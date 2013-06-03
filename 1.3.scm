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

;
