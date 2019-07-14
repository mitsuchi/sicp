; 問題 2.40
;
; 与えられた整数nに対し, 1 ≤ j < i ≤ nの対(i, j)の並びを生成する
; 手続き unique-pairsを定義せよ.
; unique-pairsを使って, 上のprime-sum-pairsの定義を簡単にせよ. 

; A.
;

(load "./common.2.2.3.scm")

(define (unique-pairs n)
  (flatmap
    (lambda (i)
      (map (lambda (j) (list i j))
          (enumerate-interval 1 (- i 1))))
    (enumerate-interval 1 n)))

(puts (unique-pairs 4)) ; => ((2 1) (3 1) (3 2) (4 1) (4 2) (4 3))

(define (prime-sum-pairs n)
  (map make-pair-sum
    (filter prime-sum? (unique-pairs n))))

(puts (prime-sum-pairs 6))
; => ((2 1 3) (3 2 5) (4 1 5) (4 3 7) (5 2 7) (6 1 7) (6 5 11))

