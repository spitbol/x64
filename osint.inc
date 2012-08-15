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

;   Macros to load a compiler register into a machine register

%macro          GET_CP 1
        mov             %1, reg_cp
%endmacro

%macro          GET_IA 1
        mov             %1, reg_ia
%endmacro

%macro          GET_WA 1
        mov             %1, reg_wa
%endmacro

%macro          GET_WB 1
        mov             %1, reg_wb
%endmacro

%macro          GET_WC 1
        mov             %1, reg_wc
%endmacro

%macro          GET_XR 1
        mov             %1, reg_xr
%endmacro

%macro          GET_XL 1
        mov             %1, reg_xl
%endmacro

%macro          GET_XS 1
        mov             %1, reg_xs
%endmacro


;   Macros to store a machine register into a compiler register.

%macro          SET_CP 1
        mov             reg_cp, %2
%endmacro

%macro          SET_IA 1
        mov             reg_ia, %1
%endmacro

%macro          SET_WA 1
        mov             reg_wa, %1
%endmacro

%macro          SET_WB 1
        mov             reg_wb, %1
%endmacro

%macro          SET_WC 1
        mov             reg_wc, %1
%endmacro

%macro          SET_XR 1
        mov             reg_xr, %1
%endmacro

%macro          SET_XL 1
        mov             reg_xl, %1
%endmacro

%macro          SET_XS 1
        mov             reg_xs, %1
%endmacro


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
        mov             %1,%2
%endmacro

%macro          SETMIN 2
        mov             %1,dword [%2]
%endmacro

%macro          SETMINR 2
        mov             %1,%2
%endmacro

%ifnmacro	access
%macro          access 1
        extern             %1
%endmacro
%endif

%macro          access2 1
%ifndef globals
        extern            %1
%endif
%endmacro

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
        struct   vords
%endif
%ifnmacro access
	dave shields
%endif
	segment	.text

        access  GBCNT
        access  HEADV
        access  MXLEN
        access  STAGE
        access  TIMSX
        access  DNAMB
        access  DNAMP
        access  STATE
        access  B_EFC
        access  B_ICL
        access  B_SCL
        access  B_VCT
        access  B_XNT
        access  B_XRT
        access  STBAS
        access  STATB
        access  POLCT
        access  TYPET
        access  DFFNC
        access  LOWSPMIN
        access  FLPRT
        access  FLPTR
        access  GTCEF
        access  HSHTB
        access  PMHBS
        access  R_FCB
        access  C_AAA
        access  C_YYY
        access  G_AAA
        access  W_YYY
        access  S_AAA
        access  S_YYY
        access  R_COD
        access  KVSTN
        access  KVDMP
        access  KVFTR
        access  KVCOM
        access  KVPFL
        access  CSWFL
        access  STMCS
        access  STMCT
        access2 TICBLK
        access2 TSCBLK
        access2 ID1
        access2 ID2BLK
        access2 INPBUF
        access2 TTYBUF
        access  B_RCL

%if direct == 0
        ends    vords
%endif
