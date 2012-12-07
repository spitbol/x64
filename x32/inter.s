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
#
        .balign 4
	.extern reg_block
	.extern reg_wa
	.extern reg_wb
	.extern reg_ia
	.extern reg_wc
	.extern reg_xr
	.extern reg_xl
	.extern reg_cp
	.extern reg_ra
	.extern	reg_pc
	.extern reg_pp
	.extern reg_xs
	.extern	ten
	.extern	inf
	.extern	sav_block
	.extern	ppoff
	.extern compsp	
	.extern sav_compsp
	.extern	.osisp
#r_size	= .-reg_block
	
 r_size = 44
	.extern	reg_size

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


#         cproc   startup,near
# 	pubname	startup
# 
#         pop     eax                     # discard return
#         pop     eax                     # discard dummy1
#         pop     eax                     # discard dummy2
# 	call	stackinit               # initialize MINIMAL stack
#         mov     eax,compsp              # get MINIMAL's stack pointer
#         SET_WA  eax                     # startup stack pointer
# 
# 	cld                             # default to UP direction for string ops
# #        GETOFF  eax,DFFNC               # get address of PPM offset
#         mov     ppoff,eax               # save for use later
# #
#         mov     esp,osisp               # switch to new C stack
#         MINIMAL START                   # load regs, switch stack, start compiler




	.extern	stackinit
