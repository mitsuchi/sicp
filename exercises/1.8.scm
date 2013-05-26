(define (improve guess x)
  (/ (+ (/ x (* guess guess)) (* 2 guess)) 3))

(define (good-enough? old-guess new-guess)
  (< (abs (/ (- old-guess new-guess) old-guess)) 0.00001))

(define (cbrt-iter guess x)
  (if (good-enough? guess (improve guess x))
      guess
      (cbrt-iter (improve guess x) x)))

(define (cbrt x)
  (cbrt-iter 1.0 x))

(print (cbrt 27))

; improve を数式に合わせて
; (x/y^2 + 2*y)/3 
; としただけ。

