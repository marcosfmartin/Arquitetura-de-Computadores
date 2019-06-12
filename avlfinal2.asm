org 0x7c00
bits 16

inicio:	
    ;leitura do segundo setor do disco, onde estÃ¡ o texto a ser exibido

    int 0x13            ;interrupÃ§Ã£o de disco (inicializa)

    mov ah, 0x02       ;ler setores
    mov al, 1          ;quantidade de setores a serem lidos (1 setor)
    mov ch, 0          ;cilindro (0)
    mov dh, 0          ;cabeÃ§ote (0)
    mov cl, 2          ;ler a partir de qual setor? (a partir do setor 2)
    mov bx, 0x7e00     ;endereÃ§o de memÃ³ria onde gravar o(s) setor(es) lido(s)
    int 0x13           ;interrupÃ§Ã£o de disco
	
	mov ax, 0x7e00
	mov si, ax; recebe endereço da mensagem
	mov al, 0; zeramos o al que era 1
	mov ah, 0x0e; vamos printar na tela
l2:	mov di, mat; recebe o endereço dos numeros da matricula
l1:	lodsb; carrega um caractere da mensagem e incrementa si
	or al, al; chegou ao fim da mensagem?
	je fim; se sim, acabamos
	sub al, [es:di] ;senão, subtraimos um dos dígitos da matrícula
	inc di ;passamos para o dígito seguinte da matrícula
	cmp byte [es:di], 10	;chegamos no final dos dígitos da matrícula?
	jne l3;se nao, so imprime o dígito
	mov di, mat; se sim, volta pro inicio dos digitos da matricula e depois imprime
l3:	int 0x10 ;se nao, imprimimos o digito pendente e vamos ler o proximo digito
	jmp l1




mat: db 4, 7, 3, 5, 9, 5, 10

fim: hlt
times 510 - ($-$$) db 0
dw 0xaa55