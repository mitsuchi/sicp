; 問題 3.77

; 上で使ったintegral手続きは, 3.5.2節の整数の無限のストリームの「暗黙の」定義に似ている. 別の方法として (やはり3.5.2節の) integers-starting-fromに更によく似たintegralの定義を与えることが出来る:

(load "./stream.scm")

(define (integral0 integrand initial-value dt)
  (cons-stream initial-value
               (if (stream-null? integrand)
                   the-empty-stream
                   (integral0 (stream-cdr integrand)
                             (+ (* dt (stream-car integrand))
                                initial-value)
                             dt))))

;ループのあるシステムで使うと, この手続きにはintegralの初版と同じ問題がある. この手続きを修正し, integrandを遅延引数としてとり, 上のsolve手続きで使えるようにせよ. 

(define (integral delayed-integrand initial-value dt)
  (cons-stream initial-value
	       (let ((integrand (force delayed-integrand))) ; 第２項以降のときのみforce する
		 (if (stream-null? integrand)
		     the-empty-stream
		     (integral (delay (stream-cdr integrand))
			       (+ (* dt (stream-car integrand))
				   initial-value)
				dt)))))

(define (solve f y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (stream-map f y))
  y)

(print (stream-ref (solve (lambda (y) y) 1 0.001) 1000))

