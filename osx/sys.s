	.set	cfp_b,4
	.set	cfp_c,4
	.set	os ,osx
	.set	log_cfp_b,2
	.set	log_cfp_c,2
	.set	ws,32

#
# copyright 1987-2012 robert b. k. dewar and mark emmer.
# copyright 2012-2015 david shields
#
# this file is part of macro spitbol.
#
#     macro spitbol is free software: you can redistribute it and/or modify
#     it under the terms of the gnu general public license as published by
#     the free software foundation, either version 2 of the license, or
#     (at your option) any later version.
#
#     macro spitbol is distributed in the hope that it will be useful,
#     but without any warranty; without even the implied warranty of
#     merchantability or fitness for a particular purpose.  see the
#     gnu general public license for more details.
#
#     you should have received a copy of the gnu general public license
#     along with macro spitbol.  if not, see <http://www.gnu.org/licenses/>.
#
#
#
#       this file contains the assembly language routines that interface
#       the macro spitbol compiler written in 80386 assembly language to its
#       operating system interface functions written in c.
#
#       contents:
#
#       o overview
#       o global variables accessed by osint functions
#       o interface routines between compiler and osint functions
#       o c callable function _startup
#       o c callable function _get_fp
#       o c callable function _restart
#       o c callable function makeexec
#       o routines for _minimal opcodes chk and cvd
#       o math functions for integer multiply, divide, and remainder
#       o math functions for real operation
#
#       overview
#
#       the macro spitbol compiler relies on a set of operating system
#       interface functions to provide all interaction with the host
#       operating system.  these functions are referred to as osint
#       functions.  a typical call to one of these osint functions takes
#       the following form in the 80386 version of the compiler:
#
#               ...code to put arguments in registers...
#               call    sysxx           # call osint function
#             D_word    extrc_1          # address of exit point 1
#             D_word    extrc_2          # address of exit point 2
#               ...     ...             # ...
#             D_word    extrc_n          # address of exit point n
#               ...instruction following call...
#
#       the osint function 'sysxx' can then return in one of n+1 ways:
#       to one of the n exit points or to the instruction following the
#       last exit.  this is not really very complicated - the call places
#       the return address on the stack, so all the interface function has
#       to do is add the appropriate offset to the return address and then
#       pick up the exit address and jump to it or do a normal return via
#       an ret instruction.
#
#       unfortunately, a c function cannot handle this scheme.  so, an
#       intermediary set of routines have been established to allow the
#       interfacing of c functions.  the mechanism is as follows:
#
#       (1) the compiler calls osint functions as described above.
#
#       (2) a set of assembly language interface routines is established,
#           one per osint function, named accordingly.  each interface
#           routine ...
#
#           (a) saves all compiler registers in global variables
#               accessible by c functions
#           (b) calls the osint function written in c
#           (c) restores all compiler registers from the global variables
#           (d) inspects the osint function's return value to determine
#               which of the n+1 returns should be taken and does so
#
#       (3) a set of c language osint functions is established, one per
#           osint function, named differently than the interface routines.
#           each osint function can access compiler registers via global
#           variables.  no arguments are passed via the call.
#
#           when an osint function returns, it must return a value indicating
#           which of the n+1 exits should be taken.  these return values are
#           defined in header file 'inter.h'.
#
#       note:  in the actual implementation below, the saving and restoring
#       of registers is actually done in one common routine accessed by all
#       interface routines.
#
#       other notes:
#
#       some c ompilers transform "internal" global names to
#       "external" global names by adding a leading underscore at the front
#       of the internal name.  thus, the function name 'osopen' becomes
#       '_osopen'.  however, not all c compilers follow this convention.
#

# Operation and declaration macros are needed for each instruction/declaration having different formats in asm and gas.


	.macro	Cmp_	dst,src	# src/dst differ
		cmpl	\src,\dst
	.endm



	.macro	Add_	dst,src
		add	\src,\dst
	.endm

	.macro	Align_	bytes
		.balign	\bytes,0
	.endm

	.macro	And_	dst,src
	and	\src,\dst
	.endm

	.macro	Cmpb_	dst,src	# src/dst differ
		cmpb	\src,\dst
	.endm

	.macro	Data
		.data
	.endm

	.macro	Equ_	name,value
	.set	\name,\value
	.endm

	.macro	Dec_	val
	decl \val
	.endm


	.macro	Inc_	val
		incl	\val
	.endm
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


	.macro	Mov_	dst,src
		movl	\src,\dst
	.endm

	.macro	Sal_	dst,src
		sall	$\src,\dst
	.endm

	.macro	Sar_	dst,src
		sarl	$\src,\dst
	.endm

	.macro	Stos_w
	stosl
	.endm

	.macro	Jmp_	lab	# gas needs '*' before target
		jmp	\lab
	.endm

	.macro	Lea_	dst,src	# load effective address
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
#
# .if 32
# 	Equ_	cfp_b,4
# 	Equ_	cfp_c,4
# 	Equ_	log_cfp_b,2
# 	Equ_	cfp_c_val,4
# 	Equ_	log_cfp_c,2
# 	Equ_	cfp_m_	2147483647
# ;	%define	cfp_n_	32
# .fi
# .if 64
# 	Equ_	cfp_b,8
# 	Equ_	cfp_c,8
# 	Equ_	log_cfp_b,3
# 	Equ_	log_cfp_c,3
# 	Equ_	cfp_c_val,8
# 	Equ_	cfp_m_,9223372036854775807
# 	Equ_	cfp_n_,64
#
# .fi
#







        Text
	Global	_dnamb
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

	.set	cfp_b,4
	.set	cfp_c,4
	.set	cfp_b,4
	.set	cfp_c,4

	Global	_reg_block
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
#	Global	reg_size

	Global	reg_rp

	Global	_minimal
	Extern	_stacksiz

#	values below must agree with calltab defined in x32.hdr and also in osint/osint.h

	Equ_	_minimal_relaj,0
	Equ_	_minimal_relcr,1
	Equ_	_minimal_reloc,2
	Equ_	_minimal_alloc,3
	Equ_	_minimal_alocs,4
	Equ_	_minimal_alost,5
	Equ_	_minimal_blkln,6
	Equ_	_minimal_insta,7
	Equ_	_minimal_rstrt,8
	Equ_	_minimal_start,9
	Equ_	_minimal_filnm,10
	Equ_	_minimal_dtype,11
	Equ_	_minimal_enevs,10
	Equ_	_minimal_engts,12

	Equ_	globals,1

#   table to recover type word from type ordinal

	Global	typet
	Data
        .long	b_art   # arblk type word - 0
        .long	b_cdc   # cdblk type word - 1
        .long	b_exl   # exblk type word - 2
        .long	_b_icl   # icblk type word - 3
        .long	b_nml   # nmblk type word - 4
        .long	p_aba   # p0blk type word - 5
        .long	p_alt   # p1blk type word - 6
        .long	p_any   # p2blk type word - 7
# next needed only if support real arithmetic cnra
#       D_word	b_rcl   ; rcblk type word - 8
        .long	_b_scl   # scblk type word - 9
        .long	b_sel   # seblk type word - 10
        .long	b_tbt   # tbblk type word - 11
        .long	b_vct   # vcblk type word - 12
        .long	_b_xnt   # xnblk type word - 13
        .long	_b_xrt   # xrblk type word - 14
        .long	b_bct   # bcblk type word - 15
        .long	b_pdt   # pdblk type word - 16
        .long	b_trt   # trblk type word - 17
        .long	b_bft   # bfblk type word   18
        .long	b_cct   # ccblk type word - 19
        .long	b_cmt   # cmblk type word - 20
        .long	b_ctt   # ctblk type word - 21
        .long	b_dfc   # dfblk type word - 22
        .long	b_efc   # efblk type word - 23
        .long	b_evt   # evblk type word - 24
        .long	b_ffc   # ffblk type word - 25
        .long	b_kvt   # kvblk type word - 26
        .long	b_pfc   # pfblk type word - 27
        .long	b_tet   # teblk type word - 28
#
#   table of _minimal entry points that can be dded from c
#   via the _minimal function (see inter.asm).
#
#   note that the order of entries in this table must correspond
#   to the order of entries in the call enumeration in osint.h
#   and osint.inc.
#
	Global calltab
calltab:
        .long	relaj
        .long	relcr
        .long	reloc
        .long	alloc
        .long	alocs
        .long	alost
        .long	blkln
        .long	insta
        .long	rstrt
        .long	start
        .long	filnm
        .long	dtype
#       D_word	enevs ;  engine words
#       D_word	engts ;   not used

	Global	b_efc
	Global	_b_icl
	Global	b_rcl
	Global	_b_scl
	Global	b_vct
	Global	_b_xnt
	Global	_b_xrt
	Global	_c_aaa
	Global	_c_yyy
	Global	_dnamb
	Global	cswfl
	Global	_dnamp
	Global	_flprt
	Global	_flptr
	Global	_g_aaa
	Global	gbcnt
	Global	_gtcef
	Global	_headv
	Global	_hshtb
	Global	kvstn
	Global	kvdmp
	Global	kvftr
	Global	kvcom
	Global	kvpfl
	Global	mxlen
	Global	_polct
	Global	_s_yyy
	Global	_s_aaa
	Global	stage
	Global	_state
	Global	_stbas
	Global	statb
        Global  stmcs
        Global  stmct
	Global	timsx
	Global  typet
	Global	_pmhbs
	Global	r_cod
	Global	_r_fcb
	Global	_w_yyy
	Global	end_min_data
#       Global variables

	Data

	Align_ 16
dummy:	.long	0
_reg_block:
reg_ia: .long	0		# register ia (ebp)
reg_w0:	.long	0        	# register wa (ecx)
reg_wa:	.long	0        	# register wa (ecx)
reg_wb:	.long 	0        	# register wb (ebx)
reg_wc:	.long	0		# register wc
reg_xr:	.long	0        	# register xr (xr)
reg_xl:	.long	0        	# register xl (xl)
reg_cp:	.long	0        	# register cp
reg_ra:	.double 	0.0  		# register ra

# these locations save _information needed to return after calling osint and after a _restart from exit()

reg_pc: .long      0               # return pc from caller
reg_xs:	.long	0		# _minimal stack pointer

#	r_size  equ       $-_reg_block

#r_size	equ	16*cfp_b

#reg_size:	dd   r_size

# end of words saved during exit(-3)

# reg_rp is used to pass pointer to real operand for real arithmetic

reg_rp:	.long	0

# reg_fl is used to communicate condition codes between _minimal and c code.

	Global	reg_fl
reg_fl:	.byte	0		# condition code register for numeric operations

	Align_	8

#  constants

	Global	ten
ten:    .long      10              # constant 10
	Global  _inf
_inf:	.long	0
	.long      0x7ff00000      # double precision _infinity
	Global	maxint
maxint:	.long 2147483647

	Global	sav_block
sav_block:
	Fill 	44 			# save _minimal registers during push/pop reg

	Align_ cfp_b
	Global	ppoff

ppoff:  .long      0               	# offset for ppm exits

	Global	compsp
compsp: .long      0               	# compiler's stack pointer

	Global	sav_compsp
sav_compsp:
	.long      0               	# save compsp here

	Global	osisp
osisp:  .long      0               	# osint's stack pointer

	Global	_rc_
_rc_:	.long   0				# return code from osint procedure

	Align_	cfp_b
	Global	save_cp
	Global	save_xl
	Global	save_xr
	Global	save_wa
	Global	save_wb
	Global	save_wc
	Global	save_xs
save_cp:	.long	0		# saved cp value
save_ia:	.long	0		# saved ia value
save_xl:	.long	0		# saved xl value
save_xr:	.long	0		# saved xr value
save_wa:	.long	0		# saved wa value
save_wb:	.long	0		# saved wb value
save_wc:	.long	0		# saved wc value
save_xs:	.long	0		# saved xs value

	Global	__minimal_id
__minimal_id:	.long	0		# id for call to minimal from c. see proc minimal below.

#
#	%define setreal 0
#
#       setup a number of internal addresses in the compiler that cannot be directly accessed from within
#	c because of naming difficulties.
#
	Global	id1
id1:	.long	0

	Global	_id1blk
_id1blk:	.long	152
	.long	0
	Fill	152

	Global	_id2blk
_id2blk:	.long	152
      	.long	0
	Fill	152

	Global	_ticblk
_ticblk:
	.long	0
	.long	0

	Global	_tscblk
_tscblk:
	.long	512
	.long	0
	Fill	512

#       standard input buffer block.

	Global  _inpbuf

_inpbuf:	.long	0			# type word
	.long	0               	# block length
	.long	1024            	# buffer size
	.long	0               	# remaining chars to read
	.long	0               	# offset to next character to read
	.long	0               	# file position of buffer
	.long	0               	# physical position in file
	Fill	1024

	Global  _ttybuf

_ttybuf:	.long    0     # type word
	.long	0								# block length
	.long	260             	# buffer size  (260 ok in ms-dos with cinread())
	.long	0               	# remaining chars to read
	.long	0               	# offset to next char to read
	.long	0               	# file position of buffer
	.long	0               	# physical position in file
	Fill	260	         	# buffer

	Global	spmin

spmin:	.long	0			# stack limit (stack grows down for x86_64)
spmin.a:	.long	spmin

	Align_	16
	Align_	cfp_b

call_adr:	.long	0

	Text
#
#       save and restore _minimal and interface registers on stack.
#       used by any routine that needs to call back into the _minimal
#       code in such a way that the _minimal code might trigger another
#       sysxx call before returning.
#
#       note 1:  pushregs returns a collectable value in xl, safe
#       for subsequent call to memory allocation routine.
#
#       note 2:  these are not recursive routines.  only reg_xl is
#       saved on the stack, where it is accessible to the garbage
#       collector.  other registers are just moved to a temp area.
#
#       note 3:  popregs does not restore reg_cp, because it may have
#       been modified by the _minimal routine called between pushregs
#       and popregs as a result of a garbage collection.  calling of
#       another sysxx routine in between is not a problem, because
#       cp will have been preserved by _minimal.
#
#       note 4:  if there isn't a compiler stack yet, we don't bother
#       saving xl.  this only happens in call of nextef from sysxi when
#       reloading a save file.
#
#
	Global	save_regs
save_regs:
	Mov_	save_xl,%esi
	Mov_	save_xr,%edi
	Mov_	save_wa,%ecx
	Mov_	save_wb,%ebx
	Mov_	save_wc,%edx
	Mov_	save_xs,%esp
	ret

	Global	restore_regs
restore_regs:
	#	restore regs, except for sp. that is caller's responsibility
	Mov_	%esi,save_xl
	Mov_	%edi,save_xr
	Mov_	%ecx,save_wa
	Mov_	%ebx,save_wb
	Mov_	%edx,save_wc
	ret
#
# ;
# ;       _startup( char *dummy1, char *dummy2) - startup compiler
# ;
# ;       an osint c function calls _startup to transfer control
# ;       to the compiler.
# ;
# ;       (xr) = basemem
# ;       (xl) = topmem - sizeof(word)
# ;
# ;	note: this function never returns.
# ;
#
#

	Global	_startup

#   ordinals for _minimal calls from assembly language.

#   the order of entries here must correspond to the order of calltab entries in the inter assembly language module.

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


_startup:
	pop	%eax			# discard return
	Mov_	%eax,maxint		# set maximum integer value
	Mov_	mxint,%eax
	call	stackinit		# initialize _minimal stack
	Mov_	%eax,compsp		# get _minimal's stack pointer
	Mov_ 	reg_wa,%eax		# _startup stack pointer

	cld				# default to up direction for string ops
#	getoff  W0,dffnc		; get address of ppm offset
	Mov_	ppoff,%eax		# save for use later

	Mov_	%esp,osisp		# switch to new c stack
	Mov_	%eax,$calltab_start
	Mov_	__minimal_id,%eax
	call	_minimal			# load regs, switch stack, start compiler
#
#	stackinit  -- initialize spmin from sp.
#
#	input:  sp - current c stack
#		_stacksiz - size of desired _minimal stack in bytes
#
#	uses:	W0
#
#	output: register wa, sp, spmin, compsp, osisp set up per diagram:
#
#	(high)	+----------------+
#		|  old c stack   |
#	  	|----------------| <-- incoming sp, resultant wa (future xs)
#		|	     ^	 |
#		|	     |	 |
#		/ _stacksiz bytes /
#		|	     |	 |
#		|            |	 |
#		|----------- | --| <-- resultant spmin
#		| 400 bytes  v   |
#		|----------------| <-- future c stack pointer, osisp
#		|  new c stack	 |
#	(low)	|                |
#

#	initialize stack

	Global	stackinit
stackinit:
	Mov_	%eax,%esp
	Mov_	compsp,%eax	# save _minimal's stack pointer
	Sub_	%eax,_stacksiz	# end of _minimal stack is where c stack will start
	Mov_	osisp,%eax	# save new c stack pointer
	Add_	%eax,$cfp_b*100		# 100 words smaller for chk
	Mov_	spmin,%eax
	ret

#	check for stack overflow, making W0 nonzero if found

	Global	chk__
chk__:
	xor	%eax,%eax			# set return value assuming no overflow
	Cmp_	%esp,spmin
	jb	chk.oflo
	ret
chk.oflo:
	inc	%eax			# make nonzero to indicate stack overflo%eax
	ret
#
#	mimimal -- call _minimal function from c
#
#	usage:  extern void _minimal(word callno)
#
#	where:
#	callno is an ordinal defined in osint.h, osint.inc, and calltab.
#
#	_minimal registers wa, wb, wc, xr, and xl are loaded and
#	saved from/to the register block.
#
#	note that before _restart is called, we do not yet have compiler
#	stack to switch to.  in that case, just make the call on the
#	the osint stack.
#
_minimal:
	Mov_	%ecx,reg_wa	# restore registers
	Mov_	%ebx,reg_wb
	Mov_	%edx,reg_wc	#
	Mov_	%edi,reg_xr
	Mov_	%esi,reg_xl

	Mov_	osisp,%esp	# save osint stack pointer
	xor	%eax,%eax
	Cmp_	compsp,%eax	# is there a compiler stack?
	je	min1			# jump if none yet
	Mov_	%esp,compsp	# switch to compiler stack

 min1:
	Mov_	%eax,__minimal_id	# get ordinal
#	call	Mem(calltab+W0*cfp_b)    ; off to the _minimal code
	call	start

	Mov_	%esp,osisp	# switch to osint stack

	Mov_	reg_wa,%ecx	# save registers
	Mov_	reg_wb,%ebx
	Mov_	reg_wc,%edx
	Mov_	reg_xr,%edi
	Mov_	reg_xl,%esi
	ret

#
#
#	interface routines
#
#	each interface routine takes the following form:
#
#	sysxx:
#			call    ccaller ; call common interface
#                     	D_word    zysxx   ; dd      of c osint function
#                       db      n       ; offset to instruction after
#                                       ;   last procedure exit
#
#	in an effort to achieve portability of c osint functions, we
#	do not take take advantage of any "internal" to "external"
#	transformation of names by c compilers.  so, a c osint function
#	representing sysxx is named _zysxx.  this renaming should satisfy
#	all c compilers.
#
#	important  one interface routine, sysfc, is passed arguments on
#	the stack.  these items are removed from the stack before calling
#	ccaller, as they are not needed by this implementation.
#
#	ccaller is called by the os interface routines to call the
#	real c os interface function.
#
#	general calling sequence is
#
#			call	ccaller
#			d_word	address_of_c_function
#			db      2*number_of_extrc_points
#
#	control is never returned to a interface routine.  instead, control
#	is returned to the compiler (the caller of the interface routine).
#
#	the c function that is called must always return an integer
#	indicating the procedure exit to take or that a normal return
#	is to be performed.
#
#	c function      interpretation
#	return value
#	------------    -------------------------------------------
#	<0         do normal return to instruction past
#	last procedure exit (distance passed
#	in by dummy routine and saved on stack)
#	0	take procedure exit 1
#	4	take procedure exit 2
#	8	take procedure exit 3
#	...        ...
#

#%ifdef	OLD
#	Global	get_ia
#get_ia:
#	Mov_	W0,IA
#	ret
#
#	Global	set_ia_
#set_ia_:	Mov_	IA,M_word[reg_w0]
#	ret
#%endif
syscall_init:
#	save registers in global variables

	Mov_	reg_wa,%ecx      # save registers
	Mov_	reg_wb,%ebx
	Mov_	reg_wc,%edx      # (also _reg_ia)
	Mov_	reg_xr,%edi
	Mov_	reg_xl,%esi
	ret

syscall_exit:
	Mov_	_rc_,%eax	# save return code from function
	Mov_	osisp,%esp	# save osint's stack pointer
	Mov_	%esp,compsp	# restore compiler's stack pointer
	Mov_	%ecx,reg_wa	# restore registers
	Mov_	%ebx,reg_wb
	Mov_	%edx,reg_wc      #
	Mov_	%edi,reg_xr
	Mov_	%esi,reg_xl
	cld
	Mov_	%eax,reg_pc
	jmp	*%eax		# gas jump to absolute address requires '*' prefix.

	.macro	syscall	proc,id
	pop	%eax			# pop return address
	Mov_	reg_pc,%eax
	call	syscall_init

#	save compiler stack and switch to osint stack

	Mov_	compsp,%esp      # save compiler's stack pointer
	Mov_	%esp,osisp       # load osint's stack pointer
	call	\proc
	call	syscall_exit
	.endm

	Global sysax
	Extern	_zysax
sysax:	syscall	  _zysax,1

	Global sysbs
	Extern	_zysbs
sysbs:	syscall	  _zysbs,2

	Global sysbx
	Extern	_zysbx
sysbx:	Mov_	reg_xs,%esp
	syscall	_zysbx,2

#	global syscr
#	Extern	zyscr
#syscr:	syscall	zyscr,0

	Global sysdc
	Extern	_zysdc
sysdc:	syscall	_zysdc,4

	Global sysdm
	Extern	_zysdm
sysdm:	syscall	_zysdm,5

	Global sysdt
	Extern	_zysdt
sysdt:	syscall	_zysdt,6

	Global sysea
	Extern	_zysea
sysea:	syscall	_zysea,7

	Global sysef
	Extern	_zysef
sysef:	syscall	_zysef,8

	Global sysej
	Extern	_zysej
sysej:	syscall	_zysej,9

	Global sysem
	Extern	_zysem
sysem:	syscall	_zysem,10

	Global sysen
	Extern	_zysen
sysen:	syscall	_zysen,11

	Global sysep
	Extern	_zysep
sysep:	syscall	_zysep,12

	Global sysex
	Extern	_zysex
sysex:	Mov_	reg_xs,%esp
	syscall	_zysex,13

	Global sysfc
	Extern	_zysfc
sysfc:  pop	%eax             # <<<<remove stacked scblk>>>>
	Mov_	%eax,%edx
	Sal_	%eax,$log_cfp_b
	Add_	%esp,%eax

	push	%eax
	syscall	_zysfc,14

	Global	sysgc
	Extern	_zysgc
sysgc:	syscall	_zysgc,15

	Global	syshs
	Extern	_zyshs
syshs:	Mov_	reg_xs,%esp
	syscall	_zyshs,16

	Global	sysid
	Extern	_zysid
sysid:	syscall	_zysid,17

	Global	sysif
	Extern	_zysif
sysif:	syscall	_zysif,18

	Global	sysil
	Extern	_zysil
sysil:	syscall	_zysil,19

	Global	sysin
	Extern	_zysin
sysin:	syscall	_zysin,20

	Global	sysio
	Extern	_zysio
sysio:	syscall	_zysio,21

	Global	sysld
	Extern	_zysld
sysld:	syscall	_zysld,22

	Global	sysmm
	Extern	_zysmm
sysmm:	syscall	_zysmm,23

	Global	sysmx
	Extern	_zysmx
sysmx:	syscall	_zysmx,24

	Global	sysou
	Extern	_zysou
sysou:	syscall	_zysou,25

	Global	syspi
	Extern	_zyspi
syspi:	syscall	_zyspi,26

	Global	syspl
	Extern	_zyspl
syspl:	syscall	_zyspl,27

	Global	syspp
	Extern	_zyspp
syspp:	syscall	_zyspp,28

	Global	syspr
	Extern	_zyspr
syspr:	syscall	_zyspr,29

	Global	sysrd
	Extern	_zysrd
sysrd:	syscall	_zysrd,30

	Global	sysri
	Extern	_zysri
sysri:	syscall	_zysri,32

	Global	sysrw
	Extern	_zysrw
sysrw:	syscall	_zysrw,33

	Global	sysst
	Extern	_zysst
sysst:	syscall	_zysst,34

	Global	systm
	Extern	_zystm
systm:	syscall	_zystm,35

	Global	systt
	Extern	_zystt
systt:	syscall	_zystt,36

	Global	sysul
	Extern	_zysul
sysul:	syscall	_zysul,37

	Global	sysxi
	Extern	_zysxi
sysxi:	Mov_	reg_xs,%esp
	syscall	_zysxi,38

	.macro	callext	name,id
	Extern	\name
	call	\name
	Add_%esp,\id		# pop arguments
	.endm

	.macro	chk_
	call	chk__
	.endm

	.macro	adi_
	Add_	reg_ia,%eax
	seto	reg_fl
	.endm

	.macro	dvi_
	Mov_	reg_w0,%eax
	call	dvi__
	.endm

	.macro	ldi_	val
	Mov_	%eax,\val
	Mov_	reg_ia,%eax
	.endm

	.macro	mli_
	mov	reg_ia,%eax
	imul	%eax
	seto	reg_fl
	.endm

# using W0 below since operand size not known, and putting it in register defers this problem

	.macro	ngi_
	mov	reg_ia,%eax
	neg	%eax
	mov	%eax,reg_ia
#	neg	Mem(reg_ia)
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
	Sub	reg_ia,%eax
	seto	reg_fl
	.endm

	.macro	sti_	dst
	Mov_	%eax,reg_ia
	Mov_	\dst,%eax
	.endm

	.macro	Icp_
	Mov_	%eax,reg_cp
	Add_	%eax,cfp_b
	Mov_	reg_cp,%eax
	.endm

	.macro	Lcp_	val
	Mov_	%eax,\val
	Mov_	reg_cp,%eax
	.endm

	.macro	Lcw_	val
	Mov_	%eax,reg_cp			# load address of code word
	push	%eax
	Mov_	%eax,(%eax)				# load code word
	Mov_	\val,%eax
	pop	%eax 				# load address of code word
	Add_	%eax,$cfp_b
	Mov_	reg_cp,%eax
	.endm

	.macro	Scp_	val
	Mov_	%eax,reg_cp
	Mov_	\val,%eax
	.endm

#
#	x64 hardware divide, expressed in form of _minimal register mappings, requires dividend be
#	placed in W0, which is then sign extended into wc:W0. after the divide, W0 contains the
#	quotient, wc contains the remainder.
#
#	cvd__ - convert by division
#
#	input   ia = number <=0 to convert
#	output  ia / 10
#	wa ecx) = remainder + '0'
#

	Global	cvd__
cvd__:
	Extern	_i_cvd
	Mov_	reg_wa,%ecx
	call	_i_cvd
	Mov_	%ecx,reg_wa
	ret

#	dvi__ - divide ia (edx) by long in w0
	Global	dvi__
dvi__:
	Extern	__i_dvi
	Mov_	reg_w0,%eax
	call	__i_dvi
	movb	reg_fl,%al
	or	%al,%al
	ret

	Global	rmi__
#       rmi__ - remainder of ia (edx) divided by long in w0
rmi__:
	jmp	ocode
	Extern	__i_rmi
	Mov_	reg_w0,%eax
	call	__i_rmi
	movb	reg_fl,%al
	or	%al,%al
	ret

ocode:
	or	%eax,%eax		# test for 0
	jz	setovr		# jump if 0 divisor
	xchg	%eax,reg_ia	# ia to w0, divisor to ia
	cdq			# extend dividend
	Mov_	%eax,reg_ia
	idiv	%eax		# perform division. w0=quotient, wc=remainder
	seto	reg_fl
	Mov_	reg_ia,%edx
	ret

setovr:
	xor	%al,%al		# set overflow indicator
	inc	%al
	movb	%al,reg_fl
	ret

	.macro	int_op glob,ext
	Global	\glob
	Extern	\ext
\glob:
	call	\ext
	ret
	.endm

	int_op itr_,_f_itr
	int_op rti_,_f_rti

#	Extern	i_ldi
#	%macro	ldi_	1
#	Mov_	W0,%1
#	Mov_	Mem(reg_ia),W0
#	call	i_ldi
#	%endmacro
#
#	%macro	sti_	1
#	Mov_	W0, Mem(reg_ia)
#	Mov_	%1,W0
#	%endmacro
#
#	Extern w00
#	%macro	int_op 2
#	Global	%1
#	Extern	%2
#%1:
#	Mov_	Mem(reg_w0),W0
#	call	%2
#	ret
#	%endmacro
#
#	int_op	adi_,_i_adi
#	int_op	mli_,_i_mli
#	int_op	sbi_,i_sbi
#	int_op	dvi_,__i_dvi
#	int_op	rmi_,__i_rmi
#	int_op	ngi_,_i_ngi	; causes spurious store of W0 that doesn't matter
#	int_op	itr_,_f_itr
#	int_op	rti_,_f_rti
#%endif


	.macro	osint_call glob,ext,reg
	Global	\glob
	Extern	\ext
\glob:
	Mov_	\reg,%eax
	call	\ext
	ret
	.endm


	.macro	real_op op,proc
	osint_call	\op,\proc,reg_rp
	.endm

	real_op	ldr_,_f_ldr
	real_op	str_,_f_str
	real_op	adr_,_f_adr
	real_op	sbr_,_f_sbr
	real_op	mlr_,_f_mlr
	real_op	dvr_,_f_dvr
	real_op	ngr_,_f_ngr
	real_op cpr_,_f_cpr

	.macro	math_op glob,ext
	Global	\glob
	Extern	\ext
\glob:
	call	\ext
	ret
	.endm

	math_op	atn_,_f_atn
	math_op	chp_,_f_chp
	math_op	cos_,_f_cos
	math_op	etx_,_f_etx
	math_op	lnf_,_f_lnf
	math_op	sin_,_f_sin
	math_op	sqr_,_f_sqr
	math_op	tan_,_f_tan

#	ovr_ test for overflow value in ra
	Global	ovr_
ovr_:
	mov	$reg_ra,%eax
	add	$6,%eax
	movw	(%eax),%ax		# get top 2 bytes
	and	$0x7ff0,%ax		# check for _infinity or nan
	add	$0x10,%ax		# set/clear overflow accordingly
	ret

	Global	_get_fp			# get frame pointer

_get_fp:
	Mov_	%eax,reg_xs     # _minimal's xs
	Add_	%eax,4           	# pop return from call to sysbx or sysxi
	ret                    	# done

	Extern	_rereloc

	Global	_restart
	Extern	_lmodstk
	Extern	_startbrk
	Extern	_outptr
	Extern	_swcoup
#	scstr is offset to start of string in scblk, or two words
#scstr	equ	cfp_c+cfp_c

#
_restart:
	Cmp_	%eax,$4
	je	re4			# yes, do a complete fudge

#       jump back with return value = normal_return

	xor	%eax,%eax			# set to zero to indicate normal return
	call	syscall_exit
	ret
#
#	here if -w produced load module.  simulate all the code that
#	would occur if we naively returned to sysbx.  clear the stack and
#	go for it.
#
re4:	Mov_	%eax,_stbas
	Mov_	compsp,%eax     	# empty the stack

#	code that would be executed if we had returned to makeexec:

	xor	%eax,%eax
	Mov_	gbcnt,%eax       	# reset garbage collect count to zero
	call	_zystm                 	# fetch execution time to reg_ia
	Mov_	%eax,reg_ia     	# set time into compiler
	Mov_	timsx,%eax

#	code that would be executed if we returned to sysbx:

	push	_outptr        	# _swcoup(outptr)
	Extern 	_swcoup
	call	_swcoup
	Add_	%esp,cfp_b

#	jump to _minimal code to _restart a save file.

	Mov_	%eax,_minimal_rstrt
	Mov_	__minimal_id,%eax
	call	_minimal			# no return

	Global	trc_
	Extern	trc
trc_:
	pushf
	call	save_regs
	call	trc
	call	restore_regs
	popf
	ret


	Global	reav1
# osx renamed
# fixed 225
