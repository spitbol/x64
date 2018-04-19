* copyright 1987-2012 robert b. k. dewar and mark emmer.
*
* copyright 2012-2015 david shields
*
* this file is part of macro spitbol.
*
*     macro spitbol is free software: you can redistribute it and/or modify
*     it under the terms of the gnu general public license as published by
*     the free software foundation, either version 2 of the license, or
*     (at your option) any later version.
*
*     macro spitbol is distributed in the hope that it will be useful,
*     but without any warranty; without even the implied warranty of
*     merchantability or fitness for a particular purpose.  see the
*     gnu general public license for more details.
*
*     you should have received a copy of the gnu general public license
*     along with macro spitbol.  if not, see <http://www.gnu.org/licenses/>.
*
*      spitbol conditional assembly symbols for use by token.spt
*      ---------------------------------------------------------
*
*      this file of conditional symbols will override the conditional
*      definitions contained in the spitbol minimal file.   in addition,
*      lines beginning with ">" are treated as spitbol statements and
*      immediately executed.
*
*      for linux spitbol-x86
*
*      in the spitbol translator, the following conditional
*      assembly symbols are referred to. to incorporate the
*      features referred to, the minimal source should be
*      prefaced by suitable conditional assembly symbol
*      definitions.
*      in all cases it is permissible to default the definitions
*      in which case the additional features will be omitted
*      from the target code.
*
*
*                            conditional options
*                            since .undef not allowed if symbol not
*                            defined, a full comment line indicates
*                            symbol initially not defined.
*
*      .caex                 define to allow up arrow for exponentiation
*      .cavt                 define to include vertical tab
*      .ccmc                 define to include syscm function
*      .ceng                 define to include engine features
*      .cnci                 define to enable sysci routine
*      .cncr                 define to enable syscr routine
*      .cnex                 define to omit exit() code.
*      .cnld                 define to omit load() code.
*      .cnpf                 define to omit profile stuff
*def   .cnra                 define to omit all real arithmetic
*      .cnsr                 define to omit sort, rsort
*      .crpp                 define if return points have odd parity
*      .cs16                 define to initialize stlim to 32767
*      .culc                 define to include &case (lc names)
*      .cust                 define to include set() code
*      .cusr                 define to have set() use real values
*                             (must also #define setreal 1 in systype.h)
*
{{ttl{27,l i c e n s e -- software license for this program{{{{93
*     copyright 1983-2012 robert b. k. dewar
*     copyright 2012-2015 david shields
*     this file is part of macro spitbol.
*     macro spitbol is free software: you can redistribute it and/or modify
*     it under the terms of the gnu general public license as published by
*     the free software foundation, either version 2 of the license, or
*     (at your option) any later version.
*     macro spitbol is distributed in the hope that it will be useful,
*     but without any warranty; without even the implied warranty of
*     merchantability or fitness for a particular purpose.  see the
*     gnu general public license for more details.
*     you should have received a copy of the gnu general public license
*     along with macro spitbol.  if not, see <http://www.gnu.org/licenses/>.
{{ttl{27,s p i t b o l -- notes to implementors{{{{113
*      m a c r o   s p i t b o l     v e r s i o n   13.01
*      ---------------------------------------------------
*      date of release  -  january 2013
*      macro spitbol is maintained by
*           dr. david shields
*           260 garth rd apt 3h4
*           scarsdale, ny 10583
*      e-mail - thedaveshields at gmail dot com
*      version 3.7 was maintained by
*           mark emmer
*           catspaw, inc.
*           p.o. box 1123
*           salida, colorado 81021
*           u.s.a
*      e-mail - marke at snobol4 dot com
*      versions 2.6 through 3.4 were maintained by
*           dr. a. p. mccann (deceased)
*           department of computer studies
*           university of leeds
*           leeds ls2 9jt
*           england.
*      from 1979 through early 1983 a number of fixes and
*      enhancements were made by steve duff and robert goldberg.
{{ttl{27,s p i t b o l - revision history{{{{145
{{ejc{{{{{146
*      r e v i s i o n   h i s t o r y
*      -------------------------------
*      version 13.01 (january 2013, david shields)
*      this version has the same functionality as the previous release, but with
*      many internal code changes.
*      support for x86-64 has been added, but is not currently working.
*      the description of the minimal language formerly found here as comments
*      is now to be found in the file minimal-reference-manual.html
*      version 3.8 (june 2012, david shields)
*      --------------------------------------
*	       this version is very close to v3.7, with the
*              same functionality.
*              the source is now maintained using git, so going forward
*              the detailed revision history will be recorded in the git
*              commit logs, not in this file.
{{ttl{27,s p i t b o l  -- basic information{{{{168
{{ejc{{{{{169
*      general structure
*      -----------------
*      this program is a translator for a version of the snobol4
*      programming language. language details are contained in
*      the manual macro spitbol by dewar and mccann, technical
*      report 90, university of leeds 1976.
*      the implementation is discussed in dewar and mccann,
*      macro spitbol - a snobol4 compiler, software practice and
*      experience, 7, 95-113, 1977.
*      the language is as implemented by the btl translator
*      (griswold, poage and polonsky, prentice hall, 1971)
*      with the following principal exceptions.
*      1)   redefinition of standard system functions and
*           operators is not permitted.
*      2)   the value function is not provided.
*      3)   access tracing is provided in addition to the
*           other standard trace modes.
*      4)   the keyword stfcount is not provided.
*      5)   the keyword fullscan is not provided and all pattern
*           matching takes place in fullscan mode (i.e. with no
*           heuristics applied).
*      6)   a series of expressions separated by commas may
*           be grouped within parentheses to provide a selection
*           capability. the semantics are that the selection
*           assumes the value of the first expression within it
*           which succeeds as they are evaluated from the left.
*           if no expression succeeds the entire statement fails
*      7)   an explicit pattern matching operator is provided.
*           this is the binary query (see gimpel sigplan oct 74)
*      8)   the assignment operator is introduced as in the
*           gimpel reference.
*      9)   the exit function is provided for generating load
*           modules - cf. gimpels sitbol.
*      the method used in this program is to translate the
*      source code into an internal pseudo-code (see following
*      section). an interpretor is then used to execute this
*      generated pseudo-code. the nature of the snobol4 language
*      is such that the latter task is much more complex than
*      the actual translation phase. accordingly, nearly all the
*      code in the program section is concerned with the actual
*      execution of the snobol4 program.
{{ejc{{{{{224
*      interpretive code format
*      ------------------------
*      the interpretive pseudo-code consists of a series of
*      address pointers. the exact format of the code is
*      described in connection with the cdblk format. the
*      purpose of this section is to give general insight into
*      the interpretive approach involved.
*      the basic form of the code is related to reverse polish.
*      in other words, the operands precede the operators which
*      are zero address operators. there are some exceptions to
*      these rules, notably the unary not operator and the
*      selection construction which clearly require advance
*      knowledge of the operator involved.
*      the operands are moved to the top of the main stack and
*      the operators are applied to the top stack entries. like
*      other versions of spitbol, this processor depends on
*      knowing whether operands are required by name or by value
*      and moves the appropriate object to the stack. thus no
*      name/value checks are included in the operator circuits.
*      the actual pointers in the code point to a block whose
*      first word is the address of the interpretor routine
*      to be executed for the code word.
*      in the case of operators, the pointer is to a word which
*      contains the address of the operator to be executed. in
*      the case of operands such as constants, the pointer is to
*      the operand itself. accordingly, all operands contain
*      a field which points to the routine to load the value of
*      the operand onto the stack. in the case of a variable,
*      there are three such pointers. one to load the value,
*      one to store the value and a third to jump to the label.
*      the handling of failure returns deserves special comment.
*      the location flptr contains the pointer to the location
*      on the main stack which contains the failure return
*      which is in the form of a byte offset in the current
*      code block (cdblk or exblk). when a failure occurs, the
*      stack is popped as indicated by the setting of flptr and
*      control is passed to the appropriate location in the
*      current code block with the stack pointer pointing to the
*      failure offset on the stack and flptr unchanged.
{{ejc{{{{{271
*      internal data representations
*      -----------------------------
*      representation of values
*      a value is represented by a pointer to a block which
*      describes the type and particulars of the data value.
*      in general, a variable is a location containing such a
*      pointer (although in the case of trace associations this
*      is modified, see description of trblk).
*      the following is a list of possible datatypes showing the
*      type of block used to hold the value. the details of
*      each block format are given later.
*      datatype              block type
*      --------              ----------
*      array                 arblk or vcblk
*      code                  cdblk
*      expression            exblk or seblk
*      integer               icblk
*      name                  nmblk
*      pattern               p0blk or p1blk or p2blk
*      real                  rcblk
*      string                scblk
*      table                 tbblk
*      program datatype      pdblk
{{ejc{{{{{310
*      representation of variables
*      ---------------------------
*      during the course of evaluating expressions, it is
*      necessary to generate names of variables (for example
*      on the left side of a binary equals operator). these are
*      not to be confused with objects of datatype name which
*      are in fact values.
*      from a logical point of view, such names could be simply
*      represented by a pointer to the appropriate value cell.
*      however in the case of arrays and program defined
*      datatypes, this would violate the rule that there must be
*      no pointers into the middle of a block in dynamic store.
*      accordingly, a name is always represented by a base and
*      offset. the base points to the start of the block
*      containing the variable value and the offset is the
*      offset within this block in bytes. thus the address
*      of the actual variable is determined by adding the base
*      and offset values.
*      the following are the instances of variables represented
*      in this manner.
*      1)   natural variable base is ptr to vrblk
*                            offset is *vrval
*      2)   table element    base is ptr to teblk
*                            offset is *teval
*      3)   array element    base is ptr to arblk
*                            offset is offset to element
*      4)   vector element   base is ptr to vcblk
*                            offset is offset to element
*      5)   prog def dtp     base is ptr to pdblk
*                            offset is offset to field value
*      in addition there are two cases of objects which are
*      like variables but cannot be handled in this manner.
*      these are called pseudo-variables and are represented
*      with a special base pointer as follows=
*      expression variable   ptr to evblk (see evblk)
*      keyword variable      ptr to kvblk (see kvblk)
*      pseudo-variables are handled as special cases by the
*      access procedure (acess) and the assignment procedure
*      (asign). see these two procedures for details.
{{ejc{{{{{363
*      organization of data area
*      -------------------------
*      the data area is divided into two regions.
*      static area
*      the static area builds up from the bottom and contains
*      data areas which are allocated dynamically but are never
*      deleted or moved around. the macro-program itself
*      uses the static area for the following.
*      1)   all variable blocks (vrblk).
*      2)   the hash table for variable blocks.
*      3)   miscellaneous buffers and work areas (see program
*           initialization section).
*      in addition, the system procedures may use this area for
*      input/output buffers, external functions etc. space in
*      the static region is allocated by calling procedure alost
*      the following global variables define the current
*      location and size of the static area.
*      statb                 address of start of static area
*      state                 address+1 of last word in area.
*      the minimum size of static is given approximately by
*           12 + *e_hnb + *e_sts + space for alphabet string
*           and standard print buffer.
{{ejc{{{{{397
*      dynamic area
*      the dynamic area is built upwards in memory after the
*      static region. data in this area must all be in standard
*      block formats so that it can be processed by the garbage
*      collector (procedure gbcol). gbcol compacts blocks down
*      in this region as required by space exhaustion and can
*      also move all blocks up to allow for expansion of the
*      static region.
*      with the exception of tables and arrays, no spitbol
*      object once built in dynamic memory is ever subsequently
*      modified. observing this rule necessitates a copying
*      action during string and pattern concatenation.
*      garbage collection is fundamental to the allocation of
*      space for values. spitbol uses a very efficient garbage
*      collector which insists that pointers into dynamic store
*      should be identifiable without use of bit tables,
*      marker bits etc. to satisfy this requirement, dynamic
*      memory must not start at too low an address and lengths
*      of arrays, tables, strings, code and expression blocks
*      may not exceed the numerical value of the lowest dynamic
*      address.
*      to avoid either penalizing users with modest
*      requirements or restricting those with greater needs on
*      host systems where dynamic memory is allocated in low
*      addresses, the minimum dynamic address may be specified
*      sufficiently high to permit arbitrarily large spitbol
*      objects to be created (with the possibility in extreme
*      cases of wasting large amounts of memory below the
*      start address). this minimum value is made available
*      in variable mxlen by a system routine, sysmx.
*      alternatively sysmx may indicate that a
*      default may be used in which dynamic is placed
*      at the lowest possible address following static.
*      the following global work cells define the location and
*      length of the dynamic area.
*      dnamb                 start of dynamic area
*      dnamp                 next available location
*      dname                 last available location + 1
*      dnamb is always higher than state since the alost
*      procedure maintains some expansion space above state.
*      *** dnamb must never be permitted to have a value less
*      than that in mxlen ***
*      space in the dynamic region is allocated by the alloc
*      procedure. the dynamic region may be used by system
*      procedures provided that all the rules are obeyed.
*      some of the rules are subtle so it is preferable for
*      osint to manage its own memory needs. spitbol procs
*      obey rules to ensure that no action can cause a garbage
*      collection except at such times as contents of xl, xr
*      and the stack are +clean+ (see comment before utility
*      procedures and in gbcol for more detail). note
*      that calls of alost may cause garbage collection (shift
*      of memory to free space). spitbol procs which call
*      system routines assume that they cannot precipitate
*      collection and this must be respected.
{{ejc{{{{{460
*      register usage
*      --------------
*      (cp)                  code pointer register. used to
*                            hold a pointer to the current
*                            location in the interpretive pseudo
*                            code (i.e. ptr into a cdblk).
*      (xl,xr)               general index registers. usually
*                            used to hold pointers to blocks in
*                            dynamic storage. an important
*                            restriction is that the value in
*                            xl must be collectable for
*                            a garbage collect call. a value
*                            is collectable if it either points
*                            outside the dynamic area, or if it
*                            points to the start of a block in
*                            the dynamic area.
*      (xs)                  stack pointer. used to point to
*                            the stack front. the stack may
*                            build up or down and is used
*                            to stack subroutine return points
*                            and other recursively saved data.
*      (xt)                  an alternative name for xl during
*                            its use in accessing stacked items.
*      (wa,wb,wc)            general work registers. cannot be
*                            used for indexing, but may hold
*                            various types of data.
*      (ia)                  used for all signed integer
*                            arithmetic, both that used by the
*                            translator and that arising from
*                            use of snobol4 arithmetic operators
*      (ra)                  real accumulator. used for all
*                            floating point arithmetic.
{{ejc{{{{{501
*      spitbol conditional assembly symbols
*      ------------------------------------
*      in the spitbol translator, the following conditional
*      assembly symbols are referred to. to incorporate the
*      features referred to, the minimal source should be
*      prefaced by suitable conditional assembly symbol
*      definitions.
*      in all cases it is permissible to default the definitions
*      in which case the additional features will be omitted
*      from the target code.
*      .caex                 define to allow up arrow for expon.
*      .caht                 define to include horizontal tab
*      .casl                 define to include 26 shifted lettrs
*      .cavt                 define to include vertical tab
*      .cbyt                 define for statistics in bytes
*      .ccmc                 define to include syscm function
*      .ccmk                 define to include compare keyword
*      .cepp                 define if entrys have odd parity
*      .cera                 define to include sysea function
*      .cexp                 define if spitbol pops sysex args
*      .cgbc                 define to include sysgc function
*      .cicc                 define to ignore bad control cards
*      .cinc                 define to add -include control card
*      .ciod                 define to not use default delimiter
*                              in processing 3rd arg of input()
*                              and output()
*      .cmth                 define to include math functions
*      .cnbf                 define to omit buffer extension
*      .cnbt                 define to omit batch initialisation
*      .cnci                 define to enable sysci routine
*      .cncr                 define to enable syscr routine
*      .cnex                 define to omit exit() code.
*      .cnld                 define to omit load() code.
*      .cnlf                 define to add file type for load()
*      .cnpf                 define to omit profile stuff
*      .cnra                 define to omit all real arithmetic
*      .cnsc                 define to no numeric-string compare
*      .cnsr                 define to omit sort, rsort
*      .cpol                 define if interface polling desired
*      .crel                 define to include reloc routines
*      .crpp                 define if returns have odd parity
*      .cs16                 define to initialize stlim to 32767
*      .cs32                 define to init stlim to 2147483647
*                            omit to take default of 50000
*      .csax                 define if sysax is to be called
*      .csed                 define to use sediment in gbcol
*      .csfn                 define to track source file names
*      .csln                 define if line number in code block
*      .csou                 define if output, terminal to sysou
*      .ctet                 define to table entry trace wanted
*      .ctmd                 define if systm unit is decisecond
*      .cucf                 define to include cfp_u
*      .cuej                 define to suppress needless ejects
*      .culk                 define to include &l/ucase keywords
*      .culc                 define to include &case (lc names)
*                            if cucl defined, must support
*                            minimal op flc wreg that folds
*                            argument to lower case
*      .cust                 define to include set() code
*                            conditional options
*                            since .undef not allowed if symbol
*                            not defined, a full comment line
*                            indicates symbol initially not
*                            defined.
*      .cbyt                 define for statistics in bytes
*      .ccmc                 define to include syscm function
*      .ccmk                 define to include compare keyword
*      .cepp                 define if entrys have odd parity
*      .cera                 define to include sysea function
*      .cexp                 define if spitbol pops sysex args
*      .cicc                 define to ignore bad control cards
*      .cinc                 define to add -include control card
*                            in processing 3rd arg of input()
*                            and output()
*      .cmth                 define to include math functions
*      .cnci                 define to enable sysci routine
*      .cncr                 define to enable syscr routine
*      .cnex                 define to omit exit() code.
*      .cnlf                 define to add file type to load()
*      .cnpf                 define to omit profile stuff
*      .cnra                 define to omit all real arithmetic
*      .cnsc                 define if no numeric-string compare
*      .cnsr                 define to omit sort, rsort
*      .cpol                 define if interface polling desired
*      .crel                 define to include reloc routines
*      .crpp                 define if returns have odd parity
*      .cs16                 define to initialize stlim to 32767
*      .cs32                 define to init stlim to 2147483647
*      .csed                 define to use sediment in gbcol
*      .csfn                 define to track source file names
*      .csln                 define if line number in code block
*      .csou                 define if output, terminal to sysou
*      .ctmd                 define if systm unit is decisecond
*      force definition of .ccmk if .ccmc is defined
{{ttl{27,s p i t b o l -- procedures section{{{{622
*      this section starts with descriptions of the operating
*      system dependent procedures which are used by the spitbol
*      translator. all such procedures have five letter names
*      beginning with sys. they are listed in alphabetical
*      order.
*      all procedures have a  specification consisting of a
*      model call, preceded by a possibly empty list of register
*      contents giving parameters available to the procedure and
*      followed by a possibly empty list of register contents
*      required on return from the call or which may have had
*      their contents destroyed. only those registers explicitly
*      mentioned in the list after the call may have their
*      values changed.
*      the segment of code providing the external procedures is
*      conveniently referred to as osint (operating system
*      interface). the sysxx procedures it contains provide
*      facilities not usually available as primitives in
*      assembly languages. for particular target machines,
*      implementors may choose for some minimal opcodes which
*      do not have reasonably direct translations, to use calls
*      of additional procedures which they provide in osint.
*      e.g. mwb or trc might be translated as jsr sysmb,
*      jsr systc in some implementations.
*      in the descriptions, reference is made to --blk
*      formats (-- = a pair of letters). see the spitbol
*      definitions section for detailed descriptions of all
*      such block formats except fcblk for which sysfc should
*      be consulted.
*      section 0 contains inp,inr specifications of internal
*      procedures,routines. this gives a single pass translator
*      information making it easy to generate alternative calls
*      in the translation of jsr-s for procedures of different
*      types if this proves necessary.
{{sec{{{{start of procedures section{660
{{ejc{{{{{662
*      sysax -- after execution
{sysax{exp{1,0{{{define external entry point{666
*      if the conditional assembly symbol .csax is defined,
*      this routine is called immediately after execution and
*      before printing of execution statistics or dump output.
*      purpose of call is for implementor to determine and
*      if the call is not required it will be omitted if .csax
*      is undefined. in this case sysax need not be coded.
*      jsr  sysax            call after execution
{{ejc{{{{{678
*      sysbs -- backspace file
{sysbs{exp{1,3{{{define external entry point{683
*      sysbs is used to implement the snobol4 function backspace
*      if the conditional assembly symbol .cbsp is defined.
*      the meaning is system dependent.  in general, backspace
*      repositions the file one record closer to the beginning
*      of file, such that a subsequent read or write will
*      operate on the previous record.
*      (wa)                  ptr to fcblk or zero
*      (xr)                  backspace argument (scblk ptr)
*      jsr  sysbs            call to backspace
*      ppm  loc              return here if file does not exist
*      ppm  loc              return here if backspace not allowed
*      ppm  loc              return here if i/o error
*      (wa,wb)               destroyed
*      the second error return is used for files for which
*      backspace is not permitted. for example, it may be expected
*      files on character devices are in this category.
{{ejc{{{{{703
*      sysbx -- before execution
{sysbx{exp{1,0{{{define external entry point{708
*      called after initial spitbol compilation and before
*      commencing execution in case osint needs
*      to assign files or perform other necessary services.
*      osint may also choose to send a message to online
*      terminal (if any) indicating that execution is starting.
*      jsr  sysbx            call before execution starts
{{ejc{{{{{717
*      sysdc -- date check
{sysdc{exp{1,0{{{define external entry point{811
*      sysdc is called to check that the expiry date for a trial
*      version of spitbol is unexpired.
*      jsr  sysdc            call to check date
*      return only if date is ok
{{ejc{{{{{818
*      sysdm  -- dump core
{sysdm{exp{1,0{{{define external entry point{822
*      sysdm is called by a spitbol program call of dump(n) with
*      n ge 4.  its purpose is to provide a core dump.
*      n could hold an encoding of the start adrs for dump and
*      amount to be dumped e.g.  n = 256*a + s , s = start adrs
*      in kilowords,  a = kilowords to dump
*      (xr)                  parameter n of call dump(n)
*      jsr  sysdm            call to enter routine
{{ejc{{{{{832
*      sysdt -- get current date
{sysdt{exp{1,0{{{define external entry point{836
*      sysdt is used to obtain the current date. the date is
*      returned as a character string in any format appropriate
*      to the operating system in use. it may also contain the
*      current time of day. sysdt is used to implement the
*      snobol4 function date().
*      (xr)                  parameter n of call date(n)
*      jsr  sysdt            call to get date
*      (xl)                  pointer to block containing date
*      the format of the block is like an scblk except that
*      the first word need not be set. the result is copied
*      into spitbol dynamic memory on return.
{{ejc{{{{{852
*      sysea -- inform osint of compilation and runtime errors
{sysea{exp{1,1{{{define external entry point{856
*      provides means for interface to take special actions on
*      errors
*      (wa)                  error code
*      (wb)                  line number
*      (wc)                  column number
*      (xr)                  system stage
*      (xl)                  file name (scblk)
*      jsr  sysea            call to sysea function
*      ppm  loc              suppress printing of error message
*      (xr)                  message to print (scblk) or 0
*      sysea may not return if interface chooses to retain
*      control.  closing files via the fcb chain will be the
*      responsibility of the interface.
*      all registers preserved
{{ejc{{{{{878
*      sysef -- eject file
{sysef{exp{1,3{{{define external entry point{882
*      sysef is used to write a page eject to a named file. it
*      may only be used for files where this concept makes
*      sense. note that sysef is not normally used for the
*      standard output file (see sysep).
*      (wa)                  ptr to fcblk or zero
*      (xr)                  eject argument (scblk ptr)
*      jsr  sysef            call to eject file
*      ppm  loc              return here if file does not exist
*      ppm  loc              return here if inappropriate file
*      ppm  loc              return here if i/o error
{{ejc{{{{{895
*      sysej -- end of job
{sysej{exp{1,0{{{define external entry point{899
*      sysej is called once at the end of execution to
*      terminate the run. the significance of the abend and
*      code values is system dependent. in general, the code
*      value should be made available for testing, and the
*      abend value should cause some post-mortem action such as
*      a dump. note that sysej does not return to its caller.
*      see sysxi for details of fcblk chain
*      (wa)                  value of abend keyword
*      (wb)                  value of code keyword
*      (xl)                  o or ptr to head of fcblk chain
*      jsr  sysej            call to end job
*      the following special values are used as codes in (wb)
*      999  execution suppressed
*      998  standard output file full or unavailable in a sysxi
*           load module. in these cases (wa) contains the number
*           of the statement causing premature termination.
{{ejc{{{{{919
*      sysem -- get error message text
{sysem{exp{1,0{{{define external entry point{923
*      sysem is used to obtain the text of err, erb calls in the
*      source program given the error code number. it is allowed
*      to return a null string if this facility is unavailable.
*      (wa)                  error code number
*      jsr  sysem            call to get text
*      (xr)                  text of message
*      the returned value is a pointer to a block in scblk
*      format except that the first word need not be set. the
*      string is copied into dynamic memory on return.
*      if the null string is returned either because sysem does
*      not provide error message texts or because wa is out of
*      range, spitbol will print the string stored in errtext
*      keyword.
{{ejc{{{{{940
*      sysen -- endfile
{sysen{exp{1,3{{{define external entry point{944
*      sysen is used to implement the snobol4 function endfile.
*      the meaning is system dependent. in general, endfile
*      implies that no further i/o operations will be performed,
*      but does not guarantee this to be the case. the file
*      should be closed after the call, a subsequent read
*      or write may reopen the file at the start or it may be
*      necessary to reopen the file via sysio.
*      (wa)                  ptr to fcblk or zero
*      (xr)                  endfile argument (scblk ptr)
*      jsr  sysen            call to endfile
*      ppm  loc              return here if file does not exist
*      ppm  loc              return here if endfile not allowed
*      ppm  loc              return here if i/o error
*      (wa,wb)               destroyed
*      the second error return is used for files for which
*      endfile is not permitted. for example, it may be expected
*      that the standard input and output files are in this
*      category.
{{ejc{{{{{966
*      sysep -- eject printer page
{sysep{exp{1,0{{{define external entry point{970
*      sysep is called to perform a page eject on the standard
*      printer output file (corresponding to syspr output).
*      jsr  sysep            call to eject printer output
{{ejc{{{{{976
*      sysex -- call external function
{sysex{exp{1,3{{{define external entry point{980
*      sysex is called to pass control to an external function
*      previously loaded with a call to sysld.
*      (xs)                  pointer to arguments on stack
*      (xl)                  pointer to control block (efblk)
*      (wa)                  number of arguments on stack
*      jsr  sysex            call to pass control to function
*      ppm  loc              return here if function call fails
*      ppm  loc              return here if insufficient memory
*      ppm  loc              return here if bad argument type
*      (xr)                  result returned
*      the arguments are stored on the stack with
*      the last argument at 0(xs). on return, xs
*      is popped past the arguments.
*      the form of the arguments as passed is that used in the
*      spitbol translator (see definitions and data structures
*      section). the control block format is also described
*      (under efblk) in this section.
*      there are two ways of returning a result.
*      1)   return a pointer to a block in dynamic storage. this
*           block must be in exactly correct format, including
*           the first word. only functions written with intimate
*           knowledge of the system will return in this way.
*      2)   string, integer and real results may be returned by
*           pointing to a pseudo-block outside dynamic memory.
*           this block is in icblk, rcblk or scblk format except
*           that the first word will be overwritten
*           by a type word on return and so need not
*           be correctly set. such a result is
*           copied into main storage before proceeding.
*           unconverted results may similarly be returned in a
*           pseudo-block which is in correct format including
*           type word recognisable by garbage collector since
*           block is copied into dynamic memory.
{{ejc{{{{{1025
*      sysfc -- file control block routine
{sysfc{exp{1,2{{{define external entry point{1029
*      see also sysio
*      input and output have 3 arguments referred to as shown
*           input(variable name,file arg1,file arg2)
*           output(variable name,file arg1,file arg2)
*      file arg1 may be an integer or string used to identify
*      an i/o channel. it is converted to a string for checking.
*      the exact significance of file arg2
*      is not rigorously prescribed but to improve portability,
*      the scheme described in the spitbol user manual
*      should be adopted when possible. the preferred form is
*      a string _f_,r_r_,c_c_,i_i_,...,z_z_  where
*      _f_ is an optional file name which is placed first.
*       remaining items may be omitted or included in any order.
*      _r_ is maximum record length
*      _c_ is a carriage control character or character string
*      _i_ is some form of channel identification used in the
*         absence of _f_ to associate the variable
*         with a file allocated dynamically by jcl commands at
*         spitbol load time.
*      ,...,z_z_ are additional fields.
*      if , (comma) cannot be used as a delimiter, .ciod
*      should be defined to introduce by conditional assembly
*      another delimiter (see
*        iodel  equ  *
*      early in definitions section).
*      sysfc is called when a variable is input or output
*      associated to check file arg1 and file arg2 and
*      to  report whether an fcblk (file control
*      block) is necessary and if so what size it should be.
*      this makes it possible for spitbol rather than osint to
*      allocate such a block in dynamic memory if required
*      or alternatively in static memory.
*      the significance of an fcblk , if one is requested, is
*      entirely up to the system interface. the only restriction
*      is that if the fcblk should appear to lie in dynamic
*      memory, pointers to it should be proper pointers to
*      the start of a recognisable and garbage collectable
*      block (this condition will be met if sysfc requests
*      spitbol to provide an fcblk).
*      an option is provided for osint to return a pointer in
*      xl to an fcblk which it privately allocated. this ptr
*      will be made available when i/o occurs later.
*      private fcblks may have arbitrary contents and spitbol
*      stores nothing in them.
{{ejc{{{{{1075
*      the requested size for an fcblk in dynamic memory
*      should allow a 2 word overhead for block type and
*      length fields. information subsequently stored in the
*      remaining words may be arbitrary if an xnblk (external
*      non-relocatable block) is requested. if the request is
*      for an xrblk (external relocatable block) the
*      contents of words should be collectable (i.e. any
*      apparent pointers into dynamic should be genuine block
*      pointers). these restrictions do not apply if an fcblk
*      is allocated outside dynamic or is not allocated at all.
*      if an fcblk is requested, its fields will be initialised
*      to zero before entry to sysio with the exception of
*      words 0 and 1 in which the block type and length
*      fields are placed for fcblks in dynamic memory only.
*      for the possible use of sysej and sysxi, if fcblks
*      are used, a chain is built so that they may all be
*      found - see sysxi for details.
*      if both file arg1 and file arg2 are null, calls of sysfc
*      and sysio are omitted.
*      if file arg1 is null (standard input/output file), sysfc
*      is called to check non-null file arg2 but any request
*      for an fcblk will be ignored, since spitbol handles the
*      standard files specially and cannot readily keep fcblk
*      pointers for them.
*      filearg1 is type checked by spitbol so further checking
*      may be unneccessary in many implementations.
*      file arg2 is passed so that sysfc may analyse and
*      check it. however to assist in this, spitbol also passes
*      on the stack the components of this argument with
*      file name, _f_ (otherwise null) extracted and stacked
*      first.
*      the other fields, if any, are extracted as substrings,
*      pointers to them are stacked and a count of all items
*      stacked is placed in wc. if an fcblk was earlier
*      allocated and pointed to via file arg1, sysfc is also
*      passed a pointer to this fcblk.
*      (xl)                  file arg1 scblk ptr (2nd arg)
*      (xr)                  filearg2 (3rd arg) or null
*      -(xs)...-(xs)         scblks for _f_,_r_,_c_,...
*      (wc)                  no. of stacked scblks above
*      (wa)                  existing file arg1 fcblk ptr or 0
*      (wb)                  0/3 for input/output assocn
*      jsr  sysfc            call to check need for fcblk
*      ppm  loc              invalid file argument
*      ppm  loc              fcblk already in use
*      (xs)                  popped (wc) times
*      (wa non zero)         byte size of requested fcblk
*      (wa=0,xl non zero)    private fcblk ptr in xl
*      (wa=xl=0)             no fcblk wanted, no private fcblk
*      (wc)                  0/1/2 request alloc of xrblk/xnblk
*                            /static block for use as fcblk
*      (wb)                  destroyed
{{ejc{{{{{1130
*      sysgc -- inform interface of garbage collections
{sysgc{exp{1,0{{{define external entry point{1134
*      provides means for interface to take special actions
*      prior to and after a garbage collection.
*      possible usages-
*      1. provide visible screen icon of garbage collection
*         in progress
*      2. inform virtual memory manager to ignore page access
*         patterns during garbage collection.  such accesses
*         typically destroy the page working set accumulated
*         by the program.
*      3. inform virtual memory manager that contents of memory
*         freed by garbage collection can be discarded.
*      (xr)                  non-zero if beginning gc
*                            =0 if completing gc
*      (wa)                  dnamb=start of dynamic area
*      (wb)                  dnamp=next available location
*      (wc)                  dname=last available location + 1
*      jsr  sysgc            call to sysgc function
*      all registers preserved
{{ejc{{{{{1158
*      syshs -- give access to host computer features
{syshs{exp{1,8{{{define external entry point{1162
*      provides means for implementing special features
*      on different host computers. the only defined entry is
*      that where all arguments are null in which case syshs
*      returns an scblk containing name of computer,
*      name of operating system and name of site separated by
*      colons. the scblk need not have a correct first field
*      as this is supplied on copying string to dynamic memory.
*      spitbol does no argument checking but does provide a
*      single error return for arguments checked as erroneous
*      by osint. it also provides a single execution error
*      return. if these are inadequate, use may be made of the
*      minimal error section direct as described in minimal
*      documentation, section 10.
*      several non-error returns are provided. the first
*      corresponds to the defined entry or, for implementation
*      defined entries, any string may be returned. the others
*      permit respectively,  return a null result, return with a
*      result to be stacked which is pointed at by xr, and a
*      return causing spitbol statement failure. if a returned
*      result is in dynamic memory it must obey garbage
*      collector rules. the only results copied on return
*      are strings returned via ppm loc3 return.
*      (wa)                  argument 1
*      (xl)                  argument 2
*      (xr)                  argument 3
*      (wb)                  argument 4
*      (wc)                  argument 5
*      jsr  syshs            call to get host information
*      ppm  loc1             erroneous arg
*      ppm  loc2             execution error
*      ppm  loc3             scblk ptr in xl or 0 if unavailable
*      ppm  loc4             return a null result
*      ppm  loc5             return result in xr
*      ppm  loc6             cause statement failure
*      ppm  loc7             return string at xl, length wa
*      ppm  loc8             return copy of result in xr
{{ejc{{{{{1201
*      sysid -- return system identification
{sysid{exp{1,0{{{define external entry point{1205
*      this routine should return strings to head the standard
*      printer output. the first string will be appended to
*      a heading line of the form
*           macro spitbol version v.v
*      supplied by spitbol itself. v.v are digits giving the
*      major version number and generally at least a minor
*      version number relating to osint should be supplied to
*      give say
*           macro spitbol version v.v(m.m)
*      the second string should identify at least the machine
*      and operating system.  preferably it should include
*      the date and time of the run.
*      optionally the strings may include site name of the
*      the implementor and/or machine on which run takes place,
*      unique site or copy number and other information as
*      appropriate without making it so long as to be a
*      nuisance to users.
*      the first words of the scblks pointed at need not be
*      correctly set.
*      jsr  sysid            call for system identification
*      (xr)                  scblk ptr for addition to header
*      (xl)                  scblk ptr for second header
{{ejc{{{{{1230
*      sysif -- switch to new include file
{sysif{exp{1,1{{{define external entry point{1235
*      sysif is used for include file processing, both to inform
*      the interface when a new include file is desired, and
*      when the end of file of an include file has been reached
*      and it is desired to return to reading from the previous
*      nested file.
*      it is the responsibility of sysif to remember the file
*      access path to the present input file before switching to
*      the new include file.
*      (xl)                  ptr to scblk or zero
*      (xr)                  ptr to vacant scblk of length cswin
*                            (xr not used if xl is zero)
*      jsr  sysif            call to change files
*      ppm  loc              unable to open file
*      (xr)                  scblk with full path name of file
*                            (xr not used if input xl is zero)
*      register xl points to an scblk containing the name of the
*      include file to which the interface should switch.  data
*      is fetched from the file upon the next call to sysrd.
*      sysif may have the ability to search multiple libraries
*      for the include file named in (xl).  it is therefore
*      required that the full path name of the file where the
*      file was finally located be returned in (xr).  it is this
*      name that is recorded along with the source statements,
*      and will accompany subsequent error messages.
*      register xl is zero to mark conclusion of use of an
*      include file.
{{ejc{{{{{1268
*      sysil -- get input record length
{sysil{exp{1,0{{{define external entry point{1273
*      sysil is used to get the length of the next input record
*      from a file previously input associated with a sysio
*      call. the length returned is used to establish a buffer
*      for a subsequent sysin call.  sysil also indicates to the
*      caller if this is a binary or text file.
*      (wa)                  ptr to fcblk or zero
*      jsr  sysil            call to get record length
*      (wa)                  length or zero if file closed
*      (wc)                  zero if binary, non-zero if text
*      no harm is done if the value returned is too long since
*      unused space will be reclaimed after the sysin call.
*      note that it is the sysil call (not the sysio call) which
*      causes the file to be opened as required for the first
*      record input from the file.
{{ejc{{{{{1292
*      sysin -- read input record
{sysin{exp{1,3{{{define external entry point{1296
*      sysin is used to read a record from the file which was
*      referenced in a prior call to sysil (i.e. these calls
*      always occur in pairs). the buffer provided is an
*      scblk for a string of length set from the sysil call.
*      if the actual length read is less than this, the length
*      field of the scblk must be modified before returning
*      unless buffer is right padded with zeroes.
*      it is also permissible to take any of the alternative
*      returns after scblk length has been modified.
*      (wa)                  ptr to fcblk or zero
*      (xr)                  pointer to buffer (scblk ptr)
*      jsr  sysin            call to read record
*      ppm  loc              endfile or no i/p file after sysxi
*      ppm  loc              return here if i/o error
*      ppm  loc              return here if record format error
*      (wa,wb,wc)            destroyed
{{ejc{{{{{1315
*      sysio -- input/output file association
{sysio{exp{1,2{{{define external entry point{1319
*      see also sysfc.
*      sysio is called in response to a snobol4 input or output
*      function call except when file arg1 and file arg2
*      are both null.
*      its call always follows immediately after a call
*      of sysfc. if sysfc requested allocation
*      of an fcblk, its address will be in wa.
*      for input files, non-zero values of _r_ should be
*      copied to wc for use in allocating input buffers. if _r_
*      is defaulted or not implemented, wc should be zeroised.
*      once a file has been opened, subsequent input(),output()
*      calls in which the second argument is identical with that
*      in a previous call, merely associate the additional
*      variable name (first argument) to the file and do not
*      result in re-opening the file.
*      in subsequent associated accesses to the file a pointer
*      to any fcblk allocated will be made available.
*      (xl)                  file arg1 scblk ptr (2nd arg)
*      (xr)                  file arg2 scblk ptr (3rd arg)
*      (wa)                  fcblk ptr (0 if none)
*      (wb)                  0 for input, 3 for output
*      jsr  sysio            call to associate file
*      ppm  loc              return here if file does not exist
*      ppm  loc              return if input/output not allowed
*      (xl)                  fcblk pointer (0 if none)
*      (wc)                  0 (for default) or max record lngth
*      (wa,wb)               destroyed
*      the second error return is used if the file named exists
*      but input/output from the file is not allowed. for
*      example, the standard output file may be in this category
*      as regards input association.
{{ejc{{{{{1354
*      sysld -- load external function
{sysld{exp{1,3{{{define external entry point{1358
*      sysld is called in response to the use of the snobol4
*      load function. the named function is loaded (whatever
*      this means), and a pointer is returned. the pointer will
*      be used on subsequent calls to the function (see sysex).
*      (xr)                  pointer to function name (scblk)
*      (xl)                  pointer to library name (scblk)
*      jsr  sysld            call to load function
*      ppm  loc              return here if func does not exist
*      ppm  loc              return here if i/o error
*      ppm  loc              return here if insufficient memory
*      (xr)                  pointer to loaded code
*      the significance of the pointer returned is up to the
*      system interface routine. the only restriction is that
*      if the pointer is within dynamic storage, it must be
*      a proper block pointer.
{{ejc{{{{{1377
*      sysmm -- get more memory
{sysmm{exp{1,0{{{define external entry point{1381
*      sysmm is called in an attempt to allocate more dynamic
*      memory. this memory must be allocated contiguously with
*      the current dynamic data area.
*      the amount allocated is up to the system to decide. any
*      value is acceptable including zero if allocation is
*      impossible.
*      jsr  sysmm            call to get more memory
*      (xr)                  number of additional words obtained
{{ejc{{{{{1393
*      sysmx -- supply mxlen
{sysmx{exp{1,0{{{define external entry point{1397
*      because of the method of garbage collection, no spitbol
*      object is allowed to occupy more bytes of memory than
*      the integer giving the lowest address of dynamic
*      (garbage collectable) memory. mxlen is the name used to
*      refer to this maximum length of an object and for most
*      users of most implementations, provided dynamic memory
*      starts at an address of at least a few thousand words,
*      there is no problem.
*      if the default starting address is less than say 10000 or
*      20000, then a load time option should be provided where a
*      user can request that he be able to create larger
*      objects. this routine informs spitbol of this request if
*      any. the value returned is either an integer
*      representing the desired value of mxlen (and hence the
*      minimum dynamic store address which may result in
*      non-use of some store) or zero if a default is acceptable
*      in which mxlen is set to the lowest address allocated
*      to dynamic store before compilation starts.
*      if a non-zero value is returned, this is used for keyword
*      maxlngth. otherwise the initial low address of dynamic
*      memory is used for this keyword.
*      jsr  sysmx            call to get mxlen
*      (wa)                  either mxlen or 0 for default
{{ejc{{{{{1423
*      sysou -- output record
{sysou{exp{1,2{{{define external entry point{1427
*      sysou is used to write a record to a file previously
*      associated with a sysio call.
*      (wa)                  ptr to fcblk
*                            or 0 for terminal or 1 for output
*      (xr)                  record to be written (scblk)
*      jsr  sysou            call to output record
*      ppm  loc              file full or no file after sysxi
*      ppm  loc              return here if i/o error
*      (wa,wb,wc)            destroyed
*      note that it is the sysou call (not the sysio call) which
*      causes the file to be opened as required for the first
*      record output to the file.
{{ejc{{{{{1449
*      syspi -- print on interactive channel
{syspi{exp{1,1{{{define external entry point{1453
*      if spitbol is run from an online terminal, osint can
*      request that messages such as copies of compilation
*      errors be sent to the terminal (see syspp). if relevant
*      reply was made by syspp then syspi is called to send such
*      messages to the interactive channel.
*      syspi is also used for sending output to the terminal
*      through the special variable name, terminal.
*      (xr)                  ptr to line buffer (scblk)
*      (wa)                  line length
*      jsr  syspi            call to print line
*      ppm  loc              failure return
*      (wa,wb)               destroyed
{{ejc{{{{{1469
*      syspl -- provide interactive control of spitbol
{syspl{exp{1,3{{{define external entry point{1473
*      provides means for interface to take special actions,
*      such as interrupting execution, breakpointing, stepping,
*      and expression evaluation.  these last three options are
*      not presently implemented by the code calling syspl.
*      (wa)                  opcode as follows-
*                            =0 poll to allow osint to interrupt
*                            =1 breakpoint hit
*                            =2 completion of statement stepping
*                            =3 expression evaluation result
*      (wb)                  statement number
*      r_fcb                 o or ptr to head of fcblk chain
*      jsr  syspl            call to syspl function
*      ppm  loc              user interruption
*      ppm  loc              step one statement
*      ppm  loc              evaluate expression
*      ---                   resume execution
*                            (wa) = new polling interval
{{ejc{{{{{1496
*      syspp -- obtain print parameters
{syspp{exp{1,0{{{define external entry point{1500
*      syspp is called once during compilation to obtain
*      parameters required for correct printed output format
*      and to select other options. it may also be called again
*      after sysxi when a load module is resumed. in this
*      case the value returned in wa may be less than or equal
*      to that returned in initial call but may not be
*      greater.
*      the information returned is -
*      1.   line length in chars for standard print file
*      2.   no of lines/page. 0 is preferable for a non-paged
*           device (e.g. online terminal) in which case listing
*           page throws are suppressed and page headers
*           resulting from -title,-stitl lines are kept short.
*      3.   an initial -nolist option to suppress listing unless
*           the program contains an explicit -list.
*      4.   options to suppress listing of compilation and/or
*           execution stats (useful for established programs) -
*           combined with 3. gives possibility of listing
*           file never being opened.
*      5.   option to have copies of errors sent to an
*           interactive channel in addition to standard printer.
*      6.   option to keep page headers short (e.g. if listing
*           to an online terminal).
*      7.   an option to choose extended or compact listing
*           format. in the former a page eject and in the latter
*           a few line feeds precede the printing of each
*           of-- listing, compilation statistics, execution
*           output and execution statistics.
*      8.   an option to suppress execution as though a
*           -noexecute card were supplied.
*      9.   an option to request that name /terminal/  be pre-
*           associated to an online terminal via syspi and sysri
*      10.  an intermediate (standard) listing option requiring
*           that page ejects occur in source listings. redundant
*           if extended option chosen but partially extends
*           compact option.
*      11.  option to suppress sysid identification.
*      jsr  syspp            call to get print parameters
*      (wa)                  print line length in chars
*      (wb)                  number of lines/page
*      (wc)                  bits value ...mlkjihgfedcba where
*                            a = 1 to send error copy to int.ch.
*                            b = 1 means std printer is int. ch.
*                            c = 1 for -nolist option
*                            d = 1 to suppress compiln. stats
*                            e = 1 to suppress execn. stats
*                            f = 1/0 for extnded/compact listing
*                            g = 1 for -noexecute
*                            h = 1 pre-associate /terminal/
*                            i = 1 for standard listing option.
*                            j = 1 suppresses listing header
*                            k = 1 for -print
*                            l = 1 for -noerrors
{{ejc{{{{{1562
*      syspr -- print line on standard output file
{syspr{exp{1,1{{{define external entry point{1566
*      syspr is used to print a single line on the standard
*      output file.
*      (xr)                  pointer to line buffer (scblk)
*      (wa)                  line length
*      jsr  syspr            call to print line
*      ppm  loc              too much o/p or no file after sysxi
*      (wa,wb)               destroyed
*      the buffer pointed to is the length obtained from the
*      syspp call and is filled out with trailing blanks. the
*      value in wa is the actual line length which may be less
*      than the maximum line length possible. there is no space
*      control associated with the line, all lines are printed
*      single spaced. note that null lines (wa=0) are possible
*      in which case a blank line is to be printed.
*      the error exit is used for systems which limit the amount
*      of printed output. if possible, printing should be
*      permitted after this condition has been signalled once to
*      allow for dump and other diagnostic information.
*      assuming this to be possible, spitbol may make more syspr
*      calls. if the error return occurs another time, execution
*      is terminated by a call of sysej with ending code 998.
{{ejc{{{{{1592
*      sysrd -- read record from standard input file
{sysrd{exp{1,1{{{define external entry point{1596
*      sysrd is used to read a record from the standard input
*      file. the buffer provided is an scblk for a string the
*      length of which in characters is given in wc, this
*      corresponding to the maximum length of string which
*      spitbol is prepared to receive. at compile time it
*      corresponds to xxx in the most recent -inxxx card
*      (default 72) and at execution time to the most recent
*      ,r_r_ (record length) in the third arg of an input()
*      statement for the standard input file (default 80).
*      if fewer than (wc) characters are read, the length
*      field of the scblk must be adjusted before returning
*      unless the buffer is right padded with zeroes.
*      it is also permissible to take the alternative return
*      after such an adjustment has been made.
*      spitbol may continue to make calls after an endfile
*      return so this routine should be prepared to make
*      repeated endfile returns.
*      (xr)                  pointer to buffer (scblk ptr)
*      (wc)                  length of buffer in characters
*      jsr  sysrd            call to read line
*      ppm  loc              endfile or no i/p file after sysxi
*                            or input file name change.  if
*                            the former, scblk length is zero.
*                            if input file name change, length
*                            is non-zero. caller should re-issue
*                            sysrd to obtain input record.
*      (wa,wb,wc)            destroyed
{{ejc{{{{{1628
*      sysri -- read record from interactive channel
{sysri{exp{1,1{{{define external entry point{1632
*      reads a record from online terminal for spitbol variable,
*      terminal. if online terminal is unavailable then code the
*      endfile return only.
*      the buffer provided is of length 258 characters. sysri
*      should replace the count in the second word of the scblk
*      by the actual character count unless buffer is right
*      padded with zeroes.
*      it is also permissible to take the alternative
*      return after adjusting the count.
*      the end of file return may be used if this makes
*      sense on the target machine (e.g. if there is an
*      eof character.)
*      (xr)                  ptr to 258 char buffer (scblk ptr)
*      jsr  sysri            call to read line from terminal
*      ppm  loc              end of file return
*      (wa,wb,wc)            may be destroyed
{{ejc{{{{{1651
*      sysrw -- rewind file
{sysrw{exp{1,3{{{define external entry point{1655
*      sysrw is used to rewind a file i.e. reposition the file
*      at the start before the first record. the file should be
*      closed and the next read or write call will open the
*      file at the start.
*      (wa)                  ptr to fcblk or zero
*      (xr)                  rewind arg (scblk ptr)
*      jsr  sysrw            call to rewind file
*      ppm  loc              return here if file does not exist
*      ppm  loc              return here if rewind not allowed
*      ppm  loc              return here if i/o error
{{ejc{{{{{1668
*      systm -- get execution time so far
{systm{exp{1,0{{{define external entry point{1695
*      systm is used to obtain the amount of execution time
*      used so far since spitbol was given control. the units
*      are described as microseconds in the spitbol output, but
*      the exact meaning is system dependent. where appropriate,
*      this value should relate to processor rather than clock
*      timing values.
*      if the symbol .ctmd is defined, the units are described
*      as deciseconds (0.1 second).
*      jsr  systm            call to get timer value
*      (ia)                  time so far in micliseconds
*                            (deciseconds if .ctmd defined)
{{ejc{{{{{1709
*      systt -- trace toggle
{systt{exp{1,0{{{define external entry point{1713
*      called by spitbol function trace() with no args to
*      toggle the system trace switch.  this permits tracing of
*      labels in spitbol code to be turned on or off.
*      jsr  systt            call to toggle trace switch
{{ejc{{{{{1720
*      sysul -- unload external function
{sysul{exp{1,0{{{define external entry point{1724
*      sysul is used to unload a function previously
*      loaded with a call to sysld.
*      (xr)                  ptr to control block (efblk)
*      jsr  sysul            call to unload function
*      the function cannot be called following a sysul call
*      until another sysld call is made for the same function.
*      the efblk contains the function code pointer and also a
*      pointer to the vrblk containing the function name (see
*      definitions and data structures section).
{{ejc{{{{{1740
*      sysxi -- exit to produce load module
{sysxi{exp{1,2{{{define external entry point{1744
*      when sysxi is called, xl contains either a string pointer
*      or zero. in the former case, the string gives the
*      character name of a program. the intention is that
*      spitbol execution should be terminated forthwith and
*      the named program loaded and executed. this type of chain
*      execution is very system dependent and implementors may
*      choose to omit it or find it impossible to provide.
*      if (xl) is zero,ia contains one of the following integers
*      -1, -2, -3, -4
*           create if possible a load module containing only the
*           impure area of memory which needs to be loaded with
*           a compatible pure segment for subsequent executions.
*           version numbers to check compatibility should be
*           kept in both segments and checked on loading.
*           to assist with this check, (xr) on entry is a
*           pointer to an scblk containing the spitbol major
*           version number v.v (see sysid).  the file thus
*           created is called a save file.
*      0    if possible, return control to job control
*           command level. the effect if available will be
*           system dependent.
*      +1, +2, +3, +4
*           create if possible a load module from all of
*           memory. it should be possible to load and execute
*           this module directly.
*      in the case of saved load modules, the status of open
*      files is not preserved and implementors may choose to
*      offer means of attaching files before execution of load
*      modules starts or leave it to the user to include
*      suitable input(), output() calls in his program.
*      sysxi should make a note that no i/o channels,
*      including standard files, have files attached so that
*      calls of sysin, sysou, syspr, sysrd should fail unless
*      new associations are made for the load module.
*      at least in the case of the standard output file, it is
*      recommended that either the user be required to attach
*      a file or that a default file is attached, since the
*      problem of error messages generated by the load module
*      is otherwise severe. as a last resort, if spitbol
*      attempts to write to the standard output file and gets a
*      reply indicating that such ouput is unacceptable it stops
*      by using an entry to sysej with ending code 998.
*      as described below, passing of some arguments makes it
*      clear that load module will use a standard output file.
*      if use is made of fcblks for i/o association, spitbol
*      builds a chain so that those in use may be found in sysxi
*      and sysej. the nodes are 4 words long. third word
*      contains link to next node or 0, fourth word contains
*      fcblk pointer.
{{ejc{{{{{1800
*      sysxi (continued)
*      (xl)                  zero or scblk ptr to first argument
*      (xr)                  ptr to v.v scblk
*      (ia)                  signed integer argument
*      (wa)                  scblk ptr to second argument
*      (wb)                  0 or ptr to head of fcblk chain
*      jsr  sysxi            call to exit
*      ppm  loc              requested action not possible
*      ppm  loc              action caused irrecoverable error
*      (wb,wc,ia,xr,xl,cp)   should be preserved over call
*      (wa)                  0 in all cases except sucessful
*                            performance of exit(4) or exit(-4),
*                            in which case 1 should be returned.
*      loading and running the load module or returning from
*      jcl command level causes execution to resume at the point
*      after the error returns which follow the call of sysxi.
*      the value passed as exit argument is used to indicate
*      options required on resumption of load module.
*      +1 or -1 require that on resumption, sysid and syspp be
*      called and a heading printed on the standard output file.
*      +2 or -2 indicate that syspp will be called but not sysid
*      and no heading will be put on standard output file.
*      above options have the obvious implication that a
*      standard o/p file must be provided for the load module.
*      +3, +4, -3 or -4 indicate calls of neither sysid nor
*      syspp and no heading will be placed on standard output
*      file.
*      +4 or -4 indicate that execution is to continue after
*      creation of the save file or load module, although all
*      files will be closed by the sysxi action.  this permits
*      the user to checkpoint long-running programs while
*      continuing execution.
*      no return from sysxi is possible if another program
*      is loaded and entered.
{{ejc{{{{{1840
*      introduce the internal procedures.
{acess{inp{25,r{1,1{{{1844
{acomp{inp{25,n{1,5{{{1845
{alloc{inp{25,e{1,0{{{1846
{alocs{inp{25,e{1,0{{{1851
{alost{inp{25,e{1,0{{{1852
{arith{inp{25,n{1,3{{{1860
{asign{inp{25,r{1,1{{{1862
{asinp{inp{25,r{1,1{{{1863
{blkln{inp{25,e{1,0{{{1864
{cdgcg{inp{25,e{1,0{{{1865
{cdgex{inp{25,r{1,0{{{1866
{cdgnm{inp{25,r{1,0{{{1867
{cdgvl{inp{25,r{1,0{{{1868
{cdwrd{inp{25,e{1,0{{{1869
{cmgen{inp{25,r{1,0{{{1870
{cmpil{inp{25,e{1,0{{{1871
{cncrd{inp{25,e{1,0{{{1872
{copyb{inp{25,n{1,1{{{1873
{dffnc{inp{25,e{1,0{{{1874
{dtach{inp{25,e{1,0{{{1875
{dtype{inp{25,e{1,0{{{1876
{dumpr{inp{25,e{1,0{{{1877
{ermsg{inp{25,e{1,0{{{1882
{ertex{inp{25,e{1,0{{{1883
{evali{inp{25,r{1,4{{{1884
{evalp{inp{25,r{1,1{{{1885
{evals{inp{25,r{1,3{{{1886
{evalx{inp{25,r{1,1{{{1887
{exbld{inp{25,e{1,0{{{1888
{expan{inp{25,e{1,0{{{1889
{expap{inp{25,e{1,1{{{1890
{expdm{inp{25,n{1,0{{{1891
{expop{inp{25,n{1,0{{{1892
{filnm{inp{25,e{1,0{{{1894
{gbcol{inp{25,e{1,0{{{1899
{gbcpf{inp{25,e{1,0{{{1900
{gtarr{inp{25,e{1,2{{{1901
{{ejc{{{{{1902
{gtcod{inp{25,e{1,1{{{1903
{gtexp{inp{25,e{1,1{{{1904
{gtint{inp{25,e{1,1{{{1905
{gtnum{inp{25,e{1,1{{{1906
{gtnvr{inp{25,e{1,1{{{1907
{gtpat{inp{25,e{1,1{{{1908
{gtrea{inp{25,e{1,1{{{1911
{gtsmi{inp{25,n{1,2{{{1913
{gtstg{inp{25,n{1,1{{{1918
{gtvar{inp{25,e{1,1{{{1919
{hashs{inp{25,e{1,0{{{1920
{icbld{inp{25,e{1,0{{{1921
{ident{inp{25,e{1,1{{{1922
{inout{inp{25,e{1,0{{{1923
{insta{inp{25,e{1,0{{{1928
{iofcb{inp{25,n{1,3{{{1929
{ioppf{inp{25,n{1,0{{{1930
{ioput{inp{25,n{1,7{{{1931
{ktrex{inp{25,r{1,0{{{1932
{kwnam{inp{25,n{1,0{{{1933
{lcomp{inp{25,n{1,5{{{1934
{listr{inp{25,e{1,0{{{1935
{listt{inp{25,e{1,0{{{1936
{newfn{inp{25,e{1,0{{{1938
{nexts{inp{25,e{1,0{{{1940
{patin{inp{25,n{1,2{{{1941
{patst{inp{25,n{1,1{{{1942
{pbild{inp{25,e{1,0{{{1943
{pconc{inp{25,e{1,0{{{1944
{pcopy{inp{25,n{1,0{{{1945
{prflr{inp{25,e{1,0{{{1948
{prflu{inp{25,e{1,0{{{1949
{prpar{inp{25,e{1,0{{{1951
{prtch{inp{25,e{1,0{{{1952
{prtic{inp{25,e{1,0{{{1953
{prtis{inp{25,e{1,0{{{1954
{prtin{inp{25,e{1,0{{{1955
{prtmi{inp{25,e{1,0{{{1956
{prtmm{inp{25,e{1,0{{{1957
{prtmx{inp{25,e{1,0{{{1958
{prtnl{inp{25,r{1,0{{{1959
{prtnm{inp{25,r{1,0{{{1960
{prtnv{inp{25,e{1,0{{{1961
{prtpg{inp{25,e{1,0{{{1962
{prtps{inp{25,e{1,0{{{1963
{prtsn{inp{25,e{1,0{{{1964
{prtst{inp{25,r{1,0{{{1965
{{ejc{{{{{1966
{prttr{inp{25,e{1,0{{{1967
{prtvl{inp{25,r{1,0{{{1968
{prtvn{inp{25,e{1,0{{{1969
{rcbld{inp{25,e{1,0{{{1972
{readr{inp{25,e{1,0{{{1974
{relaj{inp{25,e{1,0{{{1976
{relcr{inp{25,e{1,0{{{1977
{reldn{inp{25,e{1,0{{{1978
{reloc{inp{25,e{1,0{{{1979
{relst{inp{25,e{1,0{{{1980
{relws{inp{25,e{1,0{{{1981
{rstrt{inp{25,e{1,0{{{1983
{sbstr{inp{25,e{1,0{{{1987
{scane{inp{25,e{1,0{{{1988
{scngf{inp{25,e{1,0{{{1989
{setvr{inp{25,e{1,0{{{1990
{sorta{inp{25,n{1,1{{{1993
{sortc{inp{25,e{1,1{{{1994
{sortf{inp{25,e{1,0{{{1995
{sorth{inp{25,n{1,0{{{1996
{start{inp{25,e{1,0{{{1998
{stgcc{inp{25,e{1,0{{{1999
{tfind{inp{25,e{1,1{{{2000
{tmake{inp{25,e{1,0{{{2001
{trace{inp{25,n{1,2{{{2002
{trbld{inp{25,e{1,0{{{2003
{trimr{inp{25,e{1,0{{{2004
{trxeq{inp{25,r{1,0{{{2005
{vmake{inp{25,e{1,1{{{2006
{xscan{inp{25,e{1,0{{{2007
{xscni{inp{25,n{1,2{{{2008
*      introduce the internal routines
{arref{inr{{{{{2012
{cfunc{inr{{{{{2013
{exfal{inr{{{{{2014
{exint{inr{{{{{2015
{exits{inr{{{{{2016
{exixr{inr{{{{{2017
{exnam{inr{{{{{2018
{exnul{inr{{{{{2019
{exrea{inr{{{{{2022
{exsid{inr{{{{{2024
{exvnm{inr{{{{{2025
{failp{inr{{{{{2026
{flpop{inr{{{{{2027
{indir{inr{{{{{2028
{match{inr{{{{{2029
{retrn{inr{{{{{2030
{stcov{inr{{{{{2031
{stmgo{inr{{{{{2032
{stopr{inr{{{{{2033
{succp{inr{{{{{2034
{sysab{inr{{{{{2035
{systu{inr{{{{{2036
{{ttl{27,s p i t b o l -- definitions and data structures{{{{2037
*      this section contains all symbol definitions and also
*      pictures of all data structures used in the system.
{{sec{{{{start of definitions section{2041
*      definitions of machine parameters
*      the minimal translator should supply appropriate values
*      for the particular target machine for all the
*      equ  *
*      definitions given at the start of this section.
*      note that even if conditional assembly is used to omit
*      some feature (e.g. real arithmetic) a full set of cfp_-
*      values must be supplied. use dummy values if genuine
*      ones are not needed.
{cfp_a{equ{24,256{{{number of characters in alphabet{2054
{cfp_b{equ{24,8{{{bytes/word addressing factor{2056
{cfp_c{equ{24,8{{{number of characters per word{2058
{cfp_f{equ{24,16{{{offset in bytes to chars in{2060
*                            scblk. see scblk format.
{cfp_i{equ{24,1{{{number of words in integer constant{2063
{cfp_m{equ{24,9223372036854775807{{{max positive integer in one word{2065
{cfp_n{equ{24,64{{{number of bits in one word{2067
*      the following definitions require the supply of either
*      a single parameter if real arithmetic is omitted or
*      three parameters if real arithmetic is included.
{cfp_r{equ{24,1{{{number of words in real constant{2077
{cfp_s{equ{24,9{{{number of sig digs for real output{2079
{cfp_x{equ{24,3{{{max digits in real exponent{2081
{mxdgs{equ{24,cfp_s+cfp_x{{{max digits in real number{2092
*      max space for real (for +0.e+) needs five more places
{nstmx{equ{24,mxdgs+5{{{max space for real{2097
*      the following definition for cfp_u supplies a realistic
*      upper bound on the size of the alphabet.  cfp_u is used
*      to save space in the scane bsw-iff-esw table and to ease
*      translation storage requirements.
{cfp_u{equ{24,128{{{realistic upper bound on alphabet{2107
{{ejc{{{{{2109
*      environment parameters
*      the spitbol program is essentially independent of
*      the definitions of these parameters. however, the
*      efficiency of the system may be affected. consequently,
*      these parameters may require tuning for a given version
*      the values given in comments have been successfully used.
*      e_srs is the number of words to reserve at the end of
*      storage for end of run processing. it should be
*      set as small as possible without causing memory overflow
*      in critical situations (e.g. memory overflow termination)
*      and should thus reserve sufficient space at least for
*      an scblk containing say 30 characters.
{e_srs{equ{24,100{{{30 words{2126
*      e_sts is the number of words grabbed in a chunk when
*      storage is allocated in the static region. the minimum
*      permitted value is 256/cfp_b. larger values will lead
*      to increased efficiency at the cost of wasting memory.
{e_sts{equ{24,1000{{{500 words{2133
*      e_cbs is the size of code block allocated initially and
*      the expansion increment if overflow occurs. if this value
*      is too small or too large, excessive garbage collections
*      will occur during compilation and memory may be lost
*      in the case of a too large value.
{e_cbs{equ{24,500{{{500 words{2141
*      e_hnb is the number of bucket headers in the variable
*      hash table. it should always be odd. larger values will
*      speed up compilation and indirect references at the
*      expense of additional storage for the hash table itself.
{e_hnb{equ{24,257{{{127 bucket headers{2148
*      e_hnw is the maximum number of words of a string
*      name which participate in the string hash algorithm.
*      larger values give a better hash at the expense of taking
*      longer to compute the hash. there is some optimal value.
{e_hnw{equ{24,3{{{6 words{2155
*      e_fsp.  if the amount of free space left after a garbage
*      collection is small compared to the total amount of space
*      in use garbage collector thrashing is likely to occur as
*      this space is used up.  e_fsp is a measure of the
*      minimum percentage of dynamic memory left as free space
*      before the system routine sysmm is called to try to
*      obtain more memory.
{e_fsp{equ{24,15{{{15 percent{2165
*      e_sed.  if the amount of free space left in the sediment
*      after a garbage collection is a significant fraction of
*      the new sediment size, the sediment is marked for
*      collection on the next call to the garbage collector.
{e_sed{equ{24,25{{{25 percent{2173
{{ejc{{{{{2175
*      definitions of codes for letters
{ch_la{equ{24,97{{{letter a{2179
{ch_lb{equ{24,98{{{letter b{2180
{ch_lc{equ{24,99{{{letter c{2181
{ch_ld{equ{24,100{{{letter d{2182
{ch_le{equ{24,101{{{letter e{2183
{ch_lf{equ{24,102{{{letter f{2184
{ch_lg{equ{24,103{{{letter g{2185
{ch_lh{equ{24,104{{{letter h{2186
{ch_li{equ{24,105{{{letter i{2187
{ch_lj{equ{24,106{{{letter j{2188
{ch_lk{equ{24,107{{{letter k{2189
{ch_ll{equ{24,108{{{letter l{2190
{ch_lm{equ{24,109{{{letter m{2191
{ch_ln{equ{24,110{{{letter n{2192
{ch_lo{equ{24,111{{{letter o{2193
{ch_lp{equ{24,112{{{letter p{2194
{ch_lq{equ{24,113{{{letter q{2195
{ch_lr{equ{24,114{{{letter r{2196
{ch_ls{equ{24,115{{{letter s{2197
{ch_lt{equ{24,116{{{letter t{2198
{ch_lu{equ{24,117{{{letter u{2199
{ch_lv{equ{24,118{{{letter v{2200
{ch_lw{equ{24,119{{{letter w{2201
{ch_lx{equ{24,120{{{letter x{2202
{ch_ly{equ{24,121{{{letter y{2203
{ch_l_{equ{24,122{{{letter z{2204
*      definitions of codes for digits
{ch_d0{equ{24,48{{{digit 0{2208
{ch_d1{equ{24,49{{{digit 1{2209
{ch_d2{equ{24,50{{{digit 2{2210
{ch_d3{equ{24,51{{{digit 3{2211
{ch_d4{equ{24,52{{{digit 4{2212
{ch_d5{equ{24,53{{{digit 5{2213
{ch_d6{equ{24,54{{{digit 6{2214
{ch_d7{equ{24,55{{{digit 7{2215
{ch_d8{equ{24,56{{{digit 8{2216
{ch_d9{equ{24,57{{{digit 9{2217
{{ejc{{{{{2218
*      definitions of codes for special characters
*      the names of these characters are related to their
*      original representation in the ebcdic set corresponding
*      to the description in standard snobol4 manuals and texts.
{ch_am{equ{24,38{{{keyword operator (ampersand){2226
{ch_as{equ{24,42{{{multiplication symbol (asterisk){2227
{ch_at{equ{24,64{{{cursor position operator (at){2228
{ch_bb{equ{24,60{{{left array bracket (less than){2229
{ch_bl{equ{24,32{{{blank{2230
{ch_br{equ{24,124{{{alternation operator (vertical bar){2231
{ch_cl{equ{24,58{{{goto symbol (colon){2232
{ch_cm{equ{24,44{{{comma{2233
{ch_dl{equ{24,36{{{indirection operator (dollar){2234
{ch_dt{equ{24,46{{{name operator (dot){2235
{ch_dq{equ{24,34{{{double quote{2236
{ch_eq{equ{24,61{{{equal sign{2237
{ch_ex{equ{24,33{{{exponentiation operator (exclm){2238
{ch_mn{equ{24,45{{{minus sign / hyphen{2239
{ch_nm{equ{24,35{{{number sign{2240
{ch_nt{equ{24,126{{{negation operator (not){2241
{ch_pc{equ{24,94{{{percent{2242
{ch_pl{equ{24,43{{{plus sign{2243
{ch_pp{equ{24,40{{{left parenthesis{2244
{ch_rb{equ{24,62{{{right array bracket (grtr than){2245
{ch_rp{equ{24,41{{{right parenthesis{2246
{ch_qu{equ{24,63{{{interrogation operator (question){2247
{ch_sl{equ{24,47{{{slash{2248
{ch_sm{equ{24,59{{{semicolon{2249
{ch_sq{equ{24,39{{{single quote{2250
{ch_u_{equ{24,95{{{special identifier char (underline){2251
{ch_ob{equ{24,91{{{opening bracket{2252
{ch_cb{equ{24,93{{{closing bracket{2253
{{ejc{{{{{2254
*      remaining chars are optional additions to the standards.
*      tab characters - syntactically equivalent to blank
{ch_ht{equ{24,9{{{horizontal tab{2261
*      upper case or shifted case alphabetic chars
{ch_ua{equ{24,65{{{shifted a{2276
{ch_ub{equ{24,66{{{shifted b{2277
{ch_uc{equ{24,67{{{shifted c{2278
{ch_ud{equ{24,68{{{shifted d{2279
{ch_ue{equ{24,69{{{shifted e{2280
{ch_uf{equ{24,70{{{shifted f{2281
{ch_ug{equ{24,71{{{shifted g{2282
{ch_uh{equ{24,72{{{shifted h{2283
{ch_ui{equ{24,73{{{shifted i{2284
{ch_uj{equ{24,74{{{shifted j{2285
{ch_uk{equ{24,75{{{shifted k{2286
{ch_ul{equ{24,76{{{shifted l{2287
{ch_um{equ{24,77{{{shifted m{2288
{ch_un{equ{24,78{{{shifted n{2289
{ch_uo{equ{24,79{{{shifted o{2290
{ch_up{equ{24,80{{{shifted p{2291
{ch_uq{equ{24,81{{{shifted q{2292
{ch_ur{equ{24,82{{{shifted r{2293
{ch_us{equ{24,83{{{shifted s{2294
{ch_ut{equ{24,84{{{shifted t{2295
{ch_uu{equ{24,85{{{shifted u{2296
{ch_uv{equ{24,86{{{shifted v{2297
{ch_uw{equ{24,87{{{shifted w{2298
{ch_ux{equ{24,88{{{shifted x{2299
{ch_uy{equ{24,89{{{shifted y{2300
{ch_uz{equ{24,90{{{shifted z{2301
*      if a delimiter other than ch_cm must be used in
*      the third argument of input(),output() then .ciod should
*      be defined and a parameter supplied for iodel.
{iodel{equ{24,32{{{{2308
{{ejc{{{{{2312
*      data block formats and definitions
*      the following sections describe the detailed format of
*      all possible data blocks in static and dynamic memory.
*      every block has a name of the form xxblk where xx is a
*      unique two character identifier. the first word of every
*      block must contain a pointer to a program location in the
*      interpretor which is immediately preceded by an address
*      constant containing the value bl_xx where xx is the block
*      identifier. this provides a uniform mechanism for
*      distinguishing between the various block types.
*      in some cases, the contents of the first word is constant
*      for a given block type and merely serves as a pointer
*      to the identifying address constant. however, in other
*      cases there are several possibilities for the first
*      word in which case each of the several program entry
*      points must be preceded by the appropriate constant.
*      in each block, some of the fields are relocatable. this
*      means that they may contain a pointer to another block
*      in the dynamic area. (to be more precise, if they contain
*      a pointer within the dynamic area, then it is a pointer
*      to a block). such fields must be modified by the garbage
*      collector (procedure gbcol) whenever blocks are compacted
*      in the dynamic region. the garbage collector (actually
*      procedure gbcpf) requires that all such relocatable
*      fields in a block must be contiguous.
{{ejc{{{{{2343
*      the description format uses the following scheme.
*      1)   block title and two character identifier
*      2)   description of basic use of block and indication
*           of circumstances under which it is constructed.
*      3)   picture of the block format. in these pictures low
*           memory addresses are at the top of the page. fixed
*           length fields are surrounded by i (letter i). fields
*           which are fixed length but whose length is dependent
*           on a configuration parameter are surrounded by *
*           (asterisk). variable length fields are surrounded
*           by / (slash).
*      4)   definition of symbolic offsets to fields in
*           block and of the size of the block if fixed length
*           or of the size of the fixed length fields if the
*           block is variable length.
*           note that some routines such as gbcpf assume
*           certain offsets are equal. the definitions
*           given here enforce this.  make changes to
*           them only with due care.
*      definitions of common offsets
{offs1{equ{24,1{{{{2371
{offs2{equ{24,2{{{{2372
{offs3{equ{24,3{{{{2373
*      5)   detailed comments on the significance and formats
*           of the various fields.
*      the order is alphabetical by identification code.
{{ejc{{{{{2379
*      definitions of block codes
*      this table provides a unique identification code for
*      each separate block type. the first word of a block in
*      the dynamic area always contains the address of a program
*      entry point. the block code is used as the entry point id
*      the order of these codes dictates the order of the table
*      used by the datatype function (scnmt in the constant sec)
*      block codes for accessible datatypes
*      note that real and buffer types are always included, even
*      if they are conditionally excluded elsewhere.  this main-
*      tains block type codes across all versions of spitbol,
*      providing consistancy for external functions.  but note
*      that the bcblk is out of alphabetic order, placed at the
*      end of the list so as not to change the block type
*      ordering in use in existing external functions.
{bl_ar{equ{24,0{{{arblk     array{2400
{bl_cd{equ{24,bl_ar+1{{{cdblk     code{2401
{bl_ex{equ{24,bl_cd+1{{{exblk     expression{2402
{bl_ic{equ{24,bl_ex+1{{{icblk     integer{2403
{bl_nm{equ{24,bl_ic+1{{{nmblk     name{2404
{bl_p0{equ{24,bl_nm+1{{{p0blk     pattern{2405
{bl_p1{equ{24,bl_p0+1{{{p1blk     pattern{2406
{bl_p2{equ{24,bl_p1+1{{{p2blk     pattern{2407
{bl_rc{equ{24,bl_p2+1{{{rcblk     real{2408
{bl_sc{equ{24,bl_rc+1{{{scblk     string{2409
{bl_se{equ{24,bl_sc+1{{{seblk     expression{2410
{bl_tb{equ{24,bl_se+1{{{tbblk     table{2411
{bl_vc{equ{24,bl_tb+1{{{vcblk     array{2412
{bl_xn{equ{24,bl_vc+1{{{xnblk     external{2413
{bl_xr{equ{24,bl_xn+1{{{xrblk     external{2414
{bl_bc{equ{24,bl_xr+1{{{bcblk     buffer{2415
{bl_pd{equ{24,bl_bc+1{{{pdblk     program defined datatype{2416
{bl__d{equ{24,bl_pd+1{{{number of block codes for data{2418
*      other block codes
{bl_tr{equ{24,bl_pd+1{{{trblk{2422
{bl_bf{equ{24,bl_tr+1{{{bfblk{2423
{bl_cc{equ{24,bl_bf+1{{{ccblk{2424
{bl_cm{equ{24,bl_cc+1{{{cmblk{2425
{bl_ct{equ{24,bl_cm+1{{{ctblk{2426
{bl_df{equ{24,bl_ct+1{{{dfblk{2427
{bl_ef{equ{24,bl_df+1{{{efblk{2428
{bl_ev{equ{24,bl_ef+1{{{evblk{2429
{bl_ff{equ{24,bl_ev+1{{{ffblk{2430
{bl_kv{equ{24,bl_ff+1{{{kvblk{2431
{bl_pf{equ{24,bl_kv+1{{{pfblk{2432
{bl_te{equ{24,bl_pf+1{{{teblk{2433
{bl__i{equ{24,0{{{default identification code{2435
{bl__t{equ{24,bl_tr+1{{{code for data or trace block{2436
{bl___{equ{24,bl_te+1{{{number of block codes{2437
{{ejc{{{{{2438
*      field references
*      references to the fields of data blocks are symbolic
*      (i.e. use the symbolic offsets) with the following
*      exceptions.
*      1)   references to the first word are usually not
*           symbolic since they use the (x) operand format.
*      2)   the code which constructs a block is often not
*           symbolic and should be changed if the corresponding
*           block format is modified.
*      3)   the plc and psc instructions imply an offset
*           corresponding to the definition of cfp_f.
*      4)   there are non-symbolic references (easily changed)
*           in the garbage collector (procedures gbcpf, blkln).
*      5)   the fields idval, fargs appear in several blocks
*           and any changes must be made in parallel to all
*           blocks containing the fields. the actual references
*           to these fields are symbolic with the above
*           listed exceptions.
*      6)   several spots in the code assume that the
*           definitions of the fields vrval, teval, trnxt are
*           the same (these are sections of code which search
*           out along a trblk chain from a variable).
*      7)   references to the fields of an array block in the
*           array reference routine arref are non-symbolic.
*      apart from the exceptions listed, references are symbolic
*      as far as possible and modifying the order or number
*      of fields will not require changes.
{{ejc{{{{{2476
*      common fields for function blocks
*      blocks which represent callable functions have two
*      common fields at the start of the block as follows.
*           +------------------------------------+
*           i                fcode               i
*           +------------------------------------+
*           i                fargs               i
*           +------------------------------------+
*           /                                    /
*           /       rest of function block       /
*           /                                    /
*           +------------------------------------+
{fcode{equ{24,0{{{pointer to code for function{2493
{fargs{equ{24,1{{{number of arguments{2494
*      fcode is a pointer to the location in the interpretor
*      program which processes this type of function call.
*      fargs is the expected number of arguments. the actual
*      number of arguments is adjusted to this amount by
*      deleting extra arguments or supplying trailing nulls
*      for missing ones before transferring though fcode.
*      a value of 999 may be used in this field to indicate a
*      variable number of arguments (see svblk field svnar).
*      the block types which follow this scheme are.
*      ffblk                 field function
*      dfblk                 datatype function
*      pfblk                 program defined function
*      efblk                 external loaded function
{{ejc{{{{{2512
*      identification field
*      id   field
*      certain program accessible objects (those which contain
*      other data values and can be copied) are given a unique
*      identification number (see exsid). this id value is an
*      address integer value which is always stored in word two.
{idval{equ{24,1{{{id value field{2524
*      the blocks containing an idval field are.
*      arblk                 array
*      pdblk                 program defined datatype
*      tbblk                 table
*      vcblk                 vector block (array)
*      note that a zero idval means that the block is only
*      half built and should not be dumped (see dumpr).
{{ejc{{{{{2539
*      array block (arblk)
*      an array block represents an array value other than one
*      with one dimension whose lower bound is one (see vcblk).
*      an arblk is built with a call to the functions convert
*      (s_cnv) or array (s_arr).
*           +------------------------------------+
*           i                artyp               i
*           +------------------------------------+
*           i                idval               i
*           +------------------------------------+
*           i                arlen               i
*           +------------------------------------+
*           i                arofs               i
*           +------------------------------------+
*           i                arndm               i
*           +------------------------------------+
*           *                arlbd               *
*           +------------------------------------+
*           *                ardim               *
*           +------------------------------------+
*           *                                    *
*           * above 2 flds repeated for each dim *
*           *                                    *
*           +------------------------------------+
*           i                arpro               i
*           +------------------------------------+
*           /                                    /
*           /                arvls               /
*           /                                    /
*           +------------------------------------+
{{ejc{{{{{2573
*      array block (continued)
{artyp{equ{24,0{{{pointer to dummy routine b_art{2577
{arlen{equ{24,idval+1{{{length of arblk in bytes{2578
{arofs{equ{24,arlen+1{{{offset in arblk to arpro field{2579
{arndm{equ{24,arofs+1{{{number of dimensions{2580
{arlbd{equ{24,arndm+1{{{low bound (first subscript){2581
{ardim{equ{24,arlbd+cfp_i{{{dimension (first subscript){2582
{arlb2{equ{24,ardim+cfp_i{{{low bound (second subscript){2583
{ardm2{equ{24,arlb2+cfp_i{{{dimension (second subscript){2584
{arpro{equ{24,ardim+cfp_i{{{array prototype (one dimension){2585
{arvls{equ{24,arpro+1{{{start of values (one dimension){2586
{arpr2{equ{24,ardm2+cfp_i{{{array prototype (two dimensions){2587
{arvl2{equ{24,arpr2+1{{{start of values (two dimensions){2588
{arsi_{equ{24,arlbd{{{number of standard fields in block{2589
{ardms{equ{24,arlb2-arlbd{{{size of info for one set of bounds{2590
*      the bounds and dimension fields are signed integer
*      values and each occupy cfp_i words in the arblk.
*      the length of an arblk in bytes may not exceed mxlen.
*      this is required to keep name offsets garbage collectable
*      the actual values are arranged in row-wise order and
*      can contain a data pointer or a pointer to a trblk.
{{ejc{{{{{2676
*      code construction block (ccblk)
*      at any one moment there is at most one ccblk into
*      which the compiler is currently storing code (cdwrd).
*           +------------------------------------+
*           i                cctyp               i
*           +------------------------------------+
*           i                cclen               i
*           +------------------------------------+
*           i                ccsln               i
*           +------------------------------------+
*           i                ccuse               i
*           +------------------------------------+
*           /                                    /
*           /                cccod               /
*           /                                    /
*           +------------------------------------+
{cctyp{equ{24,0{{{pointer to dummy routine b_cct{2699
{cclen{equ{24,cctyp+1{{{length of ccblk in bytes{2700
{ccsln{equ{24,cclen+1{{{source line number{2702
{ccuse{equ{24,ccsln+1{{{offset past last used word (bytes){2703
{cccod{equ{24,ccuse+1{{{start of generated code in block{2707
*      the reason that the ccblk is a separate block type from
*      the usual cdblk is that the garbage collector must
*      only process those fields which have been set (see gbcpf)
{{ejc{{{{{2712
*      code block (cdblk)
*      a code block is built for each statement compiled during
*      the initial compilation or by subsequent calls to code.
*           +------------------------------------+
*           i                cdjmp               i
*           +------------------------------------+
*           i                cdstm               i
*           +------------------------------------+
*           i                cdsln               i
*           +------------------------------------+
*           i                cdlen               i
*           +------------------------------------+
*           i                cdfal               i
*           +------------------------------------+
*           /                                    /
*           /                cdcod               /
*           /                                    /
*           +------------------------------------+
{cdjmp{equ{24,0{{{ptr to routine to execute statement{2737
{cdstm{equ{24,cdjmp+1{{{statement number{2738
{cdsln{equ{24,cdstm+1{{{source line number{2740
{cdlen{equ{24,cdsln+1{{{length of cdblk in bytes{2741
{cdfal{equ{24,cdlen+1{{{failure exit (see below){2742
{cdcod{equ{24,cdfal+1{{{executable pseudo-code{2747
{cdsi_{equ{24,cdcod{{{number of standard fields in cdblk{2748
*      cdstm is the statement number of the current statement.
*      cdjmp, cdfal are set as follows.
*      1)   if the failure exit is the next statement
*           cdjmp = b_cds
*           cdfal = ptr to cdblk for next statement
*      2)   if the failure exit is a simple label name
*           cdjmp = b_cds
*           cdfal is a ptr to the vrtra field of the vrblk
*      3)   if there is no failure exit (-nofail mode)
*           cdjmp = b_cds
*           cdfal = o_unf
*      4)   if the failure exit is complex or direct
*           cdjmp = b_cdc
*           cdfal is the offset to the o_gof word
{{ejc{{{{{2773
*      code block (continued)
*      cdcod is the start of the actual code. first we describe
*      the code generated for an expression. in an expression,
*      elements are fetched by name or by value. for example,
*      the binary equal operator fetches its left argument
*      by name and its right argument by value. these two
*      cases generate quite different code and are described
*      separately. first we consider the code by value case.
*      generation of code by value for expressions elements.
*      expression            pointer to exblk or seblk
*      integer constant      pointer to icblk
*      null constant         pointer to nulls
*      pattern               (resulting from preevaluation)
*                            =o_lpt
*                            pointer to p0blk,p1blk or p2blk
*      real constant         pointer to rcblk
*      string constant       pointer to scblk
*      variable              pointer to vrget field of vrblk
*      addition              value code for left operand
*                            value code for right operand
*                            =o_add
*      affirmation           value code for operand
*                            =o_aff
*      alternation           value code for left operand
*                            value code for right operand
*                            =o_alt
*      array reference       (case of one subscript)
*                            value code for array operand
*                            value code for subscript operand
*                            =o_aov
*                            (case of more than one subscript)
*                            value code for array operand
*                            value code for first subscript
*                            value code for second subscript
*                            ...
*                            value code for last subscript
*                            =o_amv
*                            number of subscripts
{{ejc{{{{{2827
*      code block (continued)
*      assignment            (to natural variable)
*                            value code for right operand
*                            pointer to vrsto field of vrblk
*                            (to any other variable)
*                            name code for left operand
*                            value code for right operand
*                            =o_ass
*      compile error         =o_cer
*      complementation       value code for operand
*                            =o_com
*      concatenation         (case of pred func left operand)
*                            value code for left operand
*                            =o_pop
*                            value code for right operand
*                            (all other cases)
*                            value code for left operand
*                            value code for right operand
*                            =o_cnc
*      cursor assignment     name code for operand
*                            =o_cas
*      division              value code for left operand
*                            value code for right operand
*                            =o_dvd
*      exponentiation        value code for left operand
*                            value code for right operand
*                            =o_exp
*      function call         (case of call to system function)
*                            value code for first argument
*                            value code for second argument
*                            ...
*                            value code for last argument
*                            pointer to svfnc field of svblk
{{ejc{{{{{2874
*      code block (continued)
*      function call         (case of non-system function 1 arg)
*                            value code for argument
*                            =o_fns
*                            pointer to vrblk for function
*                            (non-system function, gt 1 arg)
*                            value code for first argument
*                            value code for second argument
*                            ...
*                            value code for last argument
*                            =o_fnc
*                            number of arguments
*                            pointer to vrblk for function
*      immediate assignment  value code for left operand
*                            name code for right operand
*                            =o_ima
*      indirection           value code for operand
*                            =o_inv
*      interrogation         value code for operand
*                            =o_int
*      keyword reference     name code for operand
*                            =o_kwv
*      multiplication        value code for left operand
*                            value code for right operand
*                            =o_mlt
*      name reference        (natural variable case)
*                            pointer to nmblk for name
*                            (all other cases)
*                            name code for operand
*                            =o_nam
*      negation              =o_nta
*                            cdblk offset of o_ntc word
*                            value code for operand
*                            =o_ntb
*                            =o_ntc
{{ejc{{{{{2921
*      code block (continued)
*      pattern assignment    value code for left operand
*                            name code for right operand
*                            =o_pas
*      pattern match         value code for left operand
*                            value code for right operand
*                            =o_pmv
*      pattern replacement   name code for subject
*                            value code for pattern
*                            =o_pmn
*                            value code for replacement
*                            =o_rpl
*      selection             (for first alternative)
*                            =o_sla
*                            cdblk offset to next o_slc word
*                            value code for first alternative
*                            =o_slb
*                            cdblk offset past alternatives
*                            (for subsequent alternatives)
*                            =o_slc
*                            cdblk offset to next o_slc,o_sld
*                            value code for alternative
*                            =o_slb
*                            offset in cdblk past alternatives
*                            (for last alternative)
*                            =o_sld
*                            value code for last alternative
*      subtraction           value code for left operand
*                            value code for right operand
*                            =o_sub
{{ejc{{{{{2960
*      code block (continued)
*      generation of code by name for expression elements.
*      variable              =o_lvn
*                            pointer to vrblk
*      expression            (case of *natural variable)
*                            =o_lvn
*                            pointer to vrblk
*                            (all other cases)
*                            =o_lex
*                            pointer to exblk
*      array reference       (case of one subscript)
*                            value code for array operand
*                            value code for subscript operand
*                            =o_aon
*                            (case of more than one subscript)
*                            value code for array operand
*                            value code for first subscript
*                            value code for second subscript
*                            ...
*                            value code for last subscript
*                            =o_amn
*                            number of subscripts
*      compile error         =o_cer
*      function call         (same code as for value call)
*                            =o_fne
*      indirection           value code for operand
*                            =o_inn
*      keyword reference     name code for operand
*                            =o_kwn
*      any other operand is an error in a name position
*      note that in this description, =o_xxx refers to the
*      generation of a word containing the address of another
*      word which contains the entry point address o_xxx.
{{ejc{{{{{3008
*      code block (continued)
*      now we consider the overall structure of the code block
*      for a statement with possible goto fields.
*      first comes the code for the statement body.
*      the statement body is an expression to be evaluated
*      by value although the value is not actually required.
*      normal value code is generated for the body of the
*      statement except in the case of a pattern match by
*      value, in which case the following is generated.
*                            value code for left operand
*                            value code for right operand
*                            =o_pms
*      next we have the code for the success goto. there are
*      several cases as follows.
*      1)   no success goto  ptr to cdblk for next statement
*      2)   simple label     ptr to vrtra field of vrblk
*      3)   complex goto     (code by name for goto operand)
*                            =o_goc
*      4)   direct goto      (code by value for goto operand)
*                            =o_god
*      following this we generate code for the failure goto if
*      it is direct or if it is complex, simple failure gotos
*      having been handled by an appropriate setting of the
*      cdfal field of the cdblk. the generated code is one
*      of the following.
*      1)   complex fgoto    =o_fif
*                            =o_gof
*                            name code for goto operand
*                            =o_goc
*      2)   direct fgoto     =o_fif
*                            =o_gof
*                            value code for goto operand
*                            =o_god
*      an optimization occurs if the success and failure gotos
*      are identical and either complex or direct. in this case,
*      no code is generated for the success goto and control
*      is allowed to fall into the failure goto on success.
{{ejc{{{{{3059
*      compiler block (cmblk)
*      a compiler block (cmblk) is built by expan to represent
*      one node of a tree structured expression representation.
*           +------------------------------------+
*           i                cmidn               i
*           +------------------------------------+
*           i                cmlen               i
*           +------------------------------------+
*           i                cmtyp               i
*           +------------------------------------+
*           i                cmopn               i
*           +------------------------------------+
*           /           cmvls or cmrop           /
*           /                                    /
*           /                cmlop               /
*           /                                    /
*           +------------------------------------+
{cmidn{equ{24,0{{{pointer to dummy routine b_cmt{3081
{cmlen{equ{24,cmidn+1{{{length of cmblk in bytes{3082
{cmtyp{equ{24,cmlen+1{{{type (c_xxx, see list below){3083
{cmopn{equ{24,cmtyp+1{{{operand pointer (see below){3084
{cmvls{equ{24,cmopn+1{{{operand value pointers (see below){3085
{cmrop{equ{24,cmvls{{{right (only) operator operand{3086
{cmlop{equ{24,cmvls+1{{{left operator operand{3087
{cmsi_{equ{24,cmvls{{{number of standard fields in cmblk{3088
{cmus_{equ{24,cmsi_+1{{{size of unary operator cmblk{3089
{cmbs_{equ{24,cmsi_+2{{{size of binary operator cmblk{3090
{cmar1{equ{24,cmvls+1{{{array subscript pointers{3091
*      the cmopn and cmvls fields are set as follows
*      array reference       cmopn = ptr to array operand
*                            cmvls = ptrs to subscript operands
*      function call         cmopn = ptr to vrblk for function
*                            cmvls = ptrs to argument operands
*      selection             cmopn = zero
*                            cmvls = ptrs to alternate operands
*      unary operator        cmopn = ptr to operator dvblk
*                            cmrop = ptr to operand
*      binary operator       cmopn = ptr to operator dvblk
*                            cmrop = ptr to right operand
*                            cmlop = ptr to left operand
{{ejc{{{{{3110
*      cmtyp is set to indicate the type of expression element
*      as shown by the following table of definitions.
{c_arr{equ{24,0{{{array reference{3115
{c_fnc{equ{24,c_arr+1{{{function call{3116
{c_def{equ{24,c_fnc+1{{{deferred expression (unary *){3117
{c_ind{equ{24,c_def+1{{{indirection (unary _){3118
{c_key{equ{24,c_ind+1{{{keyword reference (unary ampersand){3119
{c_ubo{equ{24,c_key+1{{{undefined binary operator{3120
{c_uuo{equ{24,c_ubo+1{{{undefined unary operator{3121
{c_uo_{equ{24,c_uuo+1{{{test value (=c_uuo+1=c_ubo+2){3122
{c__nm{equ{24,c_uuo+1{{{number of codes for name operands{3123
*      the remaining types indicate expression elements which
*      can only be evaluated by value (not by name).
{c_bvl{equ{24,c_uuo+1{{{binary op with value operands{3128
{c_uvl{equ{24,c_bvl+1{{{unary operator with value operand{3129
{c_alt{equ{24,c_uvl+1{{{alternation (binary bar){3130
{c_cnc{equ{24,c_alt+1{{{concatenation{3131
{c_cnp{equ{24,c_cnc+1{{{concatenation, not pattern match{3132
{c_unm{equ{24,c_cnp+1{{{unary op with name operand{3133
{c_bvn{equ{24,c_unm+1{{{binary op (operands by value, name){3134
{c_ass{equ{24,c_bvn+1{{{assignment{3135
{c_int{equ{24,c_ass+1{{{interrogation{3136
{c_neg{equ{24,c_int+1{{{negation (unary not){3137
{c_sel{equ{24,c_neg+1{{{selection{3138
{c_pmt{equ{24,c_sel+1{{{pattern match{3139
{c_pr_{equ{24,c_bvn{{{last preevaluable code{3141
{c__nv{equ{24,c_pmt+1{{{number of different cmblk types{3142
{{ejc{{{{{3143
*      character table block (ctblk)
*      a character table block is used to hold logical character
*      tables for use with any,notany,span,break,breakx
*      patterns. each character table can be used to store
*      cfp_n distinct tables as bit columns. a bit column
*      allocated for each argument of more than one character
*      in length to one of the above listed pattern primitives.
*           +------------------------------------+
*           i                cttyp               i
*           +------------------------------------+
*           *                                    *
*           *                                    *
*           *                ctchs               *
*           *                                    *
*           *                                    *
*           +------------------------------------+
{cttyp{equ{24,0{{{pointer to dummy routine b_ctt{3164
{ctchs{equ{24,cttyp+1{{{start of character table words{3165
{ctsi_{equ{24,ctchs+cfp_a{{{number of words in ctblk{3166
*      ctchs is cfp_a words long and consists of a one word
*      bit string value for each possible character in the
*      internal alphabet. each of the cfp_n possible bits in
*      a bitstring is used to form a column of bit indicators.
*      a bit is set on if the character is in the table and off
*      if the character is not present.
{{ejc{{{{{3174
*      datatype function block (dfblk)
*      a datatype function is used to control the construction
*      of a program defined datatype object. a call to the
*      system function data builds a dfblk for the datatype name
*      note that these blocks are built in static because pdblk
*      length is got from dflen field.  if dfblk was in dynamic
*      store this would cause trouble during pass two of garbage
*      collection.  scblk referred to by dfnam field is also put
*      in static so that there are no reloc. fields. this cuts
*      garbage collection task appreciably for pdblks which are
*      likely to be present in large numbers.
*           +------------------------------------+
*           i                fcode               i
*           +------------------------------------+
*           i                fargs               i
*           +------------------------------------+
*           i                dflen               i
*           +------------------------------------+
*           i                dfpdl               i
*           +------------------------------------+
*           i                dfnam               i
*           +------------------------------------+
*           /                                    /
*           /                dffld               /
*           /                                    /
*           +------------------------------------+
{dflen{equ{24,fargs+1{{{length of dfblk in bytes{3206
{dfpdl{equ{24,dflen+1{{{length of corresponding pdblk{3207
{dfnam{equ{24,dfpdl+1{{{pointer to scblk for datatype name{3208
{dffld{equ{24,dfnam+1{{{start of vrblk ptrs for field names{3209
{dfflb{equ{24,dffld-1{{{offset behind dffld for field func{3210
{dfsi_{equ{24,dffld{{{number of standard fields in dfblk{3211
*      the fcode field points to the routine b_dfc
*      fargs (the number of arguments) is the number of fields.
{{ejc{{{{{3216
*      dope vector block (dvblk)
*      a dope vector is assembled for each possible operator in
*      the snobol4 language as part of the constant section.
*           +------------------------------------+
*           i                dvopn               i
*           +------------------------------------+
*           i                dvtyp               i
*           +------------------------------------+
*           i                dvlpr               i
*           +------------------------------------+
*           i                dvrpr               i
*           +------------------------------------+
{dvopn{equ{24,0{{{entry address (ptr to o_xxx){3233
{dvtyp{equ{24,dvopn+1{{{type code (c_xxx, see cmblk){3234
{dvlpr{equ{24,dvtyp+1{{{left precedence (llxxx, see below){3235
{dvrpr{equ{24,dvlpr+1{{{right precedence (rrxxx, see below){3236
{dvus_{equ{24,dvlpr+1{{{size of unary operator dv{3237
{dvbs_{equ{24,dvrpr+1{{{size of binary operator dv{3238
{dvubs{equ{24,dvus_+dvbs_{{{size of unop + binop (see scane){3239
*      the contents of the dvtyp field is copied into the cmtyp
*      field of the cmblk for the operator if it is used.
*      the cmopn field of an operator cmblk points to the dvblk
*      itself, providing the required entry address pointer ptr.
*      for normally undefined operators, the dvopn (and cmopn)
*      fields contain a word offset from r_uba of the function
*      block pointer for the operator (instead of o_xxx ptr).
*      for certain special operators, the dvopn field is not
*      required at all and is assembled as zero.
*      the left precedence is used in comparing an operator to
*      the left of some other operator. it therefore governs the
*      precedence of the operator towards its right operand.
*      the right precedence is used in comparing an operator to
*      the right of some other operator. it therefore governs
*      the precedence of the operator towards its left operand.
*      higher precedence values correspond to a tighter binding
*      capability. thus we have the left precedence lower
*      (higher) than the right precedence for right (left)
*      associative binary operators.
*      the left precedence of unary operators is set to an
*      arbitrary high value. the right value is not required and
*      consequently the dvrpr field is omitted for unary ops.
{{ejc{{{{{3269
*      table of operator precedence values
{rrass{equ{24,10{{{right     equal{3273
{llass{equ{24,00{{{left      equal{3274
{rrpmt{equ{24,20{{{right     question mark{3275
{llpmt{equ{24,30{{{left      question mark{3276
{rramp{equ{24,40{{{right     ampersand{3277
{llamp{equ{24,50{{{left      ampersand{3278
{rralt{equ{24,70{{{right     vertical bar{3279
{llalt{equ{24,60{{{left      vertical bar{3280
{rrcnc{equ{24,90{{{right     blank{3281
{llcnc{equ{24,80{{{left      blank{3282
{rrats{equ{24,110{{{right     at{3283
{llats{equ{24,100{{{left      at{3284
{rrplm{equ{24,120{{{right     plus, minus{3285
{llplm{equ{24,130{{{left      plus, minus{3286
{rrnum{equ{24,140{{{right     number{3287
{llnum{equ{24,150{{{left      number{3288
{rrdvd{equ{24,160{{{right     slash{3289
{lldvd{equ{24,170{{{left      slash{3290
{rrmlt{equ{24,180{{{right     asterisk{3291
{llmlt{equ{24,190{{{left      asterisk{3292
{rrpct{equ{24,200{{{right     percent{3293
{llpct{equ{24,210{{{left      percent{3294
{rrexp{equ{24,230{{{right     exclamation{3295
{llexp{equ{24,220{{{left      exclamation{3296
{rrdld{equ{24,240{{{right     dollar, dot{3297
{lldld{equ{24,250{{{left      dollar, dot{3298
{rrnot{equ{24,270{{{right     not{3299
{llnot{equ{24,260{{{left      not{3300
{lluno{equ{24,999{{{left      all unary operators{3301
*      precedences are the same as in btl snobol4 with the
*      following exceptions.
*      1)   binary question mark is lowered and made left assoc-
*           iative to reflect its new use for pattern matching.
*      2)   alternation and concatenation are made right
*           associative for greater efficiency in pattern
*           construction and matching respectively. this change
*           is transparent to the snobol4 programmer.
*      3)   the equal sign has been added as a low precedence
*           operator which is right associative to reflect its
*           more general usage in this version of snobol4.
{{ejc{{{{{3317
*      external function block (efblk)
*      an external function block is used to control the calling
*      of an external function. it is built by a call to load.
*           +------------------------------------+
*           i                fcode               i
*           +------------------------------------+
*           i                fargs               i
*           +------------------------------------+
*           i                eflen               i
*           +------------------------------------+
*           i                efuse               i
*           +------------------------------------+
*           i                efcod               i
*           +------------------------------------+
*           i                efvar               i
*           +------------------------------------+
*           i                efrsl               i
*           +------------------------------------+
*           /                                    /
*           /                eftar               /
*           /                                    /
*           +------------------------------------+
{eflen{equ{24,fargs+1{{{length of efblk in bytes{3344
{efuse{equ{24,eflen+1{{{use count (for opsyn){3345
{efcod{equ{24,efuse+1{{{ptr to code (from sysld){3346
{efvar{equ{24,efcod+1{{{ptr to associated vrblk{3347
{efrsl{equ{24,efvar+1{{{result type (see below){3348
{eftar{equ{24,efrsl+1{{{argument types (see below){3349
{efsi_{equ{24,eftar{{{number of standard fields in efblk{3350
*      the fcode field points to the routine b_efc.
*      efuse is used to keep track of multiple use when opsyn
*      is employed. the function is automatically unloaded
*      when there are no more references to the function.
*      efrsl and eftar are type codes as follows.
*           0                type is unconverted
*           1                type is string
*           2                type is integer
*           3                type is real
*           4                type is file
{{ejc{{{{{3373
*      expression variable block (evblk)
*      in this version of spitbol, an expression can be used in
*      any position which would normally expect a name (for
*      example on the left side of equals or as the right
*      argument of binary dot). this corresponds to the creation
*      of a pseudo-variable which is represented by a pointer to
*      an expression variable block as follows.
*           +------------------------------------+
*           i                evtyp               i
*           +------------------------------------+
*           i                evexp               i
*           +------------------------------------+
*           i                evvar               i
*           +------------------------------------+
{evtyp{equ{24,0{{{pointer to dummy routine b_evt{3392
{evexp{equ{24,evtyp+1{{{pointer to exblk for expression{3393
{evvar{equ{24,evexp+1{{{pointer to trbev dummy trblk{3394
{evsi_{equ{24,evvar+1{{{size of evblk{3395
*      the name of an expression variable is represented by a
*      base pointer to the evblk and an offset of evvar. this
*      value appears to be trapped by the dummy trbev block.
*      note that there is no need to allow for the case of an
*      expression variable which references an seblk since a
*      variable which is of the form *var is equivalent to var.
{{ejc{{{{{3404
*      expression block (exblk)
*      an expression block is built for each expression
*      referenced in a program or created by eval or convert
*      during execution of a program.
*           +------------------------------------+
*           i                extyp               i
*           +------------------------------------+
*           i                exstm               i
*           +------------------------------------+
*           i                exsln               i
*           +------------------------------------+
*           i                exlen               i
*           +------------------------------------+
*           i                exflc               i
*           +------------------------------------+
*           /                                    /
*           /                excod               /
*           /                                    /
*           +------------------------------------+
{extyp{equ{24,0{{{ptr to routine b_exl to load expr{3430
{exstm{equ{24,cdstm{{{stores stmnt no. during evaluation{3431
{exsln{equ{24,exstm+1{{{stores line no. during evaluation{3433
{exlen{equ{24,exsln+1{{{length of exblk in bytes{3434
{exflc{equ{24,exlen+1{{{failure code (=o_fex){3438
{excod{equ{24,exflc+1{{{pseudo-code for expression{3439
{exsi_{equ{24,excod{{{number of standard fields in exblk{3440
*      there are two cases for excod depending on whether the
*      expression can be evaluated by name (see description
*      of cdblk for details of code for expressions).
*      if the expression can be evaluated by name we have.
*                            (code for expr by name)
*                            =o_rnm
*      if the expression can only be evaluated by value.
*                            (code for expr by value)
*                            =o_rvl
{{ejc{{{{{3455
*      field function block (ffblk)
*      a field function block is used to control the selection
*      of a field from a program defined datatype block.
*      a call to data creates an ffblk for each field.
*           +------------------------------------+
*           i                fcode               i
*           +------------------------------------+
*           i                fargs               i
*           +------------------------------------+
*           i                ffdfp               i
*           +------------------------------------+
*           i                ffnxt               i
*           +------------------------------------+
*           i                ffofs               i
*           +------------------------------------+
{ffdfp{equ{24,fargs+1{{{pointer to associated dfblk{3475
{ffnxt{equ{24,ffdfp+1{{{ptr to next ffblk on chain or zero{3476
{ffofs{equ{24,ffnxt+1{{{offset (bytes) to field in pdblk{3477
{ffsi_{equ{24,ffofs+1{{{size of ffblk in words{3478
*      the fcode field points to the routine b_ffc.
*      fargs always contains one.
*      ffdfp is used to verify that the correct program defined
*      datatype is being accessed by this call.
*      ffdfp is non-reloc. because dfblk is in static
*      ffofs is used to select the appropriate field. note that
*      it is an actual offset (not a field number)
*      ffnxt is used to point to the next ffblk of the same name
*      in the case where there are several fields of the same
*      name for different datatypes. zero marks the end of chain
{{ejc{{{{{3494
*      integer constant block (icblk)
*      an icblk is created for every integer referenced or
*      created by a program. note however that certain internal
*      integer values are stored as addresses (e.g. the length
*      field in a string constant block)
*           +------------------------------------+
*           i                icget               i
*           +------------------------------------+
*           *                icval               *
*           +------------------------------------+
{icget{equ{24,0{{{ptr to routine b_icl to load int{3509
{icval{equ{24,icget+1{{{integer value{3510
{icsi_{equ{24,icval+cfp_i{{{size of icblk{3511
*      the length of the icval field is cfp_i.
{{ejc{{{{{3514
*      keyword variable block (kvblk)
*      a kvblk is used to represent a keyword pseudo-variable.
*      a kvblk is built for each keyword reference (kwnam).
*           +------------------------------------+
*           i                kvtyp               i
*           +------------------------------------+
*           i                kvvar               i
*           +------------------------------------+
*           i                kvnum               i
*           +------------------------------------+
{kvtyp{equ{24,0{{{pointer to dummy routine b_kvt{3529
{kvvar{equ{24,kvtyp+1{{{pointer to dummy block trbkv{3530
{kvnum{equ{24,kvvar+1{{{keyword number{3531
{kvsi_{equ{24,kvnum+1{{{size of kvblk{3532
*      the name of a keyword variable is represented by a
*      base pointer to the kvblk and an offset of kvvar. the
*      value appears to be trapped by the pointer to trbkv.
{{ejc{{{{{3537
*      name block (nmblk)
*      a name block is used wherever a name must be stored as
*      a value following use of the unary dot operator.
*           +------------------------------------+
*           i                nmtyp               i
*           +------------------------------------+
*           i                nmbas               i
*           +------------------------------------+
*           i                nmofs               i
*           +------------------------------------+
{nmtyp{equ{24,0{{{ptr to routine b_nml to load name{3552
{nmbas{equ{24,nmtyp+1{{{base pointer for variable{3553
{nmofs{equ{24,nmbas+1{{{offset for variable{3554
{nmsi_{equ{24,nmofs+1{{{size of nmblk{3555
*      the actual field representing the contents of the name
*      is found nmofs bytes past the address in nmbas.
*      the name is split into base and offset form to avoid
*      creation of a pointer into the middle of a block which
*      could not be handled properly by the garbage collector.
*      a name may be built for any variable (see section on
*      representations of variables) this includes the
*      cases of pseudo-variables.
{{ejc{{{{{3567
*      pattern block, no parameters (p0blk)
*      a p0blk is used to represent pattern nodes which do
*      not require the use of any parameter values.
*           +------------------------------------+
*           i                pcode               i
*           +------------------------------------+
*           i                pthen               i
*           +------------------------------------+
{pcode{equ{24,0{{{ptr to match routine (p_xxx){3580
{pthen{equ{24,pcode+1{{{pointer to subsequent node{3581
{pasi_{equ{24,pthen+1{{{size of p0blk{3582
*      pthen points to the pattern block for the subsequent
*      node to be matched. this is a pointer to the pattern
*      block ndnth if there is no subsequent (end of pattern)
*      pcode is a pointer to the match routine for the node.
{{ejc{{{{{3589
*      pattern block (one parameter)
*      a p1blk is used to represent pattern nodes which
*      require one parameter value.
*           +------------------------------------+
*           i                pcode               i
*           +------------------------------------+
*           i                pthen               i
*           +------------------------------------+
*           i                parm1               i
*           +------------------------------------+
{parm1{equ{24,pthen+1{{{first parameter value{3604
{pbsi_{equ{24,parm1+1{{{size of p1blk in words{3605
*      see p0blk for definitions of pcode, pthen
*      parm1 contains a parameter value used in matching the
*      node. for example, in a len pattern, it is the integer
*      argument to len. the details of the use of the parameter
*      field are included in the description of the individual
*      match routines. parm1 is always an address pointer which
*      is processed by the garbage collector.
{{ejc{{{{{3615
*      pattern block (two parameters)
*      a p2blk is used to represent pattern nodes which
*      require two parameter values.
*           +------------------------------------+
*           i                pcode               i
*           +------------------------------------+
*           i                pthen               i
*           +------------------------------------+
*           i                parm1               i
*           +------------------------------------+
*           i                parm2               i
*           +------------------------------------+
{parm2{equ{24,parm1+1{{{second parameter value{3632
{pcsi_{equ{24,parm2+1{{{size of p2blk in words{3633
*      see p1blk for definitions of pcode, pthen, parm1
*      parm2 is a parameter which performs the same sort of
*      function as parm1 (see description of p1blk).
*      parm2 is a non-relocatable field and is not
*      processed by the garbage collector. accordingly, it may
*      not contain a pointer to a block in dynamic memory.
{{ejc{{{{{3643
*      program-defined datatype block
*      a pdblk represents the data item formed by a call to a
*      datatype function as defined by the system function data.
*           +------------------------------------+
*           i                pdtyp               i
*           +------------------------------------+
*           i                idval               i
*           +------------------------------------+
*           i                pddfp               i
*           +------------------------------------+
*           /                                    /
*           /                pdfld               /
*           /                                    /
*           +------------------------------------+
{pdtyp{equ{24,0{{{ptr to dummy routine b_pdt{3662
{pddfp{equ{24,idval+1{{{ptr to associated dfblk{3663
{pdfld{equ{24,pddfp+1{{{start of field value pointers{3664
{pdfof{equ{24,dffld-pdfld{{{difference in offset to field ptrs{3665
{pdsi_{equ{24,pdfld{{{size of standard fields in pdblk{3666
{pddfs{equ{24,dfsi_-pdsi_{{{difference in dfblk, pdblk sizes{3667
*      the pddfp pointer may be used to determine the datatype
*      and the names of the fields if required. the dfblk also
*      contains the length of the pdblk in bytes (field dfpdl).
*      pddfp is non-reloc. because dfblk is in static
*      pdfld values are stored in order from left to right.
*      they contain values or pointers to trblk chains.
{{ejc{{{{{3676
*      program defined function block (pfblk)
*      a pfblk is created for each call to the define function
*      and a pointer to the pfblk placed in the proper vrblk.
*           +------------------------------------+
*           i                fcode               i
*           +------------------------------------+
*           i                fargs               i
*           +------------------------------------+
*           i                pflen               i
*           +------------------------------------+
*           i                pfvbl               i
*           +------------------------------------+
*           i                pfnlo               i
*           +------------------------------------+
*           i                pfcod               i
*           +------------------------------------+
*           i                pfctr               i
*           +------------------------------------+
*           i                pfrtr               i
*           +------------------------------------+
*           /                                    /
*           /                pfarg               /
*           /                                    /
*           +------------------------------------+
{pflen{equ{24,fargs+1{{{length of pfblk in bytes{3705
{pfvbl{equ{24,pflen+1{{{pointer to vrblk for function name{3706
{pfnlo{equ{24,pfvbl+1{{{number of locals{3707
{pfcod{equ{24,pfnlo+1{{{ptr to vrblk for entry label{3708
{pfctr{equ{24,pfcod+1{{{trblk ptr if call traced else 0{3709
{pfrtr{equ{24,pfctr+1{{{trblk ptr if return traced else 0{3710
{pfarg{equ{24,pfrtr+1{{{vrblk ptrs for arguments and locals{3711
{pfagb{equ{24,pfarg-1{{{offset behind pfarg for arg, local{3712
{pfsi_{equ{24,pfarg{{{number of standard fields in pfblk{3713
*      the fcode field points to the routine b_pfc.
*      pfarg is stored in the following order.
*           arguments (left to right)
*           locals (left to right)
{{ejc{{{{{3723
*      real constant block (rcblk)
*      an rcblk is created for every real referenced or
*      created by a program.
*           +------------------------------------+
*           i                rcget               i
*           +------------------------------------+
*           *                rcval               *
*           +------------------------------------+
{rcget{equ{24,0{{{ptr to routine b_rcl to load real{3736
{rcval{equ{24,rcget+1{{{real value{3737
{rcsi_{equ{24,rcval+cfp_r{{{size of rcblk{3738
*      the length of the rcval field is cfp_r.
{{ejc{{{{{3742
*      string constant block (scblk)
*      an scblk is built for every string referenced or created
*      by a program.
*           +------------------------------------+
*           i                scget               i
*           +------------------------------------+
*           i                sclen               i
*           +------------------------------------+
*           /                                    /
*           /                schar               /
*           /                                    /
*           +------------------------------------+
{scget{equ{24,0{{{ptr to routine b_scl to load string{3759
{sclen{equ{24,scget+1{{{length of string in characters{3760
{schar{equ{24,sclen+1{{{characters of string{3761
{scsi_{equ{24,schar{{{size of standard fields in scblk{3762
*      the characters of the string are stored left justified.
*      the final word is padded on the right with zeros.
*      (i.e. the character whose internal code is zero).
*      the value of sclen may not exceed mxlen. this ensures
*      that character offsets (e.g. the pattern match cursor)
*      can be correctly processed by the garbage collector.
*      note that the offset to the characters of the string
*      is given in bytes by cfp_f and that this value is
*      automatically allowed for in plc, psc.
*      note that for a spitbol scblk, the value of cfp_f
*      is given by cfp_b*schar.
{{ejc{{{{{3777
*      simple expression block (seblk)
*      an seblk is used to represent an expression of the form
*      *(natural variable). all other expressions are exblks.
*           +------------------------------------+
*           i                setyp               i
*           +------------------------------------+
*           i                sevar               i
*           +------------------------------------+
{setyp{equ{24,0{{{ptr to routine b_sel to load expr{3790
{sevar{equ{24,setyp+1{{{ptr to vrblk for variable{3791
{sesi_{equ{24,sevar+1{{{length of seblk in words{3792
{{ejc{{{{{3793
*      standard variable block (svblk)
*      an svblk is assembled in the constant section for each
*      variable which satisfies one of the following conditions.
*      1)   it is the name of a system function
*      2)   it has an initial value
*      3)   it has a keyword association
*      4)   it has a standard i/o association
*      6)   it has a standard label association
*      if vrblks are constructed for any of these variables,
*      then the vrsvp field points to the svblk (see vrblk)
*           +------------------------------------+
*           i                svbit               i
*           +------------------------------------+
*           i                svlen               i
*           +------------------------------------+
*           /                svchs               /
*           +------------------------------------+
*           i                svknm               i
*           +------------------------------------+
*           i                svfnc               i
*           +------------------------------------+
*           i                svnar               i
*           +------------------------------------+
*           i                svlbl               i
*           +------------------------------------+
*           i                svval               i
*           +------------------------------------+
{{ejc{{{{{3826
*      standard variable block (continued)
{svbit{equ{24,0{{{bit string indicating attributes{3830
{svlen{equ{24,1{{{(=sclen) length of name in chars{3831
{svchs{equ{24,2{{{(=schar) characters of name{3832
{svsi_{equ{24,2{{{number of standard fields in svblk{3833
{svpre{equ{24,1{{{set if preevaluation permitted{3834
{svffc{equ{24,svpre+svpre{{{set on if fast call permitted{3835
{svckw{equ{24,svffc+svffc{{{set on if keyword value constant{3836
{svprd{equ{24,svckw+svckw{{{set on if predicate function{3837
{svnbt{equ{24,4{{{number of bits to right of svknm{3838
{svknm{equ{24,svprd+svprd{{{set on if keyword association{3839
{svfnc{equ{24,svknm+svknm{{{set on if system function{3840
{svnar{equ{24,svfnc+svfnc{{{set on if system function{3841
{svlbl{equ{24,svnar+svnar{{{set on if system label{3842
{svval{equ{24,svlbl+svlbl{{{set on if predefined value{3843
*      note that the last five bits correspond in order
*      to the fields which are present (see procedure gtnvr).
*      the following definitions are used in the svblk table
{svfnf{equ{24,svfnc+svnar{{{function with no fast call{3850
{svfnn{equ{24,svfnf+svffc{{{function with fast call, no preeval{3851
{svfnp{equ{24,svfnn+svpre{{{function allowing preevaluation{3852
{svfpr{equ{24,svfnn+svprd{{{predicate function{3853
{svfnk{equ{24,svfnn+svknm{{{no preeval func + keyword{3854
{svkwv{equ{24,svknm+svval{{{keyword + value{3855
{svkwc{equ{24,svckw+svknm{{{keyword with constant value{3856
{svkvc{equ{24,svkwv+svckw{{{constant keyword + value{3857
{svkvl{equ{24,svkvc+svlbl{{{constant keyword + value + label{3858
{svfpk{equ{24,svfnp+svkvc{{{preeval fcn + const keywd + val{3859
*      the svpre bit allows the compiler to preevaluate a call
*      to the associated system function if all the arguments
*      are themselves constants. functions in this category
*      must have no side effects and must never cause failure.
*      the call may generate an error condition.
*      the svffc bit allows the compiler to generate the special
*      fast call after adjusting the number of arguments. only
*      the item and apply functions fall outside this category.
*      the svckw bit is set if the associated keyword value is
*      a constant, thus allowing preevaluation for a value call.
*      the svprd bit is set on for all predicate functions to
*      enable the special concatenation code optimization.
{{ejc{{{{{3876
*      svblk (continued)
*      svknm                 keyword number
*           svknm is present only for a standard keyword assoc.
*           it contains a keyword number as defined by the
*           keyword number table given later on.
*      svfnc                 system function pointer
*           svfnc is present only for a system function assoc.
*           it is a pointer to the actual code for the system
*           function. the generated code for a fast call is a
*           pointer to the svfnc field of the svblk for the
*           function. the vrfnc field of the vrblk points to
*           this same field, in which case, it serves as the
*           fcode field for the function call.
*      svnar                 number of function arguments
*           svnar is present only for a system function assoc.
*           it is the number of arguments required for a call
*           to the system function. the compiler uses this
*           value to adjust the number of arguments in a fast
*           call and in the case of a function called through
*           the vrfnc field of the vrblk, the svnar field
*           serves as the fargs field for o_fnc. a special
*           case occurs if this value is set to 999. this is
*           used to indicate that the function has a variable
*           number of arguments and causes o_fnc to pass control
*           without adjusting the argument count. the only
*           predefined functions using this are apply and item.
*      svlbl                 system label pointer
*           svlbl is present only for a standard label assoc.
*           it is a pointer to a system label routine (l_xxx).
*           the vrlbl field of the corresponding vrblk points to
*           the svlbl field of the svblk.
*      svval                 system value pointer
*           svval is present only for a standard value.
*           it is a pointer to the pattern node (ndxxx) which
*           is the standard initial value of the variable.
*           this value is copied to the vrval field of the vrblk
{{ejc{{{{{3924
*      svblk (continued)
*      keyword number table
*      the following table gives symbolic names for keyword
*      numbers. these values are stored in the svknm field of
*      svblks and in the kvnum field of kvblks. see also
*      procedures asign, acess and kwnam.
*      unprotected keywords with one word integer values
{k_abe{equ{24,0{{{abend{3937
{k_anc{equ{24,k_abe+cfp_b{{{anchor{3938
{k_cod{equ{24,k_anc+cfp_b{{{code{3943
{k_com{equ{24,k_cod+cfp_b{{{compare{3946
{k_dmp{equ{24,k_com+cfp_b{{{dump{3947
{k_erl{equ{24,k_dmp+cfp_b{{{errlimit{3951
{k_ert{equ{24,k_erl+cfp_b{{{errtype{3952
{k_ftr{equ{24,k_ert+cfp_b{{{ftrace{3953
{k_fls{equ{24,k_ftr+cfp_b{{{fullscan{3954
{k_inp{equ{24,k_fls+cfp_b{{{input{3955
{k_mxl{equ{24,k_inp+cfp_b{{{maxlength{3956
{k_oup{equ{24,k_mxl+cfp_b{{{output{3957
{k_pfl{equ{24,k_oup+cfp_b{{{profile{3961
{k_tra{equ{24,k_pfl+cfp_b{{{trace{3962
{k_trm{equ{24,k_tra+cfp_b{{{trim{3964
*      protected keywords with one word integer values
{k_fnc{equ{24,k_trm+cfp_b{{{fnclevel{3968
{k_lst{equ{24,k_fnc+cfp_b{{{lastno{3969
{k_lln{equ{24,k_lst+cfp_b{{{lastline{3971
{k_lin{equ{24,k_lln+cfp_b{{{line{3972
{k_stn{equ{24,k_lin+cfp_b{{{stno{3973
*      keywords with constant pattern values
{k_abo{equ{24,k_stn+cfp_b{{{abort{3980
{k_arb{equ{24,k_abo+pasi_{{{arb{3981
{k_bal{equ{24,k_arb+pasi_{{{bal{3982
{k_fal{equ{24,k_bal+pasi_{{{fail{3983
{k_fen{equ{24,k_fal+pasi_{{{fence{3984
{k_rem{equ{24,k_fen+pasi_{{{rem{3985
{k_suc{equ{24,k_rem+pasi_{{{succeed{3986
{{ejc{{{{{3987
*      keyword number table (continued)
*      special keywords
{k_alp{equ{24,k_suc+1{{{alphabet{3993
{k_rtn{equ{24,k_alp+1{{{rtntype{3994
{k_stc{equ{24,k_rtn+1{{{stcount{3995
{k_etx{equ{24,k_stc+1{{{errtext{3996
{k_fil{equ{24,k_etx+1{{{file{3998
{k_lfl{equ{24,k_fil+1{{{lastfile{3999
{k_stl{equ{24,k_lfl+1{{{stlimit{4000
{k_lcs{equ{24,k_stl+1{{{lcase{4005
{k_ucs{equ{24,k_lcs+1{{{ucase{4006
*      relative offsets of special keywords
{k__al{equ{24,k_alp-k_alp{{{alphabet{4011
{k__rt{equ{24,k_rtn-k_alp{{{rtntype{4012
{k__sc{equ{24,k_stc-k_alp{{{stcount{4013
{k__et{equ{24,k_etx-k_alp{{{errtext{4014
{k__fl{equ{24,k_fil-k_alp{{{file{4016
{k__lf{equ{24,k_lfl-k_alp{{{lastfile{4017
{k__sl{equ{24,k_stl-k_alp{{{stlimit{4019
{k__lc{equ{24,k_lcs-k_alp{{{lcase{4021
{k__uc{equ{24,k_ucs-k_alp{{{ucase{4022
{k__n_{equ{24,k__uc+1{{{number of special cases{4023
*      symbols used in asign and acess procedures
{k_p__{equ{24,k_fnc{{{first protected keyword{4030
{k_v__{equ{24,k_abo{{{first keyword with constant value{4031
{k_s__{equ{24,k_alp{{{first keyword with special acess{4032
{{ejc{{{{{4033
*      format of a table block (tbblk)
*      a table block is used to represent a table value.
*      it is built by a call to the table or convert functions.
*           +------------------------------------+
*           i                tbtyp               i
*           +------------------------------------+
*           i                idval               i
*           +------------------------------------+
*           i                tblen               i
*           +------------------------------------+
*           i                tbinv               i
*           +------------------------------------+
*           /                                    /
*           /                tbbuk               /
*           /                                    /
*           +------------------------------------+
{tbtyp{equ{24,0{{{pointer to dummy routine b_tbt{4054
{tblen{equ{24,offs2{{{length of tbblk in bytes{4055
{tbinv{equ{24,offs3{{{default initial lookup value{4056
{tbbuk{equ{24,tbinv+1{{{start of hash bucket pointers{4057
{tbsi_{equ{24,tbbuk{{{size of standard fields in tbblk{4058
{tbnbk{equ{24,11{{{default no. of buckets{4059
*      the table block is a hash table which points to chains
*      of table element blocks representing the elements
*      in the table which hash into the same bucket.
*      tbbuk entries either point to the first teblk on the
*      chain or they point to the tbblk itself to indicate the
*      end of the chain.
{{ejc{{{{{4068
*      table element block (teblk)
*      a table element is used to represent a single entry in
*      a table (see description of tbblk format for hash table)
*           +------------------------------------+
*           i                tetyp               i
*           +------------------------------------+
*           i                tesub               i
*           +------------------------------------+
*           i                teval               i
*           +------------------------------------+
*           i                tenxt               i
*           +------------------------------------+
{tetyp{equ{24,0{{{pointer to dummy routine b_tet{4085
{tesub{equ{24,tetyp+1{{{subscript value{4086
{teval{equ{24,tesub+1{{{(=vrval) table element value{4087
{tenxt{equ{24,teval+1{{{link to next teblk{4088
*      see s_cnv where relation is assumed with tenxt and tbbuk
{tesi_{equ{24,tenxt+1{{{size of teblk in words{4090
*      tenxt points to the next teblk on the hash chain from the
*      tbbuk chain for this hash index. at the end of the chain,
*      tenxt points back to the start of the tbblk.
*      teval contains a data pointer or a trblk pointer.
*      tesub contains a data pointer.
{{ejc{{{{{4099
*      trap block (trblk)
*      a trap block is used to represent a trace or input or
*      output association in response to a call to the trace
*      input or output system functions. see below for details
*           +------------------------------------+
*           i                tridn               i
*           +------------------------------------+
*           i                trtyp               i
*           +------------------------------------+
*           i  trval or trlbl or trnxt or trkvr  i
*           +------------------------------------+
*           i       trtag or trter or trtrf      i
*           +------------------------------------+
*           i            trfnc or trfpt          i
*           +------------------------------------+
{tridn{equ{24,0{{{pointer to dummy routine b_trt{4119
{trtyp{equ{24,tridn+1{{{trap type code{4120
{trval{equ{24,trtyp+1{{{value of trapped variable (=vrval){4121
{trnxt{equ{24,trval{{{ptr to next trblk on trblk chain{4122
{trlbl{equ{24,trval{{{ptr to actual label (traced label){4123
{trkvr{equ{24,trval{{{vrblk pointer for keyword trace{4124
{trtag{equ{24,trval+1{{{trace tag{4125
{trter{equ{24,trtag{{{ptr to terminal vrblk or null{4126
{trtrf{equ{24,trtag{{{ptr to trblk holding fcblk ptr{4127
{trfnc{equ{24,trtag+1{{{trace function vrblk (zero if none){4128
{trfpt{equ{24,trfnc{{{fcblk ptr for sysio{4129
{trsi_{equ{24,trfnc+1{{{number of words in trblk{4130
{trtin{equ{24,0{{{trace type for input association{4132
{trtac{equ{24,trtin+1{{{trace type for access trace{4133
{trtvl{equ{24,trtac+1{{{trace type for value trace{4134
{trtou{equ{24,trtvl+1{{{trace type for output association{4135
{trtfc{equ{24,trtou+1{{{trace type for fcblk identification{4136
{{ejc{{{{{4137
*      trap block (continued)
*      variable input association
*           the value field of the variable points to a trblk
*           instead of containing the data value. in the case
*           of a natural variable, the vrget and vrsto fields
*           contain =b_vra and =b_vrv to activate the check.
*           trtyp is set to trtin
*           trnxt points to next trblk or trval has variable val
*           trter is a pointer to svblk if association is
*           for input, terminal, else it is null.
*           trtrf points to the trap block which in turn points
*           to an fcblk used for i/o association.
*           trfpt is the fcblk ptr returned by sysio.
*      variable access trace association
*           the value field of the variable points to a trblk
*           instead of containing the data value. in the case
*           of a natural variable, the vrget and vrsto fields
*           contain =b_vra and =b_vrv to activate the check.
*           trtyp is set to trtac
*           trnxt points to next trblk or trval has variable val
*           trtag is the trace tag (0 if none)
*           trfnc is the trace function vrblk ptr (0 if none)
*      variable value trace association
*           the value field of the variable points to a trblk
*           instead of containing the data value. in the case
*           of a natural variable, the vrget and vrsto fields
*           contain =b_vra and =b_vrv to activate the check.
*           trtyp is set to trtvl
*           trnxt points to next trblk or trval has variable val
*           trtag is the trace tag (0 if none)
*           trfnc is the trace function vrblk ptr (0 if none)
{{ejc{{{{{4179
*      trap block (continued)
*      variable output association
*           the value field of the variable points to a trblk
*           instead of containing the data value. in the case
*           of a natural variable, the vrget and vrsto fields
*           contain =b_vra and =b_vrv to activate the check.
*           trtyp is set to trtou
*           trnxt points to next trblk or trval has variable val
*           trter is a pointer to svblk if association is
*           for output, terminal, else it is null.
*           trtrf points to the trap block which in turn points
*           to an fcblk used for i/o association.
*           trfpt is the fcblk ptr returned by sysio.
*      function call trace
*           the pfctr field of the corresponding pfblk is set
*           to point to a trblk.
*           trtyp is set to trtin
*           trnxt is zero
*           trtag is the trace tag (0 if none)
*           trfnc is the trace function vrblk ptr (0 if none)
*      function return trace
*           the pfrtr field of the corresponding pfblk is set
*           to point to a trblk
*           trtyp is set to trtin
*           trnxt is zero
*           trtag is the trace tag (0 if none)
*           trfnc is the trace function vrblk ptr (0 if none)
*      label trace
*           the vrlbl of the vrblk for the label is
*           changed to point to a trblk and the vrtra field is
*           set to b_vrt to activate the check.
*           trtyp is set to trtin
*           trlbl points to the actual label (cdblk) value
*           trtag is the trace tag (0 if none)
*           trfnc is the trace function vrblk ptr (0 if none)
{{ejc{{{{{4227
*      trap block (continued)
*      keyword trace
*           keywords which can be traced possess a unique
*           location which is zero if there is no trace and
*           points to a trblk if there is a trace. the locations
*           are as follows.
*           r_ert            errtype
*           r_fnc            fnclevel
*           r_stc            stcount
*           the format of the trblk is as follows.
*           trtyp is set to trtin
*           trkvr is a pointer to the vrblk for the keyword
*           trtag is the trace tag (0 if none)
*           trfnc is the trace function vrblk ptr (0 if none)
*      input/output file arg1 trap block
*           the value field of the variable points to a trblk
*           instead of containing the data value. in the case of
*           a natural variable, the vrget and vrsto fields
*           contain =b_vra and =b_vrv. this trap block is used
*           to hold a pointer to the fcblk which an
*           implementation may request to hold information
*           about a file.
*           trtyp is set to trtfc
*           trnext points to next trblk or trval is variable val
*           trfnm is 0
*           trfpt is the fcblk pointer.
*      note that when multiple traps are set on a variable
*      the order is in ascending value of trtyp field.
*      input association (if present)
*      access trace (if present)
*      value trace (if present)
*      output association (if present)
*      the actual value of the variable is stored in the trval
*      field of the last trblk on the chain.
*      this implementation does not permit trace or i/o
*      associations to any of the pseudo-variables.
{{ejc{{{{{4277
*      vector block (vcblk)
*      a vcblk is used to represent an array value which has
*      one dimension whose lower bound is one. all other arrays
*      are represented by arblks. a vcblk is created by the
*      system function array (s_arr) when passed an integer arg.
*           +------------------------------------+
*           i                vctyp               i
*           +------------------------------------+
*           i                idval               i
*           +------------------------------------+
*           i                vclen               i
*           +------------------------------------+
*           i                vcvls               i
*           +------------------------------------+
{vctyp{equ{24,0{{{pointer to dummy routine b_vct{4296
{vclen{equ{24,offs2{{{length of vcblk in bytes{4297
{vcvls{equ{24,offs3{{{start of vector values{4298
{vcsi_{equ{24,vcvls{{{size of standard fields in vcblk{4299
{vcvlb{equ{24,vcvls-1{{{offset one word behind vcvls{4300
{vctbd{equ{24,tbsi_-vcsi_{{{difference in sizes - see prtvl{4301
*      vcvls are either data pointers or trblk pointers
*      the dimension can be deduced from vclen.
{{ejc{{{{{4306
*      variable block (vrblk)
*      a variable block is built in the static memory area
*      for every variable referenced or created by a program.
*      the order of fields is assumed in the model vrblk stnvr.
*      note that since these blocks only occur in the static
*      region, it is permissible to point to any word in
*      the block and this is used to provide three distinct
*      access points from the generated code as follows.
*      1)   point to vrget (first word of vrblk) to load the
*           value of the variable onto the main stack.
*      2)   point to vrsto (second word of vrblk) to store the
*           top stack element as the value of the variable.
*      3)   point to vrtra (fourth word of vrblk) to jump to
*           the label associated with the variable name.
*           +------------------------------------+
*           i                vrget               i
*           +------------------------------------+
*           i                vrsto               i
*           +------------------------------------+
*           i                vrval               i
*           +------------------------------------+
*           i                vrtra               i
*           +------------------------------------+
*           i                vrlbl               i
*           +------------------------------------+
*           i                vrfnc               i
*           +------------------------------------+
*           i                vrnxt               i
*           +------------------------------------+
*           i                vrlen               i
*           +------------------------------------+
*           /                                    /
*           /            vrchs = vrsvp           /
*           /                                    /
*           +------------------------------------+
{{ejc{{{{{4349
*      variable block (continued)
{vrget{equ{24,0{{{pointer to routine to load value{4353
{vrsto{equ{24,vrget+1{{{pointer to routine to store value{4354
{vrval{equ{24,vrsto+1{{{variable value{4355
{vrvlo{equ{24,vrval-vrsto{{{offset to value from store field{4356
{vrtra{equ{24,vrval+1{{{pointer to routine to jump to label{4357
{vrlbl{equ{24,vrtra+1{{{pointer to code for label{4358
{vrlbo{equ{24,vrlbl-vrtra{{{offset to label from transfer field{4359
{vrfnc{equ{24,vrlbl+1{{{pointer to function block{4360
{vrnxt{equ{24,vrfnc+1{{{pointer to next vrblk on hash chain{4361
{vrlen{equ{24,vrnxt+1{{{length of name (or zero){4362
{vrchs{equ{24,vrlen+1{{{characters of name (vrlen gt 0){4363
{vrsvp{equ{24,vrlen+1{{{ptr to svblk (vrlen eq 0){4364
{vrsi_{equ{24,vrchs+1{{{number of standard fields in vrblk{4365
{vrsof{equ{24,vrlen-sclen{{{offset to dummy scblk for name{4366
{vrsvo{equ{24,vrsvp-vrsof{{{pseudo-offset to vrsvp field{4367
*      vrget = b_vrl if not input associated or access traced
*      vrget = b_vra if input associated or access traced
*      vrsto = b_vrs if not output associated or value traced
*      vrsto = b_vrv if output associated or value traced
*      vrsto = b_vre if value is protected pattern value
*      vrval points to the appropriate value unless the
*      variable is i/o/trace associated in which case, vrval
*      points to an appropriate trblk (trap block) chain.
*      vrtra = b_vrg if the label is not traced
*      vrtra = b_vrt if the label is traced
*      vrlbl points to a cdblk if there is a label
*      vrlbl points to the svblk svlbl field for a system label
*      vrlbl points to stndl for an undefined label
*      vrlbl points to a trblk if the label is traced
*      vrfnc points to a ffblk for a field function
*      vrfnc points to a dfblk for a datatype function
*      vrfnc points to a pfblk for a program defined function
*      vrfnc points to a efblk for an external loaded function
*      vrfnc points to svfnc (svblk) for a system function
*      vrfnc points to stndf if the function is undefined
*      vrnxt points to the next vrblk on this chain unless
*      this is the end of the chain in which case it is zero.
*      vrlen is the name length for a non-system variable.
*      vrlen is zero for a system variable.
*      vrchs is the name (ljrz) if vrlen is non-zero.
*      vrsvp is a ptr to the svblk if vrlen is zero.
{{ejc{{{{{4403
*      format of a non-relocatable external block (xnblk)
*      an xnblk is a block representing an unknown (external)
*      data value. the block contains no pointers to other
*      relocatable blocks. an xnblk is used by external function
*      processing or possibly for system i/o routines etc.
*      the macro-system itself does not use xnblks.
*      this type of block may be used as a file control block.
*      see sysfc,sysin,sysou,s_inp,s_oup for details.
*           +------------------------------------+
*           i                xntyp               i
*           +------------------------------------+
*           i                xnlen               i
*           +------------------------------------+
*           /                                    /
*           /                xndta               /
*           /                                    /
*           +------------------------------------+
{xntyp{equ{24,0{{{pointer to dummy routine b_xnt{4425
{xnlen{equ{24,xntyp+1{{{length of xnblk in bytes{4426
{xndta{equ{24,xnlen+1{{{data words{4427
{xnsi_{equ{24,xndta{{{size of standard fields in xnblk{4428
*      note that the term non-relocatable refers to the contents
*      and not the block itself. an xnblk can be moved around if
*      it is built in the dynamic memory area.
{{ejc{{{{{4433
*      relocatable external block (xrblk)
*      an xrblk is a block representing an unknown (external)
*      data value. the data area in this block consists only
*      of address values and any addresses pointing into the
*      dynamic memory area must point to the start of other
*      data blocks. see also description of xnblk.
*      this type of block may be used as a file control block.
*      see sysfc,sysin,sysou,s_inp,s_oup for details.
*           +------------------------------------+
*           i                xrtyp               i
*           +------------------------------------+
*           i                xrlen               i
*           +------------------------------------+
*           /                                    /
*           /                xrptr               /
*           /                                    /
*           +------------------------------------+
{xrtyp{equ{24,0{{{pointer to dummy routine b_xrt{4455
{xrlen{equ{24,xrtyp+1{{{length of xrblk in bytes{4456
{xrptr{equ{24,xrlen+1{{{start of address pointers{4457
{xrsi_{equ{24,xrptr{{{size of standard fields in xrblk{4458
{{ejc{{{{{4459
*      s_cnv (convert) function switch constants.  the values
*      are tied to the order of the entries in the svctb table
*      and hence to the branch table in s_cnv.
{cnvst{equ{24,8{{{max standard type code for convert{4465
{cnvrt{equ{24,cnvst+1{{{convert code for reals{4469
{cnvbt{equ{24,cnvrt{{{no buffers - same as real code{4472
{cnvtt{equ{24,cnvbt+1{{{bsw code for convert{4476
*      input image length
{iniln{equ{24,1024{{{default image length for compiler{4480
{inils{equ{24,1024{{{image length if -sequ in effect{4481
{ionmb{equ{24,2{{{name base used for iochn in sysio{4483
{ionmo{equ{24,4{{{name offset used for iochn in sysio{4484
*      minimum value for keyword maxlngth
*      should be larger than iniln
{mnlen{equ{24,1024{{{min value allowed keyword maxlngth{4489
{mxern{equ{24,329{{{err num inadequate startup memory{4490
*      in general, meaningful mnemonics should be used for
*      offsets. however for small integers used often in
*      literals the following general definitions are provided.
{num01{equ{24,1{{{{4496
{num02{equ{24,2{{{{4497
{num03{equ{24,3{{{{4498
{num04{equ{24,4{{{{4499
{num05{equ{24,5{{{{4500
{num06{equ{24,6{{{{4501
{num07{equ{24,7{{{{4502
{num08{equ{24,8{{{{4503
{num09{equ{24,9{{{{4504
{num10{equ{24,10{{{{4505
{num25{equ{24,25{{{{4506
{nm320{equ{24,320{{{{4507
{nm321{equ{24,321{{{{4508
{nini8{equ{24,998{{{{4509
{nini9{equ{24,999{{{{4510
{thsnd{equ{24,1000{{{{4511
{{ejc{{{{{4512
*      numbers of undefined spitbol operators
{opbun{equ{24,5{{{no. of binary undefined ops{4516
{opuun{equ{24,6{{{no of unary undefined ops{4517
*      offsets used in prtsn, prtmi and acess
{prsnf{equ{24,13{{{offset used in prtsn{4521
{prtmf{equ{24,21{{{offset to col 21 (prtmi){4522
{rilen{equ{24,1024{{{buffer length for sysri{4523
*      codes for stages of processing
{stgic{equ{24,0{{{initial compile{4527
{stgxc{equ{24,stgic+1{{{execution compile (code){4528
{stgev{equ{24,stgxc+1{{{expression eval during execution{4529
{stgxt{equ{24,stgev+1{{{execution time{4530
{stgce{equ{24,stgxt+1{{{initial compile after end line{4531
{stgxe{equ{24,stgce+1{{{exec. compile after end line{4532
{stgnd{equ{24,stgce-stgic{{{difference in stage after end{4533
{stgee{equ{24,stgxe+1{{{eval evaluating expression{4534
{stgno{equ{24,stgee+1{{{number of codes{4535
{{ejc{{{{{4536
*      statement number pad count for listr
{stnpd{equ{24,8{{{statement no. pad count{4541
*      syntax type codes
*      these codes are returned from the scane procedure.
*      they are spaced 3 apart for the benefit of expan.
{t_uop{equ{24,0{{{unary operator{4549
{t_lpr{equ{24,t_uop+3{{{left paren{4550
{t_lbr{equ{24,t_lpr+3{{{left bracket{4551
{t_cma{equ{24,t_lbr+3{{{comma{4552
{t_fnc{equ{24,t_cma+3{{{function call{4553
{t_var{equ{24,t_fnc+3{{{variable{4554
{t_con{equ{24,t_var+3{{{constant{4555
{t_bop{equ{24,t_con+3{{{binary operator{4556
{t_rpr{equ{24,t_bop+3{{{right paren{4557
{t_rbr{equ{24,t_rpr+3{{{right bracket{4558
{t_col{equ{24,t_rbr+3{{{colon{4559
{t_smc{equ{24,t_col+3{{{semi-colon{4560
*      the following definitions are used only in the goto field
{t_fgo{equ{24,t_smc+1{{{failure goto{4564
{t_sgo{equ{24,t_fgo+1{{{success goto{4565
*      the above codes are grouped so that codes for elements
*      which can legitimately immediately precede a unary
*      operator come first to facilitate operator syntax check.
{t_uok{equ{24,t_fnc{{{last code ok before unary operator{4571
{{ejc{{{{{4572
*      definitions of values for expan jump table
{t_uo0{equ{24,t_uop+0{{{unary operator, state zero{4576
{t_uo1{equ{24,t_uop+1{{{unary operator, state one{4577
{t_uo2{equ{24,t_uop+2{{{unary operator, state two{4578
{t_lp0{equ{24,t_lpr+0{{{left paren, state zero{4579
{t_lp1{equ{24,t_lpr+1{{{left paren, state one{4580
{t_lp2{equ{24,t_lpr+2{{{left paren, state two{4581
{t_lb0{equ{24,t_lbr+0{{{left bracket, state zero{4582
{t_lb1{equ{24,t_lbr+1{{{left bracket, state one{4583
{t_lb2{equ{24,t_lbr+2{{{left bracket, state two{4584
{t_cm0{equ{24,t_cma+0{{{comma, state zero{4585
{t_cm1{equ{24,t_cma+1{{{comma, state one{4586
{t_cm2{equ{24,t_cma+2{{{comma, state two{4587
{t_fn0{equ{24,t_fnc+0{{{function call, state zero{4588
{t_fn1{equ{24,t_fnc+1{{{function call, state one{4589
{t_fn2{equ{24,t_fnc+2{{{function call, state two{4590
{t_va0{equ{24,t_var+0{{{variable, state zero{4591
{t_va1{equ{24,t_var+1{{{variable, state one{4592
{t_va2{equ{24,t_var+2{{{variable, state two{4593
{t_co0{equ{24,t_con+0{{{constant, state zero{4594
{t_co1{equ{24,t_con+1{{{constant, state one{4595
{t_co2{equ{24,t_con+2{{{constant, state two{4596
{t_bo0{equ{24,t_bop+0{{{binary operator, state zero{4597
{t_bo1{equ{24,t_bop+1{{{binary operator, state one{4598
{t_bo2{equ{24,t_bop+2{{{binary operator, state two{4599
{t_rp0{equ{24,t_rpr+0{{{right paren, state zero{4600
{t_rp1{equ{24,t_rpr+1{{{right paren, state one{4601
{t_rp2{equ{24,t_rpr+2{{{right paren, state two{4602
{t_rb0{equ{24,t_rbr+0{{{right bracket, state zero{4603
{t_rb1{equ{24,t_rbr+1{{{right bracket, state one{4604
{t_rb2{equ{24,t_rbr+2{{{right bracket, state two{4605
{t_cl0{equ{24,t_col+0{{{colon, state zero{4606
{t_cl1{equ{24,t_col+1{{{colon, state one{4607
{t_cl2{equ{24,t_col+2{{{colon, state two{4608
{t_sm0{equ{24,t_smc+0{{{semicolon, state zero{4609
{t_sm1{equ{24,t_smc+1{{{semicolon, state one{4610
{t_sm2{equ{24,t_smc+2{{{semicolon, state two{4611
{t_nes{equ{24,t_sm2+1{{{number of entries in branch table{4613
{{ejc{{{{{4614
*       definition of offsets used in control card processing
{cc_do{equ{24,0{{{-double{4622
{cc_co{equ{24,cc_do+1{{{-compare{4625
{cc_du{equ{24,cc_co+1{{{-dump{4626
{cc_cp{equ{24,cc_du+1{{{-copy{4631
{cc_ej{equ{24,cc_cp+1{{{-eject{4632
{cc_er{equ{24,cc_ej+1{{{-errors{4636
{cc_ex{equ{24,cc_er+1{{{-execute{4637
{cc_fa{equ{24,cc_ex+1{{{-fail{4638
{cc_in{equ{24,cc_fa+1{{{-include{4640
{cc_ln{equ{24,cc_in+1{{{-line{4642
{cc_li{equ{24,cc_ln+1{{{-list{4643
{cc_nr{equ{24,cc_li+1{{{-noerrors{4655
{cc_nx{equ{24,cc_nr+1{{{-noexecute{4656
{cc_nf{equ{24,cc_nx+1{{{-nofail{4657
{cc_nl{equ{24,cc_nf+1{{{-nolist{4658
{cc_no{equ{24,cc_nl+1{{{-noopt{4659
{cc_np{equ{24,cc_no+1{{{-noprint{4660
{cc_op{equ{24,cc_np+1{{{-optimise{4661
{cc_pr{equ{24,cc_op+1{{{-print{4662
{cc_si{equ{24,cc_pr+1{{{-single{4663
{cc_sp{equ{24,cc_si+1{{{-space{4664
{cc_st{equ{24,cc_sp+1{{{-stitl{4665
{cc_ti{equ{24,cc_st+1{{{-title{4666
{cc_tr{equ{24,cc_ti+1{{{-trace{4667
{cc_nc{equ{24,cc_tr+1{{{number of control cards{4668
{ccnoc{equ{24,4{{{no. of chars included in match{4669
{ccofs{equ{24,7{{{offset to start of title/subtitle{4670
{ccinm{equ{24,9{{{max depth of include file nesting{4672
{{ejc{{{{{4674
*      definitions of stack offsets used in cmpil procedure
*      see description at start of cmpil procedure for details
*      of use of these locations on the stack.
{cmstm{equ{24,0{{{tree for statement body{4681
{cmsgo{equ{24,cmstm+1{{{tree for success goto{4682
{cmfgo{equ{24,cmsgo+1{{{tree for fail goto{4683
{cmcgo{equ{24,cmfgo+1{{{conditional goto flag{4684
{cmpcd{equ{24,cmcgo+1{{{previous cdblk pointer{4685
{cmffp{equ{24,cmpcd+1{{{failure fill in flag for previous{4686
{cmffc{equ{24,cmffp+1{{{failure fill in flag for current{4687
{cmsop{equ{24,cmffc+1{{{success fill in offset for previous{4688
{cmsoc{equ{24,cmsop+1{{{success fill in offset for current{4689
{cmlbl{equ{24,cmsoc+1{{{ptr to vrblk for current label{4690
{cmtra{equ{24,cmlbl+1{{{ptr to entry cdblk{4691
{cmnen{equ{24,cmtra+1{{{count of stack entries for cmpil{4693
*      a few constants used by the profiler
{pfpd1{equ{24,8{{{pad positions ...{4698
{pfpd2{equ{24,20{{{... for profile ...{4699
{pfpd3{equ{24,32{{{... printout{4700
{pf_i2{equ{24,cfp_i+cfp_i{{{size of table entry (2 ints){4701
{{ejc{{{{{4704
*      definition of limits and adjustments that are built by
*      relcr for use by the routines that relocate pointers
*      after a save file is reloaded.  see reloc etc. for usage.
*      a block of information is built that is used in
*      relocating pointers.  there are rnsi_ instances
*      of a rssi_ word structure.  each instance corresponds
*      to one of the regions that a pointer might point into.
*      each structure takes the form:
*           +------------------------------------+
*           i    address past end of section     i
*           +------------------------------------+
*           i  adjustment from old to new adrs   i
*           +------------------------------------+
*           i    address of start of section     i
*           +------------------------------------+
*      the instances are ordered thusly:
*           +------------------------------------+
*           i           dynamic storage          i
*           +------------------------------------+
*           i           static storage           i
*           +------------------------------------+
*           i       working section globals      i
*           +------------------------------------+
*           i          constant section          i
*           +------------------------------------+
*           i            code section            i
*           +------------------------------------+
*      symbolic names for these locations as offsets from
*      the first entry are provided here.
*      definitions within a section
{rlend{equ{24,0{{{end{4744
{rladj{equ{24,rlend+1{{{adjustment{4745
{rlstr{equ{24,rladj+1{{{start{4746
{rssi_{equ{24,rlstr+1{{{size of section{4747
{rnsi_{equ{24,5{{{number of structures{4748
*      overall definitions of all structures
{rldye{equ{24,0{{{dynamic region end{4752
{rldya{equ{24,rldye+1{{{dynamic region adjustment{4753
{rldys{equ{24,rldya+1{{{dynamic region start{4754
{rlste{equ{24,rldys+1{{{static region end{4755
{rlsta{equ{24,rlste+1{{{static region adjustment{4756
{rlsts{equ{24,rlsta+1{{{static region start{4757
{rlwke{equ{24,rlsts+1{{{working section globals end{4758
{rlwka{equ{24,rlwke+1{{{working section globals adjustment{4759
{rlwks{equ{24,rlwka+1{{{working section globals start{4760
{rlcne{equ{24,rlwks+1{{{constants section end{4761
{rlcna{equ{24,rlcne+1{{{constants section adjustment{4762
{rlcns{equ{24,rlcna+1{{{constants section start{4763
{rlcde{equ{24,rlcns+1{{{code section end{4764
{rlcda{equ{24,rlcde+1{{{code section adjustment{4765
{rlcds{equ{24,rlcda+1{{{code section start{4766
{rlsi_{equ{24,rlcds+1{{{number of fields in structure{4767
{{ttl{27,s p i t b o l -- constant section{{{{4770
*      this section consists entirely of assembled constants.
*      all label names are five letters. the order is
*      approximately alphabetical, but in some cases (always
*      documented), constants must be placed in some special
*      order which must not be disturbed.
*      it must also be remembered that there is a requirement
*      for no forward references which also disturbs the
*      alphabetical order in some cases.
{{sec{{{{start of constant section{4783
*      start of constant section
{c_aaa{dac{1,0{{{first location of constant section{4787
*      free store percentage (used by alloc)
{alfsp{dac{2,e_fsp{{{free store percentage{4791
*      bit constants for general use
{bits0{dbc{1,0{{{all zero bits{4795
{bits1{dbc{1,1{{{one bit in low order position{4796
{bits2{dbc{1,2{{{bit in position 2{4797
{bits3{dbc{1,4{{{bit in position 3{4798
{bits4{dbc{1,8{{{bit in position 4{4799
{bits5{dbc{1,16{{{bit in position 5{4800
{bits6{dbc{1,32{{{bit in position 6{4801
{bits7{dbc{1,64{{{bit in position 7{4802
{bits8{dbc{1,128{{{bit in position 8{4803
{bits9{dbc{1,256{{{bit in position 9{4804
{bit10{dbc{1,512{{{bit in position 10{4805
{bit11{dbc{1,1024{{{bit in position 11{4806
{bit12{dbc{1,2048{{{bit in position 12{4807
*bitsm  dbc  cfp_m            mask for max integer
{bitsm{dbc{1,0{{{mask for max integer (value filled in at runtime){4809
*      bit constants for svblk (svbit field) tests
{btfnc{dbc{2,svfnc{{{bit to test for function{4813
{btknm{dbc{2,svknm{{{bit to test for keyword number{4814
{btlbl{dbc{2,svlbl{{{bit to test for label{4815
{btffc{dbc{2,svffc{{{bit to test for fast call{4816
{btckw{dbc{2,svckw{{{bit to test for constant keyword{4817
{btkwv{dbc{2,svkwv{{{bits to test for keword with value{4818
{btprd{dbc{2,svprd{{{bit to test for predicate function{4819
{btpre{dbc{2,svpre{{{bit to test for preevaluation{4820
{btval{dbc{2,svval{{{bit to test for value{4821
{{ejc{{{{{4822
*      list of names used for control card processing
{ccnms{dtc{27,/doub/{{{{4830
{{dtc{27,/comp/{{{{4833
{{dtc{27,/dump/{{{{4835
{{dtc{27,/copy/{{{{4837
{{dtc{27,/ejec/{{{{4839
{{dtc{27,/erro/{{{{4840
{{dtc{27,/exec/{{{{4841
{{dtc{27,/fail/{{{{4842
{{dtc{27,/incl/{{{{4844
{{dtc{27,/line/{{{{4847
{{dtc{27,/list/{{{{4849
{{dtc{27,/noer/{{{{4850
{{dtc{27,/noex/{{{{4851
{{dtc{27,/nofa/{{{{4852
{{dtc{27,/noli/{{{{4853
{{dtc{27,/noop/{{{{4854
{{dtc{27,/nopr/{{{{4855
{{dtc{27,/opti/{{{{4856
{{dtc{27,/prin/{{{{4857
{{dtc{27,/sing/{{{{4858
{{dtc{27,/spac/{{{{4859
{{dtc{27,/stit/{{{{4860
{{dtc{27,/titl/{{{{4861
{{dtc{27,/trac/{{{{4862
*      header messages for dumpr procedure (scblk format)
{dmhdk{dac{6,b_scl{{{dump of keyword values{4866
{{dac{1,22{{{{4867
{{dtc{27,/dump of keyword values/{{{{4868
{dmhdv{dac{6,b_scl{{{dump of natural variables{4870
{{dac{1,25{{{{4871
{{dtc{27,/dump of natural variables/{{{{4872
{{ejc{{{{{4873
*      message text for compilation statistics
{encm1{dac{6,b_scl{{{{4877
{{dac{1,19{{{{4879
{{dtc{27,/memory used (bytes)/{{{{4880
{encm2{dac{6,b_scl{{{{4882
{{dac{1,19{{{{4883
{{dtc{27,/memory left (bytes)/{{{{4884
{encm3{dac{6,b_scl{{{{4894
{{dac{1,11{{{{4895
{{dtc{27,/comp errors/{{{{4896
{encm4{dac{6,b_scl{{{{4898
{{dac{1,20{{{{4903
{{dtc{27,/comp time (microsec)/{{{{4904
{encm5{dac{6,b_scl{{{execution suppressed{4907
{{dac{1,20{{{{4908
{{dtc{27,/execution suppressed/{{{{4909
*      string constant for abnormal end
{endab{dac{6,b_scl{{{{4913
{{dac{1,12{{{{4914
{{dtc{27,/abnormal end/{{{{4915
{{ejc{{{{{4916
*      memory overflow during initialisation
{endmo{dac{6,b_scl{{{{4920
{endml{dac{1,15{{{{4921
{{dtc{27,/memory overflow/{{{{4922
*      string constant for message issued by l_end
{endms{dac{6,b_scl{{{{4926
{{dac{1,10{{{{4927
{{dtc{27,/normal end/{{{{4928
*      fail message for stack fail section
{endso{dac{6,b_scl{{{stack overflow in garbage collector{4932
{{dac{1,36{{{{4933
{{dtc{27,/stack overflow in garbage collection/{{{{4934
*      string constant for time up
{endtu{dac{6,b_scl{{{{4938
{{dac{1,15{{{{4939
{{dtc{27,/error - time up/{{{{4940
{{ejc{{{{{4941
*      string constant for error message (error section)
{ermms{dac{6,b_scl{{{error{4945
{{dac{1,5{{{{4946
{{dtc{27,/error/{{{{4947
{ermns{dac{6,b_scl{{{string / -- /{4949
{{dac{1,4{{{{4950
{{dtc{27,/ -- /{{{{4951
*      string constant for page numbering
{lstms{dac{6,b_scl{{{page{4955
{{dac{1,5{{{{4956
{{dtc{27,/page /{{{{4957
*      listing header message
{headr{dac{6,b_scl{{{{4961
{{dac{1,25{{{{4962
{{dtc{27,/macro spitbol version 4.0/{{{{4963
{headv{dac{6,b_scl{{{for exit() version no. check{4965
{{dac{1,5{{{{4966
{{dtc{27,/15.01/{{{{4967
*      free store percentage (used by gbcol)
{gbsdp{dac{2,e_sed{{{sediment percentage{4971
*      integer constants for general use
*      icbld optimisation uses the first three.
{int_r{dac{6,b_icl{{{{4977
{intv0{dic{16,+0{{{0{4978
{inton{dac{6,b_icl{{{{4979
{intv1{dic{16,+1{{{1{4980
{inttw{dac{6,b_icl{{{{4981
{intv2{dic{16,+2{{{2{4982
{intvt{dic{16,+10{{{10{4983
{intvh{dic{16,+100{{{100{4984
{intth{dic{16,+1000{{{1000{4985
*      table used in icbld optimisation
{intab{dac{4,int_r{{{pointer to 0{4989
{{dac{4,inton{{{pointer to 1{4990
{{dac{4,inttw{{{pointer to 2{4991
{{ejc{{{{{4992
*      special pattern nodes. the following pattern nodes
*      consist simply of a pcode pointer, see match routines
*      (p_xxx) for full details of their use and format).
{ndabb{dac{6,p_abb{{{arbno{4998
{ndabd{dac{6,p_abd{{{arbno{4999
{ndarc{dac{6,p_arc{{{arb{5000
{ndexb{dac{6,p_exb{{{expression{5001
{ndfnb{dac{6,p_fnb{{{fence(){5002
{ndfnd{dac{6,p_fnd{{{fence(){5003
{ndexc{dac{6,p_exc{{{expression{5004
{ndimb{dac{6,p_imb{{{immediate assignment{5005
{ndimd{dac{6,p_imd{{{immediate assignment{5006
{ndnth{dac{6,p_nth{{{pattern end (null pattern){5007
{ndpab{dac{6,p_pab{{{pattern assignment{5008
{ndpad{dac{6,p_pad{{{pattern assignment{5009
{nduna{dac{6,p_una{{{anchor point movement{5010
*      keyword constant pattern nodes. the following nodes are
*      used as the values of pattern keywords and the initial
*      values of the corresponding natural variables. all
*      nodes are in p0blk format and the order is tied to the
*      definitions of corresponding k_xxx symbols.
{ndabo{dac{6,p_abo{{{abort{5018
{{dac{4,ndnth{{{{5019
{ndarb{dac{6,p_arb{{{arb{5020
{{dac{4,ndnth{{{{5021
{ndbal{dac{6,p_bal{{{bal{5022
{{dac{4,ndnth{{{{5023
{ndfal{dac{6,p_fal{{{fail{5024
{{dac{4,ndnth{{{{5025
{ndfen{dac{6,p_fen{{{fence{5026
{{dac{4,ndnth{{{{5027
{ndrem{dac{6,p_rem{{{rem{5028
{{dac{4,ndnth{{{{5029
{ndsuc{dac{6,p_suc{{{succeed{5030
{{dac{4,ndnth{{{{5031
*      null string. all null values point to this string. the
*      svchs field contains a blank to provide for easy default
*      processing in trace, stoptr, lpad and rpad.
*      nullw contains 10 blanks which ensures an all blank word
*      but for very exceptional machines.
{nulls{dac{6,b_scl{{{null string value{5039
{{dac{1,0{{{sclen = 0{5040
{nullw{dtc{27,/          /{{{{5041
*      constant strings for lcase and ucase keywords
{lcase{dac{6,b_scl{{{{5047
{{dac{1,26{{{{5048
{{dtc{27,/abcdefghijklmnopqrstuvwxyz/{{{{5049
{ucase{dac{6,b_scl{{{{5051
{{dac{1,26{{{{5052
{{dtc{27,/ABCDEFGHIJKLMNOPQRSTUVWXYZ/{{{{5053
{{ejc{{{{{5055
*      operator dope vectors (see dvblk format)
{opdvc{dac{6,o_cnc{{{concatenation{5059
{{dac{2,c_cnc{{{{5060
{{dac{2,llcnc{{{{5061
{{dac{2,rrcnc{{{{5062
*      opdvs is used when scanning below the top level to
*      insure that the concatenation will not be later
*      mistaken for pattern matching
{opdvp{dac{6,o_cnc{{{concatenation - not pattern match{5068
{{dac{2,c_cnp{{{{5069
{{dac{2,llcnc{{{{5070
{{dac{2,rrcnc{{{{5071
*      note that the order of the remaining entries is tied to
*      the order of the coding in the scane procedure.
{opdvs{dac{6,o_ass{{{assignment{5076
{{dac{2,c_ass{{{{5077
{{dac{2,llass{{{{5078
{{dac{2,rrass{{{{5079
{{dac{1,6{{{unary equal{5081
{{dac{2,c_uuo{{{{5082
{{dac{2,lluno{{{{5083
{{dac{6,o_pmv{{{pattern match{5085
{{dac{2,c_pmt{{{{5086
{{dac{2,llpmt{{{{5087
{{dac{2,rrpmt{{{{5088
{{dac{6,o_int{{{interrogation{5090
{{dac{2,c_uvl{{{{5091
{{dac{2,lluno{{{{5092
{{dac{1,1{{{binary ampersand{5094
{{dac{2,c_ubo{{{{5095
{{dac{2,llamp{{{{5096
{{dac{2,rramp{{{{5097
{{dac{6,o_kwv{{{keyword reference{5099
{{dac{2,c_key{{{{5100
{{dac{2,lluno{{{{5101
{{dac{6,o_alt{{{alternation{5103
{{dac{2,c_alt{{{{5104
{{dac{2,llalt{{{{5105
{{dac{2,rralt{{{{5106
{{ejc{{{{{5107
*      operator dope vectors (continued)
{{dac{1,5{{{unary vertical bar{5111
{{dac{2,c_uuo{{{{5112
{{dac{2,lluno{{{{5113
{{dac{1,0{{{binary at{5115
{{dac{2,c_ubo{{{{5116
{{dac{2,llats{{{{5117
{{dac{2,rrats{{{{5118
{{dac{6,o_cas{{{cursor assignment{5120
{{dac{2,c_unm{{{{5121
{{dac{2,lluno{{{{5122
{{dac{1,2{{{binary number sign{5124
{{dac{2,c_ubo{{{{5125
{{dac{2,llnum{{{{5126
{{dac{2,rrnum{{{{5127
{{dac{1,7{{{unary number sign{5129
{{dac{2,c_uuo{{{{5130
{{dac{2,lluno{{{{5131
{{dac{6,o_dvd{{{division{5133
{{dac{2,c_bvl{{{{5134
{{dac{2,lldvd{{{{5135
{{dac{2,rrdvd{{{{5136
{{dac{1,9{{{unary slash{5138
{{dac{2,c_uuo{{{{5139
{{dac{2,lluno{{{{5140
{{dac{6,o_mlt{{{multiplication{5142
{{dac{2,c_bvl{{{{5143
{{dac{2,llmlt{{{{5144
{{dac{2,rrmlt{{{{5145
{{ejc{{{{{5146
*      operator dope vectors (continued)
{{dac{1,0{{{deferred expression{5150
{{dac{2,c_def{{{{5151
{{dac{2,lluno{{{{5152
{{dac{1,3{{{binary percent{5154
{{dac{2,c_ubo{{{{5155
{{dac{2,llpct{{{{5156
{{dac{2,rrpct{{{{5157
{{dac{1,8{{{unary percent{5159
{{dac{2,c_uuo{{{{5160
{{dac{2,lluno{{{{5161
{{dac{6,o_exp{{{exponentiation{5163
{{dac{2,c_bvl{{{{5164
{{dac{2,llexp{{{{5165
{{dac{2,rrexp{{{{5166
{{dac{1,10{{{unary exclamation{5168
{{dac{2,c_uuo{{{{5169
{{dac{2,lluno{{{{5170
{{dac{6,o_ima{{{immediate assignment{5172
{{dac{2,c_bvn{{{{5173
{{dac{2,lldld{{{{5174
{{dac{2,rrdld{{{{5175
{{dac{6,o_inv{{{indirection{5177
{{dac{2,c_ind{{{{5178
{{dac{2,lluno{{{{5179
{{dac{1,4{{{binary not{5181
{{dac{2,c_ubo{{{{5182
{{dac{2,llnot{{{{5183
{{dac{2,rrnot{{{{5184
{{dac{1,0{{{negation{5186
{{dac{2,c_neg{{{{5187
{{dac{2,lluno{{{{5188
{{ejc{{{{{5189
*      operator dope vectors (continued)
{{dac{6,o_sub{{{subtraction{5193
{{dac{2,c_bvl{{{{5194
{{dac{2,llplm{{{{5195
{{dac{2,rrplm{{{{5196
{{dac{6,o_com{{{complementation{5198
{{dac{2,c_uvl{{{{5199
{{dac{2,lluno{{{{5200
{{dac{6,o_add{{{addition{5202
{{dac{2,c_bvl{{{{5203
{{dac{2,llplm{{{{5204
{{dac{2,rrplm{{{{5205
{{dac{6,o_aff{{{affirmation{5207
{{dac{2,c_uvl{{{{5208
{{dac{2,lluno{{{{5209
{{dac{6,o_pas{{{pattern assignment{5211
{{dac{2,c_bvn{{{{5212
{{dac{2,lldld{{{{5213
{{dac{2,rrdld{{{{5214
{{dac{6,o_nam{{{name reference{5216
{{dac{2,c_unm{{{{5217
{{dac{2,lluno{{{{5218
*      special dvs for goto operators (see procedure scngf)
{opdvd{dac{6,o_god{{{direct goto{5222
{{dac{2,c_uvl{{{{5223
{{dac{2,lluno{{{{5224
{opdvn{dac{6,o_goc{{{complex normal goto{5226
{{dac{2,c_unm{{{{5227
{{dac{2,lluno{{{{5228
{{ejc{{{{{5229
*      operator entry address pointers, used in code
{oamn_{dac{6,o_amn{{{array ref (multi-subs by value){5233
{oamv_{dac{6,o_amv{{{array ref (multi-subs by value){5234
{oaon_{dac{6,o_aon{{{array ref (one sub by name){5235
{oaov_{dac{6,o_aov{{{array ref (one sub by value){5236
{ocer_{dac{6,o_cer{{{compilation error{5237
{ofex_{dac{6,o_fex{{{failure in expression evaluation{5238
{ofif_{dac{6,o_fif{{{failure during goto evaluation{5239
{ofnc_{dac{6,o_fnc{{{function call (more than one arg){5240
{ofne_{dac{6,o_fne{{{function name error{5241
{ofns_{dac{6,o_fns{{{function call (single argument){5242
{ogof_{dac{6,o_gof{{{set goto failure trap{5243
{oinn_{dac{6,o_inn{{{indirection by name{5244
{okwn_{dac{6,o_kwn{{{keyword reference by name{5245
{olex_{dac{6,o_lex{{{load expression by name{5246
{olpt_{dac{6,o_lpt{{{load pattern{5247
{olvn_{dac{6,o_lvn{{{load variable name{5248
{onta_{dac{6,o_nta{{{negation, first entry{5249
{ontb_{dac{6,o_ntb{{{negation, second entry{5250
{ontc_{dac{6,o_ntc{{{negation, third entry{5251
{opmn_{dac{6,o_pmn{{{pattern match by name{5252
{opms_{dac{6,o_pms{{{pattern match (statement){5253
{opop_{dac{6,o_pop{{{pop top stack item{5254
{ornm_{dac{6,o_rnm{{{return name from expression{5255
{orpl_{dac{6,o_rpl{{{pattern replacement{5256
{orvl_{dac{6,o_rvl{{{return value from expression{5257
{osla_{dac{6,o_sla{{{selection, first entry{5258
{oslb_{dac{6,o_slb{{{selection, second entry{5259
{oslc_{dac{6,o_slc{{{selection, third entry{5260
{osld_{dac{6,o_sld{{{selection, fourth entry{5261
{ostp_{dac{6,o_stp{{{stop execution{5262
{ounf_{dac{6,o_unf{{{unexpected failure{5263
{{ejc{{{{{5264
*      table of names of undefined binary operators for opsyn
{opsnb{dac{2,ch_at{{{at{5268
{{dac{2,ch_am{{{ampersand{5269
{{dac{2,ch_nm{{{number{5270
{{dac{2,ch_pc{{{percent{5271
{{dac{2,ch_nt{{{not{5272
*      table of names of undefined unary operators for opsyn
{opnsu{dac{2,ch_br{{{vertical bar{5276
{{dac{2,ch_eq{{{equal{5277
{{dac{2,ch_nm{{{number{5278
{{dac{2,ch_pc{{{percent{5279
{{dac{2,ch_sl{{{slash{5280
{{dac{2,ch_ex{{{exclamation{5281
*      address const containing profile table entry size
{pfi2a{dac{2,pf_i2{{{{5287
*      profiler message strings
{pfms1{dac{6,b_scl{{{{5291
{{dac{1,15{{{{5292
{{dtc{27,/program profile/{{{{5293
{pfms2{dac{6,b_scl{{{{5294
{{dac{1,42{{{{5295
{{dtc{27,/stmt    number of     -- execution time --/{{{{5296
{pfms3{dac{6,b_scl{{{{5297
{{dac{1,47{{{{5298
{{dtc{27,/number  executions  total(msec) per excn(mcsec)/{{{{5299
*      real constants for general use. note that the constants
*      starting at reav1 form a powers of ten table (used in
*      gtnum and gtstg)
{reav0{drc{17,+0.0{{{0.0{5309
{reap1{drc{17,+0.1{{{0.1{5312
{reap5{drc{17,+0.5{{{0.5{5313
{reav1{drc{17,+1.0{{{10**0{5315
{reavt{drc{17,+1.0e+1{{{10**1{5316
{{drc{17,+1.0e+2{{{10**2{5317
{{drc{17,+1.0e+3{{{10**3{5318
{{drc{17,+1.0e+4{{{10**4{5319
{{drc{17,+1.0e+5{{{10**5{5320
{{drc{17,+1.0e+6{{{10**6{5321
{{drc{17,+1.0e+7{{{10**7{5322
{{drc{17,+1.0e+8{{{10**8{5323
{{drc{17,+1.0e+9{{{10**9{5324
{reatt{drc{17,+1.0e+10{{{10**10{5325
{{ejc{{{{{5327
*      string constants (scblk format) for dtype procedure
{scarr{dac{6,b_scl{{{array{5331
{{dac{1,5{{{{5332
{{dtc{27,/array/{{{{5333
{sccod{dac{6,b_scl{{{code{5342
{{dac{1,4{{{{5343
{{dtc{27,/code/{{{{5344
{scexp{dac{6,b_scl{{{expression{5346
{{dac{1,10{{{{5347
{{dtc{27,/expression/{{{{5348
{scext{dac{6,b_scl{{{external{5350
{{dac{1,8{{{{5351
{{dtc{27,/external/{{{{5352
{scint{dac{6,b_scl{{{integer{5354
{{dac{1,7{{{{5355
{{dtc{27,/integer/{{{{5356
{scnam{dac{6,b_scl{{{name{5358
{{dac{1,4{{{{5359
{{dtc{27,/name/{{{{5360
{scnum{dac{6,b_scl{{{numeric{5362
{{dac{1,7{{{{5363
{{dtc{27,/numeric/{{{{5364
{scpat{dac{6,b_scl{{{pattern{5366
{{dac{1,7{{{{5367
{{dtc{27,/pattern/{{{{5368
{screa{dac{6,b_scl{{{real{5372
{{dac{1,4{{{{5373
{{dtc{27,/real/{{{{5374
{scstr{dac{6,b_scl{{{string{5377
{{dac{1,6{{{{5378
{{dtc{27,/string/{{{{5379
{sctab{dac{6,b_scl{{{table{5381
{{dac{1,5{{{{5382
{{dtc{27,/table/{{{{5383
{scfil{dac{6,b_scl{{{file (for extended load arguments){5385
{{dac{1,4{{{{5386
{{dtc{27,/file/{{{{5387
{{ejc{{{{{5389
*      string constants (scblk format) for kvrtn (see retrn)
{scfrt{dac{6,b_scl{{{freturn{5393
{{dac{1,7{{{{5394
{{dtc{27,/freturn/{{{{5395
{scnrt{dac{6,b_scl{{{nreturn{5397
{{dac{1,7{{{{5398
{{dtc{27,/nreturn/{{{{5399
{scrtn{dac{6,b_scl{{{return{5401
{{dac{1,6{{{{5402
{{dtc{27,/return/{{{{5403
*      datatype name table for dtype procedure. the order of
*      these entries is tied to the b_xxx definitions for blocks
*      note that slots for buffer and real data types are filled
*      even if these data types are conditionalized out of the
*      implementation.  this is done so that the block numbering
*      at bl_ar etc. remains constant in all versions.
{scnmt{dac{4,scarr{{{arblk     array{5413
{{dac{4,sccod{{{cdblk     code{5414
{{dac{4,scexp{{{exblk     expression{5415
{{dac{4,scint{{{icblk     integer{5416
{{dac{4,scnam{{{nmblk     name{5417
{{dac{4,scpat{{{p0blk     pattern{5418
{{dac{4,scpat{{{p1blk     pattern{5419
{{dac{4,scpat{{{p2blk     pattern{5420
{{dac{4,screa{{{rcblk     real{5425
{{dac{4,scstr{{{scblk     string{5427
{{dac{4,scexp{{{seblk     expression{5428
{{dac{4,sctab{{{tbblk     table{5429
{{dac{4,scarr{{{vcblk     array{5430
{{dac{4,scext{{{xnblk     external{5431
{{dac{4,scext{{{xrblk     external{5432
{{dac{4,nulls{{{bfblk     no buffer in this version{5434
*      string constant for real zero
{scre0{dac{6,b_scl{{{{5443
{{dac{1,2{{{{5444
{{dtc{27,/0./{{{{5445
{{ejc{{{{{5447
*      used to re-initialise kvstl
{stlim{dic{16,+2147483647{{{default statement limit{5455
*      dummy function block used for undefined functions
{stndf{dac{6,o_fun{{{ptr to undefined function err call{5463
{{dac{1,0{{{dummy fargs count for call circuit{5464
*      dummy code block used for undefined labels
{stndl{dac{6,l_und{{{code ptr points to undefined lbl{5468
*      dummy operator block used for undefined operators
{stndo{dac{6,o_oun{{{ptr to undefined operator err call{5472
{{dac{1,0{{{dummy fargs count for call circuit{5473
*      standard variable block. this block is used to initialize
*      the first seven fields of a newly constructed vrblk.
*      its format is tied to the vrblk definitions (see gtnvr).
{stnvr{dac{6,b_vrl{{{vrget{5479
{{dac{6,b_vrs{{{vrsto{5480
{{dac{4,nulls{{{vrval{5481
{{dac{6,b_vrg{{{vrtra{5482
{{dac{4,stndl{{{vrlbl{5483
{{dac{4,stndf{{{vrfnc{5484
{{dac{1,0{{{vrnxt{5485
{{ejc{{{{{5486
*      messages used in end of run processing (stopr)
{stpm1{dac{6,b_scl{{{in statement{5490
{{dac{1,12{{{{5491
{{dtc{27,/in statement/{{{{5492
{stpm2{dac{6,b_scl{{{{5494
{{dac{1,14{{{{5495
{{dtc{27,/stmts executed/{{{{5496
{stpm3{dac{6,b_scl{{{{5498
{{dac{1,20{{{{5499
{{dtc{27,/execution time msec /{{{{5500
{stpm4{dac{6,b_scl{{{in line{5503
{{dac{1,7{{{{5504
{{dtc{27,/in line/{{{{5505
{stpm5{dac{6,b_scl{{{{5508
{{dac{1,13{{{{5509
{{dtc{27,/regenerations/{{{{5510
{stpm6{dac{6,b_scl{{{in file{5513
{{dac{1,7{{{{5514
{{dtc{27,/in file/{{{{5515
{stpm7{dac{6,b_scl{{{{5518
{{dac{1,15{{{{5519
{{dtc{27,_stmt / microsec_{{{{5520
{stpm8{dac{6,b_scl{{{{5522
{{dac{1,15{{{{5523
{{dtc{27,_stmt / millisec_{{{{5524
{stpm9{dac{6,b_scl{{{{5526
{{dac{1,13{{{{5527
{{dtc{27,_stmt / second_{{{{5528
*      chars for /tu/ ending code
{strtu{dtc{27,/tu/{{{{5532
*      table used by convert function to check datatype name
*      the entries are ordered to correspond to branch table
*      in s_cnv
{svctb{dac{4,scstr{{{string{5538
{{dac{4,scint{{{integer{5539
{{dac{4,scnam{{{name{5540
{{dac{4,scpat{{{pattern{5541
{{dac{4,scarr{{{array{5542
{{dac{4,sctab{{{table{5543
{{dac{4,scexp{{{expression{5544
{{dac{4,sccod{{{code{5545
{{dac{4,scnum{{{numeric{5546
{{dac{4,screa{{{real{5549
{{dac{1,0{{{zero marks end of list{5555
{{ejc{{{{{5556
*      messages (scblk format) used by trace procedures
{tmasb{dac{6,b_scl{{{asterisks for trace statement no{5561
{{dac{1,13{{{{5562
{{dtc{27,/************ /{{{{5563
{tmbeb{dac{6,b_scl{{{blank-equal-blank{5566
{{dac{1,3{{{{5567
{{dtc{27,/ = /{{{{5568
*      dummy trblk for expression variable
{trbev{dac{6,b_trt{{{dummy trblk{5572
*      dummy trblk for keyword variable
{trbkv{dac{6,b_trt{{{dummy trblk{5576
*      dummy code block to return control to trxeq procedure
{trxdr{dac{6,o_txr{{{block points to return routine{5580
{trxdc{dac{4,trxdr{{{pointer to block{5581
{{ejc{{{{{5582
*      standard variable blocks
*      see svblk format for full details of the format. the
*      vrblks are ordered by length and within each length the
*      order is alphabetical by name of the variable.
{v_eqf{dbc{2,svfpr{{{eq{5590
{{dac{1,2{{{{5591
{{dtc{27,/eq/{{{{5592
{{dac{6,s_eqf{{{{5593
{{dac{1,2{{{{5594
{v_gef{dbc{2,svfpr{{{ge{5596
{{dac{1,2{{{{5597
{{dtc{27,/ge/{{{{5598
{{dac{6,s_gef{{{{5599
{{dac{1,2{{{{5600
{v_gtf{dbc{2,svfpr{{{gt{5602
{{dac{1,2{{{{5603
{{dtc{27,/gt/{{{{5604
{{dac{6,s_gtf{{{{5605
{{dac{1,2{{{{5606
{v_lef{dbc{2,svfpr{{{le{5608
{{dac{1,2{{{{5609
{{dtc{27,/le/{{{{5610
{{dac{6,s_lef{{{{5611
{{dac{1,2{{{{5612
{v_lnf{dbc{2,svfnp{{{ln{5615
{{dac{1,2{{{{5616
{{dtc{27,/ln/{{{{5617
{{dac{6,s_lnf{{{{5618
{{dac{1,1{{{{5619
{v_ltf{dbc{2,svfpr{{{lt{5622
{{dac{1,2{{{{5623
{{dtc{27,/lt/{{{{5624
{{dac{6,s_ltf{{{{5625
{{dac{1,2{{{{5626
{v_nef{dbc{2,svfpr{{{ne{5628
{{dac{1,2{{{{5629
{{dtc{27,/ne/{{{{5630
{{dac{6,s_nef{{{{5631
{{dac{1,2{{{{5632
{v_any{dbc{2,svfnp{{{any{5658
{{dac{1,3{{{{5659
{{dtc{27,/any/{{{{5660
{{dac{6,s_any{{{{5661
{{dac{1,1{{{{5662
{v_arb{dbc{2,svkvc{{{arb{5664
{{dac{1,3{{{{5665
{{dtc{27,/arb/{{{{5666
{{dac{2,k_arb{{{{5667
{{dac{4,ndarb{{{{5668
{{ejc{{{{{5669
*      standard variable blocks (continued)
{v_arg{dbc{2,svfnn{{{arg{5673
{{dac{1,3{{{{5674
{{dtc{27,/arg/{{{{5675
{{dac{6,s_arg{{{{5676
{{dac{1,2{{{{5677
{v_bal{dbc{2,svkvc{{{bal{5679
{{dac{1,3{{{{5680
{{dtc{27,/bal/{{{{5681
{{dac{2,k_bal{{{{5682
{{dac{4,ndbal{{{{5683
{v_cos{dbc{2,svfnp{{{cos{5686
{{dac{1,3{{{{5687
{{dtc{27,/cos/{{{{5688
{{dac{6,s_cos{{{{5689
{{dac{1,1{{{{5690
{v_end{dbc{2,svlbl{{{end{5693
{{dac{1,3{{{{5694
{{dtc{27,/end/{{{{5695
{{dac{6,l_end{{{{5696
{v_exp{dbc{2,svfnp{{{exp{5699
{{dac{1,3{{{{5700
{{dtc{27,/exp/{{{{5701
{{dac{6,s_exp{{{{5702
{{dac{1,1{{{{5703
{v_len{dbc{2,svfnp{{{len{5706
{{dac{1,3{{{{5707
{{dtc{27,/len/{{{{5708
{{dac{6,s_len{{{{5709
{{dac{1,1{{{{5710
{v_leq{dbc{2,svfpr{{{leq{5712
{{dac{1,3{{{{5713
{{dtc{27,/leq/{{{{5714
{{dac{6,s_leq{{{{5715
{{dac{1,2{{{{5716
{v_lge{dbc{2,svfpr{{{lge{5718
{{dac{1,3{{{{5719
{{dtc{27,/lge/{{{{5720
{{dac{6,s_lge{{{{5721
{{dac{1,2{{{{5722
{v_lgt{dbc{2,svfpr{{{lgt{5724
{{dac{1,3{{{{5725
{{dtc{27,/lgt/{{{{5726
{{dac{6,s_lgt{{{{5727
{{dac{1,2{{{{5728
{v_lle{dbc{2,svfpr{{{lle{5730
{{dac{1,3{{{{5731
{{dtc{27,/lle/{{{{5732
{{dac{6,s_lle{{{{5733
{{dac{1,2{{{{5734
{{ejc{{{{{5735
*      standard variable blocks (continued)
{v_llt{dbc{2,svfpr{{{llt{5739
{{dac{1,3{{{{5740
{{dtc{27,/llt/{{{{5741
{{dac{6,s_llt{{{{5742
{{dac{1,2{{{{5743
{v_lne{dbc{2,svfpr{{{lne{5745
{{dac{1,3{{{{5746
{{dtc{27,/lne/{{{{5747
{{dac{6,s_lne{{{{5748
{{dac{1,2{{{{5749
{v_pos{dbc{2,svfnp{{{pos{5751
{{dac{1,3{{{{5752
{{dtc{27,/pos/{{{{5753
{{dac{6,s_pos{{{{5754
{{dac{1,1{{{{5755
{v_rem{dbc{2,svkvc{{{rem{5757
{{dac{1,3{{{{5758
{{dtc{27,/rem/{{{{5759
{{dac{2,k_rem{{{{5760
{{dac{4,ndrem{{{{5761
{v_sin{dbc{2,svfnp{{{sin{5772
{{dac{1,3{{{{5773
{{dtc{27,/sin/{{{{5774
{{dac{6,s_sin{{{{5775
{{dac{1,1{{{{5776
{v_tab{dbc{2,svfnp{{{tab{5779
{{dac{1,3{{{{5780
{{dtc{27,/tab/{{{{5781
{{dac{6,s_tab{{{{5782
{{dac{1,1{{{{5783
{v_tan{dbc{2,svfnp{{{tan{5786
{{dac{1,3{{{{5787
{{dtc{27,/tan/{{{{5788
{{dac{6,s_tan{{{{5789
{{dac{1,1{{{{5790
{v_atn{dbc{2,svfnp{{{atan{5802
{{dac{1,4{{{{5803
{{dtc{27,/atan/{{{{5804
{{dac{6,s_atn{{{{5805
{{dac{1,1{{{{5806
{v_chr{dbc{2,svfnp{{{char{5816
{{dac{1,4{{{{5817
{{dtc{27,/char/{{{{5818
{{dac{6,s_chr{{{{5819
{{dac{1,1{{{{5820
{v_chp{dbc{2,svfnp{{{chop{5824
{{dac{1,4{{{{5825
{{dtc{27,/chop/{{{{5826
{{dac{6,s_chp{{{{5827
{{dac{1,1{{{{5828
{v_cod{dbc{2,svfnk{{{code{5830
{{dac{1,4{{{{5831
{{dtc{27,/code/{{{{5832
{{dac{2,k_cod{{{{5833
{{dac{6,s_cod{{{{5834
{{dac{1,1{{{{5835
{v_cop{dbc{2,svfnn{{{copy{5837
{{dac{1,4{{{{5838
{{dtc{27,/copy/{{{{5839
{{dac{6,s_cop{{{{5840
{{dac{1,1{{{{5841
{{ejc{{{{{5842
*      standard variable blocks (continued)
{v_dat{dbc{2,svfnn{{{data{5846
{{dac{1,4{{{{5847
{{dtc{27,/data/{{{{5848
{{dac{6,s_dat{{{{5849
{{dac{1,1{{{{5850
{v_dte{dbc{2,svfnn{{{date{5852
{{dac{1,4{{{{5853
{{dtc{27,/date/{{{{5854
{{dac{6,s_dte{{{{5855
{{dac{1,1{{{{5856
{v_dmp{dbc{2,svfnk{{{dump{5858
{{dac{1,4{{{{5859
{{dtc{27,/dump/{{{{5860
{{dac{2,k_dmp{{{{5861
{{dac{6,s_dmp{{{{5862
{{dac{1,1{{{{5863
{v_dup{dbc{2,svfnn{{{dupl{5865
{{dac{1,4{{{{5866
{{dtc{27,/dupl/{{{{5867
{{dac{6,s_dup{{{{5868
{{dac{1,2{{{{5869
{v_evl{dbc{2,svfnn{{{eval{5871
{{dac{1,4{{{{5872
{{dtc{27,/eval/{{{{5873
{{dac{6,s_evl{{{{5874
{{dac{1,1{{{{5875
{v_ext{dbc{2,svfnn{{{exit{5879
{{dac{1,4{{{{5880
{{dtc{27,/exit/{{{{5881
{{dac{6,s_ext{{{{5882
{{dac{1,2{{{{5883
{v_fal{dbc{2,svkvc{{{fail{5886
{{dac{1,4{{{{5887
{{dtc{27,/fail/{{{{5888
{{dac{2,k_fal{{{{5889
{{dac{4,ndfal{{{{5890
{v_fil{dbc{2,svknm{{{file{5893
{{dac{1,4{{{{5894
{{dtc{27,/file/{{{{5895
{{dac{2,k_fil{{{{5896
{v_hst{dbc{2,svfnn{{{host{5899
{{dac{1,4{{{{5900
{{dtc{27,/host/{{{{5901
{{dac{6,s_hst{{{{5902
{{dac{1,5{{{{5903
{{ejc{{{{{5904
*      standard variable blocks (continued)
{v_itm{dbc{2,svfnf{{{item{5908
{{dac{1,4{{{{5909
{{dtc{27,/item/{{{{5910
{{dac{6,s_itm{{{{5911
{{dac{1,999{{{{5912
{v_lin{dbc{2,svknm{{{line{5915
{{dac{1,4{{{{5916
{{dtc{27,/line/{{{{5917
{{dac{2,k_lin{{{{5918
{v_lod{dbc{2,svfnn{{{load{5923
{{dac{1,4{{{{5924
{{dtc{27,/load/{{{{5925
{{dac{6,s_lod{{{{5926
{{dac{1,2{{{{5927
{v_lpd{dbc{2,svfnp{{{lpad{5930
{{dac{1,4{{{{5931
{{dtc{27,/lpad/{{{{5932
{{dac{6,s_lpd{{{{5933
{{dac{1,3{{{{5934
{v_rpd{dbc{2,svfnp{{{rpad{5936
{{dac{1,4{{{{5937
{{dtc{27,/rpad/{{{{5938
{{dac{6,s_rpd{{{{5939
{{dac{1,3{{{{5940
{v_rps{dbc{2,svfnp{{{rpos{5942
{{dac{1,4{{{{5943
{{dtc{27,/rpos/{{{{5944
{{dac{6,s_rps{{{{5945
{{dac{1,1{{{{5946
{v_rtb{dbc{2,svfnp{{{rtab{5948
{{dac{1,4{{{{5949
{{dtc{27,/rtab/{{{{5950
{{dac{6,s_rtb{{{{5951
{{dac{1,1{{{{5952
{v_si_{dbc{2,svfnp{{{size{5954
{{dac{1,4{{{{5955
{{dtc{27,/size/{{{{5956
{{dac{6,s_si_{{{{5957
{{dac{1,1{{{{5958
{v_srt{dbc{2,svfnn{{{sort{5963
{{dac{1,4{{{{5964
{{dtc{27,/sort/{{{{5965
{{dac{6,s_srt{{{{5966
{{dac{1,2{{{{5967
{v_spn{dbc{2,svfnp{{{span{5969
{{dac{1,4{{{{5970
{{dtc{27,/span/{{{{5971
{{dac{6,s_spn{{{{5972
{{dac{1,1{{{{5973
{{ejc{{{{{5974
*      standard variable blocks (continued)
{v_sqr{dbc{2,svfnp{{{sqrt{5980
{{dac{1,4{{{{5981
{{dtc{27,/sqrt/{{{{5982
{{dac{6,s_sqr{{{{5983
{{dac{1,1{{{{5984
{v_stn{dbc{2,svknm{{{stno{5986
{{dac{1,4{{{{5987
{{dtc{27,/stno/{{{{5988
{{dac{2,k_stn{{{{5989
{v_tim{dbc{2,svfnn{{{time{5991
{{dac{1,4{{{{5992
{{dtc{27,/time/{{{{5993
{{dac{6,s_tim{{{{5994
{{dac{1,0{{{{5995
{v_trm{dbc{2,svfnk{{{trim{5997
{{dac{1,4{{{{5998
{{dtc{27,/trim/{{{{5999
{{dac{2,k_trm{{{{6000
{{dac{6,s_trm{{{{6001
{{dac{1,1{{{{6002
{v_abe{dbc{2,svknm{{{abend{6004
{{dac{1,5{{{{6005
{{dtc{27,/abend/{{{{6006
{{dac{2,k_abe{{{{6007
{v_abo{dbc{2,svkvl{{{abort{6009
{{dac{1,5{{{{6010
{{dtc{27,/abort/{{{{6011
{{dac{2,k_abo{{{{6012
{{dac{6,l_abo{{{{6013
{{dac{4,ndabo{{{{6014
{v_app{dbc{2,svfnf{{{apply{6016
{{dac{1,5{{{{6017
{{dtc{27,/apply/{{{{6018
{{dac{6,s_app{{{{6019
{{dac{1,999{{{{6020
{v_abn{dbc{2,svfnp{{{arbno{6022
{{dac{1,5{{{{6023
{{dtc{27,/arbno/{{{{6024
{{dac{6,s_abn{{{{6025
{{dac{1,1{{{{6026
{v_arr{dbc{2,svfnn{{{array{6028
{{dac{1,5{{{{6029
{{dtc{27,/array/{{{{6030
{{dac{6,s_arr{{{{6031
{{dac{1,2{{{{6032
{{ejc{{{{{6033
*      standard variable blocks (continued)
{v_brk{dbc{2,svfnp{{{break{6037
{{dac{1,5{{{{6038
{{dtc{27,/break/{{{{6039
{{dac{6,s_brk{{{{6040
{{dac{1,1{{{{6041
{v_clr{dbc{2,svfnn{{{clear{6043
{{dac{1,5{{{{6044
{{dtc{27,/clear/{{{{6045
{{dac{6,s_clr{{{{6046
{{dac{1,1{{{{6047
{v_ejc{dbc{2,svfnn{{{eject{6057
{{dac{1,5{{{{6058
{{dtc{27,/eject/{{{{6059
{{dac{6,s_ejc{{{{6060
{{dac{1,1{{{{6061
{v_fen{dbc{2,svfpk{{{fence{6063
{{dac{1,5{{{{6064
{{dtc{27,/fence/{{{{6065
{{dac{2,k_fen{{{{6066
{{dac{6,s_fnc{{{{6067
{{dac{1,1{{{{6068
{{dac{4,ndfen{{{{6069
{v_fld{dbc{2,svfnn{{{field{6071
{{dac{1,5{{{{6072
{{dtc{27,/field/{{{{6073
{{dac{6,s_fld{{{{6074
{{dac{1,2{{{{6075
{v_idn{dbc{2,svfpr{{{ident{6077
{{dac{1,5{{{{6078
{{dtc{27,/ident/{{{{6079
{{dac{6,s_idn{{{{6080
{{dac{1,2{{{{6081
{v_inp{dbc{2,svfnk{{{input{6083
{{dac{1,5{{{{6084
{{dtc{27,/input/{{{{6085
{{dac{2,k_inp{{{{6086
{{dac{6,s_inp{{{{6087
{{dac{1,3{{{{6088
{v_lcs{dbc{2,svkwc{{{lcase{6091
{{dac{1,5{{{{6092
{{dtc{27,/lcase/{{{{6093
{{dac{2,k_lcs{{{{6094
{v_loc{dbc{2,svfnn{{{local{6097
{{dac{1,5{{{{6098
{{dtc{27,/local/{{{{6099
{{dac{6,s_loc{{{{6100
{{dac{1,2{{{{6101
{{ejc{{{{{6102
*      standard variable blocks (continued)
{v_ops{dbc{2,svfnn{{{opsyn{6106
{{dac{1,5{{{{6107
{{dtc{27,/opsyn/{{{{6108
{{dac{6,s_ops{{{{6109
{{dac{1,3{{{{6110
{v_rmd{dbc{2,svfnp{{{remdr{6112
{{dac{1,5{{{{6113
{{dtc{27,/remdr/{{{{6114
{{dac{6,s_rmd{{{{6115
{{dac{1,2{{{{6116
{v_rsr{dbc{2,svfnn{{{rsort{6120
{{dac{1,5{{{{6121
{{dtc{27,/rsort/{{{{6122
{{dac{6,s_rsr{{{{6123
{{dac{1,2{{{{6124
{v_tbl{dbc{2,svfnn{{{table{6127
{{dac{1,5{{{{6128
{{dtc{27,/table/{{{{6129
{{dac{6,s_tbl{{{{6130
{{dac{1,3{{{{6131
{v_tra{dbc{2,svfnk{{{trace{6133
{{dac{1,5{{{{6134
{{dtc{27,/trace/{{{{6135
{{dac{2,k_tra{{{{6136
{{dac{6,s_tra{{{{6137
{{dac{1,4{{{{6138
{v_ucs{dbc{2,svkwc{{{ucase{6141
{{dac{1,5{{{{6142
{{dtc{27,/ucase/{{{{6143
{{dac{2,k_ucs{{{{6144
{v_anc{dbc{2,svknm{{{anchor{6147
{{dac{1,6{{{{6148
{{dtc{27,/anchor/{{{{6149
{{dac{2,k_anc{{{{6150
{v_bkx{dbc{2,svfnp{{{breakx{6161
{{dac{1,6{{{{6162
{{dtc{27,/breakx/{{{{6163
{{dac{6,s_bkx{{{{6164
{{dac{1,1{{{{6165
{v_def{dbc{2,svfnn{{{define{6176
{{dac{1,6{{{{6177
{{dtc{27,/define/{{{{6178
{{dac{6,s_def{{{{6179
{{dac{1,2{{{{6180
{v_det{dbc{2,svfnn{{{detach{6182
{{dac{1,6{{{{6183
{{dtc{27,/detach/{{{{6184
{{dac{6,s_det{{{{6185
{{dac{1,1{{{{6186
{{ejc{{{{{6187
*      standard variable blocks (continued)
{v_dif{dbc{2,svfpr{{{differ{6191
{{dac{1,6{{{{6192
{{dtc{27,/differ/{{{{6193
{{dac{6,s_dif{{{{6194
{{dac{1,2{{{{6195
{v_ftr{dbc{2,svknm{{{ftrace{6197
{{dac{1,6{{{{6198
{{dtc{27,/ftrace/{{{{6199
{{dac{2,k_ftr{{{{6200
{v_lst{dbc{2,svknm{{{lastno{6211
{{dac{1,6{{{{6212
{{dtc{27,/lastno/{{{{6213
{{dac{2,k_lst{{{{6214
{v_nay{dbc{2,svfnp{{{notany{6216
{{dac{1,6{{{{6217
{{dtc{27,/notany/{{{{6218
{{dac{6,s_nay{{{{6219
{{dac{1,1{{{{6220
{v_oup{dbc{2,svfnk{{{output{6222
{{dac{1,6{{{{6223
{{dtc{27,/output/{{{{6224
{{dac{2,k_oup{{{{6225
{{dac{6,s_oup{{{{6226
{{dac{1,3{{{{6227
{v_ret{dbc{2,svlbl{{{return{6229
{{dac{1,6{{{{6230
{{dtc{27,/return/{{{{6231
{{dac{6,l_rtn{{{{6232
{v_rew{dbc{2,svfnn{{{rewind{6234
{{dac{1,6{{{{6235
{{dtc{27,/rewind/{{{{6236
{{dac{6,s_rew{{{{6237
{{dac{1,1{{{{6238
{v_stt{dbc{2,svfnn{{{stoptr{6240
{{dac{1,6{{{{6241
{{dtc{27,/stoptr/{{{{6242
{{dac{6,s_stt{{{{6243
{{dac{1,2{{{{6244
{{ejc{{{{{6245
*      standard variable blocks (continued)
{v_sub{dbc{2,svfnn{{{substr{6249
{{dac{1,6{{{{6250
{{dtc{27,/substr/{{{{6251
{{dac{6,s_sub{{{{6252
{{dac{1,3{{{{6253
{v_unl{dbc{2,svfnn{{{unload{6255
{{dac{1,6{{{{6256
{{dtc{27,/unload/{{{{6257
{{dac{6,s_unl{{{{6258
{{dac{1,1{{{{6259
{v_col{dbc{2,svfnn{{{collect{6261
{{dac{1,7{{{{6262
{{dtc{27,/collect/{{{{6263
{{dac{6,s_col{{{{6264
{{dac{1,1{{{{6265
{v_com{dbc{2,svknm{{{compare{6268
{{dac{1,7{{{{6269
{{dtc{27,/compare/{{{{6270
{{dac{2,k_com{{{{6271
{v_cnv{dbc{2,svfnn{{{convert{6274
{{dac{1,7{{{{6275
{{dtc{27,/convert/{{{{6276
{{dac{6,s_cnv{{{{6277
{{dac{1,2{{{{6278
{v_enf{dbc{2,svfnn{{{endfile{6280
{{dac{1,7{{{{6281
{{dtc{27,/endfile/{{{{6282
{{dac{6,s_enf{{{{6283
{{dac{1,1{{{{6284
{v_etx{dbc{2,svknm{{{errtext{6286
{{dac{1,7{{{{6287
{{dtc{27,/errtext/{{{{6288
{{dac{2,k_etx{{{{6289
{v_ert{dbc{2,svknm{{{errtype{6291
{{dac{1,7{{{{6292
{{dtc{27,/errtype/{{{{6293
{{dac{2,k_ert{{{{6294
{v_frt{dbc{2,svlbl{{{freturn{6296
{{dac{1,7{{{{6297
{{dtc{27,/freturn/{{{{6298
{{dac{6,l_frt{{{{6299
{v_int{dbc{2,svfpr{{{integer{6301
{{dac{1,7{{{{6302
{{dtc{27,/integer/{{{{6303
{{dac{6,s_int{{{{6304
{{dac{1,1{{{{6305
{v_nrt{dbc{2,svlbl{{{nreturn{6307
{{dac{1,7{{{{6308
{{dtc{27,/nreturn/{{{{6309
{{dac{6,l_nrt{{{{6310
{{ejc{{{{{6311
*      standard variable blocks (continued)
{v_pfl{dbc{2,svknm{{{profile{6318
{{dac{1,7{{{{6319
{{dtc{27,/profile/{{{{6320
{{dac{2,k_pfl{{{{6321
{v_rpl{dbc{2,svfnp{{{replace{6324
{{dac{1,7{{{{6325
{{dtc{27,/replace/{{{{6326
{{dac{6,s_rpl{{{{6327
{{dac{1,3{{{{6328
{v_rvs{dbc{2,svfnp{{{reverse{6330
{{dac{1,7{{{{6331
{{dtc{27,/reverse/{{{{6332
{{dac{6,s_rvs{{{{6333
{{dac{1,1{{{{6334
{v_rtn{dbc{2,svknm{{{rtntype{6336
{{dac{1,7{{{{6337
{{dtc{27,/rtntype/{{{{6338
{{dac{2,k_rtn{{{{6339
{v_stx{dbc{2,svfnn{{{setexit{6341
{{dac{1,7{{{{6342
{{dtc{27,/setexit/{{{{6343
{{dac{6,s_stx{{{{6344
{{dac{1,1{{{{6345
{v_stc{dbc{2,svknm{{{stcount{6347
{{dac{1,7{{{{6348
{{dtc{27,/stcount/{{{{6349
{{dac{2,k_stc{{{{6350
{v_stl{dbc{2,svknm{{{stlimit{6352
{{dac{1,7{{{{6353
{{dtc{27,/stlimit/{{{{6354
{{dac{2,k_stl{{{{6355
{v_suc{dbc{2,svkvc{{{succeed{6357
{{dac{1,7{{{{6358
{{dtc{27,/succeed/{{{{6359
{{dac{2,k_suc{{{{6360
{{dac{4,ndsuc{{{{6361
{v_alp{dbc{2,svkwc{{{alphabet{6363
{{dac{1,8{{{{6364
{{dtc{27,/alphabet/{{{{6365
{{dac{2,k_alp{{{{6366
{v_cnt{dbc{2,svlbl{{{continue{6368
{{dac{1,8{{{{6369
{{dtc{27,/continue/{{{{6370
{{dac{6,l_cnt{{{{6371
{{ejc{{{{{6372
*      standard variable blocks (continued)
{v_dtp{dbc{2,svfnp{{{datatype{6376
{{dac{1,8{{{{6377
{{dtc{27,/datatype/{{{{6378
{{dac{6,s_dtp{{{{6379
{{dac{1,1{{{{6380
{v_erl{dbc{2,svknm{{{errlimit{6382
{{dac{1,8{{{{6383
{{dtc{27,/errlimit/{{{{6384
{{dac{2,k_erl{{{{6385
{v_fnc{dbc{2,svknm{{{fnclevel{6387
{{dac{1,8{{{{6388
{{dtc{27,/fnclevel/{{{{6389
{{dac{2,k_fnc{{{{6390
{v_fls{dbc{2,svknm{{{fullscan{6392
{{dac{1,8{{{{6393
{{dtc{27,/fullscan/{{{{6394
{{dac{2,k_fls{{{{6395
{v_lfl{dbc{2,svknm{{{lastfile{6398
{{dac{1,8{{{{6399
{{dtc{27,/lastfile/{{{{6400
{{dac{2,k_lfl{{{{6401
{v_lln{dbc{2,svknm{{{lastline{6405
{{dac{1,8{{{{6406
{{dtc{27,/lastline/{{{{6407
{{dac{2,k_lln{{{{6408
{v_mxl{dbc{2,svknm{{{maxlngth{6411
{{dac{1,8{{{{6412
{{dtc{27,/maxlngth/{{{{6413
{{dac{2,k_mxl{{{{6414
{v_ter{dbc{1,0{{{terminal{6416
{{dac{1,8{{{{6417
{{dtc{27,/terminal/{{{{6418
{{dac{1,0{{{{6419
{v_bsp{dbc{2,svfnn{{{backspace{6422
{{dac{1,9{{{{6423
{{dtc{27,/backspace/{{{{6424
{{dac{6,s_bsp{{{{6425
{{dac{1,1{{{{6426
{v_pro{dbc{2,svfnn{{{prototype{6429
{{dac{1,9{{{{6430
{{dtc{27,/prototype/{{{{6431
{{dac{6,s_pro{{{{6432
{{dac{1,1{{{{6433
{v_scn{dbc{2,svlbl{{{scontinue{6435
{{dac{1,9{{{{6436
{{dtc{27,/scontinue/{{{{6437
{{dac{6,l_scn{{{{6438
{{dbc{1,0{{{dummy entry to end list{6440
{{dac{1,10{{{length gt 9 (scontinue){6441
{{ejc{{{{{6442
*      list of svblk pointers for keywords to be dumped. the
*      list is in the order which appears on the dump output.
{vdmkw{dac{4,v_anc{{{anchor{6447
{{dac{4,v_cod{{{code{6451
{{dac{1,1{{{compare not printed{6456
{{dac{4,v_dmp{{{dump{6459
{{dac{4,v_erl{{{errlimit{6460
{{dac{4,v_etx{{{errtext{6461
{{dac{4,v_ert{{{errtype{6462
{{dac{4,v_fil{{{file{6464
{{dac{4,v_fnc{{{fnclevel{6466
{{dac{4,v_ftr{{{ftrace{6467
{{dac{4,v_fls{{{fullscan{6468
{{dac{4,v_inp{{{input{6469
{{dac{4,v_lfl{{{lastfile{6471
{{dac{4,v_lln{{{lastline{6474
{{dac{4,v_lst{{{lastno{6476
{{dac{4,v_lin{{{line{6478
{{dac{4,v_mxl{{{maxlength{6480
{{dac{4,v_oup{{{output{6481
{{dac{4,v_pfl{{{profile{6484
{{dac{4,v_rtn{{{rtntype{6486
{{dac{4,v_stc{{{stcount{6487
{{dac{4,v_stl{{{stlimit{6488
{{dac{4,v_stn{{{stno{6489
{{dac{4,v_tra{{{trace{6490
{{dac{4,v_trm{{{trim{6491
{{dac{1,0{{{end of list{6492
*      table used by gtnvr to search svblk lists
{vsrch{dac{1,0{{{dummy entry to get proper indexing{6496
{{dac{4,v_eqf{{{start of 1 char variables (none){6497
{{dac{4,v_eqf{{{start of 2 char variables{6498
{{dac{4,v_any{{{start of 3 char variables{6499
{{dac{4,v_atn{{{start of 4 char variables{6501
{{dac{4,v_abe{{{start of 5 char variables{6509
{{dac{4,v_anc{{{start of 6 char variables{6510
{{dac{4,v_col{{{start of 7 char variables{6511
{{dac{4,v_alp{{{start of 8 char variables{6512
{{dac{4,v_bsp{{{start of 9 char variables{6514
*      last location in constant section
{c_yyy{dac{1,0{{{last location in constant section{6521
{{ttl{27,s p i t b o l -- working storage section{{{{6522
*      the working storage section contains areas which are
*      changed during execution of the program. the value
*      assembled is the initial value before execution starts.
*      all these areas are fixed length areas. variable length
*      data is stored in the static or dynamic regions of the
*      allocated data areas.
*      the values in this area are described either as work
*      areas or as global values. a work area is used in an
*      ephemeral manner and the value is not saved from one
*      entry into a routine to another. a global value is a
*      less temporary location whose value is saved from one
*      call to another.
*      w_aaa marks the start of the working section whilst
*      w_yyy marks its end.  g_aaa marks the division between
*      temporary and global values.
*      global values are further subdivided to facilitate
*      processing by the garbage collector. r_aaa through
*      r_yyy are global values that may point into dynamic
*      storage and hence must be relocated after each garbage
*      collection.  they also serve as root pointers to all
*      allocated data that must be preserved.  pointers between
*      a_aaa and r_aaa may point into code, static storage,
*      or mark the limits of dynamic memory.  these pointers
*      must be adjusted when the working section is saved to a
*      file and subsequently reloaded at a different address.
*      a general part of the approach in this program is not
*      to overlap work areas between procedures even though a
*      small amount of space could be saved. such overlap is
*      considered a source of program errors and decreases the
*      information left behind after a system crash of any kind.
*      the names of these locations are labels with five letter
*      (a-y,_) names. as far as possible the order is kept
*      alphabetical by these names but in some cases there
*      are slight departures caused by other order requirements.
*      unless otherwise documented, the order of work areas
*      does not affect the execution of the spitbol program.
{{sec{{{{start of working storage section{6568
{{ejc{{{{{6569
*      this area is not cleared by initial code
{cmlab{dac{6,b_scl{{{string used to check label legality{6573
{{dac{1,2{{{{6574
{{dtc{27,/  /{{{{6575
*      label to mark start of work area
{w_aaa{dac{1,0{{{{6579
*      work areas for acess procedure
{actrm{dac{1,0{{{trim indicator{6583
*      work areas for alloc procedure
{aldyn{dac{1,0{{{amount of dynamic store{6587
{allia{dic{16,+0{{{dump ia{6588
{allsv{dac{1,0{{{save wb in alloc{6589
*      work areas for alost procedure
{alsta{dac{1,0{{{save wa in alost{6593
*      work areas for array function (s_arr)
{arcdm{dac{1,0{{{count dimensions{6597
{arnel{dic{16,+0{{{count elements{6598
{arptr{dac{1,0{{{offset ptr into arblk{6599
{arsvl{dic{16,+0{{{save integer low bound{6600
{{ejc{{{{{6601
*      work areas for arref routine
{arfsi{dic{16,+0{{{save current evolving subscript{6605
{arfxs{dac{1,0{{{save base stack pointer{6606
*      work areas for b_efc block routine
{befof{dac{1,0{{{save offset ptr into efblk{6610
*      work areas for b_pfc block routine
{bpfpf{dac{1,0{{{save pfblk pointer{6614
{bpfsv{dac{1,0{{{save old function value{6615
{bpfxt{dac{1,0{{{pointer to stacked arguments{6616
*      work area for collect function (s_col)
{clsvi{dic{16,+0{{{save integer argument{6620
*      work areas value for cncrd
{cnscc{dac{1,0{{{pointer to control card string{6624
{cnswc{dac{1,0{{{word count{6625
{cnr_t{dac{1,0{{{pointer to r_ttl or r_stl{6626
*      work areas for convert function (s_cnv)
{cnvtp{dac{1,0{{{save ptr into scvtb{6630
*      work areas for data function (s_dat)
{datdv{dac{1,0{{{save vrblk ptr for datatype name{6634
{datxs{dac{1,0{{{save initial stack pointer{6635
*      work areas for define function (s_def)
{deflb{dac{1,0{{{save vrblk ptr for label{6639
{defna{dac{1,0{{{count function arguments{6640
{defvr{dac{1,0{{{save vrblk ptr for function name{6641
{defxs{dac{1,0{{{save initial stack pointer{6642
*      work areas for dumpr procedure
{dmarg{dac{1,0{{{dump argument{6646
{dmpsa{dac{1,0{{{preserve wa over prtvl call{6647
{dmpsb{dac{1,0{{{preserve wb over syscm call{6649
{dmpsv{dac{1,0{{{general scratch save{6651
{dmvch{dac{1,0{{{chain pointer for variable blocks{6652
{dmpch{dac{1,0{{{save sorted vrblk chain pointer{6653
{dmpkb{dac{1,0{{{dummy kvblk for use in dumpr{6654
{dmpkt{dac{1,0{{{kvvar trblk ptr (must follow dmpkb){6655
{dmpkn{dac{1,0{{{keyword number (must follow dmpkt){6656
*      work area for dtach
{dtcnb{dac{1,0{{{name base{6660
{dtcnm{dac{1,0{{{name ptr{6661
*      work areas for dupl function (s_dup)
{dupsi{dic{16,+0{{{store integer string length{6665
*      work area for endfile (s_enf)
{enfch{dac{1,0{{{for iochn chain head{6669
{{ejc{{{{{6670
*      work areas for ertex
{ertwa{dac{1,0{{{save wa{6674
{ertwb{dac{1,0{{{save wb{6675
*      work areas for evali
{evlin{dac{1,0{{{dummy pattern block pcode{6679
{evlis{dac{1,0{{{then node (must follow evlin){6680
{evliv{dac{1,0{{{value of parm1 (must follow evlis){6681
{evlio{dac{1,0{{{ptr to original node{6682
{evlif{dac{1,0{{{flag for simple/complex argument{6683
*      work area for expan
{expsv{dac{1,0{{{save op dope vector pointer{6687
*      work areas for gbcol procedure
{gbcfl{dac{1,0{{{garbage collector active flag{6691
{gbclm{dac{1,0{{{pointer to last move block (pass 3){6692
{gbcnm{dac{1,0{{{dummy first move block{6693
{gbcns{dac{1,0{{{rest of dummy block (follows gbcnm){6694
{gbcia{dic{16,+0{{{dump ia{6700
{gbcsd{dac{1,0{{{first address beyond sediment{6701
{gbcsf{dac{1,0{{{free space within sediment{6702
{gbsva{dac{1,0{{{save wa{6704
{gbsvb{dac{1,0{{{save wb{6705
{gbsvc{dac{1,0{{{save wc{6706
*      work areas for gtnvr procedure
{gnvhe{dac{1,0{{{ptr to end of hash chain{6710
{gnvnw{dac{1,0{{{number of words in string name{6711
{gnvsa{dac{1,0{{{save wa{6712
{gnvsb{dac{1,0{{{save wb{6713
{gnvsp{dac{1,0{{{pointer into vsrch table{6714
{gnvst{dac{1,0{{{pointer to chars of string{6715
*      work areas for gtarr
{gtawa{dac{1,0{{{save wa{6719
*      work areas for gtint
{gtina{dac{1,0{{{save wa{6723
{gtinb{dac{1,0{{{save wb{6724
{{ejc{{{{{6725
*      work areas for gtnum procedure
{gtnnf{dac{1,0{{{zero/nonzero for result +/-{6729
{gtnsi{dic{16,+0{{{general integer save{6730
{gtndf{dac{1,0{{{0/1 for dec point so far no/yes{6733
{gtnes{dac{1,0{{{zero/nonzero exponent +/-{6734
{gtnex{dic{16,+0{{{real exponent{6735
{gtnsc{dac{1,0{{{scale (places after point){6736
{gtnsr{drc{17,+0.0{{{general real save{6737
{gtnrd{dac{1,0{{{flag for ok real number{6738
*      work areas for gtpat procedure
{gtpsb{dac{1,0{{{save wb{6743
*      work areas for gtstg procedure
{gtssf{dac{1,0{{{0/1 for result +/-{6747
{gtsvc{dac{1,0{{{save wc{6748
{gtsvb{dac{1,0{{{save wb{6749
{gtses{dac{1,0{{{char + or - for exponent +/-{6754
{gtsrs{drc{17,+0.0{{{general real save{6755
*      work areas for gtvar procedure
{gtvrc{dac{1,0{{{save wc{6761
*      work areas for ioput
{ioptt{dac{1,0{{{type of association{6776
*      work areas for load function
{lodfn{dac{1,0{{{pointer to vrblk for func name{6782
{lodna{dac{1,0{{{count number of arguments{6783
*      mxint is value of maximum positive integer. it is computed at runtime to allow
*      the compilation of spitbol on a machine with smaller word size the the target.
{mxint{dac{1,0{{{{6789
*      work area for profiler
{pfsvw{dac{1,0{{{to save a w-reg{6795
*      work areas for prtnm procedure
{prnsi{dic{16,+0{{{scratch integer loc{6800
*      work areas for prtsn procedure
{prsna{dac{1,0{{{save wa{6804
*      work areas for prtst procedure
{prsva{dac{1,0{{{save wa{6808
{prsvb{dac{1,0{{{save wb{6809
{prsvc{dac{1,0{{{save char counter{6810
*      work area for prtnl
{prtsa{dac{1,0{{{save wa{6814
{prtsb{dac{1,0{{{save wb{6815
*      work area for prtvl
{prvsi{dac{1,0{{{save idval{6819
*      work areas for pattern match routines
{psave{dac{1,0{{{temporary save for current node ptr{6823
{psavc{dac{1,0{{{save cursor in p_spn, p_str{6824
*      work area for relaj routine
{rlals{dac{1,0{{{ptr to list of bounds and adjusts{6829
*      work area for reldn routine
{rldcd{dac{1,0{{{save code adjustment{6833
{rldst{dac{1,0{{{save static adjustment{6834
{rldls{dac{1,0{{{save list pointer{6835
*      work areas for retrn routine
{rtnbp{dac{1,0{{{to save a block pointer{6840
{rtnfv{dac{1,0{{{new function value (result){6841
{rtnsv{dac{1,0{{{old function value (saved value){6842
*      work areas for substr function (s_sub)
{sbssv{dac{1,0{{{save third argument{6846
*      work areas for scan procedure
{scnsa{dac{1,0{{{save wa{6850
{scnsb{dac{1,0{{{save wb{6851
{scnsc{dac{1,0{{{save wc{6852
{scnof{dac{1,0{{{save offset{6853
{{ejc{{{{{6856
*      work area used by sorta, sortc, sortf, sorth
{srtdf{dac{1,0{{{datatype field name{6860
{srtfd{dac{1,0{{{found dfblk address{6861
{srtff{dac{1,0{{{found field name{6862
{srtfo{dac{1,0{{{offset to field name{6863
{srtnr{dac{1,0{{{number of rows{6864
{srtof{dac{1,0{{{offset within row to sort key{6865
{srtrt{dac{1,0{{{root offset{6866
{srts1{dac{1,0{{{save offset 1{6867
{srts2{dac{1,0{{{save offset 2{6868
{srtsc{dac{1,0{{{save wc{6869
{srtsf{dac{1,0{{{sort array first row offset{6870
{srtsn{dac{1,0{{{save n{6871
{srtso{dac{1,0{{{offset to a(0){6872
{srtsr{dac{1,0{{{0, non-zero for sort, rsort{6873
{srtst{dac{1,0{{{stride from one row to next{6874
{srtwc{dac{1,0{{{dump wc{6875
*      work areas for stopr routine
{stpsi{dic{16,+0{{{save value of stcount{6880
{stpti{dic{16,+0{{{save time elapsed{6881
*      work areas for tfind procedure
{tfnsi{dic{16,+0{{{number of headers{6885
*      work areas for xscan procedure
{xscrt{dac{1,0{{{save return code{6889
{xscwb{dac{1,0{{{save register wb{6890
*      start of global values in working section
{g_aaa{dac{1,0{{{{6894
*      global value for alloc procedure
{alfsf{dic{16,+0{{{factor in free store pcntage check{6898
*      global values for cmpil procedure
{cmerc{dac{1,0{{{count of initial compile errors{6902
{cmpln{dac{1,0{{{line number of first line of stmt{6903
{cmpxs{dac{1,0{{{save stack ptr in case of errors{6904
{cmpsn{dac{1,1{{{number of next statement to compile{6905
*      global values for cncrd
{cnsil{dac{1,0{{{save scnil during include process.{6910
{cnind{dac{1,0{{{current include file nest level{6911
{cnspt{dac{1,0{{{save scnpt during include process.{6912
{cnttl{dac{1,0{{{flag for -title, -stitl{6914
*      global flag for suppression of compilation statistics.
{cpsts{dac{1,0{{{suppress comp. stats if non zero{6918
*      global values for control card switches
{cswdb{dac{1,0{{{0/1 for -single/-double{6922
{cswer{dac{1,0{{{0/1 for -errors/-noerrors{6923
{cswex{dac{1,0{{{0/1 for -execute/-noexecute{6924
{cswfl{dac{1,1{{{0/1 for -nofail/-fail{6925
{cswin{dac{2,iniln{{{xxx for -inxxx{6926
{cswls{dac{1,1{{{0/1 for -nolist/-list{6927
{cswno{dac{1,0{{{0/1 for -optimise/-noopt{6928
{cswpr{dac{1,0{{{0/1 for -noprint/-print{6929
*      global location used by patst procedure
{ctmsk{dbc{1,0{{{last bit position used in r_ctp{6933
{curid{dac{1,0{{{current id value{6934
{{ejc{{{{{6935
*      global value for cdwrd procedure
{cwcof{dac{1,0{{{next word offset in current ccblk{6939
*      global locations for dynamic storage pointers
{dnams{dac{1,0{{{size of sediment in baus{6944
*      global area for error processing.
{erich{dac{1,0{{{copy error reports to int.chan if 1{6949
{erlst{dac{1,0{{{for listr when errors go to int.ch.{6950
{errft{dac{1,0{{{fatal error flag{6951
{errsp{dac{1,0{{{error suppression flag{6952
*      global flag for suppression of execution stats
{exsts{dac{1,0{{{suppress exec stats if set{6956
*      global values for exfal and return
{flprt{dac{1,0{{{location of fail offset for return{6960
{flptr{dac{1,0{{{location of failure offset on stack{6961
*      global location to count garbage collections (gbcol)
{gbsed{dic{16,+0{{{factor in sediment pcntage check{6966
{gbcnt{dac{1,0{{{count of garbage collections{6968
*      global value for gtcod and gtexp
{gtcef{dac{1,0{{{save fail ptr in case of error{6972
*      global locations for gtstg procedure
{gtsrn{drc{17,+0.0{{{rounding factor 0.5*10**-cfp_s{6980
{gtssc{drc{17,+0.0{{{scaling value 10**cfp_s{6981
{gtswk{dac{1,0{{{ptr to work area for gtstg{6984
*      global flag for header printing
{headp{dac{1,0{{{header printed flag{6988
*      global values for variable hash table
{hshnb{dic{16,+0{{{number of hash buckets{6992
*      global areas for init
{initr{dac{1,0{{{save terminal flag{6996
{{ejc{{{{{6997
*      global values for keyword values which are stored as one
*      word integers. these values must be assembled in the
*      following order (as dictated by k_xxx definition values).
{kvabe{dac{1,0{{{abend{7003
{kvanc{dac{1,1{{{anchor{7004
{kvcod{dac{1,0{{{code{7008
{kvcom{dac{1,0{{{compare{7010
{kvdmp{dac{1,0{{{dump{7012
{kverl{dac{1,0{{{errlimit{7013
{kvert{dac{1,0{{{errtype{7014
{kvftr{dac{1,0{{{ftrace{7015
{kvfls{dac{1,1{{{fullscan{7016
{kvinp{dac{1,1{{{input{7017
{kvmxl{dac{1,5000{{{maxlength{7018
{kvoup{dac{1,1{{{output{7019
{kvpfl{dac{1,0{{{profile{7022
{kvtra{dac{1,0{{{trace{7024
{kvtrm{dac{1,1{{{trim{7025
{kvfnc{dac{1,0{{{fnclevel{7026
{kvlst{dac{1,0{{{lastno{7027
{kvlln{dac{1,0{{{lastline{7029
{kvlin{dac{1,0{{{line{7030
{kvstn{dac{1,0{{{stno{7032
*      global values for other keywords
{kvalp{dac{1,0{{{alphabet{7036
{kvrtn{dac{4,nulls{{{rtntype (scblk pointer){7037
{kvstl{dic{16,+2147483647{{{stlimit{7043
{kvstc{dic{16,+2147483647{{{stcount (counts down from stlimit){7044
*      global values for listr procedure
{lstid{dac{1,0{{{include depth of current image{7054
{lstlc{dac{1,0{{{count lines on source list page{7056
{lstnp{dac{1,0{{{max number of lines on page{7057
{lstpf{dac{1,1{{{set nonzero if current image listed{7058
{lstpg{dac{1,0{{{current source list page number{7059
{lstpo{dac{1,0{{{offset to   page nnn   message{7060
{lstsn{dac{1,0{{{remember last stmnum listed{7061
*      global maximum size of spitbol objects
{mxlen{dac{1,0{{{initialised by sysmx call{7065
*      global execution control variable
{noxeq{dac{1,0{{{set non-zero to inhibit execution{7069
*      global profiler values locations
{pfdmp{dac{1,0{{{set non-0 if &profile set non-0{7075
{pffnc{dac{1,0{{{set non-0 if funct just entered{7076
{pfstm{dic{16,+0{{{to store starting time of stmt{7077
{pfetm{dic{16,+0{{{to store ending time of stmt{7078
{pfnte{dac{1,0{{{nr of table entries{7079
{pfste{dic{16,+0{{{gets int rep of table entry size{7080
{{ejc{{{{{7083
*      global values used in pattern match routines
{pmdfl{dac{1,0{{{pattern assignment flag{7087
{pmhbs{dac{1,0{{{history stack base pointer{7088
{pmssl{dac{1,0{{{length of subject string in chars{7089
*      global values for interface polling (syspl)
{polcs{dac{1,1{{{poll interval start value{7094
{polct{dac{1,1{{{poll interval counter{7095
*      global flags used for standard file listing options
{prich{dac{1,0{{{printer on interactive channel{7100
{prstd{dac{1,0{{{tested by prtpg{7101
{prsto{dac{1,0{{{standard listing option flag{7102
*      global values for print procedures
{prbuf{dac{1,0{{{ptr to print bfr in static{7106
{precl{dac{1,0{{{extended/compact listing flag{7107
{prlen{dac{1,0{{{length of print buffer in chars{7108
{prlnw{dac{1,0{{{length of print buffer in words{7109
{profs{dac{1,0{{{offset to next location in prbuf{7110
{prtef{dac{1,0{{{endfile flag{7111
{{ejc{{{{{7112
*      global area for readr
{rdcln{dac{1,0{{{current statement line number{7116
{rdnln{dac{1,0{{{next statement line number{7117
*      global amount of memory reserved for end of execution
{rsmem{dac{1,0{{{reserve memory{7121
*      global area for stmgo counters
{stmcs{dac{1,1{{{counter startup value{7125
{stmct{dac{1,1{{{counter active value{7126
*      adjustable global values
*      all the pointers in this section can point to the
*      dynamic or the static region.
*      when a save file is reloaded, these pointers must
*      be adjusted if static or dynamic memory is now
*      at a different address.  see routine reloc for
*      additional information.
*      some values cannot be move here because of adjacency
*      constraints.  they are handled specially by reloc et al.
*      these values are kvrtn,
*      values gtswk, kvalp, and prbuf are reinitialized by
*      procedure insta, and do not need to appear here.
*      values flprt, flptr, gtcef, and stbas point into the
*      stack and are explicitly adjusted by osint's restart
*      procedure.
{a_aaa{dac{1,0{{{start of adjustable values{7148
{cmpss{dac{1,0{{{save subroutine stack ptr{7149
{dnamb{dac{1,0{{{start of dynamic area{7150
{dnamp{dac{1,0{{{next available loc in dynamic area{7151
{dname{dac{1,0{{{end of available dynamic area{7152
{hshtb{dac{1,0{{{pointer to start of vrblk hash tabl{7153
{hshte{dac{1,0{{{pointer past end of vrblk hash tabl{7154
{iniss{dac{1,0{{{save subroutine stack ptr{7155
{pftbl{dac{1,0{{{gets adrs of (imag) table base{7156
{prnmv{dac{1,0{{{vrblk ptr from last name search{7157
{statb{dac{1,0{{{start of static area{7158
{state{dac{1,0{{{end of static area{7159
{stxvr{dac{4,nulls{{{vrblk pointer or null{7160
*      relocatable global values
*      all the pointers in this section can point to blocks in
*      the dynamic storage area and must be relocated by the
*      garbage collector. they are identified by r_xxx names.
{r_aaa{dac{1,0{{{start of relocatable values{7169
{r_arf{dac{1,0{{{array block pointer for arref{7170
{r_ccb{dac{1,0{{{ptr to ccblk being built (cdwrd){7171
{r_cim{dac{1,0{{{ptr to current compiler input str{7172
{r_cmp{dac{1,0{{{copy of r_cim used in cmpil{7173
{r_cni{dac{1,0{{{ptr to next compiler input string{7174
{r_cnt{dac{1,0{{{cdblk pointer for setexit continue{7175
{r_cod{dac{1,0{{{pointer to current cdblk or exblk{7176
{r_ctp{dac{1,0{{{ptr to current ctblk for patst{7177
{r_cts{dac{1,0{{{ptr to last string scanned by patst{7178
{r_ert{dac{1,0{{{trblk pointer for errtype trace{7179
{r_etx{dac{4,nulls{{{pointer to errtext string{7180
{r_exs{dac{1,0{{{= save xl in expdm{7181
{r_fcb{dac{1,0{{{fcblk chain head{7182
{r_fnc{dac{1,0{{{trblk pointer for fnclevel trace{7183
{r_gtc{dac{1,0{{{keep code ptr for gtcod,gtexp{7184
{r_ici{dac{1,0{{{saved r_cim during include process.{7186
{r_ifa{dac{1,0{{{array of file names by incl. depth{7188
{r_ifl{dac{1,0{{{array of line nums by include depth{7189
{r_ifn{dac{1,0{{{last include file name{7191
{r_inc{dac{1,0{{{table of include file names seen{7192
{r_io1{dac{1,0{{{file arg1 for ioput{7194
{r_io2{dac{1,0{{{file arg2 for ioput{7195
{r_iof{dac{1,0{{{fcblk ptr or 0{7196
{r_ion{dac{1,0{{{name base ptr{7197
{r_iop{dac{1,0{{{predecessor block ptr for ioput{7198
{r_iot{dac{1,0{{{trblk ptr for ioput{7199
{r_pms{dac{1,0{{{subject string ptr in pattern match{7204
{r_ra2{dac{1,0{{{replace second argument last time{7205
{r_ra3{dac{1,0{{{replace third argument last time{7206
{r_rpt{dac{1,0{{{ptr to ctblk replace table last usd{7207
{r_scp{dac{1,0{{{save pointer from last scane call{7208
{r_sfc{dac{4,nulls{{{current source file name{7210
{r_sfn{dac{1,0{{{ptr to source file name table{7211
{r_sxl{dac{1,0{{{preserve xl in sortc{7213
{r_sxr{dac{1,0{{{preserve xr in sorta/sortc{7214
{r_stc{dac{1,0{{{trblk pointer for stcount trace{7215
{r_stl{dac{1,0{{{source listing sub-title{7216
{r_sxc{dac{1,0{{{code (cdblk) ptr for setexit trap{7217
{r_ttl{dac{4,nulls{{{source listing title{7218
{r_xsc{dac{1,0{{{string pointer for xscan{7219
{{ejc{{{{{7220
*      the remaining pointers in this list are used to point
*      to function blocks for normally undefined operators.
{r_uba{dac{4,stndo{{{binary at{7225
{r_ubm{dac{4,stndo{{{binary ampersand{7226
{r_ubn{dac{4,stndo{{{binary number sign{7227
{r_ubp{dac{4,stndo{{{binary percent{7228
{r_ubt{dac{4,stndo{{{binary not{7229
{r_uub{dac{4,stndo{{{unary vertical bar{7230
{r_uue{dac{4,stndo{{{unary equal{7231
{r_uun{dac{4,stndo{{{unary number sign{7232
{r_uup{dac{4,stndo{{{unary percent{7233
{r_uus{dac{4,stndo{{{unary slash{7234
{r_uux{dac{4,stndo{{{unary exclamation{7235
{r_yyy{dac{1,0{{{last relocatable location{7236
*      global locations used in scan procedure
{scnbl{dac{1,0{{{set non-zero if scanned past blanks{7240
{scncc{dac{1,0{{{non-zero to scan control card name{7241
{scngo{dac{1,0{{{set non-zero to scan goto field{7242
{scnil{dac{1,0{{{length of current input image{7243
{scnpt{dac{1,0{{{pointer to next location in r_cim{7244
{scnrs{dac{1,0{{{set non-zero to signal rescan{7245
{scnse{dac{1,0{{{start of current element{7246
{scntp{dac{1,0{{{save syntax type from last call{7247
*      global value for indicating stage (see error section)
{stage{dac{1,0{{{initial value = initial compile{7251
{{ejc{{{{{7252
*      global stack pointer
{stbas{dac{1,0{{{pointer past stack base{7256
*      global values for setexit function (s_stx)
{stxoc{dac{1,0{{{code pointer offset{7260
{stxof{dac{1,0{{{failure offset{7261
*      global value for time keeping
{timsx{dic{16,+0{{{time at start of execution{7265
{timup{dac{1,0{{{set when time up occurs{7266
*      global values for xscan and xscni procedures
{xsofs{dac{1,0{{{offset to current location in r_xsc{7270
*      label to mark end of working section
{w_yyy{dac{1,0{{{{7274
{{ttl{27,s p i t b o l -- minimal code{{{{7275
{{sec{{{{start of program section{7276
{s_aaa{ent{2,bl__i{{{mark start of code{7277
{{ttl{27,s p i t b o l -- relocation{{{{7279
*      relocation
*      the following section provides services to osint to
*      relocate portions of the workspace.  it is used when
*      a saved memory image must be restarted at a different
*      location.
*      relaj -- relocate a list of pointers
*      (wa)                  ptr past last pointer of list
*      (wb)                  ptr to first pointer of list
*      (xl)                  list of boundaries and adjustments
*      jsr  relaj            call to process list of pointers
*      (wb)                  destroyed
{relaj{prc{25,e{1,0{{entry point{7295
{{mov{11,-(xs){7,xr{{save xr{7296
{{mov{11,-(xs){8,wa{{save wa{7297
{{mov{3,rlals{7,xl{{save ptr to list of bounds{7298
{{mov{7,xr{8,wb{{ptr to first pointer to process{7299
*      merge here to check if done
{rlaj0{mov{7,xl{3,rlals{{restore xl{7303
{{bne{7,xr{9,(xs){6,rlaj1{proceed if more to do{7304
{{mov{8,wa{10,(xs)+{{restore wa{7305
{{mov{7,xr{10,(xs)+{{restore xr{7306
{{exi{{{{return to caller{7307
*      merge here to process next pointer on list
{rlaj1{mov{8,wa{9,(xr){{load next pointer on list{7311
{{lct{8,wb{18,=rnsi_{{number of sections of adjusters{7312
*      merge here to process next section of stack list
{rlaj2{bgt{8,wa{13,rlend(xl){6,rlaj3{ok if past end of section{7316
{{blt{8,wa{13,rlstr(xl){6,rlaj3{or if before start of section{7317
{{add{8,wa{13,rladj(xl){{within section, add adjustment{7318
{{mov{9,(xr){8,wa{{return updated ptr to memory{7319
{{brn{6,rlaj4{{{done with this pointer{7320
*      here if not within section
{rlaj3{add{7,xl{19,*rssi_{{advance to next section{7324
{{bct{8,wb{6,rlaj2{{jump if more to go{7325
*      here when finished processing one pointer
{rlaj4{ica{7,xr{{{increment to next ptr on list{7329
{{brn{6,rlaj0{{{jump to check  for completion{7330
{{enp{{{{end procedure relaj{7331
{{ejc{{{{{7332
*      relcr -- create relocation info after save file reload
*      (wa)                  original s_aaa code section adr
*      (wb)                  original c_aaa constant section adr
*      (wc)                  original g_aaa working section adr
*      (xr)                  ptr to start of static region
*      (cp)                  ptr to start of dynamic region
*      (xl)                  ptr to area to receive information
*      jsr  relcr            create relocation information
*      (wa,wb,wc,xr)         destroyed
*      a block of information is built at (xl) that is used
*      in relocating pointers.  there are rnsi_ instances
*      of a rssi_ word structure.  each instance corresponds
*      to one of the regions that a pointer might point into.
*      the layout of this structure is shown in the definitions
*      section, together with symbolic definitions of the
*      entries as offsets from xl.
{relcr{prc{25,e{1,0{{entry point{7353
{{add{7,xl{19,*rlsi_{{point past build area{7354
{{mov{11,-(xl){8,wa{{save original code address{7355
{{mov{8,wa{22,=s_aaa{{compute adjustment{7356
{{sub{8,wa{9,(xl){{as new s_aaa minus original s_aaa{7357
{{mov{11,-(xl){8,wa{{save code adjustment{7358
{{mov{8,wa{22,=s_yyy{{end of target code section{7359
{{sub{8,wa{22,=s_aaa{{length of code section{7360
{{add{8,wa{13,num01(xl){{plus original start address{7361
{{mov{11,-(xl){8,wa{{end of original code section{7362
{{mov{11,-(xl){8,wb{{save constant section address{7363
{{mov{8,wb{21,=c_aaa{{start of constants section{7364
{{mov{8,wa{21,=c_yyy{{end of constants section{7365
{{sub{8,wa{8,wb{{length of constants section{7366
{{sub{8,wb{9,(xl){{new c_aaa minus original c_aaa{7367
{{mov{11,-(xl){8,wb{{save constant adjustment{7368
{{add{8,wa{13,num01(xl){{length plus original start adr{7369
{{mov{11,-(xl){8,wa{{save as end of original constants{7370
{{mov{11,-(xl){8,wc{{save working globals address{7371
{{mov{8,wc{20,=g_aaa{{start of working globals section{7372
{{mov{8,wa{20,=w_yyy{{end of working section{7373
{{sub{8,wa{8,wc{{length of working globals{7374
{{sub{8,wc{9,(xl){{new g_aaa minus original g_aaa{7375
{{mov{11,-(xl){8,wc{{save working globals adjustment{7376
{{add{8,wa{13,num01(xl){{length plus original start adr{7377
{{mov{11,-(xl){8,wa{{save as end of working globals{7378
{{mov{8,wb{3,statb{{old start of static region{7379
{{mov{11,-(xl){8,wb{{save{7380
{{sub{7,xr{8,wb{{compute adjustment{7381
{{mov{11,-(xl){7,xr{{save new statb minus old statb{7382
{{mov{11,-(xl){3,state{{old end of static region{7383
{{mov{8,wb{3,dnamb{{old start of dynamic region{7384
{{mov{11,-(xl){8,wb{{save{7385
{{scp{8,wa{{{new start of dynamic{7386
{{sub{8,wa{8,wb{{compute adjustment{7387
{{mov{11,-(xl){8,wa{{save new dnamb minus old dnamb{7388
{{mov{8,wc{3,dnamp{{old end of dynamic region in use{7389
{{mov{11,-(xl){8,wc{{save as end of old dynamic region{7390
{{exi{{{{{7391
{{enp{{{{{7392
{{ejc{{{{{7393
*      reldn -- relocate pointers in the dynamic region
*      (xl)                  list of boundaries and adjustments
*      (xr)                  ptr to first location to process
*      (wc)                  ptr past last location to process
*      jsr  reldn            call to process blocks in dynamic
*      (wa,wb,wc,xr)         destroyed
*      processes all blocks in the dynamic region.  within a
*      block, pointers to the code section, constant section,
*      working globals section, static region, and dynamic
*      region are relocated as needed.
{reldn{prc{25,e{1,0{{entry point{7408
{{mov{3,rldcd{13,rlcda(xl){{save code adjustment{7409
{{mov{3,rldst{13,rlsta(xl){{save static adjustment{7410
{{mov{3,rldls{7,xl{{save list pointer{7411
*      merge here to process the next block in dynamic
{rld01{add{9,(xr){3,rldcd{{adjust block type word{7415
{{mov{7,xl{9,(xr){{load block type word{7416
{{lei{7,xl{{{load entry point id (bl_xx){7417
*      block type switch. note that blocks with no relocatable
*      fields just return to rld05 to continue to next block.
*      note that dfblks do not appear in dynamic, only in static.
*      ccblks and cmblks are not live when a save file is
*      created, and can be skipped.
*      further note:  static blocks other than vrblks discovered
*      while scanning dynamic must be adjusted at this time.
*      see processing of ffblk for example.
{{ejc{{{{{7430
*      reldn (continued)
{{bsw{7,xl{2,bl___{{switch on block type{7434
{{iff{2,bl_ar{6,rld03{{arblk{7471
{{iff{2,bl_cd{6,rld07{{cdblk{7471
{{iff{2,bl_ex{6,rld10{{exblk{7471
{{iff{2,bl_ic{6,rld05{{icblk{7471
{{iff{2,bl_nm{6,rld13{{nmblk{7471
{{iff{2,bl_p0{6,rld13{{p0blk{7471
{{iff{2,bl_p1{6,rld14{{p1blk{7471
{{iff{2,bl_p2{6,rld14{{p2blk{7471
{{iff{2,bl_rc{6,rld05{{rcblk{7471
{{iff{2,bl_sc{6,rld05{{scblk{7471
{{iff{2,bl_se{6,rld13{{seblk{7471
{{iff{2,bl_tb{6,rld17{{tbblk{7471
{{iff{2,bl_vc{6,rld17{{vcblk{7471
{{iff{2,bl_xn{6,rld05{{xnblk{7471
{{iff{2,bl_xr{6,rld20{{xrblk{7471
{{iff{2,bl_bc{6,rld05{{bcblk - dummy to fill out iffs{7471
{{iff{2,bl_pd{6,rld15{{pdblk{7471
{{iff{2,bl_tr{6,rld19{{trblk{7471
{{iff{2,bl_bf{6,rld05{{bfblk{7471
{{iff{2,bl_cc{6,rld05{{ccblk{7471
{{iff{2,bl_cm{6,rld05{{cmblk{7471
{{iff{2,bl_ct{6,rld05{{ctblk{7471
{{iff{2,bl_df{6,rld05{{dfblk{7471
{{iff{2,bl_ef{6,rld08{{efblk{7471
{{iff{2,bl_ev{6,rld09{{evblk{7471
{{iff{2,bl_ff{6,rld11{{ffblk{7471
{{iff{2,bl_kv{6,rld13{{kvblk{7471
{{iff{2,bl_pf{6,rld16{{pfblk{7471
{{iff{2,bl_te{6,rld18{{teblk{7471
{{esw{{{{end of jump table{7471
*      arblk
{rld03{mov{8,wa{13,arlen(xr){{load length{7475
{{mov{8,wb{13,arofs(xr){{set offset to 1st reloc fld (arpro){7476
*      merge here to process pointers in a block
*      (xr)                  ptr to current block
*      (wc)                  ptr past last location to process
*      (wa)                  length (reloc flds + flds at start)
*      (wb)                  offset to first reloc field
{rld04{add{8,wa{7,xr{{point past last reloc field{7485
{{add{8,wb{7,xr{{point to first reloc field{7486
{{mov{7,xl{3,rldls{{point to list of bounds{7487
{{jsr{6,relaj{{{adjust pointers{7488
{{ejc{{{{{7489
*      reldn (continued)
*      merge here to advance to next block
*      (xr)                  ptr to current block
*      (wc)                  ptr past last location to process
{rld05{mov{8,wa{9,(xr){{block type word{7499
{{jsr{6,blkln{{{get length of block{7500
{{add{7,xr{8,wa{{point to next block{7501
{{blt{7,xr{8,wc{6,rld01{continue if more to process{7502
{{mov{7,xl{3,rldls{{restore xl{7503
{{exi{{{{return to caller if done{7504
*      cdblk
{rld07{mov{8,wa{13,cdlen(xr){{load length{7517
{{mov{8,wb{19,*cdfal{{set offset{7518
{{bne{9,(xr){22,=b_cdc{6,rld04{jump back if not complex goto{7519
{{mov{8,wb{19,*cdcod{{do not process cdfal word{7520
{{brn{6,rld04{{{jump back{7521
*      efblk
*      if the efcod word points to an xnblk, the xnblk type
*      word will not be adjusted.  since this is implementation
*      dependent, we will not worry about it.
{rld08{mov{8,wa{19,*efrsl{{set length{7529
{{mov{8,wb{19,*efcod{{and offset{7530
{{brn{6,rld04{{{all set{7531
*      evblk
{rld09{mov{8,wa{19,*offs3{{point past third field{7535
{{mov{8,wb{19,*evexp{{set offset{7536
{{brn{6,rld04{{{all set{7537
*      exblk
{rld10{mov{8,wa{13,exlen(xr){{load length{7541
{{mov{8,wb{19,*exflc{{set offset{7542
{{brn{6,rld04{{{jump back{7543
{{ejc{{{{{7544
*      reldn (continued)
*      ffblk
*      this block contains a ptr to a dfblk in the static rgn.
*      because there are multiple ffblks pointing to the same
*      dfblk (one for each field name), we only process the
*      dfblk when we encounter the ffblk for the first field.
*      the dfblk in turn contains a pointer to an scblk within
*      static.
{rld11{bne{13,ffofs(xr){19,*pdfld{6,rld12{skip dfblk if not first field{7558
{{mov{11,-(xs){7,xr{{save xr{7559
{{mov{7,xr{13,ffdfp(xr){{load old ptr to dfblk{7560
{{add{7,xr{3,rldst{{current location of dfblk{7561
{{add{9,(xr){3,rldcd{{adjust dfblk type word{7562
{{mov{8,wa{13,dflen(xr){{length of dfblk{7563
{{mov{8,wb{19,*dfnam{{offset to dfnam field{7564
{{add{8,wa{7,xr{{point past last reloc field{7565
{{add{8,wb{7,xr{{point to first reloc field{7566
{{mov{7,xl{3,rldls{{point to list of bounds{7567
{{jsr{6,relaj{{{adjust pointers{7568
{{mov{7,xr{13,dfnam(xr){{pointer to static scblk{7569
{{add{9,(xr){3,rldcd{{adjust scblk type word{7570
{{mov{7,xr{10,(xs)+{{restore ffblk pointer{7571
*      ffblk (continued)
*      merge here to set up for adjustment of ptrs in ffblk
{rld12{mov{8,wa{19,*ffofs{{set length{7577
{{mov{8,wb{19,*ffdfp{{set offset{7578
{{brn{6,rld04{{{all set{7579
*      kvblk, nmblk, p0blk, seblk
{rld13{mov{8,wa{19,*offs2{{point past second field{7583
{{mov{8,wb{19,*offs1{{offset is one (only reloc fld is 2){7584
{{brn{6,rld04{{{all set{7585
*      p1blk, p2blk
*      in p2blks, parm2 contains either a bit mask or the
*      name offset of a variable.  it never requires relocation.
{rld14{mov{8,wa{19,*parm2{{length (parm2 is non-relocatable){7592
{{mov{8,wb{19,*pthen{{set offset{7593
{{brn{6,rld04{{{all set{7594
*      pdblk
*      note that the dfblk pointed to by this pdblk was
*      processed when the ffblk was encountered.  because
*      the data function will be called before any records are
*      defined, the ffblk is encountered before any
*      corresponding pdblk.
{rld15{mov{7,xl{13,pddfp(xr){{load ptr to dfblk{7604
{{add{7,xl{3,rldst{{adjust for static relocation{7605
{{mov{8,wa{13,dfpdl(xl){{get pdblk length{7606
{{mov{8,wb{19,*pddfp{{set offset{7607
{{brn{6,rld04{{{all set{7608
{{ejc{{{{{7609
*      reldn (continued)
*      pfblk
{rld16{add{13,pfvbl(xr){3,rldst{{adjust non-contiguous field{7616
{{mov{8,wa{13,pflen(xr){{get pfblk length{7617
{{mov{8,wb{19,*pfcod{{offset to first reloc{7618
{{brn{6,rld04{{{all set{7619
*      tbblk, vcblk
{rld17{mov{8,wa{13,offs2(xr){{load length{7623
{{mov{8,wb{19,*offs3{{set offset{7624
{{brn{6,rld04{{{jump back{7625
*      teblk
{rld18{mov{8,wa{19,*tesi_{{set length{7629
{{mov{8,wb{19,*tesub{{and offset{7630
{{brn{6,rld04{{{all set{7631
*      trblk
{rld19{mov{8,wa{19,*trsi_{{set length{7635
{{mov{8,wb{19,*trval{{and offset{7636
{{brn{6,rld04{{{all set{7637
*      xrblk
{rld20{mov{8,wa{13,xrlen(xr){{load length{7641
{{mov{8,wb{19,*xrptr{{set offset{7642
{{brn{6,rld04{{{jump back{7643
{{enp{{{{end procedure reldn{7644
{{ejc{{{{{7645
*      reloc -- relocate storage after save file reload
*      (xl)                  list of boundaries and adjustments
*      jsr  reloc            relocate all pointers
*      (wa,wb,wc,xr)         destroyed
*      the list of boundaries and adjustments pointed to by
*      register xl is created by a call to relcr, which should
*      be consulted for information on its structure.
{reloc{prc{25,e{1,0{{entry point{7657
{{mov{7,xr{13,rldys(xl){{old start of dynamic{7658
{{mov{8,wc{13,rldye(xl){{old end of dynamic{7659
{{add{7,xr{13,rldya(xl){{create new start of dynamic{7660
{{add{8,wc{13,rldya(xl){{create new end of dynamic{7661
{{jsr{6,reldn{{{relocate pointers in dynamic{7662
{{jsr{6,relws{{{relocate pointers in working sect{7663
{{jsr{6,relst{{{relocate pointers in static{7664
{{exi{{{{return to caller{7665
{{enp{{{{end procedure reloc{7666
{{ejc{{{{{7667
*      relst -- relocate pointers in the static region
*      (xl)                  list of boundaries and adjustments
*      jsr  relst            call to process blocks in static
*      (wa,wb,wc,xr)         destroyed
*      only vrblks on the hash chain and any profile block are
*      processed.  other static blocks (dfblks) are processed
*      during processing of dynamic blocks.
*      global work locations will be processed at this point,
*      so pointers there can be relied upon.
{relst{prc{25,e{1,0{{entry point{7682
{{mov{7,xr{3,pftbl{{profile table{7683
{{bze{7,xr{6,rls01{{branch if no table allocated{7684
{{add{9,(xr){13,rlcda(xl){{adjust block type word{7685
*      here after dealing with profiler
{rls01{mov{8,wc{3,hshtb{{point to start of hash table{7689
{{mov{8,wb{8,wc{{point to first hash bucket{7690
{{mov{8,wa{3,hshte{{point beyond hash table{7691
{{jsr{6,relaj{{{adjust bucket pointers{7692
*      loop through slots in hash table
{rls02{beq{8,wc{3,hshte{6,rls05{done if none left{7696
{{mov{7,xr{8,wc{{else copy slot pointer{7697
{{ica{8,wc{{{bump slot pointer{7698
{{sub{7,xr{19,*vrnxt{{set offset to merge into loop{7699
*      loop through vrblks on one hash chain
{rls03{mov{7,xr{13,vrnxt(xr){{point to next vrblk on chain{7703
{{bze{7,xr{6,rls02{{jump for next bucket if chain end{7704
{{mov{8,wa{19,*vrlen{{offset of first loc past ptr fields{7705
{{mov{8,wb{19,*vrget{{offset of first location in vrblk{7706
{{bnz{13,vrlen(xr){6,rls04{{jump if not system variable{7707
{{mov{8,wa{19,*vrsi_{{offset to include vrsvp field{7708
*      merge here to process fields of vrblk
{rls04{add{8,wa{7,xr{{create end ptr{7712
{{add{8,wb{7,xr{{create start ptr{7713
{{jsr{6,relaj{{{adjust pointers in vrblk{7714
{{brn{6,rls03{{{check for another vrblk on chain{7715
*      here when all vrblks processed
{rls05{exi{{{{return to caller{7719
{{enp{{{{end procedure relst{7720
{{ejc{{{{{7721
*      relws -- relocate pointers in the working section
*      (xl)                  list of boundaries and adjustments
*      jsr  relws            call to process working section
*      (wa,wb,wc,xr)         destroyed
*      pointers between a_aaa and r_yyy are examined and
*      adjusted if necessary.  the pointer kvrtn is also
*      adjusted although it lies outside this range.
*      dname is explicitly adjusted because the limits
*      on dynamic region in stack are to the area actively
*      in use (between dnamb and dnamp), and dname is outside
*      this range.
{relws{prc{25,e{1,0{{entry point{7737
{{mov{8,wb{20,=a_aaa{{point to start of adjustables{7738
{{mov{8,wa{20,=r_yyy{{point to end of adjustables{7739
{{jsr{6,relaj{{{relocate adjustable pointers{7740
{{add{3,dname{13,rldya(xl){{adjust ptr missed by relaj{7741
{{mov{8,wb{20,=kvrtn{{case of kvrtn{7742
{{mov{8,wa{8,wb{{handled specially{7743
{{ica{8,wa{{{one value to adjust{7744
{{jsr{6,relaj{{{adjust kvrtn{7745
{{exi{{{{return to caller{7746
{{enp{{{{end procedure relws{7747
{{ttl{27,s p i t b o l -- initialization{{{{7749
*      initialisation
*      the following section receives control from the system
*      at the start of a run with the registers set as follows.
*      (wa)                  initial stack pointer
*      (xr)                  points to first word of data area
*      (xl)                  points to last word of data area
{start{prc{25,e{1,0{{entry point{7759
{{mov{3,mxint{8,wb{{{7760
{{mov{4,bitsm{8,wb{{{7761
{{zer{8,wb{{{{7762
*z-
{{mov{7,xs{8,wa{{discard return{7764
{{jsr{6,systm{{{initialise timer{7765
*z+
{{sti{3,timsx{{{store time{7768
{{mov{3,statb{7,xr{{start address of static{7769
{{mov{3,rsmem{19,*e_srs{{reserve memory{7821
{{mov{3,stbas{7,xs{{store stack base{7822
{{sss{3,iniss{{{save s-r stack ptr{7823
*      now convert free store percentage to a suitable factor
*      for easy testing in alloc routine.
{{ldi{4,intvh{{{get 100{7828
{{dvi{4,alfsp{{{form 100 / alfsp{7829
{{sti{3,alfsf{{{store the factor{7830
*      now convert free sediment percentage to a suitable factor
*      for easy testing in gbcol routine.
{{ldi{4,intvh{{{get 100{7836
{{dvi{4,gbsdp{{{form 100 / gbsdp{7837
{{sti{3,gbsed{{{store the factor{7838
*      initialize values for real conversion routine
{{lct{8,wb{18,=cfp_s{{load counter for significant digits{7847
{{ldr{4,reav1{{{load 1.0{7848
*      loop to compute 10**(max number significant digits)
{ini03{mlr{4,reavt{{{* 10.0{7852
{{bct{8,wb{6,ini03{{loop till done{7853
{{str{3,gtssc{{{store 10**(max sig digits){7854
{{ldr{4,reap5{{{load 0.5{7855
{{dvr{3,gtssc{{{compute 0.5*10**(max sig digits){7856
{{str{3,gtsrn{{{store as rounding bias{7857
{{zer{8,wc{{{set to read parameters{7860
{{jsr{6,prpar{{{read them{7861
{{ejc{{{{{7862
*      now compute starting address for dynamic store and if
*      necessary request more memory.
{{sub{7,xl{19,*e_srs{{allow for reserve memory{7867
{{mov{8,wa{3,prlen{{get print buffer length{7868
{{add{8,wa{18,=cfp_a{{add no. of chars in alphabet{7869
{{add{8,wa{18,=nstmx{{add chars for gtstg bfr{7870
{{ctb{8,wa{1,8{{convert to bytes, allowing a margin{7871
{{mov{7,xr{3,statb{{point to static base{7872
{{add{7,xr{8,wa{{increment for above buffers{7873
{{add{7,xr{19,*e_hnb{{increment for hash table{7874
{{add{7,xr{19,*e_sts{{bump for initial static block{7875
{{jsr{6,sysmx{{{get mxlen{7876
{{mov{3,kvmxl{8,wa{{provisionally store as maxlngth{7877
{{mov{3,mxlen{8,wa{{and as mxlen{7878
{{bgt{7,xr{8,wa{6,ini06{skip if static hi exceeds mxlen{7879
{{ctb{8,wa{1,1{{round up and make bigger than mxlen{7880
{{mov{7,xr{8,wa{{use it instead{7881
*      here to store values which mark initial division
*      of data area into static and dynamic
{ini06{mov{3,dnamb{7,xr{{dynamic base adrs{7886
{{mov{3,dnamp{7,xr{{dynamic ptr{7887
{{bnz{8,wa{6,ini07{{skip if non-zero mxlen{7888
{{dca{7,xr{{{point a word in front{7889
{{mov{3,kvmxl{7,xr{{use as maxlngth{7890
{{mov{3,mxlen{7,xr{{and as mxlen{7891
{{ejc{{{{{7892
*      loop here if necessary till enough memory obtained
*      so that dname is above dnamb
{ini07{mov{3,dname{7,xl{{store dynamic end address{7897
{{blt{3,dnamb{7,xl{6,ini09{skip if high enough{7898
{{jsr{6,sysmm{{{request more memory{7899
{{wtb{7,xr{{{get as baus (sgd05){7900
{{add{7,xl{7,xr{{bump by amount obtained{7901
{{bnz{7,xr{6,ini07{{try again{7902
{{mov{8,wa{18,=mxern{{insufficient memory for maxlength{7904
{{zer{8,wb{{{no column number info{7905
{{zer{8,wc{{{no line number info{7906
{{mov{7,xr{18,=stgic{{initial compile stage{7907
{{mov{7,xl{21,=nulls{{no file name{7909
{{jsr{6,sysea{{{advise of error{7911
{{ppm{6,ini08{{{cant use error logic yet{7912
{{brn{6,ini08{{{force termination{7913
*      insert text for error 329 in error message table
{{erb{1,329{26,requested maxlngth too large{{{7917
{ini08{mov{7,xr{21,=endmo{{point to failure message{7919
{{mov{8,wa{4,endml{{message length{7920
{{jsr{6,syspr{{{print it (prtst not yet usable){7921
{{ppm{{{{should not fail{7922
{{zer{7,xl{{{no fcb chain yet{7923
{{mov{8,wb{18,=num10{{set special code value{7924
{{jsr{6,sysej{{{pack up (stopr not yet usable){7925
*      initialise structures at start of static region
{ini09{mov{7,xr{3,statb{{point to static again{7929
{{jsr{6,insta{{{initialize static{7930
*      initialize number of hash headers
{{mov{8,wa{18,=e_hnb{{get number of hash headers{7934
{{mti{8,wa{{{convert to integer{7935
{{sti{3,hshnb{{{store for use by gtnvr procedure{7936
{{lct{8,wa{8,wa{{counter for clearing hash table{7937
{{mov{3,hshtb{7,xr{{pointer to hash table{7938
*      loop to clear hash table
{ini11{zer{10,(xr)+{{{blank a word{7942
{{bct{8,wa{6,ini11{{loop{7943
{{mov{3,hshte{7,xr{{end of hash table adrs is kept{7944
{{mov{3,state{7,xr{{store static end address{7945
*      init table to map statement numbers to source file names
{{mov{8,wc{18,=num01{{table will have only one bucket{7950
{{mov{7,xl{21,=nulls{{default table value{7951
{{mov{3,r_sfc{7,xl{{current source file name{7952
{{jsr{6,tmake{{{create table{7953
{{mov{3,r_sfn{7,xr{{save ptr to table{7954
*      initialize table to detect duplicate include file names
{{mov{8,wc{18,=num01{{table will have only one bucket{7960
{{mov{7,xl{21,=nulls{{default table value{7961
{{jsr{6,tmake{{{create table{7962
{{mov{3,r_inc{7,xr{{save ptr to table{7963
*      initialize array to hold names of nested include files
{{mov{8,wa{18,=ccinm{{maximum nesting level{7968
{{mov{7,xl{21,=nulls{{null string default value{7969
{{jsr{6,vmake{{{create array{7970
{{ppm{{{{{7971
{{mov{3,r_ifa{7,xr{{save ptr to array{7972
*      init array to hold line numbers of nested include files
{{mov{8,wa{18,=ccinm{{maximum nesting level{7976
{{mov{7,xl{21,=inton{{integer one default value{7977
{{jsr{6,vmake{{{create array{7978
{{ppm{{{{{7979
{{mov{3,r_ifl{7,xr{{save ptr to array{7980
*z+
*      initialize variable blocks for input and output
{{mov{7,xl{21,=v_inp{{point to string /input/{7987
{{mov{8,wb{18,=trtin{{trblk type for input{7988
{{jsr{6,inout{{{perform input association{7989
{{mov{7,xl{21,=v_oup{{point to string /output/{7990
{{mov{8,wb{18,=trtou{{trblk type for output{7991
{{jsr{6,inout{{{perform output association{7992
{{mov{8,wc{3,initr{{terminal flag{7993
{{bze{8,wc{6,ini13{{skip if no terminal{7994
{{jsr{6,prpar{{{associate terminal{7995
{{ejc{{{{{7996
*      check for expiry date
{ini13{jsr{6,sysdc{{{call date check{8000
{{mov{3,flptr{7,xs{{in case stack overflows in compiler{8001
*      now compile source input code
{{jsr{6,cmpil{{{call compiler{8005
{{mov{3,r_cod{7,xr{{set ptr to first code block{8006
{{mov{3,r_ttl{21,=nulls{{forget title{8007
{{mov{3,r_stl{21,=nulls{{forget sub-title{8008
{{zer{3,r_cim{{{forget compiler input image{8009
{{zer{3,r_ccb{{{forget interim code block{8010
{{zer{3,cnind{{{in case end occurred with include{8012
{{zer{3,lstid{{{listing include depth{8013
{{zer{7,xl{{{clear dud value{8015
{{zer{8,wb{{{dont shift dynamic store up{8016
{{zer{3,dnams{{{collect sediment too{8018
{{jsr{6,gbcol{{{clear garbage left from compile{8019
{{mov{3,dnams{7,xr{{record new sediment size{8020
{{bnz{3,cpsts{6,inix0{{skip if no listing of comp stats{8024
{{jsr{6,prtpg{{{eject page{8025
*      print compile statistics
{{jsr{6,prtmm{{{print memory usage{8029
{{mti{3,cmerc{{{get count of errors as integer{8030
{{mov{7,xr{21,=encm3{{point to /compile errors/{8031
{{jsr{6,prtmi{{{print it{8032
{{mti{3,gbcnt{{{garbage collection count{8033
{{sbi{4,intv1{{{adjust for unavoidable collect{8034
{{mov{7,xr{21,=stpm5{{point to /storage regenerations/{8035
{{jsr{6,prtmi{{{print gbcol count{8036
{{jsr{6,systm{{{get time{8037
{{sbi{3,timsx{{{get compilation time{8038
{{mov{7,xr{21,=encm4{{point to compilation time (msec)/{8039
{{jsr{6,prtmi{{{print message{8040
{{add{3,lstlc{18,=num05{{bump line count{8041
{{bze{3,headp{6,inix0{{no eject if nothing printed{8043
{{jsr{6,prtpg{{{eject printer{8044
{{ejc{{{{{8046
*      prepare now to start execution
*      set default input record length
{inix0{bgt{3,cswin{18,=iniln{6,inix1{skip if not default -in72 used{8052
{{mov{3,cswin{18,=inils{{else use default record length{8053
*      reset timer
{inix1{jsr{6,systm{{{get time again{8057
{{sti{3,timsx{{{store for end run processing{8058
{{zer{3,gbcnt{{{initialise collect count{8059
{{jsr{6,sysbx{{{call before starting execution{8060
{{add{3,noxeq{3,cswex{{add -noexecute flag{8061
{{bnz{3,noxeq{6,inix2{{jump if execution suppressed{8062
*      merge when listing file set for execution.  also
*      merge here when restarting a save file or load module.
{iniy0{mnz{3,headp{{{mark headers out regardless{8072
{{zer{11,-(xs){{{set failure location on stack{8073
{{mov{3,flptr{7,xs{{save ptr to failure offset word{8074
{{mov{7,xr{3,r_cod{{load ptr to entry code block{8075
{{mov{3,stage{18,=stgxt{{set stage for execute time{8076
{{mov{3,polcs{18,=num01{{reset interface polling interval{8078
{{mov{3,polct{18,=num01{{reset interface polling interval{8079
{{mov{3,pfnte{3,cmpsn{{copy stmts compiled count in case{8083
{{mov{3,pfdmp{3,kvpfl{{start profiling if &profile set{8084
{{jsr{6,systm{{{time yet again{8085
{{sti{3,pfstm{{{{8086
{{jsr{6,stgcc{{{compute stmgo countdown counters{8088
{{bri{9,(xr){{{start xeq with first statement{8089
*      here if execution is suppressed
{inix2{zer{8,wa{{{set abend value to zero{8094
{{mov{8,wb{18,=nini9{{set special code value{8102
{{zer{7,xl{{{no fcb chain{8103
{{jsr{6,sysej{{{end of job, exit to system{8104
{{enp{{{{end procedure start{8105
*      here from osint to restart a save file or load module.
{rstrt{prc{25,e{1,0{{entry point{8109
{{mov{7,xs{3,stbas{{discard return{8110
{{zer{7,xl{{{clear xl{8111
{{brn{6,iniy0{{{resume execution{8112
{{enp{{{{end procedure rstrt{8113
{{ttl{27,s p i t b o l -- snobol4 operator routines{{{{8115
*      this section includes all routines which can be accessed
*      directly from the generated code except system functions.
*      all routines in this section start with a label of the
*      form o_xxx where xxx is three letters. the generated code
*      contains a pointer to the appropriate entry label.
*      since the general form of the generated code consists of
*      pointers to blocks whose first word is the address of the
*      actual entry point label (o_xxx).
*      these routines are in alphabetical order by their
*      entry label names (i.e. by the xxx of the o_xxx name)
*      these routines receive control as follows
*      (cp)                  pointer to next code word
*      (xs)                  current stack pointer
{{ejc{{{{{8135
*      binary plus (addition)
{o_add{ent{{{{entry point{8139
*z+
{{jsr{6,arith{{{fetch arithmetic operands{8141
{{err{1,001{26,addition left operand is not numeric{{{8142
{{err{1,002{26,addition right operand is not numeric{{{8143
{{ppm{6,oadd1{{{jump if real operands{8146
*      here to add two integers
{{adi{13,icval(xl){{{add right operand to left{8151
{{ino{6,exint{{{return integer if no overflow{8152
{{erb{1,003{26,addition caused integer overflow{{{8153
*      here to add two reals
{oadd1{adr{13,rcval(xl){{{add right operand to left{8159
{{rno{6,exrea{{{return real if no overflow{8160
{{erb{1,261{26,addition caused real overflow{{{8161
{{ejc{{{{{8163
*      unary plus (affirmation)
{o_aff{ent{{{{entry point{8167
{{mov{7,xr{10,(xs)+{{load operand{8168
{{jsr{6,gtnum{{{convert to numeric{8169
{{err{1,004{26,affirmation operand is not numeric{{{8170
{{mov{11,-(xs){7,xr{{result if converted to numeric{8171
{{lcw{7,xr{{{get next code word{8172
{{bri{9,(xr){{{execute it{8173
{{ejc{{{{{8174
*      binary bar (alternation)
{o_alt{ent{{{{entry point{8178
{{mov{7,xr{10,(xs)+{{load right operand{8179
{{jsr{6,gtpat{{{convert to pattern{8180
{{err{1,005{26,alternation right operand is not pattern{{{8181
*      merge here from special (left alternation) case
{oalt1{mov{8,wb{22,=p_alt{{set pcode for alternative node{8185
{{jsr{6,pbild{{{build alternative node{8186
{{mov{7,xl{7,xr{{save address of alternative node{8187
{{mov{7,xr{10,(xs)+{{load left operand{8188
{{jsr{6,gtpat{{{convert to pattern{8189
{{err{1,006{26,alternation left operand is not pattern{{{8190
{{beq{7,xr{22,=p_alt{6,oalt2{jump if left arg is alternation{8191
{{mov{13,pthen(xl){7,xr{{set left operand as successor{8192
{{mov{11,-(xs){7,xl{{stack result{8193
{{lcw{7,xr{{{get next code word{8194
{{bri{9,(xr){{{execute it{8195
*      come here if left argument is itself an alternation
*      the result is more efficient if we make the replacement
*      (a / b) / c = a / (b / c)
{oalt2{mov{13,pthen(xl){13,parm1(xr){{build the (b / c) node{8203
{{mov{11,-(xs){13,pthen(xr){{set a as new left arg{8204
{{mov{7,xr{7,xl{{set (b / c) as new right arg{8205
{{brn{6,oalt1{{{merge back to build a / (b / c){8206
{{ejc{{{{{8207
*      array reference (multiple subscripts, by name)
{o_amn{ent{{{{entry point{8211
{{lcw{7,xr{{{load number of subscripts{8212
{{mov{8,wb{7,xr{{set flag for by name{8213
{{brn{6,arref{{{jump to array reference routine{8214
{{ejc{{{{{8215
*      array reference (multiple subscripts, by value)
{o_amv{ent{{{{entry point{8219
{{lcw{7,xr{{{load number of subscripts{8220
{{zer{8,wb{{{set flag for by value{8221
{{brn{6,arref{{{jump to array reference routine{8222
{{ejc{{{{{8223
*      array reference (one subscript, by name)
{o_aon{ent{{{{entry point{8227
{{mov{7,xr{9,(xs){{load subscript value{8228
{{mov{7,xl{13,num01(xs){{load array value{8229
{{mov{8,wa{9,(xl){{load first word of array operand{8230
{{beq{8,wa{22,=b_vct{6,oaon2{jump if vector reference{8231
{{beq{8,wa{22,=b_tbt{6,oaon3{jump if table reference{8232
*      here to use central array reference routine
{oaon1{mov{7,xr{18,=num01{{set number of subscripts to one{8236
{{mov{8,wb{7,xr{{set flag for by name{8237
{{brn{6,arref{{{jump to array reference routine{8238
*      here if we have a vector reference
{oaon2{bne{9,(xr){22,=b_icl{6,oaon1{use long routine if not integer{8242
{{ldi{13,icval(xr){{{load integer subscript value{8243
{{mfi{8,wa{6,exfal{{copy as address int, fail if ovflo{8244
{{bze{8,wa{6,exfal{{fail if zero{8245
{{add{8,wa{18,=vcvlb{{compute offset in words{8246
{{wtb{8,wa{{{convert to bytes{8247
{{mov{9,(xs){8,wa{{complete name on stack{8248
{{blt{8,wa{13,vclen(xl){6,oaon4{exit if subscript not too large{8249
{{brn{6,exfal{{{else fail{8250
*      here for table reference
{oaon3{mnz{8,wb{{{set flag for name reference{8254
{{jsr{6,tfind{{{locate/create table element{8255
{{ppm{6,exfal{{{fail if access fails{8256
{{mov{13,num01(xs){7,xl{{store name base on stack{8257
{{mov{9,(xs){8,wa{{store name offset on stack{8258
*      here to exit with result on stack
{oaon4{lcw{7,xr{{{result on stack, get code word{8262
{{bri{9,(xr){{{execute next code word{8263
{{ejc{{{{{8264
*      array reference (one subscript, by value)
{o_aov{ent{{{{entry point{8268
{{mov{7,xr{10,(xs)+{{load subscript value{8269
{{mov{7,xl{10,(xs)+{{load array value{8270
{{mov{8,wa{9,(xl){{load first word of array operand{8271
{{beq{8,wa{22,=b_vct{6,oaov2{jump if vector reference{8272
{{beq{8,wa{22,=b_tbt{6,oaov3{jump if table reference{8273
*      here to use central array reference routine
{oaov1{mov{11,-(xs){7,xl{{restack array value{8277
{{mov{11,-(xs){7,xr{{restack subscript{8278
{{mov{7,xr{18,=num01{{set number of subscripts to one{8279
{{zer{8,wb{{{set flag for value call{8280
{{brn{6,arref{{{jump to array reference routine{8281
*      here if we have a vector reference
{oaov2{bne{9,(xr){22,=b_icl{6,oaov1{use long routine if not integer{8285
{{ldi{13,icval(xr){{{load integer subscript value{8286
{{mfi{8,wa{6,exfal{{move as one word int, fail if ovflo{8287
{{bze{8,wa{6,exfal{{fail if zero{8288
{{add{8,wa{18,=vcvlb{{compute offset in words{8289
{{wtb{8,wa{{{convert to bytes{8290
{{bge{8,wa{13,vclen(xl){6,exfal{fail if subscript too large{8291
{{jsr{6,acess{{{access value{8292
{{ppm{6,exfal{{{fail if access fails{8293
{{mov{11,-(xs){7,xr{{stack result{8294
{{lcw{7,xr{{{get next code word{8295
{{bri{9,(xr){{{execute it{8296
*      here for table reference by value
{oaov3{zer{8,wb{{{set flag for value reference{8300
{{jsr{6,tfind{{{call table search routine{8301
{{ppm{6,exfal{{{fail if access fails{8302
{{mov{11,-(xs){7,xr{{stack result{8303
{{lcw{7,xr{{{get next code word{8304
{{bri{9,(xr){{{execute it{8305
{{ejc{{{{{8306
*      assignment
{o_ass{ent{{{{entry point{8310
*      o_rpl (pattern replacement) merges here
{oass0{mov{8,wb{10,(xs)+{{load value to be assigned{8314
{{mov{8,wa{10,(xs)+{{load name offset{8315
{{mov{7,xl{9,(xs){{load name base{8316
{{mov{9,(xs){8,wb{{store assigned value as result{8317
{{jsr{6,asign{{{perform assignment{8318
{{ppm{6,exfal{{{fail if assignment fails{8319
{{lcw{7,xr{{{result on stack, get code word{8320
{{bri{9,(xr){{{execute next code word{8321
{{ejc{{{{{8322
*      compilation error
{o_cer{ent{{{{entry point{8326
{{erb{1,007{26,compilation error encountered during execution{{{8327
{{ejc{{{{{8328
*      unary at (cursor assignment)
{o_cas{ent{{{{entry point{8332
{{mov{8,wc{10,(xs)+{{load name offset (parm2){8333
{{mov{7,xr{10,(xs)+{{load name base (parm1){8334
{{mov{8,wb{22,=p_cas{{set pcode for cursor assignment{8335
{{jsr{6,pbild{{{build node{8336
{{mov{11,-(xs){7,xr{{stack result{8337
{{lcw{7,xr{{{get next code word{8338
{{bri{9,(xr){{{execute it{8339
{{ejc{{{{{8340
*      concatenation
{o_cnc{ent{{{{entry point{8344
{{mov{7,xr{9,(xs){{load right argument{8345
{{beq{7,xr{21,=nulls{6,ocnc3{jump if right arg is null{8346
{{mov{7,xl{12,1(xs){{load left argument{8347
{{beq{7,xl{21,=nulls{6,ocnc4{jump if left argument is null{8348
{{mov{8,wa{22,=b_scl{{get constant to test for string{8349
{{bne{8,wa{9,(xl){6,ocnc2{jump if left arg not a string{8350
{{bne{8,wa{9,(xr){6,ocnc2{jump if right arg not a string{8351
*      merge here to concatenate two strings
{ocnc1{mov{8,wa{13,sclen(xl){{load left argument length{8355
{{add{8,wa{13,sclen(xr){{compute result length{8356
{{jsr{6,alocs{{{allocate scblk for result{8357
{{mov{12,1(xs){7,xr{{store result ptr over left argument{8358
{{psc{7,xr{{{prepare to store chars of result{8359
{{mov{8,wa{13,sclen(xl){{get number of chars in left arg{8360
{{plc{7,xl{{{prepare to load left arg chars{8361
{{mvc{{{{move characters of left argument{8362
{{mov{7,xl{10,(xs)+{{load right arg pointer, pop stack{8363
{{mov{8,wa{13,sclen(xl){{load number of chars in right arg{8364
{{plc{7,xl{{{prepare to load right arg chars{8365
{{mvc{{{{move characters of right argument{8366
{{zer{7,xl{{{clear garbage value in xl{8367
{{lcw{7,xr{{{result on stack, get code word{8368
{{bri{9,(xr){{{execute next code word{8369
*      come here if arguments are not both strings
{ocnc2{jsr{6,gtstg{{{convert right arg to string{8373
{{ppm{6,ocnc5{{{jump if right arg is not string{8374
{{mov{7,xl{7,xr{{save right arg ptr{8375
{{jsr{6,gtstg{{{convert left arg to string{8376
{{ppm{6,ocnc6{{{jump if left arg is not a string{8377
{{mov{11,-(xs){7,xr{{stack left argument{8378
{{mov{11,-(xs){7,xl{{stack right argument{8379
{{mov{7,xl{7,xr{{move left arg to proper reg{8380
{{mov{7,xr{9,(xs){{move right arg to proper reg{8381
{{brn{6,ocnc1{{{merge back to concatenate strings{8382
{{ejc{{{{{8383
*      concatenation (continued)
*      come here for null right argument
{ocnc3{ica{7,xs{{{remove right arg from stack{8389
{{lcw{7,xr{{{left argument on stack{8390
{{bri{9,(xr){{{execute next code word{8391
*      here for null left argument
{ocnc4{ica{7,xs{{{unstack one argument{8395
{{mov{9,(xs){7,xr{{store right argument{8396
{{lcw{7,xr{{{result on stack, get code word{8397
{{bri{9,(xr){{{execute next code word{8398
*      here if right argument is not a string
{ocnc5{mov{7,xl{7,xr{{move right argument ptr{8402
{{mov{7,xr{10,(xs)+{{load left arg pointer{8403
*      merge here when left argument is not a string
{ocnc6{jsr{6,gtpat{{{convert left arg to pattern{8407
{{err{1,008{26,concatenation left operand is not a string or pattern{{{8408
{{mov{11,-(xs){7,xr{{save result on stack{8409
{{mov{7,xr{7,xl{{point to right operand{8410
{{jsr{6,gtpat{{{convert to pattern{8411
{{err{1,009{26,concatenation right operand is not a string or pattern{{{8412
{{mov{7,xl{7,xr{{move for pconc{8413
{{mov{7,xr{10,(xs)+{{reload left operand ptr{8414
{{jsr{6,pconc{{{concatenate patterns{8415
{{mov{11,-(xs){7,xr{{stack result{8416
{{lcw{7,xr{{{get next code word{8417
{{bri{9,(xr){{{execute it{8418
{{ejc{{{{{8419
*      complementation
{o_com{ent{{{{entry point{8423
{{mov{7,xr{10,(xs)+{{load operand{8424
{{mov{8,wa{9,(xr){{load type word{8425
*      merge back here after conversion
{ocom1{beq{8,wa{22,=b_icl{6,ocom2{jump if integer{8429
{{beq{8,wa{22,=b_rcl{6,ocom3{jump if real{8432
{{jsr{6,gtnum{{{else convert to numeric{8434
{{err{1,010{26,negation operand is not numeric{{{8435
{{brn{6,ocom1{{{back to check cases{8436
*      here to complement integer
{ocom2{ldi{13,icval(xr){{{load integer value{8440
{{ngi{{{{negate{8441
{{ino{6,exint{{{return integer if no overflow{8442
{{erb{1,011{26,negation caused integer overflow{{{8443
*      here to complement real
{ocom3{ldr{13,rcval(xr){{{load real value{8449
{{ngr{{{{negate{8450
{{brn{6,exrea{{{return real result{8451
{{ejc{{{{{8453
*      binary slash (division)
{o_dvd{ent{{{{entry point{8457
{{jsr{6,arith{{{fetch arithmetic operands{8458
{{err{1,012{26,division left operand is not numeric{{{8459
{{err{1,013{26,division right operand is not numeric{{{8460
{{ppm{6,odvd2{{{jump if real operands{8463
*      here to divide two integers
{{dvi{13,icval(xl){{{divide left operand by right{8468
{{ino{6,exint{{{result ok if no overflow{8469
{{erb{1,014{26,division caused integer overflow{{{8470
*      here to divide two reals
{odvd2{dvr{13,rcval(xl){{{divide left operand by right{8476
{{rno{6,exrea{{{return real if no overflow{8477
{{erb{1,262{26,division caused real overflow{{{8478
{{ejc{{{{{8480
*      exponentiation
{o_exp{ent{{{{entry point{8484
{{mov{7,xr{10,(xs)+{{load exponent{8485
{{jsr{6,gtnum{{{convert to number{8486
{{err{1,015{26,exponentiation right operand is not numeric{{{8487
{{mov{7,xl{7,xr{{move exponent to xl{8488
{{mov{7,xr{10,(xs)+{{load base{8489
{{jsr{6,gtnum{{{convert to numeric{8490
{{err{1,016{26,exponentiation left operand is not numeric{{{8491
{{beq{9,(xl){22,=b_rcl{6,oexp7{jump if real exponent{8494
{{ldi{13,icval(xl){{{load exponent{8496
{{ilt{6,oex12{{{jump if negative exponent{8497
{{beq{8,wa{22,=b_rcl{6,oexp3{jump if base is real{8500
*      here to exponentiate an integer base and integer exponent
{{mfi{8,wa{6,oexp2{{convert exponent to 1 word integer{8505
{{lct{8,wa{8,wa{{set loop counter{8506
{{ldi{13,icval(xr){{{load base as initial value{8507
{{bnz{8,wa{6,oexp1{{jump into loop if non-zero exponent{8508
{{ieq{6,oexp4{{{error if 0**0{8509
{{ldi{4,intv1{{{nonzero**0{8510
{{brn{6,exint{{{give one as result for nonzero**0{8511
*      loop to perform exponentiation
{oex13{mli{13,icval(xr){{{multiply by base{8515
{{iov{6,oexp2{{{jump if overflow{8516
{oexp1{bct{8,wa{6,oex13{{loop if more to go{8517
{{brn{6,exint{{{else return integer result{8518
*      here if integer overflow
{oexp2{erb{1,017{26,exponentiation caused integer overflow{{{8522
{{ejc{{{{{8523
*      exponentiation (continued)
*      here to exponentiate a real to an integer power
{oexp3{mfi{8,wa{6,oexp6{{convert exponent to one word{8531
{{lct{8,wa{8,wa{{set loop counter{8532
{{ldr{13,rcval(xr){{{load base as initial value{8533
{{bnz{8,wa{6,oexp5{{jump into loop if non-zero exponent{8534
{{req{6,oexp4{{{error if 0.0**0{8535
{{ldr{4,reav1{{{nonzero**0{8536
{{brn{6,exrea{{{return 1.0 if nonzero**zero{8537
*      here for error of 0**0 or 0.0**0
{oexp4{erb{1,018{26,exponentiation result is undefined{{{8542
*      loop to perform exponentiation
{oex14{mlr{13,rcval(xr){{{multiply by base{8548
{{rov{6,oexp6{{{jump if overflow{8549
{oexp5{bct{8,wa{6,oex14{{loop till computation complete{8550
{{brn{6,exrea{{{then return real result{8551
*      here if real overflow
{oexp6{erb{1,266{26,exponentiation caused real overflow{{{8555
*      here with real exponent in (xl), numeric base in (xr)
{oexp7{beq{9,(xr){22,=b_rcl{6,oexp8{jump if base real{8560
{{ldi{13,icval(xr){{{load integer base{8561
{{itr{{{{convert to real{8562
{{jsr{6,rcbld{{{create real in (xr){8563
*      here with real exponent in (xl)
*      numeric base in (xr) and ra
{oexp8{zer{8,wb{{{set positive result flag{8568
{{ldr{13,rcval(xr){{{load base to ra{8569
{{rne{6,oexp9{{{jump if base non-zero{8570
{{ldr{13,rcval(xl){{{base is zero.  check exponent{8571
{{req{6,oexp4{{{jump if 0.0 ** 0.0{8572
{{ldr{4,reav0{{{0.0 to non-zero exponent yields 0.0{8573
{{brn{6,exrea{{{return zero result{8574
*      here with non-zero base in (xr) and ra, exponent in (xl)
*      a negative base is allowed if the exponent is integral.
{oexp9{rgt{6,oex10{{{jump if base gt 0.0{8580
{{ngr{{{{make base positive{8581
{{jsr{6,rcbld{{{create positive base in (xr){8582
{{ldr{13,rcval(xl){{{examine exponent{8583
{{chp{{{{chop to integral value{8584
{{rti{6,oexp6{{{convert to integer, br if too large{8585
{{sbr{13,rcval(xl){{{chop(exponent) - exponent{8586
{{rne{6,oex11{{{non-integral power with neg base{8587
{{mfi{8,wb{{{record even/odd exponent{8588
{{anb{8,wb{4,bits1{{odd exponent yields negative result{8589
{{ldr{13,rcval(xr){{{restore base to ra{8590
*      here with positive base in ra and (xr), exponent in (xl)
{oex10{lnf{{{{log of base{8594
{{rov{6,oexp6{{{too large{8595
{{mlr{13,rcval(xl){{{times exponent{8596
{{rov{6,oexp6{{{too large{8597
{{etx{{{{e ** (exponent * ln(base)){8598
{{rov{6,oexp6{{{too large{8599
{{bze{8,wb{6,exrea{{if no sign fixup required{8600
{{ngr{{{{negative result needed{8601
{{brn{6,exrea{{{{8602
*      here for non-integral exponent with negative base
{oex11{erb{1,311{26,exponentiation of negative base to non-integral power{{{8606
*      here with negative integer exponent in ia
{oex12{mov{11,-(xs){7,xr{{stack base{8615
{{itr{{{{convert to real exponent{8616
{{jsr{6,rcbld{{{real negative exponent in (xr){8617
{{mov{7,xl{7,xr{{put exponent in xl{8618
{{mov{7,xr{10,(xs)+{{restore base value{8619
{{brn{6,oexp7{{{process real exponent{8620
{{ejc{{{{{8624
*      failure in expression evaluation
*      this entry point is used if the evaluation of an
*      expression, initiated by the evalx procedure, fails.
*      control is returned to an appropriate point in evalx.
{o_fex{ent{{{{entry point{8632
{{brn{6,evlx6{{{jump to failure loc in evalx{8633
{{ejc{{{{{8634
*      failure during evaluation of a complex or direct goto
{o_fif{ent{{{{entry point{8638
{{erb{1,020{26,goto evaluation failure{{{8639
{{ejc{{{{{8640
*      function call (more than one argument)
{o_fnc{ent{{{{entry point{8644
{{lcw{8,wa{{{load number of arguments{8645
{{lcw{7,xr{{{load function vrblk pointer{8646
{{mov{7,xl{13,vrfnc(xr){{load function pointer{8647
{{bne{8,wa{13,fargs(xl){6,cfunc{use central routine if wrong num{8648
{{bri{9,(xl){{{jump to function if arg count ok{8649
{{ejc{{{{{8650
*      function name error
{o_fne{ent{{{{entry point{8654
{{lcw{8,wa{{{get next code word{8655
{{bne{8,wa{21,=ornm_{6,ofne1{fail if not evaluating expression{8656
{{bze{13,num02(xs){6,evlx3{{ok if expr. was wanted by value{8657
*      here for error
{ofne1{erb{1,021{26,function called by name returned a value{{{8661
{{ejc{{{{{8662
*      function call (single argument)
{o_fns{ent{{{{entry point{8666
{{lcw{7,xr{{{load function vrblk pointer{8667
{{mov{8,wa{18,=num01{{set number of arguments to one{8668
{{mov{7,xl{13,vrfnc(xr){{load function pointer{8669
{{bne{8,wa{13,fargs(xl){6,cfunc{use central routine if wrong num{8670
{{bri{9,(xl){{{jump to function if arg count ok{8671
{{ejc{{{{{8672
*      call to undefined function
{o_fun{ent{{{{entry point{8675
{{erb{1,022{26,undefined function called{{{8676
{{ejc{{{{{8677
*      execute complex goto
{o_goc{ent{{{{entry point{8681
{{mov{7,xr{13,num01(xs){{load name base pointer{8682
{{bhi{7,xr{3,state{6,ogoc1{jump if not natural variable{8683
{{add{7,xr{19,*vrtra{{else point to vrtra field{8684
{{bri{9,(xr){{{and jump through it{8685
*      here if goto operand is not natural variable
{ogoc1{erb{1,023{26,goto operand is not a natural variable{{{8689
{{ejc{{{{{8690
*      execute direct goto
{o_god{ent{{{{entry point{8694
{{mov{7,xr{9,(xs){{load operand{8695
{{mov{8,wa{9,(xr){{load first word{8696
{{beq{8,wa{22,=b_cds{6,bcds0{jump if code block to code routine{8697
{{beq{8,wa{22,=b_cdc{6,bcdc0{jump if code block to code routine{8698
{{erb{1,024{26,goto operand in direct goto is not code{{{8699
{{ejc{{{{{8700
*      set goto failure trap
*      this routine is executed at the start of a complex or
*      direct failure goto to trap a subsequent fail (see exfal)
{o_gof{ent{{{{entry point{8707
{{mov{7,xr{3,flptr{{point to fail offset on stack{8708
{{ica{9,(xr){{{point failure to o_fif word{8709
{{icp{{{{point to next code word{8710
{{lcw{7,xr{{{fetch next code word{8711
{{bri{9,(xr){{{execute it{8712
{{ejc{{{{{8713
*      binary dollar (immediate assignment)
*      the pattern built by binary dollar is a compound pattern.
*      see description at start of pattern match section for
*      details of the structure which is constructed.
{o_ima{ent{{{{entry point{8721
{{mov{8,wb{22,=p_imc{{set pcode for last node{8722
{{mov{8,wc{10,(xs)+{{pop name offset (parm2){8723
{{mov{7,xr{10,(xs)+{{pop name base (parm1){8724
{{jsr{6,pbild{{{build p_imc node{8725
{{mov{7,xl{7,xr{{save ptr to node{8726
{{mov{7,xr{9,(xs){{load left argument{8727
{{jsr{6,gtpat{{{convert to pattern{8728
{{err{1,025{26,immediate assignment left operand is not pattern{{{8729
{{mov{9,(xs){7,xr{{save ptr to left operand pattern{8730
{{mov{8,wb{22,=p_ima{{set pcode for first node{8731
{{jsr{6,pbild{{{build p_ima node{8732
{{mov{13,pthen(xr){10,(xs)+{{set left operand as p_ima successor{8733
{{jsr{6,pconc{{{concatenate to form final pattern{8734
{{mov{11,-(xs){7,xr{{stack result{8735
{{lcw{7,xr{{{get next code word{8736
{{bri{9,(xr){{{execute it{8737
{{ejc{{{{{8738
*      indirection (by name)
{o_inn{ent{{{{entry point{8742
{{mnz{8,wb{{{set flag for result by name{8743
{{brn{6,indir{{{jump to common routine{8744
{{ejc{{{{{8745
*      interrogation
{o_int{ent{{{{entry point{8749
{{mov{9,(xs){21,=nulls{{replace operand with null{8750
{{lcw{7,xr{{{get next code word{8751
{{bri{9,(xr){{{execute next code word{8752
{{ejc{{{{{8753
*      indirection (by value)
{o_inv{ent{{{{entry point{8757
{{zer{8,wb{{{set flag for by value{8758
{{brn{6,indir{{{jump to common routine{8759
{{ejc{{{{{8760
*      keyword reference (by name)
{o_kwn{ent{{{{entry point{8764
{{jsr{6,kwnam{{{get keyword name{8765
{{brn{6,exnam{{{exit with result name{8766
{{ejc{{{{{8767
*      keyword reference (by value)
{o_kwv{ent{{{{entry point{8771
{{jsr{6,kwnam{{{get keyword name{8772
{{mov{3,dnamp{7,xr{{delete kvblk{8773
{{jsr{6,acess{{{access value{8774
{{ppm{6,exnul{{{dummy (unused) failure return{8775
{{mov{11,-(xs){7,xr{{stack result{8776
{{lcw{7,xr{{{get next code word{8777
{{bri{9,(xr){{{execute it{8778
{{ejc{{{{{8779
*      load expression by name
{o_lex{ent{{{{entry point{8783
{{mov{8,wa{19,*evsi_{{set size of evblk{8784
{{jsr{6,alloc{{{allocate space for evblk{8785
{{mov{9,(xr){22,=b_evt{{set type word{8786
{{mov{13,evvar(xr){21,=trbev{{set dummy trblk pointer{8787
{{lcw{8,wa{{{load exblk pointer{8788
{{mov{13,evexp(xr){8,wa{{set exblk pointer{8789
{{mov{7,xl{7,xr{{move name base to proper reg{8790
{{mov{8,wa{19,*evvar{{set name offset = zero{8791
{{brn{6,exnam{{{exit with name in (xl,wa){8792
{{ejc{{{{{8793
*      load pattern value
{o_lpt{ent{{{{entry point{8797
{{lcw{7,xr{{{load pattern pointer{8798
{{mov{11,-(xs){7,xr{{stack result{8799
{{lcw{7,xr{{{get next code word{8800
{{bri{9,(xr){{{execute it{8801
{{ejc{{{{{8802
*      load variable name
{o_lvn{ent{{{{entry point{8806
{{lcw{8,wa{{{load vrblk pointer{8807
{{mov{11,-(xs){8,wa{{stack vrblk ptr (name base){8808
{{mov{11,-(xs){19,*vrval{{stack name offset{8809
{{lcw{7,xr{{{get next code word{8810
{{bri{9,(xr){{{execute next code word{8811
{{ejc{{{{{8812
*      binary asterisk (multiplication)
{o_mlt{ent{{{{entry point{8816
{{jsr{6,arith{{{fetch arithmetic operands{8817
{{err{1,026{26,multiplication left operand is not numeric{{{8818
{{err{1,027{26,multiplication right operand is not numeric{{{8819
{{ppm{6,omlt1{{{jump if real operands{8822
*      here to multiply two integers
{{mli{13,icval(xl){{{multiply left operand by right{8827
{{ino{6,exint{{{return integer if no overflow{8828
{{erb{1,028{26,multiplication caused integer overflow{{{8829
*      here to multiply two reals
{omlt1{mlr{13,rcval(xl){{{multiply left operand by right{8835
{{rno{6,exrea{{{return real if no overflow{8836
{{erb{1,263{26,multiplication caused real overflow{{{8837
{{ejc{{{{{8839
*      name reference
{o_nam{ent{{{{entry point{8843
{{mov{8,wa{19,*nmsi_{{set length of nmblk{8844
{{jsr{6,alloc{{{allocate nmblk{8845
{{mov{9,(xr){22,=b_nml{{set name block code{8846
{{mov{13,nmofs(xr){10,(xs)+{{set name offset from operand{8847
{{mov{13,nmbas(xr){10,(xs)+{{set name base from operand{8848
{{mov{11,-(xs){7,xr{{stack result{8849
{{lcw{7,xr{{{get next code word{8850
{{bri{9,(xr){{{execute it{8851
{{ejc{{{{{8852
*      negation
*      initial entry
{o_nta{ent{{{{entry point{8858
{{lcw{8,wa{{{load new failure offset{8859
{{mov{11,-(xs){3,flptr{{stack old failure pointer{8860
{{mov{11,-(xs){8,wa{{stack new failure offset{8861
{{mov{3,flptr{7,xs{{set new failure pointer{8862
{{lcw{7,xr{{{get next code word{8863
{{bri{9,(xr){{{execute next code word{8864
*      entry after successful evaluation of operand
{o_ntb{ent{{{{entry point{8868
{{mov{3,flptr{13,num02(xs){{restore old failure pointer{8869
{{brn{6,exfal{{{and fail{8870
*      entry for failure during operand evaluation
{o_ntc{ent{{{{entry point{8874
{{ica{7,xs{{{pop failure offset{8875
{{mov{3,flptr{10,(xs)+{{restore old failure pointer{8876
{{brn{6,exnul{{{exit giving null result{8877
{{ejc{{{{{8878
*      use of undefined operator
{o_oun{ent{{{{entry point{8882
{{erb{1,029{26,undefined operator referenced{{{8883
{{ejc{{{{{8884
*      binary dot (pattern assignment)
*      the pattern built by binary dot is a compound pattern.
*      see description at start of pattern match section for
*      details of the structure which is constructed.
{o_pas{ent{{{{entry point{8892
{{mov{8,wb{22,=p_pac{{load pcode for p_pac node{8893
{{mov{8,wc{10,(xs)+{{load name offset (parm2){8894
{{mov{7,xr{10,(xs)+{{load name base (parm1){8895
{{jsr{6,pbild{{{build p_pac node{8896
{{mov{7,xl{7,xr{{save ptr to node{8897
{{mov{7,xr{9,(xs){{load left operand{8898
{{jsr{6,gtpat{{{convert to pattern{8899
{{err{1,030{26,pattern assignment left operand is not pattern{{{8900
{{mov{9,(xs){7,xr{{save ptr to left operand pattern{8901
{{mov{8,wb{22,=p_paa{{set pcode for p_paa node{8902
{{jsr{6,pbild{{{build p_paa node{8903
{{mov{13,pthen(xr){10,(xs)+{{set left operand as p_paa successor{8904
{{jsr{6,pconc{{{concatenate to form final pattern{8905
{{mov{11,-(xs){7,xr{{stack result{8906
{{lcw{7,xr{{{get next code word{8907
{{bri{9,(xr){{{execute it{8908
{{ejc{{{{{8909
*      pattern match (by name, for replacement)
{o_pmn{ent{{{{entry point{8913
{{zer{8,wb{{{set type code for match by name{8914
{{brn{6,match{{{jump to routine to start match{8915
{{ejc{{{{{8916
*      pattern match (statement)
*      o_pms is used in place of o_pmv when the pattern match
*      occurs at the outer (statement) level since in this
*      case the substring value need not be constructed.
{o_pms{ent{{{{entry point{8924
{{mov{8,wb{18,=num02{{set flag for statement to match{8925
{{brn{6,match{{{jump to routine to start match{8926
{{ejc{{{{{8927
*      pattern match (by value)
{o_pmv{ent{{{{entry point{8931
{{mov{8,wb{18,=num01{{set type code for value match{8932
{{brn{6,match{{{jump to routine to start match{8933
{{ejc{{{{{8934
*      pop top item on stack
{o_pop{ent{{{{entry point{8938
{{ica{7,xs{{{pop top stack entry{8939
{{lcw{7,xr{{{get next code word{8940
{{bri{9,(xr){{{execute next code word{8941
{{ejc{{{{{8942
*      terminate execution (code compiled for end statement)
{o_stp{ent{{{{entry point{8946
{{brn{6,lend0{{{jump to end circuit{8947
{{ejc{{{{{8948
*      return name from expression
*      this entry points is used if the evaluation of an
*      expression, initiated by the evalx procedure, returns
*      a name. control is returned to the proper point in evalx.
{o_rnm{ent{{{{entry point{8955
{{brn{6,evlx4{{{return to evalx procedure{8956
{{ejc{{{{{8957
*      pattern replacement
*      when this routine gets control, the following stack
*      entries have been made (see end of match routine p_nth)
*                            subject name base
*                            subject name offset
*                            initial cursor value
*                            final cursor value
*                            subject string pointer
*      (xs) ---------------- replacement value
{o_rpl{ent{{{{entry point{8971
{{jsr{6,gtstg{{{convert replacement val to string{8972
{{err{1,031{26,pattern replacement right operand is not a string{{{8973
*      get result length and allocate result scblk
{{mov{7,xl{9,(xs){{load subject string pointer{8977
{{add{8,wa{13,sclen(xl){{add subject string length{8982
{{add{8,wa{13,num02(xs){{add starting cursor{8983
{{sub{8,wa{13,num01(xs){{minus final cursor = total length{8984
{{bze{8,wa{6,orpl3{{jump if result is null{8985
{{mov{11,-(xs){7,xr{{restack replacement string{8986
{{jsr{6,alocs{{{allocate scblk for result{8987
{{mov{8,wa{13,num03(xs){{get initial cursor (part 1 len){8988
{{mov{13,num03(xs){7,xr{{stack result pointer{8989
{{psc{7,xr{{{point to characters of result{8990
*      move part 1 (start of subject) to result
{{bze{8,wa{6,orpl1{{jump if first part is null{8994
{{mov{7,xl{13,num01(xs){{else point to subject string{8995
{{plc{7,xl{{{point to subject string chars{8996
{{mvc{{{{move first part to result{8997
{{ejc{{{{{8998
*      pattern replacement (continued)
*      now move in replacement value
{orpl1{mov{7,xl{10,(xs)+{{load replacement string, pop{9003
{{mov{8,wa{13,sclen(xl){{load length{9004
{{bze{8,wa{6,orpl2{{jump if null replacement{9005
{{plc{7,xl{{{else point to chars of replacement{9006
{{mvc{{{{move in chars (part 2){9007
*      now move in remainder of string (part 3)
{orpl2{mov{7,xl{10,(xs)+{{load subject string pointer, pop{9011
{{mov{8,wc{10,(xs)+{{load final cursor, pop{9012
{{mov{8,wa{13,sclen(xl){{load subject string length{9013
{{sub{8,wa{8,wc{{minus final cursor = part 3 length{9014
{{bze{8,wa{6,oass0{{jump to assign if part 3 is null{9015
{{plc{7,xl{8,wc{{else point to last part of string{9016
{{mvc{{{{move part 3 to result{9017
{{brn{6,oass0{{{jump to perform assignment{9018
*      here if result is null
{orpl3{add{7,xs{19,*num02{{pop subject str ptr, final cursor{9022
{{mov{9,(xs){21,=nulls{{set null result{9023
{{brn{6,oass0{{{jump to assign null value{9024
{{ejc{{{{{9043
*      return value from expression
*      this entry points is used if the evaluation of an
*      expression, initiated by the evalx procedure, returns
*      a value. control is returned to the proper point in evalx
{o_rvl{ent{{{{entry point{9051
{{brn{6,evlx3{{{return to evalx procedure{9052
{{ejc{{{{{9053
*      selection
*      initial entry
{o_sla{ent{{{{entry point{9059
{{lcw{8,wa{{{load new failure offset{9060
{{mov{11,-(xs){3,flptr{{stack old failure pointer{9061
{{mov{11,-(xs){8,wa{{stack new failure offset{9062
{{mov{3,flptr{7,xs{{set new failure pointer{9063
{{lcw{7,xr{{{get next code word{9064
{{bri{9,(xr){{{execute next code word{9065
*      entry after successful evaluation of alternative
{o_slb{ent{{{{entry point{9069
{{mov{7,xr{10,(xs)+{{load result{9070
{{ica{7,xs{{{pop fail offset{9071
{{mov{3,flptr{9,(xs){{restore old failure pointer{9072
{{mov{9,(xs){7,xr{{restack result{9073
{{lcw{8,wa{{{load new code offset{9074
{{add{8,wa{3,r_cod{{point to absolute code location{9075
{{lcp{8,wa{{{set new code pointer{9076
{{lcw{7,xr{{{get next code word{9077
{{bri{9,(xr){{{execute next code word{9078
*      entry at start of subsequent alternatives
{o_slc{ent{{{{entry point{9082
{{lcw{8,wa{{{load new fail offset{9083
{{mov{9,(xs){8,wa{{store new fail offset{9084
{{lcw{7,xr{{{get next code word{9085
{{bri{9,(xr){{{execute next code word{9086
*      entry at start of last alternative
{o_sld{ent{{{{entry point{9090
{{ica{7,xs{{{pop failure offset{9091
{{mov{3,flptr{10,(xs)+{{restore old failure pointer{9092
{{lcw{7,xr{{{get next code word{9093
{{bri{9,(xr){{{execute next code word{9094
{{ejc{{{{{9095
*      binary minus (subtraction)
{o_sub{ent{{{{entry point{9099
{{jsr{6,arith{{{fetch arithmetic operands{9100
{{err{1,032{26,subtraction left operand is not numeric{{{9101
{{err{1,033{26,subtraction right operand is not numeric{{{9102
{{ppm{6,osub1{{{jump if real operands{9105
*      here to subtract two integers
{{sbi{13,icval(xl){{{subtract right operand from left{9110
{{ino{6,exint{{{return integer if no overflow{9111
{{erb{1,034{26,subtraction caused integer overflow{{{9112
*      here to subtract two reals
{osub1{sbr{13,rcval(xl){{{subtract right operand from left{9118
{{rno{6,exrea{{{return real if no overflow{9119
{{erb{1,264{26,subtraction caused real overflow{{{9120
{{ejc{{{{{9122
*      dummy operator to return control to trxeq procedure
{o_txr{ent{{{{entry point{9126
{{brn{6,trxq1{{{jump into trxeq procedure{9127
{{ejc{{{{{9128
*      unexpected failure
*      note that if a setexit trap is operating then
*      transfer to system label continue
*      will result in looping here.  difficult to avoid except
*      with a considerable overhead which is not worthwhile or
*      else by a technique such as setting kverl to zero.
{o_unf{ent{{{{entry point{9138
{{erb{1,035{26,unexpected failure in -nofail mode{{{9139
{{ttl{27,s p i t b o l -- block action routines{{{{9140
*      the first word of every block in dynamic storage and the
*      vrget, vrsto and vrtra fields of a vrblk contain a
*      pointer to an entry point in the program. all such entry
*      points are in the following section except those for
*      pattern blocks which are in the pattern matching segment
*      later on (labels of the form p_xxx), and dope vectors
*      (d_xxx) which are in the dope vector section following
*      the pattern routines (dope vectors are used for cmblks).
*      the entry points in this section have labels of the
*      form b_xxy where xx is the two character block type for
*      the corresponding block and y is any letter.
*      in some cases, the pointers serve no other purpose than
*      to identify the block type. in this case the routine
*      is never executed and thus no code is assembled.
*      for each of these entry points corresponding to a block
*      an entry point identification is assembled (bl_xx).
*      the exact entry conditions depend on the manner in
*      which the routine is accessed and are documented with
*      the individual routines as required.
*      the order of these routines is alphabetical with the
*      following exceptions.
*      the routines for seblk and exblk entries occur first so
*      that expressions can be quickly identified from the fact
*      that their routines lie before the symbol b_e__.
*      these are immediately followed by the routine for a trblk
*      so that the test against the symbol b_t__ checks for
*      trapped values or expression values (see procedure evalp)
*      the pattern routines lie after this section so that
*      patterns are identified with routines starting at or
*      after the initial instruction in these routines (p_aaa).
*      the symbol b_aaa defines the first location for block
*      routines and the symbol p_yyy (at the end of the pattern
*      match routines section) defines the last such entry point
{b_aaa{ent{2,bl__i{{{entry point of first block routine{9185
{{ejc{{{{{9186
*      exblk
*      the routine for an exblk loads the expression onto
*      the stack as a value.
*      (xr)                  pointer to exblk
{b_exl{ent{2,bl_ex{{{entry point (exblk){9195
{{mov{11,-(xs){7,xr{{stack result{9196
{{lcw{7,xr{{{get next code word{9197
{{bri{9,(xr){{{execute it{9198
{{ejc{{{{{9199
*      seblk
*      the routine for seblk is accessed from the generated
*      code to load the expression value onto the stack.
{b_sel{ent{2,bl_se{{{entry point (seblk){9206
{{mov{11,-(xs){7,xr{{stack result{9207
{{lcw{7,xr{{{get next code word{9208
{{bri{9,(xr){{{execute it{9209
*      define symbol which marks end of entries for expressions
{b_e__{ent{2,bl__i{{{entry point{9213
{{ejc{{{{{9214
*      trblk
*      the routine for a trblk is never executed
{b_trt{ent{2,bl_tr{{{entry point (trblk){9220
*      define symbol marking end of trap and expression blocks
{b_t__{ent{2,bl__i{{{end of trblk,seblk,exblk entries{9224
{{ejc{{{{{9225
*      arblk
*      the routine for arblk is never executed
{b_art{ent{2,bl_ar{{{entry point (arblk){9231
{{ejc{{{{{9232
*      bcblk
*      the routine for a bcblk is never executed
*      (xr)                  pointer to bcblk
{b_bct{ent{2,bl_bc{{{entry point (bcblk){9240
{{ejc{{{{{9241
*      bfblk
*      the routine for a bfblk is never executed
*      (xr)                  pointer to bfblk
{b_bft{ent{2,bl_bf{{{entry point (bfblk){9249
{{ejc{{{{{9250
*      ccblk
*      the routine for ccblk is never entered
{b_cct{ent{2,bl_cc{{{entry point (ccblk){9256
{{ejc{{{{{9257
*      cdblk
*      the cdblk routines are executed from the generated code.
*      there are two cases depending on the form of cdfal.
*      entry for complex failure code at cdfal
*      (xr)                  pointer to cdblk
{b_cdc{ent{2,bl_cd{{{entry point (cdblk){9268
{bcdc0{mov{7,xs{3,flptr{{pop garbage off stack{9269
{{mov{9,(xs){13,cdfal(xr){{set failure offset{9270
{{brn{6,stmgo{{{enter stmt{9271
{{ejc{{{{{9272
*      cdblk (continued)
*      entry for simple failure code at cdfal
*      (xr)                  pointer to cdblk
{b_cds{ent{2,bl_cd{{{entry point (cdblk){9280
{bcds0{mov{7,xs{3,flptr{{pop garbage off stack{9281
{{mov{9,(xs){19,*cdfal{{set failure offset{9282
{{brn{6,stmgo{{{enter stmt{9283
{{ejc{{{{{9284
*      cmblk
*      the routine for a cmblk is never executed
{b_cmt{ent{2,bl_cm{{{entry point (cmblk){9290
{{ejc{{{{{9291
*      ctblk
*      the routine for a ctblk is never executed
{b_ctt{ent{2,bl_ct{{{entry point (ctblk){9297
{{ejc{{{{{9298
*      dfblk
*      the routine for a dfblk is accessed from the o_fnc entry
*      to call a datatype function and build a pdblk.
*      (xl)                  pointer to dfblk
{b_dfc{ent{2,bl_df{{{entry point{9307
{{mov{8,wa{13,dfpdl(xl){{load length of pdblk{9308
{{jsr{6,alloc{{{allocate pdblk{9309
{{mov{9,(xr){22,=b_pdt{{store type word{9310
{{mov{13,pddfp(xr){7,xl{{store dfblk pointer{9311
{{mov{8,wc{7,xr{{save pointer to pdblk{9312
{{add{7,xr{8,wa{{point past pdblk{9313
{{lct{8,wa{13,fargs(xl){{set to count fields{9314
*      loop to acquire field values from stack
{bdfc1{mov{11,-(xr){10,(xs)+{{move a field value{9318
{{bct{8,wa{6,bdfc1{{loop till all moved{9319
{{mov{7,xr{8,wc{{recall pointer to pdblk{9320
{{brn{6,exsid{{{exit setting id field{9321
{{ejc{{{{{9322
*      efblk
*      the routine for an efblk is passed control form the o_fnc
*      entry to call an external function.
*      (xl)                  pointer to efblk
{b_efc{ent{2,bl_ef{{{entry point (efblk){9331
{{mov{8,wc{13,fargs(xl){{load number of arguments{9334
{{wtb{8,wc{{{convert to offset{9335
{{mov{11,-(xs){7,xl{{save pointer to efblk{9336
{{mov{7,xt{7,xs{{copy pointer to arguments{9337
*      loop to convert arguments
{befc1{ica{7,xt{{{point to next entry{9341
{{mov{7,xr{9,(xs){{load pointer to efblk{9342
{{dca{8,wc{{{decrement eftar offset{9343
{{add{7,xr{8,wc{{point to next eftar entry{9344
{{mov{7,xr{13,eftar(xr){{load eftar entry{9345
{{bsw{7,xr{1,5{{switch on type{9354
{{iff{1,0{6,befc7{{no conversion needed{9372
{{iff{1,1{6,befc2{{string{9372
{{iff{1,2{6,befc3{{integer{9372
{{iff{1,3{6,befc4{{real{9372
{{iff{1,4{6,beff1{{file{9372
{{esw{{{{end of switch on type{9372
*      here to convert to file
{beff1{mov{11,-(xs){7,xt{{save entry pointer{9377
{{mov{3,befof{8,wc{{save offset{9378
{{mov{11,-(xs){9,(xt){{stack arg pointer{9379
{{jsr{6,iofcb{{{convert to fcb{9380
{{err{1,298{26,external function argument is not file{{{9381
{{err{1,298{26,external function argument is not file{{{9382
{{err{1,298{26,external function argument is not file{{{9383
{{mov{7,xr{8,wa{{point to fcb{9384
{{mov{7,xt{10,(xs)+{{reload entry pointer{9385
{{brn{6,befc5{{{jump to merge{9386
*      here to convert to string
{befc2{mov{11,-(xs){9,(xt){{stack arg ptr{9391
{{jsr{6,gtstg{{{convert argument to string{9392
{{err{1,039{26,external function argument is not a string{{{9393
{{brn{6,befc6{{{jump to merge{9394
{{ejc{{{{{9395
*      efblk (continued)
*      here to convert an integer
{befc3{mov{7,xr{9,(xt){{load next argument{9401
{{mov{3,befof{8,wc{{save offset{9402
{{jsr{6,gtint{{{convert to integer{9403
{{err{1,040{26,external function argument is not integer{{{9404
{{brn{6,befc5{{{merge with real case{9407
*      here to convert a real
{befc4{mov{7,xr{9,(xt){{load next argument{9411
{{mov{3,befof{8,wc{{save offset{9412
{{jsr{6,gtrea{{{convert to real{9413
{{err{1,265{26,external function argument is not real{{{9414
*      integer case merges here
{befc5{mov{8,wc{3,befof{{restore offset{9419
*      string merges here
{befc6{mov{9,(xt){7,xr{{store converted result{9423
*      no conversion merges here
{befc7{bnz{8,wc{6,befc1{{loop back if more to go{9427
*      here after converting all the arguments
{{mov{7,xl{10,(xs)+{{restore efblk pointer{9431
{{mov{8,wa{13,fargs(xl){{get number of args{9432
{{jsr{6,sysex{{{call routine to call external fnc{9433
{{ppm{6,exfal{{{fail if failure{9434
{{err{1,327{26,calling external function - not found{{{9435
{{err{1,326{26,calling external function - bad argument type{{{9436
{{wtb{8,wa{{{convert number of args to bytes{9438
{{add{7,xs{8,wa{{remove arguments from stack{9439
{{ejc{{{{{9441
*      efblk (continued)
*      return here with result in xr
*      first defend against non-standard null string returned
{{mov{8,wb{13,efrsl(xl){{get result type id{9449
{{bnz{8,wb{6,befa8{{branch if not unconverted{9450
{{bne{9,(xr){22,=b_scl{6,befc8{jump if not a string{9451
{{bze{13,sclen(xr){6,exnul{{return null if null{9452
*      here if converted result to check for null string
{befa8{bne{8,wb{18,=num01{6,befc8{jump if not a string{9456
{{bze{13,sclen(xr){6,exnul{{return null if null{9457
*      return if result is in dynamic storage
{befc8{blt{7,xr{3,dnamb{6,befc9{jump if not in dynamic storage{9461
{{ble{7,xr{3,dnamp{6,exixr{return result if already dynamic{9462
*      here we copy a result into the dynamic region
{befc9{mov{8,wa{9,(xr){{get possible type word{9466
{{bze{8,wb{6,bef11{{jump if unconverted result{9467
{{mov{8,wa{22,=b_scl{{string{9468
{{beq{8,wb{18,=num01{6,bef10{yes jump{9469
{{mov{8,wa{22,=b_icl{{integer{9470
{{beq{8,wb{18,=num02{6,bef10{yes jump{9471
{{mov{8,wa{22,=b_rcl{{real{9474
*      store type word in result
{bef10{mov{9,(xr){8,wa{{stored before copying to dynamic{9479
*      merge for unconverted result
{bef11{beq{9,(xr){22,=b_scl{6,bef12{branch if string result{9483
{{jsr{6,blkln{{{get length of block{9484
{{mov{7,xl{7,xr{{copy address of old block{9485
{{jsr{6,alloc{{{allocate dynamic block same size{9486
{{mov{11,-(xs){7,xr{{set pointer to new block as result{9487
{{mvw{{{{copy old block to dynamic block{9488
{{zer{7,xl{{{clear garbage value{9489
{{lcw{7,xr{{{get next code word{9490
{{bri{9,(xr){{{execute next code word{9491
*      here to return a string result that was not in dynamic.
*      cannot use the simple word copy above because it will not
*      guarantee zero padding in the last word.
{bef12{mov{7,xl{7,xr{{save source string pointer{9497
{{mov{8,wa{13,sclen(xr){{fetch string length{9498
{{bze{8,wa{6,exnul{{return null string if length zero{9499
{{jsr{6,alocs{{{allocate space for string{9500
{{mov{11,-(xs){7,xr{{save as result pointer{9501
{{psc{7,xr{{{prepare to store chars of result{9502
{{plc{7,xl{{{point to chars in source string{9503
{{mov{8,wa{8,wc{{number of characters to copy{9504
{{mvc{{{{move characters to result string{9505
{{zer{7,xl{{{clear garbage value{9506
{{lcw{7,xr{{{get next code word{9507
{{bri{9,(xr){{{execute next code word{9508
{{ejc{{{{{9510
*      evblk
*      the routine for an evblk is never executed
{b_evt{ent{2,bl_ev{{{entry point (evblk){9516
{{ejc{{{{{9517
*      ffblk
*      the routine for an ffblk is executed from the o_fnc entry
*      to call a field function and extract a field value/name.
*      (xl)                  pointer to ffblk
{b_ffc{ent{2,bl_ff{{{entry point (ffblk){9526
{{mov{7,xr{7,xl{{copy ffblk pointer{9527
{{lcw{8,wc{{{load next code word{9528
{{mov{7,xl{9,(xs){{load pdblk pointer{9529
{{bne{9,(xl){22,=b_pdt{6,bffc2{jump if not pdblk at all{9530
{{mov{8,wa{13,pddfp(xl){{load dfblk pointer from pdblk{9531
*      loop to find correct ffblk for this pdblk
{bffc1{beq{8,wa{13,ffdfp(xr){6,bffc3{jump if this is the correct ffblk{9535
{{mov{7,xr{13,ffnxt(xr){{else link to next ffblk on chain{9536
{{bnz{7,xr{6,bffc1{{loop back if another entry to check{9537
*      here for bad argument
{bffc2{erb{1,041{26,field function argument is wrong datatype{{{9541
{{ejc{{{{{9542
*      ffblk (continued)
*      here after locating correct ffblk
{bffc3{mov{8,wa{13,ffofs(xr){{load field offset{9548
{{beq{8,wc{21,=ofne_{6,bffc5{jump if called by name{9549
{{add{7,xl{8,wa{{else point to value field{9550
{{mov{7,xr{9,(xl){{load value{9551
{{bne{9,(xr){22,=b_trt{6,bffc4{jump if not trapped{9552
{{sub{7,xl{8,wa{{else restore name base,offset{9553
{{mov{9,(xs){8,wc{{save next code word over pdblk ptr{9554
{{jsr{6,acess{{{access value{9555
{{ppm{6,exfal{{{fail if access fails{9556
{{mov{8,wc{9,(xs){{restore next code word{9557
*      here after getting value in (xr), xl is garbage
{bffc4{mov{9,(xs){7,xr{{store value on stack (over pdblk){9561
{{mov{7,xr{8,wc{{copy next code word{9562
{{mov{7,xl{9,(xr){{load entry address{9563
{{bri{7,xl{{{jump to routine for next code word{9564
*      here if called by name
{bffc5{mov{11,-(xs){8,wa{{store name offset (base is set){9568
{{lcw{7,xr{{{get next code word{9569
{{bri{9,(xr){{{execute next code word{9570
{{ejc{{{{{9571
*      icblk
*      the routine for icblk is executed from the generated
*      code to load an integer value onto the stack.
*      (xr)                  pointer to icblk
{b_icl{ent{2,bl_ic{{{entry point (icblk){9580
{{mov{11,-(xs){7,xr{{stack result{9581
{{lcw{7,xr{{{get next code word{9582
{{bri{9,(xr){{{execute it{9583
{{ejc{{{{{9584
*      kvblk
*      the routine for a kvblk is never executed.
{b_kvt{ent{2,bl_kv{{{entry point (kvblk){9590
{{ejc{{{{{9591
*      nmblk
*      the routine for a nmblk is executed from the generated
*      code for the case of loading a name onto the stack
*      where the name is that of a natural variable which can
*      be preevaluated at compile time.
*      (xr)                  pointer to nmblk
{b_nml{ent{2,bl_nm{{{entry point (nmblk){9602
{{mov{11,-(xs){7,xr{{stack result{9603
{{lcw{7,xr{{{get next code word{9604
{{bri{9,(xr){{{execute it{9605
{{ejc{{{{{9606
*      pdblk
*      the routine for a pdblk is never executed
{b_pdt{ent{2,bl_pd{{{entry point (pdblk){9612
{{ejc{{{{{9613
*      pfblk
*      the routine for a pfblk is executed from the entry o_fnc
*      to call a program defined function.
*      (xl)                  pointer to pfblk
*      the following stack entries are made before passing
*      control to the program defined function.
*                            saved value of first argument
*                            .
*                            saved value of last argument
*                            saved value of first local
*                            .
*                            saved value of last local
*                            saved value of function name
*                            saved code block ptr (r_cod)
*                            saved code pointer (-r_cod)
*                            saved value of flprt
*                            saved value of flptr
*                            pointer to pfblk
*      flptr --------------- zero (to be overwritten with offs)
{b_pfc{ent{2,bl_pf{{{entry point (pfblk){9639
{{mov{3,bpfpf{7,xl{{save pfblk ptr (need not be reloc){9640
{{mov{7,xr{7,xl{{copy for the moment{9641
{{mov{7,xl{13,pfvbl(xr){{point to vrblk for function{9642
*      loop to find old value of function
{bpf01{mov{8,wb{7,xl{{save pointer{9646
{{mov{7,xl{13,vrval(xl){{load value{9647
{{beq{9,(xl){22,=b_trt{6,bpf01{loop if trblk{9648
*      set value to null and save old function value
{{mov{3,bpfsv{7,xl{{save old value{9652
{{mov{7,xl{8,wb{{point back to block with value{9653
{{mov{13,vrval(xl){21,=nulls{{set value to null{9654
{{mov{8,wa{13,fargs(xr){{load number of arguments{9655
{{add{7,xr{19,*pfarg{{point to pfarg entries{9656
{{bze{8,wa{6,bpf04{{jump if no arguments{9657
{{mov{7,xt{7,xs{{ptr to last arg{9658
{{wtb{8,wa{{{convert no. of args to bytes offset{9659
{{add{7,xt{8,wa{{point before first arg{9660
{{mov{3,bpfxt{7,xt{{remember arg pointer{9661
{{ejc{{{{{9662
*      pfblk (continued)
*      loop to save old argument values and set new ones
{bpf02{mov{7,xl{10,(xr)+{{load vrblk ptr for next argument{9668
*      loop through possible trblk chain to find value
{bpf03{mov{8,wc{7,xl{{save pointer{9672
{{mov{7,xl{13,vrval(xl){{load next value{9673
{{beq{9,(xl){22,=b_trt{6,bpf03{loop back if trblk{9674
*      save old value and get new value
{{mov{8,wa{7,xl{{keep old value{9678
{{mov{7,xt{3,bpfxt{{point before next stacked arg{9679
{{mov{8,wb{11,-(xt){{load argument (new value){9680
{{mov{9,(xt){8,wa{{save old value{9681
{{mov{3,bpfxt{7,xt{{keep arg ptr for next time{9682
{{mov{7,xl{8,wc{{point back to block with value{9683
{{mov{13,vrval(xl){8,wb{{set new value{9684
{{bne{7,xs{3,bpfxt{6,bpf02{loop if not all done{9685
*      now process locals
{bpf04{mov{7,xl{3,bpfpf{{restore pfblk pointer{9689
{{mov{8,wa{13,pfnlo(xl){{load number of locals{9690
{{bze{8,wa{6,bpf07{{jump if no locals{9691
{{mov{8,wb{21,=nulls{{get null constant{9692
{{lct{8,wa{8,wa{{set local counter{9693
*      loop to process locals
{bpf05{mov{7,xl{10,(xr)+{{load vrblk ptr for next local{9697
*      loop through possible trblk chain to find value
{bpf06{mov{8,wc{7,xl{{save pointer{9701
{{mov{7,xl{13,vrval(xl){{load next value{9702
{{beq{9,(xl){22,=b_trt{6,bpf06{loop back if trblk{9703
*      save old value and set null as new value
{{mov{11,-(xs){7,xl{{stack old value{9707
{{mov{7,xl{8,wc{{point back to block with value{9708
{{mov{13,vrval(xl){8,wb{{set null as new value{9709
{{bct{8,wa{6,bpf05{{loop till all locals processed{9710
{{ejc{{{{{9711
*      pfblk (continued)
*      here after processing arguments and locals
{bpf07{zer{7,xr{{{zero reg xr in case{9720
{{bze{3,kvpfl{6,bpf7c{{skip if profiling is off{9721
{{beq{3,kvpfl{18,=num02{6,bpf7a{branch on type of profile{9722
*      here if &profile = 1
{{jsr{6,systm{{{get current time{9726
{{sti{3,pfetm{{{save for a sec{9727
{{sbi{3,pfstm{{{find time used by caller{9728
{{jsr{6,icbld{{{build into an icblk{9729
{{ldi{3,pfetm{{{reload current time{9730
{{brn{6,bpf7b{{{merge{9731
*       here if &profile = 2
{bpf7a{ldi{3,pfstm{{{get start time of calling stmt{9735
{{jsr{6,icbld{{{assemble an icblk round it{9736
{{jsr{6,systm{{{get now time{9737
*      both types of profile merge here
{bpf7b{sti{3,pfstm{{{set start time of 1st func stmt{9741
{{mnz{3,pffnc{{{flag function entry{9742
*      no profiling merges here
{bpf7c{mov{11,-(xs){7,xr{{stack icblk ptr (or zero){9746
{{mov{8,wa{3,r_cod{{load old code block pointer{9747
{{scp{8,wb{{{get code pointer{9749
{{sub{8,wb{8,wa{{make code pointer into offset{9750
{{mov{7,xl{3,bpfpf{{recall pfblk pointer{9751
{{mov{11,-(xs){3,bpfsv{{stack old value of function name{9752
{{mov{11,-(xs){8,wa{{stack code block pointer{9753
{{mov{11,-(xs){8,wb{{stack code offset{9754
{{mov{11,-(xs){3,flprt{{stack old flprt{9755
{{mov{11,-(xs){3,flptr{{stack old failure pointer{9756
{{mov{11,-(xs){7,xl{{stack pointer to pfblk{9757
{{zer{11,-(xs){{{dummy zero entry for fail return{9758
{{chk{{{{check for stack overflow{9759
{{mov{3,flptr{7,xs{{set new fail return value{9760
{{mov{3,flprt{7,xs{{set new flprt{9761
{{mov{8,wa{3,kvtra{{load trace value{9762
{{add{8,wa{3,kvftr{{add ftrace value{9763
{{bnz{8,wa{6,bpf09{{jump if tracing possible{9764
{{icv{3,kvfnc{{{else bump fnclevel{9765
*      here to actually jump to function
{bpf08{mov{7,xr{13,pfcod(xl){{point to vrblk of entry label{9769
{{mov{7,xr{13,vrlbl(xr){{point to target code{9770
{{beq{7,xr{21,=stndl{6,bpf17{test for undefined label{9771
{{bne{9,(xr){22,=b_trt{6,bpf8a{jump if not trapped{9772
{{mov{7,xr{13,trlbl(xr){{else load ptr to real label code{9773
{bpf8a{bri{9,(xr){{{off to execute function{9774
*      here if tracing is possible
{bpf09{mov{7,xr{13,pfctr(xl){{load possible call trace trblk{9778
{{mov{7,xl{13,pfvbl(xl){{load vrblk pointer for function{9779
{{mov{8,wa{19,*vrval{{set name offset for variable{9780
{{bze{3,kvtra{6,bpf10{{jump if trace mode is off{9781
{{bze{7,xr{6,bpf10{{or if there is no call trace{9782
*      here if call traced
{{dcv{3,kvtra{{{decrement trace count{9786
{{bze{13,trfnc(xr){6,bpf11{{jump if print trace{9787
{{jsr{6,trxeq{{{execute function type trace{9788
{{ejc{{{{{9789
*      pfblk (continued)
*      here to test for ftrace trace
{bpf10{bze{3,kvftr{6,bpf16{{jump if ftrace is off{9795
{{dcv{3,kvftr{{{else decrement ftrace{9796
*      here for print trace
{bpf11{jsr{6,prtsn{{{print statement number{9800
{{jsr{6,prtnm{{{print function name{9801
{{mov{8,wa{18,=ch_pp{{load left paren{9802
{{jsr{6,prtch{{{print left paren{9803
{{mov{7,xl{13,num01(xs){{recover pfblk pointer{9804
{{bze{13,fargs(xl){6,bpf15{{skip if no arguments{9805
{{zer{8,wb{{{else set argument counter{9806
{{brn{6,bpf13{{{jump into loop{9807
*      loop to print argument values
{bpf12{mov{8,wa{18,=ch_cm{{load comma{9811
{{jsr{6,prtch{{{print to separate from last arg{9812
*      merge here first time (no comma required)
{bpf13{mov{9,(xs){8,wb{{save arg ctr (over failoffs is ok){9816
{{wtb{8,wb{{{convert to byte offset{9817
{{add{7,xl{8,wb{{point to next argument pointer{9818
{{mov{7,xr{13,pfarg(xl){{load next argument vrblk ptr{9819
{{sub{7,xl{8,wb{{restore pfblk pointer{9820
{{mov{7,xr{13,vrval(xr){{load next value{9821
{{jsr{6,prtvl{{{print argument value{9822
{{ejc{{{{{9823
*      here after dealing with one argument
{{mov{8,wb{9,(xs){{restore argument counter{9827
{{icv{8,wb{{{increment argument counter{9828
{{blt{8,wb{13,fargs(xl){6,bpf12{loop if more to print{9829
*      merge here in no args case to print paren
{bpf15{mov{8,wa{18,=ch_rp{{load right paren{9833
{{jsr{6,prtch{{{print to terminate output{9834
{{jsr{6,prtnl{{{terminate print line{9835
*      merge here to exit with test for fnclevel trace
{bpf16{icv{3,kvfnc{{{increment fnclevel{9839
{{mov{7,xl{3,r_fnc{{load ptr to possible trblk{9840
{{jsr{6,ktrex{{{call keyword trace routine{9841
*      call function after trace tests complete
{{mov{7,xl{13,num01(xs){{restore pfblk pointer{9845
{{brn{6,bpf08{{{jump back to execute function{9846
*      here if calling a function whose entry label is undefined
{bpf17{mov{3,flptr{13,num02(xs){{reset so exfal can return to evalx{9850
{{erb{1,286{26,function call to undefined entry label{{{9851
{{ejc{{{{{9854
*      rcblk
*      the routine for an rcblk is executed from the generated
*      code to load a real value onto the stack.
*      (xr)                  pointer to rcblk
{b_rcl{ent{2,bl_rc{{{entry point (rcblk){9863
{{mov{11,-(xs){7,xr{{stack result{9864
{{lcw{7,xr{{{get next code word{9865
{{bri{9,(xr){{{execute it{9866
{{ejc{{{{{9868
*      scblk
*      the routine for an scblk is executed from the generated
*      code to load a string value onto the stack.
*      (xr)                  pointer to scblk
{b_scl{ent{2,bl_sc{{{entry point (scblk){9877
{{mov{11,-(xs){7,xr{{stack result{9878
{{lcw{7,xr{{{get next code word{9879
{{bri{9,(xr){{{execute it{9880
{{ejc{{{{{9881
*      tbblk
*      the routine for a tbblk is never executed
{b_tbt{ent{2,bl_tb{{{entry point (tbblk){9887
{{ejc{{{{{9888
*      teblk
*      the routine for a teblk is never executed
{b_tet{ent{2,bl_te{{{entry point (teblk){9894
{{ejc{{{{{9895
*      vcblk
*      the routine for a vcblk is never executed
{b_vct{ent{2,bl_vc{{{entry point (vcblk){9901
{{ejc{{{{{9902
*      vrblk
*      the vrblk routines are executed from the generated code.
*      there are six entries for vrblk covering various cases
{b_vr_{ent{2,bl__i{{{mark start of vrblk entry points{9909
*      entry for vrget (trapped case). this routine is called
*      from the generated code to load the value of a variable.
*      this entry point is used if an access trace or input
*      association is currently active.
*      (xr)                  pointer to vrget field of vrblk
{b_vra{ent{2,bl__i{{{entry point{9918
{{mov{7,xl{7,xr{{copy name base (vrget = 0){9919
{{mov{8,wa{19,*vrval{{set name offset{9920
{{jsr{6,acess{{{access value{9921
{{ppm{6,exfal{{{fail if access fails{9922
{{mov{11,-(xs){7,xr{{stack result{9923
{{lcw{7,xr{{{get next code word{9924
{{bri{9,(xr){{{execute it{9925
{{ejc{{{{{9926
*      vrblk (continued)
*      entry for vrsto (error case. this routine is called from
*      the executed code for an attempt to modify the value
*      of a protected (pattern valued) natural variable.
{b_vre{ent{{{{entry point{9934
{{erb{1,042{26,attempt to change value of protected variable{{{9935
{{ejc{{{{{9936
*      vrblk (continued)
*      entry for vrtra (untrapped case). this routine is called
*      from the executed code to transfer to a label.
*      (xr)                  pointer to vrtra field of vrblk
{b_vrg{ent{{{{entry point{9945
{{mov{7,xr{13,vrlbo(xr){{load code pointer{9946
{{mov{7,xl{9,(xr){{load entry address{9947
{{bri{7,xl{{{jump to routine for next code word{9948
{{ejc{{{{{9949
*      vrblk (continued)
*      entry for vrget (untrapped case). this routine is called
*      from the generated code to load the value of a variable.
*      (xr)                  points to vrget field of vrblk
{b_vrl{ent{{{{entry point{9958
{{mov{11,-(xs){13,vrval(xr){{load value onto stack (vrget = 0){9959
{{lcw{7,xr{{{get next code word{9960
{{bri{9,(xr){{{execute next code word{9961
{{ejc{{{{{9962
*      vrblk (continued)
*      entry for vrsto (untrapped case). this routine is called
*      from the generated code to store the value of a variable.
*      (xr)                  pointer to vrsto field of vrblk
{b_vrs{ent{{{{entry point{9971
{{mov{13,vrvlo(xr){9,(xs){{store value, leave on stack{9972
{{lcw{7,xr{{{get next code word{9973
{{bri{9,(xr){{{execute next code word{9974
{{ejc{{{{{9975
*      vrblk (continued)
*      vrtra (trapped case). this routine is called from the
*      generated code to transfer to a label when a label
*      trace is currently active.
{b_vrt{ent{{{{entry point{9983
{{sub{7,xr{19,*vrtra{{point back to start of vrblk{9984
{{mov{7,xl{7,xr{{copy vrblk pointer{9985
{{mov{8,wa{19,*vrval{{set name offset{9986
{{mov{7,xr{13,vrlbl(xl){{load pointer to trblk{9987
{{bze{3,kvtra{6,bvrt2{{jump if trace is off{9988
{{dcv{3,kvtra{{{else decrement trace count{9989
{{bze{13,trfnc(xr){6,bvrt1{{jump if print trace case{9990
{{jsr{6,trxeq{{{else execute full trace{9991
{{brn{6,bvrt2{{{merge to jump to label{9992
*      here for print trace -- print colon ( label name )
{bvrt1{jsr{6,prtsn{{{print statement number{9996
{{mov{7,xr{7,xl{{copy vrblk pointer{9997
{{mov{8,wa{18,=ch_cl{{colon{9998
{{jsr{6,prtch{{{print it{9999
{{mov{8,wa{18,=ch_pp{{left paren{10000
{{jsr{6,prtch{{{print it{10001
{{jsr{6,prtvn{{{print label name{10002
{{mov{8,wa{18,=ch_rp{{right paren{10003
{{jsr{6,prtch{{{print it{10004
{{jsr{6,prtnl{{{terminate line{10005
{{mov{7,xr{13,vrlbl(xl){{point back to trblk{10006
*      merge here to jump to label
{bvrt2{mov{7,xr{13,trlbl(xr){{load pointer to actual code{10010
{{bri{9,(xr){{{execute statement at label{10011
{{ejc{{{{{10012
*      vrblk (continued)
*      entry for vrsto (trapped case). this routine is called
*      from the generated code to store the value of a variable.
*      this entry is used when a value trace or output
*      association is currently active.
*      (xr)                  pointer to vrsto field of vrblk
{b_vrv{ent{{{{entry point{10023
{{mov{8,wb{9,(xs){{load value (leave copy on stack){10024
{{sub{7,xr{19,*vrsto{{point to vrblk{10025
{{mov{7,xl{7,xr{{copy vrblk pointer{10026
{{mov{8,wa{19,*vrval{{set offset{10027
{{jsr{6,asign{{{call assignment routine{10028
{{ppm{6,exfal{{{fail if assignment fails{10029
{{lcw{7,xr{{{else get next code word{10030
{{bri{9,(xr){{{execute next code word{10031
{{ejc{{{{{10032
*      xnblk
*      the routine for an xnblk is never executed
{b_xnt{ent{2,bl_xn{{{entry point (xnblk){10038
{{ejc{{{{{10039
*      xrblk
*      the routine for an xrblk is never executed
{b_xrt{ent{2,bl_xr{{{entry point (xrblk){10045
*      mark entry address past last block action routine
{b_yyy{ent{2,bl__i{{{last block routine entry point{10049
{{ttl{27,s p i t b o l -- pattern matching routines{{{{10050
*      the following section consists of the pattern matching
*      routines. all pattern nodes contain a pointer (pcode)
*      to one of the routines in this section (p_xxx).
*      note that this section follows the b_xxx routines to
*      enable a fast test for the pattern datatype.
{p_aaa{ent{2,bl__i{{{entry to mark first pattern{10059
*      the entry conditions to the match routine are as follows
*      (see o_pmn, o_pmv, o_pms and procedure match).
*      stack contents.
*                            name base (o_pmn only)
*                            name offset (o_pmn only)
*                            type (0-o_pmn, 1-o_pmv, 2-o_pms)
*      pmhbs --------------- initial cursor (zero)
*                            initial node pointer
*      xs ------------------ =ndabo (anchored), =nduna (unanch)
*      register values.
*           (xs)             set as shown in stack diagram
*           (xr)             pointer to initial pattern node
*           (wb)             initial cursor (zero)
*      global pattern values
*           r_pms            pointer to subject string scblk
*           pmssl            length of subject string in chars
*           pmdfl            dot flag, initially zero
*           pmhbs            set as shown in stack diagram
*      control is passed by branching through the pcode
*      field of the initial pattern node (bri (xr)).
{{ejc{{{{{10089
*      description of algorithm
*      a pattern structure is represented as a linked graph
*      of nodes with the following structure.
*           +------------------------------------+
*           i                pcode               i
*           +------------------------------------+
*           i                pthen               i
*           +------------------------------------+
*           i                parm1               i
*           +------------------------------------+
*           i                parm2               i
*           +------------------------------------+
*      pcode is a pointer to the routine which will perform
*      the match of this particular node type.
*      pthen is a pointer to the successor node. i.e. the node
*      to be matched if the attempt to match this node succeeds.
*      if this is the last node of the pattern pthen points
*      to the dummy node ndnth which initiates pattern exit.
*      parm1, parm2 are parameters whose use varies with the
*      particular node. they are only present if required.
*      alternatives are handled with the special alternative
*      node whose parameter points to the node to be matched
*      if there is a failure on the successor path.
*      the following example illustrates the manner in which
*      the structure is built up. the pattern is
*      (a / b / c) (d / e)   where / is alternation
*      in the diagram, the node marked + represents an
*      alternative node and the dotted line from a + node
*      represents the parameter pointer to the alternative.
*      +---+     +---+     +---+     +---+
*      i + i-----i a i-----i + i-----i d i-----
*      +---+     +---+  i  +---+     +---+
*        .              i    .
*        .              i    .
*      +---+     +---+  i  +---+
*      i + i-----i b i--i  i e i-----
*      +---+     +---+  i  +---+
*        .              i
*        .              i
*      +---+            i
*      i c i------------i
*      +---+
{{ejc{{{{{10143
*      during the match, the registers are used as follows.
*      (xr)                  points to the current node
*      (xl)                  scratch
*      (xs)                  main stack pointer
*      (wb)                  cursor (number of chars matched)
*      (wa,wc)               scratch
*      to keep track of alternatives, the main stack is used as
*      a history stack and contains two word entries.
*      word 1                saved cursor value
*      word 2                node to match on failure
*      when a failure occurs, the most recent entry on this
*      stack is popped off to restore the cursor and point
*      to the node to be matched as an alternative. the entry
*      at the bottom of the stack points to the following
*      special nodes depending on the scan mode.
*      anchored mode         the bottom entry points to the
*                            special node ndabo which causes an
*                            abort. the cursor value stored
*                            with this entry is always zero.
*      unanchored mode       the bottom entry points to the
*                            special node nduna which moves the
*                            anchor point and restarts the match
*                            the cursor saved with this entry
*                            is the number of characters which
*                            lie before the initial anchor point
*                            (i.e. the number of anchor moves).
*                            this entry is three words long and
*                            also contains the initial pattern.
*      entries are made on this history stack by alternative
*      nodes and by some special compound patterns as described
*      later on. the following global locations are used during
*      pattern matching.
*      r_pms                 pointer to subject string
*      pmssl                 length of subject string
*      pmdfl                 flag set non-zero for dot patterns
*      pmhbs                 base ptr for current history stack
*      the following exit points are available to match routines
*      succp                 success in matching current node
*      failp                 failure in matching current node
{{ejc{{{{{10194
*      compound patterns
*      some patterns have implicit alternatives and their
*      representation in the pattern structure consists of a
*      linked set of nodes as indicated by these diagrams.
*      as before, the + represents an alternative node and
*      the dotted line from a + node is the parameter pointer
*      to the alternative pattern.
*      arb
*      ---
*           +---+            this node (p_arb) matches null
*           i b i-----       and stacks cursor, successor ptr,
*           +---+            cursor (copy) and a ptr to ndarc.
*      bal
*      ---
*           +---+            the p_bal node scans a balanced
*           i b i-----       string and then stacks a pointer
*           +---+            to itself on the history stack.
{{ejc{{{{{10222
*      compound pattern structures (continued)
*      arbno
*      -----
*           +---+            this alternative node matches null
*      +----i + i-----       the first time and stacks a pointer
*      i    +---+            to the argument pattern x.
*      i      .
*      i      .
*      i    +---+            node (p_aba) to stack cursor
*      i    i a i            and history stack base ptr.
*      i    +---+
*      i      i
*      i      i
*      i    +---+            this is the argument pattern. as
*      i    i x i            indicated, the successor of the
*      i    +---+            pattern is the p_abc node
*      i      i
*      i      i
*      i    +---+            this node (p_abc) pops pmhbs,
*      +----i c i            stacks old pmhbs and ptr to ndabd
*           +---+            (unless optimization has occurred)
*      structure and execution of this pattern resemble those of
*      recursive pattern matching and immediate assignment.
*      the alternative node at the head of the structure matches
*      null initially but on subsequent failure ensures attempt
*      to match the argument.  before the argument is matched
*      p_aba stacks the cursor, pmhbs and a ptr to p_abb.  if
*      the argument cant be matched , p_abb removes this special
*      stack entry and fails.
*      if argument is matched , p_abc restores the outer pmhbs
*      value (saved by p_aba) .  then if the argument has left
*      alternatives on stack it stacks the inner value of pmhbs
*      and a ptr to ndabd. if argument left nothing on the stack
*      it optimises by removing items stacked by p_aba.  finally
*      a check is made that argument matched more than the null
*      string (check is intended to prevent useless looping).
*      if so the successor is again the alternative node at the
*      head of the structure , ensuring a possible extra attempt
*      to match the arg if necessary.  if not , the successor to
*      alternative is taken so as to terminate the loop.  p_abd
*      restores inner pmhbs ptr and fails , thus trying to match
*      alternatives left by the arbno argument.
{{ejc{{{{{10270
*      compound pattern structures (continued)
*      breakx
*      ------
*           +---+            this node is a break node for
*      +----i b i            the argument to breakx, identical
*      i    +---+            to an ordinary break node.
*      i      i
*      i      i
*      i    +---+            this alternative node stacks a
*      i    i + i-----       pointer to the breakx node to
*      i    +---+            allow for subsequent failure
*      i      .
*      i      .
*      i    +---+            this is the breakx node itself. it
*      +----i x i            matches one character and then
*           +---+            proceeds back to the break node.
*      fence
*      -----
*           +---+            the fence node matches null and
*           i f i-----       stacks a pointer to node ndabo to
*           +---+            abort on a subsequent rematch
*      succeed
*      -------
*           +---+            the node for succeed matches null
*           i s i-----       and stacks a pointer to itself
*           +---+            to repeat the match on a failure.
{{ejc{{{{{10310
*      compound patterns (continued)
*      binary dot (pattern assignment)
*      -------------------------------
*           +---+            this node (p_paa) saves the current
*           i a i            cursor and a pointer to the
*           +---+            special node ndpab on the stack.
*             i
*             i
*           +---+            this is the structure for the
*           i x i            pattern left argument of the
*           +---+            pattern assignment call.
*             i
*             i
*           +---+            this node (p_pac) saves the cursor,
*           i c i-----       a ptr to itself, the cursor (copy)
*           +---+            and a ptr to ndpad on the stack.
*      the function of the match routine for ndpab (p_pab)
*      is simply to unstack itself and fail back onto the stack.
*      the match routine for p_pac also sets the global pattern
*      flag pmdfl non-zero to indicate that pattern assignments
*      may have occured in the pattern match
*      if pmdfl is set at the end of the match (see p_nth), the
*      history stack is scanned for matching ndpab-ndpad pairs
*      and the corresponding pattern assignments are executed.
*      the function of the match routine for ndpad (p_pad)
*      is simply to remove its entry from the stack and fail.
*      this includes removing the special node pointer stored
*      in addition to the standard two entries on the stack.
{{ejc{{{{{10347
*      compount pattern structures (continued)
*      fence (function)
*      ----------------
*           +---+            this node (p_fna) saves the
*           i a i            current history stack and a
*           +---+            pointer to ndfnb on the stack.
*             i
*             i
*           +---+            this is the pattern structure
*           i x i            given as the argument to the
*           +---+            fence function.
*             i
*             i
*           +---+            this node p_fnc restores the outer
*           i c i            history stack ptr saved in p_fna,
*           +---+            and stacks the inner stack base
*                            ptr and a pointer to ndfnd on the
*                            stack.
*      ndfnb (f_fnb) simply is the failure exit for pattern
*      argument failure, and it pops itself and fails onto the
*      stack.
*      the match routine p_fnc allows for an optimization when
*      the fence pattern leaves no alternatives.  in this case,
*      the ndfnb entry is popped, and the match continues.
*      ndfnd (p_fnd) is entered when the pattern fails after
*      going through a non-optimized p_fnc, and it pops the
*      stack back past the innter stack base created by p_fna
{{ejc{{{{{10381
*      compound patterns (continued)
*      expression patterns (recursive pattern matches)
*      -----------------------------------------------
*      initial entry for a pattern node is to the routine p_exa.
*      if the evaluated result of the expression is itself a
*      pattern, then the following steps are taken to arrange
*      for proper recursive processing.
*      1)   a pointer to the current node (the p_exa node) is
*           stored on the history stack with a dummy cursor.
*      2)   a special history stack entry is made in which the
*           node pointer points to ndexb, and the cursor value
*           is the saved value of pmhbs on entry to this node.
*           the match routine for ndexb (p_exb) restores pmhbs
*           from this cursor entry, pops off the p_exa node
*           pointer and fails.
*      3)   the resulting history stack pointer is saved in
*           pmhbs to establish a new level of history stack.
*      after matching a pattern, the end of match routine gets
*      control (p_nth). this routine proceeds as follows.
*      1)   load the current value of pmhbs and recognize the
*           outer level case by the fact that the associated
*           cursor in this case is the pattern match type code
*           which is less than 3. terminate the match in this
*           case and continue execution of the program.
*      2)   otherwise make a special history stack entry in
*           which the node pointer points to the special node
*           ndexc and the cursor is the current value of pmhbs.
*           the match routine for ndexc (p_exc) resets pmhbs to
*           this (inner) value and and then fails.
*      3)   using the history stack entry made on starting the
*           expression (accessible with the current value of
*           pmhbs), restore the p_exa node pointer and the old
*           pmhbs setting. take the successor and continue.
*      an optimization is possible if the expression pattern
*      makes no entries on the history stack. in this case,
*      instead of building the p_exc node in step 2, it is more
*      efficient to simply pop off the p_exb entry and its
*      associated node pointer. the effect is the same.
{{ejc{{{{{10431
*      compound patterns (continued)
*      binary dollar (immediate assignment)
*      ------------------------------------
*           +---+            this node (p_ima) stacks the cursor
*           i a i            pmhbs and a ptr to ndimb and resets
*           +---+            the stack ptr pmhbs.
*             i
*             i
*           +---+            this is the left structure for the
*           i x i            pattern left argument of the
*           +---+            immediate assignment call.
*             i
*             i
*           +---+            this node (p_imc) performs the
*           i c i-----       assignment, pops pmhbs and stacks
*           +---+            the old pmhbs and a ptr to ndimd.
*      the structure and execution of this pattern are similar
*      to those of the recursive expression pattern matching.
*      the match routine for ndimb (p_imb) restores the outer
*      level value of pmhbs, unstacks the saved cursor and fails
*      the match routine p_imc uses the current value of pmhbs
*      to locate the p_imb entry. this entry is used to make
*      the assignment and restore the outer level value of
*      pmhbs. finally, the inner level value of pmhbs and a
*      pointer to the special node ndimd are stacked.
*      the match routine for ndimd (p_imd) restores the inner
*      level value of pmhbs and fails back into the stack.
*      an optimization occurs if the inner pattern makes no
*      entries on the history stack. in this case, p_imc pops
*      the p_imb entry instead of making a p_imd entry.
{{ejc{{{{{10471
*      arbno
*      see compound patterns section for stucture and
*      algorithm for matching this node type.
*      no parameters
{p_aba{ent{2,bl_p0{{{p0blk{10480
{{mov{11,-(xs){8,wb{{stack cursor{10481
{{mov{11,-(xs){7,xr{{stack dummy node ptr{10482
{{mov{11,-(xs){3,pmhbs{{stack old stack base ptr{10483
{{mov{11,-(xs){21,=ndabb{{stack ptr to node ndabb{10484
{{mov{3,pmhbs{7,xs{{store new stack base ptr{10485
{{brn{6,succp{{{succeed{10486
{{ejc{{{{{10487
*      arbno (remove p_aba special stack entry)
*      no parameters (dummy pattern)
{p_abb{ent{{{{entry point{10493
{{mov{3,pmhbs{8,wb{{restore history stack base ptr{10494
{{brn{6,flpop{{{fail and pop dummy node ptr{10495
{{ejc{{{{{10496
*      arbno (check if arg matched null string)
*      no parameters (dummy pattern)
{p_abc{ent{2,bl_p0{{{p0blk{10502
{{mov{7,xt{3,pmhbs{{keep p_abb stack base{10503
{{mov{8,wa{13,num03(xt){{load initial cursor{10504
{{mov{3,pmhbs{13,num01(xt){{restore outer stack base ptr{10505
{{beq{7,xt{7,xs{6,pabc1{jump if no history stack entries{10506
{{mov{11,-(xs){7,xt{{else save inner pmhbs entry{10507
{{mov{11,-(xs){21,=ndabd{{stack ptr to special node ndabd{10508
{{brn{6,pabc2{{{merge{10509
*      optimise case of no extra entries on stack from arbno arg
{pabc1{add{7,xs{19,*num04{{remove ndabb entry and cursor{10513
*      merge to check for matching of null string
{pabc2{bne{8,wa{8,wb{6,succp{allow further attempt if non-null{10517
{{mov{7,xr{13,pthen(xr){{bypass alternative node so as to ...{10518
{{brn{6,succp{{{... refuse further match attempts{10519
{{ejc{{{{{10520
*      arbno (try for alternatives in arbno argument)
*      no parameters (dummy pattern)
{p_abd{ent{{{{entry point{10526
{{mov{3,pmhbs{8,wb{{restore inner stack base ptr{10527
{{brn{6,failp{{{and fail{10528
{{ejc{{{{{10529
*      abort
*      no parameters
{p_abo{ent{2,bl_p0{{{p0blk{10535
{{brn{6,exfal{{{signal statement failure{10536
{{ejc{{{{{10537
*      alternation
*      parm1                 alternative node
{p_alt{ent{2,bl_p1{{{p1blk{10543
{{mov{11,-(xs){8,wb{{stack cursor{10544
{{mov{11,-(xs){13,parm1(xr){{stack pointer to alternative{10545
{{chk{{{{check for stack overflow{10546
{{brn{6,succp{{{if all ok, then succeed{10547
{{ejc{{{{{10548
*      any (one character argument) (1-char string also)
*      parm1                 character argument
{p_ans{ent{2,bl_p1{{{p1blk{10554
{{beq{8,wb{3,pmssl{6,failp{fail if no chars left{10555
{{mov{7,xl{3,r_pms{{else point to subject string{10556
{{plc{7,xl{8,wb{{point to current character{10557
{{lch{8,wa{9,(xl){{load current character{10558
{{bne{8,wa{13,parm1(xr){6,failp{fail if no match{10559
{{icv{8,wb{{{else bump cursor{10560
{{brn{6,succp{{{and succeed{10561
{{ejc{{{{{10562
*      any (multi-character argument case)
*      parm1                 pointer to ctblk
*      parm2                 bit mask to select bit in ctblk
{p_any{ent{2,bl_p2{{{p2blk{10569
*      expression argument case merges here
{pany1{beq{8,wb{3,pmssl{6,failp{fail if no characters left{10573
{{mov{7,xl{3,r_pms{{else point to subject string{10574
{{plc{7,xl{8,wb{{get char ptr to current character{10575
{{lch{8,wa{9,(xl){{load current character{10576
{{mov{7,xl{13,parm1(xr){{point to ctblk{10577
{{wtb{8,wa{{{change to byte offset{10578
{{add{7,xl{8,wa{{point to entry in ctblk{10579
{{mov{8,wa{13,ctchs(xl){{load word from ctblk{10580
{{anb{8,wa{13,parm2(xr){{and with selected bit{10581
{{zrb{8,wa{6,failp{{fail if no match{10582
{{icv{8,wb{{{else bump cursor{10583
{{brn{6,succp{{{and succeed{10584
{{ejc{{{{{10585
*      any (expression argument)
*      parm1                 expression pointer
{p_ayd{ent{2,bl_p1{{{p1blk{10591
{{jsr{6,evals{{{evaluate string argument{10592
{{err{1,043{26,any evaluated argument is not a string{{{10593
{{ppm{6,failp{{{fail if evaluation failure{10594
{{ppm{6,pany1{{{merge multi-char case if ok{10595
{{ejc{{{{{10596
*      p_arb                 initial arb match
*      no parameters
*      the p_arb node is part of a compound pattern structure
*      for an arb pattern (see description of compound patterns)
{p_arb{ent{2,bl_p0{{{p0blk{10605
{{mov{7,xr{13,pthen(xr){{load successor pointer{10606
{{mov{11,-(xs){8,wb{{stack dummy cursor{10607
{{mov{11,-(xs){7,xr{{stack successor pointer{10608
{{mov{11,-(xs){8,wb{{stack cursor{10609
{{mov{11,-(xs){21,=ndarc{{stack ptr to special node ndarc{10610
{{bri{9,(xr){{{execute next node matching null{10611
{{ejc{{{{{10612
*      p_arc                 extend arb match
*      no parameters (dummy pattern)
{p_arc{ent{{{{entry point{10618
{{beq{8,wb{3,pmssl{6,flpop{fail and pop stack to successor{10619
{{icv{8,wb{{{else bump cursor{10620
{{mov{11,-(xs){8,wb{{stack updated cursor{10621
{{mov{11,-(xs){7,xr{{restack pointer to ndarc node{10622
{{mov{7,xr{13,num02(xs){{load successor pointer{10623
{{bri{9,(xr){{{off to reexecute successor node{10624
{{ejc{{{{{10625
*      bal
*      no parameters
*      the p_bal node is part of the compound structure built
*      for bal (see section on compound patterns).
{p_bal{ent{2,bl_p0{{{p0blk{10634
{{zer{8,wc{{{zero parentheses level counter{10635
{{mov{7,xl{3,r_pms{{point to subject string{10636
{{plc{7,xl{8,wb{{point to current character{10637
{{brn{6,pbal2{{{jump into scan loop{10638
*      loop to scan out characters
{pbal1{lch{8,wa{10,(xl)+{{load next character, bump pointer{10642
{{icv{8,wb{{{push cursor for character{10643
{{beq{8,wa{18,=ch_pp{6,pbal3{jump if left paren{10644
{{beq{8,wa{18,=ch_rp{6,pbal4{jump if right paren{10645
{{bze{8,wc{6,pbal5{{else succeed if at outer level{10646
*      here after processing one character
{pbal2{bne{8,wb{3,pmssl{6,pbal1{loop back unless end of string{10650
{{brn{6,failp{{{in which case, fail{10651
*      here on left paren
{pbal3{icv{8,wc{{{bump paren level{10655
{{brn{6,pbal2{{{loop back to check end of string{10656
*      here for right paren
{pbal4{bze{8,wc{6,failp{{fail if no matching left paren{10660
{{dcv{8,wc{{{else decrement level counter{10661
{{bnz{8,wc{6,pbal2{{loop back if not at outer level{10662
*      here after successfully scanning a balanced string
{pbal5{mov{11,-(xs){8,wb{{stack cursor{10666
{{mov{11,-(xs){7,xr{{stack ptr to bal node for extend{10667
{{brn{6,succp{{{and succeed{10668
{{ejc{{{{{10669
*      break (expression argument)
*      parm1                 expression pointer
{p_bkd{ent{2,bl_p1{{{p1blk{10675
{{jsr{6,evals{{{evaluate string expression{10676
{{err{1,044{26,break evaluated argument is not a string{{{10677
{{ppm{6,failp{{{fail if evaluation fails{10678
{{ppm{6,pbrk1{{{merge with multi-char case if ok{10679
{{ejc{{{{{10680
*      break (one character argument)
*      parm1                 character argument
{p_bks{ent{2,bl_p1{{{p1blk{10686
{{mov{8,wc{3,pmssl{{get subject string length{10687
{{sub{8,wc{8,wb{{get number of characters left{10688
{{bze{8,wc{6,failp{{fail if no characters left{10689
{{lct{8,wc{8,wc{{set counter for chars left{10690
{{mov{7,xl{3,r_pms{{point to subject string{10691
{{plc{7,xl{8,wb{{point to current character{10692
*      loop to scan till break character found
{pbks1{lch{8,wa{10,(xl)+{{load next char, bump pointer{10696
{{beq{8,wa{13,parm1(xr){6,succp{succeed if break character found{10697
{{icv{8,wb{{{else push cursor{10698
{{bct{8,wc{6,pbks1{{loop back if more to go{10699
{{brn{6,failp{{{fail if end of string, no break chr{10700
{{ejc{{{{{10701
*      break (multi-character argument)
*      parm1                 pointer to ctblk
*      parm2                 bit mask to select bit column
{p_brk{ent{2,bl_p2{{{p2blk{10708
*      expression argument merges here
{pbrk1{mov{8,wc{3,pmssl{{load subject string length{10712
{{sub{8,wc{8,wb{{get number of characters left{10713
{{bze{8,wc{6,failp{{fail if no characters left{10714
{{lct{8,wc{8,wc{{set counter for characters left{10715
{{mov{7,xl{3,r_pms{{else point to subject string{10716
{{plc{7,xl{8,wb{{point to current character{10717
{{mov{3,psave{7,xr{{save node pointer{10718
*      loop to search for break character
{pbrk2{lch{8,wa{10,(xl)+{{load next char, bump pointer{10722
{{mov{7,xr{13,parm1(xr){{load pointer to ctblk{10723
{{wtb{8,wa{{{convert to byte offset{10724
{{add{7,xr{8,wa{{point to ctblk entry{10725
{{mov{8,wa{13,ctchs(xr){{load ctblk word{10726
{{mov{7,xr{3,psave{{restore node pointer{10727
{{anb{8,wa{13,parm2(xr){{and with selected bit{10728
{{nzb{8,wa{6,succp{{succeed if break character found{10729
{{icv{8,wb{{{else push cursor{10730
{{bct{8,wc{6,pbrk2{{loop back unless end of string{10731
{{brn{6,failp{{{fail if end of string, no break chr{10732
{{ejc{{{{{10733
*      breakx (extension)
*      this is the entry which causes an extension of a breakx
*      match when failure occurs. see section on compound
*      patterns for full details of breakx matching.
*      no parameters
{p_bkx{ent{2,bl_p0{{{p0blk{10743
{{icv{8,wb{{{step cursor past previous break chr{10744
{{brn{6,succp{{{succeed to rematch break{10745
{{ejc{{{{{10746
*      breakx (expression argument)
*      see section on compound patterns for full structure of
*      breakx pattern. the actual character matching uses a
*      break node. however, the entry for the expression
*      argument case is separated to get proper error messages.
*      parm1                 expression pointer
{p_bxd{ent{2,bl_p1{{{p1blk{10757
{{jsr{6,evals{{{evaluate string argument{10758
{{err{1,045{26,breakx evaluated argument is not a string{{{10759
{{ppm{6,failp{{{fail if evaluation fails{10760
{{ppm{6,pbrk1{{{merge with break if all ok{10761
{{ejc{{{{{10762
*      cursor assignment
*      parm1                 name base
*      parm2                 name offset
{p_cas{ent{2,bl_p2{{{p2blk{10769
{{mov{11,-(xs){7,xr{{save node pointer{10770
{{mov{11,-(xs){8,wb{{save cursor{10771
{{mov{7,xl{13,parm1(xr){{load name base{10772
{{mti{8,wb{{{load cursor as integer{10773
{{mov{8,wb{13,parm2(xr){{load name offset{10774
{{jsr{6,icbld{{{get icblk for cursor value{10775
{{mov{8,wa{8,wb{{move name offset{10776
{{mov{8,wb{7,xr{{move value to assign{10777
{{jsr{6,asinp{{{perform assignment{10778
{{ppm{6,flpop{{{fail on assignment failure{10779
{{mov{8,wb{10,(xs)+{{else restore cursor{10780
{{mov{7,xr{10,(xs)+{{restore node pointer{10781
{{brn{6,succp{{{and succeed matching null{10782
{{ejc{{{{{10783
*      expression node (p_exa, initial entry)
*      see compound patterns description for the structure and
*      algorithms for handling expression nodes.
*      parm1                 expression pointer
{p_exa{ent{2,bl_p1{{{p1blk{10792
{{jsr{6,evalp{{{evaluate expression{10793
{{ppm{6,failp{{{fail if evaluation fails{10794
{{blo{8,wa{22,=p_aaa{6,pexa1{jump if result is not a pattern{10795
*      here if result of expression is a pattern
{{mov{11,-(xs){8,wb{{stack dummy cursor{10799
{{mov{11,-(xs){7,xr{{stack ptr to p_exa node{10800
{{mov{11,-(xs){3,pmhbs{{stack history stack base ptr{10801
{{mov{11,-(xs){21,=ndexb{{stack ptr to special node ndexb{10802
{{mov{3,pmhbs{7,xs{{store new stack base pointer{10803
{{mov{7,xr{7,xl{{copy node pointer{10804
{{bri{9,(xr){{{match first node in expression pat{10805
*      here if result of expression is not a pattern
{pexa1{beq{8,wa{22,=b_scl{6,pexa2{jump if it is already a string{10809
{{mov{11,-(xs){7,xl{{else stack result{10810
{{mov{7,xl{7,xr{{save node pointer{10811
{{jsr{6,gtstg{{{convert result to string{10812
{{err{1,046{26,expression does not evaluate to pattern{{{10813
{{mov{8,wc{7,xr{{copy string pointer{10814
{{mov{7,xr{7,xl{{restore node pointer{10815
{{mov{7,xl{8,wc{{copy string pointer again{10816
*      merge here with string pointer in xl
{pexa2{bze{13,sclen(xl){6,succp{{just succeed if null string{10820
{{brn{6,pstr1{{{else merge with string circuit{10821
{{ejc{{{{{10822
*      expression node (p_exb, remove ndexb entry)
*      see compound patterns description for the structure and
*      algorithms for handling expression nodes.
*      no parameters (dummy pattern)
{p_exb{ent{{{{entry point{10831
{{mov{3,pmhbs{8,wb{{restore outer level stack pointer{10832
{{brn{6,flpop{{{fail and pop p_exa node ptr{10833
{{ejc{{{{{10834
*      expression node (p_exc, remove ndexc entry)
*      see compound patterns description for the structure and
*      algorithms for handling expression nodes.
*      no parameters (dummy pattern)
{p_exc{ent{{{{entry point{10843
{{mov{3,pmhbs{8,wb{{restore inner stack base pointer{10844
{{brn{6,failp{{{and fail into expr pattern alternvs{10845
{{ejc{{{{{10846
*      fail
*      no parameters
{p_fal{ent{2,bl_p0{{{p0blk{10852
{{brn{6,failp{{{just signal failure{10853
{{ejc{{{{{10854
*      fence
*      see compound patterns section for the structure and
*      algorithm for matching this node type.
*      no parameters
{p_fen{ent{2,bl_p0{{{p0blk{10863
{{mov{11,-(xs){8,wb{{stack dummy cursor{10864
{{mov{11,-(xs){21,=ndabo{{stack ptr to abort node{10865
{{brn{6,succp{{{and succeed matching null{10866
{{ejc{{{{{10867
*      fence (function)
*      see compound patterns comments at start of this section
*      for details of scheme
*      no parameters
{p_fna{ent{2,bl_p0{{{p0blk{10876
{{mov{11,-(xs){3,pmhbs{{stack current history stack base{10877
{{mov{11,-(xs){21,=ndfnb{{stack indir ptr to p_fnb (failure){10878
{{mov{3,pmhbs{7,xs{{begin new history stack{10879
{{brn{6,succp{{{succeed{10880
{{ejc{{{{{10881
*      fence (function) (reset history stack and fail)
*      no parameters (dummy pattern)
{p_fnb{ent{2,bl_p0{{{p0blk{10887
{{mov{3,pmhbs{8,wb{{restore outer pmhbs stack base{10888
{{brn{6,failp{{{...and fail{10889
{{ejc{{{{{10890
*      fence (function) (make fence trap entry on stack)
*      no parameters (dummy pattern)
{p_fnc{ent{2,bl_p0{{{p0blk{10896
{{mov{7,xt{3,pmhbs{{get inner stack base ptr{10897
{{mov{3,pmhbs{13,num01(xt){{restore outer stack base{10898
{{beq{7,xt{7,xs{6,pfnc1{optimize if no alternatives{10899
{{mov{11,-(xs){7,xt{{else stack inner stack base{10900
{{mov{11,-(xs){21,=ndfnd{{stack ptr to ndfnd{10901
{{brn{6,succp{{{succeed{10902
*      here when fence function left nothing on the stack
{pfnc1{add{7,xs{19,*num02{{pop off p_fnb entry{10906
{{brn{6,succp{{{succeed{10907
{{ejc{{{{{10908
*      fence (function) (skip past alternatives on failure)
*      no parameters (dummy pattern)
{p_fnd{ent{2,bl_p0{{{p0blk{10914
{{mov{7,xs{8,wb{{pop stack to fence() history base{10915
{{brn{6,flpop{{{pop base entry and fail{10916
{{ejc{{{{{10917
*      immediate assignment (initial entry, save current cursor)
*      see compound patterns description for details of the
*      structure and algorithm for matching this node type.
*      no parameters
{p_ima{ent{2,bl_p0{{{p0blk{10926
{{mov{11,-(xs){8,wb{{stack cursor{10927
{{mov{11,-(xs){7,xr{{stack dummy node pointer{10928
{{mov{11,-(xs){3,pmhbs{{stack old stack base pointer{10929
{{mov{11,-(xs){21,=ndimb{{stack ptr to special node ndimb{10930
{{mov{3,pmhbs{7,xs{{store new stack base pointer{10931
{{brn{6,succp{{{and succeed{10932
{{ejc{{{{{10933
*      immediate assignment (remove cursor mark entry)
*      see compound patterns description for details of the
*      structure and algorithms for matching this node type.
*      no parameters (dummy pattern)
{p_imb{ent{{{{entry point{10942
{{mov{3,pmhbs{8,wb{{restore history stack base ptr{10943
{{brn{6,flpop{{{fail and pop dummy node ptr{10944
{{ejc{{{{{10945
*      immediate assignment (perform actual assignment)
*      see compound patterns description for details of the
*      structure and algorithms for matching this node type.
*      parm1                 name base of variable
*      parm2                 name offset of variable
{p_imc{ent{2,bl_p2{{{p2blk{10955
{{mov{7,xt{3,pmhbs{{load pointer to p_imb entry{10956
{{mov{8,wa{8,wb{{copy final cursor{10957
{{mov{8,wb{13,num03(xt){{load initial cursor{10958
{{mov{3,pmhbs{13,num01(xt){{restore outer stack base pointer{10959
{{beq{7,xt{7,xs{6,pimc1{jump if no history stack entries{10960
{{mov{11,-(xs){7,xt{{else save inner pmhbs pointer{10961
{{mov{11,-(xs){21,=ndimd{{and a ptr to special node ndimd{10962
{{brn{6,pimc2{{{merge{10963
*      here if no entries made on history stack
{pimc1{add{7,xs{19,*num04{{remove ndimb entry and cursor{10967
*      merge here to perform assignment
{pimc2{mov{11,-(xs){8,wa{{save current (final) cursor{10971
{{mov{11,-(xs){7,xr{{save current node pointer{10972
{{mov{7,xl{3,r_pms{{point to subject string{10973
{{sub{8,wa{8,wb{{compute substring length{10974
{{jsr{6,sbstr{{{build substring{10975
{{mov{8,wb{7,xr{{move result{10976
{{mov{7,xr{9,(xs){{reload node pointer{10977
{{mov{7,xl{13,parm1(xr){{load name base{10978
{{mov{8,wa{13,parm2(xr){{load name offset{10979
{{jsr{6,asinp{{{perform assignment{10980
{{ppm{6,flpop{{{fail if assignment fails{10981
{{mov{7,xr{10,(xs)+{{else restore node pointer{10982
{{mov{8,wb{10,(xs)+{{restore cursor{10983
{{brn{6,succp{{{and succeed{10984
{{ejc{{{{{10985
*      immediate assignment (remove ndimd entry on failure)
*      see compound patterns description for details of the
*      structure and algorithms for matching this node type.
*      no parameters (dummy pattern)
{p_imd{ent{{{{entry point{10994
{{mov{3,pmhbs{8,wb{{restore inner stack base pointer{10995
{{brn{6,failp{{{and fail{10996
{{ejc{{{{{10997
*      len (integer argument)
*      parm1                 integer argument
{p_len{ent{2,bl_p1{{{p1blk{11003
*      expression argument case merges here
{plen1{add{8,wb{13,parm1(xr){{push cursor indicated amount{11007
{{ble{8,wb{3,pmssl{6,succp{succeed if not off end{11008
{{brn{6,failp{{{else fail{11009
{{ejc{{{{{11010
*      len (expression argument)
*      parm1                 expression pointer
{p_lnd{ent{2,bl_p1{{{p1blk{11016
{{jsr{6,evali{{{evaluate integer argument{11017
{{err{1,047{26,len evaluated argument is not integer{{{11018
{{err{1,048{26,len evaluated argument is negative or too large{{{11019
{{ppm{6,failp{{{fail if evaluation fails{11020
{{ppm{6,plen1{{{merge with normal circuit if ok{11021
{{ejc{{{{{11022
*      notany (expression argument)
*      parm1                 expression pointer
{p_nad{ent{2,bl_p1{{{p1blk{11028
{{jsr{6,evals{{{evaluate string argument{11029
{{err{1,049{26,notany evaluated argument is not a string{{{11030
{{ppm{6,failp{{{fail if evaluation fails{11031
{{ppm{6,pnay1{{{merge with multi-char case if ok{11032
{{ejc{{{{{11033
*      notany (one character argument)
*      parm1                 character argument
{p_nas{ent{2,bl_p1{{{entry point{11039
{{beq{8,wb{3,pmssl{6,failp{fail if no chars left{11040
{{mov{7,xl{3,r_pms{{else point to subject string{11041
{{plc{7,xl{8,wb{{point to current character in strin{11042
{{lch{8,wa{9,(xl){{load current character{11043
{{beq{8,wa{13,parm1(xr){6,failp{fail if match{11044
{{icv{8,wb{{{else bump cursor{11045
{{brn{6,succp{{{and succeed{11046
{{ejc{{{{{11047
*      notany (multi-character string argument)
*      parm1                 pointer to ctblk
*      parm2                 bit mask to select bit column
{p_nay{ent{2,bl_p2{{{p2blk{11054
*      expression argument case merges here
{pnay1{beq{8,wb{3,pmssl{6,failp{fail if no characters left{11058
{{mov{7,xl{3,r_pms{{else point to subject string{11059
{{plc{7,xl{8,wb{{point to current character{11060
{{lch{8,wa{9,(xl){{load current character{11061
{{wtb{8,wa{{{convert to byte offset{11062
{{mov{7,xl{13,parm1(xr){{load pointer to ctblk{11063
{{add{7,xl{8,wa{{point to entry in ctblk{11064
{{mov{8,wa{13,ctchs(xl){{load entry from ctblk{11065
{{anb{8,wa{13,parm2(xr){{and with selected bit{11066
{{nzb{8,wa{6,failp{{fail if character is matched{11067
{{icv{8,wb{{{else bump cursor{11068
{{brn{6,succp{{{and succeed{11069
{{ejc{{{{{11070
*      end of pattern match
*      this routine is entered on successful completion.
*      see description of expression patterns in compound
*      pattern section for handling of recursion in matching.
*      this pattern also results from an attempt to convert the
*      null string to a pattern via convert()
*      no parameters (dummy pattern)
{p_nth{ent{2,bl_p0{{{p0blk (dummy){11083
{{mov{7,xt{3,pmhbs{{load pointer to base of stack{11084
{{mov{8,wa{13,num01(xt){{load saved pmhbs (or pattern type){11085
{{ble{8,wa{18,=num02{6,pnth2{jump if outer level (pattern type){11086
*      here we are at the end of matching an expression pattern
{{mov{3,pmhbs{8,wa{{restore outer stack base pointer{11090
{{mov{7,xr{13,num02(xt){{restore pointer to p_exa node{11091
{{beq{7,xt{7,xs{6,pnth1{jump if no history stack entries{11092
{{mov{11,-(xs){7,xt{{else stack inner stack base ptr{11093
{{mov{11,-(xs){21,=ndexc{{stack ptr to special node ndexc{11094
{{brn{6,succp{{{and succeed{11095
*      here if no history stack entries during pattern
{pnth1{add{7,xs{19,*num04{{remove p_exb entry and node ptr{11099
{{brn{6,succp{{{and succeed{11100
*      here if end of match at outer level
{pnth2{mov{3,pmssl{8,wb{{save final cursor in safe place{11104
{{bze{3,pmdfl{6,pnth6{{jump if no pattern assignments{11105
{{ejc{{{{{11106
*      end of pattern match (continued)
*      now we must perform pattern assignments. this is done by
*      scanning the history stack for matching ndpab-ndpad pairs
{pnth3{dca{7,xt{{{point past cursor entry{11113
{{mov{8,wa{11,-(xt){{load node pointer{11114
{{beq{8,wa{21,=ndpad{6,pnth4{jump if ndpad entry{11115
{{bne{8,wa{21,=ndpab{6,pnth5{jump if not ndpab entry{11116
*      here for ndpab entry, stack initial cursor
*      note that there must be more entries on the stack.
{{mov{11,-(xs){13,num01(xt){{stack initial cursor{11121
{{chk{{{{check for stack overflow{11122
{{brn{6,pnth3{{{loop back if ok{11123
*      here for ndpad entry. the starting cursor from the
*      matching ndpad entry is now the top stack entry.
{pnth4{mov{8,wa{13,num01(xt){{load final cursor{11128
{{mov{8,wb{9,(xs){{load initial cursor from stack{11129
{{mov{9,(xs){7,xt{{save history stack scan ptr{11130
{{sub{8,wa{8,wb{{compute length of string{11131
*      build substring and perform assignment
{{mov{7,xl{3,r_pms{{point to subject string{11135
{{jsr{6,sbstr{{{construct substring{11136
{{mov{8,wb{7,xr{{copy substring pointer{11137
{{mov{7,xt{9,(xs){{reload history stack scan ptr{11138
{{mov{7,xl{13,num02(xt){{load pointer to p_pac node with nam{11139
{{mov{8,wa{13,parm2(xl){{load name offset{11140
{{mov{7,xl{13,parm1(xl){{load name base{11141
{{jsr{6,asinp{{{perform assignment{11142
{{ppm{6,exfal{{{match fails if name eval fails{11143
{{mov{7,xt{10,(xs)+{{else restore history stack ptr{11144
{{ejc{{{{{11145
*      end of pattern match (continued)
*      here check for end of entries
{pnth5{bne{7,xt{7,xs{6,pnth3{loop if more entries to scan{11151
*      here after dealing with pattern assignments
{pnth6{mov{7,xs{3,pmhbs{{wipe out history stack{11155
{{mov{8,wb{10,(xs)+{{load initial cursor{11156
{{mov{8,wc{10,(xs)+{{load match type code{11157
{{mov{8,wa{3,pmssl{{load final cursor value{11158
{{mov{7,xl{3,r_pms{{point to subject string{11159
{{zer{3,r_pms{{{clear subject string ptr for gbcol{11160
{{bze{8,wc{6,pnth7{{jump if call by name{11161
{{beq{8,wc{18,=num02{6,pnth9{exit if statement level call{11162
*      here we have a call by value, build substring
{{sub{8,wa{8,wb{{compute length of string{11166
{{jsr{6,sbstr{{{build substring{11167
{{mov{11,-(xs){7,xr{{stack result{11168
{{lcw{7,xr{{{get next code word{11169
{{bri{9,(xr){{{execute it{11170
*      here for call by name, make stack entries for o_rpl
{pnth7{mov{11,-(xs){8,wb{{stack initial cursor{11174
{{mov{11,-(xs){8,wa{{stack final cursor{11175
*      here with xl pointing to scblk or bcblk
{pnth8{mov{11,-(xs){7,xl{{stack subject pointer{11184
*      here to obey next code word
{pnth9{lcw{7,xr{{{get next code word{11188
{{bri{9,(xr){{{execute next code word{11189
{{ejc{{{{{11190
*      pos (integer argument)
*      parm1                 integer argument
{p_pos{ent{2,bl_p1{{{p1blk{11196
*      optimize pos if it is the first pattern element,
*      unanchored mode, cursor is zero and pos argument
*      is not beyond end of string.  force cursor position
*      and number of unanchored moves.
*      this optimization is performed invisible provided
*      the argument is either a simple integer or an
*      expression that is an untraced variable (that is,
*      it has no side effects that would be lost by short-
*      circuiting the normal logic of failing and moving the
*      unanchored starting point.)
*      pos (integer argument)
*      parm1                 integer argument
{{beq{8,wb{13,parm1(xr){6,succp{succeed if at right location{11214
{{bnz{8,wb{6,failp{{don't look further if cursor not 0{11215
{{mov{7,xt{3,pmhbs{{get history stack base ptr{11216
{{bne{7,xr{11,-(xt){6,failp{fail if pos is not first node{11217
*      expression argument circuit merges here
{ppos2{bne{11,-(xt){21,=nduna{6,failp{fail if not unanchored mode{11221
{{mov{8,wb{13,parm1(xr){{get desired cursor position{11222
{{bgt{8,wb{3,pmssl{6,exfal{abort if off end{11223
{{mov{13,num02(xt){8,wb{{fake number of unanchored moves{11224
{{brn{6,succp{{{continue match with adjusted cursor{11225
{{ejc{{{{{11226
*      pos (expression argument)
*      parm1                 expression pointer
{p_psd{ent{2,bl_p1{{{p1blk{11232
{{jsr{6,evali{{{evaluate integer argument{11233
{{err{1,050{26,pos evaluated argument is not integer{{{11234
{{err{1,051{26,pos evaluated argument is negative or too large{{{11235
{{ppm{6,failp{{{fail if evaluation fails{11236
{{ppm{6,ppos1{{{process expression case{11237
{ppos1{beq{8,wb{13,parm1(xr){6,succp{succeed if at right location{11239
{{bnz{8,wb{6,failp{{don't look further if cursor not 0{11240
{{bnz{3,evlif{6,failp{{fail if complex argument{11241
{{mov{7,xt{3,pmhbs{{get history stack base ptr{11242
{{mov{8,wa{3,evlio{{get original node ptr{11243
{{bne{8,wa{11,-(xt){6,failp{fail if pos is not first node{11244
{{brn{6,ppos2{{{merge with integer argument code{11245
{{ejc{{{{{11246
*      pattern assignment (initial entry, save cursor)
*      see compound patterns description for the structure and
*      algorithms for matching this node type.
*      no parameters
{p_paa{ent{2,bl_p0{{{p0blk{11255
{{mov{11,-(xs){8,wb{{stack initial cursor{11256
{{mov{11,-(xs){21,=ndpab{{stack ptr to ndpab special node{11257
{{brn{6,succp{{{and succeed matching null{11258
{{ejc{{{{{11259
*      pattern assignment (remove saved cursor)
*      see compound patterns description for the structure and
*      algorithms for matching this node type.
*      no parameters (dummy pattern)
{p_pab{ent{{{{entry point{11268
{{brn{6,failp{{{just fail (entry is already popped){11269
{{ejc{{{{{11270
*      pattern assignment (end of match, make assign entry)
*      see compound patterns description for the structure and
*      algorithms for matching this node type.
*      parm1                 name base of variable
*      parm2                 name offset of variable
{p_pac{ent{2,bl_p2{{{p2blk{11280
{{mov{11,-(xs){8,wb{{stack dummy cursor value{11281
{{mov{11,-(xs){7,xr{{stack pointer to p_pac node{11282
{{mov{11,-(xs){8,wb{{stack final cursor{11283
{{mov{11,-(xs){21,=ndpad{{stack ptr to special ndpad node{11284
{{mnz{3,pmdfl{{{set dot flag non-zero{11285
{{brn{6,succp{{{and succeed{11286
{{ejc{{{{{11287
*      pattern assignment (remove assign entry)
*      see compound patterns description for the structure and
*      algorithms for matching this node type.
*      no parameters (dummy node)
{p_pad{ent{{{{entry point{11296
{{brn{6,flpop{{{fail and remove p_pac node{11297
{{ejc{{{{{11298
*      rem
*      no parameters
{p_rem{ent{2,bl_p0{{{p0blk{11304
{{mov{8,wb{3,pmssl{{point cursor to end of string{11305
{{brn{6,succp{{{and succeed{11306
{{ejc{{{{{11307
*      rpos (expression argument)
*      optimize rpos if it is the first pattern element,
*      unanchored mode, cursor is zero and rpos argument
*      is not beyond end of string.  force cursor position
*      and number of unanchored moves.
*      this optimization is performed invisibly provided
*      the argument is either a simple integer or an
*      expression that is an untraced variable (that is,
*      it has no side effects that would be lost by short-
*      circuiting the normal logic of failing and moving the
*      unanchored starting point).
*      parm1                 expression pointer
{p_rpd{ent{2,bl_p1{{{p1blk{11325
{{jsr{6,evali{{{evaluate integer argument{11326
{{err{1,052{26,rpos evaluated argument is not integer{{{11327
{{err{1,053{26,rpos evaluated argument is negative or too large{{{11328
{{ppm{6,failp{{{fail if evaluation fails{11329
{{ppm{6,prps1{{{merge with normal case if ok{11330
{prps1{mov{8,wc{3,pmssl{{get length of string{11332
{{sub{8,wc{8,wb{{get number of characters remaining{11333
{{beq{8,wc{13,parm1(xr){6,succp{succeed if at right location{11334
{{bnz{8,wb{6,failp{{don't look further if cursor not 0{11335
{{bnz{3,evlif{6,failp{{fail if complex argument{11336
{{mov{7,xt{3,pmhbs{{get history stack base ptr{11337
{{mov{8,wa{3,evlio{{get original node ptr{11338
{{bne{8,wa{11,-(xt){6,failp{fail if pos is not first node{11339
{{brn{6,prps2{{{merge with integer arg code{11340
{{ejc{{{{{11341
*      rpos (integer argument)
*      parm1                 integer argument
{p_rps{ent{2,bl_p1{{{p1blk{11347
*      rpos (integer argument)
*      parm1                 integer argument
{{mov{8,wc{3,pmssl{{get length of string{11353
{{sub{8,wc{8,wb{{get number of characters remaining{11354
{{beq{8,wc{13,parm1(xr){6,succp{succeed if at right location{11355
{{bnz{8,wb{6,failp{{don't look further if cursor not 0{11356
{{mov{7,xt{3,pmhbs{{get history stack base ptr{11357
{{bne{7,xr{11,-(xt){6,failp{fail if rpos is not first node{11358
*      expression argument merges here
{prps2{bne{11,-(xt){21,=nduna{6,failp{fail if not unanchored mode{11362
{{mov{8,wb{3,pmssl{{point to end of string{11363
{{blt{8,wb{13,parm1(xr){6,failp{fail if string not long enough{11364
{{sub{8,wb{13,parm1(xr){{else set new cursor{11365
{{mov{13,num02(xt){8,wb{{fake number of unanchored moves{11366
{{brn{6,succp{{{continue match with adjusted cursor{11367
{{ejc{{{{{11368
*      rtab (integer argument)
*      parm1                 integer argument
{p_rtb{ent{2,bl_p1{{{p1blk{11374
*      expression argument case merges here
{prtb1{mov{8,wc{8,wb{{save initial cursor{11378
{{mov{8,wb{3,pmssl{{point to end of string{11379
{{blt{8,wb{13,parm1(xr){6,failp{fail if string not long enough{11380
{{sub{8,wb{13,parm1(xr){{else set new cursor{11381
{{bge{8,wb{8,wc{6,succp{and succeed if not too far already{11382
{{brn{6,failp{{{in which case, fail{11383
{{ejc{{{{{11384
*      rtab (expression argument)
*      parm1                 expression pointer
{p_rtd{ent{2,bl_p1{{{p1blk{11390
{{jsr{6,evali{{{evaluate integer argument{11391
{{err{1,054{26,rtab evaluated argument is not integer{{{11392
{{err{1,055{26,rtab evaluated argument is negative or too large{{{11393
{{ppm{6,failp{{{fail if evaluation fails{11394
{{ppm{6,prtb1{{{merge with normal case if success{11395
{{ejc{{{{{11396
*      span (expression argument)
*      parm1                 expression pointer
{p_spd{ent{2,bl_p1{{{p1blk{11402
{{jsr{6,evals{{{evaluate string argument{11403
{{err{1,056{26,span evaluated argument is not a string{{{11404
{{ppm{6,failp{{{fail if evaluation fails{11405
{{ppm{6,pspn1{{{merge with multi-char case if ok{11406
{{ejc{{{{{11407
*      span (multi-character argument case)
*      parm1                 pointer to ctblk
*      parm2                 bit mask to select bit column
{p_spn{ent{2,bl_p2{{{p2blk{11414
*      expression argument case merges here
{pspn1{mov{8,wc{3,pmssl{{copy subject string length{11418
{{sub{8,wc{8,wb{{calculate number of characters left{11419
{{bze{8,wc{6,failp{{fail if no characters left{11420
{{mov{7,xl{3,r_pms{{point to subject string{11421
{{plc{7,xl{8,wb{{point to current character{11422
{{mov{3,psavc{8,wb{{save initial cursor{11423
{{mov{3,psave{7,xr{{save node pointer{11424
{{lct{8,wc{8,wc{{set counter for chars left{11425
*      loop to scan matching characters
{pspn2{lch{8,wa{10,(xl)+{{load next character, bump pointer{11429
{{wtb{8,wa{{{convert to byte offset{11430
{{mov{7,xr{13,parm1(xr){{point to ctblk{11431
{{add{7,xr{8,wa{{point to ctblk entry{11432
{{mov{8,wa{13,ctchs(xr){{load ctblk entry{11433
{{mov{7,xr{3,psave{{restore node pointer{11434
{{anb{8,wa{13,parm2(xr){{and with selected bit{11435
{{zrb{8,wa{6,pspn3{{jump if no match{11436
{{icv{8,wb{{{else push cursor{11437
{{bct{8,wc{6,pspn2{{loop back unless end of string{11438
*      here after scanning matching characters
{pspn3{bne{8,wb{3,psavc{6,succp{succeed if chars matched{11442
{{brn{6,failp{{{else fail if null string matched{11443
{{ejc{{{{{11444
*      span (one character argument)
*      parm1                 character argument
{p_sps{ent{2,bl_p1{{{p1blk{11450
{{mov{8,wc{3,pmssl{{get subject string length{11451
{{sub{8,wc{8,wb{{calculate number of characters left{11452
{{bze{8,wc{6,failp{{fail if no characters left{11453
{{mov{7,xl{3,r_pms{{else point to subject string{11454
{{plc{7,xl{8,wb{{point to current character{11455
{{mov{3,psavc{8,wb{{save initial cursor{11456
{{lct{8,wc{8,wc{{set counter for characters left{11457
*      loop to scan matching characters
{psps1{lch{8,wa{10,(xl)+{{load next character, bump pointer{11461
{{bne{8,wa{13,parm1(xr){6,psps2{jump if no match{11462
{{icv{8,wb{{{else push cursor{11463
{{bct{8,wc{6,psps1{{and loop unless end of string{11464
*      here after scanning matching characters
{psps2{bne{8,wb{3,psavc{6,succp{succeed if chars matched{11468
{{brn{6,failp{{{fail if null string matched{11469
{{ejc{{{{{11470
*      multi-character string
*      note that one character strings use the circuit for
*      one character any arguments (p_an1).
*      parm1                 pointer to scblk for string arg
{p_str{ent{2,bl_p1{{{p1blk{11479
{{mov{7,xl{13,parm1(xr){{get pointer to string{11480
*      merge here after evaluating expression with string value
{pstr1{mov{3,psave{7,xr{{save node pointer{11484
{{mov{7,xr{3,r_pms{{load subject string pointer{11485
{{plc{7,xr{8,wb{{point to current character{11486
{{add{8,wb{13,sclen(xl){{compute new cursor position{11487
{{bgt{8,wb{3,pmssl{6,failp{fail if past end of string{11488
{{mov{3,psavc{8,wb{{save updated cursor{11489
{{mov{8,wa{13,sclen(xl){{get number of chars to compare{11490
{{plc{7,xl{{{point to chars of test string{11491
{{cmc{6,failp{6,failp{{compare, fail if not equal{11492
{{mov{7,xr{3,psave{{if all matched, restore node ptr{11493
{{mov{8,wb{3,psavc{{restore updated cursor{11494
{{brn{6,succp{{{and succeed{11495
{{ejc{{{{{11496
*      succeed
*      see section on compound patterns for details of the
*      structure and algorithms for matching this node type
*      no parameters
{p_suc{ent{2,bl_p0{{{p0blk{11505
{{mov{11,-(xs){8,wb{{stack cursor{11506
{{mov{11,-(xs){7,xr{{stack pointer to this node{11507
{{brn{6,succp{{{succeed matching null{11508
{{ejc{{{{{11509
*      tab (integer argument)
*      parm1                 integer argument
{p_tab{ent{2,bl_p1{{{p1blk{11515
*      expression argument case merges here
{ptab1{bgt{8,wb{13,parm1(xr){6,failp{fail if too far already{11519
{{mov{8,wb{13,parm1(xr){{else set new cursor position{11520
{{ble{8,wb{3,pmssl{6,succp{succeed if not off end{11521
{{brn{6,failp{{{else fail{11522
{{ejc{{{{{11523
*      tab (expression argument)
*      parm1                 expression pointer
{p_tbd{ent{2,bl_p1{{{p1blk{11529
{{jsr{6,evali{{{evaluate integer argument{11530
{{err{1,057{26,tab evaluated argument is not integer{{{11531
{{err{1,058{26,tab evaluated argument is negative or too large{{{11532
{{ppm{6,failp{{{fail if evaluation fails{11533
{{ppm{6,ptab1{{{merge with normal case if ok{11534
{{ejc{{{{{11535
*      anchor movement
*      no parameters (dummy node)
{p_una{ent{{{{entry point{11541
{{mov{7,xr{8,wb{{copy initial pattern node pointer{11542
{{mov{8,wb{9,(xs){{get initial cursor{11543
{{beq{8,wb{3,pmssl{6,exfal{match fails if at end of string{11544
{{icv{8,wb{{{else increment cursor{11545
{{mov{9,(xs){8,wb{{store incremented cursor{11546
{{mov{11,-(xs){7,xr{{restack initial node ptr{11547
{{mov{11,-(xs){21,=nduna{{restack unanchored node{11548
{{bri{9,(xr){{{rematch first node{11549
{{ejc{{{{{11550
*      end of pattern match routines
*      the following entry point marks the end of the pattern
*      matching routines and also the end of the entry points
*      referenced from the first word of blocks in dynamic store
{p_yyy{ent{2,bl__i{{{mark last entry in pattern section{11558
{{ttl{27,s p i t b o l -- snobol4 built-in label routines{{{{11559
*      the following section contains the routines for labels
*      which have a predefined meaning in snobol4.
*      control is passed directly to the label name entry point.
*      entry names are of the form l_xxx where xxx is the three
*      letter variable name identifier.
*      entries are in alphabetical order
{{ejc{{{{{11570
*      abort
{l_abo{ent{{{{entry point{11574
*      merge here if execution terminates in error
{labo1{mov{8,wa{3,kvert{{load error code{11578
{{bze{8,wa{6,labo3{{jump if no error has occured{11579
{{jsr{6,sysax{{{call after execution proc{11581
{{mov{8,wc{3,kvstn{{current statement{11585
{{jsr{6,filnm{{{obtain file name for this statement{11586
{{mov{7,xr{3,r_cod{{current code block{11589
{{mov{8,wc{13,cdsln(xr){{line number{11590
{{zer{8,wb{{{column number{11594
{{mov{7,xr{3,stage{{{11595
{{jsr{6,sysea{{{advise system of error{11596
{{ppm{6,stpr4{{{if system does not want print{11597
{{jsr{6,prtpg{{{else eject printer{11599
{{bze{7,xr{6,labo2{{did sysea request print{11601
{{jsr{6,prtst{{{print text from sysea{11602
{labo2{jsr{6,ermsg{{{print error message{11604
{{zer{7,xr{{{indicate no message to print{11605
{{brn{6,stopr{{{jump to routine to stop run{11606
*      here if no error had occured
{labo3{erb{1,036{26,goto abort with no preceding error{{{11610
{{ejc{{{{{11611
*      continue
{l_cnt{ent{{{{entry point{11615
*      merge here after execution error
{lcnt1{mov{7,xr{3,r_cnt{{load continuation code block ptr{11619
{{bze{7,xr{6,lcnt3{{jump if no previous error{11620
{{zer{3,r_cnt{{{clear flag{11621
{{mov{3,r_cod{7,xr{{else store as new code block ptr{11622
{{bne{9,(xr){22,=b_cdc{6,lcnt2{jump if not complex go{11623
{{mov{8,wa{3,stxoc{{get offset of error{11624
{{bge{8,wa{3,stxof{6,lcnt4{jump if error in goto evaluation{11625
*      here if error did not occur in complex failure goto
{lcnt2{add{7,xr{3,stxof{{add failure offset{11629
{{lcp{7,xr{{{load code pointer{11630
{{mov{7,xs{3,flptr{{reset stack pointer{11631
{{lcw{7,xr{{{get next code word{11632
{{bri{9,(xr){{{execute next code word{11633
*      here if no previous error
{lcnt3{icv{3,errft{{{fatal error{11637
{{erb{1,037{26,goto continue with no preceding error{{{11638
*      here if error in evaluation of failure goto.
*      cannot continue back to failure goto!
{lcnt4{icv{3,errft{{{fatal error{11643
{{erb{1,332{26,goto continue with error in failure goto{{{11644
{{ejc{{{{{11645
*      end
{l_end{ent{{{{entry point{11649
*      merge here from end code circuit
{lend0{mov{7,xr{21,=endms{{point to message /normal term.../{11653
{{brn{6,stopr{{{jump to routine to stop run{11654
{{ejc{{{{{11655
*      freturn
{l_frt{ent{{{{entry point{11659
{{mov{8,wa{21,=scfrt{{point to string /freturn/{11660
{{brn{6,retrn{{{jump to common return routine{11661
{{ejc{{{{{11662
*      nreturn
{l_nrt{ent{{{{entry point{11666
{{mov{8,wa{21,=scnrt{{point to string /nreturn/{11667
{{brn{6,retrn{{{jump to common return routine{11668
{{ejc{{{{{11669
*      return
{l_rtn{ent{{{{entry point{11673
{{mov{8,wa{21,=scrtn{{point to string /return/{11674
{{brn{6,retrn{{{jump to common return routine{11675
{{ejc{{{{{11676
*      scontinue
{l_scn{ent{{{{entry point{11680
{{mov{7,xr{3,r_cnt{{load continuation code block ptr{11681
{{bze{7,xr{6,lscn2{{jump if no previous error{11682
{{zer{3,r_cnt{{{clear flag{11683
{{bne{3,kvert{18,=nm320{6,lscn1{error must be user interrupt{11684
{{beq{3,kvert{18,=nm321{6,lscn2{detect scontinue loop{11685
{{mov{3,r_cod{7,xr{{else store as new code block ptr{11686
{{add{7,xr{3,stxoc{{add resume offset{11687
{{lcp{7,xr{{{load code pointer{11688
{{lcw{7,xr{{{get next code word{11689
{{bri{9,(xr){{{execute next code word{11690
*      here if no user interrupt
{lscn1{icv{3,errft{{{fatal error{11694
{{erb{1,331{26,goto scontinue with no user interrupt{{{11695
*      here if in scontinue loop or if no previous error
{lscn2{icv{3,errft{{{fatal error{11699
{{erb{1,321{26,goto scontinue with no preceding error{{{11700
{{ejc{{{{{11701
*      undefined label
{l_und{ent{{{{entry point{11705
{{erb{1,038{26,goto undefined label{{{11706
{{ttl{27,s p i t b o l -- predefined snobol4 functions{{{{11707
*      the following section contains coding for functions
*      which are predefined and available at the snobol level.
*      these routines receive control directly from the code or
*      indirectly through the o_fnc, o_fns or cfunc routines.
*      in both cases the conditions on entry are as follows
*      the arguments are on the stack. the number of arguments
*      has been adjusted to correspond to the svblk svnar field.
*      in certain functions the direct call is not permitted
*      and in these instances we also have.
*      (wa)                  actual number of arguments in call
*      control returns by placing the function result value on
*      on the stack and continuing execution with the next
*      word from the generated code.
*      the names of the entry points of these functions are of
*      the form s_xxx where xxx is the three letter code for
*      the system variable name. the functions are in order
*      alphabetically by their entry names.
{{ejc{{{{{11732
*      any
{s_any{ent{{{{entry point{11786
{{mov{8,wb{22,=p_ans{{set pcode for single char case{11787
{{mov{7,xl{22,=p_any{{pcode for multi-char case{11788
{{mov{8,wc{22,=p_ayd{{pcode for expression case{11789
{{jsr{6,patst{{{call common routine to build node{11790
{{err{1,059{26,any argument is not a string or expression{{{11791
{{mov{11,-(xs){7,xr{{stack result{11792
{{lcw{7,xr{{{get next code word{11793
{{bri{9,(xr){{{execute it{11794
{{ejc{{{{{11795
*      apply
*      apply does not permit the direct (fast) call so that
*      wa contains the actual number of arguments passed.
{s_app{ent{{{{entry point{11821
{{bze{8,wa{6,sapp3{{jump if no arguments{11822
{{dcv{8,wa{{{else get applied func arg count{11823
{{mov{8,wb{8,wa{{copy{11824
{{wtb{8,wb{{{convert to bytes{11825
{{mov{7,xt{7,xs{{copy stack pointer{11826
{{add{7,xt{8,wb{{point to function argument on stack{11827
{{mov{7,xr{9,(xt){{load function ptr (apply 1st arg){11828
{{bze{8,wa{6,sapp2{{jump if no args for applied func{11829
{{lct{8,wb{8,wa{{else set counter for loop{11830
*      loop to move arguments up on stack
{sapp1{dca{7,xt{{{point to next argument{11834
{{mov{13,num01(xt){9,(xt){{move argument up{11835
{{bct{8,wb{6,sapp1{{loop till all moved{11836
*      merge here to call function (wa = number of arguments)
{sapp2{ica{7,xs{{{adjust stack ptr for apply 1st arg{11840
{{jsr{6,gtnvr{{{get variable block addr for func{11841
{{ppm{6,sapp3{{{jump if not natural variable{11842
{{mov{7,xl{13,vrfnc(xr){{else point to function block{11843
{{brn{6,cfunc{{{go call applied function{11844
*      here for invalid first argument
{sapp3{erb{1,060{26,apply first arg is not natural variable name{{{11848
{{ejc{{{{{11849
*      arbno
*      arbno builds a compound pattern. see description at
*      start of pattern matching section for structure formed.
{s_abn{ent{{{{entry point{11856
{{zer{7,xr{{{set parm1 = 0 for the moment{11857
{{mov{8,wb{22,=p_alt{{set pcode for alternative node{11858
{{jsr{6,pbild{{{build alternative node{11859
{{mov{7,xl{7,xr{{save ptr to alternative pattern{11860
{{mov{8,wb{22,=p_abc{{pcode for p_abc{11861
{{zer{7,xr{{{p0blk{11862
{{jsr{6,pbild{{{build p_abc node{11863
{{mov{13,pthen(xr){7,xl{{put alternative node as successor{11864
{{mov{8,wa{7,xl{{remember alternative node pointer{11865
{{mov{7,xl{7,xr{{copy p_abc node ptr{11866
{{mov{7,xr{9,(xs){{load arbno argument{11867
{{mov{9,(xs){8,wa{{stack alternative node pointer{11868
{{jsr{6,gtpat{{{get arbno argument as pattern{11869
{{err{1,061{26,arbno argument is not pattern{{{11870
{{jsr{6,pconc{{{concat arg with p_abc node{11871
{{mov{7,xl{7,xr{{remember ptr to concd patterns{11872
{{mov{8,wb{22,=p_aba{{pcode for p_aba{11873
{{zer{7,xr{{{p0blk{11874
{{jsr{6,pbild{{{build p_aba node{11875
{{mov{13,pthen(xr){7,xl{{concatenate nodes{11876
{{mov{7,xl{9,(xs){{recall ptr to alternative node{11877
{{mov{13,parm1(xl){7,xr{{point alternative back to argument{11878
{{lcw{7,xr{{{get next code word{11879
{{bri{9,(xr){{{execute next code word{11880
{{ejc{{{{{11881
*      arg
{s_arg{ent{{{{entry point{11885
{{jsr{6,gtsmi{{{get second arg as small integer{11886
{{err{1,062{26,arg second argument is not integer{{{11887
{{ppm{6,exfal{{{fail if out of range or negative{11888
{{mov{8,wa{7,xr{{save argument number{11889
{{mov{7,xr{10,(xs)+{{load first argument{11890
{{jsr{6,gtnvr{{{locate vrblk{11891
{{ppm{6,sarg1{{{jump if not natural variable{11892
{{mov{7,xr{13,vrfnc(xr){{else load function block pointer{11893
{{bne{9,(xr){22,=b_pfc{6,sarg1{jump if not program defined{11894
{{bze{8,wa{6,exfal{{fail if arg number is zero{11895
{{bgt{8,wa{13,fargs(xr){6,exfal{fail if arg number is too large{11896
{{wtb{8,wa{{{else convert to byte offset{11897
{{add{7,xr{8,wa{{point to argument selected{11898
{{mov{7,xr{13,pfagb(xr){{load argument vrblk pointer{11899
{{brn{6,exvnm{{{exit to build nmblk{11900
*      here if 1st argument is bad
{sarg1{erb{1,063{26,arg first argument is not program function name{{{11904
{{ejc{{{{{11905
*      array
{s_arr{ent{{{{entry point{11909
{{mov{7,xl{10,(xs)+{{load initial element value{11910
{{mov{7,xr{10,(xs)+{{load first argument{11911
{{jsr{6,gtint{{{convert first arg to integer{11912
{{ppm{6,sar02{{{jump if not integer{11913
*      here for integer first argument, build vcblk
{{ldi{13,icval(xr){{{load integer value{11917
{{ile{6,sar10{{{jump if zero or neg (bad dimension){11918
{{mfi{8,wa{6,sar11{{else convert to one word, test ovfl{11919
{{jsr{6,vmake{{{create vector{11920
{{ppm{6,sar11{{{fail if too large{11921
{{brn{6,exsid{{{exit setting idval{11922
{{ejc{{{{{11923
*      array (continued)
*      here if first argument is not an integer
{sar02{mov{11,-(xs){7,xr{{replace argument on stack{11929
{{jsr{6,xscni{{{initialize scan of first argument{11930
{{err{1,064{26,array first argument is not integer or string{{{11931
{{ppm{6,exnul{{{dummy (unused) null string exit{11932
{{mov{11,-(xs){3,r_xsc{{save prototype pointer{11933
{{mov{11,-(xs){7,xl{{save default value{11934
{{zer{3,arcdm{{{zero count of dimensions{11935
{{zer{3,arptr{{{zero offset to indicate pass one{11936
{{ldi{4,intv1{{{load integer one{11937
{{sti{3,arnel{{{initialize element count{11938
*      the following code is executed twice. the first time
*      (arptr eq 0), it is used to count the number of elements
*      and number of dimensions. the second time (arptr gt 0) is
*      used to actually fill in the dim,lbd fields of the arblk.
{sar03{ldi{4,intv1{{{load one as default low bound{11945
{{sti{3,arsvl{{{save as low bound{11946
{{mov{8,wc{18,=ch_cl{{set delimiter one = colon{11947
{{mov{7,xl{18,=ch_cm{{set delimiter two = comma{11948
{{zer{8,wa{{{retain blanks in prototype{11949
{{jsr{6,xscan{{{scan next bound{11950
{{bne{8,wa{18,=num01{6,sar04{jump if not colon{11951
*      here we have a colon ending a low bound
{{jsr{6,gtint{{{convert low bound{11955
{{err{1,065{26,array first argument lower bound is not integer{{{11956
{{ldi{13,icval(xr){{{load value of low bound{11957
{{sti{3,arsvl{{{store low bound value{11958
{{mov{8,wc{18,=ch_cm{{set delimiter one = comma{11959
{{mov{7,xl{8,wc{{and delimiter two = comma{11960
{{zer{8,wa{{{retain blanks in prototype{11961
{{jsr{6,xscan{{{scan high bound{11962
{{ejc{{{{{11963
*      array (continued)
*      merge here to process upper bound
{sar04{jsr{6,gtint{{{convert high bound to integer{11969
{{err{1,066{26,array first argument upper bound is not integer{{{11970
{{ldi{13,icval(xr){{{get high bound{11971
{{sbi{3,arsvl{{{subtract lower bound{11972
{{iov{6,sar10{{{bad dimension if overflow{11973
{{ilt{6,sar10{{{bad dimension if negative{11974
{{adi{4,intv1{{{add 1 to get dimension{11975
{{iov{6,sar10{{{bad dimension if overflow{11976
{{mov{7,xl{3,arptr{{load offset (also pass indicator){11977
{{bze{7,xl{6,sar05{{jump if first pass{11978
*      here in second pass to store lbd and dim in arblk
{{add{7,xl{9,(xs){{point to current location in arblk{11982
{{sti{13,cfp_i(xl){{{store dimension{11983
{{ldi{3,arsvl{{{load low bound{11984
{{sti{9,(xl){{{store low bound{11985
{{add{3,arptr{19,*ardms{{bump offset to next bounds{11986
{{brn{6,sar06{{{jump to check for end of bounds{11987
*      here in pass 1
{sar05{icv{3,arcdm{{{bump dimension count{11991
{{mli{3,arnel{{{multiply dimension by count so far{11992
{{iov{6,sar11{{{too large if overflow{11993
{{sti{3,arnel{{{else store updated element count{11994
*      merge here after processing one set of bounds
{sar06{bnz{8,wa{6,sar03{{loop back unless end of bounds{11998
{{bnz{3,arptr{6,sar09{{jump if end of pass 2{11999
{{ejc{{{{{12000
*      array (continued)
*      here at end of pass one, build arblk
{{ldi{3,arnel{{{get number of elements{12006
{{mfi{8,wb{6,sar11{{get as addr integer, test ovflo{12007
{{wtb{8,wb{{{else convert to length in bytes{12008
{{mov{8,wa{19,*arsi_{{set size of standard fields{12009
{{lct{8,wc{3,arcdm{{set dimension count to control loop{12010
*      loop to allow space for dimensions
{sar07{add{8,wa{19,*ardms{{allow space for one set of bounds{12014
{{bct{8,wc{6,sar07{{loop back till all accounted for{12015
{{mov{7,xl{8,wa{{save size (=arofs){12016
*      now allocate space for arblk
{{add{8,wa{8,wb{{add space for elements{12020
{{ica{8,wa{{{allow for arpro prototype field{12021
{{bgt{8,wa{3,mxlen{6,sar11{fail if too large{12022
{{jsr{6,alloc{{{else allocate arblk{12023
{{mov{8,wb{9,(xs){{load default value{12024
{{mov{9,(xs){7,xr{{save arblk pointer{12025
{{mov{8,wc{8,wa{{save length in bytes{12026
{{btw{8,wa{{{convert length back to words{12027
{{lct{8,wa{8,wa{{set counter to control loop{12028
*      loop to clear entire arblk to default value
{sar08{mov{10,(xr)+{8,wb{{set one word{12032
{{bct{8,wa{6,sar08{{loop till all set{12033
{{ejc{{{{{12034
*      array (continued)
*      now set initial fields of arblk
{{mov{7,xr{10,(xs)+{{reload arblk pointer{12040
{{mov{8,wb{9,(xs){{load prototype{12041
{{mov{9,(xr){22,=b_art{{set type word{12042
{{mov{13,arlen(xr){8,wc{{store length in bytes{12043
{{zer{13,idval(xr){{{zero id till we get it built{12044
{{mov{13,arofs(xr){7,xl{{set prototype field ptr{12045
{{mov{13,arndm(xr){3,arcdm{{set number of dimensions{12046
{{mov{8,wc{7,xr{{save arblk pointer{12047
{{add{7,xr{7,xl{{point to prototype field{12048
{{mov{9,(xr){8,wb{{store prototype ptr in arblk{12049
{{mov{3,arptr{19,*arlbd{{set offset for pass 2 bounds scan{12050
{{mov{3,r_xsc{8,wb{{reset string pointer for xscan{12051
{{mov{9,(xs){8,wc{{store arblk pointer on stack{12052
{{zer{3,xsofs{{{reset offset ptr to start of string{12053
{{brn{6,sar03{{{jump back to rescan bounds{12054
*      here after filling in bounds information (end pass two)
{sar09{mov{7,xr{10,(xs)+{{reload pointer to arblk{12058
{{brn{6,exsid{{{exit setting idval{12059
*      here for bad dimension
{sar10{erb{1,067{26,array dimension is zero, negative or out of range{{{12063
*      here if array is too large
{sar11{erb{1,068{26,array size exceeds maximum permitted{{{12067
{{ejc{{{{{12068
*      atan
{s_atn{ent{{{{entry point{12073
{{mov{7,xr{10,(xs)+{{get argument{12074
{{jsr{6,gtrea{{{convert to real{12075
{{err{1,301{26,atan argument not numeric{{{12076
{{ldr{13,rcval(xr){{{load accumulator with argument{12077
{{atn{{{{take arctangent{12078
{{brn{6,exrea{{{overflow, out of range not possible{12079
{{ejc{{{{{12080
{{ejc{{{{{12083
*      backspace
{s_bsp{ent{{{{entry point{12087
{{jsr{6,iofcb{{{call fcblk routine{12088
{{err{1,316{26,backspace argument is not a suitable name{{{12089
{{err{1,316{26,backspace argument is not a suitable name{{{12090
{{err{1,317{26,backspace file does not exist{{{12091
{{jsr{6,sysbs{{{call backspace file function{12092
{{err{1,317{26,backspace file does not exist{{{12093
{{err{1,318{26,backspace file does not permit backspace{{{12094
{{err{1,319{26,backspace caused non-recoverable error{{{12095
{{brn{6,exnul{{{return null as result{12096
{{ejc{{{{{12097
*      break
{s_brk{ent{{{{entry point{12130
{{mov{8,wb{22,=p_bks{{set pcode for single char case{12131
{{mov{7,xl{22,=p_brk{{pcode for multi-char case{12132
{{mov{8,wc{22,=p_bkd{{pcode for expression case{12133
{{jsr{6,patst{{{call common routine to build node{12134
{{err{1,069{26,break argument is not a string or expression{{{12135
{{mov{11,-(xs){7,xr{{stack result{12136
{{lcw{7,xr{{{get next code word{12137
{{bri{9,(xr){{{execute it{12138
{{ejc{{{{{12139
*      breakx
*      breakx is a compound pattern. see description at start
*      of pattern matching section for structure formed.
{s_bkx{ent{{{{entry point{12146
{{mov{8,wb{22,=p_bks{{pcode for single char argument{12147
{{mov{7,xl{22,=p_brk{{pcode for multi-char argument{12148
{{mov{8,wc{22,=p_bxd{{pcode for expression case{12149
{{jsr{6,patst{{{call common routine to build node{12150
{{err{1,070{26,breakx argument is not a string or expression{{{12151
*      now hook breakx node on at front end
{{mov{11,-(xs){7,xr{{save ptr to break node{12155
{{mov{8,wb{22,=p_bkx{{set pcode for breakx node{12156
{{jsr{6,pbild{{{build it{12157
{{mov{13,pthen(xr){9,(xs){{set break node as successor{12158
{{mov{8,wb{22,=p_alt{{set pcode for alternation node{12159
{{jsr{6,pbild{{{build (parm1=alt=breakx node){12160
{{mov{8,wa{7,xr{{save ptr to alternation node{12161
{{mov{7,xr{9,(xs){{point to break node{12162
{{mov{13,pthen(xr){8,wa{{set alternate node as successor{12163
{{lcw{7,xr{{{result on stack{12164
{{bri{9,(xr){{{execute next code word{12165
{{ejc{{{{{12166
*      char
{s_chr{ent{{{{entry point{12170
{{jsr{6,gtsmi{{{convert arg to integer{12171
{{err{1,281{26,char argument not integer{{{12172
{{ppm{6,schr1{{{too big error exit{12173
{{bge{8,wc{18,=cfp_a{6,schr1{see if out of range of host set{12174
{{mov{8,wa{18,=num01{{if not set scblk allocation{12175
{{mov{8,wb{8,wc{{save char code{12176
{{jsr{6,alocs{{{allocate 1 bau scblk{12177
{{mov{7,xl{7,xr{{copy scblk pointer{12178
{{psc{7,xl{{{get set to stuff char{12179
{{sch{8,wb{9,(xl){{stuff it{12180
{{csc{7,xl{{{complete store character{12181
{{zer{7,xl{{{clear slop in xl{12182
{{mov{11,-(xs){7,xr{{stack result{12183
{{lcw{7,xr{{{get next code word{12184
{{bri{9,(xr){{{execute it{12185
*      here if char argument is out of range
{schr1{erb{1,282{26,char argument not in range{{{12189
{{ejc{{{{{12190
*      chop
{s_chp{ent{{{{entry point{12195
{{mov{7,xr{10,(xs)+{{get argument{12196
{{jsr{6,gtrea{{{convert to real{12197
{{err{1,302{26,chop argument not numeric{{{12198
{{ldr{13,rcval(xr){{{load accumulator with argument{12199
{{chp{{{{truncate to integer valued real{12200
{{brn{6,exrea{{{no overflow possible{12201
{{ejc{{{{{12202
*      clear
{s_clr{ent{{{{entry point{12207
{{jsr{6,xscni{{{initialize to scan argument{12208
{{err{1,071{26,clear argument is not a string{{{12209
{{ppm{6,sclr2{{{jump if null{12210
*      loop to scan out names in first argument. variables in
*      the list are flagged by setting vrget of vrblk to zero.
{sclr1{mov{8,wc{18,=ch_cm{{set delimiter one = comma{12215
{{mov{7,xl{8,wc{{delimiter two = comma{12216
{{mnz{8,wa{{{skip/trim blanks in prototype{12217
{{jsr{6,xscan{{{scan next variable name{12218
{{jsr{6,gtnvr{{{locate vrblk{12219
{{err{1,072{26,clear argument has null variable name{{{12220
{{zer{13,vrget(xr){{{else flag by zeroing vrget field{12221
{{bnz{8,wa{6,sclr1{{loop back if stopped by comma{12222
*      here after flagging variables in argument list
{sclr2{mov{8,wb{3,hshtb{{point to start of hash table{12226
*      loop through slots in hash table
{sclr3{beq{8,wb{3,hshte{6,exnul{exit returning null if none left{12230
{{mov{7,xr{8,wb{{else copy slot pointer{12231
{{ica{8,wb{{{bump slot pointer{12232
{{sub{7,xr{19,*vrnxt{{set offset to merge into loop{12233
*      loop through vrblks on one hash chain
{sclr4{mov{7,xr{13,vrnxt(xr){{point to next vrblk on chain{12237
{{bze{7,xr{6,sclr3{{jump for next bucket if chain end{12238
{{bnz{13,vrget(xr){6,sclr5{{jump if not flagged{12239
{{ejc{{{{{12240
*      clear (continued)
*      here for flagged variable, do not set value to null
{{jsr{6,setvr{{{for flagged var, restore vrget{12246
{{brn{6,sclr4{{{and loop back for next vrblk{12247
*      here to set value of a variable to null
*      protected variables (arb, etc) are exempt
{sclr5{beq{13,vrsto(xr){22,=b_vre{6,sclr4{check for protected variable{12252
{{mov{7,xl{7,xr{{copy vrblk pointer{12253
*      loop to locate value at end of possible trblk chain
{sclr6{mov{8,wa{7,xl{{save block pointer{12257
{{mov{7,xl{13,vrval(xl){{load next value field{12258
{{beq{9,(xl){22,=b_trt{6,sclr6{loop back if trapped{12259
*      now store the null value
{{mov{7,xl{8,wa{{restore block pointer{12263
{{mov{13,vrval(xl){21,=nulls{{store null constant value{12264
{{brn{6,sclr4{{{loop back for next vrblk{12265
{{ejc{{{{{12266
*      code
{s_cod{ent{{{{entry point{12270
{{mov{7,xr{10,(xs)+{{load argument{12271
{{jsr{6,gtcod{{{convert to code{12272
{{ppm{6,exfal{{{fail if conversion is impossible{12273
{{mov{11,-(xs){7,xr{{stack result{12274
{{zer{3,r_ccb{{{forget interim code block{12275
{{lcw{7,xr{{{get next code word{12276
{{bri{9,(xr){{{execute it{12277
{{ejc{{{{{12278
*      collect
{s_col{ent{{{{entry point{12282
{{mov{7,xr{10,(xs)+{{load argument{12283
{{jsr{6,gtint{{{convert to integer{12284
{{err{1,073{26,collect argument is not integer{{{12285
{{ldi{13,icval(xr){{{load collect argument{12286
{{sti{3,clsvi{{{save collect argument{12287
{{zer{8,wb{{{set no move up{12288
{{zer{3,r_ccb{{{forget interim code block{12289
{{zer{3,dnams{{{collect sediment too{12291
{{jsr{6,gbcol{{{perform garbage collection{12292
{{mov{3,dnams{7,xr{{record new sediment size{12293
{{mov{8,wa{3,dname{{point to end of memory{12297
{{sub{8,wa{3,dnamp{{subtract next location{12298
{{btw{8,wa{{{convert bytes to words{12299
{{mti{8,wa{{{convert words available as integer{12300
{{sbi{3,clsvi{{{subtract argument{12301
{{iov{6,exfal{{{fail if overflow{12302
{{ilt{6,exfal{{{fail if not enough{12303
{{adi{3,clsvi{{{else recompute available{12304
{{brn{6,exint{{{and exit with integer result{12305
{{ejc{{{{{12306
*      convert
{s_cnv{ent{{{{entry point{12335
{{jsr{6,gtstg{{{convert second argument to string{12336
{{ppm{6,scv29{{{error if second argument not string{12337
{{bze{8,wa{6,scv29{{or if null string{12338
{{mov{7,xl{9,(xs){{load first argument{12342
{{bne{9,(xl){22,=b_pdt{6,scv01{jump if not program defined{12343
*      here for program defined datatype
{{mov{7,xl{13,pddfp(xl){{point to dfblk{12347
{{mov{7,xl{13,dfnam(xl){{load datatype name{12348
{{jsr{6,ident{{{compare with second arg{12349
{{ppm{6,exits{{{exit if ident with arg as result{12350
{{brn{6,exfal{{{else fail{12351
*      here if not program defined datatype
{scv01{mov{11,-(xs){7,xr{{save string argument{12355
{{mov{7,xl{21,=svctb{{point to table of names to compare{12356
{{zer{8,wb{{{initialize counter{12357
{{mov{8,wc{8,wa{{save length of argument string{12358
*      loop through table entries
{scv02{mov{7,xr{10,(xl)+{{load next table entry, bump pointer{12362
{{bze{7,xr{6,exfal{{fail if zero marking end of list{12363
{{bne{8,wc{13,sclen(xr){6,scv05{jump if wrong length{12364
{{mov{3,cnvtp{7,xl{{else store table pointer{12365
{{plc{7,xr{{{point to chars of table entry{12366
{{mov{7,xl{9,(xs){{load pointer to string argument{12367
{{plc{7,xl{{{point to chars of string arg{12368
{{mov{8,wa{8,wc{{set number of chars to compare{12369
{{cmc{6,scv04{6,scv04{{compare, jump if no match{12370
{{ejc{{{{{12371
*      convert (continued)
*      here we have a match
{scv03{mov{7,xl{8,wb{{copy entry number{12377
{{ica{7,xs{{{pop string arg off stack{12378
{{mov{7,xr{10,(xs)+{{load first argument{12379
{{bsw{7,xl{2,cnvtt{{jump to appropriate routine{12380
{{iff{1,0{6,scv06{{string{12398
{{iff{1,1{6,scv07{{integer{12398
{{iff{1,2{6,scv09{{name{12398
{{iff{1,3{6,scv10{{pattern{12398
{{iff{1,4{6,scv11{{array{12398
{{iff{1,5{6,scv19{{table{12398
{{iff{1,6{6,scv25{{expression{12398
{{iff{1,7{6,scv26{{code{12398
{{iff{1,8{6,scv27{{numeric{12398
{{iff{2,cnvrt{6,scv08{{real{12398
{{esw{{{{end of switch table{12398
*      here if no match with table entry
{scv04{mov{7,xl{3,cnvtp{{restore table pointer, merge{12402
*      merge here if lengths did not match
{scv05{icv{8,wb{{{bump entry number{12406
{{brn{6,scv02{{{loop back to check next entry{12407
*      here to convert to string
{scv06{mov{11,-(xs){7,xr{{replace string argument on stack{12411
{{jsr{6,gtstg{{{convert to string{12412
{{ppm{6,exfal{{{fail if conversion not possible{12413
{{mov{11,-(xs){7,xr{{stack result{12414
{{lcw{7,xr{{{get next code word{12415
{{bri{9,(xr){{{execute it{12416
{{ejc{{{{{12417
*      convert (continued)
*      here to convert to integer
{scv07{jsr{6,gtint{{{convert to integer{12423
{{ppm{6,exfal{{{fail if conversion not possible{12424
{{mov{11,-(xs){7,xr{{stack result{12425
{{lcw{7,xr{{{get next code word{12426
{{bri{9,(xr){{{execute it{12427
*      here to convert to real
{scv08{jsr{6,gtrea{{{convert to real{12433
{{ppm{6,exfal{{{fail if conversion not possible{12434
{{mov{11,-(xs){7,xr{{stack result{12435
{{lcw{7,xr{{{get next code word{12436
{{bri{9,(xr){{{execute it{12437
*      here to convert to name
{scv09{beq{9,(xr){22,=b_nml{6,exixr{return if already a name{12442
{{jsr{6,gtnvr{{{else try string to name convert{12443
{{ppm{6,exfal{{{fail if conversion not possible{12444
{{brn{6,exvnm{{{else exit building nmblk for vrblk{12445
*      here to convert to pattern
{scv10{jsr{6,gtpat{{{convert to pattern{12449
{{ppm{6,exfal{{{fail if conversion not possible{12450
{{mov{11,-(xs){7,xr{{stack result{12451
{{lcw{7,xr{{{get next code word{12452
{{bri{9,(xr){{{execute it{12453
*      convert to array
*      if the first argument is a table, then we go through
*      an intermediate array of addresses that is sorted to
*      provide a result ordered by time of entry in the
*      original table.  see c3.762.
{scv11{mov{11,-(xs){7,xr{{save argument on stack{12462
{{zer{8,wa{{{use table chain block addresses{12463
{{jsr{6,gtarr{{{get an array{12464
{{ppm{6,exfal{{{fail if empty table{12465
{{ppm{6,exfal{{{fail if not convertible{12466
{{mov{7,xl{10,(xs)+{{reload original arg{12467
{{bne{9,(xl){22,=b_tbt{6,exsid{exit if original not a table{12468
{{mov{11,-(xs){7,xr{{sort the intermediate array{12469
{{mov{11,-(xs){21,=nulls{{on first column{12470
{{zer{8,wa{{{sort ascending{12471
{{jsr{6,sorta{{{do sort{12472
{{ppm{6,exfal{{{if sort fails, so shall we{12473
{{mov{8,wb{7,xr{{save array result{12474
{{ldi{13,ardim(xr){{{load dim 1 (number of elements){12475
{{mfi{8,wa{{{get as one word integer{12476
{{lct{8,wa{8,wa{{copy to control loop{12477
{{add{7,xr{19,*arvl2{{point to first element in array{12478
*      here for each row of this 2-column array
{scv12{mov{7,xl{9,(xr){{get teblk address{12482
{{mov{10,(xr)+{13,tesub(xl){{replace with subscript{12483
{{mov{10,(xr)+{13,teval(xl){{replace with value{12484
{{bct{8,wa{6,scv12{{loop till all copied over{12485
{{mov{7,xr{8,wb{{retrieve array address{12486
{{brn{6,exsid{{{exit setting id field{12487
*      convert to table
{scv19{mov{8,wa{9,(xr){{load first word of block{12491
{{mov{11,-(xs){7,xr{{replace arblk pointer on stack{12492
{{beq{8,wa{22,=b_tbt{6,exits{return arg if already a table{12493
{{bne{8,wa{22,=b_art{6,exfal{else fail if not an array{12494
{{ejc{{{{{12495
*      convert (continued)
*      here to convert an array to table
{{bne{13,arndm(xr){18,=num02{6,exfal{fail if not 2-dim array{12501
{{ldi{13,ardm2(xr){{{load dim 2{12502
{{sbi{4,intv2{{{subtract 2 to compare{12503
{{ine{6,exfal{{{fail if dim2 not 2{12504
*      here we have an arblk of the right shape
{{ldi{13,ardim(xr){{{load dim 1 (number of elements){12508
{{mfi{8,wa{{{get as one word integer{12509
{{lct{8,wb{8,wa{{copy to control loop{12510
{{add{8,wa{18,=tbsi_{{add space for standard fields{12511
{{wtb{8,wa{{{convert length to bytes{12512
{{jsr{6,alloc{{{allocate space for tbblk{12513
{{mov{8,wc{7,xr{{copy tbblk pointer{12514
{{mov{11,-(xs){7,xr{{save tbblk pointer{12515
{{mov{10,(xr)+{22,=b_tbt{{store type word{12516
{{zer{10,(xr)+{{{store zero for idval for now{12517
{{mov{10,(xr)+{8,wa{{store length{12518
{{mov{10,(xr)+{21,=nulls{{null initial lookup value{12519
*      loop to initialize bucket ptrs to point to table
{scv20{mov{10,(xr)+{8,wc{{set bucket ptr to point to tbblk{12523
{{bct{8,wb{6,scv20{{loop till all initialized{12524
{{mov{8,wb{19,*arvl2{{set offset to first arblk element{12525
*      loop to copy elements from array to table
{scv21{mov{7,xl{13,num01(xs){{point to arblk{12529
{{beq{8,wb{13,arlen(xl){6,scv24{jump if all moved{12530
{{add{7,xl{8,wb{{else point to current location{12531
{{add{8,wb{19,*num02{{bump offset{12532
{{mov{7,xr{9,(xl){{load subscript name{12533
{{dca{7,xl{{{adjust ptr to merge (trval=1+1){12534
{{ejc{{{{{12535
*      convert (continued)
*      loop to chase down trblk chain for value
{scv22{mov{7,xl{13,trval(xl){{point to next value{12541
{{beq{9,(xl){22,=b_trt{6,scv22{loop back if trapped{12542
*      here with name in xr, value in xl
{scv23{mov{11,-(xs){7,xl{{stack value{12546
{{mov{7,xl{13,num01(xs){{load tbblk pointer{12547
{{jsr{6,tfind{{{build teblk (note wb gt 0 by name){12548
{{ppm{6,exfal{{{fail if acess fails{12549
{{mov{13,teval(xl){10,(xs)+{{store value in teblk{12550
{{brn{6,scv21{{{loop back for next element{12551
*      here after moving all elements to tbblk
{scv24{mov{7,xr{10,(xs)+{{load tbblk pointer{12555
{{ica{7,xs{{{pop arblk pointer{12556
{{brn{6,exsid{{{exit setting idval{12557
*      convert to expression
{scv25{zer{8,wb{{{by value{12562
{{jsr{6,gtexp{{{convert to expression{12563
{{ppm{6,exfal{{{fail if conversion not possible{12567
{{zer{3,r_ccb{{{forget interim code block{12568
{{mov{11,-(xs){7,xr{{stack result{12569
{{lcw{7,xr{{{get next code word{12570
{{bri{9,(xr){{{execute it{12571
*      convert to code
{scv26{jsr{6,gtcod{{{convert to code{12575
{{ppm{6,exfal{{{fail if conversion is not possible{12576
{{zer{3,r_ccb{{{forget interim code block{12577
{{mov{11,-(xs){7,xr{{stack result{12578
{{lcw{7,xr{{{get next code word{12579
{{bri{9,(xr){{{execute it{12580
*      convert to numeric
{scv27{jsr{6,gtnum{{{convert to numeric{12584
{{ppm{6,exfal{{{fail if unconvertible{12585
{scv31{mov{11,-(xs){7,xr{{stack result{12586
{{lcw{7,xr{{{get next code word{12587
{{bri{9,(xr){{{execute it{12588
{{ejc{{{{{12589
*      second argument not string or null
{scv29{erb{1,074{26,convert second argument is not a string{{{12615
*      copy
{s_cop{ent{{{{entry point{12619
{{jsr{6,copyb{{{copy the block{12620
{{ppm{6,exits{{{return if no idval field{12621
{{brn{6,exsid{{{exit setting id value{12622
{{ejc{{{{{12623
*      cos
{s_cos{ent{{{{entry point{12628
{{mov{7,xr{10,(xs)+{{get argument{12629
{{jsr{6,gtrea{{{convert to real{12630
{{err{1,303{26,cos argument not numeric{{{12631
{{ldr{13,rcval(xr){{{load accumulator with argument{12632
{{cos{{{{take cosine{12633
{{rno{6,exrea{{{if no overflow, return result in ra{12634
{{erb{1,322{26,cos argument is out of range{{{12635
{{ejc{{{{{12636
*      data
{s_dat{ent{{{{entry point{12641
{{jsr{6,xscni{{{prepare to scan argument{12642
{{err{1,075{26,data argument is not a string{{{12643
{{err{1,076{26,data argument is null{{{12644
*      scan out datatype name
{{mov{8,wc{18,=ch_pp{{delimiter one = left paren{12648
{{mov{7,xl{8,wc{{delimiter two = left paren{12649
{{mnz{8,wa{{{skip/trim blanks in prototype{12650
{{jsr{6,xscan{{{scan datatype name{12651
{{bnz{8,wa{6,sdat1{{skip if left paren found{12652
{{erb{1,077{26,data argument is missing a left paren{{{12653
*      here after scanning datatype name
{sdat1{mov{7,xl{7,xr{{save name ptr{12663
{{mov{8,wa{13,sclen(xr){{get length{12665
{{ctb{8,wa{2,scsi_{{compute space needed{12666
{{jsr{6,alost{{{request static store for name{12667
{{mov{11,-(xs){7,xr{{save datatype name{12668
{{mvw{{{{copy name to static{12669
{{mov{7,xr{9,(xs){{get name ptr{12670
{{zer{7,xl{{{scrub dud register{12671
{{jsr{6,gtnvr{{{locate vrblk for datatype name{12672
{{err{1,078{26,data argument has null datatype name{{{12673
{{mov{3,datdv{7,xr{{save vrblk pointer for datatype{12674
{{mov{3,datxs{7,xs{{store starting stack value{12675
{{zer{8,wb{{{zero count of field names{12676
*      loop to scan field names and stack vrblk pointers
{sdat2{mov{8,wc{18,=ch_rp{{delimiter one = right paren{12680
{{mov{7,xl{18,=ch_cm{{delimiter two = comma{12681
{{mnz{8,wa{{{skip/trim blanks in prototype{12682
{{jsr{6,xscan{{{scan next field name{12683
{{bnz{8,wa{6,sdat3{{jump if delimiter found{12684
{{erb{1,079{26,data argument is missing a right paren{{{12685
*      here after scanning out one field name
{sdat3{jsr{6,gtnvr{{{locate vrblk for field name{12689
{{err{1,080{26,data argument has null field name{{{12690
{{mov{11,-(xs){7,xr{{stack vrblk pointer{12691
{{icv{8,wb{{{increment counter{12692
{{beq{8,wa{18,=num02{6,sdat2{loop back if stopped by comma{12693
{{ejc{{{{{12694
*      data (continued)
*      now build the dfblk
{{mov{8,wa{18,=dfsi_{{set size of dfblk standard fields{12700
{{add{8,wa{8,wb{{add number of fields{12701
{{wtb{8,wa{{{convert length to bytes{12702
{{mov{8,wc{8,wb{{preserve no. of fields{12703
{{jsr{6,alost{{{allocate space for dfblk{12704
{{mov{8,wb{8,wc{{get no of fields{12705
{{mov{7,xt{3,datxs{{point to start of stack{12706
{{mov{8,wc{9,(xt){{load datatype name{12707
{{mov{9,(xt){7,xr{{save dfblk pointer on stack{12708
{{mov{10,(xr)+{22,=b_dfc{{store type word{12709
{{mov{10,(xr)+{8,wb{{store number of fields (fargs){12710
{{mov{10,(xr)+{8,wa{{store length (dflen){12711
{{sub{8,wa{19,*pddfs{{compute pdblk length (for dfpdl){12712
{{mov{10,(xr)+{8,wa{{store pdblk length (dfpdl){12713
{{mov{10,(xr)+{8,wc{{store datatype name (dfnam){12714
{{lct{8,wc{8,wb{{copy number of fields{12715
*      loop to move field name vrblk pointers to dfblk
{sdat4{mov{10,(xr)+{11,-(xt){{move one field name vrblk pointer{12719
{{bct{8,wc{6,sdat4{{loop till all moved{12720
*      now define the datatype function
{{mov{8,wc{8,wa{{copy length of pdblk for later loop{12724
{{mov{7,xr{3,datdv{{point to vrblk{12725
{{mov{7,xt{3,datxs{{point back on stack{12726
{{mov{7,xl{9,(xt){{load dfblk pointer{12727
{{jsr{6,dffnc{{{define function{12728
{{ejc{{{{{12729
*      data (continued)
*      loop to build ffblks
*      notice that the ffblks are constructed in reverse order
*      so that the required offsets can be obtained from
*      successive decrementation of the pdblk length (in wc).
{sdat5{mov{8,wa{19,*ffsi_{{set length of ffblk{12740
{{jsr{6,alloc{{{allocate space for ffblk{12741
{{mov{9,(xr){22,=b_ffc{{set type word{12742
{{mov{13,fargs(xr){18,=num01{{store fargs (always one){12743
{{mov{7,xt{3,datxs{{point back on stack{12744
{{mov{13,ffdfp(xr){9,(xt){{copy dfblk ptr to ffblk{12745
{{dca{8,wc{{{decrement old dfpdl to get next ofs{12746
{{mov{13,ffofs(xr){8,wc{{set offset to this field{12747
{{zer{13,ffnxt(xr){{{tentatively set zero forward ptr{12748
{{mov{7,xl{7,xr{{copy ffblk pointer for dffnc{12749
{{mov{7,xr{9,(xs){{load vrblk pointer for field{12750
{{mov{7,xr{13,vrfnc(xr){{load current function pointer{12751
{{bne{9,(xr){22,=b_ffc{6,sdat6{skip if not currently a field func{12752
*      here we must chain an old ffblk ptr to preserve it in the
*      case of multiple field functions with the same name
{{mov{13,ffnxt(xl){7,xr{{link new ffblk to previous chain{12757
*      merge here to define field function
{sdat6{mov{7,xr{10,(xs)+{{load vrblk pointer{12761
{{jsr{6,dffnc{{{define field function{12762
{{bne{7,xs{3,datxs{6,sdat5{loop back till all done{12763
{{ica{7,xs{{{pop dfblk pointer{12764
{{brn{6,exnul{{{return with null result{12765
{{ejc{{{{{12766
*      datatype
{s_dtp{ent{{{{entry point{12770
{{mov{7,xr{10,(xs)+{{load argument{12771
{{jsr{6,dtype{{{get datatype{12772
{{mov{11,-(xs){7,xr{{stack result{12773
{{lcw{7,xr{{{get next code word{12774
{{bri{9,(xr){{{execute it{12775
{{ejc{{{{{12776
*      date
{s_dte{ent{{{{entry point{12780
{{mov{7,xr{10,(xs)+{{load argument{12781
{{jsr{6,gtint{{{convert to an integer{12782
{{err{1,330{26,date argument is not integer{{{12783
{{jsr{6,sysdt{{{call system date routine{12784
{{mov{8,wa{13,num01(xl){{load length for sbstr{12785
{{bze{8,wa{6,exnul{{return null if length is zero{12786
{{zer{8,wb{{{set zero offset{12787
{{jsr{6,sbstr{{{use sbstr to build scblk{12788
{{mov{11,-(xs){7,xr{{stack result{12789
{{lcw{7,xr{{{get next code word{12790
{{bri{9,(xr){{{execute it{12791
{{ejc{{{{{12792
*      define
{s_def{ent{{{{entry point{12796
{{mov{7,xr{10,(xs)+{{load second argument{12797
{{zer{3,deflb{{{zero label pointer in case null{12798
{{beq{7,xr{21,=nulls{6,sdf01{jump if null second argument{12799
{{jsr{6,gtnvr{{{else find vrblk for label{12800
{{ppm{6,sdf12{{{jump if not a variable name{12801
{{mov{3,deflb{7,xr{{else set specified entry{12802
*      scan function name
{sdf01{jsr{6,xscni{{{prepare to scan first argument{12806
{{err{1,081{26,define first argument is not a string{{{12807
{{err{1,082{26,define first argument is null{{{12808
{{mov{8,wc{18,=ch_pp{{delimiter one = left paren{12809
{{mov{7,xl{8,wc{{delimiter two = left paren{12810
{{mnz{8,wa{{{skip/trim blanks in prototype{12811
{{jsr{6,xscan{{{scan out function name{12812
{{bnz{8,wa{6,sdf02{{jump if left paren found{12813
{{erb{1,083{26,define first argument is missing a left paren{{{12814
*      here after scanning out function name
{sdf02{jsr{6,gtnvr{{{get variable name{12818
{{err{1,084{26,define first argument has null function name{{{12819
{{mov{3,defvr{7,xr{{save vrblk pointer for function nam{12820
{{zer{8,wb{{{zero count of arguments{12821
{{mov{3,defxs{7,xs{{save initial stack pointer{12822
{{bnz{3,deflb{6,sdf03{{jump if second argument given{12823
{{mov{3,deflb{7,xr{{else default is function name{12824
*      loop to scan argument names and stack vrblk pointers
{sdf03{mov{8,wc{18,=ch_rp{{delimiter one = right paren{12828
{{mov{7,xl{18,=ch_cm{{delimiter two = comma{12829
{{mnz{8,wa{{{skip/trim blanks in prototype{12830
{{jsr{6,xscan{{{scan out next argument name{12831
{{bnz{8,wa{6,sdf04{{skip if delimiter found{12832
{{erb{1,085{26,null arg name or missing ) in define first arg.{{{12833
{{ejc{{{{{12834
*      define (continued)
*      here after scanning an argument name
{sdf04{bne{7,xr{21,=nulls{6,sdf05{skip if non-null{12840
{{bze{8,wb{6,sdf06{{ignore null if case of no arguments{12841
*      here after dealing with the case of no arguments
{sdf05{jsr{6,gtnvr{{{get vrblk pointer{12845
{{ppm{6,sdf03{{{loop back to ignore null name{12846
{{mov{11,-(xs){7,xr{{stack argument vrblk pointer{12847
{{icv{8,wb{{{increment counter{12848
{{beq{8,wa{18,=num02{6,sdf03{loop back if stopped by a comma{12849
*      here after scanning out function argument names
{sdf06{mov{3,defna{8,wb{{save number of arguments{12853
{{zer{8,wb{{{zero count of locals{12854
*      loop to scan local names and stack vrblk pointers
{sdf07{mov{8,wc{18,=ch_cm{{set delimiter one = comma{12858
{{mov{7,xl{8,wc{{set delimiter two = comma{12859
{{mnz{8,wa{{{skip/trim blanks in prototype{12860
{{jsr{6,xscan{{{scan out next local name{12861
{{bne{7,xr{21,=nulls{6,sdf08{skip if non-null{12862
{{bze{8,wa{6,sdf09{{exit scan if end of string{12863
*      here after scanning out a local name
{sdf08{jsr{6,gtnvr{{{get vrblk pointer{12867
{{ppm{6,sdf07{{{loop back to ignore null name{12868
{{icv{8,wb{{{if ok, increment count{12869
{{mov{11,-(xs){7,xr{{stack vrblk pointer{12870
{{bnz{8,wa{6,sdf07{{loop back if stopped by a comma{12871
{{ejc{{{{{12872
*      define (continued)
*      here after scanning locals, build pfblk
{sdf09{mov{8,wa{8,wb{{copy count of locals{12878
{{add{8,wa{3,defna{{add number of arguments{12879
{{mov{8,wc{8,wa{{set sum args+locals as loop count{12880
{{add{8,wa{18,=pfsi_{{add space for standard fields{12881
{{wtb{8,wa{{{convert length to bytes{12882
{{jsr{6,alloc{{{allocate space for pfblk{12883
{{mov{7,xl{7,xr{{save pointer to pfblk{12884
{{mov{10,(xr)+{22,=b_pfc{{store first word{12885
{{mov{10,(xr)+{3,defna{{store number of arguments{12886
{{mov{10,(xr)+{8,wa{{store length (pflen){12887
{{mov{10,(xr)+{3,defvr{{store vrblk ptr for function name{12888
{{mov{10,(xr)+{8,wb{{store number of locals{12889
{{zer{10,(xr)+{{{deal with label later{12890
{{zer{10,(xr)+{{{zero pfctr{12891
{{zer{10,(xr)+{{{zero pfrtr{12892
{{bze{8,wc{6,sdf11{{skip if no args or locals{12893
{{mov{8,wa{7,xl{{keep pfblk pointer{12894
{{mov{7,xt{3,defxs{{point before arguments{12895
{{lct{8,wc{8,wc{{get count of args+locals for loop{12896
*      loop to move locals and args to pfblk
{sdf10{mov{10,(xr)+{11,-(xt){{store one entry and bump pointers{12900
{{bct{8,wc{6,sdf10{{loop till all stored{12901
{{mov{7,xl{8,wa{{recover pfblk pointer{12902
{{ejc{{{{{12903
*      define (continued)
*      now deal with label
{sdf11{mov{7,xs{3,defxs{{pop stack{12909
{{mov{13,pfcod(xl){3,deflb{{store label vrblk in pfblk{12910
{{mov{7,xr{3,defvr{{point back to vrblk for function{12911
{{jsr{6,dffnc{{{define function{12912
{{brn{6,exnul{{{and exit returning null{12913
*      here for erroneous label
{sdf12{erb{1,086{26,define function entry point is not defined label{{{12917
{{ejc{{{{{12918
*      detach
{s_det{ent{{{{entry point{12922
{{mov{7,xr{10,(xs)+{{load argument{12923
{{jsr{6,gtvar{{{locate variable{12924
{{err{1,087{26,detach argument is not appropriate name{{{12925
{{jsr{6,dtach{{{detach i/o association from name{12926
{{brn{6,exnul{{{return null result{12927
{{ejc{{{{{12928
*      differ
{s_dif{ent{{{{entry point{12932
{{mov{7,xr{10,(xs)+{{load second argument{12933
{{mov{7,xl{10,(xs)+{{load first argument{12934
{{jsr{6,ident{{{call ident comparison routine{12935
{{ppm{6,exfal{{{fail if ident{12936
{{brn{6,exnul{{{return null if differ{12937
{{ejc{{{{{12938
*      dump
{s_dmp{ent{{{{entry point{12942
{{jsr{6,gtsmi{{{load dump arg as small integer{12943
{{err{1,088{26,dump argument is not integer{{{12944
{{err{1,089{26,dump argument is negative or too large{{{12945
{{jsr{6,dumpr{{{else call dump routine{12946
{{brn{6,exnul{{{and return null as result{12947
{{ejc{{{{{12948
*      dupl
{s_dup{ent{{{{entry point{12952
{{jsr{6,gtsmi{{{get second argument as small integr{12953
{{err{1,090{26,dupl second argument is not integer{{{12954
{{ppm{6,sdup7{{{jump if negative or too big{12955
{{mov{8,wb{7,xr{{save duplication factor{12956
{{jsr{6,gtstg{{{get first arg as string{12957
{{ppm{6,sdup4{{{jump if not a string{12958
*      here for case of duplication of a string
{{mti{8,wa{{{acquire length as integer{12962
{{sti{3,dupsi{{{save for the moment{12963
{{mti{8,wb{{{get duplication factor as integer{12964
{{mli{3,dupsi{{{form product{12965
{{iov{6,sdup3{{{jump if overflow{12966
{{ieq{6,exnul{{{return null if result length = 0{12967
{{mfi{8,wa{6,sdup3{{get as addr integer, check ovflo{12968
*      merge here with result length in wa
{sdup1{mov{7,xl{7,xr{{save string pointer{12972
{{jsr{6,alocs{{{allocate space for string{12973
{{mov{11,-(xs){7,xr{{save as result pointer{12974
{{mov{8,wc{7,xl{{save pointer to argument string{12975
{{psc{7,xr{{{prepare to store chars of result{12976
{{lct{8,wb{8,wb{{set counter to control loop{12977
*      loop through duplications
{sdup2{mov{7,xl{8,wc{{point back to argument string{12981
{{mov{8,wa{13,sclen(xl){{get number of characters{12982
{{plc{7,xl{{{point to chars in argument string{12983
{{mvc{{{{move characters to result string{12984
{{bct{8,wb{6,sdup2{{loop till all duplications done{12985
{{zer{7,xl{{{clear garbage value{12986
{{lcw{7,xr{{{get next code word{12987
{{bri{9,(xr){{{execute next code word{12988
{{ejc{{{{{12989
*      dupl (continued)
*      here if too large, set max length and let alocs catch it
{sdup3{mov{8,wa{3,dname{{set impossible length for alocs{12995
{{brn{6,sdup1{{{merge back{12996
*      here if not a string
{sdup4{jsr{6,gtpat{{{convert argument to pattern{13000
{{err{1,091{26,dupl first argument is not a string or pattern{{{13001
*      here to duplicate a pattern argument
{{mov{11,-(xs){7,xr{{store pattern on stack{13005
{{mov{7,xr{21,=ndnth{{start off with null pattern{13006
{{bze{8,wb{6,sdup6{{null pattern is result if dupfac=0{13007
{{mov{11,-(xs){8,wb{{preserve loop count{13008
*      loop to duplicate by successive concatenation
{sdup5{mov{7,xl{7,xr{{copy current value as right argumnt{13012
{{mov{7,xr{13,num01(xs){{get a new copy of left{13013
{{jsr{6,pconc{{{concatenate{13014
{{dcv{9,(xs){{{count down{13015
{{bnz{9,(xs){6,sdup5{{loop{13016
{{ica{7,xs{{{pop loop count{13017
*      here to exit after constructing pattern
{sdup6{mov{9,(xs){7,xr{{store result on stack{13021
{{lcw{7,xr{{{get next code word{13022
{{bri{9,(xr){{{execute next code word{13023
*      fail if second arg is out of range
{sdup7{ica{7,xs{{{pop first argument{13027
{{brn{6,exfal{{{fail{13028
{{ejc{{{{{13029
*      eject
{s_ejc{ent{{{{entry point{13033
{{jsr{6,iofcb{{{call fcblk routine{13034
{{err{1,092{26,eject argument is not a suitable name{{{13035
{{ppm{6,sejc1{{{null argument{13036
{{err{1,093{26,eject file does not exist{{{13037
{{jsr{6,sysef{{{call eject file function{13038
{{err{1,093{26,eject file does not exist{{{13039
{{err{1,094{26,eject file does not permit page eject{{{13040
{{err{1,095{26,eject caused non-recoverable output error{{{13041
{{brn{6,exnul{{{return null as result{13042
*      here to eject standard output file
{sejc1{jsr{6,sysep{{{call routine to eject printer{13046
{{brn{6,exnul{{{exit with null result{13047
{{ejc{{{{{13048
*      endfile
{s_enf{ent{{{{entry point{13052
{{jsr{6,iofcb{{{call fcblk routine{13053
{{err{1,096{26,endfile argument is not a suitable name{{{13054
{{err{1,097{26,endfile argument is null{{{13055
{{err{1,098{26,endfile file does not exist{{{13056
{{jsr{6,sysen{{{call endfile routine{13057
{{err{1,098{26,endfile file does not exist{{{13058
{{err{1,099{26,endfile file does not permit endfile{{{13059
{{err{1,100{26,endfile caused non-recoverable output error{{{13060
{{mov{8,wb{7,xl{{remember vrblk ptr from iofcb call{13061
{{mov{7,xr{7,xl{{copy pointer{13062
*      loop to find trtrf block
{senf1{mov{7,xl{7,xr{{remember previous entry{13066
{{mov{7,xr{13,trval(xr){{chain along{13067
{{bne{9,(xr){22,=b_trt{6,exnul{skip out if chain end{13068
{{bne{13,trtyp(xr){18,=trtfc{6,senf1{loop if not found{13069
{{mov{13,trval(xl){13,trval(xr){{remove trtrf{13070
{{mov{3,enfch{13,trtrf(xr){{point to head of iochn{13071
{{mov{8,wc{13,trfpt(xr){{point to fcblk{13072
{{mov{7,xr{8,wb{{filearg1 vrblk from iofcb{13073
{{jsr{6,setvr{{{reset it{13074
{{mov{7,xl{20,=r_fcb{{ptr to head of fcblk chain{13075
{{sub{7,xl{19,*num02{{adjust ready to enter loop{13076
*      find fcblk
{senf2{mov{7,xr{7,xl{{copy ptr{13080
{{mov{7,xl{13,num02(xl){{get next link{13081
{{bze{7,xl{6,senf4{{stop if chain end{13082
{{beq{13,num03(xl){8,wc{6,senf3{jump if fcblk found{13083
{{brn{6,senf2{{{loop{13084
*      remove fcblk
{senf3{mov{13,num02(xr){13,num02(xl){{delete fcblk from chain{13088
*      loop which detaches all vbls on iochn chain
{senf4{mov{7,xl{3,enfch{{get chain head{13092
{{bze{7,xl{6,exnul{{finished if chain end{13093
{{mov{3,enfch{13,trtrf(xl){{chain along{13094
{{mov{8,wa{13,ionmo(xl){{name offset{13095
{{mov{7,xl{13,ionmb(xl){{name base{13096
{{jsr{6,dtach{{{detach name{13097
{{brn{6,senf4{{{loop till done{13098
{{ejc{{{{{13099
*      eq
{s_eqf{ent{{{{entry point{13103
{{jsr{6,acomp{{{call arithmetic comparison routine{13104
{{err{1,101{26,eq first argument is not numeric{{{13105
{{err{1,102{26,eq second argument is not numeric{{{13106
{{ppm{6,exfal{{{fail if lt{13107
{{ppm{6,exnul{{{return null if eq{13108
{{ppm{6,exfal{{{fail if gt{13109
{{ejc{{{{{13110
*      eval
{s_evl{ent{{{{entry point{13114
{{mov{7,xr{10,(xs)+{{load argument{13115
{{lcw{8,wc{{{load next code word{13121
{{bne{8,wc{21,=ofne_{6,sevl1{jump if called by value{13122
{{scp{7,xl{{{copy code pointer{13123
{{mov{8,wa{9,(xl){{get next code word{13124
{{bne{8,wa{21,=ornm_{6,sevl2{by name unless expression{13125
{{bnz{13,num01(xs){6,sevl2{{jump if by name{13126
*      here if called by value
{sevl1{zer{8,wb{{{set flag for by value{13130
{{mov{11,-(xs){8,wc{{save code word{13132
{{jsr{6,gtexp{{{convert to expression{13133
{{err{1,103{26,eval argument is not expression{{{13134
{{zer{3,r_ccb{{{forget interim code block{13135
{{zer{8,wb{{{set flag for by value{13136
{{jsr{6,evalx{{{evaluate expression by value{13140
{{ppm{6,exfal{{{fail if evaluation fails{13141
{{mov{7,xl{7,xr{{copy result{13142
{{mov{7,xr{9,(xs){{reload next code word{13143
{{mov{9,(xs){7,xl{{stack result{13144
{{bri{9,(xr){{{jump to execute next code word{13145
*      here if called by name
{sevl2{mov{8,wb{18,=num01{{set flag for by name{13149
{{jsr{6,gtexp{{{convert to expression{13151
{{err{1,103{26,eval argument is not expression{{{13152
{{zer{3,r_ccb{{{forget interim code block{13153
{{mov{8,wb{18,=num01{{set flag for by name{13154
{{jsr{6,evalx{{{evaluate expression by name{13156
{{ppm{6,exfal{{{fail if evaluation fails{13157
{{brn{6,exnam{{{exit with name{13158
{{ejc{{{{{13161
*      exit
{s_ext{ent{{{{entry point{13165
{{zer{8,wb{{{clear amount of static shift{13166
{{zer{3,r_ccb{{{forget interim code block{13167
{{zer{3,dnams{{{collect sediment too{13169
{{jsr{6,gbcol{{{compact memory by collecting{13170
{{mov{3,dnams{7,xr{{record new sediment size{13171
{{jsr{6,gtstg{{{{13175
{{err{1,288{26,exit second argument is not a string{{{13176
{{mov{7,xl{7,xr{{copy second arg string pointer{13177
{{jsr{6,gtstg{{{convert arg to string{13178
{{err{1,104{26,exit first argument is not suitable integer or string{{{13179
{{mov{11,-(xs){7,xl{{save second argument{13180
{{mov{7,xl{7,xr{{copy first arg string ptr{13181
{{jsr{6,gtint{{{check it is integer{13182
{{ppm{6,sext1{{{skip if unconvertible{13183
{{zer{7,xl{{{note it is integer{13184
{{ldi{13,icval(xr){{{get integer arg{13185
*      merge to call osint exit routine
{sext1{mov{8,wb{3,r_fcb{{get fcblk chain header{13189
{{mov{7,xr{21,=headv{{point to v.v string{13190
{{mov{8,wa{10,(xs)+{{provide second argument scblk{13191
{{jsr{6,sysxi{{{call external routine{13192
{{err{1,105{26,exit action not available in this implementation{{{13193
{{err{1,106{26,exit action caused irrecoverable error{{{13194
{{ieq{6,exnul{{{return if argument 0{13195
{{igt{6,sext2{{{skip if positive{13196
{{ngi{{{{make positive{13197
*      check for option respecification
*      sysxi returns 0 in wa when a file has been resumed,
*      1 when this is a continuation of an exit(4) or exit(-4)
*      action.
{sext2{mfi{8,wc{{{get value in work reg{13205
{{add{8,wa{8,wc{{prepare to test for continue{13206
{{beq{8,wa{18,=num05{6,sext5{continued execution if 4 plus 1{13207
{{zer{3,gbcnt{{{resuming execution so reset{13208
{{bge{8,wc{18,=num03{6,sext3{skip if was 3 or 4{13209
{{mov{11,-(xs){8,wc{{save value{13210
{{zer{8,wc{{{set to read options{13211
{{jsr{6,prpar{{{read syspp options{13212
{{mov{8,wc{10,(xs)+{{restore value{13213
*      deal with header option (fiddled by prpar)
{sext3{mnz{3,headp{{{assume no headers{13217
{{bne{8,wc{18,=num01{6,sext4{skip if not 1{13218
{{zer{3,headp{{{request header printing{13219
*      almost ready to resume running
{sext4{jsr{6,systm{{{get execution time start (sgd11){13223
{{sti{3,timsx{{{save as initial time{13224
{{ldi{3,kvstc{{{reset to ensure ...{13225
{{sti{3,kvstl{{{... correct execution stats{13226
{{jsr{6,stgcc{{{recompute countdown counters{13227
{{brn{6,exnul{{{resume execution{13228
*      here after exit(4) or exit(-4) -- create save file
*      or load module and continue execution.
*      return integer 1 to signal the continuation of the
*      original execution.
{sext5{mov{7,xr{21,=inton{{integer one{13236
{{brn{6,exixr{{{return as result{13237
{{ejc{{{{{13239
*      exp
{s_exp{ent{{{{entry point{13244
{{mov{7,xr{10,(xs)+{{get argument{13245
{{jsr{6,gtrea{{{convert to real{13246
{{err{1,304{26,exp argument not numeric{{{13247
{{ldr{13,rcval(xr){{{load accumulator with argument{13248
{{etx{{{{take exponential{13249
{{rno{6,exrea{{{if no overflow, return result in ra{13250
{{erb{1,305{26,exp produced real overflow{{{13251
{{ejc{{{{{13252
*      field
{s_fld{ent{{{{entry point{13257
{{jsr{6,gtsmi{{{get second argument (field number){13258
{{err{1,107{26,field second argument is not integer{{{13259
{{ppm{6,exfal{{{fail if out of range{13260
{{mov{8,wb{7,xr{{else save integer value{13261
{{mov{7,xr{10,(xs)+{{load first argument{13262
{{jsr{6,gtnvr{{{point to vrblk{13263
{{ppm{6,sfld1{{{jump (error) if not variable name{13264
{{mov{7,xr{13,vrfnc(xr){{else point to function block{13265
{{bne{9,(xr){22,=b_dfc{6,sfld1{error if not datatype function{13266
*      here if first argument is a datatype function name
{{bze{8,wb{6,exfal{{fail if argument number is zero{13270
{{bgt{8,wb{13,fargs(xr){6,exfal{fail if too large{13271
{{wtb{8,wb{{{else convert to byte offset{13272
{{add{7,xr{8,wb{{point to field name{13273
{{mov{7,xr{13,dfflb(xr){{load vrblk pointer{13274
{{brn{6,exvnm{{{exit to build nmblk{13275
*      here for bad first argument
{sfld1{erb{1,108{26,field first argument is not datatype name{{{13279
{{ejc{{{{{13280
*      fence
{s_fnc{ent{{{{entry point{13284
{{mov{8,wb{22,=p_fnc{{set pcode for p_fnc{13285
{{zer{7,xr{{{p0blk{13286
{{jsr{6,pbild{{{build p_fnc node{13287
{{mov{7,xl{7,xr{{save pointer to it{13288
{{mov{7,xr{10,(xs)+{{get argument{13289
{{jsr{6,gtpat{{{convert to pattern{13290
{{err{1,259{26,fence argument is not pattern{{{13291
{{jsr{6,pconc{{{concatenate to p_fnc node{13292
{{mov{7,xl{7,xr{{save ptr to concatenated pattern{13293
{{mov{8,wb{22,=p_fna{{set for p_fna pcode{13294
{{zer{7,xr{{{p0blk{13295
{{jsr{6,pbild{{{construct p_fna node{13296
{{mov{13,pthen(xr){7,xl{{set pattern as pthen{13297
{{mov{11,-(xs){7,xr{{set as result{13298
{{lcw{7,xr{{{get next code word{13299
{{bri{9,(xr){{{execute next code word{13300
{{ejc{{{{{13301
*      ge
{s_gef{ent{{{{entry point{13305
{{jsr{6,acomp{{{call arithmetic comparison routine{13306
{{err{1,109{26,ge first argument is not numeric{{{13307
{{err{1,110{26,ge second argument is not numeric{{{13308
{{ppm{6,exfal{{{fail if lt{13309
{{ppm{6,exnul{{{return null if eq{13310
{{ppm{6,exnul{{{return null if gt{13311
{{ejc{{{{{13312
*      gt
{s_gtf{ent{{{{entry point{13316
{{jsr{6,acomp{{{call arithmetic comparison routine{13317
{{err{1,111{26,gt first argument is not numeric{{{13318
{{err{1,112{26,gt second argument is not numeric{{{13319
{{ppm{6,exfal{{{fail if lt{13320
{{ppm{6,exfal{{{fail if eq{13321
{{ppm{6,exnul{{{return null if gt{13322
{{ejc{{{{{13323
*      host
{s_hst{ent{{{{entry point{13327
{{mov{8,wc{10,(xs)+{{get fifth arg{13328
{{mov{8,wb{10,(xs)+{{get fourth arg{13329
{{mov{7,xr{10,(xs)+{{get third arg{13330
{{mov{7,xl{10,(xs)+{{get second arg{13331
{{mov{8,wa{10,(xs)+{{get first arg{13332
{{jsr{6,syshs{{{enter syshs routine{13333
{{err{1,254{26,erroneous argument for host{{{13334
{{err{1,255{26,error during execution of host{{{13335
{{ppm{6,shst1{{{store host string{13336
{{ppm{6,exnul{{{return null result{13337
{{ppm{6,exixr{{{return xr{13338
{{ppm{6,exfal{{{fail return{13339
{{ppm{6,shst3{{{store actual string{13340
{{ppm{6,shst4{{{return copy of xr{13341
*      return host string
{shst1{bze{7,xl{6,exnul{{null string if syshs uncooperative{13345
{{mov{8,wa{13,sclen(xl){{length{13346
{{zer{8,wb{{{zero offset{13347
*      copy string and return
{shst2{jsr{6,sbstr{{{build copy of string{13351
{{mov{11,-(xs){7,xr{{stack the result{13352
{{lcw{7,xr{{{load next code word{13353
{{bri{9,(xr){{{execute it{13354
*      return actual string pointed to by xl
{shst3{zer{8,wb{{{treat xl like an scblk ptr{13358
{{sub{8,wb{18,=cfp_f{{by creating a negative offset{13359
{{brn{6,shst2{{{join to copy string{13360
*      return copy of block pointed to by xr
{shst4{mov{11,-(xs){7,xr{{stack results{13364
{{jsr{6,copyb{{{make copy of block{13365
{{ppm{6,exits{{{if not an aggregate structure{13366
{{brn{6,exsid{{{set current id value otherwise{13367
{{ejc{{{{{13368
*      ident
{s_idn{ent{{{{entry point{13372
{{mov{7,xr{10,(xs)+{{load second argument{13373
{{mov{7,xl{10,(xs)+{{load first argument{13374
{{jsr{6,ident{{{call ident comparison routine{13375
{{ppm{6,exnul{{{return null if ident{13376
{{brn{6,exfal{{{fail if differ{13377
{{ejc{{{{{13378
*      input
{s_inp{ent{{{{entry point{13382
{{zer{8,wb{{{input flag{13383
{{jsr{6,ioput{{{call input/output assoc. routine{13384
{{err{1,113{26,input third argument is not a string{{{13385
{{err{1,114{26,inappropriate second argument for input{{{13386
{{err{1,115{26,inappropriate first argument for input{{{13387
{{err{1,116{26,inappropriate file specification for input{{{13388
{{ppm{6,exfal{{{fail if file does not exist{13389
{{err{1,117{26,input file cannot be read{{{13390
{{err{1,289{26,input channel currently in use{{{13391
{{brn{6,exnul{{{return null string{13392
{{ejc{{{{{13393
*      integer
{s_int{ent{{{{entry point{13426
{{mov{7,xr{10,(xs)+{{load argument{13427
{{jsr{6,gtnum{{{convert to numeric{13428
{{ppm{6,exfal{{{fail if non-numeric{13429
{{beq{8,wa{22,=b_icl{6,exnul{return null if integer{13430
{{brn{6,exfal{{{fail if real{13431
{{ejc{{{{{13432
*      item
*      item does not permit the direct (fast) call so that
*      wa contains the actual number of arguments passed.
{s_itm{ent{{{{entry point{13439
*      deal with case of no args
{{bnz{8,wa{6,sitm1{{jump if at least one arg{13443
{{mov{11,-(xs){21,=nulls{{else supply garbage null arg{13444
{{mov{8,wa{18,=num01{{and fix argument count{13445
*      check for name/value cases
{sitm1{scp{7,xr{{{get current code pointer{13449
{{mov{7,xl{9,(xr){{load next code word{13450
{{dcv{8,wa{{{get number of subscripts{13451
{{mov{7,xr{8,wa{{copy for arref{13452
{{beq{7,xl{21,=ofne_{6,sitm2{jump if called by name{13453
*      here if called by value
{{zer{8,wb{{{set code for call by value{13457
{{brn{6,arref{{{off to array reference routine{13458
*      here for call by name
{sitm2{mnz{8,wb{{{set code for call by name{13462
{{lcw{8,wa{{{load and ignore ofne_ call{13463
{{brn{6,arref{{{off to array reference routine{13464
{{ejc{{{{{13465
*      le
{s_lef{ent{{{{entry point{13469
{{jsr{6,acomp{{{call arithmetic comparison routine{13470
{{err{1,118{26,le first argument is not numeric{{{13471
{{err{1,119{26,le second argument is not numeric{{{13472
{{ppm{6,exnul{{{return null if lt{13473
{{ppm{6,exnul{{{return null if eq{13474
{{ppm{6,exfal{{{fail if gt{13475
{{ejc{{{{{13476
*      len
{s_len{ent{{{{entry point{13480
{{mov{8,wb{22,=p_len{{set pcode for integer arg case{13481
{{mov{8,wa{22,=p_lnd{{set pcode for expr arg case{13482
{{jsr{6,patin{{{call common routine to build node{13483
{{err{1,120{26,len argument is not integer or expression{{{13484
{{err{1,121{26,len argument is negative or too large{{{13485
{{mov{11,-(xs){7,xr{{stack result{13486
{{lcw{7,xr{{{get next code word{13487
{{bri{9,(xr){{{execute it{13488
{{ejc{{{{{13489
*      leq
{s_leq{ent{{{{entry point{13493
{{jsr{6,lcomp{{{call string comparison routine{13494
{{err{1,122{26,leq first argument is not a string{{{13495
{{err{1,123{26,leq second argument is not a string{{{13496
{{ppm{6,exfal{{{fail if llt{13497
{{ppm{6,exnul{{{return null if leq{13498
{{ppm{6,exfal{{{fail if lgt{13499
{{ejc{{{{{13500
*      lge
{s_lge{ent{{{{entry point{13504
{{jsr{6,lcomp{{{call string comparison routine{13505
{{err{1,124{26,lge first argument is not a string{{{13506
{{err{1,125{26,lge second argument is not a string{{{13507
{{ppm{6,exfal{{{fail if llt{13508
{{ppm{6,exnul{{{return null if leq{13509
{{ppm{6,exnul{{{return null if lgt{13510
{{ejc{{{{{13511
*      lgt
{s_lgt{ent{{{{entry point{13515
{{jsr{6,lcomp{{{call string comparison routine{13516
{{err{1,126{26,lgt first argument is not a string{{{13517
{{err{1,127{26,lgt second argument is not a string{{{13518
{{ppm{6,exfal{{{fail if llt{13519
{{ppm{6,exfal{{{fail if leq{13520
{{ppm{6,exnul{{{return null if lgt{13521
{{ejc{{{{{13522
*      lle
{s_lle{ent{{{{entry point{13526
{{jsr{6,lcomp{{{call string comparison routine{13527
{{err{1,128{26,lle first argument is not a string{{{13528
{{err{1,129{26,lle second argument is not a string{{{13529
{{ppm{6,exnul{{{return null if llt{13530
{{ppm{6,exnul{{{return null if leq{13531
{{ppm{6,exfal{{{fail if lgt{13532
{{ejc{{{{{13533
*      llt
{s_llt{ent{{{{entry point{13537
{{jsr{6,lcomp{{{call string comparison routine{13538
{{err{1,130{26,llt first argument is not a string{{{13539
{{err{1,131{26,llt second argument is not a string{{{13540
{{ppm{6,exnul{{{return null if llt{13541
{{ppm{6,exfal{{{fail if leq{13542
{{ppm{6,exfal{{{fail if lgt{13543
{{ejc{{{{{13544
*      lne
{s_lne{ent{{{{entry point{13548
{{jsr{6,lcomp{{{call string comparison routine{13549
{{err{1,132{26,lne first argument is not a string{{{13550
{{err{1,133{26,lne second argument is not a string{{{13551
{{ppm{6,exnul{{{return null if llt{13552
{{ppm{6,exfal{{{fail if leq{13553
{{ppm{6,exnul{{{return null if lgt{13554
{{ejc{{{{{13555
*      ln
{s_lnf{ent{{{{entry point{13560
{{mov{7,xr{10,(xs)+{{get argument{13561
{{jsr{6,gtrea{{{convert to real{13562
{{err{1,306{26,ln argument not numeric{{{13563
{{ldr{13,rcval(xr){{{load accumulator with argument{13564
{{req{6,slnf1{{{overflow if argument is 0{13565
{{rlt{6,slnf2{{{error if argument less than 0{13566
{{lnf{{{{take natural logarithm{13567
{{rno{6,exrea{{{if no overflow, return result in ra{13568
{slnf1{erb{1,307{26,ln produced real overflow{{{13569
*      here for bad argument
{slnf2{erb{1,315{26,ln argument negative{{{13573
{{ejc{{{{{13574
*      local
{s_loc{ent{{{{entry point{13579
{{jsr{6,gtsmi{{{get second argument (local number){13580
{{err{1,134{26,local second argument is not integer{{{13581
{{ppm{6,exfal{{{fail if out of range{13582
{{mov{8,wb{7,xr{{save local number{13583
{{mov{7,xr{10,(xs)+{{load first argument{13584
{{jsr{6,gtnvr{{{point to vrblk{13585
{{ppm{6,sloc1{{{jump if not variable name{13586
{{mov{7,xr{13,vrfnc(xr){{else load function pointer{13587
{{bne{9,(xr){22,=b_pfc{6,sloc1{jump if not program defined{13588
*      here if we have a program defined function name
{{bze{8,wb{6,exfal{{fail if second arg is zero{13592
{{bgt{8,wb{13,pfnlo(xr){6,exfal{or too large{13593
{{add{8,wb{13,fargs(xr){{else adjust offset to include args{13594
{{wtb{8,wb{{{convert to bytes{13595
{{add{7,xr{8,wb{{point to local pointer{13596
{{mov{7,xr{13,pfagb(xr){{load vrblk pointer{13597
{{brn{6,exvnm{{{exit building nmblk{13598
*      here if first argument is no good
{sloc1{erb{1,135{26,local first arg is not a program function name{{{13602
{{ejc{{{{{13605
*      load
{s_lod{ent{{{{entry point{13609
{{jsr{6,gtstg{{{load library name{13610
{{err{1,136{26,load second argument is not a string{{{13611
{{mov{7,xl{7,xr{{save library name{13612
{{jsr{6,xscni{{{prepare to scan first argument{13613
{{err{1,137{26,load first argument is not a string{{{13614
{{err{1,138{26,load first argument is null{{{13615
{{mov{11,-(xs){7,xl{{stack library name{13616
{{mov{8,wc{18,=ch_pp{{set delimiter one = left paren{13617
{{mov{7,xl{8,wc{{set delimiter two = left paren{13618
{{mnz{8,wa{{{skip/trim blanks in prototype{13619
{{jsr{6,xscan{{{scan function name{13620
{{mov{11,-(xs){7,xr{{save ptr to function name{13621
{{bnz{8,wa{6,slod1{{jump if left paren found{13622
{{erb{1,139{26,load first argument is missing a left paren{{{13623
*      here after successfully scanning function name
{slod1{jsr{6,gtnvr{{{locate vrblk{13627
{{err{1,140{26,load first argument has null function name{{{13628
{{mov{3,lodfn{7,xr{{save vrblk pointer{13629
{{zer{3,lodna{{{zero count of arguments{13630
*      loop to scan argument datatype names
{slod2{mov{8,wc{18,=ch_rp{{delimiter one is right paren{13634
{{mov{7,xl{18,=ch_cm{{delimiter two is comma{13635
{{mnz{8,wa{{{skip/trim blanks in prototype{13636
{{jsr{6,xscan{{{scan next argument name{13637
{{icv{3,lodna{{{bump argument count{13638
{{bnz{8,wa{6,slod3{{jump if ok delimiter was found{13639
{{erb{1,141{26,load first argument is missing a right paren{{{13640
{{ejc{{{{{13641
*      load (continued)
*      come here to analyze the datatype pointer in (xr). this
*      code is used both for arguments (wa=1,2) and for the
*      result datatype (with wa set to zero).
{slod3{mov{11,-(xs){7,xr{{stack datatype name pointer{13657
{{mov{8,wb{18,=num01{{set string code in case{13659
{{mov{7,xl{21,=scstr{{point to /string/{13660
{{jsr{6,ident{{{check for match{13661
{{ppm{6,slod4{{{jump if match{13662
{{mov{7,xr{9,(xs){{else reload name{13663
{{add{8,wb{8,wb{{set code for integer (2){13664
{{mov{7,xl{21,=scint{{point to /integer/{13665
{{jsr{6,ident{{{check for match{13666
{{ppm{6,slod4{{{jump if match{13667
{{mov{7,xr{9,(xs){{else reload string pointer{13670
{{icv{8,wb{{{set code for real (3){13671
{{mov{7,xl{21,=screa{{point to /real/{13672
{{jsr{6,ident{{{check for match{13673
{{ppm{6,slod4{{{jump if match{13674
{{mov{7,xr{9,(xs){{reload string pointer{13677
{{icv{8,wb{{{code for file (4, or 3 if no reals){13678
{{mov{7,xl{21,=scfil{{point to /file/{13679
{{jsr{6,ident{{{check for match{13680
{{ppm{6,slod4{{{jump if match{13681
{{zer{8,wb{{{else get code for no convert{13684
*      merge here with proper datatype code in wb
{slod4{mov{9,(xs){8,wb{{store code on stack{13688
{{beq{8,wa{18,=num02{6,slod2{loop back if arg stopped by comma{13689
{{bze{8,wa{6,slod5{{jump if that was the result type{13690
*      here we scan out the result type (arg stopped by ) )
{{mov{8,wc{3,mxlen{{set dummy (impossible) delimiter 1{13694
{{mov{7,xl{8,wc{{and delimiter two{13695
{{mnz{8,wa{{{skip/trim blanks in prototype{13696
{{jsr{6,xscan{{{scan result name{13697
{{zer{8,wa{{{set code for processing result{13698
{{brn{6,slod3{{{jump back to process result name{13699
{{ejc{{{{{13700
*      load (continued)
*      here after processing all args and result
{slod5{mov{8,wa{3,lodna{{get number of arguments{13706
{{mov{8,wc{8,wa{{copy for later{13707
{{wtb{8,wa{{{convert length to bytes{13708
{{add{8,wa{19,*efsi_{{add space for standard fields{13709
{{jsr{6,alloc{{{allocate efblk{13710
{{mov{9,(xr){22,=b_efc{{set type word{13711
{{mov{13,fargs(xr){8,wc{{set number of arguments{13712
{{zer{13,efuse(xr){{{set use count (dffnc will set to 1){13713
{{zer{13,efcod(xr){{{zero code pointer for now{13714
{{mov{13,efrsl(xr){10,(xs)+{{store result type code{13715
{{mov{13,efvar(xr){3,lodfn{{store function vrblk pointer{13716
{{mov{13,eflen(xr){8,wa{{store efblk length{13717
{{mov{8,wb{7,xr{{save efblk pointer{13718
{{add{7,xr{8,wa{{point past end of efblk{13719
{{lct{8,wc{8,wc{{set number of arguments for loop{13720
*      loop to set argument type codes from stack
{slod6{mov{11,-(xr){10,(xs)+{{store one type code from stack{13724
{{bct{8,wc{6,slod6{{loop till all stored{13725
*      now load the external function and perform definition
{{mov{7,xr{10,(xs)+{{load function string name{13729
{{mov{7,xl{9,(xs){{load library name{13734
{{mov{9,(xs){8,wb{{store efblk pointer{13735
{{jsr{6,sysld{{{call function to load external func{13736
{{err{1,142{26,load function does not exist{{{13737
{{err{1,143{26,load function caused input error during load{{{13738
{{err{1,328{26,load function - insufficient memory{{{13739
{{mov{7,xl{10,(xs)+{{recall efblk pointer{13740
{{mov{13,efcod(xl){7,xr{{store code pointer{13741
{{mov{7,xr{3,lodfn{{point to vrblk for function{13742
{{jsr{6,dffnc{{{perform function definition{13743
{{brn{6,exnul{{{return null result{13744
{{ejc{{{{{13746
*      lpad
{s_lpd{ent{{{{entry point{13750
{{jsr{6,gtstg{{{get pad character{13751
{{err{1,144{26,lpad third argument is not a string{{{13752
{{plc{7,xr{{{point to character (null is blank){13753
{{lch{8,wb{9,(xr){{load pad character{13754
{{jsr{6,gtsmi{{{get pad length{13755
{{err{1,145{26,lpad second argument is not integer{{{13756
{{ppm{6,slpd4{{{skip if negative or large{13757
*      merge to check first arg
{slpd1{jsr{6,gtstg{{{get first argument (string to pad){13761
{{err{1,146{26,lpad first argument is not a string{{{13762
{{bge{8,wa{8,wc{6,exixr{return 1st arg if too long to pad{13763
{{mov{7,xl{7,xr{{else move ptr to string to pad{13764
*      now we are ready for the pad
*      (xl)                  pointer to string to pad
*      (wb)                  pad character
*      (wc)                  length to pad string to
{{mov{8,wa{8,wc{{copy length{13772
{{jsr{6,alocs{{{allocate scblk for new string{13773
{{mov{11,-(xs){7,xr{{save as result{13774
{{mov{8,wa{13,sclen(xl){{load length of argument{13775
{{sub{8,wc{8,wa{{calculate number of pad characters{13776
{{psc{7,xr{{{point to chars in result string{13777
{{lct{8,wc{8,wc{{set counter for pad loop{13778
*      loop to perform pad
{slpd2{sch{8,wb{10,(xr)+{{store pad character, bump ptr{13782
{{bct{8,wc{6,slpd2{{loop till all pad chars stored{13783
{{csc{7,xr{{{complete store characters{13784
*      now copy string
{{bze{8,wa{6,slpd3{{exit if null string{13788
{{plc{7,xl{{{else point to chars in argument{13789
{{mvc{{{{move characters to result string{13790
{{zer{7,xl{{{clear garbage xl{13791
*      here to exit with result on stack
{slpd3{lcw{7,xr{{{load next code word{13795
{{bri{9,(xr){{{execute it{13796
*      here if 2nd arg is negative or large
{slpd4{zer{8,wc{{{zero pad count{13800
{{brn{6,slpd1{{{merge{13801
{{ejc{{{{{13802
*      lt
{s_ltf{ent{{{{entry point{13806
{{jsr{6,acomp{{{call arithmetic comparison routine{13807
{{err{1,147{26,lt first argument is not numeric{{{13808
{{err{1,148{26,lt second argument is not numeric{{{13809
{{ppm{6,exnul{{{return null if lt{13810
{{ppm{6,exfal{{{fail if eq{13811
{{ppm{6,exfal{{{fail if gt{13812
{{ejc{{{{{13813
*      ne
{s_nef{ent{{{{entry point{13817
{{jsr{6,acomp{{{call arithmetic comparison routine{13818
{{err{1,149{26,ne first argument is not numeric{{{13819
{{err{1,150{26,ne second argument is not numeric{{{13820
{{ppm{6,exnul{{{return null if lt{13821
{{ppm{6,exfal{{{fail if eq{13822
{{ppm{6,exnul{{{return null if gt{13823
{{ejc{{{{{13824
*      notany
{s_nay{ent{{{{entry point{13828
{{mov{8,wb{22,=p_nas{{set pcode for single char arg{13829
{{mov{7,xl{22,=p_nay{{pcode for multi-char arg{13830
{{mov{8,wc{22,=p_nad{{set pcode for expr arg{13831
{{jsr{6,patst{{{call common routine to build node{13832
{{err{1,151{26,notany argument is not a string or expression{{{13833
{{mov{11,-(xs){7,xr{{stack result{13834
{{lcw{7,xr{{{get next code word{13835
{{bri{9,(xr){{{execute it{13836
{{ejc{{{{{13837
*      opsyn
{s_ops{ent{{{{entry point{13841
{{jsr{6,gtsmi{{{load third argument{13842
{{err{1,152{26,opsyn third argument is not integer{{{13843
{{err{1,153{26,opsyn third argument is negative or too large{{{13844
{{mov{8,wb{8,wc{{if ok, save third argumnet{13845
{{mov{7,xr{10,(xs)+{{load second argument{13846
{{jsr{6,gtnvr{{{locate variable block{13847
{{err{1,154{26,opsyn second arg is not natural variable name{{{13848
{{mov{7,xl{13,vrfnc(xr){{if ok, load function block pointer{13849
{{bnz{8,wb{6,sops2{{jump if operator opsyn case{13850
*      here for function opsyn (third arg zero)
{{mov{7,xr{10,(xs)+{{load first argument{13854
{{jsr{6,gtnvr{{{get vrblk pointer{13855
{{err{1,155{26,opsyn first arg is not natural variable name{{{13856
*      merge here to perform function definition
{sops1{jsr{6,dffnc{{{call function definer{13860
{{brn{6,exnul{{{exit with null result{13861
*      here for operator opsyn (third arg non-zero)
{sops2{jsr{6,gtstg{{{get operator name{13865
{{ppm{6,sops5{{{jump if not string{13866
{{bne{8,wa{18,=num01{6,sops5{error if not one char long{13867
{{plc{7,xr{{{else point to character{13868
{{lch{8,wc{9,(xr){{load character name{13869
{{ejc{{{{{13870
*      opsyn (continued)
*      now set to search for matching unary or binary operator
*      name as appropriate. note that there are =opbun undefined
*      binary operators and =opuun undefined unary operators.
{{mov{8,wa{20,=r_uub{{point to unop pointers in case{13878
{{mov{7,xr{21,=opnsu{{point to names of unary operators{13879
{{add{8,wb{18,=opbun{{add no. of undefined binary ops{13880
{{beq{8,wb{18,=opuun{6,sops3{jump if unop (third arg was 1){13881
{{mov{8,wa{20,=r_uba{{else point to binary operator ptrs{13882
{{mov{7,xr{21,=opsnb{{point to names of binary operators{13883
{{mov{8,wb{18,=opbun{{set number of undefined binops{13884
*      merge here to check list (wb = number to check)
{sops3{lct{8,wb{8,wb{{set counter to control loop{13888
*      loop to search for name match
{sops4{beq{8,wc{9,(xr){6,sops6{jump if names match{13892
{{ica{8,wa{{{else push pointer to function ptr{13893
{{ica{7,xr{{{bump pointer{13894
{{bct{8,wb{6,sops4{{loop back till all checked{13895
*      here if bad operator name
{sops5{erb{1,156{26,opsyn first arg is not correct operator name{{{13899
*      come here on finding a match in the operator name table
{sops6{mov{7,xr{8,wa{{copy pointer to function block ptr{13903
{{sub{7,xr{19,*vrfnc{{make it look like dummy vrblk{13904
{{brn{6,sops1{{{merge back to define operator{13905
{{ejc{{{{{13906
*      output
{s_oup{ent{{{{entry point{13931
{{mov{8,wb{18,=num03{{output flag{13932
{{jsr{6,ioput{{{call input/output assoc. routine{13933
{{err{1,157{26,output third argument is not a string{{{13934
{{err{1,158{26,inappropriate second argument for output{{{13935
{{err{1,159{26,inappropriate first argument for output{{{13936
{{err{1,160{26,inappropriate file specification for output{{{13937
{{ppm{6,exfal{{{fail if file does not exist{13938
{{err{1,161{26,output file cannot be written to{{{13939
{{err{1,290{26,output channel currently in use{{{13940
{{brn{6,exnul{{{return null string{13941
{{ejc{{{{{13942
*      pos
{s_pos{ent{{{{entry point{13946
{{mov{8,wb{22,=p_pos{{set pcode for integer arg case{13947
{{mov{8,wa{22,=p_psd{{set pcode for expression arg case{13948
{{jsr{6,patin{{{call common routine to build node{13949
{{err{1,162{26,pos argument is not integer or expression{{{13950
{{err{1,163{26,pos argument is negative or too large{{{13951
{{mov{11,-(xs){7,xr{{stack result{13952
{{lcw{7,xr{{{get next code word{13953
{{bri{9,(xr){{{execute it{13954
{{ejc{{{{{13955
*      prototype
{s_pro{ent{{{{entry point{13959
{{mov{7,xr{10,(xs)+{{load argument{13960
{{mov{8,wb{13,tblen(xr){{length if table, vector (=vclen){13961
{{btw{8,wb{{{convert to words{13962
{{mov{8,wa{9,(xr){{load type word of argument block{13963
{{beq{8,wa{22,=b_art{6,spro4{jump if array{13964
{{beq{8,wa{22,=b_tbt{6,spro1{jump if table{13965
{{beq{8,wa{22,=b_vct{6,spro3{jump if vector{13966
{{erb{1,164{26,prototype argument is not valid object{{{13971
*      here for table
{spro1{sub{8,wb{18,=tbsi_{{subtract standard fields{13975
*      merge for vector
{spro2{mti{8,wb{{{convert to integer{13979
{{brn{6,exint{{{exit with integer result{13980
*      here for vector
{spro3{sub{8,wb{18,=vcsi_{{subtract standard fields{13984
{{brn{6,spro2{{{merge{13985
*      here for array
{spro4{add{7,xr{13,arofs(xr){{point to prototype field{13989
{{mov{7,xr{9,(xr){{load prototype{13990
{{mov{11,-(xs){7,xr{{stack result{13991
{{lcw{7,xr{{{get next code word{13992
{{bri{9,(xr){{{execute it{13993
{{ejc{{{{{14003
*      remdr
{s_rmd{ent{{{{entry point{14007
{{jsr{6,arith{{{get two integers or two reals{14009
{{err{1,166{26,remdr first argument is not numeric{{{14010
{{err{1,165{26,remdr second argument is not numeric{{{14011
{{ppm{6,srm06{{{if real{14012
*      both arguments integer
{{zer{8,wb{{{set positive flag{14029
{{ldi{13,icval(xr){{{load left argument value{14030
{{ige{6,srm01{{{jump if positive{14031
{{mnz{8,wb{{{set negative flag{14032
{srm01{rmi{13,icval(xl){{{get remainder{14033
{{iov{6,srm05{{{error if overflow{14034
*      make sign of result match sign of first argument
{{bze{8,wb{6,srm03{{if result should be positive{14038
{{ile{6,exint{{{if should be negative, and is{14039
{srm02{ngi{{{{adjust sign of result{14040
{{brn{6,exint{{{return result{14041
{srm03{ilt{6,srm02{{{should be pos, and result negative{14042
{{brn{6,exint{{{should be positive, and is{14043
*      fail first argument
{srm04{erb{1,166{26,remdr first argument is not numeric{{{14047
*      fail if overflow
{srm05{erb{1,167{26,remdr caused integer overflow{{{14051
*      here with 1st argument in (xr), 2nd in (xl), both real
*      result = n1 - chop(n1/n2)*n2
{srm06{zer{8,wb{{{set positive flag{14058
{{ldr{13,rcval(xr){{{load left argument value{14059
{{rge{6,srm07{{{jump if positive{14060
{{mnz{8,wb{{{set negative flag{14061
{srm07{dvr{13,rcval(xl){{{compute n1/n2{14062
{{rov{6,srm10{{{jump if overflow{14063
{{chp{{{{chop result{14064
{{mlr{13,rcval(xl){{{times n2{14065
{{sbr{13,rcval(xr){{{compute difference{14066
*      make sign of result match sign of first argument
*      -result is in ra at this point
{{bze{8,wb{6,srm09{{if result should be positive{14071
{{rle{6,exrea{{{if should be negative, and is{14072
{srm08{ngr{{{{adjust sign of result{14073
{{brn{6,exrea{{{return result{14074
{srm09{rlt{6,srm08{{{should be pos, and result negative{14075
{{brn{6,exrea{{{should be positive, and is{14076
*      fail if overflow
{srm10{erb{1,312{26,remdr caused real overflow{{{14080
{{ejc{{{{{14082
*      replace
*      the actual replace operation uses an scblk whose cfp_a
*      chars contain the translated versions of all the chars.
*      the table pointer is remembered from call to call and
*      the table is only built when the arguments change.
*      we also perform an optimization gleaned from spitbol 370.
*      if the second argument is &alphabet, there is no need to
*      to build a replace table.  the third argument can be
*      used directly as the replace table.
{s_rpl{ent{{{{entry point{14096
{{jsr{6,gtstg{{{load third argument as string{14097
{{err{1,168{26,replace third argument is not a string{{{14098
{{mov{7,xl{7,xr{{save third arg ptr{14099
{{jsr{6,gtstg{{{get second argument{14100
{{err{1,169{26,replace second argument is not a string{{{14101
*      check to see if this is the same table as last time
{{bne{7,xr{3,r_ra2{6,srpl1{jump if 2nd argument different{14105
{{beq{7,xl{3,r_ra3{6,srpl4{jump if args same as last time{14106
*      here we build a new replace table (note wa = 2nd arg len)
{srpl1{mov{8,wb{13,sclen(xl){{load 3rd argument length{14110
{{bne{8,wa{8,wb{6,srpl6{jump if arguments not same length{14111
{{beq{7,xr{3,kvalp{6,srpl5{jump if 2nd arg is alphabet string{14112
{{bze{8,wb{6,srpl6{{jump if null 2nd argument{14113
{{mov{3,r_ra3{7,xl{{save third arg for next time in{14114
{{mov{3,r_ra2{7,xr{{save second arg for next time in{14115
{{mov{7,xl{3,kvalp{{point to alphabet string{14116
{{mov{8,wa{13,sclen(xl){{load alphabet scblk length{14117
{{mov{7,xr{3,r_rpt{{point to current table (if any){14118
{{bnz{7,xr{6,srpl2{{jump if we already have a table{14119
*      here we allocate a new table
{{jsr{6,alocs{{{allocate new table{14123
{{mov{8,wa{8,wc{{keep scblk length{14124
{{mov{3,r_rpt{7,xr{{save table pointer for next time{14125
*      merge here with pointer to new table block in (xr)
{srpl2{ctb{8,wa{2,scsi_{{compute length of scblk{14129
{{mvw{{{{copy to get initial table values{14130
{{ejc{{{{{14131
*      replace (continued)
*      now we must plug selected entries as required. note that
*      we are short of index registers for the following loop.
*      hence the need to repeatedly re-initialise char ptr xl
{{mov{7,xl{3,r_ra2{{point to second argument{14139
{{lct{8,wb{8,wb{{number of chars to plug{14140
{{zer{8,wc{{{zero char offset{14141
{{mov{7,xr{3,r_ra3{{point to 3rd arg{14142
{{plc{7,xr{{{get char ptr for 3rd arg{14143
*      loop to plug chars
{srpl3{mov{7,xl{3,r_ra2{{point to 2nd arg{14147
{{plc{7,xl{8,wc{{point to next char{14148
{{icv{8,wc{{{increment offset{14149
{{lch{8,wa{9,(xl){{get next char{14150
{{mov{7,xl{3,r_rpt{{point to translate table{14151
{{psc{7,xl{8,wa{{convert char to offset into table{14152
{{lch{8,wa{10,(xr)+{{get translated char{14153
{{sch{8,wa{9,(xl){{store in table{14154
{{csc{7,xl{{{complete store characters{14155
{{bct{8,wb{6,srpl3{{loop till done{14156
{{ejc{{{{{14157
*      replace (continued)
*      here to use r_rpt as replace table.
{srpl4{mov{7,xl{3,r_rpt{{replace table to use{14163
*      here to perform translate using table in xl.
{srpl5{jsr{6,gtstg{{{get first argument{14168
{{err{1,170{26,replace first argument is not a string{{{14169
{{bze{8,wa{6,exnul{{return null if null argument{14178
{{mov{11,-(xs){7,xl{{stack replace table to use{14179
{{mov{7,xl{7,xr{{copy pointer{14180
{{mov{8,wc{8,wa{{save length{14181
{{ctb{8,wa{2,schar{{get scblk length{14182
{{jsr{6,alloc{{{allocate space for copy{14183
{{mov{8,wb{7,xr{{save address of copy{14184
{{mvw{{{{move scblk contents to copy{14185
{{mov{7,xr{10,(xs)+{{unstack replace table{14186
{{plc{7,xr{{{point to chars of table{14187
{{mov{7,xl{8,wb{{point to string to translate{14188
{{plc{7,xl{{{point to chars of string{14189
{{mov{8,wa{8,wc{{set number of chars to translate{14190
{{trc{{{{perform translation{14191
{srpl8{mov{11,-(xs){8,wb{{stack result{14192
{{lcw{7,xr{{{load next code word{14193
{{bri{9,(xr){{{execute it{14194
*      error point
{srpl6{erb{1,171{26,null or unequally long 2nd, 3rd args to replace{{{14198
{{ejc{{{{{14213
*      rewind
{s_rew{ent{{{{entry point{14217
{{jsr{6,iofcb{{{call fcblk routine{14218
{{err{1,172{26,rewind argument is not a suitable name{{{14219
{{err{1,173{26,rewind argument is null{{{14220
{{err{1,174{26,rewind file does not exist{{{14221
{{jsr{6,sysrw{{{call system rewind function{14222
{{err{1,174{26,rewind file does not exist{{{14223
{{err{1,175{26,rewind file does not permit rewind{{{14224
{{err{1,176{26,rewind caused non-recoverable error{{{14225
{{brn{6,exnul{{{exit with null result if no error{14226
{{ejc{{{{{14227
*      reverse
{s_rvs{ent{{{{entry point{14231
{{jsr{6,gtstg{{{load string argument{14233
{{err{1,177{26,reverse argument is not a string{{{14234
{{bze{8,wa{6,exixr{{return argument if null{14240
{{mov{7,xl{7,xr{{else save pointer to string arg{14241
{{jsr{6,alocs{{{allocate space for new scblk{14242
{{mov{11,-(xs){7,xr{{store scblk ptr on stack as result{14243
{{psc{7,xr{{{prepare to store in new scblk{14244
{{plc{7,xl{8,wc{{point past last char in argument{14245
{{lct{8,wc{8,wc{{set loop counter{14246
*      loop to move chars in reverse order
{srvs1{lch{8,wb{11,-(xl){{load next char from argument{14250
{{sch{8,wb{10,(xr)+{{store in result{14251
{{bct{8,wc{6,srvs1{{loop till all moved{14252
*      here when complete to execute next code word
{srvs4{csc{7,xr{{{complete store characters{14256
{{zer{7,xl{{{clear garbage xl{14257
{srvs2{lcw{7,xr{{{load next code word{14258
{{bri{9,(xr){{{execute it{14259
{{ejc{{{{{14283
*      rpad
{s_rpd{ent{{{{entry point{14287
{{jsr{6,gtstg{{{get pad character{14288
{{err{1,178{26,rpad third argument is not a string{{{14289
{{plc{7,xr{{{point to character (null is blank){14290
{{lch{8,wb{9,(xr){{load pad character{14291
{{jsr{6,gtsmi{{{get pad length{14292
{{err{1,179{26,rpad second argument is not integer{{{14293
{{ppm{6,srpd3{{{skip if negative or large{14294
*      merge to check first arg.
{srpd1{jsr{6,gtstg{{{get first argument (string to pad){14298
{{err{1,180{26,rpad first argument is not a string{{{14299
{{bge{8,wa{8,wc{6,exixr{return 1st arg if too long to pad{14300
{{mov{7,xl{7,xr{{else move ptr to string to pad{14301
*      now we are ready for the pad
*      (xl)                  pointer to string to pad
*      (wb)                  pad character
*      (wc)                  length to pad string to
{{mov{8,wa{8,wc{{copy length{14309
{{jsr{6,alocs{{{allocate scblk for new string{14310
{{mov{11,-(xs){7,xr{{save as result{14311
{{mov{8,wa{13,sclen(xl){{load length of argument{14312
{{sub{8,wc{8,wa{{calculate number of pad characters{14313
{{psc{7,xr{{{point to chars in result string{14314
{{lct{8,wc{8,wc{{set counter for pad loop{14315
*      copy argument string
{{bze{8,wa{6,srpd2{{jump if argument is null{14319
{{plc{7,xl{{{else point to argument chars{14320
{{mvc{{{{move characters to result string{14321
{{zer{7,xl{{{clear garbage xl{14322
*      loop to supply pad characters
{srpd2{sch{8,wb{10,(xr)+{{store pad character, bump ptr{14326
{{bct{8,wc{6,srpd2{{loop till all pad chars stored{14327
{{csc{7,xr{{{complete character storing{14328
{{lcw{7,xr{{{load next code word{14329
{{bri{9,(xr){{{execute it{14330
*      here if 2nd arg is negative or large
{srpd3{zer{8,wc{{{zero pad count{14334
{{brn{6,srpd1{{{merge{14335
{{ejc{{{{{14336
*      rtab
{s_rtb{ent{{{{entry point{14340
{{mov{8,wb{22,=p_rtb{{set pcode for integer arg case{14341
{{mov{8,wa{22,=p_rtd{{set pcode for expression arg case{14342
{{jsr{6,patin{{{call common routine to build node{14343
{{err{1,181{26,rtab argument is not integer or expression{{{14344
{{err{1,182{26,rtab argument is negative or too large{{{14345
{{mov{11,-(xs){7,xr{{stack result{14346
{{lcw{7,xr{{{get next code word{14347
{{bri{9,(xr){{{execute it{14348
{{ejc{{{{{14349
*      tab
{s_tab{ent{{{{entry point{14390
{{mov{8,wb{22,=p_tab{{set pcode for integer arg case{14391
{{mov{8,wa{22,=p_tbd{{set pcode for expression arg case{14392
{{jsr{6,patin{{{call common routine to build node{14393
{{err{1,183{26,tab argument is not integer or expression{{{14394
{{err{1,184{26,tab argument is negative or too large{{{14395
{{mov{11,-(xs){7,xr{{stack result{14396
{{lcw{7,xr{{{get next code word{14397
{{bri{9,(xr){{{execute it{14398
{{ejc{{{{{14399
*      rpos
{s_rps{ent{{{{entry point{14403
{{mov{8,wb{22,=p_rps{{set pcode for integer arg case{14404
{{mov{8,wa{22,=p_rpd{{set pcode for expression arg case{14405
{{jsr{6,patin{{{call common routine to build node{14406
{{err{1,185{26,rpos argument is not integer or expression{{{14407
{{err{1,186{26,rpos argument is negative or too large{{{14408
{{mov{11,-(xs){7,xr{{stack result{14409
{{lcw{7,xr{{{get next code word{14410
{{bri{9,(xr){{{execute it{14411
{{ejc{{{{{14414
*      rsort
{s_rsr{ent{{{{entry point{14418
{{mnz{8,wa{{{mark as rsort{14419
{{jsr{6,sorta{{{call sort routine{14420
{{ppm{6,exfal{{{if conversion fails, so shall we{14421
{{brn{6,exsid{{{return, setting idval{14422
{{ejc{{{{{14424
*      setexit
{s_stx{ent{{{{entry point{14428
{{mov{7,xr{10,(xs)+{{load argument{14429
{{mov{8,wa{3,stxvr{{load old vrblk pointer{14430
{{zer{7,xl{{{load zero in case null arg{14431
{{beq{7,xr{21,=nulls{6,sstx1{jump if null argument (reset call){14432
{{jsr{6,gtnvr{{{else get specified vrblk{14433
{{ppm{6,sstx2{{{jump if not natural variable{14434
{{mov{7,xl{13,vrlbl(xr){{else load label{14435
{{beq{7,xl{21,=stndl{6,sstx2{jump if label is not defined{14436
{{bne{9,(xl){22,=b_trt{6,sstx1{jump if not trapped{14437
{{mov{7,xl{13,trlbl(xl){{else load ptr to real label code{14438
*      here to set/reset setexit trap
{sstx1{mov{3,stxvr{7,xr{{store new vrblk pointer (or null){14442
{{mov{3,r_sxc{7,xl{{store new code ptr (or zero){14443
{{beq{8,wa{21,=nulls{6,exnul{return null if null result{14444
{{mov{7,xr{8,wa{{else copy vrblk pointer{14445
{{brn{6,exvnm{{{and return building nmblk{14446
*      here if bad argument
{sstx2{erb{1,187{26,setexit argument is not label name or null{{{14450
*      sin
{s_sin{ent{{{{entry point{14455
{{mov{7,xr{10,(xs)+{{get argument{14456
{{jsr{6,gtrea{{{convert to real{14457
{{err{1,308{26,sin argument not numeric{{{14458
{{ldr{13,rcval(xr){{{load accumulator with argument{14459
{{sin{{{{take sine{14460
{{rno{6,exrea{{{if no overflow, return result in ra{14461
{{erb{1,323{26,sin argument is out of range{{{14462
{{ejc{{{{{14463
*      sqrt
{s_sqr{ent{{{{entry point{14469
{{mov{7,xr{10,(xs)+{{get argument{14470
{{jsr{6,gtrea{{{convert to real{14471
{{err{1,313{26,sqrt argument not numeric{{{14472
{{ldr{13,rcval(xr){{{load accumulator with argument{14473
{{rlt{6,ssqr1{{{negative number{14474
{{sqr{{{{take square root{14475
{{brn{6,exrea{{{no overflow possible, result in ra{14476
*      here if bad argument
{ssqr1{erb{1,314{26,sqrt argument negative{{{14480
{{ejc{{{{{14481
{{ejc{{{{{14485
*      sort
{s_srt{ent{{{{entry point{14489
{{zer{8,wa{{{mark as sort{14490
{{jsr{6,sorta{{{call sort routine{14491
{{ppm{6,exfal{{{if conversion fails, so shall we{14492
{{brn{6,exsid{{{return, setting idval{14493
{{ejc{{{{{14495
*      span
{s_spn{ent{{{{entry point{14499
{{mov{8,wb{22,=p_sps{{set pcode for single char arg{14500
{{mov{7,xl{22,=p_spn{{set pcode for multi-char arg{14501
{{mov{8,wc{22,=p_spd{{set pcode for expression arg{14502
{{jsr{6,patst{{{call common routine to build node{14503
{{err{1,188{26,span argument is not a string or expression{{{14504
{{mov{11,-(xs){7,xr{{stack result{14505
{{lcw{7,xr{{{get next code word{14506
{{bri{9,(xr){{{execute it{14507
{{ejc{{{{{14508
*      size
{s_si_{ent{{{{entry point{14512
{{jsr{6,gtstg{{{load string argument{14514
{{err{1,189{26,size argument is not a string{{{14515
*      merge with bfblk or scblk ptr in xr.  wa has length.
{{mti{8,wa{{{load length as integer{14523
{{brn{6,exint{{{exit with integer result{14524
{{ejc{{{{{14525
*      stoptr
{s_stt{ent{{{{entry point{14529
{{zer{7,xl{{{indicate stoptr case{14530
{{jsr{6,trace{{{call trace procedure{14531
{{err{1,190{26,stoptr first argument is not appropriate name{{{14532
{{err{1,191{26,stoptr second argument is not trace type{{{14533
{{brn{6,exnul{{{return null{14534
{{ejc{{{{{14535
*      substr
{s_sub{ent{{{{entry point{14539
{{jsr{6,gtsmi{{{load third argument{14540
{{err{1,192{26,substr third argument is not integer{{{14541
{{ppm{6,exfal{{{jump if negative or too large{14542
{{mov{3,sbssv{7,xr{{save third argument{14543
{{jsr{6,gtsmi{{{load second argument{14544
{{err{1,193{26,substr second argument is not integer{{{14545
{{ppm{6,exfal{{{jump if out of range{14546
{{mov{8,wc{7,xr{{save second argument{14547
{{bze{8,wc{6,exfal{{jump if second argument zero{14548
{{dcv{8,wc{{{else decrement for ones origin{14549
{{jsr{6,gtstg{{{load first argument{14551
{{err{1,194{26,substr first argument is not a string{{{14552
*      merge with bfblk or scblk ptr in xr.  wa has length
{{mov{8,wb{8,wc{{copy second arg to wb{14560
{{mov{8,wc{3,sbssv{{reload third argument{14561
{{bnz{8,wc{6,ssub2{{skip if third arg given{14562
{{mov{8,wc{8,wa{{else get string length{14563
{{bgt{8,wb{8,wc{6,exfal{fail if improper{14564
{{sub{8,wc{8,wb{{reduce by offset to start{14565
*      merge
{ssub2{mov{7,xl{8,wa{{save string length{14569
{{mov{8,wa{8,wc{{set length of substring{14570
{{add{8,wc{8,wb{{add 2nd arg to 3rd arg{14571
{{bgt{8,wc{7,xl{6,exfal{jump if improper substring{14572
{{mov{7,xl{7,xr{{copy pointer to first arg{14573
{{jsr{6,sbstr{{{build substring{14574
{{mov{11,-(xs){7,xr{{stack result{14575
{{lcw{7,xr{{{get next code word{14576
{{bri{9,(xr){{{execute it{14577
{{ejc{{{{{14578
*      table
{s_tbl{ent{{{{entry point{14582
{{mov{7,xl{10,(xs)+{{get initial lookup value{14583
{{ica{7,xs{{{pop second argument{14584
{{jsr{6,gtsmi{{{load argument{14585
{{err{1,195{26,table argument is not integer{{{14586
{{err{1,196{26,table argument is out of range{{{14587
{{bnz{8,wc{6,stbl1{{jump if non-zero{14588
{{mov{8,wc{18,=tbnbk{{else supply default value{14589
*      merge here with number of headers in wc
{stbl1{jsr{6,tmake{{{make table{14593
{{brn{6,exsid{{{exit setting idval{14594
{{ejc{{{{{14595
*      tan
{s_tan{ent{{{{entry point{14600
{{mov{7,xr{10,(xs)+{{get argument{14601
{{jsr{6,gtrea{{{convert to real{14602
{{err{1,309{26,tan argument not numeric{{{14603
{{ldr{13,rcval(xr){{{load accumulator with argument{14604
{{tan{{{{take tangent{14605
{{rno{6,exrea{{{if no overflow, return result in ra{14606
{{erb{1,310{26,tan produced real overflow or argument is out of range{{{14607
{{ejc{{{{{14608
*      time
{s_tim{ent{{{{entry point{14613
{{jsr{6,systm{{{get timer value{14614
{{sbi{3,timsx{{{subtract starting time{14615
{{brn{6,exint{{{exit with integer value{14616
{{ejc{{{{{14617
*      trace
{s_tra{ent{{{{entry point{14621
{{beq{13,num03(xs){21,=nulls{6,str02{jump if first argument is null{14622
{{mov{7,xr{10,(xs)+{{load fourth argument{14623
{{zer{7,xl{{{tentatively set zero pointer{14624
{{beq{7,xr{21,=nulls{6,str01{jump if 4th argument is null{14625
{{jsr{6,gtnvr{{{else point to vrblk{14626
{{ppm{6,str03{{{jump if not variable name{14627
{{mov{7,xl{7,xr{{else save vrblk in trfnc{14628
*      here with vrblk or zero in xl
{str01{mov{7,xr{10,(xs)+{{load third argument (tag){14632
{{zer{8,wb{{{set zero as trtyp value for now{14633
{{jsr{6,trbld{{{build trblk for trace call{14634
{{mov{7,xl{7,xr{{move trblk pointer for trace{14635
{{jsr{6,trace{{{call trace procedure{14636
{{err{1,198{26,trace first argument is not appropriate name{{{14637
{{err{1,199{26,trace second argument is not trace type{{{14638
{{brn{6,exnul{{{return null{14639
*      here to call system trace toggle routine
{str02{jsr{6,systt{{{call it{14643
{{add{7,xs{19,*num04{{pop trace arguments{14644
{{brn{6,exnul{{{return{14645
*      here for bad fourth argument
{str03{erb{1,197{26,trace fourth arg is not function name or null{{{14649
{{ejc{{{{{14650
*      trim
{s_trm{ent{{{{entry point{14654
{{jsr{6,gtstg{{{load argument as string{14656
{{err{1,200{26,trim argument is not a string{{{14657
{{bze{8,wa{6,exnul{{return null if argument is null{14663
{{mov{7,xl{7,xr{{copy string pointer{14664
{{ctb{8,wa{2,schar{{get block length{14665
{{jsr{6,alloc{{{allocate copy same size{14666
{{mov{8,wb{7,xr{{save pointer to copy{14667
{{mvw{{{{copy old string block to new{14668
{{mov{7,xr{8,wb{{restore ptr to new block{14669
{{jsr{6,trimr{{{trim blanks (wb is non-zero){14670
{{mov{11,-(xs){7,xr{{stack result{14671
{{lcw{7,xr{{{get next code word{14672
{{bri{9,(xr){{{execute it{14673
{{ejc{{{{{14716
*      unload
{s_unl{ent{{{{entry point{14720
{{mov{7,xr{10,(xs)+{{load argument{14721
{{jsr{6,gtnvr{{{point to vrblk{14722
{{err{1,201{26,unload argument is not natural variable name{{{14723
{{mov{7,xl{21,=stndf{{get ptr to undefined function{14724
{{jsr{6,dffnc{{{undefine named function{14725
{{brn{6,exnul{{{return null as result{14726
{{ttl{27,s p i t b o l -- utility routines{{{{14748
*      the following section contains utility routines used for
*      various purposes throughout the system. these differ
*      from the procedures in the utility procedures section in
*      they are not in procedure form and they do not return
*      to their callers. they are accessed with a branch type
*      instruction after setting the registers to appropriate
*      parameter values.
*      the register values required for each routine are
*      documented at the start of each routine. registers not
*      mentioned may contain any values except that xr,xl
*      can only contain proper collectable pointers.
*      some of these routines will tolerate garbage pointers
*      in xl,xr on entry. this is always documented and in
*      each case, the routine clears these garbage values before
*      exiting after completing its task.
*      the routines have names consisting of five letters
*      and are assembled in alphabetical order.
{{ejc{{{{{14770
*      arref -- array reference
*      (xl)                  may be non-collectable
*      (xr)                  number of subscripts
*      (wb)                  set zero/nonzero for value/name
*                            the value in wb must be collectable
*      stack                 subscripts and array operand
*      brn  arref            jump to call function
*      arref continues by executing the next code word with
*      the result name or value placed on top of the stack.
*      to deal with the problem of accessing subscripts in the
*      order of stacking, xl is used as a subscript pointer
*      working below the stack pointer.
{arref{rtn{{{{{14786
{{mov{8,wa{7,xr{{copy number of subscripts{14787
{{mov{7,xt{7,xs{{point to stack front{14788
{{wtb{7,xr{{{convert to byte offset{14789
{{add{7,xt{7,xr{{point to array operand on stack{14790
{{ica{7,xt{{{final value for stack popping{14791
{{mov{3,arfxs{7,xt{{keep for later{14792
{{mov{7,xr{11,-(xt){{load array operand pointer{14793
{{mov{3,r_arf{7,xr{{keep array pointer{14794
{{mov{7,xr{7,xt{{save pointer to subscripts{14795
{{mov{7,xl{3,r_arf{{point xl to possible vcblk or tbblk{14796
{{mov{8,wc{9,(xl){{load first word{14797
{{beq{8,wc{22,=b_art{6,arf01{jump if arblk{14798
{{beq{8,wc{22,=b_vct{6,arf07{jump if vcblk{14799
{{beq{8,wc{22,=b_tbt{6,arf10{jump if tbblk{14800
{{erb{1,235{26,subscripted operand is not table or array{{{14801
*      here for array (arblk)
{arf01{bne{8,wa{13,arndm(xl){6,arf09{jump if wrong number of dims{14805
{{ldi{4,intv0{{{get initial subscript of zero{14806
{{mov{7,xt{7,xr{{point before subscripts{14807
{{zer{8,wa{{{initial offset to bounds{14808
{{brn{6,arf03{{{jump into loop{14809
*      loop to compute subscripts by multiplications
{arf02{mli{13,ardm2(xr){{{multiply total by next dimension{14813
*      merge here first time
{arf03{mov{7,xr{11,-(xt){{load next subscript{14817
{{sti{3,arfsi{{{save current subscript{14818
{{ldi{13,icval(xr){{{load integer value in case{14819
{{beq{9,(xr){22,=b_icl{6,arf04{jump if it was an integer{14820
{{ejc{{{{{14821
*      arref (continued)
{{jsr{6,gtint{{{convert to integer{14826
{{ppm{6,arf12{{{jump if not integer{14827
{{ldi{13,icval(xr){{{if ok, load integer value{14828
*      here with integer subscript in (ia)
{arf04{mov{7,xr{3,r_arf{{point to array{14832
{{add{7,xr{8,wa{{offset to next bounds{14833
{{sbi{13,arlbd(xr){{{subtract low bound to compare{14834
{{iov{6,arf13{{{out of range fail if overflow{14835
{{ilt{6,arf13{{{out of range fail if too small{14836
{{sbi{13,ardim(xr){{{subtract dimension{14837
{{ige{6,arf13{{{out of range fail if too large{14838
{{adi{13,ardim(xr){{{else restore subscript offset{14839
{{adi{3,arfsi{{{add to current total{14840
{{add{8,wa{19,*ardms{{point to next bounds{14841
{{bne{7,xt{7,xs{6,arf02{loop back if more to go{14842
*      here with integer subscript computed
{{mfi{8,wa{{{get as one word integer{14846
{{wtb{8,wa{{{convert to offset{14847
{{mov{7,xl{3,r_arf{{point to arblk{14848
{{add{8,wa{13,arofs(xl){{add offset past bounds{14849
{{ica{8,wa{{{adjust for arpro field{14850
{{bnz{8,wb{6,arf08{{exit with name if name call{14851
*      merge here to get value for value call
{arf05{jsr{6,acess{{{get value{14855
{{ppm{6,arf13{{{fail if acess fails{14856
*      return value
{arf06{mov{7,xs{3,arfxs{{pop stack entries{14860
{{zer{3,r_arf{{{finished with array pointer{14861
{{mov{11,-(xs){7,xr{{stack result{14862
{{lcw{7,xr{{{get next code word{14863
{{bri{9,(xr){{{execute it{14864
{{ejc{{{{{14865
*      arref (continued)
*      here for vector
{arf07{bne{8,wa{18,=num01{6,arf09{error if more than 1 subscript{14871
{{mov{7,xr{9,(xs){{else load subscript{14872
{{jsr{6,gtint{{{convert to integer{14873
{{ppm{6,arf12{{{error if not integer{14874
{{ldi{13,icval(xr){{{else load integer value{14875
{{sbi{4,intv1{{{subtract for ones offset{14876
{{mfi{8,wa{6,arf13{{get subscript as one word{14877
{{add{8,wa{18,=vcvls{{add offset for standard fields{14878
{{wtb{8,wa{{{convert offset to bytes{14879
{{bge{8,wa{13,vclen(xl){6,arf13{fail if out of range subscript{14880
{{bze{8,wb{6,arf05{{back to get value if value call{14881
*      return name
{arf08{mov{7,xs{3,arfxs{{pop stack entries{14885
{{zer{3,r_arf{{{finished with array pointer{14886
{{brn{6,exnam{{{else exit with name{14887
*      here if subscript count is wrong
{arf09{erb{1,236{26,array referenced with wrong number of subscripts{{{14891
*      table
{arf10{bne{8,wa{18,=num01{6,arf11{error if more than 1 subscript{14895
{{mov{7,xr{9,(xs){{else load subscript{14896
{{jsr{6,tfind{{{call table search routine{14897
{{ppm{6,arf13{{{fail if failed{14898
{{bnz{8,wb{6,arf08{{exit with name if name call{14899
{{brn{6,arf06{{{else exit with value{14900
*      here for bad table reference
{arf11{erb{1,237{26,table referenced with more than one subscript{{{14904
*      here for bad subscript
{arf12{erb{1,238{26,array subscript is not integer{{{14908
*      here to signal failure
{arf13{zer{3,r_arf{{{finished with array pointer{14912
{{brn{6,exfal{{{fail{14913
{{ejc{{{{{14914
*      cfunc -- call a function
*      cfunc is used to call a snobol level function. it is
*      used by the apply function (s_app), the function
*      trace routine (trxeq) and the main function call entry
*      (o_fnc, o_fns). in the latter cases, cfunc is used only
*      if the number of arguments is incorrect.
*      (xl)                  pointer to function block
*      (wa)                  actual number of arguments
*      (xs)                  points to stacked arguments
*      brn  cfunc            jump to call function
*      cfunc continues by executing the function
{cfunc{rtn{{{{{14931
{{blt{8,wa{13,fargs(xl){6,cfnc1{jump if too few arguments{14932
{{beq{8,wa{13,fargs(xl){6,cfnc3{jump if correct number of args{14933
*      here if too many arguments supplied, pop them off
{{mov{8,wb{8,wa{{copy actual number{14937
{{sub{8,wb{13,fargs(xl){{get number of extra args{14938
{{wtb{8,wb{{{convert to bytes{14939
{{add{7,xs{8,wb{{pop off unwanted arguments{14940
{{brn{6,cfnc3{{{jump to go off to function{14941
*      here if too few arguments
{cfnc1{mov{8,wb{13,fargs(xl){{load required number of arguments{14945
{{beq{8,wb{18,=nini9{6,cfnc3{jump if case of var num of args{14946
{{sub{8,wb{8,wa{{calculate number missing{14947
{{lct{8,wb{8,wb{{set counter to control loop{14948
*      loop to supply extra null arguments
{cfnc2{mov{11,-(xs){21,=nulls{{stack a null argument{14952
{{bct{8,wb{6,cfnc2{{loop till proper number stacked{14953
*      merge here to jump to function
{cfnc3{bri{9,(xl){{{jump through fcode field{14957
{{ejc{{{{{14958
*      exfal -- exit signalling snobol failure
*      (xl,xr)               may be non-collectable
*      brn  exfal            jump to fail
*      exfal continues by executing the appropriate fail goto
{exfal{rtn{{{{{14967
{{mov{7,xs{3,flptr{{pop stack{14968
{{mov{7,xr{9,(xs){{load failure offset{14969
{{add{7,xr{3,r_cod{{point to failure code location{14970
{{lcp{7,xr{{{set code pointer{14971
{{lcw{7,xr{{{load next code word{14972
{{mov{7,xl{9,(xr){{load entry address{14973
{{bri{7,xl{{{jump to execute next code word{14974
{{ejc{{{{{14975
*      exint -- exit with integer result
*      (xl,xr)               may be non-collectable
*      (ia)                  integer value
*      brn  exint            jump to exit with integer
*      exint continues by executing the next code word
*      which it does by falling through to exixr
{exint{rtn{{{{{14986
{{zer{7,xl{{{clear dud value{14987
{{jsr{6,icbld{{{build icblk{14988
{{ejc{{{{{14989
*      exixr -- exit with result in (xr)
*      (xr)                  result
*      (xl)                  may be non-collectable
*      brn  exixr            jump to exit with result in (xr)
*      exixr continues by executing the next code word
*      which it does by falling through to exits.
{exixr{rtn{{{{{14998
{{mov{11,-(xs){7,xr{{stack result{15000
*      exits -- exit with result if any stacked
*      (xr,xl)               may be non-collectable
*      brn  exits            enter exits routine
{exits{rtn{{{{{15009
{{lcw{7,xr{{{load next code word{15010
{{mov{7,xl{9,(xr){{load entry address{15011
{{bri{7,xl{{{jump to execute next code word{15012
{{ejc{{{{{15013
*      exnam -- exit with name in (xl,wa)
*      (xl)                  name base
*      (wa)                  name offset
*      (xr)                  may be non-collectable
*      brn  exnam            jump to exit with name in (xl,wa)
*      exnam continues by executing the next code word
{exnam{rtn{{{{{15024
{{mov{11,-(xs){7,xl{{stack name base{15025
{{mov{11,-(xs){8,wa{{stack name offset{15026
{{lcw{7,xr{{{load next code word{15027
{{bri{9,(xr){{{execute it{15028
{{ejc{{{{{15029
*      exnul -- exit with null result
*      (xl,xr)               may be non-collectable
*      brn  exnul            jump to exit with null value
*      exnul continues by executing the next code word
{exnul{rtn{{{{{15038
{{mov{11,-(xs){21,=nulls{{stack null value{15039
{{lcw{7,xr{{{load next code word{15040
{{mov{7,xl{9,(xr){{load entry address{15041
{{bri{7,xl{{{jump to execute next code word{15042
{{ejc{{{{{15043
*      exrea -- exit with real result
*      (xl,xr)               may be non-collectable
*      (ra)                  real value
*      brn  exrea            jump to exit with real value
*      exrea continues by executing the next code word
{exrea{rtn{{{{{15055
{{zer{7,xl{{{clear dud value{15056
{{jsr{6,rcbld{{{build rcblk{15057
{{brn{6,exixr{{{jump to exit with result in xr{15058
{{ejc{{{{{15060
*      exsid -- exit setting id field
*      exsid is used to exit after building any of the following
*      blocks (arblk, tbblk, pdblk, vcblk). it sets the idval.
*      (xr)                  ptr to block with idval field
*      (xl)                  may be non-collectable
*      brn  exsid            jump to exit after setting id field
*      exsid continues by executing the next code word
{exsid{rtn{{{{{15073
{{mov{8,wa{3,curid{{load current id value{15074
{{bne{8,wa{3,mxint{6,exsi1{jump if no overflow{15075
{{zer{8,wa{{{else reset for wraparound{15076
*      here with old idval in wa
{exsi1{icv{8,wa{{{bump id value{15080
{{mov{3,curid{8,wa{{store for next time{15081
{{mov{13,idval(xr){8,wa{{store id value{15082
{{brn{6,exixr{{{exit with result in (xr){15083
{{ejc{{{{{15084
*      exvnm -- exit with name of variable
*      exvnm exits after stacking a value which is a nmblk
*      referencing the name of a given natural variable.
*      (xr)                  vrblk pointer
*      (xl)                  may be non-collectable
*      brn  exvnm            exit with vrblk pointer in xr
{exvnm{rtn{{{{{15095
{{mov{7,xl{7,xr{{copy name base pointer{15096
{{mov{8,wa{19,*nmsi_{{set size of nmblk{15097
{{jsr{6,alloc{{{allocate nmblk{15098
{{mov{9,(xr){22,=b_nml{{store type word{15099
{{mov{13,nmbas(xr){7,xl{{store name base{15100
{{mov{13,nmofs(xr){19,*vrval{{store name offset{15101
{{brn{6,exixr{{{exit with result in xr{15102
{{ejc{{{{{15103
*      flpop -- fail and pop in pattern matching
*      flpop pops the node and cursor on the stack and then
*      drops through into failp to cause pattern failure
*      (xl,xr)               may be non-collectable
*      brn  flpop            jump to fail and pop stack
{flpop{rtn{{{{{15113
{{add{7,xs{19,*num02{{pop two entries off stack{15114
{{ejc{{{{{15115
*      failp -- failure in matching pattern node
*      failp is used after failing to match a pattern node.
*      see pattern match routines for details of use.
*      (xl,xr)               may be non-collectable
*      brn  failp            signal failure to match
*      failp continues by matching an alternative from the stack
{failp{rtn{{{{{15127
{{mov{7,xr{10,(xs)+{{load alternative node pointer{15128
{{mov{8,wb{10,(xs)+{{restore old cursor{15129
{{mov{7,xl{9,(xr){{load pcode entry pointer{15130
{{bri{7,xl{{{jump to execute code for node{15131
{{ejc{{{{{15132
*      indir -- compute indirect reference
*      (wb)                  nonzero/zero for by name/value
*      brn  indir            jump to get indirect ref on stack
*      indir continues by executing the next code word
{indir{rtn{{{{{15141
{{mov{7,xr{10,(xs)+{{load argument{15142
{{beq{9,(xr){22,=b_nml{6,indr2{jump if a name{15143
{{jsr{6,gtnvr{{{else convert to variable{15144
{{err{1,239{26,indirection operand is not name{{{15145
{{bze{8,wb{6,indr1{{skip if by value{15146
{{mov{11,-(xs){7,xr{{else stack vrblk ptr{15147
{{mov{11,-(xs){19,*vrval{{stack name offset{15148
{{lcw{7,xr{{{load next code word{15149
{{mov{7,xl{9,(xr){{load entry address{15150
{{bri{7,xl{{{jump to execute next code word{15151
*      here to get value of natural variable
{indr1{bri{9,(xr){{{jump through vrget field of vrblk{15155
*      here if operand is a name
{indr2{mov{7,xl{13,nmbas(xr){{load name base{15159
{{mov{8,wa{13,nmofs(xr){{load name offset{15160
{{bnz{8,wb{6,exnam{{exit if called by name{15161
{{jsr{6,acess{{{else get value first{15162
{{ppm{6,exfal{{{fail if access fails{15163
{{brn{6,exixr{{{else return with value in xr{15164
{{ejc{{{{{15165
*      match -- initiate pattern match
*      (wb)                  match type code
*      brn  match            jump to initiate pattern match
*      match continues by executing the pattern match. see
*      pattern match routines (p_xxx) for full details.
{match{rtn{{{{{15175
{{mov{7,xr{10,(xs)+{{load pattern operand{15176
{{jsr{6,gtpat{{{convert to pattern{15177
{{err{1,240{26,pattern match right operand is not pattern{{{15178
{{mov{7,xl{7,xr{{if ok, save pattern pointer{15179
{{bnz{8,wb{6,mtch1{{jump if not match by name{15180
{{mov{8,wa{9,(xs){{else load name offset{15181
{{mov{11,-(xs){7,xl{{save pattern pointer{15182
{{mov{7,xl{13,num02(xs){{load name base{15183
{{jsr{6,acess{{{access subject value{15184
{{ppm{6,exfal{{{fail if access fails{15185
{{mov{7,xl{9,(xs){{restore pattern pointer{15186
{{mov{9,(xs){7,xr{{stack subject string val for merge{15187
{{zer{8,wb{{{restore type code{15188
*      merge here with subject value on stack
{mtch1{jsr{6,gtstg{{{convert subject to string{15193
{{err{1,241{26,pattern match left operand is not a string{{{15194
{{mov{11,-(xs){8,wb{{stack match type code{15195
{{mov{3,r_pms{7,xr{{if ok, store subject string pointer{15203
{{mov{3,pmssl{8,wa{{and length{15204
{{zer{11,-(xs){{{stack initial cursor (zero){15205
{{zer{8,wb{{{set initial cursor{15206
{{mov{3,pmhbs{7,xs{{set history stack base ptr{15207
{{zer{3,pmdfl{{{reset pattern assignment flag{15208
{{mov{7,xr{7,xl{{set initial node pointer{15209
{{bnz{3,kvanc{6,mtch2{{jump if anchored{15210
*      here for unanchored
{{mov{11,-(xs){7,xr{{stack initial node pointer{15214
{{mov{11,-(xs){21,=nduna{{stack pointer to anchor move node{15215
{{bri{9,(xr){{{start match of first node{15216
*      here in anchored mode
{mtch2{zer{11,-(xs){{{dummy cursor value{15220
{{mov{11,-(xs){21,=ndabo{{stack pointer to abort node{15221
{{bri{9,(xr){{{start match of first node{15222
{{ejc{{{{{15223
*      retrn -- return from function
*      (wa)                  string pointer for return type
*      brn  retrn            jump to return from (snobol) func
*      retrn continues by executing the code at the return point
*      the stack is cleaned of any garbage left by other
*      routines which may have altered flptr since function
*      entry by using flprt, reserved for use only by
*      function call and return.
{retrn{rtn{{{{{15236
{{bnz{3,kvfnc{6,rtn01{{jump if not level zero{15237
{{erb{1,242{26,function return from level zero{{{15238
*      here if not level zero return
{rtn01{mov{7,xs{3,flprt{{pop stack{15242
{{ica{7,xs{{{remove failure offset{15243
{{mov{7,xr{10,(xs)+{{pop pfblk pointer{15244
{{mov{3,flptr{10,(xs)+{{pop failure pointer{15245
{{mov{3,flprt{10,(xs)+{{pop old flprt{15246
{{mov{8,wb{10,(xs)+{{pop code pointer offset{15247
{{mov{8,wc{10,(xs)+{{pop old code block pointer{15248
{{add{8,wb{8,wc{{make old code pointer absolute{15249
{{lcp{8,wb{{{restore old code pointer{15250
{{mov{3,r_cod{8,wc{{restore old code block pointer{15251
{{dcv{3,kvfnc{{{decrement function level{15252
{{mov{8,wb{3,kvtra{{load trace{15253
{{add{8,wb{3,kvftr{{add ftrace{15254
{{bze{8,wb{6,rtn06{{jump if no tracing possible{15255
*      here if there may be a trace
{{mov{11,-(xs){8,wa{{save function return type{15259
{{mov{11,-(xs){7,xr{{save pfblk pointer{15260
{{mov{3,kvrtn{8,wa{{set rtntype for trace function{15261
{{mov{7,xl{3,r_fnc{{load fnclevel trblk ptr (if any){15262
{{jsr{6,ktrex{{{execute possible fnclevel trace{15263
{{mov{7,xl{13,pfvbl(xr){{load vrblk ptr (sgd13){15264
{{bze{3,kvtra{6,rtn02{{jump if trace is off{15265
{{mov{7,xr{13,pfrtr(xr){{else load return trace trblk ptr{15266
{{bze{7,xr{6,rtn02{{jump if not return traced{15267
{{dcv{3,kvtra{{{else decrement trace count{15268
{{bze{13,trfnc(xr){6,rtn03{{jump if print trace{15269
{{mov{8,wa{19,*vrval{{else set name offset{15270
{{mov{3,kvrtn{13,num01(xs){{make sure rtntype is set right{15271
{{jsr{6,trxeq{{{execute full trace{15272
{{ejc{{{{{15273
*      retrn (continued)
*      here to test for ftrace
{rtn02{bze{3,kvftr{6,rtn05{{jump if ftrace is off{15279
{{dcv{3,kvftr{{{else decrement ftrace{15280
*      here for print trace of function return
{rtn03{jsr{6,prtsn{{{print statement number{15284
{{mov{7,xr{13,num01(xs){{load return type{15285
{{jsr{6,prtst{{{print it{15286
{{mov{8,wa{18,=ch_bl{{load blank{15287
{{jsr{6,prtch{{{print it{15288
{{mov{7,xl{12,0(xs){{load pfblk ptr{15289
{{mov{7,xl{13,pfvbl(xl){{load function vrblk ptr{15290
{{mov{8,wa{19,*vrval{{set vrblk name offset{15291
{{bne{7,xr{21,=scfrt{6,rtn04{jump if not freturn case{15292
*      for freturn, just print function name
{{jsr{6,prtnm{{{print name{15296
{{jsr{6,prtnl{{{terminate print line{15297
{{brn{6,rtn05{{{merge{15298
*      here for return or nreturn, print function name = value
{rtn04{jsr{6,prtnv{{{print name = value{15302
*      here after completing trace
{rtn05{mov{7,xr{10,(xs)+{{pop pfblk pointer{15306
{{mov{8,wa{10,(xs)+{{pop return type string{15307
*      merge here if no trace required
{rtn06{mov{3,kvrtn{8,wa{{set rtntype keyword{15311
{{mov{7,xl{13,pfvbl(xr){{load pointer to fn vrblk{15312
{{ejc{{{{{15313
*      retrn (continued)
*      get value of function
{rtn07{mov{3,rtnbp{7,xl{{save block pointer{15318
{{mov{7,xl{13,vrval(xl){{load value{15319
{{beq{9,(xl){22,=b_trt{6,rtn07{loop back if trapped{15320
{{mov{3,rtnfv{7,xl{{else save function result value{15321
{{mov{3,rtnsv{10,(xs)+{{save original function value{15322
{{mov{7,xl{10,(xs)+{{pop saved pointer{15326
{{bze{7,xl{6,rtn7c{{no action if none{15327
{{bze{3,kvpfl{6,rtn7c{{jump if no profiling{15328
{{jsr{6,prflu{{{else profile last func stmt{15329
{{beq{3,kvpfl{18,=num02{6,rtn7a{branch on value of profile keywd{15330
*      here if &profile = 1. start time must be frigged to
*      appear earlier than it actually is, by amount used before
*      the call.
{{ldi{3,pfstm{{{load current time{15336
{{sbi{13,icval(xl){{{frig by subtracting saved amount{15337
{{brn{6,rtn7b{{{and merge{15338
*      here if &profile = 2
{rtn7a{ldi{13,icval(xl){{{load saved time{15342
*      both profile types merge here
{rtn7b{sti{3,pfstm{{{store back correct start time{15346
*      merge here if no profiling
{rtn7c{mov{8,wb{13,fargs(xr){{get number of args{15350
{{add{8,wb{13,pfnlo(xr){{add number of locals{15352
{{bze{8,wb{6,rtn10{{jump if no args/locals{15353
{{lct{8,wb{8,wb{{else set loop counter{15354
{{add{7,xr{13,pflen(xr){{and point to end of pfblk{15355
*      loop to restore functions and locals
{rtn08{mov{7,xl{11,-(xr){{load next vrblk pointer{15359
*      loop to find value block
{rtn09{mov{8,wa{7,xl{{save block pointer{15363
{{mov{7,xl{13,vrval(xl){{load pointer to next value{15364
{{beq{9,(xl){22,=b_trt{6,rtn09{loop back if trapped{15365
{{mov{7,xl{8,wa{{else restore last block pointer{15366
{{mov{13,vrval(xl){10,(xs)+{{restore old variable value{15367
{{bct{8,wb{6,rtn08{{loop till all processed{15368
*      now restore function value and exit
{rtn10{mov{7,xl{3,rtnbp{{restore ptr to last function block{15372
{{mov{13,vrval(xl){3,rtnsv{{restore old function value{15373
{{mov{7,xr{3,rtnfv{{reload function result{15374
{{mov{7,xl{3,r_cod{{point to new code block{15375
{{mov{3,kvlst{3,kvstn{{set lastno from stno{15376
{{mov{3,kvstn{13,cdstm(xl){{reset proper stno value{15377
{{mov{3,kvlln{3,kvlin{{set lastline from line{15379
{{mov{3,kvlin{13,cdsln(xl){{reset proper line value{15380
{{mov{8,wa{3,kvrtn{{load return type{15382
{{beq{8,wa{21,=scrtn{6,exixr{exit with result in xr if return{15383
{{beq{8,wa{21,=scfrt{6,exfal{fail if freturn{15384
{{ejc{{{{{15385
*      retrn (continued)
*      here for nreturn
{{beq{9,(xr){22,=b_nml{6,rtn11{jump if is a name{15391
{{jsr{6,gtnvr{{{else try convert to variable name{15392
{{err{1,243{26,function result in nreturn is not name{{{15393
{{mov{7,xl{7,xr{{if ok, copy vrblk (name base) ptr{15394
{{mov{8,wa{19,*vrval{{set name offset{15395
{{brn{6,rtn12{{{and merge{15396
*      here if returned result is a name
{rtn11{mov{7,xl{13,nmbas(xr){{load name base{15400
{{mov{8,wa{13,nmofs(xr){{load name offset{15401
*      merge here with returned name in (xl,wa)
{rtn12{mov{7,xr{7,xl{{preserve xl{15405
{{lcw{8,wb{{{load next word{15406
{{mov{7,xl{7,xr{{restore xl{15407
{{beq{8,wb{21,=ofne_{6,exnam{exit if called by name{15408
{{mov{11,-(xs){8,wb{{else save code word{15409
{{jsr{6,acess{{{get value{15410
{{ppm{6,exfal{{{fail if access fails{15411
{{mov{7,xl{7,xr{{if ok, copy result{15412
{{mov{7,xr{9,(xs){{reload next code word{15413
{{mov{9,(xs){7,xl{{store result on stack{15414
{{mov{7,xl{9,(xr){{load routine address{15415
{{bri{7,xl{{{jump to execute next code word{15416
{{ejc{{{{{15417
*      stcov -- signal statement counter overflow
*      brn  stcov            jump to signal statement count oflo
*      permit up to 10 more statements to be obeyed so that
*      setexit trap can regain control.
*      stcov continues by issuing the error message
{stcov{rtn{{{{{15427
{{icv{3,errft{{{fatal error{15428
{{ldi{4,intvt{{{get 10{15429
{{adi{3,kvstl{{{add to former limit{15430
{{sti{3,kvstl{{{store as new stlimit{15431
{{ldi{4,intvt{{{get 10{15432
{{sti{3,kvstc{{{set as new count{15433
{{jsr{6,stgcc{{{recompute countdown counters{15434
{{erb{1,244{26,statement count exceeds value of stlimit keyword{{{15435
{{ejc{{{{{15436
*      stmgo -- start execution of new statement
*      (xr)                  pointer to cdblk for new statement
*      brn  stmgo            jump to execute new statement
*      stmgo continues by executing the next statement
{stmgo{rtn{{{{{15445
{{mov{3,r_cod{7,xr{{set new code block pointer{15446
{{dcv{3,stmct{{{see if time to check something{15447
{{bze{3,stmct{6,stgo2{{jump if so{15448
{{mov{3,kvlst{3,kvstn{{set lastno{15449
{{mov{3,kvstn{13,cdstm(xr){{set stno{15450
{{mov{3,kvlln{3,kvlin{{set lastline{15452
{{mov{3,kvlin{13,cdsln(xr){{set line{15453
{{add{7,xr{19,*cdcod{{point to first code word{15455
{{lcp{7,xr{{{set code pointer{15456
*      here to execute first code word of statement
{stgo1{lcw{7,xr{{{load next code word{15460
{{zer{7,xl{{{clear garbage xl{15461
{{bri{9,(xr){{{execute it{15462
*      check profiling, polling, stlimit, statement tracing
{stgo2{bze{3,kvpfl{6,stgo3{{skip if no profiling{15466
{{jsr{6,prflu{{{else profile the statement in kvstn{15467
*      here when finished with profiling
{stgo3{mov{3,kvlst{3,kvstn{{set lastno{15471
{{mov{3,kvstn{13,cdstm(xr){{set stno{15472
{{mov{3,kvlln{3,kvlin{{set lastline{15474
{{mov{3,kvlin{13,cdsln(xr){{set line{15475
{{add{7,xr{19,*cdcod{{point to first code word{15477
{{lcp{7,xr{{{set code pointer{15478
*      here to check for polling
{{mov{11,-(xs){3,stmcs{{save present count start on stack{15483
{{dcv{3,polct{{{poll interval within stmct{15484
{{bnz{3,polct{6,stgo4{{jump if not poll time yet{15485
{{zer{8,wa{{{=0 for poll{15486
{{mov{8,wb{3,kvstn{{statement number{15487
{{mov{7,xl{7,xr{{make collectable{15488
{{jsr{6,syspl{{{allow interactive access{15489
{{err{1,320{26,user interrupt{{{15490
{{ppm{{{{single step{15491
{{ppm{{{{expression evaluation{15492
{{mov{7,xr{7,xl{{restore code block pointer{15493
{{mov{3,polcs{8,wa{{poll interval start value{15494
{{jsr{6,stgcc{{{recompute counter values{15495
*      check statement limit
{stgo4{ldi{3,kvstc{{{get stmt count{15500
{{ilt{6,stgo5{{{omit counting if negative{15501
{{mti{10,(xs)+{{{reload start value of counter{15502
{{ngi{{{{negate{15503
{{adi{3,kvstc{{{stmt count minus counter{15504
{{sti{3,kvstc{{{replace it{15505
{{ile{6,stcov{{{fail if stlimit reached{15506
{{bze{3,r_stc{6,stgo5{{jump if no statement trace{15507
{{zer{7,xr{{{clear garbage value in xr{15508
{{mov{7,xl{3,r_stc{{load pointer to stcount trblk{15509
{{jsr{6,ktrex{{{execute keyword trace{15510
*      reset stmgo counter
{stgo5{mov{3,stmct{3,stmcs{{reset counter{15514
{{brn{6,stgo1{{{fetch next code word{15515
{{ejc{{{{{15516
*      stopr -- terminate run
*      (xr)                  points to ending message
*      brn stopr             jump to terminate run
*      terminate run and print statistics.  on entry xr points
*      to ending message or is zero if message  printed already.
{stopr{rtn{{{{{15526
{{bze{7,xr{6,stpra{{skip if sysax already called{15528
{{jsr{6,sysax{{{call after execution proc{15529
{stpra{add{3,dname{3,rsmem{{use the reserve memory{15530
{{bne{7,xr{21,=endms{6,stpr0{skip if not normal end message{15534
{{bnz{3,exsts{6,stpr3{{skip if exec stats suppressed{15535
{{zer{3,erich{{{clear errors to int.ch. flag{15536
*      look to see if an ending message is supplied
{stpr0{jsr{6,prtpg{{{eject printer{15540
{{bze{7,xr{6,stpr1{{skip if no message{15541
{{jsr{6,prtst{{{print message{15542
*      merge here if no message to print
{stpr1{jsr{6,prtis{{{print blank line{15546
{{bnz{3,gbcfl{6,stpr5{{if in garbage collection, skip{15548
{{mov{7,xr{21,=stpm6{{point to message /in file xxx/{15549
{{jsr{6,prtst{{{print it{15550
{{mov{3,profs{18,=prtmf{{set column offset{15551
{{mov{8,wc{3,kvstn{{get statement number{15552
{{jsr{6,filnm{{{get file name{15553
{{mov{7,xr{7,xl{{prepare to print{15554
{{jsr{6,prtst{{{print file name{15555
{{jsr{6,prtis{{{print to interactive channel{15556
{{mov{7,xr{3,r_cod{{get code pointer{15563
{{mti{13,cdsln(xr){{{get source line number{15564
{{mov{7,xr{21,=stpm4{{point to message /in line xxx/{15565
{{jsr{6,prtmx{{{print it{15566
{stpr5{mti{3,kvstn{{{get statement number{15568
{{mov{7,xr{21,=stpm1{{point to message /in statement xxx/{15569
{{jsr{6,prtmx{{{print it{15570
{{ldi{3,kvstl{{{get statement limit{15571
{{ilt{6,stpr2{{{skip if negative{15572
{{sbi{3,kvstc{{{minus counter = course count{15573
{{sti{3,stpsi{{{save{15574
{{mov{8,wa{3,stmcs{{refine with counter start value{15575
{{sub{8,wa{3,stmct{{minus current counter{15576
{{mti{8,wa{{{convert to integer{15577
{{adi{3,stpsi{{{add in course count{15578
{{sti{3,stpsi{{{save{15579
{{mov{7,xr{21,=stpm2{{point to message /stmts executed/{15580
{{jsr{6,prtmx{{{print it{15581
{{jsr{6,systm{{{get current time{15582
{{sbi{3,timsx{{{minus start time = elapsed exec tim in nanosec{15583
{{sti{3,stpti{{{save for later{15584
{{dvi{4,intth{{{divide by 1000 to convert to microseconds{15585
{{iov{6,stpr2{{{jump if we cannot compute{15586
{{dvi{4,intth{{{divide by 1000 to convert to milliseconds{15587
{{iov{6,stpr2{{{jump if we cannot compute{15588
{{sti{3,stpti{{{save elapsed time in milliseconds{15589
{{mov{7,xr{21,=stpm3{{point to msg /execution time msec /{15590
{{jsr{6,prtmx{{{print it{15591
*      Only list peformance statistics giving stmts / millisec, etc.
*      if program ran for more than one millisecond.
{{ldi{3,stpti{{{reload execution time in milliseconds{15596
{{ile{6,stpr2{{{jump if exection time less than a millisecond{15597
{{ldi{3,stpsi{{{load statement count{15601
{{dvi{3,stpti{{{divide to get stmts per millisecond{15602
{{iov{6,stpr2{{{jump if we cannot compute{15603
{{dvi{4,intth{{{divide to get stmts per microsecond{15604
{{iov{6,stpr2{{{jump if we cannot compute{15605
{{mov{7,xr{21,=stpm7{{point to msg (stmt / microsec){15606
{{jsr{6,prtmx{{{print it{15607
{{ldi{3,stpsi{{{reload statement count{15609
{{dvi{3,stpti{{{divide to get stmts per millisecond{15610
{{iov{6,stpr2{{{jump if we cannot compute{15611
{{mov{7,xr{21,=stpm8{{point to msg (stmt / millisec ){15612
{{jsr{6,prtmx{{{print it{15613
{{ldi{3,stpsi{{{reload statement count{15615
{{dvi{3,stpti{{{divide to get stmts per millisecond{15616
{{iov{6,stpr2{{{jump if we cannot compute{15617
{{mli{4,intth{{{multiply by 1000 to get stmts per microsecond{15618
{{iov{6,stpr2{{{jump if overflow{15619
{{mov{7,xr{21,=stpm9{{point to msg ( stmt / second ){15620
{{jsr{6,prtmx{{{print it{15621
{{ejc{{{{{15623
*      stopr (continued)
*      merge to skip message (overflow or negative stlimit)
{stpr2{mti{3,gbcnt{{{load count of collections{15629
{{mov{7,xr{21,=stpm4{{point to message /regenerations /{15630
{{jsr{6,prtmx{{{print it{15631
{{jsr{6,prtmm{{{print memory usage{15632
{{jsr{6,prtis{{{one more blank for luck{15633
*      check if dump requested
{stpr3{jsr{6,prflr{{{print profile if wanted{15640
{{mov{7,xr{3,kvdmp{{load dump keyword{15642
{{jsr{6,dumpr{{{execute dump if requested{15644
{{mov{7,xl{3,r_fcb{{get fcblk chain head{15645
{{mov{8,wa{3,kvabe{{load abend value{15646
{{mov{8,wb{3,kvcod{{load code value{15647
{{jsr{6,sysej{{{exit to system{15648
*      here after sysea call and suppressing error msg print
{stpr4{rtn{{{{{15653
{{add{3,dname{3,rsmem{{use the reserve memory{15654
{{bze{3,exsts{6,stpr1{{if execution stats requested{15655
{{brn{6,stpr3{{{check if dump or profile needed{15656
{{ejc{{{{{15659
*      succp -- signal successful match of a pattern node
*      see pattern match routines for details
*      (xr)                  current node
*      (wb)                  current cursor
*      (xl)                  may be non-collectable
*      brn  succp            signal successful pattern match
*      succp continues by matching the successor node
{succp{rtn{{{{{15672
{{mov{7,xr{13,pthen(xr){{load successor node{15673
{{mov{7,xl{9,(xr){{load node code entry address{15674
{{bri{7,xl{{{jump to match successor node{15675
{{ejc{{{{{15676
*      sysab -- print /abnormal end/ and terminate
{sysab{rtn{{{{{15680
{{mov{7,xr{21,=endab{{point to message{15681
{{mov{3,kvabe{18,=num01{{set abend flag{15682
{{jsr{6,prtnl{{{skip to new line{15683
{{brn{6,stopr{{{jump to pack up{15684
{{ejc{{{{{15685
*      systu -- print /time up/ and terminate
{systu{rtn{{{{{15689
{{mov{7,xr{21,=endtu{{point to message{15690
{{mov{8,wa{4,strtu{{get chars /tu/{15691
{{mov{3,kvcod{8,wa{{put in kvcod{15692
{{mov{8,wa{3,timup{{check state of timeup switch{15693
{{mnz{3,timup{{{set switch{15694
{{bnz{8,wa{6,stopr{{stop run if already set{15695
{{erb{1,245{26,translation/execution time expired{{{15696
{{ttl{27,s p i t b o l -- utility procedures{{{{15697
*      the following section contains procedures which are
*      used for various purposes throughout the system.
*      each procedure is preceded by a description of the
*      calling sequence. usually the arguments are in registers
*      but arguments can also occur on the stack and as
*      parameters assembled after the jsr instruction.
*      the following considerations apply to these descriptions.
*      1)   the stack pointer (xs) is not changed unless the
*           change is explicitly documented in the call.
*      2)   registers whose entry values are not mentioned
*           may contain any value except that xl,xr may only
*           contain proper (collectable) pointer values.
*           this condition on means that the called routine
*           may if it chooses preserve xl,xr by stacking.
*      3)   registers not mentioned on exit contain the same
*           values as they did on entry except that values in
*           xr,xl may have been relocated by the collector.
*      4)   registers which are destroyed on exit may contain
*           any value except that values in xl,xr are proper
*           (collectable) pointers.
*      5)   the code pointer register points to the current
*           code location on entry and is unchanged on exit.
*      in the above description, a collectable pointer is one
*      which either points outside the dynamic region or
*      points to the start of a block in the dynamic region.
*      in those cases where the calling sequence contains
*      parameters which are used as alternate return points,
*      these parameters may be replaced by error codes
*      assembled with the err instruction. this will result
*      in the posting of the error if the return is taken.
*      the procedures all have names consisting of five letters
*      and are in alphabetical order by their names.
{{ejc{{{{{15741
*      acess - access variable value with trace/input checks
*      acess loads the value of a variable. trace and input
*      associations are tested for and executed as required.
*      acess also handles the special cases of pseudo-variables.
*      (xl)                  variable name base
*      (wa)                  variable name offset
*      jsr  acess            call to access value
*      ppm  loc              transfer loc if access failure
*      (xr)                  variable value
*      (wa,wb,wc)            destroyed
*      (xl,ra)               destroyed
*      failure can occur if an input association causes an end
*      of file condition or if the evaluation of an expression
*      associated with an expression variable fails.
{acess{prc{25,r{1,1{{entry point (recursive){15761
{{mov{7,xr{7,xl{{copy name base{15762
{{add{7,xr{8,wa{{point to variable location{15763
{{mov{7,xr{9,(xr){{load variable value{15764
*      loop here to check for successive trblks
{acs02{bne{9,(xr){22,=b_trt{6,acs18{jump if not trapped{15768
*      here if trapped
{{beq{7,xr{21,=trbkv{6,acs12{jump if keyword variable{15772
{{bne{7,xr{21,=trbev{6,acs05{jump if not expression variable{15773
*      here for expression variable, evaluate variable
{{mov{7,xr{13,evexp(xl){{load expression pointer{15777
{{zer{8,wb{{{evaluate by value{15778
{{jsr{6,evalx{{{evaluate expression{15779
{{ppm{6,acs04{{{jump if evaluation failure{15780
{{brn{6,acs02{{{check value for more trblks{15781
{{ejc{{{{{15782
*      acess (continued)
*      here on reading end of file
{acs03{add{7,xs{19,*num03{{pop trblk ptr, name base and offset{15788
{{mov{3,dnamp{7,xr{{pop unused scblk{15789
*      merge here when evaluation of expression fails
{acs04{exi{1,1{{{take alternate (failure) return{15793
*      here if not keyword or expression variable
{acs05{mov{8,wb{13,trtyp(xr){{load trap type code{15797
{{bnz{8,wb{6,acs10{{jump if not input association{15798
{{bze{3,kvinp{6,acs09{{ignore input assoc if input is off{15799
*      here for input association
{{mov{11,-(xs){7,xl{{stack name base{15803
{{mov{11,-(xs){8,wa{{stack name offset{15804
{{mov{11,-(xs){7,xr{{stack trblk pointer{15805
{{mov{3,actrm{3,kvtrm{{temp to hold trim keyword{15806
{{mov{7,xl{13,trfpt(xr){{get file ctrl blk ptr or zero{15807
{{bnz{7,xl{6,acs06{{jump if not standard input file{15808
{{beq{13,trter(xr){21,=v_ter{6,acs21{jump if terminal{15809
*      here to read from standard input file
{{mov{8,wa{3,cswin{{length for read buffer{15813
{{jsr{6,alocs{{{build string of appropriate length{15814
{{jsr{6,sysrd{{{read next standard input image{15815
{{ppm{6,acs03{{{jump to fail exit if end of file{15816
{{brn{6,acs07{{{else merge with other file case{15817
*      here for input from other than standard input file
{acs06{mov{8,wa{7,xl{{fcblk ptr{15821
{{jsr{6,sysil{{{get input record max length (to wa){15822
{{bnz{8,wc{6,acs6a{{jump if not binary file{15823
{{mov{3,actrm{8,wc{{disable trim for binary file{15824
{acs6a{jsr{6,alocs{{{allocate string of correct size{15825
{{mov{8,wa{7,xl{{fcblk ptr{15826
{{jsr{6,sysin{{{call system input routine{15827
{{ppm{6,acs03{{{jump to fail exit if end of file{15828
{{ppm{6,acs22{{{error{15829
{{ppm{6,acs23{{{error{15830
{{ejc{{{{{15831
*      acess (continued)
*      merge here after obtaining input record
{acs07{mov{8,wb{3,actrm{{load trim indicator{15837
{{jsr{6,trimr{{{trim record as required{15838
{{mov{8,wb{7,xr{{copy result pointer{15839
{{mov{7,xr{9,(xs){{reload pointer to trblk{15840
*      loop to chase to end of trblk chain and store value
{acs08{mov{7,xl{7,xr{{save pointer to this trblk{15844
{{mov{7,xr{13,trnxt(xr){{load forward pointer{15845
{{beq{9,(xr){22,=b_trt{6,acs08{loop if this is another trblk{15846
{{mov{13,trnxt(xl){8,wb{{else store result at end of chain{15847
{{mov{7,xr{10,(xs)+{{restore initial trblk pointer{15848
{{mov{8,wa{10,(xs)+{{restore name offset{15849
{{mov{7,xl{10,(xs)+{{restore name base pointer{15850
*      come here to move to next trblk
{acs09{mov{7,xr{13,trnxt(xr){{load forward ptr to next value{15854
{{brn{6,acs02{{{back to check if trapped{15855
*      here to check for access trace trblk
{acs10{bne{8,wb{18,=trtac{6,acs09{loop back if not access trace{15859
{{bze{3,kvtra{6,acs09{{ignore access trace if trace off{15860
{{dcv{3,kvtra{{{else decrement trace count{15861
{{bze{13,trfnc(xr){6,acs11{{jump if print trace{15862
{{ejc{{{{{15863
*      acess (continued)
*      here for full function trace
{{jsr{6,trxeq{{{call routine to execute trace{15869
{{brn{6,acs09{{{jump for next trblk{15870
*      here for case of print trace
{acs11{jsr{6,prtsn{{{print statement number{15874
{{jsr{6,prtnv{{{print name = value{15875
{{brn{6,acs09{{{jump back for next trblk{15876
*      here for keyword variable
{acs12{mov{7,xr{13,kvnum(xl){{load keyword number{15880
{{bge{7,xr{18,=k_v__{6,acs14{jump if not one word value{15881
{{mti{15,kvabe(xr){{{else load value as integer{15882
*      common exit with keyword value as integer in (ia)
{acs13{jsr{6,icbld{{{build icblk{15886
{{brn{6,acs18{{{jump to exit{15887
*      here if not one word keyword value
{acs14{bge{7,xr{18,=k_s__{6,acs15{jump if special case{15891
{{sub{7,xr{18,=k_v__{{else get offset{15892
{{wtb{7,xr{{{convert to byte offset{15893
{{add{7,xr{21,=ndabo{{point to pattern value{15894
{{brn{6,acs18{{{jump to exit{15895
*      here if special keyword case
{acs15{mov{7,xl{3,kvrtn{{load rtntype in case{15899
{{ldi{3,kvstl{{{load stlimit in case{15900
{{sub{7,xr{18,=k_s__{{get case number{15901
{{bsw{7,xr{2,k__n_{{switch on keyword number{15902
{{iff{2,k__al{6,acs16{{jump if alphabet{15916
{{iff{2,k__rt{6,acs17{{rtntype{15916
{{iff{2,k__sc{6,acs19{{stcount{15916
{{iff{2,k__et{6,acs20{{errtext{15916
{{iff{2,k__fl{6,acs26{{file{15916
{{iff{2,k__lf{6,acs27{{lastfile{15916
{{iff{2,k__sl{6,acs13{{stlimit{15916
{{iff{2,k__lc{6,acs24{{lcase{15916
{{iff{2,k__uc{6,acs25{{ucase{15916
{{esw{{{{end switch on keyword number{15916
{{ejc{{{{{15917
*      acess (continued)
*      lcase
{acs24{mov{7,xr{21,=lcase{{load pointer to lcase string{15924
{{brn{6,acs18{{{common return{15925
*      ucase
{acs25{mov{7,xr{21,=ucase{{load pointer to ucase string{15929
{{brn{6,acs18{{{common return{15930
*      file
{acs26{mov{8,wc{3,kvstn{{load current stmt number{15936
{{brn{6,acs28{{{merge to obtain file name{15937
*      lastfile
{acs27{mov{8,wc{3,kvlst{{load last stmt number{15941
*      merge here to map statement number in wc to file name
{acs28{jsr{6,filnm{{{obtain file name for this stmt{15945
{{brn{6,acs17{{{merge to return string in xl{15946
*      alphabet
{acs16{mov{7,xl{3,kvalp{{load pointer to alphabet string{15950
*      rtntype merges here
{acs17{mov{7,xr{7,xl{{copy string ptr to proper reg{15954
*      common return point
{acs18{exi{{{{return to acess caller{15958
*      here for stcount (ia has stlimit)
{acs19{ilt{6,acs29{{{if counting suppressed{15962
{{mov{8,wa{3,stmcs{{refine with counter start value{15963
{{sub{8,wa{3,stmct{{minus current counter{15964
{{mti{8,wa{{{convert to integer{15965
{{adi{3,kvstl{{{add stlimit{15966
{acs29{sbi{3,kvstc{{{stcount = limit - left{15967
{{brn{6,acs13{{{merge back with integer result{15968
*      errtext
{acs20{mov{7,xr{3,r_etx{{get errtext string{15972
{{brn{6,acs18{{{merge with result{15973
*      here to read a record from terminal
{acs21{mov{8,wa{18,=rilen{{buffer length{15977
{{jsr{6,alocs{{{allocate buffer{15978
{{jsr{6,sysri{{{read record{15979
{{ppm{6,acs03{{{endfile{15980
{{brn{6,acs07{{{merge with record read{15981
*      error returns
{acs22{mov{3,dnamp{7,xr{{pop unused scblk{15985
{{erb{1,202{26,input from file caused non-recoverable error{{{15986
{acs23{mov{3,dnamp{7,xr{{pop unused scblk{15988
{{erb{1,203{26,input file record has incorrect format{{{15989
{{enp{{{{end procedure acess{15990
{{ejc{{{{{15991
*      acomp -- compare two arithmetic values
*      1(xs)                 first argument
*      0(xs)                 second argument
*      jsr  acomp            call to compare values
*      ppm  loc              transfer loc if arg1 is non-numeric
*      ppm  loc              transfer loc if arg2 is non-numeric
*      ppm  loc              transfer loc for arg1 lt arg2
*      ppm  loc              transfer loc for arg1 eq arg2
*      ppm  loc              transfer loc for arg1 gt arg2
*      (normal return is never given)
*      (wa,wb,wc,ia,ra)      destroyed
*      (xl,xr)               destroyed
{acomp{prc{25,n{1,5{{entry point{16007
{{jsr{6,arith{{{load arithmetic operands{16008
{{ppm{6,acmp7{{{jump if first arg non-numeric{16009
{{ppm{6,acmp8{{{jump if second arg non-numeric{16010
{{ppm{6,acmp4{{{jump if real arguments{16013
*      here for integer arguments
{{sbi{13,icval(xl){{{subtract to compare{16018
{{iov{6,acmp3{{{jump if overflow{16019
{{ilt{6,acmp5{{{else jump if arg1 lt arg2{16020
{{ieq{6,acmp2{{{jump if arg1 eq arg2{16021
*      here if arg1 gt arg2
{acmp1{exi{1,5{{{take gt exit{16025
*      here if arg1 eq arg2
{acmp2{exi{1,4{{{take eq exit{16029
{{ejc{{{{{16030
*      acomp (continued)
*      here for integer overflow on subtract
{acmp3{ldi{13,icval(xl){{{load second argument{16036
{{ilt{6,acmp1{{{gt if negative{16037
{{brn{6,acmp5{{{else lt{16038
*      here for real operands
{acmp4{sbr{13,rcval(xl){{{subtract to compare{16044
{{rov{6,acmp6{{{jump if overflow{16045
{{rgt{6,acmp1{{{else jump if arg1 gt{16046
{{req{6,acmp2{{{jump if arg1 eq arg2{16047
*      here if arg1 lt arg2
{acmp5{exi{1,3{{{take lt exit{16052
*      here if overflow on real subtraction
{acmp6{ldr{13,rcval(xl){{{reload arg2{16058
{{rlt{6,acmp1{{{gt if negative{16059
{{brn{6,acmp5{{{else lt{16060
*      here if arg1 non-numeric
{acmp7{exi{1,1{{{take error exit{16065
*      here if arg2 non-numeric
{acmp8{exi{1,2{{{take error exit{16069
{{enp{{{{end procedure acomp{16070
{{ejc{{{{{16071
*      alloc                 allocate block of dynamic storage
*      (wa)                  length required in bytes
*      jsr  alloc            call to allocate block
*      (xr)                  pointer to allocated block
*      a possible alternative to aov ... and following stmt is -
*      mov  dname,xr .  sub  wa,xr .  blo xr,dnamp,aloc2 .
*      mov  dnamp,xr .  add  wa,xr
{alloc{prc{25,e{1,0{{entry point{16083
*      common exit point
{aloc1{mov{7,xr{3,dnamp{{point to next available loc{16087
{{aov{8,wa{7,xr{6,aloc2{point past allocated block{16088
{{bgt{7,xr{3,dname{6,aloc2{jump if not enough room{16089
{{mov{3,dnamp{7,xr{{store new pointer{16090
{{sub{7,xr{8,wa{{point back to start of allocated bk{16091
{{exi{{{{return to caller{16092
*      here if insufficient room, try a garbage collection
{aloc2{mov{3,allsv{8,wb{{save wb{16096
{alc2a{zer{8,wb{{{set no upward move for gbcol{16097
{{jsr{6,gbcol{{{garbage collect{16098
{{mov{8,wb{7,xr{{remember new sediment size{16100
*      see if room after gbcol or sysmm call
{aloc3{mov{7,xr{3,dnamp{{point to first available loc{16105
{{aov{8,wa{7,xr{6,alc3a{point past new block{16106
{{blo{7,xr{3,dname{6,aloc4{jump if there is room now{16107
*      failed again, see if we can get more core
{alc3a{jsr{6,sysmm{{{try to get more memory{16111
{{wtb{7,xr{{{convert to baus (sgd05){16112
{{add{3,dname{7,xr{{bump ptr by amount obtained{16113
{{bnz{7,xr{6,aloc3{{jump if got more core{16114
{{bze{3,dnams{6,alc3b{{jump if there was no sediment{16116
{{zer{3,dnams{{{try collecting the sediment{16117
{{brn{6,alc2a{{{{16118
*      sysmm failed and there was no sediment to collect
{alc3b{add{3,dname{3,rsmem{{get the reserve memory{16122
{{zer{3,rsmem{{{only permissible once{16126
{{icv{3,errft{{{fatal error{16127
{{erb{1,204{26,memory overflow{{{16128
{{ejc{{{{{16129
*      here after successful garbage collection
{aloc4{sti{3,allia{{{save ia{16133
{{mov{3,dnams{8,wb{{record new sediment size{16135
{{mov{8,wb{3,dname{{get dynamic end adrs{16137
{{sub{8,wb{3,dnamp{{compute free store{16138
{{btw{8,wb{{{convert bytes to words{16139
{{mti{8,wb{{{put free store in ia{16140
{{mli{3,alfsf{{{multiply by free store factor{16141
{{iov{6,aloc5{{{jump if overflowed{16142
{{mov{8,wb{3,dname{{dynamic end adrs{16143
{{sub{8,wb{3,dnamb{{compute total amount of dynamic{16144
{{btw{8,wb{{{convert to words{16145
{{mov{3,aldyn{8,wb{{store it{16146
{{sbi{3,aldyn{{{subtract from scaled up free store{16147
{{igt{6,aloc5{{{jump if sufficient free store{16148
{{jsr{6,sysmm{{{try to get more store{16149
{{wtb{7,xr{{{convert to baus (sgd05){16150
{{add{3,dname{7,xr{{adjust dynamic end adrs{16151
*      merge to restore ia and wb
{aloc5{ldi{3,allia{{{recover ia{16155
{{mov{8,wb{3,allsv{{restore wb{16156
{{brn{6,aloc1{{{jump back to exit{16157
{{enp{{{{end procedure alloc{16158
{{ejc{{{{{16159
*      alocs -- allocate string block
*      alocs is used to build a frame for a string block into
*      which the actual characters are placed by the caller.
*      all strings are created with a call to alocs (the
*      exceptions occur in trimr and s_rpl procedures).
*      (wa)                  length of string to be allocated
*      jsr  alocs            call to allocate scblk
*      (xr)                  pointer to resulting scblk
*      (wa)                  destroyed
*      (wc)                  character count (entry value of wa)
*      the resulting scblk has the type word and the length
*      filled in and the last word is cleared to zero characters
*      to ensure correct right padding of the final word.
{alocs{prc{25,e{1,0{{entry point{16219
{{bgt{8,wa{3,kvmxl{6,alcs2{jump if length exceeds maxlength{16220
{{mov{8,wc{8,wa{{else copy length{16221
{{ctb{8,wa{2,scsi_{{compute length of scblk in bytes{16222
{{mov{7,xr{3,dnamp{{point to next available location{16223
{{aov{8,wa{7,xr{6,alcs0{point past block{16224
{{blo{7,xr{3,dname{6,alcs1{jump if there is room{16225
*      insufficient memory
{alcs0{zer{7,xr{{{else clear garbage xr value{16229
{{jsr{6,alloc{{{and use standard allocator{16230
{{add{7,xr{8,wa{{point past end of block to merge{16231
*      merge here with xr pointing beyond new block
{alcs1{mov{3,dnamp{7,xr{{set updated storage pointer{16235
{{zer{11,-(xr){{{store zero chars in last word{16236
{{dca{8,wa{{{decrement length{16237
{{sub{7,xr{8,wa{{point back to start of block{16238
{{mov{9,(xr){22,=b_scl{{set type word{16239
{{mov{13,sclen(xr){8,wc{{store length in chars{16240
{{exi{{{{return to alocs caller{16241
*      come here if string is too long
{alcs2{erb{1,205{26,string length exceeds value of maxlngth keyword{{{16245
{{enp{{{{end procedure alocs{16246
{{ejc{{{{{16247
*      alost -- allocate space in static region
*      (wa)                  length required in bytes
*      jsr  alost            call to allocate space
*      (xr)                  pointer to allocated block
*      (wb)                  destroyed
*      note that the coding ensures that the resulting value
*      of state is always less than dnamb. this fact is used
*      in testing a variable name for being in the static region
{alost{prc{25,e{1,0{{entry point{16260
*      merge back here after allocating new chunk
{alst1{mov{7,xr{3,state{{point to current end of area{16264
{{aov{8,wa{7,xr{6,alst2{point beyond proposed block{16265
{{bge{7,xr{3,dnamb{6,alst2{jump if overlap with dynamic area{16266
{{mov{3,state{7,xr{{else store new pointer{16267
{{sub{7,xr{8,wa{{point back to start of block{16268
{{exi{{{{return to alost caller{16269
*      here if no room, prepare to move dynamic storage up
{alst2{mov{3,alsta{8,wa{{save wa{16273
{{bge{8,wa{19,*e_sts{6,alst3{skip if requested chunk is large{16274
{{mov{8,wa{19,*e_sts{{else set to get large enough chunk{16275
*      here with amount to move up in wa
{alst3{jsr{6,alloc{{{allocate block to ensure room{16279
{{mov{3,dnamp{7,xr{{and delete it{16280
{{mov{8,wb{8,wa{{copy move up amount{16281
{{jsr{6,gbcol{{{call gbcol to move dynamic area up{16282
{{mov{3,dnams{7,xr{{remember new sediment size{16284
{{mov{8,wa{3,alsta{{restore wa{16286
{{brn{6,alst1{{{loop back to try again{16287
{{enp{{{{end procedure alost{16288
{{ejc{{{{{16289
*      arith -- fetch arithmetic operands
*      arith is used by functions and operators which expect
*      two numeric arguments (operands) which must both be
*      integer or both be real. arith fetches two arguments from
*      the stack and performs any necessary conversions.
*      1(xs)                 first argument (left operand)
*      0(xs)                 second argument (right operand)
*      jsr  arith            call to fetch numeric arguments
*      ppm  loc              transfer loc for opnd 1 non-numeric
*      ppm  loc              transfer loc for opnd 2 non-numeric
*      ppm  loc              transfer loc for real operands
*      for integer args, control returns past the parameters
*      (ia)                  left operand value
*      (xr)                  ptr to icblk for left operand
*      (xl)                  ptr to icblk for right operand
*      (xs)                  popped twice
*      (wa,wb,ra)            destroyed
*      for real arguments, control returns to the location
*      specified by the third parameter.
*      (ra)                  left operand value
*      (xr)                  ptr to rcblk for left operand
*      (xl)                  ptr to rcblk for right operand
*      (wa,wb,wc)            destroyed
*      (xs)                  popped twice
{{ejc{{{{{16363
*      arith (continued)
*      entry point
{arith{prc{25,n{1,3{{entry point{16372
{{mov{7,xl{10,(xs)+{{load right operand{16374
{{mov{7,xr{10,(xs)+{{load left operand{16375
{{mov{8,wa{9,(xl){{get right operand type word{16376
{{beq{8,wa{22,=b_icl{6,arth1{jump if integer{16377
{{beq{8,wa{22,=b_rcl{6,arth4{jump if real{16380
{{mov{11,-(xs){7,xr{{else replace left arg on stack{16382
{{mov{7,xr{7,xl{{copy left arg pointer{16383
{{jsr{6,gtnum{{{convert to numeric{16384
{{ppm{6,arth6{{{jump if unconvertible{16385
{{mov{7,xl{7,xr{{else copy converted result{16386
{{mov{8,wa{9,(xl){{get right operand type word{16387
{{mov{7,xr{10,(xs)+{{reload left argument{16388
{{beq{8,wa{22,=b_rcl{6,arth4{jump if right arg is real{16391
*      here if right arg is an integer
{arth1{bne{9,(xr){22,=b_icl{6,arth3{jump if left arg not integer{16396
*      exit for integer case
{arth2{ldi{13,icval(xr){{{load left operand value{16400
{{exi{{{{return to arith caller{16401
*      here for right operand integer, left operand not
{arth3{jsr{6,gtnum{{{convert left arg to numeric{16405
{{ppm{6,arth7{{{jump if not convertible{16406
{{beq{8,wa{22,=b_icl{6,arth2{jump back if integer-integer{16407
*      here we must convert real-integer to real-real
{{mov{11,-(xs){7,xr{{put left arg back on stack{16413
{{ldi{13,icval(xl){{{load right argument value{16414
{{itr{{{{convert to real{16415
{{jsr{6,rcbld{{{get real block for right arg, merge{16416
{{mov{7,xl{7,xr{{copy right arg ptr{16417
{{mov{7,xr{10,(xs)+{{load left argument{16418
{{brn{6,arth5{{{merge for real-real case{16419
{{ejc{{{{{16420
*      arith (continued)
*      here if right argument is real
{arth4{beq{9,(xr){22,=b_rcl{6,arth5{jump if left arg real{16426
{{jsr{6,gtrea{{{else convert to real{16427
{{ppm{6,arth7{{{error if unconvertible{16428
*      here for real-real
{arth5{ldr{13,rcval(xr){{{load left operand value{16432
{{exi{1,3{{{take real-real exit{16433
*      here for error converting right argument
{arth6{ica{7,xs{{{pop unwanted left arg{16438
{{exi{1,2{{{take appropriate error exit{16439
*      here for error converting left operand
{arth7{exi{1,1{{{take appropriate error return{16443
{{enp{{{{end procedure arith{16444
{{ejc{{{{{16445
*      asign -- perform assignment
*      asign performs the assignment of a value to a variable
*      with appropriate checks for output associations and
*      value trace associations which are executed as required.
*      asign also handles the special cases of assignment to
*      pattern and expression variables.
*      (wb)                  value to be assigned
*      (xl)                  base pointer for variable
*      (wa)                  offset for variable
*      jsr  asign            call to assign value to variable
*      ppm  loc              transfer loc for failure
*      (xr,xl,wa,wb,wc)      destroyed
*      (ra)                  destroyed
*      failure occurs if the evaluation of an expression
*      associated with an expression variable fails.
{asign{prc{25,r{1,1{{entry point (recursive){16466
*      merge back here to assign result to expression variable.
{asg01{add{7,xl{8,wa{{point to variable value{16470
{{mov{7,xr{9,(xl){{load variable value{16471
{{beq{9,(xr){22,=b_trt{6,asg02{jump if trapped{16472
{{mov{9,(xl){8,wb{{else perform assignment{16473
{{zer{7,xl{{{clear garbage value in xl{16474
{{exi{{{{and return to asign caller{16475
*      here if value is trapped
{asg02{sub{7,xl{8,wa{{restore name base{16479
{{beq{7,xr{21,=trbkv{6,asg14{jump if keyword variable{16480
{{bne{7,xr{21,=trbev{6,asg04{jump if not expression variable{16481
*      here for assignment to expression variable
{{mov{7,xr{13,evexp(xl){{point to expression{16485
{{mov{11,-(xs){8,wb{{store value to assign on stack{16486
{{mov{8,wb{18,=num01{{set for evaluation by name{16487
{{jsr{6,evalx{{{evaluate expression by name{16488
{{ppm{6,asg03{{{jump if evaluation fails{16489
{{mov{8,wb{10,(xs)+{{else reload value to assign{16490
{{brn{6,asg01{{{loop back to perform assignment{16491
{{ejc{{{{{16492
*      asign (continued)
*      here for failure during expression evaluation
{asg03{ica{7,xs{{{remove stacked value entry{16498
{{exi{1,1{{{take failure exit{16499
*      here if not keyword or expression variable
{asg04{mov{11,-(xs){7,xr{{save ptr to first trblk{16503
*      loop to chase down trblk chain and assign value at end
{asg05{mov{8,wc{7,xr{{save ptr to this trblk{16507
{{mov{7,xr{13,trnxt(xr){{point to next trblk{16508
{{beq{9,(xr){22,=b_trt{6,asg05{loop back if another trblk{16509
{{mov{7,xr{8,wc{{else point back to last trblk{16510
{{mov{13,trval(xr){8,wb{{store value at end of chain{16511
{{mov{7,xr{10,(xs)+{{restore ptr to first trblk{16512
*      loop to process trblk entries on chain
{asg06{mov{8,wb{13,trtyp(xr){{load type code of trblk{16516
{{beq{8,wb{18,=trtvl{6,asg08{jump if value trace{16517
{{beq{8,wb{18,=trtou{6,asg10{jump if output association{16518
*      here to move to next trblk on chain
{asg07{mov{7,xr{13,trnxt(xr){{point to next trblk on chain{16522
{{beq{9,(xr){22,=b_trt{6,asg06{loop back if another trblk{16523
{{exi{{{{else end of chain, return to caller{16524
*      here to process value trace
{asg08{bze{3,kvtra{6,asg07{{ignore value trace if trace off{16528
{{dcv{3,kvtra{{{else decrement trace count{16529
{{bze{13,trfnc(xr){6,asg09{{jump if print trace{16530
{{jsr{6,trxeq{{{else execute function trace{16531
{{brn{6,asg07{{{and loop back{16532
{{ejc{{{{{16533
*      asign (continued)
*      here for print trace
{asg09{jsr{6,prtsn{{{print statement number{16539
{{jsr{6,prtnv{{{print name = value{16540
{{brn{6,asg07{{{loop back for next trblk{16541
*      here for output association
{asg10{bze{3,kvoup{6,asg07{{ignore output assoc if output off{16545
{asg1b{mov{7,xl{7,xr{{copy trblk pointer{16546
{{mov{7,xr{13,trnxt(xr){{point to next trblk{16547
{{beq{9,(xr){22,=b_trt{6,asg1b{loop back if another trblk{16548
{{mov{7,xr{7,xl{{else point back to last trblk{16549
{{mov{11,-(xs){13,trval(xr){{stack value to output{16551
{{jsr{6,gtstg{{{convert to string{16557
{{ppm{6,asg12{{{get datatype name if unconvertible{16558
*      merge with string or buffer to output in xr
{asg11{mov{8,wa{13,trfpt(xl){{fcblk ptr{16562
{{bze{8,wa{6,asg13{{jump if standard output file{16563
*      here for output to file
{asg1a{jsr{6,sysou{{{call system output routine{16567
{{err{1,206{26,output caused file overflow{{{16568
{{err{1,207{26,output caused non-recoverable error{{{16569
{{exi{{{{else all done, return to caller{16570
*      if not printable, get datatype name instead
{asg12{jsr{6,dtype{{{call datatype routine{16574
{{brn{6,asg11{{{merge{16575
*      here to print a string to standard output or terminal
{asg13{beq{13,trter(xl){21,=v_ter{6,asg1a{jump if terminal output{16580
{{icv{8,wa{{{signal standard output{16581
{{brn{6,asg1a{{{use sysou to perform output{16582
{{ejc{{{{{16597
*      asign (continued)
*      here for keyword assignment
{asg14{mov{7,xl{13,kvnum(xl){{load keyword number{16603
{{beq{7,xl{18,=k_etx{6,asg19{jump if errtext{16604
{{mov{7,xr{8,wb{{copy value to be assigned{16605
{{jsr{6,gtint{{{convert to integer{16606
{{err{1,208{26,keyword value assigned is not integer{{{16607
{{ldi{13,icval(xr){{{else load value{16608
{{beq{7,xl{18,=k_stl{6,asg16{jump if special case of stlimit{16609
{{mfi{8,wa{6,asg18{{else get addr integer, test ovflow{16610
{{bgt{8,wa{3,mxlen{6,asg18{fail if too large{16611
{{beq{7,xl{18,=k_ert{6,asg17{jump if special case of errtype{16612
{{beq{7,xl{18,=k_pfl{6,asg21{jump if special case of profile{16615
{{beq{7,xl{18,=k_mxl{6,asg24{jump if special case of maxlngth{16617
{{beq{7,xl{18,=k_fls{6,asg26{jump if special case of fullscan{16618
{{blt{7,xl{18,=k_p__{6,asg15{jump unless protected{16619
{{erb{1,209{26,keyword in assignment is protected{{{16620
*      here to do assignment if not protected
{asg15{mov{15,kvabe(xl){8,wa{{store new value{16624
{{exi{{{{return to asign caller{16625
*      here for special case of stlimit
*      since stcount is maintained as (stlimit-stcount)
*      it is also necessary to modify stcount appropriately.
{asg16{sbi{3,kvstl{{{subtract old limit{16632
{{adi{3,kvstc{{{add old counter{16633
{{sti{3,kvstc{{{store course counter value{16634
{{ldi{3,kvstl{{{check if counting suppressed{16635
{{ilt{6,asg25{{{do not refine if so{16636
{{mov{8,wa{3,stmcs{{refine with counter breakout{16637
{{sub{8,wa{3,stmct{{values{16638
{{mti{8,wa{{{convert to integer{16639
{{ngi{{{{current-start value{16640
{{adi{3,kvstc{{{add in course counter value{16641
{{sti{3,kvstc{{{save refined value{16642
{asg25{ldi{13,icval(xr){{{reload new limit value{16643
{{sti{3,kvstl{{{store new limit value{16644
{{jsr{6,stgcc{{{recompute countdown counters{16645
{{exi{{{{return to asign caller{16646
*      here for special case of errtype
{asg17{ble{8,wa{18,=nini9{6,error{ok to signal if in range{16650
*      here if value assigned is out of range
{asg18{erb{1,210{26,keyword value assigned is negative or too large{{{16654
*      here for special case of errtext
{asg19{mov{11,-(xs){8,wb{{stack value{16658
{{jsr{6,gtstg{{{convert to string{16659
{{err{1,211{26,value assigned to keyword errtext not a string{{{16660
{{mov{3,r_etx{7,xr{{make assignment{16661
{{exi{{{{return to caller{16662
*      here for keyword profile
{asg21{bgt{8,wa{18,=num02{6,asg18{moan if not 0,1, or 2{16676
{{bze{8,wa{6,asg15{{just assign if zero{16677
{{bze{3,pfdmp{6,asg22{{branch if first assignment{16678
{{beq{8,wa{3,pfdmp{6,asg23{also if same value as before{16679
{{erb{1,268{26,inconsistent value assigned to keyword profile{{{16680
{asg22{mov{3,pfdmp{8,wa{{note value on first assignment{16682
{asg23{mov{3,kvpfl{8,wa{{store new value{16683
{{jsr{6,stgcc{{{recompute countdown counts{16684
{{jsr{6,systm{{{get the time{16685
{{sti{3,pfstm{{{fudge some kind of start time{16686
{{exi{{{{return to asign caller{16687
*      here for keyword maxlngth
{asg24{bge{8,wa{18,=mnlen{6,asg15{if acceptable value{16692
{{erb{1,287{26,value assigned to keyword maxlngth is too small{{{16693
*      here for keyword fullscan
{asg26{bnz{8,wa{6,asg15{{if acceptable value{16697
{{erb{1,274{26,value assigned to keyword fullscan is zero{{{16698
{{enp{{{{end procedure asign{16700
{{ejc{{{{{16701
*      asinp -- assign during pattern match
*      asinp is like asign and has a similar calling sequence
*      and effect. the difference is that the global pattern
*      variables are saved and restored if required.
*      (xl)                  base pointer for variable
*      (wa)                  offset for variable
*      (wb)                  value to be assigned
*      jsr  asinp            call to assign value to variable
*      ppm  loc              transfer loc if failure
*      (xr,xl)               destroyed
*      (wa,wb,wc,ra)         destroyed
{asinp{prc{25,r{1,1{{entry point, recursive{16717
{{add{7,xl{8,wa{{point to variable{16718
{{mov{7,xr{9,(xl){{load current contents{16719
{{beq{9,(xr){22,=b_trt{6,asnp1{jump if trapped{16720
{{mov{9,(xl){8,wb{{else perform assignment{16721
{{zer{7,xl{{{clear garbage value in xl{16722
{{exi{{{{return to asinp caller{16723
*      here if variable is trapped
{asnp1{sub{7,xl{8,wa{{restore base pointer{16727
{{mov{11,-(xs){3,pmssl{{stack subject string length{16728
{{mov{11,-(xs){3,pmhbs{{stack history stack base ptr{16729
{{mov{11,-(xs){3,r_pms{{stack subject string pointer{16730
{{mov{11,-(xs){3,pmdfl{{stack dot flag{16731
{{jsr{6,asign{{{call full-blown assignment routine{16732
{{ppm{6,asnp2{{{jump if failure{16733
{{mov{3,pmdfl{10,(xs)+{{restore dot flag{16734
{{mov{3,r_pms{10,(xs)+{{restore subject string pointer{16735
{{mov{3,pmhbs{10,(xs)+{{restore history stack base pointer{16736
{{mov{3,pmssl{10,(xs)+{{restore subject string length{16737
{{exi{{{{return to asinp caller{16738
*      here if failure in asign call
{asnp2{mov{3,pmdfl{10,(xs)+{{restore dot flag{16742
{{mov{3,r_pms{10,(xs)+{{restore subject string pointer{16743
{{mov{3,pmhbs{10,(xs)+{{restore history stack base pointer{16744
{{mov{3,pmssl{10,(xs)+{{restore subject string length{16745
{{exi{1,1{{{take failure exit{16746
{{enp{{{{end procedure asinp{16747
{{ejc{{{{{16748
*      blkln -- determine length of block
*      blkln determines the length of a block in dynamic store.
*      (wa)                  first word of block
*      (xr)                  pointer to block
*      jsr  blkln            call to get block length
*      (wa)                  length of block in bytes
*      (xl)                  destroyed
*      blkln is used by the garbage collector and is not
*      permitted to call gbcol directly or indirectly.
*      the first word stored in the block (i.e. at xr) may
*      be anything, but the contents of wa must be correct.
{blkln{prc{25,e{1,0{{entry point{16766
{{mov{7,xl{8,wa{{copy first word{16767
{{lei{7,xl{{{get entry id (bl_xx){16768
{{bsw{7,xl{2,bl___{6,bln00{switch on block type{16769
{{iff{2,bl_ar{6,bln01{{arblk{16809
{{iff{2,bl_cd{6,bln12{{cdblk{16809
{{iff{2,bl_ex{6,bln12{{exblk{16809
{{iff{2,bl_ic{6,bln07{{icblk{16809
{{iff{2,bl_nm{6,bln03{{nmblk{16809
{{iff{2,bl_p0{6,bln02{{p0blk{16809
{{iff{2,bl_p1{6,bln03{{p1blk{16809
{{iff{2,bl_p2{6,bln04{{p2blk{16809
{{iff{2,bl_rc{6,bln09{{rcblk{16809
{{iff{2,bl_sc{6,bln10{{scblk{16809
{{iff{2,bl_se{6,bln02{{seblk{16809
{{iff{2,bl_tb{6,bln01{{tbblk{16809
{{iff{2,bl_vc{6,bln01{{vcblk{16809
{{iff{1,13{6,bln00{{{16809
{{iff{1,14{6,bln00{{{16809
{{iff{1,15{6,bln00{{{16809
{{iff{2,bl_pd{6,bln08{{pdblk{16809
{{iff{2,bl_tr{6,bln05{{trblk{16809
{{iff{1,18{6,bln00{{{16809
{{iff{1,19{6,bln00{{{16809
{{iff{1,20{6,bln00{{{16809
{{iff{2,bl_ct{6,bln06{{ctblk{16809
{{iff{2,bl_df{6,bln01{{dfblk{16809
{{iff{2,bl_ef{6,bln01{{efblk{16809
{{iff{2,bl_ev{6,bln03{{evblk{16809
{{iff{2,bl_ff{6,bln05{{ffblk{16809
{{iff{2,bl_kv{6,bln03{{kvblk{16809
{{iff{2,bl_pf{6,bln01{{pfblk{16809
{{iff{2,bl_te{6,bln04{{teblk{16809
{{esw{{{{end of jump table on block type{16809
{{ejc{{{{{16810
*      blkln (continued)
*      here for blocks with length in second word
{bln00{mov{8,wa{13,num01(xr){{load length{16816
{{exi{{{{return to blkln caller{16817
*      here for length in third word (ar,cd,df,ef,ex,pf,tb,vc)
{bln01{mov{8,wa{13,num02(xr){{load length from third word{16821
{{exi{{{{return to blkln caller{16822
*      here for two word blocks (p0,se)
{bln02{mov{8,wa{19,*num02{{load length (two words){16826
{{exi{{{{return to blkln caller{16827
*      here for three word blocks (nm,p1,ev,kv)
{bln03{mov{8,wa{19,*num03{{load length (three words){16831
{{exi{{{{return to blkln caller{16832
*      here for four word blocks (p2,te,bc)
{bln04{mov{8,wa{19,*num04{{load length (four words){16836
{{exi{{{{return to blkln caller{16837
*      here for five word blocks (ff,tr)
{bln05{mov{8,wa{19,*num05{{load length{16841
{{exi{{{{return to blkln caller{16842
{{ejc{{{{{16843
*      blkln (continued)
*      here for ctblk
{bln06{mov{8,wa{19,*ctsi_{{set size of ctblk{16849
{{exi{{{{return to blkln caller{16850
*      here for icblk
{bln07{mov{8,wa{19,*icsi_{{set size of icblk{16854
{{exi{{{{return to blkln caller{16855
*      here for pdblk
{bln08{mov{7,xl{13,pddfp(xr){{point to dfblk{16859
{{mov{8,wa{13,dfpdl(xl){{load pdblk length from dfblk{16860
{{exi{{{{return to blkln caller{16861
*      here for rcblk
{bln09{mov{8,wa{19,*rcsi_{{set size of rcblk{16867
{{exi{{{{return to blkln caller{16868
*      here for scblk
{bln10{mov{8,wa{13,sclen(xr){{load length in characters{16873
{{ctb{8,wa{2,scsi_{{calculate length in bytes{16874
{{exi{{{{return to blkln caller{16875
*      here for length in fourth word (cd,ex)
{bln12{mov{8,wa{13,num03(xr){{load length from cdlen/exlen{16889
{{exi{{{{return to blkln caller{16890
{{enp{{{{end procedure blkln{16892
{{ejc{{{{{16893
*      copyb -- copy a block
*      (xs)                  block to be copied
*      jsr  copyb            call to copy block
*      ppm  loc              return if block has no idval field
*                            normal return if idval field
*      (xr)                  copy of block
*      (xs)                  popped
*      (xl,wa,wb,wc)         destroyed
{copyb{prc{25,n{1,1{{entry point{16905
{{mov{7,xr{9,(xs){{load argument{16906
{{beq{7,xr{21,=nulls{6,cop10{return argument if it is null{16907
{{mov{8,wa{9,(xr){{else load type word{16908
{{mov{8,wb{8,wa{{copy type word{16909
{{jsr{6,blkln{{{get length of argument block{16910
{{mov{7,xl{7,xr{{copy pointer{16911
{{jsr{6,alloc{{{allocate block of same size{16912
{{mov{9,(xs){7,xr{{store pointer to copy{16913
{{mvw{{{{copy contents of old block to new{16914
{{zer{7,xl{{{clear garbage xl{16915
{{mov{7,xr{9,(xs){{reload pointer to start of copy{16916
{{beq{8,wb{22,=b_tbt{6,cop05{jump if table{16917
{{beq{8,wb{22,=b_vct{6,cop01{jump if vector{16918
{{beq{8,wb{22,=b_pdt{6,cop01{jump if program defined{16919
{{bne{8,wb{22,=b_art{6,cop10{return copy if not array{16924
*      here for array (arblk)
{{add{7,xr{13,arofs(xr){{point to prototype field{16928
{{brn{6,cop02{{{jump to merge{16929
*      here for vector, program defined
{cop01{add{7,xr{19,*pdfld{{point to pdfld = vcvls{16933
*      merge here for arblk, vcblk, pdblk to delete trap
*      blocks from all value fields (the copy is untrapped)
{cop02{mov{7,xl{9,(xr){{load next pointer{16938
*      loop to get value at end of trblk chain
{cop03{bne{9,(xl){22,=b_trt{6,cop04{jump if not trapped{16942
{{mov{7,xl{13,trval(xl){{else point to next value{16943
{{brn{6,cop03{{{and loop back{16944
{{ejc{{{{{16945
*      copyb (continued)
*      here with untrapped value in xl
{cop04{mov{10,(xr)+{7,xl{{store real value, bump pointer{16951
{{bne{7,xr{3,dnamp{6,cop02{loop back if more to go{16952
{{brn{6,cop09{{{else jump to exit{16953
*      here to copy a table
{cop05{zer{13,idval(xr){{{zero id to stop dump blowing up{16957
{{mov{8,wa{19,*tesi_{{set size of teblk{16958
{{mov{8,wc{19,*tbbuk{{set initial offset{16959
*      loop through buckets in table
{cop06{mov{7,xr{9,(xs){{load table pointer{16963
{{beq{8,wc{13,tblen(xr){6,cop09{jump to exit if all done{16964
{{mov{8,wb{8,wc{{else copy offset{16965
{{sub{8,wb{19,*tenxt{{subtract link offset to merge{16966
{{add{7,xr{8,wb{{next bucket header less link offset{16967
{{ica{8,wc{{{bump offset{16968
*      loop through teblks on one chain
{cop07{mov{7,xl{13,tenxt(xr){{load pointer to next teblk{16972
{{mov{13,tenxt(xr){9,(xs){{set end of chain pointer in case{16973
{{beq{9,(xl){22,=b_tbt{6,cop06{back for next bucket if chain end{16974
{{sub{7,xr{8,wb{{point to head of previous block{16975
{{mov{11,-(xs){7,xr{{stack ptr to previous block{16976
{{mov{8,wa{19,*tesi_{{set size of teblk{16977
{{jsr{6,alloc{{{allocate new teblk{16978
{{mov{11,-(xs){7,xr{{stack ptr to new teblk{16979
{{mvw{{{{copy old teblk to new teblk{16980
{{mov{7,xr{10,(xs)+{{restore pointer to new teblk{16981
{{mov{7,xl{10,(xs)+{{restore pointer to previous block{16982
{{add{7,xl{8,wb{{add offset back in{16983
{{mov{13,tenxt(xl){7,xr{{link new block to previous{16984
{{mov{7,xl{7,xr{{copy pointer to new block{16985
*      loop to set real value after removing trap chain
{cop08{mov{7,xl{13,teval(xl){{load value{16989
{{beq{9,(xl){22,=b_trt{6,cop08{loop back if trapped{16990
{{mov{13,teval(xr){7,xl{{store untrapped value in teblk{16991
{{zer{8,wb{{{zero offset within teblk{16992
{{brn{6,cop07{{{back for next teblk{16993
*      common exit point
{cop09{mov{7,xr{10,(xs)+{{load pointer to block{16997
{{exi{{{{return{16998
*      alternative return
{cop10{exi{1,1{{{return{17002
{{ejc{{{{{17003
{{enp{{{{end procedure copyb{17021
*      cdgcg -- generate code for complex goto
*      used by cmpil to process complex goto tree
*      (wb)                  must be collectable
*      (xr)                  expression pointer
*      jsr  cdgcg            call to generate complex goto
*      (xl,xr,wa)            destroyed
{cdgcg{prc{25,e{1,0{{entry point{17032
{{mov{7,xl{13,cmopn(xr){{get unary goto operator{17033
{{mov{7,xr{13,cmrop(xr){{point to goto operand{17034
{{beq{7,xl{21,=opdvd{6,cdgc2{jump if direct goto{17035
{{jsr{6,cdgnm{{{generate opnd by name if not direct{17036
*      return point
{cdgc1{mov{8,wa{7,xl{{goto operator{17040
{{jsr{6,cdwrd{{{generate it{17041
{{exi{{{{return to caller{17042
*      direct goto
{cdgc2{jsr{6,cdgvl{{{generate operand by value{17046
{{brn{6,cdgc1{{{merge to return{17047
{{enp{{{{end procedure cdgcg{17048
{{ejc{{{{{17049
*      cdgex -- build expression block
*      cdgex is passed a pointer to an expression tree (see
*      expan) and returns an expression (seblk or exblk).
*      (wa)                  0 if by value, 1 if by name
*      (wc)                  some collectable value
*      (wb)                  integer in range 0 le x le mxlen
*      (xl)                  ptr to expression tree
*      jsr  cdgex            call to build expression
*      (xr)                  ptr to seblk or exblk
*      (xl,wa,wb)            destroyed
{cdgex{prc{25,r{1,0{{entry point, recursive{17066
{{blo{9,(xl){22,=b_vr_{6,cdgx1{jump if not variable{17067
*      here for natural variable, build seblk
{{mov{8,wa{19,*sesi_{{set size of seblk{17071
{{jsr{6,alloc{{{allocate space for seblk{17072
{{mov{9,(xr){22,=b_sel{{set type word{17073
{{mov{13,sevar(xr){7,xl{{store vrblk pointer{17074
{{exi{{{{return to cdgex caller{17075
*      here if not variable, build exblk
{cdgx1{mov{7,xr{7,xl{{copy tree pointer{17079
{{mov{11,-(xs){8,wc{{save wc{17080
{{mov{7,xl{3,cwcof{{save current offset{17081
{{bze{8,wa{6,cdgx2{{jump if by value{17083
{{mov{8,wa{9,(xr){{get type word{17085
{{bne{8,wa{22,=b_cmt{6,cdgx2{call by value if not cmblk{17086
{{bge{13,cmtyp(xr){18,=c__nm{6,cdgx2{jump if cmblk only by value{17087
{{ejc{{{{{17088
*      cdgex (continued)
*      here if expression can be evaluated by name
{{jsr{6,cdgnm{{{generate code by name{17094
{{mov{8,wa{21,=ornm_{{load return by name word{17095
{{brn{6,cdgx3{{{merge with value case{17096
*      here if expression can only be evaluated by value
{cdgx2{jsr{6,cdgvl{{{generate code by value{17100
{{mov{8,wa{21,=orvl_{{load return by value word{17101
*      merge here to construct exblk
{cdgx3{jsr{6,cdwrd{{{generate return word{17105
{{jsr{6,exbld{{{build exblk{17106
{{mov{8,wc{10,(xs)+{{restore wc{17107
{{exi{{{{return to cdgex caller{17108
{{enp{{{{end procedure cdgex{17109
{{ejc{{{{{17110
*      cdgnm -- generate code by name
*      cdgnm is called during the compilation process to
*      generate code by name for an expression. see cdblk
*      description for details of code generated. the input
*      to cdgnm is an expression tree as generated by expan.
*      cdgnm is a recursive procedure which proceeds by making
*      recursive calls to generate code for operands.
*      (wb)                  integer in range 0 le n le dnamb
*      (xr)                  ptr to tree generated by expan
*      (wc)                  constant flag (see below)
*      jsr  cdgnm            call to generate code by name
*      (xr,wa)               destroyed
*      (wc)                  set non-zero if non-constant
*      wc is set to a non-zero (collectable) value if the
*      expression for which code is generated cannot be
*      evaluated at compile time, otherwise wc is unchanged.
*      the code is generated in the current ccblk (see cdwrd).
{cdgnm{prc{25,r{1,0{{entry point, recursive{17135
{{mov{11,-(xs){7,xl{{save entry xl{17136
{{mov{11,-(xs){8,wb{{save entry wb{17137
{{chk{{{{check for stack overflow{17138
{{mov{8,wa{9,(xr){{load type word{17139
{{beq{8,wa{22,=b_cmt{6,cgn04{jump if cmblk{17140
{{bhi{8,wa{22,=b_vr_{6,cgn02{jump if simple variable{17141
*      merge here for operand yielding value (e.g. constant)
{cgn01{erb{1,212{26,syntax error: value used where name is required{{{17145
*      here for natural variable reference
{cgn02{mov{8,wa{21,=olvn_{{load variable load call{17149
{{jsr{6,cdwrd{{{generate it{17150
{{mov{8,wa{7,xr{{copy vrblk pointer{17151
{{jsr{6,cdwrd{{{generate vrblk pointer{17152
{{ejc{{{{{17153
*      cdgnm (continued)
*      here to exit with wc set correctly
{cgn03{mov{8,wb{10,(xs)+{{restore entry wb{17159
{{mov{7,xl{10,(xs)+{{restore entry xl{17160
{{exi{{{{return to cdgnm caller{17161
*      here for cmblk
{cgn04{mov{7,xl{7,xr{{copy cmblk pointer{17165
{{mov{7,xr{13,cmtyp(xr){{load cmblk type{17166
{{bge{7,xr{18,=c__nm{6,cgn01{error if not name operand{17167
{{bsw{7,xr{2,c__nm{{else switch on type{17168
{{iff{2,c_arr{6,cgn05{{array reference{17176
{{iff{2,c_fnc{6,cgn08{{function call{17176
{{iff{2,c_def{6,cgn09{{deferred expression{17176
{{iff{2,c_ind{6,cgn10{{indirect reference{17176
{{iff{2,c_key{6,cgn11{{keyword reference{17176
{{iff{2,c_ubo{6,cgn08{{undefined binary op{17176
{{iff{2,c_uuo{6,cgn08{{undefined unary op{17176
{{esw{{{{end switch on cmblk type{17176
*      here to generate code for array reference
{cgn05{mov{8,wb{19,*cmopn{{point to array operand{17180
*      loop to generate code for array operand and subscripts
{cgn06{jsr{6,cmgen{{{generate code for next operand{17184
{{mov{8,wc{13,cmlen(xl){{load length of cmblk{17185
{{blt{8,wb{8,wc{6,cgn06{loop till all generated{17186
*      generate appropriate array call
{{mov{8,wa{21,=oaon_{{load one-subscript case call{17190
{{beq{8,wc{19,*cmar1{6,cgn07{jump to exit if one subscript case{17191
{{mov{8,wa{21,=oamn_{{else load multi-subscript case call{17192
{{jsr{6,cdwrd{{{generate call{17193
{{mov{8,wa{8,wc{{copy cmblk length{17194
{{btw{8,wa{{{convert to words{17195
{{sub{8,wa{18,=cmvls{{calculate number of subscripts{17196
{{ejc{{{{{17197
*      cdgnm (continued)
*      here to exit generating word (non-constant)
{cgn07{mnz{8,wc{{{set result non-constant{17203
{{jsr{6,cdwrd{{{generate word{17204
{{brn{6,cgn03{{{back to exit{17205
*      here to generate code for functions and undefined oprs
{cgn08{mov{7,xr{7,xl{{copy cmblk pointer{17209
{{jsr{6,cdgvl{{{gen code by value for call{17210
{{mov{8,wa{21,=ofne_{{get extra call for by name{17211
{{brn{6,cgn07{{{back to generate and exit{17212
*      here to generate code for defered expression
{cgn09{mov{7,xr{13,cmrop(xl){{check if variable{17216
{{bhi{9,(xr){22,=b_vr_{6,cgn02{treat *variable as simple var{17217
{{mov{7,xl{7,xr{{copy ptr to expression tree{17218
{{mov{8,wa{18,=num01{{return name{17220
{{jsr{6,cdgex{{{else build exblk{17222
{{mov{8,wa{21,=olex_{{set call to load expr by name{17223
{{jsr{6,cdwrd{{{generate it{17224
{{mov{8,wa{7,xr{{copy exblk pointer{17225
{{jsr{6,cdwrd{{{generate exblk pointer{17226
{{brn{6,cgn03{{{back to exit{17227
*      here to generate code for indirect reference
{cgn10{mov{7,xr{13,cmrop(xl){{get operand{17231
{{jsr{6,cdgvl{{{generate code by value for it{17232
{{mov{8,wa{21,=oinn_{{load call for indirect by name{17233
{{brn{6,cgn12{{{merge{17234
*      here to generate code for keyword reference
{cgn11{mov{7,xr{13,cmrop(xl){{get operand{17238
{{jsr{6,cdgnm{{{generate code by name for it{17239
{{mov{8,wa{21,=okwn_{{load call for keyword by name{17240
*      keyword, indirect merge here
{cgn12{jsr{6,cdwrd{{{generate code for operator{17244
{{brn{6,cgn03{{{exit{17245
{{enp{{{{end procedure cdgnm{17246
{{ejc{{{{{17247
*      cdgvl -- generate code by value
*      cdgvl is called during the compilation process to
*      generate code by value for an expression. see cdblk
*      description for details of the code generated. the input
*      to cdgvl is an expression tree as generated by expan.
*      cdgvl is a recursive procedure which proceeds by making
*      recursive calls to generate code for operands.
*      (wb)                  integer in range 0 le n le dnamb
*      (xr)                  ptr to tree generated by expan
*      (wc)                  constant flag (see below)
*      jsr  cdgvl            call to generate code by value
*      (xr,wa)               destroyed
*      (wc)                  set non-zero if non-constant
*      wc is set to a non-zero (collectable) value if the
*      expression for which code is generated cannot be
*      evaluated at compile time, otherwise wc is unchanged.
*      if wc is non-zero on entry, then preevaluation is not
*      allowed regardless of the nature of the operand.
*      the code is generated in the current ccblk (see cdwrd).
{cdgvl{prc{25,r{1,0{{entry point, recursive{17275
{{mov{8,wa{9,(xr){{load type word{17276
{{beq{8,wa{22,=b_cmt{6,cgv01{jump if cmblk{17277
{{blt{8,wa{22,=b_vra{6,cgv00{jump if icblk, rcblk, scblk{17278
{{bnz{13,vrlen(xr){6,cgvl0{{jump if not system variable{17279
{{mov{11,-(xs){7,xr{{stack xr{17280
{{mov{7,xr{13,vrsvp(xr){{point to svblk{17281
{{mov{8,wa{13,svbit(xr){{get svblk property bits{17282
{{mov{7,xr{10,(xs)+{{recover xr{17283
{{anb{8,wa{4,btkwv{{check if constant keyword value{17284
{{beq{8,wa{4,btkwv{6,cgv00{jump if constant keyword value{17285
*      here for variable value reference
{cgvl0{mnz{8,wc{{{indicate non-constant value{17289
*      merge here for simple constant (icblk,rcblk,scblk)
*      and for variables corresponding to constant keywords.
{cgv00{mov{8,wa{7,xr{{copy ptr to var or constant{17294
{{jsr{6,cdwrd{{{generate as code word{17295
{{exi{{{{return to caller{17296
{{ejc{{{{{17297
*      cdgvl (continued)
*      here for tree node (cmblk)
{cgv01{mov{11,-(xs){8,wb{{save entry wb{17303
{{mov{11,-(xs){7,xl{{save entry xl{17304
{{mov{11,-(xs){8,wc{{save entry constant flag{17305
{{mov{11,-(xs){3,cwcof{{save initial code offset{17306
{{chk{{{{check for stack overflow{17307
*      prepare to generate code for cmblk. wc is set to the
*      value of cswno (zero if -optimise, 1 if -noopt) to
*      start with and is reset non-zero for any non-constant
*      code generated. if it is still zero after generating all
*      the cmblk code, then its value is computed as the result.
{{mov{7,xl{7,xr{{copy cmblk pointer{17315
{{mov{7,xr{13,cmtyp(xr){{load cmblk type{17316
{{mov{8,wc{3,cswno{{reset constant flag{17317
{{ble{7,xr{18,=c_pr_{6,cgv02{jump if not predicate value{17318
{{mnz{8,wc{{{else force non-constant case{17319
*      here with wc set appropriately
{cgv02{bsw{7,xr{2,c__nv{{switch to appropriate generator{17323
{{iff{2,c_arr{6,cgv03{{array reference{17343
{{iff{2,c_fnc{6,cgv05{{function call{17343
{{iff{2,c_def{6,cgv14{{deferred expression{17343
{{iff{2,c_ind{6,cgv31{{indirect reference{17343
{{iff{2,c_key{6,cgv27{{keyword reference{17343
{{iff{2,c_ubo{6,cgv29{{undefined binop{17343
{{iff{2,c_uuo{6,cgv30{{undefined unop{17343
{{iff{2,c_bvl{6,cgv18{{binops with val opds{17343
{{iff{2,c_uvl{6,cgv19{{unops with valu opnd{17343
{{iff{2,c_alt{6,cgv18{{alternation{17343
{{iff{2,c_cnc{6,cgv24{{concatenation{17343
{{iff{2,c_cnp{6,cgv24{{concatenation (not pattern match){17343
{{iff{2,c_unm{6,cgv27{{unops with name opnd{17343
{{iff{2,c_bvn{6,cgv26{{binary _ and .{17343
{{iff{2,c_ass{6,cgv21{{assignment{17343
{{iff{2,c_int{6,cgv31{{interrogation{17343
{{iff{2,c_neg{6,cgv28{{negation{17343
{{iff{2,c_sel{6,cgv15{{selection{17343
{{iff{2,c_pmt{6,cgv18{{pattern match{17343
{{esw{{{{end switch on cmblk type{17343
{{ejc{{{{{17344
*      cdgvl (continued)
*      here to generate code for array reference
{cgv03{mov{8,wb{19,*cmopn{{set offset to array operand{17350
*      loop to generate code for array operand and subscripts
{cgv04{jsr{6,cmgen{{{gen value code for next operand{17354
{{mov{8,wc{13,cmlen(xl){{load cmblk length{17355
{{blt{8,wb{8,wc{6,cgv04{loop back if more to go{17356
*      generate call to appropriate array reference routine
{{mov{8,wa{21,=oaov_{{set one subscript call in case{17360
{{beq{8,wc{19,*cmar1{6,cgv32{jump to exit if 1-sub case{17361
{{mov{8,wa{21,=oamv_{{else set call for multi-subscripts{17362
{{jsr{6,cdwrd{{{generate call{17363
{{mov{8,wa{8,wc{{copy length of cmblk{17364
{{sub{8,wa{19,*cmvls{{subtract standard length{17365
{{btw{8,wa{{{get number of words{17366
{{brn{6,cgv32{{{jump to generate subscript count{17367
*      here to generate code for function call
{cgv05{mov{8,wb{19,*cmvls{{set offset to first argument{17371
*      loop to generate code for arguments
{cgv06{beq{8,wb{13,cmlen(xl){6,cgv07{jump if all generated{17375
{{jsr{6,cmgen{{{else gen value code for next arg{17376
{{brn{6,cgv06{{{back to generate next argument{17377
*      here to generate actual function call
{cgv07{sub{8,wb{19,*cmvls{{get number of arg ptrs (bytes){17381
{{btw{8,wb{{{convert bytes to words{17382
{{mov{7,xr{13,cmopn(xl){{load function vrblk pointer{17383
{{bnz{13,vrlen(xr){6,cgv12{{jump if not system function{17384
{{mov{7,xl{13,vrsvp(xr){{load svblk ptr if system var{17385
{{mov{8,wa{13,svbit(xl){{load bit mask{17386
{{anb{8,wa{4,btffc{{test for fast function call allowed{17387
{{zrb{8,wa{6,cgv12{{jump if not{17388
{{ejc{{{{{17389
*      cdgvl (continued)
*      here if fast function call is allowed
{{mov{8,wa{13,svbit(xl){{reload bit indicators{17395
{{anb{8,wa{4,btpre{{test for preevaluation ok{17396
{{nzb{8,wa{6,cgv08{{jump if preevaluation permitted{17397
{{mnz{8,wc{{{else set result non-constant{17398
*      test for correct number of args for fast call
{cgv08{mov{7,xl{13,vrfnc(xr){{load ptr to svfnc field{17402
{{mov{8,wa{13,fargs(xl){{load svnar field value{17403
{{beq{8,wa{8,wb{6,cgv11{jump if argument count is correct{17404
{{bhi{8,wa{8,wb{6,cgv09{jump if too few arguments given{17405
*      here if too many arguments, prepare to generate o_pops
{{sub{8,wb{8,wa{{get number of extra args{17409
{{lct{8,wb{8,wb{{set as count to control loop{17410
{{mov{8,wa{21,=opop_{{set pop call{17411
{{brn{6,cgv10{{{jump to common loop{17412
*      here if too few arguments, prepare to generate nulls
{cgv09{sub{8,wa{8,wb{{get number of missing arguments{17416
{{lct{8,wb{8,wa{{load as count to control loop{17417
{{mov{8,wa{21,=nulls{{load ptr to null constant{17418
*      loop to generate calls to fix argument count
{cgv10{jsr{6,cdwrd{{{generate one call{17422
{{bct{8,wb{6,cgv10{{loop till all generated{17423
*      here after adjusting arg count as required
{cgv11{mov{8,wa{7,xl{{copy pointer to svfnc field{17427
{{brn{6,cgv36{{{jump to generate call{17428
{{ejc{{{{{17429
*      cdgvl (continued)
*      come here if fast call is not permitted
{cgv12{mov{8,wa{21,=ofns_{{set one arg call in case{17435
{{beq{8,wb{18,=num01{6,cgv13{jump if one arg case{17436
{{mov{8,wa{21,=ofnc_{{else load call for more than 1 arg{17437
{{jsr{6,cdwrd{{{generate it{17438
{{mov{8,wa{8,wb{{copy argument count{17439
*      one arg case merges here
{cgv13{jsr{6,cdwrd{{{generate =o_fns or arg count{17443
{{mov{8,wa{7,xr{{copy vrblk pointer{17444
{{brn{6,cgv32{{{jump to generate vrblk ptr{17445
*      here for deferred expression
{cgv14{mov{7,xl{13,cmrop(xl){{point to expression tree{17449
{{zer{8,wa{{{return value{17451
{{jsr{6,cdgex{{{build exblk or seblk{17453
{{mov{8,wa{7,xr{{copy block ptr{17454
{{jsr{6,cdwrd{{{generate ptr to exblk or seblk{17455
{{brn{6,cgv34{{{jump to exit, constant test{17456
*      here to generate code for selection
{cgv15{zer{11,-(xs){{{zero ptr to chain of forward jumps{17460
{{zer{11,-(xs){{{zero ptr to prev o_slc forward ptr{17461
{{mov{8,wb{19,*cmvls{{point to first alternative{17462
{{mov{8,wa{21,=osla_{{set initial code word{17463
*      0(xs)                 is the offset to the previous word
*                            which requires filling in with an
*                            offset to the following o_slc,o_sld
*      1(xs)                 is the head of a chain of offset
*                            pointers indicating those locations
*                            to be filled with offsets past
*                            the end of all the alternatives
{cgv16{jsr{6,cdwrd{{{generate o_slc (o_sla first time){17474
{{mov{9,(xs){3,cwcof{{set current loc as ptr to fill in{17475
{{jsr{6,cdwrd{{{generate garbage word there for now{17476
{{jsr{6,cmgen{{{gen value code for alternative{17477
{{mov{8,wa{21,=oslb_{{load o_slb pointer{17478
{{jsr{6,cdwrd{{{generate o_slb call{17479
{{mov{8,wa{13,num01(xs){{load old chain ptr{17480
{{mov{13,num01(xs){3,cwcof{{set current loc as new chain head{17481
{{jsr{6,cdwrd{{{generate forward chain link{17482
{{ejc{{{{{17483
*      cdgvl (continued)
*      now to fill in the skip offset to o_slc,o_sld
{{mov{7,xr{9,(xs){{load offset to word to plug{17489
{{add{7,xr{3,r_ccb{{point to actual location to plug{17490
{{mov{9,(xr){3,cwcof{{plug proper offset in{17491
{{mov{8,wa{21,=oslc_{{load o_slc ptr for next alternative{17492
{{mov{7,xr{8,wb{{copy offset (destroy garbage xr){17493
{{ica{7,xr{{{bump extra time for test{17494
{{blt{7,xr{13,cmlen(xl){6,cgv16{loop back if not last alternative{17495
*      here to generate code for last alternative
{{mov{8,wa{21,=osld_{{get header call{17499
{{jsr{6,cdwrd{{{generate o_sld call{17500
{{jsr{6,cmgen{{{generate code for last alternative{17501
{{ica{7,xs{{{pop offset ptr{17502
{{mov{7,xr{10,(xs)+{{load chain ptr{17503
*      loop to plug offsets past structure
{cgv17{add{7,xr{3,r_ccb{{make next ptr absolute{17507
{{mov{8,wa{9,(xr){{load forward ptr{17508
{{mov{9,(xr){3,cwcof{{plug required offset{17509
{{mov{7,xr{8,wa{{copy forward ptr{17510
{{bnz{8,wa{6,cgv17{{loop back if more to go{17511
{{brn{6,cgv33{{{else jump to exit (not constant){17512
*      here for binary ops with value operands
{cgv18{mov{7,xr{13,cmlop(xl){{load left operand pointer{17516
{{jsr{6,cdgvl{{{gen value code for left operand{17517
*      here for unary ops with value operand (binops merge)
{cgv19{mov{7,xr{13,cmrop(xl){{load right (only) operand ptr{17521
{{jsr{6,cdgvl{{{gen code by value{17522
{{ejc{{{{{17523
*      cdgvl (continued)
*      merge here to generate operator call from cmopn field
{cgv20{mov{8,wa{13,cmopn(xl){{load operator call pointer{17529
{{brn{6,cgv36{{{jump to generate it with cons test{17530
*      here for assignment
{cgv21{mov{7,xr{13,cmlop(xl){{load left operand pointer{17534
{{blo{9,(xr){22,=b_vr_{6,cgv22{jump if not variable{17535
*      here for assignment to simple variable
{{mov{7,xr{13,cmrop(xl){{load right operand ptr{17539
{{jsr{6,cdgvl{{{generate code by value{17540
{{mov{8,wa{13,cmlop(xl){{reload left operand vrblk ptr{17541
{{add{8,wa{19,*vrsto{{point to vrsto field{17542
{{brn{6,cgv32{{{jump to generate store ptr{17543
*      here if not simple variable assignment
{cgv22{jsr{6,expap{{{test for pattern match on left side{17547
{{ppm{6,cgv23{{{jump if not pattern match{17548
*      here for pattern replacement
{{mov{13,cmlop(xl){13,cmrop(xr){{save pattern ptr in safe place{17552
{{mov{7,xr{13,cmlop(xr){{load subject ptr{17553
{{jsr{6,cdgnm{{{gen code by name for subject{17554
{{mov{7,xr{13,cmlop(xl){{load pattern ptr{17555
{{jsr{6,cdgvl{{{gen code by value for pattern{17556
{{mov{8,wa{21,=opmn_{{load match by name call{17557
{{jsr{6,cdwrd{{{generate it{17558
{{mov{7,xr{13,cmrop(xl){{load replacement value ptr{17559
{{jsr{6,cdgvl{{{gen code by value{17560
{{mov{8,wa{21,=orpl_{{load replace call{17561
{{brn{6,cgv32{{{jump to gen and exit (not constant){17562
*      here for assignment to complex variable
{cgv23{mnz{8,wc{{{inhibit pre-evaluation{17566
{{jsr{6,cdgnm{{{gen code by name for left side{17567
{{brn{6,cgv31{{{merge with unop circuit{17568
{{ejc{{{{{17569
*      cdgvl (continued)
*      here for concatenation
{cgv24{mov{7,xr{13,cmlop(xl){{load left operand ptr{17575
{{bne{9,(xr){22,=b_cmt{6,cgv18{ordinary binop if not cmblk{17576
{{mov{8,wb{13,cmtyp(xr){{load cmblk type code{17577
{{beq{8,wb{18,=c_int{6,cgv25{special case if interrogation{17578
{{beq{8,wb{18,=c_neg{6,cgv25{or negation{17579
{{bne{8,wb{18,=c_fnc{6,cgv18{else ordinary binop if not function{17580
{{mov{7,xr{13,cmopn(xr){{else load function vrblk ptr{17581
{{bnz{13,vrlen(xr){6,cgv18{{ordinary binop if not system var{17582
{{mov{7,xr{13,vrsvp(xr){{else point to svblk{17583
{{mov{8,wa{13,svbit(xr){{load bit indicators{17584
{{anb{8,wa{4,btprd{{test for predicate function{17585
{{zrb{8,wa{6,cgv18{{ordinary binop if not{17586
*      here if left arg of concatenation is predicate function
{cgv25{mov{7,xr{13,cmlop(xl){{reload left arg{17590
{{jsr{6,cdgvl{{{gen code by value{17591
{{mov{8,wa{21,=opop_{{load pop call{17592
{{jsr{6,cdwrd{{{generate it{17593
{{mov{7,xr{13,cmrop(xl){{load right operand{17594
{{jsr{6,cdgvl{{{gen code by value as result code{17595
{{brn{6,cgv33{{{exit (not constant){17596
*      here to generate code for pattern, immediate assignment
{cgv26{mov{7,xr{13,cmlop(xl){{load left operand{17600
{{jsr{6,cdgvl{{{gen code by value, merge{17601
*      here for unops with arg by name (binary _ . merge)
{cgv27{mov{7,xr{13,cmrop(xl){{load right operand ptr{17605
{{jsr{6,cdgnm{{{gen code by name for right arg{17606
{{mov{7,xr{13,cmopn(xl){{get operator code word{17607
{{bne{9,(xr){22,=o_kwv{6,cgv20{gen call unless keyword value{17608
{{ejc{{{{{17609
*      cdgvl (continued)
*      here for keyword by value. this is constant only if
*      the operand is one of the special system variables with
*      the svckw bit set to indicate a constant keyword value.
*      note that the only constant operand by name is a variable
{{bnz{8,wc{6,cgv20{{gen call if non-constant (not var){17618
{{mnz{8,wc{{{else set non-constant in case{17619
{{mov{7,xr{13,cmrop(xl){{load ptr to operand vrblk{17620
{{bnz{13,vrlen(xr){6,cgv20{{gen (non-constant) if not sys var{17621
{{mov{7,xr{13,vrsvp(xr){{else load ptr to svblk{17622
{{mov{8,wa{13,svbit(xr){{load bit mask{17623
{{anb{8,wa{4,btckw{{test for constant keyword{17624
{{zrb{8,wa{6,cgv20{{go gen if not constant{17625
{{zer{8,wc{{{else set result constant{17626
{{brn{6,cgv20{{{and jump back to generate call{17627
*      here to generate code for negation
{cgv28{mov{8,wa{21,=onta_{{get initial word{17631
{{jsr{6,cdwrd{{{generate it{17632
{{mov{8,wb{3,cwcof{{save next offset{17633
{{jsr{6,cdwrd{{{generate gunk word for now{17634
{{mov{7,xr{13,cmrop(xl){{load right operand ptr{17635
{{jsr{6,cdgvl{{{gen code by value{17636
{{mov{8,wa{21,=ontb_{{load end of evaluation call{17637
{{jsr{6,cdwrd{{{generate it{17638
{{mov{7,xr{8,wb{{copy offset to word to plug{17639
{{add{7,xr{3,r_ccb{{point to actual word to plug{17640
{{mov{9,(xr){3,cwcof{{plug word with current offset{17641
{{mov{8,wa{21,=ontc_{{load final call{17642
{{brn{6,cgv32{{{jump to generate it (not constant){17643
*      here to generate code for undefined binary operator
{cgv29{mov{7,xr{13,cmlop(xl){{load left operand ptr{17647
{{jsr{6,cdgvl{{{generate code by value{17648
{{ejc{{{{{17649
*      cdgvl (continued)
*      here to generate code for undefined unary operator
{cgv30{mov{8,wb{18,=c_uo_{{set unop code + 1{17655
{{sub{8,wb{13,cmtyp(xl){{set number of args (1 or 2){17656
*      merge here for undefined operators
{{mov{7,xr{13,cmrop(xl){{load right (only) operand pointer{17660
{{jsr{6,cdgvl{{{gen value code for right operand{17661
{{mov{7,xr{13,cmopn(xl){{load pointer to operator dv{17662
{{mov{7,xr{13,dvopn(xr){{load pointer offset{17663
{{wtb{7,xr{{{convert word offset to bytes{17664
{{add{7,xr{20,=r_uba{{point to proper function ptr{17665
{{sub{7,xr{19,*vrfnc{{set standard function offset{17666
{{brn{6,cgv12{{{merge with function call circuit{17667
*      here to generate code for interrogation, indirection
{cgv31{mnz{8,wc{{{set non constant{17671
{{brn{6,cgv19{{{merge{17672
*      here to exit generating a word, result not constant
{cgv32{jsr{6,cdwrd{{{generate word, merge{17676
*      here to exit with no word generated, not constant
{cgv33{mnz{8,wc{{{indicate result is not constant{17680
*      common exit point
{cgv34{ica{7,xs{{{pop initial code offset{17684
{{mov{8,wa{10,(xs)+{{restore old constant flag{17685
{{mov{7,xl{10,(xs)+{{restore entry xl{17686
{{mov{8,wb{10,(xs)+{{restore entry wb{17687
{{bnz{8,wc{6,cgv35{{jump if not constant{17688
{{mov{8,wc{8,wa{{else restore entry constant flag{17689
*      here to return after dealing with wc setting
{cgv35{exi{{{{return to cdgvl caller{17693
*      exit here to generate word and test for constant
{cgv36{jsr{6,cdwrd{{{generate word{17697
{{bnz{8,wc{6,cgv34{{jump to exit if not constant{17698
{{ejc{{{{{17699
*      cdgvl (continued)
*      here to preevaluate constant sub-expression
{{mov{8,wa{21,=orvl_{{load call to return value{17705
{{jsr{6,cdwrd{{{generate it{17706
{{mov{7,xl{9,(xs){{load initial code offset{17707
{{jsr{6,exbld{{{build exblk for expression{17708
{{zer{8,wb{{{set to evaluate by value{17709
{{jsr{6,evalx{{{evaluate expression{17710
{{ppm{{{{should not fail{17711
{{mov{8,wa{9,(xr){{load type word of result{17712
{{blo{8,wa{22,=p_aaa{6,cgv37{jump if not pattern{17713
{{mov{8,wa{21,=olpt_{{else load special pattern load call{17714
{{jsr{6,cdwrd{{{generate it{17715
*      merge here to generate pointer to resulting constant
{cgv37{mov{8,wa{7,xr{{copy constant pointer{17719
{{jsr{6,cdwrd{{{generate ptr{17720
{{zer{8,wc{{{set result constant{17721
{{brn{6,cgv34{{{jump back to exit{17722
{{enp{{{{end procedure cdgvl{17723
{{ejc{{{{{17724
*      cdwrd -- generate one word of code
*      cdwrd writes one word into the current code block under
*      construction. a new, larger, block is allocated if there
*      is insufficient room in the current block. cdwrd ensures
*      that there are at least four words left in the block
*      after entering the new word. this guarantees that any
*      extra space at the end can be split off as a ccblk.
*      (wa)                  word to be generated
*      jsr  cdwrd            call to generate word
{cdwrd{prc{25,e{1,0{{entry point{17742
{{mov{11,-(xs){7,xr{{save entry xr{17743
{{mov{11,-(xs){8,wa{{save code word to be generated{17744
*      merge back here after allocating larger block
{cdwd1{mov{7,xr{3,r_ccb{{load ptr to ccblk being built{17748
{{bnz{7,xr{6,cdwd2{{jump if block allocated{17749
*      here we allocate an entirely fresh block
{{mov{8,wa{19,*e_cbs{{load initial length{17753
{{jsr{6,alloc{{{allocate ccblk{17754
{{mov{9,(xr){22,=b_cct{{store type word{17755
{{mov{3,cwcof{19,*cccod{{set initial offset{17756
{{mov{13,cclen(xr){8,wa{{store block length{17757
{{zer{13,ccsln(xr){{{zero line number{17759
{{mov{3,r_ccb{7,xr{{store ptr to new block{17761
*      here we have a block we can use
{cdwd2{mov{8,wa{3,cwcof{{load current offset{17765
{{add{8,wa{19,*num05{{adjust for test (five words){17767
{{blo{8,wa{13,cclen(xr){6,cdwd4{jump if room in this block{17771
*      here if no room in current block
{{bge{8,wa{3,mxlen{6,cdwd5{jump if already at max size{17775
{{add{8,wa{19,*e_cbs{{else get new size{17776
{{mov{11,-(xs){7,xl{{save entry xl{17777
{{mov{7,xl{7,xr{{copy pointer{17778
{{blt{8,wa{3,mxlen{6,cdwd3{jump if not too large{17779
{{mov{8,wa{3,mxlen{{else reset to max allowed size{17780
{{ejc{{{{{17781
*      cdwrd (continued)
*      here with new block size in wa
{cdwd3{jsr{6,alloc{{{allocate new block{17787
{{mov{3,r_ccb{7,xr{{store pointer to new block{17788
{{mov{10,(xr)+{22,=b_cct{{store type word in new block{17789
{{mov{10,(xr)+{8,wa{{store block length{17790
{{mov{10,(xr)+{13,ccsln(xl){{copy source line number word{17792
{{add{7,xl{19,*ccuse{{point to ccuse,cccod fields in old{17794
{{mov{8,wa{9,(xl){{load ccuse value{17795
{{mvw{{{{copy useful words from old block{17796
{{mov{7,xl{10,(xs)+{{restore xl{17797
{{brn{6,cdwd1{{{merge back to try again{17798
*      here with room in current block
{cdwd4{mov{8,wa{3,cwcof{{load current offset{17802
{{ica{8,wa{{{get new offset{17803
{{mov{3,cwcof{8,wa{{store new offset{17804
{{mov{13,ccuse(xr){8,wa{{store in ccblk for gbcol{17805
{{dca{8,wa{{{restore ptr to this word{17806
{{add{7,xr{8,wa{{point to current entry{17807
{{mov{8,wa{10,(xs)+{{reload word to generate{17808
{{mov{9,(xr){8,wa{{store word in block{17809
{{mov{7,xr{10,(xs)+{{restore entry xr{17810
{{exi{{{{return to caller{17811
*      here if compiled code is too long for cdblk
{cdwd5{erb{1,213{26,syntax error: statement is too complicated.{{{17815
{{enp{{{{end procedure cdwrd{17816
{{ejc{{{{{17817
*      cmgen -- generate code for cmblk ptr
*      cmgen is a subsidiary procedure used to generate value
*      code for a cmblk ptr from the main code generators.
*      (xl)                  cmblk pointer
*      (wb)                  offset to pointer in cmblk
*      jsr  cmgen            call to generate code
*      (xr,wa)               destroyed
*      (wb)                  bumped by one word
{cmgen{prc{25,r{1,0{{entry point, recursive{17830
{{mov{7,xr{7,xl{{copy cmblk pointer{17831
{{add{7,xr{8,wb{{point to cmblk pointer{17832
{{mov{7,xr{9,(xr){{load cmblk pointer{17833
{{jsr{6,cdgvl{{{generate code by value{17834
{{ica{8,wb{{{bump offset{17835
{{exi{{{{return to caller{17836
{{enp{{{{end procedure cmgen{17837
{{ejc{{{{{17838
*      cmpil (compile source code)
*      cmpil is used to convert snobol4 source code to internal
*      form (see cdblk format). it is used both for the initial
*      compile and at run time by the code and convert functions
*      this procedure has control for the entire duration of
*      initial compilation. an error in any procedure called
*      during compilation will lead first to the error section
*      and ultimately back here for resumed compilation. the
*      re-entry points after an error are specially labelled -
*      cmpce                 resume after control card error
*      cmple                 resume after label error
*      cmpse                 resume after statement error
*      jsr  cmpil            call to compile code
*      (xr)                  ptr to cdblk for entry statement
*      (xl,wa,wb,wc,ra)      destroyed
*      the following global variables are referenced
*      cmpln                 line number of first line of
*                            statement to be compiled
*      cmpsn                 number of next statement
*                            to be compiled.
*      cswxx                 control card switch values are
*                            changed when relevant control
*                            cards are met.
*      cwcof                 offset to next word in code block
*                            being built (see cdwrd).
*      lstsn                 number of statement most recently
*                            compiled (initially set to zero).
*      r_cim                 current (initial) compiler image
*                            (zero for initial compile call)
*      r_cni                 used to point to following image.
*                            (see readr procedure).
*      scngo                 goto switch for scane procedure
*      scnil                 length of current image excluding
*                            characters removed by -input.
*      scnpt                 current scan offset, see scane.
*      scnrs                 rescan switch for scane procedure.
*      scnse                 offset (in r_cim) of most recently
*                            scanned element. set zero if not
*                            currently scanning items
{{ejc{{{{{17895
*      cmpil (continued)
*      stage               stgic  initial compile in progress
*                          stgxc  code/convert compile
*                          stgev  building exblk for eval
*                          stgxt  execute time (outside compile)
*                          stgce  initial compile after end line
*                          stgxe  execute compile after end line
*      cmpil also uses a fixed number of locations on the
*      main stack as follows. (the definitions of the actual
*      offsets are in the definitions section).
*      cmstm(xs)             pointer to expan tree for body of
*                            statement (see expan procedure).
*      cmsgo(xs)             pointer to tree representation of
*                            success goto (see procedure scngo)
*                            zero if no success goto is given
*      cmfgo(xs)             like cmsgo for failure goto.
*      cmcgo(xs)             set non-zero only if there is a
*                            conditional goto. used for -fail,
*                            -nofail code generation.
*      cmpcd(xs)             pointer to cdblk for previous
*                            statement. zero for 1st statement.
*      cmffp(xs)             set non-zero if cdfal in previous
*                            cdblk needs filling with forward
*                            pointer, else set to zero.
*      cmffc(xs)             same as cmffp for current cdblk
*      cmsop(xs)             offset to word in previous cdblk
*                            to be filled in with forward ptr
*                            to next cdblk for success goto.
*                            zero if no fill in is required.
*      cmsoc(xs)             same as cmsop for current cdblk.
*      cmlbl(xs)             pointer to vrblk for label of
*                            current statement. zero if no label
*      cmtra(xs)             pointer to cdblk for entry stmnt.
{{ejc{{{{{17943
*      cmpil (continued)
*      entry point
{cmpil{prc{25,e{1,0{{entry point{17949
{{lct{8,wb{18,=cmnen{{set number of stack work locations{17950
*      loop to initialize stack working locations
{cmp00{zer{11,-(xs){{{store a zero, make one entry{17954
{{bct{8,wb{6,cmp00{{loop back until all set{17955
{{mov{3,cmpxs{7,xs{{save stack pointer for error sec{17956
{{sss{3,cmpss{{{save s-r stack pointer if any{17957
*      loop through statements
{cmp01{mov{8,wb{3,scnpt{{set scan pointer offset{17961
{{mov{3,scnse{8,wb{{set start of element location{17962
{{mov{8,wa{21,=ocer_{{point to compile error call{17963
{{jsr{6,cdwrd{{{generate as temporary cdfal{17964
{{blt{8,wb{3,scnil{6,cmp04{jump if chars left on this image{17965
*      loop here after comment or control card
*      also special entry after control card error
{cmpce{zer{7,xr{{{clear possible garbage xr value{17970
{{bnz{3,cnind{6,cmpc2{{if within include file{17972
{{bne{3,stage{18,=stgic{6,cmp02{skip unless initial compile{17974
{cmpc2{jsr{6,readr{{{read next input image{17975
{{bze{7,xr{6,cmp09{{jump if no input available{17976
{{jsr{6,nexts{{{acquire next source image{17977
{{mov{3,lstsn{3,cmpsn{{store stmt no for use by listr{17978
{{mov{3,cmpln{3,rdcln{{store line number at start of stmt{17979
{{zer{3,scnpt{{{reset scan pointer{17980
{{brn{6,cmp04{{{go process image{17981
*      for execute time compile, permit embedded control cards
*      and comments (by skipping to next semi-colon)
{cmp02{mov{7,xr{3,r_cim{{get current image{17986
{{mov{8,wb{3,scnpt{{get current offset{17987
{{plc{7,xr{8,wb{{prepare to get chars{17988
*      skip to semi-colon
{cmp03{bge{3,scnpt{3,scnil{6,cmp09{end loop if end of image{17992
{{lch{8,wc{10,(xr)+{{get char{17993
{{icv{3,scnpt{{{advance offset{17994
{{bne{8,wc{18,=ch_sm{6,cmp03{loop if not semi-colon{17995
{{ejc{{{{{17996
*      cmpil (continued)
*      here with image available to scan. note that if the input
*      string is null, then everything is ok since null is
*      actually assembled as a word of blanks.
{cmp04{mov{7,xr{3,r_cim{{point to current image{18004
{{mov{8,wb{3,scnpt{{load current offset{18005
{{mov{8,wa{8,wb{{copy for label scan{18006
{{plc{7,xr{8,wb{{point to first character{18007
{{lch{8,wc{10,(xr)+{{load first character{18008
{{beq{8,wc{18,=ch_sm{6,cmp12{no label if semicolon{18009
{{beq{8,wc{18,=ch_as{6,cmpce{loop back if comment card{18010
{{beq{8,wc{18,=ch_mn{6,cmp32{jump if control card{18011
{{mov{3,r_cmp{3,r_cim{{about to destroy r_cim{18012
{{mov{7,xl{20,=cmlab{{point to label work string{18013
{{mov{3,r_cim{7,xl{{scane is to scan work string{18014
{{psc{7,xl{{{point to first character position{18015
{{sch{8,wc{10,(xl)+{{store char just loaded{18016
{{mov{8,wc{18,=ch_sm{{get a semicolon{18017
{{sch{8,wc{9,(xl){{store after first char{18018
{{csc{7,xl{{{finished character storing{18019
{{zer{7,xl{{{clear pointer{18020
{{zer{3,scnpt{{{start at first character{18021
{{mov{11,-(xs){3,scnil{{preserve image length{18022
{{mov{3,scnil{18,=num02{{read 2 chars at most{18023
{{jsr{6,scane{{{scan first char for type{18024
{{mov{3,scnil{10,(xs)+{{restore image length{18025
{{mov{8,wc{7,xl{{note return code{18026
{{mov{7,xl{3,r_cmp{{get old r_cim{18027
{{mov{3,r_cim{7,xl{{put it back{18028
{{mov{3,scnpt{8,wb{{reinstate offset{18029
{{bnz{3,scnbl{6,cmp12{{blank seen - cant be label{18030
{{mov{7,xr{7,xl{{point to current image{18031
{{plc{7,xr{8,wb{{point to first char again{18032
{{beq{8,wc{18,=t_var{6,cmp06{ok if letter{18033
{{beq{8,wc{18,=t_con{6,cmp06{ok if digit{18034
*      drop in or jump from error section if scane failed
{cmple{mov{3,r_cim{3,r_cmp{{point to bad line{18038
{{erb{1,214{26,bad label or misplaced continuation line{{{18039
*      loop to scan label
{cmp05{beq{8,wc{18,=ch_sm{6,cmp07{skip if semicolon{18043
{{icv{8,wa{{{bump offset{18044
{{beq{8,wa{3,scnil{6,cmp07{jump if end of image (label end){18045
{{ejc{{{{{18046
*      cmpil (continued)
*      enter loop at this point
{cmp06{lch{8,wc{10,(xr)+{{else load next character{18052
{{beq{8,wc{18,=ch_ht{6,cmp07{jump if horizontal tab{18054
{{bne{8,wc{18,=ch_bl{6,cmp05{loop back if non-blank{18059
*      here after scanning out label
{cmp07{mov{3,scnpt{8,wa{{save updated scan offset{18063
{{sub{8,wa{8,wb{{get length of label{18064
{{bze{8,wa{6,cmp12{{skip if label length zero{18065
{{zer{7,xr{{{clear garbage xr value{18066
{{jsr{6,sbstr{{{build scblk for label name{18067
{{jsr{6,gtnvr{{{locate/contruct vrblk{18068
{{ppm{{{{dummy (impossible) error return{18069
{{mov{13,cmlbl(xs){7,xr{{store label pointer{18070
{{bnz{13,vrlen(xr){6,cmp11{{jump if not system label{18071
{{bne{13,vrsvp(xr){21,=v_end{6,cmp11{jump if not end label{18072
*      here for end label scanned out
{{add{3,stage{18,=stgnd{{adjust stage appropriately{18076
{{jsr{6,scane{{{scan out next element{18077
{{beq{7,xl{18,=t_smc{6,cmp10{jump if end of image{18078
{{bne{7,xl{18,=t_var{6,cmp08{else error if not variable{18079
*      here check for valid initial transfer
{{beq{13,vrlbl(xr){21,=stndl{6,cmp08{jump if not defined (error){18083
{{mov{13,cmtra(xs){13,vrlbl(xr){{else set initial entry pointer{18084
{{jsr{6,scane{{{scan next element{18085
{{beq{7,xl{18,=t_smc{6,cmp10{jump if ok (end of image){18086
*      here for bad transfer label
{cmp08{erb{1,215{26,syntax error: undefined or erroneous entry label{{{18090
*      here for end of input (no end label detected)
{cmp09{zer{7,xr{{{clear garbage xr value{18094
{{add{3,stage{18,=stgnd{{adjust stage appropriately{18095
{{beq{3,stage{18,=stgxe{6,cmp10{jump if code call (ok){18096
{{erb{1,216{26,syntax error: missing end line{{{18097
*      here after processing end line (merge here on end error)
{cmp10{mov{8,wa{21,=ostp_{{set stop call pointer{18101
{{jsr{6,cdwrd{{{generate as statement call{18102
{{brn{6,cmpse{{{jump to generate as failure{18103
{{ejc{{{{{18104
*      cmpil (continued)
*      here after processing label other than end
{cmp11{bne{3,stage{18,=stgic{6,cmp12{jump if code call - redef. ok{18110
{{beq{13,vrlbl(xr){21,=stndl{6,cmp12{else check for redefinition{18111
{{zer{13,cmlbl(xs){{{leave first label decln undisturbed{18112
{{erb{1,217{26,syntax error: duplicate label{{{18113
*      here after dealing with label
*      null statements and statements just containing a
*      constant subject are optimized out by resetting the
*      current ccblk to empty.
{cmp12{zer{8,wb{{{set flag for statement body{18120
{{jsr{6,expan{{{get tree for statement body{18121
{{mov{13,cmstm(xs){7,xr{{store for later use{18122
{{zer{13,cmsgo(xs){{{clear success goto pointer{18123
{{zer{13,cmfgo(xs){{{clear failure goto pointer{18124
{{zer{13,cmcgo(xs){{{clear conditional goto flag{18125
{{jsr{6,scane{{{scan next element{18126
{{beq{7,xl{18,=t_col{6,cmp13{jump if colon (goto){18127
{{bnz{3,cswno{6,cmp18{{jump if not optimizing{18128
{{bnz{13,cmlbl(xs){6,cmp18{{jump if label present{18129
{{mov{7,xr{13,cmstm(xs){{load tree ptr for statement body{18130
{{mov{8,wa{9,(xr){{load type word{18131
{{beq{8,wa{22,=b_cmt{6,cmp18{jump if cmblk{18132
{{bge{8,wa{22,=b_vra{6,cmp18{jump if not icblk, scblk, or rcblk{18133
{{mov{7,xl{3,r_ccb{{load ptr to ccblk{18134
{{mov{13,ccuse(xl){19,*cccod{{reset use offset in ccblk{18135
{{mov{3,cwcof{19,*cccod{{and in global{18136
{{icv{3,cmpsn{{{bump statement number{18137
{{brn{6,cmp01{{{generate no code for statement{18138
*      loop to process goto fields
{cmp13{mnz{3,scngo{{{set goto flag{18142
{{jsr{6,scane{{{scan next element{18143
{{beq{7,xl{18,=t_smc{6,cmp31{jump if no fields left{18144
{{beq{7,xl{18,=t_sgo{6,cmp14{jump if s for success goto{18145
{{beq{7,xl{18,=t_fgo{6,cmp16{jump if f for failure goto{18146
*      here for unconditional goto (i.e. not f or s)
{{mnz{3,scnrs{{{set to rescan element not f,s{18150
{{jsr{6,scngf{{{scan out goto field{18151
{{bnz{13,cmfgo(xs){6,cmp17{{error if fgoto already{18152
{{mov{13,cmfgo(xs){7,xr{{else set as fgoto{18153
{{brn{6,cmp15{{{merge with sgoto circuit{18154
*      here for success goto
{cmp14{jsr{6,scngf{{{scan success goto field{18158
{{mov{13,cmcgo(xs){18,=num01{{set conditional goto flag{18159
*      uncontional goto merges here
{cmp15{bnz{13,cmsgo(xs){6,cmp17{{error if sgoto already given{18163
{{mov{13,cmsgo(xs){7,xr{{else set sgoto{18164
{{brn{6,cmp13{{{loop back for next goto field{18165
*      here for failure goto
{cmp16{jsr{6,scngf{{{scan goto field{18169
{{mov{13,cmcgo(xs){18,=num01{{set conditonal goto flag{18170
{{bnz{13,cmfgo(xs){6,cmp17{{error if fgoto already given{18171
{{mov{13,cmfgo(xs){7,xr{{else store fgoto pointer{18172
{{brn{6,cmp13{{{loop back for next field{18173
{{ejc{{{{{18174
*      cmpil (continued)
*      here for duplicated goto field
{cmp17{erb{1,218{26,syntax error: duplicated goto field{{{18180
*      here to generate code
{cmp18{zer{3,scnse{{{stop positional error flags{18184
{{mov{7,xr{13,cmstm(xs){{load tree ptr for statement body{18185
{{zer{8,wb{{{collectable value for wb for cdgvl{18186
{{zer{8,wc{{{reset constant flag for cdgvl{18187
{{jsr{6,expap{{{test for pattern match{18188
{{ppm{6,cmp19{{{jump if not pattern match{18189
{{mov{13,cmopn(xr){21,=opms_{{else set pattern match pointer{18190
{{mov{13,cmtyp(xr){18,=c_pmt{{{18191
*      here after dealing with special pattern match case
{cmp19{jsr{6,cdgvl{{{generate code for body of statement{18195
{{mov{7,xr{13,cmsgo(xs){{load sgoto pointer{18196
{{mov{8,wa{7,xr{{copy it{18197
{{bze{7,xr{6,cmp21{{jump if no success goto{18198
{{zer{13,cmsoc(xs){{{clear success offset fillin ptr{18199
{{bhi{7,xr{3,state{6,cmp20{jump if complex goto{18200
*      here for simple success goto (label)
{{add{8,wa{19,*vrtra{{point to vrtra field as required{18204
{{jsr{6,cdwrd{{{generate success goto{18205
{{brn{6,cmp22{{{jump to deal with fgoto{18206
*      here for complex success goto
{cmp20{beq{7,xr{13,cmfgo(xs){6,cmp22{no code if same as fgoto{18210
{{zer{8,wb{{{else set ok value for cdgvl in wb{18211
{{jsr{6,cdgcg{{{generate code for success goto{18212
{{brn{6,cmp22{{{jump to deal with fgoto{18213
*      here for no success goto
{cmp21{mov{13,cmsoc(xs){3,cwcof{{set success fill in offset{18217
{{mov{8,wa{21,=ocer_{{point to compile error call{18218
{{jsr{6,cdwrd{{{generate as temporary value{18219
{{ejc{{{{{18220
*      cmpil (continued)
*      here to deal with failure goto
{cmp22{mov{7,xr{13,cmfgo(xs){{load failure goto pointer{18226
{{mov{8,wa{7,xr{{copy it{18227
{{zer{13,cmffc(xs){{{set no fill in required yet{18228
{{bze{7,xr{6,cmp23{{jump if no failure goto given{18229
{{add{8,wa{19,*vrtra{{point to vrtra field in case{18230
{{blo{7,xr{3,state{6,cmpse{jump to gen if simple fgoto{18231
*      here for complex failure goto
{{mov{8,wb{3,cwcof{{save offset to o_gof call{18235
{{mov{8,wa{21,=ogof_{{point to failure goto call{18236
{{jsr{6,cdwrd{{{generate{18237
{{mov{8,wa{21,=ofif_{{point to fail in fail word{18238
{{jsr{6,cdwrd{{{generate{18239
{{jsr{6,cdgcg{{{generate code for failure goto{18240
{{mov{8,wa{8,wb{{copy offset to o_gof for cdfal{18241
{{mov{8,wb{22,=b_cdc{{set complex case cdtyp{18242
{{brn{6,cmp25{{{jump to build cdblk{18243
*      here if no failure goto given
{cmp23{mov{8,wa{21,=ounf_{{load unexpected failure call in cas{18247
{{mov{8,wc{3,cswfl{{get -nofail flag{18248
{{orb{8,wc{13,cmcgo(xs){{check if conditional goto{18249
{{zrb{8,wc{6,cmpse{{jump if -nofail and no cond. goto{18250
{{mnz{13,cmffc(xs){{{else set fill in flag{18251
{{mov{8,wa{21,=ocer_{{and set compile error for temporary{18252
*      merge here with cdfal value in wa, simple cdblk
*      also special entry after statement error
{cmpse{mov{8,wb{22,=b_cds{{set cdtyp for simple case{18257
{{ejc{{{{{18258
*      cmpil (continued)
*      merge here to build cdblk
*      (wa)                  cdfal value to be generated
*      (wb)                  cdtyp value to be generated
*      at this stage, we chop off an appropriate chunk of the
*      current ccblk and convert it into a cdblk. the remainder
*      of the ccblk is reformatted to be the new ccblk.
{cmp25{mov{7,xr{3,r_ccb{{point to ccblk{18271
{{mov{7,xl{13,cmlbl(xs){{get possible label pointer{18272
{{bze{7,xl{6,cmp26{{skip if no label{18273
{{zer{13,cmlbl(xs){{{clear flag for next statement{18274
{{mov{13,vrlbl(xl){7,xr{{put cdblk ptr in vrblk label field{18275
*      merge after doing label
{cmp26{mov{9,(xr){8,wb{{set type word for new cdblk{18279
{{mov{13,cdfal(xr){8,wa{{set failure word{18280
{{mov{7,xl{7,xr{{copy pointer to ccblk{18281
{{mov{8,wb{13,ccuse(xr){{load length gen (= new cdlen){18282
{{mov{8,wc{13,cclen(xr){{load total ccblk length{18283
{{add{7,xl{8,wb{{point past cdblk{18284
{{sub{8,wc{8,wb{{get length left for chop off{18285
{{mov{9,(xl){22,=b_cct{{set type code for new ccblk at end{18286
{{mov{13,ccuse(xl){19,*cccod{{set initial code offset{18287
{{mov{3,cwcof{19,*cccod{{reinitialise cwcof{18288
{{mov{13,cclen(xl){8,wc{{set new length{18289
{{mov{3,r_ccb{7,xl{{set new ccblk pointer{18290
{{zer{13,ccsln(xl){{{initialize new line number{18292
{{mov{13,cdsln(xr){3,cmpln{{set line number in old block{18293
{{mov{13,cdstm(xr){3,cmpsn{{set statement number{18295
{{icv{3,cmpsn{{{bump statement number{18296
*      set pointers in previous code block as required
{{mov{7,xl{13,cmpcd(xs){{load ptr to previous cdblk{18300
{{bze{13,cmffp(xs){6,cmp27{{jump if no failure fill in required{18301
{{mov{13,cdfal(xl){7,xr{{else set failure ptr in previous{18302
*      here to deal with success forward pointer
{cmp27{mov{8,wa{13,cmsop(xs){{load success offset{18306
{{bze{8,wa{6,cmp28{{jump if no fill in required{18307
{{add{7,xl{8,wa{{else point to fill in location{18308
{{mov{9,(xl){7,xr{{store forward pointer{18309
{{zer{7,xl{{{clear garbage xl value{18310
{{ejc{{{{{18311
*      cmpil (continued)
*      now set fill in pointers for this statement
{cmp28{mov{13,cmffp(xs){13,cmffc(xs){{copy failure fill in flag{18317
{{mov{13,cmsop(xs){13,cmsoc(xs){{copy success fill in offset{18318
{{mov{13,cmpcd(xs){7,xr{{save ptr to this cdblk{18319
{{bnz{13,cmtra(xs){6,cmp29{{jump if initial entry already set{18320
{{mov{13,cmtra(xs){7,xr{{else set ptr here as default{18321
*      here after compiling one statement
{cmp29{blt{3,stage{18,=stgce{6,cmp01{jump if not end line just done{18325
{{bze{3,cswls{6,cmp30{{skip if -nolist{18326
{{jsr{6,listr{{{list last line{18327
*      return
{cmp30{mov{7,xr{13,cmtra(xs){{load initial entry cdblk pointer{18331
{{add{7,xs{19,*cmnen{{pop work locations off stack{18332
{{exi{{{{and return to cmpil caller{18333
*      here at end of goto field
{cmp31{mov{8,wb{13,cmfgo(xs){{get fail goto{18337
{{orb{8,wb{13,cmsgo(xs){{or in success goto{18338
{{bnz{8,wb{6,cmp18{{ok if non-null field{18339
{{erb{1,219{26,syntax error: empty goto field{{{18340
*      control card found
{cmp32{icv{8,wb{{{point past ch_mn{18344
{{jsr{6,cncrd{{{process control card{18345
{{zer{3,scnse{{{clear start of element loc.{18346
{{brn{6,cmpce{{{loop for next statement{18347
{{enp{{{{end procedure cmpil{18348
{{ejc{{{{{18349
*      cncrd -- control card processor
*      called to deal with control cards
*      r_cim                 points to current image
*      (wb)                  offset to 1st char of control card
*      jsr  cncrd            call to process control cards
*      (xl,xr,wa,wb,wc,ia)   destroyed
{cncrd{prc{25,e{1,0{{entry point{18360
{{mov{3,scnpt{8,wb{{offset for control card scan{18361
{{mov{8,wa{18,=ccnoc{{number of chars for comparison{18362
{{ctw{8,wa{1,0{{convert to word count{18363
{{mov{3,cnswc{8,wa{{save word count{18364
*      loop here if more than one control card
{cnc01{bge{3,scnpt{3,scnil{6,cnc09{return if end of image{18368
{{mov{7,xr{3,r_cim{{point to image{18369
{{plc{7,xr{3,scnpt{{char ptr for first char{18370
{{lch{8,wa{10,(xr)+{{get first char{18371
{{beq{8,wa{18,=ch_li{6,cnc07{special case of -inxxx{18375
{cnc0a{mnz{3,scncc{{{set flag for scane{18376
{{jsr{6,scane{{{scan card name{18377
{{zer{3,scncc{{{clear scane flag{18378
{{bnz{7,xl{6,cnc06{{fail unless control card name{18379
{{mov{8,wa{18,=ccnoc{{no. of chars to be compared{18380
{{blt{13,sclen(xr){8,wa{6,cnc08{fail if too few chars{18382
{{mov{7,xl{7,xr{{point to control card name{18386
{{zer{8,wb{{{zero offset for substring{18387
{{jsr{6,sbstr{{{extract substring for comparison{18388
{{mov{3,cnscc{7,xr{{keep control card substring ptr{18393
{{mov{7,xr{21,=ccnms{{point to list of standard names{18394
{{zer{8,wb{{{initialise name offset{18395
{{lct{8,wc{18,=cc_nc{{number of standard names{18396
*      try to match name
{cnc02{mov{7,xl{3,cnscc{{point to name{18400
{{lct{8,wa{3,cnswc{{counter for inner loop{18401
{{brn{6,cnc04{{{jump into loop{18402
*      inner loop to match card name chars
{cnc03{ica{7,xr{{{bump standard names ptr{18406
{{ica{7,xl{{{bump name pointer{18407
*      here to initiate the loop
{cnc04{cne{13,schar(xl){9,(xr){6,cnc05{comp. up to cfp_c chars at once{18411
{{bct{8,wa{6,cnc03{{loop if more words to compare{18412
{{ejc{{{{{18413
*      cncrd (continued)
*      matched - branch on card offset
{{mov{7,xl{8,wb{{get name offset{18419
{{bsw{7,xl{2,cc_nc{6,cnc08{switch{18421
{{iff{2,cc_do{6,cnc10{{-double{18460
{{iff{1,1{6,cnc08{{{18460
{{iff{2,cc_du{6,cnc11{{-dump{18460
{{iff{2,cc_cp{6,cnc41{{-copy{18460
{{iff{2,cc_ej{6,cnc12{{-eject{18460
{{iff{2,cc_er{6,cnc13{{-errors{18460
{{iff{2,cc_ex{6,cnc14{{-execute{18460
{{iff{2,cc_fa{6,cnc15{{-fail{18460
{{iff{2,cc_in{6,cnc41{{-include{18460
{{iff{2,cc_ln{6,cnc44{{-line{18460
{{iff{2,cc_li{6,cnc16{{-list{18460
{{iff{2,cc_nr{6,cnc17{{-noerrors{18460
{{iff{2,cc_nx{6,cnc18{{-noexecute{18460
{{iff{2,cc_nf{6,cnc19{{-nofail{18460
{{iff{2,cc_nl{6,cnc20{{-nolist{18460
{{iff{2,cc_no{6,cnc21{{-noopt{18460
{{iff{2,cc_np{6,cnc22{{-noprint{18460
{{iff{2,cc_op{6,cnc24{{-optimise{18460
{{iff{2,cc_pr{6,cnc25{{-print{18460
{{iff{2,cc_si{6,cnc27{{-single{18460
{{iff{2,cc_sp{6,cnc28{{-space{18460
{{iff{2,cc_st{6,cnc31{{-stitle{18460
{{iff{2,cc_ti{6,cnc32{{-title{18460
{{iff{2,cc_tr{6,cnc36{{-trace{18460
{{esw{{{{end switch{18460
*      not matched yet. align std names ptr and try again
{cnc05{ica{7,xr{{{bump standard names ptr{18464
{{bct{8,wa{6,cnc05{{loop{18465
{{icv{8,wb{{{bump names offset{18466
{{bct{8,wc{6,cnc02{{continue if more names{18467
{{brn{6,cnc08{{{ignore unrecognized control card{18469
*      invalid control card name
{cnc06{erb{1,247{26,invalid control statement{{{18474
*      special processing for -inxxx
{cnc07{lch{8,wa{10,(xr)+{{get next char{18478
{{bne{8,wa{18,=ch_ln{6,cnc0a{if not letter n{18482
{{lch{8,wa{9,(xr){{get third char{18483
{{blt{8,wa{18,=ch_d0{6,cnc0a{if not digit{18484
{{bgt{8,wa{18,=ch_d9{6,cnc0a{if not digit{18485
{{add{3,scnpt{18,=num02{{bump offset past -in{18486
{{jsr{6,scane{{{scan integer after -in{18487
{{mov{11,-(xs){7,xr{{stack scanned item{18488
{{jsr{6,gtsmi{{{check if integer{18489
{{ppm{6,cnc06{{{fail if not integer{18490
{{ppm{6,cnc06{{{fail if negative or large{18491
{{mov{3,cswin{7,xr{{keep integer{18492
{{ejc{{{{{18493
*      cncrd (continued)
*      check for more control cards before returning
{cnc08{mov{8,wa{3,scnpt{{preserve in case xeq time compile{18499
{{jsr{6,scane{{{look for comma{18500
{{beq{7,xl{18,=t_cma{6,cnc01{loop if comma found{18501
{{mov{3,scnpt{8,wa{{restore scnpt in case xeq time{18502
*      return point
{cnc09{exi{{{{return{18506
*      -double
{cnc10{mnz{3,cswdb{{{set switch{18510
{{brn{6,cnc08{{{merge{18511
*      -dump
*      this is used for system debugging . it has the effect of
*      producing a core dump at compilation time
{cnc11{jsr{6,sysdm{{{call dumper{18517
{{brn{6,cnc09{{{finished{18518
*      -eject
{cnc12{bze{3,cswls{6,cnc09{{return if -nolist{18522
{{jsr{6,prtps{{{eject{18523
{{jsr{6,listt{{{list title{18524
{{brn{6,cnc09{{{finished{18525
*      -errors
{cnc13{zer{3,cswer{{{clear switch{18529
{{brn{6,cnc08{{{merge{18530
*      -execute
{cnc14{zer{3,cswex{{{clear switch{18534
{{brn{6,cnc08{{{merge{18535
*      -fail
{cnc15{mnz{3,cswfl{{{set switch{18539
{{brn{6,cnc08{{{merge{18540
*      -list
{cnc16{mnz{3,cswls{{{set switch{18544
{{beq{3,stage{18,=stgic{6,cnc08{done if compile time{18545
*      list code line if execute time compile
{{zer{3,lstpf{{{permit listing{18549
{{jsr{6,listr{{{list line{18550
{{brn{6,cnc08{{{merge{18551
{{ejc{{{{{18552
*      cncrd (continued)
*      -noerrors
{cnc17{mnz{3,cswer{{{set switch{18558
{{brn{6,cnc08{{{merge{18559
*      -noexecute
{cnc18{mnz{3,cswex{{{set switch{18563
{{brn{6,cnc08{{{merge{18564
*      -nofail
{cnc19{zer{3,cswfl{{{clear switch{18568
{{brn{6,cnc08{{{merge{18569
*      -nolist
{cnc20{zer{3,cswls{{{clear switch{18573
{{brn{6,cnc08{{{merge{18574
*      -nooptimise
{cnc21{mnz{3,cswno{{{set switch{18578
{{brn{6,cnc08{{{merge{18579
*      -noprint
{cnc22{zer{3,cswpr{{{clear switch{18583
{{brn{6,cnc08{{{merge{18584
*      -optimise
{cnc24{zer{3,cswno{{{clear switch{18588
{{brn{6,cnc08{{{merge{18589
*      -print
{cnc25{mnz{3,cswpr{{{set switch{18593
{{brn{6,cnc08{{{merge{18594
{{ejc{{{{{18595
*      cncrd (continued)
*      -single
{cnc27{zer{3,cswdb{{{clear switch{18601
{{brn{6,cnc08{{{merge{18602
*      -space
{cnc28{bze{3,cswls{6,cnc09{{return if -nolist{18606
{{jsr{6,scane{{{scan integer after -space{18607
{{mov{8,wc{18,=num01{{1 space in case{18608
{{beq{7,xr{18,=t_smc{6,cnc29{jump if no integer{18609
{{mov{11,-(xs){7,xr{{stack it{18610
{{jsr{6,gtsmi{{{check integer{18611
{{ppm{6,cnc06{{{fail if not integer{18612
{{ppm{6,cnc06{{{fail if negative or large{18613
{{bnz{8,wc{6,cnc29{{jump if non zero{18614
{{mov{8,wc{18,=num01{{else 1 space{18615
*      merge with count of lines to skip
{cnc29{add{3,lstlc{8,wc{{bump line count{18619
{{lct{8,wc{8,wc{{convert to loop counter{18620
{{blt{3,lstlc{3,lstnp{6,cnc30{jump if fits on page{18621
{{jsr{6,prtps{{{eject{18622
{{jsr{6,listt{{{list title{18623
{{brn{6,cnc09{{{merge{18624
*      skip lines
{cnc30{jsr{6,prtnl{{{print a blank{18628
{{bct{8,wc{6,cnc30{{loop{18629
{{brn{6,cnc09{{{merge{18630
{{ejc{{{{{18631
*      cncrd (continued)
*      -stitl
{cnc31{mov{3,cnr_t{20,=r_stl{{ptr to r_stl{18637
{{brn{6,cnc33{{{merge{18638
*      -title
{cnc32{mov{3,r_stl{21,=nulls{{clear subtitle{18642
{{mov{3,cnr_t{20,=r_ttl{{ptr to r_ttl{18643
*      common processing for -title, -stitl
{cnc33{mov{7,xr{21,=nulls{{null in case needed{18647
{{mnz{3,cnttl{{{set flag for next listr call{18648
{{mov{8,wb{18,=ccofs{{offset to title/subtitle{18649
{{mov{8,wa{3,scnil{{input image length{18650
{{blo{8,wa{8,wb{6,cnc34{jump if no chars left{18651
{{sub{8,wa{8,wb{{no of chars to extract{18652
{{mov{7,xl{3,r_cim{{point to image{18653
{{jsr{6,sbstr{{{get title/subtitle{18654
*      store title/subtitle
{cnc34{mov{7,xl{3,cnr_t{{point to storage location{18658
{{mov{9,(xl){7,xr{{store title/subtitle{18659
{{beq{7,xl{20,=r_stl{6,cnc09{return if stitl{18660
{{bnz{3,precl{6,cnc09{{return if extended listing{18661
{{bze{3,prich{6,cnc09{{return if regular printer{18662
{{mov{7,xl{13,sclen(xr){{get length of title{18663
{{mov{8,wa{7,xl{{copy it{18664
{{bze{7,xl{6,cnc35{{jump if null{18665
{{add{7,xl{18,=num10{{increment{18666
{{bhi{7,xl{3,prlen{6,cnc09{use default lstp0 val if too long{18667
{{add{8,wa{18,=num04{{point just past title{18668
*      store offset to page nn message for short title
{cnc35{mov{3,lstpo{8,wa{{store offset{18672
{{brn{6,cnc09{{{return{18673
*      -trace
*      provided for system debugging.  toggles the system label
*      trace switch at compile time
{cnc36{jsr{6,systt{{{toggle switch{18679
{{brn{6,cnc08{{{merge{18680
*      -include
{cnc41{mnz{3,scncc{{{set flag for scane{18718
{{jsr{6,scane{{{scan quoted file name{18719
{{zer{3,scncc{{{clear scane flag{18720
{{bne{7,xl{18,=t_con{6,cnc06{if not constant{18721
{{bne{9,(xr){22,=b_scl{6,cnc06{if not string constant{18722
{{mov{3,r_ifn{7,xr{{save file name{18723
{{mov{7,xl{3,r_inc{{examine include file name table{18724
{{zer{8,wb{{{lookup by value{18725
{{jsr{6,tfind{{{do lookup{18726
{{ppm{{{{never fails{18727
{{beq{7,xr{21,=inton{6,cnc09{ignore if already in table{18728
{{mnz{8,wb{{{set for trim{18729
{{mov{7,xr{3,r_ifn{{file name{18730
{{jsr{6,trimr{{{remove trailing blanks{18731
{{mov{7,xl{3,r_inc{{include file name table{18732
{{mnz{8,wb{{{lookup by name this time{18733
{{jsr{6,tfind{{{do lookup{18734
{{ppm{{{{never fails{18735
{{mov{13,teval(xl){21,=inton{{make table value integer 1{18736
{{icv{3,cnind{{{increase nesting level{18737
{{mov{8,wa{3,cnind{{load new nest level{18738
{{bgt{8,wa{18,=ccinm{6,cnc42{fail if excessive nesting{18739
*      record the name and line number of the current input file
{{mov{7,xl{3,r_ifa{{array of nested file names{18744
{{add{8,wa{18,=vcvlb{{compute offset in words{18745
{{wtb{8,wa{{{convert to bytes{18746
{{add{7,xl{8,wa{{point to element{18747
{{mov{9,(xl){3,r_sfc{{record current file name{18748
{{mov{7,xl{8,wa{{preserve nesting byte offset{18749
{{mti{3,rdnln{{{fetch source line number as integer{18750
{{jsr{6,icbld{{{convert to icblk{18751
{{add{7,xl{3,r_ifl{{entry in nested line number array{18752
{{mov{9,(xl){7,xr{{record in array{18753
*      here to switch to include file named in r_ifn
{{mov{8,wa{3,cswin{{max read length{18758
{{mov{7,xl{3,r_ifn{{include file name{18759
{{jsr{6,alocs{{{get buffer for complete file name{18760
{{jsr{6,sysif{{{open include file{18761
{{ppm{6,cnc43{{{could not open{18762
*      make note of the complete file name for error messages
{{zer{8,wb{{{do not trim trailing blanks{18767
{{jsr{6,trimr{{{adjust scblk for actual length{18768
{{mov{3,r_sfc{7,xr{{save ptr to file name{18769
{{mti{3,cmpsn{{{current statement as integer{18770
{{jsr{6,icbld{{{build icblk for stmt number{18771
{{mov{7,xl{3,r_sfn{{file name table{18772
{{mnz{8,wb{{{lookup statement number by name{18773
{{jsr{6,tfind{{{allocate new teblk{18774
{{ppm{{{{always possible to allocate block{18775
{{mov{13,teval(xl){3,r_sfc{{record file name as entry value{18776
{{zer{3,rdnln{{{restart line counter for new file{18780
{{beq{3,stage{18,=stgic{6,cnc09{if initial compile{18781
{{bne{3,cnind{18,=num01{6,cnc09{if not first execute-time nesting{18782
*      here for -include during execute-time compile
{{mov{3,r_ici{3,r_cim{{remember code argument string{18786
{{mov{3,cnspt{3,scnpt{{save position in string{18787
{{mov{3,cnsil{3,scnil{{and length of string{18788
{{brn{6,cnc09{{{all done, merge{18789
*      here for excessive include file nesting
{cnc42{erb{1,284{26,excessively nested include files{{{18793
*      here if include file could not be opened
{cnc43{mov{3,dnamp{7,xr{{release allocated scblk{18797
{{erb{1,285{26,include file cannot be opened{{{18798
*      -line n filename
{cnc44{jsr{6,scane{{{scan integer after -line{18805
{{bne{7,xl{18,=t_con{6,cnc06{jump if no line number{18806
{{bne{9,(xr){22,=b_icl{6,cnc06{jump if not integer{18807
{{ldi{13,icval(xr){{{fetch integer line number{18808
{{ile{6,cnc06{{{error if negative or zero{18809
{{beq{3,stage{18,=stgic{6,cnc45{skip if initial compile{18810
{{mfi{3,cmpln{{{set directly for other compiles{18811
{{brn{6,cnc46{{{no need to set rdnln{18812
{cnc45{sbi{4,intv1{{{adjust number by one{18813
{{mfi{3,rdnln{{{save line number{18814
{cnc46{mnz{3,scncc{{{set flag for scane{18816
{{jsr{6,scane{{{scan quoted file name{18817
{{zer{3,scncc{{{clear scane flag{18818
{{beq{7,xl{18,=t_smc{6,cnc47{done if no file name{18819
{{bne{7,xl{18,=t_con{6,cnc06{error if not constant{18820
{{bne{9,(xr){22,=b_scl{6,cnc06{if not string constant{18821
{{jsr{6,newfn{{{record new file name{18822
{{brn{6,cnc09{{{merge{18823
*      here if file name not present
{cnc47{dcv{3,scnpt{{{set to rescan the terminator{18827
{{brn{6,cnc09{{{merge{18828
{{enp{{{{end procedure cncrd{18833
{{ejc{{{{{18834
*      dffnc -- define function
*      dffnc is called whenever a new function is assigned to
*      a variable. it deals with external function use counts.
*      (xr)                  pointer to vrblk
*      (xl)                  pointer to new function block
*      jsr  dffnc            call to define function
*      (wa,wb)               destroyed
{dffnc{prc{25,e{1,0{{entry point{18916
{{bne{9,(xl){22,=b_efc{6,dffn1{skip if new function not external{18919
{{icv{13,efuse(xl){{{else increment its use count{18920
*      here after dealing with new function use count
{dffn1{mov{8,wa{7,xr{{save vrblk pointer{18924
{{mov{7,xr{13,vrfnc(xr){{load old function pointer{18925
{{bne{9,(xr){22,=b_efc{6,dffn2{jump if old function not external{18926
{{mov{8,wb{13,efuse(xr){{else get use count{18927
{{dcv{8,wb{{{decrement{18928
{{mov{13,efuse(xr){8,wb{{store decremented value{18929
{{bnz{8,wb{6,dffn2{{jump if use count still non-zero{18930
{{jsr{6,sysul{{{else call system unload function{18931
*      here after dealing with old function use count
{dffn2{mov{7,xr{8,wa{{restore vrblk pointer{18935
{{mov{8,wa{7,xl{{copy function block ptr{18937
{{blt{7,xr{20,=r_yyy{6,dffn3{skip checks if opsyn op definition{18938
{{bnz{13,vrlen(xr){6,dffn3{{jump if not system variable{18939
*      for system variable, check for illegal redefinition
{{mov{7,xl{13,vrsvp(xr){{point to svblk{18943
{{mov{8,wb{13,svbit(xl){{load bit indicators{18944
{{anb{8,wb{4,btfnc{{is it a system function{18945
{{zrb{8,wb{6,dffn3{{redef ok if not{18946
{{erb{1,248{26,attempted redefinition of system function{{{18947
*      here if redefinition is permitted
{dffn3{mov{13,vrfnc(xr){8,wa{{store new function pointer{18951
{{mov{7,xl{8,wa{{restore function block pointer{18952
{{exi{{{{return to dffnc caller{18953
{{enp{{{{end procedure dffnc{18954
{{ejc{{{{{18955
*      dtach -- detach i/o associated names
*      detaches trblks from i/o associated variables, removes
*      entry from iochn chain attached to filearg1 vrblk and may
*      remove vrblk access and store traps.
*      input, output, terminal are handled specially.
*      (xl)                  i/o assoc. vbl name base ptr
*      (wa)                  offset to name
*      jsr  dtach            call for detach operation
*      (xl,xr,wa,wb,wc)      destroyed
{dtach{prc{25,e{1,0{{entry point{18969
{{mov{3,dtcnb{7,xl{{store name base (gbcol not called){18970
{{add{7,xl{8,wa{{point to name location{18971
{{mov{3,dtcnm{7,xl{{store it{18972
*      loop to search for i/o trblk
{dtch1{mov{7,xr{7,xl{{copy name pointer{18976
*      continue after block deletion
{dtch2{mov{7,xl{9,(xl){{point to next value{18980
{{bne{9,(xl){22,=b_trt{6,dtch6{jump at chain end{18981
{{mov{8,wa{13,trtyp(xl){{get trap block type{18982
{{beq{8,wa{18,=trtin{6,dtch3{jump if input{18983
{{beq{8,wa{18,=trtou{6,dtch3{jump if output{18984
{{add{7,xl{19,*trnxt{{point to next link{18985
{{brn{6,dtch1{{{loop{18986
*      delete an old association
{dtch3{mov{9,(xr){13,trval(xl){{delete trblk{18990
{{mov{8,wa{7,xl{{dump xl ...{18991
{{mov{8,wb{7,xr{{... and xr{18992
{{mov{7,xl{13,trtrf(xl){{point to trtrf trap block{18993
{{bze{7,xl{6,dtch5{{jump if no iochn{18994
{{bne{9,(xl){22,=b_trt{6,dtch5{jump if input, output, terminal{18995
*      loop to search iochn chain for name ptr
{dtch4{mov{7,xr{7,xl{{remember link ptr{18999
{{mov{7,xl{13,trtrf(xl){{point to next link{19000
{{bze{7,xl{6,dtch5{{jump if end of chain{19001
{{mov{8,wc{13,ionmb(xl){{get name base{19002
{{add{8,wc{13,ionmo(xl){{add offset{19003
{{bne{8,wc{3,dtcnm{6,dtch4{loop if no match{19004
{{mov{13,trtrf(xr){13,trtrf(xl){{remove name from chain{19005
{{ejc{{{{{19006
*      dtach (continued)
*      prepare to resume i/o trblk scan
{dtch5{mov{7,xl{8,wa{{recover xl ...{19012
{{mov{7,xr{8,wb{{... and xr{19013
{{add{7,xl{19,*trval{{point to value field{19014
{{brn{6,dtch2{{{continue{19015
*      exit point
{dtch6{mov{7,xr{3,dtcnb{{possible vrblk ptr{19019
{{jsr{6,setvr{{{reset vrblk if necessary{19020
{{exi{{{{return{19021
{{enp{{{{end procedure dtach{19022
{{ejc{{{{{19023
*      dtype -- get datatype name
*      (xr)                  object whose datatype is required
*      jsr  dtype            call to get datatype
*      (xr)                  result datatype
{dtype{prc{25,e{1,0{{entry point{19031
{{beq{9,(xr){22,=b_pdt{6,dtyp1{jump if prog.defined{19032
{{mov{7,xr{9,(xr){{load type word{19033
{{lei{7,xr{{{get entry point id (block code){19034
{{wtb{7,xr{{{convert to byte offset{19035
{{mov{7,xr{14,scnmt(xr){{load table entry{19036
{{exi{{{{exit to dtype caller{19037
*      here if program defined
{dtyp1{mov{7,xr{13,pddfp(xr){{point to dfblk{19041
{{mov{7,xr{13,dfnam(xr){{get datatype name from dfblk{19042
{{exi{{{{return to dtype caller{19043
{{enp{{{{end procedure dtype{19044
{{ejc{{{{{19045
*      dumpr -- print dump of storage
*      (xr)                  dump argument (see below)
*      jsr  dumpr            call to print dump
*      (xr,xl)               destroyed
*      (wa,wb,wc,ra)         destroyed
*      the dump argument has the following significance
*      dmarg = 0             no dump printed
*      dmarg = 1             partial dump (nat vars, keywords)
*      dmarg = 2             full dump (arrays, tables, etc.)
*      dmarg = 3             full dump + null variables
*      dmarg ge 4            core dump
*      since dumpr scrambles store, it is not permissible to
*      collect in mid-dump. hence a collect is done initially
*      and then if store runs out an error message is produced.
{dumpr{prc{25,e{1,0{{entry point{19066
{{bze{7,xr{6,dmp28{{skip dump if argument is zero{19067
{{bgt{7,xr{18,=num03{6,dmp29{jump if core dump required{19068
{{zer{7,xl{{{clear xl{19069
{{zer{8,wb{{{zero move offset{19070
{{mov{3,dmarg{7,xr{{save dump argument{19071
{{zer{3,dnams{{{collect sediment too{19073
{{jsr{6,gbcol{{{collect garbage{19075
{{jsr{6,prtpg{{{eject printer{19076
{{mov{7,xr{21,=dmhdv{{point to heading for variables{19077
{{jsr{6,prtst{{{print it{19078
{{jsr{6,prtnl{{{terminate print line{19079
{{jsr{6,prtnl{{{and print a blank line{19080
*      first all natural variable blocks (vrblk) whose values
*      are non-null are linked in lexical order using dmvch as
*      the chain head and chaining through the vrget fields.
*      note that this scrambles store if the process is
*      interrupted before completion e.g. by exceeding time  or
*      print limits. since the subsequent core dumps and
*      failures if execution is resumed are very confusing, the
*      execution time error routine checks for this event and
*      attempts an unscramble. similar precautions should be
*      observed if translate time dumping is implemented.
{{zer{3,dmvch{{{set null chain to start{19093
{{mov{8,wa{3,hshtb{{point to hash table{19094
*      loop through headers in hash table
{dmp00{mov{7,xr{8,wa{{copy hash bucket pointer{19098
{{ica{8,wa{{{bump pointer{19099
{{sub{7,xr{19,*vrnxt{{set offset to merge{19100
*      loop through vrblks on one chain
{dmp01{mov{7,xr{13,vrnxt(xr){{point to next vrblk on chain{19104
{{bze{7,xr{6,dmp09{{jump if end of this hash chain{19105
{{mov{7,xl{7,xr{{else copy vrblk pointer{19106
{{ejc{{{{{19107
*      dumpr (continued)
*      loop to find value and skip if null
{dmp02{mov{7,xl{13,vrval(xl){{load value{19113
{{beq{3,dmarg{18,=num03{6,dmp2a{skip null value check if dump(3){19114
{{beq{7,xl{21,=nulls{6,dmp01{loop for next vrblk if null value{19115
{dmp2a{beq{9,(xl){22,=b_trt{6,dmp02{loop back if value is trapped{19116
*      non-null value, prepare to search chain
{{mov{8,wc{7,xr{{save vrblk pointer{19120
{{add{7,xr{19,*vrsof{{adjust ptr to be like scblk ptr{19121
{{bnz{13,sclen(xr){6,dmp03{{jump if non-system variable{19122
{{mov{7,xr{13,vrsvo(xr){{else load ptr to name in svblk{19123
*      here with name pointer for new block in xr
{dmp03{mov{8,wb{7,xr{{save pointer to chars{19127
{{mov{3,dmpsv{8,wa{{save hash bucket pointer{19128
{{mov{8,wa{20,=dmvch{{point to chain head{19129
*      loop to search chain for correct insertion point
{dmp04{mov{3,dmpch{8,wa{{save chain pointer{19133
{{mov{7,xl{8,wa{{copy it{19134
{{mov{7,xr{9,(xl){{load pointer to next entry{19135
{{bze{7,xr{6,dmp08{{jump if end of chain to insert{19136
{{add{7,xr{19,*vrsof{{else get name ptr for chained vrblk{19137
{{bnz{13,sclen(xr){6,dmp05{{jump if not system variable{19138
{{mov{7,xr{13,vrsvo(xr){{else point to name in svblk{19139
*      here prepare to compare the names
*      (wa)                  scratch
*      (wb)                  pointer to string of entering vrblk
*      (wc)                  pointer to entering vrblk
*      (xr)                  pointer to string of current block
*      (xl)                  scratch
{dmp05{mov{7,xl{8,wb{{point to entering vrblk string{19149
{{mov{8,wa{13,sclen(xl){{load its length{19150
{{plc{7,xl{{{point to chars of entering string{19151
{{bhi{8,wa{13,sclen(xr){6,dmp06{jump if entering length high{19174
{{plc{7,xr{{{else point to chars of old string{19175
{{cmc{6,dmp08{6,dmp07{{compare, insert if new is llt old{19176
{{brn{6,dmp08{{{or if leq (we had shorter length){19177
*      here when new length is longer than old length
{dmp06{mov{8,wa{13,sclen(xr){{load shorter length{19181
{{plc{7,xr{{{point to chars of old string{19182
{{cmc{6,dmp08{6,dmp07{{compare, insert if new one low{19183
{{ejc{{{{{19184
*      dumpr (continued)
*      here we move out on the chain
{dmp07{mov{7,xl{3,dmpch{{copy chain pointer{19190
{{mov{8,wa{9,(xl){{move to next entry on chain{19192
{{brn{6,dmp04{{{loop back{19193
*      here after locating the proper insertion point
{dmp08{mov{7,xl{3,dmpch{{copy chain pointer{19197
{{mov{8,wa{3,dmpsv{{restore hash bucket pointer{19198
{{mov{7,xr{8,wc{{restore vrblk pointer{19199
{{mov{13,vrget(xr){9,(xl){{link vrblk to rest of chain{19200
{{mov{9,(xl){7,xr{{link vrblk into current chain loc{19201
{{brn{6,dmp01{{{loop back for next vrblk{19202
*      here after processing all vrblks on one chain
{dmp09{bne{8,wa{3,hshte{6,dmp00{loop back if more buckets to go{19206
*      loop to generate dump of natural variable values
{dmp10{mov{7,xr{3,dmvch{{load pointer to next entry on chain{19210
{{bze{7,xr{6,dmp11{{jump if end of chain{19211
{{mov{3,dmvch{9,(xr){{else update chain ptr to next entry{19212
{{jsr{6,setvr{{{restore vrget field{19213
{{mov{7,xl{7,xr{{copy vrblk pointer (name base){19214
{{mov{8,wa{19,*vrval{{set offset for vrblk name{19215
{{jsr{6,prtnv{{{print name = value{19216
{{brn{6,dmp10{{{loop back till all printed{19217
*      prepare to print keywords
{dmp11{jsr{6,prtnl{{{print blank line{19221
{{jsr{6,prtnl{{{and another{19222
{{mov{7,xr{21,=dmhdk{{point to keyword heading{19223
{{jsr{6,prtst{{{print heading{19224
{{jsr{6,prtnl{{{end line{19225
{{jsr{6,prtnl{{{print one blank line{19226
{{mov{7,xl{21,=vdmkw{{point to list of keyword svblk ptrs{19227
{{ejc{{{{{19228
*      dumpr (continued)
*      loop to dump keyword values
{dmp12{mov{7,xr{10,(xl)+{{load next svblk ptr from table{19234
{{bze{7,xr{6,dmp13{{jump if end of list{19235
{{beq{7,xr{18,=num01{6,dmp12{&compare ignored if not implemented{19237
{{mov{8,wa{18,=ch_am{{load ampersand{19239
{{jsr{6,prtch{{{print ampersand{19240
{{jsr{6,prtst{{{print keyword name{19241
{{mov{8,wa{13,svlen(xr){{load name length from svblk{19242
{{ctb{8,wa{2,svchs{{get length of name{19243
{{add{7,xr{8,wa{{point to svknm field{19244
{{mov{3,dmpkn{9,(xr){{store in dummy kvblk{19245
{{mov{7,xr{21,=tmbeb{{point to blank-equal-blank{19246
{{jsr{6,prtst{{{print it{19247
{{mov{3,dmpsv{7,xl{{save table pointer{19248
{{mov{7,xl{20,=dmpkb{{point to dummy kvblk{19249
{{mov{9,(xl){22,=b_kvt{{build type word{19250
{{mov{13,kvvar(xl){21,=trbkv{{build ptr to dummy trace block{19251
{{mov{8,wa{19,*kvvar{{set zero offset{19252
{{jsr{6,acess{{{get keyword value{19253
{{ppm{{{{failure is impossible{19254
{{jsr{6,prtvl{{{print keyword value{19255
{{jsr{6,prtnl{{{terminate print line{19256
{{mov{7,xl{3,dmpsv{{restore table pointer{19257
{{brn{6,dmp12{{{loop back till all printed{19258
*      here after completing partial dump
{dmp13{beq{3,dmarg{18,=num01{6,dmp27{exit if partial dump complete{19262
{{mov{7,xr{3,dnamb{{else point to first dynamic block{19263
*      loop through blocks in dynamic storage
{dmp14{beq{7,xr{3,dnamp{6,dmp27{jump if end of used region{19267
{{mov{8,wa{9,(xr){{else load first word of block{19268
{{beq{8,wa{22,=b_vct{6,dmp16{jump if vector{19269
{{beq{8,wa{22,=b_art{6,dmp17{jump if array{19270
{{beq{8,wa{22,=b_pdt{6,dmp18{jump if program defined{19271
{{beq{8,wa{22,=b_tbt{6,dmp19{jump if table{19272
*      merge here to move to next block
{dmp15{jsr{6,blkln{{{get length of block{19280
{{add{7,xr{8,wa{{point past this block{19281
{{brn{6,dmp14{{{loop back for next block{19282
{{ejc{{{{{19283
*      dumpr (continued)
*      here for vector
{dmp16{mov{8,wb{19,*vcvls{{set offset to first value{19289
{{brn{6,dmp19{{{jump to merge{19290
*      here for array
{dmp17{mov{8,wb{13,arofs(xr){{set offset to arpro field{19294
{{ica{8,wb{{{bump to get offset to values{19295
{{brn{6,dmp19{{{jump to merge{19296
*      here for program defined
{dmp18{mov{8,wb{19,*pdfld{{point to values, merge{19300
*      here for table (others merge)
{dmp19{bze{13,idval(xr){6,dmp15{{ignore block if zero id value{19304
{{jsr{6,blkln{{{else get block length{19305
{{mov{7,xl{7,xr{{copy block pointer{19306
{{mov{3,dmpsv{8,wa{{save length{19307
{{mov{8,wa{8,wb{{copy offset to first value{19308
{{jsr{6,prtnl{{{print blank line{19309
{{mov{3,dmpsa{8,wa{{preserve offset{19310
{{jsr{6,prtvl{{{print block value (for title){19311
{{mov{8,wa{3,dmpsa{{recover offset{19312
{{jsr{6,prtnl{{{end print line{19313
{{beq{9,(xr){22,=b_tbt{6,dmp22{jump if table{19314
{{dca{8,wa{{{point before first word{19315
*      loop to print contents of array, vector, or program def
{dmp20{mov{7,xr{7,xl{{copy block pointer{19319
{{ica{8,wa{{{bump offset{19320
{{add{7,xr{8,wa{{point to next value{19321
{{beq{8,wa{3,dmpsv{6,dmp14{exit if end (xr past block){19322
{{sub{7,xr{19,*vrval{{subtract offset to merge into loop{19323
*      loop to find value and ignore nulls
{dmp21{mov{7,xr{13,vrval(xr){{load next value{19327
{{beq{3,dmarg{18,=num03{6,dmp2b{skip null value check if dump(3){19328
{{beq{7,xr{21,=nulls{6,dmp20{loop back if null value{19329
{dmp2b{beq{9,(xr){22,=b_trt{6,dmp21{loop back if trapped{19330
{{jsr{6,prtnv{{{else print name = value{19331
{{brn{6,dmp20{{{loop back for next field{19332
{{ejc{{{{{19333
*      dumpr (continued)
*      here to dump a table
{dmp22{mov{8,wc{19,*tbbuk{{set offset to first bucket{19339
{{mov{8,wa{19,*teval{{set name offset for all teblks{19340
*      loop through table buckets
{dmp23{mov{11,-(xs){7,xl{{save tbblk pointer{19344
{{add{7,xl{8,wc{{point to next bucket header{19345
{{ica{8,wc{{{bump bucket offset{19346
{{sub{7,xl{19,*tenxt{{subtract offset to merge into loop{19347
*      loop to process teblks on one chain
{dmp24{mov{7,xl{13,tenxt(xl){{point to next teblk{19351
{{beq{7,xl{9,(xs){6,dmp26{jump if end of chain{19352
{{mov{7,xr{7,xl{{else copy teblk pointer{19353
*      loop to find value and ignore if null
{dmp25{mov{7,xr{13,teval(xr){{load next value{19357
{{beq{7,xr{21,=nulls{6,dmp24{ignore if null value{19358
{{beq{9,(xr){22,=b_trt{6,dmp25{loop back if trapped{19359
{{mov{3,dmpsv{8,wc{{else save offset pointer{19360
{{jsr{6,prtnv{{{print name = value{19361
{{mov{8,wc{3,dmpsv{{reload offset{19362
{{brn{6,dmp24{{{loop back for next teblk{19363
*      here to move to next hash chain
{dmp26{mov{7,xl{10,(xs)+{{restore tbblk pointer{19367
{{bne{8,wc{13,tblen(xl){6,dmp23{loop back if more buckets to go{19368
{{mov{7,xr{7,xl{{else copy table pointer{19369
{{add{7,xr{8,wc{{point to following block{19370
{{brn{6,dmp14{{{loop back to process next block{19371
*      here after completing dump
{dmp27{jsr{6,prtpg{{{eject printer{19375
*      merge here if no dump given (dmarg=0)
{dmp28{exi{{{{return to dump caller{19379
*      call system core dump routine
{dmp29{jsr{6,sysdm{{{call it{19383
{{brn{6,dmp28{{{return{19384
{{enp{{{{end procedure dumpr{19420
{{ejc{{{{{19421
*      ermsg -- print error code and error message
*      kvert                 error code
*      jsr  ermsg            call to print message
*      (xr,xl,wa,wb,wc,ia)   destroyed
{ermsg{prc{25,e{1,0{{entry point{19429
{{mov{8,wa{3,kvert{{load error code{19430
{{mov{7,xr{21,=ermms{{point to error message /error/{19431
{{jsr{6,prtst{{{print it{19432
{{jsr{6,ertex{{{get error message text{19433
{{add{8,wa{18,=thsnd{{bump error code for print{19434
{{mti{8,wa{{{fail code in int acc{19435
{{mov{8,wb{3,profs{{save current buffer position{19436
{{jsr{6,prtin{{{print code (now have error1xxx){19437
{{mov{7,xl{3,prbuf{{point to print buffer{19438
{{psc{7,xl{8,wb{{point to the 1{19439
{{mov{8,wa{18,=ch_bl{{load a blank{19440
{{sch{8,wa{9,(xl){{store blank over 1 (error xxx){19441
{{csc{7,xl{{{complete store characters{19442
{{zer{7,xl{{{clear garbage pointer in xl{19443
{{mov{8,wa{7,xr{{keep error text{19444
{{mov{7,xr{21,=ermns{{point to / -- /{19445
{{jsr{6,prtst{{{print it{19446
{{mov{7,xr{8,wa{{get error text again{19447
{{jsr{6,prtst{{{print error message text{19448
{{jsr{6,prtis{{{print line{19449
{{jsr{6,prtis{{{print blank line{19450
{{exi{{{{return to ermsg caller{19451
{{enp{{{{end procedure ermsg{19452
{{ejc{{{{{19453
*      ertex -- get error message text
*      (wa)                  error code
*      jsr  ertex            call to get error text
*      (xr)                  ptr to error text in dynamic
*      (r_etx)               copy of ptr to error text
*      (xl,wc,ia)            destroyed
{ertex{prc{25,e{1,0{{entry point{19463
{{mov{3,ertwa{8,wa{{save wa{19464
{{mov{3,ertwb{8,wb{{save wb{19465
{{jsr{6,sysem{{{get failure message text{19466
{{mov{7,xl{7,xr{{copy pointer to it{19467
{{mov{8,wa{13,sclen(xr){{get length of string{19468
{{bze{8,wa{6,ert02{{jump if null{19469
{{zer{8,wb{{{offset of zero{19470
{{jsr{6,sbstr{{{copy into dynamic store{19471
{{mov{3,r_etx{7,xr{{store for relocation{19472
*      return
{ert01{mov{8,wb{3,ertwb{{restore wb{19476
{{mov{8,wa{3,ertwa{{restore wa{19477
{{exi{{{{return to caller{19478
*      return errtext contents instead of null
{ert02{mov{7,xr{3,r_etx{{get errtext{19482
{{brn{6,ert01{{{return{19483
{{enp{{{{{19484
{{ejc{{{{{19485
*      evali -- evaluate integer argument
*      evali is used by pattern primitives len,tab,rtab,pos,rpos
*      when their argument is an expression value.
*      (xr)                  node pointer
*      (wb)                  cursor
*      jsr  evali            call to evaluate integer
*      ppm  loc              transfer loc for non-integer arg
*      ppm  loc              transfer loc for out of range arg
*      ppm  loc              transfer loc for evaluation failure
*      ppm  loc              transfer loc for successful eval
*      (the normal return is never taken)
*      (xr)                  ptr to node with integer argument
*      (wc,xl,ra)            destroyed
*      on return, the node pointed to has the integer argument
*      in parm1 and the proper successor pointer in pthen.
*      this allows merging with the normal (integer arg) case.
{evali{prc{25,r{1,4{{entry point (recursive){19507
{{jsr{6,evalp{{{evaluate expression{19508
{{ppm{6,evli1{{{jump on failure{19509
{{mov{11,-(xs){7,xl{{stack result for gtsmi{19510
{{mov{7,xl{13,pthen(xr){{load successor pointer{19511
{{mov{3,evlio{7,xr{{save original node pointer{19512
{{mov{3,evlif{8,wc{{zero if simple argument{19513
{{jsr{6,gtsmi{{{convert arg to small integer{19514
{{ppm{6,evli2{{{jump if not integer{19515
{{ppm{6,evli3{{{jump if out of range{19516
{{mov{3,evliv{7,xr{{store result in special dummy node{19517
{{mov{7,xr{20,=evlin{{point to dummy node with result{19518
{{mov{9,(xr){22,=p_len{{dummy pattern block pcode{19519
{{mov{13,pthen(xr){7,xl{{store successor pointer{19520
{{exi{1,4{{{take successful exit{19521
*      here if evaluation fails
{evli1{exi{1,3{{{take failure return{19525
*      here if argument is not integer
{evli2{exi{1,1{{{take non-integer error exit{19529
*      here if argument is out of range
{evli3{exi{1,2{{{take out-of-range error exit{19533
{{enp{{{{end procedure evali{19534
{{ejc{{{{{19535
*      evalp -- evaluate expression during pattern match
*      evalp is used to evaluate an expression (by value) during
*      a pattern match. the effect is like evalx, but pattern
*      variables are stacked and restored if necessary.
*      evalp also differs from evalx in that if the result is
*      an expression it is reevaluated. this occurs repeatedly.
*      to support optimization of pos and rpos, evalp uses wc
*      to signal the caller for the case of a simple vrblk
*      that is not an expression and is not trapped.  because
*      this case cannot have any side effects, optimization is
*      possible.
*      (xr)                  node pointer
*      (wb)                  pattern match cursor
*      jsr  evalp            call to evaluate expression
*      ppm  loc              transfer loc if evaluation fails
*      (xl)                  result
*      (wa)                  first word of result block
*      (wc)                  zero if simple vrblk, else non-zero
*      (xr,wb)               destroyed (failure case only)
*      (ra)                  destroyed
*      the expression pointer is stored in parm1 of the node
*      control returns to failp on failure of evaluation
{evalp{prc{25,r{1,1{{entry point (recursive){19566
{{mov{7,xl{13,parm1(xr){{load expression pointer{19567
{{beq{9,(xl){22,=b_exl{6,evlp1{jump if exblk case{19568
*      here for case of seblk
*      we can give a fast return if the value of the vrblk is
*      not an expression and is not trapped.
{{mov{7,xl{13,sevar(xl){{load vrblk pointer{19575
{{mov{7,xl{13,vrval(xl){{load value of vrblk{19576
{{mov{8,wa{9,(xl){{load first word of value{19577
{{bhi{8,wa{22,=b_t__{6,evlp3{jump if not seblk, trblk or exblk{19578
*      here for exblk or seblk with expr value or trapped value
{evlp1{chk{{{{check for stack space{19582
{{mov{11,-(xs){7,xr{{stack node pointer{19583
{{mov{11,-(xs){8,wb{{stack cursor{19584
{{mov{11,-(xs){3,r_pms{{stack subject string pointer{19585
{{mov{11,-(xs){3,pmssl{{stack subject string length{19586
{{mov{11,-(xs){3,pmdfl{{stack dot flag{19587
{{mov{11,-(xs){3,pmhbs{{stack history stack base pointer{19588
{{mov{7,xr{13,parm1(xr){{load expression pointer{19589
{{ejc{{{{{19590
*      evalp (continued)
*      loop back here to reevaluate expression result
{evlp2{zer{8,wb{{{set flag for by value{19596
{{jsr{6,evalx{{{evaluate expression{19597
{{ppm{6,evlp4{{{jump on failure{19598
{{mov{8,wa{9,(xr){{else load first word of value{19599
{{blo{8,wa{22,=b_e__{6,evlp2{loop back to reevaluate expression{19600
*      here to restore pattern values after successful eval
{{mov{7,xl{7,xr{{copy result pointer{19604
{{mov{3,pmhbs{10,(xs)+{{restore history stack base pointer{19605
{{mov{3,pmdfl{10,(xs)+{{restore dot flag{19606
{{mov{3,pmssl{10,(xs)+{{restore subject string length{19607
{{mov{3,r_pms{10,(xs)+{{restore subject string pointer{19608
{{mov{8,wb{10,(xs)+{{restore cursor{19609
{{mov{7,xr{10,(xs)+{{restore node pointer{19610
{{mov{8,wc{7,xr{{non-zero for simple vrblk{19611
{{exi{{{{return to evalp caller{19612
*      here to return after simple vrblk case
{evlp3{zer{8,wc{{{simple vrblk, no side effects{19616
{{exi{{{{return to evalp caller{19617
*      here for failure during evaluation
{evlp4{mov{3,pmhbs{10,(xs)+{{restore history stack base pointer{19621
{{mov{3,pmdfl{10,(xs)+{{restore dot flag{19622
{{mov{3,pmssl{10,(xs)+{{restore subject string length{19623
{{mov{3,r_pms{10,(xs)+{{restore subject string pointer{19624
{{add{7,xs{19,*num02{{remove node ptr, cursor{19625
{{exi{1,1{{{take failure exit{19626
{{enp{{{{end procedure evalp{19627
{{ejc{{{{{19628
*      evals -- evaluate string argument
*      evals is used by span, any, notany, break, breakx when
*      they are passed an expression argument.
*      (xr)                  node pointer
*      (wb)                  cursor
*      jsr  evals            call to evaluate string
*      ppm  loc              transfer loc for non-string arg
*      ppm  loc              transfer loc for evaluation failure
*      ppm  loc              transfer loc for successful eval
*      (the normal return is never taken)
*      (xr)                  ptr to node with parms set
*      (xl,wc,ra)            destroyed
*      on return, the node pointed to has a character table
*      pointer in parm1 and a bit mask in parm2. the proper
*      successor is stored in pthen of this node. thus it is
*      ok for merging with the normal (multi-char string) case.
{evals{prc{25,r{1,3{{entry point (recursive){19650
{{jsr{6,evalp{{{evaluate expression{19651
{{ppm{6,evls1{{{jump if evaluation fails{19652
{{mov{11,-(xs){13,pthen(xr){{save successor pointer{19653
{{mov{11,-(xs){8,wb{{save cursor{19654
{{mov{11,-(xs){7,xl{{stack result ptr for patst{19655
{{zer{8,wb{{{dummy pcode for one char string{19656
{{zer{8,wc{{{dummy pcode for expression arg{19657
{{mov{7,xl{22,=p_brk{{appropriate pcode for our use{19658
{{jsr{6,patst{{{call routine to build node{19659
{{ppm{6,evls2{{{jump if not string{19660
{{mov{8,wb{10,(xs)+{{restore cursor{19661
{{mov{13,pthen(xr){10,(xs)+{{store successor pointer{19662
{{exi{1,3{{{take success return{19663
*      here if evaluation fails
{evls1{exi{1,2{{{take failure return{19667
*      here if argument is not string
{evls2{add{7,xs{19,*num02{{pop successor and cursor{19671
{{exi{1,1{{{take non-string error exit{19672
{{enp{{{{end procedure evals{19673
{{ejc{{{{{19674
*      evalx -- evaluate expression
*      evalx is called to evaluate an expression
*      (xr)                  pointer to exblk or seblk
*      (wb)                  0 if by value, 1 if by name
*      jsr  evalx            call to evaluate expression
*      ppm  loc              transfer loc if evaluation fails
*      (xr)                  result if called by value
*      (xl,wa)               result name base,offset if by name
*      (xr)                  destroyed (name case only)
*      (xl,wa)               destroyed (value case only)
*      (wb,wc,ra)            destroyed
{evalx{prc{25,r{1,1{{entry point, recursive{19690
{{beq{9,(xr){22,=b_exl{6,evlx2{jump if exblk case{19691
*      here for seblk
{{mov{7,xl{13,sevar(xr){{load vrblk pointer (name base){19695
{{mov{8,wa{19,*vrval{{set name offset{19696
{{bnz{8,wb{6,evlx1{{jump if called by name{19697
{{jsr{6,acess{{{call routine to access value{19698
{{ppm{6,evlx9{{{jump if failure on access{19699
*      merge here to exit for seblk case
{evlx1{exi{{{{return to evalx caller{19703
{{ejc{{{{{19704
*      evalx (continued)
*      here for full expression (exblk) case
*      if an error occurs in the expression code at execution
*      time, control is passed via error section to exfal
*      without returning to this routine.
*      the following entries are made on the stack before
*      giving control to the expression code
*                            evalx return point
*                            saved value of r_cod
*                            code pointer (-r_cod)
*                            saved value of flptr
*                            0 if by value, 1 if by name
*      flptr --------------- *exflc, fail offset in exblk
{evlx2{scp{8,wc{{{get code pointer{19723
{{mov{8,wa{3,r_cod{{load code block pointer{19724
{{sub{8,wc{8,wa{{get code pointer as offset{19725
{{mov{11,-(xs){8,wa{{stack old code block pointer{19726
{{mov{11,-(xs){8,wc{{stack relative code offset{19727
{{mov{11,-(xs){3,flptr{{stack old failure pointer{19728
{{mov{11,-(xs){8,wb{{stack name/value indicator{19729
{{mov{11,-(xs){19,*exflc{{stack new fail offset{19730
{{mov{3,gtcef{3,flptr{{keep in case of error{19731
{{mov{3,r_gtc{3,r_cod{{keep code block pointer similarly{19732
{{mov{3,flptr{7,xs{{set new failure pointer{19733
{{mov{3,r_cod{7,xr{{set new code block pointer{19734
{{mov{13,exstm(xr){3,kvstn{{remember stmnt number{19735
{{add{7,xr{19,*excod{{point to first code word{19736
{{lcp{7,xr{{{set code pointer{19737
{{bne{3,stage{18,=stgxt{6,evlx0{jump if not execution time{19738
{{mov{3,stage{18,=stgee{{evaluating expression{19739
*      here to execute first code word of expression
{evlx0{zer{7,xl{{{clear garbage xl{19743
{{lcw{7,xr{{{load first code word{19744
{{bri{9,(xr){{{execute it{19745
{{ejc{{{{{19746
*      evalx (continued)
*      come here if successful return by value (see o_rvl)
{evlx3{mov{7,xr{10,(xs)+{{load value{19752
{{bze{13,num01(xs){6,evlx5{{jump if called by value{19753
{{erb{1,249{26,expression evaluated by name returned value{{{19754
*      here for expression returning by name (see o_rnm)
{evlx4{mov{8,wa{10,(xs)+{{load name offset{19758
{{mov{7,xl{10,(xs)+{{load name base{19759
{{bnz{13,num01(xs){6,evlx5{{jump if called by name{19760
{{jsr{6,acess{{{else access value first{19761
{{ppm{6,evlx6{{{jump if failure during access{19762
*      here after loading correct result into xr or xl,wa
{evlx5{zer{8,wb{{{note successful{19766
{{brn{6,evlx7{{{merge{19767
*      here for failure in expression evaluation (see o_fex)
{evlx6{mnz{8,wb{{{note unsuccessful{19771
*      restore environment
{evlx7{bne{3,stage{18,=stgee{6,evlx8{skip if was not previously xt{19775
{{mov{3,stage{18,=stgxt{{execute time{19776
*      merge with stage set up
{evlx8{add{7,xs{19,*num02{{pop name/value indicator, *exfal{19780
{{mov{3,flptr{10,(xs)+{{restore old failure pointer{19781
{{mov{8,wc{10,(xs)+{{load code offset{19782
{{add{8,wc{9,(xs){{make code pointer absolute{19783
{{mov{3,r_cod{10,(xs)+{{restore old code block pointer{19784
{{lcp{8,wc{{{restore old code pointer{19785
{{bze{8,wb{6,evlx1{{jump for successful return{19786
*      merge here for failure in seblk case
{evlx9{exi{1,1{{{take failure exit{19790
{{enp{{{{end of procedure evalx{19791
{{ejc{{{{{19792
*      exbld -- build exblk
*      exbld is used to build an expression block from the
*      code compiled most recently in the current ccblk.
*      (xl)                  offset in ccblk to start of code
*      (wb)                  integer in range 0 le n le mxlen
*      jsr  exbld            call to build exblk
*      (xr)                  ptr to constructed exblk
*      (wa,wb,xl)            destroyed
{exbld{prc{25,e{1,0{{entry point{19805
{{mov{8,wa{7,xl{{copy offset to start of code{19806
{{sub{8,wa{19,*excod{{calc reduction in offset in exblk{19807
{{mov{11,-(xs){8,wa{{stack for later{19808
{{mov{8,wa{3,cwcof{{load final offset{19809
{{sub{8,wa{7,xl{{compute length of code{19810
{{add{8,wa{19,*exsi_{{add space for standard fields{19811
{{jsr{6,alloc{{{allocate space for exblk{19812
{{mov{11,-(xs){7,xr{{save pointer to exblk{19813
{{mov{13,extyp(xr){22,=b_exl{{store type word{19814
{{zer{13,exstm(xr){{{zeroise stmnt number field{19815
{{mov{13,exsln(xr){3,cmpln{{set line number field{19817
{{mov{13,exlen(xr){8,wa{{store length{19819
{{mov{13,exflc(xr){21,=ofex_{{store failure word{19820
{{add{7,xr{19,*exsi_{{set xr for mvw{19821
{{mov{3,cwcof{7,xl{{reset offset to start of code{19822
{{add{7,xl{3,r_ccb{{point to start of code{19823
{{sub{8,wa{19,*exsi_{{length of code to move{19824
{{mov{11,-(xs){8,wa{{stack length of code{19825
{{mvw{{{{move code to exblk{19826
{{mov{8,wa{10,(xs)+{{get length of code{19827
{{btw{8,wa{{{convert byte count to word count{19828
{{lct{8,wa{8,wa{{prepare counter for loop{19829
{{mov{7,xl{9,(xs){{copy exblk ptr, dont unstack{19830
{{add{7,xl{19,*excod{{point to code itself{19831
{{mov{8,wb{13,num01(xs){{get reduction in offset{19832
*      this loop searches for negation and selection code so
*      that the offsets computed whilst code was in code block
*      can be transformed to reduced values applicable in an
*      exblk.
{exbl1{mov{7,xr{10,(xl)+{{get next code word{19839
{{beq{7,xr{21,=osla_{6,exbl3{jump if selection found{19840
{{beq{7,xr{21,=onta_{6,exbl3{jump if negation found{19841
{{bct{8,wa{6,exbl1{{loop to end of code{19842
*      no selection found or merge to exit on termination
{exbl2{mov{7,xr{10,(xs)+{{pop exblk ptr into xr{19846
{{mov{7,xl{10,(xs)+{{pop reduction constant{19847
{{exi{{{{return to caller{19848
{{ejc{{{{{19849
*      exbld (continued)
*      selection or negation found
*      reduce the offsets as needed. offsets occur in words
*      following code words -
*           =onta_, =osla_, =oslb_, =oslc_
{exbl3{sub{10,(xl)+{8,wb{{adjust offset{19858
{{bct{8,wa{6,exbl4{{decrement count{19859
{exbl4{bct{8,wa{6,exbl5{{decrement count{19861
*      continue search for more offsets
{exbl5{mov{7,xr{10,(xl)+{{get next code word{19865
{{beq{7,xr{21,=osla_{6,exbl3{jump if offset found{19866
{{beq{7,xr{21,=oslb_{6,exbl3{jump if offset found{19867
{{beq{7,xr{21,=oslc_{6,exbl3{jump if offset found{19868
{{beq{7,xr{21,=onta_{6,exbl3{jump if offset found{19869
{{bct{8,wa{6,exbl5{{loop{19870
{{brn{6,exbl2{{{merge to return{19871
{{enp{{{{end procedure exbld{19872
{{ejc{{{{{19873
*      expan -- analyze expression
*      the expression analyzer (expan) procedure is used to scan
*      an expression and convert it into a tree representation.
*      see the description of cmblk in the structures section
*      for detailed format of tree blocks.
*      the analyzer uses a simple precedence scheme in which
*      operands and operators are placed on a single stack
*      and condensations are made when low precedence operators
*      are stacked after a higher precedence operator. a global
*      variable (in wb) keeps track of the level as follows.
*      0    scanning outer level of statement or expression
*      1    scanning outer level of normal goto
*      2    scanning outer level of direct goto
*      3    scanning inside array brackets
*      4    scanning inside grouping parentheses
*      5    scanning inside function parentheses
*      this variable is saved on the stack on encountering a
*      grouping and restored at the end of the grouping.
*      another global variable (in wc) counts the number of
*      items at one grouping level and is incremented for each
*      comma encountered. it is stacked with the level indicator
*      the scan is controlled by a three state finite machine.
*      a global variable stored in wa is the current state.
*      wa=0                  nothing scanned at this level
*      wa=1                  operand expected
*      wa=2                  operator expected
*      (wb)                  call type (see below)
*      jsr  expan            call to analyze expression
*      (xr)                  pointer to resulting tree
*      (xl,wa,wb,wc,ra)      destroyed
*      the entry value of wb indicates the call type as follows.
*      0    scanning either the main body of a statement or the
*           text of an expression (from eval call). valid
*           terminators are colon, semicolon. the rescan flag is
*           set to return the terminator on the next scane call.
*      1    scanning a normal goto. the only valid
*           terminator is a right paren.
*      2    scanning a direct goto. the only valid
*           terminator is a right bracket.
{{ejc{{{{{19926
*      expan (continued)
*      entry point
{expan{prc{25,e{1,0{{entry point{19932
{{zer{11,-(xs){{{set top of stack indicator{19933
{{zer{8,wa{{{set initial state to zero{19934
{{zer{8,wc{{{zero counter value{19935
*      loop here for successive entries
{exp01{jsr{6,scane{{{scan next element{19939
{{add{7,xl{8,wa{{add state to syntax code{19940
{{bsw{7,xl{2,t_nes{{switch on element type/state{19941
{{iff{2,t_uo0{6,exp27{{unop, s=0{19978
{{iff{2,t_uo1{6,exp27{{unop, s=1{19978
{{iff{2,t_uo2{6,exp04{{unop, s=2{19978
{{iff{2,t_lp0{6,exp06{{left paren, s=0{19978
{{iff{2,t_lp1{6,exp06{{left paren, s=1{19978
{{iff{2,t_lp2{6,exp04{{left paren, s=2{19978
{{iff{2,t_lb0{6,exp08{{left brkt, s=0{19978
{{iff{2,t_lb1{6,exp08{{left brkt, s=1{19978
{{iff{2,t_lb2{6,exp09{{left brkt, s=2{19978
{{iff{2,t_cm0{6,exp02{{comma, s=0{19978
{{iff{2,t_cm1{6,exp05{{comma, s=1{19978
{{iff{2,t_cm2{6,exp11{{comma, s=2{19978
{{iff{2,t_fn0{6,exp10{{function, s=0{19978
{{iff{2,t_fn1{6,exp10{{function, s=1{19978
{{iff{2,t_fn2{6,exp04{{function, s=2{19978
{{iff{2,t_va0{6,exp03{{variable, s=0{19978
{{iff{2,t_va1{6,exp03{{variable, state one{19978
{{iff{2,t_va2{6,exp04{{variable, s=2{19978
{{iff{2,t_co0{6,exp03{{constant, s=0{19978
{{iff{2,t_co1{6,exp03{{constant, s=1{19978
{{iff{2,t_co2{6,exp04{{constant, s=2{19978
{{iff{2,t_bo0{6,exp05{{binop, s=0{19978
{{iff{2,t_bo1{6,exp05{{binop, s=1{19978
{{iff{2,t_bo2{6,exp26{{binop, s=2{19978
{{iff{2,t_rp0{6,exp02{{right paren, s=0{19978
{{iff{2,t_rp1{6,exp05{{right paren, s=1{19978
{{iff{2,t_rp2{6,exp12{{right paren, s=2{19978
{{iff{2,t_rb0{6,exp02{{right brkt, s=0{19978
{{iff{2,t_rb1{6,exp05{{right brkt, s=1{19978
{{iff{2,t_rb2{6,exp18{{right brkt, s=2{19978
{{iff{2,t_cl0{6,exp02{{colon, s=0{19978
{{iff{2,t_cl1{6,exp05{{colon, s=1{19978
{{iff{2,t_cl2{6,exp19{{colon, s=2{19978
{{iff{2,t_sm0{6,exp02{{semicolon, s=0{19978
{{iff{2,t_sm1{6,exp05{{semicolon, s=1{19978
{{iff{2,t_sm2{6,exp19{{semicolon, s=2{19978
{{esw{{{{end switch on element type/state{19978
{{ejc{{{{{19979
*      expan (continued)
*      here for rbr,rpr,col,smc,cma in state 0
*      set to rescan the terminator encountered and create
*      a null constant (case of omitted null)
{exp02{mnz{3,scnrs{{{set to rescan element{19988
{{mov{7,xr{21,=nulls{{point to null, merge{19989
*      here for var or con in states 0,1
*      stack the variable/constant and set state=2
{exp03{mov{11,-(xs){7,xr{{stack pointer to operand{19995
{{mov{8,wa{18,=num02{{set state 2{19996
{{brn{6,exp01{{{jump for next element{19997
*      here for var,con,lpr,fnc,uop in state 2
*      we rescan the element and create a concatenation operator
*      this is the case of the blank concatenation operator.
{exp04{mnz{3,scnrs{{{set to rescan element{20004
{{mov{7,xr{21,=opdvc{{point to concat operator dv{20005
{{bze{8,wb{6,exp4a{{ok if at top level{20006
{{mov{7,xr{21,=opdvp{{else point to unmistakable concat.{20007
*      merge here when xr set up with proper concatenation dvblk
{exp4a{bnz{3,scnbl{6,exp26{{merge bop if blanks, else error{20011
*      dcv  scnse            adjust start of element location
{{erb{1,220{26,syntax error: missing operator{{{20013
*      here for cma,rpr,rbr,col,smc,bop(s=1) bop(s=0)
*      this is an erronous contruction
*exp05 dcv  scnse            adjust start of element location
{exp05{erb{1,221{26,syntax error: missing operand{{{20021
*      here for lpr (s=0,1)
{exp06{mov{7,xl{18,=num04{{set new level indicator{20025
{{zer{7,xr{{{set zero value for cmopn{20026
{{ejc{{{{{20027
*      expan (continued)
*      merge here to store old level on stack and start new one
{exp07{mov{11,-(xs){7,xr{{stack cmopn value{20033
{{mov{11,-(xs){8,wc{{stack old counter{20034
{{mov{11,-(xs){8,wb{{stack old level indicator{20035
{{chk{{{{check for stack overflow{20036
{{zer{8,wa{{{set new state to zero{20037
{{mov{8,wb{7,xl{{set new level indicator{20038
{{mov{8,wc{18,=num01{{initialize new counter{20039
{{brn{6,exp01{{{jump to scan next element{20040
*      here for lbr (s=0,1)
*      this is an illegal use of left bracket
{exp08{erb{1,222{26,syntax error: invalid use of left bracket{{{20046
*      here for lbr (s=2)
*      set new level and start to scan subscripts
{exp09{mov{7,xr{10,(xs)+{{load array ptr for cmopn{20052
{{mov{7,xl{18,=num03{{set new level indicator{20053
{{brn{6,exp07{{{jump to stack old and start new{20054
*      here for fnc (s=0,1)
*      stack old level and start to scan arguments
{exp10{mov{7,xl{18,=num05{{set new lev indic (xr=vrblk=cmopn){20060
{{brn{6,exp07{{{jump to stack old and start new{20061
*      here for cma (s=2)
*      increment argument count and continue
{exp11{icv{8,wc{{{increment counter{20067
{{jsr{6,expdm{{{dump operators at this level{20068
{{zer{11,-(xs){{{set new level for parameter{20069
{{zer{8,wa{{{set new state{20070
{{bgt{8,wb{18,=num02{6,exp01{loop back unless outer level{20071
{{erb{1,223{26,syntax error: invalid use of comma{{{20072
{{ejc{{{{{20073
*      expan (continued)
*      here for rpr (s=2)
*      at outer level in a normal goto this is a terminator
*      otherwise it must terminate a function or grouping
{exp12{beq{8,wb{18,=num01{6,exp20{end of normal goto{20082
{{beq{8,wb{18,=num05{6,exp13{end of function arguments{20083
{{beq{8,wb{18,=num04{6,exp14{end of grouping / selection{20084
{{erb{1,224{26,syntax error: unbalanced right parenthesis{{{20085
*      here at end of function arguments
{exp13{mov{7,xl{18,=c_fnc{{set cmtyp value for function{20089
{{brn{6,exp15{{{jump to build cmblk{20090
*      here for end of grouping
{exp14{beq{8,wc{18,=num01{6,exp17{jump if end of grouping{20094
{{mov{7,xl{18,=c_sel{{else set cmtyp for selection{20095
*      merge here to build cmblk for level just scanned and
*      to pop up to the previous scan level before continuing.
{exp15{jsr{6,expdm{{{dump operators at this level{20100
{{mov{8,wa{8,wc{{copy count{20101
{{add{8,wa{18,=cmvls{{add for standard fields at start{20102
{{wtb{8,wa{{{convert length to bytes{20103
{{jsr{6,alloc{{{allocate space for cmblk{20104
{{mov{9,(xr){22,=b_cmt{{store type code for cmblk{20105
{{mov{13,cmtyp(xr){7,xl{{store cmblk node type indicator{20106
{{mov{13,cmlen(xr){8,wa{{store length{20107
{{add{7,xr{8,wa{{point past end of block{20108
{{lct{8,wc{8,wc{{set loop counter{20109
*      loop to move remaining words to cmblk
{exp16{mov{11,-(xr){10,(xs)+{{move one operand ptr from stack{20113
{{mov{8,wb{10,(xs)+{{pop to old level indicator{20114
{{bct{8,wc{6,exp16{{loop till all moved{20115
{{ejc{{{{{20116
*      expan (continued)
*      complete cmblk and stack pointer to it on stack
{{sub{7,xr{19,*cmvls{{point back to start of block{20122
{{mov{8,wc{10,(xs)+{{restore old counter{20123
{{mov{13,cmopn(xr){9,(xs){{store operand ptr in cmblk{20124
{{mov{9,(xs){7,xr{{stack cmblk pointer{20125
{{mov{8,wa{18,=num02{{set new state{20126
{{brn{6,exp01{{{back for next element{20127
*      here at end of a parenthesized expression
{exp17{jsr{6,expdm{{{dump operators at this level{20131
{{mov{7,xr{10,(xs)+{{restore xr{20132
{{mov{8,wb{10,(xs)+{{restore outer level{20133
{{mov{8,wc{10,(xs)+{{restore outer count{20134
{{mov{9,(xs){7,xr{{store opnd over unused cmopn val{20135
{{mov{8,wa{18,=num02{{set new state{20136
{{brn{6,exp01{{{back for next ele8ent{20137
*      here for rbr (s=2)
*      at outer level in a direct goto, this is a terminator.
*      otherwise it must terminate a subscript list.
{exp18{mov{7,xl{18,=c_arr{{set cmtyp for array reference{20144
{{beq{8,wb{18,=num03{6,exp15{jump to build cmblk if end arrayref{20145
{{beq{8,wb{18,=num02{6,exp20{jump if end of direct goto{20146
{{erb{1,225{26,syntax error: unbalanced right bracket{{{20147
{{ejc{{{{{20148
*      expan (continued)
*      here for col,smc (s=2)
*      error unless terminating statement body at outer level
{exp19{mnz{3,scnrs{{{rescan terminator{20156
{{mov{7,xl{8,wb{{copy level indicator{20157
{{bsw{7,xl{1,6{{switch on level indicator{20158
{{iff{1,0{6,exp20{{normal outer level{20165
{{iff{1,1{6,exp22{{fail if normal goto{20165
{{iff{1,2{6,exp23{{fail if direct goto{20165
{{iff{1,3{6,exp24{{fail array brackets{20165
{{iff{1,4{6,exp21{{fail if in grouping{20165
{{iff{1,5{6,exp21{{fail function args{20165
{{esw{{{{end switch on level{20165
*      here at normal end of expression
{exp20{jsr{6,expdm{{{dump remaining operators{20169
{{mov{7,xr{10,(xs)+{{load tree pointer{20170
{{ica{7,xs{{{pop off bottom of stack marker{20171
{{exi{{{{return to expan caller{20172
*      missing right paren
{exp21{erb{1,226{26,syntax error: missing right paren{{{20176
*      missing right paren in goto field
{exp22{erb{1,227{26,syntax error: right paren missing from goto{{{20180
*      missing bracket in goto
{exp23{erb{1,228{26,syntax error: right bracket missing from goto{{{20184
*      missing array bracket
{exp24{erb{1,229{26,syntax error: missing right array bracket{{{20188
{{ejc{{{{{20189
*      expan (continued)
*      loop here when an operator causes an operator dump
{exp25{mov{3,expsv{7,xr{{{20195
{{jsr{6,expop{{{pop one operator{20196
{{mov{7,xr{3,expsv{{restore op dv pointer and merge{20197
*      here for bop (s=2)
*      remove operators (condense) from stack until no more
*      left at this level or top one has lower precedence.
*      loop here till this condition is met.
{exp26{mov{7,xl{13,num01(xs){{load operator dvptr from stack{20205
{{ble{7,xl{18,=num05{6,exp27{jump if bottom of stack level{20206
{{blt{13,dvrpr(xr){13,dvlpr(xl){6,exp25{else pop if new prec is lo{20207
*      here for uop (s=0,1)
*      binary operator merges after precedence check
*      the operator dv is stored on the stack and the scan
*      continues after setting the scan state to one.
{exp27{mov{11,-(xs){7,xr{{stack operator dvptr on stack{20216
{{chk{{{{check for stack overflow{20217
{{mov{8,wa{18,=num01{{set new state{20218
{{bne{7,xr{21,=opdvs{6,exp01{back for next element unless ={20219
*      here for special case of binary =. the syntax allows a
*      null right argument for this operator to be left
*      out. accordingly we reset to state zero to get proper
*      action on a terminator (supply a null constant).
{{zer{8,wa{{{set state zero{20226
{{brn{6,exp01{{{jump for next element{20227
{{enp{{{{end procedure expan{20228
{{ejc{{{{{20229
*      expap -- test for pattern match tree
*      expap is passed an expression tree to determine if it
*      is a pattern match. the following are recogized as
*      matches in the context of this call.
*      1)   an explicit use of binary question mark
*      2)   a concatenation
*      3)   an alternation whose left operand is a concatenation
*      (xr)                  ptr to expan tree
*      jsr  expap            call to test for pattern match
*      ppm  loc              transfer loc if not a pattern match
*      (wa)                  destroyed
*      (xr)                  unchanged (if not match)
*      (xr)                  ptr to binary operator blk if match
{expap{prc{25,e{1,1{{entry point{20248
{{mov{11,-(xs){7,xl{{save xl{20249
{{bne{9,(xr){22,=b_cmt{6,expp2{no match if not complex{20250
{{mov{8,wa{13,cmtyp(xr){{else load type code{20251
{{beq{8,wa{18,=c_cnc{6,expp1{concatenation is a match{20252
{{beq{8,wa{18,=c_pmt{6,expp1{binary question mark is a match{20253
{{bne{8,wa{18,=c_alt{6,expp2{else not match unless alternation{20254
*      here for alternation. change (a b) / c to a qm (b / c)
{{mov{7,xl{13,cmlop(xr){{load left operand pointer{20258
{{bne{9,(xl){22,=b_cmt{6,expp2{not match if left opnd not complex{20259
{{bne{13,cmtyp(xl){18,=c_cnc{6,expp2{not match if left op not conc{20260
{{mov{13,cmlop(xr){13,cmrop(xl){{xr points to (b / c){20261
{{mov{13,cmrop(xl){7,xr{{set xl opnds to a, (b / c){20262
{{mov{7,xr{7,xl{{point to this altered node{20263
*      exit here for pattern match
{expp1{mov{7,xl{10,(xs)+{{restore entry xl{20267
{{exi{{{{give pattern match return{20268
*      exit here if not pattern match
{expp2{mov{7,xl{10,(xs)+{{restore entry xl{20272
{{exi{1,1{{{give non-match return{20273
{{enp{{{{end procedure expap{20274
{{ejc{{{{{20275
*      expdm -- dump operators at current level (for expan)
*      expdm uses expop to condense all operators at this syntax
*      level. the stack bottom is recognized from the level
*      value which is saved on the top of the stack.
*      jsr  expdm            call to dump operators
*      (xs)                  popped as required
*      (xr,wa)               destroyed
{expdm{prc{25,n{1,0{{entry point{20287
{{mov{3,r_exs{7,xl{{save xl value{20288
*      loop to dump operators
{exdm1{ble{13,num01(xs){18,=num05{6,exdm2{jump if stack bottom (saved level{20292
{{jsr{6,expop{{{else pop one operator{20293
{{brn{6,exdm1{{{and loop back{20294
*      here after popping all operators
{exdm2{mov{7,xl{3,r_exs{{restore xl{20298
{{zer{3,r_exs{{{release save location{20299
{{exi{{{{return to expdm caller{20300
{{enp{{{{end procedure expdm{20301
{{ejc{{{{{20302
*      expop-- pop operator (for expan)
*      expop is used by the expan routine to condense one
*      operator from the top of the syntax stack. an appropriate
*      cmblk is built for the operator (unary or binary) and a
*      pointer to this cmblk is stacked.
*      expop is also used by scngf (goto field scan) procedure
*      jsr  expop            call to pop operator
*      (xs)                  popped appropriately
*      (xr,xl,wa)            destroyed
{expop{prc{25,n{1,0{{entry point{20317
{{mov{7,xr{13,num01(xs){{load operator dv pointer{20318
{{beq{13,dvlpr(xr){18,=lluno{6,expo2{jump if unary{20319
*      here for binary operator
{{mov{8,wa{19,*cmbs_{{set size of binary operator cmblk{20323
{{jsr{6,alloc{{{allocate space for cmblk{20324
{{mov{13,cmrop(xr){10,(xs)+{{pop and store right operand ptr{20325
{{mov{7,xl{10,(xs)+{{pop and load operator dv ptr{20326
{{mov{13,cmlop(xr){9,(xs){{store left operand pointer{20327
*      common exit point
{expo1{mov{9,(xr){22,=b_cmt{{store type code for cmblk{20331
{{mov{13,cmtyp(xr){13,dvtyp(xl){{store cmblk node type code{20332
{{mov{13,cmopn(xr){7,xl{{store dvptr (=ptr to dac o_xxx){20333
{{mov{13,cmlen(xr){8,wa{{store cmblk length{20334
{{mov{9,(xs){7,xr{{store resulting node ptr on stack{20335
{{exi{{{{return to expop caller{20336
*      here for unary operator
{expo2{mov{8,wa{19,*cmus_{{set size of unary operator cmblk{20340
{{jsr{6,alloc{{{allocate space for cmblk{20341
{{mov{13,cmrop(xr){10,(xs)+{{pop and store operand pointer{20342
{{mov{7,xl{9,(xs){{load operator dv pointer{20343
{{brn{6,expo1{{{merge back to exit{20344
{{enp{{{{end procedure expop{20345
{{ejc{{{{{20346
*      filnm -- obtain file name from statement number
*      filnm takes a statement number and examines the file name
*      table pointed to by r_sfn to find the name of the file
*      containing the given statement.  table entries are
*      arranged in order of ascending statement number (there
*      is only one hash bucket in this table).  elements are
*      added to the table each time there is a change in
*      file name, recording the then current statement number.
*      to find the file name, the linked list of teblks is
*      scanned for an element containing a subscript (statement
*      number) greater than the argument statement number, or
*      the end of chain.  when this condition is met, the
*      previous teblk contains the desired file name as its
*      value entry.
*      (wc)                  statement number
*      jsr  filnm            call to obtain file name
*      (xl)                  file name (scblk)
*      (ia)                  destroyed
{filnm{prc{25,e{1,0{{entry point{20371
{{mov{11,-(xs){8,wb{{preserve wb{20372
{{bze{8,wc{6,filn3{{return nulls if stno is zero{20373
{{mov{7,xl{3,r_sfn{{file name table{20374
{{bze{7,xl{6,filn3{{if no table{20375
{{mov{8,wb{13,tbbuk(xl){{get bucket entry{20376
{{beq{8,wb{3,r_sfn{6,filn3{jump if no teblks on chain{20377
{{mov{11,-(xs){7,xr{{preserve xr{20378
{{mov{7,xr{8,wb{{previous block pointer{20379
{{mov{11,-(xs){8,wc{{preserve stmt number{20380
*      loop through teblks on hash chain
{filn1{mov{7,xl{7,xr{{next element to examine{20384
{{mov{7,xr{13,tesub(xl){{load subscript value (an icblk){20385
{{ldi{13,icval(xr){{{load the statement number{20386
{{mfi{8,wc{{{convert to address constant{20387
{{blt{9,(xs){8,wc{6,filn2{compare arg with teblk stmt number{20388
*      here if desired stmt number is ge teblk stmt number
{{mov{8,wb{7,xl{{save previous entry pointer{20392
{{mov{7,xr{13,tenxt(xl){{point to next teblk on chain{20393
{{bne{7,xr{3,r_sfn{6,filn1{jump if there is one{20394
*      here if chain exhausted or desired block found.
{filn2{mov{7,xl{8,wb{{previous teblk{20398
{{mov{7,xl{13,teval(xl){{get ptr to file name scblk{20399
{{mov{8,wc{10,(xs)+{{restore stmt number{20400
{{mov{7,xr{10,(xs)+{{restore xr{20401
{{mov{8,wb{10,(xs)+{{restore wb{20402
{{exi{{{{{20403
*      no table or no table entries
{filn3{mov{8,wb{10,(xs)+{{restore wb{20407
{{mov{7,xl{21,=nulls{{return null string{20408
{{exi{{{{{20409
{{enp{{{{{20410
{{ejc{{{{{20411
*      gbcol -- perform garbage collection
*      gbcol performs a garbage collection on the dynamic region
*      all blocks which are no longer in use are eliminated
*      by moving blocks which are in use down and resetting
*      dnamp, the pointer to the next available location.
*      (wb)                  move offset (see below)
*      jsr  gbcol            call to collect garbage
*      (xr)                  sediment size after collection
*      the following conditions must be met at the time when
*      gbcol is called.
*      1)   all pointers to blocks in the dynamic area must be
*           accessible to the garbage collector. this means
*           that they must occur in one of the following.
*           a)               main stack, with current top
*                            element being indicated by xs
*           b)               in relocatable fields of vrblks.
*           c)               in register xl at the time of call
*           e)               in the special region of working
*                            storage where names begin with r_.
*      2)   all pointers must point to the start of blocks with
*           the sole exception of the contents of the code
*           pointer register which points into the r_cod block.
*      3)   no location which appears to contain a pointer
*           into the dynamic region may occur unless it is in
*           fact a pointer to the start of the block. however
*           pointers outside this area may occur and will
*           not be changed by the garbage collector.
*           it is especially important to make sure that xl
*           does not contain a garbage value from some process
*           carried out before the call to the collector.
*      gbcol has the capability of moving the final compacted
*      result up in memory (with addresses adjusted accordingly)
*      this is used to add space to the static region. the
*      entry value of wb is the number of bytes to move up.
*      the caller must guarantee that there is enough room.
*      furthermore the value in wb if it is non-zero, must be at
*      least 256 so that the mwb instruction conditions are met.
{{ejc{{{{{20513
*      gbcol (continued)
*      the algorithm, which is a modification of the lisp-2
*      garbage collector devised by r.dewar and k.belcher
*      takes three passes as follows.
*      1)   all pointers in memory are scanned and blocks in use
*           determined from this scan. note that this procedure
*           is recursive and uses the main stack for linkage.
*           the marking process is thus similar to that used in
*           a standard lisp collector. however the method of
*           actually marking the blocks is different.
*           the first field of a block normally contains a
*           code entry point pointer. such an entry pointer
*           can be distinguished from the address of any pointer
*           to be processed by the collector. during garbage
*           collection, this word is used to build a back chain
*           of pointers through fields which point to the block.
*           the end of the chain is marked by the occurence
*           of the word which used to be in the first word of
*           the block. this backchain serves both as a mark
*           indicating that the block is in use and as a list of
*           references for the relocation phase.
*      2)   storage is scanned sequentially to discover which
*           blocks are currently in use as indicated by the
*           presence of a backchain. two pointers are maintained
*           one scans through looking at each block. the other
*           is incremented only for blocks found to be in use.
*           in this way, the eventual location of each block can
*           be determined without actually moving any blocks.
*           as each block which is in use is processed, the back
*           chain is used to reset all pointers which point to
*           this block to contain its new address, i.e. the
*           address it will occupy after the blocks are moved.
*           the first word of the block, taken from the end of
*           the chain is restored at this point.
*           during pass 2, the collector builds blocks which
*           describe the regions of storage which are to be
*           moved in the third pass. there is one descriptor for
*           each contiguous set of good blocks. the descriptor
*           is built just behind the block to be moved and
*           contains a pointer to the next block and the number
*           of words to be moved.
*      3)   in the third and final pass, the move descriptor
*           blocks built in pass two are used to actually move
*           the blocks down to the bottom of the dynamic region.
*           the collection is then complete and the next
*           available location pointer is reset.
{{ejc{{{{{20567
*      gbcol (continued)
*      the garbage collector also recognizes the concept of
*      sediment.  sediment is defined as long-lived objects
*      which percipitate to the bottom of dynamic storage.
*      moving these objects during repeated collections is
*      inefficient.  it also contributes to thrashing on
*      systems with virtual memory.  in a typical worst-case
*      situation, there may be several megabytes of live objects
*      in the sediment, and only a few dead objects in need of
*      collection.  without recognising sediment, the standard
*      collector would move those megabytes of objects downward
*      to squeeze out the dead objects.  this type of move
*      would result in excessive thrasing for very little memory
*      gain.
*      scanning of blocks in the sediment cannot be avoided
*      entirely, because these blocks may contain pointers to
*      live objects above the sediment.  however, sediment
*      blocks need not be linked to a back chain as described
*      in pass one above.  since these blocks will not be moved,
*      pointers to them do not need to be adjusted.  eliminating
*      unnecessary back chain links increases locality of
*      reference, improving virtual memory performance.
*      because back chains are used to mark blocks whose con-
*      tents have been processed, a different marking system
*      is needed for blocks in the sediment.  since block type
*      words point to odd-parity entry addresses, merely incre-
*      menting the type word serves to mark the block as pro-
*      cessed.  during pass three, the type words are decre-
*      mented to restore them to their original value.
{{ejc{{{{{20611
*      gbcol (continued)
*      the variable dnams contains the number of bytes of memory
*      currently in the sediment.  setting dnams to zero will
*      eliminate the sediment and force it to be included in a
*      full garbage collection.  gbcol returns a suggested new
*      value for dnams (usually dnamp-dnamb) in xr which the
*      caller can store in dnams if it wishes to maintain the
*      sediment.  that is, data remaining after a garbage
*      collection is considered to be sediment.  if one accepts
*      the common lore that most objects are either very short-
*      or very long-lived, then this naive setting of dnams
*      probably includes some short-lived objects toward the end
*      of the sediment.
*      knowing when to reset dnams to zero to collect the sedi-
*      ment is not precisely known.  we force it to zero prior
*      to producing a dump, when gbcol is invoked by collect()
*      (so that the sediment is invisible to the user), when
*      sysmm is unable to obtain additional memory, and when
*      gbcol is called to relocate the dynamic area up in memory
*      (to make room for enlarging the static area).  if there
*      are no other reset situations, this leads to the inexo-
*      rable growth of the sediment, possible forcing a modest
*      program to begin to use virtual memory that it otherwise
*      would not.
*      as we scan sediment blocks in pass three, we maintain
*      aggregate counts of the amount of dead and live storage,
*      which is used to decide when to reset dnams.  when the
*      ratio of free storage found in the sediment to total
*      sediment size exceeds a threshold, the sediment is marked
*      for collection on the next gbcol call.
{{ejc{{{{{20649
*      gbcol (continued)
{gbcol{prc{25,e{1,0{{entry point{20653
*z-
{{bnz{3,dmvch{6,gbc14{{fail if in mid-dump{20655
{{mnz{3,gbcfl{{{note gbcol entered{20656
{{mov{3,gbsva{8,wa{{save entry wa{20657
{{mov{3,gbsvb{8,wb{{save entry wb{20658
{{mov{3,gbsvc{8,wc{{save entry wc{20659
{{mov{11,-(xs){7,xl{{save entry xl{20660
{{scp{8,wa{{{get code pointer value{20661
{{sub{8,wa{3,r_cod{{make relative{20662
{{lcp{8,wa{{{and restore{20663
{{bze{8,wb{6,gbc0a{{check there is no move offset{20665
{{zer{3,dnams{{{collect sediment if must move it{20666
{gbc0a{mov{8,wa{3,dnamb{{start of dynamic area{20667
{{add{8,wa{3,dnams{{size of sediment{20668
{{mov{3,gbcsd{8,wa{{first location past sediment{20669
*      inform sysgc that collection to commence
{{mnz{7,xr{{{non-zero flags start of collection{20682
{{mov{8,wa{3,dnamb{{start of dynamic area{20683
{{mov{8,wb{3,dnamp{{next available location{20684
{{mov{8,wc{3,dname{{last available location + 1{20685
{{jsr{6,sysgc{{{inform of collection{20686
*      process stack entries
{{mov{7,xr{7,xs{{point to stack front{20691
{{mov{7,xl{3,stbas{{point past end of stack{20692
{{bge{7,xl{7,xr{6,gbc00{ok if d-stack{20693
{{mov{7,xr{7,xl{{reverse if ...{20694
{{mov{7,xl{7,xs{{... u-stack{20695
*      process the stack
{gbc00{jsr{6,gbcpf{{{process pointers on stack{20699
*      process special work locations
{{mov{7,xr{20,=r_aaa{{point to start of relocatable locs{20703
{{mov{7,xl{20,=r_yyy{{point past end of relocatable locs{20704
{{jsr{6,gbcpf{{{process work fields{20705
*      prepare to process variable blocks
{{mov{8,wa{3,hshtb{{point to first hash slot pointer{20709
*      loop through hash slots
{gbc01{mov{7,xl{8,wa{{point to next slot{20713
{{ica{8,wa{{{bump bucket pointer{20714
{{mov{3,gbcnm{8,wa{{save bucket pointer{20715
{{ejc{{{{{20716
*      gbcol (continued)
*      loop through variables on one hash chain
{gbc02{mov{7,xr{9,(xl){{load ptr to next vrblk{20722
{{bze{7,xr{6,gbc03{{jump if end of chain{20723
{{mov{7,xl{7,xr{{else copy vrblk pointer{20724
{{add{7,xr{19,*vrval{{point to first reloc fld{20725
{{add{7,xl{19,*vrnxt{{point past last (and to link ptr){20726
{{jsr{6,gbcpf{{{process reloc fields in vrblk{20727
{{brn{6,gbc02{{{loop back for next block{20728
*      here at end of one hash chain
{gbc03{mov{8,wa{3,gbcnm{{restore bucket pointer{20732
{{bne{8,wa{3,hshte{6,gbc01{loop back if more buckets to go{20733
{{ejc{{{{{20734
*      gbcol (continued)
*      now we are ready to start pass two. registers are used
*      as follows in pass two.
*      (xr)                  scans through all blocks
*      (wc)                  pointer to eventual location
*      the move description blocks built in this pass have
*      the following format.
*      word 1                pointer to next move block,
*                            zero if end of chain of blocks
*      word 2                length of blocks to be moved in
*                            bytes. set to the address of the
*                            first byte while actually scanning
*                            the blocks.
*      the first entry on this chain is a special entry
*      consisting of the two words gbcnm and gbcns. after
*      building the chain of move descriptors, gbcnm points to
*      the first real move block, and gbcns is the length of
*      blocks in use at the start of storage which need not
*      be moved since they are in the correct position.
{{mov{7,xr{3,dnamb{{point to first block{20763
{{zer{8,wb{{{accumulate size of dead blocks{20764
{gbc04{beq{7,xr{3,gbcsd{6,gbc4c{jump if end of sediment{20765
{{mov{8,wa{9,(xr){{else get first word{20766
{{bod{8,wa{6,gbc4b{{jump if entry pointer (unused){20768
{{dcv{8,wa{{{restore entry pointer{20769
{{mov{9,(xr){8,wa{{restore first word{20775
{{jsr{6,blkln{{{get length of this block{20776
{{add{7,xr{8,wa{{bump actual pointer{20777
{{brn{6,gbc04{{{continue scan through sediment{20778
*      here for unused sediment block
{gbc4b{jsr{6,blkln{{{get length of this block{20782
{{add{7,xr{8,wa{{bump actual pointer{20783
{{add{8,wb{8,wa{{count size of unused blocks{20784
{{brn{6,gbc04{{{continue scan through sediment{20785
*      here at end of sediment.  remember size of free blocks
*      within the sediment.  this will be used later to decide
*      how to set the sediment size returned to caller.
*      then scan rest of dynamic area above sediment.
*      (wb) = aggregate size of free blocks in sediment
*      (xr) = first location past sediment
{gbc4c{mov{3,gbcsf{8,wb{{size of sediment free space{20796
{{mov{8,wc{7,xr{{set as first eventual location{20800
{{add{8,wc{3,gbsvb{{add offset for eventual move up{20801
{{zer{3,gbcnm{{{clear initial forward pointer{20802
{{mov{3,gbclm{20,=gbcnm{{initialize ptr to last move block{20803
{{mov{3,gbcns{7,xr{{initialize first address{20804
*      loop through a series of blocks in use
{gbc05{beq{7,xr{3,dnamp{6,gbc07{jump if end of used region{20808
{{mov{8,wa{9,(xr){{else get first word{20809
{{bod{8,wa{6,gbc07{{jump if entry pointer (unused){20811
*      here for block in use, loop to relocate references
{gbc06{mov{7,xl{8,wa{{copy pointer{20819
{{mov{8,wa{9,(xl){{load forward pointer{20820
{{mov{9,(xl){8,wc{{relocate reference{20821
{{bev{8,wa{6,gbc06{{loop back if not end of chain{20823
{{ejc{{{{{20828
*      gbcol (continued)
*      at end of chain, restore first word and bump past
{{mov{9,(xr){8,wa{{restore first word{20834
{{jsr{6,blkln{{{get length of this block{20835
{{add{7,xr{8,wa{{bump actual pointer{20836
{{add{8,wc{8,wa{{bump eventual pointer{20837
{{brn{6,gbc05{{{loop back for next block{20838
*      here at end of a series of blocks in use
{gbc07{mov{8,wa{7,xr{{copy pointer past last block{20842
{{mov{7,xl{3,gbclm{{point to previous move block{20843
{{sub{8,wa{13,num01(xl){{subtract starting address{20844
{{mov{13,num01(xl){8,wa{{store length of block to be moved{20845
*      loop through a series of blocks not in use
{gbc08{beq{7,xr{3,dnamp{6,gbc10{jump if end of used region{20849
{{mov{8,wa{9,(xr){{else load first word of next block{20850
{{bev{8,wa{6,gbc09{{jump if in use{20852
{{jsr{6,blkln{{{else get length of next block{20857
{{add{7,xr{8,wa{{push pointer{20858
{{brn{6,gbc08{{{and loop back{20859
*      here for a block in use after processing a series of
*      blocks which were not in use, build new move block.
{gbc09{sub{7,xr{19,*num02{{point 2 words behind for move block{20864
{{mov{7,xl{3,gbclm{{point to previous move block{20865
{{mov{9,(xl){7,xr{{set forward ptr in previous block{20866
{{zer{9,(xr){{{zero forward ptr of new block{20867
{{mov{3,gbclm{7,xr{{remember address of this block{20868
{{mov{7,xl{7,xr{{copy ptr to move block{20869
{{add{7,xr{19,*num02{{point back to block in use{20870
{{mov{13,num01(xl){7,xr{{store starting address{20871
{{brn{6,gbc06{{{jump to process block in use{20872
{{ejc{{{{{20873
*      gbcol (continued)
*      here for pass three -- actually move the blocks down
*      (xl)                  pointer to old location
*      (xr)                  pointer to new location
{gbc10{mov{7,xr{3,gbcsd{{point to storage above sediment{20883
{{add{7,xr{3,gbcns{{bump past unmoved blocks at start{20887
*      loop through move descriptors
{gbc11{mov{7,xl{3,gbcnm{{point to next move block{20891
{{bze{7,xl{6,gbc12{{jump if end of chain{20892
{{mov{3,gbcnm{10,(xl)+{{move pointer down chain{20893
{{mov{8,wa{10,(xl)+{{get length to move{20894
{{mvw{{{{perform move{20895
{{brn{6,gbc11{{{loop back{20896
*      now test for move up
{gbc12{mov{3,dnamp{7,xr{{set next available loc ptr{20900
{{mov{8,wb{3,gbsvb{{reload move offset{20901
{{bze{8,wb{6,gbc13{{jump if no move required{20902
{{mov{7,xl{7,xr{{else copy old top of core{20903
{{add{7,xr{8,wb{{point to new top of core{20904
{{mov{3,dnamp{7,xr{{save new top of core pointer{20905
{{mov{8,wa{7,xl{{copy old top{20906
{{sub{8,wa{3,dnamb{{minus old bottom = length{20907
{{add{3,dnamb{8,wb{{bump bottom to get new value{20908
{{mwb{{{{perform move (backwards){20909
*      merge here to exit
{gbc13{zer{7,xr{{{clear garbage value in xr{20913
{{mov{3,gbcfl{7,xr{{note exit from gbcol{20914
{{mov{8,wa{3,dnamb{{start of dynamic area{20916
{{mov{8,wb{3,dnamp{{next available location{20917
{{mov{8,wc{3,dname{{last available location + 1{20918
{{jsr{6,sysgc{{{inform sysgc of completion{20919
*      decide whether to mark sediment for collection next time.
*      this is done by examining the ratio of previous sediment
*      free space to the new sediment size.
{{sti{3,gbcia{{{save ia{20927
{{zer{7,xr{{{presume no sediment will remain{20928
{{mov{8,wb{3,gbcsf{{free space in sediment{20929
{{btw{8,wb{{{convert bytes to words{20930
{{mti{8,wb{{{put sediment free store in ia{20931
{{mli{3,gbsed{{{multiply by sediment factor{20932
{{iov{6,gb13a{{{jump if overflowed{20933
{{mov{8,wb{3,dnamp{{end of dynamic area in use{20934
{{sub{8,wb{3,dnamb{{minus start is sediment remaining{20935
{{btw{8,wb{{{convert to words{20936
{{mov{3,gbcsf{8,wb{{store it{20937
{{sbi{3,gbcsf{{{subtract from scaled up free store{20938
{{igt{6,gb13a{{{jump if large free store in sedimnt{20939
{{mov{7,xr{3,dnamp{{below threshold, return sediment{20940
{{sub{7,xr{3,dnamb{{for use by caller{20941
{gb13a{ldi{3,gbcia{{{restore ia{20942
{{mov{8,wa{3,gbsva{{restore wa{20944
{{mov{8,wb{3,gbsvb{{restore wb{20945
{{scp{8,wc{{{get code pointer{20946
{{add{8,wc{3,r_cod{{make absolute again{20947
{{lcp{8,wc{{{and replace absolute value{20948
{{mov{8,wc{3,gbsvc{{restore wc{20949
{{mov{7,xl{10,(xs)+{{restore entry xl{20950
{{icv{3,gbcnt{{{increment count of collections{20951
{{exi{{{{exit to gbcol caller{20952
*      garbage collection not allowed whilst dumping
{gbc14{icv{3,errft{{{fatal error{20956
{{erb{1,250{26,insufficient memory to complete dump{{{20957
{{enp{{{{end procedure gbcol{20958
{{ejc{{{{{20959
*      gbcpf -- process fields for garbage collector
*      this procedure is used by the garbage collector to
*      process fields in pass one. see gbcol for full details.
*      (xr)                  ptr to first location to process
*      (xl)                  ptr past last location to process
*      jsr  gbcpf            call to process fields
*      (xr,wa,wb,wc,ia)      destroyed
*      note that although this procedure uses a recursive
*      approach, it controls its own stack and is not recursive.
{gbcpf{prc{25,e{1,0{{entry point{20974
{{zer{11,-(xs){{{set zero to mark bottom of stack{20975
{{mov{11,-(xs){7,xl{{save end pointer{20976
*      merge here to go down a level and start a new loop
*      1(xs)                 next lvl field ptr (0 at outer lvl)
*      0(xs)                 ptr past last field to process
*      (xr)                  ptr to first field to process
*      loop to process successive fields
{gpf01{mov{7,xl{9,(xr){{load field contents{20986
{{mov{8,wc{7,xr{{save field pointer{20987
{{blt{7,xl{3,dnamb{6,gpf2a{jump if not ptr into dynamic area{20991
{{bge{7,xl{3,dnamp{6,gpf2a{jump if not ptr into dynamic area{20992
*      here we have a ptr to a block in the dynamic area.
*      link this field onto the reference backchain.
{{mov{8,wa{9,(xl){{load ptr to chain (or entry ptr){20997
{{blt{7,xl{3,gbcsd{6,gpf1a{do not chain if within sediment{20999
{{mov{9,(xl){7,xr{{set this field as new head of chain{21001
{{mov{9,(xr){8,wa{{set forward pointer{21002
*      now see if this block has been processed before
{gpf1a{bod{8,wa{6,gpf03{{jump if not already processed{21007
*      here to restore pointer in xr to field just processed
{gpf02{mov{7,xr{8,wc{{restore field pointer{21015
*      here to move to next field
{gpf2a{ica{7,xr{{{bump to next field{21019
{{bne{7,xr{9,(xs){6,gpf01{loop back if more to go{21020
{{ejc{{{{{21021
*      gbcpf (continued)
*      here we pop up a level after finishing a block
{{mov{7,xl{10,(xs)+{{restore pointer past end{21027
{{mov{7,xr{10,(xs)+{{restore block pointer{21028
{{bnz{7,xr{6,gpf2a{{continue loop unless outer levl{21029
{{exi{{{{return to caller if outer level{21030
*      here to process an active block which has not been done
*      since sediment blocks are not marked by putting them on
*      the back chain, they must be explicitly marked in another
*      manner.  if odd parity entry points are present, mark by
*      temporarily converting to even parity.  if odd parity not
*      available, the entry point is adjusted by the value in
*      gbcmk.
{gpf03{bge{7,xl{3,gbcsd{6,gpf3a{if not within sediment{21043
{{icv{9,(xl){{{mark by making entry point even{21045
{gpf3a{mov{7,xr{7,xl{{copy block pointer{21049
{{mov{7,xl{8,wa{{copy first word of block{21053
{{lei{7,xl{{{load entry point id (bl_xx){21054
*      block type switch. note that blocks with no relocatable
*      fields just return to gpf02 here to continue to next fld.
{{bsw{7,xl{2,bl___{{switch on block type{21059
{{iff{2,bl_ar{6,gpf06{{arblk{21097
{{iff{2,bl_cd{6,gpf19{{cdblk{21097
{{iff{2,bl_ex{6,gpf17{{exblk{21097
{{iff{2,bl_ic{6,gpf02{{icblk{21097
{{iff{2,bl_nm{6,gpf10{{nmblk{21097
{{iff{2,bl_p0{6,gpf10{{p0blk{21097
{{iff{2,bl_p1{6,gpf12{{p1blk{21097
{{iff{2,bl_p2{6,gpf12{{p2blk{21097
{{iff{2,bl_rc{6,gpf02{{rcblk{21097
{{iff{2,bl_sc{6,gpf02{{scblk{21097
{{iff{2,bl_se{6,gpf02{{seblk{21097
{{iff{2,bl_tb{6,gpf08{{tbblk{21097
{{iff{2,bl_vc{6,gpf08{{vcblk{21097
{{iff{2,bl_xn{6,gpf02{{xnblk{21097
{{iff{2,bl_xr{6,gpf09{{xrblk{21097
{{iff{2,bl_bc{6,gpf02{{bcblk - dummy to fill out iffs{21097
{{iff{2,bl_pd{6,gpf13{{pdblk{21097
{{iff{2,bl_tr{6,gpf16{{trblk{21097
{{iff{2,bl_bf{6,gpf02{{bfblk{21097
{{iff{2,bl_cc{6,gpf07{{ccblk{21097
{{iff{2,bl_cm{6,gpf04{{cmblk{21097
{{iff{2,bl_ct{6,gpf02{{ctblk{21097
{{iff{2,bl_df{6,gpf02{{dfblk{21097
{{iff{2,bl_ef{6,gpf02{{efblk{21097
{{iff{2,bl_ev{6,gpf10{{evblk{21097
{{iff{2,bl_ff{6,gpf11{{ffblk{21097
{{iff{2,bl_kv{6,gpf02{{kvblk{21097
{{iff{2,bl_pf{6,gpf14{{pfblk{21097
{{iff{2,bl_te{6,gpf15{{teblk{21097
{{esw{{{{end of jump table{21097
{{ejc{{{{{21098
*      gbcpf (continued)
*      cmblk
{gpf04{mov{8,wa{13,cmlen(xr){{load length{21104
{{mov{8,wb{19,*cmtyp{{set offset{21105
*      here to push down to new level
*      (wc)                  field ptr at previous level
*      (xr)                  ptr to new block
*      (wa)                  length (reloc flds + flds at start)
*      (wb)                  offset to first reloc field
{gpf05{add{8,wa{7,xr{{point past last reloc field{21114
{{add{7,xr{8,wb{{point to first reloc field{21115
{{mov{11,-(xs){8,wc{{stack old field pointer{21116
{{mov{11,-(xs){8,wa{{stack new limit pointer{21117
{{chk{{{{check for stack overflow{21118
{{brn{6,gpf01{{{if ok, back to process{21119
*      arblk
{gpf06{mov{8,wa{13,arlen(xr){{load length{21123
{{mov{8,wb{13,arofs(xr){{set offset to 1st reloc fld (arpro){21124
{{brn{6,gpf05{{{all set{21125
*      ccblk
{gpf07{mov{8,wa{13,ccuse(xr){{set length in use{21129
{{mov{8,wb{19,*ccuse{{1st word (make sure at least one){21130
{{brn{6,gpf05{{{all set{21131
{{ejc{{{{{21132
*      gbcpf (continued)
*      cdblk
{gpf19{mov{8,wa{13,cdlen(xr){{load length{21139
{{mov{8,wb{19,*cdfal{{set offset{21140
{{brn{6,gpf05{{{jump back{21141
*      tbblk, vcblk
{gpf08{mov{8,wa{13,offs2(xr){{load length{21148
{{mov{8,wb{19,*offs3{{set offset{21149
{{brn{6,gpf05{{{jump back{21150
*      xrblk
{gpf09{mov{8,wa{13,xrlen(xr){{load length{21154
{{mov{8,wb{19,*xrptr{{set offset{21155
{{brn{6,gpf05{{{jump back{21156
*      evblk, nmblk, p0blk
{gpf10{mov{8,wa{19,*offs2{{point past second field{21160
{{mov{8,wb{19,*offs1{{offset is one (only reloc fld is 2){21161
{{brn{6,gpf05{{{all set{21162
*      ffblk
{gpf11{mov{8,wa{19,*ffofs{{set length{21166
{{mov{8,wb{19,*ffnxt{{set offset{21167
{{brn{6,gpf05{{{all set{21168
*      p1blk, p2blk
{gpf12{mov{8,wa{19,*parm2{{length (parm2 is non-relocatable){21172
{{mov{8,wb{19,*pthen{{set offset{21173
{{brn{6,gpf05{{{all set{21174
{{ejc{{{{{21175
*      gbcpf (continued)
*      pdblk
{gpf13{mov{7,xl{13,pddfp(xr){{load ptr to dfblk{21181
{{mov{8,wa{13,dfpdl(xl){{get pdblk length{21182
{{mov{8,wb{19,*pdfld{{set offset{21183
{{brn{6,gpf05{{{all set{21184
*      pfblk
{gpf14{mov{8,wa{19,*pfarg{{length past last reloc{21188
{{mov{8,wb{19,*pfcod{{offset to first reloc{21189
{{brn{6,gpf05{{{all set{21190
*      teblk
{gpf15{mov{8,wa{19,*tesi_{{set length{21194
{{mov{8,wb{19,*tesub{{and offset{21195
{{brn{6,gpf05{{{all set{21196
*      trblk
{gpf16{mov{8,wa{19,*trsi_{{set length{21200
{{mov{8,wb{19,*trval{{and offset{21201
{{brn{6,gpf05{{{all set{21202
*      exblk
{gpf17{mov{8,wa{13,exlen(xr){{load length{21206
{{mov{8,wb{19,*exflc{{set offset{21207
{{brn{6,gpf05{{{jump back{21208
{{enp{{{{end procedure gbcpf{21218
{{ejc{{{{{21219
*z+
*      gtarr -- get array
*      gtarr is passed an object and returns an array if possibl
*      (xr)                  value to be converted
*      (wa)                  0 to place table addresses in array
*                            non-zero for keys/values in array
*      jsr  gtarr            call to get array
*      ppm  loc              transfer loc for all null table
*      ppm  loc              transfer loc if convert impossible
*      (xr)                  resulting array
*      (xl,wa,wb,wc)         destroyed
{gtarr{prc{25,e{1,2{{entry point{21235
{{mov{3,gtawa{8,wa{{save wa indicator{21236
{{mov{8,wa{9,(xr){{load type word{21237
{{beq{8,wa{22,=b_art{6,gtar8{exit if already an array{21238
{{beq{8,wa{22,=b_vct{6,gtar8{exit if already an array{21239
{{bne{8,wa{22,=b_tbt{6,gta9a{else fail if not a table (sgd02){21240
*      here we convert a table to an array
{{mov{11,-(xs){7,xr{{replace tbblk pointer on stack{21244
{{zer{7,xr{{{signal first pass{21245
{{zer{8,wb{{{zero non-null element count{21246
*      the following code is executed twice. on the first pass,
*      signalled by xr=0, the number of non-null elements in
*      the table is counted in wb. in the second pass, where
*      xr is a pointer into the arblk, the name and value are
*      entered into the current arblk location provided gtawa
*      is non-zero.  if gtawa is zero, the address of the teblk
*      is entered into the arblk twice (c3.762).
{gtar1{mov{7,xl{9,(xs){{point to table{21256
{{add{7,xl{13,tblen(xl){{point past last bucket{21257
{{sub{7,xl{19,*tbbuk{{set first bucket offset{21258
{{mov{8,wa{7,xl{{copy adjusted pointer{21259
*      loop through buckets in table block
*      next three lines of code rely on tenxt having a value
*      1 less than tbbuk.
{gtar2{mov{7,xl{8,wa{{copy bucket pointer{21265
{{dca{8,wa{{{decrement bucket pointer{21266
*      loop through teblks on one bucket chain
{gtar3{mov{7,xl{13,tenxt(xl){{point to next teblk{21270
{{beq{7,xl{9,(xs){6,gtar6{jump if chain end (tbblk ptr){21271
{{mov{3,cnvtp{7,xl{{else save teblk pointer{21272
*      loop to find value down trblk chain
{gtar4{mov{7,xl{13,teval(xl){{load value{21276
{{beq{9,(xl){22,=b_trt{6,gtar4{loop till value found{21277
{{mov{8,wc{7,xl{{copy value{21278
{{mov{7,xl{3,cnvtp{{restore teblk pointer{21279
{{ejc{{{{{21280
*      gtarr (continued)
*      now check for null and test cases
{{beq{8,wc{21,=nulls{6,gtar3{loop back to ignore null value{21286
{{bnz{7,xr{6,gtar5{{jump if second pass{21287
{{icv{8,wb{{{for the first pass, bump count{21288
{{brn{6,gtar3{{{and loop back for next teblk{21289
*      here in second pass
{gtar5{bze{3,gtawa{6,gta5a{{jump if address wanted{21293
{{mov{10,(xr)+{13,tesub(xl){{store subscript name{21294
{{mov{10,(xr)+{8,wc{{store value in arblk{21295
{{brn{6,gtar3{{{loop back for next teblk{21296
*      here to record teblk address in arblk.  this allows
*      a sort routine to sort by ascending address.
{gta5a{mov{10,(xr)+{7,xl{{store teblk address in name{21301
{{mov{10,(xr)+{7,xl{{and value slots{21302
{{brn{6,gtar3{{{loop back for next teblk{21303
*      here after scanning teblks on one chain
{gtar6{bne{8,wa{9,(xs){6,gtar2{loop back if more buckets to go{21307
{{bnz{7,xr{6,gtar7{{else jump if second pass{21308
*      here after counting non-null elements
{{bze{8,wb{6,gtar9{{fail if no non-null elements{21312
{{mov{8,wa{8,wb{{else copy count{21313
{{add{8,wa{8,wb{{double (two words/element){21314
{{add{8,wa{18,=arvl2{{add space for standard fields{21315
{{wtb{8,wa{{{convert length to bytes{21316
{{bgt{8,wa{3,mxlen{6,gta9b{error if too long for array{21317
{{jsr{6,alloc{{{else allocate space for arblk{21318
{{mov{9,(xr){22,=b_art{{store type word{21319
{{zer{13,idval(xr){{{zero id for the moment{21320
{{mov{13,arlen(xr){8,wa{{store length{21321
{{mov{13,arndm(xr){18,=num02{{set dimensions = 2{21322
{{ldi{4,intv1{{{get integer one{21323
{{sti{13,arlbd(xr){{{store as lbd 1{21324
{{sti{13,arlb2(xr){{{store as lbd 2{21325
{{ldi{4,intv2{{{load integer two{21326
{{sti{13,ardm2(xr){{{store as dim 2{21327
{{mti{8,wb{{{get element count as integer{21328
{{sti{13,ardim(xr){{{store as dim 1{21329
{{zer{13,arpr2(xr){{{zero prototype field for now{21330
{{mov{13,arofs(xr){19,*arpr2{{set offset field (signal pass 2){21331
{{mov{8,wb{7,xr{{save arblk pointer{21332
{{add{7,xr{19,*arvl2{{point to first element location{21333
{{brn{6,gtar1{{{jump back to fill in elements{21334
{{ejc{{{{{21335
*      gtarr (continued)
*      here after filling in element values
{gtar7{mov{7,xr{8,wb{{restore arblk pointer{21341
{{mov{9,(xs){8,wb{{store as result{21342
*      now we need the array prototype which is of the form nn,2
*      this is obtained by building the string for nn02 and
*      changing the zero to a comma before storing it.
{{ldi{13,ardim(xr){{{get number of elements (nn){21348
{{mli{4,intvh{{{multiply by 100{21349
{{adi{4,intv2{{{add 2 (nn02){21350
{{jsr{6,icbld{{{build integer{21351
{{mov{11,-(xs){7,xr{{store ptr for gtstg{21352
{{jsr{6,gtstg{{{convert to string{21353
{{ppm{{{{convert fail is impossible{21354
{{mov{7,xl{7,xr{{copy string pointer{21355
{{mov{7,xr{10,(xs)+{{reload arblk pointer{21356
{{mov{13,arpr2(xr){7,xl{{store prototype ptr (nn02){21357
{{sub{8,wa{18,=num02{{adjust length to point to zero{21358
{{psc{7,xl{8,wa{{point to zero{21359
{{mov{8,wb{18,=ch_cm{{load a comma{21360
{{sch{8,wb{9,(xl){{store a comma over the zero{21361
{{csc{7,xl{{{complete store characters{21362
*      normal return
{gtar8{exi{{{{return to caller{21366
*      null table non-conversion return
{gtar9{mov{7,xr{10,(xs)+{{restore stack for conv err (sgd02){21370
{{exi{1,1{{{return{21371
*      impossible conversion return
{gta9a{exi{1,2{{{return{21375
*      array size too large
{gta9b{erb{1,260{26,conversion array size exceeds maximum permitted{{{21379
{{enp{{{{procedure gtarr{21380
{{ejc{{{{{21381
*      gtcod -- convert to code
*      (xr)                  object to be converted
*      jsr  gtcod            call to convert to code
*      ppm  loc              transfer loc if convert impossible
*      (xr)                  pointer to resulting cdblk
*      (xl,wa,wb,wc,ra)      destroyed
*      if a spitbol error occurs during compilation or pre-
*      evaluation, control is passed via error section to exfal
*      without returning to this routine.
{gtcod{prc{25,e{1,1{{entry point{21395
{{beq{9,(xr){22,=b_cds{6,gtcd1{jump if already code{21396
{{beq{9,(xr){22,=b_cdc{6,gtcd1{jump if already code{21397
*      here we must generate a cdblk by compilation
{{mov{11,-(xs){7,xr{{stack argument for gtstg{21401
{{jsr{6,gtstg{{{convert argument to string{21402
{{ppm{6,gtcd2{{{jump if non-convertible{21403
{{mov{3,gtcef{3,flptr{{save fail ptr in case of error{21404
{{mov{3,r_gtc{3,r_cod{{also save code ptr{21405
{{mov{3,r_cim{7,xr{{else set image pointer{21406
{{mov{3,scnil{8,wa{{set image length{21407
{{zer{3,scnpt{{{set scan pointer{21408
{{mov{3,stage{18,=stgxc{{set stage for execute compile{21409
{{mov{3,lstsn{3,cmpsn{{in case listr called{21410
{{icv{3,cmpln{{{bump line number{21412
{{jsr{6,cmpil{{{compile string{21414
{{mov{3,stage{18,=stgxt{{reset stage for execute time{21415
{{zer{3,r_cim{{{clear image{21416
*      merge here if no convert required
{gtcd1{exi{{{{give normal gtcod return{21420
*      here if unconvertible
{gtcd2{exi{1,1{{{give error return{21424
{{enp{{{{end procedure gtcod{21425
{{ejc{{{{{21426
*      gtexp -- convert to expression
*      (wb)                  0 if by value, 1 if by name
*      (xr)                  input value to be converted
*      jsr  gtexp            call to convert to expression
*      ppm  loc              transfer loc if convert impossible
*      (xr)                  pointer to result exblk or seblk
*      (xl,wa,wb,wc,ra)      destroyed
*      if a spitbol error occurs during compilation or pre-
*      evaluation, control is passed via error section to exfal
*      without returning to this routine.
{gtexp{prc{25,e{1,1{{entry point{21443
{{blo{9,(xr){22,=b_e__{6,gtex1{jump if already an expression{21444
{{mov{11,-(xs){7,xr{{store argument for gtstg{21445
{{jsr{6,gtstg{{{convert argument to string{21446
{{ppm{6,gtex2{{{jump if unconvertible{21447
*      check the last character of the string for colon or
*      semicolon.  these characters can legitimately end an
*      expression in open code, so expan will not detect them
*      as errors, but they are invalid as terminators for a
*      string that is being converted to expression form.
{{mov{7,xl{7,xr{{copy input string pointer{21455
{{plc{7,xl{8,wa{{point one past the string end{21456
{{lch{7,xl{11,-(xl){{fetch the last character{21457
{{beq{7,xl{18,=ch_cl{6,gtex2{error if it is a semicolon{21458
{{beq{7,xl{18,=ch_sm{6,gtex2{or if it is a colon{21459
*      here we convert a string by compilation
{{mov{3,r_cim{7,xr{{set input image pointer{21463
{{zer{3,scnpt{{{set scan pointer{21464
{{mov{3,scnil{8,wa{{set input image length{21465
{{mov{11,-(xs){8,wb{{save value/name flag{21467
{{zer{8,wb{{{set code for normal scan{21469
{{mov{3,gtcef{3,flptr{{save fail ptr in case of error{21470
{{mov{3,r_gtc{3,r_cod{{also save code ptr{21471
{{mov{3,stage{18,=stgev{{adjust stage for compile{21472
{{mov{3,scntp{18,=t_uok{{indicate unary operator acceptable{21473
{{jsr{6,expan{{{build tree for expression{21474
{{zer{3,scnrs{{{reset rescan flag{21475
{{mov{8,wa{10,(xs)+{{restore value/name flag{21477
{{bne{3,scnpt{3,scnil{6,gtex2{error if not end of image{21479
{{zer{8,wb{{{set ok value for cdgex call{21480
{{mov{7,xl{7,xr{{copy tree pointer{21481
{{jsr{6,cdgex{{{build expression block{21482
{{zer{3,r_cim{{{clear pointer{21483
{{mov{3,stage{18,=stgxt{{restore stage for execute time{21484
*      merge here if no conversion required
{gtex1{exi{{{{return to gtexp caller{21488
*      here if unconvertible
{gtex2{exi{1,1{{{take error exit{21492
{{enp{{{{end procedure gtexp{21493
{{ejc{{{{{21494
*      gtint -- get integer value
*      gtint is passed an object and returns an integer after
*      performing any necessary conversions.
*      (xr)                  value to be converted
*      jsr  gtint            call to convert to integer
*      ppm  loc              transfer loc for convert impossible
*      (xr)                  resulting integer
*      (wc,ra)               destroyed
*      (wa,wb)               destroyed (only on conversion err)
*      (xr)                  unchanged (on convert error)
{gtint{prc{25,e{1,1{{entry point{21509
{{beq{9,(xr){22,=b_icl{6,gtin2{jump if already an integer{21510
{{mov{3,gtina{8,wa{{else save wa{21511
{{mov{3,gtinb{8,wb{{save wb{21512
{{jsr{6,gtnum{{{convert to numeric{21513
{{ppm{6,gtin3{{{jump if unconvertible{21514
{{beq{8,wa{22,=b_icl{6,gtin1{jump if integer{21517
*      here we convert a real to integer
{{ldr{13,rcval(xr){{{load real value{21521
{{rti{6,gtin3{{{convert to integer (err if ovflow){21522
{{jsr{6,icbld{{{if ok build icblk{21523
*      here after successful conversion to integer
{gtin1{mov{8,wa{3,gtina{{restore wa{21528
{{mov{8,wb{3,gtinb{{restore wb{21529
*      common exit point
{gtin2{exi{{{{return to gtint caller{21533
*      here on conversion error
{gtin3{exi{1,1{{{take convert error exit{21537
{{enp{{{{end procedure gtint{21538
{{ejc{{{{{21539
*      gtnum -- get numeric value
*      gtnum is given an object and returns either an integer
*      or a real, performing any necessary conversions.
*      (xr)                  object to be converted
*      jsr  gtnum            call to convert to numeric
*      ppm  loc              transfer loc if convert impossible
*      (xr)                  pointer to result (int or real)
*      (wa)                  first word of result block
*      (wb,wc,ra)            destroyed
*      (xr)                  unchanged (on convert error)
{gtnum{prc{25,e{1,1{{entry point{21554
{{mov{8,wa{9,(xr){{load first word of block{21555
{{beq{8,wa{22,=b_icl{6,gtn34{jump if integer (no conversion){21556
{{beq{8,wa{22,=b_rcl{6,gtn34{jump if real (no conversion){21559
*      at this point the only possibility is to convert a string
*      to an integer or real as appropriate.
{{mov{11,-(xs){7,xr{{stack argument in case convert err{21565
{{mov{11,-(xs){7,xr{{stack argument for gtstg{21566
{{jsr{6,gtstg{{{convert argument to string{21568
{{ppm{6,gtn36{{{jump if unconvertible{21572
*      initialize numeric conversion
{{ldi{4,intv0{{{initialize integer result to zero{21576
{{bze{8,wa{6,gtn32{{jump to exit with zero if null{21577
{{lct{8,wa{8,wa{{set bct counter for following loops{21578
{{zer{3,gtnnf{{{tentatively indicate result +{21579
{{sti{3,gtnex{{{initialise exponent to zero{21582
{{zer{3,gtnsc{{{zero scale in case real{21583
{{zer{3,gtndf{{{reset flag for dec point found{21584
{{zer{3,gtnrd{{{reset flag for digits found{21585
{{ldr{4,reav0{{{zero real accum in case real{21586
{{plc{7,xr{{{point to argument characters{21588
*      merge back here after ignoring leading blank
{gtn01{lch{8,wb{10,(xr)+{{load first character{21592
{{blt{8,wb{18,=ch_d0{6,gtn02{jump if not digit{21593
{{ble{8,wb{18,=ch_d9{6,gtn06{jump if first char is a digit{21594
{{ejc{{{{{21595
*      gtnum (continued)
*      here if first digit is non-digit
{gtn02{bne{8,wb{18,=ch_bl{6,gtn03{jump if non-blank{21601
{gtna2{bct{8,wa{6,gtn01{{else decr count and loop back{21602
{{brn{6,gtn07{{{jump to return zero if all blanks{21603
*      here for first character non-blank, non-digit
{gtn03{beq{8,wb{18,=ch_pl{6,gtn04{jump if plus sign{21607
{{beq{8,wb{18,=ch_ht{6,gtna2{horizontal tab equiv to blank{21609
{{bne{8,wb{18,=ch_mn{6,gtn12{jump if not minus (may be real){21617
{{mnz{3,gtnnf{{{if minus sign, set negative flag{21619
*      merge here after processing sign
{gtn04{bct{8,wa{6,gtn05{{jump if chars left{21623
{{brn{6,gtn36{{{else error{21624
*      loop to fetch characters of an integer
{gtn05{lch{8,wb{10,(xr)+{{load next character{21628
{{blt{8,wb{18,=ch_d0{6,gtn08{jump if not a digit{21629
{{bgt{8,wb{18,=ch_d9{6,gtn08{jump if not a digit{21630
*      merge here for first digit
{gtn06{sti{3,gtnsi{{{save current value{21634
{{cvm{6,gtn35{{{current*10-(new dig) jump if ovflow{21638
{{mnz{3,gtnrd{{{set digit read flag{21639
{{bct{8,wa{6,gtn05{{else loop back if more chars{21641
*      here to exit with converted integer value
{gtn07{bnz{3,gtnnf{6,gtn32{{jump if negative (all set){21645
{{ngi{{{{else negate{21646
{{ino{6,gtn32{{{jump if no overflow{21647
{{brn{6,gtn36{{{else signal error{21648
{{ejc{{{{{21649
*      gtnum (continued)
*      here for a non-digit character while attempting to
*      convert an integer, check for trailing blanks or real.
{gtn08{beq{8,wb{18,=ch_bl{6,gtna9{jump if a blank{21656
{{beq{8,wb{18,=ch_ht{6,gtna9{jump if horizontal tab{21658
{{itr{{{{else convert integer to real{21666
{{ngr{{{{negate to get positive value{21667
{{brn{6,gtn12{{{jump to try for real{21668
*      here we scan out blanks to end of string
{gtn09{lch{8,wb{10,(xr)+{{get next char{21673
{{beq{8,wb{18,=ch_ht{6,gtna9{jump if horizontal tab{21675
{{bne{8,wb{18,=ch_bl{6,gtn36{error if non-blank{21680
{gtna9{bct{8,wa{6,gtn09{{loop back if more chars to check{21681
{{brn{6,gtn07{{{return integer if all blanks{21682
*      loop to collect mantissa of real
{gtn10{lch{8,wb{10,(xr)+{{load next character{21688
{{blt{8,wb{18,=ch_d0{6,gtn12{jump if non-numeric{21689
{{bgt{8,wb{18,=ch_d9{6,gtn12{jump if non-numeric{21690
*      merge here to collect first real digit
{gtn11{sub{8,wb{18,=ch_d0{{convert digit to number{21694
{{mlr{4,reavt{{{multiply real by 10.0{21695
{{rov{6,gtn36{{{convert error if overflow{21696
{{str{3,gtnsr{{{save result{21697
{{mti{8,wb{{{get new digit as integer{21698
{{itr{{{{convert new digit to real{21699
{{adr{3,gtnsr{{{add to get new total{21700
{{add{3,gtnsc{3,gtndf{{increment scale if after dec point{21701
{{mnz{3,gtnrd{{{set digit found flag{21702
{{bct{8,wa{6,gtn10{{loop back if more chars{21703
{{brn{6,gtn22{{{else jump to scale{21704
{{ejc{{{{{21705
*      gtnum (continued)
*      here if non-digit found while collecting a real
{gtn12{bne{8,wb{18,=ch_dt{6,gtn13{jump if not dec point{21711
{{bnz{3,gtndf{6,gtn36{{if dec point, error if one already{21712
{{mov{3,gtndf{18,=num01{{else set flag for dec point{21713
{{bct{8,wa{6,gtn10{{loop back if more chars{21714
{{brn{6,gtn22{{{else jump to scale{21715
*      here if not decimal point
{gtn13{beq{8,wb{18,=ch_le{6,gtn15{jump if e for exponent{21719
{{beq{8,wb{18,=ch_ld{6,gtn15{jump if d for exponent{21720
*      here check for trailing blanks
{gtn14{beq{8,wb{18,=ch_bl{6,gtnb4{jump if blank{21728
{{beq{8,wb{18,=ch_ht{6,gtnb4{jump if horizontal tab{21730
{{brn{6,gtn36{{{error if non-blank{21735
{gtnb4{lch{8,wb{10,(xr)+{{get next character{21737
{{bct{8,wa{6,gtn14{{loop back to check if more{21738
{{brn{6,gtn22{{{else jump to scale{21739
*      here to read and process an exponent
{gtn15{zer{3,gtnes{{{set exponent sign positive{21743
{{ldi{4,intv0{{{initialize exponent to zero{21744
{{mnz{3,gtndf{{{reset no dec point indication{21745
{{bct{8,wa{6,gtn16{{jump skipping past e or d{21746
{{brn{6,gtn36{{{error if null exponent{21747
*      check for exponent sign
{gtn16{lch{8,wb{10,(xr)+{{load first exponent character{21751
{{beq{8,wb{18,=ch_pl{6,gtn17{jump if plus sign{21752
{{bne{8,wb{18,=ch_mn{6,gtn19{else jump if not minus sign{21753
{{mnz{3,gtnes{{{set sign negative if minus sign{21754
*      merge here after processing exponent sign
{gtn17{bct{8,wa{6,gtn18{{jump if chars left{21758
{{brn{6,gtn36{{{else error{21759
*      loop to convert exponent digits
{gtn18{lch{8,wb{10,(xr)+{{load next character{21763
{{ejc{{{{{21764
*      gtnum (continued)
*      merge here for first exponent digit
{gtn19{blt{8,wb{18,=ch_d0{6,gtn20{jump if not digit{21770
{{bgt{8,wb{18,=ch_d9{6,gtn20{jump if not digit{21771
{{cvm{6,gtn36{{{else current*10, subtract new digit{21772
{{bct{8,wa{6,gtn18{{loop back if more chars{21773
{{brn{6,gtn21{{{jump if exponent field is exhausted{21774
*      here to check for trailing blanks after exponent
{gtn20{beq{8,wb{18,=ch_bl{6,gtnc0{jump if blank{21778
{{beq{8,wb{18,=ch_ht{6,gtnc0{jump if horizontal tab{21780
{{brn{6,gtn36{{{error if non-blank{21785
{gtnc0{lch{8,wb{10,(xr)+{{get next character{21787
{{bct{8,wa{6,gtn20{{loop back till all blanks scanned{21788
*      merge here after collecting exponent
{gtn21{sti{3,gtnex{{{save collected exponent{21792
{{bnz{3,gtnes{6,gtn22{{jump if it was negative{21793
{{ngi{{{{else complement{21794
{{iov{6,gtn36{{{error if overflow{21795
{{sti{3,gtnex{{{and store positive exponent{21796
*      merge here with exponent (0 if none given)
{gtn22{bze{3,gtnrd{6,gtn36{{error if not digits collected{21800
{{bze{3,gtndf{6,gtn36{{error if no exponent or dec point{21801
{{mti{3,gtnsc{{{else load scale as integer{21802
{{sbi{3,gtnex{{{subtract exponent{21803
{{iov{6,gtn36{{{error if overflow{21804
{{ilt{6,gtn26{{{jump if we must scale up{21805
*      here we have a negative exponent, so scale down
{{mfi{8,wa{6,gtn36{{load scale factor, err if ovflow{21809
*      loop to scale down in steps of 10**10
{gtn23{ble{8,wa{18,=num10{6,gtn24{jump if 10 or less to go{21813
{{dvr{4,reatt{{{else divide by 10**10{21814
{{sub{8,wa{18,=num10{{decrement scale{21815
{{brn{6,gtn23{{{and loop back{21816
{{ejc{{{{{21817
*      gtnum (continued)
*      here scale rest of way from powers of ten table
{gtn24{bze{8,wa{6,gtn30{{jump if scaled{21823
{{lct{8,wb{18,=cfp_r{{else get indexing factor{21824
{{mov{7,xr{21,=reav1{{point to powers of ten table{21825
{{wtb{8,wa{{{convert remaining scale to byte ofs{21826
*      loop to point to powers of ten table entry
{gtn25{add{7,xr{8,wa{{bump pointer{21830
{{bct{8,wb{6,gtn25{{once for each value word{21831
{{dvr{9,(xr){{{scale down as required{21832
{{brn{6,gtn30{{{and jump{21833
*      come here to scale result up (positive exponent)
{gtn26{ngi{{{{get absolute value of exponent{21837
{{iov{6,gtn36{{{error if overflow{21838
{{mfi{8,wa{6,gtn36{{acquire scale, error if ovflow{21839
*      loop to scale up in steps of 10**10
{gtn27{ble{8,wa{18,=num10{6,gtn28{jump if 10 or less to go{21843
{{mlr{4,reatt{{{else multiply by 10**10{21844
{{rov{6,gtn36{{{error if overflow{21845
{{sub{8,wa{18,=num10{{else decrement scale{21846
{{brn{6,gtn27{{{and loop back{21847
*      here to scale up rest of way with table
{gtn28{bze{8,wa{6,gtn30{{jump if scaled{21851
{{lct{8,wb{18,=cfp_r{{else get indexing factor{21852
{{mov{7,xr{21,=reav1{{point to powers of ten table{21853
{{wtb{8,wa{{{convert remaining scale to byte ofs{21854
*      loop to point to proper entry in powers of ten table
{gtn29{add{7,xr{8,wa{{bump pointer{21858
{{bct{8,wb{6,gtn29{{once for each word in value{21859
{{mlr{9,(xr){{{scale up{21860
{{rov{6,gtn36{{{error if overflow{21861
{{ejc{{{{{21862
*      gtnum (continued)
*      here with real value scaled and ready except for sign
{gtn30{bze{3,gtnnf{6,gtn31{{jump if positive{21868
{{ngr{{{{else negate{21869
*      here with properly signed real value in (ra)
{gtn31{jsr{6,rcbld{{{build real block{21873
{{brn{6,gtn33{{{merge to exit{21874
*      here with properly signed integer value in (ia)
{gtn32{jsr{6,icbld{{{build icblk{21879
*      real merges here
{gtn33{mov{8,wa{9,(xr){{load first word of result block{21883
{{ica{7,xs{{{pop argument off stack{21884
*      common exit point
{gtn34{exi{{{{return to gtnum caller{21888
*      come here if overflow occurs during collection of integer
*      have to restore wb which cvm may have destroyed.
{gtn35{lch{8,wb{11,-(xr){{reload current character{21895
{{lch{8,wb{10,(xr)+{{bump character pointer{21896
{{ldi{3,gtnsi{{{reload integer so far{21897
{{itr{{{{convert to real{21898
{{ngr{{{{make value positive{21899
{{brn{6,gtn11{{{merge with real circuit{21900
*      here for unconvertible to string or conversion error
{gtn36{mov{7,xr{10,(xs)+{{reload original argument{21905
{{exi{1,1{{{take convert-error exit{21906
{{enp{{{{end procedure gtnum{21907
{{ejc{{{{{21908
*      gtnvr -- convert to natural variable
*      gtnvr locates a variable block (vrblk) given either an
*      appropriate name (nmblk) or a non-null string (scblk).
*      (xr)                  argument
*      jsr  gtnvr            call to convert to natural variable
*      ppm  loc              transfer loc if convert impossible
*      (xr)                  pointer to vrblk
*      (wa,wb)               destroyed (conversion error only)
*      (wc)                  destroyed
{gtnvr{prc{25,e{1,1{{entry point{21922
*z-
{{bne{9,(xr){22,=b_nml{6,gnv02{jump if not name{21924
{{mov{7,xr{13,nmbas(xr){{else load name base if name{21925
{{blo{7,xr{3,state{6,gnv07{skip if vrblk (in static region){21926
*      common error exit
{gnv01{exi{1,1{{{take convert-error exit{21930
*      here if not name
{gnv02{mov{3,gnvsa{8,wa{{save wa{21934
{{mov{3,gnvsb{8,wb{{save wb{21935
{{mov{11,-(xs){7,xr{{stack argument for gtstg{21936
{{jsr{6,gtstg{{{convert argument to string{21937
{{ppm{6,gnv01{{{jump if conversion error{21938
{{bze{8,wa{6,gnv01{{null string is an error{21939
{{mov{11,-(xs){7,xl{{save xl{21943
{{mov{11,-(xs){7,xr{{stack string ptr for later{21944
{{mov{8,wb{7,xr{{copy string pointer{21945
{{add{8,wb{19,*schar{{point to characters of string{21946
{{mov{3,gnvst{8,wb{{save pointer to characters{21947
{{mov{8,wb{8,wa{{copy length{21948
{{ctw{8,wb{1,0{{get number of words in name{21949
{{mov{3,gnvnw{8,wb{{save for later{21950
{{jsr{6,hashs{{{compute hash index for string{21951
{{rmi{3,hshnb{{{compute hash offset by taking mod{21952
{{mfi{8,wc{{{get as offset{21953
{{wtb{8,wc{{{convert offset to bytes{21954
{{add{8,wc{3,hshtb{{point to proper hash chain{21955
{{sub{8,wc{19,*vrnxt{{subtract offset to merge into loop{21956
{{ejc{{{{{21957
*      gtnvr (continued)
*      loop to search hash chain
{gnv03{mov{7,xl{8,wc{{copy hash chain pointer{21963
{{mov{7,xl{13,vrnxt(xl){{point to next vrblk on chain{21964
{{bze{7,xl{6,gnv08{{jump if end of chain{21965
{{mov{8,wc{7,xl{{save pointer to this vrblk{21966
{{bnz{13,vrlen(xl){6,gnv04{{jump if not system variable{21967
{{mov{7,xl{13,vrsvp(xl){{else point to svblk{21968
{{sub{7,xl{19,*vrsof{{adjust offset for merge{21969
*      merge here with string ptr (like vrblk) in xl
{gnv04{bne{8,wa{13,vrlen(xl){6,gnv03{back for next vrblk if lengths ne{21973
{{add{7,xl{19,*vrchs{{else point to chars of chain entry{21974
{{lct{8,wb{3,gnvnw{{get word counter to control loop{21975
{{mov{7,xr{3,gnvst{{point to chars of new name{21976
*      loop to compare characters of the two names
{gnv05{cne{9,(xr){9,(xl){6,gnv03{jump if no match for next vrblk{21980
{{ica{7,xr{{{bump new name pointer{21981
{{ica{7,xl{{{bump vrblk in chain name pointer{21982
{{bct{8,wb{6,gnv05{{else loop till all compared{21983
{{mov{7,xr{8,wc{{we have found a match, get vrblk{21984
*      exit point after finding vrblk or building new one
{gnv06{mov{8,wa{3,gnvsa{{restore wa{21988
{{mov{8,wb{3,gnvsb{{restore wb{21989
{{ica{7,xs{{{pop string pointer{21990
{{mov{7,xl{10,(xs)+{{restore xl{21991
*      common exit point
{gnv07{exi{{{{return to gtnvr caller{21995
*      not found, prepare to search system variable table
{gnv08{zer{7,xr{{{clear garbage xr pointer{21999
{{mov{3,gnvhe{8,wc{{save ptr to end of hash chain{22000
{{bgt{8,wa{18,=num09{6,gnv14{cannot be system var if length gt 9{22001
{{mov{7,xl{8,wa{{else copy length{22002
{{wtb{7,xl{{{convert to byte offset{22003
{{mov{7,xl{14,vsrch(xl){{point to first svblk of this length{22004
{{ejc{{{{{22005
*      gtnvr (continued)
*      loop to search entries in standard variable table
{gnv09{mov{3,gnvsp{7,xl{{save table pointer{22011
{{mov{8,wc{10,(xl)+{{load svbit bit string{22012
{{mov{8,wb{10,(xl)+{{load length from table entry{22013
{{bne{8,wa{8,wb{6,gnv14{jump if end of right length entries{22014
{{lct{8,wb{3,gnvnw{{get word counter to control loop{22015
{{mov{7,xr{3,gnvst{{point to chars of new name{22016
*      loop to check for matching names
{gnv10{cne{9,(xr){9,(xl){6,gnv11{jump if name mismatch{22020
{{ica{7,xr{{{else bump new name pointer{22021
{{ica{7,xl{{{bump svblk pointer{22022
{{bct{8,wb{6,gnv10{{else loop until all checked{22023
*      here we have a match in the standard variable table
{{zer{8,wc{{{set vrlen value zero{22027
{{mov{8,wa{19,*vrsi_{{set standard size{22028
{{brn{6,gnv15{{{jump to build vrblk{22029
*      here if no match with table entry in svblks table
{gnv11{ica{7,xl{{{bump past word of chars{22033
{{bct{8,wb{6,gnv11{{loop back if more to go{22034
{{rsh{8,wc{2,svnbt{{remove uninteresting bits{22035
*      loop to bump table ptr for each flagged word
{gnv12{mov{8,wb{4,bits1{{load bit to test{22039
{{anb{8,wb{8,wc{{test for word present{22040
{{zrb{8,wb{6,gnv13{{jump if not present{22041
{{ica{7,xl{{{else bump table pointer{22042
*      here after dealing with one word (one bit)
{gnv13{rsh{8,wc{1,1{{remove bit already processed{22046
{{nzb{8,wc{6,gnv12{{loop back if more bits to test{22047
{{brn{6,gnv09{{{else loop back for next svblk{22048
*      here if not system variable
{gnv14{mov{8,wc{8,wa{{copy vrlen value{22052
{{mov{8,wa{18,=vrchs{{load standard size -chars{22053
{{add{8,wa{3,gnvnw{{adjust for chars of name{22054
{{wtb{8,wa{{{convert length to bytes{22055
{{ejc{{{{{22056
*      gtnvr (continued)
*      merge here to build vrblk
{gnv15{jsr{6,alost{{{allocate space for vrblk (static){22062
{{mov{8,wb{7,xr{{save vrblk pointer{22063
{{mov{7,xl{21,=stnvr{{point to model variable block{22064
{{mov{8,wa{19,*vrlen{{set length of standard fields{22065
{{mvw{{{{set initial fields of new block{22066
{{mov{7,xl{3,gnvhe{{load pointer to end of hash chain{22067
{{mov{13,vrnxt(xl){8,wb{{add new block to end of chain{22068
{{mov{10,(xr)+{8,wc{{set vrlen field, bump ptr{22069
{{mov{8,wa{3,gnvnw{{get length in words{22070
{{wtb{8,wa{{{convert to length in bytes{22071
{{bze{8,wc{6,gnv16{{jump if system variable{22072
*      here for non-system variable -- set chars of name
{{mov{7,xl{9,(xs){{point back to string name{22076
{{add{7,xl{19,*schar{{point to chars of name{22077
{{mvw{{{{move characters into place{22078
{{mov{7,xr{8,wb{{restore vrblk pointer{22079
{{brn{6,gnv06{{{jump back to exit{22080
*      here for system variable case to fill in fields where
*      necessary from the fields present in the svblk.
{gnv16{mov{7,xl{3,gnvsp{{load pointer to svblk{22085
{{mov{9,(xr){7,xl{{set svblk ptr in vrblk{22086
{{mov{7,xr{8,wb{{restore vrblk pointer{22087
{{mov{8,wb{13,svbit(xl){{load bit indicators{22088
{{add{7,xl{19,*svchs{{point to characters of name{22089
{{add{7,xl{8,wa{{point past characters{22090
*      skip past keyword number (svknm) if present
{{mov{8,wc{4,btknm{{load test bit{22094
{{anb{8,wc{8,wb{{and to test{22095
{{zrb{8,wc{6,gnv17{{jump if no keyword number{22096
{{ica{7,xl{{{else bump pointer{22097
{{ejc{{{{{22098
*      gtnvr (continued)
*      here test for function (svfnc and svnar)
{gnv17{mov{8,wc{4,btfnc{{get test bit{22104
{{anb{8,wc{8,wb{{and to test{22105
{{zrb{8,wc{6,gnv18{{skip if no system function{22106
{{mov{13,vrfnc(xr){7,xl{{else point vrfnc to svfnc field{22107
{{add{7,xl{19,*num02{{and bump past svfnc, svnar fields{22108
*      now test for label (svlbl)
{gnv18{mov{8,wc{4,btlbl{{get test bit{22112
{{anb{8,wc{8,wb{{and to test{22113
{{zrb{8,wc{6,gnv19{{jump if bit is off (no system labl){22114
{{mov{13,vrlbl(xr){7,xl{{else point vrlbl to svlbl field{22115
{{ica{7,xl{{{bump past svlbl field{22116
*      now test for value (svval)
{gnv19{mov{8,wc{4,btval{{load test bit{22120
{{anb{8,wc{8,wb{{and to test{22121
{{zrb{8,wc{6,gnv06{{all done if no value{22122
{{mov{13,vrval(xr){9,(xl){{else set initial value{22123
{{mov{13,vrsto(xr){22,=b_vre{{set error store access{22124
{{brn{6,gnv06{{{merge back to exit to caller{22125
{{enp{{{{end procedure gtnvr{22126
{{ejc{{{{{22127
*      gtpat -- get pattern
*      gtpat is passed an object in (xr) and returns a
*      pattern after performing any necessary conversions
*      (xr)                  input argument
*      jsr  gtpat            call to convert to pattern
*      ppm  loc              transfer loc if convert impossible
*      (xr)                  resulting pattern
*      (wa)                  destroyed
*      (wb)                  destroyed (only on convert error)
*      (xr)                  unchanged (only on convert error)
{gtpat{prc{25,e{1,1{{entry point{22142
*z+
{{bhi{9,(xr){22,=p_aaa{6,gtpt5{jump if pattern already{22144
*      here if not pattern, try for string
{{mov{3,gtpsb{8,wb{{save wb{22148
{{mov{11,-(xs){7,xr{{stack argument for gtstg{22149
{{jsr{6,gtstg{{{convert argument to string{22150
{{ppm{6,gtpt2{{{jump if impossible{22151
*      here we have a string
{{bnz{8,wa{6,gtpt1{{jump if non-null{22155
*      here for null string. generate pointer to null pattern.
{{mov{7,xr{21,=ndnth{{point to nothen node{22159
{{brn{6,gtpt4{{{jump to exit{22160
{{ejc{{{{{22161
*      gtpat (continued)
*      here for non-null string
{gtpt1{mov{8,wb{22,=p_str{{load pcode for multi-char string{22167
{{bne{8,wa{18,=num01{6,gtpt3{jump if multi-char string{22168
*      here for one character string, share one character any
{{plc{7,xr{{{point to character{22172
{{lch{8,wa{9,(xr){{load character{22173
{{mov{7,xr{8,wa{{set as parm1{22174
{{mov{8,wb{22,=p_ans{{point to pcode for 1-char any{22175
{{brn{6,gtpt3{{{jump to build node{22176
*      here if argument is not convertible to string
{gtpt2{mov{8,wb{22,=p_exa{{set pcode for expression in case{22180
{{blo{9,(xr){22,=b_e__{6,gtpt3{jump to build node if expression{22181
*      here we have an error (conversion impossible)
{{exi{1,1{{{take convert error exit{22185
*      merge here to build node for string or expression
{gtpt3{jsr{6,pbild{{{call routine to build pattern node{22189
*      common exit after successful conversion
{gtpt4{mov{8,wb{3,gtpsb{{restore wb{22193
*      merge here to exit if no conversion required
{gtpt5{exi{{{{return to gtpat caller{22197
{{enp{{{{end procedure gtpat{22198
{{ejc{{{{{22201
*      gtrea -- get real value
*      gtrea is passed an object and returns a real value
*      performing any necessary conversions.
*      (xr)                  object to be converted
*      jsr  gtrea            call to convert object to real
*      ppm  loc              transfer loc if convert impossible
*      (xr)                  pointer to resulting real
*      (wa,wb,wc,ra)         destroyed
*      (xr)                  unchanged (convert error only)
{gtrea{prc{25,e{1,1{{entry point{22215
{{mov{8,wa{9,(xr){{get first word of block{22216
{{beq{8,wa{22,=b_rcl{6,gtre2{jump if real{22217
{{jsr{6,gtnum{{{else convert argument to numeric{22218
{{ppm{6,gtre3{{{jump if unconvertible{22219
{{beq{8,wa{22,=b_rcl{6,gtre2{jump if real was returned{22220
*      here for case of an integer to convert to real
{gtre1{ldi{13,icval(xr){{{load integer{22224
{{itr{{{{convert to real{22225
{{jsr{6,rcbld{{{build rcblk{22226
*      exit with real
{gtre2{exi{{{{return to gtrea caller{22230
*      here on conversion error
{gtre3{exi{1,1{{{take convert error exit{22234
{{enp{{{{end procedure gtrea{22235
{{ejc{{{{{22237
*      gtsmi -- get small integer
*      gtsmi is passed a snobol object and returns an address
*      integer in the range (0 le n le dnamb). such a value can
*      only be derived from an integer in the appropriate range.
*      small integers never appear as snobol values. however,
*      they are used internally for a variety of purposes.
*      -(xs)                 argument to convert (on stack)
*      jsr  gtsmi            call to convert to small integer
*      ppm  loc              transfer loc for not integer
*      ppm  loc              transfer loc for lt 0, gt dnamb
*      (xr,wc)               resulting small int (two copies)
*      (xs)                  popped
*      (ra)                  destroyed
*      (wa,wb)               destroyed (on convert error only)
*      (xr)                  input arg (convert error only)
{gtsmi{prc{25,n{1,2{{entry point{22257
{{mov{7,xr{10,(xs)+{{load argument{22258
{{beq{9,(xr){22,=b_icl{6,gtsm1{skip if already an integer{22259
*      here if not an integer
{{jsr{6,gtint{{{convert argument to integer{22263
{{ppm{6,gtsm2{{{jump if convert is impossible{22264
*      merge here with integer
{gtsm1{ldi{13,icval(xr){{{load integer value{22268
{{mfi{8,wc{6,gtsm3{{move as one word, jump if ovflow{22269
{{bgt{8,wc{3,mxlen{6,gtsm3{or if too large{22270
{{mov{7,xr{8,wc{{copy result to xr{22271
{{exi{{{{return to gtsmi caller{22272
*      here if unconvertible to integer
{gtsm2{exi{1,1{{{take non-integer error exit{22276
*      here if out of range
{gtsm3{exi{1,2{{{take out-of-range error exit{22280
{{enp{{{{end procedure gtsmi{22281
{{ejc{{{{{22282
*      gtstg -- get string
*      gtstg is passed an object and returns a string with
*      any necessary conversions performed.
*      -(xs)                 input argument (on stack)
*      jsr  gtstg            call to convert to string
*      ppm  loc              transfer loc if convert impossible
*      (xr)                  pointer to resulting string
*      (wa)                  length of string in characters
*      (xs)                  popped
*      (ra)                  destroyed
*      (xr)                  input arg (convert error only)
{gtstg{prc{25,n{1,1{{entry point{22348
{{mov{7,xr{10,(xs)+{{load argument, pop stack{22349
{{beq{9,(xr){22,=b_scl{6,gts30{jump if already a string{22350
*      here if not a string already
{gts01{mov{11,-(xs){7,xr{{restack argument in case error{22354
{{mov{11,-(xs){7,xl{{save xl{22355
{{mov{3,gtsvb{8,wb{{save wb{22356
{{mov{3,gtsvc{8,wc{{save wc{22357
{{mov{8,wa{9,(xr){{load first word of block{22358
{{beq{8,wa{22,=b_icl{6,gts05{jump to convert integer{22359
{{beq{8,wa{22,=b_rcl{6,gts10{jump to convert real{22362
{{beq{8,wa{22,=b_nml{6,gts03{jump to convert name{22364
*      here on conversion error
{gts02{mov{7,xl{10,(xs)+{{restore xl{22372
{{mov{7,xr{10,(xs)+{{reload input argument{22373
{{exi{1,1{{{take convert error exit{22374
{{ejc{{{{{22375
*      gtstg (continued)
*      here to convert a name (only possible if natural var)
{gts03{mov{7,xl{13,nmbas(xr){{load name base{22381
{{bhi{7,xl{3,state{6,gts02{error if not natural var (static){22382
{{add{7,xl{19,*vrsof{{else point to possible string name{22383
{{mov{8,wa{13,sclen(xl){{load length{22384
{{bnz{8,wa{6,gts04{{jump if not system variable{22385
{{mov{7,xl{13,vrsvo(xl){{else point to svblk{22386
{{mov{8,wa{13,svlen(xl){{and load name length{22387
*      merge here with string in xr, length in wa
{gts04{zer{8,wb{{{set offset to zero{22391
{{jsr{6,sbstr{{{use sbstr to copy string{22392
{{brn{6,gts29{{{jump to exit{22393
*      come here to convert an integer
{gts05{ldi{13,icval(xr){{{load integer value{22397
{{mov{3,gtssf{18,=num01{{set sign flag negative{22405
{{ilt{6,gts06{{{skip if integer is negative{22406
{{ngi{{{{else negate integer{22407
{{zer{3,gtssf{{{and reset negative flag{22408
{{ejc{{{{{22409
*      gtstg (continued)
*      here with sign flag set and sign forced negative as
*      required by the cvd instruction.
{gts06{mov{7,xr{3,gtswk{{point to result work area{22416
{{mov{8,wb{18,=nstmx{{initialize counter to max length{22417
{{psc{7,xr{8,wb{{prepare to store (right-left){22418
*      loop to convert digits into work area
{gts07{cvd{{{{convert one digit into wa{22422
{{sch{8,wa{11,-(xr){{store in work area{22423
{{dcv{8,wb{{{decrement counter{22424
{{ine{6,gts07{{{loop if more digits to go{22425
{{csc{7,xr{{{complete store characters{22426
*      merge here after converting integer or real into work
*      area. wb is set to nstmx - (number of chars in result).
{gts08{mov{8,wa{18,=nstmx{{get max number of characters{22432
{{sub{8,wa{8,wb{{compute length of result{22433
{{mov{7,xl{8,wa{{remember length for move later on{22434
{{add{8,wa{3,gtssf{{add one for negative sign if needed{22435
{{jsr{6,alocs{{{allocate string for result{22436
{{mov{8,wc{7,xr{{save result pointer for the moment{22437
{{psc{7,xr{{{point to chars of result block{22438
{{bze{3,gtssf{6,gts09{{skip if positive{22439
{{mov{8,wa{18,=ch_mn{{else load negative sign{22440
{{sch{8,wa{10,(xr)+{{and store it{22441
{{csc{7,xr{{{complete store characters{22442
*      here after dealing with sign
{gts09{mov{8,wa{7,xl{{recall length to move{22446
{{mov{7,xl{3,gtswk{{point to result work area{22447
{{plc{7,xl{8,wb{{point to first result character{22448
{{mvc{{{{move chars to result string{22449
{{mov{7,xr{8,wc{{restore result pointer{22450
{{brn{6,gts29{{{jump to exit{22453
{{ejc{{{{{22454
*      gtstg (continued)
*      here to convert a real
{gts10{ldr{13,rcval(xr){{{load real{22460
{{zer{3,gtssf{{{reset negative flag{22472
{{req{6,gts31{{{skip if zero{22473
{{rge{6,gts11{{{jump if real is positive{22474
{{mov{3,gtssf{18,=num01{{else set negative flag{22475
{{ngr{{{{and get absolute value of real{22476
*      now scale the real to the range (0.1 le x lt 1.0)
{gts11{ldi{4,intv0{{{initialize exponent to zero{22480
*      loop to scale up in steps of 10**10
{gts12{str{3,gtsrs{{{save real value{22484
{{sbr{4,reap1{{{subtract 0.1 to compare{22485
{{rge{6,gts13{{{jump if scale up not required{22486
{{ldr{3,gtsrs{{{else reload value{22487
{{mlr{4,reatt{{{multiply by 10**10{22488
{{sbi{4,intvt{{{decrement exponent by 10{22489
{{brn{6,gts12{{{loop back to test again{22490
*      test for scale down required
{gts13{ldr{3,gtsrs{{{reload value{22494
{{sbr{4,reav1{{{subtract 1.0{22495
{{rlt{6,gts17{{{jump if no scale down required{22496
{{ldr{3,gtsrs{{{else reload value{22497
*      loop to scale down in steps of 10**10
{gts14{sbr{4,reatt{{{subtract 10**10 to compare{22501
{{rlt{6,gts15{{{jump if large step not required{22502
{{ldr{3,gtsrs{{{else restore value{22503
{{dvr{4,reatt{{{divide by 10**10{22504
{{str{3,gtsrs{{{store new value{22505
{{adi{4,intvt{{{increment exponent by 10{22506
{{brn{6,gts14{{{loop back{22507
{{ejc{{{{{22508
*      gtstg (continued)
*      at this point we have (1.0 le x lt 10**10)
*      complete scaling with powers of ten table
{gts15{mov{7,xr{21,=reav1{{point to powers of ten table{22515
*      loop to locate correct entry in table
{gts16{ldr{3,gtsrs{{{reload value{22519
{{adi{4,intv1{{{increment exponent{22520
{{add{7,xr{19,*cfp_r{{point to next entry in table{22521
{{sbr{9,(xr){{{subtract it to compare{22522
{{rge{6,gts16{{{loop till we find a larger entry{22523
{{ldr{3,gtsrs{{{then reload the value{22524
{{dvr{9,(xr){{{and complete scaling{22525
{{str{3,gtsrs{{{store value{22526
*      we are now scaled, so round by adding 0.5 * 10**(-cfp_s)
{gts17{ldr{3,gtsrs{{{get value again{22530
{{adr{3,gtsrn{{{add rounding factor{22531
{{str{3,gtsrs{{{store result{22532
*      the rounding operation may have pushed us up past
*      1.0 again, so check one more time.
{{sbr{4,reav1{{{subtract 1.0 to compare{22537
{{rlt{6,gts18{{{skip if ok{22538
{{adi{4,intv1{{{else increment exponent{22539
{{ldr{3,gtsrs{{{reload value{22540
{{dvr{4,reavt{{{divide by 10.0 to rescale{22541
{{brn{6,gts19{{{jump to merge{22542
*      here if rounding did not muck up scaling
{gts18{ldr{3,gtsrs{{{reload rounded value{22546
{{ejc{{{{{22547
*      gtstg (continued)
*      now we have completed the scaling as follows
*      (ia)                  signed exponent
*      (ra)                  scaled real (absolute value)
*      if the exponent is negative or greater than cfp_s, then
*      we convert the number in the form.
*      (neg sign) 0 . (cpf_s digits) e (exp sign) (exp digits)
*      if the exponent is positive and less than or equal to
*      cfp_s, the number is converted in the form.
*      (neg sign) (exponent digits) . (cfp_s-exponent digits)
*      in both cases, the formats obtained from the above
*      rules are modified by deleting trailing zeros after the
*      decimal point. there are no leading zeros in the exponent
*      and the exponent sign is always present.
{gts19{mov{7,xl{18,=cfp_s{{set num dec digits = cfp_s{22571
{{mov{3,gtses{18,=ch_mn{{set exponent sign negative{22572
{{ilt{6,gts21{{{all set if exponent is negative{22573
{{mfi{8,wa{{{else fetch exponent{22574
{{ble{8,wa{18,=cfp_s{6,gts20{skip if we can use special format{22575
{{mti{8,wa{{{else restore exponent{22576
{{ngi{{{{set negative for cvd{22577
{{mov{3,gtses{18,=ch_pl{{set plus sign for exponent sign{22578
{{brn{6,gts21{{{jump to generate exponent{22579
*      here if we can use the format without an exponent
{gts20{sub{7,xl{8,wa{{compute digits after decimal point{22583
{{ldi{4,intv0{{{reset exponent to zero{22584
{{ejc{{{{{22585
*      gtstg (continued)
*      merge here as follows
*      (ia)                  exponent absolute value
*      gtses                 character for exponent sign
*      (ra)                  positive fraction
*      (xl)                  number of digits after dec point
{gts21{mov{7,xr{3,gtswk{{point to work area{22596
{{mov{8,wb{18,=nstmx{{set character ctr to max length{22597
{{psc{7,xr{8,wb{{prepare to store (right to left){22598
{{ieq{6,gts23{{{skip exponent if it is zero{22599
*      loop to generate digits of exponent
{gts22{cvd{{{{convert a digit into wa{22603
{{sch{8,wa{11,-(xr){{store in work area{22604
{{dcv{8,wb{{{decrement counter{22605
{{ine{6,gts22{{{loop back if more digits to go{22606
*      here generate exponent sign and e
{{mov{8,wa{3,gtses{{load exponent sign{22610
{{sch{8,wa{11,-(xr){{store in work area{22611
{{mov{8,wa{18,=ch_le{{get character letter e{22612
{{sch{8,wa{11,-(xr){{store in work area{22613
{{sub{8,wb{18,=num02{{decrement counter for sign and e{22614
*      here to generate the fraction
{gts23{mlr{3,gtssc{{{convert real to integer (10**cfp_s){22618
{{rti{{{{get integer (overflow impossible){22619
{{ngi{{{{negate as required by cvd{22620
*      loop to suppress trailing zeros
{gts24{bze{7,xl{6,gts27{{jump if no digits left to do{22624
{{cvd{{{{else convert one digit{22625
{{bne{8,wa{18,=ch_d0{6,gts26{jump if not a zero{22626
{{dcv{7,xl{{{decrement counter{22627
{{brn{6,gts24{{{loop back for next digit{22628
{{ejc{{{{{22629
*      gtstg (continued)
*      loop to generate digits after decimal point
{gts25{cvd{{{{convert a digit into wa{22635
*      merge here first time
{gts26{sch{8,wa{11,-(xr){{store digit{22639
{{dcv{8,wb{{{decrement counter{22640
{{dcv{7,xl{{{decrement counter{22641
{{bnz{7,xl{6,gts25{{loop back if more to go{22642
*      here generate the decimal point
{gts27{mov{8,wa{18,=ch_dt{{load decimal point{22646
{{sch{8,wa{11,-(xr){{store in work area{22647
{{dcv{8,wb{{{decrement counter{22648
*      here generate the digits before the decimal point
{gts28{cvd{{{{convert a digit into wa{22652
{{sch{8,wa{11,-(xr){{store in work area{22653
{{dcv{8,wb{{{decrement counter{22654
{{ine{6,gts28{{{loop back if more to go{22655
{{csc{7,xr{{{complete store characters{22656
{{brn{6,gts08{{{else jump back to exit{22657
*      exit point after successful conversion
{gts29{mov{7,xl{10,(xs)+{{restore xl{22663
{{ica{7,xs{{{pop argument{22664
{{mov{8,wb{3,gtsvb{{restore wb{22665
{{mov{8,wc{3,gtsvc{{restore wc{22666
*      merge here if no conversion required
{gts30{mov{8,wa{13,sclen(xr){{load string length{22670
{{exi{{{{return to caller{22671
*      here to return string for real zero
{gts31{mov{7,xl{21,=scre0{{point to string{22677
{{mov{8,wa{18,=num02{{2 chars{22678
{{zer{8,wb{{{zero offset{22679
{{jsr{6,sbstr{{{copy string{22680
{{brn{6,gts29{{{return{22681
{{enp{{{{end procedure gtstg{22708
{{ejc{{{{{22709
*      gtvar -- get variable for i/o/trace association
*      gtvar is used to point to an actual variable location
*      for the detach,input,output,trace,stoptr system functions
*      (xr)                  argument to function
*      jsr  gtvar            call to locate variable pointer
*      ppm  loc              transfer loc if not ok variable
*      (xl,wa)               name base,offset of variable
*      (xr,ra)               destroyed
*      (wb,wc)               destroyed (convert error only)
*      (xr)                  input arg (convert error only)
{gtvar{prc{25,e{1,1{{entry point{22724
{{bne{9,(xr){22,=b_nml{6,gtvr2{jump if not a name{22725
{{mov{8,wa{13,nmofs(xr){{else load name offset{22726
{{mov{7,xl{13,nmbas(xr){{load name base{22727
{{beq{9,(xl){22,=b_evt{6,gtvr1{error if expression variable{22728
{{bne{9,(xl){22,=b_kvt{6,gtvr3{all ok if not keyword variable{22729
*      here on conversion error
{gtvr1{exi{1,1{{{take convert error exit{22733
*      here if not a name, try convert to natural variable
{gtvr2{mov{3,gtvrc{8,wc{{save wc{22737
{{jsr{6,gtnvr{{{locate vrblk if possible{22738
{{ppm{6,gtvr1{{{jump if convert error{22739
{{mov{7,xl{7,xr{{else copy vrblk name base{22740
{{mov{8,wa{19,*vrval{{and set offset{22741
{{mov{8,wc{3,gtvrc{{restore wc{22742
*      here for name obtained
{gtvr3{bhi{7,xl{3,state{6,gtvr4{all ok if not natural variable{22746
{{beq{13,vrsto(xl){22,=b_vre{6,gtvr1{error if protected variable{22747
*      common exit point
{gtvr4{exi{{{{return to caller{22751
{{enp{{{{end procedure gtvar{22752
{{ejc{{{{{22753
{{ejc{{{{{22754
*      hashs -- compute hash index for string
*      hashs is used to convert a string to a unique integer
*      value. the resulting hash value is a positive integer
*      in the range 0 to cfp_m
*      (xr)                  string to be hashed
*      jsr  hashs            call to hash string
*      (ia)                  hash value
*      (xr,wb,wc)            destroyed
*      the hash function used is as follows.
*      start with the length of the string.
*      if there is more than one character in a word,
*      take the first e_hnw words of the characters from
*      the string or all the words if fewer than e_hnw.
*      compute the exclusive or of all these words treating
*      them as one word bit string values.
*      if there is just one character in a word,
*      then mimic the word by word hash by shifting
*      successive characters to get a similar effect.
*      e_hnw is set to zero in case only one character per word.
*      move the result as an integer with the mti instruction.
*      the test on e_hnw is done dynamically. this should be done
*      eventually using conditional assembly, but that would require
*      changes to the build process (ds 8 may 2013).
{hashs{prc{25,e{1,0{{entry point{22790
*z-
{{mov{8,wc{18,=e_hnw{{get number of words to use{22792
{{bze{8,wc{6,hshsa{{branch if one character per word{22793
{{mov{8,wc{13,sclen(xr){{load string length in characters{22794
{{mov{8,wb{8,wc{{initialize with length{22795
{{bze{8,wc{6,hshs3{{jump if null string{22796
{{zgb{8,wb{{{correct byte ordering if necessary{22797
{{ctw{8,wc{1,0{{get number of words of chars{22798
{{add{7,xr{19,*schar{{point to characters of string{22799
{{blo{8,wc{18,=e_hnw{6,hshs1{use whole string if short{22800
{{mov{8,wc{18,=e_hnw{{else set to involve first e_hnw wds{22801
*      here with count of words to check in wc
{hshs1{lct{8,wc{8,wc{{set counter to control loop{22805
*      loop to compute exclusive or
{hshs2{xob{8,wb{10,(xr)+{{exclusive or next word of chars{22809
{{bct{8,wc{6,hshs2{{loop till all processed{22810
*      merge here with exclusive or in wb
{hshs3{zgb{8,wb{{{zeroise undefined bits{22814
{{anb{8,wb{4,bitsm{{ensure in range 0 to cfp_m{22815
{{mti{8,wb{{{move result as integer{22816
{{zer{7,xr{{{clear garbage value in xr{22817
{{exi{{{{return to hashs caller{22818
*      here if just one character per word
{hshsa{mov{8,wc{13,sclen(xr){{load string length in characters{22822
{{mov{8,wb{8,wc{{initialize with length{22823
{{bze{8,wc{6,hshs3{{jump if null string{22824
{{zgb{8,wb{{{correct byte ordering if necessary{22825
{{ctw{8,wc{1,0{{get number of words of chars{22826
{{plc{7,xr{{{{22827
{{mov{11,-(xs){7,xl{{save xl{22828
{{mov{7,xl{8,wc{{load length for branch{22829
{{bge{7,xl{18,=num25{6,hsh24{use first characters if longer{22830
{{bsw{7,xl{1,25{{merge to compute hash{22831
{{iff{1,0{6,hsh00{{{22857
{{iff{1,1{6,hsh01{{{22857
{{iff{1,2{6,hsh02{{{22857
{{iff{1,3{6,hsh03{{{22857
{{iff{1,4{6,hsh04{{{22857
{{iff{1,5{6,hsh05{{{22857
{{iff{1,6{6,hsh06{{{22857
{{iff{1,7{6,hsh07{{{22857
{{iff{1,8{6,hsh08{{{22857
{{iff{1,9{6,hsh09{{{22857
{{iff{1,10{6,hsh10{{{22857
{{iff{1,11{6,hsh11{{{22857
{{iff{1,12{6,hsh12{{{22857
{{iff{1,13{6,hsh13{{{22857
{{iff{1,14{6,hsh14{{{22857
{{iff{1,15{6,hsh15{{{22857
{{iff{1,16{6,hsh16{{{22857
{{iff{1,17{6,hsh17{{{22857
{{iff{1,18{6,hsh18{{{22857
{{iff{1,19{6,hsh19{{{22857
{{iff{1,20{6,hsh20{{{22857
{{iff{1,21{6,hsh21{{{22857
{{iff{1,22{6,hsh22{{{22857
{{iff{1,23{6,hsh23{{{22857
{{iff{1,24{6,hsh24{{{22857
{{esw{{{{{22857
{hsh24{lch{8,wc{10,(xr)+{{load next character{22858
{{lsh{8,wc{1,24{{shift for hash{22859
{{xob{8,wb{8,wc{{hash character{22860
{hsh23{lch{8,wc{10,(xr)+{{load next character{22861
{{lsh{8,wc{1,16{{shift for hash{22862
{{xob{8,wb{8,wc{{hash character{22863
{hsh22{lch{8,wc{10,(xr)+{{load next character{22864
{{lsh{8,wc{1,8{{shift for hash{22865
{{xob{8,wb{8,wc{{hash character{22866
{hsh21{lch{8,wc{10,(xr)+{{load next character{22867
{{xob{8,wb{8,wc{{hash character{22868
{hsh20{lch{8,wc{10,(xr)+{{load next character{22869
{{lsh{8,wc{1,24{{shift for hash{22870
{{xob{8,wb{8,wc{{hash character{22871
{hsh19{lch{8,wc{10,(xr)+{{load next character{22872
{{lsh{8,wc{1,16{{shift for hash{22873
{{xob{8,wb{8,wc{{hash character{22874
{hsh18{lch{8,wc{10,(xr)+{{load next character{22875
{{lsh{8,wc{1,8{{shift for hash{22876
{{xob{8,wb{8,wc{{hash character{22877
{hsh17{lch{8,wc{10,(xr)+{{load next character{22878
{{xob{8,wb{8,wc{{hash character{22879
{hsh16{lch{8,wc{10,(xr)+{{load next character{22880
{{lsh{8,wc{1,24{{shift for hash{22881
{{xob{8,wb{8,wc{{hash character{22882
{hsh15{lch{8,wc{10,(xr)+{{load next character{22883
{{lsh{8,wc{1,16{{shift for hash{22884
{{xob{8,wb{8,wc{{hash character{22885
{hsh14{lch{8,wc{10,(xr)+{{load next character{22886
{{lsh{8,wc{1,8{{shift for hash{22887
{{xob{8,wb{8,wc{{hash character{22888
{hsh13{lch{8,wc{10,(xr)+{{load next character{22889
{{xob{8,wb{8,wc{{hash character{22890
{hsh12{lch{8,wc{10,(xr)+{{load next character{22891
{{lsh{8,wc{1,24{{shift for hash{22892
{{xob{8,wb{8,wc{{hash character{22893
{hsh11{lch{8,wc{10,(xr)+{{load next character{22894
{{lsh{8,wc{1,16{{shift for hash{22895
{{xob{8,wb{8,wc{{hash character{22896
{hsh10{lch{8,wc{10,(xr)+{{load next character{22897
{{lsh{8,wc{1,8{{shift for hash{22898
{{xob{8,wb{8,wc{{hash character{22899
{hsh09{lch{8,wc{10,(xr)+{{load next character{22900
{{xob{8,wb{8,wc{{hash character{22901
{hsh08{lch{8,wc{10,(xr)+{{load next character{22902
{{lsh{8,wc{1,24{{shift for hash{22903
{{xob{8,wb{8,wc{{hash character{22904
{hsh07{lch{8,wc{10,(xr)+{{load next character{22905
{{lsh{8,wc{1,16{{shift for hash{22906
{{xob{8,wb{8,wc{{hash character{22907
{hsh06{lch{8,wc{10,(xr)+{{load next character{22908
{{lsh{8,wc{1,8{{shift for hash{22909
{{xob{8,wb{8,wc{{hash character{22910
{hsh05{lch{8,wc{10,(xr)+{{load next character{22911
{{xob{8,wb{8,wc{{hash character{22912
{hsh04{lch{8,wc{10,(xr)+{{load next character{22913
{{lsh{8,wc{1,24{{shift for hash{22914
{{xob{8,wb{8,wc{{hash character{22915
{hsh03{lch{8,wc{10,(xr)+{{load next character{22916
{{lsh{8,wc{1,16{{shift for hash{22917
{{xob{8,wb{8,wc{{hash character{22918
{hsh02{lch{8,wc{10,(xr)+{{load next character{22919
{{lsh{8,wc{1,8{{shift for hash{22920
{{xob{8,wb{8,wc{{hash character{22921
{hsh01{lch{8,wc{10,(xr)+{{load next character{22922
{{xob{8,wb{8,wc{{hash character{22923
{hsh00{mov{7,xl{10,(xs)+{{restore xl{22924
{{brn{6,hshs3{{{merge to complete hash{22925
{{enp{{{{end procedure hashs{22926
*      icbld -- build integer block
*      (ia)                  integer value for icblk
*      jsr  icbld            call to build integer block
*      (xr)                  pointer to result icblk
*      (wa)                  destroyed
{icbld{prc{25,e{1,0{{entry point{22935
*z+
{{mfi{7,xr{6,icbl1{{copy small integers{22937
{{ble{7,xr{18,=num02{6,icbl3{jump if 0,1 or 2{22938
*      construct icblk
{icbl1{mov{7,xr{3,dnamp{{load pointer to next available loc{22942
{{add{7,xr{19,*icsi_{{point past new icblk{22943
{{blo{7,xr{3,dname{6,icbl2{jump if there is room{22944
{{mov{8,wa{19,*icsi_{{else load length of icblk{22945
{{jsr{6,alloc{{{use standard allocator to get block{22946
{{add{7,xr{8,wa{{point past block to merge{22947
*      merge here with xr pointing past the block obtained
{icbl2{mov{3,dnamp{7,xr{{set new pointer{22951
{{sub{7,xr{19,*icsi_{{point back to start of block{22952
{{mov{9,(xr){22,=b_icl{{store type word{22953
{{sti{13,icval(xr){{{store integer value in icblk{22954
{{exi{{{{return to icbld caller{22955
*      optimise by not building icblks for small integers
{icbl3{wtb{7,xr{{{convert integer to offset{22959
{{mov{7,xr{14,intab(xr){{point to pre-built icblk{22960
{{exi{{{{return{22961
{{enp{{{{end procedure icbld{22962
{{ejc{{{{{22963
*      ident -- compare two values
*      ident compares two values in the sense of the ident
*      differ functions available at the snobol level.
*      (xr)                  first argument
*      (xl)                  second argument
*      jsr  ident            call to compare arguments
*      ppm  loc              transfer loc if ident
*      (normal return if differ)
*      (xr,xl,wc,ra)         destroyed
{ident{prc{25,e{1,1{{entry point{22977
{{beq{7,xr{7,xl{6,iden7{jump if same pointer (ident){22978
{{mov{8,wc{9,(xr){{else load arg 1 type word{22979
{{bne{8,wc{9,(xl){6,iden1{differ if arg 2 type word differ{22981
{{beq{8,wc{22,=b_scl{6,iden2{jump if strings{22985
{{beq{8,wc{22,=b_icl{6,iden4{jump if integers{22986
{{beq{8,wc{22,=b_rcl{6,iden5{jump if reals{22989
{{beq{8,wc{22,=b_nml{6,iden6{jump if names{22991
*      for all other datatypes, must be differ if xr ne xl
*      merge here for differ
{iden1{exi{{{{take differ exit{23034
*      here for strings, ident only if lengths and chars same
{iden2{mov{8,wc{13,sclen(xr){{load arg 1 length{23038
{{bne{8,wc{13,sclen(xl){6,iden1{differ if lengths differ{23039
*      buffer and string comparisons merge here
{idn2a{add{7,xr{19,*schar{{point to chars of arg 1{23043
{{add{7,xl{19,*schar{{point to chars of arg 2{23044
{{ctw{8,wc{1,0{{get number of words in strings{23045
{{lct{8,wc{8,wc{{set loop counter{23046
*      loop to compare characters. note that wc cannot be zero
*      since all null strings point to nulls and give xl=xr.
{iden3{cne{9,(xr){9,(xl){6,iden8{differ if chars do not match{23051
{{ica{7,xr{{{else bump arg one pointer{23052
{{ica{7,xl{{{bump arg two pointer{23053
{{bct{8,wc{6,iden3{{loop back till all checked{23054
{{ejc{{{{{23055
*      ident (continued)
*      here to exit for case of two ident strings
{{zer{7,xl{{{clear garbage value in xl{23061
{{zer{7,xr{{{clear garbage value in xr{23062
{{exi{1,1{{{take ident exit{23063
*      here for integers, ident if same values
{iden4{ldi{13,icval(xr){{{load arg 1{23067
{{sbi{13,icval(xl){{{subtract arg 2 to compare{23068
{{iov{6,iden1{{{differ if overflow{23069
{{ine{6,iden1{{{differ if result is not zero{23070
{{exi{1,1{{{take ident exit{23071
*      here for reals, ident if same values
{iden5{ldr{13,rcval(xr){{{load arg 1{23077
{{sbr{13,rcval(xl){{{subtract arg 2 to compare{23078
{{rov{6,iden1{{{differ if overflow{23079
{{rne{6,iden1{{{differ if result is not zero{23080
{{exi{1,1{{{take ident exit{23081
*      here for names, ident if bases and offsets same
{iden6{bne{13,nmofs(xr){13,nmofs(xl){6,iden1{differ if different offset{23086
{{bne{13,nmbas(xr){13,nmbas(xl){6,iden1{differ if different base{23087
*      merge here to signal ident for identical pointers
{iden7{exi{1,1{{{take ident exit{23091
*      here for differ strings
{iden8{zer{7,xr{{{clear garbage ptr in xr{23095
{{zer{7,xl{{{clear garbage ptr in xl{23096
{{exi{{{{return to caller (differ){23097
{{enp{{{{end procedure ident{23098
{{ejc{{{{{23099
*      inout - used to initialise input and output variables
*      (xl)                  pointer to vbl name string
*      (wb)                  trblk type
*      jsr  inout            call to perform initialisation
*      (xl)                  vrblk ptr
*      (xr)                  trblk ptr
*      (wa,wc)               destroyed
*      note that trter (= trtrf) field of standard i/o variables
*      points to corresponding svblk not to a trblk as is the
*      case for ordinary variables.
{inout{prc{25,e{1,0{{entry point{23114
{{mov{11,-(xs){8,wb{{stack trblk type{23115
{{mov{8,wa{13,sclen(xl){{get name length{23116
{{zer{8,wb{{{point to start of name{23117
{{jsr{6,sbstr{{{build a proper scblk{23118
{{jsr{6,gtnvr{{{build vrblk{23119
{{ppm{{{{no error return{23120
{{mov{8,wc{7,xr{{save vrblk pointer{23121
{{mov{8,wb{10,(xs)+{{get trter field{23122
{{zer{7,xl{{{zero trfpt{23123
{{jsr{6,trbld{{{build trblk{23124
{{mov{7,xl{8,wc{{recall vrblk pointer{23125
{{mov{13,trter(xr){13,vrsvp(xl){{store svblk pointer{23126
{{mov{13,vrval(xl){7,xr{{store trblk ptr in vrblk{23127
{{mov{13,vrget(xl){22,=b_vra{{set trapped access{23128
{{mov{13,vrsto(xl){22,=b_vrv{{set trapped store{23129
{{exi{{{{return to caller{23130
{{enp{{{{end procedure inout{23131
{{ejc{{{{{23132
*      insta - used to initialize structures in static region
*      (xr)                  pointer to starting static location
*      jsr  insta            call to initialize static structure
*      (xr)                  ptr to next free static location
*      (wa,wb,wc)            destroyed
*      note that this procedure establishes the pointers
*      prbuf, gtswk, and kvalp.
{insta{prc{25,e{1,0{{entry point{23311
*      initialize print buffer with blank words
*z-
{{mov{8,wc{3,prlen{{no. of chars in print bfr{23316
{{mov{3,prbuf{7,xr{{print bfr is put at static start{23317
{{mov{10,(xr)+{22,=b_scl{{store string type code{23318
{{mov{10,(xr)+{8,wc{{and string length{23319
{{ctw{8,wc{1,0{{get number of words in buffer{23320
{{mov{3,prlnw{8,wc{{store for buffer clear{23321
{{lct{8,wc{8,wc{{words to clear{23322
*      loop to clear buffer
{inst1{mov{10,(xr)+{4,nullw{{store blank{23326
{{bct{8,wc{6,inst1{{loop{23327
*      allocate work area for gtstg conversion procedure
{{mov{8,wa{18,=nstmx{{get max num chars in output number{23331
{{ctb{8,wa{2,scsi_{{no of bytes needed{23332
{{mov{3,gtswk{7,xr{{store bfr adrs{23333
{{add{7,xr{8,wa{{bump for work bfr{23334
*      build alphabet string for alphabet keyword and replace
{{mov{3,kvalp{7,xr{{save alphabet pointer{23338
{{mov{9,(xr){22,=b_scl{{string blk type{23339
{{mov{8,wc{18,=cfp_a{{no of chars in alphabet{23340
{{mov{13,sclen(xr){8,wc{{store as string length{23341
{{mov{8,wb{8,wc{{copy char count{23342
{{ctb{8,wb{2,scsi_{{no. of bytes needed{23343
{{add{8,wb{7,xr{{current end address for static{23344
{{mov{8,wa{8,wb{{save adrs past alphabet string{23345
{{lct{8,wc{8,wc{{loop counter{23346
{{psc{7,xr{{{point to chars of string{23347
{{zer{8,wb{{{set initial character value{23348
*      loop to enter character codes in order
{inst2{sch{8,wb{10,(xr)+{{store next code{23352
{{icv{8,wb{{{bump code value{23353
{{bct{8,wc{6,inst2{{loop till all stored{23354
{{csc{7,xr{{{complete store characters{23355
{{mov{7,xr{8,wa{{return current static ptr{23356
{{exi{{{{return to caller{23357
{{enp{{{{end procedure insta{23358
{{ejc{{{{{23359
*      iofcb -- get input/output fcblk pointer
*      used by endfile, eject and rewind to find the fcblk
*      (if any) corresponding to their argument.
*      -(xs)                 argument
*      jsr  iofcb            call to find fcblk
*      ppm  loc              arg is an unsuitable name
*      ppm  loc              arg is null string
*      ppm  loc              arg file not found
*      (xs)                  popped
*      (xl)                  ptr to filearg1 vrblk
*      (xr)                  argument
*      (wa)                  fcblk ptr or 0
*      (wb,wc)               destroyed
{iofcb{prc{25,n{1,3{{entry point{23377
*z+
{{jsr{6,gtstg{{{get arg as string{23379
{{ppm{6,iofc2{{{fail{23380
{{mov{7,xl{7,xr{{copy string ptr{23381
{{jsr{6,gtnvr{{{get as natural variable{23382
{{ppm{6,iofc3{{{fail if null{23383
{{mov{8,wb{7,xl{{copy string pointer again{23384
{{mov{7,xl{7,xr{{copy vrblk ptr for return{23385
{{zer{8,wa{{{in case no trblk found{23386
*      loop to find file arg1 trblk
{iofc1{mov{7,xr{13,vrval(xr){{get possible trblk ptr{23390
{{bne{9,(xr){22,=b_trt{6,iofc4{fail if end of chain{23391
{{bne{13,trtyp(xr){18,=trtfc{6,iofc1{loop if not file arg trblk{23392
{{mov{8,wa{13,trfpt(xr){{get fcblk ptr{23393
{{mov{7,xr{8,wb{{copy arg{23394
{{exi{{{{return{23395
*      fail return
{iofc2{exi{1,1{{{fail{23399
*      null arg
{iofc3{exi{1,2{{{null arg return{23403
*      file not found
{iofc4{exi{1,3{{{file not found return{23407
{{enp{{{{end procedure iofcb{23408
{{ejc{{{{{23409
*      ioppf -- process filearg2 for ioput
*      (r_xsc)               filearg2 ptr
*      jsr  ioppf            call to process filearg2
*      (xl)                  filearg1 ptr
*      (xr)                  file arg2 ptr
*      -(xs)...-(xs)         fields extracted from filearg2
*      (wc)                  no. of fields extracted
*      (wb)                  input/output flag
*      (wa)                  fcblk ptr or 0
{ioppf{prc{25,n{1,0{{entry point{23422
{{zer{8,wb{{{to count fields extracted{23423
*      loop to extract fields
{iopp1{mov{7,xl{18,=iodel{{get delimiter{23427
{{mov{8,wc{7,xl{{copy it{23428
{{zer{8,wa{{{retain leading blanks in filearg2{23429
{{jsr{6,xscan{{{get next field{23430
{{mov{11,-(xs){7,xr{{stack it{23431
{{icv{8,wb{{{increment count{23432
{{bnz{8,wa{6,iopp1{{loop{23433
{{mov{8,wc{8,wb{{count of fields{23434
{{mov{8,wb{3,ioptt{{i/o marker{23435
{{mov{8,wa{3,r_iof{{fcblk ptr or 0{23436
{{mov{7,xr{3,r_io2{{file arg2 ptr{23437
{{mov{7,xl{3,r_io1{{filearg1{23438
{{exi{{{{return{23439
{{enp{{{{end procedure ioppf{23440
{{ejc{{{{{23441
*      ioput -- routine used by input and output
*      ioput sets up input/output  associations. it builds
*      such trace and file control blocks as are necessary and
*      calls sysfc,sysio to perform checks on the
*      arguments and to open the files.
*         +-----------+   +---------------+       +-----------+
*      +-.i           i   i               i------.i   =b_xrt  i
*      i  +-----------+   +---------------+       +-----------+
*      i  /           /        (r_fcb)            i    *4     i
*      i  /           /                           +-----------+
*      i  +-----------+   +---------------+       i           i-
*      i  i   name    +--.i    =b_trt     i       +-----------+
*      i  /           /   +---------------+       i           i
*      i   (first arg)    i =trtin/=trtou i       +-----------+
*      i                  +---------------+             i
*      i                  i     value     i             i
*      i                  +---------------+             i
*      i                  i(trtrf) 0   or i--+          i
*      i                  +---------------+  i          i
*      i                  i(trfpt) 0   or i----+        i
*      i                  +---------------+  i i        i
*      i                     (i/o trblk)     i i        i
*      i  +-----------+                      i i        i
*      i  i           i                      i i        i
*      i  +-----------+                      i i        i
*      i  i           i                      i i        i
*      i  +-----------+   +---------------+  i i        i
*      i  i           +--.i    =b_trt     i.-+ i        i
*      i  +-----------+   +---------------+    i        i
*      i  /           /   i    =trtfc     i    i        i
*      i  /           /   +---------------+    i        i
*      i    (filearg1     i     value     i    i        i
*      i         vrblk)   +---------------+    i        i
*      i                  i(trtrf) 0   or i--+ i        .
*      i                  +---------------+  i .  +-----------+
*      i                  i(trfpt) 0   or i------./   fcblk   /
*      i                  +---------------+  i    +-----------+
*      i                       (trtrf)       i
*      i                                     i
*      i                                     i
*      i                  +---------------+  i
*      i                  i    =b_xrt     i.-+
*      i                  +---------------+
*      i                  i      *5       i
*      i                  +---------------+
*      +------------------i               i
*                         +---------------+       +-----------+
*                         i(trtrf) o   or i------.i  =b_xrt   i
*                         +---------------+       +-----------+
*                         i  name offset  i       i    etc    i
*                         +---------------+
*                           (iochn - chain of name pointers)
{{ejc{{{{{23497
*      ioput (continued)
*      no additional trap blocks are used for standard input/out
*      files. otherwise an i/o trap block is attached to second
*      arg (filearg1) vrblk. see diagram above for details of
*      the structure built.
*      -(xs)                 1st arg (vbl to be associated)
*      -(xs)                 2nd arg (file arg1)
*      -(xs)                 3rd arg (file arg2)
*      (wb)                  0 for input, 3 for output assoc.
*      jsr  ioput            call for input/output association
*      ppm  loc              3rd arg not a string
*      ppm  loc              2nd arg not a suitable name
*      ppm  loc              1st arg not a suitable name
*      ppm  loc              inappropriate file spec for i/o
*      ppm  loc              i/o file does not exist
*      ppm  loc              i/o file cannot be read/written
*      ppm  loc              i/o fcblk currently in use
*      (xs)                  popped
*      (xl,xr,wa,wb,wc)      destroyed
{ioput{prc{25,n{1,7{{entry point{23521
{{zer{3,r_iot{{{in case no trtrf block used{23522
{{zer{3,r_iof{{{in case no fcblk alocated{23523
{{zer{3,r_iop{{{in case sysio fails{23524
{{mov{3,ioptt{8,wb{{store i/o trace type{23525
{{jsr{6,xscni{{{prepare to scan filearg2{23526
{{ppm{6,iop13{{{fail{23527
{{ppm{6,iopa0{{{null file arg2{23528
{iopa0{mov{3,r_io2{7,xr{{keep file arg2{23530
{{mov{7,xl{8,wa{{copy length{23531
{{jsr{6,gtstg{{{convert filearg1 to string{23532
{{ppm{6,iop14{{{fail{23533
{{mov{3,r_io1{7,xr{{keep filearg1 ptr{23534
{{jsr{6,gtnvr{{{convert to natural variable{23535
{{ppm{6,iop00{{{jump if null{23536
{{brn{6,iop04{{{jump to process non-null args{23537
*      null filearg1
{iop00{bze{7,xl{6,iop01{{skip if both args null{23541
{{jsr{6,ioppf{{{process filearg2{23542
{{jsr{6,sysfc{{{call for filearg2 check{23543
{{ppm{6,iop16{{{fail{23544
{{ppm{6,iop26{{{fail{23545
{{brn{6,iop11{{{complete file association{23546
{{ejc{{{{{23547
*      ioput (continued)
*      here with 0 or fcblk ptr in (xl)
{iop01{mov{8,wb{3,ioptt{{get trace type{23553
{{mov{7,xr{3,r_iot{{get 0 or trtrf ptr{23554
{{jsr{6,trbld{{{build trblk{23555
{{mov{8,wc{7,xr{{copy trblk pointer{23556
{{mov{7,xr{10,(xs)+{{get variable from stack{23557
{{mov{11,-(xs){8,wc{{make trblk collectable{23558
{{jsr{6,gtvar{{{point to variable{23559
{{ppm{6,iop15{{{fail{23560
{{mov{8,wc{10,(xs)+{{recover trblk pointer{23561
{{mov{3,r_ion{7,xl{{save name pointer{23562
{{mov{7,xr{7,xl{{copy name pointer{23563
{{add{7,xr{8,wa{{point to variable{23564
{{sub{7,xr{19,*vrval{{subtract offset,merge into loop{23565
*      loop to end of trblk chain if any
{iop02{mov{7,xl{7,xr{{copy blk ptr{23569
{{mov{7,xr{13,vrval(xr){{load ptr to next trblk{23570
{{bne{9,(xr){22,=b_trt{6,iop03{jump if not trapped{23571
{{bne{13,trtyp(xr){3,ioptt{6,iop02{loop if not same assocn{23572
{{mov{7,xr{13,trnxt(xr){{get value and delete old trblk{23573
*      ioput (continued)
*      store new association
{iop03{mov{13,vrval(xl){8,wc{{link to this trblk{23579
{{mov{7,xl{8,wc{{copy pointer{23580
{{mov{13,trnxt(xl){7,xr{{store value in trblk{23581
{{mov{7,xr{3,r_ion{{restore possible vrblk pointer{23582
{{mov{8,wb{8,wa{{keep offset to name{23583
{{jsr{6,setvr{{{if vrblk, set vrget,vrsto{23584
{{mov{7,xr{3,r_iot{{get 0 or trtrf ptr{23585
{{bnz{7,xr{6,iop19{{jump if trtrf block exists{23586
{{exi{{{{return to caller{23587
*      non standard file
*      see if an fcblk has already been allocated.
{iop04{zer{8,wa{{{in case no fcblk found{23592
{{ejc{{{{{23593
*      ioput (continued)
*      search possible trblk chain to pick up the fcblk
{iop05{mov{8,wb{7,xr{{remember blk ptr{23599
{{mov{7,xr{13,vrval(xr){{chain along{23600
{{bne{9,(xr){22,=b_trt{6,iop06{jump if end of trblk chain{23601
{{bne{13,trtyp(xr){18,=trtfc{6,iop05{loop if more to go{23602
{{mov{3,r_iot{7,xr{{point to file arg1 trblk{23603
{{mov{8,wa{13,trfpt(xr){{get fcblk ptr from trblk{23604
*      wa = 0 or fcblk ptr
*      wb = ptr to preceding blk to which any trtrf block
*           for file arg1 must be chained.
{iop06{mov{3,r_iof{8,wa{{keep possible fcblk ptr{23610
{{mov{3,r_iop{8,wb{{keep preceding blk ptr{23611
{{jsr{6,ioppf{{{process filearg2{23612
{{jsr{6,sysfc{{{see if fcblk required{23613
{{ppm{6,iop16{{{fail{23614
{{ppm{6,iop26{{{fail{23615
{{bze{8,wa{6,iop12{{skip if no new fcblk wanted{23616
{{blt{8,wc{18,=num02{6,iop6a{jump if fcblk in dynamic{23617
{{jsr{6,alost{{{get it in static{23618
{{brn{6,iop6b{{{skip{23619
*      obtain fcblk in dynamic
{iop6a{jsr{6,alloc{{{get space for fcblk{23623
*      merge
{iop6b{mov{7,xl{7,xr{{point to fcblk{23627
{{mov{8,wb{8,wa{{copy its length{23628
{{btw{8,wb{{{get count as words (sgd apr80){23629
{{lct{8,wb{8,wb{{loop counter{23630
*      clear fcblk
{iop07{zer{10,(xr)+{{{clear a word{23634
{{bct{8,wb{6,iop07{{loop{23635
{{beq{8,wc{18,=num02{6,iop09{skip if in static - dont set fields{23636
{{mov{9,(xl){22,=b_xnt{{store xnblk code in case{23637
{{mov{13,num01(xl){8,wa{{store length{23638
{{bnz{8,wc{6,iop09{{jump if xnblk wanted{23639
{{mov{9,(xl){22,=b_xrt{{xrblk code requested{23640
{{ejc{{{{{23642
*      ioput (continued)
*      complete fcblk initialisation
{iop09{mov{7,xr{3,r_iot{{get possible trblk ptr{23647
{{mov{3,r_iof{7,xl{{store fcblk ptr{23648
{{bnz{7,xr{6,iop10{{jump if trblk already found{23649
*      a new trblk is needed
{{mov{8,wb{18,=trtfc{{trtyp for fcblk trap blk{23653
{{jsr{6,trbld{{{make the block{23654
{{mov{3,r_iot{7,xr{{copy trtrf ptr{23655
{{mov{7,xl{3,r_iop{{point to preceding blk{23656
{{mov{13,vrval(xr){13,vrval(xl){{copy value field to trblk{23657
{{mov{13,vrval(xl){7,xr{{link new trblk into chain{23658
{{mov{7,xr{7,xl{{point to predecessor blk{23659
{{jsr{6,setvr{{{set trace intercepts{23660
{{mov{7,xr{13,vrval(xr){{recover trblk ptr{23661
{{brn{6,iop1a{{{store fcblk ptr{23662
*      here if existing trblk
{iop10{zer{3,r_iop{{{do not release if sysio fails{23666
*      xr is ptr to trblk, xl is fcblk ptr or 0
{iop1a{mov{13,trfpt(xr){3,r_iof{{store fcblk ptr{23670
*      call sysio to complete file accessing
{iop11{mov{8,wa{3,r_iof{{copy fcblk ptr or 0{23674
{{mov{8,wb{3,ioptt{{get input/output flag{23675
{{mov{7,xr{3,r_io2{{get file arg2{23676
{{mov{7,xl{3,r_io1{{get file arg1{23677
{{jsr{6,sysio{{{associate to the file{23678
{{ppm{6,iop17{{{fail{23679
{{ppm{6,iop18{{{fail{23680
{{bnz{3,r_iot{6,iop01{{not std input if non-null trtrf blk{23681
{{bnz{3,ioptt{6,iop01{{jump if output{23682
{{bze{8,wc{6,iop01{{no change to standard read length{23683
{{mov{3,cswin{8,wc{{store new read length for std file{23684
{{brn{6,iop01{{{merge to finish the task{23685
*      sysfc may have returned a pointer to a private fcblk
{iop12{bnz{7,xl{6,iop09{{jump if private fcblk{23689
{{brn{6,iop11{{{finish the association{23690
*      failure returns
{iop13{exi{1,1{{{3rd arg not a string{23694
{iop14{exi{1,2{{{2nd arg unsuitable{23695
{iop15{ica{7,xs{{{discard trblk pointer{23696
{{exi{1,3{{{1st arg unsuitable{23697
{iop16{exi{1,4{{{file spec wrong{23698
{iop26{exi{1,7{{{fcblk in use{23699
*      i/o file does not exist
{iop17{mov{7,xr{3,r_iop{{is there a trblk to release{23703
{{bze{7,xr{6,iopa7{{if not{23704
{{mov{7,xl{13,vrval(xr){{point to trblk{23705
{{mov{13,vrval(xr){13,vrval(xl){{unsplice it{23706
{{jsr{6,setvr{{{adjust trace intercepts{23707
{iopa7{exi{1,5{{{i/o file does not exist{23708
*      i/o file cannot be read/written
{iop18{mov{7,xr{3,r_iop{{is there a trblk to release{23712
{{bze{7,xr{6,iopa7{{if not{23713
{{mov{7,xl{13,vrval(xr){{point to trblk{23714
{{mov{13,vrval(xr){13,vrval(xl){{unsplice it{23715
{{jsr{6,setvr{{{adjust trace intercepts{23716
{iopa8{exi{1,6{{{i/o file cannot be read/written{23717
{{ejc{{{{{23718
*      ioput (continued)
*      add to iochn chain of associated variables unless
*      already present.
{iop19{mov{8,wc{3,r_ion{{wc = name base, wb = name offset{23725
*      search loop
{iop20{mov{7,xr{13,trtrf(xr){{next link of chain{23729
{{bze{7,xr{6,iop21{{not found{23730
{{bne{8,wc{13,ionmb(xr){6,iop20{no match{23731
{{beq{8,wb{13,ionmo(xr){6,iop22{exit if matched{23732
{{brn{6,iop20{{{loop{23733
*      not found
{iop21{mov{8,wa{19,*num05{{space needed{23737
{{jsr{6,alloc{{{get it{23738
{{mov{9,(xr){22,=b_xrt{{store xrblk code{23739
{{mov{13,num01(xr){8,wa{{store length{23740
{{mov{13,ionmb(xr){8,wc{{store name base{23741
{{mov{13,ionmo(xr){8,wb{{store name offset{23742
{{mov{7,xl{3,r_iot{{point to trtrf blk{23743
{{mov{8,wa{13,trtrf(xl){{get ptr field contents{23744
{{mov{13,trtrf(xl){7,xr{{store ptr to new block{23745
{{mov{13,trtrf(xr){8,wa{{complete the linking{23746
*      insert fcblk on fcblk chain for sysej, sysxi
{iop22{bze{3,r_iof{6,iop25{{skip if no fcblk{23750
{{mov{7,xl{3,r_fcb{{ptr to head of existing chain{23751
*      see if fcblk already on chain
{iop23{bze{7,xl{6,iop24{{not on if end of chain{23755
{{beq{13,num03(xl){3,r_iof{6,iop25{dont duplicate if find it{23756
{{mov{7,xl{13,num02(xl){{get next link{23757
{{brn{6,iop23{{{loop{23758
*      not found so add an entry for this fcblk
{iop24{mov{8,wa{19,*num04{{space needed{23762
{{jsr{6,alloc{{{get it{23763
{{mov{9,(xr){22,=b_xrt{{store block code{23764
{{mov{13,num01(xr){8,wa{{store length{23765
{{mov{13,num02(xr){3,r_fcb{{store previous link in this node{23766
{{mov{13,num03(xr){3,r_iof{{store fcblk ptr{23767
{{mov{3,r_fcb{7,xr{{insert node into fcblk chain{23768
*      return
{iop25{exi{{{{return to caller{23772
{{enp{{{{end procedure ioput{23773
{{ejc{{{{{23774
*      ktrex -- execute keyword trace
*      ktrex is used to execute a possible keyword trace. it
*      includes the test on trace and tests for trace active.
*      (xl)                  ptr to trblk (or 0 if untraced)
*      jsr  ktrex            call to execute keyword trace
*      (xl,wa,wb,wc)         destroyed
*      (ra)                  destroyed
{ktrex{prc{25,r{1,0{{entry point (recursive){23786
{{bze{7,xl{6,ktrx3{{immediate exit if keyword untraced{23787
{{bze{3,kvtra{6,ktrx3{{immediate exit if trace = 0{23788
{{dcv{3,kvtra{{{else decrement trace{23789
{{mov{11,-(xs){7,xr{{save xr{23790
{{mov{7,xr{7,xl{{copy trblk pointer{23791
{{mov{7,xl{13,trkvr(xr){{load vrblk pointer (nmbas){23792
{{mov{8,wa{19,*vrval{{set name offset{23793
{{bze{13,trfnc(xr){6,ktrx1{{jump if print trace{23794
{{jsr{6,trxeq{{{else execute full trace{23795
{{brn{6,ktrx2{{{and jump to exit{23796
*      here for print trace
{ktrx1{mov{11,-(xs){7,xl{{stack vrblk ptr for kwnam{23800
{{mov{11,-(xs){8,wa{{stack offset for kwnam{23801
{{jsr{6,prtsn{{{print statement number{23802
{{mov{8,wa{18,=ch_am{{load ampersand{23803
{{jsr{6,prtch{{{print ampersand{23804
{{jsr{6,prtnm{{{print keyword name{23805
{{mov{7,xr{21,=tmbeb{{point to blank-equal-blank{23806
{{jsr{6,prtst{{{print blank-equal-blank{23807
{{jsr{6,kwnam{{{get keyword pseudo-variable name{23808
{{mov{3,dnamp{7,xr{{reset ptr to delete kvblk{23809
{{jsr{6,acess{{{get keyword value{23810
{{ppm{{{{failure is impossible{23811
{{jsr{6,prtvl{{{print keyword value{23812
{{jsr{6,prtnl{{{terminate print line{23813
*      here to exit after completing trace
{ktrx2{mov{7,xr{10,(xs)+{{restore entry xr{23817
*      merge here to exit if no trace required
{ktrx3{exi{{{{return to ktrex caller{23821
{{enp{{{{end procedure ktrex{23822
{{ejc{{{{{23823
*      kwnam -- get pseudo-variable name for keyword
*      1(xs)                 name base for vrblk
*      0(xs)                 offset (should be *vrval)
*      jsr  kwnam            call to get pseudo-variable name
*      (xs)                  popped twice
*      (xl,wa)               resulting pseudo-variable name
*      (xr,wa,wb)            destroyed
{kwnam{prc{25,n{1,0{{entry point{23834
{{ica{7,xs{{{ignore name offset{23835
{{mov{7,xr{10,(xs)+{{load name base{23836
{{bge{7,xr{3,state{6,kwnm1{jump if not natural variable name{23837
{{bnz{13,vrlen(xr){6,kwnm1{{error if not system variable{23838
{{mov{7,xr{13,vrsvp(xr){{else point to svblk{23839
{{mov{8,wa{13,svbit(xr){{load bit mask{23840
{{anb{8,wa{4,btknm{{and with keyword bit{23841
{{zrb{8,wa{6,kwnm1{{error if no keyword association{23842
{{mov{8,wa{13,svlen(xr){{else load name length in characters{23843
{{ctb{8,wa{2,svchs{{compute offset to field we want{23844
{{add{7,xr{8,wa{{point to svknm field{23845
{{mov{8,wb{9,(xr){{load svknm value{23846
{{mov{8,wa{19,*kvsi_{{set size of kvblk{23847
{{jsr{6,alloc{{{allocate kvblk{23848
{{mov{9,(xr){22,=b_kvt{{store type word{23849
{{mov{13,kvnum(xr){8,wb{{store keyword number{23850
{{mov{13,kvvar(xr){21,=trbkv{{set dummy trblk pointer{23851
{{mov{7,xl{7,xr{{copy kvblk pointer{23852
{{mov{8,wa{19,*kvvar{{set proper offset{23853
{{exi{{{{return to kvnam caller{23854
*      here if not keyword name
{kwnm1{erb{1,251{26,keyword operand is not name of defined keyword{{{23858
{{enp{{{{end procedure kwnam{23859
{{ejc{{{{{23860
*      lcomp-- compare two strings lexically
*      1(xs)                 first argument
*      0(xs)                 second argument
*      jsr  lcomp            call to compare aruments
*      ppm  loc              transfer loc for arg1 not string
*      ppm  loc              transfer loc for arg2 not string
*      ppm  loc              transfer loc if arg1 llt arg2
*      ppm  loc              transfer loc if arg1 leq arg2
*      ppm  loc              transfer loc if arg1 lgt arg2
*      (the normal return is never taken)
*      (xs)                  popped twice
*      (xr,xl)               destroyed
*      (wa,wb,wc,ra)         destroyed
{lcomp{prc{25,n{1,5{{entry point{23877
{{jsr{6,gtstg{{{convert second arg to string{23879
{{ppm{6,lcmp6{{{jump if second arg not string{23883
{{mov{7,xl{7,xr{{else save pointer{23884
{{mov{8,wc{8,wa{{and length{23885
{{jsr{6,gtstg{{{convert first argument to string{23887
{{ppm{6,lcmp5{{{jump if not string{23891
{{mov{8,wb{8,wa{{save arg 1 length{23892
{{plc{7,xr{{{point to chars of arg 1{23893
{{plc{7,xl{{{point to chars of arg 2{23894
{{blo{8,wa{8,wc{6,lcmp1{jump if arg 1 length is smaller{23906
{{mov{8,wa{8,wc{{else set arg 2 length as smaller{23907
*      here with smaller length in (wa)
{lcmp1{bze{8,wa{6,lcmp7{{if null string, compare lengths{23911
{{cmc{6,lcmp4{6,lcmp3{{compare strings, jump if unequal{23912
{lcmp7{bne{8,wb{8,wc{6,lcmp2{if equal, jump if lengths unequal{23913
{{exi{1,4{{{else identical strings, leq exit{23914
{{ejc{{{{{23915
*      lcomp (continued)
*      here if initial strings identical, but lengths unequal
{lcmp2{bhi{8,wb{8,wc{6,lcmp4{jump if arg 1 length gt arg 2 leng{23921
*      here if first arg llt second arg
{lcmp3{exi{1,3{{{take llt exit{23926
*      here if first arg lgt second arg
{lcmp4{exi{1,5{{{take lgt exit{23930
*      here if first arg is not a string
{lcmp5{exi{1,1{{{take bad first arg exit{23934
*      here for second arg not a string
{lcmp6{exi{1,2{{{take bad second arg error exit{23938
{{enp{{{{end procedure lcomp{23939
{{ejc{{{{{23940
*      listr -- list source line
*      listr is used to list a source line during the initial
*      compilation. it is called from scane and scanl.
*      jsr  listr            call to list line
*      (xr,xl,wa,wb,wc)      destroyed
*      global locations used by listr
*      cnttl                 flag for -title, -stitl
*      erlst                 if listing on account of an error
*      lstid                 include depth of current image
*      lstlc                 count lines on current page
*      lstnp                 max number of lines/page
*      lstpf                 set non-zero if the current source
*                            line has been listed, else zero.
*      lstpg                 compiler listing page number
*      lstsn                 set if stmnt num to be listed
*      r_cim                 pointer to current input line.
*      r_ttl                 title for source listing
*      r_stl                 ptr to sub-title string
*      entry point
{listr{prc{25,e{1,0{{entry point{23979
{{bnz{3,cnttl{6,list5{{jump if -title or -stitl{23980
{{bnz{3,lstpf{6,list4{{immediate exit if already listed{23981
{{bge{3,lstlc{3,lstnp{6,list6{jump if no room{23982
*      here after printing title (if needed)
{list0{mov{7,xr{3,r_cim{{load pointer to current image{23986
{{bze{7,xr{6,list4{{jump if no image to print{23987
{{plc{7,xr{{{point to characters{23988
{{lch{8,wa{9,(xr){{load first character{23989
{{mov{7,xr{3,lstsn{{load statement number{23990
{{bze{7,xr{6,list2{{jump if no statement number{23991
{{mti{7,xr{{{else get stmnt number as integer{23992
{{bne{3,stage{18,=stgic{6,list1{skip if execute time{23993
{{beq{8,wa{18,=ch_as{6,list2{no stmnt number list if comment{23994
{{beq{8,wa{18,=ch_mn{6,list2{no stmnt no. if control card{23995
*      print statement number
{list1{jsr{6,prtin{{{else print statement number{23999
{{zer{3,lstsn{{{and clear for next time in{24000
*      here to test for printing include depth
{list2{mov{7,xr{3,lstid{{include depth of image{24005
{{bze{7,xr{6,list8{{if not from an include file{24006
{{mov{8,wa{18,=stnpd{{position for start of statement{24007
{{sub{8,wa{18,=num03{{position to place include depth{24008
{{mov{3,profs{8,wa{{set as starting position{24009
{{mti{7,xr{{{include depth as integer{24010
{{jsr{6,prtin{{{print include depth{24011
{{ejc{{{{{24012
*      listr (continued)
*      here after printing statement number and include depth
{list8{mov{3,profs{18,=stnpd{{point past statement number{24018
{{mov{7,xr{3,r_cim{{load pointer to current image{24028
{{jsr{6,prtst{{{print it{24029
{{icv{3,lstlc{{{bump line counter{24030
{{bnz{3,erlst{6,list3{{jump if error copy to int.ch.{24031
{{jsr{6,prtnl{{{terminate line{24032
{{bze{3,cswdb{6,list3{{jump if -single mode{24033
{{jsr{6,prtnl{{{else add a blank line{24034
{{icv{3,lstlc{{{and bump line counter{24035
*      here after printing source image
{list3{mnz{3,lstpf{{{set flag for line printed{24039
*      merge here to exit
{list4{exi{{{{return to listr caller{24043
*      print title after -title or -stitl card
{list5{zer{3,cnttl{{{clear flag{24047
*      eject to new page and list title
{list6{jsr{6,prtps{{{eject{24051
{{bze{3,prich{6,list7{{skip if listing to regular printer{24052
{{beq{3,r_ttl{21,=nulls{6,list0{terminal listing omits null title{24053
*      list title
{list7{jsr{6,listt{{{list title{24057
{{brn{6,list0{{{merge{24058
{{enp{{{{end procedure listr{24059
{{ejc{{{{{24060
*      listt -- list title and subtitle
*      used during compilation to print page heading
*      jsr  listt            call to list title
*      (xr,wa)               destroyed
{listt{prc{25,e{1,0{{entry point{24069
{{mov{7,xr{3,r_ttl{{point to source listing title{24070
{{jsr{6,prtst{{{print title{24071
{{mov{3,profs{3,lstpo{{set offset{24072
{{mov{7,xr{21,=lstms{{set page message{24073
{{jsr{6,prtst{{{print page message{24074
{{icv{3,lstpg{{{bump page number{24075
{{mti{3,lstpg{{{load page number as integer{24076
{{jsr{6,prtin{{{print page number{24077
{{jsr{6,prtnl{{{terminate title line{24078
{{add{3,lstlc{18,=num02{{count title line and blank line{24079
*      print sub-title (if any)
{{mov{7,xr{3,r_stl{{load pointer to sub-title{24083
{{bze{7,xr{6,lstt1{{jump if no sub-title{24084
{{jsr{6,prtst{{{else print sub-title{24085
{{jsr{6,prtnl{{{terminate line{24086
{{icv{3,lstlc{{{bump line count{24087
*      return point
{lstt1{jsr{6,prtnl{{{print a blank line{24091
{{exi{{{{return to caller{24092
{{enp{{{{end procedure listt{24093
{{ejc{{{{{24094
*      newfn -- record new source file name
*      newfn is used after switching to a new include file, or
*      after a -line statement which contains a file name.
*      (xr)                  file name scblk
*      jsr  newfn
*      (wa,wb,wc,xl,xr,ra)   destroyed
*      on return, the table that maps statement numbers to file
*      names has been updated to include this new file name and
*      the current statement number.  the entry is made only if
*      the file name had changed from its previous value.
{newfn{prc{25,e{1,0{{entry point{24111
{{mov{11,-(xs){7,xr{{save new name{24112
{{mov{7,xl{3,r_sfc{{load previous name{24113
{{jsr{6,ident{{{check for equality{24114
{{ppm{6,nwfn1{{{jump if identical{24115
{{mov{7,xr{10,(xs)+{{different, restore name{24116
{{mov{3,r_sfc{7,xr{{record current file name{24117
{{mov{8,wb{3,cmpsn{{get current statement{24118
{{mti{8,wb{{{convert to integer{24119
{{jsr{6,icbld{{{build icblk for stmt number{24120
{{mov{7,xl{3,r_sfn{{file name table{24121
{{mnz{8,wb{{{lookup statement number by name{24122
{{jsr{6,tfind{{{allocate new teblk{24123
{{ppm{{{{always possible to allocate block{24124
{{mov{13,teval(xl){3,r_sfc{{record file name as entry value{24125
{{exi{{{{{24126
*     here if new name and old name identical
{nwfn1{ica{7,xs{{{pop stack{24130
{{exi{{{{{24131
{{ejc{{{{{24132
*      nexts -- acquire next source image
*      nexts is used to acquire the next source image at compile
*      time. it assumes that a prior call to readr has input
*      a line image (see procedure readr). before the current
*      image is finally lost it may be listed here.
*      jsr  nexts            call to acquire next input line
*      (xr,xl,wa,wb,wc)      destroyed
*      global values affected
*      lstid                 include depth of next image
*      r_cni                 on input, next image. on
*                            exit reset to zero
*      r_cim                 on exit, set to point to image
*      rdcln                 current ln set from next line num
*      scnil                 input image length on exit
*      scnse                 reset to zero on exit
*      lstpf                 set on exit if line is listed
{nexts{prc{25,e{1,0{{entry point{24164
{{bze{3,cswls{6,nxts2{{jump if -nolist{24165
{{mov{7,xr{3,r_cim{{point to image{24166
{{bze{7,xr{6,nxts2{{jump if no image{24167
{{plc{7,xr{{{get char ptr{24168
{{lch{8,wa{9,(xr){{get first char{24169
{{bne{8,wa{18,=ch_mn{6,nxts1{jump if not ctrl card{24170
{{bze{3,cswpr{6,nxts2{{jump if -noprint{24171
*      here to call lister
{nxts1{jsr{6,listr{{{list line{24175
*      here after possible listing
{nxts2{mov{7,xr{3,r_cni{{point to next image{24179
{{mov{3,r_cim{7,xr{{set as next image{24180
{{mov{3,rdcln{3,rdnln{{set as current line number{24181
{{mov{3,lstid{3,cnind{{set as current include depth{24183
{{zer{3,r_cni{{{clear next image pointer{24185
{{mov{8,wa{13,sclen(xr){{get input image length{24186
{{mov{8,wb{3,cswin{{get max allowable length{24187
{{blo{8,wa{8,wb{6,nxts3{skip if not too long{24188
{{mov{8,wa{8,wb{{else truncate{24189
*      here with length in (wa)
{nxts3{mov{3,scnil{8,wa{{use as record length{24193
{{zer{3,scnse{{{reset scnse{24194
{{zer{3,lstpf{{{set line not listed yet{24195
{{exi{{{{return to nexts caller{24196
{{enp{{{{end procedure nexts{24197
{{ejc{{{{{24198
*      patin -- pattern construction for len,pos,rpos,tab,rtab
*      these pattern types all generate a similar node type. so
*      the construction code is shared. see functions section
*      for actual entry points for these five functions.
*      (wa)                  pcode for expression arg case
*      (wb)                  pcode for integer arg case
*      jsr  patin            call to build pattern node
*      ppm  loc              transfer loc for not integer or exp
*      ppm  loc              transfer loc for int out of range
*      (xr)                  pointer to constructed node
*      (xl,wa,wb,wc,ia)      destroyed
{patin{prc{25,n{1,2{{entry point{24214
{{mov{7,xl{8,wa{{preserve expression arg pcode{24215
{{jsr{6,gtsmi{{{try to convert arg as small integer{24216
{{ppm{6,ptin2{{{jump if not integer{24217
{{ppm{6,ptin3{{{jump if out of range{24218
*      common successful exit point
{ptin1{jsr{6,pbild{{{build pattern node{24222
{{exi{{{{return to caller{24223
*      here if argument is not an integer
{ptin2{mov{8,wb{7,xl{{copy expr arg case pcode{24227
{{blo{9,(xr){22,=b_e__{6,ptin1{all ok if expression arg{24228
{{exi{1,1{{{else take error exit for wrong type{24229
*      here for error of out of range integer argument
{ptin3{exi{1,2{{{take out-of-range error exit{24233
{{enp{{{{end procedure patin{24234
{{ejc{{{{{24235
*      patst -- pattern construction for any,notany,
*               break,span and breakx pattern functions.
*      these pattern functions build similar types of nodes and
*      the construction code is shared. see functions section
*      for actual entry points for these five pattern functions.
*      0(xs)                 string argument
*      (wb)                  pcode for one char argument
*      (xl)                  pcode for multi-char argument
*      (wc)                  pcode for expression argument
*      jsr  patst            call to build node
*      ppm  loc              if not string or expr (or null)
*      (xs)                  popped past string argument
*      (xr)                  pointer to constructed node
*      (xl)                  destroyed
*      (wa,wb,wc,ra)         destroyed
*      note that there is a special call to patst in the evals
*      procedure with a slightly different form. see evals
*      for details of the form of this call.
{patst{prc{25,n{1,1{{entry point{24259
{{jsr{6,gtstg{{{convert argument as string{24260
{{ppm{6,pats7{{{jump if not string{24261
{{bze{8,wa{6,pats7{{jump if null string (catspaw){24262
{{bne{8,wa{18,=num01{6,pats2{jump if not one char string{24263
*      here for one char string case
{{bze{8,wb{6,pats2{{treat as multi-char if evals call{24267
{{plc{7,xr{{{point to character{24268
{{lch{7,xr{9,(xr){{load character{24269
*      common exit point after successful construction
{pats1{jsr{6,pbild{{{call routine to build node{24273
{{exi{{{{return to patst caller{24274
{{ejc{{{{{24275
*      patst (continued)
*      here for multi-character string case
{pats2{mov{11,-(xs){7,xl{{save multi-char pcode{24281
{{mov{8,wc{3,ctmsk{{load current mask bit{24282
{{beq{7,xr{3,r_cts{6,pats6{jump if same as last string c3.738{24283
{{mov{11,-(xs){7,xr{{save string pointer{24284
{{lsh{8,wc{1,1{{shift to next position{24285
{{nzb{8,wc{6,pats4{{skip if position left in this tbl{24286
*      here we must allocate a new character table
{{mov{8,wa{19,*ctsi_{{set size of ctblk{24290
{{jsr{6,alloc{{{allocate ctblk{24291
{{mov{3,r_ctp{7,xr{{store ptr to new ctblk{24292
{{mov{10,(xr)+{22,=b_ctt{{store type code, bump ptr{24293
{{lct{8,wb{18,=cfp_a{{set number of words to clear{24294
{{mov{8,wc{4,bits0{{load all zero bits{24295
*      loop to clear all bits in table to zeros
{pats3{mov{10,(xr)+{8,wc{{move word of zero bits{24299
{{bct{8,wb{6,pats3{{loop till all cleared{24300
{{mov{8,wc{4,bits1{{set initial bit position{24301
*      merge here with bit position available
{pats4{mov{3,ctmsk{8,wc{{save parm2 (new bit position){24305
{{mov{7,xl{10,(xs)+{{restore pointer to argument string{24306
{{mov{3,r_cts{7,xl{{save for next time   c3.738{24307
{{mov{8,wb{13,sclen(xl){{load string length{24308
{{bze{8,wb{6,pats6{{jump if null string case{24309
{{lct{8,wb{8,wb{{else set loop counter{24310
{{plc{7,xl{{{point to characters in argument{24311
{{ejc{{{{{24312
*      patst (continued)
*      loop to set bits in column of table
{pats5{lch{8,wa{10,(xl)+{{load next character{24318
{{wtb{8,wa{{{convert to byte offset{24319
{{mov{7,xr{3,r_ctp{{point to ctblk{24320
{{add{7,xr{8,wa{{point to ctblk entry{24321
{{mov{8,wa{8,wc{{copy bit mask{24322
{{orb{8,wa{13,ctchs(xr){{or in bits already set{24323
{{mov{13,ctchs(xr){8,wa{{store resulting bit string{24324
{{bct{8,wb{6,pats5{{loop till all bits set{24325
*      complete processing for multi-char string case
{pats6{mov{7,xr{3,r_ctp{{load ctblk ptr as parm1 for pbild{24329
{{zer{7,xl{{{clear garbage ptr in xl{24330
{{mov{8,wb{10,(xs)+{{load pcode for multi-char str case{24331
{{brn{6,pats1{{{back to exit (wc=bitstring=parm2){24332
*      here if argument is not a string
*      note that the call from evals cannot pass an expression
*      since evalp always reevaluates expressions.
{pats7{mov{8,wb{8,wc{{set pcode for expression argument{24339
{{blo{9,(xr){22,=b_e__{6,pats1{jump to exit if expression arg{24340
{{exi{1,1{{{else take wrong type error exit{24341
{{enp{{{{end procedure patst{24342
{{ejc{{{{{24343
*      pbild -- build pattern node
*      (xr)                  parm1 (only if required)
*      (wb)                  pcode for node
*      (wc)                  parm2 (only if required)
*      jsr  pbild            call to build node
*      (xr)                  pointer to constructed node
*      (wa)                  destroyed
{pbild{prc{25,e{1,0{{entry point{24354
{{mov{11,-(xs){7,xr{{stack possible parm1{24355
{{mov{7,xr{8,wb{{copy pcode{24356
{{lei{7,xr{{{load entry point id (bl_px){24357
{{beq{7,xr{18,=bl_p1{6,pbld1{jump if one parameter{24358
{{beq{7,xr{18,=bl_p0{6,pbld3{jump if no parameters{24359
*      here for two parameter case
{{mov{8,wa{19,*pcsi_{{set size of p2blk{24363
{{jsr{6,alloc{{{allocate block{24364
{{mov{13,parm2(xr){8,wc{{store second parameter{24365
{{brn{6,pbld2{{{merge with one parm case{24366
*      here for one parameter case
{pbld1{mov{8,wa{19,*pbsi_{{set size of p1blk{24370
{{jsr{6,alloc{{{allocate node{24371
*      merge here from two parm case
{pbld2{mov{13,parm1(xr){9,(xs){{store first parameter{24375
{{brn{6,pbld4{{{merge with no parameter case{24376
*      here for case of no parameters
{pbld3{mov{8,wa{19,*pasi_{{set size of p0blk{24380
{{jsr{6,alloc{{{allocate node{24381
*      merge here from other cases
{pbld4{mov{9,(xr){8,wb{{store pcode{24385
{{ica{7,xs{{{pop first parameter{24386
{{mov{13,pthen(xr){21,=ndnth{{set nothen successor pointer{24387
{{exi{{{{return to pbild caller{24388
{{enp{{{{end procedure pbild{24389
{{ejc{{{{{24390
*      pconc -- concatenate two patterns
*      (xl)                  ptr to right pattern
*      (xr)                  ptr to left pattern
*      jsr  pconc            call to concatenate patterns
*      (xr)                  ptr to concatenated pattern
*      (xl,wa,wb,wc)         destroyed
*      to concatenate two patterns, all successors in the left
*      pattern which point to the nothen node must be changed to
*      point to the right pattern. however, this modification
*      must be performed on a copy of the left argument rather
*      than the left argument itself, since the left argument
*      may be pointed to by some other variable value.
*      accordingly, it is necessary to copy the left argument.
*      this is not a trivial process since we must avoid copying
*      nodes more than once and the pattern is a graph structure
*      the following algorithm is employed.
*      the stack is used to store a list of nodes which
*      have already been copied. the format of the entries on
*      this list consists of a two word block. the first word
*      is the old address and the second word is the address
*      of the copy. this list is searched by the pcopy
*      routine to avoid making duplicate copies. a trick is
*      used to accomplish the concatenation at the same time.
*      a special entry is made to start with on the stack. this
*      entry records that the nothen node has been copied
*      already and the address of its copy is the right pattern.
*      this automatically performs the correct replacements.
{pconc{prc{25,e{1,0{{entry point{24425
{{zer{11,-(xs){{{make room for one entry at bottom{24426
{{mov{8,wc{7,xs{{store pointer to start of list{24427
{{mov{11,-(xs){21,=ndnth{{stack nothen node as old node{24428
{{mov{11,-(xs){7,xl{{store right arg as copy of nothen{24429
{{mov{7,xt{7,xs{{initialize pointer to stack entries{24430
{{jsr{6,pcopy{{{copy first node of left arg{24431
{{mov{13,num02(xt){8,wa{{store as result under list{24432
{{ejc{{{{{24433
*      pconc (continued)
*      the following loop scans entries in the list and makes
*      sure that their successors have been copied.
{pcnc1{beq{7,xt{7,xs{6,pcnc2{jump if all entries processed{24440
{{mov{7,xr{11,-(xt){{else load next old address{24441
{{mov{7,xr{13,pthen(xr){{load pointer to successor{24442
{{jsr{6,pcopy{{{copy successor node{24443
{{mov{7,xr{11,-(xt){{load pointer to new node (copy){24444
{{mov{13,pthen(xr){8,wa{{store ptr to new successor{24445
*      now check for special case of alternation node where
*      parm1 points to a node and must be copied like pthen.
{{bne{9,(xr){22,=p_alt{6,pcnc1{loop back if not{24450
{{mov{7,xr{13,parm1(xr){{else load pointer to alternative{24451
{{jsr{6,pcopy{{{copy it{24452
{{mov{7,xr{9,(xt){{restore ptr to new node{24453
{{mov{13,parm1(xr){8,wa{{store ptr to copied alternative{24454
{{brn{6,pcnc1{{{loop back for next entry{24455
*      here at end of copy process
{pcnc2{mov{7,xs{8,wc{{restore stack pointer{24459
{{mov{7,xr{10,(xs)+{{load pointer to copy{24460
{{exi{{{{return to pconc caller{24461
{{enp{{{{end procedure pconc{24462
{{ejc{{{{{24463
*      pcopy -- copy a pattern node
*      pcopy is called from the pconc procedure to copy a single
*      pattern node. the copy is only carried out if the node
*      has not been copied already.
*      (xr)                  pointer to node to be copied
*      (xt)                  ptr to current loc in copy list
*      (wc)                  pointer to list of copied nodes
*      jsr  pcopy            call to copy a node
*      (wa)                  pointer to copy
*      (wb,xr)               destroyed
{pcopy{prc{25,n{1,0{{entry point{24478
{{mov{8,wb{7,xt{{save xt{24479
{{mov{7,xt{8,wc{{point to start of list{24480
*      loop to search list of nodes copied already
{pcop1{dca{7,xt{{{point to next entry on list{24484
{{beq{7,xr{9,(xt){6,pcop2{jump if match{24485
{{dca{7,xt{{{else skip over copied address{24486
{{bne{7,xt{7,xs{6,pcop1{loop back if more to test{24487
*      here if not in list, perform copy
{{mov{8,wa{9,(xr){{load first word of block{24491
{{jsr{6,blkln{{{get length of block{24492
{{mov{7,xl{7,xr{{save pointer to old node{24493
{{jsr{6,alloc{{{allocate space for copy{24494
{{mov{11,-(xs){7,xl{{store old address on list{24495
{{mov{11,-(xs){7,xr{{store new address on list{24496
{{chk{{{{check for stack overflow{24497
{{mvw{{{{move words from old block to copy{24498
{{mov{8,wa{9,(xs){{load pointer to copy{24499
{{brn{6,pcop3{{{jump to exit{24500
*      here if we find entry in list
{pcop2{mov{8,wa{11,-(xt){{load address of copy from list{24504
*      common exit point
{pcop3{mov{7,xt{8,wb{{restore xt{24508
{{exi{{{{return to pcopy caller{24509
{{enp{{{{end procedure pcopy{24510
{{ejc{{{{{24511
*      prflr -- print profile
*      prflr is called to print the contents of the profile
*      table in a fairly readable tabular format.
*      jsr  prflr            call to print profile
*      (wa,ia)               destroyed
{prflr{prc{25,e{1,0{{{24522
{{bze{3,pfdmp{6,prfl4{{no printing if no profiling done{24523
{{mov{11,-(xs){7,xr{{preserve entry xr{24524
{{mov{3,pfsvw{8,wb{{and also wb{24525
{{jsr{6,prtpg{{{eject{24526
{{mov{7,xr{21,=pfms1{{load msg /program profile/{24527
{{jsr{6,prtst{{{and print it{24528
{{jsr{6,prtnl{{{followed by newline{24529
{{jsr{6,prtnl{{{and another{24530
{{mov{7,xr{21,=pfms2{{point to first hdr{24531
{{jsr{6,prtst{{{print it{24532
{{jsr{6,prtnl{{{new line{24533
{{mov{7,xr{21,=pfms3{{second hdr{24534
{{jsr{6,prtst{{{print it{24535
{{jsr{6,prtnl{{{new line{24536
{{jsr{6,prtnl{{{and another blank line{24537
{{zer{8,wb{{{initial stmt count{24538
{{mov{7,xr{3,pftbl{{point to table origin{24539
{{add{7,xr{19,*xndta{{bias past xnblk header (sgd07){24540
*      loop here to print successive entries
{prfl1{icv{8,wb{{{bump stmt nr{24544
{{ldi{9,(xr){{{load nr of executions{24545
{{ieq{6,prfl3{{{no printing if zero{24546
{{mov{3,profs{18,=pfpd1{{point where to print{24547
{{jsr{6,prtin{{{and print it{24548
{{zer{3,profs{{{back to start of line{24549
{{mti{8,wb{{{load stmt nr{24550
{{jsr{6,prtin{{{print it there{24551
{{mov{3,profs{18,=pfpd2{{and pad past count{24552
{{ldi{13,cfp_i(xr){{{load total exec time{24553
{{jsr{6,prtin{{{print that too{24554
{{ldi{13,cfp_i(xr){{{reload time{24555
{{mli{4,intth{{{convert to microsec{24556
{{iov{6,prfl2{{{omit next bit if overflow{24557
{{dvi{9,(xr){{{divide by executions{24558
{{mov{3,profs{18,=pfpd3{{pad last print{24559
{{jsr{6,prtin{{{and print mcsec/execn{24560
*      merge after printing time
{prfl2{jsr{6,prtnl{{{thats another line{24564
*      here to go to next entry
{prfl3{add{7,xr{19,*pf_i2{{bump index ptr (sgd07){24568
{{blt{8,wb{3,pfnte{6,prfl1{loop if more stmts{24569
{{mov{7,xr{10,(xs)+{{restore callers xr{24570
{{mov{8,wb{3,pfsvw{{and wb too{24571
*      here to exit
{prfl4{exi{{{{return{24575
{{enp{{{{end of prflr{24576
{{ejc{{{{{24577
*      prflu -- update an entry in the profile table
*      on entry, kvstn contains nr of stmt to profile
*      jsr  prflu            call to update entry
*      (ia)                  destroyed
{prflu{prc{25,e{1,0{{{24586
{{bnz{3,pffnc{6,pflu4{{skip if just entered function{24587
{{mov{11,-(xs){7,xr{{preserve entry xr{24588
{{mov{3,pfsvw{8,wa{{save wa (sgd07){24589
{{bnz{3,pftbl{6,pflu2{{branch if table allocated{24590
*      here if space for profile table not yet allocated.
*      calculate size needed, allocate a static xnblk, and
*      initialize it all to zero.
*      the time taken for this will be attributed to the current
*      statement (assignment to keywd profile), but since the
*      timing for this statement is up the pole anyway, this
*      doesnt really matter...
{{sub{3,pfnte{18,=num01{{adjust for extra count (sgd07){24600
{{mti{4,pfi2a{{{convrt entry size to int{24601
{{sti{3,pfste{{{and store safely for later{24602
{{mti{3,pfnte{{{load table length as integer{24603
{{mli{3,pfste{{{multiply by entry size{24604
{{mfi{8,wa{{{get back address-style{24605
{{add{8,wa{18,=num02{{add on 2 word overhead{24606
{{wtb{8,wa{{{convert the whole lot to bytes{24607
{{jsr{6,alost{{{gimme the space{24608
{{mov{3,pftbl{7,xr{{save block pointer{24609
{{mov{10,(xr)+{22,=b_xnt{{put block type and ...{24610
{{mov{10,(xr)+{8,wa{{... length into header{24611
{{mfi{8,wa{{{get back nr of wds in data area{24612
{{lct{8,wa{8,wa{{load the counter{24613
*      loop here to zero the block data
{pflu1{zer{10,(xr)+{{{blank a word{24617
{{bct{8,wa{6,pflu1{{and alllllll the rest{24618
*      end of allocation. merge back into routine
{pflu2{mti{3,kvstn{{{load nr of stmt just ended{24622
{{sbi{4,intv1{{{make into index offset{24623
{{mli{3,pfste{{{make offset of table entry{24624
{{mfi{8,wa{{{convert to address{24625
{{wtb{8,wa{{{get as baus{24626
{{add{8,wa{19,*num02{{offset includes table header{24627
{{mov{7,xr{3,pftbl{{get table start{24628
{{bge{8,wa{13,num01(xr){6,pflu3{if out of table, skip it{24629
{{add{7,xr{8,wa{{else point to entry{24630
{{ldi{9,(xr){{{get nr of executions so far{24631
{{adi{4,intv1{{{nudge up one{24632
{{sti{9,(xr){{{and put back{24633
{{jsr{6,systm{{{get time now{24634
{{sti{3,pfetm{{{stash ending time{24635
{{sbi{3,pfstm{{{subtract start time{24636
{{adi{13,cfp_i(xr){{{add cumulative time so far{24637
{{sti{13,cfp_i(xr){{{and put back new total{24638
{{ldi{3,pfetm{{{load end time of this stmt ...{24639
{{sti{3,pfstm{{{... which is start time of next{24640
*      merge here to exit
{pflu3{mov{7,xr{10,(xs)+{{restore callers xr{24644
{{mov{8,wa{3,pfsvw{{restore saved reg{24645
{{exi{{{{and return{24646
*      here if profile is suppressed because a program defined
*      function is about to be entered, and so the current stmt
*      has not yet finished
{pflu4{zer{3,pffnc{{{reset the condition flag{24652
{{exi{{{{and immediate return{24653
{{enp{{{{end of procedure prflu{24654
{{ejc{{{{{24655
*      prpar - process print parameters
*      (wc)                  if nonzero associate terminal only
*      jsr  prpar            call to process print parameters
*      (xl,xr,wa,wb,wc)      destroyed
*      since memory allocation is undecided on initial call,
*      terminal cannot be associated. the entry with wc non-zero
*      is provided so a later call can be made to complete this.
{prpar{prc{25,e{1,0{{entry point{24668
{{bnz{8,wc{6,prpa8{{jump to associate terminal{24669
{{jsr{6,syspp{{{get print parameters{24670
{{bnz{8,wb{6,prpa1{{jump if lines/page specified{24671
{{mov{8,wb{3,mxint{{else use a large value{24672
{{rsh{8,wb{1,1{{but not too large{24673
*      store line count/page
{prpa1{mov{3,lstnp{8,wb{{store number of lines/page{24677
{{mov{3,lstlc{8,wb{{pretend page is full initially{24678
{{zer{3,lstpg{{{clear page number{24679
{{mov{8,wb{3,prlen{{get prior length if any{24680
{{bze{8,wb{6,prpa2{{skip if no length{24681
{{bgt{8,wa{8,wb{6,prpa3{skip storing if too big{24682
*      store print buffer length
{prpa2{mov{3,prlen{8,wa{{store value{24686
*      process bits options
{prpa3{mov{8,wb{4,bits3{{bit 3 mask{24690
{{anb{8,wb{8,wc{{get -nolist bit{24691
{{zrb{8,wb{6,prpa4{{skip if clear{24692
{{zer{3,cswls{{{set -nolist{24693
*      check if fail reports goto interactive channel
{prpa4{mov{8,wb{4,bits1{{bit 1 mask{24697
{{anb{8,wb{8,wc{{get bit{24698
{{mov{3,erich{8,wb{{store int. chan. error flag{24699
{{mov{8,wb{4,bits2{{bit 2 mask{24700
{{anb{8,wb{8,wc{{get bit{24701
{{mov{3,prich{8,wb{{flag for std printer on int. chan.{24702
{{mov{8,wb{4,bits4{{bit 4 mask{24703
{{anb{8,wb{8,wc{{get bit{24704
{{mov{3,cpsts{8,wb{{flag for compile stats suppressn.{24705
{{mov{8,wb{4,bits5{{bit 5 mask{24706
{{anb{8,wb{8,wc{{get bit{24707
{{mov{3,exsts{8,wb{{flag for exec stats suppression{24708
{{ejc{{{{{24709
*      prpar (continued)
{{mov{8,wb{4,bits6{{bit 6 mask{24713
{{anb{8,wb{8,wc{{get bit{24714
{{mov{3,precl{8,wb{{extended/compact listing flag{24715
{{sub{8,wa{18,=num08{{point 8 chars from line end{24716
{{zrb{8,wb{6,prpa5{{jump if not extended{24717
{{mov{3,lstpo{8,wa{{store for listing page headings{24718
*       continue option processing
{prpa5{mov{8,wb{4,bits7{{bit 7 mask{24722
{{anb{8,wb{8,wc{{get bit 7{24723
{{mov{3,cswex{8,wb{{set -noexecute if non-zero{24724
{{mov{8,wb{4,bit10{{bit 10 mask{24725
{{anb{8,wb{8,wc{{get bit 10{24726
{{mov{3,headp{8,wb{{pretend printed to omit headers{24727
{{mov{8,wb{4,bits9{{bit 9 mask{24728
{{anb{8,wb{8,wc{{get bit 9{24729
{{mov{3,prsto{8,wb{{keep it as std listing option{24730
{{mov{8,wb{4,bit12{{bit 12 mask{24737
{{anb{8,wb{8,wc{{get bit 12{24738
{{mov{3,cswer{8,wb{{keep it as errors/noerrors option{24739
{{zrb{8,wb{6,prpa6{{skip if clear{24740
{{mov{8,wa{3,prlen{{get print buffer length{24741
{{sub{8,wa{18,=num08{{point 8 chars from line end{24742
{{mov{3,lstpo{8,wa{{store page offset{24743
*      check for -print/-noprint
{prpa6{mov{8,wb{4,bit11{{bit 11 mask{24747
{{anb{8,wb{8,wc{{get bit 11{24748
{{mov{3,cswpr{8,wb{{set -print if non-zero{24749
*      check for terminal
{{anb{8,wc{4,bits8{{see if terminal to be activated{24753
{{bnz{8,wc{6,prpa8{{jump if terminal required{24754
{{bze{3,initr{6,prpa9{{jump if no terminal to detach{24755
{{mov{7,xl{21,=v_ter{{ptr to /terminal/{24756
{{jsr{6,gtnvr{{{get vrblk pointer{24757
{{ppm{{{{cant fail{24758
{{mov{13,vrval(xr){21,=nulls{{clear value of terminal{24759
{{jsr{6,setvr{{{remove association{24760
{{brn{6,prpa9{{{return{24761
*      associate terminal
{prpa8{mnz{3,initr{{{note terminal associated{24765
{{bze{3,dnamb{6,prpa9{{cant if memory not organised{24766
{{mov{7,xl{21,=v_ter{{point to terminal string{24767
{{mov{8,wb{18,=trtou{{output trace type{24768
{{jsr{6,inout{{{attach output trblk to vrblk{24769
{{mov{11,-(xs){7,xr{{stack trblk ptr{24770
{{mov{7,xl{21,=v_ter{{point to terminal string{24771
{{mov{8,wb{18,=trtin{{input trace type{24772
{{jsr{6,inout{{{attach input trace blk{24773
{{mov{13,vrval(xr){10,(xs)+{{add output trblk to chain{24774
*      return point
{prpa9{exi{{{{return{24778
{{enp{{{{end procedure prpar{24779
{{ejc{{{{{24780
*      prtch -- print a character
*      prtch is used to print a single character
*      (wa)                  character to be printed
*      jsr  prtch            call to print character
{prtch{prc{25,e{1,0{{entry point{24789
{{mov{11,-(xs){7,xr{{save xr{24790
{{bne{3,profs{3,prlen{6,prch1{jump if room in buffer{24791
{{jsr{6,prtnl{{{else print this line{24792
*      here after making sure we have room
{prch1{mov{7,xr{3,prbuf{{point to print buffer{24796
{{psc{7,xr{3,profs{{point to next character location{24797
{{sch{8,wa{9,(xr){{store new character{24798
{{csc{7,xr{{{complete store characters{24799
{{icv{3,profs{{{bump pointer{24800
{{mov{7,xr{10,(xs)+{{restore entry xr{24801
{{exi{{{{return to prtch caller{24802
{{enp{{{{end procedure prtch{24803
{{ejc{{{{{24804
*      prtic -- print to interactive channel
*      prtic is called to print the contents of the standard
*      print buffer to the interactive channel. it is only
*      called after prtst has set up the string for printing.
*      it does not clear the buffer.
*      jsr  prtic            call for print
*      (wa,wb)               destroyed
{prtic{prc{25,e{1,0{{entry point{24816
{{mov{11,-(xs){7,xr{{save xr{24817
{{mov{7,xr{3,prbuf{{point to buffer{24818
{{mov{8,wa{3,profs{{no of chars{24819
{{jsr{6,syspi{{{print{24820
{{ppm{6,prtc2{{{fail return{24821
*      return
{prtc1{mov{7,xr{10,(xs)+{{restore xr{24825
{{exi{{{{return{24826
*      error occured
{prtc2{zer{3,erich{{{prevent looping{24830
{{erb{1,252{26,error on printing to interactive channel{{{24831
{{brn{6,prtc1{{{return{24832
{{enp{{{{procedure prtic{24833
{{ejc{{{{{24834
*      prtis -- print to interactive and standard printer
*      prtis puts a line from the print buffer onto the
*      interactive channel (if any) and the standard printer.
*      it always prints to the standard printer but does
*      not duplicate lines if the standard printer is
*      interactive.  it clears down the print buffer.
*      jsr  prtis            call for printing
*      (wa,wb)               destroyed
{prtis{prc{25,e{1,0{{entry point{24847
{{bnz{3,prich{6,prts1{{jump if standard printer is int.ch.{24848
{{bze{3,erich{6,prts1{{skip if not doing int. error reps.{24849
{{jsr{6,prtic{{{print to interactive channel{24850
*      merge and exit
{prts1{jsr{6,prtnl{{{print to standard printer{24854
{{exi{{{{return{24855
{{enp{{{{end procedure prtis{24856
{{ejc{{{{{24857
*      prtin -- print an integer
*      prtin prints the integer value which is in the integer
*      accumulator. blocks built in dynamic storage
*      during this process are immediately deleted.
*      (ia)                  integer value to be printed
*      jsr  prtin            call to print integer
*      (ia,ra)               destroyed
{prtin{prc{25,e{1,0{{entry point{24869
{{mov{11,-(xs){7,xr{{save xr{24870
{{jsr{6,icbld{{{build integer block{24871
{{blo{7,xr{3,dnamb{6,prti1{jump if icblk below dynamic{24872
{{bhi{7,xr{3,dnamp{6,prti1{jump if above dynamic{24873
{{mov{3,dnamp{7,xr{{immediately delete it{24874
*      delete icblk from dynamic store
{prti1{mov{11,-(xs){7,xr{{stack ptr for gtstg{24878
{{jsr{6,gtstg{{{convert to string{24879
{{ppm{{{{convert error is impossible{24880
{{mov{3,dnamp{7,xr{{reset pointer to delete scblk{24881
{{jsr{6,prtst{{{print integer string{24882
{{mov{7,xr{10,(xs)+{{restore entry xr{24883
{{exi{{{{return to prtin caller{24884
{{enp{{{{end procedure prtin{24885
{{ejc{{{{{24886
*      prtmi -- print message and integer
*      prtmi is used to print messages together with an integer
*      value starting in column 15 (used by the routines at
*      the end of compilation).
*      jsr  prtmi            call to print message and integer
{prtmi{prc{25,e{1,0{{entry point{24896
{{jsr{6,prtst{{{print string message{24897
{{mov{3,profs{18,=prtmf{{set column offset{24898
{{jsr{6,prtin{{{print integer{24899
{{jsr{6,prtnl{{{print line{24900
{{exi{{{{return to prtmi caller{24901
{{enp{{{{end procedure prtmi{24902
{{ejc{{{{{24903
*      prtmm -- print memory used and available
*      prtmm is used to provide memory usage information in
*      both the end-of-compile and end-of-run statistics.
*      jsr  prtmm            call to print memory stats
{prtmm{prc{25,e{1,0{{{24912
{{mov{8,wa{3,dnamp{{next available loc{24913
{{sub{8,wa{3,statb{{minus start{24914
{{mti{8,wa{{{convert to integer{24919
{{mov{7,xr{21,=encm1{{point to /memory used (words)/{24920
{{jsr{6,prtmi{{{print message{24921
{{mov{8,wa{3,dname{{end of memory{24922
{{sub{8,wa{3,dnamp{{minus next available loc{24923
{{mti{8,wa{{{convert to integer{24928
{{mov{7,xr{21,=encm2{{point to /memory available (words)/{24929
{{jsr{6,prtmi{{{print line{24930
{{exi{{{{return to prtmm caller{24931
{{enp{{{{end of procedure prtmm{24932
{{ejc{{{{{24933
*      prtmx  -- as prtmi with extra copy to interactive chan.
*      jsr  prtmx            call for printing
*      (wa,wb)               destroyed
{prtmx{prc{25,e{1,0{{entry point{24940
{{jsr{6,prtst{{{print string message{24941
{{mov{3,profs{18,=prtmf{{set column offset{24942
{{jsr{6,prtin{{{print integer{24943
{{jsr{6,prtis{{{print line{24944
{{exi{{{{return{24945
{{enp{{{{end procedure prtmx{24946
{{ejc{{{{{24947
*      prtnl -- print new line (end print line)
*      prtnl prints the contents of the print buffer, resets
*      the buffer to all blanks and resets the print pointer.
*      jsr  prtnl            call to print line
{prtnl{prc{25,r{1,0{{entry point{24956
{{bnz{3,headp{6,prnl0{{were headers printed{24957
{{jsr{6,prtps{{{no - print them{24958
*      call syspr
{prnl0{mov{11,-(xs){7,xr{{save entry xr{24962
{{mov{3,prtsa{8,wa{{save wa{24963
{{mov{3,prtsb{8,wb{{save wb{24964
{{mov{7,xr{3,prbuf{{load pointer to buffer{24965
{{mov{8,wa{3,profs{{load number of chars in buffer{24966
{{jsr{6,syspr{{{call system print routine{24967
{{ppm{6,prnl2{{{jump if failed{24968
{{lct{8,wa{3,prlnw{{load length of buffer in words{24969
{{add{7,xr{19,*schar{{point to chars of buffer{24970
{{mov{8,wb{4,nullw{{get word of blanks{24971
*      loop to blank buffer
{prnl1{mov{10,(xr)+{8,wb{{store word of blanks, bump ptr{24975
{{bct{8,wa{6,prnl1{{loop till all blanked{24976
*      exit point
{{mov{8,wb{3,prtsb{{restore wb{24980
{{mov{8,wa{3,prtsa{{restore wa{24981
{{mov{7,xr{10,(xs)+{{restore entry xr{24982
{{zer{3,profs{{{reset print buffer pointer{24983
{{exi{{{{return to prtnl caller{24984
*      file full or no output file for load module
{prnl2{bnz{3,prtef{6,prnl3{{jump if not first time{24988
{{mnz{3,prtef{{{mark first occurrence{24989
{{erb{1,253{26,print limit exceeded on standard output channel{{{24990
*      stop at once
{prnl3{mov{8,wb{18,=nini8{{ending code{24994
{{mov{8,wa{3,kvstn{{statement number{24995
{{mov{7,xl{3,r_fcb{{get fcblk chain head{24996
{{jsr{6,sysej{{{stop{24997
{{enp{{{{end procedure prtnl{24998
{{ejc{{{{{24999
*      prtnm -- print variable name
*      prtnm is used to print a character representation of the
*      name of a variable (not a value of datatype name)
*      names of pseudo-variables may not be passed to prtnm.
*      (xl)                  name base
*      (wa)                  name offset
*      jsr  prtnm            call to print name
*      (wb,wc,ra)            destroyed
{prtnm{prc{25,r{1,0{{entry point (recursive, see prtvl){25012
{{mov{11,-(xs){8,wa{{save wa (offset is collectable){25013
{{mov{11,-(xs){7,xr{{save entry xr{25014
{{mov{11,-(xs){7,xl{{save name base{25015
{{bhi{7,xl{3,state{6,prn02{jump if not natural variable{25016
*      here for natural variable name, recognized by the fact
*      that the name base points into the static area.
{{mov{7,xr{7,xl{{point to vrblk{25021
{{jsr{6,prtvn{{{print name of variable{25022
*      common exit point
{prn01{mov{7,xl{10,(xs)+{{restore name base{25026
{{mov{7,xr{10,(xs)+{{restore entry value of xr{25027
{{mov{8,wa{10,(xs)+{{restore wa{25028
{{exi{{{{return to prtnm caller{25029
*      here for case of non-natural variable
{prn02{mov{8,wb{8,wa{{copy name offset{25033
{{bne{9,(xl){22,=b_pdt{6,prn03{jump if array or table{25034
*      for program defined datatype, prt fld name, left paren
{{mov{7,xr{13,pddfp(xl){{load pointer to dfblk{25038
{{add{7,xr{8,wa{{add name offset{25039
{{mov{7,xr{13,pdfof(xr){{load vrblk pointer for field{25040
{{jsr{6,prtvn{{{print field name{25041
{{mov{8,wa{18,=ch_pp{{load left paren{25042
{{jsr{6,prtch{{{print character{25043
{{ejc{{{{{25044
*      prtnm (continued)
*      now we print an identifying name for the object if one
*      can be found. the following code searches for a natural
*      variable which contains this object as value. if such a
*      variable is found, its name is printed, else the value
*      of the object (as printed by prtvl) is used instead.
*      first we point to the parent tbblk if this is the case of
*      a table element. to do this, chase down the trnxt chain.
{prn03{bne{9,(xl){22,=b_tet{6,prn04{jump if we got there (or not te){25057
{{mov{7,xl{13,tenxt(xl){{else move out on chain{25058
{{brn{6,prn03{{{and loop back{25059
*      now we are ready for the search. to speed things up in
*      the case of calls from dump where the same name base
*      will occur repeatedly while dumping an array or table,
*      we remember the last vrblk pointer found in prnmv. so
*      first check to see if we have this one again.
{prn04{mov{7,xr{3,prnmv{{point to vrblk we found last time{25067
{{mov{8,wa{3,hshtb{{point to hash table in case not{25068
{{brn{6,prn07{{{jump into search for special check{25069
*      loop through hash slots
{prn05{mov{7,xr{8,wa{{copy slot pointer{25073
{{ica{8,wa{{{bump slot pointer{25074
{{sub{7,xr{19,*vrnxt{{introduce standard vrblk offset{25075
*      loop through vrblks on one hash chain
{prn06{mov{7,xr{13,vrnxt(xr){{point to next vrblk on hash chain{25079
*      merge here first time to check block we found last time
{prn07{mov{8,wc{7,xr{{copy vrblk pointer{25083
{{bze{8,wc{6,prn09{{jump if chain end (or prnmv zero){25084
{{ejc{{{{{25085
*      prtnm (continued)
*      loop to find value (chase down possible trblk chain)
{prn08{mov{7,xr{13,vrval(xr){{load value{25091
{{beq{9,(xr){22,=b_trt{6,prn08{loop if that was a trblk{25092
*      now we have the value, is this the block we want
{{beq{7,xr{7,xl{6,prn10{jump if this matches the name base{25096
{{mov{7,xr{8,wc{{else point back to that vrblk{25097
{{brn{6,prn06{{{and loop back{25098
*      here to move to next hash slot
{prn09{blt{8,wa{3,hshte{6,prn05{loop back if more to go{25102
{{mov{7,xr{7,xl{{else not found, copy value pointer{25103
{{jsr{6,prtvl{{{print value{25104
{{brn{6,prn11{{{and merge ahead{25105
*      here when we find a matching entry
{prn10{mov{7,xr{8,wc{{copy vrblk pointer{25109
{{mov{3,prnmv{7,xr{{save for next time in{25110
{{jsr{6,prtvn{{{print variable name{25111
*      merge here if no entry found
{prn11{mov{8,wc{9,(xl){{load first word of name base{25115
{{bne{8,wc{22,=b_pdt{6,prn13{jump if not program defined{25116
*      for program defined datatype, add right paren and exit
{{mov{8,wa{18,=ch_rp{{load right paren, merge{25120
*      merge here to print final right paren or bracket
{prn12{jsr{6,prtch{{{print final character{25124
{{mov{8,wa{8,wb{{restore name offset{25125
{{brn{6,prn01{{{merge back to exit{25126
{{ejc{{{{{25127
*      prtnm (continued)
*      here for array or table
{prn13{mov{8,wa{18,=ch_bb{{load left bracket{25133
{{jsr{6,prtch{{{and print it{25134
{{mov{7,xl{9,(xs){{restore block pointer{25135
{{mov{8,wc{9,(xl){{load type word again{25136
{{bne{8,wc{22,=b_tet{6,prn15{jump if not table{25137
*      here for table, print subscript value
{{mov{7,xr{13,tesub(xl){{load subscript value{25141
{{mov{7,xl{8,wb{{save name offset{25142
{{jsr{6,prtvl{{{print subscript value{25143
{{mov{8,wb{7,xl{{restore name offset{25144
*      merge here from array case to print right bracket
{prn14{mov{8,wa{18,=ch_rb{{load right bracket{25148
{{brn{6,prn12{{{merge back to print it{25149
*      here for array or vector, to print subscript(s)
{prn15{mov{8,wa{8,wb{{copy name offset{25153
{{btw{8,wa{{{convert to words{25154
{{beq{8,wc{22,=b_art{6,prn16{jump if arblk{25155
*      here for vector
{{sub{8,wa{18,=vcvlb{{adjust for standard fields{25159
{{mti{8,wa{{{move to integer accum{25160
{{jsr{6,prtin{{{print linear subscript{25161
{{brn{6,prn14{{{merge back for right bracket{25162
{{ejc{{{{{25163
*      prtnm (continued)
*      here for array. first calculate absolute subscript
*      offsets by successive divisions by the dimension values.
*      this must be done right to left since the elements are
*      stored row-wise. the subscripts are stacked as integers.
{prn16{mov{8,wc{13,arofs(xl){{load length of bounds info{25172
{{ica{8,wc{{{adjust for arpro field{25173
{{btw{8,wc{{{convert to words{25174
{{sub{8,wa{8,wc{{get linear zero-origin subscript{25175
{{mti{8,wa{{{get integer value{25176
{{lct{8,wa{13,arndm(xl){{set num of dimensions as loop count{25177
{{add{7,xl{13,arofs(xl){{point past bounds information{25178
{{sub{7,xl{19,*arlbd{{set ok offset for proper ptr later{25179
*      loop to stack subscript offsets
{prn17{sub{7,xl{19,*ardms{{point to next set of bounds{25183
{{sti{3,prnsi{{{save current offset{25184
{{rmi{13,ardim(xl){{{get remainder on dividing by dimens{25185
{{mfi{11,-(xs){{{store on stack (one word){25186
{{ldi{3,prnsi{{{reload argument{25187
{{dvi{13,ardim(xl){{{divide to get quotient{25188
{{bct{8,wa{6,prn17{{loop till all stacked{25189
{{zer{7,xr{{{set offset to first set of bounds{25190
{{lct{8,wb{13,arndm(xl){{load count of dims to control loop{25191
{{brn{6,prn19{{{jump into print loop{25192
*      loop to print subscripts from stack adjusting by adding
*      the appropriate low bound value from the arblk
{prn18{mov{8,wa{18,=ch_cm{{load a comma{25197
{{jsr{6,prtch{{{print it{25198
*      merge here first time in (no comma required)
{prn19{mti{10,(xs)+{{{load subscript offset as integer{25202
{{add{7,xl{7,xr{{point to current lbd{25203
{{adi{13,arlbd(xl){{{add lbd to get signed subscript{25204
{{sub{7,xl{7,xr{{point back to start of arblk{25205
{{jsr{6,prtin{{{print subscript{25206
{{add{7,xr{19,*ardms{{bump offset to next bounds{25207
{{bct{8,wb{6,prn18{{loop back till all printed{25208
{{brn{6,prn14{{{merge back to print right bracket{25209
{{enp{{{{end procedure prtnm{25210
{{ejc{{{{{25211
*      prtnv -- print name value
*      prtnv is used by the trace and dump routines to print
*      a line of the form
*      name = value
*      note that the name involved can never be a pseudo-var
*      (xl)                  name base
*      (wa)                  name offset
*      jsr  prtnv            call to print name = value
*      (wb,wc,ra)            destroyed
{prtnv{prc{25,e{1,0{{entry point{25227
{{jsr{6,prtnm{{{print argument name{25228
{{mov{11,-(xs){7,xr{{save entry xr{25229
{{mov{11,-(xs){8,wa{{save name offset (collectable){25230
{{mov{7,xr{21,=tmbeb{{point to blank equal blank{25231
{{jsr{6,prtst{{{print it{25232
{{mov{7,xr{7,xl{{copy name base{25233
{{add{7,xr{8,wa{{point to value{25234
{{mov{7,xr{9,(xr){{load value pointer{25235
{{jsr{6,prtvl{{{print value{25236
{{jsr{6,prtnl{{{terminate line{25237
{{mov{8,wa{10,(xs)+{{restore name offset{25238
{{mov{7,xr{10,(xs)+{{restore entry xr{25239
{{exi{{{{return to caller{25240
{{enp{{{{end procedure prtnv{25241
{{ejc{{{{{25242
*      prtpg  -- print a page throw
*      prints a page throw or a few blank lines on the standard
*      listing channel depending on the listing options chosen.
*      jsr  prtpg            call for page eject
{prtpg{prc{25,e{1,0{{entry point{25251
{{beq{3,stage{18,=stgxt{6,prp01{jump if execution time{25252
{{bze{3,lstlc{6,prp06{{return if top of page already{25253
{{zer{3,lstlc{{{clear line count{25254
*      check type of listing
{prp01{mov{11,-(xs){7,xr{{preserve xr{25258
{{bnz{3,prstd{6,prp02{{eject if flag set{25259
{{bnz{3,prich{6,prp03{{jump if interactive listing channel{25260
{{bze{3,precl{6,prp03{{jump if compact listing{25261
*      perform an eject
{prp02{jsr{6,sysep{{{eject{25265
{{brn{6,prp04{{{merge{25266
*      compact or interactive channel listing. cant print
*      blanks until check made for headers printed and flag set.
{prp03{mov{7,xr{3,headp{{remember headp{25272
{{mnz{3,headp{{{set to avoid repeated prtpg calls{25273
{{jsr{6,prtnl{{{print blank line{25274
{{jsr{6,prtnl{{{print blank line{25275
{{jsr{6,prtnl{{{print blank line{25276
{{mov{3,lstlc{18,=num03{{count blank lines{25277
{{mov{3,headp{7,xr{{restore header flag{25278
{{ejc{{{{{25279
*      prptg (continued)
*      print the heading
{prp04{bnz{3,headp{6,prp05{{jump if header listed{25285
{{mnz{3,headp{{{mark headers printed{25286
{{mov{11,-(xs){7,xl{{keep xl{25287
{{mov{7,xr{21,=headr{{point to listing header{25288
{{jsr{6,prtst{{{place it{25289
{{jsr{6,sysid{{{get system identification{25290
{{jsr{6,prtst{{{append extra chars{25291
{{jsr{6,prtnl{{{print it{25292
{{mov{7,xr{7,xl{{extra header line{25293
{{jsr{6,prtst{{{place it{25294
{{jsr{6,prtnl{{{print it{25295
{{jsr{6,prtnl{{{print a blank{25296
{{jsr{6,prtnl{{{and another{25297
{{add{3,lstlc{18,=num04{{four header lines printed{25298
{{mov{7,xl{10,(xs)+{{restore xl{25299
*      merge if header not printed
{prp05{mov{7,xr{10,(xs)+{{restore xr{25303
*      return
{prp06{exi{{{{return{25307
{{enp{{{{end procedure prtpg{25308
{{ejc{{{{{25309
*      prtps - print page with test for standard listing option
*      if the standard listing option is selected, insist that
*      an eject be done
*      jsr  prtps            call for eject
{prtps{prc{25,e{1,0{{entry point{25318
{{mov{3,prstd{3,prsto{{copy option flag{25319
{{jsr{6,prtpg{{{print page{25320
{{zer{3,prstd{{{clear flag{25321
{{exi{{{{return{25322
{{enp{{{{end procedure prtps{25323
{{ejc{{{{{25324
*      prtsn -- print statement number
*      prtsn is used to initiate a print trace line by printing
*      asterisks and the current statement number. the actual
*      format of the output generated is.
*      ***nnnnn**** iii.....iiii
*      nnnnn is the statement number with leading zeros replaced
*      by asterisks (e.g. *******9****)
*      iii...iii represents a variable length output consisting
*      of a number of letter i characters equal to fnclevel.
*      jsr  prtsn            call to print statement number
*      (wc)                  destroyed
{prtsn{prc{25,e{1,0{{entry point{25343
{{mov{11,-(xs){7,xr{{save entry xr{25344
{{mov{3,prsna{8,wa{{save entry wa{25345
{{mov{7,xr{21,=tmasb{{point to asterisks{25346
{{jsr{6,prtst{{{print asterisks{25347
{{mov{3,profs{18,=num04{{point into middle of asterisks{25348
{{mti{3,kvstn{{{load statement number as integer{25349
{{jsr{6,prtin{{{print integer statement number{25350
{{mov{3,profs{18,=prsnf{{point past asterisks plus blank{25351
{{mov{7,xr{3,kvfnc{{get fnclevel{25352
{{mov{8,wa{18,=ch_li{{set letter i{25353
*      loop to generate letter i fnclevel times
{prsn1{bze{7,xr{6,prsn2{{jump if all set{25357
{{jsr{6,prtch{{{else print an i{25358
{{dcv{7,xr{{{decrement counter{25359
{{brn{6,prsn1{{{loop back{25360
*      merge with all letter i characters generated
{prsn2{mov{8,wa{18,=ch_bl{{get blank{25364
{{jsr{6,prtch{{{print blank{25365
{{mov{8,wa{3,prsna{{restore entry wa{25366
{{mov{7,xr{10,(xs)+{{restore entry xr{25367
{{exi{{{{return to prtsn caller{25368
{{enp{{{{end procedure prtsn{25369
{{ejc{{{{{25370
*      prtst -- print string
*      prtst places a string of characters in the print buffer
*      see prtnl for global locations used
*      note that the first word of the block (normally b_scl)
*      is not used and need not be set correctly (see prtvn)
*      (xr)                  string to be printed
*      jsr  prtst            call to print string
*      (profs)               updated past chars placed
{prtst{prc{25,r{1,0{{entry point{25385
{{bnz{3,headp{6,prst0{{were headers printed{25386
{{jsr{6,prtps{{{no - print them{25387
*      call syspr
{prst0{mov{3,prsva{8,wa{{save wa{25391
{{mov{3,prsvb{8,wb{{save wb{25392
{{zer{8,wb{{{set chars printed count to zero{25393
*      loop to print successive lines for long string
{prst1{mov{8,wa{13,sclen(xr){{load string length{25397
{{sub{8,wa{8,wb{{subtract count of chars already out{25398
{{bze{8,wa{6,prst4{{jump to exit if none left{25399
{{mov{11,-(xs){7,xl{{else stack entry xl{25400
{{mov{11,-(xs){7,xr{{save argument{25401
{{mov{7,xl{7,xr{{copy for eventual move{25402
{{mov{7,xr{3,prlen{{load print buffer length{25403
{{sub{7,xr{3,profs{{get chars left in print buffer{25404
{{bnz{7,xr{6,prst2{{skip if room left on this line{25405
{{jsr{6,prtnl{{{else print this line{25406
{{mov{7,xr{3,prlen{{and set full width available{25407
{{ejc{{{{{25408
*      prtst (continued)
*      here with chars to print and some room in buffer
{prst2{blo{8,wa{7,xr{6,prst3{jump if room for rest of string{25414
{{mov{8,wa{7,xr{{else set to fill line{25415
*      merge here with character count in wa
{prst3{mov{7,xr{3,prbuf{{point to print buffer{25419
{{plc{7,xl{8,wb{{point to location in string{25420
{{psc{7,xr{3,profs{{point to location in buffer{25421
{{add{8,wb{8,wa{{bump string chars count{25422
{{add{3,profs{8,wa{{bump buffer pointer{25423
{{mov{3,prsvc{8,wb{{preserve char counter{25424
{{mvc{{{{move characters to buffer{25425
{{mov{8,wb{3,prsvc{{recover char counter{25426
{{mov{7,xr{10,(xs)+{{restore argument pointer{25427
{{mov{7,xl{10,(xs)+{{restore entry xl{25428
{{brn{6,prst1{{{loop back to test for more{25429
*      here to exit after printing string
{prst4{mov{8,wb{3,prsvb{{restore entry wb{25433
{{mov{8,wa{3,prsva{{restore entry wa{25434
{{exi{{{{return to prtst caller{25435
{{enp{{{{end procedure prtst{25436
{{ejc{{{{{25437
*      prttr -- print to terminal
*      called to print contents of standard print buffer to
*      online terminal. clears buffer down and resets profs.
*      jsr  prttr            call for print
*      (wa,wb)               destroyed
{prttr{prc{25,e{1,0{{entry point{25447
{{mov{11,-(xs){7,xr{{save xr{25448
{{jsr{6,prtic{{{print buffer contents{25449
{{mov{7,xr{3,prbuf{{point to print bfr to clear it{25450
{{lct{8,wa{3,prlnw{{get buffer length{25451
{{add{7,xr{19,*schar{{point past scblk header{25452
{{mov{8,wb{4,nullw{{get blanks{25453
*      loop to clear buffer
{prtt1{mov{10,(xr)+{8,wb{{clear a word{25457
{{bct{8,wa{6,prtt1{{loop{25458
{{zer{3,profs{{{reset profs{25459
{{mov{7,xr{10,(xs)+{{restore xr{25460
{{exi{{{{return{25461
{{enp{{{{end procedure prttr{25462
{{ejc{{{{{25463
*      prtvl -- print a value
*      prtvl places an appropriate character representation of
*      a data value in the print buffer for dump/trace use.
*      (xr)                  value to be printed
*      jsr  prtvl            call to print value
*      (wa,wb,wc,ra)         destroyed
{prtvl{prc{25,r{1,0{{entry point, recursive{25474
{{mov{11,-(xs){7,xl{{save entry xl{25475
{{mov{11,-(xs){7,xr{{save argument{25476
{{chk{{{{check for stack overflow{25477
*      loop back here after finding a trap block (trblk)
{prv01{mov{3,prvsi{13,idval(xr){{copy idval (if any){25481
{{mov{7,xl{9,(xr){{load first word of block{25482
{{lei{7,xl{{{load entry point id{25483
{{bsw{7,xl{2,bl__t{6,prv02{switch on block type{25484
{{iff{2,bl_ar{6,prv05{{arblk{25502
{{iff{1,1{6,prv02{{{25502
{{iff{1,2{6,prv02{{{25502
{{iff{2,bl_ic{6,prv08{{icblk{25502
{{iff{2,bl_nm{6,prv09{{nmblk{25502
{{iff{1,5{6,prv02{{{25502
{{iff{1,6{6,prv02{{{25502
{{iff{1,7{6,prv02{{{25502
{{iff{2,bl_rc{6,prv08{{rcblk{25502
{{iff{2,bl_sc{6,prv11{{scblk{25502
{{iff{2,bl_se{6,prv12{{seblk{25502
{{iff{2,bl_tb{6,prv13{{tbblk{25502
{{iff{2,bl_vc{6,prv13{{vcblk{25502
{{iff{1,13{6,prv02{{{25502
{{iff{1,14{6,prv02{{{25502
{{iff{1,15{6,prv02{{{25502
{{iff{2,bl_pd{6,prv10{{pdblk{25502
{{iff{2,bl_tr{6,prv04{{trblk{25502
{{esw{{{{end of switch on block type{25502
*      here for blocks for which we just print datatype name
{prv02{jsr{6,dtype{{{get datatype name{25506
{{jsr{6,prtst{{{print datatype name{25507
*      common exit point
{prv03{mov{7,xr{10,(xs)+{{reload argument{25511
{{mov{7,xl{10,(xs)+{{restore xl{25512
{{exi{{{{return to prtvl caller{25513
*      here for trblk
{prv04{mov{7,xr{13,trval(xr){{load real value{25517
{{brn{6,prv01{{{and loop back{25518
{{ejc{{{{{25519
*      prtvl (continued)
*      here for array (arblk)
*      print array ( prototype ) blank number idval
{prv05{mov{7,xl{7,xr{{preserve argument{25527
{{mov{7,xr{21,=scarr{{point to datatype name (array){25528
{{jsr{6,prtst{{{print it{25529
{{mov{8,wa{18,=ch_pp{{load left paren{25530
{{jsr{6,prtch{{{print left paren{25531
{{add{7,xl{13,arofs(xl){{point to prototype{25532
{{mov{7,xr{9,(xl){{load prototype{25533
{{jsr{6,prtst{{{print prototype{25534
*      vcblk, tbblk, bcblk merge here for ) blank number idval
{prv06{mov{8,wa{18,=ch_rp{{load right paren{25538
{{jsr{6,prtch{{{print right paren{25539
*      pdblk merges here to print blank number idval
{prv07{mov{8,wa{18,=ch_bl{{load blank{25543
{{jsr{6,prtch{{{print it{25544
{{mov{8,wa{18,=ch_nm{{load number sign{25545
{{jsr{6,prtch{{{print it{25546
{{mti{3,prvsi{{{get idval{25547
{{jsr{6,prtin{{{print id number{25548
{{brn{6,prv03{{{back to exit{25549
*      here for integer (icblk), real (rcblk)
*      print character representation of value
{prv08{mov{11,-(xs){7,xr{{stack argument for gtstg{25555
{{jsr{6,gtstg{{{convert to string{25556
{{ppm{{{{error return is impossible{25557
{{jsr{6,prtst{{{print the string{25558
{{mov{3,dnamp{7,xr{{delete garbage string from storage{25559
{{brn{6,prv03{{{back to exit{25560
{{ejc{{{{{25561
*      prtvl (continued)
*      name (nmblk)
*      for pseudo-variable, just print datatype name (name)
*      for all other names, print dot followed by name rep
{prv09{mov{7,xl{13,nmbas(xr){{load name base{25570
{{mov{8,wa{9,(xl){{load first word of block{25571
{{beq{8,wa{22,=b_kvt{6,prv02{just print name if keyword{25572
{{beq{8,wa{22,=b_evt{6,prv02{just print name if expression var{25573
{{mov{8,wa{18,=ch_dt{{else get dot{25574
{{jsr{6,prtch{{{and print it{25575
{{mov{8,wa{13,nmofs(xr){{load name offset{25576
{{jsr{6,prtnm{{{print name{25577
{{brn{6,prv03{{{back to exit{25578
*      program datatype (pdblk)
*      print datatype name ch_bl ch_nm idval
{prv10{jsr{6,dtype{{{get datatype name{25584
{{jsr{6,prtst{{{print datatype name{25585
{{brn{6,prv07{{{merge back to print id{25586
*      here for string (scblk)
*      print quote string-characters quote
{prv11{mov{8,wa{18,=ch_sq{{load single quote{25592
{{jsr{6,prtch{{{print quote{25593
{{jsr{6,prtst{{{print string value{25594
{{jsr{6,prtch{{{print another quote{25595
{{brn{6,prv03{{{back to exit{25596
{{ejc{{{{{25597
*      prtvl (continued)
*      here for simple expression (seblk)
*      print asterisk variable-name
{prv12{mov{8,wa{18,=ch_as{{load asterisk{25605
{{jsr{6,prtch{{{print asterisk{25606
{{mov{7,xr{13,sevar(xr){{load variable pointer{25607
{{jsr{6,prtvn{{{print variable name{25608
{{brn{6,prv03{{{jump back to exit{25609
*      here for table (tbblk) and array (vcblk)
*      print datatype ( prototype ) blank number idval
{prv13{mov{7,xl{7,xr{{preserve argument{25615
{{jsr{6,dtype{{{get datatype name{25616
{{jsr{6,prtst{{{print datatype name{25617
{{mov{8,wa{18,=ch_pp{{load left paren{25618
{{jsr{6,prtch{{{print left paren{25619
{{mov{8,wa{13,tblen(xl){{load length of block (=vclen){25620
{{btw{8,wa{{{convert to word count{25621
{{sub{8,wa{18,=tbsi_{{allow for standard fields{25622
{{beq{9,(xl){22,=b_tbt{6,prv14{jump if table{25623
{{add{8,wa{18,=vctbd{{for vcblk, adjust size{25624
*      print prototype
{prv14{mti{8,wa{{{move as integer{25628
{{jsr{6,prtin{{{print integer prototype{25629
{{brn{6,prv06{{{merge back for rest{25630
{{enp{{{{end procedure prtvl{25653
{{ejc{{{{{25654
*      prtvn -- print natural variable name
*      prtvn prints the name of a natural variable
*      (xr)                  pointer to vrblk
*      jsr  prtvn            call to print variable name
{prtvn{prc{25,e{1,0{{entry point{25663
{{mov{11,-(xs){7,xr{{stack vrblk pointer{25664
{{add{7,xr{19,*vrsof{{point to possible string name{25665
{{bnz{13,sclen(xr){6,prvn1{{jump if not system variable{25666
{{mov{7,xr{13,vrsvo(xr){{point to svblk with name{25667
*      merge here with dummy scblk pointer in xr
{prvn1{jsr{6,prtst{{{print string name of variable{25671
{{mov{7,xr{10,(xs)+{{restore vrblk pointer{25672
{{exi{{{{return to prtvn caller{25673
{{enp{{{{end procedure prtvn{25674
{{ejc{{{{{25677
*      rcbld -- build a real block
*      (ra)                  real value for rcblk
*      jsr  rcbld            call to build real block
*      (xr)                  pointer to result rcblk
*      (wa)                  destroyed
{rcbld{prc{25,e{1,0{{entry point{25686
{{mov{7,xr{3,dnamp{{load pointer to next available loc{25687
{{add{7,xr{19,*rcsi_{{point past new rcblk{25688
{{blo{7,xr{3,dname{6,rcbl1{jump if there is room{25689
{{mov{8,wa{19,*rcsi_{{else load rcblk length{25690
{{jsr{6,alloc{{{use standard allocator to get block{25691
{{add{7,xr{8,wa{{point past block to merge{25692
*      merge here with xr pointing past the block obtained
{rcbl1{mov{3,dnamp{7,xr{{set new pointer{25696
{{sub{7,xr{19,*rcsi_{{point back to start of block{25697
{{mov{9,(xr){22,=b_rcl{{store type word{25698
{{str{13,rcval(xr){{{store real value in rcblk{25699
{{exi{{{{return to rcbld caller{25700
{{enp{{{{end procedure rcbld{25701
{{ejc{{{{{25703
*      readr -- read next source image at compile time
*      readr is used to read the next source image. to process
*      continuation cards properly, the compiler must read one
*      line ahead. thus readr does not destroy the current image
*      see also the nexts routine which actually gets the image.
*      jsr  readr            call to read next image
*      (xr)                  ptr to next image (0 if none)
*      (r_cni)               copy of pointer
*      (wa,wb,wc,xl)         destroyed
{readr{prc{25,e{1,0{{entry point{25717
{{mov{7,xr{3,r_cni{{get ptr to next image{25718
{{bnz{7,xr{6,read3{{exit if already read{25719
{{bnz{3,cnind{6,reada{{if within include file{25721
{{bne{3,stage{18,=stgic{6,read3{exit if not initial compile{25723
{reada{mov{8,wa{3,cswin{{max read length{25724
{{zer{7,xl{{{clear any dud value in xl{25725
{{jsr{6,alocs{{{allocate buffer{25726
{{jsr{6,sysrd{{{read input image{25727
{{ppm{6,read4{{{jump if eof or new file name{25728
{{icv{3,rdnln{{{increment next line number{25729
{{dcv{3,polct{{{test if time to poll interface{25731
{{bnz{3,polct{6,read0{{not yet{25732
{{zer{8,wa{{{=0 for poll{25733
{{mov{8,wb{3,rdnln{{line number{25734
{{jsr{6,syspl{{{allow interactive access{25735
{{err{1,320{26,user interrupt{{{25736
{{ppm{{{{single step{25737
{{ppm{{{{expression evaluation{25738
{{mov{3,polcs{8,wa{{new countdown start value{25739
{{mov{3,polct{8,wa{{new counter value{25740
{read0{ble{13,sclen(xr){3,cswin{6,read1{use smaller of string lnth ...{25742
{{mov{13,sclen(xr){3,cswin{{... and xxx of -inxxx{25743
*      perform the trim
{read1{mnz{8,wb{{{set trimr to perform trim{25747
{{jsr{6,trimr{{{trim trailing blanks{25748
*      merge here after read
{read2{mov{3,r_cni{7,xr{{store copy of pointer{25752
*      merge here if no read attempted
{read3{exi{{{{return to readr caller{25756
*      here on end of file or new source file name.
*      if this is a new source file name, the r_sfn table will
*      be augmented with a new table entry consisting of the
*      current compiler statement number as subscript, and the
*      file name as value.
{read4{bze{13,sclen(xr){6,read5{{jump if true end of file{25765
{{zer{8,wb{{{new source file name{25766
{{mov{3,rdnln{8,wb{{restart line counter for new file{25767
{{jsr{6,trimr{{{remove unused space in block{25768
{{jsr{6,newfn{{{record new file name{25769
{{brn{6,reada{{{now reissue read for record data{25770
*      here on end of file
{read5{mov{3,dnamp{7,xr{{pop unused scblk{25774
{{bze{3,cnind{6,read6{{jump if not within an include file{25776
{{zer{7,xl{{{eof within include file{25777
{{jsr{6,sysif{{{switch stream back to previous file{25778
{{ppm{{{{{25779
{{mov{8,wa{3,cnind{{restore prev line number, file name{25780
{{add{8,wa{18,=vcvlb{{vector offset in words{25781
{{wtb{8,wa{{{convert to bytes{25782
{{mov{7,xr{3,r_ifa{{file name array{25783
{{add{7,xr{8,wa{{ptr to element{25784
{{mov{3,r_sfc{9,(xr){{change source file name{25785
{{mov{9,(xr){21,=nulls{{release scblk{25786
{{mov{7,xr{3,r_ifl{{line number array{25787
{{add{7,xr{8,wa{{ptr to element{25788
{{mov{7,xl{9,(xr){{icblk containing saved line number{25789
{{ldi{13,icval(xl){{{line number integer{25790
{{mfi{3,rdnln{{{change source line number{25791
{{mov{9,(xr){21,=inton{{release icblk{25792
{{dcv{3,cnind{{{decrement nesting level{25793
{{mov{8,wb{3,cmpsn{{current statement number{25794
{{icv{8,wb{{{anticipate end of previous stmt{25795
{{mti{8,wb{{{convert to integer{25796
{{jsr{6,icbld{{{build icblk for stmt number{25797
{{mov{7,xl{3,r_sfn{{file name table{25798
{{mnz{8,wb{{{lookup statement number by name{25799
{{jsr{6,tfind{{{allocate new teblk{25800
{{ppm{{{{always possible to allocate block{25801
{{mov{13,teval(xl){3,r_sfc{{record file name as entry value{25802
{{beq{3,stage{18,=stgic{6,reada{if initial compile, reissue read{25803
{{bnz{3,cnind{6,reada{{still reading from include file{25804
*      outer nesting of execute-time compile of -include
*      resume with any string remaining prior to -include.
{{mov{7,xl{3,r_ici{{restore code argument string{25809
{{zer{3,r_ici{{{release original string{25810
{{mov{8,wa{3,cnsil{{get length of string{25811
{{mov{8,wb{3,cnspt{{offset of characters left{25812
{{sub{8,wa{8,wb{{number of characters left{25813
{{mov{3,scnil{8,wa{{set new scan length{25814
{{zer{3,scnpt{{{scan from start of substring{25815
{{jsr{6,sbstr{{{create substring of remainder{25816
{{mov{3,r_cim{7,xr{{set scan image{25817
{{brn{6,read2{{{return{25818
{read6{zer{7,xr{{{zero ptr as result{25834
{{brn{6,read2{{{merge{25835
{{enp{{{{end procedure readr{25836
{{ejc{{{{{25837
*      sbstr -- build a substring
*      (xl)                  ptr to scblk/bfblk with chars
*      (wa)                  number of chars in substring
*      (wb)                  offset to first char in scblk
*      jsr  sbstr            call to build substring
*      (xr)                  ptr to new scblk with substring
*      (xl)                  zero
*      (wa,wb,wc,xl,ia)      destroyed
*      note that sbstr is called with a dummy string pointer
*      (pointing into a vrblk or svblk) to copy the name of a
*      variable as a standard string value.
{sbstr{prc{25,e{1,0{{entry point{25932
{{bze{8,wa{6,sbst2{{jump if null substring{25933
{{jsr{6,alocs{{{else allocate scblk{25934
{{mov{8,wa{8,wc{{move number of characters{25935
{{mov{8,wc{7,xr{{save ptr to new scblk{25936
{{plc{7,xl{8,wb{{prepare to load chars from old blk{25937
{{psc{7,xr{{{prepare to store chars in new blk{25938
{{mvc{{{{move characters to new string{25939
{{mov{7,xr{8,wc{{then restore scblk pointer{25940
*      return point
{sbst1{zer{7,xl{{{clear garbage pointer in xl{25944
{{exi{{{{return to sbstr caller{25945
*      here for null substring
{sbst2{mov{7,xr{21,=nulls{{set null string as result{25949
{{brn{6,sbst1{{{return{25950
{{enp{{{{end procedure sbstr{25951
{{ejc{{{{{25952
*      stgcc -- compute counters for stmt startup testing
*      jsr  stgcc            call to recompute counters
*      (wa,wb)               destroyed
*      on exit, stmcs and stmct contain the counter value to
*      tested in stmgo.
{stgcc{prc{25,e{1,0{{{25963
{{mov{8,wa{3,polcs{{assume no profiling or stcount tracing{25965
{{mov{8,wb{18,=num01{{poll each time polcs expires{25966
{{ldi{3,kvstl{{{get stmt limit{25970
{{bnz{3,kvpfl{6,stgc1{{jump if profiling enabled{25971
{{ilt{6,stgc3{{{no stcount tracing if negative{25972
{{bze{3,r_stc{6,stgc2{{jump if not stcount tracing{25973
*      here if profiling or if stcount tracing enabled
{stgc1{mov{8,wb{8,wa{{count polcs times within stmg{25978
{{mov{8,wa{18,=num01{{break out of stmgo on each stmt{25979
{{brn{6,stgc3{{{{25983
*      check that stmcs does not exceed kvstl
{stgc2{mti{8,wa{{{breakout count start value{25987
{{sbi{3,kvstl{{{proposed stmcs minus stmt limit{25988
{{ile{6,stgc3{{{jump if stmt count does not limit{25989
{{ldi{3,kvstl{{{stlimit limits breakcount count{25990
{{mfi{8,wa{{{use it instead{25991
*      re-initialize counter
{stgc3{mov{3,stmcs{8,wa{{update breakout count start value{25995
{{mov{3,stmct{8,wa{{reset breakout counter{25996
{{mov{3,polct{8,wb{{{25998
{{exi{{{{{26000
{{ejc{{{{{26001
*      tfind -- locate table element
*      (xr)                  subscript value for element
*      (xl)                  pointer to table
*      (wb)                  zero by value, non-zero by name
*      jsr  tfind            call to locate element
*      ppm  loc              transfer location if access fails
*      (xr)                  element value (if by value)
*      (xr)                  destroyed (if by name)
*      (xl,wa)               teblk name (if by name)
*      (xl,wa)               destroyed (if by value)
*      (wc,ra)               destroyed
*      note that if a call by value specifies a non-existent
*      subscript, the default value is returned without building
*      a new teblk.
{tfind{prc{25,e{1,1{{entry point{26020
{{mov{11,-(xs){8,wb{{save name/value indicator{26021
{{mov{11,-(xs){7,xr{{save subscript value{26022
{{mov{11,-(xs){7,xl{{save table pointer{26023
{{mov{8,wa{13,tblen(xl){{load length of tbblk{26024
{{btw{8,wa{{{convert to word count{26025
{{sub{8,wa{18,=tbbuk{{get number of buckets{26026
{{mti{8,wa{{{convert to integer value{26027
{{sti{3,tfnsi{{{save for later{26028
{{mov{7,xl{9,(xr){{load first word of subscript{26029
{{lei{7,xl{{{load block entry id (bl_xx){26030
{{bsw{7,xl{2,bl__d{6,tfn00{switch on block type{26031
{{iff{1,0{6,tfn00{{{26042
{{iff{1,1{6,tfn00{{{26042
{{iff{1,2{6,tfn00{{{26042
{{iff{2,bl_ic{6,tfn02{{jump if integer{26042
{{iff{2,bl_nm{6,tfn04{{jump if name{26042
{{iff{2,bl_p0{6,tfn03{{jump if pattern{26042
{{iff{2,bl_p1{6,tfn03{{jump if pattern{26042
{{iff{2,bl_p2{6,tfn03{{jump if pattern{26042
{{iff{2,bl_rc{6,tfn02{{real{26042
{{iff{2,bl_sc{6,tfn05{{jump if string{26042
{{iff{1,10{6,tfn00{{{26042
{{iff{1,11{6,tfn00{{{26042
{{iff{1,12{6,tfn00{{{26042
{{iff{1,13{6,tfn00{{{26042
{{iff{1,14{6,tfn00{{{26042
{{iff{1,15{6,tfn00{{{26042
{{iff{1,16{6,tfn00{{{26042
{{esw{{{{end switch on block type{26042
*      here for blocks for which we use the second word of the
*      block as the hash source (see block formats for details).
{tfn00{mov{8,wa{12,1(xr){{load second word{26047
*      merge here with one word hash source in wa
{tfn01{mti{8,wa{{{convert to integer{26051
{{brn{6,tfn06{{{jump to merge{26052
{{ejc{{{{{26053
*      tfind (continued)
*      here for integer or real
*      possibility of overflow exist on twos complement
*      machine if hash source is most negative integer or is
*      a real having the same bit pattern.
{tfn02{ldi{12,1(xr){{{load value as hash source{26063
{{ige{6,tfn06{{{ok if positive or zero{26064
{{ngi{{{{make positive{26065
{{iov{6,tfn06{{{clear possible overflow{26066
{{brn{6,tfn06{{{merge{26067
*      for pattern, use first word (pcode) as source
{tfn03{mov{8,wa{9,(xr){{load first word as hash source{26071
{{brn{6,tfn01{{{merge back{26072
*      for name, use offset as hash source
{tfn04{mov{8,wa{13,nmofs(xr){{load offset as hash source{26076
{{brn{6,tfn01{{{merge back{26077
*      here for string
{tfn05{jsr{6,hashs{{{call routine to compute hash{26081
*      merge here with hash source in (ia)
{tfn06{rmi{3,tfnsi{{{compute hash index by remaindering{26085
{{mfi{8,wc{{{get as one word integer{26086
{{wtb{8,wc{{{convert to byte offset{26087
{{mov{7,xl{9,(xs){{get table ptr again{26088
{{add{7,xl{8,wc{{point to proper bucket{26089
{{mov{7,xr{13,tbbuk(xl){{load first teblk pointer{26090
{{beq{7,xr{9,(xs){6,tfn10{jump if no teblks on chain{26091
*      loop through teblks on hash chain
{tfn07{mov{8,wb{7,xr{{save teblk pointer{26095
{{mov{7,xr{13,tesub(xr){{load subscript value{26096
{{mov{7,xl{12,1(xs){{load input argument subscript val{26097
{{jsr{6,ident{{{compare them{26098
{{ppm{6,tfn08{{{jump if equal (ident){26099
*      here if no match with that teblk
{{mov{7,xl{8,wb{{restore teblk pointer{26103
{{mov{7,xr{13,tenxt(xl){{point to next teblk on chain{26104
{{bne{7,xr{9,(xs){6,tfn07{jump if there is one{26105
*      here if no match with any teblk on chain
{{mov{8,wc{19,*tenxt{{set offset to link field (xl base){26109
{{brn{6,tfn11{{{jump to merge{26110
{{ejc{{{{{26111
*      tfind (continued)
*      here we have found a matching element
{tfn08{mov{7,xl{8,wb{{restore teblk pointer{26117
{{mov{8,wa{19,*teval{{set teblk name offset{26118
{{mov{8,wb{12,2(xs){{restore name/value indicator{26119
{{bnz{8,wb{6,tfn09{{jump if called by name{26120
{{jsr{6,acess{{{else get value{26121
{{ppm{6,tfn12{{{jump if reference fails{26122
{{zer{8,wb{{{restore name/value indicator{26123
*      common exit for entry found
{tfn09{add{7,xs{19,*num03{{pop stack entries{26127
{{exi{{{{return to tfind caller{26128
*      here if no teblks on the hash chain
{tfn10{add{8,wc{19,*tbbuk{{get offset to bucket ptr{26132
{{mov{7,xl{9,(xs){{set tbblk ptr as base{26133
*      merge here with (xl,wc) base,offset of final link
{tfn11{mov{7,xr{9,(xs){{tbblk pointer{26137
{{mov{7,xr{13,tbinv(xr){{load default value in case{26138
{{mov{8,wb{12,2(xs){{load name/value indicator{26139
{{bze{8,wb{6,tfn09{{exit with default if value call{26140
{{mov{8,wb{7,xr{{copy default value{26141
*      here we must build a new teblk
{{mov{8,wa{19,*tesi_{{set size of teblk{26145
{{jsr{6,alloc{{{allocate teblk{26146
{{add{7,xl{8,wc{{point to hash link{26147
{{mov{9,(xl){7,xr{{link new teblk at end of chain{26148
{{mov{9,(xr){22,=b_tet{{store type word{26149
{{mov{13,teval(xr){8,wb{{set default as initial value{26150
{{mov{13,tenxt(xr){10,(xs)+{{set tbblk ptr to mark end of chain{26151
{{mov{13,tesub(xr){10,(xs)+{{store subscript value{26152
{{mov{8,wb{10,(xs)+{{restore name/value indicator{26153
{{mov{7,xl{7,xr{{copy teblk pointer (name base){26154
{{mov{8,wa{19,*teval{{set offset{26155
{{exi{{{{return to caller with new teblk{26156
*      acess fail return
{tfn12{exi{1,1{{{alternative return{26160
{{enp{{{{end procedure tfind{26161
{{ejc{{{{{26162
*      tmake -- make new table
*      (xl)                  initial lookup value
*      (wc)                  number of buckets desired
*      jsr  tmake            call to make new table
*      (xr)                  new table
*      (wa,wb)               destroyed
{tmake{prc{25,e{1,0{{{26172
{{mov{8,wa{8,wc{{copy number of headers{26173
{{add{8,wa{18,=tbsi_{{adjust for standard fields{26174
{{wtb{8,wa{{{convert length to bytes{26175
{{jsr{6,alloc{{{allocate space for tbblk{26176
{{mov{8,wb{7,xr{{copy pointer to tbblk{26177
{{mov{10,(xr)+{22,=b_tbt{{store type word{26178
{{zer{10,(xr)+{{{zero id for the moment{26179
{{mov{10,(xr)+{8,wa{{store length (tblen){26180
{{mov{10,(xr)+{7,xl{{store initial lookup value{26181
{{lct{8,wc{8,wc{{set loop counter (num headers){26182
*      loop to initialize all bucket pointers
{tma01{mov{10,(xr)+{8,wb{{store tbblk ptr in bucket header{26186
{{bct{8,wc{6,tma01{{loop till all stored{26187
{{mov{7,xr{8,wb{{recall pointer to tbblk{26188
{{exi{{{{{26189
{{enp{{{{{26190
{{ejc{{{{{26191
*      vmake -- create a vector
*      (wa)                  number of elements in vector
*      (xl)                  default value for vector elements
*      jsr  vmake            call to create vector
*      ppm  loc              if vector too large
*      (xr)                  pointer to vcblk
*      (wa,wb,wc,xl)         destroyed
{vmake{prc{25,e{1,1{{entry point{26203
{{lct{8,wb{8,wa{{copy elements for loop later on{26204
{{add{8,wa{18,=vcsi_{{add space for standard fields{26205
{{wtb{8,wa{{{convert length to bytes{26206
{{bgt{8,wa{3,mxlen{6,vmak2{fail if too large{26207
{{jsr{6,alloc{{{allocate space for vcblk{26208
{{mov{9,(xr){22,=b_vct{{store type word{26209
{{zer{13,idval(xr){{{initialize idval{26210
{{mov{13,vclen(xr){8,wa{{set length{26211
{{mov{8,wc{7,xl{{copy default value{26212
{{mov{7,xl{7,xr{{copy vcblk pointer{26213
{{add{7,xl{19,*vcvls{{point to first element value{26214
*      loop to set vector elements to default value
{vmak1{mov{10,(xl)+{8,wc{{store one value{26218
{{bct{8,wb{6,vmak1{{loop till all stored{26219
{{exi{{{{success return{26220
*      here if desired vector size too large
{vmak2{exi{1,1{{{fail return{26224
{{enp{{{{{26225
{{ejc{{{{{26226
*      scane -- scan an element
*      scane is called at compile time (by expan ,cmpil,cncrd)
*      to scan one element from the input image.
*      (scncc)               non-zero if called from cncrd
*      jsr  scane            call to scan element
*      (xr)                  result pointer (see below)
*      (xl)                  syntax type code (t_xxx)
*      the following global locations are used.
*      r_cim                 pointer to string block (scblk)
*                            for current input image.
*      r_cni                 pointer to next input image string
*                            pointer (zero if none).
*      r_scp                 save pointer (exit xr) from last
*                            call in case rescan is set.
*      scnbl                 this location is set non-zero on
*                            exit if scane scanned past blanks
*                            before locating the current element
*                            the end of a line counts as blanks.
*      scncc                 cncrd sets this non-zero to scan
*                            control card names and clears it
*                            on return
*      scnil                 length of current input image
*      scngo                 if set non-zero on entry, f and s
*                            are returned as separate syntax
*                            types (not letters) (goto pro-
*                            cessing). scngo is reset on exit.
*      scnpt                 offset to current loc in r_cim
*      scnrs                 if set non-zero on entry, scane
*                            returns the same result as on the
*                            last call (rescan). scnrs is reset
*                            on exit from any call to scane.
*      scntp                 save syntax type from last
*                            call (in case rescan is set).
{{ejc{{{{{26274
*      scane (continued)
*      element scanned       xl        xr
*      ---------------       --        --
*      control card name     0         pointer to scblk for name
*      unary operator        t_uop     ptr to operator dvblk
*      left paren            t_lpr     t_lpr
*      left bracket          t_lbr     t_lbr
*      comma                 t_cma     t_cma
*      function call         t_fnc     ptr to function vrblk
*      variable              t_var     ptr to vrblk
*      string constant       t_con     ptr to scblk
*      integer constant      t_con     ptr to icblk
*      real constant         t_con     ptr to rcblk
*      binary operator       t_bop     ptr to operator dvblk
*      right paren           t_rpr     t_rpr
*      right bracket         t_rbr     t_rbr
*      colon                 t_col     t_col
*      semi-colon            t_smc     t_smc
*      f (scngo ne 0)        t_fgo     t_fgo
*      s (scngo ne 0)        t_sgo     t_sgo
{{ejc{{{{{26319
*      scane (continued)
*      entry point
{scane{prc{25,e{1,0{{entry point{26325
{{zer{3,scnbl{{{reset blanks flag{26326
{{mov{3,scnsa{8,wa{{save wa{26327
{{mov{3,scnsb{8,wb{{save wb{26328
{{mov{3,scnsc{8,wc{{save wc{26329
{{bze{3,scnrs{6,scn03{{jump if no rescan{26330
*      here for rescan request
{{mov{7,xl{3,scntp{{set previous returned scan type{26334
{{mov{7,xr{3,r_scp{{set previous returned pointer{26335
{{zer{3,scnrs{{{reset rescan switch{26336
{{brn{6,scn13{{{jump to exit{26337
*      come here to read new image to test for continuation
{scn01{jsr{6,readr{{{read next image{26341
{{mov{8,wb{19,*dvubs{{set wb for not reading name{26342
{{bze{7,xr{6,scn30{{treat as semi-colon if none{26343
{{plc{7,xr{{{else point to first character{26344
{{lch{8,wc{9,(xr){{load first character{26345
{{beq{8,wc{18,=ch_dt{6,scn02{jump if dot for continuation{26346
{{bne{8,wc{18,=ch_pl{6,scn30{else treat as semicolon unless plus{26347
*      here for continuation line
{scn02{jsr{6,nexts{{{acquire next source image{26351
{{mov{3,scnpt{18,=num01{{set scan pointer past continuation{26352
{{mnz{3,scnbl{{{set blanks flag{26353
{{ejc{{{{{26354
*      scane (continued)
*      merge here to scan next element on current line
{scn03{mov{8,wa{3,scnpt{{load current offset{26360
{{beq{8,wa{3,scnil{6,scn01{check continuation if end{26361
{{mov{7,xl{3,r_cim{{point to current line{26362
{{plc{7,xl{8,wa{{point to current character{26363
{{mov{3,scnse{8,wa{{set start of element location{26364
{{mov{8,wc{21,=opdvs{{point to operator dv list{26365
{{mov{8,wb{19,*dvubs{{set constant for operator circuit{26366
{{brn{6,scn06{{{start scanning{26367
*      loop here to ignore leading blanks and tabs
{scn05{bze{8,wb{6,scn10{{jump if trailing{26371
{{icv{3,scnse{{{increment start of element{26372
{{beq{8,wa{3,scnil{6,scn01{jump if end of image{26373
{{mnz{3,scnbl{{{note blanks seen{26374
*      the following jump is used repeatedly for scanning out
*      the characters of a numeric constant or variable name.
*      the registers are used as follows.
*      (xr)                  scratch
*      (xl)                  ptr to next character
*      (wa)                  current scan offset
*      (wb)                  *dvubs (0 if scanning name,const)
*      (wc)                  =opdvs (0 if scanning constant)
{scn06{lch{7,xr{10,(xl)+{{get next character{26386
{{icv{8,wa{{{bump scan offset{26387
{{mov{3,scnpt{8,wa{{store offset past char scanned{26388
{{bsw{7,xr{2,cfp_u{6,scn07{switch on scanned character{26390
*      switch table for switch on character
{{ejc{{{{{26417
*      scane (continued)
{{ejc{{{{{26473
*      scane (continued)
{{iff{1,0{6,scn07{{{26506
{{iff{1,1{6,scn07{{{26506
{{iff{1,2{6,scn07{{{26506
{{iff{1,3{6,scn07{{{26506
{{iff{1,4{6,scn07{{{26506
{{iff{1,5{6,scn07{{{26506
{{iff{1,6{6,scn07{{{26506
{{iff{1,7{6,scn07{{{26506
{{iff{1,8{6,scn07{{{26506
{{iff{2,ch_ht{6,scn05{{horizontal tab{26506
{{iff{1,10{6,scn07{{{26506
{{iff{1,11{6,scn07{{{26506
{{iff{1,12{6,scn07{{{26506
{{iff{1,13{6,scn07{{{26506
{{iff{1,14{6,scn07{{{26506
{{iff{1,15{6,scn07{{{26506
{{iff{1,16{6,scn07{{{26506
{{iff{1,17{6,scn07{{{26506
{{iff{1,18{6,scn07{{{26506
{{iff{1,19{6,scn07{{{26506
{{iff{1,20{6,scn07{{{26506
{{iff{1,21{6,scn07{{{26506
{{iff{1,22{6,scn07{{{26506
{{iff{1,23{6,scn07{{{26506
{{iff{1,24{6,scn07{{{26506
{{iff{1,25{6,scn07{{{26506
{{iff{1,26{6,scn07{{{26506
{{iff{1,27{6,scn07{{{26506
{{iff{1,28{6,scn07{{{26506
{{iff{1,29{6,scn07{{{26506
{{iff{1,30{6,scn07{{{26506
{{iff{1,31{6,scn07{{{26506
{{iff{2,ch_bl{6,scn05{{blank{26506
{{iff{2,ch_ex{6,scn37{{exclamation mark{26506
{{iff{2,ch_dq{6,scn17{{double quote{26506
{{iff{2,ch_nm{6,scn41{{number sign{26506
{{iff{2,ch_dl{6,scn36{{dollar{26506
{{iff{1,37{6,scn07{{{26506
{{iff{2,ch_am{6,scn44{{ampersand{26506
{{iff{2,ch_sq{6,scn16{{single quote{26506
{{iff{2,ch_pp{6,scn25{{left paren{26506
{{iff{2,ch_rp{6,scn26{{right paren{26506
{{iff{2,ch_as{6,scn49{{asterisk{26506
{{iff{2,ch_pl{6,scn33{{plus{26506
{{iff{2,ch_cm{6,scn31{{comma{26506
{{iff{2,ch_mn{6,scn34{{minus{26506
{{iff{2,ch_dt{6,scn32{{dot{26506
{{iff{2,ch_sl{6,scn40{{slash{26506
{{iff{2,ch_d0{6,scn08{{digit 0{26506
{{iff{2,ch_d1{6,scn08{{digit 1{26506
{{iff{2,ch_d2{6,scn08{{digit 2{26506
{{iff{2,ch_d3{6,scn08{{digit 3{26506
{{iff{2,ch_d4{6,scn08{{digit 4{26506
{{iff{2,ch_d5{6,scn08{{digit 5{26506
{{iff{2,ch_d6{6,scn08{{digit 6{26506
{{iff{2,ch_d7{6,scn08{{digit 7{26506
{{iff{2,ch_d8{6,scn08{{digit 8{26506
{{iff{2,ch_d9{6,scn08{{digit 9{26506
{{iff{2,ch_cl{6,scn29{{colon{26506
{{iff{2,ch_sm{6,scn30{{semi-colon{26506
{{iff{2,ch_bb{6,scn28{{left bracket{26506
{{iff{2,ch_eq{6,scn46{{equal{26506
{{iff{2,ch_rb{6,scn27{{right bracket{26506
{{iff{2,ch_qu{6,scn45{{question mark{26506
{{iff{2,ch_at{6,scn42{{at{26506
{{iff{2,ch_ua{6,scn09{{shifted a{26506
{{iff{2,ch_ub{6,scn09{{shifted b{26506
{{iff{2,ch_uc{6,scn09{{shifted c{26506
{{iff{2,ch_ud{6,scn09{{shifted d{26506
{{iff{2,ch_ue{6,scn09{{shifted e{26506
{{iff{2,ch_uf{6,scn20{{shifted f{26506
{{iff{2,ch_ug{6,scn09{{shifted g{26506
{{iff{2,ch_uh{6,scn09{{shifted h{26506
{{iff{2,ch_ui{6,scn09{{shifted i{26506
{{iff{2,ch_uj{6,scn09{{shifted j{26506
{{iff{2,ch_uk{6,scn09{{shifted k{26506
{{iff{2,ch_ul{6,scn09{{shifted l{26506
{{iff{2,ch_um{6,scn09{{shifted m{26506
{{iff{2,ch_un{6,scn09{{shifted n{26506
{{iff{2,ch_uo{6,scn09{{shifted o{26506
{{iff{2,ch_up{6,scn09{{shifted p{26506
{{iff{2,ch_uq{6,scn09{{shifted q{26506
{{iff{2,ch_ur{6,scn09{{shifted r{26506
{{iff{2,ch_us{6,scn21{{shifted s{26506
{{iff{2,ch_ut{6,scn09{{shifted t{26506
{{iff{2,ch_uu{6,scn09{{shifted u{26506
{{iff{2,ch_uv{6,scn09{{shifted v{26506
{{iff{2,ch_uw{6,scn09{{shifted w{26506
{{iff{2,ch_ux{6,scn09{{shifted x{26506
{{iff{2,ch_uy{6,scn09{{shifted y{26506
{{iff{2,ch_uz{6,scn09{{shifted z{26506
{{iff{2,ch_ob{6,scn28{{left bracket{26506
{{iff{1,92{6,scn07{{{26506
{{iff{2,ch_cb{6,scn27{{right bracket{26506
{{iff{2,ch_pc{6,scn38{{percent{26506
{{iff{2,ch_u_{6,scn24{{underline{26506
{{iff{1,96{6,scn07{{{26506
{{iff{2,ch_la{6,scn09{{letter a{26506
{{iff{2,ch_lb{6,scn09{{letter b{26506
{{iff{2,ch_lc{6,scn09{{letter c{26506
{{iff{2,ch_ld{6,scn09{{letter d{26506
{{iff{2,ch_le{6,scn09{{letter e{26506
{{iff{2,ch_lf{6,scn20{{letter f{26506
{{iff{2,ch_lg{6,scn09{{letter g{26506
{{iff{2,ch_lh{6,scn09{{letter h{26506
{{iff{2,ch_li{6,scn09{{letter i{26506
{{iff{2,ch_lj{6,scn09{{letter j{26506
{{iff{2,ch_lk{6,scn09{{letter k{26506
{{iff{2,ch_ll{6,scn09{{letter l{26506
{{iff{2,ch_lm{6,scn09{{letter m{26506
{{iff{2,ch_ln{6,scn09{{letter n{26506
{{iff{2,ch_lo{6,scn09{{letter o{26506
{{iff{2,ch_lp{6,scn09{{letter p{26506
{{iff{2,ch_lq{6,scn09{{letter q{26506
{{iff{2,ch_lr{6,scn09{{letter r{26506
{{iff{2,ch_ls{6,scn21{{letter s{26506
{{iff{2,ch_lt{6,scn09{{letter t{26506
{{iff{2,ch_lu{6,scn09{{letter u{26506
{{iff{2,ch_lv{6,scn09{{letter v{26506
{{iff{2,ch_lw{6,scn09{{letter w{26506
{{iff{2,ch_lx{6,scn09{{letter x{26506
{{iff{2,ch_ly{6,scn09{{letter y{26506
{{iff{2,ch_l_{6,scn09{{letter z{26506
{{iff{1,123{6,scn07{{{26506
{{iff{2,ch_br{6,scn43{{vertical bar{26506
{{iff{1,125{6,scn07{{{26506
{{iff{2,ch_nt{6,scn35{{not{26506
{{iff{1,127{6,scn07{{{26506
{{esw{{{{end switch on character{26506
*      here for illegal character (underline merges)
{scn07{bze{8,wb{6,scn10{{jump if scanning name or constant{26510
{{erb{1,230{26,syntax error: illegal character{{{26511
{{ejc{{{{{26512
*      scane (continued)
*      here for digits 0-9
{scn08{bze{8,wb{6,scn09{{keep scanning if name/constant{26518
{{zer{8,wc{{{else set flag for scanning constant{26519
*      here for letter. loop here when scanning name/constant
{scn09{beq{8,wa{3,scnil{6,scn11{jump if end of image{26523
{{zer{8,wb{{{set flag for scanning name/const{26524
{{brn{6,scn06{{{merge back to continue scan{26525
*      come here for delimiter ending name or constant
{scn10{dcv{8,wa{{{reset offset to point to delimiter{26529
*      come here after finishing scan of name or constant
{scn11{mov{3,scnpt{8,wa{{store updated scan offset{26533
{{mov{8,wb{3,scnse{{point to start of element{26534
{{sub{8,wa{8,wb{{get number of characters{26535
{{mov{7,xl{3,r_cim{{point to line image{26536
{{bnz{8,wc{6,scn15{{jump if name{26537
*      here after scanning out numeric constant
{{jsr{6,sbstr{{{get string for constant{26541
{{mov{3,dnamp{7,xr{{delete from storage (not needed){26542
{{jsr{6,gtnum{{{convert to numeric{26543
{{ppm{6,scn14{{{jump if conversion failure{26544
*      merge here to exit with constant
{scn12{mov{7,xl{18,=t_con{{set result type of constant{26548
{{ejc{{{{{26549
*      scane (continued)
*      common exit point (xr,xl) set
{scn13{mov{8,wa{3,scnsa{{restore wa{26555
{{mov{8,wb{3,scnsb{{restore wb{26556
{{mov{8,wc{3,scnsc{{restore wc{26557
{{mov{3,r_scp{7,xr{{save xr in case rescan{26558
{{mov{3,scntp{7,xl{{save xl in case rescan{26559
{{zer{3,scngo{{{reset possible goto flag{26560
{{exi{{{{return to scane caller{26561
*      here if conversion error on numeric item
{scn14{erb{1,231{26,syntax error: invalid numeric item{{{26565
*      here after scanning out variable name
{scn15{jsr{6,sbstr{{{build string name of variable{26569
{{bnz{3,scncc{6,scn13{{return if cncrd call{26570
{{jsr{6,gtnvr{{{locate/build vrblk{26571
{{ppm{{{{dummy (unused) error return{26572
{{mov{7,xl{18,=t_var{{set type as variable{26573
{{brn{6,scn13{{{back to exit{26574
*      here for single quote (start of string constant)
{scn16{bze{8,wb{6,scn10{{terminator if scanning name or cnst{26578
{{mov{8,wb{18,=ch_sq{{set terminator as single quote{26579
{{brn{6,scn18{{{merge{26580
*      here for double quote (start of string constant)
{scn17{bze{8,wb{6,scn10{{terminator if scanning name or cnst{26584
{{mov{8,wb{18,=ch_dq{{set double quote terminator, merge{26585
*      loop to scan out string constant
{scn18{beq{8,wa{3,scnil{6,scn19{error if end of image{26589
{{lch{8,wc{10,(xl)+{{else load next character{26590
{{icv{8,wa{{{bump offset{26591
{{bne{8,wc{8,wb{6,scn18{loop back if not terminator{26592
{{ejc{{{{{26593
*      scane (continued)
*      here after scanning out string constant
{{mov{8,wb{3,scnpt{{point to first character{26599
{{mov{3,scnpt{8,wa{{save offset past final quote{26600
{{dcv{8,wa{{{point back past last character{26601
{{sub{8,wa{8,wb{{get number of characters{26602
{{mov{7,xl{3,r_cim{{point to input image{26603
{{jsr{6,sbstr{{{build substring value{26604
{{brn{6,scn12{{{back to exit with constant result{26605
*      here if no matching quote found
{scn19{mov{3,scnpt{8,wa{{set updated scan pointer{26609
{{erb{1,232{26,syntax error: unmatched string quote{{{26610
*      here for f (possible failure goto)
{scn20{mov{7,xr{18,=t_fgo{{set return code for fail goto{26614
{{brn{6,scn22{{{jump to merge{26615
*      here for s (possible success goto)
{scn21{mov{7,xr{18,=t_sgo{{set success goto as return code{26619
*      special goto cases merge here
{scn22{bze{3,scngo{6,scn09{{treat as normal letter if not goto{26623
*      merge here for special character exit
{scn23{bze{8,wb{6,scn10{{jump if end of name/constant{26627
{{mov{7,xl{7,xr{{else copy code{26628
{{brn{6,scn13{{{and jump to exit{26629
*      here for underline
{scn24{bze{8,wb{6,scn09{{part of name if scanning name{26633
{{brn{6,scn07{{{else illegal{26634
{{ejc{{{{{26635
*      scane (continued)
*      here for left paren
{scn25{mov{7,xr{18,=t_lpr{{set left paren return code{26641
{{bnz{8,wb{6,scn23{{return left paren unless name{26642
{{bze{8,wc{6,scn10{{delimiter if scanning constant{26643
*      here for left paren after name (function call)
{{mov{8,wb{3,scnse{{point to start of name{26647
{{mov{3,scnpt{8,wa{{set pointer past left paren{26648
{{dcv{8,wa{{{point back past last char of name{26649
{{sub{8,wa{8,wb{{get name length{26650
{{mov{7,xl{3,r_cim{{point to input image{26651
{{jsr{6,sbstr{{{get string name for function{26652
{{jsr{6,gtnvr{{{locate/build vrblk{26653
{{ppm{{{{dummy (unused) error return{26654
{{mov{7,xl{18,=t_fnc{{set code for function call{26655
{{brn{6,scn13{{{back to exit{26656
*      processing for special characters
{scn26{mov{7,xr{18,=t_rpr{{right paren, set code{26660
{{brn{6,scn23{{{take special character exit{26661
{scn27{mov{7,xr{18,=t_rbr{{right bracket, set code{26663
{{brn{6,scn23{{{take special character exit{26664
{scn28{mov{7,xr{18,=t_lbr{{left bracket, set code{26666
{{brn{6,scn23{{{take special character exit{26667
{scn29{mov{7,xr{18,=t_col{{colon, set code{26669
{{brn{6,scn23{{{take special character exit{26670
{scn30{mov{7,xr{18,=t_smc{{semi-colon, set code{26672
{{brn{6,scn23{{{take special character exit{26673
{scn31{mov{7,xr{18,=t_cma{{comma, set code{26675
{{brn{6,scn23{{{take special character exit{26676
{{ejc{{{{{26677
*      scane (continued)
*      here for operators. on entry, wc points to the table of
*      operator dope vectors and wb is the increment to step
*      to the next pair (binary/unary) of dope vectors in the
*      list. on reaching scn46, the pointer has been adjusted to
*      point to the appropriate pair of dope vectors.
*      the first three entries are special since they can occur
*      as part of a variable name (.) or constant (.+-).
{scn32{bze{8,wb{6,scn09{{dot can be part of name or constant{26689
{{add{8,wc{8,wb{{else bump pointer{26690
{scn33{bze{8,wc{6,scn09{{plus can be part of constant{26692
{{bze{8,wb{6,scn48{{plus cannot be part of name{26693
{{add{8,wc{8,wb{{else bump pointer{26694
{scn34{bze{8,wc{6,scn09{{minus can be part of constant{26696
{{bze{8,wb{6,scn48{{minus cannot be part of name{26697
{{add{8,wc{8,wb{{else bump pointer{26698
{scn35{add{8,wc{8,wb{{not{26700
{scn36{add{8,wc{8,wb{{dollar{26701
{scn37{add{8,wc{8,wb{{exclamation{26702
{scn38{add{8,wc{8,wb{{percent{26703
{scn39{add{8,wc{8,wb{{asterisk{26704
{scn40{add{8,wc{8,wb{{slash{26705
{scn41{add{8,wc{8,wb{{number sign{26706
{scn42{add{8,wc{8,wb{{at sign{26707
{scn43{add{8,wc{8,wb{{vertical bar{26708
{scn44{add{8,wc{8,wb{{ampersand{26709
{scn45{add{8,wc{8,wb{{question mark{26710
*      all operators come here (equal merges directly)
*      (wc) points to the binary/unary pair of operator dvblks.
{scn46{bze{8,wb{6,scn10{{operator terminates name/constant{26715
{{mov{7,xr{8,wc{{else copy dv pointer{26716
{{lch{8,wc{9,(xl){{load next character{26717
{{mov{7,xl{18,=t_bop{{set binary op in case{26718
{{beq{8,wa{3,scnil{6,scn47{should be binary if image end{26719
{{beq{8,wc{18,=ch_bl{6,scn47{should be binary if followed by blk{26720
{{beq{8,wc{18,=ch_ht{6,scn47{jump if horizontal tab{26722
{{beq{8,wc{18,=ch_sm{6,scn47{semicolon can immediately follow ={26727
{{beq{8,wc{18,=ch_cl{6,scn47{colon can immediately follow ={26728
{{beq{8,wc{18,=ch_rp{6,scn47{right paren can immediately follow ={26729
{{beq{8,wc{18,=ch_rb{6,scn47{right bracket can immediately follow ={26730
{{beq{8,wc{18,=ch_cb{6,scn47{right bracket can immediately follow ={26731
*      here for unary operator
{{add{7,xr{19,*dvbs_{{point to dv for unary op{26735
{{mov{7,xl{18,=t_uop{{set type for unary operator{26736
{{ble{3,scntp{18,=t_uok{6,scn13{ok unary if ok preceding element{26737
{{ejc{{{{{26738
*      scane (continued)
*      merge here to require preceding blanks
{scn47{bnz{3,scnbl{6,scn13{{all ok if preceding blanks, exit{26744
*      fail operator in this position
{scn48{erb{1,233{26,syntax error: invalid use of operator{{{26748
*      here for asterisk, could be ** substitute for exclamation
{scn49{bze{8,wb{6,scn10{{end of name if scanning name{26752
{{beq{8,wa{3,scnil{6,scn39{not ** if * at image end{26753
{{mov{7,xr{8,wa{{else save offset past first *{26754
{{mov{3,scnof{8,wa{{save another copy{26755
{{lch{8,wa{10,(xl)+{{load next character{26756
{{bne{8,wa{18,=ch_as{6,scn50{not ** if next char not *{26757
{{icv{7,xr{{{else step offset past second *{26758
{{beq{7,xr{3,scnil{6,scn51{ok exclam if end of image{26759
{{lch{8,wa{9,(xl){{else load next character{26760
{{beq{8,wa{18,=ch_bl{6,scn51{exclamation if blank{26761
{{beq{8,wa{18,=ch_ht{6,scn51{exclamation if horizontal tab{26763
*      unary *
{scn50{mov{8,wa{3,scnof{{recover stored offset{26771
{{mov{7,xl{3,r_cim{{point to line again{26772
{{plc{7,xl{8,wa{{point to current char{26773
{{brn{6,scn39{{{merge with unary *{26774
*      here for ** as substitute for exclamation
{scn51{mov{3,scnpt{7,xr{{save scan pointer past 2nd *{26778
{{mov{8,wa{7,xr{{copy scan pointer{26779
{{brn{6,scn37{{{merge with exclamation{26780
{{enp{{{{end procedure scane{26781
{{ejc{{{{{26782
*      scngf -- scan goto field
*      scngf is called from cmpil to scan and analyze a goto
*      field including the surrounding brackets or parentheses.
*      for a normal goto, the result returned is either a vrblk
*      pointer for a simple label operand, or a pointer to an
*      expression tree with a special outer unary operator
*      (o_goc). for a direct goto, the result returned is a
*      pointer to an expression tree with the special outer
*      unary operator o_god.
*      jsr  scngf            call to scan goto field
*      (xr)                  result (see above)
*      (xl,wa,wb,wc)         destroyed
{scngf{prc{25,e{1,0{{entry point{26799
{{jsr{6,scane{{{scan initial element{26800
{{beq{7,xl{18,=t_lpr{6,scng1{skip if left paren (normal goto){26801
{{beq{7,xl{18,=t_lbr{6,scng2{skip if left bracket (direct goto){26802
{{erb{1,234{26,syntax error: goto field incorrect{{{26803
*      here for left paren (normal goto)
{scng1{mov{8,wb{18,=num01{{set expan flag for normal goto{26807
{{jsr{6,expan{{{analyze goto field{26808
{{mov{8,wa{21,=opdvn{{point to opdv for complex goto{26809
{{ble{7,xr{3,statb{6,scng3{jump if not in static (sgd15){26810
{{blo{7,xr{3,state{6,scng4{jump to exit if simple label name{26811
{{brn{6,scng3{{{complex goto - merge{26812
*      here for left bracket (direct goto)
{scng2{mov{8,wb{18,=num02{{set expan flag for direct goto{26816
{{jsr{6,expan{{{scan goto field{26817
{{mov{8,wa{21,=opdvd{{set opdv pointer for direct goto{26818
{{ejc{{{{{26819
*      scngf (continued)
*      merge here to build outer unary operator block
{scng3{mov{11,-(xs){8,wa{{stack operator dv pointer{26825
{{mov{11,-(xs){7,xr{{stack pointer to expression tree{26826
{{jsr{6,expop{{{pop operator off{26827
{{mov{7,xr{10,(xs)+{{reload new expression tree pointer{26828
*      common exit point
{scng4{exi{{{{return to caller{26832
{{enp{{{{end procedure scngf{26833
{{ejc{{{{{26834
*      setvr -- set vrget,vrsto fields of vrblk
*      setvr sets the proper values in the vrget and vrsto
*      fields of a vrblk. it is called whenever trblks are
*      added or subtracted (trace,stoptr,input,output,detach)
*      (xr)                  pointer to vrblk
*      jsr  setvr            call to set fields
*      (xl,wa)               destroyed
*      note that setvr ignores the call if xr does not point
*      into the static region (i.e. is some other name base)
{setvr{prc{25,e{1,0{{entry point{26849
{{bhi{7,xr{3,state{6,setv1{exit if not natural variable{26850
*      here if we have a vrblk
{{mov{7,xl{7,xr{{copy vrblk pointer{26854
{{mov{13,vrget(xr){22,=b_vrl{{store normal get value{26855
{{beq{13,vrsto(xr){22,=b_vre{6,setv1{skip if protected variable{26856
{{mov{13,vrsto(xr){22,=b_vrs{{store normal store value{26857
{{mov{7,xl{13,vrval(xl){{point to next entry on chain{26858
{{bne{9,(xl){22,=b_trt{6,setv1{jump if end of trblk chain{26859
{{mov{13,vrget(xr){22,=b_vra{{store trapped routine address{26860
{{mov{13,vrsto(xr){22,=b_vrv{{set trapped routine address{26861
*      merge here to exit to caller
{setv1{exi{{{{return to setvr caller{26865
{{enp{{{{end procedure setvr{26866
{{ejc{{{{{26869
*      sorta -- sort array
*      routine to sort an array or table on same basis as in
*      sitbol. a table is converted to an array, leaving two
*      dimensional arrays and vectors as cases to be considered.
*      whole rows of arrays are permuted according to the
*      ordering of the keys they contain, and the stride
*      referred to, is the the length of a row. it is one
*      for a vector.
*      the sort used is heapsort, fundamentals of data structure
*      horowitz and sahni, pitman 1977, page 347.
*      it is an order n*log(n) algorithm. in order
*      to make it stable, comparands may not compare equal. this
*      is achieved by sorting a copy array (referred to as the
*      sort array) containing at its high address end, byte
*      offsets to the rows to be sorted held in the original
*      array (referred to as the key array). sortc, the
*      comparison routine, accesses the keys through these
*      offsets and in the case of equality, resolves it by
*      comparing the offsets themselves. the sort permutes the
*      offsets which are then used in a final operation to copy
*      the actual items into the new array in sorted order.
*      references to zeroth item are to notional item
*      preceding first actual item.
*      reverse sorting for rsort is done by having the less than
*      test for keys effectively be replaced by a
*      greater than test.
*      1(xs)                 first arg - array or table
*      0(xs)                 2nd arg - index or pdtype name
*      (wa)                  0 , non-zero for sort , rsort
*      jsr  sorta            call to sort array
*      ppm  loc              transfer loc if table is empty
*      (xr)                  sorted array
*      (xl,wa,wb,wc)         destroyed
{{ejc{{{{{26906
*      sorta (continued)
{sorta{prc{25,n{1,1{{entry point{26910
{{mov{3,srtsr{8,wa{{sort/rsort indicator{26911
{{mov{3,srtst{19,*num01{{default stride of 1{26912
{{zer{3,srtof{{{default zero offset to sort key{26913
{{mov{3,srtdf{21,=nulls{{clear datatype field name{26914
{{mov{3,r_sxr{10,(xs)+{{unstack argument 2{26915
{{mov{7,xr{10,(xs)+{{get first argument{26916
{{mnz{8,wa{{{use key/values of table entries{26917
{{jsr{6,gtarr{{{convert to array{26918
{{ppm{6,srt18{{{signal that table is empty{26919
{{ppm{6,srt16{{{error if non-convertable{26920
{{mov{11,-(xs){7,xr{{stack ptr to resulting key array{26921
{{mov{11,-(xs){7,xr{{another copy for copyb{26922
{{jsr{6,copyb{{{get copy array for sorting into{26923
{{ppm{{{{cant fail{26924
{{mov{11,-(xs){7,xr{{stack pointer to sort array{26925
{{mov{7,xr{3,r_sxr{{get second arg{26926
{{mov{7,xl{13,num01(xs){{get ptr to key array{26927
{{bne{9,(xl){22,=b_vct{6,srt02{jump if arblk{26928
{{beq{7,xr{21,=nulls{6,srt01{jump if null second arg{26929
{{jsr{6,gtnvr{{{get vrblk ptr for it{26930
{{err{1,257{26,erroneous 2nd arg in sort/rsort of vector{{{26931
{{mov{3,srtdf{7,xr{{store datatype field name vrblk{26932
*      compute n and offset to item a(0) in vector case
{srt01{mov{8,wc{19,*vclen{{offset to a(0){26936
{{mov{8,wb{19,*vcvls{{offset to first item{26937
{{mov{8,wa{13,vclen(xl){{get block length{26938
{{sub{8,wa{19,*vcsi_{{get no. of entries, n (in bytes){26939
{{brn{6,srt04{{{merge{26940
*      here for array
{srt02{ldi{13,ardim(xl){{{get possible dimension{26944
{{mfi{8,wa{{{convert to short integer{26945
{{wtb{8,wa{{{further convert to baus{26946
{{mov{8,wb{19,*arvls{{offset to first value if one{26947
{{mov{8,wc{19,*arpro{{offset before values if one dim.{26948
{{beq{13,arndm(xl){18,=num01{6,srt04{jump in fact if one dim.{26949
{{bne{13,arndm(xl){18,=num02{6,srt16{fail unless two dimens{26950
{{ldi{13,arlb2(xl){{{get lower bound 2 as default{26951
{{beq{7,xr{21,=nulls{6,srt03{jump if default second arg{26952
{{jsr{6,gtint{{{convert to integer{26953
{{ppm{6,srt17{{{fail{26954
{{ldi{13,icval(xr){{{get actual integer value{26955
{{ejc{{{{{26956
*      sorta (continued)
*      here with sort column index in ia in array case
{srt03{sbi{13,arlb2(xl){{{subtract low bound{26962
{{iov{6,srt17{{{fail if overflow{26963
{{ilt{6,srt17{{{fail if below low bound{26964
{{sbi{13,ardm2(xl){{{check against dimension{26965
{{ige{6,srt17{{{fail if too large{26966
{{adi{13,ardm2(xl){{{restore value{26967
{{mfi{8,wa{{{get as small integer{26968
{{wtb{8,wa{{{offset within row to key{26969
{{mov{3,srtof{8,wa{{keep offset{26970
{{ldi{13,ardm2(xl){{{second dimension is row length{26971
{{mfi{8,wa{{{convert to short integer{26972
{{mov{7,xr{8,wa{{copy row length{26973
{{wtb{8,wa{{{convert to bytes{26974
{{mov{3,srtst{8,wa{{store as stride{26975
{{ldi{13,ardim(xl){{{get number of rows{26976
{{mfi{8,wa{{{as a short integer{26977
{{wtb{8,wa{{{convert n to baus{26978
{{mov{8,wc{13,arlen(xl){{offset past array end{26979
{{sub{8,wc{8,wa{{adjust, giving space for n offsets{26980
{{dca{8,wc{{{point to a(0){26981
{{mov{8,wb{13,arofs(xl){{offset to word before first item{26982
{{ica{8,wb{{{offset to first item{26983
*      separate pre-processing for arrays and vectors done.
*      to simplify later key comparisons, removal of any trblk
*      trap blocks from entries in key array is effected.
*      (xl) = 1(xs) = pointer to key array
*      (xs) = pointer to sort array
*      wa = number of items, n (converted to bytes).
*      wb = offset to first item of arrays.
*      wc = offset to a(0)
{srt04{ble{8,wa{19,*num01{6,srt15{return if only a single item{26995
{{mov{3,srtsn{8,wa{{store number of items (in baus){26996
{{mov{3,srtso{8,wc{{store offset to a(0){26997
{{mov{8,wc{13,arlen(xl){{length of array or vec (=vclen){26998
{{add{8,wc{7,xl{{point past end of array or vector{26999
{{mov{3,srtsf{8,wb{{store offset to first row{27000
{{add{7,xl{8,wb{{point to first item in key array{27001
*      loop through array
{srt05{mov{7,xr{9,(xl){{get an entry{27005
*      hunt along trblk chain
{srt06{bne{9,(xr){22,=b_trt{6,srt07{jump out if not trblk{27009
{{mov{7,xr{13,trval(xr){{get value field{27010
{{brn{6,srt06{{{loop{27011
{{ejc{{{{{27012
*      sorta (continued)
*      xr is value from end of chain
{srt07{mov{10,(xl)+{7,xr{{store as array entry{27018
{{blt{7,xl{8,wc{6,srt05{loop if not done{27019
{{mov{7,xl{9,(xs){{get adrs of sort array{27020
{{mov{7,xr{3,srtsf{{initial offset to first key{27021
{{mov{8,wb{3,srtst{{get stride{27022
{{add{7,xl{3,srtso{{offset to a(0){27023
{{ica{7,xl{{{point to a(1){27024
{{mov{8,wc{3,srtsn{{get n{27025
{{btw{8,wc{{{convert from bytes{27026
{{mov{3,srtnr{8,wc{{store as row count{27027
{{lct{8,wc{8,wc{{loop counter{27028
*      store key offsets at top of sort array
{srt08{mov{10,(xl)+{7,xr{{store an offset{27032
{{add{7,xr{8,wb{{bump offset by stride{27033
{{bct{8,wc{6,srt08{{loop through rows{27034
*      perform the sort on offsets in sort array.
*      (srtsn)               number of items to sort, n (bytes)
*      (srtso)               offset to a(0)
{srt09{mov{8,wa{3,srtsn{{get n{27041
{{mov{8,wc{3,srtnr{{get number of rows{27042
{{rsh{8,wc{1,1{{i = n / 2 (wc=i, index into array){27043
{{wtb{8,wc{{{convert back to bytes{27044
*      loop to form initial heap
{srt10{jsr{6,sorth{{{sorth(i,n){27048
{{dca{8,wc{{{i = i - 1{27049
{{bnz{8,wc{6,srt10{{loop if i gt 0{27050
{{mov{8,wc{8,wa{{i = n{27051
*      sorting loop. at this point, a(1) is the largest
*      item, since algorithm initialises it as, and then maintains
*      it as, root of tree.
{srt11{dca{8,wc{{{i = i - 1 (n - 1 initially){27057
{{bze{8,wc{6,srt12{{jump if done{27058
{{mov{7,xr{9,(xs){{get sort array address{27059
{{add{7,xr{3,srtso{{point to a(0){27060
{{mov{7,xl{7,xr{{a(0) address{27061
{{add{7,xl{8,wc{{a(i) address{27062
{{mov{8,wb{13,num01(xl){{copy a(i+1){27063
{{mov{13,num01(xl){13,num01(xr){{move a(1) to a(i+1){27064
{{mov{13,num01(xr){8,wb{{complete exchange of a(1), a(i+1){27065
{{mov{8,wa{8,wc{{n = i for sorth{27066
{{mov{8,wc{19,*num01{{i = 1 for sorth{27067
{{jsr{6,sorth{{{sorth(1,n){27068
{{mov{8,wc{8,wa{{restore wc{27069
{{brn{6,srt11{{{loop{27070
{{ejc{{{{{27071
*      sorta (continued)
*      offsets have been permuted into required order by sort.
*      copy array elements over them.
{srt12{mov{7,xr{9,(xs){{base adrs of key array{27078
{{mov{8,wc{7,xr{{copy it{27079
{{add{8,wc{3,srtso{{offset of a(0){27080
{{add{7,xr{3,srtsf{{adrs of first row of sort array{27081
{{mov{8,wb{3,srtst{{get stride{27082
*      copying loop for successive items. sorted offsets are
*      held at end of sort array.
{srt13{ica{8,wc{{{adrs of next of sorted offsets{27087
{{mov{7,xl{8,wc{{copy it for access{27088
{{mov{7,xl{9,(xl){{get offset{27089
{{add{7,xl{13,num01(xs){{add key array base adrs{27090
{{mov{8,wa{8,wb{{get count of characters in row{27091
{{mvw{{{{copy a complete row{27092
{{dcv{3,srtnr{{{decrement row count{27093
{{bnz{3,srtnr{6,srt13{{repeat till all rows done{27094
*      return point
{srt15{mov{7,xr{10,(xs)+{{pop result array ptr{27098
{{ica{7,xs{{{pop key array ptr{27099
{{zer{3,r_sxl{{{clear junk{27100
{{zer{3,r_sxr{{{clear junk{27101
{{exi{{{{return{27102
*      error point
{srt16{erb{1,256{26,sort/rsort 1st arg not suitable array or table{{{27106
{srt17{erb{1,258{26,sort/rsort 2nd arg out of range or non-integer{{{27107
*      return point if input table is empty
{srt18{exi{1,1{{{return indication of null table{27111
{{enp{{{{end procudure sorta{27112
{{ejc{{{{{27113
*      sortc --  compare sort keys
*      compare two sort keys given their offsets. if
*      equal, compare key offsets to give stable sort.
*      note that if srtsr is non-zero (request for reverse
*      sort), the quoted returns are inverted.
*      for objects of differing datatypes, the entry point
*      identifications are compared.
*      (xl)                  base adrs for keys
*      (wa)                  offset to key 1 item
*      (wb)                  offset to key 2 item
*      (srtsr)               zero/non-zero for sort/rsort
*      (srtof)               offset within row to comparands
*      jsr  sortc            call to compare keys
*      ppm  loc              key1 less than key2
*                            normal return, key1 gt than key2
*      (xl,xr,wa,wb)         destroyed
{sortc{prc{25,e{1,1{{entry point{27134
{{mov{3,srts1{8,wa{{save offset 1{27135
{{mov{3,srts2{8,wb{{save offset 2{27136
{{mov{3,srtsc{8,wc{{save wc{27137
{{add{7,xl{3,srtof{{add offset to comparand field{27138
{{mov{7,xr{7,xl{{copy base + offset{27139
{{add{7,xl{8,wa{{add key1 offset{27140
{{add{7,xr{8,wb{{add key2 offset{27141
{{mov{7,xl{9,(xl){{get key1{27142
{{mov{7,xr{9,(xr){{get key2{27143
{{bne{3,srtdf{21,=nulls{6,src12{jump if datatype field name used{27144
{{ejc{{{{{27145
*      sortc (continued)
*      merge after dealing with field name. try for strings.
{src01{mov{8,wc{9,(xl){{get type code{27151
{{bne{8,wc{9,(xr){6,src02{skip if not same datatype{27152
{{beq{8,wc{22,=b_scl{6,src09{jump if both strings{27153
{{beq{8,wc{22,=b_icl{6,src14{jump if both integers{27154
*      datatypes different.  now try for numeric
{src02{mov{3,r_sxl{7,xl{{keep arg1{27162
{{mov{3,r_sxr{7,xr{{keep arg2{27163
{{beq{8,wc{22,=b_scl{6,src11{do not allow conversion to number{27166
{{beq{9,(xr){22,=b_scl{6,src11{if either arg is a string{27167
{src14{mov{11,-(xs){7,xl{{stack{27210
{{mov{11,-(xs){7,xr{{args{27211
{{jsr{6,acomp{{{compare objects{27212
{{ppm{6,src10{{{not numeric{27213
{{ppm{6,src10{{{not numeric{27214
{{ppm{6,src03{{{key1 less{27215
{{ppm{6,src08{{{keys equal{27216
{{ppm{6,src05{{{key1 greater{27217
*      return if key1 smaller (sort), greater (rsort)
{src03{bnz{3,srtsr{6,src06{{jump if rsort{27221
{src04{mov{8,wc{3,srtsc{{restore wc{27223
{{exi{1,1{{{return{27224
*      return if key1 greater (sort), smaller (rsort)
{src05{bnz{3,srtsr{6,src04{{jump if rsort{27228
{src06{mov{8,wc{3,srtsc{{restore wc{27230
{{exi{{{{return{27231
*      keys are of same datatype
{src07{blt{7,xl{7,xr{6,src03{item first created is less{27235
{{bgt{7,xl{7,xr{6,src05{addresses rise in order of creation{27236
*      drop through or merge for identical or equal objects
{src08{blt{3,srts1{3,srts2{6,src04{test offsets or key addrss instead{27240
{{brn{6,src06{{{offset 1 greater{27241
{{ejc{{{{{27242
*      sortc (continued)
*      strings
{src09{mov{11,-(xs){7,xl{{stack{27252
{{mov{11,-(xs){7,xr{{args{27253
{{jsr{6,lcomp{{{compare objects{27254
{{ppm{{{{cant{27255
{{ppm{{{{fail{27256
{{ppm{6,src03{{{key1 less{27257
{{ppm{6,src08{{{keys equal{27258
{{ppm{6,src05{{{key1 greater{27259
*      arithmetic comparison failed - recover args
{src10{mov{7,xl{3,r_sxl{{get arg1{27263
{{mov{7,xr{3,r_sxr{{get arg2{27264
{{mov{8,wc{9,(xl){{get type of key1{27265
{{beq{8,wc{9,(xr){6,src07{jump if keys of same type{27266
*      here to compare datatype ids
{src11{mov{7,xl{8,wc{{get block type word{27270
{{mov{7,xr{9,(xr){{get block type word{27271
{{lei{7,xl{{{entry point id for key1{27272
{{lei{7,xr{{{entry point id for key2{27273
{{bgt{7,xl{7,xr{6,src05{jump if key1 gt key2{27274
{{brn{6,src03{{{key1 lt key2{27275
*      datatype field name used
{src12{jsr{6,sortf{{{call routine to find field 1{27279
{{mov{11,-(xs){7,xl{{stack item pointer{27280
{{mov{7,xl{7,xr{{get key2{27281
{{jsr{6,sortf{{{find field 2{27282
{{mov{7,xr{7,xl{{place as key2{27283
{{mov{7,xl{10,(xs)+{{recover key1{27284
{{brn{6,src01{{{merge{27285
{{enp{{{{procedure sortc{27286
{{ejc{{{{{27287
*      sortf -- find field for sortc
*      routine used by sortc to obtain item corresponding
*      to a given field name, if this exists, in a programmer
*      defined object passed as argument.
*      if such a match occurs, record is kept of datatype
*      name, field name and offset to field in order to
*      short-circuit later searches on same type. note that
*      dfblks are stored in static and hence cannot be moved.
*      (srtdf)               vrblk pointer of field name
*      (xl)                  possible pdblk pointer
*      jsr  sortf            call to search for field name
*      (xl)                  item found or original pdblk ptr
*      (wc)                  destroyed
{sortf{prc{25,e{1,0{{entry point{27305
{{bne{9,(xl){22,=b_pdt{6,srtf3{return if not pdblk{27306
{{mov{11,-(xs){7,xr{{keep xr{27307
{{mov{7,xr{3,srtfd{{get possible former dfblk ptr{27308
{{bze{7,xr{6,srtf4{{jump if not{27309
{{bne{7,xr{13,pddfp(xl){6,srtf4{jump if not right datatype{27310
{{bne{3,srtdf{3,srtff{6,srtf4{jump if not right field name{27311
{{add{7,xl{3,srtfo{{add offset to required field{27312
*      here with xl pointing to found field
{srtf1{mov{7,xl{9,(xl){{get item from field{27316
*      return point
{srtf2{mov{7,xr{10,(xs)+{{restore xr{27320
{srtf3{exi{{{{return{27322
{{ejc{{{{{27323
*      sortf (continued)
*      conduct a search
{srtf4{mov{7,xr{7,xl{{copy original pointer{27329
{{mov{7,xr{13,pddfp(xr){{point to dfblk{27330
{{mov{3,srtfd{7,xr{{keep a copy{27331
{{mov{8,wc{13,fargs(xr){{get number of fields{27332
{{wtb{8,wc{{{convert to bytes{27333
{{add{7,xr{13,dflen(xr){{point past last field{27334
*      loop to find name in pdfblk
{srtf5{dca{8,wc{{{count down{27338
{{dca{7,xr{{{point in front{27339
{{beq{9,(xr){3,srtdf{6,srtf6{skip out if found{27340
{{bnz{8,wc{6,srtf5{{loop{27341
{{brn{6,srtf2{{{return - not found{27342
*      found
{srtf6{mov{3,srtff{9,(xr){{keep field name ptr{27346
{{add{8,wc{19,*pdfld{{add offset to first field{27347
{{mov{3,srtfo{8,wc{{store as field offset{27348
{{add{7,xl{8,wc{{point to field{27349
{{brn{6,srtf1{{{return{27350
{{enp{{{{procedure sortf{27351
{{ejc{{{{{27352
*      sorth -- heap routine for sorta
*      this routine constructs a heap from elements of array, a.
*      in this application, the elements are offsets to keys in
*      a key array.
*      (xs)                  pointer to sort array base
*      1(xs)                 pointer to key array base
*      (wa)                  max array index, n (in bytes)
*      (wc)                  offset j in a to root (in *1 to *n)
*      jsr  sorth            call sorth(j,n) to make heap
*      (xl,xr,wb)            destroyed
{sorth{prc{25,n{1,0{{entry point{27367
{{mov{3,srtsn{8,wa{{save n{27368
{{mov{3,srtwc{8,wc{{keep wc{27369
{{mov{7,xl{9,(xs){{sort array base adrs{27370
{{add{7,xl{3,srtso{{add offset to a(0){27371
{{add{7,xl{8,wc{{point to a(j){27372
{{mov{3,srtrt{9,(xl){{get offset to root{27373
{{add{8,wc{8,wc{{double j - cant exceed n{27374
*      loop to move down tree using doubled index j
{srh01{bgt{8,wc{3,srtsn{6,srh03{done if j gt n{27378
{{beq{8,wc{3,srtsn{6,srh02{skip if j equals n{27379
{{mov{7,xr{9,(xs){{sort array base adrs{27380
{{mov{7,xl{13,num01(xs){{key array base adrs{27381
{{add{7,xr{3,srtso{{point to a(0){27382
{{add{7,xr{8,wc{{adrs of a(j){27383
{{mov{8,wa{13,num01(xr){{get a(j+1){27384
{{mov{8,wb{9,(xr){{get a(j){27385
*      compare sons. (wa) right son, (wb) left son
{{jsr{6,sortc{{{compare keys - lt(a(j+1),a(j)){27389
{{ppm{6,srh02{{{a(j+1) lt a(j){27390
{{ica{8,wc{{{point to greater son, a(j+1){27391
{{ejc{{{{{27392
*      sorth (continued)
*      compare root with greater son
{srh02{mov{7,xl{13,num01(xs){{key array base adrs{27398
{{mov{7,xr{9,(xs){{get sort array address{27399
{{add{7,xr{3,srtso{{adrs of a(0){27400
{{mov{8,wb{7,xr{{copy this adrs{27401
{{add{7,xr{8,wc{{adrs of greater son, a(j){27402
{{mov{8,wa{9,(xr){{get a(j){27403
{{mov{7,xr{8,wb{{point back to a(0){27404
{{mov{8,wb{3,srtrt{{get root{27405
{{jsr{6,sortc{{{compare them - lt(a(j),root){27406
{{ppm{6,srh03{{{father exceeds sons - done{27407
{{mov{7,xr{9,(xs){{get sort array adrs{27408
{{add{7,xr{3,srtso{{point to a(0){27409
{{mov{7,xl{7,xr{{copy it{27410
{{mov{8,wa{8,wc{{copy j{27411
{{btw{8,wc{{{convert to words{27412
{{rsh{8,wc{1,1{{get j/2{27413
{{wtb{8,wc{{{convert back to bytes{27414
{{add{7,xl{8,wa{{point to a(j){27415
{{add{7,xr{8,wc{{adrs of a(j/2){27416
{{mov{9,(xr){9,(xl){{a(j/2) = a(j){27417
{{mov{8,wc{8,wa{{recover j{27418
{{aov{8,wc{8,wc{6,srh03{j = j*2. done if too big{27419
{{brn{6,srh01{{{loop{27420
*      finish by copying root offset back into array
{srh03{btw{8,wc{{{convert to words{27424
{{rsh{8,wc{1,1{{j = j/2{27425
{{wtb{8,wc{{{convert back to bytes{27426
{{mov{7,xr{9,(xs){{sort array adrs{27427
{{add{7,xr{3,srtso{{adrs of a(0){27428
{{add{7,xr{8,wc{{adrs of a(j/2){27429
{{mov{9,(xr){3,srtrt{{a(j/2) = root{27430
{{mov{8,wa{3,srtsn{{restore wa{27431
{{mov{8,wc{3,srtwc{{restore wc{27432
{{exi{{{{return{27433
{{enp{{{{end procedure sorth{27434
{{ejc{{{{{27436
*      trace -- set/reset a trace association
*      this procedure is shared by trace and stoptr to
*      either initiate or stop a trace respectively.
*      (xl)                  trblk ptr (trace) or zero (stoptr)
*      1(xs)                 first argument (name)
*      0(xs)                 second argument (trace type)
*      jsr  trace            call to set/reset trace
*      ppm  loc              transfer loc if 1st arg is bad name
*      ppm  loc              transfer loc if 2nd arg is bad type
*      (xs)                  popped
*      (xl,xr,wa,wb,wc,ia)   destroyed
{trace{prc{25,n{1,2{{entry point{27452
{{jsr{6,gtstg{{{get trace type string{27453
{{ppm{6,trc15{{{jump if not string{27454
{{plc{7,xr{{{else point to string{27455
{{lch{8,wa{9,(xr){{load first character{27456
{{mov{7,xr{9,(xs){{load name argument{27460
{{mov{9,(xs){7,xl{{stack trblk ptr or zero{27461
{{mov{8,wc{18,=trtac{{set trtyp for access trace{27462
{{beq{8,wa{18,=ch_la{6,trc10{jump if a (access){27463
{{mov{8,wc{18,=trtvl{{set trtyp for value trace{27464
{{beq{8,wa{18,=ch_lv{6,trc10{jump if v (value){27465
{{beq{8,wa{18,=ch_bl{6,trc10{jump if blank (value){27466
*      here for l,k,f,c,r
{{beq{8,wa{18,=ch_lf{6,trc01{jump if f (function){27470
{{beq{8,wa{18,=ch_lr{6,trc01{jump if r (return){27471
{{beq{8,wa{18,=ch_ll{6,trc03{jump if l (label){27472
{{beq{8,wa{18,=ch_lk{6,trc06{jump if k (keyword){27473
{{bne{8,wa{18,=ch_lc{6,trc15{else error if not c (call){27474
*      here for f,c,r
{trc01{jsr{6,gtnvr{{{point to vrblk for name{27478
{{ppm{6,trc16{{{jump if bad name{27479
{{ica{7,xs{{{pop stack{27480
{{mov{7,xr{13,vrfnc(xr){{point to function block{27481
{{bne{9,(xr){22,=b_pfc{6,trc17{error if not program function{27482
{{beq{8,wa{18,=ch_lr{6,trc02{jump if r (return){27483
{{ejc{{{{{27484
*      trace (continued)
*      here for f,c to set/reset call trace
{{mov{13,pfctr(xr){7,xl{{set/reset call trace{27490
{{beq{8,wa{18,=ch_lc{6,exnul{exit with null if c (call){27491
*      here for f,r to set/reset return trace
{trc02{mov{13,pfrtr(xr){7,xl{{set/reset return trace{27495
{{exi{{{{return{27496
*      here for l to set/reset label trace
{trc03{jsr{6,gtnvr{{{point to vrblk{27500
{{ppm{6,trc16{{{jump if bad name{27501
{{mov{7,xl{13,vrlbl(xr){{load label pointer{27502
{{bne{9,(xl){22,=b_trt{6,trc04{jump if no old trace{27503
{{mov{7,xl{13,trlbl(xl){{else delete old trace association{27504
*      here with old label trace association deleted
{trc04{beq{7,xl{21,=stndl{6,trc16{error if undefined label{27508
{{mov{8,wb{10,(xs)+{{get trblk ptr again{27509
{{bze{8,wb{6,trc05{{jump if stoptr case{27510
{{mov{13,vrlbl(xr){8,wb{{else set new trblk pointer{27511
{{mov{13,vrtra(xr){22,=b_vrt{{set label trace routine address{27512
{{mov{7,xr{8,wb{{copy trblk pointer{27513
{{mov{13,trlbl(xr){7,xl{{store real label in trblk{27514
{{exi{{{{return{27515
*      here for stoptr case for label
{trc05{mov{13,vrlbl(xr){7,xl{{store label ptr back in vrblk{27519
{{mov{13,vrtra(xr){22,=b_vrg{{store normal transfer address{27520
{{exi{{{{return{27521
{{ejc{{{{{27522
*      trace (continued)
*      here for k (keyword)
{trc06{jsr{6,gtnvr{{{point to vrblk{27528
{{ppm{6,trc16{{{error if not natural var{27529
{{bnz{13,vrlen(xr){6,trc16{{error if not system var{27530
{{ica{7,xs{{{pop stack{27531
{{bze{7,xl{6,trc07{{jump if stoptr case{27532
{{mov{13,trkvr(xl){7,xr{{store vrblk ptr in trblk for ktrex{27533
*      merge here with trblk set up in wb (or zero)
{trc07{mov{7,xr{13,vrsvp(xr){{point to svblk{27537
{{beq{7,xr{21,=v_ert{6,trc08{jump if errtype{27538
{{beq{7,xr{21,=v_stc{6,trc09{jump if stcount{27539
{{bne{7,xr{21,=v_fnc{6,trc17{else error if not fnclevel{27540
*      fnclevel
{{mov{3,r_fnc{7,xl{{set/reset fnclevel trace{27544
{{exi{{{{return{27545
*      errtype
{trc08{mov{3,r_ert{7,xl{{set/reset errtype trace{27549
{{exi{{{{return{27550
*      stcount
{trc09{mov{3,r_stc{7,xl{{set/reset stcount trace{27554
{{jsr{6,stgcc{{{update countdown counters{27555
{{exi{{{{return{27556
{{ejc{{{{{27557
*      trace (continued)
*      a,v merge here with trtyp value in wc
{trc10{jsr{6,gtvar{{{locate variable{27563
{{ppm{6,trc16{{{error if not appropriate name{27564
{{mov{8,wb{10,(xs)+{{get new trblk ptr again{27565
{{add{8,wa{7,xl{{point to variable location{27566
{{mov{7,xr{8,wa{{copy variable pointer{27567
*      loop to search trblk chain
{trc11{mov{7,xl{9,(xr){{point to next entry{27571
{{bne{9,(xl){22,=b_trt{6,trc13{jump if not trblk{27572
{{blt{8,wc{13,trtyp(xl){6,trc13{jump if too far out on chain{27573
{{beq{8,wc{13,trtyp(xl){6,trc12{jump if this matches our type{27574
{{add{7,xl{19,*trnxt{{else point to link field{27575
{{mov{7,xr{7,xl{{copy pointer{27576
{{brn{6,trc11{{{and loop back{27577
*      here to delete an old trblk of the type we were given
{trc12{mov{7,xl{13,trnxt(xl){{get ptr to next block or value{27581
{{mov{9,(xr){7,xl{{store to delete this trblk{27582
*      here after deleting any old association of this type
{trc13{bze{8,wb{6,trc14{{jump if stoptr case{27586
{{mov{9,(xr){8,wb{{else link new trblk in{27587
{{mov{7,xr{8,wb{{copy trblk pointer{27588
{{mov{13,trnxt(xr){7,xl{{store forward pointer{27589
{{mov{13,trtyp(xr){8,wc{{store appropriate trap type code{27590
*      here to make sure vrget,vrsto are set properly
{trc14{mov{7,xr{8,wa{{recall possible vrblk pointer{27594
{{sub{7,xr{19,*vrval{{point back to vrblk{27595
{{jsr{6,setvr{{{set fields if vrblk{27596
{{exi{{{{return{27597
*      here for bad trace type
{trc15{exi{1,2{{{take bad trace type error exit{27601
*      pop stack before failing
{trc16{ica{7,xs{{{pop stack{27605
*      here for bad name argument
{trc17{exi{1,1{{{take bad name error exit{27609
{{enp{{{{end procedure trace{27610
{{ejc{{{{{27611
*      trbld -- build trblk
*      trblk is used by the input, output and trace functions
*      to construct a trblk (trap block)
*      (xr)                  trtag or trter
*      (xl)                  trfnc or trfpt
*      (wb)                  trtyp
*      jsr  trbld            call to build trblk
*      (xr)                  pointer to trblk
*      (wa)                  destroyed
{trbld{prc{25,e{1,0{{entry point{27625
{{mov{11,-(xs){7,xr{{stack trtag (or trfnm){27626
{{mov{8,wa{19,*trsi_{{set size of trblk{27627
{{jsr{6,alloc{{{allocate trblk{27628
{{mov{9,(xr){22,=b_trt{{store first word{27629
{{mov{13,trfnc(xr){7,xl{{store trfnc (or trfpt){27630
{{mov{13,trtag(xr){10,(xs)+{{store trtag (or trfnm){27631
{{mov{13,trtyp(xr){8,wb{{store type{27632
{{mov{13,trval(xr){21,=nulls{{for now, a null value{27633
{{exi{{{{return to caller{27634
{{enp{{{{end procedure trbld{27635
{{ejc{{{{{27636
*      trimr -- trim trailing blanks
*      trimr is passed a pointer to an scblk which must be the
*      last block in dynamic storage. trailing blanks are
*      trimmed off and the dynamic storage pointer reset to
*      the end of the (possibly) shortened block.
*      (wb)                  non-zero to trim trailing blanks
*      (xr)                  pointer to string to trim
*      jsr  trimr            call to trim string
*      (xr)                  pointer to trimmed string
*      (xl,wa,wb,wc)         destroyed
*      the call with wb zero still performs the end zero pad
*      and dnamp readjustment. it is used from acess if kvtrm=0.
{trimr{prc{25,e{1,0{{entry point{27654
{{mov{7,xl{7,xr{{copy string pointer{27655
{{mov{8,wa{13,sclen(xr){{load string length{27656
{{bze{8,wa{6,trim2{{jump if null input{27657
{{plc{7,xl{8,wa{{else point past last character{27658
{{bze{8,wb{6,trim3{{jump if no trim{27659
{{mov{8,wc{18,=ch_bl{{load blank character{27660
*      loop through characters from right to left
{trim0{lch{8,wb{11,-(xl){{load next character{27664
{{beq{8,wb{18,=ch_ht{6,trim1{jump if horizontal tab{27666
{{bne{8,wb{8,wc{6,trim3{jump if non-blank found{27668
{trim1{dcv{8,wa{{{else decrement character count{27669
{{bnz{8,wa{6,trim0{{loop back if more to check{27670
*      here if result is null (null or all-blank input)
{trim2{mov{3,dnamp{7,xr{{wipe out input string block{27674
{{mov{7,xr{21,=nulls{{load null result{27675
{{brn{6,trim5{{{merge to exit{27676
{{ejc{{{{{27677
*      trimr (continued)
*      here with non-blank found (merge for no trim)
{trim3{mov{13,sclen(xr){8,wa{{set new length{27683
{{mov{7,xl{7,xr{{copy string pointer{27684
{{psc{7,xl{8,wa{{ready for storing blanks{27685
{{ctb{8,wa{2,schar{{get length of block in bytes{27686
{{add{8,wa{7,xr{{point past new block{27687
{{mov{3,dnamp{8,wa{{set new top of storage pointer{27688
{{lct{8,wa{18,=cfp_c{{get count of chars in word{27689
{{zer{8,wc{{{set zero char{27690
*      loop to zero pad last word of characters
{trim4{sch{8,wc{10,(xl)+{{store zero character{27694
{{bct{8,wa{6,trim4{{loop back till all stored{27695
{{csc{7,xl{{{complete store characters{27696
*      common exit point
{trim5{zer{7,xl{{{clear garbage xl pointer{27700
{{exi{{{{return to caller{27701
{{enp{{{{end procedure trimr{27702
{{ejc{{{{{27703
*      trxeq -- execute function type trace
*      trxeq is used to execute a trace when a fourth argument
*      has been supplied. trace has already been decremented.
*      (xr)                  pointer to trblk
*      (xl,wa)               name base,offset for variable
*      jsr  trxeq            call to execute trace
*      (wb,wc,ra)            destroyed
*      the following stack entries are made before passing
*      control to the trace function using the cfunc routine.
*                            trxeq return point word(s)
*                            saved value of trace keyword
*                            trblk pointer
*                            name base
*                            name offset
*                            saved value of r_cod
*                            saved code ptr (-r_cod)
*                            saved value of flptr
*      flptr --------------- zero (dummy fail offset)
*                            nmblk for variable name
*      xs ------------------ trace tag
*      r_cod and the code ptr are set to dummy values which
*      cause control to return to the trxeq procedure on success
*      or failure (trxeq ignores a failure condition).
{trxeq{prc{25,r{1,0{{entry point (recursive){27734
{{mov{8,wc{3,r_cod{{load code block pointer{27735
{{scp{8,wb{{{get current code pointer{27736
{{sub{8,wb{8,wc{{make code pointer into offset{27737
{{mov{11,-(xs){3,kvtra{{stack trace keyword value{27738
{{mov{11,-(xs){7,xr{{stack trblk pointer{27739
{{mov{11,-(xs){7,xl{{stack name base{27740
{{mov{11,-(xs){8,wa{{stack name offset{27741
{{mov{11,-(xs){8,wc{{stack code block pointer{27742
{{mov{11,-(xs){8,wb{{stack code pointer offset{27743
{{mov{11,-(xs){3,flptr{{stack old failure pointer{27744
{{zer{11,-(xs){{{set dummy fail offset{27745
{{mov{3,flptr{7,xs{{set new failure pointer{27746
{{zer{3,kvtra{{{reset trace keyword to zero{27747
{{mov{8,wc{21,=trxdc{{load new (dummy) code blk pointer{27748
{{mov{3,r_cod{8,wc{{set as code block pointer{27749
{{lcp{8,wc{{{and new code pointer{27750
{{ejc{{{{{27751
*      trxeq (continued)
*      now prepare arguments for function
{{mov{8,wb{8,wa{{save name offset{27757
{{mov{8,wa{19,*nmsi_{{load nmblk size{27758
{{jsr{6,alloc{{{allocate space for nmblk{27759
{{mov{9,(xr){22,=b_nml{{set type word{27760
{{mov{13,nmbas(xr){7,xl{{store name base{27761
{{mov{13,nmofs(xr){8,wb{{store name offset{27762
{{mov{7,xl{12,6(xs){{reload pointer to trblk{27763
{{mov{11,-(xs){7,xr{{stack nmblk pointer (1st argument){27764
{{mov{11,-(xs){13,trtag(xl){{stack trace tag (2nd argument){27765
{{mov{7,xl{13,trfnc(xl){{load trace vrblk pointer{27766
{{mov{7,xl{13,vrfnc(xl){{load trace function pointer{27767
{{beq{7,xl{21,=stndf{6,trxq2{jump if not a defined function{27768
{{mov{8,wa{18,=num02{{set number of arguments to two{27769
{{brn{6,cfunc{{{jump to call function{27770
*      see o_txr for details of return to this point
{trxq1{mov{7,xs{3,flptr{{point back to our stack entries{27774
{{ica{7,xs{{{pop off garbage fail offset{27775
{{mov{3,flptr{10,(xs)+{{restore old failure pointer{27776
{{mov{8,wb{10,(xs)+{{reload code offset{27777
{{mov{8,wc{10,(xs)+{{load old code base pointer{27778
{{mov{7,xr{8,wc{{copy cdblk pointer{27779
{{mov{3,kvstn{13,cdstm(xr){{restore stmnt no{27780
{{mov{8,wa{10,(xs)+{{reload name offset{27781
{{mov{7,xl{10,(xs)+{{reload name base{27782
{{mov{7,xr{10,(xs)+{{reload trblk pointer{27783
{{mov{3,kvtra{10,(xs)+{{restore trace keyword value{27784
{{add{8,wb{8,wc{{recompute absolute code pointer{27785
{{lcp{8,wb{{{restore code pointer{27786
{{mov{3,r_cod{8,wc{{and code block pointer{27787
{{exi{{{{return to trxeq caller{27788
*      here if the target function is not defined
{trxq2{erb{1,197{26,trace fourth arg is not function name or null{{{27792
{{enp{{{{end procedure trxeq{27794
{{ejc{{{{{27795
*      xscan -- execution function argument scan
*      xscan scans out one token in a prototype argument in
*      array,clear,data,define,load function calls. xscan
*      calls must be preceded by a call to the initialization
*      procedure xscni. the following variables are used.
*      r_xsc                 pointer to scblk for function arg
*      xsofs                 offset (num chars scanned so far)
*      (wa)                  non-zero to skip and trim blanks
*      (wc)                  delimiter one (ch_xx)
*      (xl)                  delimiter two (ch_xx)
*      jsr  xscan            call to scan next item
*      (xr)                  pointer to scblk for token scanned
*      (wa)                  completion code (see below)
*      (wc,xl)               destroyed
*      the scan starts from the current position and continues
*      until one of the following three conditions occurs.
*      1)   delimiter one is encountered  (wa set to 1)
*      2)   delimiter two encountered  (wa set to 2)
*      3)   end of string encountered  (wa set to 0)
*      the result is a string containing all characters scanned
*      up to but not including any delimiter character.
*      the pointer is left pointing past the delimiter.
*      if only one delimiter is to be detected, delimiter one
*      and delimiter two should be set to the same value.
*      in the case where the end of string is encountered, the
*      string includes all the characters to the end of the
*      string. no further calls can be made to xscan until
*      xscni is called to initialize a new argument scan
{{ejc{{{{{27835
*      xscan (continued)
{xscan{prc{25,e{1,0{{entry point{27839
{{mov{3,xscwb{8,wb{{preserve wb{27840
{{mov{11,-(xs){8,wa{{record blank skip flag{27841
{{mov{11,-(xs){8,wa{{and second copy{27842
{{mov{7,xr{3,r_xsc{{point to argument string{27843
{{mov{8,wa{13,sclen(xr){{load string length{27844
{{mov{8,wb{3,xsofs{{load current offset{27845
{{sub{8,wa{8,wb{{get number of remaining characters{27846
{{bze{8,wa{6,xscn3{{jump if no characters left{27847
{{plc{7,xr{8,wb{{point to current character{27848
*      loop to search for delimiter
{xscn1{lch{8,wb{10,(xr)+{{load next character{27852
{{beq{8,wb{8,wc{6,xscn4{jump if delimiter one found{27853
{{beq{8,wb{7,xl{6,xscn5{jump if delimiter two found{27854
{{bze{9,(xs){6,xscn2{{jump if not skipping blanks{27855
{{icv{3,xsofs{{{assume blank and delete it{27856
{{beq{8,wb{18,=ch_ht{6,xscn2{jump if horizontal tab{27858
{{beq{8,wb{18,=ch_bl{6,xscn2{jump if blank{27863
{{dcv{3,xsofs{{{undelete non-blank character{27864
{{zer{9,(xs){{{and discontinue blank checking{27865
*      here after performing any leading blank trimming.
{xscn2{dcv{8,wa{{{decrement count of chars left{27869
{{bnz{8,wa{6,xscn1{{loop back if more chars to go{27870
*      here for runout
{xscn3{mov{7,xl{3,r_xsc{{point to string block{27874
{{mov{8,wa{13,sclen(xl){{get string length{27875
{{mov{8,wb{3,xsofs{{load offset{27876
{{sub{8,wa{8,wb{{get substring length{27877
{{zer{3,r_xsc{{{clear string ptr for collector{27878
{{zer{3,xscrt{{{set zero (runout) return code{27879
{{brn{6,xscn7{{{jump to exit{27880
{{ejc{{{{{27881
*      xscan (continued)
*      here if delimiter one found
{xscn4{mov{3,xscrt{18,=num01{{set return code{27887
{{brn{6,xscn6{{{jump to merge{27888
*      here if delimiter two found
{xscn5{mov{3,xscrt{18,=num02{{set return code{27892
*      merge here after detecting a delimiter
{xscn6{mov{7,xl{3,r_xsc{{reload pointer to string{27896
{{mov{8,wc{13,sclen(xl){{get original length of string{27897
{{sub{8,wc{8,wa{{minus chars left = chars scanned{27898
{{mov{8,wa{8,wc{{move to reg for sbstr{27899
{{mov{8,wb{3,xsofs{{set offset{27900
{{sub{8,wa{8,wb{{compute length for sbstr{27901
{{icv{8,wc{{{adjust new cursor past delimiter{27902
{{mov{3,xsofs{8,wc{{store new offset{27903
*      common exit point
{xscn7{zer{7,xr{{{clear garbage character ptr in xr{27907
{{jsr{6,sbstr{{{build sub-string{27908
{{ica{7,xs{{{remove copy of blank flag{27909
{{mov{8,wb{10,(xs)+{{original blank skip/trim flag{27910
{{bze{13,sclen(xr){6,xscn8{{cannot trim the null string{27911
{{jsr{6,trimr{{{trim trailing blanks if requested{27912
*      final exit point
{xscn8{mov{8,wa{3,xscrt{{load return code{27916
{{mov{8,wb{3,xscwb{{restore wb{27917
{{exi{{{{return to xscan caller{27918
{{enp{{{{end procedure xscan{27919
{{ejc{{{{{27920
*      xscni -- execution function argument scan
*      xscni initializes the scan used for prototype arguments
*      in the clear, define, load, data, array functions. see
*      xscan for the procedure which is used after this call.
*      -(xs)                 argument to be scanned (on stack)
*      jsr  xscni            call to scan argument
*      ppm  loc              transfer loc if arg is not string
*      ppm  loc              transfer loc if argument is null
*      (xs)                  popped
*      (xr,r_xsc)            argument (scblk ptr)
*      (wa)                  argument length
*      (ia,ra)               destroyed
{xscni{prc{25,n{1,2{{entry point{27937
{{jsr{6,gtstg{{{fetch argument as string{27938
{{ppm{6,xsci1{{{jump if not convertible{27939
{{mov{3,r_xsc{7,xr{{else store scblk ptr for xscan{27940
{{zer{3,xsofs{{{set offset to zero{27941
{{bze{8,wa{6,xsci2{{jump if null string{27942
{{exi{{{{return to xscni caller{27943
*      here if argument is not a string
{xsci1{exi{1,1{{{take not-string error exit{27947
*      here for null string
{xsci2{exi{1,2{{{take null-string error exit{27951
{{enp{{{{end procedure xscni{27952
{{ttl{27,s p i t b o l -- stack overflow section{{{{27953
*      control comes here if the main stack overflows
{{sec{{{{start of stack overflow section{27957
{{add{3,errft{18,=num04{{force conclusive fatal error{27959
{{mov{7,xs{3,flptr{{pop stack to avoid more fails{27960
{{bnz{3,gbcfl{6,stak1{{jump if garbage collecting{27961
{{erb{1,246{26,stack overflow{{{27962
*      no chance of recovery in mid garbage collection
{stak1{mov{7,xr{21,=endso{{point to message{27966
{{zer{3,kvdmp{{{memory is undumpable{27967
{{brn{6,stopr{{{give up{27968
{{ttl{27,s p i t b o l -- error section{{{{27969
*      this section of code is entered whenever a procedure
*      return via an err parameter or an erb opcode is obeyed.
*      (wa)                  is the error code
*      the global variable stage indicates the point at which
*      the error occured as follows.
*      stage=stgic           error during initial compile
*      stage=stgxc           error during compile at execute
*                            time (code, convert function calls)
*      stage=stgev           error during compilation of
*                            expression at execution time
*                            (eval, convert function call).
*      stage=stgxt           error at execute time. compiler
*                            not active.
*      stage=stgce           error during initial compile after
*                            scanning out the end line.
*      stage=stgxe           error during compile at execute
*                            time after scanning end line.
*      stage=stgee           error during expression evaluation
{{sec{{{{start of error section{27999
{error{beq{3,r_cim{20,=cmlab{6,cmple{jump if error in scanning label{28001
{{mov{3,kvert{8,wa{{save error code{28002
{{zer{3,scnrs{{{reset rescan switch for scane{28003
{{zer{3,scngo{{{reset goto switch for scane{28004
{{mov{3,polcs{18,=num01{{reset poll count{28006
{{mov{3,polct{18,=num01{{reset poll count{28007
{{mov{7,xr{3,stage{{load current stage{28009
{{bsw{7,xr{2,stgno{{jump to appropriate error circuit{28010
{{iff{2,stgic{6,err01{{initial compile{28018
{{iff{2,stgxc{6,err04{{execute time compile{28018
{{iff{2,stgev{6,err04{{eval compiling expr.{28018
{{iff{2,stgxt{6,err05{{execute time{28018
{{iff{2,stgce{6,err01{{compile - after end{28018
{{iff{2,stgxe{6,err04{{xeq compile-past end{28018
{{iff{2,stgee{6,err04{{eval evaluating expr{28018
{{esw{{{{end switch on error type{28018
{{ejc{{{{{28019
*      error during initial compile
*      the error message is printed as part of the compiler
*      output. this printout includes the offending line (if not
*      printed already) and an error flag under the appropriate
*      column as indicated by scnse unless scnse is set to zero.
*      after printing the message, the generated code is
*      modified to an error call and control is returned to
*      the cmpil procedure after resetting the stack pointer.
*      if the error occurs after the end line, control returns
*      in a slightly different manner to ensure proper cleanup.
{err01{mov{7,xs{3,cmpxs{{reset stack pointer{28035
{{ssl{3,cmpss{{{restore s-r stack ptr for cmpil{28036
{{bnz{3,errsp{6,err03{{jump if error suppress flag set{28037
{{mov{8,wc{3,cmpsn{{current statement{28040
{{jsr{6,filnm{{{obtain file name for this statement{28041
{{mov{8,wb{3,scnse{{column number{28043
{{mov{8,wc{3,rdcln{{line number{28044
{{mov{7,xr{3,stage{{{28045
{{jsr{6,sysea{{{advise system of error{28046
{{ppm{6,erra3{{{if system does not want print{28047
{{mov{11,-(xs){7,xr{{save any provided print message{28048
{{mov{3,erlst{3,erich{{set flag for listr{28050
{{jsr{6,listr{{{list line{28051
{{jsr{6,prtis{{{terminate listing{28052
{{zer{3,erlst{{{clear listr flag{28053
{{mov{8,wa{3,scnse{{load scan element offset{28054
{{bze{8,wa{6,err02{{skip if not set{28055
{{lct{8,wb{8,wa{{loop counter{28057
{{icv{8,wa{{{increase for ch_ex{28058
{{mov{7,xl{3,r_cim{{point to bad statement{28059
{{jsr{6,alocs{{{string block for error flag{28060
{{mov{8,wa{7,xr{{remember string ptr{28061
{{psc{7,xr{{{ready for character storing{28062
{{plc{7,xl{{{ready to get chars{28063
*      loop to replace all chars but tabs by blanks
{erra1{lch{8,wc{10,(xl)+{{get next char{28067
{{beq{8,wc{18,=ch_ht{6,erra2{skip if tab{28068
{{mov{8,wc{18,=ch_bl{{get a blank{28069
{{ejc{{{{{28070
*      merge to store blank or tab in error line
{erra2{sch{8,wc{10,(xr)+{{store char{28074
{{bct{8,wb{6,erra1{{loop{28075
{{mov{7,xl{18,=ch_ex{{exclamation mark{28076
{{sch{7,xl{9,(xr){{store at end of error line{28077
{{csc{7,xr{{{end of sch loop{28078
{{mov{3,profs{18,=stnpd{{allow for statement number{28079
{{mov{7,xr{8,wa{{point to error line{28080
{{jsr{6,prtst{{{print error line{28081
*      here after placing error flag as required
{err02{jsr{6,prtis{{{print blank line{28095
{{mov{7,xr{10,(xs)+{{restore any sysea message{28097
{{bze{7,xr{6,erra0{{did sysea provide message to print{28098
{{jsr{6,prtst{{{print sysea message{28099
{erra0{jsr{6,ermsg{{{generate flag and error message{28101
{{add{3,lstlc{18,=num03{{bump page ctr for blank, error, blk{28102
{erra3{zer{7,xr{{{in case of fatal error{28103
{{bhi{3,errft{18,=num03{6,stopr{pack up if several fatals{28104
*      count error, inhibit execution if required
{{icv{3,cmerc{{{bump error count{28108
{{add{3,noxeq{3,cswer{{inhibit xeq if -noerrors{28109
{{bne{3,stage{18,=stgic{6,cmp10{special return if after end line{28110
{{ejc{{{{{28111
*      loop to scan to end of statement
{err03{mov{7,xr{3,r_cim{{point to start of image{28115
{{plc{7,xr{{{point to first char{28116
{{lch{7,xr{9,(xr){{get first char{28117
{{beq{7,xr{18,=ch_mn{6,cmpce{jump if error in control card{28118
{{zer{3,scnrs{{{clear rescan flag{28119
{{mnz{3,errsp{{{set error suppress flag{28120
{{jsr{6,scane{{{scan next element{28121
{{bne{7,xl{18,=t_smc{6,err03{loop back if not statement end{28122
{{zer{3,errsp{{{clear error suppress flag{28123
*      generate error call in code and return to cmpil
{{mov{3,cwcof{19,*cdcod{{reset offset in ccblk{28127
{{mov{8,wa{21,=ocer_{{load compile error call{28128
{{jsr{6,cdwrd{{{generate it{28129
{{mov{13,cmsoc(xs){3,cwcof{{set success fill in offset{28130
{{mnz{13,cmffc(xs){{{set failure fill in flag{28131
{{jsr{6,cdwrd{{{generate succ. fill in word{28132
{{brn{6,cmpse{{{merge to generate error as cdfal{28133
*      error during execute time compile or expression evaluatio
*      execute time compilation is initiated through gtcod or
*      gtexp which are called by compile, code or eval.
*      before causing statement failure through exfal it is
*      helpful to set keyword errtext and for generality
*      these errors may be handled by the setexit mechanism.
{err04{bge{3,errft{18,=num03{6,labo1{abort if too many fatal errors{28143
{{beq{3,kvert{18,=nm320{6,err06{treat user interrupt specially{28145
{{zer{3,r_ccb{{{forget garbage code block{28147
{{mov{3,cwcof{19,*cccod{{set initial offset (mbe catspaw){28148
{{ssl{3,iniss{{{restore main prog s-r stack ptr{28149
{{jsr{6,ertex{{{get fail message text{28150
{{dca{7,xs{{{ensure stack ok on loop start{28151
*      pop stack until find flptr for most deeply nested prog.
*      defined function call or call of eval / code.
{erra4{ica{7,xs{{{pop stack{28156
{{beq{7,xs{3,flprt{6,errc4{jump if prog defined fn call found{28157
{{bne{7,xs{3,gtcef{6,erra4{loop if not eval or code call yet{28158
{{mov{3,stage{18,=stgxt{{re-set stage for execute{28159
{{mov{3,r_cod{3,r_gtc{{recover code ptr{28160
{{mov{3,flptr{7,xs{{restore fail pointer{28161
{{zer{3,r_cim{{{forget possible image{28162
{{zer{3,cnind{{{forget possible include{28164
*      test errlimit
{errb4{bnz{3,kverl{6,err07{{jump if errlimit non-zero{28169
{{brn{6,exfal{{{fail{28170
*      return from prog. defined function is outstanding
{errc4{mov{7,xs{3,flptr{{restore stack from flptr{28174
{{brn{6,errb4{{{merge{28175
{{ejc{{{{{28176
*      error at execute time.
*      the action taken on an error is as follows.
*      if errlimit keyword is zero, an abort is signalled,
*      see coding for system label abort at l_abo.
*      otherwise, errlimit is decremented and an errtype trace
*      generated if required. control returns either via a jump
*      to continue (to take the failure exit) or a specified
*      setexit trap is executed and control passes to the trap.
*      if 3 or more fatal errors occur an abort is signalled
*      regardless of errlimit and setexit - looping is all too
*      probable otherwise. fatal errors include stack overflow
*      and exceeding stlimit.
{err05{ssl{3,iniss{{{restore main prog s-r stack ptr{28194
{{bnz{3,dmvch{6,err08{{jump if in mid-dump{28195
*      merge here from err08 and err04 (error 320)
{err06{bze{3,kverl{6,labo1{{abort if errlimit is zero{28199
{{jsr{6,ertex{{{get fail message text{28200
*      merge from err04
{err07{bge{3,errft{18,=num03{6,labo1{abort if too many fatal errors{28204
{{dcv{3,kverl{{{decrement errlimit{28205
{{mov{7,xl{3,r_ert{{load errtype trace pointer{28206
{{jsr{6,ktrex{{{generate errtype trace if required{28207
{{mov{8,wa{3,r_cod{{get current code block{28208
{{mov{3,r_cnt{8,wa{{set cdblk ptr for continuation{28209
{{scp{8,wb{{{current code pointer{28210
{{sub{8,wb{8,wa{{offset within code block{28211
{{mov{3,stxoc{8,wb{{save code ptr offset for scontinue{28212
{{mov{7,xr{3,flptr{{set ptr to failure offset{28213
{{mov{3,stxof{9,(xr){{save failure offset for continue{28214
{{mov{7,xr{3,r_sxc{{load setexit cdblk pointer{28215
{{bze{7,xr{6,lcnt1{{continue if no setexit trap{28216
{{zer{3,r_sxc{{{else reset trap{28217
{{mov{3,stxvr{21,=nulls{{reset setexit arg to null{28218
{{mov{7,xl{9,(xr){{load ptr to code block routine{28219
{{bri{7,xl{{{execute first trap statement{28220
*      interrupted partly through a dump whilst store is in a
*      mess so do a tidy up operation. see dumpr for details.
{err08{mov{7,xr{3,dmvch{{chain head for affected vrblks{28225
{{bze{7,xr{6,err06{{done if zero{28226
{{mov{3,dmvch{9,(xr){{set next link as chain head{28227
{{jsr{6,setvr{{{restore vrget field{28228
*      label to mark end of code
{s_yyy{brn{6,err08{{{loop through chain{28232
{{ttl{27,s p i t b o l -- here endeth the code{{{{28233
*      end of assembly
{{end{{{{end macro-spitbol assembly{28237
