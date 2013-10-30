(define rand-init 1298407356)
(define (rand-update x)
  (mod (+ (* 3103515249 x) 12345) 2147483))

(define rand
  (begin
    (define current-rand rand-init)
    (lambda (op)
      (cond ((eq? op 'generate)
	     (set! current-rand (rand-update current-rand))
	     current-rand)
	    ((eq? op 'reset)
	     (lambda (new-value)
	       (set! current-rand new-value)))))))

(print (rand 'generate))
(print (rand 'generate))
(print (rand 'generate))
(print "-- reset --")
((rand 'reset) rand-init)
(print (rand 'generate))
(print (rand 'generate))
(print (rand 'generate))
