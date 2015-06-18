

MINIMAL -- Machine Independent Macro Assembly Language.
=================

Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer

Copyright 2015 David Shields


The following sections describe the implementation language developed
for SPITBOL.  MINIMAL is an assembly language for an
idealized machine. The following describes the basic characteristics of this
machine and the MINIMAL language.

Statement format
-----------

All labels are exactly five characters long and start with three letters
(abcdefghijklmnopqrstuvwxy$) followed by two letters or digits.  The letter z
may not be used in MINIMAL symbols but $ is permitted.  For implementations
where $ may not appear in the target code , a simple substitution of z for $ may
Thus be made without risk of producing non-unique symbols.  The letter z is
however permitted in opcode mnemonics and in comments.

MINIMAL statements are in a variable format with fields separated by whitespace, consisting of one or
more blanks or tabs.

A label definition must begin a line, with no whitespace before it.

The operation must be preceded by whitespace.

Operands, if any, follow the operation.

Comments begin with a semicolon character, and continue through to the end of the line.

Section 1 - Configuration Parameters
--------------

There are several parameters which may vary with the target machine.  The
macro-program is independent of the actual definitions of these parameters.

The definitions of these parameters are supplied by the translation program to
match the target machine.

CFP_A

Number of distinct characters in internal alphabet in the range 64 <= CFP_A <= MXLEN.

CFP_B

Number of bytes in a word where a byte is the amount of storage addressed by the least significant address bit.

CFP_C

Number of characters which can be stored in a single word.

CFP_F

Byte offset from start of a string block to the first character. Depends both on target machine and string data structure. See *plc*, *PSC*

CFP_I

Number of words in a signed integer constant

CFP_L

The largest unsigned integer of form 2**n - 1 which can be stored in a single word.  N will often be CFP_N but need not be.
CFP_M

The largest positive signed integer of form 2**n - 1 which can be stored in a
single word. N will often be CFP_N-1 but need not be.

CFP_N

Number of bits which can be stored in a one word bit string.

CFP_R

Number of words in a real constant

CFP_S

Number of significant digits to be output in conversion of a real quantity. 
The integer consisting of this number of 9s must not be too large to fit in the integer accumulator.


CFP_U

Realistic upper bound on alphabet.


CFP_X

Number of digits in real exponent.

Section 2 - Memory
-----------

Memory is organized into words which each contain CFP_B bytes. For word machines
CFP_B, which is a configuration parameter, may be one in which case words and
bytes are identical. To each word corresponds an address which is a non-negative
quantity which is a multiple of CFP_B. Data is organized into words as follows.

1. A signed integer value occupies CFP_I consecutive words (CFP_I is a configuration parameter).
The range may include more negative numbers than positive (e.g. The twos complement representation).

2. A signed real value occupies CFP_R consecutive words. (CFP_R is a configuration
parameter).

3.  CFP_C characters may be stored in a single word (CFP_C is a configuration
parameter).

4. A bit string containing CFP_N bits can be stored in a single word (CFP_N is a
configuration parameter).

5. A word can contain a unsigned integer value in the range (0 <= n <= CFP_L).
These integer values may represent addresses of other words and some of the
instructions use this fact to provide indexing and indirection facilities.

6. Program instructions occupy words in an undefined manner. Depending on the
actual implementation, instructions may occupy several words, or part of a word,
or even be split over word boundaries.

The following regions of memory are available to the program. Each region
consists of a series of words with consecutive addresses.

1. constant section, with assembled constants
2. working storage section
3. program section, with assembled instructions
4. stack area
5. data area


Section 3 - Registers
---------------

There are three index registers called XR,XL,XS. In addition XL may sometimes be
referred to by the alias of XT - see section 4. Any of the above registers may
hold a positive unsigned integer in the range (0 <= n i <= CFP_L). when the index
register is used for indexing purposes, this must be an appropriate address.  XS
is special in that it is used to point to the top item of a stack in memory. The
stack may build up or down in memory.since it is required that XS points to the
stack top but access to items below the top is permitted, registers XS and XT
may be used with suitable offsets to index stacked items. Only XS and XT may be
used for

This purpose since the direction of the offset is target machine dependent. XT
is a synonym for XL which therefore cannot be used in code sequences referencing
XT.

The stack is used for subroutine linkage and temporary data storage for which the stack
arrangement is suitable.  XR,XL can also contain a character pointer in
conjunction with the character instructions (see description of PLC).  

There are three work registers called WA,WB,WC which can contain any data item
which can be stored in a single memory word. In fact, the work registers are
just like memory locations except that they have no addresses and are referenced
in a special way by the instructions.

Note that registers WA,WB have special uses in connection with the CVD, CVM,
MVC, MVW, MWB, CMC, and TRC instructions.

There is an integer accumulator (IA) which is capable of holding a signed
integer value (CFP_I words long).

Register WC may overlap the integer accumulator (IA) in some implementations.
Thus any operation changing the value in WC leaves (IA) undefined and vice versa
except as noted in the following restriction on simple dump/restore operations.

If IA and WC overlap then

```nasm
    STI  iasav
    LDI  iasav
```

Does not change WC, and

```nasm
    MOV  WC,wcsav
    MOV  wcsav,WC
```

does not change IA.

There is a single real accumulator (RA) which can hold any real value and is
completely separate from any of the other registers or program accessible
locations.

The code pointer register (CP) is a special index register for use in
implementations of interpretors.  It is used to contain a pseudo-code pointer
and can only be affected by ICP, lCP, SCP and LCW instructions.

Section 4 - The Stack
------------------

The following notes are to guide both implementors of systems written in MINIMAL
and MINIMAL programmers in dealing with stack manipulation.  Implementation of a
downwards building stack is easiest and in general is to be preferred, in which
case it is merely necessary to consider XT as an alternative name for XL.

The MINIMAL virtual machine includes a stack and has operand formats -(XS) and
(XS)+ for pushing and popping items with an implication that the stack builds
down in memory (a d-stack). However on some target machines it is better for the
stack to build up (a u-stack).

A stack addressed only by push and pop operations can build in either direction with no complication but such a pure
scheme of stack access proves restrictive. Hence it is permitted to access
buried items using an integer offset past the index register pointing to the
stack top. On target machines this offset will be positive/negative for
d-stacks/u-stacks and this must be allowed for in the translation.  

A further restriction is that at no time may an item be placed above the stack top. For
some operations this makes it convenient to advance the stack pointer and then
address items below it using a second index register.  The problem of signed
offsets past such a register then arises. 

To distinguish stack offsets, which in some implementations may be negative, from non-stack offsets which are
invariably positive, XT, an alias or synonym for XL is used. For a u-stack
implementation, the MINIMAL translator should negate the sign of offsets applied
To both (XS) and (XT). Programmers should note that since XT is not a separate
register, XL should not be used in code where XT is referenced. Other
modifications needed in u-stack translations are in the ADD, SUB, ICA, DCA
opcodes applied to XS, XT. For example

```nasm
MINIMAL           d-stack trans.  u-stack trans.

MOV  WA,-(XS)     SBI  XS,1       ADI  XS,1
                  STO  WA,(XS)    STO  WA,(XS)
MOV  (XT)+,WC     LOD  WC,(XL)    LOD  WC,(XL)
                  ADI  XL,1       SBI  XL,1
ADD  =seven,XS    ADI  XS,7       SBI  XS,7
MOV  2(XT),WA     LOD  WA,2(XL)   LOD  WA,-2(XL)
ICA  XS           ADI  XS,1       SBI  XS,1
```
note that forms such as

```nasm
MOV  -(XS),WA
ADD  WA,(XS)+
```

are illegal, since they assume information storage above the stack top.

Section 5 - Internal Character Set
-------------

The internal character set is represented by a set of contiguous codes from 0 to
CFP_A-1. The codes for the digits 0-9 must be contiguous and in sequence. Other
than this, there are no restraints.

The following symbols are automatically defined to have the value of the
corresponding internal character code.

```nasm
ch_la                 letter a
ch_lb                 letter b
.                     .
ch_l$                 letter z

ch_d0                 digit 0
.                     .
ch_d9                 digit 9

ch_am                 ampersand
ch_as                 asterisk
ch_at                 at
ch_bb                 left bracket
ch_bl                 blank
ch_br                 vertical bar
ch_cl                 colon
ch_cm                 comma
ch_dl                 dollar sign
ch_dt                 dot (period)
ch_dq                 double quote
ch_eq                 equal sign
ch_ex                 exclamation mark
ch_mn                 minus
ch_nm                 number sign
ch_nt                 not
ch_pc                 percent
ch_pl                 plus
ch_pp                 left paren
ch_rb                 right bracket
ch_rp                 right paren
ch_qu                 question mark
ch_sl                 slash
ch_sm                 semi-colon
ch_sq                 single quote
ch_un                 underline
```

The following optional symbols are incorporated by defining the conditional assembly symbol named.

26 shifted letters incorporated by defining .casl

```nasm
ch_a                 shifted a
ch_b                 shifted b
.                     .
ch_$                 shifted z

ch_ht                 horizontal tab - define .caht
ch_vt                 vertical tab   - define .cavt
ch_ey                 up arrow       - define .caex
```


Section 6 - Conditional Assembly Features
------------

Some features of the interpreter are applicable to only certain target machines.
They may be incorporated or omitted by use of conditional assembly. The full
form of a condition is -

```nasm
.if    conditional assembly symbol    (cas)
.then
       MINIMAL statements1   (ms1)
.else
       MINIMAL statements2   (ms2)
.fi
```

The following rules apply

1. The directives .if, .then, .else, .fi must start in column 1.
2. The conditional assembly symbol must start with a
     dot in column 8 followed by 4 letters or digits e.g.
```nasm
        .ca$1
```
3. .then is redundant and may be omitted if wished.
4. Ms1, ms2 are arbitrary sequences of MINIMAL
     statements either of which may be null or may
     contain further conditions.
5. If ms2 is omitted, .else may also be omitted.
6. .fi is required.
7. Conditions may be nested to a depth determined
     by the translator (not less than 20, say).

Selection of the alternatives ms1, ms2 is by means of the define and undefine directives of form -

```nasm
.DEF   cas
.UNDEF cas
```

which obey rules 1. and 2. above and may occur at any point in a MINIMAL
program, including within a condition.  Multiply defining a symbol is an error.
undefining a symbol which is not defined is not an error.

The effect is that if a symbol is currently defined, then in any condition
depending on it, ms1 will be processed and ms2 omitted.  Conversely if it is
undefined, ms1 will be omitted and ms2 processed.

Nesting of conditions is such that conditions in a section not selected for
processing must not be evaluated. Nested conditions must remember their
environment whilst being processed. Effectively this implies use of a scheme
based on a stack with .if, .fi matching by the condition processor of the
translator.  

Section 7 - operand formats

The following section describes the various possibilities for operands of
instructions and assembly operations.

|Type|Name|Description|
|:------|:--------|:---------|
|01|_int_|unsigned integer <= CFP_L|
|02|_dlbl_|symbol defined in definitions sec|
|03|_wlbl_|label in working storage section|
|04|_clbl_|label in constant section|
|05|_elbl_|program section entry label|
|06|_plbl_|program section label (non-entry)|
|07|_x_|one of the three index registers|
|08|_w_|one of the three work registers|
|09|(_x_)|location indexed by _x_|
|10|(_x_)+|like (_x_) but post increment _x_|
|11|-(_x_)|like (_x_) but predecrement _x_|
|12|_int(x)_|location _int_ words beyond addr in _x_|
|13|_dlbl(x)_|location dlbl words past address in _x_|
|14|_clbl(x)_|location (_x_) bytes beyond _clbl_|
|15|_wlbl(x)_|location (_x_) bytes beyond _wlbl_|
|16|_integer_|signed integer (DIC)|
|17|_real_|signed real (DRC)|
|18|=_dlbl_|location containing DAC _dlbl_|
|19|*_dlbl_|location containing DAC CFP_B*_dlbl_|
|20|=_wlbl_|location containing DAC _wlbl_|
|21|=_clbl_|location containing DAC _clbl_|
|22|=_elbl_|location containing DAC _elbl_|
|23|_pnam_|procedure label (on PRC instruc)|
|24|_eqop_|operand for EQU instruction|
|25|_ptyp_|procedure type (see PRC)|
|26|_text_|arbitrary text (ERB,ERR,TTL)|
|27|_dtext_|delimited text string (DTC)|

The type numbers in the above list are used in subsequent description and in some of
The MINIMAL translators.


The following special symbols refer to a collection of the listed possibilities

_val_  01,02 ; predefined value

_Val_ is used to refer to a predefined one word integer value in the range 0 <= n <= CFP_L.

_reg_  07,08  ; register

_reg_ is used to describe an operand which can be any of the registers
(XL,XR,XS,XT,WA,WB,WC). Such an operand can hold a one word integer (address).

_opc_  09,10,11  ; character

_opc_ is used to designate a specific character operand for use in the lch and sch
instructions.  The index register referenced must be either XR or XL (not
XS or XT). See section on character operations.

_ops_  03,04,09,12,13,14,15  ; memory reference

_ops_ is used to describe an operand which is in memory. The operand may be one or
more words long depending on the data type. In the case of multiword operands,
The address given is the first word.

_opw_  as for _ops_ + 08,10,11  ; full word

_opw_ is used to refer to an operand whose capacity is that of a full memory word.
_opw_ includes all the possibilities for _ops_ (the referenced word is used) plus
the use of one of the three work registers (WA,WB,WC). 

In addition, the formats (_x_)+ and -(_x_) allow indexed operations in which the index register is popped by
one word after the reference (_x_)+, or pushed by one word before the reference
-(_x_).

These latter two formats provide a facility for manipulation of stacks. The
format does not imply a particular direction in which stacks must build - it is
used for compactness. 

Note that there is a restriction which disallows an instruction to use an index register in one 
of these formats in some other manner in the same instruction.
For example.  `MOV XL,(XL)+` is illegal.  

The formats -(_x_) and (_x_)+ may also be used in pre-decrementation, post-incrementation to
access the adjacent character of a string.


_opn_  as for _opw_ + 07; one word integer

The operand _opn_ is used to represent an operand location which can contain a one word
integer (e.g. an address).  This includes all the possibilities for _opw_ plus the
use of one of the index registers (XL,XR,XT, XS). The range of integer values is
0 <= n <= CFP_L.

_opv_  as for _opn_ + 18-2  ; one word integer value

The _opv_ operand is used for an operand which can yield a one word integer value (e.g. an
address). It includes all the possibilities for _opn_ (the current value of the
location is used) plus the use of literals. 

Note that although the literal
formats are described in terms of a reference to a location containing an
address constant, this location may not actually exist in some implementations
since only the value is required. 

A restriction is placed on literals which may
consist only of defined symbols and certain labels. Consequently small integers
To be used as literals must be pre-defined, a discipline aiding program
maintenance and revision.

_addr_ 01,02,03,04,05 ; address

_Addr_ is used to describe an explicit address value (one word integer value) for
use with DAC.

```nasm
     ****************************************************
     *   in the following descriptions the usage --     *
     *      (XL),(XR), ... ,(IA)                        *
     *   in the descriptive text signifies the          +
     *   contents of the stated register.               *
     ****************************************************
```

Section 8 - List Of Instruction Mnemonics
-----------------

The following list includes all instruction and assembly operation mnemonics in
alphabetical order.  The mnemonics are preceded by a number identifying the
following section where the instruction is described.  An asterisk is appended
To the mnemonic if the last operand may optionally be omitted.


|Section|Operation|Operands|Description|
|:---|:---|:---|:---|
|2.1|ADD|_opv_,_opn_|add address|
|4.2|ADI|_ops_|add integer|
|5.3|ADR|_ops_|add real|
|7.1|ANB|_opw_,_w_|and bit string|
|2.17|AOV|_opv_,_opn_,_plbl_|add address, fail if overflow|
|5.16|ATN||arctangent of real accumulator|
|2.16|BCT|_w_,_plbl_|branch and count|
|2.5|BEQ|_opn_,_opv_,_plbl_|branch if address equal|
|2.18|BEV|_opn_,_plbl_|branch if address even|
|2.8|BGE|_opn_,_opv_,_plbl_|branch if address greater or equl|
|2.7|BGT|_opn_,_opv_,_plbl_|branch if address greater|
|2.12|BHI|_opn_,_opv_,_plbl_|branch if address high|
|2.10|BLE|_opn_,_opv_,_plbl_|branch if address less or equal|
|2.11|BLO|_opn_,_opv_,_plbl_|branch if address low|
|2.9|BLT|_opn_,_opv_,_plbl_|branch if address less than|
|2.6|BNE|_opn_,_opv_,_plbl_|branch if address not equal|
|2.13|BNZ|_opn_,_plbl_|branch if address non-zero|
|2.19|BOD|_opn_,_plbl_|branch if address odd|
|1.2|BRN|_plbl_| branch unconditional|
|1.7|BRI|_opn_|branch indirect|
|1.3|BSW*|_x_,_val_,_plbl_|branch on switch value|
|8.2|BTW|_reg_|convert bytes to words|
|2.14|BZE|_opn_,_plbl_|branch if address zero|
|6.6|CEQ|_opw_,_opw_,_plbl_|branch if characters equal|
10.1|CHK|| check stack overflow|
|5.17|CHP||integer portion of real accumulator|
|7.4|CMB|_w_|complement bit string|
|6.8|CMC|_plbl_,_plbl_|compare character strings|
|6.7|CNE|_opw_,_opw_,_plbl_|branch if characters not equal|
|6.5|CSC|_x_|complete store characters|
|5.18|COS||cosine of real accumulator|
|8.8|CTB|_w_,_val_|convert character count to bytes|
|8.7|CTW|_w_,_val_|convert character count to words|
|8.10|CVD||convert by division|
|8.9|CVM|_plbl_| convert by multiplication|
11.1|DAC|_addr_| define address constant|
11.5|DBC|_val_|define bit string constant|
|2.4|DCA|_opn_|decrement address by one word|
|1.17|DCV|_opn_|decrement value by one|
11.2|DIC|_integer_|define integer constant|
11.3|DRC|_real_| define real constant|
11.4|DTC|_dtext_|define text (character) constant|
|4.5|DVI|_ops_|divide integer|
|5.6|DVR|_ops_|divide real|
13.1|EJC|| eject assembly listing|
14.2|END|| end of assembly|
|1.13|ENP||define end of procedure|
|1.6|ENT*|_val_|define entry point|
12.1|EQU|_eqop_| define symbolic value|
|1.15|ERB|_int_,_text_|assemble error code and branch|
|1.14|ERR|_int,text_|assemble error code |
|1.5|ESW|| end of switch list for BSW|
|5.19|ETX||e to the power in the real accumulator|
|1.12|EXI*|_int_|exit from procedure|
12.2|EXP|| define external procedure|
|6.10|FLC|_w_|fold character to upper case|
|2.3|ICA|_opn_|increment address by one word|
|3.4|ICP|| increment code pointer|
|1.16|ICV|_opn_|increment value by one|
|4.11|IEQ|_plbl_|jump if integer zero|
|1.4|IFF|_val_,_plbl_| specify branch for BSW|
|4.12|IGE|_plbl_|jump if integer non-negative|
|4.13|IGT|_plbl_|jump if integer positive|
|4.14|ILE|_plbl_|jump if integer negative or zero|
|4.15|ILT|_plbl_|jump if integer negative|
|4.16|INE|_plbl_|jump if integer non-zero|
|4.9|INO|_plbl_| jump if no integer overflow|
12.3|INP|_ptyp,int_| internal procedure|
12.4|INR|| internal routine|
|4.10|IOV|_plbl_|jump if integer overflow|
|8.5|ITR|| convert integer to real|
|1.9|JSR|_pnam_| call procedure|
|6.3|LCH|_reg_,_opc_|load character|
|2.15|LCT|_w_,_opv_|load counter for loop|
|3.1|LCP|_reg_|load code pointer register|
|3.3|LCW|_reg_|load next code word|
|4.1|LDI|_ops_|load integer|
|5.1|LDR|_ops_|load real|
|1.8|LEI|_x_|load entry point id|
|5.20|LNF||natural logorithm of real accumulator|
|7.6|LSH|_w_,_val_|left shift bit string|
|7.8|LSX|_w_,(_x_)|left shift indexed|
|9.4|MCB|| move characterswords backwards|
|8.4|MFI*|_opn_,_plbl_|convert (IA) to address value|
|4.3|MLI|_ops_|multiply integer|
|5.5|MLR|_ops_|multiply real|
|1.19|MNZ|_opn_|move non-zero|
|1.1|MOV|_opv_,_opn_|move|
|8.3|MTI|_opn_|move address value to (IA)|
|9.1|MVC|| move characters|
|9.2|MVW|| move words|
|9.3|MWB|| move words backwards|
|4.8|NGI|| negate integer|
|5.9|NGR|| negate real|
|7.9|NZB|_w_,_plbl_| jump if not all zero bits|
|7.2|ORB|_opw_,_w_|or bit strings|
|6.1|PLC*|_x_,_opv_|prepare to load characters|
|1.10|PPM*|_plbl_|provide procedure exit parameter|
|1.11|PRC|_ptyp_,_val_|define start of procedure|
|6.2|PSC*|_x_,_opv_|prepare to store characters|
|5.10|REQ|_plbl_|jump if real zero|
|5.11|RGE|_plbl_|jump if real positive or zero|
|5.12|RGT|_plbl_|jump if real positive|
|5.13|RLE|_plbl_|jump if real negative or zero|
|5.14|RLT|_plbl_|jump if real negative|
|4.6|RMI|_ops_|remainder integer|
|5.15|RNE|_plbl_|jump if real non-zero|
|5.8|RNO|_plbl_| jump if no real overflow|
|5.7|ROV|_plbl_| jump if real overflow|
|7.5|RSH|_w_,_val_|right shift bit string|
|7.7|RSX|_w_,(_x_)|right shift indexed|
|8.6|RTI*|_plbl_|convert real to integer|
|1.22|RTN||define start of routine|
|4.4|SBI|_ops_|subtract integer|
|5.4|SBR|_ops_|subtract reals|
|6.4|SCH|_reg_,_opc_|store character|
|3.2|SCP|_reg_|store code pointer|
14.1|SEC|| define start of assembly section|
|5.21|SIN||sine of real accumulator|
|5.22|SQR||square root of real accumulator|
|1.20|SSL|_opw_|subroutine stack load|
|1.21|SSS|_opw_|subroutine stack store|
|4.7|STI|_ops_|store integer|
|5.2|STR|_ops_|store real|
|2.2|SUB|_opv_,_opn_|subtract address|
|5.23|TAN||tangent of real accumulator|
|6.9|TRC|| translate character string|
13.2|TTL|_text_| supply assembly title|
|8.1|WTB|_reg_|convert words to bytes|
|7.3|XOB|_opw_,_w_|exclusive or bit strings|
|1.18|ZER|_opn_|zeroise integer location|
|7.11|ZGB|_opn_|zeroise garbage bits|
|7.10|ZRB|_w_,_plbl_|jump if all zero bits|

Section 9 - MINIMAL instructions
------------

The following descriptions assume the definitions -

```nasm
zeroe  EQU  0
unity  EQU  1
```

-1-  basic instruction set

1.1  MOV  _opv_,_opn_    ;  move one word value


MOV causes the value of operand _opv_ to be set as the new contents of operand
location _opn_. In the case where _opn_ is not an index register, any value which
can normally occupy a memory word (including a part of a multiword real or
integer value) can be transferred using mov. If the target location _opn_ is an
index register, then _opv_ must specify an appropriate one word value or operand
containing such an appropriate value.

1.2  BRN  _plbl_        ; unconditional branch


BRN causes control to be passed to the indicated label in the program section.


1.3  BSW  _x_,val,_plbl_  ; branch on switch value

1.4  IFF  _val,_plbl_    ; provide branch for switch

```
     IFF  val,plbl    ;  ...
     ...

     ...
```

1.5  ESW              ; end of branch switch table


BSW,IFF,ESW provide a capability for a switched branch similar to a FORTRAN
computed goto. The val on the BSW instruction is the maximum number of branches.
The value in _x_ ranges from zero up to but not including this maximum. Each IFF
provides a branch. _Val_ must be less than that given on the BSW and control goes
to _plbl_ if the value in _x_ matches.  If the value in _x_ does not correspond to any
of the IFF entries, then control passes to the _plbl_ on the BSW. This _plbl_
operand may be omitted if there are no values missing from the list.


IFF and ESW may only be used in this context.  Execution of BSW may destroy the
contents of _x_.  The IFF entries may be in any order and since a translator may
Thus need to store and sort them, the comment field is restricted in length (sec
11).  

1.6  ENT  _val_         ; define program entry point


The symbol appearing in the label field is defined to be a program entry point
which can subsequently be used in conjunction with the bri instruction, which
provides the only means of entering the code. It is illegal to fall into code
identified by an entry point. 

The entry symbol is assigned an address which need
not be a multiple of CFP_B but which must be in the range 0 le CFP_L and the
address must not lie within the address range of the allocated data area.
furthermore, addresses of successive entry points must be assigned in some
ascending sequence so that the address comparison instructions can be used to
test the order in which two entry points occur. 

The symbol _val_ gives an
identifying value to the entry point which can be accessed with the LEI
instruction.

Subject to the restriction below, _val_ may be omitted if no such
identification is needed i.e.  If no LEI references the entry point. For this
case, a translation optimisation is possible in which no memory need be reserved
for a null identification which is never to be referenced, but only provided
This is done so as not to interfere with the strictly ascending sequence of
entry point addresses. 

To simplify this optimisation for all implementors, the
following restriction is observed: _val_ may only be omitted if the entry point is
separated from a following entry point by a non-null MINIMAL code sequence.
entry point addresses are accessible only by use of literals (=elbl, section 7)
or DAC constants (section 8-11.1).

1.7  BRI  _opn_         ; branch indirect


The operand _opn_ contains the address of a program entry point (see ent). Control
is passed to the executable code starting at the entry point address.
_opn_ is left unchanged.

1.8  LEI  _x_           ; load entry point identification


_X- contains the address of an entry point for which an identifying value was
given on the the ent line.  LEI replaces the contents of _x_ by this value.  

1.9  JSR  _pnam_        ; call procedure pnam

1.10 PPM  _plbl_        ; provide exit parameter
     PPM  _plbl_        ;  ...
     ...
     PPM  _plbl_        ; ...


JSR causes control to be passed to the named procedure. Pnam is the label on a
PRC statement elsewhere in the program section (see PRC) or has been defined
using an exp instruction.  The PPM exit parameters following the call give names
of program locations (_plbl_-s) to which alternative EXI returns of the called
procedure may pass control. They may optionally be replaced by error returns
(see err). The number of exit parameters following a JSR must equal the _int_ in
The procedure definition. The operand of PPM may be omitted if the corresponding
EXI return is certain not to be taken.

1.11 PRC  _ptyp_,_int_    ; define start of procedure

The symbol appearing in the label field is defined to be the name of a procedure
for use with JSR.  A procedure is a contiguous section of instructions to which
control may be passed with a JSR instruction.  This is the only way in which the
instructions in a procedure may be executed. It is not permitted to fall into a
procedure.  All procedures should be named in section 0 INP statements.


_int_ is the number of exit parameters (PPM-s) to be used in JSR calls.


There are three possibilities for _ptyp_, each consisting of a single letter as
follows.

     R                 recursive


The return point (one or more words) is stored on the stack as though one or
more MOV ...,-(XS) instructions were executed.  

     N                 non-recursive

     the return point is to be stored either

1. In a local storage word associated with the procedure and not directly
available to the program in any other manner or

2. On a subroutine link stack quite distinct from the MINIMAL stack addressed by
XS.  It is an error to use the stack for n-links, since procedure parameters or
results may be passed via the stack.

if method (2) is used for links, error exits (erb,err) from a procedure will
necessitate link stack resetting. The ssl and sss orders provided for this may
be regarded as no-ops for implementations using method (1).

     E                 either


The return point may be stored in either manner according to efficiency
requirements of the actual physical machine used for the implementation. Note
that programming of e type procedures must be independent of the actual
implementation.

The actual form of the return point is undefined.  However, each word stored on
The stack for an r-type call must meet the following requirements.

1 it can be handled as an address and placed in an index register.

2 when used as an operand in an address comparison instruction, it must not
appear to lie within the allocated data area.

3 it is not required to appear to lie within the program section.

1.12 EXI  _int_         ; exit from procedure


The PPM and err parameters following a JSR are numbered starting from 1.  `EXI
_int_` causes control to be returned to the _int_-th such param.  `EXI 1` gives control
to the _plbl_ of the first _PPM_ after the JSR.  If _int_ is omitted, control is
passed back past the last exit parameter (or past the JSR if there are none).
for R and E type procedures, the stack pointer XS must be set to its appropriate
entry value before executing an EXI instruction.  In this case, exi removes
return points from the stack if any are stored there so that the stack pointer
is restored to its calling value.

1.13 ENP              ; define end of procedure body


ENP delimits a procedure body and may not actually be executed, hence it must
have no label.

1.14 ERR  _int_,_text_     ; provide error return


ERR may replace an exit parameter (PPM) in any procedure call. The _int_ argument
is a unique error code in 0 to 899.  The text supplied as the other operand is
arbitrary text in the FORTRAN character set and may be used in constructing a
file of error messages for documenting purposes or for building a direct access
or other file of messages to be used by the error handling code.  In the event
That an EXI attempts to return control via an exit parameter to an ERR, control
is instead passed to the first instruction in the error section (which follows
The program section) with the error code in WA.

1.15 ERB  _int_,_text_    ; error branch


This instruction resembles ERR except that it may occur at any point where a
branch is permitted.  It effects a transfer of control to the error section with
The error code in WA.

1.16 ICV  _opn_         ; increment value by one


ICV increments the value of the operand by unity.  It is equivalent to 

```nasm
	 ADD	=unity,_opn_
```

1.17 DCV  _opn_         ; decrement value by one


DCV decrements the value of the operand by unity.  It is equivalent to 

```nasm
	SUB	=unity,_opn_
```

1.18 ZER  _opn_         ; zeroise _opn_


ZER is equivalent to 

```nasm
	MOV =zeroe,_opn_
```


1.19 MNZ  _opn_         ; move non-zero to _opn_


Any non-zero collectable value may used, for which the opcodes BNZ/BZE will
branch/fail to branch.

1.20 SSL  _opw_         ; subroutine stack load

1.21 SSS  _opw_         ; subroutine stack store


This pair of operations is provided to make possible the use of a local stack to
hold subroutine (subroutine) return links for n-type procedures. sss stores the subroutine
stack pointer in _opw_ and ssl loads the subroutine stack pointer from _opw_. by using sss
in the main program or on entry to a procedure which should regain control on
occurrence of an err or erb and by use of ssl in the error processing sections.

The subroutine stack pointer can be restored giving a link stack cleaned up ready for
resumed execution.  The form of the link stack pointer is undefined in MINIMAL
(it is likely to be a private register known to the translator) and the only
requirement is that it should fit into a single full word.  SSL and SSS are
no-ops if a private link stack is not used.

1.22 RTN              ; define start of routine


A routine is a code chunk used for similar purposes to a procedure.  However it
is entered by any type of conditional or unconditional branch (not by JSR). on
Termination it passes control by a branch (often _bri_ through a code word) or
even permits control to drop through to another routine. No return link exists
and the end of a routine is not marked by an explicit opcode (compare ENP).  All
routines should be named in section 0 INR statements.  

-2-  operations on one word integer values (addresses)

2.1  ADD  _opv_,_opn_

Adds _opv_ to the value in _opn_ and stores the result in _opn_. Undefined if the
result exceeds CFP_L.

2.2  SUB  _opv_,_opn_

subtracts _opv_ from _opn_. stores the result in _opn_. Undefined if the result is
negative.

2.3  ICA  _opn_

increment address in _opn_ equivalent to 

```nasm
	ADD *unity,_opn_
```

2.4  DCA  _opn_         

Decrement address in _opn_, equivalent to 

```nasm
	SUB *unity,_opn_
```

2.5  BEQ  _opn_,_opv_,_plbl_ branch to _plbl_ if _opn_ eq _opv_

2.6  BNE  _opn_,_opv_,_plbl_ branch to _plbl_ if _opn_ ne _opv_

2.7  BGT  _opn_,_opv_,_plbl_ branch to _plbl_ if _opn_ gt _opv_

2.8  BGE  _opn_,_opv_,_plbl_ branch to _plbl_ if _opn_ ge _opv_

2.9  BLT  _opn_,_opv_,_plbl_ branch to _plbl_ if _opn_ lt _opv_

2.10 BLE  _opn_,_opv_,_plbl_ branch to _plbl_ if _opn_ le _opv_

2.11 BLO  _opn_,_opv_,_plbl_ equivalent to blt or ble

2.12 BHI  _opn_,_opv_,_plbl_ equivalent to bgt or bge


The above instructions compare two address values as unsigned integer
values.  The BLO and BHI instructions are used in cases where the
equal condition either does not occur or can result either in a branch
or no branch. This avoids inefficient translations in some implementations.

2.13 BNZ  _opn_,_plbl_

equivalent to 

```nasm
	BNE opn,=zeroe,plbl1
```

2.14 BZE  _opn_,_plbl_

equivalent to 

```nasm
	BEQ opn,=zeroe,plbl1
```

2.15 LCT  _w_,_opv_       ; load counter for BCT

LCT loads a counter value for use with the BCT instruction. The value in _opv_ is
The number of loops to be executed. The value in _w_ after this operation is an
undefined one word integer quantity.

2.16 BCT  _w_,_plbl_      ; branch and count


BCT uses the counter value in _w_ to branch the required number of times and then
finally to fall through to the next instruction. BCT can only be used following
an appropriate LCT instruction.  The value in _w_ after execution of bct is
undefined.

2.17 AOV  _opv_,_opn_,_plbl_ add with carry test


Adds _opv_ to the value in _opn_ and stores result in _opn_. branches to _plbl_ if
result exceeds CFP_L with result in _opn_ undefined. cf. add.

2.18 BEV  _opn_,_plbl_     ; branch if even

2.19 BOD  _opn_,_plbl_     ; branch if odd


These operations are used only if .cepp or .crpp is defined.  On some
implementations, a more efficient implementation is possible by noting that
address of blocks must always be a multiple of CFP_B. we call such addresses
even.  Thus return address on the stack (.crpp) and entry point addresses
(.cepp) can be distinguished from block addresses if they are forced to be odd
(not a multiple of CFP_B).  BEV and BOD branch according as operand is even or
odd, respectively.  

-3-  operations on the code pointer register (CP)


The code pointer register provides a psuedo instruction counter for use in an
interpretor. It may be implemented as a real register or as a memory location,
but in either case it is separate from any other register. The value in the code
pointer register is always a word address (i.e.  a one word integer which is a
multiple of CFP_B).

3.1  LCP  _reg_

Load code pointer register. This instruction causes the code pointer register to
be set from the value in _reg_ which is unchanged

3.2  SCP  _reg_

Store code pointer register this instruction loads the current value in the code
pointer register into reg. (CP) is unchanged.

3.3  LCW  _reg_

Load next code word this instruction causes the word pointed to by CP to be
loaded into the indicated reg. The value in CP is then incremented by one word.
execution of LCW may destroy XL.

3.4  ICP              ; increment CP by one word


On machines with more than three index registers, CP can be treated simply as an
index register.  In this case, the following equivalences apply.

```nasm
     LCP reg is like   MOV reg,CP
     SCP reg is like   MOV CP,reg
     LCW reg is like   MOV (CP)+,reg
     ICP     is like ICA CP
```

Since LCW is allowed to destroy XL, the following implementation using a work
location CP$$$ can also be used.

```nasm
     LCP  reg         MOV  reg,CP$$$

     SCP  reg         MOV  CP$$$,reg

     LCW  reg         MOV  CP$$$,XL
                      MOV  (XL)+,reg
                      MOV  XL,CP$$$

     ICP              ICA  CP$$$
```

-4-  Operations On Signed Integer Values

4.1  LDI  _ops_         ; load integer accumulator from ops

4.2  ADI  _ops_         ; add ops to integer accumulator

4.3  MLI  _ops_         ; multiply integer accumulator by ops

4.4  SBI  _ops_         ; subtract ops from _int_ accumulator

4.5  DVI  _ops_         ; divide integer accumulator by ops

4.6  RMI  _ops_         ; set _int_ accum to mod(intacc,ops)

4.7  STI  _ops_         ; store integer accumulator at ops

4.8  NGI              ; negate the value in the integer accumulator (change its sign)


The equation satisfied by operands and results of dvi and rmi is

```
            div = qot * _ops_ + rem          where

     div = dividend in integer accumulator
     qot = quotient left in IA by div
     ops = the divisor
     rem = remainder left in IA by rmi
```

The sign of the result of DVI is positive if (IA) and (_ops_) have the same sign and is negtive
if they have opposite signs. The sign of (IA) is always used as the sign of the
result of REM.  Assuming in each case that IA contains the number specified in
parentheses and that seven and msevn hold +7 and -7 resp. The algorithm is
illustrated below.

```nasm
     (IA = 13)
     DVI  seven       IA = 1
     RMI  seven       IA = 6
     DVI  msevn       IA = -1
     RMI  msevn       IA = 6
     (IA = -13)
     DVI  seven       IA = -1
     RMI  seven       IA = -6
     DVI  msevn       IA = 1
     RMI  msevn       IA = -6
```

The above instructions operate on a full range of signed integer values. 
With the exception of LDI and STI, these instructions may cause integer overflow by
attempting to produce an undefined or out of range result in which case integer
overflow is set, the result in (IA) is undefined and the following instruction
must be IOV or INO.  Particular care may be needed on target machines having
distinct overflow and divide by zero conditions.

4.9  INO  _plbl_        ; jump to _plbl_ if no integer overflow

4.10 IOV  _plbl_        ; jump to _plbl_ if integer overflow


These instructions can only occur immediately following an instruction which can
cause integer overflow (ADI, SBI, MLI, DVI, RMI, NGI) and test the result of the
preceding instruction.  IOV and INO may not have labels.

4.11 IEQ  _plbl_        ; jump to _plbl_ if (IA) eq 0

4.12 IGE  _plbl_        ; jump to _plbl_ if (IA) ge 0

4.13 IGT  _plbl_        ; jump to _plbl_ if (IA) gt 0

4.14 ILE  _plbl_        ; jump to _plbl_ if (IA) le 0

4.15 ILT  _plbl_        ; jump to _plbl_ if (IA) lt 0

4.16 INE  _plbl_        ; jump to _plbl_ if (IA) ne 0


The above conditional jump instructions do not change the contents of the
accumulator.  On a ones complement machine, it is permissible to produce
negative zero in IA provided these instructions operate correctly with such a
value.  

-5-  operations on real values

5.1  LDR  _ops_         ; load real accumulator from ops

5.2  STR  _ops_         ; store real accumulator at ops

5.3  ADR  _ops_         ; add ops to real accumulator

5.4  SBR  _ops_         ; subtract ops from real accumulator

5.5  MLR  _ops_         ; multiply real accumulator by ops

5.6  DVR  _ops_         ; divide real accumulator by ops


If the result of any of the above operations causes underflow, the result
yielded is 0.0.


If the result of any of the above operations is undefined or out of range, real
overflow is set, the contents of (RA) are undefined and the following
instruction must be either ROV or RNO.  Particular care may be needed on target
machines having distinct overflow and divide by zero conditions.

5.7  ROV  _plbl_        ; jump to _plbl_ if real overflow

5.8  RNO  _plbl_        ; jump to _plbl_ if no real overflow


These instructions can only occur immediately following an instruction which can
cause real overflow (ADR,SBR,MLR,DVR).

5.9  NGR              ; negate real accum (change sign)

5.10 REQ  _plbl_        ; jump to _plbl_ if (ra) eq 0.0

5.11 RGE  _plbl_        ; jump to _plbl_ if (ra) ge 0.0

5.12 RGT  _plbl_        ; jump to _plbl_ if (ra) gt 0.0

5.13 RLE  _plbl_        ; jump to _plbl_ if (ra) le 0.0

5.14 RLT  _plbl_        ; jump to _plbl_ if (ra) lt 0.0

5.15 RNE  _plbl_        ; jump to _plbl_ if (ra) ne 0.0


The above conditional instructions do not affect the value stored in the real
accumulator.  On a ones complement machine, it is permissible to produce
negative zero in RA provided these instructions operate correctly with such a
value.

5.16 ATN              ; arctangent of real accum

5.17 CHP              ; integer portion of real accum

5.18 COS              ; cosine of real accum

5.19 ETX              ; e to the power in the real accum

5.20 LNF              ; natural logorithm of real accum

5.21 SIN              ; sine of real accum

5.22 SQR              ; square root of real accum

5.23 TAN              ; tangent of real accum


The above orders operate upon the real accumulator, and replace the contents of
the accumulator with the result.


If the result of any of the above operations is undefined or out of range, real
overflow is set, the contents of (RA) are undefined and the following
instruction must be either ROV or RNO.  .fi

-6-  operations on character values


Character operations employ the concept of a character pointer which uses either
index register XR or XL (not XS).


A character pointer points to a specific character in a string of characters
stored CFP_C chars to a word. The only operations permitted on a character
pointer are LCH and SCH. In particular, a character pointer may not even be
moved with MOV.

+ restriction 1.

It is important when coding in MINIMAL to ensure that no action occurring
between the initial use of PLC or PSC and the eventual clearing of XL or XR on
completion of character operations can initiate a garbage collection. The latter
of course could cause the addressed characters to be moved leaving the character
pointers pointing to rubbish.

+ restriction 2.

A further restriction to be observed in code handling character strings is that
strings built dynamically should be right padded with zero characters to a full
word boundary to permit easy hashing and use of CEQ or CNE in testing strings
for equality.

6.1  PLC  _x_,_opv_       ; prepare character pointer for LCH,CMC,MVC,TRC, MCB.

6.2  PSC  _x_,_opv_       ; prepare character pointer for SCH,MVC,MCB.


The operand _opv_ can be omitted if it is zero.  The chararacter Initially addressed is determined
by the word address in _x_ and the integer offset _opv_.  There is an automatic
implied offset of CFP_F bytes.  CFP_F is used to formally introduce into MINIMAL
A value needed in translating these opcodes which, since MINIMAL itself does not
prescribe a string structure in detail, depends on the choice of a data
structure for strings in the MINIMAL program.  

e.g. If CFP_B = CFP_C = 3, CFP_F = 6, num01 = 1, XL points to a series of 4
words, abc/def/ghi/jkl, then plc XL,=num01 points to h.  

6.3  LCH  _reg_,_opc_     ; load character into _reg_

6.4  SCH  _reg_,_opc_     ; store character from _reg_


These operations are defined such that the character is right justified in
register _reg_ with zero bits to the left. after lch for example, it is legitimate
To regard _reg_ as containing the ordinal integer corresponding to the character.

_opc_ is one of the following three possibilities.

+     (x)
The character pointed to by the character pointer in _x_  The character
pointer is not changed.

+     (x)+
Same character as (_x_) but the character pointer is incremented to point to the
next character following execution.

+     -(x)
The character pointer is decremented before accessing the character so that the
previous character is referenced.

6.5  CSC  _x_           ; complete store characters


This instruction marks completion of a PSC,SCH,SCH,...,SCH sequence initiated by
A PSC _x_ instruction. no more SCH instructions using _x_ should be obeyed until
another PSC is obeyed. It is provided solely as an efficiency aid on machines
without character orders since it permits use of register buffering of chars in
SCH sequences. where CSC is not a no-op, it must observe restriction 2. For exampl, in
SPITBOL, the procedure ALOCS zeroises the last word of a string frame prior to SCH sequence
being started so csc must not nullify this action.


The following instructions are used to compare two words containing CFP_C
characters.  Comparisons distinct from beq,bne are provided as on some target
machines, the possibility of the sign bit being set may require special action.
Note that restriction 2 above, eases use of these orders in testing complete
strings for equality, since whole word tests are possible.

6.6  CEQ  _opw_,_opw_,_plbl_ ; jump to _plbl_ if _opw_ eq _opw_

6.7  CNE  _opw_,_opw_,_plbl_ ; jump to _plbl_ if _opw_ ne _opw_


6.8  CMC  _plbl_,_plbl_   ; compare characters


CMC is used to compare two character strings. Before executing CMC, registers
are set up as follows.

```nasm
     (XL)             character pointer for first string
     (XR)             character pointer for second string

```

XL and XR should have been prepared by PLC.  Control passes to first _plbl_ if the
first string is lexically less than the second string, and to the second _plbl_ if
The first string is lexically greater. control passes to the following
instruction if the strings are identical.  After executing this instruction, the
values of XR and XL are set to zero and the value in (WA) is undefined.

Arguments to CMC may be complete or partial strings, so making optimisation to
use whole word comparisons difficult (dependent in general on shifts and
masking).

6.9  TRC              ; translate characters


TRC is used to translate a character string using a supplied translation table.
before executing TRC the registers are set as follows.

     (XL)             character pointer to string to be translated
     (XR)             character pointer to translate table

     (WA)             length of string to be translated


XL and XR should have been prepared by PLC.  The translate table consists of
CFP_A contiguous characters giving the translations of the CFP_A characters in
The alphabet. On completion, (XR) and (XL) are set to zero and (WA) is
undefined.

6.10 FLC  _w_           ; fold character to upper case


FLC is used only if .culc is defined. The character code value in _w_ is
translated to upper case if it corresponds to a lower case character.


-7-  operations on bit string values

7.1  ANB  _opw_,_w_       ; and bit string values

7.2  ORB  _opw_,_w_       ; or bit string values

7.3  XOB  _opw_,_w_       ; exclusive or bit string values


In the above operations, the logical connective is applied separately to each of
the CFP_N bits.  The result is stored in the second operand location.

7.4  CMB  _w_           ; complement all bits in _opw_

7.5  RSH  _w_,_val_       ; right shift by val bits

7.6  LSH  _w_,_val_       ; left shift by val bits

7.7  RSX  _w_,(_x_)       ; right shift _w_ number of bits in x

7.8  LSX  _w_,(_x_)       ; left shift _w_ number of bits in x


The above shifts are logical shifts in which bits shifted out are lost and zero
bits supplied as required. The shift count is in the range 0-CFP_N.

7.9  NZB  _w_,_plbl_      ; jump to _plbl_ if _w_ is not all zero bits.

7.10 ZRB  _w_,_plbl_      ; jump to _plbl_ if _w_ is all zero bits

7.11 ZGB  _opn_         ; zeroise garbage bits


The operand _opn_ contains a bit string representing a word of characters from a string or
some function formed from such characters (e.g. as a result of hashing). On a
machine where the word size is not a multiple of the character size, some bits
in _reg_ may be undefined. This opcode replaces such bits by the zero bit. ZGB is
a no-op if the word size is a multiple of the character size.  

-8-  Conversion Instructions

The following instructions provide for conversion between lengths in bytes
and lengths in words.

8.1  WTB  _reg_

Convert _reg_ from words to bytes.  That is, multiply by CFP_B. This is a no-op if
CFP_B is one.

8.2  BTW  _reg_

Convert _reg_ from bytes to words by dividing _reg _ by CFP_B discarding the
fraction. This operation does nothing if CFP_B is one


The following instructions provide for conversion of one word integer values
(addresses) to and from the full signed integer format.

8.3  MTI  _opn_

The value of _opn_ (an address) is moved as a positive integer to the integer
accumulator.

8.4  MFI  _opn_,_plbl_

The value currently stored in the integer accumulator is moved to _opn_ as an
address if it is in the range 0 to CFP_M inclusive.  If the accumulator value is
outside this range, then the result in _opn_ is undefined and control is passed to
_plbl_. MFI destroys the value of (IA) whether or not integer overflow is
signalled.  The label _plbl_ may be omitted if overflow is impossible.

The following instructions provide for conversion between real values and
integer values.

8.5  ITR

Convert integer value in integer accumulator to real and store in real
accumulator (may lose precision in some cases)

8.6  RTI  _plbl_

Convert the real value in RA to an integer and place result in IA.  Conversion
is by truncation of the fraction - no rounding occurs.  Jump to _plbl_ if out of
range. (RA) is not changed in either case.  The label _plbl_ may be omitted if overflow is
impossible.  

The following instructions provide for computing the length of storage required
for a text string.

8.7  CTW  _w_,_val_

This instruction computes the sum (number of words required to store _w_
characters) + (_val_). The sum is stored in _w_.  For example, if CFP_C is 5, and WA
contains 32, then CTW WA,2 gives a result of 9 in WA.

8.8  CTB  _w_,_val_

CTB is exactly like CTW except that the result is in bytes. It has the same effect as 

```nasm
	CTW w,val 
	WTB w
```

The following instructions provide for conversion from integers to and from
numeric digit characters for use in numeric conversion routines.  They employ
negative integer values to allow for proper conversion of numbers which cannot
be complemented.

8.9  CVM  _plbl_        ; convert by multiplication


The integer accumulator, which is zero or negative, is multiplied by 10. WB
contains the character code for a digit. The value of this digit is then
subtracted from the result. If the result is out of range, then control is
passed to _plbl_ with the result in (IA) undefined. execution of CVM leaves the
result in (WB) undefined.

8.10 CVD              ; convert by division


The integer accumulator, which is zero or negative, is divided by 10.  The
quotient (zero or negative) is replaced in the accumulator. The remainder is
converted to the character code of a digit and placed in WA. for example, an
operand of -523 gives a quotient of -52 and a remainder in WA of ch_d3.  

-9-  Block Move Instructions

The following instructions are used for transferring data from one area of
memory to another in blocks.  They can be implemented with the indicated series
of other macro-instructions, but more efficient implementations will be
possible on most machines.

Note that in the equivalent code sequence shown below, a zero value in WA will
move at least one item, and may may wrap the counter causing a core dump in some
implementations.  Thus WA should be greater than zero prior to invoking any of these
block move instructions.

9.1  MVC              ; move characters


Before obeying this order WA,XL,XR should have been set up, the latter two by
PLC, PSC respectively.


MVC is equivalent to the sequence

```nasm
            MOV  WB,dumpb
            LCT  WA,WA
     loopc  LCH  WB,(XL)+
            SCH  WB,(XR)+
            BCT  WA,loopc
            CSC  XR
            MOV  dumpb,WB
```

The character pointers are bumped as indicated and the final value of WA is
undefined.


9.2  MVW              ; move words


MVW is equivalent to the sequence

```nasm
     loopw  MOV  (XL)+,(XR)+
            DCA  WA               WA = bytes to move
            BNZ  WA,loopw
```

Note that this implies that the value in WA is the length in bytes which is a
multiple of CFP_B.  The initial addresses in XR,XL are word addresses.  As
indicated, the final XR,XL values point past the new and old regions of memory
respectively.  The final value of WA is undefined.  WA,XL,XR must be set up
before obeying MVW.

9.3  MWB              ; move words backwards


MWB is equivalent to the sequence

```nasm
     loopb  MOV  -(XL),-(XR)
            DCA  WA               WA = bytes to move
            BNZ  WA,loopb
```

There is a requirement that the initial value in XL be at least 256 less than
The value in XR. This allows an implementation in which chunks of 256 bytes are
moved forward (IBM 360, ICL 1900).  The final value of WA is undefined.
WA,XL,XR must be set up before obeying mWB.

9.4  MCB              ; move characters backwards


MCB is equivalent to the sequence

```nasm
            MOV  WB,dumpb
            LCT  WA,WA
     loopc  LCH  WB,-(XL)
            SCH  WB,-(XR)
            BCT  WA,loopc
            CSC  XR
            MOV  dumpb,WB
```

There is a requirement that the initial value in XL be at least 256 less than
The value in XR. This allows an implementation in which chunks of 256 bytes are
moved forward (IBM 360, ICL 1900).  The final value of WA is undefined.
WA,XL,XR must be set up before obeying MCB.


-10- operations connected with the stack

The stack is an area in memory which is dedicated for use in conjunction with
the stack pointer register (XS). As previously described, it is used by the JSR
and EXI instructions and may be used for storage of any other data as required.

The stack builds either way in memory and an important restriction is that the
value in (XS) must be the address of the stack front at all times since some
implementations may randomly destroy stack locations beyond (XS).

The starting stack base address is passed in (XS) at the start of execution.
during execution it is necessary to make sure that the stack does not overflow.
This is achieved by executing the following instruction periodically.

10.1 CHK              ; check stack overflow

After successfully executing CHK, it is permissible to use up to 100 additional
words before issuing another CHK thus CHK need not be issued every time the
stack is expanded. In some implementations, the checking may be automatic and
CHK will have no effect. following the above rule makes sure that the program
will operate correctly in implementations with no automatic check.

If stack overflow occurs (detected either automatically or by a CHK
instruction), then control is passed to the stack overflow section (see program
form). Note that this transfer may take place following any instruction which
stores data at a new location on the stack.  After stack overflow, stack is
arbitrarily popped to give some space in which the error procedure may operate.
otherwise a loop of stack overflows may occur.


-11- data generation instructions

The following instructions are used to generate constant values in the constant
section and also to assemble initial values in the working storage section. They
may not appear except in these two sections.

11.1 DAC  _addr_

Assemble address constant.  Generates one word containing the specified one word
integer value (address).

11.2 DIC  _integer_

Generates an integer value which occupies CFP_I consecutive words.  The operand
is a digit string with a required leading sign.

11.3 DRC  _real_

Assembles a real constant which occupies CFP_R consecutive words.  The operand
form must obey the rules for a FORTRAN real constant with the extra requirement
That a leading sign be present.

11.4 DTC  _dtext_

Define text constant. dtext is started and ended with any character not
contained in the characters to be assembled. The constant occupies consecutive
words as dictated by the configuration parameter CFP_C.  Any unused chars in the
last word are right filled with zeros (i.e.  The character whose internal code
is zero).  The string contains a sequence of letters, digits, blanks and any of
The following special characters.  = , $ . ( * ) / + -  no other characters may be used in
a dtext operand.

11.5 DBC  _val_

Assemble bit string constant. The operand is a positive integer value which is
interpreted in binary, right justified and left filled with zero bits. Thus 5
would imply the bit string value 00...101.  

-12- symbol definition instructions

The following instruction is used to define symbols in the definitions section.
it may not be used elsewhere.

12.1 EQU  _eqop_       ; define symbol


The symbol which appears in the label field is defined to have the absolute
value given by the eqop operand. a given symbol may be defined only once in this
manner, and any symbols occuring in eqop must be previously defined.

The following are the possibilities for eqop

+     val
The indicated value is used

+     _val_+_val_
The sum of the two values is used.  This sum must not exceed CFP_M

+     _val_-_val_
The difference between the two values (must be positive) is used.

+     *
This format defines the label by using a value supplied by the MINIMAL
translator. Values are required for the CFP_X (configuration parameters) e$xxx
(environment parameters) ch_xx (character codes).  In order for a translator to
handle this format correctly the definitions section must be consulted for
details of required symbols as listed at the front of the section.  

The following instructions may be used to define symbols in the procedure
section. They may not be used in any other part of the program.

12.2 EXP              ; define external procedure


EXP defines the symbol appearing in the label field to be the name of an
external procedure which can be referenced in a subsequent JSR instruction. The
coding for the procedure is external to the coding of the source program in this
language.  The code for external procedures may be referred to collectively as
The operating system interface, or more briefly, OSINT, and will frequently be a
separately compiled segment of code loaded with SPITBOL to produce a complete
system.

12.3 INP  _ptyp_,_int_    ; define internal procedure


INP defines the symbol appearing in the label field to be the name of an
internal procedure and gives its type and number of exit parameters. The label
can be referenced in JSR instructions and it must appear labelling a PRC
instruction in the program section.

12.4 INR              ; define internal routine


INR defines the symbol appearing in the label field to be the name of an
internal routine. The label may be referenced in any type of branch order and it
must appear labelling a rtn instruction in the program section.  

-13- Assembly Listing Layout Instructions

13.1 EJC              ; eject to next page

13.2 TTL  _text_        ; set new assembly title

TTL implies an immediate eject of the assembly listing to print the new title.

The use of TTL and EJC instructions is such that the program will list neatly if the
printer prints as many as 58 lines per page. In the event that the printer depth
is less than this, or if the listing contains interspersed lines (such as actual
generated code), then the format may be upset.


Lines starting with a semicolon are comment lines which cause no code to be
generated and may occur freely anywhere in the program. 

-14- program form


The program consists of separate sections separated by sec operations.  The
sections must appear in the following specified order.

14.1 SEC              start of procedure section 

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

14.2 END              end of assembly


Section 10 - Program Form
----------

+ Procedure section


The procedure section contains all the EXP instructions for externally available
procedures and inp,inr opcodes for internal procedures,routines so that a single
pass MINIMAL translator has advance knowledge of procedure types when
translating calls.

+ Definitions section


The definitions section contains EQU instructions which define symbols referenced later on in the program, 
constant and work sections.

+ Constant storage section


The constant storage section consists entirely of constants assembled with the
DAC, DIC,DRC,DTC, and DBC assembly operations. These constants can be freely
referenced by the program instructions.

+ Working storage section


The working storage section consists entirely of DAC,  DIC, DRC, DBC,  and DTC
instructions to define a fixed length work area. The work locations in this area
can be directly referenced in program instructions.  The area is initialized in
accordance with the values assembled in the instructions.

+ Program section


The program section contains program instructions and associated operations
(such as PRC, ENP, ENT).  Control is passed to the first instruction in this
section when execution is initiated.

+ Stack overflow section

The stack overflow section contains instructions like the program section.
control is passed to the first instruction in this section following the
occurrence of stack overflow, see CHK instruction.

+ Error section

The error section contains instructions like the program section. Control is
passed to the first instruction in this section when a procedure exit
corresponds to an error parameter (see ERR) or when an ERB opcode is obeyed. The
error code must clean up the main stack and cater for the possibility that a
subroutine stack may need clean up.


# OSINT


Though not part of the MINIMAL source, it is useful to refer to the collection
of initialisation and external routines as OSINT (operating system interface).
Errors occurring within OSINT procedures are usually handled by making an error
return. If this is not feasible or appropriate, OSINT may use the MINIMAL error
section to report errors directly by branching to it with a suitable numeric
error code in WA.


Section 11 - Program execution
------------

Execution of the program begins with the first instruction in the program section.

In addition to the fixed length memory regions defined by the assembly, there
are two dynamically allocated memory regions as follows.

+ Data area

This is an area available to the program for general storage of data any data
value may be stored in this area except instructions.  In some implementations,
it may be possible to increase the size of this area dynamically by adding words
at the top end with a call to a system procedure.

+ Stack area

This region of memory holds the stack used for subroutine calls and other
storage of one word integer values (addresses). This is the stack associated
with index register XS.

The locations and sizes of these areas are specified by the values in the
registers at the start of program execution as follows.

```nasm
(XS)                  address one past the stack base.  For example, If XS is 23456, a d-stack will
                      occupy words 23455,23454,...,  whereas a u-stack will occupy  23457,23458,...

(XR)                  address of the first word in the data area

(XL)                  address of the last word in the data area.

(WA)                  initial stack pointer

(WB,WC,IA,RA,CP)      zero
```

There is no explicit way to terminate the execution of a program. This function
is performed by an appropriate system procedure referenced with the SYSEJ
instruction.
