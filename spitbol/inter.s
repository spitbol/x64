        .title          "SPITBOL ASSEMBLY-LANGUAGE TO C-LANGUAGE O/S INTERFACE"
        .sbttl          "INTER"
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
        .psize          80,132
        .arch           pentium
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
#       Acknowledgement:
#
#       This interfacing scheme is based on an idea put forth by Andy Koenig.
#
#       V1.0    10/21/86 Robert E. Goldberg, DISC.  VAX version
#       V1.01   10/23/86 Mark B. Emmer, Catspaw.  AT&T 7300 version
#       V1.02   01/07/87   "  "    "      "   Generic 68000 version
#       V1.03   01/15/87 Revised to match new VAXINTER, V1.03.  MBE
#       V1.04   01/23/87 Adjust pointers within stack during restart.
#                        Add function makeexec to write a.out file when
#                        requested with -w command option.  MBE
#       V1.05   02/04/87 <withdrawn>
#       V1.06   02/14/87 <withdrawn>
#       V1.07   02/21/87 <withdrawn>
#       V1.08   05/18/87 <withdrawn>
#       V1.10   06/03/87 Changed compiler to use A6 as pointer to constant
#                        and working storage, rather than A5.
#       V1.11   10/11/87 Added conditional 68020 opcodes for multiply,
#                        divide and remainder.
#                        Corrected bug in makeexec added when moved DB
#                        from A5 to A6.
#       V1.12   11/16/87 <withdrawn>
#       V1.13   01/15/88 Version for HP.  Initialize 68881 if present
#       V1.14   02/27/88 Version for Definicon.
#       V1.15   03/03/88 Added SYSGC call.
#       V1.16   05/09/88 Split off 80386 version
#       V1.17   09/12/89 Add support for keyboard polling and keyboard editing.
#                        Makeexec accepts file name scblk.
#       V1.18   10/27/89 <withdrawn>
#       V1.19   12/16/89 Add pushregs, popregs
#       V1.20   07/21/90 Modify pushregs/popregs to save/restore EBP and
#                        load it with reg_cp, so that any MINIMAL routine
#                        call between adjusts CP properly.
#                        Change ccaller to clear EBP, so CP (which points
#                        within a SPITBOL block) isn't placed on stack when
#                        C routine pushes EBP.  This is not a legimate
#                        collectable value, and will crash if a garbage
#                        collect occurs (as within callef). 2.43 I/O.
#       V1.21   09/09/90 Modify pushregs to return zero in ESI (XL), so
#                        that a safe, collectable value is there for any
#                        subsequent call to a memory allocation routine.
#       V1.22   10/31/90 Remove SYSGC call.
#       V1.23   11/08/90 Update I/O version number to 2.45.
#       V1.24   11/17/90 Modify push/pop regs to put reg_xl on stack,
#                        other regs into a temp area.
#       V1.25   12/04/90 Mark SYSEX for 3 exits.
#       V1.26   01/21/91 Update I/O version number to 2.46.
#       V1.27   02/07/91 Add Control-C checking.
#       V1.28   02/16/91 Add BACKSPACE function via SYSBS.
#       V1.29   02/22/91 Rewrite CINREAD to allocate buffer on stack.
#       V1.30   05/12/91 Add include of systype.ah to assemble different
#                        versions for use with HighC and Intel compilers.
#                        Move break logic to break.c for Intel version.
#       V1.31   06/09/91 <withdrawn>.
#       V1.32   06/21/91 Add routines for Intel version to allow C code
#                        to manage an LDT, including transitions to and
#                        from protection ring 0.  Update version number
#                        to 2.47 for 1.20 release.
#       V1.33   10/17/91 Update to 2.48 for 1.21 release.
#       V1.34   11/07/91 Add call to INSTA to initialize static
#                        region after reloading save file.
#       V1.35   11/30/91 Add MINIMAL function to allow calls into
#                        MINIMAL code from C.
#       V1.36   12/17/91 Update to 2.49 for 1.22 release.
#       V1.37   01/23/92 Update to 2.50 for 1.23 release.
#       V1.38   03/06/92 Update to 2.51 for 1.24 release.
#       V1.39   03/13/92 Fix pushregs and popregs to not save and
#                        restore REG_CP.  It is necessary for GBCOL
#                        to be able to modify REG_CP and have its
#                        change stick.  We also go to a dual stack
#                        approach like the Macintosh, with the compiler's
#                        stack and the OSINT stack keep seperate.  This
#                        is necessary because if an OSINT return calls into
#                        Minimal and triggers a garbage collect, anything on
#                        the stack from OSINT could be fatal to GBCOL.
#       V1.40   03/29/92 Update to 2.52 for 1.25 release.
#       V1.41   10/11/95 Redid overflow detection logic to check for infinity
#                        in RA, relying on masked exceptions to produce infinity
#                        from basic math ops.
#       V1.42   10/08/96 Increased number of exits for SYSFC from 1 to 2.
#       V1.43   03/31/97 Added sav_compsp for use by push/popregs.  Call to
#                        SYSLD would save esp in compsp (at ccaller), then
#                        loadef calls ALOST which may call GBCOL, which calls
#                        SYSGC and clobbers compsp with this nested cccaller call.
#                        pushregs saves compsp in sav_compsp, and popregs
#                        restores it.
#       V1.44   06/20/99 Fix bug in RTI_ when negative number was not pushing
#                        ecx.
#       V1.45   11/26/99 Fix bug in CPR_ not detecting -0.0 as true zero.  (-0.0
#                        results from -1.0 * 0.0 and 0.0 / -1.0.
#       V1.46   06/17/09 Modify for Linux "as" assembler.
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
.if winnt && _MASM_ <> 0
        .long   0               # 64-bit offset
        .long   0               # and current position
.endif
        .fill   1024,1,0        # buffer
#
        pubdef  TTYBUF,.long,0     # type word
        .long   0               # block length
        .long   260             # buffer size  (260 OK in MS-DOS with cinread())
        .long   0               # remaining chars to read
        .long   0               # offset to next char to read
        .long   0               # file position of buffer
        .long   0               # physical position in file
.if winnt && _MASM_ <> 0
        .long   0               # 64-bit offset
        .long   0               # and current position
.endif
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
#-----------
#
#       Interface routines
#
#       Each interface routine takes the following form:
#
#               SYSXX   call    ccaller         # call common interface
#                       dd      zysxx           # address of C OSINT function
#                       db      n               # offset to instruction after
#                                               #   last procedure exit
#
#       In an effort to achieve portability of C OSINT functions, we
#       do not take take advantage of any "internal" to "external"
#       transformation of names by C compilers.  So, a C OSINT function
#       representing sysxx is named _zysxx.  This renaming should satisfy
#       all C compilers.
#
#       IMPORTANT  ONE interface routine, SYSFC, is passed arguments on
#       the stack.  These items are removed from the stack before calling
#       ccaller, as they are not needed by this implementation.
#
#
#-----------
#
#       CCALLER is called by the OS interface routines to call the
#       real C OS interface function.
#
#       General calling sequence is
#
#               call    ccaller
#               dd      address_of_C_function
#               db      2*number_of_exit_points
#
#       Control IS NEVER returned to a interface routine.  Instead, control
#       is returned to the compiler (THE caller of the interface routine).
#
#       The C function that is called MUST ALWAYS return an integer
#       indicating the procedure exit to take or that a normal return
#       is to be performed.
#
#               C function      Interpretation
#               return value
#               ------------    -------------------------------------------
#                    <0         Do normal return to instruction past
#                               last procedure exit (distance passed
#                               in by dummy routine and saved on stack)
#                     0         Take procedure exit 1
#                     4         Take procedure exit 2
#                     8         Take procedure exit 3
#                    ...        ...
#
        proc   ccaller,near

#       (1) Save registers in global variables
#
        mov     reg_wa,ecx              # save registers
	mov	reg_wb,ebx
        mov     reg_wc,edx              # (also _reg_ia)
	mov	reg_xr,edi
	mov	reg_xl,esi
        mov     reg_cp,ebp              # Needed in image saved by sysxi

#       (2) Get pointer to arg list
#
        pop     esi                     # point to arg list
#
#       (3) Fetch address of C function, fetch offset to 1st instruction
#           past last procedure exit, and call C function.
#
        cs                              # CS segment override
        lodsd                           # point to C function entry point
#       lodsd   cs:ccaller              # point to C function entry point
        movzx   ebx,byte ptr [esi]   # save normal exit adjustment
#
        mov     reg_pp,ebx              # in memory
        pop     reg_pc                  # save return PC past "CALL SYSXX"
#
#       (3a) Save compiler stack and switch to OSINT stack
#
        mov     compsp,esp              # 1.39 save compiler's stack pointer
        mov     esp,osisp               # 1.39 load OSINT's stack pointer
#
#       (3b) Make call to OSINT
#
        call    eax                     # call C interface function
#
#       (4) Restore registers after C function returns.
#

cc1:    mov     osisp,esp               # 1.39 save OSINT's stack pointer
        mov     esp,compsp              # 1.39 restore compiler's stack pointer
        mov     ecx,reg_wa              # restore registers
	mov	ebx,reg_wb
        mov     edx,reg_wc              # (also reg_ia)
	mov	edi,reg_xr
	mov	esi,reg_xl
	mov	ebp,reg_cp

	cld
#
#       (5) Based on returned value from C function (in EAX) either do a normal
#           return or take a procedure exit.
#
        or      eax,eax         # test if normal return ...
        jns     short erexit    # j. if >= 0 (take numbered exit)
	mov	eax,reg_pc
        add     eax,reg_pp      # point to instruction following exits
        jmp     eax             # bypass PPM exits

#                               # else (take procedure exit n)
erexit: shr     eax,1           # divide by 2
        add     eax,reg_pc      #   get to address of exit offset
	movsx	eax,word ptr [eax]
        add     eax,ppoff       # bias to fit in 16-bit word
	push	eax
        xor     eax,eax         # in case branch to error cascade
        ret                     #   take procedure exit via PPM address

        endp    ccaller
#
#---------------
#
#       Individual OSINT routine entry points
#
        publab SYSAX
	ext	zysax,near
SYSAX:	call	ccaller
        address   zysax
        .byte   0
#
        publab SYSBS
	ext	zysbs,near
SYSBS:	call	ccaller
        address   zysbs
        .byte   3*2
#
        publab SYSBX
	ext	zysbx,near
SYSBX:	mov	reg_xs,esp
	call	ccaller
        address zysbx
        .byte   0
#
.if SETREAL == 1
        publab SYSCR
	ext	zyscr,near
SYSCR:  call    ccaller
        address zyscr
        .byte   0
#
.endif
        publab SYSDC
	ext	zysdc,near
SYSDC:	call	ccaller
        address zysdc
        .byte   0
#
        publab SYSDM
	ext	zysdm,near
SYSDM:	call	ccaller
        address zysdm
        .byte   0
#
        publab SYSDT
	ext	zysdt,near
SYSDT:	call	ccaller
        address zysdt
        .byte   0
#
        publab SYSEA
	ext	zysea,near
SYSEA:	call	ccaller
        address zysea
        .byte   1*2
#
        publab SYSEF
	ext	zysef,near
SYSEF:	call	ccaller
        address zysef
        .byte   3*2
#
        publab SYSEJ
	ext	zysej,near
SYSEJ:	call	ccaller
        address zysej
        .byte   0
#
        publab SYSEM
	ext	zysem,near
SYSEM:	call	ccaller
        address zysem
        .byte   0
#
        publab SYSEN
	ext	zysen,near
SYSEN:	call	ccaller
        address zysen
        .byte   3*2
#
        publab SYSEP
	ext	zysep,near
SYSEP:	call	ccaller
        address zysep
        .byte   0
#
        publab SYSEX
	ext	zysex,near
SYSEX:	mov	reg_xs,esp
	call	ccaller
        address zysex
        .byte   3*2
#
        publab SYSFC
	ext	zysfc,near
SYSFC:  pop     eax             # <<<<remove stacked SCBLK>>>>
	lea	esp,[esp+edx*4]
	push	eax
	call	ccaller
        address zysfc
        .byte   2*2
#
        publab SYSGC
	ext	zysgc,near
SYSGC:	call	ccaller
        address zysgc
        .byte   0
#
        publab SYSHS
	ext	zyshs,near
SYSHS:	mov	reg_xs,esp
	call	ccaller
        address zyshs
        .byte   8*2
#
        publab SYSID
	ext	zysid,near
SYSID:	call	ccaller
        address zysid
        .byte   0
#
        publab SYSIF
	ext	zysif,near
SYSIF:	call	ccaller
        address zysif
        .byte   1*2
#
        publab SYSIL
	ext	zysil,near
SYSIL:  call    ccaller
        address zysil
        .byte   0
#
        publab SYSIN
	ext	zysin,near
SYSIN:	call	ccaller
        address zysin
        .byte   3*2
#
        publab SYSIO
	ext	zysio,near
SYSIO:	call	ccaller
        address zysio
        .byte   2*2
#
        publab SYSLD
	ext	zysld,near
SYSLD:  call    ccaller
        address zysld
        .byte   3*2
#
        publab SYSMM
	ext	zysmm,near
SYSMM:	call	ccaller
        address zysmm
        .byte   0
#
        publab SYSMX
	ext	zysmx,near
SYSMX:	call	ccaller
        address zysmx
        .byte   0
#
        publab SYSOU
	ext	zysou,near
SYSOU:	call	ccaller
        address zysou
        .byte   2*2
#
        publab SYSPI
	ext	zyspi,near
SYSPI:	call	ccaller
        address zyspi
        .byte   1*2
#
        publab SYSPL
	ext	zyspl,near
SYSPL:	call	ccaller
        address zyspl
        .byte   3*2
#
        publab SYSPP
	ext	zyspp,near
SYSPP:	call	ccaller
        address zyspp
        .byte   0
#
        publab SYSPR
	ext	zyspr,near
SYSPR:	call	ccaller
        address zyspr
        .byte   1*2
#
        publab SYSRD
	ext	zysrd,near
SYSRD:	call	ccaller
        address zysrd
        .byte   1*2
#
        publab SYSRI
	ext	zysri,near
SYSRI:	call	ccaller
        address zysri
        .byte   1*2
#
        publab SYSRW
	ext	zysrw,near
SYSRW:	call	ccaller
        address zysrw
        .byte   3*2
#
        publab SYSST
	ext	zysst,near
SYSST:	call	ccaller
        address zysst
        .byte   5*2
#
        publab SYSTM
	ext	zystm,near
SYSTM:	call	ccaller
systm_p: address zystm
        .byte   0
#
        publab SYSTT
	ext	zystt,near
SYSTT:	call	ccaller
        address zystt
        .byte   0
#
        publab SYSUL
	ext	zysul,near
SYSUL:	call	ccaller
        address zysul
        .byte   0
#
        publab SYSXI
	ext	zysxi,near
SYSXI:	mov	reg_xs,esp
	call	ccaller
sysxi_p: address zysxi
        .byte   2*2

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
        GETOFF  eax,DFFNC               # get address of PPM offset
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


#
#-----------
#
#       get_fp  - get C caller's FP (frame pointer)
#
#       get_fp() returns the frame pointer for the C function that called
#       this function.  HOWEVER, THIS FUNCTION IS ONLY CALLED BY ZYSXI.
#
#       C function zysxi calls this function to determine the lowest USEFUL
#       word on the stack, so that only the useful part of the stack will be
#       saved in the load module.
#
#       The flow goes like this:
#
#       (1) User's spitbol program calls EXIT function
#
#       (2) spitbol compiler calls interface routine sysxi to handle exit
#
#       (3) Interface routine sysxi passes control to ccaller which then
#           calls C function zysxi
#
#       (4) C function zysxi will write a load module, but needs to save
#           a copy of the current stack in the load module.  The base of
#           the part of the stack to be saved begins with the frame of our
#           caller, so that the load module can execute a return to ccaller.
#
#           This will allow the load module to pretend to be returning from
#           C function zysxi.  So, C function zysxi calls this function,
#           get_fp, to determine the BASE OF THE USEFUL PART OF THE STACK.
#
#           We cheat just a little bit here.  C function zysxi can (and does)
#           have local variables, but we won't save them in the load module.
#           Only the portion of the frame established by the 80386 call
#           instruction, from BP up, is saved.  These local variables
#           aren't needed, because the load module will not be going back
#           to C function zysxi.  Instead when function restart returns, it
#           will act as if C function zysxi is returning.
#
#       (5) After writing the load module, C function zysxi calls C function
#           zysej to terminate spitbol's execution.
#
#       (6) When the resulting load module is executed, C function main
#           calls function restart.  Function restart restores the stack
#           and then does a return.  This return will act as if it is
#           C function zysxi doing the return and the user's program will
#           continue execution following its call to EXIT.
#
#       On entry to _get_fp, the stack looks like
#
#               /      ...      /
#       (high)  |               |
#               |---------------|
#       ZYSXI   |    old PC     |  --> return point in CCALLER
#         +     |---------------|  USEFUL part of stack
#       frame   |    old BP     |  <<<<-- BP of get_fp's caller
#               |---------------|     -
#               |     ZYSXI's   |     -
#               /     locals    /     - NON-USEFUL part of stack
#               |               |     ------
#       ======= |---------------|
#       SP-->   |    old PC     |  --> return PC in C function ZYSXI
#       (low)   +---------------+
#
#       On exit, return EBP in EAX. This is the lower limit on the
#       size of the stack.


        cproc    get_fp,near
	pubname	get_fp

        mov     eax,reg_xs      # Minimal's XS
        add     eax,4           # pop return from call to SYSBX or SYSXI
        retc    0               # done

        cendp    get_fp

#
#-----------
#
#       restart - restart for load module
#
#       restart( char *dummy, char *stackbase ) - startup compiler
#
#       The OSINT main function calls restart when resuming execution
#       of a program from a load module.  The OSINT main function has
#       reset global variables except for the stack and any associated
#       variables.
#
#       Before restoring stack, set up values for proper checking of
#       stack overflow. (initial sp here will most likely differ
#       from initial sp when compile was done.)
#
#       It is also necessary to relocate any addresses in the the stack
#       that point within the stack itself.  An adjustment factor is
#       calculated as the difference between the STBAS at exit() time,
#       and STBAS at restart() time.  As the stack is transferred from
#       TSCBLK to the active stack, each word is inspected to see if it
#       points within the old stack boundaries.  If so, the adjustment
#       factor is subtracted from it.
#
#       We use Minimal's INSTA routine to initialize static variables
#       not saved in the Save file.  These values were not saved so as
#       to minimize the size of the Save file.
#
	ext	rereloc,near

        cproc   restart,near
	pubname	restart

        pop     eax                     # discard return
        pop     eax                     # discard dummy
        pop     eax                     # get lowest legal stack value

        add     eax,stacksiz            # top of compiler's stack
        mov     esp,eax                 # switch to this stack
	call	stackinit               # initialize MINIMAL stack

                                        # set up for stack relocation
        lea     eax,TSCBLK+scstr        # top of saved stack
        mov     ebx,lmodstk             # bottom of saved stack
        GETMIN  ecx,STBAS               # ecx = stbas from exit() time
        sub     ebx,eax                 # ebx = size of saved stack
	mov	edx,ecx
        sub     edx,ebx                 # edx = stack bottom from exit() time
	mov	ebx,ecx
        sub     ebx,esp                 # ebx = old stbas - new stbas

        SETMINR  STBAS,esp               # save initial sp
        GETOFF  eax,DFFNC               # get address of PPM offset
        mov     ppoff,eax               # save for use later
#
#       restore stack from TSCBLK.
#
        mov     esi,lmodstk             # -> bottom word of stack in TSCBLK
        lea     edi,TSCBLK+scstr        # -> top word of stack
        cmp     esi,edi                 # Any stack to transfer?
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
        mov     esp,osisp               # 1.39 back to OSINT's stack pointer
        callc   rereloc,0               # V1.08 relocate compiler pointers into stack
        GETMIN  eax,STATB               # V1.34 start of static region to XR
	SET_XR  eax
        MINIMAL INSTA                   # V1.34 initialize static region

#
#       Now pretend that we're executing the following C statement from
#       function zysxi:
#
#               return  NORMAL_RETURN#
#
#       If the load module was invoked by EXIT(), the return path is
#       as follows:  back to ccaller, back to S$EXT following SYSXI call,
#       back to user program following EXIT() call.
#
#       Alternately, the user specified -w as a command line option, and
#       SYSBX called MAKEEXEC, which in turn called SYSXI.  The return path
#       should be:  back to ccaller, back to MAKEEXEC following SYSXI call,
#       back to SYSBX, back to MINIMAL code.  If we allowed this to happen,
#       then it would require that stacked return address to SYSBX still be
#       valid, which may not be true if some of the C programs have changed
#       size.  Instead, we clear the stack and execute the restart code that
#       simulates resumption just past the SYSBX call in the MINIMAL code.
#       We distinguish this case by noting the variable STAGE is 4.
#
.if winnt
	ext	startbrk,near
.endif
        callc   startbrk,0              # start control-C logic

        GETMIN  eax,STAGE               # is this a -w call?
	cmp	eax,4
        je      short re4               # yes, do a complete fudge

#
#       Jump back to cc1 with return value = NORMAL_RETURN
	mov	eax,-1
        jmp     cc1                     # jump back

#       Here if -w produced load module.  simulate all the code that
#       would occur if we naively returned to sysbx.  Clear the stack and
#       go for it.
#
re4:	GETMIN	eax,STBAS
        mov     compsp,eax              # 1.39 empty the stack

#       Code that would be executed if we had returned to makeexec:
#
        SETMIN  GBCNT,0                 # reset garbage collect count
        callc   zystm,0                 # Fetch execution time to reg_ia
        mov     eax,reg_ia              # Set time into compiler
	SETMINR	TIMSX,eax

#       Code that would be executed if we returned to sysbx:
#
        push    outptr                  # swcoup(outptr)
	callc	swcoup,4

#       Jump to Minimal code to restart a save file.

        MINIMAL RSTRT                   # no return

        cendp    restart


#
#-----------
#
#       CVD_ - convert by division
#
#       Input   IA (EDX) = number <=0 to convert
#       Output  IA / 10
#               WA (ECX) = remainder + '0'
#
        publab  CVD_
        proc    CVD_,near

        xchg    eax,edx         # IA to EAX
        cdq                     # sign extend
        idiv    dword ptr ten   # divide by 10. edx = remainder (negative)
        neg     edx             # make remainder positive
        add     dl,0x30         # convert remainder to ascii ('0')
        mov     ecx,edx         # return remainder in WA
        xchg    edx,eax         # return quotient in IA
	ret

        endp    CVD_
#
#-----------
#
#       DVI_ - divide IA (EDX) by long in EAX
#
        publab  DVI_
        proc    DVI_,near

        or      eax,eax         # test for 0
        jz      short setovr    # jump if 0 divisor
        push    ebp             # preserve CP
        xchg    ebp,eax         # divisor to ebp
        xchg    eax,edx         # dividend in eax
        cdq                     # extend dividend
        idiv    ebp             # perform division. eax=quotient, edx=remainder
        xchg    edx,eax         # place quotient in edx (IA)
        pop     ebp             # restore CP
        xor     eax,eax         # clear overflow indicator
	ret

        endp    DVI_

#
#-----------
#
#       RMI_ - remainder of IA (EDX) divided by long in EAX
#
        publab  RMI_
        proc    RMI_,near
             or      eax,eax         # test for 0
        jz      short setovr    # jump if 0 divisor
        push    ebp             # preserve CP
        xchg    ebp,eax         # divisor to ebp
        xchg    eax,edx         # dividend in eax
        cdq                     # extend dividend
        idiv    ebp             # perform division. eax=quotient, edx=remainder
        pop     ebp             # restore CP
        xor     eax,eax         # clear overflow indicator
        ret                     # return remainder in edx (IA)
setovr: mov     al,0x80         # set overflow indicator
	dec	al
	ret

        endp    RMI_


#----------
#
#    Calls to C
#
#       The calling convention of the various compilers:
#
#       Integer results returned in EAX.
#       Float results returned in ST0 for Intel.
#       See conditional switches fretst0 and
#       freteax in systype.ah for each compiler.
#
#       C function preserves EBP, EBX, ESI, EDI.
#


#----------
#
#       RTI_ - convert real in RA to integer in IA
#               returns C=0 if fit OK, C=1 if too large to convert
#
        publab  RTI_
        proc    RTI_,near

# 41E00000 00000000 = 2147483648.0
# 41E00000 00200000 = 2147483649.0
        mov     eax, dword ptr reg_ra+4   # RA msh
        btr     eax,31          # take absolute value, sign bit to carry flag
        jc      short RTI_2     # jump if negative real
        cmp     eax,0x41E00000  # test against 2147483648
        jae     short RTI_1     # jump if >= +2147483648
RTI_3:  push    ecx             # protect against C routine usage.
        push    eax             # push RA MSH
        push    dword ptr reg_ra# push RA LSH
        callfar f_2_i,8         # float to integer
        xchg    eax,edx         # return integer in edx (IA)
        pop     ecx             # restore ecx
        clc
	ret

# here to test negative number, made positive by the btr instruction
RTI_2:  cmp     eax,0x41E00000          # test against 2147483649
        jb      short RTI_0             # definately smaller
        ja      short RTI_1             # definately larger
        cmp     word ptr reg_ra+2, 0x0020
        jae     short RTI_1
RTI_0:  btc     eax,31                  # make negative again
        jmp     RTI_3
RTI_1:  stc                             # return C=1 for too large to convert
        ret

        endp    CVD_
#
#----------
#
#       ITR_ - convert integer in IA to real in RA
#
        publab  ITR_
        proc    ITR_,near

        push    ecx             # preserve
        push    edx             # push IA
        callfar i_2_f,4         # integer to float
.if fretst0
	fstp	qword ptr reg_ra
        pop     ecx             # restore ecx
	fwait
.endif
.if freteax
        mov     dword ptr reg_ra,eax    # return result in RA
	mov	dword ptr reg_ra+4,edx
        pop     ecx             # restore ecx
.endif
	ret

        endp    ITR_
#
#----------
#
#       LDR_ - load real pointed to by eax to RA
#
        publab  LDR_
        proc    LDR_,near

        push    dword ptr [eax]                 # lsh
	pop	dword ptr reg_ra
        mov     eax,[eax+4]                     # msh
	mov	dword ptr reg_ra+4, eax
	ret

        endp    LDR_
#
#----------
#
#       STR_ - store RA in real pointed to by eax
#
        publab  STR_
        proc    STR_,near

        push    dword ptr reg_ra                # lsh
	pop	dword ptr [eax]
        push    dword ptr reg_ra+4              # msh
	pop	dword ptr [eax+4]
	ret

        endp    STR_
#
#----------
#
#       ADR_ - add real at [eax] to RA
#
        publab  ADR_
        proc    ADR_,near

        push    ecx                             # preserve regs for C
	push	edx
        push    dword ptr reg_ra+4              # RA msh
        push    dword ptr reg_ra                # RA lsh
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

        endp    ADR_
#
#----------
#
#       SBR_ - subtract real at [eax] from RA
#
        publab  SBR_
        proc    SBR_,near

        push    ecx                             # preserve regs for C
	push	edx
        push    dword ptr reg_ra+4              # RA msh
        push    dword ptr reg_ra                # RA lsh
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

        endp    SBR_
#
#----------
#
#       MLR_ - multiply real in RA by real at [eax]
#
        publab  MLR_
        proc    MLR_,near

        push    ecx                             # preserve regs for C
	push	edx
        push    dword ptr reg_ra+4              # RA msh
        push    dword ptr reg_ra                # RA lsh
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

        endp    MLR_
#
#----------
#
#       DVR_ - divide real in RA by real at [eax]
#
        publab  DVR_

        proc    DVR_,near

        push    ecx                             # preserve regs for C
	push	edx
        push    dword ptr reg_ra+4              # RA msh
        push    dword ptr reg_ra                # RA lsh
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

        endp    DVR_
#
#----------
#
#       NGR_ - negate real in RA
#
        publab  NGR_

        proc    NGR_,near
	cmp	dword ptr reg_ra, 0
	jne	short ngr_1
	cmp	dword ptr reg_ra+4, 0
        je      short ngr_2                     # if zero, leave alone
ngr_1:  xor     byte ptr reg_ra+7, 0x80         # complement mantissa sign
ngr_2:	ret

        endp    NGR_
#
#----------
#
#       ATN_ arctangent of real in RA
#
        publab  ATN_

        proc    ATN_,near

        push    ecx                             # preserve regs for C
	push	edx
        push    dword ptr reg_ra+4              # RA msh
        push    dword ptr reg_ra                # RA lsh
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

        endp    ATN_
#
#----------
#
#       CHP_ chop fractional part of real in RA
#
        publab  CHP_

        proc    CHP_,near

        push    ecx                             # preserve regs for C
	push	edx
        push    dword ptr reg_ra+4              # RA msh
        push    dword ptr reg_ra                # RA lsh
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

        endp    CHP_
#
#----------
#
#       COS_ cosine of real in RA
#
        publab  COS_

        proc    COS_,near

        push    ecx                             # preserve regs for C
	push	edx
        push    dword ptr reg_ra+4              # RA msh
        push    dword ptr reg_ra                # RA lsh
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

        endp    COS_
#
#----------
#
#       ETX_ exponential of real in RA
#
        publab  ETX_

        proc    ETX_,near

        push    ecx                             # preserve regs for C
	push	edx
        push    dword ptr reg_ra+4              # RA msh
        push    dword ptr reg_ra                # RA lsh
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

        endp    ETX_
#
#----------
#
#       LNF_ natural logarithm of real in RA
#
        publab  LNF_

        proc    LNF_,near

        push    ecx                             # preserve regs for C
	push	edx
        push    dword ptr reg_ra+4              # RA msh
        push    dword ptr reg_ra                # RA lsh
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

        endp    LNF_
#
#----------
#
#       SIN_ arctangent of real in RA
#
        publab  SIN_

        proc    SIN_,near

        push    ecx                             # preserve regs for C
	push	edx
        push    dword ptr reg_ra+4              # RA msh
        push    dword ptr reg_ra                # RA lsh
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

        endp    SIN_
#
#----------
#
#       SQR_ arctangent of real in RA
#
        publab  SQR_

        proc    SQR_,near

        push    ecx                             # preserve regs for C
	push	edx
        push    dword ptr reg_ra+4              # RA msh
        push    dword ptr reg_ra                # RA lsh
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

        endp    SQR_
#
#----------
#
#       TAN_ arctangent of real in RA
#
        publab  TAN_

        proc    TAN_,near

        push    ecx                             # preserve regs for C
	push	edx
        push    dword ptr reg_ra+4              # RA msh
        push    dword ptr reg_ra                # RA lsh
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

        endp    TAN_
#
#----------
#
#       CPR_ compare real in RA to 0
#
        publab  CPR_

        proc    CPR_,near

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

        endp    CPR_
#
#----------
#
#       OVR_ test for overflow value in RA
#
        publab  OVR_

OVR_:   proc    near

        mov     ax, word ptr reg_ra+6   # get top 2 bytes
        and     ax, 0x7ff0              # check for infinity or nan
        add     ax, 0x10                # set/clear overflow accordingly
	ret

        endp    OVR_

.if winnt
#
#----------
#
#       cinread(fdn, buffer, size)      Do buffered console input
#
#       Input:  fdn     = file descriptor in case can't use DOS function 0A
#               buffer  = buffer
#               size    = buffer size
#       Output: eax    = number of bytes transferred if no error
#               = -1 if error
#
#       Preserves ds, es, esi, edi, ebx
#
#       Uses DOS function 0A because that is the function intercepted by
#       various keyboard editing programs, such as DOS Edit.
#
#       If a program has redirected standard output, function 0A's echos
#       will go to the redirected file, instead of the screen.  To overcome
#       this, we save standard out's handle, and force it to be the console
#       (stderr).  Similarly, function 0Ah reads from handle 0, and we
#       force it to the console to preclude reading from a file.
#
#       If insufficient handles remain in the system to do this little
#       shuffle, we simple fall back to the normal DOS read routine.
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

        xor     ebx,ebx                 # Save STDIN by duplicating to
        mov     ecx,ebx                 #  get another handle
	xor	eax,eax
        mov     ah,0x45                 # CX = STDIN
        int     0x21
        jc      cinr5                   # Out of handles
        push    eax                     # Save handle to old STDIN
        mov     ebx,2                   # Make STDIN refer to STDERR
        mov     ah,0x46                 # so DOS's input comes from keyboard
        int     0x21

        mov     ebx,1                   # Save STDOUT by duplicating to
        mov     ecx,ebx                 #  get another handle
        mov     ah,0x45                 # CX = STDOUT
        int     0x21
        jc      short cinr4             # Out of handles
	push	ecx
        push    eax                     # Save handle to old STDOUT
        mov     ebx,2                   # Make STDOUT refer to STDERR
        mov     ah,0x46                 # so DOS' echo goes to screen
        int     0x21

	mov	ecx,[ebp].cin_siz
        inc     ecx                     # Allow for CR
	cmp	ecx,255
	jle	short cinr1
        mov     cl,255                  # 255 is the max size for function 0Ah
cinr1:  lea     edx,ctemp.crbuf         # Buffer (DS=SS)
        mov     [edx],cl                # Set up count

        mov     ah,0x0a
        int     0x21                    # Do buffered input into [edx+2]

	pop	ebx
        pop     ecx                     # (CX = STDOUT)
        mov     ah,0x46                 # Restore STDOUT to original file
        int     0x21
        mov     ah,0x3e                 # Discard dup'ed handle
        int     0x21

        xor     ecx,ecx                 # CX = STDIN
	pop	ebx
        mov     ah,0x46                 # Restore STDIN to original file
        int     0x21
        mov     ah,0x3e                 # Discard dup'ed handle
        int     0x21

	mov	esi,edx
        inc     esi                     # Point to number of bytes read
        movzx   ebx,byte ptr [esi]      # Char count
        inc     ebx                     # Include CR
        inc     esi                     # Point to first char
        lea     edx,[esi+ebx]           # Point past CR
        mov     [edx],byte ptr 10       # Append LF after CR
        inc     ebx                     # Include LF
        cmp     ebx,cin_siz[ebp]        # Compare with caller's buffer size
	jle	short cinr3
        mov     ebx,cin_siz[ebp]        # Caller's buffer size limits us
cinr3:	mov	ecx,ebx
        mov     edi,cin_buf[ebp]        # Caller's buffer
  rep	movsb

        push    ebx                     # Save count
        mov     ebx,2                   # Force LF echo to screen
        mov     ah,0x40                 # edx points to LF
	mov	ecx,1
        int     0x21
	pop	eax

cinr2:	pop	edi
	pop	esi
	pop	ebx
	leave
	retc	12

# Here if insufficient handles to save standard out.
# Release standard in.
#
cinr4:  xor     ecx,ecx                 # CX = STDIN
	pop	ebx
        mov     ah,0x46                 # Restore STDIN to original file
        int     0x21
        mov     ah,0x3e                 # Discard dup'ed handle
        int     0x21

# Here if insufficient handles to save standard in.
# Just fall back to read routine.
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
#       chrdevdos(fdn)  Do ioctl to see if character device.
#
#       Input:  fdn     = file descriptor
#       Output: eax     = 81h/82h if input/output char dev, else 0
#
#       Preserves ds, es, esi, edi, ebx
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

        mov     ebx,chrdev_fdn[ebp]     # Caller's fdn
        mov     ax,0x4400               # IOCTL get status
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
#       rawmodedos(fdn,mode)    Set console to raw/cooked mode
#
#       Input:  fdn     = file descriptor
#               mode    = 0 = cooked, 1 = raw
#       Output: none
#
#       Preserves ds, es, esi, edi, ebx
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
        and     eax,0x0DF
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


  CSegEnd_
        .end
