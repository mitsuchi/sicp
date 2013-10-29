;Implement Monte Carlo integration as a procedure estimate-integral that takes as arguments a predicate P, upper and lower bounds x1, x2, y1, and y2 for the rectangle, and the number of trials to perform in order to produce the estimate. Your procedure should use the same monte-carlo procedure that was used above to estimate . Use your estimate-integral to produce an estimate of  by measuring the area of a unit circle.

; via http://masimaro.net/blog/2007/01/gaucherandom_linux.html
;(define (random x)
;  (mod (sys-random) x))
(define (random x)
  (* x (/ (mod (sys-random) 111111111.0) 111111111.0)))

(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))))

(define (monte-carlo trials experiment) ; trials = 試行回数, experiment = 試行して結果を返す手続き
  (define (iter trials-remaining trials-passed)
    (cond ((= trials-remaining 0)
           (/ trials-passed trials))
          ((experiment)
           (iter (- trials-remaining 1) (+ trials-passed 1)))
          (else
           (iter (- trials-remaining 1) trials-passed))))
  (iter trials 0))

(define (estimate-integral p x1 x2 y1 y2 num-trials)
  (* (* (- x2 x1) (- y2 y1)) (monte-carlo num-trials p)))

(define (is-random-point-in-unit-circle?)
  (define x (random-in-range -1.0 1.0))
  (define y (random-in-range -1.0 1.0))
  (define d2 (+ (* x x) (* y y)))
  (< d2 1))

(print (estimate-integral is-random-point-in-unit-circle? -1.0 1.0 -1.0 1.0 100000))
