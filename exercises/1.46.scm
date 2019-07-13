; 問題 1.46
; 
; 本章に述べた数値計算法のいくつかは, 反復改良法(iterative improvement)という非常に一般的な計算戦略の特殊化である.
; 反復改良法では何かを計算するのに, 答に対する最初の予測値から始め, 予測値が十分良好であるか調べ,
;  そうでなければ予測値を改良し, 改良した予測値を新しい予測値としてプロセスを続ける.
; 引数として二つの手続き: 予測値が十分良好であるか調べる方法と, 予測値を改良する方法をとる手続き iterative-improveを書け.
; iterative-improveは引数として予測値をとり, 予測値が十分良好になるまで改良を繰り返す手続きを値として返す.
; iterative-improveを使って1.1.7節のsqrt手続きと, 1.3.3節のfixed-point手続きを書き直せ. 

; A. 

; 1.1.7でやった 二乗根 はこんなだった
; (define (sqrt-iter guess x)
;   (if (good-enough? guess x)
;       guess
;       (sqrt-iter (improve guess x)
;                  x)))
; 
; なので iterative-improve はこんなか

(define (iterative-improve good-enough? improve) ; 予測値をとり、十分良好になるまで繰り返すような手続きを返す
    (define (generate-improved-value guess)
        (if (good-enough? guess)
            guess
            (generate-improved-value (improve guess))))
    generate-improved-value)

; これで sqrt を書き直すとこう
  
(define (sqrt x)
    ((iterative-improve
        (lambda (guess) (< (abs (- (* guess guess) x)) 0.001))
        (lambda (guess) (average guess (/ x guess)))) 1.0))

(define (average x y)
  (/ (+ x y) 2))

(display (sqrt 10)) ; #=> 3.162277665175675
(newline)

; つづいて fixed-point だ
; 1.3.3 での定義はこうだった
 
; (define (fixed-point f first-guess)
;   (define (close-enough? v1 v2)
;     (< (abs (- v1 v2)) tolerance))
;   (define (try guess)
;     (let ((next (f guess)))
;       (if (close-enough? guess next)
;           next
;           (try next))))
;   (try first-guess))

; これを iterative-improve で書き直す

(define (fixed-point f first-guess)
    ((iterative-improve
        (lambda (x) (< (abs (- x (f x))) 0.0001))
        (lambda (x) (f x))) first-guess))

(display (fixed-point cos 1.0)) ; #=> 0.7391301765296711
(newline)

