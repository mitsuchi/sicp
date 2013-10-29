; (define s (make-monitored sqrt))
;
; (s 100)
; 10
; (s 100)
; 10
; 
; (s 'how-many-calls?)
; 2
; 
; みたいに呼ばれた回数を覚えてるバージョンの手続きを返すような
; make-monitored を定義しなさい。

(define (make-monitored proc)
  (let ((num-calls 0))
    (define (monitored arg)
      (if (eq? arg 'how-many-calls?)
	  num-calls
	  (begin
	    (set! num-calls (+ 1 num-calls))
	    (proc arg))))
    monitored))
      
(define s (make-monitored sqrt))

(print (s 100))
; 10
(print (s 100))
; 10
(print (s 'how-many-calls?))
; 2
