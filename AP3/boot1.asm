[BITS 16]
[ORG 0x7C00]

jmp main

;Print characters to the screen 
Println:
    lodsb ;Load string 
    or al, al
    jz complete
    mov ah, 0x0e 	
    int 0x10 ;BIOS Interrupt 0x10 - Used to print characters on the screen via Video Memory 
    jmp Println ;Loop   	
complete:
    call PrintNwL

;Prints empty new lines like '\n' in C/C++ 	
PrintNwL: 
    mov al, 0	; null terminator '\0'
    stosb       ; Store string 			
    mov ah, 0x0E ;Adds a newline break '\n'
    mov al, 0x0D
    int 0x10
    mov al, 0x0A 
    int 0x10
	ret

;Reboot the Machine 
Reboot: 
    mov si, AnyKey
    call Println
    call GetPressedKey 
    ret

;Gets the pressed key 
GetPressedKey:
    mov ah, 0
    int 0x16  ;BIOS Keyboard Service 
    ret 

clear:
	mov ah,06h
 	mov al,00h  
 	mov bh,07h 
 	mov ch,00h 
 	mov cl,00h 
	mov dh,18h
 	mov dl,4fh  
 	int 10h 
 ret

main:
cli ;Clear interrupts 
;Setup stack segments 
mov ax,cs              
mov ds,ax   
mov es,ax               
mov ss,ax                
sti ;Enable interrupts 

call clear
mov si, msg
call Println

call Reboot

continue:
cli

lgdt [gdt_desc]

mov eax, cr0
or eax, 1
mov cr0, eax

jmp 0x08:clear_pipe

[bits 32]
clear_pipe:

mov ax, 0x10
mov ds, ax
mov es, ax
mov ss, ax
mov esp, 0x090000

call clrscr32 ; limpo a tela primeiro

mov byte [ds:0x0b8000], 'P'
mov byte [ds:0x0b8001], 0x02
mov byte [ds:0x0b8002], 'M'
mov byte [ds:0x0b8003], 0x02
mov byte [ds:0x0b8004], 'O'
mov byte [ds:0x0b8005], 0x02
mov byte [ds:0x0b8006], 'D'
mov byte [ds:0x0b8007], 0x02
mov byte [ds:0x0b8008], 'E'
mov byte [ds:0x0b8009], 0x02

hlt

clrscr32:
	pushad
	cld
	mov edi, 0xb8000
	mov cx, 80 * 25
	mov ah, 0x0f ; atributo
	mov al, ' ' ; caractere nulo
	rep stosw
	popad
	ret
	
gdt:

gdt_null:
	dd 0
	dd 0
gdt_code:
	dw 0ffffh
	dw 0
	db 0
	db 10011010b
	db 11001111b
	db 0
gdt_data:
	dw 0ffffh
	dw 0
	db 0
	db 10010010b
	db 11001111b
	db 0
	
gdt_end:

gdt_desc:
	dw gdt_end - gdt - 1
	dd gdt

msg db "Real mode...", 0x0
AnyKey db "Press any key to enter in protected mode...", 0x0 
	
TIMES 510-($-$$) DB 0
DW 0AA55h