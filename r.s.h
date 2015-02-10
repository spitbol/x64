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
#

	.att_syntax

        .text

	.include	"m.h"

	.extern	osisp
	.extern	compsp
	.extern	save_regs
	.extern	restore_regs
	.extern	_rc_
	.extern	reg_fl
	.extern	reg_w0
	.extern	rcode

	.global	mxint

	.extern	it
	.extern	it_
	.extern	it_cp
	.extern	it_xl
	.extern	it_xr
	.extern	it_xs
	.extern	it_wa
	.extern	it_wb
	.extern	it_wc
	.extern	it_w0
	.extern	it_it
	.extern	it_id
	.extern	it_de
	.extern	it_0
	.extern	it_1
	.extern	it_2
	.extern	it_3
	.extern	it_4
	.extern	it_arg
	.extern	it_num

	.global	start


#
#
#   table to recover type word from type ordinal
#

	.extern	_rc_
	.global	typet
	.data

        d_word	b_art   # arblk type word - 0
        d_word	b_cdc   # cdblk type word - 1
        d_word	b_exl   # exblk type word - 2
        d_word	b_icl   # icblk type word - 3
        d_word	b_nml   # nmblk type word - 4
        d_word	p_aba   # p0blk type word - 5
        d_word	p_alt   # p1blk type word - 6
        d_word	p_any   # p2blk type word - 7
# next needed only if support real arithmetic cnra
#       d_word	b_rcl   # rcblk type word - 8
        d_word	b_scl   # scblk type word - 9
        d_word	b_sel   # seblk type word - 10
        d_word	b_tbt   # tbblk type word - 11
        d_word	b_vct   # vcblk type word - 12
        d_word	b_xnt   # xnblk type word - 13
        d_word	b_xrt   # xrblk type word - 14
        d_word	b_bct   # bcblk type word - 15
        d_word	b_pdt   # pdblk type word - 16
        d_word	b_trt   # trblk type word - 17
        d_word	b_bft   # bfblk type word   18
        d_word	b_cct   # ccblk type word - 19
        d_word	b_cmt   # cmblk type word - 20
        d_word	b_ctt   # ctblk type word - 21
        d_word	b_dfc   # dfblk type word - 22
        d_word	b_efc   # efblk type word - 23
        d_word	b_evt   # evblk type word - 24
        d_word	b_ffc   # ffblk type word - 25
        d_word	b_kvt   # kvblk type word - 26
        d_word	b_pfc   # pfblk type word - 27
        d_word	b_tet   # teblk type word - 28
#
#   table of minimal entry points that can be dded from c
#   via the minimal function (see inter.asm).
#
#   note that the order of entries in this table must correspond
#   to the order of entries in the call enumeration in osint.h
#   and osint.inc.
#
	.global calltab
calltab:
        d_word	relaj
        d_word	relcr
        d_word	reloc
        d_word	alloc
        d_word	alocs
        d_word	alost
        d_word	blkln
        d_word	insta
        d_word	rstrt
        d_word	start
        d_word	filnm
        d_word	dtype
#       d_word	enevs #  engine words
#       d_word	engts #   not used

	.global	b_efc
	.global	b_icl
	.global	b_rcl
	.global	b_scl
	.global	b_vct
	.global	b_xnt
	.global	b_xrt
	.global	c_aaa
	.global	c_yyy
	.global	dnamb
	.global	cswfl
	.global	dnamp
	.global	flprt
	.global	flptr
	.global	g_aaa
	.global	gbcnt
	.global	gtcef
	.global	headv
	.global	hshtb
	.global	kvstn
	.global	kvdmp
	.global	kvftr
	.global	kvcom
	.global	kvpfl
	.global	mxlen
	.global	polct
	.global	s_yyy
	.global	s_aaa
	.global	stage
	.global	state
	.global	stbas
	.global	statb
	.global	stmcs
	.global	stmct
	.global	timsx
	.global	typet
	.global	pmhbs
	.global	r_cod
	.global	r_fcb
	.global	w_yyy
	.global	end_min_data


	.extern	adr_
	.extern	atn_
	.extern	chp_
	.extern	cos_
	.extern	cpr_
	.extern	dvr_
	.extern	etx_
	.extern	itr_
	.extern	ldr_
	.extern	lnf_
	.extern	mlr_
	.extern	ngr_
	.extern	ovr_
	.extern	sbr_
	.extern	sin_
	.extern	str_
	.extern	sqr_
	.extern	tan_

	.extern	reg_cp

	.extern	reg_ia,reg_wa,reg_fl,reg_w0,reg_wc

	.macro	chk_	
	.extern	chk__	
	call	chk__
	.endm

	.extern	cvd__

	.macro	cvd_
	call	cvd__
	.endm

	.macro	icp_
	mov	reg_cp,W0
	add	cfp_b,W0
	mov	W0,reg_cp
	.endm

	.macro	ino_	val
	mov	reg_fl,%al
	or	%al,%al
	jno	\val
	.endm

	.macro	iov_	val
	mov	reg_fl,%al
	or	%al,%al
	jo	\val
	.endm

	.extern	f_rti

	.macro	rti_
	call	f_rti
	mov	(reg_ia),IA
	.endm

	.macro	lcp_	val
	mov	\val,W0
	mov	W0,reg_cp
	.endm

	.macro	lcw_	val
	mov	reg_cp,W0		# load address of code word
	mov	(W0),W0			# load code word
	mov	W0,\val
	mov	reg_cp,W0		# load address of code word
	add	cfp_b,W0
	mov	W0,reg_cp
	.endm

	.macro	rno_	val
	mov	reg_fl,%al
	or	%al,%al
	je	\val
	.endm

	.macro	rov_	val
	mov	reg_fl,%al
	or	%al,%al
	jne	\val
	.endm

	.macro	scp_	val
	mov	(reg_cp),W0
	mov	W0,\val
	.endm
