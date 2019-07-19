; 問題 2.48
;
; 平面上の有向線分はベクタの対---原点から線分の始点へ向うベクタと, 
; 始点から線分の終点へ向うベクタ---で表現出来る. 問題2.46のベクタ表現を使い,
; この線分の表現を構成子 make-segmentと選択子 start-segment および end-segmentとして定義せよ. 

; A.
;
; 問題2.46のベクタ表現はこんなだった。

; (define (make-vect x y) (cons x y))

; (define (add-vect v w)
;     (make-vect (+ (xcor-vect v) (xcor-vect w))
;                (+ (ycor-vect v) (ycor-vect w))))

; make-segment : vect vect -> segment
; start-segment : segment -> vect
; end-segment : segment -> vect : こっちは原点からではなく始点から終点まででOKそう
; と思ったら次の問題を見るかぎり原点から終点までのベクトルだった。

(define (make-segment v w) (cons v w))
(define (start-segment seg) (car seg))
(define (end-segment seg) (add-vect (car seg) (cdr seg)))

; (load "./common.scm")
; (load "./2.46.scm")
; (define v (make-vect 1 2))
; (define w (make-vect 3 4))
; (define seg (make-segment v w))
; (puts (start-segment seg)) ; => (1 . 2)
; (puts (end-segment seg))   ; => (4 . 6)