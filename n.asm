; Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
; 
; This file is part of Macro SPITBOL.
; 
;     Macro SPITBOL is free software: you can redistribute it and/or modify
;     it under the terms of the GNU General Public License as published by
;     the Free Software Foundation, either version 3 of the License, or
;     (at your option) any later version.
; 
;     Macro SPITBOL is distributed in the hope that it will be useful,
;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;     GNU General Public License for more details.
; 
;     You should have received a copy of the GNU General Public License
;     along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
;
; First segment in program.  Contains serial number string.
; If external functions are included, a call to the external
; function will appear in this segment as well, placed here
; by the code in load.asm.
;
        %include        "systype.nh"
	extern	reg_ra

%define KEEP
        segment	.data

        align         4
ten:	dd	10
	global	hasfpu
hasfpu:	dd	0
	global	cprtmsg
cprtmsg: db " Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer."

	segment	.text


%ifdef SKIP

;#       TAN_ arctangent of real in RA

        global  TAN_

TAN_:

        push    ecx                             ; preserve regs for C
	push	edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
        callfar f_tan                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     edx                             ; restore regs
	pop	ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [ reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret


;       CPR_ compare real in RA to 0

        global  CPR_

CPR_:
        mov     eax, dword [reg_ra+4] ; fetch msh
        cmp     eax, 0x80000000         ; test msh for -0.0
        je       cpr050            ; possibly
        or      eax, eax                ; test msh for +0.0
        jnz      cpr100            ; exit if non-zero for cc's set
cpr050: cmp     dword [reg_ra], 0     ; true zero, or denormalized number?
        jz       cpr100            ; exit if true zero
	mov	al, 1
        cmp     al, 0                   ; positive denormal, set cc
cpr100:	ret

;       OVR_ test for overflow value in RA

        global  OVR_

OVR_:

        mov     ax, word [reg_ra+6]   ; get top 2 bytes
        and     ax, 0x7ff0              ; check for infinity or nan
        add     ax, 0x10                ; set/clear overflow accordingly
	ret


;  tryfpu - perform a floating point op to trigger a trap if no floating point hardware.
	global		tryfpu
tryfpu:

	push	ebp
	fldz
	pop	ebp
	ret
; next is end of SKIP
%endif

