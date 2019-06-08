; 問題 2.7
; 区間の抽象化の実装を規定しなかったので, Alyssaのプログラムは不完全である. 区間構成子は:
(define (make-interval a b) (cons a b))
;実装を完成させるため, 選択子 upper-boundと lower-boundを定義せよ.  

(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
                 (+ (upper-bound x) (upper-bound y))))

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

(define (div-interval x y)
  (mul-interval x 
                (make-interval (/ 1.0 (upper-bound y))
                               (/ 1.0 (lower-bound y)))))

(define (upper-bound x)
  (cdr x))

(define (lower-bound x)
  (car x))

