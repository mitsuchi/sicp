; 問題 3.81

; 問題3.6は乱数発生器を一般化し, 乱数の並びをリセットして「乱」数の反復可能な並びが作れるようにすることを論じた. 新しい乱数をgenerateするか, 規定した値に並びをresetするかの要求の入力ストリームに操作して, 望みの乱数が作れるこの発生器のストリーム形式化を作れ. 解に代入を使ってはいけない. 

; ('generate 'generate 'reset 12345 'generate .. )
; みたいなストリームを受け取って
; (   987483   343134         12345   4417743 .. )
; みたいな乱数ストリームを返せばいい      

; めんどくさいので
; ('generate 'generate 12345 'generate .. )
; みたいなストリームを受け取って
; (   987483   343134  12345   4417743 .. )
; みたいな乱数ストリームを返せばいいことにする

(load "./stream.scm")

(define (random-numbers-for-request request-stream)
  (define (random-numbers request-stream current-value) ; 現在の値を持ち回す
    (if (stream-null? request-stream)
	the-empty-stream
	(let ((next-value (get-next-value (stream-car request-stream) current-value)))
	  (cons-stream next-value
		       (random-numbers (stream-cdr request-stream)
				       next-value)))))
  (define (get-next-value request current-value) ; 次の乱数を返す
    (if (eq? request 'generate)     ; generate なら
	(rand-update current-value) ; 新しく生成する
	request))                   ; それ以外はそのまま返す
  (random-numbers request-stream random-init))

; http://cparrish.sewanee.edu/cs376/class14.html
(define list->stream
  (lambda (ls)
    (if (null? ls)
      the-empty-stream
      (cons-stream (car ls)
                   (list->stream (cdr ls))))))

(display-stream (random-numbers-for-request (list->stream '(1234 generate generate 12345 generate))))
