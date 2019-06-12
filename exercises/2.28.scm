; 問題 2.28

; 引数として(リストとして表現されている)木をとり, その要素が, 木のすべての葉を, 
; 左から右の順に並べたものであるリストを返す手続き fringeを書け. 例えば

(define x (list (list 1 2) (list 3 4)))

; (fringe x)
; (1 2 3 4)

; (fringe (list x x))
; (1 2 3 4 1 2 3 4)

(define (fringe x)
  (cond 
    ((null? x) ())
    ((list? x) (append (fringe (car x)) (fringe (cdr x))))
    (else (list x))
  )
)

(display (fringe x))          ; => (1 2 3 4)
(newline)
(display (fringe (list x x))) ; => (1 2 3 4 1 2 3 4)
(newline)


