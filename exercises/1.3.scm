(define (sum-of-squares-larger-two a b c)
  (cond ((= (min a b c) a)
		 (sum-of-squares b c))
		((= (min a b c) b)
		 (sum-of-squares a c))
		(else
		 (sum-of-squares a b))))

(define (square a)
  (* a a))

(define (sum-of-squares a b)
  (+ (* a a) (* b b)))

; 大きい2つ = 最小じゃないやつ。

(print (sum-of-squares-larger-two 1 2 3))
; 13
(print (sum-of-squares-larger-two 5 4 3))
; 41
