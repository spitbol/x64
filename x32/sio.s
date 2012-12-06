; copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
; copyright 2012 David Shields
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

;       this file contains the assembly language routines that interface
;       the macro spitbol compiler written in 80386 assembly language to its
;       operating system interface functions written in c.
;

;%include 	"systype.nh"
	extern	_rc_
	extern	reg_xl
	extern	reg_xr
	extern	reg_xs
	extern	reg_wa
	extern	reg_wb
	extern	reg_wc
	extern	reg_cp


; define interface macro for calling procedures written in c from
; within the minimal code.

;       this file contains the assembly language routines that interface
;       the macro spitbol compiler written in 80386 assembly language to its
;       operating system interface functions written in c.
;

;       interface routines
;
;       each interface routine takes the following form:
;
;               sysxx   call    ccaller         ; call common interface
;                                               ;   last procedure exit
;
;
;       important:  one interface routine, sysfc, is passed arguments on
;       the stack.  these items are removed from the stack before calling
;       ccaller, as they are not needed by this implementation.
;
;
; define interface macro for calling procedures written in c from
; within the minimal code.


	%macro	mtoc	1
	extern	%1
	; save minimal registers to make their values available to called procedure
	mov     dword [reg_wa],ecx     
        mov     dword [reg_wb],ebx
        mov     dword [reg_wc],edx	; (also reg_ia)
        mov     dword [reg_xr],edi
        mov     dword [reg_xl],esi
        mov     dword [reg_cp],ebp	; Needed in image saved by sysxi
        call    %1			; call c interface function
	mov	eax,dword [_rc_]	; save return code from procedure
;       restore minimal registers since called procedure may have changed them
        mov     ecx, dword [reg_wa]	; restore registers
        mov     ebx, dword [reg_wb]
        mov     edx, dword [reg_wc]	; (also reg_ia)
        mov     edi, dword [reg_xr]
        mov     esi, dword [reg_xl]
        mov     ebp, dword [reg_cp]
;	restore direction flag in (the unlikeley) case callee changed it
        cld
;	note that the called procedure has set return exi action in eax
	ret
	%endmacro

	global	SYSAX
SYSAX:
	mtoc	zysax

	global	SYSBS
SYSBS:
	mtoc	zysbs

	global	SYSBX
SYSBX:
	mtoc	zysbx

;	global	yscr
;syscr:
;	mtoc	zyscr

	global	SYSDC
SYSDC:
	mtoc	zysdc

	global	SYSDM
SYSDM:
	mtoc	zysdm

	global	SYSDT
SYSDT:
	mtoc	zysdt

	global	SYSEA
SYSEA:
	mtoc	zysea

	global	SYSEF
SYSEF:
	mtoc	zysef

	global	SYSEJ
SYSEJ:
	mtoc	zysej

	global	SYSEM
SYSEM:
	mtoc	zysem

	global	SYSEN
SYSEN:
	mtoc	zysen

	global	SYSEP
SYSEP:
	mtoc	zysep

	global	SYSEX
SYSEX:
	mtoc	zysex
 
	global	SYSFC
SYSFC:
	mtoc	zysfc
	pop     eax             ; <<<<remove stacked scblk>>>>
	lea	esp,[esp+edx*4]
	push	eax

	global	SYSGC
SYSGC:
	mtoc	zysgc

	global	SYSHS
SYSHS:
	mtoc	zyshs

	global	SYSID
SYSID:
	mtoc	zysid

	global	SYSIF
SYSIF:
	mtoc	zysif

	global	SYSIL
SYSIL:
	mtoc	zysil

	global	SYSIN
SYSIN:
	mtoc	zysin

	global	SYSIO
SYSIO:
	mtoc	zysio

	global	SYSLD
SYSLD:
	mtoc	zysld

	global	SYSMM
SYSMM:
	mtoc	zysmm

	global	SYSMX
SYSMX:
	mtoc	zysmx

	global	SYSOU
SYSOU:
	mtoc	zysou

	global	SYSPI
SYSPI:
	mtoc	zyspi

	global	SYSPL
SYSPL:
	mtoc	zyspl

	global	SYSPP
SYSPP:
	mtoc	zyspp

	global	SYSPR
SYSPR:
	mtoc	zyspr

	global	SYSRD
SYSRD:
	mtoc	zysrd

	global	SYSRI
SYSRI:
	mtoc	zysri

	global	SYSRW
SYSRW:
	mtoc	zysrw

	global	SYSST
SYSST:
	mtoc	zysst

	global	SYSTM
SYSTM:
	mtoc	zystm

	global	SYSTT
SYSTT:
	mtoc	zystt

	global	SYSUL
SYSUL:
	mtoc	zysul
        
	global	SYSXI
SYSXI:
	mtoc	zysxi

