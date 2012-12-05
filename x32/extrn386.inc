#--------------------------  extrn386.inc -------------------------------------
# Equates of routines and data available to external function from SPITBOL-386

nearptr =       1

# Macros for code that must be assembled differently depending upon
# whether this function is being built for OS/2 or MS-DOS.
#
# MS-DOS external functions are reached via FAR calls, and use FAR
# pointers to SPITBOL data.
#
# OS/2 external functions are reached via NEAR calls, and use NEAR
# pointers to SPITBOL data.
#------------------------------------------------------------------
#
# Macro Glossary:
# entry     entry name          Define main procedure for this function.
#
# fstore    fstore arg          Store floating point result after call to
#                               SPITBOL floating point function.
#
# preamble  preamble segname    Define group and seg name for 1 seg program.
#           preamble seg1,seg2  Define group and segs for 2 segment program.
#
#
# procx     proc name           Define near or far procedure.
#
# sload     sload sreg,reg,arg  Load pointer into registers.
#
# sstore    sstore arg,reg,sreg Store pointer into memory.
#
# spop      spop sreg           Pop segment register.
#
# spush     spush sreg          Push segment register.
#
#
# Equate Glossary:
#
# Name      Usage               Purpose
# --------  -----------------   -------------------------------------------
#
# cbrptr    cbrptr              Size of pointer in bytes.
#
# scs       op  reg, scs:arg    Code segment override.
#
# ses       op  reg, ses:arg    ES segment override.
#
# sfs       op  reg, sfs:arg    FS segment override.
#
# sgs       op  reg, sgs:arg    GS segment override.
#
#
# Structure Glossary:
#
# Name      Usage               Purpose
# --------  -----------------   -------------------------------------------
#
# dpt       dpt <?>             Pointer data declaration.
#
# dps       dps <?>             Pointer data declaration (on stack, padded
#                               to even word boundary).

        .macro          fstore arg
        fstp            \arg
	fwait
        .endm

        .macro          preamble segname1,segname2
        CSeg_
        CSegEnd_
        DSeg_
        DSegEnd_
        BSSSeg_
        BSSSegEnd_
        CSeg_
        .endm

        .equ    cbrptr,4

        .equ    scs,cs
        .equ    ses,ds
        .equ    sfs,ds
        .equ    sgs,ds

        struc   dpt
o:      .long   0
        ends    dpt

        struc   dps
        .long   0
        ends    dps

        .macro  procx procnm
        .endm

        .macro  entry procnm
        .global \procnm
        procx   \procnm
        .endm

        .macro  sload sreg,reg,arg
        mov     \reg,\arg
        .endm

        .macro  sstore arg,reg,sreg
        mov     \arg,\reg
        .endm

        .macro  spop sreg
        .endm

        .macro  spush sreg
        .endm

.list

        .include         "block386.inc"

.nolist
#       V1.02   10-Sep-92 Add string buffer blocks.
#
#       V1.03   19-Jun-09 Modified for Linux 386 (32-bit) SPITBOL.
#
#       (c) Copyright 1990 - Catspaw, Incorporated
#
#
# At function entry, the stack looks like this:
#
#               +-----------------------+
# SS:ESP -----> |     return offset     |
#               |-----------------------|
#               |  result area offset   |
#               |-----------------------|
#               | miscinfo area offset  |
#               |-----------------------|
#               |     last argument     |
#               |-----------------------|
#               |       . . . .         |
#               |-----------------------|
#               |    first argument     |
#               +-----------------------+
#
#
# Generally, the items in the miscinfo area can be ignored, and are provided
# only for the benefit of those wishing to operate directly on SPITBOL's
# internal data structures.
#
# However, the result area pointer *must* be used by the external
# function to locate the area in which results are returned.
#
# Note that pointers on the stack are 4-byte quantities.
#
# Definition of structure of the miscinfo area.  A pointer to this
# area is placed on the stack below the result area pointer.
#

        struc   misc
vers:   .word   0               #internal version number
env:    .byte   0               #host environment (t_pharlap, t_intel, t_os2)
        .byte   0               #reserved
nargs:  .long   0               #number of arguments to function
ptyptab:.long   0               #pointer to table of data types
pxnblk: .long   0               #pointer to xnblk describing function
pefblk: .long   0               #pointer to efblk describing function
pflttab:.long   0               #pointer to floating point table
spds:   .word   0               #SPITBOL's DS
spcs:   .word   0               #SPITBOL's CS
        ends    misc

# values in env word of misc structure.  Executing under:
t_pharlap =     0               #PharLap DOS Extender
t_intel   =     1               #Intel DOS Extender
t_os2     =     2               #OS/2 2.0
t_tc16    =     3               #MS-DOS TurboC with 16-bit IA
t_tc32    =     4               #MS-DOS TurboC with 32-bit IA
t_w1616   =     5               #16-bit Windows, 16-bit SPITBOL
t_w1632   =     6               #16-bit Windows, 32-bit SPITBOL
t_wnt8    =     7               #Windows NT on 386/486
t_sparc   =     8               #Sun 4 / SPARC
t_mips    =    10               #MIPS R3000
t_rs6000  =    11               #IBM RS/6000
t_lnx8632 =    12               #Linux Intel x86 32-bit
t_lnx8664 =    13               #Linux Intel x86 64-bit

#
# Sample usage.  Example stack frame for function arguments, assuming
#                the execution of an ENTER instruction to put the stack
#                pointer in EBP.  This example assumes the function is
#                called with three arguments of type (INTEGER, REAL, STRING):
#
#               struc
#       stk_ebp .long      0               #save ebp
#       stk_ret .long      0               #return pointer
#       presult .long      0               #pointer to result area
#       pmisc   .long      0               #pointer to miscinfo area
#       parg3   .long      0               #pointer to arg 3 string
#       larg3   .long      0               #length of arg 3 string
#       rarg2   .double    0               #real arg 2
#       iarg1   .long      0               #integer arg 1
#               ends
#
#               The pointer to the result area could be loaded with:
#
#               sload   fs, edi, [ebp].presult
#
#               The pointer to the type table would be loaded by
#               double indexing:
#
#               sload   fs, ecx, [ebp].pmisc
#               sload   fs, ecx, sfs:[ecx].ptyptab
#


#
# Simple names for datatypes.  Performs a lookup in SPITBOL's type
# table to fetch a 32-bit type word for specific data types.
#
# The address of SPITBOL's type table is passed to the function on the
# stack in ptyptab (see above).  Prior to using these symbols, a
# pointer to this table must be loaded into the registers.  These equates
# assume that the pointer has been loaded into DS:[ECX].  There is nothing
# special about these registers, and any others could be used
# provided the equates are modified.
#
# Note:  This DOES NOT work in the GNU assembler.  It generates the error message
#         Error: can't make global register symbol `xx'
#        for each line.  Nor can it be made into a macro, because macro expansion only
#        occurs for macros that appear in the opcode field.
#
#        Users will just have to use the expansion expression explicitly in code.
#
                                         #data types in type table at DS:[ECX]
#ar      =       [ecx+BL_AR*4]           # Array
#bc      =       [ecx+BL_BC*4]           # Buffer Control
#bf      =       [ecx+BL_BF*4]           # String Buffer
#cd      =       [ecx+BL_CD*4]           # Code
#ex      =       [ecx+BL_EX*4]           # Expression
#ic      =       [ecx+BL_IC*4]           # Integer
#nm      =       [ecx+BL_NM*4]           # Name
#rc      =       [ecx+BL_RC*4]           # Real
#sc      =       [ecx+BL_SC*4]           # String
#tb      =       [ecx+BL_TB*4]           # Table
#vc      =       [ecx+BL_VC*4]           # Vector
#xn      =       [ecx+BL_XN*4]           # External

#
# Non-standard block-type values that may be returned in register EAX.
#
FAIL    =       -1                      # Signal function failure
BL_NC   =       100                     # Unconverted result
BL_FS   =       101                     # Pointer to string
BL_FX   =       102                     # Pointer to external block

#
# Length of string area in result buffer
#
buflen  =       512


# Vectors to real number functions.
#
# Reals are 8-byte, double-precision reals in IEEE format.
# Integers (for fix and float) are 32-bit two's complement numbers.
#
# Function arguments are pushed onto the stack left-to-right.  With 8-byte
# reals, the most-significant half (MSH) is pushed first.  Note that this
# differs from standard C calling conventions.
#
# Integer results are returned in EAX.  Real results are returned in
# EDX:EAX  (EDX = MSH, EAX = LSH).
#
# The caller is responsible for removing arguments from the stack
# after the function returns.
#
# Functions taking two arguments, such as r_sub(r1,r2) order their
# operations as r1-r2.
#
# The address of a table of dispatch vectors is passed to the external
# function on the stack in pflttab (see above).  These =  ates assume
# that a pointer to the table has been loaded into DS:[EBX] by your code.
#
# Using the example above, this might be done with the following:
#
#                       sload   ds, ebx, [ebp].pmisc
#                       sload   ds, ebx, [ebx].pflttab
#
#
# The real functions preserve EBX, ESI, EDI and EBP, and may destroy
# EAX, ECX, and EDX.
#
# Example.  Divide the real number in location r1 by the number in r2, and
#           store the result in r3:
#
#       spush   ds                      #save our DS
#       push    dword ptr r1+4          #push first arg, msh
#       push    dword ptr r1            #push first arg, lsh
#       push    dword ptr r2+4          #push second arg, msh
#       push    dword ptr r2            #push second arg, lsh
#       sload   ds,ebx,[ebp].pmisc      #get address of miscinfo area
#       sload   ds,ebx,[ebx].pflttab    #get address of vector table
#       r_div                           #perform division
#       add     esp, 2*8                #remove arguments
#       spop    ds                      #restore our DS
#       mov     dword ptr r3, eax       #store result lsh
#       mov     dword ptr r3+4, edx     #store result msh
#
#
#
        .macro  fix
        call    [ebx+ 0*cbrptr]           # real to integer        i = fix(r)
        .endm
        .macro  float
        call    [ebx+ 1*cbrptr]           # integer to real        r = float(i)
        .endm
        .macro  r_add
        call    [ebx+ 2*cbrptr]           # real addition          r = r_add(r1,r2)
        .endm
        .macro  r_sub
        call    [ebx+ 3*cbrptr]           # real subtraction       r = r_sub(r1,r2)
        .endm
        .macro  r_mul
        call    [ebx+ 4*cbrptr]           # real multiplication    r = r_mul(r1,r2)
        .endm
        .macro  r_div
        call    [ebx+ 5*cbrptr]           # real division          r = r_div(r1,r2)
        .endm
        .macro  r_neg
        call    [ebx+ 6*cbrptr]           # real negation          r = r_neg(r)
        .endm
        .macro  r_atn
        call    [ebx+ 7*cbrptr]           # real arc tangent       r = r_atn(r)
        .endm
        .macro  r_chp
        call    [ebx+ 8*cbrptr]           # real chop              r = r_chp(r)
        .endm
        .macro  r_cos
        call    [ebx+ 9*cbrptr]           # real cosine            r = r_cos(r)
        .endm
        .macro  r_etx
        call    [ebx+10*cbrptr]           # real e to the x        r = r_etx(r)
        .endm
        .macro  r_lnf
        call    [ebx+11*cbrptr]           # real natural logarithm r = r_lnf(r)
        .endm
        .macro  r_sin
        call    [ebx+12*cbrptr]           # real sine              r = r_sin(r)
        .endm
        .macro  r_sqr
        call    [ebx+13*cbrptr]           # real square root       r = r_sqr(r)
        .endm
        .macro  r_tan
        call    [ebx+14*cbrptr]           # real tangent           r = r_tan(r)
        .endm

.list
#-------------------------- End of extrn386.inc -----------------------------
