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
.ifndef globals
	ext		reg_cp,dword
	ext		reg_wa,dword
	ext		reg_wb,dword
	ext		reg_wc,dword
	ext		reg_xr,dword
	ext		reg_xl,dword
	ext		reg_xs,dword
	ext		reg_ia,dword
.endif
        DSegEnd_

;   Macros to load a compiler register into a machine register

        %macro          GET_CP reg
        mov             \reg, reg_cp
        %endmarco

        %macro          GET_IA reg
        mov             \reg, reg_ia
        %endmarco

        %macro          GET_WA reg
        mov             \reg, reg_wa
        %endmarco

        %macro          GET_WB reg
        mov             \reg, reg_wb
        %endmarco

        %macro          GET_WC reg
        mov             \reg, reg_wc
        %endmarco

        %macro          GET_XR reg
        mov             \reg, reg_xr
        %endmarco

        %macro          GET_XL reg
        mov             \reg, reg_xl
        %endmarco

        %macro          GET_XS reg
        mov             \reg, reg_xs
        %endmarco


;   Macros to store a machine register into a compiler register.

        %macro          SET_CP val
        mov             reg_cp, \val
        %endmarco

        %macro          SET_IA val
        mov             reg_ia, \val
        %endmarco

        %macro          SET_WA val
        mov             reg_wa, \val
        %endmarco

        %macro          SET_WB val
        mov             reg_wb, \val
        %endmarco

        %macro          vSET_WC val
        mov             reg_wc, \val
        %endmarco

        %macro          SET_XR val
        mov             reg_xr, \val
        %endmarco

        %macro          SET_XL val
        mov             reg_xl, \val
        %endmarco

        %macro          SET_XS val
        mov             reg_xs, \val
        %endmarco


;   Return values to take exit N from interface

EXIT_1  =       0
EXIT_2  =       4
EXIT_3  =       8
EXIT_4  =       12
EXIT_5  =       16
EXIT_6  =       20
EXIT_7  =       24
EXIT_8  =       28
EXIT_9  =       32

;    Return value to do a normal return from interface.

NORMAL_RETURN   =       -1

        CSeg_

;       Function and macro to call into MINIMAL code.
;       The argument is an ordinal number defined below.
.ifndef globals
	ext		minimal,near
.endif
        %macro          MINIMAL callno
        push            offset \callno
	callc		minimal,4
        %endmarco

;   Ordinals for MINIMAL calls from assembly language.
;
;   The order of entries here must correspond to the order of
;   calltab entries in the INTER assembly language module.
;
RELAJ   =       0
RELCR   =       1
RELOC   =       2
ALLOC   =       3
ALOCS   =       4
ALOST   =       5
BLKLN   =       6
INSTA   =       7
RSTRT   =       8
START   =       9
FILNM   =       10
DTYPE   =       11
ENEVS   =       12
ENGTS   =       13

;       Function and macro to get/set value from/to MINIMAL dataspace.
;       The argument is an ordinal number defined below.
;       The macro GETOFF returns the address of the value.
.if direct                                  ; [[
        %macro          GETOFF reg,valno
.ifne underscore
        lea             \reg,_\valno
.else
        lea             \reg,\valno
.endif
        %endmarco

        %macro          GETMIN reg,valno
.ifne underscore
        mov             \reg,_\valno
.else
        mov             \reg,\valno
.endif
        %endmarco

        %macro          SETMIN valno,value
.ifne underscore
        mov             _\valno,dword ptr \value
.else
        mov             \valno,dword ptr \value
.endif
        %endmarco

        %macro          SETMINR valno,value
.ifne underscore
        mov             _\valno,\value
.else
        mov             \valno,\value
.endif
        %endmarco

        %macro          access name
        ext             \name,dword
        %endmarco

        %macro          access2 name
.ifndef globals
        ext            \name,dword
.endif
        %endmarco

        DSeg_
.else                                       ; ][
.ifndef globals
	ext		minoff,near
.endif
        %macro          GETOFF reg,valno
.ifnc \reg,eax
	push		eax
.endif
        push            offset \valno
	callc		minoff,4
.ifnc \reg,eax
        mov             \reg,eax
	pop		eax
.endif
        %endmarco

        %macro          GETMIN reg,valno
.ifnc \reg,eax
	push		eax
.endif
        push            offset \valno
	callc		minoff,4
        mov             \reg,[eax]
.ifnc \reg,eax
	pop		eax
.endif
        %endmarco

        %macro          SETMIN valno,value
.ifc \value,eax
	push		eax
.endif
        push            offset \valno
	callc		minoff,4
.ifc \value,eax
	pop		[eax]
.else
        mov             [eax],\value
.endif
        %endmarco

        %macro          access name
\name:  .byte           0
        %endmarco

        %macro          access2 name
\name:  .byte           0
        %endmarco

;   Ordinals for transferring MINIMAL values to/from assembly language.
;
;   The order of entries here must correspond to the order of
;   valtab entries in the INTER assembly language module.
;
;   The structure vords and the access macro is merely a device to
;   produce an enumeration similar to an enum structure to C.
;
        struc   vords
.endif                                      ; ]]

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

.if direct
        DSegEnd_
.else
        ends    vords
.endif

        CSegEnd_
