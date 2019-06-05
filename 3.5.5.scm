(load "./stream.scm")

; 3.5.5 関数的プログラムの部品化度とオブジェクトの部品化度
;
; 乱数列を生成する話をストリームでやってみる

(define random-numbers ; stream
  (cons-stream random-init
               (stream-map rand-update random-numbers)))

; 乱数のストリーム
;(display-stream (stream-take 100 random-numbers))

; cesaro 実験をやってみる。ランダムな2つの自然数が互いに疎な確率はPi/6というやつ。
; そこから逆に Pi を計算する。

(define (map-successive-pairs f s)
  (cons-stream
   (f (stream-car s) (stream-car (stream-cdr s)))
   (map-successive-pairs f (stream-cdr (stream-cdr s)))))

; (98734 1238787 1434 498242 .. )
; ↓ map-successive-pairs
; ( (f 98734 1238787) (f 1434 498242) .. )

(define cesaro-stream
  (map-successive-pairs (lambda (r1 r2) (= (gcd r1 r2) 1))
                        random-numbers))

; (display-stream (stream-take 10 cesaro-stream))

; (98734 1238787 1434 498242 .. )
; ↓ cesaro-stream
; (true false false true false .... )
;   1/1   1/2   1/3  2/4   2/5 

(define (monte-carlo experiment-stream passed failed)
  (define (next passed failed)
    (cons-stream
     (/ passed (+ passed failed))
     (monte-carlo
      (stream-cdr experiment-stream) passed failed)))
  (if (stream-car experiment-stream)
      (next (+ passed 1.0) failed)    ; 有理数表示にならないように 1.0 にした
      (next passed (+ failed 1.0))))

; (1 0.5 0.3 0.5 .. )

(define pi ; stream
  (stream-map (lambda (p) (sqrt (/ 6.0 p)))
              (monte-carlo cesaro-stream 0 0)))

;(display-stream (stream-take 1000 pi))

;(define pi314 (cons-stream 3.14 pi314))
;(display-stream (stream-take 1000 (stream-map (lambda (a b) (list a b)) pi pi314)))
;gosh 3.5.5.scm | sed -e 's/[()]//g' | plot

; この monte-carlo はかなりモジュール化されてて使い回しが効く。
; 代入も状態もない。
;
; 問題 3.81
; 問題 3.82

; 時の関数型プログラミング的視点
; ------------------------------
;
; 銀行口座の例をもう一回考える。

(define (make-simplified-withdraw balance)
  (lambda (amount)
    (set! balance (- balance amount)) ; balance が局所状態
    balance))

(define w1 (make-simplified-withdraw 100))
(w1 20) ; -> 80
(w1 30) ; -> 50

; これをストリーム化するとどうなる？

; 引き出しのストリームを入力として、残高のストリームを出力する
(define (stream-withdraw balance amount-stream)
  (cons-stream
   balance
   (stream-withdraw (- balance (stream-car amount-stream))
                    (stream-cdr amount-stream))))

(stream-withdraw 100 (list->stream '(20 30))) ; -> (80 50)

; amount-stream をだれかが順番に入力してると考えると、w1 のときと見た目に区別できない。
; ストリーム版には状態がない。でも、利用者には現在の残高（＝状態）があるように見える。
; すごい！でもそれは、利用者にとって時間が変化するから。ストリームとして見れば時間はない。
; (つまり、ストリームは時間ごとの状態を一覧にしたもの？）
;
; 状態を持つオブジェクトのモデルは直感的で便利。でも並列化は大変。
; 関数型で状態をなくせば並列化しやすい。
;
; 口座を共有する話をストリームで考えなおしてみる。
; 図
; 引き出しのストリーム二つを入力として、１つの残高のストリームを出力する
;
; ただし、どうやって混ぜ合わせたらいい？
; 交互じゃだめ。うまい方法がない。
;
; 状態と時間を持つオブジェクトモデルと、状態も時間もないストリームモデルは
; それぞれ利点と欠点がある。それらを統合したすばらしいモデルがあるかな？
