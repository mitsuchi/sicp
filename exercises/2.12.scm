; 問題 2.12
; 
; 中央値とパーセント相対許容誤差をとり, 望み通りの区間を返す構成子
; make-center-percentを定義せよ. また区間のパーセント相対許容誤差を
; 返す選択子percentを定義しなければならない. center選択子は上に示したのと同じでよい. 

(load "./2.7.scm")

(define (make-center-percent c p)
  (make-interval (- c (* c p 0.01)) (+ c (* c p 0.01))))

(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2))

; 98, 102 なら 100 に対して2%だ。これはつまり、
; 100 * ((x.l + x.w) * 0.5 - x.l) / (x.l + x.w) * 0.5 
; だ。けっこうめんどくさい。
; 100 * (1 - 2 * x.l / (x.l + x.w))
; のほうがいいか
(define (percent i)
  (* 100 
    (- 1 
      (* 2 
        (/ (lower-bound i) 
          (+ (lower-bound i)
             (upper-bound i)))))))

(define i (make-center-percent 100 2))

(display (center i))
(newline)
(display (percent i))
(newline)