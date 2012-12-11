	global	reg_block
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
 
; Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
; 
; This file is part of Macro SPITBOL.
; 
;     Macro SPITBOL is free software: you can rrdistribute it and/or modify
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
%define globals 1                       ;ASM globals defined here

;
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
;       intermrdiary set of routines have been established to allow the
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
;  ;


; x86 doesn't have instructions equivalent to
; x32 pushad and popad, so use macros to 
; provide the desired function
	align	8
	segment	.data

rax_save:	dq	0
rbp_save:	dq	0
rbx_save:	dq	0
rcx_save:	dq	0
rdi_save:	dq	0
rdx_save:	dq	0
rsi_save:	dq	0
rsp_save:	dq	0

	%macro	pushaq	0
	mov	qword [rax_save],rax
	mov	qword [rbp_save],rbp
	mov	qword [rbx_save],rcx
	mov	qword [rcx_save],rcx
	mov	qword [rdi_save],rdi
	mov	qword [rdx_save],rdx
	mov	qword [rsi_save],rsi
	mov	qword [rsp_save],rsp
	%endmacro


	%macro	popaq 0
	mov	rax,qword [rax_save]
	mov	rbp,qword [rbp_save]
	mov	rbx,qword [rbx_save]
	mov	rcx,qword [rcx_save]
	mov	rdi,qword [rdi_save]
	mov	rdx,qword [rdx_save]
	mov	rsi,qword [rsi_save]
	mov	rsp,qword [rsp_save]
	%endmacro
        align 8
reg_block:
reg_wa:	dq	0        ; Register WA (ECX)
reg_wb:	dq 	0        ; Register WB (EBX)
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
sav_block: times 88 db 0     ; Save Minimal registers during push/pop reg
;
        align 8
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
	global	pushregs
pushregs:
	pushaq
	lea	rsi,[reg_block]
	lea	rdi,[sav_block]
	mov	rcx,r_size/8
	cld
   rep	movsd

        mov     rdi,qword [compsp]
        or      rdi,rdi                         ; 1.39 is there a compiler stack
        je      push1                     ; 1.39 jump if none yet
        sub     rdi,8                           ;push onto compiler's stack
        mov     rsi,qword [reg_xl]                      ;collectable XL
	mov	[rdi],rsi
        mov     qword [compsp],rdi                      ;smashed if call OSINT again (SYSGC)
        mov     qword [sav_compsp],rdi                  ;used by popregs

push1:	popaq
	ret

	global	popregs
popregs:
	pushaq
        mov     rax,qword [reg_cp]                      ;don't restore CP
	cld
	lea	rsi,[sav_block]
        lea     rdi,[reg_block]                   ;unload saved registers
	mov	rcx,r_size/8
   rep  movsd                                   ;restore from temp area
	mov	qword [reg_cp],rax

        mov     rdi,qword [sav_compsp]                  ;saved compiler's stack
        or      rdi,rdi                         ;1.39 is there one?
        je      pop1                      ;1.39 jump if none yet
        mov     rsi,qword [rdi]                       ;retrieve collectable XL
        mov     qword [reg_xl],rsi                      ;update XL
        add     rdi,8                           ;update compiler's sp
        mov     qword [compsp],rdi

pop1:	popaq
	ret

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
;   The order of entries here must corrrspond to the order of
;   calltab entries in the INTER assembly language module.
;
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
        pop     rax                     ; discard return
        pop     rax                     ; discard dummy1
        pop     rax                     ; discard dummy2
	call	stackinit               ; initialize MINIMAL stack
        mov     rax,qword [compsp]              ; get MINIMAL's stack pointer
        mov qword[reg_wa],rax                     ; startup stack pointer

	cld                             ; default to UP direction for string ops
;        GETOFF  rax,DFFNC               # get address of PPM offset
        mov     qword [ppoff],rax               ; save for use later
;
        mov     rsp,qword [osisp]               ; switch to new C stack
	push	CALLTAB_START
	call	minimal			; load regs, switch stack, start compiler

; 
; 
; 
;
;-----------
;
;	stackinit  -- initialize LOWSPMIN from sp.
;
;	Input:  sp - current C stack
;		stacksiz - size of drsired Minimal stack in bytes
;
;	Uses:	rax
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
	mov	rax,rsp
        mov     qword [compsp],rax              ; save as MINIMAL's stack pointer
	sub	rax,qword [stacksiz]            ; end of MINIMAL stack is where C stack will start
        mov     qword [osisp],rax               ; save new C stack pointer
	add	rax,8*100               ; 100 words smaller for CHK
	extern	LOWSPMIN
	mov	qword [LOWSPMIN],rax
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
         pushaq                          ; save all registers for C
         mov     rax,qword [rsp+32+8]          ; get ordinal
         mov     rcx,qword [reg_wa]              ; restore registers
 	mov	rbx,qword [reg_wb]
         mov     rdx,qword [reg_wc]              ; (also _reg_ia)
 	mov	rdi,qword [reg_xr]
 	mov	rsi,qword [reg_xl]
 	mov	rbp,qword [reg_cp]
 
         mov     qword [osisp],rsp               ; 1.39 save OSINT stack pointer
         cmp     qword [compsp],0      ; 1.39 is there a compiler stack?
         je      min1              ; 1.39 jump if none yet
         mov     rsp,qword [compsp]              ; 1.39 switch to compiler stack
 
 min1:   call   qword [calltab+rax*8]        ; off to the Minimal code
 
         mov     rsp,qword [osisp]               ; 1.39 switch to OSINT stack
 
         mov     qword [reg_wa],rcx              ; save registers
 	mov	qword [reg_wb],rbx
 	mov	qword [reg_wc],rdx
 	mov	qword [reg_xr],rdi
 	mov	qword [reg_xl],rsi
 	mov	qword [reg_cp],rbp
 	popaq
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
;                       dq      zysxx           ; dq      of C OSINT function
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

ccaller:
;       (1) Save registers in global variables

        mov     qword [reg_wa],rcx              ; save registers
	mov	qword [reg_wb],rbx
        mov     qword [reg_wc],rdx              ; (also _reg_ia)
	mov	qword [reg_xr],rdi
	mov	qword [reg_xl],rsi
        mov     qword [reg_cp],rbp              ; Needed in image saved by sysxi

;       (2) Get pointer to arg list

        pop     rsi                     ; point to arg list

;       (3) Fetch dq      of C function], fetch offset to 1st instruction
;           past last procedure exit], and call C function.

        cs                              ; CS segment override
        lodsd                           ; point to C function entry point
	mov	qword [call_adr],rax
;       lodsd   cs:ccaller              ; point to C function entry point
;	word after callee address used to be ppm count. Now used for debug
	mov	rbx,qword[rsi]
        mov     qword [reg_pp],rbx              ; in memory
        pop     qword [reg_pc]                  ; save return PC past "CALL SYSXX"

;       (3a) Save compiler stack and switch to OSINT stack

; DS 12/22/12 Note that needn't save and restore stack ptrs if not using
; 	save files or load modules
         mov     qword [compsp],rsp              ; 1.39 save compiler's stack pointer
         mov     rsp,qword [osisp]               ; 1.39 load OSINT's stack pointer

;       (3b) Make call to OSINT
	mov	rax,qword [call_adr]
        call    rax                     ; call C interface function

	mov	qword [_rc_],rax		; save return code from function

;       (4) Restore registers after C function returns.


cc1:    
 	mov     qword [osisp],rsp               ; 1.39 save OSINT's stack pointer
        mov     rsp,qword [compsp]              ; 1.39 restore compiler's stack pointer
        mov     rcx,qword [reg_wa]              ; restore registers
	mov	rbx,qword [reg_wb]
        mov     rdx,qword [reg_wc]              ; (also reg_ia)
	mov	rdi,qword [reg_xr]
	mov	rsi,qword [reg_xl]
	mov	rbp,qword [reg_cp]

	cld

	mov	rax,qword [reg_pc]
	jmp	rax


;---------------

;       Individual OSINT routine entry points

        global SYSAX
	extern	zysax
SYSAX:	call	ccaller
        dq        zysax
        dq   1

        global SYSBS
	extern	zysbs
SYSBS:	call	ccaller
        dq        zysbs
        dq   2

        global SYSBX
	extern	zysbx
SYSBX:	mov	qword [reg_xs],rsp
	call	ccaller
        dq      zysbx
        dq   2

;        global SYSCR
;	extern	zyscr
;SYSCR:  call    ccaller
;        dq      zyscr
;        dq   0
;
        global SYSDC
	extern	zysdc
SYSDC:	call	ccaller
        dq      zysdc
        dq   4

        global SYSDM
	extern	zysdm
SYSDM:	call	ccaller
        dq      zysdm
        dq   5

        global SYSDT
	extern	zysdt
SYSDT:	call	ccaller
        dq      zysdt
        dq   6

        global SYSEA
	extern	zysea
SYSEA:	call	ccaller
        dq      zysea
        dq   7

        global SYSEF
	extern	zysef
SYSEF:	call	ccaller
        dq      zysef
        dq   8

        global SYSEJ
	extern	zysej
SYSEJ:	call	ccaller
        dq      zysej
        dq   9

        global SYSEM
	extern	zysem
SYSEM:	call	ccaller
        dq      zysem
        dq   10

        global SYSEN
	extern	zysen
SYSEN:	call	ccaller
        dq      zysen
        dq   11

        global SYSEP
	extern	zysep
SYSEP:	call	ccaller
        dq      zysep
        dq  	12

        global SYSEX
	extern	zysex
SYSEX:	mov	qword [reg_xs],rsp
	call	ccaller
        dq      zysex
        dq   13

        global SYSFC
	extern	zysfc
SYSFC:  pop     rax             ; <<<<remove stacked SCBLK>>>>
	lea	rsp,[rsp+rdx*8]
	push	rax
	call	ccaller
        dq      zysfc
        dq   14

        global SYSGC
	extern	zysgc
SYSGC:	call	ccaller
        dq      zysgc
        dq   15

        global SYSHS
	extern	zyshs
SYSHS:	mov	qword [reg_xs],rsp
	call	ccaller
        dq      zyshs
        dq   16

        global SYSID
	extern	zysid
SYSID:	call	ccaller
        dq      zysid
        dq   17

        global SYSIF
	extern	zysif
SYSIF:	call	ccaller
        dq      zysif
        dq   18

        global SYSIL
	extern	zysil
SYSIL:  call    ccaller
        dq      zysil
        dq   19

        global SYSIN
	extern	zysin
SYSIN:	call	ccaller
        dq      zysin
        dq   20

        global SYSIO
	extern	zysio
SYSIO:	call	ccaller
        dq      zysio
        dq   21

        global SYSLD
	extern	zysld
SYSLD:  call    ccaller
        dq      zysld
        dq   22

        global SYSMM
	extern	zysmm
SYSMM:	call	ccaller
        dq      zysmm
        dq   23

        global SYSMX
	extern	zysmx
SYSMX:	call	ccaller
        dq      zysmx
        dq   24

        global SYSOU
	extern	zysou
SYSOU:	call	ccaller
        dq      zysou
        dq   25

        global SYSPI
	extern	zyspi
SYSPI:	call	ccaller
        dq      zyspi
        dq   26

        global SYSPL
	extern	zyspl
SYSPL:	call	ccaller
        dq      zyspl
        dq   27

        global SYSPP
	extern	zyspp
SYSPP:	call	ccaller
        dq      zyspp
        dq   28

        global SYSPR
	extern	zyspr
SYSPR:	call	ccaller
        dq      zyspr
        dq   29

        global SYSRD
	extern	zysrd
SYSRD:	call	ccaller
        dq      zysrd
        dq   30

        global SYSRI
	extern	zysri
SYSRI:	call	ccaller
        dq      zysri
        dq   32

        global SYSRW
	extern	zysrw
SYSRW:	call	ccaller
        dq      zysrw
        dq   33

        global SYSST
	extern	zysst
SYSST:	call	ccaller
        dq      zysst
        dq   34

        global SYSTM
	extern	zystm
SYSTM:	call	ccaller
systm_p: dq      zystm
        dq   35

        global SYSTT
	extern	zystt
SYSTT:	call	ccaller
        dq      zystt
        dq   36

        global SYSUL
	extern	zysul
SYSUL:	call	ccaller
        dq      zysul
        dq   37

        global SYSXI
	extern	zysxi
SYSXI:	mov	qword [reg_xs],rsp
	call	ccaller
sysxi_p: dq      zysxi
        dq   38
; SPITBOL math routine interface 

	%macro	callext	2
	extern	%1
	call	%1
	add	rsp,%2	; pop arguments
	%endmacro

;-----------
;
;       CVD_ - convert by division
;
;       Input   IA (EDX) = number <=0 to convert
;       Output  IA / 10
;               WA (ECX) = remainder + '0'
;
        global  CVD_

CVD_:
        xchg    rax,rdx         ; IA to EAX
        cdq                     ; sign extend
        idiv    qword [ten]   ; divide by 10. rdx = remainder (negative)
        neg     rdx             ; make remainder positive
        add     dl,0x30         ; convert remainder to ascii ('0')
        mov     rcx,rdx         ; return remainder in WA
        xchg    rdx,rax         ; return quotient in IA
	ret

;
;-----------
;
;       DVI_ - divide IA (EDX) by long in EAX
;
        global  DVI_

DVI_:
        or      rax,rax         ; test for 0
        jz      setovr    	; jump if 0 divisor
        push    rbp             ; preserve CP
        xchg    rbp,rax         ; divisor to rbp
        xchg    rax,rdx         ; dividend in rax
        cdq                     ; extend dividend
        idiv    rbp             ; perform division. rax=quotient, rdx=remainder
        xchg    rdx,rax         ; place quotient in rdx (IA)
        pop     rbp             ; restore CP
        xor     rax,rax         ; clear overflow indicator
	ret


;
;-----------
;
;       RMI_ - remainder of IA (EDX) divided by long in EAX
;
        global  RMI_
RMI_:
        or      rax,rax         ; test for 0
        jz      setovr    ; jump if 0 divisor
        push    rbp             ; preserve CP
        xchg    rbp,rax         ; divisor to rbp
        xchg    rax,rdx         ; dividend in rax
        cdq                     ; extend dividend
        idiv    rbp             ; perform division. rax=quotient, rdx=remainder
        pop     rbp             ; restore CP
        xor     rax,rax         ; clear overflow indicator
        ret                     ; return remainder in rdx (IA)
setovr: mov     al,0x80         ; set overflow indicator
	dec	al
	ret



;----------
;
;    Calls to C
;
;       The calling convention of the various compilers:
;
;       Integer results returned in EAX.
;       Float results returned in ST0 for Intel.
;       See conditional switches fretst0 and
;       fretrax. 
;
;       C function preserves EBP, EBX, ESI, EDI.
;

; define how floating point results are returned from a function
; (either in ST(0) or in EDX:EAX.
%define fretst0 1
%define fretrax 0

;----------
;
;       RTI_ - convert real in RA to integer in IA
;               returns C=0 if fit OK, C=1 if too large to convert
;
        global  RTI_
RTI_:
; 41E00000 00000000 = 2147483648.0
; 41E00000 00200000 = 2147483649.0
        mov     rax, qword [reg_ra+4]  ; RA msh
        btr     rax,31          ; take absolute value, sign bit to carry flag
        jc      RTI_2     ; jump if negative real
        cmp     rax,0x41E00000  ; test against 2147483648
        jae     RTI_1     ; jump if >= +2147483648
RTI_3:  push    rcx             ; protect against C routine usage.
        push    rax             ; push RA MSH
        push    qword [reg_ra]  ; push RA LSH
        callext f_2_i,8         ; float to integer
        xchg    rax,rdx         ; return integer in rdx (IA)
        pop     rcx             ; restore rcx
        clc
	ret

; here to test negative number, made positive by the btr instruction
RTI_2:  cmp     rax,0x41E00000          ; test against 2147483649
        jb      RTI_0             ; definately smaller
        ja      RTI_1             ; definately larger
        cmp     word [reg_ra+2], 0x0020
        jae     RTI_1
RTI_0:  btc     rax,31                  ; make negative again
        jmp     RTI_3
RTI_1:  stc                             ; return C=1 for too large to convert
        ret

;
;----------
;
;       ITR_ - convert integer in IA to real in RA
;
        global  ITR_
ITR_:

        push    rcx             ; preserve
        push    rdx             ; push IA
        callext i_2_f,4         ; integer to float
%if fretst0
	fstp	qword [reg_ra]
        pop     rcx             ; restore rcx
	fwait
%endif
%if fretrax
        mov     qword [reg_ra,rax    ; return result in RA
	mov	qword [reg_ra+4,rdx
        pop     rcx             ; restore rcx
%endif
	ret

;
;----------
;
;       LDR_ - load real pointed to by rax to RA
;
        global  LDR_
LDR_:

        push    qword [rax]                 ; lsh
	pop	qword [reg_ra]
        mov     rax,[rax+4]                     ; msh
	mov	qword [reg_ra+4], rax
	ret

;
;----------
;
;       STR_ - store RA in real pointed to by rax
;
        global  STR_
STR_:

        push    qword [reg_ra]               ; lsh
	pop	qword [rax]
        push    qword [reg_ra+4]              ; msh
	pop	qword [rax+4]
	ret

;
;----------
;
;       ADR_ - add real at [rax] to RA
;
        global  ADR_
ADR_:

        push    rcx                             ; preserve regs for C
	push	rdx
        push    qword [reg_ra+4]             ; RA msh
        push    qword [reg_ra]               ; RA lsh
        push    qword [rax+4]               ; arg msh
        push    qword [rax]                 ; arg lsh
        callext f_add,16                        ; perform op
%if fretst0
	fstp	qword [reg_ra]
        pop     rdx                             ; restore regs
	pop	rcx
	fwait
%endif
%if fretrax
        mov     qword [reg_ra+4], rdx         ; result msh
        mov     qword [reg_ra], rax           ; result lsh
        pop     rdx                             ; restore regs
	pop	rcx
%endif
	ret

;
;----------
;
;       SBR_ - subtract real at [rax] from RA
;
        global  SBR_

SBR_:
        push    rcx                             ; preserve regs for C
	push	rdx
        push    qword [reg_ra+4]             ; RA msh
        push    qword [reg_ra]               ; RA lsh
        push    qword [rax+4]               ; arg msh
        push    qword [rax]                 ; arg lsh
        callext f_sub,16                        ; perform op
%if fretst0
	fstp	qword [reg_ra]
        pop     rdx                             ; restore regs
	pop	rcx
	fwait
%endif
%if fretrax
        mov     qword [reg_ra+4, rdx         ; result msh
        mov     qword [reg_ra, rax           ; result lsh
        pop     rdx                             ; restore regs
	pop	rcx
%endif
	ret

;
;----------
;
;       MLR_ - multiply real in RA by real at [rax]
;
        global  MLR_

MLR_:
        push    rcx                             ; preserve regs for C
	push	rdx
        push    qword [reg_ra+4]              ; RA msh
        push    qword [reg_ra]                ; RA lsh
        push    qword [rax+4]               ; arg msh
        push    qword [rax]                 ; arg lsh
        callext f_mul,16                        ; perform op
%if fretst0
	fstp	qword [reg_ra]
        pop     rdx                             ; restore regs
	pop	rcx
	fwait
%endif
%if fretrax
        mov     qword [reg_ra+4], rdx         ; result msh
        mov     qword [reg_ra], rax           ; result lsh
        pop     rdx                             ; restore regs
	pop	rcx
%endif
	ret

;
;----------
;
;       DVR_ - divide real in RA by real at [rax]
;
        global  DVR_

DVR_:
        push    rcx                             ; preserve regs for C
	push	rdx
        push    qword [reg_ra+4]              ; RA msh
        push    qword [reg_ra]                ; RA lsh
        push    qword [rax+4]               ; arg msh
        push    qword [rax]                 ; arg lsh
        callext f_div,16                        ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     rdx                             ; restore regs
	pop	rcx
	fwait
%endif
%if fretrax
        mov     qword [reg_ra+4], rdx         ; result msh
        mov     qword [reg_ra], rax           ; result lsh
        pop     rdx                             ; restore regs
	pop	rcx
%endif
	ret

;
;----------
;
;       NGR_ - negate real in RA
;
        global  NGR_

NGR_:
	cmp	qword [reg_ra], 0
	jne	ngr_1
	cmp	qword [reg_ra+4], 0
        je      ngr_2                     ; if zero, leave alone
ngr_1:  xor     byte [reg_ra+7], 0x80         ; complement mantissa sign
ngr_2:	ret

;
;----------
;
;       ATN_ arctangent of real in RA
;
        global  ATN_

ATN_:
        push    rcx                             ; preserve regs for C
	push	rdx
        push    qword [reg_ra+4]              ; RA msh
        push    qword [reg_ra]                ; RA lsh
        callext f_atn,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     rdx                             ; restore regs
	pop	rcx
	fwait
%endif
%if fretrax
        mov     qword [reg_ra+4], rdx         ; result msh
        mov     qword [reg_ra], rax           ; result lsh
        pop     rdx                             ; restore regs
	pop	rcx
%endif
	ret

;
;----------
;
;       CHP_ chop fractional part of real in RA
;
        global  CHP_


CHP_:
        push    rcx                             ; preserve regs for C
	push	rdx
        push    qword [reg_ra+4]              ; RA msh
        push    qword [reg_ra]                ; RA lsh
        callext f_chp,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     rdx                             ; restore regs
	pop	rcx
	fwait
%endif
%if fretrax
        mov     qword [reg_ra+4], rdx         ; result msh
        mov     qword [reg_ra], rax           ; result lsh
        pop     rdx                             ; restore regs
	pop	rcx
%endif
	ret

;
;----------
;
;       COS_ cosine of real in RA
;
        global  COS_

COS_:
        push    rcx                             ; preserve regs for C
	push	rdx
        push    qword [reg_ra+4]              ; RA msh
        push    qword [reg_ra]                ; RA lsh
        callext f_cos,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     rdx                             ; restore regs
	pop	rcx
	fwait
%endif
%if fretrax
        mov     qword [reg_ra+4], rdx         ; result msh
        mov     qword [reg_ra], rax           ; result lsh
        pop     rdx                             ; restore regs
	pop	rcx
%endif
	ret

;
;----------
;
;       ETX_ exponential of real in RA
;
        global  ETX_

ETX_:
        push    rcx                             ; preserve regs for C
	push	rdx
        push    qword [reg_ra+4]              ; RA msh
        push    qword [reg_ra]                ; RA lsh
        callext f_etx,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     rdx                             ; restore regs
	pop	rcx
	fwait
%endif
%if fretrax
        mov     qword [reg_ra+4], rdx         ; result msh
        mov     qword [reg_ra], rax           ; result lsh
        pop     rdx                             ; restore regs
	pop	rcx
%endif
	ret

;
;----------
;
;       LNF_ natural logarithm of real in RA
;
        global  LNF_

LNF_:
        push    rcx                             ; preserve regs for C
	push	rdx
        push    qword [reg_ra+4]              ; RA msh
        push    qword [reg_ra]                ; RA lsh
        callext f_lnf,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     rdx                             ; restore regs
	pop	rcx
	fwait
%endif
%if fretrax
        mov     qword [reg_ra+4], rdx         ; result msh
        mov     qword [reg_ra], rax           ; result lsh
        pop     rdx                             ; restore regs
	pop	rcx
%endif
	ret

;
;----------
;
;       SIN_ arctangent of real in RA
;
        global  SIN_

SIN_:

        push    rcx                             ; preserve regs for C
	push	rdx
        push    qword [reg_ra+4]              ; RA msh
        push    qword [reg_ra]               ; RA lsh
        callext f_sin,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     rdx                             ; restore regs
	pop	rcx
	fwait
%endif
%if fretrax
        mov     qword [reg_ra+4], rdx         ; result msh
        mov     qword [reg_ra], rax           ; result lsh
        pop     rdx                             ; restore regs
	pop	rcx
%endif
	ret

;
;----------
;
;       SQR_ arctangent of real in RA
;
        global  SQR_

SQR_:
        push    rcx                             ; preserve regs for C
	push	rdx
        push    qword [reg_ra+4]              ; RA msh
        push    qword [reg_ra]                ; RA lsh
        callext f_sqr,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     rdx                             ; restore regs
	pop	rcx
	fwait
%endif
%if fretrax
        mov     qword [reg_ra+4], rdx         ; result msh
        mov     qword [reg_ra], rax           ; result lsh
        pop     rdx                             ; restore regs
	pop	rcx
%endif
	ret
;
;----------
;
;       TAN_ arctangent of real in RA
;
        global  TAN_

TAN_:
        push    rcx                             ; preserve regs for C
	push	rdx
        push    qword [reg_ra+4]              ; RA msh
        push    qword [reg_ra]                ; RA lsh
        callext f_tan,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     rdx                             ; restore regs
	pop	rcx
	fwait
%endif
%if fretrax
        mov     qword [reg_ra+4], rdx         ; result msh
        mov     qword [reg_ra], rax           ; result lsh
        pop     rdx                             ; restore regs
	pop	rcx
%endif
	ret

;
;----------
;
;       CPR_ compare real in RA to 0
;
        global  CPR_
CPR_:
        mov     rax, qword [reg_ra+4] ; fetch msh
        cmp     rax, 0x8000000000000000         ; test msh for -0.0
        je      cpr050            ; possibly
        or      rax, rax                ; test msh for +0.0
        jnz     cpr100            ; exit if non-zero for cc's set
cpr050: cmp     qword [reg_ra], 0     ; true zero, or denormalized number?
        jz      cpr100            ; exit if true zero
	mov	al, 1
        cmp     al, 0                   ; positive denormal, set cc
cpr100:	ret


;----------
;
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
;         mov     rax,reg_xs      # Minimal's XS
;         add     rax,4           # pop return from call to SYSBX or SYSXI
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
;         pop     rax                     # discard return
;         pop     rax                     # discard dummy
;         pop     rax                     # get lowest legal stack value
; 
;         add     rax,stacksiz            # top of compiler's stack
;         mov     rsp,rax                 # switch to this stack
; 	call	stackinit               # initialize MINIMAL stack
; 
;                                         # set up for stack relocation
;         lea     rax,TSCBLK+scstr        # top of saved stack
;         mov     rbx,lmodstk             # bottom of saved stack
;         GETMIN  rcx,STBAS               # rcx = stbas from exit() time
;         sub     rbx,rax                 # rbx = size of saved stack
; 	mov	rdx,rcx
;         sub     rdx,rbx                 # rdx = stack bottom from exit() time
; 	mov	rbx,rcx
;         sub     rbx,rsp                 # rbx = old stbas - new stbas
; 
;         SETMINR  STBAS,rsp               # save initial sp
; #        GETOFF  rax,DFFNC               # get address of PPM offset
;         mov     ppoff,rax               # save for use later
; #
; #       restore stack from TSCBLK.
; #
;         mov     rsi,lmodstk             # -> bottom word of stack in TSCBLK
;         lea     rdi,TSCBLK+scstr        # -> top word of stack
;         cmp     rsi,rdi                 # Any stack to transfer?
;         je      short re3               #  skip if not
; 	sub	rsi,4
; 	std
; re1:    lodsd                           # get old stack word to rax
;         cmp     rax,rdx                 # below old stack bottom?
;         jb      short re2               #   j. if rax < rdx
;         cmp     rax,rcx                 # above old stack top?
;         ja      short re2               #   j. if rax > rcx
;         sub     rax,rbx                 # within old stack, perform relocation
; re2:    push    rax                     # transfer word of stack
;         cmp     rsi,rdi                 # if not at end of relocation then
;         jae     re1                     #    loop back
; 
; re3:	cld
;         mov     compsp,rsp              # 1.39 save compiler's stack pointer
;         mov     rsp,osisp               # 1.39 back to OSINT's stack pointer
;         callc   rereloc,0               # V1.08 relocate compiler pointers into stack
;         GETMIN  rax,STATB               # V1.34 start of static region to XR
; 	SET_XR  rax
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
;         GETMIN  rax,STAGE               # is this a -w call?
; 	cmp	rax,4
;         je      short re4               # yes, do a complete fudge
; 
; #
; #       Jump back to cc1 with return value = NORMAL_RETURN
; 	mov	rax,-1
;         jmp     cc1                     # jump back
; 
; #       Here if -w produced load module.  simulate all the code that
; #       would occur if we naively returned to sysbx.  Clear the stack and
; #       go for it.
; #
; re4:	GETMIN	rax,STBAS
;         mov     compsp,rax              # 1.39 empty the stack
; 
; #       Code that would be executed if we had returned to makeexec:
; #
;         SETMIN  GBCNT,0                 # reset garbage collect count
;         callc   zystm,0                 # Fetch execution time to reg_ia
;         mov     rax,reg_ia              # Set time into compiler
; 	SETMINR	TIMSX,rax
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
