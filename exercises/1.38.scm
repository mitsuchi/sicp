; 問題 1.38
; 1737年, スイスの数学者 Leonhard Eulerは De Fractionibus Continuisというメモを発表した.
; その中にeを自然対数の底としてe - 2 の連分数展開がある.
; この分数ではNiはすべて1, Diは順に1, 2, 1, 1, 4, 1, 1, 6, 1, 1, 8, ... となる。
; 問題1.37のcont-fracを使い, Eulerの展開によりeを近似するプログラムを書け. 

; A.

; Di は
; 2 -> 2
; 5 -> 4
; 8 -> 6
; 11 -> 8
; else -> 1
; という形なので、3k+2 のときだけ1以外になる。
; k に対する対応に直すと
; 0 -> 2
; 1 -> 4
; 2 -> 6
; 3 -> 8
; なので 2k+2
; つまりまとめると
; 3k+2 -> 2k+2
; else -> 1
; だ

(define (cont-frac n d k)
  (define (cont-frac-ij n d i k) ; i から k までについて
    (if (= i k)
      (/ (n i) (d i))
      (/ (n i) (+ (d i) (cont-frac-ij n d (+ i 1) k)))))
  (cont-frac-ij n d 1 k))

(define (n i) 1)
(define (d i) 
  (if
    (= (mod i 3) 2)
    (+ 2 (* 2 (div i 3)))
    1.0))
(define (e k)
  (+ 2 (cont-frac n d k)))

(display (e 10)) ; 2.7182817182817183
(newline)