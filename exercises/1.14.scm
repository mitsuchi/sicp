; プロセス
; --------
; 手で展開したら死にそうになったので、
; ccの呼び出しのたびに再帰の深さに応じたインデントをつけて
; 引数を表示するようにして、実際に実行させてみた。

(define (count-change amount)
  (cc amount 5 0))
(define (cc amount kinds-of-coins depth)
  (print (make-string depth #\Space) "(cc " amount " " kinds-of-coins ") " depth)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (= kinds-of-coins 0)) 0)
        (else (+ (cc amount
                     (- kinds-of-coins 1)
					 (+ depth 1))
                 (cc (- amount
                        (first-denomination kinds-of-coins))
                     kinds-of-coins
					 (+ depth 1))))))
(define (first-denomination kinds-of-coins)
  (cond ((= kinds-of-coins 1) 1)
        ((= kinds-of-coins 2) 5)
        ((= kinds-of-coins 3) 10)
        ((= kinds-of-coins 4) 25)
        ((= kinds-of-coins 5) 50)))

(print (count-change 11))
; depth 15, step 56
;
; オーダー
; ----------------
; (cc a k)
; が
; (+ (cc a k-1) (cc a-d k))
; に展開されるので、
; 座標(a,k)の問題が座標(a,k-1)と(a-d,k)の問題に
; 帰着することになる。
; 再帰の深さはせいぜい a と k の大きい方
; だからほんとは領域量は O( max(n, k) ) か。
;
; ステップ数は、本来たかだか a * k なんだけど
; メモ化してないので大量に再計算が発生する。
; たとえば (cc a 2)の計算のためには、
; (cc a 1)の計算をO(a/d)回分やり直す。
; 同様に (cc a 3)のためには (cc a 2)をO(a/d')回分やり直す。
; なので O(a^k) になる。
