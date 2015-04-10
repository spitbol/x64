.if asm
.def comment_semicolon
.else
.def comment_number
.fi
/*
 copyright 1987-2012 robert b. k. dewar and mark emmer.
 copyright 2012-2015 david shields

 this file is part of macro spitbol.

     macro spitbol is free software: you can redistribute it and/or modify
     it under the terms of the gnu general public license as published by
     the free software foundation, either version 2 of the license, or
     (at your option) any later version.

     macro spitbol is distributed in the hope that it will be useful,
     but without any warranty; without even the implied warranty of
     merchantability or fitness for a particular purpose.  see the
     gnu general public license for more details.

     you should have received a copy of the gnu general public license
     along with macro spitbol.  if not, see <http://www.gnu.org/licenses/>.



       this file contains the assembly language routines that interface
       the macro spitbol compiler written in 80386 assembly language to its
       operating system interface functions written in c.

       contents:

       o overview
       o global variables accessed by osint functions
       o interface routines between compiler and osint functions
       o c callable function startup
       o c callable function get_fp
       o c callable function restart
       o c callable function makeexec
       o routines for minimal opcodes chk and cvd
       o math functions for integer multiply, divide, and remainder
       o math functions for real operation

       overview

       the macro spitbol compiler relies on a set of operating system
       interface functions to provide all interaction with the host
       operating system.  these functions are referred to as osint
       functions.  a typical call to one of these osint functions takes
       the following form in the 80386 version of the compiler:

               ...code to put arguments in registers...
               call    sysxx           ; call osint function
             Word_    extrc_1          ; address of exit point 1
             Word_    extrc_2          ; address of exit point 2
               ...     ...             ; ...
             Word_    extrc_n          ; address of exit point n
               ...instruction following call...

       the osint function 'sysxx' can then return in one of n+1 ways:
       to one of the n exit points or to the instruction following the
       last exit.  this is not really very complicated - the call places
       the return address on the stack, so all the interface function has
       to do is add the appropriate offset to the return address and then
       pick up the exit address and jump to it or do a normal return via
       an ret instruction.

       unfortunately, a c function cannot handle this scheme.  so, an
       intermediary set of routines have been established to allow the
       interfacing of c functions.  the mechanism is as follows:

       (1) the compiler calls osint functions as described above.

       (2) a set of assembly language interface routines is established,
           one per osint function, named accordingly.  each interface
           routine ...

           (a) saves all compiler registers in global variables
               accessible by c functions
           (b) calls the osint function written in c
           (c) restores all compiler registers from the global variables
           (d) inspects the osint function's return value to determine
               which of the n+1 returns should be taken and does so

       (3) a set of c language osint functions is established, one per
           osint function, named differently than the interface routines.
           each osint function can access compiler registers via global
           variables.  no arguments are passed via the call.

           when an osint function returns, it must return a value indicating
           which of the n+1 exits should be taken.  these return values are
           defined in header file 'inter.h'.

       note:  in the actual implementation below, the saving and restoring
       of registers is actually done in one common routine accessed by all
       interface routines.

       other notes:

       some c ompilers transform "internal" global names to
       "external" global names by adding a leading underscore at the front
       of the internal name.  thus, the function name 'osopen' becomes
       '_osopen'.  however, not all c compilers follow this convention.
*/
	Section_	text
	Global_	dnamb
	Global_	dname

	Extern_	id_de
	Extern_	trc_cp
	Extern_	trc_xl
	Extern_	trc_xr
	Extern_	trc_xs
	Extern_	trc_wa
	Extern_	trc_wb
	Extern_	trc_wc
	Extern_	trc_w0
	Extern_	trc_it
	Extern_	trc_id
	Extern_	trc_de
	Extern_	trc_0
	Extern_	trc_1
	Extern_	trc_2
	Extern_	trc_3
	Extern_	trc_4
	Extern_	trc_arg
	Extern_	trc_num

	Global_	start

.if asm
	%macro	itz	1
	Section_	data
%%desc:	D_char	%1,0
	Section_	text
	Mov_	M_word [trc_de],%%desc
	call	trc_
	%endmacro

.if 32
	%define	cfp_b	4
	%define	cfp_c	4
.fi

.if 64
	%define	cfp_b	8
	%define	cfp_c	8
.fi
.fi

.if gas 
.if 32
	.set	cfp_b,4
	.set	cfp_c,4
.fi
.if 64
	.set	cfp_b,8
	.set	cfp_c,8
.fi
.fi
	Global_	reg_block
	Global_	reg_w0
	Global_	reg_wa
	Global_	reg_wb
	Global_	reg_ia
	Global_	reg_wc
	Global_	reg_xr
	Global_	reg_xl
	Global_	reg_cp
	Global_	reg_ra
	Global_	reg_pc
	Global_	reg_xs
;	Global_	reg_size

	Global_	reg_rp

	Global_	minimal
	Extern_	stacksiz

;	values below must agree with calltab defined in x32.hdr and also in osint/osint.h

	Equ_	minimal_relaj,0
	Equ_	minimal_relcr,1
	Equ_	minimal_reloc,2
	Equ_	minimal_alloc,3
	Equ_	minimal_alocs,4
	Equ_	minimal_alost,5
	Equ_	minimal_blkln,6
	Equ_	minimal_insta,7
	Equ_	minimal_rstrt,8
	Equ_	minimal_start,9
	Equ_	minimal_filnm,10
	Equ_	minimal_dtype,11
	Equ_	minimal_enevs,10
	Equ_	minimal_engts,12

	Equ_	globals,1

;   table to recover type word from type ordinal

	Global_	typet
	Section_	data
        Word_	b_art   ; arblk type word - 0
        Word_	b_cdc   ; cdblk type word - 1
        Word_	b_exl   ; exblk type word - 2
        Word_	b_icl   ; icblk type word - 3
        Word_	b_nml   ; nmblk type word - 4
        Word_	p_aba   ; p0blk type word - 5
        Word_	p_alt   ; p1blk type word - 6
        Word_	p_any   ; p2blk type word - 7
; next needed only if support real arithmetic cnra
;       Word_	b_rcl   ; rcblk type word - 8
        Word_	b_scl   ; scblk type word - 9
        Word_	b_sel   ; seblk type word - 10
        Word_	b_tbt   ; tbblk type word - 11
        Word_	b_vct   ; vcblk type word - 12
        Word_	b_xnt   ; xnblk type word - 13
        Word_	b_xrt   ; xrblk type word - 14
        Word_	b_bct   ; bcblk type word - 15
        Word_	b_pdt   ; pdblk type word - 16
        Word_	b_trt   ; trblk type word - 17
        Word_	b_bft   ; bfblk type word   18
        Word_	b_cct   ; ccblk type word - 19
        Word_	b_cmt   ; cmblk type word - 20
        Word_	b_ctt   ; ctblk type word - 21
        Word_	b_dfc   ; dfblk type word - 22
        Word_	b_efc   ; efblk type word - 23
        Word_	b_evt   ; evblk type word - 24
        Word_	b_ffc   ; ffblk type word - 25
        Word_	b_kvt   ; kvblk type word - 26
        Word_	b_pfc   ; pfblk type word - 27
        Word_	b_tet   ; teblk type word - 28
/*
   table of minimal entry points that can be dded from c
   via the minimal function (see inter.asm).

   note that the order of entries in this table must correspond
   to the order of entries in the call enumeration in osint.h
   and osint.inc.
*/
	Global_ calltab
calltab:
        Word_	relaj
        Word_	relcr
        Word_	reloc
        Word_	alloc
        Word_	alocs
        Word_	alost
        Word_	blkln
        Word_	insta
        Word_	rstrt
        Word_	start
        Word_	filnm
        Word_	dtype
;       Word_	enevs ;  engine words
;       Word_	engts ;   not used

	Global_	b_efc
	Global_	b_icl
	Global_	b_rcl
	Global_	b_scl
	Global_	b_vct
	Global_	b_xnt
	Global_	b_xrt
	Global_	c_aaa
	Global_	c_yyy
	Global_	dnamb
	Global_	cswfl
	Global_	dnamp
	Global_	flprt
	Global_	flptr
	Global_	g_aaa
	Global_	gbcnt
	Global_	gtcef
	Global_	headv
	Global_	hshtb
	Global_	kvstn
	Global_	kvdmp
	Global_	kvftr
	Global_	kvcom
	Global_	kvpfl
	Global_	mxlen
	Global_	polct
	Global_	s_yyy
	Global_	s_aaa
	Global_	stage
	Global_	state
	Global_	stbas
	Global_	statb
        Global_	stmcs
        Global_	stmct
	Global_	timsx
	Global_	typet
	Global_	pmhbs
	Global_	r_cod
	Global_	r_fcb
	Global_	w_yyy
	Global_	end_min_data
;       Global variables

	Section_	data

	Align_ 16
dummy:	
	Word_	0
reg_block:
reg_ia: 
	Word_	0		; register ia (ebp)
reg_w0:	
	Word_	0        	; register wa (ecx)
reg_wa:
	Word_	0        	; register wa (ecx)
reg_wb:
	Word_ 	0        	; register wb (ebx)
reg_wc:
	Word_	0		; register wc
reg_xr:
	Word_	0        	; register xr (xr)
reg_xl:
	Word_	0        	; register xl (xl)
reg_cp:
	Word_	0        	; register cp
reg_ra:
	Real_ 	0.0  		; register ra

; these locations save information needed to return after calling osint and after a restart from exit()

reg_pc:
	Word_      0               ; return pc from caller
reg_xs:
	Word_	0		; minimal stack pointer

;	r_size  equ       $-reg_block

;r_size	equ	16*cfp_b

;reg_size:	dd   r_size

; end of words saved during exit(-3)

; reg_rp is used to pass pointer to real operand for real arithmetic

reg_rp:	
	Word_	0

; reg_fl is used to communicate condition codes between minimal and c code.

	Global_	reg_fl
reg_fl:
	Byte_	0		; condition code register for numeric operations

	Align_	8

;  constants

	Global_	ten
ten:   
	Word_      10              ; constant 10
	Global_	inf
inf:
	Word_	0
	Word_      0x7ff00000      ; double precision infinity
	Global_	maxint
.if 32
maxint:
	Word_ 2147483647
.fi
.if 64
maxint:
	Word_ 9223372036854775807
.fi

	Global_	sav_block
sav_block:
	Fill_	44 			; save minimal registers during push/pop reg

	Align_	cfp_b
	Global_	ppoff

ppoff:
	Word_      0               	; offset for ppm exits

	Global_	compsp
compsp:
	Word_      0               	; compiler's stack pointer

	Global_	sav_compsp
sav_compsp:
	Word_      0               	; save compsp here

	Global_	osisp
osisp: 
	Word_      0               	; osint's stack pointer

	Global_	_rc_
_rc_:
	Word_   0				; return code from osint procedure

	Align_	cfp_b
	Global_	save_cp
	Global_	save_xl
	Global_	save_xr
	Global_	save_wa
	Global_	save_wb
	Global_	save_wc
	Global_	save_xs
save_cp:
	Word_	0		; saved cp value
save_ia:
	Word_	0		; saved ia value
save_xl:
	Word_	0		; saved xl value
save_xr:
	Word_	0		; saved xr value
save_wa:
	Word_	0		; saved wa value
save_wb:
	Word_	0		; saved wb value
save_wc:
	Word_	0		; saved wc value
save_xs:
	Word_	0		; saved xs value

	Global_	minimal_id
minimal_id:
	Word_	0		; id for call to minimal from c. see proc minimal below.

/*
	%define setreal 0

       setup a number of internal addresses in the compiler that cannot be directly accessed from within
	c because of naming difficulties.
*/
	Global_	id1
id1:	
	Word_	0
.if dead
%if setreal == 1
	Word_	2

       Word_       1
	D_char	"1x\x00\x00\x00"
%endif
.fi

	Global_	id1blk
id1blk:
		Word_	152
	Word_	0
	Fill_	152

	Global_	id2blk
id2blk:
	Word_	152
      	Word_	0
	Fill_	152

	Global_	ticblk
ticblk:
	Word_	0
	Word_	0

	Global_	tscblk
tscblk:
	Word_	512
	Word_	0
	Fill_	512

;       standard input buffer block.

	Global_	inpbuf

inpbuf:
		Word_	0			; type word
	Word_	0               	; block length
	Word_	1024            	; buffer size
	Word_	0               	; remaining chars to read
	Word_	0               	; offset to next character to read
	Word_	0               	; file position of buffer
	Word_	0               	; physical position in file
	Fill_	1024

	Global_	ttybuf

ttybuf:
	Word_	0     ; type word
	Word_	0								; block length
	Word_	260             	; buffer size  (260 ok in ms-dos with cinread())
	Word_	0               	; remaining chars to read
	Word_	0               	; offset to next char to read
	Word_	0               	; file position of buffer
	Word_	0               	; physical position in file
	Fill_	260	         	; buffer

	Global_	spmin

spmin:
	Word_	0			; stack limit (stack grows down for x86_64)
spmin.a:
	Word_	spmin

	Align_	16
	Align_	cfp_b

call_adr:	
	Word_	0

	Section_	text
/*
       save and restore minimal and interface registers on stack.
       used by any routine that needs to call back into the minimal
       code in such a way that the minimal code might trigger another
       sysxx call before returning.

       note 1:  pushregs returns a collectable value in xl, safe
       for subsequent call to memory allocation routine.

       note 2:  these are not recursive routines.  only reg_xl is
       saved on the stack, where it is accessible to the garbage
       collector.  other registers are just moved to a temp area.

       note 3:  popregs does not restore reg_cp, because it may have
       been modified by the minimal routine called between pushregs
       and popregs as a result of a garbage collection.  calling of
       another sysxx routine in between is not a problem, because
       cp will have been preserved by minimal.

       note 4:  if there isn't a compiler stack yet, we don't bother
       saving xl.  this only happens in call of nextef from sysxi when
       reloading a save file.

*/
	Global_	save_regs
save_regs:
	Mov_	Mem(save_xl),XL
	Mov_	Mem(save_xr),XR
	Mov_	Mem(save_wa),WA
	Mov_	Mem(save_wb),WB
	Mov_	Mem(save_wc),WC
	Mov_	Mem(save_xs),XS
	ret

	Global_	restore_regs
restore_regs:
	;	restore regs, except for sp. that is caller's responsibility
	Mov_	XL,Mem(save_xl)
	Mov_	XR,Mem(save_xr)
	Mov_	WA,Mem(save_wa)
	Mov_	WB,Mem(save_wb)
	Mov_	WC,Mem(save_wc)
	ret
/*
 ;
 ;       startup( char *dummy1, char *dummy2) - startup compiler
 ;
 ;       an osint c function calls startup to transfer control
 ;       to the compiler.
 ;
 ;       (xr) = basemem
 ;       (xl) = topmem - sizeof(word)
 ;
 ;	note: this function never returns.
 ;

*/

	Global_	startup

;   ordinals for minimal calls from assembly language.

;   the order of entries here must correspond to the order of calltab entries in the inter assembly language module.

	Equ_	calltab_relaj,0
	Equ_	calltab_relcr,1
	Equ_	calltab_reloc,2
	Equ_	calltab_alloc,3
	Equ_	calltab_alocs,4
	Equ_	calltab_alost,5
	Equ_	calltab_blkln,6
	Equ_	calltab_insta,7
	Equ_	calltab_rstrt,8
	Equ_	calltab_start,9
	Equ_	calltab_filnm,10
	Equ_	calltab_dtype,11
	Equ_	calltab_enevs,12
	Equ_	calltab_engts,13


startup:
	pop	W0			; discard return
	Mov_	W0,Mem(maxint)		; set maximum integer value
	Mov_	Mem(mxint),W0
	call	stackinit		; initialize minimal stack
	Mov_	W0,Mem(compsp)		; get minimal's stack pointer
	Mov_ 	Mem(reg_wa),W0		; startup stack pointer

	cld				; default to up direction for string ops
;	getoff  W0,dffnc		; get address of ppm offset
	Mov_	Mem(ppoff),W0		; save for use later

	Mov_	XS,Mem(osisp)		; switch to new c stack
.if asm
	Mov_	W0,calltab_start
.fi
.if gas
	Mov_	W0,$calltab_start
.fi
	Mov_	Mem(minimal_id),W0
	call	minimal			; load regs, switch stack, start compiler
/*
	stackinit  -- initialize spmin from sp.

	input:  sp - current c stack
		stacksiz - size of desired minimal stack in bytes

	uses:	W0

	output: register wa, sp, spmin, compsp, osisp set up per diagram:

	(high)	+----------------+
		|  old c stack   |
	  	|----------------| <-- incoming sp, resultant wa (future xs)
		|	     ^	 |
		|	     |	 |
		/ stacksiz bytes /
		|	     |	 |
		|            |	 |
		|----------- | --| <-- resultant spmin
		| 400 bytes  v   |
		|----------------| <-- future c stack pointer, osisp
		|  new c stack	 |
	(low)	|                |
*/

;	initialize stack

	Global_	stackinit
stackinit:
	Mov_	W0,XS
	Mov_	Mem(compsp),W0	; save minimal's stack pointer
	Sub_	W0,Mem(stacksiz)	; end of minimal stack is where c stack will start
	Mov_	Mem(osisp),W0	; save new c stack pointer
	Add_	W0,$cfp_b*100		; 100 words smaller for chk
	Mov_	Mem(spmin),W0
	ret

;	check for stack overflow, making W0 nonzero if found

	Global_	chk__
chk__:
	xor	W0,W0			; set return value assuming no overflow
	Cmp_	XS,Mem(spmin)
	jb	chk.oflo
	ret
chk.oflo:
	inc	W0			; make nonzero to indicate stack overfloW0
	ret
/*
	mimimal -- call minimal function from c

	usage:  extern void minimal(word callno)

	where:
	callno is an ordinal defined in osint.h, osint.inc, and calltab.

	minimal registers wa, wb, wc, xr, and xl are loaded and
	saved from/to the register block.

	note that before restart is called, we do not yet have compiler
	stack to switch to.  in that case, just make the call on the
	the osint stack.
*/
minimal:
	Mov_	WA,Mem(reg_wa)	; restore registers
	Mov_	WB,Mem(reg_wb)
	Mov_	WC,Mem(reg_wc)	;
	Mov_	XR,Mem(reg_xr)
	Mov_	XL,Mem(reg_xl)

	Mov_	Mem(osisp),XS	; save osint stack pointer
	xor	W0,W0
	Cmp_	Mem(compsp),W0	; is there a compiler stack?
	je	min1			; jump if none yet
	Mov_	XS,Mem(compsp)	; switch to compiler stack

 min1:
	Mov_	W0,Mem(minimal_id)	; get ordinal
;	call	Mem(calltab+W0*cfp_b)    ; off to the minimal code
	call	start

	Mov_	XS,Mem(osisp)	; switch to osint stack

	Mov_	Mem(reg_wa),WA	; save registers
	Mov_	Mem(reg_wb),WB
	Mov_	Mem(reg_wc),WC
	Mov_	Mem(reg_xr),XR
	Mov_	Mem(reg_xl),XL
	ret

/*

	interface routines

	each interface routine takes the following form:

	sysxx:
			call    ccaller ; call common interface
                     	Word_    zysxx   ; dd      of c osint function
                       db      n       ; offset to instruction after
                                       ;   last procedure exit

	in an effort to achieve portability of c osint functions, we
	do not take take advantage of any "internal" to "external"
	transformation of names by c compilers.  so, a c osint function
	representing sysxx is named _zysxx.  this renaming should satisfy
	all c compilers.

	important  one interface routine, sysfc, is passed arguments on
	the stack.  these items are removed from the stack before calling
	ccaller, as they are not needed by this implementation.

	ccaller is called by the os interface routines to call the
	real c os interface function.

	general calling sequence is

			call	ccaller
			Word_	address_of_c_function
			db      2*number_of_extrc_points

	control is never returned to a interface routine.  instead, control
	is returned to the compiler (the caller of the interface routine).

	the c function that is called must always return an integer
	indicating the procedure exit to take or that a normal return
	is to be performed.

	c function      interpretation
	return value
	------------    -------------------------------------------
	<0         do normal return to instruction past
	last procedure exit (distance passed
	in by dummy routine and saved on stack)
	0	take procedure exit 1
	4	take procedure exit 2
	8	take procedure exit 3
	...        ...
*/

;%ifdef	OLD
;	Global_	get_ia
;get_ia:
;	Mov_	W0,IA
;	ret
;
;	Global_	set_ia_
;set_ia_:	Mov_	IA,M_word[reg_w0]
;	ret
;%endif
syscall_init:
;	save registers in global variables

	Mov_	Mem(reg_wa),WA      ; save registers
	Mov_	Mem(reg_wb),WB
	Mov_	Mem(reg_wc),WC      ; (also _reg_ia)
	Mov_	Mem(reg_xr),XR
	Mov_	Mem(reg_xl),XL
	ret

syscall_exit:
	Mov_	Mem(_rc_),W0	; save return code from function
	Mov_	Mem(osisp),XS	; save osint's stack pointer
	Mov_	XS,Mem(compsp)	; restore compiler's stack pointer
	Mov_	WA,Mem(reg_wa)	; restore registers
	Mov_	WB,Mem(reg_wb)
	Mov_	WC,Mem(reg_wc)      ;
	Mov_	XR,Mem(reg_xr)
	Mov_	XL,Mem(reg_xl)
	cld
	Mov_	W0,Mem(reg_pc)
.if asm
	jmp	W0
.fi
.if gas
	jmp	*W0		; gas jump to absolute address requires '*' prefix.
.fi

.if asm
	%macro	syscall	2
	pop	W0			; pop return address
	Mov_	Mem(reg_pc),W0
	call	syscall_init

;	save compiler stack and switch to osint stack

	Mov_	Mem(compsp),XS      ; save compiler's stack pointer
	Mov_	XS,Mem(osisp)       ; load osint's stack pointer
	call	%1
	call	syscall_exit
	%endmacro
.fi
.if gas
	.macro	syscall	proc,id
	pop	W0			; pop return address
	Mov_	Mem(reg_pc),W0
	call	syscall_init

;	save compiler stack and switch to osint stack

	Mov_	Mem(compsp),XS      ; save compiler's stack pointer
	Mov_	XS,Mem(osisp)       ; load osint's stack pointer
	call	\proc
	call	syscall_exit
	.endm
.fi

	Global_	sysax
	Extern_	zysax
sysax:
		syscall	  zysax,1

	Global_	sysbs
	Extern_	zysbs
sysbs:
	syscall	  zysbs,2

	Global_	sysbx
	Extern_	zysbx
sysbx:
	Mov_	Mem(reg_xs),XS
	syscall	zysbx,2

;	global syscr
;	Extern_	zyscr
;syscr:
;	syscall	zyscr,0

	Global_	sysdc
	Extern_	zysdc
sysdc:
	syscall	zysdc,4

	Global_	sysdm
	Extern_	zysdm
sysdm:
	syscall	zysdm,5

	Global_	sysdt
	Extern_	zysdt
sysdt:
	syscall	zysdt,6

	Global_	sysea
	Extern_	zysea
sysea:
	syscall	zysea,7

	Global_	sysef
	Extern_	zysef
sysef:
	syscall	zysef,8

	Global_	sysej
	Extern_	zysej
sysej:
	syscall	zysej,9

	Global_	sysem
	Extern_	zysem
sysem:
	syscall	zysem,10

	Global_	sysen
	Extern_	zysen
sysen:
	syscall	zysen,11

	Global_	sysep
	Extern_	zysep
sysep:
	syscall	zysep,12

	Global_	sysex
	Extern_	zysex
sysex:
	Mov_	Mem(reg_xs),XS
	syscall	zysex,13

	Global_	sysfc
	Extern_	zysfc
sysfc: 
	pop	W0             ; <<<<remove stacked scblk>>>>
.if asm
	lea	XS,[XS+WC*cfp_b]
.fi
.if gas
	Mov_	W0,WC
	Sal_	W0,$log_cfp_b
	Add_	XS,W0
.fi

	push	W0
	syscall	zysfc,14

	Global_	sysgc
	Extern_	zysgc
sysgc:
	syscall	zysgc,15

	Global_	syshs
	Extern_	zyshs
syshs:
	Mov_	Mem(reg_xs),XS
	syscall	zyshs,16

	Global_	sysid
	Extern_	zysid
sysid:
	syscall	zysid,17

	Global_	sysif
	Extern_	zysif
sysif:
	syscall	zysif,18

	Global_	sysil
	Extern_	zysil
sysil:
	syscall	zysil,19

	Global_	sysin
	Extern_	zysin
sysin:
	syscall	zysin,20

	Global_	sysio
	Extern_	zysio
sysio:
	syscall	zysio,21

	Global_	sysld
	Extern_	zysld
sysld:
	syscall	zysld,22

	Global_	sysmm
	Extern_	zysmm
sysmm:
	syscall	zysmm,23

	Global_	sysmx
	Extern_	zysmx
sysmx:
	syscall	zysmx,24

	Global_	sysou
	Extern_	zysou
sysou:
	syscall	zysou,25

	Global_	syspi
	Extern_	zyspi
syspi:
	syscall	zyspi,26

	Global_	syspl
	Extern_	zyspl
syspl:
	syscall	zyspl,27

	Global_	syspp
	Extern_	zyspp
syspp:
	syscall	zyspp,28

	Global_	syspr
	Extern_	zyspr
syspr:
	syscall	zyspr,29

	Global_	sysrd
	Extern_	zysrd
sysrd:
	syscall	zysrd,30

	Global_	sysri
	Extern_	zysri
sysri:
	syscall	zysri,32

	Global_	sysrw
	Extern_	zysrw
sysrw:
	syscall	zysrw,33

	Global_	sysst
	Extern_	zysst
sysst:
	syscall	zysst,34

	Global_	systm
	Extern_	zystm
systm:
	syscall	zystm,35

	Global_	systt
	Extern_	zystt
systt:
	syscall	zystt,36

	Global_	sysul
	Extern_	zysul
sysul:
	syscall	zysul,37

	Global_	sysxi
	Extern_	zysxi
sysxi:
	Mov_	Mem(reg_xs),XS
	syscall	zysxi,38

.if asm
	%macro	callext	2
	Extern_	%1
	call	%1
	Add_XS,%2		; pop arguments
	%endmacro

	%macro	chk_	0
	call	chk__
	%endmacro

	%macro	adi_	0
	Add_	Mem(reg_ia),W0
	seto	byte [reg_fl]
	%endmacro

	%macro	dvi_	0
	Mov_	Mem(reg_w0),W0
	call	dvi__
	%endmacro

	%macro	ldi_	1
	Mov_	W0,%1
	Mov_	Mem(reg_ia),W0
	%endmacro

	%macro	mli_	0
	imul	Mem(reg_ia)
	seto	byte [reg_fl]
	%endmacro

	%macro	ngi_	0
	neg	Mem(reg_ia)
	seto	byte [reg_fl]
	%endmacro

	%macro	rmi_	0
	call	rmi__
	%endmacro

	%macro	cvd_	0
	call	cvd__
	%endmacro

	%macro	ino_	1
	Mov_	al,byte [reg_fl]
	or	al,al
	jno	%1
	%endmacro

	%macro	iov_	1
	Mov_	al,byte [reg_fl]
	or	al,al
	jo	%1
	%endmacro

	%macro	rno_	1
	Mov_	al,byte [reg_fl]
	or	al,al
	je	%1
	%endmacro

	%macro	rov_	1
	Mov_	al,byte [reg_fl]
	or	al,al
	jne	%1
	%endmacro

	%macro	sbi_	0
	Sub	Mem(reg_ia),W0
	seto	byte [reg_fl]
	%endmacro

	%macro	sti_	1
	Mov_	W0,Mem(reg_ia)
	Mov_	%1,W0
	%endmacro

	%macro	Icp_	0
	Mov_	W0,Mem(reg_cp)
	Add_	W0,cfp_b
	Mov_	Mem(reg_cp),W0
	%endmacro

	%macro	Lcp_	1
	Mov_	W0,%1
	Mov_	M_word [reg_cp],W0
	%endmacro

	%macro	Lcw_	1
	Mov_	W0,M_word [reg_cp]		; load address of code word
	push	W0
	Mov_	W0,M_word [W0]			; load code word
	Mov_	%1,W0
	pop	W0 				; load address of code word
	Add_	W0,cfp_b
	Mov_	M_word [reg_cp],W0
	%endmacro

	%macro	Scp_	1
	Mov_	W0,M_word [reg_cp]
	Mov_	%1,W0
	%endmacro

.fi
.if gas
.if unix
	.macro	callext	name,id
	Extern_	\name
	call	\name
	Add_XS,\id		; pop arguments
	.endm

	.macro	chk_
	call	chk__
	.endm

	.macro	adi_
	Add_	Mem(reg_ia),W0
	seto	reg_fl
	.endm

	.macro	dvi_
	Mov_	Mem(reg_w0),W0
	call	dvi__
	.endm

	.macro	ldi_	val
	Mov_	W0,\val
	Mov_	Mem(reg_ia),W0
	.endm

	.macro	mli_
	mov	Mem(reg_ia),W0
	imul	W0
	seto	reg_fl
	.endm

; using W0 below since operand size not known, and putting it in register defers this problem

	.macro	ngi_
	mov	Mem(reg_ia),W0
	neg	W0
	mov	W0,Mem(reg_ia)
;	neg	Mem(reg_ia)
	seto	reg_fl
	.endm

	.macro	rmi_
	call	rmi__
	.endm

	.macro	cvd_
	call	cvd__
	.endm

	.macro	ino_	lbl
	movb	reg_fl,%al
	or	%al,%al
	jno	\lbl
	.endm

	.macro	iov_	lbl
	movb	reg_fl,%al
	or	%al,%al
	jo	\lbl
	.endm

	.macro	rno_	lbl
	movb	reg_fl,%al
	or	%al,%al
	je	\lbl
	.endm

	.macro	rov_	lbl
	mov	reg_fl,%al
	or	%al,%al
	jne	\lbl
	.endm

	.macro	sbi_
	Sub	Mem(reg_ia),W0
	seto	reg_fl
	.endm

	.macro	sti_	dst
	Mov_	W0,Mem(reg_ia)
	Mov_	\dst,W0
	.endm

	.macro	Icp_
	Mov_	W0,Mem(reg_cp)
	Add_	W0,cfp_b
	Mov_	Mem(reg_cp),W0
	.endm

	.macro	Lcp_	val
	Mov_	W0,\val
	Mov_	reg_cp,W0
	.endm

	.macro	Lcw_	val
	Mov_	W0,reg_cp			; load address of code word
	push	W0
	Mov_	W0,(W0)				; load code word
	Mov_	\val,W0
	pop	W0 				; load address of code word
	Add_	W0,$cfp_b
	Mov_	reg_cp,W0
	.endm

	.macro	Scp_	val
	Mov_	W0,reg_cp
	Mov_	\val,W0
	.endm

.fi
.if osx
	.macro	callext
	Extern_	$1
	call	$1
	Add_	XS,$2		; pop arguments
	.endm

	.macro	chk_
	call	chk__
	.endm

	.macro	adi_
	Add_	Mem(reg_ia),W0
	seto	reg_fl
	.endm

	.macro	dvi_
	Mov_	Mem(reg_w0),W0
	call	dvi__
	.endm

	.macro	ldi_	val
	Mov_	W0,\val
	Mov_	Mem(reg_ia),W0
	.endm

	.macro	mli_
	mov	Mem(reg_ia),W0
	imul	W0
	seto	reg_fl
	.endm

; using W0 below since operand size not known, and putting it in register defers this problem

	.macro	ngi_
	mov	Mem(reg_ia),W0
	neg	W0
	mov	W0,Mem(reg_ia)
;	neg	Mem(reg_ia)
	seto	reg_fl
	.endm

	.macro	rmi_
	call	rmi__
	.endm

	.macro	cvd_
	call	cvd__
	.endm

	.macro	ino_
	movb	reg_fl,%al
	or	%al,%al
	jno	$1
	.endm

	.macro	iov_
	movb	reg_fl,%al
	or	%al,%al
	jo	$1
	.endm

	.macro	rno_	
	movb	reg_fl,%al
	or	%al,%al
	je	$1
	.endm

	.macro	rov_
	mov	reg_fl,%al
	or	%al,%al
	jne	$1
	.endm

	.macro	sbi_
	Sub	Mem(reg_ia),W0
	seto	reg_fl
	.endm

	.macro	sti
	Mov_	W0,Mem(reg_ia)
	Mov_	$1,W0
	.endm

	.macro	Icp_
	Mov_	W0,Mem(reg_cp)
	Add_	W0,cfp_b
	Mov_	Mem(reg_cp),W0
	.endm

	.macro	Lcp_
	Mov_	W0,$1
	Mov_	reg_cp,W0
	.endm

	.macro	Lcw_
	Mov_	W0,reg_cp			; load address of code word
	push	W0
	Mov_	W0,(W0)				; load code word
	Mov_	$1,W0
	pop	W0 				; load address of code word
	Add_	W0,$cfp_b
	Mov_	reg_cp,W0
	.endm

	.macro	Scp_	val
	Mov_	W0,reg_cp
	Mov_	\val,W0
	.endm

.fi
.fi
/*
	x64 hardware divide, expressed in form of minimal register mappings, requires dividend be
	placed in W0, which is then sign extended into wc:W0. after the divide, W0 contains the
	quotient, wc contains the remainder.

	cvd__ - convert by division

	input   ia = number <=0 to convert
	output  ia / 10
	wa ecx) = remainder + '0'
*/

	Global_	cvd__
cvd__:
	Extern_	i_cvd
	Mov_	Mem(reg_wa),WA
	call	i_cvd
	Mov_	WA,Mem(reg_wa)
	ret

;	dvi__ - divide ia (edx) by long in w0
	Global_	dvi__
dvi__:
	Extern_	i_dvi
	Mov_	Mem(reg_w0),W0
	call	i_dvi
.if asm
	Mov_	al,byte [reg_fl]
	or	al,al
.fi
.if gas
	movb	reg_fl,%al
	or	%al,%al
.fi
	ret

	Global_	rmi__
;       rmi__ - remainder of ia (edx) divided by long in w0
rmi__:
	jmp	ocode
	Extern_	i_rmi
	Mov_	Mem(reg_w0),W0
	call	i_rmi
.if asm
	Mov_	al,byte [rel reg_fl]
	or	al,al
.fi
.if gas
	movb	reg_fl,%al
	or	%al,%al
.fi
	ret

ocode:
	or	W0,W0		; test for 0
	jz	setovr		; jump if 0 divisor
	xchg	W0,Mem(reg_ia)	; ia to w0, divisor to ia
	Cdq_			; extend dividend
	Mov_	W0,Mem(reg_ia)
	idiv	W0		; perform division. w0=quotient, wc=remainder
.if asm
	seto	byte [rel reg_fl]
.fi
.if gas
	seto	reg_fl
.fi
	Mov_	Mem(reg_ia),WC
	ret

setovr:
.if asm
	Mov_	al,1		; set overflow indicator
	Mov_	byte [rel reg_fl],al
.fi
.if gas
	xor	%al,%al		; set overflow indicator
	inc	%al
	movb	%al,reg_fl
.fi
	ret

.if asm
	%macro	int_op 2
	Global_	%1
	Extern_	%2
%1:
	call	%2
	ret
%endmacro
.fi
.if gas
.if unix
	.macro	int_op glob,ext
	Global_	\glob
	Extern_	\ext
\glob:
	call	\ext
	ret
	.endm
.fi
.if osx
	.macro	int_op 
	Global_	$1
	Extern_	$2
\glob:
	call	$2
	ret
	.endm
.fi
.fi

	int_op itr_,f_itr
	int_op rti_,f_rti

;	Extern_	i_ldi
;	%macro	ldi_	1
;	Mov_	W0,%1
;	Mov_	Mem(reg_ia),W0
;	call	i_ldi
;	%endmacro
;
;	%macro	sti_	1
;	Mov_	W0, Mem(reg_ia)
;	Mov_	%1,W0
;	%endmacro
;
;	Extern w00
;	%macro	int_op 2
;	Global_	%1
;	Extern_	%2
;%1:
;	Mov_	Mem(reg_w0),W0
;	call	%2
;	ret
;	%endmacro
;
;	int_op	adi_,i_adi
;	int_op	mli_,i_mli
;	int_op	sbi_,i_sbi
;	int_op	dvi_,i_dvi
;	int_op	rmi_,i_rmi
;	int_op	ngi_,i_ngi	; causes spurious store of W0 that doesn't matter
;	int_op	itr_,f_itr
;	int_op	rti_,f_rti
;%endif

.if asm
	%macro	osint_call 3
	Global_	%1
	Extern_	%2
%1:
	Mov_	M_word [%3],W0
	call	%2
	ret
	%endmacro
.fi

.if gas
.if unix
	.macro	osint_call glob,ext,reg
	Global_	\glob
	Extern_	\ext
\glob:
	Mov_	\reg,W0
	call	\ext
	ret
	.endm
.fi
.if osx
	.macro	osint_call 
	Global_	$1
	Extern_	$2
$1:
	Mov_	$3,W0
	call	$2
	ret
	.endm
.fi
.fi

.if asm
	%macro	real_op 2
	osint_call	%1,%2,reg_rp
	%endmacro
.fi

.if gas
.if unix
	.macro	real_op op,proc
	osint_call	\op,\proc,reg_rp
	.endm
.fi
.if osx
	.macro	real_op
	osint_call	$1,$2,\proc,reg_rp
	.endm
.fi
.fi

	real_op	ldr_,f_ldr
	real_op	str_,f_str
	real_op	adr_,f_adr
	real_op	sbr_,f_sbr
	real_op	mlr_,f_mlr
	real_op	dvr_,f_dvr
	real_op	ngr_,f_ngr
	real_op cpr_,f_cpr

.if asm
	%macro	math_op 2
	Global_	%1
	Extern_	%2
%1:
	call	%2
	ret
	%endmacro
.fi
.if gas
.if unix
	.macro	math_op glob,ext
	Global_	\glob
	Extern_	\ext
\glob:
	call	\ext
	ret
	.endm
.fi
.if osx
	.macro	math_op 
	Global_	$1
	Extern_	$2
$1:
	call	$2
	ret
	.endm
.fi
.fi

	math_op	atn_,f_atn
	math_op	chp_,f_chp
	math_op	cos_,f_cos
	math_op	etx_,f_etx
	math_op	lnf_,f_lnf
	math_op	sin_,f_sin
	math_op	sqr_,f_sqr
	math_op	tan_,f_tan

;	ovr_ test for overflow value in ra
	Global_	ovr_
ovr_:
.if asm
	Mov_	ax, word [ rel reg_ra+6]	; get top 2 bytes
	and	ax, 0x7ff0		; check for infinity or nan
	Add_	ax, 0x10		; set/clear overflow accordingly
.fi
.if gas
	mov	$reg_ra,W0
	add	$6,W0
	movw	(W0),%ax		; get top 2 bytes
	and	$0x7ff0,%ax		; check for infinity or nan
	add	$0x10,%ax		; set/clear overflow accordingly
.fi
	ret

	Global_	get_fp			; get frame pointer

get_fp:
	Mov_	W0,Mem(reg_xs)     ; minimal's xs
	Add_	W0,4           	; pop return from call to sysbx or sysxi
	ret                    	; done

	Extern_	rereloc

	Global_	restart
	Extern_	lmodstk
	Extern_	startbrk
	Extern_	outptr
	Extern_	swcoup
;	scstr is offset to start of string in scblk, or two words
;scstr	equ	cfp_c+cfp_c

;
restart:
.if restart
	pop	W0                      ; discard return
	pop	W0                     	; discard dummy
	pop	W0                     	; get lowest legal stack value

	Add_	W0,Mem(stacksiz)  	; top of compiler's stack
	Mov_	XS,W0                 	; switch to this stack
	call	stackinit               ; initialize minimal stack

                                        ; set up for stack relocation
	lea	W0,[rel tscblk+scstr]       ; top of saved stack
	Mov_	WB,Mem(lmodstk)    	; bottom of saved stack
	Mov_	WA,Mem(stbas)      ; wa = stbas from exit() time
	Sub	WB,W0                 	; wb = size of saved stack
	Mov_	WC,WA
	Sub	WC,WB                 	; wc = stack bottom from exit() time
	Mov_	WB,WA
	Sub	WB,XS                 	; wb =  stbas - new stbas

	Mov_	Mem(stbas),XS       ; save initial sp
;	getoff  W0,dffnc               ; get address of ppm offset
	Mov_	Mem(ppoff),W0       ; save for use later
;
;	restore stack from tscblk.
;
	Mov_	XL,Mem(lmodstk)    	; -> bottom word of stack in tscblk
	lea	XR,[rel tscblk+scstr]      	; -> top word of stack
	Cmp_	XL,XR                 	; any stack to transfer?
        je      re3               	;  skip if not
	Sub	XL,4
	std
re1:
	lodsd                           ; get old stack word to W0
	Cmp_	W0,WC                 	; below old stack bottom?
	jb	re2               	;   j. if W0 < wc
	Cmp_	W0,WA                 	; above old stack top?
	ja	re2               	;   j. if W0 > wa
	Sub	W0,WB                 	; within old stack, perform relocation
re2:
	push	W0                     	; transfer word of stack
	Cmp_	XL,XR                 	; if not at end of relocation then
	jae	re1                     ;    loop back

re3:	cld
	Mov_	Mem(compsp),XS     	; save compiler's stack pointer
	Mov_	XS,Mem(osisp)      	; back to osint's stack pointer
	call	rereloc               	; relocate compiler pointers into stack
	Mov_	W0,Mem(statb)      	; start of static region to xr
	Mov_	Mem(reg_xr),W0
	Mov_	W0,minimal_insta
	call	minimal			; initialize static region
/*

       now pretend that we're executing the following c statement from
       function zysxi:

               return  normal_return;

       if the load module was invoked by exit(), the return path is
       as follows:  back to ccaller, back to s$ext following sysxi call,
       back to user program following exit() call.

       alternately, the user specified -w as a command line option, and
       sysbx called makeexec, which in turn called sysxi.  the return path
       should be:  back to ccaller, back to makeexec following sysxi call,
       back to sysbx, back to minimal code.  if we allowed this to happen,
       then it would require that stacked return address to sysbx still be
       valid, which may not be true if some of the c programs have changed
       size.  instead, we clear the stack and execute the restart code that
       simulates resumption just past the sysbx call in the minimal code.
       we distinguish this case by noting the variable stage is 4.

*/
	call	startbrk			; start control-c logic

	Mov_	W0,Mem(stage)	; is this a -w call?
.if asm
	Cmp_	W0,4
.fi
.if gas
	Cmp_	W0,$4
.fi
	je	re4			; yes, do a complete fudge

;       jump back with return value = normal_return

	xor	W0,W0			; set to zero to indicate normal return
	call	syscall_exit
	ret
/*
	here if -w produced load module.  simulate all the code that
	would occur if we naively returned to sysbx.  clear the stack and
	go for it.
*/
re4:
	Mov_	W0,Mem(stbas)
	Mov_	Mem(compsp),W0     	; empty the stack

;	code that would be executed if we had returned to makeexec:

	xor	W0,W0
	Mov_	Mem(gbcnt),W0       	; reset garbage collect count to zero
	call	zystm                 	; fetch execution time to reg_ia
	Mov_	W0,Mem(reg_ia)     	; set time into compiler
	Mov_	Mem(timsx),W0

;	code that would be executed if we returned to sysbx:

	push	Mem(outptr)        	; swcoup(outptr)
	Extern 	swcoup
	call	swcoup
	Add_	XS,cfp_b

;	jump to minimal code to restart a save file.

	Mov_	W0,minimal_rstrt
	Mov_	Mem(minimal_id),W0
	call	minimal			; no return
.fi

	Global_	trc_
	Extern_	trc
trc_:
	pushf
	call	save_regs
	call	trc
	call	restore_regs
	popf
	ret
.if asm
;	%undef		cfp_b
;	%undef		cfp_c
.fi


	Global_	reav1
