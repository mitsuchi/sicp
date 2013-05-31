; fast-expt-iter を fei と書くことにして
; (fei b n 1)
; から計算をはじめて
; (fei x y b^n)
; にたどり着けばいい。ただし x^y = 1 つまり y = 0
;
; ヒントは
; b^n = (b^(n/2))^2 = (b^2)^(n/2)
; でこれはつまり
;
; (fei b 2m a)    ; a * b^(2m)
; は
; (fei b^2 m a)   ; a * (b^2)^m
; と等しいってことだ。
;
; (fei b 2m+1 a)  ; a * b^(2m+1)
; は
; (fei b 2m ab)   ; ab * b^2m
; と等しい。
;
; 最後は
; (fei b 0 a)
; なら a を返す。
;
; つまるところ

(define (fast-expt b n)
  (fei b n 1))

(define (fei b n a)
  (cond ((= n 0) a)
		((even? n) (fei (* b b) (/ n 2) a))
		(else (fei b (- n 1) (* a b)))))

(define (even? n)
  (= (remainder n 2) 0))

(print (fast-expt 2 10))
; 1024
(print (fast-expt 3 6))
; 729

; 2^10 だったら
; (fei 2 10 1)
; (fei 4 5 1)
; (fei 4 4 4)
; (fei 16 2 4)
; (fei 256 1 4)
; (fei 256 0 1024)
; 1024
