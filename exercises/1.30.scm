; 問題 1.30

; 上のsumの手続きは線形再帰を生成する. 総和が反復的に実行出来るように手続きを書き直せる.
; 次の定義の欠けているところを補ってこれを示せ:

; (define (sum term a next b)
;   (define (iter a result)
;     (if ⟨??⟩
;         ⟨??⟩
;         (iter ⟨??⟩ ⟨??⟩)))
;   (iter ⟨??⟩ ⟨??⟩))

; もともとの sum の定義はこう

(define (sum2 term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum2 term (next a) next b))))

; 途中までの足し算の結果を result に入れてあげればいい

(define (sum term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (+ result (term a)))))
  (iter a 0))

(define (square x) (* x x))

(display (sum2 square 0 (lambda (x) (+ x 1)) 10)) ; 385
(newline)
(display (sum square 0 (lambda (x) (+ x 1)) 10))  ; 385
(newline)