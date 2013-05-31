; 問題1.17の ^2 を double に、* を + に、1(*の単位元)を0(+の単位元)に
; まんま置き換えてやればいい。

(define (fast-multi b n)
  (fmi b n 0))

(define (fmi b n a)
  (cond ((= n 0) a)
		((even? n) (fmi (double b) (halve n) a))
		(else (fmi b (- n 1) (+ a b)))))

(define (even? n)
  (= (remainder n 2) 0))

(define (double n)
  (* n 2))

(define (halve n)
  (/ n 2))

(print (fast-multi 7 8))
; 56
(print (fast-multi 100 7))
; 700
