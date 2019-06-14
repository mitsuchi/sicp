; 問題1.32

; a. sumと(問題1.31の)productは, 一般的なアキュムレーションの関数:
; (accumulate combiner null-value term a next b)
; を使い, 項の集りを組み合せるaccumulateという更に一般的なものの特殊な場合であることを示せ.
; accumulateは引数としてsumや productと同様, 項と範囲指定と,
;  先行する項のアキュムレーションと現在の項をどう組み合せるかを指定する
; (二引数の)combiner手続き, 項がなくなった時に使う値を指定するnull-valueをとる. 
; accumulateを書き, sumやproductがaccumulateの単なる呼出しで定義出来ることを示せ. 

(define (accumulate combiner null-value term a next b)
    (if (> a b)
        null-value
        (combiner (term a)
            (accumulate combiner null-value term (next a) next b))))

(define (product term a next b)
  (accumulate 
    (lambda (value progress) (* value progress)) ; combiner
    1                                            ; null-value
    term                                        
    a
    next
    b))

(define (factorial n)
  (product (lambda (x) x) 1 (lambda (m) (+ m 1)) n))

(display (factorial 5)) ; 120
(newline)

(define (sum term a next b)
  (accumulate 
    (lambda (value progress) (+ value progress)) ; combiner
    0                                            ; null-value
    term                                        
    a
    next
    b))

(define (sum1 n) ; 1 + 2 + .. + n
  (sum (lambda (x) x) 1 (lambda (m) (+ m 1)) n))

(display (sum1 10)) ; 55
(newline)

; b. 上のaccumulateが再帰的プロセスを生成するなら, 反復的プロセスを生成するものを書け.
; 反復的プロセスを生成するなら, 再帰的プロセスを生成するものを書け. 

; 問題1.31を参考に

(define (accumulate-iter combiner null-value term a next b)
    (define (iter a result)
        (if (> a b)
            result
            (iter
                (next a)
                (combiner result (term a)))))
    (iter a null-value))


(define (product-iter term a next b)
  (accumulate-iter 
    (lambda (value progress) (* value progress)) ; combiner
    1                                            ; null-value
    term                                        
    a
    next
    b))

(define (factorial-iter n)
  (product-iter (lambda (x) x) 1 (lambda (m) (+ m 1)) n))

(display (factorial-iter 6)) ; 720
(newline)