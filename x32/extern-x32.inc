; equates of routines and data available to external function from spitbol-386

nearptr equ       1

; macros for code that must be assembled differently depending upon
; whether this function is being built for os/2 or ms-dos.
;
; ms-dos external functions are reached via far calls, and use far
; pointers to spitbol data.
;
; os/2 external functions are reached via near calls, and use near
; pointers to spitbol data.
;
; macro glossary 
; entry     entry name          define main procedure for this function.
;
; fstore    fstore arg          store floating point result after call to
;                               spitbol floating point function.
;
; preamble  preamble segname    define group and seg name for 1 seg program.
;           preamble seg1,seg2  define group and segs for 2 segment program.
;
;
; procx     proc name           define near or far procedure.
;
; sload     sload sreg,reg,arg  load pointer into registers.
;
; sstore    sstore arg,reg,sreg store pointer into memory.
;
; spop      spop sreg           pop segment register.
;
; spush     spush sreg          push segment register.
;
;
; equate glossary 
;
; name      usage               purpose
; --------  -----------------   -------------------------------------------
;
; cbrptr    cbrptr              size of pointer in bytes.
;
; scs       op  reg, scs arg    code segment override.
;
; ses       op  reg, ses arg    es segment override.
;
; sfs       op  reg, sfs arg    fs segment override.
;
; sgs       op  reg, sgs arg    gs segment override.
;
;
; structure glossary 
;
; name      usage               purpose
; --------  -----------------   -------------------------------------------
;
; dpt       dpt <?>             pointer data declaration.
;
; dps       dps <?>             pointer data declaration (on stack, padded
;                               to even word boundary).

%macro	fstore	1
	fstp	%1
	fwait
%endmacro
;        .macro          fstore arg
;        fstp            \arg
;	fwait
;        %endmacro

	segment	.data

%define	cbrptr	4
%define	scs	cs
%define	ses	ds
%define	sfs	ds
%define	sgs	ds

;        struc   dps
;        equ     0
;
;        struc   dpt
;         equ     0

;        .macro  procx procnm
;        %endmacro
%macro	procx	1
%endmacro

%macro	entry	1
	global  %1	
	procx	%1
%endmacro
;        .macro  entry procnm
;        .global \procnm
;        procx   \procnm
;        %endmacro
;       .macro  sload sreg,reg,arg
;       mov     \reg,\arg
;       %endmacro
%macro	sload	3
	mov	%2,%3
%endmacro

;       .macro  sstore arg,reg,sreg
;       mov     \arg,\reg
;       %endmacro
%macro	sstore	3
	mov	%1,%2
%endmacro

;       .macro  spop sreg
;       %endmacro
%macro	spop	1
%endmacro

;       .macro  spush sreg
;       %endmacro
%macro	spush	1
%endmacro

;.list

        %include         "x32/block-x32.inc"

;       (c) copyright 1990 - catspaw, incorporated
;
;
; at function entry, the stack looks like this 
;
;               +-----------------------+
; ss esp -----> |     return offset     |
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
; generally, the items in the miscinfo area can be ignored, and are provided
; only for the benefit of those wishing to operate directly on spitbol's
; internal data structures.
;
; however, the result area pointer *must* be used by the external
; function to locate the area in which results are returned.
;
; note that pointers on the stack are 4-byte quantities.
;
; definition of structure of the miscinfo area.  a pointer to this
; area is placed on the stack below the result area pointer.
;

;	segment	.text
vers    equ     0               ;internal version number
env     equ     2               ;host environment (t_pharlap, t_intel, t_os2)
;       equ     3               ;reserved
nargs   equ     4               ;number of arguments to function
ptyptab equ     8               ;pointer to table of data types
pxnblk  equ     12              ;pointer to xnblk describing function
pefblk  equ     16              ;pointer to efblk describing function
pflttab equ     20              ;pointer to floating point table
spds    equ     24              ;spitbol's ds
spcs    equ     26              ;spitbol's cs

; values in env word of misc structure.  executing under 
t_pharlap equ   0               ;pharlap dos extender
t_intel  equ    1               ;intel dos extender
t_os2    equ    2               ;os/2 2.0
t_tc16   equ    3               ;ms-dos turboc with 16-bit ia
t_tc32   equ    4               ;ms-dos turboc with 32-bit ia
t_w1616  equ    5               ;16-bit windows, 16-bit spitbol
t_w1632  equ    6               ;16-bit windows, 32-bit spitbol
t_wnt8   equ    7               ;windows nt on 386/486
t_sparc  equ    8               ;sun 4 / sparc
t_mips   equ   10               ;mips r3000
t_rs6000 equ   11               ;ibm rs/6000
t_lnx8632 equ  12               ;linux intel x86 32-bit
t_lnx8664 equ  13               ;linux intel x86 64-bit

;
; sample usage.  example stack frame for function arguments, assuming
;                the execution of an enter instruction to put the stack
;                pointer in ebp.  this example assumes the function is
;                called with three arguments of type (integer, real, string) 
;
;               struc
;       stk_ebp equ        0               ;save ebp
;       stk_ret equ        4               ;return pointer
;       presult equ        8               ;pointer to result area
;       pmisc   equ        12              ;pointer to miscinfo area
;       parg3   equ        16              ;pointer to arg 3 string
;       larg3   equ        20              ;length of arg 3 string
;       rarg2   dq         24              ;real arg 2
;       iarg1   equ        28              ;integer arg 1
;               ends
;
;               the pointer to the result area could be loaded with 
;
;               sload   fs, edi, [ebp].presult
;
;               the pointer to the type table would be loaded by
;               double indexing 
;
;               sload   fs, ecx, [ebp].pmisc
;               sload   fs, ecx, sfs [ecx].ptyptab
;


;
; simple names for datatypes.  performs a lookup in spitbol's type
; table to fetch a 32-bit type word for specific data types.
;
; the address of spitbol's type table is passed to the function on the
; stack in ptyptab (see above).  prior to using these symbols, a
; pointer to this table must be loaded into the registers.  these equates
; assume that the pointer has been loaded into ds [ecx].  there is nothing
; special about these registers, and any others could be used
; provided the equates are modified.
;
; note   this does not work in the gnu assembler.  it generates the error message
;         error  can't make global register symbol `xx'
;        for each line.  nor can it be made into a macro, because macro expansion only
;        occurs for macros that appear in the opcode field.
;
;        users will just have to use the expansion expression explicitly in code.
;
                                         ;data types in type table at ds [ecx]
;ar     equ      [ecx+bl_ar*4]           ; array
;bc     equ      [ecx+bl_bc*4]           ; buffer control
;bf     equ      [ecx+bl_bf*4]           ; string buffer
;cd     equ      [ecx+bl_cd*4]           ; code
;ex     equ      [ecx+bl_ex*4]           ; expression
;ic     equ      [ecx+bl_ic*4]           ; integer
;nm     equ      [ecx+bl_nm*4]           ; name
;rc     equ      [ecx+bl_rc*4]           ; real
;sc     equ      [ecx+bl_sc*4]           ; string
;tb     equ      [ecx+bl_tb*4]           ; table
;vc     equ      [ecx+bl_vc*4]           ; vector
;xn     equ      [ecx+bl_xn*4]           ; external

;
; non-standard block-type values that may be returned in register eax.
;
fail   equ      -1                      ; signal function failure
bl_nc  equ      100                     ; unconverted result
bl_fs  equ      101                     ; pointer to string
bl_fx  equ      102                     ; pointer to external block

;
; length of string area in result buffer
;
buflen equ      512


; vectors to real number functions.
;
; reals are 8-byte, double-precision reals in ieee format.
; integers (for fix and float) are 32-bit two's complement numbers.
;
; function arguments are pushed onto the stack left-to-right.  with 8-byte
; reals, the most-significant half (msh) is pushed first.  note that this
; differs from standard c calling conventions.
;
; integer results are returned in eax.  real results are returned in
; edx eax  (edx = msh, eax = lsh).
;
; the caller is responsible for removing arguments from the stack
; after the function returns.
;
; functions taking two arguments, such as r_sub(r1,r2) order their
; operations as r1-r2.
;
; the address of a table of dispatch vectors is passed to the external
; function on the stack in pflttab (see above).  these =  ates assume
; that a pointer to the table has been loaded into ds [ebx] by your code.
;
; using the example above, this might be done with the following 
;
;                       sload   ds, ebx, [ebp].pmisc
;                       sload   ds, ebx, [ebx].pflttab
;
;
; the real functions preserve ebx, esi, edi and ebp, and may destroy
; eax, ecx, and edx.
;
; example.  divide the real number in location r1 by the number in r2, and
;           store the result in r3 
;
;       spush   ds                      ;save our ds
;       push    dword ptr r1+4          ;push first arg, msh
;       push    dword ptr r1            ;push first arg, lsh
;       push    dword ptr r2+4          ;push second arg, msh
;       push    dword ptr r2            ;push second arg, lsh
;       sload   ds,ebx,[ebp].pmisc      ;get address of miscinfo area
;       sload   ds,ebx,[ebx].pflttab    ;get address of vector table
;       r_div                           ;perform division
;       aequ    esp, 2*8                ;remove arguments
;       spop    ds                      ;restore our ds
;       mov     dword ptr r3, eax       ;store result lsh
;       mov     dword ptr r3+4, edx     ;store result msh
;
;
;
;       .macro  fix
;       call    [ebx+ 0*cbrptr]           ; real to integer        i = fix(r)
;       %endmacro
;       .macro  float
;       call    [ebx+ 1*cbrptr]           ; integer to real        r = float(i)
;       %endmacro
;       .macro  r_add
;       call    [ebx+ 2*cbrptr]           ; real addition          r = r_add(r1,r2)
;       %endmacro
%macro  fix	0
        call    [ebx+ 0*cbrptr]           ; real to integer        i = fix(r)
%endmacro
%macro	float	0
        call    [ebx+ 1*cbrptr]           ; integer to real        r = float(i)
%endmacro
%macro  r_add	0
        call    [ebx+ 2*cbrptr]           ; real addition          r = r_add(r1,r2)
%endmacro

%macro  r_sub	0
        call    [ebx+ 3*cbrptr]           ; real subtraction       r = r_sub(r1,r2)
%endmacro

%macro  r_mul	0
        call    [ebx+ 4*cbrptr]           ; real multiplication    r = r_mul(r1,r2)
%endmacro
%macro  r_div	0
        call    [ebx+ 5*cbrptr]           ; real division          r = r_div(r1,r2)
        %endmacro
%macro  r_neg	0
        call    [ebx+ 6*cbrptr]           ; real negation          r = r_neg(r)
        %endmacro
%macro  r_atn	0
        call    [ebx+ 7*cbrptr]           ; real arc tangent       r = r_atn(r)
%endmacro
%macro  r_chp	0
        call    [ebx+ 8*cbrptr]           ; real chop              r = r_chp(r)
%endmacro
%macro  r_cos	0
        call    [ebx+ 9*cbrptr]           ; real cosine            r = r_cos(r)
%endmacro
%macro  r_etx	0
        call    [ebx+10*cbrptr]           ; real e to the x        r = r_etx(r)
%endmacro
%macro  r_lnf	0
        call    [ebx+11*cbrptr]           ; real natural logarithm r = r_lnf(r)
%endmacro
%macro  r_sin	0
        call    [ebx+12*cbrptr]           ; real sine              r = r_sin(r)
%endmacro
%macro  r_sqr	0
        call    [ebx+13*cbrptr]           ; real square root       r = r_sqr(r)
%endmacro
%macro  r_tan	0
        call    [ebx+14*cbrptr]           ; real tangent           r = r_tan(r)
%endmacro

