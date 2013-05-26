; 1.1 プログラムの要素
; ====================
; 
; よくできたプログラム言語は、ただコンピュータに命令をするだけじゃなくて
; 考え方のフレームワークになる。
; 言語をみるときは、小さいアイデアを複雑なアイデアに組み立てるための手段に
; 注目するといい。
; よくできた言語はそのための3つの方法を必ず持っている。
;
; 1. 基本要素        ：一番かんたんな要素、3とか"hoge"とか。
; 2. 組み合わせの手段：かんたんな要素から複雑な要素をつくる方法。
; 3. 抽象化の手段    ：複雑な要素に名前をつけて、単位として扱う手段。
;
; プログラムでは2つのことを扱う。手続きとデータだ。
; データは「もの」。手続きはものの扱いかた。
; 簡単なデータから複雑なデータをつくるやり方や
; 簡単な手続きから複雑な手続きをつくるやり方が必ずある。
;
; この章では簡単のためにデータとして数値だけを扱う。
; 複雑なデータでも、同様に手続きをつくれることが後で分かる。
;
; 1.1.1 式
; --------
;
; Scheme に慣れるために、インタープリターに式を食わせてみよう。
; 基本要素の1つは、数値だ。

486

; は、486と返す。
; 数値は、基本手続きである * とか + を使って、複合した式にできる。

(+ 137 349)
486
(- 1000 334)
666
(* 5 99)
495
(/ 10 5)
2
(+ 2.7 10)
12.7

; など。
; 手続きの適用のためのこういう式をコンビネーションという。
; 一番左の要素がオペレーター、その他はオペランドという。
; コンビネーションの値は、オペレーターで表される手続きに、
; オペランドの値を適用して得られる。
;
; オペレーターが一番左にあるような記法を前置記法という。
; 利点の1つは、引数がどれだけ長くてもいいこと。

(+ 21 35 12 7)
75

(* 25 4 12)
1200

; 2つ目の利点は、コンビネーションをそのままネストできること。

(+ (* 3 5) (- 10 6))
19

; ネストの深さには原理的には制限がない。

(+ (* 3 (+ (* 2 4) (+ 3 5))) (+ (- 10 7) 6))

; って書くと混乱するけど、インタープリターにとっては問題ない。
; 人間用の表記として、

(+ (* 3
      (+ (* 2 4)
         (+ 3 5)))
   (+ (- 10 7)
      6))

; みたいにインデントすると見やすい。
; どんなに複雑な式でも、インタープリターがそれを扱う方法は決まってる。
; 式を読み取って、評価して、値を出力する。
; こういうモードを REPL -- read-eval-print loop という。
;
; 1.1.2 名前と環境
; ----------------
;
; 計算の対象となるオブジェクトに名前をつけることができる。
; 名前は変数を区別する。変数の値はオブジェクトだ。

(define size 2)

; とすると、2という値にsizeという名前がひもづけられる。
; すると size という名前でその値を参照できる。

size
2
(* 5 size)
10

; その他の例。

(define pi 3.14159)
(define radius 10)
(* pi (* radius radius))
314.159
(define circumference (* 2 pi radius))
circumference
62.8318

; defineは、もっとも簡単な抽象化の手段だ。
; 複雑な結果にかんたんな名前をつけることができる。
;
; 計算のステップが進むほど、オブジェクトは複雑になっていく。
; それらに名前をつけて単位として扱うことで一歩ずつプログラムを
; 組んで行くことができる。
;
; 名前と値をひもづけておくためのメモリーのことを環境という。
; 環境は複数つくられる。ここまでの例の場合は正確にはグローバル環境という。
;
; 1.1.3 コンビネーションを評価する
; -------------------------------
;
; コンビネーションを評価するとき、インタープリター自体が次の手続きに従う。
;
; 1. コンビネーションに含まれる部分式を評価する
; 2. 一番左の部分式（オペレーター）の値に、その他の部分式の値を適用する
;
; このルールは再帰的なことに注意。
; 深くネストした計算は、ふつうのやりかただととても複雑になるけど再帰だと
; 簡単。たとえば、

(* (+ 2 (* 4 6))
   (+ 3 5 7))

; の評価の過程を図に書くと木のようになる。

*
  +
    2
    *      
      4
      6
  +
    3
    5
    7

; 部分評価の結果が木を登って行く感じ。
; こういうのを再帰で処理するのは簡単で、一般に木のアキュミュレーションという。
;
; 再帰の過程で基本要素を評価することになって、そこが末端になる。
; それは3パターンある。
;
; 1. 数の値はそれ自身が表す値
; 2. 組み込みオペレーターの値は、それを処理する機械語の列
; 3. 変数の値は、環境中にひもづけられたオブジェクト
;
; 2つめは3つめの特別な場合ともいえる。組み込みオペレーターがグローバル環境中に
; 定義されてると考えれば。環境がないと + がなにかともいえないのでとにかく重要。
;
; ただし上で書いた評価方法は、defineには使えない。

(define x 3)

; は define に x と 3 を適用するわけじゃない。
; こういうのは特別形式といって、それぞれ評価の方法が違う。
; define のほかにも後々でてくる。
;
; 1.1.4 複合手続き
; --------------------
;
; これまでに重要な要素を3つ見てきた。
;
; 1. 数値とか+みたいな手続きは基本的なデータと手続きだ
; 2. 手続きを組み合わせるには、コンビネーションをネストさせればいい
; 3. defineによる名前づけは抽象化の1つの手段
;
; こんどは関数定義について学ぼう。複雑な手続きに名前をつけて抽象化する
; 強力な手段だ。
;
; たとえば何かを2乗する関数はこう。

(define (square x) (* x x))

; これは、なにかを2乗するためには、その数どうしをかけなさいと読める。
; こういう square みたいのを複合手続きという。
; この define を評価すると、複合手続きをつくって、それに square という
; 名前を環境内でひもづける。
;
; 関数定義の一般的な形はこう。

(define (<name> <formal parameters>) <body>)

; <name>は関数にひもづいて環境に定義される名前、<formal parameters>は、
; 関数の本体で引数の値にひもづく名前、<body> は関数本体を表す式。
;
; squareをつかってみよう。

(square 21)
441

(square (+ 2 5))
49

(square (square 3))
81

; square を組み立ての単位とすることもできる。
; x^2 + y^2 はこう。

(+ (square x) (square y))

; それを表す関数はこうなる。

(define (sum-of-squares x y)
  (+ (square x) (square y)))

(sum-of-squares 3 4)
25

; sum-of-squares を単位とすることすらできる。

(define (f a)
  (sum-of-squares (+ a 1) (* a 2)))

(f 5)
136

; 複合手続きは基本手続きとまったく同じように使われ、
; 外部からそれらを区別することはできない。
;
; 1.1.5 置き換えモデルによる関数の適用
; ------------------------------------
;
; 基本手続きの処理はインタープリターに組み込まれてるとして、
; 複合手続きの処理は置き換えで考えることができる。
;
; つまり、複合手続きに引数を適用するには、手続きの本体にでてくる
; パラメーターを引数で置き換えればいい。
;
; 例えば次の式で考えてみよう。

(f 5)

; f の本体は

(sum-of-squares (+ a 1) (* a 2))

; なので、この a を 5で置き換えると

(sum-of-squares (+ 5 1) (* 5 2))

; になる。まず引数の部分式を先に評価して

(sum-of-squares 6 10)

; sum-of-squares の本体は

(+ (square x) (square y))

; だったから置き換えると

(+ (square 6) (square 10))

; 部分式を先に評価すると、square の本体は

(* x x)

; だったから、

(+ (* 6 6) (* 10 10))

; で

(+ 36 100)

; になって

136

; が答というわけ。こういうのを関数適用の置き換えモデルという。
; ここまでにでてきた関数においては、関数の適用の意味はこれでいい。
;
; ただし次の点に注意する。
; 1. ほんとにこの通りインタープリターが評価してるわけじゃない。
; 2. 置き換えモデルは、計算のモデルの一歩目にすぎない。
;    この後だんだんモデルを紹介して、そのたび実際のモデルに近づいていく。
;    たとえばこの後でやるミュータブルなデータだと置き換えモデルは破綻する。
; 
; ### 適用順と正規順
;
; さっきはオペランドを先に評価したけど、後から評価してもいいはずだ。
; 具体的には基本手続きまで展開されたらはじめて評価することもありうる。

(f 5)

; で試すとこうなる。

(sum-of-squares (+ 5 1) (* 5 2))

(+    (square (+ 5 1))      (square (* 5 2))  )

(+    (* (+ 5 1) (+ 5 1))   (* (* 5 2) (* 5 2)))

; ここで (+ 5 1 ) とかが基本手続きまで展開されつくしたので
; いよいよ評価していく。

(+         (* 6 6)             (* 10 10))

(+           36                   100)

                    136

; 同じ答えがでたけど、評価の過程は違ってる。
; とくに (+ 5 1)とかは2回も評価してる。
;
; こういうふうに、展開しきってから収束させるのを正規順という。
; これまでの、引数を評価してから適用させるのは適用順という。
; 置き換えモデルが有効な限り、どっちの順序も処理結果は同じ。
;
; Lispは適用順を使う。ひとつには、(+ 5 1)を2回評価するみたいな
; ムダを省きたいので。それに正規順での評価は一般的にはとても
; 複雑になりうる。でも正規順も強力なツールになるので後で扱う。
;
; 1.1.6 条件式と述語
; ------------------
;
; 条件分岐は cond 特別形式を使ってこう書く。

(define (abs x)
  (cond ((> x 0) x)
        ((= x 0) 0)
        ((< x 0) (- x))))

; 一般形はこう。

(cond (<p1> <e1>)
      (<p2> <e2>)
      ...
      (<pn> <en>))

; <p> の部分は真偽値となる式で、述語という。
; p1 から見て行って最初に真となったペアの ei が評価される。
; 最後まで述語が真にならかったら、全体の値は不定。

(define (abs x)
  (cond ((< x 0) (- x))
        (else x)))

; みたいに else とかけば、すべての条件に当てはまらなかった場合を
; 救える。こうも書ける。

(define (abs x)
  (if (< x 0)
      (- x)
      x))

; if は条件判断をする特別形式で一般形はこう。

(if <predicate> <consequent> <alternative>)

; predicate が真なら consequent、偽なら alternative が評価される。
; 論理演算として次がある。

(and <e1> ... <en>)
(or <e1> ... <en>)
(not <e>)

; それぞれ 論理積、論理和、否定。
; and と or は特別形式なので、必ずしもすべては評価されない。
; and なら最初に偽になればそれ以降、or なら最初の真以降は評価の必要ない。

(and (> x 5) (< x 10))

; は、x が 5より大きくて 10より小さいか？

(define (>= x y)
  (or (> x y) (= x y)))

; は、等しいか大きいを表す手続きで、こうも書ける。

(define (>= x y)
  (not (< x y)))

; ### 問題 1.1
; 
; 以下を評価したときの結果は？上から順番にやったとして。

10
(+ 5 3 4)
(- 9 1)
(/ 6 2)
(+ (* 2 4) (- 4 6))
(define a 3)
(define b (+ a 1))
(+ a b (* a b))
(= a b)
(if (and (> b a) (< b (* a b)))
    b
    a)
(cond ((= a 4) 6)
      ((= b 4) (+ 6 7 a))
      (else 25))
(+ 2 (if (> b a) b a))
(* (cond ((> a b) a)
         ((< a b) b)
         (else -1))
   (+ a 1))

; ### 問題 1.2
; 
; 問題文省略
;
; ### 問題 1.3
;
; 関数をつくりなさい。3つの引数をとって、大きい2つの二乗の和を返すようなやつ。
;
; ### 問題 1.4
;
; コンビネーションのオペレーターは複合式でもいい。
; ということを踏まえて次が何をやってるか説明せよ。

(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))

; ### 問題 1.5
; 
; 使ってるインタープリターが適用順か正規順かを区別するテストとして
; 次のようなものを思いついた。

(define (p) (p))

(define (test x y)
  (if (= x 0)
      0
      y))

; そのうえで、以下を評価する。

(test 0 (p))

; 適用順と正規順でなにが起こるか？
;
; 1.1.7 例：ニュートン法で平方根を求める
; --------------------------------------
;
; 手続きは数学の関数に似てるけど、違いは効果的じゃなきゃいけないってことだ。
; たとえば平方根を考えてみる。平方根は、二乗したらそれになる数と定義できる。
; でもどうやって求めたらいいかは定義からは分からない。

(define (sqrt x)
  (the y (and (>= y 0)
              (= (square y) x))))

; と定義をLispでも書いてみても意味はない。
; 関数と手続きの違いは、「何であるか」と「どうやって」の違い、または宣言的か
; 命令的かの違いだ。
; 
; 平方根を「どうやって」計算するか？
; ニュートン法を使えばいい。
; xの平方根の推測yがあるとき、y' = (y+x/y)/2 とすると y' は y よりもいつも
; xの平方根に近い。だからこれを繰り返せばどんどん真の値に近づく。
; たとえばこう。

1
1.5  
1.4167
1.4142
......

; これを手続きで書くとこんな。

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
                 x)))

; 推測値が十分に真の値に近ければそれを答えとする。
; そうじゃなかったら推測値を一回改善して同じことをする。

(define (improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

; が improve と averageの定義。
; 真の値に近いかどうかはたとえば次でいい。

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

; あとは平方根を求める本体の手続きだ。推測値は1から始める。

(define (sqrt x)
  (sqrt-iter 1.0 x))

; 評価してみるとこんなふうになる。

(sqrt 9)
3.00009155413138

(sqrt (+ 100 37))
11.704699917758145

(sqrt (+ (sqrt 2) (sqrt 3)))
1.7739279023207892

(square (sqrt 1000))
1000.000369924366

; Cでいうwhileみたいな繰り返しを使わなくても、繰り返しの計算ができてることに注意。
;
; ### 問題 1.6
;
; if はどうして特別形式じゃないといけないのか？
; たとえば cond をつかって普通の手続きで定義したらこうなる。

(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))

; こんなふうに動く

(new-if (= 2 3) 0 5)
5

(new-if (= 1 1) 0 5)
0

; じゃあ sqrt-iter をこう書きかえたらどうなるか？説明しなさい。

(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)
          guess
          (sqrt-iter (improve guess x)
                     x)))

; ### 問題 1.7
;
; good-enough?はxが小さすぎるときや大きすぎる時は効果的じゃない。
; どんなときにテストに失敗するか実例でしめしなさい。
; 改善案は、guessがほとんど変化しなくなったこと検知すること。
; 実装して、小さい値と大きい値についてうまく動くかやってみなさい。
;
; ### 問題 1.8
;
; xの立法根の推測yについてのyの改善はこんなふうになる。
; y' = (x/y^2 + 2*y)/3
; これを元に立方根を求めてみなさい。
;
; 1.1.18 ブラックボックス抽象化としての手続き
; -------------------------------------------
;
; sqrtは再帰的な手続きだけど、なぜこれでうまく行くのはまだはっきり
; 分からないかもしれない。それは1.2章でやる。
; 
; sqrt がいくつかの副問題に分かれたことに注意。

sqrt
  sqrt-iter
  good-enough
    square
    abs
  improve
    average  

; のような構造になっていた。
; これは、問題がたんにいくつかの部分に分かれるというだけの意味じゃない。
; あとで使い回しが効くような、個々の仕事に分ける事ができるということが大事。
; 仕事の依頼元から見ると、内部で何をやっているかは知らないし、知らなくもいい。
; ブラックボックスなんだけど、とにかくインターフェースだけ分かってるという状態。
; たとえば以下の二つのsquareは、内部は違うけど外部からは同じ手続き。

(define (square x) (* x x))

(define (square x) 
  (exp (double (log x))))

(define (double x) (+ x x))

; ### 局所名
;
; 手続きを使う側にとって、実装での引数名は知らなくてもいい情報。
; だから次の2つは同じ。

(define (square x) (* x x))
(define (square y) (* y y))

; 手続きの意味は、その引数名と関係ないという原理を認めると、
; 手続きの引数名はその本体の中で局所的じゃないといけないことが分かる。
; たとえば good-enough? では square を使った。

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

; square の中で引数名として x を使ったとしても、それは good-enough? の中の
; x と干渉しちゃいけない。
; そうじゃなかったら、squareでxを使ってないか？と気にしないといけないから、
; ブラックボックスにならない。
;
; 手続きの引数名は束縛変数という。手続きの定義は、引数を引数の値に束縛する。
; 本体の中に、引数に現れない変数があったら、それは自由変数という。
; 
; 変数が束縛される範囲（式の集合）をスコープという。
; 手続きの定義だと、引数名のスコープは手続きの本体だ。
;
; たとえば good-enough? だと、guess と x が束縛変数。
; < と abs、-、square は自由変数だ。
;
; good-enough の意味は、束縛変数が変わっても、たとえば x が y になっても変わらない。
; でも自由変数が変わったら、たとえば square が double になったら全然変わってしまう。
;
; ### 内部定義とブロック構造
;
; sqrtのプログラムをまとめるとこんなふうだ。

(define (sqrt x)
  (sqrt-iter 1.0 x))
(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x) x)))
(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))
(define (improve guess x)
  (average guess (/ x guess)))

; ユーザーにとって大事なのは sqrt だけなのに、sqrt-iter とか good-enough?
; とかがグローバル環境にこぼれてる。
; しかもsqrt-iterは、他の手続きでも使える汎用なモジュールじゃない。
; だからもっと大規模で何人もがつくるプログラムだと問題が大きくなる。
; improveみたいな名前が衝突するかもしれないからだ。
; なので、手続きの内部に手続きを定義することができる。

(define (sqrt x)
  (define (good-enough? guess x)
    (< (abs (- (square guess) x)) 0.001))
  (define (improve guess x)
    (average guess (/ x guess)))
  (define (sqrt-iter guess x)
    (if (good-enough? guess x)
        guess
        (sqrt-iter (improve guess x) x)))
  (sqrt-iter 1.0 x))

; こういうのはブロック構造という。
; これで、内部の improve は外に漏れることはない。
; もっといいのは、引数をシンプルにできることだ。

(define (sqrt x)
  (define (good-enough? guess)
    (< (abs (- (square guess) x)) 0.001))
  (define (improve guess)
    (average guess (/ x guess)))
  (define (sqrt-iter guess)
    (if (good-enough? guess)
        guess
        (sqrt-iter (improve guess))))
  (sqrt-iter 1.0))

; x を good-enough? の自由変数とすることで、明示的に引数に入れなくてよくなる。
; ブロック構造は Algol 60 が始めた。プログラムを構造化するのにとても便利。
