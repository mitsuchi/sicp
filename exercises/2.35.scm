; 問題 2.35
; 2.2.2節のcount-leavesをアキュムレーションとして再定義せよ.
; (define (count-leaves t)
;   (accumulate ⟨??⟩ ⟨??⟩ (map ⟨??⟩ ⟨??⟩)))

; A.
; count-leaves はこうだった

; (define (count-leaves x)
;   (cond ((null? x) 0)  
;         ((not (pair? x)) 1)
;         (else (+ (count-leaves (car x))
;                  (count-leaves (cdr x))))))

; 左右の木の葉の数を再帰的に足していた。
; 木をリストのリストと考えて、length の要領で再帰的に数えればいいんじゃないだろうか

(define (length sequence)
    (accumulate (lambda (x y) (+ 1 y)) 0 sequence))

; これが length だった。
; (cons a as) -> (op a (accumulate op initial as)) = (op a as') として
; で、op を + に、a は a 自身の葉の数に、as' はそのまま足せばいい。

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))
          
(define (count-leaves sequence)
    (accumulate (lambda (x y)
      (+ (cond ((null? x) 0)
               ((not (pair? x)) 1)
               (else (count-leaves x)))
          y)) 0 sequence))

(define x (cons (list 1 2) (list 3 4)))

(display (count-leaves (list x x))) ; #=> 8
(newline)