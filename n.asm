; 
; This file is part of Macro SPITBOL.
; 
;     Macro SPITBOL is free software: you can redistribute it and/or modify
;     it under the terms of the GNU General Public License as published by
;     the Free Software Foundation, either version 3 of the License, or
;     (at your option) any later version.
; 
;     Macro SPITBOL is distributed in the hope that it will be useful,
;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;     GNU General Public License for more details.
; 
;     You should have received a copy of the GNU General Public License
;     along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
;
; First segment in program.  Contains serial number string.
; If external functions are included, a call to the external
; function will appear in this segment as well, placed here
; by the code in load.asm.
;
        %include        "systype.nh"
        %include        "nosint.inc"
	extern	reg_ra
	extern	osisp

;	addresses defined by minimal source
	extern	TSCBLK
	extern	STBAS
	extern	DFFNC
	extern	TSCBLK
	extern	STATB
	extern	STAGE
	extern	STBAS
	extern	GBCNT
	extern	TIMSX
	extern	LOWSPMIN

        Header_
;
;       File: inter.s           Version: 1.46
;       ---------------------------------------
;
;       This file contains the assembly language routines that interface
;       the Macro SPITBOL compiler written in 80386 assembly language to its
;       operating system interface functions written in C.
;
;       Contents:
;
;       o Overview
;       o Global variables accessed by OSINT functions
;       o Interface routines between compiler and OSINT functions
;       o C callable function startup
;       o C callable function get_fp
;       o C callable function restart
;       o C callable function makeexec
;       o Routines for Minimal opcodes CHK and CVD
;       o Math functions for integer multiply, divide, and remainder
;       o Math functions for real operation
;
;-----------
;
;       Overview
;
;       The Macro SPITBOL compiler relies on a set of operating system
;       interface functions to provide all interaction with the host
;       operating system.  These functions are referred to as OSINT
;       functions.  A typical call to one of these OSINT functions takes
;       the following form in the 80386 version of the compiler:
;
;               ...code to put arguments in registers...
;               call    SYSXX           # call osint function
;               dd      EXIT_1          # address of exit point 1
;               dd      EXIT_2          # address of exit point 2
;               ...     ...             # ...
;               dd      EXIT_n          # address of exit point n
;               ...instruction following call...
;
;       The OSINT function 'SYSXX' can then return in one of n+1 ways:
;       to one of the n exit points or to the instruction following the
;       last exit.  This is not really very complicated - the call places
;       the return address on the stack, so all the interface function has
;       to do is add the appropriate offset to the return address and then
;       pick up the exit address and jump to it OR do a normal return via
;       an ret instruction.
;
;       Unfortunately, a C function cannot handle this scheme.  So, an
;       intermediary set of routines have been established to allow the
;       interfacing of C functions.  The mechanism is as follows:
;
;       (1) The compiler calls OSINT functions as described above.
;
;       (2) A set of assembly language interface routines is established,
;           one per OSINT function, named accordingly.  Each interface
;           routine ...
;
;           (a) saves all compiler registers in global variables
;               accessible by C functions
;           (b) calls the OSINT function written in C
;           (c) restores all compiler registers from the global variables
;           (d) inspects the OSINT function's return value to determine
;               which of the n+1 returns should be taken and does so
;
;       (3) A set of C language OSINT functions is established, one per
;           OSINT function, named differently than the interface routines.
;           Each OSINT function can access compiler registers via global
;           variables.  NO arguments are passed via the call.
;
;           When an OSINT function returns, it must return a value indicating
;           which of the n+1 exits should be taken.  These return values are
;           defined in header file 'inter.h'.
;
;       Note:  in the actual implementation below, the saving and restoring
;       of registers is actually done in one common routine accessed by all
;       interface routines.
;
;       Other notes:
;
;       Some C ompilers transform "internal" global names to
;       "external" global names by adding a leading underscore at the front
;       of the internal name.  Thus, the function name 'osopen' becomes
;       '_osopen'.  However, not all C compilers follow this convention.
;
;
;       Global Variables
;
        CSeg_
	extern	swcoup
        CSegEnd_

        DSeg_
	global	nlines
nlines:	dd   	0
	extern	stacksiz
	extern	lmodstk
	extern	lowsp
	extern	outptr
	extern	calltab
%if direct = 0
        extern     valtab
%endif

        %include "nextrn386.inc"


; Words saved during exit(-3)
;
        align 4
;;	global	reg_block
;;	global	reg_wa
;;	global	reg_wb
;;	global	reg_ia
;;	global	reg_wc
;;	global	reg_xr
;;	global	reg_xl
;;	global	reg_cp
;;	global	reg_ra
;;reg_block:
;;reg_wa:	dd	0	; register WA (ECX)
;;reg_wb:	dd	0	; register WB (EBC)	
;;reg_ia:
;;reg_wc:	dd	0	; register WC&IA (EDX)
;;reg_xr:	dd	0	; register XR (EDI)
;;reg_xl:	dd	0	; register XL (EDI)
;;reg_cp:	dd	0	; register CP
;;reg_ra:	dq	0e	; register RA
;;;
;;; These locations save information needed to return after calling OSINT
;;; and after a restart from EXIT()
;;;
	extern	reg_pc
	extern	reg_pp
;;reg_pc:        dd   ,0  ; Return PC from ccaller
;;reg_pp: dd      0               ; Number of bytes of PPMs
;;	global	reg_xs
;;reg_xs:	dd   0  ; Minimal stack pointer
;;;
;;%define r_size         $-reg_block
;;	gloal	reg_size
;;reg_size	dd	r_size
;
; end of words saved during exit(-3)
;

;
;  Constants
;
;;ten:    dd      10              ; constant 10
;;        pubdef  inf,dd   ,0
;;        dd      0x7ff00000      ; double precision infinity
;;
;;sav_block	times rsize dd 0 ; Save Minimal registers during push/pop reg
;;;
;;        align 4
;;ppoff:  dd      0               ; offset for ppm exits
;;	
;;	global	compsp
;;	global	osisp
;;compsp: dd      0               ; 1.39 compiler's stack pointer
;;sav_compsp:
;;        dd      0               ; save compsp here
;;osisp:  dd      0               ; 1.39 OSINT's stack pointer
;;
;;



%define KEEP
        segment	.data

        align         4
ten:	dd	10
	global	hasfpu
hasfpu:	dd	0
	global	cprtmsg
cprtmsg: db " Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer."

	segment	.text

%ifdef SKIP
; next is end of SKIP DS
%endif
;
;-----------
;
;       restart - restart for load module
;
;       restart( char *dummy, char *stackbase ) - startup compiler
;
;       The OSINT main function calls restart when resuming execution
;       of a program from a load module.  The OSINT main function has
;       reset global variables except for the stack and any associated
;       variables.
;
;       Before restoring stack, set up values for proper checking of
;       stack overflow. (initial sp here will most likely differ
;       from initial sp when compile was done.)
;
;       It is also necessary to relocate any addresses in the the stack
;       that point within the stack itself.  An adjustment factor is
;       calculated as the difference between the STBAS at exit() time,
;       and STBAS at restart() time.  As the stack is transferred from
;       TSCBLK to the active stack, each word is inspected to see if it
;       points within the old stack boundaries.  If so, the adjustment
;       factor is subtracted from it.
;
;       We use Minimal's INSTA routine to initialize static variables
;       not saved in the Save file.  These values were not saved so as
;       to minimize the size of the Save file.
;
	extern	rereloc
	extern	compsp
	extern	ppoff

	global	restart
        cproc   restart

        pop     eax                     ; discard return
        pop     eax                     ; discard dummy
        pop     eax                     ; get lowest legal stack value

        add     eax,dword [stacksiz]            ; top of compiler's stack
        mov     esp,eax                 ; switch to this stack
	call	stackinit               ; initialize MINIMAL stack

                                        ; set up for stack relocation
        lea     eax,[TSCBLK+scstr]        ; top of saved stack
        mov     ebx,dword [lmodstk]             ; bottom of saved stack
        GETMIN  ecx,STBAS               ; ecx = stbas from exit() time
        sub     ebx,eax                 ; ebx = size of saved stack
	mov	edx,ecx
        sub     edx,ebx                 ; edx = stack bottom from exit() time
	mov	ebx,ecx
        sub     ebx,esp                 ; ebx = old stbas - new stbas

        SETMINR  STBAS,esp               ; save initial sp
        GETOFF  eax,DFFNC               ; get address of PPM offset
        mov     dword [ppoff],eax               ; save for use later
;
;       restore stack from TSCBLK.
;
        mov     esi,dword [lmodstk]             ; -> bottom word of stack in TSCBLK
        lea     edi,[TSCBLK+scstr]        ; -> top word of stack
        cmp     esi,edi                 ; Any stack to transfer?
        je      re3               ;  skip if not
	sub	esi,4
	std
re1:    lodsd                           ; get old stack word to eax
        cmp     eax,edx                 ; below old stack bottom?
        jb      re2               ;   j. if eax < edx
        cmp     eax,ecx                 ; above old stack top?
        ja      re2               ;   j. if eax > ecx
        sub     eax,ebx                 ; within old stack, perform relocation
re2:    push    eax                     ; transfer word of stack
        cmp     esi,edi                 ; if not at end of relocation then
        jae     re1                     ;    loop back

re3:	cld
        mov     dword [compsp],esp              ; 1.39 save compiler's stack pointer
        mov     esp,dword [osisp]               ; 1.39 back to OSINT's stack pointer
        callc   rereloc,0               ; V1.08 relocate compiler pointers into stack
        GETMIN  eax,STATB               ; V1.34 start of static region to XR
	SET_XR  eax
        MINIMAL INSTA                   ; V1.34 initialize static region

;
;       Now pretend that we're executing the following C statement from
;       function zysxi:
;
;               return  NORMAL_RETURN#
;
;       If the load module was invoked by EXIT(), the return path is
;       as follows:  back to ccaller, back to S$EXT following SYSXI call,
;       back to user program following EXIT() call.
;
;       Alternately, the user specified -w as a command line option, and
;       SYSBX called MAKEEXEC, which in turn called SYSXI.  The return path
;       should be:  back to ccaller, back to MAKEEXEC following SYSXI call,
;       back to SYSBX, back to MINIMAL code.  If we allowed this to happen,
;       then it would require that stacked return address to SYSBX still be
;       valid, which may not be true if some of the C programs have changed
;       size.  Instead, we clear the stack and execute the restart code that
;       simulates resumption just past the SYSBX call in the MINIMAL code.
;       We distinguish this case by noting the variable STAGE is 4.
;
	extern	startbrk
        callc   startbrk,0              ; start control-C logic

        GETMIN  eax,STAGE               ; is this a -w call?
	cmp	eax,4
        je      re4               	; yes, do a complete fudge

;
;       Jump back to cc1 with return value = NORMAL_RETURN
	mov	eax,-1
        jmp     cc1                     ; jump back

;       Here if -w produced load module.  simulate all the code that
;       would occur if we naively returned to sysbx.  Clear the stack and
;       go for it.
;
re4:	GETMIN	eax,STBAS
        mov     dword [compsp],eax              ; 1.39 empty the stack

;       Code that would be executed if we had returned to makeexec:
;
	extern	zystm
        SETMIN  GBCNT,0                 ; reset garbage collect count
        callc   zystm,0                 ; Fetch execution time to reg_ia
        mov     eax,dword [reg_ia]              ; Set time into compiler
	SETMINR	TIMSX,eax

;       Code that would be executed if we returned to sysbx:
;
        push    outptr                  ; swcoup(outptr)
	callc	swcoup,4

;       Jump to Minimal code to restart a save file.

        MINIMAL RSTRT                   ; no return

;
;       CVD_ - convert by division
;       Input   IA (EDX) = number <=0 to convert
;       Output  IA / 10
;               WA (ECX) = remainder + '0'

	global	CVD_
CVD_:
        xchg    eax,edx         ; IA to EAX
        cdq                     ; sign extend
        idiv    dword [ten]   ; divide by 10. edx = remainder (negative)
        neg     edx             ; make remainder positive
        add     dl,0x30         ; convert remainder to ascii ('0')
        mov     ecx,edx         ; return remainder in WA
        xchg    edx,eax         ; return quotient in IA
	ret

;       DVI_ - divide IA (EDX) by long in EAX

        global  DVI_
DVI_:

        or      eax,eax         ; test for 0
        jz      setovr    	; jump if 0 divisor
        push    ebp             ; preserve CP
        xchg    ebp,eax         ; divisor to ebp
        xchg    eax,edx         ; dividend in eax
        cdq                     ; extend dividend
        idiv    ebp             ; perform division. eax=quotient, edx=remainder
        xchg    edx,eax         ; place quotient in edx (IA)
        pop     ebp             ; restore CP
        xor     eax,eax         ; clear overflow indicator
	ret

;       RMI_ - remainder of IA (EDX) divided by long in EAX

        global  RMI_
RMI_:
	or      eax,eax         ; test for 0
        jz      setovr    	; jump if 0 divisor
        push    ebp             ; preserve CP
        xchg    ebp,eax         ; divisor to ebp
        xchg    eax,edx         ; dividend in eax
        cdq                     ; extend dividend
        idiv    ebp             ; perform division. eax=quotient, edx=remainder
        pop     ebp             ; restore CP
        xor     eax,eax         ; clear overflow indicator
        ret                     ; return remainder in edx (IA)
setovr: mov     al,0x80         ; set overflow indicator
	dec	al
	ret

;    Calls to C

;       The calling convention of the various compilers:
;
;       Integer results returned in EAX.
;       Float results returned in ST0 for Intel.
;       See conditional switches fretst0 and
;       freteax in systype.ah for each compiler.
;
;       C function preserves EBP, EBX, ESI, EDI.

;       RTI_ - convert real in RA to integer in IA
;               returns C=0 if fit OK, C=1 if too large to convert
;
        global  RTI_
RTI_:

; 41E00000 00000000 = 2147483648.0
; 41E00000 00200000 = 2147483649.0
        mov     eax, dword [reg_ra+4]  ; RA msh
        btr     eax,31          ; take absolute value, sign bit to carry flag
        jc            RTI_2     ; jump if negative real
        cmp     eax,0x41E00000  ; test against 2147483648
        jae           RTI_1     ; jump if >= +2147483648
RTI_3:  push    ecx             ; protect against C routine usage.
        push    eax             ; push RA MSH
        push    dword [reg_ra]; push RA LSH
        callfar f_2_i,8         ; float to integer
        xchg    eax,edx         ; return integer in edx (IA)
        pop     ecx             ; restore ecx
        clc
	ret

; here to test negative number, made positive by the btr instruction
RTI_2:  cmp     eax,0x41E00000          ; test against 2147483649
        jb            RTI_0             ; definately smaller
        ja            RTI_1             ; definately larger
        cmp     word [reg_ra+2], 0x0020
        jae           RTI_1
RTI_0:  btc     eax,31                  ; make negative again
        jmp     RTI_3
RTI_1:  stc                             ; return C=1 for too large to convert
        ret

;       ITR_ - convert integer in IA to real in RA

        global  ITR_
ITR_:
        push    ecx             ; preserve
        push    edx             ; push IA
        callfar i_2_f,4         ; integer to float
%if fretst0 
	fstp	qword [reg_ra]
        pop     ecx             ; restore ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra],eax    ; return result in RA
	mov	dword [reg_ra+4],edx
        pop     ecx             ; restore ecx
%endif
	ret

;       LDR_ - load real pointed to by eax to RA

        global  LDR_
LDR_:
        push    dword [eax]                  ; lsh
	pop	dword [reg_ra]
        mov     eax,[eax+4]                     ; msh
	mov	dword [reg_ra+4], eax
	ret
;
;       STR_ - store RA in real pointed to by eax

        global  STR_
STR_:
        push    dword [reg_ra]               ; lsh
	pop	dword [eax]
        push    dword [reg_ra+4]             ; msh
	pop	dword [eax+4]
	ret

;       ADR_ - add real at [eax] to RA

        global  ADR_
ADR_:
        push    ecx                             ; preserve regs for C
	push	edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]               ; RA lsh
        push    dword [eax+4]               ; arg msh
        push    dword [eax]                 ; arg lsh
        callfar f_add,16                        ; perform op
%if fretst0
	fstp	qword [reg_ra]
        pop     edx                             ; restore regs
	pop	ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra+4],edx         ; result msh
        mov     dword [reg_ra],eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret

;
;
;       SBR_ - subtract real at [eax] from RA
;
        global  SBR_
SBR_:
        push    ecx                             ; preserve regs for C
	push	edx
        push    dword [reg_ra+4]             ; RA msh
        push    dword [reg_ra]               ; RA lsh
        push    dword [eax+4]               ; arg msh
        push    dword [eax]                 ; arg lsh
        callfar f_sub,16                        ; perform op
%if fretst0
	fstp	qword [reg_ra]
        pop     edx                             ; restore regs
	pop	ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra+4],edx         ; result msh
        mov     dword [reg_ra],eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret

;       MLR_ - multiply real in RA by real at [eax]

        global  MLR_
MLR_:
        push    ecx            		; preserve regs for C
	push	edx
        push    dword [reg_ra+4]        ; RA msh
        push    dword [reg_ra]         	; RA lsh
        push    dword [eax+4]                ; arg msh
        push    dword [eax]                  ; arg lsh
        callfar f_mul,16                     ; perform op
%if fretst0
	fstp	qword [reg_ra]
        pop     edx                             ; restore regs
	pop	ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra+4],edx         ; result msh
        mov     dword [reg_ra],eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret


;       DVR_ - divide real in RA by real at [eax]

        global  DVR_
DVR_:
        push    ecx                             ; preserve regs for C
	push	edx
        push    dword [reg_ra+4]             ; RA msh
        push    dword [reg_ra]               ; RA lsh
        push    dword [eax+4]                ; arg msh
        push    dword [eax]                  ; arg lsh
        callfar f_div,16                        ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     edx                             ; restore regs
	pop	ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra+4],edx         ; result msh
        mov     dword [reg_ra],eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret

;       NGR_ - negate real in RA

        global  NGR_
NGR_:
	cmp	dword [reg_ra], 0
	jne	ngr_1
	cmp	dword [reg_ra+4], 0
        je      ngr_2	                     ; if zero, leave alone
ngr_1:  xor     byte [reg_ra+7], 0x80         ; complement mantissa sign
ngr_2:	ret

;       ATN_ arctangent of real in RA

        global  ATN_
ATN_:
        push    ecx                             ; preserve regs for C
	push	edx
        push    dword [reg_ra+4]             ; RA msh
        push    dword [reg_ra]               ; RA lsh
        callfar f_atn,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     edx                             ; restore regs
	pop	ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra+4],edx         ; result msh
        mov     dword [reg_ra],eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret

;

;       CHP_ chop fractional part of real in RA

        global  CHP_
CHP_:
        push    ecx                             ; preserve regs for C
	push	edx
        push    dword [reg_ra+4]             ; RA msh
        push    dword [reg_ra]               ; RA lsh
        callfar f_chp,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     edx                             ; restore regs
	pop	ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra+4, edx         ; result msh
        mov     dword [reg_ra, eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret


;       COS_ cosine of real in RA

        global  COS_
COS_:
        push    ecx                             ; preserve regs for C
	push	edx
        push    dword [reg_ra+4]             ; RA msh
        push    dword [reg_ra]               ; RA lsh
        callfar f_cos,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     edx                             ; restore regs
	pop	ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra+4],edx         ; result msh
        mov     dword [reg_ra],eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret

;       ETX_ exponential of real in RA
        global  ETX_
ETX_:
        push    ecx                             ; preserve regs for C
	push	edx
        push    dword [reg_ra+4]             ; RA msh
        push    dword [reg_ra]               ; RA lsh
        callfar f_etx,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     edx                             ; restore regs
	pop	ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret

;       LNF_ natural logarithm of real in RA

        global  LNF_
LNF_:

        push    ecx                             ; preserve regs for C
	push	edx
        push    dword [reg_ra+4]             ; RA msh
        push    dword [reg_ra]               ; RA lsh
        callfar f_lnf,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     edx                             ; restore regs
	pop	ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret

;
;       SIN_ arctangent of real in RA
;
        global  SIN_

SIN_:
        push    ecx                             ; preserve regs for C
	push	edx
        push    dword [reg_ra+4]             ; RA msh
        push    dword [reg_ra]               ; RA lsh
        callfar f_sin,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     edx                             ; restore regs
	pop	ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra,] eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret

;
;       SQR_ arctangent of real in RA
;
        global  SQR_
SQR_:        
        push    ecx                          ; preserve regs for C
	push	edx
        push    dword [reg_ra+4]             ; RA msh
        push    dword [reg_ra]                ; RA lsh
        callfar f_sqr,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     edx                             ; restore regs
	pop	ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret



;#       TAN_ arctangent of real in RA

        global  TAN_

TAN_:

        push    ecx                             ; preserve regs for C
	push	edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
        callfar f_tan,8                       ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     edx                             ; restore regs
	pop	ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [ reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret


;       CPR_ compare real in RA to 0

        global  CPR_

CPR_:
        mov     eax, dword [reg_ra+4] ; fetch msh
        cmp     eax, 0x80000000         ; test msh for -0.0
        je       cpr050            ; possibly
        or      eax, eax                ; test msh for +0.0
        jnz      cpr100            ; exit if non-zero for cc's set
cpr050: cmp     dword [reg_ra], 0     ; true zero, or denormalized number?
        jz       cpr100            ; exit if true zero
	mov	al, 1
        cmp     al, 0                   ; positive denormal, set cc
cpr100:	ret

;       OVR_ test for overflow value in RA

        global  OVR_

OVR_:

        mov     ax, word [reg_ra+6]   ; get top 2 bytes
        and     ax, 0x7ff0              ; check for infinity or nan
        add     ax, 0x10                ; set/clear overflow accordingly
	ret


;  tryfpu - perform a floating point op to trigger a trap if no floating point hardware.
	global		tryfpu
tryfpu:

	push	ebp
	fldz
	pop	ebp
	ret

;
;-----------
;
;       get_fp  - get C caller's FP (frame pointer)
;
;       get_fp() returns the frame pointer for the C function that called
;       this function.  HOWEVER, THIS FUNCTION IS ONLY CALLED BY ZYSXI.
;
;       C function zysxi calls this function to determine the lowest USEFUL
;       word on the stack, so that only the useful part of the stack will be
;       saved in the load module.
;
;       The flow goes like this:
;
;       (1) User's spitbol program calls EXIT function
;
;       (2) spitbol compiler calls interface routine sysxi to handle exit
;
;       (3) Interface routine sysxi passes control to ccaller which then
;           calls C function zysxi
;
;       (4) C function zysxi will write a load module, but needs to save
;           a copy of the current stack in the load module.  The base of
;           the part of the stack to be saved begins with the frame of our
;           caller, so that the load module can execute a return to ccaller.
;
;           This will allow the load module to pretend to be returning from
;           C function zysxi.  So, C function zysxi calls this function,
;           get_fp, to determine the BASE OF THE USEFUL PART OF THE STACK.
;
;           We cheat just a little bit here.  C function zysxi can (and does)
;           have local variables, but we won't save them in the load module.
;           Only the portion of the frame established by the 80386 call
;           instruction, from BP up, is saved.  These local variables
;           aren't needed, because the load module will not be going back
;           to C function zysxi.  Instead when function restart returns, it
;           will act as if C function zysxi is returning.
;
;       (5) After writing the load module, C function zysxi calls C function
;           zysej to terminate spitbol's execution.
;
;       (6) When the resulting load module is executed, C function main
;           calls function restart.  Function restart restores the stack
;           and then does a return.  This return will act as if it is
;           C function zysxi doing the return and the user's program will
;           continue execution following its call to EXIT.
;
;       On entry to _get_fp, the stack looks like
;
;               /      ...      /
;       (high)  |               |
;               |---------------|
;       ZYSXI   |    old PC     |  --> return point in CCALLER
;         +     |---------------|  USEFUL part of stack
;       frame   |    old BP     |  <<<<-- BP of get_fp's caller
;               |---------------|     -
;               |     ZYSXI's   |     -
;               /     locals    /     - NON-USEFUL part of stack
;               |               |     ------
;       ======= |---------------|
;       SP-->   |    old PC     |  --> return PC in C function ZYSXI
;       (low)   +---------------+
;
;       On exit, return EBP in EAX. This is the lower limit on the
;       size of the stack.


	global	get_fp
get_fp:

        mov     eax,dword [reg_xs]      ; Minimal's XS
        add     eax,4           ; pop return from call to SYSBX or SYSXI
        ret                     ; done

;
;-----------
;
;       mimimal -- call MINIMAL function from C
;
;       Usage:  extern void minimal(WORD callno)
;
;       where:
;         callno is an ordinal defined in osint.h, osint.inc, and calltab.
;
;       Minimal registers WA, WB, WC, XR, and XL are loaded and
;       saved from/to the register block.
;
;       Note that before restart is called, we do not yet have compiler
;       stack to switch to.  In that case, just make the call on the
;       the OSINT stack.
;

	global	minimal
minimal:


        pushad                          ; save all registers for C
        mov     eax, dword [esp+32+4]          ; get ordinal
        mov     ecx, dword [reg_wa]              ; restore registers
	mov	ebx, dword [reg_wb]
        mov     edx, dword [reg_wc ]             ; (also _reg_ia)
	mov	edi, dword [reg_xr]
	mov	esi, dword [reg_xl]
	mov	ebp, dword [reg_cp]

        mov     dword [osisp],esp               ; 1.39 save OSINT stack pointer
        cmp     dword [compsp],0      ; 1.39 is there a compiler stack?
        je      min1              ; 1.39 jump if none yet
        mov     esp,dword [compsp]              ; 1.39 switch to compiler stack

min1:   call   dword [calltab+eax*4]          ; off to the Minimal code

        mov     esp,dword [osisp]               ; 1.39 switch to OSINT stack

        mov     dword [reg_wa],ecx              ; save registers
	mov	dword [reg_wb],ebx
	mov	dword [reg_wc],edx
	mov	dword [reg_xr],edi
	mov	dword [reg_xl],esi
	mov	dword [reg_cp],ebp
	popad
	ret



%if direct = 0
;
;-----------
;
;       minoff -- obtain address of MINIMAL variable
;
;       Usage:  extern WORD *minoff(WORD valno)
;
;       where:
;         valno is an ordinal defined in osint.h, osint.inc and valtab.
;

        proc    minoff,near
	pubname	minoff

	global	minoff
minoff:
        mov     eax,dword [esp+4]             ; get ordinal
        mov     eax,dword [valtab+eax*4]       ; get address of Minimal value
	ret

%endif


;
;-----------
;
;	stackinit  -- initialize LOWSPMIN from sp.
;
;	Input:  sp - current C stack
;		stacksiz - size of desired Minimal stack in bytes
;
;	Uses:	eax
;
;	Output: register WA, sp, LOWSPMIN, compsp, osisp set up per diagram:
;
;	(high)	+----------------+
;		|  old C stack   |
;	  	|----------------| <-- incoming sp, resultant WA (future XS)
;		|	     ^	 |
;		|	     |	 |
;		/ stacksiz bytes /
;		|	     |	 |
;		|            |	 |
;		|----------- | --| <-- resultant LOWSPMIN
;		| 400 bytes  v   |
;	  	|----------------| <-- future C stack pointer, osisp
;		|  new C stack	 |
;	(low)	|                |
;
;
;
	global	stackinit
stackinit:

	mov	eax,esp
        mov     dword [compsp],eax              ; save as MINIMAL's stack pointer
	sub	eax,dword [stacksiz]            ; end of MINIMAL stack is where C stack will start
        mov     dword [osisp],eax               ; save new C stack pointer
	add	eax,4*100               ; 100 words smaller for CHK
	mov	dword [LOWSPMIN],eax	; set LOWSPMIN
	ret



;
;-----------
;
;       startup( char *dummy1, char *dummy2) - startup compiler
;
;       An OSINT C function calls startup to transfer control
;       to the compiler.
;
;       (XR) = basemem
;       (XL) = topmem - sizeof(WORD)
;
;	Note: This function never returns.


	global	startup
startup:
        pop     eax                     ; discard return
        pop     eax                     ; discard dummy1
        pop     eax                     ; discard dummy2
	call	stackinit               ; initialize MINIMAL stack
        mov     eax,dword [compsp]              ; get MINIMAL's stack pointer
	mov	dword [reg_wa],eax
;        SET_WA  eax                     ; startup stack pointer

	cld                             ; default to UP direction for string ops
	lea	eax, [DFFNC]
;        GETOFF  eax,DFFNC               ; get address of PPM offset
        mov     dword [ppoff],eax               ; save for use later
        mov     esp,dword [osisp]               ; switch to new C stack
;        MINIMAL START                   # load regs, switch stack, start compiler
        push START
        callc minimal,4

;
;-----------
;
;       Interface routines
;
;       Each interface routine takes the following form:
;
;               SYSXX   call    ccaller         # call common interface
;                       dd      zysxx           # address of C OSINT function
;                       db      n               # offset to instruction after
;                                               #   last procedure exit
;
;       In an effort to achieve portability of C OSINT functions, we
;       do not take take advantage of any "internal" to "external"
;       transformation of names by C compilers.  So, a C OSINT function
;       representing sysxx is named _zysxx.  This renaming should satisfy
;       all C compilers.
;
;       IMPORTANT  ONE interface routine, SYSFC, is passed arguments on
;       the stack.  These items are removed from the stack before calling
;       ccaller, as they are not needed by this implementation.
;
;
;-----------
;
;       CCALLER is called by the OS interface routines to call the
;       real C OS interface function.
;
;       General calling sequence is
;
;               call    ccaller
;               dd      address_of_C_function
;               db      2*number_of_exit_points
;
;       Control IS NEVER returned to a interface routine.  Instead, control
;       is returned to the compiler (THE caller of the interface routine).
;
;       The C function that is called MUST ALWAYS return an integer
;       indicating the procedure exit to take or that a normal return
;       is to be performed.
;
;               C function      Interpretation
;               return value
;               ------------    -------------------------------------------
;                    <0         Do normal return to instruction past
;                               last procedure exit (distance passed
;                               in by dummy routine and saved on stack)
;                     0         Take procedure exit 1
;                     4         Take procedure exit 2
;                     8         Take procedure exit 3
;                    ...        ...
;
        proc   ccaller,near

;       (1) Save registers in global variables
;
        mov     dword [reg_wa],ecx              ; save registers
	mov	dword [reg_wb],ebx
        mov     dword [reg_wc],edx              ; (also _reg_ia)
	mov	dword [reg_xr],edi
	mov	dword [reg_xl],esi
        mov     dword [reg_cp],ebp              ; Needed in image saved by sysxi

;       (2) Get pointer to arg list
;
        pop     esi                     ; point to arg list
;
;       (3) Fetch address of C function, fetch offset to 1st instruction
;           past last procedure exit, and call C function.
;
        cs                              ; CS segment override
        lodsd                           ; point to C function entry point
;       lodsd   cs:ccaller              # point to C function entry point
        movzx   ebx,byte [esi]   ; save normal exit adjustment
;
        mov     dword [reg_pp],ebx              ; in memory
        pop     dword [reg_pc]                  ; save return PC past "CALL SYSXX"
;
;       (3a) Save compiler stack and switch to OSINT stack
;
        mov     dword [compsp],esp              ; 1.39 save compiler's stack pointer
        mov     esp,dword [osisp]               ; 1.39 load OSINT's stack pointer
;
;       (3b) Make call to OSINT
;
        call    eax                     ; call C interface function
;
;       (4) Restore registers after C function returns.
;
cc1:    mov     dword [osisp],esp               ; 1.39 save OSINT's stack pointer
        mov     esp,dword [compsp]              ; 1.39 restore compiler's stack pointer
        mov     ecx, dword [reg_wa]              ; restore registers
	mov	ebx, dword [reg_wb]
        mov     edx, dword [reg_wc ]             ; (also reg_ia)
	mov	edi, dword [reg_xr]
	mov	esi, dword [reg_xl]
	mov	ebp, dword [reg_cp]

	cld
;
;       (5) Based on returned value from C function (in EAX) either do a normal
;           return or take a procedure exit.
;
        or      eax,eax         ; test if normal return ...
        jns     erexit    ; j. if >= 0 (take numbered exit)
	mov	eax,dword [reg_pc]
        add     eax,dword [reg_pp]      ; point to instruction following exits
        jmp     eax             ; bypass PPM exits

;                               # else (take procedure exit n)
erexit: shr     eax,1           ; divide by 2
        add     eax,dword [reg_pc]      ;   get to address of exit offset
	movsx	eax,word [eax]
        add     eax,dword [ppoff]       ; bias to fit in 16-bit word
	push	eax
        xor     eax,eax         ; in case branch to error cascade
        ret                     ;   take procedure exit via PPM address


;       Individual OSINT routine entry points

        global SYSAX
	extern	zysax
SYSAX:	call	ccaller
        dd        zysax
        db     0
;
        global SYSBS
	extern	zysbs
SYSBS:	call	ccaller
        dd        zysbs
        db     3*2
;
        global SYSBX
	extern	zysbx
SYSBX:	mov	dword [reg_xs],esp
	call	ccaller
        dd      zysbx
        db     0
;
;%if SETREAL = 1
;        global SYSCR
;	extern	zyscr
;SYSCR:  call    ccaller
;        dd      zyscr
;        db     0
;;
;%endif
        global SYSDC
	extern	zysdc
SYSDC:	call	ccaller
        dd      zysdc
        db     0
;
        global SYSDM
	extern	zysdm
SYSDM:	call	ccaller
        dd      zysdm
        db     0
;
        global SYSDT
	extern	zysdt
SYSDT:	call	ccaller
        dd      zysdt
        db     0
;
        global SYSEA
	extern	zysea
SYSEA:	call	ccaller
        dd      zysea
        db     1*2
;
        global SYSEF
	extern	zysef
SYSEF:	call	ccaller
        dd      zysef
        db     3*2
;
        global SYSEJ
	extern	zysej
SYSEJ:	call	ccaller
        dd      zysej
        db     0
;
        global SYSEM
	extern	zysem
SYSEM:	call	ccaller
        dd      zysem
        db     0
;
        global SYSEN
	extern	zysen
SYSEN:	call	ccaller
        dd      zysen
        db     3*2
;
        global SYSEP
	extern	zysep
SYSEP:	call	ccaller
        dd      zysep
        db     0
;
        global SYSEX
	extern	zysex
SYSEX:	mov	dword [reg_xs],esp
	call	ccaller
        dd      zysex
        db     3*2
;
        global SYSFC
	extern	zysfc
SYSFC:  pop     eax             ; <<<<remove stacked SCBLK>>>>
	lea	esp,[esp+edx*4]
	push	eax
	call	ccaller
        dd      zysfc
        db     2*2
;
        global SYSGC
	extern	zysgc
SYSGC:	call	ccaller
        dd      zysgc
        db     0
;
        global SYSHS
	extern	zyshs
SYSHS:	mov	dword [reg_xs],esp
	call	ccaller
        dd      zyshs
        db     8*2
;
        global SYSID
	extern	zysid
SYSID:	call	ccaller
        dd      zysid
        db     0
;
        global SYSIF
	extern	zysif
SYSIF:	call	ccaller
        dd      zysif
        db     1*2
;
        global SYSIL
	extern	zysil
SYSIL:  call    ccaller
        dd      zysil
        db     0
;
        global SYSIN
	extern	zysin
SYSIN:	call	ccaller
        dd      zysin
        db     3*2
;
        global SYSIO
	extern	zysio
SYSIO:	call	ccaller
        dd      zysio
        db     2*2
;
        global SYSLD
	extern	zysld
SYSLD:  call    ccaller
        dd      zysld
        db     3*2
;
        global SYSMM
	extern	zysmm
SYSMM:	call	ccaller
        dd      zysmm
        db     0
;
        global SYSMX
	extern	zysmx
SYSMX:	call	ccaller
        dd      zysmx
        db     0
;
        global SYSOU
	extern	zysou
SYSOU:	call	ccaller
        dd      zysou
        db     2*2
;
        global SYSPI
	extern	zyspi
SYSPI:	call	ccaller
        dd      zyspi
        db     1*2
;
        global SYSPL
	extern	zyspl
SYSPL:	call	ccaller
        dd      zyspl
        db     3*2
;
        global SYSPP
	extern	zyspp
SYSPP:	call	ccaller
        dd      zyspp
        db     0
;
        global SYSPR
	extern	zyspr
SYSPR:	call	ccaller
        dd      zyspr
        db     1*2
;
        global SYSRD
	extern	zysrd
SYSRD:	call	ccaller
        dd      zysrd
        db     1*2
;
        global SYSRI
	extern	zysri
SYSRI:	call	ccaller
        dd      zysri
        db     1*2
;
        global SYSRW
	extern	zysrw
SYSRW:	call	ccaller
        dd      zysrw
        db     3*2
;
        global SYSST
	extern	zysst
SYSST:	call	ccaller
        dd      zysst
        db     5*2
;
        global SYSTM
	extern	zystm
SYSTM:	call	ccaller
systm_p: dd      zystm
        db     0
;
        global SYSTT
	extern	zystt
SYSTT:	call	ccaller
        dd      zystt
        db     0
;
        global SYSUL
	extern	zysul
SYSUL:	call	ccaller
        dd      zysul
        db     0
;
        global SYSXI
	extern	zysxi
SYSXI:	mov	dword [reg_xs],esp
	call	ccaller
sysxi_p: dd      zysxi
        db     2*2


