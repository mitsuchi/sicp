(define balance 100) ; balanceが口座残高

(define (withdraw amount)
  (if (>= balance amount)
      (begin (set! balance (- balance amount))
             balance)
      "Insufficient funds"))

;(print (withdraw 30))
;(print (withdraw 30))

(define new-withdraw
  (let ((balance 100))
    (lambda (amount)
      (if (>= balance amount)
          (begin (set! balance (- balance amount))
                 balance)
          "Insufficient funds"))))

;(print (new-withdraw 30))
;(print (new-withdraw 30))

(define (make-withdraw balance)
  (lambda (amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds")))

(define W1 (make-withdraw 100))
(define W2 (make-withdraw 100))
;(W1 50)
;50
;(W2 70)
;30
;(W2 40)
;"Insufficient funds"
;(W1 40)
;10

(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch m)
    (cond ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          (else (error "Unknown request -- MAKE-ACCOUNT"
                       m))))
  dispatch)

(define acc (make-account 100))
;((acc 'withdraw) 50)
;50
;((acc 'withdraw) 60)
;"Insufficient funds"
;((acc 'deposit) 40)
;90
;((acc 'withdraw) 60)
;30

(define acc2 (make-account 100))
; とすると acc と acc2 は完全に独立なことに注意。
