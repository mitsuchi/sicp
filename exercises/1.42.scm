; 問題 1.42

; fとgを一引数の関数とする. gの後のfの合成関数 (composition)は関数x  f(g(x))と定義する.
; 合成関数を実装する手続きcomposeを定義せよ. 例えばincが引数に1を足す手続きとすれば
; ((compose square inc) 6)
; 49

; A.

(define (compose f g)
  (lambda (x) (f (g x))))

(define (inc x) (+ x 1))
(define (square x) (* x x))

(display ((compose square inc) 6)) ; 49
(newline)