; 問題 2.43

; Louis Reasonerは問題2.42をやるのにおそろしく時間がかかった.
; 彼の手続きqueensは動くように見えたがすごく遅かった.
; (Louisは6 × 6を解くのさえ, 待つわけにいかなかった.)
; LouisがEva Lu Atorに助けを求めた時, 彼女は彼がflatmapの写像の入れ子の順を入れ替えて

(flatmap
  (lambda (new-row)
    (map (lambda (rest-of-queens)
          (adjoin-position new-row k rest-of-queens))
        (queen-cols (- k 1))))
  (enumerate-interval 1 board-size))

; と書いていると指摘した. この入替えがプログラムの実行を遅くする理由を説明せよ.
; 問題2.42のプログラムがパズルを解く時間をTとし,
; Louisのプログラムがエイトクィーンパズルを解くのにどのくらいかかるか推定せよ. 

; A.

; もともとはこうだった。

(flatmap
  (lambda (rest-of-queens)
    (map (lambda (new-row)
            (adjoin-position new-row k rest-of-queens))
          (enumerate-interval 1 board-size)))
  (queen-cols (- k 1)))

; つまり、k-1列めまでのクイーン配置の集合のリストのそれぞれ（の配置）に対して、
; k列めに(1..n)行めをそれぞれ置いたような配置を追加している。
; このコストは、q(k) をk列目までの全クイーン配置の個数とすると、
; q(k-1) * n なので、
; "k列めまでのクイーン配置の集合" を計算するコストを C(k) とすると、
; C(k) = C(k-1) + q(k-1) * n
; つまり
; C(n) = n * (q(1) + q(2) + .. + q(n-1))
; 
; それに対して新しいほうではこう。

(flatmap
  (lambda (new-row)
    (map (lambda (rest-of-queens)
          (adjoin-position new-row k rest-of-queens))
        (queen-cols (- k 1))))
  (enumerate-interval 1 board-size))

; (1..n)行のそれぞれ(i)に対して、k-1列めまでのクイーン配置の集合のリストのそれぞれ（の配置）に、
; k列にi行を追加している。
; このとき、"k-1列めまでのクイーン配置の集合" を毎回再計算することになるので、
; C(k) = n * q(k-1) * C(k-1)
; になる。
; C(1) = n
; C(2) = n * q(1) * n = n^2 * q(1)
; C(3) = n * q(2) * n^2 * q(1) = n^3 * q(1) * q(2)
; C(n) = n^n * q(1) * q(2) * .. q(n-1)
;
; q(i) については不明だけれども、
; q(1) + q(2) + .. + q(n-1) を q(n-1)^2 
; q(1) * q(2) * .. q(n-1)   を q(n-1)^(n-1) と近似すれば、
; C0(n) = n * q(n-1)^2
; C1(n) = n^n * q(n-1)^(n-1)
; となるので、新しい方式はおおよそ T の 8^7 * q(7)^5 倍になっている。