; 問題 1.37

; a. 無限の連分数(continued fraction)は
; f = N1 / (D1 + N2 / (D2 + N3 / (D3 +  ... )))
; 例えばNiとDiがすべて1の無限連分数展開が1/φになることが示せる.
; φは(1.2.2節で示した)黄金比.
; 無限連分数の近似値のとり方の一つは, 与えられた項数で展開を中断することで,
; そういう中断--- k項有限連分数(k-term finite continued fraction)という---は
; f = N1 / (D1 + N2 / (D2 + ... + (Nk / Dk)))
; の形である. nとdを一引数(項の添字i)で連分数の項のNiとDiを返す手続きとする.
; (cont-frac n d k)がk項有限連分数を計算するような手続きcont-fracを定義せよ.

; A.

; f1 = N1 / D1
; f2 = N1 / ( D1+ N2 / D2)
; f3 = N1 / ( D1+ N2 / (D2 + N3/D3)) ; f(1,3) = n1 / (d1 + f(2,3))

; f(i,j) = ni / (di + f(i+1,j)) ; 区間iからjまでについて

(define (cont-frac n d k)
  (define (cont-frac-ij n d i k) ; i から k までについて
    (if (= i k)
      (/ (n i) (d i))
      (/ (n i) (+ (d i) (cont-frac-ij n d (+ i 1) k)))))
  (cont-frac-ij n d 1 k))

(define (phi k)
  (/ 1 (cont-frac (lambda (i) 1.0)
            (lambda (i) 1.0)
            k)))

; のkの順次の値で1/φの近似をとり, 手続きを調べよ.
; 4桁の精度の近似を得るのに, kはどのくらい大きくしなければならないか.

; A.

(display (phi 9)) ; 1.6176470588235294
(newline)
(display (phi 10)) ; 1.6181818181818184
(newline)

; なのでkを10にすればいい