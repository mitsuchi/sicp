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
; ## ex 3.3
; ## ex 3.4
;
; 3.1.2 代入を導入する利点
; ------------------------
;
; 代入を導入するとやっかいな点もあるけど、便利なことも多い。
; 例えば乱数。正確には擬似乱数。

x2 = (rand-update x1)
x3 = (rand-update x2)

; みたいに、rand-update が次の擬似乱数を返すことを考える。

(define rand
  (let ((x random-init))
    (lambda ()
      (set! x (rand-update x))
      x)))

; として「今の」乱数xをローカルに持つと便利。
; そうじゃないと、乱数を使う場所それぞれで管理の必要があって大変。
; 例えばモンテカルロ・シミュレーションを考える。
;
; ランダムに選んだ2つの整数が互いに素な確率は 6 / Pi^2
; なので sqrt(n回目の試行までの確率/6) は Pi に近づく

(define (estimate-pi trials)
  (sqrt (/ 6 (monte-carlo trials cesaro-test))))
(define (cesaro-test)
   (= (gcd (rand) (rand)) 1))
(define (monte-carlo trials experiment) ; trials = 試行回数, experiment = 試行して結果を返す手続き
  (define (iter trials-remaining trials-passed)
    (cond ((= trials-remaining 0)
           (/ trials-passed trials))
          ((experiment)
           (iter (- trials-remaining 1) (+ trials-passed 1)))
          (else
           (iter (- trials-remaining 1) trials-passed))))
  (iter trials 0))

; 上のようにすると、monte-carlo が何してるかわかりやすい。
; 代入を使わないと、「今の乱数」があちこちに漏れだしてモジュール性が失われる。

(define (estimate-pi trials)
  (sqrt (/ 6 (random-gcd-test trials random-init))))
(define (random-gcd-test trials initial-x)
  (define (iter trials-remaining trials-passed x)
    (let ((x1 (rand-update x)))
      (let ((x2 (rand-update x1)))
        (cond ((= trials-remaining 0)   
               (/ trials-passed trials))
              ((= (gcd x1 x2) 1)
               (iter (- trials-remaining 1)
                     (+ trials-passed 1)
                     x2))
              (else
               (iter (- trials-remaining 1)
                     trials-passed
                     x2))))))
  (iter trials 0 initial-x))

; ここでは乱数を2つ使うから x1 と x2があるけど、3個使うかもしれない。
; もっと面倒になる。
;
; 内部状態を局所変数に、時間による変化を代入によって表すといい感じ。
; ただしやっかいな点もあって後で述べる。