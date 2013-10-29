(define us-coins (list 50 25 10 5 1))
;(define us-coins (list 25 50 5 1 10))
;(define us-coins (list 1 5 10 25 50))
;(define uk-coins (list 100 50 20 10 5 2 1 0.5))

(define (cc amount coin-values)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (no-more? coin-values)) 0)
        (else
         (+ (cc amount
                (except-first-denomination coin-values))
            (cc (- amount
                   (first-denomination coin-values))
                coin-values)))))

(define (first-denomination coin-values)
  (car coin-values))

(define (except-first-denomination coin-values)
  (cdr coin-values))

(define (no-more? coin-values)
  (null? coin-values))

(print (cc 100 us-coins))

; 硬貨の種類で辞書式順序に並べる
; d1, d2, .., dn のn種類があるとして、
; a円の払い方が以下のようだとする。

;; d1 d1 d1 d2 d4 d5 
;; d1 d1 d3 d6
;; d1 d3 d6
;; d1 d4
;; d2 d2 d3 d4
;; d3 d3 d3

; すると、d1 をまったく含まないもの（下2行）と、d1を1つ以上含むもの（上4行）に
; 分けられる。
; n種類の硬貨でa円を払うやりかたの数を(cc a n)とすると、
; 前者は(cc a (n-1))、後者は(cc (a-d1) n)で、この和になる。
; 前者は種類が減ってて、後者はお金が減ってるので、再帰的に小さな問題に還元されてる。
