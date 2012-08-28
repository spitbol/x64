;        .title          "spitbol assembly-language to c-language o/s interface"
;        .sbttl          "inter"
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

        %include        "systype.ah"
        %include        "os.inc"

        segment .data

; this file defines interface routines for calling procedures written in c from
; within the minimal code.
;
	segment	.text

;-----------
;
;       interface routines
;
;       each interface routine takes the following form:
;
;               sysxx   call    ccaller         ; call common interface
;                       dd      zysxx           ; dd of c osint function
;                       db      n               ; offset to instruction after
;                                               ;   last procedure exit
;
;       in an effort to achieve portability of c osint functions, we
;       do not take take advantage of any "internal" to "external"
;       transformation of names by c compilers.  so, a c osint function
;       representing sysxx is named _zysxx.  this renaming should satisfy
;       all c compilers.
;
;       important:  one interface routine, sysfc, is passed arguments on
;       the stack.  these items are removed from the stack before calling
;       ccaller, as they are not needed by this implementation.
;
;
;-----------
;
;       ccaller is called by the os interface routines to 
;	call the real c os interface function.
;
;       general calling sequence is
;
;               call    ccaller
;               dd      dd_of_c_function
;               db      2*number_of_exit_points
;
;       control is never returned to a interface routine.  instead, control
;       is returned to the compiler (the caller of the interface routine).
;
;       the c function that is called must always return an integer
;       indicating the procedure exit to take or that a normal return
;       is to be performed.
;
;               c function      interpretation
;               return value
;               ------------    -------------------------------------------
;                    <0         do normal return to instruction past
;                               last procedure exit (distance passed
;                               in by dummy routine and saved on stack)
;                     0         take procedure exit 1
;                     4         take procedure exit 2
;                     8         take procedure exit 3
;                    ...        ...
;
ccaller:

;       (1) save registers in global variables
;
        mov     dword [reg_wa],ecx              ; save registers
        mov     dword [reg_wb],ebx
        mov     dword [reg_wc],edx              ; (also _reg_ia)
        mov     dword [reg_xr],edi
        mov     dword [reg_xl],esi
        mov     dword [reg_cp],ebp              ; Needed in image saved by sysxi

;       (2) get pointer to arg list
;
        pop     esi                     ; point to arg list
;
;       (3) fetch dd of c function, fetch offset to  instruction
;           past last procedure exit, and call c function.
;
        cs                              ; cs segment override
        lodsd                           ; point to c function entry point
;       lodsd   cs:ccaller              ; point to c function entry point
        movzx   ebx,byte [esi]   ; save normal exit adjustment
;
        mov     dword [reg_pp],ebx              ; in memory
        pop     dword [reg_pc]                  ; save return pc past "call sysxx"
;
;       (3a) save compiler stack and switch to osint stack
;
        mov     dword [compsp],esp              ; save compiler's stack pointer
        mov     esp,[osisp]               ; load osint's stack pointer
;
;       (3b) make call to osint
;
        call    eax                     ; call c interface function
;
;       (4) restore registers after c function returns.
;
	global	cc1
cc1:    mov     dword [osisp], esp               ; save OSINT's stack pointer
        mov     esp, dword [compsp]              ; restore compiler's stack pointer
        mov     ecx, dword [reg_wa]              ; restore registers
        mov     ebx, dword [reg_wb]
        mov     edx, dword [reg_wc]             ; (also reg_ia)
        mov     edi, dword [reg_xr]
        mov     esi, dword [reg_xl]
        mov     ebp, dword [reg_cp]

        cld
;
;       (5) based on returned value from c function (in eax) either do a normal
;           return or take a procedure exit.
;
        or      eax,eax         ; test if normal return ...
        jns     erexit    ; j. if >= 0 (take numbered exit)
        mov     eax,dword [reg_pc]
        add     eax,dword [reg_pp]      ; point to instruction following exits
        jmp     eax             ; bypass ppm exits

;                               ; else (take procedure exit n)
erexit: shr     eax,1           ; divide by 2
        add     eax,dword [reg_pc]      ;   get to dd of exit offset
        movsx   eax,word [eax]
        add     eax,ppoff       ; bias to fit in 16-bit word
        push    eax
        xor     eax,eax         ; in case branch to error cascade
        ret                     ;   take procedure exit via ppm dd

	%macro	mtoc.1	2
	global	%1
	extern	%2
%1:
	%endmacro

	%macro	mtoc.2  2
	call	cccaller
	dd	%1
	db	%2 * 2
	%endmacro

	%macro	mtoc	3
	mtoc.1	%1,%2
	mtoc.2	%2,%3
	%endmacro

	mtoc	sysax,zysax,0
	mtoc	sysbs,zysbs,3

	mtoc.1	sysbx,zysbx
	mov	[reg_xs],esp
	mtoc.2	zysbx,0

	mtoc	syscr,zyscr,0
	mtoc	sysdc,zysdc,0
	mtoc	sysdm,zysdm,0
	mtoc	sysdt,zysdt,0
	mtoc	sysea,zysea,1
	mtoc	sysef,zysef,3
	mtoc	sysej,zysej,0
	mtoc	sysem,zysem,0
	mtoc	sysen,zysen,3
;	mtoc	sysep,zysep,0

	mtoc.1	sysex,zysex
	mov	[reg_xs],esp
	mtoc.2	zysex,3
 
	mtoc.1	sysfc,zysfc
	pop     eax             ; <<<<remove stacked scblk>>>>
	lea	esp,[esp+edx*4]
	push	eax
	mtoc.2	zysfc,2

	mtoc	sysgc,zysgc,0

	mtoc.1	syshs,zyshs
	mov	[reg_xs],esp
	mtoc.2	zyshs,8

	mtoc	sysid,zysid,0
	mtoc	sysif,zysif,1
	mtoc	sysil,zysil,0
	mtoc	sysin,zysin,3
	mtoc	sysio,zysio,2
	mtoc	sysld,zysld,3
	mtoc	sysmm,zysmm,0
	mtoc	sysmx,zysmx,0
	mtoc	sysou,zysou,2
	mtoc	syspi,zyspi,1
	mtoc	syspl,zyspl,3
	mtoc	syspp,zyspp,0
	mtoc	syspr,zyspr,1
	mtoc	sysrd,zysrd,1
	mtoc	sysri,zysri,1
	mtoc	sysrw,zysrw,3
	mtoc	sysst,zysst,5
	mtoc	systm,zystm,0
	mtoc	systt,zystt,0
	mtoc	sysul,zysul,0
        
	mtoc.1	sysxi,zysxi
	mov	[reg_xs],esp
	mtoc.2  zysci,2

