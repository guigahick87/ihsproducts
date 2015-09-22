org 0x500
bits 16		

jmp start

espera:
	mov ah, 86h
	mov cx, 20
	xor dx, dx
	mov dx, 0
	int 15h
	ret

print:
	lodsb
	or	al, al
	jz	printDone
	mov	ah,	0eh
	int	10h
	jmp	print
printDone:
	ret

clear:
	MOV AH,06H
 	MOV AL,00H  
 	MOV BH,07H 
 	MOV CH,00H 
 	MOV CL,00H 
	MOV DH,18H
 	MOV DL,4FH  
 	INT 10H 
 	ret

cgaMode:
MOV AH,00H
MOV AL,04H 
INT 10H 
MOV AH,0BH 
MOV BX,0201H 
INT 10H 
ret

textMode:
MOV AH,00H
MOV AL,03H  
INT 10H 
ret


start:	
	call cgaMode	
	call clear

	mov	si, Msg1
	call	print
	call	espera

	mov	si, Msg2
	call	print
	call	espera

	mov	si, Msg3
	call	print
	call	espera

	mov	si, Msg4
	call	print
	call	espera

	call textMode
	call clear
	
reset_disk:
	mov		ah, 0					
	mov		dl, 0					
	int		0x13					
	jc		reset_disk	

	mov		ax, 0x7e0				
	mov		es, ax
	xor		bx, bx
		 
	mov		ah, 0x02				
	mov		al, 13
	mov		ch, 0				
	mov		cl, 3					
	mov		dh, 0					
	mov		dl, 0					
	int		0x13					
		 
	jmp		0x7e0:0x0
 
Msg1	db	"Loading structures for the kernel...", 13, 10, 0
Msg2	db	"Setting up protected mode...", 13, 10, 0
Msg3	db	"Loading kernel in memory...", 13, 10, 0
Msg4	db	"Running kernel...", 13, 10, 0
Msg5	db	"Loading structures for the kernel...", 13, 10, 0


times	3582 - ($ - $$) db 0
dw	0xAA55