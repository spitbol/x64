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

	extern	_rc_
	extern	reg_xl
	extern	reg_xr
	extern	reg_xs
	extern	reg_wa
	extern	reg_wb
	extern	reg_wc
	extern	reg_cp
	extern	reg_pc
	extern	compsp
	extern	osisp
	extern	at_note
	extern	at_note1

reg_pp	dd	0


;-----------
;
;       Interface routines
;
;       Each interface routine takes the following form:
;
;               SYSXX   call    ccaller         ; call common interface
;                       dd      zysxx           ; dd     of C OSINT function
;                       db      n               ; offset to instruction after
;                                               ;   last procedure exit
;
;       In an effort to achieve portability of C OSINT functions, we
;       do not take take advantage of any "internal" to "external"
;       transformation of names by C compilers.  So, a C OSINT function
;       representing sysxx is named _zysxx.  This renaming should satisfy
;       all C compilers.
;
;       IMPORTANT  ONE interface routine, SYSFC, is passed arguments on
;       the stack.  These items are removed from the stack before calling
;       ccaller, as they are not needed by this implementation.
;
;
;-----------
;
;       CCALLER is called by the OS interface routines to call the
;       real C OS interface function.
;
;       General calling sequence is
;
;               call    ccaller
;               dd      address_of_C_function
;               db      2*number_of_exit_points
;
;       Control IS NEVER returned to a interface routine.  Instead, control
;       is returned to the compiler (THE caller of the interface routine).
;
;       The C function that is called MUST ALWAYS return an integer
;       indicating the procedure exit to take or that a normal return
;       is to be performed.
;
;               C function      Interpretation
;               return value
;               ------------    -------------------------------------------
;                    <0         Do normal return to instruction past
;                               last procedure exit (distance passed
;                               in by dummy routine and saved on stack)
;                     0         Take procedure exit 1
;                     4         Take procedure exit 2
;                     8         Take procedure exit 3
;                    ...        ...
;
ccaller:

;       (1) Save registers in global variables
;
        mov     dword [reg_wa],ecx              ; save registers
	mov	dword [reg_wb],ebx
        mov     dword [reg_wc],edx              ; (also _reg_ia)
	mov	dword [reg_xr],edi
	mov	dword [reg_xl],esi
        mov     dword [reg_cp],ebp              ; Needed in image saved by sysxi

;       (2) Get pointer to arg list
;
        pop     esi                     ; point to arg list
;
;       (3) Fetch dd     of C function, fetch offset to 1st instruction
;           past last procedure exit, and call C function.
;
         cs                              ; CS segment override
         lodsd                           ; point to C function entry point
	call	at_note
;       lodsd   cs:ccaller              ; point to C function entry point
;       movzx   ebx,byte [esi]   ; save normal exit adjustment
;
;       mov     dword [reg_pp],ebx              ; in memory
        pop     dword [reg_pc]                  ; save return PC past "CALL SYSXX"
;
;       (3a) Save compiler stack and switch to OSINT stack
;
; DS 12/22/12 Note that needn't save and restore stack ptrs if not using
; 	save files or load modules
         mov     dword [compsp],esp              ; 1.39 save compiler's stack pointer
         mov     esp,dword [osisp]               ; 1.39 load OSINT's stack pointer
;
;       (3b) Make call to OSINT
;
        call    eax                     ; call C interface function
	call	at_note1

	mov	dword [_rc_],eax		; save return code from function
;
;       (4) Restore registers after C function returns.
;

cc1:    
 	mov     dword [osisp],esp               ; 1.39 save OSINT's stack pointer
        mov     esp,dword [compsp]              ; 1.39 restore compiler's stack pointer
        mov     ecx,dword [reg_wa]              ; restore registers
	mov	ebx,dword [reg_wb]
        mov     edx,dword [reg_wc]              ; (also reg_ia)
	mov	edi,dword [reg_xr]
	mov	esi,dword [reg_xl]
	mov	ebp,dword [reg_cp]

	cld

	call	at_note
 	mov	eax,dword [reg_pc]
	 jmp	eax

;
;---------------
;
;       Individual OSINT routine entry points
;
        global SYSAX
	extern	zysax
SYSAX:	call	ccaller
        dd       zysax
        db      0
;
        global SYSBS
	extern	zysbs
SYSBS:	call	ccaller
        dd       zysbs
        db      0
;
        global SYSBX
	extern	zysbx
SYSBX:	mov	dword [reg_xs],esp
	call	ccaller
        dd     zysbx
        db      0
;
;.if SETREAL == 1
;        global SYSCR
;	extern	zyscr
;SYSCR:  call    ccaller
;        dd     zyscr
;        db      0
;
;.endif
        global SYSDC
	extern	zysdc
SYSDC:	call	ccaller
        dd     zysdc
        db      0
;
        global SYSDM
	extern	zysdm
SYSDM:	call	ccaller
        dd     zysdm
        db      0
;
        global SYSDT
	extern	zysdt
SYSDT:	call	ccaller
        dd     zysdt
        db      0
;
        global SYSEA
	extern	zysea
SYSEA:	call	ccaller
        dd     zysea
        db      0
;
        global SYSEF
	extern	zysef
SYSEF:	call	ccaller
        dd     zysef
        db      0
;
        global SYSEJ
	extern	zysej
SYSEJ:	call	ccaller
        dd     zysej
        db      0
;
        global SYSEM
	extern	zysem
SYSEM:	call	ccaller
        dd     zysem
        db      0
;
        global SYSEN
	extern	zysen
SYSEN:	call	ccaller
        dd     zysen
        db      0
;
        global SYSEP
	extern	zysep
SYSEP:	call	ccaller
        dd     zysep
        db      0
;
        global SYSEX
	extern	zysex
SYSEX:	mov	dword [reg_xs],esp
	call	ccaller
        dd     zysex
        db      0
;
        global SYSFC
	extern	zysfc
SYSFC:  pop     eax             ; <<<<remove stacked SCBLK>>>>
	lea	esp,[esp+edx*4]
	push	eax
	call	ccaller
        dd     zysfc
        db      0
;
        global SYSGC
	extern	zysgc
SYSGC:	call	ccaller
        dd     zysgc
        db      0
;
        global SYSHS
	extern	zyshs
SYSHS:	mov	dword [reg_xs],esp
	call	ccaller
        dd     zyshs
        db      0
;
        global SYSID
	extern	zysid
SYSID:	call	ccaller
        dd     zysid
        db      0
;
        global SYSIF
	extern	zysif
SYSIF:	call	ccaller
        dd     zysif
        db      0
;
        global SYSIL
	extern	zysil
SYSIL:  call    ccaller
        dd     zysil
        db      0
;
        global SYSIN
	extern	zysin
SYSIN:	call	ccaller
        dd     zysin
        db      0
;
        global SYSIO
	extern	zysio
SYSIO:	call	ccaller
        dd     zysio
        db      0
;
        global SYSLD
	extern	zysld
SYSLD:  call    ccaller
        dd     zysld
        db      0
;
        global SYSMM
	extern	zysmm
SYSMM:	call	ccaller
        dd     zysmm
        db      0
;
        global SYSMX
	extern	zysmx
SYSMX:	call	ccaller
        dd     zysmx
        db      0
;
        global SYSOU
	extern	zysou
SYSOU:	call	ccaller
        dd     zysou
        db      0
;
        global SYSPI
	extern	zyspi
SYSPI:	call	ccaller
        dd     zyspi
        db      0
;
        global SYSPL
	extern	zyspl
SYSPL:	call	ccaller
        dd     zyspl
        db      0
;
        global SYSPP
	extern	zyspp
SYSPP:	call	ccaller
        dd     zyspp
        db      0
;
        global SYSPR
	extern	zyspr
SYSPR:	call	ccaller
        dd     zyspr
        db      0
;
        global SYSRD
	extern	zysrd
SYSRD:	call	ccaller
        dd     zysrd
        db      0
;
        global SYSRI
	extern	zysri
SYSRI:	call	ccaller
        dd     zysri
        db      0
;
        global SYSRW
	extern	zysrw
SYSRW:	call	ccaller
        dd     zysrw
        db      0
;
        global SYSST
	extern	zysst
SYSST:	call	ccaller
        dd     zysst
        db      0
;
        global SYSTM
	extern	zystm
SYSTM:	call	ccaller
systm_p: dd     zystm
        db      0
;
        global SYSTT
	extern	zystt
SYSTT:	call	ccaller
        dd     zystt
        db      0
;
        global SYSUL
extern	zysul
SYSUL:	call	ccaller
        dd     zysul
        db      0
;
        global SYSXI
	extern	zysxi
SYSXI:	mov	dword [reg_xs],esp
	call	ccaller
sysxi_p: dd     zysxi
        db      0

