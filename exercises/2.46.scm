; 問題 2.46

; 原点からある点へ向う二次元のベクタvはx座標とy座標からなる対で表現出来る.
; 構成子 make-vectと, 対応する選択子 xcor-vectと ycor-vectを作り, ベクタのデータ抽象を実装せよ.
; その選択子と構成子を使い, ベクタの加算, 減算, スカラーによる乗算:

; (x1, y1) + (x2, y2) = (x1+x2, y1+y2)
; (x1, y1) - (x2, y2) = (x1-x2, y1-y2)
; s * (x,y)           = (sx, sy)

; の演算を実行する手続き add-vect, sub-vectおよび scale-vectを実装せよ. 

(define (make-vect x y) (cons x y))
(define (xcor-vect v) (car v))
(define (ycor-vect v) (cdr v))

(define (add-vect v w)
    (make-vect (+ (xcor-vect v) (xcor-vect w))
               (+ (ycor-vect v) (ycor-vect w))))

(define (sub-vect v w)
    (make-vect (- (xcor-vect v) (xcor-vect w))
               (- (ycor-vect v) (ycor-vect w))))

(define (scale-vect s v)
    (make-vect (* s (xcor-vect v))
               (* s (ycor-vect v))))

; (define v (make-vect 1 2))
; (define w (make-vect 3 4))

; (load "./common.scm")
; (puts (add-vect v w))
; (puts (sub-vect v w))
; (puts (scale-vect 2 v))