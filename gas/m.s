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


#	ws is bits per word, cfp_b is bytes per word, cfp_c is characters per word

	.intel_syntax

	#include	"m.h"

#ifdef	unix_32
	.set	cfp_b,4
	.set	cfp_c,4
#else
	.set	cfp_b,8
	.set	cfp_c,8
	.set	m64,1			# make m64 the default
#endif

	.global	reg_block
	.global	reg_w0
	.global	reg_wa
	.global	reg_wB
	.global	reg_ia
	.global	reg_wC
	.global	reg_xR
	.global	reg_xL
	.global	reg_cp
	.global	reg_ra
	.global	reg_pc
	.global	reg_xS
	.global	reg_size

	.global	reg_rp

	.global	minimal
	.extern	calltab
	.extern	stacksiz

#	values below must agree with calltab defined in x32.hdr and also in osint/osint.h

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

	.set	globals,1                       # asm globals defined here


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
#             .long    exit_1          # address of exit point 1
#             .long    exit_2          # address of exit point 2
#               ...     ...             # ...
#             .long    exit_n          # address of exit point n
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

#       some compilers transform "internal" global names to
#       "external" global names by adding a leading underscore at the front
#       of the internal name.  thus, the function name 'osopen' becomes
#       '_osopen'.  however, not all c compilers follow this convention.

#       global variables

	.data
#
# ; words saved during exit(-3)
# ;
	.align 8
dummy:	.long	0
reg_block:
reg_ia: .long	0		# register ia
reg_w0:	.long	0        	# register w0
reg_wa:	.long	0        	# register wa
reg_wb:	.long 	0        	# register wb
reg_wc:	.long	0		# register wc
reg_xr:	.long	0        	# register xr
reg_xl:	.long	0        	# register xl
reg_cp:	.long	0        	# register cp
reg_ra:	.double 	0.0  		# register ra

# these locations save information needed to return after calling osint
# and after a restart from exit()

reg_pc: .long      0               # return pc from caller
reg_xs:	.long	0		# minimal stack pointer

#	r_size  equ       $-reg_block
# use computed value for nasm conversion, put back proper code later
	.set r_size,10*cfp_b
reg_size:	.long   r_size

# end of words saved during exit(-3)

# reg_rp is used to pass pointer to real operand for real arithmetic
reg_rp:	.long	0

# reg_fl is used to communicate condition codes between minimal and c code.
	.global	reg_fl
reg_fl:	.byte	0		# condition code register for numeric operations

	.align	8
#  constants

	.global	ten
ten:    .long      10              # constant 10
	.global  inf
inf:	.long	0
	.long      0x7ff00000      # double precision infinity

	.global	sav_block
#sav_block: times r_size db 0     	# save minimal registers during push/pop reg
sav_block: .fill 44     		# save minimal registers during push/pop reg
	.fill	64			# slack to avoid running into ppoff below

	.align cfp_b
	.global	ppoff
ppoff:  .long  	0               	# offset for ppm exits
	.global	compsp
compsp: .long  	0               	# compiler's stack pointer
	.global	sav_compsp
sav_compsp:
	.long  	0               	# save compsp here
	.global	osisp
osisp:  .long  	0               	# osint's stack pointer
	.global	_rc_
_rc_:	.long  	0				# return code from osint procedure

	.align	cfp_b
	.global	save_cp
	.global	save_xl
	.global	save_xr
	.global	save_xs
	.global	save_wa
	.global	save_wb
	.global	save_wc
	.global	save_w0
save_cp:	.long	0		# saved cp value
save_ia:	.long	0		# saved ia value
save_xl:	.long	0		# saved XL value
save_xr:	.long	0		# saved XR value
save_xs:	.long	0		# saved sp value
save_wa:	.long	0		# saved wa value
save_wb:	.long	0		# saved WB value
save_wc:	.long	0		# saved WC value
save_w0:	.long	0		# saved W0 value

	.global	minimal_id
minimal_id:	.long	0		# id for call to minimal from c. see proc minimal below.

#
	.set setreal,0

#       setup a number of internal addresses in the compiler that cannot
#       be directly accessed from within c because of naming difficulties.

	.global  id1
id1:	.long   0
#if setreal == 1
	.long       2

       .long       1
	.byte  "1x\x00\x00\x00"
#endif

	.global  id1blk
id1blk:	.long   152
      	.long    0
	.fill	152

	.global  id2blk
id2blk:	.long   152
      	.long    0
	.file   152

	.global  ticblk
ticblk:	.long   0
      .long    0

	.global  tscblk
tscblk:	 .long   512
      .long    0
	.fill	512

#       standard input buffer block.

	.global  inpbuf

inpbuf:	.long	0			# type word
	.long	0               	# block length
	.long	1024            	# buffer size
	.long	0               	# remaining chars to read
	.long	0               	# offset to next character to read
	.long	0               	# file position of buffer
	.long	0               	# physical position in file
	.fill	1024         	# buffer

	.global  ttybuf

ttybuf:	.long    0     # type word
	.long	0               	# block length
	.long	260             	# buffer size  (260 ok in ms-dos with cinread())
	.long	0               	# remaining chars to read
	.long	0               	# offset to next char to read
	.long	0               	# file position of buffer
	.long	0               	# physical position in file
	.fill	260	         	# buffer

	.global	spmin

spmin:	.long	0			# stack limit (stack grows down for x86_64)
spmin.a:	.long	spmin

	.align	16
	.align         cfp_b

	.global	cprtmsg
cprtmsg:
	.byte          ' copyright 1987-2012 robert b. k. dewar and mark emmer.',0,0

call_adr:	.long	0


	.text
#
#       save and restore minimal and interface registers on stack.
#       used by any routine that needs to call back into the minimal
#       code in such a way that the minimal code might trigger another
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
#       been modified by the minimal routine called between pushregs
#       and popregs as a result of a garbage collection.  calling of
#       another sysxx routine in between is not a problem, because
#       cp will have been preserved by minimal.
#
#       note 4:  if there isn't a compiler stack yet, we don't bother
#       saving XL.  this only happens in call of nextef from sysxi when
#       reloading a save file.
#
#
	.global	save_regs
save_regs:
	mov	save_ia,IA
	mov	save_XL,XL
	mov	save_XR,XR
	mov	save_XS,XS
	mov	save_wa,WA
	mov	save_WB,WB
	mov	save_WC,WC
	mov	save_W0,W0
	ret

	.global	restore_regs
restore_regs:
	#	restore regs, except for sp. that is caller's responsibility
	mov	IA,m(save_ia)
	mov	XL,m(save_XL)
	mov	XR,m(save_XR)
#	mov	XS,m(save_XS)	# caller restores sp
	mov	WA,m(save_wa)
	mov	WB,m(save_WB)
	mov	WC,m(save_WC)
	mov	W0,m(save_W0)
	ret

# ;
# ;       startup( char *dummy1, char *dummy2) - startup compiler
# ;
# ;       an osint c function calls startup to transfer control
# ;       to the compiler.
# ;
# ;       (XR) = basemem
# ;       (XL) = topmem - sizeof(word)
# ;
# ;	note: this function never returns.
# ;
#
	.global	startup
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


startup:
	pop     W0			# discard return
	call	stackinit		# initialize minimal stack
	mov     W0,m(compsp)	# get minimal's stack pointer
	mov m(reg_wa),W0		# startup stack pointer

	cld				# default to up direction for string ops
#        getoff  W0,dffnc               # get address of ppm offset
	mov     m(ppoff),W0	# save for use later

	mov     XS,m(osisp)	# switch to new c stack
	mov	m(minimal_id),calltab_start
	call	minimal			# load regs, switch stack, start compiler

#	stackinit  -- initialize spmin from sp.

#	input:  sp - current c stack
#		stacksiz - size of desired minimal stack in bytes

#	uses:	W0

#	output: register wa, sp, spmin, compsp, osisp set up per diagram:

#	(high)	+----------------+
#		|  old c stack   |
#	  	|----------------| <-- incoming sp, resultant wa (future XS)
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
	.global	stackinit
stackinit:
	mov	W0,XS
	mov     m(compsp),W0	# save minimal's stack pointer
	sub	W0,m(stacksiz)	# end of minimal stack is where c stack will start
	mov     m(osisp),W0	# save new c stack pointer
	add	W0,cfp_b*100		# 100 words smaller for chk
	mov	m(spmin),W0
	ret

#	check for stack overflow, making W0 nonzero if found
	.global	chk__
chk__:
	xor	W0,W0			# set return value assuming no overflow
	cmp	XS,m(spmin)
	jb	chk.oflo
	ret
chk.oflo:
	inc	W0			# make nonzero to indicate stack overfloW0
	ret

#       mimimal -- call minimal function from c

#       usage:  extern void minimal(word callno)

#       where:
#         callno is an ordinal defined in osint.h, osint.inc, and calltab.

#       minimal registers wa, WB, WC, XR, and XL are loaded and
#       saved from/to the register block.

#       note that before restart is called, we do not yet have compiler
#       stack to switch to.  in that case, just make the call on the
#       the osint stack.

minimal:
#         pushad			# save all registers for c
	mov     WA,m(reg_wa)	# restore registers
	mov	WB,m(reg_wb)
	mov     WC,m(reg_wc)	#
	mov	XR,m(reg_xr)
	mov	XL,m(reg_xl)

	mov     m(osisp),xs	# save osint stack pointer
	cmp     m(compsp),0	# is there a compiler stack?
	je      min1			# jump if none yet
	mov     XS,m(compsp)	# switch to compiler stack

 min1:
	mov     W0,m(minimal_id)	# get ordinal
#	call   m(calltab+W0*cfp_b)    ; off to the minimal code
	.extern	start
	call	start

	mov     XS,m(osisp)	# switch to osint stack

	mov     m(reg_wa),WA	# save registers
	mov	m(reg_wb),WB
	mov	m(reg_wc),WC
	mov	m(reg_xr),XR
	mov	m(reg_xl),XL
	ret



#       interface routines

#       each interface routine takes the following form:

#               sysxx   call    ccaller ; call common interface
#                     .long    zysxx   ; .long      of c osint function
#                       db      n       ; offset to instruction after
#                                       ;   last procedure exit

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
#             .long    address_of_c_function
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


	.global	get_ia
get_ia:
	mov	W0,ia
	ret

	.global	set_ia_
set_ia_:	mov	ia,m_word[reg_w0]
	ret

syscall_init:
#       save registers in global variables

	mov     m(reg_wa),WA      # save registers
	mov	m(reg_wb),WB
	mov     m(reg_wc),WC      # (also _reg_ia) 
	mov	m(reg_xr),XR
	mov	m(reg_xl),XL
	mov	m(reg_ia),ia
	ret

syscall_exit:
	mov	m(_rc_),W0	# save return code from function
	mov     m(osisp),XS       # save osint's stack pointer
	mov     XS,m(compsp)      # restore compiler's stack pointer
	mov     WA,m(reg_wa)      # restore registers
	mov	WB,m(reg_wb)
	mov     WC,m(reg_wc)      #
	mov	XR,m(reg_xr)
	mov	IA,m(reg_ia)
	mov	XL,m(reg_xl)
	cld
	mov	W0,m(reg_pc)
	jmp	W0

	.macro	syscall	zproc,id
	pop     W0			# pop return address
	mov	m(reg_pc),W0
	call	syscall_init
#       save compiler stack and switch to osint stack
	mov     m(compsp),XS      # save compiler's stack pointer
	mov     XS,m(osisp)       # load osint's stack pointer
	call	\zproc
	call	syscall_exit
	.endm

	.global sysax
	.extern	zysax
sysax:	syscall	  zysax,1

	.global sysbs
	.extern	zysbs
sysbs:	syscall	  zysbs,2

	.global sysbx
	.extern	zysbx
sysbx:	mov	m(reg_xs),XS
	syscall	zysbx,2

#        global syscr
#	.extern	zyscr
#syscr:  syscall    zyscr ;    ,0

	.global sysdc
	.extern	zysdc
sysdc:	syscall	zysdc,4

	.global sysdm
	.extern	zysdm
sysdm:	syscall	zysdm,5

	.global sysdt
	.extern	zysdt
sysdt:	syscall	zysdt,6

	.global sysea
	.extern	zysea
sysea:	syscall	zysea,7

	.global sysef
	.extern	zysef
sysef:	syscall	zysef,8

	.global sysej
	.extern	zysej
sysej:	syscall	zysej,9

	.global sysem
	.extern	zysem
sysem:	syscall	zysem,10

	.global sysen
	.extern	zysen
sysen:	syscall	zysen,11

	.global sysep
	.extern	zysep
sysep:	syscall	zysep,12

	.global sysex
	.extern	zysex
sysex:	mov	m(reg_xs),XS
	syscall	zysex,13

	.global sysfc
	.extern	zysfc
sysfc:  pop     W0             # <<<<remove stacked scblk>>>>
	lea	XS,[XS+WC*cfp_b]
	push	W0
	syscall	zysfc,14

	.global sysgc
	.extern	zysgc
sysgc:	syscall	zysgc,15

	.global syshs
	.extern	zyshs
syshs:	mov	m(reg_xs),XS
	syscall	zyshs,16

	.global sysid
	.extern	zysid
sysid:	syscall	zysid,17

	.global sysif
	.extern	zysif
sysif:	syscall	zysif,18

	.global sysil
	.extern	zysil
sysil:  syscall zysil,19

	.global sysin
	.extern	zysin
sysin:	syscall	zysin,20

	.global sysio
	.extern	zysio
sysio:	syscall	zysio,21

	.global sysld
	.extern	zysld
sysld:  syscall zysld,22

	.global sysmm
	.extern	zysmm
sysmm:	syscall	zysmm,23

	.global sysmx
	.extern	zysmx
sysmx:	syscall	zysmx,24

	.global sysou
	.extern	zysou
sysou:	syscall	zysou,25

	.global syspi
	.extern	zyspi
syspi:	syscall	zyspi,26

	.global syspl
	.extern	zyspl
syspl:	syscall	zyspl,27

	.global syspp
	.extern	zyspp
syspp:	syscall	zyspp,28

	.global syspr
	.extern	zyspr
syspr:	syscall	zyspr,29

	.global sysrd
	.extern	zysrd
sysrd:	syscall	zysrd,30

	.global sysri
	.extern	zysri
sysri:	syscall	zysri,32

	.global sysrw
	.extern	zysrw
sysrw:	syscall	zysrw,33

	.global sysst
	.extern	zysst
sysst:	syscall	zysst,34

	.global systm
	.extern	zystm
systm:	syscall	zystm,35

	.global systt
	.extern	zystt
systt:	syscall	zystt,36

	.global sysul
	.extern	zysul
sysul:	syscall	zysul,37

	.global sysxi
	.extern	zysxi
sysxi:	mov	m(reg_xs),XS
	syscall	zysxi,38

	.macro	callext	proc,disp
	.extern	\proc
	call	\proc
	add	XS,\disp		# pop arguments
	.endm

#	x64 hardware divide, expressed in form of minimal register mappings, requires dividend be
#	placed in W0, which is then sign extended into WC:W0. after the divide, W0 contains the
#	quotient, WC contains the remainder.
#
#       cvd__ - convert by division
#
#       input   ia = number <=0 to convert
#       output  ia / 10
#               wa ecx) = remainder + '0'
	.global	cvd__
cvd__:
	.extern	i_cvd
	mov	m(reg_ia),IA
	mov	m(reg_wa),WA
	call	i_cvd
	mov	IA,m(reg_ia)
	mov	WA,m(reg_wa)
	ret


#       dvi__ - divide ia (edx) by long in W0
	.global	dvi__
dvi__:
	.extern	i_dvi
	mov	m(reg_w0),W0
	call	i_dvi
	mov	IA,m(reg_ia)
	mov	al,byte [rel reg_fl]
	or	al,al
	ret

	.global	rmi__
#       rmi__ - remainder of ia (edx) divided by long in W0
rmi__:
	jmp	ocode
	.extern	i_rmi
	mov	m(reg_w0),W0
	call	i_rmi
	mov	ia,m(reg_ia)
	mov	al,byte [rel reg_fl]
	or	al,al
	ret

ocode:
        or      W0,W0         	# test for 0
        jz      setovr    	# jump if 0 divisor
        xchg    W0,ia         	# ia to W0, divisor to ia
        cdq                     # extend dividend
        idiv    ia              # perform division. W0=quotient, WC=remainder
	seto	byte [rel reg_fl]
	mov	ia,WC
	ret

setovr: mov     al,1		# set overflow indicator
	mov	byte [rel reg_fl],al
	ret

	.macro	real_op 2
	.global	nam,proc
	.extern	\proc
\nam:
	mov	m(reg_rp),W0
	call	\proc
	ret
	.endm

	real_op	ldr_,f_ldr
	real_op	str_,f_str
	real_op	adr_,f_adr
	real_op	sbr_,f_sbr
	real_op	mlr_,f_mlr
	real_op	dvr_,f_dvr
	real_op	ngr_,f_ngr
	real_op cpr_,f_cpr

	.macro	int_op var,proc
	.global	\var
	.extern	\proc
\var:
	mov	m(reg_ia),ia
	call	\proc
	ret
	.endm

	int_op itr_,f_itr
	int_op rti_,f_rti

	.macro	math_op var,proc
	.global	\var
	.extern	\proc
\var:
	call	\proc
	ret
	.endm

	math_op	atn_,f_atn
	math_op	chp_,f_chp
	math_op	cos_,f_cos
	math_op	etx_,f_etx
	math_op	lnf_,f_lnf
	math_op	sin_,f_sin
	math_op	sqr_,f_sqr
	math_op	tan_,f_tan

#       ovr_ test for overflow value in ra
	.global	ovr_
ovr_:
        mov     ax, word [ rel reg_ra+6]	# get top 2 bytes
        and     ax, 0x7ff0             	# check for infinity or nan
        add     ax, 0x10               	# set/clear overflow accordingly
	ret

	.global	get_fp			# get frame pointer

get_fp:
         mov     W0,m(reg_xs)     # minimal's XS
         add     W0,4           	# pop return from call to sysbx or sysxi
         ret                    	# done

	.extern	rereloc

	.global	restart
	.extern	stbas
	.extern	statb
	.extern	stage
	.extern	gbcnt
	.extern	lmodstk
	.extern	startbrk
	.extern	outptr
	.extern	sWCoup
#	scstr is offset to start of string in scblk, or two words
	.set	scstr,cfp_c+cfp_c

#
restart:
        pop     W0                      # discard return
        pop     W0                     	# discard dummy
        pop     W0                     	# get lowest legal stack value

        add     W0,m(stacksiz)  	# top of compiler's stack
        mov     XS,W0                 	# switch to this stack
	call	stackinit               # initialize minimal stack

                                        # set up for stack relocation
        lea     W0,[rel tscblk+scstr]       # top of saved stack
        mov     WB,m(lmodstk)    	# bottom of saved stack
        mov	WA,m(stbas)      # wa = stbas from exit() time
        sub     WB,W0                 	# WB = size of saved stack
	mov	WC,WA
        sub     WC,WB                 	# WC = stack bottom from exit() time
	mov	WB,WA
        sub     WB,XS                 	# WB =  stbas - new stbas

        mov	m(stbas),XS       # save initial sp
#        getoff  W0,dffnc               # get address of ppm offset
        mov     m(ppoff),W0       # save for use later
#
#       restore stack from tscblk.
#
        mov     XL,m(lmodstk)    	# -> bottom word of stack in tscblk
        lea     XR,[rel tscblk+scstr]      	# -> top word of stack
        cmp     XL,XR                 	# any stack to transfer?
        je      re3               	#  skip if not
	sub	XL,4
	std
re1:    lodsd                           # get old stack word to W0
        cmp     W0,WC                 	# below old stack bottom?
        jb      re2               	#   j. if W0 < WC
        cmp     W0,WA                 	# above old stack top?
        ja      re2               	#   j. if W0 > wa
        sub     W0,WB                 	# within old stack, perform relocation
re2:    push    W0                     	# transfer word of stack
        cmp     XL,XR                 	# if not at end of relocation then
        jae     re1                     #    loop back

re3:	cld
        mov     m(compsp),XS     	# save compiler's stack pointer
        mov     XS,m(osisp)      	# back to osint's stack pointer
        call   rereloc               	# relocate compiler pointers into stack
        mov	W0,m(statb)      	# start of static region to XR
	mov	m(reg_xr),W0
	mov	W0,minimal_insta
	call	minimal			# initialize static region

#
#       now pretend that we're executing the following c statement from
#       function zysxi:
#
#               return  normal_return;
#
#       if the load module was invoked by exit(), the return path is
#       as follows:  back to ccaller, back to s$ext following sysxi call,
#       back to user program following exit() call.
#
#       alternately, the user specified -w as a command line option, and
#       sysbx called makeexec, which in turn called sysxi.  the return path
#       should be:  back to ccaller, back to makeexec following sysxi call,
#       back to sysbx, back to minimal code.  if we allowed this to happen,
#       then it would require that stacked return address to sysbx still be
#       valid, which may not be true if some of the c programs have changed
#       size.  instead, we clear the stack and execute the restart code that
#       simulates resumption just past the sysbx call in the minimal code.
#       we distinguish this case by noting the variable stage is 4.
#
        call   startbrk			# start control-c logic

        mov	W0,m(stage)      	# is this a -w call?
	cmp	W0,4
        je            re4               # yes, do a complete fudge

#
#       jump back with return value = normal_return
	xor	W0,W0			# set to zero to indicate normal return
	call	syscall_exit
	ret

#       here if -w produced load module.  simulate all the code that
#       would occur if we naively returned to sysbx.  clear the stack and
#       go for it.
#
re4:	mov	W0,m(stbas)
        mov     m(compsp),W0     	# empty the stack

#       code that would be executed if we had returned to makeexec:
#
        mov	m(gbcnt),0       	# reset garbage collect count
        call    zystm                 	# fetch execution time to reg_ia
        mov     W0,m(reg_ia)     	# set time into compiler
	.extern	timsx
	mov	m(timsx),W0

#       code that would be executed if we returned to sysbx:
#
        push    m(outptr)        	# sWCoup(outptr)
	.extern 	sWCoup
	call	sWCoup
	add	XS,cfp_b

#       jump to minimal code to restart a save file.

	mov	W0,minimal_rstrt
	mov	m(minimal_id),W0
        call	minimal			# no return

#ifdef zz_trace
	.extern	zz_ra
	.global	zz_
	.extern	zz,zz_cp,zz_XL,zz_XR,zz_wa,zz_WB,zz_WC,zz_W0
zz_:
	pushf
	call	save_regs
	call	zz
	call	restore_regs
	popf
	ret
#endif
