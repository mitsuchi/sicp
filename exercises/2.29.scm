; 問題 2.29

; 二進モービルは, 左の枝と右の枝の二つの枝で出来ている.
; それぞれの枝はある長さの棒で, そこから錘か, 別の二進モービルがぶら下っている.
; 二進モービルを二つの枝から(例えばlistを使って)出来ている合成データで表現出来る:

(define (make-mobile left right)
  (list left right))

; 一つの枝はlength(数でなければならない)と, (単なる錘を表現する)数か別のモービルかであるstructureで構成する:

(define (make-branch length structure)
  (list length structure))

; a. これに対応する選択子(モービルの枝を返す)left-branchと right-branchと, (枝の部品を返す)branch-lengthと branch-structureを書け. 

(define (left-branch mobile)
    (car mobile))

(define (right-branch mobile)
    (car (cdr mobile)))

(define (branch-length branch)
    (car branch))

(define (branch-structure branch)
    (car (cdr branch)))

; b. この選択子を使い, モービルの全重量を返す手続きtotal-weightを定義せよ. 

(define (total-weight mobile)
    (+ (total-weight-branch (left-branch mobile))
       (total-weight-branch (right-branch mobile))))

(define (total-weight-branch branch)
    (let ((bs (branch-structure branch)))
        (if (list? bs)
            (total-weight bs)
            bs)))

; mobile1 を以下のように定義してみる
;             |
;      +------+---+
;      |          |
;   +--+-+        30
;   |    |
;   10   20

(define mobile1
    (make-mobile
        (make-branch 6 
            (make-mobile
                (make-branch 2 10)
                (make-branch 1 20)))
        (make-branch 3 30)))
        
(display (total-weight mobile1))
(newline)

; c. モービルは最上段左の枝による回転力と, 最上段右の枝による回転力が等しく,
; (つまり左の棒の長さと棒の左にかかっている重さを掛けたものが右側の対応する積に等しく,)
; しかも枝にぶら下っている部分モービルのそれぞれが釣合っている時, 釣合っている(balanced)という.
; 二進モービルが釣合っているかどうかをテストする述語を設計せよ. 

(define (balanced? mobile)
    (and
        (= 
            (moment (left-branch mobile))
            (moment (right-branch mobile)))
        (balanced-branch? (left-branch mobile))
        (balanced-branch? (right-branch mobile))
    )
)

(define (balanced-branch? branch)
    (if (list? (branch-structure branch))
        (balanced? (branch-structure branch))
        #t))

(define (moment branch)
    (*
        (branch-length branch)
        (total-weight-branch branch)))

(display (balanced? mobile1))  ; #f
(newline)

; mobile2 : つりあってるやつの例
;             |
;      +------+---+
;      |          |
;   +--+-+        60
;   |    |
;   10   20

(define mobile2
    (make-mobile
        (make-branch 6 
            (make-mobile
                (make-branch 2 10)
                (make-branch 1 20)))
        (make-branch 3 60)))

(display (balanced? mobile2))  ; #t
(newline)

; d. 構成子が

(define (make-mobile2 left right)
  (cons left right))

(define (make-branch2 length structure)
  (cons length structure))

; となるようにモービルの表現を変更したとする. 
; 新しい表現に対応するにはプログラムをどのくらい変更しなければならないか. 

; 4つの選択子だけ以下のように変えればいい。

(define (left-branch2 mobile)
    (car mobile))

(define (right-branch2 mobile)
    (cdr mobile))

(define (branch-length2 branch)
    (car branch))

(define (branch-structure2 branch)
    (cdr branch))

; 抽象化の壁のおかげ！