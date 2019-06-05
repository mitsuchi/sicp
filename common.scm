(define true #t)
(define false #f)

(define random-max 2147483647)
(define (rand-update x)
  (modulo (+ (* x 1103515245) 12345) random-max))

(define random-init 11111)
