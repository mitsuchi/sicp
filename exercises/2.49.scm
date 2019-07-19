; 問題 2.49
;
; segments->painterを使い, 次の基本的ペインタを定義せよ: 
; a. 指定されたフレームの外形を描くペインタ. 
; b. フレームの向い側の頂点を結んで「X」を描くペインタ. 
; c. フレームの辺の中点を結んで菱形を描くペインタ. 
; d. waveペインタ. 

; A. 
;
; えーとなにをすればいいのかな。segments->painter とはなんだ。

(define (frame-coord-map frame)
  (lambda (v)
    (add-vect
     (origin-frame frame)
     (add-vect (scale-vect (xcor-vect v)
                           (edge1-frame frame))
               (scale-vect (ycor-vect v)
                           (edge2-frame frame))))))

; これはなにか？
; 単位ベクタ (0,0) から (1,1) までを
; フレーム上のベクタ (x0,y0) から (x1,y1) までに変換する関数を返す

(define (segments->painter segment-list)
  (lambda (frame)
    (for-each
     (lambda (segment)
       (draw-line
        ((frame-coord-map frame) (start-segment segment))
        ((frame-coord-map frame) (end-segment segment))))
     segment-list)))

; これだ。これはなにをするものだ？
; 本文を読んでみよう。
; 単位正方形に対する座標を持つ線分(たとえば (0,1)->(1,0))のリストを引数にとり、関数を返す。
; どんな関数かというと、フレームを引数にとり、線分のそれぞれについて、フレーム内座標に変換した
; 始点から終点までの線を引く
; たとえば (0,1) -> (1,0) ていう線分なら、
; (0,1) -> (1,1) という線分に対応するフレーム内線分を引く
; painter とは、フレームを受け取ると、その中で絵を書くものである

; a. 指定されたフレームの外形を描くペインタ. 
; 
; これは単位正方形の外枠を囲む線分を4つ作ればいい

(segments->painter
    (list
        (make-segment (make-vect 0 0) (make-vect 1 0))  ; →
        (make-segment (make-vect 1 0) (make-vect 0 1))  ; ↑
        (make-segment (make-vect 1 1) (make-vect -1 0)) ; ←
        (make-segment (make-vect 0 1) (make-vect 0 -1))  ; ↓
    ))

; b. フレームの向い側の頂点を結んで「X」を描くペインタ. 

(segments->painter
    (list
        (make-segment (make-vect 0 0) (make-vect 1 1))  ; /
        (make-segment (make-vect 0 1) (make-vect 1 -1))  ; \
    ))

; c. フレームの辺の中点を結んで菱形を描くペインタ. 

(segments->painter
    (list
        (make-segment (make-vect 0.5 0) (make-vect 0.5 0.5))  ; /
        (make-segment (make-vect 1 0.5) (make-vect -0.5 0.5))  ; \
        (make-segment (make-vect 0.5 1) (make-vect -0.5 -0.5))  ; /
        (make-segment (make-vect 0 0.5) (make-vect 0.5 -0.5))  ; \
    ))

; d. waveペインタ. 
;
; 省略