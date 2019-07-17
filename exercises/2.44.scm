; 問題 2.44

; corner-splitで使った手続き up-splitを定義せよ.
; belowとbesideの働きを切り替える他は, right-splitと同様である. 

; A.
; 
; right-split はこんなだった。

(define (right-split painter n)
  (if (= n 0)
      painter
      (let ((smaller (right-split painter (- n 1))))
        (beside painter (below smaller smaller)))))

; up-split は、
; --------+--------
; up(n-1) | up(n-1)
; --------+--------
;     original
;
; という感じなので

(define (up-split painter n)
  (if (= n 0)
      painter
      (let ((smaller (up-split painter (- n 1))))
        (below painter (beside smaller smaller)))))

; 実際の確認は DrRacket で SICP collection をインストールして

#lang sicp
(#%require sicp-pict)

(define (up-split painter n)
  (if (= n 0)
      painter
      (let ((smaller (up-split painter (- n 1))))
        (below painter (beside smaller smaller)))))

(paint (up-split einstein 2))

; のようにする