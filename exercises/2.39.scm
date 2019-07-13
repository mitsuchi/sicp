; 問題 2.39

; reverse(問題2.18)の, 問題2.38のfold-rightとfold-left を使った, 次の定義を完成せよ:
; (define (reverse sequence)
;   (fold-right (lambda (x y) ⟨??⟩) nil sequence))
; (define (reverse sequence)
;   (fold-left (lambda (x y) ⟨??⟩) nil sequence))

; A.

(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))

(load "./common.2.2.3.scm")
(define fold-right accumulate)

; fold-right は
; x0 op (x1 op (x2 op nil))
; のように計算する。つまり、op の右側（第二引数）に現在までの値が、
; 左側にリスト中の次の値がくる。

(define (reverse-r sequence)
  (fold-right (lambda (x y) (append y (list x))) nil sequence))

(puts (reverse-r (list 1 2 3 4))) ; #=> (4 3 2 1)

; fold-left は
; ((init op x0) op x1) op x2
; のように計算する。つまり、op の左側（第一引数）に現在までの値が、
; 右側にリスト中の次の値がくる。

(define (reverse-l sequence)
  (fold-left (lambda (x y) (append (list y) x)) nil sequence))

(puts (reverse-l (list 1 2 3 4)))
