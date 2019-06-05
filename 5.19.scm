(define true #t)
(define false #f)

; 計算機モデルの作成
(define (make-machine register-names ops controller-text)
  (let ((machine (make-new-machine)))
	(for-each (lambda (register-name)
				((machine 'allocate-register) register-name))
			  register-names)
	((machine 'install-operations) ops)
	((machine 'install-instruction-sequence)
	 (assemble controller-text machine))
	machine))

; レジスタ
(define (make-register name)
  (let ((contents '*unassigned*)
		(trace false)
		(register-name name))
	(define (trace-on)
	  (set! trace true))
	(define (trace-off)
	  (set! trace false))
	(define (set value)
	  (if trace
		(begin
		  (display (list 'name '= register-name 
						 'old-value '= contents 
						 'new-value '= value))
		  (newline)))
	  (set! contents value))
	(define (dispatch message)
	  (cond ((eq? message 'get) contents)
			((eq? message 'set) set)
			((eq? message 'trace-on) (trace-on))
			((eq? message 'trace-off) (trace-off))
			(else
			  (error "Unknown request -- REGISTER" message))))
	dispatch))

(define (get-contents register)
  (register 'get))

(define (set-contents! register value)
  ((register 'set) value))

; スタック
(define (make-stack)
  (let ((s '())
		(number-pushes 0)
		(max-depth 0)
		(current-depth 0))
	(define (push x)
	  (set! s (cons x s))
	  (set! number-pushes (+ 1 number-pushes))
	  (set! current-depth (+ 1 current-depth))
	  (set! max-depth (max current-depth max-depth)))
	(define (pop)
	  (if (null? s)
		(error "Empty stack -- POP")
		(let ((top (car s)))
		  (set! s (cdr s))
		  (set! current-depth (- current-depth 1))
		  top)))
	(define (initialize)
	  (set! s '())
	  (set! number-pushes 0)
	  (set! max-depth 0)
	  (set! current-depth 0)
	  'done)
	(define (print-statistics)
	  (newline)
	  (display (list 'total-pushes  '= number-pushes
					 'maximum-depth '= max-depth))
	  (newline))
	(define (dispath message)
	  (cond ((eq? message 'push) push)
			((eq? message 'pop) (pop))
			((eq? message 'initialize) (initialize))
			((eq? message 'print-statistics)
			 (print-statistics))
			(else
			  (error "Unknown request -- STACK" message))))
	dispath))

(define (pop stack)
  (stack 'pop))

(define (push stack value)
  ((stack 'push) value))

; 基本計算機
(define (make-new-machine)
  (let ((pc (make-register 'pc))
		(flag (make-register 'flag))
		(stack (make-stack))
		(the-instruction-sequence '())
		(instruction-count 0)
		(instruction-trace false)
		(current-label '*unassigned*))
	; 命令計数用
	(define (advance-instruction-count)
	  (set! instruction-count (+ 1 instruction-count)))
	(define (initial-instruction-count)
	  (set! instruction-count 0))
	(define (print-instruction-count)
	  (newline)
	  (display (list 'instruction-count '= instruction-count))
	  (newline))
	; 命令トレース用
	(define (trace-on)
	  (set! instruction-trace true))
	(define (trace-off)
	  (set! instruction-trace false))
	(let ((the-ops
			(list (list 'initialize-stack
						(lambda () (stack 'initialize)))
				  (list 'print-stack-statistics
						(lambda () (stack 'print-statistics)))
				  (list 'print-instruction-count
						(lambda () (print-instruction-count)))
				  (list 'initial-instruction-count 
						(lambda () (initial-instruction-count)))))
		  (register-table
			(list (list 'pc pc) (list 'flag flag))))
	  (define (allocate-register name)
		(if (assoc name register-table)
		  (error "Multiply defined register: " name)
		  (set! register-table
			(cons (list name (make-register name))
				  register-table)))
		'register-allocated)
	  (define (lookup-register name)
		(let ((val (assoc name register-table)))
		  (if val
			(cadr val)
			(error "Unknown register: " name))))
	  (define (execute)
		(let ((insts (get-contents pc)))
		  (if (null? insts)
			'done
			(begin
			  ; 命令計数
			  (advance-instruction-count)
			  ; 命令トレース
			  (print-instruction-trace (car insts))

			  ; ブレークポイントが設定されていない場合のみexecuteする
			  ; このときpcは実行直前の状態になってるはずなので
			  ; この状態で再度executeすれば続きから実行できるはず
			  (if (not (instruction-breakpoint (car insts)))
				(begin
				  ((instruction-execution-proc (car insts)))
				  (execute))
				(begin
				  (print-breakpoint (car insts))
				  'stop))))))
	  ; ブレークポイント情報の表示
	  (define (print-breakpoint inst)
		; 最寄のラベル
		 (newline)
		 (display (instruction-label inst))
		 (display " ")
		 (display (instruction-label-count inst))
		 (newline))
	  ; 命令トレース
	  (define (print-instruction-trace inst)
		(if instruction-trace
		  (begin
			; 最寄のラベル
			(print-breakpoint inst)
		    ; 命令トレース
			(display (instruction-text inst))
			(newline))))
	  ; レジスタのトレースをON、OFF
	  (define (register-trace-on reg-name)
		(let ((reg (lookup-register reg-name)))
		  (if reg
			(reg 'trace-on)
			(error "Undefined register -- MACHINE" reg-name))))
	  (define (register-trace-off reg-name)
		(let ((reg (lookup-register reg-name)))
		  (if reg
			(reg 'trace-off)
			(error "Undefined register -- MACHINE" reg-name))))
	  ; ブレークポイントを設定する
	  (define (set-breakpoint-switch label n switch)
		; pcを頭から走査し、ラベルと距離が一致したらセット
		; 見つからない場合はエラーにする。
		(define (iter insts)
		  (if (null? insts)
			(error "Not find label -- MACHINE" label n)
			(let ((inst (car insts)))
			  (if (and (eq? (instruction-label inst) label)
						  (eq? (instruction-label-count inst) n))
				(set-instruction-breakpoint! inst switch)
				(iter (cdr insts))))))
		(iter the-instruction-sequence)
		'done)
	  ; ブレークポイントON用
	  (define (set-breakpoint label n)
		(set-breakpoint-switch label n true))
	  ; ブレークポイントCANCEL用
	  (define (cancel-breakpoint label n)
		(set-breakpoint-switch label n false))
	  ; 全てのブレークポイントをキャンセルする
	  (define (cancel-all-breakpoint)
		(define (iter insts)
		  (if (null? insts)
			'done
			(begin
			  (set-instruction-breakpoint! (car insts) false)
			  (iter (cdr insts)))))
		(iter the-instruction-sequence))
	  ; 再開
	  (define (proceed)
		; とまっている箇所をブレークポイントを無視して実行し
		; executeを呼びだす。
		(let ((insts (get-contents pc)))
		  (if (null? insts)
			'done
			(begin
			  ; 命令計数
			  (advance-instruction-count)
			  ; 命令トレース
			  (print-instruction-trace (car insts))
			  ((instruction-execution-proc (car insts)))
			  (execute)))))
	  (define (dispatch message)
		(cond ((eq? message 'start)
			   (set-contents! pc the-instruction-sequence)
			   (execute))
			  ((eq? message 'install-instruction-sequence)
			   (lambda (seq) (set! the-instruction-sequence seq)))
			  ((eq? message 'allocate-register) allocate-register)
			  ((eq? message 'get-register) lookup-register)
			  ((eq? message 'install-operations)
			   (lambda (ops) (set! the-ops (append the-ops ops))))
			  ((eq? message 'stack) stack)
			  ((eq? message 'operations) the-ops)
			  ; 命令計数用
			  ((eq? message 'initial-instruction-count) (initial-instruction-count))
			  ((eq? message 'advance-instruction-count) (advance-instruction-count))
			  ; 命令トレース用
			  ((eq? message 'trace-on) (trace-on))
			  ((eq? message 'trace-off) (trace-off))
			  ; レジスタのトレースをON、OFFする
			  ((eq? message 'reg-trace-on) register-trace-on)
			  ((eq? message 'reg-trace-off) register-trace-off)
			  ; ブレークポイントをセットする
			  ((eq? message 'set-breakpoint) set-breakpoint)
			  ; ブレークポイントをキャンセルする
			  ((eq? message 'cancel-breakpoint) cancel-breakpoint)
			  ; 全ブレークポイントをキャンセルする
			  ((eq? message 'cancel-all-breakpoint) (cancel-all-breakpoint))
			  ; 再開
			  ((eq? message 'proceed) (proceed))
			  (else (error "Unknown request -- MACHINE" message))))
	  dispatch)))

(define (start machine)
  (machine 'start))

; レジスタトレースON
(define (set-register-trace-on machine register-name)
  ((machine 'reg-trace-on) register-name))

; レジスタトレースOFF
(define (set-register-trace-off machine register-name)
  ((machine 'reg-trace-off) register-name))

(define (get-register-contents machine register-name)
  (get-contents (get-register machine register-name)))

(define (set-register-contents! machine register-name value)
  (set-contents! (get-register machine register-name) value)
  'done)

(define (get-register machine reg-name)
  ((machine 'get-register) reg-name))

; ブレークポイント
(define (set-breakpoint machine label n)
  ((machine 'set-breakpoint) label n))

(define (cancel-breakpoint machine label n)
  ((machine 'cancel-breakpoint) label n))

(define (proceed-machine machine)
  (machine 'proceed))

(define (cancel-all-breakpoint machine)
  (machine 'cancel-all-breakpoint))

; アセンブラ
(define (assemble controller-text machine)
  (extract-labels controller-text
				  (lambda (insts labels)
					(update-insts! insts labels machine)
					insts)))

(define (extract-labels text receive)
  (if (null? text)
	(receive '() '())
	(extract-labels (cdr text)
					(lambda (insts labels)
					  (let ((next-inst (car text)))
						(if (symbol? next-inst)
						  (if (assoc next-inst labels)
							(error "Multiply defined label -- ASSEMBLE" next-inst)
							(receive (set-label-to-instructions! insts next-inst)
									 (cons (make-label-entry next-inst
															 insts)
										   labels)))
						  (receive (cons (make-instruction next-inst)
										 insts)
								   labels)))))))

(define (update-insts! insts labels machine)
  (let ((pc (get-register machine 'pc))
		(flag (get-register machine 'flag))
		(stack (machine 'stack))
		(ops (machine 'operations)))
	(for-each
	  (lambda (inst)
		(set-instruction-execution-proc!
		  inst
		  (make-execution-procedure
			(instruction-text inst) labels machine
			pc flag stack ops)))
	  insts)))

(define (make-instruction text)
  ; テキスト、命令、直前のラベル、ラベルからの距離、ブレイクポイント
  (list text '() '() '() false))

(define (instruction-text inst)
  (car inst))

(define (instruction-execution-proc inst)
  (cadr inst))

(define (set-instruction-execution-proc! inst proc)
  (set-car! (cdr inst) proc))

; instructionにラベルとラベルからの距離の情報を記憶させる
(define (set-label-to-instructions! insts label)
  (define (iter insts count)
	(if (or (null? insts) (instruction-have-label? (car insts)))
	  insts
	  (cons (set-instruction-label-info! (car insts) label count)
			(iter (cdr insts) (+ count 1)))))
  (iter insts 1))

(define (instruction-have-label? inst)
  (not (null? (instruction-label inst))))

(define (instruction-label inst)
  (caddr inst))

(define (instruction-label-count inst)
  (cadddr inst))

; ブレークポイント設定の取得
(define (instruction-breakpoint inst)
  (cadr (cdddr inst)))

; ブレークポイント設定の書き込み
(define (set-instruction-breakpoint! inst switch)
  (set-car! (cddddr inst) switch))

; ラベルとラベルからの距離を書き込む
(define (set-instruction-label-info! inst label count)
  (set-car! (cddr inst) label)
  (set-car! (cdddr inst) count)
  inst)

(define (make-label-entry label-name insts)
  (cons label-name insts))

(define (lookup-label labels label-name)
  (let ((val (assoc label-name labels)))
	(if val
	  (cdr val)
	  (error "Undefined label -- ASSEMBLE" label-name))))

; 命令の実行手続きの生成
(define (make-execution-procedure inst labels machine
								  pc flag stack ops)
  (cond ((eq? (car inst) 'assign)
		 (make-assign inst machine labels ops pc))
		((eq? (car inst) 'test)
		 (make-test inst machine labels ops flag pc))
		((eq? (car inst) 'branch)
		 (make-branch inst machine labels flag pc))
		((eq? (car inst) 'goto)
		 (make-goto inst machine labels pc))
		((eq? (car inst) 'save)
		 (make-save inst machine stack pc))
		((eq? (car inst) 'restore)
		 (make-restore inst machine stack pc))
		((eq? (car inst) 'perfome)
		 (make-perfome inst machine labels ops pc))
		((eq? (car inst) 'unassign)
		 (make-unassign inst machine pc))
		(else (error "Unknown instruction type -- ASSEMBLE"
					 inst))))

; assign命令
(define (make-assign inst machine labels operations pc)
  (let ((target
		  (get-register machine (assign-reg-name inst)))
		(value-exp (assign-value-exp inst)))
	(let ((value-proc
			(if (operation-exp? value-exp)
			  (make-operation-exp
				value-exp machine labels operations)
			  (make-primitive-exp
				(car value-exp) machine labels))))
	  (lambda ()
		(set-contents! target (value-proc))
		(advance-pc pc)))))

(define (assign-reg-name assign-instruction)
  (cadr assign-instruction))

(define (assign-value-exp assign-instruction)
  (cddr assign-instruction))

; unassign命令（問題5.10用、実際あまり意味はない）
(define (make-unassign inst machine pc)
  (let ((target
		  (get-register machine (assign-reg-name inst))))
	(lambda ()
	  (set-contents! target '*unassigned*)
	  (advance-pc pc))))

(define (unassign-reg-name unassign-instruction)
  (cadr unassign-instruction))

; pcを次に進める
(define (advance-pc pc)
  (set-contents! pc (cdr (get-contents pc))))

; test命令
(define (make-test inst machine labels operations flag pc)
  (let ((condition (test-condition inst)))
	(if (operation-exp? condition)
	  (let ((condition-proc
			  (make-operation-exp
				condition machine labels operations)))
		(lambda ()
		  (set-contents! flag (condition-proc))
		  (advance-pc pc)))
	  (error "Bad TEST instruction -- ASSEMBLE" inst))))

(define (test-condition test-instruction)
  (cdr test-instruction))

; branch命令
(define (make-branch inst machine labels flag pc)
  (let ((dest (branch-dest inst)))
	(if (label-exp? dest)
	  (let ((insts
			  (lookup-label labels (label-exp-label dest))))
		(lambda ()
		  (if (get-contents flag)
			(set-contents! pc insts)
			(advance-pc pc))))
	  (error "Bad BRANCH -- ASSEMBLE" inst))))

(define (branch-dest branch-instruction)
  (cadr branch-instruction))

; goto命令
(define (make-goto inst machine labels pc)
  (let ((dest (goto-dest inst)))
	(cond ((label-exp? dest)
		   (let ((insts
				   (lookup-label labels
								 (label-exp-label dest))))
			 (lambda () (set-contents! pc insts))))
		  ((register-exp? dest)
		   (let ((reg
				   (get-register machine
								 (register-exp-reg dest))))
			 (lambda ()
			   (set-contents! pc (get-contents reg)))))
		  (else (error "Bad GOTO instruction -- ASSEMBLE"
					   inst)))))

(define (goto-dest goto-instruction)
  (cadr goto-instruction))

; スタック命令
(define (make-save inst machine stack pc)
  (let ((reg (get-register machine
						   (stack-inst-reg-name inst))))
	(lambda ()
	  (push stack (get-contents reg))
	  (advance-pc pc))))

(define (make-restore inst machine stack pc)
  (let ((reg (get-register machine
						   (stack-inst-reg-name inst))))
	(lambda ()
	  (set-contents! reg (pop stack))
	  (advance-pc pc))))

(define (stack-inst-reg-name stack-instruction)
  (cadr stack-instruction))

; perfome
(define (make-perfome inst machine labels operations pc)
  (let ((action (perfome-action inst)))
	(if (operation-exp? action)
	  (let ((action-proc
			  (make-operation-exp
				action machine labels operations)))
		(lambda ()
		  (action-proc)
		  (advance-pc pc)))
	  (error "Bad PERFORM instruction -- ASSEMBLE" inst))))

(define (perfome-action inst) (cdr inst))

; 式の値を作る
(define (make-primitive-exp exp machine labels)
  (cond ((constant-exp? exp)
		 (let ((c (constant-exp-value exp)))
		   (lambda () c)))
		((label-exp? exp)
		 (let ((insts
				 (lookup-label labels
							   (label-exp-label exp))))
		   (lambda () insts)))
		((register-exp? exp)
		 (let ((r (get-register machine
								(register-exp-reg exp))))
		   (lambda () (get-contents r))))
		(else
		  (error "Unknown expression type -- ASSEMBLE" exp))))

; 式の構文
(define (tagged-list? exp tag)
  (if (pair? exp)
	(eq? (car exp) tag)
	false))

(define (register-exp? exp) (tagged-list? exp 'reg))

(define (register-exp-reg exp) (cadr exp))

(define (constant-exp? exp) (tagged-list? exp 'const))

(define (constant-exp-value exp) (cadr exp))

(define (label-exp? exp) (tagged-list? exp 'label))

(define (label-exp-label exp) (cadr exp))

; 演算式に対する実行手続き
(define (make-operation-exp exp machine labels operations)
  (let ((op (lookup-prim (operation-exp-op exp) operations))
		(aprocs
		  (map (lambda (e)
				 (if (label-exp? e)
				   (error "Arguments include label -- ASSEMBLE" e)
				   (make-primitive-exp e machine labels)))
			   (operation-exp-operands exp))))
	(lambda ()
	  (apply op (map (lambda (p) (p)) aprocs)))))

; 演算式の構文
(define (operation-exp? exp)
  (and (pair? exp) (tagged-list? (car exp) 'op)))

(define (operation-exp-op operation-exp)
  (cadr (car operation-exp)))

(define (operation-exp-operands operation-exp)
  (cdr operation-exp))

; シミュレーション手続きの検索
(define (lookup-prim symbol operations)
  (let ((val (assoc symbol operations)))
	(if val
	  (cadr val)
	  (error "Unknown operation -- ASSEMBLE" symbol))))

; サンプル実行用
(define exp-machine
  (make-machine
	'(p n b)
	(list (list '= =) (list '- -) (list '* *))
	'(expt-loop
		(assign p (const 1))
		(assign b (const 2))
		(assign n (const 11))
	  test-e
		(test (op =) (reg n) (const 0))
		(branch (label expt-done))
		(assign n (op -) (reg n) (const 1))
		(assign p (op *) (reg p) (reg b))
		(goto (label test-e))
	  expt-done)))

(define exp-machine2
  (make-machine
	'(val n b continue)
	(list (list '= =) (list '- -) (list '* *))
	'((assign continue (label expt-done))
	  (assign val (const 1))
	  (assign b (const 2))
	  (assign n (const 11))
	  expt-loop
		(test (op =) (reg n) (const 0))
		(branch (label immediate-answer))
		(save continue)
		(assign continue (label after-expt))
		(save n)
		(assign n (op -) (reg n) (const 1))
		(goto (label expt-loop))
	  after-expt
		(restore n)
		(restore continue)
		(assign val (op *) (reg val) (reg b))
		(goto (reg continue))
	  immediate-answer
		(assign val (const 1))
		(goto (reg continue))
	  expt-done
	    (unassign b))))

(define fibonacci-machine
  (make-machine
	'(val n continue)
	(list (list 'print print) (list 'read read) (list '- -) (list '+ +) (list '< <))
	'(  
	  fib-start
	    (perfome (op initial-instruction-count))
	    (perfome (op initialize-stack))
		(assign n (op read))
		(assign continue (label fib-done))
	  fib-loop
	    (test (op <) (reg n) (const 2))
		(branch (label immediate-answer))
		(save continue)
		(assign continue (label after-fib-n-1))
		(save n)
		(assign n (op -) (reg n) (const 1))
		(goto (label fib-loop))
      after-fib-n-1
	    (restore n)
		(restore continue)
		(assign n (op -) (reg n) (const 2))
		(save continue)
		(assign continue (label after-fib-n-2))
		(save val)
		(goto (label fib-loop))
	  after-fib-n-2
	    (assign n (reg val))
		(restore val)
;		(restore n)
		(restore continue)
		(assign val
				(op +) (reg val) (reg n))
		(goto (reg continue))
	  immediate-answer
	    (assign val (reg n))
		(goto (reg continue))
	  fib-done
	    (perfome (op print) (reg val))
		(perfome (op print-stack-statistics))
		(perfome (op print-instruction-count))
		(goto (label fib-start)))))

(define fact-machine
  (make-machine
	'(val n continue)
	(list (list 'print print) (list 'read read) (list '- -) (list '= =) (list '* *))
	'(  
	  fact-start
	    (perfome (op initial-instruction-count))
	    (perfome (op initialize-stack))
	    (assign continue (label fact-done))
	    (assign n (op read))
	  fact-loop
	    (test (op =) (reg n) (const 1))
		(branch (label base-case))
		(save continue)
		(save n)
		(assign n (op -) (reg n) (const 1))
		(assign continue (label after-fact))
		(goto (label fact-loop))
	  after-fact
	    (restore n)
		(restore continue)
		(assign val (op *) (reg n) (reg val))
		(goto (reg continue))
	  base-case
	    (assign val (const 1))
		(goto (reg continue))
	  fact-done
	    (perfome (op print) (reg val))
	    (perfome (op print-stack-statistics))
		(perfome (op print-instruction-count))
		(goto (label fact-start)))))
