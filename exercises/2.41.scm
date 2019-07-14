; 問題 2.41
; 
; 与えられた整数nに対し, nより小さいか等しい相異る正の整数i, j, kの
; 順序づけられた三つ組で, 和が与えられた整数sになるものをすべて見つけよ. 

; A.
; 
; 1 <= i < j < k <= n
; 最初に [1 .. n] のリストを作り、
; つぎにそのそれぞれ(i)を [1..(i-1)] に写像し、
; つぎにそのそれぞれ(j) を [1..(j-1)] に写像し、
; 最後に そのそれぞれ (k) を (i j k) に写像すればいい。

(load "./common.2.2.3.scm")

(define (unique-triples n)
  (flatmap ; 6. さらにネストを外す
    (lambda (i)
      (flatmap ; 5. できたリストのネストを外し
        (lambda (j) 
          (map
            (lambda (k) (list i j k)); 4. そのそれぞれの要素 k について (i j k) を作る
            (enumerate-interval 1 (- j 1)) ; 3. そのそれぞれの要素 j について 1 から (j-1) までのリストを作り
          )
        ) 
        (enumerate-interval 1 (- i 1)))) ; 2. 1 から (i-1) までのリストを作り
    (enumerate-interval 1 n))) ; 1. 1からnまでのリストのそれぞれの要素iについて

(puts (unique-triples 4)) ; => ((3 2 1) (4 2 1) (4 3 1) (4 3 2))
