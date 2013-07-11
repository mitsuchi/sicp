; 2.2 階層型データと閉包性
; ========================
;
; ペアを図示するための方法として「箱とポインター」がある。
;
; 箱の中には基本要素が入ってる。数とか。
; ペアは左右1組の箱で、左にはcarへのポインター、
; 右にはcdrへのポインターが入ってる。
;
; 図：(cons 1 2)
; (cons 1 2)の評価で返るのは箱へのポインター。
;
; それぞれの要素がペアであるペアも作れる。
;
; 図：1 2 3 4を組み合わせたもの
;
; なので、ペアを部品としていくらでも複雑な構造を作れる。
; consのこういう性質を閉包性という。
;
; 部品を組み合わせた結果がまた部品となることで、小さくて基本的な
; 部品から、大きくて複雑な構造を作れる。こういう構造のことを階層型構造という。
;
; 1章でやったように、簡単な手続きを組み合わせて複雑な手続きをつくるには
; コンビネーションの各要素をコンビネーションにすればよかった。
; この章では、簡単なデータを組み合わせて複雑なデータを作る方法を見る。
;
; 2.2.1 並びを表現する
; --------------------
;
; 1 2 3 4 みたいな並びは箱とポインターの記法ではこう書ける。
; 図：1 2 3 4の並び
; 式で書くとこう。

(cons 1
      (cons 2
            (cons 3
                  (cons 4 nil))))  ; nil は斜線のところ。

; こういうのをリストという。
; (list 1 2 3 4) とも書ける。

(define one-through-four (list 1 2 3 4))

one-through-four ; を評価すると
(1 2 3 4)        ; と表示される

; (1 2 3 4)は評価の結果の単なる表示であり、(1 2 3 4)という
; コンビネーションと混同しないこと。1がオペランドなわけじゃない。
;
; リストについては、car, cdr, cons が基本操作になる。
; 
; * car xs は リストxsの最初の要素を返す。
; * cdr xs は リストxsの2番目以降からなるリストを返す。
; * cons x xs は リストxsの先頭に要素xを足したものを返す。
;
; いくつか試してみる。

(car one-through-four)
1

(cdr one-through-four)
(2 3 4)

(car (cdr one-through-four))
2

(cons 10 one-through-four)
(10 1 2 3 4)

(cons 5 one-through-four)
(5 1 2 3 4)

; nilは空リストと見ることもできる。
; 斜線を空のリストへのポインターと見なすことで。
;
; リストの操作
; ------------
;
; リストを操作するには、リストをcdrで下っていけばいい。
; たとえばリストitemsのn番目の要素を返す list-ref はこんな感じ。

(define (list-ref items n)              ; n番目の要素は
  (if (= n 0)              
      (car items)                       ; n=0 なら car
      (list-ref (cdr items) (- n 1))))  ; n>0 なら cdr の n-1 番目

(define squares (list 1 4 9 16 25))
(list-ref squares 3)
16

; リストが空かどうかは null? で分かる。

(define (length items)              ; リストitemsの長さは
  (if (null? items)
      0                             ; 空なら0
      (+ 1 (length (cdr items)))))  ; そうでないなら cdrの長さ + 1

(define odds (list 1 3 5 7))
(length odds)
4

; 反復的にも書ける

(define (length items)
  (define (length-iter a count)
    (if (null? a)
        count
        (length-iter (cdr a) (+ 1 count))))
  (length-iter items 0))

; cdrで下りながら、別のリストにconsで付け加えていく方法もよくある。
; たとえば append というリストを結合する手続きを考える。
; 評価の例はこう。

(append squares odds)
(1 4 9 16 25 1 3 5 7)

(append odds squares)
(1 3 5 7 1 4 9 16 25)

; 実装はこんなかんじ。

(define (append list1 list2)               ; list1 と list2を結合したものは
  (if (null? list1)
      list2                                ; list1 が空なら list2
      (cons (car list1)                    ; そうじゃないなら list1 の先頭に、
            (append (cdr list1) list2))))  ; list1のcdrとlist2を結合したのをconsしたもの。

;プロセスのイメージ。もともと左側にあったリストが短くなっていく。
;

(1 2 3)+(4 5)
(1 (2 3)+(4 5))
(1 2 (3)+(4 5))
(1 2 3 ()+(4 5))
(1 2 3 (4 5))
(1 2 3 4 5)

; ### 問題 2.17
;
; リストの最後の要素だけからなるリストを返す手続きlast-pairを定義しなさい。

(last-pair (list 23 72 149 34))
(34)

; [回答](exercises/2.17.scm)
;
; ### 問題 2.18
;
; リストをひっくり返す手続き reverse を作りなさい。

(reverse (list 1 4 9 16 25))
(25 16 9 4 1)

; [回答](exercises/2.18.scm)
;
; ### 問題 2.19
;
; 1.2.2の両替問題で、硬貨の種類をリストで指定できたら便利。

(define us-coins (list 50 25 10 5 1))
(define uk-coins (list 100 50 20 10 5 2 1 0.5))
(cc 100 us-coins)
292

; みたいな。
; 次の定義の first-denomination, except-first-denomination, no-more? を
; リストの基本操作で定義しなさい。

(define (cc amount coin-values)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (no-more? coin-values)) 0)
        (else
         (+ (cc amount
                (except-first-denomination coin-values))
            (cc (- amount
                   (first-denomination coin-values))
                coin-values)))))

; coin-values の順番は結果に影響するか？その理由は？
;
; [回答](exercises/2.19.scm)
;
; ### 問題 2.20
;
; 引数の長さが可変の手続きは、

(define (f x y . z) <body>)

; みたいに書ける。

(f 1 2 3 4 5 6)

; なら x=1, y=2, z=(list 3 4 5 6) 。
; ちなみに

(define (g . w) <body>)

; で

(g 1 2 3 4 5 6)

; なら w=(list 1 2 3 4 5 6) 。
; これを使って、引数のうち、最初のものと偶奇が一致するものだけを残したリストを返す
; 手続き same-parity を定義しなさい。結果はたとえばこう。

(same-parity 1 2 3 4 5 6 7)
(1 3 5 7)

(same-parity 2 3 4 5 6 7)
(2 4 6)

; [回答](exercises/2.20.scm)
;
; リスト上のマッピング
; --------------------
;
; リストのそれぞれの要素を変形できると便利。
; たとえばそれぞれの要素を定数倍するのはこう。

(define (scale-list items factor)
  (if (null? items)
      nil
      (cons (* (car items) factor)
            (scale-list (cdr items) factor))))

(scale-list (list 1 2 3 4 5) 10) ; 10倍にする
(10 20 30 40 50)

; これを一般化すると map になる。

(define (map proc items)
  (if (null? items)
      nil
      (cons (proc (car items))
            (map proc (cdr items)))))

(map abs (list -10 2.5 -11.6 17))
(10 2.5 11.6 17)

(map (lambda (x) (* x x))
     (list 1 2 3 4))
(1 4 9 16)

; map を使って scale-list を書き直すとこう。

(define (scale-list items factor)
  (map (lambda (x) (* x factor))
       items))

; mapを使う利点。
; * リストの各要素を順に操作、じゃなくてリストそのものを操作するという発想になる。
; * リストが具体的にどう実装されてるかを知らなくてもいい。抽象化の壁を築ける。
; * 将来リストの実装が変わっても影響ない。
; 
; ### 問題 2.21
;
; リストの各要素を2乗する手続き square-list を考える。

(square-list (list 1 2 3 4))
(1 4 9 16)

; 以下の <??> を穴埋めしなさい。
;
; consを使ったもの
(define (square-list items)
  (if (null? items)
      nil
      (cons <??> <??>)))

; mapを使ったもの
(define (square-list items)
  (map <??> <??>))

; [回答](exercises/2.21.scm)
;
; ### 問題 2.22
; 
; square-list を反復プロセスで書き換えようとしてみた。

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things) 
              (cons (square (car things))
                    answer))))
  (iter items nil))

; でもこれだと逆順になっちゃう。なぜか？
; cons の引数を逆にしてみた。

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons answer
                    (square (car things))))))
  (iter items nil))

; これも動かない。どうしてか。
;
; [回答](exercises/2.22.scm)
;
; ### 問題 2.23
;
; リストの各要素に手続きを適用だけして結果を捨てる for-each を作りなさい。
; 動作はこんな感じ。

(for-each (lambda (x) (newline) (display x))
          (list 57 321 88))
57
321
88

; [回答](exercises/2.23.scm)

