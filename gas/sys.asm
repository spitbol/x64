# opyright 1987-2012 robert b. k. dewar and mark emmer.

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
#     but without any warranty# without even the implied warranty of
#     merchantability or fitness for a particular purpose.  see the
#     gnu general public license for more details.
#
#     you should have received a copy of the gnu general public license
#     along with macro spitbol.  if not, see <http://www.gnu.org/licenses/>.


#	ws is bits per word, cfp_b is bytes per word, cfp_c is characters per word

	.data
#	.set	os,unix
#	.set	ws,64
	.set	cfp_b,8
	.set	cfp_c,8

	.set	flag_of,0x80
	.set	flag_cf,0x01
	.set	flag_ca,0x40

	.global	reg_block
	.global	reg_w0 
	.global	reg_wa
	.global	reg_wb
	.global	reg_ia
	.global	reg_wc
	.global	reg_xr
	.global	reg_xl
	.global	reg_cp
	.global	reg_ra
	.global	reg_rb
	.global	reg_pc
	.global	reg_xs
	.global	reg_size
	.global	reav1

	.global	reg_rp

	.global	c_minimal

#	values below must agree with calltab defined in osint/osint.h

	.set	minimal_relaj,0
	.set	minimal_relcr,1
	.set	minimal_reloc,2
	.set	minimal_alloc,3
	.set	minimal_alocs,4
	.set	minimal_alost,5
	.set	minimal_blkln,6
	.set	minimal_insta,7
	.set	minimal_rstrt,8
	.set	minimal_start,9
	.set	minimal_filnm,10
	.set	minimal_dtype,11
	.set	minimal_enevs,10
	.set	minimal_engts,12

	.set	globals,1                       #asm globals defined here


#       ---------------------------------------

#       this file contains the assembly language routines that interface
#       the macro spitbol compiler written in 80386 assembly language to its
#       operating system interface functions written in c.

#       contents:

#       o overview
#       o global variables accessed by osint functions
#       o interface routines between compiler and osint functions
#       o c callable function startup
#       o c callable function get_fp
#       o c callable function restart
#       o c callable function makeexec
#       o routines for minimal opcodes chk and cvd
#       o math functions for integer multiply, divide, and remainder
#       o math functions for real operation

#       overview

#       the macro spitbol compiler relies on a set of operating system
#       interface functions to provide all interaction with the host
#       operating system.  these functions are referred to as osint
#       functions.  a typical call to one of these osint functions takes
#       the following form in the 80386 version of the compiler:

#               ...code to put arguments in registers...
#               call    sysxx           # call osint function
#             .quad    exit_1          # address of exit point 1
#             .quad    exit_2          # address of exit point 2
#               ...     ...             # ...
#             .quad    exit_n          # address of exit point n
#               ...instruction following call...

#       the osint function 'sysxx' can then return in one of n+1 ways:
#       to one of the n exit points or to the instruction following the
#       last exit.  this is not really very complicated - the call places
#       the return address on the stack, so all the interface function has
#       to do is add the appropriate offset to the return address and then
#       pick up the exit address and jump to it or do a normal return via
#       an ret instruction.

#       unfortunately, a c function cannot handle this scheme.  so, an
#       intermediary set of routines have been established to allow the
#       interfacing of c functions.  the mechanism is as follows:

#       (1) the compiler calls osint functions as described above.

#       (2) a set of assembly language interface routines is established,
#           one per osint function, named accordingly.  each interface
#           routine ...

#           (a) saves all compiler registers in global variables
#               accessible by c functions
#           (b) calls the osint function written in c
#           (c) restores all compiler registers from the global variables
#           (d) inspects the osint function's return value to determine
#               which of the n+1 returns should be taken and does so

#       (3) a set of c language osint functions is established, one per
#           osint function, named differently than the interface routines.
#           each osint function can access compiler registers via global
#           variables.  no arguments are passed via the call.

#           when an osint function returns, it must return a value indicating
#           which of the n+1 exits should be taken.  these return values are
#           defined in header file 'inter.h'.

#       note:  in the actual implementation below, the saving and restoring
#       of registers is actually done in one common routine accessed by all
#       interface routines.

#       other notes:

#       some c ompilers transform "internal" global names to
#       "external" global names by adding a leading underscore at the front
#       of the internal name.  thus, the function name 'osopen' becomes
#       '_osopen'.  however, not all c compilers follow this convention.

#       global variables

#
# # words saved during exit(-3)
# #
	.balign 16
dummy:	.quad	0
reg_block:
reg_ia: .quad	0		# register ia (ebp)
reg_w0:	.quad	0        	# register wa (ecx)
reg_wa:	.quad	0        	# register wa (ecx)
reg_wb:	.quad 	0        	# register wb (ebx)
reg_wc:	.quad	0		# register wc
reg_xr:	.quad	0        	# register xr (xr)
reg_xl:	.quad	0        	# register xl (xl)
reg_cp:	.quad	0        	# register cp
reg_ra:	.double 	0.0  		# register ra
# reg_rb is used to pass argument to real operations
reg_rb:	.double 	0.0  		# register rb

# these locations save information needed to return after calling osint
# and after a restart from exit()

reg_pc: .quad	0               # return pc from caller
reg_xs:	.quad	0		# minimal stack pointer

#	r_size  equ       $-reg_block
	.set	r_size,80
reg_size:	.long   r_size

# end of words saved during exit(-3)

# reg_rp is used to pass pointer to real operand for real arithmetic
reg_rp:	.quad	0

# reg_fl is used to communicate condition codes between minimal and c code.
	.global	reg_fl
reg_fl:	.byte	0		# condition code register for numeric operations

	.balign	8
#  constants

	.global	ten
ten:    .quad      10              # constant 10
	.global  inf
inf:	.long	0
	.long      0x7ff00000      # double precision infinity
	.global	zero
zero:	.quad	0

	.global	sav_block
#sav_block: times r_size db 0     	# save minimal registers during push/pop reg
sav_block: .fill  440,1,0     		# save minimal registers during push/pop reg

	.balign 8
	.global	compsp
compsp: .quad      0               	# compiler's stack pointer
	.global	sav_compsp
sav_compsp:
	.quad      0               	# save compsp here
	.global	osisp
osisp:  .quad      0               	# osint's stack pointer
	.global	_rc_
_rc_:	.byte   0				# return code from osint procedure

	.balign	cfp_b
	.global	save_cp
	.global	save_xl
	.global	save_xr
	.global	save_wa
	.global	save_wb
	.global	save_wc
	.global	save_ia
save_cp:	.quad	0		# saved cp value
save_ia:	.quad	0		# saved ia value
save_xl:	.quad	0		# saved xl value
save_xr:	.quad	0		# saved xr value
save_wa:	.quad	0		# saved wa value
save_wb:	.quad	0		# saved wb value
save_wc:	.quad	0		# saved wc value

	.global	minimal_id
minimal_id:	.quad	0		# id for call to minimal from c. see proc minimal below.

	.global  id1blk
id1blk:	.quad   152
      	.quad   0
	.fill   152,1,0

	.global  id2blk
id2blk:	.quad   152
      	.quad	0
	.fill   152,1,0

	.global ticblk
ticblk:	.quad	0
	.quad   0

	.global  tscblk
tscblk: .quad   512
	.quad   0
	.fill   512,1,0

#       standard input buffer block.

	.global  inpbuf

inpbuf:	.quad	0			# type word
	.quad   0               	# block length
	.quad   1024            	# buffer size
	.quad   0               	# remaining chars to read
	.quad   0               	# offset to next character to read
	.quad   0               	# file position of buffer
	.quad   0               	# physical position in file
	.fill	1024,1,0        	# buffer

	.global  ttybuf

ttybuf:	.quad    0     # type word
	.quad    0               	# block length
	.quad    260             	# buffer size  (260 ok in ms-dos with cinread())
	.quad    0               	# remaining chars to read
	.quad    0               	# offset to next char to read
	.quad    0               	# file position of buffer
	.quad    0               	# physical position in file
	.fill   260,1,0	         	# buffer

	.global	spmin

spmin:	.quad	0			# stack limit (stack grows down for x86_64)
spmin.a:	.quad	spmin

	.balign	16
	.balign	8

call_adr:	.quad	0

init_ra:	.quad	0		# initial return address

	.text
#   ordinals for minimal calls from assembly language.

#   the order of entries here must correspond to the order of
#   calltab entries in the inter assembly language module.

	.set	calltab_relaj,0
	.set	calltab_relcr,1
	.set	calltab_reloc,2
	.set	calltab_alloc,3
	.set	calltab_alocs,4
	.set	calltab_alost,5
	.set	calltab_blkln,6
	.set	calltab_insta,7
	.set	calltab_rstrt,8
	.set	calltab_start,9
	.set	calltab_filnm,10
	.set	calltab_dtype,11
	.set	calltab_enevs,12
	.set	calltab_engts,13
	
#
#       startup( char *dummy1, char *dummy2) - startup compiler
#
#       an osint c function calls startup to transfer control
#       to the compiler.
#
#       (xr) = basemem
#       (xl) = topmem - sizeof(word)
#
#	note: this function never returns.
#
#
	.global	startup
startup:
	pop	%rax			# save return address
#	since we have popped return address, c stack is now aligned on 16-byte boundary.
	mov	%rax,init_ra(%rip)
#	initialize stack
#	stackinit  -- initialize stacks

#	input:  sp - current c stack
#		stacksiz - size of desired minimal stack in bytes

#	uses:	%rax

#	output: register wa, sp, spmin, compsp, osisp set up per diagram:

#	(high)	+----------------+
#		|  old c stack   |
#	  	|----------------| <-- incoming sp, resultant wa (future xs)
#		|	     ^	 |
#		|	     |	 |
#		/ stacksiz bytes /
#		|	     |	 |
#		|            |	 |
#		|----------- | --| <-- resultant spmin
#		| 400 bytes  v   |
#	  	|----------------| <-- future c stack pointer, osisp
#		|  new c stack	 |
#	(low)	|                |

#	initialize stack
#	movq	%rsp,%rax
	movq	%rsp,compsp(%rip)	# save minimal's stack pointer
	subq	stacksiz(%rip),%rsp	# end of minimal stack is where c stack will start
	movq	%rsp,%rax
	addq	$cfp_b*128,%rax	# 128 words smaller for chk (need multiple of 16 for mac osx)
	movq	%rax,spmin(%rip)
#	here with new c stack empty, and hence aligned on 16-byte boundary
	movq	init_ra(%rip),%rax	# get original return address
	pushq	%rax			# restore return address
	pushq	%rbp			# save frame pointer
	subq	$16,%rsp		# keep stack aligned
	movq	%rsp,osisp(%rip)	# save new c stack pointer

	mov	compsp(%rip),%rax		# get minimal's stack pointer
	mov	%rax,reg_wa(%rip)		# startup stack pointer

	cld				# default to up direction for string ops
	mov	osisp(%rip),%rsp	# switch to new c stack
#	initialize registers to values set by osint before calling startup
	movq	reg_ia(%rip),%r12
	movq 	reg_wa(%rip),%rcx	# restore registers
	movq	reg_wb(%rip),%rbx
	movq	reg_wc(%rip),%rdx	#
	movq	reg_xl(%rip),%rsi
	movq	reg_xr(%rip),%rdi
	xorq	%r12,%r12		# initialize IA to zero
	call	start

#	check for stack overflow, making %rax nonzero if found
	.global	chk_
chk_:
	xorq	%rax,%rax		# set return value assuming no overflow
	cmpq	spmin(%rip),%rsp
	jb	chk.oflo
	ret
chk.oflo:
	incq	%rax		# make nonzero to indicate stack overflo
	ret

#       call_mimimal -- call minimal function from c

#       usage:  extern void minimal(word callno)

#       where:
#         callno is an ordinal defined in osint.h, osint.inc, and calltab.

#       minimal registers wa, wb, wc, xr, and xl are loaded and
#       saved from/to the register block.

#       note that before restart is called, we do not yet have compiler
#       stack to switch to.  in that case, just make the call on the
#       the osint stack.

c_minimal:
#	this is just place holder, c_minimal should never be called. Cf. osint/sysxi.c.
# 	force error in case it is ever called.
	xorq %rax,%rax
	jmp *%rax
	ret



#       interface routines

#       each interface routine takes the following form:

#               sysxx   call    ccaller # call common interface
#                     .quad    zysxx   # dd      of c osint function
#                       db      n       # offset to instruction after
#                                       #   last procedure exit

#       in an effort to achieve portability of c osint functions, we
#       do not take take advantage of any "internal" to "external"
#       transformation of names by c compilers.  so, a c osint function
#       representing sysxx is named _zysxx.  this renaming should satisfy
#       all c compilers.

#       important  one interface routine, sysfc, is passed arguments on
#       the stack.  these items are removed from the stack before calling
#       ccaller, as they are not needed by this implementation.

#       ccaller is called by the os interface routines to call the
#       real c os interface function.

#       general calling sequence is

#               call    ccaller
#             .quad    address_of_c_function
#               db      2*number_of_exit_points

#       control is never returned to a interface routine.  instead, control
#       is returned to the compiler (the caller of the interface routine).

#       the c function that is called must always return an integer
#       indicating the procedure exit to take or that a normal return
#       is to be performed.

#               c function      interpretation
#               return value
#               ------------    -------------------------------------------
#                    <0         do normal return to instruction past
#                               last procedure exit (distance passed
#                               in by dummy routine and saved on stack)
#                     0         take procedure exit 1
#                     4         take procedure exit 2
#                     8         take procedure exit 3
#                    ...        ...


syscall_init:
#       save registers in global variables
	movq    %rcx,reg_wa(%rip)      # save registers
	movq	%rbx,reg_wb(%rip)
	movq	%rdx,reg_wc(%rip)
	movq	%rsi,reg_xl(%rip)
	movq	%rdi,reg_xr(%rip)
	movq	%r12,reg_ia(%rip)
	ret

syscallf_init:
#       save registers in global variables
	movq    %rcx,save_wa(%rip)      # save registers
	movq	%rbx,save_wb(%rip)
	movq	%rdx,save_wc(%rip)
	movq	%rsi,save_xl(%rip)
	movq	%rdi,save_xr(%rip)
	movq	%r12,save_ia(%rip)
	ret

syscall_exit:
	movq	reg_wa(%rip),%rcx      # restore registers
	movq	reg_wb(%rip),%rbx
	movq	reg_wc(%rip),%rdx      
	movq	reg_xr(%rip),%rdi
	movq	reg_xl(%rip),%rsi
	movq	reg_ia(%rip),%r12
	cld
	movq	%rax,_rc_(%rip)		# save return code from function
	movq	compsp(%rip),%rsp	# switch to compiler's stack 
	movq	reg_pc(%rip),%rax	# load return address
	jmp	*%rax			# return to caller

syscallf_exit:
	movq	save_wa(%rip),%rcx      # restore registers
	movq	save_wb(%rip),%rbx
	movq	save_wc(%rip),%rdx      
	movq	save_xr(%rip),%rdi
	movq	save_xl(%rip),%rsi
	movq	save_ia(%rip),%r12
	cld
	movq	compsp(%rip),%rsp	# switch to compiler's stack 
	movq	reg_pc(%rip),%rax	# load return address
	jmp	*%rax			# return to caller


	.global	M_rmi
#       rmi - remainder of ia (edx) divided by long in %rax
M_rmi:
	orq	%rax,%rax		# test for 0
	jz	setovr   	 	# jump if 0 divisor
	xchg	%rax,%r12         	# ia to %rax, divisor to ia
	cqo                    		# extend dividend
	idiv	%r12              	# perform division. %rax=quotient, wc=remainder
	seto	reg_fl(%rip)
	movq	%rdx,%r12
	ret

setovr: movb     $1,%al		# set overflow indicator
	movb	%al,reg_fl(%rip)
	ret


#       ovr_ test for overflow value in ra
	.global	ovr_
ovr_:
	lea	reg_ra(%rip),%rax
	add	$6,%rax
	movw	(%rax),%ax		# get top 2 bytes
	andw	0x7ff0,%ax             	# check for infinity or nan
	addw	0x10,%ax               	# set/clear overflow accordingly
	ret

	.global	get_fp			# get frame pointer
get_fp:
	movq	reg_xs(%rip),%rax     		# minimal's %rsp
	addq	$8,%rax           	# pop return from call to sysbx or sysxi
	ret                    		# done


#	scstr_off is offset to start of string in scblk, or two words
#	%define scstr_off	cfp_c+cfp_c
	.set	scstr_off,16

	.global	mxint

#	%ifdef zz_trace
#	%endif
	.global	start

	.data
trc_fl:	.quad	0			# used to save flags for trc calls
	.text
trc_:
	syscallf	trc_i
	ret


#   table to recover type word from type ordinal


	.global	typet
	.data

	.quad	b_art	# arblk type word - 0
	.quad	b_cdc	# cdblk type word - 1
	.quad	b_exl	# exblk type word - 2
	.quad	b_icl	# icblk type word - 3
	.quad	b_nml	# nmblk type word - 4
	.quad	p_aba	# p0blk type word - 5
	.quad	p_alt	# p1blk type word - 6
	.quad	p_any	# p2blk type word - 7
# next needed only if support real arithmetic cnra
#       .quad	b_rcl   # rcblk type word - 8
	.quad	b_scl	# scblk type word - 9
	.quad	b_sel	# seblk type word - 10
	.quad	b_tbt	# tbblk type word - 11
	.quad	b_vct	# vcblk type word - 12
	.quad	b_xnt	# xnblk type word - 13
	.quad	b_xrt	# xrblk type word - 14
	.quad	b_bct	# bcblk type word - 15
	.quad	b_pdt	# pdblk type word - 16
	.quad	b_trt	# trblk type word - 17
	.quad	b_bft	# bfblk type word   18
	.quad	b_cct	# ccblk type word - 19
	.quad	b_cmt	# cmblk type word - 20
	.quad	b_ctt	# ctblk type word - 21
	.quad	b_dfc	# dfblk type word - 22
	.quad	b_efc	# efblk type word - 23
	.quad	b_evt	# evblk type word - 24
	.quad	b_ffc	# ffblk type word - 25
	.quad	b_kvt	# kvblk type word - 26
	.quad	b_pfc	# pfblk type word - 27
	.quad	b_tet	# teblk type word - 28
#
#   table of minimal entry points that can be dded from c
#   via the minimal function (see inter.asm).
#
#   note that the order of entries in this table must correspond
#   to the order of entries in the call enumeration in osint.h
#   and osint.inc.
#
	.global calltab
calltab:
	.quad	relaj
	.quad	relcr
	.quad	reloc
	.quad	alloc
	.quad	alocs
	.quad	alost
	.quad	blkln
	.quad	insta
	.quad	rstrt
	.quad	start
	.quad	filnm
	.quad	dtype
#       .quad	enevs #  engine words
#       .quad	engts #   not used

	.global	b_efc
	.global	b_icl
	.global	b_rcl
	.global	b_scl
	.global	b_vct
	.global	b_xnt
	.global	b_xrt
	.global	c_aaa
	.global	c_yyy
	.global	dnamb
	.global	cswfl
	.global	dnamp
	.global	flprt
	.global	flptr
	.global	g_aaa
	.global	gbcnt
	.global	gtcef
	.global	headv
	.global	hshtb
	.global	kvstn
	.global	kvdmp
	.global	kvftr
	.global	kvcom
	.global	kvpfl
	.global	mxlen
	.global	polct
	.global	s_yyy
	.global	s_aaa
	.global	stage
	.global	state
	.global	stbas
	.global	statb
	.global	stmcs
	.global	stmct
	.global	timsx
	.global	typet
	.global	pmhbs
	.global	r_cod
	.global	r_fcb
	.global	w_aaa
	.global	w_yyy
	.global	end_min_data



