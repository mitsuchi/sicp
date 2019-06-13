; 問題 1.29
; 
; Simpsonの公式は上に示したのより更に正確な数値積分法である.
; Simpsonの公式を使えば, aからbまでの関数fの積分は, 偶整数nに対し, h = (b - a)/nまたyk = f(a + kh)として

; h/3 * ( y[0] + 4y[1] + 2y[2] + 4y[3] + 2y[4] + ... + 2y[n-2] + 4y[n-1] + y[n] )

; で近似出来る. (nの増加は近似の精度を増加する.)
; 引数としてf, a, bとnをとり, Simpson公式を使って計算した積分値を返す手続きを定義せよ.
; その手続きを使って(n = 100とn = 1000で)0から1までcubeを積分し, またその結果を上のintegral手続きの結果と比較せよ. 

(define (simpson f a b n)
  (define h (/ (- b a) n))
  (define (y k) (f (+ a (* k h))))
  (define (add-dx x) (+ x dx))
  (define (g m)
    (cond
       ((= 0 m) (y m))
       ((= n m) (y m))
       ((even? m) (* 2.0 (y m)))
       (else (* 4.0 (y m)))))
  (* (sum2 g 0 n) (/ h 3.0)))

(define (sum2 term a b)
  (if (> a b)
      0
      (+ (term a)
         (sum2 term (+ 1 a) b))))

(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))

(define (integral f a b dx)
  (define (add-dx x) (+ x dx))
  (* (sum f (+ a (/ dx 2.0)) add-dx b)
     dx))

(define (cube x) (* x x x))

(display (integral cube 0 1 0.01))  ; .24998750000000042
(newline)
(display (simpson cube 0 1 100))    ; 0.24999999999999992
(newline)
(display (simpson cube 0 1 1000))   ; 0.2500000000000002
(newline)

; 最初こうやって 1/4 になっちゃった
; 整数で掛け算割り算すると有理数のまま計算してくれるみたい

(define (simpson f a b n)
  (define h (/ (- b a) n))
  (define (y k) (f (+ a (* k h))))
  (define (add-dx x) (+ x dx))
  (define (g m)
    (cond
       ((= 0 m) (y m))
       ((= n m) (y m))
       ((even? m) (* 2 (y m)))
       (else (* 4 (y m)))))
  (* (sum2 g 0 n) (/ h 3)))

