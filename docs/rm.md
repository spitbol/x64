
Test

One star is *italic* and two stars are **bold**

One underline is _italic_ and two underlines are __bold__

Bold (underlne)  _this_ _is_ _starred_ but not rest

Bold (two stars)  **This text should be bold**

* list one
* list two
* list three

1 list one
2 list two
3 list three

starred font  here is a use of *edp* and the *do while* statement.
And so *mov* is the mov opcode:  * mov  eax,edx*

underlined font  here is a use of _edp_ and the _do while_ statement.
And so _mov_ is the mov opcode:  _ mov  eax,edx_

monospace font  here is a use of `edp` and the `do while` statement.
And so `mov` is the mov opcode:  ` mov  eax,edx`

Here is straight link: http://github.com/hardbol/spitbol

Here is bracket and paren line [http://github.com/daveshields/md](md test repository)




fenced code block

```
   bss 1
   bss 3
   mov xl,xr
```

and wikh formatting (nasm)

```nasm
  mov edx,eax
  push edx
  jb   lab
label: mov xs,xr
```






 MINIMAL -- machine independent macro assembly lang.

The following sections describe the implementation language originally developed
for SPITBOL but now more widely used. MINIMAL is an assembly language for an
idealized machine. The following describes the basic characteristics of this
machine.

# section 1 - configuration parameters

There are several parameters which may vary with the target machine.  The
macro-program is independent of the actual definitions of these parameters.

The definitions of these parameters are supplied by the translation program to
match the target machine.

CFP_A                 

Number of distinct characters in internal alphabet in the range 64 <= CFP_A <= MXLEN.

CFP_B

Number of bytes in a word where a byte is the amount of storage addressed by the
least significant address bit.

CFP_C                 

Number of characters which can be stored in a single word.

CFP_F                 

Byte offset from start of a string block to the first character. Depends both
on target machine and string data structure. See plc, psc

CFP_I                 

Number of words in a signed integer constant

CFP_L                 

The largest unsigned integer of form 2**n - 1 which can be stored in a single
word.  N will often be CFP_N but need not be.

CFP_M                 

The largest positive signed integer of form 2**n - 1 which can be stored in a
single word. N will often be CFP_N-1 but need not be.

CFP_N                 

Number of bits which can be stored in a one word bit string.

CFP_R                 

Number of words in a real constant

CFP_S                 

Number of significant digits to be output in conversion of a real quantity.  .if
.cncr .else the integer consisting of this number of 9s must not be too large to
fit in the integer accum.  .fi


CFP_U                 

Realistic upper bound on alphabet.


CFP_X                 

Number of digits in real exponent 

section 2 - memory

Memory is organized into words which each contain CFP_B bytes. For word machines
CFP_B, which is a configuration parameter, may be one in which case words and
bytes are identical. To each word corresponds an address which is a non-negative
quantity which is a multiple of CFP_B. Data is organized into words as follows.

1)   

A signed integer value occupies CFP_I consecutive words (CFP_I is a
configuration parameter).  The range may include more negative numbers than
positive (e.g. The twos complement representation).

2)   

A signed real value occupies CFP_R consecutive words. (CFP_R is a configuration
parameter).

3)   

CFP_C characters may be stored in a single word (CFP_C is a configuration
parameter).

4)   

A bit string containing CFP_N bits can be stored in a single word (CFP_N is a
configuration parameter).

5)   

A word can contain a unsigned integer value in the range (0 le n le CFP_L).
These integer values may represent addresses of other words and some of the
instructions use this fact to provide indexing and indirection facilities.

6)   

Program instructions occupy words in an undefined manner. Depending on the
actual implementation, instructions may occupy several words, or part of a word,
or even be split over word boundaries.

The following regions of memory are available to the program. Each region
consists of a series of words with consecutive addresses.

1)   constant section           assembled constants
2)   working storage section    assembled work areas
3)   program section            assembled instructions
4)   stack area                 allocated stack area
5)   data area                  allocated data area


# section 3 - registers

There are three index registers called XR,XL,XS. In addition XL may sometimes be
referred to by the alias of XT - see section 4. Any of the above registers may
hold a positive unsigned integer in the range (0 le n le CFP_L). when the index
register is used for indexing purposes, this must be an appropriate address.  XS
is special in that it is used to point to the top item of a stack in memory. The
stack may build up or down in memory.since it is required that XS points to the
stack top but access to items below the top is permitted, registers XS and XT
may be used with suitable offsets to index stacked items. Only XS and XT may be
used for

This purpose since the direction of the offset is target machine dependent. XT
is a synonym for XL which therefore cannot be used in code sequences referencing
XT.

The stack is used for s-r linkage and temporary data storage for which the stack
arrangement is suitable.  XR,XL can also contain a character pointer in
conjunction with the character instructions (see description of plc).  

There are three work registers called WA,WB,WC which can contain any data item
which can be stored in a single memory word. In fact, the work registers are
just like memory locations except that they have no addresses and are referenced
in a special way by the instructions.

Note that registers WA,WB have special uses in connection with the cvd, cvm,
mvc, mvw, mWB, cmc, trc instructions.

Register WC may overlap the integer accumulator (IA) in some implementations.
Thus any operation changing the value in WC leaves (IA) undefined and vice versa
except as noted in the following restriction on simple dump/restore operations.

    restriction
    -----------

If IA and WC overlap then

```
    sti  iasav
    ldi  iasav
```

Does not change WC, and

```
    mov  WC,WCsav
    mov  WCsav,WC
```

does not change IA.



There is an integer accumulator (IA) which is capable of holding a signed
integer value (CFP_I words long). Register WC may overlap the integer
accumulator (IA) in some implementations. Thus any operation changing the value
in WC leaves (IA) undefined and vice versa except as noted in the above
restriction on simple dump/restore operations.

There is a single real accumulator (ra) which can hold any real value and is
completely separate from any of the other registers or program accessible
locations.

The code pointer register (CP) is a special index register for use in
implementations of interpretors.  It is used to contain a pseudo-code pointer
and can only be affected by iCP, lCP, sCP and lcw instructions. 

#  section 4 - the stack

The following notes are to guide both implementors of systems written in MINIMAL
and MINIMAL programmers in dealing with stack manipulation.  Implementation of a
downwards building stack is easiest and in general is to be preferred, in which
case it is merely necessary to consider XT as an alternative name for XL.

The MINIMAL virtual machine includes a stack and has operand formats -(XS) and
(XS)+ for pushing and popping items with an implication that the stack builds
down in memory (a d-stack). However on some target machines it is better for the
stack to build up (a u-stack). A stack addressed only by push and pop
operations can build in either direction with no complication but such a pure
scheme of stack access proves restrictive. Hence it is permitted to access
buried items using an integer offset past the index register pointing to the
stack top. On target machines this offset will be positive/negative for
d-stacks/u-stacks and this must be allowed for in the translation.  A further
restriction is that at no time may an item be placed above the stack top. For
some operations this makes it convenient to advance the stack pointer and then
address items below it using a second index register.  The problem of signed
offsets past such a register then arises. To distinguish stack offsets, which in
some implementations may be negative, from non-stack offsets which are
invariably positive, XT, an alias or synonym for XL is used. For a u-stack
implementation, the MINIMAL translator should negate the sign of offsets applied
To both (XS) and (XT). Programmers should note that since XT is not a separate
register, XL should not be used in code where XT is referenced. Other
modifications needed in u-stack translations are in the add, sub, ica, dca
opcodes applied to XS, XT. For example

```nasm
MINIMAL           d-stack trans.  u-stack trans.

mov  WA,-(XS)     sbi  XS,1       adi  XS,1
                  sto  WA,(XS)    sto  WA,(XS)
mov  (XT)+,WC     lod  WC,(XL)    lod  WC,(XL)
                  adi  XL,1       sbi  XL,1
add  =seven,XS    adi  XS,7       sbi  XS,7
mov  2(XT),WA     lod  WA,2(XL)   lod  WA,-2(XL)
ica  XS           adi  XS,1       sbi  XS,1
```
note that forms such as

```nasm
mov  -(XS),WA
add  WA,(XS)+
```

are illegal, since they assume information storage above the stack top.

# section 5 - internal character set

The internal character set is represented by a set of contiguous codes from 0 to
CFP_A-1. The codes for the digits 0-9 must be contiguous and in sequence. Other
Than this, there are no restraints.

The following symbols are automatically defined to have the value of the
corresponding internal character code.

```
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

```
ch_a                 shifted a
ch_b                 shifted b
.                     .
ch_$                 shifted z

ch_ht                 horizontal tab - define .caht
ch_vt                 vertical tab   - define .cavt
ch_ey                 up arrow       - define .caex
```


section 6 - conditional assembly features

Some features of the interpreter are applicable to only certain target machines.
They may be incorporated or omitted by use of conditional assembly. The full
form of a condition is -

```
.if    conditional assembly symbol    (cas)
.then
       MINIMAL statements1   (ms1)
.else
       MINIMAL statements2   (ms2)
.fi
```

The following rules apply

```
1.   The directives .if, .then, .else, .fi must
     start in column 1.
2.   The conditional assembly symbol must start with a
     dot in column 8 followed by 4 letters or digits e.g.
        .ca$1
3.   .then is redundant and may be omitted if wished.
4.   Ms1, ms2 are arbitrary sequences of MINIMAL
     statements either of which may be null or may
     contain further conditions.
5.   If ms2 is omitted, .else may also be omitted.
6.   .fi is required.
7.   Conditions may be nested to a depth determined
     by the translator (not less than 20, say).
```

Selection of the alternatives ms1, ms2 is by means of the
define and undefine directives of form -

```
.def   cas
.undef cas
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

#  section 7 - operand formats

The following section describes the various possibilities for operands of
instructions and assembly operations.

```
01   int              unsigned integer le CFP_L
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
19   *dlbl            location containing dac CFP_B*dlbl
20   =wlbl            location containing dac wlbl
21   =clbl            location containing dac clbl
22   =elbl            location containing dac elbl
23   pnam             procedure label (on prc instruc)
24   eqop             operand for equ instruction
25   ptyp             procedure type (see prc)
26   text             arbitrary text (erb,err,ttl)
27   dtext            delimited text string (dtc)
```

The numbers in the above list are used in subsequent description and in some of
The MINIMAL translators.


operand formats (continued)

The following special symbols refer to a collection of the listed possibilities

val  01,02                      predefined value

val is used to refer to a predefined one word integer value in the range 0
le n le CFP_L.

reg  07,08                      register

reg is used to describe an operand which can be any of the registers
(XL,XR,XS,XT,WA,WB,WC). Such an operand can hold a one word integer (address).

opc  09,10,11                   character

opc is used to designate a specific character operand for use in the lch and sch
instructions.  The index register referenced must be either XR or XL (not
XS,XT). See section on character operations.

ops  03,04,09,12,13,14,15       memory reference

ops is used to describe an operand which is in memory. The operand may be one or
more words long depending on the data type. In the case of multiword operands,
The address given is the first word.

opw  as for ops + 08,10,11      full word

opw is used to refer to an operand whose capacity is that of a full memory word.
opw includes all the possibilities for ops (the referenced word is used) plus
The use of one of the three work registers (WA,WB,WC). In addition, the formats
(x)+ and -(x) allow indexed operations in which the index register is popped by
one word after the reference (x)+, or pushed by one word before the reference
-(x) these latter two formats provide a facility for manipulation of stacks. The
format does not imply a particular direction in which stacks must build - it is
used for compactness. Note that there is a restriction which disallows an
instruction to use an index register in one of these formats in some other
manner in the same instruction.  E.g.  mov XL,(XL)+ is illegal.  The formats
-(x) and (x)+ may also be used in pre-decrementation, post-incrementation to
access the adjacent character of a string.


operand formats (continued)

opn  as for opw + 07            one word integer

opn is used to represent an operand location which can contain a one word
integer (e.g. an address).  This includes all the possibilities for opw plus the
use of one of the index registers (XL,XR,XT, XS). The range of integer values is
0 le n le CFP_L.

opv  as for opn + 18-22         one word integer value

opv is used for an operand which can yield a one word integer value (e.g. an
address). It includes all the possibilities for opn (the current value of the
location is used) plus the use of literals. Note that although the literal
formats are described in terms of a reference to a location containing an
address constant, this location may not actually exist in some implementations
since only the value is required. A restriction is placed on literals which may
consist only of defined symbols and certain labels. Consequently small integers
To be used as literals must be pre-defined, a discipline aiding program
maintenance and revision.

addr 01,02,03,04,05             address

addr is used to describe an explicit address value (one word integer value) for
use with dac.

```
     ****************************************************
     *   in the following descriptions the usage --     *
     *      (XL),(XR), ... ,(IA)                        *
     *   in the descriptive text signifies the          +
     *   contents of the stated register.               *
     ****************************************************
```

section 8 - list of instruction mnemonics

The following list includes all instruction and assembly operation mnemonics in
alphabetical order.  The mnemonics are preceded by a number identifying the
following section where the instruction is described.  An asterisk is appended
To the mnemonic if the last operand may optionally be omitted.  See section -15-
for details of statement format and comment conventions.

```
 2.1  add  opv,opn      add address
 4.2  adi  ops          add integer
 5.3  adr  ops          add real
 7.1  anb  opw,w        and bit string
 2.17 aov  opv,opn,plbl add address, fail if overflow
 5.16 atn               arctangent of real accum
 2.16 bct  w,plbl       branch and count
 2.5  beq  opn,opv,plbl branch if address equal
 2.18 bev  opn,plbl     branch if address even
 2.8  bge  opn,opv,plbl branch if address greater or equl
 2.7  bgt  opn,opv,plbl branch if address greater
 2.12 bhi  opn,opv,plbl branch if address high
 2.10 ble  opn,opv,plbl branch if address less or equal
 2.11 blo  opn,opv,plbl branch if address low
 2.9  blt  opn,opv,plbl branch if address less than
 2.6  bne  opn,opv,plbl branch if address not equal
 2.13 bnz  opn,plbl     branch if address non-zero
 2.19 bod  opn,plbl     branch if address odd
 1.2  brn  plbl         branch unconditional
 1.7  bri  opn          branch indirect
 1.3  bsw* x,val,plbl   branch on switch value
 8.2  btw  reg          convert bytes to words
 2.14 bze  opn,plbl     branch if address zero
 6.6  ceq  opw,opw,plbl branch if characters equal
10.1  chk               check stack overflow
 5.17 chp               integer portion of real accum
 7.4  cmb  w            complement bit string
 6.8  cmc  plbl,plbl    compare character strings
 6.7  cne  opw,opw,plbl branch if characters not equal
 6.5  csc  x            complete store characters
 5.18 cos               cosine of real accum
 8.8  ctb  w,val        convert character count to bytes
 8.7  ctw  w,val        convert character count to words
 8.10 cvd               convert by division
 8.9  cvm  plbl         convert by multiplication
11.1  dac  addr         define address constant
11.5  dbc  val          define bit string constant
 2.4  dca  opn          decrement address by one word
 1.17 dcv  opn          decrement value by one
11.2  dic  integer      define integer constant
11.3  drc  real         define real constant
11.4  dtc  dtext        define text (character) constant
 4.5  dvi  ops          divide integer
 5.6  dvr  ops          divide real
13.1  ejc               eject assembly listing
14.2  end               end of assembly
 1.13 enp               define end of procedure
 1.6  ent* val          define entry point
12.1  equ  eqop         define symbolic value
 1.15 erb  int,text     assemble error code and branch
 1.14 err  int,text     assemble error code
 1.5  esw               end of switch list for bsw
 5.19 etx               e to the power in the real accum
 1.12 exi* int          exit from procedure
12.2  exp               define eXTernal procedure
 6.10 flc  w            fold character to upper case
 2.3  ica  opn          increment address by one word
 3.4  iCP               increment code pointer
 1.16 icv  opn          increment value by one
 4.11 ieq  plbl         jump if integer zero
 1.4  iff  val,plbl     specify branch for bsw
 4.12 ige  plbl         jump if integer non-negative
 4.13 igt  plbl         jump if integer positive
 4.14 ile  plbl         jump if integer negative or zero
 4.15 ilt  plbl         jump if integer negative
 4.16 ine  plbl         jump if integer non-zero
 4.9  ino  plbl         jump if no integer overflow
12.3  inp  ptyp,int     internal procedure
12.4  inr               internal routine
 4.10 iov  plbl         jump if integer overflow
 8.5  itr               convert integer to real
 1.9  jsr  pnam         call procedure
 6.3  lch  reg,opc      load character
 2.15 lct  w,opv        load counter for loop
 3.1  lCP  reg          load code pointer register
 3.3  lcw  reg          load neXT code word
 4.1  ldi  ops          load integer
 5.1  ldr  ops          load real
 1.8  lei  x            load entry point id
 5.20 lnf               natural logorithm of real accum
 7.6  lsh  w,val        left shift bit string
 7.8  lsx  w,(x)        left shift indexed
 9.4  mcb               move characterswords backwards
 8.4  mfi* opn,plbl     convert (IA) to address value
 4.3  mli  ops          multiply integer
 5.5  mlr  ops          multiply real
 1.19 mnz  opn          move non-zero
 1.1  mov  opv,opn      move
 8.3  mti  opn          move address value to (IA)
 9.1  mvc               move characters
 9.2  mvw               move words
 9.3  mWB               move words backwards
 4.8  ngi               negate integer
 5.9  ngr               negate real
 7.9  nzb  w,plbl       jump if not all zero bits
 7.2  orb  opw,w        or bit strings
 6.1  plc* x,opv        prepare to load characters
 1.10 ppm* plbl         provide procedure exit parameter
 1.11 prc  ptyp,val     define start of procedure
 6.2  psc* x,opv        prepare to store characters
 5.10 req  plbl         jump if real zero
 5.11 rge  plbl         jump if real positive or zero
 5.12 rgt  plbl         jump if real positive
 5.13 rle  plbl         jump if real negative or zero
 5.14 rlt  plbl         jump if real negative
 4.6  rmi  ops          remainder integer
 5.15 rne  plbl         jump if real non-zero
 5.8  rno  plbl         jump if no real overflow
 5.7  rov  plbl         jump if real overflow
 7.5  rsh  w,val        right shift bit string
 7.7  rsx  w,(x)        right shift indexed
 8.6  rti* plbl         convert real to integer
 1.22 rtn               define start of routine
 4.4  sbi  ops          subtract integer
 5.4  sbr  ops          subtract reals
 6.4  sch  reg,opc      store character
 3.2  sCP  reg          store code pointer
14.1  sec               define start of assembly section
 5.21 sin               sine of real accum
 5.22 sqr               square root of real accum
 1.20 ssl  opw          subroutine stack load
 1.21 sss  opw          subroutine stack store
 4.7  sti  ops          store integer
 5.2  str  ops          store real
 2.2  sub  opv,opn      subtract address
 5.23 tan               tangent of real accum
 6.9  trc               translate character string
13.2  ttl  text         supply assembly title
 8.1  wtb  reg          convert words to bytes
 7.3  xob  opw,w        exclusive or bit strings
 1.18 zer  opn          zeroise integer location
 7.11 zgb  opn          zeroise garbage bits
 7.10 zrb  w,plbl       jump if all zero bits
```


# section 9 - MINIMAL instructions

The following descriptions assume the definitions -

```nasm
zeroe  equ  0
unity  equ  1
```

-1-  basic instruction set

1.1  mov  opv,opn     move one word value

     
mov causes the value of operand opv to be set as the new contents of operand
location opn. In the case where opn is not an index register, any value which
can normally occupy a memory word (including a part of a multiword real or
integer value) can be transferred using mov. If the target location opn is an
index register, then opv must specify an appropriate one word value or operand
containing such an appropriate value.

1.2  brn  plbl        unconditional branch

     
brn causes control to be passed to the indicated label in the program section.


1.3  bsw  x,val,plbl  branch on switch value

1.4  iff  val,plbl    provide branch for switch

     iff  val,plbl     ...
     ...

     ...

1.5  esw              end of branch switch table

     
bsw,iff,esw provide a capability for a switched branch similar to a fortran
computed goto. The val on the bsw instruction is the maximum number of branches.
The value in x ranges from zero up to but not including this maximum. Each iff
provides a branch. Val must be less than that given on the bsw and control goes
To plbl if the value in x matches.  If the value in x does not correspond to any
of the iff entries, then control passes to the plbl on the bsw. This plbl
operand may be omitted if there are no values missing from the list.

     
iff and esw may only be used in this context.  Execution of bsw may destroy the
contents of x.  The iff entries may be in any order and since a translator may
Thus need to store and sort them, the comment field is restricted in length (sec
11).  

-1-  basic instructions (continued)

1.6  ent  val         define program entry point

     
The symbol appearing in the label field is defined to be a program entry point
which can subsequently be used in conjunction with the bri instruction, which
provides the only means of entering the code. It is illegal to fall into code
identified by an entry point. The entry symbol is assigned an address which need
not be a multiple of CFP_B but which must be in the range 0 le CFP_L and the
address must not lie within the address range of the allocated data area.
furthermore, addresses of successive entry points must be assigned in some
ascending sequence so that the address comparison instructions can be used to
Test the order in which two entry points occur. The symbol val gives an
identifying value to the entry point which can be accessed with the lei
instruction.

     
Note - subject to the restriction below, val may be omitted if no such
identification is needed i.e.  If no lei references the entry point. For this
case, a translation optimisation is possible in which no memory need be reserved
for a null identification which is never to be referenced, but only provided
This is done so as not to interfere with the strictly ascending sequence of
entry point addresses. To simplify this optimisation for all implementors, the
following restriction is observed val may only be omitted if the entry point is
separated from a following entry point by a non-null MINIMAL code sequence.
entry point addresses are accessible only by use of literals (=elbl, section 7)
or dac constants (section 8-11.1).

1.7  bri  opn         branch indirect

     
opn contains the address of a program entry point (see ent). Control
is passed to the executable code starting at the entry point address.
opn is left unchanged.

1.8  lei  x           load entry point identification

     
x contains the address of an entry point for which an identifying value was
given on the the ent line.  LEI replaces the contents of x by this value.  

-1-  basic instructions (continued)

1.9  jsr  pnam        call procedure pnam
1.10 ppm  plbl        provide exit parameter
     ppm  plbl         ...
     ...
     ppm  plbl         ...

     
jsr causes control to be passed to the named procedure. Pnam is the label on a
prc statement elsewhere in the program section (see prc) or has been defined
using an exp instruction.  The ppm exit parameters following the call give names
of program locations (plbl-s) to which alternative exi returns of the called
procedure may pass control. They may optionally be replaced by error returns
(see err). The number of exit parameters following a jsr must equal the int in
The procedure definition. The operand of ppm may be omitted if the corresponding
exi return is certain not to be taken.

1.11 prc  ptyp,int    define start of procedure

	
     
The symbol appearing in the label field is defined to be the name of a procedure
for use with jsr.  A procedure is a contiguous section of instructions to which
control may be passed with a jsr instruction.  This is the only way in which the
instructions in a procedure may be executed. It is not permitted to fall into a
procedure.  All procedures should be named in section 0 inp statements.

     
int is the number of exit parameters (ppm-s) to be used in jsr calls.

     
There are three possibilities for ptyp, each consisting of a single letter as
follows.

     r                recursive

     
The return point (one or more words) is stored on the stack as though one or
more mov ...,-(XS) instructions were executed.  

-1-  basic instructions (continued)

     n                non-recursive

     the return point is to be stored either

1. In a local storage word associated with the procedure and not directly
available to the program in any other manner or

2. On a subroutine link stack quite distinct from the MINIMAL stack addressed by
XS.  It is an error to use the stack for n-links, since procedure parameters or
results may be passed via the stack.

if method (2) is used for links, error exits (erb,err) from a procedure will
necessitate link stack resetting. The ssl and sss orders provided for this may
be regarded as no-ops for implementations using method (1).

     e                either

     
The return point may be stored in either manner according to efficiency
requirements of the actual physical machine used for the implementation. Note
That programming of e type procedures must be independent of the actual
implementation.

The actual form of the return point is undefined.  However, each word stored on
The stack for an r-type call must meet the following requirements.

1 it can be handled as an address and placed in an index register.

2 when used as an operand in an address comparison instruction, it must not
appear to lie within the allocated data area.

3 it is not required to appear to lie within the program section.



1.12 exi  int         exit from procedure

     
The ppm and err parameters following a jsr are numbered starting from 1.  Exi
int causes control to be returned to the int-th such param.  Exi 1 gives control
To the plbl of the first ppm after the jsr.  If int is omitted, control is
passed back past the last exit parameter (or past the jsr if there are none).
for r and e type procedures, the stack pointer XS must be set to its appropriate
entry value before executing an exi instruction.  In this case, exi removes
return points from the stack if any are stored there so that the stack pointer
is restored to its calling value.

1.13 enp              define end of procedure body

     
enp delimits a procedure body and may not actually be executed, hence it must
have no label.

1.14 err  int,text    provide error return

     
err may replace an exit parameter (ppm) in any procedure call. The int argument
is a unique error code in 0 to 899.  The text supplied as the other operand is
arbitrary text in the fortran character set and may be used in constructing a
file of error messages for documenting purposes or for building a direct access
or other file of messages to be used by the error handling code.  In the event
That an exi attempts to return control via an exit parameter to an err, control
is instead passed to the first instruction in the error section (which follows
The program section) with the error code in WA.

1.15 erb  int,text    error branch

     
This instruction resembles err except that it may occur at any point where a
branch is permitted.  It effects a transfer of control to the error section with
The error code in WA.

1.16 icv  opn         increment value by one

     
icv increments the value of the operand by unity.  It is equivalent to add
=unity,opn

1.17 dcv  opn         decrement value by one

     
dcv decrements the value of the operand by unity.  It is equivalent to sub
=unity,opn 

basic instructions (continued)

1.18 zer  opn         zeroise opn

     
zer is equivalent to mov =zeroe,opn

1.19 mnz  opn         move non-zero to opn

     
any non-zero collectable value may used, for which the opcodes bnz/bze will
branch/fail to branch.

1.20 ssl  opw         subroutine stack load

1.21 sss  opw         subroutine stack store

     
This pair of operations is provided to make possible the use of a local stack to
hold subroutine (s-r) return links for n-type procedures. sss stores the s-r
stack pointer in opw and ssl loads the s-r stack pointer from opw. by using sss
in the main program or on entry to a procedure which should regain control on
occurrence of an err or erb and by use of ssl in the error processing sections
The s-r stack pointer can be restored giving a link stack cleaned up ready for
resumed execution.  The form of the link stack pointer is undefined in MINIMAL
(it is likely to be a private register known to the translator) and the only
requirement is that it should fit into a single full word.  SSL and SSS are
no-ops if a private link stack is not used.

1.22 rtn              define start of routine

     
A routine is a code chunk used for similar purposes to a procedure.  However it
is entered by any type of conditional or unconditional branch (not by jsr). on
Termination it passes control by a branch (often bri through a code word) or
even permits control to drop through to another routine. no return link exists
and the end of a routine is not marked by an explicit opcode (compare enp).  All
routines should be named in section 0 inr statements.  

-2-  operations on one word integer values (addresses)

2.1  add  opv,opn     

adds opv to the value in opn and stores the result in opn. undefined if the
result exceeds CFP_L.

2.2  sub  opv,opn     

subtracts opv from opn. stores the result in opn. undefined if the result is
negative.

2.3  ica  opn         

increment address in opn equivalent to add *unity,opn

2.4  dca  opn         decrement address in opn
                      equivalent to sub *unity,opn

2.5  beq  opn,opv,plbl branch to plbl if opn eq opv
2.6  bne  opn,opv,plbl branch to plbl if opn ne opv
2.7  bgt  opn,opv,plbl branch to plbl if opn gt opv
2.8  bge  opn,opv,plbl branch to plbl if opn ge opv
2.9  blt  opn,opv,plbl branch to plbl if opn lt opv
2.10 ble  opn,opv,plbl branch to plbl if opn le opv
2.11 blo  opn,opv,plbl equivalent to blt or ble
2.12 bhi  opn,opv,plbl equivalent to bgt or bge


The above instructions compare two address values as unsigned integer
values.  The blo and bhi instructions are used in cases where the
equal condition either does not occur or can result either in a branch
or no branch. This avoids inefficient translations in some
implementations.

2.13 bnz  opn,plbl    

equivalent to bne opn,=zeroe,plbl

2.14 bze  opn,plbl    

equivalent to beq opn,=zeroe,plbl



2.15 lct  w,opv       load counter for bct

     
lct loads a counter value for use with the bct instruction. The value in opv is
The number of loops to be executed. The value in w after this operation is an
undefined one word integer quantity.

2.16 bct  w,plbl      branch and count

     
bct uses the counter value in w to branch the required number of times and then
finally to fall through to the neXT instruction. bct can only be used following
an appropriate lct instruction.  The value in w after execution of bct is
undefined.

2.17 aov  opv,opn,plbl add with carry test

     
adds opv to the value in opn and stores result in opn. branches to plbl if
result exceeds CFP_L with result in opn undefined. cf. add.

2.18 bev  opn,plbl     branch if even
2.19 bod  opn,plbl     branch if odd

     
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
pointer register is always a word address (i.e.  A one word integer which is a
multiple of CFP_B).

3.1  lCP  reg         

load code pointer register this instruction causes the code pointer register to
be set from the value in reg which is unchanged

3.2  sCP  reg         

store code pointer register this instruction loads the current value in the code
pointer register into reg. (CP) is unchanged.

3.3  lcw  reg         

load neXT code word this instruction causes the word pointed to by CP to be
loaded into the indicated reg. The value in CP is then incremented by one word.
execution of lcw may destroy XL.

3.4  iCP              increment CP by one word

     
on machines with more than three index registers, CP can be treated simply as an
index register.  In this case, the following equivalences apply.

```
     lCP reg is like mov reg,CP
     sCP reg is like mov CP,reg
     lcw reg is like mov (CP)+,reg
     iCP     is like ica CP
```
     
since lcw is allowed to destroy XL, the following implementation using a work
location CP$$$ can also be used.

```
     lCP  reg         mov  reg,CP$$$

     sCP  reg         mov  CP$$$,reg

     lcw  reg         mov  CP$$$,XL
                      mov  (XL)+,reg
                      mov  XL,CP$$$

     iCP              ica  CP$$$
```

-4-  operations on signed integer values

4.1  ldi  ops         load integer accumulator from ops
4.2  adi  ops         add ops to integer accumulator
4.3  mli  ops         multiply integer accumulator by ops
4.4  sbi  ops         subtract ops from int accumulator
4.5  dvi  ops         divide integer accumulator by ops
4.6  rmi  ops         set int accum to mod(intacc,ops)
4.7  sti  ops         store integer accumulator at ops
4.8  ngi              negate the value in the integer
                      accumulator (change its sign)

     
The equation satisfied by operands and results of dvi and rmi is

```
            div = qot * ops + rem          where

     div = dividend in integer accumulator
     qot = quotient left in IA by div
     ops = the divisor
     rem = remainder left in IA by rmi
```
     
The sign of the result of dvi is + if (IA) and (ops) have the same sign and is -
if they have opposite signs. The sign of (IA) is always used as the sign of the
result of rem.  Assuming in each case that IA contains the number specified in
parentheses and that seven and msevn hold +7 and -7 resp. The algorithm is
illustrated below.

```
     (IA = 13)
     dvi  seven       IA = 1
     rmi  seven       IA = 6
     dvi  msevn       IA = -1
     rmi  msevn       IA = 6
     (IA = -13)
     dvi  seven       IA = -1
     rmi  seven       IA = -6
     dvi  msevn       IA = 1
     rmi  msevn       IA = -6
```

The above instructions operate on a full range of signed integer values. with
The exception of ldi and sti, these instructions may cause integer overflow by
attempting to produce an undefined or out of range result in which case integer
overflow is set, the result in (IA) is undefined and the following instruction
must be iov or ino.  Particular care may be needed on target machines having
distinct overflow and divide by zero conditions.

4.9  ino  plbl        jump to plbl if no integer overflow
4.10 iov  plbl        jump to plbl if integer overflow

     
These instructions can only occur immediately following an instruction which can
cause integer overflow (adi, sbi, mli, dvi, rmi, ngi) and test the result of the
preceding instruction.  IOV and INO may not have labels.

4.11 ieq  plbl        jump to plbl if (IA) eq 0
4.12 ige  plbl        jump to plbl if (IA) ge 0
4.13 igt  plbl        jump to plbl if (IA) gt 0
4.14 ile  plbl        jump to plbl if (IA) le 0
4.15 ilt  plbl        jump to plbl if (IA) lt 0
4.16 ine  plbl        jump to plbl if (IA) ne 0

     
The above conditional jump instructions do not change the contents of the
accumulator.  On a ones complement machine, it is permissible to produce
negative zero in IA provided these instructions operate correctly with such a
value.  

-5-  operations on real values

5.1  ldr  ops         load real accumulator from ops
5.2  str  ops         store real accumulator at ops
5.3  adr  ops         add ops to real accumulator
5.4  sbr  ops         subtract ops from real accumulator
5.5  mlr  ops         multiply real accumulator by ops
5.6  dvr  ops         divide real accumulator by ops

     
if the result of any of the above operations causes underflow, the result
yielded is 0.0.

     
if the result of any of the above operations is undefined or out of range, real
overflow is set, the contents of (ra) are undefined and the following
instruction must be either rov or rno.  Particular care may be needed on target
machines having distinct overflow and divide by zero conditions.

5.7  rov  plbl        jump to plbl if real overflow
5.8  rno  plbl        jump to plbl if no real overflow

     
These instructions can only occur immediately following an instruction which can
cause real overflow (adr,sbr,mlr,dvr).

5.9  ngr              negate real accum (change sign)

5.10 req  plbl        jump to plbl if (ra) eq 0.0
5.11 rge  plbl        jump to plbl if (ra) ge 0.0
5.12 rgt  plbl        jump to plbl if (ra) gt 0.0
5.13 rle  plbl        jump to plbl if (ra) le 0.0
5.14 rlt  plbl        jump to plbl if (ra) lt 0.0
5.15 rne  plbl        jump to plbl if (ra) ne 0.0

     
The above conditional instructions do not affect the value stored in the real
accumulator.  On a ones complement machine, it is permissible to produce
negative zero in ra provided these instructions operate correctly with such a
value.  .if .cmth

5.16 atn              arctangent of real accum
5.17 chp              integer portion of real accum
5.18 cos              cosine of real accum
5.19 etx              e to the power in the real accum
5.20 lnf              natural logorithm of real accum
5.21 sin              sine of real accum
5.22 sqr              square root of real accum
5.23 tan              tangent of real accum

     
The above orders operate upon the real accumulator, and replace the contents of
The accumulator with the result.

     
if the result of any of the above operations is undefined or out of range, real
overflow is set, the contents of (ra) are undefined and the following
instruction must be either rov or rno.  .fi 

-6-  operations on character values

     
character operations employ the concept of a character pointer which uses either
index register XR or XL (not XS).

     
A character pointer points to a specific character in a string of characters
stored CFP_C chars to a word. The only operations permitted on a character
pointer are lch and sch. In particular, a character pointer may not even be
moved with mov.

        restriction 1.
        --------------
     
it is important when coding in MINIMAL to ensure that no action occurring
between the initial use of plc or psc and the eventual clearing of XL or XR on
completion of character operations can initiate a garbage collection. The latter
of course could cause the addressed characters to be moved leaving the character
pointers pointing to rubbish.

        restriction 2.
        --------------
     
A further restriction to be observed in code handling character strings, is that
strings built dynamically should be right padded with zero characters to a full
word boundary to permit easy hashing and use of ceq or cne in testing strings
for equality.

6.1  plc  x,opv       prepare ch ptr for lch,cmc,mvc,trc,
                      mcb.

6.2  psc  x,opv       prepare char. ptr for sch,mvc,mcb.

     
opv can be omitted if it is zero.  The char. Initially addressed is determined
by the word address in x and the integer offset opv.  There is an automatic
implied offset of CFP_F bytes.  CFP_F is used to formally introduce into MINIMAL
A value needed in translating these opcodes which, since MINIMAL itself does not
prescribe a string structure in detail, depends on the choice of a data
structure for strings in the MINIMAL program.  

e.g. If CFP_B = CFP_C = 3, CFP_F = 6, num01 = 1, XL points to a series of 4
words, abc/def/ghi/jkl, then plc XL,=num01 points to h.  

-6- operations on character values (continued)

6.3  lch  reg,opc     load character into reg

6.4  sch  reg,opc     store character from reg

     
These operations are defined such that the character is right justified in
register reg with zero bits to the left. after lch for example, it is legitimate
To regard reg as containing the ordinal integer corresponding to the character.

     opc is one of the following three possibilities.

     (x)              

The character pointed to by the character pointer in x. The character
pointer is not changed.

     (x)+             

same character as (x) but the character pointer is incremented to point to the
neXT character following execution.

     -(x)             

The character pointer is decremented before accessing the character so that the
previous character is referenced.

6.5  csc  x           complete store characters

      
This instruction marks completion of a psc,sch,sch,...,sch sequence initiated by
A psc x instruction. no more sch instructions using x should be obeyed until
another psc is obeyed. It is provided solely as an efficiency aid on machines
without character orders since it permits use of register buffering of chars in
sch sequences. where csc is not a no-op, it must observe restriction 2. (e.g. In
SPITBOL, alocs zeroises the last word of a string frame prior to sch sequence
being started so csc must not nullify this action.)

     
The following instructions are used to compare two words containing CFP_C
characters.  Comparisons distinct from beq,bne are provided as on some target
machines, the possibility of the sign bit being set may require special action.
note that restriction 2 above, eases use of these orders in testing complete
strings for equality, since whole word tests are possible.

6.6  ceq  opw,opw,plbl jump to plbl if opw eq opw
6.7  cne  opw,opw,plbl jump to plbl if opw ne opw


-6- operations on character values (continued)

6.8  cmc  plbl,plbl   compare characters

     
cmc is used to compare two character strings. before executing cmc, registers
are set up as follows.

```
     (XL)             character ptr for first string
     (XR)             character pointer for second string

```
     
XL and XR should have been prepared by plc.  Control passes to first plbl if the
first string is lexically less than the second string, and to the second plbl if
The first string is lexically greater. control passes to the following
instruction if the strings are identical.  After executing this instruction, the
values of XR and XL are set to zero and the value in (WA) is undefined.
arguments to cmc may be complete or partial strings, so making optimisation to
use whole word comparisons difficult (dependent in general on shifts and
masking).

6.9  trc              translate characters

     
Trc is used to translate a character string using a supplied translation table.
before executing trc the registers are set as follows.

     (XL)             char ptr to string to be translated
     (XR)             char ptr to translate table

     (WA)             length of string to be translated

     
XL and XR should have been prepared by plc.  The translate table consists of
CFP_A contiguous characters giving the translations of the CFP_A characters in
The alphabet. on completion, (XR) and (XL) are set to zero and (WA) is
undefined.

6.10 flc  w           fold character to upper case

     
flc is used only if .culc is defined. The character code value in w is
Translated to upper case if it corresponds to a lower case character.


-7-  operations on bit string values

7.1  anb  opw,w       and bit string values
7.2  orb  opw,w       or bit string values
7.3  xob  opw,w       exclusive or bit string values

     
in the above operations, the logical connective is applied separately to each of
The CFP_N bits.  The result is stored in the second operand location.

7.4  cmb  w           complement all bits in opw

7.5  rsh  w,val       right shift by val bits
7.6  lsh  w,val       left shift by val bits
7.7  rsx  w,(x)       right shift w number of bits in x
7.8  lsx  w,(x)       left shift w number of bits in x

     
The above shifts are logical shifts in which bits shifted out are lost and zero
bits supplied as required. The shift count is in the range 0-CFP_N.

7.9  nzb  w,plbl      jump to plbl if w is not
                      all zero bits.

7.10 zrb  w,plbl      jump to plbl if w is all zero bits

7.11 zgb  opn         zeroise garbage bits

     
opn contains a bit string representing a word of characters from a string or
some function formed from such characters (e.g. as a result of hashing). on a
machine where the word size is not a multiple of the character size, some bits
in reg may be undefined. This opcode replaces such bits by the zero bit. zgb is
A no-op if the word size is a multiple of the character size.  

-8-  conversion instructions

     the following instructions provide for conversion between lengths in bytes
and lengths in words.

8.1  wtb  reg         

convert reg from words to bytes.  That is, multiply by CFP_B. This is a no-op if
CFP_B is one.

8.2  btw  reg         

convert reg from bytes to words by dividing reg by CFP_B discarding the
fraction. no-op if CFP_B is one

     
The following instructions provide for conversion of one word integer values
(addresses) to and from the full signed integer format.

8.3  mti  opn         

The value of opn (an address) is moved as a positive integer to the integer
accumulator.

8.4  mfi  opn,plbl    

The value currently stored in the integer accumulator is moved to opn as an
address if it is in the range 0 to CFP_M inclusive.  If the accumulator value is
outside this range, then the result in opn is undefined and control is passed to
plbl. mfi destroys the value of (IA) whether or not integer overflow is
signalled.  PLBL may be omitted if overflow is impossible.

     
The following instructions provide for conversion between real values and
integer values.

8.5  itr              

convert integer value in integer accumulator to real and store in real
accumulator (may lose precision in some cases)

8.6  rti  plbl        

convert the real value in ra to an integer and place result in IA.  conversion
is by truncation of the fraction - no rounding occurs.  jump to plbl if out of
range. (ra) is not changed in either case.  PLBL may be omitted if overflow is
impossible.  

-8-  conversion instructions (continued)

     
The following instructions provide for computing the length of storage required
for a text string.

8.7  ctw  w,val       

This instruction computes the sum (number of words required to store w
characters) + (val). The sum is stored in w.  For example, if CFP_C is 5, and WA
contains 32, then ctw WA,2 gives a result of 9 in WA.

8.8  ctb  w,val       

ctb is exactly like ctw except that the result is in bytes. It has the same
effect as ctw w,val wtb w

     
The following instructions provide for conversion from integers to and from
numeric digit characters for use in numeric conversion routines.  They employ
negative integer values to allow for proper conversion of numbers which cannot
be complemented.

8.9  cvm  plbl        convert by multiplication

     
The integer accumulator, which is zero or negative, is multiplied by 10. WB
contains the character code for a digit. The value of this digit is then
subtracted from the result. If the result is out of range, then control is
passed to plbl with the result in (IA) undefined. execution of cvm leaves the
result in (WB) undefined.

8.10 cvd              convert by division

     
The integer accumulator, which is zero or negative, is divided by 10.  The
quotient (zero or negative) is replaced in the accumulator. The remainder is
converted to the character code of a digit and placed in WA. for example, an
operand of -523 gives a quotient of -52 and a remainder in WA of ch_d3.  

-9-  block move instructions

The following instructions are used for transferring data from one area of
memory to another in blocks.  They can be implemented with the indicated series
of other macro-instructions, but more efficient imple- mentations will be
possible on most machines.

note that in the equivalent code sequence shown below, a zero value in WA will
move at least one item, and may may wrap the counter causing a core dump in some
imple- mentations.  Thus WA should be .gt. 0 prior to invoking any of these
block move instructions.

9.1  mvc              move characters

     
before obeying this order WA,XL,XR should have been set up, the latter two by
plc, psc resp.

     
mvc is equivalent to the sequence

```nasm
            mov  WB,dumpb
            lct  WA,WA
     loopc  lch  WB,(XL)+
            sch  WB,(XR)+
            bct  WA,loopc
            csc  XR
            mov  dumpb,WB
```
     
The character pointers are bumped as indicated and the final value of WA is
undefined.


9.2  mvw              move words

     
mvw is equivalent to the sequence

```nasm
     loopw  mov  (XL)+,(XR)+
            dca  WA               WA = bytes to move
            bnz  WA,loopw
```
     
note that this implies that the value in WA is the length in bytes which is a
multiple of CFP_B.  The initial addresses in XR,XL are word addresses.  As
indicated, the final XR,XL values point past the new and old regions of memory
respectively.  The final value of WA is undefined.  WA,XL,XR must be set up
before obeying mvw.

9.3  mWB              move words backwards

     
mWB is equivalent to the sequence

```nasm
     loopb  mov  -(XL),-(XR)
            dca  WA               WA = bytes to move
            bnz  WA,loopb
```
     
There is a requirement that the initial value in XL be at least 256 less than
The value in XR. This allows an implementation in which chunks of 256 bytes are
moved forward (ibm 360, icl 1900).  The final value of WA is undefined.
WA,XL,XR must be set up before obeying mWB.

9.4  mcb              move characters backwards

     
mcb is equivalent to the sequence

```nasm
            mov  WB,dumpb
            lct  WA,WA
     loopc  lch  WB,-(XL)
            sch  WB,-(XR)
            bct  WA,loopc
            csc  XR
            mov  dumpb,WB
```
     
There is a requirement that the initial value in XL be at least 256 less than
The value in XR. This allows an implementation in which chunks of 256 bytes are
moved forward (ibm 360, icl 1900).  The final value of WA is undefined.
WA,XL,XR must be set up before obeying mcb.


-10- operations connected with the stack

The stack is an area in memory which is dedicated for use in conjunction with
The stack pointer register (XS). as previously described, it is used by the jsr
and exi instructions and may be used for storage of any other data as required.

The stack builds either way in memory and an important restriction is that the
value in (XS) must be the address of the stack front at all times since some
implementations may randomly destroy stack locations beyond (XS).

The starting stack base address is passed in (XS) at the start of execution.
during execution it is necessary to make sure that the stack does not overflow.
This is achieved by executing the following instruction periodically.

10.1 chk              check stack overflow

after successfully executing chk, it is permissible to use up to 100 additional
words before issuing another chk thus chk need not be issued every time the
stack is expanded. In some implementations, the checking may be automatic and
chk will have no effect. following the above rule makes sure that the program
will operate correctly in implementations with no automatic check.

if stack overflow occurs (detected either automatically or by a chk
instruction), then control is passed to the stack overflow section (see program
form). note that this transfer may take place following any instruction which
stores data at a new location on the stack.  After stack overflow, stack is
arbitrarily popped to give some space in which the error procedure may operate.
otherwise a loop of stack overflows may occur.


-11- data generation instructions

The following instructions are used to generate constant values in the constant
section and also to assemble initial values in the working storage section. They
may not appear except in these two sections.

11.1 dac  addr        

assemble address constant.  Generates one word containing the specified one word
integer value (address).

11.2 dic  integer     

generates an integer value which occupies CFP_I consecutive words.  The operand
is a digit string with a required leading sign.

11.3 drc  real        

assembles a real constant which occupies CFP_R consecutive words.  The operand
form must obey the rules for a fortran real constant with the eXTra requirement
That a leading sign be present.

11.4 dtc  dtext       

Define text constant. dtext is started and ended with any character not
contained in the characters to be assembled. The constant occupies consecutive
words as dictated by the configuration parameter CFP_C.  Any unused chars in the
last word are right filled with zeros (i.e.  The character whose internal code
is zero).  The string contains a sequence of letters, digits, blanks and any of
The following special characters.  = , $ . ( * ) / + -  no other characters may be used in
a dtext operand.

11.5 dbc  val         

assemble bit string constant. The operand is a positive integer value which is
interpreted in binary, right justified and left filled with zero bits. Thus 5
would imply the bit string value 00...101.  

-12- symbol definition instructions

The following instruction is used to define symbols in the definitions section.
it may not be used elsewhere.

12.1 equ  eqop        define symbol

     
The symbol which appears in the label field is defined to have the absolute
value given by the eqop operand. a given symbol may be defined only once in this
manner, and any symbols occuring in eqop must be previously defined.

     the following are the possibilities for eqop

     val              

The indicated value is used

     val+val          

The sum of the two values is used.  This sum must not exceed CFP_M

     val-val          

The difference between the two values (must be positive) is used.

     *                

This format defines the label by using a value supplied by the MINIMAL
Translator. values are required for the CFP_X (configuration parameters) e$xxx
(environment parameters) ch_xx (character codes).  In order for a translator to
handle this format correctly the definitions section must be consulted for
details of required symbols as listed at the front of the section.  

symbol definition instructions (continued)

The following instructions may be used to define symbols in the procedure
section. They may not be used in any other part of the program.

12.2 exp              define eXTernal procedure

     
exp defines the symbol appearing in the label field to be the name of an
eXTernal procedure which can be referenced in a subsequent jsr instruction. The
coding for the procedure is eXTernal to the coding of the source program in this
language.  The code for eXTernal procedures may be referred to collectively as
The operating system interface, or more briefly, osint, and will frequently be a
separately compiled segment of code loaded with SPITBOL to produce a complete
system.

12.3 inp  ptyp,int    define internal procedure

     
inp defines the symbol appearing in the label field to be the name of an
internal procedure and gives its type and number of exit parameters. The label
can be referenced in jsr instructions and it must appear labelling a prc
instruction in the program section.

12.4 inr              define internal routine

     
inr defines the symbol appearing in the label field to be the name of an
internal routine. The label may be referenced in any type of branch order and it
must appear labelling a rtn instruction in the program section.  

-13- assembly listing layout instructions

13.1 ejc              eject to neXT page

13.2 ttl  text        set new assembly title

     
Ttl implies an immediate eject of the assembly listing to print the new title.

     
The use of ttl and ejc cards is such that the program will list neatly if the
printer prints as many as 58 lines per page. In the event that the printer depth
is less than this, or if the listing contains interspersed lines (such as actual
generated code), then the format may be upset.

     
lines starting with an asterisk are comment lines which cause no code to be
generated and may occur freely anywhere in the program. The format for comment
lines is given in section -15-.  

-14- program form

     
The program consists of separate sections separated by sec operations.  The
sections must appear in the following specified order.

14.1 sec              start of procedure section

     (procedure section)

     sec               start of definitions section

     (definitions section)

     sec               start of constant storage section

     (constant storage section)

     sec               start of working storage section

     (working storage section)

     sec               start of program section

     (program section)

     sec               start of stack overflow section

     (stack overflow section)

     sec               start of error section

     (error section)

14.2 end              end of assembly


section 10 - program form

procedure section

     
The procedure section contains all the exp instructions for eXTernally available
procedures and inp,inr opcodes for internal procedures,routines so that a single
pass MINIMAL translator has advance knowledge of procedure types when
Translating calls.

definitions section

     
The definitions section contains equ instructions which define symbols
referenced later on in the program, constant and work sections.

constant storage section

     
The constant storage section consists entirely of constants assembled with the
dac,dic,drc,dtc,dbc assembly operations. These constants can be freely
referenced by the program instructions.

working storage section

     
The working storage section consists entirely of dac,dic,drc,dbc,dtc
instructions to define a fixed length work area. The work locations in this area
can be directly referenced in program instructions.  The area is initialized in
accordance with the values assembled in the instructions.

program section

     
The program section contains program instructions and associated operations
(such as prc, enp, ent).  Control is passed to the first instruction in this
section when execution is initiated.

stack overflow section

     
The stack overflow section contains instructions like the program section.
control is passed to the first instruction in this section following the
occurrence of stack overflow, see chk instruction.

error section

     
The error section contains instructions like the program section. Control is
passed to the first instruction in this section when a procedure exit
corresponds to an error parameter (see err) or when an erb opcode is obeyed. The
error code must clean up the main stack and cater for the possibility that a
subroutine stack may need clean up.


# osint

     
Though not part of the MINIMAL source, it is useful to refer to the collection
of initialisation and exp routines as osint (operating system interface).
errors occurring within osint procedures are usually handled by making an error
return. If this is not feasible or appropriate, osint may use the MINIMAL error
section to report errors directly by branching to it with a suitable numeric
error code in WA.


section 11 - statement format

all labels are exactly five characters long and start with three letters
(abcdefghijklmnopqrstuvwxy$) followed by two letters or digits.  The letter z
may not be used in MINIMAL symbols but $ is permitted.  For implementations
where $ may not appear in the target code , a simple substitution of z for $ may
Thus be made without risk of producing non-unique symbols.  The letter z is
however permitted in opcode mnemonics and in comments.

MINIMAL statements are in a fixed format as follows.


```
cols 1-5              label if any (else blank)

cols 6-7              always blank

cols 8-10             operation mnemonic

cols 11-12            blanks

cols 13-28            operand field, terminated by a
                      blank. may occasionally
                      eXTend past column 28.

cols 30-64            comment. always separated from the
                      operand field by at least one blank
                      may occasionally start after column
                      30 if the operand eXTends past 28.
                      a special exception occurs for the
                      iff instruction, whose comment may
                      be only 20 characters long (30-49).

cols 65 on            unused


comment lines have the following format

col 1                 asterisk

cols 2-7              blank

cols 8-64             arbitrary text
```

#section 12 - program execution

execution of the program begins with the first instruction in the program
section.

in addition to the fixed length memory regions defined by the assembly, there
are two dynamically allocated memory regions as follows.

data area             

This is an area available to the program for general storage of data any data
value may be stored in this area except instructions.  In some implementations,
it may be possible to increase the size of this area dynamically by adding words
at the top end with a call to a system procedure.

stack area            

This region of memory holds the stack used for subroutine calls and other
storage of one word integer values (addresses). This is the stack associated
with index register XS.

The locations and sizes of these areas are specified by the values in the
registers at the start of program execution as follows.

```
(XS)                  address one past the stack base.
                      e.g. If XS is 23456, a d-stack will
                      occupy words 23455,23454,...
                      whereas a u-stack will occupy
                      23457,23458,...

(XR)                  address of the first word
                      in the data area

(XL)                  address of the last word in the
                      data area.

(WA)                  initial stack pointer

(WB,WC,IA,RA,CP)      zero
```

There is no explicit way to terminate the execution of a program. This function
is performed by an appropriate system procedure referenced with the sysej
instruction.
