; 最初の実装を試してみる。

(define (square x) (* x x))
(define nil (list))

;; (define (square-list items)
;;   (define (iter things answer)
;;     (if (null? things)
;;         answer
;;         (iter (cdr things) 
;;               (cons (square (car things))
;;                     answer))))
;;   (iter items nil))

;; (print (square-list (list 1 2 3 4)))

; 逆順になるのは reverse を作る問題で説明したとおり。
; cons を逆にしてみたもの。

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons answer
                    (square (car things))))))
  (iter items nil))

(print (square-list (list 1 2 3 4)))

; 順番は正しいけどリストじゃない。
; 構造を図で書く。

