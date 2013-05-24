(define (square a)
  (* a a))

(define (sum-of-squares-larger-two a b c)
  (cond ((= (min a b c) a)
		 (+ (square b) (square c)))
		((= (min a b c) b)
		 (+ (square a) (square c)))
		(else
		 (+ (square a) (square b)))))

; 大きい2つ = 最小じゃないやつ。

(sum-of-squares-larger-two 1 2 3)
; gosh> 13
(sum-of-squares-larger-two 5 4 3)
; gosh> 41
