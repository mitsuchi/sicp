; 問題 1.33
; 組み合せる項に フィルタ(filter)の考えを入れることで, 
; accumulate(問題1.32)の更に一般的なものが得られる.
; つまり範囲から得られて, 指定した条件を満した項だけを組み合せる.
; 出来上ったfiltered-accumulate抽象は, accumulate と同じ引数の他,
; フィルタを指定する一引数の述語をとる. filtered-accumulateを手続きとして書け. 

(define (filtered-accumulate filter combiner null-value term a next b)
    (if (not (filter a))
        (filtered-accumulate filter combiner null-value term (next a) next b)
        (if (> a b)
            null-value
            (combiner (term a)
                (filtered-accumulate filter combiner null-value term (next a) next b)))))

; filtered-accumulateを使い, 次をどう表現するかを示せ. 

; a. 区間a, bの素数の二乗の和(prime?述語は持っていると仮定する.) 
(load "./prime.scm")

(define (sum-prime a b)
  (filtered-accumulate
    prime?
    (lambda (value progress) (+ value progress))
    0
    (lambda (x) (* x x))
    a
    (lambda (x) (+ x 1))
    b))

(display (sum-prime 1 10)) ; 88 = (1^2 + 2^2 + 3^2 + 5^2 + 7^2)
(newline)
; 問題1.22 の prime? は1が素数に入る流儀のようなのでこれでOK

; b. nと互いに素で, nより小さい正の整数(つまりi < nでGCD(i, n)=1なる全整数i)の積

(define (product-mutually-prime n)
  (filtered-accumulate
    (lambda (x) (= (gcd x n) 1))
    (lambda (value progress) (* value progress))
    1
    (lambda (x) x)
    1
    (lambda (x) (+ x 1))
    (- n 1)))

(display (product-mutually-prime 10)) ; 189 = (3 * 7 * 9)
(newline)