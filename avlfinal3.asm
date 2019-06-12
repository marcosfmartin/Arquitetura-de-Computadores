;Programa para saudar o usuÃ¡rio com entrada de string
	org 0x7c00
	bits 16

	mov ax, 0
	mov ds, ax

	mov ax, 0x7e00
	call gets

	mov ax, 0x7e00
	call prints
	
	jmp fim

;Subrotina para pegar uma string digitada (até o enter) usando a interrupção 0x16 (teclado), gravando as letras no endereÃ§o indicado pelo registrador ax
gets:	push ax
	push di
	mov di, ax		;di recebe o endereço onde gravar os caracteres na memoria
.loop2: mov ah, 0 		;laço para gravar cada letra digitada até encontrar o enter
	int 0x16		;int 0x16 armazena em al a tecla digitada
	cmp al, 13		;compara a tecla com o enter
	je .ret2		;se for enter, pula
	mov [ds:di], al		;se não, grava a tecla na memória
	inc di			;incrementa pra gravar na proxima posicao
	mov ah, 0x0e		;usar interrupção pra mostrar a tecla na tela
	int 0x10		
	jmp .loop2		
.ret2:	mov ah, 0x0e 		;finaliza quebrando a linha
	int 0x10		
	mov al, 10
	int 0x10
	mov [ds:di], byte 0	;grava o byte 0 no final da string
	pop di
	pop ax
	ret

;subrotina para escrever na tela a string gravada no endereço indicado pelo registrador ax utilizando a interrupção 0x10 (video)
prints:	push ax
	push si
	mov si, ax


	mov ah, 0x02; mover cursor
	mov dh, 1; pra linha 1
	int 0x10; interrupcao com ah=0x02 diz: Mover cursor

	mov ah, 0x0e 		;interrupcao 0x10 com 0x0e diz: vamos printar coisas na tela
.loop1:	lodsb			;laço para percorrer a string até chegar no zero	
	cmp al, 0		;se al for zero, encontramos o final da string. começamos a leitura
	jnz .loop1		;se al não for zero, lemos mais um caractere

	sub si, 2		;começa a ler string. precisamos decrementar si 2 vezes pq lodsb lê, armazena o valor em al e incrementa 1.
l1:	lodsb			;le a string. si vai ser incrementado 1
	sub si, 2		;subtraimos 2 para ler o próximo caractere (o valor incrementado em lodsb + andar 1 caractere pra trás na string)
	int 0x10
	cmp si, 0x7e00		;chegou no começo da string?
	jnz l1			;senao, lê o proximo caractere
	lodsb			;se sim, lê o caractere do começo e imprime
	int 0x10
	
		
.ret1:	pop si
	pop ax
	ret

fim:	hlt

	times 510 - ($-$$) db 0
	dw 0xaa55