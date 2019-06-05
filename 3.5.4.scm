(load "./stream.scm")

; 3.5.4 ストリームと遅延評価
; -------------------------
;
; y' = f(y) を解く。
;
; 回路で表すと図のようになる。
; そのまま式に起こすとこう。

(define (solve f y0 dt)
  (define y (integral dy y0 dt))
  (define dy (stream-map f y))
  y)
 
; でも integral の引数をまず評価するために dy を評価する -> stream-map の第二引数の y を評価
; となって無限ループで止まらない。
; -> integral の第一引数(被積分ストリーム)を遅延評価にすればいい

; もともとはこう。

(define (integral integrand initial-value dt)
  (define int
    (cons-stream initial-value
		 (add-streams (scale-stream integrand dt)
			      int)))
  int)

; こう変える

(define (integral delayed-integrand initial-value dt)
  (define int
    (cons-stream initial-value
                 (let ((integrand (force delayed-integrand)))
                   (add-streams (scale-stream integrand dt)
                                int))))
  int)

; solve はこうなる

(define (solve f y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (stream-map f y))
  y)

; y(0)=1をその初期値とする微分方程式dy/dt=yの解のy=1での値を計算し, e ≈ 2.718の近似を得ることで, solve手続きが実証出来る:
;(print (stream-ref (solve (lambda (y) y) 1 0.001) 1000))

; 問題 3.77
; 問題 3.78
; 問題 3.79
; 問題 3.80

; 正規順序の評価
; --------------

; delay 便利だけど
; (define (integral delayed-integrand initial-value dt)

; みたいに個別に引数を delay させないといけないのはめんどくさい。
; 手続きの引数の評価を正規順序にすれば遅延評価になってOK。4.2節でやる。
; でも遅延評価と代入を混ぜるとカオスになる。問題3.51とかでやったように。
; どうやって混ぜるかはまだ研究中。

; ちなみに問題3.51

(define (show x)
  (display-line x)
  x)

; で以下を実行するとどうなる？

;(define x (stream-map show (stream-enumerate-interval 0 10)))
;(stream-ref x 5)
;(stream-ref x 7)
