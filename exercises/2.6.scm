;Exercise 2.6.  In case representing pairs as procedures wasn't mind-boggling enough, consider that, in a language that can manipulate procedures, we can get by without numbers (at least insofar as nonnegative integers are concerned) by implementing 0 and the operation of adding 1 as

(define zero (lambda (f) (lambda (x) x)))

(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))

;This representation is known as Church numerals, after its inventor, Alonzo Church, the logician who invented the  calculus.

;Define one and two directly (not in terms of zero and add-1). (Hint: Use substitution to evaluate (add-1 zero)). Give a direct definition of the addition procedure + (not in terms of repeated application of add-1).

;zero
;\f -> (\x -> x)

;add-1 n
;\f -> (\x -> (f ((n f) x)))

; one =>
(define one (add-1 zero))
;(lambda (f) (lambda (x) (f ((zero f) x))))
;                            --------
;(lambda (f) (lambda (x) (f ((lambda (x) x) x))))
;                           -------------------
;(lambda (f) (lambda (x) (f x)))

; two =>
(define two (add-1 one))
;(lambda (f) (lambda (x) (f ((one f) x)))))
;                            -------
;(lambda (f) (lambda (x) (f (  ((lambda (f) (lambda (x) (f x))) f)   x))))
;                              -----------------------------------
;(lambda (f) (lambda (x) (f ((lambda (x) (f x)) x))))
;                           ----------------------
;(lambda (f) (lambda (x) (f (f x))))

; n は f を与えられたらそれを任意の x に n 回適用するような手続き
; なので n + m は、f が与えられたらそれを任意の x に n+m回適用するような手続き

(define (+ n m)
  (lambda (f) (lambda (x) ((m f) ((n f) x)))))

(define three (+ one two))
(define six (+ three three))

(display 
  ((six (lambda (x) (* x 2))) 1)) ; 2^6 = 64
(newline)