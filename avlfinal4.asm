org 0x7c00
bits 16


	mov ah, 0
	mov al, 0x13
	int 0x10




	mov ax, 0xa000; endereco de video
	mov es, ax; move pra segmento de memoria
	mov di, 0; iterador para ir percorrendo os pixels. começamos no primeiro pixel
l3:	mov dl, 0; vamos começar pondo a cor 0
l2:	mov [es:di], dl; insere a cor no pixel
	inc dl; passa pra proxima cor
	inc di; passa pro próximo pixel da tela
	cmp dl, 255; verifica se chegou no final da paleta
	jnz l2; se não tiver chegado, insere a próxima cor
	jmp l3; se tiver chegado, volta pro inicio da paleta



fim: hlt
	
	times 510 - ($ - $$) db 0
	dw 0xaa55