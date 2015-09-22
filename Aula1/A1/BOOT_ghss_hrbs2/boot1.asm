org 0x7c00 
jmp 0x0000:start

start:

	xor	ax,	ax
	mov	ds,	ax

try_again:
	xor	ah,	0					
	mov	dl,	ah					
	int	0x13					
	jc	try_again	

	mov	ax,	0x50	
	mov	es,	ax		
	xor	bx,	bx	
	 
	mov	ah,	0x02
	mov	al,	1
	mov	ch,	0
	mov	cl,	2
	mov	dh,	0
	mov	dl,	0	
	int	0x13					
	
	jmp	0x50:0x0

times 510-($-$$) db 0		
dw 0xaa55					
