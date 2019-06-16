; 問題 1.36

; 問題1.22で示した基本のnewlineとdisplayを使い, 生成する近似値を順に印字するようfixed-pointを修正せよ.
; 次にx log(1000)/log(x)の不動点を探索することで, xx = 1000の解を見つけよ.
;  (自然対数を計算するSchemeの基本log手続きを使う.) 平均緩和を使った時と使わない時のステップ数を比べよ. 
; ({ fixed-pointの予測値を1にして始めてはいけない. log(1)=0による除算を惹き起すからだ.) 

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

; まずはふつうバージョン : 34行
(display (fixed-point 
    (lambda (x) (/ (log 1000) (log x)))
    10.0))
(newline)

; 平均緩和バージョン : 11行
(display (fixed-point 
    (lambda (x) (average x (/ (log 1000) (log x))))
    10.0))
(newline)