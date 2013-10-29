(define random-init 1)

; via http://www001.upp.so-net.ne.jp/isaku/rand.html
;(define (rand-update x)
;  (mod (+ (* 1103515245 x) 12345) 4294967296))
(define (rand-update x)
  (mod (+ (* 3103515249 x) 12345) 2147483))

(define rand
  (let ((x random-init))
    (lambda ()
      (set! x (rand-update x))
      x)))

(define (estimate-pi trials)
  (sqrt (/ 6 (monte-carlo trials cesaro-test))))
(define (cesaro-test)
   (= (gcd (rand) (rand)) 1))
(define (monte-carlo trials experiment) ; trials = 試行回数, experiment = 試行して結果を返す手続き
  (define (iter trials-remaining trials-passed)
    (cond ((= trials-remaining 0)
           (/ trials-passed trials))
          ((experiment)
           (iter (- trials-remaining 1) (+ trials-passed 1)))
          (else
           (iter (- trials-remaining 1) trials-passed))))
  (iter trials 0))

(print (estimate-pi 100000))
