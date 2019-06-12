;Programa para saudar o usuário com entrada de string
	org 0x7c00
	bits 16

	mov ax, 0
	mov ds, ax

	mov ax, 0x7e00
	call gets

	mov ax, 0x7e00
	call prints
	
	jmp fim

;Subrotina para pegar uma string digitada (at� o enter) usando a interrup��o 0x16 (teclado), gravando as letras no endereço indicado pelo registrador ax
gets:	push ax
	push di
	mov di, ax		;di recebe o endere�o onde gravar os caracteres na memoria
.loop2: mov ah, 0 		;la�o para gravar cada letra digitada at� encontrar o enter
	int 0x16		;int 0x16 armazena em al a tecla digitada
	cmp al, 13		;compara a tecla com o enter
	je .ret2		;se for enter, pula
	mov [ds:di], al		;se n�o, grava a tecla na mem�ria
	inc di			;incrementa pra gravar na proxima posicao
	mov ah, 0x0e		;usar interrup��o pra mostrar a tecla na tela
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

;subrotina para escrever na tela a string gravada no endere�o indicado pelo registrador ax utilizando a interrup��o 0x10 (video)
prints:	push ax
	push si
	mov si, ax


	mov ah, 0x02; mover cursor
	mov dh, 1; pra linha 1
	int 0x10; interrupcao com ah=0x02 diz: Mover cursor

	mov ah, 0x0e 		;interrupcao 0x10 com 0x0e diz: vamos printar coisas na tela
.loop1:	lodsb			;la�o para percorrer a string at� chegar no zero	
	cmp al, 0		;se al for zero, encontramos o final da string. come�amos a leitura
	jnz .loop1		;se al n�o for zero, lemos mais um caractere

	sub si, 2		;come�a a ler string. precisamos decrementar si 2 vezes pq lodsb l�, armazena o valor em al e incrementa 1.
l1:	lodsb			;le a string. si vai ser incrementado 1
	sub si, 2		;subtraimos 2 para ler o pr�ximo caractere (o valor incrementado em lodsb + andar 1 caractere pra tr�s na string)
	int 0x10
	cmp si, 0x7e00		;chegou no come�o da string?
	jnz l1			;senao, l� o proximo caractere
	lodsb			;se sim, l� o caractere do come�o e imprime
	int 0x10
	
		
.ret1:	pop si
	pop ax
	ret

fim:	hlt

	times 510 - ($-$$) db 0
	dw 0xaa55