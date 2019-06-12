; 問題 2.27

; 問題2.18の手続きreverseを修正し, 引数としてリストをとり, 要素を逆順にし, 
; 更に部分木も奥まで逆順にする手続き deep-reverseを作れ. 例えば
(define x (list (list 1 2) (list 3 4)))

; x
; ((1 2) (3 4))

; → ( ,-)---------> ( ,\)
;    ↓              ↓    
;   ( ,-)--> ( ,\)  ( ,-)--> ( ,\)
;    ↓        ↓      ↓        ↓    
;    1        2      3        4

; (reverse x)
; ((3 4) (1 2))

; (deep-reverse x)
; ((4 3) (2 1))
; 
; 方針を考えよう
; リストを入れ子でぜんぶ逆順にする。
; 先頭のやつを後ろにくっつければいい
; 後ろにくっつけるときに、それがまたリストなら逆順にすればいい。

(define (deep-reverse items)
    (cond 
        ((null? items) ())
        ((list? items) (append (deep-reverse (cdr items)) (list (deep-reverse (car items)))))
        (else items)))

(display (deep-reverse (list 1 2 3 4)))               ; => (4 3 2 1)
(newline)
(display (deep-reverse (list (list 1 2) (list 3 4)))) ; => ((4 3) (2 1))
(newline)

; こうしちゃってうまく行かなかった

(define (deep-reverse2 items)
    (if (null? items)
        ()
        (append (deep-reverse2 (cdr items)) (deep-reverse2 (list (car items))))))

; これだとたとえば (list 1) からはじめると
; (car (list 1)) が 1 なので、ふたたび (list 1) にもどって無限ループになる。

; これもだめだった

(define (deep-reverse3 items)
    (cond 
        ((null? items) ())
        ((list? items) (append (deep-reverse3 (cdr items)) (deep-reverse3 (car items))))
        (else (list items))))


(display (deep-reverse3 (list 1 2 3 4)))                ; (4 3 2 1)
(newline)
(display (deep-reverse3 (list (list 1 2) (list 3 4))))  ; (4 3 2 1)
(newline)
