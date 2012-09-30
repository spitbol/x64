;        .title          "spitbol assembly-language to c-language o/s interface"
;        .sbttl          "inter"
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
;       contents:
;
;       o overview
;       o global variables accessed by osint functions
;       o c callable function startup
;       o c callable function get_fp
;       o c callable function restart
;       o c callable function makeexec
;       o routines for minimal opcodes chk and cvd
;       o math functions for integer multiply, divide, and remainder
;       o math functions for real operation
;
;-----------
;
;       overview
;
;       the macro spitbol compiler relies on a set of operating system
;       interface functions to provide all interaction with the host
;       operating system.  these functions are referred to as osint
;       functions.  a typical call to one of these osint functions takes
;       the following form in the 80386 version of the compiler:
;
;               ...code to put arguments in registers...
;               call    sysxx           ; call osint function
;               dd      exit_1          ; dd of exit point 1
;               dd      exit_2          ; dd of exit point 2
;               ...     ...             ; ...
;               dd      exit_n          ; dd of exit point n
;               ...instruction following call...
;
;       the osint function 'sysxx' can then return in one of n+1 ways:
;       to one of the n exit points or to the instruction following the
;       last exit.  this is not really very complicated - the call places
;       the return dd on the stack, so all the interface function has
;       to do is add the appropriate offset to the return dd and then
;       pick up the exit dd and jump to it or do a normal return via
;       an ret instruction.
;
;       unfortunately, a c function cannot handle this scheme.  so, an
;       intermediary set of routines have been established to allow the
;       interfacing of c functions.  the mechanism is as follows:
;
;       (1) the compiler calls osint functions as described above.
;
;       (2) a set of assembly language interface routines is established,
;           one per osint function, named accordingly.  each interface
;           routine ...
;
;           (a) saves all compiler registers in global variables
;               accessible by c functions
;           (b) calls the osint function written in c
;           (c) restores all compiler registers from the global variables
;           (d) inspects the osint function's return value to determine
;               which of the n+1 returns should be taken and does so
;
;       (3) a set of c language osint functions is established, one per
;           osint function, named differently than the interface routines.
;           each osint function can access compiler registers via global
;           variables.  no arguments are passed via the call.
;
;           when an osint function returns, it must return a value indicating
;           which of the n+1 exits should be taken.  these return values are
;           defined in header file 'inter.h'.
;
;       note:  in the actual implementation below, the saving and restoring
;       of registers is actually done in one common routine accessed by all
;       interface routines.
;
;       acknowledgement:
;
;       this interfacing scheme is based on an idea put forth by andy koenig.
;
;------------
;
;       global variables

	extern	atlin
	extern	id_call

	extern	at_xl;
	extern	at_xr;
	extern	at_xs;
	extern	at_wa;
	extern	at_wb;
	extern	at_wc;
	extern	at_w0;
	extern	at_cp;
	extern	atip;

%define globals 1

	%include	"x32/x32.h"
        %include        "x32/os.inc"


        extern  swcoup
	extern	atmsg
	extern	atlin
	extern	stacksiz
	extern	lmodstk
	extern	lowsp
	extern	outptr
%if direct == 0
        extern     valtab
%endif


	segment	.data
;
        align 4

        global  reg_cp
        global  reg_ia
        global  reg_pc
        global  reg_pp
        global  reg_ra
        global  reg_xl
        global  reg_xr
        global  reg_xs
        global  reg_wa
        global  reg_wb
        global  reg_wc
        global  reg_w0

        global  reg_block
        global  reg_size
	global	stack_low
	global	stack_top

stack_low:	times 500 	dd	0
stack_top:			dd	0



reg_block:
reg_wa: dd      0     		; Register WA (ECX)
reg_wb: dd      0     		; Register WB (EBX)
reg_ia:
reg_wc: dd   	0     		; Register WC & IA (EDX)
reg_w0: dd   	0     		; Register W0 (EAX)
reg_xr: dd   	0     		; Register XR (EDI)
reg_xl: dd   	0     		; Register XL (ESI)
reg_cp: dd   	0     		; Register CP
reg_ra: dq   	0e    		; Register RA
;
; these locations save information needed to return after calling osint
; and after a restart from exit()
;
reg_pc:	dd	0		; return pc from caller
reg_pp: dd      0               ; number of bytes of ppms
reg_xs:	dd   	0  		; minimal stack pointer
;
r_size equ      $-reg_block
reg_size        db      r_size

;	reg_dump is used to retrieve the register values for
;	use during debugging

; end of words saved during exit(-3)
;
sav_block: times r_size dd 0    ; save minimal registers during push/pop reg
;
	dd	0
	dd	0

        align 4
	global	ppoff
ppoff:  dd      0               ; offset for ppm exits
	global	compsp
compsp: dd      0               ; compiler's stack pointer
sav_compsp:
        dd      0               ; save compsp here

;
;       setup a number of internal ddes in the compiler that cannot
;       be directly accessed from within c because of naming difficulties.
;
	global	ID1
ID1	dd	0
%ifdef setreal
        dd       2
        db  "1x\x00\x00"
%else
        dd       1
        db  "1x\x00\x00\x00"
%endif
;
	global	ID2BLK
	dd	0
ID2BLK:	times	52 dd 0
	global	TSCBLK

	global	TICBLK
TICBLK:	dd	0

	global	TSCBLk
        dd      0
TSCBLK:	times	512 dd 0

;       standard input buffer block.
;
	global	INPBUF
INPBUF:
        dd      0               ; type work
        dd      0               ; block length
        dd      1024            ; buffer size
        dd      0               ; remaining chars to read
        dd      0               ; offset to next character to read
        dd      0               ; file position of buffer
        dd      0               ; physical position in file
        times   1024 dd 0       ; buffer
;
	global	TTYBUF
TTYBUF:	dd   	0     		; type word
        dd      0               ; block length
        dd      260             ; buffer size  (260 ok in ms-dos with cinread())
        dd      0               ; remaining chars to read
        dd      0               ; offset to next char to read
        dd      0               ; file position of buffer
        dd      0               ; physical position in file
        times   260 dd 0        ; buffer


        segment .text

; start is main entry point in minimal source
	extern	start

        global  startup
startup:
	mov 	esp,stack_top
	mov	ecx.wa,esp
	sub	ecx,500
	mov	dword[stack_low],ecx
	mov	edi.xr,dword [reg_xr]
	mov	esi.xl,dword [reg_xl]
;	ati	10
        cld                             ; default to UP direction for string ops
;	start doesn't return, so there is no need to save or restore registers.
;	ati	20
	call	start
	add	esp,4

;	global	save_cp
;	global	save_xl
;	global	save_xr
;	global	save_xs
;	global	save_wa
;	global	save_wb
;	global	save_wc
;
;	global	osisp

	segment	.text



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
; define interface routines for calling procedures written in c from
; within the minimal code.

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
;ccaller:

;       (1) save registers in global variables
;
ccaller:        
	ati	100
	mov     dword [reg_wa],ecx              ; save registers
	ati	101
        mov     dword [reg_wb],ebx
	ati	102
        mov     dword [reg_wc],edx              ; (also _reg_ia)
	ati	103
        mov     dword [reg_xr],edi
	ati	104
        mov     dword [reg_xl],esi
	ati	105
        mov     dword [reg_cp],ebp              ; Needed in image saved by sysxi
	ati	106

;       (2) get pointer to arg list
;
        pop     esi                     	; point to arg list
;
;       (3) fetch dd of c function, fetch offset to  instruction
;           past last procedure exit, and call c function.
;
        cs                              	; cs segment override
        lodsd                           	; point to c function entry point
	ati	107
        movzx   ebx,byte [esi]   		; save normal exit adjustment
;
	ati	108
        mov     dword [reg_pp],ebx              ; in memory
        pop     dword [reg_pc]                  ; save return pc past "call sysxx"
	ati	109
;
;       (3a) save compiler stack and switch to osint stack
;
;        mov     dword [compsp],esp              ; save compiler's stack pointer
;        mov     esp,osisp               	; load osint's stack pointer
;
;       (3b) make call to osint
;
	ati	110
        call    eax                     	; call c interface function
;
;       (4) restore registers after c function returns.
;
	global	cc1

cc1:    
;	mov     dword [osisp], esp              ; save OSINT's stack pointer
;        mov     esp, dword [compsp]             ; restore compiler's stack pointer
;       mov     esp,compsp             ; restore compiler's stack pointer
	ati	111
        mov     ecx, dword [reg_wa]             ; restore registers
	ati	112
        mov     ebx, dword [reg_wb]
	ati	113
        mov     edx, dword [reg_wc]             ; (also reg_ia)
	ati	114
        mov     edi, dword [reg_xr]
	ati	115
        mov     esi, dword [reg_xl]
	ati	116
        mov     ebp, dword [reg_cp]
	ati	117

        cld
;
;       (5) based on returned value from c function (in eax) either do a normal
;           return or take a procedure exit.
;
	ati	110
        or      eax,eax         ; test if normal return ...
	ati	110
        jns     erexit    ; j. if >= 0 (take numbered exit)
	ati	110
        mov     eax,dword [reg_pc]
	ati	110
        add     eax,dword [reg_pp]      ; point to instruction following exits
	ati	110
        jmp     eax             ; bypass ppm exits
	ati	110

;                               ; else (take procedure exit n)
erexit: shr     eax,1           ; divide by 2
        add     eax,dword [reg_pc]      ;   get to dd of exit offset
        movsx   eax,word [eax]
        add     eax,ppoff       ; bias to fit in 16-bit word
        push    eax
        xor     eax,eax         ; in case branch to error cascade
        ret                     ;   take procedure exit via ppm dd


 
	%macro	mtoc	2
	global	%1
	extern	%2
%1:
	%endmacro

	mtoc	sysax,zysax
	call	ccaller
	db	0

	mtoc	sysbs,zysbs
	call	ccaller
	db	6

	mtoc	sysbx,zysbx
	mov	[reg_xs],esp
	call	ccaller
	db	0

%if setreal == 1
	mtoc	syscr,zyscr
	call	ccaller
	db	0
%endif
	mtoc	sysdc,zysdc
	call	ccaller
	db	0

	mtoc	sysdm,zysdm
	call	ccaller
	db	0

	mtoc	sysdt,zysdt
	call	ccaller
	db	0

	mtoc	sysea,zysea
	call	ccaller
	db	2

	mtoc	sysef,zysef
	call	ccaller
	db	6

	mtoc	sysej,zysej
	call	ccaller
	db	0

	mtoc	sysem,zysem
	call	ccaller
	db	0

	
	mtoc	sysen,zysen
	call	ccaller
	db	0

	mtoc	sysep,zysep
	call	ccaller
	db	6

	mtoc	sysex,zysex
	mov	[reg_xs],esp
	call	ccaller
	db	6
 
	mtoc	sysfc,zysfc
	pop     eax             ; <<<<remove stacked scblk>>>>
	lea	esp,[esp+edx*4]
	push	eax
	call	ccaller
	db	4

	mtoc	sysgc,zysgc
	call	ccaller
	db	0

	mtoc	syshs,zyshs
	mov	[reg_xs],esp
	call	ccaller
	db	16

	mtoc	sysid,zysid
	call	ccaller
	db	0

	mtoc	sysif,zysif
	call	ccaller
	db	2

	mtoc	sysil,zysil
	call	ccaller
	db	0

	mtoc	sysin,zysin
	call	ccaller
	db	6

	mtoc	sysio,zysio
	call	ccaller
	db	4

	mtoc	sysld,zysld
	call	ccaller
	db	0

	mtoc	sysmm,zysmm
	call	ccaller
	db	0

	mtoc	sysmx,zysmx
	call	ccaller
	db	0

	mtoc	sysou,zysou
	call	ccaller
	db	4

	mtoc	syspi,zyspi
	call	ccaller
	db	2

	mtoc	syspl,zyspl
	call	ccaller
	db	6

	mtoc	syspp,zyspp
	call	ccaller
	db	0

	mtoc	syspr,zyspr
	call	ccaller
	db	2

	mtoc	sysrd,zysrd
	call	ccaller
	db	2

	mtoc	sysri,zysri
	call	ccaller
	db	2

	mtoc	sysrw,zysrw
	call	ccaller
	db	6

	mtoc	sysst,zysst
	call	ccaller
	db	10

	mtoc	systm,zystm
	call	ccaller
	db	0

	mtoc	systt,zystt
	call	ccaller
	db	0

	mtoc	sysul,zysul
	call	ccaller
	db	0

        
	mtoc	sysxi,zysxi
	mov	[reg_xs],esp
	call	ccaller
	db	4





; INCLUDE INT-ARITH
	segment		.data

        align 4

;  constants
;
Ten:    dd      10              ; constant 10
;;inf:    dd      0       
;;        dd      0x7ff00000      ; double precision infinity

	segment		.text
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


; SERIAL
        segment		.data
        align         	4
	global	hasfpu
hasfpu:	dd	0
        global         cprtmsg
cprtmsg:
	db              " Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer."
	db		0
