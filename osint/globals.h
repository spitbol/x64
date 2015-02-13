/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2015 David Shields

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
 *	Globals.h	All OSINT globals are defined in this file.
 *
 *	Define GLOBALS in the C module that wishes to have these
 *	variables defined.  All other modules will see them as externals.
 */

#ifndef Init
#ifdef GLOBALS
#define Init(what,value) what = value
#else
#define Init(what,value) extern what
#endif
#endif

#ifndef NoInit
#ifdef GLOBALS
#define NoInit(what) what
#else
#define NoInit(what) extern what
#endif
#endif


/*
/    Global data areas needed by compiler.
*/
NoInit(	int		cmdcnt);		//  command count
NoInit(	int		gblargc);		//  argc from command line
NoInit(	char	**gblargv);		//  argv from command line
Init(	char	*uarg, 0);		//  -u argument from command line

/*
/   Information to be given to compiler
*/
Init(	uword	lnsppage, PAGE_DEPTH);	//  lines per page for listings
Init(	uword	pagewdth, PAGE_WIDTH);	//  width of output line for listings
Init(	long	spitflag, DFLT_FLAGS);	//  flags to be given to compiler

/*
/   Memory variables that control compiler's dynamic area and stack.
*/
Init(	uword	memincb, CHUNK_B_SIZE);	//  meminc converted to bytes
Init(	uword	databts, HEAP_SIZE * sizeof(word));	//  max size in bytes of data area
NoInit(	char	*basemem);		//  base of dynamic memory
NoInit(	char	*topmem);		//  current top of dynamic memory
NoInit(	char	*maxmem);		//  maximum top of dynamic memory
Init(	uword	maxsize, OBJECT_SIZE * sizeof(word));	//  maximum size element in dyn. memory
Init(	uword	stacksiz, STACK_SIZE);	//  maximum size of stack in bytes
NoInit(	char	*lowsp);			//  lowest legal sp value

/*
/   Variables that describe access to standard input and output files.
*/
Init(	int		inpcnt, 0);		//  number of input files
Init(	char	**inpptr, 0);	//  pointer to input file in argv array
NoInit(	char	*outptr);		//  pointer to output listing file
Init(	char	*sfn, 0);		//  current source file name
Init(	int	readshell0, 1);		//  interlock default reading of fd 0
Init(	int	first_record, 2);	//  non-zero before first record read
Init(	int	executing, 0);		//  non-zero during execution
Init(	int	originp, -1);		//  dup of original fd 0
Init(	int	curfile, 0);		//  current file position (swcinp)
Init(	int	errflag, 0);		//  Nonzero if error in swcoup
Init(	int	origoup, 1);		//  Dup of shell's std output (swcoup)
Init(	int	oupState, 0);		//  Current state of swcoup
Init(	int	nesting, 0);		//  depth of include file nesting
NoInit(	int	dcdone);			//  if zysdc has written headlines
Init(	int	provide_name, 1);	//  sysrd to deliver filename to caller
NoInit(	char   *pathptr);		//  include file paths

NoInit(	word	bfblksize);
NoInit( struct ioblk	*save_iob);
Init(	word in_gbcol, 0);		// record whether in GBCOL or not
Init(	int mallocSys, 0);		// Kludgy Intel interlock with malloc and free
Init(	int first_time, -1);	// Flag for systm.c
NoInit(	long	start_time);	// record start-up time for systm.c
NoInit(	char	savexl);		// used by syshs.c
NoInit(	char	savexr);
NoInit(	int		inc_fd[INCLUDE_DEPTH]);	// used by sysif.c
NoInit(	int		fd);					//  "    "   "
NoInit(	FILEPOS	inc_pos[INCLUDE_DEPTH]);//	"	 "	 "

Init(	word	maxf, -1);		// number of files specified this way -1

/*
/	Structure to record i/o files specified on command line
/	with /#=filename.
*/
#define Ncmdf	12

typedef	struct {
    word	filenum;
    char	*fileptr;
} CFile;
NoInit(	CFile	cfiles[Ncmdf]);	// Array of structures to record info

#define ttyiobininit {0,    /* type word            */ \
    IRECSIZ,                /* length               */ \
	0,						/* filename				*/ \
	0,						/* process id			*/ \
	0,						/* tty BFBLK 			*/ \
    STDERRFD,               /* file descriptor 2    */ \
    IO_INP+IO_OPN+IO_SYS+IO_CIN, /* flg1            */ \
	0,						/* flg2					*/ \
	EOL}					/* end of line char 1	*/

#define ttyioboutinit {0,   /* type word            */ \
	ORECSIZ,				/* length				*/ \
	0,						/* filename				*/ \
	0,						/* process id			*/ \
	0,						/* tty BFBLK 			*/ \
    STDERRFD,               /* file descriptor 2    */ \
    IO_OUP+IO_OPN+IO_SYS+IO_COT+IO_WRC, /* flg1     */ \
	0,						/* flg2					*/ \
	EOL}					/* end of line char 1	*/

Init(   struct ioblk ttyiobin, ttyiobininit);
Init(   struct ioblk ttyiobout, ttyioboutinit);

#define inpiobinit	{0,		/* type word			*/ \
	IRECSIZ,				/* length				*/ \
	0,						/* filename				*/ \
	0,						/* process id			*/ \
	0,						/* std input BFBLK 		*/ \
	0,						/* file descriptor 0	*/ \
	IO_INP+IO_OPN+IO_SYS,	/* flg1:  				*/ \
	0,						/* flg2:				*/ \
	EOL}					/* end of line char 1	*/

Init(	struct ioblk inpiob, inpiobinit);


#define outiobinit {0,		/* type word			*/ \
	ORECSIZ,				/* length				*/ \
	0,						/* filename				*/ \
	0,						/* process id			*/ \
	0,						/* no BFBLK needed		*/ \
	1,						/* file descriptor 1	*/ \
	IO_OUP+IO_OPN+IO_SYS+IO_WRC,  /* flg1: 			*/ \
	0,						/* flg2:				*/ \
	EOL}					/* end of line char 1	*/
Init(	struct ioblk oupiob, outiobinit);

NoInit( char  namebuf[256]);
NoInit(	int		save_fd0);		// Hold current fd 0 for swcinp

Init(	int expanding, 0);	// non-zero if doing expansion
Init(	int compressing, 0);	// non-zero if doing expansion
Init(	long extra, 0);
NoInit(	int		bufcnt);
NoInit(	unsigned char *bufptr);
NoInit(	int		bit_count);
NoInit(	unsigned long bit_buffer);
NoInit(	short int *code_value);				// This is the code value array
NoInit(	short unsigned int *prefix_code);	// This array holds the prefix codes
NoInit(	unsigned char *append_character);	// This array holds the appended chars
NoInit(	unsigned char *decode_stack);		// This array holds the decoded string
NoInit(	unsigned char *buffer);				// Read/write buffer

NoInit(	int		aoutfd);
NoInit(  FILEPOS  fp);

/*
/   lmodstk is set when creating a load module.  On the subsequent
/   execution of a load module, the presence of a non-zero value in
/   lmodstk determines that the execution is indeed of a load module.
/
/   For Intel DOS Extender, lmodstk provides the file position within
/	the execution module where a save file begins.
*/
NoInit(	word	*lmodstk);


/*
 * Globals found in assembly language modules.
 *
 */
extern int  reg_size;
extern char cprtmsg[];
extern word reg_block;

#if ENGINE
/*
 * Engine globals
 */
NoInit(	word lastError);
#endif					// ENGINE
