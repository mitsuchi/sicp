; 問題 1.35

; (1.2.2節の)黄金比φが変換 x -> 1 + 1/xの不動点であることを示し, 
; この事実を使いfixed-point手続きにより&\phi;を計算せよ. 

(define tolerance 0.00001)

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

(display (fixed-point (lambda (x) (+ 1 (/ 1 x))) 1.0))
(newline)

; 黄金比は φ^2 = φ + 1 なので
; φ = φ + 1/φ 
; なので
; x -> 1 + 1/x の不動点が満たすべき
; x = 1 + 1/x を満たす。
