; 問題 2.10
; 
; 経験あるシステムプログラマ, Ben BitdiddleはAlyssaの肩越しに眺め,
; 零を跨る区間で割った時, どうなるかよく分らないと評した.
; この状態が生じたことを調べ, 起きたらエラーとするようにAlyssaのプログラムを修正せよ. 

(load "./2.7.scm")
(define (div-interval2 x y)
  (if 
    (and (< (lower-bound y) 0) (< 0 (upper-bound y)))
    (error "division by interval including 0")
    (mul-interval x 
                (make-interval (/ 1.0 (upper-bound y))
                               (/ 1.0 (lower-bound y))))))

(define a (make-interval 2 4))
(define b (make-interval -1 1))

(display (div-interval2 a b))
(newline)
