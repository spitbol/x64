globals =               1                       #ASM globals defined here
        .include        "systype.ah"
        .include        "osint.inc"

        Header_
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
	.global	reg_pc
reg_pc: .long   0               # return PC from caller
	.global	reg_pp
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
	.global	compsp
compsp: .long   0               # 1.39 compiler's stack pointer
sav_compsp:
        .long   0               # save compsp here
	.global	osisp
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



	.extern	stackinit
