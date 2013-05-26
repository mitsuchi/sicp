(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
                 x)))

(define (improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (square x)
  (* x x))

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

(define (my-sqrt x)
  (sqrt-iter 1.0 x))

; 小さすぎてだめな例
; 閾値よりもちいさいとだめ。

(define small 0.00001)
(print "small")
(print small)
(print (my-sqrt small))
(print (sqrt small))

; 大きすぎてだめな例

(define big 10000000000000)
(print "big")
(print big)
;(print (my-sqrt big))
;止まらない
;floatの精度が閾値より大きくなるから
(print (sqrt big))

; 改善案を実装してみる。
; たとえば、新推測値が旧推測値と0.01%しか違わないかどうか

(define (new-good-enough? old-guess new-guess)
  (< (abs (/ (- old-guess new-guess) old-guess)) 0.00001))

(define (new-sqrt-iter guess x)
  (if (new-good-enough? guess (improve guess x))
      guess
      (new-sqrt-iter (improve guess x) x)))

(define (new-sqrt x)
  (new-sqrt-iter 1.0 x))

(print "small")
(print small)
(print (new-sqrt small))
(print (sqrt small))

; 小さい方の精度があがった

(print "big")
(print big)
(print (new-sqrt big))
(print (sqrt big))

; 大きい方も止まるようになった
