;******************************************************************************************
;Anderson Felix,Diogo Shiroto,Guilherme Henrique,Hugo Ricardo,Matheus Barbosa
;Questão da Aula prática sobre a FPU

section .data
const_0299   :dd 0.299  
const_0587   :dd 0.587
const_0144   :dd 0.114   
const_0713   :dd 0.713
const_0564   :dd 0.564
const_128	 :dd 128  	
const_50	 :dd 50
const_115	 :dd 115
const_180    :dd 180
const_85     :dd 85
const_135    :dd 135
red_input    :dd 60		;;valor de vermelho no pixel
green_input  :dd 60			;;valor de verde no pixel
blue_input   :dd 60		;;Valor de azul no pixel
y            :dq 0
cr			 :dq 0
cb  		 :dq 0




msg_white_pixel: db "A cor do Pixel é branca", 13, 10, 0
lenmsg_white_pixel: equ $ - msg_white_pixel

msg_black_pixel: db "A cor do pixel é preta", 13, 10, 0
lenmsg_black_pixel: equ $ - msg_black_pixel

section .text
global _start
_start:

;;Começando a primeira etapa e calculando o luminancia
fld dword[const_0299]      	;;Empilhamos a primeira constante 0.299,que nesse momento está em st0
fld dword[red_input]		;;Empilhamos a entrada do valor do pixel
fmulp st1,st0 				;;Multiplicamos o que está st0 por st1 e colocamos o resultado em st1,após isso desempilha o sto
fld dword[const_0587]      	;;Empilhamos a primeira constante 0.587,que nesse momento está em st0
fld dword[green_input]		;;Empilhamos a entrada do valor do pixel
fmulp st1,st0 				;;Multiplicamos o que está st0 por st1 e colocamos o resultado em st1,após isso desempilha o stosto
faddp						;;Soma St0 com st1,coloca o resultado em St1 e desempilha o sto
fld dword[const_0144]      	;;Empilhamos a primeira constante 0.587,que nesse momento está em st0
fld dword[blue_input]		;;Empilhamos a entrada do valor do pixel
fmulp st1,st0 				;;Multiplicamos o que está st0 por st1 e colocamos o resultado em st1,após isso desempilha o sto
faddp						;;Soma St0 com St1,coloca o resultado em st1 e desempilha
fstp dword[y]				;;Salvamos o valor calculado em y,guardando em si o topo da pilha


;;Começando segunda etapa do calculo,achando a crominancia,nesse etapa y está no topo da pilha
fld dword[red_input]		;;pilha está zerada,coloco o valor de vermelho
fld dword[y]				;;agora o topo da pilha está com o valor calculado no item 1
fsubp						;;realiza a subtração (R-Y)
fld dword[const_0713]		;;Carregando a constante
fmulp	st1,st0				;;multiplicando o topo da pilha por st1(R-Y)*0.713
fld dword[const_128]		;;Constante para ser somada
faddp						;;Soma st0 com st1(R-Y)*0.713 + 128 e desimpilha,topo atual tem o resultado


fstp dword[cr]				;;Salvando a crominancia na memória


;;Começando a terceira etapa,calculando a crominancia


fld dword[blue_input]		;;pilha estava vazia e agora possui
fld dword[y]				;;
fsubp   					;;(B-Y)
fld dword[const_0564]		;;Carregando a constante
fmulp	st1,st0				;;multiplicando o topo da pilha por st1(B-Y)*0.564
fld dword[const_128]		;;Constante para ser somada
faddp						;;Soma       St0 e St1 (B-Y)*0.564 + 128                     

fstp dword[cb]				;;Salvando a crominancia  e retirando da pilha da fpu


;;Comparando resultados obtidos dos calculos das etapas anteriores

;;pilha estava vazia,agora possui 50 | y,e podemos verificar 50 < Y
fld dword[y]
fld dword[const_50]
fcomip	st0,st1				
ja		pixel_preto				;;Se 50 >=y,fim de comparação e o pixel é preto	


fld dword[cr]					;;Carrega o valor calulado em CR
fld dword[const_115]			;;Carrega a constante 115
fcomip	st0,st1					;;Compara st0 com st1 e seta flags


ja		pixel_preto				;;Se 115>cr,fim de comparação e o pixel é preto


fld dword[const_180]			;;Coloco 180 no topo da pilha			

ja		pixel_preto				;;Se 180 > cr,fim de comparação e o pixel é preto

;;nesse passo temos dois valores na pilha,seria bom retirar

fld dword[cb]
fld dword[const_85]
fcomip st0,st1
ja		pixel_preto				;;Se 85>cb,fim de comparação e o pixel é preto


fld dword[const_135]			;;Coloco 135 no topo da pilha
ja	pixel_preto					;;Se 135 > cb,o pixel é preto


;;Exibindo o resultado da comparação

pixel_branco:				;;Se chegou até aqui,passou por todas as condições e o pixel é branco
mov eax, 4
mov ebx, 1
mov ecx, msg_white_pixel
mov edx, lenmsg_white_pixel
int 80h

jmp exit

pixel_preto:
mov eax, 4
mov ebx, 1
mov ecx, msg_black_pixel
mov edx, lenmsg_black_pixel
int 80h


;;Exit,saída

exit:
mov eax,1
mov ebx,0
int 80h




