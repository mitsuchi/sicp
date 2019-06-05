(load "./exercises/5.18.scm")

; a. 再帰的count-leaves:
;(define (count-leaves tree)
;  (cond ((null? tree) 0)
;        ((not (pair? tree)) 1)
;        (else (+ (count-leaves (car tree))
;                 (count-leaves (cdr tree))))))

(define count-leaves-machine
    (make-machine
        '(tree count continue tmp)    ; tree: 対象の木, count: 葉の数
        (list (list '+ +)
              (list 'car car)
	      (list 'cdr cdr)
	      (list 'null? null?)
              (list 'not not)
	      (list 'pair? pair?))
        '(
	  (assign continue (label count-leaves-done))
          count-leaves-loop
          (test (op null?) (reg tree))       ; 木が空だったら0
          (branch (label return-0))
          (assign tmp (op pair?) (reg tree))
          (test (op not) (reg tmp))          ; 木が葉だったら1
          (branch (label return-1))
          (save continue)
          (save tree)                        ; そうじゃなかったら再帰的に
          (assign tree (op car) (reg tree))   ; まず car について数える
          (assign continue (label after-car))
          (goto (label count-leaves-loop))
          after-car
          (restore tree)
          (save count)
          (assign tree (op cdr) (reg tree))     ; つぎは cdr について調べる
          (assign continue (label after-cdr))
          (goto (label count-leaves-loop))
          after-cdr
          (restore tmp)                                 
          (assign count (op +) (reg tmp) (reg count))    ; car と cdr の結果を足し算する
          (restore continue)
          (goto (reg continue))
          return-1
          (assign count (const 1))
          (goto (reg continue))
          return-0
          (assign count (const 0))
          (goto (reg continue))
          count-leaves-done)))

(define (count-leaves tree)
  (set-register-contents! count-leaves-machine 'tree tree)
  (start count-leaves-machine)
  (get-register-contents count-leaves-machine 'count))
