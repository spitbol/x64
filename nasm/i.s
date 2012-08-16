
%define	globals	1

	%include	"systype.ah"
	%include	"osint.inc"



	segment	.data
	extern	swcoup

	extern	stacksiz
	extern	lmodstk
	extern	lowsp
	extern	outptr
	extern	calltab
%if direct == 0
        extern     valtab
%endif

        %include "extrn386.inc"


        align 4

	global	reg_wa
	global	reg_wb
	global	reg_ia
	global	reg_wc
	global	reg_xr
	global	reg_xl
	global	reg_cp
	global	reg_ra
	global	reg_pc
	global	reg_pp
	global	reg_xs

	global	reg_block
	global	reg_size
reg_block:
reg_wa:	dd	0     ; Register WA (ECX)
reg_wb:	dd	0     ; Register WB (EBX)
reg_ia:
reg_wc:	dd   0     ; Register WC & IA (EDX)
reg_xr:	dd   0     ; Register XR (EDI)
reg_xl:	dd   0     ; Register XL (ESI)
reg_cp:	dd   0     ; Register CP
reg_ra:	dd	0e  ; Register RA
reg_pc:	dd	0		; return pc from caller
reg_pp: dd      0               ; Number of bytes of PPMs
reg_xs:	dd   	0  		; Minimal stack pointer
r_size equ      $-reg_block
reg_size	dd	r_size

ten:    dd      10              ; constant 10
	global	inf
inf:	dd	0	
        dd      0x7ff00000      ; double precision infinity

sav_block: times r_size dd 0    ; Save Minimal registers during push/pop reg
        align 4
ppoff:  dd      0               ; offset for ppm exits
compsp: dd      0               ; 1.39 compiler's stack pointer
sav_compsp:
        dd      0               ; save compsp here
osisp:  dd      0               ; 1.39 OSINT's stack pointer


	global	ID1
ID1	dd	0
%ifdef SETREAL
        dd       2
        db  "1x\x00\x00"
%else
        dd       1
        db  "1x\x00\x00\x00"
%endif
	global	ID2BLK
ID2BLK:	times	52 dd 0
	global	TSCBLK

	global	TICBLK
TICBLK:	dd	0
        dd      0

	global	TSCBLK
TSCBLK:	times	512 dd 0

	global	INPBUF
INPBUF:	dd   	0     ; type word
        dd      0               ; block length
        dd      1024            ; buffer size
        dd      0               ; remaining chars to read
        dd      0               ; offset to next character to read
        dd      0               ; file position of buffer
        dd      0               ; physical position in file
%if winnt
        dd      0               ; 64-bit offset
        dd      0               ; and current position
%endif
	times	1024 dd 0	; buffer
	global	TTYBUF
TTYBUF:	dd   0     ; type word
        dd      0               ; block length
        dd      260             ; buffer size  (260 OK in MS-DOS with cinread())
        dd      0               ; remaining chars to read
        dd      0               ; offset to next char to read
        dd      0               ; file position of buffer
        dd      0               ; physical position in file
%if winnt 
        dd      0               ; 64-bit offset
        dd      0               ; and current position
%endif
	times	260 dd 0	; buffer


	segment	.text
        					;bashes eax,ecx,esi
pushregs:
	pushad
	lea	edi,[sav_block]
	mov	ecx,r_size/4
	cld
   rep	movsd

        mov     edi,compsp
        or      edi,edi                         ; 1.39 is there a compiler stack
        je      push1                     ; 1.39 jump if none yet
        sub     edi,4                           ;push onto compiler's stack
        mov     esi,reg_xl                      ;collectable XL
	mov	[edi],esi
        mov     [compsp],edi                      ;smashed if call OSINT again (SYSGC)
        mov     [sav_compsp],edi                  ;used by popregs

push1:	popad
	retc	0

popregs:
	pushad
        mov     eax,[reg_cp]                      ;don't restore CP
	cld
	lea	esi,[sav_block]
        lea     edi,[reg_block]                   ;unload saved registers
	mov	ecx,r_size/4
   rep  movsd                                   ;restore from temp area
	mov	[reg_cp],eax

        mov     edi,[sav_compsp]                  ;saved compiler's stack
        or      edi,edi                         ;1.39 is there one?
        je      pop1                      ;1.39 jump if none yet
        mov     esi,[edi]                       ;retrieve collectable XL
        mov     dword [reg_xl],esi                      ;update XL
        add     edi,4                           ;update compiler's sp
        mov     [compsp],edi

pop1:	popad
	retc	0

ccaller:

        mov     [reg_wa],ecx              ; save registers
	mov	[reg_wb],ebx
        mov     [reg_wc],edx              ; (also _reg_ia)
	mov	[reg_xr],edi
	mov	[reg_xl],esi
        mov     [reg_cp],ebp              ; Needed in image saved by sysxi

        pop     esi                     ; point to arg list
        cs                              ; CS segment override
        lodsd                           ; point to C function entry point
        movzx   ebx,byte [esi]   ; save normal exit adjustment
        mov     dword [reg_pp],ebx              ; in memory
        pop     dword [reg_pc]                  ; save return PC past "CALL SYSXX"
        mov     dword [compsp],esp              ; 1.39 save compiler's stack pointer
        mov     esp,[osisp]               ; 1.39 load OSINT's stack pointer
        call    eax                     ; call C interface function

cc1:    mov     [osisp], esp               ; 1.39 save OSINT's stack pointer
        mov     esp, dword [compsp]              ; 1.39 restore compiler's stack pointer
        mov     ecx, dword [reg_wa]              ; restore registers
	mov	ebx, dword [reg_wb]
        mov     edx, dword [reg_wc]             ; (also reg_ia)
	mov	edi, dword [reg_xr]
	mov	esi, dword [reg_xl]
	mov	ebp, dword [reg_cp]

	cld
        or      eax,eax         ; test if normal return ...
        jns     erexit    ; j. if >= 0 (take numbered exit)
	mov	eax,dword [reg_pc]
        add     eax,dword [reg_pp]      ; point to instruction following exits
        jmp     eax             ; bypass PPM exits

erexit: shr     eax,1           ; divide by 2
        add     eax,dword [reg_pc]      ;   get to dd of exit offset
	movsx	eax,word [eax]
        add     eax,ppoff       ; bias to fit in 16-bit word
	push	eax
        xor     eax,eax         ; in case branch to error cascade
        ret                     ;   take procedure exit via PPM dd

	global	SYSAX
	extern	zysax
SYSAX:	call	ccaller
        dd   zysax
        db      0
	global	SYSBS
	extern	zysbs
SYSBS:	call	ccaller
        dd   zysbs
        db      3*2
        global	 SYSBX
	extern	zysbx
SYSBX:	mov	[reg_xs],esp
	call	ccaller
        dd zysbx
        db      0
%ifdef SETREAL
        global SYSCR
	extern	zyscr
SYSCR:  call    ccaller
        dd zyscr
        db      0
%endif
        global SYSDC
	extern	zysdc
SYSDC:	call	ccaller
        dd zysdc
        db      0
        global SYSDM
	extern	zysdm
SYSDM:	call	ccaller
        dd zysdm
        db      0
        global SYSDT
	extern	zysdt
SYSDT:	call	ccaller
        dd zysdt
        db      0
        global SYSEA
	extern	zysea
SYSEA:	call	ccaller
        dd zysea
        db      1*2
        global SYSEF
	extern	zysef
SYSEF:	call	ccaller
        dd zysef
        db      3*2
        global SYSEJ
	extern	zysej
SYSEJ:	call	ccaller
        dd zysej
        db      0
        global SYSEM
	extern	zysem
SYSEM:	call	ccaller
        dd zysem
        db      0
        global SYSEN
	extern	zysen
SYSEN:	call	ccaller
        dd zysen
        db      3*2
        global SYSEP
	extern	zysep
SYSEP:	call	ccaller
        dd zysep
        db      0
        global SYSEX
	extern	zysex
SYSEX:	mov	[reg_xs],esp
	call	ccaller
        dd zysex
        db      3*2
        global SYSFC
	extern	zysfc
SYSFC:  pop     eax             ; <<<<remove stacked SCBLK>>>>
	lea	esp,[esp+edx*4]
	push	eax
	call	ccaller
        dd zysfc
        db      2*2
        global SYSGC
	extern	zysgc
SYSGC:	call	ccaller
        dd zysgc
        db      0
        global SYSHS
	extern	zyshs
SYSHS:	mov	[reg_xs],esp
	call	ccaller
        dd zyshs
        db      8*2
        global SYSID
	extern	zysid
SYSID:	call	ccaller
        dd zysid
        db      0
        global SYSIF
	extern	zysif
SYSIF:	call	ccaller
        dd zysif
        db      1*2
        global SYSIL
	extern	zysil
SYSIL:  call    ccaller
        dd zysil
        db      0
        global SYSIN
	extern	zysin
SYSIN:	call	ccaller
        dd zysin
        db      3*2
        global SYSIO
	extern	zysio
SYSIO:	call	ccaller
        dd zysio
        db      2*2
        global SYSLD
	extern	zysld
SYSLD:  call    ccaller
        dd zysld
        db      3*2
        global SYSMM
	extern	zysmm
SYSMM:	call	ccaller
        dd zysmm
        db      0
        global SYSMX
	extern	zysmx
SYSMX:	call	ccaller
        dd zysmx
        db      0
        global SYSOU
	extern	zysou
SYSOU:	call	ccaller
        dd zysou
        db      2*2
        global SYSPI
	extern	zyspi
SYSPI:	call	ccaller
        dd zyspi
        db      1*2
        global SYSPL
	extern	zyspl
SYSPL:	call	ccaller
        dd zyspl
        db      3*2
        global SYSPP
	extern	zyspp
SYSPP:	call	ccaller
        dd zyspp
        db      0
        global SYSPR
	extern	zyspr
SYSPR:	call	ccaller
        dd zyspr
        db      1*2
        global SYSRD
	extern	zysrd
SYSRD:	call	ccaller
        dd zysrd
        db      1*2
        global SYSRI
	extern	zysri
SYSRI:	call	ccaller
        dd zysri
        db      1*2
        global SYSRW
	extern	zysrw
SYSRW:	call	ccaller
        dd zysrw
        db      3*2
        global SYSST
	extern	zysst
SYSST:	call	ccaller
        dd zysst
        db      5*2
        global SYSTM
	extern	zystm
SYSTM:	call	ccaller
systm_p: dd zystm
        db      0
        global SYSTT
	extern	zystt
SYSTT:	call	ccaller
        dd zystt
        db      0
        global SYSUL
	extern	zysul
SYSUL:	call	ccaller
        dd zysul
        db      0
        global SYSXI
	extern	zysxi
SYSXI:	mov	[reg_xs],esp
	call	ccaller
sysxi_p: dd zysxi
        db      2*2


	
	global	startup
startup:

        pop     eax                     ; discard return
        pop     eax                     ; discard dummy1
        pop     eax                     ; discard dummy2
	call	stackinit               ; initialize MINIMAL stack
        mov     eax,compsp              ; get MINIMAL's stack pointer
        mov	dword [reg_wa],eax                     ; startup stack pointer

	cld                             ; default to UP direction for string ops
	extern	DFFNC
        GETOFF  eax,[DFFNC]               ; get dd of PPM offset
        mov     dword [ppoff],eax               ; save for use later
        mov     esp,dword [osisp]               ; switch to new C stack
        MINIMAL START                   ; load regs, switch stack, start compiler



	global	stackinit
stackinit:
	mov	eax,esp
        mov     dword [compsp],eax              ; save as MINIMAL's stack pointer
	sub	eax,dword [stacksiz]     ; end of MINIMAL stack is where C stack will start
        mov     dword [osisp],eax       ; save new C stack pointer
	add	eax,4*100               ; 100 words smaller for CHK
	extern	LOWSPMIN
        SETMINR  [LOWSPMIN],eax           ; Set LOWSPMIN
	ret


	global	minimal
minimal:

        pushad                          ; save all registers for C
        mov     eax,dword[esp+32+4]          ; get ordinal
        mov     ecx,dword[reg_wa]              ; restore registers
	mov	ebx,dword[reg_wb]
        mov     edx,dword[reg_wc]              ; (also _reg_ia)
	mov	edi,dword[reg_xr]
	mov	esi,dword[reg_xl]
	mov	ebp,dword[reg_cp]

        mov     dword [osisp],esp               ; 1.39 save OSINT stack pointer
        cmp     dword [compsp],0      ; 1.39 is there a compiler stack?
        je      min1              ; 1.39 jump if none yet
        mov     esp,compsp              ; 1.39 switch to compiler stack

min1:   callc   [calltab+eax*4],0        ; off to the Minimal code

        mov     esp,osisp               ; 1.39 switch to OSINT stack

        mov     [reg_wa],ecx              ; save registers
	mov	[reg_wb],ebx
	mov	[reg_wc],edx
	mov	[reg_xr],edi
	mov	[reg_xl],esi
	mov	[reg_cp],ebp
	popad
	retc	4



%if direct = 0

	global 	minoff
minoff:

        mov     eax,[esp+4]             ; get ordinal
        mov     eax,[valtab+eax*4]       ; get dd of Minimal value
	retc	4

%endif




	global	get_fp
get_fp:

        mov     eax,[reg_xs]      ; Minimal's XS
        add     eax,4           ; pop return from call to SYSBX or SYSXI
        retc    0               ; done


	extern	rereloc

       global   restart
restart:
	global	restart

        pop     eax                     ; discard return
        pop     eax                     ; discard dummy
        pop     eax                     ; get lowest legal stack value

        add     eax,stacksiz            ; top of compiler's stack
        mov     esp,eax                 ; switch to this stack
	call	stackinit               ; initialize MINIMAL stack

                                        ; set up for stack relocation
        lea     eax,[TSCBLK+scstr]        ; top of saved stack
        mov     ebx,dword [lmodstk]             ; bottom of saved stack
        sub     ebx,eax                 ; ebx = size of saved stack
	mov	edx,ecx
        sub     edx,ebx                 ; edx = stack bottom from exit() time
	mov	ebx,ecx
        sub     ebx,esp                 ; ebx = old stbas - new stbas
	extern	STBAS
        SETMINR  dword [STBAS],esp               ; save initial sp
        GETOFF  eax,[DFFNC]               ; get dd of PPM offset
        mov     dword [ppoff],eax               ; save for use later
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
	mov	dword [reg_xr],  eax
        MINIMAL INSTA                   ; V1.34 initialize static region

	extern	startbrk
        callc   startbrk,0              ; start control-C logic
	cmp	eax,4
        je      re4               ; yes, do a complete fudge

	mov	eax,-1
        jmp     cc1                     ; jump back

re4:	
        mov     dword [compsp],eax              ; 1.39 empty the stack

        callc   zystm,0                 ; Fetch execution time to reg_ia
        mov     eax,dword [reg_ia]              ; Set time into compiler0
	extern	TIMSX
	SETMINR	dword [TIMSX],eax

        push    outptr                  ; swcoup(outptr)
	callc	swcoup,4


        MINIMAL RSTRT                   ; no return

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

	global	DVI_
DVI_:

        or      eax,eax         ; test for 0
        jz      setovr    ; jump if 0 divisor
        push    ebp             ; preserve CP
        xchg    ebp,eax         ; divisor to ebp
        xchg    eax,edx         ; dividend in eax
        cdq                     ; extend dividend
        idiv    ebp             ; perform division. eax=quotient, edx=remainder
        xchg    edx,eax         ; place quotient in edx (IA)
        pop     ebp             ; restore CP
        xor     eax,eax         ; clear overflow indicator
	ret


	global	RMI_
RMI_:
             or      eax,eax         ; test for 0
        jz      setovr    ; jump if 0 divisor
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





	global	RTI_
RTI_:

        mov     eax, dword [reg_ra+4]   ; RA msh
        btr     eax,31          ; take absolute value, sign bit to carry flag
        jc      RTI_2     ; jump if negative real
        cmp     eax,0x41E00000  ; test against 2147483648
        jae     RTI_1     ; jump if >= +2147483648
RTI_3:  push    ecx             ; protect against C routine usage.
        push    eax             ; push RA MSH
        push    dword [reg_ra]; push RA LSH
        callfar f_2_i,8         ; float to integer
        xchg    eax,edx         ; return integer in edx (IA)
        pop     ecx             ; restore ecx
        clc
	ret

RTI_2:  cmp     eax,0x41E00000          ; test against 2147483649
        jb      RTI_0             ; definately smaller
        ja      RTI_1             ; definately larger
        cmp     dword [reg_ra+2], 0x0020
        jae     RTI_1
RTI_0:  btc     eax,31                  ; make negative again
        jmp     RTI_3
RTI_1:  stc                             ; return C=1 for too large to convert
        ret

	global	ITR_
ITR_:

        push    ecx             ; preserve
        push    edx             ; push IA
        callfar i_2_f,4         ; integer to float
%if fretst0
	fstp	dword [reg_ra]
        pop     ecx             ; restore ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra],eax    ; return result in RA

	mov	dword [reg_ra+4],edx
        pop     ecx             ; restore ecx
%endif
	ret

	global	LDR_
LDR_:
        push    dword [eax]                 ; lsh
	pop	dword [reg_ra]
        mov     eax,[eax+4]                     ; msh
	mov	dword [reg_ra+4], eax
	ret

	global	STR_
STR_:

        push    dword [reg_ra]                ; lsh
	pop	dword [eax]
        push    dword [reg_ra+4]              ; msh
	pop	dword [eax+4]
	ret

	global	ADR_
ADR_:

        push    ecx                             ; preserve regs for C
	push	edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
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
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret

        global  SBR_
SBR_:

        push    ecx                             ; preserve regs for C
	push	edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
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
        mov     dword [reg_ra+4, edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret

        global  MLR_
MLR_:

        push    ecx                             ; preserve regs for C
	push	edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
        push    dword [eax+4]               ; arg msh
        push    dword [eax]                 ; arg lsh
        callfar f_mul,16                        ; perform op
%if fretst0
	fstp	qword [reg_ra]
        pop     edx                             ; restore regs
	pop	ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra+4,] edx         ; result msh
        mov     dword [reg_ra,] eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret

        global  DVR_

DVR_:

        push    ecx                             ; preserve regs for C
	push	edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
        push    dword [eax+4]               ; arg msh
        push    dword [eax]                 ; arg lsh
        callfar f_div,16                        ; perform op
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

        global  NGR_
NGR_:
	cmp	dword [reg_ra], 0
	jne	ngr_1
	cmp	dword [reg_ra+4], 0
        je      ngr_2                     ; if zero, leave alone
ngr_1:  xor     byte [reg_ra+7], 0x80         ; complement mantissa sign
ngr_2:	ret

        global  ATN_

ATN_:

        push    ecx                             ; preserve regs for C
	push	edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
        callfar f_atn,8                         ; perform op
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

        global  CHP_

CHP_:

        push    ecx                             ; preserve regs for C
	push	edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
        callfar f_chp,8                         ; perform op
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

        global  COS_

COS_:
        push    ecx                             ; preserve regs for C
	push	edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
        callfar f_cos,8                         ; perform op
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

        global  ETX_

ETX_:
        push    ecx                             ; preserve regs for C
	push	edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
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

        global  LNF_

LNF_:

        push    ecx                             ; preserve regs for C
	push	edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
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

        global  SIN_

SIN_:

        push    ecx                             ; preserve regs for C
	push	edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
        callfar f_sin,8                         ; perform op
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

        global  SQR_


SQR_:
        push    ecx                             ; preserve regs for C
	push	edx
        push    dword [reg_ra+4]              ; RA msh
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

        global  TAN_

TAN_:
        push    ecx                             ; preserve regs for C
	push	edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
        callfar f_tan,8                         ; perform op
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

        global  CPR_

CPR_:

        mov     eax, dword [reg_ra+4] ; fetch msh
        cmp     eax, 0x80000000         ; test msh for -0.0
        je      cpr050            ; possibly
        or      eax, eax                ; test msh for +0.0
        jnz     cpr100            ; exit if non-zero for cc's set
cpr050: cmp     dword [reg_ra], 0     ; true zero, or denormalized number?
        jz      cpr100            ; exit if true zero
	mov	al, 1
        cmp     al, 0                   ; positive denormal, set cc
cpr100:	ret

        global  OVR_

OVR_: 

        mov     ax, word [reg_ra+6]   ; get top 2 bytes
        and     ax, 0x7ff0              ; check for infinity or nan
        add     ax, 0x10                ; set/clear overflow accordingly
	ret


%if winnt

        struc   cinarg
cin_ebp: resd     1
cin_ip:  resd     1
cin_fdn: resd     1
cin_buf: resd     1
cin_siz: resd     1
        endstruc

        struc   ct                      ;cinread temps
crbuf:  times   260 resd 0                ;keyboard buffer
	endstruc
zct    equ      260/4                   ;word aligned temp size
ctemp  equ      [ebp-zct]               ;temp on stack

	extern	read
%if winnt
        proc    cinreaddos
	global  cinreaddos
%else
        proc    cinread
	global	cinread
%endif
        enter   zct,0                   ;enter and reserve space for ctemp
	push	ebx
	push	esi
	push	edi

        xor     ebx,ebx                 ; Save STDIN by duplicating to
        mov     ecx,ebx                 ;  get another handle
	xor	eax,eax
        mov     ah,0x45                 ; CX = STDIN
        int     0x21
        jc      cinr5                   ; Out of handles
        push    eax                     ; Save handle to old STDIN
        mov     ebx,2                   ; Make STDIN refer to STDERR
        mov     ah,0x46                 ; so DOS's input comes from keyboard
        int     0x21

        mov     ebx,1                   ; Save STDOUT by duplicating to
        mov     ecx,ebx                 ;  get another handle
        mov     ah,0x45                 ; CX = STDOUT
        int     0x21
        jc      cinr4             ; Out of handles
	push	ecx
        push    eax                     ; Save handle to old STDOUT
        mov     ebx,2                   ; Make STDOUT refer to STDERR
        mov     ah,0x46                 ; so DOS' echo goes to screen
        int     0x21

	mov	ecx,[ebp].cin_siz
        inc     ecx                     ; Allow for CR
	cmp	ecx,255
	jle	cinr1
        mov     cl,255                  ; 255 is the max size for function 0Ah
cinr1:  lea     edx,ctemp.crbuf         ; Buffer (DS=SS)
        mov     [edx],cl                ; Set up count

        mov     ah,0x0a
        int     0x21                    ; Do buffered input into [edx+2]

	pop	ebx
        pop     ecx                     ; (CX = STDOUT)
        mov     ah,0x46                 ; Restore STDOUT to original file
        int     0x21
        mov     ah,0x3e                 ; Discard dup'ed handle
        int     0x21

        xor     ecx,ecx                 ; CX = STDIN
	pop	ebx
        mov     ah,0x46                 ; Restore STDIN to original file
        int     0x21
        mov     ah,0x3e                 ; Discard dup'ed handle
        int     0x21

	mov	esi,edx
        inc     esi                     ; Point to number of bytes read
        movzx   ebx,byte [esi]      ; Char count
        inc     ebx                     ; Include CR
        inc     esi                     ; Point to first char
        lea     edx,[esi+ebx]           ; Point past CR
        mov     [edx],byte 10       ; Append LF after CR
        inc     ebx                     ; Include LF
        cmp     ebx,[cin_siz+ebp]        ; Compare with caller's buffer size
	jle	cinr3
        mov     ebx,[cin_siz+ebp]        ; Caller's buffer size limits us
cinr3:	mov	ecx,ebx
        mov     edi,[cin_buf+ebp]        ; Caller's buffer
  rep	movsb

        push    ebx                     ; Save count
        mov     ebx,2                   ; Force LF echo to screen
        mov     ah,0x40                 ; edx points to LF
	mov	ecx,1
        int     0x21
	pop	eax

cinr2:	pop	edi
	pop	esi
	pop	ebx
	leave
	retc	12

cinr4:  xor     ecx,ecx                 ; CX = STDIN
	pop	ebx
        mov     ah,0x46                 ; Restore STDIN to original file
        int     0x21
        mov     ah,0x3e                 ; Discard dup'ed handle
        int     0x21

cinr5:	push	[cin_siz+ebp]
	push	[cin_buf+ebp]
	push	[cin_fdn+ebp]
	callc	read,12
	jmp	cinr2

%endif



%if winnt

                struc   chrdevarg
chrdev_ebp:     resd      1
chrdev_ip:      resd      1
chrdev_fdn:     resd      1
                ends

        proc    chrdevdos
	global  chrdevdos
	enter	0,0
	push	ebx

        mov     ebx,[chrdev_fdn+ebp]     ; Caller's fdn
        mov     ax,0x4400               ; IOCTL get status
        int     0x21
	pop	ebx
	jc	chrdev1
	xor	eax,eax
	mov	al,dl
	leave
	retc	4
chrdev1: xor	eax,eax
	leave
	retc	4


                struc   rawmodearg
rawmode_ebp:    resd      1
rawmode_ip:     resd      1
rawmode_fdn:    resd      1
rawmode_mode:   resd      1
                endstruc

        proc    rawmodedos
	global  rawmodedos
	enter	0,0
	push	ebx

	push	[rawmode_fdn+ebp]
	callc	chrdevdos,4
	or	eax,eax
	jz	rawmode1
        and     eax,0x0DF
	cmp	[rawmode_mode+ebp],0
	je	rawmode0
        or      al,0x20                 ; set raw bit
rawmode0:
	mov	edx,eax
        mov     ax,0x4401
        int     0x21
rawmode1: pop	ebx
	leave
	retc	4
%endif

%if linux
	global	tryfpu
tryfpu:
	push	ebp
	fldz
	pop	ebp
	ret
%endif


