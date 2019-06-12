; 問題 2.30

; 問題2.21のsquare-list手続きと類似の手続きsquare-treeを定義せよ. つまりsquare-treeは, 次のように振舞わなければならない.

; (square-tree
;     (list 1
;         (list 2 (list 3 4) 5)
;         (list 6 7)))
;
; => (1 (4 (9 16) 25) (36 49))

; square-treeを直接に(つまり高階手続きを使わずに), またmapと再帰を使って定義せよ. 

(define (square-tree tree)
    (map (lambda (sub-tree)
         (if (pair? sub-tree)
             (square-tree sub-tree)
             (* sub-tree sub-tree)))
        tree))

(define tree1 
    (list 1
       (list 2 (list 3 4) 5)
       (list 6 7)))

(display (square-tree tree1))
(newline)