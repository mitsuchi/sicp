; パスカルの三角形を

1
1 1
1 2 1
1 3 3 1
1 4 6 4 1

; と書き直して、
; 上から y 行目、左から x 列目の数を計算するのを
; (pascal x y) とする。

(define (pascal x y)
  (cond ((= x 0) 1) ; 左の端は1
		((= x y) 1) ; 右の端は1
		(else (+ (pascal (- x 1) (- y 1)) ; それ以外は真上の1つ左と
				 (pascal x (- y 1))))))   ; 真上の和

(print (pascal 0 4))
; 1
(print (pascal 1 4))
; 4
(print (pascal 2 4))
; 6
(print (pascal 3 4))
; 4
(print (pascal 4 4))
; 1
