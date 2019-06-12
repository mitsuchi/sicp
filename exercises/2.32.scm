; 問題 2.32

; 集合は相異る要素のリストで表現出来る.
; また, 集合のすべての部分集合の集合を, リストのリストで表現出来る.
; 例えば集合が(1 2 3)の時, すべての部分集合の集合は
; (() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3))である.
; 集合の部分集合の集合を作り出す手続きの次の定義を完成し, なぜうまくいくか, 明快に説明せよ.

; (define (subsets s)
;   (if (null? s)
;       (list nil)
;       (let ((rest (subsets (cdr s))))
;         (append rest (map ⟨??⟩ rest)))))

(define (subsets s)
  (if (null? s)
      (list ())
      (let ((rest (subsets (cdr s))))
        (append rest (map 
                        (lambda 
                           (elem)
                           (append (list (car s))
                                   elem))
                        rest)))))

(display (subsets (list 1 2 3))) ; (() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3))
(newline)

; うまくいく理由はこう。
; あるひとつの要素(headとする)をのぞいた集合についての部分集合がすでにつくられているとする。rest-subsets とする。
; すると全体の部分集合は、rest-subsets そのものと、
; rest-subsets のそれぞれに head を追加したもの、を併せたものになる。
