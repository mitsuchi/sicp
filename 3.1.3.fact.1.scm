(define (factorial n)
  (let ((product 1)
        (counter 1))
    (define (iter)
      (if (> counter n)
          product
          (begin (set! product (* counter product))  ; これと
                 (set! counter (+ counter 1))        ; これの順番に注意
                 (iter))))
    (iter)))

(print (factorial 1))
(print (factorial 2))
(print (factorial 3))
(print (factorial 4))
(print (factorial 5))
