
;----------

;    Calls to C

;       The calling convention of the various compilers:

;       Integer results returned in EAX.
;       Float results returned in ST0 for Intel.
;       See conditional switches fretst0 and
;       freteax in systype.ah for each compiler.
;
;       C function preserves EBP, EBX, ESI, EDI.


; call c function.  intel follows standard c conventions, and
; caller pops arguments.

%macro  callc 2
        call    %1
%if %2
        add     esp,%2
%endif
%endmacro

; intel runs in one flat segment.  far calls are the same as near calls.

%macro  callfar 2
        extern     %1
        callc   %1,%2
%endmacro

	extern ten
;
;-----------
;
;       cvd_ - convert by division
;
;       input   ia (edx) = number <=0 to convert
;       output  ia / 10
;               wa (ecx) = remainder + '0'
;
	%macro	cvd_ 0
        xchg    eax,edx         ; ia to eax
        cdq                     ; sign extend
        idiv    dword [ten]   ; divide by 10. edx = remainder (negative)
        neg     edx             ; make remainder positive
        add     dl,0x30         ; convert remainder to ascii ('0')
        mov     ecx,edx         ; return remainder in WA
        xchg    edx,eax         ; return quotient in IA
	%endmacro

;
;       rmi_ - remainder of ia (edx) divided by long in eax
;
	%macro	rmi_ 0
        or      eax,eax         ; test for 0
        jz      %%setovr    ; jump if 0 divisor
        push    ebp             ; preserve cp
        xchg    ebp,eax         ; divisor to ebp
        xchg    eax,edx         ; dividend in eax
        cdq                     ; extend dividend
        idiv    ebp             ; perform division. eax=quotient, edx=remainder
        pop     ebp             ; restore cp
        xor     eax,eax         ; clear overflow indicator
%%setovr: 
	mov     al,0x80         ; set overflow indicator
        dec     al
	%endmacro


;       RTI_ - convert real in RA to integer in IA
;               returns C=0 if fit OK, C=1 if too large to convert


; 41E00000 00000000 = 2147483648.0
; 41E00000 00200000 = 2147483649.0
	%macro	rti_	0
        mov     eax, dword [reg_ra+4]   ; RA msh
        btr     eax,31          ; take absolute value, sign bit to carry flag
        jc      %%rti_2     ; jump if negative real
        cmp     eax,0x41E00000  ; test against 2147483648
        jae     %%rti_1     ; jump if >= +2147483648
%%rti_3:  
	push    ecx             ; protect against C routine usage.
        push    eax             ; push RA MSH
        push    dword [reg_ra]; push RA LSH
        callfar f_2_i,8         ; float to integer
        xchg    eax,edx         ; return integer in edx (IA)
        pop     ecx             ; restore ecx
        clc
	jmp	%%rti_r

; here to test negative number, made positive by the btr instruction
%%rti_2:  cmp     eax,0x41E00000          ; test against 2147483649
        jb      %%rti_0             ; definately smaller
        ja      %%rti_1             ; definately larger
        cmp     dword [reg_ra+2], 0x0020
        jae     %%rti_1
%%rti_0:  btc     eax,31                  ; make negative again
        jmp     %%rti_3
%%rti_1:  stc                             ; return C=1 for too large to convert
%%rti_r: 
	%endmacro



;       itr_ - convert integer in ia to real in ra

	%macro	itr_ 0

        push    ecx             ; preserve
        push    edx             ; push ia
        callfar i_2_f,4         ; integer to float
%if fretst0
        fstp    qword [reg_ra]
        pop     ecx             ; restore ecx
        fwait
%endif
%if freteax
        mov     dword [reg_ra],eax    ; return result in ra

        mov     dword [reg_ra+4],edx
        pop     ecx             ; restore ecx
%endif
	%endmacro



;       ldr_ - load real pointed to by eax to ra

	%macro	ldr_ 0
        push    dword [eax]                 ; lsh
        pop     dword [reg_ra]
        mov     eax,dword [eax+4]                     ; msh
        mov     dword [reg_ra+4], eax
        %endmacro



;       str_ - store ra in real pointed to by eax

	%macro	str_ 0

        push    dword [reg_ra]                ; lsh
        pop     dword [eax]
        push    dword [reg_ra+4]              ; msh
        pop     dword [eax+4]
        %endmacro


;       adr_ - add real at [eax] to ra

	%macro	adr_	0

        push    ecx                             ; preserve regs for c
	push	edx
        push    dword [reg_ra+4]              ; ra msh
        push    dword [reg_ra]                ; ra lsh
        push    dword [eax+4]               ; arg msh
        push    dword [eax]                 ; arg lsh
        callfar f_add,16                        ; perform op
%if fretst0
        fstp    qword [reg_ra]
        pop     edx                             ; restore regs
        pop     ecx
        fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
        pop     ecx
%endif
	%endmacro


;       sbr_ - subtract real at [eax] from ra

        %macro  sbr_	0
        push    ecx                             ; preserve regs for C
        push    edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
        push    dword [eax+4]               ; arg msh
        push    dword [eax]                 ; arg lsh
        callfar f_sub,16                        ; perform op
%if fretst0
        fstp    qword [reg_ra]
        pop     edx                             ; restore regs
        pop     ecx
        fwait
%endif
%if freteax
        mov     dword [reg_ra+4, edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
        pop     ecx
%endif
        %endmacro

;       mlr_ - multiply real in ra by real at [eax]

        %macro  mlr_	0
        push    ecx                             ; preserve regs for C
        push    edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
        push    dword [eax+4]               ; arg msh
        push    dword [eax]                 ; arg lsh
        callfar f_mul,16                        ; perform op
%if fretst0
        fstp    qword [reg_ra]
        pop     edx                             ; restore regs
        pop     ecx
        fwait
%endif
%if freteax
        mov     dword [reg_ra+4,] edx         ; result msh
        mov     dword [reg_ra,] eax           ; result lsh
        pop     edx                             ; restore regs
        pop     ecx
%endif
       %endmacro


;       dvr_ - divide real in ra by real at [eax]

        %macro  dvr_	0


        push    ecx                             ; preserve regs for C
        push    edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
        push    dword [eax+4]               ; arg msh
        push    dword [eax]                 ; arg lsh
        callfar f_div,16                        ; perform op
%if fretst0
        fstp    qword [reg_ra]
        pop     edx                             ; restore regs
        pop     ecx
        fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
        pop     ecx
%endif
       %endmacro


;       ngr_ - negate real in ra

        %macro  ngr_	0
	cmp	dword [reg_ra], 0
	jne	%%ngr_1
	cmp	dword [reg_ra+4], 0
        je      %%ngr_2                     ; if zero, leave alone
%%ngr_1:  xor     byte [reg_ra+7], 0x80         ; complement mantissa sign
%%ngr_2:  
	%endmacro



; MATH-LIB
;	segment		.text

; MATH-LIB
;	segment		.text
	%macro	atn_	0

;       atn_ arctangent of real in ra


        push    ecx                             ; preserve regs for C
        push    edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
	extern	f_atn
        callfar f_atn,8                         ; perform op
%if fretst0
        fstp    qword [reg_ra]
        pop     edx                             ; restore regs
        pop     ecx
        fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
        pop     ecx
%endif
	%endmacro


;       chp_ chop fractional part of real in ra

	%macro	chp_	0

        push    ecx                             ; preserve regs for C
        push    edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
        callfar f_chp,8                         ; perform op
%if fretst0
        fstp    qword [reg_ra]
        pop     edx                             ; restore regs
        pop     ecx
        fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
        pop     ecx
%endif
	%endmacro


;       cos_ cosine of real in ra

	%macro	cos_	0
        push    ecx                             ; preserve regs for C
        push    edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
        callfar f_cos,8                         ; perform op
%if fretst0
        fstp    qword [reg_ra]
        pop     edx                             ; restore regs
        pop     ecx
        fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
        pop     ecx
%endif
	%endmacro

        %macro  etx_	0
        push    ecx                             ; preserve regs for c
	push	edx
        push    dword [reg_ra+4]              ; ra msh
        push    dword [reg_ra]                ; ra lsh
        callfar f_etx,8                         ; perform op
%if fretst0
        fstp    qword [reg_ra]
        pop     edx                             ; restore regs
        pop     ecx
        fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
        pop     ecx
%endif
	%endmacro

	%macro  lnf_	0

        push    ecx                             ; preserve regs for C
        push    edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
        callfar f_lnf,8                         ; perform op
%if fretst0
        fstp    qword [reg_ra]
        pop     edx                             ; restore regs
        pop     ecx
        fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
        pop     ecx
%endif
	%endmacro

	%macro	sin_	0

        push    ecx                             ; preserve regs for C
        push    edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
        callfar f_sin,8                         ; perform op
%if fretst0
        fstp    qword [reg_ra]
        pop     edx                             ; restore regs
        pop     ecx
        fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
        pop     ecx
%endif
	%endmacro

        %macro sqr_	0
        push    ecx                             ; preserve regs for C
        push    edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
        callfar f_sqr,8                         ; perform op
%if fretst0
        fstp    qword [reg_ra]
        pop     edx                             ; restore regs
        pop     ecx
        fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
        pop     ecx
%endif
	%endmacro

        %macro tan_	0
        push    ecx                             ; preserve regs for C
        push    edx
        push    dword [reg_ra+4]              ; RA msh
        push    dword [reg_ra]                ; RA lsh
        callfar f_tan,8                         ; perform op
%if fretst0
        fstp    qword [reg_ra]
        pop     edx                             ; restore regs
        pop     ecx
        fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
        pop     ecx
%endif
	%endmacro

        %macro cpr_	0

        mov     eax, dword [reg_ra+4] ; fetch msh
        cmp     eax, 0x80000000         ; test msh for -0.0
        je      %%cpr050            ; possibly
        or      eax, eax                ; test msh for +0.0
        jnz     %%cpr100            ; exit if non-zero for cc's set
%%cpr050: cmp     dword [reg_ra], 0     ; true zero, or denormalized number?
        jz      %%cpr100            ; exit if true zero
        mov     al, 1
        cmp     al, 0                   ; positive denormal, set cc
%%cpr100: 
	%endmacro

;       ovr_ test for overflow value in ra

        %macro ovr_	0
        mov     ax, word [reg_ra+6]   ; get top 2 bytes
        and     ax, 0x7ff0              ; check for infinity or nan
        add     ax, 0x10                ; set/clear overflow accordingly
	%endmacro
