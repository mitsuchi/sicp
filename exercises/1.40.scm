; 問題 1.40

; newtons-methodの手続きと一緒に
; (newtons-method (cubic a b c) 1)
; の形の式で使い, 三次式x3 + ax2 + bx + cの零点を近似する手続き cubicを定義せよ. 

; A.

(define tolerance 0.00001)

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (begin 
        (display guess)
        (newline)
        (let ((next (f guess)))
         (if (close-enough? guess next)
            next
            (try next)))))
  (try first-guess))

(define dx 0.00001)

(define (deriv g)
  (lambda (x)
    (/ (- (g (+ x dx)) (g x))
       dx)))

(define (newton-transform g)
  (lambda (x)
    (- x (/ (g x) ((deriv g) x)))))

(define (newtons-method g guess)
  (fixed-point (newton-transform g) guess))       

; (define (sqrt x)
;   (newtons-method (lambda (y) (- (square y) x))
;                   1.0))

; y = sqrt x 
; とすると y^2 = x
; つまり y^2 - x = 0
; なので (- (square y) x)
; を考えた
; (cubic a b c) の場合は
; x^3 + ax^2 + bx + c = 0
; なので

(define (cubic a b c)
  (lambda (x) (+ (* x x x) (* a x x) (* b x) c)))

(display (newtons-method (cubic 1 1 1) 1)) ; -0.9999999999997796
(newline)

; 実際の解は -1 なのでOK
