;   hdrdata.inc
;
;
;   table to recover type word from type ordinal
;

	global	typet
typet:
        dd      b_art   ; arblk type word - 0
        dd      b_cdc   ; cdblk type word - 1
        dd      b_exl   ; exblk type word - 2
        dd 	b_icl   ; icblk type word - 3
        dd      b_nml   ; nmblk type word - 4
        dd      p_aba   ; p0blk type word - 5
        dd      p_alt   ; p1blk type word - 6
        dd      p_any   ; p2blk type word - 7
        dd	 b_rcl   ; rcblk type word - 8
        dd	 b_scl   ; scblk type word - 9
        dd      b_sel   ; seblk type word - 10
        dd      b_tbt   ; tbblk type word - 11
        dd	 b_vct   ; vcblk type word - 12
        dd	 b_xnt   ; xnblk type word - 13
        dd	 b_xrt   ; xrblk type word - 14
        dd      b_bct   ; bcblk type word - 15
        dd      b_pdt   ; pdblk type word - 16
        dd      b_trt   ; trblk type word - 17
        dd      b_bft   ; bfblk type word   18
        dd      b_cct   ; ccblk type word - 19
        dd      b_cmt   ; cmblk type word - 20
        dd      b_ctt   ; ctblk type word - 21
        dd      b_dfc   ; dfblk type word - 22
        dd	 b_efc   ; efblk type word - 23
        dd      b_evt   ; evblk type word - 24
        dd      b_ffc   ; ffblk type word - 25
        dd      b_kvt   ; kvblk type word - 26
        dd      b_pfc   ; pfblk type word - 27
        dd      b_tet   ; teblk type word - 28
;
;   table of minimal entry points that can be accessed from c
;   via the minimal function (see inter.asm).
;
;   note that the order of entries in this table must correspond
;   to the order of entries in the call enumeration in osint.h
;   and osint.inc.
;
	global	calltab
calltab:
        dd      relaj
        dd      relcr
        dd      reloc
        dd      alloc
        dd      alocs
        dd      alost
        dd      blkln
        dd      insta
        dd      rstrt
        dd      start
        dd      filnm
        dd      dtype
;       dd      enevs #  engine words
;       dd      engts #   not used

;
;   table of minimal variables that can be accessed from c
;   and assembly-language via macros getoff, getptr, getmin, and setmin.
;
;   there are two ways of setting this up.  if the symbol "direct" is
;   non-zero, the symbols are declared public and accessed directly.
;   if direct is zero, access is via the function minadr in inter.asm.
;
;   the macros getoff, getptr, getmin, and setmin in osint.h and osint.inc
;   must be adjusted when direct is changed.
;
;   note that the order of entries in this table must correspond to the
;   order of entries in the val enumeration in osint.h and osint.inc.
;
;%if	 direct != 0
;        .macro  access name
;        pubname \name
;        .endm
;.else
;        .macro  access name
;        address \name
;        .endm
;
;        pubdef  valtab
;.endif
	global	gbcnt
	global	headv
	global	mxlen
	global	stage
	global	timsx
	global	dnamb
	global	dnamp
	global	state
	global	b_efc
	global	b_icl
	global	b_scl
	global	b_vct
	global	b_xnt
	global	b_xrt
	global	stbas
	global	statb
	global	polct
;.ifeq direct
 	global  typet
;.endif
	global	lowspmin
	global	flprt
	global	flptr
	global	gtcef
	global	hshtb
	global	pmhbs
	global	r_fcb
	global	c_aaa
	global	c_yyy
	global	g_aaa
	global	w_yyy
	global	s_aaa
	global	s_yyy
	global	r_cod
	global	kvstn
	global	kvdmp
	global	kvftr
	global	kvcom
	global	kvpfl
	global	cswfl
        global  stmcs
        global  stmct
	global	b_rcl
	global	end_min_data

