; 問題 2.42

; 8 queen 問題を解けるようにする

(define (queens board-size)
  (define (queen-cols k)  
    (if (= k 0)
        (list empty-board)
        (filter
         (lambda (positions) (safe? k positions))
         (flatmap
          (lambda (rest-of-queens)
            (map (lambda (new-row)
                   (adjoin-position new-row k rest-of-queens))
                 (enumerate-interval 1 board-size)))
          (queen-cols (- k 1))))))
  (queen-cols board-size))

; queen-colsは盤の最初のk列にクィーンを置くすべての方法の並びを返す
; ということなので、empty-board は単に nil でいいのでは？

(load "./common.2.2.3.scm")
(define empty-board nil)

; adjoin-position は、
; 盤上の位置の集合の表現を実装し, 位置の集合に新しい場所の座標を連結する手続き
; とのこと
; 1列めでは3行めにクイーンが、2列めでは1行めにクイーンがいる状態は
; (1 3) と右から順に表したらどうか。クイーンに位置が一つも未確定な状態は () 

(define (adjoin-position new-row k rest-of-queens)
  ; new-row は行番号、k は追加する列、rest-of-queens は k-1列めまでのクイーンの位置の集合
  ; rest-of-queens が k-1個のリストであることは前提とする
  (cons new-row rest-of-queens))

(define (safe? k positions)
  ; (4 1 3) であれば最初の 4 が右側のどの列ともかぶってないことが必要
  (and (= 0 (length (filter (lambda (x) (= x (car positions))) (cdr positions))))
       ; 同様に斜め方向もかぶってないことが必要
       (diagonal-isolated? (car positions) (cdr positions))))

(define (diagonal-isolated? k rest-of-queens)
  ; 4 (1 3) であれば、1行目は 4+1 でも 4-1 でもないことが必要、2行目は 4+2 でも 4-2 でもだめ
  ; i 行目は 4 +- i でないことが必要。つまり、
  ; (5 6), (3 2) という2つのリストと (1 3) がどの要素も一致していなければいい
  (and (not (collide? rest-of-queens (incr-from k (length rest-of-queens))))
       (not (collide? rest-of-queens (decr-from k (length rest-of-queens))))))

; (k+1 k+2 ... k+l) の l個のリスト
(define (incr-from k l)
  (if (= l 0)
    nil
    (append (list (+ k 1)) (incr-from (+ k 1) (- l 1)))))

; (k-1 k-2 ... k-l) の l個のリスト
(define (decr-from k l)
  (if (= l 0)
    nil
    (append (list (- k 1)) (decr-from (- k 1) (- l 1)))))

; 二つのリストがいずれかの項目で一致するか
(define (collide? xs ys)
  (cond
    ((null? xs) false)
    ((= (car xs) (car ys)) true)
    (else (collide? (cdr xs) (cdr ys)))))

(puts (queens 8)) ; #=> 問題文にある (3 7 2 8 5 1 4 6) を含む 92個
