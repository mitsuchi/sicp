; 問題 1.45

; 1.3.3節で y -> x/y の不動点を素朴に見つけることで平方根を計算する試みは収束せず, 平均緩和が役立つことを見た.
; 同じ方法で, y -> x/y^2 の平均緩和の不動点として立方根を見つけることが出来る.
; 困ったことに, この方法は四乗根には使えない. 単一の平均緩和は y -> x/y^3 の不動点を収束させるには十分でない.
; 一方二回平均緩和すると(つまりy -> x/y^3の平均緩和の平均緩和を使うと)不動点探索は収束する.
; y -> x/y^(n-1)の平均緩和を繰り返し使った不動点探索として n乗根を計算するのに, 何回の平均緩和が必要か実験してみよ.
; この結果を利用し, fixed-point, average-dampおよび問題1.43の repeatedを使い, n乗根を計算する単純な手続きを実装せよ.
; 必要な算術演算は基本手続きとして使えるとせよ. 

; A. 

; 問題文が長いなー
; とにかく実験しろと言ってるのはわかる。
; なにを実験すればいいんだ？
; ひとまず y-> x/y を収束させる平均緩和の話を思い出そう。

(define tolerance 0.00001)

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (begin 
        (display guess)
        (newline)
        (let ((next (f guess)))
        (if (close-enough? guess next)
            next
            (try next)))))
  (try first-guess))

(define (average x y) (/ (+ x y) 2))
(define (sqrt x)
  (fixed-point (lambda (y) (average y (/ x y)))
               1.0))

(display (sqrt 2))
(newline)

; とりあえず思い出せた。
; x -> x/y は平均緩和法で収束した。
; つぎに x -> x/y^2 だとどうなるかをやってみよう

(define (cbrt x)
    (fixed-point
        (lambda (y) (average y (/ x (* y y))))
        1.0))

(display (cbrt 10)) ; 2.154432882998236 : 合ってる
(newline)

; つぎに、4乗根はだめっていうのを確認しよう

(define (fourth-root x)
    (fixed-point
        (lambda (y) (average y (/ x (* y y y))))
        1.0))

;(display (fourth-root 10))
;(newline)

; 確かに発散した
; 2回平均緩和したらうまくいくのを確認しよう

(define (fourth-root-avg-2 x)
    (fixed-point
        (lambda (y) (average y (average y (/ x (* y y y)))))
        1.0))

(display (fourth-root-avg-2 10)) ; 1.7782794100444472 : 正解
(newline)

; うまくいった
; それで一般のn乗根について実験せよということだね。
; その前に、n回平均緩和をとる手続きをつくっておきたいね

(define (nth-average n a b) ; (average a (average a ... (average a b)))
    (if (= n 1)
        (average a b)
        (average a (nth-average (- n 1) a b))))

; 試してみよう

(display (nth-average 1 2.0 3.0)) ; 2.5
(newline)
(display (nth-average 2 2.0 3.0)) ; 2.25
(newline)
(display (average 2.0 (average 2.0 3.0))) ; 2.25
(newline)

; うまく行ってる
; 4乗根で試してみよう

(define (fourth-root-ver3 x)
    (fixed-point
        (lambda (y) (nth-average 2 y (/ x (* y y y))))
        1.0))

(display (fourth-root-ver3 10)) ; 1.7782794100444472 : 正解
(newline)

; では5乗根はどうなるか実験しよう

(define (fifth-root x)
    (fixed-point
        (lambda (y) (nth-average 2 y (/ x (expt y 4)))) ; (* y y y y) の代わりに (expt y 4) とした
        1.0))
(display (fifth-root 32)) ; 2.000001512995761 : 正解
(newline)

; 10乗根までやってみよう

(define (nth-root-m x n m) ; x の n乗根を求める。m回平均緩和する。
    (fixed-point
        (lambda (y) (nth-average m y (/ x (expt y (- n 1)))))
        1.0))

(display (nth-root-m 32 5 2))
(newline)
(display (nth-root-m 64 6 2))
(newline)
(display (nth-root-m 128 7 2))
(newline)
(display (nth-root-m 256 8 3)) ; 2回ではだめだった
(newline)
(display (nth-root-m 512 9 3))
(newline)
(display (nth-root-m 1024 10 3))
(newline)

; ここまでを表にすると
; n乗根 -> m回平均緩和
; 2 -> 1
; 3 -> 1
; 4 -> 2
; 5 -> 2
; 6 -> 2
; 7 -> 2
; 8 -> 3
; 9 -> 3
; 10 -> 3
; という感じなので、m = log2 n の切り下げ、とすればよさそうだ。

(define (nth-root x n) ; x の n乗根を求める。
  (define m (floor (log n 2)))
  (fixed-point
      (lambda (y) (nth-average m y (/ x (expt y (- n 1)))))
      1.0))

(display (nth-root 1048576 20))
(newline)

; 解けたけど、average-damp と repeated を使ってない。
; なんだっけそれ

(define (average-damp f) ; x -> (x と f(x) の平均) のような関数を返す
  (lambda (x) (average x (f x))))

(define (compose f g)
  (lambda (x) (f (g x))))

(define (repeated f n) ; f を n回適用するような関数を返す
  (if 
    (= n 1)
    f
    (compose f (repeated f (- n 1)))))

; こうだ。これをつかって書き直そう。
; (average x (average x ... (average x (f x)))))
; は
; f: x -> f x
; が 変換 a によって
; g: x -> (x + f(x))/2
; になるとする。g をさらに a で変換すると
; h: x -> (x + g(x))/2
; になる
; g = a f
; h = a (a f) = a^2 f
; いっぱんには m = a^n f みたいになる

(define (nth-average-ver2 f n)
  ((repeated average-damp n) f))

(display ((nth-average-ver2 (lambda (x) (* x x)) 3) 3.0))
(newline)

; として
; (nth-average-ver2 f 10) 1.0
; みたいにかけるので、

(define (nth-root-ver2 x n) ; x の n乗根を求める。ver2
  (define m (floor (log n 2)))
  (fixed-point
      (lambda (y) ((nth-average-ver2 (lambda (z) (/ x (expt z (- n 1)))) m) y))
      1.0))

(display (nth-root-ver2 1048576 20))
(newline)