; 問題2.33
;
; リスト操作の基本演算の, アキュムレーションとしての定義が以下にある. 欠けた部分を補って完成せよ.

; (define (map p sequence)
;   (accumulate (lambda (x y) ⟨??⟩) nil sequence))

; (define (append seq1 seq2)
;   (accumulate cons ⟨??⟩ ⟨??⟩))

; (define (length sequence)
;   (accumulate ⟨??⟩ 0 sequence))

; accumulate の定義はこう

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

; つまり、sequence = (cons a (cons b (cons c nil))) として、
; cons を op に変換したものを作る。
; nil                   -> initial
; (cons a nil)          -> (op a initial)
; (cons a (cons b nil)) -> (op a (op b initial))
; なので、終端の nil は initial に変換する。
; map は、cons a b を cons (f a) b にすればいいので

(load "./common.scm")

(define (map p sequence)
    (accumulate (lambda (x y) (cons (p x) y)) nil sequence))

(define (double x) (+ x x))
(display (map double (list 1 2 3))) ; #=> (2 4 6)
(newline)

; append x y は、x 中の cons はそのまま、終端の nil を y にすればいいので、

(define (append seq1 seq2)
    (accumulate cons seq2 seq1))

(display (append (list 1 2 3) (list 4 5 6))) ; #=> (1 2 3 4 5 6)
(newline)

; length xs は、op を + に、要素は 1 にすればいいので、

(define (length sequence)
    (accumulate (lambda (x y) (+ 1 y)) 0 sequence))

(display (length (list 2 4 6 8 10))) ; #=> 5
(newline)