(use srfi-27)

(define (random n)
  (random-integer n))

(define true #t)

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

(define (divides? a b)
  (= (remainder b a) 0))
(define (square n)
  (* n n))
(define (prime? n)
  (fast-prime? n 10))
(define (runtime)
  (- (time->seconds (current-time)) 1136041200))

(define (fast-prime? n times)
  (cond ((= times 0) true)
        ((fermat-test n) (fast-prime? n (- times 1)))
        (else false)))

(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))

(define (expmod base exp m) ; = base^exp (mod m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square (expmod base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))       

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

; random が動かんかった...
; いろいろ調べると
; (use srfi-27)
; で
; (random-integer n)
; が使えるらしいのでそれを利用。
; 結果は
;1009 *** 8.916854858398437e-5
;1013 *** 6.508827209472656e-5
;1019 *** 7.581710815429687e-5
;10007 *** 8.893013000488281e-5
;10009 *** 8.606910705566406e-5
;10037 *** 8.797645568847656e-5
;100003 *** 1.049041748046875e-4
;100019 *** 1.02996826171875e-4
;100043 *** 1.02996826171875e-4
;1000003 *** 1.2302398681640625e-4
;1000033 *** 1.1801719665527344e-4
;1000037 *** 1.239776611328125e-4
;
; 1000 にくらべて 1000000 は桁が2倍なので
; 実行時間も2倍になってほしい。
; でも実際は 1.6倍くらいだ。
;
; その差の理由は？
; random のコストがO(1)なら差はないはず。
; そうじゃないからだろうけど具体的なコストが分からない。


