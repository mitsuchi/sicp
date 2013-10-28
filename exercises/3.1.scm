; (define A (make-accumulator 5))
;
; (A 10)
; 15
; (A 10)
; 25
; 
; みたいになる make-accumulator を作りなさい。

(define (make-accumulator total)
  (define (adder dx)
    (begin
      (set! total (+ total dx))
      total))
  adder)

(define A (make-accumulator 5))
(print (A 10))
(print (A 10))

;(define (make-accumulator2 total)
;  (lambda (dx)
;    (begin
;      (set! total (+ total dx))
;      total)))
;
;(define B (make-accumulator2 5))
;(print (B 10))
;(print (B 10))
;
;でもいいけど、adderみたいに名前をつけると意味が分かりやすい。