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

	.intel_syntax

        .text

	.include	"m.h"

	.extern	osisp
	.extern	compsp
	.extern	save_regs
	.extern	restore_regs
	.extern	_rc_
	.extern	reg_fl
	.extern	reg_w0

	.global	mxint

.ifdef zz_trace
	.extern	shields
	.extern	zz
	.extern	zz_
	.extern	zz_cp
	.extern	zz_xl
	.extern	zz_xr
	.extern	zz_xs
	.extern	zz_wa
	.extern	zz_wb
	.extern	zz_wc
	.extern	zz_w0
	.extern	zz_zz
	.extern	zz_id
	.extern	zz_de
	.extern	zz_0
	.extern	zz_1
	.extern	zz_2
	.extern	zz_3
	.extern	zz_4
	.extern	zz_arg
	.extern	zz_num
.endif
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

	.macro	adi_	a1
	add	IA,\a1
	seto	byte [reg_fl]
	.endm


	.macro	chk_	
	.extern	chk__	
	call	chk__
	.endm

	.extern	cvd__

	.macro	cvd_
	call	cvd__
	.endm

	.extern	dvi__ val

	.macro	dvi_	
	mov	W0,\val
	call	dvi__
	.endm

	.macro	icp_
	mov	W0,m_word [reg_cp]
	add	W0,cfp_b
	mov	m_word [reg_cp],W0
	.endm

	.macro	ino_	a1
	mov	al,byte [reg_fl]
	or	al,al
	jno	\a1
	.endm

	.macro	iov_	a1
	mov	al,byte [reg_fl]
	or	al,al
	jo	\a1
	.endm

	.macro	ldi_	a1
	mov	IA,\a1
	.endm

	.macro	mli_	a1
	imul	IA,\a1
	seto	byte [reg_fl]
	.endm

	.macro	ngi_
	neg	IA
	seto	byte [reg_fl]
	.endm

	.extern	rmi__
	.macro	rmi_
	mov	W0,\a1
	call	rmi__
	.endm

	.extern	f_rti
	.macro	rti_

	call	f_rti
	mov	IA,m_word [reg_ia]
	.endm

	.macro	sbi_	a1
	sub	IA,\a1
	mov	W0,0
	seto	byte [reg_fl]
	.endm

	.macro	sti_	a1
	mov	\a1,ia
	.endm

	.macro	lcp_	a1
	mov	W0,\a1
	mov	m_word [reg_cp],W0
	.endm

	.macro	lcw_	a1
	mov	W0,m_word [reg_cp]		# load address of code word
	mov	W0,m_word [W0]			# load code word
	mov	\a1,W0
	mov	W0,m_word [reg_cp]		# load address of code word
	add	W0,cfp_b
	mov	m_word [reg_cp],W0
	.endm

	.macro	rno_	a1
	mov	al,byte [reg_fl]
	or	al,al
	je	\a1
	.endm

	.macro	rov_	a1
	mov	al,byte [reg_fl]
	or	al,al
	jne	\a1
	.endm

	.macro	scp_	a1
	mov	W0,m_word [reg_cp]
	mov	\a1,W0
	.endm

.ifdef zz_trace
	.macro	zzz	a1,a2,a3
	.data
%%desc:	db	\a3,0
	.text
	mov	m_word [zz_id],\a1
	mov	m_word [zz_zz],\a2
	mov	m_word [zz_de],%%desc
	call	zz_
	.endm
.endif
