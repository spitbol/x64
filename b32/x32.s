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

	%include	"x32.h"
;	CFP_B gives bytes per word, CFP_C gives characters per word
	%define CFP_B	4
	%define CFP_C	4

	global	reg_block
	global	reg_wa
	global	reg_wb
	global	reg_ia
	global	reg_wc
	global	reg_xr
	global	reg_xl
	global	reg_cp
	global	reg_ra
	global	reg_pc
	global	reg_xs
	global	reg_size

 	global	minimal
	extern	calltab
	extern	stacksiz
 
%define globals 1                       ;ASM globals defined here


;       ---------------------------------------

;       This file contains the assembly language routines that interface
;       the Macro SPITBOL compiler written in 80386 assembly language to its
;       operating system interface functions written in C.

;       Contents:

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

;       Overview

;       The Macro SPITBOL compiler relies on a set of operating system
;       interface functions to provide all interaction with the host
;       operating system.  These functions are referred to as OSINT
;       functions.  A typical call to one of these OSINT functions takes
;       the following form in the 80386 version of the compiler:

;               ...code to put arguments in registers...
;               call    SYSXX           # call osint function
;             D_WORD    EXIT_1          # address of exit point 1
;             D_WORD    EXIT_2          # address of exit point 2
;               ...     ...             # ...
;             D_WORD    EXIT_n          # address of exit point n
;               ...instruction following call...

;       The OSINT function 'SYSXX' can then return in one of n+1 ways:
;       to one of the n exit points or to the instruction following the
;       last exit.  This is not really very complicated - the call places
;       the return address on the stack, so all the interface function has
;       to do is add the appropriate offset to the return address and then
;       pick up the exit address and jump to it OR do a normal return via
;       an ret instruction.

;       Unfortunately, a C function cannot handle this scheme.  So, an
;       intermediary set of routines have been established to allow the
;       interfacing of C functions.  The mechanism is as follows:

;       (1) The compiler calls OSINT functions as described above.

;       (2) A set of assembly language interface routines is established,
;           one per OSINT function, named accordingly.  Each interface
;           routine ...

;           (a) saves all compiler registers in global variables
;               accessible by C functions
;           (b) calls the OSINT function written in C
;           (c) restores all compiler registers from the global variables
;           (d) inspects the OSINT function's return value to determine
;               which of the n+1 returns should be taken and does so

;       (3) A set of C language OSINT functions is established, one per
;           OSINT function, named differently than the interface routines.
;           Each OSINT function can access compiler registers via global
;           variables.  NO arguments are passed via the call.

;           When an OSINT function returns, it must return a value indicating
;           which of the n+1 exits should be taken.  These return values are
;           defined in header file 'inter.h'.

;       Note:  in the actual implementation below, the saving and restoring
;       of registers is actually done in one common routine accessed by all
;       interface routines.

;       Other notes:

;       Some C ompilers transform "internal" global names to
;       "external" global names by adding a leading underscore at the front
;       of the internal name.  Thus, the function name 'osopen' becomes
;       '_osopen'.  However, not all C compilers follow this convention.

;       Global Variables

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
; ;
        align CFP_B
	extern	MINCP
reg_block:
reg_wa:	D_WORD	0        ; Register WA (ECX)
reg_wb:	D_WORD 	0        ; Register WB (EBX)
reg_ia:
reg_wc:	D_WORD	0		; Register WC & IA (EDX)
reg_xr:	D_WORD	0        ; Register XR (XR)
reg_xl:	D_WORD	0        ; Register XL (XL)
reg_cp:	D_WORD	0        ; Register CP
reg_ra	dq 	0.0  ; Register RA

; These locations save information needed to return after calling OSINT
; and after a restart from EXIT()

reg_pc: dd      0               ; return PC from caller
reg_xs:	D_WORD	0;		 Minimal stack pointer

;	r_size  equ       $-reg_block
; use computed value for nasm conversion, put back proper code later
r_size	equ	10*CFP_B
reg_size:	dd   r_size


; end of words saved during exit(-3)



;  Constants

	global	ten
ten:    D_WORD      10              ; constant 10
        global  inf
inf:	D_WORD	0   
        D_WORD      0x7ff00000      ; double precision infinity

	global	sav_block
;sav_block: times r_size db 0     ; Save Minimal registers during push/pop reg
sav_block: times 44 db 0     ; Save Minimal registers during push/pop reg

        align CFP_B
	global	ppoff
ppoff:  D_WORD      0               ; offset for ppm exits
	global	compsp
compsp: D_WORD      0               ; 1.39 compiler's stack pointer
	global	sav_compsp
sav_compsp:
        D_WORD      0               ; save compsp here
	global	osisp
osisp:  D_WORD      0               ; 1.39 OSINT's stack pointer
	global	_rc_
_rc_:	dd   0	; return code from osint procedure



	global	save_cp
	global	save_xl
	global	save_xr
	global	save_xs
	global	save_wa
	global	save_wb
	global	save_wc
	global	save_w0
save_cp:	D_WORD	0	; saved CP value
save_xl:	D_WORD	0	; saved XL value
save_xr:	D_WORD	0	; saved XR value
save_xs:	D_WORD	0	; saved SP value
save_wa:	D_WORD	0	; saved WA value
save_wb:	D_WORD	0	; saved WB value
save_wc:	D_WORD	0	; saved WC value
save_w0:	D_WORD	0	; saved W0 value

minimal_id:	D_WORD	0	; id for call to minimal from C. See proc minimal below.

; 
%define SETREAL 0

;       Setup a number of internal addresses in the compiler that cannot
;       be directly accessed from within C because of naming difficulties.

        global  ID1
ID1:	dd   0
%if SETREAL == 1
        D_WORD       2

       D_WORD       1
        db  "1x\x00\x00\x00"
%endif

        global  ID2BLK
ID2BLK	D_WORD   52
      D_WORD    0
        times   52 db 0

        global  TICBLK
TICBLK:	D_WORD   0
      D_WORD    0

        global  TSCBLK
TSCBLK:	 D_WORD   512
      D_WORD    0
        times   512 db 0


;       Standard input buffer block.

        global  INPBUF
INPBUF:	D_WORD	0		; type word
      D_WORD    0               ; block length
      D_WORD    1024            ; buffer size
      D_WORD    0               ; remaining chars to read
      D_WORD    0               ; offset to next character to read
      D_WORD    0               ; file position of buffer
      D_WORD    0               ; physical position in file
        times   1024 db 0        ; buffer

        global  TTYBUF
TTYBUF:	D_WORD    0     ; type word
      	D_WORD    0               ; block length
      	D_WORD    260             ; buffer size  (260 OK in MS-DOS with cinread())
      	D_WORD    0               ; remaining chars to read
      	D_WORD    0               ; offset to next char to read
      	D_WORD    0               ; file position of buffer
      	D_WORD    0               ; physical position in file
        times   260 db 0         ; buffer
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
; 	pushad
; 	lea	XL,[reg_block]
; 	lea	XR,[sav_block]
; 	mov	WA,r_size/4
; 	cld
;    rep	movsd
; 
;         mov     XR,M_WORD [compsp]
;         or      XR,XR                         ; 1.39 is there a compiler stack
;         je      push1                     ; 1.39 jump if none yet
;         sub     XR,4                           ;push onto compiler's stack
;         mov     XL,M_WORD [reg_xl]                      ;collectable XL
; 	mov	[XR],XL
;         mov     M_WORD [compsp],XR                      ;smashed if call OSINT again (SYSGC)
;         mov     M_WORD [sav_compsp],XR                  ;used by popregs
; 
; push1:	popad
; 	ret
; 
; 	global	popregs
; popregs:
; 	pushad
;         mov     W0,M_WORD [reg_cp]                      ;don't restore CP
; 	cld
; 	lea	XL,[sav_block]
;         lea     XR,[reg_block]                   ;unload saved registers
; 	mov	WA,r_size/4
;    rep  movsd                                   ;restore from temp area
; 	mov	M_WORD [reg_cp],W0
; 
;         mov     XR,M_WORD [sav_compsp]                  ;saved compiler's stack
;         or      XR,XR                         ;1.39 is there one?
;         je      pop1                      ;1.39 jump if none yet
;         mov     XL,M_WORD [XR]                       ;retrieve collectable XL
;         mov     M_WORD [reg_xl],XL                      ;update XL
;         add     XR,CFP_B                           ;update compiler's sp
;         mov     M_WORD [compsp],XR
; 
; pop1:	popad
; 	ret
	global	save_regs
save_regs:
	mov	M_WORD [save_cp],WA
	mov	M_WORD [save_xl],XL
	mov	M_WORD [save_xr],XR
	mov	M_WORD [save_xs],XS
	mov	M_WORD [save_wa],WA
	mov	M_WORD [save_wb],WB
	mov	M_WORD [save_wc],WC
	mov	M_WORD [save_w0],W0
	ret

	global	restore_regs
restore_regs:
	;	Restore regs, except for SP. That is caller's responsibility
	mov	XL,M_WORD [save_xl]
	mov	XR,M_WORD [save_xr]
;	mov	XS,M_WORD [save_xs	; caller restores SP]
	mov	WA,M_WORD [save_cp]
	mov	WA,M_WORD [save_wa]
	mov	WB,M_WORD [save_wb]
	mov	WC,M_WORD [save_wc]
	mov	W0,M_WORD [save_w0]
	ret
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

;   The order of entries here must correspond to the order of
;   calltab entries in the INTER assembly language module.

CALLTAB_RELAJ equ   0
CALLTAB_RELCR equ   1
CALLTAB_RELOC equ   2
CALLTAB_ALLOC equ   3
CALLTAB_ALOCS equ   4
CALLTAB_ALOST equ   5
CALLTAB_BLKLN equ   6
CALLTAB_INSTA equ   7
CALLTAB_RSTRT equ   8
CALLTAB_START equ   9
CALLTAB_FILNM equ   10
CALLTAB_DTYPE equ   11
CALLTAB_ENEVS equ   12
CALLTAB_ENGTS equ   13


startup:
        pop     W0                     ; discard return
        pop     W0                     ; discard dummy1
        pop     W0                     ; discard dummy2
	call	stackinit               ; initialize MINIMAL stack
        mov     W0,M_WORD [compsp]              ; get MINIMAL's stack pointer
        mov M_WORD [reg_wa],W0                     ; startup stack pointer

	cld                             ; default to UP direction for string ops
;        GETOFF  W0,DFFNC               # get address of PPM offset
        mov     M_WORD [ppoff],W0               ; save for use later

        mov     XS,M_WORD [osisp]               ; switch to new C stack
	push	CALLTAB_START
	call	minimal			; load regs, switch stack, start compiler

;	stackinit  -- initialize LOWSPMIN from sp.

;	Input:  sp - current C stack
;		stacksiz - size of desired Minimal stack in bytes

;	Uses:	W0

;	Output: register WA, sp, LOWSPMIN, compsp, osisp set up per diagram:

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




	global	stackinit
stackinit:
	mov	W0,XS
        mov     M_WORD [compsp],W0              ; save as MINIMAL's stack pointer
	sub	W0,M_WORD [stacksiz]            ; end of MINIMAL stack is where C stack will start
        mov     M_WORD [osisp],W0               ; save new C stack pointer
	add	W0,CFP_B*100               ; 100 words smaller for CHK
	extern	LOWSPMIN
	mov	M_WORD [LOWSPMIN],W0
	ret

;       mimimal -- call MINIMAL function from C

;       Usage:  extern void minimal(WORD callno)

;       where:
;         callno is an ordinal defined in osint.h, osint.inc, and calltab.

;       Minimal registers WA, WB, WC, XR, and XL are loaded and
;       saved from/to the register block.

;       Note that before restart is called, we do not yet have compiler
;       stack to switch to.  In that case, just make the call on the
;       the OSINT stack.


 minimal:
         pushad                          ; save all registers for C
	mov     W0,M_WORD [XS+32+4]          ; get ordinal
        mov     WA,M_WORD [reg_wa]              ; restore registers
	mov	WB,M_WORD [reg_wb]
        mov     WC,M_WORD [reg_wc]              ; (also _reg_ia)
 	mov	XR,M_WORD [reg_xr]
 	mov	XL,M_WORD [reg_xl]
 	mov	CP,M_WORD [reg_cp]
 
        mov     M_WORD [osisp],XS               ; 1.39 save OSINT stack pointer
        cmp     M_WORD [compsp],0      ; 1.39 is there a compiler stack?
        je      min1              ; 1.39 jump if none yet
        mov     XS,M_WORD [compsp]              ; 1.39 switch to compiler stack
 
 min1:  call   M_WORD [calltab+W0*4]        ; off to the Minimal code
 
        mov     XS,M_WORD [osisp]               ; 1.39 switch to OSINT stack
 
        mov     M_WORD [reg_wa],WA              ; save registers
 	mov	M_WORD [reg_wb],WB
 	mov	M_WORD [reg_wc],WC
 	mov	M_WORD [reg_xr],XR
 	mov	M_WORD [reg_xl],XL
 	mov	M_WORD [reg_cp],CP
 	popad
 	ret
 
 
        section		.data
        align         CFP_B
	global	hasfpu
hasfpu:	D_WORD	0
	global	cprtmsg
cprtmsg:
	db          ' Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.',0,0


;       Interface routines

;       Each interface routine takes the following form:

;               SYSXX   call    ccaller         ; call common interface
;                     D_WORD    zysxx           ; dd      of C OSINT function
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

;       CCALLER is called by the OS interface routines to call the
;       real C OS interface function.

;       General calling sequence is

;               call    ccaller
;             D_WORD    address_of_C_function
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
call_adr:	D_WORD	0
	segment	.text

syscall_init:
;       save registers in global variables

        mov     M_WORD [reg_wa],WA              ; save registers
	mov	M_WORD [reg_wb],WB
        mov     M_WORD [reg_wc],WC              ; (also _reg_ia)
	mov	M_WORD [reg_xr],XR
	mov	M_WORD [reg_xl],XL
        mov     M_WORD [reg_cp],CP              ; Needed in image saved by sysxi
	ret

syscall_exit:
	mov	M_WORD [_rc_],W0		; save return code from function
 	mov     M_WORD [osisp],XS               ; save OSINT's stack pointer
        mov     XS,M_WORD [compsp]              ; restore compiler's stack pointer
        mov     WA,M_WORD [reg_wa]              ; restore registers
	mov	WB,M_WORD [reg_wb]
        mov     WC,M_WORD [reg_wc]              ; (also reg_ia)
	mov	XR,M_WORD [reg_xr]
	mov	XL,M_WORD [reg_xl]
	mov	CP,M_WORD [reg_cp]
	cld
	mov	W0,M_WORD [reg_pc]
	jmp	W0
	
	%macro	syscall	2
        pop     W0                     ; pop return address
	mov	M_WORD [reg_pc],W0
	call	syscall_init
;       save compiler stack and switch to OSINT stack
        mov     M_WORD [compsp],XS              ; save compiler's stack pointer
        mov     XS,M_WORD [osisp]               ; load OSINT's stack pointer
	call	%1
	call	syscall_exit
	%endmacro

        global SYSAX
	extern	zysax
SYSAX:	syscall	  zysax,1

        global SYSBS
	extern	zysbs
SYSBS:	syscall	  zysbs,2

        global SYSBX
	extern	zysbx
SYSBX:	mov	M_WORD [reg_xs],XS
	syscall	zysbx,2

;        global SYSCR
;	extern	zyscr
;SYSCR:  syscall    zyscr ;    ,0

        global SYSDC
	extern	zysdc
SYSDC:	syscall	zysdc,4

        global SYSDM
	extern	zysdm
SYSDM:	syscall	zysdm,5

        global SYSDT
	extern	zysdt
SYSDT:	syscall	zysdt,6

        global SYSEA
	extern	zysea
SYSEA:	syscall	zysea,7

        global SYSEF
	extern	zysef
SYSEF:	syscall	zysef,8

        global SYSEJ
	extern	zysej
SYSEJ:	syscall	zysej,9

        global SYSEM
	extern	zysem
SYSEM:	syscall	zysem,10

        global SYSEN
	extern	zysen
SYSEN:	syscall	zysen,11

        global SYSEP
	extern	zysep
SYSEP:	syscall	zysep,12

        global SYSEX
	extern	zysex
SYSEX:	mov	M_WORD [reg_xs],XS
	syscall	zysex,13

        global SYSFC
	extern	zysfc
SYSFC:  pop     W0             ; <<<<remove stacked SCBLK>>>>
	lea	XS,[XS+WC*4]
	push	W0
	syscall	zysfc,14

        global SYSGC
	extern	zysgc
SYSGC:	syscall	zysgc,15

        global SYSHS
	extern	zyshs
SYSHS:	mov	M_WORD [reg_xs],XS
	syscall	zyshs,16

        global SYSID
	extern	zysid
SYSID:	syscall	zysid,17

        global SYSIF
	extern	zysif
SYSIF:	syscall	zysif,18

        global SYSIL
	extern	zysil
SYSIL:  syscall zysil,19

        global SYSIN
	extern	zysin
SYSIN:	syscall	zysin,20

        global SYSIO
	extern	zysio
SYSIO:	syscall	zysio,21

        global SYSLD
	extern	zysld
SYSLD:  syscall zysld,22

        global SYSMM
	extern	zysmm
SYSMM:	syscall	zysmm,23

        global SYSMX
	extern	zysmx
SYSMX:	syscall	zysmx,24

        global SYSOU
	extern	zysou
SYSOU:	syscall	zysou,25

        global SYSPI
	extern	zyspi
SYSPI:	syscall	zyspi,26

        global SYSPL
	extern	zyspl
SYSPL:	syscall	zyspl,27

        global SYSPP
	extern	zyspp
SYSPP:	syscall	zyspp,28

        global SYSPR
	extern	zyspr
SYSPR:	syscall	zyspr,29

        global SYSRD
	extern	zysrd
SYSRD:	syscall	zysrd,30

        global SYSRI
	extern	zysri
SYSRI:	syscall	zysri,32

        global SYSRW
	extern	zysrw
SYSRW:	syscall	zysrw,33

        global SYSST
	extern	zysst
SYSST:	syscall	zysst,34

        global SYSTM
	extern	zystm
SYSTM:	syscall	zystm,35

        global SYSTT
	extern	zystt
SYSTT:	syscall	zystt,36

        global SYSUL
	extern	zysul
SYSUL:	syscall	zysul,37

        global SYSXI
	extern	zysxi
SYSXI:	mov	M_WORD [reg_xs],XS
	syscall	zysxi,38

;       Individual OSINT routine entry points

; SPITBOL math routine interface 

	%macro	callext	2
	extern	%1
	call	%1
	add	XS,%2	; pop arguments
	%endmacro

;       CVD_ - convert by division

;       Input   IA (EDX) = number <=0 to convert
;       Output  IA / 10
;               WA (ECX) = remainder + '0'

        global  CVD_

CVD_:
        xchg    W0,WC         ; IA to EAX
        cdq                     ; sign extend
        idiv    M_WORD [ten]   ; divide by 10. WC = remainder (negative)
        neg     WC             ; make remainder positive
        add     dl,0x30         ; convert remainder to ascii ('0')
        mov     WA,WC         ; return remainder in WA
        xchg    WC,W0         ; return quotient in IA
	ret

;       DVI_ - divide IA (EDX) by long in EAX

        global  DVI_

DVI_:
        or      W0,W0         ; test for 0
        jz      setovr    	; jump if 0 divisor
        push    CP             ; preserve CP
        xchg    CP,W0         ; divisor to CP
        xchg    W0,WC         ; dividend in W0
        cdq                     ; extend dividend
        idiv    CP             ; perform division. W0=quotient, WC=remainder
        xchg    WC,W0         ; place quotient in WC (IA)
        pop     CP             ; restore CP
        xor     W0,W0         ; clear overflow indicator
	ret

;       RMI_ - remainder of IA (EDX) divided by long in EAX

        global  RMI_
RMI_:
        or      W0,W0         ; test for 0
        jz      setovr    ; jump if 0 divisor
        push    CP             ; preserve CP
        xchg    CP,W0         ; divisor to CP
        xchg    W0,WC         ; dividend in W0
        cdq                     ; extend dividend
        idiv    CP             ; perform division. W0=quotient, WC=remainder
        pop     CP             ; restore CP
        xor     W0,W0         ; clear overflow indicator
        ret                     ; return remainder in WC (IA)
setovr: mov     al,0x80         ; set overflow indicator
	dec	al
	ret

;    Calls to C

;       The calling convention of the various compilers:

;       Integer results returned in EAX.
;       Float results returned in ST0 for Intel.
;       See conditional switches fretst0 and
;       fretW0. 

;       C function preserves CP, EBX, XL, XR.


; define how floating point results are returned from a function
; (either in ST(0) or in EDX:EAX.
%define fretst0 1
%define fretW0 0

;       RTI_ - convert real in RA to integer in IA
;               returns C=0 if fit OK, C=1 if too large to convert

        global  RTI_
RTI_:
; 41E00000 00000000 = 2147483648.0
; 41E00000 00200000 = 2147483649.0
        mov     W0, M_WORD [reg_ra+4]  ; RA msh
        btr     W0,31          ; take absolute value, sign bit to carry flag
        jc      RTI_2     ; jump if negative real
        cmp     W0,0x41E00000  ; test against 2147483648
        jae     RTI_1     ; jump if >= +2147483648
RTI_3:  push    WA             ; protect against C routine usage.
        push    W0             ; push RA MSH
        push    M_WORD [reg_ra]  ; push RA LSH
        callext f_2_i,8         ; float to integer
        xchg    W0,WC         ; return integer in WC (IA)
        pop     WA             ; restore WA
        clc
	ret

; here to test negative number, made positive by the btr instruction
RTI_2:  cmp     W0,0x41E00000          ; test against 2147483649
        jb      RTI_0             ; definately smaller
        ja      RTI_1             ; definately larger
        cmp     word [reg_ra+2], 0x0020
        jae     RTI_1
RTI_0:  btc     W0,31                  ; make negative again
        jmp     RTI_3
RTI_1:  stc                             ; return C=1 for too large to convert
        ret

;       ITR_ - convert integer in IA to real in RA

        global  ITR_
ITR_:

        push    WA             ; preserve
        push    WC             ; push IA
        callext i_2_f,4         ; integer to float
%if fretst0
	fstp	qword [reg_ra]
        pop     WA             ; restore WA
	fwait
%endif
%if fretW0
        mov     M_WORD [reg_ra,W0    ; return result in RA
	mov	M_WORD [reg_ra+4,WC
        pop     WA             ; restore WA
%endif
	ret

;       LDR_ - load real pointed to by W0 to RA

        global  LDR_
LDR_:

        push    M_WORD [W0]                 ; lsh
	pop	M_WORD [reg_ra]
        mov     W0,[W0+4]                     ; msh
	mov	M_WORD [reg_ra+4], W0
	ret

;       STR_ - store RA in real pointed to by W0

        global  STR_
STR_:

        push    M_WORD [reg_ra]               ; lsh
	pop	M_WORD [W0]
        push    M_WORD [reg_ra+4]              ; msh
	pop	M_WORD [W0+4]
	ret

;       ADR_ - add real at [W0] to RA

        global  ADR_
ADR_:

        push    WA                             ; preserve regs for C
	push	WC
        push    M_WORD [reg_ra+4]             ; RA msh
        push    M_WORD [reg_ra]               ; RA lsh
        push    M_WORD [W0+4]               ; arg msh
        push    M_WORD [W0]                 ; arg lsh
        callext f_add,16                        ; perform op
%if fretst0
	fstp	qword [reg_ra]
        pop     WC                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     M_WORD [reg_ra+4], WC         ; result msh
        mov     M_WORD [reg_ra], W0           ; result lsh
        pop     WC                             ; restore regs
	pop	WA
%endif
	ret

;       SBR_ - subtract real at [W0] from RA

        global  SBR_

SBR_:
        push    WA                             ; preserve regs for C
	push	WC
        push    M_WORD [reg_ra+4]             ; RA msh
        push    M_WORD [reg_ra]               ; RA lsh
        push    M_WORD [W0+4]               ; arg msh
        push    M_WORD [W0]                 ; arg lsh
        callext f_sub,16                        ; perform op
%if fretst0
	fstp	qword [reg_ra]
        pop     WC                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     M_WORD [reg_ra+4, WC         ; result msh
        mov     M_WORD [reg_ra, W0           ; result lsh
        pop     WC                             ; restore regs
	pop	WA
%endif
	ret

;       MLR_ - multiply real in RA by real at [W0]

        global  MLR_

MLR_:
        push    WA                             ; preserve regs for C
	push	WC
        push    M_WORD [reg_ra+4]              ; RA msh
        push    M_WORD [reg_ra]                ; RA lsh
        push    M_WORD [W0+4]               ; arg msh
        push    M_WORD [W0]                 ; arg lsh
        callext f_mul,16                        ; perform op
%if fretst0
	fstp	qword [reg_ra]
        pop     WC                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     M_WORD [reg_ra+4], WC         ; result msh
        mov     M_WORD [reg_ra], W0           ; result lsh
        pop     WC                             ; restore regs
	pop	WA
%endif
	ret

;       DVR_ - divide real in RA by real at [W0]

        global  DVR_

DVR_:
        push    WA                             ; preserve regs for C
	push	WC
        push    M_WORD [reg_ra+4]              ; RA msh
        push    M_WORD [reg_ra]                ; RA lsh
        push    M_WORD [W0+4]               ; arg msh
        push    M_WORD [W0]                 ; arg lsh
        callext f_div,16                        ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     WC                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     M_WORD [reg_ra+4], WC         ; result msh
        mov     M_WORD [reg_ra], W0           ; result lsh
        pop     WC                             ; restore regs
	pop	WA
%endif
	ret

;       NGR_ - negate real in RA

        global  NGR_

NGR_:
	cmp	M_WORD [reg_ra], 0
	jne	ngr_1
	cmp	M_WORD [reg_ra+4], 0
        je      ngr_2                     ; if zero, leave alone
ngr_1:  xor     byte [reg_ra+7], 0x80         ; complement mantissa sign
ngr_2:	ret

;       ATN_ arctangent of real in RA

        global  ATN_

ATN_:
        push    WA                             ; preserve regs for C
	push	WC
        push    M_WORD [reg_ra+4]              ; RA msh
        push    M_WORD [reg_ra]                ; RA lsh
        callext f_atn,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     WC                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     M_WORD [reg_ra+4], WC         ; result msh
        mov     M_WORD [reg_ra], W0           ; result lsh
        pop     WC                             ; restore regs
	pop	WA
%endif
	ret

;       CHP_ chop fractional part of real in RA

        global  CHP_


CHP_:
        push    WA                             ; preserve regs for C
	push	WC
        push    M_WORD [reg_ra+4]              ; RA msh
        push    M_WORD [reg_ra]                ; RA lsh
        callext f_chp,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     WC                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     M_WORD [reg_ra+4], WC         ; result msh
        mov     M_WORD [reg_ra], W0           ; result lsh
        pop     WC                             ; restore regs
	pop	WA
%endif
	ret

;       COS_ cosine of real in RA

        global  COS_

COS_:
        push    WA                             ; preserve regs for C
	push	WC
        push    M_WORD [reg_ra+4]              ; RA msh
        push    M_WORD [reg_ra]                ; RA lsh
        callext f_cos,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     WC                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     M_WORD [reg_ra+4], WC         ; result msh
        mov     M_WORD [reg_ra], W0           ; result lsh
        pop     WC                             ; restore regs
	pop	WA
%endif
	ret

;       ETX_ exponential of real in RA

        global  ETX_

ETX_:
        push    WA                             ; preserve regs for C
	push	WC
        push    M_WORD [reg_ra+4]              ; RA msh
        push    M_WORD [reg_ra]                ; RA lsh
        callext f_etx,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     WC                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     M_WORD [reg_ra+4], WC         ; result msh
        mov     M_WORD [reg_ra], W0           ; result lsh
        pop     WC                             ; restore regs
	pop	WA
%endif
	ret

;       LNF_ natural logarithm of real in RA

        global  LNF_

LNF_:
        push    WA                             ; preserve regs for C
	push	WC
        push    M_WORD [reg_ra+4]              ; RA msh
        push    M_WORD [reg_ra]                ; RA lsh
        callext f_lnf,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     WC                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     M_WORD [reg_ra+4], WC         ; result msh
        mov     M_WORD [reg_ra], W0           ; result lsh
        pop     WC                             ; restore regs
	pop	WA
%endif
	ret

;       SIN_ arctangent of real in RA

        global  SIN_

SIN_:

        push    WA                             ; preserve regs for C
	push	WC
        push    M_WORD [reg_ra+4]              ; RA msh
        push    M_WORD [reg_ra]               ; RA lsh
        callext f_sin,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     WC                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     M_WORD [reg_ra+4], WC         ; result msh
        mov     M_WORD [reg_ra], W0           ; result lsh
        pop     WC                             ; restore regs
	pop	WA
%endif
	ret

;       SQR_ arctangent of real in RA

        global  SQR_

SQR_:
        push    WA                             ; preserve regs for C
	push	WC
        push    M_WORD [reg_ra+4]              ; RA msh
        push    M_WORD [reg_ra]                ; RA lsh
        callext f_sqr,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     WC                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     M_WORD [reg_ra+4], WC         ; result msh
        mov     M_WORD [reg_ra], W0           ; result lsh
        pop     WC                             ; restore regs
	pop	WA
%endif
	ret

;       TAN_ arctangent of real in RA

        global  TAN_

TAN_:
        push    WA                             ; preserve regs for C
	push	WC
        push    M_WORD [reg_ra+4]              ; RA msh
        push    M_WORD [reg_ra]                ; RA lsh
        callext f_tan,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     WC                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     M_WORD [reg_ra+4], WC         ; result msh
        mov     M_WORD [reg_ra], W0           ; result lsh
        pop     WC                             ; restore regs
	pop	WA
%endif
	ret

;       CPR_ compare real in RA to 0

        global  CPR_
CPR_:
        mov     W0, M_WORD [reg_ra+4] ; fetch msh
        cmp     W0, 0x80000000         ; test msh for -0.0
        je      cpr050            ; possibly
        or      W0, W0                ; test msh for +0.0
        jnz     cpr100            ; exit if non-zero for cc's set
cpr050: cmp     M_WORD [reg_ra], 0     ; true zero, or denormalized number?
        jz      cpr100            ; exit if true zero
	mov	al, 1
        cmp     al, 0                   ; positive denormal, set cc
cpr100:	ret

;       OVR_ test for overflow value in RA

	global	OVR_

OVR_:   
        mov     ax, word [reg_ra+6]   ; get top 2 bytes
        and     ax, 0x7ff0              ; check for infinity or nan
        add     ax, 0x10                ; set/clear overflow accordingly
	ret




;  tryfpu - perform a floating point op to trigger a trap if no floating point hardware.

	global	tryfpu
tryfpu:
	push	CP
	fldz
	pop	CP
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
; #       On exit, return CP in EAX. This is the lower limit on the
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
;         mov     XS,W0                 # switch to this stack
; 	call	stackinit               # initialize MINIMAL stack
; 
;                                         # set up for stack relocation
;         lea     W0,TSCBLK+scstr        # top of saved stack
;         mov     WB,lmodstk             # bottom of saved stack
;         GETMIN  WA,STBAS               # WA = stbas from exit() time
;         sub     WB,W0                 # WB = size of saved stack
; 	mov	WC,WA
;         sub     WC,WB                 # WC = stack bottom from exit() time
; 	mov	WB,WA
;         sub     WB,XS                 # WB = old stbas - new stbas
; 
;         SETMINR  STBAS,XS               # save initial sp
; #        GETOFF  W0,DFFNC               # get address of PPM offset
;         mov     ppoff,W0               # save for use later
; #
; #       restore stack from TSCBLK.
; #
;         mov     XL,lmodstk             # -> bottom word of stack in TSCBLK
;         lea     XR,TSCBLK+scstr        # -> top word of stack
;         cmp     XL,XR                 # Any stack to transfer?
;         je            re3               #  skip if not
; 	sub	XL,4
; 	std
; re1:    lodsd                           # get old stack word to W0
;         cmp     W0,WC                 # below old stack bottom?
;         jb            re2               #   j. if W0 < WC
;         cmp     W0,WA                 # above old stack top?
;         ja            re2               #   j. if W0 > WA
;         sub     W0,WB                 # within old stack, perform relocation
; re2:    push    W0                     # transfer word of stack
;         cmp     XL,XR                 # if not at end of relocation then
;         jae     re1                     #    loop back
; 
; re3:	cld
;         mov     compsp,XS              # 1.39 save compiler's stack pointer
;         mov     XS,osisp               # 1.39 back to OSINT's stack pointer
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
;         je            re4               # yes, do a complete fudge
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
