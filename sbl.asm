; copyright 1987-2012 robert b. k. dewar and mark emmer.
;
; copyright 2012-2015 david shields
;
; this file is part of macro spitbol.
;
;     macro spitbol is free software: you can redistribute it and/or modify
;     it under the terms of the gnu general public license as published by
;     the free software foundation, either version 2 of the license, or
;     (at your option) any later version.
;
;     macro spitbol is distributed in the hope that it will be useful,
;     but without any warranty; without even the implied warranty of
;     merchantability or fitness for a particular purpose.  see the
;     gnu general public license for more details.
;
;     you should have received a copy of the gnu general public license
;     along with macro spitbol.  if not, see <http://www.gnu.org/licenses/>.
;
;      spitbol conditional assembly symbols for use by token.spt
;      ---------------------------------------------------------
;
;      this file of conditional symbols will override the conditional
;      definitions contained in the spitbol minimal file.   in addition,
;      lines beginning with ">" are treated as spitbol statements and
;      immediately executed.
;
;      for linux spitbol-x86
;
;      in the spitbol translator, the following conditional
;      assembly symbols are referred to. to incorporate the
;      features referred to, the minimal source should be
;      prefaced by suitable conditional assembly symbol
;      definitions.
;      in all cases it is permissible to default the definitions
;      in which case the additional features will be omitted
;      from the target code.
;
;
;                            conditional options
;                            since .undef not allowed if symbol not
;                            defined, a full comment line indicates
;                            symbol initially not defined.
;
.def   .caex                 define to allow up arrow for exponentiation
.def   .caht                 define to include horizontal tab
.def   .casl                 define to include 26 shifted lettrs
;      .cavt                 define to include vertical tab
.def   .cbsp                 define to include backspace function
.def   .cbyt                 define for statistics in bytes
;      .ccmc                 define to include syscm function
.def   .ccmk                 define to include compare keyword
;      .ceng                 define to include engine features
.def   .cepp                 define if entry points have odd parity
.def   .cera                 define to include sysea function
.def   .cevb                 define to fix eval bug
.def   .cexp                 define to have spitbol pop sysex arguments
.def   .cgbc                 define to include sysgc function
.def   .cicc                 define to ignore unrecognised control card
.def   .cinc                 define to include -include control card
.def   .ciod                 if defined, default delimiter is
.def   .cmth                 define to include extended math functions
.def   .cnbf                 define to omit buffer extension
.def   .cnbt                 define to omit batch initialisation
;      .cnci                 define to enable sysci routine
;      .cncr                 define to enable syscr routine
;      .cnex                 define to omit exit() code.
;      .cnld                 define to omit load() code.
.def   .cnlf                 define to support file type for load()
;      .cnpf                 define to omit profile stuff
;def   .cnra                 define to omit all real arithmetic
.def   .cnsc                 define to omit numeric-string compare in sort
;      .cnsr                 define to omit sort, rsort
.def   .csou                 define if output, terminal go to sysou
.def   .cpol                 define if interface polling desired
.def   .crel                 define to include reloc routines
;      .crpp                 define if return points have odd parity
;      .cs16                 define to initialize stlim to 32767
.def   .cs32                 define to initialize stlim to 2147483647
.def   .csax                 define if sysax is to be called
.def   .csed                 define to use sediment in garbage collector
.def   .csfn                 define to track source file names
.def   .csln                 define to put source line number in code blocks
;      .csn5                 define to pad stmt nos to 5 chars
;      .csn6                 define to pad stmt nos to 6 chars
.def   .csn8                 define to pad stmt nos to 8 chars
;      .ctmd                 define if systm unit is decisecond
.def   .cucf                 define to include cfp$u
.def   .cuej                 define to suppress needless ejects
.def   .culc                 define to include &case (lc names)
.def   .culk                 define to include &lcase, &ucase keywords
.def   .cust                 define to include set() code
;      .cusr                 define to have set() use real values
;                             (must also #define setreal 1 in systype.h)
;
	ttl	l i c e n s e -- software license for this program
;
;     copyright 1983-2012 robert b. k. dewar
;     copyright 2012-2015 david shields
;
;     this file is part of macro spitbol.
;
;     macro spitbol is free software: you can redistribute it and/or modify
;     it under the terms of the gnu general public license as published by
;     the free software foundation, either version 2 of the license, or
;     (at your option) any later version.
;
;     macro spitbol is distributed in the hope that it will be useful,
;     but without any warranty; without even the implied warranty of
;     merchantability or fitness for a particular purpose.  see the
;     gnu general public license for more details.
;
;     you should have received a copy of the gnu general public license
;     along with macro spitbol.	 if not, see <http://www.gnu.org/licenses/>.
;
	ttl	s p i t b o l -- notes to implementors
;
;      m a c r o   s p i t b o l     v e r s i o n   13.01
;      ---------------------------------------------------
;
;      date of release	-  january 2013
;
;      macro spitbol is maintained by
;	    dr. david shields
;	    260 garth rd apt 3h4
;	    scarsdale, ny 10583
;      e-mail - thedaveshields at gmail dot com
;
;      version 3.7 was maintained by
;	    mark emmer
;	    catspaw, inc.
;	    p.o. box 1123
;	    salida, colorado 81021
;	    u.s.a
;      e-mail - marke at snobol4 dot com
;
;      versions 2.6 through 3.4 were maintained by
;	    dr. a. p. mccann (deceased)
;	    department of computer studies
;	    university of leeds
;	    leeds ls2 9jt
;	    england.
;
;      from 1979 through early 1983 a number of fixes and
;      enhancements were made by steve duff and robert goldberg.
;
;
	ttl	s p i t b o l - revision history
	ejc
;      r e v i s i o n	 h i s t o r y
;      -------------------------------
;
;      version 13.01 (january 2013, david shields)
;
;      this version has the same functionality as the previous release, but with
;      many internal code changes.
;      support for x86-64 has been added, but is not currently working.
;      the description of the minimal language formerly found here as comments
;      is now to be found in the file minimal-reference-manual.html
;
;      version 3.8 (june 2012, david shields)
;      --------------------------------------
;
;      this version is very close to v3.7, with the
;	       same functionality.
;
;	       the source is now maintained using git, so going forward
;	       the detailed revision history will be recorded in the git
;	       commit logs, not in this file.
;
	ttl	s p i t b o l  -- basic information
	ejc
;
;      general structure
;      -----------------
;
;      this program is a translator for a version of the snobol4
;      programming language. language details are contained in
;      the manual macro spitbol by dewar and mccann, technical
;      report 90, university of leeds 1976.
;      the implementation is discussed in dewar and mccann,
;      macro spitbol - a snobol4 compiler, software practice and
;      experience, 7, 95-113, 1977.
;      the language is as implemented by the btl translator
;      (griswold, poage and polonsky, prentice hall, 1971)
;      with the following principal exceptions.
;
;      1)   redefinition of standard system functions and
;	    operators is not permitted.
;
;      2)   the value function is not provided.
;
;      3)   access tracing is provided in addition to the
;	    other standard trace modes.
;
;      4)   the keyword stfcount is not provided.
;
;      5)   the keyword fullscan is not provided and all pattern
;	    matching takes place in fullscan mode (i.e. with no
;	    heuristics applied).
;
;      6)   a series of expressions separated by commas may
;	    be grouped within parentheses to provide a selection
;	    capability. the semantics are that the selection
;	    assumes the value of the first expression within it
;	    which succeeds as they are evaluated from the left.
;	    if no expression succeeds the entire statement fails
;
;      7)   an explicit pattern matching operator is provided.
;	    this is the binary query (see gimpel sigplan oct 74)
;
;      8)   the assignment operator is introduced as in the
;	    gimpel reference.
;
;      9)   the exit function is provided for generating load
;	    modules - cf. gimpels sitbol.
;
;
;      the method used in this program is to translate the
;      source code into an internal pseudo-code (see following
;      section). an interpretor is then used to execute this
;      generated pseudo-code. the nature of the snobol4 language
;      is such that the latter task is much more complex than
;      the actual translation phase. accordingly, nearly all the
;      code in the program section is concerned with the actual
;      execution of the snobol4 program.
	ejc
;
;      interpretive code format
;      ------------------------
;
;      the interpretive pseudo-code consists of a series of
;      address pointers. the exact format of the code is
;      described in connection with the cdblk format. the
;      purpose of this section is to give general insight into
;      the interpretive approach involved.
;
;      the basic form of the code is related to reverse polish.
;      in other words, the operands precede the operators which
;      are zero address operators. there are some exceptions to
;      these rules, notably the unary not operator and the
;      selection construction which clearly require advance
;      knowledge of the operator involved.
;
;      the operands are moved to the top of the main stack and
;      the operators are applied to the top stack entries. like
;      other versions of spitbol, this processor depends on
;      knowing whether operands are required by name or by value
;      and moves the appropriate object to the stack. thus no
;      name/value checks are included in the operator circuits.
;
;      the actual pointers in the code point to a block whose
;      first word is the address of the interpretor routine
;      to be executed for the code word.
;
;      in the case of operators, the pointer is to a word which
;      contains the address of the operator to be executed. in
;      the case of operands such as constants, the pointer is to
;      the operand itself. accordingly, all operands contain
;      a field which points to the routine to load the value of
;      the operand onto the stack. in the case of a variable,
;      there are three such pointers. one to load the value,
;      one to store the value and a third to jump to the label.
;
;      the handling of failure returns deserves special comment.
;      the location flptr contains the pointer to the location
;      on the main stack which contains the failure return
;      which is in the form of a byte offset in the current
;      code block (cdblk or exblk). when a failure occurs, the
;      stack is popped as indicated by the setting of flptr and
;      control is passed to the appropriate location in the
;      current code block with the stack pointer pointing to the
;      failure offset on the stack and flptr unchanged.
	ejc
;
;      internal data representations
;      -----------------------------
;
;      representation of values
;
;      a value is represented by a pointer to a block which
;      describes the type and particulars of the data value.
;      in general, a variable is a location containing such a
;      pointer (although in the case of trace associations this
;      is modified, see description of trblk).
;
;      the following is a list of possible datatypes showing the
;      type of block used to hold the value. the details of
;      each block format are given later.
;
;      datatype		     block type
;      --------		     ----------
;
;      array		     arblk or vcblk
;
;      code		     cdblk
;
;      expression	     exblk or seblk
;
;      integer		     icblk
;
;      name		     nmblk
;
;      pattern		     p0blk or p1blk or p2blk
;
;      real		     rcblk
;
;      string		     scblk
;
;      table		     tbblk
;
;      program datatype	     pdblk
	ejc
;
;      representation of variables
;      ---------------------------
;
;      during the course of evaluating expressions, it is
;      necessary to generate names of variables (for example
;      on the left side of a binary equals operator). these are
;      not to be confused with objects of datatype name which
;      are in fact values.
;
;      from a logical point of view, such names could be simply
;      represented by a pointer to the appropriate value cell.
;      however in the case of arrays and program defined
;      datatypes, this would violate the rule that there must be
;      no pointers into the middle of a block in dynamic store.
;      accordingly, a name is always represented by a base and
;      offset. the base points to the start of the block
;      containing the variable value and the offset is the
;      offset within this block in bytes. thus the address
;      of the actual variable is determined by adding the base
;      and offset values.
;
;      the following are the instances of variables represented
;      in this manner.
;
;      1)   natural variable base is ptr to vrblk
;			     offset is *vrval
;
;      2)   table element    base is ptr to teblk
;			     offset is *teval
;
;      3)   array element    base is ptr to arblk
;			     offset is offset to element
;
;      4)   vector element   base is ptr to vcblk
;			     offset is offset to element
;
;      5)   prog def dtp     base is ptr to pdblk
;			     offset is offset to field value
;
;      in addition there are two cases of objects which are
;      like variables but cannot be handled in this manner.
;      these are called pseudo-variables and are represented
;      with a special base pointer as follows=
;
;      expression variable   ptr to evblk (see evblk)
;
;      keyword variable	     ptr to kvblk (see kvblk)
;
;      pseudo-variables are handled as special cases by the
;      access procedure (acess) and the assignment procedure
;      (asign). see these two procedures for details.
	ejc
;
;      organization of data area
;      -------------------------
;
;      the data area is divided into two regions.
;
;      static area
;
;      the static area builds up from the bottom and contains
;      data areas which are allocated dynamically but are never
;      deleted or moved around. the macro-program itself
;      uses the static area for the following.
;
;      1)   all variable blocks (vrblk).
;
;      2)   the hash table for variable blocks.
;
;      3)   miscellaneous buffers and work areas (see program
;	    initialization section).
;
;      in addition, the system procedures may use this area for
;      input/output buffers, external functions etc. space in
;      the static region is allocated by calling procedure alost
;
;      the following global variables define the current
;      location and size of the static area.
;
;      statb		     address of start of static area
;      state		     address+1 of last word in area.
;
;      the minimum size of static is given approximately by
;	    12 + *e_hnb + *e_sts + space for alphabet string
;	    and standard print buffer.
	ejc
;      dynamic area
;
;      the dynamic area is built upwards in memory after the
;      static region. data in this area must all be in standard
;      block formats so that it can be processed by the garbage
;      collector (procedure gbcol). gbcol compacts blocks down
;      in this region as required by space exhaustion and can
;      also move all blocks up to allow for expansion of the
;      static region.
;      with the exception of tables and arrays, no spitbol
;      object once built in dynamic memory is ever subsequently
;      modified. observing this rule necessitates a copying
;      action during string and pattern concatenation.
;
;      garbage collection is fundamental to the allocation of
;      space for values. spitbol uses a very efficient garbage
;      collector which insists that pointers into dynamic store
;      should be identifiable without use of bit tables,
;      marker bits etc. to satisfy this requirement, dynamic
;      memory must not start at too low an address and lengths
;      of arrays, tables, strings, code and expression blocks
;      may not exceed the numerical value of the lowest dynamic
;      address.
;
;      to avoid either penalizing users with modest
;      requirements or restricting those with greater needs on
;      host systems where dynamic memory is allocated in low
;      addresses, the minimum dynamic address may be specified
;      sufficiently high to permit arbitrarily large spitbol
;      objects to be created (with the possibility in extreme
;      cases of wasting large amounts of memory below the
;      start address). this minimum value is made available
;      in variable mxlen by a system routine, sysmx.
;      alternatively sysmx may indicate that a
;      default may be used in which dynamic is placed
;      at the lowest possible address following static.
;
;      the following global work cells define the location and
;      length of the dynamic area.
;
;      dnamb		     start of dynamic area
;      dnamp		     next available location
;      dname		     last available location + 1
;
;      dnamb is always higher than state since the alost
;      procedure maintains some expansion space above state.
;      *** dnamb must never be permitted to have a value less
;      than that in mxlen ***
;
;      space in the dynamic region is allocated by the alloc
;      procedure. the dynamic region may be used by system
;      procedures provided that all the rules are obeyed.
;      some of the rules are subtle so it is preferable for
;      osint to manage its own memory needs. spitbol procs
;      obey rules to ensure that no action can cause a garbage
;      collection except at such times as contents of xl, xr
;      and the stack are +clean+ (see comment before utility
;      procedures and in gbcol for more detail). note
;      that calls of alost may cause garbage collection (shift
;      of memory to free space). spitbol procs which call
;      system routines assume that they cannot precipitate
;      collection and this must be respected.
	ejc
;
;      register usage
;      --------------
;
;      (cp)		     code pointer register. used to
;			     hold a pointer to the current
;			     location in the interpretive pseudo
;			     code (i.e. ptr into a cdblk).
;
;      (xl,xr)		     general index registers. usually
;			     used to hold pointers to blocks in
;			     dynamic storage. an important
;			     restriction is that the value in
;			     xl must be collectable for
;			     a garbage collect call. a value
;			     is collectable if it either points
;			     outside the dynamic area, or if it
;			     points to the start of a block in
;			     the dynamic area.
;
;      (xs)		     stack pointer. used to point to
;			     the stack front. the stack may
;			     build up or down and is used
;			     to stack subroutine return points
;			     and other recursively saved data.
;
;      (xt)		     an alternative name for xl during
;			     its use in accessing stacked items.
;
;      (wa,wb,wc)	     general work registers. cannot be
;			     used for indexing, but may hold
;			     various types of data.
;
;      (ia)		     used for all signed integer
;			     arithmetic, both that used by the
;			     translator and that arising from
;			     use of snobol4 arithmetic operators
;
;      (ra)		     real accumulator. used for all
;			     floating point arithmetic.
	ejc
;
;      spitbol conditional assembly symbols
;      ------------------------------------
;
;      in the spitbol translator, the following conditional
;      assembly symbols are referred to. to incorporate the
;      features referred to, the minimal source should be
;      prefaced by suitable conditional assembly symbol
;      definitions.
;      in all cases it is permissible to default the definitions
;      in which case the additional features will be omitted
;      from the target code.
;
;      .caex		     define to allow up arrow for expon.
;      .caht		     define to include horizontal tab
;      .casl		     define to include 26 shifted lettrs
;      .cavt		     define to include vertical tab
;      .cbyt		     define for statistics in bytes
;      .ccmc		     define to include syscm function
;      .ccmk		     define to include compare keyword
;      .cepp		     define if entrys have odd parity
;      .cera		     define to include sysea function
;      .cexp		     define if spitbol pops sysex args
;      .cgbc		     define to include sysgc function
;      .cicc		     define to ignore bad control cards
;      .cinc		     define to add -include control card
;      .ciod		     define to not use default delimiter
;			       in processing 3rd arg of input()
;			       and output()
;      .cmth		     define to include math functions
;      .cnbf		     define to omit buffer extension
;      .cnbt		     define to omit batch initialisation
;      .cnci		     define to enable sysci routine
;      .cncr		     define to enable syscr routine
;      .cnex		     define to omit exit() code.
;      .cnld		     define to omit load() code.
;      .cnlf		     define to add file type for load()
;      .cnpf		     define to omit profile stuff
;      .cnra		     define to omit all real arithmetic
;      .cnsc		     define to no numeric-string compare
;      .cnsr		     define to omit sort, rsort
;      .cpol		     define if interface polling desired
;      .crel		     define to include reloc routines
;      .crpp		     define if returns have odd parity
;      .cs16		     define to initialize stlim to 32767
;      .cs32		     define to init stlim to 2147483647
;			     omit to take default of 50000
;      .csax		     define if sysax is to be called
;      .csed		     define to use sediment in gbcol
;      .csfn		     define to track source file names
;      .csln		     define if line number in code block
;      .csn5		     define to pad stmt nos to 5 chars
;      .csn6		     define to pad stmt nos to 6 chars
;      .csn8		     define to pad stmt nos to 8 chars
;      .csou		     define if output, terminal to sysou
;      .ctet		     define to table entry trace wanted
;      .ctmd		     define if systm unit is decisecond
;      .cucf		     define to include cfp_u
;      .cuej		     define to suppress needless ejects
;      .culk		     define to include &l/ucase keywords
;      .culc		     define to include &case (lc names)
;			     if cucl defined, must support
;			     minimal op flc wreg that folds
;			     argument to lower case
;      .cust		     define to include set() code
;
;			     conditional options
;			     since .undef not allowed if symbol
;			     not defined, a full comment line
;			     indicates symbol initially not
;			     defined.
;
.def   .caex		     define to allow up arrow for expon.
.def   .caht		     define to include horizontal tab
.def   .casl		     define to include 26 shifted lettrs
.def   .cavt		     define to include vertical tab
;      .cbyt		     define for statistics in bytes
;      .ccmc		     define to include syscm function
;      .ccmk		     define to include compare keyword
;      .cepp		     define if entrys have odd parity
;      .cera		     define to include sysea function
;      .cexp		     define if spitbol pops sysex args
.def   .cgbc		     define to include sysgc function
;      .cicc		     define to ignore bad control cards
;      .cinc		     define to add -include control card
.def   .ciod		     define to not use default delimiter
;			     in processing 3rd arg of input()
;			     and output()
;      .cmth		     define to include math functions
.def   .cnbf		     define to omit buffer extension
.def   .cnbt		     define to omit batch initialisation
;      .cnci		     define to enable sysci routine
;      .cncr		     define to enable syscr routine
;      .cnex		     define to omit exit() code.
.def   .cnld		     define to omit load() code.
;      .cnlf		     define to add file type to load()
;      .cnpf		     define to omit profile stuff
;      .cnra		     define to omit all real arithmetic
;      .cnsc		     define if no numeric-string compare
;      .cnsr		     define to omit sort, rsort
;      .cpol		     define if interface polling desired
;      .crel		     define to include reloc routines
;      .crpp		     define if returns have odd parity
;      .cs16		     define to initialize stlim to 32767
;      .cs32		     define to init stlim to 2147483647
.def   .csax		     define if sysax is to be called
;      .csed		     define to use sediment in gbcol
;      .csfn		     define to track source file names
;      .csln		     define if line number in code block
;      .csn5		     define to pad stmt nos to 5 chars
;      .csn6		     define to pad stmt nos to 6 chars
.def   .csn8		     define to pad stmt nos to 8 chars
;      .csou		     define if output, terminal to sysou
.def   .ctet		     define to table entry trace wanted
;      .ctmd		     define if systm unit is decisecond
.def   .cucf		     define to include cfp_u
.def   .cuej		     define to suppress needless ejects
.def   .culk		     define to include &l/ucase keywords
.def   .culc		     define to include &case (lc names)
.def   .cust		     define to include set() code
;
;      force definition of .ccmk if .ccmc is defined
;
.if    .ccmc
.def   .ccmk
.fi
	ttl	s p i t b o l -- procedures section
;
;      this section starts with descriptions of the operating
;      system dependent procedures which are used by the spitbol
;      translator. all such procedures have five letter names
;      beginning with sys. they are listed in alphabetical
;      order.
;      all procedures have a  specification consisting of a
;      model call, preceded by a possibly empty list of register
;      contents giving parameters available to the procedure and
;      followed by a possibly empty list of register contents
;      required on return from the call or which may have had
;      their contents destroyed. only those registers explicitly
;      mentioned in the list after the call may have their
;      values changed.
;      the segment of code providing the external procedures is
;      conveniently referred to as osint (operating system
;      interface). the sysxx procedures it contains provide
;      facilities not usually available as primitives in
;      assembly languages. for particular target machines,
;      implementors may choose for some minimal opcodes which
;      do not have reasonably direct translations, to use calls
;      of additional procedures which they provide in osint.
;      e.g. mwb or trc might be translated as jsr sysmb,
;      jsr systc in some implementations.
;
;      in the descriptions, reference is made to --blk
;      formats (-- = a pair of letters). see the spitbol
;      definitions section for detailed descriptions of all
;      such block formats except fcblk for which sysfc should
;      be consulted.
;
;      section 0 contains inp,inr specifications of internal
;      procedures,routines. this gives a single pass translator
;      information making it easy to generate alternative calls
;      in the translation of jsr-s for procedures of different
;      types if this proves necessary.
;
	sec				; start of procedures section
.if    .csax
	ejc
;
;      sysax -- after execution
;
sysax	exp	0			; define external entry point
;
;      if the conditional assembly symbol .csax is defined,
;      this routine is called immediately after execution and
;      before printing of execution statistics or dump output.
;      purpose of call is for implementor to determine and
;      if the call is not required it will be omitted if .csax
;      is undefined. in this case sysax need not be coded.
;
;      jsr  sysax	     call after execution
.else
.fi
	ejc
.if    .cbsp
;
;      sysbs -- backspace file
;
sysbs	exp	3			; define external entry point
;
;      sysbs is used to implement the snobol4 function backspace
;      if the conditional assembly symbol .cbsp is defined.
;      the meaning is system dependent.	 in general, backspace
;      repositions the file one record closer to the beginning
;      of file, such that a subsequent read or write will
;      operate on the previous record.
;
;      (wa)		     ptr to fcblk or zero
;      (xr)		     backspace argument (scblk ptr)
;      jsr  sysbs	     call to backspace
;      ppm  loc		     return here if file does not exist
;      ppm  loc		     return here if backspace not allowed
;      ppm  loc		     return here if i/o error
;      (wa,wb)		     destroyed
;
;      the second error return is used for files for which
;      backspace is not permitted. for example, it may be expected
;      files on character devices are in this category.
	ejc
.fi
;
;      sysbx -- before execution
;
sysbx	exp	0			; define external entry point
;
;      called after initial spitbol compilation and before
;      commencing execution in case osint needs
;      to assign files or perform other necessary services.
;      osint may also choose to send a message to online
;      terminal (if any) indicating that execution is starting.
;
;      jsr  sysbx	     call before execution starts
	ejc
.if    .cnci
;
;      sysci -- convert integer
;
sysci	exp
;
;      sysci is an optional osint routine that causes spitbol to
;      call sysci to convert integer values to strings, rather
;      than using the internal spitbol conversion code.	 this
;      code may be less efficient on machines with hardware
;      conversion instructions and in such cases, it may be an
;      advantage to include sysci.  the symbol .cnci must be
;      defined if this routine is to be used.
;
;      the rules for converting integers to strings are that
;      positive values are represented without any sign, and
;      there are never any leading blanks or zeros, except in
;      the case of zero itself which is represented as a single
;      zero digit.  negative numbers are represented with a
;      preceeding minus sign.  there are never any trailing
;      blanks, and conversion cannot fail.
;
;      (ia)		     value to be converted
;      jsr  sysci	     call to convert integer value
;      (xl)		     pointer to pseudo-scblk with string
	ejc
.fi
.if    .ccmc
;
;      syscm -- general string comparison function
;
syscm	exp	1			; define external entry point
;
;      provides string comparison determined by interface.
;      used for international string comparison.
;
;
;      (xr)		     character pointer for first string
;      (xl)		     character pointer for second string
;      (wb)		     character count of first string
;      (wa)		     character count of second string
;      jsr  syscm	     call to syscm function
;      ppm  loc		     string too long for syscm
;      ppm  loc		     first string lexically gt second
;      ppm  loc		     first string lexically lt second
;      ---		     strings equal
;      (xl)		     zero
;      (xr)		     destroyed
;
	ejc
.fi
.if    .cnra
.else
.if    .cncr
;
;      syscr -- convert real
;
syscr	exp
;
;      syscr is an optional osint routine that causes spitbol to
;      call syscr to convert real values to strings, rather
;      than using the internal spitbol conversion code.	 this
;      code may be desired on machines where the integer size
;      is too small to allow production of a sufficient number
;      of significant digits.  the symbol .cncr must be defined
;      if this routine is to be used.
;
;      the rules for converting reals to strings are that
;      positive values are represented without any sign, and
;      there are never any leading blanks or zeros, except in
;      the case of zero itself which is represented as a single
;      zero digit.  negative numbers are represented with a
;      preceeding minus sign.  there are never any trailing
;      blanks, or trailing zeros in the fractional part.
;      conversion cannot fail.
;
;      (ra)		     value to be converted
;      (wa)		     no. of significant digits desired
;      (wb)		     conversion type:
;			      negative for e-type conversion
;			      zero for g-type conversion
;			      positive for f-type conversion
;      (wc)		     character positions in result scblk
;      (xr)		     scblk for result
;      jsr  syscr	     call to convert real value
;      (xr)		     result scblk
;      (wa)		     number of result characters
	ejc
.fi
.fi
;
;      sysdc -- date check
;
sysdc	exp	0			; define external entry point
;
;      sysdc is called to check that the expiry date for a trial
;      version of spitbol is unexpired.
;
;      jsr  sysdc	     call to check date
;      return only if date is ok
	ejc
;
;      sysdm  -- dump core
;
sysdm	exp	0			; define external entry point
;
;      sysdm is called by a spitbol program call of dump(n) with
;      n ge 4.	its purpose is to provide a core dump.
;      n could hold an encoding of the start adrs for dump and
;      amount to be dumped e.g.	 n = 256*a + s , s = start adrs
;      in kilowords,  a = kilowords to dump
;
;      (xr)		     parameter n of call dump(n)
;      jsr  sysdm	     call to enter routine
	ejc
;
;      sysdt -- get current date
;
sysdt	exp	0			; define external entry point
;
;      sysdt is used to obtain the current date. the date is
;      returned as a character string in any format appropriate
;      to the operating system in use. it may also contain the
;      current time of day. sysdt is used to implement the
;      snobol4 function date().
;
;      (xr)		     parameter n of call date(n)
;      jsr  sysdt	     call to get date
;      (xl)		     pointer to block containing date
;
;      the format of the block is like an scblk except that
;      the first word need not be set. the result is copied
;      into spitbol dynamic memory on return.
.if    .cera
	ejc
;
;      sysea -- inform osint of compilation and runtime errors
;
sysea	exp	1			; define external entry point
;
;      provides means for interface to take special actions on
;      errors
;
;      (wa)		     error code
;      (wb)		     line number
;      (wc)		     column number
;      (xr)		     system stage
.if    .csfn
;      (xl)		     file name (scblk)
.fi
;      jsr  sysea	     call to sysea function
;      ppm  loc		     suppress printing of error message
;      (xr)		     message to print (scblk) or 0
;
;      sysea may not return if interface chooses to retain
;      control.	 closing files via the fcb chain will be the
;      responsibility of the interface.
;
;      all registers preserved
.fi
	ejc
;
;      sysef -- eject file
;
sysef	exp	3			; define external entry point
;
;      sysef is used to write a page eject to a named file. it
;      may only be used for files where this concept makes
;      sense. note that sysef is not normally used for the
;      standard output file (see sysep).
;
;      (wa)		     ptr to fcblk or zero
;      (xr)		     eject argument (scblk ptr)
;      jsr  sysef	     call to eject file
;      ppm  loc		     return here if file does not exist
;      ppm  loc		     return here if inappropriate file
;      ppm  loc		     return here if i/o error
	ejc
;
;      sysej -- end of job
;
sysej	exp	0			; define external entry point
;
;      sysej is called once at the end of execution to
;      terminate the run. the significance of the abend and
;      code values is system dependent. in general, the code
;      value should be made available for testing, and the
;      abend value should cause some post-mortem action such as
;      a dump. note that sysej does not return to its caller.
;      see sysxi for details of fcblk chain
;
;      (wa)		     value of abend keyword
;      (wb)		     value of code keyword
;      (xl)		     o or ptr to head of fcblk chain
;      jsr  sysej	     call to end job
;
;      the following special values are used as codes in (wb)
;      999  execution suppressed
;      998  standard output file full or unavailable in a sysxi
;	    load module. in these cases (wa) contains the number
;	    of the statement causing premature termination.
	ejc
;
;      sysem -- get error message text
;
sysem	exp	0			; define external entry point
;
;      sysem is used to obtain the text of err, erb calls in the
;      source program given the error code number. it is allowed
;      to return a null string if this facility is unavailable.
;
;      (wa)		     error code number
;      jsr  sysem	     call to get text
;      (xr)		     text of message
;
;      the returned value is a pointer to a block in scblk
;      format except that the first word need not be set. the
;      string is copied into dynamic memory on return.
;      if the null string is returned either because sysem does
;      not provide error message texts or because wa is out of
;      range, spitbol will print the string stored in errtext
;      keyword.
	ejc
;
;      sysen -- endfile
;
sysen	exp	3			; define external entry point
;
;      sysen is used to implement the snobol4 function endfile.
;      the meaning is system dependent. in general, endfile
;      implies that no further i/o operations will be performed,
;      but does not guarantee this to be the case. the file
;      should be closed after the call, a subsequent read
;      or write may reopen the file at the start or it may be
;      necessary to reopen the file via sysio.
;
;      (wa)		     ptr to fcblk or zero
;      (xr)		     endfile argument (scblk ptr)
;      jsr  sysen	     call to endfile
;      ppm  loc		     return here if file does not exist
;      ppm  loc		     return here if endfile not allowed
;      ppm  loc		     return here if i/o error
;      (wa,wb)		     destroyed
;
;      the second error return is used for files for which
;      endfile is not permitted. for example, it may be expected
;      that the standard input and output files are in this
;      category.
	ejc
;
;      sysep -- eject printer page
;
sysep	exp	0			; define external entry point
;
;      sysep is called to perform a page eject on the standard
;      printer output file (corresponding to syspr output).
;
;      jsr  sysep	     call to eject printer output
	ejc
;
;      sysex -- call external function
;
sysex	exp	3			; define external entry point
;
;      sysex is called to pass control to an external function
;      previously loaded with a call to sysld.
;
;      (xs)		     pointer to arguments on stack
;      (xl)		     pointer to control block (efblk)
;      (wa)		     number of arguments on stack
;      jsr  sysex	     call to pass control to function
;      ppm  loc		     return here if function call fails
;      ppm  loc		     return here if insufficient memory
;      ppm  loc		     return here if bad argument type
.if    .cexp
.else
;      (xs)		     popped past arguments
.fi
;      (xr)		     result returned
;
;      the arguments are stored on the stack with
;      the last argument at 0(xs). on return, xs
;      is popped past the arguments.
;
;      the form of the arguments as passed is that used in the
;      spitbol translator (see definitions and data structures
;      section). the control block format is also described
;      (under efblk) in this section.
;
;      there are two ways of returning a result.
;
;      1)   return a pointer to a block in dynamic storage. this
;	    block must be in exactly correct format, including
;	    the first word. only functions written with intimate
;	    knowledge of the system will return in this way.
;
;      2)   string, integer and real results may be returned by
;	    pointing to a pseudo-block outside dynamic memory.
;	    this block is in icblk, rcblk or scblk format except
;	    that the first word will be overwritten
;	    by a type word on return and so need not
;	    be correctly set. such a result is
;	    copied into main storage before proceeding.
;	    unconverted results may similarly be returned in a
;	    pseudo-block which is in correct format including
;	    type word recognisable by garbage collector since
;	    block is copied into dynamic memory.
	ejc
;
;      sysfc -- file control block routine
;
sysfc	exp	2			; define external entry point
;
;      see also sysio
;      input and output have 3 arguments referred to as shown
;	    input(variable name,file arg1,file arg2)
;	    output(variable name,file arg1,file arg2)
;      file arg1 may be an integer or string used to identify
;      an i/o channel. it is converted to a string for checking.
;      the exact significance of file arg2
;      is not rigorously prescribed but to improve portability,
;      the scheme described in the spitbol user manual
;      should be adopted when possible. the preferred form is
;      a string _f_,r_r_,c_c_,i_i_,...,z_z_  where
;      _f_ is an optional file name which is placed first.
;	remaining items may be omitted or included in any order.
;      _r_ is maximum record length
;      _c_ is a carriage control character or character string
;      _i_ is some form of channel identification used in the
;	  absence of _f_ to associate the variable
;	  with a file allocated dynamically by jcl commands at
;	  spitbol load time.
;      ,...,z_z_ are additional fields.
;      if , (comma) cannot be used as a delimiter, .ciod
;      should be defined to introduce by conditional assembly
;      another delimiter (see
;	 iodel	equ  *
;      early in definitions section).
;      sysfc is called when a variable is input or output
;      associated to check file arg1 and file arg2 and
;      to  report whether an fcblk (file control
;      block) is necessary and if so what size it should be.
;      this makes it possible for spitbol rather than osint to
;      allocate such a block in dynamic memory if required
;      or alternatively in static memory.
;      the significance of an fcblk , if one is requested, is
;      entirely up to the system interface. the only restriction
;      is that if the fcblk should appear to lie in dynamic
;      memory, pointers to it should be proper pointers to
;      the start of a recognisable and garbage collectable
;      block (this condition will be met if sysfc requests
;      spitbol to provide an fcblk).
;      an option is provided for osint to return a pointer in
;      xl to an fcblk which it privately allocated. this ptr
;      will be made available when i/o occurs later.
;      private fcblks may have arbitrary contents and spitbol
;      stores nothing in them.
	ejc
;      the requested size for an fcblk in dynamic memory
;      should allow a 2 word overhead for block type and
;      length fields. information subsequently stored in the
;      remaining words may be arbitrary if an xnblk (external
;      non-relocatable block) is requested. if the request is
;      for an xrblk (external relocatable block) the
;      contents of words should be collectable (i.e. any
;      apparent pointers into dynamic should be genuine block
;      pointers). these restrictions do not apply if an fcblk
;      is allocated outside dynamic or is not allocated at all.
;      if an fcblk is requested, its fields will be initialised
;      to zero before entry to sysio with the exception of
;      words 0 and 1 in which the block type and length
;      fields are placed for fcblks in dynamic memory only.
;      for the possible use of sysej and sysxi, if fcblks
;      are used, a chain is built so that they may all be
;      found - see sysxi for details.
;      if both file arg1 and file arg2 are null, calls of sysfc
;      and sysio are omitted.
;      if file arg1 is null (standard input/output file), sysfc
;      is called to check non-null file arg2 but any request
;      for an fcblk will be ignored, since spitbol handles the
;      standard files specially and cannot readily keep fcblk
;      pointers for them.
;      filearg1 is type checked by spitbol so further checking
;      may be unneccessary in many implementations.
;      file arg2 is passed so that sysfc may analyse and
;      check it. however to assist in this, spitbol also passes
;      on the stack the components of this argument with
;      file name, _f_ (otherwise null) extracted and stacked
;      first.
;      the other fields, if any, are extracted as substrings,
;      pointers to them are stacked and a count of all items
;      stacked is placed in wc. if an fcblk was earlier
;      allocated and pointed to via file arg1, sysfc is also
;      passed a pointer to this fcblk.
;
;      (xl)		     file arg1 scblk ptr (2nd arg)
;      (xr)		     filearg2 (3rd arg) or null
;      -(xs)...-(xs)	     scblks for _f_,_r_,_c_,...
;      (wc)		     no. of stacked scblks above
;      (wa)		     existing file arg1 fcblk ptr or 0
;      (wb)		     0/3 for input/output assocn
;      jsr  sysfc	     call to check need for fcblk
;      ppm  loc		     invalid file argument
;      ppm  loc		     fcblk already in use
;      (xs)		     popped (wc) times
;      (wa non zero)	     byte size of requested fcblk
;      (wa=0,xl non zero)    private fcblk ptr in xl
;      (wa=xl=0)	     no fcblk wanted, no private fcblk
;      (wc)		     0/1/2 request alloc of xrblk/xnblk
;			     /static block for use as fcblk
;      (wb)		     destroyed
.if    .cgbc
	ejc
;
;      sysgc -- inform interface of garbage collections
;
sysgc	exp	0			; define external entry point
;
;      provides means for interface to take special actions
;      prior to and after a garbage collection.
;
;      possible usages-
;      1. provide visible screen icon of garbage collection
;	  in progress
;      2. inform virtual memory manager to ignore page access
;	  patterns during garbage collection.  such accesses
;	  typically destroy the page working set accumulated
;	  by the program.
;      3. inform virtual memory manager that contents of memory
;	  freed by garbage collection can be discarded.
;
;      (xr)		     non-zero if beginning gc
;			     =0 if completing gc
;      (wa)		     dnamb=start of dynamic area
;      (wb)		     dnamp=next available location
;      (wc)		     dname=last available location + 1
;      jsr  sysgc	     call to sysgc function
;      all registers preserved
.fi

	ejc
;
;      syshs -- give access to host computer features
;
syshs	exp	8			; define external entry point
;
;      provides means for implementing special features
;      on different host computers. the only defined entry is
;      that where all arguments are null in which case syshs
;      returns an scblk containing name of computer,
;      name of operating system and name of site separated by
;      colons. the scblk need not have a correct first field
;      as this is supplied on copying string to dynamic memory.
;      spitbol does no argument checking but does provide a
;      single error return for arguments checked as erroneous
;      by osint. it also provides a single execution error
;      return. if these are inadequate, use may be made of the
;      minimal error section direct as described in minimal
;      documentation, section 10.
;      several non-error returns are provided. the first
;      corresponds to the defined entry or, for implementation
;      defined entries, any string may be returned. the others
;      permit respectively,  return a null result, return with a
;      result to be stacked which is pointed at by xr, and a
;      return causing spitbol statement failure. if a returned
;      result is in dynamic memory it must obey garbage
;      collector rules. the only results copied on return
;      are strings returned via ppm loc3 return.
;
;      (wa)		     argument 1
;      (xl)		     argument 2
;      (xr)		     argument 3
;      (wb)		     argument 4
;      (wc)		     argument 5
;      jsr  syshs	     call to get host information
;      ppm  loc1	     erroneous arg
;      ppm  loc2	     execution error
;      ppm  loc3	     scblk ptr in xl or 0 if unavailable
;      ppm  loc4	     return a null result
;      ppm  loc5	     return result in xr
;      ppm  loc6	     cause statement failure
;      ppm  loc7	     return string at xl, length wa
;      ppm  loc8	     return copy of result in xr
	ejc
;
;      sysid -- return system identification
;
sysid	exp	0			; define external entry point
;
;      this routine should return strings to head the standard
;      printer output. the first string will be appended to
;      a heading line of the form
;	    macro spitbol version v.v
;      supplied by spitbol itself. v.v are digits giving the
;      major version number and generally at least a minor
;      version number relating to osint should be supplied to
;      give say
;	    macro spitbol version v.v(m.m)
;      the second string should identify at least the machine
;      and operating system.  preferably it should include
;      the date and time of the run.
;      optionally the strings may include site name of the
;      the implementor and/or machine on which run takes place,
;      unique site or copy number and other information as
;      appropriate without making it so long as to be a
;      nuisance to users.
;      the first words of the scblks pointed at need not be
;      correctly set.
;
;      jsr  sysid	     call for system identification
;      (xr)		     scblk ptr for addition to header
;      (xl)		     scblk ptr for second header
	ejc
.if    .cinc
;
;      sysif -- switch to new include file
;
sysif	exp	1			; define external entry point
;
;      sysif is used for include file processing, both to inform
;      the interface when a new include file is desired, and
;      when the end of file of an include file has been reached
;      and it is desired to return to reading from the previous
;      nested file.
;
;      it is the responsibility of sysif to remember the file
;      access path to the present input file before switching to
;      the new include file.
;
;      (xl)		     ptr to scblk or zero
;      (xr)		     ptr to vacant scblk of length cswin
;			     (xr not used if xl is zero)
;      jsr  sysif	     call to change files
;      ppm  loc		     unable to open file
;      (xr)		     scblk with full path name of file
;			     (xr not used if input xl is zero)
;
;      register xl points to an scblk containing the name of the
;      include file to which the interface should switch.  data
;      is fetched from the file upon the next call to sysrd.
;
;      sysif may have the ability to search multiple libraries
;      for the include file named in (xl).  it is therefore
;      required that the full path name of the file where the
;      file was finally located be returned in (xr).  it is this
;      name that is recorded along with the source statements,
;      and will accompany subsequent error messages.
;
;      register xl is zero to mark conclusion of use of an
;      include file.
	ejc
.fi
;
;      sysil -- get input record length
;
sysil	exp	0			; define external entry point
;
;      sysil is used to get the length of the next input record
;      from a file previously input associated with a sysio
;      call. the length returned is used to establish a buffer
;      for a subsequent sysin call.  sysil also indicates to the
;      caller if this is a binary or text file.
;
;      (wa)		     ptr to fcblk or zero
;      jsr  sysil	     call to get record length
;      (wa)		     length or zero if file closed
;      (wc)		     zero if binary, non-zero if text
;
;      no harm is done if the value returned is too long since
;      unused space will be reclaimed after the sysin call.
;
;      note that it is the sysil call (not the sysio call) which
;      causes the file to be opened as required for the first
;      record input from the file.
	ejc
;
;      sysin -- read input record
;
sysin	exp	3			; define external entry point
;
;      sysin is used to read a record from the file which was
;      referenced in a prior call to sysil (i.e. these calls
;      always occur in pairs). the buffer provided is an
;      scblk for a string of length set from the sysil call.
;      if the actual length read is less than this, the length
;      field of the scblk must be modified before returning
;      unless buffer is right padded with zeroes.
;      it is also permissible to take any of the alternative
;      returns after scblk length has been modified.
;
;      (wa)		     ptr to fcblk or zero
;      (xr)		     pointer to buffer (scblk ptr)
;      jsr  sysin	     call to read record
;      ppm  loc		     endfile or no i/p file after sysxi
;      ppm  loc		     return here if i/o error
;      ppm  loc		     return here if record format error
;      (wa,wb,wc)	     destroyed
	ejc
;
;      sysio -- input/output file association
;
sysio	exp	2			; define external entry point
;
;      see also sysfc.
;      sysio is called in response to a snobol4 input or output
;      function call except when file arg1 and file arg2
;      are both null.
;      its call always follows immediately after a call
;      of sysfc. if sysfc requested allocation
;      of an fcblk, its address will be in wa.
;      for input files, non-zero values of _r_ should be
;      copied to wc for use in allocating input buffers. if _r_
;      is defaulted or not implemented, wc should be zeroised.
;      once a file has been opened, subsequent input(),output()
;      calls in which the second argument is identical with that
;      in a previous call, merely associate the additional
;      variable name (first argument) to the file and do not
;      result in re-opening the file.
;      in subsequent associated accesses to the file a pointer
;      to any fcblk allocated will be made available.
;
;      (xl)		     file arg1 scblk ptr (2nd arg)
;      (xr)		     file arg2 scblk ptr (3rd arg)
;      (wa)		     fcblk ptr (0 if none)
;      (wb)		     0 for input, 3 for output
;      jsr  sysio	     call to associate file
;      ppm  loc		     return here if file does not exist
;      ppm  loc		     return if input/output not allowed
;      (xl)		     fcblk pointer (0 if none)
;      (wc)		     0 (for default) or max record lngth
;      (wa,wb)		     destroyed
;
;      the second error return is used if the file named exists
;      but input/output from the file is not allowed. for
;      example, the standard output file may be in this category
;      as regards input association.
	ejc
;
;      sysld -- load external function
;
sysld	exp	3			; define external entry point
;
;      sysld is called in response to the use of the snobol4
;      load function. the named function is loaded (whatever
;      this means), and a pointer is returned. the pointer will
;      be used on subsequent calls to the function (see sysex).
;
;      (xr)		     pointer to function name (scblk)
;      (xl)		     pointer to library name (scblk)
;      jsr  sysld	     call to load function
;      ppm  loc		     return here if func does not exist
;      ppm  loc		     return here if i/o error
;      ppm  loc		     return here if insufficient memory
;      (xr)		     pointer to loaded code
;
;      the significance of the pointer returned is up to the
;      system interface routine. the only restriction is that
;      if the pointer is within dynamic storage, it must be
;      a proper block pointer.
	ejc
;
;      sysmm -- get more memory
;
sysmm	exp	0			; define external entry point
;
;      sysmm is called in an attempt to allocate more dynamic
;      memory. this memory must be allocated contiguously with
;      the current dynamic data area.
;
;      the amount allocated is up to the system to decide. any
;      value is acceptable including zero if allocation is
;      impossible.
;
;      jsr  sysmm	     call to get more memory
;      (xr)		     number of additional words obtained
	ejc
;
;      sysmx -- supply mxlen
;
sysmx	exp	0			; define external entry point
;
;      because of the method of garbage collection, no spitbol
;      object is allowed to occupy more bytes of memory than
;      the integer giving the lowest address of dynamic
;      (garbage collectable) memory. mxlen is the name used to
;      refer to this maximum length of an object and for most
;      users of most implementations, provided dynamic memory
;      starts at an address of at least a few thousand words,
;      there is no problem.
;      if the default starting address is less than say 10000 or
;      20000, then a load time option should be provided where a
;      user can request that he be able to create larger
;      objects. this routine informs spitbol of this request if
;      any. the value returned is either an integer
;      representing the desired value of mxlen (and hence the
;      minimum dynamic store address which may result in
;      non-use of some store) or zero if a default is acceptable
;      in which mxlen is set to the lowest address allocated
;      to dynamic store before compilation starts.
;      if a non-zero value is returned, this is used for keyword
;      maxlngth. otherwise the initial low address of dynamic
;      memory is used for this keyword.
;
;      jsr  sysmx	     call to get mxlen
;      (wa)		     either mxlen or 0 for default
	ejc
;
;      sysou -- output record
;
sysou	exp	2			; define external entry point
;
;      sysou is used to write a record to a file previously
;      associated with a sysio call.
;
;      (wa)		     ptr to fcblk
.if    .csou
;			     or 0 for terminal or 1 for output
.fi
.if    .cnbf
;      (xr)		     record to be written (scblk)
.else
;      (xr)		     record to write (bcblk or scblk)
.fi
;      jsr  sysou	     call to output record
;      ppm  loc		     file full or no file after sysxi
;      ppm  loc		     return here if i/o error
;      (wa,wb,wc)	     destroyed
;
;      note that it is the sysou call (not the sysio call) which
;      causes the file to be opened as required for the first
;      record output to the file.
	ejc
;
;      syspi -- print on interactive channel
;
syspi	exp	1			; define external entry point
;
;      if spitbol is run from an online terminal, osint can
;      request that messages such as copies of compilation
;      errors be sent to the terminal (see syspp). if relevant
;      reply was made by syspp then syspi is called to send such
;      messages to the interactive channel.
;      syspi is also used for sending output to the terminal
;      through the special variable name, terminal.
;
;      (xr)		     ptr to line buffer (scblk)
;      (wa)		     line length
;      jsr  syspi	     call to print line
;      ppm  loc		     failure return
;      (wa,wb)		     destroyed
.if    .cpol
	ejc
;
;      syspl -- provide interactive control of spitbol
;
syspl	exp	3			; define external entry point
;
;      provides means for interface to take special actions,
;      such as interrupting execution, breakpointing, stepping,
;      and expression evaluation.  these last three options are
;      not presently implemented by the code calling syspl.
;
;
;      (wa)		     opcode as follows-
;			     =0 poll to allow osint to interrupt
;			     =1 breakpoint hit
;			     =2 completion of statement stepping
;			     =3 expression evaluation result
;      (wb)		     statement number
;      r_fcb		     o or ptr to head of fcblk chain
;      jsr  syspl	     call to syspl function
;      ppm  loc		     user interruption
;      ppm  loc		     step one statement
;      ppm  loc		     evaluate expression
;      ---		     resume execution
;			     (wa) = new polling interval
;
.fi
	ejc
;
;      syspp -- obtain print parameters
;
syspp	exp	0			; define external entry point
;
;      syspp is called once during compilation to obtain
;      parameters required for correct printed output format
;      and to select other options. it may also be called again
;      after sysxi when a load module is resumed. in this
;      case the value returned in wa may be less than or equal
;      to that returned in initial call but may not be
;      greater.
;      the information returned is -
;      1.   line length in chars for standard print file
;      2.   no of lines/page. 0 is preferable for a non-paged
;	    device (e.g. online terminal) in which case listing
;	    page throws are suppressed and page headers
;	    resulting from -title,-stitl lines are kept short.
;      3.   an initial -nolist option to suppress listing unless
;	    the program contains an explicit -list.
;      4.   options to suppress listing of compilation and/or
;	    execution stats (useful for established programs) -
;	    combined with 3. gives possibility of listing
;	    file never being opened.
;      5.   option to have copies of errors sent to an
;	    interactive channel in addition to standard printer.
;      6.   option to keep page headers short (e.g. if listing
;	    to an online terminal).
;      7.   an option to choose extended or compact listing
;	    format. in the former a page eject and in the latter
;	    a few line feeds precede the printing of each
;	    of-- listing, compilation statistics, execution
;	    output and execution statistics.
;      8.   an option to suppress execution as though a
;	    -noexecute card were supplied.
;      9.   an option to request that name /terminal/  be pre-
;	    associated to an online terminal via syspi and sysri
;      10.  an intermediate (standard) listing option requiring
;	    that page ejects occur in source listings. redundant
;	    if extended option chosen but partially extends
;	    compact option.
;      11.  option to suppress sysid identification.
;
;      jsr  syspp	     call to get print parameters
;      (wa)		     print line length in chars
;      (wb)		     number of lines/page
;      (wc)		     bits value ...mlkjihgfedcba where
;			     a = 1 to send error copy to int.ch.
;			     b = 1 means std printer is int. ch.
;			     c = 1 for -nolist option
;			     d = 1 to suppress compiln. stats
;
;			     e = 1 to suppress execn. stats
;			     f = 1/0 for extnded/compact listing
;			     g = 1 for -noexecute
;			     h = 1 pre-associate /terminal/
;
;			     i = 1 for standard listing option.
;			     j = 1 suppresses listing header
;			     k = 1 for -print
;			     l = 1 for -noerrors
.if    .culc
;
;			     m = 1 for -case 1
.fi
	ejc
;
;      syspr -- print line on standard output file
;
syspr	exp	1			; define external entry point
;
;      syspr is used to print a single line on the standard
;      output file.
;
;      (xr)		     pointer to line buffer (scblk)
;      (wa)		     line length
;      jsr  syspr	     call to print line
;      ppm  loc		     too much o/p or no file after sysxi
;      (wa,wb)		     destroyed
;
;      the buffer pointed to is the length obtained from the
;      syspp call and is filled out with trailing blanks. the
;      value in wa is the actual line length which may be less
;      than the maximum line length possible. there is no space
;      control associated with the line, all lines are printed
;      single spaced. note that null lines (wa=0) are possible
;      in which case a blank line is to be printed.
;
;      the error exit is used for systems which limit the amount
;      of printed output. if possible, printing should be
;      permitted after this condition has been signalled once to
;      allow for dump and other diagnostic information.
;      assuming this to be possible, spitbol may make more syspr
;      calls. if the error return occurs another time, execution
;      is terminated by a call of sysej with ending code 998.
	ejc
;
;      sysrd -- read record from standard input file
;
sysrd	exp	1			; define external entry point
;
;      sysrd is used to read a record from the standard input
;      file. the buffer provided is an scblk for a string the
;      length of which in characters is given in wc, this
;      corresponding to the maximum length of string which
;      spitbol is prepared to receive. at compile time it
;      corresponds to xxx in the most recent -inxxx card
;      (default 72) and at execution time to the most recent
;      ,r_r_ (record length) in the third arg of an input()
;      statement for the standard input file (default 80).
;      if fewer than (wc) characters are read, the length
;      field of the scblk must be adjusted before returning
;      unless the buffer is right padded with zeroes.
;      it is also permissible to take the alternative return
;      after such an adjustment has been made.
;      spitbol may continue to make calls after an endfile
;      return so this routine should be prepared to make
;      repeated endfile returns.
;
;      (xr)		     pointer to buffer (scblk ptr)
;      (wc)		     length of buffer in characters
;      jsr  sysrd	     call to read line
;      ppm  loc		     endfile or no i/p file after sysxi
.if    .csfn
;			     or input file name change.	 if
;			     the former, scblk length is zero.
;			     if input file name change, length
;			     is non-zero. caller should re-issue
;			     sysrd to obtain input record.
.fi
;      (wa,wb,wc)	     destroyed
	ejc
;
;      sysri -- read record from interactive channel
;
sysri	exp	1			; define external entry point
;
;      reads a record from online terminal for spitbol variable,
;      terminal. if online terminal is unavailable then code the
;      endfile return only.
;      the buffer provided is of length 258 characters. sysri
;      should replace the count in the second word of the scblk
;      by the actual character count unless buffer is right
;      padded with zeroes.
;      it is also permissible to take the alternative
;      return after adjusting the count.
;      the end of file return may be used if this makes
;      sense on the target machine (e.g. if there is an
;      eof character.)
;
;      (xr)		     ptr to 258 char buffer (scblk ptr)
;      jsr  sysri	     call to read line from terminal
;      ppm  loc		     end of file return
;      (wa,wb,wc)	     may be destroyed
	ejc
;
;      sysrw -- rewind file
;
sysrw	exp	3			; define external entry point
;
;      sysrw is used to rewind a file i.e. reposition the file
;      at the start before the first record. the file should be
;      closed and the next read or write call will open the
;      file at the start.
;
;      (wa)		     ptr to fcblk or zero
;      (xr)		     rewind arg (scblk ptr)
;      jsr  sysrw	     call to rewind file
;      ppm  loc		     return here if file does not exist
;      ppm  loc		     return here if rewind not allowed
;      ppm  loc		     return here if i/o error
	ejc
.if    .cust
;
;      sysst -- set file pointer
;
sysst	exp	0			; define external entry point
;
;      sysst is called to change the position of a file
;      pointer. this is accomplished in a system dependent
;      manner, and thus the 2nd and 3rd arguments are passed
;      unconverted.
;
;      (wa)		     fcblk pointer
;      (wb)		     2nd argument
;      (wc)		     3rd argument
;      jsr  sysst	     call to set file pointer
;      ppm  loc		     return here if invalid 2nd arg
;      ppm  loc		     return here if invalid 3rd arg
;      ppm  loc		     return here if file does not exist
;      ppm  loc		     return here if set not allowed
;      ppm  loc		     return here if i/o error
;
	ejc
.fi
;
;      systm -- get execution time so far
;
systm	exp	0			; define external entry point
;
;      systm is used to obtain the amount of execution time
;      used so far since spitbol was given control. the units
;      are described as milliseconds in the spitbol output, but
;      the exact meaning is system dependent. where appropriate,
;      this value should relate to processor rather than clock
;      timing values.
;      if the symbol .ctmd is defined, the units are described
;      as deciseconds (0.1 second).
;
;      jsr  systm	     call to get timer value
;      (ia)		     time so far in milliseconds
;			     (deciseconds if .ctmd defined)
	ejc
;
;      systt -- trace toggle
;
systt	exp	0			; define external entry point
;
;      called by spitbol function trace() with no args to
;      toggle the system trace switch.	this permits tracing of
;      labels in spitbol code to be turned on or off.
;
;      jsr  systt	     call to toggle trace switch
	ejc
;
;      sysul -- unload external function
;
sysul	exp	0			; define external entry point
;
;      sysul is used to unload a function previously
;      loaded with a call to sysld.
;
;      (xr)		     ptr to control block (efblk)
;      jsr  sysul	     call to unload function
;
;      the function cannot be called following a sysul call
;      until another sysld call is made for the same function.
;
;      the efblk contains the function code pointer and also a
;      pointer to the vrblk containing the function name (see
;      definitions and data structures section).
.if    .cnex
.else
	ejc
;
;      sysxi -- exit to produce load module
;
sysxi	exp	2			; define external entry point
;
;      when sysxi is called, xl contains either a string pointer
;      or zero. in the former case, the string gives the
;      character name of a program. the intention is that
;      spitbol execution should be terminated forthwith and
;      the named program loaded and executed. this type of chain
;      execution is very system dependent and implementors may
;      choose to omit it or find it impossible to provide.
;      if (xl) is zero,ia contains one of the following integers
;
;      -1, -2, -3, -4
;	    create if possible a load module containing only the
;	    impure area of memory which needs to be loaded with
;	    a compatible pure segment for subsequent executions.
;	    version numbers to check compatibility should be
;	    kept in both segments and checked on loading.
;	    to assist with this check, (xr) on entry is a
;	    pointer to an scblk containing the spitbol major
;	    version number v.v (see sysid).  the file thus
;	    created is called a save file.
;
;      0    if possible, return control to job control
;	    command level. the effect if available will be
;	    system dependent.
;
;      +1, +2, +3, +4
;	    create if possible a load module from all of
;	    memory. it should be possible to load and execute
;	    this module directly.
;
;      in the case of saved load modules, the status of open
;      files is not preserved and implementors may choose to
;      offer means of attaching files before execution of load
;      modules starts or leave it to the user to include
;      suitable input(), output() calls in his program.
;      sysxi should make a note that no i/o channels,
;      including standard files, have files attached so that
;      calls of sysin, sysou, syspr, sysrd should fail unless
;      new associations are made for the load module.
;      at least in the case of the standard output file, it is
;      recommended that either the user be required to attach
;      a file or that a default file is attached, since the
;      problem of error messages generated by the load module
;      is otherwise severe. as a last resort, if spitbol
;      attempts to write to the standard output file and gets a
;      reply indicating that such ouput is unacceptable it stops
;      by using an entry to sysej with ending code 998.
;      as described below, passing of some arguments makes it
;      clear that load module will use a standard output file.
;
;      if use is made of fcblks for i/o association, spitbol
;      builds a chain so that those in use may be found in sysxi
;      and sysej. the nodes are 4 words long. third word
;      contains link to next node or 0, fourth word contains
;      fcblk pointer.
	ejc
;
;      sysxi (continued)
;
;      (xl)		     zero or scblk ptr to first argument
;      (xr)		     ptr to v.v scblk
;      (ia)		     signed integer argument
;      (wa)		     scblk ptr to second argument
;      (wb)		     0 or ptr to head of fcblk chain
;      jsr  sysxi	     call to exit
;      ppm  loc		     requested action not possible
;      ppm  loc		     action caused irrecoverable error
;      (wb,wc,ia,xr,xl,cp)   should be preserved over call
;      (wa)		     0 in all cases except sucessful
;			     performance of exit(4) or exit(-4),
;			     in which case 1 should be returned.
;
;      loading and running the load module or returning from
;      jcl command level causes execution to resume at the point
;      after the error returns which follow the call of sysxi.
;      the value passed as exit argument is used to indicate
;      options required on resumption of load module.
;      +1 or -1 require that on resumption, sysid and syspp be
;      called and a heading printed on the standard output file.
;      +2 or -2 indicate that syspp will be called but not sysid
;      and no heading will be put on standard output file.
;      above options have the obvious implication that a
;      standard o/p file must be provided for the load module.
;      +3, +4, -3 or -4 indicate calls of neither sysid nor
;      syspp and no heading will be placed on standard output
;      file.
;      +4 or -4 indicate that execution is to continue after
;      creation of the save file or load module, although all
;      files will be closed by the sysxi action.  this permits
;      the user to checkpoint long-running programs while
;      continuing execution.
;
;      no return from sysxi is possible if another program
;      is loaded and entered.
.fi
	ejc
;
;      introduce the internal procedures.
;
acess	inp	r,1			;
acomp	inp	n,5			;
alloc	inp	e,0			;
.if    .cnbf
.else
alobf	inp	e,0			;
.fi
alocs	inp	e,0			;
alost	inp	e,0			;
.if    .cnbf
.else
apndb	inp	e,2			;
.fi
.if    .cnra
arith	inp	n,2			;
.else
arith	inp	n,3			;
.fi
asign	inp	r,1			;
asinp	inp	r,1			;
blkln	inp	e,0			;
cdgcg	inp	e,0			;
cdgex	inp	r,0			;
cdgnm	inp	r,0			;
cdgvl	inp	r,0			;
cdwrd	inp	e,0			;
cmgen	inp	r,0			;
cmpil	inp	e,0			;
cncrd	inp	e,0			;
copyb	inp	n,1			;
dffnc	inp	e,0			;
dtach	inp	e,0			;
dtype	inp	e,0			;
dumpr	inp	e,0			;
.if    .ceng
enevs	inp	r,0			;
engts	inp	e,0			;
.fi
ermsg	inp	e,0			;
ertex	inp	e,0			;
evali	inp	r,4			;
evalp	inp	r,1			;
evals	inp	r,3			;
evalx	inp	r,1			;
exbld	inp	e,0			;
expan	inp	e,0			;
expap	inp	e,1			;
expdm	inp	n,0			;
expop	inp	n,0			;
.if    .csfn
filnm	inp	e,0			;
.fi
.if    .culc
flstg	inp	e,0			;
.fi
gbcol	inp	e,0			;
gbcpf	inp	e,0			;
gtarr	inp	e,2			;
	ejc
gtcod	inp	e,1			;
gtexp	inp	e,1			;
gtint	inp	e,1			;
gtnum	inp	e,1			;
gtnvr	inp	e,1			;
gtpat	inp	e,1			;
.if    .cnra
.else
gtrea	inp	e,1			;
.fi
gtsmi	inp	n,2			;
.if    .cnbf
.else
gtstb	inp	n,1			;
.fi
gtstg	inp	n,1			;
gtvar	inp	e,1			;
hashs	inp	e,0			;
icbld	inp	e,0			;
ident	inp	e,1			;
inout	inp	e,0			;
.if    .cnbf
.else
insbf	inp	e,2			;
.fi
insta	inp	e,0			;
iofcb	inp	n,3			;
ioppf	inp	n,0			;
ioput	inp	n,7			;
ktrex	inp	r,0			;
kwnam	inp	n,0			;
lcomp	inp	n,5			;
listr	inp	e,0			;
listt	inp	e,0			;
.if    .csfn
newfn	inp	e,0			;
.fi
nexts	inp	e,0			;
patin	inp	n,2			;
patst	inp	n,1			;
pbild	inp	e,0			;
pconc	inp	e,0			;
pcopy	inp	n,0			;
.if    .cnpf
.else
prflr	inp	e,0			;
prflu	inp	e,0			;
.fi
prpar	inp	e,0			;
prtch	inp	e,0			;
prtic	inp	e,0			;
prtis	inp	e,0			;
prtin	inp	e,0			;
prtmi	inp	e,0			;
prtmm	inp	e,0			;
prtmx	inp	e,0			;
prtnl	inp	r,0			;
prtnm	inp	r,0			;
prtnv	inp	e,0			;
prtpg	inp	e,0			;
prtps	inp	e,0			;
prtsn	inp	e,0			;
prtst	inp	r,0			;
	ejc
prttr	inp	e,0			;
prtvl	inp	r,0			;
prtvn	inp	e,0			;
.if    .cnra
.else
rcbld	inp	e,0			;
.fi
readr	inp	e,0			;
.if    .crel
relaj	inp	e,0			;
relcr	inp	e,0			;
reldn	inp	e,0			;
reloc	inp	e,0			;
relst	inp	e,0			;
relws	inp	e,0			;
.fi
rstrt	inp	e,0			;
.if    .c370
sbool	inp	n,4			;
.fi
sbstr	inp	e,0			;
scane	inp	e,0			;
scngf	inp	e,0			;
setvr	inp	e,0			;
.if    .cnsr
.else
sorta	inp	n,1			;
sortc	inp	e,1			;
sortf	inp	e,0			;
sorth	inp	n,0			;
.fi
start	inp	e,0			;
stgcc	inp	e,0			;
tfind	inp	e,1			;
tmake	inp	e,0			;
trace	inp	n,2			;
trbld	inp	e,0			;
trimr	inp	e,0			;
trxeq	inp	r,0			;
vmake	inp	e,1			;
xscan	inp	e,0			;
xscni	inp	n,2			;
;
;      introduce the internal routines
;
arref	inr
cfunc	inr
exfal	inr
exint	inr
exits	inr
exixr	inr
exnam	inr
exnul	inr
.if    .cnra
.else
exrea	inr
.fi
exsid	inr
exvnm	inr
failp	inr
flpop	inr
indir	inr
match	inr
retrn	inr
stcov	inr
stmgo	inr
stopr	inr
succp	inr
sysab	inr
systu	inr
	ttl	s p i t b o l -- definitions and data structures
;      this section contains all symbol definitions and also
;      pictures of all data structures used in the system.
;
	sec				; start of definitions section
;
;      definitions of machine parameters
;
;      the minimal translator should supply appropriate values
;      for the particular target machine for all the
;      equ  *
;      definitions given at the start of this section.
;      note that even if conditional assembly is used to omit
;      some feature (e.g. real arithmetic) a full set of cfp_-
;      values must be supplied. use dummy values if genuine
;      ones are not needed.
;
cfp_a	equ	*			; number of characters in alphabet
;
cfp_b	equ	*			; bytes/word addressing factor
;
cfp_c	equ	*			; number of characters per word
;
cfp_f	equ	*			; offset in bytes to chars in
;			     scblk. see scblk format.
;
cfp_i	equ	*			; number of words in integer constant
;
cfp_m	equ	*			; max positive integer in one word
;
cfp_n	equ	*			; number of bits in one word
;
;      the following definitions require the supply of either
;      a single parameter if real arithmetic is omitted or
;      three parameters if real arithmetic is included.
;
.if    .cnra
nstmx	equ	*			; no. of decimal digits in cfp_m
.else
;
cfp_r	equ	*			; number of words in real constant
;
cfp_s	equ	*			; number of sig digs for real output
;
cfp_x	equ	*			; max digits in real exponent
.if    .cncr
nstmx	equ	*			; no. of decimal digits in cfp_m
;
mxdgs	equ	cfp_s+cfp_x		; max digits in real number
;
;      max space for real (for +0.e+) needs five more places
;
nstmr	equ	mxdgs+5			; max space for real
.else
;
mxdgs	equ	cfp_s+cfp_x		; max digits in real number
;
;
;      max space for real (for +0.e+) needs five more places
;
nstmx	equ	mxdgs+5			; max space for real
.fi
.fi
.if    .cucf
;
;      the following definition for cfp_u supplies a realistic
;      upper bound on the size of the alphabet.	 cfp_u is used
;      to save space in the scane bsw-iff-esw table and to ease
;      translation storage requirements.
;
cfp_u	equ	*			; realistic upper bound on alphabet
.fi
	ejc
;
;      environment parameters
;
;      the spitbol program is essentially independent of
;      the definitions of these parameters. however, the
;      efficiency of the system may be affected. consequently,
;      these parameters may require tuning for a given version
;      the values given in comments have been successfully used.
;
;      e_srs is the number of words to reserve at the end of
;      storage for end of run processing. it should be
;      set as small as possible without causing memory overflow
;      in critical situations (e.g. memory overflow termination)
;      and should thus reserve sufficient space at least for
;      an scblk containing say 30 characters.
;
e_srs	equ	*			; 30 words
;
;      e_sts is the number of words grabbed in a chunk when
;      storage is allocated in the static region. the minimum
;      permitted value is 256/cfp_b. larger values will lead
;      to increased efficiency at the cost of wasting memory.
;
e_sts	equ	*			; 500 words
;
;      e_cbs is the size of code block allocated initially and
;      the expansion increment if overflow occurs. if this value
;      is too small or too large, excessive garbage collections
;      will occur during compilation and memory may be lost
;      in the case of a too large value.
;
e_cbs	equ	*			; 500 words
;
;      e_hnb is the number of bucket headers in the variable
;      hash table. it should always be odd. larger values will
;      speed up compilation and indirect references at the
;      expense of additional storage for the hash table itself.
;
e_hnb	equ	*			; 127 bucket headers
;
;      e_hnw is the maximum number of words of a string
;      name which participate in the string hash algorithm.
;      larger values give a better hash at the expense of taking
;      longer to compute the hash. there is some optimal value.
;
e_hnw	equ	*			; 6 words
;
;      e_fsp.  if the amount of free space left after a garbage
;      collection is small compared to the total amount of space
;      in use garbage collector thrashing is likely to occur as
;      this space is used up.  e_fsp is a measure of the
;      minimum percentage of dynamic memory left as free space
;      before the system routine sysmm is called to try to
;      obtain more memory.
;
e_fsp	equ	*			; 15 percent
.if    .csed
;
;      e_sed.  if the amount of free space left in the sediment
;      after a garbage collection is a significant fraction of
;      the new sediment size, the sediment is marked for
;      collection on the next call to the garbage collector.
;
e_sed	equ	*			; 25 percent
.fi
	ejc
;
;      definitions of codes for letters
;
ch_la	equ	*			; letter a
ch_lb	equ	*			; letter b
ch_lc	equ	*			; letter c
ch_ld	equ	*			; letter d
ch_le	equ	*			; letter e
ch_lf	equ	*			; letter f
ch_lg	equ	*			; letter g
ch_lh	equ	*			; letter h
ch_li	equ	*			; letter i
ch_lj	equ	*			; letter j
ch_lk	equ	*			; letter k
ch_ll	equ	*			; letter l
ch_lm	equ	*			; letter m
ch_ln	equ	*			; letter n
ch_lo	equ	*			; letter o
ch_lp	equ	*			; letter p
ch_lq	equ	*			; letter q
ch_lr	equ	*			; letter r
ch_ls	equ	*			; letter s
ch_lt	equ	*			; letter t
ch_lu	equ	*			; letter u
ch_lv	equ	*			; letter v
ch_lw	equ	*			; letter w
ch_lx	equ	*			; letter x
ch_ly	equ	*			; letter y
ch_l_	equ	*			; letter z
;
;      definitions of codes for digits
;
ch_d0	equ	*			; digit 0
ch_d1	equ	*			; digit 1
ch_d2	equ	*			; digit 2
ch_d3	equ	*			; digit 3
ch_d4	equ	*			; digit 4
ch_d5	equ	*			; digit 5
ch_d6	equ	*			; digit 6
ch_d7	equ	*			; digit 7
ch_d8	equ	*			; digit 8
ch_d9	equ	*			; digit 9
	ejc
;
;      definitions of codes for special characters
;
;      the names of these characters are related to their
;      original representation in the ebcdic set corresponding
;      to the description in standard snobol4 manuals and texts.
;
ch_am	equ	*			; keyword operator (ampersand)
ch_as	equ	*			; multiplication symbol (asterisk)
ch_at	equ	*			; cursor position operator (at)
ch_bb	equ	*			; left array bracket (less than)
ch_bl	equ	*			; blank
ch_br	equ	*			; alternation operator (vertical bar)
ch_cl	equ	*			; goto symbol (colon)
ch_cm	equ	*			; comma
ch_dl	equ	*			; indirection operator (dollar)
ch_dt	equ	*			; name operator (dot)
ch_dq	equ	*			; double quote
ch_eq	equ	*			; equal sign
ch_ex	equ	*			; exponentiation operator (exclm)
ch_mn	equ	*			; minus sign / hyphen
ch_nm	equ	*			; number sign
ch_nt	equ	*			; negation operator (not)
ch_pc	equ	*			; percent
ch_pl	equ	*			; plus sign
ch_pp	equ	*			; left parenthesis
ch_rb	equ	*			; right array bracket (grtr than)
ch_rp	equ	*			; right parenthesis
ch_qu	equ	*			; interrogation operator (question)
ch_sl	equ	*			; slash
ch_sm	equ	*			; semicolon
ch_sq	equ	*			; single quote
ch_u_	equ	*			; special identifier char (underline)
ch_ob	equ	*			; opening bracket
ch_cb	equ	*			; closing bracket
	ejc
;
;      remaining chars are optional additions to the standards.
.if    .caht
;
;      tab characters - syntactically equivalent to blank
;
ch_ht	equ	*			; horizontal tab
.fi
.if    .cavt
ch_vt	equ	*			; vertical tab
.fi
.if    .caex
;
;      up arrow same as exclamation mark for exponentiation
;
ch_ey	equ	*			; up arrow
.fi
.if    .casl
;
;      lower case or shifted case alphabetic chars
;
ch_ua	equ	*			; shifted a
ch_ub	equ	*			; shifted b
ch_uc	equ	*			; shifted c
ch_ud	equ	*			; shifted d
ch_ue	equ	*			; shifted e
ch_uf	equ	*			; shifted f
ch_ug	equ	*			; shifted g
ch_uh	equ	*			; shifted h
ch_ui	equ	*			; shifted i
ch_uj	equ	*			; shifted j
ch_uk	equ	*			; shifted k
ch_ul	equ	*			; shifted l
ch_um	equ	*			; shifted m
ch_un	equ	*			; shifted n
ch_uo	equ	*			; shifted o
ch_up	equ	*			; shifted p
ch_uq	equ	*			; shifted q
ch_ur	equ	*			; shifted r
ch_us	equ	*			; shifted s
ch_ut	equ	*			; shifted t
ch_uu	equ	*			; shifted u
ch_uv	equ	*			; shifted v
ch_uw	equ	*			; shifted w
ch_ux	equ	*			; shifted x
ch_uy	equ	*			; shifted y
ch_uz	equ	*			; shifted z
.fi
;      if a delimiter other than ch_cm must be used in
;      the third argument of input(),output() then .ciod should
;      be defined and a parameter supplied for iodel.
;
.if    .ciod
iodel	equ	*			;
.else
iodel	equ	ch_cm			;
.fi
	ejc
;
;      data block formats and definitions
;
;      the following sections describe the detailed format of
;      all possible data blocks in static and dynamic memory.
;
;      every block has a name of the form xxblk where xx is a
;      unique two character identifier. the first word of every
;      block must contain a pointer to a program location in the
;      interpretor which is immediately preceded by an address
;      constant containing the value bl_xx where xx is the block
;      identifier. this provides a uniform mechanism for
;      distinguishing between the various block types.
;
;      in some cases, the contents of the first word is constant
;      for a given block type and merely serves as a pointer
;      to the identifying address constant. however, in other
;      cases there are several possibilities for the first
;      word in which case each of the several program entry
;      points must be preceded by the appropriate constant.
;
;      in each block, some of the fields are relocatable. this
;      means that they may contain a pointer to another block
;      in the dynamic area. (to be more precise, if they contain
;      a pointer within the dynamic area, then it is a pointer
;      to a block). such fields must be modified by the garbage
;      collector (procedure gbcol) whenever blocks are compacted
;      in the dynamic region. the garbage collector (actually
;      procedure gbcpf) requires that all such relocatable
;      fields in a block must be contiguous.
	ejc
;
;      the description format uses the following scheme.
;
;      1)   block title and two character identifier
;
;      2)   description of basic use of block and indication
;	    of circumstances under which it is constructed.
;
;      3)   picture of the block format. in these pictures low
;	    memory addresses are at the top of the page. fixed
;	    length fields are surrounded by i (letter i). fields
;	    which are fixed length but whose length is dependent
;	    on a configuration parameter are surrounded by *
;	    (asterisk). variable length fields are surrounded
;	    by / (slash).
;
;      4)   definition of symbolic offsets to fields in
;	    block and of the size of the block if fixed length
;	    or of the size of the fixed length fields if the
;	    block is variable length.
;	    note that some routines such as gbcpf assume
;	    certain offsets are equal. the definitions
;	    given here enforce this.  make changes to
;	    them only with due care.
;
;      definitions of common offsets
;
offs1	equ	1			;
offs2	equ	2			;
offs3	equ	3			;
;
;      5)   detailed comments on the significance and formats
;	    of the various fields.
;
;      the order is alphabetical by identification code.
	ejc
;
;      definitions of block codes
;
;      this table provides a unique identification code for
;      each separate block type. the first word of a block in
;      the dynamic area always contains the address of a program
;      entry point. the block code is used as the entry point id
;      the order of these codes dictates the order of the table
;      used by the datatype function (scnmt in the constant sec)
;
;      block codes for accessible datatypes
;
;      note that real and buffer types are always included, even
;      if they are conditionally excluded elsewhere.  this main-
;      tains block type codes across all versions of spitbol,
;      providing consistancy for external functions.  but note
;      that the bcblk is out of alphabetic order, placed at the
;      end of the list so as not to change the block type
;      ordering in use in existing external functions.
;
bl_ar	equ	0			; arblk	    array
bl_cd	equ	bl_ar+1			; cdblk	    code
bl_ex	equ	bl_cd+1			; exblk	    expression
bl_ic	equ	bl_ex+1			; icblk	    integer
bl_nm	equ	bl_ic+1			; nmblk	    name
bl_p0	equ	bl_nm+1			; p0blk	    pattern
bl_p1	equ	bl_p0+1			; p1blk	    pattern
bl_p2	equ	bl_p1+1			; p2blk	    pattern
bl_rc	equ	bl_p2+1			; rcblk	    real
bl_sc	equ	bl_rc+1			; scblk	    string
bl_se	equ	bl_sc+1			; seblk	    expression
bl_tb	equ	bl_se+1			; tbblk	    table
bl_vc	equ	bl_tb+1			; vcblk	    array
bl_xn	equ	bl_vc+1			; xnblk	    external
bl_xr	equ	bl_xn+1			; xrblk	    external
bl_bc	equ	bl_xr+1			; bcblk	    buffer
bl_pd	equ	bl_bc+1			; pdblk	    program defined datatype
;
bl__d	equ	bl_pd+1			; number of block codes for data
;
;      other block codes
;
bl_tr	equ	bl_pd+1			; trblk
bl_bf	equ	bl_tr+1			; bfblk
bl_cc	equ	bl_bf+1			; ccblk
bl_cm	equ	bl_cc+1			; cmblk
bl_ct	equ	bl_cm+1			; ctblk
bl_df	equ	bl_ct+1			; dfblk
bl_ef	equ	bl_df+1			; efblk
bl_ev	equ	bl_ef+1			; evblk
bl_ff	equ	bl_ev+1			; ffblk
bl_kv	equ	bl_ff+1			; kvblk
bl_pf	equ	bl_kv+1			; pfblk
bl_te	equ	bl_pf+1			; teblk
;
bl__i	equ	0			; default identification code
bl__t	equ	bl_tr+1			; code for data or trace block
bl___	equ	bl_te+1			; number of block codes
	ejc
;
;      field references
;
;      references to the fields of data blocks are symbolic
;      (i.e. use the symbolic offsets) with the following
;      exceptions.
;
;      1)   references to the first word are usually not
;	    symbolic since they use the (x) operand format.
;
;      2)   the code which constructs a block is often not
;	    symbolic and should be changed if the corresponding
;	    block format is modified.
;
;      3)   the plc and psc instructions imply an offset
;	    corresponding to the definition of cfp_f.
;
;      4)   there are non-symbolic references (easily changed)
;	    in the garbage collector (procedures gbcpf, blkln).
;
;      5)   the fields idval, fargs appear in several blocks
;	    and any changes must be made in parallel to all
;	    blocks containing the fields. the actual references
;	    to these fields are symbolic with the above
;	    listed exceptions.
;
;      6)   several spots in the code assume that the
;	    definitions of the fields vrval, teval, trnxt are
;	    the same (these are sections of code which search
;	    out along a trblk chain from a variable).
;
;      7)   references to the fields of an array block in the
;	    array reference routine arref are non-symbolic.
;
;      apart from the exceptions listed, references are symbolic
;      as far as possible and modifying the order or number
;      of fields will not require changes.
	ejc
;
;      common fields for function blocks
;
;      blocks which represent callable functions have two
;      common fields at the start of the block as follows.
;
;	    +------------------------------------+
;	    i		     fcode		 i
;	    +------------------------------------+
;	    i		     fargs		 i
;	    +------------------------------------+
;	    /					 /
;	    /	    rest of function block	 /
;	    /					 /
;	    +------------------------------------+
;
fcode	equ	0			; pointer to code for function
fargs	equ	1			; number of arguments
;
;      fcode is a pointer to the location in the interpretor
;      program which processes this type of function call.
;
;      fargs is the expected number of arguments. the actual
;      number of arguments is adjusted to this amount by
;      deleting extra arguments or supplying trailing nulls
;      for missing ones before transferring though fcode.
;      a value of 999 may be used in this field to indicate a
;      variable number of arguments (see svblk field svnar).
;
;      the block types which follow this scheme are.
;
;      ffblk		     field function
;      dfblk		     datatype function
;      pfblk		     program defined function
;      efblk		     external loaded function
	ejc
;
;      identification field
;
;
;      id   field
;
;      certain program accessible objects (those which contain
;      other data values and can be copied) are given a unique
;      identification number (see exsid). this id value is an
;      address integer value which is always stored in word two.
;
idval	equ	1			; id value field
;
;      the blocks containing an idval field are.
;
;      arblk		     array
.if    .cnbf
.else
;      bcblk		     buffer control block
.fi
;      pdblk		     program defined datatype
;      tbblk		     table
;      vcblk		     vector block (array)
;
;      note that a zero idval means that the block is only
;      half built and should not be dumped (see dumpr).
	ejc
;
;      array block (arblk)
;
;      an array block represents an array value other than one
;      with one dimension whose lower bound is one (see vcblk).
;      an arblk is built with a call to the functions convert
;      (s_cnv) or array (s_arr).
;
;	    +------------------------------------+
;	    i		     artyp		 i
;	    +------------------------------------+
;	    i		     idval		 i
;	    +------------------------------------+
;	    i		     arlen		 i
;	    +------------------------------------+
;	    i		     arofs		 i
;	    +------------------------------------+
;	    i		     arndm		 i
;	    +------------------------------------+
;	    *		     arlbd		 *
;	    +------------------------------------+
;	    *		     ardim		 *
;	    +------------------------------------+
;	    *					 *
;	    * above 2 flds repeated for each dim *
;	    *					 *
;	    +------------------------------------+
;	    i		     arpro		 i
;	    +------------------------------------+
;	    /					 /
;	    /		     arvls		 /
;	    /					 /
;	    +------------------------------------+
	ejc
;
;      array block (continued)
;
artyp	equ	0			; pointer to dummy routine b_art
arlen	equ	idval+1			; length of arblk in bytes
arofs	equ	arlen+1			; offset in arblk to arpro field
arndm	equ	arofs+1			; number of dimensions
arlbd	equ	arndm+1			; low bound (first subscript)
ardim	equ	arlbd+cfp_i		; dimension (first subscript)
arlb2	equ	ardim+cfp_i		; low bound (second subscript)
ardm2	equ	arlb2+cfp_i		; dimension (second subscript)
arpro	equ	ardim+cfp_i		; array prototype (one dimension)
arvls	equ	arpro+1			; start of values (one dimension)
arpr2	equ	ardm2+cfp_i		; array prototype (two dimensions)
arvl2	equ	arpr2+1			; start of values (two dimensions)
arsi_	equ	arlbd			; number of standard fields in block
ardms	equ	arlb2-arlbd		; size of info for one set of bounds
;
;      the bounds and dimension fields are signed integer
;      values and each occupy cfp_i words in the arblk.
;
;      the length of an arblk in bytes may not exceed mxlen.
;      this is required to keep name offsets garbage collectable
;
;      the actual values are arranged in row-wise order and
;      can contain a data pointer or a pointer to a trblk.
.if    .cnbf
.else
;
;      buffer control block (bcblk)
;
;      a bcblk is built for every bfblk.
;
;	    +------------------------------------+
;	    i		     bctyp		 i
;	    +------------------------------------+
;	    i		     idval		 i
;	    +------------------------------------+
;	    i		     bclen		 i
;	    +------------------------------------+
;	    i		     bcbuf		 i
;	    +------------------------------------+
;
bctyp	equ	0			; ptr to dummy routine b_bct
bclen	equ	idval+1			; defined buffer length
bcbuf	equ	bclen+1			; ptr to bfblk
bcsi_	equ	bcbuf+1			; size of bcblk
;
;      a bcblk is an indirect control header for bfblk.
;      the reason for not storing this data directly
;      in the related bfblk is so that the bfblk can
;      maintain the same skeletal structure as an scblk
;      thus facilitating transparent string operations
;      (for the most part).  specifically, cfp_f is the
;      same for a bfblk as for an scblk.  by convention,
;      whereever a buffer value is employed, the bcblk
;      is pointed to.
;
;      the corresponding bfblk is pointed to by the
;      bcbuf pointer in the bcblk.
;
;      bclen is the current defined size of the character
;      array in the bfblk.  characters following the offset
;      of bclen are undefined.
;
	ejc
;
;      string buffer block (bfblk)
;
;      a bfblk is built by a call to buffer(...)
;
;	    +------------------------------------+
;	    i		     bftyp		 i
;	    +------------------------------------+
;	    i		     bfalc		 i
;	    +------------------------------------+
;	    /					 /
;	    /		     bfchr		 /
;	    /					 /
;	    +------------------------------------+
;
bftyp	equ	0			; ptr to dummy routine b_bft
bfalc	equ	bftyp+1			; allocated size of buffer
bfchr	equ	bfalc+1			; characters of string
bfsi_	equ	bfchr			; size of standard fields in bfblk
;
;      the characters in the buffer are stored left justified.
;      the final word of defined characters is always zero
;      (character) padded.  any trailing allocation past the
;      word containing the last character contains
;      unpredictable contents and is never referenced.
;
;      note that the offset to the characters of the string
;      is given by cfp_f, as with an scblk.  however, the
;      offset which is occupied by the length for an scblk
;      is the total char space for bfblks, and routines which
;      deal with both must account for this difference.
;
;      the value of bfalc may not exceed mxlen.	 the value of
;      bclen is always less than or equal to bfalc.
;
.fi
	ejc
;
;      code construction block (ccblk)
;
;      at any one moment there is at most one ccblk into
;      which the compiler is currently storing code (cdwrd).
;
;	    +------------------------------------+
;	    i		     cctyp		 i
;	    +------------------------------------+
;	    i		     cclen		 i
.if    .csln
;	    +------------------------------------+
;	    i		     ccsln		 i
.fi
;	    +------------------------------------+
;	    i		     ccuse		 i
;	    +------------------------------------+
;	    /					 /
;	    /		     cccod		 /
;	    /					 /
;	    +------------------------------------+
;
cctyp	equ	0			; pointer to dummy routine b_cct
cclen	equ	cctyp+1			; length of ccblk in bytes
.if    .csln
ccsln	equ	cclen+1			; source line number
ccuse	equ	ccsln+1			; offset past last used word (bytes)
.else
ccuse	equ	cclen+1			; offset past last used word (bytes)
.fi
cccod	equ	ccuse+1			; start of generated code in block
;
;      the reason that the ccblk is a separate block type from
;      the usual cdblk is that the garbage collector must
;      only process those fields which have been set (see gbcpf)
	ejc
;
;      code block (cdblk)
;
;      a code block is built for each statement compiled during
;      the initial compilation or by subsequent calls to code.
;
;	    +------------------------------------+
;	    i		     cdjmp		 i
;	    +------------------------------------+
;	    i		     cdstm		 i
.if    .csln
;	    +------------------------------------+
;	    i		     cdsln		 i
.fi
;	    +------------------------------------+
;	    i		     cdlen		 i
;	    +------------------------------------+
;	    i		     cdfal		 i
;	    +------------------------------------+
;	    /					 /
;	    /		     cdcod		 /
;	    /					 /
;	    +------------------------------------+
;
cdjmp	equ	0			; ptr to routine to execute statement
cdstm	equ	cdjmp+1			; statement number
.if    .csln
cdsln	equ	cdstm+1			; source line number
cdlen	equ	cdsln+1			; length of cdblk in bytes
cdfal	equ	cdlen+1			; failure exit (see below)
.else
cdlen	equ	offs2			; length of cdblk in bytes
cdfal	equ	offs3			; failure exit (see below)
.fi
cdcod	equ	cdfal+1			; executable pseudo-code
cdsi_	equ	cdcod			; number of standard fields in cdblk
;
;      cdstm is the statement number of the current statement.
;
;      cdjmp, cdfal are set as follows.
;
;      1)   if the failure exit is the next statement
;
;	    cdjmp = b_cds
;	    cdfal = ptr to cdblk for next statement
;
;      2)   if the failure exit is a simple label name
;
;	    cdjmp = b_cds
;	    cdfal is a ptr to the vrtra field of the vrblk
;
;      3)   if there is no failure exit (-nofail mode)
;
;	    cdjmp = b_cds
;	    cdfal = o_unf
;
;      4)   if the failure exit is complex or direct
;
;	    cdjmp = b_cdc
;	    cdfal is the offset to the o_gof word
	ejc
;
;      code block (continued)
;
;      cdcod is the start of the actual code. first we describe
;      the code generated for an expression. in an expression,
;      elements are fetched by name or by value. for example,
;      the binary equal operator fetches its left argument
;      by name and its right argument by value. these two
;      cases generate quite different code and are described
;      separately. first we consider the code by value case.
;
;      generation of code by value for expressions elements.
;
;      expression	     pointer to exblk or seblk
;
;      integer constant	     pointer to icblk
;
;      null constant	     pointer to nulls
;
;      pattern		     (resulting from preevaluation)
;			     =o_lpt
;			     pointer to p0blk,p1blk or p2blk
;
;      real constant	     pointer to rcblk
;
;      string constant	     pointer to scblk
;
;      variable		     pointer to vrget field of vrblk
;
;      addition		     value code for left operand
;			     value code for right operand
;			     =o_add
;
;      affirmation	     value code for operand
;			     =o_aff
;
;      alternation	     value code for left operand
;			     value code for right operand
;			     =o_alt
;
;      array reference	     (case of one subscript)
;			     value code for array operand
;			     value code for subscript operand
;			     =o_aov
;
;			     (case of more than one subscript)
;			     value code for array operand
;			     value code for first subscript
;			     value code for second subscript
;			     ...
;			     value code for last subscript
;			     =o_amv
;			     number of subscripts
	ejc
;
;      code block (continued)
;
;      assignment	     (to natural variable)
;			     value code for right operand
;			     pointer to vrsto field of vrblk
;
;			     (to any other variable)
;			     name code for left operand
;			     value code for right operand
;			     =o_ass
;
;      compile error	     =o_cer
;
;
;      complementation	     value code for operand
;			     =o_com
;
;      concatenation	     (case of pred func left operand)
;			     value code for left operand
;			     =o_pop
;			     value code for right operand
;
;			     (all other cases)
;			     value code for left operand
;			     value code for right operand
;			     =o_cnc
;
;      cursor assignment     name code for operand
;			     =o_cas
;
;      division		     value code for left operand
;			     value code for right operand
;			     =o_dvd
;
;      exponentiation	     value code for left operand
;			     value code for right operand
;			     =o_exp
;
;      function call	     (case of call to system function)
;			     value code for first argument
;			     value code for second argument
;			     ...
;			     value code for last argument
;			     pointer to svfnc field of svblk
;
	ejc
;
;      code block (continued)
;
;      function call	     (case of non-system function 1 arg)
;			     value code for argument
;			     =o_fns
;			     pointer to vrblk for function
;
;			     (non-system function, gt 1 arg)
;			     value code for first argument
;			     value code for second argument
;			     ...
;			     value code for last argument
;			     =o_fnc
;			     number of arguments
;			     pointer to vrblk for function
;
;      immediate assignment  value code for left operand
;			     name code for right operand
;			     =o_ima
;
;      indirection	     value code for operand
;			     =o_inv
;
;      interrogation	     value code for operand
;			     =o_int
;
;      keyword reference     name code for operand
;			     =o_kwv
;
;      multiplication	     value code for left operand
;			     value code for right operand
;			     =o_mlt
;
;      name reference	     (natural variable case)
;			     pointer to nmblk for name
;
;			     (all other cases)
;			     name code for operand
;			     =o_nam
;
;      negation		     =o_nta
;			     cdblk offset of o_ntc word
;			     value code for operand
;			     =o_ntb
;			     =o_ntc
	ejc
;
;      code block (continued)
;
;      pattern assignment    value code for left operand
;			     name code for right operand
;			     =o_pas
;
;      pattern match	     value code for left operand
;			     value code for right operand
;			     =o_pmv
;
;      pattern replacement   name code for subject
;			     value code for pattern
;			     =o_pmn
;			     value code for replacement
;			     =o_rpl
;
;      selection	     (for first alternative)
;			     =o_sla
;			     cdblk offset to next o_slc word
;			     value code for first alternative
;			     =o_slb
;			     cdblk offset past alternatives
;
;			     (for subsequent alternatives)
;			     =o_slc
;			     cdblk offset to next o_slc,o_sld
;			     value code for alternative
;			     =o_slb
;			     offset in cdblk past alternatives
;
;			     (for last alternative)
;			     =o_sld
;			     value code for last alternative
;
;      subtraction	     value code for left operand
;			     value code for right operand
;			     =o_sub
	ejc
;
;      code block (continued)
;
;      generation of code by name for expression elements.
;
;      variable		     =o_lvn
;			     pointer to vrblk
;
;      expression	     (case of *natural variable)
;			     =o_lvn
;			     pointer to vrblk
;
;			     (all other cases)
;			     =o_lex
;			     pointer to exblk
;
;
;      array reference	     (case of one subscript)
;			     value code for array operand
;			     value code for subscript operand
;			     =o_aon
;
;			     (case of more than one subscript)
;			     value code for array operand
;			     value code for first subscript
;			     value code for second subscript
;			     ...
;			     value code for last subscript
;			     =o_amn
;			     number of subscripts
;
;      compile error	     =o_cer
;
;      function call	     (same code as for value call)
;			     =o_fne
;
;      indirection	     value code for operand
;			     =o_inn
;
;      keyword reference     name code for operand
;			     =o_kwn
;
;      any other operand is an error in a name position
;
;      note that in this description, =o_xxx refers to the
;      generation of a word containing the address of another
;      word which contains the entry point address o_xxx.
	ejc
;
;      code block (continued)
;
;      now we consider the overall structure of the code block
;      for a statement with possible goto fields.
;
;      first comes the code for the statement body.
;      the statement body is an expression to be evaluated
;      by value although the value is not actually required.
;      normal value code is generated for the body of the
;      statement except in the case of a pattern match by
;      value, in which case the following is generated.
;
;			     value code for left operand
;			     value code for right operand
;			     =o_pms
;
;      next we have the code for the success goto. there are
;      several cases as follows.
;
;      1)   no success goto  ptr to cdblk for next statement
;
;      2)   simple label     ptr to vrtra field of vrblk
;
;      3)   complex goto     (code by name for goto operand)
;			     =o_goc
;
;      4)   direct goto	     (code by value for goto operand)
;			     =o_god
;
;      following this we generate code for the failure goto if
;      it is direct or if it is complex, simple failure gotos
;      having been handled by an appropriate setting of the
;      cdfal field of the cdblk. the generated code is one
;      of the following.
;
;      1)   complex fgoto    =o_fif
;			     =o_gof
;			     name code for goto operand
;			     =o_goc
;
;      2)   direct fgoto     =o_fif
;			     =o_gof
;			     value code for goto operand
;			     =o_god
;
;      an optimization occurs if the success and failure gotos
;      are identical and either complex or direct. in this case,
;      no code is generated for the success goto and control
;      is allowed to fall into the failure goto on success.
	ejc
;
;      compiler block (cmblk)
;
;      a compiler block (cmblk) is built by expan to represent
;      one node of a tree structured expression representation.
;
;	    +------------------------------------+
;	    i		     cmidn		 i
;	    +------------------------------------+
;	    i		     cmlen		 i
;	    +------------------------------------+
;	    i		     cmtyp		 i
;	    +------------------------------------+
;	    i		     cmopn		 i
;	    +------------------------------------+
;	    /		cmvls or cmrop		 /
;	    /					 /
;	    /		     cmlop		 /
;	    /					 /
;	    +------------------------------------+
;
cmidn	equ	0			; pointer to dummy routine b_cmt
cmlen	equ	cmidn+1			; length of cmblk in bytes
cmtyp	equ	cmlen+1			; type (c_xxx, see list below)
cmopn	equ	cmtyp+1			; operand pointer (see below)
cmvls	equ	cmopn+1			; operand value pointers (see below)
cmrop	equ	cmvls			; right (only) operator operand
cmlop	equ	cmvls+1			; left operator operand
cmsi_	equ	cmvls			; number of standard fields in cmblk
cmus_	equ	cmsi_+1			; size of unary operator cmblk
cmbs_	equ	cmsi_+2			; size of binary operator cmblk
cmar1	equ	cmvls+1			; array subscript pointers
;
;      the cmopn and cmvls fields are set as follows
;
;      array reference	     cmopn = ptr to array operand
;			     cmvls = ptrs to subscript operands
;
;      function call	     cmopn = ptr to vrblk for function
;			     cmvls = ptrs to argument operands
;
;      selection	     cmopn = zero
;			     cmvls = ptrs to alternate operands
;
;      unary operator	     cmopn = ptr to operator dvblk
;			     cmrop = ptr to operand
;
;      binary operator	     cmopn = ptr to operator dvblk
;			     cmrop = ptr to right operand
;			     cmlop = ptr to left operand
	ejc
;
;      cmtyp is set to indicate the type of expression element
;      as shown by the following table of definitions.
;
c_arr	equ	0			; array reference
c_fnc	equ	c_arr+1			; function call
c_def	equ	c_fnc+1			; deferred expression (unary *)
c_ind	equ	c_def+1			; indirection (unary _)
c_key	equ	c_ind+1			; keyword reference (unary ampersand)
c_ubo	equ	c_key+1			; undefined binary operator
c_uuo	equ	c_ubo+1			; undefined unary operator
c_uo_	equ	c_uuo+1			; test value (=c_uuo+1=c_ubo+2)
c__nm	equ	c_uuo+1			; number of codes for name operands
;
;      the remaining types indicate expression elements which
;      can only be evaluated by value (not by name).
;
c_bvl	equ	c_uuo+1			; binary op with value operands
c_uvl	equ	c_bvl+1			; unary operator with value operand
c_alt	equ	c_uvl+1			; alternation (binary bar)
c_cnc	equ	c_alt+1			; concatenation
c_cnp	equ	c_cnc+1			; concatenation, not pattern match
c_unm	equ	c_cnp+1			; unary op with name operand
c_bvn	equ	c_unm+1			; binary op (operands by value, name)
c_ass	equ	c_bvn+1			; assignment
c_int	equ	c_ass+1			; interrogation
c_neg	equ	c_int+1			; negation (unary not)
c_sel	equ	c_neg+1			; selection
c_pmt	equ	c_sel+1			; pattern match
;
c_pr_	equ	c_bvn			; last preevaluable code
c__nv	equ	c_pmt+1			; number of different cmblk types
	ejc
;
;      character table block (ctblk)
;
;      a character table block is used to hold logical character
;      tables for use with any,notany,span,break,breakx
;      patterns. each character table can be used to store
;      cfp_n distinct tables as bit columns. a bit column
;      allocated for each argument of more than one character
;      in length to one of the above listed pattern primitives.
;
;	    +------------------------------------+
;	    i		     cttyp		 i
;	    +------------------------------------+
;	    *					 *
;	    *					 *
;	    *		     ctchs		 *
;	    *					 *
;	    *					 *
;	    +------------------------------------+
;
cttyp	equ	0			; pointer to dummy routine b_ctt
ctchs	equ	cttyp+1			; start of character table words
ctsi_	equ	ctchs+cfp_a		; number of words in ctblk
;
;      ctchs is cfp_a words long and consists of a one word
;      bit string value for each possible character in the
;      internal alphabet. each of the cfp_n possible bits in
;      a bitstring is used to form a column of bit indicators.
;      a bit is set on if the character is in the table and off
;      if the character is not present.
	ejc
;
;      datatype function block (dfblk)
;
;      a datatype function is used to control the construction
;      of a program defined datatype object. a call to the
;      system function data builds a dfblk for the datatype name
;
;      note that these blocks are built in static because pdblk
;      length is got from dflen field.	if dfblk was in dynamic
;      store this would cause trouble during pass two of garbage
;      collection.  scblk referred to by dfnam field is also put
;      in static so that there are no reloc. fields. this cuts
;      garbage collection task appreciably for pdblks which are
;      likely to be present in large numbers.
;
;	    +------------------------------------+
;	    i		     fcode		 i
;	    +------------------------------------+
;	    i		     fargs		 i
;	    +------------------------------------+
;	    i		     dflen		 i
;	    +------------------------------------+
;	    i		     dfpdl		 i
;	    +------------------------------------+
;	    i		     dfnam		 i
;	    +------------------------------------+
;	    /					 /
;	    /		     dffld		 /
;	    /					 /
;	    +------------------------------------+
;
dflen	equ	fargs+1			; length of dfblk in bytes
dfpdl	equ	dflen+1			; length of corresponding pdblk
dfnam	equ	dfpdl+1			; pointer to scblk for datatype name
dffld	equ	dfnam+1			; start of vrblk ptrs for field names
dfflb	equ	dffld-1			; offset behind dffld for field func
dfsi_	equ	dffld			; number of standard fields in dfblk
;
;      the fcode field points to the routine b_dfc
;
;      fargs (the number of arguments) is the number of fields.
	ejc
;
;      dope vector block (dvblk)
;
;      a dope vector is assembled for each possible operator in
;      the snobol4 language as part of the constant section.
;
;	    +------------------------------------+
;	    i		     dvopn		 i
;	    +------------------------------------+
;	    i		     dvtyp		 i
;	    +------------------------------------+
;	    i		     dvlpr		 i
;	    +------------------------------------+
;	    i		     dvrpr		 i
;	    +------------------------------------+
;
dvopn	equ	0			; entry address (ptr to o_xxx)
dvtyp	equ	dvopn+1			; type code (c_xxx, see cmblk)
dvlpr	equ	dvtyp+1			; left precedence (llxxx, see below)
dvrpr	equ	dvlpr+1			; right precedence (rrxxx, see below)
dvus_	equ	dvlpr+1			; size of unary operator dv
dvbs_	equ	dvrpr+1			; size of binary operator dv
dvubs	equ	dvus_+dvbs_		; size of unop + binop (see scane)
;
;      the contents of the dvtyp field is copied into the cmtyp
;      field of the cmblk for the operator if it is used.
;
;      the cmopn field of an operator cmblk points to the dvblk
;      itself, providing the required entry address pointer ptr.
;
;      for normally undefined operators, the dvopn (and cmopn)
;      fields contain a word offset from r_uba of the function
;      block pointer for the operator (instead of o_xxx ptr).
;      for certain special operators, the dvopn field is not
;      required at all and is assembled as zero.
;
;      the left precedence is used in comparing an operator to
;      the left of some other operator. it therefore governs the
;      precedence of the operator towards its right operand.
;
;      the right precedence is used in comparing an operator to
;      the right of some other operator. it therefore governs
;      the precedence of the operator towards its left operand.
;
;      higher precedence values correspond to a tighter binding
;      capability. thus we have the left precedence lower
;      (higher) than the right precedence for right (left)
;      associative binary operators.
;
;      the left precedence of unary operators is set to an
;      arbitrary high value. the right value is not required and
;      consequently the dvrpr field is omitted for unary ops.
	ejc
;
;      table of operator precedence values
;
rrass	equ	10			; right	    equal
llass	equ	00			; left	    equal
rrpmt	equ	20			; right	    question mark
llpmt	equ	30			; left	    question mark
rramp	equ	40			; right	    ampersand
llamp	equ	50			; left	    ampersand
rralt	equ	70			; right	    vertical bar
llalt	equ	60			; left	    vertical bar
rrcnc	equ	90			; right	    blank
llcnc	equ	80			; left	    blank
rrats	equ	110			; right	    at
llats	equ	100			; left	    at
rrplm	equ	120			; right	    plus, minus
llplm	equ	130			; left	    plus, minus
rrnum	equ	140			; right	    number
llnum	equ	150			; left	    number
rrdvd	equ	160			; right	    slash
lldvd	equ	170			; left	    slash
rrmlt	equ	180			; right	    asterisk
llmlt	equ	190			; left	    asterisk
rrpct	equ	200			; right	    percent
llpct	equ	210			; left	    percent
rrexp	equ	230			; right	    exclamation
llexp	equ	220			; left	    exclamation
rrdld	equ	240			; right	    dollar, dot
lldld	equ	250			; left	    dollar, dot
rrnot	equ	270			; right	    not
llnot	equ	260			; left	    not
lluno	equ	999			; left	    all unary operators
;
;      precedences are the same as in btl snobol4 with the
;      following exceptions.
;
;      1)   binary question mark is lowered and made left assoc-
;	    iative to reflect its new use for pattern matching.
;
;      2)   alternation and concatenation are made right
;	    associative for greater efficiency in pattern
;	    construction and matching respectively. this change
;	    is transparent to the snobol4 programmer.
;
;      3)   the equal sign has been added as a low precedence
;	    operator which is right associative to reflect its
;	    more general usage in this version of snobol4.
	ejc
;
;      external function block (efblk)
;
;      an external function block is used to control the calling
;      of an external function. it is built by a call to load.
;
;	    +------------------------------------+
;	    i		     fcode		 i
;	    +------------------------------------+
;	    i		     fargs		 i
;	    +------------------------------------+
;	    i		     eflen		 i
;	    +------------------------------------+
;	    i		     efuse		 i
;	    +------------------------------------+
;	    i		     efcod		 i
;	    +------------------------------------+
;	    i		     efvar		 i
;	    +------------------------------------+
;	    i		     efrsl		 i
;	    +------------------------------------+
;	    /					 /
;	    /		     eftar		 /
;	    /					 /
;	    +------------------------------------+
;
eflen	equ	fargs+1			; length of efblk in bytes
efuse	equ	eflen+1			; use count (for opsyn)
efcod	equ	efuse+1			; ptr to code (from sysld)
efvar	equ	efcod+1			; ptr to associated vrblk
efrsl	equ	efvar+1			; result type (see below)
eftar	equ	efrsl+1			; argument types (see below)
efsi_	equ	eftar			; number of standard fields in efblk
;
;      the fcode field points to the routine b_efc.
;
;      efuse is used to keep track of multiple use when opsyn
;      is employed. the function is automatically unloaded
;      when there are no more references to the function.
;
;      efrsl and eftar are type codes as follows.
;
;	    0		     type is unconverted
;	    1		     type is string
;	    2		     type is integer
.if    .cnra
.if    .cnlf
;	    3		     type is file
.fi
.else
;	    3		     type is real
.if    .cnlf
;	    4		     type is file
.fi
.fi
	ejc
;
;      expression variable block (evblk)
;
;      in this version of spitbol, an expression can be used in
;      any position which would normally expect a name (for
;      example on the left side of equals or as the right
;      argument of binary dot). this corresponds to the creation
;      of a pseudo-variable which is represented by a pointer to
;      an expression variable block as follows.
;
;	    +------------------------------------+
;	    i		     evtyp		 i
;	    +------------------------------------+
;	    i		     evexp		 i
;	    +------------------------------------+
;	    i		     evvar		 i
;	    +------------------------------------+
;
evtyp	equ	0			; pointer to dummy routine b_evt
evexp	equ	evtyp+1			; pointer to exblk for expression
evvar	equ	evexp+1			; pointer to trbev dummy trblk
evsi_	equ	evvar+1			; size of evblk
;
;      the name of an expression variable is represented by a
;      base pointer to the evblk and an offset of evvar. this
;      value appears to be trapped by the dummy trbev block.
;
;      note that there is no need to allow for the case of an
;      expression variable which references an seblk since a
;      variable which is of the form *var is equivalent to var.
	ejc
;
;      expression block (exblk)
;
;      an expression block is built for each expression
;      referenced in a program or created by eval or convert
;      during execution of a program.
;
;	    +------------------------------------+
;	    i		     extyp		 i
;	    +------------------------------------+
;	    i		     exstm		 i
.if    .csln
;	    +------------------------------------+
;	    i		     exsln		 i
.fi
;	    +------------------------------------+
;	    i		     exlen		 i
;	    +------------------------------------+
;	    i		     exflc		 i
;	    +------------------------------------+
;	    /					 /
;	    /		     excod		 /
;	    /					 /
;	    +------------------------------------+
;
extyp	equ	0			; ptr to routine b_exl to load expr
exstm	equ	cdstm			; stores stmnt no. during evaluation
.if    .csln
exsln	equ	exstm+1			; stores line no. during evaluation
exlen	equ	exsln+1			; length of exblk in bytes
.else
exlen	equ	exstm+1			; length of exblk in bytes
.fi
exflc	equ	exlen+1			; failure code (=o_fex)
excod	equ	exflc+1			; pseudo-code for expression
exsi_	equ	excod			; number of standard fields in exblk
;
;      there are two cases for excod depending on whether the
;      expression can be evaluated by name (see description
;      of cdblk for details of code for expressions).
;
;      if the expression can be evaluated by name we have.
;
;			     (code for expr by name)
;			     =o_rnm
;
;      if the expression can only be evaluated by value.
;
;			     (code for expr by value)
;			     =o_rvl
	ejc
;
;      field function block (ffblk)
;
;      a field function block is used to control the selection
;      of a field from a program defined datatype block.
;      a call to data creates an ffblk for each field.
;
;	    +------------------------------------+
;	    i		     fcode		 i
;	    +------------------------------------+
;	    i		     fargs		 i
;	    +------------------------------------+
;	    i		     ffdfp		 i
;	    +------------------------------------+
;	    i		     ffnxt		 i
;	    +------------------------------------+
;	    i		     ffofs		 i
;	    +------------------------------------+
;
ffdfp	equ	fargs+1			; pointer to associated dfblk
ffnxt	equ	ffdfp+1			; ptr to next ffblk on chain or zero
ffofs	equ	ffnxt+1			; offset (bytes) to field in pdblk
ffsi_	equ	ffofs+1			; size of ffblk in words
;
;      the fcode field points to the routine b_ffc.
;
;      fargs always contains one.
;
;      ffdfp is used to verify that the correct program defined
;      datatype is being accessed by this call.
;      ffdfp is non-reloc. because dfblk is in static
;
;      ffofs is used to select the appropriate field. note that
;      it is an actual offset (not a field number)
;
;      ffnxt is used to point to the next ffblk of the same name
;      in the case where there are several fields of the same
;      name for different datatypes. zero marks the end of chain
	ejc
;
;      integer constant block (icblk)
;
;      an icblk is created for every integer referenced or
;      created by a program. note however that certain internal
;      integer values are stored as addresses (e.g. the length
;      field in a string constant block)
;
;	    +------------------------------------+
;	    i		     icget		 i
;	    +------------------------------------+
;	    *		     icval		 *
;	    +------------------------------------+
;
icget	equ	0			; ptr to routine b_icl to load int
icval	equ	icget+1			; integer value
icsi_	equ	icval+cfp_i		; size of icblk
;
;      the length of the icval field is cfp_i.
	ejc
;
;      keyword variable block (kvblk)
;
;      a kvblk is used to represent a keyword pseudo-variable.
;      a kvblk is built for each keyword reference (kwnam).
;
;	    +------------------------------------+
;	    i		     kvtyp		 i
;	    +------------------------------------+
;	    i		     kvvar		 i
;	    +------------------------------------+
;	    i		     kvnum		 i
;	    +------------------------------------+
;
kvtyp	equ	0			; pointer to dummy routine b_kvt
kvvar	equ	kvtyp+1			; pointer to dummy block trbkv
kvnum	equ	kvvar+1			; keyword number
kvsi_	equ	kvnum+1			; size of kvblk
;
;      the name of a keyword variable is represented by a
;      base pointer to the kvblk and an offset of kvvar. the
;      value appears to be trapped by the pointer to trbkv.
	ejc
;
;      name block (nmblk)
;
;      a name block is used wherever a name must be stored as
;      a value following use of the unary dot operator.
;
;	    +------------------------------------+
;	    i		     nmtyp		 i
;	    +------------------------------------+
;	    i		     nmbas		 i
;	    +------------------------------------+
;	    i		     nmofs		 i
;	    +------------------------------------+
;
nmtyp	equ	0			; ptr to routine b_nml to load name
nmbas	equ	nmtyp+1			; base pointer for variable
nmofs	equ	nmbas+1			; offset for variable
nmsi_	equ	nmofs+1			; size of nmblk
;
;      the actual field representing the contents of the name
;      is found nmofs bytes past the address in nmbas.
;
;      the name is split into base and offset form to avoid
;      creation of a pointer into the middle of a block which
;      could not be handled properly by the garbage collector.
;
;      a name may be built for any variable (see section on
;      representations of variables) this includes the
;      cases of pseudo-variables.
	ejc
;
;      pattern block, no parameters (p0blk)
;
;      a p0blk is used to represent pattern nodes which do
;      not require the use of any parameter values.
;
;	    +------------------------------------+
;	    i		     pcode		 i
;	    +------------------------------------+
;	    i		     pthen		 i
;	    +------------------------------------+
;
pcode	equ	0			; ptr to match routine (p_xxx)
pthen	equ	pcode+1			; pointer to subsequent node
pasi_	equ	pthen+1			; size of p0blk
;
;      pthen points to the pattern block for the subsequent
;      node to be matched. this is a pointer to the pattern
;      block ndnth if there is no subsequent (end of pattern)
;
;      pcode is a pointer to the match routine for the node.
	ejc
;
;      pattern block (one parameter)
;
;      a p1blk is used to represent pattern nodes which
;      require one parameter value.
;
;	    +------------------------------------+
;	    i		     pcode		 i
;	    +------------------------------------+
;	    i		     pthen		 i
;	    +------------------------------------+
;	    i		     parm1		 i
;	    +------------------------------------+
;
parm1	equ	pthen+1			; first parameter value
pbsi_	equ	parm1+1			; size of p1blk in words
;
;      see p0blk for definitions of pcode, pthen
;
;      parm1 contains a parameter value used in matching the
;      node. for example, in a len pattern, it is the integer
;      argument to len. the details of the use of the parameter
;      field are included in the description of the individual
;      match routines. parm1 is always an address pointer which
;      is processed by the garbage collector.
	ejc
;
;      pattern block (two parameters)
;
;      a p2blk is used to represent pattern nodes which
;      require two parameter values.
;
;	    +------------------------------------+
;	    i		     pcode		 i
;	    +------------------------------------+
;	    i		     pthen		 i
;	    +------------------------------------+
;	    i		     parm1		 i
;	    +------------------------------------+
;	    i		     parm2		 i
;	    +------------------------------------+
;
parm2	equ	parm1+1			; second parameter value
pcsi_	equ	parm2+1			; size of p2blk in words
;
;      see p1blk for definitions of pcode, pthen, parm1
;
;      parm2 is a parameter which performs the same sort of
;      function as parm1 (see description of p1blk).
;
;      parm2 is a non-relocatable field and is not
;      processed by the garbage collector. accordingly, it may
;      not contain a pointer to a block in dynamic memory.
	ejc
;
;      program-defined datatype block
;
;      a pdblk represents the data item formed by a call to a
;      datatype function as defined by the system function data.
;
;	    +------------------------------------+
;	    i		     pdtyp		 i
;	    +------------------------------------+
;	    i		     idval		 i
;	    +------------------------------------+
;	    i		     pddfp		 i
;	    +------------------------------------+
;	    /					 /
;	    /		     pdfld		 /
;	    /					 /
;	    +------------------------------------+
;
pdtyp	equ	0			; ptr to dummy routine b_pdt
pddfp	equ	idval+1			; ptr to associated dfblk
pdfld	equ	pddfp+1			; start of field value pointers
pdfof	equ	dffld-pdfld		; difference in offset to field ptrs
pdsi_	equ	pdfld			; size of standard fields in pdblk
pddfs	equ	dfsi_-pdsi_		; difference in dfblk, pdblk sizes
;
;      the pddfp pointer may be used to determine the datatype
;      and the names of the fields if required. the dfblk also
;      contains the length of the pdblk in bytes (field dfpdl).
;      pddfp is non-reloc. because dfblk is in static
;
;      pdfld values are stored in order from left to right.
;      they contain values or pointers to trblk chains.
	ejc
;
;      program defined function block (pfblk)
;
;      a pfblk is created for each call to the define function
;      and a pointer to the pfblk placed in the proper vrblk.
;
;	    +------------------------------------+
;	    i		     fcode		 i
;	    +------------------------------------+
;	    i		     fargs		 i
;	    +------------------------------------+
;	    i		     pflen		 i
;	    +------------------------------------+
;	    i		     pfvbl		 i
;	    +------------------------------------+
;	    i		     pfnlo		 i
;	    +------------------------------------+
;	    i		     pfcod		 i
;	    +------------------------------------+
;	    i		     pfctr		 i
;	    +------------------------------------+
;	    i		     pfrtr		 i
;	    +------------------------------------+
;	    /					 /
;	    /		     pfarg		 /
;	    /					 /
;	    +------------------------------------+
;
pflen	equ	fargs+1			; length of pfblk in bytes
pfvbl	equ	pflen+1			; pointer to vrblk for function name
pfnlo	equ	pfvbl+1			; number of locals
pfcod	equ	pfnlo+1			; ptr to vrblk for entry label
pfctr	equ	pfcod+1			; trblk ptr if call traced else 0
pfrtr	equ	pfctr+1			; trblk ptr if return traced else 0
pfarg	equ	pfrtr+1			; vrblk ptrs for arguments and locals
pfagb	equ	pfarg-1			; offset behind pfarg for arg, local
pfsi_	equ	pfarg			; number of standard fields in pfblk
;
;      the fcode field points to the routine b_pfc.
;
;      pfarg is stored in the following order.
;
;	    arguments (left to right)
;	    locals (left to right)
.if    .cnra
.else
	ejc
;
;      real constant block (rcblk)
;
;      an rcblk is created for every real referenced or
;      created by a program.
;
;	    +------------------------------------+
;	    i		     rcget		 i
;	    +------------------------------------+
;	    *		     rcval		 *
;	    +------------------------------------+
;
rcget	equ	0			; ptr to routine b_rcl to load real
rcval	equ	rcget+1			; real value
rcsi_	equ	rcval+cfp_r		; size of rcblk
;
;      the length of the rcval field is cfp_r.
.fi
	ejc
;
;      string constant block (scblk)
;
;      an scblk is built for every string referenced or created
;      by a program.
;
;	    +------------------------------------+
;	    i		     scget		 i
;	    +------------------------------------+
;	    i		     sclen		 i
;	    +------------------------------------+
;	    /					 /
;	    /		     schar		 /
;	    /					 /
;	    +------------------------------------+
;
scget	equ	0			; ptr to routine b_scl to load string
sclen	equ	scget+1			; length of string in characters
schar	equ	sclen+1			; characters of string
scsi_	equ	schar			; size of standard fields in scblk
;
;      the characters of the string are stored left justified.
;      the final word is padded on the right with zeros.
;      (i.e. the character whose internal code is zero).
;
;      the value of sclen may not exceed mxlen. this ensures
;      that character offsets (e.g. the pattern match cursor)
;      can be correctly processed by the garbage collector.
;
;      note that the offset to the characters of the string
;      is given in bytes by cfp_f and that this value is
;      automatically allowed for in plc, psc.
;      note that for a spitbol scblk, the value of cfp_f
;      is given by cfp_b*schar.
	ejc
;
;      simple expression block (seblk)
;
;      an seblk is used to represent an expression of the form
;      *(natural variable). all other expressions are exblks.
;
;	    +------------------------------------+
;	    i		     setyp		 i
;	    +------------------------------------+
;	    i		     sevar		 i
;	    +------------------------------------+
;
setyp	equ	0			; ptr to routine b_sel to load expr
sevar	equ	setyp+1			; ptr to vrblk for variable
sesi_	equ	sevar+1			; length of seblk in words
	ejc
;
;      standard variable block (svblk)
;
;      an svblk is assembled in the constant section for each
;      variable which satisfies one of the following conditions.
;
;      1)   it is the name of a system function
;      2)   it has an initial value
;      3)   it has a keyword association
;      4)   it has a standard i/o association
;      6)   it has a standard label association
;
;      if vrblks are constructed for any of these variables,
;      then the vrsvp field points to the svblk (see vrblk)
;
;	    +------------------------------------+
;	    i		     svbit		 i
;	    +------------------------------------+
;	    i		     svlen		 i
;	    +------------------------------------+
;	    /		     svchs		 /
;	    +------------------------------------+
;	    i		     svknm		 i
;	    +------------------------------------+
;	    i		     svfnc		 i
;	    +------------------------------------+
;	    i		     svnar		 i
;	    +------------------------------------+
;	    i		     svlbl		 i
;	    +------------------------------------+
;	    i		     svval		 i
;	    +------------------------------------+
	ejc
;
;      standard variable block (continued)
;
svbit	equ	0			; bit string indicating attributes
svlen	equ	1			; (=sclen) length of name in chars
svchs	equ	2			; (=schar) characters of name
svsi_	equ	2			; number of standard fields in svblk
svpre	equ	1			; set if preevaluation permitted
svffc	equ	svpre+svpre		; set on if fast call permitted
svckw	equ	svffc+svffc		; set on if keyword value constant
svprd	equ	svckw+svckw		; set on if predicate function
svnbt	equ	4			; number of bits to right of svknm
svknm	equ	svprd+svprd		; set on if keyword association
svfnc	equ	svknm+svknm		; set on if system function
svnar	equ	svfnc+svfnc		; set on if system function
svlbl	equ	svnar+svnar		; set on if system label
svval	equ	svlbl+svlbl		; set on if predefined value
;
;      note that the last five bits correspond in order
;      to the fields which are present (see procedure gtnvr).
;
;      the following definitions are used in the svblk table
;
svfnf	equ	svfnc+svnar		; function with no fast call
svfnn	equ	svfnf+svffc		; function with fast call, no preeval
svfnp	equ	svfnn+svpre		; function allowing preevaluation
svfpr	equ	svfnn+svprd		; predicate function
svfnk	equ	svfnn+svknm		; no preeval func + keyword
svkwv	equ	svknm+svval		; keyword + value
svkwc	equ	svckw+svknm		; keyword with constant value
svkvc	equ	svkwv+svckw		; constant keyword + value
svkvl	equ	svkvc+svlbl		; constant keyword + value + label
svfpk	equ	svfnp+svkvc		; preeval fcn + const keywd + val
;
;      the svpre bit allows the compiler to preevaluate a call
;      to the associated system function if all the arguments
;      are themselves constants. functions in this category
;      must have no side effects and must never cause failure.
;      the call may generate an error condition.
;
;      the svffc bit allows the compiler to generate the special
;      fast call after adjusting the number of arguments. only
;      the item and apply functions fall outside this category.
;
;      the svckw bit is set if the associated keyword value is
;      a constant, thus allowing preevaluation for a value call.
;
;      the svprd bit is set on for all predicate functions to
;      enable the special concatenation code optimization.
	ejc
;
;      svblk (continued)
;
;      svknm		     keyword number
;
;	    svknm is present only for a standard keyword assoc.
;	    it contains a keyword number as defined by the
;	    keyword number table given later on.
;
;      svfnc		     system function pointer
;
;	    svfnc is present only for a system function assoc.
;	    it is a pointer to the actual code for the system
;	    function. the generated code for a fast call is a
;	    pointer to the svfnc field of the svblk for the
;	    function. the vrfnc field of the vrblk points to
;	    this same field, in which case, it serves as the
;	    fcode field for the function call.
;
;      svnar		     number of function arguments
;
;	    svnar is present only for a system function assoc.
;	    it is the number of arguments required for a call
;	    to the system function. the compiler uses this
;	    value to adjust the number of arguments in a fast
;	    call and in the case of a function called through
;	    the vrfnc field of the vrblk, the svnar field
;	    serves as the fargs field for o_fnc. a special
;	    case occurs if this value is set to 999. this is
;	    used to indicate that the function has a variable
;	    number of arguments and causes o_fnc to pass control
;	    without adjusting the argument count. the only
;	    predefined functions using this are apply and item.
;
;      svlbl		     system label pointer
;
;	    svlbl is present only for a standard label assoc.
;	    it is a pointer to a system label routine (l_xxx).
;	    the vrlbl field of the corresponding vrblk points to
;	    the svlbl field of the svblk.
;
;      svval		     system value pointer
;
;	    svval is present only for a standard value.
;	    it is a pointer to the pattern node (ndxxx) which
;	    is the standard initial value of the variable.
;	    this value is copied to the vrval field of the vrblk
	ejc
;
;      svblk (continued)
;
;      keyword number table
;
;      the following table gives symbolic names for keyword
;      numbers. these values are stored in the svknm field of
;      svblks and in the kvnum field of kvblks. see also
;      procedures asign, acess and kwnam.
;
;      unprotected keywords with one word integer values
;
k_abe	equ	0			; abend
k_anc	equ	k_abe+cfp_b		; anchor
.if    .culc
k_cas	equ	k_anc+cfp_b		; case
k_cod	equ	k_cas+cfp_b		; code
.else
k_cod	equ	k_anc+cfp_b		; code
.fi
.if    .ccmk
k_com	equ	k_cod+cfp_b		; compare
k_dmp	equ	k_com+cfp_b		; dump
.else
k_dmp	equ	k_cod+cfp_b		; dump
.fi
k_erl	equ	k_dmp+cfp_b		; errlimit
k_ert	equ	k_erl+cfp_b		; errtype
k_ftr	equ	k_ert+cfp_b		; ftrace
k_fls	equ	k_ftr+cfp_b		; fullscan
k_inp	equ	k_fls+cfp_b		; input
k_mxl	equ	k_inp+cfp_b		; maxlength
k_oup	equ	k_mxl+cfp_b		; output
.if    .cnpf
k_tra	equ	k_oup+cfp_b		; trace
.else
k_pfl	equ	k_oup+cfp_b		; profile
k_tra	equ	k_pfl+cfp_b		; trace
.fi
k_trm	equ	k_tra+cfp_b		; trim
;
;      protected keywords with one word integer values
;
k_fnc	equ	k_trm+cfp_b		; fnclevel
k_lst	equ	k_fnc+cfp_b		; lastno
.if    .csln
k_lln	equ	k_lst+cfp_b		; lastline
k_lin	equ	k_lln+cfp_b		; line
k_stn	equ	k_lin+cfp_b		; stno
.else
k_stn	equ	k_lst+cfp_b		; stno
.fi
;
;      keywords with constant pattern values
;
k_abo	equ	k_stn+cfp_b		; abort
k_arb	equ	k_abo+pasi_		; arb
k_bal	equ	k_arb+pasi_		; bal
k_fal	equ	k_bal+pasi_		; fail
k_fen	equ	k_fal+pasi_		; fence
k_rem	equ	k_fen+pasi_		; rem
k_suc	equ	k_rem+pasi_		; succeed
	ejc
;
;      keyword number table (continued)
;
;      special keywords
;
k_alp	equ	k_suc+1			; alphabet
k_rtn	equ	k_alp+1			; rtntype
k_stc	equ	k_rtn+1			; stcount
k_etx	equ	k_stc+1			; errtext
.if    .csfn
k_fil	equ	k_etx+1			; file
k_lfl	equ	k_fil+1			; lastfile
k_stl	equ	k_lfl+1			; stlimit
.else
k_stl	equ	k_etx+1			; stlimit
.fi
.if    .culk
k_lcs	equ	k_stl+1			; lcase
k_ucs	equ	k_lcs+1			; ucase
.fi
;
;      relative offsets of special keywords
;
k__al	equ	k_alp-k_alp		; alphabet
k__rt	equ	k_rtn-k_alp		; rtntype
k__sc	equ	k_stc-k_alp		; stcount
k__et	equ	k_etx-k_alp		; errtext
.if    .csfn
k__fl	equ	k_fil-k_alp		; file
k__lf	equ	k_lfl-k_alp		; lastfile
.fi
k__sl	equ	k_stl-k_alp		; stlimit
.if    .culk
k__lc	equ	k_lcs-k_alp		; lcase
k__uc	equ	k_ucs-k_alp		; ucase
k__n_	equ	k__uc+1			; number of special cases
.else
k__n_	equ	k__sl+1			; number of special cases
.fi
;
;      symbols used in asign and acess procedures
;
k_p__	equ	k_fnc			; first protected keyword
k_v__	equ	k_abo			; first keyword with constant value
k_s__	equ	k_alp			; first keyword with special acess
	ejc
;
;      format of a table block (tbblk)
;
;      a table block is used to represent a table value.
;      it is built by a call to the table or convert functions.
;
;	    +------------------------------------+
;	    i		     tbtyp		 i
;	    +------------------------------------+
;	    i		     idval		 i
;	    +------------------------------------+
;	    i		     tblen		 i
;	    +------------------------------------+
;	    i		     tbinv		 i
;	    +------------------------------------+
;	    /					 /
;	    /		     tbbuk		 /
;	    /					 /
;	    +------------------------------------+
;
tbtyp	equ	0			; pointer to dummy routine b_tbt
tblen	equ	offs2			; length of tbblk in bytes
tbinv	equ	offs3			; default initial lookup value
tbbuk	equ	tbinv+1			; start of hash bucket pointers
tbsi_	equ	tbbuk			; size of standard fields in tbblk
tbnbk	equ	11			; default no. of buckets
;
;      the table block is a hash table which points to chains
;      of table element blocks representing the elements
;      in the table which hash into the same bucket.
;
;      tbbuk entries either point to the first teblk on the
;      chain or they point to the tbblk itself to indicate the
;      end of the chain.
	ejc
;
;      table element block (teblk)
;
;      a table element is used to represent a single entry in
;      a table (see description of tbblk format for hash table)
;
;	    +------------------------------------+
;	    i		     tetyp		 i
;	    +------------------------------------+
;	    i		     tesub		 i
;	    +------------------------------------+
;	    i		     teval		 i
;	    +------------------------------------+
;	    i		     tenxt		 i
;	    +------------------------------------+
;
tetyp	equ	0			; pointer to dummy routine b_tet
tesub	equ	tetyp+1			; subscript value
teval	equ	tesub+1			; (=vrval) table element value
tenxt	equ	teval+1			; link to next teblk
;      see s_cnv where relation is assumed with tenxt and tbbuk
tesi_	equ	tenxt+1			; size of teblk in words
;
;      tenxt points to the next teblk on the hash chain from the
;      tbbuk chain for this hash index. at the end of the chain,
;      tenxt points back to the start of the tbblk.
;
;      teval contains a data pointer or a trblk pointer.
;
;      tesub contains a data pointer.
	ejc
;
;      trap block (trblk)
;
;      a trap block is used to represent a trace or input or
;      output association in response to a call to the trace
;      input or output system functions. see below for details
;
;	    +------------------------------------+
;	    i		     tridn		 i
;	    +------------------------------------+
;	    i		     trtyp		 i
;	    +------------------------------------+
;	    i  trval or trlbl or trnxt or trkvr	 i
;	    +------------------------------------+
;	    i	    trtag or trter or trtrf	 i
;	    +------------------------------------+
;	    i		 trfnc or trfpt		 i
;	    +------------------------------------+
;
tridn	equ	0			; pointer to dummy routine b_trt
trtyp	equ	tridn+1			; trap type code
trval	equ	trtyp+1			; value of trapped variable (=vrval)
trnxt	equ	trval			; ptr to next trblk on trblk chain
trlbl	equ	trval			; ptr to actual label (traced label)
trkvr	equ	trval			; vrblk pointer for keyword trace
trtag	equ	trval+1			; trace tag
trter	equ	trtag			; ptr to terminal vrblk or null
trtrf	equ	trtag			; ptr to trblk holding fcblk ptr
trfnc	equ	trtag+1			; trace function vrblk (zero if none)
trfpt	equ	trfnc			; fcblk ptr for sysio
trsi_	equ	trfnc+1			; number of words in trblk
;
trtin	equ	0			; trace type for input association
trtac	equ	trtin+1			; trace type for access trace
trtvl	equ	trtac+1			; trace type for value trace
trtou	equ	trtvl+1			; trace type for output association
trtfc	equ	trtou+1			; trace type for fcblk identification
	ejc
;
;      trap block (continued)
;
;      variable input association
;
;	    the value field of the variable points to a trblk
;	    instead of containing the data value. in the case
;	    of a natural variable, the vrget and vrsto fields
;	    contain =b_vra and =b_vrv to activate the check.
;
;	    trtyp is set to trtin
;	    trnxt points to next trblk or trval has variable val
;	    trter is a pointer to svblk if association is
;	    for input, terminal, else it is null.
;	    trtrf points to the trap block which in turn points
;	    to an fcblk used for i/o association.
;	    trfpt is the fcblk ptr returned by sysio.
;
;      variable access trace association
;
;	    the value field of the variable points to a trblk
;	    instead of containing the data value. in the case
;	    of a natural variable, the vrget and vrsto fields
;	    contain =b_vra and =b_vrv to activate the check.
;
;	    trtyp is set to trtac
;	    trnxt points to next trblk or trval has variable val
;	    trtag is the trace tag (0 if none)
;	    trfnc is the trace function vrblk ptr (0 if none)
;
;      variable value trace association
;
;	    the value field of the variable points to a trblk
;	    instead of containing the data value. in the case
;	    of a natural variable, the vrget and vrsto fields
;	    contain =b_vra and =b_vrv to activate the check.
;
;	    trtyp is set to trtvl
;	    trnxt points to next trblk or trval has variable val
;	    trtag is the trace tag (0 if none)
;	    trfnc is the trace function vrblk ptr (0 if none)
	ejc
;      trap block (continued)
;
;      variable output association
;
;	    the value field of the variable points to a trblk
;	    instead of containing the data value. in the case
;	    of a natural variable, the vrget and vrsto fields
;	    contain =b_vra and =b_vrv to activate the check.
;
;	    trtyp is set to trtou
;	    trnxt points to next trblk or trval has variable val
;	    trter is a pointer to svblk if association is
;	    for output, terminal, else it is null.
;	    trtrf points to the trap block which in turn points
;	    to an fcblk used for i/o association.
;	    trfpt is the fcblk ptr returned by sysio.
;
;      function call trace
;
;	    the pfctr field of the corresponding pfblk is set
;	    to point to a trblk.
;
;	    trtyp is set to trtin
;	    trnxt is zero
;	    trtag is the trace tag (0 if none)
;	    trfnc is the trace function vrblk ptr (0 if none)
;
;      function return trace
;
;	    the pfrtr field of the corresponding pfblk is set
;	    to point to a trblk
;
;	    trtyp is set to trtin
;	    trnxt is zero
;	    trtag is the trace tag (0 if none)
;	    trfnc is the trace function vrblk ptr (0 if none)
;
;      label trace
;
;	    the vrlbl of the vrblk for the label is
;	    changed to point to a trblk and the vrtra field is
;	    set to b_vrt to activate the check.
;
;	    trtyp is set to trtin
;	    trlbl points to the actual label (cdblk) value
;	    trtag is the trace tag (0 if none)
;	    trfnc is the trace function vrblk ptr (0 if none)
	ejc
;
;      trap block (continued)
;
;      keyword trace
;
;	    keywords which can be traced possess a unique
;	    location which is zero if there is no trace and
;	    points to a trblk if there is a trace. the locations
;	    are as follows.
;
;	    r_ert	     errtype
;	    r_fnc	     fnclevel
;	    r_stc	     stcount
;
;	    the format of the trblk is as follows.
;
;	    trtyp is set to trtin
;	    trkvr is a pointer to the vrblk for the keyword
;	    trtag is the trace tag (0 if none)
;	    trfnc is the trace function vrblk ptr (0 if none)
;
;      input/output file arg1 trap block
;
;	    the value field of the variable points to a trblk
;	    instead of containing the data value. in the case of
;	    a natural variable, the vrget and vrsto fields
;	    contain =b_vra and =b_vrv. this trap block is used
;	    to hold a pointer to the fcblk which an
;	    implementation may request to hold information
;	    about a file.
;
;	    trtyp is set to trtfc
;	    trnext points to next trblk or trval is variable val
;	    trfnm is 0
;	    trfpt is the fcblk pointer.
;
;      note that when multiple traps are set on a variable
;      the order is in ascending value of trtyp field.
;
;      input association (if present)
;      access trace (if present)
;      value trace (if present)
;      output association (if present)
;
;      the actual value of the variable is stored in the trval
;      field of the last trblk on the chain.
;
;      this implementation does not permit trace or i/o
;      associations to any of the pseudo-variables.
	ejc
;
;      vector block (vcblk)
;
;      a vcblk is used to represent an array value which has
;      one dimension whose lower bound is one. all other arrays
;      are represented by arblks. a vcblk is created by the
;      system function array (s_arr) when passed an integer arg.
;
;	    +------------------------------------+
;	    i		     vctyp		 i
;	    +------------------------------------+
;	    i		     idval		 i
;	    +------------------------------------+
;	    i		     vclen		 i
;	    +------------------------------------+
;	    i		     vcvls		 i
;	    +------------------------------------+
;
vctyp	equ	0			; pointer to dummy routine b_vct
vclen	equ	offs2			; length of vcblk in bytes
vcvls	equ	offs3			; start of vector values
vcsi_	equ	vcvls			; size of standard fields in vcblk
vcvlb	equ	vcvls-1			; offset one word behind vcvls
vctbd	equ	tbsi_-vcsi_		; difference in sizes - see prtvl
;
;      vcvls are either data pointers or trblk pointers
;
;      the dimension can be deduced from vclen.
	ejc
;
;      variable block (vrblk)
;
;      a variable block is built in the static memory area
;      for every variable referenced or created by a program.
;      the order of fields is assumed in the model vrblk stnvr.
;
;      note that since these blocks only occur in the static
;      region, it is permissible to point to any word in
;      the block and this is used to provide three distinct
;      access points from the generated code as follows.
;
;      1)   point to vrget (first word of vrblk) to load the
;	    value of the variable onto the main stack.
;
;      2)   point to vrsto (second word of vrblk) to store the
;	    top stack element as the value of the variable.
;
;      3)   point to vrtra (fourth word of vrblk) to jump to
;	    the label associated with the variable name.
;
;	    +------------------------------------+
;	    i		     vrget		 i
;	    +------------------------------------+
;	    i		     vrsto		 i
;	    +------------------------------------+
;	    i		     vrval		 i
;	    +------------------------------------+
;	    i		     vrtra		 i
;	    +------------------------------------+
;	    i		     vrlbl		 i
;	    +------------------------------------+
;	    i		     vrfnc		 i
;	    +------------------------------------+
;	    i		     vrnxt		 i
;	    +------------------------------------+
;	    i		     vrlen		 i
;	    +------------------------------------+
;	    /					 /
;	    /		 vrchs = vrsvp		 /
;	    /					 /
;	    +------------------------------------+
	ejc
;
;      variable block (continued)
;
vrget	equ	0			; pointer to routine to load value
vrsto	equ	vrget+1			; pointer to routine to store value
vrval	equ	vrsto+1			; variable value
vrvlo	equ	vrval-vrsto		; offset to value from store field
vrtra	equ	vrval+1			; pointer to routine to jump to label
vrlbl	equ	vrtra+1			; pointer to code for label
vrlbo	equ	vrlbl-vrtra		; offset to label from transfer field
vrfnc	equ	vrlbl+1			; pointer to function block
vrnxt	equ	vrfnc+1			; pointer to next vrblk on hash chain
vrlen	equ	vrnxt+1			; length of name (or zero)
vrchs	equ	vrlen+1			; characters of name (vrlen gt 0)
vrsvp	equ	vrlen+1			; ptr to svblk (vrlen eq 0)
vrsi_	equ	vrchs+1			; number of standard fields in vrblk
vrsof	equ	vrlen-sclen		; offset to dummy scblk for name
vrsvo	equ	vrsvp-vrsof		; pseudo-offset to vrsvp field
;
;      vrget = b_vrl if not input associated or access traced
;      vrget = b_vra if input associated or access traced
;
;      vrsto = b_vrs if not output associated or value traced
;      vrsto = b_vrv if output associated or value traced
;      vrsto = b_vre if value is protected pattern value
;
;      vrval points to the appropriate value unless the
;      variable is i/o/trace associated in which case, vrval
;      points to an appropriate trblk (trap block) chain.
;
;      vrtra = b_vrg if the label is not traced
;      vrtra = b_vrt if the label is traced
;
;      vrlbl points to a cdblk if there is a label
;      vrlbl points to the svblk svlbl field for a system label
;      vrlbl points to stndl for an undefined label
;      vrlbl points to a trblk if the label is traced
;
;      vrfnc points to a ffblk for a field function
;      vrfnc points to a dfblk for a datatype function
;      vrfnc points to a pfblk for a program defined function
;      vrfnc points to a efblk for an external loaded function
;      vrfnc points to svfnc (svblk) for a system function
;      vrfnc points to stndf if the function is undefined
;
;      vrnxt points to the next vrblk on this chain unless
;      this is the end of the chain in which case it is zero.
;
;      vrlen is the name length for a non-system variable.
;      vrlen is zero for a system variable.
;
;      vrchs is the name (ljrz) if vrlen is non-zero.
;      vrsvp is a ptr to the svblk if vrlen is zero.
	ejc
;
;      format of a non-relocatable external block (xnblk)
;
;      an xnblk is a block representing an unknown (external)
;      data value. the block contains no pointers to other
;      relocatable blocks. an xnblk is used by external function
;      processing or possibly for system i/o routines etc.
;      the macro-system itself does not use xnblks.
;      this type of block may be used as a file control block.
;      see sysfc,sysin,sysou,s_inp,s_oup for details.
;
;	    +------------------------------------+
;	    i		     xntyp		 i
;	    +------------------------------------+
;	    i		     xnlen		 i
;	    +------------------------------------+
;	    /					 /
;	    /		     xndta		 /
;	    /					 /
;	    +------------------------------------+
;
xntyp	equ	0			; pointer to dummy routine b_xnt
xnlen	equ	xntyp+1			; length of xnblk in bytes
xndta	equ	xnlen+1			; data words
xnsi_	equ	xndta			; size of standard fields in xnblk
;
;      note that the term non-relocatable refers to the contents
;      and not the block itself. an xnblk can be moved around if
;      it is built in the dynamic memory area.
	ejc
;
;      relocatable external block (xrblk)
;
;      an xrblk is a block representing an unknown (external)
;      data value. the data area in this block consists only
;      of address values and any addresses pointing into the
;      dynamic memory area must point to the start of other
;      data blocks. see also description of xnblk.
;      this type of block may be used as a file control block.
;      see sysfc,sysin,sysou,s_inp,s_oup for details.
;
;	    +------------------------------------+
;	    i		     xrtyp		 i
;	    +------------------------------------+
;	    i		     xrlen		 i
;	    +------------------------------------+
;	    /					 /
;	    /		     xrptr		 /
;	    /					 /
;	    +------------------------------------+
;
xrtyp	equ	0			; pointer to dummy routine b_xrt
xrlen	equ	xrtyp+1			; length of xrblk in bytes
xrptr	equ	xrlen+1			; start of address pointers
xrsi_	equ	xrptr			; size of standard fields in xrblk
	ejc
;
;      s_cnv (convert) function switch constants.  the values
;      are tied to the order of the entries in the svctb table
;      and hence to the branch table in s_cnv.
;
cnvst	equ	8			; max standard type code for convert
.if    .cnra
cnvrt	equ	cnvst			; no reals - same as standard types
.else
cnvrt	equ	cnvst+1			; convert code for reals
.fi
.if    .cnbf
cnvbt	equ	cnvrt			; no buffers - same as real code
.else
cnvbt	equ	cnvrt+1			; convert code for buffer
.fi
cnvtt	equ	cnvbt+1			; bsw code for convert
;
;      input image length
;
iniln	equ	1024			; default image length for compiler
inils	equ	1024			; image length if -sequ in effect
;
ionmb	equ	2			; name base used for iochn in sysio
ionmo	equ	4			; name offset used for iochn in sysio
;
;      minimum value for keyword maxlngth
;      should be larger than iniln
;
mnlen	equ	1024			; min value allowed keyword maxlngth
mxern	equ	329			; err num inadequate startup memory
;
;      in general, meaningful mnemonics should be used for
;      offsets. however for small integers used often in
;      literals the following general definitions are provided.
;
num01	equ	1			;
num02	equ	2			;
num03	equ	3			;
num04	equ	4			;
num05	equ	5			;
num06	equ	6			;
num07	equ	7			;
num08	equ	8			;
num09	equ	9			;
num10	equ	10			;
num25	equ	25			;
nm320	equ	320			;
nm321	equ	321			;
nini8	equ	998			;
nini9	equ	999			;
thsnd	equ	1000			;
	ejc
;
;      numbers of undefined spitbol operators
;
opbun	equ	5			; no. of binary undefined ops
opuun	equ	6			; no of unary undefined ops
;
;      offsets used in prtsn, prtmi and acess
;
prsnf	equ	13			; offset used in prtsn
prtmf	equ	21			; offset to col 21 (prtmi)
rilen	equ	1024			; buffer length for sysri
;
;      codes for stages of processing
;
stgic	equ	0			; initial compile
stgxc	equ	stgic+1			; execution compile (code)
stgev	equ	stgxc+1			; expression eval during execution
stgxt	equ	stgev+1			; execution time
stgce	equ	stgxt+1			; initial compile after end line
stgxe	equ	stgce+1			; exec. compile after end line
stgnd	equ	stgce-stgic		; difference in stage after end
stgee	equ	stgxe+1			; eval evaluating expression
stgno	equ	stgee+1			; number of codes
	ejc
;
;
;      statement number pad count for listr
;
.if    .csn6
stnpd	equ	6			; statement no. pad count
.fi
.if    .csn8
stnpd	equ	8			; statement no. pad count
.fi
.if    .csn5
stnpd	equ	5			; statement no. pad count
.fi
;
;      syntax type codes
;
;      these codes are returned from the scane procedure.
;
;      they are spaced 3 apart for the benefit of expan.
;
t_uop	equ	0			; unary operator
t_lpr	equ	t_uop+3			; left paren
t_lbr	equ	t_lpr+3			; left bracket
t_cma	equ	t_lbr+3			; comma
t_fnc	equ	t_cma+3			; function call
t_var	equ	t_fnc+3			; variable
t_con	equ	t_var+3			; constant
t_bop	equ	t_con+3			; binary operator
t_rpr	equ	t_bop+3			; right paren
t_rbr	equ	t_rpr+3			; right bracket
t_col	equ	t_rbr+3			; colon
t_smc	equ	t_col+3			; semi-colon
;
;      the following definitions are used only in the goto field
;
t_fgo	equ	t_smc+1			; failure goto
t_sgo	equ	t_fgo+1			; success goto
;
;      the above codes are grouped so that codes for elements
;      which can legitimately immediately precede a unary
;      operator come first to facilitate operator syntax check.
;
t_uok	equ	t_fnc			; last code ok before unary operator
	ejc
;
;      definitions of values for expan jump table
;
t_uo0	equ	t_uop+0			; unary operator, state zero
t_uo1	equ	t_uop+1			; unary operator, state one
t_uo2	equ	t_uop+2			; unary operator, state two
t_lp0	equ	t_lpr+0			; left paren, state zero
t_lp1	equ	t_lpr+1			; left paren, state one
t_lp2	equ	t_lpr+2			; left paren, state two
t_lb0	equ	t_lbr+0			; left bracket, state zero
t_lb1	equ	t_lbr+1			; left bracket, state one
t_lb2	equ	t_lbr+2			; left bracket, state two
t_cm0	equ	t_cma+0			; comma, state zero
t_cm1	equ	t_cma+1			; comma, state one
t_cm2	equ	t_cma+2			; comma, state two
t_fn0	equ	t_fnc+0			; function call, state zero
t_fn1	equ	t_fnc+1			; function call, state one
t_fn2	equ	t_fnc+2			; function call, state two
t_va0	equ	t_var+0			; variable, state zero
t_va1	equ	t_var+1			; variable, state one
t_va2	equ	t_var+2			; variable, state two
t_co0	equ	t_con+0			; constant, state zero
t_co1	equ	t_con+1			; constant, state one
t_co2	equ	t_con+2			; constant, state two
t_bo0	equ	t_bop+0			; binary operator, state zero
t_bo1	equ	t_bop+1			; binary operator, state one
t_bo2	equ	t_bop+2			; binary operator, state two
t_rp0	equ	t_rpr+0			; right paren, state zero
t_rp1	equ	t_rpr+1			; right paren, state one
t_rp2	equ	t_rpr+2			; right paren, state two
t_rb0	equ	t_rbr+0			; right bracket, state zero
t_rb1	equ	t_rbr+1			; right bracket, state one
t_rb2	equ	t_rbr+2			; right bracket, state two
t_cl0	equ	t_col+0			; colon, state zero
t_cl1	equ	t_col+1			; colon, state one
t_cl2	equ	t_col+2			; colon, state two
t_sm0	equ	t_smc+0			; semicolon, state zero
t_sm1	equ	t_smc+1			; semicolon, state one
t_sm2	equ	t_smc+2			; semicolon, state two
;
t_nes	equ	t_sm2+1			; number of entries in branch table
	ejc
;
;	definition of offsets used in control card processing
;
.if    .culc
cc_ca	equ	0			; -case
cc_do	equ	cc_ca+1			; -double
.else
cc_do	equ	0			; -double
.fi
.if    .ccmk
cc_co	equ	cc_do+1			; -compare
cc_du	equ	cc_co+1			; -dump
.else
cc_du	equ	cc_do+1			; -dump
.fi
.if    .cinc
cc_cp	equ	cc_du+1			; -copy
cc_ej	equ	cc_cp+1			; -eject
.else
cc_ej	equ	cc_du+1			; -eject
.fi
cc_er	equ	cc_ej+1			; -errors
cc_ex	equ	cc_er+1			; -execute
cc_fa	equ	cc_ex+1			; -fail
.if    .cinc
cc_in	equ	cc_fa+1			; -include
.if    .csln
cc_ln	equ	cc_in+1			; -line
cc_li	equ	cc_ln+1			; -list
.else
cc_li	equ	cc_in+1			; -list
.fi
.else
.if    .csln
cc_ln	equ	cc_fa+1			; -line
cc_li	equ	cc_ln+1			; -list
.else
cc_li	equ	cc_fa+1			; -list
.fi
.fi
cc_nr	equ	cc_li+1			; -noerrors
cc_nx	equ	cc_nr+1			; -noexecute
cc_nf	equ	cc_nx+1			; -nofail
cc_nl	equ	cc_nf+1			; -nolist
cc_no	equ	cc_nl+1			; -noopt
cc_np	equ	cc_no+1			; -noprint
cc_op	equ	cc_np+1			; -optimise
cc_pr	equ	cc_op+1			; -print
cc_si	equ	cc_pr+1			; -single
cc_sp	equ	cc_si+1			; -space
cc_st	equ	cc_sp+1			; -stitl
cc_ti	equ	cc_st+1			; -title
cc_tr	equ	cc_ti+1			; -trace
cc_nc	equ	cc_tr+1			; number of control cards
ccnoc	equ	4			; no. of chars included in match
ccofs	equ	7			; offset to start of title/subtitle
.if    .cinc
ccinm	equ	9			; max depth of include file nesting
.fi
	ejc
;
;      definitions of stack offsets used in cmpil procedure
;
;      see description at start of cmpil procedure for details
;      of use of these locations on the stack.
;
cmstm	equ	0			; tree for statement body
cmsgo	equ	cmstm+1			; tree for success goto
cmfgo	equ	cmsgo+1			; tree for fail goto
cmcgo	equ	cmfgo+1			; conditional goto flag
cmpcd	equ	cmcgo+1			; previous cdblk pointer
cmffp	equ	cmpcd+1			; failure fill in flag for previous
cmffc	equ	cmffp+1			; failure fill in flag for current
cmsop	equ	cmffc+1			; success fill in offset for previous
cmsoc	equ	cmsop+1			; success fill in offset for current
cmlbl	equ	cmsoc+1			; ptr to vrblk for current label
cmtra	equ	cmlbl+1			; ptr to entry cdblk
;
cmnen	equ	cmtra+1			; count of stack entries for cmpil
.if    .cnpf
.else
;
;      a few constants used by the profiler
pfpd1	equ	8			; pad positions ...
pfpd2	equ	20			; ... for profile ...
pfpd3	equ	32			; ... printout
pf_i2	equ	cfp_i+cfp_i		; size of table entry (2 ints)
.fi
.if    .crel
	ejc
;
;      definition of limits and adjustments that are built by
;      relcr for use by the routines that relocate pointers
;      after a save file is reloaded.  see reloc etc. for usage.
;
;      a block of information is built that is used in
;      relocating pointers.  there are rnsi_ instances
;      of a rssi_ word structure.  each instance corresponds
;      to one of the regions that a pointer might point into.
;
;      each structure takes the form:
;
;	    +------------------------------------+
;	    i	 address past end of section	 i
;	    +------------------------------------+
;	    i  adjustment from old to new adrs	 i
;	    +------------------------------------+
;	    i	 address of start of section	 i
;	    +------------------------------------+
;
;      the instances are ordered thusly:
;
;	    +------------------------------------+
;	    i		dynamic storage		 i
;	    +------------------------------------+
;	    i		static storage		 i
;	    +------------------------------------+
;	    i	    working section globals	 i
;	    +------------------------------------+
;	    i	       constant section		 i
;	    +------------------------------------+
;	    i		 code section		 i
;	    +------------------------------------+
;
;      symbolic names for these locations as offsets from
;      the first entry are provided here.
;
;      definitions within a section
;
rlend	equ	0			; end
rladj	equ	rlend+1			; adjustment
rlstr	equ	rladj+1			; start
rssi_	equ	rlstr+1			; size of section
rnsi_	equ	5			; number of structures
;
;      overall definitions of all structures
;
rldye	equ	0			; dynamic region end
rldya	equ	rldye+1			; dynamic region adjustment
rldys	equ	rldya+1			; dynamic region start
rlste	equ	rldys+1			; static region end
rlsta	equ	rlste+1			; static region adjustment
rlsts	equ	rlsta+1			; static region start
rlwke	equ	rlsts+1			; working section globals end
rlwka	equ	rlwke+1			; working section globals adjustment
rlwks	equ	rlwka+1			; working section globals start
rlcne	equ	rlwks+1			; constants section end
rlcna	equ	rlcne+1			; constants section adjustment
rlcns	equ	rlcna+1			; constants section start
rlcde	equ	rlcns+1			; code section end
rlcda	equ	rlcde+1			; code section adjustment
rlcds	equ	rlcda+1			; code section start
rlsi_	equ	rlcds+1			; number of fields in structure
.fi
;
	ttl	s p i t b o l -- constant section
;
;      this section consists entirely of assembled constants.
;
;      all label names are five letters. the order is
;      approximately alphabetical, but in some cases (always
;      documented), constants must be placed in some special
;      order which must not be disturbed.
;
;      it must also be remembered that there is a requirement
;      for no forward references which also disturbs the
;      alphabetical order in some cases.
;
	sec				; start of constant section
;
;      start of constant section
;
c_aaa	dac	0			; first location of constant section
;
;      free store percentage (used by alloc)
;
alfsp	dac	e_fsp			; free store percentage
;
;      bit constants for general use
;
bits0	dbc	0			; all zero bits
bits1	dbc	1			; one bit in low order position
bits2	dbc	2			; bit in position 2
bits3	dbc	4			; bit in position 3
bits4	dbc	8			; bit in position 4
bits5	dbc	16			; bit in position 5
bits6	dbc	32			; bit in position 6
bits7	dbc	64			; bit in position 7
bits8	dbc	128			; bit in position 8
bits9	dbc	256			; bit in position 9
bit10	dbc	512			; bit in position 10
bit11	dbc	1024			; bit in position 11
bit12	dbc	2048			; bit in position 12
;bitsm	dbc  cfp_m	      mask for max integer
bitsm	dbc	0			; mask for max integer (value filled in at runtime)
;
;      bit constants for svblk (svbit field) tests
;
btfnc	dbc	svfnc			; bit to test for function
btknm	dbc	svknm			; bit to test for keyword number
btlbl	dbc	svlbl			; bit to test for label
btffc	dbc	svffc			; bit to test for fast call
btckw	dbc	svckw			; bit to test for constant keyword
btkwv	dbc	svkwv			; bits to test for keword with value
btprd	dbc	svprd			; bit to test for predicate function
btpre	dbc	svpre			; bit to test for preevaluation
btval	dbc	svval			; bit to test for value
	ejc
;
;      list of names used for control card processing
;
.if    .culc
ccnms	dtc	/case/
	dtc	/doub/
.else
ccnms	dtc	/doub/
.fi
.if    .ccmk
	dtc	/comp/
.fi
	dtc	/dump/
.if    .cinc
	dtc	/copy/
.fi
	dtc	/ejec/
	dtc	/erro/
	dtc	/exec/
	dtc	/fail/
.if    .cinc
	dtc	/incl/
.fi
.if    .csln
	dtc	/line/
.fi
	dtc	/list/
	dtc	/noer/
	dtc	/noex/
	dtc	/nofa/
	dtc	/noli/
	dtc	/noop/
	dtc	/nopr/
	dtc	/opti/
	dtc	/prin/
	dtc	/sing/
	dtc	/spac/
	dtc	/stit/
	dtc	/titl/
	dtc	/trac/
;
;      header messages for dumpr procedure (scblk format)
;
dmhdk	dac	b_scl			; dump of keyword values
	dac	22			;
	dtc	/dump of keyword values/
;
dmhdv	dac	b_scl			; dump of natural variables
	dac	25			;
	dtc	/dump of natural variables/
	ejc
;
;      message text for compilation statistics
;
encm1	dac	b_scl			;
.if    .cbyt
	dac	19			;
	dtc	/memory used (bytes)/
;
encm2	dac	b_scl			;
	dac	19			;
	dtc	/memory left (bytes)/
.else
	dac	19			;
	dtc	/memory used (words)/
;
encm2	dac	b_scl			;
	dac	19			;
	dtc	/memory left (words)/
.fi
;
encm3	dac	b_scl			;
	dac	11			;
	dtc	/comp errors/
;
encm4	dac	b_scl			;
.if    .ctmd
	dac	19			;
	dtc	/comp time (decisec)/
.else
	dac	20			;
	dtc	/comp time (millisec)/
.fi
;
encm5	dac	b_scl			; execution suppressed
	dac	20			;
	dtc	/execution suppressed/
;
;      string constant for abnormal end
;
endab	dac	b_scl			;
	dac	12			;
	dtc	/abnormal end/
	ejc
;
;      memory overflow during initialisation
;
endmo	dac	b_scl			;
endml	dac	15			;
	dtc	/memory overflow/
;
;      string constant for message issued by l_end
;
endms	dac	b_scl			;
	dac	10			;
	dtc	/normal end/
;
;      fail message for stack fail section
;
endso	dac	b_scl			; stack overflow in garbage collector
	dac	36			;
	dtc	/stack overflow in garbage collection/
;
;      string constant for time up
;
endtu	dac	b_scl			;
	dac	15			;
	dtc	/error - time up/
	ejc
;
;      string constant for error message (error section)
;
ermms	dac	b_scl			; error
	dac	5			;
	dtc	/error/
;
ermns	dac	b_scl			; string / -- /
	dac	4			;
	dtc	/ -- /
;
;      string constant for page numbering
;
lstms	dac	b_scl			; page
	dac	5			;
	dtc	/page /
;
;      listing header message
;
headr	dac	b_scl			;
	dac	27			;
	dtc	/macro spitbol version 15.01/
;
headv	dac	b_scl			; for exit() version no. check
	dac	5			;
	dtc	/15.01/
.if    .csed
;      free store percentage (used by gbcol)
;
gbsdp	dac	e_sed			; sediment percentage
.fi
;
;      integer constants for general use
;      icbld optimisation uses the first three.
;
int_r	dac	b_icl			;
intv0	dic	+0			; 0
inton	dac	b_icl			;
intv1	dic	+1			; 1
inttw	dac	b_icl			;
intv2	dic	+2			; 2
intvt	dic	+10			; 10
intvh	dic	+100			; 100
intth	dic	+1000			; 1000
;
;      table used in icbld optimisation
;
intab	dac	int_r			; pointer to 0
	dac	inton			; pointer to 1
	dac	inttw			; pointer to 2
	ejc
;
;      special pattern nodes. the following pattern nodes
;      consist simply of a pcode pointer, see match routines
;      (p_xxx) for full details of their use and format).
;
ndabb	dac	p_abb			; arbno
ndabd	dac	p_abd			; arbno
ndarc	dac	p_arc			; arb
ndexb	dac	p_exb			; expression
ndfnb	dac	p_fnb			; fence()
ndfnd	dac	p_fnd			; fence()
ndexc	dac	p_exc			; expression
ndimb	dac	p_imb			; immediate assignment
ndimd	dac	p_imd			; immediate assignment
ndnth	dac	p_nth			; pattern end (null pattern)
ndpab	dac	p_pab			; pattern assignment
ndpad	dac	p_pad			; pattern assignment
nduna	dac	p_una			; anchor point movement
;
;      keyword constant pattern nodes. the following nodes are
;      used as the values of pattern keywords and the initial
;      values of the corresponding natural variables. all
;      nodes are in p0blk format and the order is tied to the
;      definitions of corresponding k_xxx symbols.
;
ndabo	dac	p_abo			; abort
	dac	ndnth			;
ndarb	dac	p_arb			; arb
	dac	ndnth			;
ndbal	dac	p_bal			; bal
	dac	ndnth			;
ndfal	dac	p_fal			; fail
	dac	ndnth			;
ndfen	dac	p_fen			; fence
	dac	ndnth			;
ndrem	dac	p_rem			; rem
	dac	ndnth			;
ndsuc	dac	p_suc			; succeed
	dac	ndnth			;
;
;      null string. all null values point to this string. the
;      svchs field contains a blank to provide for easy default
;      processing in trace, stoptr, lpad and rpad.
;      nullw contains 10 blanks which ensures an all blank word
;      but for very exceptional machines.
;
nulls	dac	b_scl			; null string value
	dac	0			; sclen = 0
nullw	dtc	/          /
;
.if    .culk
;
;      constant strings for lcase and ucase keywords
;
lcase	dac	b_scl			;
	dac	26			;
	dtc	/abcdefghijklmnopqrstuvwxyz/
;
ucase	dac	b_scl			;
	dac	26			;
	dtc	/ABCDEFGHIJKLMNOPQRSTUVWXYZ/
.fi
	ejc
;
;      operator dope vectors (see dvblk format)
;
opdvc	dac	o_cnc			; concatenation
	dac	c_cnc			;
	dac	llcnc			;
	dac	rrcnc			;
;
;      opdvs is used when scanning below the top level to
;      insure that the concatenation will not be later
;      mistaken for pattern matching
;
opdvp	dac	o_cnc			; concatenation - not pattern match
	dac	c_cnp			;
	dac	llcnc			;
	dac	rrcnc			;
;
;      note that the order of the remaining entries is tied to
;      the order of the coding in the scane procedure.
;
opdvs	dac	o_ass			; assignment
	dac	c_ass			;
	dac	llass			;
	dac	rrass			;
;
	dac	6			; unary equal
	dac	c_uuo			;
	dac	lluno			;
;
	dac	o_pmv			; pattern match
	dac	c_pmt			;
	dac	llpmt			;
	dac	rrpmt			;
;
	dac	o_int			; interrogation
	dac	c_uvl			;
	dac	lluno			;
;
	dac	1			; binary ampersand
	dac	c_ubo			;
	dac	llamp			;
	dac	rramp			;
;
	dac	o_kwv			; keyword reference
	dac	c_key			;
	dac	lluno			;
;
	dac	o_alt			; alternation
	dac	c_alt			;
	dac	llalt			;
	dac	rralt			;
	ejc
;
;      operator dope vectors (continued)
;
	dac	5			; unary vertical bar
	dac	c_uuo			;
	dac	lluno			;
;
	dac	0			; binary at
	dac	c_ubo			;
	dac	llats			;
	dac	rrats			;
;
	dac	o_cas			; cursor assignment
	dac	c_unm			;
	dac	lluno			;
;
	dac	2			; binary number sign
	dac	c_ubo			;
	dac	llnum			;
	dac	rrnum			;
;
	dac	7			; unary number sign
	dac	c_uuo			;
	dac	lluno			;
;
	dac	o_dvd			; division
	dac	c_bvl			;
	dac	lldvd			;
	dac	rrdvd			;
;
	dac	9			; unary slash
	dac	c_uuo			;
	dac	lluno			;
;
	dac	o_mlt			; multiplication
	dac	c_bvl			;
	dac	llmlt			;
	dac	rrmlt			;
	ejc
;
;      operator dope vectors (continued)
;
	dac	0			; deferred expression
	dac	c_def			;
	dac	lluno			;
;
	dac	3			; binary percent
	dac	c_ubo			;
	dac	llpct			;
	dac	rrpct			;
;
	dac	8			; unary percent
	dac	c_uuo			;
	dac	lluno			;
;
	dac	o_exp			; exponentiation
	dac	c_bvl			;
	dac	llexp			;
	dac	rrexp			;
;
	dac	10			; unary exclamation
	dac	c_uuo			;
	dac	lluno			;
;
	dac	o_ima			; immediate assignment
	dac	c_bvn			;
	dac	lldld			;
	dac	rrdld			;
;
	dac	o_inv			; indirection
	dac	c_ind			;
	dac	lluno			;
;
	dac	4			; binary not
	dac	c_ubo			;
	dac	llnot			;
	dac	rrnot			;
;
	dac	0			; negation
	dac	c_neg			;
	dac	lluno			;
	ejc
;
;      operator dope vectors (continued)
;
	dac	o_sub			; subtraction
	dac	c_bvl			;
	dac	llplm			;
	dac	rrplm			;
;
	dac	o_com			; complementation
	dac	c_uvl			;
	dac	lluno			;
;
	dac	o_add			; addition
	dac	c_bvl			;
	dac	llplm			;
	dac	rrplm			;
;
	dac	o_aff			; affirmation
	dac	c_uvl			;
	dac	lluno			;
;
	dac	o_pas			; pattern assignment
	dac	c_bvn			;
	dac	lldld			;
	dac	rrdld			;
;
	dac	o_nam			; name reference
	dac	c_unm			;
	dac	lluno			;
;
;      special dvs for goto operators (see procedure scngf)
;
opdvd	dac	o_god			; direct goto
	dac	c_uvl			;
	dac	lluno			;
;
opdvn	dac	o_goc			; complex normal goto
	dac	c_unm			;
	dac	lluno			;
	ejc
;
;      operator entry address pointers, used in code
;
oamn_	dac	o_amn			; array ref (multi-subs by value)
oamv_	dac	o_amv			; array ref (multi-subs by value)
oaon_	dac	o_aon			; array ref (one sub by name)
oaov_	dac	o_aov			; array ref (one sub by value)
ocer_	dac	o_cer			; compilation error
ofex_	dac	o_fex			; failure in expression evaluation
ofif_	dac	o_fif			; failure during goto evaluation
ofnc_	dac	o_fnc			; function call (more than one arg)
ofne_	dac	o_fne			; function name error
ofns_	dac	o_fns			; function call (single argument)
ogof_	dac	o_gof			; set goto failure trap
oinn_	dac	o_inn			; indirection by name
okwn_	dac	o_kwn			; keyword reference by name
olex_	dac	o_lex			; load expression by name
olpt_	dac	o_lpt			; load pattern
olvn_	dac	o_lvn			; load variable name
onta_	dac	o_nta			; negation, first entry
ontb_	dac	o_ntb			; negation, second entry
ontc_	dac	o_ntc			; negation, third entry
opmn_	dac	o_pmn			; pattern match by name
opms_	dac	o_pms			; pattern match (statement)
opop_	dac	o_pop			; pop top stack item
ornm_	dac	o_rnm			; return name from expression
orpl_	dac	o_rpl			; pattern replacement
orvl_	dac	o_rvl			; return value from expression
osla_	dac	o_sla			; selection, first entry
oslb_	dac	o_slb			; selection, second entry
oslc_	dac	o_slc			; selection, third entry
osld_	dac	o_sld			; selection, fourth entry
ostp_	dac	o_stp			; stop execution
ounf_	dac	o_unf			; unexpected failure
	ejc
;
;      table of names of undefined binary operators for opsyn
;
opsnb	dac	ch_at			; at
	dac	ch_am			; ampersand
	dac	ch_nm			; number
	dac	ch_pc			; percent
	dac	ch_nt			; not
;
;      table of names of undefined unary operators for opsyn
;
opnsu	dac	ch_br			; vertical bar
	dac	ch_eq			; equal
	dac	ch_nm			; number
	dac	ch_pc			; percent
	dac	ch_sl			; slash
	dac	ch_ex			; exclamation
.if    .cnpf
.else
;
;      address const containing profile table entry size
;
pfi2a	dac	pf_i2			;
;
;      profiler message strings
;
pfms1	dac  b_scl
	dac	15
	dtc	/program profile/
pfms2	dac  b_scl
	dac	42
	dtc	/stmt    number of     -- execution time --/
pfms3	dac  b_scl
	dac	47
	dtc	/number  executions  total(msec) per excn(mcsec)/
.fi
;
.if    .cnra
.else
;
;      real constants for general use. note that the constants
;      starting at reav1 form a powers of ten table (used in
;      gtnum and gtstg)
;
reav0	drc	+0.0			; 0.0
.if    .cncr
.else
reap1	drc	+0.1			; 0.1
reap5	drc	+0.5			; 0.5
.fi
reav1	drc	+1.0			; 10**0
reavt	drc	+1.0e+1			; 10**1
	drc	+1.0e+2			; 10**2
	drc	+1.0e+3			; 10**3
	drc	+1.0e+4			; 10**4
	drc	+1.0e+5			; 10**5
	drc	+1.0e+6			; 10**6
	drc	+1.0e+7			; 10**7
	drc	+1.0e+8			; 10**8
	drc	+1.0e+9			; 10**9
reatt	drc	+1.0e+10		; 10**10
.fi
	ejc
;
;      string constants (scblk format) for dtype procedure
;
scarr	dac	b_scl			; array
	dac	5			;
	dtc	/array/
.if    .cnbf
.else
;
scbuf	dac	b_scl			; buffer
	dac	6			;
	dtc	/buffer/
.fi
;
sccod	dac	b_scl			; code
	dac	4			;
	dtc	/code/
;
scexp	dac	b_scl			; expression
	dac	10			;
	dtc	/expression/
;
scext	dac	b_scl			; external
	dac	8			;
	dtc	/external/
;
scint	dac	b_scl			; integer
	dac	7			;
	dtc	/integer/
;
scnam	dac	b_scl			; name
	dac	4			;
	dtc	/name/
;
scnum	dac	b_scl			; numeric
	dac	7			;
	dtc	/numeric/
;
scpat	dac	b_scl			; pattern
	dac	7			;
	dtc	/pattern/
.if    .cnra
.else
;
screa	dac	b_scl			; real
	dac	4			;
	dtc	/real/
.fi
;
scstr	dac	b_scl			; string
	dac	6			;
	dtc	/string/
;
sctab	dac	b_scl			; table
	dac	5			;
	dtc	/table/
.if    .cnlf
scfil	dac	b_scl			; file (for extended load arguments)
	dac	4			;
	dtc	/file/
.fi
	ejc
;
;      string constants (scblk format) for kvrtn (see retrn)
;
scfrt	dac	b_scl			; freturn
	dac	7			;
	dtc	/freturn/
;
scnrt	dac	b_scl			; nreturn
	dac	7			;
	dtc	/nreturn/
;
scrtn	dac	b_scl			; return
	dac	6			;
	dtc	/return/
;
;      datatype name table for dtype procedure. the order of
;      these entries is tied to the b_xxx definitions for blocks
;
;      note that slots for buffer and real data types are filled
;      even if these data types are conditionalized out of the
;      implementation.	this is done so that the block numbering
;      at bl_ar etc. remains constant in all versions.
;
scnmt	dac	scarr			; arblk	    array
	dac	sccod			; cdblk	    code
	dac	scexp			; exblk	    expression
	dac	scint			; icblk	    integer
	dac	scnam			; nmblk	    name
	dac	scpat			; p0blk	    pattern
	dac	scpat			; p1blk	    pattern
	dac	scpat			; p2blk	    pattern
.if    .cnra
	dac	nulls			; rcblk	    no real in this version
.else

	dac	screa			; rcblk	    real
.fi
	dac	scstr			; scblk	    string
	dac	scexp			; seblk	    expression
	dac	sctab			; tbblk	    table
	dac	scarr			; vcblk	    array
	dac	scext			; xnblk	    external
	dac	scext			; xrblk	    external
.if    .cnbf
	dac	nulls			; bfblk	    no buffer in this version
.else
	dac	scbuf			; bfblk	    buffer
.fi
;
.if    .cnra
.else
;      string constant for real zero
;
scre0	dac	b_scl			;
	dac	2			;
	dtc	/0./
.fi
	ejc
;
;      used to re-initialise kvstl
;
.if    .cs16
stlim	dic	+32767			; default statement limit
.else
.if    .cs32
stlim	dic	+2147483647		; default statement limit
.else
stlim	dic	+50000			; default statement limit
.fi
.fi
;
;      dummy function block used for undefined functions
;
stndf	dac	o_fun			; ptr to undefined function err call
	dac	0			; dummy fargs count for call circuit
;
;      dummy code block used for undefined labels
;
stndl	dac	l_und			; code ptr points to undefined lbl
;
;      dummy operator block used for undefined operators
;
stndo	dac	o_oun			; ptr to undefined operator err call
	dac	0			; dummy fargs count for call circuit
;
;      standard variable block. this block is used to initialize
;      the first seven fields of a newly constructed vrblk.
;      its format is tied to the vrblk definitions (see gtnvr).
;
stnvr	dac	b_vrl			; vrget
	dac	b_vrs			; vrsto
	dac	nulls			; vrval
	dac	b_vrg			; vrtra
	dac	stndl			; vrlbl
	dac	stndf			; vrfnc
	dac	0			; vrnxt
	ejc
;
;      messages used in end of run processing (stopr)
;
stpm1	dac	b_scl			; in statement
	dac	12			;
	dtc	/in statement/
;
stpm2	dac	b_scl			;
	dac	14			;
	dtc	/stmts executed/
;
stpm3	dac	b_scl			;
.if    .ctmd
	dac	18			;
	dtc	/run time (decisec)/
.else
	dac	19			;
	dtc	/run time (millisec)/
.fi
;
stpm4	dac	b_scl			;
	dac	12			;
	dtc	_mcsec / stmt_
;
stpm5	dac	b_scl			;
	dac	13			;
	dtc	/regenerations/
.if    .csln
;
stpm6	dac	b_scl			; in line
	dac	7			;
	dtc	/in line/
.fi
.if    .csfn
;
stpm7	dac	b_scl			; in file
	dac	7			;
	dtc	/in file/
.fi
;
;      chars for /tu/ ending code
;
strtu	dtc	/tu/
;
;      table used by convert function to check datatype name
;      the entries are ordered to correspond to branch table
;      in s_cnv
;
svctb	dac	scstr			; string
	dac	scint			; integer
	dac	scnam			; name
	dac	scpat			; pattern
	dac	scarr			; array
	dac	sctab			; table
	dac	scexp			; expression
	dac	sccod			; code
	dac	scnum			; numeric
.if    .cnra
.else
	dac	screa			; real
.fi
.if    .cnbf
.else
	dac	scbuf			; buffer
.fi
	dac	0			; zero marks end of list
	ejc
;
;      messages (scblk format) used by trace procedures
;
;
tmasb	dac	b_scl			; asterisks for trace statement no
	dac	13			;
	dtc	/************ /

;
tmbeb	dac	b_scl			; blank-equal-blank
	dac	3			;
	dtc	/ = /
;
;      dummy trblk for expression variable
;
trbev	dac	b_trt			; dummy trblk
;
;      dummy trblk for keyword variable
;
trbkv	dac	b_trt			; dummy trblk
;
;      dummy code block to return control to trxeq procedure
;
trxdr	dac	o_txr			; block points to return routine
trxdc	dac	trxdr			; pointer to block
	ejc
;
;      standard variable blocks
;
;      see svblk format for full details of the format. the
;      vrblks are ordered by length and within each length the
;      order is alphabetical by name of the variable.
;
v_eqf	dbc	svfpr			; eq
	dac	2			;
	dtc	/eq/
	dac	s_eqf			;
	dac	2			;
;
v_gef	dbc	svfpr			; ge
	dac	2			;
	dtc	/ge/
	dac	s_gef			;
	dac	2			;
;
v_gtf	dbc	svfpr			; gt
	dac	2			;
	dtc	/gt/
	dac	s_gtf			;
	dac	2			;
;
v_lef	dbc	svfpr			; le
	dac	2			;
	dtc	/le/
	dac	s_lef			;
	dac	2			;
.if    .cmth
;
v_lnf	dbc	svfnp			; ln
	dac	2			;
	dtc	/ln/
	dac	s_lnf			;
	dac	1			;
.fi
;
v_ltf	dbc	svfpr			; lt
	dac	2			;
	dtc	/lt/
	dac	s_ltf			;
	dac	2			;
;
v_nef	dbc	svfpr			; ne
	dac	2			;
	dtc	/ne/
	dac	s_nef			;
	dac	2			;
.if    .c370
;
v_orf	dbc	svfnp			; or
	dac	2			;
	dtc	/or/
	dac	s_orf			;
	dac	2			;
.fi
.if    .c370
;
v_abs	dbc	svfnp			; abs
	dac	3			;
	dtc	/abs/
	dac	s_abs			;
	dac	1			;
.fi
.if    .c370
;
v_and	dbc	svfnp			; and
	dac	3			;
	dtc	/and/
	dac	s_and			;
	dac	2			;
.fi
;
v_any	dbc	svfnp			; any
	dac	3			;
	dtc	/any/
	dac	s_any			;
	dac	1			;
;
v_arb	dbc	svkvc			; arb
	dac	3			;
	dtc	/arb/
	dac	k_arb			;
	dac	ndarb			;
	ejc
;
;      standard variable blocks (continued)
;
v_arg	dbc	svfnn			; arg
	dac	3			;
	dtc	/arg/
	dac	s_arg			;
	dac	2			;
;
v_bal	dbc	svkvc			; bal
	dac	3			;
	dtc	/bal/
	dac	k_bal			;
	dac	ndbal			;
.if    .cmth
;
v_cos	dbc	svfnp			; cos
	dac	3			;
	dtc	/cos/
	dac	s_cos			;
	dac	1			;
.fi
;
v_end	dbc	svlbl			; end
	dac	3			;
	dtc	/end/
	dac	l_end			;
.if    .cmth
;
v_exp	dbc	svfnp			; exp
	dac	3			;
	dtc	/exp/
	dac	s_exp			;
	dac	1			;
.fi
;
v_len	dbc	svfnp			; len
	dac	3			;
	dtc	/len/
	dac	s_len			;
	dac	1			;
;
v_leq	dbc	svfpr			; leq
	dac	3			;
	dtc	/leq/
	dac	s_leq			;
	dac	2			;
;
v_lge	dbc	svfpr			; lge
	dac	3			;
	dtc	/lge/
	dac	s_lge			;
	dac	2			;
;
v_lgt	dbc	svfpr			; lgt
	dac	3			;
	dtc	/lgt/
	dac	s_lgt			;
	dac	2			;
;
v_lle	dbc	svfpr			; lle
	dac	3			;
	dtc	/lle/
	dac	s_lle			;
	dac	2			;
	ejc
;
;      standard variable blocks (continued)
;
v_llt	dbc	svfpr			; llt
	dac	3			;
	dtc	/llt/
	dac	s_llt			;
	dac	2			;
;
v_lne	dbc	svfpr			; lne
	dac	3			;
	dtc	/lne/
	dac	s_lne			;
	dac	2			;
;
v_pos	dbc	svfnp			; pos
	dac	3			;
	dtc	/pos/
	dac	s_pos			;
	dac	1			;
;
v_rem	dbc	svkvc			; rem
	dac	3			;
	dtc	/rem/
	dac	k_rem			;
	dac	ndrem			;
.if    .cust
;
v_set	dbc	svfnn			; set
	dac	3			;
	dtc	/set/
	dac	s_set			;
	dac	3			;
.fi
.if    .cmth
;
v_sin	dbc	svfnp			; sin
	dac	3			;
	dtc	/sin/
	dac	s_sin			;
	dac	1			;
.fi
;
v_tab	dbc	svfnp			; tab
	dac	3			;
	dtc	/tab/
	dac	s_tab			;
	dac	1			;
.if    .cmth
;
v_tan	dbc	svfnp			; tan
	dac	3			;
	dtc	/tan/
	dac	s_tan			;
	dac	1			;
.fi
.if    .c370
;
v_xor	dbc	svfnp			; xor
	dac	3			;
	dtc	/xor/
	dac	s_xor			;
	dac	2			;
.fi
.if    .cmth
;
v_atn	dbc	svfnp			; atan
	dac	4			;
	dtc	/atan/
	dac	s_atn			;
	dac	1			;
.fi
.if    .culc
;
v_cas	dbc	svknm			; case
	dac	4			;
	dtc	/case/
	dac	k_cas			;
.fi
;
v_chr	dbc	svfnp			; char
	dac	4			;
	dtc	/char/
	dac	s_chr			;
	dac	1			;
;
.if    .cmth
;
v_chp	dbc	svfnp			; chop
	dac	4			;
	dtc	/chop/
	dac	s_chp			;
	dac	1			;
.fi
v_cod	dbc	svfnk			; code
	dac	4			;
	dtc	/code/
	dac	k_cod			;
	dac	s_cod			;
	dac	1			;
;
v_cop	dbc	svfnn			; copy
	dac	4			;
	dtc	/copy/
	dac	s_cop			;
	dac	1			;
	ejc
;
;      standard variable blocks (continued)
;
v_dat	dbc	svfnn			; data
	dac	4			;
	dtc	/data/
	dac	s_dat			;
	dac	1			;
;
v_dte	dbc	svfnn			; date
	dac	4			;
	dtc	/date/
	dac	s_dte			;
	dac	1			;
;
v_dmp	dbc	svfnk			; dump
	dac	4			;
	dtc	/dump/
	dac	k_dmp			;
	dac	s_dmp			;
	dac	1			;
;
v_dup	dbc	svfnn			; dupl
	dac	4			;
	dtc	/dupl/
	dac	s_dup			;
	dac	2			;
;
v_evl	dbc	svfnn			; eval
	dac	4			;
	dtc	/eval/
	dac	s_evl			;
	dac	1			;
.if    .cnex
.else
;
v_ext	dbc	svfnn			; exit
	dac	4			;
	dtc	/exit/
	dac	s_ext			;
	dac	2			;
.fi
;
v_fal	dbc	svkvc			; fail
	dac	4			;
	dtc	/fail/
	dac	k_fal			;
	dac	ndfal			;
;
.if    .csfn
v_fil	dbc	svknm			; file
	dac	4			;
	dtc	/file/
	dac	k_fil			;
;
.fi
v_hst	dbc	svfnn			; host
	dac	4			;
	dtc	/host/
	dac	s_hst			;
	dac	5			;
	ejc
;
;      standard variable blocks (continued)
;
v_itm	dbc	svfnf			; item
	dac	4			;
	dtc	/item/
	dac	s_itm			;
	dac	999			;
.if    .csln
;
v_lin	dbc	svknm			; line
	dac	4			;
	dtc	/line/
	dac	k_lin			;
.fi
.if    .cnld
.else
;
v_lod	dbc	svfnn			; load
	dac	4			;
	dtc	/load/
	dac	s_lod			;
	dac	2			;
.fi
;
v_lpd	dbc	svfnp			; lpad
	dac	4			;
	dtc	/lpad/
	dac	s_lpd			;
	dac	3			;
;
v_rpd	dbc	svfnp			; rpad
	dac	4			;
	dtc	/rpad/
	dac	s_rpd			;
	dac	3			;
;
v_rps	dbc	svfnp			; rpos
	dac	4			;
	dtc	/rpos/
	dac	s_rps			;
	dac	1			;
;
v_rtb	dbc	svfnp			; rtab
	dac	4			;
	dtc	/rtab/
	dac	s_rtb			;
	dac	1			;
;
v_si_	dbc	svfnp			; size
	dac	4			;
	dtc	/size/
	dac	s_si_			;
	dac	1			;
;
.if    .cnsr
.else
;
v_srt	dbc	svfnn			; sort
	dac	4			;
	dtc	/sort/
	dac	s_srt			;
	dac	2			;
.fi
v_spn	dbc	svfnp			; span
	dac	4			;
	dtc	/span/
	dac	s_spn			;
	dac	1			;
	ejc
;
;      standard variable blocks (continued)
;
.if    .cmth
;
v_sqr	dbc	svfnp			; sqrt
	dac	4			;
	dtc	/sqrt/
	dac	s_sqr			;
	dac	1			;
.fi
v_stn	dbc	svknm			; stno
	dac	4			;
	dtc	/stno/
	dac	k_stn			;
;
v_tim	dbc	svfnn			; time
	dac	4			;
	dtc	/time/
	dac	s_tim			;
	dac	0			;
;
v_trm	dbc	svfnk			; trim
	dac	4			;
	dtc	/trim/
	dac	k_trm			;
	dac	s_trm			;
	dac	1			;
;
v_abe	dbc	svknm			; abend
	dac	5			;
	dtc	/abend/
	dac	k_abe			;
;
v_abo	dbc	svkvl			; abort
	dac	5			;
	dtc	/abort/
	dac	k_abo			;
	dac	l_abo			;
	dac	ndabo			;
;
v_app	dbc	svfnf			; apply
	dac	5			;
	dtc	/apply/
	dac	s_app			;
	dac	999			;
;
v_abn	dbc	svfnp			; arbno
	dac	5			;
	dtc	/arbno/
	dac	s_abn			;
	dac	1			;
;
v_arr	dbc	svfnn			; array
	dac	5			;
	dtc	/array/
	dac	s_arr			;
	dac	2			;
	ejc
;
;      standard variable blocks (continued)
;
v_brk	dbc	svfnp			; break
	dac	5			;
	dtc	/break/
	dac	s_brk			;
	dac	1			;
;
v_clr	dbc	svfnn			; clear
	dac	5			;
	dtc	/clear/
	dac	s_clr			;
	dac	1			;
.if    .c370
;
v_cmp	dbc	svfnp			; compl
	dac	5			;
	dtc	/compl/
	dac	s_cmp			;
	dac	1			;
.fi
;
v_ejc	dbc	svfnn			; eject
	dac	5			;
	dtc	/eject/
	dac	s_ejc			;
	dac	1			;
;
v_fen	dbc	svfpk			; fence
	dac	5			;
	dtc	/fence/
	dac	k_fen			;
	dac	s_fnc			;
	dac	1			;
	dac	ndfen			;
;
v_fld	dbc	svfnn			; field
	dac	5			;
	dtc	/field/
	dac	s_fld			;
	dac	2			;
;
v_idn	dbc	svfpr			; ident
	dac	5			;
	dtc	/ident/
	dac	s_idn			;
	dac	2			;
;
v_inp	dbc	svfnk			; input
	dac	5			;
	dtc	/input/
	dac	k_inp			;
	dac	s_inp			;
	dac	3			;
.if    .culk
;
v_lcs	dbc	svkwc			; lcase
	dac	5			;
	dtc	/lcase/
	dac	k_lcs			;
.fi
;
v_loc	dbc	svfnn			; local
	dac	5			;
	dtc	/local/
	dac	s_loc			;
	dac	2			;
	ejc
;
;      standard variable blocks (continued)
;
v_ops	dbc	svfnn			; opsyn
	dac	5			;
	dtc	/opsyn/
	dac	s_ops			;
	dac	3			;
;
v_rmd	dbc	svfnp			; remdr
	dac	5			;
	dtc	/remdr/
	dac	s_rmd			;
	dac	2			;
.if    .cnsr
.else
;
v_rsr	dbc	svfnn			; rsort
	dac	5			;
	dtc	/rsort/
	dac	s_rsr			;
	dac	2			;
.fi
;
v_tbl	dbc	svfnn			; table
	dac	5			;
	dtc	/table/
	dac	s_tbl			;
	dac	3			;
;
v_tra	dbc	svfnk			; trace
	dac	5			;
	dtc	/trace/
	dac	k_tra			;
	dac	s_tra			;
	dac	4			;
.if    .culk
;
v_ucs	dbc	svkwc			; ucase
	dac	5			;
	dtc	/ucase/
	dac	k_ucs			;
.fi
;
v_anc	dbc	svknm			; anchor
	dac	6			;
	dtc	/anchor/
	dac	k_anc			;
.if    .cnbf
.else
;
v_apn	dbc	svfnn			; append
	dac	6			;
	dtc	/append/
	dac	s_apn			;
	dac	2			;
.fi
;
v_bkx	dbc	svfnp			; breakx
	dac	6			;
	dtc	/breakx/
	dac	s_bkx			;
	dac	1			;
;
.if    .cnbf
.else
v_buf	dbc	svfnn			; buffer
	dac	6			;
	dtc	/buffer/
	dac	s_buf			;
	dac	2			;
.fi
;
v_def	dbc	svfnn			; define
	dac	6			;
	dtc	/define/
	dac	s_def			;
	dac	2			;
;
v_det	dbc	svfnn			; detach
	dac	6			;
	dtc	/detach/
	dac	s_det			;
	dac	1			;
	ejc
;
;      standard variable blocks (continued)
;
v_dif	dbc	svfpr			; differ
	dac	6			;
	dtc	/differ/
	dac	s_dif			;
	dac	2			;
;
v_ftr	dbc	svknm			; ftrace
	dac	6			;
	dtc	/ftrace/
	dac	k_ftr			;
;
.if    .cnbf
.else
v_ins	dbc	svfnn			; insert
	dac	6			;
	dtc	/insert/
	dac	s_ins			;
	dac	4			;
;
.fi
v_lst	dbc	svknm			; lastno
	dac	6			;
	dtc	/lastno/
	dac	k_lst			;
;
v_nay	dbc	svfnp			; notany
	dac	6			;
	dtc	/notany/
	dac	s_nay			;
	dac	1			;
;
v_oup	dbc	svfnk			; output
	dac	6			;
	dtc	/output/
	dac	k_oup			;
	dac	s_oup			;
	dac	3			;
;
v_ret	dbc	svlbl			; return
	dac	6			;
	dtc	/return/
	dac	l_rtn			;
;
v_rew	dbc	svfnn			; rewind
	dac	6			;
	dtc	/rewind/
	dac	s_rew			;
	dac	1			;
;
v_stt	dbc	svfnn			; stoptr
	dac	6			;
	dtc	/stoptr/
	dac	s_stt			;
	dac	2			;
	ejc
;
;      standard variable blocks (continued)
;
v_sub	dbc	svfnn			; substr
	dac	6			;
	dtc	/substr/
	dac	s_sub			;
	dac	3			;
;
v_unl	dbc	svfnn			; unload
	dac	6			;
	dtc	/unload/
	dac	s_unl			;
	dac	1			;
;
v_col	dbc	svfnn			; collect
	dac	7			;
	dtc	/collect/
	dac	s_col			;
	dac	1			;
.if    .ccmk
;
v_com	dbc	svknm			; compare
	dac	7			;
	dtc	/compare/
	dac	k_com			;
.fi
;
v_cnv	dbc	svfnn			; convert
	dac	7			;
	dtc	/convert/
	dac	s_cnv			;
	dac	2			;
;
v_enf	dbc	svfnn			; endfile
	dac	7			;
	dtc	/endfile/
	dac	s_enf			;
	dac	1			;
;
v_etx	dbc	svknm			; errtext
	dac	7			;
	dtc	/errtext/
	dac	k_etx			;
;
v_ert	dbc	svknm			; errtype
	dac	7			;
	dtc	/errtype/
	dac	k_ert			;
;
v_frt	dbc	svlbl			; freturn
	dac	7			;
	dtc	/freturn/
	dac	l_frt			;
;
v_int	dbc	svfpr			; integer
	dac	7			;
	dtc	/integer/
	dac	s_int			;
	dac	1			;
;
v_nrt	dbc	svlbl			; nreturn
	dac	7			;
	dtc	/nreturn/
	dac	l_nrt			;
	ejc
;
;      standard variable blocks (continued)
;
.if    .cnpf
.else
;
v_pfl	dbc	svknm			; profile
	dac	7			;
	dtc	/profile/
	dac	k_pfl			;
.fi
;
v_rpl	dbc	svfnp			; replace
	dac	7			;
	dtc	/replace/
	dac	s_rpl			;
	dac	3			;
;
v_rvs	dbc	svfnp			; reverse
	dac	7			;
	dtc	/reverse/
	dac	s_rvs			;
	dac	1			;
;
v_rtn	dbc	svknm			; rtntype
	dac	7			;
	dtc	/rtntype/
	dac	k_rtn			;
;
v_stx	dbc	svfnn			; setexit
	dac	7			;
	dtc	/setexit/
	dac	s_stx			;
	dac	1			;
;
v_stc	dbc	svknm			; stcount
	dac	7			;
	dtc	/stcount/
	dac	k_stc			;
;
v_stl	dbc	svknm			; stlimit
	dac	7			;
	dtc	/stlimit/
	dac	k_stl			;
;
v_suc	dbc	svkvc			; succeed
	dac	7			;
	dtc	/succeed/
	dac	k_suc			;
	dac	ndsuc			;
;
v_alp	dbc	svkwc			; alphabet
	dac	8			;
	dtc	/alphabet/
	dac	k_alp			;
;
v_cnt	dbc	svlbl			; continue
	dac	8			;
	dtc	/continue/
	dac	l_cnt			;
	ejc
;
;      standard variable blocks (continued)
;
v_dtp	dbc	svfnp			; datatype
	dac	8			;
	dtc	/datatype/
	dac	s_dtp			;
	dac	1			;
;
v_erl	dbc	svknm			; errlimit
	dac	8			;
	dtc	/errlimit/
	dac	k_erl			;
;
v_fnc	dbc	svknm			; fnclevel
	dac	8			;
	dtc	/fnclevel/
	dac	k_fnc			;
;
v_fls	dbc	svknm			; fullscan
	dac	8			;
	dtc	/fullscan/
	dac	k_fls			;
;
.if    .csfn
v_lfl	dbc	svknm			; lastfile
	dac	8			;
	dtc	/lastfile/
	dac	k_lfl			;
;
.fi
.if    .csln
v_lln	dbc	svknm			; lastline
	dac	8			;
	dtc	/lastline/
	dac	k_lln			;
;
.fi
v_mxl	dbc	svknm			; maxlngth
	dac	8			;
	dtc	/maxlngth/
	dac	k_mxl			;
;
v_ter	dbc	0			; terminal
	dac	8			;
	dtc	/terminal/
	dac	0			;
;
.if    .cbsp
v_bsp	dbc	svfnn			; backspace
	dac	9			;
	dtc	/backspace/
	dac	s_bsp			;
	dac	1			;
;
.fi
v_pro	dbc	svfnn			; prototype
	dac	9			;
	dtc	/prototype/
	dac	s_pro			;
	dac	1			;
;
v_scn	dbc	svlbl			; scontinue
	dac	9			;
	dtc	/scontinue/
	dac	l_scn			;
;
	dbc	0			; dummy entry to end list
	dac	10			; length gt 9 (scontinue)
	ejc
;
;      list of svblk pointers for keywords to be dumped. the
;      list is in the order which appears on the dump output.
;
vdmkw	dac	v_anc			; anchor
.if    .culc
	dac	v_cas			; ccase
.fi
	dac	v_cod			; code
.if    .ccmk
.if    .ccmc
	dac	v_com			; compare
.else
	dac	1			; compare not printed
.fi
.fi
	dac	v_dmp			; dump
	dac	v_erl			; errlimit
	dac	v_etx			; errtext
	dac	v_ert			; errtype
.if    .csfn
	dac	v_fil			; file
.fi
	dac	v_fnc			; fnclevel
	dac	v_ftr			; ftrace
	dac	v_fls			; fullscan
	dac	v_inp			; input
.if    .csfn
	dac	v_lfl			; lastfile
.fi
.if    .csln
	dac	v_lln			; lastline
.fi
	dac	v_lst			; lastno
.if    .csln
	dac	v_lin			; line
.fi
	dac	v_mxl			; maxlength
	dac	v_oup			; output
.if    .cnpf
.else
	dac	v_pfl			; profile
.fi
	dac	v_rtn			; rtntype
	dac	v_stc			; stcount
	dac	v_stl			; stlimit
	dac	v_stn			; stno
	dac	v_tra			; trace
	dac	v_trm			; trim
	dac	0			; end of list
;
;      table used by gtnvr to search svblk lists
;
vsrch	dac	0			; dummy entry to get proper indexing
	dac	v_eqf			; start of 1 char variables (none)
	dac	v_eqf			; start of 2 char variables
	dac	v_any			; start of 3 char variables
.if    .cmth
	dac	v_atn			; start of 4 char variables
.else
.if    .culc
	dac	v_cas			; start of 4 char variables
.else
	dac	v_chr			; start of 4 char variables
.fi
.fi
	dac	v_abe			; start of 5 char variables
	dac	v_anc			; start of 6 char variables
	dac	v_col			; start of 7 char variables
	dac	v_alp			; start of 8 char variables
.if    .cbsp
	dac	v_bsp			; start of 9 char variables
.else
	dac	v_pro			; start of 9 char variables
.fi
;
;      last location in constant section
;
c_yyy	dac	0			; last location in constant section
	ttl	s p i t b o l -- working storage section
;
;      the working storage section contains areas which are
;      changed during execution of the program. the value
;      assembled is the initial value before execution starts.
;
;      all these areas are fixed length areas. variable length
;      data is stored in the static or dynamic regions of the
;      allocated data areas.
;
;      the values in this area are described either as work
;      areas or as global values. a work area is used in an
;      ephemeral manner and the value is not saved from one
;      entry into a routine to another. a global value is a
;      less temporary location whose value is saved from one
;      call to another.
;
;      w_aaa marks the start of the working section whilst
;      w_yyy marks its end.  g_aaa marks the division between
;      temporary and global values.
;
;      global values are further subdivided to facilitate
;      processing by the garbage collector. r_aaa through
;      r_yyy are global values that may point into dynamic
;      storage and hence must be relocated after each garbage
;      collection.  they also serve as root pointers to all
;      allocated data that must be preserved.  pointers between
;      a_aaa and r_aaa may point into code, static storage,
;      or mark the limits of dynamic memory.  these pointers
;      must be adjusted when the working section is saved to a
;      file and subsequently reloaded at a different address.
;
;      a general part of the approach in this program is not
;      to overlap work areas between procedures even though a
;      small amount of space could be saved. such overlap is
;      considered a source of program errors and decreases the
;      information left behind after a system crash of any kind.
;
;      the names of these locations are labels with five letter
;      (a-y,_) names. as far as possible the order is kept
;      alphabetical by these names but in some cases there
;      are slight departures caused by other order requirements.
;
;      unless otherwise documented, the order of work areas
;      does not affect the execution of the spitbol program.
;
	sec				; start of working storage section
	ejc
;
;      this area is not cleared by initial code
;
cmlab	dac	b_scl			; string used to check label legality
	dac	2			;
	dtc	/  /
;
;      label to mark start of work area
;
w_aaa	dac	0			;
;
;      work areas for acess procedure
;
actrm	dac	0			; trim indicator
;
;      work areas for alloc procedure
;
aldyn	dac	0			; amount of dynamic store
allia	dic	+0			; dump ia
allsv	dac	0			; save wb in alloc
;
;      work areas for alost procedure
;
alsta	dac	0			; save wa in alost
;
;      work areas for array function (s_arr)
;
arcdm	dac	0			; count dimensions
arnel	dic	+0			; count elements
arptr	dac	0			; offset ptr into arblk
arsvl	dic	+0			; save integer low bound
	ejc
;
;      work areas for arref routine
;
arfsi	dic	+0			; save current evolving subscript
arfxs	dac	0			; save base stack pointer
;
;      work areas for b_efc block routine
;
befof	dac	0			; save offset ptr into efblk
;
;      work areas for b_pfc block routine
;
bpfpf	dac	0			; save pfblk pointer
bpfsv	dac	0			; save old function value
bpfxt	dac	0			; pointer to stacked arguments
;
;      work area for collect function (s_col)
;
clsvi	dic	+0			; save integer argument
;
;      work areas value for cncrd
;
cnscc	dac	0			; pointer to control card string
cnswc	dac	0			; word count
cnr_t	dac	0			; pointer to r_ttl or r_stl
;
;      work areas for convert function (s_cnv)
;
cnvtp	dac	0			; save ptr into scvtb
;
;      work areas for data function (s_dat)
;
datdv	dac	0			; save vrblk ptr for datatype name
datxs	dac	0			; save initial stack pointer
;
;      work areas for define function (s_def)
;
deflb	dac	0			; save vrblk ptr for label
defna	dac	0			; count function arguments
defvr	dac	0			; save vrblk ptr for function name
defxs	dac	0			; save initial stack pointer
;
;      work areas for dumpr procedure
;
dmarg	dac	0			; dump argument
dmpsa	dac	0			; preserve wa over prtvl call
.if    .ccmk
dmpsb	dac	0			; preserve wb over syscm call
.fi
dmpsv	dac	0			; general scratch save
dmvch	dac	0			; chain pointer for variable blocks
dmpch	dac	0			; save sorted vrblk chain pointer
dmpkb	dac	0			; dummy kvblk for use in dumpr
dmpkt	dac	0			; kvvar trblk ptr (must follow dmpkb)
dmpkn	dac	0			; keyword number (must follow dmpkt)
;
;      work area for dtach
;
dtcnb	dac	0			; name base
dtcnm	dac	0			; name ptr
;
;      work areas for dupl function (s_dup)
;
dupsi	dic	+0			; store integer string length
;
;      work area for endfile (s_enf)
;
enfch	dac	0			; for iochn chain head
	ejc
;
;      work areas for ertex
;
ertwa	dac	0			; save wa
ertwb	dac	0			; save wb
;
;      work areas for evali
;
evlin	dac	0			; dummy pattern block pcode
evlis	dac	0			; then node (must follow evlin)
evliv	dac	0			; value of parm1 (must follow evlis)
evlio	dac	0			; ptr to original node
evlif	dac	0			; flag for simple/complex argument
;
;      work area for expan
;
expsv	dac	0			; save op dope vector pointer
;
;      work areas for gbcol procedure
;
gbcfl	dac	0			; garbage collector active flag
gbclm	dac	0			; pointer to last move block (pass 3)
gbcnm	dac	0			; dummy first move block
gbcns	dac	0			; rest of dummy block (follows gbcnm)
.if    .csed
.if    .cepp
.else
gbcmk	dac	0			; bias when marking entry point
.fi
gbcia	dic	+0			; dump ia
gbcsd	dac	0			; first address beyond sediment
gbcsf	dac	0			; free space within sediment
.fi
gbsva	dac	0			; save wa
gbsvb	dac	0			; save wb
gbsvc	dac	0			; save wc
;
;      work areas for gtnvr procedure
;
gnvhe	dac	0			; ptr to end of hash chain
gnvnw	dac	0			; number of words in string name
gnvsa	dac	0			; save wa
gnvsb	dac	0			; save wb
gnvsp	dac	0			; pointer into vsrch table
gnvst	dac	0			; pointer to chars of string
;
;      work areas for gtarr
;
gtawa	dac	0			; save wa
;
;      work areas for gtint
;
gtina	dac	0			; save wa
gtinb	dac	0			; save wb
	ejc
;
;      work areas for gtnum procedure
;
gtnnf	dac	0			; zero/nonzero for result +/-
gtnsi	dic	+0			; general integer save
.if    .cnra
.else
gtndf	dac	0			; 0/1 for dec point so far no/yes
gtnes	dac	0			; zero/nonzero exponent +/-
gtnex	dic	+0			; real exponent
gtnsc	dac	0			; scale (places after point)
gtnsr	drc	+0.0			; general real save
gtnrd	dac	0			; flag for ok real number
.fi
;
;      work areas for gtpat procedure
;
gtpsb	dac	0			; save wb
;
;      work areas for gtstg procedure
;
gtssf	dac	0			; 0/1 for result +/-
gtsvc	dac	0			; save wc
gtsvb	dac	0			; save wb
.if    .cnra
.else
.if    .cncr
.else
gtses	dac	0			; char + or - for exponent +/-
gtsrs	drc	+0.0			; general real save
.fi
.fi
;
;      work areas for gtvar procedure
;
gtvrc	dac	0			; save wc
.if    .cnbf
.else
;
;      work areas for insbf
;
insab	dac	0			; entry wa + entry wb
insln	dac	0			; length of insertion string
inssa	dac	0			; save entry wa
inssb	dac	0			; save entry wb
inssc	dac	0			; save entry wc
.fi
;
;      work areas for ioput
;
ioptt	dac	0			; type of association
.if    .cnld
.else
;
;      work areas for load function
;
lodfn	dac	0			; pointer to vrblk for func name
lodna	dac	0			; count number of arguments
.fi
;
;      mxint is value of maximum positive integer. it is computed at runtime to allow
;      the compilation of spitbol on a machine with smaller word size the the target.
;
mxint	dac	0			;
.if    .cnpf
.else
;
;      work area for profiler
;
pfsvw	dac	0			; to save a w-reg
.fi
;
;      work areas for prtnm procedure
;
prnsi	dic	+0			; scratch integer loc
;
;      work areas for prtsn procedure
;
prsna	dac	0			; save wa
;
;      work areas for prtst procedure
;
prsva	dac	0			; save wa
prsvb	dac	0			; save wb
prsvc	dac	0			; save char counter
;
;      work area for prtnl
;
prtsa	dac	0			; save wa
prtsb	dac	0			; save wb
;
;      work area for prtvl
;
prvsi	dac	0			; save idval
;
;      work areas for pattern match routines
;
psave	dac	0			; temporary save for current node ptr
psavc	dac	0			; save cursor in p_spn, p_str
.if    .crel
;
;      work area for relaj routine
;
rlals	dac	0			; ptr to list of bounds and adjusts
;
;      work area for reldn routine
;
rldcd	dac	0			; save code adjustment
rldst	dac	0			; save static adjustment
rldls	dac	0			; save list pointer
.fi
;
;      work areas for retrn routine
;
rtnbp	dac	0			; to save a block pointer
rtnfv	dac	0			; new function value (result)
rtnsv	dac	0			; old function value (saved value)
;
;      work areas for substr function (s_sub)
;
sbssv	dac	0			; save third argument
;
;      work areas for scan procedure
;
scnsa	dac	0			; save wa
scnsb	dac	0			; save wb
scnsc	dac	0			; save wc
scnof	dac	0			; save offset
.if    .cnsr
.else
	ejc
;
;      work area used by sorta, sortc, sortf, sorth
;
srtdf	dac	0			; datatype field name
srtfd	dac	0			; found dfblk address
srtff	dac	0			; found field name
srtfo	dac	0			; offset to field name
srtnr	dac	0			; number of rows
srtof	dac	0			; offset within row to sort key
srtrt	dac	0			; root offset
srts1	dac	0			; save offset 1
srts2	dac	0			; save offset 2
srtsc	dac	0			; save wc
srtsf	dac	0			; sort array first row offset
srtsn	dac	0			; save n
srtso	dac	0			; offset to a(0)
srtsr	dac	0			; 0, non-zero for sort, rsort
srtst	dac	0			; stride from one row to next
srtwc	dac	0			; dump wc
.fi
;
;      work areas for stopr routine
;
stpsi	dic	+0			; save value of stcount
stpti	dic	+0			; save time elapsed
;
;      work areas for tfind procedure
;
tfnsi	dic	+0			; number of headers
;
;      work areas for xscan procedure
;
xscrt	dac	0			; save return code
xscwb	dac	0			; save register wb
;
;      start of global values in working section
;
g_aaa	dac	0			;
;
;      global value for alloc procedure
;
alfsf	dic	+0			; factor in free store pcntage check
;
;      global values for cmpil procedure
;
cmerc	dac	0			; count of initial compile errors
cmpln	dac	0			; line number of first line of stmt
cmpxs	dac	0			; save stack ptr in case of errors
cmpsn	dac	1			; number of next statement to compile
;
;      global values for cncrd
;
.if    .cinc
cnsil	dac	0			; save scnil during include process.
cnind	dac	0			; current include file nest level
cnspt	dac	0			; save scnpt during include process.
.fi
cnttl	dac	0			; flag for -title, -stitl
;
;      global flag for suppression of compilation statistics.
;
cpsts	dac	0			; suppress comp. stats if non zero
;
;      global values for control card switches
;
cswdb	dac	0			; 0/1 for -single/-double
cswer	dac	0			; 0/1 for -errors/-noerrors
cswex	dac	0			; 0/1 for -execute/-noexecute
cswfl	dac	1			; 0/1 for -nofail/-fail
cswin	dac	iniln			; xxx for -inxxx
cswls	dac	1			; 0/1 for -nolist/-list
cswno	dac	0			; 0/1 for -optimise/-noopt
cswpr	dac	0			; 0/1 for -noprint/-print
;
;      global location used by patst procedure
;
ctmsk	dbc	0			; last bit position used in r_ctp
curid	dac	0			; current id value
	ejc
;
;      global value for cdwrd procedure
;
cwcof	dac	0			; next word offset in current ccblk
.if    .csed
;
;      global locations for dynamic storage pointers
;
dnams	dac	0			; size of sediment in baus
.fi
;
;      global area for error processing.
;
erich	dac	0			; copy error reports to int.chan if 1
erlst	dac	0			; for listr when errors go to int.ch.
errft	dac	0			; fatal error flag
errsp	dac	0			; error suppression flag
;
;      global flag for suppression of execution stats
;
exsts	dac	0			; suppress exec stats if set
;
;      global values for exfal and return
;
flprt	dac	0			; location of fail offset for return
flptr	dac	0			; location of failure offset on stack
;
;      global location to count garbage collections (gbcol)
;
.if    .csed
gbsed	dic	+0			; factor in sediment pcntage check
.fi
gbcnt	dac	0			; count of garbage collections
;
;      global value for gtcod and gtexp
;
gtcef	dac	0			; save fail ptr in case of error
;
;      global locations for gtstg procedure
;
.if    .cnra
.else
.if    .cncr
.else
gtsrn	drc	+0.0			; rounding factor 0.5*10**-cfp_s
gtssc	drc	+0.0			; scaling value 10**cfp_s
.fi
.fi
gtswk	dac	0			; ptr to work area for gtstg
;
;      global flag for header printing
;
headp	dac	0			; header printed flag
;
;      global values for variable hash table
;
hshnb	dic	+0			; number of hash buckets
;
;      global areas for init
;
initr	dac	0			; save terminal flag
	ejc
;
;      global values for keyword values which are stored as one
;      word integers. these values must be assembled in the
;      following order (as dictated by k_xxx definition values).
;
kvabe	dac	0			; abend
kvanc	dac	0			; anchor
.if    .culc
kvcas	dac	0			; case
.fi
kvcod	dac	0			; code
.if    .ccmk
kvcom	dac	0			; compare
.fi
kvdmp	dac	0			; dump
kverl	dac	0			; errlimit
kvert	dac	0			; errtype
kvftr	dac	0			; ftrace
kvfls	dac	1			; fullscan
kvinp	dac	1			; input
kvmxl	dac	5000			; maxlength
kvoup	dac	1			; output
.if    .cnpf
.else
kvpfl	dac	0			; profile
.fi
kvtra	dac	0			; trace
kvtrm	dac	0			; trim
kvfnc	dac	0			; fnclevel
kvlst	dac	0			; lastno
.if    .csln
kvlln	dac	0			; lastline
kvlin	dac	0			; line
.fi
kvstn	dac	0			; stno
;
;      global values for other keywords
;
kvalp	dac	0			; alphabet
kvrtn	dac	nulls			; rtntype (scblk pointer)
.if    .cs16
kvstl	dic	+32767			; stlimit
kvstc	dic	+32767			; stcount (counts down from stlimit)
.else
.if    .cs32
kvstl	dic	+2147483647		; stlimit
kvstc	dic	+2147483647		; stcount (counts down from stlimit)
.else
kvstl	dic	+50000			; stlimit
kvstc	dic	+50000			; stcount (counts down from stlimit)
.fi
.fi
;
;      global values for listr procedure
;
.if    .cinc
lstid	dac	0			; include depth of current image
.fi
lstlc	dac	0			; count lines on source list page
lstnp	dac	0			; max number of lines on page
lstpf	dac	1			; set nonzero if current image listed
lstpg	dac	0			; current source list page number
lstpo	dac	0			; offset to   page nnn	 message
lstsn	dac	0			; remember last stmnum listed
;
;      global maximum size of spitbol objects
;
mxlen	dac	0			; initialised by sysmx call
;
;      global execution control variable
;
noxeq	dac	0			; set non-zero to inhibit execution
.if    .cnpf
.else
;
;      global profiler values locations
;
pfdmp	dac	0			; set non-0 if &profile set non-0
pffnc	dac	0			; set non-0 if funct just entered
pfstm	dic	+0			; to store starting time of stmt
pfetm	dic	+0			; to store ending time of stmt
pfnte	dac	0			; nr of table entries
pfste	dic	+0			; gets int rep of table entry size
.fi
;
	ejc
;
;      global values used in pattern match routines
;
pmdfl	dac	0			; pattern assignment flag
pmhbs	dac	0			; history stack base pointer
pmssl	dac	0			; length of subject string in chars
.if    .cpol
;
;      global values for interface polling (syspl)
;
polcs	dac	1			; poll interval start value
polct	dac	1			; poll interval counter
.fi
;
;      global flags used for standard file listing options
;
prich	dac	0			; printer on interactive channel
prstd	dac	0			; tested by prtpg
prsto	dac	0			; standard listing option flag
;
;      global values for print procedures
;
prbuf	dac	0			; ptr to print bfr in static
precl	dac	0			; extended/compact listing flag
prlen	dac	0			; length of print buffer in chars
prlnw	dac	0			; length of print buffer in words
profs	dac	0			; offset to next location in prbuf
prtef	dac	0			; endfile flag
	ejc
;
;      global area for readr
;
rdcln	dac	0			; current statement line number
rdnln	dac	0			; next statement line number
;
;      global amount of memory reserved for end of execution
;
rsmem	dac	0			; reserve memory
;
;      global area for stmgo counters
;
stmcs	dac	1			; counter startup value
stmct	dac	1			; counter active value
;
;      adjustable global values
;
;      all the pointers in this section can point to the
;      dynamic or the static region.
;      when a save file is reloaded, these pointers must
;      be adjusted if static or dynamic memory is now
;      at a different address.	see routine reloc for
;      additional information.
;
;      some values cannot be move here because of adjacency
;      constraints.  they are handled specially by reloc et al.
;      these values are kvrtn,
;
;      values gtswk, kvalp, and prbuf are reinitialized by
;      procedure insta, and do not need to appear here.
;
;      values flprt, flptr, gtcef, and stbas point into the
;      stack and are explicitly adjusted by osint's restart
;      procedure.
;
a_aaa	dac	0			; start of adjustable values
cmpss	dac	0			; save subroutine stack ptr
dnamb	dac	0			; start of dynamic area
dnamp	dac	0			; next available loc in dynamic area
dname	dac	0			; end of available dynamic area
hshtb	dac	0			; pointer to start of vrblk hash tabl
hshte	dac	0			; pointer past end of vrblk hash tabl
iniss	dac	0			; save subroutine stack ptr
pftbl	dac	0			; gets adrs of (imag) table base
prnmv	dac	0			; vrblk ptr from last name search
statb	dac	0			; start of static area
state	dac	0			; end of static area
stxvr	dac	nulls			; vrblk pointer or null

;
;      relocatable global values
;
;      all the pointers in this section can point to blocks in
;      the dynamic storage area and must be relocated by the
;      garbage collector. they are identified by r_xxx names.
;
r_aaa	dac	0			; start of relocatable values
r_arf	dac	0			; array block pointer for arref
r_ccb	dac	0			; ptr to ccblk being built (cdwrd)
r_cim	dac	0			; ptr to current compiler input str
r_cmp	dac	0			; copy of r_cim used in cmpil
r_cni	dac	0			; ptr to next compiler input string
r_cnt	dac	0			; cdblk pointer for setexit continue
r_cod	dac	0			; pointer to current cdblk or exblk
r_ctp	dac	0			; ptr to current ctblk for patst
r_cts	dac	0			; ptr to last string scanned by patst
r_ert	dac	0			; trblk pointer for errtype trace
r_etx	dac	nulls			; pointer to errtext string
r_exs	dac	0			; = save xl in expdm
r_fcb	dac	0			; fcblk chain head
r_fnc	dac	0			; trblk pointer for fnclevel trace
r_gtc	dac	0			; keep code ptr for gtcod,gtexp
.if    .cinc
r_ici	dac	0			; saved r_cim during include process.
.if    .csfn
r_ifa	dac	0			; array of file names by incl. depth
r_ifl	dac	0			; array of line nums by include depth
.fi
r_ifn	dac	0			; last include file name
r_inc	dac	0			; table of include file names seen
.fi
r_io1	dac	0			; file arg1 for ioput
r_io2	dac	0			; file arg2 for ioput
r_iof	dac	0			; fcblk ptr or 0
r_ion	dac	0			; name base ptr
r_iop	dac	0			; predecessor block ptr for ioput
r_iot	dac	0			; trblk ptr for ioput
.if    .cnbf
.else
r_pmb	dac	0			; buffer ptr in pattern match
.fi
r_pms	dac	0			; subject string ptr in pattern match
r_ra2	dac	0			; replace second argument last time
r_ra3	dac	0			; replace third argument last time
r_rpt	dac	0			; ptr to ctblk replace table last usd
r_scp	dac	0			; save pointer from last scane call
.if    .csfn
r_sfc	dac	nulls			; current source file name
r_sfn	dac	0			; ptr to source file name table
.fi
r_sxl	dac	0			; preserve xl in sortc
r_sxr	dac	0			; preserve xr in sorta/sortc
r_stc	dac	0			; trblk pointer for stcount trace
r_stl	dac	0			; source listing sub-title
r_sxc	dac	0			; code (cdblk) ptr for setexit trap
r_ttl	dac	nulls			; source listing title
r_xsc	dac	0			; string pointer for xscan
	ejc
;
;      the remaining pointers in this list are used to point
;      to function blocks for normally undefined operators.
;
r_uba	dac	stndo			; binary at
r_ubm	dac	stndo			; binary ampersand
r_ubn	dac	stndo			; binary number sign
r_ubp	dac	stndo			; binary percent
r_ubt	dac	stndo			; binary not
r_uub	dac	stndo			; unary vertical bar
r_uue	dac	stndo			; unary equal
r_uun	dac	stndo			; unary number sign
r_uup	dac	stndo			; unary percent
r_uus	dac	stndo			; unary slash
r_uux	dac	stndo			; unary exclamation
r_yyy	dac	0			; last relocatable location
;
;      global locations used in scan procedure
;
scnbl	dac	0			; set non-zero if scanned past blanks
scncc	dac	0			; non-zero to scan control card name
scngo	dac	0			; set non-zero to scan goto field
scnil	dac	0			; length of current input image
scnpt	dac	0			; pointer to next location in r_cim
scnrs	dac	0			; set non-zero to signal rescan
scnse	dac	0			; start of current element
scntp	dac	0			; save syntax type from last call
;
;      global value for indicating stage (see error section)
;
stage	dac	0			; initial value = initial compile
	ejc
;
;      global stack pointer
;
stbas	dac	0			; pointer past stack base
;
;      global values for setexit function (s_stx)
;
stxoc	dac	0			; code pointer offset
stxof	dac	0			; failure offset
;
;      global value for time keeping
;
timsx	dic	+0			; time at start of execution
timup	dac	0			; set when time up occurs
;
;      global values for xscan and xscni procedures
;
xsofs	dac	0			; offset to current location in r_xsc
;
;      label to mark end of working section
;
w_yyy	dac	0			;
	ttl	s p i t b o l -- minimal code
	sec				; start of program section
s_aaa	ent	bl__i			; mark start of code
.if    .crel
	ttl	s p i t b o l -- relocation
;
;      relocation
;      the following section provides services to osint to
;      relocate portions of the workspace.  it is used when
;      a saved memory image must be restarted at a different
;      location.
;
;      relaj -- relocate a list of pointers
;
;      (wa)		     ptr past last pointer of list
;      (wb)		     ptr to first pointer of list
;      (xl)		     list of boundaries and adjustments
;      jsr  relaj	     call to process list of pointers
;      (wb)		     destroyed
;
relaj	prc	e,0			; entry point
	mov	-(xs),xr		; save xr
	mov	-(xs),wa		; save wa
	mov	rlals,xl		; save ptr to list of bounds
	mov	xr,wb			; ptr to first pointer to process
;
;      merge here to check if done
;
rlaj0	mov	xl,rlals		; restore xl
	bne	xr,(xs),rlaj1		; proceed if more to do
	mov	wa,(xs)+		; restore wa
	mov	xr,(xs)+		; restore xr
	exi				; return to caller
;
;      merge here to process next pointer on list
;
rlaj1	mov	wa,(xr)			; load next pointer on list
	lct	wb,=rnsi_		; number of sections of adjusters
;
;      merge here to process next section of stack list
;
rlaj2	bgt	wa,rlend(xl),rlaj3	; ok if past end of section
	blt	wa,rlstr(xl),rlaj3	; or if before start of section
	add	wa,rladj(xl)		; within section, add adjustment
	mov	(xr),wa			; return updated ptr to memory
	brn	rlaj4			; done with this pointer
;
;      here if not within section
;
rlaj3	add	xl,*rssi_		; advance to next section
	bct	wb,rlaj2		; jump if more to go
;
;      here when finished processing one pointer
;
rlaj4	ica	xr			; increment to next ptr on list
	brn	rlaj0			; jump to check	 for completion
	enp				; end procedure relaj
	ejc
;
;      relcr -- create relocation info after save file reload
;
;      (wa)		     original s_aaa code section adr
;      (wb)		     original c_aaa constant section adr
;      (wc)		     original g_aaa working section adr
;      (xr)		     ptr to start of static region
;      (cp)		     ptr to start of dynamic region
;      (xl)		     ptr to area to receive information
;      jsr  relcr	     create relocation information
;      (wa,wb,wc,xr)	     destroyed
;
;      a block of information is built at (xl) that is used
;      in relocating pointers.	there are rnsi_ instances
;      of a rssi_ word structure.  each instance corresponds
;      to one of the regions that a pointer might point into.
;      the layout of this structure is shown in the definitions
;      section, together with symbolic definitions of the
;      entries as offsets from xl.
;
relcr	prc	e,0			; entry point
	add	xl,*rlsi_		; point past build area
	mov	-(xl),wa		; save original code address
	mov	wa,=s_aaa		; compute adjustment
	sub	wa,(xl)			; as new s_aaa minus original s_aaa
	mov	-(xl),wa		; save code adjustment
	mov	wa,=s_yyy		; end of target code section
	sub	wa,=s_aaa		; length of code section
	add	wa,num01(xl)		; plus original start address
	mov	-(xl),wa		; end of original code section
	mov	-(xl),wb		; save constant section address
	mov	wb,=c_aaa		; start of constants section
	mov	wa,=c_yyy		; end of constants section
	sub	wa,wb			; length of constants section
	sub	wb,(xl)			; new c_aaa minus original c_aaa
	mov	-(xl),wb		; save constant adjustment
	add	wa,num01(xl)		; length plus original start adr
	mov	-(xl),wa		; save as end of original constants
	mov	-(xl),wc		; save working globals address
	mov	wc,=g_aaa		; start of working globals section
	mov	wa,=w_yyy		; end of working section
	sub	wa,wc			; length of working globals
	sub	wc,(xl)			; new g_aaa minus original g_aaa
	mov	-(xl),wc		; save working globals adjustment
	add	wa,num01(xl)		; length plus original start adr
	mov	-(xl),wa		; save as end of working globals
	mov	wb,statb		; old start of static region
	mov	-(xl),wb		; save
	sub	xr,wb			; compute adjustment
	mov	-(xl),xr		; save new statb minus old statb
	mov	-(xl),state		; old end of static region
	mov	wb,dnamb		; old start of dynamic region
	mov	-(xl),wb		; save
	scp	wa			; new start of dynamic
	sub	wa,wb			; compute adjustment
	mov	-(xl),wa		; save new dnamb minus old dnamb
	mov	wc,dnamp		; old end of dynamic region in use
	mov	-(xl),wc		; save as end of old dynamic region
	exi
	enp
	ejc
;
;      reldn -- relocate pointers in the dynamic region
;
;      (xl)		     list of boundaries and adjustments
;      (xr)		     ptr to first location to process
;      (wc)		     ptr past last location to process
;      jsr  reldn	     call to process blocks in dynamic
;      (wa,wb,wc,xr)	     destroyed
;
;      processes all blocks in the dynamic region.  within a
;      block, pointers to the code section, constant section,
;      working globals section, static region, and dynamic
;      region are relocated as needed.
;
reldn	prc	e,0			; entry point
	mov	rldcd,rlcda(xl)		; save code adjustment
	mov	rldst,rlsta(xl)		; save static adjustment
	mov	rldls,xl		; save list pointer
;
;      merge here to process the next block in dynamic
;
rld01	add	(xr),rldcd		; adjust block type word
	mov	xl,(xr)			; load block type word
	lei	xl			; load entry point id (bl_xx)
;
;      block type switch. note that blocks with no relocatable
;      fields just return to rld05 to continue to next block.
;
;      note that dfblks do not appear in dynamic, only in static.
;      ccblks and cmblks are not live when a save file is
;      created, and can be skipped.
;
;      further note:  static blocks other than vrblks discovered
;      while scanning dynamic must be adjusted at this time.
;      see processing of ffblk for example.
;
	ejc
;
;      reldn (continued)
;
	bsw	xl,bl___		; switch on block type
	iff	bl_ar,rld03		; arblk
.if    .cnbf
	iff	bl_bc,rld05		; bcblk - dummy to fill out iffs
.else
	iff	bl_bc,rld06		; bcblk
.fi
	iff	bl_bf,rld05		; bfblk
	iff	bl_cc,rld05		; ccblk
	iff	bl_cd,rld07		; cdblk
	iff	bl_cm,rld05		; cmblk
	iff	bl_ct,rld05		; ctblk
	iff	bl_df,rld05		; dfblk
	iff	bl_ef,rld08		; efblk
	iff	bl_ev,rld09		; evblk
	iff	bl_ex,rld10		; exblk
	iff	bl_ff,rld11		; ffblk
	iff	bl_ic,rld05		; icblk
	iff	bl_kv,rld13		; kvblk
	iff	bl_nm,rld13		; nmblk
	iff	bl_p0,rld13		; p0blk
	iff	bl_p1,rld14		; p1blk
	iff	bl_p2,rld14		; p2blk
	iff	bl_pd,rld15		; pdblk
	iff	bl_pf,rld16		; pfblk
.if    .cnra
.else
	iff	bl_rc,rld05		; rcblk
.fi
	iff	bl_sc,rld05		; scblk
	iff	bl_se,rld13		; seblk
	iff	bl_tb,rld17		; tbblk
	iff	bl_te,rld18		; teblk
	iff	bl_tr,rld19		; trblk
	iff	bl_vc,rld17		; vcblk
	iff	bl_xn,rld05		; xnblk
	iff	bl_xr,rld20		; xrblk
	esw				; end of jump table
;
;      arblk
;
rld03	mov	wa,arlen(xr)		; load length
	mov	wb,arofs(xr)		; set offset to 1st reloc fld (arpro)
;
;      merge here to process pointers in a block
;
;      (xr)		     ptr to current block
;      (wc)		     ptr past last location to process
;      (wa)		     length (reloc flds + flds at start)
;      (wb)		     offset to first reloc field
;
rld04	add	wa,xr			; point past last reloc field
	add	wb,xr			; point to first reloc field
	mov	xl,rldls		; point to list of bounds
	jsr	relaj			; adjust pointers
	ejc
;
;      reldn (continued)
;
;
;      merge here to advance to next block
;
;      (xr)		     ptr to current block
;      (wc)		     ptr past last location to process
;
rld05	mov	wa,(xr)			; block type word
	jsr	blkln			; get length of block
	add	xr,wa			; point to next block
	blt	xr,wc,rld01		; continue if more to process
	mov	xl,rldls		; restore xl
	exi				; return to caller if done
.if    .cnbf
.else
;
;      bcblk
;
rld06	mov	wa,*bcsi_		; set length
	mov	wb,*bcbuf		; and offset
	brn	rld04			; all set
.fi
;
;      cdblk
;
rld07	mov	wa,cdlen(xr)		; load length
	mov	wb,*cdfal		; set offset
	bne	(xr),=b_cdc,rld04	; jump back if not complex goto
	mov	wb,*cdcod		; do not process cdfal word
	brn	rld04			; jump back
;
;      efblk
;
;      if the efcod word points to an xnblk, the xnblk type
;      word will not be adjusted.  since this is implementation
;      dependent, we will not worry about it.
;
rld08	mov	wa,*efrsl		; set length
	mov	wb,*efcod		; and offset
	brn	rld04			; all set
;
;      evblk
;
rld09	mov	wa,*offs3		; point past third field
	mov	wb,*evexp		; set offset
	brn	rld04			; all set
;
;      exblk
;
rld10	mov	wa,exlen(xr)		; load length
	mov	wb,*exflc		; set offset
	brn	rld04			; jump back
	ejc
;
;      reldn (continued)
;
;
;      ffblk
;
;      this block contains a ptr to a dfblk in the static rgn.
;      because there are multiple ffblks pointing to the same
;      dfblk (one for each field name), we only process the
;      dfblk when we encounter the ffblk for the first field.
;      the dfblk in turn contains a pointer to an scblk within
;      static.
;
rld11	bne	ffofs(xr),*pdfld,rld12	; skip dfblk if not first field
	mov	-(xs),xr		; save xr
	mov	xr,ffdfp(xr)		; load old ptr to dfblk
	add	xr,rldst		; current location of dfblk
	add	(xr),rldcd		; adjust dfblk type word
	mov	wa,dflen(xr)		; length of dfblk
	mov	wb,*dfnam		; offset to dfnam field
	add	wa,xr			; point past last reloc field
	add	wb,xr			; point to first reloc field
	mov	xl,rldls		; point to list of bounds
	jsr	relaj			; adjust pointers
	mov	xr,dfnam(xr)		; pointer to static scblk
	add	(xr),rldcd		; adjust scblk type word
	mov	xr,(xs)+		; restore ffblk pointer
;
;      ffblk (continued)
;
;      merge here to set up for adjustment of ptrs in ffblk
;
rld12	mov	wa,*ffofs		; set length
	mov	wb,*ffdfp		; set offset
	brn	rld04			; all set
;
;      kvblk, nmblk, p0blk, seblk
;
rld13	mov	wa,*offs2		; point past second field
	mov	wb,*offs1		; offset is one (only reloc fld is 2)
	brn	rld04			; all set
;
;      p1blk, p2blk
;
;      in p2blks, parm2 contains either a bit mask or the
;      name offset of a variable.  it never requires relocation.
;
rld14	mov	wa,*parm2		; length (parm2 is non-relocatable)
	mov	wb,*pthen		; set offset
	brn	rld04			; all set
;
;      pdblk
;
;      note that the dfblk pointed to by this pdblk was
;      processed when the ffblk was encountered.  because
;      the data function will be called before any records are
;      defined, the ffblk is encountered before any
;      corresponding pdblk.
;
rld15	mov	xl,pddfp(xr)		; load ptr to dfblk
	add	xl,rldst		; adjust for static relocation
	mov	wa,dfpdl(xl)		; get pdblk length
	mov	wb,*pddfp		; set offset
	brn	rld04			; all set
	ejc
;
;      reldn (continued)
;
;
;      pfblk
;
rld16	add	pfvbl(xr),rldst		; adjust non-contiguous field
	mov	wa,pflen(xr)		; get pfblk length
	mov	wb,*pfcod		; offset to first reloc
	brn	rld04			; all set
;
;      tbblk, vcblk
;
rld17	mov	wa,offs2(xr)		; load length
	mov	wb,*offs3		; set offset
	brn	rld04			; jump back
;
;      teblk
;
rld18	mov	wa,*tesi_		; set length
	mov	wb,*tesub		; and offset
	brn	rld04			; all set
;
;      trblk
;
rld19	mov	wa,*trsi_		; set length
	mov	wb,*trval		; and offset
	brn	rld04			; all set
;
;      xrblk
;
rld20	mov	wa,xrlen(xr)		; load length
	mov	wb,*xrptr		; set offset
	brn	rld04			; jump back
	enp				; end procedure reldn
	ejc
;
;      reloc -- relocate storage after save file reload
;
;      (xl)		     list of boundaries and adjustments
;      jsr  reloc	     relocate all pointers
;      (wa,wb,wc,xr)	     destroyed
;
;      the list of boundaries and adjustments pointed to by
;      register xl is created by a call to relcr, which should
;      be consulted for information on its structure.
;
reloc	prc	e,0			; entry point
	mov	xr,rldys(xl)		; old start of dynamic
	mov	wc,rldye(xl)		; old end of dynamic
	add	xr,rldya(xl)		; create new start of dynamic
	add	wc,rldya(xl)		; create new end of dynamic
	jsr	reldn			; relocate pointers in dynamic
	jsr	relws			; relocate pointers in working sect
	jsr	relst			; relocate pointers in static
	exi				; return to caller
	enp				; end procedure reloc
	ejc
;
;      relst -- relocate pointers in the static region
;
;      (xl)		     list of boundaries and adjustments
;      jsr  relst	     call to process blocks in static
;      (wa,wb,wc,xr)	     destroyed
;
;      only vrblks on the hash chain and any profile block are
;      processed.  other static blocks (dfblks) are processed
;      during processing of dynamic blocks.
;
;      global work locations will be processed at this point,
;      so pointers there can be relied upon.
;
relst	prc	e,0			; entry point
	mov	xr,pftbl		; profile table
	bze	xr,rls01		; branch if no table allocated
	add	(xr),rlcda(xl)		; adjust block type word
;
;      here after dealing with profiler
;
rls01	mov	wc,hshtb		; point to start of hash table
	mov	wb,wc			; point to first hash bucket
	mov	wa,hshte		; point beyond hash table
	jsr	relaj			; adjust bucket pointers
;
;      loop through slots in hash table
;
rls02	beq	wc,hshte,rls05		; done if none left
	mov	xr,wc			; else copy slot pointer
	ica	wc			; bump slot pointer
	sub	xr,*vrnxt		; set offset to merge into loop
;
;      loop through vrblks on one hash chain
;
rls03	mov	xr,vrnxt(xr)		; point to next vrblk on chain
	bze	xr,rls02		; jump for next bucket if chain end
	mov	wa,*vrlen		; offset of first loc past ptr fields
	mov	wb,*vrget		; offset of first location in vrblk
	bnz	vrlen(xr),rls04		; jump if not system variable
	mov	wa,*vrsi_		; offset to include vrsvp field
;
;      merge here to process fields of vrblk
;
rls04	add	wa,xr			; create end ptr
	add	wb,xr			; create start ptr
	jsr	relaj			; adjust pointers in vrblk
	brn	rls03			; check for another vrblk on chain
;
;      here when all vrblks processed
;
rls05	exi				; return to caller
	enp				; end procedure relst
	ejc
;
;      relws -- relocate pointers in the working section
;
;      (xl)		     list of boundaries and adjustments
;      jsr  relws	     call to process working section
;      (wa,wb,wc,xr)	     destroyed
;
;      pointers between a_aaa and r_yyy are examined and
;      adjusted if necessary.  the pointer kvrtn is also
;      adjusted although it lies outside this range.
;      dname is explicitly adjusted because the limits
;      on dynamic region in stack are to the area actively
;      in use (between dnamb and dnamp), and dname is outside
;      this range.
;
relws	prc	e,0			; entry point
	mov	wb,=a_aaa		; point to start of adjustables
	mov	wa,=r_yyy		; point to end of adjustables
	jsr	relaj			; relocate adjustable pointers
	add	dname,rldya(xl)		; adjust ptr missed by relaj
	mov	wb,=kvrtn		; case of kvrtn
	mov	wa,wb			; handled specially
	ica	wa			; one value to adjust
	jsr	relaj			; adjust kvrtn
	exi				; return to caller
	enp				; end procedure relws
.fi
	ttl	s p i t b o l -- initialization
;
;      initialisation
;      the following section receives control from the system
;      at the start of a run with the registers set as follows.
;
;      (wa)		     initial stack pointer
;      (xr)		     points to first word of data area
;      (xl)		     points to last word of data area
;
start	prc	e,0			; entry point
;z-
	mov	mxint,wb		;
	mov	bitsm,wb		;
	zer	wb			;
	mov	xs,wa			; discard return
;z+
	jsr	systm			; initialise timer
.if    .cnbt
	sti	timsx			; store time
	mov	statb,xr		; start address of static
.else
;
;      initialise work area (essential for batched runs)
;
	mov	wb,xr			; preserve xr
	mov	wa,=w_yyy		; point to end of work area
	sub	wa,=w_aaa		; get length of work area
	btw	wa			; convert to words
	lct	wa,wa			; count for loop
	mov	xr,=w_aaa		; set up index register
;
;      clear work space
;
ini01	zer	(xr)+			; clear a word
	bct	wa,ini01		; loop till done
	mov	wa,=stndo		; undefined operators pointer
	mov	wc,=r_yyy		; point to table end
	sub	wc,=r_uba		; length of undef. operators table
	btw	wc			; convert to words
	lct	wc,wc			; loop counter
	mov	xr,=r_uba		; set up xr
;
;      set correct value into undefined operators table
;
ini02	mov	(xr)+,wa		; store value
	bct	wc,ini02		; loop till all done
	mov	wa,=num01		; get a 1
.if    .cpol
	mov	polcs,wa		; interface polling interval
	mov	polct,wa		; interface polling interval
.fi
	mov	cmpsn,wa		; statement no
	mov	cswfl,wa		; nofail
	mov	cswls,wa		; list
	mov	kvinp,wa		; input
	mov	kvoup,wa		; output
	mov	lstpf,wa		; nothing for listr yet
	mov	wa,=iniln		; input image length
	mov	cswin,wa		; -in72
	ejc
	mov	wa,=nulls		; get null string pointer
	mov	kvrtn,wa		; return
	mov	r_etx,wa		; errtext
	mov	r_ttl,wa		; title for listing
	mov	stxvr,wa		; setexit
	sti	timsx			; store time in correct place
	ldi	stlim			; get default stlimit
	sti	kvstl			; statement limit
	sti	kvstc			; statement count
	mov	statb,wb		; store start adrs of static
.fi
	mov	rsmem,*e_srs		; reserve memory
	mov	stbas,xs		; store stack base
	sss	iniss			; save s-r stack ptr
;
;      now convert free store percentage to a suitable factor
;      for easy testing in alloc routine.
;
	ldi	intvh			; get 100
	dvi	alfsp			; form 100 / alfsp
	sti	alfsf			; store the factor
.if    .csed
;
;      now convert free sediment percentage to a suitable factor
;      for easy testing in gbcol routine.
;
	ldi	intvh			; get 100
	dvi	gbsdp			; form 100 / gbsdp
	sti	gbsed			; store the factor
.fi
.if    .cnra
.else
.if    .cncr
.else
;
;      initialize values for real conversion routine
;
	lct	wb,=cfp_s		; load counter for significant digits
	ldr	reav1			; load 1.0
;
;      loop to compute 10**(max number significant digits)
;
ini03	mlr	reavt			; * 10.0
	bct	wb,ini03		; loop till done
	str	gtssc			; store 10**(max sig digits)
	ldr	reap5			; load 0.5
	dvr	gtssc			; compute 0.5*10**(max sig digits)
	str	gtsrn			; store as rounding bias
.fi
.fi
	zer	wc			; set to read parameters
	jsr	prpar			; read them
	ejc
;
;      now compute starting address for dynamic store and if
;      necessary request more memory.
;
	sub	xl,*e_srs		; allow for reserve memory
	mov	wa,prlen		; get print buffer length
	add	wa,=cfp_a		; add no. of chars in alphabet
	add	wa,=nstmx		; add chars for gtstg bfr
	ctb	wa,8			; convert to bytes, allowing a margin
	mov	xr,statb		; point to static base
	add	xr,wa			; increment for above buffers
	add	xr,*e_hnb		; increment for hash table
	add	xr,*e_sts		; bump for initial static block
	jsr	sysmx			; get mxlen
	mov	kvmxl,wa		; provisionally store as maxlngth
	mov	mxlen,wa		; and as mxlen
	bgt	xr,wa,ini06		; skip if static hi exceeds mxlen
	ctb	wa,1			; round up and make bigger than mxlen
	mov	xr,wa			; use it instead
;
;      here to store values which mark initial division
;      of data area into static and dynamic
;
ini06	mov	dnamb,xr		; dynamic base adrs
	mov	dnamp,xr		; dynamic ptr
	bnz	wa,ini07		; skip if non-zero mxlen
	dca	xr			; point a word in front
	mov	kvmxl,xr		; use as maxlngth
	mov	mxlen,xr		; and as mxlen
	ejc
;
;      loop here if necessary till enough memory obtained
;      so that dname is above dnamb
;
ini07	mov	dname,xl		; store dynamic end address
	blt	dnamb,xl,ini09		; skip if high enough
	jsr	sysmm			; request more memory
	wtb	xr			; get as baus (sgd05)
	add	xl,xr			; bump by amount obtained
	bnz	xr,ini07		; try again
.if    .cera
	mov	wa,=mxern		; insufficient memory for maxlength
	zer	wb			; no column number info
	zer	wc			; no line number info
	mov	xr,=stgic		; initial compile stage
.if    .csfn
	mov	xl,=nulls		; no file name
.fi
	jsr	sysea			; advise of error
	ppm	ini08			; cant use error logic yet
	brn	ini08			; force termination
;
;      insert text for error 329 in error message table
;
	erb	329,requested maxlngth too large
.fi
ini08	mov	xr,=endmo		; point to failure message
	mov	wa,endml		; message length
	jsr	syspr			; print it (prtst not yet usable)
	ppm				; should not fail
	zer	xl			; no fcb chain yet
	mov	wb,=num10		; set special code value
	jsr	sysej			; pack up (stopr not yet usable)
;
;      initialise structures at start of static region
;
ini09	mov	xr,statb		; point to static again
	jsr	insta			; initialize static
;
;      initialize number of hash headers
;
	mov	wa,=e_hnb		; get number of hash headers
	mti	wa			; convert to integer
	sti	hshnb			; store for use by gtnvr procedure
	lct	wa,wa			; counter for clearing hash table
	mov	hshtb,xr		; pointer to hash table
;
;      loop to clear hash table
;
ini11	zer	(xr)+			; blank a word
	bct	wa,ini11		; loop
	mov	hshte,xr		; end of hash table adrs is kept
	mov	state,xr		; store static end address
.if    .csfn
;
;      init table to map statement numbers to source file names
;
	mov	wc,=num01		; table will have only one bucket
	mov	xl,=nulls		; default table value
	mov	r_sfc,xl		; current source file name
	jsr	tmake			; create table
	mov	r_sfn,xr		; save ptr to table
.fi
.if    .cinc
;
;      initialize table to detect duplicate include file names
;
	mov	wc,=num01		; table will have only one bucket
	mov	xl,=nulls		; default table value
	jsr	tmake			; create table
	mov	r_inc,xr		; save ptr to table
.if    .csfn
;
;      initialize array to hold names of nested include files
;
	mov	wa,=ccinm		; maximum nesting level
	mov	xl,=nulls		; null string default value
	jsr	vmake			; create array
	ppm
	mov	r_ifa,xr		; save ptr to array
;
;      init array to hold line numbers of nested include files
;
	mov	wa,=ccinm		; maximum nesting level
	mov	xl,=inton		; integer one default value
	jsr	vmake			; create array
	ppm
	mov	r_ifl,xr		; save ptr to array
.fi
.fi
;z+
;
;      initialize variable blocks for input and output
;
	mov	xl,=v_inp		; point to string /input/
	mov	wb,=trtin		; trblk type for input
	jsr	inout			; perform input association
	mov	xl,=v_oup		; point to string /output/
	mov	wb,=trtou		; trblk type for output
	jsr	inout			; perform output association
	mov	wc,initr		; terminal flag
	bze	wc,ini13		; skip if no terminal
	jsr	prpar			; associate terminal
	ejc
;
;      check for expiry date
;
ini13	jsr	sysdc			; call date check
	mov	flptr,xs		; in case stack overflows in compiler
;
;      now compile source input code
;
	jsr	cmpil			; call compiler
	mov	r_cod,xr		; set ptr to first code block
	mov	r_ttl,=nulls		; forget title
	mov	r_stl,=nulls		; forget sub-title
	zer	r_cim			; forget compiler input image
	zer	r_ccb			; forget interim code block
.if    .cinc
	zer	cnind			; in case end occurred with include
	zer	lstid			; listing include depth
.fi
	zer	xl			; clear dud value
	zer	wb			; dont shift dynamic store up
.if    .csed
	zer	dnams			; collect sediment too
	jsr	gbcol			; clear garbage left from compile
	mov	dnams,xr		; record new sediment size
.else
	jsr	gbcol			; clear garbage left from compile
.fi
	bnz	cpsts,inix0		; skip if no listing of comp stats
	jsr	prtpg			; eject page
;
;      print compile statistics
;
	jsr	prtmm			; print memory usage
	mti	cmerc			; get count of errors as integer
	mov	xr,=encm3		; point to /compile errors/
	jsr	prtmi			; print it
	mti	gbcnt			; garbage collection count
	sbi	intv1			; adjust for unavoidable collect
	mov	xr,=stpm5		; point to /storage regenerations/
	jsr	prtmi			; print gbcol count
	jsr	systm			; get time
	sbi	timsx			; get compilation time
	mov	xr,=encm4		; point to compilation time (msec)/
	jsr	prtmi			; print message
	add	lstlc,=num05		; bump line count
.if    .cuej
	bze	headp,inix0		; no eject if nothing printed
	jsr	prtpg			; eject printer
.fi
	ejc
;
;      prepare now to start execution
;
;      set default input record length
;
inix0	bgt	cswin,=iniln,inix1	; skip if not default -in72 used
	mov	cswin,=inils		; else use default record length
;
;      reset timer
;
inix1	jsr	systm			; get time again
	sti	timsx			; store for end run processing
	zer	gbcnt			; initialise collect count
	jsr	sysbx			; call before starting execution
	add	noxeq,cswex		; add -noexecute flag
	bnz	noxeq,inix2		; jump if execution suppressed
.if    .cuej
.else
	bze	headp,iniy0		; no eject if nothing printed (sgd11)
	jsr	prtpg			; eject printer
.fi
;
;      merge when listing file set for execution.  also
;      merge here when restarting a save file or load module.
;
iniy0	mnz	headp			; mark headers out regardless
	zer	-(xs)			; set failure location on stack
	mov	flptr,xs		; save ptr to failure offset word
	mov	xr,r_cod		; load ptr to entry code block
	mov	stage,=stgxt		; set stage for execute time
.if    .cpol
	mov	polcs,=num01		; reset interface polling interval
	mov	polct,=num01		; reset interface polling interval
.fi
.if    .cnpf
.else
	mov	pfnte,cmpsn		; copy stmts compiled count in case
	mov	pfdmp,kvpfl		; start profiling if &profile set
	jsr	systm			; time yet again
	sti	pfstm			;
.fi
	jsr	stgcc			; compute stmgo countdown counters
	bri	(xr)			; start xeq with first statement
;
;      here if execution is suppressed
;
.if    .cera
inix2	zer	wa			; set abend value to zero
.else
inix2	jsr	prtnl			; print a blank line
	mov	xr,=encm5		; point to /execution suppressed/
	jsr	prtst			; print string
	jsr	prtnl			; output line
	zer	wa			; set abend value to zero
.fi
	mov	wb,=nini9		; set special code value
	zer	xl			; no fcb chain
	jsr	sysej			; end of job, exit to system
	enp				; end procedure start
;
;      here from osint to restart a save file or load module.
;
rstrt	prc	e,0			; entry point
	mov	xs,stbas		; discard return
	zer	xl			; clear xl
	brn	iniy0			; resume execution
	enp				; end procedure rstrt

	ttl	s p i t b o l -- snobol4 operator routines
;
;      this section includes all routines which can be accessed
;      directly from the generated code except system functions.
;
;      all routines in this section start with a label of the
;      form o_xxx where xxx is three letters. the generated code
;      contains a pointer to the appropriate entry label.
;
;      since the general form of the generated code consists of
;      pointers to blocks whose first word is the address of the
;      actual entry point label (o_xxx).
;
;      these routines are in alphabetical order by their
;      entry label names (i.e. by the xxx of the o_xxx name)
;
;      these routines receive control as follows
;
;      (cp)		     pointer to next code word
;      (xs)		     current stack pointer
	ejc
;
;      binary plus (addition)
;
o_add	ent				; entry point
;z+
	jsr	arith			; fetch arithmetic operands
	err	001,addition left operand is not numeric
	err	002,addition right operand is not numeric
.if    .cnra
.else
	ppm	oadd1			; jump if real operands
.fi
;
;      here to add two integers
;
	adi	icval(xl)		; add right operand to left
	ino	exint			; return integer if no overflow
	erb	003,addition caused integer overflow
.if    .cnra
.else
;
;      here to add two reals
;
oadd1	adr	rcval(xl)		; add right operand to left
	rno	exrea			; return real if no overflow
	erb	261,addition caused real overflow
.fi
	ejc
;
;      unary plus (affirmation)
;
o_aff	ent				; entry point
	mov	xr,(xs)+		; load operand
	jsr	gtnum			; convert to numeric
	err	004,affirmation operand is not numeric
	mov	-(xs),xr		; result if converted to numeric
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
;
;      binary bar (alternation)
;
o_alt	ent				; entry point
	mov	xr,(xs)+		; load right operand
	jsr	gtpat			; convert to pattern
	err	005,alternation right operand is not pattern
;
;      merge here from special (left alternation) case
;
oalt1	mov	wb,=p_alt		; set pcode for alternative node
	jsr	pbild			; build alternative node
	mov	xl,xr			; save address of alternative node
	mov	xr,(xs)+		; load left operand
	jsr	gtpat			; convert to pattern
	err	006,alternation left operand is not pattern
	beq	xr,=p_alt,oalt2		; jump if left arg is alternation
	mov	pthen(xl),xr		; set left operand as successor
	mov	-(xs),xl		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
;
;      come here if left argument is itself an alternation
;
;      the result is more efficient if we make the replacement
;
;      (a / b) / c = a / (b / c)
;
oalt2	mov	pthen(xl),parm1(xr)	; build the (b / c) node
	mov	-(xs),pthen(xr)		; set a as new left arg
	mov	xr,xl			; set (b / c) as new right arg
	brn	oalt1			; merge back to build a / (b / c)
	ejc
;
;      array reference (multiple subscripts, by name)
;
o_amn	ent				; entry point
	lcw	xr			; load number of subscripts
	mov	wb,xr			; set flag for by name
	brn	arref			; jump to array reference routine
	ejc
;
;      array reference (multiple subscripts, by value)
;
o_amv	ent				; entry point
	lcw	xr			; load number of subscripts
	zer	wb			; set flag for by value
	brn	arref			; jump to array reference routine
	ejc
;
;      array reference (one subscript, by name)
;
o_aon	ent				; entry point
	mov	xr,(xs)			; load subscript value
	mov	xl,num01(xs)		; load array value
	mov	wa,(xl)			; load first word of array operand
	beq	wa,=b_vct,oaon2		; jump if vector reference
	beq	wa,=b_tbt,oaon3		; jump if table reference
;
;      here to use central array reference routine
;
oaon1	mov	xr,=num01		; set number of subscripts to one
	mov	wb,xr			; set flag for by name
	brn	arref			; jump to array reference routine
;
;      here if we have a vector reference
;
oaon2	bne	(xr),=b_icl,oaon1	; use long routine if not integer
	ldi	icval(xr)		; load integer subscript value
	mfi	wa,exfal		; copy as address int, fail if ovflo
	bze	wa,exfal		; fail if zero
	add	wa,=vcvlb		; compute offset in words
	wtb	wa			; convert to bytes
	mov	(xs),wa			; complete name on stack
	blt	wa,vclen(xl),oaon4	; exit if subscript not too large
	brn	exfal			; else fail
;
;      here for table reference
;
oaon3	mnz	wb			; set flag for name reference
	jsr	tfind			; locate/create table element
	ppm	exfal			; fail if access fails
	mov	num01(xs),xl		; store name base on stack
	mov	(xs),wa			; store name offset on stack
;
;      here to exit with result on stack
;
oaon4	lcw	xr			; result on stack, get code word
	bri	(xr)			; execute next code word
	ejc
;
;      array reference (one subscript, by value)
;
o_aov	ent				; entry point
	mov	xr,(xs)+		; load subscript value
	mov	xl,(xs)+		; load array value
	mov	wa,(xl)			; load first word of array operand
	beq	wa,=b_vct,oaov2		; jump if vector reference
	beq	wa,=b_tbt,oaov3		; jump if table reference
;
;      here to use central array reference routine
;
oaov1	mov	-(xs),xl		; restack array value
	mov	-(xs),xr		; restack subscript
	mov	xr,=num01		; set number of subscripts to one
	zer	wb			; set flag for value call
	brn	arref			; jump to array reference routine
;
;      here if we have a vector reference
;
oaov2	bne	(xr),=b_icl,oaov1	; use long routine if not integer
	ldi	icval(xr)		; load integer subscript value
	mfi	wa,exfal		; move as one word int, fail if ovflo
	bze	wa,exfal		; fail if zero
	add	wa,=vcvlb		; compute offset in words
	wtb	wa			; convert to bytes
	bge	wa,vclen(xl),exfal	; fail if subscript too large
	jsr	acess			; access value
	ppm	exfal			; fail if access fails
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
;
;      here for table reference by value
;
oaov3	zer	wb			; set flag for value reference
	jsr	tfind			; call table search routine
	ppm	exfal			; fail if access fails
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
;
;      assignment
;
o_ass	ent				; entry point
;
;      o_rpl (pattern replacement) merges here
;
oass0	mov	wb,(xs)+		; load value to be assigned
	mov	wa,(xs)+		; load name offset
	mov	xl,(xs)			; load name base
	mov	(xs),wb			; store assigned value as result
	jsr	asign			; perform assignment
	ppm	exfal			; fail if assignment fails
	lcw	xr			; result on stack, get code word
	bri	(xr)			; execute next code word
	ejc
;
;      compilation error
;
o_cer	ent				; entry point
	erb	007,compilation error encountered during execution
	ejc
;
;      unary at (cursor assignment)
;
o_cas	ent				; entry point
	mov	wc,(xs)+		; load name offset (parm2)
	mov	xr,(xs)+		; load name base (parm1)
	mov	wb,=p_cas		; set pcode for cursor assignment
	jsr	pbild			; build node
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
;
;      concatenation
;
o_cnc	ent				; entry point
	mov	xr,(xs)			; load right argument
	beq	xr,=nulls,ocnc3		; jump if right arg is null
	mov	xl,1(xs)		; load left argument
	beq	xl,=nulls,ocnc4		; jump if left argument is null
	mov	wa,=b_scl		; get constant to test for string
	bne	wa,(xl),ocnc2		; jump if left arg not a string
	bne	wa,(xr),ocnc2		; jump if right arg not a string
;
;      merge here to concatenate two strings
;
ocnc1	mov	wa,sclen(xl)		; load left argument length
	add	wa,sclen(xr)		; compute result length
	jsr	alocs			; allocate scblk for result
	mov	1(xs),xr		; store result ptr over left argument
	psc	xr			; prepare to store chars of result
	mov	wa,sclen(xl)		; get number of chars in left arg
	plc	xl			; prepare to load left arg chars
	mvc				; move characters of left argument
	mov	xl,(xs)+		; load right arg pointer, pop stack
	mov	wa,sclen(xl)		; load number of chars in right arg
	plc	xl			; prepare to load right arg chars
	mvc				; move characters of right argument
	zer	xl			; clear garbage value in xl
	lcw	xr			; result on stack, get code word
	bri	(xr)			; execute next code word
;
;      come here if arguments are not both strings
;
ocnc2	jsr	gtstg			; convert right arg to string
	ppm	ocnc5			; jump if right arg is not string
	mov	xl,xr			; save right arg ptr
	jsr	gtstg			; convert left arg to string
	ppm	ocnc6			; jump if left arg is not a string
	mov	-(xs),xr		; stack left argument
	mov	-(xs),xl		; stack right argument
	mov	xl,xr			; move left arg to proper reg
	mov	xr,(xs)			; move right arg to proper reg
	brn	ocnc1			; merge back to concatenate strings
	ejc
;
;      concatenation (continued)
;
;      come here for null right argument
;
ocnc3	ica	xs			; remove right arg from stack
	lcw	xr			; left argument on stack
	bri	(xr)			; execute next code word
;
;      here for null left argument
;
ocnc4	ica	xs			; unstack one argument
	mov	(xs),xr			; store right argument
	lcw	xr			; result on stack, get code word
	bri	(xr)			; execute next code word
;
;      here if right argument is not a string
;
ocnc5	mov	xl,xr			; move right argument ptr
	mov	xr,(xs)+		; load left arg pointer
;
;      merge here when left argument is not a string
;
ocnc6	jsr	gtpat			; convert left arg to pattern
	err	008,concatenation left operand is not a string or pattern
	mov	-(xs),xr		; save result on stack
	mov	xr,xl			; point to right operand
	jsr	gtpat			; convert to pattern
	err	009,concatenation right operand is not a string or pattern
	mov	xl,xr			; move for pconc
	mov	xr,(xs)+		; reload left operand ptr
	jsr	pconc			; concatenate patterns
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
;
;      complementation
;
o_com	ent				; entry point
	mov	xr,(xs)+		; load operand
	mov	wa,(xr)			; load type word
;
;      merge back here after conversion
;
ocom1	beq	wa,=b_icl,ocom2		; jump if integer
.if    .cnra
.else
	beq	wa,=b_rcl,ocom3		; jump if real
.fi
	jsr	gtnum			; else convert to numeric
	err	010,negation operand is not numeric
	brn	ocom1			; back to check cases
;
;      here to complement integer
;
ocom2	ldi	icval(xr)		; load integer value
	ngi				; negate
	ino	exint			; return integer if no overflow
	erb	011,negation caused integer overflow
.if    .cnra
.else
;
;      here to complement real
;
ocom3	ldr	rcval(xr)		; load real value
	ngr				; negate
	brn	exrea			; return real result
.fi
	ejc
;
;      binary slash (division)
;
o_dvd	ent				; entry point
	jsr	arith			; fetch arithmetic operands
	err	012,division left operand is not numeric
	err	013,division right operand is not numeric
.if    .cnra
.else
	ppm	odvd2			; jump if real operands
.fi
;
;      here to divide two integers
;
	dvi	icval(xl)		; divide left operand by right
	ino	exint			; result ok if no overflow
	erb	014,division caused integer overflow
.if    .cnra
.else
;
;      here to divide two reals
;
odvd2	dvr	rcval(xl)		; divide left operand by right
	rno	exrea			; return real if no overflow
	erb	262,division caused real overflow
.fi
	ejc
;
;      exponentiation
;
o_exp	ent				; entry point
	mov	xr,(xs)+		; load exponent
	jsr	gtnum			; convert to number
	err	015,exponentiation right operand is not numeric
	mov	xl,xr			; move exponent to xl
	mov	xr,(xs)+		; load base
	jsr	gtnum			; convert to numeric
	err	016,exponentiation left operand is not numeric
.if    .cnra
.else
	beq	(xl),=b_rcl,oexp7	; jump if real exponent
.fi
	ldi	icval(xl)		; load exponent
	ilt	oex12			; jump if negative exponent
.if    .cnra
.else
	beq	wa,=b_rcl,oexp3		; jump if base is real
.fi
;
;      here to exponentiate an integer base and integer exponent
;
	mfi	wa,oexp2		; convert exponent to 1 word integer
	lct	wa,wa			; set loop counter
	ldi	icval(xr)		; load base as initial value
	bnz	wa,oexp1		; jump into loop if non-zero exponent
	ieq	oexp4			; error if 0**0
	ldi	intv1			; nonzero**0
	brn	exint			; give one as result for nonzero**0
;
;      loop to perform exponentiation
;
oex13	mli	icval(xr)		; multiply by base
	iov	oexp2			; jump if overflow
oexp1	bct	wa,oex13		; loop if more to go
	brn	exint			; else return integer result
;
;      here if integer overflow
;
oexp2	erb	017,exponentiation caused integer overflow
	ejc
;
;      exponentiation (continued)
.if    .cnra
.else
;
;      here to exponentiate a real to an integer power
;
oexp3	mfi	wa,oexp6		; convert exponent to one word
	lct	wa,wa			; set loop counter
	ldr	rcval(xr)		; load base as initial value
	bnz	wa,oexp5		; jump into loop if non-zero exponent
	req	oexp4			; error if 0.0**0
	ldr	reav1			; nonzero**0
	brn	exrea			; return 1.0 if nonzero**zero
.fi
;
;      here for error of 0**0 or 0.0**0
;
oexp4	erb	018,exponentiation result is undefined
.if    .cnra
.else
;
;      loop to perform exponentiation
;
oex14	mlr	rcval(xr)		; multiply by base
	rov	oexp6			; jump if overflow
oexp5	bct	wa,oex14		; loop till computation complete
	brn	exrea			; then return real result
;
;      here if real overflow
;
oexp6	erb	266,exponentiation caused real overflow
;
;      here with real exponent in (xl), numeric base in (xr)
;
.if    .cmth
oexp7	beq	(xr),=b_rcl,oexp8	; jump if base real
	ldi	icval(xr)		; load integer base
	itr				; convert to real
	jsr	rcbld			; create real in (xr)
;
;      here with real exponent in (xl)
;      numeric base in (xr) and ra
;
oexp8	zer	wb			; set positive result flag
	ldr	rcval(xr)		; load base to ra
	rne	oexp9			; jump if base non-zero
	ldr	rcval(xl)		; base is zero.	 check exponent
	req	oexp4			; jump if 0.0 ** 0.0
	ldr	reav0			; 0.0 to non-zero exponent yields 0.0
	brn	exrea			; return zero result
;
;      here with non-zero base in (xr) and ra, exponent in (xl)
;
;      a negative base is allowed if the exponent is integral.
;
oexp9	rgt	oex10			; jump if base gt 0.0
	ngr				; make base positive
	jsr	rcbld			; create positive base in (xr)
	ldr	rcval(xl)		; examine exponent
	chp				; chop to integral value
	rti	oexp6			; convert to integer, br if too large
	sbr	rcval(xl)		; chop(exponent) - exponent
	rne	oex11			; non-integral power with neg base
	mfi	wb			; record even/odd exponent
	anb	wb,bits1		; odd exponent yields negative result
	ldr	rcval(xr)		; restore base to ra
;
;      here with positive base in ra and (xr), exponent in (xl)
;
oex10	lnf				; log of base
	rov	oexp6			; too large
	mlr	rcval(xl)		; times exponent
	rov	oexp6			; too large
	etx				; e ** (exponent * ln(base))
	rov	oexp6			; too large
	bze	wb,exrea		; if no sign fixup required
	ngr				; negative result needed
	brn	exrea			;
;
;      here for non-integral exponent with negative base
;
oex11	erb	311,exponentiation of negative base to non-integral power
.else
oexp7	erb	267,exponentiation right operand is real not integer
.fi
.fi
;
;      here with negative integer exponent in ia
;
.if    .cmth
oex12	mov	-(xs),xr		; stack base
	itr				; convert to real exponent
	jsr	rcbld			; real negative exponent in (xr)
	mov	xl,xr			; put exponent in xl
	mov	xr,(xs)+		; restore base value
	brn	oexp7			; process real exponent
.else
oex12	erb	019,exponentiation right operand is negative
.fi
	ejc
;
;      failure in expression evaluation
;
;      this entry point is used if the evaluation of an
;      expression, initiated by the evalx procedure, fails.
;      control is returned to an appropriate point in evalx.
;
o_fex	ent				; entry point
	brn	evlx6			; jump to failure loc in evalx
	ejc
;
;      failure during evaluation of a complex or direct goto
;
o_fif	ent				; entry point
	erb	020,goto evaluation failure
	ejc
;
;      function call (more than one argument)
;
o_fnc	ent				; entry point
	lcw	wa			; load number of arguments
	lcw	xr			; load function vrblk pointer
	mov	xl,vrfnc(xr)		; load function pointer
	bne	wa,fargs(xl),cfunc	; use central routine if wrong num
	bri	(xl)			; jump to function if arg count ok
	ejc
;
;      function name error
;
o_fne	ent				; entry point
	lcw	wa			; get next code word
	bne	wa,=ornm_,ofne1		; fail if not evaluating expression
	bze	num02(xs),evlx3		; ok if expr. was wanted by value
;
;      here for error
;
ofne1	erb	021,function called by name returned a value
	ejc
;
;      function call (single argument)
;
o_fns	ent				; entry point
	lcw	xr			; load function vrblk pointer
	mov	wa,=num01		; set number of arguments to one
	mov	xl,vrfnc(xr)		; load function pointer
	bne	wa,fargs(xl),cfunc	; use central routine if wrong num
	bri	(xl)			; jump to function if arg count ok
	ejc
;      call to undefined function
;
o_fun	ent				; entry point
	erb	022,undefined function called
	ejc
;
;      execute complex goto
;
o_goc	ent				; entry point
	mov	xr,num01(xs)		; load name base pointer
	bhi	xr,state,ogoc1		; jump if not natural variable
	add	xr,*vrtra		; else point to vrtra field
	bri	(xr)			; and jump through it
;
;      here if goto operand is not natural variable
;
ogoc1	erb	023,goto operand is not a natural variable
	ejc
;
;      execute direct goto
;
o_god	ent				; entry point
	mov	xr,(xs)			; load operand
	mov	wa,(xr)			; load first word
	beq	wa,=b_cds,bcds0		; jump if code block to code routine
	beq	wa,=b_cdc,bcdc0		; jump if code block to code routine
	erb	024,goto operand in direct goto is not code
	ejc
;
;      set goto failure trap
;
;      this routine is executed at the start of a complex or
;      direct failure goto to trap a subsequent fail (see exfal)
;
o_gof	ent				; entry point
	mov	xr,flptr		; point to fail offset on stack
	ica	(xr)			; point failure to o_fif word
	icp				; point to next code word
	lcw	xr			; fetch next code word
	bri	(xr)			; execute it
	ejc
;
;      binary dollar (immediate assignment)
;
;      the pattern built by binary dollar is a compound pattern.
;      see description at start of pattern match section for
;      details of the structure which is constructed.
;
o_ima	ent				; entry point
	mov	wb,=p_imc		; set pcode for last node
	mov	wc,(xs)+		; pop name offset (parm2)
	mov	xr,(xs)+		; pop name base (parm1)
	jsr	pbild			; build p_imc node
	mov	xl,xr			; save ptr to node
	mov	xr,(xs)			; load left argument
	jsr	gtpat			; convert to pattern
	err	025,immediate assignment left operand is not pattern
	mov	(xs),xr			; save ptr to left operand pattern
	mov	wb,=p_ima		; set pcode for first node
	jsr	pbild			; build p_ima node
	mov	pthen(xr),(xs)+		; set left operand as p_ima successor
	jsr	pconc			; concatenate to form final pattern
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
;
;      indirection (by name)
;
o_inn	ent				; entry point
	mnz	wb			; set flag for result by name
	brn	indir			; jump to common routine
	ejc
;
;      interrogation
;
o_int	ent				; entry point
	mov	(xs),=nulls		; replace operand with null
	lcw	xr			; get next code word
	bri	(xr)			; execute next code word
	ejc
;
;      indirection (by value)
;
o_inv	ent				; entry point
	zer	wb			; set flag for by value
	brn	indir			; jump to common routine
	ejc
;
;      keyword reference (by name)
;
o_kwn	ent				; entry point
	jsr	kwnam			; get keyword name
	brn	exnam			; exit with result name
	ejc
;
;      keyword reference (by value)
;
o_kwv	ent				; entry point
	jsr	kwnam			; get keyword name
	mov	dnamp,xr		; delete kvblk
	jsr	acess			; access value
	ppm	exnul			; dummy (unused) failure return
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
;
;      load expression by name
;
o_lex	ent				; entry point
	mov	wa,*evsi_		; set size of evblk
	jsr	alloc			; allocate space for evblk
	mov	(xr),=b_evt		; set type word
	mov	evvar(xr),=trbev	; set dummy trblk pointer
	lcw	wa			; load exblk pointer
	mov	evexp(xr),wa		; set exblk pointer
	mov	xl,xr			; move name base to proper reg
	mov	wa,*evvar		; set name offset = zero
	brn	exnam			; exit with name in (xl,wa)
	ejc
;
;      load pattern value
;
o_lpt	ent				; entry point
	lcw	xr			; load pattern pointer
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
;
;      load variable name
;
o_lvn	ent				; entry point
	lcw	wa			; load vrblk pointer
	mov	-(xs),wa		; stack vrblk ptr (name base)
	mov	-(xs),*vrval		; stack name offset
	lcw	xr			; get next code word
	bri	(xr)			; execute next code word
	ejc
;
;      binary asterisk (multiplication)
;
o_mlt	ent				; entry point
	jsr	arith			; fetch arithmetic operands
	err	026,multiplication left operand is not numeric
	err	027,multiplication right operand is not numeric
.if    .cnra
.else
	ppm	omlt1			; jump if real operands
.fi
;
;      here to multiply two integers
;
	mli	icval(xl)		; multiply left operand by right
	ino	exint			; return integer if no overflow
	erb	028,multiplication caused integer overflow
.if    .cnra
.else
;
;      here to multiply two reals
;
omlt1	mlr	rcval(xl)		; multiply left operand by right
	rno	exrea			; return real if no overflow
	erb	263,multiplication caused real overflow
.fi
	ejc
;
;      name reference
;
o_nam	ent				; entry point
	mov	wa,*nmsi_		; set length of nmblk
	jsr	alloc			; allocate nmblk
	mov	(xr),=b_nml		; set name block code
	mov	nmofs(xr),(xs)+		; set name offset from operand
	mov	nmbas(xr),(xs)+		; set name base from operand
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
;
;      negation
;
;      initial entry
;
o_nta	ent				; entry point
	lcw	wa			; load new failure offset
	mov	-(xs),flptr		; stack old failure pointer
	mov	-(xs),wa		; stack new failure offset
	mov	flptr,xs		; set new failure pointer
	lcw	xr			; get next code word
	bri	(xr)			; execute next code word
;
;      entry after successful evaluation of operand
;
o_ntb	ent				; entry point
	mov	flptr,num02(xs)		; restore old failure pointer
	brn	exfal			; and fail
;
;      entry for failure during operand evaluation
;
o_ntc	ent				; entry point
	ica	xs			; pop failure offset
	mov	flptr,(xs)+		; restore old failure pointer
	brn	exnul			; exit giving null result
	ejc
;
;      use of undefined operator
;
o_oun	ent				; entry point
	erb	029,undefined operator referenced
	ejc
;
;      binary dot (pattern assignment)
;
;      the pattern built by binary dot is a compound pattern.
;      see description at start of pattern match section for
;      details of the structure which is constructed.
;
o_pas	ent				; entry point
	mov	wb,=p_pac		; load pcode for p_pac node
	mov	wc,(xs)+		; load name offset (parm2)
	mov	xr,(xs)+		; load name base (parm1)
	jsr	pbild			; build p_pac node
	mov	xl,xr			; save ptr to node
	mov	xr,(xs)			; load left operand
	jsr	gtpat			; convert to pattern
	err	030,pattern assignment left operand is not pattern
	mov	(xs),xr			; save ptr to left operand pattern
	mov	wb,=p_paa		; set pcode for p_paa node
	jsr	pbild			; build p_paa node
	mov	pthen(xr),(xs)+		; set left operand as p_paa successor
	jsr	pconc			; concatenate to form final pattern
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
;
;      pattern match (by name, for replacement)
;
o_pmn	ent				; entry point
	zer	wb			; set type code for match by name
	brn	match			; jump to routine to start match
	ejc
;
;      pattern match (statement)
;
;      o_pms is used in place of o_pmv when the pattern match
;      occurs at the outer (statement) level since in this
;      case the substring value need not be constructed.
;
o_pms	ent				; entry point
	mov	wb,=num02		; set flag for statement to match
	brn	match			; jump to routine to start match
	ejc
;
;      pattern match (by value)
;
o_pmv	ent				; entry point
	mov	wb,=num01		; set type code for value match
	brn	match			; jump to routine to start match
	ejc
;
;      pop top item on stack
;
o_pop	ent				; entry point
	ica	xs			; pop top stack entry
	lcw	xr			; get next code word
	bri	(xr)			; execute next code word
	ejc
;
;      terminate execution (code compiled for end statement)
;
o_stp	ent				; entry point
	brn	lend0			; jump to end circuit
	ejc
;
;      return name from expression
;      this entry points is used if the evaluation of an
;      expression, initiated by the evalx procedure, returns
;      a name. control is returned to the proper point in evalx.
;
o_rnm	ent				; entry point
	brn	evlx4			; return to evalx procedure
	ejc
;
;      pattern replacement
;
;      when this routine gets control, the following stack
;      entries have been made (see end of match routine p_nth)
;
;			     subject name base
;			     subject name offset
;			     initial cursor value
;			     final cursor value
;			     subject string pointer
;      (xs) ---------------- replacement value
;
o_rpl	ent				; entry point
	jsr	gtstg			; convert replacement val to string
	err	031,pattern replacement right operand is not a string
;
;      get result length and allocate result scblk
;
	mov	xl,(xs)			; load subject string pointer
.if    .cnbf
.else
	beq	(xl),=b_bct,orpl4	; branch if buffer assignment
.fi
	add	wa,sclen(xl)		; add subject string length
	add	wa,num02(xs)		; add starting cursor
	sub	wa,num01(xs)		; minus final cursor = total length
	bze	wa,orpl3		; jump if result is null
	mov	-(xs),xr		; restack replacement string
	jsr	alocs			; allocate scblk for result
	mov	wa,num03(xs)		; get initial cursor (part 1 len)
	mov	num03(xs),xr		; stack result pointer
	psc	xr			; point to characters of result
;
;      move part 1 (start of subject) to result
;
	bze	wa,orpl1		; jump if first part is null
	mov	xl,num01(xs)		; else point to subject string
	plc	xl			; point to subject string chars
	mvc				; move first part to result
	ejc
;      pattern replacement (continued)
;
;      now move in replacement value
;
orpl1	mov	xl,(xs)+		; load replacement string, pop
	mov	wa,sclen(xl)		; load length
	bze	wa,orpl2		; jump if null replacement
	plc	xl			; else point to chars of replacement
	mvc				; move in chars (part 2)
;
;      now move in remainder of string (part 3)
;
orpl2	mov	xl,(xs)+		; load subject string pointer, pop
	mov	wc,(xs)+		; load final cursor, pop
	mov	wa,sclen(xl)		; load subject string length
	sub	wa,wc			; minus final cursor = part 3 length
	bze	wa,oass0		; jump to assign if part 3 is null
	plc	xl,wc			; else point to last part of string
	mvc				; move part 3 to result
	brn	oass0			; jump to perform assignment
;
;      here if result is null
;
orpl3	add	xs,*num02		; pop subject str ptr, final cursor
	mov	(xs),=nulls		; set null result
	brn	oass0			; jump to assign null value
.if    .cnbf
.else
;
;      here for buffer substring assignment
;
orpl4	mov	xl,xr			; copy scblk replacement ptr
	mov	xr,(xs)+		; unstack bcblk ptr
	mov	wb,(xs)+		; get final cursor value
	mov	wa,(xs)+		; get initial cursor
	sub	wb,wa			; get length in wb
	add	xs,*num01		; get rid of name offset
	mov	(xs),xr			; store buffer result over name base
	jsr	insbf			; insert substring
	ppm				; convert fail impossible
	ppm	exfal			; fail if insert fails
	lcw	xr			; result on stack, get code word
	bri	(xr)			; execute next code word
.fi
	ejc
;
;      return value from expression
;
;      this entry points is used if the evaluation of an
;      expression, initiated by the evalx procedure, returns
;      a value. control is returned to the proper point in evalx
;
o_rvl	ent				; entry point
	brn	evlx3			; return to evalx procedure
	ejc
;
;      selection
;
;      initial entry
;
o_sla	ent				; entry point
	lcw	wa			; load new failure offset
	mov	-(xs),flptr		; stack old failure pointer
	mov	-(xs),wa		; stack new failure offset
	mov	flptr,xs		; set new failure pointer
	lcw	xr			; get next code word
	bri	(xr)			; execute next code word
;
;      entry after successful evaluation of alternative
;
o_slb	ent				; entry point
	mov	xr,(xs)+		; load result
	ica	xs			; pop fail offset
	mov	flptr,(xs)		; restore old failure pointer
	mov	(xs),xr			; restack result
	lcw	wa			; load new code offset
	add	wa,r_cod		; point to absolute code location
	lcp	wa			; set new code pointer
	lcw	xr			; get next code word
	bri	(xr)			; execute next code word
;
;      entry at start of subsequent alternatives
;
o_slc	ent				; entry point
	lcw	wa			; load new fail offset
	mov	(xs),wa			; store new fail offset
	lcw	xr			; get next code word
	bri	(xr)			; execute next code word
;
;      entry at start of last alternative
;
o_sld	ent				; entry point
	ica	xs			; pop failure offset
	mov	flptr,(xs)+		; restore old failure pointer
	lcw	xr			; get next code word
	bri	(xr)			; execute next code word
	ejc
;
;      binary minus (subtraction)
;
o_sub	ent				; entry point
	jsr	arith			; fetch arithmetic operands
	err	032,subtraction left operand is not numeric
	err	033,subtraction right operand is not numeric
.if    .cnra
.else
	ppm	osub1			; jump if real operands
.fi
;
;      here to subtract two integers
;
	sbi	icval(xl)		; subtract right operand from left
	ino	exint			; return integer if no overflow
	erb	034,subtraction caused integer overflow
.if    .cnra
.else
;
;      here to subtract two reals
;
osub1	sbr	rcval(xl)		; subtract right operand from left
	rno	exrea			; return real if no overflow
	erb	264,subtraction caused real overflow
.fi
	ejc
;
;      dummy operator to return control to trxeq procedure
;
o_txr	ent				; entry point
	brn	trxq1			; jump into trxeq procedure
	ejc
;
;      unexpected failure
;
;      note that if a setexit trap is operating then
;      transfer to system label continue
;      will result in looping here.  difficult to avoid except
;      with a considerable overhead which is not worthwhile or
;      else by a technique such as setting kverl to zero.
;
o_unf	ent				; entry point
	erb	035,unexpected failure in -nofail mode
	ttl	s p i t b o l -- block action routines
;
;      the first word of every block in dynamic storage and the
;      vrget, vrsto and vrtra fields of a vrblk contain a
;      pointer to an entry point in the program. all such entry
;      points are in the following section except those for
;      pattern blocks which are in the pattern matching segment
;      later on (labels of the form p_xxx), and dope vectors
;      (d_xxx) which are in the dope vector section following
;      the pattern routines (dope vectors are used for cmblks).
;
;      the entry points in this section have labels of the
;      form b_xxy where xx is the two character block type for
;      the corresponding block and y is any letter.
;
;      in some cases, the pointers serve no other purpose than
;      to identify the block type. in this case the routine
;      is never executed and thus no code is assembled.
;
;      for each of these entry points corresponding to a block
;      an entry point identification is assembled (bl_xx).
;
;      the exact entry conditions depend on the manner in
;      which the routine is accessed and are documented with
;      the individual routines as required.
;
;      the order of these routines is alphabetical with the
;      following exceptions.
;
;      the routines for seblk and exblk entries occur first so
;      that expressions can be quickly identified from the fact
;      that their routines lie before the symbol b_e__.
;
;      these are immediately followed by the routine for a trblk
;      so that the test against the symbol b_t__ checks for
;      trapped values or expression values (see procedure evalp)
;
;      the pattern routines lie after this section so that
;      patterns are identified with routines starting at or
;      after the initial instruction in these routines (p_aaa).
;
;      the symbol b_aaa defines the first location for block
;      routines and the symbol p_yyy (at the end of the pattern
;      match routines section) defines the last such entry point
;
b_aaa	ent	bl__i			; entry point of first block routine
	ejc
;
;      exblk
;
;      the routine for an exblk loads the expression onto
;      the stack as a value.
;
;      (xr)		     pointer to exblk
;
b_exl	ent	bl_ex			; entry point (exblk)
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
;
;      seblk
;
;      the routine for seblk is accessed from the generated
;      code to load the expression value onto the stack.
;
b_sel	ent	bl_se			; entry point (seblk)
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
;
;      define symbol which marks end of entries for expressions
;
b_e__	ent	bl__i			; entry point
	ejc
;
;      trblk
;
;      the routine for a trblk is never executed
;
b_trt	ent	bl_tr			; entry point (trblk)
;
;      define symbol marking end of trap and expression blocks
;
b_t__	ent	bl__i			; end of trblk,seblk,exblk entries
	ejc
;
;      arblk
;
;      the routine for arblk is never executed
;
b_art	ent	bl_ar			; entry point (arblk)
	ejc
;
;      bcblk
;
;      the routine for a bcblk is never executed
;
;      (xr)		     pointer to bcblk
;
b_bct	ent	bl_bc			; entry point (bcblk)
	ejc
;
;      bfblk
;
;      the routine for a bfblk is never executed
;
;      (xr)		     pointer to bfblk
;
b_bft	ent	bl_bf			; entry point (bfblk)
	ejc
;
;      ccblk
;
;      the routine for ccblk is never entered
;
b_cct	ent	bl_cc			; entry point (ccblk)
	ejc
;
;      cdblk
;
;      the cdblk routines are executed from the generated code.
;      there are two cases depending on the form of cdfal.
;
;      entry for complex failure code at cdfal
;
;      (xr)		     pointer to cdblk
;
b_cdc	ent	bl_cd			; entry point (cdblk)
bcdc0	mov	xs,flptr		; pop garbage off stack
	mov	(xs),cdfal(xr)		; set failure offset
	brn	stmgo			; enter stmt
	ejc
;
;      cdblk (continued)
;
;      entry for simple failure code at cdfal
;
;      (xr)		     pointer to cdblk
;
b_cds	ent	bl_cd			; entry point (cdblk)
bcds0	mov	xs,flptr		; pop garbage off stack
	mov	(xs),*cdfal		; set failure offset
	brn	stmgo			; enter stmt
	ejc
;
;      cmblk
;
;      the routine for a cmblk is never executed
;
b_cmt	ent	bl_cm			; entry point (cmblk)
	ejc
;
;      ctblk
;
;      the routine for a ctblk is never executed
;
b_ctt	ent	bl_ct			; entry point (ctblk)
	ejc
;
;      dfblk
;
;      the routine for a dfblk is accessed from the o_fnc entry
;      to call a datatype function and build a pdblk.
;
;      (xl)		     pointer to dfblk
;
b_dfc	ent	bl_df			; entry point
	mov	wa,dfpdl(xl)		; load length of pdblk
	jsr	alloc			; allocate pdblk
	mov	(xr),=b_pdt		; store type word
	mov	pddfp(xr),xl		; store dfblk pointer
	mov	wc,xr			; save pointer to pdblk
	add	xr,wa			; point past pdblk
	lct	wa,fargs(xl)		; set to count fields
;
;      loop to acquire field values from stack
;
bdfc1	mov	-(xr),(xs)+		; move a field value
	bct	wa,bdfc1		; loop till all moved
	mov	xr,wc			; recall pointer to pdblk
	brn	exsid			; exit setting id field
	ejc
;
;      efblk
;
;      the routine for an efblk is passed control form the o_fnc
;      entry to call an external function.
;
;      (xl)		     pointer to efblk
;
b_efc	ent	bl_ef			; entry point (efblk)
.if    .cnld
.else
	mov	wc,fargs(xl)		; load number of arguments
	wtb	wc			; convert to offset
	mov	-(xs),xl		; save pointer to efblk
	mov	xt,xs			; copy pointer to arguments
;
;      loop to convert arguments
;
befc1	ica	xt			; point to next entry
	mov	xr,(xs)			; load pointer to efblk
	dca	wc			; decrement eftar offset
	add	xr,wc			; point to next eftar entry
	mov	xr,eftar(xr)		; load eftar entry
.if    .cnra
.if    .cnlf
	bsw	xr,4			; switch on type
.else
	bsw	xr,3			; switch on type
.fi
.else
.if    .cnlf
	bsw	xr,5			; switch on type
.else
	bsw	xr,4			; switch on type
.fi
.fi
	iff	0,befc7			; no conversion needed
	iff	1,befc2			; string
	iff	2,befc3			; integer
.if    .cnra
.if    .cnlf
	iff	3,beff1			; file
.fi
.else
	iff	3,befc4			; real
.if    .cnlf
	iff	4,beff1			; file
.fi
.fi
	esw				; end of switch on type
.if    .cnlf
;
;      here to convert to file
;
beff1	mov	-(xs),xt		; save entry pointer
	mov	befof,wc		; save offset
	mov	-(xs),(xt)		; stack arg pointer
	jsr	iofcb			; convert to fcb
	err	298,external function argument is not file
	err	298,external function argument is not file
	err	298,external function argument is not file
	mov	xr,wa			; point to fcb
	mov	xt,(xs)+		; reload entry pointer
	brn	befc5			; jump to merge
.fi
;
;      here to convert to string
;
befc2	mov	-(xs),(xt)		; stack arg ptr
	jsr	gtstg			; convert argument to string
	err	039,external function argument is not a string
	brn	befc6			; jump to merge
	ejc
;
;      efblk (continued)
;
;      here to convert an integer
;
befc3	mov	xr,(xt)			; load next argument
	mov	befof,wc		; save offset
	jsr	gtint			; convert to integer
	err	040,external function argument is not integer
.if    .cnra
.else
	brn	befc5			; merge with real case
;
;      here to convert a real
;
befc4	mov	xr,(xt)			; load next argument
	mov	befof,wc		; save offset
	jsr	gtrea			; convert to real
	err	265,external function argument is not real
.fi
;
;      integer case merges here
;
befc5	mov	wc,befof		; restore offset
;
;      string merges here
;
befc6	mov	(xt),xr			; store converted result
;
;      no conversion merges here
;
befc7	bnz	wc,befc1		; loop back if more to go
;
;      here after converting all the arguments
;
	mov	xl,(xs)+		; restore efblk pointer
	mov	wa,fargs(xl)		; get number of args
	jsr	sysex			; call routine to call external fnc
	ppm	exfal			; fail if failure
	err	327,calling external function - not found
	err	326,calling external function - bad argument type
.if    .cexp
	wtb	wa			; convert number of args to bytes
	add	xs,wa			; remove arguments from stack
.fi
	ejc
;
;      efblk (continued)
;
;      return here with result in xr
;
;      first defend against non-standard null string returned
;
	mov	wb,efrsl(xl)		; get result type id
	bnz	wb,befa8		; branch if not unconverted
	bne	(xr),=b_scl,befc8	; jump if not a string
	bze	sclen(xr),exnul		; return null if null
;
;      here if converted result to check for null string
;
befa8	bne	wb,=num01,befc8		; jump if not a string
	bze	sclen(xr),exnul		; return null if null
;
;      return if result is in dynamic storage
;
befc8	blt	xr,dnamb,befc9		; jump if not in dynamic storage
	ble	xr,dnamp,exixr		; return result if already dynamic
;
;      here we copy a result into the dynamic region
;
befc9	mov	wa,(xr)			; get possible type word
	bze	wb,bef11		; jump if unconverted result
	mov	wa,=b_scl		; string
	beq	wb,=num01,bef10		; yes jump
	mov	wa,=b_icl		; integer
	beq	wb,=num02,bef10		; yes jump
.if    .cnra
.else
	mov	wa,=b_rcl		; real
.fi
;
;      store type word in result
;
bef10	mov	(xr),wa			; stored before copying to dynamic
;
;      merge for unconverted result
;
bef11	beq	(xr),=b_scl,bef12	; branch if string result
	jsr	blkln			; get length of block
	mov	xl,xr			; copy address of old block
	jsr	alloc			; allocate dynamic block same size
	mov	-(xs),xr		; set pointer to new block as result
	mvw				; copy old block to dynamic block
	zer	xl			; clear garbage value
	lcw	xr			; get next code word
	bri	(xr)			; execute next code word
;
;      here to return a string result that was not in dynamic.
;      cannot use the simple word copy above because it will not
;      guarantee zero padding in the last word.
;
bef12	mov	xl,xr			; save source string pointer
	mov	wa,sclen(xr)		; fetch string length
	bze	wa,exnul		; return null string if length zero
	jsr	alocs			; allocate space for string
	mov	-(xs),xr		; save as result pointer
	psc	xr			; prepare to store chars of result
	plc	xl			; point to chars in source string
	mov	wa,wc			; number of characters to copy
	mvc				; move characters to result string
	zer	xl			; clear garbage value
	lcw	xr			; get next code word
	bri	(xr)			; execute next code word
.fi
	ejc
;
;      evblk
;
;      the routine for an evblk is never executed
;
b_evt	ent	bl_ev			; entry point (evblk)
	ejc
;
;      ffblk
;
;      the routine for an ffblk is executed from the o_fnc entry
;      to call a field function and extract a field value/name.
;
;      (xl)		     pointer to ffblk
;
b_ffc	ent	bl_ff			; entry point (ffblk)
	mov	xr,xl			; copy ffblk pointer
	lcw	wc			; load next code word
	mov	xl,(xs)			; load pdblk pointer
	bne	(xl),=b_pdt,bffc2	; jump if not pdblk at all
	mov	wa,pddfp(xl)		; load dfblk pointer from pdblk
;
;      loop to find correct ffblk for this pdblk
;
bffc1	beq	wa,ffdfp(xr),bffc3	; jump if this is the correct ffblk
	mov	xr,ffnxt(xr)		; else link to next ffblk on chain
	bnz	xr,bffc1		; loop back if another entry to check
;
;      here for bad argument
;
bffc2	erb	041,field function argument is wrong datatype
	ejc
;
;      ffblk (continued)
;
;      here after locating correct ffblk
;
bffc3	mov	wa,ffofs(xr)		; load field offset
	beq	wc,=ofne_,bffc5		; jump if called by name
	add	xl,wa			; else point to value field
	mov	xr,(xl)			; load value
	bne	(xr),=b_trt,bffc4	; jump if not trapped
	sub	xl,wa			; else restore name base,offset
	mov	(xs),wc			; save next code word over pdblk ptr
	jsr	acess			; access value
	ppm	exfal			; fail if access fails
	mov	wc,(xs)			; restore next code word
;
;      here after getting value in (xr), xl is garbage
;
bffc4	mov	(xs),xr			; store value on stack (over pdblk)
	mov	xr,wc			; copy next code word
	mov	xl,(xr)			; load entry address
	bri	xl			; jump to routine for next code word
;
;      here if called by name
;
bffc5	mov	-(xs),wa		; store name offset (base is set)
	lcw	xr			; get next code word
	bri	(xr)			; execute next code word
	ejc
;
;      icblk
;
;      the routine for icblk is executed from the generated
;      code to load an integer value onto the stack.
;
;      (xr)		     pointer to icblk
;
b_icl	ent	bl_ic			; entry point (icblk)
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
;
;      kvblk
;
;      the routine for a kvblk is never executed.
;
b_kvt	ent	bl_kv			; entry point (kvblk)
	ejc
;
;      nmblk
;
;      the routine for a nmblk is executed from the generated
;      code for the case of loading a name onto the stack
;      where the name is that of a natural variable which can
;      be preevaluated at compile time.
;
;      (xr)		     pointer to nmblk
;
b_nml	ent	bl_nm			; entry point (nmblk)
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
;
;      pdblk
;
;      the routine for a pdblk is never executed
;
b_pdt	ent	bl_pd			; entry point (pdblk)
	ejc
;
;      pfblk
;
;      the routine for a pfblk is executed from the entry o_fnc
;      to call a program defined function.
;
;      (xl)		     pointer to pfblk
;
;      the following stack entries are made before passing
;      control to the program defined function.
;
;			     saved value of first argument
;			     .
;			     saved value of last argument
;			     saved value of first local
;			     .
;			     saved value of last local
;			     saved value of function name
;			     saved code block ptr (r_cod)
;			     saved code pointer (-r_cod)
;			     saved value of flprt
;			     saved value of flptr
;			     pointer to pfblk
;      flptr --------------- zero (to be overwritten with offs)
;
b_pfc	ent	bl_pf			; entry point (pfblk)
	mov	bpfpf,xl		; save pfblk ptr (need not be reloc)
	mov	xr,xl			; copy for the moment
	mov	xl,pfvbl(xr)		; point to vrblk for function
;
;      loop to find old value of function
;
bpf01	mov	wb,xl			; save pointer
	mov	xl,vrval(xl)		; load value
	beq	(xl),=b_trt,bpf01	; loop if trblk
;
;      set value to null and save old function value
;
	mov	bpfsv,xl		; save old value
	mov	xl,wb			; point back to block with value
	mov	vrval(xl),=nulls	; set value to null
	mov	wa,fargs(xr)		; load number of arguments
	add	xr,*pfarg		; point to pfarg entries
	bze	wa,bpf04		; jump if no arguments
	mov	xt,xs			; ptr to last arg
	wtb	wa			; convert no. of args to bytes offset
	add	xt,wa			; point before first arg
	mov	bpfxt,xt		; remember arg pointer
	ejc
;
;      pfblk (continued)
;
;      loop to save old argument values and set new ones
;
bpf02	mov	xl,(xr)+		; load vrblk ptr for next argument
;
;      loop through possible trblk chain to find value
;
bpf03	mov	wc,xl			; save pointer
	mov	xl,vrval(xl)		; load next value
	beq	(xl),=b_trt,bpf03	; loop back if trblk
;
;      save old value and get new value
;
	mov	wa,xl			; keep old value
	mov	xt,bpfxt		; point before next stacked arg
	mov	wb,-(xt)		; load argument (new value)
	mov	(xt),wa			; save old value
	mov	bpfxt,xt		; keep arg ptr for next time
	mov	xl,wc			; point back to block with value
	mov	vrval(xl),wb		; set new value
	bne	xs,bpfxt,bpf02		; loop if not all done
;
;      now process locals
;
bpf04	mov	xl,bpfpf		; restore pfblk pointer
	mov	wa,pfnlo(xl)		; load number of locals
	bze	wa,bpf07		; jump if no locals
	mov	wb,=nulls		; get null constant
	lct	wa,wa			; set local counter
;
;      loop to process locals
;
bpf05	mov	xl,(xr)+		; load vrblk ptr for next local
;
;      loop through possible trblk chain to find value
;
bpf06	mov	wc,xl			; save pointer
	mov	xl,vrval(xl)		; load next value
	beq	(xl),=b_trt,bpf06	; loop back if trblk
;
;      save old value and set null as new value
;
	mov	-(xs),xl		; stack old value
	mov	xl,wc			; point back to block with value
	mov	vrval(xl),wb		; set null as new value
	bct	wa,bpf05		; loop till all locals processed
	ejc
;
;      pfblk (continued)
;
;      here after processing arguments and locals
;
.if    .cnpf
bpf07	mov	wa,r_cod		; load old code block pointer
.else
bpf07	zer	xr			; zero reg xr in case
	bze	kvpfl,bpf7c		; skip if profiling is off
	beq	kvpfl,=num02,bpf7a	; branch on type of profile
;
;      here if &profile = 1
;
	jsr	systm			; get current time
	sti	pfetm			; save for a sec
	sbi	pfstm			; find time used by caller
	jsr	icbld			; build into an icblk
	ldi	pfetm			; reload current time
	brn	bpf7b			; merge
;
;	here if &profile = 2
;
bpf7a	ldi	pfstm			; get start time of calling stmt
	jsr	icbld			; assemble an icblk round it
	jsr	systm			; get now time
;
;      both types of profile merge here
;
bpf7b	sti	pfstm			; set start time of 1st func stmt
	mnz	pffnc			; flag function entry
;
;      no profiling merges here
;
bpf7c	mov	-(xs),xr		; stack icblk ptr (or zero)
	mov	wa,r_cod		; load old code block pointer
.fi
	scp	wb			; get code pointer
	sub	wb,wa			; make code pointer into offset
	mov	xl,bpfpf		; recall pfblk pointer
	mov	-(xs),bpfsv		; stack old value of function name
	mov	-(xs),wa		; stack code block pointer
	mov	-(xs),wb		; stack code offset
	mov	-(xs),flprt		; stack old flprt
	mov	-(xs),flptr		; stack old failure pointer
	mov	-(xs),xl		; stack pointer to pfblk
	zer	-(xs)			; dummy zero entry for fail return
	chk				; check for stack overflow
	mov	flptr,xs		; set new fail return value
	mov	flprt,xs		; set new flprt
	mov	wa,kvtra		; load trace value
	add	wa,kvftr		; add ftrace value
	bnz	wa,bpf09		; jump if tracing possible
	icv	kvfnc			; else bump fnclevel
;
;      here to actually jump to function
;
bpf08	mov	xr,pfcod(xl)		; point to vrblk of entry label
	mov	xr,vrlbl(xr)		; point to target code
	beq	xr,=stndl,bpf17		; test for undefined label
	bne	(xr),=b_trt,bpf8a	; jump if not trapped
	mov	xr,trlbl(xr)		; else load ptr to real label code
bpf8a	bri	(xr)			; off to execute function
;
;      here if tracing is possible
;
bpf09	mov	xr,pfctr(xl)		; load possible call trace trblk
	mov	xl,pfvbl(xl)		; load vrblk pointer for function
	mov	wa,*vrval		; set name offset for variable
	bze	kvtra,bpf10		; jump if trace mode is off
	bze	xr,bpf10		; or if there is no call trace
;
;      here if call traced
;
	dcv	kvtra			; decrement trace count
	bze	trfnc(xr),bpf11		; jump if print trace
	jsr	trxeq			; execute function type trace
	ejc
;
;      pfblk (continued)
;
;      here to test for ftrace trace
;
bpf10	bze	kvftr,bpf16		; jump if ftrace is off
	dcv	kvftr			; else decrement ftrace
;
;      here for print trace
;
bpf11	jsr	prtsn			; print statement number
	jsr	prtnm			; print function name
	mov	wa,=ch_pp		; load left paren
	jsr	prtch			; print left paren
	mov	xl,num01(xs)		; recover pfblk pointer
	bze	fargs(xl),bpf15		; skip if no arguments
	zer	wb			; else set argument counter
	brn	bpf13			; jump into loop
;
;      loop to print argument values
;
bpf12	mov	wa,=ch_cm		; load comma
	jsr	prtch			; print to separate from last arg
;
;      merge here first time (no comma required)
;
bpf13	mov	(xs),wb			; save arg ctr (over failoffs is ok)
	wtb	wb			; convert to byte offset
	add	xl,wb			; point to next argument pointer
	mov	xr,pfarg(xl)		; load next argument vrblk ptr
	sub	xl,wb			; restore pfblk pointer
	mov	xr,vrval(xr)		; load next value
	jsr	prtvl			; print argument value
	ejc
;
;      here after dealing with one argument
;
	mov	wb,(xs)			; restore argument counter
	icv	wb			; increment argument counter
	blt	wb,fargs(xl),bpf12	; loop if more to print
;
;      merge here in no args case to print paren
;
bpf15	mov	wa,=ch_rp		; load right paren
	jsr	prtch			; print to terminate output
	jsr	prtnl			; terminate print line
;
;      merge here to exit with test for fnclevel trace
;
bpf16	icv	kvfnc			; increment fnclevel
	mov	xl,r_fnc		; load ptr to possible trblk
	jsr	ktrex			; call keyword trace routine
;
;      call function after trace tests complete
;
	mov	xl,num01(xs)		; restore pfblk pointer
	brn	bpf08			; jump back to execute function
;
;      here if calling a function whose entry label is undefined
;
bpf17	mov	flptr,num02(xs)		; reset so exfal can return to evalx
	erb	286,function call to undefined entry label
.if    .cnra
.else
	ejc
;
;      rcblk
;
;      the routine for an rcblk is executed from the generated
;      code to load a real value onto the stack.
;
;      (xr)		     pointer to rcblk
;
b_rcl	ent	bl_rc			; entry point (rcblk)
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
.fi
	ejc
;
;      scblk
;
;      the routine for an scblk is executed from the generated
;      code to load a string value onto the stack.
;
;      (xr)		     pointer to scblk
;
b_scl	ent	bl_sc			; entry point (scblk)
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
;
;      tbblk
;
;      the routine for a tbblk is never executed
;
b_tbt	ent	bl_tb			; entry point (tbblk)
	ejc
;
;      teblk
;
;      the routine for a teblk is never executed
;
b_tet	ent	bl_te			; entry point (teblk)
	ejc
;
;      vcblk
;
;      the routine for a vcblk is never executed
;
b_vct	ent	bl_vc			; entry point (vcblk)
	ejc
;
;      vrblk
;
;      the vrblk routines are executed from the generated code.
;      there are six entries for vrblk covering various cases
;
b_vr_	ent	bl__i			; mark start of vrblk entry points
;
;      entry for vrget (trapped case). this routine is called
;      from the generated code to load the value of a variable.
;      this entry point is used if an access trace or input
;      association is currently active.
;
;      (xr)		     pointer to vrget field of vrblk
;
b_vra	ent	bl__i			; entry point
	mov	xl,xr			; copy name base (vrget = 0)
	mov	wa,*vrval		; set name offset
	jsr	acess			; access value
	ppm	exfal			; fail if access fails
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
;
;      vrblk (continued)
;
;      entry for vrsto (error case. this routine is called from
;      the executed code for an attempt to modify the value
;      of a protected (pattern valued) natural variable.
;
b_vre	ent				; entry point
	erb	042,attempt to change value of protected variable
	ejc
;
;      vrblk (continued)
;
;      entry for vrtra (untrapped case). this routine is called
;      from the executed code to transfer to a label.
;
;      (xr)		     pointer to vrtra field of vrblk
;
b_vrg	ent				; entry point
	mov	xr,vrlbo(xr)		; load code pointer
	mov	xl,(xr)			; load entry address
	bri	xl			; jump to routine for next code word
	ejc
;
;      vrblk (continued)
;
;      entry for vrget (untrapped case). this routine is called
;      from the generated code to load the value of a variable.
;
;      (xr)		     points to vrget field of vrblk
;
b_vrl	ent				; entry point
	mov	-(xs),vrval(xr)		; load value onto stack (vrget = 0)
	lcw	xr			; get next code word
	bri	(xr)			; execute next code word
	ejc
;
;      vrblk (continued)
;
;      entry for vrsto (untrapped case). this routine is called
;      from the generated code to store the value of a variable.
;
;      (xr)		     pointer to vrsto field of vrblk
;
b_vrs	ent				; entry point
	mov	vrvlo(xr),(xs)		; store value, leave on stack
	lcw	xr			; get next code word
	bri	(xr)			; execute next code word
	ejc
;
;      vrblk (continued)
;
;      vrtra (trapped case). this routine is called from the
;      generated code to transfer to a label when a label
;      trace is currently active.
;
b_vrt	ent				; entry point
	sub	xr,*vrtra		; point back to start of vrblk
	mov	xl,xr			; copy vrblk pointer
	mov	wa,*vrval		; set name offset
	mov	xr,vrlbl(xl)		; load pointer to trblk
	bze	kvtra,bvrt2		; jump if trace is off
	dcv	kvtra			; else decrement trace count
	bze	trfnc(xr),bvrt1		; jump if print trace case
	jsr	trxeq			; else execute full trace
	brn	bvrt2			; merge to jump to label
;
;      here for print trace -- print colon ( label name )
;
bvrt1	jsr	prtsn			; print statement number
	mov	xr,xl			; copy vrblk pointer
	mov	wa,=ch_cl		; colon
	jsr	prtch			; print it
	mov	wa,=ch_pp		; left paren
	jsr	prtch			; print it
	jsr	prtvn			; print label name
	mov	wa,=ch_rp		; right paren
	jsr	prtch			; print it
	jsr	prtnl			; terminate line
	mov	xr,vrlbl(xl)		; point back to trblk
;
;      merge here to jump to label
;
bvrt2	mov	xr,trlbl(xr)		; load pointer to actual code
	bri	(xr)			; execute statement at label
	ejc
;
;      vrblk (continued)
;
;      entry for vrsto (trapped case). this routine is called
;      from the generated code to store the value of a variable.
;      this entry is used when a value trace or output
;      association is currently active.
;
;      (xr)		     pointer to vrsto field of vrblk
;
b_vrv	ent				; entry point
	mov	wb,(xs)			; load value (leave copy on stack)
	sub	xr,*vrsto		; point to vrblk
	mov	xl,xr			; copy vrblk pointer
	mov	wa,*vrval		; set offset
	jsr	asign			; call assignment routine
	ppm	exfal			; fail if assignment fails
	lcw	xr			; else get next code word
	bri	(xr)			; execute next code word
	ejc
;
;      xnblk
;
;      the routine for an xnblk is never executed
;
b_xnt	ent	bl_xn			; entry point (xnblk)
	ejc
;
;      xrblk
;
;      the routine for an xrblk is never executed
;
b_xrt	ent	bl_xr			; entry point (xrblk)
;
;      mark entry address past last block action routine
;
b_yyy	ent	bl__i			; last block routine entry point
	ttl	s p i t b o l -- pattern matching routines
;
;      the following section consists of the pattern matching
;      routines. all pattern nodes contain a pointer (pcode)
;      to one of the routines in this section (p_xxx).
;
;      note that this section follows the b_xxx routines to
;      enable a fast test for the pattern datatype.
;
p_aaa	ent	bl__i			; entry to mark first pattern
;
;
;      the entry conditions to the match routine are as follows
;      (see o_pmn, o_pmv, o_pms and procedure match).
;
;      stack contents.
;
;			     name base (o_pmn only)
;			     name offset (o_pmn only)
;			     type (0-o_pmn, 1-o_pmv, 2-o_pms)
;      pmhbs --------------- initial cursor (zero)
;			     initial node pointer
;      xs ------------------ =ndabo (anchored), =nduna (unanch)
;
;      register values.
;
;	    (xs)	     set as shown in stack diagram
;	    (xr)	     pointer to initial pattern node
;	    (wb)	     initial cursor (zero)
;
;      global pattern values
;
;	    r_pms	     pointer to subject string scblk
;	    pmssl	     length of subject string in chars
;	    pmdfl	     dot flag, initially zero
;	    pmhbs	     set as shown in stack diagram
;
;      control is passed by branching through the pcode
;      field of the initial pattern node (bri (xr)).
	ejc
;
;      description of algorithm
;
;      a pattern structure is represented as a linked graph
;      of nodes with the following structure.
;
;	    +------------------------------------+
;	    i		     pcode		 i
;	    +------------------------------------+
;	    i		     pthen		 i
;	    +------------------------------------+
;	    i		     parm1		 i
;	    +------------------------------------+
;	    i		     parm2		 i
;	    +------------------------------------+
;
;      pcode is a pointer to the routine which will perform
;      the match of this particular node type.
;
;      pthen is a pointer to the successor node. i.e. the node
;      to be matched if the attempt to match this node succeeds.
;      if this is the last node of the pattern pthen points
;      to the dummy node ndnth which initiates pattern exit.
;
;      parm1, parm2 are parameters whose use varies with the
;      particular node. they are only present if required.
;
;      alternatives are handled with the special alternative
;      node whose parameter points to the node to be matched
;      if there is a failure on the successor path.
;
;      the following example illustrates the manner in which
;      the structure is built up. the pattern is
;
;      (a / b / c) (d / e)   where / is alternation
;
;      in the diagram, the node marked + represents an
;      alternative node and the dotted line from a + node
;      represents the parameter pointer to the alternative.
;
;      +---+	 +---+	   +---+     +---+
;      i + i-----i a i-----i + i-----i d i-----
;      +---+	 +---+	i  +---+     +---+
;	 .		i    .
;	 .		i    .
;      +---+	 +---+	i  +---+
;      i + i-----i b i--i  i e i-----
;      +---+	 +---+	i  +---+
;	 .		i
;	 .		i
;      +---+		i
;      i c i------------i
;      +---+
	ejc
;
;      during the match, the registers are used as follows.
;
;      (xr)		     points to the current node
;      (xl)		     scratch
;      (xs)		     main stack pointer
;      (wb)		     cursor (number of chars matched)
;      (wa,wc)		     scratch
;
;      to keep track of alternatives, the main stack is used as
;      a history stack and contains two word entries.
;
;      word 1		     saved cursor value
;      word 2		     node to match on failure
;
;      when a failure occurs, the most recent entry on this
;      stack is popped off to restore the cursor and point
;      to the node to be matched as an alternative. the entry
;      at the bottom of the stack points to the following
;      special nodes depending on the scan mode.
;
;      anchored mode	     the bottom entry points to the
;			     special node ndabo which causes an
;			     abort. the cursor value stored
;			     with this entry is always zero.
;
;      unanchored mode	     the bottom entry points to the
;			     special node nduna which moves the
;			     anchor point and restarts the match
;			     the cursor saved with this entry
;			     is the number of characters which
;			     lie before the initial anchor point
;			     (i.e. the number of anchor moves).
;			     this entry is three words long and
;			     also contains the initial pattern.
;
;      entries are made on this history stack by alternative
;      nodes and by some special compound patterns as described
;      later on. the following global locations are used during
;      pattern matching.
;
;      r_pms		     pointer to subject string
;      pmssl		     length of subject string
;      pmdfl		     flag set non-zero for dot patterns
;      pmhbs		     base ptr for current history stack
;
;      the following exit points are available to match routines
;
;      succp		     success in matching current node
;      failp		     failure in matching current node
	ejc
;
;      compound patterns
;
;      some patterns have implicit alternatives and their
;      representation in the pattern structure consists of a
;      linked set of nodes as indicated by these diagrams.
;
;      as before, the + represents an alternative node and
;      the dotted line from a + node is the parameter pointer
;      to the alternative pattern.
;
;      arb
;      ---
;
;	    +---+	     this node (p_arb) matches null
;	    i b i-----	     and stacks cursor, successor ptr,
;	    +---+	     cursor (copy) and a ptr to ndarc.
;
;
;
;
;      bal
;      ---
;
;	    +---+	     the p_bal node scans a balanced
;	    i b i-----	     string and then stacks a pointer
;	    +---+	     to itself on the history stack.
	ejc
;
;      compound pattern structures (continued)
;
;
;      arbno
;      -----
;
;	    +---+	     this alternative node matches null
;      +----i + i-----	     the first time and stacks a pointer
;      i    +---+	     to the argument pattern x.
;      i      .
;      i      .
;      i    +---+	     node (p_aba) to stack cursor
;      i    i a i	     and history stack base ptr.
;      i    +---+
;      i      i
;      i      i
;      i    +---+	     this is the argument pattern. as
;      i    i x i	     indicated, the successor of the
;      i    +---+	     pattern is the p_abc node
;      i      i
;      i      i
;      i    +---+	     this node (p_abc) pops pmhbs,
;      +----i c i	     stacks old pmhbs and ptr to ndabd
;	    +---+	     (unless optimization has occurred)
;
;      structure and execution of this pattern resemble those of
;      recursive pattern matching and immediate assignment.
;      the alternative node at the head of the structure matches
;      null initially but on subsequent failure ensures attempt
;      to match the argument.  before the argument is matched
;      p_aba stacks the cursor, pmhbs and a ptr to p_abb.  if
;      the argument cant be matched , p_abb removes this special
;      stack entry and fails.
;      if argument is matched , p_abc restores the outer pmhbs
;      value (saved by p_aba) .	 then if the argument has left
;      alternatives on stack it stacks the inner value of pmhbs
;      and a ptr to ndabd. if argument left nothing on the stack
;      it optimises by removing items stacked by p_aba.	 finally
;      a check is made that argument matched more than the null
;      string (check is intended to prevent useless looping).
;      if so the successor is again the alternative node at the
;      head of the structure , ensuring a possible extra attempt
;      to match the arg if necessary.  if not , the successor to
;      alternative is taken so as to terminate the loop.  p_abd
;      restores inner pmhbs ptr and fails , thus trying to match
;      alternatives left by the arbno argument.
	ejc
;
;      compound pattern structures (continued)
;
;      breakx
;      ------
;
;	    +---+	     this node is a break node for
;      +----i b i	     the argument to breakx, identical
;      i    +---+	     to an ordinary break node.
;      i      i
;      i      i
;      i    +---+	     this alternative node stacks a
;      i    i + i-----	     pointer to the breakx node to
;      i    +---+	     allow for subsequent failure
;      i      .
;      i      .
;      i    +---+	     this is the breakx node itself. it
;      +----i x i	     matches one character and then
;	    +---+	     proceeds back to the break node.
;
;
;
;
;      fence
;      -----
;
;	    +---+	     the fence node matches null and
;	    i f i-----	     stacks a pointer to node ndabo to
;	    +---+	     abort on a subsequent rematch
;
;
;
;
;      succeed
;      -------
;
;	    +---+	     the node for succeed matches null
;	    i s i-----	     and stacks a pointer to itself
;	    +---+	     to repeat the match on a failure.
	ejc
;
;      compound patterns (continued)
;
;      binary dot (pattern assignment)
;      -------------------------------
;
;	    +---+	     this node (p_paa) saves the current
;	    i a i	     cursor and a pointer to the
;	    +---+	     special node ndpab on the stack.
;	      i
;	      i
;	    +---+	     this is the structure for the
;	    i x i	     pattern left argument of the
;	    +---+	     pattern assignment call.
;	      i
;	      i
;	    +---+	     this node (p_pac) saves the cursor,
;	    i c i-----	     a ptr to itself, the cursor (copy)
;	    +---+	     and a ptr to ndpad on the stack.
;
;
;      the function of the match routine for ndpab (p_pab)
;      is simply to unstack itself and fail back onto the stack.
;
;      the match routine for p_pac also sets the global pattern
;      flag pmdfl non-zero to indicate that pattern assignments
;      may have occured in the pattern match
;
;      if pmdfl is set at the end of the match (see p_nth), the
;      history stack is scanned for matching ndpab-ndpad pairs
;      and the corresponding pattern assignments are executed.
;
;      the function of the match routine for ndpad (p_pad)
;      is simply to remove its entry from the stack and fail.
;      this includes removing the special node pointer stored
;      in addition to the standard two entries on the stack.
	ejc
;
;      compount pattern structures (continued)
;
;      fence (function)
;      ----------------
;
;	    +---+	     this node (p_fna) saves the
;	    i a i	     current history stack and a
;	    +---+	     pointer to ndfnb on the stack.
;	      i
;	      i
;	    +---+	     this is the pattern structure
;	    i x i	     given as the argument to the
;	    +---+	     fence function.
;	      i
;	      i
;	    +---+	     this node p_fnc restores the outer
;	    i c i	     history stack ptr saved in p_fna,
;	    +---+	     and stacks the inner stack base
;			     ptr and a pointer to ndfnd on the
;			     stack.
;
;      ndfnb (f_fnb) simply is the failure exit for pattern
;      argument failure, and it pops itself and fails onto the
;      stack.
;
;      the match routine p_fnc allows for an optimization when
;      the fence pattern leaves no alternatives.  in this case,
;      the ndfnb entry is popped, and the match continues.
;
;      ndfnd (p_fnd) is entered when the pattern fails after
;      going through a non-optimized p_fnc, and it pops the
;      stack back past the innter stack base created by p_fna
	ejc
;
;      compound patterns (continued)
;
;      expression patterns (recursive pattern matches)
;      -----------------------------------------------
;
;      initial entry for a pattern node is to the routine p_exa.
;      if the evaluated result of the expression is itself a
;      pattern, then the following steps are taken to arrange
;      for proper recursive processing.
;
;      1)   a pointer to the current node (the p_exa node) is
;	    stored on the history stack with a dummy cursor.
;
;      2)   a special history stack entry is made in which the
;	    node pointer points to ndexb, and the cursor value
;	    is the saved value of pmhbs on entry to this node.
;	    the match routine for ndexb (p_exb) restores pmhbs
;	    from this cursor entry, pops off the p_exa node
;	    pointer and fails.
;
;      3)   the resulting history stack pointer is saved in
;	    pmhbs to establish a new level of history stack.
;
;      after matching a pattern, the end of match routine gets
;      control (p_nth). this routine proceeds as follows.
;
;      1)   load the current value of pmhbs and recognize the
;	    outer level case by the fact that the associated
;	    cursor in this case is the pattern match type code
;	    which is less than 3. terminate the match in this
;	    case and continue execution of the program.
;
;      2)   otherwise make a special history stack entry in
;	    which the node pointer points to the special node
;	    ndexc and the cursor is the current value of pmhbs.
;	    the match routine for ndexc (p_exc) resets pmhbs to
;	    this (inner) value and and then fails.
;
;      3)   using the history stack entry made on starting the
;	    expression (accessible with the current value of
;	    pmhbs), restore the p_exa node pointer and the old
;	    pmhbs setting. take the successor and continue.
;
;      an optimization is possible if the expression pattern
;      makes no entries on the history stack. in this case,
;      instead of building the p_exc node in step 2, it is more
;      efficient to simply pop off the p_exb entry and its
;      associated node pointer. the effect is the same.
	ejc
;
;      compound patterns (continued)
;
;      binary dollar (immediate assignment)
;      ------------------------------------
;
;	    +---+	     this node (p_ima) stacks the cursor
;	    i a i	     pmhbs and a ptr to ndimb and resets
;	    +---+	     the stack ptr pmhbs.
;	      i
;	      i
;	    +---+	     this is the left structure for the
;	    i x i	     pattern left argument of the
;	    +---+	     immediate assignment call.
;	      i
;	      i
;	    +---+	     this node (p_imc) performs the
;	    i c i-----	     assignment, pops pmhbs and stacks
;	    +---+	     the old pmhbs and a ptr to ndimd.
;
;
;      the structure and execution of this pattern are similar
;      to those of the recursive expression pattern matching.
;
;      the match routine for ndimb (p_imb) restores the outer
;      level value of pmhbs, unstacks the saved cursor and fails
;
;      the match routine p_imc uses the current value of pmhbs
;      to locate the p_imb entry. this entry is used to make
;      the assignment and restore the outer level value of
;      pmhbs. finally, the inner level value of pmhbs and a
;      pointer to the special node ndimd are stacked.
;
;      the match routine for ndimd (p_imd) restores the inner
;      level value of pmhbs and fails back into the stack.
;
;      an optimization occurs if the inner pattern makes no
;      entries on the history stack. in this case, p_imc pops
;      the p_imb entry instead of making a p_imd entry.
	ejc
;
;      arbno
;
;      see compound patterns section for stucture and
;      algorithm for matching this node type.
;
;      no parameters
;
p_aba	ent	bl_p0			; p0blk
	mov	-(xs),wb		; stack cursor
	mov	-(xs),xr		; stack dummy node ptr
	mov	-(xs),pmhbs		; stack old stack base ptr
	mov	-(xs),=ndabb		; stack ptr to node ndabb
	mov	pmhbs,xs		; store new stack base ptr
	brn	succp			; succeed
	ejc
;
;      arbno (remove p_aba special stack entry)
;
;      no parameters (dummy pattern)
;
p_abb	ent				; entry point
	mov	pmhbs,wb		; restore history stack base ptr
	brn	flpop			; fail and pop dummy node ptr
	ejc
;
;      arbno (check if arg matched null string)
;
;      no parameters (dummy pattern)
;
p_abc	ent	bl_p0			; p0blk
	mov	xt,pmhbs		; keep p_abb stack base
	mov	wa,num03(xt)		; load initial cursor
	mov	pmhbs,num01(xt)		; restore outer stack base ptr
	beq	xt,xs,pabc1		; jump if no history stack entries
	mov	-(xs),xt		; else save inner pmhbs entry
	mov	-(xs),=ndabd		; stack ptr to special node ndabd
	brn	pabc2			; merge
;
;      optimise case of no extra entries on stack from arbno arg
;
pabc1	add	xs,*num04		; remove ndabb entry and cursor
;
;      merge to check for matching of null string
;
pabc2	bne	wa,wb,succp		; allow further attempt if non-null
	mov	xr,pthen(xr)		; bypass alternative node so as to ...
	brn	succp			; ... refuse further match attempts
	ejc
;
;      arbno (try for alternatives in arbno argument)
;
;      no parameters (dummy pattern)
;
p_abd	ent				; entry point
	mov	pmhbs,wb		; restore inner stack base ptr
	brn	failp			; and fail
	ejc
;
;      abort
;
;      no parameters
;
p_abo	ent	bl_p0			; p0blk
	brn	exfal			; signal statement failure
	ejc
;
;      alternation
;
;      parm1		     alternative node
;
p_alt	ent	bl_p1			; p1blk
	mov	-(xs),wb		; stack cursor
	mov	-(xs),parm1(xr)		; stack pointer to alternative
	chk				; check for stack overflow
	brn	succp			; if all ok, then succeed
	ejc
;
;      any (one character argument) (1-char string also)
;
;      parm1		     character argument
;
p_ans	ent	bl_p1			; p1blk
	beq	wb,pmssl,failp		; fail if no chars left
	mov	xl,r_pms		; else point to subject string
	plc	xl,wb			; point to current character
	lch	wa,(xl)			; load current character
	bne	wa,parm1(xr),failp	; fail if no match
	icv	wb			; else bump cursor
	brn	succp			; and succeed
	ejc
;
;      any (multi-character argument case)
;
;      parm1		     pointer to ctblk
;      parm2		     bit mask to select bit in ctblk
;
p_any	ent	bl_p2			; p2blk
;
;      expression argument case merges here
;
pany1	beq	wb,pmssl,failp		; fail if no characters left
	mov	xl,r_pms		; else point to subject string
	plc	xl,wb			; get char ptr to current character
	lch	wa,(xl)			; load current character
	mov	xl,parm1(xr)		; point to ctblk
	wtb	wa			; change to byte offset
	add	xl,wa			; point to entry in ctblk
	mov	wa,ctchs(xl)		; load word from ctblk
	anb	wa,parm2(xr)		; and with selected bit
	zrb	wa,failp		; fail if no match
	icv	wb			; else bump cursor
	brn	succp			; and succeed
	ejc
;
;      any (expression argument)
;
;      parm1		     expression pointer
;
p_ayd	ent	bl_p1			; p1blk
	jsr	evals			; evaluate string argument
	err	043,any evaluated argument is not a string
	ppm	failp			; fail if evaluation failure
	ppm	pany1			; merge multi-char case if ok
	ejc
;
;      p_arb		     initial arb match
;
;      no parameters
;
;      the p_arb node is part of a compound pattern structure
;      for an arb pattern (see description of compound patterns)
;
p_arb	ent	bl_p0			; p0blk
	mov	xr,pthen(xr)		; load successor pointer
	mov	-(xs),wb		; stack dummy cursor
	mov	-(xs),xr		; stack successor pointer
	mov	-(xs),wb		; stack cursor
	mov	-(xs),=ndarc		; stack ptr to special node ndarc
	bri	(xr)			; execute next node matching null
	ejc
;
;      p_arc		     extend arb match
;
;      no parameters (dummy pattern)
;
p_arc	ent				; entry point
	beq	wb,pmssl,flpop		; fail and pop stack to successor
	icv	wb			; else bump cursor
	mov	-(xs),wb		; stack updated cursor
	mov	-(xs),xr		; restack pointer to ndarc node
	mov	xr,num02(xs)		; load successor pointer
	bri	(xr)			; off to reexecute successor node
	ejc
;
;      bal
;
;      no parameters
;
;      the p_bal node is part of the compound structure built
;      for bal (see section on compound patterns).
;
p_bal	ent	bl_p0			; p0blk
	zer	wc			; zero parentheses level counter
	mov	xl,r_pms		; point to subject string
	plc	xl,wb			; point to current character
	brn	pbal2			; jump into scan loop
;
;      loop to scan out characters
;
pbal1	lch	wa,(xl)+		; load next character, bump pointer
	icv	wb			; push cursor for character
	beq	wa,=ch_pp,pbal3		; jump if left paren
	beq	wa,=ch_rp,pbal4		; jump if right paren
	bze	wc,pbal5		; else succeed if at outer level
;
;      here after processing one character
;
pbal2	bne	wb,pmssl,pbal1		; loop back unless end of string
	brn	failp			; in which case, fail
;
;      here on left paren
;
pbal3	icv	wc			; bump paren level
	brn	pbal2			; loop back to check end of string
;
;      here for right paren
;
pbal4	bze	wc,failp		; fail if no matching left paren
	dcv	wc			; else decrement level counter
	bnz	wc,pbal2		; loop back if not at outer level
;
;      here after successfully scanning a balanced string
;
pbal5	mov	-(xs),wb		; stack cursor
	mov	-(xs),xr		; stack ptr to bal node for extend
	brn	succp			; and succeed
	ejc
;
;      break (expression argument)
;
;      parm1		     expression pointer
;
p_bkd	ent	bl_p1			; p1blk
	jsr	evals			; evaluate string expression
	err	044,break evaluated argument is not a string
	ppm	failp			; fail if evaluation fails
	ppm	pbrk1			; merge with multi-char case if ok
	ejc
;
;      break (one character argument)
;
;      parm1		     character argument
;
p_bks	ent	bl_p1			; p1blk
	mov	wc,pmssl		; get subject string length
	sub	wc,wb			; get number of characters left
	bze	wc,failp		; fail if no characters left
	lct	wc,wc			; set counter for chars left
	mov	xl,r_pms		; point to subject string
	plc	xl,wb			; point to current character
;
;      loop to scan till break character found
;
pbks1	lch	wa,(xl)+		; load next char, bump pointer
	beq	wa,parm1(xr),succp	; succeed if break character found
	icv	wb			; else push cursor
	bct	wc,pbks1		; loop back if more to go
	brn	failp			; fail if end of string, no break chr
	ejc
;
;      break (multi-character argument)
;
;      parm1		     pointer to ctblk
;      parm2		     bit mask to select bit column
;
p_brk	ent	bl_p2			; p2blk
;
;      expression argument merges here
;
pbrk1	mov	wc,pmssl		; load subject string length
	sub	wc,wb			; get number of characters left
	bze	wc,failp		; fail if no characters left
	lct	wc,wc			; set counter for characters left
	mov	xl,r_pms		; else point to subject string
	plc	xl,wb			; point to current character
	mov	psave,xr		; save node pointer
;
;      loop to search for break character
;
pbrk2	lch	wa,(xl)+		; load next char, bump pointer
	mov	xr,parm1(xr)		; load pointer to ctblk
	wtb	wa			; convert to byte offset
	add	xr,wa			; point to ctblk entry
	mov	wa,ctchs(xr)		; load ctblk word
	mov	xr,psave		; restore node pointer
	anb	wa,parm2(xr)		; and with selected bit
	nzb	wa,succp		; succeed if break character found
	icv	wb			; else push cursor
	bct	wc,pbrk2		; loop back unless end of string
	brn	failp			; fail if end of string, no break chr
	ejc
;
;      breakx (extension)
;
;      this is the entry which causes an extension of a breakx
;      match when failure occurs. see section on compound
;      patterns for full details of breakx matching.
;
;      no parameters
;
p_bkx	ent	bl_p0			; p0blk
	icv	wb			; step cursor past previous break chr
	brn	succp			; succeed to rematch break
	ejc
;
;      breakx (expression argument)
;
;      see section on compound patterns for full structure of
;      breakx pattern. the actual character matching uses a
;      break node. however, the entry for the expression
;      argument case is separated to get proper error messages.
;
;      parm1		     expression pointer
;
p_bxd	ent	bl_p1			; p1blk
	jsr	evals			; evaluate string argument
	err	045,breakx evaluated argument is not a string
	ppm	failp			; fail if evaluation fails
	ppm	pbrk1			; merge with break if all ok
	ejc
;
;      cursor assignment
;
;      parm1		     name base
;      parm2		     name offset
;
p_cas	ent	bl_p2			; p2blk
	mov	-(xs),xr		; save node pointer
	mov	-(xs),wb		; save cursor
	mov	xl,parm1(xr)		; load name base
	mti	wb			; load cursor as integer
	mov	wb,parm2(xr)		; load name offset
	jsr	icbld			; get icblk for cursor value
	mov	wa,wb			; move name offset
	mov	wb,xr			; move value to assign
	jsr	asinp			; perform assignment
	ppm	flpop			; fail on assignment failure
	mov	wb,(xs)+		; else restore cursor
	mov	xr,(xs)+		; restore node pointer
	brn	succp			; and succeed matching null
	ejc
;
;      expression node (p_exa, initial entry)
;
;      see compound patterns description for the structure and
;      algorithms for handling expression nodes.
;
;      parm1		     expression pointer
;
p_exa	ent	bl_p1			; p1blk
	jsr	evalp			; evaluate expression
	ppm	failp			; fail if evaluation fails
	blo	wa,=p_aaa,pexa1		; jump if result is not a pattern
;
;      here if result of expression is a pattern
;
	mov	-(xs),wb		; stack dummy cursor
	mov	-(xs),xr		; stack ptr to p_exa node
	mov	-(xs),pmhbs		; stack history stack base ptr
	mov	-(xs),=ndexb		; stack ptr to special node ndexb
	mov	pmhbs,xs		; store new stack base pointer
	mov	xr,xl			; copy node pointer
	bri	(xr)			; match first node in expression pat
;
;      here if result of expression is not a pattern
;
pexa1	beq	wa,=b_scl,pexa2		; jump if it is already a string
	mov	-(xs),xl		; else stack result
	mov	xl,xr			; save node pointer
	jsr	gtstg			; convert result to string
	err	046,expression does not evaluate to pattern
	mov	wc,xr			; copy string pointer
	mov	xr,xl			; restore node pointer
	mov	xl,wc			; copy string pointer again
;
;      merge here with string pointer in xl
;
pexa2	bze	sclen(xl),succp		; just succeed if null string
	brn	pstr1			; else merge with string circuit
	ejc
;
;      expression node (p_exb, remove ndexb entry)
;
;      see compound patterns description for the structure and
;      algorithms for handling expression nodes.
;
;      no parameters (dummy pattern)
;
p_exb	ent				; entry point
	mov	pmhbs,wb		; restore outer level stack pointer
	brn	flpop			; fail and pop p_exa node ptr
	ejc
;
;      expression node (p_exc, remove ndexc entry)
;
;      see compound patterns description for the structure and
;      algorithms for handling expression nodes.
;
;      no parameters (dummy pattern)
;
p_exc	ent				; entry point
	mov	pmhbs,wb		; restore inner stack base pointer
	brn	failp			; and fail into expr pattern alternvs
	ejc
;
;      fail
;
;      no parameters
;
p_fal	ent	bl_p0			; p0blk
	brn	failp			; just signal failure
	ejc
;
;      fence
;
;      see compound patterns section for the structure and
;      algorithm for matching this node type.
;
;      no parameters
;
p_fen	ent	bl_p0			; p0blk
	mov	-(xs),wb		; stack dummy cursor
	mov	-(xs),=ndabo		; stack ptr to abort node
	brn	succp			; and succeed matching null
	ejc
;
;      fence (function)
;
;      see compound patterns comments at start of this section
;      for details of scheme
;
;      no parameters
;
p_fna	ent	bl_p0			; p0blk
	mov	-(xs),pmhbs		; stack current history stack base
	mov	-(xs),=ndfnb		; stack indir ptr to p_fnb (failure)
	mov	pmhbs,xs		; begin new history stack
	brn	succp			; succeed
	ejc
;
;      fence (function) (reset history stack and fail)
;
;      no parameters (dummy pattern)
;
p_fnb	ent	bl_p0			; p0blk
	mov	pmhbs,wb		; restore outer pmhbs stack base
	brn	failp			; ...and fail
	ejc
;
;      fence (function) (make fence trap entry on stack)
;
;      no parameters (dummy pattern)
;
p_fnc	ent	bl_p0			; p0blk
	mov	xt,pmhbs		; get inner stack base ptr
	mov	pmhbs,num01(xt)		; restore outer stack base
	beq	xt,xs,pfnc1		; optimize if no alternatives
	mov	-(xs),xt		; else stack inner stack base
	mov	-(xs),=ndfnd		; stack ptr to ndfnd
	brn	succp			; succeed
;
;      here when fence function left nothing on the stack
;
pfnc1	add	xs,*num02		; pop off p_fnb entry
	brn	succp			; succeed
	ejc
;
;      fence (function) (skip past alternatives on failure)
;
;      no parameters (dummy pattern)
;
p_fnd	ent	bl_p0			; p0blk
	mov	xs,wb			; pop stack to fence() history base
	brn	flpop			; pop base entry and fail
	ejc
;
;      immediate assignment (initial entry, save current cursor)
;
;      see compound patterns description for details of the
;      structure and algorithm for matching this node type.
;
;      no parameters
;
p_ima	ent	bl_p0			; p0blk
	mov	-(xs),wb		; stack cursor
	mov	-(xs),xr		; stack dummy node pointer
	mov	-(xs),pmhbs		; stack old stack base pointer
	mov	-(xs),=ndimb		; stack ptr to special node ndimb
	mov	pmhbs,xs		; store new stack base pointer
	brn	succp			; and succeed
	ejc
;
;      immediate assignment (remove cursor mark entry)
;
;      see compound patterns description for details of the
;      structure and algorithms for matching this node type.
;
;      no parameters (dummy pattern)
;
p_imb	ent				; entry point
	mov	pmhbs,wb		; restore history stack base ptr
	brn	flpop			; fail and pop dummy node ptr
	ejc
;
;      immediate assignment (perform actual assignment)
;
;      see compound patterns description for details of the
;      structure and algorithms for matching this node type.
;
;      parm1		     name base of variable
;      parm2		     name offset of variable
;
p_imc	ent	bl_p2			; p2blk
	mov	xt,pmhbs		; load pointer to p_imb entry
	mov	wa,wb			; copy final cursor
	mov	wb,num03(xt)		; load initial cursor
	mov	pmhbs,num01(xt)		; restore outer stack base pointer
	beq	xt,xs,pimc1		; jump if no history stack entries
	mov	-(xs),xt		; else save inner pmhbs pointer
	mov	-(xs),=ndimd		; and a ptr to special node ndimd
	brn	pimc2			; merge
;
;      here if no entries made on history stack
;
pimc1	add	xs,*num04		; remove ndimb entry and cursor
;
;      merge here to perform assignment
;
pimc2	mov	-(xs),wa		; save current (final) cursor
	mov	-(xs),xr		; save current node pointer
	mov	xl,r_pms		; point to subject string
	sub	wa,wb			; compute substring length
	jsr	sbstr			; build substring
	mov	wb,xr			; move result
	mov	xr,(xs)			; reload node pointer
	mov	xl,parm1(xr)		; load name base
	mov	wa,parm2(xr)		; load name offset
	jsr	asinp			; perform assignment
	ppm	flpop			; fail if assignment fails
	mov	xr,(xs)+		; else restore node pointer
	mov	wb,(xs)+		; restore cursor
	brn	succp			; and succeed
	ejc
;
;      immediate assignment (remove ndimd entry on failure)
;
;      see compound patterns description for details of the
;      structure and algorithms for matching this node type.
;
;      no parameters (dummy pattern)
;
p_imd	ent				; entry point
	mov	pmhbs,wb		; restore inner stack base pointer
	brn	failp			; and fail
	ejc
;
;      len (integer argument)
;
;      parm1		     integer argument
;
p_len	ent	bl_p1			; p1blk
;
;      expression argument case merges here
;
plen1	add	wb,parm1(xr)		; push cursor indicated amount
	ble	wb,pmssl,succp		; succeed if not off end
	brn	failp			; else fail
	ejc
;
;      len (expression argument)
;
;      parm1		     expression pointer
;
p_lnd	ent	bl_p1			; p1blk
	jsr	evali			; evaluate integer argument
	err	047,len evaluated argument is not integer
	err	048,len evaluated argument is negative or too large
	ppm	failp			; fail if evaluation fails
	ppm	plen1			; merge with normal circuit if ok
	ejc
;
;      notany (expression argument)
;
;      parm1		     expression pointer
;
p_nad	ent	bl_p1			; p1blk
	jsr	evals			; evaluate string argument
	err	049,notany evaluated argument is not a string
	ppm	failp			; fail if evaluation fails
	ppm	pnay1			; merge with multi-char case if ok
	ejc
;
;      notany (one character argument)
;
;      parm1		     character argument
;
p_nas	ent	bl_p1			; entry point
	beq	wb,pmssl,failp		; fail if no chars left
	mov	xl,r_pms		; else point to subject string
	plc	xl,wb			; point to current character in strin
	lch	wa,(xl)			; load current character
	beq	wa,parm1(xr),failp	; fail if match
	icv	wb			; else bump cursor
	brn	succp			; and succeed
	ejc
;
;      notany (multi-character string argument)
;
;      parm1		     pointer to ctblk
;      parm2		     bit mask to select bit column
;
p_nay	ent	bl_p2			; p2blk
;
;      expression argument case merges here
;
pnay1	beq	wb,pmssl,failp		; fail if no characters left
	mov	xl,r_pms		; else point to subject string
	plc	xl,wb			; point to current character
	lch	wa,(xl)			; load current character
	wtb	wa			; convert to byte offset
	mov	xl,parm1(xr)		; load pointer to ctblk
	add	xl,wa			; point to entry in ctblk
	mov	wa,ctchs(xl)		; load entry from ctblk
	anb	wa,parm2(xr)		; and with selected bit
	nzb	wa,failp		; fail if character is matched
	icv	wb			; else bump cursor
	brn	succp			; and succeed
	ejc
;
;      end of pattern match
;
;      this routine is entered on successful completion.
;      see description of expression patterns in compound
;      pattern section for handling of recursion in matching.
;
;      this pattern also results from an attempt to convert the
;      null string to a pattern via convert()
;
;      no parameters (dummy pattern)
;
p_nth	ent	bl_p0			; p0blk (dummy)
	mov	xt,pmhbs		; load pointer to base of stack
	mov	wa,num01(xt)		; load saved pmhbs (or pattern type)
	ble	wa,=num02,pnth2		; jump if outer level (pattern type)
;
;      here we are at the end of matching an expression pattern
;
	mov	pmhbs,wa		; restore outer stack base pointer
	mov	xr,num02(xt)		; restore pointer to p_exa node
	beq	xt,xs,pnth1		; jump if no history stack entries
	mov	-(xs),xt		; else stack inner stack base ptr
	mov	-(xs),=ndexc		; stack ptr to special node ndexc
	brn	succp			; and succeed
;
;      here if no history stack entries during pattern
;
pnth1	add	xs,*num04		; remove p_exb entry and node ptr
	brn	succp			; and succeed
;
;      here if end of match at outer level
;
pnth2	mov	pmssl,wb		; save final cursor in safe place
	bze	pmdfl,pnth6		; jump if no pattern assignments
	ejc
;
;      end of pattern match (continued)
;
;      now we must perform pattern assignments. this is done by
;      scanning the history stack for matching ndpab-ndpad pairs
;
pnth3	dca	xt			; point past cursor entry
	mov	wa,-(xt)		; load node pointer
	beq	wa,=ndpad,pnth4		; jump if ndpad entry
	bne	wa,=ndpab,pnth5		; jump if not ndpab entry
;
;      here for ndpab entry, stack initial cursor
;      note that there must be more entries on the stack.
;
	mov	-(xs),num01(xt)		; stack initial cursor
	chk				; check for stack overflow
	brn	pnth3			; loop back if ok
;
;      here for ndpad entry. the starting cursor from the
;      matching ndpad entry is now the top stack entry.
;
pnth4	mov	wa,num01(xt)		; load final cursor
	mov	wb,(xs)			; load initial cursor from stack
	mov	(xs),xt			; save history stack scan ptr
	sub	wa,wb			; compute length of string
;
;      build substring and perform assignment
;
	mov	xl,r_pms		; point to subject string
	jsr	sbstr			; construct substring
	mov	wb,xr			; copy substring pointer
	mov	xt,(xs)			; reload history stack scan ptr
	mov	xl,num02(xt)		; load pointer to p_pac node with nam
	mov	wa,parm2(xl)		; load name offset
	mov	xl,parm1(xl)		; load name base
	jsr	asinp			; perform assignment
	ppm	exfal			; match fails if name eval fails
	mov	xt,(xs)+		; else restore history stack ptr
	ejc
;
;      end of pattern match (continued)
;
;      here check for end of entries
;
pnth5	bne	xt,xs,pnth3		; loop if more entries to scan
;
;      here after dealing with pattern assignments
;
pnth6	mov	xs,pmhbs		; wipe out history stack
	mov	wb,(xs)+		; load initial cursor
	mov	wc,(xs)+		; load match type code
	mov	wa,pmssl		; load final cursor value
	mov	xl,r_pms		; point to subject string
	zer	r_pms			; clear subject string ptr for gbcol
	bze	wc,pnth7		; jump if call by name
	beq	wc,=num02,pnth9		; exit if statement level call
;
;      here we have a call by value, build substring
;
	sub	wa,wb			; compute length of string
	jsr	sbstr			; build substring
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
;
;      here for call by name, make stack entries for o_rpl
;
pnth7	mov	-(xs),wb		; stack initial cursor
	mov	-(xs),wa		; stack final cursor
.if    .cnbf
.else
	bze	r_pmb,pnth8		; skip if subject not buffer
	mov	xl,r_pmb		; else get ptr to bcblk instead
.fi
;
;      here with xl pointing to scblk or bcblk
;
pnth8	mov	-(xs),xl		; stack subject pointer
;
;      here to obey next code word
;
pnth9	lcw	xr			; get next code word
	bri	(xr)			; execute next code word
	ejc
;
;      pos (integer argument)
;
;      parm1		     integer argument
;
p_pos	ent	bl_p1			; p1blk
;
;      optimize pos if it is the first pattern element,
;      unanchored mode, cursor is zero and pos argument
;      is not beyond end of string.  force cursor position
;      and number of unanchored moves.
;
;      this optimization is performed invisible provided
;      the argument is either a simple integer or an
;      expression that is an untraced variable (that is,
;      it has no side effects that would be lost by short-
;      circuiting the normal logic of failing and moving the
;      unanchored starting point.)
;
;      pos (integer argument)
;
;      parm1		     integer argument
;
	beq	wb,parm1(xr),succp	; succeed if at right location
	bnz	wb,failp		; don't look further if cursor not 0
	mov	xt,pmhbs		; get history stack base ptr
	bne	xr,-(xt),failp		; fail if pos is not first node
;
;      expression argument circuit merges here
;
ppos2	bne	-(xt),=nduna,failp	; fail if not unanchored mode
	mov	wb,parm1(xr)		; get desired cursor position
	bgt	wb,pmssl,exfal		; abort if off end
	mov	num02(xt),wb		; fake number of unanchored moves
	brn	succp			; continue match with adjusted cursor
	ejc
;
;      pos (expression argument)
;
;      parm1		     expression pointer
;
p_psd	ent	bl_p1			; p1blk
	jsr	evali			; evaluate integer argument
	err	050,pos evaluated argument is not integer
	err	051,pos evaluated argument is negative or too large
	ppm	failp			; fail if evaluation fails
	ppm	ppos1			; process expression case
;
ppos1	beq	wb,parm1(xr),succp	; succeed if at right location
	bnz	wb,failp		; don't look further if cursor not 0
	bnz	evlif,failp		; fail if complex argument
	mov	xt,pmhbs		; get history stack base ptr
	mov	wa,evlio		; get original node ptr
	bne	wa,-(xt),failp		; fail if pos is not first node
	brn	ppos2			; merge with integer argument code
	ejc
;
;      pattern assignment (initial entry, save cursor)
;
;      see compound patterns description for the structure and
;      algorithms for matching this node type.
;
;      no parameters
;
p_paa	ent	bl_p0			; p0blk
	mov	-(xs),wb		; stack initial cursor
	mov	-(xs),=ndpab		; stack ptr to ndpab special node
	brn	succp			; and succeed matching null
	ejc
;
;      pattern assignment (remove saved cursor)
;
;      see compound patterns description for the structure and
;      algorithms for matching this node type.
;
;      no parameters (dummy pattern)
;
p_pab	ent				; entry point
	brn	failp			; just fail (entry is already popped)
	ejc
;
;      pattern assignment (end of match, make assign entry)
;
;      see compound patterns description for the structure and
;      algorithms for matching this node type.
;
;      parm1		     name base of variable
;      parm2		     name offset of variable
;
p_pac	ent	bl_p2			; p2blk
	mov	-(xs),wb		; stack dummy cursor value
	mov	-(xs),xr		; stack pointer to p_pac node
	mov	-(xs),wb		; stack final cursor
	mov	-(xs),=ndpad		; stack ptr to special ndpad node
	mnz	pmdfl			; set dot flag non-zero
	brn	succp			; and succeed
	ejc
;
;      pattern assignment (remove assign entry)
;
;      see compound patterns description for the structure and
;      algorithms for matching this node type.
;
;      no parameters (dummy node)
;
p_pad	ent				; entry point
	brn	flpop			; fail and remove p_pac node
	ejc
;
;      rem
;
;      no parameters
;
p_rem	ent	bl_p0			; p0blk
	mov	wb,pmssl		; point cursor to end of string
	brn	succp			; and succeed
	ejc
;
;      rpos (expression argument)
;
;      optimize rpos if it is the first pattern element,
;      unanchored mode, cursor is zero and rpos argument
;      is not beyond end of string.  force cursor position
;      and number of unanchored moves.
;
;      this optimization is performed invisibly provided
;      the argument is either a simple integer or an
;      expression that is an untraced variable (that is,
;      it has no side effects that would be lost by short-
;      circuiting the normal logic of failing and moving the
;      unanchored starting point).
;
;      parm1		     expression pointer
;
p_rpd	ent	bl_p1			; p1blk
	jsr	evali			; evaluate integer argument
	err	052,rpos evaluated argument is not integer
	err	053,rpos evaluated argument is negative or too large
	ppm	failp			; fail if evaluation fails
	ppm	prps1			; merge with normal case if ok
;
prps1	mov	wc,pmssl		; get length of string
	sub	wc,wb			; get number of characters remaining
	beq	wc,parm1(xr),succp	; succeed if at right location
	bnz	wb,failp		; don't look further if cursor not 0
	bnz	evlif,failp		; fail if complex argument
	mov	xt,pmhbs		; get history stack base ptr
	mov	wa,evlio		; get original node ptr
	bne	wa,-(xt),failp		; fail if pos is not first node
	brn	prps2			; merge with integer arg code
	ejc
;
;      rpos (integer argument)
;
;      parm1		     integer argument
;
p_rps	ent	bl_p1			; p1blk
;
;      rpos (integer argument)
;
;      parm1		     integer argument
;
	mov	wc,pmssl		; get length of string
	sub	wc,wb			; get number of characters remaining
	beq	wc,parm1(xr),succp	; succeed if at right location
	bnz	wb,failp		; don't look further if cursor not 0
	mov	xt,pmhbs		; get history stack base ptr
	bne	xr,-(xt),failp		; fail if rpos is not first node
;
;      expression argument merges here
;
prps2	bne	-(xt),=nduna,failp	; fail if not unanchored mode
	mov	wb,pmssl		; point to end of string
	blt	wb,parm1(xr),failp	; fail if string not long enough
	sub	wb,parm1(xr)		; else set new cursor
	mov	num02(xt),wb		; fake number of unanchored moves
	brn	succp			; continue match with adjusted cursor
	ejc
;
;      rtab (integer argument)
;
;      parm1		     integer argument
;
p_rtb	ent	bl_p1			; p1blk
;
;      expression argument case merges here
;
prtb1	mov	wc,wb			; save initial cursor
	mov	wb,pmssl		; point to end of string
	blt	wb,parm1(xr),failp	; fail if string not long enough
	sub	wb,parm1(xr)		; else set new cursor
	bge	wb,wc,succp		; and succeed if not too far already
	brn	failp			; in which case, fail
	ejc
;
;      rtab (expression argument)
;
;      parm1		     expression pointer
;
p_rtd	ent	bl_p1			; p1blk
	jsr	evali			; evaluate integer argument
	err	054,rtab evaluated argument is not integer
	err	055,rtab evaluated argument is negative or too large
	ppm	failp			; fail if evaluation fails
	ppm	prtb1			; merge with normal case if success
	ejc
;
;      span (expression argument)
;
;      parm1		     expression pointer
;
p_spd	ent	bl_p1			; p1blk
	jsr	evals			; evaluate string argument
	err	056,span evaluated argument is not a string
	ppm	failp			; fail if evaluation fails
	ppm	pspn1			; merge with multi-char case if ok
	ejc
;
;      span (multi-character argument case)
;
;      parm1		     pointer to ctblk
;      parm2		     bit mask to select bit column
;
p_spn	ent	bl_p2			; p2blk
;
;      expression argument case merges here
;
pspn1	mov	wc,pmssl		; copy subject string length
	sub	wc,wb			; calculate number of characters left
	bze	wc,failp		; fail if no characters left
	mov	xl,r_pms		; point to subject string
	plc	xl,wb			; point to current character
	mov	psavc,wb		; save initial cursor
	mov	psave,xr		; save node pointer
	lct	wc,wc			; set counter for chars left
;
;      loop to scan matching characters
;
pspn2	lch	wa,(xl)+		; load next character, bump pointer
	wtb	wa			; convert to byte offset
	mov	xr,parm1(xr)		; point to ctblk
	add	xr,wa			; point to ctblk entry
	mov	wa,ctchs(xr)		; load ctblk entry
	mov	xr,psave		; restore node pointer
	anb	wa,parm2(xr)		; and with selected bit
	zrb	wa,pspn3		; jump if no match
	icv	wb			; else push cursor
	bct	wc,pspn2		; loop back unless end of string
;
;      here after scanning matching characters
;
pspn3	bne	wb,psavc,succp		; succeed if chars matched
	brn	failp			; else fail if null string matched
	ejc
;
;      span (one character argument)
;
;      parm1		     character argument
;
p_sps	ent	bl_p1			; p1blk
	mov	wc,pmssl		; get subject string length
	sub	wc,wb			; calculate number of characters left
	bze	wc,failp		; fail if no characters left
	mov	xl,r_pms		; else point to subject string
	plc	xl,wb			; point to current character
	mov	psavc,wb		; save initial cursor
	lct	wc,wc			; set counter for characters left
;
;      loop to scan matching characters
;
psps1	lch	wa,(xl)+		; load next character, bump pointer
	bne	wa,parm1(xr),psps2	; jump if no match
	icv	wb			; else push cursor
	bct	wc,psps1		; and loop unless end of string
;
;      here after scanning matching characters
;
psps2	bne	wb,psavc,succp		; succeed if chars matched
	brn	failp			; fail if null string matched
	ejc
;
;      multi-character string
;
;      note that one character strings use the circuit for
;      one character any arguments (p_an1).
;
;      parm1		     pointer to scblk for string arg
;
p_str	ent	bl_p1			; p1blk
	mov	xl,parm1(xr)		; get pointer to string
;
;      merge here after evaluating expression with string value
;
pstr1	mov	psave,xr		; save node pointer
	mov	xr,r_pms		; load subject string pointer
	plc	xr,wb			; point to current character
	add	wb,sclen(xl)		; compute new cursor position
	bgt	wb,pmssl,failp		; fail if past end of string
	mov	psavc,wb		; save updated cursor
	mov	wa,sclen(xl)		; get number of chars to compare
	plc	xl			; point to chars of test string
	cmc	failp,failp		; compare, fail if not equal
	mov	xr,psave		; if all matched, restore node ptr
	mov	wb,psavc		; restore updated cursor
	brn	succp			; and succeed
	ejc
;
;      succeed
;
;      see section on compound patterns for details of the
;      structure and algorithms for matching this node type
;
;      no parameters
;
p_suc	ent	bl_p0			; p0blk
	mov	-(xs),wb		; stack cursor
	mov	-(xs),xr		; stack pointer to this node
	brn	succp			; succeed matching null
	ejc
;
;      tab (integer argument)
;
;      parm1		     integer argument
;
p_tab	ent	bl_p1			; p1blk
;
;      expression argument case merges here
;
ptab1	bgt	wb,parm1(xr),failp	; fail if too far already
	mov	wb,parm1(xr)		; else set new cursor position
	ble	wb,pmssl,succp		; succeed if not off end
	brn	failp			; else fail
	ejc
;
;      tab (expression argument)
;
;      parm1		     expression pointer
;
p_tbd	ent	bl_p1			; p1blk
	jsr	evali			; evaluate integer argument
	err	057,tab evaluated argument is not integer
	err	058,tab evaluated argument is negative or too large
	ppm	failp			; fail if evaluation fails
	ppm	ptab1			; merge with normal case if ok
	ejc
;
;      anchor movement
;
;      no parameters (dummy node)
;
p_una	ent				; entry point
	mov	xr,wb			; copy initial pattern node pointer
	mov	wb,(xs)			; get initial cursor
	beq	wb,pmssl,exfal		; match fails if at end of string
	icv	wb			; else increment cursor
	mov	(xs),wb			; store incremented cursor
	mov	-(xs),xr		; restack initial node ptr
	mov	-(xs),=nduna		; restack unanchored node
	bri	(xr)			; rematch first node
	ejc
;
;      end of pattern match routines
;
;      the following entry point marks the end of the pattern
;      matching routines and also the end of the entry points
;      referenced from the first word of blocks in dynamic store
;
p_yyy	ent	bl__i			; mark last entry in pattern section
	ttl	s p i t b o l -- snobol4 built-in label routines
;
;      the following section contains the routines for labels
;      which have a predefined meaning in snobol4.
;
;      control is passed directly to the label name entry point.
;
;      entry names are of the form l_xxx where xxx is the three
;      letter variable name identifier.
;
;      entries are in alphabetical order
	ejc
;
;      abort
;
l_abo	ent				; entry point
;
;      merge here if execution terminates in error
;
labo1	mov	wa,kvert		; load error code
	bze	wa,labo3		; jump if no error has occured
.if    .csax
	jsr	sysax			; call after execution proc
.fi
.if    .cera
.if    .csfn
	mov	wc,kvstn		; current statement
	jsr	filnm			; obtain file name for this statement
.fi
.if    .csln
	mov	xr,r_cod		; current code block
	mov	wc,cdsln(xr)		; line number
.else
	zer	wc			; line number
.fi
	zer	wb			; column number
	mov	xr,stage		;
	jsr	sysea			; advise system of error
	ppm	stpr4			; if system does not want print
.fi
	jsr	prtpg			; else eject printer
.if    .cera
	bze	xr,labo2		; did sysea request print
	jsr	prtst			; print text from sysea
.fi
labo2	jsr	ermsg			; print error message
	zer	xr			; indicate no message to print
	brn	stopr			; jump to routine to stop run
;
;      here if no error had occured
;
labo3	erb	036,goto abort with no preceding error
	ejc
;
;      continue
;
l_cnt	ent				; entry point
;
;      merge here after execution error
;
lcnt1	mov	xr,r_cnt		; load continuation code block ptr
	bze	xr,lcnt3		; jump if no previous error
	zer	r_cnt			; clear flag
	mov	r_cod,xr		; else store as new code block ptr
	bne	(xr),=b_cdc,lcnt2	; jump if not complex go
	mov	wa,stxoc		; get offset of error
	bge	wa,stxof,lcnt4		; jump if error in goto evaluation
;
;      here if error did not occur in complex failure goto
;
lcnt2	add	xr,stxof		; add failure offset
	lcp	xr			; load code pointer
	mov	xs,flptr		; reset stack pointer
	lcw	xr			; get next code word
	bri	(xr)			; execute next code word
;
;      here if no previous error
;
lcnt3	icv	errft			; fatal error
	erb	037,goto continue with no preceding error
;
;      here if error in evaluation of failure goto.
;      cannot continue back to failure goto!
;
lcnt4	icv	errft			; fatal error
	erb	332,goto continue with error in failure goto
	ejc
;
;      end
;
l_end	ent				; entry point
;
;      merge here from end code circuit
;
lend0	mov	xr,=endms		; point to message /normal term.../
	brn	stopr			; jump to routine to stop run
	ejc
;
;      freturn
;
l_frt	ent				; entry point
	mov	wa,=scfrt		; point to string /freturn/
	brn	retrn			; jump to common return routine
	ejc
;
;      nreturn
;
l_nrt	ent				; entry point
	mov	wa,=scnrt		; point to string /nreturn/
	brn	retrn			; jump to common return routine
	ejc
;
;      return
;
l_rtn	ent				; entry point
	mov	wa,=scrtn		; point to string /return/
	brn	retrn			; jump to common return routine
	ejc
;
;      scontinue
;
l_scn	ent				; entry point
	mov	xr,r_cnt		; load continuation code block ptr
	bze	xr,lscn2		; jump if no previous error
	zer	r_cnt			; clear flag
	bne	kvert,=nm320,lscn1	; error must be user interrupt
	beq	kvert,=nm321,lscn2	; detect scontinue loop
	mov	r_cod,xr		; else store as new code block ptr
	add	xr,stxoc		; add resume offset
	lcp	xr			; load code pointer
	lcw	xr			; get next code word
	bri	(xr)			; execute next code word
;
;      here if no user interrupt
;
lscn1	icv	errft			; fatal error
	erb	331,goto scontinue with no user interrupt
;
;      here if in scontinue loop or if no previous error
;
lscn2	icv	errft			; fatal error
	erb	321,goto scontinue with no preceding error
	ejc
;
;      undefined label
;
l_und	ent				; entry point
	erb	038,goto undefined label
	ttl	s p i t b o l -- predefined snobol4 functions
;
;      the following section contains coding for functions
;      which are predefined and available at the snobol level.
;
;      these routines receive control directly from the code or
;      indirectly through the o_fnc, o_fns or cfunc routines.
;      in both cases the conditions on entry are as follows
;
;      the arguments are on the stack. the number of arguments
;      has been adjusted to correspond to the svblk svnar field.
;
;      in certain functions the direct call is not permitted
;      and in these instances we also have.
;
;      (wa)		     actual number of arguments in call
;
;      control returns by placing the function result value on
;      on the stack and continuing execution with the next
;      word from the generated code.
;
;      the names of the entry points of these functions are of
;      the form s_xxx where xxx is the three letter code for
;      the system variable name. the functions are in order
;      alphabetically by their entry names.
	ejc
.if    .c370
;
;      abs
;
s_abs	ent				; entry point
	mov	xr,(xs)+		; get argument
	jsr	gtnum			; make numeric
	err	xxx,abs argument not numeric
.if    .cnra
.else
	beq	wa,=b_rcl,sabs1		; jump if real
.fi
	ldi	icval(xr)		; load integer value
	ige	exixr			; no change if not negative
	ngi				; produce absolute value
	ino	exint			; return integer if no overflow
	erb	xxx,abs caused integer overflow
.if    .cnra
.else
;
;      here to process real argument
;
sabs1	ldr	rcval(xr)		; load real value
	rge	exixr			; no change if not negative
	ngr				; produce absolute value
	rno	exrea			; return real if no overflow
	erb	xxx,abs caused real overflow
.fi
.fi
.if    .c370
;
;      and
;
s_and	ent				; entry point
	mnz	wb			; signal two arguments
	jsr	sbool			; call string boolean routine
	err	xxx,and first argument is not a string
	err	xxx,and second argument is not a string
	err	xxx,and arguments not same length
	ppm	exits			; null string arguments
;
;      here to process (wc) words.  result is stacked.
;
sand1	mov	wa,(xl)+		; get next cfp_c chars from arg 1
	anb	wa,(xr)			; and with characters from arg 2
	mov	(xr)+,wa		; put back in memory
	bct	wc,sand1		; loop over all words in string block
	brn	exits			; fetch next code word
	ejc
.fi
;
;      any
;
s_any	ent				; entry point
	mov	wb,=p_ans		; set pcode for single char case
	mov	xl,=p_any		; pcode for multi-char case
	mov	wc,=p_ayd		; pcode for expression case
	jsr	patst			; call common routine to build node
	err	059,any argument is not a string or expression
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
.if    .cnbf
.else
;
;      append
;
s_apn	ent				; entry point
	mov	xl,(xs)+		; get append argument
	mov	xr,(xs)+		; get bcblk
	beq	(xr),=b_bct,sapn1	; ok if first arg is bcblk
	erb	275,append first argument is not a buffer
;
;      here to do the append
;
sapn1	jsr	apndb			; do the append
	err	276,append second argument is not a string
	ppm	exfal			; no room - fail
	brn	exnul			; exit with null result
	ejc
.fi
;
;      apply
;
;      apply does not permit the direct (fast) call so that
;      wa contains the actual number of arguments passed.
;
s_app	ent				; entry point
	bze	wa,sapp3		; jump if no arguments
	dcv	wa			; else get applied func arg count
	mov	wb,wa			; copy
	wtb	wb			; convert to bytes
	mov	xt,xs			; copy stack pointer
	add	xt,wb			; point to function argument on stack
	mov	xr,(xt)			; load function ptr (apply 1st arg)
	bze	wa,sapp2		; jump if no args for applied func
	lct	wb,wa			; else set counter for loop
;
;      loop to move arguments up on stack
;
sapp1	dca	xt			; point to next argument
	mov	num01(xt),(xt)		; move argument up
	bct	wb,sapp1		; loop till all moved
;
;      merge here to call function (wa = number of arguments)
;
sapp2	ica	xs			; adjust stack ptr for apply 1st arg
	jsr	gtnvr			; get variable block addr for func
	ppm	sapp3			; jump if not natural variable
	mov	xl,vrfnc(xr)		; else point to function block
	brn	cfunc			; go call applied function
;
;      here for invalid first argument
;
sapp3	erb	060,apply first arg is not natural variable name
	ejc
;
;      arbno
;
;      arbno builds a compound pattern. see description at
;      start of pattern matching section for structure formed.
;
s_abn	ent				; entry point
	zer	xr			; set parm1 = 0 for the moment
	mov	wb,=p_alt		; set pcode for alternative node
	jsr	pbild			; build alternative node
	mov	xl,xr			; save ptr to alternative pattern
	mov	wb,=p_abc		; pcode for p_abc
	zer	xr			; p0blk
	jsr	pbild			; build p_abc node
	mov	pthen(xr),xl		; put alternative node as successor
	mov	wa,xl			; remember alternative node pointer
	mov	xl,xr			; copy p_abc node ptr
	mov	xr,(xs)			; load arbno argument
	mov	(xs),wa			; stack alternative node pointer
	jsr	gtpat			; get arbno argument as pattern
	err	061,arbno argument is not pattern
	jsr	pconc			; concat arg with p_abc node
	mov	xl,xr			; remember ptr to concd patterns
	mov	wb,=p_aba		; pcode for p_aba
	zer	xr			; p0blk
	jsr	pbild			; build p_aba node
	mov	pthen(xr),xl		; concatenate nodes
	mov	xl,(xs)			; recall ptr to alternative node
	mov	parm1(xl),xr		; point alternative back to argument
	lcw	xr			; get next code word
	bri	(xr)			; execute next code word
	ejc
;
;      arg
;
s_arg	ent				; entry point
	jsr	gtsmi			; get second arg as small integer
	err	062,arg second argument is not integer
	ppm	exfal			; fail if out of range or negative
	mov	wa,xr			; save argument number
	mov	xr,(xs)+		; load first argument
	jsr	gtnvr			; locate vrblk
	ppm	sarg1			; jump if not natural variable
	mov	xr,vrfnc(xr)		; else load function block pointer
	bne	(xr),=b_pfc,sarg1	; jump if not program defined
	bze	wa,exfal		; fail if arg number is zero
	bgt	wa,fargs(xr),exfal	; fail if arg number is too large
	wtb	wa			; else convert to byte offset
	add	xr,wa			; point to argument selected
	mov	xr,pfagb(xr)		; load argument vrblk pointer
	brn	exvnm			; exit to build nmblk
;
;      here if 1st argument is bad
;
sarg1	erb	063,arg first argument is not program function name
	ejc
;
;      array
;
s_arr	ent				; entry point
	mov	xl,(xs)+		; load initial element value
	mov	xr,(xs)+		; load first argument
	jsr	gtint			; convert first arg to integer
	ppm	sar02			; jump if not integer
;
;      here for integer first argument, build vcblk
;
	ldi	icval(xr)		; load integer value
	ile	sar10			; jump if zero or neg (bad dimension)
	mfi	wa,sar11		; else convert to one word, test ovfl
	jsr	vmake			; create vector
	ppm	sar11			; fail if too large
	brn	exsid			; exit setting idval
	ejc
;
;      array (continued)
;
;      here if first argument is not an integer
;
sar02	mov	-(xs),xr		; replace argument on stack
	jsr	xscni			; initialize scan of first argument
	err	064,array first argument is not integer or string
	ppm	exnul			; dummy (unused) null string exit
	mov	-(xs),r_xsc		; save prototype pointer
	mov	-(xs),xl		; save default value
	zer	arcdm			; zero count of dimensions
	zer	arptr			; zero offset to indicate pass one
	ldi	intv1			; load integer one
	sti	arnel			; initialize element count
;
;      the following code is executed twice. the first time
;      (arptr eq 0), it is used to count the number of elements
;      and number of dimensions. the second time (arptr gt 0) is
;      used to actually fill in the dim,lbd fields of the arblk.
;
sar03	ldi	intv1			; load one as default low bound
	sti	arsvl			; save as low bound
	mov	wc,=ch_cl		; set delimiter one = colon
	mov	xl,=ch_cm		; set delimiter two = comma
	zer	wa			; retain blanks in prototype
	jsr	xscan			; scan next bound
	bne	wa,=num01,sar04		; jump if not colon
;
;      here we have a colon ending a low bound
;
	jsr	gtint			; convert low bound
	err	065,array first argument lower bound is not integer
	ldi	icval(xr)		; load value of low bound
	sti	arsvl			; store low bound value
	mov	wc,=ch_cm		; set delimiter one = comma
	mov	xl,wc			; and delimiter two = comma
	zer	wa			; retain blanks in prototype
	jsr	xscan			; scan high bound
	ejc
;
;      array (continued)
;
;      merge here to process upper bound
;
sar04	jsr	gtint			; convert high bound to integer
	err	066,array first argument upper bound is not integer
	ldi	icval(xr)		; get high bound
	sbi	arsvl			; subtract lower bound
	iov	sar10			; bad dimension if overflow
	ilt	sar10			; bad dimension if negative
	adi	intv1			; add 1 to get dimension
	iov	sar10			; bad dimension if overflow
	mov	xl,arptr		; load offset (also pass indicator)
	bze	xl,sar05		; jump if first pass
;
;      here in second pass to store lbd and dim in arblk
;
	add	xl,(xs)			; point to current location in arblk
	sti	cfp_i(xl)		; store dimension
	ldi	arsvl			; load low bound
	sti	(xl)			; store low bound
	add	arptr,*ardms		; bump offset to next bounds
	brn	sar06			; jump to check for end of bounds
;
;      here in pass 1
;
sar05	icv	arcdm			; bump dimension count
	mli	arnel			; multiply dimension by count so far
	iov	sar11			; too large if overflow
	sti	arnel			; else store updated element count
;
;      merge here after processing one set of bounds
;
sar06	bnz	wa,sar03		; loop back unless end of bounds
	bnz	arptr,sar09		; jump if end of pass 2
	ejc
;
;      array (continued)
;
;      here at end of pass one, build arblk
;
	ldi	arnel			; get number of elements
	mfi	wb,sar11		; get as addr integer, test ovflo
	wtb	wb			; else convert to length in bytes
	mov	wa,*arsi_		; set size of standard fields
	lct	wc,arcdm		; set dimension count to control loop
;
;      loop to allow space for dimensions
;
sar07	add	wa,*ardms		; allow space for one set of bounds
	bct	wc,sar07		; loop back till all accounted for
	mov	xl,wa			; save size (=arofs)
;
;      now allocate space for arblk
;
	add	wa,wb			; add space for elements
	ica	wa			; allow for arpro prototype field
	bgt	wa,mxlen,sar11		; fail if too large
	jsr	alloc			; else allocate arblk
	mov	wb,(xs)			; load default value
	mov	(xs),xr			; save arblk pointer
	mov	wc,wa			; save length in bytes
	btw	wa			; convert length back to words
	lct	wa,wa			; set counter to control loop
;
;      loop to clear entire arblk to default value
;
sar08	mov	(xr)+,wb		; set one word
	bct	wa,sar08		; loop till all set
	ejc
;
;      array (continued)
;
;      now set initial fields of arblk
;
	mov	xr,(xs)+		; reload arblk pointer
	mov	wb,(xs)			; load prototype
	mov	(xr),=b_art		; set type word
	mov	arlen(xr),wc		; store length in bytes
	zer	idval(xr)		; zero id till we get it built
	mov	arofs(xr),xl		; set prototype field ptr
	mov	arndm(xr),arcdm		; set number of dimensions
	mov	wc,xr			; save arblk pointer
	add	xr,xl			; point to prototype field
	mov	(xr),wb			; store prototype ptr in arblk
	mov	arptr,*arlbd		; set offset for pass 2 bounds scan
	mov	r_xsc,wb		; reset string pointer for xscan
	mov	(xs),wc			; store arblk pointer on stack
	zer	xsofs			; reset offset ptr to start of string
	brn	sar03			; jump back to rescan bounds
;
;      here after filling in bounds information (end pass two)
;
sar09	mov	xr,(xs)+		; reload pointer to arblk
	brn	exsid			; exit setting idval
;
;      here for bad dimension
;
sar10	erb	067,array dimension is zero, negative or out of range
;
;      here if array is too large
;
sar11	erb	068,array size exceeds maximum permitted
	ejc
.if    .cmth
;
;      atan
;
s_atn	ent				; entry point
	mov	xr,(xs)+		; get argument
	jsr	gtrea			; convert to real
	err	301,atan argument not numeric
	ldr	rcval(xr)		; load accumulator with argument
	atn				; take arctangent
	brn	exrea			; overflow, out of range not possible
	ejc
.fi
.if    .cbsp
	ejc
;
;      backspace
;
s_bsp	ent				; entry point
	jsr	iofcb			; call fcblk routine
	err	316,backspace argument is not a suitable name
	err	316,backspace argument is not a suitable name
	err	317,backspace file does not exist
	jsr	sysbs			; call backspace file function
	err	317,backspace file does not exist
	err	318,backspace file does not permit backspace
	err	319,backspace caused non-recoverable error
	brn	exnul			; return null as result
	ejc
.fi
.if    .cnbf
.else
;
;      buffer
;
s_buf	ent				; entry point
	mov	xl,(xs)+		; get initial value
	mov	xr,(xs)+		; get requested allocation
	jsr	gtint			; convert to integer
	err	269,buffer first argument is not integer
	ldi	icval(xr)		; get value
	ile	sbf01			; branch if negative or zero
	mfi	wa,sbf02		; move with overflow check
	jsr	alobf			; allocate the buffer
	jsr	apndb			; copy it in
	err	270,buffer second argument is not a string or buffer
	err	271,buffer initial value too big for allocation
	brn	exsid			; exit setting idval
;
;      here for invalid allocation size
;
sbf01	erb	272,buffer first argument is not positive
;
;      here for allocation size integer overflow
;
sbf02	erb	273,buffer size exceeds value of maxlngth keyword
	ejc
.fi
;
;      break
;
s_brk	ent				; entry point
	mov	wb,=p_bks		; set pcode for single char case
	mov	xl,=p_brk		; pcode for multi-char case
	mov	wc,=p_bkd		; pcode for expression case
	jsr	patst			; call common routine to build node
	err	069,break argument is not a string or expression
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
;
;      breakx
;
;      breakx is a compound pattern. see description at start
;      of pattern matching section for structure formed.
;
s_bkx	ent				; entry point
	mov	wb,=p_bks		; pcode for single char argument
	mov	xl,=p_brk		; pcode for multi-char argument
	mov	wc,=p_bxd		; pcode for expression case
	jsr	patst			; call common routine to build node
	err	070,breakx argument is not a string or expression
;
;      now hook breakx node on at front end
;
	mov	-(xs),xr		; save ptr to break node
	mov	wb,=p_bkx		; set pcode for breakx node
	jsr	pbild			; build it
	mov	pthen(xr),(xs)		; set break node as successor
	mov	wb,=p_alt		; set pcode for alternation node
	jsr	pbild			; build (parm1=alt=breakx node)
	mov	wa,xr			; save ptr to alternation node
	mov	xr,(xs)			; point to break node
	mov	pthen(xr),wa		; set alternate node as successor
	lcw	xr			; result on stack
	bri	(xr)			; execute next code word
	ejc
;
;      char
;
s_chr	ent				; entry point
	jsr	gtsmi			; convert arg to integer
	err	281,char argument not integer
	ppm	schr1			; too big error exit
	bge	wc,=cfp_a,schr1		; see if out of range of host set
	mov	wa,=num01		; if not set scblk allocation
	mov	wb,wc			; save char code
	jsr	alocs			; allocate 1 bau scblk
	mov	xl,xr			; copy scblk pointer
	psc	xl			; get set to stuff char
	sch	wb,(xl)			; stuff it
	csc	xl			; complete store character
	zer	xl			; clear slop in xl
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
;
;      here if char argument is out of range
;
schr1	erb	282,char argument not in range
	ejc
.if    .cmth
;
;      chop
;
s_chp	ent				; entry point
	mov	xr,(xs)+		; get argument
	jsr	gtrea			; convert to real
	err	302,chop argument not numeric
	ldr	rcval(xr)		; load accumulator with argument
	chp				; truncate to integer valued real
	brn	exrea			; no overflow possible
	ejc
.fi
;
;      clear
;
s_clr	ent				; entry point
	jsr	xscni			; initialize to scan argument
	err	071,clear argument is not a string
	ppm	sclr2			; jump if null
;
;      loop to scan out names in first argument. variables in
;      the list are flagged by setting vrget of vrblk to zero.
;
sclr1	mov	wc,=ch_cm		; set delimiter one = comma
	mov	xl,wc			; delimiter two = comma
	mnz	wa			; skip/trim blanks in prototype
	jsr	xscan			; scan next variable name
	jsr	gtnvr			; locate vrblk
	err	072,clear argument has null variable name
	zer	vrget(xr)		; else flag by zeroing vrget field
	bnz	wa,sclr1		; loop back if stopped by comma
;
;      here after flagging variables in argument list
;
sclr2	mov	wb,hshtb		; point to start of hash table
;
;      loop through slots in hash table
;
sclr3	beq	wb,hshte,exnul		; exit returning null if none left
	mov	xr,wb			; else copy slot pointer
	ica	wb			; bump slot pointer
	sub	xr,*vrnxt		; set offset to merge into loop
;
;      loop through vrblks on one hash chain
;
sclr4	mov	xr,vrnxt(xr)		; point to next vrblk on chain
	bze	xr,sclr3		; jump for next bucket if chain end
	bnz	vrget(xr),sclr5		; jump if not flagged
	ejc
;
;      clear (continued)
;
;      here for flagged variable, do not set value to null
;
	jsr	setvr			; for flagged var, restore vrget
	brn	sclr4			; and loop back for next vrblk
;
;      here to set value of a variable to null
;      protected variables (arb, etc) are exempt
;
sclr5	beq	vrsto(xr),=b_vre,sclr4	; check for protected variable
	mov	xl,xr			; copy vrblk pointer
;
;      loop to locate value at end of possible trblk chain
;
sclr6	mov	wa,xl			; save block pointer
	mov	xl,vrval(xl)		; load next value field
	beq	(xl),=b_trt,sclr6	; loop back if trapped
;
;      now store the null value
;
	mov	xl,wa			; restore block pointer
	mov	vrval(xl),=nulls	; store null constant value
	brn	sclr4			; loop back for next vrblk
	ejc
;
;      code
;
s_cod	ent				; entry point
	mov	xr,(xs)+		; load argument
	jsr	gtcod			; convert to code
	ppm	exfal			; fail if conversion is impossible
	mov	-(xs),xr		; stack result
	zer	r_ccb			; forget interim code block
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
;
;      collect
;
s_col	ent				; entry point
	mov	xr,(xs)+		; load argument
	jsr	gtint			; convert to integer
	err	073,collect argument is not integer
	ldi	icval(xr)		; load collect argument
	sti	clsvi			; save collect argument
	zer	wb			; set no move up
	zer	r_ccb			; forget interim code block
.if    .csed
	zer	dnams			; collect sediment too
	jsr	gbcol			; perform garbage collection
	mov	dnams,xr		; record new sediment size
.else
	jsr	gbcol			; perform garbage collection
.fi
	mov	wa,dname		; point to end of memory
	sub	wa,dnamp		; subtract next location
	btw	wa			; convert bytes to words
	mti	wa			; convert words available as integer
	sbi	clsvi			; subtract argument
	iov	exfal			; fail if overflow
	ilt	exfal			; fail if not enough
	adi	clsvi			; else recompute available
	brn	exint			; and exit with integer result
	ejc
.if    .c370
;
;      compl
;
s_cmp	ent				; entry point
	zer	wb			; signal one argument
	jsr	sbool			; call string boolean routine
	ppm				; only one argument, cannot get here
	err	xxx,compl argument is not a string
	ppm				; cannot have two strings unequal
	ppm	exits			; null string argument
;
;      here to process (wa) characters.	 result is stacked.
;
	lct	wc,wa			; prepare count
	plc	xl			; prepare to load chars from (xl)
	psc	xr			; prepare to store chars into (xr)
scmp1	lch	wa,(xl)+		; get next char from arg 1
	cmb	wa			; complement
	sch	wa,(xr)+		; store into result
	bct	wc,scmp1		; loop over all chars in string block
	csc				; complete store character
	brn	exits			; fetch next code word.
	ejc
.fi
;
;      convert
;
s_cnv	ent				; entry point
	jsr	gtstg			; convert second argument to string
	ppm	scv29			; error if second argument not string
	bze	wa,scv29		; or if null string
.if    .culc
	jsr	flstg			; fold lower case to upper case
.fi
	mov	xl,(xs)			; load first argument
	bne	(xl),=b_pdt,scv01	; jump if not program defined
;
;      here for program defined datatype
;
	mov	xl,pddfp(xl)		; point to dfblk
	mov	xl,dfnam(xl)		; load datatype name
	jsr	ident			; compare with second arg
	ppm	exits			; exit if ident with arg as result
	brn	exfal			; else fail
;
;      here if not program defined datatype
;
scv01	mov	-(xs),xr		; save string argument
	mov	xl,=svctb		; point to table of names to compare
	zer	wb			; initialize counter
	mov	wc,wa			; save length of argument string
;
;      loop through table entries
;
scv02	mov	xr,(xl)+		; load next table entry, bump pointer
	bze	xr,exfal		; fail if zero marking end of list
	bne	wc,sclen(xr),scv05	; jump if wrong length
	mov	cnvtp,xl		; else store table pointer
	plc	xr			; point to chars of table entry
	mov	xl,(xs)			; load pointer to string argument
	plc	xl			; point to chars of string arg
	mov	wa,wc			; set number of chars to compare
	cmc	scv04,scv04		; compare, jump if no match
	ejc
;
;      convert (continued)
;
;      here we have a match
;
scv03	mov	xl,wb			; copy entry number
	ica	xs			; pop string arg off stack
	mov	xr,(xs)+		; load first argument
	bsw	xl,cnvtt		; jump to appropriate routine
	iff	0,scv06			; string
	iff	1,scv07			; integer
	iff	2,scv09			; name
	iff	3,scv10			; pattern
	iff	4,scv11			; array
	iff	5,scv19			; table
	iff	6,scv25			; expression
	iff	7,scv26			; code
	iff	8,scv27			; numeric
.if    .cnra
.else
	iff	cnvrt,scv08		; real
.fi
.if    .cnbf
.else
	iff	cnvbt,scv28		; buffer
.fi
	esw				; end of switch table
;
;      here if no match with table entry
;
scv04	mov	xl,cnvtp		; restore table pointer, merge
;
;      merge here if lengths did not match
;
scv05	icv	wb			; bump entry number
	brn	scv02			; loop back to check next entry
;
;      here to convert to string
;
scv06	mov	-(xs),xr		; replace string argument on stack
	jsr	gtstg			; convert to string
	ppm	exfal			; fail if conversion not possible
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
;
;      convert (continued)
;
;      here to convert to integer
;
scv07	jsr	gtint			; convert to integer
	ppm	exfal			; fail if conversion not possible
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
.if    .cnra
.else
;
;      here to convert to real
;
scv08	jsr	gtrea			; convert to real
	ppm	exfal			; fail if conversion not possible
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
.fi
;
;      here to convert to name
;
scv09	beq	(xr),=b_nml,exixr	; return if already a name
	jsr	gtnvr			; else try string to name convert
	ppm	exfal			; fail if conversion not possible
	brn	exvnm			; else exit building nmblk for vrblk
;
;      here to convert to pattern
;
scv10	jsr	gtpat			; convert to pattern
	ppm	exfal			; fail if conversion not possible
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
;
;      convert to array
;
;      if the first argument is a table, then we go through
;      an intermediate array of addresses that is sorted to
;      provide a result ordered by time of entry in the
;      original table.	see c3.762.
;
scv11	mov	-(xs),xr		; save argument on stack
	zer	wa			; use table chain block addresses
	jsr	gtarr			; get an array
	ppm	exfal			; fail if empty table
	ppm	exfal			; fail if not convertible
	mov	xl,(xs)+		; reload original arg
	bne	(xl),=b_tbt,exsid	; exit if original not a table
	mov	-(xs),xr		; sort the intermediate array
	mov	-(xs),=nulls		; on first column
	zer	wa			; sort ascending
	jsr	sorta			; do sort
	ppm	exfal			; if sort fails, so shall we
	mov	wb,xr			; save array result
	ldi	ardim(xr)		; load dim 1 (number of elements)
	mfi	wa			; get as one word integer
	lct	wa,wa			; copy to control loop
	add	xr,*arvl2		; point to first element in array
;
;      here for each row of this 2-column array
;
scv12	mov	xl,(xr)			; get teblk address
	mov	(xr)+,tesub(xl)		; replace with subscript
	mov	(xr)+,teval(xl)		; replace with value
	bct	wa,scv12		; loop till all copied over
	mov	xr,wb			; retrieve array address
	brn	exsid			; exit setting id field
;
;      convert to table
;
scv19	mov	wa,(xr)			; load first word of block
	mov	-(xs),xr		; replace arblk pointer on stack
	beq	wa,=b_tbt,exits		; return arg if already a table
	bne	wa,=b_art,exfal		; else fail if not an array
	ejc
;
;      convert (continued)
;
;      here to convert an array to table
;
	bne	arndm(xr),=num02,exfal	; fail if not 2-dim array
	ldi	ardm2(xr)		; load dim 2
	sbi	intv2			; subtract 2 to compare
	ine	exfal			; fail if dim2 not 2
;
;      here we have an arblk of the right shape
;
	ldi	ardim(xr)		; load dim 1 (number of elements)
	mfi	wa			; get as one word integer
	lct	wb,wa			; copy to control loop
	add	wa,=tbsi_		; add space for standard fields
	wtb	wa			; convert length to bytes
	jsr	alloc			; allocate space for tbblk
	mov	wc,xr			; copy tbblk pointer
	mov	-(xs),xr		; save tbblk pointer
	mov	(xr)+,=b_tbt		; store type word
	zer	(xr)+			; store zero for idval for now
	mov	(xr)+,wa		; store length
	mov	(xr)+,=nulls		; null initial lookup value
;
;      loop to initialize bucket ptrs to point to table
;
scv20	mov	(xr)+,wc		; set bucket ptr to point to tbblk
	bct	wb,scv20		; loop till all initialized
	mov	wb,*arvl2		; set offset to first arblk element
;
;      loop to copy elements from array to table
;
scv21	mov	xl,num01(xs)		; point to arblk
	beq	wb,arlen(xl),scv24	; jump if all moved
	add	xl,wb			; else point to current location
	add	wb,*num02		; bump offset
	mov	xr,(xl)			; load subscript name
	dca	xl			; adjust ptr to merge (trval=1+1)
	ejc
;
;      convert (continued)
;
;      loop to chase down trblk chain for value
;
scv22	mov	xl,trval(xl)		; point to next value
	beq	(xl),=b_trt,scv22	; loop back if trapped
;
;      here with name in xr, value in xl
;
scv23	mov	-(xs),xl		; stack value
	mov	xl,num01(xs)		; load tbblk pointer
	jsr	tfind			; build teblk (note wb gt 0 by name)
	ppm	exfal			; fail if acess fails
	mov	teval(xl),(xs)+		; store value in teblk
	brn	scv21			; loop back for next element
;
;      here after moving all elements to tbblk
;
scv24	mov	xr,(xs)+		; load tbblk pointer
	ica	xs			; pop arblk pointer
	brn	exsid			; exit setting idval
;
;      convert to expression
;
.if    .cevb
scv25	zer	wb			; by value
	jsr	gtexp			; convert to expression
.else
scv25	jsr	gtexp			; convert to expression
.fi
	ppm	exfal			; fail if conversion not possible
	zer	r_ccb			; forget interim code block
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
;
;      convert to code
;
scv26	jsr	gtcod			; convert to code
	ppm	exfal			; fail if conversion is not possible
	zer	r_ccb			; forget interim code block
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
;
;      convert to numeric
;
scv27	jsr	gtnum			; convert to numeric
	ppm	exfal			; fail if unconvertible
scv31	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
.if    .cnbf
.else
;
;      convert to buffer
;
scv28	mov	-(xs),xr		; stack first arg for procedure
	jsr	gtstb			; get string or buffer
	ppm	exfal			; fail if conversion not possible
	bnz	wb,scv30		; jump if already a buffer
	mov	xl,xr			; save string pointer
	jsr	alobf			; allocate buffer of same size
	jsr	apndb			; copy in the string
	ppm				; already string - cant fail to cnv
	ppm				; must be enough room
	brn	exsid			; exit setting idval field
;
;      here if argument is already a buffer
;
scv30	mov	xr,wb			; return buffer without conversion
	brn	scv31			; merge to return result
	ejc
.fi
;
;      second argument not string or null
;
scv29	erb	074,convert second argument is not a string
;
;      copy
;
s_cop	ent				; entry point
	jsr	copyb			; copy the block
	ppm	exits			; return if no idval field
	brn	exsid			; exit setting id value
	ejc
.if    .cmth
;
;      cos
;
s_cos	ent				; entry point
	mov	xr,(xs)+		; get argument
	jsr	gtrea			; convert to real
	err	303,cos argument not numeric
	ldr	rcval(xr)		; load accumulator with argument
	cos				; take cosine
	rno	exrea			; if no overflow, return result in ra
	erb	322,cos argument is out of range
	ejc
.fi
;
;      data
;
s_dat	ent				; entry point
	jsr	xscni			; prepare to scan argument
	err	075,data argument is not a string
	err	076,data argument is null
;
;      scan out datatype name
;
	mov	wc,=ch_pp		; delimiter one = left paren
	mov	xl,wc			; delimiter two = left paren
	mnz	wa			; skip/trim blanks in prototype
	jsr	xscan			; scan datatype name
	bnz	wa,sdat1		; skip if left paren found
	erb	077,data argument is missing a left paren
;
;      here after scanning datatype name
;
.if    .culc
sdat1	mov	wa,sclen(xr)		; get length
	bze	wa,sdt1a		; avoid folding if null string
	jsr	flstg			; fold lower case to upper case
sdt1a	mov	xl,xr			; save name ptr
.else
sdat1	mov	xl,xr			; save name ptr
.fi
	mov	wa,sclen(xr)		; get length
	ctb	wa,scsi_		; compute space needed
	jsr	alost			; request static store for name
	mov	-(xs),xr		; save datatype name
	mvw				; copy name to static
	mov	xr,(xs)			; get name ptr
	zer	xl			; scrub dud register
	jsr	gtnvr			; locate vrblk for datatype name
	err	078,data argument has null datatype name
	mov	datdv,xr		; save vrblk pointer for datatype
	mov	datxs,xs		; store starting stack value
	zer	wb			; zero count of field names
;
;      loop to scan field names and stack vrblk pointers
;
sdat2	mov	wc,=ch_rp		; delimiter one = right paren
	mov	xl,=ch_cm		; delimiter two = comma
	mnz	wa			; skip/trim blanks in prototype
	jsr	xscan			; scan next field name
	bnz	wa,sdat3		; jump if delimiter found
	erb	079,data argument is missing a right paren
;
;      here after scanning out one field name
;
sdat3	jsr	gtnvr			; locate vrblk for field name
	err	080,data argument has null field name
	mov	-(xs),xr		; stack vrblk pointer
	icv	wb			; increment counter
	beq	wa,=num02,sdat2		; loop back if stopped by comma
	ejc
;
;      data (continued)
;
;      now build the dfblk
;
	mov	wa,=dfsi_		; set size of dfblk standard fields
	add	wa,wb			; add number of fields
	wtb	wa			; convert length to bytes
	mov	wc,wb			; preserve no. of fields
	jsr	alost			; allocate space for dfblk
	mov	wb,wc			; get no of fields
	mov	xt,datxs		; point to start of stack
	mov	wc,(xt)			; load datatype name
	mov	(xt),xr			; save dfblk pointer on stack
	mov	(xr)+,=b_dfc		; store type word
	mov	(xr)+,wb		; store number of fields (fargs)
	mov	(xr)+,wa		; store length (dflen)
	sub	wa,*pddfs		; compute pdblk length (for dfpdl)
	mov	(xr)+,wa		; store pdblk length (dfpdl)
	mov	(xr)+,wc		; store datatype name (dfnam)
	lct	wc,wb			; copy number of fields
;
;      loop to move field name vrblk pointers to dfblk
;
sdat4	mov	(xr)+,-(xt)		; move one field name vrblk pointer
	bct	wc,sdat4		; loop till all moved
;
;      now define the datatype function
;
	mov	wc,wa			; copy length of pdblk for later loop
	mov	xr,datdv		; point to vrblk
	mov	xt,datxs		; point back on stack
	mov	xl,(xt)			; load dfblk pointer
	jsr	dffnc			; define function
	ejc
;
;      data (continued)
;
;      loop to build ffblks
;
;
;      notice that the ffblks are constructed in reverse order
;      so that the required offsets can be obtained from
;      successive decrementation of the pdblk length (in wc).
;
sdat5	mov	wa,*ffsi_		; set length of ffblk
	jsr	alloc			; allocate space for ffblk
	mov	(xr),=b_ffc		; set type word
	mov	fargs(xr),=num01	; store fargs (always one)
	mov	xt,datxs		; point back on stack
	mov	ffdfp(xr),(xt)		; copy dfblk ptr to ffblk
	dca	wc			; decrement old dfpdl to get next ofs
	mov	ffofs(xr),wc		; set offset to this field
	zer	ffnxt(xr)		; tentatively set zero forward ptr
	mov	xl,xr			; copy ffblk pointer for dffnc
	mov	xr,(xs)			; load vrblk pointer for field
	mov	xr,vrfnc(xr)		; load current function pointer
	bne	(xr),=b_ffc,sdat6	; skip if not currently a field func
;
;      here we must chain an old ffblk ptr to preserve it in the
;      case of multiple field functions with the same name
;
	mov	ffnxt(xl),xr		; link new ffblk to previous chain
;
;      merge here to define field function
;
sdat6	mov	xr,(xs)+		; load vrblk pointer
	jsr	dffnc			; define field function
	bne	xs,datxs,sdat5		; loop back till all done
	ica	xs			; pop dfblk pointer
	brn	exnul			; return with null result
	ejc
;
;      datatype
;
s_dtp	ent				; entry point
	mov	xr,(xs)+		; load argument
	jsr	dtype			; get datatype
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
;
;      date
;
s_dte	ent				; entry point
	mov	xr,(xs)+		; load argument
	jsr	gtint			; convert to an integer
	err	330,date argument is not integer
	jsr	sysdt			; call system date routine
	mov	wa,num01(xl)		; load length for sbstr
	bze	wa,exnul		; return null if length is zero
	zer	wb			; set zero offset
	jsr	sbstr			; use sbstr to build scblk
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
;
;      define
;
s_def	ent				; entry point
	mov	xr,(xs)+		; load second argument
	zer	deflb			; zero label pointer in case null
	beq	xr,=nulls,sdf01		; jump if null second argument
	jsr	gtnvr			; else find vrblk for label
	ppm	sdf12			; jump if not a variable name
	mov	deflb,xr		; else set specified entry
;
;      scan function name
;
sdf01	jsr	xscni			; prepare to scan first argument
	err	081,define first argument is not a string
	err	082,define first argument is null
	mov	wc,=ch_pp		; delimiter one = left paren
	mov	xl,wc			; delimiter two = left paren
	mnz	wa			; skip/trim blanks in prototype
	jsr	xscan			; scan out function name
	bnz	wa,sdf02		; jump if left paren found
	erb	083,define first argument is missing a left paren
;
;      here after scanning out function name
;
sdf02	jsr	gtnvr			; get variable name
	err	084,define first argument has null function name
	mov	defvr,xr		; save vrblk pointer for function nam
	zer	wb			; zero count of arguments
	mov	defxs,xs		; save initial stack pointer
	bnz	deflb,sdf03		; jump if second argument given
	mov	deflb,xr		; else default is function name
;
;      loop to scan argument names and stack vrblk pointers
;
sdf03	mov	wc,=ch_rp		; delimiter one = right paren
	mov	xl,=ch_cm		; delimiter two = comma
	mnz	wa			; skip/trim blanks in prototype
	jsr	xscan			; scan out next argument name
	bnz	wa,sdf04		; skip if delimiter found
	erb	085,null arg name or missing ) in define first arg.
	ejc
;
;      define (continued)
;
;      here after scanning an argument name
;
sdf04	bne	xr,=nulls,sdf05		; skip if non-null
	bze	wb,sdf06		; ignore null if case of no arguments
;
;      here after dealing with the case of no arguments
;
sdf05	jsr	gtnvr			; get vrblk pointer
	ppm	sdf03			; loop back to ignore null name
	mov	-(xs),xr		; stack argument vrblk pointer
	icv	wb			; increment counter
	beq	wa,=num02,sdf03		; loop back if stopped by a comma
;
;      here after scanning out function argument names
;
sdf06	mov	defna,wb		; save number of arguments
	zer	wb			; zero count of locals
;
;      loop to scan local names and stack vrblk pointers
;
sdf07	mov	wc,=ch_cm		; set delimiter one = comma
	mov	xl,wc			; set delimiter two = comma
	mnz	wa			; skip/trim blanks in prototype
	jsr	xscan			; scan out next local name
	bne	xr,=nulls,sdf08		; skip if non-null
	bze	wa,sdf09		; exit scan if end of string
;
;      here after scanning out a local name
;
sdf08	jsr	gtnvr			; get vrblk pointer
	ppm	sdf07			; loop back to ignore null name
	icv	wb			; if ok, increment count
	mov	-(xs),xr		; stack vrblk pointer
	bnz	wa,sdf07		; loop back if stopped by a comma
	ejc
;
;      define (continued)
;
;      here after scanning locals, build pfblk
;
sdf09	mov	wa,wb			; copy count of locals
	add	wa,defna		; add number of arguments
	mov	wc,wa			; set sum args+locals as loop count
	add	wa,=pfsi_		; add space for standard fields
	wtb	wa			; convert length to bytes
	jsr	alloc			; allocate space for pfblk
	mov	xl,xr			; save pointer to pfblk
	mov	(xr)+,=b_pfc		; store first word
	mov	(xr)+,defna		; store number of arguments
	mov	(xr)+,wa		; store length (pflen)
	mov	(xr)+,defvr		; store vrblk ptr for function name
	mov	(xr)+,wb		; store number of locals
	zer	(xr)+			; deal with label later
	zer	(xr)+			; zero pfctr
	zer	(xr)+			; zero pfrtr
	bze	wc,sdf11		; skip if no args or locals
	mov	wa,xl			; keep pfblk pointer
	mov	xt,defxs		; point before arguments
	lct	wc,wc			; get count of args+locals for loop
;
;      loop to move locals and args to pfblk
;
sdf10	mov	(xr)+,-(xt)		; store one entry and bump pointers
	bct	wc,sdf10		; loop till all stored
	mov	xl,wa			; recover pfblk pointer
	ejc
;
;      define (continued)
;
;      now deal with label
;
sdf11	mov	xs,defxs		; pop stack
	mov	pfcod(xl),deflb		; store label vrblk in pfblk
	mov	xr,defvr		; point back to vrblk for function
	jsr	dffnc			; define function
	brn	exnul			; and exit returning null
;
;      here for erroneous label
;
sdf12	erb	086,define function entry point is not defined label
	ejc
;
;      detach
;
s_det	ent				; entry point
	mov	xr,(xs)+		; load argument
	jsr	gtvar			; locate variable
	err	087,detach argument is not appropriate name
	jsr	dtach			; detach i/o association from name
	brn	exnul			; return null result
	ejc
;
;      differ
;
s_dif	ent				; entry point
	mov	xr,(xs)+		; load second argument
	mov	xl,(xs)+		; load first argument
	jsr	ident			; call ident comparison routine
	ppm	exfal			; fail if ident
	brn	exnul			; return null if differ
	ejc
;
;      dump
;
s_dmp	ent				; entry point
	jsr	gtsmi			; load dump arg as small integer
	err	088,dump argument is not integer
	err	089,dump argument is negative or too large
	jsr	dumpr			; else call dump routine
	brn	exnul			; and return null as result
	ejc
;
;      dupl
;
s_dup	ent				; entry point
	jsr	gtsmi			; get second argument as small integr
	err	090,dupl second argument is not integer
	ppm	sdup7			; jump if negative or too big
	mov	wb,xr			; save duplication factor
	jsr	gtstg			; get first arg as string
	ppm	sdup4			; jump if not a string
;
;      here for case of duplication of a string
;
	mti	wa			; acquire length as integer
	sti	dupsi			; save for the moment
	mti	wb			; get duplication factor as integer
	mli	dupsi			; form product
	iov	sdup3			; jump if overflow
	ieq	exnul			; return null if result length = 0
	mfi	wa,sdup3		; get as addr integer, check ovflo
;
;      merge here with result length in wa
;
sdup1	mov	xl,xr			; save string pointer
	jsr	alocs			; allocate space for string
	mov	-(xs),xr		; save as result pointer
	mov	wc,xl			; save pointer to argument string
	psc	xr			; prepare to store chars of result
	lct	wb,wb			; set counter to control loop
;
;      loop through duplications
;
sdup2	mov	xl,wc			; point back to argument string
	mov	wa,sclen(xl)		; get number of characters
	plc	xl			; point to chars in argument string
	mvc				; move characters to result string
	bct	wb,sdup2		; loop till all duplications done
	zer	xl			; clear garbage value
	lcw	xr			; get next code word
	bri	(xr)			; execute next code word
	ejc
;
;      dupl (continued)
;
;      here if too large, set max length and let alocs catch it
;
sdup3	mov	wa,dname		; set impossible length for alocs
	brn	sdup1			; merge back
;
;      here if not a string
;
sdup4	jsr	gtpat			; convert argument to pattern
	err	091,dupl first argument is not a string or pattern
;
;      here to duplicate a pattern argument
;
	mov	-(xs),xr		; store pattern on stack
	mov	xr,=ndnth		; start off with null pattern
	bze	wb,sdup6		; null pattern is result if dupfac=0
	mov	-(xs),wb		; preserve loop count
;
;      loop to duplicate by successive concatenation
;
sdup5	mov	xl,xr			; copy current value as right argumnt
	mov	xr,num01(xs)		; get a new copy of left
	jsr	pconc			; concatenate
	dcv	(xs)			; count down
	bnz	(xs),sdup5		; loop
	ica	xs			; pop loop count
;
;      here to exit after constructing pattern
;
sdup6	mov	(xs),xr			; store result on stack
	lcw	xr			; get next code word
	bri	(xr)			; execute next code word
;
;      fail if second arg is out of range
;
sdup7	ica	xs			; pop first argument
	brn	exfal			; fail
	ejc
;
;      eject
;
s_ejc	ent				; entry point
	jsr	iofcb			; call fcblk routine
	err	092,eject argument is not a suitable name
	ppm	sejc1			; null argument
	err	093,eject file does not exist
	jsr	sysef			; call eject file function
	err	093,eject file does not exist
	err	094,eject file does not permit page eject
	err	095,eject caused non-recoverable output error
	brn	exnul			; return null as result
;
;      here to eject standard output file
;
sejc1	jsr	sysep			; call routine to eject printer
	brn	exnul			; exit with null result
	ejc
;
;      endfile
;
s_enf	ent				; entry point
	jsr	iofcb			; call fcblk routine
	err	096,endfile argument is not a suitable name
	err	097,endfile argument is null
	err	098,endfile file does not exist
	jsr	sysen			; call endfile routine
	err	098,endfile file does not exist
	err	099,endfile file does not permit endfile
	err	100,endfile caused non-recoverable output error
	mov	wb,xl			; remember vrblk ptr from iofcb call
	mov	xr,xl			; copy pointer
;
;      loop to find trtrf block
;
senf1	mov	xl,xr			; remember previous entry
	mov	xr,trval(xr)		; chain along
	bne	(xr),=b_trt,exnul	; skip out if chain end
	bne	trtyp(xr),=trtfc,senf1	; loop if not found
	mov	trval(xl),trval(xr)	; remove trtrf
	mov	enfch,trtrf(xr)		; point to head of iochn
	mov	wc,trfpt(xr)		; point to fcblk
	mov	xr,wb			; filearg1 vrblk from iofcb
	jsr	setvr			; reset it
	mov	xl,=r_fcb		; ptr to head of fcblk chain
	sub	xl,*num02		; adjust ready to enter loop
;
;      find fcblk
;
senf2	mov	xr,xl			; copy ptr
	mov	xl,num02(xl)		; get next link
	bze	xl,senf4		; stop if chain end
	beq	num03(xl),wc,senf3	; jump if fcblk found
	brn	senf2			; loop
;
;      remove fcblk
;
senf3	mov	num02(xr),num02(xl)	; delete fcblk from chain
;
;      loop which detaches all vbls on iochn chain
;
senf4	mov	xl,enfch		; get chain head
	bze	xl,exnul		; finished if chain end
	mov	enfch,trtrf(xl)		; chain along
	mov	wa,ionmo(xl)		; name offset
	mov	xl,ionmb(xl)		; name base
	jsr	dtach			; detach name
	brn	senf4			; loop till done
	ejc
;
;      eq
;
s_eqf	ent				; entry point
	jsr	acomp			; call arithmetic comparison routine
	err	101,eq first argument is not numeric
	err	102,eq second argument is not numeric
	ppm	exfal			; fail if lt
	ppm	exnul			; return null if eq
	ppm	exfal			; fail if gt
	ejc
;
;      eval
;
s_evl	ent				; entry point
	mov	xr,(xs)+		; load argument
.if    .cevb
.else
	jsr	gtexp			; convert to expression
	err	103,eval argument is not expression
.fi
	lcw	wc			; load next code word
	bne	wc,=ofne_,sevl1		; jump if called by value
	scp	xl			; copy code pointer
	mov	wa,(xl)			; get next code word
	bne	wa,=ornm_,sevl2		; by name unless expression
	bnz	num01(xs),sevl2		; jump if by name
;
;      here if called by value
;
sevl1	zer	wb			; set flag for by value
.if    .cevb
	mov	-(xs),wc		; save code word
	jsr	gtexp			; convert to expression
	err	103,eval argument is not expression
	zer	r_ccb			; forget interim code block
	zer	wb			; set flag for by value
.else
	mov	-(xs),wc		; save code word
.fi
	jsr	evalx			; evaluate expression by value
	ppm	exfal			; fail if evaluation fails
	mov	xl,xr			; copy result
	mov	xr,(xs)			; reload next code word
	mov	(xs),xl			; stack result
	bri	(xr)			; jump to execute next code word
;
;      here if called by name
;
sevl2	mov	wb,=num01		; set flag for by name
.if    .cevb
	jsr	gtexp			; convert to expression
	err	103,eval argument is not expression
	zer	r_ccb			; forget interim code block
	mov	wb,=num01		; set flag for by name
.fi
	jsr	evalx			; evaluate expression by name
	ppm	exfal			; fail if evaluation fails
	brn	exnam			; exit with name
.if    .cnex
.else
	ejc
;
;      exit
;
s_ext	ent				; entry point
	zer	wb			; clear amount of static shift
	zer	r_ccb			; forget interim code block
.if    .csed
	zer	dnams			; collect sediment too
	jsr	gbcol			; compact memory by collecting
	mov	dnams,xr		; record new sediment size
.else
	jsr	gbcol			; compact memory by collecting
.fi
	jsr	gtstg			;
	err	288,exit second argument is not a string
	mov	xl,xr			; copy second arg string pointer
	jsr	gtstg			; convert arg to string
	err	104,exit first argument is not suitable integer or string
	mov	-(xs),xl		; save second argument
	mov	xl,xr			; copy first arg string ptr
	jsr	gtint			; check it is integer
	ppm	sext1			; skip if unconvertible
	zer	xl			; note it is integer
	ldi	icval(xr)		; get integer arg
;
;      merge to call osint exit routine
;
sext1	mov	wb,r_fcb		; get fcblk chain header
	mov	xr,=headv		; point to v.v string
	mov	wa,(xs)+		; provide second argument scblk
	jsr	sysxi			; call external routine
	err	105,exit action not available in this implementation
	err	106,exit action caused irrecoverable error
	ieq	exnul			; return if argument 0
	igt	sext2			; skip if positive
	ngi				; make positive
;
;      check for option respecification
;
;      sysxi returns 0 in wa when a file has been resumed,
;      1 when this is a continuation of an exit(4) or exit(-4)
;      action.
;
sext2	mfi	wc			; get value in work reg
	add	wa,wc			; prepare to test for continue
	beq	wa,=num05,sext5		; continued execution if 4 plus 1
	zer	gbcnt			; resuming execution so reset
	bge	wc,=num03,sext3		; skip if was 3 or 4
	mov	-(xs),wc		; save value
	zer	wc			; set to read options
	jsr	prpar			; read syspp options
	mov	wc,(xs)+		; restore value
;
;      deal with header option (fiddled by prpar)
;
sext3	mnz	headp			; assume no headers
	bne	wc,=num01,sext4		; skip if not 1
	zer	headp			; request header printing
;
;      almost ready to resume running
;
sext4	jsr	systm			; get execution time start (sgd11)
	sti	timsx			; save as initial time
	ldi	kvstc			; reset to ensure ...
	sti	kvstl			; ... correct execution stats
	jsr	stgcc			; recompute countdown counters
	brn	exnul			; resume execution
;
;      here after exit(4) or exit(-4) -- create save file
;      or load module and continue execution.
;
;      return integer 1 to signal the continuation of the
;      original execution.
;
sext5	mov	xr,=inton		; integer one
	brn	exixr			; return as result
.fi
	ejc
.if    .cmth
;
;      exp
;
s_exp	ent				; entry point
	mov	xr,(xs)+		; get argument
	jsr	gtrea			; convert to real
	err	304,exp argument not numeric
	ldr	rcval(xr)		; load accumulator with argument
	etx				; take exponential
	rno	exrea			; if no overflow, return result in ra
	erb	305,exp produced real overflow
	ejc
.fi
;
;      field
;
s_fld	ent				; entry point
	jsr	gtsmi			; get second argument (field number)
	err	107,field second argument is not integer
	ppm	exfal			; fail if out of range
	mov	wb,xr			; else save integer value
	mov	xr,(xs)+		; load first argument
	jsr	gtnvr			; point to vrblk
	ppm	sfld1			; jump (error) if not variable name
	mov	xr,vrfnc(xr)		; else point to function block
	bne	(xr),=b_dfc,sfld1	; error if not datatype function
;
;      here if first argument is a datatype function name
;
	bze	wb,exfal		; fail if argument number is zero
	bgt	wb,fargs(xr),exfal	; fail if too large
	wtb	wb			; else convert to byte offset
	add	xr,wb			; point to field name
	mov	xr,dfflb(xr)		; load vrblk pointer
	brn	exvnm			; exit to build nmblk
;
;      here for bad first argument
;
sfld1	erb	108,field first argument is not datatype name
	ejc
;
;      fence
;
s_fnc	ent				; entry point
	mov	wb,=p_fnc		; set pcode for p_fnc
	zer	xr			; p0blk
	jsr	pbild			; build p_fnc node
	mov	xl,xr			; save pointer to it
	mov	xr,(xs)+		; get argument
	jsr	gtpat			; convert to pattern
	err	259,fence argument is not pattern
	jsr	pconc			; concatenate to p_fnc node
	mov	xl,xr			; save ptr to concatenated pattern
	mov	wb,=p_fna		; set for p_fna pcode
	zer	xr			; p0blk
	jsr	pbild			; construct p_fna node
	mov	pthen(xr),xl		; set pattern as pthen
	mov	-(xs),xr		; set as result
	lcw	xr			; get next code word
	bri	(xr)			; execute next code word
	ejc
;
;      ge
;
s_gef	ent				; entry point
	jsr	acomp			; call arithmetic comparison routine
	err	109,ge first argument is not numeric
	err	110,ge second argument is not numeric
	ppm	exfal			; fail if lt
	ppm	exnul			; return null if eq
	ppm	exnul			; return null if gt
	ejc
;
;      gt
;
s_gtf	ent				; entry point
	jsr	acomp			; call arithmetic comparison routine
	err	111,gt first argument is not numeric
	err	112,gt second argument is not numeric
	ppm	exfal			; fail if lt
	ppm	exfal			; fail if eq
	ppm	exnul			; return null if gt
	ejc
;
;      host
;
s_hst	ent				; entry point
	mov	wc,(xs)+		; get fifth arg
	mov	wb,(xs)+		; get fourth arg
	mov	xr,(xs)+		; get third arg
	mov	xl,(xs)+		; get second arg
	mov	wa,(xs)+		; get first arg
	jsr	syshs			; enter syshs routine
	err	254,erroneous argument for host
	err	255,error during execution of host
	ppm	shst1			; store host string
	ppm	exnul			; return null result
	ppm	exixr			; return xr
	ppm	exfal			; fail return
	ppm	shst3			; store actual string
	ppm	shst4			; return copy of xr
;
;      return host string
;
shst1	bze	xl,exnul		; null string if syshs uncooperative
	mov	wa,sclen(xl)		; length
	zer	wb			; zero offset
;
;      copy string and return
;
shst2	jsr	sbstr			; build copy of string
	mov	-(xs),xr		; stack the result
	lcw	xr			; load next code word
	bri	(xr)			; execute it
;
;      return actual string pointed to by xl
;
shst3	zer	wb			; treat xl like an scblk ptr
	sub	wb,=cfp_f		; by creating a negative offset
	brn	shst2			; join to copy string
;
;      return copy of block pointed to by xr
;
shst4	mov	-(xs),xr		; stack results
	jsr	copyb			; make copy of block
	ppm	exits			; if not an aggregate structure
	brn	exsid			; set current id value otherwise
	ejc
;
;      ident
;
s_idn	ent				; entry point
	mov	xr,(xs)+		; load second argument
	mov	xl,(xs)+		; load first argument
	jsr	ident			; call ident comparison routine
	ppm	exnul			; return null if ident
	brn	exfal			; fail if differ
	ejc
;
;      input
;
s_inp	ent				; entry point
	zer	wb			; input flag
	jsr	ioput			; call input/output assoc. routine
	err	113,input third argument is not a string
	err	114,inappropriate second argument for input
	err	115,inappropriate first argument for input
	err	116,inappropriate file specification for input
	ppm	exfal			; fail if file does not exist
	err	117,input file cannot be read
	err	289,input channel currently in use
	brn	exnul			; return null string
	ejc
.if    .cnbf
.else
;
;      insert
;
s_ins	ent				; entry point
	mov	xl,(xs)+		; get string arg
	jsr	gtsmi			; get replace length
	err	277,insert third argument not integer
	ppm	exfal			; fail if out of range
	mov	wb,wc			; copy to proper reg
	jsr	gtsmi			; get replace position
	err	278,insert second argument not integer
	ppm	exfal			; fail if out of range
	bze	wc,exfal		; fail if zero
	dcv	wc			; decrement to get offset
	mov	wa,wc			; put in proper register
	mov	xr,(xs)+		; get buffer
	beq	(xr),=b_bct,sins1	; press on if type ok
	erb	279,insert first argument is not a buffer
;
;      here when everything loaded up
;
sins1	jsr	insbf			; call to insert
	err	280,insert fourth argument is not a string
	ppm	exfal			; fail if out of range
	brn	exnul			; else ok - exit with null
	ejc
.fi
;
;      integer
;
s_int	ent				; entry point
	mov	xr,(xs)+		; load argument
	jsr	gtnum			; convert to numeric
	ppm	exfal			; fail if non-numeric
	beq	wa,=b_icl,exnul		; return null if integer
	brn	exfal			; fail if real
	ejc
;
;      item
;
;      item does not permit the direct (fast) call so that
;      wa contains the actual number of arguments passed.
;
s_itm	ent				; entry point
;
;      deal with case of no args
;
	bnz	wa,sitm1		; jump if at least one arg
	mov	-(xs),=nulls		; else supply garbage null arg
	mov	wa,=num01		; and fix argument count
;
;      check for name/value cases
;
sitm1	scp	xr			; get current code pointer
	mov	xl,(xr)			; load next code word
	dcv	wa			; get number of subscripts
	mov	xr,wa			; copy for arref
	beq	xl,=ofne_,sitm2		; jump if called by name
;
;      here if called by value
;
	zer	wb			; set code for call by value
	brn	arref			; off to array reference routine
;
;      here for call by name
;
sitm2	mnz	wb			; set code for call by name
	lcw	wa			; load and ignore ofne_ call
	brn	arref			; off to array reference routine
	ejc
;
;      le
;
s_lef	ent				; entry point
	jsr	acomp			; call arithmetic comparison routine
	err	118,le first argument is not numeric
	err	119,le second argument is not numeric
	ppm	exnul			; return null if lt
	ppm	exnul			; return null if eq
	ppm	exfal			; fail if gt
	ejc
;
;      len
;
s_len	ent				; entry point
	mov	wb,=p_len		; set pcode for integer arg case
	mov	wa,=p_lnd		; set pcode for expr arg case
	jsr	patin			; call common routine to build node
	err	120,len argument is not integer or expression
	err	121,len argument is negative or too large
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
;
;      leq
;
s_leq	ent				; entry point
	jsr	lcomp			; call string comparison routine
	err	122,leq first argument is not a string
	err	123,leq second argument is not a string
	ppm	exfal			; fail if llt
	ppm	exnul			; return null if leq
	ppm	exfal			; fail if lgt
	ejc
;
;      lge
;
s_lge	ent				; entry point
	jsr	lcomp			; call string comparison routine
	err	124,lge first argument is not a string
	err	125,lge second argument is not a string
	ppm	exfal			; fail if llt
	ppm	exnul			; return null if leq
	ppm	exnul			; return null if lgt
	ejc
;
;      lgt
;
s_lgt	ent				; entry point
	jsr	lcomp			; call string comparison routine
	err	126,lgt first argument is not a string
	err	127,lgt second argument is not a string
	ppm	exfal			; fail if llt
	ppm	exfal			; fail if leq
	ppm	exnul			; return null if lgt
	ejc
;
;      lle
;
s_lle	ent				; entry point
	jsr	lcomp			; call string comparison routine
	err	128,lle first argument is not a string
	err	129,lle second argument is not a string
	ppm	exnul			; return null if llt
	ppm	exnul			; return null if leq
	ppm	exfal			; fail if lgt
	ejc
;
;      llt
;
s_llt	ent				; entry point
	jsr	lcomp			; call string comparison routine
	err	130,llt first argument is not a string
	err	131,llt second argument is not a string
	ppm	exnul			; return null if llt
	ppm	exfal			; fail if leq
	ppm	exfal			; fail if lgt
	ejc
;
;      lne
;
s_lne	ent				; entry point
	jsr	lcomp			; call string comparison routine
	err	132,lne first argument is not a string
	err	133,lne second argument is not a string
	ppm	exnul			; return null if llt
	ppm	exfal			; fail if leq
	ppm	exnul			; return null if lgt
	ejc
.if    .cmth
;
;      ln
;
s_lnf	ent				; entry point
	mov	xr,(xs)+		; get argument
	jsr	gtrea			; convert to real
	err	306,ln argument not numeric
	ldr	rcval(xr)		; load accumulator with argument
	req	slnf1			; overflow if argument is 0
	rlt	slnf2			; error if argument less than 0
	lnf				; take natural logarithm
	rno	exrea			; if no overflow, return result in ra
slnf1	erb	307,ln produced real overflow
;
;      here for bad argument
;
slnf2	erb	315,ln argument negative
	ejc
.fi
;
;      local
;
s_loc	ent				; entry point
	jsr	gtsmi			; get second argument (local number)
	err	134,local second argument is not integer
	ppm	exfal			; fail if out of range
	mov	wb,xr			; save local number
	mov	xr,(xs)+		; load first argument
	jsr	gtnvr			; point to vrblk
	ppm	sloc1			; jump if not variable name
	mov	xr,vrfnc(xr)		; else load function pointer
	bne	(xr),=b_pfc,sloc1	; jump if not program defined
;
;      here if we have a program defined function name
;
	bze	wb,exfal		; fail if second arg is zero
	bgt	wb,pfnlo(xr),exfal	; or too large
	add	wb,fargs(xr)		; else adjust offset to include args
	wtb	wb			; convert to bytes
	add	xr,wb			; point to local pointer
	mov	xr,pfagb(xr)		; load vrblk pointer
	brn	exvnm			; exit building nmblk
;
;      here if first argument is no good
;
sloc1	erb	135,local first arg is not a program function name
.if    .cnld
.else
	ejc
;
;      load
;
s_lod	ent				; entry point
	jsr	gtstg			; load library name
	err	136,load second argument is not a string
	mov	xl,xr			; save library name
	jsr	xscni			; prepare to scan first argument
	err	137,load first argument is not a string
	err	138,load first argument is null
	mov	-(xs),xl		; stack library name
	mov	wc,=ch_pp		; set delimiter one = left paren
	mov	xl,wc			; set delimiter two = left paren
	mnz	wa			; skip/trim blanks in prototype
	jsr	xscan			; scan function name
	mov	-(xs),xr		; save ptr to function name
	bnz	wa,slod1		; jump if left paren found
	erb	139,load first argument is missing a left paren
;
;      here after successfully scanning function name
;
slod1	jsr	gtnvr			; locate vrblk
	err	140,load first argument has null function name
	mov	lodfn,xr		; save vrblk pointer
	zer	lodna			; zero count of arguments
;
;      loop to scan argument datatype names
;
slod2	mov	wc,=ch_rp		; delimiter one is right paren
	mov	xl,=ch_cm		; delimiter two is comma
	mnz	wa			; skip/trim blanks in prototype
	jsr	xscan			; scan next argument name
	icv	lodna			; bump argument count
	bnz	wa,slod3		; jump if ok delimiter was found
	erb	141,load first argument is missing a right paren
	ejc
;
;      load (continued)
;
;      come here to analyze the datatype pointer in (xr). this
;      code is used both for arguments (wa=1,2) and for the
;      result datatype (with wa set to zero).
;
.if    .culc
slod3	mov	wb,wa			; save scan mode
	mov	wa,sclen(xr)		; datatype length
	bze	wa,sld3a		; bypass if null string
	jsr	flstg			; fold to upper case
sld3a	mov	wa,wb			; restore scan mode
	mov	-(xs),xr		; stack datatype name pointer
.else
slod3	mov	-(xs),xr		; stack datatype name pointer
.fi
	mov	wb,=num01		; set string code in case
	mov	xl,=scstr		; point to /string/
	jsr	ident			; check for match
	ppm	slod4			; jump if match
	mov	xr,(xs)			; else reload name
	add	wb,wb			; set code for integer (2)
	mov	xl,=scint		; point to /integer/
	jsr	ident			; check for match
	ppm	slod4			; jump if match
.if    .cnra
.else
	mov	xr,(xs)			; else reload string pointer
	icv	wb			; set code for real (3)
	mov	xl,=screa		; point to /real/
	jsr	ident			; check for match
	ppm	slod4			; jump if match
.fi
.if    .cnlf
	mov	xr,(xs)			; reload string pointer
	icv	wb			; code for file (4, or 3 if no reals)
	mov	xl,=scfil		; point to /file/
	jsr	ident			; check for match
	ppm	slod4			; jump if match
.fi
	zer	wb			; else get code for no convert
;
;      merge here with proper datatype code in wb
;
slod4	mov	(xs),wb			; store code on stack
	beq	wa,=num02,slod2		; loop back if arg stopped by comma
	bze	wa,slod5		; jump if that was the result type
;
;      here we scan out the result type (arg stopped by ) )
;
	mov	wc,mxlen		; set dummy (impossible) delimiter 1
	mov	xl,wc			; and delimiter two
	mnz	wa			; skip/trim blanks in prototype
	jsr	xscan			; scan result name
	zer	wa			; set code for processing result
	brn	slod3			; jump back to process result name
	ejc
;
;      load (continued)
;
;      here after processing all args and result
;
slod5	mov	wa,lodna		; get number of arguments
	mov	wc,wa			; copy for later
	wtb	wa			; convert length to bytes
	add	wa,*efsi_		; add space for standard fields
	jsr	alloc			; allocate efblk
	mov	(xr),=b_efc		; set type word
	mov	fargs(xr),wc		; set number of arguments
	zer	efuse(xr)		; set use count (dffnc will set to 1)
	zer	efcod(xr)		; zero code pointer for now
	mov	efrsl(xr),(xs)+		; store result type code
	mov	efvar(xr),lodfn		; store function vrblk pointer
	mov	eflen(xr),wa		; store efblk length
	mov	wb,xr			; save efblk pointer
	add	xr,wa			; point past end of efblk
	lct	wc,wc			; set number of arguments for loop
;
;      loop to set argument type codes from stack
;
slod6	mov	-(xr),(xs)+		; store one type code from stack
	bct	wc,slod6		; loop till all stored
;
;      now load the external function and perform definition
;
	mov	xr,(xs)+		; load function string name
.if    .culc
	mov	wa,sclen(xr)		; function name length
	jsr	flstg			; fold to upper case
.fi
	mov	xl,(xs)			; load library name
	mov	(xs),wb			; store efblk pointer
	jsr	sysld			; call function to load external func
	err	142,load function does not exist
	err	143,load function caused input error during load
	err	328,load function - insufficient memory
	mov	xl,(xs)+		; recall efblk pointer
	mov	efcod(xl),xr		; store code pointer
	mov	xr,lodfn		; point to vrblk for function
	jsr	dffnc			; perform function definition
	brn	exnul			; return null result
.fi
	ejc
;
;      lpad
;
s_lpd	ent				; entry point
	jsr	gtstg			; get pad character
	err	144,lpad third argument is not a string
	plc	xr			; point to character (null is blank)
	lch	wb,(xr)			; load pad character
	jsr	gtsmi			; get pad length
	err	145,lpad second argument is not integer
	ppm	slpd4			; skip if negative or large
;
;      merge to check first arg
;
slpd1	jsr	gtstg			; get first argument (string to pad)
	err	146,lpad first argument is not a string
	bge	wa,wc,exixr		; return 1st arg if too long to pad
	mov	xl,xr			; else move ptr to string to pad
;
;      now we are ready for the pad
;
;      (xl)		     pointer to string to pad
;      (wb)		     pad character
;      (wc)		     length to pad string to
;
	mov	wa,wc			; copy length
	jsr	alocs			; allocate scblk for new string
	mov	-(xs),xr		; save as result
	mov	wa,sclen(xl)		; load length of argument
	sub	wc,wa			; calculate number of pad characters
	psc	xr			; point to chars in result string
	lct	wc,wc			; set counter for pad loop
;
;      loop to perform pad
;
slpd2	sch	wb,(xr)+		; store pad character, bump ptr
	bct	wc,slpd2		; loop till all pad chars stored
	csc	xr			; complete store characters
;
;      now copy string
;
	bze	wa,slpd3		; exit if null string
	plc	xl			; else point to chars in argument
	mvc				; move characters to result string
	zer	xl			; clear garbage xl
;
;      here to exit with result on stack
;
slpd3	lcw	xr			; load next code word
	bri	(xr)			; execute it
;
;      here if 2nd arg is negative or large
;
slpd4	zer	wc			; zero pad count
	brn	slpd1			; merge
	ejc
;
;      lt
;
s_ltf	ent				; entry point
	jsr	acomp			; call arithmetic comparison routine
	err	147,lt first argument is not numeric
	err	148,lt second argument is not numeric
	ppm	exnul			; return null if lt
	ppm	exfal			; fail if eq
	ppm	exfal			; fail if gt
	ejc
;
;      ne
;
s_nef	ent				; entry point
	jsr	acomp			; call arithmetic comparison routine
	err	149,ne first argument is not numeric
	err	150,ne second argument is not numeric
	ppm	exnul			; return null if lt
	ppm	exfal			; fail if eq
	ppm	exnul			; return null if gt
	ejc
;
;      notany
;
s_nay	ent				; entry point
	mov	wb,=p_nas		; set pcode for single char arg
	mov	xl,=p_nay		; pcode for multi-char arg
	mov	wc,=p_nad		; set pcode for expr arg
	jsr	patst			; call common routine to build node
	err	151,notany argument is not a string or expression
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
;
;      opsyn
;
s_ops	ent				; entry point
	jsr	gtsmi			; load third argument
	err	152,opsyn third argument is not integer
	err	153,opsyn third argument is negative or too large
	mov	wb,wc			; if ok, save third argumnet
	mov	xr,(xs)+		; load second argument
	jsr	gtnvr			; locate variable block
	err	154,opsyn second arg is not natural variable name
	mov	xl,vrfnc(xr)		; if ok, load function block pointer
	bnz	wb,sops2		; jump if operator opsyn case
;
;      here for function opsyn (third arg zero)
;
	mov	xr,(xs)+		; load first argument
	jsr	gtnvr			; get vrblk pointer
	err	155,opsyn first arg is not natural variable name
;
;      merge here to perform function definition
;
sops1	jsr	dffnc			; call function definer
	brn	exnul			; exit with null result
;
;      here for operator opsyn (third arg non-zero)
;
sops2	jsr	gtstg			; get operator name
	ppm	sops5			; jump if not string
	bne	wa,=num01,sops5		; error if not one char long
	plc	xr			; else point to character
	lch	wc,(xr)			; load character name
	ejc
;
;      opsyn (continued)
;
;      now set to search for matching unary or binary operator
;      name as appropriate. note that there are =opbun undefined
;      binary operators and =opuun undefined unary operators.
;
	mov	wa,=r_uub		; point to unop pointers in case
	mov	xr,=opnsu		; point to names of unary operators
	add	wb,=opbun		; add no. of undefined binary ops
	beq	wb,=opuun,sops3		; jump if unop (third arg was 1)
	mov	wa,=r_uba		; else point to binary operator ptrs
	mov	xr,=opsnb		; point to names of binary operators
	mov	wb,=opbun		; set number of undefined binops
;
;      merge here to check list (wb = number to check)
;
sops3	lct	wb,wb			; set counter to control loop
;
;      loop to search for name match
;
sops4	beq	wc,(xr),sops6		; jump if names match
	ica	wa			; else push pointer to function ptr
	ica	xr			; bump pointer
	bct	wb,sops4		; loop back till all checked
;
;      here if bad operator name
;
sops5	erb	156,opsyn first arg is not correct operator name
;
;      come here on finding a match in the operator name table
;
sops6	mov	xr,wa			; copy pointer to function block ptr
	sub	xr,*vrfnc		; make it look like dummy vrblk
	brn	sops1			; merge back to define operator
	ejc
.if    .c370
;
;      or
;
s_orf	ent				; entry point
	mnz	wb			; signal two arguments
	jsr	sbool			; call string boolean routine
	err	xxx,or first argument is not a string
	err	xxx,or second argument is not a string
	err	xxx,or arguments not same length
	ppm	exits			; null string arguments
;
;      here to process (wc) words.  result is stacked.
;
sorf1	mov	wa,(xl)+		; get next cfp_c chars from arg 1
	orb	wa,(xr)			; or with characters from arg 2
	mov	(xr)+,wa		; put back in memory
	bct	wc,sorf1		; loop over all words in string block
	brn	exits			; fetch next code word
	ejc
.fi
;
;      output
;
s_oup	ent				; entry point
	mov	wb,=num03		; output flag
	jsr	ioput			; call input/output assoc. routine
	err	157,output third argument is not a string
	err	158,inappropriate second argument for output
	err	159,inappropriate first argument for output
	err	160,inappropriate file specification for output
	ppm	exfal			; fail if file does not exist
	err	161,output file cannot be written to
	err	290,output channel currently in use
	brn	exnul			; return null string
	ejc
;
;      pos
;
s_pos	ent				; entry point
	mov	wb,=p_pos		; set pcode for integer arg case
	mov	wa,=p_psd		; set pcode for expression arg case
	jsr	patin			; call common routine to build node
	err	162,pos argument is not integer or expression
	err	163,pos argument is negative or too large
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
;
;      prototype
;
s_pro	ent				; entry point
	mov	xr,(xs)+		; load argument
	mov	wb,tblen(xr)		; length if table, vector (=vclen)
	btw	wb			; convert to words
	mov	wa,(xr)			; load type word of argument block
	beq	wa,=b_art,spro4		; jump if array
	beq	wa,=b_tbt,spro1		; jump if table
	beq	wa,=b_vct,spro3		; jump if vector
.if    .cnbf
.else
	beq	wa,=b_bct,spr05		; jump if buffer
.fi
	erb	164,prototype argument is not valid object
;
;      here for table
;
spro1	sub	wb,=tbsi_		; subtract standard fields
;
;      merge for vector
;
spro2	mti	wb			; convert to integer
	brn	exint			; exit with integer result
;
;      here for vector
;
spro3	sub	wb,=vcsi_		; subtract standard fields
	brn	spro2			; merge
;
;      here for array
;
spro4	add	xr,arofs(xr)		; point to prototype field
	mov	xr,(xr)			; load prototype
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
.if    .cnbf
.else
;
;      here for buffer
;
spr05	mov	xr,bcbuf(xr)		; point to bfblk
	mti	bfalc(xr)		; load allocated length
	brn	exint			; exit with integer allocation
.fi
	ejc
;
;      remdr
;
s_rmd	ent				; entry point
.if    .cmth
	jsr	arith			; get two integers or two reals
	err	166,remdr first argument is not numeric
	err	165,remdr second argument is not numeric
	ppm	srm06			; if real
.else
	mov	xr,(xs)			; load second argument
	jsr	gtint			; convert to integer
	err	165,remdr second argument is not integer
	mov	(xs),xr			; place converted arg in stack
	jsr	arith			; convert args
	ppm	srm04			; first arg not integer
	ppm				; second arg checked above
.if    .cnra
.else
	ppm	srm01			; first arg real
.fi
.fi
;
;      both arguments integer
;
	zer	wb			; set positive flag
	ldi	icval(xr)		; load left argument value
	ige	srm01			; jump if positive
	mnz	wb			; set negative flag
srm01	rmi	icval(xl)		; get remainder
	iov	srm05			; error if overflow
;
;      make sign of result match sign of first argument
;
	bze	wb,srm03		; if result should be positive
	ile	exint			; if should be negative, and is
srm02	ngi				; adjust sign of result
	brn	exint			; return result
srm03	ilt	srm02			; should be pos, and result negative
	brn	exint			; should be positive, and is
;
;      fail first argument
;
srm04	erb	166,remdr first argument is not numeric
;
;      fail if overflow
;
srm05	erb	167,remdr caused integer overflow
.if    .cmth
;
;      here with 1st argument in (xr), 2nd in (xl), both real
;
;      result = n1 - chop(n1/n2)*n2
;
srm06	zer	wb			; set positive flag
	ldr	rcval(xr)		; load left argument value
	rge	srm07			; jump if positive
	mnz	wb			; set negative flag
srm07	dvr	rcval(xl)		; compute n1/n2
	rov	srm10			; jump if overflow
	chp				; chop result
	mlr	rcval(xl)		; times n2
	sbr	rcval(xr)		; compute difference
;
;      make sign of result match sign of first argument
;      -result is in ra at this point
;
	bze	wb,srm09		; if result should be positive
	rle	exrea			; if should be negative, and is
srm08	ngr				; adjust sign of result
	brn	exrea			; return result
srm09	rlt	srm08			; should be pos, and result negative
	brn	exrea			; should be positive, and is
;
;      fail if overflow
;
srm10	erb	312,remdr caused real overflow
.fi
	ejc
;
;      replace
;
;      the actual replace operation uses an scblk whose cfp_a
;      chars contain the translated versions of all the chars.
;      the table pointer is remembered from call to call and
;      the table is only built when the arguments change.
;
;      we also perform an optimization gleaned from spitbol 370.
;      if the second argument is &alphabet, there is no need to
;      to build a replace table.  the third argument can be
;      used directly as the replace table.
;
s_rpl	ent				; entry point
	jsr	gtstg			; load third argument as string
	err	168,replace third argument is not a string
	mov	xl,xr			; save third arg ptr
	jsr	gtstg			; get second argument
	err	169,replace second argument is not a string
;
;      check to see if this is the same table as last time
;
	bne	xr,r_ra2,srpl1		; jump if 2nd argument different
	beq	xl,r_ra3,srpl4		; jump if args same as last time
;
;      here we build a new replace table (note wa = 2nd arg len)
;
srpl1	mov	wb,sclen(xl)		; load 3rd argument length
	bne	wa,wb,srpl6		; jump if arguments not same length
	beq	xr,kvalp,srpl5		; jump if 2nd arg is alphabet string
	bze	wb,srpl6		; jump if null 2nd argument
	mov	r_ra3,xl		; save third arg for next time in
	mov	r_ra2,xr		; save second arg for next time in
	mov	xl,kvalp		; point to alphabet string
	mov	wa,sclen(xl)		; load alphabet scblk length
	mov	xr,r_rpt		; point to current table (if any)
	bnz	xr,srpl2		; jump if we already have a table
;
;      here we allocate a new table
;
	jsr	alocs			; allocate new table
	mov	wa,wc			; keep scblk length
	mov	r_rpt,xr		; save table pointer for next time
;
;      merge here with pointer to new table block in (xr)
;
srpl2	ctb	wa,scsi_		; compute length of scblk
	mvw				; copy to get initial table values
	ejc
;
;      replace (continued)
;
;      now we must plug selected entries as required. note that
;      we are short of index registers for the following loop.
;      hence the need to repeatedly re-initialise char ptr xl
;
	mov	xl,r_ra2		; point to second argument
	lct	wb,wb			; number of chars to plug
	zer	wc			; zero char offset
	mov	xr,r_ra3		; point to 3rd arg
	plc	xr			; get char ptr for 3rd arg
;
;      loop to plug chars
;
srpl3	mov	xl,r_ra2		; point to 2nd arg
	plc	xl,wc			; point to next char
	icv	wc			; increment offset
	lch	wa,(xl)			; get next char
	mov	xl,r_rpt		; point to translate table
	psc	xl,wa			; convert char to offset into table
	lch	wa,(xr)+		; get translated char
	sch	wa,(xl)			; store in table
	csc	xl			; complete store characters
	bct	wb,srpl3		; loop till done
	ejc
;
;      replace (continued)
;
;      here to use r_rpt as replace table.
;
srpl4	mov	xl,r_rpt		; replace table to use
;
;      here to perform translate using table in xl.
;
.if    .cnbf
srpl5	jsr	gtstg			; get first argument
	err	170,replace first argument is not a string
.else
;
;      if first arg is a buffer, perform translate in place.
;
srpl5	jsr	gtstb			; get first argument
	err	170,replace first argument is not a string or buffer
	bnz	wb,srpl7		; branch if buffer
.fi
	bze	wa,exnul		; return null if null argument
	mov	-(xs),xl		; stack replace table to use
	mov	xl,xr			; copy pointer
	mov	wc,wa			; save length
	ctb	wa,schar		; get scblk length
	jsr	alloc			; allocate space for copy
	mov	wb,xr			; save address of copy
	mvw				; move scblk contents to copy
	mov	xr,(xs)+		; unstack replace table
	plc	xr			; point to chars of table
	mov	xl,wb			; point to string to translate
	plc	xl			; point to chars of string
	mov	wa,wc			; set number of chars to translate
	trc				; perform translation
srpl8	mov	-(xs),wb		; stack result
	lcw	xr			; load next code word
	bri	(xr)			; execute it
;
;      error point
;
srpl6	erb	171,null or unequally long 2nd, 3rd args to replace
.if    .cnbf
.else
;
;      here to perform replacement within buffer
;
srpl7	bze	wa,srpl8		; return buffer unchanged if empty
	mov	wc,xr			; copy bfblk pointer to wc
	mov	xr,xl			; translate table to xr
	plc	xr			; point to chars of table
	mov	xl,wc			; point to string to translate
	plc	xl			; point to chars of string
	trc				; perform translation
	brn	srpl8			; stack result and exit
.fi
	ejc
;
;      rewind
;
s_rew	ent				; entry point
	jsr	iofcb			; call fcblk routine
	err	172,rewind argument is not a suitable name
	err	173,rewind argument is null
	err	174,rewind file does not exist
	jsr	sysrw			; call system rewind function
	err	174,rewind file does not exist
	err	175,rewind file does not permit rewind
	err	176,rewind caused non-recoverable error
	brn	exnul			; exit with null result if no error
	ejc
;
;      reverse
;
s_rvs	ent				; entry point
.if    .cnbf
	jsr	gtstg			; load string argument
	err	177,reverse argument is not a string
.else
	jsr	gtstb			; load string or buffer argument
	err	177,reverse argument is not a string or buffer
	bnz	wb,srvs3		; branch if buffer
.fi
	bze	wa,exixr		; return argument if null
	mov	xl,xr			; else save pointer to string arg
	jsr	alocs			; allocate space for new scblk
	mov	-(xs),xr		; store scblk ptr on stack as result
	psc	xr			; prepare to store in new scblk
	plc	xl,wc			; point past last char in argument
	lct	wc,wc			; set loop counter
;
;      loop to move chars in reverse order
;
srvs1	lch	wb,-(xl)		; load next char from argument
	sch	wb,(xr)+		; store in result
	bct	wc,srvs1		; loop till all moved
;
;      here when complete to execute next code word
;
srvs4	csc	xr			; complete store characters
	zer	xl			; clear garbage xl
srvs2	lcw	xr			; load next code word
	bri	(xr)			; execute it
.if    .cnbf
.else
;
;      here if argument is a buffer.  perform reverse in place.
;
srvs3	mov	-(xs),wb		; stack buffer as result
	bze	wa,srvs2		; return buffer unchanged if empty
	mov	xl,xr			; copy bfblk pointer to xl
	psc	xr			; prepare to store at first char
	plc	xl,wa			; point past last char in argument
	rsh	wa,1			; operate on half the string
	lct	wc,wa			; set loop counter
;
;      loop to swap chars from end to end.  note that in the
;      case of an odd count, the middle char is not touched.
;
srvs5	lch	wb,-(xl)		; load next char from end
	lch	wa,(xr)			; load next char from front
	sch	wb,(xr)+		; store end char in front
	sch	wa,(xl)			; store front char at end
	bct	wc,srvs5		; loop till all moved
	brn	srvs4			; complete store
.fi
	ejc
;
;      rpad
;
s_rpd	ent				; entry point
	jsr	gtstg			; get pad character
	err	178,rpad third argument is not a string
	plc	xr			; point to character (null is blank)
	lch	wb,(xr)			; load pad character
	jsr	gtsmi			; get pad length
	err	179,rpad second argument is not integer
	ppm	srpd3			; skip if negative or large
;
;      merge to check first arg.
;
srpd1	jsr	gtstg			; get first argument (string to pad)
	err	180,rpad first argument is not a string
	bge	wa,wc,exixr		; return 1st arg if too long to pad
	mov	xl,xr			; else move ptr to string to pad
;
;      now we are ready for the pad
;
;      (xl)		     pointer to string to pad
;      (wb)		     pad character
;      (wc)		     length to pad string to
;
	mov	wa,wc			; copy length
	jsr	alocs			; allocate scblk for new string
	mov	-(xs),xr		; save as result
	mov	wa,sclen(xl)		; load length of argument
	sub	wc,wa			; calculate number of pad characters
	psc	xr			; point to chars in result string
	lct	wc,wc			; set counter for pad loop
;
;      copy argument string
;
	bze	wa,srpd2		; jump if argument is null
	plc	xl			; else point to argument chars
	mvc				; move characters to result string
	zer	xl			; clear garbage xl
;
;      loop to supply pad characters
;
srpd2	sch	wb,(xr)+		; store pad character, bump ptr
	bct	wc,srpd2		; loop till all pad chars stored
	csc	xr			; complete character storing
	lcw	xr			; load next code word
	bri	(xr)			; execute it
;
;      here if 2nd arg is negative or large
;
srpd3	zer	wc			; zero pad count
	brn	srpd1			; merge
	ejc
;
;      rtab
;
s_rtb	ent				; entry point
	mov	wb,=p_rtb		; set pcode for integer arg case
	mov	wa,=p_rtd		; set pcode for expression arg case
	jsr	patin			; call common routine to build node
	err	181,rtab argument is not integer or expression
	err	182,rtab argument is negative or too large
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
.if    .cust
;
;      set
;
s_set	ent				; entry point
	mov	r_io2,(xs)+		; save third arg (whence)
.if    .cusr
	mov	xr,(xs)+		; get second arg (offset)
	jsr	gtrea			; convert to real
	err	324,set second argument not numeric
	ldr	rcval(xr)		; load accumulator with argument
.else
	mov	r_io1,(xs)+		; save second arg (offset)
.fi
	jsr	iofcb			; call fcblk routine
	err	291,set first argument is not a suitable name
	err	292,set first argument is null
	err	295,set file does not exist
.if    .cusr
.else
	mov	wb,r_io1		; load second arg
.fi
	mov	wc,r_io2		; load third arg
	jsr	sysst			; call system set routine
	err	293,inappropriate second argument to set
	err	294,inappropriate third argument to set
	err	295,set file does not exist
	err	296,set file does not permit setting file pointer
	err	297,set caused non-recoverable i/o error
.if    .cusr
	rti	exrea			; return real position if not able
	brn	exint			; to return integer position
.else
	brn	exint			; otherwise return position
.fi
	ejc
.fi
;
;      tab
;
s_tab	ent				; entry point
	mov	wb,=p_tab		; set pcode for integer arg case
	mov	wa,=p_tbd		; set pcode for expression arg case
	jsr	patin			; call common routine to build node
	err	183,tab argument is not integer or expression
	err	184,tab argument is negative or too large
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
;
;      rpos
;
s_rps	ent				; entry point
	mov	wb,=p_rps		; set pcode for integer arg case
	mov	wa,=p_rpd		; set pcode for expression arg case
	jsr	patin			; call common routine to build node
	err	185,rpos argument is not integer or expression
	err	186,rpos argument is negative or too large
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
.if    .cnsr
.else
	ejc
;
;      rsort
;
s_rsr	ent				; entry point
	mnz	wa			; mark as rsort
	jsr	sorta			; call sort routine
	ppm	exfal			; if conversion fails, so shall we
	brn	exsid			; return, setting idval
.fi
	ejc
;
;      setexit
;
s_stx	ent				; entry point
	mov	xr,(xs)+		; load argument
	mov	wa,stxvr		; load old vrblk pointer
	zer	xl			; load zero in case null arg
	beq	xr,=nulls,sstx1		; jump if null argument (reset call)
	jsr	gtnvr			; else get specified vrblk
	ppm	sstx2			; jump if not natural variable
	mov	xl,vrlbl(xr)		; else load label
	beq	xl,=stndl,sstx2		; jump if label is not defined
	bne	(xl),=b_trt,sstx1	; jump if not trapped
	mov	xl,trlbl(xl)		; else load ptr to real label code
;
;      here to set/reset setexit trap
;
sstx1	mov	stxvr,xr		; store new vrblk pointer (or null)
	mov	r_sxc,xl		; store new code ptr (or zero)
	beq	wa,=nulls,exnul		; return null if null result
	mov	xr,wa			; else copy vrblk pointer
	brn	exvnm			; and return building nmblk
;
;      here if bad argument
;
sstx2	erb	187,setexit argument is not label name or null
.if    .cmth
;
;      sin
;
s_sin	ent				; entry point
	mov	xr,(xs)+		; get argument
	jsr	gtrea			; convert to real
	err	308,sin argument not numeric
	ldr	rcval(xr)		; load accumulator with argument
	sin				; take sine
	rno	exrea			; if no overflow, return result in ra
	erb	323,sin argument is out of range
	ejc
.fi
.if    .cmth
;
;      sqrt
;
s_sqr	ent				; entry point
	mov	xr,(xs)+		; get argument
	jsr	gtrea			; convert to real
	err	313,sqrt argument not numeric
	ldr	rcval(xr)		; load accumulator with argument
	rlt	ssqr1			; negative number
	sqr				; take square root
	brn	exrea			; no overflow possible, result in ra
;
;      here if bad argument
;
ssqr1	erb	314,sqrt argument negative
	ejc
.fi
.if    .cnsr
.else
	ejc
;
;      sort
;
s_srt	ent				; entry point
	zer	wa			; mark as sort
	jsr	sorta			; call sort routine
	ppm	exfal			; if conversion fails, so shall we
	brn	exsid			; return, setting idval
.fi
	ejc
;
;      span
;
s_spn	ent				; entry point
	mov	wb,=p_sps		; set pcode for single char arg
	mov	xl,=p_spn		; set pcode for multi-char arg
	mov	wc,=p_spd		; set pcode for expression arg
	jsr	patst			; call common routine to build node
	err	188,span argument is not a string or expression
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
;
;      size
;
s_si_	ent				; entry point
.if    .cnbf
	jsr	gtstg			; load string argument
	err	189,size argument is not a string
.else
	jsr	gtstb			; load string argument
	err	189,size argument is not a string or buffer
.fi
;
;      merge with bfblk or scblk ptr in xr.  wa has length.
;
	mti	wa			; load length as integer
	brn	exint			; exit with integer result
	ejc
;
;      stoptr
;
s_stt	ent				; entry point
	zer	xl			; indicate stoptr case
	jsr	trace			; call trace procedure
	err	190,stoptr first argument is not appropriate name
	err	191,stoptr second argument is not trace type
	brn	exnul			; return null
	ejc
;
;      substr
;
s_sub	ent				; entry point
	jsr	gtsmi			; load third argument
	err	192,substr third argument is not integer
	ppm	exfal			; jump if negative or too large
	mov	sbssv,xr		; save third argument
	jsr	gtsmi			; load second argument
	err	193,substr second argument is not integer
	ppm	exfal			; jump if out of range
	mov	wc,xr			; save second argument
	bze	wc,exfal		; jump if second argument zero
	dcv	wc			; else decrement for ones origin
.if    .cnbf
	jsr	gtstg			; load first argument
	err	194,substr first argument is not a string
.else
	jsr	gtstb			; load first argument
	err	194,substr first argument is not a string or buffer
.fi
;
;      merge with bfblk or scblk ptr in xr.  wa has length
;
	mov	wb,wc			; copy second arg to wb
	mov	wc,sbssv		; reload third argument
	bnz	wc,ssub2		; skip if third arg given
	mov	wc,wa			; else get string length
	bgt	wb,wc,exfal		; fail if improper
	sub	wc,wb			; reduce by offset to start
;
;      merge
;
ssub2	mov	xl,wa			; save string length
	mov	wa,wc			; set length of substring
	add	wc,wb			; add 2nd arg to 3rd arg
	bgt	wc,xl,exfal		; jump if improper substring
	mov	xl,xr			; copy pointer to first arg
	jsr	sbstr			; build substring
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
;
;      table
;
s_tbl	ent				; entry point
	mov	xl,(xs)+		; get initial lookup value
	ica	xs			; pop second argument
	jsr	gtsmi			; load argument
	err	195,table argument is not integer
	err	196,table argument is out of range
	bnz	wc,stbl1		; jump if non-zero
	mov	wc,=tbnbk		; else supply default value
;
;      merge here with number of headers in wc
;
stbl1	jsr	tmake			; make table
	brn	exsid			; exit setting idval
	ejc
.if    .cmth
;
;      tan
;
s_tan	ent				; entry point
	mov	xr,(xs)+		; get argument
	jsr	gtrea			; convert to real
	err	309,tan argument not numeric
	ldr	rcval(xr)		; load accumulator with argument
	tan				; take tangent
	rno	exrea			; if no overflow, return result in ra
	erb	310,tan produced real overflow or argument is out of range
	ejc
.fi
;
;      time
;
s_tim	ent				; entry point
	jsr	systm			; get timer value
	sbi	timsx			; subtract starting time
	brn	exint			; exit with integer value
	ejc
;
;      trace
;
s_tra	ent				; entry point
	beq	num03(xs),=nulls,str02	; jump if first argument is null
	mov	xr,(xs)+		; load fourth argument
	zer	xl			; tentatively set zero pointer
	beq	xr,=nulls,str01		; jump if 4th argument is null
	jsr	gtnvr			; else point to vrblk
	ppm	str03			; jump if not variable name
	mov	xl,xr			; else save vrblk in trfnc
;
;      here with vrblk or zero in xl
;
str01	mov	xr,(xs)+		; load third argument (tag)
	zer	wb			; set zero as trtyp value for now
	jsr	trbld			; build trblk for trace call
	mov	xl,xr			; move trblk pointer for trace
	jsr	trace			; call trace procedure
	err	198,trace first argument is not appropriate name
	err	199,trace second argument is not trace type
	brn	exnul			; return null
;
;      here to call system trace toggle routine
;
str02	jsr	systt			; call it
	add	xs,*num04		; pop trace arguments
	brn	exnul			; return
;
;      here for bad fourth argument
;
str03	erb	197,trace fourth arg is not function name or null
	ejc
;
;      trim
;
s_trm	ent				; entry point
.if    .cnbf
	jsr	gtstg			; load argument as string
	err	200,trim argument is not a string
.else
	jsr	gtstb			; load argument as string
	err	200,trim argument is not a string or buffer
	bnz	wb,strm0		; branch if buffer
.fi
	bze	wa,exnul		; return null if argument is null
	mov	xl,xr			; copy string pointer
	ctb	wa,schar		; get block length
	jsr	alloc			; allocate copy same size
	mov	wb,xr			; save pointer to copy
	mvw				; copy old string block to new
	mov	xr,wb			; restore ptr to new block
	jsr	trimr			; trim blanks (wb is non-zero)
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
.if    .cnbf
.else
;
;      argument is a buffer, perform trim in place.
;
strm0	mov	-(xs),wb		; stack buffer as result
	bze	wa,strm6		; return buffer unchanged if empty
	mov	xl,xr			; get bfblk ptr
	mov	xr,wb			; copy bcblk ptr to xr
	plc	xl,wa			; point past last character
	mov	wc,=ch_bl		; load blank character
;
;      loop through characters from right to left
;
strm1	lch	wb,-(xl)		; load next character
.if    .caht
	beq	wb,=ch_ht,strm2		; jump if horizontal tab
.fi
	bne	wb,wc,strm3		; jump if non-blank found
strm2	dcv	wa			; else decrement character count
	bnz	wa,strm1		; loop back if more to check
;
;      here when buffer trim complete
;
strm3	mov	bclen(xr),wa		; set new length in bcblk
	mov	xr,bcbuf(xr)		; get bfblk ptr
	mov	wb,wa			; copy length
	ctb	wb,0			; words needed converted to bytes
	sub	wb,wa			; number of zeros needed
	psc	xr,wa			; ready for storing zeros
	zer	wc			; set zero char
;
;      loop to zero pad last word of characters
;
strm4	bze	wb,strm5		; loop while more to be done
	sch	wc,(xr)+		; store zero character
	dcv	wb			; decrement count
	brn	strm4			; continue loop
strm5	csc	xr			; complete store characters
strm6	lcw	xr			; get next code word
	bri	(xr)			; execute it
.fi
	ejc
;
;      unload
;
s_unl	ent				; entry point
	mov	xr,(xs)+		; load argument
	jsr	gtnvr			; point to vrblk
	err	201,unload argument is not natural variable name
	mov	xl,=stndf		; get ptr to undefined function
	jsr	dffnc			; undefine named function
	brn	exnul			; return null as result
.if    .c370
	ejc
;
;      xor
;
s_xor	ent				; entry point
	mnz	wb			; signal two arguments
	jsr	sbool			; call string boolean routine
	err	xxx,xor first argument is not a string
	err	xxx,xor second argument is not a string
	err	xxx,xor arguments not same length
	ppm	exits			; null string arguments
;
;      here to process (wc) words.  result is stacked.
;
sxor1	mov	wa,(xl)+		; get next cfp_c chars from arg 1
	xob	wa,(xr)			; xor with characters from arg 2
	mov	(xr)+,wa		; put back in memory
	bct	wc,sxor1		; loop over all words in string block
	brn	exits			; fetch next code word
.fi
	ttl	s p i t b o l -- utility routines
;
;      the following section contains utility routines used for
;      various purposes throughout the system. these differ
;      from the procedures in the utility procedures section in
;      they are not in procedure form and they do not return
;      to their callers. they are accessed with a branch type
;      instruction after setting the registers to appropriate
;      parameter values.
;
;      the register values required for each routine are
;      documented at the start of each routine. registers not
;      mentioned may contain any values except that xr,xl
;      can only contain proper collectable pointers.
;
;      some of these routines will tolerate garbage pointers
;      in xl,xr on entry. this is always documented and in
;      each case, the routine clears these garbage values before
;      exiting after completing its task.
;
;      the routines have names consisting of five letters
;      and are assembled in alphabetical order.
	ejc
;      arref -- array reference
;
;      (xl)		     may be non-collectable
;      (xr)		     number of subscripts
;      (wb)		     set zero/nonzero for value/name
;			     the value in wb must be collectable
;      stack		     subscripts and array operand
;      brn  arref	     jump to call function
;
;      arref continues by executing the next code word with
;      the result name or value placed on top of the stack.
;      to deal with the problem of accessing subscripts in the
;      order of stacking, xl is used as a subscript pointer
;      working below the stack pointer.
;
arref	rtn
	mov	wa,xr			; copy number of subscripts
	mov	xt,xs			; point to stack front
	wtb	xr			; convert to byte offset
	add	xt,xr			; point to array operand on stack
	ica	xt			; final value for stack popping
	mov	arfxs,xt		; keep for later
	mov	xr,-(xt)		; load array operand pointer
	mov	r_arf,xr		; keep array pointer
	mov	xr,xt			; save pointer to subscripts
	mov	xl,r_arf		; point xl to possible vcblk or tbblk
	mov	wc,(xl)			; load first word
	beq	wc,=b_art,arf01		; jump if arblk
	beq	wc,=b_vct,arf07		; jump if vcblk
	beq	wc,=b_tbt,arf10		; jump if tbblk
	erb	235,subscripted operand is not table or array
;
;      here for array (arblk)
;
arf01	bne	wa,arndm(xl),arf09	; jump if wrong number of dims
	ldi	intv0			; get initial subscript of zero
	mov	xt,xr			; point before subscripts
	zer	wa			; initial offset to bounds
	brn	arf03			; jump into loop
;
;      loop to compute subscripts by multiplications
;
arf02	mli	ardm2(xr)		; multiply total by next dimension
;
;      merge here first time
;
arf03	mov	xr,-(xt)		; load next subscript
	sti	arfsi			; save current subscript
	ldi	icval(xr)		; load integer value in case
	beq	(xr),=b_icl,arf04	; jump if it was an integer
	ejc
;
;      arref (continued)
;
;
	jsr	gtint			; convert to integer
	ppm	arf12			; jump if not integer
	ldi	icval(xr)		; if ok, load integer value
;
;      here with integer subscript in (ia)
;
arf04	mov	xr,r_arf		; point to array
	add	xr,wa			; offset to next bounds
	sbi	arlbd(xr)		; subtract low bound to compare
	iov	arf13			; out of range fail if overflow
	ilt	arf13			; out of range fail if too small
	sbi	ardim(xr)		; subtract dimension
	ige	arf13			; out of range fail if too large
	adi	ardim(xr)		; else restore subscript offset
	adi	arfsi			; add to current total
	add	wa,*ardms		; point to next bounds
	bne	xt,xs,arf02		; loop back if more to go
;
;      here with integer subscript computed
;
	mfi	wa			; get as one word integer
	wtb	wa			; convert to offset
	mov	xl,r_arf		; point to arblk
	add	wa,arofs(xl)		; add offset past bounds
	ica	wa			; adjust for arpro field
	bnz	wb,arf08		; exit with name if name call
;
;      merge here to get value for value call
;
arf05	jsr	acess			; get value
	ppm	arf13			; fail if acess fails
;
;      return value
;
arf06	mov	xs,arfxs		; pop stack entries
	zer	r_arf			; finished with array pointer
	mov	-(xs),xr		; stack result
	lcw	xr			; get next code word
	bri	(xr)			; execute it
	ejc
;
;      arref (continued)
;
;      here for vector
;
arf07	bne	wa,=num01,arf09		; error if more than 1 subscript
	mov	xr,(xs)			; else load subscript
	jsr	gtint			; convert to integer
	ppm	arf12			; error if not integer
	ldi	icval(xr)		; else load integer value
	sbi	intv1			; subtract for ones offset
	mfi	wa,arf13		; get subscript as one word
	add	wa,=vcvls		; add offset for standard fields
	wtb	wa			; convert offset to bytes
	bge	wa,vclen(xl),arf13	; fail if out of range subscript
	bze	wb,arf05		; back to get value if value call
;
;      return name
;
arf08	mov	xs,arfxs		; pop stack entries
	zer	r_arf			; finished with array pointer
	brn	exnam			; else exit with name
;
;      here if subscript count is wrong
;
arf09	erb	236,array referenced with wrong number of subscripts
;
;      table
;
arf10	bne	wa,=num01,arf11		; error if more than 1 subscript
	mov	xr,(xs)			; else load subscript
	jsr	tfind			; call table search routine
	ppm	arf13			; fail if failed
	bnz	wb,arf08		; exit with name if name call
	brn	arf06			; else exit with value
;
;      here for bad table reference
;
arf11	erb	237,table referenced with more than one subscript
;
;      here for bad subscript
;
arf12	erb	238,array subscript is not integer
;
;      here to signal failure
;
arf13	zer	r_arf			; finished with array pointer
	brn	exfal			; fail
	ejc
;
;      cfunc -- call a function
;
;      cfunc is used to call a snobol level function. it is
;      used by the apply function (s_app), the function
;      trace routine (trxeq) and the main function call entry
;      (o_fnc, o_fns). in the latter cases, cfunc is used only
;      if the number of arguments is incorrect.
;
;      (xl)		     pointer to function block
;      (wa)		     actual number of arguments
;      (xs)		     points to stacked arguments
;      brn  cfunc	     jump to call function
;
;      cfunc continues by executing the function
;
cfunc	rtn
	blt	wa,fargs(xl),cfnc1	; jump if too few arguments
	beq	wa,fargs(xl),cfnc3	; jump if correct number of args
;
;      here if too many arguments supplied, pop them off
;
	mov	wb,wa			; copy actual number
	sub	wb,fargs(xl)		; get number of extra args
	wtb	wb			; convert to bytes
	add	xs,wb			; pop off unwanted arguments
	brn	cfnc3			; jump to go off to function
;
;      here if too few arguments
;
cfnc1	mov	wb,fargs(xl)		; load required number of arguments
	beq	wb,=nini9,cfnc3		; jump if case of var num of args
	sub	wb,wa			; calculate number missing
	lct	wb,wb			; set counter to control loop
;
;      loop to supply extra null arguments
;
cfnc2	mov	-(xs),=nulls		; stack a null argument
	bct	wb,cfnc2		; loop till proper number stacked
;
;      merge here to jump to function
;
cfnc3	bri	(xl)			; jump through fcode field
	ejc
;
;      exfal -- exit signalling snobol failure
;
;      (xl,xr)		     may be non-collectable
;      brn  exfal	     jump to fail
;
;      exfal continues by executing the appropriate fail goto
;
exfal	rtn
	mov	xs,flptr		; pop stack
	mov	xr,(xs)			; load failure offset
	add	xr,r_cod		; point to failure code location
	lcp	xr			; set code pointer
	lcw	xr			; load next code word
	mov	xl,(xr)			; load entry address
	bri	xl			; jump to execute next code word
	ejc
;
;      exint -- exit with integer result
;
;      (xl,xr)		     may be non-collectable
;      (ia)		     integer value
;      brn  exint	     jump to exit with integer
;
;      exint continues by executing the next code word
;      which it does by falling through to exixr
;
exint	rtn
	zer	xl			; clear dud value
	jsr	icbld			; build icblk
	ejc
;      exixr -- exit with result in (xr)
;
;      (xr)		     result
;      (xl)		     may be non-collectable
;      brn  exixr	     jump to exit with result in (xr)
;
;      exixr continues by executing the next code word
;      which it does by falling through to exits.
exixr	rtn
;
	mov	-(xs),xr		; stack result
;
;
;      exits -- exit with result if any stacked
;
;      (xr,xl)		     may be non-collectable
;
;      brn  exits	     enter exits routine
;
exits	rtn
	lcw	xr			; load next code word
	mov	xl,(xr)			; load entry address
	bri	xl			; jump to execute next code word
	ejc
;
;      exnam -- exit with name in (xl,wa)
;
;      (xl)		     name base
;      (wa)		     name offset
;      (xr)		     may be non-collectable
;      brn  exnam	     jump to exit with name in (xl,wa)
;
;      exnam continues by executing the next code word
;
exnam	rtn
	mov	-(xs),xl		; stack name base
	mov	-(xs),wa		; stack name offset
	lcw	xr			; load next code word
	bri	(xr)			; execute it
	ejc
;
;      exnul -- exit with null result
;
;      (xl,xr)		     may be non-collectable
;      brn  exnul	     jump to exit with null value
;
;      exnul continues by executing the next code word
;
exnul	rtn
	mov	-(xs),=nulls		; stack null value
	lcw	xr			; load next code word
	mov	xl,(xr)			; load entry address
	bri	xl			; jump to execute next code word
	ejc
.if    .cnra
.else
;
;      exrea -- exit with real result
;
;      (xl,xr)		     may be non-collectable
;      (ra)		     real value
;      brn  exrea	     jump to exit with real value
;
;      exrea continues by executing the next code word
;
exrea	rtn
	zer	xl			; clear dud value
	jsr	rcbld			; build rcblk
	brn	exixr			; jump to exit with result in xr
.fi
	ejc
;
;      exsid -- exit setting id field
;
;      exsid is used to exit after building any of the following
;      blocks (arblk, tbblk, pdblk, vcblk). it sets the idval.
;
;      (xr)		     ptr to block with idval field
;      (xl)		     may be non-collectable
;      brn  exsid	     jump to exit after setting id field
;
;      exsid continues by executing the next code word
;
exsid	rtn
	mov	wa,curid		; load current id value
	bne	wa,mxint,exsi1		; jump if no overflow
	zer	wa			; else reset for wraparound
;
;      here with old idval in wa
;
exsi1	icv	wa			; bump id value
	mov	curid,wa		; store for next time
	mov	idval(xr),wa		; store id value
	brn	exixr			; exit with result in (xr)
	ejc
;
;      exvnm -- exit with name of variable
;
;      exvnm exits after stacking a value which is a nmblk
;      referencing the name of a given natural variable.
;
;      (xr)		     vrblk pointer
;      (xl)		     may be non-collectable
;      brn  exvnm	     exit with vrblk pointer in xr
;
exvnm	rtn
	mov	xl,xr			; copy name base pointer
	mov	wa,*nmsi_		; set size of nmblk
	jsr	alloc			; allocate nmblk
	mov	(xr),=b_nml		; store type word
	mov	nmbas(xr),xl		; store name base
	mov	nmofs(xr),*vrval	; store name offset
	brn	exixr			; exit with result in xr
	ejc
;
;      flpop -- fail and pop in pattern matching
;
;      flpop pops the node and cursor on the stack and then
;      drops through into failp to cause pattern failure
;
;      (xl,xr)		     may be non-collectable
;      brn  flpop	     jump to fail and pop stack
;
flpop	rtn
	add	xs,*num02		; pop two entries off stack
	ejc
;
;      failp -- failure in matching pattern node
;
;      failp is used after failing to match a pattern node.
;      see pattern match routines for details of use.
;
;      (xl,xr)		     may be non-collectable
;      brn  failp	     signal failure to match
;
;      failp continues by matching an alternative from the stack
;
failp	rtn
	mov	xr,(xs)+		; load alternative node pointer
	mov	wb,(xs)+		; restore old cursor
	mov	xl,(xr)			; load pcode entry pointer
	bri	xl			; jump to execute code for node
	ejc
;
;      indir -- compute indirect reference
;
;      (wb)		     nonzero/zero for by name/value
;      brn  indir	     jump to get indirect ref on stack
;
;      indir continues by executing the next code word
;
indir	rtn
	mov	xr,(xs)+		; load argument
	beq	(xr),=b_nml,indr2	; jump if a name
	jsr	gtnvr			; else convert to variable
	err	239,indirection operand is not name
	bze	wb,indr1		; skip if by value
	mov	-(xs),xr		; else stack vrblk ptr
	mov	-(xs),*vrval		; stack name offset
	lcw	xr			; load next code word
	mov	xl,(xr)			; load entry address
	bri	xl			; jump to execute next code word
;
;      here to get value of natural variable
;
indr1	bri	(xr)			; jump through vrget field of vrblk
;
;      here if operand is a name
;
indr2	mov	xl,nmbas(xr)		; load name base
	mov	wa,nmofs(xr)		; load name offset
	bnz	wb,exnam		; exit if called by name
	jsr	acess			; else get value first
	ppm	exfal			; fail if access fails
	brn	exixr			; else return with value in xr
	ejc
;
;      match -- initiate pattern match
;
;      (wb)		     match type code
;      brn  match	     jump to initiate pattern match
;
;      match continues by executing the pattern match. see
;      pattern match routines (p_xxx) for full details.
;
match	rtn
	mov	xr,(xs)+		; load pattern operand
	jsr	gtpat			; convert to pattern
	err	240,pattern match right operand is not pattern
	mov	xl,xr			; if ok, save pattern pointer
	bnz	wb,mtch1		; jump if not match by name
	mov	wa,(xs)			; else load name offset
	mov	-(xs),xl		; save pattern pointer
	mov	xl,num02(xs)		; load name base
	jsr	acess			; access subject value
	ppm	exfal			; fail if access fails
	mov	xl,(xs)			; restore pattern pointer
	mov	(xs),xr			; stack subject string val for merge
	zer	wb			; restore type code
;
;      merge here with subject value on stack
;
.if    .cnbf
mtch1	jsr	gtstg			; convert subject to string
	err	241,pattern match left operand is not a string
	mov	-(xs),wb		; stack match type code
.else
mtch1	mov	wc,wb			; save match type in wc
	jsr	gtstb			; convert subject to string
	err	241,pattern match left operand is not a string or buffer
	mov	r_pmb,wb		; set to zero/bcblk if string/buffer
	mov	-(xs),wc		; stack match type code
.fi
	mov	r_pms,xr		; if ok, store subject string pointer
	mov	pmssl,wa		; and length
	zer	-(xs)			; stack initial cursor (zero)
	zer	wb			; set initial cursor
	mov	pmhbs,xs		; set history stack base ptr
	zer	pmdfl			; reset pattern assignment flag
	mov	xr,xl			; set initial node pointer
	bnz	kvanc,mtch2		; jump if anchored
;
;      here for unanchored
;
	mov	-(xs),xr		; stack initial node pointer
	mov	-(xs),=nduna		; stack pointer to anchor move node
	bri	(xr)			; start match of first node
;
;      here in anchored mode
;
mtch2	zer	-(xs)			; dummy cursor value
	mov	-(xs),=ndabo		; stack pointer to abort node
	bri	(xr)			; start match of first node
	ejc
;
;      retrn -- return from function
;
;      (wa)		     string pointer for return type
;      brn  retrn	     jump to return from (snobol) func
;
;      retrn continues by executing the code at the return point
;      the stack is cleaned of any garbage left by other
;      routines which may have altered flptr since function
;      entry by using flprt, reserved for use only by
;      function call and return.
;
retrn	rtn
	bnz	kvfnc,rtn01		; jump if not level zero
	erb	242,function return from level zero
;
;      here if not level zero return
;
rtn01	mov	xs,flprt		; pop stack
	ica	xs			; remove failure offset
	mov	xr,(xs)+		; pop pfblk pointer
	mov	flptr,(xs)+		; pop failure pointer
	mov	flprt,(xs)+		; pop old flprt
	mov	wb,(xs)+		; pop code pointer offset
	mov	wc,(xs)+		; pop old code block pointer
	add	wb,wc			; make old code pointer absolute
	lcp	wb			; restore old code pointer
	mov	r_cod,wc		; restore old code block pointer
	dcv	kvfnc			; decrement function level
	mov	wb,kvtra		; load trace
	add	wb,kvftr		; add ftrace
	bze	wb,rtn06		; jump if no tracing possible
;
;      here if there may be a trace
;
	mov	-(xs),wa		; save function return type
	mov	-(xs),xr		; save pfblk pointer
	mov	kvrtn,wa		; set rtntype for trace function
	mov	xl,r_fnc		; load fnclevel trblk ptr (if any)
	jsr	ktrex			; execute possible fnclevel trace
	mov	xl,pfvbl(xr)		; load vrblk ptr (sgd13)
	bze	kvtra,rtn02		; jump if trace is off
	mov	xr,pfrtr(xr)		; else load return trace trblk ptr
	bze	xr,rtn02		; jump if not return traced
	dcv	kvtra			; else decrement trace count
	bze	trfnc(xr),rtn03		; jump if print trace
	mov	wa,*vrval		; else set name offset
	mov	kvrtn,num01(xs)		; make sure rtntype is set right
	jsr	trxeq			; execute full trace
	ejc
;
;      retrn (continued)
;
;      here to test for ftrace
;
rtn02	bze	kvftr,rtn05		; jump if ftrace is off
	dcv	kvftr			; else decrement ftrace
;
;      here for print trace of function return
;
rtn03	jsr	prtsn			; print statement number
	mov	xr,num01(xs)		; load return type
	jsr	prtst			; print it
	mov	wa,=ch_bl		; load blank
	jsr	prtch			; print it
	mov	xl,0(xs)		; load pfblk ptr
	mov	xl,pfvbl(xl)		; load function vrblk ptr
	mov	wa,*vrval		; set vrblk name offset
	bne	xr,=scfrt,rtn04		; jump if not freturn case
;
;      for freturn, just print function name
;
	jsr	prtnm			; print name
	jsr	prtnl			; terminate print line
	brn	rtn05			; merge
;
;      here for return or nreturn, print function name = value
;
rtn04	jsr	prtnv			; print name = value
;
;      here after completing trace
;
rtn05	mov	xr,(xs)+		; pop pfblk pointer
	mov	wa,(xs)+		; pop return type string
;
;      merge here if no trace required
;
rtn06	mov	kvrtn,wa		; set rtntype keyword
	mov	xl,pfvbl(xr)		; load pointer to fn vrblk
	ejc
;      retrn (continued)
;
;      get value of function
;
rtn07	mov	rtnbp,xl		; save block pointer
	mov	xl,vrval(xl)		; load value
	beq	(xl),=b_trt,rtn07	; loop back if trapped
	mov	rtnfv,xl		; else save function result value
	mov	rtnsv,(xs)+		; save original function value
.if    .cnpf
	mov	wb,fargs(xr)		; get number of arguments
.else
	mov	xl,(xs)+		; pop saved pointer
	bze	xl,rtn7c		; no action if none
	bze	kvpfl,rtn7c		; jump if no profiling
	jsr	prflu			; else profile last func stmt
	beq	kvpfl,=num02,rtn7a	; branch on value of profile keywd
;
;      here if &profile = 1. start time must be frigged to
;      appear earlier than it actually is, by amount used before
;      the call.
;
	ldi	pfstm			; load current time
	sbi	icval(xl)		; frig by subtracting saved amount
	brn	rtn7b			; and merge
;
;      here if &profile = 2
;
rtn7a	ldi	icval(xl)		; load saved time
;
;      both profile types merge here
;
rtn7b	sti	pfstm			; store back correct start time
;
;      merge here if no profiling
;
rtn7c	mov	wb,fargs(xr)		; get number of args
.fi
	add	wb,pfnlo(xr)		; add number of locals
	bze	wb,rtn10		; jump if no args/locals
	lct	wb,wb			; else set loop counter
	add	xr,pflen(xr)		; and point to end of pfblk
;
;      loop to restore functions and locals
;
rtn08	mov	xl,-(xr)		; load next vrblk pointer
;
;      loop to find value block
;
rtn09	mov	wa,xl			; save block pointer
	mov	xl,vrval(xl)		; load pointer to next value
	beq	(xl),=b_trt,rtn09	; loop back if trapped
	mov	xl,wa			; else restore last block pointer
	mov	vrval(xl),(xs)+		; restore old variable value
	bct	wb,rtn08		; loop till all processed
;
;      now restore function value and exit
;
rtn10	mov	xl,rtnbp		; restore ptr to last function block
	mov	vrval(xl),rtnsv		; restore old function value
	mov	xr,rtnfv		; reload function result
	mov	xl,r_cod		; point to new code block
	mov	kvlst,kvstn		; set lastno from stno
	mov	kvstn,cdstm(xl)		; reset proper stno value
.if    .csln
	mov	kvlln,kvlin		; set lastline from line
	mov	kvlin,cdsln(xl)		; reset proper line value
.fi
	mov	wa,kvrtn		; load return type
	beq	wa,=scrtn,exixr		; exit with result in xr if return
	beq	wa,=scfrt,exfal		; fail if freturn
	ejc
;
;      retrn (continued)
;
;      here for nreturn
;
	beq	(xr),=b_nml,rtn11	; jump if is a name
	jsr	gtnvr			; else try convert to variable name
	err	243,function result in nreturn is not name
	mov	xl,xr			; if ok, copy vrblk (name base) ptr
	mov	wa,*vrval		; set name offset
	brn	rtn12			; and merge
;
;      here if returned result is a name
;
rtn11	mov	xl,nmbas(xr)		; load name base
	mov	wa,nmofs(xr)		; load name offset
;
;      merge here with returned name in (xl,wa)
;
rtn12	mov	xr,xl			; preserve xl
	lcw	wb			; load next word
	mov	xl,xr			; restore xl
	beq	wb,=ofne_,exnam		; exit if called by name
	mov	-(xs),wb		; else save code word
	jsr	acess			; get value
	ppm	exfal			; fail if access fails
	mov	xl,xr			; if ok, copy result
	mov	xr,(xs)			; reload next code word
	mov	(xs),xl			; store result on stack
	mov	xl,(xr)			; load routine address
	bri	xl			; jump to execute next code word
	ejc
;
;      stcov -- signal statement counter overflow
;
;      brn  stcov	     jump to signal statement count oflo
;
;      permit up to 10 more statements to be obeyed so that
;      setexit trap can regain control.
;      stcov continues by issuing the error message
;
stcov	rtn
	icv	errft			; fatal error
	ldi	intvt			; get 10
	adi	kvstl			; add to former limit
	sti	kvstl			; store as new stlimit
	ldi	intvt			; get 10
	sti	kvstc			; set as new count
	jsr	stgcc			; recompute countdown counters
	erb	244,statement count exceeds value of stlimit keyword
	ejc
;
;      stmgo -- start execution of new statement
;
;      (xr)		     pointer to cdblk for new statement
;      brn  stmgo	     jump to execute new statement
;
;      stmgo continues by executing the next statement
;
stmgo	rtn
	mov	r_cod,xr		; set new code block pointer
	dcv	stmct			; see if time to check something
	bze	stmct,stgo2		; jump if so
	mov	kvlst,kvstn		; set lastno
	mov	kvstn,cdstm(xr)		; set stno
.if    .csln
	mov	kvlln,kvlin		; set lastline
	mov	kvlin,cdsln(xr)		; set line
.fi
	add	xr,*cdcod		; point to first code word
	lcp	xr			; set code pointer
;
;      here to execute first code word of statement
;
stgo1	lcw	xr			; load next code word
	zer	xl			; clear garbage xl
	bri	(xr)			; execute it
;
;      check profiling, polling, stlimit, statement tracing
;
stgo2	bze	kvpfl,stgo3		; skip if no profiling
	jsr	prflu			; else profile the statement in kvstn
;
;      here when finished with profiling
;
stgo3	mov	kvlst,kvstn		; set lastno
	mov	kvstn,cdstm(xr)		; set stno
.if    .csln
	mov	kvlln,kvlin		; set lastline
	mov	kvlin,cdsln(xr)		; set line
.fi
	add	xr,*cdcod		; point to first code word
	lcp	xr			; set code pointer
.if    .cpol
;
;      here to check for polling
;
	mov	-(xs),stmcs		; save present count start on stack
	dcv	polct			; poll interval within stmct
	bnz	polct,stgo4		; jump if not poll time yet
	zer	wa			; =0 for poll
	mov	wb,kvstn		; statement number
	mov	xl,xr			; make collectable
	jsr	syspl			; allow interactive access
	err	320,user interrupt
	ppm				; single step
	ppm				; expression evaluation
	mov	xr,xl			; restore code block pointer
	mov	polcs,wa		; poll interval start value
	jsr	stgcc			; recompute counter values
.fi
;
;      check statement limit
;
stgo4	ldi	kvstc			; get stmt count
	ilt	stgo5			; omit counting if negative
	mti	(xs)+			; reload start value of counter
	ngi				; negate
	adi	kvstc			; stmt count minus counter
	sti	kvstc			; replace it
	ile	stcov			; fail if stlimit reached
	bze	r_stc,stgo5		; jump if no statement trace
	zer	xr			; clear garbage value in xr
	mov	xl,r_stc		; load pointer to stcount trblk
	jsr	ktrex			; execute keyword trace
;
;      reset stmgo counter
;
stgo5	mov	stmct,stmcs		; reset counter
	brn	stgo1			; fetch next code word
	ejc
;
;      stopr -- terminate run
;
;      (xr)		     points to ending message
;      brn stopr	     jump to terminate run
;
;      terminate run and print statistics.  on entry xr points
;      to ending message or is zero if message	printed already.
;
stopr	rtn
.if    .csax
	bze	xr,stpra		; skip if sysax already called
	jsr	sysax			; call after execution proc
stpra	add	dname,rsmem		; use the reserve memory
.else
	add	dname,rsmem		; use the reserve memory
.fi
	bne	xr,=endms,stpr0		; skip if not normal end message
	bnz	exsts,stpr3		; skip if exec stats suppressed
	zer	erich			; clear errors to int.ch. flag
;
;      look to see if an ending message is supplied
;
stpr0	jsr	prtpg			; eject printer
	bze	xr,stpr1		; skip if no message
	jsr	prtst			; print message
;
;      merge here if no message to print
;
stpr1	jsr	prtis			; print blank line
.if    .csfn
	bnz	gbcfl,stpr5		; if in garbage collection, skip
	mov	xr,=stpm7		; point to message /in file xxx/
	jsr	prtst			; print it
	mov	profs,=prtmf		; set column offset
	mov	wc,kvstn		; get statement number
	jsr	filnm			; get file name
	mov	xr,xl			; prepare to print
	jsr	prtst			; print file name
	jsr	prtis			; print to interactive channel
.fi
.if    .csln
.if    .csfn
.else
	bnz	gbcfl,stpr5		; if in garbage collection, skip
.fi
	mov	xr,r_cod		; get code pointer
	mti	cdsln(xr)		; get source line number
	mov	xr,=stpm6		; point to message /in line xxx/
	jsr	prtmx			; print it
.fi
stpr5	mti	kvstn			; get statement number
	mov	xr,=stpm1		; point to message /in statement xxx/
	jsr	prtmx			; print it
	jsr	systm			; get current time
	sbi	timsx			; minus start time = elapsed exec tim
	sti	stpti			; save for later
	mov	xr,=stpm3		; point to msg /execution time msec /
	jsr	prtmx			; print it
	ldi	kvstl			; get statement limit
	ilt	stpr2			; skip if negative
	sbi	kvstc			; minus counter = course count
	sti	stpsi			; save
	mov	wa,stmcs		; refine with counter start value
	sub	wa,stmct		; minus current counter
	mti	wa			; convert to integer
	adi	stpsi			; add in course count
	sti	stpsi			; save
	mov	xr,=stpm2		; point to message /stmts executed/
	jsr	prtmx			; print it
.if    .ctmd
.else
	ldi	stpti			; reload elapsed time
	mli	intth			; *1000 (microsecs)
	iov	stpr2			; jump if we cannot compute
	dvi	stpsi			; divide by statement count
	iov	stpr2			; jump if overflow
	mov	xr,=stpm4		; point to msg (mcsec per statement /
	jsr	prtmx			; print it
.fi
	ejc
;
;      stopr (continued)
;
;      merge to skip message (overflow or negative stlimit)
;
stpr2	mti	gbcnt			; load count of collections
	mov	xr,=stpm5		; point to message /regenerations /
	jsr	prtmx			; print it
	jsr	prtmm			; print memory usage
	jsr	prtis			; one more blank for luck
;
;      check if dump requested
;
.if    .cnpf
stpr3	mov	xr,kvdmp		; load dump keyword
.else
stpr3	jsr	prflr			; print profile if wanted
;
	mov	xr,kvdmp		; load dump keyword
.fi
	jsr	dumpr			; execute dump if requested
	mov	xl,r_fcb		; get fcblk chain head
	mov	wa,kvabe		; load abend value
	mov	wb,kvcod		; load code value
	jsr	sysej			; exit to system
.if    .cera
;
;      here after sysea call and suppressing error msg print
;
stpr4	rtn
	add	dname,rsmem		; use the reserve memory
	bze	exsts,stpr1		; if execution stats requested
	brn	stpr3			; check if dump or profile needed
.fi

	ejc
;
;      succp -- signal successful match of a pattern node
;
;      see pattern match routines for details
;
;      (xr)		     current node
;      (wb)		     current cursor
;      (xl)		     may be non-collectable
;      brn  succp	     signal successful pattern match
;
;      succp continues by matching the successor node
;
succp	rtn
	mov	xr,pthen(xr)		; load successor node
	mov	xl,(xr)			; load node code entry address
	bri	xl			; jump to match successor node
	ejc
;
;      sysab -- print /abnormal end/ and terminate
;
sysab	rtn
	mov	xr,=endab		; point to message
	mov	kvabe,=num01		; set abend flag
	jsr	prtnl			; skip to new line
	brn	stopr			; jump to pack up
	ejc
;
;      systu -- print /time up/ and terminate
;
systu	rtn
	mov	xr,=endtu		; point to message
	mov	wa,strtu		; get chars /tu/
	mov	kvcod,wa		; put in kvcod
	mov	wa,timup		; check state of timeup switch
	mnz	timup			; set switch
	bnz	wa,stopr		; stop run if already set
	erb	245,translation/execution time expired
	ttl	s p i t b o l -- utility procedures
;
;      the following section contains procedures which are
;      used for various purposes throughout the system.
;
;      each procedure is preceded by a description of the
;      calling sequence. usually the arguments are in registers
;      but arguments can also occur on the stack and as
;      parameters assembled after the jsr instruction.
;
;      the following considerations apply to these descriptions.
;
;      1)   the stack pointer (xs) is not changed unless the
;	    change is explicitly documented in the call.
;
;      2)   registers whose entry values are not mentioned
;	    may contain any value except that xl,xr may only
;	    contain proper (collectable) pointer values.
;	    this condition on means that the called routine
;	    may if it chooses preserve xl,xr by stacking.
;
;      3)   registers not mentioned on exit contain the same
;	    values as they did on entry except that values in
;	    xr,xl may have been relocated by the collector.
;
;      4)   registers which are destroyed on exit may contain
;	    any value except that values in xl,xr are proper
;	    (collectable) pointers.
;
;      5)   the code pointer register points to the current
;	    code location on entry and is unchanged on exit.
;
;      in the above description, a collectable pointer is one
;      which either points outside the dynamic region or
;      points to the start of a block in the dynamic region.
;
;      in those cases where the calling sequence contains
;      parameters which are used as alternate return points,
;      these parameters may be replaced by error codes
;      assembled with the err instruction. this will result
;      in the posting of the error if the return is taken.
;
;      the procedures all have names consisting of five letters
;      and are in alphabetical order by their names.
	ejc
;
;      acess - access variable value with trace/input checks
;
;      acess loads the value of a variable. trace and input
;      associations are tested for and executed as required.
;      acess also handles the special cases of pseudo-variables.
;
;      (xl)		     variable name base
;      (wa)		     variable name offset
;      jsr  acess	     call to access value
;      ppm  loc		     transfer loc if access failure
;      (xr)		     variable value
;      (wa,wb,wc)	     destroyed
;      (xl,ra)		     destroyed
;
;      failure can occur if an input association causes an end
;      of file condition or if the evaluation of an expression
;      associated with an expression variable fails.
;
acess	prc	r,1			; entry point (recursive)
	mov	xr,xl			; copy name base
	add	xr,wa			; point to variable location
	mov	xr,(xr)			; load variable value
;
;      loop here to check for successive trblks
;
acs02	bne	(xr),=b_trt,acs18	; jump if not trapped
;
;      here if trapped
;
	beq	xr,=trbkv,acs12		; jump if keyword variable
	bne	xr,=trbev,acs05		; jump if not expression variable
;
;      here for expression variable, evaluate variable
;
	mov	xr,evexp(xl)		; load expression pointer
	zer	wb			; evaluate by value
	jsr	evalx			; evaluate expression
	ppm	acs04			; jump if evaluation failure
	brn	acs02			; check value for more trblks
	ejc
;
;      acess (continued)
;
;      here on reading end of file
;
acs03	add	xs,*num03		; pop trblk ptr, name base and offset
	mov	dnamp,xr		; pop unused scblk
;
;      merge here when evaluation of expression fails
;
acs04	exi	1			; take alternate (failure) return
;
;      here if not keyword or expression variable
;
acs05	mov	wb,trtyp(xr)		; load trap type code
	bnz	wb,acs10		; jump if not input association
	bze	kvinp,acs09		; ignore input assoc if input is off
;
;      here for input association
;
	mov	-(xs),xl		; stack name base
	mov	-(xs),wa		; stack name offset
	mov	-(xs),xr		; stack trblk pointer
	mov	actrm,kvtrm		; temp to hold trim keyword
	mov	xl,trfpt(xr)		; get file ctrl blk ptr or zero
	bnz	xl,acs06		; jump if not standard input file
	beq	trter(xr),=v_ter,acs21	; jump if terminal
;
;      here to read from standard input file
;
	mov	wa,cswin		; length for read buffer
	jsr	alocs			; build string of appropriate length
	jsr	sysrd			; read next standard input image
	ppm	acs03			; jump to fail exit if end of file
	brn	acs07			; else merge with other file case
;
;      here for input from other than standard input file
;
acs06	mov	wa,xl			; fcblk ptr
	jsr	sysil			; get input record max length (to wa)
	bnz	wc,acs6a		; jump if not binary file
	mov	actrm,wc		; disable trim for binary file
acs6a	jsr	alocs			; allocate string of correct size
	mov	wa,xl			; fcblk ptr
	jsr	sysin			; call system input routine
	ppm	acs03			; jump to fail exit if end of file
	ppm	acs22			; error
	ppm	acs23			; error
	ejc
;
;      acess (continued)
;
;      merge here after obtaining input record
;
acs07	mov	wb,actrm		; load trim indicator
	jsr	trimr			; trim record as required
	mov	wb,xr			; copy result pointer
	mov	xr,(xs)			; reload pointer to trblk
;
;      loop to chase to end of trblk chain and store value
;
acs08	mov	xl,xr			; save pointer to this trblk
	mov	xr,trnxt(xr)		; load forward pointer
	beq	(xr),=b_trt,acs08	; loop if this is another trblk
	mov	trnxt(xl),wb		; else store result at end of chain
	mov	xr,(xs)+		; restore initial trblk pointer
	mov	wa,(xs)+		; restore name offset
	mov	xl,(xs)+		; restore name base pointer
;
;      come here to move to next trblk
;
acs09	mov	xr,trnxt(xr)		; load forward ptr to next value
	brn	acs02			; back to check if trapped
;
;      here to check for access trace trblk
;
acs10	bne	wb,=trtac,acs09		; loop back if not access trace
	bze	kvtra,acs09		; ignore access trace if trace off
	dcv	kvtra			; else decrement trace count
	bze	trfnc(xr),acs11		; jump if print trace
	ejc
;
;      acess (continued)
;
;      here for full function trace
;
	jsr	trxeq			; call routine to execute trace
	brn	acs09			; jump for next trblk
;
;      here for case of print trace
;
acs11	jsr	prtsn			; print statement number
	jsr	prtnv			; print name = value
	brn	acs09			; jump back for next trblk
;
;      here for keyword variable
;
acs12	mov	xr,kvnum(xl)		; load keyword number
	bge	xr,=k_v__,acs14		; jump if not one word value
	mti	kvabe(xr)		; else load value as integer
;
;      common exit with keyword value as integer in (ia)
;
acs13	jsr	icbld			; build icblk
	brn	acs18			; jump to exit
;
;      here if not one word keyword value
;
acs14	bge	xr,=k_s__,acs15		; jump if special case
	sub	xr,=k_v__		; else get offset
	wtb	xr			; convert to byte offset
	add	xr,=ndabo		; point to pattern value
	brn	acs18			; jump to exit
;
;      here if special keyword case
;
acs15	mov	xl,kvrtn		; load rtntype in case
	ldi	kvstl			; load stlimit in case
	sub	xr,=k_s__		; get case number
	bsw	xr,k__n_		; switch on keyword number
.if    .csfn
	iff	k__fl,acs26		; file
	iff	k__lf,acs27		; lastfile
.fi
.if    .culk
	iff	k__lc,acs24		; lcase
	iff	k__uc,acs25		; ucase
.fi
	iff	k__al,acs16		; jump if alphabet
	iff	k__rt,acs17		; rtntype
	iff	k__sc,acs19		; stcount
	iff	k__sl,acs13		; stlimit
	iff	k__et,acs20		; errtext
	esw				; end switch on keyword number
	ejc
;
;      acess (continued)
;
.if    .culk
;      lcase
;
acs24	mov	xr,=lcase		; load pointer to lcase string
	brn	acs18			; common return
;
;      ucase
;
acs25	mov	xr,=ucase		; load pointer to ucase string
	brn	acs18			; common return
;
.fi
.if    .csfn
;      file
;
acs26	mov	wc,kvstn		; load current stmt number
	brn	acs28			; merge to obtain file name
;
;      lastfile
;
acs27	mov	wc,kvlst		; load last stmt number
;
;      merge here to map statement number in wc to file name
;
acs28	jsr	filnm			; obtain file name for this stmt
	brn	acs17			; merge to return string in xl
.fi
;      alphabet
;
acs16	mov	xl,kvalp		; load pointer to alphabet string
;
;      rtntype merges here
;
acs17	mov	xr,xl			; copy string ptr to proper reg
;
;      common return point
;
acs18	exi				; return to acess caller
;
;      here for stcount (ia has stlimit)
;
acs19	ilt	acs29			; if counting suppressed
	mov	wa,stmcs		; refine with counter start value
	sub	wa,stmct		; minus current counter
	mti	wa			; convert to integer
	adi	kvstl			; add stlimit
acs29	sbi	kvstc			; stcount = limit - left
	brn	acs13			; merge back with integer result
;
;      errtext
;
acs20	mov	xr,r_etx		; get errtext string
	brn	acs18			; merge with result
;
;      here to read a record from terminal
;
acs21	mov	wa,=rilen		; buffer length
	jsr	alocs			; allocate buffer
	jsr	sysri			; read record
	ppm	acs03			; endfile
	brn	acs07			; merge with record read
;
;      error returns
;
acs22	mov	dnamp,xr		; pop unused scblk
	erb	202,input from file caused non-recoverable error
;
acs23	mov	dnamp,xr		; pop unused scblk
	erb	203,input file record has incorrect format
	enp				; end procedure acess
	ejc
;
;      acomp -- compare two arithmetic values
;
;      1(xs)		     first argument
;      0(xs)		     second argument
;      jsr  acomp	     call to compare values
;      ppm  loc		     transfer loc if arg1 is non-numeric
;      ppm  loc		     transfer loc if arg2 is non-numeric
;      ppm  loc		     transfer loc for arg1 lt arg2
;      ppm  loc		     transfer loc for arg1 eq arg2
;      ppm  loc		     transfer loc for arg1 gt arg2
;      (normal return is never given)
;      (wa,wb,wc,ia,ra)	     destroyed
;      (xl,xr)		     destroyed
;
acomp	prc	n,5			; entry point
	jsr	arith			; load arithmetic operands
	ppm	acmp7			; jump if first arg non-numeric
	ppm	acmp8			; jump if second arg non-numeric
.if    .cnra
.else
	ppm	acmp4			; jump if real arguments
.fi
;
;      here for integer arguments
;
	sbi	icval(xl)		; subtract to compare
	iov	acmp3			; jump if overflow
	ilt	acmp5			; else jump if arg1 lt arg2
	ieq	acmp2			; jump if arg1 eq arg2
;
;      here if arg1 gt arg2
;
acmp1	exi	5			; take gt exit
;
;      here if arg1 eq arg2
;
acmp2	exi	4			; take eq exit
	ejc
;
;      acomp (continued)
;
;      here for integer overflow on subtract
;
acmp3	ldi	icval(xl)		; load second argument
	ilt	acmp1			; gt if negative
	brn	acmp5			; else lt
.if    .cnra
.else
;
;      here for real operands
;
acmp4	sbr	rcval(xl)		; subtract to compare
	rov	acmp6			; jump if overflow
	rgt	acmp1			; else jump if arg1 gt
	req	acmp2			; jump if arg1 eq arg2
.fi
;
;      here if arg1 lt arg2
;
acmp5	exi	3			; take lt exit
.if    .cnra
.else
;
;      here if overflow on real subtraction
;
acmp6	ldr	rcval(xl)		; reload arg2
	rlt	acmp1			; gt if negative
	brn	acmp5			; else lt
.fi
;
;      here if arg1 non-numeric
;
acmp7	exi	1			; take error exit
;
;      here if arg2 non-numeric
;
acmp8	exi	2			; take error exit
	enp				; end procedure acomp
	ejc
;
;      alloc		     allocate block of dynamic storage
;
;      (wa)		     length required in bytes
;      jsr  alloc	     call to allocate block
;      (xr)		     pointer to allocated block
;
;      a possible alternative to aov ... and following stmt is -
;      mov  dname,xr .	sub  wa,xr .  blo xr,dnamp,aloc2 .
;      mov  dnamp,xr .	add  wa,xr
;
alloc	prc	e,0			; entry point
;
;      common exit point
;
aloc1	mov	xr,dnamp		; point to next available loc
	aov	wa,xr,aloc2		; point past allocated block
	bgt	xr,dname,aloc2		; jump if not enough room
	mov	dnamp,xr		; store new pointer
	sub	xr,wa			; point back to start of allocated bk
	exi				; return to caller
;
;      here if insufficient room, try a garbage collection
;
aloc2	mov	allsv,wb		; save wb
alc2a	zer	wb			; set no upward move for gbcol
	jsr	gbcol			; garbage collect
.if    .csed
	mov	wb,xr			; remember new sediment size
.fi
;
;      see if room after gbcol or sysmm call
;
aloc3	mov	xr,dnamp		; point to first available loc
	aov	wa,xr,alc3a		; point past new block
	blo	xr,dname,aloc4		; jump if there is room now
;
;      failed again, see if we can get more core
;
alc3a	jsr	sysmm			; try to get more memory
	wtb	xr			; convert to baus (sgd05)
	add	dname,xr		; bump ptr by amount obtained
	bnz	xr,aloc3		; jump if got more core
.if    .csed
	bze	dnams,alc3b		; jump if there was no sediment
	zer	dnams			; try collecting the sediment
	brn	alc2a			;
;
;      sysmm failed and there was no sediment to collect
;
alc3b	add	dname,rsmem		; get the reserve memory
.else
	add	dname,rsmem		; get the reserve memory
.fi
	zer	rsmem			; only permissible once
	icv	errft			; fatal error
	erb	204,memory overflow
	ejc
;
;      here after successful garbage collection
;
aloc4	sti	allia			; save ia
.if    .csed
	mov	dnams,wb		; record new sediment size
.fi
	mov	wb,dname		; get dynamic end adrs
	sub	wb,dnamp		; compute free store
	btw	wb			; convert bytes to words
	mti	wb			; put free store in ia
	mli	alfsf			; multiply by free store factor
	iov	aloc5			; jump if overflowed
	mov	wb,dname		; dynamic end adrs
	sub	wb,dnamb		; compute total amount of dynamic
	btw	wb			; convert to words
	mov	aldyn,wb		; store it
	sbi	aldyn			; subtract from scaled up free store
	igt	aloc5			; jump if sufficient free store
	jsr	sysmm			; try to get more store
	wtb	xr			; convert to baus (sgd05)
	add	dname,xr		; adjust dynamic end adrs
;
;      merge to restore ia and wb
;
aloc5	ldi	allia			; recover ia
	mov	wb,allsv		; restore wb
	brn	aloc1			; jump back to exit
	enp				; end procedure alloc
	ejc
.if    .cnbf
.else
;
;      alobf -- allocate buffer
;
;      this routines allocates a new buffer.  as the bfblk
;      and bcblk come in pairs, both are allocated here,
;      and xr points to the bcblk on return.  the bfblk
;      and bcblk are set to the null buffer, and the idval
;      is zero on return.
;
;      (wa)		     buffer size in characters
;      jsr  alobf	     call to create buffer
;      (xr)		     bcblk ptr
;      (wa,wb)		     destroyed
;
alobf	prc	e,0			; entry point
	bgt	wa,kvmxl,alb01		; check for maxlngth exceeded
	mov	wb,wa			; hang onto allocation size
	ctb	wa,bfsi_		; get total block size
	add	wa,*bcsi_		; add in allocation for bcblk
	jsr	alloc			; allocate frame
	mov	(xr),=b_bct		; set type
	zer	idval(xr)		; no id yet
	zer	bclen(xr)		; no defined length
	mov	wa,xl			; save xl
	mov	xl,xr			; copy bcblk ptr
	add	xl,*bcsi_		; bias past partially built bcblk
	mov	(xl),=b_bft		; set bfblk type word
	mov	bfalc(xl),wb		; set allocated size
	mov	bcbuf(xr),xl		; set pointer in bcblk
	zer	bfchr(xl)		; clear first word (null pad)
	mov	xl,wa			; restore entry xl
	exi				; return to caller
;
;      here for mxlen exceeded
;
alb01	erb	273,buffer size exceeds value of maxlngth keyword
	enp				; end procedure alobf
	ejc
.fi
;
;      alocs -- allocate string block
;
;      alocs is used to build a frame for a string block into
;      which the actual characters are placed by the caller.
;      all strings are created with a call to alocs (the
;      exceptions occur in trimr and s_rpl procedures).
;
;      (wa)		     length of string to be allocated
;      jsr  alocs	     call to allocate scblk
;      (xr)		     pointer to resulting scblk
;      (wa)		     destroyed
;      (wc)		     character count (entry value of wa)
;
;      the resulting scblk has the type word and the length
;      filled in and the last word is cleared to zero characters
;      to ensure correct right padding of the final word.
;
alocs	prc	e,0			; entry point
	bgt	wa,kvmxl,alcs2		; jump if length exceeds maxlength
	mov	wc,wa			; else copy length
	ctb	wa,scsi_		; compute length of scblk in bytes
	mov	xr,dnamp		; point to next available location
	aov	wa,xr,alcs0		; point past block
	blo	xr,dname,alcs1		; jump if there is room
;
;      insufficient memory
;
alcs0	zer	xr			; else clear garbage xr value
	jsr	alloc			; and use standard allocator
	add	xr,wa			; point past end of block to merge
;
;      merge here with xr pointing beyond new block
;
alcs1	mov	dnamp,xr		; set updated storage pointer
	zer	-(xr)			; store zero chars in last word
	dca	wa			; decrement length
	sub	xr,wa			; point back to start of block
	mov	(xr),=b_scl		; set type word
	mov	sclen(xr),wc		; store length in chars
	exi				; return to alocs caller
;
;      come here if string is too long
;
alcs2	erb	205,string length exceeds value of maxlngth keyword
	enp				; end procedure alocs
	ejc
;
;      alost -- allocate space in static region
;
;      (wa)		     length required in bytes
;      jsr  alost	     call to allocate space
;      (xr)		     pointer to allocated block
;      (wb)		     destroyed
;
;      note that the coding ensures that the resulting value
;      of state is always less than dnamb. this fact is used
;      in testing a variable name for being in the static region
;
alost	prc	e,0			; entry point
;
;      merge back here after allocating new chunk
;
alst1	mov	xr,state		; point to current end of area
	aov	wa,xr,alst2		; point beyond proposed block
	bge	xr,dnamb,alst2		; jump if overlap with dynamic area
	mov	state,xr		; else store new pointer
	sub	xr,wa			; point back to start of block
	exi				; return to alost caller
;
;      here if no room, prepare to move dynamic storage up
;
alst2	mov	alsta,wa		; save wa
	bge	wa,*e_sts,alst3		; skip if requested chunk is large
	mov	wa,*e_sts		; else set to get large enough chunk
;
;      here with amount to move up in wa
;
alst3	jsr	alloc			; allocate block to ensure room
	mov	dnamp,xr		; and delete it
	mov	wb,wa			; copy move up amount
	jsr	gbcol			; call gbcol to move dynamic area up
.if    .csed
	mov	dnams,xr		; remember new sediment size
.fi
	mov	wa,alsta		; restore wa
	brn	alst1			; loop back to try again
	enp				; end procedure alost
	ejc
.if    .cnbf
.else
;
;      apndb -- append string to buffer
;
;      this routine is used by buffer handling routines to
;      append data to an existing bfblk.
;
;      (xr)		     existing bcblk to be appended
;      (xl)		     convertable to string
;      jsr  apndb	     call to append to buffer
;      ppm  loc		     thread if (xl) cant be converted
;      ppm  loc		     if not enough room
;      (wa,wb)		     destroyed
;
;      if more characters are specified than can be inserted,
;      then no action is taken and the second return is taken.
;
apndb	prc	e,2			; entry point
	mov	wa,bclen(xr)		; load offset to insert
	zer	wb			; replace section is null
	jsr	insbf			; call to insert at end
	ppm	apn01			; convert error
	ppm	apn02			; no room
	exi				; return to caller
;
;      here to take convert failure exit
;
apn01	exi	1			; return to caller alternate
;
;      here for no fit exit
;
apn02	exi	2			; alternate exit to caller
	enp				; end procedure apndb
	ejc
.fi
;
;      arith -- fetch arithmetic operands
;
;      arith is used by functions and operators which expect
;      two numeric arguments (operands) which must both be
;      integer or both be real. arith fetches two arguments from
;      the stack and performs any necessary conversions.
;
;      1(xs)		     first argument (left operand)
;      0(xs)		     second argument (right operand)
;      jsr  arith	     call to fetch numeric arguments
;      ppm  loc		     transfer loc for opnd 1 non-numeric
;      ppm  loc		     transfer loc for opnd 2 non-numeric
.if    .cnra
.else
;      ppm  loc		     transfer loc for real operands
.fi
;
;      for integer args, control returns past the parameters
;
;      (ia)		     left operand value
;      (xr)		     ptr to icblk for left operand
;      (xl)		     ptr to icblk for right operand
;      (xs)		     popped twice
;      (wa,wb,ra)	     destroyed
.if    .cnra
.else
;
;      for real arguments, control returns to the location
;      specified by the third parameter.
;
;      (ra)		     left operand value
;      (xr)		     ptr to rcblk for left operand
;      (xl)		     ptr to rcblk for right operand
;      (wa,wb,wc)	     destroyed
;      (xs)		     popped twice
.fi
	ejc
;
;      arith (continued)
;
;      entry point
;
.if    .cnra
arith	prc	n,2			; entry point
.else
arith	prc	n,3			; entry point
.fi
	mov	xl,(xs)+		; load right operand
	mov	xr,(xs)+		; load left operand
	mov	wa,(xl)			; get right operand type word
	beq	wa,=b_icl,arth1		; jump if integer
.if    .cnra
.else
	beq	wa,=b_rcl,arth4		; jump if real
.fi
	mov	-(xs),xr		; else replace left arg on stack
	mov	xr,xl			; copy left arg pointer
	jsr	gtnum			; convert to numeric
	ppm	arth6			; jump if unconvertible
	mov	xl,xr			; else copy converted result
	mov	wa,(xl)			; get right operand type word
	mov	xr,(xs)+		; reload left argument
.if    .cnra
.else
	beq	wa,=b_rcl,arth4		; jump if right arg is real
.fi
;
;      here if right arg is an integer
;
arth1	bne	(xr),=b_icl,arth3	; jump if left arg not integer
;
;      exit for integer case
;
arth2	ldi	icval(xr)		; load left operand value
	exi				; return to arith caller
;
;      here for right operand integer, left operand not
;
arth3	jsr	gtnum			; convert left arg to numeric
	ppm	arth7			; jump if not convertible
	beq	wa,=b_icl,arth2		; jump back if integer-integer
.if    .cnra
.else
;
;      here we must convert real-integer to real-real
;
	mov	-(xs),xr		; put left arg back on stack
	ldi	icval(xl)		; load right argument value
	itr				; convert to real
	jsr	rcbld			; get real block for right arg, merge
	mov	xl,xr			; copy right arg ptr
	mov	xr,(xs)+		; load left argument
	brn	arth5			; merge for real-real case
	ejc
;
;      arith (continued)
;
;      here if right argument is real
;
arth4	beq	(xr),=b_rcl,arth5	; jump if left arg real
	jsr	gtrea			; else convert to real
	ppm	arth7			; error if unconvertible
;
;      here for real-real
;
arth5	ldr	rcval(xr)		; load left operand value
	exi	3			; take real-real exit
.fi
;
;      here for error converting right argument
;
arth6	ica	xs			; pop unwanted left arg
	exi	2			; take appropriate error exit
;
;      here for error converting left operand
;
arth7	exi	1			; take appropriate error return
	enp				; end procedure arith
	ejc
;
;      asign -- perform assignment
;
;      asign performs the assignment of a value to a variable
;      with appropriate checks for output associations and
;      value trace associations which are executed as required.
;      asign also handles the special cases of assignment to
;      pattern and expression variables.
;
;      (wb)		     value to be assigned
;      (xl)		     base pointer for variable
;      (wa)		     offset for variable
;      jsr  asign	     call to assign value to variable
;      ppm  loc		     transfer loc for failure
;      (xr,xl,wa,wb,wc)	     destroyed
;      (ra)		     destroyed
;
;      failure occurs if the evaluation of an expression
;      associated with an expression variable fails.
;
asign	prc	r,1			; entry point (recursive)
;
;      merge back here to assign result to expression variable.
;
asg01	add	xl,wa			; point to variable value
	mov	xr,(xl)			; load variable value
	beq	(xr),=b_trt,asg02	; jump if trapped
	mov	(xl),wb			; else perform assignment
	zer	xl			; clear garbage value in xl
	exi				; and return to asign caller
;
;      here if value is trapped
;
asg02	sub	xl,wa			; restore name base
	beq	xr,=trbkv,asg14		; jump if keyword variable
	bne	xr,=trbev,asg04		; jump if not expression variable
;
;      here for assignment to expression variable
;
	mov	xr,evexp(xl)		; point to expression
	mov	-(xs),wb		; store value to assign on stack
	mov	wb,=num01		; set for evaluation by name
	jsr	evalx			; evaluate expression by name
	ppm	asg03			; jump if evaluation fails
	mov	wb,(xs)+		; else reload value to assign
	brn	asg01			; loop back to perform assignment
	ejc
;
;      asign (continued)
;
;      here for failure during expression evaluation
;
asg03	ica	xs			; remove stacked value entry
	exi	1			; take failure exit
;
;      here if not keyword or expression variable
;
asg04	mov	-(xs),xr		; save ptr to first trblk
;
;      loop to chase down trblk chain and assign value at end
;
asg05	mov	wc,xr			; save ptr to this trblk
	mov	xr,trnxt(xr)		; point to next trblk
	beq	(xr),=b_trt,asg05	; loop back if another trblk
	mov	xr,wc			; else point back to last trblk
	mov	trval(xr),wb		; store value at end of chain
	mov	xr,(xs)+		; restore ptr to first trblk
;
;      loop to process trblk entries on chain
;
asg06	mov	wb,trtyp(xr)		; load type code of trblk
	beq	wb,=trtvl,asg08		; jump if value trace
	beq	wb,=trtou,asg10		; jump if output association
;
;      here to move to next trblk on chain
;
asg07	mov	xr,trnxt(xr)		; point to next trblk on chain
	beq	(xr),=b_trt,asg06	; loop back if another trblk
	exi				; else end of chain, return to caller
;
;      here to process value trace
;
asg08	bze	kvtra,asg07		; ignore value trace if trace off
	dcv	kvtra			; else decrement trace count
	bze	trfnc(xr),asg09		; jump if print trace
	jsr	trxeq			; else execute function trace
	brn	asg07			; and loop back
	ejc
;
;      asign (continued)
;
;      here for print trace
;
asg09	jsr	prtsn			; print statement number
	jsr	prtnv			; print name = value
	brn	asg07			; loop back for next trblk
;
;      here for output association
;
asg10	bze	kvoup,asg07		; ignore output assoc if output off
asg1b	mov	xl,xr			; copy trblk pointer
	mov	xr,trnxt(xr)		; point to next trblk
	beq	(xr),=b_trt,asg1b	; loop back if another trblk
	mov	xr,xl			; else point back to last trblk
.if    .cnbf
	mov	-(xs),trval(xr)		; stack value to output
.else
	mov	xr,trval(xr)		; get value to output
	beq	(xr),=b_bct,asg11	; branch if buffer
	mov	-(xs),xr		; stack value to output
.fi
	jsr	gtstg			; convert to string
	ppm	asg12			; get datatype name if unconvertible
;
;      merge with string or buffer to output in xr
;
asg11	mov	wa,trfpt(xl)		; fcblk ptr
	bze	wa,asg13		; jump if standard output file
;
;      here for output to file
;
asg1a	jsr	sysou			; call system output routine
	err	206,output caused file overflow
	err	207,output caused non-recoverable error
	exi				; else all done, return to caller
;
;      if not printable, get datatype name instead
;
asg12	jsr	dtype			; call datatype routine
	brn	asg11			; merge
;
;      here to print a string to standard output or terminal
;
.if    .csou
asg13	beq	trter(xl),=v_ter,asg1a	; jump if terminal output
	icv	wa			; signal standard output
	brn	asg1a			; use sysou to perform output
.else
.if    .cnbf
asg13	jsr	prtst			; print string value
.else
asg13	bne	(xr),=b_bct,asg1c	; branch if not buffer
	mov	-(xs),xr		; stack buffer
	jsr	gtstg			; convert to string
	ppm				; always succeeds
asg1c	jsr	prtst			; print string value
.fi
	beq	trter(xl),=v_ter,asg20	; jump if terminal output
	jsr	prtnl			; end of line
	exi				; return to caller
.fi
	ejc
;
;      asign (continued)
;
;      here for keyword assignment
;
asg14	mov	xl,kvnum(xl)		; load keyword number
	beq	xl,=k_etx,asg19		; jump if errtext
	mov	xr,wb			; copy value to be assigned
	jsr	gtint			; convert to integer
	err	208,keyword value assigned is not integer
	ldi	icval(xr)		; else load value
	beq	xl,=k_stl,asg16		; jump if special case of stlimit
	mfi	wa,asg18		; else get addr integer, test ovflow
	bgt	wa,mxlen,asg18		; fail if too large
	beq	xl,=k_ert,asg17		; jump if special case of errtype
.if    .cnpf
.else
	beq	xl,=k_pfl,asg21		; jump if special case of profile
.fi
	beq	xl,=k_mxl,asg24		; jump if special case of maxlngth
	beq	xl,=k_fls,asg26		; jump if special case of fullscan
	blt	xl,=k_p__,asg15		; jump unless protected
	erb	209,keyword in assignment is protected
;
;      here to do assignment if not protected
;
asg15	mov	kvabe(xl),wa		; store new value
	exi				; return to asign caller
;
;      here for special case of stlimit
;
;      since stcount is maintained as (stlimit-stcount)
;      it is also necessary to modify stcount appropriately.
;
asg16	sbi	kvstl			; subtract old limit
	adi	kvstc			; add old counter
	sti	kvstc			; store course counter value
	ldi	kvstl			; check if counting suppressed
	ilt	asg25			; do not refine if so
	mov	wa,stmcs		; refine with counter breakout
	sub	wa,stmct		; values
	mti	wa			; convert to integer
	ngi				; current-start value
	adi	kvstc			; add in course counter value
	sti	kvstc			; save refined value
asg25	ldi	icval(xr)		; reload new limit value
	sti	kvstl			; store new limit value
	jsr	stgcc			; recompute countdown counters
	exi				; return to asign caller
;
;      here for special case of errtype
;
asg17	ble	wa,=nini9,error		; ok to signal if in range
;
;      here if value assigned is out of range
;
asg18	erb	210,keyword value assigned is negative or too large
;
;      here for special case of errtext
;
asg19	mov	-(xs),wb		; stack value
	jsr	gtstg			; convert to string
	err	211,value assigned to keyword errtext not a string
	mov	r_etx,xr		; make assignment
	exi				; return to caller
.if    .csou
.else
;
;      print string to terminal
;
asg20	jsr	prttr			; print
	exi				; return
.fi
;
.if    .cnpf
.else
;      here for keyword profile
;
asg21	bgt	wa,=num02,asg18		; moan if not 0,1, or 2
	bze	wa,asg15		; just assign if zero
	bze	pfdmp,asg22		; branch if first assignment
	beq	wa,pfdmp,asg23		; also if same value as before
	erb	268,inconsistent value assigned to keyword profile
;
asg22	mov	pfdmp,wa		; note value on first assignment
asg23	mov	kvpfl,wa		; store new value
	jsr	stgcc			; recompute countdown counts
	jsr	systm			; get the time
	sti	pfstm			; fudge some kind of start time
	exi				; return to asign caller
.fi
;
;      here for keyword maxlngth
;
asg24	bge	wa,=mnlen,asg15		; if acceptable value
	erb	287,value assigned to keyword maxlngth is too small
;
;      here for keyword fullscan
;
asg26	bnz	wa,asg15		; if acceptable value
	erb	274,value assigned to keyword fullscan is zero
;
	enp				; end procedure asign
	ejc
;
;      asinp -- assign during pattern match
;
;      asinp is like asign and has a similar calling sequence
;      and effect. the difference is that the global pattern
;      variables are saved and restored if required.
;
;      (xl)		     base pointer for variable
;      (wa)		     offset for variable
;      (wb)		     value to be assigned
;      jsr  asinp	     call to assign value to variable
;      ppm  loc		     transfer loc if failure
;      (xr,xl)		     destroyed
;      (wa,wb,wc,ra)	     destroyed
;
asinp	prc	r,1			; entry point, recursive
	add	xl,wa			; point to variable
	mov	xr,(xl)			; load current contents
	beq	(xr),=b_trt,asnp1	; jump if trapped
	mov	(xl),wb			; else perform assignment
	zer	xl			; clear garbage value in xl
	exi				; return to asinp caller
;
;      here if variable is trapped
;
asnp1	sub	xl,wa			; restore base pointer
	mov	-(xs),pmssl		; stack subject string length
	mov	-(xs),pmhbs		; stack history stack base ptr
	mov	-(xs),r_pms		; stack subject string pointer
	mov	-(xs),pmdfl		; stack dot flag
	jsr	asign			; call full-blown assignment routine
	ppm	asnp2			; jump if failure
	mov	pmdfl,(xs)+		; restore dot flag
	mov	r_pms,(xs)+		; restore subject string pointer
	mov	pmhbs,(xs)+		; restore history stack base pointer
	mov	pmssl,(xs)+		; restore subject string length
	exi				; return to asinp caller
;
;      here if failure in asign call
;
asnp2	mov	pmdfl,(xs)+		; restore dot flag
	mov	r_pms,(xs)+		; restore subject string pointer
	mov	pmhbs,(xs)+		; restore history stack base pointer
	mov	pmssl,(xs)+		; restore subject string length
	exi	1			; take failure exit
	enp				; end procedure asinp
	ejc
;
;      blkln -- determine length of block
;
;      blkln determines the length of a block in dynamic store.
;
;      (wa)		     first word of block
;      (xr)		     pointer to block
;      jsr  blkln	     call to get block length
;      (wa)		     length of block in bytes
;      (xl)		     destroyed
;
;      blkln is used by the garbage collector and is not
;      permitted to call gbcol directly or indirectly.
;
;      the first word stored in the block (i.e. at xr) may
;      be anything, but the contents of wa must be correct.
;
blkln	prc	e,0			; entry point
	mov	xl,wa			; copy first word
	lei	xl			; get entry id (bl_xx)
	bsw	xl,bl___,bln00		; switch on block type
	iff	bl_ar,bln01		; arblk
.if    .cnbf
.else
	iff	bl_bc,bln04		; bcblk
	iff	bl_bf,bln11		; bfblk
.fi
.if    .csln
	iff	bl_cd,bln12		; cdblk
.else
	iff	bl_cd,bln01		; cdblk
.fi
	iff	bl_df,bln01		; dfblk
	iff	bl_ef,bln01		; efblk
.if    .csln
	iff	bl_ex,bln12		; exblk
.else
	iff	bl_ex,bln01		; exblk
.fi
	iff	bl_pf,bln01		; pfblk
	iff	bl_tb,bln01		; tbblk
	iff	bl_vc,bln01		; vcblk
	iff	bl_ev,bln03		; evblk
	iff	bl_kv,bln03		; kvblk
	iff	bl_p0,bln02		; p0blk
	iff	bl_se,bln02		; seblk
	iff	bl_nm,bln03		; nmblk
	iff	bl_p1,bln03		; p1blk
	iff	bl_p2,bln04		; p2blk
	iff	bl_te,bln04		; teblk
	iff	bl_ff,bln05		; ffblk
	iff	bl_tr,bln05		; trblk
	iff	bl_ct,bln06		; ctblk
	iff	bl_ic,bln07		; icblk
	iff	bl_pd,bln08		; pdblk
.if    .cnra
.else
	iff	bl_rc,bln09		; rcblk
.fi
	iff	bl_sc,bln10		; scblk
	esw				; end of jump table on block type
	ejc
;
;      blkln (continued)
;
;      here for blocks with length in second word
;
bln00	mov	wa,num01(xr)		; load length
	exi				; return to blkln caller
;
;      here for length in third word (ar,cd,df,ef,ex,pf,tb,vc)
;
bln01	mov	wa,num02(xr)		; load length from third word
	exi				; return to blkln caller
;
;      here for two word blocks (p0,se)
;
bln02	mov	wa,*num02		; load length (two words)
	exi				; return to blkln caller
;
;      here for three word blocks (nm,p1,ev,kv)
;
bln03	mov	wa,*num03		; load length (three words)
	exi				; return to blkln caller
;
;      here for four word blocks (p2,te,bc)
;
bln04	mov	wa,*num04		; load length (four words)
	exi				; return to blkln caller
;
;      here for five word blocks (ff,tr)
;
bln05	mov	wa,*num05		; load length
	exi				; return to blkln caller
	ejc
;
;      blkln (continued)
;
;      here for ctblk
;
bln06	mov	wa,*ctsi_		; set size of ctblk
	exi				; return to blkln caller
;
;      here for icblk
;
bln07	mov	wa,*icsi_		; set size of icblk
	exi				; return to blkln caller
;
;      here for pdblk
;
bln08	mov	xl,pddfp(xr)		; point to dfblk
	mov	wa,dfpdl(xl)		; load pdblk length from dfblk
	exi				; return to blkln caller
.if    .cnra
.else
;
;      here for rcblk
;
bln09	mov	wa,*rcsi_		; set size of rcblk
	exi				; return to blkln caller
.fi
;
;      here for scblk
;
bln10	mov	wa,sclen(xr)		; load length in characters
	ctb	wa,scsi_		; calculate length in bytes
	exi				; return to blkln caller
.if    .cnbf
.else
;
;      here for bfblk
;
bln11	mov	wa,bfalc(xr)		; get allocation in bytes
	ctb	wa,bfsi_		; calculate length in bytes
	exi				; return to blkln caller
.fi
.if    .csln
;
;      here for length in fourth word (cd,ex)
;
bln12	mov	wa,num03(xr)		; load length from cdlen/exlen
	exi				; return to blkln caller
.fi
	enp				; end procedure blkln
	ejc
;
;      copyb -- copy a block
;
;      (xs)		     block to be copied
;      jsr  copyb	     call to copy block
;      ppm  loc		     return if block has no idval field
;			     normal return if idval field
;      (xr)		     copy of block
;      (xs)		     popped
;      (xl,wa,wb,wc)	     destroyed
;
copyb	prc	n,1			; entry point
	mov	xr,(xs)			; load argument
	beq	xr,=nulls,cop10		; return argument if it is null
	mov	wa,(xr)			; else load type word
	mov	wb,wa			; copy type word
	jsr	blkln			; get length of argument block
	mov	xl,xr			; copy pointer
	jsr	alloc			; allocate block of same size
	mov	(xs),xr			; store pointer to copy
	mvw				; copy contents of old block to new
	zer	xl			; clear garbage xl
	mov	xr,(xs)			; reload pointer to start of copy
	beq	wb,=b_tbt,cop05		; jump if table
	beq	wb,=b_vct,cop01		; jump if vector
	beq	wb,=b_pdt,cop01		; jump if program defined
.if    .cnbf
.else
	beq	wb,=b_bct,cop11		; jump if buffer
.fi
	bne	wb,=b_art,cop10		; return copy if not array
;
;      here for array (arblk)
;
	add	xr,arofs(xr)		; point to prototype field
	brn	cop02			; jump to merge
;
;      here for vector, program defined
;
cop01	add	xr,*pdfld		; point to pdfld = vcvls
;
;      merge here for arblk, vcblk, pdblk to delete trap
;      blocks from all value fields (the copy is untrapped)
;
cop02	mov	xl,(xr)			; load next pointer
;
;      loop to get value at end of trblk chain
;
cop03	bne	(xl),=b_trt,cop04	; jump if not trapped
	mov	xl,trval(xl)		; else point to next value
	brn	cop03			; and loop back
	ejc
;
;      copyb (continued)
;
;      here with untrapped value in xl
;
cop04	mov	(xr)+,xl		; store real value, bump pointer
	bne	xr,dnamp,cop02		; loop back if more to go
	brn	cop09			; else jump to exit
;
;      here to copy a table
;
cop05	zer	idval(xr)		; zero id to stop dump blowing up
	mov	wa,*tesi_		; set size of teblk
	mov	wc,*tbbuk		; set initial offset
;
;      loop through buckets in table
;
cop06	mov	xr,(xs)			; load table pointer
	beq	wc,tblen(xr),cop09	; jump to exit if all done
	mov	wb,wc			; else copy offset
	sub	wb,*tenxt		; subtract link offset to merge
	add	xr,wb			; next bucket header less link offset
	ica	wc			; bump offset
;
;      loop through teblks on one chain
;
cop07	mov	xl,tenxt(xr)		; load pointer to next teblk
	mov	tenxt(xr),(xs)		; set end of chain pointer in case
	beq	(xl),=b_tbt,cop06	; back for next bucket if chain end
	sub	xr,wb			; point to head of previous block
	mov	-(xs),xr		; stack ptr to previous block
	mov	wa,*tesi_		; set size of teblk
	jsr	alloc			; allocate new teblk
	mov	-(xs),xr		; stack ptr to new teblk
	mvw				; copy old teblk to new teblk
	mov	xr,(xs)+		; restore pointer to new teblk
	mov	xl,(xs)+		; restore pointer to previous block
	add	xl,wb			; add offset back in
	mov	tenxt(xl),xr		; link new block to previous
	mov	xl,xr			; copy pointer to new block
;
;      loop to set real value after removing trap chain
;
cop08	mov	xl,teval(xl)		; load value
	beq	(xl),=b_trt,cop08	; loop back if trapped
	mov	teval(xr),xl		; store untrapped value in teblk
	zer	wb			; zero offset within teblk
	brn	cop07			; back for next teblk
;
;      common exit point
;
cop09	mov	xr,(xs)+		; load pointer to block
	exi				; return
;
;      alternative return
;
cop10	exi	1			; return
	ejc
.if    .cnbf
.else
;
;      here to copy buffer
;
cop11	mov	xl,bcbuf(xr)		; get bfblk ptr
	mov	wa,bfalc(xl)		; get allocation
	ctb	wa,bfsi_		; set total size
	mov	xl,xr			; save bcblk ptr
	jsr	alloc			; allocate bfblk
	mov	wb,bcbuf(xl)		; get old bfblk
	mov	bcbuf(xl),xr		; set pointer to new bfblk
	mov	xl,wb			; point to old bfblk
	mvw				; copy bfblk too
	zer	xl			; clear rubbish ptr
	brn	cop09			; branch to exit
.fi
	enp				; end procedure copyb
;
;      cdgcg -- generate code for complex goto
;
;      used by cmpil to process complex goto tree
;
;      (wb)		     must be collectable
;      (xr)		     expression pointer
;      jsr  cdgcg	     call to generate complex goto
;      (xl,xr,wa)	     destroyed
;
cdgcg	prc	e,0			; entry point
	mov	xl,cmopn(xr)		; get unary goto operator
	mov	xr,cmrop(xr)		; point to goto operand
	beq	xl,=opdvd,cdgc2		; jump if direct goto
	jsr	cdgnm			; generate opnd by name if not direct
;
;      return point
;
cdgc1	mov	wa,xl			; goto operator
	jsr	cdwrd			; generate it
	exi				; return to caller
;
;      direct goto
;
cdgc2	jsr	cdgvl			; generate operand by value
	brn	cdgc1			; merge to return
	enp				; end procedure cdgcg
	ejc
;
;      cdgex -- build expression block
;
;      cdgex is passed a pointer to an expression tree (see
;      expan) and returns an expression (seblk or exblk).
;
.if    .cevb
;      (wa)		     0 if by value, 1 if by name
.fi
;      (wc)		     some collectable value
;      (wb)		     integer in range 0 le x le mxlen
;      (xl)		     ptr to expression tree
;      jsr  cdgex	     call to build expression
;      (xr)		     ptr to seblk or exblk
;      (xl,wa,wb)	     destroyed
;
cdgex	prc	r,0			; entry point, recursive
	blo	(xl),=b_vr_,cdgx1	; jump if not variable
;
;      here for natural variable, build seblk
;
	mov	wa,*sesi_		; set size of seblk
	jsr	alloc			; allocate space for seblk
	mov	(xr),=b_sel		; set type word
	mov	sevar(xr),xl		; store vrblk pointer
	exi				; return to cdgex caller
;
;      here if not variable, build exblk
;
cdgx1	mov	xr,xl			; copy tree pointer
	mov	-(xs),wc		; save wc
	mov	xl,cwcof		; save current offset
.if    .cevb
	bze	wa,cdgx2		; jump if by value
.fi
	mov	wa,(xr)			; get type word
	bne	wa,=b_cmt,cdgx2		; call by value if not cmblk
	bge	cmtyp(xr),=c__nm,cdgx2	; jump if cmblk only by value
	ejc
;
;      cdgex (continued)
;
;      here if expression can be evaluated by name
;
	jsr	cdgnm			; generate code by name
	mov	wa,=ornm_		; load return by name word
	brn	cdgx3			; merge with value case
;
;      here if expression can only be evaluated by value
;
cdgx2	jsr	cdgvl			; generate code by value
	mov	wa,=orvl_		; load return by value word
;
;      merge here to construct exblk
;
cdgx3	jsr	cdwrd			; generate return word
	jsr	exbld			; build exblk
	mov	wc,(xs)+		; restore wc
	exi				; return to cdgex caller
	enp				; end procedure cdgex
	ejc
;
;      cdgnm -- generate code by name
;
;      cdgnm is called during the compilation process to
;      generate code by name for an expression. see cdblk
;      description for details of code generated. the input
;      to cdgnm is an expression tree as generated by expan.
;
;      cdgnm is a recursive procedure which proceeds by making
;      recursive calls to generate code for operands.
;
;      (wb)		     integer in range 0 le n le dnamb
;      (xr)		     ptr to tree generated by expan
;      (wc)		     constant flag (see below)
;      jsr  cdgnm	     call to generate code by name
;      (xr,wa)		     destroyed
;      (wc)		     set non-zero if non-constant
;
;      wc is set to a non-zero (collectable) value if the
;      expression for which code is generated cannot be
;      evaluated at compile time, otherwise wc is unchanged.
;
;      the code is generated in the current ccblk (see cdwrd).
;
cdgnm	prc	r,0			; entry point, recursive
	mov	-(xs),xl		; save entry xl
	mov	-(xs),wb		; save entry wb
	chk				; check for stack overflow
	mov	wa,(xr)			; load type word
	beq	wa,=b_cmt,cgn04		; jump if cmblk
	bhi	wa,=b_vr_,cgn02		; jump if simple variable
;
;      merge here for operand yielding value (e.g. constant)
;
cgn01	erb	212,syntax error: value used where name is required
;
;      here for natural variable reference
;
cgn02	mov	wa,=olvn_		; load variable load call
	jsr	cdwrd			; generate it
	mov	wa,xr			; copy vrblk pointer
	jsr	cdwrd			; generate vrblk pointer
	ejc
;
;      cdgnm (continued)
;
;      here to exit with wc set correctly
;
cgn03	mov	wb,(xs)+		; restore entry wb
	mov	xl,(xs)+		; restore entry xl
	exi				; return to cdgnm caller
;
;      here for cmblk
;
cgn04	mov	xl,xr			; copy cmblk pointer
	mov	xr,cmtyp(xr)		; load cmblk type
	bge	xr,=c__nm,cgn01		; error if not name operand
	bsw	xr,c__nm		; else switch on type
	iff	c_arr,cgn05		; array reference
	iff	c_fnc,cgn08		; function call
	iff	c_def,cgn09		; deferred expression
	iff	c_ind,cgn10		; indirect reference
	iff	c_key,cgn11		; keyword reference
	iff	c_ubo,cgn08		; undefined binary op
	iff	c_uuo,cgn08		; undefined unary op
	esw				; end switch on cmblk type
;
;      here to generate code for array reference
;
cgn05	mov	wb,*cmopn		; point to array operand
;
;      loop to generate code for array operand and subscripts
;
cgn06	jsr	cmgen			; generate code for next operand
	mov	wc,cmlen(xl)		; load length of cmblk
	blt	wb,wc,cgn06		; loop till all generated
;
;      generate appropriate array call
;
	mov	wa,=oaon_		; load one-subscript case call
	beq	wc,*cmar1,cgn07		; jump to exit if one subscript case
	mov	wa,=oamn_		; else load multi-subscript case call
	jsr	cdwrd			; generate call
	mov	wa,wc			; copy cmblk length
	btw	wa			; convert to words
	sub	wa,=cmvls		; calculate number of subscripts
	ejc
;
;      cdgnm (continued)
;
;      here to exit generating word (non-constant)
;
cgn07	mnz	wc			; set result non-constant
	jsr	cdwrd			; generate word
	brn	cgn03			; back to exit
;
;      here to generate code for functions and undefined oprs
;
cgn08	mov	xr,xl			; copy cmblk pointer
	jsr	cdgvl			; gen code by value for call
	mov	wa,=ofne_		; get extra call for by name
	brn	cgn07			; back to generate and exit
;
;      here to generate code for defered expression
;
cgn09	mov	xr,cmrop(xl)		; check if variable
	bhi	(xr),=b_vr_,cgn02	; treat *variable as simple var
	mov	xl,xr			; copy ptr to expression tree
.if    .cevb
	mov	wa,=num01		; return name
.fi
	jsr	cdgex			; else build exblk
	mov	wa,=olex_		; set call to load expr by name
	jsr	cdwrd			; generate it
	mov	wa,xr			; copy exblk pointer
	jsr	cdwrd			; generate exblk pointer
	brn	cgn03			; back to exit
;
;      here to generate code for indirect reference
;
cgn10	mov	xr,cmrop(xl)		; get operand
	jsr	cdgvl			; generate code by value for it
	mov	wa,=oinn_		; load call for indirect by name
	brn	cgn12			; merge
;
;      here to generate code for keyword reference
;
cgn11	mov	xr,cmrop(xl)		; get operand
	jsr	cdgnm			; generate code by name for it
	mov	wa,=okwn_		; load call for keyword by name
;
;      keyword, indirect merge here
;
cgn12	jsr	cdwrd			; generate code for operator
	brn	cgn03			; exit
	enp				; end procedure cdgnm
	ejc
;
;      cdgvl -- generate code by value
;
;      cdgvl is called during the compilation process to
;      generate code by value for an expression. see cdblk
;      description for details of the code generated. the input
;      to cdgvl is an expression tree as generated by expan.
;
;      cdgvl is a recursive procedure which proceeds by making
;      recursive calls to generate code for operands.
;
;      (wb)		     integer in range 0 le n le dnamb
;      (xr)		     ptr to tree generated by expan
;      (wc)		     constant flag (see below)
;      jsr  cdgvl	     call to generate code by value
;      (xr,wa)		     destroyed
;      (wc)		     set non-zero if non-constant
;
;      wc is set to a non-zero (collectable) value if the
;      expression for which code is generated cannot be
;      evaluated at compile time, otherwise wc is unchanged.
;
;      if wc is non-zero on entry, then preevaluation is not
;      allowed regardless of the nature of the operand.
;
;      the code is generated in the current ccblk (see cdwrd).
;
cdgvl	prc	r,0			; entry point, recursive
	mov	wa,(xr)			; load type word
	beq	wa,=b_cmt,cgv01		; jump if cmblk
	blt	wa,=b_vra,cgv00		; jump if icblk, rcblk, scblk
	bnz	vrlen(xr),cgvl0		; jump if not system variable
	mov	-(xs),xr		; stack xr
	mov	xr,vrsvp(xr)		; point to svblk
	mov	wa,svbit(xr)		; get svblk property bits
	mov	xr,(xs)+		; recover xr
	anb	wa,btkwv		; check if constant keyword value
	beq	wa,btkwv,cgv00		; jump if constant keyword value
;
;      here for variable value reference
;
cgvl0	mnz	wc			; indicate non-constant value
;
;      merge here for simple constant (icblk,rcblk,scblk)
;      and for variables corresponding to constant keywords.
;
cgv00	mov	wa,xr			; copy ptr to var or constant
	jsr	cdwrd			; generate as code word
	exi				; return to caller
	ejc
;
;      cdgvl (continued)
;
;      here for tree node (cmblk)
;
cgv01	mov	-(xs),wb		; save entry wb
	mov	-(xs),xl		; save entry xl
	mov	-(xs),wc		; save entry constant flag
	mov	-(xs),cwcof		; save initial code offset
	chk				; check for stack overflow
;
;      prepare to generate code for cmblk. wc is set to the
;      value of cswno (zero if -optimise, 1 if -noopt) to
;      start with and is reset non-zero for any non-constant
;      code generated. if it is still zero after generating all
;      the cmblk code, then its value is computed as the result.
;
	mov	xl,xr			; copy cmblk pointer
	mov	xr,cmtyp(xr)		; load cmblk type
	mov	wc,cswno		; reset constant flag
	ble	xr,=c_pr_,cgv02		; jump if not predicate value
	mnz	wc			; else force non-constant case
;
;      here with wc set appropriately
;
cgv02	bsw	xr,c__nv		; switch to appropriate generator
	iff	c_arr,cgv03		; array reference
	iff	c_fnc,cgv05		; function call
	iff	c_def,cgv14		; deferred expression
	iff	c_sel,cgv15		; selection
	iff	c_ind,cgv31		; indirect reference
	iff	c_key,cgv27		; keyword reference
	iff	c_ubo,cgv29		; undefined binop
	iff	c_uuo,cgv30		; undefined unop
	iff	c_bvl,cgv18		; binops with val opds
	iff	c_alt,cgv18		; alternation
	iff	c_uvl,cgv19		; unops with valu opnd
	iff	c_ass,cgv21		; assignment
	iff	c_cnc,cgv24		; concatenation
	iff	c_cnp,cgv24		; concatenation (not pattern match)
	iff	c_unm,cgv27		; unops with name opnd
	iff	c_bvn,cgv26		; binary _ and .
	iff	c_int,cgv31		; interrogation
	iff	c_neg,cgv28		; negation
	iff	c_pmt,cgv18		; pattern match
	esw				; end switch on cmblk type
	ejc
;
;      cdgvl (continued)
;
;      here to generate code for array reference
;
cgv03	mov	wb,*cmopn		; set offset to array operand
;
;      loop to generate code for array operand and subscripts
;
cgv04	jsr	cmgen			; gen value code for next operand
	mov	wc,cmlen(xl)		; load cmblk length
	blt	wb,wc,cgv04		; loop back if more to go
;
;      generate call to appropriate array reference routine
;
	mov	wa,=oaov_		; set one subscript call in case
	beq	wc,*cmar1,cgv32		; jump to exit if 1-sub case
	mov	wa,=oamv_		; else set call for multi-subscripts
	jsr	cdwrd			; generate call
	mov	wa,wc			; copy length of cmblk
	sub	wa,*cmvls		; subtract standard length
	btw	wa			; get number of words
	brn	cgv32			; jump to generate subscript count
;
;      here to generate code for function call
;
cgv05	mov	wb,*cmvls		; set offset to first argument
;
;      loop to generate code for arguments
;
cgv06	beq	wb,cmlen(xl),cgv07	; jump if all generated
	jsr	cmgen			; else gen value code for next arg
	brn	cgv06			; back to generate next argument
;
;      here to generate actual function call
;
cgv07	sub	wb,*cmvls		; get number of arg ptrs (bytes)
	btw	wb			; convert bytes to words
	mov	xr,cmopn(xl)		; load function vrblk pointer
	bnz	vrlen(xr),cgv12		; jump if not system function
	mov	xl,vrsvp(xr)		; load svblk ptr if system var
	mov	wa,svbit(xl)		; load bit mask
	anb	wa,btffc		; test for fast function call allowed
	zrb	wa,cgv12		; jump if not
	ejc
;
;      cdgvl (continued)
;
;      here if fast function call is allowed
;
	mov	wa,svbit(xl)		; reload bit indicators
	anb	wa,btpre		; test for preevaluation ok
	nzb	wa,cgv08		; jump if preevaluation permitted
	mnz	wc			; else set result non-constant
;
;      test for correct number of args for fast call
;
cgv08	mov	xl,vrfnc(xr)		; load ptr to svfnc field
	mov	wa,fargs(xl)		; load svnar field value
	beq	wa,wb,cgv11		; jump if argument count is correct
	bhi	wa,wb,cgv09		; jump if too few arguments given
;
;      here if too many arguments, prepare to generate o_pops
;
	sub	wb,wa			; get number of extra args
	lct	wb,wb			; set as count to control loop
	mov	wa,=opop_		; set pop call
	brn	cgv10			; jump to common loop
;
;      here if too few arguments, prepare to generate nulls
;
cgv09	sub	wa,wb			; get number of missing arguments
	lct	wb,wa			; load as count to control loop
	mov	wa,=nulls		; load ptr to null constant
;
;      loop to generate calls to fix argument count
;
cgv10	jsr	cdwrd			; generate one call
	bct	wb,cgv10		; loop till all generated
;
;      here after adjusting arg count as required
;
cgv11	mov	wa,xl			; copy pointer to svfnc field
	brn	cgv36			; jump to generate call
	ejc
;
;      cdgvl (continued)
;
;      come here if fast call is not permitted
;
cgv12	mov	wa,=ofns_		; set one arg call in case
	beq	wb,=num01,cgv13		; jump if one arg case
	mov	wa,=ofnc_		; else load call for more than 1 arg
	jsr	cdwrd			; generate it
	mov	wa,wb			; copy argument count
;
;      one arg case merges here
;
cgv13	jsr	cdwrd			; generate =o_fns or arg count
	mov	wa,xr			; copy vrblk pointer
	brn	cgv32			; jump to generate vrblk ptr
;
;      here for deferred expression
;
cgv14	mov	xl,cmrop(xl)		; point to expression tree
.if    .cevb
	zer	wa			; return value
.fi
	jsr	cdgex			; build exblk or seblk
	mov	wa,xr			; copy block ptr
	jsr	cdwrd			; generate ptr to exblk or seblk
	brn	cgv34			; jump to exit, constant test
;
;      here to generate code for selection
;
cgv15	zer	-(xs)			; zero ptr to chain of forward jumps
	zer	-(xs)			; zero ptr to prev o_slc forward ptr
	mov	wb,*cmvls		; point to first alternative
	mov	wa,=osla_		; set initial code word
;
;      0(xs)		     is the offset to the previous word
;			     which requires filling in with an
;			     offset to the following o_slc,o_sld
;
;      1(xs)		     is the head of a chain of offset
;			     pointers indicating those locations
;			     to be filled with offsets past
;			     the end of all the alternatives
;
cgv16	jsr	cdwrd			; generate o_slc (o_sla first time)
	mov	(xs),cwcof		; set current loc as ptr to fill in
	jsr	cdwrd			; generate garbage word there for now
	jsr	cmgen			; gen value code for alternative
	mov	wa,=oslb_		; load o_slb pointer
	jsr	cdwrd			; generate o_slb call
	mov	wa,num01(xs)		; load old chain ptr
	mov	num01(xs),cwcof		; set current loc as new chain head
	jsr	cdwrd			; generate forward chain link
	ejc
;
;      cdgvl (continued)
;
;      now to fill in the skip offset to o_slc,o_sld
;
	mov	xr,(xs)			; load offset to word to plug
	add	xr,r_ccb		; point to actual location to plug
	mov	(xr),cwcof		; plug proper offset in
	mov	wa,=oslc_		; load o_slc ptr for next alternative
	mov	xr,wb			; copy offset (destroy garbage xr)
	ica	xr			; bump extra time for test
	blt	xr,cmlen(xl),cgv16	; loop back if not last alternative
;
;      here to generate code for last alternative
;
	mov	wa,=osld_		; get header call
	jsr	cdwrd			; generate o_sld call
	jsr	cmgen			; generate code for last alternative
	ica	xs			; pop offset ptr
	mov	xr,(xs)+		; load chain ptr
;
;      loop to plug offsets past structure
;
cgv17	add	xr,r_ccb		; make next ptr absolute
	mov	wa,(xr)			; load forward ptr
	mov	(xr),cwcof		; plug required offset
	mov	xr,wa			; copy forward ptr
	bnz	wa,cgv17		; loop back if more to go
	brn	cgv33			; else jump to exit (not constant)
;
;      here for binary ops with value operands
;
cgv18	mov	xr,cmlop(xl)		; load left operand pointer
	jsr	cdgvl			; gen value code for left operand
;
;      here for unary ops with value operand (binops merge)
;
cgv19	mov	xr,cmrop(xl)		; load right (only) operand ptr
	jsr	cdgvl			; gen code by value
	ejc
;
;      cdgvl (continued)
;
;      merge here to generate operator call from cmopn field
;
cgv20	mov	wa,cmopn(xl)		; load operator call pointer
	brn	cgv36			; jump to generate it with cons test
;
;      here for assignment
;
cgv21	mov	xr,cmlop(xl)		; load left operand pointer
	blo	(xr),=b_vr_,cgv22	; jump if not variable
;
;      here for assignment to simple variable
;
	mov	xr,cmrop(xl)		; load right operand ptr
	jsr	cdgvl			; generate code by value
	mov	wa,cmlop(xl)		; reload left operand vrblk ptr
	add	wa,*vrsto		; point to vrsto field
	brn	cgv32			; jump to generate store ptr
;
;      here if not simple variable assignment
;
cgv22	jsr	expap			; test for pattern match on left side
	ppm	cgv23			; jump if not pattern match
;
;      here for pattern replacement
;
	mov	cmlop(xl),cmrop(xr)	; save pattern ptr in safe place
	mov	xr,cmlop(xr)		; load subject ptr
	jsr	cdgnm			; gen code by name for subject
	mov	xr,cmlop(xl)		; load pattern ptr
	jsr	cdgvl			; gen code by value for pattern
	mov	wa,=opmn_		; load match by name call
	jsr	cdwrd			; generate it
	mov	xr,cmrop(xl)		; load replacement value ptr
	jsr	cdgvl			; gen code by value
	mov	wa,=orpl_		; load replace call
	brn	cgv32			; jump to gen and exit (not constant)
;
;      here for assignment to complex variable
;
cgv23	mnz	wc			; inhibit pre-evaluation
	jsr	cdgnm			; gen code by name for left side
	brn	cgv31			; merge with unop circuit
	ejc
;
;      cdgvl (continued)
;
;      here for concatenation
;
cgv24	mov	xr,cmlop(xl)		; load left operand ptr
	bne	(xr),=b_cmt,cgv18	; ordinary binop if not cmblk
	mov	wb,cmtyp(xr)		; load cmblk type code
	beq	wb,=c_int,cgv25		; special case if interrogation
	beq	wb,=c_neg,cgv25		; or negation
	bne	wb,=c_fnc,cgv18		; else ordinary binop if not function
	mov	xr,cmopn(xr)		; else load function vrblk ptr
	bnz	vrlen(xr),cgv18		; ordinary binop if not system var
	mov	xr,vrsvp(xr)		; else point to svblk
	mov	wa,svbit(xr)		; load bit indicators
	anb	wa,btprd		; test for predicate function
	zrb	wa,cgv18		; ordinary binop if not
;
;      here if left arg of concatenation is predicate function
;
cgv25	mov	xr,cmlop(xl)		; reload left arg
	jsr	cdgvl			; gen code by value
	mov	wa,=opop_		; load pop call
	jsr	cdwrd			; generate it
	mov	xr,cmrop(xl)		; load right operand
	jsr	cdgvl			; gen code by value as result code
	brn	cgv33			; exit (not constant)
;
;      here to generate code for pattern, immediate assignment
;
cgv26	mov	xr,cmlop(xl)		; load left operand
	jsr	cdgvl			; gen code by value, merge
;
;      here for unops with arg by name (binary _ . merge)
;
cgv27	mov	xr,cmrop(xl)		; load right operand ptr
	jsr	cdgnm			; gen code by name for right arg
	mov	xr,cmopn(xl)		; get operator code word
	bne	(xr),=o_kwv,cgv20	; gen call unless keyword value
	ejc
;
;      cdgvl (continued)
;
;      here for keyword by value. this is constant only if
;      the operand is one of the special system variables with
;      the svckw bit set to indicate a constant keyword value.
;      note that the only constant operand by name is a variable
;
	bnz	wc,cgv20		; gen call if non-constant (not var)
	mnz	wc			; else set non-constant in case
	mov	xr,cmrop(xl)		; load ptr to operand vrblk
	bnz	vrlen(xr),cgv20		; gen (non-constant) if not sys var
	mov	xr,vrsvp(xr)		; else load ptr to svblk
	mov	wa,svbit(xr)		; load bit mask
	anb	wa,btckw		; test for constant keyword
	zrb	wa,cgv20		; go gen if not constant
	zer	wc			; else set result constant
	brn	cgv20			; and jump back to generate call
;
;      here to generate code for negation
;
cgv28	mov	wa,=onta_		; get initial word
	jsr	cdwrd			; generate it
	mov	wb,cwcof		; save next offset
	jsr	cdwrd			; generate gunk word for now
	mov	xr,cmrop(xl)		; load right operand ptr
	jsr	cdgvl			; gen code by value
	mov	wa,=ontb_		; load end of evaluation call
	jsr	cdwrd			; generate it
	mov	xr,wb			; copy offset to word to plug
	add	xr,r_ccb		; point to actual word to plug
	mov	(xr),cwcof		; plug word with current offset
	mov	wa,=ontc_		; load final call
	brn	cgv32			; jump to generate it (not constant)
;
;      here to generate code for undefined binary operator
;
cgv29	mov	xr,cmlop(xl)		; load left operand ptr
	jsr	cdgvl			; generate code by value
	ejc
;
;      cdgvl (continued)
;
;      here to generate code for undefined unary operator
;
cgv30	mov	wb,=c_uo_		; set unop code + 1
	sub	wb,cmtyp(xl)		; set number of args (1 or 2)
;
;      merge here for undefined operators
;
	mov	xr,cmrop(xl)		; load right (only) operand pointer
	jsr	cdgvl			; gen value code for right operand
	mov	xr,cmopn(xl)		; load pointer to operator dv
	mov	xr,dvopn(xr)		; load pointer offset
	wtb	xr			; convert word offset to bytes
	add	xr,=r_uba		; point to proper function ptr
	sub	xr,*vrfnc		; set standard function offset
	brn	cgv12			; merge with function call circuit
;
;      here to generate code for interrogation, indirection
;
cgv31	mnz	wc			; set non constant
	brn	cgv19			; merge
;
;      here to exit generating a word, result not constant
;
cgv32	jsr	cdwrd			; generate word, merge
;
;      here to exit with no word generated, not constant
;
cgv33	mnz	wc			; indicate result is not constant
;
;      common exit point
;
cgv34	ica	xs			; pop initial code offset
	mov	wa,(xs)+		; restore old constant flag
	mov	xl,(xs)+		; restore entry xl
	mov	wb,(xs)+		; restore entry wb
	bnz	wc,cgv35		; jump if not constant
	mov	wc,wa			; else restore entry constant flag
;
;      here to return after dealing with wc setting
;
cgv35	exi				; return to cdgvl caller
;
;      exit here to generate word and test for constant
;
cgv36	jsr	cdwrd			; generate word
	bnz	wc,cgv34		; jump to exit if not constant
	ejc
;
;      cdgvl (continued)
;
;      here to preevaluate constant sub-expression
;
	mov	wa,=orvl_		; load call to return value
	jsr	cdwrd			; generate it
	mov	xl,(xs)			; load initial code offset
	jsr	exbld			; build exblk for expression
	zer	wb			; set to evaluate by value
	jsr	evalx			; evaluate expression
	ppm				; should not fail
	mov	wa,(xr)			; load type word of result
	blo	wa,=p_aaa,cgv37		; jump if not pattern
	mov	wa,=olpt_		; else load special pattern load call
	jsr	cdwrd			; generate it
;
;      merge here to generate pointer to resulting constant
;
cgv37	mov	wa,xr			; copy constant pointer
	jsr	cdwrd			; generate ptr
	zer	wc			; set result constant
	brn	cgv34			; jump back to exit
	enp				; end procedure cdgvl
	ejc
;
;      cdwrd -- generate one word of code
;
;      cdwrd writes one word into the current code block under
;      construction. a new, larger, block is allocated if there
;      is insufficient room in the current block. cdwrd ensures
.if    .csln
;      that there are at least four words left in the block
.else
;      that there are at least three words left in the block
.fi
;      after entering the new word. this guarantees that any
;      extra space at the end can be split off as a ccblk.
;
;      (wa)		     word to be generated
;      jsr  cdwrd	     call to generate word
;
cdwrd	prc	e,0			; entry point
	mov	-(xs),xr		; save entry xr
	mov	-(xs),wa		; save code word to be generated
;
;      merge back here after allocating larger block
;
cdwd1	mov	xr,r_ccb		; load ptr to ccblk being built
	bnz	xr,cdwd2		; jump if block allocated
;
;      here we allocate an entirely fresh block
;
	mov	wa,*e_cbs		; load initial length
	jsr	alloc			; allocate ccblk
	mov	(xr),=b_cct		; store type word
	mov	cwcof,*cccod		; set initial offset
	mov	cclen(xr),wa		; store block length
.if    .csln
	zer	ccsln(xr)		; zero line number
.fi
	mov	r_ccb,xr		; store ptr to new block
;
;      here we have a block we can use
;
cdwd2	mov	wa,cwcof		; load current offset
.if    .csln
	add	wa,*num05		; adjust for test (five words)
.else
	add	wa,*num04		; adjust for test (four words)
.fi
	blo	wa,cclen(xr),cdwd4	; jump if room in this block
;
;      here if no room in current block
;
	bge	wa,mxlen,cdwd5		; jump if already at max size
	add	wa,*e_cbs		; else get new size
	mov	-(xs),xl		; save entry xl
	mov	xl,xr			; copy pointer
	blt	wa,mxlen,cdwd3		; jump if not too large
	mov	wa,mxlen		; else reset to max allowed size
	ejc
;
;      cdwrd (continued)
;
;      here with new block size in wa
;
cdwd3	jsr	alloc			; allocate new block
	mov	r_ccb,xr		; store pointer to new block
	mov	(xr)+,=b_cct		; store type word in new block
	mov	(xr)+,wa		; store block length
.if    .csln
	mov	(xr)+,ccsln(xl)		; copy source line number word
.fi
	add	xl,*ccuse		; point to ccuse,cccod fields in old
	mov	wa,(xl)			; load ccuse value
	mvw				; copy useful words from old block
	mov	xl,(xs)+		; restore xl
	brn	cdwd1			; merge back to try again
;
;      here with room in current block
;
cdwd4	mov	wa,cwcof		; load current offset
	ica	wa			; get new offset
	mov	cwcof,wa		; store new offset
	mov	ccuse(xr),wa		; store in ccblk for gbcol
	dca	wa			; restore ptr to this word
	add	xr,wa			; point to current entry
	mov	wa,(xs)+		; reload word to generate
	mov	(xr),wa			; store word in block
	mov	xr,(xs)+		; restore entry xr
	exi				; return to caller
;
;      here if compiled code is too long for cdblk
;
cdwd5	erb	213,syntax error: statement is too complicated.
	enp				; end procedure cdwrd
	ejc
;
;      cmgen -- generate code for cmblk ptr
;
;      cmgen is a subsidiary procedure used to generate value
;      code for a cmblk ptr from the main code generators.
;
;      (xl)		     cmblk pointer
;      (wb)		     offset to pointer in cmblk
;      jsr  cmgen	     call to generate code
;      (xr,wa)		     destroyed
;      (wb)		     bumped by one word
;
cmgen	prc	r,0			; entry point, recursive
	mov	xr,xl			; copy cmblk pointer
	add	xr,wb			; point to cmblk pointer
	mov	xr,(xr)			; load cmblk pointer
	jsr	cdgvl			; generate code by value
	ica	wb			; bump offset
	exi				; return to caller
	enp				; end procedure cmgen
	ejc
;
;      cmpil (compile source code)
;
;      cmpil is used to convert snobol4 source code to internal
;      form (see cdblk format). it is used both for the initial
;      compile and at run time by the code and convert functions
;      this procedure has control for the entire duration of
;      initial compilation. an error in any procedure called
;      during compilation will lead first to the error section
;      and ultimately back here for resumed compilation. the
;      re-entry points after an error are specially labelled -
;
;      cmpce		     resume after control card error
;      cmple		     resume after label error
;      cmpse		     resume after statement error
;
;      jsr  cmpil	     call to compile code
;      (xr)		     ptr to cdblk for entry statement
;      (xl,wa,wb,wc,ra)	     destroyed
;
;      the following global variables are referenced
;
;      cmpln		     line number of first line of
;			     statement to be compiled
;
;      cmpsn		     number of next statement
;			     to be compiled.
;
;      cswxx		     control card switch values are
;			     changed when relevant control
;			     cards are met.
;
;      cwcof		     offset to next word in code block
;			     being built (see cdwrd).
;
;      lstsn		     number of statement most recently
;			     compiled (initially set to zero).
;
;      r_cim		     current (initial) compiler image
;			     (zero for initial compile call)
;
;      r_cni		     used to point to following image.
;			     (see readr procedure).
;
;      scngo		     goto switch for scane procedure
;
;      scnil		     length of current image excluding
;			     characters removed by -input.
;
;      scnpt		     current scan offset, see scane.
;
;      scnrs		     rescan switch for scane procedure.
;
;      scnse		     offset (in r_cim) of most recently
;			     scanned element. set zero if not
;			     currently scanning items
	ejc
;
;      cmpil (continued)
;
;      stage		   stgic  initial compile in progress
;			   stgxc  code/convert compile
;			   stgev  building exblk for eval
;			   stgxt  execute time (outside compile)
;			   stgce  initial compile after end line
;			   stgxe  execute compile after end line
;
;      cmpil also uses a fixed number of locations on the
;      main stack as follows. (the definitions of the actual
;      offsets are in the definitions section).
;
;      cmstm(xs)	     pointer to expan tree for body of
;			     statement (see expan procedure).
;
;      cmsgo(xs)	     pointer to tree representation of
;			     success goto (see procedure scngo)
;			     zero if no success goto is given
;
;      cmfgo(xs)	     like cmsgo for failure goto.
;
;      cmcgo(xs)	     set non-zero only if there is a
;			     conditional goto. used for -fail,
;			     -nofail code generation.
;
;      cmpcd(xs)	     pointer to cdblk for previous
;			     statement. zero for 1st statement.
;
;      cmffp(xs)	     set non-zero if cdfal in previous
;			     cdblk needs filling with forward
;			     pointer, else set to zero.
;
;      cmffc(xs)	     same as cmffp for current cdblk
;
;      cmsop(xs)	     offset to word in previous cdblk
;			     to be filled in with forward ptr
;			     to next cdblk for success goto.
;			     zero if no fill in is required.
;
;      cmsoc(xs)	     same as cmsop for current cdblk.
;
;      cmlbl(xs)	     pointer to vrblk for label of
;			     current statement. zero if no label
;
;      cmtra(xs)	     pointer to cdblk for entry stmnt.
	ejc
;
;      cmpil (continued)
;
;      entry point
;
cmpil	prc	e,0			; entry point
	lct	wb,=cmnen		; set number of stack work locations
;
;      loop to initialize stack working locations
;
cmp00	zer	-(xs)			; store a zero, make one entry
	bct	wb,cmp00		; loop back until all set
	mov	cmpxs,xs		; save stack pointer for error sec
	sss	cmpss			; save s-r stack pointer if any
;
;      loop through statements
;
cmp01	mov	wb,scnpt		; set scan pointer offset
	mov	scnse,wb		; set start of element location
	mov	wa,=ocer_		; point to compile error call
	jsr	cdwrd			; generate as temporary cdfal
	blt	wb,scnil,cmp04		; jump if chars left on this image
;
;      loop here after comment or control card
;      also special entry after control card error
;
cmpce	zer	xr			; clear possible garbage xr value
.if    .cinc
	bnz	cnind,cmpc2		; if within include file
.fi
	bne	stage,=stgic,cmp02	; skip unless initial compile
cmpc2	jsr	readr			; read next input image
	bze	xr,cmp09		; jump if no input available
	jsr	nexts			; acquire next source image
	mov	lstsn,cmpsn		; store stmt no for use by listr
	mov	cmpln,rdcln		; store line number at start of stmt
	zer	scnpt			; reset scan pointer
	brn	cmp04			; go process image
;
;      for execute time compile, permit embedded control cards
;      and comments (by skipping to next semi-colon)
;
cmp02	mov	xr,r_cim		; get current image
	mov	wb,scnpt		; get current offset
	plc	xr,wb			; prepare to get chars
;
;      skip to semi-colon
;
cmp03	bge	scnpt,scnil,cmp09	; end loop if end of image
	lch	wc,(xr)+		; get char
	icv	scnpt			; advance offset
	bne	wc,=ch_sm,cmp03		; loop if not semi-colon
	ejc
;
;      cmpil (continued)
;
;      here with image available to scan. note that if the input
;      string is null, then everything is ok since null is
;      actually assembled as a word of blanks.
;
cmp04	mov	xr,r_cim		; point to current image
	mov	wb,scnpt		; load current offset
	mov	wa,wb			; copy for label scan
	plc	xr,wb			; point to first character
	lch	wc,(xr)+		; load first character
	beq	wc,=ch_sm,cmp12		; no label if semicolon
	beq	wc,=ch_as,cmpce		; loop back if comment card
	beq	wc,=ch_mn,cmp32		; jump if control card
	mov	r_cmp,r_cim		; about to destroy r_cim
	mov	xl,=cmlab		; point to label work string
	mov	r_cim,xl		; scane is to scan work string
	psc	xl			; point to first character position
	sch	wc,(xl)+		; store char just loaded
	mov	wc,=ch_sm		; get a semicolon
	sch	wc,(xl)			; store after first char
	csc	xl			; finished character storing
	zer	xl			; clear pointer
	zer	scnpt			; start at first character
	mov	-(xs),scnil		; preserve image length
	mov	scnil,=num02		; read 2 chars at most
	jsr	scane			; scan first char for type
	mov	scnil,(xs)+		; restore image length
	mov	wc,xl			; note return code
	mov	xl,r_cmp		; get old r_cim
	mov	r_cim,xl		; put it back
	mov	scnpt,wb		; reinstate offset
	bnz	scnbl,cmp12		; blank seen - cant be label
	mov	xr,xl			; point to current image
	plc	xr,wb			; point to first char again
	beq	wc,=t_var,cmp06		; ok if letter
	beq	wc,=t_con,cmp06		; ok if digit
;
;      drop in or jump from error section if scane failed
;
cmple	mov	r_cim,r_cmp		; point to bad line
	erb	214,bad label or misplaced continuation line
;
;      loop to scan label
;
cmp05	beq	wc,=ch_sm,cmp07		; skip if semicolon
	icv	wa			; bump offset
	beq	wa,scnil,cmp07		; jump if end of image (label end)
	ejc
;
;      cmpil (continued)
;
;      enter loop at this point
;
cmp06	lch	wc,(xr)+		; else load next character
.if    .caht
	beq	wc,=ch_ht,cmp07		; jump if horizontal tab
.fi
.if    .cavt
	beq	wc,=ch_vt,cmp07		; jump if vertical tab
.fi
	bne	wc,=ch_bl,cmp05		; loop back if non-blank
;
;      here after scanning out label
;
cmp07	mov	scnpt,wa		; save updated scan offset
	sub	wa,wb			; get length of label
	bze	wa,cmp12		; skip if label length zero
	zer	xr			; clear garbage xr value
	jsr	sbstr			; build scblk for label name
	jsr	gtnvr			; locate/contruct vrblk
	ppm				; dummy (impossible) error return
	mov	cmlbl(xs),xr		; store label pointer
	bnz	vrlen(xr),cmp11		; jump if not system label
	bne	vrsvp(xr),=v_end,cmp11	; jump if not end label
;
;      here for end label scanned out
;
	add	stage,=stgnd		; adjust stage appropriately
	jsr	scane			; scan out next element
	beq	xl,=t_smc,cmp10		; jump if end of image
	bne	xl,=t_var,cmp08		; else error if not variable
;
;      here check for valid initial transfer
;
	beq	vrlbl(xr),=stndl,cmp08	; jump if not defined (error)
	mov	cmtra(xs),vrlbl(xr)	; else set initial entry pointer
	jsr	scane			; scan next element
	beq	xl,=t_smc,cmp10		; jump if ok (end of image)
;
;      here for bad transfer label
;
cmp08	erb	215,syntax error: undefined or erroneous entry label
;
;      here for end of input (no end label detected)
;
cmp09	zer	xr			; clear garbage xr value
	add	stage,=stgnd		; adjust stage appropriately
	beq	stage,=stgxe,cmp10	; jump if code call (ok)
	erb	216,syntax error: missing end line
;
;      here after processing end line (merge here on end error)
;
cmp10	mov	wa,=ostp_		; set stop call pointer
	jsr	cdwrd			; generate as statement call
	brn	cmpse			; jump to generate as failure
	ejc
;
;      cmpil (continued)
;
;      here after processing label other than end
;
cmp11	bne	stage,=stgic,cmp12	; jump if code call - redef. ok
	beq	vrlbl(xr),=stndl,cmp12	; else check for redefinition
	zer	cmlbl(xs)		; leave first label decln undisturbed
	erb	217,syntax error: duplicate label
;
;      here after dealing with label
;      null statements and statements just containing a
;      constant subject are optimized out by resetting the
;      current ccblk to empty.
;
cmp12	zer	wb			; set flag for statement body
	jsr	expan			; get tree for statement body
	mov	cmstm(xs),xr		; store for later use
	zer	cmsgo(xs)		; clear success goto pointer
	zer	cmfgo(xs)		; clear failure goto pointer
	zer	cmcgo(xs)		; clear conditional goto flag
	jsr	scane			; scan next element
	beq	xl,=t_col,cmp13		; jump if colon (goto)
	bnz	cswno,cmp18		; jump if not optimizing
	bnz	cmlbl(xs),cmp18		; jump if label present
	mov	xr,cmstm(xs)		; load tree ptr for statement body
	mov	wa,(xr)			; load type word
	beq	wa,=b_cmt,cmp18		; jump if cmblk
	bge	wa,=b_vra,cmp18		; jump if not icblk, scblk, or rcblk
	mov	xl,r_ccb		; load ptr to ccblk
	mov	ccuse(xl),*cccod	; reset use offset in ccblk
	mov	cwcof,*cccod		; and in global
	icv	cmpsn			; bump statement number
	brn	cmp01			; generate no code for statement
;
;      loop to process goto fields
;
cmp13	mnz	scngo			; set goto flag
	jsr	scane			; scan next element
	beq	xl,=t_smc,cmp31		; jump if no fields left
	beq	xl,=t_sgo,cmp14		; jump if s for success goto
	beq	xl,=t_fgo,cmp16		; jump if f for failure goto
;
;      here for unconditional goto (i.e. not f or s)
;
	mnz	scnrs			; set to rescan element not f,s
	jsr	scngf			; scan out goto field
	bnz	cmfgo(xs),cmp17		; error if fgoto already
	mov	cmfgo(xs),xr		; else set as fgoto
	brn	cmp15			; merge with sgoto circuit
;
;      here for success goto
;
cmp14	jsr	scngf			; scan success goto field
	mov	cmcgo(xs),=num01	; set conditional goto flag
;
;      uncontional goto merges here
;
cmp15	bnz	cmsgo(xs),cmp17		; error if sgoto already given
	mov	cmsgo(xs),xr		; else set sgoto
	brn	cmp13			; loop back for next goto field
;
;      here for failure goto
;
cmp16	jsr	scngf			; scan goto field
	mov	cmcgo(xs),=num01	; set conditonal goto flag
	bnz	cmfgo(xs),cmp17		; error if fgoto already given
	mov	cmfgo(xs),xr		; else store fgoto pointer
	brn	cmp13			; loop back for next field
	ejc
;
;      cmpil (continued)
;
;      here for duplicated goto field
;
cmp17	erb	218,syntax error: duplicated goto field
;
;      here to generate code
;
cmp18	zer	scnse			; stop positional error flags
	mov	xr,cmstm(xs)		; load tree ptr for statement body
	zer	wb			; collectable value for wb for cdgvl
	zer	wc			; reset constant flag for cdgvl
	jsr	expap			; test for pattern match
	ppm	cmp19			; jump if not pattern match
	mov	cmopn(xr),=opms_	; else set pattern match pointer
	mov	cmtyp(xr),=c_pmt	;
;
;      here after dealing with special pattern match case
;
cmp19	jsr	cdgvl			; generate code for body of statement
	mov	xr,cmsgo(xs)		; load sgoto pointer
	mov	wa,xr			; copy it
	bze	xr,cmp21		; jump if no success goto
	zer	cmsoc(xs)		; clear success offset fillin ptr
	bhi	xr,state,cmp20		; jump if complex goto
;
;      here for simple success goto (label)
;
	add	wa,*vrtra		; point to vrtra field as required
	jsr	cdwrd			; generate success goto
	brn	cmp22			; jump to deal with fgoto
;
;      here for complex success goto
;
cmp20	beq	xr,cmfgo(xs),cmp22	; no code if same as fgoto
	zer	wb			; else set ok value for cdgvl in wb
	jsr	cdgcg			; generate code for success goto
	brn	cmp22			; jump to deal with fgoto
;
;      here for no success goto
;
cmp21	mov	cmsoc(xs),cwcof		; set success fill in offset
	mov	wa,=ocer_		; point to compile error call
	jsr	cdwrd			; generate as temporary value
	ejc
;
;      cmpil (continued)
;
;      here to deal with failure goto
;
cmp22	mov	xr,cmfgo(xs)		; load failure goto pointer
	mov	wa,xr			; copy it
	zer	cmffc(xs)		; set no fill in required yet
	bze	xr,cmp23		; jump if no failure goto given
	add	wa,*vrtra		; point to vrtra field in case
	blo	xr,state,cmpse		; jump to gen if simple fgoto
;
;      here for complex failure goto
;
	mov	wb,cwcof		; save offset to o_gof call
	mov	wa,=ogof_		; point to failure goto call
	jsr	cdwrd			; generate
	mov	wa,=ofif_		; point to fail in fail word
	jsr	cdwrd			; generate
	jsr	cdgcg			; generate code for failure goto
	mov	wa,wb			; copy offset to o_gof for cdfal
	mov	wb,=b_cdc		; set complex case cdtyp
	brn	cmp25			; jump to build cdblk
;
;      here if no failure goto given
;
cmp23	mov	wa,=ounf_		; load unexpected failure call in cas
	mov	wc,cswfl		; get -nofail flag
	orb	wc,cmcgo(xs)		; check if conditional goto
	zrb	wc,cmpse		; jump if -nofail and no cond. goto
	mnz	cmffc(xs)		; else set fill in flag
	mov	wa,=ocer_		; and set compile error for temporary
;
;      merge here with cdfal value in wa, simple cdblk
;      also special entry after statement error
;
cmpse	mov	wb,=b_cds		; set cdtyp for simple case
	ejc
;
;      cmpil (continued)
;
;      merge here to build cdblk
;
;      (wa)		     cdfal value to be generated
;      (wb)		     cdtyp value to be generated
;
;      at this stage, we chop off an appropriate chunk of the
;      current ccblk and convert it into a cdblk. the remainder
;      of the ccblk is reformatted to be the new ccblk.
;
cmp25	mov	xr,r_ccb		; point to ccblk
	mov	xl,cmlbl(xs)		; get possible label pointer
	bze	xl,cmp26		; skip if no label
	zer	cmlbl(xs)		; clear flag for next statement
	mov	vrlbl(xl),xr		; put cdblk ptr in vrblk label field
;
;      merge after doing label
;
cmp26	mov	(xr),wb			; set type word for new cdblk
	mov	cdfal(xr),wa		; set failure word
	mov	xl,xr			; copy pointer to ccblk
	mov	wb,ccuse(xr)		; load length gen (= new cdlen)
	mov	wc,cclen(xr)		; load total ccblk length
	add	xl,wb			; point past cdblk
	sub	wc,wb			; get length left for chop off
	mov	(xl),=b_cct		; set type code for new ccblk at end
	mov	ccuse(xl),*cccod	; set initial code offset
	mov	cwcof,*cccod		; reinitialise cwcof
	mov	cclen(xl),wc		; set new length
	mov	r_ccb,xl		; set new ccblk pointer
.if    .csln
	zer	ccsln(xl)		; initialize new line number
	mov	cdsln(xr),cmpln		; set line number in old block
.fi
	mov	cdstm(xr),cmpsn		; set statement number
	icv	cmpsn			; bump statement number
;
;      set pointers in previous code block as required
;
	mov	xl,cmpcd(xs)		; load ptr to previous cdblk
	bze	cmffp(xs),cmp27		; jump if no failure fill in required
	mov	cdfal(xl),xr		; else set failure ptr in previous
;
;      here to deal with success forward pointer
;
cmp27	mov	wa,cmsop(xs)		; load success offset
	bze	wa,cmp28		; jump if no fill in required
	add	xl,wa			; else point to fill in location
	mov	(xl),xr			; store forward pointer
	zer	xl			; clear garbage xl value
	ejc
;
;      cmpil (continued)
;
;      now set fill in pointers for this statement
;
cmp28	mov	cmffp(xs),cmffc(xs)	; copy failure fill in flag
	mov	cmsop(xs),cmsoc(xs)	; copy success fill in offset
	mov	cmpcd(xs),xr		; save ptr to this cdblk
	bnz	cmtra(xs),cmp29		; jump if initial entry already set
	mov	cmtra(xs),xr		; else set ptr here as default
;
;      here after compiling one statement
;
cmp29	blt	stage,=stgce,cmp01	; jump if not end line just done
	bze	cswls,cmp30		; skip if -nolist
	jsr	listr			; list last line
;
;      return
;
cmp30	mov	xr,cmtra(xs)		; load initial entry cdblk pointer
	add	xs,*cmnen		; pop work locations off stack
	exi				; and return to cmpil caller
;
;      here at end of goto field
;
cmp31	mov	wb,cmfgo(xs)		; get fail goto
	orb	wb,cmsgo(xs)		; or in success goto
	bnz	wb,cmp18		; ok if non-null field
	erb	219,syntax error: empty goto field
;
;      control card found
;
cmp32	icv	wb			; point past ch_mn
	jsr	cncrd			; process control card
	zer	scnse			; clear start of element loc.
	brn	cmpce			; loop for next statement
	enp				; end procedure cmpil
	ejc
;
;      cncrd -- control card processor
;
;      called to deal with control cards
;
;      r_cim		     points to current image
;      (wb)		     offset to 1st char of control card
;      jsr  cncrd	     call to process control cards
;      (xl,xr,wa,wb,wc,ia)   destroyed
;
cncrd	prc	e,0			; entry point
	mov	scnpt,wb		; offset for control card scan
	mov	wa,=ccnoc		; number of chars for comparison
	ctw	wa,0			; convert to word count
	mov	cnswc,wa		; save word count
;
;      loop here if more than one control card
;
cnc01	bge	scnpt,scnil,cnc09	; return if end of image
	mov	xr,r_cim		; point to image
	plc	xr,scnpt		; char ptr for first char
	lch	wa,(xr)+		; get first char
.if    .culc
	flc	wa			; fold to lower case
.fi
	beq	wa,=ch_li,cnc07		; special case of -inxxx
cnc0a	mnz	scncc			; set flag for scane
	jsr	scane			; scan card name
	zer	scncc			; clear scane flag
	bnz	xl,cnc06		; fail unless control card name
	mov	wa,=ccnoc		; no. of chars to be compared
.if    .cicc
	blt	sclen(xr),wa,cnc08	; fail if too few chars
.else
	blt	sclen(xr),wa,cnc06	; fail if too few chars
.fi
	mov	xl,xr			; point to control card name
	zer	wb			; zero offset for substring
	jsr	sbstr			; extract substring for comparison
.if    .culc
	mov	wa,sclen(xr)		; reload length
	jsr	flstg			; fold to upper case
.fi
	mov	cnscc,xr		; keep control card substring ptr
	mov	xr,=ccnms		; point to list of standard names
	zer	wb			; initialise name offset
	lct	wc,=cc_nc		; number of standard names
;
;      try to match name
;
cnc02	mov	xl,cnscc		; point to name
	lct	wa,cnswc		; counter for inner loop
	brn	cnc04			; jump into loop
;
;      inner loop to match card name chars
;
cnc03	ica	xr			; bump standard names ptr
	ica	xl			; bump name pointer
;
;      here to initiate the loop
;
cnc04	cne	schar(xl),(xr),cnc05	; comp. up to cfp_c chars at once
	bct	wa,cnc03		; loop if more words to compare
	ejc
;
;      cncrd (continued)
;
;      matched - branch on card offset
;
	mov	xl,wb			; get name offset
.if    .cicc
	bsw	xl,cc_nc,cnc08		; switch
.else
	bsw	xl,cc_nc,cnc06		; switch
.fi
.if    .culc
	iff	cc_ca,cnc37		; -case
.fi
.if    .ccmc
	iff	cc_co,cnc39		; -compare
.fi
	iff	cc_do,cnc10		; -double
	iff	cc_du,cnc11		; -dump
.if    .cinc
	iff	cc_cp,cnc41		; -copy
.fi
	iff	cc_ej,cnc12		; -eject
	iff	cc_er,cnc13		; -errors
	iff	cc_ex,cnc14		; -execute
	iff	cc_fa,cnc15		; -fail
.if    .cinc
	iff	cc_in,cnc41		; -include
.fi
.if    .csln
	iff	cc_ln,cnc44		; -line
.fi
	iff	cc_li,cnc16		; -list
	iff	cc_nr,cnc17		; -noerrors
	iff	cc_nx,cnc18		; -noexecute
	iff	cc_nf,cnc19		; -nofail
	iff	cc_nl,cnc20		; -nolist
	iff	cc_no,cnc21		; -noopt
	iff	cc_np,cnc22		; -noprint
	iff	cc_op,cnc24		; -optimise
	iff	cc_pr,cnc25		; -print
	iff	cc_si,cnc27		; -single
	iff	cc_sp,cnc28		; -space
	iff	cc_st,cnc31		; -stitle
	iff	cc_ti,cnc32		; -title
	iff	cc_tr,cnc36		; -trace
	esw				; end switch
;
;      not matched yet. align std names ptr and try again
;
cnc05	ica	xr			; bump standard names ptr
	bct	wa,cnc05		; loop
	icv	wb			; bump names offset
	bct	wc,cnc02		; continue if more names
.if    .cicc
	brn	cnc08			; ignore unrecognized control card
.fi
;
;      invalid control card name
;
cnc06	erb	247,invalid control statement
;
;      special processing for -inxxx
;
cnc07	lch	wa,(xr)+		; get next char
.if    .culc
	flc	wa			; fold to lower case
.fi
	bne	wa,=ch_ln,cnc0a		; if not letter n
	lch	wa,(xr)			; get third char
	blt	wa,=ch_d0,cnc0a		; if not digit
	bgt	wa,=ch_d9,cnc0a		; if not digit
	add	scnpt,=num02		; bump offset past -in
	jsr	scane			; scan integer after -in
	mov	-(xs),xr		; stack scanned item
	jsr	gtsmi			; check if integer
	ppm	cnc06			; fail if not integer
	ppm	cnc06			; fail if negative or large
	mov	cswin,xr		; keep integer
	ejc
;
;      cncrd (continued)
;
;      check for more control cards before returning
;
cnc08	mov	wa,scnpt		; preserve in case xeq time compile
	jsr	scane			; look for comma
	beq	xl,=t_cma,cnc01		; loop if comma found
	mov	scnpt,wa		; restore scnpt in case xeq time
;
;      return point
;
cnc09	exi				; return
;
;      -double
;
cnc10	mnz	cswdb			; set switch
	brn	cnc08			; merge
;
;      -dump
;      this is used for system debugging . it has the effect of
;      producing a core dump at compilation time
;
cnc11	jsr	sysdm			; call dumper
	brn	cnc09			; finished
;
;      -eject
;
cnc12	bze	cswls,cnc09		; return if -nolist
	jsr	prtps			; eject
	jsr	listt			; list title
	brn	cnc09			; finished
;
;      -errors
;
cnc13	zer	cswer			; clear switch
	brn	cnc08			; merge
;
;      -execute
;
cnc14	zer	cswex			; clear switch
	brn	cnc08			; merge
;
;      -fail
;
cnc15	mnz	cswfl			; set switch
	brn	cnc08			; merge
;
;      -list
;
cnc16	mnz	cswls			; set switch
	beq	stage,=stgic,cnc08	; done if compile time
;
;      list code line if execute time compile
;
	zer	lstpf			; permit listing
	jsr	listr			; list line
	brn	cnc08			; merge
	ejc
;
;      cncrd (continued)
;
;      -noerrors
;
cnc17	mnz	cswer			; set switch
	brn	cnc08			; merge
;
;      -noexecute
;
cnc18	mnz	cswex			; set switch
	brn	cnc08			; merge
;
;      -nofail
;
cnc19	zer	cswfl			; clear switch
	brn	cnc08			; merge
;
;      -nolist
;
cnc20	zer	cswls			; clear switch
	brn	cnc08			; merge
;
;      -nooptimise
;
cnc21	mnz	cswno			; set switch
	brn	cnc08			; merge
;
;      -noprint
;
cnc22	zer	cswpr			; clear switch
	brn	cnc08			; merge
;
;      -optimise
;
cnc24	zer	cswno			; clear switch
	brn	cnc08			; merge
;
;      -print
;
cnc25	mnz	cswpr			; set switch
	brn	cnc08			; merge
	ejc
;
;      cncrd (continued)
;
;      -single
;
cnc27	zer	cswdb			; clear switch
	brn	cnc08			; merge
;
;      -space
;
cnc28	bze	cswls,cnc09		; return if -nolist
	jsr	scane			; scan integer after -space
	mov	wc,=num01		; 1 space in case
	beq	xr,=t_smc,cnc29		; jump if no integer
	mov	-(xs),xr		; stack it
	jsr	gtsmi			; check integer
	ppm	cnc06			; fail if not integer
	ppm	cnc06			; fail if negative or large
	bnz	wc,cnc29		; jump if non zero
	mov	wc,=num01		; else 1 space
;
;      merge with count of lines to skip
;
cnc29	add	lstlc,wc		; bump line count
	lct	wc,wc			; convert to loop counter
	blt	lstlc,lstnp,cnc30	; jump if fits on page
	jsr	prtps			; eject
	jsr	listt			; list title
	brn	cnc09			; merge
;
;      skip lines
;
cnc30	jsr	prtnl			; print a blank
	bct	wc,cnc30		; loop
	brn	cnc09			; merge
	ejc
;
;      cncrd (continued)
;
;      -stitl
;
cnc31	mov	cnr_t,=r_stl		; ptr to r_stl
	brn	cnc33			; merge
;
;      -title
;
cnc32	mov	r_stl,=nulls		; clear subtitle
	mov	cnr_t,=r_ttl		; ptr to r_ttl
;
;      common processing for -title, -stitl
;
cnc33	mov	xr,=nulls		; null in case needed
	mnz	cnttl			; set flag for next listr call
	mov	wb,=ccofs		; offset to title/subtitle
	mov	wa,scnil		; input image length
	blo	wa,wb,cnc34		; jump if no chars left
	sub	wa,wb			; no of chars to extract
	mov	xl,r_cim		; point to image
	jsr	sbstr			; get title/subtitle
;
;      store title/subtitle
;
cnc34	mov	xl,cnr_t		; point to storage location
	mov	(xl),xr			; store title/subtitle
	beq	xl,=r_stl,cnc09		; return if stitl
	bnz	precl,cnc09		; return if extended listing
	bze	prich,cnc09		; return if regular printer
	mov	xl,sclen(xr)		; get length of title
	mov	wa,xl			; copy it
	bze	xl,cnc35		; jump if null
	add	xl,=num10		; increment
	bhi	xl,prlen,cnc09		; use default lstp0 val if too long
	add	wa,=num04		; point just past title
;
;      store offset to page nn message for short title
;
cnc35	mov	lstpo,wa		; store offset
	brn	cnc09			; return
;
;      -trace
;      provided for system debugging.  toggles the system label
;      trace switch at compile time
;
cnc36	jsr	systt			; toggle switch
	brn	cnc08			; merge
.if    .culc
;
;      -case
;      sets value of kvcas so that names are folded or not
;      during compilation.
;
cnc37	jsr	scane			; scan integer after -case
	zer	wc			; get 0 in case none there
	beq	xl,=t_smc,cnc38		; skip if no integer
	mov	-(xs),xr		; stack it
	jsr	gtsmi			; check integer
	ppm	cnc06			; fail if not integer
	ppm	cnc06			; fail if negative or too large
cnc38	mov	kvcas,wc		; store new case value
	brn	cnc09			; merge
.fi
.if    .ccmc
;
;      -compare
;
;      sets value of kvcom so that string comparisons may
;      follow collation sequence determined by the interface.
;
cnc39	jsr	scane			; scan integer after -compare
	zer	wc			; get 0 in case none there
	beq	xl,=t_smc,cnc40		; skip if no integer
	mov	-(xs),xr		; stack it
	jsr	gtsmi			; check integer
	ppm	cnc06			; fail if not integer
	ppm	cnc06			; fail if negative or too large
cnc40	mov	kvcom,wc		; store new compare value
	brn	cnc09			; merge
.fi
.if    .cinc
;
;      -include
;
cnc41	mnz	scncc			; set flag for scane
	jsr	scane			; scan quoted file name
	zer	scncc			; clear scane flag
	bne	xl,=t_con,cnc06		; if not constant
	bne	(xr),=b_scl,cnc06	; if not string constant
	mov	r_ifn,xr		; save file name
	mov	xl,r_inc		; examine include file name table
	zer	wb			; lookup by value
	jsr	tfind			; do lookup
	ppm				; never fails
	beq	xr,=inton,cnc09		; ignore if already in table
	mnz	wb			; set for trim
	mov	xr,r_ifn		; file name
	jsr	trimr			; remove trailing blanks
	mov	xl,r_inc		; include file name table
	mnz	wb			; lookup by name this time
	jsr	tfind			; do lookup
	ppm				; never fails
	mov	teval(xl),=inton	; make table value integer 1
	icv	cnind			; increase nesting level
	mov	wa,cnind		; load new nest level
	bgt	wa,=ccinm,cnc42		; fail if excessive nesting
.if    .csfn
;
;      record the name and line number of the current input file
;
	mov	xl,r_ifa		; array of nested file names
	add	wa,=vcvlb		; compute offset in words
	wtb	wa			; convert to bytes
	add	xl,wa			; point to element
	mov	(xl),r_sfc		; record current file name
	mov	xl,wa			; preserve nesting byte offset
	mti	rdnln			; fetch source line number as integer
	jsr	icbld			; convert to icblk
	add	xl,r_ifl		; entry in nested line number array
	mov	(xl),xr			; record in array
.fi
;
;      here to switch to include file named in r_ifn
;
	mov	wa,cswin		; max read length
	mov	xl,r_ifn		; include file name
	jsr	alocs			; get buffer for complete file name
	jsr	sysif			; open include file
	ppm	cnc43			; could not open
.if    .csfn
;
;      make note of the complete file name for error messages
;
	zer	wb			; do not trim trailing blanks
	jsr	trimr			; adjust scblk for actual length
	mov	r_sfc,xr		; save ptr to file name
	mti	cmpsn			; current statement as integer
	jsr	icbld			; build icblk for stmt number
	mov	xl,r_sfn		; file name table
	mnz	wb			; lookup statement number by name
	jsr	tfind			; allocate new teblk
	ppm				; always possible to allocate block
	mov	teval(xl),r_sfc		; record file name as entry value
.else
	mov	dnamp,xr		; release allocated scblk
.fi
	zer	rdnln			; restart line counter for new file
	beq	stage,=stgic,cnc09	; if initial compile
	bne	cnind,=num01,cnc09	; if not first execute-time nesting
;
;      here for -include during execute-time compile
;
	mov	r_ici,r_cim		; remember code argument string
	mov	cnspt,scnpt		; save position in string
	mov	cnsil,scnil		; and length of string
	brn	cnc09			; all done, merge
;
;      here for excessive include file nesting
;
cnc42	erb	284,excessively nested include files
;
;      here if include file could not be opened
;
cnc43	mov	dnamp,xr		; release allocated scblk
	erb	285,include file cannot be opened
;
.fi
.if    .csln
;
;      -line n filename
;
cnc44	jsr	scane			; scan integer after -line
	bne	xl,=t_con,cnc06		; jump if no line number
	bne	(xr),=b_icl,cnc06	; jump if not integer
	ldi	icval(xr)		; fetch integer line number
	ile	cnc06			; error if negative or zero
	beq	stage,=stgic,cnc45	; skip if initial compile
	mfi	cmpln			; set directly for other compiles
	brn	cnc46			; no need to set rdnln
cnc45	sbi	intv1			; adjust number by one
	mfi	rdnln			; save line number
.if    .csfn
cnc46	mnz	scncc			; set flag for scane
	jsr	scane			; scan quoted file name
	zer	scncc			; clear scane flag
	beq	xl,=t_smc,cnc47		; done if no file name
	bne	xl,=t_con,cnc06		; error if not constant
	bne	(xr),=b_scl,cnc06	; if not string constant
	jsr	newfn			; record new file name
	brn	cnc09			; merge
;
;      here if file name not present
;
cnc47	dcv	scnpt			; set to rescan the terminator
	brn	cnc09			; merge
.else
cnc46	brn	cnc09			; merge
.fi
.fi
	enp				; end procedure cncrd
	ejc
.if    .ceng
;
;      enevs -- evaluate string expression for engine
;
;      enevs is used by the external interface to evaluate a
;      string expression, typically for an engine wishing to
;      obtain the value of a variable or expression.
;
.if    .cevb
;      (wb)		     0 if by value, 1 if by name
.fi
;      (xr)		     scblk for string to evaluate
;      jsr  enevs	     call to convert and evaluate
;      (xr)		     pointer to result
;			     = 0 if expression evaluation failed
;			     = 1 if conversion to expression failed
;
enevs	prc	r,0			; entry point (recursive)
.if    .cevb
	mov	-(xs),wb		; save value/name flag
.fi
	jsr	gtexp			; convert to expression
	ppm	enev2			; conversion fails
.if    .cevb
	mov	wb,(xs)+		; recover value/name flag
.fi
	jsr	evalx			; evaluate expression by value
	ppm	enev1			; evaluation fails
	exi
;
;      here if expression evaluation failed
;
enev1	zer	xr			; return zero result
	exi
;
;      here if conversion to expression failed
;
.if    .cevb
enev2	ica	xs			; discard value/name flag
	mov	xr,=num01		; return integer one result
.else
enev2	mov	xr,=num01		; return integer one result
.fi
	exi
	enp
	ejc
;
;      engts -- get string for engine
;
;      engts is passed an object and returns a string with
;      any necessary conversions performed.
;
;      (xr)		     input argument
;      jsr  engts	     call to convert to string
;      (xr)		     pointer to resulting string
;			     =0 if conversion not possible
;
engts	prc	e,0			; entry point
	mov	-(xs),xr		; stack argument to convert
	jsr	gtstg			; convert to string
	ppm	engt1			; convert impossible
	exi
;
;      here if unable to convert to string
;
engt1	zer	xr			; return zero
	exi
	enp
	ejc
.fi
;
;      dffnc -- define function
;
;      dffnc is called whenever a new function is assigned to
;      a variable. it deals with external function use counts.
;
;      (xr)		     pointer to vrblk
;      (xl)		     pointer to new function block
;      jsr  dffnc	     call to define function
;      (wa,wb)		     destroyed
;
dffnc	prc	e,0			; entry point
.if    .cnld
.else
	bne	(xl),=b_efc,dffn1	; skip if new function not external
	icv	efuse(xl)		; else increment its use count
;
;      here after dealing with new function use count
;
dffn1	mov	wa,xr			; save vrblk pointer
	mov	xr,vrfnc(xr)		; load old function pointer
	bne	(xr),=b_efc,dffn2	; jump if old function not external
	mov	wb,efuse(xr)		; else get use count
	dcv	wb			; decrement
	mov	efuse(xr),wb		; store decremented value
	bnz	wb,dffn2		; jump if use count still non-zero
	jsr	sysul			; else call system unload function
;
;      here after dealing with old function use count
;
dffn2	mov	xr,wa			; restore vrblk pointer
.fi
	mov	wa,xl			; copy function block ptr
	blt	xr,=r_yyy,dffn3		; skip checks if opsyn op definition
	bnz	vrlen(xr),dffn3		; jump if not system variable
;
;      for system variable, check for illegal redefinition
;
	mov	xl,vrsvp(xr)		; point to svblk
	mov	wb,svbit(xl)		; load bit indicators
	anb	wb,btfnc		; is it a system function
	zrb	wb,dffn3		; redef ok if not
	erb	248,attempted redefinition of system function
;
;      here if redefinition is permitted
;
dffn3	mov	vrfnc(xr),wa		; store new function pointer
	mov	xl,wa			; restore function block pointer
	exi				; return to dffnc caller
	enp				; end procedure dffnc
	ejc
;
;      dtach -- detach i/o associated names
;
;      detaches trblks from i/o associated variables, removes
;      entry from iochn chain attached to filearg1 vrblk and may
;      remove vrblk access and store traps.
;      input, output, terminal are handled specially.
;
;      (xl)		     i/o assoc. vbl name base ptr
;      (wa)		     offset to name
;      jsr  dtach	     call for detach operation
;      (xl,xr,wa,wb,wc)	     destroyed
;
dtach	prc	e,0			; entry point
	mov	dtcnb,xl		; store name base (gbcol not called)
	add	xl,wa			; point to name location
	mov	dtcnm,xl		; store it
;
;      loop to search for i/o trblk
;
dtch1	mov	xr,xl			; copy name pointer
;
;      continue after block deletion
;
dtch2	mov	xl,(xl)			; point to next value
	bne	(xl),=b_trt,dtch6	; jump at chain end
	mov	wa,trtyp(xl)		; get trap block type
	beq	wa,=trtin,dtch3		; jump if input
	beq	wa,=trtou,dtch3		; jump if output
	add	xl,*trnxt		; point to next link
	brn	dtch1			; loop
;
;      delete an old association
;
dtch3	mov	(xr),trval(xl)		; delete trblk
	mov	wa,xl			; dump xl ...
	mov	wb,xr			; ... and xr
	mov	xl,trtrf(xl)		; point to trtrf trap block
	bze	xl,dtch5		; jump if no iochn
	bne	(xl),=b_trt,dtch5	; jump if input, output, terminal
;
;      loop to search iochn chain for name ptr
;
dtch4	mov	xr,xl			; remember link ptr
	mov	xl,trtrf(xl)		; point to next link
	bze	xl,dtch5		; jump if end of chain
	mov	wc,ionmb(xl)		; get name base
	add	wc,ionmo(xl)		; add offset
	bne	wc,dtcnm,dtch4		; loop if no match
	mov	trtrf(xr),trtrf(xl)	; remove name from chain
	ejc
;
;      dtach (continued)
;
;      prepare to resume i/o trblk scan
;
dtch5	mov	xl,wa			; recover xl ...
	mov	xr,wb			; ... and xr
	add	xl,*trval		; point to value field
	brn	dtch2			; continue
;
;      exit point
;
dtch6	mov	xr,dtcnb		; possible vrblk ptr
	jsr	setvr			; reset vrblk if necessary
	exi				; return
	enp				; end procedure dtach
	ejc
;
;      dtype -- get datatype name
;
;      (xr)		     object whose datatype is required
;      jsr  dtype	     call to get datatype
;      (xr)		     result datatype
;
dtype	prc	e,0			; entry point
	beq	(xr),=b_pdt,dtyp1	; jump if prog.defined
	mov	xr,(xr)			; load type word
	lei	xr			; get entry point id (block code)
	wtb	xr			; convert to byte offset
	mov	xr,scnmt(xr)		; load table entry
	exi				; exit to dtype caller
;
;      here if program defined
;
dtyp1	mov	xr,pddfp(xr)		; point to dfblk
	mov	xr,dfnam(xr)		; get datatype name from dfblk
	exi				; return to dtype caller
	enp				; end procedure dtype
	ejc
;
;      dumpr -- print dump of storage
;
;      (xr)		     dump argument (see below)
;      jsr  dumpr	     call to print dump
;      (xr,xl)		     destroyed
;      (wa,wb,wc,ra)	     destroyed
;
;      the dump argument has the following significance
;
;      dmarg = 0	     no dump printed
;      dmarg = 1	     partial dump (nat vars, keywords)
;      dmarg = 2	     full dump (arrays, tables, etc.)
;      dmarg = 3	     full dump + null variables
;      dmarg ge 4	     core dump
;
;      since dumpr scrambles store, it is not permissible to
;      collect in mid-dump. hence a collect is done initially
;      and then if store runs out an error message is produced.
;
dumpr	prc	e,0			; entry point
	bze	xr,dmp28		; skip dump if argument is zero
	bgt	xr,=num03,dmp29		; jump if core dump required
	zer	xl			; clear xl
	zer	wb			; zero move offset
	mov	dmarg,xr		; save dump argument
.if    .csed
	zer	dnams			; collect sediment too
.fi
	jsr	gbcol			; collect garbage
	jsr	prtpg			; eject printer
	mov	xr,=dmhdv		; point to heading for variables
	jsr	prtst			; print it
	jsr	prtnl			; terminate print line
	jsr	prtnl			; and print a blank line
;
;      first all natural variable blocks (vrblk) whose values
;      are non-null are linked in lexical order using dmvch as
;      the chain head and chaining through the vrget fields.
;      note that this scrambles store if the process is
;      interrupted before completion e.g. by exceeding time  or
;      print limits. since the subsequent core dumps and
;      failures if execution is resumed are very confusing, the
;      execution time error routine checks for this event and
;      attempts an unscramble. similar precautions should be
;      observed if translate time dumping is implemented.
;
	zer	dmvch			; set null chain to start
	mov	wa,hshtb		; point to hash table
;
;      loop through headers in hash table
;
dmp00	mov	xr,wa			; copy hash bucket pointer
	ica	wa			; bump pointer
	sub	xr,*vrnxt		; set offset to merge
;
;      loop through vrblks on one chain
;
dmp01	mov	xr,vrnxt(xr)		; point to next vrblk on chain
	bze	xr,dmp09		; jump if end of this hash chain
	mov	xl,xr			; else copy vrblk pointer
	ejc
;
;      dumpr (continued)
;
;      loop to find value and skip if null
;
dmp02	mov	xl,vrval(xl)		; load value
	beq	dmarg,=num03,dmp2a	; skip null value check if dump(3)
	beq	xl,=nulls,dmp01		; loop for next vrblk if null value
dmp2a	beq	(xl),=b_trt,dmp02	; loop back if value is trapped
;
;      non-null value, prepare to search chain
;
	mov	wc,xr			; save vrblk pointer
	add	xr,*vrsof		; adjust ptr to be like scblk ptr
	bnz	sclen(xr),dmp03		; jump if non-system variable
	mov	xr,vrsvo(xr)		; else load ptr to name in svblk
;
;      here with name pointer for new block in xr
;
dmp03	mov	wb,xr			; save pointer to chars
	mov	dmpsv,wa		; save hash bucket pointer
	mov	wa,=dmvch		; point to chain head
;
;      loop to search chain for correct insertion point
;
dmp04	mov	dmpch,wa		; save chain pointer
	mov	xl,wa			; copy it
	mov	xr,(xl)			; load pointer to next entry
	bze	xr,dmp08		; jump if end of chain to insert
	add	xr,*vrsof		; else get name ptr for chained vrblk
	bnz	sclen(xr),dmp05		; jump if not system variable
	mov	xr,vrsvo(xr)		; else point to name in svblk
;
;      here prepare to compare the names
;
;      (wa)		     scratch
;      (wb)		     pointer to string of entering vrblk
;      (wc)		     pointer to entering vrblk
;      (xr)		     pointer to string of current block
;      (xl)		     scratch
;
dmp05	mov	xl,wb			; point to entering vrblk string
	mov	wa,sclen(xl)		; load its length
	plc	xl			; point to chars of entering string
.if    .ccmc
	mov	dmpsb,wb		; save wb
	mov	wb,sclen(xr)		; length of old string
	plc	xr			; point to chars of old string
	jsr	syscm			; generalized lexical compare
	ppm	dmp06			; string too long, treat like eq
	ppm	dmp06			; entering string lt old string
	ppm	dmp07			; entering string gt old string
;
;      here when entering string le old string
;
dmp06	mov	wb,dmpsb		; restore wb
	brn	dmp08			; found insertion point
	ejc
;
;      dumpr (continued)
;
;      here we move out on the chain
;
dmp07	mov	wb,dmpsb		; restore wb
	mov	xl,dmpch		; copy chain pointer
.else
	bhi	wa,sclen(xr),dmp06	; jump if entering length high
	plc	xr			; else point to chars of old string
	cmc	dmp08,dmp07		; compare, insert if new is llt old
	brn	dmp08			; or if leq (we had shorter length)
;
;      here when new length is longer than old length
;
dmp06	mov	wa,sclen(xr)		; load shorter length
	plc	xr			; point to chars of old string
	cmc	dmp08,dmp07		; compare, insert if new one low
	ejc
;
;      dumpr (continued)
;
;      here we move out on the chain
;
dmp07	mov	xl,dmpch		; copy chain pointer
.fi
	mov	wa,(xl)			; move to next entry on chain
	brn	dmp04			; loop back
;
;      here after locating the proper insertion point
;
dmp08	mov	xl,dmpch		; copy chain pointer
	mov	wa,dmpsv		; restore hash bucket pointer
	mov	xr,wc			; restore vrblk pointer
	mov	vrget(xr),(xl)		; link vrblk to rest of chain
	mov	(xl),xr			; link vrblk into current chain loc
	brn	dmp01			; loop back for next vrblk
;
;      here after processing all vrblks on one chain
;
dmp09	bne	wa,hshte,dmp00		; loop back if more buckets to go
;
;      loop to generate dump of natural variable values
;
dmp10	mov	xr,dmvch		; load pointer to next entry on chain
	bze	xr,dmp11		; jump if end of chain
	mov	dmvch,(xr)		; else update chain ptr to next entry
	jsr	setvr			; restore vrget field
	mov	xl,xr			; copy vrblk pointer (name base)
	mov	wa,*vrval		; set offset for vrblk name
	jsr	prtnv			; print name = value
	brn	dmp10			; loop back till all printed
;
;      prepare to print keywords
;
dmp11	jsr	prtnl			; print blank line
	jsr	prtnl			; and another
	mov	xr,=dmhdk		; point to keyword heading
	jsr	prtst			; print heading
	jsr	prtnl			; end line
	jsr	prtnl			; print one blank line
	mov	xl,=vdmkw		; point to list of keyword svblk ptrs
	ejc
;
;      dumpr (continued)
;
;      loop to dump keyword values
;
dmp12	mov	xr,(xl)+		; load next svblk ptr from table
	bze	xr,dmp13		; jump if end of list
.if    .ccmk
	beq	xr,=num01,dmp12		; &compare ignored if not implemented
.fi
	mov	wa,=ch_am		; load ampersand
	jsr	prtch			; print ampersand
	jsr	prtst			; print keyword name
	mov	wa,svlen(xr)		; load name length from svblk
	ctb	wa,svchs		; get length of name
	add	xr,wa			; point to svknm field
	mov	dmpkn,(xr)		; store in dummy kvblk
	mov	xr,=tmbeb		; point to blank-equal-blank
	jsr	prtst			; print it
	mov	dmpsv,xl		; save table pointer
	mov	xl,=dmpkb		; point to dummy kvblk
	mov	(xl),=b_kvt		; build type word
	mov	kvvar(xl),=trbkv	; build ptr to dummy trace block
	mov	wa,*kvvar		; set zero offset
	jsr	acess			; get keyword value
	ppm				; failure is impossible
	jsr	prtvl			; print keyword value
	jsr	prtnl			; terminate print line
	mov	xl,dmpsv		; restore table pointer
	brn	dmp12			; loop back till all printed
;
;      here after completing partial dump
;
dmp13	beq	dmarg,=num01,dmp27	; exit if partial dump complete
	mov	xr,dnamb		; else point to first dynamic block
;
;      loop through blocks in dynamic storage
;
dmp14	beq	xr,dnamp,dmp27		; jump if end of used region
	mov	wa,(xr)			; else load first word of block
	beq	wa,=b_vct,dmp16		; jump if vector
	beq	wa,=b_art,dmp17		; jump if array
	beq	wa,=b_pdt,dmp18		; jump if program defined
	beq	wa,=b_tbt,dmp19		; jump if table
.if    .cnbf
.else
	beq	wa,=b_bct,dmp30		; jump if buffer
.fi
;
;      merge here to move to next block
;
dmp15	jsr	blkln			; get length of block
	add	xr,wa			; point past this block
	brn	dmp14			; loop back for next block
	ejc
;
;      dumpr (continued)
;
;      here for vector
;
dmp16	mov	wb,*vcvls		; set offset to first value
	brn	dmp19			; jump to merge
;
;      here for array
;
dmp17	mov	wb,arofs(xr)		; set offset to arpro field
	ica	wb			; bump to get offset to values
	brn	dmp19			; jump to merge
;
;      here for program defined
;
dmp18	mov	wb,*pdfld		; point to values, merge
;
;      here for table (others merge)
;
dmp19	bze	idval(xr),dmp15		; ignore block if zero id value
	jsr	blkln			; else get block length
	mov	xl,xr			; copy block pointer
	mov	dmpsv,wa		; save length
	mov	wa,wb			; copy offset to first value
	jsr	prtnl			; print blank line
	mov	dmpsa,wa		; preserve offset
	jsr	prtvl			; print block value (for title)
	mov	wa,dmpsa		; recover offset
	jsr	prtnl			; end print line
	beq	(xr),=b_tbt,dmp22	; jump if table
	dca	wa			; point before first word
;
;      loop to print contents of array, vector, or program def
;
dmp20	mov	xr,xl			; copy block pointer
	ica	wa			; bump offset
	add	xr,wa			; point to next value
	beq	wa,dmpsv,dmp14		; exit if end (xr past block)
	sub	xr,*vrval		; subtract offset to merge into loop
;
;      loop to find value and ignore nulls
;
dmp21	mov	xr,vrval(xr)		; load next value
	beq	dmarg,=num03,dmp2b	; skip null value check if dump(3)
	beq	xr,=nulls,dmp20		; loop back if null value
dmp2b	beq	(xr),=b_trt,dmp21	; loop back if trapped
	jsr	prtnv			; else print name = value
	brn	dmp20			; loop back for next field
	ejc
;
;      dumpr (continued)
;
;      here to dump a table
;
dmp22	mov	wc,*tbbuk		; set offset to first bucket
	mov	wa,*teval		; set name offset for all teblks
;
;      loop through table buckets
;
dmp23	mov	-(xs),xl		; save tbblk pointer
	add	xl,wc			; point to next bucket header
	ica	wc			; bump bucket offset
	sub	xl,*tenxt		; subtract offset to merge into loop
;
;      loop to process teblks on one chain
;
dmp24	mov	xl,tenxt(xl)		; point to next teblk
	beq	xl,(xs),dmp26		; jump if end of chain
	mov	xr,xl			; else copy teblk pointer
;
;      loop to find value and ignore if null
;
dmp25	mov	xr,teval(xr)		; load next value
	beq	xr,=nulls,dmp24		; ignore if null value
	beq	(xr),=b_trt,dmp25	; loop back if trapped
	mov	dmpsv,wc		; else save offset pointer
	jsr	prtnv			; print name = value
	mov	wc,dmpsv		; reload offset
	brn	dmp24			; loop back for next teblk
;
;      here to move to next hash chain
;
dmp26	mov	xl,(xs)+		; restore tbblk pointer
	bne	wc,tblen(xl),dmp23	; loop back if more buckets to go
	mov	xr,xl			; else copy table pointer
	add	xr,wc			; point to following block
	brn	dmp14			; loop back to process next block
;
;      here after completing dump
;
dmp27	jsr	prtpg			; eject printer
;
;      merge here if no dump given (dmarg=0)
;
dmp28	exi				; return to dump caller
;
;      call system core dump routine
;
dmp29	jsr	sysdm			; call it
	brn	dmp28			; return
.if    .cnbf
.else
	ejc
;
;      dumpr (continued)
;
;      here to dump buffer block
;
dmp30	jsr	prtnl			; print blank line
	jsr	prtvl			; print value id for title
	jsr	prtnl			; force new line
	mov	wa,=ch_dq		; load double quote
	jsr	prtch			; print it
	mov	wc,bclen(xr)		; load defined length
	bze	wc,dmp32		; skip characters if none
	lct	wc,wc			; load count for loop
	mov	wb,xr			; save bcblk ptr
	mov	xr,bcbuf(xr)		; point to bfblk
	plc	xr			; get set to load characters
;
;      loop here stuffing characters in output stream
;
dmp31	lch	wa,(xr)+		; get next character
	jsr	prtch			; stuff it
	bct	wc,dmp31		; branch for next one
	mov	xr,wb			; restore bcblk pointer
;
;      merge to stuff closing quote mark
;
dmp32	mov	wa,=ch_dq		; stuff quote
	jsr	prtch			; print it
	jsr	prtnl			; print new line
	mov	wa,(xr)			; get first wd for blkln
	brn	dmp15			; merge to get next block
.fi
	enp				; end procedure dumpr
	ejc
;
;      ermsg -- print error code and error message
;
;      kvert		     error code
;      jsr  ermsg	     call to print message
;      (xr,xl,wa,wb,wc,ia)   destroyed
;
ermsg	prc	e,0			; entry point
	mov	wa,kvert		; load error code
	mov	xr,=ermms		; point to error message /error/
	jsr	prtst			; print it
	jsr	ertex			; get error message text
	add	wa,=thsnd		; bump error code for print
	mti	wa			; fail code in int acc
	mov	wb,profs		; save current buffer position
	jsr	prtin			; print code (now have error1xxx)
	mov	xl,prbuf		; point to print buffer
	psc	xl,wb			; point to the 1
	mov	wa,=ch_bl		; load a blank
	sch	wa,(xl)			; store blank over 1 (error xxx)
	csc	xl			; complete store characters
	zer	xl			; clear garbage pointer in xl
	mov	wa,xr			; keep error text
	mov	xr,=ermns		; point to / -- /
	jsr	prtst			; print it
	mov	xr,wa			; get error text again
	jsr	prtst			; print error message text
	jsr	prtis			; print line
	jsr	prtis			; print blank line
	exi				; return to ermsg caller
	enp				; end procedure ermsg
	ejc
;
;      ertex -- get error message text
;
;      (wa)		     error code
;      jsr  ertex	     call to get error text
;      (xr)		     ptr to error text in dynamic
;      (r_etx)		     copy of ptr to error text
;      (xl,wc,ia)	     destroyed
;
ertex	prc	e,0			; entry point
	mov	ertwa,wa		; save wa
	mov	ertwb,wb		; save wb
	jsr	sysem			; get failure message text
	mov	xl,xr			; copy pointer to it
	mov	wa,sclen(xr)		; get length of string
	bze	wa,ert02		; jump if null
	zer	wb			; offset of zero
	jsr	sbstr			; copy into dynamic store
	mov	r_etx,xr		; store for relocation
;
;      return
;
ert01	mov	wb,ertwb		; restore wb
	mov	wa,ertwa		; restore wa
	exi				; return to caller
;
;      return errtext contents instead of null
;
ert02	mov	xr,r_etx		; get errtext
	brn	ert01			; return
	enp
	ejc
;
;      evali -- evaluate integer argument
;
;      evali is used by pattern primitives len,tab,rtab,pos,rpos
;      when their argument is an expression value.
;
;      (xr)		     node pointer
;      (wb)		     cursor
;      jsr  evali	     call to evaluate integer
;      ppm  loc		     transfer loc for non-integer arg
;      ppm  loc		     transfer loc for out of range arg
;      ppm  loc		     transfer loc for evaluation failure
;      ppm  loc		     transfer loc for successful eval
;      (the normal return is never taken)
;      (xr)		     ptr to node with integer argument
;      (wc,xl,ra)	     destroyed
;
;      on return, the node pointed to has the integer argument
;      in parm1 and the proper successor pointer in pthen.
;      this allows merging with the normal (integer arg) case.
;
evali	prc	r,4			; entry point (recursive)
	jsr	evalp			; evaluate expression
	ppm	evli1			; jump on failure
	mov	-(xs),xl		; stack result for gtsmi
	mov	xl,pthen(xr)		; load successor pointer
	mov	evlio,xr		; save original node pointer
	mov	evlif,wc		; zero if simple argument
	jsr	gtsmi			; convert arg to small integer
	ppm	evli2			; jump if not integer
	ppm	evli3			; jump if out of range
	mov	evliv,xr		; store result in special dummy node
	mov	xr,=evlin		; point to dummy node with result
	mov	(xr),=p_len		; dummy pattern block pcode
	mov	pthen(xr),xl		; store successor pointer
	exi	4			; take successful exit
;
;      here if evaluation fails
;
evli1	exi	3			; take failure return
;
;      here if argument is not integer
;
evli2	exi	1			; take non-integer error exit
;
;      here if argument is out of range
;
evli3	exi	2			; take out-of-range error exit
	enp				; end procedure evali
	ejc
;
;      evalp -- evaluate expression during pattern match
;
;      evalp is used to evaluate an expression (by value) during
;      a pattern match. the effect is like evalx, but pattern
;      variables are stacked and restored if necessary.
;
;      evalp also differs from evalx in that if the result is
;      an expression it is reevaluated. this occurs repeatedly.
;
;      to support optimization of pos and rpos, evalp uses wc
;      to signal the caller for the case of a simple vrblk
;      that is not an expression and is not trapped.  because
;      this case cannot have any side effects, optimization is
;      possible.
;
;      (xr)		     node pointer
;      (wb)		     pattern match cursor
;      jsr  evalp	     call to evaluate expression
;      ppm  loc		     transfer loc if evaluation fails
;      (xl)		     result
;      (wa)		     first word of result block
;      (wc)		     zero if simple vrblk, else non-zero
;      (xr,wb)		     destroyed (failure case only)
;      (ra)		     destroyed
;
;      the expression pointer is stored in parm1 of the node
;
;      control returns to failp on failure of evaluation
;
evalp	prc	r,1			; entry point (recursive)
	mov	xl,parm1(xr)		; load expression pointer
	beq	(xl),=b_exl,evlp1	; jump if exblk case
;
;      here for case of seblk
;
;      we can give a fast return if the value of the vrblk is
;      not an expression and is not trapped.
;
	mov	xl,sevar(xl)		; load vrblk pointer
	mov	xl,vrval(xl)		; load value of vrblk
	mov	wa,(xl)			; load first word of value
	bhi	wa,=b_t__,evlp3		; jump if not seblk, trblk or exblk
;
;      here for exblk or seblk with expr value or trapped value
;
evlp1	chk				; check for stack space
	mov	-(xs),xr		; stack node pointer
	mov	-(xs),wb		; stack cursor
	mov	-(xs),r_pms		; stack subject string pointer
	mov	-(xs),pmssl		; stack subject string length
	mov	-(xs),pmdfl		; stack dot flag
	mov	-(xs),pmhbs		; stack history stack base pointer
	mov	xr,parm1(xr)		; load expression pointer
	ejc
;
;      evalp (continued)
;
;      loop back here to reevaluate expression result
;
evlp2	zer	wb			; set flag for by value
	jsr	evalx			; evaluate expression
	ppm	evlp4			; jump on failure
	mov	wa,(xr)			; else load first word of value
	blo	wa,=b_e__,evlp2		; loop back to reevaluate expression
;
;      here to restore pattern values after successful eval
;
	mov	xl,xr			; copy result pointer
	mov	pmhbs,(xs)+		; restore history stack base pointer
	mov	pmdfl,(xs)+		; restore dot flag
	mov	pmssl,(xs)+		; restore subject string length
	mov	r_pms,(xs)+		; restore subject string pointer
	mov	wb,(xs)+		; restore cursor
	mov	xr,(xs)+		; restore node pointer
	mov	wc,xr			; non-zero for simple vrblk
	exi				; return to evalp caller
;
;      here to return after simple vrblk case
;
evlp3	zer	wc			; simple vrblk, no side effects
	exi				; return to evalp caller
;
;      here for failure during evaluation
;
evlp4	mov	pmhbs,(xs)+		; restore history stack base pointer
	mov	pmdfl,(xs)+		; restore dot flag
	mov	pmssl,(xs)+		; restore subject string length
	mov	r_pms,(xs)+		; restore subject string pointer
	add	xs,*num02		; remove node ptr, cursor
	exi	1			; take failure exit
	enp				; end procedure evalp
	ejc
;
;      evals -- evaluate string argument
;
;      evals is used by span, any, notany, break, breakx when
;      they are passed an expression argument.
;
;      (xr)		     node pointer
;      (wb)		     cursor
;      jsr  evals	     call to evaluate string
;      ppm  loc		     transfer loc for non-string arg
;      ppm  loc		     transfer loc for evaluation failure
;      ppm  loc		     transfer loc for successful eval
;      (the normal return is never taken)
;      (xr)		     ptr to node with parms set
;      (xl,wc,ra)	     destroyed
;
;      on return, the node pointed to has a character table
;      pointer in parm1 and a bit mask in parm2. the proper
;      successor is stored in pthen of this node. thus it is
;      ok for merging with the normal (multi-char string) case.
;
evals	prc	r,3			; entry point (recursive)
	jsr	evalp			; evaluate expression
	ppm	evls1			; jump if evaluation fails
	mov	-(xs),pthen(xr)		; save successor pointer
	mov	-(xs),wb		; save cursor
	mov	-(xs),xl		; stack result ptr for patst
	zer	wb			; dummy pcode for one char string
	zer	wc			; dummy pcode for expression arg
	mov	xl,=p_brk		; appropriate pcode for our use
	jsr	patst			; call routine to build node
	ppm	evls2			; jump if not string
	mov	wb,(xs)+		; restore cursor
	mov	pthen(xr),(xs)+		; store successor pointer
	exi	3			; take success return
;
;      here if evaluation fails
;
evls1	exi	2			; take failure return
;
;      here if argument is not string
;
evls2	add	xs,*num02		; pop successor and cursor
	exi	1			; take non-string error exit
	enp				; end procedure evals
	ejc
;
;      evalx -- evaluate expression
;
;      evalx is called to evaluate an expression
;
;      (xr)		     pointer to exblk or seblk
;      (wb)		     0 if by value, 1 if by name
;      jsr  evalx	     call to evaluate expression
;      ppm  loc		     transfer loc if evaluation fails
;      (xr)		     result if called by value
;      (xl,wa)		     result name base,offset if by name
;      (xr)		     destroyed (name case only)
;      (xl,wa)		     destroyed (value case only)
;      (wb,wc,ra)	     destroyed
;
evalx	prc	r,1			; entry point, recursive
	beq	(xr),=b_exl,evlx2	; jump if exblk case
;
;      here for seblk
;
	mov	xl,sevar(xr)		; load vrblk pointer (name base)
	mov	wa,*vrval		; set name offset
	bnz	wb,evlx1		; jump if called by name
	jsr	acess			; call routine to access value
	ppm	evlx9			; jump if failure on access
;
;      merge here to exit for seblk case
;
evlx1	exi				; return to evalx caller
	ejc
;
;      evalx (continued)
;
;      here for full expression (exblk) case
;
;      if an error occurs in the expression code at execution
;      time, control is passed via error section to exfal
;      without returning to this routine.
;      the following entries are made on the stack before
;      giving control to the expression code
;
;			     evalx return point
;			     saved value of r_cod
;			     code pointer (-r_cod)
;			     saved value of flptr
;			     0 if by value, 1 if by name
;      flptr --------------- *exflc, fail offset in exblk
;
evlx2	scp	wc			; get code pointer
	mov	wa,r_cod		; load code block pointer
	sub	wc,wa			; get code pointer as offset
	mov	-(xs),wa		; stack old code block pointer
	mov	-(xs),wc		; stack relative code offset
	mov	-(xs),flptr		; stack old failure pointer
	mov	-(xs),wb		; stack name/value indicator
	mov	-(xs),*exflc		; stack new fail offset
	mov	gtcef,flptr		; keep in case of error
	mov	r_gtc,r_cod		; keep code block pointer similarly
	mov	flptr,xs		; set new failure pointer
	mov	r_cod,xr		; set new code block pointer
	mov	exstm(xr),kvstn		; remember stmnt number
	add	xr,*excod		; point to first code word
	lcp	xr			; set code pointer
	bne	stage,=stgxt,evlx0	; jump if not execution time
	mov	stage,=stgee		; evaluating expression
;
;      here to execute first code word of expression
;
evlx0	zer	xl			; clear garbage xl
	lcw	xr			; load first code word
	bri	(xr)			; execute it
	ejc
;
;      evalx (continued)
;
;      come here if successful return by value (see o_rvl)
;
evlx3	mov	xr,(xs)+		; load value
	bze	num01(xs),evlx5		; jump if called by value
	erb	249,expression evaluated by name returned value
;
;      here for expression returning by name (see o_rnm)
;
evlx4	mov	wa,(xs)+		; load name offset
	mov	xl,(xs)+		; load name base
	bnz	num01(xs),evlx5		; jump if called by name
	jsr	acess			; else access value first
	ppm	evlx6			; jump if failure during access
;
;      here after loading correct result into xr or xl,wa
;
evlx5	zer	wb			; note successful
	brn	evlx7			; merge
;
;      here for failure in expression evaluation (see o_fex)
;
evlx6	mnz	wb			; note unsuccessful
;
;      restore environment
;
evlx7	bne	stage,=stgee,evlx8	; skip if was not previously xt
	mov	stage,=stgxt		; execute time
;
;      merge with stage set up
;
evlx8	add	xs,*num02		; pop name/value indicator, *exfal
	mov	flptr,(xs)+		; restore old failure pointer
	mov	wc,(xs)+		; load code offset
	add	wc,(xs)			; make code pointer absolute
	mov	r_cod,(xs)+		; restore old code block pointer
	lcp	wc			; restore old code pointer
	bze	wb,evlx1		; jump for successful return
;
;      merge here for failure in seblk case
;
evlx9	exi	1			; take failure exit
	enp				; end of procedure evalx
	ejc
;
;      exbld -- build exblk
;
;      exbld is used to build an expression block from the
;      code compiled most recently in the current ccblk.
;
;      (xl)		     offset in ccblk to start of code
;      (wb)		     integer in range 0 le n le mxlen
;      jsr  exbld	     call to build exblk
;      (xr)		     ptr to constructed exblk
;      (wa,wb,xl)	     destroyed
;
exbld	prc	e,0			; entry point
	mov	wa,xl			; copy offset to start of code
	sub	wa,*excod		; calc reduction in offset in exblk
	mov	-(xs),wa		; stack for later
	mov	wa,cwcof		; load final offset
	sub	wa,xl			; compute length of code
	add	wa,*exsi_		; add space for standard fields
	jsr	alloc			; allocate space for exblk
	mov	-(xs),xr		; save pointer to exblk
	mov	extyp(xr),=b_exl	; store type word
	zer	exstm(xr)		; zeroise stmnt number field
.if    .csln
	mov	exsln(xr),cmpln		; set line number field
.fi
	mov	exlen(xr),wa		; store length
	mov	exflc(xr),=ofex_	; store failure word
	add	xr,*exsi_		; set xr for mvw
	mov	cwcof,xl		; reset offset to start of code
	add	xl,r_ccb		; point to start of code
	sub	wa,*exsi_		; length of code to move
	mov	-(xs),wa		; stack length of code
	mvw				; move code to exblk
	mov	wa,(xs)+		; get length of code
	btw	wa			; convert byte count to word count
	lct	wa,wa			; prepare counter for loop
	mov	xl,(xs)			; copy exblk ptr, dont unstack
	add	xl,*excod		; point to code itself
	mov	wb,num01(xs)		; get reduction in offset
;
;      this loop searches for negation and selection code so
;      that the offsets computed whilst code was in code block
;      can be transformed to reduced values applicable in an
;      exblk.
;
exbl1	mov	xr,(xl)+		; get next code word
	beq	xr,=osla_,exbl3		; jump if selection found
	beq	xr,=onta_,exbl3		; jump if negation found
	bct	wa,exbl1		; loop to end of code
;
;      no selection found or merge to exit on termination
;
exbl2	mov	xr,(xs)+		; pop exblk ptr into xr
	mov	xl,(xs)+		; pop reduction constant
	exi				; return to caller
	ejc
;
;      exbld (continued)
;
;      selection or negation found
;      reduce the offsets as needed. offsets occur in words
;      following code words -
;	    =onta_, =osla_, =oslb_, =oslc_
;
exbl3	sub	(xl)+,wb		; adjust offset
	bct	wa,exbl4		; decrement count
;
exbl4	bct	wa,exbl5		; decrement count
;
;      continue search for more offsets
;
exbl5	mov	xr,(xl)+		; get next code word
	beq	xr,=osla_,exbl3		; jump if offset found
	beq	xr,=oslb_,exbl3		; jump if offset found
	beq	xr,=oslc_,exbl3		; jump if offset found
	beq	xr,=onta_,exbl3		; jump if offset found
	bct	wa,exbl5		; loop
	brn	exbl2			; merge to return
	enp				; end procedure exbld
	ejc
;
;      expan -- analyze expression
;
;      the expression analyzer (expan) procedure is used to scan
;      an expression and convert it into a tree representation.
;      see the description of cmblk in the structures section
;      for detailed format of tree blocks.
;
;      the analyzer uses a simple precedence scheme in which
;      operands and operators are placed on a single stack
;      and condensations are made when low precedence operators
;      are stacked after a higher precedence operator. a global
;      variable (in wb) keeps track of the level as follows.
;
;      0    scanning outer level of statement or expression
;      1    scanning outer level of normal goto
;      2    scanning outer level of direct goto
;      3    scanning inside array brackets
;      4    scanning inside grouping parentheses
;      5    scanning inside function parentheses
;
;      this variable is saved on the stack on encountering a
;      grouping and restored at the end of the grouping.
;
;      another global variable (in wc) counts the number of
;      items at one grouping level and is incremented for each
;      comma encountered. it is stacked with the level indicator
;
;      the scan is controlled by a three state finite machine.
;      a global variable stored in wa is the current state.
;
;      wa=0		     nothing scanned at this level
;      wa=1		     operand expected
;      wa=2		     operator expected
;
;      (wb)		     call type (see below)
;      jsr  expan	     call to analyze expression
;      (xr)		     pointer to resulting tree
;      (xl,wa,wb,wc,ra)	     destroyed
;
;      the entry value of wb indicates the call type as follows.
;
;      0    scanning either the main body of a statement or the
;	    text of an expression (from eval call). valid
;	    terminators are colon, semicolon. the rescan flag is
;	    set to return the terminator on the next scane call.
;
;      1    scanning a normal goto. the only valid
;	    terminator is a right paren.
;
;      2    scanning a direct goto. the only valid
;	    terminator is a right bracket.
	ejc
;
;      expan (continued)
;
;      entry point
;
expan	prc	e,0			; entry point
	zer	-(xs)			; set top of stack indicator
	zer	wa			; set initial state to zero
	zer	wc			; zero counter value
;
;      loop here for successive entries
;
exp01	jsr	scane			; scan next element
	add	xl,wa			; add state to syntax code
	bsw	xl,t_nes		; switch on element type/state
	iff	t_va0,exp03		; variable, s=0
	iff	t_va1,exp03		; variable, state one
	iff	t_va2,exp04		; variable, s=2
	iff	t_co0,exp03		; constant, s=0
	iff	t_co1,exp03		; constant, s=1
	iff	t_co2,exp04		; constant, s=2
	iff	t_lp0,exp06		; left paren, s=0
	iff	t_lp1,exp06		; left paren, s=1
	iff	t_lp2,exp04		; left paren, s=2
	iff	t_fn0,exp10		; function, s=0
	iff	t_fn1,exp10		; function, s=1
	iff	t_fn2,exp04		; function, s=2
	iff	t_rp0,exp02		; right paren, s=0
	iff	t_rp1,exp05		; right paren, s=1
	iff	t_rp2,exp12		; right paren, s=2
	iff	t_lb0,exp08		; left brkt, s=0
	iff	t_lb1,exp08		; left brkt, s=1
	iff	t_lb2,exp09		; left brkt, s=2
	iff	t_rb0,exp02		; right brkt, s=0
	iff	t_rb1,exp05		; right brkt, s=1
	iff	t_rb2,exp18		; right brkt, s=2
	iff	t_uo0,exp27		; unop, s=0
	iff	t_uo1,exp27		; unop, s=1
	iff	t_uo2,exp04		; unop, s=2
	iff	t_bo0,exp05		; binop, s=0
	iff	t_bo1,exp05		; binop, s=1
	iff	t_bo2,exp26		; binop, s=2
	iff	t_cm0,exp02		; comma, s=0
	iff	t_cm1,exp05		; comma, s=1
	iff	t_cm2,exp11		; comma, s=2
	iff	t_cl0,exp02		; colon, s=0
	iff	t_cl1,exp05		; colon, s=1
	iff	t_cl2,exp19		; colon, s=2
	iff	t_sm0,exp02		; semicolon, s=0
	iff	t_sm1,exp05		; semicolon, s=1
	iff	t_sm2,exp19		; semicolon, s=2
	esw				; end switch on element type/state
	ejc
;
;      expan (continued)
;
;      here for rbr,rpr,col,smc,cma in state 0
;
;      set to rescan the terminator encountered and create
;      a null constant (case of omitted null)
;
exp02	mnz	scnrs			; set to rescan element
	mov	xr,=nulls		; point to null, merge
;
;      here for var or con in states 0,1
;
;      stack the variable/constant and set state=2
;
exp03	mov	-(xs),xr		; stack pointer to operand
	mov	wa,=num02		; set state 2
	brn	exp01			; jump for next element
;
;      here for var,con,lpr,fnc,uop in state 2
;
;      we rescan the element and create a concatenation operator
;      this is the case of the blank concatenation operator.
;
exp04	mnz	scnrs			; set to rescan element
	mov	xr,=opdvc		; point to concat operator dv
	bze	wb,exp4a		; ok if at top level
	mov	xr,=opdvp		; else point to unmistakable concat.
;
;      merge here when xr set up with proper concatenation dvblk
;
exp4a	bnz	scnbl,exp26		; merge bop if blanks, else error
;      dcv  scnse	     adjust start of element location
	erb	220,syntax error: missing operator
;
;      here for cma,rpr,rbr,col,smc,bop(s=1) bop(s=0)
;
;      this is an erronous contruction
;

;exp05 dcv  scnse	     adjust start of element location
exp05	erb	221,syntax error: missing operand
;
;      here for lpr (s=0,1)
;
exp06	mov	xl,=num04		; set new level indicator
	zer	xr			; set zero value for cmopn
	ejc
;
;      expan (continued)
;
;      merge here to store old level on stack and start new one
;
exp07	mov	-(xs),xr		; stack cmopn value
	mov	-(xs),wc		; stack old counter
	mov	-(xs),wb		; stack old level indicator
	chk				; check for stack overflow
	zer	wa			; set new state to zero
	mov	wb,xl			; set new level indicator
	mov	wc,=num01		; initialize new counter
	brn	exp01			; jump to scan next element
;
;      here for lbr (s=0,1)
;
;      this is an illegal use of left bracket
;
exp08	erb	222,syntax error: invalid use of left bracket
;
;      here for lbr (s=2)
;
;      set new level and start to scan subscripts
;
exp09	mov	xr,(xs)+		; load array ptr for cmopn
	mov	xl,=num03		; set new level indicator
	brn	exp07			; jump to stack old and start new
;
;      here for fnc (s=0,1)
;
;      stack old level and start to scan arguments
;
exp10	mov	xl,=num05		; set new lev indic (xr=vrblk=cmopn)
	brn	exp07			; jump to stack old and start new
;
;      here for cma (s=2)
;
;      increment argument count and continue
;
exp11	icv	wc			; increment counter
	jsr	expdm			; dump operators at this level
	zer	-(xs)			; set new level for parameter
	zer	wa			; set new state
	bgt	wb,=num02,exp01		; loop back unless outer level
	erb	223,syntax error: invalid use of comma
	ejc
;
;      expan (continued)
;
;      here for rpr (s=2)
;
;      at outer level in a normal goto this is a terminator
;      otherwise it must terminate a function or grouping
;
exp12	beq	wb,=num01,exp20		; end of normal goto
	beq	wb,=num05,exp13		; end of function arguments
	beq	wb,=num04,exp14		; end of grouping / selection
	erb	224,syntax error: unbalanced right parenthesis
;
;      here at end of function arguments
;
exp13	mov	xl,=c_fnc		; set cmtyp value for function
	brn	exp15			; jump to build cmblk
;
;      here for end of grouping
;
exp14	beq	wc,=num01,exp17		; jump if end of grouping
	mov	xl,=c_sel		; else set cmtyp for selection
;
;      merge here to build cmblk for level just scanned and
;      to pop up to the previous scan level before continuing.
;
exp15	jsr	expdm			; dump operators at this level
	mov	wa,wc			; copy count
	add	wa,=cmvls		; add for standard fields at start
	wtb	wa			; convert length to bytes
	jsr	alloc			; allocate space for cmblk
	mov	(xr),=b_cmt		; store type code for cmblk
	mov	cmtyp(xr),xl		; store cmblk node type indicator
	mov	cmlen(xr),wa		; store length
	add	xr,wa			; point past end of block
	lct	wc,wc			; set loop counter
;
;      loop to move remaining words to cmblk
;
exp16	mov	-(xr),(xs)+		; move one operand ptr from stack
	mov	wb,(xs)+		; pop to old level indicator
	bct	wc,exp16		; loop till all moved
	ejc
;
;      expan (continued)
;
;      complete cmblk and stack pointer to it on stack
;
	sub	xr,*cmvls		; point back to start of block
	mov	wc,(xs)+		; restore old counter
	mov	cmopn(xr),(xs)		; store operand ptr in cmblk
	mov	(xs),xr			; stack cmblk pointer
	mov	wa,=num02		; set new state
	brn	exp01			; back for next element
;
;      here at end of a parenthesized expression
;
exp17	jsr	expdm			; dump operators at this level
	mov	xr,(xs)+		; restore xr
	mov	wb,(xs)+		; restore outer level
	mov	wc,(xs)+		; restore outer count
	mov	(xs),xr			; store opnd over unused cmopn val
	mov	wa,=num02		; set new state
	brn	exp01			; back for next ele8ent
;
;      here for rbr (s=2)
;
;      at outer level in a direct goto, this is a terminator.
;      otherwise it must terminate a subscript list.
;
exp18	mov	xl,=c_arr		; set cmtyp for array reference
	beq	wb,=num03,exp15		; jump to build cmblk if end arrayref
	beq	wb,=num02,exp20		; jump if end of direct goto
	erb	225,syntax error: unbalanced right bracket
	ejc
;
;      expan (continued)
;
;      here for col,smc (s=2)
;
;      error unless terminating statement body at outer level
;
exp19	mnz	scnrs			; rescan terminator
	mov	xl,wb			; copy level indicator
	bsw	xl,6			; switch on level indicator
	iff	0,exp20			; normal outer level
	iff	1,exp22			; fail if normal goto
	iff	2,exp23			; fail if direct goto
	iff	3,exp24			; fail array brackets
	iff	4,exp21			; fail if in grouping
	iff	5,exp21			; fail function args
	esw				; end switch on level
;
;      here at normal end of expression
;
exp20	jsr	expdm			; dump remaining operators
	mov	xr,(xs)+		; load tree pointer
	ica	xs			; pop off bottom of stack marker
	exi				; return to expan caller
;
;      missing right paren
;
exp21	erb	226,syntax error: missing right paren
;
;      missing right paren in goto field
;
exp22	erb	227,syntax error: right paren missing from goto
;
;      missing bracket in goto
;
exp23	erb	228,syntax error: right bracket missing from goto
;
;      missing array bracket
;
exp24	erb	229,syntax error: missing right array bracket
	ejc
;
;      expan (continued)
;
;      loop here when an operator causes an operator dump
;
exp25	mov	expsv,xr		;
	jsr	expop			; pop one operator
	mov	xr,expsv		; restore op dv pointer and merge
;
;      here for bop (s=2)
;
;      remove operators (condense) from stack until no more
;      left at this level or top one has lower precedence.
;      loop here till this condition is met.
;
exp26	mov	xl,num01(xs)		; load operator dvptr from stack
	ble	xl,=num05,exp27		; jump if bottom of stack level
	blt	dvrpr(xr),dvlpr(xl),exp25; else pop if new prec is lo
;
;      here for uop (s=0,1)
;
;      binary operator merges after precedence check
;
;      the operator dv is stored on the stack and the scan
;      continues after setting the scan state to one.
;
exp27	mov	-(xs),xr		; stack operator dvptr on stack
	chk				; check for stack overflow
	mov	wa,=num01		; set new state
	bne	xr,=opdvs,exp01		; back for next element unless =
;
;      here for special case of binary =. the syntax allows a
;      null right argument for this operator to be left
;      out. accordingly we reset to state zero to get proper
;      action on a terminator (supply a null constant).
;
	zer	wa			; set state zero
	brn	exp01			; jump for next element
	enp				; end procedure expan
	ejc
;
;      expap -- test for pattern match tree
;
;      expap is passed an expression tree to determine if it
;      is a pattern match. the following are recogized as
;      matches in the context of this call.
;
;      1)   an explicit use of binary question mark
;      2)   a concatenation
;      3)   an alternation whose left operand is a concatenation
;
;      (xr)		     ptr to expan tree
;      jsr  expap	     call to test for pattern match
;      ppm  loc		     transfer loc if not a pattern match
;      (wa)		     destroyed
;      (xr)		     unchanged (if not match)
;      (xr)		     ptr to binary operator blk if match
;
expap	prc	e,1			; entry point
	mov	-(xs),xl		; save xl
	bne	(xr),=b_cmt,expp2	; no match if not complex
	mov	wa,cmtyp(xr)		; else load type code
	beq	wa,=c_cnc,expp1		; concatenation is a match
	beq	wa,=c_pmt,expp1		; binary question mark is a match
	bne	wa,=c_alt,expp2		; else not match unless alternation
;
;      here for alternation. change (a b) / c to a qm (b / c)
;
	mov	xl,cmlop(xr)		; load left operand pointer
	bne	(xl),=b_cmt,expp2	; not match if left opnd not complex
	bne	cmtyp(xl),=c_cnc,expp2	; not match if left op not conc
	mov	cmlop(xr),cmrop(xl)	; xr points to (b / c)
	mov	cmrop(xl),xr		; set xl opnds to a, (b / c)
	mov	xr,xl			; point to this altered node
;
;      exit here for pattern match
;
expp1	mov	xl,(xs)+		; restore entry xl
	exi				; give pattern match return
;
;      exit here if not pattern match
;
expp2	mov	xl,(xs)+		; restore entry xl
	exi	1			; give non-match return
	enp				; end procedure expap
	ejc
;
;      expdm -- dump operators at current level (for expan)
;
;      expdm uses expop to condense all operators at this syntax
;      level. the stack bottom is recognized from the level
;      value which is saved on the top of the stack.
;
;      jsr  expdm	     call to dump operators
;      (xs)		     popped as required
;      (xr,wa)		     destroyed
;
expdm	prc	n,0			; entry point
	mov	r_exs,xl		; save xl value
;
;      loop to dump operators
;
exdm1	ble	num01(xs),=num05,exdm2	; jump if stack bottom (saved level
	jsr	expop			; else pop one operator
	brn	exdm1			; and loop back
;
;      here after popping all operators
;
exdm2	mov	xl,r_exs		; restore xl
	zer	r_exs			; release save location
	exi				; return to expdm caller
	enp				; end procedure expdm
	ejc
;
;      expop-- pop operator (for expan)
;
;      expop is used by the expan routine to condense one
;      operator from the top of the syntax stack. an appropriate
;      cmblk is built for the operator (unary or binary) and a
;      pointer to this cmblk is stacked.
;
;      expop is also used by scngf (goto field scan) procedure
;
;      jsr  expop	     call to pop operator
;      (xs)		     popped appropriately
;      (xr,xl,wa)	     destroyed
;
expop	prc	n,0			; entry point
	mov	xr,num01(xs)		; load operator dv pointer
	beq	dvlpr(xr),=lluno,expo2	; jump if unary
;
;      here for binary operator
;
	mov	wa,*cmbs_		; set size of binary operator cmblk
	jsr	alloc			; allocate space for cmblk
	mov	cmrop(xr),(xs)+		; pop and store right operand ptr
	mov	xl,(xs)+		; pop and load operator dv ptr
	mov	cmlop(xr),(xs)		; store left operand pointer
;
;      common exit point
;
expo1	mov	(xr),=b_cmt		; store type code for cmblk
	mov	cmtyp(xr),dvtyp(xl)	; store cmblk node type code
	mov	cmopn(xr),xl		; store dvptr (=ptr to dac o_xxx)
	mov	cmlen(xr),wa		; store cmblk length
	mov	(xs),xr			; store resulting node ptr on stack
	exi				; return to expop caller
;
;      here for unary operator
;
expo2	mov	wa,*cmus_		; set size of unary operator cmblk
	jsr	alloc			; allocate space for cmblk
	mov	cmrop(xr),(xs)+		; pop and store operand pointer
	mov	xl,(xs)			; load operator dv pointer
	brn	expo1			; merge back to exit
	enp				; end procedure expop
	ejc
.if    .csfn
;
;      filnm -- obtain file name from statement number
;
;      filnm takes a statement number and examines the file name
;      table pointed to by r_sfn to find the name of the file
;      containing the given statement.	table entries are
;      arranged in order of ascending statement number (there
;      is only one hash bucket in this table).	elements are
;      added to the table each time there is a change in
;      file name, recording the then current statement number.
;
;      to find the file name, the linked list of teblks is
;      scanned for an element containing a subscript (statement
;      number) greater than the argument statement number, or
;      the end of chain.  when this condition is met, the
;      previous teblk contains the desired file name as its
;      value entry.
;
;      (wc)		     statement number
;      jsr  filnm	     call to obtain file name
;      (xl)		     file name (scblk)
;      (ia)		     destroyed
;
filnm	prc	e,0			; entry point
	mov	-(xs),wb		; preserve wb
	bze	wc,filn3		; return nulls if stno is zero
	mov	xl,r_sfn		; file name table
	bze	xl,filn3		; if no table
	mov	wb,tbbuk(xl)		; get bucket entry
	beq	wb,r_sfn,filn3		; jump if no teblks on chain
	mov	-(xs),xr		; preserve xr
	mov	xr,wb			; previous block pointer
	mov	-(xs),wc		; preserve stmt number
;
;      loop through teblks on hash chain
;
filn1	mov	xl,xr			; next element to examine
	mov	xr,tesub(xl)		; load subscript value (an icblk)
	ldi	icval(xr)		; load the statement number
	mfi	wc			; convert to address constant
	blt	(xs),wc,filn2		; compare arg with teblk stmt number
;
;      here if desired stmt number is ge teblk stmt number
;
	mov	wb,xl			; save previous entry pointer
	mov	xr,tenxt(xl)		; point to next teblk on chain
	bne	xr,r_sfn,filn1		; jump if there is one
;
;      here if chain exhausted or desired block found.
;
filn2	mov	xl,wb			; previous teblk
	mov	xl,teval(xl)		; get ptr to file name scblk
	mov	wc,(xs)+		; restore stmt number
	mov	xr,(xs)+		; restore xr
	mov	wb,(xs)+		; restore wb
	exi
;
;      no table or no table entries
;
filn3	mov	wb,(xs)+		; restore wb
	mov	xl,=nulls		; return null string
	exi
	enp
	ejc
.fi
;
.if    .culc
;
;      flstg -- fold string to lower case
;
;      flstg folds a character string containing upper case
;      characcters to one containing lower case characters.
;      folding is only done if &case (kvcas) is not zero.
;
;      (xr)		     string argument
;      (wa)		     length of string
;      jsr  flstg	     call to fold string
;      (xr)		     result string (possibly original)
;      (wc)		     destroyed
;
flstg	prc	e,0			; entry point
	bze	kvcas,fst99		; skip if &case is 0
	mov	-(xs),xl		; save xl across call
	mov	-(xs),xr		; save original scblk ptr
	jsr	alocs			; allocate new string block
	mov	xl,(xs)			; point to original scblk
	mov	-(xs),xr		; save pointer to new scblk
	plc	xl			; point to original chars
	psc	xr			; point to new chars
	zer	-(xs)			; init did fold flag
	lct	wc,wc			; load loop counter
fst01	lch	wa,(xl)+		; load character
	blt	wa,=ch_ua,fst02		; skip if less than uc a
	bgt	wa,=ch_uz,fst02		; skip if greater than uc z
	flc	wa			; fold character to lower case
	mnz	(xs)			; set did fold character flag
fst02	sch	wa,(xr)+		; store (possibly folded) character
	bct	wc,fst01		; loop thru entire string
	csc	xr			; complete store characters
	mov	xr,(xs)+		; see if any change
	bnz	xr,fst10		; skip if folding done (no change)
	mov	dnamp,(xs)+		; do not need new scblk
	mov	xr,(xs)+		; return original scblk
	brn	fst20			; merge below
fst10	mov	xr,(xs)+		; return new scblk
	ica	xs			; throw away original scblk pointer
fst20	mov	wa,sclen(xr)		; reload string length
	mov	xl,(xs)+		; restore xl
fst99	exi				; return
	enp
	ejc
.fi
;
;      gbcol -- perform garbage collection
;
;      gbcol performs a garbage collection on the dynamic region
;      all blocks which are no longer in use are eliminated
;      by moving blocks which are in use down and resetting
;      dnamp, the pointer to the next available location.
;
;      (wb)		     move offset (see below)
;      jsr  gbcol	     call to collect garbage
.if    .csed
;      (xr)		     sediment size after collection
.else
;      (xr)		     destroyed
.fi
;
;      the following conditions must be met at the time when
;      gbcol is called.
;
;      1)   all pointers to blocks in the dynamic area must be
;	    accessible to the garbage collector. this means
;	    that they must occur in one of the following.
;
;	    a)		     main stack, with current top
;			     element being indicated by xs
;
;	    b)		     in relocatable fields of vrblks.
;
;	    c)		     in register xl at the time of call
;
;	    e)		     in the special region of working
;			     storage where names begin with r_.
;
;      2)   all pointers must point to the start of blocks with
;	    the sole exception of the contents of the code
;	    pointer register which points into the r_cod block.
;
;      3)   no location which appears to contain a pointer
;	    into the dynamic region may occur unless it is in
;	    fact a pointer to the start of the block. however
;	    pointers outside this area may occur and will
;	    not be changed by the garbage collector.
;	    it is especially important to make sure that xl
;	    does not contain a garbage value from some process
;	    carried out before the call to the collector.
;
;      gbcol has the capability of moving the final compacted
;      result up in memory (with addresses adjusted accordingly)
;      this is used to add space to the static region. the
;      entry value of wb is the number of bytes to move up.
;      the caller must guarantee that there is enough room.
;      furthermore the value in wb if it is non-zero, must be at
;      least 256 so that the mwb instruction conditions are met.
	ejc
;
;      gbcol (continued)
;
;      the algorithm, which is a modification of the lisp-2
;      garbage collector devised by r.dewar and k.belcher
;      takes three passes as follows.
;
;      1)   all pointers in memory are scanned and blocks in use
;	    determined from this scan. note that this procedure
;	    is recursive and uses the main stack for linkage.
;	    the marking process is thus similar to that used in
;	    a standard lisp collector. however the method of
;	    actually marking the blocks is different.
;
;	    the first field of a block normally contains a
;	    code entry point pointer. such an entry pointer
;	    can be distinguished from the address of any pointer
;	    to be processed by the collector. during garbage
;	    collection, this word is used to build a back chain
;	    of pointers through fields which point to the block.
;	    the end of the chain is marked by the occurence
;	    of the word which used to be in the first word of
;	    the block. this backchain serves both as a mark
;	    indicating that the block is in use and as a list of
;	    references for the relocation phase.
;
;      2)   storage is scanned sequentially to discover which
;	    blocks are currently in use as indicated by the
;	    presence of a backchain. two pointers are maintained
;	    one scans through looking at each block. the other
;	    is incremented only for blocks found to be in use.
;	    in this way, the eventual location of each block can
;	    be determined without actually moving any blocks.
;	    as each block which is in use is processed, the back
;	    chain is used to reset all pointers which point to
;	    this block to contain its new address, i.e. the
;	    address it will occupy after the blocks are moved.
;	    the first word of the block, taken from the end of
;	    the chain is restored at this point.
;
;	    during pass 2, the collector builds blocks which
;	    describe the regions of storage which are to be
;	    moved in the third pass. there is one descriptor for
;	    each contiguous set of good blocks. the descriptor
;	    is built just behind the block to be moved and
;	    contains a pointer to the next block and the number
;	    of words to be moved.
;
;      3)   in the third and final pass, the move descriptor
;	    blocks built in pass two are used to actually move
;	    the blocks down to the bottom of the dynamic region.
;	    the collection is then complete and the next
;	    available location pointer is reset.
	ejc
;
;      gbcol (continued)
;
.if    .csed
;      the garbage collector also recognizes the concept of
;      sediment.  sediment is defined as long-lived objects
;      which percipitate to the bottom of dynamic storage.
;      moving these objects during repeated collections is
;      inefficient.  it also contributes to thrashing on
;      systems with virtual memory.  in a typical worst-case
;      situation, there may be several megabytes of live objects
;      in the sediment, and only a few dead objects in need of
;      collection.  without recognising sediment, the standard
;      collector would move those megabytes of objects downward
;      to squeeze out the dead objects.	 this type of move
;      would result in excessive thrasing for very little memory
;      gain.
;
;      scanning of blocks in the sediment cannot be avoided
;      entirely, because these blocks may contain pointers to
;      live objects above the sediment.	 however, sediment
;      blocks need not be linked to a back chain as described
;      in pass one above.  since these blocks will not be moved,
;      pointers to them do not need to be adjusted.  eliminating
;      unnecessary back chain links increases locality of
;      reference, improving virtual memory performance.
;
;      because back chains are used to mark blocks whose con-
;      tents have been processed, a different marking system
.if    .cepp
;      is needed for blocks in the sediment.  since block type
;      words point to odd-parity entry addresses, merely incre-
;      menting the type word serves to mark the block as pro-
;      cessed.	during pass three, the type words are decre-
;      mented to restore them to their original value.
.else
;      is needed for blocks in the sediment.  all block type
;      words normally lie in the range b_aaa to p_yyy.	blocks
;      can be marked by adding an offset (created in gbcmk) to
;      move type words out of this range.  during pass three the
;      offset is subtracted to restore them to their original
;      value.
.fi
	ejc
;
;      gbcol (continued)
;
;
;      the variable dnams contains the number of bytes of memory
;      currently in the sediment.  setting dnams to zero will
;      eliminate the sediment and force it to be included in a
;      full garbage collection.	 gbcol returns a suggested new
;      value for dnams (usually dnamp-dnamb) in xr which the
;      caller can store in dnams if it wishes to maintain the
;      sediment.  that is, data remaining after a garbage
;      collection is considered to be sediment.	 if one accepts
;      the common lore that most objects are either very short-
;      or very long-lived, then this naive setting of dnams
;      probably includes some short-lived objects toward the end
;      of the sediment.
;
;      knowing when to reset dnams to zero to collect the sedi-
;      ment is not precisely known.  we force it to zero prior
;      to producing a dump, when gbcol is invoked by collect()
;      (so that the sediment is invisible to the user), when
;      sysmm is unable to obtain additional memory, and when
;      gbcol is called to relocate the dynamic area up in memory
;      (to make room for enlarging the static area).  if there
;      are no other reset situations, this leads to the inexo-
;      rable growth of the sediment, possible forcing a modest
;      program to begin to use virtual memory that it otherwise
;      would not.
;
;      as we scan sediment blocks in pass three, we maintain
;      aggregate counts of the amount of dead and live storage,
;      which is used to decide when to reset dnams.  when the
;      ratio of free storage found in the sediment to total
;      sediment size exceeds a threshold, the sediment is marked
;      for collection on the next gbcol call.
;
.fi
	ejc
;
;      gbcol (continued)
;
gbcol	prc	e,0			; entry point
;z-
	bnz	dmvch,gbc14		; fail if in mid-dump
	mnz	gbcfl			; note gbcol entered
	mov	gbsva,wa		; save entry wa
	mov	gbsvb,wb		; save entry wb
	mov	gbsvc,wc		; save entry wc
	mov	-(xs),xl		; save entry xl
	scp	wa			; get code pointer value
	sub	wa,r_cod		; make relative
	lcp	wa			; and restore
.if    .csed
	bze	wb,gbc0a		; check there is no move offset
	zer	dnams			; collect sediment if must move it
gbc0a	mov	wa,dnamb		; start of dynamic area
	add	wa,dnams		; size of sediment
	mov	gbcsd,wa		; first location past sediment
.if    .cepp
.else
	mov	wa,=p_yyy		; last entry point
	icv	wa			; address past last entry point
	sub	wa,=b_aaa		; size of entry point area
	mov	gbcmk,wa		; use to mark processed sed. blocks
.fi
.fi
.if    .cgbc
;
;      inform sysgc that collection to commence
;
	mnz	xr			; non-zero flags start of collection
	mov	wa,dnamb		; start of dynamic area
	mov	wb,dnamp		; next available location
	mov	wc,dname		; last available location + 1
	jsr	sysgc			; inform of collection
.fi
;
;      process stack entries
;
	mov	xr,xs			; point to stack front
	mov	xl,stbas		; point past end of stack
	bge	xl,xr,gbc00		; ok if d-stack
	mov	xr,xl			; reverse if ...
	mov	xl,xs			; ... u-stack
;
;      process the stack
;
gbc00	jsr	gbcpf			; process pointers on stack
;
;      process special work locations
;
	mov	xr,=r_aaa		; point to start of relocatable locs
	mov	xl,=r_yyy		; point past end of relocatable locs
	jsr	gbcpf			; process work fields
;
;      prepare to process variable blocks
;
	mov	wa,hshtb		; point to first hash slot pointer
;
;      loop through hash slots
;
gbc01	mov	xl,wa			; point to next slot
	ica	wa			; bump bucket pointer
	mov	gbcnm,wa		; save bucket pointer
	ejc
;
;      gbcol (continued)
;
;      loop through variables on one hash chain
;
gbc02	mov	xr,(xl)			; load ptr to next vrblk
	bze	xr,gbc03		; jump if end of chain
	mov	xl,xr			; else copy vrblk pointer
	add	xr,*vrval		; point to first reloc fld
	add	xl,*vrnxt		; point past last (and to link ptr)
	jsr	gbcpf			; process reloc fields in vrblk
	brn	gbc02			; loop back for next block
;
;      here at end of one hash chain
;
gbc03	mov	wa,gbcnm		; restore bucket pointer
	bne	wa,hshte,gbc01		; loop back if more buckets to go
	ejc
;
;      gbcol (continued)
;
;      now we are ready to start pass two. registers are used
;      as follows in pass two.
;
;      (xr)		     scans through all blocks
;      (wc)		     pointer to eventual location
;
;      the move description blocks built in this pass have
;      the following format.
;
;      word 1		     pointer to next move block,
;			     zero if end of chain of blocks
;
;      word 2		     length of blocks to be moved in
;			     bytes. set to the address of the
;			     first byte while actually scanning
;			     the blocks.
;
;      the first entry on this chain is a special entry
;      consisting of the two words gbcnm and gbcns. after
;      building the chain of move descriptors, gbcnm points to
;      the first real move block, and gbcns is the length of
;      blocks in use at the start of storage which need not
;      be moved since they are in the correct position.
;
.if    .csed
	mov	xr,dnamb		; point to first block
	zer	wb			; accumulate size of dead blocks
gbc04	beq	xr,gbcsd,gbc4c		; jump if end of sediment
	mov	wa,(xr)			; else get first word
.if    .cepp
	bod	wa,gbc4b		; jump if entry pointer (unused)
	dcv	wa			; restore entry pointer
.else
	bhi	wa,=p_yyy,gbc4a		; skip if not entry ptr (in use)
	bhi	wa,=b_aaa,gbc4b		; jump if entry pointer (unused)
gbc4a	sub	wa,gbcmk		; restore entry pointer
.fi
	mov	(xr),wa			; restore first word
	jsr	blkln			; get length of this block
	add	xr,wa			; bump actual pointer
	brn	gbc04			; continue scan through sediment
;
;      here for unused sediment block
;
gbc4b	jsr	blkln			; get length of this block
	add	xr,wa			; bump actual pointer
	add	wb,wa			; count size of unused blocks
	brn	gbc04			; continue scan through sediment
;
;      here at end of sediment.	 remember size of free blocks
;      within the sediment.  this will be used later to decide
;      how to set the sediment size returned to caller.
;
;      then scan rest of dynamic area above sediment.
;
;      (wb) = aggregate size of free blocks in sediment
;      (xr) = first location past sediment
;
gbc4c	mov	gbcsf,wb		; size of sediment free space
.else
	mov	xr,dnamb		; point to first block
.fi
	mov	wc,xr			; set as first eventual location
	add	wc,gbsvb		; add offset for eventual move up
	zer	gbcnm			; clear initial forward pointer
	mov	gbclm,=gbcnm		; initialize ptr to last move block
	mov	gbcns,xr		; initialize first address
;
;      loop through a series of blocks in use
;
gbc05	beq	xr,dnamp,gbc07		; jump if end of used region
	mov	wa,(xr)			; else get first word
.if    .cepp
	bod	wa,gbc07		; jump if entry pointer (unused)
.else
	bhi	wa,=p_yyy,gbc06		; skip if not entry ptr (in use)
	bhi	wa,=b_aaa,gbc07		; jump if entry pointer (unused)
.fi
;
;      here for block in use, loop to relocate references
;
gbc06	mov	xl,wa			; copy pointer
	mov	wa,(xl)			; load forward pointer
	mov	(xl),wc			; relocate reference
.if    .cepp
	bev	wa,gbc06		; loop back if not end of chain
.else
	bhi	wa,=p_yyy,gbc06		; loop back if not end of chain
	blo	wa,=b_aaa,gbc06		; loop back if not end of chain
.fi
	ejc
;
;      gbcol (continued)
;
;      at end of chain, restore first word and bump past
;
	mov	(xr),wa			; restore first word
	jsr	blkln			; get length of this block
	add	xr,wa			; bump actual pointer
	add	wc,wa			; bump eventual pointer
	brn	gbc05			; loop back for next block
;
;      here at end of a series of blocks in use
;
gbc07	mov	wa,xr			; copy pointer past last block
	mov	xl,gbclm		; point to previous move block
	sub	wa,num01(xl)		; subtract starting address
	mov	num01(xl),wa		; store length of block to be moved
;
;      loop through a series of blocks not in use
;
gbc08	beq	xr,dnamp,gbc10		; jump if end of used region
	mov	wa,(xr)			; else load first word of next block
.if    .cepp
	bev	wa,gbc09		; jump if in use
.else
	bhi	wa,=p_yyy,gbc09		; jump if in use
	blo	wa,=b_aaa,gbc09		; jump if in use
.fi
	jsr	blkln			; else get length of next block
	add	xr,wa			; push pointer
	brn	gbc08			; and loop back
;
;      here for a block in use after processing a series of
;      blocks which were not in use, build new move block.
;
gbc09	sub	xr,*num02		; point 2 words behind for move block
	mov	xl,gbclm		; point to previous move block
	mov	(xl),xr			; set forward ptr in previous block
	zer	(xr)			; zero forward ptr of new block
	mov	gbclm,xr		; remember address of this block
	mov	xl,xr			; copy ptr to move block
	add	xr,*num02		; point back to block in use
	mov	num01(xl),xr		; store starting address
	brn	gbc06			; jump to process block in use
	ejc
;
;      gbcol (continued)
;
;      here for pass three -- actually move the blocks down
;
;      (xl)		     pointer to old location
;      (xr)		     pointer to new location
;
.if    .csed
gbc10	mov	xr,gbcsd		; point to storage above sediment
.else
gbc10	mov	xr,dnamb		; point to start of storage
.fi
	add	xr,gbcns		; bump past unmoved blocks at start
;
;      loop through move descriptors
;
gbc11	mov	xl,gbcnm		; point to next move block
	bze	xl,gbc12		; jump if end of chain
	mov	gbcnm,(xl)+		; move pointer down chain
	mov	wa,(xl)+		; get length to move
	mvw				; perform move
	brn	gbc11			; loop back
;
;      now test for move up
;
gbc12	mov	dnamp,xr		; set next available loc ptr
	mov	wb,gbsvb		; reload move offset
	bze	wb,gbc13		; jump if no move required
	mov	xl,xr			; else copy old top of core
	add	xr,wb			; point to new top of core
	mov	dnamp,xr		; save new top of core pointer
	mov	wa,xl			; copy old top
	sub	wa,dnamb		; minus old bottom = length
	add	dnamb,wb		; bump bottom to get new value
	mwb				; perform move (backwards)
;
;      merge here to exit
;
gbc13	zer	xr			; clear garbage value in xr
	mov	gbcfl,xr		; note exit from gbcol
.if    .cgbc
	mov	wa,dnamb		; start of dynamic area
	mov	wb,dnamp		; next available location
	mov	wc,dname		; last available location + 1
	jsr	sysgc			; inform sysgc of completion
.fi
.if    .csed
;
;      decide whether to mark sediment for collection next time.
;      this is done by examining the ratio of previous sediment
;      free space to the new sediment size.
;
	sti	gbcia			; save ia
	zer	xr			; presume no sediment will remain
	mov	wb,gbcsf		; free space in sediment
	btw	wb			; convert bytes to words
	mti	wb			; put sediment free store in ia
	mli	gbsed			; multiply by sediment factor
	iov	gb13a			; jump if overflowed
	mov	wb,dnamp		; end of dynamic area in use
	sub	wb,dnamb		; minus start is sediment remaining
	btw	wb			; convert to words
	mov	gbcsf,wb		; store it
	sbi	gbcsf			; subtract from scaled up free store
	igt	gb13a			; jump if large free store in sedimnt
	mov	xr,dnamp		; below threshold, return sediment
	sub	xr,dnamb		; for use by caller
gb13a	ldi	gbcia			; restore ia
.fi
	mov	wa,gbsva		; restore wa
	mov	wb,gbsvb		; restore wb
	scp	wc			; get code pointer
	add	wc,r_cod		; make absolute again
	lcp	wc			; and replace absolute value
	mov	wc,gbsvc		; restore wc
	mov	xl,(xs)+		; restore entry xl
	icv	gbcnt			; increment count of collections
	exi				; exit to gbcol caller
;
;      garbage collection not allowed whilst dumping
;
gbc14	icv	errft			; fatal error
	erb	250,insufficient memory to complete dump
	enp				; end procedure gbcol
	ejc
;
;      gbcpf -- process fields for garbage collector
;
;      this procedure is used by the garbage collector to
;      process fields in pass one. see gbcol for full details.
;
;      (xr)		     ptr to first location to process
;      (xl)		     ptr past last location to process
;      jsr  gbcpf	     call to process fields
;      (xr,wa,wb,wc,ia)	     destroyed
;
;      note that although this procedure uses a recursive
;      approach, it controls its own stack and is not recursive.
;
gbcpf	prc	e,0			; entry point
	zer	-(xs)			; set zero to mark bottom of stack
	mov	-(xs),xl		; save end pointer
;
;      merge here to go down a level and start a new loop
;
;      1(xs)		     next lvl field ptr (0 at outer lvl)
;      0(xs)		     ptr past last field to process
;      (xr)		     ptr to first field to process
;
;      loop to process successive fields
;
gpf01	mov	xl,(xr)			; load field contents
	mov	wc,xr			; save field pointer
.if    .crpp
	bod	xl,gpf2a		; jump if not ptr into dynamic area
.fi
	blt	xl,dnamb,gpf2a		; jump if not ptr into dynamic area
	bge	xl,dnamp,gpf2a		; jump if not ptr into dynamic area
;
;      here we have a ptr to a block in the dynamic area.
;      link this field onto the reference backchain.
;
	mov	wa,(xl)			; load ptr to chain (or entry ptr)
.if    .csed
	blt	xl,gbcsd,gpf1a		; do not chain if within sediment
.fi
	mov	(xl),xr			; set this field as new head of chain
	mov	(xr),wa			; set forward pointer
;
;      now see if this block has been processed before
;
.if    .cepp
gpf1a	bod	wa,gpf03		; jump if not already processed
.else
gpf1a	bhi	wa,=p_yyy,gpf2a		; jump if already processed
	bhi	wa,=b_aaa,gpf03		; jump if not already processed
.fi
;
;      here to restore pointer in xr to field just processed
;
gpf02	mov	xr,wc			; restore field pointer
;
;      here to move to next field
;
gpf2a	ica	xr			; bump to next field
	bne	xr,(xs),gpf01		; loop back if more to go
	ejc
;
;      gbcpf (continued)
;
;      here we pop up a level after finishing a block
;
	mov	xl,(xs)+		; restore pointer past end
	mov	xr,(xs)+		; restore block pointer
	bnz	xr,gpf2a		; continue loop unless outer levl
	exi				; return to caller if outer level
;
;      here to process an active block which has not been done
;
.if    .csed
;
;      since sediment blocks are not marked by putting them on
;      the back chain, they must be explicitly marked in another
;      manner.	if odd parity entry points are present, mark by
;      temporarily converting to even parity.  if odd parity not
;      available, the entry point is adjusted by the value in
;      gbcmk.
;
gpf03	bge	xl,gbcsd,gpf3a		; if not within sediment
.if    .cepp
	icv	(xl)			; mark by making entry point even
.else
	add	(xl),gbcmk		; mark by biasing entry point
.fi
gpf3a	mov	xr,xl			; copy block pointer
.else
gpf03	mov	xr,xl			; copy block pointer
.fi
	mov	xl,wa			; copy first word of block
	lei	xl			; load entry point id (bl_xx)
;
;      block type switch. note that blocks with no relocatable
;      fields just return to gpf02 here to continue to next fld.
;
	bsw	xl,bl___		; switch on block type
	iff	bl_ar,gpf06		; arblk
.if    .cnbf
	iff	bl_bc,gpf02		; bcblk - dummy to fill out iffs
.else
	iff	bl_bc,gpf18		; bcblk
.fi
	iff	bl_bf,gpf02		; bfblk
	iff	bl_cc,gpf07		; ccblk
.if    .csln
	iff	bl_cd,gpf19		; cdblk
.else
	iff	bl_cd,gpf08		; cdblk
.fi
	iff	bl_cm,gpf04		; cmblk
	iff	bl_df,gpf02		; dfblk
	iff	bl_ev,gpf10		; evblk
	iff	bl_ex,gpf17		; exblk
	iff	bl_ff,gpf11		; ffblk
	iff	bl_nm,gpf10		; nmblk
	iff	bl_p0,gpf10		; p0blk
	iff	bl_p1,gpf12		; p1blk
	iff	bl_p2,gpf12		; p2blk
	iff	bl_pd,gpf13		; pdblk
	iff	bl_pf,gpf14		; pfblk
	iff	bl_tb,gpf08		; tbblk
	iff	bl_te,gpf15		; teblk
	iff	bl_tr,gpf16		; trblk
	iff	bl_vc,gpf08		; vcblk
	iff	bl_xr,gpf09		; xrblk
	iff	bl_ct,gpf02		; ctblk
	iff	bl_ef,gpf02		; efblk
	iff	bl_ic,gpf02		; icblk
	iff	bl_kv,gpf02		; kvblk
	iff	bl_rc,gpf02		; rcblk
	iff	bl_sc,gpf02		; scblk
	iff	bl_se,gpf02		; seblk
	iff	bl_xn,gpf02		; xnblk
	esw				; end of jump table
	ejc
;
;      gbcpf (continued)
;
;      cmblk
;
gpf04	mov	wa,cmlen(xr)		; load length
	mov	wb,*cmtyp		; set offset
;
;      here to push down to new level
;
;      (wc)		     field ptr at previous level
;      (xr)		     ptr to new block
;      (wa)		     length (reloc flds + flds at start)
;      (wb)		     offset to first reloc field
;
gpf05	add	wa,xr			; point past last reloc field
	add	xr,wb			; point to first reloc field
	mov	-(xs),wc		; stack old field pointer
	mov	-(xs),wa		; stack new limit pointer
	chk				; check for stack overflow
	brn	gpf01			; if ok, back to process
;
;      arblk
;
gpf06	mov	wa,arlen(xr)		; load length
	mov	wb,arofs(xr)		; set offset to 1st reloc fld (arpro)
	brn	gpf05			; all set
;
;      ccblk
;
gpf07	mov	wa,ccuse(xr)		; set length in use
	mov	wb,*ccuse		; 1st word (make sure at least one)
	brn	gpf05			; all set
	ejc
;
;      gbcpf (continued)
;
.if    .csln
;      cdblk
;
gpf19	mov	wa,cdlen(xr)		; load length
	mov	wb,*cdfal		; set offset
	brn	gpf05			; jump back
;
;      tbblk, vcblk
.else
;      cdblk, tbblk, vcblk
.fi
;
gpf08	mov	wa,offs2(xr)		; load length
	mov	wb,*offs3		; set offset
	brn	gpf05			; jump back
;
;      xrblk
;
gpf09	mov	wa,xrlen(xr)		; load length
	mov	wb,*xrptr		; set offset
	brn	gpf05			; jump back
;
;      evblk, nmblk, p0blk
;
gpf10	mov	wa,*offs2		; point past second field
	mov	wb,*offs1		; offset is one (only reloc fld is 2)
	brn	gpf05			; all set
;
;      ffblk
;
gpf11	mov	wa,*ffofs		; set length
	mov	wb,*ffnxt		; set offset
	brn	gpf05			; all set
;
;      p1blk, p2blk
;
gpf12	mov	wa,*parm2		; length (parm2 is non-relocatable)
	mov	wb,*pthen		; set offset
	brn	gpf05			; all set
	ejc
;
;      gbcpf (continued)
;
;      pdblk
;
gpf13	mov	xl,pddfp(xr)		; load ptr to dfblk
	mov	wa,dfpdl(xl)		; get pdblk length
	mov	wb,*pdfld		; set offset
	brn	gpf05			; all set
;
;      pfblk
;
gpf14	mov	wa,*pfarg		; length past last reloc
	mov	wb,*pfcod		; offset to first reloc
	brn	gpf05			; all set
;
;      teblk
;
gpf15	mov	wa,*tesi_		; set length
	mov	wb,*tesub		; and offset
	brn	gpf05			; all set
;
;      trblk
;
gpf16	mov	wa,*trsi_		; set length
	mov	wb,*trval		; and offset
	brn	gpf05			; all set
;
;      exblk
;
gpf17	mov	wa,exlen(xr)		; load length
	mov	wb,*exflc		; set offset
	brn	gpf05			; jump back
.if    .cnbf
.else
;
;      bcblk
;
gpf18	mov	wa,*bcsi_		; set length
	mov	wb,*bcbuf		; and offset
	brn	gpf05			; all set
.fi
	enp				; end procedure gbcpf
	ejc
;z+
;
;      gtarr -- get array
;
;      gtarr is passed an object and returns an array if possibl
;
;      (xr)		     value to be converted
;      (wa)		     0 to place table addresses in array
;			     non-zero for keys/values in array
;      jsr  gtarr	     call to get array
;      ppm  loc		     transfer loc for all null table
;      ppm  loc		     transfer loc if convert impossible
;      (xr)		     resulting array
;      (xl,wa,wb,wc)	     destroyed
;
gtarr	prc	e,2			; entry point
	mov	gtawa,wa		; save wa indicator
	mov	wa,(xr)			; load type word
	beq	wa,=b_art,gtar8		; exit if already an array
	beq	wa,=b_vct,gtar8		; exit if already an array
	bne	wa,=b_tbt,gta9a		; else fail if not a table (sgd02)
;
;      here we convert a table to an array
;
	mov	-(xs),xr		; replace tbblk pointer on stack
	zer	xr			; signal first pass
	zer	wb			; zero non-null element count
;
;      the following code is executed twice. on the first pass,
;      signalled by xr=0, the number of non-null elements in
;      the table is counted in wb. in the second pass, where
;      xr is a pointer into the arblk, the name and value are
;      entered into the current arblk location provided gtawa
;      is non-zero.  if gtawa is zero, the address of the teblk
;      is entered into the arblk twice (c3.762).
;
gtar1	mov	xl,(xs)			; point to table
	add	xl,tblen(xl)		; point past last bucket
	sub	xl,*tbbuk		; set first bucket offset
	mov	wa,xl			; copy adjusted pointer
;
;      loop through buckets in table block
;      next three lines of code rely on tenxt having a value
;      1 less than tbbuk.
;
gtar2	mov	xl,wa			; copy bucket pointer
	dca	wa			; decrement bucket pointer
;
;      loop through teblks on one bucket chain
;
gtar3	mov	xl,tenxt(xl)		; point to next teblk
	beq	xl,(xs),gtar6		; jump if chain end (tbblk ptr)
	mov	cnvtp,xl		; else save teblk pointer
;
;      loop to find value down trblk chain
;
gtar4	mov	xl,teval(xl)		; load value
	beq	(xl),=b_trt,gtar4	; loop till value found
	mov	wc,xl			; copy value
	mov	xl,cnvtp		; restore teblk pointer
	ejc
;
;      gtarr (continued)
;
;      now check for null and test cases
;
	beq	wc,=nulls,gtar3		; loop back to ignore null value
	bnz	xr,gtar5		; jump if second pass
	icv	wb			; for the first pass, bump count
	brn	gtar3			; and loop back for next teblk
;
;      here in second pass
;
gtar5	bze	gtawa,gta5a		; jump if address wanted
	mov	(xr)+,tesub(xl)		; store subscript name
	mov	(xr)+,wc		; store value in arblk
	brn	gtar3			; loop back for next teblk
;
;      here to record teblk address in arblk.  this allows
;      a sort routine to sort by ascending address.
;
gta5a	mov	(xr)+,xl		; store teblk address in name
	mov	(xr)+,xl		; and value slots
	brn	gtar3			; loop back for next teblk
;
;      here after scanning teblks on one chain
;
gtar6	bne	wa,(xs),gtar2		; loop back if more buckets to go
	bnz	xr,gtar7		; else jump if second pass
;
;      here after counting non-null elements
;
	bze	wb,gtar9		; fail if no non-null elements
	mov	wa,wb			; else copy count
	add	wa,wb			; double (two words/element)
	add	wa,=arvl2		; add space for standard fields
	wtb	wa			; convert length to bytes
	bgt	wa,mxlen,gta9b		; error if too long for array
	jsr	alloc			; else allocate space for arblk
	mov	(xr),=b_art		; store type word
	zer	idval(xr)		; zero id for the moment
	mov	arlen(xr),wa		; store length
	mov	arndm(xr),=num02	; set dimensions = 2
	ldi	intv1			; get integer one
	sti	arlbd(xr)		; store as lbd 1
	sti	arlb2(xr)		; store as lbd 2
	ldi	intv2			; load integer two
	sti	ardm2(xr)		; store as dim 2
	mti	wb			; get element count as integer
	sti	ardim(xr)		; store as dim 1
	zer	arpr2(xr)		; zero prototype field for now
	mov	arofs(xr),*arpr2	; set offset field (signal pass 2)
	mov	wb,xr			; save arblk pointer
	add	xr,*arvl2		; point to first element location
	brn	gtar1			; jump back to fill in elements
	ejc
;
;      gtarr (continued)
;
;      here after filling in element values
;
gtar7	mov	xr,wb			; restore arblk pointer
	mov	(xs),wb			; store as result
;
;      now we need the array prototype which is of the form nn,2
;      this is obtained by building the string for nn02 and
;      changing the zero to a comma before storing it.
;
	ldi	ardim(xr)		; get number of elements (nn)
	mli	intvh			; multiply by 100
	adi	intv2			; add 2 (nn02)
	jsr	icbld			; build integer
	mov	-(xs),xr		; store ptr for gtstg
	jsr	gtstg			; convert to string
	ppm				; convert fail is impossible
	mov	xl,xr			; copy string pointer
	mov	xr,(xs)+		; reload arblk pointer
	mov	arpr2(xr),xl		; store prototype ptr (nn02)
	sub	wa,=num02		; adjust length to point to zero
	psc	xl,wa			; point to zero
	mov	wb,=ch_cm		; load a comma
	sch	wb,(xl)			; store a comma over the zero
	csc	xl			; complete store characters
;
;      normal return
;
gtar8	exi				; return to caller
;
;      null table non-conversion return
;
gtar9	mov	xr,(xs)+		; restore stack for conv err (sgd02)
	exi	1			; return
;
;      impossible conversion return
;
gta9a	exi	2			; return
;
;      array size too large
;
gta9b	erb	260,conversion array size exceeds maximum permitted
	enp				; procedure gtarr
	ejc
;
;      gtcod -- convert to code
;
;      (xr)		     object to be converted
;      jsr  gtcod	     call to convert to code
;      ppm  loc		     transfer loc if convert impossible
;      (xr)		     pointer to resulting cdblk
;      (xl,wa,wb,wc,ra)	     destroyed
;
;      if a spitbol error occurs during compilation or pre-
;      evaluation, control is passed via error section to exfal
;      without returning to this routine.
;
gtcod	prc	e,1			; entry point
	beq	(xr),=b_cds,gtcd1	; jump if already code
	beq	(xr),=b_cdc,gtcd1	; jump if already code
;
;      here we must generate a cdblk by compilation
;
	mov	-(xs),xr		; stack argument for gtstg
	jsr	gtstg			; convert argument to string
	ppm	gtcd2			; jump if non-convertible
	mov	gtcef,flptr		; save fail ptr in case of error
	mov	r_gtc,r_cod		; also save code ptr
	mov	r_cim,xr		; else set image pointer
	mov	scnil,wa		; set image length
	zer	scnpt			; set scan pointer
	mov	stage,=stgxc		; set stage for execute compile
	mov	lstsn,cmpsn		; in case listr called
.if    .csln
	icv	cmpln			; bump line number
.fi
	jsr	cmpil			; compile string
	mov	stage,=stgxt		; reset stage for execute time
	zer	r_cim			; clear image
;
;      merge here if no convert required
;
gtcd1	exi				; give normal gtcod return
;
;      here if unconvertible
;
gtcd2	exi	1			; give error return
	enp				; end procedure gtcod
	ejc
;
;      gtexp -- convert to expression
;
.if    .cevb
;      (wb)		     0 if by value, 1 if by name
.fi
;      (xr)		     input value to be converted
;      jsr  gtexp	     call to convert to expression
;      ppm  loc		     transfer loc if convert impossible
;      (xr)		     pointer to result exblk or seblk
;      (xl,wa,wb,wc,ra)	     destroyed
;
;      if a spitbol error occurs during compilation or pre-
;      evaluation, control is passed via error section to exfal
;      without returning to this routine.
;
gtexp	prc	e,1			; entry point
	blo	(xr),=b_e__,gtex1	; jump if already an expression
	mov	-(xs),xr		; store argument for gtstg
	jsr	gtstg			; convert argument to string
	ppm	gtex2			; jump if unconvertible
;
;      check the last character of the string for colon or
;      semicolon.  these characters can legitimately end an
;      expression in open code, so expan will not detect them
;      as errors, but they are invalid as terminators for a
;      string that is being converted to expression form.
;
	mov	xl,xr			; copy input string pointer
	plc	xl,wa			; point one past the string end
	lch	xl,-(xl)		; fetch the last character
	beq	xl,=ch_cl,gtex2		; error if it is a semicolon
	beq	xl,=ch_sm,gtex2		; or if it is a colon
;
;      here we convert a string by compilation
;
	mov	r_cim,xr		; set input image pointer
	zer	scnpt			; set scan pointer
	mov	scnil,wa		; set input image length
.if    .cevb
	mov	-(xs),wb		; save value/name flag
.fi
	zer	wb			; set code for normal scan
	mov	gtcef,flptr		; save fail ptr in case of error
	mov	r_gtc,r_cod		; also save code ptr
	mov	stage,=stgev		; adjust stage for compile
	mov	scntp,=t_uok		; indicate unary operator acceptable
	jsr	expan			; build tree for expression
	zer	scnrs			; reset rescan flag
.if    .cevb
	mov	wa,(xs)+		; restore value/name flag
.fi
	bne	scnpt,scnil,gtex2	; error if not end of image
	zer	wb			; set ok value for cdgex call
	mov	xl,xr			; copy tree pointer
	jsr	cdgex			; build expression block
	zer	r_cim			; clear pointer
	mov	stage,=stgxt		; restore stage for execute time
;
;      merge here if no conversion required
;
gtex1	exi				; return to gtexp caller
;
;      here if unconvertible
;
gtex2	exi	1			; take error exit
	enp				; end procedure gtexp
	ejc
;
;      gtint -- get integer value
;
;      gtint is passed an object and returns an integer after
;      performing any necessary conversions.
;
;      (xr)		     value to be converted
;      jsr  gtint	     call to convert to integer
;      ppm  loc		     transfer loc for convert impossible
;      (xr)		     resulting integer
;      (wc,ra)		     destroyed
;      (wa,wb)		     destroyed (only on conversion err)
;      (xr)		     unchanged (on convert error)
;
gtint	prc	e,1			; entry point
	beq	(xr),=b_icl,gtin2	; jump if already an integer
	mov	gtina,wa		; else save wa
	mov	gtinb,wb		; save wb
	jsr	gtnum			; convert to numeric
	ppm	gtin3			; jump if unconvertible
.if    .cnra
.else
	beq	wa,=b_icl,gtin1		; jump if integer
;
;      here we convert a real to integer
;
	ldr	rcval(xr)		; load real value
	rti	gtin3			; convert to integer (err if ovflow)
	jsr	icbld			; if ok build icblk
.fi
;
;      here after successful conversion to integer
;
gtin1	mov	wa,gtina		; restore wa
	mov	wb,gtinb		; restore wb
;
;      common exit point
;
gtin2	exi				; return to gtint caller
;
;      here on conversion error
;
gtin3	exi	1			; take convert error exit
	enp				; end procedure gtint
	ejc
;
;      gtnum -- get numeric value
;
;      gtnum is given an object and returns either an integer
;      or a real, performing any necessary conversions.
;
;      (xr)		     object to be converted
;      jsr  gtnum	     call to convert to numeric
;      ppm  loc		     transfer loc if convert impossible
;      (xr)		     pointer to result (int or real)
;      (wa)		     first word of result block
;      (wb,wc,ra)	     destroyed
;      (xr)		     unchanged (on convert error)
;
gtnum	prc	e,1			; entry point
	mov	wa,(xr)			; load first word of block
	beq	wa,=b_icl,gtn34		; jump if integer (no conversion)
.if    .cnra
.else
	beq	wa,=b_rcl,gtn34		; jump if real (no conversion)
.fi
;
;      at this point the only possibility is to convert a string
;      to an integer or real as appropriate.
;
	mov	-(xs),xr		; stack argument in case convert err
	mov	-(xs),xr		; stack argument for gtstg
.if    .cnbf
	jsr	gtstg			; convert argument to string
.else
	jsr	gtstb			; get argument as string or buffer
.fi
	ppm	gtn36			; jump if unconvertible
;
;      initialize numeric conversion
;
	ldi	intv0			; initialize integer result to zero
	bze	wa,gtn32		; jump to exit with zero if null
	lct	wa,wa			; set bct counter for following loops
	zer	gtnnf			; tentatively indicate result +
.if    .cnra
.else
	sti	gtnex			; initialise exponent to zero
	zer	gtnsc			; zero scale in case real
	zer	gtndf			; reset flag for dec point found
	zer	gtnrd			; reset flag for digits found
	ldr	reav0			; zero real accum in case real
.fi
	plc	xr			; point to argument characters
;
;      merge back here after ignoring leading blank
;
gtn01	lch	wb,(xr)+		; load first character
	blt	wb,=ch_d0,gtn02		; jump if not digit
	ble	wb,=ch_d9,gtn06		; jump if first char is a digit
	ejc
;
;      gtnum (continued)
;
;      here if first digit is non-digit
;
gtn02	bne	wb,=ch_bl,gtn03		; jump if non-blank
gtna2	bct	wa,gtn01		; else decr count and loop back
	brn	gtn07			; jump to return zero if all blanks
;
;      here for first character non-blank, non-digit
;
gtn03	beq	wb,=ch_pl,gtn04		; jump if plus sign
.if    .caht
	beq	wb,=ch_ht,gtna2		; horizontal tab equiv to blank
.fi
.if    .cavt
	beq	wb,=ch_vt,gtna2		; vertical tab equiv to blank
.fi
.if    .cnra
	bne	wb,=ch_mn,gtn36		; else fail
.else
	bne	wb,=ch_mn,gtn12		; jump if not minus (may be real)
.fi
	mnz	gtnnf			; if minus sign, set negative flag
;
;      merge here after processing sign
;
gtn04	bct	wa,gtn05		; jump if chars left
	brn	gtn36			; else error
;
;      loop to fetch characters of an integer
;
gtn05	lch	wb,(xr)+		; load next character
	blt	wb,=ch_d0,gtn08		; jump if not a digit
	bgt	wb,=ch_d9,gtn08		; jump if not a digit
;
;      merge here for first digit
;
gtn06	sti	gtnsi			; save current value
.if    .cnra
	cvm	gtn36			; current*10-(new dig) jump if ovflow
.else
	cvm	gtn35			; current*10-(new dig) jump if ovflow
	mnz	gtnrd			; set digit read flag
.fi
	bct	wa,gtn05		; else loop back if more chars
;
;      here to exit with converted integer value
;
gtn07	bnz	gtnnf,gtn32		; jump if negative (all set)
	ngi				; else negate
	ino	gtn32			; jump if no overflow
	brn	gtn36			; else signal error
	ejc
;
;      gtnum (continued)
;
;      here for a non-digit character while attempting to
;      convert an integer, check for trailing blanks or real.
;
gtn08	beq	wb,=ch_bl,gtna9		; jump if a blank
.if    .caht
	beq	wb,=ch_ht,gtna9		; jump if horizontal tab
.fi
.if    .cavt
	beq	wb,=ch_vt,gtna9		; jump if vertical tab
.fi
.if    .cnra
	brn	gtn36			; error
.else
	itr				; else convert integer to real
	ngr				; negate to get positive value
	brn	gtn12			; jump to try for real
.fi
;
;      here we scan out blanks to end of string
;
gtn09	lch	wb,(xr)+		; get next char
.if    .caht
	beq	wb,=ch_ht,gtna9		; jump if horizontal tab
.fi
.if    .cavt
	beq	wb,=ch_vt,gtna9		; jump if vertical tab
.fi
	bne	wb,=ch_bl,gtn36		; error if non-blank
gtna9	bct	wa,gtn09		; loop back if more chars to check
	brn	gtn07			; return integer if all blanks
.if    .cnra
.else
;
;      loop to collect mantissa of real
;
gtn10	lch	wb,(xr)+		; load next character
	blt	wb,=ch_d0,gtn12		; jump if non-numeric
	bgt	wb,=ch_d9,gtn12		; jump if non-numeric
;
;      merge here to collect first real digit
;
gtn11	sub	wb,=ch_d0		; convert digit to number
	mlr	reavt			; multiply real by 10.0
	rov	gtn36			; convert error if overflow
	str	gtnsr			; save result
	mti	wb			; get new digit as integer
	itr				; convert new digit to real
	adr	gtnsr			; add to get new total
	add	gtnsc,gtndf		; increment scale if after dec point
	mnz	gtnrd			; set digit found flag
	bct	wa,gtn10		; loop back if more chars
	brn	gtn22			; else jump to scale
	ejc
;
;      gtnum (continued)
;
;      here if non-digit found while collecting a real
;
gtn12	bne	wb,=ch_dt,gtn13		; jump if not dec point
	bnz	gtndf,gtn36		; if dec point, error if one already
	mov	gtndf,=num01		; else set flag for dec point
	bct	wa,gtn10		; loop back if more chars
	brn	gtn22			; else jump to scale
;
;      here if not decimal point
;
gtn13	beq	wb,=ch_le,gtn15		; jump if e for exponent
	beq	wb,=ch_ld,gtn15		; jump if d for exponent
.if    .culc
	beq	wb,=ch_ue,gtn15		; jump if e for exponent
	beq	wb,=ch_ud,gtn15		; jump if d for exponent
.fi
;
;      here check for trailing blanks
;
gtn14	beq	wb,=ch_bl,gtnb4		; jump if blank
.if    .caht
	beq	wb,=ch_ht,gtnb4		; jump if horizontal tab
.fi
.if    .cavt
	beq	wb,=ch_vt,gtnb4		; jump if vertical tab
.fi
	brn	gtn36			; error if non-blank
;
gtnb4	lch	wb,(xr)+		; get next character
	bct	wa,gtn14		; loop back to check if more
	brn	gtn22			; else jump to scale
;
;      here to read and process an exponent
;
gtn15	zer	gtnes			; set exponent sign positive
	ldi	intv0			; initialize exponent to zero
	mnz	gtndf			; reset no dec point indication
	bct	wa,gtn16		; jump skipping past e or d
	brn	gtn36			; error if null exponent
;
;      check for exponent sign
;
gtn16	lch	wb,(xr)+		; load first exponent character
	beq	wb,=ch_pl,gtn17		; jump if plus sign
	bne	wb,=ch_mn,gtn19		; else jump if not minus sign
	mnz	gtnes			; set sign negative if minus sign
;
;      merge here after processing exponent sign
;
gtn17	bct	wa,gtn18		; jump if chars left
	brn	gtn36			; else error
;
;      loop to convert exponent digits
;
gtn18	lch	wb,(xr)+		; load next character
	ejc
;
;      gtnum (continued)
;
;      merge here for first exponent digit
;
gtn19	blt	wb,=ch_d0,gtn20		; jump if not digit
	bgt	wb,=ch_d9,gtn20		; jump if not digit
	cvm	gtn36			; else current*10, subtract new digit
	bct	wa,gtn18		; loop back if more chars
	brn	gtn21			; jump if exponent field is exhausted
;
;      here to check for trailing blanks after exponent
;
gtn20	beq	wb,=ch_bl,gtnc0		; jump if blank
.if    .caht
	beq	wb,=ch_ht,gtnc0		; jump if horizontal tab
.fi
.if    .cavt
	beq	wc,=ch_vt,gtnc0		; jump if vertical tab
.fi
	brn	gtn36			; error if non-blank
;
gtnc0	lch	wb,(xr)+		; get next character
	bct	wa,gtn20		; loop back till all blanks scanned
;
;      merge here after collecting exponent
;
gtn21	sti	gtnex			; save collected exponent
	bnz	gtnes,gtn22		; jump if it was negative
	ngi				; else complement
	iov	gtn36			; error if overflow
	sti	gtnex			; and store positive exponent
;
;      merge here with exponent (0 if none given)
;
gtn22	bze	gtnrd,gtn36		; error if not digits collected
	bze	gtndf,gtn36		; error if no exponent or dec point
	mti	gtnsc			; else load scale as integer
	sbi	gtnex			; subtract exponent
	iov	gtn36			; error if overflow
	ilt	gtn26			; jump if we must scale up
;
;      here we have a negative exponent, so scale down
;
	mfi	wa,gtn36		; load scale factor, err if ovflow
;
;      loop to scale down in steps of 10**10
;
gtn23	ble	wa,=num10,gtn24		; jump if 10 or less to go
	dvr	reatt			; else divide by 10**10
	sub	wa,=num10		; decrement scale
	brn	gtn23			; and loop back
	ejc
;
;      gtnum (continued)
;
;      here scale rest of way from powers of ten table
;
gtn24	bze	wa,gtn30		; jump if scaled
	lct	wb,=cfp_r		; else get indexing factor
	mov	xr,=reav1		; point to powers of ten table
	wtb	wa			; convert remaining scale to byte ofs
;
;      loop to point to powers of ten table entry
;
gtn25	add	xr,wa			; bump pointer
	bct	wb,gtn25		; once for each value word
	dvr	(xr)			; scale down as required
	brn	gtn30			; and jump
;
;      come here to scale result up (positive exponent)
;
gtn26	ngi				; get absolute value of exponent
	iov	gtn36			; error if overflow
	mfi	wa,gtn36		; acquire scale, error if ovflow
;
;      loop to scale up in steps of 10**10
;
gtn27	ble	wa,=num10,gtn28		; jump if 10 or less to go
	mlr	reatt			; else multiply by 10**10
	rov	gtn36			; error if overflow
	sub	wa,=num10		; else decrement scale
	brn	gtn27			; and loop back
;
;      here to scale up rest of way with table
;
gtn28	bze	wa,gtn30		; jump if scaled
	lct	wb,=cfp_r		; else get indexing factor
	mov	xr,=reav1		; point to powers of ten table
	wtb	wa			; convert remaining scale to byte ofs
;
;      loop to point to proper entry in powers of ten table
;
gtn29	add	xr,wa			; bump pointer
	bct	wb,gtn29		; once for each word in value
	mlr	(xr)			; scale up
	rov	gtn36			; error if overflow
	ejc
;
;      gtnum (continued)
;
;      here with real value scaled and ready except for sign
;
gtn30	bze	gtnnf,gtn31		; jump if positive
	ngr				; else negate
;
;      here with properly signed real value in (ra)
;
gtn31	jsr	rcbld			; build real block
	brn	gtn33			; merge to exit
.fi
;
;      here with properly signed integer value in (ia)
;
gtn32	jsr	icbld			; build icblk
;
;      real merges here
;
gtn33	mov	wa,(xr)			; load first word of result block
	ica	xs			; pop argument off stack
;
;      common exit point
;
gtn34	exi				; return to gtnum caller
.if    .cnra
.else
;
;      come here if overflow occurs during collection of integer
;      have to restore wb which cvm may have destroyed.
;
gtn35	lch	wb,-(xr)		; reload current character
	lch	wb,(xr)+		; bump character pointer
	ldi	gtnsi			; reload integer so far
	itr				; convert to real
	ngr				; make value positive
	brn	gtn11			; merge with real circuit
.fi
;
;      here for unconvertible to string or conversion error
;
gtn36	mov	xr,(xs)+		; reload original argument
	exi	1			; take convert-error exit
	enp				; end procedure gtnum
	ejc
;
;      gtnvr -- convert to natural variable
;
;      gtnvr locates a variable block (vrblk) given either an
;      appropriate name (nmblk) or a non-null string (scblk).
;
;      (xr)		     argument
;      jsr  gtnvr	     call to convert to natural variable
;      ppm  loc		     transfer loc if convert impossible
;      (xr)		     pointer to vrblk
;      (wa,wb)		     destroyed (conversion error only)
;      (wc)		     destroyed
;
gtnvr	prc	e,1			; entry point
;z-
	bne	(xr),=b_nml,gnv02	; jump if not name
	mov	xr,nmbas(xr)		; else load name base if name
	blo	xr,state,gnv07		; skip if vrblk (in static region)
;
;      common error exit
;
gnv01	exi	1			; take convert-error exit
;
;      here if not name
;
gnv02	mov	gnvsa,wa		; save wa
	mov	gnvsb,wb		; save wb
	mov	-(xs),xr		; stack argument for gtstg
	jsr	gtstg			; convert argument to string
	ppm	gnv01			; jump if conversion error
	bze	wa,gnv01		; null string is an error
.if    .culc
	jsr	flstg			; fold upper case to lower case
.fi
	mov	-(xs),xl		; save xl
	mov	-(xs),xr		; stack string ptr for later
	mov	wb,xr			; copy string pointer
	add	wb,*schar		; point to characters of string
	mov	gnvst,wb		; save pointer to characters
	mov	wb,wa			; copy length
	ctw	wb,0			; get number of words in name
	mov	gnvnw,wb		; save for later
	jsr	hashs			; compute hash index for string
	rmi	hshnb			; compute hash offset by taking mod
	mfi	wc			; get as offset
	wtb	wc			; convert offset to bytes
	add	wc,hshtb		; point to proper hash chain
	sub	wc,*vrnxt		; subtract offset to merge into loop
	ejc
;
;      gtnvr (continued)
;
;      loop to search hash chain
;
gnv03	mov	xl,wc			; copy hash chain pointer
	mov	xl,vrnxt(xl)		; point to next vrblk on chain
	bze	xl,gnv08		; jump if end of chain
	mov	wc,xl			; save pointer to this vrblk
	bnz	vrlen(xl),gnv04		; jump if not system variable
	mov	xl,vrsvp(xl)		; else point to svblk
	sub	xl,*vrsof		; adjust offset for merge
;
;      merge here with string ptr (like vrblk) in xl
;
gnv04	bne	wa,vrlen(xl),gnv03	; back for next vrblk if lengths ne
	add	xl,*vrchs		; else point to chars of chain entry
	lct	wb,gnvnw		; get word counter to control loop
	mov	xr,gnvst		; point to chars of new name
;
;      loop to compare characters of the two names
;
gnv05	cne	(xr),(xl),gnv03		; jump if no match for next vrblk
	ica	xr			; bump new name pointer
	ica	xl			; bump vrblk in chain name pointer
	bct	wb,gnv05		; else loop till all compared
	mov	xr,wc			; we have found a match, get vrblk
;
;      exit point after finding vrblk or building new one
;
gnv06	mov	wa,gnvsa		; restore wa
	mov	wb,gnvsb		; restore wb
	ica	xs			; pop string pointer
	mov	xl,(xs)+		; restore xl
;
;      common exit point
;
gnv07	exi				; return to gtnvr caller
;
;      not found, prepare to search system variable table
;
gnv08	zer	xr			; clear garbage xr pointer
	mov	gnvhe,wc		; save ptr to end of hash chain
	bgt	wa,=num09,gnv14		; cannot be system var if length gt 9
	mov	xl,wa			; else copy length
	wtb	xl			; convert to byte offset
	mov	xl,vsrch(xl)		; point to first svblk of this length
	ejc
;
;      gtnvr (continued)
;
;      loop to search entries in standard variable table
;
gnv09	mov	gnvsp,xl		; save table pointer
	mov	wc,(xl)+		; load svbit bit string
	mov	wb,(xl)+		; load length from table entry
	bne	wa,wb,gnv14		; jump if end of right length entries
	lct	wb,gnvnw		; get word counter to control loop
	mov	xr,gnvst		; point to chars of new name
;
;      loop to check for matching names
;
gnv10	cne	(xr),(xl),gnv11		; jump if name mismatch
	ica	xr			; else bump new name pointer
	ica	xl			; bump svblk pointer
	bct	wb,gnv10		; else loop until all checked
;
;      here we have a match in the standard variable table
;
	zer	wc			; set vrlen value zero
	mov	wa,*vrsi_		; set standard size
	brn	gnv15			; jump to build vrblk
;
;      here if no match with table entry in svblks table
;
gnv11	ica	xl			; bump past word of chars
	bct	wb,gnv11		; loop back if more to go
	rsh	wc,svnbt		; remove uninteresting bits
;
;      loop to bump table ptr for each flagged word
;
gnv12	mov	wb,bits1		; load bit to test
	anb	wb,wc			; test for word present
	zrb	wb,gnv13		; jump if not present
	ica	xl			; else bump table pointer
;
;      here after dealing with one word (one bit)
;
gnv13	rsh	wc,1			; remove bit already processed
	nzb	wc,gnv12		; loop back if more bits to test
	brn	gnv09			; else loop back for next svblk
;
;      here if not system variable
;
gnv14	mov	wc,wa			; copy vrlen value
	mov	wa,=vrchs		; load standard size -chars
	add	wa,gnvnw		; adjust for chars of name
	wtb	wa			; convert length to bytes
	ejc
;
;      gtnvr (continued)
;
;      merge here to build vrblk
;
gnv15	jsr	alost			; allocate space for vrblk (static)
	mov	wb,xr			; save vrblk pointer
	mov	xl,=stnvr		; point to model variable block
	mov	wa,*vrlen		; set length of standard fields
	mvw				; set initial fields of new block
	mov	xl,gnvhe		; load pointer to end of hash chain
	mov	vrnxt(xl),wb		; add new block to end of chain
	mov	(xr)+,wc		; set vrlen field, bump ptr
	mov	wa,gnvnw		; get length in words
	wtb	wa			; convert to length in bytes
	bze	wc,gnv16		; jump if system variable
;
;      here for non-system variable -- set chars of name
;
	mov	xl,(xs)			; point back to string name
	add	xl,*schar		; point to chars of name
	mvw				; move characters into place
	mov	xr,wb			; restore vrblk pointer
	brn	gnv06			; jump back to exit
;
;      here for system variable case to fill in fields where
;      necessary from the fields present in the svblk.
;
gnv16	mov	xl,gnvsp		; load pointer to svblk
	mov	(xr),xl			; set svblk ptr in vrblk
	mov	xr,wb			; restore vrblk pointer
	mov	wb,svbit(xl)		; load bit indicators
	add	xl,*svchs		; point to characters of name
	add	xl,wa			; point past characters
;
;      skip past keyword number (svknm) if present
;
	mov	wc,btknm		; load test bit
	anb	wc,wb			; and to test
	zrb	wc,gnv17		; jump if no keyword number
	ica	xl			; else bump pointer
	ejc
;
;      gtnvr (continued)
;
;      here test for function (svfnc and svnar)
;
gnv17	mov	wc,btfnc		; get test bit
	anb	wc,wb			; and to test
	zrb	wc,gnv18		; skip if no system function
	mov	vrfnc(xr),xl		; else point vrfnc to svfnc field
	add	xl,*num02		; and bump past svfnc, svnar fields
;
;      now test for label (svlbl)
;
gnv18	mov	wc,btlbl		; get test bit
	anb	wc,wb			; and to test
	zrb	wc,gnv19		; jump if bit is off (no system labl)
	mov	vrlbl(xr),xl		; else point vrlbl to svlbl field
	ica	xl			; bump past svlbl field
;
;      now test for value (svval)
;
gnv19	mov	wc,btval		; load test bit
	anb	wc,wb			; and to test
	zrb	wc,gnv06		; all done if no value
	mov	vrval(xr),(xl)		; else set initial value
	mov	vrsto(xr),=b_vre	; set error store access
	brn	gnv06			; merge back to exit to caller
	enp				; end procedure gtnvr
	ejc
;
;      gtpat -- get pattern
;
;      gtpat is passed an object in (xr) and returns a
;      pattern after performing any necessary conversions
;
;      (xr)		     input argument
;      jsr  gtpat	     call to convert to pattern
;      ppm  loc		     transfer loc if convert impossible
;      (xr)		     resulting pattern
;      (wa)		     destroyed
;      (wb)		     destroyed (only on convert error)
;      (xr)		     unchanged (only on convert error)
;
gtpat	prc	e,1			; entry point
;z+
	bhi	(xr),=p_aaa,gtpt5	; jump if pattern already
;
;      here if not pattern, try for string
;
	mov	gtpsb,wb		; save wb
	mov	-(xs),xr		; stack argument for gtstg
	jsr	gtstg			; convert argument to string
	ppm	gtpt2			; jump if impossible
;
;      here we have a string
;
	bnz	wa,gtpt1		; jump if non-null
;
;      here for null string. generate pointer to null pattern.
;
	mov	xr,=ndnth		; point to nothen node
	brn	gtpt4			; jump to exit
	ejc
;
;      gtpat (continued)
;
;      here for non-null string
;
gtpt1	mov	wb,=p_str		; load pcode for multi-char string
	bne	wa,=num01,gtpt3		; jump if multi-char string
;
;      here for one character string, share one character any
;
	plc	xr			; point to character
	lch	wa,(xr)			; load character
	mov	xr,wa			; set as parm1
	mov	wb,=p_ans		; point to pcode for 1-char any
	brn	gtpt3			; jump to build node
;
;      here if argument is not convertible to string
;
gtpt2	mov	wb,=p_exa		; set pcode for expression in case
	blo	(xr),=b_e__,gtpt3	; jump to build node if expression
;
;      here we have an error (conversion impossible)
;
	exi	1			; take convert error exit
;
;      merge here to build node for string or expression
;
gtpt3	jsr	pbild			; call routine to build pattern node
;
;      common exit after successful conversion
;
gtpt4	mov	wb,gtpsb		; restore wb
;
;      merge here to exit if no conversion required
;
gtpt5	exi				; return to gtpat caller
	enp				; end procedure gtpat
.if    .cnra
.else
	ejc
;
;      gtrea -- get real value
;
;      gtrea is passed an object and returns a real value
;      performing any necessary conversions.
;
;      (xr)		     object to be converted
;      jsr  gtrea	     call to convert object to real
;      ppm  loc		     transfer loc if convert impossible
;      (xr)		     pointer to resulting real
;      (wa,wb,wc,ra)	     destroyed
;      (xr)		     unchanged (convert error only)
;
gtrea	prc	e,1			; entry point
	mov	wa,(xr)			; get first word of block
	beq	wa,=b_rcl,gtre2		; jump if real
	jsr	gtnum			; else convert argument to numeric
	ppm	gtre3			; jump if unconvertible
	beq	wa,=b_rcl,gtre2		; jump if real was returned
;
;      here for case of an integer to convert to real
;
gtre1	ldi	icval(xr)		; load integer
	itr				; convert to real
	jsr	rcbld			; build rcblk
;
;      exit with real
;
gtre2	exi				; return to gtrea caller
;
;      here on conversion error
;
gtre3	exi	1			; take convert error exit
	enp				; end procedure gtrea
.fi
	ejc
;
;      gtsmi -- get small integer
;
;      gtsmi is passed a snobol object and returns an address
;      integer in the range (0 le n le dnamb). such a value can
;      only be derived from an integer in the appropriate range.
;      small integers never appear as snobol values. however,
;      they are used internally for a variety of purposes.
;
;      -(xs)		     argument to convert (on stack)
;      jsr  gtsmi	     call to convert to small integer
;      ppm  loc		     transfer loc for not integer
;      ppm  loc		     transfer loc for lt 0, gt dnamb
;      (xr,wc)		     resulting small int (two copies)
;      (xs)		     popped
;      (ra)		     destroyed
;      (wa,wb)		     destroyed (on convert error only)
;      (xr)		     input arg (convert error only)
;
gtsmi	prc	n,2			; entry point
	mov	xr,(xs)+		; load argument
	beq	(xr),=b_icl,gtsm1	; skip if already an integer
;
;      here if not an integer
;
	jsr	gtint			; convert argument to integer
	ppm	gtsm2			; jump if convert is impossible
;
;      merge here with integer
;
gtsm1	ldi	icval(xr)		; load integer value
	mfi	wc,gtsm3		; move as one word, jump if ovflow
	bgt	wc,mxlen,gtsm3		; or if too large
	mov	xr,wc			; copy result to xr
	exi				; return to gtsmi caller
;
;      here if unconvertible to integer
;
gtsm2	exi	1			; take non-integer error exit
;
;      here if out of range
;
gtsm3	exi	2			; take out-of-range error exit
	enp				; end procedure gtsmi
	ejc
.if    .cnbf
.else
;
;      gtstb -- get string or buffer
;
;      gtstb is passed an object and returns it unchanged if
;      it is a buffer block, else it returns it as a string with
;      any necessary conversions performed.
;
;      -(xs)		     input argument (on stack)
;      jsr  gtstb	     call to get buffer or cnvrt to stg
;      ppm  loc		     transfer loc if convert impossible
;      (xr)		     pointer to resulting scblk or bfblk
;      (wa)		     length of string in characters
;      (wb)		     zero/bcblk if string/buffer
;      (xs)		     popped
;      (ra)		     destroyed
;      (xr)		     input arg (convert error only)
;
gtstb	prc	n,1			; entry point
	mov	xr,(xs)			; load argument, leave on stack
	mov	wa,(xr)			; load block type
	beq	wa,=b_scl,gtsb2		; jump if already a string
	beq	wa,=b_bct,gtsb3		; jump if already a buffer
	jsr	gtstg			; convert to string
	ppm	gtsb1			; conversion failed
	zer	wb			; signal string result
	exi				; convert with string result
;
;      here if conversion failed
;
gtsb1	exi	1			; take convert error exit
;
;      here if a string already
;
gtsb2	ica	xs			; pop argument
	mov	wa,sclen(xr)		; load string length
	zer	wb			; signal string result
	exi				; return with string result
;
;      here if it is already a buffer
;
gtsb3	ica	xs			; pop argument
	mov	wa,bclen(xr)		; load length of string in buffer
	mov	wb,xr			; return bcblk pointer in wb
	mov	xr,bcbuf(xr)		; return bfblk pointer in xr
	exi				; return with buffer result
	enp				; end procedure gtstg
	ejc
.fi
;
;      gtstg -- get string
;
;      gtstg is passed an object and returns a string with
;      any necessary conversions performed.
;
;      -(xs)		     input argument (on stack)
;      jsr  gtstg	     call to convert to string
;      ppm  loc		     transfer loc if convert impossible
;      (xr)		     pointer to resulting string
;      (wa)		     length of string in characters
;      (xs)		     popped
;      (ra)		     destroyed
;      (xr)		     input arg (convert error only)
;
gtstg	prc	n,1			; entry point
	mov	xr,(xs)+		; load argument, pop stack
	beq	(xr),=b_scl,gts30	; jump if already a string
;
;      here if not a string already
;
gts01	mov	-(xs),xr		; restack argument in case error
	mov	-(xs),xl		; save xl
	mov	gtsvb,wb		; save wb
	mov	gtsvc,wc		; save wc
	mov	wa,(xr)			; load first word of block
	beq	wa,=b_icl,gts05		; jump to convert integer
.if    .cnra
.else
	beq	wa,=b_rcl,gts10		; jump to convert real
.fi
	beq	wa,=b_nml,gts03		; jump to convert name
.if    .cnbf
.else
	beq	wa,=b_bct,gts32		; jump to convert buffer
.fi
;
;      here on conversion error
;
gts02	mov	xl,(xs)+		; restore xl
	mov	xr,(xs)+		; reload input argument
	exi	1			; take convert error exit
	ejc
;
;      gtstg (continued)
;
;      here to convert a name (only possible if natural var)
;
gts03	mov	xl,nmbas(xr)		; load name base
	bhi	xl,state,gts02		; error if not natural var (static)
	add	xl,*vrsof		; else point to possible string name
	mov	wa,sclen(xl)		; load length
	bnz	wa,gts04		; jump if not system variable
	mov	xl,vrsvo(xl)		; else point to svblk
	mov	wa,svlen(xl)		; and load name length
;
;      merge here with string in xr, length in wa
;
gts04	zer	wb			; set offset to zero
	jsr	sbstr			; use sbstr to copy string
	brn	gts29			; jump to exit
;
;      come here to convert an integer
;
gts05	ldi	icval(xr)		; load integer value
.if    .cnci
	jsr	sysci			; convert integer
	mov	wa,sclen(xl)		; get length
	zer	wb			; zero offset for sbstr
	jsr	sbstr			; copy in result from sysci
	brn	gts29			; exit
.else
	mov	gtssf,=num01		; set sign flag negative
	ilt	gts06			; skip if integer is negative
	ngi				; else negate integer
	zer	gtssf			; and reset negative flag
	ejc
;
;      gtstg (continued)
;
;      here with sign flag set and sign forced negative as
;      required by the cvd instruction.
;
gts06	mov	xr,gtswk		; point to result work area
	mov	wb,=nstmx		; initialize counter to max length
	psc	xr,wb			; prepare to store (right-left)
;
;      loop to convert digits into work area
;
gts07	cvd				; convert one digit into wa
	sch	wa,-(xr)		; store in work area
	dcv	wb			; decrement counter
	ine	gts07			; loop if more digits to go
	csc	xr			; complete store characters
.fi
;
;      merge here after converting integer or real into work
;      area. wb is set to nstmx - (number of chars in result).
;
gts08	mov	wa,=nstmx		; get max number of characters
	sub	wa,wb			; compute length of result
	mov	xl,wa			; remember length for move later on
	add	wa,gtssf		; add one for negative sign if needed
	jsr	alocs			; allocate string for result
	mov	wc,xr			; save result pointer for the moment
	psc	xr			; point to chars of result block
	bze	gtssf,gts09		; skip if positive
	mov	wa,=ch_mn		; else load negative sign
	sch	wa,(xr)+		; and store it
	csc	xr			; complete store characters
;
;      here after dealing with sign
;
gts09	mov	wa,xl			; recall length to move
	mov	xl,gtswk		; point to result work area
	plc	xl,wb			; point to first result character
	mvc				; move chars to result string
	mov	xr,wc			; restore result pointer
.if    .cnra
.else
	brn	gts29			; jump to exit
	ejc
;
;      gtstg (continued)
;
;      here to convert a real
;
gts10	ldr	rcval(xr)		; load real
.if    .cncr
	mov	wa,=nstmr		; max number of result chars
	zer	xl			; clear dud value
	jsr	alocs			; allocate result area
	mov	wa,=cfp_s		; significant digits to produce
	zer	wb			; conversion type
	jsr	syscr			; convert real to string
	mov	sclen(xr),wa		; store result size
	zer	wb			; no trailing blanks to remove
	jsr	trimr			; discard excess memory
.else
	zer	gtssf			; reset negative flag
	req	gts31			; skip if zero
	rge	gts11			; jump if real is positive
	mov	gtssf,=num01		; else set negative flag
	ngr				; and get absolute value of real
;
;      now scale the real to the range (0.1 le x lt 1.0)
;
gts11	ldi	intv0			; initialize exponent to zero
;
;      loop to scale up in steps of 10**10
;
gts12	str	gtsrs			; save real value
	sbr	reap1			; subtract 0.1 to compare
	rge	gts13			; jump if scale up not required
	ldr	gtsrs			; else reload value
	mlr	reatt			; multiply by 10**10
	sbi	intvt			; decrement exponent by 10
	brn	gts12			; loop back to test again
;
;      test for scale down required
;
gts13	ldr	gtsrs			; reload value
	sbr	reav1			; subtract 1.0
	rlt	gts17			; jump if no scale down required
	ldr	gtsrs			; else reload value
;
;      loop to scale down in steps of 10**10
;
gts14	sbr	reatt			; subtract 10**10 to compare
	rlt	gts15			; jump if large step not required
	ldr	gtsrs			; else restore value
	dvr	reatt			; divide by 10**10
	str	gtsrs			; store new value
	adi	intvt			; increment exponent by 10
	brn	gts14			; loop back
	ejc
;
;      gtstg (continued)
;
;      at this point we have (1.0 le x lt 10**10)
;      complete scaling with powers of ten table
;
gts15	mov	xr,=reav1		; point to powers of ten table
;
;      loop to locate correct entry in table
;
gts16	ldr	gtsrs			; reload value
	adi	intv1			; increment exponent
	add	xr,*cfp_r		; point to next entry in table
	sbr	(xr)			; subtract it to compare
	rge	gts16			; loop till we find a larger entry
	ldr	gtsrs			; then reload the value
	dvr	(xr)			; and complete scaling
	str	gtsrs			; store value
;
;      we are now scaled, so round by adding 0.5 * 10**(-cfp_s)
;
gts17	ldr	gtsrs			; get value again
	adr	gtsrn			; add rounding factor
	str	gtsrs			; store result
;
;      the rounding operation may have pushed us up past
;      1.0 again, so check one more time.
;
	sbr	reav1			; subtract 1.0 to compare
	rlt	gts18			; skip if ok
	adi	intv1			; else increment exponent
	ldr	gtsrs			; reload value
	dvr	reavt			; divide by 10.0 to rescale
	brn	gts19			; jump to merge
;
;      here if rounding did not muck up scaling
;
gts18	ldr	gtsrs			; reload rounded value
	ejc
;
;      gtstg (continued)
;
;      now we have completed the scaling as follows
;
;      (ia)		     signed exponent
;      (ra)		     scaled real (absolute value)
;
;      if the exponent is negative or greater than cfp_s, then
;      we convert the number in the form.
;
;      (neg sign) 0 . (cpf_s digits) e (exp sign) (exp digits)
;
;      if the exponent is positive and less than or equal to
;      cfp_s, the number is converted in the form.
;
;      (neg sign) (exponent digits) . (cfp_s-exponent digits)
;
;      in both cases, the formats obtained from the above
;      rules are modified by deleting trailing zeros after the
;      decimal point. there are no leading zeros in the exponent
;      and the exponent sign is always present.
;
gts19	mov	xl,=cfp_s		; set num dec digits = cfp_s
	mov	gtses,=ch_mn		; set exponent sign negative
	ilt	gts21			; all set if exponent is negative
	mfi	wa			; else fetch exponent
	ble	wa,=cfp_s,gts20		; skip if we can use special format
	mti	wa			; else restore exponent
	ngi				; set negative for cvd
	mov	gtses,=ch_pl		; set plus sign for exponent sign
	brn	gts21			; jump to generate exponent
;
;      here if we can use the format without an exponent
;
gts20	sub	xl,wa			; compute digits after decimal point
	ldi	intv0			; reset exponent to zero
	ejc
;
;      gtstg (continued)
;
;      merge here as follows
;
;      (ia)		     exponent absolute value
;      gtses		     character for exponent sign
;      (ra)		     positive fraction
;      (xl)		     number of digits after dec point
;
gts21	mov	xr,gtswk		; point to work area
	mov	wb,=nstmx		; set character ctr to max length
	psc	xr,wb			; prepare to store (right to left)
	ieq	gts23			; skip exponent if it is zero
;
;      loop to generate digits of exponent
;
gts22	cvd				; convert a digit into wa
	sch	wa,-(xr)		; store in work area
	dcv	wb			; decrement counter
	ine	gts22			; loop back if more digits to go
;
;      here generate exponent sign and e
;
	mov	wa,gtses		; load exponent sign
	sch	wa,-(xr)		; store in work area
	mov	wa,=ch_le		; get character letter e
	sch	wa,-(xr)		; store in work area
	sub	wb,=num02		; decrement counter for sign and e
;
;      here to generate the fraction
;
gts23	mlr	gtssc			; convert real to integer (10**cfp_s)
	rti				; get integer (overflow impossible)
	ngi				; negate as required by cvd
;
;      loop to suppress trailing zeros
;
gts24	bze	xl,gts27		; jump if no digits left to do
	cvd				; else convert one digit
	bne	wa,=ch_d0,gts26		; jump if not a zero
	dcv	xl			; decrement counter
	brn	gts24			; loop back for next digit
	ejc
;
;      gtstg (continued)
;
;      loop to generate digits after decimal point
;
gts25	cvd				; convert a digit into wa
;
;      merge here first time
;
gts26	sch	wa,-(xr)		; store digit
	dcv	wb			; decrement counter
	dcv	xl			; decrement counter
	bnz	xl,gts25		; loop back if more to go
;
;      here generate the decimal point
;
gts27	mov	wa,=ch_dt		; load decimal point
	sch	wa,-(xr)		; store in work area
	dcv	wb			; decrement counter
;
;      here generate the digits before the decimal point
;
gts28	cvd				; convert a digit into wa
	sch	wa,-(xr)		; store in work area
	dcv	wb			; decrement counter
	ine	gts28			; loop back if more to go
	csc	xr			; complete store characters
	brn	gts08			; else jump back to exit
.fi
.fi
;
;      exit point after successful conversion
;
gts29	mov	xl,(xs)+		; restore xl
	ica	xs			; pop argument
	mov	wb,gtsvb		; restore wb
	mov	wc,gtsvc		; restore wc
;
;      merge here if no conversion required
;
gts30	mov	wa,sclen(xr)		; load string length
	exi				; return to caller
.if    .cnra
.else
;
;      here to return string for real zero
;
gts31	mov	xl,=scre0		; point to string
	mov	wa,=num02		; 2 chars
	zer	wb			; zero offset
	jsr	sbstr			; copy string
	brn	gts29			; return
.fi
.if    .cnbf
.else
	ejc
;
;      here to convert a buffer block
;
gts32	mov	xl,xr			; copy arg ptr
	mov	wa,bclen(xl)		; get size to allocate
	bze	wa,gts33		; if null then return null
	jsr	alocs			; allocate string frame
	mov	wb,xr			; save string ptr
	mov	wa,sclen(xr)		; get length to move
	ctb	wa,0			; get as multiple of word size
	mov	xl,bcbuf(xl)		; point to bfblk
	add	xr,*scsi_		; point to start of character area
	add	xl,*bfsi_		; point to start of buffer chars
	mvw				; copy words
	mov	xr,wb			; restore scblk ptr
	brn	gts29			; exit with scblk
;
;      here when null buffer is being converted
;
gts33	mov	xr,=nulls		; point to null
	brn	gts29			; exit with null
.fi
	enp				; end procedure gtstg
	ejc
;
;      gtvar -- get variable for i/o/trace association
;
;      gtvar is used to point to an actual variable location
;      for the detach,input,output,trace,stoptr system functions
;
;      (xr)		     argument to function
;      jsr  gtvar	     call to locate variable pointer
;      ppm  loc		     transfer loc if not ok variable
;      (xl,wa)		     name base,offset of variable
;      (xr,ra)		     destroyed
;      (wb,wc)		     destroyed (convert error only)
;      (xr)		     input arg (convert error only)
;
gtvar	prc	e,1			; entry point
	bne	(xr),=b_nml,gtvr2	; jump if not a name
	mov	wa,nmofs(xr)		; else load name offset
	mov	xl,nmbas(xr)		; load name base
	beq	(xl),=b_evt,gtvr1	; error if expression variable
	bne	(xl),=b_kvt,gtvr3	; all ok if not keyword variable
;
;      here on conversion error
;
gtvr1	exi	1			; take convert error exit
;
;      here if not a name, try convert to natural variable
;
gtvr2	mov	gtvrc,wc		; save wc
	jsr	gtnvr			; locate vrblk if possible
	ppm	gtvr1			; jump if convert error
	mov	xl,xr			; else copy vrblk name base
	mov	wa,*vrval		; and set offset
	mov	wc,gtvrc		; restore wc
;
;      here for name obtained
;
gtvr3	bhi	xl,state,gtvr4		; all ok if not natural variable
	beq	vrsto(xl),=b_vre,gtvr1	; error if protected variable
;
;      common exit point
;
gtvr4	exi				; return to caller
	enp				; end procedure gtvar
	ejc
	ejc
;
;      hashs -- compute hash index for string
;
;      hashs is used to convert a string to a unique integer
;      value. the resulting hash value is a positive integer
;      in the range 0 to cfp_m
;
;      (xr)		     string to be hashed
;      jsr  hashs	     call to hash string
;      (ia)		     hash value
;      (xr,wb,wc)	     destroyed
;
;      the hash function used is as follows.
;
;      start with the length of the string.
;
;      if there is more than one character in a word,
;      take the first e_hnw words of the characters from
;      the string or all the words if fewer than e_hnw.
;
;      compute the exclusive or of all these words treating
;      them as one word bit string values.
;
;      if there is just one character in a word,
;      then mimic the word by word hash by shifting
;      successive characters to get a similar effect.
;
;      e_hnw is set to zero in case only one character per word.
;
;      move the result as an integer with the mti instruction.
;
;      the test on e_hnw is done dynamically. this should be done
;      eventually using conditional assembly, but that would require
;      changes to the build process (ds 8 may 2013).
;
hashs	prc	e,0			; entry point
;z-
	mov	wc,=e_hnw		; get number of words to use
	bze	wc,hshsa		; branch if one character per word
	mov	wc,sclen(xr)		; load string length in characters
	mov	wb,wc			; initialize with length
	bze	wc,hshs3		; jump if null string
	zgb	wb			; correct byte ordering if necessary
	ctw	wc,0			; get number of words of chars
	add	xr,*schar		; point to characters of string
	blo	wc,=e_hnw,hshs1		; use whole string if short
	mov	wc,=e_hnw		; else set to involve first e_hnw wds
;
;      here with count of words to check in wc
;
hshs1	lct	wc,wc			; set counter to control loop
;
;      loop to compute exclusive or
;
hshs2	xob	wb,(xr)+		; exclusive or next word of chars
	bct	wc,hshs2		; loop till all processed
;
;      merge here with exclusive or in wb
;
hshs3	zgb	wb			; zeroise undefined bits
	anb	wb,bitsm		; ensure in range 0 to cfp_m
	mti	wb			; move result as integer
	zer	xr			; clear garbage value in xr
	exi				; return to hashs caller
;
;      here if just one character per word
;
hshsa	mov	wc,sclen(xr)		; load string length in characters
	mov	wb,wc			; initialize with length
	bze	wc,hshs3		; jump if null string
	zgb	wb			; correct byte ordering if necessary
	ctw	wc,0			; get number of words of chars
	plc	xr			;
	mov	-(xs),xl		; save xl
	mov	xl,wc			; load length for branch
	bge	xl,=num25,hsh24		; use first characters if longer
	bsw	xl,25			; merge to compute hash
	iff	0,hsh00			;
	iff	1,hsh01			;
	iff	2,hsh02			;
	iff	3,hsh03			;
	iff	4,hsh04			;
	iff	5,hsh05			;
	iff	6,hsh06			;
	iff	7,hsh07			;
	iff	8,hsh08			;
	iff	9,hsh09			;
	iff	10,hsh10		;
	iff	11,hsh11		;
	iff	12,hsh12		;
	iff	13,hsh13		;
	iff	14,hsh14		;
	iff	15,hsh15		;
	iff	16,hsh16		;
	iff	17,hsh17		;
	iff	18,hsh18		;
	iff	19,hsh19		;
	iff	20,hsh20		;
	iff	21,hsh21		;
	iff	22,hsh22		;
	iff	23,hsh23		;
	iff	24,hsh24		;
	esw
hsh24	lch	wc,(xr)+		; load next character
	lsh	wc,24			; shift for hash
	xob	wb,wc			; hash character
hsh23	lch	wc,(xr)+		; load next character
	lsh	wc,16			; shift for hash
	xob	wb,wc			; hash character
hsh22	lch	wc,(xr)+		; load next character
	lsh	wc,8			; shift for hash
	xob	wb,wc			; hash character
hsh21	lch	wc,(xr)+		; load next character
	xob	wb,wc			; hash character
hsh20	lch	wc,(xr)+		; load next character
	lsh	wc,24			; shift for hash
	xob	wb,wc			; hash character
hsh19	lch	wc,(xr)+		; load next character
	lsh	wc,16			; shift for hash
	xob	wb,wc			; hash character
hsh18	lch	wc,(xr)+		; load next character
	lsh	wc,8			; shift for hash
	xob	wb,wc			; hash character
hsh17	lch	wc,(xr)+		; load next character
	xob	wb,wc			; hash character
hsh16	lch	wc,(xr)+		; load next character
	lsh	wc,24			; shift for hash
	xob	wb,wc			; hash character
hsh15	lch	wc,(xr)+		; load next character
	lsh	wc,16			; shift for hash
	xob	wb,wc			; hash character
hsh14	lch	wc,(xr)+		; load next character
	lsh	wc,8			; shift for hash
	xob	wb,wc			; hash character
hsh13	lch	wc,(xr)+		; load next character
	xob	wb,wc			; hash character
hsh12	lch	wc,(xr)+		; load next character
	lsh	wc,24			; shift for hash
	xob	wb,wc			; hash character
hsh11	lch	wc,(xr)+		; load next character
	lsh	wc,16			; shift for hash
	xob	wb,wc			; hash character
hsh10	lch	wc,(xr)+		; load next character
	lsh	wc,8			; shift for hash
	xob	wb,wc			; hash character
hsh09	lch	wc,(xr)+		; load next character
	xob	wb,wc			; hash character
hsh08	lch	wc,(xr)+		; load next character
	lsh	wc,24			; shift for hash
	xob	wb,wc			; hash character
hsh07	lch	wc,(xr)+		; load next character
	lsh	wc,16			; shift for hash
	xob	wb,wc			; hash character
hsh06	lch	wc,(xr)+		; load next character
	lsh	wc,8			; shift for hash
	xob	wb,wc			; hash character
hsh05	lch	wc,(xr)+		; load next character
	xob	wb,wc			; hash character
hsh04	lch	wc,(xr)+		; load next character
	lsh	wc,24			; shift for hash
	xob	wb,wc			; hash character
hsh03	lch	wc,(xr)+		; load next character
	lsh	wc,16			; shift for hash
	xob	wb,wc			; hash character
hsh02	lch	wc,(xr)+		; load next character
	lsh	wc,8			; shift for hash
	xob	wb,wc			; hash character
hsh01	lch	wc,(xr)+		; load next character
	xob	wb,wc			; hash character
hsh00	mov	xl,(xs)+		; restore xl
	brn	hshs3			; merge to complete hash
	enp				; end procedure hashs
;
;      icbld -- build integer block
;
;      (ia)		     integer value for icblk
;      jsr  icbld	     call to build integer block
;      (xr)		     pointer to result icblk
;      (wa)		     destroyed
;
icbld	prc	e,0			; entry point
;z+
	mfi	xr,icbl1		; copy small integers
	ble	xr,=num02,icbl3		; jump if 0,1 or 2
;
;      construct icblk
;
icbl1	mov	xr,dnamp		; load pointer to next available loc
	add	xr,*icsi_		; point past new icblk
	blo	xr,dname,icbl2		; jump if there is room
	mov	wa,*icsi_		; else load length of icblk
	jsr	alloc			; use standard allocator to get block
	add	xr,wa			; point past block to merge
;
;      merge here with xr pointing past the block obtained
;
icbl2	mov	dnamp,xr		; set new pointer
	sub	xr,*icsi_		; point back to start of block
	mov	(xr),=b_icl		; store type word
	sti	icval(xr)		; store integer value in icblk
	exi				; return to icbld caller
;
;      optimise by not building icblks for small integers
;
icbl3	wtb	xr			; convert integer to offset
	mov	xr,intab(xr)		; point to pre-built icblk
	exi				; return
	enp				; end procedure icbld
	ejc
;
;      ident -- compare two values
;
;      ident compares two values in the sense of the ident
;      differ functions available at the snobol level.
;
;      (xr)		     first argument
;      (xl)		     second argument
;      jsr  ident	     call to compare arguments
;      ppm  loc		     transfer loc if ident
;      (normal return if differ)
;      (xr,xl,wc,ra)	     destroyed
;
ident	prc	e,1			; entry point
	beq	xr,xl,iden7		; jump if same pointer (ident)
	mov	wc,(xr)			; else load arg 1 type word
.if    .cnbf
	bne	wc,(xl),iden1		; differ if arg 2 type word differ
.else
	bne	wc,(xl),iden0		; differ if arg 2 type word differ
.fi
	beq	wc,=b_scl,iden2		; jump if strings
	beq	wc,=b_icl,iden4		; jump if integers
.if    .cnra
.else
	beq	wc,=b_rcl,iden5		; jump if reals
.fi
	beq	wc,=b_nml,iden6		; jump if names
.if    .cnbf
.else
	bne	wc,=b_bct,iden1		; jump if not buffers
;
;      here for buffers, ident only if lengths and chars same
;
	mov	wc,bclen(xr)		; load arg 1 length
	bne	wc,bclen(xl),iden1	; differ if lengths differ
	bze	wc,iden7		; identical if length 0
	mov	xr,bcbuf(xr)		; arg 1 buffer block
	mov	xl,bcbuf(xl)		; arg 2 buffer block
	brn	idn2a			; compare characters
;
;      here if the type words differ.
;      check if string/buffer comparison
;
iden0	beq	wc,=b_scl,idn0a		; jump if arg 1 is a string
	bne	wc,=b_bct,iden1		; jump if arg 1 not string or buffer
;
;      here if arg 1 is a buffer
;
	bne	(xl),=b_scl,iden1	; jump if arg 2 is not string
	mov	wc,bclen(xr)		; load arg 1 length
	bne	wc,sclen(xl),iden1	; differ if lengths differ
	bze	wc,iden7		; identical if length 0
	mov	xr,bcbuf(xr)		; arg 1 buffer block
	brn	idn2a			; compare characters
;
;      here if arg 1 is a string
;
idn0a	bne	(xl),=b_bct,iden1	; jump if arg 2 is not buffer
	mov	wc,sclen(xr)		; load arg 1 length
	bne	wc,bclen(xl),iden1	; differ if lengths differ
	bze	wc,iden7		; identical if length 0
	mov	xl,bcbuf(xl)		; arg 2 buffer block
	brn	idn2a			; compare characters
.fi
;
;      for all other datatypes, must be differ if xr ne xl
;
;      merge here for differ
;
iden1	exi				; take differ exit
;
;      here for strings, ident only if lengths and chars same
;
iden2	mov	wc,sclen(xr)		; load arg 1 length
	bne	wc,sclen(xl),iden1	; differ if lengths differ
;
;      buffer and string comparisons merge here
;
idn2a	add	xr,*schar		; point to chars of arg 1
	add	xl,*schar		; point to chars of arg 2
	ctw	wc,0			; get number of words in strings
	lct	wc,wc			; set loop counter
;
;      loop to compare characters. note that wc cannot be zero
;      since all null strings point to nulls and give xl=xr.
;
iden3	cne	(xr),(xl),iden8		; differ if chars do not match
	ica	xr			; else bump arg one pointer
	ica	xl			; bump arg two pointer
	bct	wc,iden3		; loop back till all checked
	ejc
;
;      ident (continued)
;
;      here to exit for case of two ident strings
;
	zer	xl			; clear garbage value in xl
	zer	xr			; clear garbage value in xr
	exi	1			; take ident exit
;
;      here for integers, ident if same values
;
iden4	ldi	icval(xr)		; load arg 1
	sbi	icval(xl)		; subtract arg 2 to compare
	iov	iden1			; differ if overflow
	ine	iden1			; differ if result is not zero
	exi	1			; take ident exit
.if    .cnra
.else
;
;      here for reals, ident if same values
;
iden5	ldr	rcval(xr)		; load arg 1
	sbr	rcval(xl)		; subtract arg 2 to compare
	rov	iden1			; differ if overflow
	rne	iden1			; differ if result is not zero
	exi	1			; take ident exit
.fi
;
;      here for names, ident if bases and offsets same
;
iden6	bne	nmofs(xr),nmofs(xl),iden1; differ if different offset
	bne	nmbas(xr),nmbas(xl),iden1; differ if different base
;
;      merge here to signal ident for identical pointers
;
iden7	exi	1			; take ident exit
;
;      here for differ strings
;
iden8	zer	xr			; clear garbage ptr in xr
	zer	xl			; clear garbage ptr in xl
	exi				; return to caller (differ)
	enp				; end procedure ident
	ejc
;
;      inout - used to initialise input and output variables
;
;      (xl)		     pointer to vbl name string
;      (wb)		     trblk type
;      jsr  inout	     call to perform initialisation
;      (xl)		     vrblk ptr
;      (xr)		     trblk ptr
;      (wa,wc)		     destroyed
;
;      note that trter (= trtrf) field of standard i/o variables
;      points to corresponding svblk not to a trblk as is the
;      case for ordinary variables.
;
inout	prc	e,0			; entry point
	mov	-(xs),wb		; stack trblk type
	mov	wa,sclen(xl)		; get name length
	zer	wb			; point to start of name
	jsr	sbstr			; build a proper scblk
	jsr	gtnvr			; build vrblk
	ppm				; no error return
	mov	wc,xr			; save vrblk pointer
	mov	wb,(xs)+		; get trter field
	zer	xl			; zero trfpt
	jsr	trbld			; build trblk
	mov	xl,wc			; recall vrblk pointer
	mov	trter(xr),vrsvp(xl)	; store svblk pointer
	mov	vrval(xl),xr		; store trblk ptr in vrblk
	mov	vrget(xl),=b_vra	; set trapped access
	mov	vrsto(xl),=b_vrv	; set trapped store
	exi				; return to caller
	enp				; end procedure inout
	ejc
.if    .cnbf
.else
;
;      insbf -- insert string in buffer
;
;      this routine will replace a section of a buffer with the
;      contents of a given string.  if the length of the
;      section to be replaced is different than the length of
;      the given string, and the replacement is not an append,
;      then the upper section of the buffer is shifted up or
;      down to create the proper space for the insert.
;
;      (xr)		     pointer to bcblk
;      (xl)		     object which is string convertable
;      (wa)		     offset of start of insert in buffer
;      (wb)		     length of section to replace
;      jsr  insbf	     call to insert characters in buffer
;      ppm  loc		     thread if (xl) not convertable
;      ppm  loc		     thread if insert not possible
;
;      the second alternate exit is taken if the insert would
;      overflow the buffer, or if the insert is out past the
;      defined end of the buffer as given.
;
insbf	prc	e,2			; entry point
	mov	inssa,wa		; save entry wa
	mov	inssb,wb		; save entry wb
	mov	inssc,wc		; save entry wc
	add	wa,wb			; add to get offset past replace part
	mov	insab,wa		; save wa+wb
	mov	wc,bclen(xr)		; get current defined length
	bgt	inssa,wc,ins07		; fail if start offset too big
	bgt	wa,wc,ins07		; fail if final offset too big
	mov	-(xs),xl		; save entry xl
	mov	-(xs),xr		; save bcblk ptr
	mov	-(xs),xl		; stack again for gtstg or gtstb
	beq	xr,xl,ins08		; b if inserting same buffer
	jsr	gtstb			; call to get string or buffer
	ppm	ins05			; take string convert err exit
;
;      merge here with xr pointing to the scblk or bfblk of
;      the object being inserted, and wa containing the
;      number of characters in that object.
;
ins09	mov	xl,xr			; save string ptr
	mov	insln,wa		; save its length
	mov	xr,(xs)			; restore bcblk ptr
	add	wa,wc			; add buffer len to string len
	sub	wa,inssb		; bias out component being replaced
	mov	xr,bcbuf(xr)		; point to bfblk
	bgt	wa,bfalc(xr),ins06	; fail if result exceeds allocation
	mov	xr,(xs)			; restore bcblk ptr
	mov	wa,wc			; get buffer length
	sub	wa,insab		; subtract to get shift length
	add	wc,insln		; add length of new
	sub	wc,inssb		; subtract old to get total new len
	mov	wb,bclen(xr)		; get old bclen
	mov	bclen(xr),wc		; stuff new length
	bze	wa,ins04		; skip shift if nothing to do
	beq	inssb,insln,ins04	; skip shift if lengths match
	mov	xr,bcbuf(xr)		; point to bfblk
	mov	-(xs),xl		; save scblk ptr
	blo	inssb,insln,ins01	; brn if shift is for more room
	ejc
;
;      insbf (continued)
;
;      we are shifting the upper segment down to compact
;      the buffer.  (the string length is smaller than the
;      segment being replaced.)	 registers are set as
;
;      (wa)		     move (shift down) length
;      (wb)		     old bclen
;      (wc)		     new bclen
;      (xr)		     bfblk ptr
;      (xl),(xs)	     scblk or bfblk ptr
;
	mov	wb,inssa		; get offset to insert
	add	wb,insln		; add insert length to get dest off
	mov	xl,xr			; make copy
	plc	xl,insab		; prepare source for move
	psc	xr,wb			; prepare destination reg for move
	mvc				; move em out
	brn	ins02			; branch to pad
;
;      we are shifting the upper segment up to expand
;      the buffer.  (the string length is larger than the
;      segment being replaced.)
;
ins01	mov	xl,xr			; copy bfblk ptr
	plc	xl,wb			; set source reg for move backwards
	psc	xr,wc			; set destination ptr for move
	mcb				; move backwards (possible overlap)
;
;      merge here after move to adjust padding at new buffer end
;
ins02	mov	xl,(xs)+		; restore scblk or bfblk ptr
	mov	wa,wc			; copy new buffer end
	ctb	wa,0			; round out
	sub	wa,wc			; subtract to get remainder
	bze	wa,ins04		; no pad if already even boundary
	mov	xr,(xs)			; get bcblk ptr
	mov	xr,bcbuf(xr)		; get bfblk ptr
	psc	xr,wc			; prepare to pad
	zer	wb			; clear wb
	lct	wa,wa			; load loop count
;
;      loop here to stuff pad characters
;
ins03	sch	wb,(xr)+		; stuff zero pad
	bct	wa,ins03		; branch for more
	csc	xr			; complete store character
	ejc
;
;      insbf (continued)
;
;      merge here when padding ok.  now copy in the insert
;      string to the hole.
;
ins04	mov	wa,insln		; get insert length
	bze	wa,ins4b		; if nothing to insert
	mov	xr,(xs)			; get bcblk ptr
	mov	xr,bcbuf(xr)		; get bfblk ptr
	plc	xl			; prepare to copy from first char
	psc	xr,inssa		; prepare to store in hole
	mvc				; copy the characters
;
;      continue here after possible insertion copy
;
ins4b	mov	xr,(xs)+		; restore entry xr
	mov	xl,(xs)+		; restore entry xl
	mov	wa,inssa		; restore entry wa
	mov	wb,inssb		; restore entry wb
	mov	wc,inssc		; restore entry wc
	exi				; return to caller
;
;      here to take string convert error exit
;
ins05	mov	xr,(xs)+		; restore entry xr
	mov	xl,(xs)+		; restore entry xl
	mov	wa,inssa		; restore entry wa
	mov	wb,inssb		; restore entry wb
	mov	wc,inssc		; restore entry wc
	exi	1			; alternate exit
;
;      here for invalid offset or length
;
ins06	mov	xr,(xs)+		; restore entry xr
	mov	xl,(xs)+		; restore entry xl
;
;      merge for length failure exit with stack set
;
ins07	mov	wa,inssa		; restore entry wa
	mov	wb,inssb		; restore entry wb
	mov	wc,inssc		; restore entry wc
	exi	2			; alternate exit
;
;      here if inserting the same buffer into itself.  have
;      to convert the inserted buffer to an intermediate
;      string to prevent garbled data.
;
ins08	jsr	gtstg			; call to get string
	ppm	ins05			; take string convert err exit
	brn	ins09			; merge back to perform insertion
	enp				; end procedure insbf
	ejc
.fi
;
;      insta - used to initialize structures in static region
;
;      (xr)		     pointer to starting static location
;      jsr  insta	     call to initialize static structure
;      (xr)		     ptr to next free static location
;      (wa,wb,wc)	     destroyed
;
;      note that this procedure establishes the pointers
;      prbuf, gtswk, and kvalp.
;
insta	prc	e,0			; entry point
;
;      initialize print buffer with blank words
;
;z-
	mov	wc,prlen		; no. of chars in print bfr
	mov	prbuf,xr		; print bfr is put at static start
	mov	(xr)+,=b_scl		; store string type code
	mov	(xr)+,wc		; and string length
	ctw	wc,0			; get number of words in buffer
	mov	prlnw,wc		; store for buffer clear
	lct	wc,wc			; words to clear
;
;      loop to clear buffer
;
inst1	mov	(xr)+,nullw		; store blank
	bct	wc,inst1		; loop
;
;      allocate work area for gtstg conversion procedure
;
	mov	wa,=nstmx		; get max num chars in output number
	ctb	wa,scsi_		; no of bytes needed
	mov	gtswk,xr		; store bfr adrs
	add	xr,wa			; bump for work bfr
;
;      build alphabet string for alphabet keyword and replace
;
	mov	kvalp,xr		; save alphabet pointer
	mov	(xr),=b_scl		; string blk type
	mov	wc,=cfp_a		; no of chars in alphabet
	mov	sclen(xr),wc		; store as string length
	mov	wb,wc			; copy char count
	ctb	wb,scsi_		; no. of bytes needed
	add	wb,xr			; current end address for static
	mov	wa,wb			; save adrs past alphabet string
	lct	wc,wc			; loop counter
	psc	xr			; point to chars of string
	zer	wb			; set initial character value
;
;      loop to enter character codes in order
;
inst2	sch	wb,(xr)+		; store next code
	icv	wb			; bump code value
	bct	wc,inst2		; loop till all stored
	csc	xr			; complete store characters
	mov	xr,wa			; return current static ptr
	exi				; return to caller
	enp				; end procedure insta
	ejc
;
;      iofcb -- get input/output fcblk pointer
;
;      used by endfile, eject and rewind to find the fcblk
;      (if any) corresponding to their argument.
;
;      -(xs)		     argument
;      jsr  iofcb	     call to find fcblk
;      ppm  loc		     arg is an unsuitable name
;      ppm  loc		     arg is null string
;      ppm  loc		     arg file not found
;      (xs)		     popped
;      (xl)		     ptr to filearg1 vrblk
;      (xr)		     argument
;      (wa)		     fcblk ptr or 0
;      (wb,wc)		     destroyed
;
iofcb	prc	n,3			; entry point
;z+
	jsr	gtstg			; get arg as string
	ppm	iofc2			; fail
	mov	xl,xr			; copy string ptr
	jsr	gtnvr			; get as natural variable
	ppm	iofc3			; fail if null
	mov	wb,xl			; copy string pointer again
	mov	xl,xr			; copy vrblk ptr for return
	zer	wa			; in case no trblk found
;
;      loop to find file arg1 trblk
;
iofc1	mov	xr,vrval(xr)		; get possible trblk ptr
	bne	(xr),=b_trt,iofc4	; fail if end of chain
	bne	trtyp(xr),=trtfc,iofc1	; loop if not file arg trblk
	mov	wa,trfpt(xr)		; get fcblk ptr
	mov	xr,wb			; copy arg
	exi				; return
;
;      fail return
;
iofc2	exi	1			; fail
;
;      null arg
;
iofc3	exi	2			; null arg return
;
;      file not found
;
iofc4	exi	3			; file not found return
	enp				; end procedure iofcb
	ejc
;
;      ioppf -- process filearg2 for ioput
;
;      (r_xsc)		     filearg2 ptr
;      jsr  ioppf	     call to process filearg2
;      (xl)		     filearg1 ptr
;      (xr)		     file arg2 ptr
;      -(xs)...-(xs)	     fields extracted from filearg2
;      (wc)		     no. of fields extracted
;      (wb)		     input/output flag
;      (wa)		     fcblk ptr or 0
;
ioppf	prc	n,0			; entry point
	zer	wb			; to count fields extracted
;
;      loop to extract fields
;
iopp1	mov	xl,=iodel		; get delimiter
	mov	wc,xl			; copy it
	zer	wa			; retain leading blanks in filearg2
	jsr	xscan			; get next field
	mov	-(xs),xr		; stack it
	icv	wb			; increment count
	bnz	wa,iopp1		; loop
	mov	wc,wb			; count of fields
	mov	wb,ioptt		; i/o marker
	mov	wa,r_iof		; fcblk ptr or 0
	mov	xr,r_io2		; file arg2 ptr
	mov	xl,r_io1		; filearg1
	exi				; return
	enp				; end procedure ioppf
	ejc
;
;      ioput -- routine used by input and output
;
;      ioput sets up input/output  associations. it builds
;      such trace and file control blocks as are necessary and
;      calls sysfc,sysio to perform checks on the
;      arguments and to open the files.
;
;	  +-----------+	  +---------------+	  +-----------+
;      +-.i	      i	  i		  i------.i   =b_xrt  i
;      i  +-----------+	  +---------------+	  +-----------+
;      i  /	      /	       (r_fcb)		  i    *4     i
;      i  /	      /				  +-----------+
;      i  +-----------+	  +---------------+	  i	      i-
;      i  i   name    +--.i    =b_trt	  i	  +-----------+
;      i  /	      /	  +---------------+	  i	      i
;      i   (first arg)	  i =trtin/=trtou i	  +-----------+
;      i		  +---------------+		i
;      i		  i	value	  i		i
;      i		  +---------------+		i
;      i		  i(trtrf) 0   or i--+		i
;      i		  +---------------+  i		i
;      i		  i(trfpt) 0   or i----+	i
;      i		  +---------------+  i i	i
;      i		     (i/o trblk)     i i	i
;      i  +-----------+			     i i	i
;      i  i	      i			     i i	i
;      i  +-----------+			     i i	i
;      i  i	      i			     i i	i
;      i  +-----------+	  +---------------+  i i	i
;      i  i	      +--.i    =b_trt	  i.-+ i	i
;      i  +-----------+	  +---------------+    i	i
;      i  /	      /	  i    =trtfc	  i    i	i
;      i  /	      /	  +---------------+    i	i
;      i    (filearg1	  i	value	  i    i	i
;      i	 vrblk)	  +---------------+    i	i
;      i		  i(trtrf) 0   or i--+ i	.
;      i		  +---------------+  i .  +-----------+
;      i		  i(trfpt) 0   or i------./   fcblk   /
;      i		  +---------------+  i	  +-----------+
;      i		       (trtrf)	     i
;      i				     i
;      i				     i
;      i		  +---------------+  i
;      i		  i    =b_xrt	  i.-+
;      i		  +---------------+
;      i		  i	 *5	  i
;      i		  +---------------+
;      +------------------i		  i
;			  +---------------+	  +-----------+
;			  i(trtrf) o   or i------.i  =b_xrt   i
;			  +---------------+	  +-----------+
;			  i  name offset  i	  i    etc    i
;			  +---------------+
;			    (iochn - chain of name pointers)
	ejc
;
;      ioput (continued)
;
;      no additional trap blocks are used for standard input/out
;      files. otherwise an i/o trap block is attached to second
;      arg (filearg1) vrblk. see diagram above for details of
;      the structure built.
;
;      -(xs)		     1st arg (vbl to be associated)
;      -(xs)		     2nd arg (file arg1)
;      -(xs)		     3rd arg (file arg2)
;      (wb)		     0 for input, 3 for output assoc.
;      jsr  ioput	     call for input/output association
;      ppm  loc		     3rd arg not a string
;      ppm  loc		     2nd arg not a suitable name
;      ppm  loc		     1st arg not a suitable name
;      ppm  loc		     inappropriate file spec for i/o
;      ppm  loc		     i/o file does not exist
;      ppm  loc		     i/o file cannot be read/written
;      ppm  loc		     i/o fcblk currently in use
;      (xs)		     popped
;      (xl,xr,wa,wb,wc)	     destroyed
;
ioput	prc	n,7			; entry point
	zer	r_iot			; in case no trtrf block used
	zer	r_iof			; in case no fcblk alocated
	zer	r_iop			; in case sysio fails
	mov	ioptt,wb		; store i/o trace type
	jsr	xscni			; prepare to scan filearg2
	ppm	iop13			; fail
	ppm	iopa0			; null file arg2
;
iopa0	mov	r_io2,xr		; keep file arg2
	mov	xl,wa			; copy length
	jsr	gtstg			; convert filearg1 to string
	ppm	iop14			; fail
	mov	r_io1,xr		; keep filearg1 ptr
	jsr	gtnvr			; convert to natural variable
	ppm	iop00			; jump if null
	brn	iop04			; jump to process non-null args
;
;      null filearg1
;
iop00	bze	xl,iop01		; skip if both args null
	jsr	ioppf			; process filearg2
	jsr	sysfc			; call for filearg2 check
	ppm	iop16			; fail
	ppm	iop26			; fail
	brn	iop11			; complete file association
	ejc
;
;      ioput (continued)
;
;      here with 0 or fcblk ptr in (xl)
;
iop01	mov	wb,ioptt		; get trace type
	mov	xr,r_iot		; get 0 or trtrf ptr
	jsr	trbld			; build trblk
	mov	wc,xr			; copy trblk pointer
	mov	xr,(xs)+		; get variable from stack
	mov	-(xs),wc		; make trblk collectable
	jsr	gtvar			; point to variable
	ppm	iop15			; fail
	mov	wc,(xs)+		; recover trblk pointer
	mov	r_ion,xl		; save name pointer
	mov	xr,xl			; copy name pointer
	add	xr,wa			; point to variable
	sub	xr,*vrval		; subtract offset,merge into loop
;
;      loop to end of trblk chain if any
;
iop02	mov	xl,xr			; copy blk ptr
	mov	xr,vrval(xr)		; load ptr to next trblk
	bne	(xr),=b_trt,iop03	; jump if not trapped
	bne	trtyp(xr),ioptt,iop02	; loop if not same assocn
	mov	xr,trnxt(xr)		; get value and delete old trblk
;
;      ioput (continued)
;
;      store new association
;
iop03	mov	vrval(xl),wc		; link to this trblk
	mov	xl,wc			; copy pointer
	mov	trnxt(xl),xr		; store value in trblk
	mov	xr,r_ion		; restore possible vrblk pointer
	mov	wb,wa			; keep offset to name
	jsr	setvr			; if vrblk, set vrget,vrsto
	mov	xr,r_iot		; get 0 or trtrf ptr
	bnz	xr,iop19		; jump if trtrf block exists
	exi				; return to caller
;
;      non standard file
;      see if an fcblk has already been allocated.
;
iop04	zer	wa			; in case no fcblk found
	ejc
;
;      ioput (continued)
;
;      search possible trblk chain to pick up the fcblk
;
iop05	mov	wb,xr			; remember blk ptr
	mov	xr,vrval(xr)		; chain along
	bne	(xr),=b_trt,iop06	; jump if end of trblk chain
	bne	trtyp(xr),=trtfc,iop05	; loop if more to go
	mov	r_iot,xr		; point to file arg1 trblk
	mov	wa,trfpt(xr)		; get fcblk ptr from trblk
;
;      wa = 0 or fcblk ptr
;      wb = ptr to preceding blk to which any trtrf block
;	    for file arg1 must be chained.
;
iop06	mov	r_iof,wa		; keep possible fcblk ptr
	mov	r_iop,wb		; keep preceding blk ptr
	jsr	ioppf			; process filearg2
	jsr	sysfc			; see if fcblk required
	ppm	iop16			; fail
	ppm	iop26			; fail
	bze	wa,iop12		; skip if no new fcblk wanted
	blt	wc,=num02,iop6a		; jump if fcblk in dynamic
	jsr	alost			; get it in static
	brn	iop6b			; skip
;
;      obtain fcblk in dynamic
;
iop6a	jsr	alloc			; get space for fcblk
;
;      merge
;
iop6b	mov	xl,xr			; point to fcblk
	mov	wb,wa			; copy its length
	btw	wb			; get count as words (sgd apr80)
	lct	wb,wb			; loop counter
;
;      clear fcblk
;
iop07	zer	(xr)+			; clear a word
	bct	wb,iop07		; loop
	beq	wc,=num02,iop09		; skip if in static - dont set fields
	mov	(xl),=b_xnt		; store xnblk code in case
	mov	num01(xl),wa		; store length
	bnz	wc,iop09		; jump if xnblk wanted
	mov	(xl),=b_xrt		; xrblk code requested
;
	ejc
;      ioput (continued)
;
;      complete fcblk initialisation
;
iop09	mov	xr,r_iot		; get possible trblk ptr
	mov	r_iof,xl		; store fcblk ptr
	bnz	xr,iop10		; jump if trblk already found
;
;      a new trblk is needed
;
	mov	wb,=trtfc		; trtyp for fcblk trap blk
	jsr	trbld			; make the block
	mov	r_iot,xr		; copy trtrf ptr
	mov	xl,r_iop		; point to preceding blk
	mov	vrval(xr),vrval(xl)	; copy value field to trblk
	mov	vrval(xl),xr		; link new trblk into chain
	mov	xr,xl			; point to predecessor blk
	jsr	setvr			; set trace intercepts
	mov	xr,vrval(xr)		; recover trblk ptr
	brn	iop1a			; store fcblk ptr
;
;      here if existing trblk
;
iop10	zer	r_iop			; do not release if sysio fails
;
;      xr is ptr to trblk, xl is fcblk ptr or 0
;
iop1a	mov	trfpt(xr),r_iof		; store fcblk ptr
;
;      call sysio to complete file accessing
;
iop11	mov	wa,r_iof		; copy fcblk ptr or 0
	mov	wb,ioptt		; get input/output flag
	mov	xr,r_io2		; get file arg2
	mov	xl,r_io1		; get file arg1
	jsr	sysio			; associate to the file
	ppm	iop17			; fail
	ppm	iop18			; fail
	bnz	r_iot,iop01		; not std input if non-null trtrf blk
	bnz	ioptt,iop01		; jump if output
	bze	wc,iop01		; no change to standard read length
	mov	cswin,wc		; store new read length for std file
	brn	iop01			; merge to finish the task
;
;      sysfc may have returned a pointer to a private fcblk
;
iop12	bnz	xl,iop09		; jump if private fcblk
	brn	iop11			; finish the association
;
;      failure returns
;
iop13	exi	1			; 3rd arg not a string
iop14	exi	2			; 2nd arg unsuitable
iop15	ica	xs			; discard trblk pointer
	exi	3			; 1st arg unsuitable
iop16	exi	4			; file spec wrong
iop26	exi	7			; fcblk in use
;
;      i/o file does not exist
;
iop17	mov	xr,r_iop		; is there a trblk to release
	bze	xr,iopa7		; if not
	mov	xl,vrval(xr)		; point to trblk
	mov	vrval(xr),vrval(xl)	; unsplice it
	jsr	setvr			; adjust trace intercepts
iopa7	exi	5			; i/o file does not exist
;
;      i/o file cannot be read/written
;
iop18	mov	xr,r_iop		; is there a trblk to release
	bze	xr,iopa7		; if not
	mov	xl,vrval(xr)		; point to trblk
	mov	vrval(xr),vrval(xl)	; unsplice it
	jsr	setvr			; adjust trace intercepts
iopa8	exi	6			; i/o file cannot be read/written
	ejc
;
;      ioput (continued)
;
;      add to iochn chain of associated variables unless
;      already present.
;
iop19	mov	wc,r_ion		; wc = name base, wb = name offset
;
;      search loop
;
iop20	mov	xr,trtrf(xr)		; next link of chain
	bze	xr,iop21		; not found
	bne	wc,ionmb(xr),iop20	; no match
	beq	wb,ionmo(xr),iop22	; exit if matched
	brn	iop20			; loop
;
;      not found
;
iop21	mov	wa,*num05		; space needed
	jsr	alloc			; get it
	mov	(xr),=b_xrt		; store xrblk code
	mov	num01(xr),wa		; store length
	mov	ionmb(xr),wc		; store name base
	mov	ionmo(xr),wb		; store name offset
	mov	xl,r_iot		; point to trtrf blk
	mov	wa,trtrf(xl)		; get ptr field contents
	mov	trtrf(xl),xr		; store ptr to new block
	mov	trtrf(xr),wa		; complete the linking
;
;      insert fcblk on fcblk chain for sysej, sysxi
;
iop22	bze	r_iof,iop25		; skip if no fcblk
	mov	xl,r_fcb		; ptr to head of existing chain
;
;      see if fcblk already on chain
;
iop23	bze	xl,iop24		; not on if end of chain
	beq	num03(xl),r_iof,iop25	; dont duplicate if find it
	mov	xl,num02(xl)		; get next link
	brn	iop23			; loop
;
;      not found so add an entry for this fcblk
;
iop24	mov	wa,*num04		; space needed
	jsr	alloc			; get it
	mov	(xr),=b_xrt		; store block code
	mov	num01(xr),wa		; store length
	mov	num02(xr),r_fcb		; store previous link in this node
	mov	num03(xr),r_iof		; store fcblk ptr
	mov	r_fcb,xr		; insert node into fcblk chain
;
;      return
;
iop25	exi				; return to caller
	enp				; end procedure ioput
	ejc
;
;      ktrex -- execute keyword trace
;
;      ktrex is used to execute a possible keyword trace. it
;      includes the test on trace and tests for trace active.
;
;      (xl)		     ptr to trblk (or 0 if untraced)
;      jsr  ktrex	     call to execute keyword trace
;      (xl,wa,wb,wc)	     destroyed
;      (ra)		     destroyed
;
ktrex	prc	r,0			; entry point (recursive)
	bze	xl,ktrx3		; immediate exit if keyword untraced
	bze	kvtra,ktrx3		; immediate exit if trace = 0
	dcv	kvtra			; else decrement trace
	mov	-(xs),xr		; save xr
	mov	xr,xl			; copy trblk pointer
	mov	xl,trkvr(xr)		; load vrblk pointer (nmbas)
	mov	wa,*vrval		; set name offset
	bze	trfnc(xr),ktrx1		; jump if print trace
	jsr	trxeq			; else execute full trace
	brn	ktrx2			; and jump to exit
;
;      here for print trace
;
ktrx1	mov	-(xs),xl		; stack vrblk ptr for kwnam
	mov	-(xs),wa		; stack offset for kwnam
	jsr	prtsn			; print statement number
	mov	wa,=ch_am		; load ampersand
	jsr	prtch			; print ampersand
	jsr	prtnm			; print keyword name
	mov	xr,=tmbeb		; point to blank-equal-blank
	jsr	prtst			; print blank-equal-blank
	jsr	kwnam			; get keyword pseudo-variable name
	mov	dnamp,xr		; reset ptr to delete kvblk
	jsr	acess			; get keyword value
	ppm				; failure is impossible
	jsr	prtvl			; print keyword value
	jsr	prtnl			; terminate print line
;
;      here to exit after completing trace
;
ktrx2	mov	xr,(xs)+		; restore entry xr
;
;      merge here to exit if no trace required
;
ktrx3	exi				; return to ktrex caller
	enp				; end procedure ktrex
	ejc
;
;      kwnam -- get pseudo-variable name for keyword
;
;      1(xs)		     name base for vrblk
;      0(xs)		     offset (should be *vrval)
;      jsr  kwnam	     call to get pseudo-variable name
;      (xs)		     popped twice
;      (xl,wa)		     resulting pseudo-variable name
;      (xr,wa,wb)	     destroyed
;
kwnam	prc	n,0			; entry point
	ica	xs			; ignore name offset
	mov	xr,(xs)+		; load name base
	bge	xr,state,kwnm1		; jump if not natural variable name
	bnz	vrlen(xr),kwnm1		; error if not system variable
	mov	xr,vrsvp(xr)		; else point to svblk
	mov	wa,svbit(xr)		; load bit mask
	anb	wa,btknm		; and with keyword bit
	zrb	wa,kwnm1		; error if no keyword association
	mov	wa,svlen(xr)		; else load name length in characters
	ctb	wa,svchs		; compute offset to field we want
	add	xr,wa			; point to svknm field
	mov	wb,(xr)			; load svknm value
	mov	wa,*kvsi_		; set size of kvblk
	jsr	alloc			; allocate kvblk
	mov	(xr),=b_kvt		; store type word
	mov	kvnum(xr),wb		; store keyword number
	mov	kvvar(xr),=trbkv	; set dummy trblk pointer
	mov	xl,xr			; copy kvblk pointer
	mov	wa,*kvvar		; set proper offset
	exi				; return to kvnam caller
;
;      here if not keyword name
;
kwnm1	erb	251,keyword operand is not name of defined keyword
	enp				; end procedure kwnam
	ejc
;
;      lcomp-- compare two strings lexically
;
;      1(xs)		     first argument
;      0(xs)		     second argument
;      jsr  lcomp	     call to compare aruments
;      ppm  loc		     transfer loc for arg1 not string
;      ppm  loc		     transfer loc for arg2 not string
;      ppm  loc		     transfer loc if arg1 llt arg2
;      ppm  loc		     transfer loc if arg1 leq arg2
;      ppm  loc		     transfer loc if arg1 lgt arg2
;      (the normal return is never taken)
;      (xs)		     popped twice
;      (xr,xl)		     destroyed
;      (wa,wb,wc,ra)	     destroyed
;
lcomp	prc	n,5			; entry point
.if    .cnbf
	jsr	gtstg			; convert second arg to string
.else
	jsr	gtstb			; get second arg as string or buffer
.fi
	ppm	lcmp6			; jump if second arg not string
	mov	xl,xr			; else save pointer
	mov	wc,wa			; and length
.if    .cnbf
	jsr	gtstg			; convert first argument to string
.else
	jsr	gtstb			; get first arg as string or buffer
.fi
	ppm	lcmp5			; jump if not string
	mov	wb,wa			; save arg 1 length
	plc	xr			; point to chars of arg 1
	plc	xl			; point to chars of arg 2
.if    .ccmc
	mov	wa,wc			; arg 2 length to wa
	jsr	syscm			; compare (xl,wa=arg2  xr,wb=arg1)
	err	283,string length exceeded for generalized lexical comparison
	ppm	lcmp4			; arg 2 lt arg 1, lgt exit
	ppm	lcmp3			; arg 2 gt arg 1, llt exit
	exi	4			; else identical strings, leq exit
	ejc
;
;      lcomp (continued)
.else
	blo	wa,wc,lcmp1		; jump if arg 1 length is smaller
	mov	wa,wc			; else set arg 2 length as smaller
;
;      here with smaller length in (wa)
;
lcmp1	bze	wa,lcmp7		; if null string, compare lengths
	cmc	lcmp4,lcmp3		; compare strings, jump if unequal
lcmp7	bne	wb,wc,lcmp2		; if equal, jump if lengths unequal
	exi	4			; else identical strings, leq exit
	ejc
;
;      lcomp (continued)
;
;      here if initial strings identical, but lengths unequal
;
lcmp2	bhi	wb,wc,lcmp4		; jump if arg 1 length gt arg 2 leng
.fi
;
;      here if first arg llt second arg
;
lcmp3	exi	3			; take llt exit
;
;      here if first arg lgt second arg
;
lcmp4	exi	5			; take lgt exit
;
;      here if first arg is not a string
;
lcmp5	exi	1			; take bad first arg exit
;
;      here for second arg not a string
;
lcmp6	exi	2			; take bad second arg error exit
	enp				; end procedure lcomp
	ejc
;
;      listr -- list source line
;
;      listr is used to list a source line during the initial
;      compilation. it is called from scane and scanl.
;
;      jsr  listr	     call to list line
;      (xr,xl,wa,wb,wc)	     destroyed
;
;      global locations used by listr
;
;      cnttl		     flag for -title, -stitl
;
;      erlst		     if listing on account of an error
;
.if    .cinc
;      lstid		     include depth of current image
;
.fi
;      lstlc		     count lines on current page
;
;      lstnp		     max number of lines/page
;
;      lstpf		     set non-zero if the current source
;			     line has been listed, else zero.
;
;      lstpg		     compiler listing page number
;
;      lstsn		     set if stmnt num to be listed
;
;      r_cim		     pointer to current input line.
;
;      r_ttl		     title for source listing
;
;      r_stl		     ptr to sub-title string
;
;      entry point
;
listr	prc	e,0			; entry point
	bnz	cnttl,list5		; jump if -title or -stitl
	bnz	lstpf,list4		; immediate exit if already listed
	bge	lstlc,lstnp,list6	; jump if no room
;
;      here after printing title (if needed)
;
list0	mov	xr,r_cim		; load pointer to current image
	bze	xr,list4		; jump if no image to print
	plc	xr			; point to characters
	lch	wa,(xr)			; load first character
	mov	xr,lstsn		; load statement number
	bze	xr,list2		; jump if no statement number
	mti	xr			; else get stmnt number as integer
	bne	stage,=stgic,list1	; skip if execute time
	beq	wa,=ch_as,list2		; no stmnt number list if comment
	beq	wa,=ch_mn,list2		; no stmnt no. if control card
;
;      print statement number
;
list1	jsr	prtin			; else print statement number
	zer	lstsn			; and clear for next time in
.if    .cinc
;
;      here to test for printing include depth
;
list2	mov	xr,lstid		; include depth of image
	bze	xr,list8		; if not from an include file
	mov	wa,=stnpd		; position for start of statement
	sub	wa,=num03		; position to place include depth
	mov	profs,wa		; set as starting position
	mti	xr			; include depth as integer
	jsr	prtin			; print include depth
	ejc
;
;      listr (continued)
;
;      here after printing statement number and include depth
;
list8	mov	profs,=stnpd		; point past statement number
.else
	ejc
;
;      listr (continued)
;
;      merge here after printing statement number (if required)
;
list2	mov	profs,=stnpd		; point past statement number
.fi
	mov	xr,r_cim		; load pointer to current image
	jsr	prtst			; print it
	icv	lstlc			; bump line counter
	bnz	erlst,list3		; jump if error copy to int.ch.
	jsr	prtnl			; terminate line
	bze	cswdb,list3		; jump if -single mode
	jsr	prtnl			; else add a blank line
	icv	lstlc			; and bump line counter
;
;      here after printing source image
;
list3	mnz	lstpf			; set flag for line printed
;
;      merge here to exit
;
list4	exi				; return to listr caller
;
;      print title after -title or -stitl card
;
list5	zer	cnttl			; clear flag
;
;      eject to new page and list title
;
list6	jsr	prtps			; eject
	bze	prich,list7		; skip if listing to regular printer
	beq	r_ttl,=nulls,list0	; terminal listing omits null title
;
;      list title
;
list7	jsr	listt			; list title
	brn	list0			; merge
	enp				; end procedure listr
	ejc
;
;      listt -- list title and subtitle
;
;      used during compilation to print page heading
;
;      jsr  listt	     call to list title
;      (xr,wa)		     destroyed
;
listt	prc	e,0			; entry point
	mov	xr,r_ttl		; point to source listing title
	jsr	prtst			; print title
	mov	profs,lstpo		; set offset
	mov	xr,=lstms		; set page message
	jsr	prtst			; print page message
	icv	lstpg			; bump page number
	mti	lstpg			; load page number as integer
	jsr	prtin			; print page number
	jsr	prtnl			; terminate title line
	add	lstlc,=num02		; count title line and blank line
;
;      print sub-title (if any)
;
	mov	xr,r_stl		; load pointer to sub-title
	bze	xr,lstt1		; jump if no sub-title
	jsr	prtst			; else print sub-title
	jsr	prtnl			; terminate line
	icv	lstlc			; bump line count
;
;      return point
;
lstt1	jsr	prtnl			; print a blank line
	exi				; return to caller
	enp				; end procedure listt
	ejc
.if    .csfn
;
;      newfn -- record new source file name
;
;      newfn is used after switching to a new include file, or
;      after a -line statement which contains a file name.
;
;      (xr)		     file name scblk
;      jsr  newfn
;      (wa,wb,wc,xl,xr,ra)   destroyed
;
;      on return, the table that maps statement numbers to file
;      names has been updated to include this new file name and
;      the current statement number.  the entry is made only if
;      the file name had changed from its previous value.
;
newfn	prc	e,0			; entry point
	mov	-(xs),xr		; save new name
	mov	xl,r_sfc		; load previous name
	jsr	ident			; check for equality
	ppm	nwfn1			; jump if identical
	mov	xr,(xs)+		; different, restore name
	mov	r_sfc,xr		; record current file name
	mov	wb,cmpsn		; get current statement
	mti	wb			; convert to integer
	jsr	icbld			; build icblk for stmt number
	mov	xl,r_sfn		; file name table
	mnz	wb			; lookup statement number by name
	jsr	tfind			; allocate new teblk
	ppm				; always possible to allocate block
	mov	teval(xl),r_sfc		; record file name as entry value
	exi
;
;     here if new name and old name identical
;
nwfn1	ica	xs			; pop stack
	exi
	ejc
.fi
;
;      nexts -- acquire next source image
;
;      nexts is used to acquire the next source image at compile
;      time. it assumes that a prior call to readr has input
;      a line image (see procedure readr). before the current
;      image is finally lost it may be listed here.
;
;      jsr  nexts	     call to acquire next input line
;      (xr,xl,wa,wb,wc)	     destroyed
;
;      global values affected
;
.if    .cinc
;      lstid		     include depth of next image
;
.fi
;      r_cni		     on input, next image. on
;			     exit reset to zero
;
;      r_cim		     on exit, set to point to image
;
;      rdcln		     current ln set from next line num
;
;      scnil		     input image length on exit
;
;      scnse		     reset to zero on exit
;
;      lstpf		     set on exit if line is listed
;
nexts	prc	e,0			; entry point
	bze	cswls,nxts2		; jump if -nolist
	mov	xr,r_cim		; point to image
	bze	xr,nxts2		; jump if no image
	plc	xr			; get char ptr
	lch	wa,(xr)			; get first char
	bne	wa,=ch_mn,nxts1		; jump if not ctrl card
	bze	cswpr,nxts2		; jump if -noprint
;
;      here to call lister
;
nxts1	jsr	listr			; list line
;
;      here after possible listing
;
nxts2	mov	xr,r_cni		; point to next image
	mov	r_cim,xr		; set as next image
	mov	rdcln,rdnln		; set as current line number
.if    .cinc
	mov	lstid,cnind		; set as current include depth
.fi
	zer	r_cni			; clear next image pointer
	mov	wa,sclen(xr)		; get input image length
	mov	wb,cswin		; get max allowable length
	blo	wa,wb,nxts3		; skip if not too long
	mov	wa,wb			; else truncate
;
;      here with length in (wa)
;
nxts3	mov	scnil,wa		; use as record length
	zer	scnse			; reset scnse
	zer	lstpf			; set line not listed yet
	exi				; return to nexts caller
	enp				; end procedure nexts
	ejc
;
;      patin -- pattern construction for len,pos,rpos,tab,rtab
;
;      these pattern types all generate a similar node type. so
;      the construction code is shared. see functions section
;      for actual entry points for these five functions.
;
;      (wa)		     pcode for expression arg case
;      (wb)		     pcode for integer arg case
;      jsr  patin	     call to build pattern node
;      ppm  loc		     transfer loc for not integer or exp
;      ppm  loc		     transfer loc for int out of range
;      (xr)		     pointer to constructed node
;      (xl,wa,wb,wc,ia)	     destroyed
;
patin	prc	n,2			; entry point
	mov	xl,wa			; preserve expression arg pcode
	jsr	gtsmi			; try to convert arg as small integer
	ppm	ptin2			; jump if not integer
	ppm	ptin3			; jump if out of range
;
;      common successful exit point
;
ptin1	jsr	pbild			; build pattern node
	exi				; return to caller
;
;      here if argument is not an integer
;
ptin2	mov	wb,xl			; copy expr arg case pcode
	blo	(xr),=b_e__,ptin1	; all ok if expression arg
	exi	1			; else take error exit for wrong type
;
;      here for error of out of range integer argument
;
ptin3	exi	2			; take out-of-range error exit
	enp				; end procedure patin
	ejc
;
;      patst -- pattern construction for any,notany,
;		break,span and breakx pattern functions.
;
;      these pattern functions build similar types of nodes and
;      the construction code is shared. see functions section
;      for actual entry points for these five pattern functions.
;
;      0(xs)		     string argument
;      (wb)		     pcode for one char argument
;      (xl)		     pcode for multi-char argument
;      (wc)		     pcode for expression argument
;      jsr  patst	     call to build node
;      ppm  loc		     if not string or expr (or null)
;      (xs)		     popped past string argument
;      (xr)		     pointer to constructed node
;      (xl)		     destroyed
;      (wa,wb,wc,ra)	     destroyed
;
;      note that there is a special call to patst in the evals
;      procedure with a slightly different form. see evals
;      for details of the form of this call.
;
patst	prc	n,1			; entry point
	jsr	gtstg			; convert argument as string
	ppm	pats7			; jump if not string
	bze	wa,pats7		; jump if null string (catspaw)
	bne	wa,=num01,pats2		; jump if not one char string
;
;      here for one char string case
;
	bze	wb,pats2		; treat as multi-char if evals call
	plc	xr			; point to character
	lch	xr,(xr)			; load character
;
;      common exit point after successful construction
;
pats1	jsr	pbild			; call routine to build node
	exi				; return to patst caller
	ejc
;
;      patst (continued)
;
;      here for multi-character string case
;
pats2	mov	-(xs),xl		; save multi-char pcode
	mov	wc,ctmsk		; load current mask bit
	beq	xr,r_cts,pats6		; jump if same as last string c3.738
	mov	-(xs),xr		; save string pointer
	lsh	wc,1			; shift to next position
	nzb	wc,pats4		; skip if position left in this tbl
;
;      here we must allocate a new character table
;
	mov	wa,*ctsi_		; set size of ctblk
	jsr	alloc			; allocate ctblk
	mov	r_ctp,xr		; store ptr to new ctblk
	mov	(xr)+,=b_ctt		; store type code, bump ptr
	lct	wb,=cfp_a		; set number of words to clear
	mov	wc,bits0		; load all zero bits
;
;      loop to clear all bits in table to zeros
;
pats3	mov	(xr)+,wc		; move word of zero bits
	bct	wb,pats3		; loop till all cleared
	mov	wc,bits1		; set initial bit position
;
;      merge here with bit position available
;
pats4	mov	ctmsk,wc		; save parm2 (new bit position)
	mov	xl,(xs)+		; restore pointer to argument string
	mov	r_cts,xl		; save for next time   c3.738
	mov	wb,sclen(xl)		; load string length
	bze	wb,pats6		; jump if null string case
	lct	wb,wb			; else set loop counter
	plc	xl			; point to characters in argument
	ejc
;
;      patst (continued)
;
;      loop to set bits in column of table
;
pats5	lch	wa,(xl)+		; load next character
	wtb	wa			; convert to byte offset
	mov	xr,r_ctp		; point to ctblk
	add	xr,wa			; point to ctblk entry
	mov	wa,wc			; copy bit mask
	orb	wa,ctchs(xr)		; or in bits already set
	mov	ctchs(xr),wa		; store resulting bit string
	bct	wb,pats5		; loop till all bits set
;
;      complete processing for multi-char string case
;
pats6	mov	xr,r_ctp		; load ctblk ptr as parm1 for pbild
	zer	xl			; clear garbage ptr in xl
	mov	wb,(xs)+		; load pcode for multi-char str case
	brn	pats1			; back to exit (wc=bitstring=parm2)
;
;      here if argument is not a string
;
;      note that the call from evals cannot pass an expression
;      since evalp always reevaluates expressions.
;
pats7	mov	wb,wc			; set pcode for expression argument
	blo	(xr),=b_e__,pats1	; jump to exit if expression arg
	exi	1			; else take wrong type error exit
	enp				; end procedure patst
	ejc
;
;      pbild -- build pattern node
;
;      (xr)		     parm1 (only if required)
;      (wb)		     pcode for node
;      (wc)		     parm2 (only if required)
;      jsr  pbild	     call to build node
;      (xr)		     pointer to constructed node
;      (wa)		     destroyed
;
pbild	prc	e,0			; entry point
	mov	-(xs),xr		; stack possible parm1
	mov	xr,wb			; copy pcode
	lei	xr			; load entry point id (bl_px)
	beq	xr,=bl_p1,pbld1		; jump if one parameter
	beq	xr,=bl_p0,pbld3		; jump if no parameters
;
;      here for two parameter case
;
	mov	wa,*pcsi_		; set size of p2blk
	jsr	alloc			; allocate block
	mov	parm2(xr),wc		; store second parameter
	brn	pbld2			; merge with one parm case
;
;      here for one parameter case
;
pbld1	mov	wa,*pbsi_		; set size of p1blk
	jsr	alloc			; allocate node
;
;      merge here from two parm case
;
pbld2	mov	parm1(xr),(xs)		; store first parameter
	brn	pbld4			; merge with no parameter case
;
;      here for case of no parameters
;
pbld3	mov	wa,*pasi_		; set size of p0blk
	jsr	alloc			; allocate node
;
;      merge here from other cases
;
pbld4	mov	(xr),wb			; store pcode
	ica	xs			; pop first parameter
	mov	pthen(xr),=ndnth	; set nothen successor pointer
	exi				; return to pbild caller
	enp				; end procedure pbild
	ejc
;
;      pconc -- concatenate two patterns
;
;      (xl)		     ptr to right pattern
;      (xr)		     ptr to left pattern
;      jsr  pconc	     call to concatenate patterns
;      (xr)		     ptr to concatenated pattern
;      (xl,wa,wb,wc)	     destroyed
;
;
;      to concatenate two patterns, all successors in the left
;      pattern which point to the nothen node must be changed to
;      point to the right pattern. however, this modification
;      must be performed on a copy of the left argument rather
;      than the left argument itself, since the left argument
;      may be pointed to by some other variable value.
;
;      accordingly, it is necessary to copy the left argument.
;      this is not a trivial process since we must avoid copying
;      nodes more than once and the pattern is a graph structure
;      the following algorithm is employed.
;
;      the stack is used to store a list of nodes which
;      have already been copied. the format of the entries on
;      this list consists of a two word block. the first word
;      is the old address and the second word is the address
;      of the copy. this list is searched by the pcopy
;      routine to avoid making duplicate copies. a trick is
;      used to accomplish the concatenation at the same time.
;      a special entry is made to start with on the stack. this
;      entry records that the nothen node has been copied
;      already and the address of its copy is the right pattern.
;      this automatically performs the correct replacements.
;
pconc	prc	e,0			; entry point
	zer	-(xs)			; make room for one entry at bottom
	mov	wc,xs			; store pointer to start of list
	mov	-(xs),=ndnth		; stack nothen node as old node
	mov	-(xs),xl		; store right arg as copy of nothen
	mov	xt,xs			; initialize pointer to stack entries
	jsr	pcopy			; copy first node of left arg
	mov	num02(xt),wa		; store as result under list
	ejc
;
;      pconc (continued)
;
;      the following loop scans entries in the list and makes
;      sure that their successors have been copied.
;
pcnc1	beq	xt,xs,pcnc2		; jump if all entries processed
	mov	xr,-(xt)		; else load next old address
	mov	xr,pthen(xr)		; load pointer to successor
	jsr	pcopy			; copy successor node
	mov	xr,-(xt)		; load pointer to new node (copy)
	mov	pthen(xr),wa		; store ptr to new successor
;
;      now check for special case of alternation node where
;      parm1 points to a node and must be copied like pthen.
;
	bne	(xr),=p_alt,pcnc1	; loop back if not
	mov	xr,parm1(xr)		; else load pointer to alternative
	jsr	pcopy			; copy it
	mov	xr,(xt)			; restore ptr to new node
	mov	parm1(xr),wa		; store ptr to copied alternative
	brn	pcnc1			; loop back for next entry
;
;      here at end of copy process
;
pcnc2	mov	xs,wc			; restore stack pointer
	mov	xr,(xs)+		; load pointer to copy
	exi				; return to pconc caller
	enp				; end procedure pconc
	ejc
;
;      pcopy -- copy a pattern node
;
;      pcopy is called from the pconc procedure to copy a single
;      pattern node. the copy is only carried out if the node
;      has not been copied already.
;
;      (xr)		     pointer to node to be copied
;      (xt)		     ptr to current loc in copy list
;      (wc)		     pointer to list of copied nodes
;      jsr  pcopy	     call to copy a node
;      (wa)		     pointer to copy
;      (wb,xr)		     destroyed
;
pcopy	prc	n,0			; entry point
	mov	wb,xt			; save xt
	mov	xt,wc			; point to start of list
;
;      loop to search list of nodes copied already
;
pcop1	dca	xt			; point to next entry on list
	beq	xr,(xt),pcop2		; jump if match
	dca	xt			; else skip over copied address
	bne	xt,xs,pcop1		; loop back if more to test
;
;      here if not in list, perform copy
;
	mov	wa,(xr)			; load first word of block
	jsr	blkln			; get length of block
	mov	xl,xr			; save pointer to old node
	jsr	alloc			; allocate space for copy
	mov	-(xs),xl		; store old address on list
	mov	-(xs),xr		; store new address on list
	chk				; check for stack overflow
	mvw				; move words from old block to copy
	mov	wa,(xs)			; load pointer to copy
	brn	pcop3			; jump to exit
;
;      here if we find entry in list
;
pcop2	mov	wa,-(xt)		; load address of copy from list
;
;      common exit point
;
pcop3	mov	xt,wb			; restore xt
	exi				; return to pcopy caller
	enp				; end procedure pcopy
	ejc
.if    .cnpf
.else
;
;      prflr -- print profile
;      prflr is called to print the contents of the profile
;      table in a fairly readable tabular format.
;
;      jsr  prflr	     call to print profile
;      (wa,ia)		     destroyed
;
prflr	prc	e,0			;
	bze	pfdmp,prfl4		; no printing if no profiling done
	mov	-(xs),xr		; preserve entry xr
	mov	pfsvw,wb		; and also wb
	jsr	prtpg			; eject
	mov	xr,=pfms1		; load msg /program profile/
	jsr	prtst			; and print it
	jsr	prtnl			; followed by newline
	jsr	prtnl			; and another
	mov	xr,=pfms2		; point to first hdr
	jsr	prtst			; print it
	jsr	prtnl			; new line
	mov	xr,=pfms3		; second hdr
	jsr	prtst			; print it
	jsr	prtnl			; new line
	jsr	prtnl			; and another blank line
	zer	wb			; initial stmt count
	mov	xr,pftbl		; point to table origin
	add	xr,*xndta		; bias past xnblk header (sgd07)
;
;      loop here to print successive entries
;
prfl1	icv	wb			; bump stmt nr
	ldi	(xr)			; load nr of executions
	ieq	prfl3			; no printing if zero
	mov	profs,=pfpd1		; point where to print
	jsr	prtin			; and print it
	zer	profs			; back to start of line
	mti	wb			; load stmt nr
	jsr	prtin			; print it there
	mov	profs,=pfpd2		; and pad past count
	ldi	cfp_i(xr)		; load total exec time
	jsr	prtin			; print that too
	ldi	cfp_i(xr)		; reload time
	mli	intth			; convert to microsec
	iov	prfl2			; omit next bit if overflow
	dvi	(xr)			; divide by executions
	mov	profs,=pfpd3		; pad last print
	jsr	prtin			; and print mcsec/execn
;
;      merge after printing time
;
prfl2	jsr	prtnl			; thats another line
;
;      here to go to next entry
;
prfl3	add	xr,*pf_i2		; bump index ptr (sgd07)
	blt	wb,pfnte,prfl1		; loop if more stmts
	mov	xr,(xs)+		; restore callers xr
	mov	wb,pfsvw		; and wb too
;
;      here to exit
;
prfl4	exi				; return
	enp				; end of prflr
	ejc
;
;      prflu -- update an entry in the profile table
;
;      on entry, kvstn contains nr of stmt to profile
;
;      jsr  prflu	     call to update entry
;      (ia)		     destroyed
;
prflu	prc	e,0			;
	bnz	pffnc,pflu4		; skip if just entered function
	mov	-(xs),xr		; preserve entry xr
	mov	pfsvw,wa		; save wa (sgd07)
	bnz	pftbl,pflu2		; branch if table allocated
;
;      here if space for profile table not yet allocated.
;      calculate size needed, allocate a static xnblk, and
;      initialize it all to zero.
;      the time taken for this will be attributed to the current
;      statement (assignment to keywd profile), but since the
;      timing for this statement is up the pole anyway, this
;      doesnt really matter...
;
	sub	pfnte,=num01		; adjust for extra count (sgd07)
	mti	pfi2a			; convrt entry size to int
	sti	pfste			; and store safely for later
	mti	pfnte			; load table length as integer
	mli	pfste			; multiply by entry size
	mfi	wa			; get back address-style
	add	wa,=num02		; add on 2 word overhead
	wtb	wa			; convert the whole lot to bytes
	jsr	alost			; gimme the space
	mov	pftbl,xr		; save block pointer
	mov	(xr)+,=b_xnt		; put block type and ...
	mov	(xr)+,wa		; ... length into header
	mfi	wa			; get back nr of wds in data area
	lct	wa,wa			; load the counter
;
;      loop here to zero the block data
;
pflu1	zer	(xr)+			; blank a word
	bct	wa,pflu1		; and alllllll the rest
;
;      end of allocation. merge back into routine
;
pflu2	mti	kvstn			; load nr of stmt just ended
	sbi	intv1			; make into index offset
	mli	pfste			; make offset of table entry
	mfi	wa			; convert to address
	wtb	wa			; get as baus
	add	wa,*num02		; offset includes table header
	mov	xr,pftbl		; get table start
	bge	wa,num01(xr),pflu3	; if out of table, skip it
	add	xr,wa			; else point to entry
	ldi	(xr)			; get nr of executions so far
	adi	intv1			; nudge up one
	sti	(xr)			; and put back
	jsr	systm			; get time now
	sti	pfetm			; stash ending time
	sbi	pfstm			; subtract start time
	adi	cfp_i(xr)		; add cumulative time so far
	sti	cfp_i(xr)		; and put back new total
	ldi	pfetm			; load end time of this stmt ...
	sti	pfstm			; ... which is start time of next
;
;      merge here to exit
;
pflu3	mov	xr,(xs)+		; restore callers xr
	mov	wa,pfsvw		; restore saved reg
	exi				; and return
;
;      here if profile is suppressed because a program defined
;      function is about to be entered, and so the current stmt
;      has not yet finished
;
pflu4	zer	pffnc			; reset the condition flag
	exi				; and immediate return
	enp				; end of procedure prflu
	ejc
.fi
;
;      prpar - process print parameters
;
;      (wc)		     if nonzero associate terminal only
;      jsr  prpar	     call to process print parameters
;      (xl,xr,wa,wb,wc)	     destroyed
;
;      since memory allocation is undecided on initial call,
;      terminal cannot be associated. the entry with wc non-zero
;      is provided so a later call can be made to complete this.
;
prpar	prc	e,0			; entry point
	bnz	wc,prpa8		; jump to associate terminal
	jsr	syspp			; get print parameters
	bnz	wb,prpa1		; jump if lines/page specified
	mov	wb,mxint		; else use a large value
	rsh	wb,1			; but not too large
;
;      store line count/page
;
prpa1	mov	lstnp,wb		; store number of lines/page
	mov	lstlc,wb		; pretend page is full initially
	zer	lstpg			; clear page number
	mov	wb,prlen		; get prior length if any
	bze	wb,prpa2		; skip if no length
	bgt	wa,wb,prpa3		; skip storing if too big
;
;      store print buffer length
;
prpa2	mov	prlen,wa		; store value
;
;      process bits options
;
prpa3	mov	wb,bits3		; bit 3 mask
	anb	wb,wc			; get -nolist bit
	zrb	wb,prpa4		; skip if clear
	zer	cswls			; set -nolist
;
;      check if fail reports goto interactive channel
;
prpa4	mov	wb,bits1		; bit 1 mask
	anb	wb,wc			; get bit
	mov	erich,wb		; store int. chan. error flag
	mov	wb,bits2		; bit 2 mask
	anb	wb,wc			; get bit
	mov	prich,wb		; flag for std printer on int. chan.
	mov	wb,bits4		; bit 4 mask
	anb	wb,wc			; get bit
	mov	cpsts,wb		; flag for compile stats suppressn.
	mov	wb,bits5		; bit 5 mask
	anb	wb,wc			; get bit
	mov	exsts,wb		; flag for exec stats suppression
	ejc
;
;      prpar (continued)
;
	mov	wb,bits6		; bit 6 mask
	anb	wb,wc			; get bit
	mov	precl,wb		; extended/compact listing flag
	sub	wa,=num08		; point 8 chars from line end
	zrb	wb,prpa5		; jump if not extended
	mov	lstpo,wa		; store for listing page headings
;
;	continue option processing
;
prpa5	mov	wb,bits7		; bit 7 mask
	anb	wb,wc			; get bit 7
	mov	cswex,wb		; set -noexecute if non-zero
	mov	wb,bit10		; bit 10 mask
	anb	wb,wc			; get bit 10
	mov	headp,wb		; pretend printed to omit headers
	mov	wb,bits9		; bit 9 mask
	anb	wb,wc			; get bit 9
	mov	prsto,wb		; keep it as std listing option
.if    .culc
	mov	wb,wc			; copy flags
	rsh	wb,12			; right justify bit 13
	anb	wb,bits1		; get bit
	mov	kvcas,wb		; set -case
.fi
	mov	wb,bit12		; bit 12 mask
	anb	wb,wc			; get bit 12
	mov	cswer,wb		; keep it as errors/noerrors option
	zrb	wb,prpa6		; skip if clear
	mov	wa,prlen		; get print buffer length
	sub	wa,=num08		; point 8 chars from line end
	mov	lstpo,wa		; store page offset
;
;      check for -print/-noprint
;
prpa6	mov	wb,bit11		; bit 11 mask
	anb	wb,wc			; get bit 11
	mov	cswpr,wb		; set -print if non-zero
;
;      check for terminal
;
	anb	wc,bits8		; see if terminal to be activated
	bnz	wc,prpa8		; jump if terminal required
	bze	initr,prpa9		; jump if no terminal to detach
	mov	xl,=v_ter		; ptr to /terminal/
	jsr	gtnvr			; get vrblk pointer
	ppm				; cant fail
	mov	vrval(xr),=nulls	; clear value of terminal
	jsr	setvr			; remove association
	brn	prpa9			; return
;
;      associate terminal
;
prpa8	mnz	initr			; note terminal associated
	bze	dnamb,prpa9		; cant if memory not organised
	mov	xl,=v_ter		; point to terminal string
	mov	wb,=trtou		; output trace type
	jsr	inout			; attach output trblk to vrblk
	mov	-(xs),xr		; stack trblk ptr
	mov	xl,=v_ter		; point to terminal string
	mov	wb,=trtin		; input trace type
	jsr	inout			; attach input trace blk
	mov	vrval(xr),(xs)+		; add output trblk to chain
;
;      return point
;
prpa9	exi				; return
	enp				; end procedure prpar
	ejc
;
;      prtch -- print a character
;
;      prtch is used to print a single character
;
;      (wa)		     character to be printed
;      jsr  prtch	     call to print character
;
prtch	prc	e,0			; entry point
	mov	-(xs),xr		; save xr
	bne	profs,prlen,prch1	; jump if room in buffer
	jsr	prtnl			; else print this line
;
;      here after making sure we have room
;
prch1	mov	xr,prbuf		; point to print buffer
	psc	xr,profs		; point to next character location
	sch	wa,(xr)			; store new character
	csc	xr			; complete store characters
	icv	profs			; bump pointer
	mov	xr,(xs)+		; restore entry xr
	exi				; return to prtch caller
	enp				; end procedure prtch
	ejc
;
;      prtic -- print to interactive channel
;
;      prtic is called to print the contents of the standard
;      print buffer to the interactive channel. it is only
;      called after prtst has set up the string for printing.
;      it does not clear the buffer.
;
;      jsr  prtic	     call for print
;      (wa,wb)		     destroyed
;
prtic	prc	e,0			; entry point
	mov	-(xs),xr		; save xr
	mov	xr,prbuf		; point to buffer
	mov	wa,profs		; no of chars
	jsr	syspi			; print
	ppm	prtc2			; fail return
;
;      return
;
prtc1	mov	xr,(xs)+		; restore xr
	exi				; return
;
;      error occured
;
prtc2	zer	erich			; prevent looping
	erb	252,error on printing to interactive channel
	brn	prtc1			; return
	enp				; procedure prtic
	ejc
;
;      prtis -- print to interactive and standard printer
;
;      prtis puts a line from the print buffer onto the
;      interactive channel (if any) and the standard printer.
;      it always prints to the standard printer but does
;      not duplicate lines if the standard printer is
;      interactive.  it clears down the print buffer.
;
;      jsr  prtis	     call for printing
;      (wa,wb)		     destroyed
;
prtis	prc	e,0			; entry point
	bnz	prich,prts1		; jump if standard printer is int.ch.
	bze	erich,prts1		; skip if not doing int. error reps.
	jsr	prtic			; print to interactive channel
;
;      merge and exit
;
prts1	jsr	prtnl			; print to standard printer
	exi				; return
	enp				; end procedure prtis
	ejc
;
;      prtin -- print an integer
;
;      prtin prints the integer value which is in the integer
;      accumulator. blocks built in dynamic storage
;      during this process are immediately deleted.
;
;      (ia)		     integer value to be printed
;      jsr  prtin	     call to print integer
;      (ia,ra)		     destroyed
;
prtin	prc	e,0			; entry point
	mov	-(xs),xr		; save xr
	jsr	icbld			; build integer block
	blo	xr,dnamb,prti1		; jump if icblk below dynamic
	bhi	xr,dnamp,prti1		; jump if above dynamic
	mov	dnamp,xr		; immediately delete it
;
;      delete icblk from dynamic store
;
prti1	mov	-(xs),xr		; stack ptr for gtstg
	jsr	gtstg			; convert to string
	ppm				; convert error is impossible
	mov	dnamp,xr		; reset pointer to delete scblk
	jsr	prtst			; print integer string
	mov	xr,(xs)+		; restore entry xr
	exi				; return to prtin caller
	enp				; end procedure prtin
	ejc
;
;      prtmi -- print message and integer
;
;      prtmi is used to print messages together with an integer
;      value starting in column 15 (used by the routines at
;      the end of compilation).
;
;      jsr  prtmi	     call to print message and integer
;
prtmi	prc	e,0			; entry point
	jsr	prtst			; print string message
	mov	profs,=prtmf		; set column offset
	jsr	prtin			; print integer
	jsr	prtnl			; print line
	exi				; return to prtmi caller
	enp				; end procedure prtmi
	ejc
;
;      prtmm -- print memory used and available
;
;      prtmm is used to provide memory usage information in
;      both the end-of-compile and end-of-run statistics.
;
;      jsr  prtmm	     call to print memory stats
;
prtmm	prc	e,0			;
	mov	wa,dnamp		; next available loc
	sub	wa,statb		; minus start
.if    .cbyt
.else
	btw	wa			; convert to words
.fi
	mti	wa			; convert to integer
	mov	xr,=encm1		; point to /memory used (words)/
	jsr	prtmi			; print message
	mov	wa,dname		; end of memory
	sub	wa,dnamp		; minus next available loc
.if    .cbyt
.else
	btw	wa			; convert to words
.fi
	mti	wa			; convert to integer
	mov	xr,=encm2		; point to /memory available (words)/
	jsr	prtmi			; print line
	exi				; return to prtmm caller
	enp				; end of procedure prtmm
	ejc
;
;      prtmx  -- as prtmi with extra copy to interactive chan.
;
;      jsr  prtmx	     call for printing
;      (wa,wb)		     destroyed
;
prtmx	prc	e,0			; entry point
	jsr	prtst			; print string message
	mov	profs,=prtmf		; set column offset
	jsr	prtin			; print integer
	jsr	prtis			; print line
	exi				; return
	enp				; end procedure prtmx
	ejc
;
;      prtnl -- print new line (end print line)
;
;      prtnl prints the contents of the print buffer, resets
;      the buffer to all blanks and resets the print pointer.
;
;      jsr  prtnl	     call to print line
;
prtnl	prc	r,0			; entry point
	bnz	headp,prnl0		; were headers printed
	jsr	prtps			; no - print them
;
;      call syspr
;
prnl0	mov	-(xs),xr		; save entry xr
	mov	prtsa,wa		; save wa
	mov	prtsb,wb		; save wb
	mov	xr,prbuf		; load pointer to buffer
	mov	wa,profs		; load number of chars in buffer
	jsr	syspr			; call system print routine
	ppm	prnl2			; jump if failed
	lct	wa,prlnw		; load length of buffer in words
	add	xr,*schar		; point to chars of buffer
	mov	wb,nullw		; get word of blanks
;
;      loop to blank buffer
;
prnl1	mov	(xr)+,wb		; store word of blanks, bump ptr
	bct	wa,prnl1		; loop till all blanked
;
;      exit point
;
	mov	wb,prtsb		; restore wb
	mov	wa,prtsa		; restore wa
	mov	xr,(xs)+		; restore entry xr
	zer	profs			; reset print buffer pointer
	exi				; return to prtnl caller
;
;      file full or no output file for load module
;
prnl2	bnz	prtef,prnl3		; jump if not first time
	mnz	prtef			; mark first occurrence
	erb	253,print limit exceeded on standard output channel
;
;      stop at once
;
prnl3	mov	wb,=nini8		; ending code
	mov	wa,kvstn		; statement number
	mov	xl,r_fcb		; get fcblk chain head
	jsr	sysej			; stop
	enp				; end procedure prtnl
	ejc
;
;      prtnm -- print variable name
;
;      prtnm is used to print a character representation of the
;      name of a variable (not a value of datatype name)
;      names of pseudo-variables may not be passed to prtnm.
;
;      (xl)		     name base
;      (wa)		     name offset
;      jsr  prtnm	     call to print name
;      (wb,wc,ra)	     destroyed
;
prtnm	prc	r,0			; entry point (recursive, see prtvl)
	mov	-(xs),wa		; save wa (offset is collectable)
	mov	-(xs),xr		; save entry xr
	mov	-(xs),xl		; save name base
	bhi	xl,state,prn02		; jump if not natural variable
;
;      here for natural variable name, recognized by the fact
;      that the name base points into the static area.
;
	mov	xr,xl			; point to vrblk
	jsr	prtvn			; print name of variable
;
;      common exit point
;
prn01	mov	xl,(xs)+		; restore name base
	mov	xr,(xs)+		; restore entry value of xr
	mov	wa,(xs)+		; restore wa
	exi				; return to prtnm caller
;
;      here for case of non-natural variable
;
prn02	mov	wb,wa			; copy name offset
	bne	(xl),=b_pdt,prn03	; jump if array or table
;
;      for program defined datatype, prt fld name, left paren
;
	mov	xr,pddfp(xl)		; load pointer to dfblk
	add	xr,wa			; add name offset
	mov	xr,pdfof(xr)		; load vrblk pointer for field
	jsr	prtvn			; print field name
	mov	wa,=ch_pp		; load left paren
	jsr	prtch			; print character
	ejc
;
;      prtnm (continued)
;
;      now we print an identifying name for the object if one
;      can be found. the following code searches for a natural
;      variable which contains this object as value. if such a
;      variable is found, its name is printed, else the value
;      of the object (as printed by prtvl) is used instead.
;
;      first we point to the parent tbblk if this is the case of
;      a table element. to do this, chase down the trnxt chain.
;
prn03	bne	(xl),=b_tet,prn04	; jump if we got there (or not te)
	mov	xl,tenxt(xl)		; else move out on chain
	brn	prn03			; and loop back
;
;      now we are ready for the search. to speed things up in
;      the case of calls from dump where the same name base
;      will occur repeatedly while dumping an array or table,
;      we remember the last vrblk pointer found in prnmv. so
;      first check to see if we have this one again.
;
prn04	mov	xr,prnmv		; point to vrblk we found last time
	mov	wa,hshtb		; point to hash table in case not
	brn	prn07			; jump into search for special check
;
;      loop through hash slots
;
prn05	mov	xr,wa			; copy slot pointer
	ica	wa			; bump slot pointer
	sub	xr,*vrnxt		; introduce standard vrblk offset
;
;      loop through vrblks on one hash chain
;
prn06	mov	xr,vrnxt(xr)		; point to next vrblk on hash chain
;
;      merge here first time to check block we found last time
;
prn07	mov	wc,xr			; copy vrblk pointer
	bze	wc,prn09		; jump if chain end (or prnmv zero)
	ejc
;
;      prtnm (continued)
;
;      loop to find value (chase down possible trblk chain)
;
prn08	mov	xr,vrval(xr)		; load value
	beq	(xr),=b_trt,prn08	; loop if that was a trblk
;
;      now we have the value, is this the block we want
;
	beq	xr,xl,prn10		; jump if this matches the name base
	mov	xr,wc			; else point back to that vrblk
	brn	prn06			; and loop back
;
;      here to move to next hash slot
;
prn09	blt	wa,hshte,prn05		; loop back if more to go
	mov	xr,xl			; else not found, copy value pointer
	jsr	prtvl			; print value
	brn	prn11			; and merge ahead
;
;      here when we find a matching entry
;
prn10	mov	xr,wc			; copy vrblk pointer
	mov	prnmv,xr		; save for next time in
	jsr	prtvn			; print variable name
;
;      merge here if no entry found
;
prn11	mov	wc,(xl)			; load first word of name base
	bne	wc,=b_pdt,prn13		; jump if not program defined
;
;      for program defined datatype, add right paren and exit
;
	mov	wa,=ch_rp		; load right paren, merge
;
;      merge here to print final right paren or bracket
;
prn12	jsr	prtch			; print final character
	mov	wa,wb			; restore name offset
	brn	prn01			; merge back to exit
	ejc
;
;      prtnm (continued)
;
;      here for array or table
;
prn13	mov	wa,=ch_bb		; load left bracket
	jsr	prtch			; and print it
	mov	xl,(xs)			; restore block pointer
	mov	wc,(xl)			; load type word again
	bne	wc,=b_tet,prn15		; jump if not table
;
;      here for table, print subscript value
;
	mov	xr,tesub(xl)		; load subscript value
	mov	xl,wb			; save name offset
	jsr	prtvl			; print subscript value
	mov	wb,xl			; restore name offset
;
;      merge here from array case to print right bracket
;
prn14	mov	wa,=ch_rb		; load right bracket
	brn	prn12			; merge back to print it
;
;      here for array or vector, to print subscript(s)
;
prn15	mov	wa,wb			; copy name offset
	btw	wa			; convert to words
	beq	wc,=b_art,prn16		; jump if arblk
;
;      here for vector
;
	sub	wa,=vcvlb		; adjust for standard fields
	mti	wa			; move to integer accum
	jsr	prtin			; print linear subscript
	brn	prn14			; merge back for right bracket
	ejc
;
;      prtnm (continued)
;
;      here for array. first calculate absolute subscript
;      offsets by successive divisions by the dimension values.
;      this must be done right to left since the elements are
;      stored row-wise. the subscripts are stacked as integers.
;
prn16	mov	wc,arofs(xl)		; load length of bounds info
	ica	wc			; adjust for arpro field
	btw	wc			; convert to words
	sub	wa,wc			; get linear zero-origin subscript
	mti	wa			; get integer value
	lct	wa,arndm(xl)		; set num of dimensions as loop count
	add	xl,arofs(xl)		; point past bounds information
	sub	xl,*arlbd		; set ok offset for proper ptr later
;
;      loop to stack subscript offsets
;
prn17	sub	xl,*ardms		; point to next set of bounds
	sti	prnsi			; save current offset
	rmi	ardim(xl)		; get remainder on dividing by dimens
	mfi	-(xs)			; store on stack (one word)
	ldi	prnsi			; reload argument
	dvi	ardim(xl)		; divide to get quotient
	bct	wa,prn17		; loop till all stacked
	zer	xr			; set offset to first set of bounds
	lct	wb,arndm(xl)		; load count of dims to control loop
	brn	prn19			; jump into print loop
;
;      loop to print subscripts from stack adjusting by adding
;      the appropriate low bound value from the arblk
;
prn18	mov	wa,=ch_cm		; load a comma
	jsr	prtch			; print it
;
;      merge here first time in (no comma required)
;
prn19	mti	(xs)+			; load subscript offset as integer
	add	xl,xr			; point to current lbd
	adi	arlbd(xl)		; add lbd to get signed subscript
	sub	xl,xr			; point back to start of arblk
	jsr	prtin			; print subscript
	add	xr,*ardms		; bump offset to next bounds
	bct	wb,prn18		; loop back till all printed
	brn	prn14			; merge back to print right bracket
	enp				; end procedure prtnm
	ejc
;
;      prtnv -- print name value
;
;      prtnv is used by the trace and dump routines to print
;      a line of the form
;
;      name = value
;
;      note that the name involved can never be a pseudo-var
;
;      (xl)		     name base
;      (wa)		     name offset
;      jsr  prtnv	     call to print name = value
;      (wb,wc,ra)	     destroyed
;
prtnv	prc	e,0			; entry point
	jsr	prtnm			; print argument name
	mov	-(xs),xr		; save entry xr
	mov	-(xs),wa		; save name offset (collectable)
	mov	xr,=tmbeb		; point to blank equal blank
	jsr	prtst			; print it
	mov	xr,xl			; copy name base
	add	xr,wa			; point to value
	mov	xr,(xr)			; load value pointer
	jsr	prtvl			; print value
	jsr	prtnl			; terminate line
	mov	wa,(xs)+		; restore name offset
	mov	xr,(xs)+		; restore entry xr
	exi				; return to caller
	enp				; end procedure prtnv
	ejc
;
;      prtpg  -- print a page throw
;
;      prints a page throw or a few blank lines on the standard
;      listing channel depending on the listing options chosen.
;
;      jsr  prtpg	     call for page eject
;
prtpg	prc	e,0			; entry point
	beq	stage,=stgxt,prp01	; jump if execution time
	bze	lstlc,prp06		; return if top of page already
	zer	lstlc			; clear line count
;
;      check type of listing
;
prp01	mov	-(xs),xr		; preserve xr
	bnz	prstd,prp02		; eject if flag set
	bnz	prich,prp03		; jump if interactive listing channel
	bze	precl,prp03		; jump if compact listing
;
;      perform an eject
;
prp02	jsr	sysep			; eject
	brn	prp04			; merge
;
;      compact or interactive channel listing. cant print
;      blanks until check made for headers printed and flag set.
;
;
prp03	mov	xr,headp		; remember headp
	mnz	headp			; set to avoid repeated prtpg calls
	jsr	prtnl			; print blank line
	jsr	prtnl			; print blank line
	jsr	prtnl			; print blank line
	mov	lstlc,=num03		; count blank lines
	mov	headp,xr		; restore header flag
	ejc
;
;      prptg (continued)
;
;      print the heading
;
prp04	bnz	headp,prp05		; jump if header listed
	mnz	headp			; mark headers printed
	mov	-(xs),xl		; keep xl
	mov	xr,=headr		; point to listing header
	jsr	prtst			; place it
	jsr	sysid			; get system identification
	jsr	prtst			; append extra chars
	jsr	prtnl			; print it
	mov	xr,xl			; extra header line
	jsr	prtst			; place it
	jsr	prtnl			; print it
	jsr	prtnl			; print a blank
	jsr	prtnl			; and another
	add	lstlc,=num04		; four header lines printed
	mov	xl,(xs)+		; restore xl
;
;      merge if header not printed
;
prp05	mov	xr,(xs)+		; restore xr
;
;      return
;
prp06	exi				; return
	enp				; end procedure prtpg
	ejc
;
;      prtps - print page with test for standard listing option
;
;      if the standard listing option is selected, insist that
;      an eject be done
;
;      jsr  prtps	     call for eject
;
prtps	prc	e,0			; entry point
	mov	prstd,prsto		; copy option flag
	jsr	prtpg			; print page
	zer	prstd			; clear flag
	exi				; return
	enp				; end procedure prtps
	ejc
;
;      prtsn -- print statement number
;
;      prtsn is used to initiate a print trace line by printing
;      asterisks and the current statement number. the actual
;      format of the output generated is.
;
;      ***nnnnn**** iii.....iiii
;
;      nnnnn is the statement number with leading zeros replaced
;      by asterisks (e.g. *******9****)
;
;      iii...iii represents a variable length output consisting
;      of a number of letter i characters equal to fnclevel.
;
;      jsr  prtsn	     call to print statement number
;      (wc)		     destroyed
;
prtsn	prc	e,0			; entry point
	mov	-(xs),xr		; save entry xr
	mov	prsna,wa		; save entry wa
	mov	xr,=tmasb		; point to asterisks
	jsr	prtst			; print asterisks
	mov	profs,=num04		; point into middle of asterisks
	mti	kvstn			; load statement number as integer
	jsr	prtin			; print integer statement number
	mov	profs,=prsnf		; point past asterisks plus blank
	mov	xr,kvfnc		; get fnclevel
	mov	wa,=ch_li		; set letter i
;
;      loop to generate letter i fnclevel times
;
prsn1	bze	xr,prsn2		; jump if all set
	jsr	prtch			; else print an i
	dcv	xr			; decrement counter
	brn	prsn1			; loop back
;
;      merge with all letter i characters generated
;
prsn2	mov	wa,=ch_bl		; get blank
	jsr	prtch			; print blank
	mov	wa,prsna		; restore entry wa
	mov	xr,(xs)+		; restore entry xr
	exi				; return to prtsn caller
	enp				; end procedure prtsn
	ejc
;
;      prtst -- print string
;
;      prtst places a string of characters in the print buffer
;
;      see prtnl for global locations used
;
;      note that the first word of the block (normally b_scl)
;      is not used and need not be set correctly (see prtvn)
;
;      (xr)		     string to be printed
;      jsr  prtst	     call to print string
;      (profs)		     updated past chars placed
;
prtst	prc	r,0			; entry point
	bnz	headp,prst0		; were headers printed
	jsr	prtps			; no - print them
;
;      call syspr
;
prst0	mov	prsva,wa		; save wa
	mov	prsvb,wb		; save wb
	zer	wb			; set chars printed count to zero
;
;      loop to print successive lines for long string
;
prst1	mov	wa,sclen(xr)		; load string length
	sub	wa,wb			; subtract count of chars already out
	bze	wa,prst4		; jump to exit if none left
	mov	-(xs),xl		; else stack entry xl
	mov	-(xs),xr		; save argument
	mov	xl,xr			; copy for eventual move
	mov	xr,prlen		; load print buffer length
	sub	xr,profs		; get chars left in print buffer
	bnz	xr,prst2		; skip if room left on this line
	jsr	prtnl			; else print this line
	mov	xr,prlen		; and set full width available
	ejc
;
;      prtst (continued)
;
;      here with chars to print and some room in buffer
;
prst2	blo	wa,xr,prst3		; jump if room for rest of string
	mov	wa,xr			; else set to fill line
;
;      merge here with character count in wa
;
prst3	mov	xr,prbuf		; point to print buffer
	plc	xl,wb			; point to location in string
	psc	xr,profs		; point to location in buffer
	add	wb,wa			; bump string chars count
	add	profs,wa		; bump buffer pointer
	mov	prsvc,wb		; preserve char counter
	mvc				; move characters to buffer
	mov	wb,prsvc		; recover char counter
	mov	xr,(xs)+		; restore argument pointer
	mov	xl,(xs)+		; restore entry xl
	brn	prst1			; loop back to test for more
;
;      here to exit after printing string
;
prst4	mov	wb,prsvb		; restore entry wb
	mov	wa,prsva		; restore entry wa
	exi				; return to prtst caller
	enp				; end procedure prtst
	ejc
;
;      prttr -- print to terminal
;
;      called to print contents of standard print buffer to
;      online terminal. clears buffer down and resets profs.
;
;      jsr  prttr	     call for print
;      (wa,wb)		     destroyed
;
prttr	prc	e,0			; entry point
	mov	-(xs),xr		; save xr
	jsr	prtic			; print buffer contents
	mov	xr,prbuf		; point to print bfr to clear it
	lct	wa,prlnw		; get buffer length
	add	xr,*schar		; point past scblk header
	mov	wb,nullw		; get blanks
;
;      loop to clear buffer
;
prtt1	mov	(xr)+,wb		; clear a word
	bct	wa,prtt1		; loop
	zer	profs			; reset profs
	mov	xr,(xs)+		; restore xr
	exi				; return
	enp				; end procedure prttr
	ejc
;
;      prtvl -- print a value
;
;      prtvl places an appropriate character representation of
;      a data value in the print buffer for dump/trace use.
;
;      (xr)		     value to be printed
;      jsr  prtvl	     call to print value
;      (wa,wb,wc,ra)	     destroyed
;
prtvl	prc	r,0			; entry point, recursive
	mov	-(xs),xl		; save entry xl
	mov	-(xs),xr		; save argument
	chk				; check for stack overflow
;
;      loop back here after finding a trap block (trblk)
;
prv01	mov	prvsi,idval(xr)		; copy idval (if any)
	mov	xl,(xr)			; load first word of block
	lei	xl			; load entry point id
	bsw	xl,bl__t,prv02		; switch on block type
	iff	bl_tr,prv04		; trblk
	iff	bl_ar,prv05		; arblk
	iff	bl_ic,prv08		; icblk
	iff	bl_nm,prv09		; nmblk
	iff	bl_pd,prv10		; pdblk
.if    .cnra
.else
	iff	bl_rc,prv08		; rcblk
.fi
	iff	bl_sc,prv11		; scblk
	iff	bl_se,prv12		; seblk
	iff	bl_tb,prv13		; tbblk
	iff	bl_vc,prv13		; vcblk
.if    .cnbf
.else
	iff	bl_bc,prv15		; bcblk
.fi
	esw				; end of switch on block type
;
;      here for blocks for which we just print datatype name
;
prv02	jsr	dtype			; get datatype name
	jsr	prtst			; print datatype name
;
;      common exit point
;
prv03	mov	xr,(xs)+		; reload argument
	mov	xl,(xs)+		; restore xl
	exi				; return to prtvl caller
;
;      here for trblk
;
prv04	mov	xr,trval(xr)		; load real value
	brn	prv01			; and loop back
	ejc
;
;      prtvl (continued)
;
;      here for array (arblk)
;
;      print array ( prototype ) blank number idval
;
prv05	mov	xl,xr			; preserve argument
	mov	xr,=scarr		; point to datatype name (array)
	jsr	prtst			; print it
	mov	wa,=ch_pp		; load left paren
	jsr	prtch			; print left paren
	add	xl,arofs(xl)		; point to prototype
	mov	xr,(xl)			; load prototype
	jsr	prtst			; print prototype
;
;      vcblk, tbblk, bcblk merge here for ) blank number idval
;
prv06	mov	wa,=ch_rp		; load right paren
	jsr	prtch			; print right paren
;
;      pdblk merges here to print blank number idval
;
prv07	mov	wa,=ch_bl		; load blank
	jsr	prtch			; print it
	mov	wa,=ch_nm		; load number sign
	jsr	prtch			; print it
	mti	prvsi			; get idval
	jsr	prtin			; print id number
	brn	prv03			; back to exit
;
;      here for integer (icblk), real (rcblk)
;
;      print character representation of value
;
prv08	mov	-(xs),xr		; stack argument for gtstg
	jsr	gtstg			; convert to string
	ppm				; error return is impossible
	jsr	prtst			; print the string
	mov	dnamp,xr		; delete garbage string from storage
	brn	prv03			; back to exit
	ejc
;
;      prtvl (continued)
;
;      name (nmblk)
;
;      for pseudo-variable, just print datatype name (name)
;      for all other names, print dot followed by name rep
;
prv09	mov	xl,nmbas(xr)		; load name base
	mov	wa,(xl)			; load first word of block
	beq	wa,=b_kvt,prv02		; just print name if keyword
	beq	wa,=b_evt,prv02		; just print name if expression var
	mov	wa,=ch_dt		; else get dot
	jsr	prtch			; and print it
	mov	wa,nmofs(xr)		; load name offset
	jsr	prtnm			; print name
	brn	prv03			; back to exit
;
;      program datatype (pdblk)
;
;      print datatype name ch_bl ch_nm idval
;
prv10	jsr	dtype			; get datatype name
	jsr	prtst			; print datatype name
	brn	prv07			; merge back to print id
;
;      here for string (scblk)
;
;      print quote string-characters quote
;
prv11	mov	wa,=ch_sq		; load single quote
	jsr	prtch			; print quote
	jsr	prtst			; print string value
	jsr	prtch			; print another quote
	brn	prv03			; back to exit
	ejc
;
;      prtvl (continued)
;
;      here for simple expression (seblk)
;
;      print asterisk variable-name
;
prv12	mov	wa,=ch_as		; load asterisk
	jsr	prtch			; print asterisk
	mov	xr,sevar(xr)		; load variable pointer
	jsr	prtvn			; print variable name
	brn	prv03			; jump back to exit
;
;      here for table (tbblk) and array (vcblk)
;
;      print datatype ( prototype ) blank number idval
;
prv13	mov	xl,xr			; preserve argument
	jsr	dtype			; get datatype name
	jsr	prtst			; print datatype name
	mov	wa,=ch_pp		; load left paren
	jsr	prtch			; print left paren
	mov	wa,tblen(xl)		; load length of block (=vclen)
	btw	wa			; convert to word count
	sub	wa,=tbsi_		; allow for standard fields
	beq	(xl),=b_tbt,prv14	; jump if table
	add	wa,=vctbd		; for vcblk, adjust size
;
;      print prototype
;
prv14	mti	wa			; move as integer
	jsr	prtin			; print integer prototype
	brn	prv06			; merge back for rest
.if    .cnbf
.else
	ejc
;
;      prtvl (continued)
;
;      here for buffer (bcblk)
;
prv15	mov	xl,xr			; preserve argument
	mov	xr,=scbuf		; point to datatype name (buffer)
	jsr	prtst			; print it
	mov	wa,=ch_pp		; load left paren
	jsr	prtch			; print left paren
	mov	xr,bcbuf(xl)		; point to bfblk
	mti	bfalc(xr)		; load allocation size
	jsr	prtin			; print it
	mov	wa,=ch_cm		; load comma
	jsr	prtch			; print it
	mti	bclen(xl)		; load defined length
	jsr	prtin			; print it
	brn	prv06			; merge to finish up
.fi
	enp				; end procedure prtvl
	ejc
;
;      prtvn -- print natural variable name
;
;      prtvn prints the name of a natural variable
;
;      (xr)		     pointer to vrblk
;      jsr  prtvn	     call to print variable name
;
prtvn	prc	e,0			; entry point
	mov	-(xs),xr		; stack vrblk pointer
	add	xr,*vrsof		; point to possible string name
	bnz	sclen(xr),prvn1		; jump if not system variable
	mov	xr,vrsvo(xr)		; point to svblk with name
;
;      merge here with dummy scblk pointer in xr
;
prvn1	jsr	prtst			; print string name of variable
	mov	xr,(xs)+		; restore vrblk pointer
	exi				; return to prtvn caller
	enp				; end procedure prtvn
.if    .cnra
.else
	ejc
;
;      rcbld -- build a real block
;
;      (ra)		     real value for rcblk
;      jsr  rcbld	     call to build real block
;      (xr)		     pointer to result rcblk
;      (wa)		     destroyed
;
rcbld	prc	e,0			; entry point
	mov	xr,dnamp		; load pointer to next available loc
	add	xr,*rcsi_		; point past new rcblk
	blo	xr,dname,rcbl1		; jump if there is room
	mov	wa,*rcsi_		; else load rcblk length
	jsr	alloc			; use standard allocator to get block
	add	xr,wa			; point past block to merge
;
;      merge here with xr pointing past the block obtained
;
rcbl1	mov	dnamp,xr		; set new pointer
	sub	xr,*rcsi_		; point back to start of block
	mov	(xr),=b_rcl		; store type word
	str	rcval(xr)		; store real value in rcblk
	exi				; return to rcbld caller
	enp				; end procedure rcbld
.fi
	ejc
;
;      readr -- read next source image at compile time
;
;      readr is used to read the next source image. to process
;      continuation cards properly, the compiler must read one
;      line ahead. thus readr does not destroy the current image
;      see also the nexts routine which actually gets the image.
;
;      jsr  readr	     call to read next image
;      (xr)		     ptr to next image (0 if none)
;      (r_cni)		     copy of pointer
;      (wa,wb,wc,xl)	     destroyed
;
readr	prc	e,0			; entry point
	mov	xr,r_cni		; get ptr to next image
	bnz	xr,read3		; exit if already read
.if    .cinc
	bnz	cnind,reada		; if within include file
.fi
	bne	stage,=stgic,read3	; exit if not initial compile
reada	mov	wa,cswin		; max read length
	zer	xl			; clear any dud value in xl
	jsr	alocs			; allocate buffer
	jsr	sysrd			; read input image
	ppm	read4			; jump if eof or new file name
	icv	rdnln			; increment next line number
.if    .cpol
	dcv	polct			; test if time to poll interface
	bnz	polct,read0		; not yet
	zer	wa			; =0 for poll
	mov	wb,rdnln		; line number
	jsr	syspl			; allow interactive access
	err	320,user interrupt
	ppm				; single step
	ppm				; expression evaluation
	mov	polcs,wa		; new countdown start value
	mov	polct,wa		; new counter value
.fi
read0	ble	sclen(xr),cswin,read1	; use smaller of string lnth ...
	mov	sclen(xr),cswin		; ... and xxx of -inxxx
;
;      perform the trim
;
read1	mnz	wb			; set trimr to perform trim
	jsr	trimr			; trim trailing blanks
;
;      merge here after read
;
read2	mov	r_cni,xr		; store copy of pointer
;
;      merge here if no read attempted
;
read3	exi				; return to readr caller
.if    .csfn
;
;      here on end of file or new source file name.
;      if this is a new source file name, the r_sfn table will
;      be augmented with a new table entry consisting of the
;      current compiler statement number as subscript, and the
;      file name as value.
;
read4	bze	sclen(xr),read5		; jump if true end of file
	zer	wb			; new source file name
	mov	rdnln,wb		; restart line counter for new file
	jsr	trimr			; remove unused space in block
	jsr	newfn			; record new file name
	brn	reada			; now reissue read for record data
;
;      here on end of file
;
read5	mov	dnamp,xr		; pop unused scblk
.if    .cinc
	bze	cnind,read6		; jump if not within an include file
	zer	xl			; eof within include file
	jsr	sysif			; switch stream back to previous file
	ppm
	mov	wa,cnind		; restore prev line number, file name
	add	wa,=vcvlb		; vector offset in words
	wtb	wa			; convert to bytes
	mov	xr,r_ifa		; file name array
	add	xr,wa			; ptr to element
	mov	r_sfc,(xr)		; change source file name
	mov	(xr),=nulls		; release scblk
	mov	xr,r_ifl		; line number array
	add	xr,wa			; ptr to element
	mov	xl,(xr)			; icblk containing saved line number
	ldi	icval(xl)		; line number integer
	mfi	rdnln			; change source line number
	mov	(xr),=inton		; release icblk
	dcv	cnind			; decrement nesting level
	mov	wb,cmpsn		; current statement number
	icv	wb			; anticipate end of previous stmt
	mti	wb			; convert to integer
	jsr	icbld			; build icblk for stmt number
	mov	xl,r_sfn		; file name table
	mnz	wb			; lookup statement number by name
	jsr	tfind			; allocate new teblk
	ppm				; always possible to allocate block
	mov	teval(xl),r_sfc		; record file name as entry value
	beq	stage,=stgic,reada	; if initial compile, reissue read
	bnz	cnind,reada		; still reading from include file
;
;      outer nesting of execute-time compile of -include
;      resume with any string remaining prior to -include.
;
	mov	xl,r_ici		; restore code argument string
	zer	r_ici			; release original string
	mov	wa,cnsil		; get length of string
	mov	wb,cnspt		; offset of characters left
	sub	wa,wb			; number of characters left
	mov	scnil,wa		; set new scan length
	zer	scnpt			; scan from start of substring
	jsr	sbstr			; create substring of remainder
	mov	r_cim,xr		; set scan image
	brn	read2			; return
.fi
.else
;
;      here on end of file
;
read4	mov	dnamp,xr		; pop unused scblk
.if    .cinc
	bze	cnind,read6		; jump if not within an include file
	zer	xl			; eof within include file
	jsr	sysif			; switch stream back to previous file
	ppm
	dcv	cnind			; decrement nesting level
	brn	reada			; reissue read from previous stream
.fi
.fi
read6	zer	xr			; zero ptr as result
	brn	read2			; merge
	enp				; end procedure readr
	ejc
.if    .c370
;
;      sbool-- setup for boolean operations on strings
;
;      1(xs)		     first argument (if two)
;      0(xs)		     second argument
;      (wb)		     number of arguments
;			      zero = one arguments
;			      non-zero = two arguments
;      jsr  sbool	     call to perform operation
;      ppm  loc		     transfer loc for arg1 not string
;      ppm  loc		     transfer loc for arg2 not string
;      ppm  loc		     transfer loc arg lengths not equal
;      ppm  loc		     transfer loc if null string args
;      (xs)		     arguments popped, result stacked
;      (xl)		     arg 1 chars to operate upon
;      (xr)		     copy of arg 2 if two arguments
;      (wa)		     no. of characters to process
;      (wc)		     no. of words to process (bct ready)
;      (wb)		     destroyed
;
;      the second argument string block is copied to a result
;      block, and pointers returned to allow the caller to
;      proceed with the desired operation if two arguments.
;
;      operations like and/or that do not alter the trailing
;      zeros in the last word of the string block can be
;      performed a word at a time.  operations such as compl
;      may either be performed a character at a time or will
;      have to adjust the last word if done a word at a time.
;
sbool	prc	n,3			; entry point
	jsr	gtstg			; convert second arg to string
	ppm	sbl05			; jump if second arg not string
	mov	xl,xr			; else save pointer
	mov	wc,wa			; and length
	bze	wb,sbl01		; only one argument if compl
	jsr	gtstg			; convert first argument to string
	ppm	sbl04			; jump if not string
	bne	wa,wc,sbl03		; jump if lengths unequal
;
;      merge here if only one argument
;
sbl01	mov	-(xs),xr		; stack first argument
	bze	wc,sbl02		; return null if null argument
	jsr	alocs			; allocate space for copy
	bze	wb,sbl06		; only one argument if compl
	mov	wa,wc			; string length
	mov	wb,xr			; save address of copy
	ctb	wa,schar		; get scblk length
	mvw				; move arg2 contents to copy
	mov	xr,wb			; reload result ptr
sbl06	mov	xl,(xs)+		; reload first argument
	mov	-(xs),xr		; stack result
	add	xl,*schar		; point to characters in arg 1 block
	add	xr,*schar		; point to characters in result block
	mov	wa,wc			; character count
	ctw	wc,0			; number of words of characters
	lct	wc,wc			; prepare counter
	exi
;
;      here if null arguments
;
sbl02	exi	4			; take null string exit
;
;      here if argument lengths unequal
;
sbl03	exi	3			; take unequal length error exit
;
;      here if first arg is not a string
;
sbl04	exi	1			; take bad first arg error exit
;
;      here for second arg not a string
;
sbl05	exi	2			; take bad second arg error exit
	enp				; end procedure sbool
	ejc
.fi
;
;      sbstr -- build a substring
;
;      (xl)		     ptr to scblk/bfblk with chars
;      (wa)		     number of chars in substring
;      (wb)		     offset to first char in scblk
;      jsr  sbstr	     call to build substring
;      (xr)		     ptr to new scblk with substring
;      (xl)		     zero
;      (wa,wb,wc,xl,ia)	     destroyed
;
;      note that sbstr is called with a dummy string pointer
;      (pointing into a vrblk or svblk) to copy the name of a
;      variable as a standard string value.
;
sbstr	prc	e,0			; entry point
	bze	wa,sbst2		; jump if null substring
	jsr	alocs			; else allocate scblk
	mov	wa,wc			; move number of characters
	mov	wc,xr			; save ptr to new scblk
	plc	xl,wb			; prepare to load chars from old blk
	psc	xr			; prepare to store chars in new blk
	mvc				; move characters to new string
	mov	xr,wc			; then restore scblk pointer
;
;      return point
;
sbst1	zer	xl			; clear garbage pointer in xl
	exi				; return to sbstr caller
;
;      here for null substring
;
sbst2	mov	xr,=nulls		; set null string as result
	brn	sbst1			; return
	enp				; end procedure sbstr
	ejc
;
;      stgcc -- compute counters for stmt startup testing
;
;      jsr  stgcc	     call to recompute counters
;      (wa,wb)		     destroyed
;
;      on exit, stmcs and stmct contain the counter value to
;      tested in stmgo.
;
;
stgcc	prc	e,0			;
.if    .cpol
	mov	wa,polcs		; assume no profiling or stcount tracing
	mov	wb,=num01		; poll each time polcs expires
.else
	mov	wa,mxint		; assume no profiling or stcount tracing
.fi
	ldi	kvstl			; get stmt limit
	bnz	kvpfl,stgc1		; jump if profiling enabled
	ilt	stgc3			; no stcount tracing if negative
	bze	r_stc,stgc2		; jump if not stcount tracing
;
;      here if profiling or if stcount tracing enabled
;
.if    .cpol
stgc1	mov	wb,wa			; count polcs times within stmg
	mov	wa,=num01		; break out of stmgo on each stmt
.else
stgc1	mov	wa,=num01		; break out of stmgo on each stmt
.fi
	brn	stgc3			;
;
;      check that stmcs does not exceed kvstl
;
stgc2	mti	wa			; breakout count start value
	sbi	kvstl			; proposed stmcs minus stmt limit
	ile	stgc3			; jump if stmt count does not limit
	ldi	kvstl			; stlimit limits breakcount count
	mfi	wa			; use it instead
;
;      re-initialize counter
;
stgc3	mov	stmcs,wa		; update breakout count start value
	mov	stmct,wa		; reset breakout counter
.if    .cpol
	mov	polct,wb		;
.fi
	exi
	ejc
;
;      tfind -- locate table element
;
;      (xr)		     subscript value for element
;      (xl)		     pointer to table
;      (wb)		     zero by value, non-zero by name
;      jsr  tfind	     call to locate element
;      ppm  loc		     transfer location if access fails
;      (xr)		     element value (if by value)
;      (xr)		     destroyed (if by name)
;      (xl,wa)		     teblk name (if by name)
;      (xl,wa)		     destroyed (if by value)
;      (wc,ra)		     destroyed
;
;      note that if a call by value specifies a non-existent
;      subscript, the default value is returned without building
;      a new teblk.
;
tfind	prc	e,1			; entry point
	mov	-(xs),wb		; save name/value indicator
	mov	-(xs),xr		; save subscript value
	mov	-(xs),xl		; save table pointer
	mov	wa,tblen(xl)		; load length of tbblk
	btw	wa			; convert to word count
	sub	wa,=tbbuk		; get number of buckets
	mti	wa			; convert to integer value
	sti	tfnsi			; save for later
	mov	xl,(xr)			; load first word of subscript
	lei	xl			; load block entry id (bl_xx)
	bsw	xl,bl__d,tfn00		; switch on block type
	iff	bl_ic,tfn02		; jump if integer
.if    .cnra
.else
	iff	bl_rc,tfn02		; real
.fi
	iff	bl_p0,tfn03		; jump if pattern
	iff	bl_p1,tfn03		; jump if pattern
	iff	bl_p2,tfn03		; jump if pattern
	iff	bl_nm,tfn04		; jump if name
	iff	bl_sc,tfn05		; jump if string
	esw				; end switch on block type
;
;      here for blocks for which we use the second word of the
;      block as the hash source (see block formats for details).
;
tfn00	mov	wa,1(xr)		; load second word
;
;      merge here with one word hash source in wa
;
tfn01	mti	wa			; convert to integer
	brn	tfn06			; jump to merge
	ejc
;
;      tfind (continued)
;
;      here for integer or real
;      possibility of overflow exist on twos complement
;      machine if hash source is most negative integer or is
;      a real having the same bit pattern.
;
;
tfn02	ldi	1(xr)			; load value as hash source
	ige	tfn06			; ok if positive or zero
	ngi				; make positive
	iov	tfn06			; clear possible overflow
	brn	tfn06			; merge
;
;      for pattern, use first word (pcode) as source
;
tfn03	mov	wa,(xr)			; load first word as hash source
	brn	tfn01			; merge back
;
;      for name, use offset as hash source
;
tfn04	mov	wa,nmofs(xr)		; load offset as hash source
	brn	tfn01			; merge back
;
;      here for string
;
tfn05	jsr	hashs			; call routine to compute hash
;
;      merge here with hash source in (ia)
;
tfn06	rmi	tfnsi			; compute hash index by remaindering
	mfi	wc			; get as one word integer
	wtb	wc			; convert to byte offset
	mov	xl,(xs)			; get table ptr again
	add	xl,wc			; point to proper bucket
	mov	xr,tbbuk(xl)		; load first teblk pointer
	beq	xr,(xs),tfn10		; jump if no teblks on chain
;
;      loop through teblks on hash chain
;
tfn07	mov	wb,xr			; save teblk pointer
	mov	xr,tesub(xr)		; load subscript value
	mov	xl,1(xs)		; load input argument subscript val
	jsr	ident			; compare them
	ppm	tfn08			; jump if equal (ident)
;
;      here if no match with that teblk
;
	mov	xl,wb			; restore teblk pointer
	mov	xr,tenxt(xl)		; point to next teblk on chain
	bne	xr,(xs),tfn07		; jump if there is one
;
;      here if no match with any teblk on chain
;
	mov	wc,*tenxt		; set offset to link field (xl base)
	brn	tfn11			; jump to merge
	ejc
;
;      tfind (continued)
;
;      here we have found a matching element
;
tfn08	mov	xl,wb			; restore teblk pointer
	mov	wa,*teval		; set teblk name offset
	mov	wb,2(xs)		; restore name/value indicator
	bnz	wb,tfn09		; jump if called by name
	jsr	acess			; else get value
	ppm	tfn12			; jump if reference fails
	zer	wb			; restore name/value indicator
;
;      common exit for entry found
;
tfn09	add	xs,*num03		; pop stack entries
	exi				; return to tfind caller
;
;      here if no teblks on the hash chain
;
tfn10	add	wc,*tbbuk		; get offset to bucket ptr
	mov	xl,(xs)			; set tbblk ptr as base
;
;      merge here with (xl,wc) base,offset of final link
;
tfn11	mov	xr,(xs)			; tbblk pointer
	mov	xr,tbinv(xr)		; load default value in case
	mov	wb,2(xs)		; load name/value indicator
	bze	wb,tfn09		; exit with default if value call
	mov	wb,xr			; copy default value
;
;      here we must build a new teblk
;
	mov	wa,*tesi_		; set size of teblk
	jsr	alloc			; allocate teblk
	add	xl,wc			; point to hash link
	mov	(xl),xr			; link new teblk at end of chain
	mov	(xr),=b_tet		; store type word
	mov	teval(xr),wb		; set default as initial value
	mov	tenxt(xr),(xs)+		; set tbblk ptr to mark end of chain
	mov	tesub(xr),(xs)+		; store subscript value
	mov	wb,(xs)+		; restore name/value indicator
	mov	xl,xr			; copy teblk pointer (name base)
	mov	wa,*teval		; set offset
	exi				; return to caller with new teblk
;
;      acess fail return
;
tfn12	exi	1			; alternative return
	enp				; end procedure tfind
	ejc
;
;      tmake -- make new table
;
;      (xl)		     initial lookup value
;      (wc)		     number of buckets desired
;      jsr  tmake	     call to make new table
;      (xr)		     new table
;      (wa,wb)		     destroyed
;
tmake	prc	e,0			;
	mov	wa,wc			; copy number of headers
	add	wa,=tbsi_		; adjust for standard fields
	wtb	wa			; convert length to bytes
	jsr	alloc			; allocate space for tbblk
	mov	wb,xr			; copy pointer to tbblk
	mov	(xr)+,=b_tbt		; store type word
	zer	(xr)+			; zero id for the moment
	mov	(xr)+,wa		; store length (tblen)
	mov	(xr)+,xl		; store initial lookup value
	lct	wc,wc			; set loop counter (num headers)
;
;      loop to initialize all bucket pointers
;
tma01	mov	(xr)+,wb		; store tbblk ptr in bucket header
	bct	wc,tma01		; loop till all stored
	mov	xr,wb			; recall pointer to tbblk
	exi
	enp
	ejc
;
;      vmake -- create a vector
;
;      (wa)		     number of elements in vector
;      (xl)		     default value for vector elements
;      jsr  vmake	     call to create vector
;      ppm  loc		     if vector too large
;
;      (xr)		     pointer to vcblk
;      (wa,wb,wc,xl)	     destroyed
;
vmake	prc	e,1			; entry point
	lct	wb,wa			; copy elements for loop later on
	add	wa,=vcsi_		; add space for standard fields
	wtb	wa			; convert length to bytes
	bgt	wa,mxlen,vmak2		; fail if too large
	jsr	alloc			; allocate space for vcblk
	mov	(xr),=b_vct		; store type word
	zer	idval(xr)		; initialize idval
	mov	vclen(xr),wa		; set length
	mov	wc,xl			; copy default value
	mov	xl,xr			; copy vcblk pointer
	add	xl,*vcvls		; point to first element value
;
;      loop to set vector elements to default value
;
vmak1	mov	(xl)+,wc		; store one value
	bct	wb,vmak1		; loop till all stored
	exi				; success return
;
;      here if desired vector size too large
;
vmak2	exi	1			; fail return
	enp
	ejc
;
;      scane -- scan an element
;
;      scane is called at compile time (by expan ,cmpil,cncrd)
;      to scan one element from the input image.
;
;      (scncc)		     non-zero if called from cncrd
;      jsr  scane	     call to scan element
;      (xr)		     result pointer (see below)
;      (xl)		     syntax type code (t_xxx)
;
;      the following global locations are used.
;
;      r_cim		     pointer to string block (scblk)
;			     for current input image.
;
;      r_cni		     pointer to next input image string
;			     pointer (zero if none).
;
;      r_scp		     save pointer (exit xr) from last
;			     call in case rescan is set.
;
;      scnbl		     this location is set non-zero on
;			     exit if scane scanned past blanks
;			     before locating the current element
;			     the end of a line counts as blanks.
;
;      scncc		     cncrd sets this non-zero to scan
;			     control card names and clears it
;			     on return
;
;      scnil		     length of current input image
;
;      scngo		     if set non-zero on entry, f and s
;			     are returned as separate syntax
;			     types (not letters) (goto pro-
;			     cessing). scngo is reset on exit.
;
;      scnpt		     offset to current loc in r_cim
;
;      scnrs		     if set non-zero on entry, scane
;			     returns the same result as on the
;			     last call (rescan). scnrs is reset
;			     on exit from any call to scane.
;
;      scntp		     save syntax type from last
;			     call (in case rescan is set).
	ejc
;
;      scane (continued)
;
;
;
;      element scanned	     xl	       xr
;      ---------------	     --	       --
;
;      control card name     0	       pointer to scblk for name
;
;      unary operator	     t_uop     ptr to operator dvblk
;
;      left paren	     t_lpr     t_lpr
;
;      left bracket	     t_lbr     t_lbr
;
;      comma		     t_cma     t_cma
;
;      function call	     t_fnc     ptr to function vrblk
;
;      variable		     t_var     ptr to vrblk
;
;      string constant	     t_con     ptr to scblk
;
;      integer constant	     t_con     ptr to icblk
;
.if    .cnra
.else
;      real constant	     t_con     ptr to rcblk
;
.fi
;      binary operator	     t_bop     ptr to operator dvblk
;
;      right paren	     t_rpr     t_rpr
;
;      right bracket	     t_rbr     t_rbr
;
;      colon		     t_col     t_col
;
;      semi-colon	     t_smc     t_smc
;
;      f (scngo ne 0)	     t_fgo     t_fgo
;
;      s (scngo ne 0)	     t_sgo     t_sgo
	ejc
;
;      scane (continued)
;
;      entry point
;
scane	prc	e,0			; entry point
	zer	scnbl			; reset blanks flag
	mov	scnsa,wa		; save wa
	mov	scnsb,wb		; save wb
	mov	scnsc,wc		; save wc
	bze	scnrs,scn03		; jump if no rescan
;
;      here for rescan request
;
	mov	xl,scntp		; set previous returned scan type
	mov	xr,r_scp		; set previous returned pointer
	zer	scnrs			; reset rescan switch
	brn	scn13			; jump to exit
;
;      come here to read new image to test for continuation
;
scn01	jsr	readr			; read next image
	mov	wb,*dvubs		; set wb for not reading name
	bze	xr,scn30		; treat as semi-colon if none
	plc	xr			; else point to first character
	lch	wc,(xr)			; load first character
	beq	wc,=ch_dt,scn02		; jump if dot for continuation
	bne	wc,=ch_pl,scn30		; else treat as semicolon unless plus
;
;      here for continuation line
;
scn02	jsr	nexts			; acquire next source image
	mov	scnpt,=num01		; set scan pointer past continuation
	mnz	scnbl			; set blanks flag
	ejc
;
;      scane (continued)
;
;      merge here to scan next element on current line
;
scn03	mov	wa,scnpt		; load current offset
	beq	wa,scnil,scn01		; check continuation if end
	mov	xl,r_cim		; point to current line
	plc	xl,wa			; point to current character
	mov	scnse,wa		; set start of element location
	mov	wc,=opdvs		; point to operator dv list
	mov	wb,*dvubs		; set constant for operator circuit
	brn	scn06			; start scanning
;
;      loop here to ignore leading blanks and tabs
;
scn05	bze	wb,scn10		; jump if trailing
	icv	scnse			; increment start of element
	beq	wa,scnil,scn01		; jump if end of image
	mnz	scnbl			; note blanks seen
;
;      the following jump is used repeatedly for scanning out
;      the characters of a numeric constant or variable name.
;      the registers are used as follows.
;
;      (xr)		     scratch
;      (xl)		     ptr to next character
;      (wa)		     current scan offset
;      (wb)		     *dvubs (0 if scanning name,const)
;      (wc)		     =opdvs (0 if scanning constant)
;
scn06	lch	xr,(xl)+		; get next character
	icv	wa			; bump scan offset
	mov	scnpt,wa		; store offset past char scanned
.if    .cucf
	bsw	xr,cfp_u,scn07		; switch on scanned character
.else
	bsw	xr,cfp_a,scn07		; switch on scanned character
.fi
;
;      switch table for switch on character
;
	iff	ch_bl,scn05		; blank
.if    .caht
	iff	ch_ht,scn05		; horizontal tab
.fi
.if    .cavt
	iff	ch_vt,scn05		; vertical tab
.fi
.if    .caex
	iff	ch_ey,scn37		; up arrow
.fi
	iff	ch_d0,scn08		; digit 0
	iff	ch_d1,scn08		; digit 1
	iff	ch_d2,scn08		; digit 2
	iff	ch_d3,scn08		; digit 3
	iff	ch_d4,scn08		; digit 4
	iff	ch_d5,scn08		; digit 5
	iff	ch_d6,scn08		; digit 6
	iff	ch_d7,scn08		; digit 7
	iff	ch_d8,scn08		; digit 8
	iff	ch_d9,scn08		; digit 9
	ejc
;
;      scane (continued)
;
	iff	ch_la,scn09		; letter a
	iff	ch_lb,scn09		; letter b
	iff	ch_lc,scn09		; letter c
	iff	ch_ld,scn09		; letter d
	iff	ch_le,scn09		; letter e
	iff	ch_lg,scn09		; letter g
	iff	ch_lh,scn09		; letter h
	iff	ch_li,scn09		; letter i
	iff	ch_lj,scn09		; letter j
	iff	ch_lk,scn09		; letter k
	iff	ch_ll,scn09		; letter l
	iff	ch_lm,scn09		; letter m
	iff	ch_ln,scn09		; letter n
	iff	ch_lo,scn09		; letter o
	iff	ch_lp,scn09		; letter p
	iff	ch_lq,scn09		; letter q
	iff	ch_lr,scn09		; letter r
	iff	ch_lt,scn09		; letter t
	iff	ch_lu,scn09		; letter u
	iff	ch_lv,scn09		; letter v
	iff	ch_lw,scn09		; letter w
	iff	ch_lx,scn09		; letter x
	iff	ch_ly,scn09		; letter y
	iff	ch_l_,scn09		; letter z
.if    .casl
	iff	ch_ua,scn09		; shifted a
	iff	ch_ub,scn09		; shifted b
	iff	ch_uc,scn09		; shifted c
	iff	ch_ud,scn09		; shifted d
	iff	ch_ue,scn09		; shifted e
	iff	ch_uf,scn20		; shifted f
	iff	ch_ug,scn09		; shifted g
	iff	ch_uh,scn09		; shifted h
	iff	ch_ui,scn09		; shifted i
	iff	ch_uj,scn09		; shifted j
	iff	ch_uk,scn09		; shifted k
	iff	ch_ul,scn09		; shifted l
	iff	ch_um,scn09		; shifted m
	iff	ch_un,scn09		; shifted n
	iff	ch_uo,scn09		; shifted o
	iff	ch_up,scn09		; shifted p
	iff	ch_uq,scn09		; shifted q
	iff	ch_ur,scn09		; shifted r
	iff	ch_us,scn21		; shifted s
	iff	ch_ut,scn09		; shifted t
	iff	ch_uu,scn09		; shifted u
	iff	ch_uv,scn09		; shifted v
	iff	ch_uw,scn09		; shifted w
	iff	ch_ux,scn09		; shifted x
	iff	ch_uy,scn09		; shifted y
	iff	ch_uz,scn09		; shifted z
.fi
	ejc
;
;      scane (continued)
;
	iff	ch_sq,scn16		; single quote
	iff	ch_dq,scn17		; double quote
	iff	ch_lf,scn20		; letter f
	iff	ch_ls,scn21		; letter s
	iff	ch_u_,scn24		; underline
	iff	ch_pp,scn25		; left paren
	iff	ch_rp,scn26		; right paren
	iff	ch_rb,scn27		; right bracket
	iff	ch_bb,scn28		; left bracket
	iff	ch_cb,scn27		; right bracket
	iff	ch_ob,scn28		; left bracket
	iff	ch_cl,scn29		; colon
	iff	ch_sm,scn30		; semi-colon
	iff	ch_cm,scn31		; comma
	iff	ch_dt,scn32		; dot
	iff	ch_pl,scn33		; plus
	iff	ch_mn,scn34		; minus
	iff	ch_nt,scn35		; not
	iff	ch_dl,scn36		; dollar
	iff	ch_ex,scn37		; exclamation mark
	iff	ch_pc,scn38		; percent
	iff	ch_sl,scn40		; slash
	iff	ch_nm,scn41		; number sign
	iff	ch_at,scn42		; at
	iff	ch_br,scn43		; vertical bar
	iff	ch_am,scn44		; ampersand
	iff	ch_qu,scn45		; question mark
	iff	ch_eq,scn46		; equal
	iff	ch_as,scn49		; asterisk
	esw				; end switch on character
;
;      here for illegal character (underline merges)
;
scn07	bze	wb,scn10		; jump if scanning name or constant
	erb	230,syntax error: illegal character
	ejc
;
;      scane (continued)
;
;      here for digits 0-9
;
scn08	bze	wb,scn09		; keep scanning if name/constant
	zer	wc			; else set flag for scanning constant
;
;      here for letter. loop here when scanning name/constant
;
scn09	beq	wa,scnil,scn11		; jump if end of image
	zer	wb			; set flag for scanning name/const
	brn	scn06			; merge back to continue scan
;
;      come here for delimiter ending name or constant
;
scn10	dcv	wa			; reset offset to point to delimiter
;
;      come here after finishing scan of name or constant
;
scn11	mov	scnpt,wa		; store updated scan offset
	mov	wb,scnse		; point to start of element
	sub	wa,wb			; get number of characters
	mov	xl,r_cim		; point to line image
	bnz	wc,scn15		; jump if name
;
;      here after scanning out numeric constant
;
	jsr	sbstr			; get string for constant
	mov	dnamp,xr		; delete from storage (not needed)
	jsr	gtnum			; convert to numeric
	ppm	scn14			; jump if conversion failure
;
;      merge here to exit with constant
;
scn12	mov	xl,=t_con		; set result type of constant
	ejc
;
;      scane (continued)
;
;      common exit point (xr,xl) set
;
scn13	mov	wa,scnsa		; restore wa
	mov	wb,scnsb		; restore wb
	mov	wc,scnsc		; restore wc
	mov	r_scp,xr		; save xr in case rescan
	mov	scntp,xl		; save xl in case rescan
	zer	scngo			; reset possible goto flag
	exi				; return to scane caller
;
;      here if conversion error on numeric item
;
scn14	erb	231,syntax error: invalid numeric item
;
;      here after scanning out variable name
;
scn15	jsr	sbstr			; build string name of variable
	bnz	scncc,scn13		; return if cncrd call
	jsr	gtnvr			; locate/build vrblk
	ppm				; dummy (unused) error return
	mov	xl,=t_var		; set type as variable
	brn	scn13			; back to exit
;
;      here for single quote (start of string constant)
;
scn16	bze	wb,scn10		; terminator if scanning name or cnst
	mov	wb,=ch_sq		; set terminator as single quote
	brn	scn18			; merge
;
;      here for double quote (start of string constant)
;
scn17	bze	wb,scn10		; terminator if scanning name or cnst
	mov	wb,=ch_dq		; set double quote terminator, merge
;
;      loop to scan out string constant
;
scn18	beq	wa,scnil,scn19		; error if end of image
	lch	wc,(xl)+		; else load next character
	icv	wa			; bump offset
	bne	wc,wb,scn18		; loop back if not terminator
	ejc
;
;      scane (continued)
;
;      here after scanning out string constant
;
	mov	wb,scnpt		; point to first character
	mov	scnpt,wa		; save offset past final quote
	dcv	wa			; point back past last character
	sub	wa,wb			; get number of characters
	mov	xl,r_cim		; point to input image
	jsr	sbstr			; build substring value
	brn	scn12			; back to exit with constant result
;
;      here if no matching quote found
;
scn19	mov	scnpt,wa		; set updated scan pointer
	erb	232,syntax error: unmatched string quote
;
;      here for f (possible failure goto)
;
scn20	mov	xr,=t_fgo		; set return code for fail goto
	brn	scn22			; jump to merge
;
;      here for s (possible success goto)
;
scn21	mov	xr,=t_sgo		; set success goto as return code
;
;      special goto cases merge here
;
scn22	bze	scngo,scn09		; treat as normal letter if not goto
;
;      merge here for special character exit
;
scn23	bze	wb,scn10		; jump if end of name/constant
	mov	xl,xr			; else copy code
	brn	scn13			; and jump to exit
;
;      here for underline
;
scn24	bze	wb,scn09		; part of name if scanning name
	brn	scn07			; else illegal
	ejc
;
;      scane (continued)
;
;      here for left paren
;
scn25	mov	xr,=t_lpr		; set left paren return code
	bnz	wb,scn23		; return left paren unless name
	bze	wc,scn10		; delimiter if scanning constant
;
;      here for left paren after name (function call)
;
	mov	wb,scnse		; point to start of name
	mov	scnpt,wa		; set pointer past left paren
	dcv	wa			; point back past last char of name
	sub	wa,wb			; get name length
	mov	xl,r_cim		; point to input image
	jsr	sbstr			; get string name for function
	jsr	gtnvr			; locate/build vrblk
	ppm				; dummy (unused) error return
	mov	xl,=t_fnc		; set code for function call
	brn	scn13			; back to exit
;
;      processing for special characters
;
scn26	mov	xr,=t_rpr		; right paren, set code
	brn	scn23			; take special character exit
;
scn27	mov	xr,=t_rbr		; right bracket, set code
	brn	scn23			; take special character exit
;
scn28	mov	xr,=t_lbr		; left bracket, set code
	brn	scn23			; take special character exit
;
scn29	mov	xr,=t_col		; colon, set code
	brn	scn23			; take special character exit
;
scn30	mov	xr,=t_smc		; semi-colon, set code
	brn	scn23			; take special character exit
;
scn31	mov	xr,=t_cma		; comma, set code
	brn	scn23			; take special character exit
	ejc
;
;      scane (continued)
;
;      here for operators. on entry, wc points to the table of
;      operator dope vectors and wb is the increment to step
;      to the next pair (binary/unary) of dope vectors in the
;      list. on reaching scn46, the pointer has been adjusted to
;      point to the appropriate pair of dope vectors.
;      the first three entries are special since they can occur
;      as part of a variable name (.) or constant (.+-).
;
scn32	bze	wb,scn09		; dot can be part of name or constant
	add	wc,wb			; else bump pointer
;
scn33	bze	wc,scn09		; plus can be part of constant
	bze	wb,scn48		; plus cannot be part of name
	add	wc,wb			; else bump pointer
;
scn34	bze	wc,scn09		; minus can be part of constant
	bze	wb,scn48		; minus cannot be part of name
	add	wc,wb			; else bump pointer
;
scn35	add	wc,wb			; not
scn36	add	wc,wb			; dollar
scn37	add	wc,wb			; exclamation
scn38	add	wc,wb			; percent
scn39	add	wc,wb			; asterisk
scn40	add	wc,wb			; slash
scn41	add	wc,wb			; number sign
scn42	add	wc,wb			; at sign
scn43	add	wc,wb			; vertical bar
scn44	add	wc,wb			; ampersand
scn45	add	wc,wb			; question mark
;
;      all operators come here (equal merges directly)
;      (wc) points to the binary/unary pair of operator dvblks.
;
scn46	bze	wb,scn10		; operator terminates name/constant
	mov	xr,wc			; else copy dv pointer
	lch	wc,(xl)			; load next character
	mov	xl,=t_bop		; set binary op in case
	beq	wa,scnil,scn47		; should be binary if image end
	beq	wc,=ch_bl,scn47		; should be binary if followed by blk
.if    .caht
	beq	wc,=ch_ht,scn47		; jump if horizontal tab
.fi
.if    .cavt
	beq	wc,=ch_vt,scn47		; jump if vertical tab
.fi
	beq	wc,=ch_sm,scn47		; semicolon can immediately follow =
	beq	wc,=ch_cl,scn47		; colon can immediately follow =
	beq	wc,=ch_rp,scn47		; right paren can immediately follow =
	beq	wc,=ch_rb,scn47		; right bracket can immediately follow =
	beq	wc,=ch_cb,scn47		; right bracket can immediately follow =
;
;      here for unary operator
;
	add	xr,*dvbs_		; point to dv for unary op
	mov	xl,=t_uop		; set type for unary operator
	ble	scntp,=t_uok,scn13	; ok unary if ok preceding element
	ejc
;
;      scane (continued)
;
;      merge here to require preceding blanks
;
scn47	bnz	scnbl,scn13		; all ok if preceding blanks, exit
;
;      fail operator in this position
;
scn48	erb	233,syntax error: invalid use of operator
;
;      here for asterisk, could be ** substitute for exclamation
;
scn49	bze	wb,scn10		; end of name if scanning name
	beq	wa,scnil,scn39		; not ** if * at image end
	mov	xr,wa			; else save offset past first *
	mov	scnof,wa		; save another copy
	lch	wa,(xl)+		; load next character
	bne	wa,=ch_as,scn50		; not ** if next char not *
	icv	xr			; else step offset past second *
	beq	xr,scnil,scn51		; ok exclam if end of image
	lch	wa,(xl)			; else load next character
	beq	wa,=ch_bl,scn51		; exclamation if blank
.if    .caht
	beq	wa,=ch_ht,scn51		; exclamation if horizontal tab
.fi
.if    .cavt
	beq	wa,=ch_vt,scn51		; exclamation if vertical tab
.fi
;
;      unary *
;
scn50	mov	wa,scnof		; recover stored offset
	mov	xl,r_cim		; point to line again
	plc	xl,wa			; point to current char
	brn	scn39			; merge with unary *
;
;      here for ** as substitute for exclamation
;
scn51	mov	scnpt,xr		; save scan pointer past 2nd *
	mov	wa,xr			; copy scan pointer
	brn	scn37			; merge with exclamation
	enp				; end procedure scane
	ejc
;
;      scngf -- scan goto field
;
;      scngf is called from cmpil to scan and analyze a goto
;      field including the surrounding brackets or parentheses.
;      for a normal goto, the result returned is either a vrblk
;      pointer for a simple label operand, or a pointer to an
;      expression tree with a special outer unary operator
;      (o_goc). for a direct goto, the result returned is a
;      pointer to an expression tree with the special outer
;      unary operator o_god.
;
;      jsr  scngf	     call to scan goto field
;      (xr)		     result (see above)
;      (xl,wa,wb,wc)	     destroyed
;
scngf	prc	e,0			; entry point
	jsr	scane			; scan initial element
	beq	xl,=t_lpr,scng1		; skip if left paren (normal goto)
	beq	xl,=t_lbr,scng2		; skip if left bracket (direct goto)
	erb	234,syntax error: goto field incorrect
;
;      here for left paren (normal goto)
;
scng1	mov	wb,=num01		; set expan flag for normal goto
	jsr	expan			; analyze goto field
	mov	wa,=opdvn		; point to opdv for complex goto
	ble	xr,statb,scng3		; jump if not in static (sgd15)
	blo	xr,state,scng4		; jump to exit if simple label name
	brn	scng3			; complex goto - merge
;
;      here for left bracket (direct goto)
;
scng2	mov	wb,=num02		; set expan flag for direct goto
	jsr	expan			; scan goto field
	mov	wa,=opdvd		; set opdv pointer for direct goto
	ejc
;
;      scngf (continued)
;
;      merge here to build outer unary operator block
;
scng3	mov	-(xs),wa		; stack operator dv pointer
	mov	-(xs),xr		; stack pointer to expression tree
	jsr	expop			; pop operator off
	mov	xr,(xs)+		; reload new expression tree pointer
;
;      common exit point
;
scng4	exi				; return to caller
	enp				; end procedure scngf
	ejc
;
;      setvr -- set vrget,vrsto fields of vrblk
;
;      setvr sets the proper values in the vrget and vrsto
;      fields of a vrblk. it is called whenever trblks are
;      added or subtracted (trace,stoptr,input,output,detach)
;
;      (xr)		     pointer to vrblk
;      jsr  setvr	     call to set fields
;      (xl,wa)		     destroyed
;
;      note that setvr ignores the call if xr does not point
;      into the static region (i.e. is some other name base)
;
setvr	prc	e,0			; entry point
	bhi	xr,state,setv1		; exit if not natural variable
;
;      here if we have a vrblk
;
	mov	xl,xr			; copy vrblk pointer
	mov	vrget(xr),=b_vrl	; store normal get value
	beq	vrsto(xr),=b_vre,setv1	; skip if protected variable
	mov	vrsto(xr),=b_vrs	; store normal store value
	mov	xl,vrval(xl)		; point to next entry on chain
	bne	(xl),=b_trt,setv1	; jump if end of trblk chain
	mov	vrget(xr),=b_vra	; store trapped routine address
	mov	vrsto(xr),=b_vrv	; set trapped routine address
;
;      merge here to exit to caller
;
setv1	exi				; return to setvr caller
	enp				; end procedure setvr
.if    .cnsr
.else
	ejc
;
;      sorta -- sort array
;
;      routine to sort an array or table on same basis as in
;      sitbol. a table is converted to an array, leaving two
;      dimensional arrays and vectors as cases to be considered.
;      whole rows of arrays are permuted according to the
;      ordering of the keys they contain, and the stride
;      referred to, is the the length of a row. it is one
;      for a vector.
;      the sort used is heapsort, fundamentals of data structure
;      horowitz and sahni, pitman 1977, page 347.
;      it is an order n*log(n) algorithm. in order
;      to make it stable, comparands may not compare equal. this
;      is achieved by sorting a copy array (referred to as the
;      sort array) containing at its high address end, byte
;      offsets to the rows to be sorted held in the original
;      array (referred to as the key array). sortc, the
;      comparison routine, accesses the keys through these
;      offsets and in the case of equality, resolves it by
;      comparing the offsets themselves. the sort permutes the
;      offsets which are then used in a final operation to copy
;      the actual items into the new array in sorted order.
;      references to zeroth item are to notional item
;      preceding first actual item.
;      reverse sorting for rsort is done by having the less than
;      test for keys effectively be replaced by a
;      greater than test.
;
;      1(xs)		     first arg - array or table
;      0(xs)		     2nd arg - index or pdtype name
;      (wa)		     0 , non-zero for sort , rsort
;      jsr  sorta	     call to sort array
;      ppm  loc		     transfer loc if table is empty
;      (xr)		     sorted array
;      (xl,wa,wb,wc)	     destroyed
	ejc
;
;      sorta (continued)
;
sorta	prc	n,1			; entry point
	mov	srtsr,wa		; sort/rsort indicator
	mov	srtst,*num01		; default stride of 1
	zer	srtof			; default zero offset to sort key
	mov	srtdf,=nulls		; clear datatype field name
	mov	r_sxr,(xs)+		; unstack argument 2
	mov	xr,(xs)+		; get first argument
	mnz	wa			; use key/values of table entries
	jsr	gtarr			; convert to array
	ppm	srt18			; signal that table is empty
	ppm	srt16			; error if non-convertable
	mov	-(xs),xr		; stack ptr to resulting key array
	mov	-(xs),xr		; another copy for copyb
	jsr	copyb			; get copy array for sorting into
	ppm				; cant fail
	mov	-(xs),xr		; stack pointer to sort array
	mov	xr,r_sxr		; get second arg
	mov	xl,num01(xs)		; get ptr to key array
	bne	(xl),=b_vct,srt02	; jump if arblk
	beq	xr,=nulls,srt01		; jump if null second arg
	jsr	gtnvr			; get vrblk ptr for it
	err	257,erroneous 2nd arg in sort/rsort of vector
	mov	srtdf,xr		; store datatype field name vrblk
;
;      compute n and offset to item a(0) in vector case
;
srt01	mov	wc,*vclen		; offset to a(0)
	mov	wb,*vcvls		; offset to first item
	mov	wa,vclen(xl)		; get block length
	sub	wa,*vcsi_		; get no. of entries, n (in bytes)
	brn	srt04			; merge
;
;      here for array
;
srt02	ldi	ardim(xl)		; get possible dimension
	mfi	wa			; convert to short integer
	wtb	wa			; further convert to baus
	mov	wb,*arvls		; offset to first value if one
	mov	wc,*arpro		; offset before values if one dim.
	beq	arndm(xl),=num01,srt04	; jump in fact if one dim.
	bne	arndm(xl),=num02,srt16	; fail unless two dimens
	ldi	arlb2(xl)		; get lower bound 2 as default
	beq	xr,=nulls,srt03		; jump if default second arg
	jsr	gtint			; convert to integer
	ppm	srt17			; fail
	ldi	icval(xr)		; get actual integer value
	ejc
;
;      sorta (continued)
;
;      here with sort column index in ia in array case
;
srt03	sbi	arlb2(xl)		; subtract low bound
	iov	srt17			; fail if overflow
	ilt	srt17			; fail if below low bound
	sbi	ardm2(xl)		; check against dimension
	ige	srt17			; fail if too large
	adi	ardm2(xl)		; restore value
	mfi	wa			; get as small integer
	wtb	wa			; offset within row to key
	mov	srtof,wa		; keep offset
	ldi	ardm2(xl)		; second dimension is row length
	mfi	wa			; convert to short integer
	mov	xr,wa			; copy row length
	wtb	wa			; convert to bytes
	mov	srtst,wa		; store as stride
	ldi	ardim(xl)		; get number of rows
	mfi	wa			; as a short integer
	wtb	wa			; convert n to baus
	mov	wc,arlen(xl)		; offset past array end
	sub	wc,wa			; adjust, giving space for n offsets
	dca	wc			; point to a(0)
	mov	wb,arofs(xl)		; offset to word before first item
	ica	wb			; offset to first item
;
;      separate pre-processing for arrays and vectors done.
;      to simplify later key comparisons, removal of any trblk
;      trap blocks from entries in key array is effected.
;
;      (xl) = 1(xs) = pointer to key array
;      (xs) = pointer to sort array
;      wa = number of items, n (converted to bytes).
;      wb = offset to first item of arrays.
;      wc = offset to a(0)
;
srt04	ble	wa,*num01,srt15		; return if only a single item
	mov	srtsn,wa		; store number of items (in baus)
	mov	srtso,wc		; store offset to a(0)
	mov	wc,arlen(xl)		; length of array or vec (=vclen)
	add	wc,xl			; point past end of array or vector
	mov	srtsf,wb		; store offset to first row
	add	xl,wb			; point to first item in key array
;
;      loop through array
;
srt05	mov	xr,(xl)			; get an entry
;
;      hunt along trblk chain
;
srt06	bne	(xr),=b_trt,srt07	; jump out if not trblk
	mov	xr,trval(xr)		; get value field
	brn	srt06			; loop
	ejc
;
;      sorta (continued)
;
;      xr is value from end of chain
;
srt07	mov	(xl)+,xr		; store as array entry
	blt	xl,wc,srt05		; loop if not done
	mov	xl,(xs)			; get adrs of sort array
	mov	xr,srtsf		; initial offset to first key
	mov	wb,srtst		; get stride
	add	xl,srtso		; offset to a(0)
	ica	xl			; point to a(1)
	mov	wc,srtsn		; get n
	btw	wc			; convert from bytes
	mov	srtnr,wc		; store as row count
	lct	wc,wc			; loop counter
;
;      store key offsets at top of sort array
;
srt08	mov	(xl)+,xr		; store an offset
	add	xr,wb			; bump offset by stride
	bct	wc,srt08		; loop through rows
;
;      perform the sort on offsets in sort array.
;
;      (srtsn)		     number of items to sort, n (bytes)
;      (srtso)		     offset to a(0)
;
srt09	mov	wa,srtsn		; get n
	mov	wc,srtnr		; get number of rows
	rsh	wc,1			; i = n / 2 (wc=i, index into array)
	wtb	wc			; convert back to bytes
;
;      loop to form initial heap
;
srt10	jsr	sorth			; sorth(i,n)
	dca	wc			; i = i - 1
	bnz	wc,srt10		; loop if i gt 0
	mov	wc,wa			; i = n
;
;      sorting loop. at this point, a(1) is the largest
;      item, since algorithm initialises it as, and then maintains
;      it as, root of tree.
;
srt11	dca	wc			; i = i - 1 (n - 1 initially)
	bze	wc,srt12		; jump if done
	mov	xr,(xs)			; get sort array address
	add	xr,srtso		; point to a(0)
	mov	xl,xr			; a(0) address
	add	xl,wc			; a(i) address
	mov	wb,num01(xl)		; copy a(i+1)
	mov	num01(xl),num01(xr)	; move a(1) to a(i+1)
	mov	num01(xr),wb		; complete exchange of a(1), a(i+1)
	mov	wa,wc			; n = i for sorth
	mov	wc,*num01		; i = 1 for sorth
	jsr	sorth			; sorth(1,n)
	mov	wc,wa			; restore wc
	brn	srt11			; loop
	ejc
;
;      sorta (continued)
;
;      offsets have been permuted into required order by sort.
;      copy array elements over them.
;
srt12	mov	xr,(xs)			; base adrs of key array
	mov	wc,xr			; copy it
	add	wc,srtso		; offset of a(0)
	add	xr,srtsf		; adrs of first row of sort array
	mov	wb,srtst		; get stride
;
;      copying loop for successive items. sorted offsets are
;      held at end of sort array.
;
srt13	ica	wc			; adrs of next of sorted offsets
	mov	xl,wc			; copy it for access
	mov	xl,(xl)			; get offset
	add	xl,num01(xs)		; add key array base adrs
	mov	wa,wb			; get count of characters in row
	mvw				; copy a complete row
	dcv	srtnr			; decrement row count
	bnz	srtnr,srt13		; repeat till all rows done
;
;      return point
;
srt15	mov	xr,(xs)+		; pop result array ptr
	ica	xs			; pop key array ptr
	zer	r_sxl			; clear junk
	zer	r_sxr			; clear junk
	exi				; return
;
;      error point
;
srt16	erb	256,sort/rsort 1st arg not suitable array or table
srt17	erb	258,sort/rsort 2nd arg out of range or non-integer
;
;      return point if input table is empty
;
srt18	exi	1			; return indication of null table
	enp				; end procudure sorta
	ejc
;
;      sortc --	 compare sort keys
;
;      compare two sort keys given their offsets. if
;      equal, compare key offsets to give stable sort.
;      note that if srtsr is non-zero (request for reverse
;      sort), the quoted returns are inverted.
;      for objects of differing datatypes, the entry point
;      identifications are compared.
;
;      (xl)		     base adrs for keys
;      (wa)		     offset to key 1 item
;      (wb)		     offset to key 2 item
;      (srtsr)		     zero/non-zero for sort/rsort
;      (srtof)		     offset within row to comparands
;      jsr  sortc	     call to compare keys
;      ppm  loc		     key1 less than key2
;			     normal return, key1 gt than key2
;      (xl,xr,wa,wb)	     destroyed
;
sortc	prc	e,1			; entry point
	mov	srts1,wa		; save offset 1
	mov	srts2,wb		; save offset 2
	mov	srtsc,wc		; save wc
	add	xl,srtof		; add offset to comparand field
	mov	xr,xl			; copy base + offset
	add	xl,wa			; add key1 offset
	add	xr,wb			; add key2 offset
	mov	xl,(xl)			; get key1
	mov	xr,(xr)			; get key2
	bne	srtdf,=nulls,src12	; jump if datatype field name used
	ejc
;
;      sortc (continued)
;
;      merge after dealing with field name. try for strings.
;
src01	mov	wc,(xl)			; get type code
	bne	wc,(xr),src02		; skip if not same datatype
	beq	wc,=b_scl,src09		; jump if both strings
	beq	wc,=b_icl,src14		; jump if both integers
.if    .cnbf
.else
	beq	wc,=b_bct,src09		; jump if both buffers
.fi
;
;      datatypes different.  now try for numeric
;
src02	mov	r_sxl,xl		; keep arg1
	mov	r_sxr,xr		; keep arg2
.if    .cnbf
.if    .cnsc
	beq	wc,=b_scl,src11		; do not allow conversion to number
	beq	(xr),=b_scl,src11	; if either arg is a string
.fi
.else
;
;      first examine for string/buffer comparison.  if so,
;      allow lcomp to compare chars in string and buffer
;      without converting buffer to a string.
;
	beq	wc,=b_scl,src13		; jump if key1 is a string
.if    .cnsc
	bne	wc,=b_bct,src15		; j if key1 is not a string or buffer
.else
	bne	wc,=b_bct,src14		; try converting key 2 to a number
.fi
;
;      here if key1 is a buffer, key2 known not to be a buffer.
;      if key2 is a string, then lcomp can proceed.
;
	beq	(xr),=b_scl,src09	; j if keys 1/2 are buffer/string
.if    .cnsc
	brn	src11			; prevent convert of key 1 to number
.else
	brn	src14			; try converting key 1 to number
.fi
;
;      here if key1 is a string, key2 known not to be a string.
;      if key2 is a buffer, then lcomp can proceed.
;
src13	beq	(xr),=b_bct,src09	; j if keys 1/2 are string/buffer
.if    .cnsc
	brn	src11			; prevent convert of key 1 to number
;
;      here if key1 is not a string or buffer.
;      examine key2.  if it is a string or buffer, then do not
;      convert key2 to a number.
;
src15	beq	(xr),=b_scl,src11	; j if key 2 is a string
	beq	(xr),=b_bct,src11	; j if key 2 is a buffer
;
;      here with keys 1/2 not strings or buffers
;
.fi
.fi
src14	mov	-(xs),xl		; stack
	mov	-(xs),xr		; args
	jsr	acomp			; compare objects
	ppm	src10			; not numeric
	ppm	src10			; not numeric
	ppm	src03			; key1 less
	ppm	src08			; keys equal
	ppm	src05			; key1 greater
;
;      return if key1 smaller (sort), greater (rsort)
;
src03	bnz	srtsr,src06		; jump if rsort
;
src04	mov	wc,srtsc		; restore wc
	exi	1			; return
;
;      return if key1 greater (sort), smaller (rsort)
;
src05	bnz	srtsr,src04		; jump if rsort
;
src06	mov	wc,srtsc		; restore wc
	exi				; return
;
;      keys are of same datatype
;
src07	blt	xl,xr,src03		; item first created is less
	bgt	xl,xr,src05		; addresses rise in order of creation
;
;      drop through or merge for identical or equal objects
;
src08	blt	srts1,srts2,src04	; test offsets or key addrss instead
	brn	src06			; offset 1 greater
	ejc
;
;      sortc (continued)
;
.if    .cnbf
;      strings
.else
;      strings or buffers or some combination of same
.fi
;
src09	mov	-(xs),xl		; stack
	mov	-(xs),xr		; args
	jsr	lcomp			; compare objects
	ppm				; cant
	ppm				; fail
	ppm	src03			; key1 less
	ppm	src08			; keys equal
	ppm	src05			; key1 greater
;
;      arithmetic comparison failed - recover args
;
src10	mov	xl,r_sxl		; get arg1
	mov	xr,r_sxr		; get arg2
	mov	wc,(xl)			; get type of key1
	beq	wc,(xr),src07		; jump if keys of same type
;
;      here to compare datatype ids
;
src11	mov	xl,wc			; get block type word
	mov	xr,(xr)			; get block type word
	lei	xl			; entry point id for key1
	lei	xr			; entry point id for key2
	bgt	xl,xr,src05		; jump if key1 gt key2
	brn	src03			; key1 lt key2
;
;      datatype field name used
;
src12	jsr	sortf			; call routine to find field 1
	mov	-(xs),xl		; stack item pointer
	mov	xl,xr			; get key2
	jsr	sortf			; find field 2
	mov	xr,xl			; place as key2
	mov	xl,(xs)+		; recover key1
	brn	src01			; merge
	enp				; procedure sortc
	ejc
;
;      sortf -- find field for sortc
;
;      routine used by sortc to obtain item corresponding
;      to a given field name, if this exists, in a programmer
;      defined object passed as argument.
;      if such a match occurs, record is kept of datatype
;      name, field name and offset to field in order to
;      short-circuit later searches on same type. note that
;      dfblks are stored in static and hence cannot be moved.
;
;      (srtdf)		     vrblk pointer of field name
;      (xl)		     possible pdblk pointer
;      jsr  sortf	     call to search for field name
;      (xl)		     item found or original pdblk ptr
;      (wc)		     destroyed
;
sortf	prc	e,0			; entry point
	bne	(xl),=b_pdt,srtf3	; return if not pdblk
	mov	-(xs),xr		; keep xr
	mov	xr,srtfd		; get possible former dfblk ptr
	bze	xr,srtf4		; jump if not
	bne	xr,pddfp(xl),srtf4	; jump if not right datatype
	bne	srtdf,srtff,srtf4	; jump if not right field name
	add	xl,srtfo		; add offset to required field
;
;      here with xl pointing to found field
;
srtf1	mov	xl,(xl)			; get item from field
;
;      return point
;
srtf2	mov	xr,(xs)+		; restore xr
;
srtf3	exi				; return
	ejc
;
;      sortf (continued)
;
;      conduct a search
;
srtf4	mov	xr,xl			; copy original pointer
	mov	xr,pddfp(xr)		; point to dfblk
	mov	srtfd,xr		; keep a copy
	mov	wc,fargs(xr)		; get number of fields
	wtb	wc			; convert to bytes
	add	xr,dflen(xr)		; point past last field
;
;      loop to find name in pdfblk
;
srtf5	dca	wc			; count down
	dca	xr			; point in front
	beq	(xr),srtdf,srtf6	; skip out if found
	bnz	wc,srtf5		; loop
	brn	srtf2			; return - not found
;
;      found
;
srtf6	mov	srtff,(xr)		; keep field name ptr
	add	wc,*pdfld		; add offset to first field
	mov	srtfo,wc		; store as field offset
	add	xl,wc			; point to field
	brn	srtf1			; return
	enp				; procedure sortf
	ejc
;
;      sorth -- heap routine for sorta
;
;      this routine constructs a heap from elements of array, a.
;      in this application, the elements are offsets to keys in
;      a key array.
;
;      (xs)		     pointer to sort array base
;      1(xs)		     pointer to key array base
;      (wa)		     max array index, n (in bytes)
;      (wc)		     offset j in a to root (in *1 to *n)
;      jsr  sorth	     call sorth(j,n) to make heap
;      (xl,xr,wb)	     destroyed
;
sorth	prc	n,0			; entry point
	mov	srtsn,wa		; save n
	mov	srtwc,wc		; keep wc
	mov	xl,(xs)			; sort array base adrs
	add	xl,srtso		; add offset to a(0)
	add	xl,wc			; point to a(j)
	mov	srtrt,(xl)		; get offset to root
	add	wc,wc			; double j - cant exceed n
;
;      loop to move down tree using doubled index j
;
srh01	bgt	wc,srtsn,srh03		; done if j gt n
	beq	wc,srtsn,srh02		; skip if j equals n
	mov	xr,(xs)			; sort array base adrs
	mov	xl,num01(xs)		; key array base adrs
	add	xr,srtso		; point to a(0)
	add	xr,wc			; adrs of a(j)
	mov	wa,num01(xr)		; get a(j+1)
	mov	wb,(xr)			; get a(j)
;
;      compare sons. (wa) right son, (wb) left son
;
	jsr	sortc			; compare keys - lt(a(j+1),a(j))
	ppm	srh02			; a(j+1) lt a(j)
	ica	wc			; point to greater son, a(j+1)
	ejc
;
;      sorth (continued)
;
;      compare root with greater son
;
srh02	mov	xl,num01(xs)		; key array base adrs
	mov	xr,(xs)			; get sort array address
	add	xr,srtso		; adrs of a(0)
	mov	wb,xr			; copy this adrs
	add	xr,wc			; adrs of greater son, a(j)
	mov	wa,(xr)			; get a(j)
	mov	xr,wb			; point back to a(0)
	mov	wb,srtrt		; get root
	jsr	sortc			; compare them - lt(a(j),root)
	ppm	srh03			; father exceeds sons - done
	mov	xr,(xs)			; get sort array adrs
	add	xr,srtso		; point to a(0)
	mov	xl,xr			; copy it
	mov	wa,wc			; copy j
	btw	wc			; convert to words
	rsh	wc,1			; get j/2
	wtb	wc			; convert back to bytes
	add	xl,wa			; point to a(j)
	add	xr,wc			; adrs of a(j/2)
	mov	(xr),(xl)		; a(j/2) = a(j)
	mov	wc,wa			; recover j
	aov	wc,wc,srh03		; j = j*2. done if too big
	brn	srh01			; loop
;
;      finish by copying root offset back into array
;
srh03	btw	wc			; convert to words
	rsh	wc,1			; j = j/2
	wtb	wc			; convert back to bytes
	mov	xr,(xs)			; sort array adrs
	add	xr,srtso		; adrs of a(0)
	add	xr,wc			; adrs of a(j/2)
	mov	(xr),srtrt		; a(j/2) = root
	mov	wa,srtsn		; restore wa
	mov	wc,srtwc		; restore wc
	exi				; return
	enp				; end procedure sorth
.fi
	ejc
;
;      trace -- set/reset a trace association
;
;      this procedure is shared by trace and stoptr to
;      either initiate or stop a trace respectively.
;
;      (xl)		     trblk ptr (trace) or zero (stoptr)
;      1(xs)		     first argument (name)
;      0(xs)		     second argument (trace type)
;      jsr  trace	     call to set/reset trace
;      ppm  loc		     transfer loc if 1st arg is bad name
;      ppm  loc		     transfer loc if 2nd arg is bad type
;      (xs)		     popped
;      (xl,xr,wa,wb,wc,ia)   destroyed
;
trace	prc	n,2			; entry point
	jsr	gtstg			; get trace type string
	ppm	trc15			; jump if not string
	plc	xr			; else point to string
	lch	wa,(xr)			; load first character
.if    .culc
	flc	wa			; fold to lower case
.fi
	mov	xr,(xs)			; load name argument
	mov	(xs),xl			; stack trblk ptr or zero
	mov	wc,=trtac		; set trtyp for access trace
	beq	wa,=ch_la,trc10		; jump if a (access)
	mov	wc,=trtvl		; set trtyp for value trace
	beq	wa,=ch_lv,trc10		; jump if v (value)
	beq	wa,=ch_bl,trc10		; jump if blank (value)
;
;      here for l,k,f,c,r
;
	beq	wa,=ch_lf,trc01		; jump if f (function)
	beq	wa,=ch_lr,trc01		; jump if r (return)
	beq	wa,=ch_ll,trc03		; jump if l (label)
	beq	wa,=ch_lk,trc06		; jump if k (keyword)
	bne	wa,=ch_lc,trc15		; else error if not c (call)
;
;      here for f,c,r
;
trc01	jsr	gtnvr			; point to vrblk for name
	ppm	trc16			; jump if bad name
	ica	xs			; pop stack
	mov	xr,vrfnc(xr)		; point to function block
	bne	(xr),=b_pfc,trc17	; error if not program function
	beq	wa,=ch_lr,trc02		; jump if r (return)
	ejc
;
;      trace (continued)
;
;      here for f,c to set/reset call trace
;
	mov	pfctr(xr),xl		; set/reset call trace
	beq	wa,=ch_lc,exnul		; exit with null if c (call)
;
;      here for f,r to set/reset return trace
;
trc02	mov	pfrtr(xr),xl		; set/reset return trace
	exi				; return
;
;      here for l to set/reset label trace
;
trc03	jsr	gtnvr			; point to vrblk
	ppm	trc16			; jump if bad name
	mov	xl,vrlbl(xr)		; load label pointer
	bne	(xl),=b_trt,trc04	; jump if no old trace
	mov	xl,trlbl(xl)		; else delete old trace association
;
;      here with old label trace association deleted
;
trc04	beq	xl,=stndl,trc16		; error if undefined label
	mov	wb,(xs)+		; get trblk ptr again
	bze	wb,trc05		; jump if stoptr case
	mov	vrlbl(xr),wb		; else set new trblk pointer
	mov	vrtra(xr),=b_vrt	; set label trace routine address
	mov	xr,wb			; copy trblk pointer
	mov	trlbl(xr),xl		; store real label in trblk
	exi				; return
;
;      here for stoptr case for label
;
trc05	mov	vrlbl(xr),xl		; store label ptr back in vrblk
	mov	vrtra(xr),=b_vrg	; store normal transfer address
	exi				; return
	ejc
;
;      trace (continued)
;
;      here for k (keyword)
;
trc06	jsr	gtnvr			; point to vrblk
	ppm	trc16			; error if not natural var
	bnz	vrlen(xr),trc16		; error if not system var
	ica	xs			; pop stack
	bze	xl,trc07		; jump if stoptr case
	mov	trkvr(xl),xr		; store vrblk ptr in trblk for ktrex
;
;      merge here with trblk set up in wb (or zero)
;
trc07	mov	xr,vrsvp(xr)		; point to svblk
	beq	xr,=v_ert,trc08		; jump if errtype
	beq	xr,=v_stc,trc09		; jump if stcount
	bne	xr,=v_fnc,trc17		; else error if not fnclevel
;
;      fnclevel
;
	mov	r_fnc,xl		; set/reset fnclevel trace
	exi				; return
;
;      errtype
;
trc08	mov	r_ert,xl		; set/reset errtype trace
	exi				; return
;
;      stcount
;
trc09	mov	r_stc,xl		; set/reset stcount trace
	jsr	stgcc			; update countdown counters
	exi				; return
	ejc
;
;      trace (continued)
;
;      a,v merge here with trtyp value in wc
;
trc10	jsr	gtvar			; locate variable
	ppm	trc16			; error if not appropriate name
	mov	wb,(xs)+		; get new trblk ptr again
	add	wa,xl			; point to variable location
	mov	xr,wa			; copy variable pointer
;
;      loop to search trblk chain
;
trc11	mov	xl,(xr)			; point to next entry
	bne	(xl),=b_trt,trc13	; jump if not trblk
	blt	wc,trtyp(xl),trc13	; jump if too far out on chain
	beq	wc,trtyp(xl),trc12	; jump if this matches our type
	add	xl,*trnxt		; else point to link field
	mov	xr,xl			; copy pointer
	brn	trc11			; and loop back
;
;      here to delete an old trblk of the type we were given
;
trc12	mov	xl,trnxt(xl)		; get ptr to next block or value
	mov	(xr),xl			; store to delete this trblk
;
;      here after deleting any old association of this type
;
trc13	bze	wb,trc14		; jump if stoptr case
	mov	(xr),wb			; else link new trblk in
	mov	xr,wb			; copy trblk pointer
	mov	trnxt(xr),xl		; store forward pointer
	mov	trtyp(xr),wc		; store appropriate trap type code
;
;      here to make sure vrget,vrsto are set properly
;
trc14	mov	xr,wa			; recall possible vrblk pointer
	sub	xr,*vrval		; point back to vrblk
	jsr	setvr			; set fields if vrblk
	exi				; return
;
;      here for bad trace type
;
trc15	exi	2			; take bad trace type error exit
;
;      pop stack before failing
;
trc16	ica	xs			; pop stack
;
;      here for bad name argument
;
trc17	exi	1			; take bad name error exit
	enp				; end procedure trace
	ejc
;
;      trbld -- build trblk
;
;      trblk is used by the input, output and trace functions
;      to construct a trblk (trap block)
;
;      (xr)		     trtag or trter
;      (xl)		     trfnc or trfpt
;      (wb)		     trtyp
;      jsr  trbld	     call to build trblk
;      (xr)		     pointer to trblk
;      (wa)		     destroyed
;
trbld	prc	e,0			; entry point
	mov	-(xs),xr		; stack trtag (or trfnm)
	mov	wa,*trsi_		; set size of trblk
	jsr	alloc			; allocate trblk
	mov	(xr),=b_trt		; store first word
	mov	trfnc(xr),xl		; store trfnc (or trfpt)
	mov	trtag(xr),(xs)+		; store trtag (or trfnm)
	mov	trtyp(xr),wb		; store type
	mov	trval(xr),=nulls	; for now, a null value
	exi				; return to caller
	enp				; end procedure trbld
	ejc
;
;      trimr -- trim trailing blanks
;
;      trimr is passed a pointer to an scblk which must be the
;      last block in dynamic storage. trailing blanks are
;      trimmed off and the dynamic storage pointer reset to
;      the end of the (possibly) shortened block.
;
;      (wb)		     non-zero to trim trailing blanks
;      (xr)		     pointer to string to trim
;      jsr  trimr	     call to trim string
;      (xr)		     pointer to trimmed string
;      (xl,wa,wb,wc)	     destroyed
;
;      the call with wb zero still performs the end zero pad
;      and dnamp readjustment. it is used from acess if kvtrm=0.
;
trimr	prc	e,0			; entry point
	mov	xl,xr			; copy string pointer
	mov	wa,sclen(xr)		; load string length
	bze	wa,trim2		; jump if null input
	plc	xl,wa			; else point past last character
	bze	wb,trim3		; jump if no trim
	mov	wc,=ch_bl		; load blank character
;
;      loop through characters from right to left
;
trim0	lch	wb,-(xl)		; load next character
.if    .caht
	beq	wb,=ch_ht,trim1		; jump if horizontal tab
.fi
	bne	wb,wc,trim3		; jump if non-blank found
trim1	dcv	wa			; else decrement character count
	bnz	wa,trim0		; loop back if more to check
;
;      here if result is null (null or all-blank input)
;
trim2	mov	dnamp,xr		; wipe out input string block
	mov	xr,=nulls		; load null result
	brn	trim5			; merge to exit
	ejc
;
;      trimr (continued)
;
;      here with non-blank found (merge for no trim)
;
trim3	mov	sclen(xr),wa		; set new length
	mov	xl,xr			; copy string pointer
	psc	xl,wa			; ready for storing blanks
	ctb	wa,schar		; get length of block in bytes
	add	wa,xr			; point past new block
	mov	dnamp,wa		; set new top of storage pointer
	lct	wa,=cfp_c		; get count of chars in word
	zer	wc			; set zero char
;
;      loop to zero pad last word of characters
;
trim4	sch	wc,(xl)+		; store zero character
	bct	wa,trim4		; loop back till all stored
	csc	xl			; complete store characters
;
;      common exit point
;
trim5	zer	xl			; clear garbage xl pointer
	exi				; return to caller
	enp				; end procedure trimr
	ejc
;
;      trxeq -- execute function type trace
;
;      trxeq is used to execute a trace when a fourth argument
;      has been supplied. trace has already been decremented.
;
;      (xr)		     pointer to trblk
;      (xl,wa)		     name base,offset for variable
;      jsr  trxeq	     call to execute trace
;      (wb,wc,ra)	     destroyed
;
;      the following stack entries are made before passing
;      control to the trace function using the cfunc routine.
;
;			     trxeq return point word(s)
;			     saved value of trace keyword
;			     trblk pointer
;			     name base
;			     name offset
;			     saved value of r_cod
;			     saved code ptr (-r_cod)
;			     saved value of flptr
;      flptr --------------- zero (dummy fail offset)
;			     nmblk for variable name
;      xs ------------------ trace tag
;
;      r_cod and the code ptr are set to dummy values which
;      cause control to return to the trxeq procedure on success
;      or failure (trxeq ignores a failure condition).
;
trxeq	prc	r,0			; entry point (recursive)
	mov	wc,r_cod		; load code block pointer
	scp	wb			; get current code pointer
	sub	wb,wc			; make code pointer into offset
	mov	-(xs),kvtra		; stack trace keyword value
	mov	-(xs),xr		; stack trblk pointer
	mov	-(xs),xl		; stack name base
	mov	-(xs),wa		; stack name offset
	mov	-(xs),wc		; stack code block pointer
	mov	-(xs),wb		; stack code pointer offset
	mov	-(xs),flptr		; stack old failure pointer
	zer	-(xs)			; set dummy fail offset
	mov	flptr,xs		; set new failure pointer
	zer	kvtra			; reset trace keyword to zero
	mov	wc,=trxdc		; load new (dummy) code blk pointer
	mov	r_cod,wc		; set as code block pointer
	lcp	wc			; and new code pointer
	ejc
;
;      trxeq (continued)
;
;      now prepare arguments for function
;
	mov	wb,wa			; save name offset
	mov	wa,*nmsi_		; load nmblk size
	jsr	alloc			; allocate space for nmblk
	mov	(xr),=b_nml		; set type word
	mov	nmbas(xr),xl		; store name base
	mov	nmofs(xr),wb		; store name offset
	mov	xl,6(xs)		; reload pointer to trblk
	mov	-(xs),xr		; stack nmblk pointer (1st argument)
	mov	-(xs),trtag(xl)		; stack trace tag (2nd argument)
	mov	xl,trfnc(xl)		; load trace vrblk pointer
	mov	xl,vrfnc(xl)		; load trace function pointer
	beq	xl,=stndf,trxq2		; jump if not a defined function
	mov	wa,=num02		; set number of arguments to two
	brn	cfunc			; jump to call function
;
;      see o_txr for details of return to this point
;
trxq1	mov	xs,flptr		; point back to our stack entries
	ica	xs			; pop off garbage fail offset
	mov	flptr,(xs)+		; restore old failure pointer
	mov	wb,(xs)+		; reload code offset
	mov	wc,(xs)+		; load old code base pointer
	mov	xr,wc			; copy cdblk pointer
	mov	kvstn,cdstm(xr)		; restore stmnt no
	mov	wa,(xs)+		; reload name offset
	mov	xl,(xs)+		; reload name base
	mov	xr,(xs)+		; reload trblk pointer
	mov	kvtra,(xs)+		; restore trace keyword value
	add	wb,wc			; recompute absolute code pointer
	lcp	wb			; restore code pointer
	mov	r_cod,wc		; and code block pointer
	exi				; return to trxeq caller
;
;      here if the target function is not defined
;
trxq2	erb	197,trace fourth arg is not function name or null
;
	enp				; end procedure trxeq
	ejc
;
;      xscan -- execution function argument scan
;
;      xscan scans out one token in a prototype argument in
;      array,clear,data,define,load function calls. xscan
;      calls must be preceded by a call to the initialization
;      procedure xscni. the following variables are used.
;
;      r_xsc		     pointer to scblk for function arg
;      xsofs		     offset (num chars scanned so far)
;
;      (wa)		     non-zero to skip and trim blanks
;      (wc)		     delimiter one (ch_xx)
;      (xl)		     delimiter two (ch_xx)
;      jsr  xscan	     call to scan next item
;      (xr)		     pointer to scblk for token scanned
;      (wa)		     completion code (see below)
;      (wc,xl)		     destroyed
;
;      the scan starts from the current position and continues
;      until one of the following three conditions occurs.
;
;      1)   delimiter one is encountered  (wa set to 1)
;
;      2)   delimiter two encountered  (wa set to 2)
;
;      3)   end of string encountered  (wa set to 0)
;
;      the result is a string containing all characters scanned
;      up to but not including any delimiter character.
;      the pointer is left pointing past the delimiter.
;
;      if only one delimiter is to be detected, delimiter one
;      and delimiter two should be set to the same value.
;
;      in the case where the end of string is encountered, the
;      string includes all the characters to the end of the
;      string. no further calls can be made to xscan until
;      xscni is called to initialize a new argument scan
	ejc
;
;      xscan (continued)
;
xscan	prc	e,0			; entry point
	mov	xscwb,wb		; preserve wb
	mov	-(xs),wa		; record blank skip flag
	mov	-(xs),wa		; and second copy
	mov	xr,r_xsc		; point to argument string
	mov	wa,sclen(xr)		; load string length
	mov	wb,xsofs		; load current offset
	sub	wa,wb			; get number of remaining characters
	bze	wa,xscn3		; jump if no characters left
	plc	xr,wb			; point to current character
;
;      loop to search for delimiter
;
xscn1	lch	wb,(xr)+		; load next character
	beq	wb,wc,xscn4		; jump if delimiter one found
	beq	wb,xl,xscn5		; jump if delimiter two found
	bze	(xs),xscn2		; jump if not skipping blanks
	icv	xsofs			; assume blank and delete it
.if    .caht
	beq	wb,=ch_ht,xscn2		; jump if horizontal tab
.fi
.if    .cavt
	beq	wb,=ch_vt,xscn2		; jump if vertical tab
.fi
	beq	wb,=ch_bl,xscn2		; jump if blank
	dcv	xsofs			; undelete non-blank character
	zer	(xs)			; and discontinue blank checking
;
;      here after performing any leading blank trimming.
;
xscn2	dcv	wa			; decrement count of chars left
	bnz	wa,xscn1		; loop back if more chars to go
;
;      here for runout
;
xscn3	mov	xl,r_xsc		; point to string block
	mov	wa,sclen(xl)		; get string length
	mov	wb,xsofs		; load offset
	sub	wa,wb			; get substring length
	zer	r_xsc			; clear string ptr for collector
	zer	xscrt			; set zero (runout) return code
	brn	xscn7			; jump to exit
	ejc
;
;      xscan (continued)
;
;      here if delimiter one found
;
xscn4	mov	xscrt,=num01		; set return code
	brn	xscn6			; jump to merge
;
;      here if delimiter two found
;
xscn5	mov	xscrt,=num02		; set return code
;
;      merge here after detecting a delimiter
;
xscn6	mov	xl,r_xsc		; reload pointer to string
	mov	wc,sclen(xl)		; get original length of string
	sub	wc,wa			; minus chars left = chars scanned
	mov	wa,wc			; move to reg for sbstr
	mov	wb,xsofs		; set offset
	sub	wa,wb			; compute length for sbstr
	icv	wc			; adjust new cursor past delimiter
	mov	xsofs,wc		; store new offset
;
;      common exit point
;
xscn7	zer	xr			; clear garbage character ptr in xr
	jsr	sbstr			; build sub-string
	ica	xs			; remove copy of blank flag
	mov	wb,(xs)+		; original blank skip/trim flag
	bze	sclen(xr),xscn8		; cannot trim the null string
	jsr	trimr			; trim trailing blanks if requested
;
;      final exit point
;
xscn8	mov	wa,xscrt		; load return code
	mov	wb,xscwb		; restore wb
	exi				; return to xscan caller
	enp				; end procedure xscan
	ejc
;
;      xscni -- execution function argument scan
;
;      xscni initializes the scan used for prototype arguments
;      in the clear, define, load, data, array functions. see
;      xscan for the procedure which is used after this call.
;
;      -(xs)		     argument to be scanned (on stack)
;      jsr  xscni	     call to scan argument
;      ppm  loc		     transfer loc if arg is not string
;      ppm  loc		     transfer loc if argument is null
;      (xs)		     popped
;      (xr,r_xsc)	     argument (scblk ptr)
;      (wa)		     argument length
;      (ia,ra)		     destroyed
;
xscni	prc	n,2			; entry point
	jsr	gtstg			; fetch argument as string
	ppm	xsci1			; jump if not convertible
	mov	r_xsc,xr		; else store scblk ptr for xscan
	zer	xsofs			; set offset to zero
	bze	wa,xsci2		; jump if null string
	exi				; return to xscni caller
;
;      here if argument is not a string
;
xsci1	exi	1			; take not-string error exit
;
;      here for null string
;
xsci2	exi	2			; take null-string error exit
	enp				; end procedure xscni
	ttl	s p i t b o l -- stack overflow section
;
;      control comes here if the main stack overflows
;
	sec				; start of stack overflow section
;
	add	errft,=num04		; force conclusive fatal error
	mov	xs,flptr		; pop stack to avoid more fails
	bnz	gbcfl,stak1		; jump if garbage collecting
	erb	246,stack overflow
;
;      no chance of recovery in mid garbage collection
;
stak1	mov	xr,=endso		; point to message
	zer	kvdmp			; memory is undumpable
	brn	stopr			; give up
	ttl	s p i t b o l -- error section
;
;      this section of code is entered whenever a procedure
;      return via an err parameter or an erb opcode is obeyed.
;
;      (wa)		     is the error code
;
;      the global variable stage indicates the point at which
;      the error occured as follows.
;
;      stage=stgic	     error during initial compile
;
;      stage=stgxc	     error during compile at execute
;			     time (code, convert function calls)
;
;      stage=stgev	     error during compilation of
;			     expression at execution time
;			     (eval, convert function call).
;
;      stage=stgxt	     error at execute time. compiler
;			     not active.
;
;      stage=stgce	     error during initial compile after
;			     scanning out the end line.
;
;      stage=stgxe	     error during compile at execute
;			     time after scanning end line.
;
;      stage=stgee	     error during expression evaluation
;
	sec				; start of error section
;
error	beq	r_cim,=cmlab,cmple	; jump if error in scanning label
	mov	kvert,wa		; save error code
	zer	scnrs			; reset rescan switch for scane
	zer	scngo			; reset goto switch for scane
.if    .cpol
	mov	polcs,=num01		; reset poll count
	mov	polct,=num01		; reset poll count
.fi
	mov	xr,stage		; load current stage
	bsw	xr,stgno		; jump to appropriate error circuit
	iff	stgic,err01		; initial compile
	iff	stgxc,err04		; execute time compile
	iff	stgev,err04		; eval compiling expr.
	iff	stgee,err04		; eval evaluating expr
	iff	stgxt,err05		; execute time
	iff	stgce,err01		; compile - after end
	iff	stgxe,err04		; xeq compile-past end
	esw				; end switch on error type
	ejc
;
;      error during initial compile
;
;      the error message is printed as part of the compiler
;      output. this printout includes the offending line (if not
;      printed already) and an error flag under the appropriate
;      column as indicated by scnse unless scnse is set to zero.
;
;      after printing the message, the generated code is
;      modified to an error call and control is returned to
;      the cmpil procedure after resetting the stack pointer.
;
;      if the error occurs after the end line, control returns
;      in a slightly different manner to ensure proper cleanup.
;
err01	mov	xs,cmpxs		; reset stack pointer
	ssl	cmpss			; restore s-r stack ptr for cmpil
	bnz	errsp,err03		; jump if error suppress flag set
.if    .cera
.if    .csfn
	mov	wc,cmpsn		; current statement
	jsr	filnm			; obtain file name for this statement
.fi
	mov	wb,scnse		; column number
	mov	wc,rdcln		; line number
	mov	xr,stage		;
	jsr	sysea			; advise system of error
	ppm	erra3			; if system does not want print
	mov	-(xs),xr		; save any provided print message
.fi
	mov	erlst,erich		; set flag for listr
	jsr	listr			; list line
	jsr	prtis			; terminate listing
	zer	erlst			; clear listr flag
	mov	wa,scnse		; load scan element offset
	bze	wa,err02		; skip if not set
.if    .caht
	lct	wb,wa			; loop counter
	icv	wa			; increase for ch_ex
	mov	xl,r_cim		; point to bad statement
	jsr	alocs			; string block for error flag
	mov	wa,xr			; remember string ptr
	psc	xr			; ready for character storing
	plc	xl			; ready to get chars
;
;      loop to replace all chars but tabs by blanks
;
erra1	lch	wc,(xl)+		; get next char
	beq	wc,=ch_ht,erra2		; skip if tab
	mov	wc,=ch_bl		; get a blank
	ejc
;
;      merge to store blank or tab in error line
;
erra2	sch	wc,(xr)+		; store char
	bct	wb,erra1		; loop
	mov	xl,=ch_ex		; exclamation mark
	sch	xl,(xr)			; store at end of error line
	csc	xr			; end of sch loop
	mov	profs,=stnpd		; allow for statement number
	mov	xr,wa			; point to error line
	jsr	prtst			; print error line
.else
	mti	prlen			; get print buffer length
	mfi	gtnsi			; store as signed integer
	add	wa,=stnpd		; adjust for statement number
	mti	wa			; copy to integer accumulator
	rmi	gtnsi			; remainder modulo print bfr length
	sti	profs			; use as character offset
	mov	wa,=ch_ex		; get exclamation mark
	jsr	prtch			; generate under bad column
.fi
;
;      here after placing error flag as required
;
err02	jsr	prtis			; print blank line
.if    .cera
	mov	xr,(xs)+		; restore any sysea message
	bze	xr,erra0		; did sysea provide message to print
	jsr	prtst			; print sysea message
.fi
erra0	jsr	ermsg			; generate flag and error message
	add	lstlc,=num03		; bump page ctr for blank, error, blk
erra3	zer	xr			; in case of fatal error
	bhi	errft,=num03,stopr	; pack up if several fatals
;
;      count error, inhibit execution if required
;
	icv	cmerc			; bump error count
	add	noxeq,cswer		; inhibit xeq if -noerrors
	bne	stage,=stgic,cmp10	; special return if after end line
	ejc
;
;      loop to scan to end of statement
;
err03	mov	xr,r_cim		; point to start of image
	plc	xr			; point to first char
	lch	xr,(xr)			; get first char
	beq	xr,=ch_mn,cmpce		; jump if error in control card
	zer	scnrs			; clear rescan flag
	mnz	errsp			; set error suppress flag
	jsr	scane			; scan next element
	bne	xl,=t_smc,err03		; loop back if not statement end
	zer	errsp			; clear error suppress flag
;
;      generate error call in code and return to cmpil
;
	mov	cwcof,*cdcod		; reset offset in ccblk
	mov	wa,=ocer_		; load compile error call
	jsr	cdwrd			; generate it
	mov	cmsoc(xs),cwcof		; set success fill in offset
	mnz	cmffc(xs)		; set failure fill in flag
	jsr	cdwrd			; generate succ. fill in word
	brn	cmpse			; merge to generate error as cdfal
;
;      error during execute time compile or expression evaluatio
;
;      execute time compilation is initiated through gtcod or
;      gtexp which are called by compile, code or eval.
;      before causing statement failure through exfal it is
;      helpful to set keyword errtext and for generality
;      these errors may be handled by the setexit mechanism.
;
err04	bge	errft,=num03,labo1	; abort if too many fatal errors
.if    .cpol
	beq	kvert,=nm320,err06	; treat user interrupt specially
.fi
	zer	r_ccb			; forget garbage code block
	mov	cwcof,*cccod		; set initial offset (mbe catspaw)
	ssl	iniss			; restore main prog s-r stack ptr
	jsr	ertex			; get fail message text
	dca	xs			; ensure stack ok on loop start
;
;      pop stack until find flptr for most deeply nested prog.
;      defined function call or call of eval / code.
;
erra4	ica	xs			; pop stack
	beq	xs,flprt,errc4		; jump if prog defined fn call found
	bne	xs,gtcef,erra4		; loop if not eval or code call yet
	mov	stage,=stgxt		; re-set stage for execute
	mov	r_cod,r_gtc		; recover code ptr
	mov	flptr,xs		; restore fail pointer
	zer	r_cim			; forget possible image
.if    .cinc
	zer	cnind			; forget possible include
.fi
;
;      test errlimit
;
errb4	bnz	kverl,err07		; jump if errlimit non-zero
	brn	exfal			; fail
;
;      return from prog. defined function is outstanding
;
errc4	mov	xs,flptr		; restore stack from flptr
	brn	errb4			; merge
	ejc
;
;      error at execute time.
;
;      the action taken on an error is as follows.
;
;      if errlimit keyword is zero, an abort is signalled,
;      see coding for system label abort at l_abo.
;
;      otherwise, errlimit is decremented and an errtype trace
;      generated if required. control returns either via a jump
;      to continue (to take the failure exit) or a specified
;      setexit trap is executed and control passes to the trap.
;      if 3 or more fatal errors occur an abort is signalled
;      regardless of errlimit and setexit - looping is all too
;      probable otherwise. fatal errors include stack overflow
;      and exceeding stlimit.
;
err05	ssl	iniss			; restore main prog s-r stack ptr
	bnz	dmvch,err08		; jump if in mid-dump
;
;      merge here from err08 and err04 (error 320)
;
err06	bze	kverl,labo1		; abort if errlimit is zero
	jsr	ertex			; get fail message text
;
;      merge from err04
;
err07	bge	errft,=num03,labo1	; abort if too many fatal errors
	dcv	kverl			; decrement errlimit
	mov	xl,r_ert		; load errtype trace pointer
	jsr	ktrex			; generate errtype trace if required
	mov	wa,r_cod		; get current code block
	mov	r_cnt,wa		; set cdblk ptr for continuation
	scp	wb			; current code pointer
	sub	wb,wa			; offset within code block
	mov	stxoc,wb		; save code ptr offset for scontinue
	mov	xr,flptr		; set ptr to failure offset
	mov	stxof,(xr)		; save failure offset for continue
	mov	xr,r_sxc		; load setexit cdblk pointer
	bze	xr,lcnt1		; continue if no setexit trap
	zer	r_sxc			; else reset trap
	mov	stxvr,=nulls		; reset setexit arg to null
	mov	xl,(xr)			; load ptr to code block routine
	bri	xl			; execute first trap statement
;
;      interrupted partly through a dump whilst store is in a
;      mess so do a tidy up operation. see dumpr for details.
;
err08	mov	xr,dmvch		; chain head for affected vrblks
	bze	xr,err06		; done if zero
	mov	dmvch,(xr)		; set next link as chain head
	jsr	setvr			; restore vrget field
;
;      label to mark end of code
;
s_yyy	brn	err08			; loop through chain
	ttl	s p i t b o l -- here endeth the code
;
;      end of assembly
;
	end				; end macro-spitbol assembly
