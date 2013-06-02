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
        (else (find-divisor n (+ test-divisor 1)))))
(define (divides? a b)
  (= (remainder b a) 0))
(define (square n)
  (* n n))
(define (prime? n)
  (= n (smallest-divisor n)))

; (timed-prime-test 10)
; runtime がなくて動かない。
; http://sicp.g.hatena.ne.jp/n-oohira/?word=*%5Bgauche%5D
; による runtime の実装を借りてくる。

(define (runtime)
  (- (time->seconds (current-time)) 1136041200))

;(timed-prime-test 11)
;(timed-prime-test 12)
;(timed-prime-test 13)
;(newline)
; 11 *** 5.9604644775390625e-6
; 12
; 13 *** 3.0994415283203125e-6
; いい感じ

(define (search-for-primes start end)
  (if (even? start)
	  (search-for-primes-for-odd (+ 1 start) end)
	  (search-for-primes-for-odd start end)))

(define (search-for-primes-for-odd start end)
  (if (< start end)
	  (begin
		(timed-prime-test start)
		(search-for-primes-for-odd (+ start 2) end))))

(search-for-primes 1000 1050)
;1009 *** 1.2159347534179687e-5
;1011
;1013 *** 5.698204040527344e-5
;1015
;1017
;1019 *** 1.1920928955078125e-5
;
; 1013だけ遅いと思ったけどタイミングによるようだ。
; 2回目はそろった。
; 
;1009 *** 1.1920928955078125e-5
;1011
;1013 *** 1.1920928955078125e-5
;1015
;1017
;1019 *** 1.0967254638671875e-5

(search-for-primes 10000 10050)
;10007 *** 3.504753112792969e-5
;10009 *** 3.504753112792969e-5
;10011
;10013
;10015
;10017
;10019
;10021
;10023
;10025
;10027
;10029
;10031
;10033
;10035
;10037 *** 3.504753112792969e-5
; 
; root 10 = 3.16 くらいなので、3.50/1.1 = 3.18 だから、おおむね
; root 10倍になってる！

(search-for-primes 100000 100050)
;100003 *** 1.0800361633300781e-4
;100005
;100007
;100009
;100011
;100013
;100015
;100017
;100019 *** 1.0800361633300781e-4
;100021
;100023
;100025
;100027
;100029
;100031
;100033
;100035
;100037
;100039
;100041
;100043 *** 1.0800361633300781e-4 
;
; gosh> (/ 11.08 3.5)
; 3.165714285714286
; だからほぼ root 10
;
; 実測値はオーダーの計算どおりといえる。

(search-for-primes 1000000 1000050)
;1000003 *** 3.440380096435547e-4
;1000005
;1000007
;1000009
;1000011
;1000013
;1000015
;1000017
;1000019
;1000021
;1000023
;1000025
;1000027
;1000029
;1000031
;1000033 *** 3.399848937988281e-4
;1000035
;1000037 *** 3.387928009033203e-4
