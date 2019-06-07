; 問題 2.3
; 平面上の長方形[rectangle]の表現を実装せよ. (ヒント: 問題2.2が使いたくなるであろう.) 
; 構成子と選択子を使い, 与えられた長方形の周囲の長さ[perimeter]と面積[area]を計算する手続きを作れ. 
; 次に長方形の違う表現を実装せよ. 同じ周囲の長さと面積の手続きが, どちらの表現でも働くように, 
; システムは良好な抽象の壁で設計されているか. 

(load "./2.2.scm")

(define (make-rectangle p1 p2)
  (cons p1 p2))

(define (upper-left-rectangle rec)
  (car rec))
  
(define (lower-right-rectangle rec)
  (cdr rec))

(define (width-rectangle rec)
  (- (x-point (lower-right-rectangle rec))
     (x-point (upper-left-rectangle rec))))

(define (height-rectangle rec)
  (- (y-point (upper-left-rectangle rec))
     (y-point (lower-right-rectangle rec))))

(define (perimeter rec)
  (+ (* 2 (width-rectangle rec))
     (* 2 (height-rectangle rec))))

(define (area rec)
  (* (width-rectangle rec)
     (height-rectangle rec)))

(define r1 (make-rectangle (make-point 3 10)
                           (make-point 12 6)))

(display "area of rectangle (3,10)-(12,6)")
(newline)
(display (area r1))
(newline)

(display "perimiter of rectangle (3,10)-(12,6)")
(newline)
(display (perimeter r1))
(newline)

(define (make-rectangle2 p1 p2)
  (cons (make-point (x-point p1)
                    (y-point p2))
        (make-point (x-point p2)
                    (y-point p1))))

(define (lower-left-rectangle rec)
  (car rec))

(define (upper-right-rectangle rec)
  (cdr rec))

(define (width-rectangle2 rec)
  (- (x-point (upper-right-rectangle rec))
     (x-point (lower-left-rectangle rec))))

(define (height-rectangle2 rec)
  (- (y-point (upper-right-rectangle rec))
     (y-point (lower-left-rectangle rec))))

(define (perimeter2 rec)
  (+ (* 2 (width-rectangle2 rec))
     (* 2 (height-rectangle2 rec))))

(define (area2 rec)
  (* (width-rectangle2 rec)
     (height-rectangle2 rec)))

(define r1 (make-rectangle2 (make-point 3 10)
                            (make-point 12 6)))

(display "version 2")
(newline)
(display "area of rectangle (3,10)-(12,6)")
(newline)
(display (area2 r1))
(newline)

(display "perimiter of rectangle (3,10)-(12,6)")
(newline)
(display (perimeter2 r1))
(newline)