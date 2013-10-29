; 引数の最初と同じパリティの引数だけを残したリストを作る
; 方針：引数のリストを順番に見て同じパリティのものだけ残す

(define nil (list))

(define (same-parity . args)
  (define parity (remainder (car args) 2))
  (define (filter items) 
	(cond ((null? items) nil)
		  ((= parity (remainder (car items) 2))
		   (cons (car items)
				 (filter (cdr items))))
		  (else (filter (cdr items)))))
  (filter args))

(print (same-parity 1 2 3 4 5 6 7))
(print (same-parity 2 3 4 5 6 7))

;; (define (same-parity . args)
;;   (filter (lambda (item)
;; 	    (= (remainder (car args) 2)
;; 	       (remainder item 2)))
;; 	    args))

;; (define (filter predicate sequence)
;;   (cond ((null? sequence) (list))
;;         ((predicate (car sequence))
;;          (cons (car sequence)
;;                (filter predicate (cdr sequence))))
;;         (else (filter predicate (cdr sequence)))))

