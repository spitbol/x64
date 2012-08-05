;--------------------------  extrn386.inc -------------------------------------
; Equates of routines and data available to external function from SPITBOL-386

nearptr equ       1

; Macros for code that must be assembled differently depending upon
; whether this function is being built for OS/2 or MS-DOS.
;
; MS-DOS external functions are reached via FAR calls, and use FAR
; pointers to SPITBOL data.
;
; OS/2 external functions are reached via NEAR calls, and use NEAR
; pointers to SPITBOL data.
;------------------------------------------------------------------
;
; Macro Glossary:
; entry     entry name          Define main procedure for this function.
;
; fstore    fstore arg          Store floating point result after call to
;                               SPITBOL floating point function.
;
; preamble  preamble segname    Define group and seg name for 1 seg program.
;           preamble seg1,seg2  Define group and segs for 2 segment program.
;
;
; procx     proc name           Define near or far procedure.
;
; sload     sload sreg,reg,arg  Load pointer into registers.
;
; sstore    sstore arg,reg,sreg Store pointer into memory.
;
; spop      spop sreg           Pop segment register.
;
; spush     spush sreg          Push segment register.
;
;
; Equate Glossary:
;
; Name      Usage               Purpose
; --------  -----------------   -------------------------------------------
;
; cbrptr    cbrptr              Size of pointer in bytes.
;
; scs       op  reg, scs:arg    Code segment override.
;
; ses       op  reg, ses:arg    ES segment override.
;
; sfs       op  reg, sfs:arg    FS segment override.
;
; sgs       op  reg, sgs:arg    GS segment override.
;
;
; Structure Glossary:
;
; Name      Usage               Purpose
; --------  -----------------   -------------------------------------------
;
; dpt       dpt <?>             Pointer data declaration.
;
; dps       dps <?>             Pointer data declaration (on stack, padded
;                               to even word boundary).

        %macro          fstore 1
        fstp            %1
	fwait
        %endmacro

        %macro          preamble 2
	section		.text
	section		.data
	section		.bss
	section		.text
        %endmacro

cbrptr equ 4

	%define	scs	cs
	%define	ses	ds
	%define	sfs	ds
	%define	sks	ds

; above define's used instead of following, that was TODO
;	equ	scs,cs
;	equ	ses,ds
;	equ	sfs,ds
;	equ	sgs,ds

;	segment		.data
;        struc   dpt
;o:      resd   1
;        endstruc 

;       struc   dps
;o:	resd	1
;        endstruc

        %macro  procx 1
        %endmacro

        %macro  entry 1
        global %1
        procx   %1
        %endmacro

        %macro  sload 3
        mov     \reg,\arg
	mov	%2,%3
        %endmacro

        %macro  sstore 3
	mov	%1,%2
        %endmacro

        %macro  spop 1
        %endmacro

        %macro  spush 1
        %endmacro

;.list

        %include         "block386.inc"

;.nolist
;       V1.02   10-Sep-92 Add string buffer blocks.
;
;       V1.03   19-Jun-09 Modified for Linux 386 (32-bit) SPITBOL.
;
;       (c) Copyright 1990 - Catspaw, Incorporated
;
;
; At function entry, the stack looks like this:
;
;               +-----------------------+
; SS:ESP -----> |     return offset     |
;               |-----------------------|
;               |  result area offset   |
;               |-----------------------|
;               | miscinfo area offset  |
;               |-----------------------|
;               |     last argument     |
;               |-----------------------|
;               |       . . . .         |
;               |-----------------------|
;               |    first argument     |
;               +-----------------------+
;
;
; Generally, the items in the miscinfo area can be ignored, and are provided
; only for the benefit of those wishing to operate directly on SPITBOL's
; internal data structures.
;
; However, the result area pointer *must* be used by the external
; function to locate the area in which results are returned.
;
; Note that pointers on the stack are 4-byte quantities.
;
; Definition of structure of the miscinfo area.  A pointer to this
; area is placed on the stack below the result area pointer.
;

        struc   misc
vers:		resd	1       ;internal version number
env:		resd	1       ;host environment (t_pharlap, t_intel, t_os2)
reserved:	resb	1       ;reserved
nargs:		resd	1       ;number of arguments to function
ptyptab:	resd	1       ;pointer to table of data types
pxnblk:		resd	1       ;pointer to xnblk describing function
pefblk:		resd	1       ;pointer to efblk describing function
pflttab:	resd	1       ;pointer to floating point table
spds:		resd	1       ;SPITBOL's DS
spcs:		resd	1	;SPITBOL's CS
        endstruc

; values in env word of misc structure.  Executing under:
t_pharlap equ    0               ;PharLap DOS Extender
t_intel  equ    1               ;Intel DOS Extender
t_os2    equ    2               ;OS/2 2.0
t_tc16   equ    3               ;MS-DOS TurboC with 16-bit IA
t_tc32   equ    4               ;MS-DOS TurboC with 32-bit IA
t_w1616  equ    5               ;16-bit Windows, 16-bit SPITBOL
t_w1632  equ    6               ;16-bit Windows, 32-bit SPITBOL
t_wnt8   equ    7               ;Windows NT on 386/486
t_sparc  equ    8               ;Sun 4 / SPARC
t_mips   equ   10               ;MIPS R3000
t_rs6000 equ   11               ;IBM RS/6000
t_lnx8632 equ   12               ;Linux Intel x86 32-bit
t_lnx8664 equ   13               ;Linux Intel x86 64-bit

;
; Sample usage.  Example stack frame for function arguments, assuming
;                the execution of an ENTER instruction to put the stack
;                pointer in EBP.  This example assumes the function is
;                called with three arguments of type (INTEGER, REAL, STRING):
;
;               struc
;       stk_ebp dd      0               #save ebp
;       stk_ret dd      0               #return pointer
;       presult dd      0               #pointer to result area
;       pmisc   dd      0               #pointer to miscinfo area
;       parg3   dd      0               #pointer to arg 3 string
;       larg3   dd      0               #length of arg 3 string
;       rarg2   dd    0               #real arg 2
;       iarg1   dd      0               #integer arg 1
;               ends
;
;               The pointer to the result area could be loaded with:
;
;               sload   fs, edi, [ebp].presult
;
;               The pointer to the type table would be loaded by
;               double indexing:
;
;               sload   fs, ecx, [ebp].pmisc
;               sload   fs, ecx, sfs:[ecx].ptyptab
;


;
; Simple names for datatypes.  Performs a lookup in SPITBOL's type
; table to fetch a 32-bit type word for specific data types.
;
; The address of SPITBOL's type table is passed to the function on the
; stack in ptyptab (see above).  Prior to using these symbols, a
; pointer to this table must be loaded into the registers.  These equates
; assume that the pointer has been loaded into DS:[ECX].  There is nothing
; special about these registers, and any others could be used
; provided the equates are modified.
;
; Note:  This DOES NOT work in the GNU assembler.  It generates the error message
;         Error: can't make global register symbol `xx'
;        for each line.  Nor can it be made into a macro, because macro expansion only
;        occurs for macros that appear in the opcode field.
;
;        Users will just have to use the expansion expression explicitly in code.
;
                                         ;data types in type table at DS:[ECX]
;ar      =       [ecx+BL_AR*4]           # Array
;bc      =       [ecx+BL_BC*4]           # Buffer Control
;bf      =       [ecx+BL_BF*4]           # String Buffer
;cd      =       [ecx+BL_CD*4]           # Code
;ex      =       [ecx+BL_EX*4]           # Expression
;ic      =       [ecx+BL_IC*4]           # Integer
;nm      =       [ecx+BL_NM*4]           # Name
;rc      =       [ecx+BL_RC*4]           # Real
;sc      =       [ecx+BL_SC*4]           # String
;tb      =       [ecx+BL_TB*4]           # Table
;vc      =       [ecx+BL_VC*4]           # Vector
;xn      =       [ecx+BL_XN*4]           # External

;
; Non-standard block-type values that may be returned in register EAX.
;
FAIL   equ      -1                      ; Signal function failure
BL_NC  equ      100                     ; Unconverted result
BL_FS  equ      101                     ; Pointer to string
BL_FX  equ      102                     ; Pointer to external block

;
; Length of string area in result buffer
;
buflen equ      512


; Vectors to real number functions.
;
; Reals are 8-byte, double-precision reals in IEEE format.
; Integers (for fix and float) are 32-bit two's complement numbers.
;
; Function arguments are pushed onto the stack left-to-right.  With 8-byte
; reals, the most-significant half (MSH) is pushed first.  Note that this
; differs from standard C calling conventions.
;
; Integer results are returned in EAX.  Real results are returned in
; EDX:EAX  (EDX = MSH, EAX = LSH).
;
; The caller is responsible for removing arguments from the stack
; after the function returns.
;
; Functions taking two arguments, such as r_sub(r1,r2) order their
; operations as r1-r2.
;
; The address of a table of dispatch vectors is passed to the external
; function on the stack in pflttab (see above).  These =  ates assume
; that a pointer to the table has been loaded into DS:[EBX] by your code.
;
; Using the example above, this might be done with the following:
;
;                       sload   ds, ebx, [ebp].pmisc
;                       sload   ds, ebx, [ebx].pflttab
;
;
; The real functions preserve EBX, ESI, EDI and EBP, and may destroy
; EAX, ECX, and EDX.
;
; Example.  Divide the real number in location r1 by the number in r2, and
;           store the result in r3:
;
;       spush   ds                      #save our DS
;       push    dword ptr r1+4          #push first arg, msh
;       push    dword ptr r1            #push first arg, lsh
;       push    dword ptr r2+4          #push second arg, msh
;       push    dword ptr r2            #push second arg, lsh
;       sload   ds,ebx,[ebp].pmisc      #get address of miscinfo area
;       sload   ds,ebx,[ebx].pflttab    #get address of vector table
;       r_div                           #perform division
;       add     esp, 2*8                #remove arguments
;       spop    ds                      #restore our DS
;       mov     dword ptr r3, eax       #store result lsh
;       mov     dword ptr r3+4, edx     #store result msh
;
;
;
        %macro  fix 0
        call    [ebx+ 0*cbrptr]           ; real to integer        i = fix(r)
        %endmacro
        %macro  float 0
        call    [ebx+ 1*cbrptr]           ; integer to real        r = float(i)
        %endmacro
        %macro  r_add 0
        call    [ebx+ 2*cbrptr]           ; real addition          r = r_add(r1,r2)
        %endmacro
        %macro  r_sub 0
        call    [ebx+ 3*cbrptr]           ; real subtraction       r = r_sub(r1,r2)
        %endmacro
        %macro  r_mul 0
        call    [ebx+ 4*cbrptr]           ; real multiplication    r = r_mul(r1,r2)
        %endmacro
        %macro  r_div 0
        call    [ebx+ 5*cbrptr]           ; real division          r = r_div(r1,r2)
        %endmacro
        %macro  r_neg 0
        call    [ebx+ 6*cbrptr]           ; real negation          r = r_neg(r)
        %endmacro
        %macro  r_atn 0
        call    [ebx+ 7*cbrptr]           ; real arc tangent       r = r_atn(r)
        %endmacro
        %macro  r_chp 0
        call    [ebx+ 8*cbrptr]           ; real chop              r = r_chp(r)
        %endmacro
        %macro  r_cos 0
        call    [ebx+ 9*cbrptr]           ; real cosine            r = r_cos(r)
        %endmacro
        %macro  r_etx 0
        call    [ebx+10*cbrptr]           ; real e to the x        r = r_etx(r)
        %endmacro
        %macro  r_lnf 0
        call    [ebx+11*cbrptr]           ; real natural logarithm r = r_lnf(r)
        %endmacro
        %macro  r_sin 0
        call    [ebx+12*cbrptr]           ; real sine              r = r_sin(r)
        %endmacro
        %macro  r_sqr 0
        call    [ebx+13*cbrptr]           ; real square root       r = r_sqr(r)
        %endmacro
        %macro  r_tan 0
        call    [ebx+14*cbrptr]           ; real tangent           r = r_tan(r)
        %endmacro

;.list
;-------------------------- End of extrn386.inc -----------------------------
