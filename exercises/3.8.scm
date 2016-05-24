; (+ (f 0) (f 1))
; を、+ の引数について左から順番に評価すると 0 になり、
; を、+ の引数について右から順番に評価すると 1 になる、
; そんな手続き f を作りなさい

; 方針
; ----
;
; 状態が必須。最初の引数が0ならあとはずっと0を返し、
; 最初の引数が1ならずっと1/2を返すようにする。

(define nil '())
(define retval nil)
(define (f x)
  (if (null? retval)
      (if (eq? x 0)
	  (set! retval 0)
	  (set! retval (/ 1 2))))
  retval)

(define r0 (f 0))
(define r1 (f 1))
(print (+ r0 r1))
