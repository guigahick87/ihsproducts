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
	quit_program_message  	:db 'Sair do programa(5)',0
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


	enter_contact_search	:db 'Insira o nome do contato a ser buscado',0

	;;counts
	count :db 1
	aux   :db 1

	;;user data section
	table  times 10 db 0
	
code:

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

add_contact:
cc 2,30
mov si,add_contact_info_message
push si
call print_function

cc 4,5
mov si,enter_contact_name
push si
call print_function

cc 6,5
mov si,enter_contact_group
push si
call print_function

cc 8,5
mov si,enter_contact_telefone
push si
call print_function

cc 10,5
mov si,enter_contact_email
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
cc 12,5
;;Get the character 

mov ah,0
int 16h

;;Display
mov ah,0xe
mov bh,0
int 0x10

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
cc 4,5
mov si,show_contacts_info_message
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
mov si,quit_program_message
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


endfunction:
cc 8,5
mov si,message_thanks
push si
call print_function

times	8128 - ($ - $$) db 0
dw	0xAA55

