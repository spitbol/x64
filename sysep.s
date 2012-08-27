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


	global	sysax
	extern	zysax
sysax:	call	ccaller
        dd   zysax
        db      0
;
	global	sysbs
	extern	zysbs
sysbs:	call	ccaller
        dd   zysbs
        db      3*2
;
        global	 sysbx
	extern	zysbx
sysbx:	mov	[reg_xs],esp
	call	ccaller
        dd zysbx
        db      0
;
%ifdef setreal
        global syscr
	extern	zyscr
syscr:  call    ccaller
        dd zyscr
        db      0
;
%endif
        global sysdc
	extern	zysdc
sysdc:	call	ccaller
        dd zysdc
        db      0
;
        global sysdm
	extern	zysdm
sysdm:	call	ccaller
        dd zysdm
        db      0
;
        global sysdt
	extern	zysdt
sysdt:	call	ccaller
        dd zysdt
        db      0
;
        global sysea
	extern	zysea
sysea:	call	ccaller
        dd zysea
        db      1*2
;
        global sysef
	extern	zysef
sysef:	call	ccaller
        dd zysef
        db      3*2
;
        global sysej
	extern	zysej
sysej:	call	ccaller
        dd zysej
        db      0
;
        global sysem
	extern	zysem
sysem:	call	ccaller
        dd zysem
        db      0
;
        global sysen
	extern	zysen
sysen:	call	ccaller
        dd zysen
        db      3*2
;
        global sysep
	extern	zysep
sysep:	call	ccaller
        dd zysep
        db      0
;
        global sysex
	extern	zysex
sysex:	mov	[reg_xs],esp
	call	ccaller
        dd zysex
        db      3*2
;
        global sysfc
	extern	zysfc
sysfc:  pop     eax             ; <<<<remove stacked scblk>>>>
	lea	esp,[esp+edx*4]
	push	eax
	call	ccaller
        dd zysfc
        db      2*2
;
        global sysgc
	extern	zysgc
sysgc:	call	ccaller
        dd zysgc
        db      0
;
        global syshs
	extern	zyshs
syshs:	mov	[reg_xs],esp
	call	ccaller
        dd zyshs
        db      8*2
;
        global sysid
	extern	zysid
sysid:	call	ccaller
        dd zysid
        db      0
;
        global sysif
	extern	zysif
sysif:	call	ccaller
        dd zysif
        db      1*2
;
        global sysil
	extern	zysil
sysil:  call    ccaller
        dd zysil
        db      0
;
        global sysin
	extern	zysin
sysin:	call	ccaller
        dd zysin
        db      3*2
;
        global sysio
	extern	zysio
sysio:	call	ccaller
        dd zysio
        db      2*2
;
        global sysld
	extern	zysld
sysld:  call    ccaller
        dd zysld
        db      3*2
;
        global sysmm
	extern	zysmm
sysmm:	call	ccaller
        dd zysmm
        db      0
;
        global sysmx
	extern	zysmx
sysmx:	call	ccaller
        dd zysmx
        db      0
;
        global sysou
	extern	zysou
sysou:	call	ccaller
        dd zysou
        db      2*2
;
        global syspi
	extern	zyspi
syspi:	call	ccaller
        dd zyspi
        db      1*2
;
        global syspl
	extern	zyspl
syspl:	call	ccaller
        dd zyspl
        db      3*2
;
        global syspp
	extern	zyspp
syspp:	call	ccaller
        dd zyspp
        db      0
;
        global syspr
	extern	zyspr
syspr:	call	ccaller
        dd zyspr
        db      1*2
;
        global sysrd
	extern	zysrd
sysrd:	call	ccaller
        dd zysrd
        db      1*2
;
        global sysri
	extern	zysri
sysri:	call	ccaller
        dd zysri
        db      1*2
;
        global sysrw
	extern	zysrw
sysrw:	call	ccaller
        dd zysrw
        db      3*2
;
        global sysst
	extern	zysst
sysst:	call	ccaller
        dd zysst
        db      5*2
;
        global systm
	extern	zystm
systm:	call	ccaller
systm_p: dd zystm
        db      0
;
        global systt
	extern	zystt
systt:	call	ccaller
        dd zystt
        db      0
;
        global sysul
	extern	zysul
sysul:	call	ccaller
        dd zysul
        db      0
;
        global sysxi
	extern	zysxi
sysxi:	mov	[reg_xs],esp
	call	ccaller
sysxi_p: dd zysxi
        db      2*2

