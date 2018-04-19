// copyright 1987-2012 robert b. k. dewar and mark emmer.

// copyright 2012-2015 david shields
//
// this file is part of macro spitbol.
//
//     macro spitbol is free software: you can redistribute it and/or modify
//     it under the terms of the gnu general public license as published by
//     the free software foundation, either version 2 of the license, or
//     (at your option) any later version.
//
//     macro spitbol is distributed in the hope that it will be useful,
//     but without any warranty; without even the implied warranty of
//     merchantability or fitness for a particular purpose.  see the
//     gnu general public license for more details.
//
//     you should have received a copy of the gnu general public license
//     along with macro spitbol.  if not, see <http://www.gnu.org/licenses/>.


//	ws is bits per word, cfp_b is bytes per word, cfp_c is characters per word


#include "port.h"
#include "c_64.h"
#include <stdio.h>
	word	reg_w0;
	word	reg_wa;
	word	reg_wb;
	word	reg_ia;
	word	reg_wc;
	word	reg_xr;
	word	reg_xl;
	word	reg_cp;
	double	reg_ra;
	word	reg_pc;
	word	reg_xs;
	word	reg_size;

// reg_rp is used to pass pointer to real operand for real arithmetic
	double	*reg_rp = NULL;

	void 	minimal();
//
//  table of minimal entry points that can be dded from c
//  via the minimal function (see inter.asm).
//
//  note that the order of entries in this table must correspond
//  to the order of entries in the call enumeration in osint.h
//  and osint.inc.
//      
extern void relaj();
extern void relcr();
extern void reloc();
extern void alloc();
extern void alocs();
extern void alost();
extern void blkln();
extern void insta();
extern void rstrt();
extern void start();
extern void filnm();
extern void dtype();


	word calltab	= (word)(relaj);
 word calltab_s_001 =  (word)(relcr);
 word calltab_s_002 =  (word)(reloc);
 word calltab_s_003 =  (word)(alloc);
 word calltab_s_004 =  (word)(alocs);
 word calltab_s_005 =  (word)(alost);
 word calltab_s_006 =  (word)(blkln);
 word calltab_s_007 =  (word)(insta);
 word calltab_s_008 =  (word)(rstrt);
 word calltab_s_009 =  (word)(start);
 word calltab_s_010 =  (word)(filnm);
 word calltab_s_011 =  (word)(dtype);
//      d_word  enevs ;  engine words
//      d_word  engts ;   not used


	
	uword	stacksiz;

//	values below must agree with calltab defined in x64.hdr and also in osint/osint.h

#define MINIMAL_RELAJ		0
#define MINIMAL_RELCR		1
#define MINIMAL_RELOC		2
#define MINIMAL_ALLOC		3
#define MINIMAL_ALOCS		4
#define MINIMAL_ALOST		5
#define MINIMAL_BLKLN		6
#define MINIMAL_INSTA		7
#define MINIMAL_RSTRT		8
#define MINIMAL_START		9
#define MINIMAL_FILNM		10
#define MINIMAL_DTYPE		11
#define MINIMAL_ENEVS		10
#define MINIMAL_ENGTS		12



//       ---------------------------------------

//       this file contains the assembly language routines that interface
//       the macro spitbol compiler written in 80386 assembly language to its
//       operating system interface functions written in c.

//       contents:

//       o overview
//       o global variables accessed by osint functions
//       o interface routines between compiler and osint functions
//       o c callable function startup
//       o c callable function get_fp
//       o c callable function restart
//       o c callable function makeexec
//       o routines for minimal opcodes chk and cvd
//       o math functions for integer multiply, divide, and remainder
//       o math functions for real operation

//       overview

//       the macro spitbol compiler relies on a set of operating system
//       interface functions to provide all interaction with the host
//       operating system.  these functions are referred to as osint
//       functions.  a typical call to one of these osint functions takes
//       the following form in the 80386 version of the compiler:

//               ...code to put arguments in registers...
//               call    sysxx           # call osint function
//             d_word    exit_1          # address of exit point 1
//             d_word    exit_2          # address of exit point 2
//               ...     ...             # ...
//             d_word    exit_n          # address of exit point n
//               ...instruction following call...

//       the osint function 'sysxx' can then return in one of n+1 ways:
//       to one of the n exit points or to the instruction following the
//       last exit.  this is not really very complicated - the call places
//       the return address on the stack, so all the interface function has
//       to do is add the appropriate offset to the return address and then
//       pick up the exit address and jump to it or do a normal return via
//       an ret instruction.

//       unfortunately, a c function cannot handle this scheme.  so, an
//       intermediary set of routines have been established to allow the
//       interfacing of c functions.  the mechanism is as follows:

//       (1) the compiler calls osint functions as described above.

//       (2) a set of assembly language interface routines is established,
//           one per osint function, named accordingly.  each interface
//           routine ...

//           (a) saves all compiler registers in global variables
//               accessible by c functions
//           (b) calls the osint function written in c
//           (c) restores all compiler registers from the global variables
//           (d) inspects the osint function's return value to determine
//               which of the n+1 returns should be taken and does so

//       (3) a set of c language osint functions is established, one per
//           osint function, named differently than the interface routines.
//           each osint function can access compiler registers via global
//           variables.  no arguments are passed via the call.

//           when an osint function returns, it must return a value indicating
//           which of the n+1 exits should be taken.  these return values are
//           defined in header file 'inter.h'.

//       note:  in the actual implementation below, the saving and restoring
//       of registers is actually done in one common routine accessed by all
//       interface routines.

//       other notes:

//       some c ompilers transform "internal" global names to
//       "external" global names by adding a leading underscore at the front
//       of the internal name.  thus, the function name 'osopen' becomes
//       '_osopen'.  however, not all c compilers follow this convention.

//       global variables

//	segment	.data
//
// ; words saved during exit(-3)
// ;
word reg_block;
word reg_block_1;
word reg_block_2;
word reg_block_3;
word reg_block_4;
word reg_block_5;
word reg_block_6;
word reg_block_7;
word reg_block_8;
word reg_block_9;
word reg_block_10;
// register ia (ebp)
// register wa (ecx)
// register wa (ecx)
// register wb (ebx)
// register wc
// register xr (xr)
// register xl (xl)
// register cp
// register ra

// these locations save information needed to return after calling osint
// and after a restart from exit()

// return pc from caller
// minimal stack pointer
#define R_SIZE 10*CFP_B

word reg_size =    R_SIZE;

// end of words saved during exit(-3)


// reg_fl is used to communicate condition codes between minimal and c code.
signed char reg_fl = 0;
// condition code register for numeric operations
//  constants

const word 	ten = 10;
// constant 10
word  inf = 0;
// double precision infinity

word 	sav_block[R_SIZE];
//sav_block: times r_size db 0     	; save minimal registers during push/pop reg
// save minimal registers during push/pop reg


word	ppoff;
// offset for ppm exits
word 	compsp;
// compiler's stack pointer
word	sav_compsp;
//sav_compsp:
// save compsp here
word	osisp;
// osint's stack pointer
word	_rc_;
// return code from osint procedure

word 	save_cp;
word 	save_ia;
word 	save_xl;
word 	save_xr;
word 	save_xs;
word 	save_wa;
word 	save_wb;
word 	save_wc;
word 	save_w0;
word	save_minimal_id;
// saved cp value
// saved ia value
// saved xl value
// saved xr value
// saved sp value
// saved wa value
// saved wb value
// saved wc value
// saved w0 value
// saved minima_id value

uword 	minimal_id;
// id for call to minimal from c. see proc minimal below.

//
#define setreal 0

//       setup a number of internal addresses in the compiler that cannot
//       be directly accessed from within c because of naming difficulties.

word id1 = 0;
#if setreal
word id1_a =       2;
word id1_b = 1;
word id1_c = 0x1000000; //	db  "1x\x00\x00\x00"
#endif

word id1blk	= 152;
word xpid1blk[153]   = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
word id2blk = 152;
word xpid2blk[153]   = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
word ticblk = 0;
word ticblk_a = 0;

word tscblk = 512;
word xptscblk[513] = {0 ,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

word  inpbuf;
// type word
// block length
// buffer size
// remaining chars to read
// offset to next character to read
// file position of buffer
// physical position in file
// buffer

word   ttybuf;
// type word
// block length
// buffer size  (260 ok in ms-dos with cinread())
// remaining chars to read
// offset to next char to read
// file position of buffer
// physical position in file
// buffer
//
//       save and restore minimal and interface registers on stack.
//       used by any routine that needs to call back into the minimal
//       code in such a way that the minimal code might trigger another
//       sysxx call before returning.
//
//       note 1:  pushregs returns a collectable value in xl, safe
//       for subsequent call to memory allocation routine.
//
//       note 2:  these are not recursive routines.  only reg_xl is
//       saved on the stack, where it is accessible to the garbage
//       collector.  other registers are just moved to a temp area.
//
//       note 3:  popregs does not restore reg_cp, because it may have
//       been modified by the minimal routine called between pushregs
//       and popregs as a result of a garbage collection.  calling of
//       another sysxx routine in between is not a problem, because
//       cp will have been preserved by minimal.
//
//       note 4:  if there isn't a compiler stack yet, we don't bother
//       saving xl.  this only happens in call of nextef from sysxi when
//       reloading a save file.
//
//
// pushregs and popregs are in syslinux.c



//       resrtore_regs is for debugging
//	save_regs is for debugging. it doesnt do all those weird rules
void save_regs() {
	save_ia=ia;
	save_xl = xl;
	save_xr = xr;
	save_xs = xs;
	save_wa = wa;
	save_wb = wb;
	save_wc = wc;
	save_w0 = w0;
	save_minimal_id=minimal_id;
	C_EXIT(0);
}

void restore_regs() {
//	restore regs, except for sp. that is caller's responsibility
	ia=save_ia;
	xl=save_xl;
	xr=save_xr;
	//xs=save_xs;
	wa=save_wa;
	wb=save_wb;
	wc=save_wc;
	minimal_id = save_minimal_id;
	w0=save_w0;
	C_EXIT(0);
}
	
// ;
// ;       startup( char *dummy1, char *dummy2) - startup compiler
// ;
// ;       an osint c function calls startup to transfer control
// ;       to the compiler.
// ;
// ;       (xr) = basemem
// ;       (xl) = topmem - sizeof(word)
// ;
// ;	note: this function never returns.
// ;
//

//   ordinals for minimal calls from assembly language.

//   the order of entries here must correspond to the order of
//   calltab entries in the inter assembly language module.

#define CALLTAB_RELAJ   0
#define CALLTAB_RELCR   1
#define CALLTAB_RELOC   2
#define CALLTAB_ALLOC   3
#define CALLTAB_ALOCS   4
#define CALLTAB_ALOST   5
#define CALLTAB_BLKLN   6
#define CALLTAB_INSTA   7
#define CALLTAB_RSTRT   8
#define CALLTAB_START   9
#define CALLTAB_FILNM   10
#define CALLTAB_DTYPE   11
#define CALLTAB_ENEVS   12
#define CALLTAB_ENGTS   13


extern void stackinit();

void startup() {
// discard return
// initialize minimal stack
// get minimal's stack pointer
// startup stack pointer

// default to up direction for string ops
//        getoff  w0,dffnc               # get address of ppm offset
// save for use later

// switch to new c stack
minimal_id = CALLTAB_START;

// load regs, switch stack, start compiler

//	stackinit  -- initialize lowspmin from sp.

//	input:  sp - current c stack
//		stacksiz - size of desired minimal stack in bytes

//	uses:	w0

//	output: register wa, sp, lowspmin, compsp, osisp set up per diagram:

//	(high)	+----------------+
//		|  old c stack   |
//	  	|----------------| <-- incoming sp, resultant wa (future xs)
//		|	     ^	 |
//		|	     |	 |
//		/ stacksiz bytes /
//		|	     |	 |
//		|            |	 |
//		|----------- | --| <-- resultant lowspmin
//		| 400 bytes  v   |
//	  	|----------------| <-- future c stack pointer, osisp
//		|  new c stack	 |
//	(low)	|                |
//C_GOTO(stackinit);
C_JSR(stackinit);
C_JSR(minimal);
}

	word lowspmin;

void stackinit() {
	/* Since xs is not the real xs we need to cheat a bit */
	word *s;
	{
	char stuff[128];
	stuff[0]='h' + w0;
	stuff[99]='i' + w0;	
	s = (word *)stuff;
	}
	xs=((word)(s))+128*CFP_B;  // around there - might need to adjust
	w0 = xs;
	compsp = w0;
	osisp = compsp-stacksiz;
	lowspmin=CFP_B*100;	
	
	/* Hib Done here because of START functionality */
	reg_wa = compsp;		
					
	
	/* old code 
	w0=xs;
	compsp = 10;// save as minimal's stack pointer
	w0 = stacksiz;// end of minimal stack is where c stack will start
        osisp=w0;// save new c stack pointer
	w0=CFP_B*100;// 100 words smaller for chk
	lowspmin=w0;
	*/

	C_EXIT(0);
}


extern void min1();

//       mimimal -- call minimal function from c

//       usage:  extern void minimal(word callno)

//       where:
//         callno is an ordinal defined in osint.h, osint.inc, and calltab.

//       minimal registers wa, wb, wc, xr, and xl are loaded and
//       saved from/to the register block.

//       note that before restart is called, we do not yet have compiler
//       stack to switch to.  in that case, just make the call on the
//       the osint stack.

void minimal() {
//         pushad			; save all registers for c
// restore registers
	wa=reg_wa;
	wb=reg_wb;
	wc=reg_wc;
	xr=reg_xr;
	xl=reg_xl;
	osisp=xs;
	if (compsp) xs=compsp;
C_GOTO(min1);
// save osint stack pointer
// is there a compiler stack?
// jump if none yet
// switch to compiler stack
}



void min1() {
w0 = minimal_id; // get ordinal
w0 = ((word *)(&calltab))[w0];
C_JSR(w0_it.callp);   // off to the minimal code

xs=osisp;// switch to osint stack

// save registers
reg_wa=wa;
reg_wb=wb;
reg_wc=wc;
reg_xr=xr;
reg_xl=xl;
C_EXIT(0);
}

//another section here 

word  hasfpu=	0;

const char cprtmsg [] =  " copyright 1987-2012 robert b. k. dewar and mark emmer.\000\000";


//       interface routines

//       each interface routine takes the following form:

//               sysxx   call    ccaller ; call common interface
//                     d_word    zysxx   ; dd      of c osint function
//                       db      n       ; offset to instruction after
//                                       ;   last procedure exit

//       in an effort to achieve portability of c osint functions, we
//       do not take take advantage of any "internal" to "external"
//       transformation of names by c compilers.  so, a c osint function
//       representing sysxx is named _zysxx.  this renaming should satisfy
//       all c compilers.

//       important  one interface routine, sysfc, is passed arguments on
//       the stack.  these items are removed from the stack before calling
//       ccaller, as they are not needed by this implementation.

//       ccaller is called by the os interface routines to call the
//       real c os interface function.

//       general calling sequence is

//               call    ccaller
//             d_word    address_of_c_function
//               db      2*number_of_exit_points

//       control is never returned to a interface routine.  instead, control
//       is returned to the compiler (the caller of the interface routine).

//       the c function that is called must always return an integer
//       indicating the procedure exit to take or that a normal return
//       is to be performed.

//               c function      interpretation
//               return value
//               ------------    -------------------------------------------
//                    <0         do normal return to instruction past
//                               last procedure exit (distance passed
//                               in by dummy routine and saved on stack)
//                     0         take procedure exit 1
//                     4         take procedure exit 2
//                     8         take procedure exit 3
//                    ...        ...


//	segment	.data
word call_adr =0;
//	segment	.text


void syscall_init() {
//       save registers in global variables

// save registers
reg_wa=wa;
reg_wb=wb;
reg_wc=wc;
reg_xr=xr;
reg_xl=xl;
reg_ia=ia;
reg_xs = xs;
C_EXIT(0);
}


void syscall_exit() {
// save return code from function
// save osint's stack pointer
// restore compiler's stack pointer
// restore registers
// _rc_ is set
//osisp=xs;
//xs=compsp;
wa=reg_wa;
wb=reg_wb;
wc=reg_wc;
xr=reg_xr;
xl=reg_xl;
ia=reg_ia;
//w0=reg_pc;
//  hib - checked - we are not setting a go to from any syscall at the moment.
//C_GOTO(w0_it.callp);
// xs = reg_xs;
// rt has the value for return.
C_EXIT(_rt_);
}

#define syscall(a,b) {C_JSR(syscall_init)_rt_=b;_rt_=a();C_GOTO(syscall_exit);}

// pop return address	
//       save compiler stack and switch to osint stack
// save compiler's stack pointer
// load osint's stack pointer
//	call	%1
// was a call for debugging purposes, but that would cause a crash when the
// compilers stack pointer blew up
//	%endmacro

extern int zysax();
void sysax() {syscall(zysax,1);}

extern int zysbs();
void sysbs() {reg_xs = xs;syscall(zysbs,2);}

extern int zysbx();
void sysbx() {reg_xs = xs;syscall(zysbx,2);}

//        global syscr
//	extern	zyscr
//syscr:  syscall    zyscr ;    ,0

extern int zysdc();
void sysdc() {syscall(zysdc,4);}

extern int zysdm();
void sysdm() {syscall(zysdm,5);}

extern int zysdt();
void sysdt() {syscall(zysdt,6);}

	extern	int zysea();
void sysea() {syscall(zysea,7);}


	extern int	zysef();
void sysef() {	syscall(zysef,8);}

	extern int 	zysej();
void sysej() {syscall(zysej,9);}

	extern	int zysem();
void sysem() {	syscall(zysem,10);}

	extern	int zysen();
void sysen() {	syscall(zysen,11);}

	extern	int zysep();
void sysep() {	syscall(zysep,12);}

	extern	int zysex();
void sysex() {reg_xs=xs;	syscall(zysex,13);}

	extern	int zysfc();
// <<<<remove stacked scblk>>>>
void sysfc() {xs = (word)(xs_it.wp+wc);
	      C_PUSH(w0);
	syscall(zysfc,14);}

	extern	int zysgc();
void sysgc() {	syscall(zysgc,15);}

	extern	int zyshs();
void syshs() {xs=reg_xs;
	syscall(zyshs,16);}

	extern int	zysid();
void sysid() {syscall(zysid,17);}

	extern int	zysif();
void sysif() {syscall(zysif,18);}

	extern int	zysil();
void sysil()  {syscall(zysil,19);}

	extern	int zysin();
void sysin() {syscall(zysin,20);}

	extern int	zysio();
void sysio()	{syscall(zysio,21);}

	extern	int zysld();
void sysld() {syscall(zysld,22);}

	extern int	zysmm();
void sysmm()	{syscall(zysmm,23);}

	extern int	zysmx();
void sysmx() {	syscall(zysmx,24);}

	extern int	zysou();
void sysou() {syscall(zysou,25);}

	extern int	zyspi();
void syspi() {syscall(zyspi,26);}

	extern int	zyspl();
void syspl() {syscall(zyspl,27);}

	extern	int zyspp();
void syspp()	{syscall(zyspp,28);}

	extern int zyspr();
void syspr()    {	syscall	(zyspr,29);}

	extern	int zysrd();
void sysrd()	{syscall(zysrd,30);}

	extern int	zysri();
void sysri() {syscall(zysri,32);}

	extern int	zysrw();
void sysrw() {	syscall(zysrw,33);}

	extern int	zysst();
void sysst() {	syscall(zysst,34);}

	extern	int zystm();
void systm() {	syscall(zystm,35);}

	extern int	zystt();
void systt() {	syscall(zystt,36);}

	extern int 	zysul();
void sysul() { 	syscall(zysul,37);}

	extern int	zysxi();
void sysxi() {reg_xs = xs;	syscall(zysxi,38);}

//	%macro	callext	2
//	extern	%1
//	call	%1
// pop arguments
//	%endmacro
// not used - hib

void i_cvd();
//	x64 hardware divide, expressed in form of minimal register mappings, requires dividend be
//	placed in w0, which is then sign extended into wc:w0. after the divide, w0 contains the
//	quotient, wc contains the remainder.
//
//       cvd__ - convert by division
//
//       input   ia = number <=0 to convert
//       output  ia / 10
//               wa ecx) = remainder + '0'
void cvd__() {
reg_ia = ia;
reg_wa = wa;
C_JSR(i_cvd);
ia=reg_ia;
wa=reg_wa;
C_EXIT(0);
}


void ocode() {
// test for 0
// jump if 0 divisor
// ia to w0, divisor to ia
// extend dividend
// perform division. w0=quotient, wc=remainder
//	seto	byte [reg_fl]
reg_fl=0;
w0=ia=wc;
C_EXIT(0);
}

#define real_op(a,b) extern void b(); void a() {reg_rp=(double *)w0; C_CALL(b); C_EXIT(0);}

	real_op(ldr_,f_ldr);
	real_op(str_,f_str);
	real_op(adr_,f_adr);
	real_op(sbr_,f_sbr);
	real_op(mlr_,f_mlr);
	real_op(dvr_,f_dvr);
	real_op(ngr_,f_ngr);
	real_op(cpr_,f_cpr);

#define int_op(a,b) extern void b(); void a() {reg_ia=ia; C_CALL(b); C_EXIT(0);}

	int_op(itr_,f_itr);
	int_op(rti_,f_rti);


#define math_op(a,b) extern void b(); void a() {C_CALL(b); C_EXIT(0);}

	math_op(atn_,f_atn);
	math_op(chp_,f_chp);
	math_op(cos_,f_cos);
	math_op(etx_,f_etx);
	math_op(lnf_,f_lnf);
	math_op(sin_,f_sin);
	math_op(sqr_,f_sqr);
	math_op(tan_,f_tan);

//       ovr_ test for overflow value in ra
void ovr_() {
C_EXIT(0);
}
// get top 2 bytes
// check for infinity or nan
// set/clear overflow accordingly


// get frame pointer

word *get_fp() {
// minimal's xs
// pop return from call to sysbx or sysxi
// theres a pesky 200000000000000
// done
w0=reg_xs;
w0 +=  CFP_C+CFP_C;
return (word *)(w0);
}

	extern	void rereloc();

	extern	word *lmodstk;
	extern	void startbrk();
	extern	char *outptr;
	extern	int swcoup(char *oupptr);
//	SCSTR is offset to start of string in scblk, or two words
#define SCSTR	CFP_C+CFP_C




void re1();
void re2();
void re3();
void re4();
//
void restart(char *code,char *stack) {
w0 = C_POP();
xt=w0;
// discard return maybee maybee not
// For x86_cr System V AMD64 ABI conventions,
// arg 2 is in rsi (xt)

// old way to get teh values on 32 bit:
//        pop     w0                     	; discard dummy
//        pop     w0                     	; get lowest legal stack value

w0 += stacksiz;		// top of compiler's stack
xs=w0;			// switch to this stack

C_JSR(stackinit);		// initialize minimal stack


w0 = (word)(&tscblk)+SCSTR;   // top of saved stack
wb = (word)(lmodstk);
wa=stbas;
wb -= w0;
wc=wa;
wc -= wb;
wb=wa;
wb -=xs;

// set up for stack relocation
// bottom of saved stack
// wa = stbas from exit() time
// wb = size of saved stack
	wc=wa;
//	mov	wc,wa
// wc = stack bottom from exit() time
//	mov	wb,wa
	wb=wa;
// wb =  stbas - new stbas

stbas=xs;		// save initial sp
//        getoff  w0,dffnc               ; get address of ppm offset
ppoff=w0; 		// save for use later
//
//       restore stack from tscblk.
//
xl=(word)lmodstk;			// -> bottom word of stack in tscblk
xr =  (word)(&tscblk)+SCSTR;		// -> top word of stack
if (xl==xr) C_GOTO(re3);		// any stack to transfer?
				//  skip if not
				
xl -= CFP_B;       // this was 4 (32 bit. changed to "8" via cfp_b.
// note - 8088 dec index twice with dec.
//	std
//     mov     xl,m_word [lmodstk]     ; -> bottom word of stack in tscblk
//        lea     xr,[tscblk+scstr]       ; -> top word of stack
//        cmp     xl,xr                   ; any stack to transfer?
//        je      re3                     ;  skip if not
//        sub     xl,cfp_b                ; this was 4 (32 bit. changed to "8" via cfp_b.
        //                                ; note - 8088 dec index twice with dec.
//        std
C_GOTO(re1);
}

void re1() {
//re1:    lodsd                           ; get old stack word to w0
// I think this is 
w0 = xs;
if (w0<wc) C_GOTO(re2);
if (w0>wc) C_GOTO(re2);
//        cmp     w0,wc                   ; below old stack bottom?
//        jb      re2                     ;   j. if w0 < wc
//        cmp     w0,wa                   ; above old stack top?
//        ja      re2                     ;   j. if w0 > wa


w0 -= wb; //        sub     w0,wb                   ; within old stack, perform relocation
C_GOTO(re2);
}



void re2() {
C_PUSH(w0);
if (xl>=xr) C_GOTO(re1);

//re2:    push    w0                      ; transfer word of stack
//        cmp     xl,xr                   ; if not at end of relocation then
//        jae     re1                     ;    loop back
C_GOTO(re3);
}



void re3() {
//re3:    cld
compsp=xs;
xs=osisp;
C_CALL(rereloc);
w0=statb;
reg_xr=w0;
minimal_id= minimal_insta;
C_CALL(minimal);


//        mov     m_word [compsp],xs      ; save compiler's stack pointer
//        mov     xs,m_word [osisp]       ; back to osint's stack pointer
//        call   rereloc                  ; relocate compiler pointers into stack
//        mov     w0,m_word [statb]       ; start of static region to xr
//        mov     m_word [reg_xr],w0
//        mov     word [minimal_id],minimal_insta
//        call    minimal                 ; initialize static region
//re3:	cld
// save compiler's stack pointer
// back to osint's stack pointer
// relocate compiler pointers into stack
// start of static region to xr


// initialize static region

//
//       now pretend that we're executing the following c statement from
//       function zysxi:
//
//               return  normal_return;
//
//       if the load module was invoked by exit(), the return path is
//       as follows:  back to ccaller, back to s$ext following sysxi call,
//       back to user program following exit() call.
//
//       alternately, the user specified -w as a command line option, and
//       sysbx called makeexec, which in turn called sysxi.  the return path
//       should be:  back to ccaller, back to makeexec following sysxi call,
//       back to sysbx, back to minimal code.  if we allowed this to happen,
//       then it would require that stacked return address to sysbx still be
//       valid, which may not be true if some of the c programs have changed
//       size.  instead, we clear the stack and execute the restart code that
//       simulates resumption just past the sysbx call in the minimal code.
//       we distinguish this case by noting the variable stage is 4.
//
// start control-c logic
C_CALL(startbrk);
// is this a -w call?
        if (stage==4) C_GOTO(re4);

// yes, do a complete fudge

//
//       jump back with return value = normal_return
// set to zero to indicate normal return
	w0=0;
C_CALL(syscall_exit);
C_EXIT(0);
}


//       here if -w produced load module.  simulate all the code that
//       would occur if we naively returned to sysbx.  clear the stack and
//       go for it.
//
void re4() {
	w0=stbas;
// empty the stack

//       code that would be executed if we had returned to makeexec:
//
// reset garbage collect count
// fetch execution time to reg_ia
// set time into compiler

	timsx=w0;

//       code that would be executed if we returned to sysbx:
//
// swcoup(outptr)
	extern 	int swcoup(char *outptr);
	swcoup(outptr);
	xs += CFP_B;

//       jump to minimal code to restart a save file.

	minimal_id = MINIMAL_RSTRT;
// was c_call 
        C_GOTO(minimal);
// no return
}

#ifdef z_trace
	extern	word zz_ra;
	extern	word zz,zz_cp,zz_xl,zz_xr,zz_wa,zz_wb,zz_wc,zz_w0;
void zzz() {
	//pushf
	C_CALL(save_regs);
	C_CALL(zz);
	C_CALL(restore_regs);
	//popf
	C_EXIT(0);
}

#endif




void error_found(word errornum) {
fprintf(stderr,"error found %ld\n",errornum);
}


word goto_counter=0;



  #define SCGET   0
   #define SCLEN   (SCGET+1)
   

int dinout() {
fprintf(stderr,"inout stpte %lx %s type %lx\n",xl,xl_it.chp,wb);
fprintf(stderr,"wa %lx %lx should = %lx = %lx\n",SCLEN,CFP_B*SCLEN, *((word *)(CFP_B*SCLEN + xl)),xl_it.wp[SCLEN]);
}
