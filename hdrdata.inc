#   hdrdata.inc
#
#
#   table to recover type word from type ordinal
#

        pubdef  typet
        .long   b_art   # arblk type word - 0
        .long   b_cdc   # cdblk type word - 1
        .long   b_exl   # exblk type word - 2
        address b_icl   # icblk type word - 3
        .long   b_nml   # nmblk type word - 4
        .long   p_aba   # p0blk type word - 5
        .long   p_alt   # p1blk type word - 6
        .long   p_any   # p2blk type word - 7
        address b_rcl   # rcblk type word - 8
        address b_scl   # scblk type word - 9
        .long   b_sel   # seblk type word - 10
        .long   b_tbt   # tbblk type word - 11
        address b_vct   # vcblk type word - 12
        address b_xnt   # xnblk type word - 13
        address b_xrt   # xrblk type word - 14
        .long   b_bct   # bcblk type word - 15
        .long   b_pdt   # pdblk type word - 16
        .long   b_trt   # trblk type word - 17
        .long   b_bft   # bfblk type word   18
        .long   b_cct   # ccblk type word - 19
        .long   b_cmt   # cmblk type word - 20
        .long   b_ctt   # ctblk type word - 21
        .long   b_dfc   # dfblk type word - 22
        address b_efc   # efblk type word - 23
        .long   b_evt   # evblk type word - 24
        .long   b_ffc   # ffblk type word - 25
        .long   b_kvt   # kvblk type word - 26
        .long   b_pfc   # pfblk type word - 27
        .long   b_tet   # teblk type word - 28
#
#   table of minimal entry points that can be accessed from c
#   via the minimal function (see inter.asm).
#
#   note that the order of entries in this table must correspond
#   to the order of entries in the call enumeration in osint.h
#   and osint.inc.
#
        pubdef  calltab
        .long   relaj
        .long   relcr
        .long   reloc
        .long   alloc
        .long   alocs
        .long   alost
        .long   blkln
        .long   insta
        .long   rstrt
        .long   start
        .long   filnm
        .long   dtype
#       .long   enevs #  engine words
#       .long   engts #   not used

#
#   table of minimal variables that can be accessed from c
#   and assembly-language via macros getoff, getptr, getmin, and setmin.
#
#   there are two ways of setting this up.  if the symbol "direct" is
#   non-zero, the symbols are declared public and accessed directly.
#   if direct is zero, access is via the function minadr in inter.asm.
#
#   the macros getoff, getptr, getmin, and setmin in osint.h and osint.inc
#   must be adjusted when direct is changed.
#
#   note that the order of entries in this table must correspond to the
#   order of entries in the val enumeration in osint.h and osint.inc.
#
.ifne direct
        .macro  access name
        pubname \name
        .endm
.else
        .macro  access name
        address \name
        .endm

        pubdef  valtab
.endif
	access	gbcnt
	access	headv
	access	mxlen
	access	stage
	access	timsx
	access	dnamb
	access	dnamp
	access	state
	access	b_efc
	access	b_icl
	access	b_scl
	access	b_vct
	access	b_xnt
	access	b_xrt
	access	stbas
	access	statb
	access	polct
.ifeq direct
	access  typet
.endif
	access	lowspmin
	access	flprt
	access	flptr
	access	gtcef
	access	hshtb
	access	pmhbs
	access	r_fcb
	access	c_aaa
	access	c_yyy
	access	g_aaa
	access	w_yyy
	access	s_aaa
	access	s_yyy
	access	r_cod
	access	kvstn
	access	kvdmp
	access	kvftr
	access	kvcom
	access	kvpfl
	access	cswfl
        access  stmcs
        access  stmct
	access	b_rcl
	access	end_min_data

