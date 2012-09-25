	extern	at_xl;
	extern	at_xr;
	extern	at_xs;
	extern	at_wa;
	extern	at_wb;
	extern	at_wc;
	extern	at_cp;
	extern	atip;

; at is used to trace instruction pointer
%macro	ati	1
; save flags, save registers, put ip on top of stack, and call 'at' procedure
	pushf
	pushad
	mov	dword [at_xl],esi
	mov	dword [at_xr],edi
	mov	dword [at_xs],esp
	mov	dword [at_wa],ecx
	mov	dword [at_wb],ebx
	mov	dword [at_wc],edx
	mov	dword [at_cp],ebp

; there is no explicit instruction to save ip, so just do call that has the
; effect of pushing ip onto the stack
	push	%1
	call	%%ati
%%ati:
	call	atip
; back from at, pop arguments, restore registers, restore flags
	pop	ax
	pop	ax
	popad
	popf
%endmacro
