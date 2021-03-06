(define (A x y)
  (cond ((= y 0) 0)
        ((= x 0) (* 2 y))
        ((= y 1) 2)
        (else (A (- x 1)
                 (A x (- y 1))))))

(print (A 1 10))
; 1024

(print (A 2 4))
; 65536

(print (A 3 3))
; 65536

; f は
(print (A 0 0)) ; 0
(print (A 0 1)) ; 2
(print (A 0 2)) ; 4
(print (A 0 3)) ; 6
(print (A 0 4)) ; 8
; なので 2n

; g は
(print (A 1 0)) ; 0  = 0
(print (A 1 1)) ; 2  = 2^1
(print (A 1 2)) ; 4  = 2^2
(print (A 1 3)) ; 8  = 2^3
(print (A 1 4)) ; 16 = 2^4
; なので n=0のとき0、n>=1のとき2^n

; hは
(print (A 2 0)) ; 0     = 0    = 0       
(print (A 2 1)) ; 2     = 2^1  = 2       
(print (A 2 2)) ; 4     = 2^2  = 2^2     
(print (A 2 3)) ; 16    = 2^4  = 2^2^2   
(print (A 2 4)) ; 65536 = 2^16 = 2^2^2^2 
; なので
; n=0 のとき 0、n=1のとき2、n>=2 のとき 2^2^..^2で2がn個な式

