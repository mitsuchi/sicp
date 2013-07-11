; リストを先頭から見て、それぞれについて手続きを適用して結果を捨てる

(define nil (list))

(define (for-each proc items)
  (if (null? items)
	  nil
	  (begin
		(proc (car items))
		(for-each proc (cdr items)))))

(for-each (lambda (x) (newline) (display x))
           (list 57 321 88))

;; beginを使わない場合
;;
;; (define (for-each proc items)
;;   (if (null? items)
;; 	  nil
;; 	  ((lambda ()
;; 		(proc (car items))
;; 		(for-each proc (cdr items))))))

