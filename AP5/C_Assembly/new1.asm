;extern printf
global _asm_sin
global _asm_cos
global _asm_tan
global _asm_pow
global _asm_sqrt
global _asm_log10
global _asm_log
global _asm_exp

section .data
	const_1 dq 1.0
	const_2 dq 2.0
section .text
_asm_sin:
	enter 0, 0
	
	finit
	fld		qword[esp+8]
	fsin
	
	leave
	ret
	
_asm_cos:
	enter 0, 0
	
	finit
	fld qword[esp+8]
	fcos
	
	leave
	ret
	
_asm_tan:
	enter 0, 0
	
	finit
	fld qword[esp+8]
	fcos
	
	fld qword[esp+8]
	fsin
	
	fdiv st0, st1
	
	leave
	ret
	
_asm_pow:				; x^y = 2^(y*log2(x))
	enter 0, 0
	
	finit
	fld qword[esp+16]	; carrega y na pilha - st0 = y
	fld qword[esp+8]	; carrega x na pilha - st0 = x , st1 = y
	fyl2x				; st0 = y*log2(x)
	
	f2xm1				; st(0) = 2^(y*log2(x)) - 1
	fld1				; empinha 1, pois ele vai cancelar o -1 da função acima
	fadd st0, st1		; st(0) = 2^(y*log2(x) -1 + 1) = x^y
	
	leave
	ret
	
_asm_sqrt:
	enter 0, 0
	
	finit				; reseta a fpu
	fld qword[esp+8]	; carrega o parâmetro passado, na pilha.
	fsqrt				; calcula a raiz quadrada de st0 e coloca em st0
	
	leave
	ret
	
_asm_log10:
	enter 0, 0
						; log10(x) = log10(2) * log2(x)
	finit 				; reseta a fpu
	fldlg2				; calcula o log10(2) e coloca em st0
	fld qword[esp+8]	; coloca o parametro em st0
	fyl2x				; calcula log2(st0) == log2(x) , e multiplica por st1 == log10(2), e por fim, armazena o resultado em st0	
	
	leave
	ret
	
_asm_log:
	enter 0, 0
						; ln(x) = ln(2) * log2(x)
	finit				; reseta a fpu
	fldln2				; calcula o ln(2) e armazena em st0
	fld qword[esp+8]	; armazena o parametro no topo da pilha, em st0
	fyl2x				; calcula log2(st0) == log2(x), e multiplica por st1 == ln(2), e armazena em st0
	
	leave
	ret
	
_asm_exp:
	enter 	0, 0
	
	finit				; reseta a fpu
	fld	qword[esp+8]	; st0 = x
	fldl2e				; calcula o log2(e), logo, st0 = log2(e) e st1 = x
	fmulp				; multiplica st0 por st1 e coloca o resultado em st0, logo, st0 = xlog2(e)
	fld1				; st0 = 1, st1 = xlog2(e)
	fxch	; troca[1] com [expoente], ou seja, st0 = xlog2(e), st1 = 1
	
	fcom qword[const_1]	; compara st0 que é o expoente com a constante 1
	fstsw ax				; Carrega FPU Flags em AX
	sahf					; Carrega AH no E-Flags
	jb	exp_menor_um
			; Se o expoente for maior que 0
	exp_maior_um:
		fcom	qword[const_1]	; Compara [expoente] com 1
		fstsw	ax				; Carrega FPU Flags em AX
		sahf					; Carrega AH no E-Flags
		jb	fracao_exp
		fxch					; troca [expoente] com [1], logo, st0 = 1 e st1 = xlog2(e)
		fmul	qword[const_2]	; multiplica o st0 [1] por [2]
		fxch					; troca o [st0], [st1], logo, st0 = xlog2(e) e st1 = resultadoDaMultiplicacaoAnterior
		fsub	qword[const_1]	; subtraindo 1 do expoente
		jmp		exp_maior_um
	fracao_exp:	; Calcular a parte fracionária do expoente
		f2xm1					; 2^(st0) - 1
		fld1					; coloca um na pilha
		faddp					; soma st0 com st1 = 2^(xlog2(e))
		fmulp					; multiplica o resultado do calculo da parte inteira com o resultado da parte fracionaria
		jmp sair_exp
	
	exp_menor_um:
		f2xm1
		faddp
	
	sair_exp:
		leave
		ret
	
	
	

