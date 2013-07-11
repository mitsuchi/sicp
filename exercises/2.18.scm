; リストを逆順にしたものを返す
; 方針：前から順番に見て、別のリストの先頭にくっつけていく

(define (reverse items)		       
  (define (reverse-iter items answer)
    (if (null? items)			
	answer
	(reverse-iter (cdr items) (cons (car items) answer))))
  (reverse-iter items (list)))

(print (reverse (list 1 2 3 4 5)))     

;; 
;; 

;items  
;answer 5 4 3 2 1 

;; 別の方針：一番前を別のリストの最後に回す
;; (define (reverse items)
;;  (if (null? items)
;;      nil
;;      (append (reverse (cdr items)) (list (car items)))))

;1 2 3 4 5
;|2 3 4 5| 1 
;|3 4 5| 2 1
;|4 5| 3 2 1
;|5| 4 3 2 1
;|| 5 4 3 2 1
;5 4 3 2 1

;(print (reverse (list 1 2 3 4 5)))
