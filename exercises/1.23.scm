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

(define (smallest-divisor n)
  (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (next test-divisor)))))
(define (next cand)
  (if (= cand 2)
	  3
	  (+ cand 2)))
(define (divides? a b)
  (= (remainder b a) 0))
(define (square n)
  (* n n))
(define (prime? n)
  (= n (smallest-divisor n)))
(define (runtime)
  (- (time->seconds (current-time)) 1136041200))


(timed-prime-test 1009)
(timed-prime-test 1013)
(timed-prime-test 1019)
(timed-prime-test 10007)
(timed-prime-test 10009)
(timed-prime-test 10037)
(timed-prime-test 100003)
(timed-prime-test 100019)
(timed-prime-test 100043)
(timed-prime-test 1000003)
(timed-prime-test 1000033)
(timed-prime-test 1000037)
(newline)

;1009 *** 1.2874603271484375e-5
;1013 *** 8.821487426757812e-6
;1019 *** 7.867813110351562e-6
;10007 *** 2.3126602172851562e-5
;10009 *** 2.288818359375e-5
;10037 *** 2.288818359375e-5
;100003 *** 6.699562072753906e-5
;100019 *** 6.890296936035156e-5
;100043 *** 6.794929504394531e-5
;1000003 *** 2.110004425048828e-4
;1000033 *** 2.1004676818847656e-4
;1000037 *** 2.1004676818847656e-4
; 
; さっきと比べるとせいぜい60%くらいになっただけだ。
; まあ十分ともいえるけど。
;
; 50%にならない理由は
; 足し算が手続きの呼び出しに変わったので、手続きの呼び出し
; にかかわる部分の手間が増えたからと思う。
; nに対するもとの実行時間を x(n) とすると、nextにしたバージョンの
; 実行時間は x(n) / 2 + a みたいな感じになりそうなので、
; 比率は 1/2 + a/x(n) 、つまり n が大きくなるとだんだん 1/2 に
; 収束しそう。

