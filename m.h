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

	%define	os	unix	; default
	%define	unix
	%define	ws	64	; default

%ifdef	osx_64
	%define	os	osx
	%define	osx
	%define	ws	64
	default	rel		; use rip addressing
%endif

%ifdef	unix_32
	%define	os	unix
	%define	unix
	%define	ws	32
%endif

%ifdef	unix_64
	%define	os	unix
	%define	unix
	%define	ws	64
%endif

	%define m_char	byte	; reference to byte in memory
	%define d_char	db	; define value of byte
	%define m_real	qword	; reference to floating point value in memory
	%define d_real	dq	; define value for floating point

%if	ws=32
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
%ifdef osx
	%define m(ref) qword[rel ref]
	%define a(ref) [rel ref]
%else
	%define m(ref) qword[ref]
	%define a(ref) [ref]
%endif
%endif

;	flags
	%define	flag_of	0x80
	%define	flag_cf	0x01
	%define	flag_ca	0x40

%ifdef osx
; redefine symbols needed by C to account for leading _ inserted by C compiler on osx
	%define	b_icl		_b_icl
	%define	b_scl		_b_scl
	%define	b_xnt		_b_xnt
	%define	b_xrt		_b_xrt
	%define	c_aaa		_c_aaa
	%define	c_yyy		_c_yyy
	%define	dnamb		_dnamb
	%define	dnamp		_dnamp
	%define	errors		_errors
	%define	flprt		_flprt
	%define	flptr		_flptr
	%define	g_aaa		_g_aaa
	%define	get_fp		_get_fp
	%define	gtcef		_gtcef
	%define	hasfpu		_hasfpu
	%define	headv		_headv
	%define	hshtb		_hshtb
	%define	id1blk		_id1blk
	%define	id2blk		_id2blk
	%define	inf		_inf
	%define	inpbuf		_inpbuf
	%define	minimal		_minimal
	%define	phrases		_phrases
	%define	pmhbs		_pmhbs
	%define	polct		_polct
	%define	r_fcb		_r_fcb
	%define	reg_block	_reg_block
	%define	reg_cp		_reg_cp
	%define	reg_xl		_reg_xl
	%define	reg_xr		_reg_xr
	%define	reg_xs		_reg_xs
	%define	reg_w0		_reg_w0
	%define	reg_wa		_reg_wa
	%define	reg_wb		_reg_wb
	%define	reg_wc		_reg_wc
	%define	reg_ia		_reg_ia
	%define	reg_fl		_reg_fl
	%define	reg_ra		_reg_ra
	%define	reg_rp		_reg_rp
	%define	reg_size	_reg_size
	%define	restart		_restart
	%define	s_aaa		_s_aaa
	%define	s_yyy		_s_yyy
	%define	startup		_startup
	%define	state		_state
	%define	stbas		_stbas
	%define	ticblk		_ticblk
	%define	tscblk		_tscblk
	%define	ttybuf		_ttybuf
	%define	w_yyy		_w_yyy
	%define	f_adr		_f_adr
	%define	f_atn		_f_atn
	%define	f_chk		_f_chk
	%define	f_cos		_f_cos
	%define	f_cpr		_f_cpr
	%define	f_dvr		_f_dvr
	%define	f_etx		_f_etx
	%define	f_itr		_f_itr
	%define	f_ldr		_f_ldr
	%define	f_lnf		_f_lnf
	%define	f_mlr		_f_mlr
	%define	f_ngr		_f_ngr
	%define	f_rti		_f_rti
	%define	f_sbr		_f_sbr
	%define	f_sin		_f_sin
	%define	f_sqr		_f_sqr
	%define	f_str		_f_str
	%define	f_tan		_f_tan
	%define	i_cvd		_i_cvd
	%define	i_dvi		_i_dvi
	%define	i_rmi		_i_rmi
	%define	lmodstk		_lmodstk
	%define	outptr		_outptr
	%define	rereloc		_rereloc
	%define	stacksiz		_stacksiz
	%define	startbrk		_startbrk
	%define	swcoup		_swcoup
	%define	zysaz		_zysaz
	%define	zysbs		_zysbs
	%define	zysbx		_zysbx
	%define	zysdc		_zysdc
	%define	zysdm		_zysdm
	%define	zysdt		_zysdt
	%define	zysea		_zysea
	%define	zysef		_zysef
	%define	zysej		_zysej
	%define	zysem		_zysem
	%define	zysen		_zysen
	%define	zysep		_zysep
	%define	zysex		_zysex
	%define	zysfc		_zysfc
	%define	zysgc		_zysgc
	%define	zyshs		_zyshs
	%define	zysid		_zysid
	%define	zysif		_zysif
	%define	zysil		_zysil
	%define	zysin		_zysin
	%define	zysio		_zysio
	%define	zysld		_zysld
	%define	zysmm		_zysmm
	%define	zysmx		_zysmx
	%define	zysou		_zysou
	%define	zyspi		_zyspi
	%define	zyspl		_zyspl
	%define	zyspp		_zyspp
	%define	zyspr		_zyspr
	%define	zysrd		_zysrd
	%define	zysri		_zysri
	%define	zysrw		_zysrw
	%define	zysst		_zysst
	%define	zystm		_zystm
	%define	zystt		_zystt
	%define	zysul		_zysul
	%define	zysxi		_zysxi
%endif

