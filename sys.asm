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
             D_word    extrc_1          ; address of exit point 1
             D_word    extrc_2          ; address of exit point 2
               ...     ...             ; ...
             D_word    extrc_n          ; address of exit point n
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

; Operation and declaration macros are needed for each instruction/declaration having different formats in asm and gas.

.if asm

	%macro	Add_	2
		add	%1,%2
	%endmacro

	%macro	Align_	1
		align	%1
	%endmacro

	%macro	And_	2
	and	%1,%2
	%endmacro

	%macro	Cmp_	2	; src/dst differ
		cmp	%1,%2
	%endmacro

	%macro	Cmpb_	2	; src/dst differ
		Cmp_	%1,%2
	%endmacro

	%macro	Data	0
		section	.data
	%endmacro

	%macro	Dec_	1
	dec %1
	%endmacro

	%macro	Equ_	2
%1:	equ	%2
	%endmacro
.fi

.if gas
.if 32
.if unix
	.macro	Cmp_	dst,src	; src/dst differ
		cmpl	\src,\dst
	.endm
.fi
.if osx
	.macro	Cmp_
		cmpl	$1,$2
	.endm
.fi
.fi
.fi

.if gas
.if 64
.if unix
	.macro	Cmp_	dst,src	; src/dst differ
		cmpq	\src,\dst
	.endm
.fi
.if osx
	.macro	Cmp_
		cmpq	$1,$2
	.endm
.fi
.fi
.fi


.if gas
.if unix
	.macro	Add_	dst,src
		add	\src,\dst
	.endm

	.macro	Align_	bytes
		.balign	\bytes,0
	.endm

	.macro	And_	dst,src
	and	\src,\dst
	.endm

	.macro	Cmpb_	dst,src	; src/dst differ
		cmpb	\src,\dst
	.endm

	.macro	Data
		.data
	.endm

	.macro	Equ_	name,value
	.set	\name,\value
	.endm
.fi
.if osx
	.macro	Add_
		add	$1,$2
	.endm

	.macro	Align_
		.balign	$1,0
	.endm

	.macro	And_
		and	$1,$2
	.endm

	.macro	Cmpb_
		cmpb	$1,$2
	.endm

	.macro	Data
		.data
	.endm

	.macro	Equ_
	.set	$1,$2
	.endm
.fi
.fi

.if gas
.if 32
.if unix
	.macro	Dec_	val
	decl \val
	.endm
.fi
.if osx
	.macro	Dec_
	decl $1
	.endm
.fi
.fi
.fi

.if gas 
.if 64
.if unix
	.macro	Dec_	val
	decq \val
	.endm
.fi
.if osx
	.macro	Dec_
	decq $1
	.endm
.fi
.fi
.fi


.if asm
	%macro Extern	1
		extern	%1
	%endmacro

	%macro	Fill	1
	times	%1 db 0
	%endmacro

	%macro Global	1
		global	%1
	%endmacro

	%macro	Inc_	1
		inc	%1
	%endmacro

	%macro	Include	1
		%include	%1
	%endmacro
.fi
.if gas 
.if 32
.if unix
	.macro	Inc_	val
		incl	\val
	.endm
.fi
.if osx
	.macro	Inc_
		incl	$1
	.endm
.fi
.fi
.fi

.if gas 
.if 64
.if unix
	.macro	Inc_	val
		incq	\val
	.endm
.fi
.if osx
	.macro	Inc_
		incq	$1
	.endm
.fi
.fi
.fi

.if gas
.if unix
	.macro	Extern	name
		.extern	\name
	.endm

	.macro	Fill	count
	.fill	\count
	.endm

	.macro	Global	name
		.global	\name
	.endm

	.macro	Include	file
		.include	\file
	.endm
.fi
.if osx
	.macro	Extern
		.extern	$1
	.endm

	.macro	Fill
	.fill	%1
	.endm

	.macro	Global
		.globl	$1

	.endm

	.macro	Include	
		.include	$1
	.endm
.fi
.fi

.if asm
	%macro	Jmp_	1	; gas needs '*' before target
		jmp	%1
	%endmacro

	%macro	Lea_	2	; load effective address
		lea	%1,%2
	%endmacro

	%macro	Mov_	2
		mov	%1,%2
	%endmacro

	%macro	Or_	2
	or	%1,%2
	%endmacro

	%macro	Sal_	2
		sal	%1,%2
	%endmacro

	%macro	Sar_	2
		sar	%1,%2
	%endmacro

	%macro	Sub_	2
		sub	%1,%2
	%endmacro

	%macro	Text 0
		section	.text
	%endmacro

	%macro	Xor_	2
	xor	%1,%2
	%endmacro
.fi

.if gas
.if  32
.if unix
	.macro	Mov_	dst,src
		movl	\src,\dst
	.endm
.fi
.if osx
	.macro	Mov_
		movl	$1,$2
	.endm
.fi
.fi
.fi

.if gas 
.if 64
.if unix
	.macro	Mov_	dst,src
		movq	\src,\dst
	.endm
.fi
.if osx
	.macro	Mov_
		movq	$1,$2
	.endm
.fi
.fi
.fi

.if gas 
.if 32
.if unix
	.macro	Sal_	dst,src
		sall	\src,\dst
	.endm

	.macro	Sar_	dst,src
		sarl	\src,\dst
	.endm

	.macro	Stos_w
	stosl
	.endm
.fi
.if osx
	.macro	Sal_	
		sall	$1,$2
	.endm

	.macro	Sar_
		sarl	$1,$2
	.endm

	.macro	Stos_w
	stosl
	.endm
.fi
.fi
.fi

.if gas 
.if 64
.if unix
	.macro	Sal_	dst,src
		salq	\src,\dst
	.endm

	.macro	Sar_	dst,src
		sarq	\src,\dst
	.endm

	.macro	Stos_w
	stosq
	.endm
.fi
.if osx
	.macro	Sal_
		salq	$1,$2
	.endm

	.macro	Sar_
		sarq	$1,$2
	.endm

	.macro	Stos_w
	stosq
	.endm
.fi
.fi
.fi

.if gas
	.macro	Jmp_	lab	; gas needs '*' before target
		jmp	\lab
	.endm

	.macro	Lea_	dst,src	; load effective address
		lea	\src,\dst
	.endm

	.macro	Or_	dst,src
	or	\src,\dst
	.endm

	.macro	Sub_	dst,src
		sub	\src,\dst
	.endm

	.macro	Text
		.text
	.endm

	.macro	Xor_	dst,src
	xor	\src,\dst
	.endm
.fi

.if osx
	.macro	Jmp_	
		jmp	$1
	.endm

	.macro	Lea_
		lea	$1,$2
	.endm

	.macro	Or_
		or	$1,$2
	.endm

	.macro	Sub_
		sub	$1,$2
	.endm

	.macro	Text
		.text
	.endm

	.macro	Xor_
		xor	$1,$2
	.endm
.fi

.if asm
	%define M_char	byte	; reference to byte in memory
	%define D_byte	db	; define value of byte
	%define D_char	db	; define value of byte
	%define D_real	dq	; real always 64 bits
.fi

.if asm 
.if 64
	%define	log_cfp_b	3
	%define	log_cfp_c	3


	%define	D_char	db
	%define D_word	dq
	%define M_real	qword	; reference to floating point value in memory
	%define M_word  qword

	%define	W0	rax
	%define W1	rbp
	%define	WA	rcx
	%define	WB	rbx
	%define	WC	rdx

	%define	XL	rsi
	%define	XT	rsi
	%define	XR	rdi
	%define	XS	rsp

	%define	Lods_b	lodsb
	%define Movs_b	movsb
	%define Movs_w	movsq
	%define Stos_b	stosb
	%define	Stos_w	stosq

	%define	cdq	cqo	; sign extend (64 bits)
	%define Mem(ref) qword[ref]
	%define Adr(ref) [ref]
.fi
.fi

.if asm 
.if 32

	%define	log_cfp_b	2
	%define	log_cfp_c	2

	%define M_real	dword	; reference to floating point value in memory
	%define W0	eax
	%define W1	ebp
	%define WA	ecx
	%define WB	ebx
	%define WC	edx

	%define	XL	esi
	%define	XT	esi
	%define XR	edi
	%define XS	esp

	%define	D_char	db
	%define D_word	dd	; define value for memory Word
	%define M_word	dword	; reference to Word in memory
	%define M_real	dword	; reference to Word in memory

	%define	Lods_b	lodsb
	%define Movs_b	movsb
	%define Movs_w	movsd
	%define	Stos_b	stosb

	%define	cdq	cdq	; sign extend (32 bits)

	%define Mem(ref) dword[ref]
	%define Adr(ref) [ref]
.fi
.fi

.if asm
	%define	W0_L	al
	%define	WA_L	cl
	%define	WB_L	bl
	%define	WC_L	dl

;	flags
	%define	flag_of	0x80
	%define	flag_cf	0x01
	%define	flag_ca	0x40
.fi


        Text
	Global	dnamb
	Global	dname

	Extern	id_de
	Extern	trc_cp
	Extern	trc_xl
	Extern	trc_xr
	Extern	trc_xs
	Extern	trc_wa
	Extern	trc_wb
	Extern	trc_wc
	Extern	trc_w0
	Extern	trc_it
	Extern	trc_id
	Extern	trc_de
	Extern	trc_0
	Extern	trc_1
	Extern	trc_2
	Extern	trc_3
	Extern	trc_4
	Extern	trc_arg
	Extern	trc_num

	Global	start

.if asm
	%macro	itz	1
	Data
%%desc:	D_char	%1,0
	Text
	Mov_	M_word [trc_de],%%desc
	call	trc_
	%endmacro
.fi

.if asm 
.if 32
	%define	cfp_b	4
	%define	cfp_c	4
.fi
.fi

.if asm 
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
.fi

.if gas 
.if 64
	.set	cfp_b,8
	.set	cfp_c,8
.fi
.fi

	Global	reg_block
	Global	reg_w0
	Global	reg_wa
	Global	reg_wb
	Global	reg_ia
	Global	reg_wc
	Global	reg_xr
	Global	reg_xl
	Global	reg_cp
	Global	reg_ra
	Global	reg_pc
	Global	reg_xs
;	Global	reg_size

	Global	reg_rp

	Global	minimal
	Extern	stacksiz

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

	Global	typet
	Data
        D_word	b_art   ; arblk type word - 0
        D_word	b_cdc   ; cdblk type word - 1
        D_word	b_exl   ; exblk type word - 2
        D_word	b_icl   ; icblk type word - 3
        D_word	b_nml   ; nmblk type word - 4
        D_word	p_aba   ; p0blk type word - 5
        D_word	p_alt   ; p1blk type word - 6
        D_word	p_any   ; p2blk type word - 7
; next needed only if support real arithmetic cnra
;       D_word	b_rcl   ; rcblk type word - 8
        D_word	b_scl   ; scblk type word - 9
        D_word	b_sel   ; seblk type word - 10
        D_word	b_tbt   ; tbblk type word - 11
        D_word	b_vct   ; vcblk type word - 12
        D_word	b_xnt   ; xnblk type word - 13
        D_word	b_xrt   ; xrblk type word - 14
        D_word	b_bct   ; bcblk type word - 15
        D_word	b_pdt   ; pdblk type word - 16
        D_word	b_trt   ; trblk type word - 17
        D_word	b_bft   ; bfblk type word   18
        D_word	b_cct   ; ccblk type word - 19
        D_word	b_cmt   ; cmblk type word - 20
        D_word	b_ctt   ; ctblk type word - 21
        D_word	b_dfc   ; dfblk type word - 22
        D_word	b_efc   ; efblk type word - 23
        D_word	b_evt   ; evblk type word - 24
        D_word	b_ffc   ; ffblk type word - 25
        D_word	b_kvt   ; kvblk type word - 26
        D_word	b_pfc   ; pfblk type word - 27
        D_word	b_tet   ; teblk type word - 28
/*
   table of minimal entry points that can be dded from c
   via the minimal function (see inter.asm).

   note that the order of entries in this table must correspond
   to the order of entries in the call enumeration in osint.h
   and osint.inc.
*/
	Global calltab
calltab:
        D_word	relaj
        D_word	relcr
        D_word	reloc
        D_word	alloc
        D_word	alocs
        D_word	alost
        D_word	blkln
        D_word	insta
        D_word	rstrt
        D_word	start
        D_word	filnm
        D_word	dtype
;       D_word	enevs ;  engine words
;       D_word	engts ;   not used

	Global	b_efc
	Global	b_icl
	Global	b_rcl
	Global	b_scl
	Global	b_vct
	Global	b_xnt
	Global	b_xrt
	Global	c_aaa
	Global	c_yyy
	Global	dnamb
	Global	cswfl
	Global	dnamp
	Global	flprt
	Global	flptr
	Global	g_aaa
	Global	gbcnt
	Global	gtcef
	Global	headv
	Global	hshtb
	Global	kvstn
	Global	kvdmp
	Global	kvftr
	Global	kvcom
	Global	kvpfl
	Global	mxlen
	Global	polct
	Global	s_yyy
	Global	s_aaa
	Global	stage
	Global	state
	Global	stbas
	Global	statb
        Global  stmcs
        Global  stmct
	Global	timsx
	Global  typet
	Global	pmhbs
	Global	r_cod
	Global	r_fcb
	Global	w_yyy
	Global	end_min_data
;       Global variables

	Data

	Align_ 16
dummy:	D_word	0
reg_block:
reg_ia: D_word	0		; register ia (ebp)
reg_w0:	D_word	0        	; register wa (ecx)
reg_wa:	D_word	0        	; register wa (ecx)
reg_wb:	D_word 	0        	; register wb (ebx)
reg_wc:	D_word	0		; register wc
reg_xr:	D_word	0        	; register xr (xr)
reg_xl:	D_word	0        	; register xl (xl)
reg_cp:	D_word	0        	; register cp
reg_ra:	D_real 	0.0  		; register ra

; these locations save information needed to return after calling osint and after a restart from exit()

reg_pc: D_word      0               ; return pc from caller
reg_xs:	D_word	0		; minimal stack pointer

;	r_size  equ       $-reg_block

;r_size	equ	16*cfp_b

;reg_size:	dd   r_size

; end of words saved during exit(-3)

; reg_rp is used to pass pointer to real operand for real arithmetic

reg_rp:	D_word	0

; reg_fl is used to communicate condition codes between minimal and c code.

	Global	reg_fl
reg_fl:	D_byte	0		; condition code register for numeric operations

	Align_	8

;  constants

	Global	ten
ten:    D_word      10              ; constant 10
	Global  inf
inf:	D_word	0
	D_word      0x7ff00000      ; double precision infinity
	Global	maxint
.if 32
maxint:	D_word 2147483647
.fi
.if 64
maxint:	D_word 9223372036854775807
.fi

	Global	sav_block
sav_block:
	Fill 	44 			; save minimal registers during push/pop reg

	Align_ cfp_b
	Global	ppoff

ppoff:  D_word      0               	; offset for ppm exits

	Global	compsp
compsp: D_word      0               	; compiler's stack pointer

	Global	sav_compsp
sav_compsp:
	D_word      0               	; save compsp here

	Global	osisp
osisp:  D_word      0               	; osint's stack pointer

	Global	_rc_
_rc_:	D_word   0				; return code from osint procedure

	Align_	cfp_b
	Global	save_cp
	Global	save_xl
	Global	save_xr
	Global	save_wa
	Global	save_wb
	Global	save_wc
	Global	save_xs
save_cp:	D_word	0		; saved cp value
save_ia:	D_word	0		; saved ia value
save_xl:	D_word	0		; saved xl value
save_xr:	D_word	0		; saved xr value
save_wa:	D_word	0		; saved wa value
save_wb:	D_word	0		; saved wb value
save_wc:	D_word	0		; saved wc value
save_xs:	D_word	0		; saved xs value

	Global	minimal_id
minimal_id:	D_word	0		; id for call to minimal from c. see proc minimal below.

/*
	%define setreal 0

       setup a number of internal addresses in the compiler that cannot be directly accessed from within
	c because of naming difficulties.
*/
	Global	id1
id1:	D_word	0
.if dead
%if setreal == 1
	D_word	2

       D_word       1
	D_char	"1x\x00\x00\x00"
%endif
.fi

	Global	id1blk
id1blk:	D_word	152
	D_word	0
	Fill	152

	Global	id2blk
id2blk:	D_word	152
      	D_word	0
	Fill	152

	Global	ticblk
ticblk:
	D_word	0
	D_word	0

	Global	tscblk
tscblk:
	D_word	512
	D_word	0
	Fill	512

;       standard input buffer block.

	Global  inpbuf

inpbuf:	D_word	0			; type word
	D_word	0               	; block length
	D_word	1024            	; buffer size
	D_word	0               	; remaining chars to read
	D_word	0               	; offset to next character to read
	D_word	0               	; file position of buffer
	D_word	0               	; physical position in file
	Fill	1024

	Global  ttybuf

ttybuf:	D_word    0     ; type word
	D_word	0								; block length
	D_word	260             	; buffer size  (260 ok in ms-dos with cinread())
	D_word	0               	; remaining chars to read
	D_word	0               	; offset to next char to read
	D_word	0               	; file position of buffer
	D_word	0               	; physical position in file
	Fill	260	         	; buffer

	Global	spmin

spmin:	D_word	0			; stack limit (stack grows down for x86_64)
spmin.a:	D_word	spmin

	Align_	16
	Align_	cfp_b

call_adr:	D_word	0

	Text
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
	Global	save_regs
save_regs:
	Mov_	Mem(save_xl),XL
	Mov_	Mem(save_xr),XR
	Mov_	Mem(save_wa),WA
	Mov_	Mem(save_wb),WB
	Mov_	Mem(save_wc),WC
	Mov_	Mem(save_xs),XS
	ret

	Global	restore_regs
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

	Global	startup

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

	Global	stackinit
stackinit:
	Mov_	W0,XS
	Mov_	Mem(compsp),W0	; save minimal's stack pointer
	Sub_	W0,Mem(stacksiz)	; end of minimal stack is where c stack will start
	Mov_	Mem(osisp),W0	; save new c stack pointer
	Add_	W0,$cfp_b*100		; 100 words smaller for chk
	Mov_	Mem(spmin),W0
	ret

;	check for stack overflow, making W0 nonzero if found

	Global	chk__
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
                     	D_word    zysxx   ; dd      of c osint function
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
			d_word	address_of_c_function
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
;	Global	get_ia
;get_ia:
;	Mov_	W0,IA
;	ret
;
;	Global	set_ia_
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

	Global sysax
	Extern	zysax
sysax:	syscall	  zysax,1

	Global sysbs
	Extern	zysbs
sysbs:	syscall	  zysbs,2

	Global sysbx
	Extern	zysbx
sysbx:	Mov_	Mem(reg_xs),XS
	syscall	zysbx,2

;	global syscr
;	Extern	zyscr
;syscr:	syscall	zyscr,0

	Global sysdc
	Extern	zysdc
sysdc:	syscall	zysdc,4

	Global sysdm
	Extern	zysdm
sysdm:	syscall	zysdm,5

	Global sysdt
	Extern	zysdt
sysdt:	syscall	zysdt,6

	Global sysea
	Extern	zysea
sysea:	syscall	zysea,7

	Global sysef
	Extern	zysef
sysef:	syscall	zysef,8

	Global sysej
	Extern	zysej
sysej:	syscall	zysej,9

	Global sysem
	Extern	zysem
sysem:	syscall	zysem,10

	Global sysen
	Extern	zysen
sysen:	syscall	zysen,11

	Global sysep
	Extern	zysep
sysep:	syscall	zysep,12

	Global sysex
	Extern	zysex
sysex:	Mov_	Mem(reg_xs),XS
	syscall	zysex,13

	Global sysfc
	Extern	zysfc
sysfc:  pop	W0             ; <<<<remove stacked scblk>>>>
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

	Global	sysgc
	Extern	zysgc
sysgc:	syscall	zysgc,15

	Global	syshs
	Extern	zyshs
syshs:	Mov_	Mem(reg_xs),XS
	syscall	zyshs,16

	Global	sysid
	Extern	zysid
sysid:	syscall	zysid,17

	Global	sysif
	Extern	zysif
sysif:	syscall	zysif,18

	Global	sysil
	Extern	zysil
sysil:	syscall	zysil,19

	Global	sysin
	Extern	zysin
sysin:	syscall	zysin,20

	Global	sysio
	Extern	zysio
sysio:	syscall	zysio,21

	Global	sysld
	Extern	zysld
sysld:	syscall	zysld,22

	Global	sysmm
	Extern	zysmm
sysmm:	syscall	zysmm,23

	Global	sysmx
	Extern	zysmx
sysmx:	syscall	zysmx,24

	Global	sysou
	Extern	zysou
sysou:	syscall	zysou,25

	Global	syspi
	Extern	zyspi
syspi:	syscall	zyspi,26

	Global	syspl
	Extern	zyspl
syspl:	syscall	zyspl,27

	Global	syspp
	Extern	zyspp
syspp:	syscall	zyspp,28

	Global	syspr
	Extern	zyspr
syspr:	syscall	zyspr,29

	Global	sysrd
	Extern	zysrd
sysrd:	syscall	zysrd,30

	Global	sysri
	Extern	zysri
sysri:	syscall	zysri,32

	Global	sysrw
	Extern	zysrw
sysrw:	syscall	zysrw,33

	Global	sysst
	Extern	zysst
sysst:	syscall	zysst,34

	Global	systm
	Extern	zystm
systm:	syscall	zystm,35

	Global	systt
	Extern	zystt
systt:	syscall	zystt,36

	Global	sysul
	Extern	zysul
sysul:	syscall	zysul,37

	Global	sysxi
	Extern	zysxi
sysxi:	Mov_	Mem(reg_xs),XS
	syscall	zysxi,38

.if asm
	%macro	callext	2
	Extern	%1
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
	Extern	\name
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
	Extern	$1
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

	Global	cvd__
cvd__:
	Extern	i_cvd
	Mov_	Mem(reg_wa),WA
	call	i_cvd
	Mov_	WA,Mem(reg_wa)
	ret

;	dvi__ - divide ia (edx) by long in w0
	Global	dvi__
dvi__:
	Extern	i_dvi
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

	Global	rmi__
;       rmi__ - remainder of ia (edx) divided by long in w0
rmi__:
	jmp	ocode
	Extern	i_rmi
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
	cdq			; extend dividend
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
	Global	%1
	Extern	%2
%1:
	call	%2
	ret
%endmacro
.fi
.if gas
.if unix
	.macro	int_op glob,ext
	Global	\glob
	Extern	\ext
\glob:
	call	\ext
	ret
	.endm
.fi
.if osx
	.macro	int_op 
	Global	$1
	Extern	$2
\glob:
	call	$2
	ret
	.endm
.fi
.fi

	int_op itr_,f_itr
	int_op rti_,f_rti

;	Extern	i_ldi
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
;	Global	%1
;	Extern	%2
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
	Global	%1
	Extern	%2
%1:
	Mov_	M_word [%3],W0
	call	%2
	ret
	%endmacro
.fi

.if gas
.if unix
	.macro	osint_call glob,ext,reg
	Global	\glob
	Extern	\ext
\glob:
	Mov_	\reg,W0
	call	\ext
	ret
	.endm
.fi
.if osx
	.macro	osint_call 
	Global	$1
	Extern	$2
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
	Global	%1
	Extern	%2
%1:
	call	%2
	ret
	%endmacro
.fi
.if gas
.if unix
	.macro	math_op glob,ext
	Global	\glob
	Extern	\ext
\glob:
	call	\ext
	ret
	.endm
.fi
.if osx
	.macro	math_op 
	Global	$1
	Extern	$2
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
	Global	ovr_
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

	Global	get_fp			; get frame pointer

get_fp:
	Mov_	W0,Mem(reg_xs)     ; minimal's xs
	Add_	W0,4           	; pop return from call to sysbx or sysxi
	ret                    	; done

	Extern	rereloc

	Global	restart
	Extern	lmodstk
	Extern	startbrk
	Extern	outptr
	Extern	swcoup
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
re4:	Mov_	W0,Mem(stbas)
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

	Global	trc_
	Extern	trc
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


	Global	reav1
