; a. (sine 12.15) を評価すると p が何回適用されるか？
(define counter 0)
(define (cube x) (* x x x))
(define (p x) (set! counter (+ counter 1)) (- (* 3 x) (* 4 (cube x))))
(define (sine angle)
  (sine-with-depth angle 0))
(define (sine-with-depth angle depth)
   (if (not (> (abs angle) 0.1))
	   (begin
		 (print "depth = " depth)
		 angle
		 )
       (p (sine-with-depth (/ angle 3.0) (+ 1 depth)))))

(define (print-counter-and-init)
  (print counter)
  (set! counter 0))

(sine 12.15)
(print-counter-and-init)
; depth = 5
; 5
; 答えは5回
;
; b. (sine a)のステップ数と領域量のオーダーは？

(sine (* 3 12.15))
(print-counter-and-init)
; depth = 6
; 6
(sine (* 9 12.15))
(print-counter-and-init)
; depth = 7
; 7
(sine (* 27 12.15))
(print-counter-and-init)
; depth = 8
; 8
;
; aが3倍になるとステップ数は1ずつ増えるのでステップ数は O(log n)
; depthも同様なので O(log n)
;
; 再帰が1段深くなるたびに問題のサイズが 1/3 になり、
; フィボナッチみたいな再計算が必要ないから、たしかにそうなる。
