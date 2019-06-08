; 問題 2.8
; Alyssaと似たような推論をして, 二つの区間の差の計算法を書け.
; それに対応する sub-intervalという減算手続きを定義せよ. 

; 二つの区間の差は、片方の最大から片方の最小への差が一番大きく、
; 片方の最小から片方の最大への差が一番小さい。

(define (sub-interval x y)
  (make-interval (- (lower-bound x) (upper-bound y))
                 (- (upper-bound x) (lower-bound y))))
