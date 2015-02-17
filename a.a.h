# copyright 1987-2012 robert b. k. dewar and mark emmer.

# copyright 2012-2015 david shields
#
# this file is part of macro spitbol.
#
#     macro spitbol is free software: you can redistribute it and/or modify
#     it under the terms of the gnu general public license as published by
#     the free software foundation, either version 2 of the license, or
#     (at your option) any later version.
#
#     macro spitbol is distributed in the hope that it will be useful,
#     but without any warranty; without even the implied warranty of
#     merchantability or fitness for a particular purpose.  see the
#     gnu general public license for more details.
#
#     you should have received a copy of the gnu general public license
#     along with macro spitbol.  if not, see <http://www.gnu.org/licenses/>.

	.set	os,	unix	# default
	.set	ws,64	# default

#ifdef	osx_64
	.set	os,osx
#	.set	osx
	.set	ws,64
#	default	rel		# use rip addressing
#endif

#ifdef	unix_32
	.set	os,unix
#	.set	unix
	.set	ws,32
#endif

#ifdef	unix_64
	.set	os,unix
#	.set	unix
	.set	ws,64
#endif

#if	ws=32
#	.set	cfp_b,4
	.set	cfp_b_m1,3
	.set	log_cfp_b,2
	.set	cfp_c_val,4
	.set	log_cfp_c,2
	.set	cfp_m_,2147483647
#	.set	cfp_n_,32

	.set	lods_b,lodsb
	.set	lods_w,lodsd
	.set	movs_b,movsb
	.set	movs_w,movsd
	.set	stos_b,stosb
	.set	stos_w,stosd
	.set	cmps_b,cmpsb

	.set	cdq,cdq	# sign extend (32 bits)
#else
#	.set	cfp_b,8
	.set	cfp_b_m1,7
	.set	log_cfp_b,3
	.set	log_cfp_c,3
	.set	d_real,dq
	.set	cfp_c_val,8
	.set	log_cfp_c,3
	.set	cfp_m_,9223372036854775807
#	.set	cfp_n_,64

	.set	lods_w,lodsq
	.set	lods_b,lodsb
	.set	movs_b,movsb
	.set	movs_w,movsq
	.set	stos_b,stosb
	.set	stos_w,stosq
	.set	cmps_b,cmpsb

	.set	cdq,cqo	# sign extend (64 bits)

#endif

	.macro	d_word	val
#if	ws=32
	.long	\val
#else
	.quad	\val
#endif
	.endm

#	flags
	.set	flag_of,0x80
	.set	flag_cf,0x01
	.set	flag_ca,0x40

#if	os=osx
# redefine symbols needed by C to account for leading _ inserted by C compiler on osx
#	.set	b_icl,_b_icl
#	.set	b_scl,_b_scl
#	.set	b_xnt,_b_xnt
#	.set	b_xrt,_b_xrt
#	.set	c_aaa,_c_aaa
#	.set	c_yyy,_c_yyy
#	.set	dnamb,_dnamb
#	.set	dnamp,_dnamp
#	.set	error	,_errors
#	.set	flprt,_flprt
#	.set	flptr,_flptr
#	.set	g_aaa,_g_aaa
#	.set	get_fp,_get_fp
#	.set	gtcef,_gtcef
#	.set	hasfpu,_hasfpu
#	.set	headv,_headv
#	.set	hshtb,_hshtb
#	.set	id1blk,_id1blk
#	.set	id2blk,_id2blk
#	.set	inf,_inf
#	.set	inpbuf,_inpbuf
#	.set	minimal,_minimal
#	.set	minimal_id,_minimal_id
#	.set	phrases,_phrases
#	.set	pmhbs,_pmhbs
#	.set	polct,_polct
#	.set	r_fcb,_r_fcb
#	.set	reg_block,_reg_block
#	.set	reg_cp,_reg_cp
#	.set	reg_xl,_reg_xl
#	.set	reg_xr,_reg_xr
#	.set	reg_xs,_reg_xs
#	.set	reg_w0,_reg_w0
#	.set	reg_wa,_reg_wa
#	.set	reg_wb,_reg_wb
#	.set	reg_wc,_reg_wc
#	.set	reg_ia,_reg_ia
#	.set	reg_fl,_reg_fl
#	.set	reg_ra,_reg_ra
#	.set	reg_rp,_reg_rp
#	.set	reg_size,_reg_size
#	.set	restart,_restart
#	.set	s_aaa,_s_aaa
#	.set	s_yyy,_s_yyy
#	.set	startup,_startup
#	.set	state,_state
#	.set	stbas,_stbas
#	.set	ticbl,	_ticblk
#	 .set	tscblk,_tscblk
#	.set	ttybuf,_ttybuf
#	.set	w_yyy,_w_yyy
#	.set	i_adi,_i_adi
#	.set	i_cvd,_i_cvd
#	.set	i_dvi,_i_dvi
#	.set	i_mli,_i_mli
#	.set	i_ngi,_i_ngi
#	.set	i_rmi,_i_rmi
#	.set	f_adr,_f_adr
#	.set	f_atn,_f_atn
#	.set	f_chk,_f_chk
#	.set	f_chp,_f_chp
#	.set	f_cos,_f_cos
#	.set	f_cpr,_f_cpr
#	.set	f_dvr,_f_dvr
#	.set	f_etx,_f_etx
#	.set	f_itr,_f_itr
#	.set	f_ldr,_f_ldr
#	.set	f_lnf,_f_lnf
#	.set	f_mlr,_f_mlr
#	.set	f_ngr,_f_ngr
#	.set	f_rti,_f_rti
#	.set	f_sbr,_f_sbr
#	.set	f_sin,_f_sin
#	.set	f_sqr,_f_sqr
#	.set	f_str,_f_str
#	.set	f_tan,_f_tan
#	.set	lmodstk,_lmodstk
#	.set	outptr,_outptr
#	.set	rereloc,_rereloc
#	.set	stacksiz,_stacksiz
#	.set	startbrk,_startbrk
#	.set	swcoup,_swcoup
#	.set	zysax,_zysax
#	.set	zysaz,_zysaz
#	.set	zysbs,_zysbs
#	.set	zysbx,_zysbx
#	.set	zysdc,_zysdc
#	.set	zysdm,_zysdm
#	.set	zysdt,_zysdt
#	.set	zysea,_zysea
#	.set	zysef,_zysef
#	.set	zysej,_zysej
#	.set	zysem,_zysem
#	.set	zysen,_zysen
#	.set	zysep,_zysep
#	.set	zysex,_zysex
#	.set	zysfc,_zysfc
#	.set	zysgc,_zysgc
#	.set	zyshs,_zyshs
#	.set	zysid,_zysid
#	.set	zysif,_zysif
#	.set	zysil,_zysil
#	.set	zysin,_zysin
#	.set	zysio,_zysio
#	.set	zysld,_zysld
#	.set	zysmm,_zysmm
#	.set	zysmx,_zysmx
#	.set	zysou,_zysou
#	.set	zyspi,_zyspi
#	.set	zyspl,_zyspl
#	.set	zyspp,_zyspp
#	.set	zyspr,_zyspr
#	.set	zysrd,_zysrd
#	.set	zysri,_zysri
#	.set	zysrw,_zysrw
#	.set	zysst,_zysst
#	.set	zystm,_zystm
#	.set	zystt,_zystt
#	.set	zysul,_zysul
#	.set	zysxi,_zysxi
#endif

