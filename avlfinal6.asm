org 0x7c00
bits 16

mov si, fib
call print_dec
call printEspaco
add si, 2
call print_dec
call printEspaco
mov cl, 20; imprimimos mais 20 numeros
loop:
call getFib
call print_dec
call printEspaco
dec cl
or cl, cl
jnz loop
jmp fim



; TODO: ignorar o 0 a esquerda dos numeros


print_dec: ;print numero em 0x7e00

 push ax
 push bx
 push cx
 push dx

 ;Set up registers:
 ;AX = Number left to print
 ;BX = Power of ten to extract the current digit
 ;DX = Scratch/Needed for DIV
 ;CX = Scratch

 mov ax, [ds:si]; numero de fibonacci a ser exibido
 mov bx, 10000
 mov dx, 0; dx precisa ser zero pro comando div

_pd_convert:     
 div bx                           ;extrai o dígito mais significativo de ax. o dígito fica em ax(al)
 mov cx, dx                       ;o resto fica em cx
 


cmp bx, 1
jne _pd_continue ;para nao repetir o ultimo digito


_pd_print:

 ;Print digit in AL
 add al, '0' ;transforma valor do algarismo no caractere correspondente
 mov ah, 0x0e
 int 0x10

_pd_continue:

 mov ax, bx; ax recebe 10 elevado a muito
 mov dx, 0; dx precisa ser 0 no comando div
 mov bx, 10;bx recebe 10
 div bx; agr dividimos bx/ax pra diminuir um zero. bx recebe depois.
 mov bx, ax

 mov ax, cx ;o resto tinha ficado em cx e agora volta pra ax

or bx, bx ;checa se o divisor é zero
jnz _pd_convert ;nao é zero. continua

pop dx
pop cx
pop bx
pop ax

ret


printEspaco:
push ax

mov al, 0x20; espaço
mov ah, 0x0e
int 0x10

pop ax
ret

getFib: ;calcula proximo numero da sequencia e armazena em es:di

add si, 2
mov bx, si
sub bx, 4
mov di, bx
mov ax, word [es:di]
mov [ds:si], ax
add di, 2
mov ax, word [es:di]
add [ds:si], ax
ret



fib: dw 1, 1; escreve os dois primeiros numeros de fibonacci (do tamanho de ax)





fim: hlt
times 510 - ($-$$) db 0
dw 0xaa55