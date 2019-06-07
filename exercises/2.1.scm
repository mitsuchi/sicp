; 正負両方の引数を扱う改良版make-ratを定義せよ. make-ratは符号を正規化し, 有理数が正なら, 分子, 分母とも正, 有理数が負なら, 分子だけ負とする. 

(define (make-rat n d)
  (let ((n1 (normalize-n n d))
        (g (gcd (abs n) (abs d))))
    (cons (/ n1 g) (/ (abs d) g))))

(define (normalize-n n d)
  (if (< 0 (* n d))
    (abs n)
    (* -1 (abs n))))

(define (numer x) (car x))
(define (denom x) (cdr x))    

(define (print-rat x)
    (display (numer x))
    (display "/")
    (display (denom x))
    (newline))

(define a (make-rat 1 -3))

(print-rat a)