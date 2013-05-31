; 1.2 手続きと、それがつくるプロセス
; ==================================
; 
; これまでプログラムの要素をみてきたけど、これだけだとまだ
; プログラムが組めるようになったとはいえない。チェスでいえば
; 駒の動かし方が分かっただけで、どう動せばいいかが分からないからだ。
;
; 達人になるには、何をどう動かしたらその結果何がどうなるかが完璧に
; 分かってないといけない。あらかじめ図示できるようじゃないといけない。
;
; 手続きは、計算のプロセスの局所的な進行のパターンだ。あるステージから
; 次のステップでどんなステージになるかを定める。
;
; この章では、かんたんな手続きについて、典型的な計算のプロセスの形を見てみよう。
; それから計算量とか領域量も。
;
; 1.2.1 線形再帰と繰り返し
; ------------------------
;
; 最初に階乗の計算プロセスを見てみよう。

(factorial 6)
(* 6 (factorial 5))
(* 6 (* 5 (factorial 4)))
(* 6 (* 5 (* 4 (factorial 3))))
(* 6 (* 5 (* 4 (* 3 (factorial 2)))))
(* 6 (* 5 (* 4 (* 3 (* 2 (factorial 1))))))
(* 6 (* 5 (* 4 (* 3 (* 2 1)))))
(* 6 (* 5 (* 4 (* 3 2))))
(* 6 (* 5 (* 4 6)))
(* 6 (* 5 24))
(* 6 120)
720

; たとえばこんな感じだ。factorial はふつうに定義するとこうなる。

(define (factorial n)
  (if (= n 1)
      1
      (* n (factorial (- n 1)))))

; もうちょっと違う計算方法もある。
; 1 * 2 * .. * n みたいに1から順にnまでかけ算すればいい。
; こんな感じ。

(define (factorial n)
  (fact-iter 1 1 n))

(define (fact-iter product counter max-count)
  (if (> counter max-count)
      product
      (fact-iter (* counter product)
                 (+ counter 1)
                 max-count)))

; 計算のプロセスはこうだ。

(factorial 6)
(fact-iter   1 1 6)
(fact-iter   1 2 6)
(fact-iter   2 3 6)
(fact-iter   6 4 6)
(fact-iter  24 5 6)
(fact-iter 120 6 6)
(fact-iter 720 7 6)
720

; fact-iterの最初の引数に途中の答えが引き回されてる。2番めの引数はカウンターだ。
; ふたつの factorial は、同じ計算をする手続きなのにそのプロセスは全然違う。
; 
; 最初の例みたいに、最初に展開しまくって後から収束するタイプを再帰的プロセスという。
; 展開してる最中に必要な領域はnに比例するので、とくに線形再帰プロセスという。
;
; 2つめのほうは、必要な領域量はプロセスの最中ずっと一定だ。こういうのを繰り返し
; プロセスという。この手のプロセスの状態は状態変数と、それがどういうふうに
; 変化するか、どんな条件で繰り返しが終わるかで表せる。
; n!を計算するのに必要なステップはnなので、とくに線形繰り返しプロセスという。
;
; 見方をかえるとこういう違いもある。繰り返しプロセスのほうは、プロセスの状態は
; 手続きに含まれる変数の値で完全に決まる。途中で中断しても、すべての変数の値が
; 分かってれば、そこから再開できる。でも再帰的プロセスのほうは、再帰がどこまで
; 進んでるかっていう表にでない情報があって、それがないと中断したあと再開できない。
;
; 再帰的手続きと再帰的プロセスは区別しないといけない。再帰的手続きのほうは、
; 文法的に手続きが自分自身を呼び出してること。再帰的プロセスは、プロセスが
; 展開〜収束みたいに進行すること。たとえば fact-iter は、再帰的手続きだけど再帰的
; プロセスじゃない。
;
; ふつうの言語だと、再帰的手続きはかならず再帰的プロセスになる。繰り返しプロセス
; にしようと思ったら while とかのループ用の部品を使わないといけない。
; schemeの場合は、再帰的手続きでも繰り返しプロセスになる場合があって、そういう実装を
; 末尾再帰という。
;
; ### 問題 1.9
;
; 次の2つの手続きは、足し算を定義してる。inc(1足す)とdec(1引く)を使ってる。

(define (+ a b)
  (if (= a 0)
      b
      (inc (+ (dec a) b))))

(define (+ a b)
  (if (= a 0)
      b
      (+ (dec a) (inc b))))

; 置き換えモデルを使って、(+ 4 5)の評価プロセスがどう進むかしらべなさい。
; 再帰的？それとも繰り返し？
;
; [回答](exercises/1.9.scm)
;
; ### 問題 1.10
; 
; 次の手続きはアッカーマン関数というものを計算する。

(define (A x y)
  (cond ((= y 0) 0)
        ((= x 0) (* 2 y))
        ((= y 1) 2)
        (else (A (- x 1)
                 (A x (- y 1))))))

; 次の式の値は？

(A 1 10)

(A 2 4)

(A 3 3)

; それから次の手続きの計算する関数の数学的な定義をあたえなさい。

(define (f n) (A 0 n))

(define (g n) (A 1 n))

(define (h n) (A 2 n))

(define (k n) (* 5 n n))

; [回答](exercises/1.10.scm)
;
; 木の再帰
; --------
;
; もうひとつよくあるパターンは木の再帰だ。
; フィボナッチ数列を考えてみる。ある項は前2つの和だ。

0,1,1,2,3,5,8,13,21,...

; 手続きで表すとこう。

(define (fib n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib (- n 1))
                 (fib (- n 2))))))

; 計算のプロセスは木みたいになる

fib 4
  fib 3
    fib 2
      fib 1
        1
      fib 0
        0
    fib 1
      1
  fib 2
    fib 1
      1
    fib 0
      0

; 木は2分木になっていて、つまりfibは1ステップ進むたびに2回呼び出される。
; ただこの定義はムダが多い。fib 4でみると、fib 2 は2回、fib 1は３回も
; 重複して計算されてる。
;
; 実際、fib n を計算する過程で fib 0 と fib 1は合計Fib(n+1)回計算される。
; Fib(n) はnの指数関数的に増えるので、つまりfib nの計算に必要なステップも
; 指数関数的ということになる。ちなみに黄金比をφとすると、φ^√5に一番近い
; 自然数がFib(n)になる。
;
; 領域量のほうは実は線形でいい。なぜなら再帰の深さは木の深さになるけど、
; それはせいぜい n だから。
;
; 一般に木の再帰では、計算のステップ数は木のノードの数に比例して、
; 領域量は木の深さに比例する。
;
; フィボナッチ数を繰り返し的プロセスで計算することもできる。
; それぞれのステップで Fib(n)とFib(n+1)を覚えておけばいい。

(define (fib n)
  (fib-iter 1 0 n))

(define (fib-iter a b count)
  (if (= count 0)
      b
      (fib-iter (+ a b) a (- count 1))))

; fib-iter の a が Fib(n+1)で、bがFib(n)にあたる。
; こっちだと計算のステップ数はnに比例する。
;
; だからといって、木の再帰的プロセスは使えないと思っちゃ行けない。
; 木構造の上で計算するときにはまっすぐで分かりやすいし、数学的な定義から
; Lispへの変換も簡単だ。繰り返しプロセスへの変換は簡単じゃない場合がある。
;
; ### 例：両替する方法を数える
;
; フィボナッチ数の場合は繰り返しプロセスで表すのはちょっとした工夫でよかった。
; 次の場合はどうだろう？
;
; 1ドルを両替するのに何通りの方法があるか？使う硬貨は次のとおり。
; * ハーフダラー：1/2ドル
; * クォーター　：1/4ドル
; * ダイム　　　：1/10ドル
; * ニッケル　　：1/20ドル
; * ペニー　　　：1/100ドル
;
; 再帰的手続きだと簡単な解法がある。いま使える硬貨の種類が順番に並んでるとして、
; aドルをn種類の硬貨で両替する方法の数は次の2つの和に等しい。
; 
; * A. aドルを最初の硬貨を使わないで両替する方法の数　
; * B. a-dドルをn種類の硬貨で両替する方法の数。ただしdは最初の硬貨の金額。
;
; なんでかっていうと、両替する方法は次の2つに分けられることに注意。
;
; * 最初の硬貨を1枚も使わない方法
; * 最初の硬貨を少なくとも1枚は使う方法
;
; 1つめの場合の数はAと一緒だし、2つめの場合の数は
; 1枚使って残りの金額をn種類で両替する方法と同じ。つまりBと同じだ。
;
; Aの場合は硬貨の種類が減ってて、Bの場合はお金が減ってる。だからこのやり方で
; 再帰的に問題をどんどん小さくしていくことができる。はしっこのケースはこうだ。
;
; * もし a が 0 なら 1 通り
; * a が 0 未満なら 0 通り
; * n が 0 なら 0 通り
;
; つまりこうなる。

(define (count-change amount)
  (cc amount 5))
(define (cc amount kinds-of-coins)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (= kinds-of-coins 0)) 0)
        (else (+ (cc amount
                     (- kinds-of-coins 1))
                 (cc (- amount
                        (first-denomination kinds-of-coins))
                     kinds-of-coins)))))
(define (first-denomination kinds-of-coins)
  (cond ((= kinds-of-coins 1) 1)
        ((= kinds-of-coins 2) 5)
        ((= kinds-of-coins 3) 10)
        ((= kinds-of-coins 4) 25)
        ((= kinds-of-coins 5) 50)))

; 最初の問題の答えはこう。

(count-change 100)
292

; count-changeは木の再帰プロセスになって、フィボナッチと同じように効率はよくない。
; でもアイデアをプログラムに翻訳するのは簡単だ。
; 同じことをする繰り返しプロセスのプログラムはどう書けばいいのかちょっと分からない。
; だから将来誰かがかしこいコンパイラーを作って、木の再帰プロセスを繰り返しプロセスの
; プログラムに翻訳できるようになるかもしれない。
;
; ### 問題 1.11
;
; 関数fは、n<=3 のとき f(n) = n、n>3のとき f(n) = f(n - 1) + 2f(n - 2) + 3f(n - 3)
; とする。fを計算する手続きを、再帰的プロセスのものと繰り返しプロセスのものでそれぞれ
; 作りなさい。
;
; [回答](exercises/1.11.scm)
;
; ### 問題 1.12
;
; 次のようなのをパスカルの三角形という。

    1
   1 1
  1 2 1
 1 3 3 1
1 4 6 4 1

; 再帰的プロセスでこれを計算する手続きを書きなさい。
;
; [回答](exercises/1.12.scm)
;
; ### 問題 1.13
;
; phiを黄金比=(1+root 5)/2として、Fib(n)が phi^n / root 5 に一番近い整数で
; あることを証明しなさい。
; ヒント：psi = (1-root 5)/2 として、Fib(n) = (phi^n - psi^n)/ root 5なことを示せ。
;
; [回答](exercises/1.13.scm)
;
; 1.2.3 増加のオーダー
; --------------------
;
; 計算のプロセスによって、ステップ数とか領域量の消費の仕方は
; ぜんぜん違う。それを表すには増加のオーダーを使うのがいい。
;
; nを問題のサイズ、R(n)を使うリソースの量とする。
; なにをもって問題のサイズとするかは、問題の種類によって変わってくる。
; フィボナッチ数列なら何番目か、ニュートン法での近似値計算なら求める桁数、
; 行列計算なら行列の列の数とかが考えられる。
; リソースの量も同様。レジスターの数かもしれないし、CPUの演算の回数かも
; しれない。一回のステップにやる演算の数が一定なら、計算にかかる時間は
; 演算の数に比例する。
;
; n によらない定数 k1 と k2があって、十分大きな任意のnに対して
; k1 f(n) <= R(n) <= kn f(n) となるとき、
; R(n) の増加のオーダーは &Theta;(f(n))だという。
;
; ようするに f(n) とたかだか定数倍しか違わないってこと。
;
; たとえば階乗の線形再帰プロセスでの計算のステップはnに比例してたので、
; オーダーは&Theta;(n)だ。領域量も &Theta;(n)だった。繰り返しプロセス
; だとステップは &Theta;(n) だけど領域はなんと &Theta;(1)だった。
; 木再帰プロセスだと &Theta;(&Phi;^n) で、領域量は &Theta;(n)だった。
;
; オーダーはすごいおおざっぱな情報しか示さない。
; n^2も 1000*n^2 も3*n^2 + 10*n + 17 もぜんぶ &Theta;(n^2)だ。
; そのかわり、サイズが変わると必要なリソースがどう変わるかのいい指標に
; なる。
; &Theta;(n)ならnが2倍になればリソースも2倍だし、&Theta;(2^n)ならnが1
; 増えるとリソースは2倍になる。&Theta;(log n)ならnが2倍になっても
; リソースは定数分増えるだけだ。
;
; ### 問題 1.14
;
; 両替の問題で11セントをやったときの計算プロセスがどうなるか描きなさい。
; ステップと領域量のオーダーは？
;
; [回答](exercises/1.14.scm)
;
; ### 問題 1.15
;
; sin x を計算するためには
; sin x = 3 sin (x/3) - 4 sin^3 (x/3)
; で sin の引数を小さくしていって、十分小さくなったら
; sin x ~ x の近似で sin x = xとしてやればいい。

(define (cube x) (* x x x))
(define (p x) (- (* 3 x) (* 4 (cube x))))
(define (sine angle)
   (if (not (> (abs angle) 0.1))
       angle
       (p (sine (/ angle 3.0)))))

; a. (sine 12.15) を評価すると p が何回適用されるか？
; b. (sine a)のステップ数と領域量のオーダーは？
;
; [回答](exercises/1.15.scm)
;
; 1.2.4 べき乗
; ------------
;
; べき乗の計算は普通に書くとこうなる。

(define (expt b n)
  (if (= n 0)
      1
      (* b (expt b (- n 1)))))

; これは計算量がO(n)で領域量がO(n)。
; 繰り返しプロセスにするのも簡単。

(define (expt b n)
  (expt-iter b n 1))

(define (expt-iter b counter product)
  (if (= counter 0)
      product
      (expt-iter b
                (- counter 1)
                (* b product)))) 

; こっちは計算量がO(n)で領域量はO(1)
;
; ただし頭がいい方法があって、b^8 なら

b^2 = b * b
b^4 = b^2 * b^2
b^8 = b^4 * b^4

; みたいにすればかけ算は3回で住む。つまりO(log n)。
; 一般化すると、

b^n = (b^(n/2))^2  ; b が偶数
b^n = b * b^(n-1)  ; b が奇数

; となるから

(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((even? n) (square (fast-expt b (/ n 2))))
        (else (* b (fast-expt b (- n 1))))))

(define (even? n)
  (= (remainder n 2) 0))

; で計算できる。
; 繰り返しプロセスでも計算できるけど、再帰的な書き方みたいに
; まっすぐ書くのは難しい。
;
; ### 問題 1.16
;
; fast-expt を繰り返しプロセスで書き直しなさい。
; ヒント：
; 最終的に答えを表すことになる変数を a として、
; aを1から始めて、ステップが進んでも a * b^n が一定となるように
; aを変化させていく。その際に (b^(n/2))^2 = (b^2)^(n/2) を使う。
;
; [回答](exercises/1.16.scm)
;
; ### 問題 1.17
;
; かけ算は足し算の繰り返しで計算できる。こんなふうに。

(define (* a b)
  (if (= b 0)
      0
      (+ a (* a (- b 1)))))

; 2倍にするdoubleと半分にするhalveを使って、
; fast-exptみたいにO(log n)なfast-multをつくりなさい。
;
; [回答](exercises/1.17.scm)
;
; ### 問題 1.18
;
; 問題1.16と1.17の結果から、O(log n)でかけ算する繰り返しプロセスな
; 手続きをつくりなさい。
; adding, doubling, halving を使って。
;
; [回答](exercises/1.18.scm)
;
; ### 問題 1.19
;
; Fib(n)を賢く計算する方法がある。
; a <- a + b
; b <- a
; な変換をTとすると、T^n(1,0) = (Fib(n+1),Fib(n))となる。
; Tを一般化して T(p,q) として
; a <- bq + aq + ap
; b <- bp + aq
; とすると、TはT(0,1)と同じ。
; 
; 1. T^2(p,q) は T(P,Q) と同じなことを示せ。その際の P と Q は？
; 2. その結果を使って fib を以下のように定義したときの <??> を埋めなさい。

(define (fib n)
  (fib-iter 1 0 0 1 n))
(define (fib-iter a b p q count)
  (cond ((= count 0) b)
        ((even? count)
         (fib-iter a
                   b
                   ??      ; compute p'
                   ??      ; compute q'
                   (/ count 2)))
        (else (fib-iter (+ (* b q) (* a q) (* a p))
                        (+ (* b p) (* a q))
                        p
                        q
                        (- count 1)))))

; [回答](exercises/1.19.scm)
