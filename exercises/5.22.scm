(load "./exercises/5.18.scm")

;(define (append x y)  ; x の後ろに y をつなげる
;  (if (null? x)       ; x が空なら
;      y               ; y が答
;      (cons (car x) (append (cdr x) y))))  ; そうじゃないなら、x の先頭と、 x の残りと y をつなげたものの対をつくる

(define append-machine
  (make-machine
    '(x y result tmp continue) ; result : 答
    (list
     (list 'null? null?)
     (list 'cons cons)
     (list 'car car)
     (list 'cdr cdr))
    '(start
       (assign continue (label append-done))
    append-loop
       (test (op null?) (reg x))    ; x が空なら
       (branch (label return-y))    ; y が答
       (save continue)
       (assign continue (label after-append))     ; そうじゃないなら
       (save x)
       (assign x (op cdr) (reg x))     ; x の残りと y をつなげたものの
       (goto (label append-loop))
    return-y
       (assign result (reg y))
       (goto (reg continue))
    after-append
       (restore x)
       (restore continue)
       (assign tmp (op car) (reg x))
       (assign result (op cons) (reg tmp) (reg result)) ; 対をつくる
       (goto (reg continue))
    append-done)))

(define (append x y)
  (set-register-contents! append-machine 'x x)
  (set-register-contents! append-machine 'y y)
  (start append-machine)
  (print (get-register-contents append-machine 'result)))

(append '(1 2) '(3 4 5))

;(define (append! x y)
;  (set-cdr! (last-pair x) y)     ; x の 最後 のセルを y に上書きして　
;  x)                             ; x を返す
;
; (define (last-pair x)           ; x の 最後のセルは、
;  (if (null? (cdr x))            ; x の cdr が空なら x そのもの
;      x
;      (last-pair (cdr x))))      ; そうじゃないなら、再帰的に cdr x の最後のセル

(define append!-machine
  (make-machine
    '(continue x y tmp)
    (list
     (list 'set-cdr! set-cdr!)
     (list 'null? null?)
     (list 'cdr cdr))
    '(start
       (assign continue (label append!-done))
       (save x)
    append!-loop                                  ; x の 最後のセルは、
       (assign tmp (op cdr) (reg x))           
       (test (op null?) (reg tmp))                ; x の cdr が空なら
       (branch (label return-x))                  ; x そのもの
       (assign x (op cdr) (reg x))                ; そうじゃないなら、再帰的に cdr x の最後のセル
       (goto (label append!-loop))
    return-x
       (assign x (op set-cdr!) (reg x) (reg y))   ; x の 最後 のセルを y に上書きして　
       (goto (reg continue))
    append!-done
       (restore x)                                ; x を返す
    )))

(define (append! x y)
  (set-register-contents! append!-machine 'x x)
  (set-register-contents! append!-machine 'y y)
  (start append!-machine)
  (print (get-register-contents append!-machine 'x)))

(append! '(a b) '(c d e f g h i j))
