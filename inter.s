# copyright 1987-2012 robert b. k. dewar and mark emmer.
# 
# this file is part of macro spitbol.
# 
#     macro spitbol is free software: you can redistribute it and/or modify
#     it under the terms of the gnu general public license as published by
#     the free software foundation, either version 3 of the license, or
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
globals =               1                       #asm globals defined here
        .include        "systype.ah"
        .include        "osint.inc"

        header_
#
#       file: inter.s           version: 1.46
#       ---------------------------------------
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
#       o c callable function startup
#       o c callable function get_fp
#       o c callable function restart
#       o c callable function makeexec
#       o routines for minimal opcodes chk and cvd
#       o math functions for integer multiply, divide, and remainder
#       o math functions for real operation
#
#-----------
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
#               .long   exit_1          # address of exit point 1
#               .long   exit_2          # address of exit point 2
#               ...     ...             # ...
#               .long   exit_n          # address of exit point n
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
#       acknowledgement:
#
#------------
#
#       global variables
#
        cseg_
	ext	swcoup,near
        csegend_

        dseg_
	cext	stacksiz,dword
	cext	lmodstk,dword
	ext	lowsp,dword
	cext	outptr,dword
	ext	calltab,dword
.ifeq direct
        ext     valtab,dword
.endif

        .include "extrn386.inc"


# words saved during exit(-3)
#
        .balign 4
        pubdef  reg_block
        pubdef  reg_wa,.long,0     # register wa (ecx)
        pubdef  reg_wb,.long,0     # register wb (ebx)
        pubdef  reg_ia
        pubdef  reg_wc,.long,0     # register wc & ia (edx)
        pubdef  reg_xr,.long,0     # register xr (edi)
        pubdef  reg_xl,.long,0     # register xl (esi)
        pubdef  reg_cp,.long,0     # register cp
        pubdef  reg_ra,.double,0e  # register ra
#
# these locations save information needed to return after calling osint
# and after a restart from exit()
#
        pubdef  reg_pc,.long,0  # return pc from ccaller
reg_pp: .long   0               # number of bytes of ppms
        pubdef  reg_xs,.long,0  # minimal stack pointer
#
r_size  =       .-reg_block
        pubdef  reg_size,.long,r_size
#
# end of words saved during exit(-3)
#

#
#  constants
#
ten:    .long   10              # constant 10
        pubdef  inf,.long,0
        .long   0x7ff00000      # double precision infinity

sav_block: .fill r_size,1,0     # save minimal registers during push/pop reg
#
        .balign 4
ppoff:  .long   0               # offset for ppm exits
compsp: .long   0               # 1.39 compiler's stack pointer
sav_compsp:
        .long   0               # save compsp here
osisp:  .long   0               # 1.39 osint's stack pointer


#
#       setup a number of internal addresses in the compiler that cannot
#       be directly accessed from within c because of naming difficulties.
#
        pubdef  id1,.long,0
.if setreal == 1
        .long    2
        .ascii  "1x\x00\x00"
.else
        .long    1
        .ascii  "1x\x00\x00\x00"
.endif
#
        pubdef  id2blk,.long,52
        .long   0
        .fill   52,1,0

        pubdef  ticblk,.long,0
        .long   0

        pubdef  tscblk,.long,512
        .long   0
        .fill   512,1,0

#
#       standard input buffer block.
#
        pubdef  inpbuf,.long,0     # type word
        .long   0               # block length
        .long   1024            # buffer size
        .long   0               # remaining chars to read
        .long   0               # offset to next character to read
        .long   0               # file position of buffer
        .long   0               # physical position in file
.if winnt && _masm_ <> 0
        .long   0               # 64-bit offset
        .long   0               # and current position
.endif
        .fill   1024,1,0        # buffer
#
        pubdef  ttybuf,.long,0     # type word
        .long   0               # block length
        .long   260             # buffer size  (260 ok in ms-dos with cinread())
        .long   0               # remaining chars to read
        .long   0               # offset to next char to read
        .long   0               # file position of buffer
        .long   0               # physical position in file
.if winnt && _masm_ <> 0
        .long   0               # 64-bit offset
        .long   0               # and current position
.endif
        .fill   260,1,0         # buffer

  dsegend_

  cseg_
#
#-----------
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
#       saving xl.  this only happens in call of nextef from sysxi when
#       reloading a save file.
#
#
        proc    pushregs,near                   #bashes eax,ecx,esi
	publab	pushregs
	pushad
	lea	esi,reg_block
	lea	edi,sav_block
	mov	ecx,r_size/4
	cld
   rep	movsd

        mov     edi,compsp
        or      edi,edi                         # 1.39 is there a compiler stack
        je      short push1                     # 1.39 jump if none yet
        sub     edi,4                           #push onto compiler's stack
        mov     esi,reg_xl                      #collectable xl
	mov	[edi],esi
        mov     compsp,edi                      #smashed if call osint again (sysgc)
        mov     sav_compsp,edi                  #used by popregs

push1:	popad
	retc	0
        endp    pushregs

        proc    popregs,near                    #bashes eax,ebx,ecx
	publab	popregs
	pushad
        mov     eax,reg_cp                      #don't restore cp
	cld
	lea	esi,sav_block
        lea     edi,reg_block                   #unload saved registers
	mov	ecx,r_size/4
   rep  movsd                                   #restore from temp area
	mov	reg_cp,eax

        mov     edi,sav_compsp                  #saved compiler's stack
        or      edi,edi                         #1.39 is there one?
        je      short pop1                      #1.39 jump if none yet
        mov     esi,[edi]                       #retrieve collectable xl
        mov     reg_xl,esi                      #update xl
        add     edi,4                           #update compiler's sp
        mov     compsp,edi

pop1:	popad
	retc	0
        endp    popregs

#
#-----------
#
#       interface routines
#
#       each interface routine takes the following form:
#
#               sysxx   call    ccaller         # call common interface
#                       dd      zysxx           # address of c osint function
#                       db      n               # offset to instruction after
#                                               #   last procedure exit
#
#       in an effort to achieve portability of c osint functions, we
#       do not take take advantage of any "internal" to "external"
#       transformation of names by c compilers.  so, a c osint function
#       representing sysxx is named _zysxx.  this renaming should satisfy
#       all c compilers.
#
#       important  one interface routine, sysfc, is passed arguments on
#       the stack.  these items are removed from the stack before calling
#       ccaller, as they are not needed by this implementation.
#
#
#-----------
#
#       ccaller is called by the os interface routines to call the
#       real c os interface function.
#
#       general calling sequence is
#
#               call    ccaller
#               dd      address_of_c_function
#               db      2*number_of_exit_points
#
#       control is never returned to a interface routine.  instead, control
#       is returned to the compiler (the caller of the interface routine).
#
#       the c function that is called must always return an integer
#       indicating the procedure exit to take or that a normal return
#       is to be performed.
#
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
#
        proc   ccaller,near

#       (1) save registers in global variables
#
        mov     reg_wa,ecx              # save registers
	mov	reg_wb,ebx
        mov     reg_wc,edx              # (also _reg_ia)
	mov	reg_xr,edi
	mov	reg_xl,esi
        mov     reg_cp,ebp              # needed in image saved by sysxi

#       (2) get pointer to arg list
#
        pop     esi                     # point to arg list
#
#       (3) fetch address of c function, fetch offset to 1st instruction
#           past last procedure exit, and call c function.
#
        cs                              # cs segment override
        lodsd                           # point to c function entry point
#       lodsd   cs:ccaller              # point to c function entry point
        movzx   ebx,byte ptr [esi]   # save normal exit adjustment
#
        mov     reg_pp,ebx              # in memory
        pop     reg_pc                  # save return pc past "call sysxx"
#
#       (3a) save compiler stack and switch to osint stack
#
        mov     compsp,esp              # 1.39 save compiler's stack pointer
        mov     esp,osisp               # 1.39 load osint's stack pointer
#
#       (3b) make call to osint
#
        call    eax                     # call c interface function
#
#       (4) restore registers after c function returns.
#

cc1:    mov     osisp,esp               # 1.39 save osint's stack pointer
        mov     esp,compsp              # 1.39 restore compiler's stack pointer
        mov     ecx,reg_wa              # restore registers
	mov	ebx,reg_wb
        mov     edx,reg_wc              # (also reg_ia)
	mov	edi,reg_xr
	mov	esi,reg_xl
	mov	ebp,reg_cp

	cld
#
#       (5) based on returned value from c function (in eax) either do a normal
#           return or take a procedure exit.
#
        or      eax,eax         # test if normal return ...
        jns     short erexit    # j. if >= 0 (take numbered exit)
	mov	eax,reg_pc
        add     eax,reg_pp      # point to instruction following exits
        jmp     eax             # bypass ppm exits

#                               # else (take procedure exit n)
erexit: shr     eax,1           # divide by 2
        add     eax,reg_pc      #   get to address of exit offset
	movsx	eax,word ptr [eax]
        add     eax,ppoff       # bias to fit in 16-bit word
	push	eax
        xor     eax,eax         # in case branch to error cascade
        ret                     #   take procedure exit via ppm address

        endp    ccaller
#
#---------------
#
#       individual osint routine entry points
#
        publab sysax
	ext	zysax,near
sysax:	call	ccaller
        address   zysax
        .byte   0
#
        publab sysbs
	ext	zysbs,near
sysbs:	call	ccaller
        address   zysbs
        .byte   3*2
#
        publab sysbx
	ext	zysbx,near
sysbx:	mov	reg_xs,esp
	call	ccaller
        address zysbx
        .byte   0
#
.if setreal == 1
        publab syscr
	ext	zyscr,near
syscr:  call    ccaller
        address zyscr
        .byte   0
#
.endif
        publab sysdc
	ext	zysdc,near
sysdc:	call	ccaller
        address zysdc
        .byte   0
#
        publab sysdm
	ext	zysdm,near
sysdm:	call	ccaller
        address zysdm
        .byte   0
#
        publab sysdt
	ext	zysdt,near
sysdt:	call	ccaller
        address zysdt
        .byte   0
#
        publab sysea
	ext	zysea,near
sysea:	call	ccaller
        address zysea
        .byte   1*2
#
        publab sysef
	ext	zysef,near
sysef:	call	ccaller
        address zysef
        .byte   3*2
#
        publab sysej
	ext	zysej,near
sysej:	call	ccaller
        address zysej
        .byte   0
#
        publab sysem
	ext	zysem,near
sysem:	call	ccaller
        address zysem
        .byte   0
#
        publab sysen
	ext	zysen,near
sysen:	call	ccaller
        address zysen
        .byte   3*2
#
        publab sysep
	ext	zysep,near
sysep:	call	ccaller
        address zysep
        .byte   0
#
        publab sysex
	ext	zysex,near
sysex:	mov	reg_xs,esp
	call	ccaller
        address zysex
        .byte   3*2
#
        publab sysfc
	ext	zysfc,near
sysfc:  pop     eax             # <<<<remove stacked scblk>>>>
	lea	esp,[esp+edx*4]
	push	eax
	call	ccaller
        address zysfc
        .byte   2*2
#
        publab sysgc
	ext	zysgc,near
sysgc:	call	ccaller
        address zysgc
        .byte   0
#
        publab syshs
	ext	zyshs,near
syshs:	mov	reg_xs,esp
	call	ccaller
        address zyshs
        .byte   8*2
#
        publab sysid
	ext	zysid,near
sysid:	call	ccaller
        address zysid
        .byte   0
#
        publab sysif
	ext	zysif,near
sysif:	call	ccaller
        address zysif
        .byte   1*2
#
        publab sysil
	ext	zysil,near
sysil:  call    ccaller
        address zysil
        .byte   0
#
        publab sysin
	ext	zysin,near
sysin:	call	ccaller
        address zysin
        .byte   3*2
#
        publab sysio
	ext	zysio,near
sysio:	call	ccaller
        address zysio
        .byte   2*2
#
        publab sysld
	ext	zysld,near
sysld:  call    ccaller
        address zysld
        .byte   3*2
#
        publab sysmm
	ext	zysmm,near
sysmm:	call	ccaller
        address zysmm
        .byte   0
#
        publab sysmx
	ext	zysmx,near
sysmx:	call	ccaller
        address zysmx
        .byte   0
#
        publab sysou
	ext	zysou,near
sysou:	call	ccaller
        address zysou
        .byte   2*2
#
        publab syspi
	ext	zyspi,near
syspi:	call	ccaller
        address zyspi
        .byte   1*2
#
        publab syspl
	ext	zyspl,near
syspl:	call	ccaller
        address zyspl
        .byte   3*2
#
        publab syspp
	ext	zyspp,near
syspp:	call	ccaller
        address zyspp
        .byte   0
#
        publab syspr
	ext	zyspr,near
syspr:	call	ccaller
        address zyspr
        .byte   1*2
#
        publab sysrd
	ext	zysrd,near
sysrd:	call	ccaller
        address zysrd
        .byte   1*2
#
        publab sysri
	ext	zysri,near
sysri:	call	ccaller
        address zysri
        .byte   1*2
#
        publab sysrw
	ext	zysrw,near
sysrw:	call	ccaller
        address zysrw
        .byte   3*2
#
        publab sysst
	ext	zysst,near
sysst:	call	ccaller
        address zysst
        .byte   5*2
#
        publab systm
	ext	zystm,near
systm:	call	ccaller
systm_p: address zystm
        .byte   0
#
        publab systt
	ext	zystt,near
systt:	call	ccaller
        address zystt
        .byte   0
#
        publab sysul
	ext	zysul,near
sysul:	call	ccaller
        address zysul
        .byte   0
#
        publab sysxi
	ext	zysxi,near
sysxi:	mov	reg_xs,esp
	call	ccaller
sysxi_p: address zysxi
        .byte   2*2

#
#-----------
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

        cproc   startup,near
	pubname	startup

        pop     eax                     # discard return
        pop     eax                     # discard dummy1
        pop     eax                     # discard dummy2
	call	stackinit               # initialize minimal stack
        mov     eax,compsp              # get minimal's stack pointer
        set_wa  eax                     # startup stack pointer

	cld                             # default to up direction for string ops
        getoff  eax,dffnc               # get address of ppm offset
        mov     ppoff,eax               # save for use later
#
        mov     esp,osisp               # switch to new c stack
        minimal start                   # load regs, switch stack, start compiler

        cendp   startup



#
#-----------
#
#	stackinit  -- initialize lowspmin from sp.
#
#	input:  sp - current c stack
#		stacksiz - size of desired minimal stack in bytes
#
#	uses:	eax
#
#	output: register wa, sp, lowspmin, compsp, osisp set up per diagram:
#
#	(high)	+----------------+
#		|  old c stack   |
#	  	|----------------| <-- incoming sp, resultant wa (future xs)
#		|	     ^	 |
#		|	     |	 |
#		/ stacksiz bytes /
#		|	     |	 |
#		|            |	 |
#		|----------- | --| <-- resultant lowspmin
#		| 400 bytes  v   |
#	  	|----------------| <-- future c stack pointer, osisp
#		|  new c stack	 |
#	(low)	|                |
#
#
#

	proc	stackinit,near
	mov	eax,esp
        mov     compsp,eax              # save as minimal's stack pointer
	sub	eax,stacksiz            # end of minimal stack is where c stack will start
        mov     osisp,eax               # save new c stack pointer
	add	eax,4*100               # 100 words smaller for chk
        setminr  lowspmin,eax            # set lowspmin
	ret
	endp	stackinit

#
#-----------
#
#       mimimal -- call minimal function from c
#
#       usage:  extern void minimal(word callno)
#
#       where:
#         callno is an ordinal defined in osint.h, osint.inc, and calltab.
#
#       minimal registers wa, wb, wc, xr, and xl are loaded and
#       saved from/to the register block.
#
#       note that before restart is called, we do not yet have compiler
#       stack to switch to.  in that case, just make the call on the
#       the osint stack.
#

        cproc    minimal,near
	pubname	minimal

        pushad                          # save all registers for c
        mov     eax,[esp+32+4]          # get ordinal
        mov     ecx,reg_wa              # restore registers
	mov	ebx,reg_wb
        mov     edx,reg_wc              # (also _reg_ia)
	mov	edi,reg_xr
	mov	esi,reg_xl
	mov	ebp,reg_cp

        mov     osisp,esp               # 1.39 save osint stack pointer
        cmp     dword ptr compsp,0      # 1.39 is there a compiler stack?
        je      short min1              # 1.39 jump if none yet
        mov     esp,compsp              # 1.39 switch to compiler stack

min1:   callc   calltab[eax*4],0        # off to the minimal code

        mov     esp,osisp               # 1.39 switch to osint stack

        mov     reg_wa,ecx              # save registers
	mov	reg_wb,ebx
	mov	reg_wc,edx
	mov	reg_xr,edi
	mov	reg_xl,esi
	mov	reg_cp,ebp
	popad
	retc	4

        cendp    minimal


.ifeq direct
#
#-----------
#
#       minoff -- obtain address of minimal variable
#
#       usage:  extern word *minoff(word valno)
#
#       where:
#         valno is an ordinal defined in osint.h, osint.inc and valtab.
#

        proc    minoff,near
	pubname	minoff

        mov     eax,[esp+4]             # get ordinal
        mov     eax,valtab[eax*4]       # get address of minimal value
	retc	4

        endp    minoff
.endif


#
#-----------
#
#       get_fp  - get c caller's fp (frame pointer)
#
#       get_fp() returns the frame pointer for the c function that called
#       this function.  however, this function is only called by zysxi.
#
#       c function zysxi calls this function to determine the lowest useful
#       word on the stack, so that only the useful part of the stack will be
#       saved in the load module.
#
#       the flow goes like this:
#
#       (1) user's spitbol program calls exit function
#
#       (2) spitbol compiler calls interface routine sysxi to handle exit
#
#       (3) interface routine sysxi passes control to ccaller which then
#           calls c function zysxi
#
#       (4) c function zysxi will write a load module, but needs to save
#           a copy of the current stack in the load module.  the base of
#           the part of the stack to be saved begins with the frame of our
#           caller, so that the load module can execute a return to ccaller.
#
#           this will allow the load module to pretend to be returning from
#           c function zysxi.  so, c function zysxi calls this function,
#           get_fp, to determine the base of the useful part of the stack.
#
#           we cheat just a little bit here.  c function zysxi can (and does)
#           have local variables, but we won't save them in the load module.
#           only the portion of the frame established by the 80386 call
#           instruction, from bp up, is saved.  these local variables
#           aren't needed, because the load module will not be going back
#           to c function zysxi.  instead when function restart returns, it
#           will act as if c function zysxi is returning.
#
#       (5) after writing the load module, c function zysxi calls c function
#           zysej to terminate spitbol's execution.
#
#       (6) when the resulting load module is executed, c function main
#           calls function restart.  function restart restores the stack
#           and then does a return.  this return will act as if it is
#           c function zysxi doing the return and the user's program will
#           continue execution following its call to exit.
#
#       on entry to _get_fp, the stack looks like
#
#               /      ...      /
#       (high)  |               |
#               |---------------|
#       zysxi   |    old pc     |  --> return point in ccaller
#         +     |---------------|  useful part of stack
#       frame   |    old bp     |  <<<<-- bp of get_fp's caller
#               |---------------|     -
#               |     zysxi's   |     -
#               /     locals    /     - non-useful part of stack
#               |               |     ------
#       ======= |---------------|
#       sp-->   |    old pc     |  --> return pc in c function zysxi
#       (low)   +---------------+
#
#       on exit, return ebp in eax. this is the lower limit on the
#       size of the stack.


        cproc    get_fp,near
	pubname	get_fp

        mov     eax,reg_xs      # minimal's xs
        add     eax,4           # pop return from call to sysbx or sysxi
        retc    0               # done

        cendp    get_fp

#
#-----------
#
#       restart - restart for load module
#
#       restart( char *dummy, char *stackbase ) - startup compiler
#
#       the osint main function calls restart when resuming execution
#       of a program from a load module.  the osint main function has
#       reset global variables except for the stack and any associated
#       variables.
#
#       before restoring stack, set up values for proper checking of
#       stack overflow. (initial sp here will most likely differ
#       from initial sp when compile was done.)
#
#       it is also necessary to relocate any addresses in the the stack
#       that point within the stack itself.  an adjustment factor is
#       calculated as the difference between the stbas at exit() time,
#       and stbas at restart() time.  as the stack is transferred from
#       tscblk to the active stack, each word is inspected to see if it
#       points within the old stack boundaries.  if so, the adjustment
#       factor is subtracted from it.
#
#       we use minimal's insta routine to initialize static variables
#       not saved in the save file.  these values were not saved so as
#       to minimize the size of the save file.
#
	ext	rereloc,near

        cproc   restart,near
	pubname	restart

        pop     eax                     # discard return
        pop     eax                     # discard dummy
        pop     eax                     # get lowest legal stack value

        add     eax,stacksiz            # top of compiler's stack
        mov     esp,eax                 # switch to this stack
	call	stackinit               # initialize minimal stack

                                        # set up for stack relocation
        lea     eax,tscblk+scstr        # top of saved stack
        mov     ebx,lmodstk             # bottom of saved stack
        getmin  ecx,stbas               # ecx = stbas from exit() time
        sub     ebx,eax                 # ebx = size of saved stack
	mov	edx,ecx
        sub     edx,ebx                 # edx = stack bottom from exit() time
	mov	ebx,ecx
        sub     ebx,esp                 # ebx = old stbas - new stbas

        setminr  stbas,esp               # save initial sp
        getoff  eax,dffnc               # get address of ppm offset
        mov     ppoff,eax               # save for use later
#
#       restore stack from tscblk.
#
        mov     esi,lmodstk             # -> bottom word of stack in tscblk
        lea     edi,tscblk+scstr        # -> top word of stack
        cmp     esi,edi                 # any stack to transfer?
        je      short re3               #  skip if not
	sub	esi,4
	std
re1:    lodsd                           # get old stack word to eax
        cmp     eax,edx                 # below old stack bottom?
        jb      short re2               #   j. if eax < edx
        cmp     eax,ecx                 # above old stack top?
        ja      short re2               #   j. if eax > ecx
        sub     eax,ebx                 # within old stack, perform relocation
re2:    push    eax                     # transfer word of stack
        cmp     esi,edi                 # if not at end of relocation then
        jae     re1                     #    loop back

re3:	cld
        mov     compsp,esp              # 1.39 save compiler's stack pointer
        mov     esp,osisp               # 1.39 back to osint's stack pointer
        callc   rereloc,0               # v1.08 relocate compiler pointers into stack
        getmin  eax,statb               # v1.34 start of static region to xr
	set_xr  eax
        minimal insta                   # v1.34 initialize static region

#
#       now pretend that we're executing the following c statement from
#       function zysxi:
#
#               return  normal_return#
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
.if winnt
	ext	startbrk,near
.endif
        callc   startbrk,0              # start control-c logic

        getmin  eax,stage               # is this a -w call?
	cmp	eax,4
        je      short re4               # yes, do a complete fudge

#
#       jump back to cc1 with return value = normal_return
	mov	eax,-1
        jmp     cc1                     # jump back

#       here if -w produced load module.  simulate all the code that
#       would occur if we naively returned to sysbx.  clear the stack and
#       go for it.
#
re4:	getmin	eax,stbas
        mov     compsp,eax              # 1.39 empty the stack

#       code that would be executed if we had returned to makeexec:
#
        setmin  gbcnt,0                 # reset garbage collect count
        callc   zystm,0                 # fetch execution time to reg_ia
        mov     eax,reg_ia              # set time into compiler
	setminr	timsx,eax

#       code that would be executed if we returned to sysbx:
#
        push    outptr                  # swcoup(outptr)
	callc	swcoup,4

#       jump to minimal code to restart a save file.

        minimal rstrt                   # no return

        cendp    restart


#
#-----------
#
#       cvd_ - convert by division
#
#       input   ia (edx) = number <=0 to convert
#       output  ia / 10
#               wa (ecx) = remainder + '0'
#
        publab  cvd_
        proc    cvd_,near

        xchg    eax,edx         # ia to eax
        cdq                     # sign extend
        idiv    dword ptr ten   # divide by 10. edx = remainder (negative)
        neg     edx             # make remainder positive
        add     dl,0x30         # convert remainder to ascii ('0')
        mov     ecx,edx         # return remainder in wa
        xchg    edx,eax         # return quotient in ia
	ret

        endp    cvd_
#
#-----------
#
#       dvi_ - divide ia (edx) by long in eax
#
        publab  dvi_
        proc    dvi_,near

        or      eax,eax         # test for 0
        jz      short setovr    # jump if 0 divisor
        push    ebp             # preserve cp
        xchg    ebp,eax         # divisor to ebp
        xchg    eax,edx         # dividend in eax
        cdq                     # extend dividend
        idiv    ebp             # perform division. eax=quotient, edx=remainder
        xchg    edx,eax         # place quotient in edx (ia)
        pop     ebp             # restore cp
        xor     eax,eax         # clear overflow indicator
	ret

        endp    dvi_

#
#-----------
#
#       rmi_ - remainder of ia (edx) divided by long in eax
#
        publab  rmi_
        proc    rmi_,near
             or      eax,eax         # test for 0
        jz      short setovr    # jump if 0 divisor
        push    ebp             # preserve cp
        xchg    ebp,eax         # divisor to ebp
        xchg    eax,edx         # dividend in eax
        cdq                     # extend dividend
        idiv    ebp             # perform division. eax=quotient, edx=remainder
        pop     ebp             # restore cp
        xor     eax,eax         # clear overflow indicator
        ret                     # return remainder in edx (ia)
setovr: mov     al,0x80         # set overflow indicator
	dec	al
	ret

        endp    rmi_


#----------
#
#    calls to c
#
#       the calling convention of the various compilers:
#
#       integer results returned in eax.
#       float results returned in st0 for intel.
#       see conditional switches fretst0 and
#       freteax in systype.ah for each compiler.
#
#       c function preserves ebp, ebx, esi, edi.
#


#----------
#
#       rti_ - convert real in ra to integer in ia
#               returns c=0 if fit ok, c=1 if too large to convert
#
        publab  rti_
        proc    rti_,near

# 41e00000 00000000 = 2147483648.0
# 41e00000 00200000 = 2147483649.0
        mov     eax, dword ptr reg_ra+4   # ra msh
        btr     eax,31          # take absolute value, sign bit to carry flag
        jc      short rti_2     # jump if negative real
        cmp     eax,0x41e00000  # test against 2147483648
        jae     short rti_1     # jump if >= +2147483648
rti_3:  push    ecx             # protect against c routine usage.
        push    eax             # push ra msh
        push    dword ptr reg_ra# push ra lsh
        callfar f_2_i,8         # float to integer
        xchg    eax,edx         # return integer in edx (ia)
        pop     ecx             # restore ecx
        clc
	ret

# here to test negative number, made positive by the btr instruction
rti_2:  cmp     eax,0x41e00000          # test against 2147483649
        jb      short rti_0             # definately smaller
        ja      short rti_1             # definately larger
        cmp     word ptr reg_ra+2, 0x0020
        jae     short rti_1
rti_0:  btc     eax,31                  # make negative again
        jmp     rti_3
rti_1:  stc                             # return c=1 for too large to convert
        ret

        endp    cvd_
#
#----------
#
#       itr_ - convert integer in ia to real in ra
#
        publab  itr_
        proc    itr_,near

        push    ecx             # preserve
        push    edx             # push ia
        callfar i_2_f,4         # integer to float
.if fretst0
	fstp	qword ptr reg_ra
        pop     ecx             # restore ecx
	fwait
.endif
.if freteax
        mov     dword ptr reg_ra,eax    # return result in ra
	mov	dword ptr reg_ra+4,edx
        pop     ecx             # restore ecx
.endif
	ret

        endp    itr_
#
#----------
#
#       ldr_ - load real pointed to by eax to ra
#
        publab  ldr_
        proc    ldr_,near

        push    dword ptr [eax]                 # lsh
	pop	dword ptr reg_ra
        mov     eax,[eax+4]                     # msh
	mov	dword ptr reg_ra+4, eax
	ret

        endp    ldr_
#
#----------
#
#       str_ - store ra in real pointed to by eax
#
        publab  str_
        proc    str_,near

        push    dword ptr reg_ra                # lsh
	pop	dword ptr [eax]
        push    dword ptr reg_ra+4              # msh
	pop	dword ptr [eax+4]
	ret

        endp    str_
#
#----------
#
#       adr_ - add real at [eax] to ra
#
        publab  adr_
        proc    adr_,near

        push    ecx                             # preserve regs for c
	push	edx
        push    dword ptr reg_ra+4              # ra msh
        push    dword ptr reg_ra                # ra lsh
        push    dword ptr [eax+4]               # arg msh
        push    dword ptr [eax]                 # arg lsh
        callfar f_add,16                        # perform op
.if fretst0
	fstp	qword ptr reg_ra
        pop     edx                             # restore regs
	pop	ecx
	fwait
.endif
.if freteax
        mov     dword ptr reg_ra+4, edx         # result msh
        mov     dword ptr reg_ra, eax           # result lsh
        pop     edx                             # restore regs
	pop	ecx
.endif
	ret

        endp    adr_
#
#----------
#
#       sbr_ - subtract real at [eax] from ra
#
        publab  sbr_
        proc    sbr_,near

        push    ecx                             # preserve regs for c
	push	edx
        push    dword ptr reg_ra+4              # ra msh
        push    dword ptr reg_ra                # ra lsh
        push    dword ptr [eax+4]               # arg msh
        push    dword ptr [eax]                 # arg lsh
        callfar f_sub,16                        # perform op
.if fretst0
	fstp	qword ptr reg_ra
        pop     edx                             # restore regs
	pop	ecx
	fwait
.endif
.if freteax
        mov     dword ptr reg_ra+4, edx         # result msh
        mov     dword ptr reg_ra, eax           # result lsh
        pop     edx                             # restore regs
	pop	ecx
.endif
	ret

        endp    sbr_
#
#----------
#
#       mlr_ - multiply real in ra by real at [eax]
#
        publab  mlr_
        proc    mlr_,near

        push    ecx                             # preserve regs for c
	push	edx
        push    dword ptr reg_ra+4              # ra msh
        push    dword ptr reg_ra                # ra lsh
        push    dword ptr [eax+4]               # arg msh
        push    dword ptr [eax]                 # arg lsh
        callfar f_mul,16                        # perform op
.if fretst0
	fstp	qword ptr reg_ra
        pop     edx                             # restore regs
	pop	ecx
	fwait
.endif
.if freteax
        mov     dword ptr reg_ra+4, edx         # result msh
        mov     dword ptr reg_ra, eax           # result lsh
        pop     edx                             # restore regs
	pop	ecx
.endif
	ret

        endp    mlr_
#
#----------
#
#       dvr_ - divide real in ra by real at [eax]
#
        publab  dvr_

        proc    dvr_,near

        push    ecx                             # preserve regs for c
	push	edx
        push    dword ptr reg_ra+4              # ra msh
        push    dword ptr reg_ra                # ra lsh
        push    dword ptr [eax+4]               # arg msh
        push    dword ptr [eax]                 # arg lsh
        callfar f_div,16                        # perform op
.if fretst0
        fstp	qword ptr reg_ra
        pop     edx                             # restore regs
	pop	ecx
	fwait
.endif
.if freteax
        mov     dword ptr reg_ra+4, edx         # result msh
        mov     dword ptr reg_ra, eax           # result lsh
        pop     edx                             # restore regs
	pop	ecx
.endif
	ret

        endp    dvr_
#
#----------
#
#       ngr_ - negate real in ra
#
        publab  ngr_

        proc    ngr_,near
	cmp	dword ptr reg_ra, 0
	jne	short ngr_1
	cmp	dword ptr reg_ra+4, 0
        je      short ngr_2                     # if zero, leave alone
ngr_1:  xor     byte ptr reg_ra+7, 0x80         # complement mantissa sign
ngr_2:	ret

        endp    ngr_
#
#----------
#
#       atn_ arctangent of real in ra
#
        publab  atn_

        proc    atn_,near

        push    ecx                             # preserve regs for c
	push	edx
        push    dword ptr reg_ra+4              # ra msh
        push    dword ptr reg_ra                # ra lsh
        callfar f_atn,8                         # perform op
.if fretst0
        fstp	qword ptr reg_ra
        pop     edx                             # restore regs
	pop	ecx
	fwait
.endif
.if freteax
        mov     dword ptr reg_ra+4, edx         # result msh
        mov     dword ptr reg_ra, eax           # result lsh
        pop     edx                             # restore regs
	pop	ecx
.endif
	ret

        endp    atn_
#
#----------
#
#       chp_ chop fractional part of real in ra
#
        publab  chp_

        proc    chp_,near

        push    ecx                             # preserve regs for c
	push	edx
        push    dword ptr reg_ra+4              # ra msh
        push    dword ptr reg_ra                # ra lsh
        callfar f_chp,8                         # perform op
.if fretst0
        fstp	qword ptr reg_ra
        pop     edx                             # restore regs
	pop	ecx
	fwait
.endif
.if freteax
        mov     dword ptr reg_ra+4, edx         # result msh
        mov     dword ptr reg_ra, eax           # result lsh
        pop     edx                             # restore regs
	pop	ecx
.endif
	ret

        endp    chp_
#
#----------
#
#       cos_ cosine of real in ra
#
        publab  cos_

        proc    cos_,near

        push    ecx                             # preserve regs for c
	push	edx
        push    dword ptr reg_ra+4              # ra msh
        push    dword ptr reg_ra                # ra lsh
        callfar f_cos,8                         # perform op
.if fretst0
        fstp	qword ptr reg_ra
        pop     edx                             # restore regs
	pop	ecx
	fwait
.endif
.if freteax
        mov     dword ptr reg_ra+4, edx         # result msh
        mov     dword ptr reg_ra, eax           # result lsh
        pop     edx                             # restore regs
	pop	ecx
.endif
	ret

        endp    cos_
#
#----------
#
#       etx_ exponential of real in ra
#
        publab  etx_

        proc    etx_,near

        push    ecx                             # preserve regs for c
	push	edx
        push    dword ptr reg_ra+4              # ra msh
        push    dword ptr reg_ra                # ra lsh
        callfar f_etx,8                         # perform op
.if fretst0
        fstp	qword ptr reg_ra
        pop     edx                             # restore regs
	pop	ecx
	fwait
.endif
.if freteax
        mov     dword ptr reg_ra+4, edx         # result msh
        mov     dword ptr reg_ra, eax           # result lsh
        pop     edx                             # restore regs
	pop	ecx
.endif
	ret

        endp    etx_
#
#----------
#
#       lnf_ natural logarithm of real in ra
#
        publab  lnf_

        proc    lnf_,near

        push    ecx                             # preserve regs for c
	push	edx
        push    dword ptr reg_ra+4              # ra msh
        push    dword ptr reg_ra                # ra lsh
        callfar f_lnf,8                         # perform op
.if fretst0
        fstp	qword ptr reg_ra
        pop     edx                             # restore regs
	pop	ecx
	fwait
.endif
.if freteax
        mov     dword ptr reg_ra+4, edx         # result msh
        mov     dword ptr reg_ra, eax           # result lsh
        pop     edx                             # restore regs
	pop	ecx
.endif
	ret

        endp    lnf_
#
#----------
#
#       sin_ arctangent of real in ra
#
        publab  sin_

        proc    sin_,near

        push    ecx                             # preserve regs for c
	push	edx
        push    dword ptr reg_ra+4              # ra msh
        push    dword ptr reg_ra                # ra lsh
        callfar f_sin,8                         # perform op
.if fretst0
        fstp	qword ptr reg_ra
        pop     edx                             # restore regs
	pop	ecx
	fwait
.endif
.if freteax
        mov     dword ptr reg_ra+4, edx         # result msh
        mov     dword ptr reg_ra, eax           # result lsh
        pop     edx                             # restore regs
	pop	ecx
.endif
	ret

        endp    sin_
#
#----------
#
#       sqr_ arctangent of real in ra
#
        publab  sqr_

        proc    sqr_,near

        push    ecx                             # preserve regs for c
	push	edx
        push    dword ptr reg_ra+4              # ra msh
        push    dword ptr reg_ra                # ra lsh
        callfar f_sqr,8                         # perform op
.if fretst0
        fstp	qword ptr reg_ra
        pop     edx                             # restore regs
	pop	ecx
	fwait
.endif
.if freteax
        mov     dword ptr reg_ra+4, edx         # result msh
        mov     dword ptr reg_ra, eax           # result lsh
        pop     edx                             # restore regs
	pop	ecx
.endif
	ret

        endp    sqr_
#
#----------
#
#       tan_ arctangent of real in ra
#
        publab  tan_

        proc    tan_,near

        push    ecx                             # preserve regs for c
	push	edx
        push    dword ptr reg_ra+4              # ra msh
        push    dword ptr reg_ra                # ra lsh
        callfar f_tan,8                         # perform op
.if fretst0
        fstp	qword ptr reg_ra
        pop     edx                             # restore regs
	pop	ecx
	fwait
.endif
.if freteax
        mov     dword ptr reg_ra+4, edx         # result msh
        mov     dword ptr reg_ra, eax           # result lsh
        pop     edx                             # restore regs
	pop	ecx
.endif
	ret

        endp    tan_
#
#----------
#
#       cpr_ compare real in ra to 0
#
        publab  cpr_

        proc    cpr_,near

        mov     eax, dword ptr reg_ra+4 # fetch msh
        cmp     eax, 0x80000000         # test msh for -0.0
        je      short cpr050            # possibly
        or      eax, eax                # test msh for +0.0
        jnz     short cpr100            # exit if non-zero for cc's set
cpr050: cmp     dword ptr reg_ra, 0     # true zero, or denormalized number?
        jz      short cpr100            # exit if true zero
	mov	al, 1
        cmp     al, 0                   # positive denormal, set cc
cpr100:	ret

        endp    cpr_
#
#----------
#
#       ovr_ test for overflow value in ra
#
        publab  ovr_

ovr_:   proc    near

        mov     ax, word ptr reg_ra+6   # get top 2 bytes
        and     ax, 0x7ff0              # check for infinity or nan
        add     ax, 0x10                # set/clear overflow accordingly
	ret

        endp    ovr_

.if winnt
#
#----------
#
#       cinread(fdn, buffer, size)      do buffered console input
#
#       input:  fdn     = file descriptor in case can't use dos function 0a
#               buffer  = buffer
#               size    = buffer size
#       output: eax    = number of bytes transferred if no error
#               = -1 if error
#
#       preserves ds, es, esi, edi, ebx
#
#       uses dos function 0a because that is the function intercepted by
#       various keyboard editing programs, such as dos edit.
#
#       if a program has redirected standard output, function 0a's echos
#       will go to the redirected file, instead of the screen.  to overcome
#       this, we save standard out's handle, and force it to be the console
#       (stderr).  similarly, function 0ah reads from handle 0, and we
#       force it to the console to preclude reading from a file.
#
#       if insufficient handles remain in the system to do this little
#       shuffle, we simple fall back to the normal dos read routine.
#

        struc   cinarg
cin_ebp: .long  0
cin_ip:  .long  0
cin_fdn: .long  0
cin_buf: .long  0
cin_siz: .long  0
        ends    cinarg

        struc   ct                      #cinread temps
crbuf:  .fill   260,1,0                 #keyboard buffer
        ends    ct
zct     =       260/4                   #word aligned temp size
ctemp   =       [ebp-zct]               #temp on stack

	ext	read,near
.if winnt
        proc    cinreaddos,near
	pubname  cinreaddos
.else
        proc    cinread,near
	pubname	cinread
.endif
        enter   zct,0                   #enter and reserve space for ctemp
	push	ebx
	push	esi
	push	edi

        xor     ebx,ebx                 # save stdin by duplicating to
        mov     ecx,ebx                 #  get another handle
	xor	eax,eax
        mov     ah,0x45                 # cx = stdin
        int     0x21
        jc      cinr5                   # out of handles
        push    eax                     # save handle to old stdin
        mov     ebx,2                   # make stdin refer to stderr
        mov     ah,0x46                 # so dos's input comes from keyboard
        int     0x21

        mov     ebx,1                   # save stdout by duplicating to
        mov     ecx,ebx                 #  get another handle
        mov     ah,0x45                 # cx = stdout
        int     0x21
        jc      short cinr4             # out of handles
	push	ecx
        push    eax                     # save handle to old stdout
        mov     ebx,2                   # make stdout refer to stderr
        mov     ah,0x46                 # so dos' echo goes to screen
        int     0x21

	mov	ecx,[ebp].cin_siz
        inc     ecx                     # allow for cr
	cmp	ecx,255
	jle	short cinr1
        mov     cl,255                  # 255 is the max size for function 0ah
cinr1:  lea     edx,ctemp.crbuf         # buffer (ds=ss)
        mov     [edx],cl                # set up count

        mov     ah,0x0a
        int     0x21                    # do buffered input into [edx+2]

	pop	ebx
        pop     ecx                     # (cx = stdout)
        mov     ah,0x46                 # restore stdout to original file
        int     0x21
        mov     ah,0x3e                 # discard dup'ed handle
        int     0x21

        xor     ecx,ecx                 # cx = stdin
	pop	ebx
        mov     ah,0x46                 # restore stdin to original file
        int     0x21
        mov     ah,0x3e                 # discard dup'ed handle
        int     0x21

	mov	esi,edx
        inc     esi                     # point to number of bytes read
        movzx   ebx,byte ptr [esi]      # char count
        inc     ebx                     # include cr
        inc     esi                     # point to first char
        lea     edx,[esi+ebx]           # point past cr
        mov     [edx],byte ptr 10       # append lf after cr
        inc     ebx                     # include lf
        cmp     ebx,cin_siz[ebp]        # compare with caller's buffer size
	jle	short cinr3
        mov     ebx,cin_siz[ebp]        # caller's buffer size limits us
cinr3:	mov	ecx,ebx
        mov     edi,cin_buf[ebp]        # caller's buffer
  rep	movsb

        push    ebx                     # save count
        mov     ebx,2                   # force lf echo to screen
        mov     ah,0x40                 # edx points to lf
	mov	ecx,1
        int     0x21
	pop	eax

cinr2:	pop	edi
	pop	esi
	pop	ebx
	leave
	retc	12

# here if insufficient handles to save standard out.
# release standard in.
#
cinr4:  xor     ecx,ecx                 # cx = stdin
	pop	ebx
        mov     ah,0x46                 # restore stdin to original file
        int     0x21
        mov     ah,0x3e                 # discard dup'ed handle
        int     0x21

# here if insufficient handles to save standard in.
# just fall back to read routine.
#
cinr5:	push	cin_siz[ebp]
	push	cin_buf[ebp]
	push	cin_fdn[ebp]
	callc	read,12
	jmp	cinr2

.if winnt
        endp    cinreaddos
.else
        endp    cinread
.endif
.endif



.if winnt
#
#----------
#
#       chrdevdos(fdn)  do ioctl to see if character device.
#
#       input:  fdn     = file descriptor
#       output: eax     = 81h/82h if input/output char dev, else 0
#
#       preserves ds, es, esi, edi, ebx
#

                struc   chrdevarg
chrdev_ebp:     .long   0
chrdev_ip:      .long   0
chrdev_fdn:     .long   0
                ends    chrdevarg

        proc    chrdevdos,near
	pubname  chrdevdos
	enter	0,0
	push	ebx

        mov     ebx,chrdev_fdn[ebp]     # caller's fdn
        mov     ax,0x4400               # ioctl get status
        int     0x21
	pop	ebx
	jc	short chrdev1
	xor	eax,eax
	mov	al,dl
	leave
	retc	4
chrdev1: xor	eax,eax
	leave
	retc	4
        endp    chrdevdos

#
#----------
#
#       rawmodedos(fdn,mode)    set console to raw/cooked mode
#
#       input:  fdn     = file descriptor
#               mode    = 0 = cooked, 1 = raw
#       output: none
#
#       preserves ds, es, esi, edi, ebx
#

                struc   rawmodearg
rawmode_ebp:    .long   0
rawmode_ip:     .long   0
rawmode_fdn:    .long   0
rawmode_mode:   .long   0
                ends    rawmodearg

        proc    rawmodedos,near
	pubname  rawmodedos
	enter	0,0
	push	ebx

	push	rawmode_fdn[ebp]
	callc	chrdevdos,4
	or	eax,eax
	jz	rawmode1
        and     eax,0x0df
	cmp	rawmode_mode[ebp],0
	je	rawmode0
        or      al,0x20                 # set raw bit
rawmode0:
	mov	edx,eax
        mov     ax,0x4401
        int     0x21
rawmode1: pop	ebx
	leave
	retc	4
        endp    rawmodedos
.endif

.if linux
#
#----------
#
#  tryfpu - perform a floating point op to trigger a trap if no floating point hardware.
#
  cproc   tryfpu,near
	pubname tryfpu
	push	ebp
	fldz
	pop	ebp
	ret
	cendp	tryfpu
.endif


  csegend_
        .end
