;   hdrdata.inc
;
;
;   table to recover type word from type ordinal
;
	%include	"mintype.h"

;%macro  pubdef 3
;        global %1
;%1:	%2	%3
;%endmacro
        global  typet
b_rcl:	dd	0
typet:
        dd      b_art   ; arblk type word - 0
        dd      b_cdc   ; cdblk type word - 1
        dd      b_exl   ; exblk type word - 2
        dd 	b_icl   ; icblk type word - 3
        dd      b_nml   ; nmblk type word - 4
        dd      p_aba   ; p0blk type word - 5
        dd      p_alt   ; p1blk type word - 6
        dd      p_any   ; p2blk type word - 7
        dd 	b_rcl   ; rcblk type word - 8
        dd 	b_scl   ; scblk type word - 9
        dd      b_sel   ; seblk type word - 10
        dd      b_tbt   ; tbblk type word - 11
        dd 	b_vct   ; vcblk type word - 12
        dd 	b_xnt   ; xnblk type word - 13
        dd 	b_xrt   ; xrblk type word - 14
        dd      b_bct   ; bcblk type word - 15
        dd      b_pdt   ; pdblk type word - 16
        dd      b_trt   ; trblk type word - 17
        dd      b_bft   ; bfblk type word   18
        dd      b_cct   ; ccblk type word - 19
        dd      b_cmt   ; cmblk type word - 20
        dd      b_ctt   ; ctblk type word - 21
        dd      b_dfc   ; dfblk type word - 22
        dd 	b_efc   ; efblk type word - 23
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
;   to the order of entries in the call enumeration in os.h
;   and os.inc.
;
        global  calltab
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
;       dd      enevs ;  engine words
;       dd      engts ;   not used

;
;   table of minimal variables that can be accessed from c
;   and assembly-language via macros getoff, getptr, getmin, and setmin.
;
;   there are two ways of setting this up.  if the symbol "direct" is
;   non-zero, the symbols are declared public and accessed directly.
;   if direct is zero, access is via the function minadr in inter.asm.
;
;   the macros getoff, getptr, getmin, and setmin in os.h and os.inc
;   must be adjusted when direct is changed.
;
;   note that the order of entries in this table must correspond to the
;   order of entries in the val enumeration in os.h and os.inc.
;
%if  direct
%macro  access 1
        global %1
        %endmacro
%else
%macro  access 1
        dd %1
        %endmacro

%endif
        global  valtab
valtab:
	dd	gbcnt
	dd	headv
	dd	mxlen
	dd	stage
	dd	timsx
	dd	dnamb
	dd	dnamp
	dd	state
	dd	b_efc
	dd	b_icl
	dd	b_scl
	dd	b_vct
	dd	b_xnt
	dd	b_xrt
	dd	stbas
	dd	statb
	dd	polct
;%if 	direct = 0
	dd  	typet
;%endif
	dd	lowspmin
	dd	flprt
	dd	flptr
	dd	gtcef
	dd	hshtb
	dd	pmhbs
	dd	r_fcb
	dd	c_aaa
	dd	c_yyy
	dd	g_aaa
	dd	w_yyy
	dd	s_aaa
	dd	s_yyy
	dd	r_cod
	dd	kvstn
	dd	kvdmp
	dd	kvftr
	dd	kvcom
	dd	kvpfl
	dd	cswfl
        dd  stmcs
        dd  stmct
	dd	b_rcl
	dd	end_min_data

