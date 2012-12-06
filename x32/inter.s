# Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
# 
# This file is part of Macro SPITBOL.
# 
#     Macro SPITBOL is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
# 
#     Macro SPITBOL is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
# 
#     You should have received a copy of the GNU General Public License
#     along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
#
globals =               1                       #ASM globals defined here
        .include        "systype.ah"
        .include        "osint.inc"

        Header_
#
#       File: inter.s           Version: 1.46
#       ---------------------------------------
#
#       This file contains the assembly language routines that interface
#       the Macro SPITBOL compiler written in 80386 assembly language to its
#       operating system interface functions written in C.
#
#       Contents:
#
#       o Overview
#       o Global variables accessed by OSINT functions
#       o Interface routines between compiler and OSINT functions
#       o C callable function startup
#       o C callable function get_fp
#       o C callable function restart
#       o C callable function makeexec
#       o Routines for Minimal opcodes CHK and CVD
#       o Math functions for integer multiply, divide, and remainder
#       o Math functions for real operation
#
#-----------
#
#       Overview
#
#       The Macro SPITBOL compiler relies on a set of operating system
#       interface functions to provide all interaction with the host
#       operating system.  These functions are referred to as OSINT
#       functions.  A typical call to one of these OSINT functions takes
#       the following form in the 80386 version of the compiler:
#
#               ...code to put arguments in registers...
#               call    SYSXX           # call osint function
#               .long   EXIT_1          # address of exit point 1
#               .long   EXIT_2          # address of exit point 2
#               ...     ...             # ...
#               .long   EXIT_n          # address of exit point n
#               ...instruction following call...
#
#       The OSINT function 'SYSXX' can then return in one of n+1 ways:
#       to one of the n exit points or to the instruction following the
#       last exit.  This is not really very complicated - the call places
#       the return address on the stack, so all the interface function has
#       to do is add the appropriate offset to the return address and then
#       pick up the exit address and jump to it OR do a normal return via
#       an ret instruction.
#
#       Unfortunately, a C function cannot handle this scheme.  So, an
#       intermediary set of routines have been established to allow the
#       interfacing of C functions.  The mechanism is as follows:
#
#       (1) The compiler calls OSINT functions as described above.
#
#       (2) A set of assembly language interface routines is established,
#           one per OSINT function, named accordingly.  Each interface
#           routine ...
#
#           (a) saves all compiler registers in global variables
#               accessible by C functions
#           (b) calls the OSINT function written in C
#           (c) restores all compiler registers from the global variables
#           (d) inspects the OSINT function's return value to determine
#               which of the n+1 returns should be taken and does so
#
#       (3) A set of C language OSINT functions is established, one per
#           OSINT function, named differently than the interface routines.
#           Each OSINT function can access compiler registers via global
#           variables.  NO arguments are passed via the call.
#
#           When an OSINT function returns, it must return a value indicating
#           which of the n+1 exits should be taken.  These return values are
#           defined in header file 'inter.h'.
#
#       Note:  in the actual implementation below, the saving and restoring
#       of registers is actually done in one common routine accessed by all
#       interface routines.
#
#       Other notes:
#
#       Some C ompilers transform "internal" global names to
#       "external" global names by adding a leading underscore at the front
#       of the internal name.  Thus, the function name 'osopen' becomes
#       '_osopen'.  However, not all C compilers follow this convention.
#
#------------
#
#       Global Variables
#
        CSeg_
	ext	swcoup,near
        CSegEnd_

        DSeg_
	cext	stacksiz,dword
	cext	lmodstk,dword
	ext	lowsp,dword
	cext	outptr,dword
	ext	calltab,dword
.ifeq direct
        ext     valtab,dword
.endif

        .include "extrn386.inc"


# Words saved during exit(-3)
#
        .balign 4
        pubdef  reg_block
        pubdef  reg_wa,.long,0     # Register WA (ECX)
        pubdef  reg_wb,.long,0     # Register WB (EBX)
        pubdef  reg_ia
        pubdef  reg_wc,.long,0     # Register WC & IA (EDX)
        pubdef  reg_xr,.long,0     # Register XR (EDI)
        pubdef  reg_xl,.long,0     # Register XL (ESI)
        pubdef  reg_cp,.long,0     # Register CP
        pubdef  reg_ra,.double,0e  # Register RA
#
# These locations save information needed to return after calling OSINT
# and after a restart from EXIT()
#
        pubdef  reg_pc,.long,0  # Return PC from ccaller
reg_pp: .long   0               # Number of bytes of PPMs
        pubdef  reg_xs,.long,0  # Minimal stack pointer
#
r_size  =       .-reg_block
        pubdef  reg_size,.long,r_size
#
# end of words saved during exit(-3)
#

#
#  Constants
#
	.global	ten
ten:    .long   10              # constant 10
        pubdef  inf,.long,0
        .long   0x7ff00000      # double precision infinity

sav_block: .fill r_size,1,0     # Save Minimal registers during push/pop reg
#
        .balign 4
ppoff:  .long   0               # offset for ppm exits
compsp: .long   0               # 1.39 compiler's stack pointer
sav_compsp:
        .long   0               # save compsp here
osisp:  .long   0               # 1.39 OSINT's stack pointer
	pubdef	_rc_,.long,0	# return code from osint procedure

SETREAL=0
#
#       Setup a number of internal addresses in the compiler that cannot
#       be directly accessed from within C because of naming difficulties.
#
        pubdef  ID1,.long,0
.if SETREAL == 1
        .long    2
        .ascii  "1x\x00\x00"
.else
        .long    1
        .ascii  "1x\x00\x00\x00"
.endif
#
        pubdef  ID2BLK,.long,52
        .long   0
        .fill   52,1,0

        pubdef  TICBLK,.long,0
        .long   0

        pubdef  TSCBLK,.long,512
        .long   0
        .fill   512,1,0

#
#       Standard input buffer block.
#
        pubdef  INPBUF,.long,0     # type word
        .long   0               # block length
        .long   1024            # buffer size
        .long   0               # remaining chars to read
        .long   0               # offset to next character to read
        .long   0               # file position of buffer
        .long   0               # physical position in file
        .fill   1024,1,0        # buffer
#
        pubdef  TTYBUF,.long,0     # type word
        .long   0               # block length
        .long   260             # buffer size  (260 OK in MS-DOS with cinread())
        .long   0               # remaining chars to read
        .long   0               # offset to next char to read
        .long   0               # file position of buffer
        .long   0               # physical position in file
        .fill   260,1,0         # buffer

  DSegEnd_

  CSeg_
#
#-----------
#
#       Save and restore MINIMAL and interface registers on stack.
#       Used by any routine that needs to call back into the MINIMAL
#       code in such a way that the MINIMAL code might trigger another
#       SYSxx call before returning.
#
#       Note 1:  pushregs returns a collectable value in XL, safe
#       for subsequent call to memory allocation routine.
#
#       Note 2:  these are not recursive routines.  Only reg_xl is
#       saved on the stack, where it is accessible to the garbage
#       collector.  Other registers are just moved to a temp area.
#
#       Note 3:  popregs does not restore REG_CP, because it may have
#       been modified by the Minimal routine called between pushregs
#       and popregs as a result of a garbage collection.  Calling of
#       another SYSxx routine in between is not a problem, because
#       CP will have been preserved by Minimal.
#
#       Note 4:  if there isn't a compiler stack yet, we don't bother
#       saving XL.  This only happens in call of nextef from sysxi when
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
        mov     esi,reg_xl                      #collectable XL
	mov	[edi],esi
        mov     compsp,edi                      #smashed if call OSINT again (SYSGC)
        mov     sav_compsp,edi                  #used by popregs

push1:	popad
	retc	0
        endp    pushregs

        proc    popregs,near                    #bashes eax,ebx,ecx
	publab	popregs
	pushad
        mov     eax,reg_cp                      #don't restore CP
	cld
	lea	esi,sav_block
        lea     edi,reg_block                   #unload saved registers
	mov	ecx,r_size/4
   rep  movsd                                   #restore from temp area
	mov	reg_cp,eax

        mov     edi,sav_compsp                  #saved compiler's stack
        or      edi,edi                         #1.39 is there one?
        je      short pop1                      #1.39 jump if none yet
        mov     esi,[edi]                       #retrieve collectable XL
        mov     reg_xl,esi                      #update XL
        add     edi,4                           #update compiler's sp
        mov     compsp,edi

pop1:	popad
	retc	0
        endp    popregs

#
#
#-----------
#
#       startup( char *dummy1, char *dummy2) - startup compiler
#
#       An OSINT C function calls startup to transfer control
#       to the compiler.
#
#       (XR) = basemem
#       (XL) = topmem - sizeof(WORD)
#
#	Note: This function never returns.
#

        cproc   startup,near
	pubname	startup

        pop     eax                     # discard return
        pop     eax                     # discard dummy1
        pop     eax                     # discard dummy2
	call	stackinit               # initialize MINIMAL stack
        mov     eax,compsp              # get MINIMAL's stack pointer
        SET_WA  eax                     # startup stack pointer

	cld                             # default to UP direction for string ops
#        GETOFF  eax,DFFNC               # get address of PPM offset
        mov     ppoff,eax               # save for use later
#
        mov     esp,osisp               # switch to new C stack
        MINIMAL START                   # load regs, switch stack, start compiler

        cendp   startup



#
#-----------
#
#	stackinit  -- initialize LOWSPMIN from sp.
#
#	Input:  sp - current C stack
#		stacksiz - size of desired Minimal stack in bytes
#
#	Uses:	eax
#
#	Output: register WA, sp, LOWSPMIN, compsp, osisp set up per diagram:
#
#	(high)	+----------------+
#		|  old C stack   |
#	  	|----------------| <-- incoming sp, resultant WA (future XS)
#		|	     ^	 |
#		|	     |	 |
#		/ stacksiz bytes /
#		|	     |	 |
#		|            |	 |
#		|----------- | --| <-- resultant LOWSPMIN
#		| 400 bytes  v   |
#	  	|----------------| <-- future C stack pointer, osisp
#		|  new C stack	 |
#	(low)	|                |
#
#
#

	proc	stackinit,near
	mov	eax,esp
        mov     compsp,eax              # save as MINIMAL's stack pointer
	sub	eax,stacksiz            # end of MINIMAL stack is where C stack will start
        mov     osisp,eax               # save new C stack pointer
	add	eax,4*100               # 100 words smaller for CHK
        SETMINR  LOWSPMIN,eax            # Set LOWSPMIN
	ret
	endp	stackinit

#
#-----------
#
#       mimimal -- call MINIMAL function from C
#
#       Usage:  extern void minimal(WORD callno)
#
#       where:
#         callno is an ordinal defined in osint.h, osint.inc, and calltab.
#
#       Minimal registers WA, WB, WC, XR, and XL are loaded and
#       saved from/to the register block.
#
#       Note that before restart is called, we do not yet have compiler
#       stack to switch to.  In that case, just make the call on the
#       the OSINT stack.
#

        cproc    minimal,near
	pubname	minimal

        pushad                          # save all registers for C
        mov     eax,[esp+32+4]          # get ordinal
        mov     ecx,reg_wa              # restore registers
	mov	ebx,reg_wb
        mov     edx,reg_wc              # (also _reg_ia)
	mov	edi,reg_xr
	mov	esi,reg_xl
	mov	ebp,reg_cp

        mov     osisp,esp               # 1.39 save OSINT stack pointer
        cmp     dword ptr compsp,0      # 1.39 is there a compiler stack?
        je      short min1              # 1.39 jump if none yet
        mov     esp,compsp              # 1.39 switch to compiler stack

min1:   callc   calltab[eax*4],0        # off to the Minimal code

        mov     esp,osisp               # 1.39 switch to OSINT stack

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
#       minoff -- obtain address of MINIMAL variable
#
#       Usage:  extern WORD *minoff(WORD valno)
#
#       where:
#         valno is an ordinal defined in osint.h, osint.inc and valtab.
#

        proc    minoff,near
	pubname	minoff

        mov     eax,[esp+4]             # get ordinal
        mov     eax,valtab[eax*4]       # get address of Minimal value
	retc	4

        endp    minoff
.endif


