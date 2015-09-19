org 0x7c00
jmp 0x0000:Codigo

Data:
	nome: dw 21,0
	grupo: db 20
	fone: db 12
	email: db 15
	count dw 1

Codigo:
		xor ax, ax
		mov ds, ax

mov di, 0
			;lendo um caracter do teclado, apos a interrupcao ele estara em al		
read:		
		mov ah,0
		int 16h

		mov [nome + di], ax
		inc di
							
		inc DWORD[count]	;;increment the number of the character
		
		mov ah,0xe
		mov bh,0
		int 0x10	;;call the video system to show the last character
		
		cmp al,13	;;check if the "enter" was pressed
		jnz read	;; if not,then get the next character

;;change cursor position
mov ah,2
mov bh,0
mov dh,9
mov dl,0
int 10h

mov di, 0

lacoImprimirString:
		
		mov al, [nome + di]		; move caracter por caracter para ax
		inc di					; incrementa di
		
		cmp di, [count]  		; verifica se a string chegou ao final
		je Finaliza				; se chegou finaliza
		
		mov AH, 0xe 	;Número da interrupção. 0xe=Imprime ;	um caractere que está em AL.
		mov BH, 0 		;Número da Página.
		mov BL, 2 		;Cor do caractere em modos de vídeo gráficos (verde)
		int 0x10 		;int 10h = Interrupção de vídeo.
		
		
		jmp lacoImprimirString

		
Finaliza:
			times 510-($-$$) db 0
			dw 0xAA55