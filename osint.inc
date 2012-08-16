;   File:  osint.inc            Version:  01.00
;   -------------------------------------------
;
;   This header file defines the interface between the Macro SPITBOL compiler
;   and any assembly-language OSINT modules.
;   Communication between the two is handled via a set of global variables
;   defined as externals below.

;  Copyright 1991 Robert Goldberg and Catspaw, Inc.
;  Copyright 2012 David Shields

;   Set up externals for all the compiler's registers.

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


;   Return values to take exit N from interface

EXIT_1 equ      0
EXIT_2 equ      4
EXIT_3 equ      8
EXIT_4 equ      12
EXIT_5 equ      16
EXIT_6 equ      20
EXIT_7 equ      24
EXIT_8 equ      28
EXIT_9 equ      32

;    Return value to do a normal return from interface.

NORMAL_RETURN  equ      -1

	segment	.text

;       Function and macro to call into MINIMAL code.
;       The argument is an ordinal number defined below.
%ifndef globals
	extern		minimal
%endif
%macro          MINIMAL 1
        push            %1
	callc		minimal,4
%endmacro

;   Ordinals for MINIMAL calls from assembly language.
;
;   The order of entries here must correspond to the order of
;   calltab entries in the INTER assembly language module.
;
RELAJ  equ      0
RELCR  equ      1
RELOC  equ      2
ALLOC  equ      3
ALOCS  equ      4
ALOST  equ      5
BLKLN  equ      6
INSTA  equ      7
RSTRT  equ      8
START  equ      9
FILNM  equ      10
DTYPE  equ      11
ENEVS  equ      12
ENGTS  equ      13

;       Function and macro to get/set value from/to MINIMAL dataspace.
;       The argument is an ordinal number defined below.
;       The macro GETOFF returns the address of the value.
%if direct                                  ; [[
%macro          GETOFF 2
        lea             %1,%2
%endmacro

%macro          GETMIN 2
        mov             %1,dword [%2]
%endmacro

%macro          SETMIN 2
        mov             %1,dword [%2]
%endmacro

%macro          SETMINR 2
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
%macro          GETOFF 2
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

%macro          GETMIN 2
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

%macro          SETMIN 2
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

;   Ordinals for transferring MINIMAL values to/from assembly language.
;
;   The order of entries here must correspond to the order of
;   valtab entries in the INTER assembly language module.
;
;   The structure vords and the access macro is merely a device to
;   produce an enumeration similar to an enum structure to C.
;
;;        struct   vords
%endif
	segment	.text
%ifndef globals
        extern  GBCNT
        extern  HEADV
        extern  MXLEN
        extern  STAGE
        extern  TIMSX
        extern  DNAMB
        extern  DNAMP
        extern  STATE
        extern  B_EFC
        extern  B_ICL
        extern  B_SCL
        extern  B_VCT
        extern  B_XNT
        extern  B_XRT
        extern  STBAS
        extern  STATB
        extern  POLCT
        extern  TYPET
        extern  DFFNC
        extern  LOWSPMIN
        extern  FLPRT
        extern  FLPTR
        extern  GTCEF
        extern  HSHTB
        extern  PMHBS
        extern  R_FCB
        extern  C_AAA
        extern  C_YYY
        extern  G_AAA
        extern  W_YYY
        extern  S_AAA
        extern  S_YYY
        extern  R_COD
        extern  KVSTN
        extern  KVDMP
        extern  KVFTR
        extern  KVCOM
        extern  KVPFL
        extern  CSWFL
        extern  STMCS
        extern  STMCT
        extern  TICBLK
        extern  TSCBLK
        extern  ID1
        extern  ID2BLK
        extern  INPBUF
        extern  TTYBUF
        extern  B_RCL
%endif
%if direct == 0
        ends    vords
%endif
