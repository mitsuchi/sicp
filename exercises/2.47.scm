; 問題 2.47
;
; フレームの構成子に候補が二つある:
;
;(define (make-frame origin edge1 edge2)
;  (list origin edge1 edge2))
;
; (define (make-frame origin edge1 edge2)
;   (cons origin (cons edge1 edge2)))
;
; 構成子のそれぞれに, フレームの実装となる適切な選択子を作れ. 

; A.
; 
; origin-frame : frame -> vect
; edge1-frame : frame -> vect
; edge2-frame : frame -> vect
; をつくればいい

(load "./common.scm")
(load "./2.46.scm")

; 1つめ

(define (make-frame1 origin edge1 edge2)
  (list origin edge1 edge2))

(define fr1 (make-frame1 (make-vect 1 2) (make-vect 1 0) (make-vect 0 1)))
(define (origin-frame1 frame) (car frame))
(define (edge1-frame1 frame) (car (cdr frame)))
(define (edge2-frame1 frame) (car (cdr (cdr frame))))

; (puts (origin-frame1 fr1))
; (puts (edge1-frame1 fr1))
; (puts (edge2-frame1 fr1))

; 2つめ

(define (make-frame2 origin edge1 edge2)
  (cons origin (cons edge1 edge2)))

(define fr2 (make-frame2 (make-vect 1 2) (make-vect 1 0) (make-vect 0 1)))
(define (origin-frame2 frame) (car frame))
(define (edge1-frame2 frame) (car (cdr frame)))
(define (edge2-frame2 frame) (cdr (cdr frame)))

; (puts (origin-frame2 fr2))
; (puts (edge1-frame2 fr2))
; (puts (edge2-frame2 fr2))