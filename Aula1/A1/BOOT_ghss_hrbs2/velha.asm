;**********************************************************************
;Anderson Felix,Diogo Shiroto,Guilherme Henrique,Hugo Ricardo,Matheus Barbosa
;**********************************************************************

org 0x7e00;;start point of the program

%macro dbg 3
	pusha
		mov ah,2
		mov bh,0
		mov dh, %1
		mov dl, %2
		int 10h
		mov ah, 0xe
		mov al, %3
		int 10h
	popa
%endmacro


%macro cc 2 ;change_cursor_position:
	pusha
		mov ah,2
		mov bh,0
		mov dh,%1
		mov dl,%2
		int 10h
	popa
%endmacro

%macro print 1
	pusha
		mov cl,0
		mov si,%1
		print_string_program_name:
		lodsb
		cmp cl,al
		je continue_m
		mov ah,0xe
		mov bh,0
		int 0x10
		jmp print_string_program_name

		continue_m:
	popa
%endmacro

jmp code 
	data:;;Data section
	
	;;messages
	program_name  		  	:db 'Agenda Estilisada',0
	choose_message		  	:db 'Selecione o numero da opcao correspondente',0
	add_contact_message   	:db 'Cadastrar Contato(0)',0
	search_contact_message 	:db 'Buscar Contato(1)',0
	edit_contact_message  	:db 'Editar Contato(2)',0
	delet_contact_message 	:db 'Deletar Contato(3)',0
	show_contacts_message 	:db 'Listar Grupos(4)',0
	show_contacts_full_message 	:db 'Listar Todos os Dados dos Contatos(5)',0
	quit_program_message  	:db 'Sair do programa(6)',0
	message_end   	      	:db 'Voce deseja realizar outa operacao?(s= sim,n = nao)',0
	message_thanks	      	:db 'Obrigado por utilizar nossa Agenda Estilisada',0
	add_contact_info_message :db 'Voce esta em Cadastrar Contato',0
	search_contact_info_message :db   'Voce esta em Buscar Contato',0
	edit_contact_info_message :db   'Voce esta em Editar Contato',0
	delet_contact_info_message :db   'Voce esta em Deletar Contato',0
	show_contacts_info_message :db   'Voce esta em Listar Grupos',0

	enter_contact_name		:db 'Insira o nome',0
	enter_contact_group		:db 'Insira o Grupo',0
	enter_contact_telefone	:db 'Insira o numero de Telefone',0
	enter_contact_email		:db 'Insira o e-mail',0

	register_done			:db 'Contato cadastrado com sucesso!',0

	print_nome 				:db 'Nome: ',0
	print_email 			:db 'Email: ',0
	print_fone 				:db 'Telefone:',0
	print_grupo 			:db 'Grupo:', 0

	print_grupo_cad			:db 'Grupo Cadastrados:', 0

	message_number			:db 'Digite o numero do contato que voce quer editar: ',0
	enter_edit_name			:db 'Insira o novo nome',0


	enter_contact_search	:db 'Insira o nome do contato a ser buscado',0

	;;counts
	count :db 1
	aux   :db 1
	index : db 0
	count1: db 0
	aux2: db 0
	count_contacts: db 0
	length: dw 0
	count2: db 0

		;;user data section
	nome times 105 db 0
	group times 105 db 0
	fone times 105 db 0
	email times 105 db 0
	string_aux:db 21

	
code:
	xor ax, ax
	mov [count_contacts], ax 	; zerando o index
	call clear

jmp initialize


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

print_function:
		push bp
		mov bp,sp
		add bp,4
		mov si,[bp]
		mov cl,0
		print_string:
		lodsb
		cmp cl,al
		je continue
		mov ah,0xe
		mov bh,0
		int 0x10
		jmp print_string
		continue:
		pop bp
ret 2


read_function:
		
read:	
		mov ah,0	;recebe o caracter e armazena em al
		int 16h

		cmp al,13	;;check if the "enter" was pressed
		je exitRead

		;;cmp al, 8	; check if the BACKSPACE was pressed
		;;je DeleteCaracter

		;;mov [string_aux + di], al
		mov byte[si],al
		inc si

		mov ah,0xe
		mov bh,0
		int 0x10	;;call the video system to show the last character
							
		jmp read	;; if not,then get the next character

exitRead:		
		xor ax, ax		; atribuindo zero no final da string
		;mov [string_aux + di], al 
		mov byte[si],al
		;mov [count2], di

		;xor ax, ax
		;mov ax, [count1]
		;inc ax
		;mov [count1], ax
		;changeCursor [count1]
ret 

;;;user funtions

add_contact:
	cc 2,30
	mov si,add_contact_info_message
	push si
	call print_function

		; pegando o nome

	cc 4,5
	mov si,enter_contact_name
	push si
	call print_function

	xor di, di 
	cc 5,5

	xor ax, ax					; zera ax pois ele vai receber index
	mov al, [count_contacts]	; al recebe index, que posteriomente sera somado com nome para obtermos a posição desejada

	mov bl, 20					; bl = 20   isso esta sendo feito pois a ideia é: ax = al * bl  ( index * 20 )
	mul bl 						; ax = al*bl
 
	cc 5,5
	lea si, [nome]				; si esta recebendo o endereço de memória de nome
	add si, ax 					; 
	call read_function			; recebe a string do nome do usuario

		; pegando o grupo

	cc 7,5
	mov si,enter_contact_group
	push si
	call print_function

	xor di, di 

	xor ax, ax					; zera ax pois ele vai receber index
	mov al, [count_contacts]	; al recebe index, que posteriomente sera somado com nome para obtermos a posição desejada

	mov bl, 20					; bl = 20   isso esta sendo feito pois a ideia é: ax = al * bl  ( index * 20 )
	mul bl 						; ax = al*bl
 
	cc 8,5
	lea si, [group]				; si esta recebendo o endereço de memória de nome
	add si, ax 					; 
	call read_function			; recebe a string do nome do usuario

		; pegando o email

	cc 10,5
	mov si,enter_contact_email
	push si
	call print_function

	xor di, di 

	xor ax, ax					; zera ax pois ele vai receber index
	mov al, [count_contacts]	; al recebe index, que posteriomente sera somado com nome para obtermos a posição desejada

	mov bl, 20					; bl = 20   isso esta sendo feito pois a ideia é: ax = al * bl  ( index * 20 )
	mul bl 						; ax = al*bl
 
	cc 11,5
	lea si, [email]				; si esta recebendo o endereço de memória de nome
	add si, ax 					; 
	call read_function			; recebe a string do nome do usuario

		;	pegando o fone

	cc 13,5
	mov si,enter_contact_telefone
	push si
	call print_function

	xor di, di 

	xor ax, ax					; zera ax pois ele vai receber index
	mov al, [count_contacts]	; al recebe index, que posteriomente sera somado com nome para obtermos a posição desejada

	mov bl, 20					; bl = 20   isso esta sendo feito pois a ideia é: ax = al * bl  ( index * 20 )
	mul bl 						; ax = al*bl
 
	cc 14,5
	lea si, [fone]				; si esta recebendo o endereço de memória de nome
	add si, ax 					; 
	call read_function			; recebe a string do nome do usuario


		; incrementando o count_contacts
	xor dx, dx					; zera dx
	mov dx, [count_contacts]	; dx recebe o que tem em index
	inc dx						; incrementa dx 
	mov [count_contacts], dx	; move o resultado do incremento para index

	call clear
	mov si, register_done
	push si
	call print_function

	mov ah,0
	int 16h

	;;Display
	mov ah,0xe
	mov bh,0
	int 0x10

jmp program


search_contact:
	cc 2,30
	mov si,search_contact_info_message
	push si
	call print_function

	cc 4,5
	mov si,enter_contact_search
	push si
	call print_function

	cc 12,5
	;;Get the character 

	mov ah,0
	int 16h

	;;Display
	mov ah,0xe
	mov bh,0
	int 0x10

jmp program


edit_contact:
	cc 4,5
	mov si,edit_contact_info_message
	push si
	call print_function
	

		; mostrando os nomes
	xor ax, ax						; zera ax pois ele vai receber index
	mov al, [count_contacts]	; al recebe index, que posteriomente sera somado com nome para obtermos a posição d

	mov bl, 20						; bl = 20   isso esta sendo feito pois a ideia é: ax = al * bl  ( index * 20 )
	mul bl 							; ax = al*bl
	mov word [length],ax

	xor di, di
	mov [count2], di
	mov dl,6
	mov [aux2],dl
	cc 5,5
	xor di, di
	
	loop3:
		cc [aux2], 5	

		mov bl, [count2]
		add bl, '0'
		mov byte[count2], bl

		lea si, [count2]
		push si
		call print_function

		cc [aux2], 7

		lea si,[nome + di]
		push si
		call print_function
		
		mov dl,[aux2]
		add dl,1
		mov byte [aux2],dl

		mov bl, [count2]
		sub bl, '0'
		mov byte[count2], bl

		mov dl, [count2]
		add dl, 1
		mov byte[count2], dl

		add di,20
		cmp di,[length]

	jne loop3
xor di, di


	;;Get the character 

	cc 12,5
	mov si, message_number
	push si
	call print_function

	cc 14,5

	mov ah,0
	int 16h

		;;Display
	mov ah,0xe
	mov bh,0
	int 0x10
		;;Convert Input
	sub al,'0'
	mov byte [aux],al
	mov di,[aux]

		;;call clear
	
	cc 16,5	
			
	mov si,enter_edit_name
	push si
	call print_function

	xor ax, ax					; zera ax pois ele vai receber aux
	mov al, [aux]				; al recebe aux, que posteriomente sera somado com nome para obtermos a posição desejada

	mov bl, 20					; bl = 20   isso esta sendo feito pois a ideia é: ax = al * bl  ( aux * 20 )
	mul bl 						; ax = al*bl
 	
 	mov di,ax
	cc 17,5
	lea si, [nome + di]				; si esta recebendo o endereço de memória de nome
	;;add si, ax 					; 
	call read_function			; recebe a string do nome do usuario

jmp program


delet_contact:
	cc 4,5
	mov si,delet_contact_info_message
	push si
	call print_function
	cc 12,5
	;;Get the character 

	mov ah,0
	int 16h

	;;Display
	mov ah,0xe
	mov bh,0
	int 0x10

jmp program



show_contacts:
	
	cc 2,5
	mov si,show_contacts_info_message
	push si
	call print_function	

	xor ax, ax						; zera ax pois ele vai receber index
	mov al, [count_contacts]	; al recebe index, que posteriomente sera somado com nome para obtermos a posição d

	mov bl, 20						; bl = 20   isso esta sendo feito pois a ideia é: ax = al * bl  ( index * 20 )
	mul bl 							; ax = al*bl
	mov word [length],ax

	xor di, di
	mov dl,6
	mov [aux2],dl
	cc 5,5
	
	lea si, [print_grupo_cad]
	push si
	call print_function

	loop:
		cc [aux2],22

		lea si,[group + di]
		push si
		call print_function

		mov dl,[aux2]
		add dl,2
		mov byte [aux2],dl

		cc [aux2],5

		add di,20
		cmp di,[length]

	jne loop


	mov ah,0
	int 16h

		;Display
	mov ah,0xe
	mov bh,0
	int 0x10

jmp program




show_contacts_full:

	xor ax, ax						; zera ax pois ele vai receber index
	mov al, [count_contacts]	; al recebe index, que posteriomente sera somado com nome para obtermos a posição d

	mov bl, 20						; bl = 20   isso esta sendo feito pois a ideia é: ax = al * bl  ( index * 20 )
	mul bl 							; ax = al*bl
	mov word [length],ax

	xor di, di
	mov dl,5
	mov [aux2],dl
	cc 5,5
	
	loop2:
		
		lea si, [print_nome]
		push si
		call print_function

		cc [aux2], 11
			
		lea si,[nome + di]
		push si
		call print_function
		
		mov dl,[aux2]
		add dl,2
		mov byte [aux2],dl
		
		cc [aux2],5	

		mov dl,[aux2]
		add dl,2
		mov byte [aux2],dl

		cc [aux2],5
		

		add di,20
		cmp di,[length]

	jne loop2


	mov ah,0
	int 16h

		;Display
	mov ah,0xe
	mov bh,0
	int 0x10

jmp program


initialize:;;Initalize Variable's Values

paint_background_color: ;;Paint the Background with some Color 
mov ah,0Bh 
mov bh,0
mov bl,1
int 10h

;;main loop
program:
call clear
cc 2,30
print program_name


cc 5,5
mov si,choose_message
push si
call print_function
cc 6,5
mov si,add_contact_message
push si
call print_function
cc 7,5
mov si,search_contact_message
push si
call print_function
cc 8,5
mov si,edit_contact_message
push si
call print_function
cc 9,5
mov si,delet_contact_message
push si
call print_function
cc 10,5
mov si,show_contacts_message
push si
call print_function
cc 11,5
mov si, show_contacts_full_message
push si
call print_function
cc 12,5
mov si,quit_program_message
push si
call print_function


cc 13,5
;;Get the character 

mov ah,0
int 16h

;;Display
mov ah,0xe
mov bh,0
int 0x10

;Convert Input
sub al ,'0'
mov byte [aux],al
mov di,[aux]

call clear
cmp di,0			;;check if the user choosed the option 1
jz add_contact
cmp di,1			;;check if the user choosed the option 1
jz search_contact
cmp di,2			;;check if the user choosed the option 1
jz edit_contact
cmp di,3
jz delet_contact
cmp di,4
jz show_contacts
cmp di,5
jz show_contacts_full


endfunction:
cc 8,5
mov si,message_thanks
push si
call print_function

times	8128 - ($ - $$) db 0
dw	0xAA55

