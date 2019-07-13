; 問題 2.38

; accumulate手続きは, 並びの先頭の要素を右方のすべての要素を組み合せた結果に組み合せるので, fold-rightとしても知られている. 
; 逆向きに仕事をしながら要素を組み合せる他はfold-rightと類似な fold-leftもある.

(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))

(load "./common.2.2.3.scm")
(define fold-right accumulate)

; 次の値は何か.

(puts (fold-right / 1 (list 1 2 3))) ; #=> 3/2
(puts (fold-left / 1 (list 1 2 3))) ; #=>  1/6

; A.
; fold-right のほうは
; (cons a (cons b nil)) で cons を op に、nil を initial にしたものなので、
; (/ 1 (/ 2 (/ 3 1)))
; 3 -> 2/3 -> 1/(2/3) = 3/2
;
; fold-left のほうはinitial から初めて前から result op xi で順番にやっていくので
; 1 -> 1/1 = 1 -> 1/2 -> (1/2)/3 = 1/6

(puts (fold-right list nil (list 1 2 3))) ; #=> (1 (2 (3 ())))
(puts (fold-left list nil (list 1 2 3)))  ; #=> (((() 1) 2) 3)

; fold-right のほうは、list を中置演算子だと思うと
; 1 list (2 list (3 list nil)) なので、
; (3 nil) -> (2 (3 nil)) -> (1 (2 (3 nil)))
;
; fold-left のほうは ((nil list 1) list 2) list 3 なので、
; (nil 1) -> ((nil 1) 2) -> (((nil 1) 2) 3)

; fold-rightとfold-leftが, どのような並びに対しても同じ値を生じるためにopが満たすべき性質は何か. 

; A.
; op を中置で書くと
; a op (b op init) : foldr
; と
; (init op a) op b : foldl
; になるから、これが一致するためには、op は可換であり、結合律を満たす必要がある。
; a op b = b op a
; かつ
; (a op b) op c = a op (b op c)
;
; 逆にこれが満たされれば、
; (a op (b op init)) : foldr
; = (a op b) op init
; = init op (a op b)
; = (init op a) op b : foldl
; になり、両者は等しくなる
