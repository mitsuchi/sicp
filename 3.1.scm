; 3.1 代入と局所状態
; ==================
;
; 世界は状態を持ったオブジェクトの集合に見える。
; 状態を持つというのは過去に影響されるということ。
; 状態は状態変数で表せる。
;
; オブジェクトはたいてい互いに影響しあう。
; 強く影響しあうもの同士をあつめてサブシステムにして、
; 他のサブシステムとはあんまりやりとりしないようにすると都合がいい。
;
; 状態は時間とともに変化するから、それをプログラムで実現しないといけない。
; そのために、代入という操作が必要になる。
;
; 3.1.1 局所状態変数
; ------------------
;
; 時間で状態が変わるものの例として銀行口座を考える。
; (withdraw money)という手続きは、口座にまだお金があれば残高からmoney
; を引いて、その結果を返す。お金が足りなければエラーを返す。

(withdraw 25)
75
(withdraw 25)
50
(withdraw 60)
"Insufficient funds"
(withdraw 15)
35

; (withdraw 25)が2回呼ばれてるけど、結果が違うことに注意。
; いままでは手続きは数学的な関数と見なすことができた、つまり
; 同じ引数なら何回呼んでも同じ結果。
;
; withdraw の実装のためには、たとえば残高を大域変数にすればいい。

(define balance 100) ; balanceが口座残高

(define (withdraw amount)
  (if (>= balance amount)
      (begin (set! balance (- balance amount))
             balance)
      "Insufficient funds"))

; balance の引き算は

(set! balance (- balance amount))

; set! は special form

(set! <name> <new-value>)

; nameな名前の変数の値が new-value に置き換わる。
; begin も special form

(begin <exp1> <exp2> ... <expk>)

; で順番に評価する。全体の値は最後の expk の値。
; さっきのだと balance がグローバルでよくない。こうするといい。

(define new-withdraw
  (let ((balance 100))
    (lambda (amount)
      (if (>= balance amount)
          (begin (set! balance (- balance amount))
                 balance)
          "Insufficient funds"))))

; balance がローカルになった。
; set!と局所変数の組み合わせは、状態のあるオブジェクトを表すのによく使う。
; ただし計算の置き換えモデルが使えなくなるので、後でやる新しい計算モデルが必要。

(define (make-withdraw balance)
  (lambda (amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds")))

; とやると口座が複数作れる。

(define W1 (make-withdraw 100))
(define W2 (make-withdraw 100))
(W1 50)
50
(W2 70)
30
(W2 40)
"Insufficient funds"
(W1 40)
10

; W1とW2は完全に独立してることに注意。
; 引き出しだけじゃなくて deposit で振込もできるようにする。

(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch m)
    (cond ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          (else (error "Unknown request -- MAKE-ACCOUNT"
                       m))))
  dispatch)

; 全体の値は dispatch で、まさに2.4.3章のメッセージパッシングスタイル。
; 使い方。

(define acc (make-account 100))
((acc 'withdraw) 50)
50
((acc 'withdraw) 60)
"Insufficient funds"
((acc 'deposit) 40)
90
((acc 'withdraw) 60)
30

(define acc2 (make-account 100))
; とすると acc と acc2 は完全に独立なことに注意。
;
; ## ex 3.1
; ## ex 3.2
; 