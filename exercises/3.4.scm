; 新しいmake-accountをいじって、
; 7回連続パスワードが違ってたら call-the-cops 手続きを呼ぶようにしなさい。

(define (make-account balance password)
  (define num-errors 0) ; 追加
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch given-password m)
    (if (eq? given-password password)
	(begin                               ; 追加
	  (set! num-errors 0)                ; 追加	  
	  (cond ((eq? m 'withdraw) withdraw)
		((eq? m 'deposit) deposit)
		(else (error "Unknown request -- MAKE-ACCOUNT"
			     m))))
	(begin 
	  (set! num-errors (+ 1 num-errors)) ; 追加
	  (if (= num-errors 7)
	      (call-the-cops)
	      (warn "Incorrect password")))))     ; 変更
  dispatch)

(define (warn message) ; 追加
  (print message)      ; 追加
  (lambda (arg) '()))  ; 追加

(define (call-the-cops) ; 追加
  (warn "タイ━━━━||Φ|(|´|Д|`|)|Φ||━━━━ホ"))    ; 追加

(define acc (make-account 100 'secret-password))
(print ((acc 'secret-password 'withdraw) 40))
; 60
((acc 'some-other-password 'deposit) 50)
; "Incorrect password"
((acc 'some-other-password 'deposit) 30)
((acc 'some-other-password 'deposit) 30)
((acc 'some-other-password 'deposit) 30)
((acc 'some-other-password 'deposit) 30)
;(print ((acc 'secret-password 'withdraw) 40))
((acc 'some-other-password 'deposit) 30)
((acc 'some-other-password 'deposit) 30)
