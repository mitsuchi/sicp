; 1.3 高階関数をつかって抽象化する
; ------------------------
;
; 手続きは、抽象化の手段の1つだということを見てきた。

(define (cube x) (* x x x))

; と定義しておけば、

(* 3 3 3)
(* x x x)
(* y y y)       

; と毎回書かなくていい。こんなふうに一番基本的な要素まで
; 還元した書き方しかできなかったとしたら、3乗の計算はできても
; 3乗という考え方を表現できないのと一緒だ。
;
; よくあるパターンに名前をつけて抽象化して、直接その名前で
; 計算できると便利で、手続きはその手段の1つだ。
; 
; 手続きの引数に手続きを渡したり、返り値が手続きだったりできると
; さらに便利だ。そういうのを高階関数という。
;
; 1.3.1 引数としての手続き
; ------------------------
;
; aからbまで足し算する手続きはこんなだ。

(define (sum-integers a b)
  (if (> a b)
      0
      (+ a (sum-integers (+ a 1) b))))

; aからbまで、3乗したものを足すのはこう。

(define (sum-cubes a b)
  (if (> a b)
      0
      (+ (cube a) (sum-cubes (+ a 1) b))))

; aからbまで、1/1*3 + 1/5*7 + 1/9*11 みたいに足して行くのはこう。
; ちなみにこれは PI/8 にゆっくり収束する。

(define (pi-sum a b)
  (if (> a b)
      0
      (+ (/ 1.0 (* a (+ a 2))) (pi-sum (+ a 4) b))))

; この3つはすごくよく似てる。同じパターンだ。
; 同じところを括りだして一般化するとこうだ。

(define (<name> a b)
  (if (> a b)
      0
      (+ (<term> a)
         (<name> (<next> a) b))))

; それぞれの項をどういじるか？が term。
; 次の a は何か？が next。
; こういうふうなパターンがあるってことは抽象化できるってことだ。
; つまりこう。
;
; 数列の和:
; Sigma{n=a}{b}f(n) = f(a) + ... + f(b)
; 
; さしあたっては、上の一般化をそのまま使ってみる。

(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))

; term と next は上で書いた意味の手続きだ。
; すると sum-cubes はこう書ける。

(define (inc n) (+ n 1))
(define (sum-cubes a b)
  (sum cube a inc b))

; 結果はたとえばこう。
(sum-cubes 1 10)
3025

; 単なる足し算はこんなふうに書ける。

(define (identity x) x)
(define (sum-integers a b)
  (sum identity a inc b))

(sum-integers 1 10)
55

; pi-sumも同様。

(define (pi-sum a b)
  (define (pi-term x)
    (/ 1.0 (* x (+ x 2))))
  (define (pi-next x)
    (+ x 4))
  (sum pi-term a pi-next b))

; 円周率の近似を計算してみるとこう。

(* 8 (pi-sum 1 1000))
3.139592655589783

; sum を他の部品にすることもできる。
; たとえば、a から b までの f(x) の定積分はこんなふうに近似できる。
;
; dx * ( f(a+dx/2) + f(a+dx+dx/2) + f(a+2dx+dx/2) .. )
;
; sum を使うとこう

(define (integral f a b dx)
  (define (add-dx x) (+ x dx))
  (* (sum f (+ a (/ dx 2.0)) add-dx b)
     dx))

(integral cube 0 1 0.01)
.24998750000000042
(integral cube 0 1 0.001)
.249999875000001

; ちなみに x^3 の 0 から 1 までの定積分の値は 1/4 だ。
;
; ### 問題 1.29
;
; シンプソンの法則を使うと定積分がもっと正確に計算できる
;
; h/3*(y0+4y1+2y2+4y3+2y4+ ... + 2y(n-2)+4y(n-1) + yn)
;
; ただし h = (b-a)/n (nは偶数)、yk = f(a+kh)
;
; f, a, b, n を受け取って定積分を計算する手続きを作りなさい。
; x^3 の0から1の定積分を n = 100 と n = 1000 の場合で計算して
; 上と比較しなさい。
;
; ### 問題 1.30
; 
; 上の sum手続きが線形再帰なので、線形反復に書き換えなさい。
; ヒントはこちら。

(define (sum term a next b)
  (define (iter a result)
    (if <??>
        <??>
        (iter <??> <??>)))
  (iter <??> <??>))

; ### 問題 1.31
;
; a. sum の類推で、かけ算する product 手続きを作りなさい。
; factorial を product を使って作りなさい。
; それから Pi を以下の公式を使って計算しなさい。
;
; Pi/4 = 2/3 * 4/3 * 4/5 * 6/5 * 6/7 * 8/7 ...
;
; b. つくった product が線形再帰なら、線形反復にしてみなさい。
; 反復なら再帰で。
;
; ### 問題 1.32
; 
; a. sum も product も抽象化できて、accumulate を使って
; (accumulate combiner null-value term a next b)
; みたいに計算できる。accumulate手続きを定義しなさい。
;
; b. つくった手続きが線形再帰なら、線形反復にしてみなさい。
; 反復なら再帰で。
; 
; ### 問題 1.33
;
; filter っていうのを考えることで、accumulate はさらに一般化できる。
; (filterd-accumulate combiner null-value term a next b filter)
; filter は、term が特定の条件を満たすときだけ真になって、その時だけ
; accumulate に効いてくるようにする。
; これを使って以下を計算しなさい。
; 
; a. a から b までの素数の二乗の和
; b. n以下のnと互いに素な数の積
;
; 1.3.2 Lambdaをつかって手続きを作る
; ----------------------------------
;
; 1.3.1 で定義した pi-term とかは、考えてみるとばかくさい。
; わざわざ名前をつけるまでもない。
; そういう場合には lambda が使える。

(lambda (x) (+ x 4))

; と書けば、「xをとって、x+4を返す手続き」とダイレクトに記述できる。
; pi-sum はこうなる。

(define (pi-sum a b)
  (sum (lambda (x) (/ 1.0 (* x (+ x 2))))
       a
       (lambda (x) (+ x 4))
       b))

; integral も add-dx がいらなくなる。

(define (integral f a b dx)
  (* (sum f
          (+ a (/ dx 2.0))
          (lambda (x) (+ x dx))
          b)
     dx))

; lambda は define と同じように手続きが作れる。
; ただし作られた手続きには名前がない。
; 一般形はこう。

(lambda (<formal-parameters>) <body>)

(define (plus4 x) (+ x 4))

; は、以下と同じだ。

(define plus4 (lambda (x) (+ x 4)))

; もちろんオペレーターとしても使える。

((lambda (x y z) (+ x y (square z))) 1 2 3)
12

; もっと一般的に、手続きの名前を書けるところには
; どこでも書ける。
;
; ### let で局所変数を作る

(let ((<var1> <exp1>)
      (<var2> <exp2>)
      ...      
      (<varn> <expn>))
   <body>)

; と書くと、bodyから参照できる局所変数として、 var1 .. varn 
; までを定義できる。その値はそれぞれ exp1 .. expn。
; これは次のように書くのと同じだ。でも読みやすく書きやすい。

((lambda (<var1> ...<varn>)
    <body>)
 <exp1>
 ... 
 <expn>)

; var1 .. varn のスコープは body の中だけだ。なので次のようになる。
;
; 1. x が 5 のとき

(+ (let ((x 3))
     (+ x (* x 10)))  ; x は 3。なので 33
   x)                 ; x は 5

; の値は38になる。
;
; 2. exp1 .. expn の値は let の外の値で計算される。
; たとえば x が 2のとき

(let ((x 3)
      (y (+ x 2)))  ; x は 2 だから y は 4
  (* x y))          ; 3 * 4 だから 12

; ### 問題 1.34
; f がこんなだとする。

(define (f g)
  (g 2))

; たとえば

(f square)
4

(f (lambda (z) (* z (+ z 1))))
6

; 次の式はどうなる？

(f f)

; 1.3.3 一般的なメソッドとしての手続き
; ------------------------------------
;
; 
