(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))

; は、b が正だったら a+b、負だったら a-b を返す。
; つまりa+|b|を返す。

