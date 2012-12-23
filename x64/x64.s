; Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
; Copyright 2012 David Shields
; 
; This file is part of Macro SPITBOL.
; 
;     Macro SPITBOL is free software: you can redistribute it and/or modify
;     it under the terms of the GNU General Public License as published by
;     the Free Software Foundation, either version 2 of the License, or
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
	%define	XL	RSI
	%define	XT	RSI
	%define	XR	RDI
	%define	WA	RCX
	%define WA_L	CL
	%define	WB	RBX
	%define WB_L    BL
	%define	WC	RDX
	%define WC_L    DL
	%define	XS	RSP
	%define	W0	RAX
	%define	W0_L	AL
	%define	IA	RDX
	global	reg_block
	extern	lowspmin

	global	reg_w0
	global	reg_wa
	global	reg_wb
	global	reg_ia
	global	reg_wc
	global	reg_xr
	global	reg_xl
	global	reg_cp
	global	reg_ra
	global	reg_pp
	global	reg_pc
	global	reg_xs
	global	reg_size

 	global	minimal
	extern	calltab
	extern	stacksiz
	extern	zz_arg
	extern	zz_num
 
%define globals 1                       ;ASM globals defined here

;
;       File: inter.s           Version: 1.46
;       ---------------------------------------
;
;       This file contains the assembly language routines that interface
;       the Macro SPITBOL compiler written in 80386 assembly language to its
;       operating system interface functions written in C.
;
;       Contents:
;
;       o Overview
;       o Global variables accessed by OSINT functions
;       o Interface routines between compiler and OSINT functions
;       o C callable function startup
;       o C callable function get_fp
;       o C callable function restart
;       o C callable function makeexec
;       o Routines for Minimal opcodes CHK and CVD
;       o Math functions for integer multiply, divide, and remainder
;       o Math functions for real operation
;
;-----------
;
;       Overview
;
;       The Macro SPITBOL compiler relies on a set of operating system
;       interface functions to provide all interaction with the host
;       operating system.  These functions are referred to as OSINT
;       functions.  A typical call to one of these OSINT functions takes
;       the following form in the 80386 version of the compiler:
;
;               ...code to put arguments in registers...
;               call    SYSXX           # call osint function
;               dq      EXIT_1          # address of exit point 1
;               dq      EXIT_2          # address of exit point 2
;               ...     ...             # ...
;               dq      EXIT_n          # address of exit point n
;               ...instruction following call...
;
;       The OSINT function 'SYSXX' can then return in one of n+1 ways:
;       to one of the n exit points or to the instruction following the
;       last exit.  This is not really very complicated - the call places
;       the return address on the stack, so all the interface function has
;       to do is add the appropriate offset to the return address and then
;       pick up the exit address and jump to it OR do a normal return via
;       an ret instruction.
;
;       Unfortunately, a C function cannot handle this scheme.  So, an
;       intermediary set of routines have been established to allow the
;       interfacing of C functions.  The mechanism is as follows:
;
;       (1) The compiler calls OSINT functions as described above.
;
;       (2) A set of assembly language interface routines is established,
;           one per OSINT function, named accordingly.  Each interface
;           routine ...
;
;           (a) saves all compiler registers in global variables
;               accessible by C functions
;           (b) calls the OSINT function written in C
;           (c) restores all compiler registers from the global variables
;           (d) inspects the OSINT function's return value to determine
;               which of the n+1 returns should be taken and does so
;
;       (3) A set of C language OSINT functions is established, one per
;           OSINT function, named differently than the interface routines.
;           Each OSINT function can access compiler registers via global
;           variables.  NO arguments are passed via the call.
;
;           When an OSINT function returns, it must return a value indicating
;           which of the n+1 exits should be taken.  These return values are
;           defined in header file 'inter.h'.
;
;       Note:  in the actual implementation below, the saving and restoring
;       of registers is actually done in one common routine accessed by all
;       interface routines.
;
;       Other notes:
;
;       Some C ompilers transform "internal" global names to
;       "external" global names by adding a leading underscore at the front
;       of the internal name.  Thus, the function name 'osopen' becomes
;       '_osopen'.  However, not all C compilers follow this convention.
;
;------------
;
;       Global Variables
;
        segment	.data
; 	extern	swcoup
; 
; 	extern	stacksiz
; 	extern	lmodstk
; 	extern	lowsp
; 	extern	outptr
; 	extern	calltab
; 
; ;       .include "extrn386.inc"
; 
; 
; ; Words saved during exit(-3)

	bits	64
        align 4
reg_block:
reg_wa:	dq	0        ; Register WA (ECX)
reg_wb:	dd 	0        ; Register WB (EBX)
reg_ia:
reg_wc:	dq	0		; Register WC & IA (EDX)
reg_xr:	dq	0        ; Register XR (EDI)
reg_xl:	dq	0        ; Register XL (ESI)
reg_cp:	dq	0        ; Register CP
reg_ra	dq 	0.0  ; Register RA
;
; These locations save information needed to return after calling OSINT
; and after a restart from EXIT()
;
reg_pc: dq      0               ; return PC from caller
reg_pp: dq      0               ; Number of bytes of PPMs
reg_xs:	dq	0;		 Minimal stack pointer
;
;	r_size  equ       $-reg_block
; use computed value for nasm conversion, put back proper code later
r_size	equ	88
reg_size:	dq   r_size

reg_w0:	dq	0
;
; end of words saved during exit(-3)
;

;
;  Constants
;
	global	ten
ten:    dq      10              ; constant 10
        global  inf
inf:	dq	0   
        dq      0x7ff00000      ; double precision infinity

	global	sav_block
;sav_block: times r_size db 0     ; Save Minimal registers during push/pop reg
sav_block: times 44 db 0     ; Save Minimal registers during push/pop reg
;
        align 4
	global	ppoff
ppoff:  dq      0               ; offset for ppm exits
	global	compsp
compsp: dq      0               ; 1.39 compiler's stack pointer
	global	sav_compsp
sav_compsp:
        dq      0               ; save compsp here
	global	osisp
osisp:  dq      0               ; 1.39 OSINT's stack pointer
	global	_rc_
_rc_:	dq   0	; return code from osint procedure
; 
%define SETREAL 0
;
;       Setup a number of internal addresses in the compiler that cannot
;       be directly accessed from within C because of naming difficulties.
;
        global  ID1
ID1:	dq   0
%if SETREAL == 1
        dq       2

        dq       1
        db  "1x\x00\x00\x00"
%endif
;
        global  ID2BLK
ID2BLK	dq   52
        dq      0
        times   52 db 0

        global  TICBLK
TICBLK:	dq   0
        dq      0

        global  TSCBLK
TSCBLK:	 dq   512
        dq      0
        times   512 db 0

;
;       Standard input buffer block.
;
        global  INPBUF
INPBUF:	dq	0		; type word
        dq      0               ; block length
        dq      1024            ; buffer size
        dq      0               ; remaining chars to read
        dq      0               ; offset to next character to read
        dq      0               ; file position of buffer
        dq      0               ; physical position in file
        times   1024 db 0        ; buffer
;
        global  TTYBUF
TTYBUF:	dq   0     ; type word
        dq      0               ; block length
        dq      260             ; buffer size  (260 OK in MS-DOS with cinread())
        dq      0               ; remaining chars to read
        dq      0               ; offset to next char to read
        dq      0               ; file position of buffer
        dq      0               ; physical position in file
        times   260 db 0         ; buffer
; ;-----------
; ;
; ;       Save and restore MINIMAL and interface registers on stack.
; ;       Used by any routine that needs to call back into the MINIMAL
; ;       code in such a way that the MINIMAL code might trigger another
; ;       SYSxx call before returning.
; ;
; ;       Note 1:  pushregs returns a collectable value in XL, safe
; ;       for subsequent call to memory allocation routine.
; ;
; ;       Note 2:  these are not recursive routines.  Only reg_xl is
; ;       saved on the stack, where it is accessible to the garbage
; ;       collector.  Other registers are just moved to a temp area.
; ;
; ;       Note 3:  popregs does not restore REG_CP, because it may have
; ;       been modified by the Minimal routine called between pushregs
; ;       and popregs as a result of a garbage collection.  Calling of
; ;       another SYSxx routine in between is not a problem, because
; ;       CP will have been preserved by Minimal.
; ;
; ;       Note 4:  if there isn't a compiler stack yet, we don't bother
; ;       saving XL.  This only happens in call of nextef from sysxi when
; ;       reloading a save file.
; ;
; ;

; 	global	pushregs
; pushregs:
; ;	pushaq
; 	lea	XL,[reg_block]
; 	lea	XR,[sav_block]
; 	mov	WA,r_size/8
; 	cld
;    rep	movsd
; 
;         mov     XR,qword [compsp]
;         or      XR,XR                         ; is there a compiler stack
;         je      push1                     ; jump if none yet
;         sub     XR,8                           ;push onto compiler's stack
;         mov     XL,qword [reg_xl]                      ;collectable xl
; 	mov	[XR],XL
;         mov     qword [compsp],XR                      ;smashed if call osint again (sysgc)
;         mov     qword [sav_compsp],XR                  ;used by popregs
; 
; push1:	
; ;popaq
; 	ret
; 
; 	global	popregs
; popregs:
; ;	pushaq
; 	cld
; 	lea	XL,[sav_block]
;         lea     XR,[reg_block]                   ;unload saved registers
; 	mov	WA,r_size/8
;    rep  movsd                                   ;restore from temp area
; 
;         mov     XR,qword [sav_compsp]                  ;saved compiler's stack
;         or      XR,XR                         ;is there one?
;         je      pop1                      ;jump if none yet
;         mov     XL,qword [XR]                       ;retrieve collectable xl
;         mov     qword [reg_xl],XL                      ;update xl
;         add     XR,8                           ;update compiler's sp
;         mov     qword [compsp],XR
; 
; pop1:	
; ;	popaq
; 	ret
; 
; ;
; ;
; ;-----------
; ;
; ;       startup( char *dummy1, char *dummy2) - startup compiler
; ;
; ;       An OSINT C function calls startup to transfer control
; ;       to the compiler.
; ;
; ;       (XR) = basemem
; ;       (XL) = topmem - sizeof(WORD)
; ;
; ;	Note: This function never returns.
; ;
; 
	global	startup
;   Ordinals for MINIMAL calls from assembly language.
;
;   The order of entries here must correspond to the order of
;   calltab entries in the INTER assembly language module.
;

;   ordinals for minimal calls from assembly language.
;
;   the order of entries here must corrXSond to the order of
;   calltab entries in the inter assembly language module.
;
calltab_relaj equ   0
calltab_relcr equ   1
calltab_reloc equ   2
calltab_alloc equ   3
calltab_alocs equ   4
calltab_alost equ   5
calltab_blkln equ   6
calltab_insta equ   7
calltab_rstrt equ   8
calltab_start equ   9
calltab_filnm equ   10
calltab_dtype equ   11
calltab_enevs equ   12
calltab_engts equ   13

; 
startup:
        pop     W0                     ; pop return address (this procedure never returns)
	mov	[zz_arg],XS
	call	zz_num
	call	stackinit               ; initialize minimal stack
        mov     W0,[compsp]              ; get minimal's stack pointer
        mov 	[reg_wa],W0                     ; startup stack pointer

	cld                             ; default to up direction for string ops
;        getoff  W0,dffnc                get address of ppm offset
        mov     XS,[osisp]               ; switch to new c stack
	mov	WA,[compsp]
;	Minimal start expects inital stack pointer (SP) to be in WA.
	mov	WA,rsp
	push	calltab_start
	call	minimal			; load regs, switch stack, start compiler

;
; 
;
;-----------
;
;	stackinit  -- initialize LOWSPMIN from sp.
;
;	Input:  sp - current C stack
;		stacksiz - size of desired Minimal stack in bytes
;
;	Uses:	W0
;
;	Output: register WA, sp, LOWSPMIN, compsp, osisp set up per diagram:
;
;	(high)	+----------------+
;		|  old C stack   |
;	  	|----------------| <-- incoming sp, resultant WA (future XS)
;		|	     ^	 |
;		|	     |	 |
;		/ stacksiz bytes /
;		|	     |	 |
;		|            |	 |
;		|----------- | --| <-- resultant LOWSPMIN
;		| 400 bytes  v   |
;	  	|----------------| <-- future C stack pointer, osisp
;		|  new C stack	 |
;	(low)	|                |
;
;
;

	global	stackinit
stackinit:
	mov	W0,rsp
        mov     [compsp],W0              ; save as MINIMAL's stack pointer
	sub	W0,[stacksiz]            ; end of MINIMAL stack is where C stack will start
        mov     [osisp],W0               ; save new C stack pointer
	add	W0,8*100               ; 100 words smaller for CHK
	extern	lowspmin
	mov	[lowspmin],W0
	ret

;
;-----------
;
;       mimimal -- call MINIMAL function from C
;
;       Usage:  extern void minimal(WORD callno)
;
;       where:
;         callno is an ordinal defined in osint.h, osint.inc, and calltab.
;
;       Minimal registers WA, WB, WC, XR, and XL are loaded and
;       saved from/to the register block.
;
;       Note that before restart is called, we do not yet have compiler
;       stack to switch to.  In that case, just make the call on the
;       the OSINT stack.
;

 
 minimal:
        mov     W0,qword [XS+32+8]          ; get ordinal
        mov     WA,qword [reg_wa]              ; restore registers
 	mov	WB,qword [reg_wb]
        mov     WC,qword [reg_wc]              ; (also _reg_ia)
 	mov	XR,qword [reg_xr]
 	mov	XL,qword [reg_xl]
        mov     qword [osisp],XS               ; save osint stack pointer
        cmp     qword [compsp],0      ; is there a compiler stack?
        je      min1              ; jump if none yet
        mov     XS,qword [compsp]              ; switch to compiler stack

 min1:
	extern	start
	call	start
;		call   qword [calltab+W0*8]        ; off to the minimal code

        mov     XS,qword [osisp]               ; switch to osint stack
 	mov	qword [reg_xl],XL
 	mov	qword [reg_xr],XR
        mov     qword [reg_wa],WA              ; save registers
 	mov	qword [reg_wb],WB
 	mov	qword [reg_wc],WC
	mov	qword [reg_w0],W0
 	ret

 
        section		.data
        align         8
	global	hasfpu
hasfpu:	dq	0
	global	cprtmsg
cprtmsg:
	db          ' Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.',0,0


;       Interface routines

;       Each interface routine takes the following form:

;               SYSXX   call    ccaller         ; call common interface
;                       dq      zysxx           ; dd      of C OSINT function
;                       db      n               ; offset to instruction after
;                                               ;   last procedure exit

;       In an effort to achieve portability of C OSINT functions, we
;       do not take take advantage of any "internal" to "external"
;       transformation of names by C compilers.  So, a C OSINT function
;       representing sysxx is named _zysxx.  This renaming should satisfy
;       all C compilers.

;       IMPORTANT  ONE interface routine, SYSFC, is passed arguments on
;       the stack.  These items are removed from the stack before calling
;       ccaller, as they are not needed by this implementation.


;-----------

;       CCALLER is called by the OS interface routines to call the
;       real C OS interface function.

;       General calling sequence is

;               call    ccaller
;               dq      address_of_C_function
;               db      2*number_of_exit_points

;       Control IS NEVER returned to a interface routine.  Instead, control
;       is returned to the compiler (THE caller of the interface routine).

;       The C function that is called MUST ALWAYS return an integer
;       indicating the procedure exit to take or that a normal return
;       is to be performed.

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


	segment	.data
call_adr:	dq	0
	segment	.text

syscall_init:
;       save registers in global variables

        mov     qword [reg_wa],WA              ; save registers
	mov	qword [reg_wb],WB
        mov     qword [reg_wc],WC
	mov	qword [reg_xr],XR
	mov	qword [reg_xl],XL
	ret

syscall_exit:
	mov	qword [_rc_],W0		; save return code from function
 	mov     qword [osisp],rsp               ; save OSINT's stack pointer
        mov     rsp,qword [compsp]              ; restore compiler's stack pointer
        mov     WA,qword [reg_wa]              ; restore registers
	mov	WB,qword [reg_wb]
        mov     WC,qword [reg_wc]              ; (also reg_ia)
	mov	XR,qword [reg_xr]
	mov	XL,qword [reg_xl]
	cld
	mov	W0,qword [reg_pc]
	jmp	W0
	
	%macro	syscall	2
        pop     W0                     ; pop return address
	mov	qword [reg_pc],W0
	call	syscall_init
;       save compiler stack and switch to OSINT stack
        mov     qword [compsp],rsp              ; save compiler's stack pointer
        mov     rsp,qword [osisp]               ; load OSINT's stack pointer
	call	%1
	jmp	syscall_exit
	%endmacro

        global sysax
	extern	zysax
sysax:	syscall	  zysax,1

        global sysbs
	extern	zysbs
sysbs:	syscall	  zysbs,2

        global sysbx
	extern	zysbx
sysbx:	mov	qword [reg_xs],rsp
	syscall	zysbx,2

;        global syscr
;	extern	zyscr
;syscr:  syscall    zyscr ;    ,0
;
        global sysdc
	extern	zysdc
sysdc:	syscall	zysdc,4

        global sysdm
	extern	zysdm
sysdm:	syscall	zysdm,5

        global sysdt
	extern	zysdt
sysdt:	syscall	zysdt,6

        global sysea
	extern	zysea
sysea:	syscall	zysea,7

        global sysef
	extern	zysef
sysef:	syscall	zysef,8

        global sysej
	extern	zysej
sysej:	syscall	zysej,9

        global sysem
	extern	zysem
sysem:	syscall	zysem,10

        global sysen
	extern	zysen
sysen:	syscall	zysen,11

        global sysep
	extern	zysep
sysep:	syscall	zysep,12

        global sysex
	extern	zysex
sysex:	mov	qword [reg_xs],rsp
	syscall	zysex,13

        global sysfc
	extern	zysfc
sysfc:  pop     W0             ; <<<<remove stacked SCBLK>>>>
	lea	rsp,[rsp+WC*4]
	push	W0
	syscall	zysfc,14

        global sysgc
	extern	zysgc
sysgc:	syscall	zysgc,15

        global syshs
	extern	zyshs
syshs:	mov	qword [reg_xs],rsp
	syscall	zyshs,16

        global sysid
	extern	zysid
sysid:	syscall	zysid,17

        global sysif
	extern	zysif
sysif:	syscall	zysif,18

        global sysil
	extern	zysil
sysil:  syscall zysil,19

        global sysin
	extern	zysin
sysin:	syscall	zysin,20

        global sysio
	extern	zysio
sysio:	syscall	zysio,21

        global sysld
	extern	zysld
sysld:  syscall zysld,22

        global sysmm
	extern	zysmm
sysmm:	syscall	zysmm,23

        global sysmx
	extern	zysmx
sysmx:	syscall	zysmx,24

        global sysou
	extern	zysou
sysou:	syscall	zysou,25

        global syspi
	extern	zyspi
syspi:	syscall	zyspi,26

        global syspl
	extern	zyspl
syspl:	syscall	zyspl,27

        global syspp
	extern	zyspp
syspp:	syscall	zyspp,28

        global syspr
	extern	zyspr
syspr:	syscall	zyspr,29

        global sysrd
	extern	zysrd
sysrd:	syscall	zysrd,30

        global sysri
	extern	zysri
sysri:	syscall	zysri,32

        global sysrw
	extern	zysrw
sysrw:	syscall	zysrw,33

        global sysst
	extern	zysst
sysst:	syscall	zysst,34

        global systm
	extern	zystm
systm:	syscall	zystm,35

        global systt
	extern	zystt
systt:	syscall	zystt,36

        global sysul
	extern	zysul
sysul:	syscall	zysul,37

        global sysxi
	extern	zysxi
sysxi:	mov	qword [reg_xs],rsp
	syscall	zysxi,38
;---------------

;       Individual OSINT routine entry points

; SPITBOL math routine interface 

	%macro	callext	2
	extern	%1
	call	%1
	add	rsp,%2	; pop arguments
	%endmacro


;-----------
;
;       cvd_ - convert by division
;
;       input   ia (edx) = number <=0 to convert
;       output  ia / 10
;               wa (ecx) = remainder + '0'
;
        global  cvd_

cvd_:
        xchg    W0,WC         ; ia to W0
        cdq                     ; sign extend
        idiv    qword [ten]   ; divide by 10. IA = remainder (negative)
        neg     IA             ; make remainder positive
        add     dl,0x30         ; convert remainder to ascii ('0')
        mov     WA,IA         ; return remainder in wa
        xchg    IA,W0         ; return quotient in ia
	ret

;
;-----------
;
;       dvi_ - divide ia (edx) by long in W0
;
        global  dvi_

dvi_:
        or      W0,W0         ; test for 0
        jz      setovr    	; jump if 0 divisor
        push    XR             ; preserve cp
        xchg    XR,W0         ; divisor to XR
        xchg    W0,IA         ; dividend in W0
        cdq                     ; extend dividend
        idiv    XR             ; perform division. W0=quotient, IA=remainder
        xchg    IA,W0         ; place quotient in IA (ia)
        pop     XR             ; restore cp
        xor     W0,W0         ; clear overflow indicator
	ret


;
;-----------
;
;       rmi_ - remainder of ia (edx) divided by long in W0
;
        global  rmi_
rmi_:
        or      W0,W0         ; test for 0
        jz      setovr    ; jump if 0 divisor
        push    XR             ; preserve cp
        xchg    XR,W0         ; divisor to XR
        xchg    W0,IA         ; dividend in W0
        cdq                     ; extend dividend
        idiv    XR             ; perform division. W0=quotient, IA=remainder
        pop     XR             ; restore cp
        xor     W0,W0         ; clear overflow indicator
        ret                     ; return remainder in IA (ia)
setovr: mov     al,0x80         ; set overflow indicator
	dec	al
	ret



;----------
;
;    calls to c
;
;       the calling convention of the various compilers:
;
;       integer results returned in W0.
;       float results returned in st0 for intel.
;       see conditional switches fretst0 and
;       fretW0.
;
;       c function preserves ebp, ebx, esi, edi.
;

; define how floating point results are returned from a function
; (either in st(0) or in edx:W0.
%define fretst0 1
%define fretW0 0

;----------
;
;       rti_ - convert real in ra to integer in ia
;               returns c=0 if fit ok, c=1 if too large to convert
;
        global  rti_
rti_:
; 41e00000 00000000 = 2147483648.0
; 41e00000 00200000 = 2147483649.0
        mov     W0, qword [reg_ra+4]  ; ra msh
        btr     W0,31          ; take absolute value, sign bit to carry flag
        jc      rti_2     ; jump if negative real
        cmp     W0,0x41e00000  ; test against 2147483648
        jae     rti_1     ; jump if >= +2147483648
rti_3:  push    WA             ; protect against c routine usage.
        push    W0             ; push ra msh
        push    qword [reg_ra]  ; push ra lsh
        callext f_2_i,8         ; float to integer
        xchg    W0,IA         ; return integer in IA (ia)
        pop     WA             ; restore WA
        clc
	ret

; here to test negative number, made positive by the btr instruction
rti_2:  cmp     W0,0x41e00000          ; test against 2147483649
        jb      rti_0             ; definately smaller
        ja      rti_1             ; definately larger
        cmp     word [reg_ra+2], 0x0020
        jae     rti_1
rti_0:  btc     W0,31                  ; make negative again
        jmp     rti_3
rti_1:  stc                             ; return c=1 for too large to convert
        ret

;
;----------
;
;       itr_ - convert integer in ia to real in ra
;
        global  itr_
itr_:

        push    WA             ; preserve
        push    IA             ; push ia
        callext i_2_f,4         ; integer to float
%if fretst0
	fstp	qword [reg_ra]
        pop     WA             ; restore WA
	fwait
%endif
%if fretW0
        mov     qword [reg_ra,W0    ; return result in ra
	mov	qword [reg_ra+4,IA
        pop     WA             ; restore WA
%endif
	ret

;
;----------
;
;       ldr_ - load real pointed to by W0 to ra
;
        global  ldr_
ldr_:

        push    qword [W0]                 ; lsh
	pop	qword [reg_ra]
        mov     W0,[W0+4]                     ; msh
	mov	qword [reg_ra+4], W0
	ret

;
;----------
;
;       str_ - store ra in real pointed to by W0
;
        global  str_
str_:

        push    qword [reg_ra]               ; lsh
	pop	qword [W0]
        push    qword [reg_ra+4]              ; msh
	pop	qword [W0+4]
	ret

;
;----------
;
;       adr_ - add real at [W0] to ra
;
        global  adr_
adr_:

        push    WA                             ; preserve regs for c
	push	WC
        push    qword [reg_ra+4]             ; ra msh
        push    qword [reg_ra]               ; ra lsh
        push    qword [W0+4]               ; arg msh
        push    qword [W0]                 ; arg lsh
        callext f_add,16                        ; perform op
%if fretst0
	fstp	qword [reg_ra]
        pop     WC                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     qword [reg_ra+4], WC         ; result msh
        mov     qword [reg_ra], W0           ; result lsh
        pop     WC                             ; restore regs
	pop	WA
%endif
	ret

;
;----------
;
;       sbr_ - subtract real at [W0] from ra
;
        global  sbr_

sbr_:
        push    WA                             ; preserve regs for c
	push	WC
        push    qword [reg_ra+4]             ; ra msh
        push    qword [reg_ra]               ; ra lsh
        push    qword [W0+4]               ; arg msh
        push    qword [W0]                 ; arg lsh
        callext f_sub,16                        ; perform op
%if fretst0
	fstp	qword [reg_ra]
        pop     WC                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     qword [reg_ra+4], WC         ; result msh
        mov     qword [reg_ra], W0           ; result lsh
        pop     WC                             ; restore regs
	pop	WA
%endif
	ret

;
;----------
;
;       mlr_ - multiply real in ra by real at [W0]
;
        global  mlr_

mlr_:
        push    WA                             ; preserve regs for c
	push	WC
        push    qword [reg_ra+4]              ; ra msh
        push    qword [reg_ra]                ; ra lsh
        push    qword [W0+4]               ; arg msh
        push    qword [W0]                 ; arg lsh
        callext f_mul,16                        ; perform op
%if fretst0
	fstp	qword [reg_ra]
        pop     WC                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     qword [reg_ra+4], WC         ; result msh
        mov     qword [reg_ra], W0           ; result lsh
        pop     WC                             ; restore regs
	pop	WA
%endif
	ret

;
;----------
;
;       dvr_ - divide real in ra by real at [W0]
;
        global  dvr_

dvr_:
        push    WA                             ; preserve regs for c
	push	WC
        push    qword [reg_ra+4]              ; ra msh
        push    qword [reg_ra]                ; ra lsh
        push    qword [W0+4]               ; arg msh
        push    qword [W0]                 ; arg lsh
        callext f_div,16                        ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     WC                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     qword [reg_ra+4], WC         ; result msh
        mov     qword [reg_ra], W0           ; result lsh
        pop     WC                             ; restore regs
	pop	WA
%endif
	ret

;
;----------
;
;       ngr_ - negate real in ra
;
        global  ngr_

ngr_:
	cmp	qword [reg_ra], 0
	jne	ngr_1
	cmp	qword [reg_ra+4], 0
        je      ngr_2                     ; if zero, leave alone
ngr_1:  xor     byte [reg_ra+7], 0x80         ; complement mantissa sign
ngr_2:	ret

;
;----------
;
;       atn_ arctangent of real in ra
;
        global  atn_

atn_:
        push    WA                             ; preserve regs for c
	push	WC
        push    qword [reg_ra+4]              ; ra msh
        push    qword [reg_ra]                ; ra lsh
        callext f_atn,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     WC                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     qword [reg_ra+4], WC         ; result msh
        mov     qword [reg_ra], W0           ; result lsh
        pop     WC                             ; restore regs
	pop	WA
%endif
	ret

;
;----------
;
;       chp_ chop fractional part of real in ra
;
        global  chp_


chp_:
        push    WA                             ; preserve regs for c
	push	WC
        push    qword [reg_ra+4]              ; ra msh
        push    qword [reg_ra]                ; ra lsh
        callext f_chp,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     WC                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     qword [reg_ra+4], WC         ; result msh
        mov     qword [reg_ra], W0           ; result lsh
        pop     WC                             ; restore regs
	pop	WA
%endif
	ret

;
;----------
;
;       cos_ cosine of real in ra
;
        global  cos_

cos_:
        push    WA                             ; preserve regs for c
	push	WC
        push    qword [reg_ra+4]              ; ra msh
        push    qword [reg_ra]                ; ra lsh
        callext f_cos,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     WC                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     qword [reg_ra+4], WC         ; result msh
        mov     qword [reg_ra], W0           ; result lsh
        pop     WC                             ; restore regs
	pop	WA
%endif
	ret

;
;----------
;
;       etx_ exponential of real in ra
;
        global  etx_

etx_:
        push    WA                             ; preserve regs for c
	push	WC
        push    qword [reg_ra+4]              ; ra msh
        push    qword [reg_ra]                ; ra lsh
        callext f_etx,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     WC                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     qword [reg_ra+4], WC         ; result msh
        mov     qword [reg_ra], W0           ; result lsh
        pop     WC                             ; restore regs
	pop	WA
%endif
	ret

;
;----------
;
;       lnf_ natural logarithm of real in ra
;
        global  lnf_

lnf_:
        push    WA                             ; preserve regs for c
	push	WC
        push    qword [reg_ra+4]              ; ra msh
        push    qword [reg_ra]                ; ra lsh
        callext f_lnf,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     WC                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     qword [reg_ra+4], WC         ; result msh
        mov     qword [reg_ra], W0           ; result lsh
        pop     WC                             ; restore regs
	pop	WA
%endif
	ret

;
;----------
;
;       sin_ arctangent of real in ra
;
        global  sin_

sin_:

        push    WA                             ; preserve regs for c
	push	WC
        push    qword [reg_ra+4]              ; ra msh
        push    qword [reg_ra]               ; ra lsh
        callext f_sin,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     WC                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     qword [reg_ra+4], WC         ; result msh
        mov     qword [reg_ra], W0           ; result lsh
        pop     WC                             ; restore regs
	pop	WA
%endif
	ret

;
;----------
;
;       sqr_ arctangent of real in ra
;
        global  sqr_

sqr_:
        push    WA                             ; preserve regs for c
	push	WC
        push    qword [reg_ra+4]              ; ra msh
        push    qword [reg_ra]                ; ra lsh
        callext f_sqr,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     WC                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     qword [reg_ra+4], WC         ; result msh
        mov     qword [reg_ra], W0           ; result lsh
        pop     WC                             ; restore regs
	pop	WA
%endif
	ret
;
;----------
;
;       tan_ arctangent of real in ra
;
        global  tan_

tan_:
        push    WA                             ; preserve regs for c
	push	WC
        push    qword [reg_ra+4]              ; ra msh
        push    qword [reg_ra]                ; ra lsh
        callext f_tan,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     WC                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     qword [reg_ra+4], WC         ; result msh
        mov     qword [reg_ra], W0           ; result lsh
        pop     WC                             ; restore regs
	pop	WA
%endif
	ret

;
;----------
;
;       cpr_ compare real in ra to 0
;
        global  cpr_
cpr_:
        mov     W0, qword [reg_ra+4] ; fetch msh
; DS Need to fix next line, won't assemble for x64.
;        cmp     W0, 0x8000000000000000         ; test msh for -0.0
        je      cpr050            ; possibly
        or      W0, W0                ; test msh for +0.0
        jnz     cpr100            ; exit if non-zero for cc's set
cpr050: cmp     qword [reg_ra], 0     ; true zero, or denormalized number?
        jz      cpr100            ; exit if true zero
	mov	al, 1
        cmp     al, 0                   ; positive denormal, set cc
cpr100:	ret


;----------
;
;       ovr_ test for overflow value in ra

	global	ovr_

ovr_:
        mov     ax, word [reg_ra+6]   ; get top 2 bytes
        and     ax, 0x7ff0              ; check for infinity or nan
        add     ax, 0x10                ; set/clear overflow accordingly
	ret





;  tryfpu - perform a floating point op to trigger a trap if no floating point hardware.

	global	tryfpu
tryfpu:
	push	rbp
	fldz
	pop	rbp
	ret


; # procedures needed for save file / load module support -- debug later
; 
; #
; #-----------
; #
; #       get_fp  - get C caller's FP (frame pointer)
; #
; #       get_fp() returns the frame pointer for the C function that called
; #       this function.  HOWEVER, THIS FUNCTION IS ONLY CALLED BY ZYSXI.
; #
; #       C function zysxi calls this function to determine the lowest USEFUL
; #       word on the stack, so that only the useful part of the stack will be
; #       saved in the load module.
; #
; #       The flow goes like this:
; #
; #       (1) User's spitbol program calls EXIT function
; #
; #       (2) spitbol compiler calls interface routine sysxi to handle exit
; #
; #       (3) Interface routine sysxi passes control to ccaller which then
; #           calls C function zysxi
; #
; #       (4) C function zysxi will write a load module, but needs to save
; #           a copy of the current stack in the load module.  The base of
; #           the part of the stack to be saved begins with the frame of our
; #           caller, so that the load module can execute a return to ccaller.
; #
; #           This will allow the load module to pretend to be returning from
; #           C function zysxi.  So, C function zysxi calls this function,
; #           get_fp, to determine the BASE OF THE USEFUL PART OF THE STACK.
; #
; #           We cheat just a little bit here.  C function zysxi can (and does)
; #           have local variables, but we won't save them in the load module.
; #           Only the portion of the frame established by the 80386 call
; #           instruction, from BP up, is saved.  These local variables
; #           aren't needed, because the load module will not be going back
; #           to C function zysxi.  Instead when function restart returns, it
; #           will act as if C function zysxi is returning.
; #
; #       (5) After writing the load module, C function zysxi calls C function
; #           zysej to terminate spitbol's execution.
; #
; #       (6) When the resulting load module is executed, C function main
; #           calls function restart.  Function restart restores the stack
; #           and then does a return.  This return will act as if it is
; #           C function zysxi doing the return and the user's program will
; #           continue execution following its call to EXIT.
; #
; #       On entry to _get_fp, the stack looks like
; #
; #               /      ...      /
; #       (high)  |               |
; #               |---------------|
; #       ZYSXI   |    old PC     |  --> return point in CCALLER
; #         +     |---------------|  USEFUL part of stack
; #       frame   |    old BP     |  <<<<-- BP of get_fp's caller
; #               |---------------|     -
; #               |     ZYSXI's   |     -
; #               /     locals    /     - NON-USEFUL part of stack
; #               |               |     ------
; #       ======= |---------------|
; #       SP-->   |    old PC     |  --> return PC in C function ZYSXI
; #       (low)   +---------------+
; #
; #       On exit, return EBP in EAX. This is the lower limit on the
; #       size of the stack.
; 
; 
;         cproc    get_fp,near
; 	pubname	get_fp
; 
;         mov     W0,reg_xs      # Minimal's XS
;         add     W0,4           # pop return from call to SYSBX or SYSXI
;         retc    0               # done
; 
;         cendp    get_fp
; 
; #
; #-----------
; #
; #       restart - restart for load module
; #
; #       restart( char *dummy, char *stackbase ) - startup compiler
; #
; #       The OSINT main function calls restart when resuming execution
; #       of a program from a load module.  The OSINT main function has
; #       reset global variables except for the stack and any associated
; #       variables.
; #
; #       Before restoring stack, set up values for proper checking of
; #       stack overflow. (initial sp here will most likely differ
; #       from initial sp when compile was done.)
; #
; #       It is also necessary to relocate any addresses in the the stack
; #       that point within the stack itself.  An adjustment factor is
; #       calculated as the difference between the STBAS at exit() time,
; #       and STBAS at restart() time.  As the stack is transferred from
; #       TSCBLK to the active stack, each word is inspected to see if it
; #       points within the old stack boundaries.  If so, the adjustment
; #       factor is subtracted from it.
; #
; #       We use Minimal's INSTA routine to initialize static variables
; #       not saved in the Save file.  These values were not saved so as
; #       to minimize the size of the Save file.
; #
; 	ext	rereloc,near
; 
;         cproc   restart,near
; 	pubname	restart
; 
;         pop     W0                     # discard return
;         pop     W0                     # discard dummy
;         pop     W0                     # get lowest legal stack value
; 
;         add     W0,stacksiz            # top of compiler's stack
;         mov     esp,W0                 # switch to this stack
; 	call	stackinit               # initialize MINIMAL stack
; 
;                                         # set up for stack relocation
;         lea     W0,TSCBLK+scstr        # top of saved stack
;         mov     ebx,lmodstk             # bottom of saved stack
;         GETMIN  ecx,STBAS               # ecx = stbas from exit() time
;         sub     ebx,W0                 # ebx = size of saved stack
; 	mov	edx,ecx
;         sub     edx,ebx                 # edx = stack bottom from exit() time
; 	mov	ebx,ecx
;         sub     ebx,esp                 # ebx = old stbas - new stbas
; 
;         SETMINR  STBAS,esp               # save initial sp
; #        GETOFF  W0,DFFNC               # get address of PPM offset
;         mov     ppoff,W0               # save for use later
; #
; #       restore stack from TSCBLK.
; #
;         mov     esi,lmodstk             # -> bottom word of stack in TSCBLK
;         lea     edi,TSCBLK+scstr        # -> top word of stack
;         cmp     esi,edi                 # Any stack to transfer?
;         je      short re3               #  skip if not
; 	sub	esi,4
; 	std
; re1:    lodsd                           # get old stack word to rax
;         cmp     W0,edx                 # below old stack bottom?
;         jb      short re2               #   j. if rax < edx
;         cmp     W0,ecx                 # above old stack top?
;         ja      short re2               #   j. if rax > ecx
;         sub     W0,ebx                 # within old stack, perform relocation
; re2:    push    W0                     # transfer word of stack
;         cmp     esi,edi                 # if not at end of relocation then
;         jae     re1                     #    loop back
; 
; re3:	cld
;         mov     compsp,esp              # 1.39 save compiler's stack pointer
;         mov     esp,osisp               # 1.39 back to OSINT's stack pointer
;         callc   rereloc,0               # V1.08 relocate compiler pointers into stack
;         GETMIN  W0,STATB               # V1.34 start of static region to XR
; 	SET_XR  W0
;         MINIMAL INSTA                   # V1.34 initialize static region
; 
; #
; #       Now pretend that we're executing the following C statement from
; #       function zysxi:
; #
; #               return  NORMAL_RETURN#
; #
; #       If the load module was invoked by EXIT(), the return path is
; #       as follows:  back to ccaller, back to S$EXT following SYSXI call,
; #       back to user program following EXIT() call.
; #
; #       Alternately, the user specified -w as a command line option, and
; #       SYSBX called MAKEEXEC, which in turn called SYSXI.  The return path
; #       should be:  back to ccaller, back to MAKEEXEC following SYSXI call,
; #       back to SYSBX, back to MINIMAL code.  If we allowed this to happen,
; #       then it would require that stacked return address to SYSBX still be
; #       valid, which may not be true if some of the C programs have changed
; #       size.  Instead, we clear the stack and execute the restart code that
; #       simulates resumption just past the SYSBX call in the MINIMAL code.
; #       We distinguish this case by noting the variable STAGE is 4.
; #
;         callc   startbrk,0              # start control-C logic
; 
;         GETMIN  W0,STAGE               # is this a -w call?
; 	cmp	W0,4
;         je      short re4               # yes, do a complete fudge
; 
; #
; #       Jump back to cc1 with return value = NORMAL_RETURN
; 	mov	W0,-1
;         jmp     cc1                     # jump back
; 
; #       Here if -w produced load module.  simulate all the code that
; #       would occur if we naively returned to sysbx.  Clear the stack and
; #       go for it.
; #
; re4:	GETMIN	W0,STBAS
;         mov     compsp,W0              # 1.39 empty the stack
; 
; #       Code that would be executed if we had returned to makeexec:
; #
;         SETMIN  GBCNT,0                 # reset garbage collect count
;         callc   zystm,0                 # Fetch execution time to reg_ia
;         mov     W0,reg_ia              # Set time into compiler
; 	SETMINR	TIMSX,W0
; 
; #       Code that would be executed if we returned to sysbx:
; #
;         push    outptr                  # swcoup(outptr)
; 	callc	swcoup,4
; 
; #       Jump to Minimal code to restart a save file.
; 
;         MINIMAL RSTRT                   # no return
; 
;         cendp    restart
; 
