; 問題 3.82

; monte-carlo積分に関する問題3.5をストリームを使って再試行せよ. estimate-integralのストリーム版は, 試行の回数を示す引数はいらない. その代り, 次々と多くの試行に基づいた見積りのストリームを生成するものとする.

(load "./stream.scm")

(define (monte-carlo experiment-stream passed failed)
  (define (next passed failed)
    (cons-stream
     (/ (* 1.0 passed) (+ passed failed)) ; * 1.0 して実数にした
     (monte-carlo
      (stream-cdr experiment-stream) passed failed)))
  (if (stream-car experiment-stream)
      (next (+ passed 1) failed)
      (next passed (+ failed 1))))

(define (map-successive-pairs f s)
  (cons-stream
   (f (stream-car s) (stream-car (stream-cdr s)))
   (map-successive-pairs f (stream-cdr (stream-cdr s)))))

(define random-numbers
  (cons-stream random-init
               (stream-map rand-update random-numbers)))

(define random-numbers-0-to-1 ; 0から1までの実数のランダム列にする
  (stream-map (lambda (x) (/ (modulo x 12345) 12345.0)) random-numbers))

(define (range x1 x2) ; 与えられた数をx1とx2の間に納める
  (lambda (x)
    (+ x1 (* x (- x2 x1)))))

(define (estimate-integral p x1 y1 x2 y2)
  (define random-xs (stream-map (range x1 x2) random-numbers-0-to-1)) ; x1 から x2までのランダム列
  (define random-ys (stream-map (range y1 y2) (stream-cdr random-numbers-0-to-1))) ; ちょっとずらした
;  (define random-ys (stream-map (range y1 y2) random-numbers-0-to-1)) ; ちょっとずらした
  (define random-xys (interleave random-xs random-ys))
  (define experiment-stream
    (map-successive-pairs (lambda (x y) (p x y)) random-xys))
  (scale-stream (monte-carlo experiment-stream 0 0) (* (- x2 x1) (- y2 y1))))

; !! ふつうに rand-update つかって結果だけストリームでもいいじゃん

; (-1,-1)から(1,1)までの領域と、(0,0)を中心とする半径1の円(=面積はPi)で考える。
(define estimate-stream
  (estimate-integral (lambda (x y)
		       (< (+ (* x x) (* y y)) 1))
		     -1 -1 1 1))

;(display-stream (stream-take 1000 estimate-stream))

;(define pi314 (cons-stream 3.14 pi314))
;(display-stream (stream-take 1000 (stream-map (lambda (a b) (list a b)) estimate-stream pi314)))
; gosh exercises/3.82.scm | sed -e 's/[()]//g' | plot

(display-stream (stream-take 1000 estimate-stream))
; gosh exercises/3.82.scm | sed -e 's/\([0-9].[0-9]\)[0-9]*/\1/' | ruby pass-to-r.rb
