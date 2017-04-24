; copyright 1987-2012 robert b. k. dewar and mark emmer.
; copyright 2012-2017 david shields

; This program is licensed under the GPL2 (or later) license.

;
; this file is part of macro spitbol.
;

	%define m_char	byte	; reference to byte in memory
	%define d_char	db	; define value of byte
	%define m_real	qword	; reference to floating point value in memory
	%define d_real	dq	; define value for floating point

;	We exploit one elegant feature of the Minimal design:
;	ia and wc may share the same register.

	%define	ia	rbp

	%define	wa	rcx
	%define wa_l	cl
	%define	wb	rbx
	%define wb_l    bl
	%define	wc	rdx
	%define wc_l    dl

	%define	w0	rax

	%define	xl	rsi
	%define	xr	rdi
	%define	xs	rsp
	%define	xt	rsi


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

;	flags
	%define	flag_of	0x80
	%define	flag_cf	0x01
	%define	flag_ca	0x40
