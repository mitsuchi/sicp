(define true #t)
(define false #f)

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))
(define (start-prime-test n start-time)
  (if (prime? n)
      (report-prime (- (runtime) start-time))))
(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

(define (square n)
  (* n n))
(define (prime? n)
  (fast-prime? n (- n 1)))
(define (runtime)
  (- (time->seconds (current-time)) 1136041200))

(define (fast-prime? n a)
  (cond ((= a 0) true)
        ((fermat-test n a) (fast-prime? n (- a 1)))
        (else false)))

(define (fermat-test n a)
  (= (expmod a n n) a))

(define (expmod base exp m) ; = base^exp (mod m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square (expmod base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))       


(timed-prime-test 560)  ; not prime
(timed-prime-test 561)  ; not prime but Carmichael number
(timed-prime-test 1105) ; same as above
(timed-prime-test 1729) 
(timed-prime-test 2465)
(timed-prime-test 2821)
(timed-prime-test 6601)
(newline)
; たしかに全部素数ってことになってる。
