; SPITBOL math routine interface 
        %include        "systype.nh"
;        %include        "osint.inc"

	extern	ten
	extern	reg_ra
;
;-----------
;
;       CVD_ - convert by division
;
;       Input   IA (EDX) = number <=0 to convert
;       Output  IA / 10
;               WA (ECX) = remainder + '0'
;
        global  CVD_

CVD_:
        xchg    eax,edx         ; IA to EAX
        cdq                     ; sign extend
        idiv    dword [ten]   ; divide by 10. edx = remainder (negative)
        neg     edx             ; make remainder positive
        add     dl,0x30         ; convert remainder to ascii ('0')
        mov     ecx,edx         ; return remainder in WA
        xchg    edx,eax         ; return quotient in IA
	ret

;
;-----------
;
;       DVI_ - divide IA (EDX) by long in EAX
;
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


;
;-----------
;
;       RMI_ - remainder of IA (EDX) divided by long in EAX
;
        global  RMI_
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



;----------
;
;    Calls to C
;
;       The calling convention of the various compilers:
;
;       Integer results returned in EAX.
;       Float results returned in ST0 for Intel.
;       See conditional switches fretst0 and
;       freteax in systype.ah for each compiler.
;
;       C function preserves EBP, EBX, ESI, EDI.
;


;----------
;
;       RTI_ - convert real in RA to integer in IA
;               returns C=0 if fit OK, C=1 if too large to convert
;
        global  RTI_
RTI_:
; 41E00000 00000000 = 2147483648.0
; 41E00000 00200000 = 2147483649.0
        mov     eax, dword [reg_ra+4]  ; RA msh
        btr     eax,31          ; take absolute value, sign bit to carry flag
        jc      RTI_2     ; jump if negative real
        cmp     eax,0x41E00000  ; test against 2147483648
        jae     RTI_1     ; jump if >= +2147483648
RTI_3:  push    ecx             ; protect against C routine usage.
        push    eax             ; push RA MSH
        push    dword [reg_ra]  ; push RA LSH
        callfar f_2_i,8         ; float to integer
        xchg    eax,edx         ; return integer in edx (IA)
        pop     ecx             ; restore ecx
        clc
	ret

; here to test negative number, made positive by the btr instruction
RTI_2:  cmp     eax,0x41E00000          ; test against 2147483649
        jb      RTI_0             ; definately smaller
        ja      RTI_1             ; definately larger
        cmp     word [reg_ra+2], 0x0020
        jae     RTI_1
RTI_0:  btc     eax,31                  ; make negative again
        jmp     RTI_3
RTI_1:  stc                             ; return C=1 for too large to convert
        ret

;
;----------
;
;       ITR_ - convert integer in IA to real in RA
;
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
        mov     dword [reg_ra,eax    ; return result in RA
	mov	dword [reg_ra+4,edx
        pop     ecx             ; restore ecx
%endif
	ret

;
;----------
;
;       LDR_ - load real pointed to by eax to RA
;
        global  LDR_
LDR_:

        push    dword [eax]                 ; lsh
	pop	dword [reg_ra]
        mov     eax,[eax+4]                     ; msh
	mov	dword [reg_ra+4], eax
	ret

;
;----------
;
;       STR_ - store RA in real pointed to by eax
;
        global  STR_
STR_:

        push    dword [reg_ra]               ; lsh
	pop	dword [eax]
        push    dword [reg_ra+4]              ; msh
	pop	dword [eax+4]
	ret

;
;----------
;
;       ADR_ - add real at [eax] to RA
;
        global  ADR_
ADR_:

        push    ecx                             ; preserve regs for C
	push	edx
        push    dword [reg_ra+4]             ; RA msh
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
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret

;
;----------
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
        mov     dword [reg_ra+4, edx         ; result msh
        mov     dword [reg_ra, eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret

;
;----------
;
;       MLR_ - multiply real in RA by real at [eax]
;
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
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret

;
;----------
;
;       DVR_ - divide real in RA by real at [eax]
;
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

;
;----------
;
;       NGR_ - negate real in RA
;
        global  NGR_

NGR_:
	cmp	dword [reg_ra], 0
	jne	ngr_1
	cmp	dword [reg_ra+4], 0
        je      ngr_2                     ; if zero, leave alone
ngr_1:  xor     byte [reg_ra+7], 0x80         ; complement mantissa sign
ngr_2:	ret

;
;----------
;
;       ATN_ arctangent of real in RA
;
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

;
;----------
;
;       CHP_ chop fractional part of real in RA
;
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

;
;----------
;
;       COS_ cosine of real in RA
;
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

;
;----------
;
;       ETX_ exponential of real in RA
;
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

;
;----------
;
;       LNF_ natural logarithm of real in RA
;
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

;
;----------
;
;       SIN_ arctangent of real in RA
;
        global  SIN_

SIN_:

        push    ecx                             ; preserve regs for C
	push	edx
        push    dword [reg_ra+4]              ; RA msh
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
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret

;
;----------
;
;       SQR_ arctangent of real in RA
;
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

;
;----------
;
;       TAN_ arctangent of real in RA
;
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

;
;----------
;
;       CPR_ compare real in RA to 0
;
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


;----------
;
;       OVR_ test for overflow value in RA

	global	OVR_

OVR_:   
        mov     ax, word [reg_ra+6]   ; get top 2 bytes
        and     ax, 0x7ff0              ; check for infinity or nan
        add     ax, 0x10                ; set/clear overflow accordingly
	ret




;  tryfpu - perform a floating point op to trigger a trap if no floating point hardware.

	global	tryfpu
tryfpu:
	push	ebp
	fldz
	pop	ebp
	ret

