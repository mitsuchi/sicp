; 問題 2.11
; 
; ついでにBenは謎めいたことをいった:
;「区間の端点の符号を調べると, mul-intervalを九つの場合に分けることが出来,
; そのうち一つだけが二回を超える乗算を必要とする.」 Benの提案に従い, 手続きを書き直せ. 

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

; まず現状はつねに4回の乗算をしている。これを減らせるというのが Ben の指摘。
; x について                   
; 1. x.lb < 0 && x.ub < 0 
; 2. x.lb < 0 && 0 <= x.ub
; 3. x.lb <= 0 && 0 <= x.ub
; の3通りの状況がある
; それぞれ [-,-], [-,+], [+,+] と書くことにする。
; y についても同様に3通りの状況がある
; なので3*3=9通りの状況になる。
; 一番簡単な [+,+] * [+,+] の場合で考えると、
;  (x*y).lb = x.lb * y.lb
;  (x*y).ub = x.ub * y.ub
; となって二回で済む。
; この調子で [-,-]*[-,-] から考えていく。
;
; 1. [-,-]*[-,-]
;  (x*y).lb = x.ub * y.ub
;  (x*y).ub = x.lb * y.lb
; 2. [-,-]*[-,+]
;  (x*y).lb = x.lb * y.ub
;  (x*y).ub = x.lb * y.lb
; 3. [-,-]*[+,+]
;  (x*y).lb = x.lb * y.ub
;  (x*y).ub = x.ub * y.lb
; 4. [-,+]*[-.-] は ケース2 と同じ
; 5. [-,+]*[-.+] 
;  (x*y).lb = min( x.lb * y.ub, x.ub * y.lb )
;  (x*y).ub = max( x.lb * y.lb, x.ub * y.ub )
; 6. [-,+]*[+.+] 
;  (x*y).lb = x.lb * y.ub
;  (x*y).ub = x.ub * y.ub
; 7. [+,+]*[-.-] は ケース3と同じ
; 8. [+,+]*[-.+] は ケース6と同じ
; 9. [+,+]*[+.+] は 最初にやった

; ということでケース5だけが掛け算が4回必要になる
; めんどくさいので実装省略