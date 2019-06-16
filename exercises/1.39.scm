; 問題 1.39
; 正接関数の連分数展開は1770年にドイツの数学者 J. H. Lambertが発表した.
; xをラジアンで表し, 
; tan x = x / (1 - x^2 / (3 - x^2 / 5 - ... ))
; Lambertの式に基づいて正接関数の近似値を計算する手続き(tan-cf x k) を定義せよ. 
; kは問題1.37と同様, 計算する項数を指定する. 

; A.
;
; tan x の連分数展開は,
; D(i) = 2i - 1
; N(i,x) = 
;  1 -> x
;  else -> - x * x
; なので、

(define (cont-frac n d k)
  (define (cont-frac-ij n d i k) ; i から k までについて
    (if (= i k)
      (/ (n i) (d i))
      (/ (n i) (+ (d i) (cont-frac-ij n d (+ i 1) k)))))
  (cont-frac-ij n d 1 k))

(define (d i) (- (* 2 i) 1))
(define (n x) 
  (lambda (i) 
    (if 
      (= i 1)
      x
      (* -1 x x))))
(define (tan-cf x k)
  (cont-frac (n x) d k))

(display (tan-cf (/ 3.141592 4) 10)) ; tan (pi/4) -> 0.9999996732051568 
(newline)
