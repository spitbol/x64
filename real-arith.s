;        .title          "spitbol assembly-language mathematical function support"
; copyright 1987-2012 robert b. k. dewar and mark emmer.
; 
; this file is part of macro spitbol.
; 
;     macro spitbol is free software: you can redistribute it and/or modify
;     it under the terms of the gnu general public license as published by
;     the free software foundation, either version 3 of the license, or
;     (at your option) any later version.
; 
;     macro spitbol is distributed in the hope that it will be useful,
;     but without any warranty; without even the implied warranty of
;     merchantability or fitness for a particular purpose.  see the
;     gnu general public license for more details.
; 
;     you should have received a copy of the gnu general public license
;     along with macro spitbol.  if not, see <http://www.gnu.org/licenses/>.

%define globals 1

        %include        "mintype.h"
        %include        "os.inc"

	segment		.data

        align 4

        extern  reg_cp
        extern  reg_ia
        extern  reg_pc
        extern  reg_pp
        extern  reg_ra
        extern  reg_xl
        extern  reg_xr
        extern  reg_xs
        extern  reg_wa
        extern  reg_wb
        extern  reg_wc
;
;  constants
;
ten:    dd      10              ; constant 10
inf:    dd      0       
        dd      0x7ff00000      ; double precision infinity

	segment		.text
;
;-----------
;
;       rmi_ - remainder of ia (edx) divided by long in eax
;
	global	rmi_
rmi_:
             or      eax,eax         ; test for 0
        jz      setovr    ; jump if 0 divisor
        push    ebp             ; preserve cp
        xchg    ebp,eax         ; divisor to ebp
        xchg    eax,edx         ; dividend in eax
        cdq                     ; extend dividend
        idiv    ebp             ; perform division. eax=quotient, edx=remainder
        pop     ebp             ; restore cp
        xor     eax,eax         ; clear overflow indicator
        ret                     ; return remainder in edx (ia)
setovr: mov     al,0x80         ; set overflow indicator
        dec     al
        ret



;----------
;
;    calls to c
;
;       the calling convention of the various compilers:
;
;       integer results returned in eax.
;       float results returned in st0 for intel.
;       see conditional switches fretst0 and
;       freteax in mintype.h for each compiler.
;
;       c function preserves ebp, ebx, esi, edi.
;


;----------
;
;       rti_ - convert real in ra to integer in ia
;               returns c=0 if fit ok, c=1 if too large to convert
;
	global	rti_
rti_:

; 41e00000 00000000 = 2147483648.0
; 41e00000 00200000 = 2147483649.0
        mov     eax, dword [reg_ra+4]   ; ra msh
        btr     eax,31          ; take absolute value, sign bit to carry flag
        jc      rti_2     ; jump if negative real
        cmp     eax,0x41e00000  ; test against 2147483648
        jae     rti_1     ; jump if >= +2147483648
rti_3:  push    ecx             ; protect against c routine usage.
        push    eax             ; push ra msh
        push    dword [reg_ra]; push ra lsh
        callfar f_2_i,8         ; float to integer
        xchg    eax,edx         ; return integer in edx (ia)
        pop     ecx             ; restore ecx
        clc
        ret

; here to test negative number, made positive by the btr instruction
rti_2:  cmp     eax,0x41e00000          ; test against 2147483649
        jb      rti_0             ; definately smaller
        ja      rti_1             ; definately larger
        cmp     dword [reg_ra+2], 0x0020
        jae     rti_1
rti_0:  btc     eax,31                  ; make negative again
        jmp     rti_3
rti_1:  stc                             ; return c=1 for too large to convert
        ret

;
;----------
;
;       itr_ - convert integer in ia to real in ra
;
	global	itr_
itr_:

        push    ecx             ; preserve
        push    edx             ; push ia
        callfar i_2_f,4         ; integer to float
%if fretst0
        fstp    dword [reg_ra]
        pop     ecx             ; restore ecx
        fwait
%endif
%if freteax
        mov     dword [reg_ra],eax    ; return result in ra

        mov     dword [reg_ra+4],edx
        pop     ecx             ; restore ecx
%endif
        ret

;
;----------
;
;       ldr_ - load real pointed to by eax to ra
;
	global	ldr_
ldr_:
        push    dword [eax]                 ; lsh
        pop     dword [reg_ra]
        mov     eax,dword [eax+4]                     ; msh
        mov     dword [reg_ra+4], eax
        ret

;
;----------
;
;       str_ - store ra in real pointed to by eax
;
	global	str_
str_:

        push    dword [reg_ra]                ; lsh
        pop     dword [eax]
        push    dword [reg_ra+4]              ; msh
        pop     dword [eax+4]
        ret

;
;----------
;
;       adr_ - add real at [eax] to ra
;
	global	adr_
adr_:

        push    ecx                             ; preserve regs for c
	push	edx
        push    dword [reg_ra+4]              ; ra msh
        push    dword [reg_ra]                ; ra lsh
        push    dword [eax+4]               ; arg msh
        push    dword [eax]                 ; arg lsh
        callfar f_add,16                        ; perform op
%if fretst0
        fstp    dword [reg_ra]
        pop     edx                             ; restore regs
        pop     ecx
        fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
        pop     ecx
%endif
        ret

;
;----------
;
;       sbr_ - subtract real at [eax] from ra
;
        global  sbr_
sbr_:

        push    ecx                             ; preserve regs for C
        push    edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
        push    dword [eax+4]               ; arg msh
        push    dword [eax]                 ; arg lsh
        callfar f_sub,16                        ; perform op
%if fretst0
        fstp    dword [reg_ra]
        pop     edx                             ; restore regs
        pop     ecx
        fwait
%endif
%if freteax
        mov     dword [reg_ra+4, edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
        pop     ecx
%endif
        ret

;
;----------
;
;       mlr_ - multiply real in ra by real at [eax]
;
        global  mlr_
mlr_:

        push    ecx                             ; preserve regs for C
        push    edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
        push    dword [eax+4]               ; arg msh
        push    dword [eax]                 ; arg lsh
        callfar f_mul,16                        ; perform op
%if fretst0
        fstp    dword [reg_ra]
        pop     edx                             ; restore regs
        pop     ecx
        fwait
%endif
%if freteax
        mov     dword [reg_ra+4,] edx         ; result msh
        mov     dword [reg_ra,] eax           ; result lsh
        pop     edx                             ; restore regs
        pop     ecx
%endif
        ret

;
;----------
;
;       dvr_ - divide real in ra by real at [eax]
;
        global  dvr_

dvr_:

        push    ecx                             ; preserve regs for C
        push    edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
        push    dword [eax+4]               ; arg msh
        push    dword [eax]                 ; arg lsh
        callfar f_div,16                        ; perform op
%if fretst0
        fstp    dword [reg_ra]
        pop     edx                             ; restore regs
        pop     ecx
        fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
        pop     ecx
%endif
        ret

;
;----------
;
;       ngr_ - negate real in ra
;
        global  ngr_
ngr_:
	cmp	dword [reg_ra], 0
	jne	ngr_1
	cmp	dword [reg_ra+4], 0
        je      ngr_2                     ; if zero, leave alone
ngr_1:  xor     byte [reg_ra+7], 0x80         ; complement mantissa sign
ngr_2:  ret

;
;----------
;
;       atn_ arctangent of real in ra
;
        global  atn_

atn_:

        push    ecx                             ; preserve regs for C
        push    edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
	extern	f_atn
        callfar f_atn,8                         ; perform op
%if fretst0
        fstp    dword [reg_ra]
        pop     edx                             ; restore regs
        pop     ecx
        fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
        pop     ecx
%endif
        ret

;
;----------
;
;       chp_ chop fractional part of real in ra
;
        global  chp_

chp_:

        push    ecx                             ; preserve regs for C
        push    edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
        callfar f_chp,8                         ; perform op
%if fretst0
        fstp    dword [reg_ra]
        pop     edx                             ; restore regs
        pop     ecx
        fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
        pop     ecx
%endif
        ret
;
;----------
;
;  tryfpu - perform a floating point op to trigger a trap if no floating point hardware.
;
        global  tryfpu
tryfpu:
        push    ebp
        fldz
        pop     ebp
        ret
