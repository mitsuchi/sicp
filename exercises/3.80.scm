; 問題 3.80
;
; 引数として回路のパラメタR, LおよびCと, 時間増分dtをとる手続きRLCを書け. 問題3.73のRC手続きと同様に, RLCは状態変数vC0とiL0の初期値をとり, 状態vCとiLのストリームの対(consを使う)を生じる手続きを生じるものとする. このRLCを使って, R=1オーム, C=0.2ファラド, L=1ヘンリ, dt=0.1秒, 初期値iL0=0アンペア, vC0=10ボルトの直列RLC回路の振舞いをモデル化する一対のストリームを生成せよ. 

(load "./stream.scm")

(define (RLC r l c dt)
  (define (solve-rlc vc0 il0)
    (define vc (integral (delay dvc) vc0 dt))
    (define il (integral (delay dil) il0 dt))
    (define dvc (scale-stream il (/ -1 c)))
    (define dil (add-streams (scale-stream vc (/ 1 l))
			     (scale-stream il (/ (* -1 r) l))))
    (cons vc il))
  solve-rlc)

(define solver (RLC 1 1 0.2 0.1))
(define vc-il (solver 10 0))
;(define solver (RLC 1 10 0.2 0.1))
;(define vc-il (solver 10 0))
(display-stream (stream-take 100 (cdr vc-il)))
;(display-stream (stream-take 100 (stream-map (lambda (a b) (list a b)) (car vc-il) (cdr vc-il))))
;gosh exercises/3.80.scm | sed -e 's/[()]//g' | plot
