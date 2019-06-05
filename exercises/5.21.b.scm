(load "./exercises/5.18.scm")

;b. カウンタを陽に持つ再帰的count-leaves:
;(define (count-leaves tree)
;  (define (count-iter tree n)               ; tree: 残りの木、n: 現在までの個数
;    (cond ((null? tree) n)                  ; 木が空なら n が答
;          ((not (pair? tree)) (+ n 1))      ; 木が葉なら n+1 が答え
;          (else (count-iter (cdr tree)      ; そうじゃないなら、car について数えてから
;                            (count-iter (car tree) n))))) ; 残りの cdr について数える
;  (count-iter tree 0))

(define count-leaves-machine
    (make-machine
        '(tree tmp count continue)    ; tree: 対象の木, count: 葉の数
        (list (list '+ +)
              (list 'car car)
	      (list 'cdr cdr)
	      (list 'null? null?)
              (list 'not not)
	      (list 'pair? pair?))
        '((assign continue (label count-leaves-done))
          (assign count (const 0))
          count-leaves-loop
          (test (op null?) (reg tree))           
          (branch (label return-n))                    ; 木が空なら n が答
          (assign tmp (op pair?) (reg tree))
          (test (op not) (reg tmp))
          (branch (label return-n-plus-1))             ; 木が葉なら n+1 が答え
          (save continue)
          (save tree)
          (assign continue (label after-car))    ; そうじゃないなら再帰的に
          (assign tree (op car) (reg tree))
          (goto (label count-leaves-loop))       ; car について数えてから
          after-car
          (restore tree)
          (restore continue)
          (assign tree (op cdr) (reg tree))
          (goto (label count-leaves-loop))       ; 残りの cdr について数える
          return-n
          (goto (reg continue))                         
          return-n-plus-1
          (assign count (op +) (reg count) (const 1))   ; 最後の答えがそのまま答え
          (goto (reg continue))                         
          count-leaves-done)))

(define (count-leaves tree)
  (set-register-contents! count-leaves-machine 'tree tree)
  (start count-leaves-machine)
  (get-register-contents count-leaves-machine 'count))
