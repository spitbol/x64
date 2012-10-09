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
#       Global Variables
#
	.extern	LNF_
	.extern	ETX_
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
	.global	ppoff
ppoff:  .long   0               # offset for ppm exits
	
	.global	compsp
	.global	osisp
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

	CSeg_
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
	.global	cc1
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


  CSegEnd_
        .end
