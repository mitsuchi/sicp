; 問題 1.31

; a. sum手続きは高階手続きとして書ける, 同様な数多い抽象の最も単純なものに過ぎない.
; 与えられた範囲の点での関数値の積を返すproductという似た手続きを書け.
; productを使って, factorialを定義せよ.

(define (product term a next b)
  (if (> a b)
      1
      (* (term a)
         (product term (next a) next b))))

(define (factorial n)
  (product (lambda (x) x) 1 (lambda (m) (+ m 1)) n))

(display (factorial 5)) ; 120
(newline)

; また式
;
; π/4 = (2*4*4*6*6*8*..)/(3*3*5*5*7*7*..)
;
; によってπの近似値を計算するのにproductを使え
;
; n(>=0)番目の分子は ((n+3) div 2)*2 = f(n)
; n(>=0)番目の分母は (n div 2)*2 + 3 = g(n)
; h(n) = f(n)/g(n) とすれば pi/4 は
; Product[n=0 to m] h(n)

(define (f n) (* 2 (div (+ n 3) 2)))
(define (g n) (+ 3.0 (* 2 (div n 2))))
(define (h n) (/ (f n) (g n)))

(define pi4
  (product h 0 (lambda (n) (+ n 1)) 10000))

(display (* 4 pi4)) ; 3.1414356249916424
(newline)

; b. 上のproductが再帰的プロセスを生成するなら, 反復的プロセスを生成するものを書け.
; 反復的プロセスを生成するなら, 再帰的プロセスを生成するものを書け. 

; 再帰的プロセスなので反復的プロセスに書き直す

(define (product2 term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (* result (term a)))))
  (iter a 1))

(define piq
  (product2 h 0 (lambda (n) (+ n 1)) 10000))

(display (* 4 piq)) ; 3.1414356249916584
(newline)