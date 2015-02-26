-title mincod: phase 2 translation from minimal tokens to 80386 code
-stitl description
* copyright 1987-2012 robert b. k. dewar and mark emmer.
* copyright 2012-2015 david shields

* this file is part of macro spitbol.

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


*  this program takes input file in minimal token form and
*  produces assembly code for intel 80386 processor.
*  the program obtains the name of the file to be translated from the
*  command line string in host(0).  options relating to the processing
*  of comments can be changed by modifying the source.

*  in addition to the minimal token file, the program requires the
*  name of a "machine definition file" that contains code specific
*  to a particular 80386 assembler.

*  you may also specify option flags on the command line to control the
*  code generation.  the following flags are processed:
*	compress	generate tabs rather than spaces in output file
*       comments        retain full-line and end-of-line comments

*  in addition to the normal minimal register complement, one scratch
*  work register, w0 is defined.  see the register map below for specific allocations.

*  this program is based in part on earlier translators for the
*  it is based in part on earlier translators for the dec vax
*  (vms and un*x) written by steve duff and robert goldberg, and the
*  pc-spitbol translator by david shields.

*  to run under spitbol:
*       spitbol -u "<file>:<machine>[:flag:...:flag]" codlinux.spt

*	reads <file>.lex	containing tokenized source code
*       writes <file>.s         with 80386 assembly code
*	also writes <file>.err	with err and erb error messages
*       parts of n.hdr  are prepended and appended to <file>.s
*	also sets flags		to 1 after converting names to upper case
*	also reads <file>.pub	for debug symbols to be declared public

*  example:
*       spitbol -u v37:dos:compress codlinux.spt


*  revision history:

        version = 'v1.12'
	rcode = '_rc_'


-eject

*  keyword initialization

	&anchor = &trim	= &dump = 1
	&stlimit = 10000000
	

*  useful constants

	letters = 'abcdefghijklmnopqrstuvwxyz'
	ucase   = letters
	lcase   = 'abcdefghijklmnopqrstuvwxyz'
	nos     = '0123456789'
	tab	= char(9)


*  function definitions

*  crack parses stmt into a stmt data plex and returns it.
*  it fails if there is a syntax error.

	define('crack(line)operands,operand,char')

	define('chktrace()')
*	comregs - map minimal register names to target register names
	define('comregs(line)t,pre,word')

*  error is used to report an error for current statement

	define('error(text)')
	define('flush()')
	define('genaop(stmt)')
	define('genbop(stmt)')
	define('gendata()')
	define('genit(count,lines,desc)lbl')
        define('genlab(prefix)')
        define('genrip()')
	define('genop(gopc,gop1,gop2,gop3)')
	define('genopl(gopl,gopc,gop1,gop2,gop3)')
	define('genrep(op)l1,l2)')
	define('gensh(opc,reg,val)')
	define('gentext()')
	define('getarg(iarg)txt,typ,pre,post')
.if N
	define('getlea(iarg)txt,typ,pre,post')
.fi
	define('getrip(iarg)txt,typ,pre,post,ent,lb,var,reg')
	define('getval(iarg)txt,typ,pre,post')
.if G
	define('getadr(iarg)txt,typ,pre,post')
.fi
	define('getmem(iarg)txt,typ,pre,post,base,disp,indx,scale')
	define('ifreg(iarg)')
	define('memmem()t')
.if G
	define('m(text)')
.fi
	define('outline(txt)')
	define('prcent(n)')
	define('prsarg(iarg)l1,l2')
	define('report(num,text)')
	define('ripinit()')
	define('tblini(str)pos,cnt,index,val,lastval')

*  outstmt is used to send a target statement to the target code
*  output file outfile

	define('outstmt(ostmt)label,opcode,op1,op2,op3,comment,t,stmtout')

*  readline is called to return the next non-comment line from
*  the minimal input file (infile <=> lu1).   note that it will
*  not fail on eof, but it will return a minimal end statement

	define('readline()')

	os = 'unix';	ws = '64'
	options = host(0)
	output = 'options: ' options
*	add trailing colon so always have colon after an argument
	options = options ':'
option.next		
*	ignore extraneous : in list (helps with writing makefiles)
	options ':' =				:s(option.next)
	options break(':') . option ':' =	:f(options.done)

	ident(option,'unix_32')			:s(option.unix.32)
	ident(option,'unix_64')			:s(option.unix.64)
	ident(option,'osx_32')			:s(option.osx.32)
	ident(option,'xt')			:s(option.xt)
	ident(option,'it')			:s(option.it)

* here if unknown option

	output = "error: unknown option '" option "', translation ends."	
	&dump = 0				:(end)

option.unix.32
	os = 'unix'; 	ws = '32'		:(option.next)
option.unix.64
	os = 'unix'; 	ws = '64'		:(option.next)
option.osx.32
	os = 'osx'; 	ws = '32'		:(option.next)
option.it
*	turn on instruction trace
	i_trace = 1				:(option.next)
option.xt
*  x_trace turns on tracing for executable instructions
	x_trace = 1				:(option.next)

options.done
	target = os '_' ws
	report(target,'target')



	filebase = "s"
	fileprefix = "s"

*	cfp_b is bytes per word, cfp_c is characters per word
*       these should agree with values used in translator
* set target-dependent configuration parameters
	:($('config.' ws))

config.32
	cfp_b = 4
	cfp_bm1 = 3
	cfp_c = 4
	log_cfp_b = '2'
	log_cfp_c = '2'
*	op_w is instruction suffix for word-size
	op_w = 'd'
*	op_c is instruction suffix for minimal character size
	op_c = 'b'
	rel = ''
.if G
	d_word = '.long'
	m_word = 'dword '
*	suffix for opcode to indicate double word (32 bits)
	o_ =	'd'
.fi
						:(config.done)

config.64
*	cfp_b is bytes per word, cfp_c is characters per word
*       these should agree with values used in translator
	cfp_b = 8
	cfp_bm1 = 7
	cfp_c = 8
	log_cfp_b = '3'
	log_cfp_c = '3'
	op_w = 'q'
	op_c = 'b'
*	rel = 'rel '
	rel = ''
.if G	d_word = '.quad'
	m_word = 'qword '
*	suffix for opcode to indicate quad word (64 bits)
	o_ =	'q'
.fi
config.done

*	rip_mode is needed for osx. See getval()

	rip_mode = (ident(os,'osx') 1, 0)

	report('rip', rip_mode)
	ne(rip_mode) ripinit()

*	it_limit is maximum number of calls to be generated if non-zero
	it_limit = 000
*	set it_first non-zero to skip first number of instructions that would generate trace
	it_first = 1
*	will set in_executable when in part of program where executable
*	instructions may occur
	it_exec = 0

*	it_suspend is set nonzero to temporarily disable the instruction trace.
*	it is initially nonzero so no trace can be emitted until reach code section.
	it_suspend = 1
*	set in_skip when should not insert trace code, else assembly errors result.
*	start with skip on, turn off when see first start of code.
	it_skip = 1
*	skip_on and skip_off are labels indicating the start and end,
*	respectively, of sections of the code that should not be traced,
*	usually because they contain a loop instruction that won't
*	compile if too much trace code is inserted.
	skip_on = table(50)
	skip_off = table(50)

	define('skip_init(s)on,off')		:(skip_init.end)
skip_init	s break(':') . on ':' rem . off	:f(return)
	skip_on[on] = 1
	skip_off[off] = 1			:(return)
skip_init.end

*	skip_init('start:ini03')
   	skip_init('gbcol:gtarr')
*	skip_init('gtn01:gtnvr')
*	skip_init('bpf05:bpf07')
*	skip_init('scv12:scv19')
*	skip_init('exbl1:exbl2')
*	skip_init('exbl5:expan')
*	skip_init('prn17:prn18')
*	skip_init('ini11:ini13')
*	skip_init('oex13:oexp2')
*	skip_init('oex14:oexp6')
*	skip_init('bdfc1:b_efc')
*	skip_init('sar01:sar10')
*	skip_init('srpl5:srpl8')
*	skip_init('pflu1:pflu2')
*	skip_init('prpa4:prpa5')
*	skip_init('prn17:prn18')
*	skip_init('prtvl:prtt1')
*	skip_init('trim4:trim5')
*	skip_init('prnl1:prnl2')
*	skip_init('prti1:prtmi')
*	skip_init('srpl5:srpl8')



*  data structures

	data('minarg(i.type,i.text)')
	data('tstmt(t.label,t.opc,t.op1,t.op2,t.op3,t.comment)')

	sectnow = 0

*	ppm_cases gives count of ppm/err statments that must follow call to
*	a procedure

	ppm_cases = table(50,,0)


	 p.comregs = break(letters) . pre span(letters) . word

*  exttab has entry for external procedures

	exttab = table(50)

*  labtab records labels in the code section, and their line numbers

	labtab = table(500)

*  for each statement, code in generated into three
*  arrays of statements:

*	astmts:	statements after opcode (()+, etc.)
*	bstmts: statements before code (-(), etc)
*	cstmts: generated code proper

	astmts = array(20,'')
	bstmts = array(10,'')
	cstmts = array(20,'')

*  genlabels is count of generated labels (cf. genlab)

	genlabels = 0

*  riplabel is count of generated rip (osx rip address mode) labels

	riplabels = 0


*  initialize variables

	labcnt = outlines = nlines = nstmts = ntarget = nerrors = 0
	lastopc = lastop1 = lastop2 =
	data_lc = 0
	max_exi = 0

*  initial patterns

*  p.csparse parses tokenized line
	p.csparse = '|' break('|') . inlabel
.	'|' break('|') . incode
.	'|' break('|') . iarg1
.	'|' break('|') . iarg2
.	'|' break('|') . iarg3
.	'|' break('|') . incomment
	'|' rem . slineno

*  dispatch table
.if N
	argcase = table(100)
	argcase[01] = .arg.c.1;	argcase[2]  = .arg.c.2;	argcase[3]  = .arg.c.3;
	argcase[04] = .arg.c.4;	argcase[5]  = .arg.c.5;	argcase[6]  = .arg.c.6;
	argcase[07] = .arg.c.7;	argcase[8]  = .arg.c.8;	argcase[9]  = .arg.c.9;   
	argcase[10] = .arg.c.10;	argcase[11] = .arg.c.11;	argcase[12] = .arg.c.12;
	argcase[13] = .arg.c.13;	argcase[14] = .arg.c.14;	argcase[15] = .arg.c.15;
	argcase[16] = .arg.c.16;	argcase[17] = .arg.c.17;	argcase[18] = .arg.c.18;
	argcase[19] = .arg.c.19;	argcase[20] = .arg.c.20;	argcase[21] = .arg.c.21; 
	argcase[22] = .arg.c.22;	argcase[23] = .arg.c.23;	argcase[24] = .arg.c.24;
	argcase[25] = .arg.c.25;	argcase[26] = .arg.c.26;	argcase[27] = .arg.c.27

	leacase = table(50) 
	leacase[03] = .lea.c.3;		leacase[04] = .lea.c.4;		leacase[09] = .lea.c.9;   
	leacase[12] = .lea.c.12;	leacase[13] = .lea.c.13;	leacase[14] = .lea.c.14
	leacase[15] = .lea.c.15;		 

	valcase = table(50)
	valcase[18] = .val.c.18;	valcase[19] = .val.c.19;	valcase[20] = .val.c.20;	
	valcase[21] = .val.c.21;	valcase[22] = .val.c.22

	riptable = table(500)
	rip_count = 0
	ripcase = table(50)
	ripcase[14] = .rip.c.14;	ripcase[15] = .rip.c.15;	ripcase[18] = .rip.c.18;	
	ripcase[19] = .rip.c.19;	ripcase[20] = .rip.c.20;	ripcase[21] = .rip.c.21;	
	ripcase[22] = .rip.c.22
.fi
.if G
	argcase = table(100)
	argcase[01] = .getarg.c.1;	argcase[2]  = .getarg.c.2;	argcase[3]  = .getarg.c.3;
	argcase[04] = .getarg.c.4;	argcase[5]  = .getarg.c.5;	argcase[6]  = .getarg.c.6;
	argcase[07] = .getarg.c.7;	argcase[8]  = .getarg.c.8;	argcase[9]  = .getarg.c.9;   
	argcase[10] = .getarg.c.10;	argcase[11] = .getarg.c.11;	argcase[12] = .getarg.c.12;
	argcase[13] = .getarg.c.13;	argcase[14] = .getarg.c.14;	argcase[15] = .getarg.c.15;
	argcase[16] = .getarg.c.16;	argcase[17] = .getarg.c.17;	argcase[18] = .getarg.c.18;
	argcase[19] = .getarg.c.19;	argcase[20] = .getarg.c.20;	argcase[21] = .getarg.c.21; 
	argcase[22] = .getarg.c.22;	argcase[23] = .getarg.c.23;	argcase[24] = .getarg.c.24;
	argcase[25] = .getarg.c.25;	argcase[26] = .getarg.c.26;	argcase[27] = .getarg.c.27

	leacase = table(50) 
	leacase[03] = .getadr.c.3;	leacase[04] = .getadr.c.4;	leacase[09] = .getadr.c.9;   
	leacase[12] = .getadr.c.12;	leacase[13] = .getadr.c.13;	leacase[14] = .getadr.c.14
	leacase[15] = .getadr.c.15;		 


	valtable = table(100)


.fi

*  pifatal maps minimal opcodes for which no a code allowed
*  to nonzero value. such operations include conditional
*  branches with operand of form (x)+

	pifatal = tblini(
.	'aov[1]beq[1]bne[1]bge[1]bgt[1]bhi[1]ble[1]blo[1]'
.	'blt[1]bne[1]bnz[1]ceq[1]cne[1]mfi[1]nzb[1]zrb[1]')

*	trace not working for mvc (x32/x64)

	is_executable = table(100)
	s =
+       'add adi adr anb aov atn '
+	'bct beq bev bge bgt bhi ble blo blt bne bnz bod '
+       'brn bri bsw btw bze ceq chk chp cmb cmc cmp cne csc '
+       'cos ctb ctw cvd cvm dca dcv eti dvi dvr erb esw etx flc '
+       'ica icp icv ieq ige igt ile ilt ine ino iov itr jmp '
+       'jsr lch lct lcp lcw ldi ldr lei lnf lsh lsx mcb mfi mli mlr '
+       'mnz mov mti mvw mwb ngi eti ngr nzb orb plc prc psc '
+       'req rge rgt rle rlt rmi rne rno rov rsh rsx rti rtn sbi sbr '
+       'sch scp sin sqr ssl sss sti str sub tan trc wtb xob zer '
+       'zgb zrb'

*	don't trace mvc as doing so causes just 'end' to fail. sort out later. (ds 01/09/13)

is_exec.1
	s len(3) . opc ' ' =			:f(is_exec.2)
	is_executable[opc] = 1			:(is_exec.1)
is_exec.2

-stitl main program
*  here follows the driver code for the "main" program.


*  loop until program exits via g.end

*  opnext is invoked to initiate processing of the next line from
*  readline.
*  after doing this, opnext branches to the generator routine indicated
*  for this opcode if there is one.
*  the generators all have entry points beginning
*  with "g.", and can be considered a logical extension of the
*  opnext routine.  the generators have the choice of branching back
*  to dsgen to cause the thisstmt plex to be sent to outstmt, or
*  or branching to dsout, in which case the generator must output
*  all needed code itself.

*  the generators are listed in a separate section below.


*  get file name


* get definition file name following token file name, and flags.

*	filebase ? break(';:') . filebase len(1) (break(';:') | rem) . target
*+		((len(1) rem . flags) | '')
*	$replace(target,lcase,ucase) = 1

* parse and display flags, setting each one's name to non-null value (1).

 :(flgs.skip)
flgs	flags ? ((len(1) break(';:')) . flag len(1)) |
+	 ((len(1) rem) . flag) =			:f(flgs2)
	flag = replace(flag,lcase,ucase)
        output = "  flag: " flag
	$flag = 1					:(flgs)

flgs.skip
flgs2

* various constants

	tab = char(9)
        comment.delim = ';'

	w0_arg = minarg(8,'w0')
*  branchtab maps minimal opcodes 'beq', etc to desired
*  target instruction

	branchtab = table(10)
	branchtab['beq'] = 'je'
	branchtab['bne'] = 'jne'
	branchtab['bgt'] = 'ja'
	branchtab['bge'] = 'jae'
	branchtab['ble'] = 'jbe'
	branchtab['blt'] = 'jb'
	branchtab['blo'] = 'jb'
	branchtab['bhi'] = 'ja'

*  optim.tab flags opcodes capable of participating in or optimization
*		in outstmt routine

	optim.tab = table(10)
	optim.tab<"and"> = 1
	optim.tab<"add"> = 1
	optim.tab<"sub"> = 1
	optim.tab<"neg"> = 1
	optim.tab<"or"> = 1
	optim.tab<"xor"> = 1
	optim.tab<"shr"> = 1
	optim.tab<"shl"> = 1
	optim.tab<"inc"> = 1
	optim.tab<"dec"> = 1


*  ismem is table indexed by operand type which is nonzero if
*  operand type implies memory reference.

	ismem = array(30,0)
	ismem<3> = 1; ismem<4> = 1; ismem<5> = 1
	ismem<9> = 1; ismem<10> = 1; ismem<11> = 1
	ismem<12> = 1; ismem<13> = 1; ismem<14> = 1
	ismem<15> = 1

*  regmap maps minimal register name to target machine
*  register/memory-location name.

	regmap = table(30)
.if N
	regmap['xl'] = 'xl';  regmap['xt'] = 'xt'
	regmap['xr'] = 'xr';  regmap['xs'] = 'xs'
	regmap['wa'] = 'wa';  regmap['wb'] = 'wb'
	regmap['wc'] = 'wc';  regmap['ia'] = 'ia'
	regmap['cp'] = 'cp'
*	w0 is temp register
	regmap['w0'] = 'w0'
	w0 = regmap['w0']
*  quick reference:
	reg.wa = regmap['wa']
	reg.cp = regmap['cp']

* reglow maps register to identify target, so
* can extract 'l' part.
	reglow = table(4)
	reglow['wa'] = 'wa_l'
	reglow['wb'] = 'wb_l'
	reglow['wc'] = 'wc_l'

.fi
.if G
	s = 'xlXLxrXRxsXSxtXTwaWAwbWBwcWCw0W0iaIAcpCP'
regmap.loop
	s len(2) . min len(2) . reg =		:f(regmap.done)
	regmap[min] = reg			:(regmap.loop)
regmap.done

	w0 = regmap['w0']

*  quick reference:
	reg.xl = regmap['xl']
	reg.xr = regmap['xr']
	reg.xs = regmap['xs']
	reg.wa = regmap['wa']
	reg.wb = regmap['wa']
	reg.wc = regmap['wc']
	reg.cp = regmap['cp']
	reg.ia = regmap['ia']

* reglow maps register to identify target, so
* can extract 'l' part.
	reglow = table(4)
	reglow['wa'] = '%cl'
	reglow['wb'] = '%bl'
	reglow['wc'] = '%dl'
	reglow['w0'] = '%al'
.fi

* real_op maps minimal real opcode to machine opcode
	real_op = table(10)
	real_op['adr'] = 'fadd'
	real_op['atn'] = 'fpatan'
	real_op['chp'] = 'frndint'
	real_op['cos'] = 'fcos'
	real_op['dvr'] = 'fdiv'
	real_op['ldr'] = 'fld'
	real_op['mlr'] = 'fmul'
	real_op['ngr'] = 'fchs'
	real_op['sbr'] = 'fsub'
	real_op['sin'] = 'fsin'
	real_op['sqr'] = 'fsqrt'
	real_op['str'] = 'fst'

*  other definitions that are dependent upon things defined in the
*  machine definition file, and cannot be built until after the definition
*  file has been read in.

*  p.outstmt examines output lines for certain types of comment contructions
	fillc	  = (ident(compress) " ",tab)
	p.outstmt = (break(fillc) . label span(fillc)) . leader
+			comment.delim rem . comment
	p.alltabs = span(tab) rpos(0)

*  strip end of comments if y

	strip_comment = (differ(comments) 'n', 'y')

        output = ~input(.infile,1) "no input file"	:s(end)

inputok 



*  associate output files.

        output = ~output(.outfile,2) "no output file"	:s(end)
outputok


* open file for compilation of minimal err and erb messages

        output = ~output(.errfile,3) "no error file"	:s(end)
err_ok


*  The 'header' information, required for assembly, is copied
*  Copy the header information to the output file. The header
*  follows the 'end' statement in this program.
*  Note that the '-r' option must be given to spitbol for this to work.

	outlines = outlines + 1

	havehdr = 1
hdrcopy line = input				:f(hdrend)
	ident(line,'end')			:s(nohdr)
	outline(line)
						:(hdrcopy)
hdrend	havehdr =
nohdr

*  will have havehdr non-null if more remains to copy out at end.

*  read in pub file if it exists.  this contains a list of symbols to
*  be declared public when encountered.

	pubtab = table(2)
	input(.pubfile,5, filebase ".pub")		:f(nopub)
	pubtab = table(101)
pubcopy	line = pubfile				:f(pubend)
	pubtab[line] = 1			:(pubcopy)
pubend	endfile(5)
nopub

						:(dsout)
  &trace = 2000
  &ftrace = 1000
*  &profile = 1
dsout
opnext	thisline = readline()
	crack(thisline)				:f(dsout)
	op_ = incode '_'

* append ':' after label if in code or data.

* output label of executable instruction immediately if there is one,
* as it simplifies later processing, especially for tracing.
	ident(inlabel)				:s(opnext.1)
	thislabel = inlabel (differ(inlabel) ge(sectnow,3) ':',)
* keep the label as is is not in executable code
	lt(sectnow,5)				:s(opnext.1)
* here if in code, so output label now
* defer label processing for ent to allow emission of alignment ops for x86.
	ident(incode,'ent')			:s(opnext.1)
	outline(thislabel)
* set lastlabel so can check to avoid emitting duplicate label definitions
	lastlabel = thislabel
* clear out label info once generated
	label = thislabel =
opnext.1
	thislabel = inlabel (differ(inlabel) ge(sectnow,3) ':',)
	i1 = prsarg(iarg1)
	i2 = prsarg(iarg2)
	i3 = prsarg(iarg3)
	tcomment = comregs(incomment) '} ' incode ' ' i.text(i1) ' '
.		i.text(i2) ' ' i.text(i3)
	argerrs = 0
	differ(it_trace) ge(sectnow,5) eq(it_suspend) chktrace()
	ge(sectnow,5) chktrace()
						:($('g.' incode))
*  here if bad opcode
ds01	error('bad op-code')			:(dsout)

*  generate tokens.

ds.typerr
	error('operand type zero')		:(dsout)
-stitl comregs(line)t,pre,word
comregs
	line p.comregs =			:f(comregs1)
	word = eq(size(word),2) differ(t = regmap[word]) t
	comregs = comregs pre word		:(comregs)
comregs1 comregs = comregs line			:(return)
-stitl crack(line)
*  crack is called to create a stmt plex containing the various parts  of
* the minimal source statement in line.  for conditional assembly ops,
* the opcode is the op, and op1 is the symbol.  note that dtc is handled
*  as a special case to assure that the decomposition is correct.

*  crack prints an error and fails if a syntax error occurs.

crack   nstmts  = nstmts + 1
	op1 = op2 = op3 = typ1 = typ2 = typ3 =
	line    p.csparse			:s(return)
*  here on syntax error

	error('source line syntax error')	:(freturn)
-stitl error(text)
*  this module handles reporting of errors with the offending
*  statement text in thisline.  comments explaining
*  the error are written to the listing (including error chain), and
*  the appropriate counts are updated.

error   outline('* *???* ' thisline)
	outline('*       ' text)
.	          (ident(lasterror),'. last error was line ' lasterror)
	lasterror = outlines
	le(nerrors = nerrors + 1, 10)		:s(dsout)
        output = 'too many errors, quitting'  :(end)

-stitl genaop(stmt)
genaop

	astmts[astmts.n = astmts.n + 1] = stmt	:(return)
-stitl genbop(stmt)
genbop
	bstmts[bstmts.n = bstmts.n + 1] = stmt	:(return)

-stitl genlab(prefix)
*  generate unique labels for use in generated code
genlab	genlab = (differ(prefix) prefix,'')  '_' lpad(genlabels = genlabels + 1,4,'0') :(return)

-stitl genrip()
*  generate unique labels for use in generated code
genrip	genrip = 'r_' lpad(riplabels = riplabels + 1,4,'0') :(return)

-stitl genopl(gopl,gopc,gop1,gop2,gop3)
*  generate operation with label
genopl	cstmts[cstmts.n = cstmts.n + 1] =
.		tstmt(gopl,gopc,gop1,gop2,gop3)	:(return)

-stitl genop(gopc,gop1,gop2,gop3)
*  generate operation with no label
genop   genopl(,gopc,gop1,gop2,gop3)            :(return)


-stitl getarg(iarg)
getarg
*	imem is null to generate memory reference, otherwise just get
*	address for use in 'lea' instruction.
	pre = 'm('
	post = ')'	

	txt = i.text(iarg)
	typ = i.type(iarg)
	it_suspend = 1
	eq(typ)					:f($(argcase[typ]))
	getarg = txt				:(arg.done)

* int
arg.c.1 getarg = txt				:(arg.done)

* dlbl
arg.c.2 getarg = txt				:(arg.done)

* wlbl, clbl
arg.c.3
arg.c.4 getarg = pre txt post			:(arg.done)

* elbl, plbl
arg.c.5
arg.c.6 getarg = txt				:(arg.done)

* w,x, map register name
arg.c.7
arg.c.8
	getarg = regmap[txt]			:(arg.done)

* (x), register indirect
arg.c.9
	txt len(1) len(2) . typ
	typ = regmap[typ]
	getarg = pre typ post
						:(arg.done)

* (x)+, register indirect, post increment
* use lea reg,[reg+cfp_b] unless reg is esp, since it takes an extra byte.
* actually, lea reg,[reg+cfp_b] and add reg,cfp_b are both 2 cycles and 3 bytes
* for all the other regs, and either could be used.
arg.c.10
	txt = substr(txt,2,2)
	t1 = regmap[txt]
	getarg = pre t1 post
	(ident(txt,'xs') genaop(tstmt(,'add',t1,'cfp_b'))) :s(arg.done)
	genaop(tstmt(,'lea',t1,'a(' t1 '+cfp_b)'))	:(arg.done)

*  -(x), register indirect, pre decrement
arg.c.11
	t1 = regmap[substr(txt,3,2)]
	getarg = pre t1 post
	genbop(tstmt(,'lea',t1,'a(' t1 '-cfp_b)')) :(arg.done)

* int(x)
* dlbl(x)
arg.c.12
arg.c.13
	txt break('(') . t1 '(' len(2) . t2
	getarg = pre  '(cfp_b*' t1 ')+' regmap[t2]  post
							:(arg.done)

*  name(x), where name is in working section
arg.c.14
arg.c.15
	getarg = ne(rip_mode)	getrip(iarg)		:s(return)
	txt break('(') . t1 '(' len(2) . t2
	getarg = pre    t1 '+'  regmap[t2] 	post
							:(arg.done)
* signed integer
arg.c.16 getarg = txt				:(arg.done)

* signed real
arg.c.17 getarg = txt				:(arg.done)

arg.c.18
arg.c.19
arg.c.20
arg.c.21
arg.c.22
	getarg = getval(iarg)			:(arg.done)
*  pnam, eqop
arg.c.23
arg.c.24 getarg = txt				:(arg.done)

* ptyp, text, dtext
arg.c.25
arg.c.26
arg.c.27 getarg = txt				:(arg.done)
arg.done
	it_suspend = 0
*	ne(x_trace) outline('; arg ' typ ':' txt   ' -> ' getarg)
						:(return)

-stitl getlea(iarg)
getlea
*	similar to getarg, but gets effective address
*	this procedure only called if operand is
*	ops: 3,4,9,12,13,14,15
*	imem is null to generate memory reference, otherwise just get
*	address for use in 'lea' instruction.
	pre = 'a('
	post = ')'	

	txt = i.text(iarg)
	typ = i.type(iarg)
	eq(typ)					:f($(leacase[typ]))
	getlea = txt				:(return)
* wlbl, clbl
lea.c.3
lea.c.4 
	getlea = pre txt post			:(return)

* (x), register indirect
lea.c.9
	txt len(1) len(2) . typ
	typ = regmap[typ]
	getlea = pre typ post
						:(return)
* int(x)
* dlbl(x)
lea.c.12
lea.c.13
	txt break('(') . t1 '(' len(2) . t2
	getlea = pre  '(cfp_b*' t1 ')+' regmap[t2]  post
							:(return)

*  name(x), where name is in working section
lea.c.14
lea.c.15
	txt break('(') . t1 '(' len(2) . t2
	getlea = pre    t1 '+'  regmap[t2] 	post
							:(return)

-stitl getrip(iarg)
getrip
*  return value suitable for use in rip mode (needed for osx). This requires that we
*  allocate a variable to hold the address,value. This is loaded into w0
	pre = 'm('
	post = ')'	
	txt = i.text(iarg)
	typ = i.type(iarg)
	eq(typ)					:f($(ripcase[typ]))
	getrip = txt				:(rip.done)

*  name(x), where name is in working section
rip.c.14
rip.c.15
	txt break('(') . var '(' len(2) . reg
*	getrip = pre    var '+'  regmap[t2] 	post
	getrip = var 
						:(rip.done)
*  *dlbl
rip.c.19
	getrip = 'cfp_b*' substr(txt,2)		:(rip.done)

*  =dlbl
rip.c.18	
*  =name (data section)
rip.c.20
rip.c.21
*  =name (program section)
rip.c.22
        getrip =  substr(txt,2)   		:(rip.done)

rip.done
*  see if have generated location for argument with same txt. Use it if so, else make new one.
	ent = riptable[txt]
	differ(ent)				:s(rip.ent)
*  here to make new entry for generated location
	rip_count = rip_count + 1
	lbl = genrip()
	riptable[txt] = lbl
	ent = lbl
	gendata()
	genopl(lbl ':','d_word',getrip)
	gentext()
rip.ent
*	generate reference via w0 if needed
	genop('mov',w0,pre ent post)
	differ(reg)	genop('add',w0,reg)
	getrip = w0
*	outfile = ne(x_trace) '; getrip ' ent
						:(return)
	

-stitl getval(iarg)
getval
	pre = 'm('
	post = ')'	

	txt = i.text(iarg)
	typ = i.type(iarg)
	output = lt(typ, 18) gt(typ.22) ' impossible type for getval ' typ
	getval = ne(rip_mode) getrip(iarg)	:s(return)
	eq(typ)					:f($(valcase[typ]))
	getarg = txt				:(val.done)

*  =dlbl
val.c.18	
	getval = substr(txt,2)			:(val.done)
val.c.18.1
	getval = substr(txt,2)			:(val.done)
*  *dlbl
val.c.19
	getval = 'cfp_b*' substr(txt,2)		:(val.done)
*  =name (data section)
val.c.20
val.c.21
        getval =  substr(txt,2)			:(val.done)
*  =name (program section)
val.c.22
        getval =  substr(txt,2)			:(val.done)
val.done
						:(return)

-stitl memmem()t
memmem
*  memmem is called for those ops for which both operands may be
*  in memory, in which case, we generate code to load second operand
*  to pseudo-register w0, and then modify the second argument
*  to reference this register

  eq(ismem[i.type(i1)])				:s(return)
  eq(ismem[i.type(i2)])				:s(return)
*  here if memory-memory case, load second argument
  t = getarg(i2)
  i2 = w0_arg
  genop('mov',w0,t)				:(return)

-stitl outline(txt)
outline	
	outlines = outlines + 1		
	outfile = txt
						:(return)

-stitl prcent(n)
prcent prcent = 'prc_+cfp_b*' ( n - 1)	:(return)

-stitl outstmt(ostmt)label,opcode,op1,op2,op3,comment)
*  this module writes the components of the statement
*  passed in the argument list to the formatted .s file

outstmt	label = t.label(ostmt)
* clear label if definition already emitted
	label = ident(label, lastlabel)

outstmt1
	comment = t.comment(ostmt)
* ds suppress comments
 	comment = tcomment = comments =
 	:(outstmt2)
*  attach source comment to first generated instruction
	differ(comment)				:s(outstmt2)
	ident(tcomment)				:s(outstmt2)
	comment = tcomment; tcomment =
outstmt2
	opcode = t.opc(ostmt)
	op1 = t.op1(ostmt)
	op2 = t.op2(ostmt)
	op3 = t.op3(ostmt)
	differ(compress)			:s(outstmt3)
	stmtout = rpad( rpad(label,7) ' ' rpad(opcode,4) ' '
.		  (ident(op1), op1
.			(ident(op2), ',' op2
.				(ident(op3), ',' op3))) ,27)
.       (ident(strip_comment,'y'), ' ' (ident(comment), ';') comment)
.						:(outstmt4)
outstmt3
	stmtout = label tab opcode tab
.		  (ident(op1), op1
.		    (ident(op2), ',' op2
.		      (ident(op3), ',' op3)))
.       (ident(strip_comment,'y'), tab (ident(comment), ';') comment)

**	send text to outfile

**
outstmt4
**
**	send text to output file if not null.

*	stmtout = replace(trim(stmtout),'$','_')
	stmtout = trim(stmtout)
	ident(stmtout)				:s(return)
	outline(stmtout)
	ntarget	= ntarget + 1

*  record code labels in table with delimiter removed.
	(ge(sectnow,5) differ(thislabel))	:f(return)
	label ? break(':') . label		:f(return)
	labtab<label> = outlines		:(return)

-stitl  chktrace()
chktrace
	ident(i_trace)				:s(return)
	ne(it_suspend)				:s(return)
	clabel = inlabel
 	old_it_skip = it_skip
 	old_it_exec = it_exec
 	old_is_exec = is_exec
	it_skip = ident(inlabel,'s_aaa') 0

	is_exec = is_executable[incode]
	it_exec = differ(i_trace)  ident(inlabel, 's_aaa') 1
	it_exec = differ(i_trace) ge(sectnow,5) 1

 	it_skip  = differ(inlabel) differ(skip_on[inlabel]) 1
 	it_skip  = differ(inlabel) differ(skip_off[inlabel]) 0

	ne(it_skip)				:s(return)
	eq(it_exec)				:s(return)
	eq(is_exec)				:s(return)

*	ne(in_gcol)				:s(return)
chktrace.1
*	no trace if trace has been suspended

*	 only trace at label definition
*	ident(thislabel)			:s(return)

	it_count = it_count + 1

	gt(it_first) le(it_count,it_first)	:s(return)
	gt(it_limit)  gt(it_count, it_limit)	:s(return)
*	only trace an instruction once
	eq(nlines,nlast)			:s(return)
	nlast = nlines

	it_desc = '"' replace(thisline,'|',' ') '"'

	lbl = genlab('it')
	outline(tab 'segment' tab '.data')
	outline(lbl ':' tab 'd_char' tab it_desc)
	outline(tab 'd_char' tab '0');* string terminator
	outline(tab 'segment' tab '.text')
	outline(tab 'mov' tab w0 ',' lbl)
	outline(tab 'mov' tab 'm(it_de),' w0)
	outline(tab 'call' tab 'it_')
						:(return)

-stitl prsarg(iarg)
prsarg	prsarg = minarg(0)
	iarg break(',') . l1 ',' rem . l2	:f(return)
	prsarg = minarg(convert(l1,'integer'),l2)	:(return)
-stitl readline()
*  this routine returns the next statement line in the input file
*  to the caller.  it never fails.  if there is no more input,
*  then a minimal end statement is returned.
*  comments are passed through to the output file directly.


readline readline = infile                      :f(rl02)
	nlines  = nlines + 1
	ident( readline )			:s(readline)
readline.0
	leq( substr(readline,1,1 ),';' )       	:f(rl01)
	it_skip = ident(readline,';z+') 0	:s(readline)
*	it_skip = ident(readline,';z-') 1	:s(readline)
* force skip of full line comments
	:(readline)

*  only print comment if requested.

	ident(strip_comment,'n')		:f(readline)
        readline len(1) = ';'
	outlines = outlines + 1               :(readline)

*  here if not a comment line

rl01	
*  find out why need to add 2 here
*  add 2 since need to account for this line and one that will follow
	ne(x_trace) outline(';:' outlines + 2 ':' tab readline)
					:(return)

*  here on eof

rl02    readline = '       end'
						:(rl01)
-stitl ripinit()
*  initialize rip mode, allocating the table used to save allocated locations
ripinit
	riptable = table(500)
						:(return)

-stitl tblini(str)
*  this routine is called to initialize a table from a string of
*  index/value pairs.

tblini   pos     = 0

*  count the number of "[" symbols to get an assessment of the table
*  size we need.

tin01   str     (tab(*pos) '[' break(']') *?(cnt = cnt + 1) @pos)
.						:s(tin01)

*  allocate the table, and then fill it. note that a small memory
*  optimisation is attempted here by trying to re-use the previous
*  value string if it is the same as the present one.

	tblini   = table(cnt)
tin02   str     (break('[') $ index len(1) break(']') $ val len(1)) =
.						:f(return)
	val     = convert( val,'integer' )
	val     = ident(val,lastval) lastval
	lastval = val
	tblini[index] = val			:(tin02)
-stitl generators

ifreg	ge(i.type(iarg),7) le(i.type(iarg),8)
.						:f(freturn)s(return)

g.flc
	t1 = (eq(cfp_b,cfp_c) reglow[getarg(i1)], getarg(i1))
	t2 = genlab('flc')
*	it_suspend = 1
	genop('cmp',t1,"'A'")
	genop('jb', t2 )
	genop('cmp',t1,"'Z'")
	genop('ja', t2)
	genop('add',t1,'32')
        genopl(t2 ':')
*	it_suspend = 0
						:(opdone)

g.mov
*  perhaps change mov x,(xr)+ to
*	mov ax,x; stows

*  perhaps do  mov (xl)+,wx as
*	lodsw
*	xchg ax,tx
*  and also mov (xl)+,name as
*	lodsw
*	mov name,w0
*  need to process memory-memory case
*  change 'mov (xs)+,a' to 'pop a'
*  change 'mov a,-(xs)' to 'push a'
        i.src = i2; i.dst = i1
	t.src = i.text(i.src); t.dst = i.text(i.dst)
	ident(t.src,'(xl)+')			:s(mov.xlp)
	ident(t.src,'(xt)+')			:s(mov.xtp)
	ident(t.src,'(xs)+')			:s(mov.xsp)
	ident(t.dst,'(xr)+')			:s(mov.xrp)
	ident(t.dst,'-(xs)')			:s(mov.2)
	memmem()
	genop('mov',getarg(i1),getarg(i2))
						:(opdone)
mov.xtp
mov.xlp
	ident(t.dst,'(xr)+') genop('movs_w')	:s(opdone)
	genop('lods_w')
	ident(t.dst,'-(xs)') genop('push',w0)	:s(opdone)
	genop('mov',getarg(i.dst),w0)		:(opdone)
mov.xsp
	ident(t.dst,'(xr)+')		:s(mov.xsprp)
	genop('pop',getarg(i.dst))		:(opdone)
mov.xsprp genop('pop',w0)
	genop('stos_w')				:(opdone)
mov.xrp genop('mov',w0,getarg(i.src))
	genop('stos_w')				:(opdone)
mov.2
	genop('push',getarg(i.src))		:(opdone)

* odd/even tests.  if w reg, use low byte of register.
g.bod	t1 = getarg(i1)
 	t1 = eq(i.type(i1),8) reglow[t1]
	genop('test',t1,'1')
	genop('jne',getarg(i2))			:(opdone)

g.bev	t1 = getarg(i1)
	t1 = eq(i.type(i1),8) reglow[t1]
	genop('test',t1,'1')
	genop('je',getarg(i2))
						:(opdone)

g.brn   genop('jmp',getarg(i1))			:(opdone)

g.bsw	t1 = getarg(i1)
	t2 = genlab('bsw')
	it_suspend = 1
	ident(i.text(i3))			:s(g.bsw1)
	genop('cmp',t1,getarg(i2))
	genop('jge',getarg(i3))
* here after default case.
g.bsw1	
	ne(rip_mode)				:s(g.bsw.2)	
	genop('jmp', 'm(' t2 '+' t1 '*cfp_b)' ) :(g.bsw.3)
g.bsw.2
* in rip_mode, need to generate location to reference destination
	lbl = genrip()
        gendata()
	genopl(lbl,'d_word',t2 )
	gentext()
	genop('mov',w0,t1)
	genop('sal',w0,'log_cfp_b')
	genop('add',w0,'m(' lbl ')')
	genop('jmp', w0)
g.bsw.3
	gendata()
        genopl(t2 ':')
	it_suspend = 0
						:(opdone)

g.iff   genop('d_word',getarg(i2))              :(opdone)

g.esw
        gentext()				:(opdone)
g.ent

*  entry points are stored in byte before program entry label
*  last arg is optional, in which case no initial 'db' need be
*  issued. we force odd alignment so can distinguish entry point
*  addresses from block addresses (which are always even).

*  note that this address of odd/even is less restrictive than
*  the minimal definition, which defines an even address as being
*  a multiple of cfp_b (4), and an odd address as one that is not
*  a multiple of cfp_b (ends in 1, 2, or 3).  the definition here
*  is a simple odd/even, least significant bit definition.
*  that is, for us, 1 and 3 are odd, 2 and 4 are even.


	t1 = i.text(i1)
*        genop('align',2)
	outline(tab 'align' tab '2')
	differ(t1)				:s(g.ent.1)
	outline(tab 'nop')
						:(g.ent.2)
g.ent.1
	outline(tab 'db' tab	t1)

g.ent.2
	genopl(thislabel)
*  note that want to attach label to last instruction
*	t1 = cstmts[cstmts.n]
*	t.label(t1) = tlabel
*	cstmts[cstmts.n] = t1
*  here to see if want label made public
	thislabel ? rtab(1) . thislabel ':'
        (differ(pubtab[thislabel]), differ(debug)) genop('global',thislabel)
	thislabel =				:(opdone)

g.bri	genop('jmp',getarg(i1))			:(opdone)

g.lei	t1 = regmap[i.text(i1)]
	genop('movzx',t1,'byte [' t1 '-1]' )	:(opdone)

g.jsr
	jsr_proc = getarg(i1)
	genop('call',jsr_proc)
*	get count of following ppm statements
	jsr_count = ppm_cases[jsr_proc]
	eq(jsr_count)				:s(opdone)
	it_suspend = 1
	jsr_calls = jsr_calls +  1
	jsr_label = 'call_' jsr_calls
	jsr_label_norm = jsr_label
	genop('dec','m(' rcode ')')
	genop('js',jsr_label_norm)
	it_suspend = 0

*	generate branch around for ppms that will follow
*	take the branch if normal return (eax==0)
						:(opdone)

g.err
g.ppm

*  here with return code in rcode. it is zero for normal return
*  and positive for error return. decrement the value.
*  if it is negative then this is normal return. otherwise,
*  proceed decrementing rcode until it goes negative,and then
*  take the appropriate branch.

	t1 = getarg(i1)

*  branch to next case if rcode code still not negative.
	ident(incode,'ppm')			:s(g.ppm.loop)
	count.err =  count.err + 1
	errfile =   i.text(i1) ' ' i.text(i2)
	max.err = gt(t1,max.err) t1
						:(g.ppm.loop)

g.ppm.loop.next
	genopl(lab_next ':')
 	jsr_count = jsr_count - 1
 	it_suspend = eq(jsr_count) 0
	eq(jsr_count) genopl(jsr_label_norm ':') :(opdone)
g.ppm.loop
	lab_next = genlab('ppm')
	genop('dec','m(' rcode ')' )
	genop('jns',lab_next)
	ident(incode,'ppm')			:s(g.ppm.loop.ppm)
*  here if error exit via exi. set rcode to exit code and jump
*  to error handler with error code in rcode
g.ppm.loop.err
	genop('mov','m(' rcode ')', +t1)
	genop('jmp','err_')
						:(g.ppm.loop.next)
g.ppm.loop.ppm
*	check each ppm case and take branch if appropriate
	ident(i.text(i1))			:s(g.ppm.2)
	count.ppm = count.ppm + 1
	genop('jmp',	getarg(i1))
						:(g.ppm.loop.next)

g.ppm.2
*  a ppm with no arguments, which should never be executed, is
*  translated to err 299,internal logic error: unexpected ppm branch
	t1 = 299
	errfile =  t1 ' internal logic error: unexpected ppm branch'
						:(g.ppm.loop.err)

g.prc

*  generate public declaration
*	t1 = thislabel
*	t1 ? rtab(1) . t1 ':'
*	genop()
*	genop('global',t1)
*  nop needed to get labels straight
	prc.args = getarg(i2)
	ppm_cases[thislabel] = i.text(i2)
	thislabel =
	max_exi = gt(prc.args,max_exi) prc.args
	prc.type = i.text(i1)			:($('g.prc.' prc.type))
g.prc.e
g.prc.r						:(opdone)

g.prc.n
*  store return address in reserved location
	prc.count = prc.count + 1
	genop('pop', 'm(' prcent(prc.count) ')')	:(opdone)

g.exi
        t1 = getarg(i1); t2 = prc.type; t3 = i.text(i1)
*  if type r or e, and no exit parameters, just return
 	differ(t2,'n') eq(prc.args)	genop('ret')	:s(opdone)
        t3 = ident(t3) '0'
    	genop('mov','m('  rcode ')',+t3)
	ident(t2,'n')				:s(g.exi.1)
	genop('ret')				:(opdone)
g.exi.1

	genop('mov',w0, 'm( ' prcent(prc.count) ')' )
	genop('jmp',w0)
						:(opdone)
g.enp   genop()					:(opdone)

g.erb
	errfile =  i.text(i1) ' ' i.text(i2)
*	set rcode to error code and branch to error handler
	genop('mov', 'm(' rcode ')',  +(i.text(i1)))
 	genop('jmp','err_')
						:(opdone)


g.icv   genop('inc',getarg(i1))    :(opdone)
g.dcv   genop('dec',getarg(i1))    :(opdone)

g.zer	ident(i.text(i1),'(xr)+') genop('mov',w0,'0')
+		genop('stos_w')			:s(opdone)
	ifreg(i1)				:s(g.zer1)
	ident(i.text(i1),'-(xs)')		:s(g.zer.xs)
	genop('mov',w0,'0')
	genop('mov',getarg(i1),w0)		:(opdone)
g.zer1	t1 = getarg(i1)
	genop('xor',t1,t1)			:(opdone)
g.zer.xs genop('push','0')			:(opdone)

g.mnz   genop('mov',getarg(i1),'xs')		:(opdone)

g.ssl
g.sss
g.rtn
	genop()					:(opdone)

g.add	memmem()
	genop('add',getarg(i1),getarg(i2))	:(opdone)

g.sub	memmem()
	genop('sub',getarg(i1),getarg(i2))	:(opdone)

g.ica   genop('add',getarg(i1),'cfp_b')		:(opdone)

g.dca   genop('sub',getarg(i1),'cfp_b')		:(opdone)

g.beq
g.bne
g.bgt
g.bge
g.blt
g.ble
g.blo
g.bhi

*  these operators all have two operands, memmem may apply
*  issue target opcode by table lookup.

	memmem()
	t1 = branchtab[incode]
	genop('cmp',getarg(i1),getarg(i2))
	genop(branchtab[incode],getarg(i3))
.						:(opdone)

g.bnz
	ifreg(i1)				:s(g.bnz1)
        genop('cmp', getarg(i1) ,'0')
	genop('jnz',getarg(i2))
						:(opdone)
g.bnz1
	genop('or',getarg(i1),getarg(i1))
	genop('jnz',getarg(i2))
						:(opdone)

g.bze   ifreg(i1)				:s(g.bze1)
        genop('cmp', getarg(i1)  ,'0')
	genop('jz',getarg(i2))
						:(opdone)
g.bze1
	t1 = getarg(i1)
	genop('or',t1,t1)
	genop('jz',getarg(i2))			:(opdone)

g.lct

*  if operands differ must emit code

	differ(i.text(i1),i.text(i2))		:s(g.lct.1)
*  here if operands same. emit no code if no label, else emit null
	ident(thislabel)			:s(opnext)
	genop()					:(opdone)

g.lct.1	genop('mov',getarg(i1),getarg(i2))	:(opdone)

g.bct
*  can issue loop if target register is cx.
	t1 = getarg(i1)
	t2 = getarg(i2)
	:(g.bct2)
	ident(t1,'wa')				:s(g.bct1)
g.bct2
	genop('dec',t1)
	genop('jnz',t2)				:(opdone)
g.bct1
	genop('loop',t2)			:(opdone)

g.aov
	genop('add',getarg(i2),getarg(i1))
	genop('jc',getarg(i3))
						:(opdone)
g.lcp
g.lcw
g.scp
	genop(op_,getarg(i1))			:(opdone)

*  use cp for code pointer.
	genop('mov',reg.cp,getarg(i1))
						:(opdone)

	genop('mov',getarg(i1),reg.cp)
						:(opdone)
*  should be able to get lodsd; xchg eax,getarg(i1)
	genop('mov',getarg(i1),m(reg.cp))
	genop('add',reg.cp,'cfp_b')

						:(opdone)


g.icp
	genop(op_)				:(opdone)
	genop('add',reg.cp,'cfp_b')
						:(opdone)
*  integer accumulator kept in wdx (wc)
g.ldi
g.sti
	genop(op_,getarg(i1))			:(opdone)
g.adi
g.mli
g.sbi
g.dvi
g.rmi
	genop(op_,getarg(i1))			:(opdone)

g.ngi
	genop(op_)				:(opdone)

g.ino
g.iov
	genop(op_,getarg(i1))			:(opdone)


g.ieq	jop = 'je'				:(op.cmp)
g.ige	jop = 'jge'				:(op.cmp)
g.igt	jop = 'jg'				:(op.cmp)
g.ile	jop = 'jle'				:(op.cmp)
g.ilt	jop = 'jl'				:(op.cmp)
g.ine	jop = 'jne'				:(op.cmp)
op.cmp
	genop('sti_',w0)
	genop('or',w0,w0)
	genop(jop,getarg(i1))			:(opdone)

*  real operations

g.itr	genop('call','itr_')	:(opdone)

g.rti	genop('rti_')
	eq(i.type(i1))				:s(opdone)
*  here if label given, branch if real too large
        genop('jc',getarg(i1))                 :(opdone)

g.ldr
g.str
g.adr
g.sbr
g.mlr
g.dvr
	genop('lea',w0,getlea(i1))
	genop('call',op_)
						:(opdone)
g.ngr
g.atn
g.chp
g.cos
g.etx
g.lnf
g.sin
g.sqr
g.tan
	genop('call',op_)
						:(opdone)

g.rov
g.rno	genop(op_,getarg(i1))			:(opdone)
*g.rno	t1 = 'jno'				:(g.rov1)
*g.rov	t1 = 'jo'
*g.rov1  genop('call','ovr_')
	genop(t1,getarg(i1))			:(opdone)

g.req	jop = 'je'				:(g.r1)
g.rne	jop = 'jne'				:(g.r1)
g.rge	jop = 'jge'				:(g.r1)
g.rgt	jop = 'jg'				:(g.r1)
g.rle	jop = 'jle'				:(g.r1)
g.rlt	jop = 'jl'
g.r1	genop('call','cpr_')
	genop('mov','al','byte [reg_fl]')
	genop('or','al','al')
	genop(jop,getarg(i1))			:(opdone)

g.plc
g.psc
	ne(cfp_b,cfp_c)				:s(g.plc.1)
*  last arg is optional.  if present and a register or constant,
*  use lea instead.

	t1 = getarg(i1)
	t2 = i.type(i2)
	((ifreg(i2), ge(t2,1) le(t2,2))
+	genop('lea',t1,'a(cfp_f+' t1 '+' getarg(i2) ')')) :s(opdone)
	genop('add',t1,'cfp_f')
	eq(i.type(i2))				:s(opdone)

*  here if d_offset_(given (in a variable), so add it in.

	genop('add',t1,getarg(i2))		:(opdone)

g.plc.1
*  here for case where character size if word size
*  last arg is optional.  if present and a register or constant,
*  use lea instead.

	t1 = getarg(i1)
	t2 = i.type(i2)
	((ifreg(i2), ge(t2,1) le(t2,2))
+	genop('lea',t1,'a(cfp_f+' t1 '+' 'cfp_b*' getarg(i2) ')')) :s(opdone)
	genop('add',t1,'cfp_f')
	eq(i.type(i2))				:s(opdone)

*  here if d_offset_(given (in a variable), so add it in, after converting to byte count
	genop('mov','w0', getarg(i2))
	genop('sal','w0', 'log_cfp_b')

	genop('add',t1,'w0')		:(opdone)

*  lch requires separate cases for each first operand possibility.

g.lch
	t2 = i.text(i2)
	t1 = getarg(i1)

*  see if predecrement needed.
	leq('-',substr(t2,1,1))			:f(g.lcg.1)
	t2 break('(') len(1) len(2) . t3
	(eq(cfp_b,cfp_c) genop('dec',regmap[t3]), genop('sub',regmap[t3],'cfp_b'))
g.lcg.1
	t2 break('(') len(1) len(2) . t3
	eq(cfp_b,cfp_c) genop('mov',w0,'0')
	eq(cfp_b,cfp_c) genop('mov','al','m_char [' regmap[t3] ']')
	eq(cfp_b,cfp_c) genop('mov',t1,w0)

	ne(cfp_b,cfp_c) genop('mov',t1,'m_char [' regmap[t3] ']')

*  see if postincrement needed.
	t2 rtab(1) '+'				:f(g.lcg.2)
	(eq(cfp_b,cfp_c) genop('inc',regmap[t3]), genop('add',regmap[t3],'cfp_b'))
g.lcg.2						:(opdone)

g.sch
	t2 = i.text(i2)
	eq(i.type(i1),8)			:s(g.scg.w)
	t1 = getarg(i1)
	eq(cfp_b,cfp_w)				:f(g.scg.0)
	ident(t2,'(xr)+')			:f(g.scg.0)

*  here if can use stos.

	eq(cfp_b,cfp_c) genop('mov','al',getarg(i1))
	ne(cfp_b,cfp_c) genop('mov','eax',getarg(i1))
	genop('stos_b')				:(opdone)

g.scg.0
	leq('-',substr(t2,1,1))			:f(g.scg.1)
	t2 break('(') len(1) len(2) . t3
	genop('dec',regmap[t3])
	(eq(cfp_b,cfp_c) genop('dec',regmap[t3]), genop('sub',regmap[t3],'cfp_b'))
g.scg.1
	t2 break('(') len(1) len(2) . t3
	eq(cfp_b,cfp_c) genop('mov',w0,t1,)
	eq(cfp_b,cfp_c) genop('mov','[' regmap[t3] ']','al')
	ne(cfp_b,cfp_c) genop('mov','m_char [' regmap[t3] ']',t1)
*  see if postincrement needed.
	t2 rtab(1) '+'				:f(g.scg.2)
	(eq(cfp_b,cfp_c) genop('inc',regmap[t3]), genop('add',regmap[t3],'cfp_b'))
g.scg.2						:(opdone)
g.scg.w

*  here if moving character from work register, convert t1
*  to name of low part.

	t1 = (eq(cfp_b,cfp_c) reglow[getarg(i1)], getarg(i1))

	ident(t2,'(xl)')			:s(g.scg.w.xl)
	ident(t2,'-(xl)')			:s(g.scg.w.pxl)
	ident(t2,'(xl)+')			:s(g.scg.w.xlp)
	ident(t2,'(xr)')			:s(g.scg.w.xr)
	ident(t2,'-(xr)')			:s(g.scg.w.pxr)
	ident(t2,'(xr)+')			:s(g.scg.w.xrp)
g.scg.w.xl
	genop('mov','m_char [xl]',t1)		:(opdone)
g.scg.w.pxl
	(eq(cfp_b,cfp_c)  genop('dec', 'xl'), genop('sub','xl', 'cfp_b'))
	genop('mov','m_char [xl]',t1)			:(opdone)

g.scg.w.xlp
	genop('mov','m_char [xl]',t1)
	(eq(cfp_b,cfp_c)  genop('inc', 'xl'), genop('add','xl', 'cfp_b'))
						:(opdone)
g.scg.w.xr
	genop('mov','m_char [xr]',t1)			:(opdone)

g.scg.w.pxr
	(eq(cfp_b,cfp_c)  genop('dec', 'xr'), genop('sub','xr', 'cfp_b'))
	genop('mov','m_char [xr]',t1)			:(opdone)
g.scg.w.xrp
	(eq(cfp_b,cfp_c) genop('mov','al',t1), genop('mov','eax',t1))
	genop('stos_b')				:(opdone)

g.csc  	ident(thislabel)			:s(opnext)
	genop()					:(opdone)

g.ceq
	memmem()
	genop('cmp',getarg(i1),getarg(i2))
	genop('je',getarg(i3))
						:(opdone)

g.cne   memmem()
	genop('cmp',getarg(i1),getarg(i2))
	genop('jnz',getarg(i3))
						:(opdone)

g.cmc
	genop('repe','cmps_b')
	genop('mov','xl','0')
	genop('mov','xr','xl')
	t1 = getarg(i1)
	t2 = getarg(i2)
	(ident(t1,t2) genop('jnz',t1))		:s(opdone)
	genop('ja',t2)
	genop('jb',t1)				:(opdone)

g.trc
	genop('xchg','xl','xr')
        eq(cfp_b,cfp_c) genopl((t1 = genlab('trc')) ':','movzx',w0,'m_char [xr]')
        ne(cfp_b,cfp_c) genopl((t1 = genlab('trc')) ':','mov',w0,'m_char [xr]')
	ne(cfp_b,cfp_c) genop('sal', w0, 'log_cfp_b');* convert char value to byte offset
	eq(cfp_b,cfp_c) genop('mov','al','[xl+w0]')
	ne(cfp_b,cfp_c) genop('mov','eax','[xl+w0]')
	genop('stos' op_c)
*	genop('loop',t1)
	genop('dec','wa')
	genop('jnz',t1)
	genop('xor','xl','xl')
	genop('xor','xr','xr')
						:(opdone)

g.anb   genop('and',getarg(i1),getarg(i2))	:(opdone)
g.orb   genop('or',getarg(i1),getarg(i2))	:(opdone)
g.xob   genop('xor',getarg(i1),getarg(i2))	:(opdone)
g.cmb   genop('not',getarg(i1))			:(opdone)

g.rsh
	genop('shr',getarg(i1),getarg(i2))	:(opdone)

g.lsh
	genop('shl',getarg(i1),getarg(i2))	:(opdone)

g.rsx
	error('rsx not supported')
g.lsx
	error('lsx not supported')

g.nzb	ifreg(i1)				:s(g.nzb1)
	genop('cmp',getarg(i1),'0')
	genop('jnz',getarg(i2))
						:(opdone)
g.nzb1
	genop('or',getarg(i1),getarg(i1))
	genop('jnz',getarg(i2))
						:(opdone)

g.zrb	ifreg(i1)				:s(g.zrb1)
	genop('cmp',getarg(i1),'0')
	genop('jz',getarg(i2))
						:(opdone)
g.zrb1
	genop('or',getarg(i1),getarg(i1))
	genop('jz',getarg(i2))
						:(opdone)

g.zgb
	genop('nop')				:(opdone)

g.zzz
 	genop('zzz',getarg(i1))			:(opdone)

g.wtb   genop('sal',getarg(i1),'log_cfp_b')	:(opdone)

g.btw   genop('shr',getarg(i1),'log_cfp_b')	:(opdone)


g.mti	ident(i.text(i1),'(xs)+')		:f(g.mti.1)
	genop('pop',w0)
	genop('ldi_',w0)			:(opdone)
g.mti.1
	genop('ldi_',getarg(i1))		:(opdone)

g.mfi
*  last arg is optional
*  compare with cfp$m, branching if result negative
	eq(i.type(i2))				:s(g.mfi.1)
*  here if label given, branch if wc not in range (ie, negative)
	genop('sti_',w0)
	genop('or',w0,w0)
	genop('js',getarg(i2))
g.mfi.1
	ident(i.text(i1),'-(xs)')		:s(g.mfi.2)
	genop('sti_',getarg(i1))		:(opdone)
g.mfi.2
	genop('sti_',w0)
	genop('push',w0)			:(opdone)

g.ctw
*  assume cfp_c chars per word
	t1 = getarg(i1)
	eq(cfp_b,cfp_c)				:s(g.ctw.1)
*  here if one word per character, so just add character count
	genop('add',t1,i.text(i2))
						:(opdone)
g.ctw.1
	genop('add',t1,'(cfp_c-1)+cfp_c*' i.text(i2))
	genop('shr',t1,'log_cfp_c')
					:(opdone)
g.ctb
	t1 = getarg(i1)
	eq(cfp_b,cfp_c)				:s(g.ctb.1)
*  here if one word per character, so just add character count, then convert to byte count
	genop('add',t1,i.text(i2))
        genop('sal',getarg(i1),'log_cfp_b')	:(opdone)
g.ctb.1
	genop('add',t1,'(cfp_b-1)+cfp_b*' i.text(i2))
	genop('and',t1,'-cfp_b')
						:(opdone)
g.cvm	t1 = getarg(i1)
	genop('sti_',w0)
	genop('imul',w0,'10')
	genop('jo',t1)
	genop('sub',regmap['wb'],'ch_d0')
	genop('sub',w0,regmap['wb'])
	genop('ldi_',w0)
	genop('jo',t1)
						:(opdone)
g.cvd
	genop('cvd_')				:(opdone)
g.mvc
	t1 = genlab('mvc')
	it_suspend = 1
	genop('rep')
	genop('movs_b')
	it_suspend = 0
						:(opdone)
g.mvw
*	it_suspend = 1
	genop('shr','wa','log_cfp_b')
 	genop('rep','movs_w')
*	it_suspend = 0
						:(opdone)

g.mwb
	genop('shr','wa','log_cfp_b')
	genop('std')
	genop('lea','xl','a(xl-cfp_b)')
	genop('lea','xr','a(xr-cfp_b)')
 	genrep('movs_w')
	genop('cld')				:(opdone)

	genop('std')
	genop('shr','wa','log_cfp_b')
	genop('rep')
	genop('movs_w')
	genop('ctd')
						:(opdone)

g.mcb
*	use word move if character size is word size
	ne(cfp_b,cfp_c) genop('shl', 'wa', 'log_cfp_b')
	ne(cfp_b,cfp_c)				:s(g.mwb)
	genop('std')
	genop('dec','xl')
	genop('dec','xr')
 	genrep('movs_b')
	genop('cld')
						:(opdone)
	genop('std')
	genop('rep')
	genop('movs_b')
	genop('cld')
						:(opdone)
genrep
*	generate equivalent of rep op loop
	l1 = genlab('rep')
	l2 = genlab('rep')
	genopl(l1 ':')
	genop('or','wa','wa')
	genop('jz',l2)
	genop(op)
	genop('dec','wa')
	genop('jmp',l1)
	genopl(l2 ':')
						:(return)
-stitl	gendata() - move to data segment
gendata
	genop('segment','.data')		:(return)

-stitl	gentext() - move to text segment
gentext
	genop('segment','.text')		:(return)

g.chk
	genop('chk_')
	genop('or',w0,w0);
	genop('jne','sec06')			:(opdone)

decend
*  here at end of dic or dac to see if want label made public
	thislabel ? rtab(1) . thislabel ':'
        differ(pubtab[thislabel]) genop('global',thislabel)
						:(opdone)

g.dac	t1 = i.type(i1)
        t2 = "" ;*(le(t1,2) "", le(t1,4) "d_offset_(", le(t1,6) "d_offset_(", "")
        genopl(thislabel,'d_word',t2 i.text(i1))
						:(decend)
g.dic   genopl(thislabel,'d_word',i.text(i1))
						:(decend)

g.drc
*	genop('align','cfp_b')
	genop('align',8)
	t1 = i.text(i1)
	t1 ? fence "+" = ""
        genop('d_real',t1)
*  note that want to attach label to last instruction
	t.label(cstmts[cstmts.n]) = thislabel
	thislabel =				:(opdone)

g.dtc
*  change first and last chars to " (assume / used in source)
	t1 = i.text(i1)
	t1 tab(1) rtab(1) . t2
	t3 = remdr(size(t2),cfp_c)
*        t2 = "'" t2 "'"
*  append nulls to complete last word so constant length is multiple
*  of word word
	dtc_i = 1
	t4 =
g.dtc.1
	t4 = gt(dtc_i, 1) t4 ","
	t4 = t4 "'" substr(t2,dtc_i,1) "'"
	le(dtc_i = dtc_i + 1, size(t2))		:s(g.dtc.1)

        t4 = ne(t3) t4 dupl(',0',cfp_c - t3)
        genopl(thislabel,'d_char',t4)
						:(opdone)
g.dbc   genopl(thislabel,'d_word',getarg(i1))
						:(opdone)
g.equ   genopl(thislabel,'equ',i.text(i1))
						:(opdone)
g.exp
	ppm_cases[thislabel] = i.text(i1)
	genop('extern',thislabel)
	thislabel =				:(opdone)

g.inp
	ppm_cases[thislabel] = i.text(i2)
	prc.count1 = ident(i.text(i1),'n') prc.count1 + 1
+						:(opnext)

g.inr						:(opnext)

g.ejc	genop('')				:(opdone)

g.ttl	genop('')
						:(opdone)

g.sec	genop('')
	sectnow = sectnow + 1			:($("g.sec." sectnow))

* procedure declaration section
g.sec.1 gentext()
        genop('global','sec01')
        genopl('sec01' ':')             	:(opdone)

* definitions section
g.sec.2
        gendata()
        genop('global','sec02')
        genopl('sec02' ':')             	:(opdone)

* constants section
g.sec.3
        gendata()
        genop('global','sec03')
        genopl('sec03' ':')     		:(opdone)

* working variables section
g.sec.4 genop('global','esec03')
        genopl('esec03' ':')
        gendata()
        genop('global','sec04')
        genopl('sec04' ':')     
						:(opdone)

*  here at start of program section.  if any n type procedures,
*  put out entry-word block declaration at end of working storage
g.sec.5
*  emit code to indicate in code section
*  get direction set to up.
        genop('global','esec04')
        genopl('esec04' ':')
*        (gt(prc.count1) genopl('prc$' ':','times', prc.count1 ' dd 0'))
	genop('prc_: times ' prc.count1 ' dd 0')
        genop('global','end_min_data')
        genopl('end_min_data' ':')
        gentext()
        genop('global','sec05')
        genopl('sec05' ':')     
*  enable tracing if desired
						:(opdone)

*  stack overflow section.  output exi__n tail code
g.sec.6
        genop('global','sec06')
        genopl('sec06'  ':', 'nop')
				             :(opdone)

*  error section.  produce code to receive erb's
g.sec.7
        genop('global','sec07')
        genopl('sec07' ':')
	flush()
*  error section.  produce code to receive erb's

*	allow for some extra cases in case of max.err bad estimate
	n1 = max.err + 8
	genopl('err_:','xchg',reg.wa,'m(' rcode ')')
						:(opdone)


opdone	flush()					:(opnext)

*  here to emit bstmts, cstmts, astmts. attach input label and
*  comment to first instruction generated.

flush	eq(astmts.n) eq(bstmts.n) eq(cstmts.n)	:f(opdone1)

*  here if some statements to emit, so output single 'null' statement to get label
*  and comment field right.

	label = thislabel =
	outstmt(tstmt())			:(opdone.6)
opdone1	eq(bstmts.n)				:s(opdone.2)
	i = 1
opdone.1
	outstmt(bstmts[i])
	le(i = i + 1, bstmts.n)			:s(opdone.1)

opdone.2	eq(cstmts.n)			:s(opdone.4)
	i = 1
opdone.3
	outstmt(cstmts[i])
	le(i = i + 1, cstmts.n)			:s(opdone.3)

opdone.4	eq(astmts.n)			:s(opdone.6)
	i = 1
	ident(pifatal[incode])			:s(opdone.5)
*  here if post incrementing code not allowed
	error('post increment not allowed for op ' incode)
opdone.5	outstmt(astmts[i])
	le(i = i + 1, astmts.n)			:s(opdone.5)
opdone.6 astmts.n = bstmts.n = cstmts.n =	:(return)
flush_end

report
	output = lpad(num,7) tab text		:(return)


g.end
	&dump = 0
	ident(havehdr)				:s(g.end.2)
*  here to copy remaining part from hdr file
g.end.1	line = hdrfile				:f(g.end.2)
	ntarget = ntarget + 1
	outline(line)				:(g.end.1)
g.end.2

* here at end of code generation.

	endfile(1)
	endfile(2)
	endfile(3)
        report(nlines,		'lines read')
        report(nstmts,		'statements processed')
        report(ntarget,		'target code lines produced')
	report(&stcount,	'spitbol statements executed')
        report(max.err,		'maximum err/erb number')
        report(prc.count1, 	'prc count')
        output  = '  ' gt(prc.count,prc.count1)
.	  'differing counts for n-procedures:'
.	  ' inp ' prc.count1 ' prc ' prc.count
        differ(nerrors) report(nerrors,'errors detected')

	errfile = '* ' max.err 'maximum err/erb number'
	errfile  = '* ' prc.count 'prc count'
.		differ(lasterror) '  the last error was in line ' lasterror

	&code   = ne(nerrors) 2001
        report(collect(), 'free words')
	report(time(),'execution time ms')
	:(end)
end
; copyright 1987-2012 robert b. k. dewar and mark emmer.
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
        section	.text

	%include	"nasm.h"

	global	dnamb
	global	dname
	extern	osisp
	extern	compsp
	extern	save_regs
	extern	restore_regs
	extern	_rc_
	extern	reg_fl
	extern	reg_cp
	extern	reg_w0

	global	mxint

;%ifdef it_trace
	extern	shields
	extern	it_
	extern	id_de
	extern	it_cp
	extern	it_xl
	extern	it_xr
	extern	it_xs
	extern	it_wa
	extern	it_wb
	extern	it_wc
	extern	it_w0
	extern	it_it
	extern	it_id
	extern	it_de
	extern	it_0
	extern	it_1
	extern	it_2
	extern	it_3
	extern	it_4
	extern	it_arg
	extern	it_num
;%endif
	global	start


	%macro	itz	1
	section	.data
%%desc:	db	%1,0
	section	.text
	mov	m_word [it_de],%%desc
	call	it_
	%endmacro
;
;
;   table to recover type word from type ordinal
;

	extern	_rc_
	global	typet
	section .data

        d_word	b_art   ; arblk type word - 0
        d_word	b_cdc   ; cdblk type word - 1
        d_word	b_exl   ; exblk type word - 2
        d_word	b_icl   ; icblk type word - 3
        d_word	b_nml   ; nmblk type word - 4
        d_word	p_aba   ; p0blk type word - 5
        d_word	p_alt   ; p1blk type word - 6
        d_word	p_any   ; p2blk type word - 7
; next needed only if support real arithmetic cnra
;       d_word	b_rcl   ; rcblk type word - 8
        d_word	b_scl   ; scblk type word - 9
        d_word	b_sel   ; seblk type word - 10
        d_word	b_tbt   ; tbblk type word - 11
        d_word	b_vct   ; vcblk type word - 12
        d_word	b_xnt   ; xnblk type word - 13
        d_word	b_xrt   ; xrblk type word - 14
        d_word	b_bct   ; bcblk type word - 15
        d_word	b_pdt   ; pdblk type word - 16
        d_word	b_trt   ; trblk type word - 17
        d_word	b_bft   ; bfblk type word   18
        d_word	b_cct   ; ccblk type word - 19
        d_word	b_cmt   ; cmblk type word - 20
        d_word	b_ctt   ; ctblk type word - 21
        d_word	b_dfc   ; dfblk type word - 22
        d_word	b_efc   ; efblk type word - 23
        d_word	b_evt   ; evblk type word - 24
        d_word	b_ffc   ; ffblk type word - 25
        d_word	b_kvt   ; kvblk type word - 26
        d_word	b_pfc   ; pfblk type word - 27
        d_word	b_tet   ; teblk type word - 28
;
;   table of minimal entry points that can be dded from c
;   via the minimal function (see inter.asm).
;
;   note that the order of entries in this table must correspond
;   to the order of entries in the call enumeration in osint.h
;   and osint.inc.
;
	global calltab
calltab:
        d_word	relaj
        d_word	relcr
        d_word	reloc
        d_word	alloc
        d_word	alocs
        d_word	alost
        d_word	blkln
        d_word	insta
        d_word	rstrt
        d_word	start
        d_word	filnm
        d_word	dtype
;       d_word	enevs ;  engine words
;       d_word	engts ;   not used

	global	b_efc
	global	b_icl
	global	b_rcl
	global	b_scl
	global	b_vct
	global	b_xnt
	global	b_xrt
	global	c_aaa
	global	c_yyy
	global	dnamb
	global	cswfl
	global	dnamp
	global	flprt
	global	flptr
	global	g_aaa
	global	gbcnt
	global	gtcef
	global	headv
	global	hshtb
	global	kvstn
	global	kvdmp
	global	kvftr
	global	kvcom
	global	kvpfl
	global	mxlen
	global	polct
	global	s_yyy
	global	s_aaa
	global	stage
	global	state
	global	stbas
	global	statb
        global  stmcs
        global  stmct
	global	timsx
	global  typet
	global	pmhbs
	global	r_cod
	global	r_fcb
	global	w_yyy
	global	end_min_data


        extern	adr_
        extern	atn_
        extern	chp_
        extern	cos_
	extern	cpr_
        extern	dvr_
        extern	etx_
        extern	itr_
        extern	ldr_
        extern	lnf_
        extern	mlr_
        extern	ngr_
	extern	ovr_
        extern	sbr_
        extern	sin_
        extern	str_
        extern	sqr_
        extern	tan_


	extern	reg_ia,reg_wa,reg_fl,reg_w0,reg_wc

	%macro	adi_	1
	add	ia,%1
	seto	byte [reg_fl]
	%endmacro


	%macro	chk_	0
	extern	chk__	
	call	chk__
	%endmacro

	extern	cvd__

	%macro	cvd_	0
	call	cvd__
	%endmacro

	extern	dvi__

	%macro	dvi_	1
	mov	w0,%1
	call	dvi__
	%endmacro

	%macro	icp_	0
	mov	w0,m(reg_cp)
	add	w0,cfp_b
	mov	m(reg_cp),w0
	%endmacro

	%macro	ino_	1
	mov	al,byte [reg_fl]
	or	al,al
	jno	%1
	%endmacro

	%macro	iov_	1
	mov	al,byte [reg_fl]
	or	al,al
	jo	%1
	%endmacro

	%macro	ldi_	1
	mov	ia,%1
	%endmacro

	%macro	mli_	1
	imul	ia,%1
	seto	byte [reg_fl]
	%endmacro

	%macro	ngi_	0
	neg	ia
	seto	byte [reg_fl]
	%endmacro

	extern	rmi__
	%macro	rmi_	1
	mov	w0,%1
	call	rmi__
	%endmacro

	extern	f_rti
	%macro	rti_	0

	call	f_rti
	mov	ia,m(reg_ia)
	%endmacro

	%macro	sbi_	1
	sub	ia,%1
	mov	w0,0
	seto	byte [reg_fl]
	%endmacro

	%macro	sti_	1
	mov	%1,ia
	%endmacro

	%macro	lcp_	1
	mov	w0,%1
	mov	m_word [reg_cp],w0
	%endmacro

	%macro	lcw_	1
	mov	w0,m_word [reg_cp]		; load address of code word
	mov	w0,m_word [w0]			; load code word
	mov	%1,w0
	mov	w0,m_word [reg_cp]		; load address of code word
	add	w0,cfp_b
	mov	m_word [reg_cp],w0
	%endmacro

	%macro	rno_	1
	mov	al,byte [reg_fl]
	or	al,al
	je	%1
	%endmacro

	%macro	rov_	1
	mov	al,byte [reg_fl]
	or	al,al
	jne	%1
	%endmacro

	%macro	scp_	1
	mov	w0,m_word [reg_cp]
	mov	%1,w0
	%endmacro

