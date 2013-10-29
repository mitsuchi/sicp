; make-accountをいじって、
; (define acc (make-account 100 'secret-password))
; みたいにパスワードつきの口座を作れるようにしなさい。
;
; セッションの例。
; ((acc 'secret-password 'withdraw) 40)
; 60
; ((acc 'some-other-password 'deposit) 50)
; "Incorrect password"

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

(define acc (make-account 100 'secret-password))
(print ((acc 'secret-password 'withdraw) 40))
; 60
((acc 'some-other-password 'deposit) 50)
; "Incorrect password"
