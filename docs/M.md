## Introduction

The implementation of MACRO SPITBOL is written in three languages:
MINIMAL, C, and assembler.

The SPITBOL compiler and runtime is written in MINIMAL, a
machine-independent portable assembly language.

The runtime is augmented by procedures written in C that
collectively comprise OSINT (Operating System INTerface). These
procedures provides such functions as input and output, system
initialization and termination, management of UNIX pipes, the loading
of external functions, and so forth.

 The implementation also includes assembly code. This size of this
code varies according to the target machine. About 1500 lines are
needed for the x86 architecture running UNIX. This code provides such
functions as macros that define the translation of MINIMAL
instructions that take more than a few machine-level instructions,
support for calling C procedures from MINIMAL, for calling MINIMAL
procedures from C, for creating save files and load modules, and for
resuming execution from save files or loand load modules.

To give some idea of the flavor of the code, consider the following simple
SPITBOL program that copies standard input to standard output.

```
loop output = input :s(loop)
end
```

By default, the variable _input_ is input-associated to standard input, so each attempt to get its value results in reading in a line from standard input and returning the line as a string.
The read fails if there are no more lines, and succeeds otherwise.


Similarly, the variable _output_ is output-associated with standard
output, so each assignment to _output_ causes the assigned value to be
written to the standard output file.

The osint procedure for writing a line is *SYSOU*. It is called from within SPITBOL as part of assignment, as shown in the follwing excerpt
from the MINIMAL source:

```
*      here for output association

asg10  bze  kvoup,asg07      ignore output assoc if output off
asg1b  mov  xr,xl            copy trblk pointer
       mov  trnxt(XR),xr     point to next trblk
       beq  (XR),=b_trt,asg1b loop back if another trblk
       mov  xl,xr            else point back to last trblk
.if    .cnbf
       mov  trval(XR),-(XS)  stack value to output
.else
       mov  trval(XR),xr     get value to output
       beq  (XR),=b_bct,asg11 branch if buffer
       mov  xr,-(XS)         stack value to output
.fi
       JSR  gtstg            convert to string
       PPM  asg12            get datatype name if unconvertible

*      merge with string or buffer to output in xr

asg11  mov  trfpt(XL),wa     FCBLK ptr
       bze  wa,asg13         jump if standard output file

*      here for output to file

asg1a  JSR  sysou            call system output routine
       err  206,output caused file overflow
       err  207,output caused non-recoverable error
       exi                   else all done, return to caller
```

From the OSINT C code (the C procedure name starts with 'z' since there is some
needed intermediate code (shown below) to go from MINIMAL to C at runtime):


```
zysou()
{
    REGISTER struct FCBLK *fcb = WA(struct FCBLK *);
    REGISTER union block *blk = XR(union block *);
    int result;

    if (blk->scb.typ == type_scl) {
	/* called with string, get length from SCBLK */
	SET_WA(blk->scb.len);
    } else {
	/* called with buffer, get length from BCBLK, and treat BSBLK
	 * like an SCBLK
	 */
	SET_WA(blk->bcb.len);
	SET_XR(blk->bcb.bcbuf);
    }

    if (fcb == (struct FCBLK *) 0 || fcb == (struct FCBLK *) 1) {
	if (!fcb)
	    result = zyspi();
	else
	    result = zyspr();
	if (result == EXI_0)
	    return EXI_0;
	else
	    return EXI_2;
    }

    /* ensure iob is open, fail if unsuccessful */
    if (!(MK_MP(fcb->iob, struct ioblk *)->flg1 & IO_OPN)) {
	 return EXI_1;
    }

    /* write the data, fail if unsuccessful */
    if (oswrite
	(fcb->mode, fcb->rsz, WA(word), MK_MP(fcb->iob, struct ioblk *),
	 XR(struct scblk *)) != 0)
	 return EXI_2;

    /* normal return */
    return EXI_0;
}
```

Here is a fragment of the assembly code that is used to
call a C procedure from MINIMAL. The code is  for 32-bit X86
and is written using NASM (Netwide Assembler) syntax.

```
	%macro	mtoc	1
	extern	%1
	; save minimal registers to make their values available to called procedure
	mov     dword [reg_wa],ecx
        mov     dword [reg_wb],ebx
        mov     dword [reg_wc],edx	; (also reg_ia)
        mov     dword [reg_xr],edi
        mov     dword [reg_xl],esi
        mov     dword [reg_cp],ebp	; Needed in image saved by SYSXI
        call    %1			; call c interface function
;       restore minimal registers since called procedure  may have changed them
        mov     ecx, dword [reg_wa]	; restore registers
        mov     ebx, dword [reg_wb]
        mov     edx, dword [reg_wc]	; (also reg_ia)
        mov     edi, dword [reg_xr]
        mov     esi, dword [reg_xl]
        mov     ebp, dword [reg_cp]
;	restore direction flag in (the unlikely) case that it was changed
        cld
;	note that the called procedure must return exi action in eax
	ret
	%endmacro

  ...

	global	sysou			; output record
sysou:
	mtoc	zysou
```

The remainder of this document consists of text that was formerly
part of the source code for the MACRO SPITBOL compiler. It was converted
from plain text to HTML by Dave Shields.

## MINIMAL -- Machine Independent Macro Assembly Language



The following sections describe the implementation language originally
developed for SPITBOL but now more widely used.
MINIMAL (Machine Independent Macro Assembly Language) is an assembly
language for an idealized machine. The following describes the basic
characteristics of this machine.

### Configuration Parameters



There are several parameters which may vary with the target machine.
the macro-program is independent of the actual definitions of these
parameters.



The definitions of these parameters are supplied by the translation
program to match the target machine.

*   CFP$A

Number of distinct characters in internal alphabet in the range 64
le CFP$A le MAXLEN.

*   CFP$B

Number of bytes in a word where a byte is the amount of storage
addressed by the least significant address bit.

*   CFP$C

 Number of characters which can be stored in a single word.

*   CFP$F

Byte offset from start of a string block to the first character.
depends both on target machine and string data structure. see
PLC instruction.

*   CFP$I

Number of words in a signed integer constant

*   CFP$L

The largest unsigned integer of form 2n - 1 which can be stored
in a single word.  n will often be CFP$N but need not
be.

*   CFP$M

The largest positive signed integer of form 2n - 1 which can be
stored in a single word.  n will often be CFP$N -1
but need not be.

*   CFP$N

 Number of bits which can be stored in a one word bit string.

*   CFP$R

 Number of words in a real constant

*   CFP$S



Number of significant digits to be output in conversion of a real
quantity.  .if .CNCR .else the integer consisting of this number of 9s
must not be too large to fit in the integer accum.  .fi

```
.if    .cucf
       CFP$U                  realistic upper bound on alphabet.


.fi
       CFP$X                  number of digits in real exponent
```


### Memory



Memory is organized into words which each contain
CFP$B bytes. for word machines CFP$B
, which is a configuration parameter, may be one in which case words
and bytes are identical. To each word corresponds an address which is
a non-negative quantity which is a multiple of CFP$B
.  Data is organized into words as follows.



* A signed integer value occupies CFP$I consecutive
words (CFP$I is a configuration parameter).  The
range may include more negative numbers than positive (e.g. the twos
complement representation).

* A signed real value occupies CFP$R consecutive
words. (CFP$R is a configuration parameter).

*   CFP$C characters may be stored in a single word
(CFP$C is a configuration parameter).

*   A bit string containing CFP$N bits can be stored in a
single word (CFP$N is a configuration parameter).


*   A word can contain a unsigned integer value in the range (0 le n le
CFP$L . These integer values may represent addresses
of other words and some of the instructions use this fact to provide
indexing and indirection facilities.

*   Program instructions occupy
words in an undefined manner. Depending on the actual implementation,
instructions may occupy several words, or part of a word, or even be
split over word boundaries.



The following regions of memory are available to the program. each
region consists of a series of words with consecutive addresses.


1   constant section ---            assembled constants

2   working storage section ---    assembled work areas

3   program section ---            assembled instructions

4   stack area ---                 allocated stack area

5   data area ---                  allocated data area


### Registers


There are three index registers called XR
,XL ,and XS . In addition
XL may sometimes be referred to by the alias of XT -
see section 4. Any of the above registers may hold a positive unsigned
integer in the range (0 le n le CFP$L). When the
index register is used for indexing purposes, this must be an appropriate address.
XS is special in that it is
used to point to the top item of a stack in memory. The stack may
build up or down in memory.since it is required that
XS points to the stack top but access to items below
the top is permitted, registers XS and XT may be used
with suitable offsets to index stacked items. only XS
and XT may be used for this purpose since the direction of the offset
is target machine dependent. XT is a synonym for XL
which therefore cannot be used in code sequences referencing *XT*.

The stack is used for subroutine linkage and temporary data storage for which
the stack arrangement is suitable.  XR
and XL can also contain a character pointer in
conjunction with the character instructions (see description of PLC).

There are three work registers called WA,WB, and WC, which can contain any data item which can be
stored in a single memory word. In fact, the work registers are just
like memory locations except that they have no addresses and are
referenced in a special way by the instructions.



Note that registers WA and WB have special uses in connection with the CVD,CVM, MVC MVW MWB, CMC, and  TRC instructions.



Register WC may overlap the integer accumulator
(IA) in some implementations. thus any operation
changing the value in WC leaves (IA
) undefined and vice versa except as noted in the following
restriction on simple dump/restore operations.


```
           restriction
           -----------

       if IA  and WC  overlap then
           sti  iasav
           ldi  iasav
       does not change WC, and
           mov  WC ,WC sav
           mov  WC sav,WC
       does not change IA .
```



There is an integer accumulator (IA) which is
capable of holding a signed integer value (CFP$I
words long).  register WC may overlap the integer
accumulator (IA) in some implementations. thus any
operation changing the value in WC leaves
(IA) undefined and vice versa except as noted in the
above restriction on simple dump/restore operations.

There is a single real accumulator (RA ) which can
hold any real value and is completely separate from any of the other
registers or program accessible locations.

The code pointer register CP is a special index
register for use in implementations of interpretors.  it is used to
contain a pseudo-code pointer and can only be affected by
ICP , LCP , SCP, and LCW instructions.

### The Stack

The following notes are to guide both implementors of systems written
in MINIMAL and MINIMAL programmers in dealing with stack manipulation.
implementation of a downwards building stack is easiest and in general
is to be preferred, in which case it is merely necessary to consider
*XT* as an alternative name for XL .

The MINIMAL virtual machine includes a stack and has operand formats
-(XS) and (XS)+ for pushing and
popping items with an implication that the stack builds down in memory
(a _d-stack_). however on some target machines it is better for the
stack to build up (a _u-stack_).

A stack addressed only by push and pop
operations can build in either direction with no complication but such
a pure scheme of stack access proves restrictive.  Hence it is
permitted to access buried items using an integer offset past the
index register pointing to the stack top. on target machines this
offset will be positive/negative for d-stacks/u-stacks and this must
be allowed for in the translation.

A further restriction is that at
no time may an item be placed above the stack top. For some operations
this makes it convenient to advance the stack pointer and then address
items below it using a second index register.  The problem of signed
offsets past such a register then arises. to distinguish stack
offsets, which in some implementations may be negative, from non-stack
offsets which are invariably positive, XT, an alias or synonym for
XL is used.

For a u-stack implementation, the MINIMAL
translator should negate the sign of offsets applied to both
(XS) and (XT).  Programmers should note that since
XT is not a separate register, XL should not be used
in code where XT is referenced. Other modifications needed in u-stack
translations are in the ADD SUB
ICA DCA opcodes applied to
XS , XT. For example

```
       MINIMAL           d-stack trans.  u-stack trans.

       mov  WA,-(XS)     sbi  XS ,1       adi  XS ,1
                         sto  WA,(XS)     sto  WA,(XS)
       mov  (XT)+,WC     lod  WC ,(XL)    lod  WC ,(XL)
                         adi  XL ,1       sbi  XL ,1
       add  XS,=seven      adi  XS ,7     sbi  XS ,7
       mov  2(XT),WA     lod  WA,2(XL)    lod  WA,-2(XL)
       ica  XS           adi  XS ,1       sbi  XS ,1

       Note that forms such as

       mov  -(XS),WA
       add  (XS),WA

are illegal, since they assume information storage above the stack top.
```

### Internal Character Set

The internal character set is represented by a set of contiguous codes
from 0 to CFP$A-1 . The codes for the digits 0-9 must
be contiguous and in sequence. Other than this, there are no
restraints.

The following symbols are automatically defined to have the value of
the corresponding internal character code.

```
       ch$la                 letter a
       ch$lb                 letter b
       .                     .
       ch$l$                 letter z

       ch$d0                 digit 0
       .                     .
       ch$d9                 digit 9

       ch$am                 ampersand
       ch$as                 asterisk
       ch$at                 at
       ch$bb                 left bracket
       ch$bl                 blank
       ch$br                 vertical bar
       ch$d0                 digit 0
       .                     .
       ch$d9                 digit 9

       ch$am                 ampersand
       ch$as                 asterisk
       ch$at                 at
       ch$bb                 left bracket
       ch$bl                 blank
       ch$br                 vertical bar
       ch$cl                 colon
       ch$cm                 comma
       ch$dl                 dollar sign
       ch$dt                 dot (period)
       ch$dq                 double quote
       ch$eq                 equal sign
       ch$ex                 exclamation mark
       ch$mn                 minus
       ch$nm                 number sign
       ch$nt                 not
       ch$pc                 percent
       ch$pl                 plus
       ch$pp                 left paren
       ch$rb                 right bracket
       ch$rp                 right paren
       ch$qu                 question mark
       ch$sl                 slash
       ch$sm                 semi-colon
       ch$sq                 single quote
       ch$un                 underline
```


The following optional symbols are incorporated by defining the
conditional assembly symbol named.

```
       26 shifted letters incorporated by defining .casl

       ch$$a                 shifted a
       ch$$b                 shifted b
       .                     .
       ch$$$                 shifted z

       ch$ht                 horizontal tab - define .caht
       ch$vt                 vertical tab   - define .cavt
       ch$ey                 up arrow       - define .caex
```

## Conditional Assembly Features



Some features of the interpreter are applicable to only certain target
machines. they may be incorporated or omitted by use of conditional
assembly. The full form of a condition is -

```
       .if    conditional assembly symbol    (cas)
       .then
              minimal statements1   (ms1)
       .else
              minimal statements2   (ms2)
       .fi
```
       The following rules apply


1   The directives .IF   .THEN,   .ELSE, and .FI must
            start in column 1.

2      The conditional assembly symbol must start with a
            dot in column 8 followed by 4 letters or digits e.g.
```
               .ca$1
```

3 THEN is redundant and may be omitted if wished.

4 _ms1_, _ms2_ are arbitrary sequences of MINIMAL
            statements either of which may be null or may
            contain further conditions.

5 If _ms2_ is omitted, .ELSE may also be omitted.

6 .*fi* is required.

7 Conditions may be nested to a depth determined
            by the translator (not less than 20, say).

Selection of the alternatives _ms1_, _ms2_ is by means of the
       define and undefine directives of form -

```
       .DEF   _cas_
       .UNDEF _cas_
```

Which obey rules 1. and 2. above and may occur at any point in a
MINIMAL program, including within a condition.  Multiply defining a
symbol is an error.  Undefining a symbol which is not defined is not
an error.

The effect is that if a symbol is currently defined,
THEN in any condition depending on it, _ms1_ will be
processed and _ms2_ omitted. Conversely if it is undefined, _ms1_ will be
omitted and _ms2_ processed.


Nesting of conditions is such that conditions in a section not
selected for processing must not be evaluated. nested conditions must
remember their environment whilst being processed. Effectively this
implies use of a scheme based on a stack with if .FI matching by the
condition processor of the translator.

## Operand Formats

The following section describes the various possibilities for operands
of instructions and assembly operations.

```
      01   int              unsigned integer le CFP$L
      02   dlbl             symbol defined in definitions sec
      03   wlbl             label in working storage section
      04   clbl             label in constant section
      05   elbl             program section entry label
      06   plbl             program section label (non-entry)
      07   x                one of the three index registers
      08   w                one of the three work registers
      09   (x)              location indexed by x
      10   (x)+             like (x) but post increment x
      11   -(x)             like (x) but predecrement x
      12   int(x)           location int words beyond addr in x
      13   dlbl(x)          location dlbl words past addr in x
      14   clbl(x)          location (x) bytes beyond clbl
      15   wlbl(x)          location (x) bytes beyond wlbl
      16   integer          signed integer (dic)
      17   real             signed real (drc)
      18   =dlbl            location containing dac dlbl
      19   *dlbl            location containing dac CFP$Bdlbl
      20   =wlbl            location containing dac wlbl
      21   =clbl            location containing dac clbl
      22   =elbl            location containing dac elbl
      23   pnam             procedure label (on prc instruc)
      24   eqop             operand for equ instruction
      25   ptyp             procedure type (see prc)
      26   text             arbitrary text (erb,err,ttl)
      27   dtext            delimited text string (dtc)
```

The numbers in the above list are used in subsequent description and
in some of the MINIMAL translators.


The following special symbols refer to a collection of the listed
possibilities


*   _val_  01,02

    predefined value

_val_ is used to refer to a predefined one word integer value in the
range 0 le n le CFP$L

*   reg  07,08

register



_reg_ is used to describe an operand which can be any of the
registers (XL, XR, XS ,XT, WA, WB, and WC ). Such an operand can hold
a one word integer (address).

* _opc_  09,10,11

                   character



_opc_ is used to designate a specific character operand for use
in the LCH and SCH instructions.
the index register referenced must be either XR or
XL (not XS ,XT). see section on
character operations.

* _ops_  03,04,09,12,13,14,15

       memory reference



_ops_ is used to describe an operand which is in memory. the
operand may be one or more words long depending on the data type. In
the case of multiword operands, the address given is the first word.

* _opw_  as for  _ops_ + 08,10,11

      full word



_opw_ is used to refer to an operand whose capacity is that of
a full memory word.  _opw_ includes all the possibilities for
_ops_ (the referenced word is used) plus the use of one of the
three work registers (WA,WB, and WC ).
in addition, the formats (X)+ and -(X) allow indexed operations in
which the index register is popped by one word after the reference
(X)+, or pushed by one word before the reference -(X) these latter two
formats provide a facility for manipulation of stacks. the format does
not imply a particular direction in which stacks must build - it is
used for compactness.

Note that there is a restriction which disallows
an instruction to use an index register in one of these formats in
some other manner in the same instruction.  e.g.  MOV
XL ,(XL)+ is illegal.  The formats
-(X) and (X)+ may also be used in pre-decrementation,
post-incrementation to access the adjacent character of a string.

* _opn_  as for  _opw_ + 07

            one word integer



_opn_ is used to represent an operand location which can
contain a one word integer (e.g. an address).  This includes all the
possibilities for _opw_ plus the use of one of the index
registers (XL ,XR, XT, and XS). The range of integer
values is 0 le n le CFP$L

* _opv_  as for  _opn_ + 18-22

         one word integer value



_opv_ is used for an operand which can yield a one word integer
value (e.g. an address). It includes all the possibilities for
_opn_ (the current value of the location is used) plus the use
of literals.

Note that although the literal formats are described in
terms of a reference to a location containing an address constant,
This location may not actually exist in some implementations since
only the value is required. A restriction is placed on literals which
may consist only of defined symbols and certain labels. Consequently
small integers to be used as literals must be pre-defined, a
discipline aiding program maintenance and revision.


* _addr_ 01,02,03,04,05

address



_addr_ is used to describe an explicit address value (one word integer
value) for use with DAC

```

            ************************************************
            *   in the following descriptions the usage --     *
            *      (XL ),(XR ), ... ,(IA)                        *
            *   in the descriptive te*XT* signifies the          +
            *   contents of the stated register.               *
            ************************************************
```


## Instruction Mnemonics



The following list includes all instruction and assembly operation
mnemonics in alphabetical order.  The mnemonics are preceded by a
number identifying the following section where the instruction is
described.  An asterisk is appended to the mnemonic if the last operand
may optionally be omitted.  See section -15- for details of statement
format and comment conventions.





|  sec|opcode|operands|description|
| ----- | ---- | ---------------|-------------------------------------------------|
| 2.1|add|opv,opn|add address|
| 4.2|adi|ops|add integer|
| 5.3|adr|ops|add real|
| 7.1|anb|opw,w|and bit string|
| 2.17|aov|opv,opn,plbl|add address, fail if overflow|
| 5.16|atn| |arctangent of real accum|
| 2.16|bct|w,plbl|branch and count|
| 2.5|beq|opn,opv,plbl|branch if address equal|
| 2.18|bev|opn,plbl|branch if address even|
| 2.8|bge|opn,opv,plbl|branch if address greater or equl|
| 2.7|bgt|opn,opv,plbl|branch if address greater|
| 2.12|bhi|opn,opv,plbl|branch if address high|
| 2.10|ble|opn,opv,plbl|branch if address less or equal|
| 2.11|blo|opn,opv,plbl|branch if address low|
| 2.9|blt|opn,opv,plbl|branch if address less than|
| 2.6|bne|opn,opv,plbl|branch if address not equal|
| 2.13|bnz|opn,plbl|branch if address non-zero|
| 2.19|bod|opn,plbl|branch if address odd|
| 1.2|brn|plbl|branch unconditional|
| 1.7|bri|opn|branch indirect|
| 1.3|bsw!|x,val,plbl|branch on switch value|
| 8.2|btw|reg|convert bytes to words|
| 2.14|bze|opn,plbl|branch if address zero|
| 6.6|ceq|opw,opw,plbl|branch if characters equal|
| 10.1|chk| | check stack overflow|
| 5.17|chp| | integer portion of real accum|
| 7.4|cmb|w|complement bit string|
| 6.8|cmc|plbl,plbl|compare character strings|
| 6.7|cne|opw,opw,plbl|branch if characters not equal|
| 6.5|csc|x|complete store characters|
| 5.18|cos| |cosine of real accum|
| 8.8|ctb|w,val|convert character count to bytes|
| 8.7|ctw|w,val|convert character count to words|
| 8.10|cvd| |convert by division|
| 8.9|cvm|plbl|convert by multiplication|
| 11.1|dac|addr|define address constant|
| 11.5|dbc|val|define bit string constant|
| 2.4|dca|opn|decrement address by one word|
| 1.17|dcv|opn|decrement value by one|
| 11.2|dic|integer|define integer constant|
| 11.3|drc|real|define real constant|
| 11.4|dtc|dtext|define text (character) constant|
| 4.5|dvi|ops|divide integer|
| 5.6|dvr|ops|divide real|
| 13.1|ejc| | eject assembly listing|
| 14.2|end| |end of assembly|
| 1.13|enp| | define end of procedure|
| 1.6|ent!|val|define entry point|
| 12.1|equ|eqop|define symbolic value|
| 1.15|erb|int,text|assemble error code and branch|
| 1.14|err|int,text|assemble error code|
| 1.5|esw| |end of switch list for bsw|
| 5.19|etx| |e to the power in the real accum|
| 1.12|exi!|int|exit from procedure|
| 12.2|exp| |define external procedure|
| 6.10|flc|w|fold character to upper case|
| 2.3|ica|opn|increment address by one word|
| 3.4|icp| |increment code pointer|
| 1.16|icv|opn|increment value by one|
| 4.11|ieq|plbl|jump if integer zero|
| 1.4|iff|val,plbl|specify branch for bsw|
| 4.12|ige|plbl|jump if integer non-negative|
| 4.13|igt|plbl|jump if integer positive|
| 4.14|ile|plbl|jump if integer negative or zero|
| 4.15|ilt|plbl|jump if integer negative|
| 4.16|ine|plbl|jump if integer non-zero|
| 4.9|ino|plbl|jump if no integer overflow|
| 12.3|inp|ptyp,int|internal procedure|
| 12.4|inr| |internal routine|
| 4.10|iov|plbl|jump if integer overflow|
| 8.5|itr| | convert integer to real|
| 1.9|JSR|pnam|call procedure|
| 6.3|lch|reg,opc|load character|
| 2.15|lct|w,opv|load counter for loop|
| 3.1|lcp|reg|load code pointer register|
| 3.3|lcw|reg|load next code word|
| 4.1|ldi|ops|load integer|
| 5.1|ldr|ops|load real|
| 1.8|lei|x|load entry point id|
| 5.20|lnf| | natural logorithm of real accum|
| 7.6|lsh|w,val|left shift bit string|
| 7.8|lsx|w,(x)|left shift indexed|
| 9.4|mcb| |move characterswords backwards|
| 8.4|mfi!|opn,plbl|convert (IA) to address value|
| 4.3|mli|ops|multiply integer|
| 5.5|mlr|ops|multiply real|
| 1.19|mnz|opn|move non-zero|
| 1.1|mov|opv,opn|move|
| 8.3|mti|opn|move address value to (IA)|
| 9.1|mvc| |move characters|
| 9.2|mvw| |move words|
| 9.3|mwb| |move words backwards|
| 4.8|ngi| |negate integer|
| 5.9|ngr| |negate real|
| 7.9|nzb|w,plbl|jump if not all zero bits|
| 7.2|orb|opw,w|or bit strings|
| 6.1|plc!|x,opv|prepare to load characters|
| 1.10|PPM!|plbl|provide procedure exit parameter|
| 1.11|prc|ptyp,val|define start of procedure|
| 6.2|psc!|x,opv|prepare to store characters|
| 5.10|req|plbl|jump if real zero|
| 5.11|rge|plbl|jump if real positive or zero|
| 5.12|rgt|plbl|jump if real positive|
| 5.13|rle|plbl|jump if real negative or zero|
| 5.14|rlt|plbl|jump if real negative|
| 4.6|rmi|ops|remainder integer|
| 5.15|rne|plbl|jump if real non-zero|
| 5.8|rno|plbl|jump if no real overflow|
| 5.7|rov|plbl|jump if real overflow|
| 7.5|rsh|w,val|right shift bit string|
| 7.7|rsx|w,(x)|right shift indexed|
| 8.6|rti!|plbl|convert real to integer|
| 1.22|rtn| |define start of routine|
| 4.4|sbi|ops|subtract integer|
| 5.4|sbr|ops|subtract reals|
| 6.4|sch|reg,opc|store character|
| 3.2|scp|reg|store code pointer|
| 14.1|sec| |define start of assembly section|
| 5.21|sin| |sine of real accum|
| 5.22|sqr| |square root of real accum|
| 1.20|ssl|opw|subroutine stack load|
| 1.21|sss|opw|subroutine stack store|
| 4.7|sti|ops|store integer|
| 5.2|str|ops|store real|
| 2.2|sub|opv,opn|subtract address|
| 5.23|tan| |tangent of real accum|
| 6.9|trc| |translate character string|
| 13.2|ttl|text|supply assembly title|
| 8.1|wtb|reg|convert words to bytes|
| 7.3|xob|opw,w|exclusive or bit strings|
| 1.18|zer|opn|zeroise integer location|
| 7.11|zgb|opn|zeroise garbage bits|
| 7.10|zrb|w,plbl|jump if all zero bits|

### MINIMAL Instructions


The following descriptions assume the definitions -

```
       zeroe  equ 0
       unity  equ 1
```

#### 1-  Basic Instruction Set

*   1.1  MOV   _opn,opv_  move one word value

MOV causes the value of operand _opv_ to be
set as the new contents of operand location _opn_. In the case
where _opn_ is not an index register, any value which can
normally occupy a memory word (including a part of a multiword real or
integer value) can be transferred using MOV. If the
target location _opn_ is an index register,
then _opv_ must specify an appropriate one
word value or operand containing such an appropriate value.

* 1.2  BRN  _plbl_    unconditional branch

BRN causes control to be passed to the indicated
label in the program section.

*   1.3  BSW  _x,val,plbl_    branch on switch value

* 1.4  IFF  _val,plbl_        provide branch for switch

```
            IFF  val,_plbl_     ...
            ...
            ...
```

*   1.5  ESW      end of branch switch table


BSW IFF,ESW provide a capability for
a switched branch similar to a fortran computed goto. The _val_ on the
BSW instruction is the maximum number of branches.
the value in x ranges from zero up to but not including this maximum.
each IFF provides a branch.

_val_ must be less than
that given on the bsw and control goes to _plbl_ if the value
in x matches.  If the value in x does not correspond to any of the
IFF entries, then control passes to
the _plbl_ on the BSW.

The  _plbl_ operand may be omitted if there are no values missing from the list.

IFF and ESW may only be used in this
contextxt.  Execution of BSW may destroy the contents
of _x_.

The IFF entries may be in any order and since a translator may thus need to store and sort them, the comment field
is restricted in length (sec 11).

*   1.6  ENT  _val_ define program entry point

The symbol appearing in the label field is defined to be a program
entry point which can subsequently be used in conjunction with the
BRI instruction, which provides the only means of
entering the code. It is illegal to fall into code identified by an
entry point. the entry symbol is assigned an address which need not be
a multiple of CFP$B but which must be in the range 0
le CFP$L and the address must not lie within the
address range of the allocated data area.  Furthermore, addresses of
successive entry points must be assigned in some ascending sequence so
that the address comparison instructions can be used to test the order
in which two entry points occur. The symbol _val_ gives an identifying
value to the entry point which can be accessed with the
LEI instruction.



Note - subject to the restriction below, _val_ may be omitted if no such
identification is needed i.e.
If no LEI references
the entry point. For this case, a translation optimisation is possible
in which no memory need be reserved for a null identification which is
never to be referenced, but only provided this is done so as not to
interfere with the strictly ascending sequence of entry point
addresses. To simplify this optimisation for all implementors, the
following restriction is observed

<blockquote>
                 _val_ may only be omitted if the entry point is
                 separated from a following entry point by a
                 non-null MINIMAL code sequence.
</blockquote>



Entry point addresses are accessible only by use of literals
(=_elbl_, section 7) or DAC constants (section
8-11.1).

*   1.7  BRI   _opn_      branch indirect

_opn_ contains the address of a program entry point (see ent).
control is passed to the executable code starting at the entry point
address.  _opn_ is left unchanged.

*   1.8  LEI  _x_         load entry point identification

X contains the address of an entry point for which an identifying
value was given on the the ENT line.
LEI replaces the contents of _x_ by this value.

*   1.9  JSR  _pnam_      call procedure _pnam_

*   1.10 PPM  _plbl_      provide exit parameter

```
            PPM  _plbl_         ...
            ...
            PPM  _plbl_         ...
```

JSR causes control to be passed to the named
procedure. _pnam_ is the label on a PRC
statement elsewhere in the program section (see prc) or has been
defined using an *exp* instruction.

The
PPM exit parameters following the call give names of
program locations (_plbl_-s) to which alternative
EXI returns of the called procedure may pass control.

They may optionally be replaced by error returns (see err). the number
of exit parameters following a JSR must equal the int
in the procedure definition.

The operand of PPM may
be omitted if the corresponding EXI return is certain
not to be taken.

*   1.11 PRC  _ptyp,int_  define start of procedure

The symbol appearing in the label field is defined to be the name of a
procedure for use with JSR a procedure is a
contiguous section of instructions to which control may be passed with
a JSR instruction.

This is the only way in which the instructions in a
procedure may be executed.

It is not permitted to fall into a
procedure.  All procedures should be named in section 0
INP statements.

_int_ is the number of exit parameters (PPM-s) to be used in
JSR calls.

There are three possibilities for _ptyp_, each consisting of a
single letter as follows.


*  r    recursive

The return point (one or more words) is stored on the stack as though
one or more MOV ...,-(XS )

*   n   non non-recursive

The return point is to be stored either (1) in a local storage word
associated with the procedure and not directly available to the
program in any other manner or (2) on a subroutine link stack quite
distinct from the MINIMAL stack addressed by XS .

It is an error to use the stack for n-links, since procedure parameters
or results may be passed via the stack.

If method (2) is used for links, error exits (erb,err) from a
procedure will necessitate link stack resetting. The
SSL and SSS orders provided for this
may be regarded as no- _ops_ for implementations using method
(1).


* either


The return point may be stored in either manner according to
efficiency requirements of the actual physical machine used for the
implementation.

Note that programming of _e_ type procedures must be
independent of the actual implementation.

The actual form of the return point is undefined.  However, each word
stored on the stack for an r-type call must meet the following
requirements.

1   It can be handled as an address and placed in an index register.


When used as an operand in an address comparison instruction, it must
not appear to lie within the allocated data area.

2   It is not required to appear to lie within the program section.

*   1.12 EXI  _int_       exit from procedure


The PPM and ERR parameters following
a JSR are numbered starting from 1.

EXI int causes control to be returned to the int-th
such param. EXI 1 gives control to the _plbl_
of the first PPM after the JSR if
int is omitted, control is passed back past the last exit parameter
(or past the * JSR* if there are none).

For _r and_ _e_
type procedures, the stack pointer XS must be set to
its appropriate entry value before executing an EXI
instruction.

In this case, EXI removes return points
from the stack if any are stored there so that the stack pointer is
restored to its calling value.

*   1.13 ENP  define end of procedure body



ENP delimits a procedure body and may not actually be
executed, hence it must have no label.

*   1.14 ERR  _int,text_  provide error return



ERR may replace an exit parameter (PPM) in any
procedure call. the int argument is a unique error code in 0 to 899.

The text supplied as the other operand is arbitrary text in the
FORTRAN character set and may be used in constructing a file of error
messages for documenting purposes or for building a direct access or
other file of messages to be used by the error handling code.

In the event that an EXI attempts to return control via an
exit parameter to an ERR control is instead passed to
the first instruction in the error section (which follows the program
section) with the error code in WA.

*   1.15 ERB  _int,text_  error branch

This instruction resembles ERR except that it may
occur at any point where a branch is permitted.  It effects a transfer
of control to the error section with the error code in WA.

*   1.16 ICV   _opn_  increment value by one

ICV increments the value of the operand by unity.  it
is equivalent to ADD _opn_,=unity

*   1.17 DCV   _opn_      decrement value by one

DCV decrements the value of the operand by unity.  It
is equivalent to SUB _opn=unity_

*   1.18 ZER   _opn_ zeroise  _opn_

ZER is equivalent to MOV =zeroe,_opn_

*   1.19 MNZ   _opn_ move non-zero to  _opn_


Any non-zero collectable value may used, for which the opcodes *bnz/bze*
will branch/fail to branch.


*   1.20 SSL   _opw_      subroutine stack load

*   1.21 SSS   _opw_      subroutine stack store

This pair of operations is provided to make possible the use of a
local stack to hold subroutine (subroutine) return links for n-type
procedures.

    SSS stores the subroutine stack pointer in _opw_ and SSL loads the subroutine stack pointer from _opw_.

By using SSS in the main program or on entry to a procedure which should regain control on occurrence of an
ERR or ERB and by use of SSL in the error processing sections the subroutine stack
pointer can be restored giving a link stack cleaned up ready for resumed execution.

The form of the link stack pointer is undefined in MINIMAL (it is likely to be a private register known to the
translator) and the only requirement is that it should fit into a
single full word.

SSL and SSS are no-ops if no private link stack is not used.

*   1.22 RTN define start of routine


However it is entered by any type of conditional or unconditional branch (not by JSR).

On termination it passes control by a branch (often BRI through a code word) or even permits control to drop through to another routine.

No return link exists and the end of a routine is not marked by an explicit opcode (compare ENP).

All routines must be named in section 0 INR statements.  

#### 2-  Operations on One Word Integer Values (addresses)


*   2.1  ADD   _opn,opv_

Adds  _opv_ to the value in  _opn_ and stores the result in  _opn_. 
Undefined if the result exceeds CFP$L .

*   2.2  SUB   _opn,opv_



Subtracts _opv_ from _opn_, and stores the result in
_opn_. Undefined if the result is negative.

*   2.3  ICA   _opn_

Increment address in  _opn_
Equivalent to ADD  _opn_,*unity

*   2.4  DCA   _opn_

Decrement address in _opn_ equivalent to SUB
_opn_,*unity

*   2.5  BEQ   _opn,opv,plbl_

Branch to _plbl_  _opn_ eq  _opv_


*   2.6  BNE   _opn,opv,plbl_

Branch to _plbl_  _opn_ ne  _opv_

*   2.7  BGT   _opn,opv,plbl_


Branch to _plbl_  _opn_ gt  _opv_

*   2.8  BGE   _opn,opv,plbl_


Branch to _plbl_  _opn_ ge  _opv_

*   2.9  BLT   _opn,opv,plbl_

Branch to _plbl_  _opn_ lt  _opv_

*   2.10 BLE   _opn,opv,plbl_

Branch to _plbl_  _opn_ le  _opv_

*   2.11 BLO   _opn,opv,plbl_

Equivalent to BLT or ble

*   2.12 BHI   _opn,opv,plbl_

Equivalent to BGT or BGE


The above instructions compare two address values as unsigned integer
values.  The BLO and BHI instructions are used in cases where the equal condition either does
not occur or can result either in a branch or no branch.

This avoids inefficient translations in some implementations.

*   2.13 BNZ   _opn,plbl_

Equivalent to BNE  _opn_,=zeroe,_plbl_

*   2.14 BZE   _opn,plbl_

Equivalent to BEQ  _opn_,=zeroe,_plbl_

*   2.15 LCT  _w,opv_

Load counter for BCT

LCT loads a counter value for use with the BCT
instruction. The value in _opv_ is the number of loop
operations  to be executed.

The value in _w_ after this operation is an undefined one word integer quantity.

*   2.16 BCT  _w,plbl_

Branch and count

BCT uses the counter value in w to branch the required number of times and *then* finally to fall
through to the next instruction.

BCT can only be used following an appropriate LCT instruction.

The value in _w_ after execution of BCT is undefined.

*   2.17 AOV   _opn,opv,plbl_

ADD with carry test

Adds  _opv_ to the value in  _opn_ and stores result in _opn_.

Branches to _plbl_ result exceeds CFP$L with result in  _opn_ undefined. cf. ADD

*   2.18 BEV   _opn,plbl_

Branch even

*   2.19 BOD   _opn,plbl_

Branch odd

These operations are used only .cepp or .crpp is defined.

On some implementations, a more efficient implementation is possible by noting
that address of blocks must always be a multiple of
CFP$B. We call such addresses even.

Thus return
address on the stack (.crpp) and entry point addresses (.cepp) can be
distinguished from block addresses they are forced to be odd (not a
multiple of CFP$B ).  BEV and
BOD branch according as operand is even or odd,
respectively.

 #### 3- Operations on the Code Pointer Register

(CP )


The code pointer register provides a psuedo instruction counter for
use in an interpretor. It may be implemented as a real register or as
a memory location, but in either case it is separate from any other
register. the value in the code pointer register is always a word
address (i.e.  a one word integer which is a multiple of
CFP$B ).

*   3.1  LCP   _reg_

Load code pointer register

This instruction causes the code pointer register to be set from the
value in _reg_ which is unchanged

*   3.2  SCP   _reg_

Store code pointer register this instruction loads the current value
in the code pointer register into reg. (CP ) is unchanged.

*   3.3  LCW  _reg_

Load next code word

This instruction causes the word pointed to by CP to
be loaded into the indicated reg. The value in CP is
*then* incremented by one word.

Execution of LCW may destroy XL .

*   3.4  ICP

Increment CP  by one word

On machines with more than three index registers, CP
can be treated simply as an index register.  In this case, the
following equivalences apply:

```

            CP   _reg_ is like MOV reg,*CP*
            CP   _reg_ is like MOV *CP* ,_reg_
            LCW _reg_ is like MOV (CP )+,_reg_
            CP      is like ICA *CP*

```

Since LCW is allowed to destroy XL , the following implementation using a work location CP
$$$ can also be used.

```
            CP    _reg_         MOV  reg,*CP* $$$

            CP    _reg_         MOV  *CP* $$$,_reg_

            LCW   _reg_         MOV  CP $$$,XL
                             MOV  (XL )+,_reg_
                             MOV  XL ,CP $$$

            iCP               ICA  *CP* $$$
```

#### 4-  Operations on Signed Integer Values


*   4.1  LDI   _ops_

Load integer accumulator from  _ops_

*   4.2  ADI   _ops_

ADD  _ops_ to integer accumulator

*   4.3  MLI   _ops_

Multiply integer accumulator by  _ops_

*   4.4  SBI   _ops_

Subtract  _ops_ from int accumulator

*   4.5  DVI   _ops_

Divide integer accumulator by  _ops_

*   4.6  RMI   _ops_

Set integer accumulator to `mod(intacc,_ops_)`

*   4.7  STI   _ops_

Store integer accumulator at  _ops_

*   4.8  NGI

Negate the value in the integer accumulator (change its sign)

The equation satisfied by operands and results of DVI
and RMI is

```
            div = qot *  _ops_ + rem          where
            div = dividend in integer accumulator
            qot = quotient left in IA  by div
             _ops_ = the divisor
            rem = remainder left in IA  by rmi
```

The sign of the result of DVI is + (IA) and ( _ops_) have the same sign and is -
they have opposite signs.

The sign of (IA) is always used as the sign of the result of `rem`.

Assuming in each case that IA contains the number
specified in parentheses and that seven and msevn hold +7 and -7 resp.
the algorithm is illustrated below.


```
            (IA  = 13)
            DVI  seven       IA  = 1
            RMI  seven       IA  = 6
            DVI  msevn       IA  = -1
            RMI  msevn       IA  = 6
            (IA  = -13)
            DVI  seven       IA  = -1
            RMI  seven       IA  = -6
            DVI  msevn       IA  = 1
            RMI  msevn       IA  = -6
```

The above instructions operate on a full range of signed integer
values. with the exception of LDI and
STI these instructions may cause integer overflow by
attempting to produce an undefined or out of range result in which
case integer overflow is set, The result in (IA) is
undefined and the following instruction must be IOV
or INO.

Particular care may be needed on target machines having distinct overflow and divide by zero conditions.

*   4.9  INO  _plbl_

Jump to _plbl_ if no integer overflow

*   4.10 IOV  _plbl_

Jump to _plbl_ if integer overflow


These instructions can only occur immediately following an instruction
which can cause integer overflow (ADI, SBI MLI DVI RMI ngi)
and test the result of the preceding instruction.

IOV and INO may not have labels.

*   4.11 IEQ  _plbl_

Jump to _plbl_ if (IA) eq 0


*   4.12 IGE  _plbl_

Jump to _plbl_ if (IA) ge 0

*   4.13 IGT  _plbl_

Jump to _plbl_ if (IA) gt 0

*   4.14 ILE  _plbl_

Jump to _plbl_ if (IA) le 0


*   4.15 ILT  _plbl_

Jump to _plbl_ if (IA) lt 0

*   4.16 INE  _plbl_

Jump to _plbl_ if (IA) ne 0


The above conditional jump instructions do not change the contents of
the accumulator.

On a ones complement machine, it is permissible to produce negative zero in IA provided these
instructions operate correctly with such a value.

 #### 5- Operations on Real Values 

*   5.1  LDR   _ops_

Load real accumulator from  _ops_

*   5.2  STR   _ops_

Store real accumulator at  _ops_


*   `5.3  ADR   _ops_

ADD  _ops_ to real accumulator

*   5.4  SBR   _ops_

Subtract  _ops_ from real accumulator


*   5.5  MLR   _ops_

Multiply real accumulator by  _ops_

*   5.6  DVR   _ops_

Divide real accumulator by  _ops_

If the result of any of the above operations causes underflow, the result yielded is 0.0.

The result of any of the above operations is undefined or out of
range, real overflow is set, the contents of (RA) are undefined and
the following instruction must be either ROV or RNO.

Particular care may be needed on target machines having distinct overflow and divide by zero conditions.

*   5.7  ROV  _plbl_

Jump to _plbl_ real overflow

*   5.8  RNO  _plbl_

Jump to _plbl_ no real overflow

These instructions can only occur immediately following an instruction
which can cause real overflow (ADR,SBR MLR DVR.

*   5.9 NGR

Negate real accumulator (change sign)

*   5.10 REQ  _plbl_

Jump to _plbl_ if (RA) eq 0.0


*   5.11 RGE  _plbl_

Jump to _plbl_ if (RA) ge 0.0

*   5.12 RGT  _plbl_

Jump to _plbl_ if (RA) gt 0.0


*   5.13 RLE  _plbl_

Jump to _plbl_ if (RA) le 0.0

*   5.14 RLT  _plbl_

Jump to _plbl_ if (RA ) lt 0.0

*   5.15 RNE  _plbl_

Jump to _plbl_ if (RA) ne 0.0

The above conditional instructions do not affect the value stored in the real accumulator.

On a ones complement machine, it is permissible to produce negative zero in RA  provided these
instructions operate correctly with such a value.

*   5.16 ATN

Arctangent of real accumulator

*   5.17 CHP

Integer portion of real accumulator

*   5.18 COS

Cosine of real accumulator

*   5.19 ETX

e to the power in the real accumulator

*   5.20 LNF

Natural logorithm of real accumulator

*   5.21 SIN

Sine of real accumulator

*   5.22 SQR

square root of real accumulat

*5.23 TAN

Tangent of real accumulator


The above orders operate upon the real accumulator, and replace the
contents of the accumulator with the result.

The result of any of the above operations is undefined or out of
range, real overflow is set, the contents of (RA) are undefined and
the following instruction must be either ROV or RNO

#### 6-  Operations on Character Values


Character operations employ the concept of a character pointer which
uses either index register XR or XL (not XS ).

A character pointer points to a specific character in a string of
characters stored CFP$C chars to a word.

The only operations permitted on a character pointer are LCH
and SCH. In particular, a character pointer may not even be moved with MOV


*   restriction 1

It is important when coding in MINIMAL to ensure that no action
occurring between the initial use of PLC or
PSC and the eventual clearing of XL
or XR on completion of character operations can
initiate a garbage collection.

The latter of course could cause the addressed characters to be moved leaving the character pointers
pointing to rubbish.

*   restriction 2.

A further restriction to be observed in code handling character
strings, is that strings built dynamically should be right padded with
zero characters to a full word boundary to permit easy hashing and use
of CEQ or CNE in testing strings for equality.


*   6.1  PLC  _x,opv_

Prepare ch ptr for LCH CMC mvc,TRC MCB

*   6.2  PSC  _x,opv_

Prepare character pointer for SCH MVC MCB

_opv_ can be omitted it is zero.

<he character initially addressed
is determined by the word address in x and the integer offset
_opv_.

There is an automatic implied offset of CFP$F bytes.  *CFP$F* is used to
formally introduce into MINIMAL a value needed in translating these
opcodes which, since MINIMAL itself does not prescribe a string
structure in detail, depends on the choice of a data structure for
strings in the MINIMAL program.  e.g. CFP$B =
CFP$C = 3, *CFP$F = 6, num01 = 1,
XL points to a series of 4 words, abc/def/ghi/jkl,
then PLC XL ,=num01
points to h.


*   6.3  LCH  _reg,opc_

Load character into register

*   6.4  SCH  _reg,opc_

Store character from _reg_

These operations are defined such that the character is right
justified in register _reg_ with zero bits to the left.

After LCH,  for example, it is legitimate to regard
_reg_ as containing the ordinal integer corresponding to the
character.

_opc_ is one of the following three possibilities.

*   (x)  --

The character pointed to by the character pointer in x. the
character pointer is not changed.

*   (x)+  --

Same character as (x) but the character pointer is incremented
to point to the next character following execution.

*   -(x)  --

The character pointer is decremented before accessing the
character so that the previous character is referenced.

*   6.5  CSC  _x_

Complete store characters

This instruction marks completion of a PSC sch,SCH ...,sch sequence initiated by a
PSC x instruction.

No more SCH instructions using x should be obeyed until another
PSC is obeyed.

It is provided solely as an efficiency aid on machines without character orders since it permits use of
register buffering of chars in sch sequences.

Where CSC is not a no-op, it must observe restriction 2.
(e.g. in SPITBOL, *alocs* zeroises the last word of a string frame prior
to SCH sequence being started so CSC must not nullify this action.)

The following instructions are used to compare two words containing
CFP$C characters.

Comparisons distinct from BEQ BNE are provided as on some target machines, the
possibility of the sign bit being set may require special action.

Note that restriction 2 above, eases use of these orders in testing
complete strings for equality, since whole word tests are possible.

*   6.6  CEQ   _opw,opw,plbl_

Jump to _plbl_  _opw_ eq  _opw_

*   6.7  CNE   _opw,opw,plbl_

Jump to _plbl_  _opw_ ne  _opw_

*   6.8  CMC  _plbl,plbl_

Compare characters

CMC is used to compare two character strings. before
executing CMC  registers are set up as follows.

```
            (XL )             character ptr for first string
            (XR )             character pointer for second string
            (WA)             character count (must be .gt. zero)
```

XL and XR should have been prepared by PLC control passes to first _plbl_ the
first string is lexically less than the second string, and to the
second _plbl_ the first string is lexically greater.

Control passes to the following instruction the strings are identical. after
executing this instruction, the values of XR and XL are set to zero and the value in (WA) is
undefined.

Arguments to CMC may be complete or partial strings, so making optimisation to use whole word comparisons
difficult (dependent in general on shifts and masking).

*   6.9  TRC

Translate characters

TRC is used to translate a character string using a supplied translation table. before executing *trc* the
registers are set as follows.

```
            (XL )             char ptr to string to be translated
            (XR )             char ptr to translate table
            (WA)             length of string to be translated
```

XL and XR should have been prepared by PLC the translate table consists of
CFP$A* contiguous characters giving the translations
of the CFP$A* characters in the alphabet.

On completion, (XR ) and (XL ) are set to zero and (WA) is undefined.

*   6.10 FLC  _w_

Fold character to upper case

FLC is used only `.culc` is defined. the character code
value in _w_ is translated to upper case it corresponds to a lower case
character.

#### 7- Operations on Bit String Values

*   7.1  ANB   _w,opw_

And bit string values, result in _w_

*   7.2  ORB   <emp>w,opw_

Or bit string values, result in _w_


*   7.3  XOB   _w,opw_

Exclusive or bit string values, result in _w_

In the above operations, the logical connective is applied separately
to each of the CFP$N bits.  The result is stored in the second operand location.

*   7.4  CMB  _w_

Complement all bits in _w_


*   7.5  RSH  _w,val_

Right shift _w_ by _val_ bits


*   7.6  LSH  _w,val_

Left shift _w_ by _val_ bits


*   7.7  RSX  _w,(x)_

Right shift _w_ by  number of bits in _x_


*   7.8  LSX  _w,(x)_

Left shift _w_ by the  number of bits in _x_


The above shifts are logical shifts in which bits shifted out are lost
and zero bits supplied as required. The shift count is in the range
0-CFP$N .

*   7.9  NZB  w,_plbl_

Jump to _plbl_ w is not all zero bits.

*   7.10 ZRB  w,_plbl_

Jump to _plbl_ w is all zero bits


*   7.11 ZGB   _opn_

Zeroise garbage bits

_opn_ contains a bit string representing a word of characters
from a string or some function formed from such characters (e.g. as a
result of hashing).

 On a machine where the word size is not a multiple of the character size, some bits in _reg_ may be undefined.

This opcode replaces such bits by the zero bit. ZGB is a no-op the word size is a multiple of the character size.


#### 8-  Conversion Instructions


The following instructions provide for conversion between lengths in
bytes and lengths in words.


*   8.1  WTB  _reg_

Convert  _reg_ from words to bytes.


That is, multiply by CFP$B . this is a no-op *CFP$B  is one.

*   8.2  BTW  _reg_

Convert  _reg_ from bytes to words

By dividing _reg_ by CFP$B discarding the fraction. no-op *CFP$B is one

The following instructions provide for conversion of one word integer
values (addresses) to and from the full signed integer format.

*   8.3  MTI   _opn_

The value of _opn_ (an address) is moved as a positive integer
to the integer accumulator.

*   8.4  MFI   _opn,plbl_

The value currently stored in the integer accumulator is moved to
_opn_ as an address it is in the range 0 to
CFP$M inclusive.

IftThe accumulator value is outside this range, *then* the result in _opn_ is
undefined and control is passed to _plbl_.

MFI destroys the value of (IA) whether or not integer overflow is
signalled.  _plbl_ may be omitted overflow is impossible.

The following instructions provide for conversion between real values and integer values.

*   8.5  ITR

Convert integer value in integer accumulator to real and store in real
accumulator (may lose precision in some cases)

*   8.6  RTI  _plbl_

Convert the real value in RA to an integer and place result in
IA .  Conversion is by truncation of the fraction - no rounding occurs.

Jump to _plbl_ if RA out of range. *RA* is not changed in either case.

_plbl_ may be omitted overflow is impossible.

The following instructions provide for computing the length of storage
required for a text string.

*   8.7  CTW  _w,val_

This instruction computes the sum (number of words required to store w
characters) + (val). the sum is stored in _w_.

For example, CFP$C is 5, and WA contains 32, *then*
CTW WA,2 gives a result of 9 in WA.

*   8.8  CTB  w,val

CTB is exactly like CTW except that the result is in bytes. it has the
same effect as CTW w,_val_  WTB w

The following instructions provide for conversion from
integers to and from numeric digit characters for use in numeric
conversion routines. They employ negative integer values to allow for
proper conversion of numbers which cannot be complemented.


*   8.9  CVM  _plbl_

Convert by multiplication

The integer accumulator, which is zero or negative, is multiplied by
10. WB contains the character code for a digit. the
value of this digit is then subtracted from the result.

The result is out of range, *then* control is passed to _plbl_
with the result in (IA) undefined. execution of CVM leaves the result in (WB )
undefined.


*8.10 cvd

Convert by division

The integer accumulator, which is zero or negative, is divided by 10.
the quotient (zero or negative) is replaced in the accumulator. The
remainder is converted to the character code of a digit and placed in
WA. For example, an operand of -523 gives a quotient of -52 and a
remainder in WA of CH$D3.

#### 9-  Block Move Instructions



The following instructions are used for transferring data from one
area of memory to another in blocks.  They can be implemented with the
indicated series of other macro-instructions, but more efficient
implementations will be possible on most machines.

Note that in the equivalent code sequence shown below, a zero
value in WA will move at least one item, and may may wrap the counter
causing a core dump in some imple- mentations.  Thus WA should be .gt.
0 prior to invoking any of these block move instructions.

*   9.1  MVC

Move characters


Before obeying this order WA,XL ,XR should have been set up, the latter two by PLC
PSC resp.  MVC is equivalent to the sequence

```
                   mov  dumpb,WB
                   lct  WA,WA
            loopc  lch  WB,(XL)+
                   sch  WB,(XR)+
                   bct  WA,loopc
                   csc  XR
                   mov  WB,dumpb

```

The character pointers are bumped as indicated and the final value of WA is undefined.


*9.2  MVW

              move words



MVW is equivalent to the sequence

```
             opw  mov  (XR)+,(XL)+
             dca  WA              WA = bytes to move
             bnz  WA,lo opw

```



Note that this implies that the value in WA is the length in bytes
which is a multiple of CFP$B .

The initial addresses in XR ,XL are word addresses.

As indicated, the final XR ,XL values point past the new and old regions of memory respectively.

The final value of WA is undefined.  WA,XL ,XR must be set up before obeying MVW

*   9.3  MWB

Move words backwards



MWB  is equivalent to the sequence

```
            loopb  mov  -(XL),-(XR)
                   dca  WA               WA = bytes to move
                   bnz  WA,loopb
```

There is a requirement that the initial value in XL
be at least 256 less than the value in XR . this
allows an implementation in which chunks of 256 bytes are moved
forward (IBM 360, ICL 1900).

The final value of WA is undefined.

WA ,XL , XR must be set up before obeying MWB .

*   9.4  MCB



Move characters backwards


MCB is equivalent to the sequence

```
                   mov  dumpb,WB
                   lct  WA,WA
            loopc  lch  WB,-(XL)
                   sch  WB,-(XR)
                   bct  WA,loopc
                   csc  XR
                   mov  WB,dumpb
```




There is a requirement that the initial value in XL
be at least 256 less than the value in XR . this
allows an implementation in which chunks of 256 bytes are moved
forward (IBM 360, ICL 1900).

The final value of WA is undefined.  WA,XL ,XR must be set up before
obeying MCB


#### 10- Operations Connected with the Stack


The stack is an area in memory which is dedicated for use in
conjunction with the stack pointer register (XS ). As
previously described, it is used by the JSR and EXI
instructions and may be used for storage of any other data as
required.



The stack builds either way in memory and an important restriction is
that the value in (XS ) must be the address of the
stack front at all times since some implementations may randomly
destroy stack locations beyond (XS ).


The starting stack base address is passed in (XS ) at
The start of execution. During execution it is necessary to make sure
that the stack does not overflow. This is achieved by executing the
following instruction periodically.



*   10.1 CHK


Check stack overflow

After successfully executing CHK it is permissible to
use up to 100 additional words before issuing another chk thus
CHK need not be issued every time the stack is
expanded. In some implementations, the checking may be automatic and
CHK will have no effect.

Following the above rule makes sure that the program
will operate correctly in implementations with no automatic check.

Stack overflow occurs (detected either automatically or by a
CHK instruction), *then* control is
passed to the stack overflow section (see program form).

Note that this transfer may take place following any instruction which stores
data at a new location on the stack.  After stack overflow, stack is
arbitrarily popped to give some space in which the error procedure may
operate. otherwise a loop of stack overflows may occur.

#### 11- Data Generation Instructions


The following instructions are used to generate constant values in the
constant section and also to assemble initial values in the working
storage section. They may not appear except in these two sections.

*   11.1 DAC  _addr_

Assemble address constant.

Generates one word containing the specified one word integer value
(address).


*   11.2 DIC  _integer_

Generates an integer value which occupies CFP$I
consecutive words.

The operand is a digit string with a required leading sign.

*   11.3 DRC  _real_

Assembles a real constant which occupies CFP$R
consecutive words.

The operand form must obey the rules for a FORTRAN
real constant with the extra requirement that a leading sign be
present.


*   11.4 DTC  _dtext_

Define _text_ constant.

*Text* is started and ended with any character not contained in the
characters to be assembled. The constant occupies consecutive words as
dictated by the configuration parameter CFP$C .

Any unused chars in the last word are right filled with zeros (i.e. the
character whose internal code is zero).  The string contains a
sequence of letters, digits, blanks and any of the following special
characters.  =,$.(*)/+-


No other characters may be used in a _dtext_ operand.

*   11.5 DBC  val

Assemble bit string constant.

The operand is a positive integer value which is interpreted in
binary, right justified and left filled with zero bits. Thus 5 would
imply the bit string value 00...101.  

#### 12- Symbol Definition Instructions

The following instruction is used to define symbols in the definitions
section. It may not be used elsewhere.

*   12.1 EQU  _eqop_

Define symbol

The symbol which appears in the label field is defined to have the absolute value given by the _eqop_ operand. A given
symbol may be defined only once in this manner, and any symbols occuring in _eqop_ must be previously defined.

The following are the possibilities for _eqop_


    *_val_

the indicated value is used


*   _val+val_

The sum of the two values is used.  This sum must not exceed CFP$M

*   _val-val_

The difference between the two values (must be positive) is used.

This format defines the label by using a value supplied by the MINIMAL
translator. Values are required for the


```
            CFP$x            (configuration parameters)
            E$xxx            (environment parameters)
            CH$xx            (character codes).
```

In order for a translator to handle this format correctly the
definitions section must be consulted for details of required symbols
as listed at the front of the section.


The following instructions may be used to define symbols in the
procedure section. They may not be used in any other part of the
program.

*   12.2 *exp*

Define external procedure

*exp* defines the symbol appearing in the
label field to be the name of an external procedure which can be
referenced in a subsequent JSR instruction.

The coding for the procedure is external to the coding of the source
program in this language.  The code for external procedures may be
referred to collectively as the operating system interface, or more
briefly, osint, and will frequently be a separately compiled segment
of code loaded with SPITBOL to produce a complete system.

*   12.3 INP  _ptyp_,int

Define internal procedure

INP defines the symbol appearing in the
label field to be the name of an internal procedure and gives its type
and number of exit parameters.

The label can be referenced in JSR instructions and it must appear labelling a
PRC instruction in the program section.

*   12.4 INR

Define internal routine

INR defines the symbol appearing in the
label field to be the name of an internal routine.

The label may be referenced in any type of branch order and it must appear labelling a
RTN instruction in the program section.

### 13 - Assembly Listing Layout Instruction

*   13.1 EJC

Eject to next page


*   13.2 TTL  text

Set new assembly title

TTL implies an immediate eject of the assembly listing to print the new title.

The use of TTL and EJC cards is such
that the program will list neatly the printer prints as many as 58
lines per page. In the event that the printer depth is less than this,
or the listing contains interspersed lines (such as actual generated
code), then the format may be upset.

Lines starting with an asterisk are comment lines which cause no code
to be generated and may occur freely anywhere in the program. The
format for comment lines is given in section -15-.

Lines starting with left set brace, '{', begin a block comment that
continues up to and includind the first following line that begins
with a right set brace, '}'. Any statements such as instructions or
conditional assembly within the body of the block comment will not be
recognized as such.

#### 14 - Program Form



The program consists of separate sections separated by
SEC operations. The sections must appear in the
following specified order.


*   14.1 SEC


```
            start of procedure section

            (procedure section)

            SEC               start of definitions section

            (definitions section)

            SEC               start of constant storage section

            (constant storage section)

            SEC               start of working storage section

            (working storage section)

            SEC               start of program section

            (program section)

            SEC               start of stack overflow section

            (stack overflow section)

            SEC               start of error section

            (error section)

```

*1  4.2 END

End of assembly

### Section 10 - Program Form

*procedure section



The procedure section contains all the exp instructions for externally
available procedures and INP inr opcodes for internal
procedures,routines so that a single pass MINIMAL translator has
advance knowledge of procedure types when translating calls.


*definitions section



The definitions section contains EQU instructions
which define symbols referenced later on in the program, constant and
work sections.

 constant storage section



The constant storage section consists entirely of constants assembled
with the DAC dic,DRC dtc,dbc
assembly operations. these constants can be freely referenced by the
program instructions.



*working storage section



The working storage section consists entirely of DAC
dic,DRC DBC dtc instructions to
define a fixed length work area. The work locations in this area can
be directly referenced in program instructions.  The area is
initialized in accordance with the values assembled in the
instructions.



*program section



The program section contains program instructions and associated
operations (such as PRC ENP ENT).


Control is passed to the first instruction in this section when
execution is initiated.

*stack overflow section




The stack overflow section contains instructions like the program
section.

Control is passed to the first instruction in this section
following the occurrence of stack overflow, see CHK
instruction.

*error section



The error section contains instructions like the program section.

Control is passed to the first instruction in this section when a
procedure exit corresponds to an error parameter (see err) or when an
ERB opcode is obeyed.

The error code must clean up the main stack and cater for
the possibility that a subroutine stack may need clean up.

*osint



Though not part of the MINIMAL source, it is useful to refer to the
collection of initialisation and *exp* routines as
osint (operating system interface).

  Errors occurring within osint
procedures are usually handled by making an error return. If this is
not feasible or appropriate, osint may use the MINIMAL error section
to report errors directly by branching to it with a suitable numeric
error code in WA.  

### Section 11 - Statement Format





All labels are exactly five characters long and start with three
letters (abcdefghijklmnopqrstuvwxy$) followed by two letters or
digits.

The letter z may not be used in MINIMAL symbols but $ is permitted.


For implementations where $ may not appear in the target code , a
simple substitution of z for $ may thus be made without risk of
producing non-unique symbols.

The letter z is however permitted in opcode mnemonics and in comments.

MINIMAL statements are in a fixed format as follows.

```
       cols 1-5              label any (else blank)

       cols 6-7              always blank

       cols 8-10             operation mnemonic

       cols 11-12            blanks

       cols 13-28            operand field, terminated by a
                             blank. may occasionally
                             extend past column 28.

       cols 30-64            comment. always separated from the
                             operand field by at least one blank
                             may occasionally start after column
                             30 the operand extends past 28.
                             a special exception occurs for the
                             IFF instruction, whose comment may
                             be only 20 characters long (30-49).

       cols 65 on            unused


       comment lines have the following format

       col 1                 asterisk

       cols 2-7              blank

       cols 8-64             arbitrary text, restricted to the
                             fortran character set.


       the fortran character set is a-z 0-9 =,$.(*)-/+
```
### Section 12 - Program Execution


Execution of the program begins with the first instruction in the
program section.



In addition to the fixed length memory regions defined by the
assembly, there are two dynamically allocated memory regions as
follows.


*   data area


This is an area available to the program for general storage of data
any data value may be stored in this area except instructions.

In some implementations, it may be possible to increase the size of this
area dynamically by adding words at the top end with a call to a
system procedure.

*   stack area

This region of memory holds the stack used for subroutine calls and
other storage of one word integer values (addresses). This is the
stack associated with index register XS .

The locations and sizes of these areas are specified by the values in
the registers at the start of program execution as follows.

*   (XS )

Address one past the stack base.  For example, if  XS
is 23456, a d-stack will occupy words 23455,23454,...  whereas a
u-stack will occupy 23457,23458,...

*   (XR )

Address of the first word in the data area

    *(XL)

Address of the last word in the data area.

*   (WA)

Initial stack pointer

*   (WB ,WC ,IA ,ra,CP )

There is no explicit way to terminate the execution of a program. This
function is performed by an appropriate system procedure referenced
with the SYSEJ instruction.


## SPITBOL Operating System Interface (OSINT)

This section describes the operating system interface functions,
mostly written in C, the are used by MACRO SPITBOL for runtime
support,doing input/output, loading external functions, reading and
writing save files, reading and writing load modules, and so forth.

### SYSAX -- after execution

 If the conditional assembly symbol .csax is defined, this routine
is called immediately after execution and before printing of execution
statistics or dump output.

 The purpose of call is for the implementor to determine and if the
call is not required it will be omitted if .csax is undefined. in this
case SYSAX need not be coded.

```
JSR  SYSAX            call after execution
```
### sysbs -- backspace file

SYSBS is used to implement the snobol4 function backspace.

 If the conditional assembly symbol .cbsp is defined.  the meaning
is system dependent.  In general, backspace repositions the file one
record closer to the beginning of file, such that a subsequent read or
write will operate on the previous record.

```

       (WA)                  pointer to FCBLK or zero
       (XR)                  backspace argument (scblk pointer)
       JSR  sysbs            call to backspace
       PPM  loc              return here if file does not exist
       PPM  loc              return here if backspace not allowed
       PPM  loc              return here if i/o error
       (WA,WB)               destroyed
```

The second error return is used for files for which backspace is
not permitted. For example, it may be expected files on character
devices are in this category.

### SYSBP  exp  0                define external entry point

 SYSBP is not required in normal operation. It is
called as a breakpoint to assist in debugging.

```
       JSR  SYSBP            call to breakpoint
```
### SYSBX -- before execution

SYSBX  exp  0                define external entry point

Called after initial SPITBOL compilation and before commencing
execution in case osint needs to assign files or perform other
necessary services.  osint may also choose to send a message to online
terminal (if any) indicating that execution is starting.

```
       JSR  SYSBX            call before execution starts
```

### SYSCI -- convert integer

SYSCI is an optional osint routine that causes
SPITBOL to call SYSCI to convert integer values to
strings, rather than using the internal SPITBOL conversion code.

This code may be less efficient on machines with hardware
conversion instructions and in such cases, It may be an advantage to
include SYSCI.  The symbol .CNCI must be defined if
this routine is to be used.

The rules for converting integers to strings are that positive
values are represented without any sign, and

There are never any leading blanks or zeros, except in the case of
zero itself which is represented as a single zero digit.  Negative
numbers are represented with a preceeding minus sign.  There are never
any trailing blanks, and conversion cannot fail.

```
       (IA)                  value to be converted
       JSR  SYSCI            call to convert integer value
       (XL)                  pointer to pseudo-scblk with string
```

### SYSCB -- general string comparison function

 Provides string comparison determined by interface.  used for
international string comparison.


```
       (XR)                  character pointer for first string
       (XL)                  character pointer for second string
       (WB)                  character count of first string
       (WA)                  character count of second string
       JSR  SYSCB            call to SYSCB function
       PPM  loc              string too long for SYSCB
       PPM  loc              first string lexically gt second
       PPM  loc              first string lexically lt second
       ---                   strings equal
       (XL)                  zero
       (XR)                  destroyed
```

### SYSCR -- convert real

SYSCR is an optional osint routine that causes
SPITBOL to call SYSCR to convert real values to
strings, rather than using the internal SPITBOL conversion code.

This code may be desired on machines where the integer size is too
small to allow production of a sufficient number of significant
digits.  The symbol .CNCR must be defined if this routine is to be
used.

The rules for converting reals to strings are that positive values
are represented without any sign, and there are never any leading
blanks or zeros, except in the case of zero itself which is
represented as a single zero digit.  Negative numbers are represented
with a preceeding minus sign.  There are never any trailing blanks, or
trailing zeros in the fractional part.  conversion cannot fail.

```
       (RA)                  value to be converted
       (WA)                  no. of significant digits desired
       (WB)                  conversion type:
                             negative for e-type conversion
                             zero for g-type conversion
                             positive for f-type conversion
       (WC)                  character positions in result SCBLK
       (XR)                  scblk for result
       JSR  SYSCR            call to convert real value
       (XR)                  result SCBLK
       (WA)                  number of result characters
```

### SYSDC -- date check

SYSDC is called to check that the expiry date for
a trial version of SPITBOL is unexpired.

```
       JSR  SYSDC             call to check date
return only if date is ok
```


### SYSDM  exp  0                define external entry point

SYSDM is called by a SPITBOL program call of
DUMP(n) with n ge 4.  Its purpose is to provide a core dump.  n could
hold an encoding of the start adrs for dump and amount to be dumped
e.g.  n = 256\*a + s , s = start adrs in kilowords, a = kilowords to
dump

```
       (XR)                  parameter n of call DUMP(n)
       JSR  SYSDM            call to enter routine

```

### SYSDT -- get current date

SYSDT is used to obtain the current date. The date is returned as a character string in any format appropriate to
the operating system in use. It may also contain the current time of
day.

SYSDT is used to implement the SNOBOL4 function DATE().

```
       (XR)                  parameter n of call date(n)
       JSR  SYSDT            call to get date
       (XL)                  pointer to block containing date
```

The format of the block is like an SCBLK except
that the first word need not be set. The result is copied into SPITBOL
dynamic memory on return.  

### SYSEA -- inform osint of compilation and runtime errors

Provides means for interface to take special actions on errors

```
       (WA)                  error code
       (WB)                  line number
       (WC)                  column number
       (XR)                  system stage
       (XL)                  file name (scblk)
       JSR  SYSEA            call to SYSEA function
       PPM  loc              suppress printing of error message
       (XR)                  message to print (scblk) or 0

```

SYSEA may not return if interface chooses to
retain control.  Closing files via the fcb chain will be the
responsibility of the interface.

All registers must be preserved

### SYSEF -- eject file

SYSEF is used to write a page eject to a named
file. It may only be used for files where this concept makes sense.
Note that SYSEF is not normally used for the standard
output file (see SYSEP).

```
       (WA)                  pointer to FCBLK> or zero
       (XR)                  eject argument (scblk pointer)
       JSR  SYSEF            call to eject file
       PPM  loc              return here if file does not exist
       PPM  loc              return here if inappropriate file
       PPM  loc              return here if i/o error
```

### SYSEJ -- end of job

SYSEF is used to write a page eject to a named
file. It may only be used for files where this concept makes sense.

Note that SYSEF is not normally used for the
standard output file (see SYSEP).

```
       (WA)                  pointer to FCBLK or zero
       (XR)                  eject argument (scblk pointer)
       JSR  SYSEF            call to eject file
       PPM  loc              return here if file does not exist
       PPM  loc              return here if inappropriate file
       PPM  loc              return here if i/o error
```

### SYSEF -- end of job

SYSEF is used to write a page eject to a named
file. It may only be used for files where this concept makes sense.

Note that SYSEF is not normally used for the standard output file (see SYSEP).

```
       (WA)                  pointer to FCBLK or zero
       (XR)                  eject argument (scblk pointer)
       JSR  SYSEF            call to eject file
       PPM  loc              return here if file does not exist
       PPM  loc              return here if inappropriate file
       PPM  loc              return here if i/o error
```

### SYSEJ -- end of job

SYSEJ is called once at the end of execution to
terminate the run. The significance of the abend and code values is
system dependent. In general, the code value should be made available
for testing, and the abend value should cause some post-mortem action
such as a dump.

Note that SYSEJ does not return to its caller.  See SYSXI for details of FCBLK chain

```
       (WA)                  value of abend keyword
       (WB)                  value of code keyword
       (XL)                  zero or pointer to head of FCBLK chain
       JSR  SYSEJ            call to end job
```

The following special values are used as codes in (WB)

```
999  execution suppressed
998  standard output file full or unavailable in a SYSXI
load module. in these cases (*wa*) contains the number
of the statement causing premature termination.
```

### SYSEM -- get error message text

SYSEM is used to obtain the text of err, erb
calls in the source program given the error code number. It is allowed
to return a null string if this facility is unavailable.

```
       (WA)                  error code number
       JSR  SYSEM            call to get text
       (XR)                  text of message
```

The returned value is a pointer to a block in
SCBLK format except that the first word need not be
set. The string is copied into dynamic memory on return.  if the null
string is returned either because SYSEM does not
provide error message texts or because *wa* is out of
range, SPITBOL will print the string stored in errtext keyword.

### SYSEN - endfile

SYSEN is used to implement the snobol4 function
endfile.  The meaning is system dependent. In general, endfile implies
that no further i/o operations will be performed, but does not
guarantee this to be the case. The file should be closed after the
call, a subsequent read or write may reopen the file at the start or
it may be necessary to reopen the file via SYSIO.

```
       (WA)                  pointer to FCBLK or zero
       (XR)                  endfile argument (scblk pointer)
       JSR  SYSEN            call to endfile
       PPM  loc              return here if file does not exist
       PPM  loc              return here if endfile not allowed
       PPM  loc              return here if i/o error
       (WA,WB)               destroyed
```

The second error return is used for files for which endfile is not
permitted. For example, it may be expected that the standard input and
output files are in this category.

### SYSEP -- eject printer page

SYSEP is called to perform a page eject on the
standard printer output file (corresponding to SYSPR
output).

```
       JSR  SYSEP            call to eject printer output<
```

### SYSEX -- call external function

SYSEX is called to pass control to an
external function previously loaded with a call to SYSLD.

```
       (XS)                  pointer to arguments on stack
       (XL)                  pointer to control block (efblk)
       (WA)                  number of arguments on stack
       JSR  SYSEX            call to pass control to function
       PPM  loc              return here if function call fails
       PPM  loc              return here if insufficient memory
       PPM  loc              return here if bad argument type
       (XS)                  popped past arguments
       (XR)                  result returned
```

The arguments are stored on the stack with the last argument at
0(XS). On return, XS is popped past the arguments.

The form of the arguments as passed is that used in the SPITBOL
translator (see definitions and data structures section). The control
block format is also described (under EFBLK) in this
section.

There are two ways of returning a result:


Return a pointer to a block in dynamic storage. this block must
be in exactly correct format, including the first word. Only functions
written with intimate knowledge of the system will return in this
way.

String, integer and real results may be returned by pointing to a
pseudo-block outside dynamic memory.

This block is in ICBLK, RCBLK or
SCBLK format except that the first word will be
overwritten by a type word on return and so need not be correctly set.


Such a result is copied into main storage before proceeding.
unconverted results may similarly be returned in a pseudo-block which
is in correct format including type word recognisable by garbage
collector since block is copied into dynamic memory.


### SYSFC -- file control block routine

See also SYSIO

Input and output have three arguments referred to as an

`input(variable name,file arg1,file arg2)`
`output(variable name,file arg1,file arg2)`

File *arg1* may be an integer or string used to identify an
i/o channel. It is converted to a string for checking.

The exact significance of file *arg2* is not rigorously
prescribed but to improve portability, The scheme described in the
SPITBOL user manual should be adopted when possible. The preferred
form is

A string "f,r,c,i,...,z"  where
*f* is an optional file name which is placed first.
remaining items may be omitted or included in any order.

*r* is maximum record length

*c* is a carriage control character or character string

*i* is some form of channel identification used in the
absence of *f* to associate the variable with a file allocated dynamically by jcl commands at
SPITBOL load time.

,...,*z* are additional fields.

If , (comma) cannot be used as a delimiter, .ciod should be defined
to introduce by conditional assembly another delimiter (see```
iodel equ \*``` early in definitions section).

SYSFC is called when a variable is input or output associated to check file _arg1_ and file _arg2_ and to
report whether an FCBLK (file control block) is
necessary and if so what size it should be.

This makes it possible for SPITBOL rather than osint to allocate
such a block in dynamic memory if required or alternatively in static
memory.

The significance of an FCBLK , if one is
requested, is entirely up to the system interface.

The only restriction is that if the FCBLK should
appear to lie in dynamic memory, pointers to it should be proper
pointers to the start of a recognisable and garbage collectable block
(this condition will be met if SYSFC requests SPITBOL
to provide an FCBLK).

An option is provided for osint to return a pointer in
XL to an FCBLK which it privately
allocated. This pointer will be made available when i/o occurs later.
private FCBLKs may have arbitrary contents and
SPITBOL stores nothing in them.

The requested size for an FCBLK in dynamic memory
should allow a 2 word overhead for block type and length fields.

Information subsequently stored in the remaining words may be
arbitrary if an xnblk (external non-relocatable block) is requested.

If the request is for an xr*blk*
(external relocatable block) the contents of words should be
collectable (i.e.  any apparent pointers into dynamic should be
genuine block pointers).


These restrictions do not apply if an FCBLK is
allocated outside dynamic or is not allocated at all.

If an FCBLK is requested, its fields will be
initialised to zero before entry to SYSIO with the
exception of words 0 and 1 in which the block type and length fields
are placed for FCBLKs in dynamic memory only.

For the possible use of SYSEJ and
SYSXI, if FCBLKs are used, a chain
is built so that they may all be found - see SYSXI
for details.


If both file _arg1_ and file _arg2_ are null, calls
of SYSFC and SYSIO are omitted.

If file _arg1_ is null (standard input/output file),
SYSFC is called to check non-null file _arg2_
but any request for an FCBLK will be ignored, since
SPITBOL handles the standard files specially and cannot readily keep
FCBLK pointers for them.file _arg1_ is
type checked by SPITBOL so further checking may be unneccessary in
many implementations.  file _arg2_ is passed so that
SYSFC may analyse and check it. however to assist in
this, SPITBOL also passes on the stack the components of this argument
with file name, _f_ (otherwise null) extracted and stacked first.

The other fields, if any, are extracted as substrings, pointers to
them are stacked and a count of all items stacked is placed in
WC.

If an FCBLK was earlier
allocated and pointed to via file _arg1_, SYSFC is also passed a pointer to this
FCBLK.

```
      (XL)                  file arg1 scblk ptr (2nd arg)
      (XR)                  filearg2 (3rd arg) or null
      -(XS)...-(XS)         scblks for $f$,$r$,$c$,...
      (WC)                  no. of stacked scblks above
      (WA)                  existing file arg1 FCBLK ptr or 0
      (WB)                  0/3 for input/output assocn
      JSR  SYSFC            call to check need for FCBLK
      PPM  loc              invalid file argument
      PPM  loc              FCBLK already in use
      (XS)                  popped (WC) times
      (WA non zero)         byte size of requested FCBLK
      (WA=0,xl non zero)    private FCBLK ptr in xl
      (WA=XL=0)             no FCBLK wanted, no private FCBLK
      (WC)                  0/1/2 request alloc of xrblk/xnblk
                            /static block for use as FCBLK
      (WB)                  destroyed
```

### SYSGC -- inform interface of garbage
collections

Provides means for interface to take special actions prior to and
after a garbage collection.

Possible usages- 

provide visible screen icon of garbage collection in
progress.

inform virtual memory manager to ignore page access patterns
during garbage collection.  such accesses typically destroy the page
working set accumulated by the program.

inform virtual memory manager that contents of memory freed by
garbage collection can be discarded. 

```
      (XR)                  non-zero if beginning gc
                            =0 if completing gc
      (WA)                  dnamb=start of dynamic area
      (WB)                  dnamp=next available location
      (WC)                  dname=last available location + 1
      JSR  SYSGC            call to sysgc function
      all registers preserved
```

### SYSHS -- give access to host computer features

Provides means for implementing special features on different host
computers.  the only defined entry is that where all arguments are
null in which case SYSHS *SYSHS* returns an SCBLK containing name of computer, name of
operating system and name of site separated by colons.

The SCBLK need not have a correct first field as this is supplied on copying string to dynamic memory.

SPITBOL does no argument checking but does provide a single error return for arguments checked as erroneous by osint.  It also provides
a single execution error return.

If these are inadequate, use may be made of the minimal error section direct as described in minimal documentation, section 10.

Several non-error returns are provided. the first corresponds to the defined entry or, for implementation
defined entries, any string may be returned. the others permit respectively,  return a null result, return with a
result to be stacked which is pointed at by XR, and a
return causing SPITBOL statement failure.

If a returned result is in dynamic memory it must obey garbage
collector rules.

The only results copied on return are strings returned via PPM loc3
return.

```
       (WA)                  argument 1
       (XL)                  argument 2
       (XR)                  argument 3
       (WB)                  argument 4
       (WC)                  argument 5
       JSR  syshs            call to get host information
       PPM  loc1             erroneous arg
       PPM  loc2             execution error
       PPM  loc3             SCBLK pointer in xl or 0 if unavailable
       PPM  loc4             return a null result
       PPM  loc5             return result in xr
       PPM  loc6             cause statement failure
       PPM  loc7             return string at xl, length wa
       PPM  loc8             return copy of result in xr
```

### SYSID -- return system identification

This routine should return strings to head the standard printer
output. the first string will be appended to a heading line of the
form

```
    MACRO SPITBOL version v.v
```

Supplied by SPITBOL itself. v.v are digits giving the major version
number and generally at least a minor version number relating to osint
should be supplied to give say

```
    MACRO SPITBOL version v.v(m.m)
```

The second string should identify at least the machine and
operating system.  preferably it should include the date and time of
the run.  optionally the strings may include site name of the the
implementor and/or machine on which run takes place, unique site or
copy number and other information as appropriate without making it so
long as to be a nuisance to users.  the first words of the
SCBLKs pointed at need not be correctly set.


```
       JSR  sysid            call for system identification
       (XR)                  scblk pointer for addition to header
       (XL)                  scblk pointer for second header
```

### SYSIF -- switch to new include file

SYSIF is used for include file processing, both to
inform the interface when a new include file is desired, and when the
end of file of an include file has been reached and it is desired to
return to reading from the previous nested file.

It is the responsibility of SYSIF to remember the
file access path to the present input file before switching to the new
include file.

```
      (XL)                  ptr to scblk or zero
      (XR)                  ptr to vacant scblk of length cswin
                            (xr not used if xl is zero)
      JSR  sysif            call to change files
      PPM  loc              unable to open file
      (XR)                  scblk with full path name of file
                            (xr not used if input xl is zero)
```

Register XL points to an SCBLK containing the name of the include file to which the interface should
switch.  Data is fetched from the file upon the next call to SYSRD.

SYSIF may have the ability to search multiple
libraries for the include file named in (XL).  It is
therefore required that the full path name of the file where the file
was finally located be returned in (XR).  It is this
name that is recorded along with the source statements, and will
accompany subsequent error messages.

Register XL is zero to mark conclusion of use of an include file.

### SYSIL -- get input record length

SYSIL is used to get the length of the next input
record from a file previously input associated with a
SYSIO call. The length returned is used to establish
a buffer for a subsequent SYSIN call.
SYSIL also indicates to the caller if this is a
binary or text file.

```
       (WA)                  pointer to FCBLK or zero
       JSR  sysil            call to get record length
       (WA)                  length or zero if file closed
       (WC)                  zero if binary, non-zero if text
```

No harm is done if the value returned is too long since unused
space will be reclaimed after the SYSIN call.

Note that it is the SYSIL call (not the
SYSIO call) which causes the file to be opened as
required for the first record input from the file.

### SYSIN -- read input record

SYSIN is used to read a record from the file
which was referenced in a prior call to SYSIL (i.e.
these calls always occur in pairs). The buffer provided is an
SCBLK for a string of length set from the
SYSIL call.  If the actual length read is less than
this, the length field of the SCBLK must be modified
before returning unless buffer is right padded with zeroes.

It is also permissible to take any of the alternative returns after
SCBLK length has been modified.

```
       (WA)                  pointer to FCBLK or zero
       (XR)                  pointer to buffer (scblk pointer)
       JSR  sysin            call to read record
       PPM  loc              endfile or no i/p file after SYSXI
       PPM  loc              return here if i/o error
       PPM  loc              return here if record format error
       (WA,WB,WC)            destroyed
```

### SYSIO -- input/output file association

See also SYSFC.

SYSIO is called in response to a snobol4 input or
output function call except when file _arg1_ and file
_arg2_ are both null.  Its call always follows immediately
after a call of SYSFC. If SYSFC
requested allocation of an FCBLK, its address will be
in *wa*.  for input files, non-zero values of _r_
should be copied to WC for use in allocating input
buffers. If _r_ is defaulted or not implemented, WC
should be zeroised.

Once a file has been opened, subsequent input(),output() calls in
which the second argument is identical with that in a previous call,
merely associate the additional variable name (first argument) to the
file and do not result in re-opening the file.

In subsequent associated accesses to the file a pointer to any
FCBLK allocated will be made available.

```
       (XL)                  file arg1 scblk pointer (2nd arg)
       (XR)                  file arg2 scblk pointer (3rd arg)
       (WA)                  FCBLK pointer (0 if none)
       (WB)                  0 for input, 3 for output
       JSR  SYSIO            call to associate file
       PPM  loc              return here if file does not exist
       PPM  loc              return if input/output not allowed
       (XL)                  FCBLK pointer (0 if none)
       (WC)                  0 (for default) or max record lngth
       (WA,WB)               destroyed
```

The second error return is used if the file named exists but
input/output from the file is not allowed. For example, the standard
output file may be in this category as regards input association.

### SYSLD -- load external function

SYSLD is called in response to the use of the snobol4 load
function. The named function is loaded (whatever this means), and a
pointer is returned. the pointer will be used on subsequent calls to
the function (see SYSEX).

```
       (XR)                  pointer to function name (scblk)
       (XL)                  pointer to library name (scblk)
       JSR  SYSLD            call to load function
       PPM  loc              return here if func does not exist
       PPM  loc              return here if i/o error
       PPM  loc              return here if insufficient memory
       (XR)                  pointer to loaded code
```

The significance of the pointer returned is up to the system
interface routine. The only restriction is that if the pointer is
within dynamic storage, it must be a proper block pointer.

### SYSMM -- get more memory

SYSMM is called in an attempt to allocate more
dynamic memory. This memory must be allocated contiguously with the
current dynamic data area.

The amount allocated is up to the system to decide. any value is
acceptable including zero if allocation is impossible.

```
       JSR  SYSMM            call to get more memory
       (XR)                  number of additional words obtained

```

### SYSMX -- supply *mXLen*

Because of the method of garbage collection, no SPITBOL object is
allowed to occupy more bytes of memory than the integer giving the
lowest address of dynamic (garbage collectable) memory.
*mXLen* is the name used to refer to
this maximum length of an object and for most users of most
implementations, provided dynamic memory starts at an address of at
least a few thousand words, there is no problem.

If the default starting address is less than say 10000 or 20000,
then a load time option should be provided where a user can request
that he be able to create larger objects. This routine informs SPITBOL
of this request if any. the value returned is either an integer
representing the desired value of
*mXLen* (and hence the minimum dynamic
store address which may result in non-use of some store) or zero if a
default is acceptable in which *mXLen*
is set to the lowest address allocated to dynamic store before
compilation starts.

If a non-zero value is returned, this is used for keyword
maXLngth. Otherwise the initial low address of
dynamic memory is used for this keyword.

```
       JSR  SYSMX            call to get mxlen
       (WA)                  either mxlen or 0 for default
```

### SYSOU -- output record

SYSOU is used to write a record to a file previously
associated with a SYSIO call.

```
       (WA)                  pointer to FCBLK or 0 for terminal or 1 for output
       (XR)                  record to be written (scblk)
       JSR  sysou            call to output record
       PPM  loc              file full or no file after SYSXI
       PPM  loc              return here if i/o error
       (WA,WB,WC)            destroyed
```

Note that it is the SYSOU call (not the
SYSIO call) which causes the file to be opened as
required for the first record output to the file.

### SYSPI -- print on interactive channel

If SPITBOL is run from an online terminal, osint can request that
messages such as copies of compilation errors be sent to the terminal
(see SYSPP). if relevant reply was made by
SYSPP then SYSPI is called to send
such messages to the interactive channel.  SYSPI is
also used for sending output to the terminal through the special
variable name, terminal. (XR) pointer to line
buffer (SCBLK) (*wa*) line length JSR
SYSPI call to print line PPM loc failure return
(*wa*,WB) destroyed

### SYSPL -- provide interactive control of SPITBOL

Provides means for interface to take special actions, such as
interrupting execution, breakpointing, stepping, and expression
evaluation.  These last three options are not presently implemented by
the code calling SYSPL.

```
       (WA)                  opcode as follows-
                             =0 poll to allow osint to interrupt
                             =1 breakpoint hit
                             =2 completion of statement stepping
                             =3 expression evaluation result
       (WB)                  statement number
       r_fcb                 zero or pointer to head of FCBLK chain
       JSR  syspl            call to syspl function
       PPM  loc              user interruption
       PPM  loc              step one statement
       PPM  loc              evaluate expression
       ---                   resume execution
                             (WA) = new polling interval
```

### SYSPP -- obtain print parameters

SYSPP is called once during compilation to obtain
parameters required for correct printed output format and to select
other options. it may also be called again after
SYSXI when a load module is resumed. in this case the
value returned in *wa* may be less than or equal to
that returned in initial call but may not be greater.


the information returned is -


line length in chars for standard print file

no of lines/page. 0 is preferable for a non-paged device (e.g.
online terminal) in which case listing page throws are suppressed and
page headers resulting from -title,-stitl lines are kept short.

an initial -nolist option to suppress listing unless the program
contains an explicit -list.

options to suppress listing of compilation and/or execution stats
(useful for established programs) - combined with 3. gives possibility
of listing file never being opened.

option to have copies of errors sent to an interactive channel in
addition to standard printer.

option to keep page headers short (e.g. if listing to an online
terminal).

an option to choose extended or compact listing format. in the
former a page eject and in the latter a few line feeds precede the
printing of each of-- listing, compilation statistics, execution
output and execution statistics.

an option to suppress execution as though a -noexecute card were
supplied.

an option to request that name /terminal/ be pre- associated to
an online terminal via SYSPI and
SYSRI

an intermediate (standard) listing option requiring that page
ejects occur in source listings. redundant if extended option chosen
but partially extends compact option.

 option to suppress SYSID identification.


```

       JSR  syspp            call to get print parameters
       (WA)                  print line length in chars
       (WB)                  number of lines/page
       (WC)                  bits value ...mlkjihgfedcba where
                     a = 1 to send error copy to int.ch.
                     b = 1 means std printer is int. ch.
                     c = 1 for -nolist option
                     d = 1 to suppress compiln. stats

                     e = 1 to suppress execn. stats
                     f = 1/0 for extnded/compact listing
                     g = 1 for -noexecute
                     h = 1 pre-associate /terminal/

                     i = 1 for standard listing option.
                     j = 1 suppresses listing header
                     k = 1 for -print
                     l = 1 for -noerrors
                     m = 1 for -case 1
```

### SYSPR -- print line on standard output file

SYSPR is used to print a single line on the
standard output file.

```
       (XR)                  pointer to line buffer (scblk)
       (WA)                  line length
       JSR  SYSPR            call to print line
       PPM  loc              too much o/p or no file after SYSXI
       (WA,WB)               destroyed
```

The buffer pointed to is the length obtained from the
SYSPP call and is filled out with trailing blanks.
the value in *wa* is the actual line length which may
be less than the maximum line length possible. there is no space
control associated with the line, all lines are printed single spaced.

Note that null lines (*wa*=0) are possible in which
case a blank line is to be printed.

The error exit is used for systems which limit the amount of
printed output.

If possible, printing should be permitted after this
condition has been signalled once to allow for dump and other
diagnostic information.  assuming this to be possible, SPITBOL may
make more SYSPR calls. if the error return occurs
another time, execution is terminated by a call of
SYSEJ with ending code 998.

### SYSRD -- read record from standard input
file

SYSRD is used to read a record from the standard
input file. the buffer provided is an SCBLK for a
string the length of which in characters is given in
WC, this corresponding to the maximum length of
string which SPITBOL is prepared to receive. at compile time it
corresponds to xxx in the most recent `-inxxx` card (default 72) and at
execution time to the most recent ,*r* (record length) in the third
arg of an input() statement for the standard input file (default 80).

If fewer than (WC) characters are read, the length field of the SCBLK must be adjusted before
returning unless the buffer is right padded with zeroes.

It is also permissible to take the alternative return after such an adjustment has been made.

SPITBOL may continue to make calls after an endfile return so this
routine should be prepared to make repeated endfile returns.

```
       (XR)                  pointer to buffer (scblk pointer)
       (WC)                  length of buffer in characters
       JSR  sysrd            call to read line
       PPM  loc              endfile or no i/p file after SYSXI
                             or input file name change.  if
                             the former,scblk length is zero.
                             if input file name change, length
                             is non-zero. caller should re-issue
                             sysrd to obtain input record.
       (WA,WB,WC)            destroyed
```

### SYSRI -- read record from interactive channel

Reads a record from online terminal for SPITBOL variable,
terminal. if online terminal is unavailable then code the endfile
return only.

The buffer provided is of length 258 characters.
SYSRI should replace the count in the second word of
the SCBLK by the actual character count unless buffer
is right padded with zeroes.

It is also permissible to take the alternative return after
adjusting the count.

The end of file return may be used if this makes
sense on the target machine (e.g. if there is an
eof character.)

```
       (XR)                  pointer to 258 char buffer (scblk pointer)
       JSR  sysri            call to read line from terminal
       PPM  loc              end of file return
       (WA,WB,WC)            may be destroyed
```

###  SYSRW -- rewind file

SYSRW is used to rewind a file i.e. reposition
the file at the start before the first record. the file should be
closed and the next read or write call will open the file at the
start.

```
       (WA)                  pointer to FCBLK or zero
       (XR)                  rewind arg scblk pointer)
       JSR  sysrw            call to rewind file
       PPM loc return here if file does not exist
       PPM loc return here if rewind not allowed PPM loc return here if i / o error
```

### SYSST -- set file pointer

SYSST is called to change the position of a file
pointer. this is accomplished in a system dependent manner, and thus
the 2nd and 3rd arguments are passed unconverted.

```
       (WA)                  FCBLK pointer
       (WB)                  2nd argument
       (WC)                  3rd argument
       JSR  SYSST            call to set file pointer
       PPM  loc              return here if invalid 2nd arg
       PPM  loc              return here if invalid 3rd arg
       PPM  loc              return here if file does not exist
       PPM  loc              return here if set not allowed
       PPM  loc              return here if i/o error
```

### SYSTM -- get execution time so far

SYSTM is used to obtain the amount of execution
time used so far since SPITBOL was given control. the units are
described as milliseconds in the SPITBOL output, but the exact meaning
is system dependent. where appropriate, this value should relate to
processor rather than clock timing values.

If the symbol `.ctm` is defined, the units are described as
deciseconds (0.1 second).

```
       JSR  systm            call to get timer value
       (IA)                  time so far in milliseconds
                            (deciseconds if .ctmd defined)
```

###  SYSTT -- trace toggle

Called by SPITBOL function trace() with no args to toggle the
system trace switch.  this permits tracing of labels in SPITBOL code
to be turned on or off.

```
       JSR  systt            call to toggle trace switch
```

### SYSUL -- unload external function

SYSUL is used to unload a function previously
loaded with a call to SYSLD.

```
       (XR)                  pointer to control block (efblk)
       JSR  SYSUL            call to unload function
```

The function cannot be called following a SYSUL
call until another SYSLD call is made for the same function.

The EFBLK contains the function code pointer and
also a pointer to the vrblk containing the function name (see
definitions and data structures section).

### SYSXI -- exit to produce load module

When SYSXI is called, XL contains either a string pointer or zero. In the former case, the
string gives the character name of a program. The intention is that
SPITBOL execution should be terminated forthwith and the named program
loaded and executed.

This type of chain execution is very system dependent and
implementors may choose to omit it or find it impossible to provide.

If XL) is zero,ia contains one of the following
integers

```
-1, -2, -3, -4
    Create if possible a load module containing only the
    impure area of memory which needs to be loaded with
    a compatible pure segment for subsequent executions.
    Version numbers to check compatibility should be
    kept in both segments and checked on loading.
    To assist with this check, (XR) on entry is a
    pointer to an SCBLK containing the SPITBOL major
    version number v.v (see SYSID).  The file thus
    created is called a save file.

0    If possible, return control to job control
    command level. The effect if available will be
    system dependent.

+1, +2, +3, +4
    Create if possible a load module from all of
    memory. It should be possible to load and execute
    this module directly.
```

In the case of saved load modules, the status of open files is not
preserved and implementors may choose to offer means of attaching
files before execution of load modules starts or leave it to the user
to include suitable input(), output() calls in his program.
SYSXI should make a note that no i/o channels,
including standard files, have files attached so that calls of
SYSIN, SYSOU, SYSPR,

SYSRD should fail unless new associations are made for the load module.  at least in the case of the standard output file,

It is recommended that either the user be required to attach a file
or that a default file is attached, since the problem of error
messages generated by the load module is otherwise severe.As a
last resort, if SPITBOL attempts to write to the standard output file
and gets a reply indicating that such ouput is unacceptable it stops
by using an entry to SYSEJ with ending code 998.  As
described below, passing of some arguments makes it clear that load
module will use a standard output file.

If use is made of FCBLKs for i/o association,
SPITBOL builds a chain so that those in use may be found in
SYSXI and SYSEJ. The nodes are 4
words long. The third word contains link to next node or 0, and the
fourth word contains a FCBLK pointer.

```
       (XL)                  zero or scblk pointer to first argument
       (XR)                  pointer to v.v scblk
       (IA)                  signed integer argument
       (WA)                  scblk pointer to second argument
       (WB)                  0 or pointer to head of FCBLK chain
       JSR  SYSXI            call to exit
       PPM  loc              requested action not possible
       PPM  loc              action caused irrecoverable error
       (WB,WC,IA,XR,XL,CP)   should be preserved over call
       (WA)                  0 in all cases except sucessful
                             performance of exit(4) or exit(-4),
                             in which case 1 should be returned.
```

Loading and running the load module or returning from jcl command
level causes execution to resume at the point after the error returns
which follow the call of SYSXI.  The value passed as
exit argument is used to indicate options required on resumption of
load module.

The values +1 or -1 require that on resumption, SYSID and
SYSPP be called and a heading printed on the standard
output file.

The values +2 or -2 indicate that SYSPP will be called but not SYSID
and no heading will be put on standard output file.

Above options have the obvious implication that a
standard o/p file must be provided for the load module.

The values +3, +4, -3 or -4 indicate calls of neither SYSID nor
SYSPP and no heading will be placed on standard output
       file.

The values  +4 or -4 indicate that execution is to continue after creation of
the save file or load module, although all files will be closed by the
SYSXI action.  This permits the user to checkpoint
long-running programs while continuing execution.

No return from SYSXI is possible if another
program is loadednd entered.
