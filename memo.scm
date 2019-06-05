; 環境
; ====
;
; ## 関数を定義するとき
; * 関数の本体とそれへのポインターと(親)環境へのポインターをつくる
; * 環境へのポインターは、関数が定義されている環境を指す
;
; ## 関数を適用するとき
; * 新たな環境を作って、そこに仮引数を登録する
; * その環境の親は、関数にひもづいた環境
; * その環境で、実際に関数を適用する

(define (make-withdraw balance)
  (lambda (amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds")))
(define W1 (make-withdraw 100))
(W1 50)

; を評価する場合を考える。
; 最初の make-withdraw の定義で
;
; global Env  <------------------------------------+
; ----------                                       |
;                                                  |
; * make-withdraw  ------------> (関数本体) (環境へのポインター)
;                                   |
;                                   +--> params, body
; となる。次の

(define W1 (make-withdraw 100))

; の評価で以下になる。
;
; global Env  <------------------------------------+<-------------------+
; ----------                                       |                    |
;                                                  |                    |
; * make-withdraw  ------------> (関数本体) (環境へのポインター)        |
;                                   |                                   |
;                                   +--> params(balance), body(lambda)  |
; * W1 --------------------------------+                                |
;                                      |                                |
; Env 1 (by eval: (make-withdraw 100)) -------------------------------->+
; -----                             ^  |
; * balance: 100                    |  |
;           +-----------------------|--+
;           |                       |
; (関数本体)(環境へのポインター) ---+   (by eval: (lambda (amount) if.. ))
;     |                               
;     +--> params(amount), body(if)  
;     

(define W1 (make-withdraw 100))

; の評価の手順
; 1. (make-withdraw 100) を評価する
; 1.1. 環境をつくる
; 1.2. 手続きを適用する
; 1.2.1 (lambda (amount) if..) を定義する        
; 1.2.1.1 関数の本体と環境へのポインターをつくる 
; 2. その結果をグローバル環境にW1としてひもづける # いまここ

; さらに

(W1 50)

; を評価するとこうなる。

; global Env  <------------------------------------+<-------------------+
; ----------                                       |                    |
;                                                  |                    |
; * make-withdraw  ------------> (関数本体) (環境へのポインター)        |
;                                   |                                   |
;                                   +--> params(balance), body(lambda)  |
; * W1 --------------------------------+                                |
;                                      |                                |
; Env 1 (by eval: (make-withdraw 100)) -------------------------------->+
; -----                             ^  |
; * balance: 100 -> 50              |  |
;           +-----------------------|--+
;           |                       |
; (関数本体)(環境へのポインター) ---+   (by eval: (lambda (amount) if.. ))
;     |                             ^ 
;     +--> params(amount), body(if) |
;                                   |
;                                   |
; Env 2 (by eval W1 50)   --------->+
; -----
; * amount: 50
;
; ここで、(W1 50)の評価の後、Env 2 を指すポインターがないので、Env 2 は削除して構わない
; 環境はこうなる。

;
; global Env  <------------------------------------+<-------------------+
; ----------                                       |                    |
;                                                  |                    |
; * make-withdraw  ------------> (関数本体) (環境へのポインター)        |
;                                   |                                   |
;                                   +--> params(balance), body(lambda)  |
; * W1 --------------------------------+                                |
;                                      |                                |
; Env 1 (by eval: (make-withdraw 100)) -------------------------------->+
; -----                             ^  |
; * balance: 50                     |  |
;           +-----------------------|--+
;           |                       |
; (関数本体)(環境へのポインター) ---+   (by eval: (lambda (amount) if.. ))
;     |                               
;     +--> params(amount), body(if)  

; 結局、現在のbalanceはどこに確保されてるかというと、
; 1. (make-withdraw 100) の適用で作られた環境(Env1)に確保された。
; 2. グローバル環境にW1という名前で、Env1を親環境とする関数を登録したために、
;    結果的に balance が長寿命になった。
;
; フレームは、関数を適用するときに作られ、適用が終われば基本的には削除される。
; ただし、フレームが外から参照されてたら削除されない。
; -> フレームは、だれかに参照されることによって寿命が長くなる。

(define (make-withdraw balance)
  balance)
(define W1 (make-withdraw 100))

; っていうのを考えると、
; (make-withdraw 100)の適用で確かに balance がフレーム上(F1)に確保される。
; でもそれが balance を返した瞬間には、F1はだれにも参照されてないので削除される。
; W1 は結果の値としての 100 を保持するのみ。

(define (make-withdraw balance)
  (lambda () balance))
(define W1 (make-withdraw 100))

; を考えると、
; 
; 以下の違いは？

(define rand
  (define x random-init)
  (lambda ()
      (set! x (rand-update x))
      x))

(define rand
  (define x random-init)
  (set! x (rand-update x))
      x)

