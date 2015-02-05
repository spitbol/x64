ttl  minimal -- machine independent macro assembly lang.
ejc

the following sections describe the implementation language originally
developed for spitbol but now more widely used. minimal is an assembly
language for an idealized machine. the following describes the basic
characteristics of this machine.

section 1 - configuration parameters

there are several parameters which may vary with the target machine.
the macro-program is independent of the actual definitions of these
parameters.

the definitions of these parameters are supplied by
the translation program to match the target machine.

cfp$a                 

number of distinct characters in internal alphabet in the range 64 le
cfp$a le mxlen.

cfp$b

number of bytes in a word where a byte is the amount
of storage addressed by the least significant address bit.

cfp$c                 

number of characters which can be stored in a single word.

cfp$f                 

byte offset from start of a string block to the first character.
depends both on target machine and string data structure. see plc, psc

cfp$i                 

number of words in a signed integer constant

cfp$l                 

the largest unsigned integer of form 2**n - 1 which can be stored in a
single word.  n will often be cfp$n but need not be.

cfp$m                 

the largest positive signed integer of form 2**n - 1 which can be
stored in a single word.  n will often be cfp$n-1 but need not be.

cfp$n                 

number of bits which can be stored in a one word bit string.

cfp$r                 

number of words in a real constant

cfp$s                 

number of significant digits to be output in conversion of a real
quantity.  .if .cncr .else the integer consisting of this number of 9s
must not be too large to fit in the integer accum.  .fi


cfp$u                 

realistic upper bound on alphabet.


cfp$x                 

number of digits in real exponent ejc

section 2 - memory

memory is organized into words which each contain cfp$b bytes. for
word machines cfp$b, which is a configuration parameter, may be one in
which case words and bytes are identical. to each word corresponds an
address which is a non-negative quantity which is a multiple of cfp$b.
data is organized into words as follows.

1)   

a signed integer value occupies cfp$i consecutive words (cfp$i is a
configuration parameter).  the range may include more negative numbers
than positive (e.g. the twos complement representation).

2)   

a signed real value occupies cfp$r consecutive words. (cfp$r is a
configuration parameter).

3)   

cfp$c characters may be stored in a single word (cfp$c is a
configuration parameter).

4)   

a bit string containing cfp$n bits can be stored in a single word
(cfp$n is a configuration parameter).

5)   

a word can contain a unsigned integer value in the range (0 le n le
cfp$l). these integer values may represent addresses of other words
and some of the instructions use this fact to provide indexing and
indirection facilities.

6)   

program instructions occupy words in an undefined manner. depending on
the actual implementation, instructions may occupy several words, or
part of a word, or even be split over word boundaries.

the following regions of memory are available to the program. each
region consists of a series of words with consecutive addresses.

1)   constant section           assembled constants
2)   working storage section    assembled work areas
3)   program section            assembled instructions
4)   stack area                 allocated stack area
5)   data area                  allocated data area
ejc

section 3 - registers

there are three index registers called xr,xl,xs. in addition xl may
sometimes be referred to by the alias of xt - see section 4. any of
the above registers may hold a positive unsigned integer in the range
(0 le n le cfp$l). when the index register is used for indexing
purposes, this must be an appropriate address.  xs is special in that
it is used to point to the top item of a stack in memory. the stack
may build up or down in memory.since it is required that xs points to
the stack top but access to items below the top is permitted,
registers xs and xt may be used with suitable offsets to index stacked
items. only xs and xt may be used for

this purpose since the direction of the offset is target machine
dependent. xt is a synonym for xl which therefore cannot be used in
code sequences referencing xt.

the stack is used for s-r linkage and temporary data storage for which
the stack arrangement is suitable.  xr,xl can also contain a character
pointer in conjunction with the character instructions (see
description of plc).  ejc

there are three work registers called wa,wb,wc which can contain any
data item which can be stored in a single memory word. in fact, the
work registers are just like memory locations except that they have no
addresses and are referenced in a special way by the instructions.

note that registers wa,wb have special uses in connection with the
cvd, cvm, mvc, mvw, mwb, cmc, trc instructions.

register wc may overlap the integer accumulator (ia) in some
implementations. thus any operation changing the value in wc leaves
(ia) undefined and vice versa except as noted in the following
restriction on simple dump/restore operations.

    restriction
    -----------

if ia and wc overlap then
    sti  iasav
    ldi  iasav
does not change wc, and
    mov  wc,wcsav
    mov  wcsav,wc
does not change ia.



there is an integer accumulator (ia) which is capable of holding a
signed integer value (cfp$i words long).  register wc may overlap the
integer accumulator (ia) in some implementations. thus any operation
changing the value in wc leaves (ia) undefined and vice versa except
as noted in the above restriction on simple dump/restore operations.



there is a single real accumulator (ra) which can hold any real value
and is completely separate from any of the other registers or program
accessible locations.



the code pointer register (cp) is a special index register for use in
implementations of interpretors.  it is used to contain a pseudo-code
pointer and can only be affected by icp, lcp, scp and lcw
instructions.  ejc section 4 - the stack

the following notes are to guide both implementors of systems written
in minimal and minimal programmers in dealing with stack manipulation.
implementation of a downwards building stack is easiest and in general
is to be preferred, in which case it is merely necessary to consider
xt as an alternative name for xl.

the minimal virtual machine includes a stack and has operand formats
-(xs) and (xs)+ for pushing and popping items with an implication that
the stack builds down in memory (a d-stack). however on some target
machines it is better for the stack to build up (a u-stack).  a stack
addressed only by push and pop operations can build in either
direction with no complication but such a pure scheme of stack access
proves restrictive.  hence it is permitted to access buried items
using an integer offset past the index register pointing to the stack
top. on target machines this offset will be positive/negative for
d-stacks/u-stacks and this must be allowed for in the translation.  a
further restriction is that at no time may an item be placed above the
stack top. for some operations this makes it convenient to advance the
stack pointer and then address items below it using a second index
register.  the problem of signed offsets past such a register then
arises. to distinguish stack offsets, which in some implementations
may be negative, from non-stack offsets which are invariably positive,
xt, an alias or synonym for xl is used. for a u-stack implementation,
the minimal translator should negate the sign of offsets applied to
both (xs) and (xt).  programmers should note that since xt is not a
separate register, xl should not be used in code where xt is
referenced. other modifications needed in u-stack translations are in
the add, sub, ica, dca opcodes applied to xs, xt. for example

minimal           d-stack trans.  u-stack trans.

mov  wa,-(xs)     sbi  xs,1       adi  xs,1
                  sto  wa,(xs)    sto  wa,(xs)
mov  (xt)+,wc     lod  wc,(xl)    lod  wc,(xl)
                  adi  xl,1       sbi  xl,1
add  =seven,xs    adi  xs,7       sbi  xs,7
mov  2(xt),wa     lod  wa,2(xl)   lod  wa,-2(xl)
ica  xs           adi  xs,1       sbi  xs,1

note that forms such as
mov  -(xs),wa
add  wa,(xs)+
are illegal, since they assume information storage
above the stack top.
ejc
section 5 - internal character set

the internal character set is represented by a set of contiguous codes
from 0 to cfp$a-1. the codes for the digits 0-9 must be contiguous and
in sequence. other than this, there are no restraints.

the following symbols are automatically defined to have the value of
the corresponding internal character code.

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

the following optional symbols are incorporated by defining the
conditional assembly symbol named.

26 shifted letters incorporated by defining .casl

ch$$a                 shifted a
ch$$b                 shifted b
.                     .
ch$$$                 shifted z

ch$ht                 horizontal tab - define .caht
ch$vt                 vertical tab   - define .cavt
ch$ey                 up arrow       - define .caex
ejc

section 6 - conditional assembly features

some features of the interpreter are applicable to only
certain target machines. they may be incorporated or
omitted by use of conditional assembly. the full
form of a condition is -
.if    conditional assembly symbol    (cas)
.then
       minimal statements1   (ms1)
.else
       minimal statements2   (ms2)
.fi
the following rules apply
1.   the directives .if, .then, .else, .fi must
     start in column 1.
2.   the conditional assembly symbol must start with a
     dot in column 8 followed by 4 letters or digits e.g.
        .ca$1
3.   .then is redundant and may be omitted if wished.
4.   ms1, ms2 are arbitrary sequences of minimal
     statements either of which may be null or may
     contain further conditions.
5.   if ms2 is omitted, .else may also be omitted.
6.   .fi is required.
7.   conditions may be nested to a depth determined
     by the translator (not less than 20, say).

selection of the alternatives ms1, ms2 is by means of the
define and undefine directives of form -
.def   cas
.undef cas

which obey rules 1. and 2. above and may occur at any point in a
minimal program, including within a condition.  multiply defining a
symbol is an error.  undefining a symbol which is not defined is not
an error.

the effect is that if a symbol is currently defined, then in any
condition depending on it, ms1 will be processed and ms2 omitted.
conversely if it is undefined, ms1 will be omitted and ms2 processed.

nesting of conditions is such that conditions in a section not
selected for processing must not be evaluated. nested conditions must
remember their environment whilst being processed. effectively this
implies use of a scheme based on a stack with .if, .fi matching by the
condition processor of the translator.  ejc

section 7 - operand formats

the following section describes the various possibilities
for operands of instructions and assembly operations.

01   int              unsigned integer le cfp$l
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
19   *dlbl            location containing dac cfp$b*dlbl
20   =wlbl            location containing dac wlbl
21   =clbl            location containing dac clbl
22   =elbl            location containing dac elbl
23   pnam             procedure label (on prc instruc)
24   eqop             operand for equ instruction
25   ptyp             procedure type (see prc)
26   text             arbitrary text (erb,err,ttl)
27   dtext            delimited text string (dtc)

the numbers in the above list are used in subsequent
description and in some of the minimal translators.
ejc

operand formats (continued)

the following special symbols refer to a collection of
the listed possibilities

val  01,02                      predefined value

     val is used to refer to a predefined one word
     integer value in the range 0 le n le cfp$l.

reg  07,08                      register

     reg is used to describe an operand which can be
     any of the registers (xl,xr,xs,xt,wa,wb,wc). such
     an operand can hold a one word integer (address).

opc  09,10,11                   character

     opc is used to designate a specific character
     operand for use in the lch and sch instructions.
     the index register referenced must be either xr or
     xl (not xs,xt). see section on character operations.

ops  03,04,09,12,13,14,15       memory reference

     ops is used to describe an operand which is in
     memory. the operand may be one or more words long
     depending on the data type. in the case of multiword
     operands, the address given is the first word.

opw  as for ops + 08,10,11      full word

     opw is used to refer to an operand whose capacity is
     that of a full memory word. opw includes all the
     possibilities for ops (the referenced word is used)
     plus the use of one of the three work registers
     (wa,wb,wc). in addition, the formats (x)+ and -(x)
     allow indexed operations in which the index register
     is popped by one word after the reference (x)+,
     or pushed by one word before the reference -(x)
     these latter two formats provide a facility for
     manipulation of stacks. the format does not imply
     a particular direction in which stacks must build -
     it is used for compactness. note that there is a
     restriction which disallows an instruction to use
     an index register in one of these formats
     in some other manner in the same instruction.
     e.g.   mov  xl,(xl)+   is illegal.
     the formats -(x) and (x)+ may also be used in
     pre-decrementation, post-incrementation to access
     the adjacent character of a string.
ejc

operand formats (continued)

opn  as for opw + 07            one word integer

     opn is used to represent an operand location which
     can contain a one word integer (e.g. an address).
     this includes all the possibilities for opw plus
     the use of one of the index registers (xl,xr,xt,
     xs). the range of integer values is 0 le n le cfp$l.

opv  as for opn + 18-22         one word integer value

     opv is used for an operand which can yield a one
     word integer value (e.g. an address). it includes
     all the possibilities for opn (the current value of
     the location is used) plus the use of literals. note
     that although the literal formats are described in
     terms of a reference to a location containing an
     address constant, this location may not actually
     exist in some implementations since only the value
     is required. a restriction is placed on literals
     which may consist only of defined symbols and
     certain labels. consequently small integers to be
     used as literals must be pre-defined, a discipline
     aiding program maintenance and revision.

addr 01,02,03,04,05             address

     addr is used to describe an explicit address value
     (one word integer value) for use with dac.


     ****************************************************
     *   in the following descriptions the usage --     *
     *      (xl),(xr), ... ,(ia)                        *
     *   in the descriptive text signifies the          +
     *   contents of the stated register.               *
     ****************************************************
ejc

section 8 - list of instruction mnemonics

the following list includes all instruction and
assembly operation mnemonics in alphabetical order.
the mnemonics are preceded by a number identifying
the following section where the instruction is described.
a star (*) is appended to the mnemonic if the last
operand may optionally be omitted.
see section -15- for details of statement format and
comment conventions.

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
ejc

alphabetical list of mnemonics (continued)

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
12.2  exp               define external procedure
 6.10 flc  w            fold character to upper case
 2.3  ica  opn          increment address by one word
 3.4  icp               increment code pointer
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
 3.1  lcp  reg          load code pointer register
 3.3  lcw  reg          load next code word
 4.1  ldi  ops          load integer
 5.1  ldr  ops          load real
 1.8  lei  x            load entry point id
 5.20 lnf               natural logorithm of real accum
 7.6  lsh  w,val        left shift bit string
 7.8  lsx  w,(x)        left shift indexed
 9.4  mcb               move characterswords backwards
 8.4  mfi* opn,plbl     convert (ia) to address value
 4.3  mli  ops          multiply integer
 5.5  mlr  ops          multiply real
 1.19 mnz  opn          move non-zero
 1.1  mov  opv,opn      move
 8.3  mti  opn          move address value to (ia)
 9.1  mvc               move characters
 9.2  mvw               move words
 9.3  mwb               move words backwards
 4.8  ngi               negate integer
ejc

alphabetical list of mnemonics (continued)

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
 3.2  scp  reg          store code pointer
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
ejc

section 9 - minimal instructions

the following descriptions assume the definitions -

zeroe  equ  0
unity  equ  1

-1-  basic instruction set

1.1  mov  opv,opn     move one word value

     
mov causes the value of operand opv to be set as the new contents
of operand location opn. in the case where opn is not an index
register, any value which can normally occupy a memory word (including
a part of a multiword real or integer value) can be transferred using
mov. if the target location opn is an index register, then opv must
specify an appropriate one word value or operand containing such an
appropriate value.

1.2  brn  plbl        unconditional branch

     
brn causes control to be passed to the indicated label in the program
section.

1.3  bsw  x,val,plbl  branch on switch value
1.4  iff  val,plbl    provide branch for switch
     iff  val,plbl     ...
     ...
     ...
1.5  esw              end of branch switch table

     
bsw,iff,esw provide a capability for a switched branch similar to a
fortran computed goto. the val on the bsw instruction is the maximum
number of branches. the value in x ranges from zero up to but not
including this maximum. each iff provides a branch. val must be less
than that given on the bsw and control goes to plbl if the value in x
matches.  if the value in x does not correspond to any of the iff
entries, then control passes to the plbl on the bsw. this plbl operand
may be omitted if there are no values missing from the list.

     
iff and esw may only be used in this context.  execution of bsw may
destroy the contents of x.  the iff entries may be in any order and
since a translator may thus need to store and sort them, the comment
field is restricted in length (sec 11).  ejc

-1-  basic instructions (continued)

1.6  ent  val         define program entry point

     
the symbol appearing in the label field is defined to be a program
entry point which can subsequently be used in conjunction with the bri
instruction, which provides the only means of entering the code. it is
illegal to fall into code identified by an entry point. the entry
symbol is assigned an address which need not be a multiple of cfp$b
but which must be in the range 0 le cfp$l and the address must not lie
within the address range of the allocated data area.  furthermore,
addresses of successive entry points must be assigned in some
ascending sequence so that the address comparison instructions can be
used to test the order in which two entry points occur. the symbol val
gives an identifying value to the entry point which can be accessed
with the lei instruction.

     
note - subject to the restriction below, val may be omitted if no such
identification is needed i.e.  if no lei references the entry point.
for this case, a translation optimisation is possible in which no
memory need be reserved for a null identification which is never to be
referenced, but only provided this is done so as not to interfere with
the strictly ascending sequence of entry point addresses. to simplify
this optimisation for all implementors, the following restriction is
observed val may only be omitted if the entry point is separated from
a following entry point by a non-null minimal code sequence.  entry
point addresses are accessible only by use of literals (=elbl, section
7) or dac constants (section 8-11.1).

1.7  bri  opn         branch indirect

     
opn contains the address of a program entry point (see ent). control
is passed to the executable code starting at the entry point address.
opn is left unchanged.

1.8  lei  x           load entry point identification

     
x contains the address of an entry point for which an identifying
value was given on the the ent line.  lei replaces the contents of x
by this value.  ejc

-1-  basic instructions (continued)

1.9  jsr  pnam        call procedure pnam
1.10 ppm  plbl        provide exit parameter
     ppm  plbl         ...
     ...
     ppm  plbl         ...

     
jsr causes control to be passed to the named procedure. pnam is the
label on a prc statement elsewhere in the program section (see prc) or
has been defined using an exp instruction.  the ppm exit parameters
following the call give names of program locations (plbl-s) to which
alternative exi returns of the called procedure may pass control. they
may optionally be replaced by error returns (see err). the number of
exit parameters following a jsr must equal the int in the procedure
definition. the operand of ppm may be omitted if the corresponding exi
return is certain not to be taken.

1.11 prc  ptyp,int    define start of procedure

	
     
the symbol appearing in the label field is defined to be the name of a
procedure for use with jsr.  a procedure is a contiguous section of
instructions to which control may be passed with a jsr instruction.
this is the only way in which the instructions in a procedure may be
executed. it is not permitted to fall into a procedure.  all
procedures should be named in section 0 inp statements.

     
int is the number of exit parameters (ppm-s) to be used in jsr calls.

     
there are three possibilities for ptyp, each consisting of a single
letter as follows.

     r                recursive

     
the return point (one or more words) is stored on the stack as though
one or more mov ...,-(xs) instructions were executed.  ejc

-1-  basic instructions (continued)

     n                non-recursive

     the return point is to be stored either

     (1) in a local storage word associated
     with the procedure and not directly
     available to the program in any other manner or

     (2) on a subroutine link stack quite distinct from
     the minimal stack addressed by xs.
     it is an error to use the stack for n-links, since
     procedure parameters or results may be passed via
     the stack.

     if method (2) is used for links, error exits
     (erb,err) from a procedure will necessitate link
     stack resetting. the ssl and sss orders provided
     for this may be regarded as no-ops for
     implementations using method (1).

     e                either

     
the return point may be stored in either manner according to
efficiency requirements of the actual physical machine used for the
implementation. note that programming of e type procedures must be
independent of the actual implementation.

      the actual form of the return point is undefined.  however, each
word stored on the stack for an r-type call must meet the following
requirements.

     1)               it can be handled as an address
                      and placed in an index register.

     2)               when used as an operand in an
                      address comparison instruction, it
                      must not appear to lie within
                      the allocated data area.

     3)               it is not required to appear
                      to lie within the program section.
ejc

-1-  basic instructions (continued)

1.12 exi  int         exit from procedure

     
the ppm and err parameters following a jsr are numbered starting from
1.  exi int causes control to be returned to the int-th such param.
exi 1 gives control to the plbl of the first ppm after the jsr.  if
int is omitted, control is passed back past the last exit parameter
(or past the jsr if there are none). for r and e type procedures, the
stack pointer xs must be set to its appropriate entry value before
executing an exi instruction.  in this case, exi removes return points
from the stack if any are stored there so that the stack pointer is
restored to its calling value.

1.13 enp              define end of procedure body

     
enp delimits a procedure body and may not actually be executed, hence
it must have no label.

1.14 err  int,text    provide error return

     
err may replace an exit parameter (ppm) in any procedure call. the int
argument is a unique error code in 0 to 899.  the text supplied as the
other operand is arbitrary text in the fortran character set and may
be used in constructing a file of error messages for documenting
purposes or for building a direct access or other file of messages to
be used by the error handling code.  in the event that an exi attempts
to return control via an exit parameter to an err, control is instead
passed to the first instruction in the error section (which follows
the program section) with the error code in wa.

1.15 erb  int,text    error branch

     
this instruction resembles err except that it may occur at any point
where a branch is permitted.  it effects a transfer of control to the
error section with the error code in wa.

1.16 icv  opn         increment value by one

     
icv increments the value of the operand by unity.  it is equivalent to
add =unity,opn

1.17 dcv  opn         decrement value by one

     
dcv decrements the value of the operand by unity.  it is equivalent to
sub =unity,opn ejc

basic instructions (continued)

1.18 zer  opn         zeroise opn

     
zer is equivalent to mov =zeroe,opn

1.19 mnz  opn         move non-zero to opn

     
any non-zero collectable value may used, for which the opcodes bnz/bze
will branch/fail to branch.

1.20 ssl  opw         subroutine stack load

1.21 sss  opw         subroutine stack store

     
this pair of operations is provided to make possible the use of a
local stack to hold subroutine (s-r) return links for n-type
procedures. sss stores the s-r stack pointer in opw and ssl loads the
s-r stack pointer from opw. by using sss in the main program or on
entry to a procedure which should regain control on occurrence of an
err or erb and by use of ssl in the error processing sections the s-r
stack pointer can be restored giving a link stack cleaned up ready for
resumed execution.  the form of the link stack pointer is undefined in
minimal (it is likely to be a private register known to the
translator) and the only requirement is that it should fit into a
single full word.  ssl and sss are no-ops if a private link stack is
not used.

1.22 rtn              define start of routine

     
a routine is a code chunk used for similar purposes to a procedure.
however it is entered by any type of conditional or unconditional
branch (not by jsr). on termination it passes control by a branch
(often bri through a code word) or even permits control to drop
through to another routine. no return link exists and the end of a
routine is not marked by an explicit opcode (compare enp).  all
routines should be named in section 0 inr statements.  ejc

-2-  operations on one word integer values (addresses)

2.1  add  opv,opn     

adds opv to the value in opn and stores the result in opn. undefined
if the result exceeds cfp$l.

2.2  sub  opv,opn     

subtracts opv from opn. stores the result in opn. undefined if the
result is negative.

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


the above instructions compare two address values as unsigned integer
values.  the blo and bhi instructions are used in cases where the
equal condition either does not occur or can result either in a branch
or no branch. this avoids inefficient translations in some
implementations.

2.13 bnz  opn,plbl    

equivalent to bne opn,=zeroe,plbl

2.14 bze  opn,plbl    

equivalent to beq opn,=zeroe,plbl



2.15 lct  w,opv       load counter for bct

     
lct loads a counter value for use with the bct instruction. the value
in opv is the number of loops to be executed. the value in w after
this operation is an undefined one word integer quantity.

2.16 bct  w,plbl      branch and count

     
 bct uses the counter value in w to branch the required number of
times and then finally to fall through to the next instruction. bct
can only be used following an appropriate lct instruction.  the value
in w after execution of bct is undefined.

2.17 aov  opv,opn,plbl add with carry test

     
adds opv to the value in opn and stores result in opn. branches to
plbl if result exceeds cfp$l with result in opn undefined. cf. add.

2.18 bev  opn,plbl     branch if even
2.19 bod  opn,plbl     branch if odd

     
these operations are used only if .cepp or .crpp is defined.  on some
implementations, a more efficient implementation is possible by noting
that address of blocks must always be a multiple of cfp$b. we call
such addresses even.  thus return address on the stack (.crpp) and
entry point addresses (.cepp) can be distinguished from block
addresses if they are forced to be odd (not a multiple of cfp$b).  bev
and bod branch according as operand is even or odd, respectively.  ejc

-3-  operations on the code pointer register (cp)

     
the code pointer register provides a psuedo instruction counter for
use in an interpretor. it may be implemented as a real register or as
a memory location, but in either case it is separate from any other
register. the value in the code pointer register is always a word
address (i.e.  a one word integer which is a multiple of cfp$b).

3.1  lcp  reg         

load code pointer register this instruction causes the code pointer
register to be set from the value in reg which is unchanged

3.2  scp  reg         

store code pointer register this instruction loads the current value
in the code pointer register into reg. (cp) is unchanged.

3.3  lcw  reg         

load next code word this instruction causes the word pointed to by cp
to be loaded into the indicated reg. the value in cp is then
incremented by one word.  execution of lcw may destroy xl.

3.4  icp              increment cp by one word

     
on machines with more than three index registers, cp can be treated
simply as an index register.  in this case, the following equivalences
apply.

     lcp reg is like mov reg,cp
     scp reg is like mov cp,reg
     lcw reg is like mov (cp)+,reg
     icp     is like ica cp

     
since lcw is allowed to destroy xl, the following implementation using
a work location cp$$$ can also be used.

     lcp  reg         mov  reg,cp$$$

     scp  reg         mov  cp$$$,reg

     lcw  reg         mov  cp$$$,xl
                      mov  (xl)+,reg
                      mov  xl,cp$$$

     icp              ica  cp$$$
ejc

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

     
the equation satisfied by operands and results of dvi and rmi is

            div = qot * ops + rem          where

     div = dividend in integer accumulator
     qot = quotient left in ia by div
     ops = the divisor
     rem = remainder left in ia by rmi

     
the sign of the result of dvi is + if (ia) and (ops) have the same
sign and is - if they have opposite signs. the sign of (ia) is always
used as the sign of the result of rem.  assuming in each case that ia
contains the number specified in parentheses and that seven and msevn
hold +7 and -7 resp. the algorithm is illustrated below.

     (ia = 13)
     dvi  seven       ia = 1
     rmi  seven       ia = 6
     dvi  msevn       ia = -1
     rmi  msevn       ia = 6
     (ia = -13)
     dvi  seven       ia = -1
     rmi  seven       ia = -6
     dvi  msevn       ia = 1
     rmi  msevn       ia = -6
ejc

     
the above instructions operate on a full range of signed integer
values. with the exception of ldi and sti, these instructions may
cause integer overflow by attempting to produce an undefined or out of
range result in which case integer overflow is set, the result in (ia)
is undefined and the following instruction must be iov or ino.
particular care may be needed on target machines having distinct
overflow and divide by zero conditions.

4.9  ino  plbl        jump to plbl if no integer overflow
4.10 iov  plbl        jump to plbl if integer overflow

     
these instructions can only occur immediately following an instruction
which can cause integer overflow (adi, sbi, mli, dvi, rmi, ngi) and
test the result of the preceding instruction.  iov and ino may not
have labels.

4.11 ieq  plbl        jump to plbl if (ia) eq 0
4.12 ige  plbl        jump to plbl if (ia) ge 0
4.13 igt  plbl        jump to plbl if (ia) gt 0
4.14 ile  plbl        jump to plbl if (ia) le 0
4.15 ilt  plbl        jump to plbl if (ia) lt 0
4.16 ine  plbl        jump to plbl if (ia) ne 0

     
the above conditional jump instructions do not change the contents of
the accumulator.  on a ones complement machine, it is permissible to
produce negative zero in ia provided these instructions operate
correctly with such a value.  ejc

-5-  operations on real values

5.1  ldr  ops         load real accumulator from ops
5.2  str  ops         store real accumulator at ops
5.3  adr  ops         add ops to real accumulator
5.4  sbr  ops         subtract ops from real accumulator
5.5  mlr  ops         multiply real accumulator by ops
5.6  dvr  ops         divide real accumulator by ops

     
if the result of any of the above operations causes underflow, the
result yielded is 0.0.

     
if the result of any of the above operations is undefined or out of
range, real overflow is set, the contents of (ra) are undefined and
the following instruction must be either rov or rno.  particular care
may be needed on target machines having distinct overflow and divide
by zero conditions.

5.7  rov  plbl        jump to plbl if real overflow
5.8  rno  plbl        jump to plbl if no real overflow

     
these instructions can only occur immediately following an instruction
which can cause real overflow (adr,sbr,mlr,dvr).

5.9  ngr              negate real accum (change sign)

5.10 req  plbl        jump to plbl if (ra) eq 0.0
5.11 rge  plbl        jump to plbl if (ra) ge 0.0
5.12 rgt  plbl        jump to plbl if (ra) gt 0.0
5.13 rle  plbl        jump to plbl if (ra) le 0.0
5.14 rlt  plbl        jump to plbl if (ra) lt 0.0
5.15 rne  plbl        jump to plbl if (ra) ne 0.0

     
the above conditional instructions do not affect the value stored in
the real accumulator.  on a ones complement machine, it is permissible
to produce negative zero in ra provided these instructions operate
correctly with such a value.  .if .cmth

5.16 atn              arctangent of real accum
5.17 chp              integer portion of real accum
5.18 cos              cosine of real accum
5.19 etx              e to the power in the real accum
5.20 lnf              natural logorithm of real accum
5.21 sin              sine of real accum
5.22 sqr              square root of real accum
5.23 tan              tangent of real accum

     
the above orders operate upon the real accumulator, and replace the
contents of the accumulator with the result.

     
if the result of any of the above operations is undefined or out of
range, real overflow is set, the contents of (ra) are undefined and
the following instruction must be either rov or rno.  .fi ejc

-6-  operations on character values

     
character operations employ the concept of a character pointer which
uses either index register xr or xl (not xs).

     
a character pointer points to a specific character in a string of
characters stored cfp$c chars to a word. the only operations permitted
on a character pointer are lch and sch. in particular, a character
pointer may not even be moved with mov.

        restriction 1.
        --------------
     
it is important when coding in minimal to ensure that no action
occurring between the initial use of plc or psc and the eventual
clearing of xl or xr on completion of character operations can
initiate a garbage collection. the latter of course could cause the
addressed characters to be moved leaving the character pointers
pointing to rubbish.

        restriction 2.
        --------------
     
a further restriction to be observed in code handling character
strings, is that strings built dynamically should be right padded with
zero characters to a full word boundary to permit easy hashing and use
of ceq or cne in testing strings for equality.

6.1  plc  x,opv       prepare ch ptr for lch,cmc,mvc,trc,
                      mcb.

6.2  psc  x,opv       prepare char. ptr for sch,mvc,mcb.

     
opv can be omitted if it is zero.  the char. initially addressed is
determined by the word address in x and the integer offset opv.  there
is an automatic implied offset of cfp$f bytes.  cfp$f is used to
formally introduce into minimal a value needed in translating these
opcodes which, since minimal itself does not prescribe a string
structure in detail, depends on the choice of a data structure for
strings in the minimal program.  

e.g. if cfp$b = cfp$c = 3, cfp$f = 6,
num01 = 1, xl points to a series of 4 words, abc/def/ghi/jkl, then plc
xl,=num01 points to h.  ejc

-6- operations on character values (continued)

6.3  lch  reg,opc     load character into reg

6.4  sch  reg,opc     store character from reg

     
these operations are defined such that the character is right
justified in register reg with zero bits to the left. after lch for
example, it is legitimate to regard reg as containing the ordinal
integer corresponding to the character.

     opc is one of the following three possibilities.

     (x)              

the character pointed to by the character pointer in x. the character
pointer is not changed.

     (x)+             

same character as (x) but the character pointer is incremented to
point to the next character following execution.

     -(x)             

the character pointer is decre- mented before accessing the character
so that the previous character is referenced.

6.5  csc  x           complete store characters

      
this instruction marks completion of a psc,sch,sch,...,sch sequence
initiated by a psc x instruction. no more sch instructions using x
should be obeyed until another psc is obeyed. it is provided solely as
an efficiency aid on machines without character orders since it
permits use of register buffering of chars in sch sequences. where csc
is not a no-op, it must observe restriction 2. (e.g. in spitbol, alocs
zeroises the last word of a string frame prior to sch sequence being
started so csc must not nullify this action.)

     
the following instructions are used to compare two words containing
cfp$c characters.  comparisons distinct from beq,bne are provided as
on some target machines, the possibility of the sign bit being set may
require special action.  note that restriction 2 above, eases use of
these orders in testing complete strings for equality, since whole
word tests are possible.

6.6  ceq  opw,opw,plbl jump to plbl if opw eq opw
6.7  cne  opw,opw,plbl jump to plbl if opw ne opw
ejc

-6- operations on character values (continued)

6.8  cmc  plbl,plbl   compare characters

     
cmc is used to compare two character strings. before executing cmc,
registers are set up as follows.

     (xl)             character ptr for first string
     (xr)             character pointer for second string
     (wa)             character count (must be .gt. zero)

     
xl and xr should have been prepared by plc.  control passes to first
plbl if the first string is lexically less than the second string, and
to the second plbl if the first string is lexically greater. control
passes to the following instruction if the strings are identical.
after executing this instruction, the values of xr and xl are set to
zero and the value in (wa) is undefined.  arguments to cmc may be
complete or partial strings, so making optimisation to use whole word
comparisons difficult (dependent in general on shifts and masking).

6.9  trc              translate characters

     
trc is used to translate a character string using a supplied
translation table. before executing trc the registers are set as
follows.

     (xl)             char ptr to string to be translated
     (xr)             char ptr to translate table

     (wa)             length of string to be translated

     
xl and xr should have been prepared by plc.  the translate table
consists of cfp$a contiguous characters giving the translations of the
cfp$a characters in the alphabet. on completion, (xr) and (xl) are set
to zero and (wa) is undefined.

6.10 flc  w           fold character to upper case

     
flc is used only if .culc is defined. the character code value in w is
translated to upper case if it corresponds to a lower case character.
ejc

-7-  operations on bit string values

7.1  anb  opw,w       and bit string values
7.2  orb  opw,w       or bit string values
7.3  xob  opw,w       exclusive or bit string values

     
in the above operations, the logical connective is applied separately
to each of the cfp$n bits.  the result is stored in the second operand
location.

7.4  cmb  w           complement all bits in opw

7.5  rsh  w,val       right shift by val bits
7.6  lsh  w,val       left shift by val bits
7.7  rsx  w,(x)       right shift w number of bits in x
7.8  lsx  w,(x)       left shift w number of bits in x

     
the above shifts are logical shifts in which bits shifted out are lost
and zero bits supplied as required. the shift count is in the range
0-cfp$n.

7.9  nzb  w,plbl      jump to plbl if w is not
                      all zero bits.

7.10 zrb  w,plbl      jump to plbl if w is all zero bits

7.11 zgb  opn         zeroise garbage bits

     
opn contains a bit string representing a word of characters from a
string or some function formed from such characters (e.g. as a result
of hashing). on a machine where the word size is not a multiple of the
character size, some bits in reg may be undefined. this opcode
replaces such bits by the zero bit. zgb is a no-op if the word size is
a multiple of the character size.  ejc

-8-  conversion instructions

     the following instructions provide for conversion
     between lengths in bytes and lengths in words.

8.1  wtb  reg         convert reg from words to bytes.
                      that is, multiply by cfp$b. this is
                      a no-op if cfp$b is one.

8.2  btw  reg         convert reg from bytes to words
                      by dividing reg by cfp$b discarding
                      the fraction. no-op if cfp$b is one

     
the following instructions provide for conversion of one word integer
values (addresses) to and from the full signed integer format.

8.3  mti  opn         

the value of opn (an address) is moved as a positive integer to the
integer accumulator.

8.4  mfi  opn,plbl    

the value currently stored in the integer accumulator is moved to opn
as an address if it is in the range 0 to cfp$m inclusive.  if the
accumulator value is outside this range, then the result in opn is
undefined and control is passed to plbl. mfi destroys the value of
(ia) whether or not integer overflow is signalled.  plbl may be
omitted if overflow is impossible.

     
the following instructions provide for conversion between real values
and integer values.

8.5  itr              

convert integer value in integer accumulator to real and store in real
accumulator (may lose precision in some cases)

8.6  rti  plbl        

convert the real value in ra to an integer and place result in ia.
conversion is by truncation of the fraction - no rounding occurs.
jump to plbl if out of range. (ra) is not changed in either case.
plbl may be omitted if overflow is impossible.  ejc

-8-  conversion instructions (continued)

     
the following instructions provide for computing the length of storage
required for a text string.

8.7  ctw  w,val       

this instruction computes the sum (number of words required to store w
characters) + (val). the sum is stored in w.  for example, if cfp$c is
5, and wa contains 32, then ctw wa,2 gives a result of 9 in wa.

8.8  ctb  w,val       

ctb is exactly like ctw except that the result is in bytes. it has the
same effect as ctw w,val wtb w

     
the following instructions provide for conversion from integers to and
from numeric digit characters for use in numeric conversion routines.
they employ negative integer values to allow for proper conversion of
numbers which cannot be complemented.

8.9  cvm  plbl        convert by multiplication

     
the integer accumulator, which is zero or negative, is multiplied by
10. wb contains the character code for a digit. the value of this
digit is then subtracted from the result. if the result is out of
range, then control is passed to plbl with the result in (ia)
undefined. execution of cvm leaves the result in (wb) undefined.

8.10 cvd              convert by division

     
the integer accumulator, which is zero or negative, is divided by 10.
the quotient (zero or negative) is replaced in the accumulator. the
remainder is converted to the character code of a digit and placed in
wa. for example, an operand of -523 gives a quotient of -52 and a
remainder in wa of ch$d3.  ejc

-9-  block move instructions

the following instructions are used for transferring
data from one area of memory to another in blocks.
they can be implemented with the indicated series of
other macro-instructions, but more efficient imple-
mentations will be possible on most machines.

note that in the equivalent code sequence shown below, a
zero value in wa will move at least one item, and may
may wrap the counter causing a core dump in some imple-
mentations.  thus wa should be .gt. 0 prior to invoking
any of these block move instructions.

9.1  mvc              move characters

     
before obeying this order wa,xl,xr should have been set up, the latter
two by plc, psc resp.

     
mvc is equivalent to the sequence

            mov  wb,dumpb
            lct  wa,wa
     loopc  lch  wb,(xl)+
            sch  wb,(xr)+
            bct  wa,loopc
            csc  xr
            mov  dumpb,wb

     
the character pointers are bumped as indicated and the final value of
wa is undefined.


9.2  mvw              move words

     
mvw is equivalent to the sequence

     loopw  mov  (xl)+,(xr)+
            dca  wa               wa = bytes to move
            bnz  wa,loopw

     
note that this implies that the value in wa is the length in bytes
which is a multiple of cfp$b.  the initial addresses in xr,xl are word
addresses.  as indicated, the final xr,xl values point past the new
and old regions of memory respectively.  the final value of wa is
undefined.  wa,xl,xr must be set up before obeying mvw.

9.3  mwb              move words backwards

     
mwb is equivalent to the sequence

     loopb  mov  -(xl),-(xr)
            dca  wa               wa = bytes to move
            bnz  wa,loopb

     
there is a requirement that the initial value in xl be at least 256
less than the value in xr. this allows an implementation in which
chunks of 256 bytes are moved forward (ibm 360, icl 1900).  the final
value of wa is undefined.  wa,xl,xr must be set up before obeying mwb.

9.4  mcb              move characters backwards

     
mcb is equivalent to the sequence

            mov  wb,dumpb
            lct  wa,wa
     loopc  lch  wb,-(xl)
            sch  wb,-(xr)
            bct  wa,loopc
            csc  xr
            mov  dumpb,wb

     
there is a requirement that the initial value in xl be at least 256
less than the value in xr. this allows an implementation in which
chunks of 256 bytes are moved forward (ibm 360, icl 1900).  the final
value of wa is undefined.  wa,xl,xr must be set up before obeying mcb.
ejc

-10- operations connected with the stack

the stack is an area in memory which is dedicated for use
in conjunction with the stack pointer register (xs). as
previously described, it is used by the jsr and exi
instructions and may be used for storage of any other
data as required.

the stack builds either way in memory and an important
restriction is that the value in (xs) must be the address
of the stack front at all times since
some implementations may randomly destroy stack locations
beyond (xs).

the starting stack base address is passed
in (xs) at the start of execution. during execution it
is necessary to make sure that the stack does not
overflow. this is achieved by executing the following
instruction periodically.

10.1 chk              check stack overflow

after successfully executing chk, it is permissible to
use up to 100 additional words before issuing another chk
thus chk need not be issued every time the stack is
expanded. in some implementations, the checking may be
automatic and chk will have no effect. following the
above rule makes sure that the program will operate
correctly in implementations with no automatic check.

if stack overflow occurs (detected either automatically
or by a chk instruction), then control is passed to the
stack overflow section (see program form). note that this
transfer may take place following any instruction which
stores data at a new location on the stack.
after stack overflow, stack is arbitrarily popped
to give some space in which the error procedure may
operate. otherwise a loop of stack overflows may occur.
ejc

-11- data generation instructions

the following instructions are used to generate constant
values in the constant section and also to assemble
initial values in the working storage section. they
may not appear except in these two sections.

11.1 dac  addr        

assemble address constant.  generates one word containing the
specified one word integer value (address).

11.2 dic  integer     

generates an integer value which occupies cfp$i consecutive words.
the operand is a digit string with a required leading sign.

11.3 drc  real        

assembles a real constant which occupies cfp$r consecutive words.  the
operand form must obey the rules for a fortran real constant with the
extra requirement that a leading sign be present.

11.4 dtc  dtext       

define text constant. dtext is started and ended with any character
not contained in the characters to be assembled. the constant occupies
consecutive words as dictated by the configuration parameter cfp$c.
any unused chars in the last word are right filled with zeros (i.e.
the character whose internal code is zero).  the string contains a
sequence of letters, digits, blanks and any of the following special
characters.  =,$.(*)/+- no other characters may be used in a dtext
operand.

11.5 dbc  val         

assemble bit string constant. the operand is a positive integer value
which is interpreted in binary, right justified and left filled with
zero bits. thus 5 would imply the bit string value 00...101.  ejc

-12- symbol definition instructions

the following instruction is used to define symbols
in the definitions section. it may not be used elsewhere.

12.1 equ  eqop        define symbol

     
the symbol which appears in the label field is defined to have the
absolute value given by the eqop operand. a given symbol may be
defined only once in this manner, and any symbols occuring in eqop
must be previously defined.

     the following are the possibilities for eqop

     val              

the indicated value is used

     val+val          

the sum of the two values is used.  this sum must not exceed cfp$m

     val-val          

the difference between the two values (must be positive) is used.

     *                

this format defines the label by using a value supplied by the minimal
translator. values are required for the cfp$x (configuration
parameters) e$xxx (environment parameters) ch$xx (character codes).
in order for a translator to handle this format correctly the
definitions section must be consulted for details of required symbols
as listed at the front of the section.  ejc

symbol definition instructions (continued)

the following instructions may be used to define symbols
in the procedure section. they may not be used in
any other part of the program.

12.2 exp              define external procedure

     
exp defines the symbol appearing in the label field to be the name of
an external procedure which can be referenced in a subsequent jsr
instruction. the coding for the procedure is external to the coding of
the source program in this language.  the code for external procedures
may be referred to collectively as the operating system interface, or
more briefly, osint, and will frequently be a separately compiled
segment of code loaded with spitbol to produce a complete system.

12.3 inp  ptyp,int    define internal procedure

     
inp defines the symbol appearing in the label field to be the name of
an internal procedure and gives its type and number of exit
parameters. the label can be referenced in jsr instructions and it
must appear labelling a prc instruction in the program section.

12.4 inr              define internal routine

     
inr defines the symbol appearing in the label field to be the name of
an internal routine. the label may be referenced in any type of branch
order and it must appear labelling a rtn instruction in the program
section.  ejc

-13- assembly listing layout instructions

13.1 ejc              eject to next page

13.2 ttl  text        set new assembly title

     
ttl implies an immediate eject of the assembly listing to print the
new title.

     
the use of ttl and ejc cards is such that the program will list neatly
if the printer prints as many as 58 lines per page. in the event that
the printer depth is less than this, or if the listing contains
interspersed lines (such as actual generated code), then the format
may be upset.

     
lines starting with an asterisk are comment lines which cause no code
to be generated and may occur freely anywhere in the program. the
format for comment lines is given in section -15-.  ejc

-14- program form

     
the program consists of separate sections separated by sec operations.
the sections must appear in the following specified order.

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
ejc

section 10 - program form

procedure section

     
the procedure section contains all the exp instructions for externally
available procedures and inp,inr opcodes for internal
procedures,routines so that a single pass minimal translator has
advance knowledge of procedure types when translating calls.

definitions section

     
the definitions section contains equ instructions which define symbols
referenced later on in the program, constant and work sections.

constant storage section

     
the constant storage section consists entirely of constants assembled
with the dac,dic,drc,dtc,dbc assembly operations. these constants can
be freely referenced by the program instructions.

working storage section

     
the working storage section consists entirely of dac,dic,drc,dbc,dtc
instructions to define a fixed length work area. the work locations in
this area can be directly referenced in program instructions.  the
area is initialized in accordance with the values assembled in the
instructions.

program section

     
the program section contains program instructions and associated
operations (such as prc, enp, ent).  control is passed to the first
instruction in this section when execution is initiated.

stack overflow section

     
the stack overflow section contains instructions like the program
section. control is passed to the first instruction in this section
following the occurrence of stack overflow, see chk instruction.

error section

     
the error section contains instructions like the program section.
control is passed to the first instruction in this section when a
procedure exit corresponds to an error parameter (see err) or when an
erb opcode is obeyed. the error code must clean up the main stack and
cater for the possibility that a subroutine stack may need clean up.
ejc osint

     
though not part of the minimal source, it is useful to refer to the
collection of initialisation and exp routines as osint (operating
system interface).  errors occurring within osint procedures are
usually handled by making an error return. if this is not feasible or
appropriate, osint may use the minimal error section to report errors
directly by branching to it with a suitable numeric error code in wa.
ejc

section 11 - statement format

all labels are exactly five characters long and start
with three letters (abcdefghijklmnopqrstuvwxy$) followed
by two letters or digits.
the letter z may not be used in minimal symbols but $ is
permitted.
for implementations where $ may not appear in the
target code , a simple substitution of z for $
may thus be made without risk of producing non-unique
symbols.
the letter z is however permitted in opcode mnemonics and
in comments.

minimal statements are in a fixed format as follows.

cols 1-5              label if any (else blank)

cols 6-7              always blank

cols 8-10             operation mnemonic

cols 11-12            blanks

cols 13-28            operand field, terminated by a
                      blank. may occasionally
                      extend past column 28.

cols 30-64            comment. always separated from the
                      operand field by at least one blank
                      may occasionally start after column
                      30 if the operand extends past 28.
                      a special exception occurs for the
                      iff instruction, whose comment may
                      be only 20 characters long (30-49).

cols 65 on            unused


comment lines have the following format

col 1                 asterisk

cols 2-7              blank

cols 8-64             arbitrary text, restricted to the
                      fortran character set.


the fortran character set is a-z 0-9 =,$.(*)-/+
ejc

section 12 - program execution

execution of the program begins with the first instruction in the
program section.

in addition to the fixed length memory regions defined by the
assembly, there are two dynamically allocated memory regions as
follows.

data area             

this is an area available to the program for general storage of data
any data value may be stored in this area except instructions.  in
some implementations, it may be possible to increase the size of this
area dynamically by adding words at the top end with a call to a
system procedure.

stack area            

this region of memory holds the stack used for subroutine calls and
other storage of one word integer values (addresses). this is the
stack associated with index register xs.

the locations and sizes of these areas are specified by the values in
the registers at the start of program execution as follows.

(xs)                  address one past the stack base.
                      e.g. if xs is 23456, a d-stack will
                      occupy words 23455,23454,...
                      whereas a u-stack will occupy
                      23457,23458,...

(xr)                  address of the first word
                      in the data area

(xl)                  address of the last word in the
                      data area.

(wa)                  initial stack pointer

(wb,wc,ia,ra,cp)      zero

there is no explicit way to terminate the execution of a program. this
function is performed by an appropriate system procedure referenced
with the sysej instruction.
