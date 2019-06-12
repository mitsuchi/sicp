; 問題 2.31

; 問題2.30の答を抽象化し, square-treeが
; (define (square-tree tree) (tree-map square tree))
; と定義出来るように, 手続き tree-mapを作れ. 

(define (tree-map proc tree)
    (map (lambda (sub-tree)
         (if (pair? sub-tree)
             (tree-map proc sub-tree)
             (proc sub-tree)))
        tree))

(define tree1 
    (list 1
       (list 2 (list 3 4) 5)
       (list 6 7)))

(define (square x) (* x x))
(define (square-tree tree) (tree-map square tree)) 

(display (square-tree tree1))
(newline)
