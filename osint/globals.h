/*
copyright 1987-2012 robert b. k. dewar and mark emmer.

this file is part of macro spitbol.

    macro spitbol is free software: you can redistribute it and/or modify
    it under the terms of the gnu general public license as published by
    the free software foundation, either version 3 of the license, or
    (at your option) any later version.

    macro spitbol is distributed in the hope that it will be useful,
    but without any warranty; without even the implied warranty of
    merchantability or fitness for a particular purpose.  see the
    gnu general public license for more details.

    you should have received a copy of the gnu general public license
    along with macro spitbol.  if not, see <http://www.gnu.org/licenses/>.
*/

/*
 *	globals.h	all osint globals are defined in this file.
 *
 *	define globals in the c module that wishes to have these
 *	variables defined.  all other modules will see them as externals.
 */

#ifndef init
#ifdef globals
#define init(what,value) what = value
#else
#define init(what,value) extern what
#endif
#endif

#ifndef noinit
#ifdef globals
#define noinit(what) what
#else
#define noinit(what) extern what
#endif
#endif


/*
/    global data areas needed by compiler.
*/
noinit(	int		cmdcnt);		/*  command count			*/
noinit(	int		gblargc);		/*  argc from command line		*/
noinit(	char	**gblargv);		/*  argv from command line		*/
init(	char	*uarg, 0);		/*  -u argument from command line	*/

/*
/   information to be given to compiler
*/
init(	uword	lnsppage, page_depth);	/*  lines per page for listings			*/
init(	uword	pagewdth, page_width);	/*  width of output line for listings	*/
init(	long	spitflag, dflt_flags);	/*  flags to be given to compiler		*/

/*
/   memory variables that control compiler's dynamic area and stack.
*/
init(	uword	memincb, chunk_b_size);	/*  meminc converted to bytes		*/
init(	uword	databts, heap_size * sizeof(word));	/*  max size in bytes of data area	*/
noinit(	char	*basemem);		/*  base of dynamic memory		*/
noinit(	char	*topmem);		/*  current top of dynamic memory	*/
noinit(	char	*maxmem);		/*  maximum top of dynamic memory	*/
init(	uword	maxsize, object_size * sizeof(word));	/*  maximum size element in dyn. memory	*/
init(	uword	stacksiz, stack_size);	/*  maximum size of stack in bytes	*/
noinit(	char	*lowsp);			/*  lowest legal sp value		*/

/*
/   variables that describe access to standard input and output files.
*/
init(	int		inpcnt, 0);		/*  number of input files			*/
init(	char	**inpptr, 0);	/*  pointer to input file in argv array	*/
noinit(	char	*outptr);		/*  pointer to output listing file	*/
init(	char	*sfn, 0);		/*  current source file name		*/
init(	int	readshell0, 1);		/*  interlock default reading of fd 0	*/
init(	int	first_record, 2);	/*  non-zero before first record read	*/
init(	int	executing, 0);		/*  non-zero during execution		*/
init(	int	originp, -1);		/*  dup of original fd 0			*/
init(	int	curfile, 0);		/*  current file position (swcinp)	*/
init(	int	errflag, 0);		/*  nonzero if error in swcoup		*/
init(	int	origoup, 1);		/*  dup of shell's std output (swcoup)	*/
init(	int	oupstate, 0);		/*  current state of swcoup			*/
init(	int	nesting, 0);		/*  depth of include file nesting	*/
noinit(	int	dcdone);			/*  if zysdc has written headlines	*/
init(	int	provide_name, 1);	/*  sysrd to deliver filename to caller */
noinit(	char   *pathptr);		/*  include file paths 				*/

noinit(	word	bfblksize);
noinit( struct ioblk	*save_iob);
init(	word in_gbcol, 0);		/* record whether in gbcol or not */
init(	int mallocsys, 0);		/* kludgy intel interlock with malloc and free */
init(	int first_time, -1);	/* flag for systm.c */
noinit(	long	start_time);	/* record start-up time for systm.c */
noinit(	char	savexl);		/* used by syshs.c */
noinit(	char	savexr);
noinit(	int		inc_fd[include_depth]);	/* used by sysif.c	*/
noinit(	int		fd);					/*  "    "   "		*/
noinit(	filepos	inc_pos[include_depth]);/*	"	 "	 "		*/

init(	word	maxf, -1);		/* number of files specified this way -1 */

/*
/	structure to record i/o files specified on command line
/	with /#=filename.
*/
#define ncmdf	12

typedef	struct {
    word	filenum;
    char	*fileptr;
} cfile;
noinit(	cfile	cfiles[ncmdf]);	/* array of structures to record info	*/

#define ttyiobininit {0,    /* type word            */ \
    irecsiz,                /* length               */ \
	0,						/* filename				*/ \
	0,						/* process id			*/ \
	0,						/* tty bfblk 			*/ \
    stderrfd,               /* file descriptor 2    */ \
    io_inp+io_opn+io_sys+io_cin, /* flg1            */ \
	0,						/* flg2					*/ \
	eol1,					/* end of line char 1	*/ \
	eol2}					/* end of line char 2	*/

#define ttyioboutinit {0,   /* type word            */ \
	orecsiz,				/* length				*/ \
	0,						/* filename				*/ \
	0,						/* process id			*/ \
	0,						/* tty bfblk 			*/ \
    stderrfd,               /* file descriptor 2    */ \
    io_oup+io_opn+io_sys+io_cot+io_wrc, /* flg1     */ \
	0,						/* flg2					*/ \
	eol1,					/* end of line char 1	*/ \
	eol2}					/* end of line char 2	*/
init(   struct ioblk ttyiobin, ttyiobininit);
init(   struct ioblk ttyiobout, ttyioboutinit);

#define inpiobinit	{0,		/* type word			*/ \
	irecsiz,				/* length				*/ \
	0,						/* filename				*/ \
	0,						/* process id			*/ \
	0,						/* std input bfblk 		*/ \
	0,						/* file descriptor 0	*/ \
	io_inp+io_opn+io_sys,	/* flg1:  				*/ \
	0,						/* flg2:				*/ \
	eol1,					/* end of line char 1	*/ \
	eol2 }					/* end of line char 2	*/
init(	struct ioblk inpiob, inpiobinit);


#define outiobinit {0,		/* type word			*/ \
	orecsiz,				/* length				*/ \
	0,						/* filename				*/ \
	0,						/* process id			*/ \
	0,						/* no bfblk needed		*/ \
	1,						/* file descriptor 1	*/ \
	io_oup+io_opn+io_sys+io_wrc,  /* flg1: 			*/ \
	0,						/* flg2:				*/ \
	eol1,					/* end of line char 1	*/ \
	eol2 }		   			/* end of line char 2	*/
init(	struct ioblk oupiob, outiobinit);

noinit( char  namebuf[256]);
noinit(	int		save_fd0);		/* hold current fd 0 for swcinp */

#if savefile
init(	int expanding, 0);	/* non-zero if doing expansion */
init(	int compressing, 0);	/* non-zero if doing expansion */
init(	long extra, 0);
noinit(	int		bufcnt);
noinit(	unsigned char *bufptr);
noinit(	int		bit_count);
noinit(	unsigned long bit_buffer);
noinit(	short int *code_value);				/* this is the code value array			*/
noinit(	short unsigned int *prefix_code);	/* this array holds the prefix codes	*/
noinit(	unsigned char *append_character);	/* this array holds the appended chars	*/
noinit(	unsigned char *decode_stack);		/* this array holds the decoded string	*/
noinit(	unsigned char *buffer);				/* read/write buffer					*/
#endif					/* savefile */

#if savefile | execfile
noinit(	int		aoutfd);
noinit(  filepos  fp);
#endif					/* savefile | execfile */

/*
/   lmodstk is set when creating a load module.  on the subsequent
/   execution of a load module, the presence of a non-zero value in
/   lmodstk determines that the execution is indeed of a load module.
/
/   for intel dos extender, lmodstk provides the file position within
/	the execution module where a save file begins.
*/
noinit(	word	*lmodstk);


/*
 * globals found in assembly language modules.
 *
 */
extern int  reg_size;
extern int  hasfpu;
extern char cprtmsg[];
extern word reg_block;

#if engine
/*
 * engine globals
 */
noinit(	word lasterror);
#endif					/* engine */
