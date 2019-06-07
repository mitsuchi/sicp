; 問題 2.5
; 
; aとbの対を積2^a * 3^bである整数で表現するなら, 非負の整数の対は数と算術演算だけを
; 使って表現出来ることを示せ. これに対応する手続き cons, carおよびcdrの定義は何か. 

; cons は明らかに数と演算で生成できる。car, cdr は2または3で何回割れるかで表せる。

(define (cons a b)
  (* (power 2 a)
     (power 3 b)))

(define (power x y)
  (if (= y 0)
      1
      (* x (power x (- y 1)))))
  
(define (car x)
  (num-dev x 2))

(define (cdr x)
  (num-dev x 3))  

(define (num-dev n a)
  (if (> (mod n a) 0)
      0
      (+ 1 (num-dev (div n a) a))))

(display (power 2 3))
(newline)
(display (cons 4 5))
(newline)
(display (num-dev 24 2))
(newline)
(display (car (cons 4 5)))
(newline)
(display (cdr (cons 4 5)))
(newline)
