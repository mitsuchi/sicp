; ex 3.3の結果をいじって、共有口座が作れるようにしなさい。
;
; セッションの例
;
; (define peter-acc (make-account 100 'open-sesame))
; (define paul-acc
;  (make-joint peter-acc 'open-sesame 'rosebud))
; 
; ((peter-acc 'open-sesame 'withdraw) 10)
; 90
; ((paul-acc 'open-sesame 'rosebud) 20)
; 70

; 方針
; ----
; 
; 他人のパスワードを覚えておいて、他人になりすまして引き落とす。

(define (make-joint orig-acc orig-password new-password)
  (define (dispatch given-password m)
    (if (eq? given-password new-password)
	(orig-acc orig-password m))) ; なりすます
  dispatch)

(define (make-account balance password)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch given-password m) ; 追加
    (if (eq? given-password password) ; 追加
	(cond ((eq? m 'withdraw) withdraw)
	      ((eq? m 'deposit) deposit)
	      (else (error "Unknown request -- MAKE-ACCOUNT"
			   m)))
	(error "Incorrect password"))) ; 追加
  dispatch)

(define peter-acc (make-account 100 'open-sesame))
(print ((peter-acc 'open-sesame 'withdraw) 10))
; 90

(define paul-acc
  (make-joint peter-acc 'open-sesame 'rosebud))

(print ((paul-acc 'rosebud 'withdraw) 20))
; 70
