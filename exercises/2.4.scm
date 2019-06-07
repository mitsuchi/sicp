; 問題 2.4
; これは対のもう一つの手続き表現である.
; この表現について任意のオブジェクトxとyに対し, (car (cons x y))がxを生じることを証明せよ.

(define (cons2 x y)
  (lambda (m) (m x y)))

(define (car2 z)
  (z (lambda (p q) p)))

; (car (cons x y))
; -> (car (lambda (m) (m x y)))
; -> ((lambda (m) (m x y)) (lambda (p q) p))
; -> ((lambda (p q) p) x y))
; -> x

;これに対するcdrの定義は何か. (ヒント: これが働くことを調べるには, 1.1.5節の置換えモデルを利用せよ.) 

(define (cdr2 z)
  (z (lambda (p q) q)))

(display (car2 (cons2 1 2)))
(newline)
(display (cdr2 (cons2 1 2)))
(newline)