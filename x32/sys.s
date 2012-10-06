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

	segment	.data
	global	stklo
	global	stkhi

stklo:	times 1024 	dd	0
stkhi:			dd	0

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

	segment	.data

	global	lowspmin:
lowspmin:	dd	0
	global	osisp
osisp:	dd	0


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

;	stackinit  -- initialize lowspmin from sp.
;
;	Input:  sp - current C stack
;		stacksiz - size of desired Minimal stack in bytes
;
;	Uses:	eax
;
;	Output: register WA, sp, lowspmin, compsp, osisp set up per diagram:
;
;	(high)	+----------------+
;		|  old C stack   |
;	  	|----------------| <-- incoming sp, resultant WA (future XS)
;		|	     ^	 |
;		|	     |	 |
;		/ stacksiz bytes /
;		|	     |	 |
;		|            |	 |
;		|----------- | --| <-- resultant lowspmin
;		| 400 bytes  v   |
;	  	|----------------| <-- future C stack pointer, osisp
;		|  new C stack	 |
;	(low)	|                |
	global	read_sp
read_sp:
	mov	eax,esp
	ret

	extern	print_sp
        global  startup

startup:
	mov	eax,1
 	mov	esi.xl,16
 	mov	edi.xr,32
 	mov	ecx.wa,48
 	mov	ebx.wb,256
 	mov	edx.wc,512
 	mov	ebp.cp,1024
	ati	2048
	ati	4097

	mov	dword [osisp],esp	; save location of c stack
	mov	ecx,esp
	mov	eax,stkhi
;	sub	eax,edx	            ; end of MINIMAL stack is where C stack will start
;        mov     dword [osisp],eax               ; save new C stack pointer
;	add	eax,4*1024               ; 100 words smaller for CHK
;	mov	dword [lowspmin],eax	; set lowspmin
;	mov	eax,dword [compsp]
;	mov	ecx,eax
        cld			; default to UP direction for string ops
;	minimal wants (wa)=sp (xr)=first data word (xl)=last data word
;	mov	ecx.wa,stkhi
	mov	edi.xr,dword [reg_xr]
	mov	esi.xl,dword [reg_xl]
;	start doesn't return, so there is no need to save or restore registers.
	call	print_sp
	mov	esp,stkhi
	call	print_sp
	call	start
	add	esp,4


;
;
;



;       interface routines
;
;       each interface routine takes the following form:
;
;               sysxx   call    ccaller         ; call common interface
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
; define interface macro for calling procedures written in c from
; within the minimal code.

;-----------
;
;       ccaller is called by the os interface routines to 
;	call the real c os interface function.
;
;       general calling sequence is
;
;               call    ccaller
;
;       control is never returned to a interface routine.  instead, control
;       is returned to the compiler (the caller of the interface routine).
;
;       the c function that is called must always return an integer
;       indicating the procedure exit to take or that a normal return
;       is to be performed.
;
;       c function      interpretation
;       return value
;       ------------    -------------------------------------------
;       0         do normal return to next instruction after call
;       1         take procedure exit 1
;       2         take procedure exit 2
;       3         take procedure exit 3
;	... 

	%macro	mtoc	1
	extern	%1
	; save minimal registers to make their values availale to called procedure
	mov     dword [reg_wa],ecx     
        mov     dword [reg_wb],ebx
        mov     dword [reg_wc],edx	; (also reg_ia)
        mov     dword [reg_xr],edi
        mov     dword [reg_xl],esi
        mov     dword [reg_cp],ebp	; Needed in image saved by sysxi
        call    %1			; call c interface function
;       restore minimal registers since called procedure  may have changed them
        mov     ecx, dword [reg_wa]	; restore registers
        mov     ebx, dword [reg_wb]
        mov     edx, dword [reg_wc]	; (also reg_ia)
        mov     edi, dword [reg_xr]
        mov     esi, dword [reg_xl]
        mov     ebp, dword [reg_cp]
;	restore direction flag in (the unlikeley) case callee changed it
        cld
;	note that the called procedure must return exi action in eax
	ret
	%endmacro

	global	sysax
sysax:
	mtoc	zysax

	global	sysbs
sysbs:
	mtoc	zysbs

	global	sysbx
sysbx:
	mtoc	zysbx

%if setreal == 1
	global	syscr
syscr:
	mtoc	zyscr
%endif

	global	sysdc
sysdc:
	mtoc	zysdc

	global	sysdm
sysdm:
	mtoc	zysdm

	global	sysdt
sysdt:
	mtoc	zysdt

	global	sysea
sysea:
	mtoc	zysea

	global	sysef
sysef:
	mtoc	zysef

	global	sysej
sysej:
	mtoc	zysej

	global	sysem
sysem:
	mtoc	zysem

	global	sysen
sysen:
	mtoc	zysen

	global	sysep
sysep:
	mtoc	zysep

	global	sysex
sysex:
	mtoc	zysex
 
	global	sysfc
sysfc:
	mtoc	zysfc
	pop     eax             ; <<<<remove stacked scblk>>>>
	lea	esp,[esp+edx*4]
	push	eax

	global	sysgc
sysgc:
	mtoc	zysgc

	global	syshs
syshs:
	mtoc	zyshs

	global	sysid
sysid:
	mtoc	zysid

	global	sysif
sysif:
	mtoc	zysif

	global	sysil
sysil:
	mtoc	zysil

	global	sysin
sysin:
	mtoc	zysin

	global	sysio
sysio:
	mtoc	zysio

	global	sysld
sysld:
	mtoc	zysld

	global	sysmm
sysmm:
	mtoc	zysmm

	global	sysmx
sysmx:
	mtoc	zysmx

	global	sysou
sysou:
	mtoc	zysou

	global	syspi
syspi:
	mtoc	zyspi

	global	syspl
syspl:
	mtoc	zyspl

	global	syspp
syspp:
	mtoc	zyspp

	global	syspr
syspr:
	mtoc	zyspr

	global	sysrd
sysrd:
	mtoc	zysrd

	global	sysri
sysri:
	mtoc	zysri

	global	sysrw
sysrw:
	mtoc	zysrw

	global	sysst
sysst:
	mtoc	zysst

	global	systm
systm:
	mtoc	zystm

	global	systt
systt:
	mtoc	zystt

	global	sysul
sysul:
	mtoc	zysul
        
	global	sysxi
sysxi:
	mtoc	zysxi


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
