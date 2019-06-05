(define x (cons 1 2))
(define y (list x x))

; free -> p1

; 箱とポインタ表記
;
; y -> |+|-| -> |+|/|
;       |        |
; +-----+        |
; |              |
;↓↓------------+
;
; x -> |+|-| -> |2|
;       ↓
;      |1|

; メモリーベクタ表現
;               free
; Index      0  1  2  3  4  5  6  7  8  9 10 11
; the-cars |  |  |  |  |  |  |  |  |  |  |  |  |
; the-cdrs |  |  |  |  |  |  |  |  |  |  |  |  |
; 
; (define x (cons 1 2)) -> p1
;
;               x  free
; Index      0  1  2  3  4  5  6  7  8  9 10 11
; the-cars |  |n1|  |  |  |  |  |  |  |  |  |  |
; the-cdrs |  |n2|  |  |  |  |  |  |  |  |  |  |
;                                            p3      p2
; (define y (list x x))     ; (list x x) -> (cons x (cons x ()))
;   (cons x ())    -> p1
;   (cons x ...)   -> p2
;   (define y ...) -> p3
;
;               x     y  free
; Index      0  1  2  3  4  5  6  7  8  9 10 11
; the-cars |  |n1|p1|p1|  |  |  |  |  |  |  |  |
; the-cdrs |  |n2|e0|p2|  |  |  |  |  |  |  |  |
;
; freeの最後の値
;   -> p4
;
; どのポインタがxとyの値を表しているか.
;   -> p1:x, p3:y
;
; ((1 2) 3 4)
; (cons (cons (list 1 2) 3) 4)
; (cons (cons (cons 1 (cons 2 ())) 3) 4)
