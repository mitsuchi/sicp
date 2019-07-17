; 問題 2.45

; right-splitとup-splitは, 汎用分割演算の具体化として表すことが出来る.
(define right-split (split beside below))
(define up-split (split below beside))
; の評価が, すでに定義したものと同じ振舞いの手続きright-splitとup-splitを
; 作り出すような性質を持つ手続き splitを定義せよ. 

; A.
;
; right-split, up-split はこんなだった。

(define (right-split painter n)
  (if (= n 0)
      painter
      (let ((smaller (right-split painter (- n 1))))
        (beside painter (below smaller smaller)))))

(define (up-split painter n)
  (if (= n 0)
      painter
      (let ((smaller (up-split painter (- n 1))))
        (below painter (beside smaller smaller)))))

; ほとんど同じで、beside, below だけの箇所だけが違う

(define (split sp1 sp2)
  (define (splitter painter n)
    (if (= n 0)
      painter
      (let ((smaller (splitter painter (- n 1))))
        (sp1 painter (sp2 smaller smaller)))))
  splitter)

