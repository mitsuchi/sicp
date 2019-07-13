; 問題2.37
; 
; 行列
; |1 2 3 4|
; |4 5 6 6|
; |6 7 8 9|
; を ((1 2 3 4) (4 5 6 6) (6 7 8 9)) と表現することにする。
; ベクトル
; |1 2 3 4| は (1 2 3 4) とする。
;
; 内積は

(define (dot-product v w)
  (accumulate + 0 (map * v w)))

; と表現できる。
; 
; 以下の定義の欠けたところを補いなさい。

; (define (matrix-*-vector m v)
;   (map ⟨??⟩ m)

; (define (transpose mat)
;   (accumulate-n ⟨??⟩ ⟨??⟩ mat))
            
; (define (matrix-*-matrix m n)
;   (let ((cols (transpose n)))
;     (map ⟨??⟩ m)))

; A.

; (map * v w) っていう書き方ができるの知らなかった。
;
; 行列m とベクタv の積は、mの行を順にとってきてvと内積をとったもの
(load "./common.2.2.3.scm")

(define (matrix-*-vector m v)
  (map (lambda (mv) (dot-product mv v)) m))

(puts (matrix-*-vector '((1 2 3) (4 5 6)) '(2 3 4))) ; #=> (20 47)

; mat の転置行列は、
; ((1 2 3) (4 5 6)) -> ((1 4) (2 5) (3 6))
; なので、各行の最初の要素から順にとってきてリストにしたもの

(define (transpose mat)
  (accumulate-n cons nil mat))

(puts (transpose '((1 2 3) (4 5 6)))) ; #=> ((1 4) (2 5) (3 6))

; 行列の積 m * n は、
; (m1 m2 m3) * (n1 n2)
; なら
; (m1 m2 m3) と (n'1 n'2 n'3 n'4) : n' = transpose n について
; mi * n' を並べたもの

(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (mx) (matrix-*-vector cols mx)) m)))

(puts (matrix-*-matrix '((1 2 3) (4 5 6) (7 8 9)) '((1 0 0) (0 1 0) (0 0 1))))
; => ((1 2 3) (4 5 6) (7 8 9))
