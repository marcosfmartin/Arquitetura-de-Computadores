org 0x7c00
bits 16


mov ah, 0
mov al, 0x13
int 0x10

int 0x13
mov ah, 0x02
mov al, 32
mov cl, 2
mov ch, 0
mov dh, 0
mov bx, 0x7e00
int 0x13


	
 	mov ax, 0xa000
	mov es, ax
	mov di, 0
	mov si, 0x7e00
	
	;carrega imagem (50 linhas x 320 colunas de pixels)	
	mov ch, 50
	mov cl, 255
	mov dh, 65; 255+65 = 320 colunas
l1:	mov dl, [ds:si]  ;move pixel para a mem�ria de v�deo
	mov [es:di], dl  ; escreve na tela o endere�o do pixel atual
	inc di; vamos ler o pr�ximo pixel da imagem
	inc si
	dec cl
	or  cl, cl  ;Terminou de ler as 255 colunas na linha?
	jne l1     ;Se n�o terminou, continua lendo. Se terminou, v� se terminou total ou se precisa de mais 65 colunas
	mov cl, dh
	mov bl, 0
	or cl, cl
	jne l1; se n�o for zero, significa que ainda precisa ler mais 65. volta pra l1
l2:	add cl, 255 ;se foi zero, j� leu a coluna toda. passa pra pr�xima linha
	add dh, 65
	dec ch
	or ch, ch  ;Terminou de ler todas as linhas?
	jnz l1     ;Se n�o, come�a leitura da nova linha
	
	jmp fim    ;terminou de ler a imagem, ent�o termina o programa.


fim: hlt
	
	times 510 - ($ - $$) db 0
	dw 0xaa55