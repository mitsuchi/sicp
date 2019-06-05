; 問題 3.79

; 問題3.78のsolve-2nd手続きを一般化し, 一般的な二階微分方程式
;
; d2y/dt2=f(dy/dt, y)
;
; を解くのに使えるようにせよ. 

(load "./stream.scm")

(define (solve-2nd f dt y0 dy0)
  (define y (integral (delay dy) y0 dt))
  (define dy (integral (delay ddy) dy0 dt))
  (define ddy (stream-map f dy y))
  y)

(define f (lambda (dy y) (- dy y)))

;(display-stream (stream-take 1000 (solve-2nd f 0.01 3 4)))
(display-stream (stream-take 10000 (solve-2nd f 0.01 0 1)))
