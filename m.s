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


%ifdef	m32
	%define	cfp_b	4
	%define	cfp_c	4
%else
	%define	cfp_b	8
	%define	cfp_c	8
	%define		m64			// make m64 the default
%endif

	%include	"m.h"

%ifdef	m32
;	%define	rel
%endif

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

;	values below must agree with calltab defined in x32.hdr and also in osint/osint.h

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
	align 16
dummy:	d_word	0
reg_block:
reg_ia: d_word	0		; register ia (ebp)
reg_w0:	d_word	0        	; register wa (ecx)
reg_wa:	d_word	0        	; register wa (ecx)
reg_wb:	d_word 	0        	; register wb (ebx)
reg_wc:	d_word	0		; register wc
reg_xr:	d_word	0        	; register xr (xr)
reg_xl:	d_word	0        	; register xl (xl)
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
	mov	m(save_ia),ia
	mov	m(save_xl),xl
	mov	m(save_xr),xr
	mov	m(save_xs),xs
	mov	m(save_wa),wa
	mov	m(save_wb),wb
	mov	m(save_wc),wc
	mov	m(save_w0),w0
	ret

	global	restore_regs
restore_regs:
	;	restore regs, except for sp. that is caller's responsibility
	mov	ia,m(save_ia)
	mov	xl,m(save_xl)
	mov	xr,m(save_xr)
;	mov	xs,m(save_xs)	; caller restores sp
	mov	wa,m(save_wa)
	mov	wb,m(save_wb)
	mov	wc,m(save_wc)
	mov	w0,m(save_w0)
	ret
; ;
; ;       startup( char *dummy1, char *dummy2) - startup compiler
; ;
; ;       an osint c function calls startup to transfer control
; ;       to the compiler.
; ;
; ;       (xr) = basemem
; ;       (xl) = topmem - sizeof(word)
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
	pop     w0			; discard return
	call	stackinit		; initialize minimal stack
	mov     w0,m(compsp)	; get minimal's stack pointer
	mov m(reg_wa),w0		; startup stack pointer

	cld				; default to up direction for string ops
;        getoff  w0,dffnc               # get address of ppm offset
	mov     m(ppoff),w0	; save for use later

	mov     xs,m(osisp)	; switch to new c stack
	mov	m(minimal_id),calltab_start
	call	minimal			; load regs, switch stack, start compiler

;	stackinit  -- initialize lowspmin from sp.

;	input:  sp - current c stack
;		stacksiz - size of desired minimal stack in bytes

;	uses:	w0

;	output: register wa, sp, lowspmin, compsp, osisp set up per diagram:

;	(high)	+----------------+
;		|  old c stack   |
;	  	|----------------| <-- incoming sp, resultant wa (future xs)
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



lowspmin.a:	d_word	lowspmin

	global	stackinit
stackinit:
	mov	w0,xs
	mov     m(compsp),w0	; save as minimal's stack pointer
	sub	w0,m(stacksiz)	; end of minimal stack is where c stack will start
	mov     m(osisp),w0	; save new c stack pointer
	add	w0,cfp_b*100		; 100 words smaller for chk
	extern	lowspmin
	mov	m(lowspmin),w0
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
	mov     wa,m(reg_wa)	; restore registers
	mov	wb,m(reg_wb)
	mov     wc,m(reg_wc)	;
	mov	xr,m(reg_xr)
	mov	xl,m(reg_xl)

	mov     m(osisp),xs	; save osint stack pointer
	cmp     m(compsp),0	; is there a compiler stack?
	je      min1			; jump if none yet
	mov     xs,m(compsp)	; switch to compiler stack

 min1:
	mov     w0,m(minimal_id)	; get ordinal
;	call   m(calltab+w0*cfp_b)    ; off to the minimal code
	extern	start
	call	start

	mov     xs,m(osisp)	; switch to osint stack

	mov     m(reg_wa),wa	; save registers
	mov	m(reg_wb),wb
	mov	m(reg_wc),wc
	mov	m(reg_xr),xr
	mov	m(reg_xl),xl
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

	mov     m(reg_wa),wa      ; save registers
	mov	m(reg_wb),wb
	mov     m(reg_wc),wc      ; (also _reg_ia)
	mov	m(reg_xr),xr
	mov	m(reg_xl),xl
	mov	m(reg_ia),ia
	ret

syscall_exit:
	mov	m(_rc_),w0	; save return code from function
	mov     m(osisp),xs       ; save osint's stack pointer
	mov     xs,m(compsp)      ; restore compiler's stack pointer
	mov     wa,m(reg_wa)      ; restore registers
	mov	wb,m(reg_wb)
	mov     wc,m(reg_wc)      ;
	mov	xr,m(reg_xr)
	mov	ia,m(reg_ia)
	mov	xl,m(reg_xl)
	cld
	mov	w0,m(reg_pc)
	jmp	w0

	%macro	syscall	2
	pop     w0			; pop return address
	mov	m(reg_pc),w0
	call	syscall_init
;       save compiler stack and switch to osint stack
	mov     m(compsp),xs      ; save compiler's stack pointer
	mov     xs,m(osisp)       ; load osint's stack pointer
	call	%1
	call	syscall_exit
	%endmacro

	global sysax
	extern	zysax
sysax:	syscall	  zysax,1

	global sysbs
	extern	zysbs
sysbs:	syscall	  zysbs,2

	global sysbx
	extern	zysbx
sysbx:	mov	m(reg_xs),xs
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
sysex:	mov	m(reg_xs),xs
	syscall	zysex,13

	global sysfc
	extern	zysfc
sysfc:  pop     w0             ; <<<<remove stacked scblk>>>>
	lea	xs,[xs+wc*cfp_b]
	push	w0
	syscall	zysfc,14

	global sysgc
	extern	zysgc
sysgc:	syscall	zysgc,15

	global syshs
	extern	zyshs
syshs:	mov	m(reg_xs),xs
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
sysxi:	mov	m(reg_xs),xs
	syscall	zysxi,38

	%macro	callext	2
	extern	%1
	call	%1
	add	xs,%2		; pop arguments
	%endmacro

;	x64 hardware divide, expressed in form of minimal register mappings, requires dividend be
;	placed in w0, which is then sign extended into wc:w0. after the divide, w0 contains the
;	quotient, wc contains the remainder.
;
;       cvd__ - convert by division
;
;       input   ia = number <=0 to convert
;       output  ia / 10
;               wa ecx) = remainder + '0'
	global	cvd__
cvd__:
	extern	i_cvd
	mov	m(reg_ia),ia
	mov	m(reg_wa),wa
	call	i_cvd
	mov	ia,m(reg_ia)
	mov	wa,m(reg_wa)
	ret


;       dvi__ - divide ia (edx) by long in w0
	global	dvi__
dvi__:
	extern	i_dvi
	mov	m(reg_w0),w0
	call	i_dvi
	mov	ia,m(reg_ia)
	mov	al,byte [rel reg_fl]
	or	al,al
	ret

	global	rmi__
;       rmi__ - remainder of ia (edx) divided by long in w0
rmi__:
	jmp	ocode
	extern	i_rmi
	mov	m(reg_w0),w0
	call	i_rmi
	mov	ia,m(reg_ia)
	mov	al,byte [rel reg_fl]
	or	al,al
	ret

ocode:
        or      w0,w0         	; test for 0
        jz      setovr    	; jump if 0 divisor
        xchg    w0,ia         	; ia to w0, divisor to ia
        cdq                     ; extend dividend
        idiv    ia              ; perform division. w0=quotient, wc=remainder
	seto	byte [rel reg_fl]
	mov	ia,wc
	ret

setovr: mov     al,1		; set overflow indicator
	mov	byte [rel reg_fl],al
	ret

	%macro	real_op 2
	global	%1
	extern	%2
%1:
	mov	m(reg_rp),w0
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
	mov	m(reg_ia),ia
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
        mov     ax, word [ rel reg_ra+6]	; get top 2 bytes
        and     ax, 0x7ff0             	; check for infinity or nan
        add     ax, 0x10               	; set/clear overflow accordingly
	ret

	global	get_fp			; get frame pointer

get_fp:
         mov     w0,m(reg_xs)     ; minimal's xs
         add     w0,4           	; pop return from call to sysbx or sysxi
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
        pop     w0                      ; discard return
        pop     w0                     	; discard dummy
        pop     w0                     	; get lowest legal stack value

        add     w0,m(stacksiz)  	; top of compiler's stack
        mov     xs,w0                 	; switch to this stack
	call	stackinit               ; initialize minimal stack

                                        ; set up for stack relocation
        lea     w0,[rel tscblk+scstr]       ; top of saved stack
        mov     wb,m(lmodstk)    	; bottom of saved stack
        mov	wa,m(stbas)      ; wa = stbas from exit() time
        sub     wb,w0                 	; wb = size of saved stack
	mov	wc,wa
        sub     wc,wb                 	; wc = stack bottom from exit() time
	mov	wb,wa
        sub     wb,xs                 	; wb =  stbas - new stbas

        mov	m(stbas),xs       ; save initial sp
;        getoff  w0,dffnc               ; get address of ppm offset
        mov     m(ppoff),w0       ; save for use later
;
;       restore stack from tscblk.
;
        mov     xl,m(lmodstk)    	; -> bottom word of stack in tscblk
        lea     xr,[rel tscblk+scstr]      	; -> top word of stack
        cmp     xl,xr                 	; any stack to transfer?
        je      re3               	;  skip if not
	sub	xl,4
	std
re1:    lodsd                           ; get old stack word to w0
        cmp     w0,wc                 	; below old stack bottom?
        jb      re2               	;   j. if w0 < wc
        cmp     w0,wa                 	; above old stack top?
        ja      re2               	;   j. if w0 > wa
        sub     w0,wb                 	; within old stack, perform relocation
re2:    push    w0                     	; transfer word of stack
        cmp     xl,xr                 	; if not at end of relocation then
        jae     re1                     ;    loop back

re3:	cld
        mov     m(compsp),xs     	; save compiler's stack pointer
        mov     xs,m(osisp)      	; back to osint's stack pointer
        call   rereloc               	; relocate compiler pointers into stack
        mov	w0,m(statb)      	; start of static region to xr
	mov	m(reg_xr),w0
	mov	w0,minimal_insta
	call	minimal			; initialize static region

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

        mov	w0,m(stage)      	; is this a -w call?
	cmp	w0,4
        je            re4               ; yes, do a complete fudge

;
;       jump back with return value = normal_return
	xor	w0,w0			; set to zero to indicate normal return
	call	syscall_exit
	ret

;       here if -w produced load module.  simulate all the code that
;       would occur if we naively returned to sysbx.  clear the stack and
;       go for it.
;
re4:	mov	w0,m(stbas)
        mov     m(compsp),w0     	; empty the stack

;       code that would be executed if we had returned to makeexec:
;
        mov	m(gbcnt),0       	; reset garbage collect count
        call    zystm                 	; fetch execution time to reg_ia
        mov     w0,m(reg_ia)     	; set time into compiler
	extern	timsx
	mov	m(timsx),w0

;       code that would be executed if we returned to sysbx:
;
        push    m(outptr)        	; swcoup(outptr)
	extern 	swcoup
	call	swcoup
	add	xs,cfp_b

;       jump to minimal code to restart a save file.

	mov	w0,minimal_rstrt
	mov	m(minimal_id),w0
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
