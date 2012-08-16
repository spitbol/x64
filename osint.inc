;   file:  osint.inc            version:  01.00
;   -------------------------------------------
;
;   this header file defines the interface between the macro spitbol compiler
;   and any assembly-language osint modules.
;   communication between the two is handled via a set of global variables
;   defined as externals below.

;  copyright 1991 robert goldberg and catspaw, inc.
;  copyright 2012 david shields

;   set up externals for all the compiler's registers.

	segment	.data
%ifndef globals
	extern		reg_cp
	extern		reg_wa
	extern		reg_wb
	extern		reg_wc
	extern		reg_xr
	extern		reg_xl
	extern		reg_xs
	extern		reg_ia
%endif


;   return values to take exit n from interface

exit_1 equ      0
exit_2 equ      4
exit_3 equ      8
exit_4 equ      12
exit_5 equ      16
exit_6 equ      20
exit_7 equ      24
exit_8 equ      28
exit_9 equ      32

;    return value to do a normal return from interface.

normal_return  equ      -1

	segment	.text

;       function and macro to call into minimal code.
;       the argument is an ordinal number defined below.
%ifndef globals
	extern		minimal
%endif
%macro          minimal 1
        push            %1
	callc		minimal,4
%endmacro

;   ordinals for minimal calls from assembly language.
;
;   the order of entries here must correspond to the order of
;   calltab entries in the inter assembly language module.
;
relaj  equ      0
relcr  equ      1
reloc  equ      2
alloc  equ      3
alocs  equ      4
alost  equ      5
blkln  equ      6
insta  equ      7
rstrt  equ      8
start  equ      9
filnm  equ      10
dtype  equ      11
enevs  equ      12
engts  equ      13

;       function and macro to get/set value from/to minimal dataspace.
;       the argument is an ordinal number defined below.
;       the macro getoff returns the address of the value.
%if direct                                  ; [[
%macro          getoff 2
        lea             %1,%2
%endmacro

%macro          getmin 2
        mov             %1,dword [%2]
%endmacro

%macro          setmin 2
        mov             %1,dword [%2]
%endmacro

%macro          setminr 2
        mov             %1,%2
%endmacro

;;%ifnmacro	access
;;%macro          access 1
;;        extern             %1
;;%endmacro
;;%endif
;;
;;%macro          access2 1
;;%ifndef globals
;;        extern            %1
;;%endif
;;%endmacro

	segment	.data
%else                                       ; ][
%ifndef globals
	extern		minoff
%endif
%macro          getoff 2
%ifnidn %1,eax
	push		eax
%endif
        push            %2
	callc		minoff,4
%ifnidn %1,eax
        mov             %1,eax
	pop		eax
%endif
%endmacro

%macro          getmin 2
%ifnidn %1,eax
	push		eax
%endif
        push            %2
	callc		minoff,4
        mov             %1,[eax]
%ifnidn %1,eax
	pop		eax
%endif
%endmacro

%macro          setmin 2
%ifidn %2,eax
	push		eax
%endif
        push            %1
	callc		minoff,4
%ifidn %2,eax
	pop		[eax]
%else
        mov             [eax],%2
%endif
%endmacro

%ifnmacro	access
%macro          access 1
	extern	%1
%endmacro
%endif

%ifnmacro	access2
%macro          access2 1
	extern %1
%endmacro
%endif

;   ordinals for transferring minimal values to/from assembly language.
;
;   the order of entries here must correspond to the order of
;   valtab entries in the inter assembly language module.
;
;   the structure vords and the access macro is merely a device to
;   produce an enumeration similar to an enum structure to c.
;
;;        struct   vords
%endif
	segment	.text
%ifndef globals
        extern  gbcnt
        extern  headv
        extern  mxlen
        extern  stage
        extern  timsx
        extern  dnamb
        extern  dnamp
        extern  state
        extern  b_efc
        extern  b_icl
        extern  b_scl
        extern  b_vct
        extern  b_xnt
        extern  b_xrt
        extern  stbas
        extern  statb
        extern  polct
        extern  typet
        extern  dffnc
        extern  lowspmin
        extern  flprt
        extern  flptr
        extern  gtcef
        extern  hshtb
        extern  pmhbs
        extern  r_fcb
        extern  c_aaa
        extern  c_yyy
        extern  g_aaa
        extern  w_yyy
        extern  s_aaa
        extern  s_yyy
        extern  r_cod
        extern  kvstn
        extern  kvdmp
        extern  kvftr
        extern  kvcom
        extern  kvpfl
        extern  cswfl
        extern  stmcs
        extern  stmct
        extern  ticblk
        extern  tscblk
        extern  id1
        extern  id2blk
        extern  inpbuf
        extern  ttybuf
        extern  b_rcl
%endif
%if direct == 0
        ends    vords
%endif
