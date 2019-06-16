; 問題 1.43

; fを数値関数, nを正の整数とすると, xでの値がf(f(... (f(x)) ... ))である
; fのn回作用関数が定義出来る. 
; 例えばfを関数x  x + 1とすると, fのn回作用は関数x  x + nである. 
; fが数を二乗する演算なら, fのn回作用は引数を2n乗する関数である.
; 入力としてfを計算する手続きと, 正の整数nをとり, fのn回作用を計算する手続きを書け. その手続きは:
; ((repeated square 2) 5)
; 625
; のように使えなければならない. ヒント:問題1.42のcomposeを使うと便利である. 

; A.

; f^n = f * f^(n-1)
; なので

(define (compose f g)
  (lambda (x) (f (g x))))

(define (repeated f n)
  (if 
    (= n 1)
    f
    (compose f (repeated f (- n 1)))))

(define (square x) (* x x))

(display ((repeated square 2) 5)) ; 625
(newline)

