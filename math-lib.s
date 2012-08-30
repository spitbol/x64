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
;       cos_ cosine of real in ra
;
        global  cos_

cos_:
        push    ecx                             ; preserve regs for C
        push    edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
        callfar f_cos,8                         ; perform op
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

        global  etx_
etx_:
        push    ecx                             ; preserve regs for c
	push	edx
        push    dword [reg_ra+4]              ; ra msh
        push    dword [reg_ra]                ; ra lsh
        callfar f_etx,8                         ; perform op
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

        global  lnf_
lnf_:

        push    ecx                             ; preserve regs for C
        push    edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
        callfar f_lnf,8                         ; perform op
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

        global  sin_
sin_:

        push    ecx                             ; preserve regs for C
        push    edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
        callfar f_sin,8                         ; perform op
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

        global  sqr_
sqr_:
        push    ecx                             ; preserve regs for C
        push    edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
        callfar f_sqr,8                         ; perform op
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

        global  tan_
tan_:
        push    ecx                             ; preserve regs for C
        push    edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
        callfar f_tan,8                         ; perform op
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

        global  cpr_
cpr_:

        mov     eax, dword [reg_ra+4] ; fetch msh
        cmp     eax, 0x80000000         ; test msh for -0.0
        je      cpr050            ; possibly
        or      eax, eax                ; test msh for +0.0
        jnz     cpr100            ; exit if non-zero for cc's set
cpr050: cmp     dword [reg_ra], 0     ; true zero, or denormalized number?
        jz      cpr100            ; exit if true zero
        mov     al, 1
        cmp     al, 0                   ; positive denormal, set cc
cpr100: ret

;       ovr_ test for overflow value in ra

        global  ovr_

ovr_: 

        mov     ax, word [reg_ra+6]   ; get top 2 bytes
        and     ax, 0x7ff0              ; check for infinity or nan
        add     ax, 0x10                ; set/clear overflow accordingly
        ret
