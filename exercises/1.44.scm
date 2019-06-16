; 問題 1.44

; 関数の平滑化(smoothing)の考えは信号処理に重要な概念である.
; f を関数, dxを微小な値とすると, fの平滑化したものは,
;  xでの値がf(x - dx), f(x), f(x + dx)の平均であるような関数である.
; 入力としてf を計算する手続きをとり, fの平滑化関数を計算する手続きを返す手続きsmoothを書け.
; 時には関数を繰り返し平滑化する(つまり平滑化関数を平滑化し, これを繰り返す),
;  n重平滑化関数(n-fold smoothed function)を得るのは有益である. 
; smoothと問題1.43のrepeated を使い, 与えられた関数のn重平滑化関数を作る方法を示せ. 

; A.

(define (smooth f)
  (define dx 0.001)
  (lambda (x)
    (/ (+ (f (- x dx)) (f x) (f (+ x dx))) 3)))

(define (square x) (* x x))

(display
  ((smooth square) 10))
(newline)  

(define (compose f g)
  (lambda (x) (f (g x))))

(define (repeated f n)
  (if 
    (= n 1)
    f
    (compose f (repeated f (- n 1)))))

(define (smooth-n f n)
  (repeated smooth n) f)

(display
  ((smooth-n square 3) 10))
(newline)
