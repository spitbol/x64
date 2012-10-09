;   File:  osint.inc            Version:  01.00
;   -------------------------------------------
;
;   This header file defines the interface between the Macro SPITBOL compiler
;   and any assembly-language OSINT modules.
;   Communication between the two is handled via a set of global variables
;   defined as externals below.

;  Copyright 1991 Robert Goldberg and Catspaw, Inc.

;   Set up externals for all the compiler's registers.

        DSeg_
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
        DSegEnd_

;   Macros to load a compiler register into a machine register
	%macro		atline 1
	mov	dword [nlines],%1
	call	atlin
	%endmacro

        %macro          GET_CP 1
        mov             %1, dword [reg_cp]
        %endmacro

        %macro          GET_IA 1
        mov             %1, dword [reg_ia]
        %endmacro

        %macro          GET_WA 1
        mov             %1, dword [reg_wa]
        %endmacro

        %macro          GET_WB 1
        mov             %1, dword [reg_wb]
        %endmacro

        %macro          GET_WC 1
        mov             %1, dword [reg_wc]
        %endmacro

        %macro          GET_XR 1
        mov             %1, dword [reg_xr]
        %endmacro

        %macro          GET_XL 1
        mov             %1, dword [reg_xl]
        %endmacro

        %macro          GET_XS 1
        mov             %1, dword [reg_xs]
        %endmacro


;   Macros to store a machine register into a compiler register.

        %macro          SET_CP  1
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

%define	EXIT_1         0
%define	EXIT_2         4
%define	EXIT_3         8
%define	EXIT_4         12
%define	EXIT_5         16
%define	EXIT_6         20
%define	EXIT_7         24
%define	EXIT_8         28
%define	EXIT_9         32
;    Return value to do a normal return from interface.

%define NORMAL_RETURN   -1

        CSeg_

;       Function and macro to call into MINIMAL code.
;       The argument is an ordinal number defined below.
;%ifndef globals
;	extern		minimal
;%endif
        %macro          MINIMAL 1
        push            %1
	callc		minimal,4
        %endmacro

;   Ordinals for MINIMAL calls from assembly language.
;
;   The order of entries here must correspond to the order of
;   calltab entries in the INTER assembly language module.
;
%define  RELAJ          0
%define  RELCR          1
%define  RELOC          2
%define  ALLOC          3
%define  ALOCS          4
%define  ALOST          5
%define  BLKLN          6
%define  INSTA          7
%define  RSTRT          8
%define  START          9
%define  FILNM          10
%define  DTYPE          11
%define  ENEVS          12
%define  ENGTS          13

;       Function and macro to get/set value from/to MINIMAL dataspace.
;       The argument is an ordinal number defined below.
;       The macro GETOFF returns the address of the value.
%if direct                                  ; [[
        %macro          GETOFF 2
	lea		%1,[%2]
        %endmacro

        %macro          GETMIN 2
        mov             %1,%2
        %endmacro

        %macro          SETMIN 2
	mov		dword [%1],%2
        %endmacro

        %macro          SETMINR 2
	mov		dword [%1],%2
        %endmacro

        %macro          access 1
        ext             %1,dword
        %endmacro

        %macro          access2 1
%ifndef globals
        ext            %1,dword
%endif
        %endmacro

        DSeg_
%else                                       ; ][
%ifndef globals
	ext		minoff,near
%endif
        %macro          GETOFF 2
%ifidn %1,eax
%else
	push	dave
	push		eax
%endif
        push            %2
	callc		minoff,4
%ifidn %1,eax
%else
        mov             %1,eax
	pop		eax
%endif
        %endmacro

        %macro          GETMIN 2
%ifidn	%1,eax
%else
	push		eax
%endif
        push            %2
	callc		minoff,4
        mov             %1,dword [eax]
%ifidn %1,eax
%else
	pop		eax
%endif
        %endmacro

        %macro          SETMIN 2
%ifidn %1,eax
	push		eax
%endif
        push            offset %1
	callc		minoff,4
%ifidn %2,eax
	pop		dword [eax]
%else
        mov             dword [eax],%2
%endif
        %endmacro

        %macro          access 1
%1:  db              0
        %endmacro

        %macro          access2 1
%1:  db              0
        %endmacro

;   Ordinals for transferring MINIMAL values to/from assembly language.
;
;   The order of entries here must correspond to the order of
;   valtab entries in the INTER assembly language module.
;
;   The structure vords and the access macro is merely a device to
;   produce an enumeration similar to an enum structure to C.
;
;        struc   vords
%endif                                      ; ]]

;        %define   GBCNT 1
;        %define   HEADV 2
;        %define   MXLEN 3
;        %define   STAGE 4
;        %define   TIMSX 5
;        %define   DNAMB 6
;        %define   DNAMP 7
;        %define   STATE 8
;        %define   B_EFC 9
;        %define   B_ICL 10
;        %define   B_SCL 11
;        %define   B_VCT 12
;        %define   B_XNT 13
;        %define   B_XRT 14
;        %define   STBAS 15
;        %define   STATB 16
;        %define   POLCT 17
;        %define   TYPET 18
;        %define   DFFNC 19
;        %define   LOWSPMIN 20
;        %define   FLPRT 21
;        %define   FLPTR 22
;        %define   GTCEF 23
;        %define   HSHTB 24
;        %define   PMHBS 25
;        %define   R_FCB 26
;        %define   C_AAA 27
;        %define   C_YYY 28
;        %define   G_AAA 29
;        %define   W_YYY 30
;        %define   S_AAA 31
;        %define   S_YYY 32
;        %define   R_COD 33
;        %define   KVSTN 34
;        %define   KVDMP 35
;        %define   KVFTR 36
;        %define   KVCOM 37
;        %define   KVPFL 38
;        %define   CSWFL 39
;        %define   STMCS 40
;        %define   STMCT 41
;        %define   TICBLK   42
;        %define   TSCBLK   43
;        %define   ID1   44
;        %define   ID2BLK   45
;        %define   INPBUF   46
;        %define   TTYBUF   47
;        %define   B_RCL   48
;
%if direct
        DSegEnd_
%else
;        ends    vords
%endif

        CSegEnd_
