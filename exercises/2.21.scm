; リストの各要素を2乗する

(define (square x) (* x x))
(define nil (list))

; consを使ったもの
(define (square-list items)
  (if (null? items)
      nil
      (cons (square (car items)) (square-list (cdr items)) )))

(print (square-list (list 1 2 3 4)))

; mapを使ったもの
;; (define (square-list items)
;;  (map square items))

;; (define (square-list items)
;;  (map (lambda (x) (* x x)) items))

;; (print (square-list (list 1 2 3 4)))
