; 問題 1.41

; 引数として一引数の手続きをとり, 受け取った手続きを二回作用させる手続きを返す手続きdoubleを定義せよ.
; 例えばincが引数に1を足す手続きとすれば, (double inc)は2を足す手続きとなる.
; (((double (double double)) inc) 5)
; はどういう値を返すか. 

; A.

(define (double f)
  (lambda (x) (f (f x))))

(define (inc x) (+ x 1))

(display ((double inc) 1))
(newline)

; f = (double double) は、2回作用させることを2回作用させるので、4回作用させる手続き。
; g = (double f) は、4回作用させるのを2回作用させるので、8回作用させる手続き。
; h = (g inc) は8回 inc するので、8を足す手続き
; (h 5) は、5に8を足すので 13

; と思ったけどまちがいだった。

; f = (double double) は、2回繰り返すのを2回繰り返すので、4回繰り返す手続き、
; g = (double f) は、(f f) つまり4回繰り返すのを4回繰り返すので、16回繰り返す手続き
; h = (g inc) は16回 inc するので、16を足す手続き
; (h 5) は、5に16を足すので 21
; が正しかった
;
; 以下、詳細
; 
; double = f -> x -> f (f x)
; と書き直す。
; double inc = x -> inc (inc x)
; となる。同様に
; double double = x -> double (double x)
; になる。
; double double = f -> double (double f)
; と書き直し、これを quatre と呼ぶことにする。
; (double quatre) は
; x -> quatre (quatre x)
; なのでこれを
; f -> quatre (quatre f)
; と書き直すと、
; (quatre f) は x -> (f (f (f (f x)))) だから
; f -> quatre (quatre f) は
; f -> quatre (x -> (f (f (f (f x)))))
; つまるところ4回繰り返ののを4回繰り返すので、16回繰り返すことになる。

(display (((double (double double)) inc) 5)) ; 21
(newline)