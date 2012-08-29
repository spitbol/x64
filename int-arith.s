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
        global  inf
inf:    dd      0       
        dd      0x7ff00000      ; double precision infinity

	segment		.text
;
;-----------
;
;       cvd_ - convert by division
;
;       input   ia (edx) = number <=0 to convert
;       output  ia / 10
;               wa (ecx) = remainder + '0'
;
	global	cvd_
cvd_:
        xchg    eax,edx         ; ia to eax
        cdq                     ; sign extend
        idiv    dword [ten]   ; divide by 10. edx = remainder (negative)
        neg     edx             ; make remainder positive
        add     dl,0x30         ; convert remainder to ascii ('0')
        mov     ecx,edx         ; return remainder in WA
        xchg    edx,eax         ; return quotient in IA
        ret

;
;-----------
;
;       dvi_ - divide ia (edx) by long in eax
;
	global	dvi_
dvi_:

        or      eax,eax         ; test for 0
        jz      setovr    	; jump if 0 divisor
        push    ebp             ; preserve cp
        xchg    ebp,eax         ; divisor to ebp
        xchg    eax,edx         ; dividend in eax
        cdq                     ; extend dividend
        idiv    ebp             ; perform division. eax=quotient, edx=remainder
        xchg    edx,eax         ; place quotient in edx (ia)
        pop     ebp             ; restore cp
        xor     eax,eax         ; clear overflow indicator
        ret


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



