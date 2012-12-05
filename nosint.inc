;   File:  osint.inc            Version:  01.00
;   -------------------------------------------
;
;   This header file defines the interface between the Macro SPITBOL compiler
;   and any assembly-language OSINT modules.
;   Communication between the two is handled via a set of global variables
;   defined as externals below.

;  Copyright 1991 Robert Goldberg and Catspaw, Inc.

;   Set up externals for all the compiler's registers.

	segment		.data
%ifndef globals
	extern		reg_cp,dword
	extern		reg_wa,dword
	extern		reg_wb,dword
	extern		reg_wc,dword
	extern		reg_xr,dword
	extern		reg_xl,dword
	extern		reg_xs,dword
	extern		reg_ia,dword
%endif

;;   Macros to load a compiler register into a machine register
;
        %macro          GET_CP 1
        mov             %1, dword [_cp]
        %endmacro

        %macro          GET_IA 1
        mov             %1, dword [_ia]
        %endmacro

        %macro          GET_WA 1
        mov             %1, dword [_wa]
        %endmacro

        %macro          GET_WB 1
        mov             %1, dword [_wb]
        %endmacro

        %macro          GET_WC 1
        mov             %1, dword [_wc]
        %endmacro

        %macro          GET_XR 1
        mov             %1, dword [_xr]
        %endmacro

        %macro          GET_XL 1
        mov             %1, dword [_xl]
        %endmacro

        %macro          GET_XS 1
        mov             %1, dword [_xs]
        %endmacro


;   Macros to store a machine register into a compiler register.

        %macro          SET_CP 1
        mov             dword [reg_cp], %1
        %endmacro

        %macro          SET_IA 1
        mov             dword [reg_ia], %1
        %endmacro

        %macro          SET_WA 1
        mov             dword [reg_wa], %1
        %endmacro

        %macro          SET_WB 1
        mov             dword [reg_wb], %1
        %endmacro

        %macro          vSET_WC 1
        mov             dword [reg_wc], %1
        %endmacro

        %macro          SET_XR 1
        mov             dword [reg_xr], %1
        %endmacro

        %macro          SET_XL 1
        mov             dword [reg_xl], %1
        %endmacro

        %macro          SET_XS 1
        mov             dword [reg_xs], %1
        %endmacro


;   Return values to take exit N from interface

%define EXIT_1  1
%define EXIT_2  2
%define EXIT_3  3
%define EXIT_4  4
%define EXIT_5  5
%define EXIT_6  6
%define EXIT_7  7
%define EXIT_8  8
%define EXIT_9  9
;
;;    Return value to do a normal return from interface.
;
%define NORMAL_RETURN          (-1)

;        segment	.text
;
;;       Function and macro to call into MINIMAL code.
;;       The argument is an ordinal number defined below.
;.ifndef globals
;	extern		minimal,near
;.endif
;        %macro          MINIMAL callno
;        push            offset \callno
;	callc		minimal,4
;        %endmacro
;
;;   Ordinals for MINIMAL calls from assembly language.
;;
;;   The order of entries here must correspond to the order of
;;   calltab entries in the INTER assembly language module.
;;
%define RELAJ     0
%define RELCR     1
%define RELOC     2
%define ALLOC     3
%define ALOCS     4
%define ALOST     5
%define BLKLN     6
%define INSTA     7
%define RSTRT     8
%define START     9
%define FILNM     10
%define DTYPE     11
%define ENEVS     12
%define ENGTS     13
;
;;       Function and macro to get/set value from/to MINIMAL dataspace.
;;       The argument is an ordinal number defined below.
;;       The macro GETOFF returns the address of the value.
;.if direct                                  ; [[
;        %macro          GETOFF reg,valno
;        lea             \reg,\valno
;        %endmacro
;
;        %macro          GETMIN reg,valno
;        mov             \reg,\valno
;        %endmacro
;
;        %macro          SETMIN valno,value
;        mov             \valno,dword ptr \value
;        %endmacro
;
;        %macro          SETMINR valno,value
;        mov             \valno,\value
;        %endmacro
;
;
;        segment		.data
;.else                                       ; ][
;.ifndef globals
;	extern		minoff,near
;.endif
;        %macro          GETOFF reg,valno
;.ifnc \reg,eax
;	push		eax
;.endif
;        push            offset \valno
;	callc		minoff,4
;.ifnc \reg,eax
;        mov             \reg,eax
;	pop		eax
;.endif
;        %endmacro
;
;        %macro          GETMIN reg,valno
;.ifnc \reg,eax
;	push		eax
;.endif
;        push            offset \valno
;	callc		minoff,4
;        mov             \reg,[eax]
;.ifnc \reg,eax
;	pop		eax
;.endif
;        %endmacro
;
;        %macro          SETMIN valno,value
;.ifc \value,eax
;	push		eax
;.endif
;        push            offset \valno
;	callc		minoff,4
;.ifc \value,eax
;	pop		[eax]
;.else
;        mov             [eax],\value
;.endif
;        %endmacro
;
;
;;   Ordinals for transferring MINIMAL values to/from assembly language.
;;
;;   The order of entries here must correspond to the order of
;;   valtab entries in the INTER assembly language module.
;;
;;   The structure vords and the access macro is merely a device to
;;   produce an enumeration similar to an enum structure to C.
;;
;        struc   vords
;.endif                                      ; ]]
;
        extern GBCNT
        extern HEADV
        extern MXLEN
        extern STAGE
        extern TIMSX
        extern DNAMB
        extern DNAMP
        extern STATE
        extern B_EFC
        extern B_ICL
        extern B_SCL
        extern B_VCT
        extern B_XNT
        extern B_XRT
        extern STBAS
        extern STATB
        extern POLCT
        extern TYPET
        extern DFFNC
        extern LOWSPMIN
        extern FLPRT
        extern FLPTR
        extern GTCEF
        extern HSHTB
        extern PMHBS
        extern R_FCB
        extern C_AAA
        extern C_YYY
        extern G_AAA
        extern W_YYY
        extern S_AAA
        extern S_YYY
        extern R_COD
        extern KVSTN
        extern KVDMP
        extern KVFTR
        extern KVCOM
        extern KVPFL
        extern CSWFL
        extern STMCS
        extern STMCT
        extern TICBLK
        extern TSCBLK
        extern ID1
        extern ID2BLK
        extern INPBUF
        extern TTYBUF
;;ifdef REAL_ARITH
;        access B_RCL
;;endif
;
;.if direct
;        DSegEnd_
;.else
;        ends    vords
;.endif
;
