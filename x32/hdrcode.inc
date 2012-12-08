;   HDRCODE.INC
;
;  No header code in 386 version.
;
%define XL.ESI ESI
%define XT.ESI ESI
%define XR.EDI EDI
%define XS.ESP ESP
%define WA.ECX ECX
%define WB.EBX EBX
%define WC.EDX EDX
%define IA.EDX EDX
%define CP.EBP EBP
%define W0.EAX EAX
	extern	_rc_
%ifdef AT_TRACE
	extern	at_xl
	extern	at_xr
	extern	at_xs
	extern	at_wa
	extern	at_wb
	extern	at_wc
	extern	at_w0
	extern	at_zz
%endif
	global	START

	%macro	ZZZ	1
	pushf
	pushad
%ifdef AT_TRACE
	mov	dword [at_zz],%1
	mov	dword [at_xl],esi
	mov	dword [at_xr],edi
	mov	dword [at_xs],esp
	mov	dword [at_wa],ecx
	mov	dword [at_wb],ebx
	mov	dword [at_wc],edx
	mov	dword [at_w0],eax
%endif
;	push	%1
;	pop	eax
	popad
	popf
	%endmacro

