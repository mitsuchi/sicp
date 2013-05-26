; 帰納法で行こう。
; G(n) = (phi^n - psi^n) / root 5 とする。
;
; n = 0 の場合。
; Fib(0) = 0
; G(0) = (phi^0 - psi^0) / root 5 = (1-1)/root 5 = 0
; Fib(0) = G(0)
;
; n = 1 の場合。
; Fib(1) = 1
; G(1) = (phi^1 - psi^1) / root 5 =  root 5 / root 5 = 1
; Fib(1) = G(1)
;
; いま、あるn+1以下の任意のiについて Fib(i) = G(i)と仮定する。ただし n>=0
;
; ところで phi = (1+root 5)/2 だから
; 2phi - 1 = root 5 
; 4phi^2 - 4phi + 1 = 5
; 4phi^2 - 4phi - 4 = 0
; phi^2 - phi - 1 = 0
; phi^2 = phi + 1
;
; 同様に psi = (1-root 5)/2 だから
; 2psi - 1 = - root 5 
; 4psi^2 - 4psi + 1 = 5
; psi^2 = psi + 1
; 
; G(n+2) = (phi^(n+2) - psi^(n+2)) / root 5
; = (phi^n * phi^2 - psi^n * psi^2 ) / root 5
; 上の phi^2 と psi^2 についての計算結果から
; = (phi^n * (phi + 1) - psi^n * (psi + 1)) / root 5
; = ((phi^(n+1) + phi^n) - (psi^(n+1) + psi^n)) / root 5
; = (phi^(n+1) - psi^(n+1)) / root 5 +  (phi^n - psi^n) / root 5
; = G(n+1) + G(n)
; 仮定から
; = Fib(n+1) + Fib(n)
; フィボナッチ数列の定義から
; = Fib(n+2)
;
; ここまででようやくヒントの部分が証明できた。
; つまり Fib(n) = phi^2 / root 5 - psi^n / root 5 だ。
; Fib(n)は整数と分かってるから、2つめの項 psi^n / root 5 の
; 絶対値がいつも0.5より小さいといえればいい。
; 
; psi^n / root 5 の値をみると
; n = 0 : -0.27639320225002106
; n = 1 : 0.17082039324993692
; n = 2 : -0.10557280900008414
; n = 3 : 0.06524758424985282
; みたいに 振動しながら0に収束していく。
; なのでOK。
