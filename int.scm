(load "./stream.scm")

(define ones (cons-stream 1 ones))
(define ints
  (cons-stream 1
	       (add-streams ones ints)))

(display-stream (stream-take 10 ints))
