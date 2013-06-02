; 1. 正規順の場合

(gcd 206 40)

(gcd 40 (remainder 206 40))
; これで (= b 0)の評価をするのに remainder を1回評価する
(gcd (remainder 206 40) (remainder 40 (remainder 206 40)))
; 同様に 2回
(gcd (remainder 40 (remainder 206 40))
     (remainder (remainder 206 40) (remainder 40 (remainder 206 40))))
; 4回
(gcd (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))
	 (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))))
; 7回
(remainder (remainder 206 40) (remainder 40 (remainder 206 40)))
; 4回
2
; でremainderの評価は合計1+2+4+7+4=17回
;
; 2. 適用順の場合

(gcd 206 40)

(gcd 40 (remainder 206 40))
; 1回
(gcd 40 6)

(gcd 6 (remainder 40 6))
; 1回
(gcd 6 4)

(gcd 4 (remainder 6 4))
; 1回
(gcd 4 2)

(gcd 2 (remainder 4 2))
; 1回
(gcd 2 0)

2
; で合計4回


