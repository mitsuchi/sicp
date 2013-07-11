; リストの最後の要素を返す。
; 方針：前から順番に見ていって、次がなければ最後

(define (last-pair items)
  (if (null? (cdr items))
      (list (car items))
      (last-pair (cdr items))))

(print (last-pair (list 1 2 3 4 5)))
(print (last-pair (list 1)))

