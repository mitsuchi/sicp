; べき乗の場合と同じように考えると
;
; b*n = (b*(n/2))*2  ; b が偶数
; b*n = b + b*(n-1)  ; b が奇数
;
; だから

(define (fast-multi b n)
  (cond ((= n 0) 0)
        ((even? n) (double (fast-multi b (halve n))))
        (else (+ b (fast-multi b (- n 1))))))

(define (even? n)
  (= (remainder n 2) 0))

(define (double n)
  (* n 2))

(define (halve n)
  (/ n 2))

(print (fast-multi 7 8))
; 56
(print (fast-multi 100 7))
; 700
