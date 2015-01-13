; copyright 1987-2012 robert b. k. dewar and mark emmer.

; copyright 2012-2015 david shields
;
; this file is part of macro spitbol.
;
;     macro spitbol is free software: you can redistribute it and/or modify
;     it under the terms of the gnu general public license as published by
;     the free software foundation, either version 2 of the license, or
;     (at your option) any later version.
;
;     macro spitbol is distributed in the hope that it will be useful,
;     but without any warranty; without even the implied warranty of
;     merchantability or fitness for a particular purpose.  see the
;     gnu general public license for more details.
;
;     you should have received a copy of the gnu general public license
;     along with macro spitbol.  if not, see <http://www.gnu.org/licenses/>.

	%define m_char	byte	; reference to byte in memory
	%define d_char	db	; define value of byte
	%define m_real	qword	; reference to floating point value in memory
	%define d_real	dq	; define value for floating point

%ifdef	m32
	%define	xl	esi
	%define	xt	esi
	%define xr	edi
	%define xs	esp
	%define w0	eax
	%define w1	ebp
	%define wa	ecx
	%define wa_l    cl
	%define wb	ebx
	%define wb_l  	bl
	%define wc	edx
	%define wc_l  	dl
;	%define ia	edx
	%define ia	ebp
	%define m_word	dword	; reference to word in memory
	%define d_word	dd	; define value for memory word
;	%define	cfp_b	4
	%define log_cfp_b 2
	%define cfp_c_val	4
	%define log_cfp_c 2
	%define cfp_m_	2147483647
;	%define	cfp_n_	32

	%define	lods_b	lodsb
	%define	lods_w	lodsd
	%define movs_b	movsb
	%define movs_w	movsd
	%define	stos_b	stosb
	%define	stos_w	stosd
	%define	cmps_b	cmpsb

	%define	cdq	cdq	; sign extend (32 bits)
	%define m(ref) dword[ref]
	%define a(ref) [ref]
%else
	%define		m64		// m64 is the default
	%define	xl	rsi
	%define	xt	rsi
	%define	xr	rdi
	%define	w0	rax
	%define w1	rbp
	%define	wa	rcx
	%define wa_l	cl
	%define	wb	rbx
	%define wb_l    bl
	%define	wc	rdx
	%define wc_l    dl
	%define	xs	rsp
	%define	w0_l	al
;	%define	ia	rdx
	%define	ia	rbp
	%define m_word  qword
	%define d_word	dq
;	%define	cfp_b	8
	%define log_cfp_b 3
	%define log_cfp_c 3
	%define d_real	dq
	%define cfp_c_val	8
	%define log_cfp_c 3
	%define cfp_m_	9223372036854775807
;	%define	cfp_n_	64

	%define	lods_w	lodsq
	%define	lods_b	lodsb
	%define movs_b	movsb
	%define movs_w	movsq
	%define stos_b	stosb
	%define	stos_w	stosq
	%define	cmps_b	cmpsb

	%define	cdq	cqo	; sign extend (64 bits)

;	%define mem(ref) qword[ref]
	%define m(ref) qword[ rel ref]
	%define a(ref) [ rel ref]
; rel not needed for m32
	%define rel		
%endif

;	flags
	%define	flag_of	0x80
	%define	flag_cf	0x01
	%define	flag_ca	0x40
