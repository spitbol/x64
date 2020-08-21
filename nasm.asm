; copyright 1987-2012 robert b. k. dewar and mark emmer.

; copyright 2012-2015 david shields
;
; this file is part of macro spitbol.
;
;     macro spitbol is free software: you can redistribute it and/or modify
;     it under the terms of the gnu general public license as published by
;     the free software foundation, either version 2 of the license, or
;     (at your option) any later version.
;
;     macro spitbol is distributed in the hope that it will be useful,
;     but without any warranty; without even the implied warranty of
;     merchantability or fitness for a particular purpose.  see the
;     gnu general public license for more details.
;
;     you should have received a copy of the gnu general public license
;     along with macro spitbol.  if not, see <http://www.gnu.org/licenses/>.


;	ws is bits per word, cfp_b is bytes per word, cfp_c is characters per word


	%define	cfp_b	8
	%define	cfp_c	8

	%include "nasm.h"

	global	reg_block
	global	reg_w0
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

	global	reg_rp

	global	minimal
	extern	calltab
	extern	stacksiz

;	values below must agree with calltab defined in x64.hdr and also in osint/osint.h

minimal_relaj	equ	0
minimal_relcr	equ	1
minimal_reloc	equ	2
minimal_alloc	equ	3
minimal_alocs	equ	4
minimal_alost	equ	5
minimal_blkln	equ	6
minimal_insta	equ	7
minimal_rstrt	equ	8
minimal_start	equ	9
minimal_filnm	equ	10
minimal_dtype	equ	11
minimal_enevs	equ	10
minimal_engts	equ	12

%define globals 1                       ;asm globals defined here


;       ---------------------------------------

;       this file contains the assembly language routines that interface
;       the macro spitbol compiler written in 80386 assembly language to its
;       operating system interface functions written in c.

;       contents:

;       o overview
;       o global variables accessed by osint functions
;       o interface routines between compiler and osint functions
;       o c callable function startup
;       o c callable function get_fp
;       o c callable function restart
;       o c callable function makeexec
;       o routines for minimal opcodes chk and cvd
;       o math functions for integer multiply, divide, and remainder
;       o math functions for real operation

;       overview

;       the macro spitbol compiler relies on a set of operating system
;       interface functions to provide all interaction with the host
;       operating system.  these functions are referred to as osint
;       functions.  a typical call to one of these osint functions takes
;       the following form in the 80386 version of the compiler:

;               ...code to put arguments in registers...
;               call    sysxx           # call osint function
;             d_word    exit_1          # address of exit point 1
;             d_word    exit_2          # address of exit point 2
;               ...     ...             # ...
;             d_word    exit_n          # address of exit point n
;               ...instruction following call...

;       the osint function 'sysxx' can then return in one of n+1 ways:
;       to one of the n exit points or to the instruction following the
;       last exit.  this is not really very complicated - the call places
;       the return address on the stack, so all the interface function has
;       to do is add the appropriate offset to the return address and then
;       pick up the exit address and jump to it or do a normal return via
;       an ret instruction.

;       unfortunately, a c function cannot handle this scheme.  so, an
;       intermediary set of routines have been established to allow the
;       interfacing of c functions.  the mechanism is as follows:

;       (1) the compiler calls osint functions as described above.

;       (2) a set of assembly language interface routines is established,
;           one per osint function, named accordingly.  each interface
;           routine ...

;           (a) saves all compiler registers in global variables
;               accessible by c functions
;           (b) calls the osint function written in c
;           (c) restores all compiler registers from the global variables
;           (d) inspects the osint function's return value to determine
;               which of the n+1 returns should be taken and does so

;       (3) a set of c language osint functions is established, one per
;           osint function, named differently than the interface routines.
;           each osint function can access compiler registers via global
;           variables.  no arguments are passed via the call.

;           when an osint function returns, it must return a value indicating
;           which of the n+1 exits should be taken.  these return values are
;           defined in header file 'inter.h'.

;       note:  in the actual implementation below, the saving and restoring
;       of registers is actually done in one common routine accessed by all
;       interface routines.

;       other notes:

;       some c ompilers transform "internal" global names to
;       "external" global names by adding a leading underscore at the front
;       of the internal name.  thus, the function name 'osopen' becomes
;       '_osopen'.  however, not all c compilers follow this convention.

;       global variables

	segment	.data
;
; ; words saved during exit(-3)
; ;
	align cfp_b
reg_block:
reg_ia: d_word	0		; register ia (ebp)
reg_w0:	d_word	0        	; register w0 (rax)
reg_wa:	d_word	0        	; register wa (rcx)
reg_wb:	d_word 	0        	; register wb (rbx)
reg_wc:	d_word	0		; register wc (rdx)
reg_xl:	d_word	0        	; register xl (rsi)
reg_xr:	d_word	0        	; register xr (rdi)
reg_cp:	d_word	0        	; register cp
reg_ra:	d_real 	0.0  		; register ra

; these locations save information needed to return after calling osint
; and after a restart from exit()

reg_pc: d_word      0               ; return pc from caller
reg_xs:	d_word	0		; minimal stack pointer

;	r_size  equ       $-reg_block
; use computed value for nasm conversion, put back proper code later
r_size	equ	10*cfp_b
reg_size:	dd   r_size

; end of words saved during exit(-3)

; reg_rp is used to pass pointer to real operand for real arithmetic
reg_rp:	d_word	0

; reg_fl is used to communicate condition codes between minimal and c code.
	global	reg_fl
reg_fl:	db	0		; condition code register for numeric operations

	align	8
;  constants

	global	ten
ten:    d_word      10              ; constant 10
	global  inf
inf:	d_word	0
	d_word      0x7ff00000      ; double precision infinity

	global	sav_block
;sav_block: times r_size db 0     	; save minimal registers during push/pop reg
sav_block: times 44 db 0     		; save minimal registers during push/pop reg

	align cfp_b
	global	ppoff
ppoff:  d_word      0               	; offset for ppm exits
	global	compsp
compsp: d_word      0               	; compiler's stack pointer
	global	sav_compsp
sav_compsp:
	d_word      0               	; save compsp here
	global	osisp
osisp:  d_word      0               	; osint's stack pointer
	global	_rc_
_rc_:	dd   0				; return code from osint procedure

	align	cfp_b
	global	save_cp
	global	save_xl
	global	save_xr
	global	save_xs
	global	save_wa
	global	save_wb
	global	save_wc
	global	save_w0
save_cp:	d_word	0		; saved cp value
save_ia:	d_word	0		; saved ia value
save_xl:	d_word	0		; saved xl value
save_xr:	d_word	0		; saved xr value
save_xs:	d_word	0		; saved sp value
save_wa:	d_word	0		; saved wa value
save_wb:	d_word	0		; saved wb value
save_wc:	d_word	0		; saved wc value
save_w0:	d_word	0		; saved w0 value

	global	minimal_id
minimal_id:	d_word	0		; id for call to minimal from c. see proc minimal below.

;
%define setreal 0

;       setup a number of internal addresses in the compiler that cannot
;       be directly accessed from within c because of naming difficulties.

	global  id1
id1:	dd   0
%if setreal == 1
	d_word       2

       d_word       1
	db  "1x\x00\x00\x00"
%endif

	global  id1blk
id1blk	d_word   152
      	d_word    0
	times   152 db 0

	global  id2blk
id2blk	d_word   152
      	d_word    0
	times   152 db 0

	global  ticblk
ticblk:	d_word   0
      d_word    0

	global  tscblk
tscblk:	 d_word   512
      d_word    0
	times   512 db 0

;       standard input buffer block.

	global  inpbuf
inpbuf:	d_word	0			; type word
      d_word    0               	; block length
      d_word    1024            	; buffer size
      d_word    0               	; remaining chars to read
      d_word    0               	; offset to next character to read
      d_word    0               	; file position of buffer
      d_word    0               	; physical position in file
	times   1024 db 0        	; buffer

	global  ttybuf
ttybuf:	d_word    0     ; type word
	d_word    0               	; block length
	d_word    260             	; buffer size  (260 ok in ms-dos with cinread())
	d_word    0               	; remaining chars to read
	d_word    0               	; offset to next char to read
	d_word    0               	; file position of buffer
	d_word    0               	; physical position in file
	times   260 db 0         	; buffer
;
;       save and restore minimal and interface registers on stack.
;       used by any routine that needs to call back into the minimal
;       code in such a way that the minimal code might trigger another
;       sysxx call before returning.
;
;       note 1:  pushregs returns a collectable value in xl, safe
;       for subsequent call to memory allocation routine.
;
;       note 2:  these are not recursive routines.  only reg_xl is
;       saved on the stack, where it is accessible to the garbage
;       collector.  other registers are just moved to a temp area.
;
;       note 3:  popregs does not restore reg_cp, because it may have
;       been modified by the minimal routine called between pushregs
;       and popregs as a result of a garbage collection.  calling of
;       another sysxx routine in between is not a problem, because
;       cp will have been preserved by minimal.
;
;       note 4:  if there isn't a compiler stack yet, we don't bother
;       saving xl.  this only happens in call of nextef from sysxi when
;       reloading a save file.
;
;
	global	save_regs
save_regs:
	mov	m_word [save_ia],rdx
	mov	m_word [save_xl],rsi
	mov	m_word [save_xr],rdi
	mov	m_word [save_xs],rsp
	mov	m_word [save_wa],rcx
	mov	m_word [save_wb],rbx
	mov	m_word [save_wc],rdx
	mov	m_word [save_w0],rax
	ret

	global	restore_regs
restore_regs:
	;	restore regs, except for sp. that is caller's responsibility
	mov	rdx,m_word [save_ia]
	mov	rsi,m_word [save_xl]
	mov	rdi,m_word [save_xr]
;	mov	rsp,m_word [save_xs	; caller restores sp]
	mov	rcx,m_word [save_wa]
	mov	rbx,m_word [save_wb]
	mov	rdx,m_word [save_wc]
	mov	rax,m_word [save_w0]
	ret
; ;
; ;       startup( char *dummy1, char *dummy2) - startup compiler
; ;
; ;       an osint c function calls startup to transfer control
; ;       to the compiler.
; ;
; ;       (rdi) = basemem
; ;       (rsi) = topmem - sizeof(word)
; ;
; ;	note: this function never returns.
; ;
;
	global	startup
;   ordinals for minimal calls from assembly language.

;   the order of entries here must correspond to the order of
;   calltab entries in the inter assembly language module.

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

startup:
	pop     rax			; discard return
	call	stackinit		; initialize minimal stack
	mov     rax,m_word [compsp]	; get minimal's stack pointer
	mov m_word [reg_wa],rax		; startup stack pointer

	cld				; default to up direction for string ops
;        getoff  rax,dffnc               # get address of ppm offset
	mov     m_word [ppoff],rax	; save for use later

	mov     rsp,m_word [osisp]	; switch to new c stack
	mov	m_word [minimal_id],calltab_start
	call	minimal			; load regs, switch stack, start compiler

;	stackinit  -- initialize lowspmin from sp.

;	input:  sp - current c stack
;		stacksiz - size of desired minimal stack in bytes

;	uses:	rax

;	output: register wa, sp, lowspmin, compsp, osisp set up per diagram:

;	(high)	+----------------+
;		|  old c stack   |
;	  	|----------------| <-- incoming sp, resultant wa (future rsp)
;		|	     ^	 |
;		|	     |	 |
;		/ stacksiz bytes /
;		|	     |	 |
;		|            |	 |
;		|----------- | --| <-- resultant lowspmin
;		| 400 bytes  v   |
;	  	|----------------| <-- future c stack pointer, osisp
;		|  new c stack	 |
;	(low)	|                |




	global	stackinit
stackinit:
	mov	rax,rsp
	mov     m_word [compsp],rax	; save as minimal's stack pointer
	sub	rax,m_word [stacksiz]	; end of minimal stack is where c stack will start
	mov     m_word [osisp],rax	; save new c stack pointer
	add	rax,cfp_b*100		; 100 words smaller for chk
	extern	lowspmin
	mov	m_word [lowspmin],rax
	ret

;       mimimal -- call minimal function from c

;       usage:  extern void minimal(word callno)

;       where:
;         callno is an ordinal defined in osint.h, osint.inc, and calltab.

;       minimal registers wa, wb, wc, xr, and xl are loaded and
;       saved from/to the register block.

;       note that before restart is called, we do not yet have compiler
;       stack to switch to.  in that case, just make the call on the
;       the osint stack.

 minimal:
;         pushad			; save all registers for c
	mov     rcx,m_word [reg_wa]	; restore registers
	mov	rbx,m_word [reg_wb]
	mov     rdx,m_word [reg_wc]	;
	mov	rdi,m_word [reg_xr]
	mov	rsi,m_word [reg_xl]

	mov     m_word [osisp],rsp	; save osint stack pointer
	cmp     m_word [compsp],0	; is there a compiler stack?
	je      min1			; jump if none yet
	mov     rsp,m_word [compsp]	; switch to compiler stack

 min1:
	mov     rax,m_word [minimal_id]	; get ordinal
	call   m_word [calltab+rax*cfp_b]    ; off to the minimal code

	mov     rsp,m_word [osisp]	; switch to osint stack

	mov     m_word [reg_wa],rcx	; save registers
	mov	m_word [reg_wb],rbx
	mov	m_word [reg_wc],rdx
	mov	m_word [reg_xr],rdi
	mov	m_word [reg_xl],rsi
	ret


	section		.data
	align         cfp_b
	global	hasfpu
hasfpu:	d_word	0
	global	cprtmsg
cprtmsg:
	db          ' copyright 1987-2012 robert b. k. dewar and mark emmer.',0,0


;       interface routines

;       each interface routine takes the following form:

;               sysxx   call    ccaller ; call common interface
;                     d_word    zysxx   ; dd      of c osint function
;                       db      n       ; offset to instruction after
;                                       ;   last procedure exit

;       in an effort to achieve portability of c osint functions, we
;       do not take take advantage of any "internal" to "external"
;       transformation of names by c compilers.  so, a c osint function
;       representing sysxx is named _zysxx.  this renaming should satisfy
;       all c compilers.

;       important  one interface routine, sysfc, is passed arguments on
;       the stack.  these items are removed from the stack before calling
;       ccaller, as they are not needed by this implementation.

;       ccaller is called by the os interface routines to call the
;       real c os interface function.

;       general calling sequence is

;               call    ccaller
;             d_word    address_of_c_function
;               db      2*number_of_exit_points

;       control is never returned to a interface routine.  instead, control
;       is returned to the compiler (the caller of the interface routine).

;       the c function that is called must always return an integer
;       indicating the procedure exit to take or that a normal return
;       is to be performed.

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


	segment	.data
call_adr:	d_word	0
	segment	.text

syscall_init:
;       save registers in global variables

	mov     m_word [reg_wa],rcx      ; save registers
	mov	m_word [reg_wb],rbx
	mov     m_word [reg_wc],rdx      ; (also _reg_ia)
	mov	m_word [reg_xr],rdi
	mov	m_word [reg_xl],rsi
	mov	m_word [reg_ia],ia
	ret

syscall_exit:
	mov	m_word [_rc_],rax	; save return code from function
	mov     m_word [osisp],rsp       ; save osint's stack pointer
	mov     rsp,m_word [compsp]      ; restore compiler's stack pointer
	mov     rcx,m_word [reg_wa]      ; restore registers
	mov	rbx,m_word [reg_wb]
	mov     rdx,m_word [reg_wc]      ;
	mov	rdi,m_word [reg_xr]
	mov	rsi,m_word [reg_xl]
	mov	ia,m_word [reg_ia]
	cld
	mov	rax,m_word [reg_pc]
	jmp	rax

	%macro	syscall	2
	pop     rax			; pop return address
	mov	m_word [reg_pc],rax
	call	syscall_init
;       save compiler stack and switch to osint stack
	mov     m_word [compsp],rsp      ; save compiler's stack pointer
	mov     rsp,m_word [osisp]       ; load osint's stack pointer
	call	%1
	jmp	syscall_exit		; was a call for debugging purposes, but that would cause a crash when the 
					; compilers stack pointer blew up
	%endmacro

	global sysax
	extern	zysax
sysax:	syscall	  zysax,1

	global sysbs
	extern	zysbs
sysbs:	syscall	  zysbs,2

	global sysbx
	extern	zysbx
sysbx:	mov	m_word [reg_xs],rsp
	syscall	zysbx,2

;        global syscr
;	extern	zyscr
;syscr:  syscall    zyscr ;    ,0

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
sysex:	mov	m_word [reg_xs],rsp
	syscall	zysex,13

	global sysfc
	extern	zysfc
sysfc:  pop     rax             ; <<<<remove stacked scblk>>>>
	lea	rsp,[rsp+rdx*cfp_b]
	push	rax
	syscall	zysfc,14

	global sysgc
	extern	zysgc
sysgc:	syscall	zysgc,15

	global syshs
	extern	zyshs
syshs:	mov	m_word [reg_xs],rsp
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
sysxi:	mov	m_word [reg_xs],rsp
	syscall	zysxi,38

	%macro	callext	2
	extern	%1
	call	%1
	add	rsp,%2		; pop arguments
	%endmacro

;	x64 hardware divide, expressed in form of minimal register mappings, requires dividend be
;	placed in rax, which is then sign extended into rdx:rax. after the divide, rax contains the
;	quotient, rdx contains the remainder.
;
;       cvd__ - convert by division
;
;       input   ia = number <=0 to convert
;       output  ia / 10
;               wa ecx) = remainder + '0'
	global	cvd__
cvd__:
	extern	i_cvd
	mov	m_word [reg_ia],ia
	mov	m_word [reg_wa],rcx
	call	i_cvd
	mov	ia,m_word [reg_ia]
	mov	rcx,m_word [reg_wa]
	ret


ocode:
        or      rax,rax         	; test for 0
        jz      setovr    	; jump if 0 divisor
        xchg    rax,ia         	; ia to rax, divisor to ia
        cdq                     ; extend dividend
        idiv    ia              ; perform division. rax=quotient, rdx=remainder
	seto	byte [reg_fl]
	mov	ia,rdx
	ret

setovr: mov     al,1		; set overflow indicator
	mov	byte [reg_fl],al
	ret

	%macro	real_op 2
	global	%1
	extern	%2
%1:
	mov	m_word [reg_rp],rax
	call	%2
	ret
%endmacro

	real_op	ldr_,f_ldr
	real_op	str_,f_str
	real_op	adr_,f_adr
	real_op	sbr_,f_sbr
	real_op	mlr_,f_mlr
	real_op	dvr_,f_dvr
	real_op	ngr_,f_ngr
	real_op cpr_,f_cpr

	%macro	int_op 2
	global	%1
	extern	%2
%1:
	mov	m_word [reg_ia],ia
	call	%2
	ret
%endmacro

	int_op itr_,f_itr
	int_op rti_,f_rti

	%macro	math_op 2
	global	%1
	extern	%2
%1:
	call	%2
	ret
%endmacro

	math_op	atn_,f_atn
	math_op	chp_,f_chp
	math_op	cos_,f_cos
	math_op	etx_,f_etx
	math_op	lnf_,f_lnf
	math_op	sin_,f_sin
	math_op	sqr_,f_sqr
	math_op	tan_,f_tan

;       ovr_ test for overflow value in ra
	global	ovr_
ovr_:
        mov     ax, word [reg_ra+6]	; get top 2 bytes
        and     ax, 0x7ff0             	; check for infinity or nan
        add     ax, 0x10               	; set/clear overflow accordingly
	ret

	global	get_fp			; get frame pointer

get_fp:
         mov     rax,m_word [reg_xs]     ; minimal's xs
         add     rax,4           	; pop return from call to sysbx or sysxi
         ret                    	; done

	extern	rereloc

	global	restart
	extern	stbas
	extern	statb
	extern	stage
	extern	gbcnt
	extern	lmodstk
	extern	startbrk
	extern	outptr
	extern	swcoup
;	scstr is offset to start of string in scblk, or two words
scstr	equ	cfp_c+cfp_c

;
restart:
        pop     rax                      ; discard return
        pop     rax                     	; discard dummy
        pop     rax                     	; get lowest legal stack value

        add     rax,m_word [stacksiz]  	; top of compiler's stack
        mov     rsp,rax                 	; switch to this stack
	call	stackinit               ; initialize minimal stack

                                        ; set up for stack relocation
        lea     rax,[tscblk+scstr]       ; top of saved stack
        mov     rbx,m_word [lmodstk]    	; bottom of saved stack
        mov	rcx,m_word [stbas]      ; rcx = stbas from exit() time
        sub     rbx,rax                 	; wb = size of saved stack
	mov	rdx,rcx
        sub     rdx,rbx                 	; rdx = stack bottom from exit() time
	mov	rbx,rcx
        sub     rbx,rsp                 	; rbx =  stbas - new stbas

        mov	m_word [stbas],rsp       ; save initial sp
;        getoff  rax,dffnc               ; get address of ppm offset
        mov     m_word [ppoff],rax       ; save for use later
;
;       restore stack from tscblk.
;
        mov     rsi,m_word [lmodstk]    	; -> bottom word of stack in tscblk
        lea     rdi,[tscblk+scstr]      	; -> top word of stack
        cmp     rsi,rdi                 	; any stack to transfer?
        je      re3               	;  skip if not
	sub	rsi,4
	std
re1:    lodsd                           ; get old stack word to rax
        cmp     rax,rdx                 	; below old stack bottom?
        jb      re2               	;   j. if rax < rdx
        cmp     rax,rcx                 	; above old stack top?
        ja      re2               	;   j. if rax > rcx
        sub     rax,rbx                 	; within old stack, perform relocation
re2:    push    rax                     	; transfer word of stack
        cmp     rsi,rdi                 	; if not at end of relocation then
        jae     re1                     ;    loop back

re3:	cld
        mov     m_word [compsp],rsp     	; save compiler's stack pointer
        mov     rsp,m_word [osisp]      	; back to osint's stack pointer
        call   rereloc               	; relocate compiler pointers into stack
        mov	rax,m_word [statb]      	; start of static region to rdi
	mov	m_word [reg_xr],rax
	mov	rax,minimal_insta
	jmp	minimal			; initialize static region 
					; was a call, but there is nothing to return to.  This was probably for 
					; debugging purposes.

;
;       now pretend that we're executing the following c statement from
;       function zysxi:
;
;               return  normal_return;
;
;       if the load module was invoked by exit(), the return path is
;       as follows:  back to ccaller, back to s$ext following sysxi call,
;       back to user program following exit() call.
;
;       alternately, the user specified -w as a command line option, and
;       sysbx called makeexec, which in turn called sysxi.  the return path
;       should be:  back to ccaller, back to makeexec following sysxi call,
;       back to sysbx, back to minimal code.  if we allowed this to happen,
;       then it would require that stacked return address to sysbx still be
;       valid, which may not be true if some of the c programs have changed
;       size.  instead, we clear the stack and execute the restart code that
;       simulates resumption just past the sysbx call in the minimal code.
;       we distinguish this case by noting the variable stage is 4.
;
        call   startbrk			; start control-c logic

        mov	rax,m_word [stage]      	; is this a -w call?
	cmp	rax,4
        je            re4               ; yes, do a complete fudge

;
;       jump back with return value = normal_return
	xor	rax,rax			; set to zero to indicate normal return
	call	syscall_exit
	ret

;       here if -w produced load module.  simulate all the code that
;       would occur if we naively returned to sysbx.  clear the stack and
;       go for it.
;
re4:	mov	rax,m_word [stbas]
        mov     m_word [compsp],rax     	; empty the stack

;       code that would be executed if we had returned to makeexec:
;
        mov	m_word [gbcnt],0       	; reset garbage collect count
        call    zystm                 	; fetch execution time to reg_ia
        mov     rax,m_word [reg_ia]     	; set time into compiler
	extern	timsx
	mov	m_word [timsx],rax

;       code that would be executed if we returned to sysbx:
;
        push    m_word [outptr]        	; swcoup(outptr)
	extern 	swcoup
	call	swcoup
	add	rsp,cfp_b

;       jump to minimal code to restart a save file.

	mov	rax,minimal_rstrt
	mov	m_word [minimal_id],rax
        call	minimal			; no return

%ifdef z_trace
	extern	zz_ra
	global	zzz
	extern	zz,zz_cp,zz_xl,zz_xr,zz_wa,zz_wb,zz_wc,zz_w0
zzz:
	pushf
	call	save_regs
	call	zz
	call	restore_regs
	popf
	ret
%endif
