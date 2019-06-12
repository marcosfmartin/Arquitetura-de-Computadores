org 0x7c00
bits 16


	mov ah, 0
	mov al, 0x13
	int 0x10


	
ini	mov ax, 0xa000; endereco de video
	mov es, ax; move pra segmento de memoria
	mov di, 0; iterador para ir percorrendo os pixels. começamos no primeiro pixel

	mov ch, 200; linhas
	call pegaTecla
l1:	mov cl, 255; colunas
	mov dh, 65; colunas parte 2
l2:	mov dl, al; põe a cor que está no registrador al (que pegamos na interrupcao de teclado)
l3:	mov [es:di], dl; insere a cor no pixel
	inc di; passa pro próximo pixel da tela
	dec cl
	or cl, cl; terminou de ler as primeiras 255 colunas?
	jne l3; se nao, volta pra ler a proxima coluna
	mov cl, dh; se sim lê mais 65 colunas
	mov dh, 0; pra garantir que não vai ler mais 65 a toa
	or cl, cl; se aqui der diferente de zero, significa que precisa mais 65 colunas
	jne l3; volta pra ler proximas 65 colunas
	dec ch	;se for zero, significa que terminou a coluna. passa pra proxima linha	
	or ch, ch; terminou de ler as linhas?
	jne l1; se nao, leia a proxima linha
	jmp ini ;se sim, acabou a pintura da tela. espera a próxima tecla

pegaTecla:
	mov ah, 0
	int 0x16; chama a interrupção. o byte da tecla fica armazenado em al
	ret


fim: hlt
	
	times 510 - ($ - $$) db 0
	dw 0xaa55