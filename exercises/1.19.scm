; 1.
; T^2(p,q)( a, b)
; = T(p,q)( bq + aq + ap, bp + aq )
; = ( (bp + aq)q + (bq + aq + ap)q + (bq + aq + ap)p,
;     (bp + aq)p + (bq + aq + ap)q )
; = ( bpq + aqq + bqq + aqq + apq + bpq + apq + app,
;     bpp + apq + bqq + aqq + apq )
; = ( 2bpq + bqq + 2aqq + 2apq + app,
;     bpp + bqq + 2apq + aqq )
; = ( b(2pq+qq) + a(2pq+qq) + a(pp+qq),
;     b(pp+qq)  + a(2pq+qq) )
; なので P = pp + qq, Q = 2pq + qq とすると
; = ( bQ + aQ + aP, bP + aQ )
; = T(P,Q)
;
; 2.

(define (fib n)
  (fib-iter 1 0 0 1 n))
(define (fib-iter a b p q count)
  (cond ((= count 0) b)
        ((even? count)
         (fib-iter a
                   b
                   (+ (* p p) (* q q))        ; compute p'
                   (+ (* 2 p q) (* q q))      ; compute q'
                   (/ count 2)))
        (else (fib-iter (+ (* b q) (* a q) (* a p))
                        (+ (* b p) (* a q))
                        p
                        q
                        (- count 1)))))


(print (fib 10))
; 55

(print (fib 100))
; 354224848179261915075

