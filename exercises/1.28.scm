(use srfi-27)

(define (random n)
  (random-integer n))

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
  (fast-prime? n 10))
(define (runtime)
  (- (time->seconds (current-time)) 1136041200))

(define (fast-prime? n times)
  (cond ((= times 0) true)
        ((miller-rabin-test n) (fast-prime? n (- times 1)))
        (else false)))

(define (miller-rabin-test n)
  (define (try-it a)
    (not (= (expmod a (- n 1) n) 0)))
  (if (even? n)
	  false
	  (try-it (+ 1 (random (- n 1))))))

(define (expmod base exp m) ; = base^exp (mod m)
  (cond ((= exp 0) 1)
        ((even? exp)
		 (let* ((a (expmod base (/ exp 2) m))
				(remainder-of-square (remainder (square a) m)))
		   (if (and (= remainder-of-square 1)
					(not (= a 1))
					(not (= a (- m 1))))
			   0
			   remainder-of-square)))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))       

; 2乗してる場所で、非自明な2乗根かどうかをチェックして、
; そうじゃなければヒントどうり0を返してる。
; 1回テストにパスするたびに素数じゃない確率が1/2になるので
; 10回パスしたら1/1024、なのでほぼ素数。

(timed-prime-test 560)  ; not prime
(timed-prime-test 561)  ; not prime but Carmichael number
(timed-prime-test 1105) ; same as above
(timed-prime-test 1729) 
(timed-prime-test 2465)
(timed-prime-test 2821)
(timed-prime-test 6601)
(newline)
; 素数に判定されない！
(timed-prime-test 6607)
(newline)
; 素数だ！
