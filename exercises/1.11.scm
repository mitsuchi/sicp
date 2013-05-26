; まず再帰的プロセスの場合

(define (f-r n)
  (if (<= n 3)
	  n
	  (+ (f-r (- n 1)) (f-r (- n 2)) (f-r (- n 3)))))

(print (f-r 1))
; 1
(print (f-r 2))
; 2
(print (f-r 3))
; 3
(print (f-r 4))
; 6
(print (f-r 5))
; 11
(print (f-r 6))
; 20

; 繰り返しプロセスの場合

(define (f-i a b c count)
  (if (= count 0)
	  a
	  (f-i b c (+ a b c) (- count 1))))

;aがf(n), bがf(n+1), cがf(n+2)を表す。
;(f-i 0 1 2 5)
;(f-i 1 2 3 4)
;(f-i 2 3 6 3)
;(f-i 3 6 11 2)
;(f-i 6 11 20 1)
;(f-i 11 20 32 0)

(define (f n)
  (f-i 0 1 2 n))

(print (f 1))
; 1
(print (f 2))
; 2
(print (f 3))
; 3
(print (f 4))
; 6
(print (f 5))
; 11
(print (f 6))
; 20
