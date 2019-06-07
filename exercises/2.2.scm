; 問題 2.2
; 平面上の線分を表現する問題を考えよう. 各線分は一対の点: 始発点と終着点で表現されている. 
; 点を使って線分の表現を定義する構成子 make-segmentと選択子 start-segmentと end-segmentを定義せよ. 
; さらに 点は一対の数: x座標とy座標で表現することが出来る. 
; 従ってこの表現を定義する構成子 make-pointと選択子x-pointとy-pointを規定せよ.
; 最後に選択子と構成子を使い, 引数として線分をとり, 中間点(座標が両端点の座標の平均である点)を返す手続き, midpoint-segmentを定義せよ.
; その手続きを使ってみるには, 点を印字する方法が必要である.

(define (midpoint-segment seg)
  (make-point
    (/ (+ (x-point (start-segment seg)) (x-point (end-segment seg))) 2.0)
    (/ (+ (y-point (start-segment seg)) (y-point (end-segment seg))) 2.0)))

(define (make-segment p1 p2)
  (cons p1 p2))

(define (start-segment seg)
  (car seg))

(define (end-segment seg)
  (cdr seg))

(define (make-point x y)
  (cons x y))

(define (x-point p)
  (car p))

(define (y-point p)
  (cdr p))

(define (print-point p)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")")
  (newline))

(define s1 (make-segment (make-point 1 2) (make-point 3 4)))
(print-point (midpoint-segment s1))
