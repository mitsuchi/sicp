; 問題 2.14
;
; Lemの正しいことを示せ.
; いろいろな算術演算の式でシステムの振舞いを調べよ.
; 区間AとBを作り, A/AとA/Bを計算するのに使ってみよ.
; 幅が中央値に比べて小さいパーセントの区間を使うと, 大体のことは推察出来る.
; 中央値とパーセント相対許容誤差の形式の計算結果を調べよ(問題2.12参照). 

; つまり 

(define (par1 r1 r2)
  (div-interval (mul-interval r1 r2)
                (add-interval r1 r2)))

(define (par2 r1 r2)
  (let ((one (make-interval 1 1))) 
    (div-interval one
                  (add-interval (div-interval one r1)
                                (div-interval one r2)))))

; この二つが違うことを示せということ

(load "./2.12.scm")

(define r1 (make-center-percent 2 10))
(define r2 (make-center-percent 2 10))

(display (par1 r1 r2))  ; (0.73, 1.34)
(newline)
(display (par2 r1 r2))  ; (0.89, 1.1)
(newline)

; たしかに全然違う

(define a (make-center-percent 2 1))
(define b (make-center-percent 3 1))
(define c (make-center-percent 100 1)) ; 100, 1%
(define d (make-center-percent 100 2)) ; 100, 2%

; a/a
(display (div-interval a a))
(newline)
; a/b
(display (div-interval a b))
(newline)
; c/c
(display (div-interval c c)) ; [0.98, 1.04] ; 1, 2%
(newline)
; d/d
(display (div-interval d d)) ; [0.96, 1.04] ; 1, 4%
(newline)

; つまり a が n% の誤差のとき, a/a は 2*n% の誤差になる
