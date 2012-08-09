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
/   file:  spitblks.h		version:  01.01
/   -------------------------------------------
/
/   this header file defines structures used by the macro spitbol compiler
/   that are passed into the os interface.
*/

/*
/   first, define the c type word to be the same size as a word used
/   by the macro spitbol compiler.  the type of a word is a signed
/   integer for now.
*/

/*
 * 	buffer control block
 *
 *	a buffer control block (bcblk) is created by the buffer
 *	function, and serves as an indirect control header for the
 *	buffer. it contains the number of characters currently
 *	stored in the buffer.
 */
struct bcblk {
    word	typ;					/* type word							*/
    word	idv;					/* identifier value						*/
    word	len;					/* number of chars in use in bfblk		*/
    struct bsblk *bcbuf;			/* pointer to bfblk						*/
};

/*
 * 	string buffer block
 *
 *	a string buffer block (bfblk) contains the actual buffer
 *	memory area. it specifies the largest string that can be
 *	stored in the buffer.
 */
struct bsblk {
    word	typ;					/* type word							*/
    word	bsalc;					/* allocated size of buffer				*/
    char	bschr[1];				/* characters of string					*/
};


/*
 * code block
 *
 * a code block (cdblk) is present for every source statement.
 */

struct cdblk {
    word			cdjmp;			/* ptr to routine to execute statement	*/
    word			cdstm;			/* statement number						*/
    word			cdsln;			/* source file line number				*/
    word			cdlen;			/* length of cdblk in bytes				*/
    union {
        struct cdblk near *cdnxt;	/* if failure exit is next statement	*/
        struct vrblk near *cdlab;	/* if failure exit is a simple label	*/
        char 		 near *cdnof;	/* no failure exit (-nofail mode)		*/
        word		  cddir;		/* failure exit is complex or direct	*/
    }			cdfal;			/* failure exit							*/
    word			cdcod[1];		/* executable pseudo-code				*/
};


/*
/   chfcb - chain of fcbs block
/
/   for every fcb created by osint, the compiler creates a chfcb pointing
/   to the fcb and links it onto a chain of chfcbs.  at eoj the head of this
/   chfcb chain is passed to the interface function sysej so that all files
/   can be closed.
*/

struct	chfcb {
    word	typ;				/*  type word			*/
    word	len;				/*  block length		*/
    struct	chfcb near *nxt;	/*  pointer to next chfcb	*/
    struct	fcblk near *fcp;	/*  pointer to fcb		*/
};


/*
/   efblk - external function block
/
*/

struct	efblk {
    word	fcode;				/*  type word			*/
    word	fargs;				/*  number of arguments	*/
    word	eflen;				/*  block length		*/
    word	efuse;				/*  usage count			*/
    void near *efcod;			/*  pointer to xnblk	*/
    struct vrblk near *efvar;	/*  pointer to vrblk	*/
    word	efrsl;				/*  result type			*/
    word	eftar[1];			/*  argument types		*/
};

/*
/   icblk - integer block
/
/   integer values are stored in icblks.  field icval should be defined
/   to be the appropriate type for the implementation.
*/

struct	icblk {
    word	typ;		/*  type word - b$icl		*/
    iatype	val;
};

/*
/	rcblk - real block
/
/	real values are stored in rcblks.  field rcval should be defined
/	to be the appropriate type for the implementation.
*/

struct	rcblk {
    word	typ;		/*	type word - b$rcl */
    double	rcval;		/*	real value */
};

/*
/   scblk - string block
/
/   string values are stored in scblks.  notice that the scstr field
/   is defined as an array of characters of length 1.  this is a slight
/   kludge to side-step c's lack of support for varying length strings.
/
/   the actual length of a scblk is 2 words + the number of words necessary
/   to hold a string of length sclen.
*/

struct	scblk {
    word	typ;		/*  type word - b$scl		*/
    word	len;		/*  string length		*/
    char	str[1];		/*  string characters		*/
};


/*
 * variable block
 *
 * a variable block (vrblk) is used to hold a program variable.
 */

struct vrblk {
    word			vrget;			/* routine to load variable onto stack	*/
    word			vrsto;			/* routine to store stack top into var.	*/
    union block	 near *vrval;		/* variable value						*/
    word			vrtra;			/* routine to transfer to label			*/
    union block	 near *vrlbl;		/* pointer to code for label			*/
    union block	 near *vrfnc;		/* function block if name is function	*/
    struct vrblk near *vrnxt;		/* next vrblk on hash chain				*/
    word			vrlen;			/* length of name						*/
    char			vrchs[1];		/* characters of name					*/
};




/*
/	block - an arbitrary block
*/

union block {
    struct bcblk	bcb;
    struct bsblk	bsb;
    struct cdblk	cdb;
    struct chfcb	fcb;
    struct efblk	efb;
    struct icblk	icb;
    struct rcblk	rcb;
    struct scblk	scb;
    struct vrblk	vrb;
};
