	bits	64

;	register assignments (all are preserved over call to C procedure, except for W0, which
;	is only used very locally, and so can be destroyed by C procedure).
;XL=ESI  XR=EDI W0=EAX WA=ECX WB=EBX WC=EDX IA=EDX XS=ESP CP=EBP   
;XL=rbx  XR=rbp W0=r11 WA=r12 WB=r13 WC=r14 IA=r14 XS=r15 CP=mem


	%define	XL	RSI
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

;	%define	IA	r14
;	%define	WA	r12
;	%define	WB	r13
;	%define	WC	r14
;	%define	IA	r14
;	%define	XS	rsp
;	%define	XL	rbx
;	%define XR	rbp
;	%define XT	r15
;	%define	W0	rax

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
	extern	at_note
	extern	at_note1
	extern	at_note2
	extern	at_arg
	extern	at_num
	extern	at_num_id
	extern	at_sys_id
	extern	at_sys

; copyright 1987-2012 robert b. k. dewar and mark emmer.
;
; this file is part of macro spitbol.
;
;     macro spitbol is free software: you can rrdistribute it and/or modify
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
;
%define globals 1                       ;asm globals defined here

;
;       ---------------------------------------
;
;       this file contains the assembly language routines that interface
;       the macro spitbol compiler written in 80386 assembly language to its
;       operating system interface functions written in c.
;
;       contents:
;
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
;               call    sysxx            call osint function
;               dq      exit_1           address of exit point 1
;               dq      exit_2           address of exit point 2
;               ...     ...              ...
;               dq      exit_n           address of exit point n
;               ...instruction following call...
;
;       the osint function 'sysxx' can then return in one of n+1 ways:
;       to one of the n exit points or to the instruction following the
;       last exit.  this is not really very complicated - the call places
;       the return address on the stack, so all the interface function has
;       to do is add the appropriate offset to the return address and then
;       pick up the exit address and jump to it or do a normal return via
;       an ret instruction.
;
;       unfortunately, a c function cannot handle this scheme.  so, an
;       intermrdiary set of routines have been established to allow the
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
;       other notes:
;
;       some c ompilers transform "internal" global names to
;       "external" global names by adding a leading underscore at the front
;       of the internal name.  thus, the function name 'osopen' becomes
;       '_osopen'.  however, not all c compilers follow this convention.
;
;------------
;
;       global variables
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
;       .include "extrn386.inc"

; ; words saved during exit(-3)

; x86 doesn't have instructions equivalent to
; x32 pushad and popad, so use macros to
; provide the desired function
	align	8
	segment	.data

W0_save:	dq	0
WA_save:	dq	0
WB_save:	dq	0
WC_save:	dq	0
XL_save:	dq	0
XR_save:	dq	0
XS_save:	dq	0

	%macro	pushaq	0
	mov	qword [W0_save],W0
	mov	qword [WB_save],WB
	mov	qword [WA_save],WA
	mov	qword [WC_save],WC
	mov	qword [XR_save],XR
	mov	qword [XL_save],XL
	mov	qword [XS_save],XS
	%endmacro


	%macro	popaq 0
	mov	W0,qword [W0_save]
	mov	WA,qword [WA_save]
	mov	WB,qword [WB_save]
	mov	WC,qword [WC_save]
	mov	XL,qword [XL_save]
	mov	XR,qword [XR_save]
	mov	XS,qword [XS_save]
	%endmacro
        align 8
reg_block:
reg_wa:	dq	0        ; register wa (ecx)
reg_wb:	dq 	0        ; register wb (ebx)
reg_ia:
reg_wc:	dq	0		; register wc & ia (edx)
reg_xr:	dq	0        ; register xr (edi)
reg_xl:	dq	0        ; register xl (esi)
reg_cp:	dq	0        ; register cp
reg_ra	dq 	0.0  ; register ra
reg_w0	dq	0	; register w0
;
; these locations save information needed to return after calling osint
; and after a restart from exit()
;
reg_pc: dq      0               ; return pc from caller
reg_pp: dq      0               ; number of bytes of ppms
reg_xs:	dq	0;		 minimal stack pointer
;
;	r_size  equ       $-reg_block
; use computed value for nasm conversion, put back proper code later
r_size	equ	88
reg_size:	dq   r_size

;
; end of words saved during exit(-3)
;

;
;  constants
;
	global	ten
ten:    dq      10              ; constant 10
        global  inf
inf:	dq	0
        dq      0x7ff00000      ; double precision infinity

	global	sav_block
;sav_block: times r_size db 0     ; save minimal registers during push/pop reg
sav_block: times 88 db 0     ; save minimal registers during push/pop reg
;
        align 8
	global	compsp
compsp: dq      0               ; compiler's stack pointer
	global	sav_compsp
sav_compsp:
        dq      0               ; save compsp here
	global	osisp
osisp:  dq      0               ; osint's stack pointer
	global	_rc_
_rc_:	dq   0	; return code from osint procedure
;
%define setreal 0
;
;       setup a number of internal addresses in the compiler that cannot
;       be directly accessed from within c because of naming difficulties.
;
        global  ID1
ID1:	dq   0
%if setreal == 1
        dq       2

        dq       1
        db  "1x\x00\x00\x00"
%endif
;
        global  ID2BLK
ID2BLK:	dq   52
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
;       standard input buffer block.
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
        dq      260             ; buffer size  (260 ok in ms-dos with cinread())
        dq      0               ; remaining chars to read
        dq      0               ; offset to next char to read
        dq      0               ; file position of buffer
        dq      0               ; physical position in file
        times   260 db 0         ; buffer
; ;-----------
; ;
; ;       save and restore minimal and interface registers on stack.
; ;       used by any routine that needs to call back into the minimal
; ;       code in such a way that the minimal code might trigger another
; ;       sysxx call before returning.
; ;
; ;       note 1:  pushregs returns a collectable value in xl, safe
; ;       for subsequent call to memory allocation routine.
; ;
; ;       note 2:  these are not recursive routines.  only reg_xl is
; ;       saved on the stack, where it is accessible to the garbage
; ;       collector.  other registers are just moved to a temp area.
; ;
; ;       note 3:  if there isn't a compiler stack yet, we don't bother
; ;       saving xl.  this only happens in call of nextef from sysxi when
; ;       reloading a save file.
; ;
; ;
	global	pushregs
pushregs:
	pushaq
	lea	rsi,[reg_block]
	lea	rdi,[sav_block]
	mov	WA,r_size/8
	cld
   rep	movsd

        mov     rdi,qword [compsp]
        or      rdi,rdi                         ; is there a compiler stack
        je      push1                     ; jump if none yet
        sub     rdi,8                           ;push onto compiler's stack
        mov     rsi,qword [reg_xl]                      ;collectable xl
	mov	[rdi],rsi
        mov     qword [compsp],rdi                      ;smashed if call osint again (sysgc)
        mov     qword [sav_compsp],rdi                  ;used by popregs

push1:	popaq
	ret

	global	popregs
popregs:
	pushaq
	cld
	lea	rsi,[sav_block]
        lea     rdi,[reg_block]                   ;unload saved registers
	mov	WA,r_size/8
   rep  movsd                                   ;restore from temp area

        mov     rdi,qword [sav_compsp]                  ;saved compiler's stack
        or      rdi,rdi                         ;is there one?
        je      pop1                      ;jump if none yet
        mov     rsi,qword [rdi]                       ;retrieve collectable xl
        mov     qword [reg_xl],rsi                      ;update xl
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


startup:
        pop     W0                     ; pop return address (this procedure never returns)
	mov	qword[at_arg],XS
	call	at_num
	call	stackinit               ; initialize minimal stack
        mov     W0,qword [compsp]              ; get minimal's stack pointer
        mov qword[reg_wa],W0                     ; startup stack pointer

	cld                             ; default to up direction for string ops
;        getoff  W0,dffnc                get address of ppm offset
        mov     XS,qword [osisp]               ; switch to new c stack
	mov	WA,qword [compsp]
	mov	rsp,WA
	push	calltab_start
	call	minimal			; load regs, switch stack, start compiler

;
;
;
;
;-----------
;
;	stackinit  -- initialize lowspmin from sp.
;
;	input:  XS - current c stack
;		stacksiz - size of drsired minimal stack in bytes
;
;	uses:	W0
;
;	output: register wa, XS, lowspmin, compsp, osisp set up per diagram:
;
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
;
;
;

	global	stackinit
stackinit:
	mov	W0,XS
        mov     qword [compsp],W0              ; save as minimal's stack pointer
	sub	W0,qword [stacksiz]            ; end of minimal stack is where c stack will start
        mov     qword [osisp],W0               ; save new c stack pointer
	add	W0,8*100               ; 100 words smaller for chk
	extern	lowspmin
	mov	qword [lowspmin],W0
	ret

;
;-----------
;
;       mimimal -- call minimal function from c
;
;       usage:  extern void minimal(word callno)
;
;       where:
;         callno is an ordinal defined in osint.h, osint.inc, and calltab.
;
;       minimal registers wa, wb, wc, xr, and xl are loaded and
;       saved from/to the register block.
;
;       note that before restart is called, we do not yet have compiler
;       stack to switch to.  in that case, just make the call on the
;       the osint stack.
;

 minimal:
        mov     W0,qword [XS+32+8]          ; get ordinal
        mov     WA,qword [reg_wa]              ; restore registers
 	mov	WB,qword [reg_wb]
        mov     WC,qword [reg_wc]              ; (also _reg_ia)
 	mov	rdi,qword [reg_xr]
 	mov	rsi,qword [reg_xl]
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
	db          ' copyright 1987-2012 robert b. k. dewar and mark emmer.',0,0


;       SYSCALL macro provides the inteface for calling OSINT procedures from Minimal.

;       Control IS NEVER returned to a interface routine.  Instead, control
;       is returned to the compiler (THE caller of the interface routine).

;       The C function that is called MUST ALWAYS return an integer
;	in EAX giving the exit (PPM) value, which is zero for normal return, or else
;	the number of the PPM branch to be taken.

	segment	.text

syscall_init:
;       save registers in global variables

        mov     qword [reg_wa],WA              ; save registers
	mov	qword [reg_wb],WB
        mov     qword [reg_wc],WC              ; (also _reg_ia)
	mov	qword [reg_xr],XR
	mov	qword [reg_xl],XL
	ret

syscall_exit:
	mov	qword [_rc_],rax		; save return code from function
 	mov     qword [osisp],XS               ; save OSINT's stack pointer
        mov     WA,qword [reg_wa]              ; restore registers
	mov	WB,qword [reg_wb]
        mov     WC,qword [reg_wc]              ; (also reg_ia)
	mov	XL,qword [reg_xl]
	mov	XR,qword [reg_xr]
        mov     XS,qword [compsp]              ; restore compiler's stack pointer
	cld
	mov	W0,qword [reg_pc]
	jmp	W0
	
	%macro	syscall	2
        pop     W0                     ; pop return address
	mov	qword [reg_pc],W0
	call	syscall_init
;       save compiler stack and switch to OSINT stack
        mov     qword [compsp],XS              ; save compiler's stack pointer
        mov     XS,qword [osisp]               ; load OSINT's stack pointer
	extern	%1
	mov	qword [at_sys_id],%2
	call	at_sys
	call	%1
	call	syscall_exit
	%endmacro

        global sysax
sysax:	syscall	  zysax,1

        global sysbs
sysbs:	syscall	  zysbs,2

        global sysbx
sysbx:	mov	qword [reg_xs],XS
	syscall	zysbx,2

;        global syscr
;SYSCR:  syscall    zyscr ;    ,0
;
        global sysdc
sysdc:	syscall	zysdc,4

        global sysdm
sysdm:	syscall	zysdm,5

        global sysdt
sysdt:	syscall	zysdt,6

        global sysea
sysea:	syscall	zysea,7

        global sysef
sysef:	syscall	zysef,8

        global sysej
sysej:	syscall	zysej,9

        global sysem
sysem:	syscall	zysem,10

        global sysen
sysen:	syscall	zysen,11

        global sysep
sysep:	syscall	zysep,12

        global sysex
sysex:	mov	qword [reg_xs],XS
	syscall	zysex,13

        global sysfc
sysfc:  pop     W0             ; <<<<remove stacked SCBLK>>>>
	lea	XS,[XS+WC*4]
	push	W0
	syscall	zysfc,14

        global sysgc
sysgc:	syscall	zysgc,15

        global syshs
syshs:	mov	qword [reg_xs],XS
	syscall	zyshs,16

        global sysid
sysid:	syscall	zysid,17

        global sysif
sysif:	syscall	zysif,18

        global sysil
sysil:  syscall zysil,19

        global sysin
sysin:	syscall	zysin,20

        global sysio
sysio:	syscall	zysio,21

        global sysld
sysld:  syscall zysld,22

        global sysmm
sysmm:	syscall	zysmm,23

        global sysmx
sysmx:	syscall	zysmx,24

        global sysou
sysou:	syscall	zysou,25

        global syspi
syspi:	syscall	zyspi,26

        global syspl
syspl:	syscall	zyspl,27

        global syspp
syspp:	syscall	zyspp,28

        global syspr
syspr:	syscall	zyspr,29

        global sysrd
sysrd:	syscall	zysrd,30

        global sysri
sysri:	syscall	zysri,32

        global sysrw
sysrw:	syscall	zysrw,33

        global sysst
sysst:	syscall	zysst,34

        global systm
systm:	syscall	zystm,35

        global systt
systt:	syscall	zystt,36

        global sysul
sysul:	syscall	zysul,37

        global sysxi
sysxi:	mov	qword [reg_xs],XS

	syscall	zysxi,38
	%macro	callext	2
	extern	%1
	call	%1
	add	XS,%2	; pop arguments
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
	push	rdx
        push    qword [reg_ra+4]             ; ra msh
        push    qword [reg_ra]               ; ra lsh
        push    qword [W0+4]               ; arg msh
        push    qword [W0]                 ; arg lsh
        callext f_add,16                        ; perform op
%if fretst0
	fstp	qword [reg_ra]
        pop     rdx                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     qword [reg_ra+4], rdx         ; result msh
        mov     qword [reg_ra], W0           ; result lsh
        pop     rdx                             ; restore regs
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
	push	rdx
        push    qword [reg_ra+4]             ; ra msh
        push    qword [reg_ra]               ; ra lsh
        push    qword [W0+4]               ; arg msh
        push    qword [W0]                 ; arg lsh
        callext f_sub,16                        ; perform op
%if fretst0
	fstp	qword [reg_ra]
        pop     rdx                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     qword [reg_ra+4, rdx         ; result msh
        mov     qword [reg_ra, W0           ; result lsh
        pop     rdx                             ; restore regs
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
	push	rdx
        push    qword [reg_ra+4]              ; ra msh
        push    qword [reg_ra]                ; ra lsh
        push    qword [W0+4]               ; arg msh
        push    qword [W0]                 ; arg lsh
        callext f_mul,16                        ; perform op
%if fretst0
	fstp	qword [reg_ra]
        pop     rdx                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     qword [reg_ra+4], rdx         ; result msh
        mov     qword [reg_ra], W0           ; result lsh
        pop     rdx                             ; restore regs
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
	push	rdx
        push    qword [reg_ra+4]              ; ra msh
        push    qword [reg_ra]                ; ra lsh
        push    qword [W0+4]               ; arg msh
        push    qword [W0]                 ; arg lsh
        callext f_div,16                        ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     rdx                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     qword [reg_ra+4], rdx         ; result msh
        mov     qword [reg_ra], W0           ; result lsh
        pop     rdx                             ; restore regs
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
	push	rdx
        push    qword [reg_ra+4]              ; ra msh
        push    qword [reg_ra]                ; ra lsh
        callext f_atn,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     rdx                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     qword [reg_ra+4], rdx         ; result msh
        mov     qword [reg_ra], W0           ; result lsh
        pop     rdx                             ; restore regs
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
	push	rdx
        push    qword [reg_ra+4]              ; ra msh
        push    qword [reg_ra]                ; ra lsh
        callext f_chp,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     rdx                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     qword [reg_ra+4], rdx         ; result msh
        mov     qword [reg_ra], W0           ; result lsh
        pop     rdx                             ; restore regs
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
	push	rdx
        push    qword [reg_ra+4]              ; ra msh
        push    qword [reg_ra]                ; ra lsh
        callext f_cos,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     rdx                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     qword [reg_ra+4], rdx         ; result msh
        mov     qword [reg_ra], W0           ; result lsh
        pop     rdx                             ; restore regs
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
	push	rdx
        push    qword [reg_ra+4]              ; ra msh
        push    qword [reg_ra]                ; ra lsh
        callext f_etx,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     rdx                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     qword [reg_ra+4], rdx         ; result msh
        mov     qword [reg_ra], W0           ; result lsh
        pop     rdx                             ; restore regs
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
	push	rdx
        push    qword [reg_ra+4]              ; ra msh
        push    qword [reg_ra]                ; ra lsh
        callext f_lnf,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     rdx                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     qword [reg_ra+4], rdx         ; result msh
        mov     qword [reg_ra], W0           ; result lsh
        pop     rdx                             ; restore regs
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
	push	rdx
        push    qword [reg_ra+4]              ; ra msh
        push    qword [reg_ra]               ; ra lsh
        callext f_sin,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     rdx                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     qword [reg_ra+4], rdx         ; result msh
        mov     qword [reg_ra], W0           ; result lsh
        pop     rdx                             ; restore regs
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
	push	rdx
        push    qword [reg_ra+4]              ; ra msh
        push    qword [reg_ra]                ; ra lsh
        callext f_sqr,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     rdx                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     qword [reg_ra+4], rdx         ; result msh
        mov     qword [reg_ra], W0           ; result lsh
        pop     rdx                             ; restore regs
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
	push	rdx
        push    qword [reg_ra+4]              ; ra msh
        push    qword [reg_ra]                ; ra lsh
        callext f_tan,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     rdx                             ; restore regs
	pop	WA
	fwait
%endif
%if fretW0
        mov     qword [reg_ra+4], rdx         ; result msh
        mov     qword [reg_ra], W0           ; result lsh
        pop     rdx                             ; restore regs
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
	push	XR
	fldz
	pop	XR
	ret


;  procedures needed for save file / load module support -- debug later
;
; 
; -----------
; 
;        get_fp  - get c caller's fp (frame pointer)
; 
;        get_fp() returns the frame pointer for the c function that called
;        this function.  however, this function is only called by zysxi.
; 
;        c function zysxi calls this function to determine the lowest useful
;        word on the stack, so that only the useful part of the stack will be
;        saved in the load module.
; 
;        the flow goes like this:
; 
;        (1) user's spitbol program calls exit function
; 
;        (2) spitbol compiler calls interface routine sysxi to handle exit
; 
;        (3) interface routine sysxi passes control to ccaller which then
;            calls c function zysxi
; 
;        (4) c function zysxi will write a load module, but needs to save
;            a copy of the current stack in the load module.  the base of
;            the part of the stack to be saved begins with the frame of our
;            caller, so that the load module can execute a return to ccaller.
; 
;            this will allow the load module to pretend to be returning from
;            c function zysxi.  so, c function zysxi calls this function,
;            get_fp, to determine the base of the useful part of the stack.
; 
;            we cheat just a little bit here.  c function zysxi can (and does)
;            have local variables, but we won't save them in the load module.
;            only the portion of the frame established by the 80386 call
;            instruction, from bp up, is saved.  these local variables
;            aren't needed, because the load module will not be going back
;            to c function zysxi.  instead when function restart returns, it
;            will act as if c function zysxi is returning.
; 
;        (5) after writing the load module, c function zysxi calls c function
;            zysej to terminate spitbol's execution.
; 
;        (6) when the resulting load module is executed, c function main
;            calls function restart.  function restart restores the stack
;            and then does a return.  this return will act as if it is
;            c function zysxi doing the return and the user's program will
;            continue execution following its call to exit.
; 
;        on entry to _get_fp, the stack looks like
; 
;                /      ...      /
;        (high)  |               |
;                |---------------|
;        zysxi   |    old pc     |  --> return point in ccaller
;          +     |---------------|  useful part of stack
;        frame   |    old bp     |  <<<<-- bp of get_fp's caller
;                |---------------|     -
;                |     zysxi's   |     -
;                /     locals    /     - non-useful part of stack
;                |               |     ------
;        ======= |---------------|
;        sp-->   |    old pc     |  --> return pc in c function zysxi
;        (low)   +---------------+
; 
;        on exit, return ebp in W0. this is the lower limit on the
;        size of the stack.
;
;
;         cproc    get_fp,near
; 	pubname	get_fp
;
;         mov     W0,reg_xs       minimal's xs
;         add     W0,4            pop return from call to sysbx or sysxi
;         retc    0                done
;
;         cendp    get_fp
;
; 
; -----------
; 
;        restart - restart for load module
; 
;        restart( char *dummy, char *stackbase ) - startup compiler
; 
;        the osint main function calls restart when resuming execution
;        of a program from a load module.  the osint main function has
;        reset global variables except for the stack and any associated
;        variables.
; 
;        before restoring stack, set up values for proper checking of
;        stack overflow. (initial sp here will most likely differ
;        from initial sp when compile was done.)
; 
;        it is also necessary to relocate any addresses in the the stack
;        that point within the stack itself.  an adjustment factor is
;        calculated as the difference between the stbas at exit() time,
;        and stbas at restart() time.  as the stack is transferred from
;        tscblk to the active stack, each word is inspected to see if it
;        points within the old stack boundaries.  if so, the adjustment
;        factor is subtracted from it.
; 
;        we use minimal's insta routine to initialize static variables
;        not saved in the save file.  these values were not saved so as
;        to minimize the size of the save file.
; 
; 	ext	rereloc,near
;
;         cproc   restart,near
; 	pubname	restart
;
;         pop     W0                      discard return
;         pop     W0                      discard dummy
;         pop     W0                      get lowest legal stack value
;
;         add     W0,stacksiz             top of compiler's stack
;         mov     XS,W0                  switch to this stack
; 	call	stackinit                initialize minimal stack
;
;                                          set up for stack relocation
;         lea     W0,tscblk+scstr         top of saved stack
;         mov     WB,lmodstk              bottom of saved stack
;         getmin  WA,stbas                WA = stbas from exit() time
;         sub     WB,W0                  WB = size of saved stack
; 	mov	rdx,WA
;         sub     rdx,WB                  rdx = stack bottom from exit() time
; 	mov	WB,WA
;         sub     WB,XS                  WB = old stbas - new stbas
;
;         setminr  stbas,XS                save initial sp
;         getoff  W0,dffnc                get address of ppm offset
;        restore stack from tscblk.
; 
;         mov     rsi,lmodstk              -> bottom word of stack in tscblk
;         lea     rdi,tscblk+scstr         -> top word of stack
;         cmp     rsi,rdi                  any stack to transfer?
;         je      short re3                 skip if not
; 	sub	rsi,4
; 	std
; re1:    lodsd                            get old stack word to W0
;         cmp     W0,rdx                  below old stack bottom?
;         jb      short re2                  j. if W0 < rdx
;         cmp     W0,WA                  above old stack top?
;         ja      short re2                  j. if W0 > WA
;         sub     W0,WB                  within old stack, perform relocation
; re2:    push    W0                      transfer word of stack
;         cmp     rsi,rdi                  if not at end of relocation then
;         jae     re1                         loop back
;
; re3:	cld
;         mov     compsp,XS               save compiler's stack pointer
;         mov     XS,osisp                back to osint's stack pointer
;         callc   rereloc,0                v1.08 relocate compiler pointers into stack
;         getmin  W0,statb                v1.34 start of static region to xr
; 	set_xr  W0
;         minimal insta                    v1.34 initialize static region
;
; 
;        now pretend that we're executing the following c statement from
;        function zysxi:
; 
;                return  normal_return
; 
;        if the load module was invoked by exit(), the return path is
;        as follows:  back to ccaller, back to s$ext following sysxi call,
;        back to user program following exit() call.
; 
;        alternately, the user specified -w as a command line option, and
;        sysbx called makeexec, which in turn called sysxi.  the return path
;        should be:  back to ccaller, back to makeexec following sysxi call,
;        back to sysbx, back to minimal code.  if we allowed this to happen,
;        then it would require that stacked return address to sysbx still be
;        valid, which may not be true if some of the c programs have changed
;        size.  instead, we clear the stack and execute the restart code that
;        simulates resumption just past the sysbx call in the minimal code.
;        we distinguish this case by noting the variable stage is 4.
; 
;         callc   startbrk,0               start control-c logic
;
;         getmin  W0,stage                is this a -w call?
; 	cmp	W0,4
;         je      short re4                yes, do a complete fudge
;
; 
;        jump back to cc1 with return value = normal_return
; 	mov	W0,-1
;         jmp     cc1                      jump back
;
;        here if -w produced load module.  simulate all the code that
;        would occur if we naively returned to sysbx.  clear the stack and
;        go for it.
; 
; re4:	getmin	W0,stbas
;         mov     compsp,W0               empty the stack
;
;        code that would be executed if we had returned to makeexec:
; 
;         setmin  gbcnt,0                  reset garbage collect count
;         callc   zystm,0                  fetch execution time to reg_ia
;         mov     W0,reg_ia               set time into compiler
; 	setminr	timsx,W0
;
;        code that would be executed if we returned to sysbx:
; 
;         push    outptr                   swcoup(outptr)
; 	callc	swcoup,4
;
;        jump to minimal code to restart a save file.
;
;         minimal rstrt                    no return
;
;         cendp    restart
;
