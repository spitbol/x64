!@#$arg2scb.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  ARG2SCB.C	Version:  01.02
/	---------------------------------------
/
/	Contents:	Function arg2scb
/
/	1.02	Rewritten to append to scblk instead of copy to block.
*/

/*
/   arg2scb( req, argc, argv, scptr, maxs )
/
/   arg2scb() makes a copy of the req-th argument in the argv array.
/   The copy is appended to the string in the SCBLK provided.
/
/   Parameters:
/	req	number of argument to copy
/	argc	number of arguments
/	argv	pointer to array of pointers to strings (arguments)
/	scptr	pointer to SCBLK to receive copy of argument
/	maxs	maximum number of characters to append.
/   Returns:
/	Length of argument copied or -1 if req is out of range.
/   Side Effects:
/	Modifies contents of passed SCBLK (scptr).
/	SCBLK length field is incremented.
*/

#include "port.h"

int	arg2scb( req, argc, argv, scptr, maxs )

int	req;
int	argc;
char	*argv[];
struct	scblk	*scptr;
int	maxs;

{
    register word	i;
    register char	*argcp, *scbcp;

    if ( req < 0  ||  req >= argc )
        return	-1;

    argcp	= argv[req];
    scbcp	= scptr->str + scptr->len;
    for( i = 0 ; i < maxs  &&  ((*scbcp++ = *argcp++) != 0) ; i++ )
        ;
    scptr->len += i;
    return i;
}
!@#$blocks32.h
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*----------------------------  blocks32.h  --------------------------------*/
#ifndef __blocks32__
#define __blocks32__

/*
 * Definitions of SPITBOL data blocks available to C-language
 * external functions to be called from 32-bit versions of SPITBOL.
 *
 * V1.00	02/17/90 01:53pm
 *			Initial version
 * V1.01	12-03-90 12:01pm
 * 			To match release 1.08.  Split flags in IOBLK
 * 			into to words to prevent flag bits from being
 * 			mistaken for a relocatable value.
 * V1.02	03-11-91 15:00pm
 * 			To match release 1.1.  Add new words to ioblk for end-
 * 			of-line characters.  The bfblk has been completely
 * 			reworked to accommodate read/write I/O.
 * V1.03	10-18-91 04:27pm
 *        <withdrawn>.
 * V1.04	3-July-92
 * 			Begin to customize for SPARC/Sun 4.
 * V1.05	09-12-94 07:13pm
 *		 	Add definitions for buffers
 * V1.06	04-25-95 10:07pm
 *			Customize for RS/6000.
 * V1.07    12-29-96 06:05pm
 *          Customize for Windows NT
 * V1.08    03-04-97 01:45pm
 *          Tweak for SPARC
 * V1.09 04-27-97
 *          Add FILEPOS definition.
 *
 *
 * SPITBOL BLOCKS
 *
 * All SPITBOL objects are encapsulated into blocks of memory.
 * The first word of each block identifies the block type in a
 * curious way.  Rather than containing a simple integer type
 * code, it contains the address of a subroutine that performs
 * some particular action on the block, such as placing it on
 * the stack.  Because each block type uses a different subroutine,
 * the subroutine addresses serve as a type identifier.
 *
 *
 * Each subroutine is proceeded in memory by a one-byte (Intel platforms)
 * or one-word (all other platforms) integer type code (given below).
 * Thus to obtain a simple ordinal type code for a block pointed to by an
 * address in pblk, use the following:
 *
 * block	*pblk;
 * unsigned	typecode;
 *   ...
 *  typecode = *((unsigned char *)((long)pblk - 1)); (Intel platform)
 *  typecode = *((unsigned *)((long)pblk - 4));      (Sun, RS/6000, SGI, etc.)
 *
 *
 * Here's a visualization of how SPITBOL stores data blocks and identifies
 * their type by pointing to unique sections of code:
 *
 *
 *   In Data Space:                        In Code Space:
 * +---------------------+               +-----------+
 * |      Type Word      |----+          | Type code |
 * +---------------------+    |          +-----------+----------------+
 * |      Block Data     |    +--------->|   Program Code for this    |
 *...                   ...              |   Block Type               |
 * |                     |               |                            |
 * +---------------------+               +----------------------------+
 *
 *
 * Given an integer type, the Type Word can be obtained by
 * looking it up in a table provided to external functions as ptyptab in
 * the misc info structure.  For example, if the locator information
 * structure is passed to the function as an argument called "info",
 * use the following:
 *
 * unsigned typecode;
 * mword	typeword;
 *  ...
 *   typeword = (*info.ptyptab)[typecode];
 */

/*
 * BLOCK CODES FOR ACCESSIBLE DATATYPES
 *
 * These blocks may appear in an argument list if left untranslated
 * by the LOAD function definition.
 */

enum {
    BL_AR =	0,				/* ARBLK	ARRAY								*/
    BL_CD,					/* CDBLK	CODE								*/
    BL_EX,					/* EXBLK	EXPRESSION							*/
    BL_IC,					/* ICBLK	INTEGER								*/
    BL_NM,					/* NMBLK	NAME								*/
    BL_P0,					/* P0BLK	PATTERN, 0 args						*/
    BL_P1,					/* P1BLK	PATTERN, 1 arg						*/
    BL_P2,					/* P2BLK	PATTERN, 2 args						*/
    BL_RC,					/* RCBLK	REAL								*/
    BL_SC,					/* SCBLK	STRING								*/
    BL_SE,					/* SEBLK	EXPRESSION							*/
    BL_TB,					/* TBBLK	TABLE								*/
    BL_VC,					/* VCBLK	VECTOR (array)						*/
    BL_XN,					/* XNBLK	EXTERNAL, non-relocatable contents	*/
    BL_XR,					/* XRBLK	EXTERNAL, relocatable contents		*/
    BL_BC,					/* BCBLK	BUFFER CONTROL						*/
    BL_PD,					/* PDBLK	PROGRAM DEFINED DATATYPE			*/
    BL__D					/* NUMBER OF BLOCK CODES FOR DATA				*/
};

/*
 * OTHER BLOCK CODES
 *
 * These blocks will never appear in an argument list, but are
 * listed here for completeness.
 */

enum {
    BL_TR = BL__D,			/* TRBLK	TRACE							*/
    BL_BF,					/* BFBLK	BUFFER							*/
    BL_CC,					/* CCBLK	CODE CONSTRUCTION				*/
    BL_CM,					/* CMBLK	COMPILER TREE NODE				*/
    BL_CT,					/* CTBLK	CHARACTER TABLE					*/
    BL_DF,					/* DFBLK	DATATYPE FUNCTION				*/
    BL_EF,					/* EFBLK	EXTERNAL FUNCTION				*/
    BL_EV,					/* EVBLK	EXPRESSION VARIABLE				*/
    BL_FF,					/* FFBLK	FIELD FUNCTION					*/
    BL_KV,					/* KVBLK	KEYWORD VARIABLE				*/
    BL_PF,					/* PFBLK	PROGRAM-DEFINED FUNCTION		*/
    BL_TE					/* TEBLK	TABLE ELEMENT					*/
};

/*
 * Structure of common SPITBOL blocks:
 * 	    Integer, Real, String, and File blocks.
 *
 *  	These structures are part of the "blocks" union that can be applied
 * 	    to the result area to determine where to store required return
 *      information.
 */

/*
 *  	Structure of ICBLK (integers)
 */

struct icblk {
    mword 	ictyp;					/* type word						*/
    mword 	icval;					/* integer value					*/
};


/*
 * 		Structure of RCBLK (reals)
 */
#if sparc
/*
 * 		Note that the obvious declaration "double rcval" can not be
 *      used, because the SPARC C compiler insists on placing double
 * 		values on an 8-byte boundary, effectively making the rcblk into
 * 		a four-word structure, instead of three. (A filler word is
 * 		inserted between rctyp and rcval).  But an rcblk really is a
 * 		three-word structure inside of SPITBOL.
 *
 * 		As a workaround, we define rcvals as a two word array, and use
 * 		an rcval macro to access the double value there.  The macro
 * 		is invoked with the rcblk as its argument.  For example,
 * 		suppose presult pointed to a union of all block types.  The
 * 		double value stored in an rcblk there would be accessed as
 *
 * 			rcval(presult->rcb)
 *
 * 		It may be necessary to use the -misalign command option with
 * 		cc to have the compiler generate the two single-precision loads
 * 		needed to access the real at rcvals.  The normal double-precision
 * 		load will fault because the operand is not aligned properly.
 *
 *  	See function retreal in extrnlib.c for an example.
 */
struct rcblk {
    mword	rctyp;					/* type word						*/
    mword	rcvals[2];				/* real value (not 8-byte aligned!)	*/
};
#define rcval(blk) (*(double *)blk.rcvals) /* access double at rcvals	*/
#else
struct rcblk {
    mword	rctyp;					/* type word						*/
    double	rcval;					/* real value (not 8-byte aligned!)	*/
};
#endif

/*
 *  	Structure of SCBLK (strings)
 */

struct scblk {
    mword	sctyp;					/* type word						*/
    mword	sclen;					/* string length					*/
    char	scstr[1];				/* start of string					*/
};

/*
 *   	Structure for returning a far string
 */

struct fsblk {
    mword	fstyp;					/* type word						*/
    mword	fslen;					/* string length					*/
    far char *fsptr;				/* far pointer to string				*/
};


/*
 *   	Structure for returning a far external block
 */

struct fxblk {
    mword	fxtyp;					/* type word						*/
    mword	fxlen;					/* external data length				*/
    far void *fxptr;				/* far pointer to external data			*/
};


/*
 * FILE CONTROL BLOCK
 *
 * The user may provide the word "FILE" for any argument in
 * the LOAD function prototype.  When a call is made to the
 * external function with an I/O associated variable in this argument
 * position, SPITBOL will provide a pointer to the file control
 * block instead of the value of the variable.
 *
 * The file control block (FCB) points to an I/O block with
 * additional information.  In turn, the I/O block points to any
 * buffer used by the file.
 *
 * This block is obtained for every file except those associated
 * with INPUT, OUTPUT, or TERMINAL.  Note that these FCB's are
 * unrelated to MS-DOS FCB's.  File control blocks do not have
 * their own type word, but appear as XRBLKs with the following structure:
 */

struct fcblk {
    mword			fcbtyp;	 		/* type word (XRBLK)				*/
    mword			fcblen;	 		/* size of block, in bytes			*/
    mword			fcbrsz;	 		/* SPITBOL record size and mode
									   positive if text mode,
									   negative if binary.				*/
    struct ioblk   *fcbiob;			/* pointer to IOBLK					*/
    mword			fcbmod;			/* 1 if text mode, 0 if binary mode	*/
};


/*
 *   CHFCB - chain of FCBs block
 *
 *   For every FCB created by OSINT, the compiler creates a CHFCB pointing
 *   to the FCB and links it onto a chain of CHFCBs.  At EOJ the head of this
 *   CHFCB chain is passed to the interface function SYSEJ so that all files
 *   can be closed.
 */

struct	chfcb {
    mword	typ;				/*  type word			*/
    mword	len;				/*  block length		*/
    struct	chfcb *nxt;			/*  pointer to next chfcb	*/
    struct	fcblk *fcp;			/*  pointer to fcb		*/
};



/*
 * I/O BLOCK
 *
 * An I/O block is pointed to by the fcbiob field of a file control block.
 */

struct ioblk {
    mword			iobtyp;	   		/* type word (XRBLK)				*/
    mword			ioblen;			/* size of IOBLK in bytes			*/
    struct scblk   *iobfnm;			/* SCBLK holding filename			*/
    mword			iobpid;			/* pipe id (not used for DOS)		*/
    struct bfbblk  *iobbfb;         /* pointer to BFBBLK                */
    mword			iobfdn;			/* O/S file descriptor number 		*/
    mword			iobflg1;		/* flags 1 (see below)				*/
    mword			iobflg2;		/* flags 2 (see below)				*/
    mword			iobeol1;		/* end of line character 1			*/
    mword			iobeol2;		/* end of line character 2			*/
    mword			iobshare; 		/* sharing mode						*/
    mword			iobaction;		/* file open actions				*/
};

/*
 * 	Bits in iobflg1 dword
 */
#define IO_INP	0x00000001			/* input file							*/
#define IO_OUP	0x00000002			/* output file							*/
#define IO_APP	0x00000004			/* append output to existing file		*/
#define IO_OPN	0x00000008			/* file is open							*/
#define IO_COT	0x00000010			/* console output to non-disk device	*/
#define IO_CIN	0x00000020			/* console input from non-disk device	*/
#define IO_SYS	0x00000040			/* -f option used instead of name		*/
#define IO_WRC	0x00000080			/* output without buffering				*/

/*
 * 	Bits in iobflg2 dword
 */
#define IO_PIP	0x00000001			/* pipe (not used in MS-DOS)			*/
#define IO_DED	0x00000002			/* dead pipe (not used in MS-DOS)		*/
#define IO_ILL	0x00000004			/* illegal I/O association				*/
#define IO_RAW	0x00000008			/* binary I/O to character device			*/
#define IO_LF 	0x00000010			/* ignore line feed if next character	*/
#define IO_NOE	0x00000020			/* no echo input						*/
#define IO_ENV	0x00000040			/* filearg1 mapped via environment var	*/
#define IO_DIR  0x00000080		    /* buffer is dirty (needs to be written)*/
#define	IO_BIN	0x00000100			/* binary I/O */

/* Private flags used to convey sharing status when opening a file */
#define IO_COMPATIBILITY	0x00
#define IO_DENY_READWRITE	0x01
#define IO_DENY_WRITE		0x02
#define IO_DENY_READ		0x03
#define IO_DENY_NONE		0x04
#define IO_DENY_MASK		0x07		/* mask for above deny mode bits*/
#define	IO_EXECUTABLE		0x40		/* file to be marked executable */
#define IO_PRIVATE			0x80		/* file is private to current process */

/* Private flags used to convey file open actions */
#define IO_FAIL_IF_EXISTS		0x00
#define IO_OPEN_IF_EXISTS		0x01
#define IO_REPLACE_IF_EXISTS	0x02
#define IO_FAIL_IF_NOT_EXIST	0x00
#define IO_CREATE_IF_NOT_EXIST	0x10
#define IO_EXIST_ACTION_MASK	0x13	/* mask for above bits */
#define IO_WRITE_THRU       	0x20	/* writes complete before return*/

/*
 * I/O BUFFER BLOCK
 *
 * An I/O buffer block (BFBBLK) is pointed to by an IOBLK.
 *
 * Size of file position words in I/O buffer block
 */

#if SETREAL
typedef double FILEPOS;     /* real file positions */
#else
typedef long FILEPOS;       /* 32-bit file positions */
#endif

struct bfbblk {
    mword	bfbtyp;					/* type word (XNBLK)					*/
    mword	bfblen;					/* size of BFBBLK, in bytes				*/
    mword	bfbsiz;					/* size of buffer in bytes				*/
    mword	bfbfil;					/* number of bytes currently in buffer	*/
    mword	bfbnxt;					/* offset of next buffer char to r/w	*/
    FILEPOS bfboff;                 /* file position of first byte in buf   */
    FILEPOS bfbcur;                 /* physical file position               */
    char	bfbbuf[1];				/* start of buffer						*/
};


/*
 * Structure of EFBLK (external function).  A pointer to this block
 * is passed to the external function in the stack in info.pefblk.
 */

struct efblk {
    mword			fcode;			/* type word							*/
    mword   		fargs;			/* number of arguments					*/
    mword			eflen;			/* block length							*/
    mword			efuse;			/* usage count							*/
    struct xnblk   *efcod;			/* pointer to XNBLK, see below			*/
    struct vrblk   *efvar;			/* pointer to VRBLK with function name	*/
    mword			efrsl;			/* result type  (see below)				*/
    mword			eftar[1];		/* array of argument types, one per arg	*/
};

/*
 * efrsl and eftar[] contain small integer type codes as follows:
 */

#define noconv	0					/* argument remains unconverted			*/
#define constr	1					/* convert argument to string			*/
#define conint	2					/* convert argument to integer			*/
#define conreal	3					/* convert argument to real				*/
#define confile	4					/* produce fcb associated with variable	*/


/*
 * Structure of XNBLK allocated for external function
 * A pointer to this structure is passed to the external function
 * in the stack in pxnblk.
 *
 * This structure is used to ways:
 *   1.	 As a general structure in which the user can place private
 * 		 data and have it maintained by SPITBOL.
 *
 *   2.  As a particular structure in which information about each
 * 		 external function is maintained.
 */

struct xnblk {
    mword	xntyp;					/* type word							*/
    mword	xnlen;					/* length of this block					*/
    union {							/* two uses for rest of block:			*/
        mword	xndta[1];			/* 1. user defined data starts here		*/
        struct ef {                 /* 2. external function info            */
            mword   xnoff;          /*    base offset of function image     */
            mword   xnsiz;          /*    size of function in bytes         */
            mword   xneip;          /*    transfer EIP                      */
            short	xncs;			/*    transfer CS						*/
            mword   xnesp;          /*    transfer ESP, 0 = SPITBOL's stack */
            short	xnss;			/*	  transfer SS, 0 = SPITBOL's stack	*/
            short	xnds;			/*	  transfer DS						*/
            short	xnes;			/*	  transfer ES						*/
            short	xnfs;			/*	  transfer FS						*/
            short	xngs;			/*	  transfer GS						*/
            short	xn1st;			/*    non-zero = first-ever call		*/
            short	xnsave;			/*    non-zero = first call after reload*/
            far void (*xncbp)(void);/*    callback function prior to exiting*/
            short	xnpad;			/*    pad to dword boundary				*/
        } ef;
    } xnu;
};

/*
 * Simplified access to xn1st and xnsave words in xnblk via pointer to
 * miscellaneous info area in pinfo.
 */

#define first_call ((*((*pinfo).pxnblk)).xnu.ef.xn1st)
#define reload_call ((*((*pinfo).pxnblk)).xnu.ef.xnsave)


/*
 * Other selected blocks of interest:
 *
 *
 * ARRAY BLOCK
 *
 * An array block (ARBLK) represents an array value other than one
 * with one dimension whose lower bound is one (see VCBLK).
 */

struct arblk1 {	   					/* One dimensional array				*/
    mword			arblk;			/* type word (ARBLK)                    */
    mword			aridv;			/* identifier value						*/
    mword			arlen;			/* length of ARBLK in bytes				*/
    mword			arofs;			/* offset in arblk to arpro field		*/
    mword			arndm;			/* number of dimensions					*/
    mword			arlbd;			/* low bound (first subscript)			*/
    mword			ardim;			/* dimension (first subscript)			*/
    struct scblk   *arpro;			/* array prototype string				*/
    union block	   *arvls[1];		/* start of values in row-wise order	*/
};

struct arblk2 {						/* Two dimensional array				*/
    mword			arblk;	  		/* type word (ARBLK)                    */
    mword			aridv;	  		/* identifier value						*/
    mword			arlen;			/* length of ARBLK in bytes				*/
    mword			arofs;			/* offset in arblk to arpro field		*/
    mword			arndm;			/* number of dimensions					*/
    mword			arlbd;			/* low bound (first subscript)			*/
    mword			ardim;			/* dimension (first subscript)			*/
    mword			arlb2;			/* low bound (second subscript)			*/
    mword			ardm2;			/* dimension (second subscript)			*/
    struct scblk   *arpro;			/* array prototype string				*/
    union block	   *arvls[1];		/* start of values in row-wise order	*/
};

#define ndim	3					/* For example, 3-dimensional array		*/
struct arblkn {						/* N-dimensional array					*/
    mword			arblk;			/* type word (ARBLK)                    */
    mword			aridv;			/* identifier value						*/
    mword			arlen;			/* length of ARBLK in bytes				*/
    mword			arofs;			/* offset in arblk to arpro field		*/
    mword			arndm;		  	/* number of dimensions					*/
    struct {
        mword	arlbd;				/* low bound (first subscript)			*/
        mword	ardim;				/* dimension (first subscript)			*/
    } 			bounds[ndim]; 	/* adjust for number of dimensions		*/
    struct scblk   *arpro;  		/* array prototype string				*/
    union block	   *arvls[1];		/* start of values in row-wise order	*/
};


/*
 * 	BUFFER CONTROL BLOCK
 *
 *	A buffer control block (BCBLK) is created by the BUFFER
 *	function, and serves as an indirect control header for the
 *	buffer. It contains the number of characters currently
 *	stored in the buffer.
 */
struct bcblk {
    mword	bctyp;					/* type word							*/
    mword	bcidv;					/* identifier value						*/
    mword	bclen;					/* number of chars in use in bfblk		*/
    mword	bcbuf;					/* pointer to bfblk						*/
};


/*
 * 	STRING BUFFER BLOCK
 *
 *	A string buffer block (BFBLK) contains the actual buffer
 *	memory area. It specifies the largest string that can be
 *	stored in the buffer.
 */
struct bfblk {
    mword	bftyp;					/* type word							*/
    mword	bfalc;					/* allocated size of buffer				*/
    char	bfchr[1];				/* characters of string					*/
};


/*
 * CODE BLOCK
 *
 * A code block (CDBLK) is present for every source statement.
 */

struct cdblk {
    mword			cdjmp;			/* ptr to routine to execute statement	*/
    mword			cdstm;			/* statement number						*/
    mword			cdsln;			/* source file line number				*/
    mword			cdlen;			/* length of CDBLK in bytes				*/
    union {
        struct cdblk *cdnxt;		/* if failure exit is next statement	*/
        struct vrblk *cdlab;		/* if failure exit is a simple label	*/
        char 		 *cdnof;		/* no failure exit (-NOFAIL mode)		*/
        mword		  cddir;		/* failure exit is complex or direct	*/
    }			cdfal;			/* Failure exit							*/
    mword			cdcod[1];		/* executable pseudo-code				*/
};


/*
 * NAME BLOCK
 *
 * A name block (NMBLK) is used whereever a name must be stored as
 * a value following use of the unary dot operator.
 */

struct nmblk {
    mword			nmtyp;		  	/* type word (NMBLK)					*/
    union block	   *nmbas;			/* base pointer for variable			*/
    mword			nmofs;			/* offset within block for variable		*/
};


/*
 * TABLE BLOCK
 *
 * A table block (TBBLK) is used to represent a table value.
 * It comprises a list of buckets, each of which may point to
 * a chain of TEBLKs.  TBBUK entries either point to the first
 * TEBLK on the chain or they point to the TBBLK itself to
 * indicate the end of the chain.  The number of buckets can
 * be deduced from tblen.
 */

struct tbblk {
    mword			tbtyp;			/* type word (TBBLK)					*/
    mword			tbidv;			/* identifier value						*/
    mword			tblen;			/* length of TBBLK in bytes				*/
    union block	   *tbinv; 			/* default initial lookup value			*/
    struct teblk   *tbbuk[1];		/* start of hash bucket pointers		*/
};


/*
 * TABLE ELEMENT BLOCK
 *
 * A table element (TEBLK) is used to represent a single entry in
 * a table.
 */

struct teblk {
    mword			teblk;			/* type word (TEBLK)					*/
    union block	   *tesub;			/* subscript value						*/
    union block    *teval;			/* table element value					*/
    struct teblk   *tenxt;			/* next TEBLK or TBBLK if end of chain	*/
};


/*
 * VARIABLE BLOCK
 *
 * A variable block (VRBLK) is used to hold a program variable.
 */

struct vrblk {
    mword			vrget;			/* routine to load variable onto stack	*/
    mword			vrsto;			/* routine to store stack top into var.	*/
    union block	    *vrval;			/* variable value						*/
    mword			vrtra;			/* routine to transfer to label			*/
    union block	   *vrlbl;			/* pointer to code for label			*/
    union block	   *vrfnc;			/* function block if name is function	*/
    struct vrblk   *vrnxt;			/* next vrblk on hash chain				*/
    mword			vrlen;			/* length of name						*/
    char			vrchs[1];		/* characters of name					*/
};


/*
 * VECTOR BLOCK
 *
 * A vector block (VCBLK) is used to represent an array value which has
 * one dimension whose lower bound is one. All other arrays are
 * represented by ARBLKs.  The number of elements can be deduced
 * from vclen.
 */

struct vcblk {
    mword			vctyp;			/* type word (VCBLK)					*/
    mword			vcidv;			/* identifier value						*/
    mword			vclen;			/* length of vcblk in bytes				*/
    union block	   *vcvls[1];		/* start of vector values				*/
};


/*
 * UNION OF ALL BLOCKS
 *
 * A block is merely a union of all the block types enumerated here.
 *
 */

union block {
    struct arblk1	arb1;
    struct arblk2	arb2;
    struct arblkn	arbn;
    struct bcblk	bcb;
    struct bfblk	bfb;
    struct cdblk	cdb;
    struct efblk	efb;
    struct fcblk	fcb;
    struct fsblk	fsb;
    struct fxblk	fxb;
    struct icblk	icb;
    struct ioblk	iob;
    struct nmblk	nmb;
    struct rcblk	rcb;
    struct scblk	scb;
    struct tbblk	tbb;
    struct teblk	teb;
    struct vcblk	vcb;
    struct vrblk	vrb;
    struct xnblk	xnb;
};

#endif
/*------------------------  end of blocks32.h  ------------------------------*/
!@#$break.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  BREAK.C		Version:  01.00
/	---------------------------------------
/
/	Contents:	Function endbrk
/				Function startbrk
/			    Function rearmbrk
/
/	v1.00	02-Mar-91	Initial version for Unix.
/	V1.01	16-May-91	Initial version for MS-DOS using Intel compiler.
*/

/*
/   startbrk( )
/
/   startbrk starts up the logic for trapping user keyboard interrupts.
*/

#include "port.h"

#if POLLING
int	brkpnd;

#if UNIX
#include <signal.h>
#undef SigType
#define SigType void

static SigType (*cstat)Params((int));
void catchbrk Params((int sig));
void rearmbrk Params((void));

void startbrk()							/* start up break logic */
{
    brkpnd = 0;
    cstat = signal(SIGINT,catchbrk);	/* set to catch control-C */
}



void endbrk()							/* terminate break logic */
{
    signal(SIGINT, cstat);				/* restore original trap value */
}


/*
 *  catchbrk() - come here when a user interrupt occurs
 */
SigType catchbrk(sig)
int sig;
{
    word    stmct, stmcs;
    brkpnd++;
    stmct = GET_MIN_VALUE(STMCT,word) - 1;
    stmcs = GET_MIN_VALUE(STMCS,word);
    SET_MIN_VALUE(STMCT,1,word);                /* force STMGO loop to check */
    SET_MIN_VALUE(STMCS,stmcs - stmct,word);    /* counters quickly */
    SET_MIN_VALUE(POLCT,1,word);				/* force quick SYSPL call */
}


void rearmbrk()							/* rearm after a trap occurs */
{
    signal(SIGINT,catchbrk);			/* set to catch traps */
}
#endif
#endif					/* POLLING */

!@#$checkfpu.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
 * checkfpu - check if floating point hardware is present.
 *
 * Used on those systems where hardware floating point is
 * optional.  On those systems where it is standard, the
 * floating point ops are coded in line, and this module
 * is not linked in.
 *
 * Returns 0 if absent, -1 if present.
 */


#include "port.h"

#if FLOAT
#if FLTHDWR
checkfpu()
{
    return -1;			/* Hardware flting pt always present */
}
#else					/* FLTHDWR */

checkfpu()
{
    return -1;    /* Assume all modern machines have FPU (excludes 80386 without 80387) */
}

#endif					/* FLTHDWR */
#endif					/* FLOAT */
!@#$compress.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  COMPRESS.C	Version:  01.01
/	---------------------------------------
/
/	Contents:	Functions doexpand, docompress
/			Functions compress, expand
/
/	These functions are used to compress and expand a save file.
/
/	LZW data compression taken from an article by Mark R. Nelson in
/	the October 1989 Dr. Dobbs magazine.
/	Modified to flush table when full.
/
/	Note on memory allocation.  Both compression and decompression require
/	substantial tables.  Because a program is garbage collected prior to
/	being saved, there may exist a substantial block of memory between
/	dnamp and topmem.  The docompress and doexpand routines accept a pointer
/	to this block from the caller.  If the block provided is not large enough,
/	we call sbrk to extend the block as needed.  This additional memory is
/	released after the expansion/compression is completed.
/
/	IT IS ASSUMED THAT THE MEMORY PROVIDED BY THE CALLER IS THE LAST
/	ALLOCATED BLOCK ON THE HEAP, AND THAT ADDITIONAL MEMORY PROVIDED
/	BY SBRK() WILL BE CONTIGUOUS WITH THIS MEMORY.
/
/   v1.01 02-26-92	Correct input_code() to fill with zeros at end of file.
*/


#include "port.h"
#include "sproto.h"
#include <string.h>

#define HASHING_SHIFT (LZWBITS-8)
#define MAX_VALUE ((1L << LZWBITS) - 1)
#define MAX_CODE (MAX_VALUE - 1)

#if LZWBITS == 14
#define TABLE_SIZE 18041		/* The string table size needs to be a	*/
#endif							/* prime number that is somewhat larger	*/
#if LZWBITS == 13               /* than 2**LZWBITS       */
#define TABLE_SIZE 9029
#endif
#if LZWBITS == 12
#define	TABLE_SIZE 5021
#endif
#if LZWBITS == 11
#define	TABLE_SIZE 2551
#endif
#if LZWBITS <= 10
#define	TABLE_SIZE 1223
#endif

#if SAVEFILE

#define CODE_SIZE   (TABLE_SIZE*sizeof(short int))
#define PREFIX_SIZE (TABLE_SIZE*sizeof(short unsigned int))
#define APPEND_SIZE (TABLE_SIZE*sizeof(unsigned char))
#define DECODE_SIZE (4096*sizeof(unsigned char))
#define BUFF_SIZE (2048*sizeof(unsigned char))

static unsigned int input_code Params((word fd));
static void output_code Params((unsigned int code));
static unsigned char *decode_string Params((unsigned char *buffer, unsigned int code));
static int find_match Params((int hash_prefix, unsigned int hash_character));

/*
/ Memory needed for tables for expansion (EMEMORY) and compression (CMEMORY)
*/
#define EMEMORY (PREFIX_SIZE + APPEND_SIZE + DECODE_SIZE + BUFF_SIZE)
#define CMEMORY (CODE_SIZE + PREFIX_SIZE + APPEND_SIZE + DECODE_SIZE + BUFF_SIZE)

/*
/ doexpand - initialize or terminate expansion
*/
int doexpand(bits, freeptr, size)
int	bits;
char	*freeptr;
uword size;
{
    if (!(bits | expanding))	/* If not expanding, nothing to do */
        return 0;

    if (!bits && expanding)		/* Turn off expansion */
    {
        if (extra)
            sbrk(-extra);		/* release any extra memory acquired */
        extra = 0;
        expanding = 0;
        return 0;
    }

    if (bits == LZWBITS)          /* turn on expansion */
    {
        if (EMEMORY <= size)
            extra = 0;	/* no extra memory needed */
        else
        {
            extra = EMEMORY - size;	/* extra memory needed */
            if ((char *)sbrk((uword)extra) == (char *) -1)
                return 1;			/* not available */
        }
        expanding = bits;

        /* initialize for expansion */
        prefix_code = (short unsigned int *)freeptr;
        append_character = (unsigned char *)prefix_code + PREFIX_SIZE;
        decode_stack = (unsigned char *)append_character + APPEND_SIZE;
        buffer = decode_stack + DECODE_SIZE;
        bufcnt = 0;				/* buffer is empty */
        bit_buffer = 0L;
        bit_count = 0;
        return 0;
    }

    return 1;			/* failure */

}


/*
/	The following two routines are used to output variable length codes.
*/
static unsigned int input_code(fd)
word fd;
{
    unsigned int return_value;

    while (bit_count <= 24)
    {
        if (bufcnt <= 0)
        {
            bufcnt = read( fd, buffer, BUFF_SIZE);
            if (bufcnt < 0)
                return MAX_VALUE;
            if (!bufcnt) {				/* provide 0 at EOF until ... */
                *buffer = 0;			/* ... bit_buffer is shifted out */
                bufcnt++;
            }
            bufptr = buffer;
        }
        bit_buffer |= (unsigned long)*bufptr++ << (24-bit_count);
        bufcnt--;
        bit_count += 8;
    }
    return_value = (unsigned int)(bit_buffer >> (32-LZWBITS));
    bit_buffer <<= LZWBITS;
    bit_count -= LZWBITS;
    return return_value;
}

static void output_code(code)
unsigned int code;
{
    bit_buffer |= (unsigned long)code << (32-LZWBITS-bit_count);
    bit_count += LZWBITS;

    while (bit_count >= 8)
    {
        if (bufcnt >= BUFF_SIZE)
        {
            wrtaout((unsigned char FAR *) buffer, bufcnt);
            bufptr = buffer;
            bufcnt = 0;
        }
        *bufptr++ = (unsigned char)(bit_buffer >> 24);
        bufcnt++;
        bit_buffer <<= 8;
        bit_count -= 8;
    }
}


/*
/	This routine simple decodes a string from the string table, storing
/	it in a buffer.  The buffer can then be output in reverse order by
/	the expansion program.
*/
static unsigned char *decode_string(buffer, code)
unsigned char *buffer;
unsigned int code;
{
    register int i;

    i = 0;
    while (code > 255)
    {
        *buffer++ = append_character[code];
        code = prefix_code[code];
        if (i++ >= 4000)
        {
#if USEQUIT
            quit(356);
#else					/* USEQUIT */
            wrterr("Fatal error during save file expansion.");
            __exit(1);
#endif					/* USEQUIT */
        }
    }
    *buffer = (unsigned char) code;
    return buffer;
}


/*
/   expand( fd, startadr, size ) - read in section of file created by wrtaout()
/									with optional decompression.
/
/   Parameters:
/	fd		file descriptor
/	startadr	char pointer to first address to read
/	size		number of bytes to read
/   Returns:
/	0	successful
/	-2	error reading from a.out
/
/   Read data from .spx file.
*/
int
expand( fd, startadr, size )
word	fd;
unsigned char FAR *startadr;
uword size;

{
    unsigned char *string;
    unsigned int character;
    unsigned int old_code;
    unsigned int new_code;
    unsigned int next_code;

    if (!expanding)
        return rdaout( fd, startadr, size );

    if (!size)
        return 0;

    next_code = 256;					/* This is the next available code to define	*/
    old_code = input_code(fd);			/* Read in the first code, initialize the	*/
    character = old_code;				/* character variable, and send the first	*/
    *startadr++ = old_code;				/* code to the output file.					*/
    size--;

    /*
    /	This is the main expansin loop.  It reads in characters from the LZW file
    /	until it sees the special code used to indicate the end of the data.
    */
    while ((new_code=input_code(fd)) != MAX_VALUE)
    {
        /*
        /	This code checks for the special STRING+CHARACTER+STRING+CHARACTER+STRING
        /	case, which generates an undefined code.  It handles it by decoding
        /	the last code, adding a single character tothe end of the decode string
        */
        if (new_code >= next_code)
        {
            *decode_stack = character;
            string = decode_string(decode_stack+1, old_code);
        }

        /*
        /	Otherwise we do a straight decode of the new code.
        */
        else
            string = decode_string(decode_stack, new_code);

        /*
        /	Now we output the decoded string in reverse order
        */
        character = *string;
        while (string >= decode_stack)
        {
            *startadr++ = *string--;
            size--;
        }

        /*
        /	Finally, if possible, add a new code to the string table.
        */
        if (next_code <= MAX_CODE)
        {
            prefix_code[next_code] = old_code;
            append_character[next_code] = character;
            next_code++;
        }
        old_code = new_code;
        if (next_code > MAX_CODE)
            next_code = 256;			/* Restart codes when it gets too big */
    }
    return (size == 0 ? 0 : -2);
}


/*
/	This is the hashing routine.  It tries to find a match for the prefix+char
/	string in the string table.  If it finds it, the index is returned.  If
/	the string is not found, the first available index in the string table is
/	returned instead.
*/
static int find_match(hash_prefix, hash_character)
int hash_prefix;
unsigned int hash_character;
{
    int index;
    int offset;

    index = (hash_character << HASHING_SHIFT) ^ hash_prefix;
    if (index == 0)
        offset = 1;
    else
        offset = TABLE_SIZE - index;

    for (;;)
    {
        if (code_value[index] == -1)
            return index;
        if (prefix_code[index] == hash_prefix && append_character[index] == hash_character)
            return index;
        index -= offset;
        if (index < 0)
            index += TABLE_SIZE;
    }
}


/*
/	docompress - initialize and terminate compression
*/
int docompress(bits, freeptr, size)
int	bits;
char	*freeptr;
uword size;
{
    if (!(bits | compressing))	/* If not compressing, nothing to do */
        return 0;

    if (!bits && compressing)	/* Turn off compression */
    {
        output_code(0);			/* This code flushes the output buffer	*/
        if (bufcnt)
            wrtaout((unsigned char FAR *)buffer, bufcnt);
        bufcnt = 0;
        if (extra)
            sbrk(-extra);		/* release any extra memory acquired */
        extra = 0;
        compressing = 0;
        return 0;
    }

    if (bits == LZWBITS)          /* turn on compression */
    {
        if (CMEMORY <= size)
            extra = 0;	/* no extra memory needed */
        else
        {
            extra = CMEMORY - size;	/* extra memory needed */
            if ((char *)sbrk((uword)extra) == (char *) -1)
                return 1;			/* not available */
        }
        compressing = bits;

        /* initialize for compression */
        code_value = (short int *)freeptr;
        prefix_code = (short unsigned int *)((char *)code_value + CODE_SIZE);
        append_character = (unsigned char *)prefix_code + PREFIX_SIZE;
        decode_stack = (unsigned char *)append_character + APPEND_SIZE;
        buffer = decode_stack + DECODE_SIZE;
        bufcnt = 0;				/* buffer is empty */
        bufptr = buffer;
        bit_buffer = 0L;
        bit_count = 0;
        return 0;
    }

    return 1;			/* failure */

}


/*
/   compress( startadr, size )
/
/   Parameters:
/	startadr	char pointer to first address to write
/	size		number of bytes to write
/   Returns:
/	0	successful
/	-2	error writing memory to a.out
/
/   Write data to a.out file.
*/
int
compress( startadr, size )
unsigned char FAR *startadr;
uword size;
{
    unsigned int index;
    unsigned int string_code;
    unsigned int character;
    unsigned int next_code;

    if (!compressing)
        return wrtaout( startadr, size );

    if (!size)
        return 0;

    next_code = 256;				/* next_code is the next available string code	*/

    /* Clear out the string hash table before starting */
    memset((void *)code_value, -1, TABLE_SIZE*sizeof(short int));

    string_code = *startadr++;		/* Get the first code */
    size--;

    /*
    /	This is the main loop where it all happens.  This loop runs until all of
    /	the input has been exhausted.  Note that it clears the table and starts over
    /	when all of the possible codes have been define.
    */
    while (size--)
    {
        character = *startadr++;

        index = find_match(string_code, character);	/* See if the string is in	*/
        if (code_value[index] != -1)				/* the table.  If it is,	*/
            string_code = code_value[index];		/* get the code value.  If	*/
        else										/* the string is not in the	*/
        {   /* table, try to add it.	*/
            if (next_code <= MAX_CODE)
            {
                code_value[index] = next_code++;
                prefix_code[index] = string_code;
                append_character[index] = character;
            }
            output_code(string_code);				/* When a string is found	*/
            string_code = character;				/* that is not in the table,*/
            if (next_code > MAX_CODE)				/* output the last string	*/
            {   /* after adding the new one */
                /* Clear out the string hash table and restart codes */
                memset((void *)code_value, -1, TABLE_SIZE*sizeof(short int));
                next_code = 256;
            }
        }
    }

    /*
    /	End of the main loop
    */
    output_code(string_code);					/* Output the last code			*/
    output_code(MAX_VALUE);						/* Output the buffer end code	*/
    return 0;
}
#endif					/* SAVEFILE */
!@#$cpys2sc.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  CPYS2SC.C	Version:  01.01
/	---------------------------------------
/
/	Contents:	Function cpy2sc
*/

/*
/   cpys2sc( cp, scptr, maxlen )
/
/   cpys2sc() copies a C style string pointed to by cp into the SCBLK
/   pointed to by scptr.
/
/   Parameters:
/	cp	pointer to C style string
/	scptr	pointer to SCBLK to receive copy of string
/	maxlen	maximum length of string area within SCBLK
/   Returns:
/	Nothing.
/
/   Side Effects:
/	Modifies contents of passed SCBLK (scptr).
/
/   v1.01, 12/28/90 - pad last word in SCBLK with zeros to match behavior of ALOCS.
/			Eliminated termch argument,  since it was always zero.
*/

#include "port.h"

void cpys2sc( cp, scptr, maxlen )

char	*cp;
struct	scblk	*scptr;
word	maxlen;

{
    register word	i;
    register char	*scbcp;

    scptr->typ = TYPE_SCL;
    scbcp	= scptr->str;
    for( i = 0 ; i < maxlen  &&  ((*scbcp++ = *cp++) != 0) ; i++ )
        ;
    scptr->len = i;
    while (i++ & (sizeof(word) - 1))
        *scbcp++ = 0;
}
!@#$doexec.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  DOEXEC.C		Version:  01.03
/	---------------------------------------
/
/	Contents:	Function doexec
*/

/*
/   doexec( scptr )
/
/   doexec() does an "execle" function call to invoke the shell on the
/   command string contained in the passed SCBLK.
/
/   Parameters:
/	scptr	pointer to SCBLK containing the command to execute
/   Returns:
/	No return if shell successfully executed
/	Returns if could not execute command
/
/
/	1.03	15-Oct-91	Intel bug in system() command.  Malloc must
/						allocate out of high memory to allow spawn to
/						work properly.  We set a global switch that
/						tells malloc to use sbrk to satisfy memory
/						request made by spawn() and system().
/

*/

#include "port.h"

char	*getshell();
char	*pathlast();

void doexec( scbptr )

struct	scblk	*scbptr;

{
    word	length;
    char	savech;
    char	*cp;
#if UNIX
    extern char **environ;
    char	*shellpath;
#endif					/* UNIX */
    length	= scbptr->len;
    cp	= scbptr->str;

    /*
    /	Instead of copying the command string, temporarily save the character
    /	following the string, replace it with a NUL, execute the command, and
    /	then restore the original character.
    */
    savech	= make_c_str(&cp[length]);

    /*
    /	Use function getshell to get shell's path and function lastpath
    /	to get the last component of the shell's path.
    */
    shellpath = getshell();
    execle( shellpath, pathlast( shellpath ), "-c", cp, (char *)NULL, environ );	/* no return */

    unmake_c_str(&cp[length], savech);
}
!@#$doset.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  DOSET.C		Version:  01.04
/	---------------------------------------
/
/	Contents:	Function doset
*/

/*
/   doset( ioptr, offset, whence )
/
/   doset() does an "LSEEK" function call on the file described by ioptr.
/   For output files, the buffer must be flushed before doing the LSEEK.
/   For input file, any "unread" characters in the buffer must be seeked
/   over as well.
/
/   Parameters:
/	ioptr	pointer to IOBLK describing file
/  offset   offset for LSEEK call
/  whence   type of LSEEK to perform
/   Returns:
/  Value returned by LSEEK (-1 if error).
/
/   History:
/
/   v1.01  05-Feb-1991  Modified for read/write I/O.
/
/	v1.02  13-May-1992  Changed offset argument and result type from
/						word to long.
/
/	V1.03	01-Aug-93	Add IO_EOT flag to ignore EOT char in DOS-mode
/						 text files.
/
/	V1.04	04-Jun-95	No longer have to clear IO_LF since it is only
/						used on a non-seekable device like a pipe.
*/

#include "port.h"


#if SETREAL
#include <math.h>       /* for floor() */
#endif

FILEPOS doset( ioptr, offset, whence )

struct	ioblk	*ioptr;
FILEPOS  offset;
int	whence;

{
    register struct	bfblk *bfptr = MK_MP(ioptr->bfb, struct bfblk *);
    FILEPOS target, newoffset;

    if (ioptr->flg2 & IO_PIP)
        return -1L;


    switch (whence) {
    case 0:								/* absolute position */
        target = offset;
        break;
    case 1:								/* relative to current position */
        target = offset +
                 (bfptr ? bfptr->offset + bfptr->next : LSEEK(ioptr->fdn, (FILEPOS)0, 1));
        break;
    case 2:								/* relative to EOF */
        target = offset + geteof(ioptr);
        break;
    default:
        return -1;
    }

    if (target < (FILEPOS)0)
        target = (FILEPOS)0;

    if (bfptr) {
        /*
         * see if target is within the present buffer
         */
        if (bfptr->offset <= target &&
                target <= bfptr->offset + bfptr->fill) {
            bfptr->next = (word)(target - bfptr->offset);
            return target;
        }

        /*
        /  Flush any dirty buffer before doing LSEEK.
        */
        if (flush(ioptr))
            return -1;						/* return if error */

        /*
        /	Seek to a position that is a multiple of the buffer size.
        */
#if SETREAL
        newoffset = floor(target / bfptr->size) * bfptr->size;
#else
        newoffset = (target / bfptr->size) * bfptr->size;
#endif
        if (newoffset != bfptr->curpos)
        {
            /* physical file position differs from desired new offset */
            FILEPOS newcurrent;
            newcurrent = LSEEK(ioptr->fdn, newoffset, 0);
            if (newcurrent < (FILEPOS)0)
                return -1;
            bfptr->offset = bfptr->curpos = newcurrent;
        }
        else
        {
            /* file is properly positined already */
            bfptr->offset = newoffset;
        }

        /*
        /	Now fill the buffer and position the next pointer carefully.
        */
        if (testty(ioptr->fdn) && fillbuf(ioptr) < 0)
            return -1;

        bfptr->next = (word)(target - bfptr->offset);
        if (bfptr->next > bfptr->fill)	{			/* if extending beyond EOF */
            if (ioptr->flg1 & IO_OUP)
                bfptr->fill = bfptr->next;			/* only allow if output file */
            else
                bfptr->next = bfptr->fill;			/* otherwise, limit to true EOF */
        }

        return bfptr->offset + bfptr->next;
    }
    else
        return LSEEK(ioptr->fdn, target, 0); /* unbuffered I/O */
}

FILEPOS geteof(ioptr)
struct ioblk *ioptr;
{
    register struct	bfblk *bfptr = MK_MP(ioptr->bfb, struct bfblk *);
    FILEPOS eofpos, curpos;

    if (!bfptr)								/* if unbuffered file */
        curpos = LSEEK(ioptr->fdn, (FILEPOS)0, 1);   /*  record current position */

    eofpos = LSEEK(ioptr->fdn, (FILEPOS)0, 2);      /* get eof position */

    if (bfptr) {
        bfptr->curpos = eofpos;				/* buffered - record position */
        if (bfptr->offset + bfptr->fill > eofpos)	/* if buffer extended */
            eofpos = bfptr->offset + bfptr->fill;	/* beyond physical file */
    }
    else
        LSEEK(ioptr->fdn, curpos, 0);    /* unbuffered - restore position */


    return eofpos;
}
!@#$dosys.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  DOSYS.C		Version:  01.04
/	---------------------------------------
/
/	Contents:	Function dosys
/
/	1.04	15-Oct-91	Intel bug in system() command.  Malloc must
/						allocate out of high memory to allow spawn to
/						work properly.  We set a global switch that
/						tells malloc to use sbrk to satisfy memory
/						request made by spawn() and system().
/
/   1.03  08-May-91 <withdrawn>.
/
/	1.02	23-Jun-90	Add second argument for optional path specification.
/				Change first argument to C-string, not SCBLK.
/
/	1.01	04-Mar-88	Changes for Definicon
/
*/

/*
/   dosys( cmd, path )
/
/   dosys() does a "system" function call with the string contained in cmd.
/
/   Parameters:
/	cmd		C-string of command to execute
/	path	C-string of optional pathspec of program to execute.
/			May be null string.
/   Returns:
/	code returned by system
*/

#include "port.h"

int dosys( cmd, path )
char	*cmd;
char	*path;
{
    return system( cmd );
}

!@#$extern32.h
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*----------------------------  extern32.h  ------------------------------*/
#ifndef __extern32__
#define __extern32__

/*
 *  Definitions of routines and data available to C-language
 *  external function to be called from 32-bit versions of SPITBOL.
 *
 * 	V1.00  02/17/90 01:52pm
 * 		   Initial version
 *
 *  V1.01  10-18-91 04:53pm
 *         <withdrawn>.
 *
 *  V1.02  03-29-92 09:11am
 *       <withdrawn>.
 *
 *  V1.03  07-28-92 06:56am
 * 		   Customize for SPARC.
 *
 *	V1.04  09-12-94 07:13pm
 *		   Add definitions for buffers
 *
 *  V1.05  04-25-95 10:05pm
 *		   Customize for RS/6000
 *
 *  V1.06  12-29-96 06:05pm
 *         Customize for Windows NT
 *
 *  V1.07  03-04-97 12:45pm
 *			  Tweak for SPARC.
 *
 *  Definition of information placed on stack prior to pushing arguments to
 *  an external function.
 *
 *  Many of these items can be ignored, and are provided only for the
 *  benefit of those wishing to operate directly on SPITBOL's internal
 *  data structures.
 *
 *  However, the pointer in presult *must* be used by the external
 *  function to locate the area in which results are returned.
 *
 */

#include "system.h"
typedef int mword;				/* MINIMAL word	*/
typedef unsigned int muword;	/* MINIMAL unsigned word	*/
#ifndef far
#define far
#endif

#ifndef near
#define near
#endif

#ifndef Params
#if PROTOTYPES
#define Params(a) a
#else
#define Params(a) ()
#endif
#endif

#include "blocks32.h"
#include <string.h>


/* array of pointers to double functions */
typedef double (*APDF[])();


/*
 * Miscellaneous information provided by SPITBOL in pointer above the arguments.
 */

typedef struct misc {
    short			 vers;			/* version number of interface			*/
    unsigned char	 ext;			/* host environment, see ext_type below	*/
    unsigned char	 spare;			/* reserved 							*/
    mword			 nargs;		    /* number of args to function			*/
    mword		   (*ptyptab)[];	/* pointer to table of data types		*/
    struct xnblk 	*pxnblk;	    /* ptr to xnblk describing function		*/
    struct efblk 	*pefblk;		/* ptr to efblk describing function		*/
    APDF            *pflttab;		/* ptr to array of floating point fncs	*/
} misc;

enum ext_type {						/* Executing under:						*/
    t_pharlap,						/*  PharLap DOS Extender				*/
    t_intel,						/*  Intel DOS Extender					*/
    t_os2,							/*  OS/2 2.0							*/
    t_tc16,						 	/*  MS-DOS TurboC with 16-bit IA		*/
    t_tc32,							/*  MS-DOS TurboC with 32-bit IA		*/
    t_w1616,						/*  16-bit Windows, 16-bit SPITBOL		*/
    t_w1632,						/*  16-bit Windows, 32-bit SPITBOL		*/
    t_wnt8,							/*  Windows NT on 386/486				*/
    t_sparc,						/*  Sun 4 / SPARC						*/
    t_mac,							/*  Apple Macintosh						*/
    t_mips,							/*  MIPS R3000							*/
    t_rs6000,                       /*  IBM RS/6000                         */
    t_lnx8632,                      /*  Linux Intel x86 32-bit              */
    t_lnx8664                       /*  Linux Intel x86 64-bit              */
};

/*
 * Sample usage.  Definition for function arguments, assuming
 * calling function in SPITBOL with:
 *
 * 	 F(INTEGER,REAL,STRING)
 *
 * Because SPITBOL pushes arguments left to right, a Pascal
 * calling sequence should be used.  The could be supplied by
 * adding the __pascal keyword to the entry macro.
 *
 * However, because the SPARC and RS/6000 C compilers do not support
 * Pascal calling sequences, and we would like to move external function
 * source files easily between systems, the function definition will have
 * to manually reverse the arguments:
 *   entry(F)(presult, pinfo, parg3, larg3, rarg2, iarg1)
 *     union block	   *presult;		 pointer to result area
 *     misc		   	   *pinfo;		     miscellaneous info
 *     char	   		   *parg3;			 pointer to arg3 string
 *     mword	 		larg3;			 arg3 length
 *     double		   	rarg2;			 arg2 real number
 *     mword	   		iarg1;			 arg1 integer
 * {
 *    ....  start of function body
 */


/*
 * Simple names for datatypes.  Performs a lookup in SPITBOL's type
 * table to fetch a 32-bit type word for specific data types.
 */

#define ar	(*((*pinfo).ptyptab))[BL_AR]	/* Array		*/
#define bc	(*((*pinfo).ptyptab))[BL_BC]	/* Buffer Control	*/
#define bf	(*((*pinfo).ptyptab))[BL_BF]	/* String Buffer	*/
#define cd	(*((*pinfo).ptyptab))[BL_CD]	/* Code			*/
#define ex	(*((*pinfo).ptyptab))[BL_EX]	/* Expression	*/
#define ic	(*((*pinfo).ptyptab))[BL_IC]	/* Integer		*/
#define nm	(*((*pinfo).ptyptab))[BL_NM]	/* Name			*/
#define rc	(*((*pinfo).ptyptab))[BL_RC]	/* Real			*/
#define sc	(*((*pinfo).ptyptab))[BL_SC]	/* String		*/
#define tb	(*((*pinfo).ptyptab))[BL_TB]	/* Table		*/
#define vc	(*((*pinfo).ptyptab))[BL_VC]	/* Vector		*/
#define xn	(*((*pinfo).ptyptab))[BL_XN]	/* External		*/


/*
 * Non-standard block-type values that may be returned as a result:
 */

#define FAIL	(-1)			/* Signal function failure	*/
#define	BL_NC	100				/* Unconverted result		*/
#define BL_FS	101				/* Far string				*/
#define	BL_FX	102				/* Far external block		*/

/*
 * Length of string area in result buffer
 */

#define	buflen	512


/*
 * SPITBOL's Real Number Functions are not available to external
 * functions coded in C.  Use the normal C floating point library
 * to provide such support.
 */

/*
 * Function definitions for routines in extrnlib.c
 */
#if sparc | aix
#include <memory.h>
#endif

mword     retint Params((int val, union block *presult));
mword     retnstrt Params((char *s, size_t n, union block *presult));
mword     retnxdtf Params((void *s, size_t n, union block *presult));
mword     retreal Params((double val, union block *presult));
mword     retstrt Params((char *s, union block *presult));

#endif          /* __extern32__ */
/*-------------------------- end of extern32.h ------------------------*/
!@#$fakexit.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  FAKEXIT.C	Version:  01.00
/	---------------------------------------
/
/	Contents:	Function exit
*/

/*
/   exit()
/
/   This is a "fake" exit() function that prevents the linker from linking
/   in the standard C exit() function with all the associated stdio library
/   functions.
*/
#include "port.h"
#if !VCC
void exit(status)
int status;
{}
#endif

extern void _exit Params((int status));

void __exit(code)
int code;
{
    _exit(code);
}
!@#$float.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
 * float.c - floating point support for spitbol
 *
 * These routines are not called from other C routines.  Rather they
 * are called by inter.*, and by external functions.
 */

#include "port.h"
#if (FLOAT & !FLTHDWR) | (EXTFUN & (AIX))

/*
 * f_2_i - float to integer
 */
IATYPE f_2_i(ra)
double ra;
{
    return (IATYPE)ra;
}


/*
 * i_2_f - integer to float
 */
double i_2_f(ia)
IATYPE ia;
{
    return ia;
}

/*
 * f_add - floating add to accumulator
 */
double f_add(arg, ra)
double arg,ra;
{
    return ra+arg;
}

/*
 * f_sub - floating subtract from accumulator
 */
double f_sub(arg, ra)
double arg,ra;
{
    return ra-arg;
}

/*
 * f_mul - floating multiply to accumulator
 */
double f_mul(arg, ra)
double arg,ra;
{
    return ra*arg;
}


/*
 * f_div - floating divide into accumulator
 */
double f_div(arg, ra)
double arg,ra;
{
    return ra/arg;
}

/*
 * f_neg - negate accumulator
 */
double f_neg(ra)
double ra;
{
    return -ra;
}

#endif					/* (FLOAT & !FLTHDWR) | (EXTFUN & (AIX)) */
!@#$flush.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  FLUSH.C		Version:  01.02
/	---------------------------------------
/
/	Contents:	Function flush
/
/   V1.02 05-Feb-91	Flush only if dirty.  Adjust file position in buffer.
/   v1.01		Ignore short count writes if MS-DOS and character device.
*/

/*
/   flush( ioptr )
/
/   flush() writes out any characters in the buffer associated with the
/   passed IOBLK.
/
/   Parameters:
/	ioptr	pointer to IOBLK representing file
/   Returns:
/	0 if flush successful / number of I/O errors
*/

#include "port.h"

int flush( ioptr )
struct	ioblk	*ioptr;
{
    register struct bfblk	*bfptr = MK_MP(ioptr->bfb, struct bfblk *);
    register int	ioerrcnt = 0;
    register word	n;

    if ( bfptr ) {							/* if buffer */
        if ( ioptr->flg2 & IO_DIR ) {		/* if dirty */
            ioerrcnt += fsyncio(ioptr);     /* synchronize file and buffer */
            if ( bfptr->fill ) {
                n = write(ioptr->fdn, bfptr->buf, bfptr->fill);
                if ( n != bfptr->fill)
                    ioerrcnt++;

                if (n > 0)
                    bfptr->curpos += n;
            }
            ioptr->flg2 &= ~IO_DIR;
        }
        bfptr->offset += bfptr->fill;		/* advance file position */
        bfptr->next = bfptr->fill = 0;		/* empty the buffer */
    }
    return ioerrcnt;
}

/*
 * fsyncio - bring file into sync with buffer.  A brute force
 * approach is to always LSEEK to bfptr->offset, but this slows down
 * SPITBOL's I/O with many unnecessary LSEEKs when the file is already
 * properly positioned.  Instead, we remember the current physical file
 * position in bfptr->curpos, and only LSEEK if it is different
 * from bfptr->offset.
 *
 * For unbuffered files, the file position is always correct.
 *
 * Returns 0 if no error, 1 if error.
 */
int fsyncio( ioptr )
struct	ioblk	*ioptr;
{
    register struct bfblk *bfptr = MK_MP(ioptr->bfb, struct bfblk *);
    FILEPOS n;

    if (bfptr) {
        if (bfptr->offset != bfptr->curpos) {
            n = LSEEK(ioptr->fdn, bfptr->offset, 0);
            if (n >= 0)
                bfptr->curpos = n;
            else
                return 1;			/* I/O error */
        }
    }
    return 0;
}

!@#$getargs.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  GETARGS.C		Version:  01.00
/	---------------------------------------
/
/	Contents:	Function getargs
*/


/*
/	This module contains the switch loop that processes command
/	line options.
/
/	HISTORY
/
/  V1.00 30-Jul-92 Split off from OSINT as a separate module.
*/
#include "port.h"

#include <fcntl.h>


/*
 * getargs
 *
 * Input:
 *   argc:  count of argument strings
 *   argv:  array of argument string pointers
 *
 * Output:
 *   pointer to pointer to string of source file name, or NULL if none.
 *
 * Globals modified:
 *   cfiles[]
 *   cmdcnt
 *   databts
 *   inpcnt
 *   lnsppage
 *   maxf
 *   maxsize
 *   memincb
 *   outptr
 *   pagewdth
 *   readshell0
 *   spitflags
 *   stacksiz
 *   uarg
 */
static  int i;
static  char *cp;
static char *filenamearg Params((int argc, char *argv[]));

char **getargs( argc, argv )
int		argc;
char	*argv[];
{
    register char **result;

    /*
    /   Process all command line options.
    /
    /   NOTE:  the value of the loop control variable
    /   i is modified within the loop.
    /
    /   spitbol is invoked as
    /
    /	spitbol [options] [input-files]
    /
    /   where each option string begins with a '-'
    /
    /   A single '-' represents the standard file provided by the shell
    /   and is treated as an input-file or output file as appropriate.
    */
    result = (char **)0;		/* no source file */

    for( i = 1 ; i < argc ; i++ ) {
        cp = argv[i];			/* point to next cmd line argument	*/

        /*
         *   If this command line argument does not start with a '-
         *   OR is a single '-', treat is as the first filename.
         */
        if ( *cp != '-'  ||  !cp[1] ) {
            if ( !result )
                result = argv + i;	/* result -> first filename pointer	*/
            break;		/* break out of for loop		*/
        }

        /*
        /   Here to process option string.  Allow more than one option
        /   to be specified after the '-'.  For example, "-aez" and
        /    "-s24kae"
        */
        ++cp;
        while( *cp )
            switch( *cp++ ) {
                /*
                /	-?  display option summary
                */
            case '?':
                prompt();
                break;
#if !RUNTIME
                /*
                /   -a	turn on all listing options except header
                */
            case 'a':
                spitflag &= ~(NOLIST | NOCMPS | NOEXCS);
                break;

                /*
                /   -b	suppress signon message when reloading save file
                */
            case 'b':
                spitflag |= NOBRAG;
                break;

                /*
                /   -c	turn on compilation statistics
                */
            case 'c':
                spitflag &= ~NOCMPS;
                break;

                /*
                    /   -dnnn	set maximum size of dynamic area in bytes
                    */
            case 'd':
                cp = optnum( cp, &databts );
                /* round up to machine word boundary */
                databts = (databts + sizeof(int) - 1)  & ~(sizeof(int) - 1);
                break;

                /*
                /   -e don't send errors to terminal
                */
            case 'e':
                spitflag &= ~ERRORS;
                break;

                /*
                /   -f	don't fold lower case to upper case
                */
            case 'f':
                spitflag &= ~CASFLD;
                break;

                /*
                /   -gddd	set page length in lines  V1.08
                */
            case 'g':
                cp = getnum( cp, &lnsppage );
                break;

                /*
                /   -h	suppress version header in listing
                */
            case 'h':
                spitflag |= NOHEDR;
                break;

                /*
                /   -iddd	set memory expansion increment (bytes)
                */
            case 'i':
                cp = optnum( cp, &memincb );
                break;

                /*
                /   -k	run inspite of compilation errors
                */
            case 'k':
                spitflag &= ~NOERRO;
                break;

                /*
                /   -l	turn on compilation listing
                */
            case 'l':
                spitflag &= ~NOLIST;
                break;

                /*
                /   -mddd	set maximum size of object in dynamic area
                */
            case 'm':
                cp = optnum( cp, &maxsize );
                break;

                /*
                /   -n	suppress program execution
                */
            case 'n':
                spitflag |= NOEXEC;
                break;

                /*
                /   -o fff	set output file to fff
                /   -o:fff & -o=fff also allowed.
                */
            case 'o':
                outptr = filenamearg(argc, argv);
                if (!outptr)
                    goto badopt;
                break;

                /*
                /   -p	turn on long listing format
                */
            case 'p':
                spitflag |= LNGLST;
                spitflag &= ~NOLIST;
                break;

                /*
                /   -r	read INPUT from source program file
                */
            case 'r':
                readshell0 = 0;
                break;

                /*
                /   -s	set stack size in bytes
                */
            case 's': {
                cp = optnum( cp, &stacksiz );
                /* round up to machine word boundary */
                stacksiz = (stacksiz + sizeof(int) - 1)  & ~(sizeof(int) - 1);
            }
            break;

            /*
            /   -tddd	set line width in characters  V1.08
            */
            case 't':
                cp = getnum( cp, &pagewdth );
                break;
#endif					/* !RUNTIME */

                /*
                /   -T fff  write TERMINAL output to file fff
                /   -T:fff & -T=fff also allowed.
                */
            case 'T':
            {
                char *ttyfile;
                File_handle h;
                ttyfile = filenamearg(argc, argv);
                if (!ttyfile)
                    goto badopt;
                h = spit_open(ttyfile, O_WRONLY|O_CREAT|O_TRUNC,
                              IO_PRIVATE | IO_DENY_READWRITE /* 0666 */,
                              IO_REPLACE_IF_EXISTS | IO_CREATE_IF_NOT_EXIST |
                              IO_WRITE_THRU );
                if (h == -1)
                    goto badopt;
                ttyoutfdn(h);
            }
            break;

            /*
            /   -u aaa	set user argument accessible via host()
            */
            case 'u':
                uarg = argv[++i];
                if ( i == argc )
                    goto badopt;	/* V1.08 */
                break;


#if !RUNTIME
#if EXECFILE
                /*
                /   -w	write executable module after compilation
                */
            case 'w':
                spitflag |= WRTEXE;
                break;

#endif					/* EXECFILE */

                /*
                /   -x	print execution statistics
                */
            case 'x':
                spitflag &= ~NOEXCS;
                break;

#if SAVEFILE
                /*
                /   -y	write executable module after compilation
                */
            case 'y':
                spitflag |= WRTSAV;
                break;
#endif					/* SAVEFILE */

                /*
                /   -z	turn on standard listing options
                */
            case 'z':
                spitflag |= STDLST;
                spitflag &= ~NOLIST;
                break;
#endif					/* !RUNTIME */

                /*
                / -# fff	associate file fff with channel #
                */
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                if (++maxf >= Ncmdf) {
                    wrterr( "Too many files on command line." );
                    __exit(1);
                }
                cp = getnum(cp - 1, (uword *)&(cfiles[maxf].filenum));
                cfiles[maxf].fileptr = filenamearg(argc, argv);
                if (!cfiles[maxf].fileptr)
                    goto badopt;
                break;

                /*
                /   anything else is an error
                */
            default:
badopt:
                write( STDERRFD, "Illegal option -", 17 );
                write( STDERRFD,  (cp - 1), 1 );
                wrterr( "?" );
                __exit(1);			/* V1.08 */
            }
    }

    inpcnt = argc - i;		/* inpcnt =  number of filenames	*/

    /*
    /   Establish command counter for use by HOST(3) function
    */
    cmdcnt = i;
    return result;
}

/* Collect filename following option */
static char *filenamearg( argc, argv )
int		argc;
char    *argv[];
{
    char *result;

    if ( *cp == ':' || *cp == '=' )
    {
        if (*(cp + 1))
        {
            result = ++cp;
            while (*++cp)
                ;
        }
        else
            return (char *)0;
    }
    else
    {
        result = argv[++i];
        if ( i == argc || (result[0] == '-' && result[1] != '\0')
           )
            return (char *)0;    /* V1.08 */
    }
    return result;
}


/*
/    getnum() converts an ASCII string to an integer AND returns a pointer
/    to the character following the last valid digit.
/
/    Parameters:
/		cp	pointer to character string
/		ip	pointer to word receiving converted result
/    Returns:
/		Pointer to character following last valid digit in input string
/    Side Effects:
/		Modifies contents of integer pointed to by ip.
*/

char	*getnum( cp, ip )
char	*cp;
uword	*ip;
{
    word	result = 0;

    while( *cp >= '0'  &&  *cp <= '9' )
        result = result * 10 + *cp++ - '0';

    *ip = result;
    return  cp;
}


/*
/   optnum() converts an ASCII string to an integer AND returns a pointer
/   to the character following the last valid digit.  optnum() is similar
/   to getnum() except that optnum accepts a trailing 'k' or 'm' to indicate
/   that the value should be scaled in units of 1,024 or 1,048,576.
/
/   Parameters:
/		cp	pointer to character string
/		ip	pointer to word receiving converted result
/   Returns:
/		Pointer to character following last valid digit in input string,
/		including a trailing k.
/   Side Effects:
/		Modifies contents of integer pointed to by ip.
*/

char	*optnum( cp, ip )
char *cp;
uword *ip;
{
    char c;
    cp = getnum( cp, ip );

    c = *cp;
    if ( c == 'k' || c == 'K' ) {
        ++cp;
        *ip <<= 10;
    }

    if ( c == 'm' || c == 'M' ) {
        ++cp;
        *ip <<= 20;
    }

    return  cp;
}
!@#$gethost.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  GETHOST.C	Version:  01.05
/	---------------------------------------
/
/	Contents:	Function gethost
*/

/*
/   gethost( scptr, maxlen )
/
/   gethost() reads the first line from the host file into the passed SCBLK.
/
/   Parameters:
/	scptr	pointer to SCBLK to receive host string
/	maxlen	max length of string area in SCBLK
/   Returns:
/	Nothing.
/   Side Effects:
/	Modifies contents of passed SCBLK (scptr).
*/

#include "port.h"

char htype[] = "80386";
char osver[] = ":Linux ";

#include <fcntl.h>

void gethost( scptr, maxlen )
struct	scblk	*scptr;
word	maxlen;

{
    struct scblk *pHEADV = GET_DATA_OFFSET(HEADV,struct scblk *);
    int cnt = 0;
    word fd;

    if ( (fd = spit_open( HOST_FILE, O_RDONLY, IO_PRIVATE | IO_DENY_WRITE,
                          IO_OPEN_IF_EXISTS )) >= 0 )
    {
        cnt	= read( fd, scptr->str, maxlen );
        close( fd );
    }

#if EOL2
    if ( cnt > 0  &&  scptr->str[cnt-2] == EOL1 )
    {
        cnt--;
        scptr->str[--cnt] = 0;
    }
#else					/* EOL2 */
    if ( cnt > 0  &&  scptr->str[cnt-1] == EOL1 )
    {
        scptr->str[--cnt] = 0;
    }
#endif					/* EOL2 */

    if ( cnt == 0 )
    {
        /* Could not read spithost file.  Construct string instead */
        register char *scp;

        gettype( scptr, maxlen );
        scp = scptr->str + scptr->len;
        scp = mystrcpy(scp,osver);
        scp = mystrcpy(scp,":Macro SPITBOL ");
        scp += mystrncpy(scp, pHEADV->str, pHEADV->len );
        scp += mystrncpy(scp, pID1->str, (int)pID1->len);
        *scp++ = ' ';
        *scp++ = '#';
        cnt = scp - scptr->str;
    }

    scptr->len = cnt;
}



/*
 * Get type of host computer
 */
void gettype( scptr, maxlen )

struct	scblk	*scptr;
word	maxlen;
{
    cpys2sc( htype, scptr, maxlen );	/* Computer type */
}
!@#$getshell.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  GETSHELL.C	Version:  01.04
/	---------------------------------------
/
/	Contents:	Function getshell
/
/	V1.04	18-Oct-90	Rewrite to use findenv().
/
/	V1.03	23-Jun-90	Move pathlast() to swcinp.c.
/
/	V1.02	03-Mar-88	Return in tscblk in all cases, so that
/				there is room to append after command string.
/
/	V1.01	28-Feb-88	Remove usage of strlen and strcpy
/
*/

#include "port.h"

/*
/   getshell()
/
/   Function getshell returns the path for the current shell.
/
/   Parameters:
/	None
/   Returns:
/	Pointer to character string representing current shell path
*/

char *getshell()
{
    register char *p;

    if ((p = findenv(SHELL_ENV_NAME, sizeof(SHELL_ENV_NAME))) == (char *)0)
        p = SHELL_PATH;		/* failure -- use default */
    return p;			/* value (with a null terminator) */
}
!@#$globals.h
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
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
NoInit(	int		cmdcnt);		/*  command count			*/
NoInit(	int		gblargc);		/*  argc from command line		*/
NoInit(	char	**gblargv);		/*  argv from command line		*/
Init(	char	*uarg, 0);		/*  -u argument from command line	*/

/*
/   Information to be given to compiler
*/
Init(	uword	lnsppage, PAGE_DEPTH);	/*  lines per page for listings			*/
Init(	uword	pagewdth, PAGE_WIDTH);	/*  width of output line for listings	*/
Init(	long	spitflag, DFLT_FLAGS);	/*  flags to be given to compiler		*/

/*
/   Memory variables that control compiler's dynamic area and stack.
*/
Init(	uword	memincb, CHUNK_B_SIZE);	/*  meminc converted to bytes		*/
Init(	uword	databts, HEAP_SIZE * sizeof(word));	/*  max size in bytes of data area	*/
NoInit(	char	*basemem);		/*  base of dynamic memory		*/
NoInit(	char	*topmem);		/*  current top of dynamic memory	*/
NoInit(	char	*maxmem);		/*  maximum top of dynamic memory	*/
Init(	uword	maxsize, OBJECT_SIZE * sizeof(word));	/*  maximum size element in dyn. memory	*/
Init(	uword	stacksiz, STACK_SIZE);	/*  maximum size of stack in bytes	*/
NoInit(	char	*lowsp);			/*  lowest legal sp value		*/

/*
/   Variables that describe access to standard input and output files.
*/
Init(	int		inpcnt, 0);		/*  number of input files			*/
Init(	char	**inpptr, 0);	/*  pointer to input file in argv array	*/
NoInit(	char	*outptr);		/*  pointer to output listing file	*/
Init(	char	*sfn, 0);		/*  current source file name		*/
Init(	int	readshell0, 1);		/*  interlock default reading of fd 0	*/
Init(	int	first_record, 2);	/*  non-zero before first record read	*/
Init(	int	executing, 0);		/*  non-zero during execution		*/
Init(	int	originp, -1);		/*  dup of original fd 0			*/
Init(	int	curfile, 0);		/*  current file position (swcinp)	*/
Init(	int	errflag, 0);		/*  Nonzero if error in swcoup		*/
Init(	int	origoup, 1);		/*  Dup of shell's std output (swcoup)	*/
Init(	int	oupState, 0);		/*  Current state of swcoup			*/
Init(	int	nesting, 0);		/*  depth of include file nesting	*/
NoInit(	int	dcdone);			/*  if zysdc has written headlines	*/
Init(	int	provide_name, 1);	/*  sysrd to deliver filename to caller */
NoInit(	char   *pathptr);		/*  include file paths 				*/

NoInit(	word	bfblksize);
NoInit( struct ioblk	*save_iob);
Init(	word in_gbcol, 0);		/* record whether in GBCOL or not */
Init(	int mallocSys, 0);		/* Kludgy Intel interlock with malloc and free */
Init(	int first_time, -1);	/* Flag for systm.c */
NoInit(	long	start_time);	/* record start-up time for systm.c */
NoInit(	char	savexl);		/* used by syshs.c */
NoInit(	char	savexr);
NoInit(	int		inc_fd[INCLUDE_DEPTH]);	/* used by sysif.c	*/
NoInit(	int		fd);					/*  "    "   "		*/
NoInit(	FILEPOS	inc_pos[INCLUDE_DEPTH]);/*	"	 "	 "		*/

Init(	word	maxf, -1);		/* number of files specified this way -1 */

/*
/	Structure to record i/o files specified on command line
/	with /#=filename.
*/
#define Ncmdf	12

typedef	struct {
    word	filenum;
    char	*fileptr;
} CFile;
NoInit(	CFile	cfiles[Ncmdf]);	/* Array of structures to record info	*/

#define ttyiobininit {0,    /* type word            */ \
    IRECSIZ,                /* length               */ \
	0,						/* filename				*/ \
	0,						/* process id			*/ \
	0,						/* tty BFBLK 			*/ \
    STDERRFD,               /* file descriptor 2    */ \
    IO_INP+IO_OPN+IO_SYS+IO_CIN, /* flg1            */ \
	0,						/* flg2					*/ \
	EOL1,					/* end of line char 1	*/ \
	EOL2}					/* end of line char 2	*/

#define ttyioboutinit {0,   /* type word            */ \
	ORECSIZ,				/* length				*/ \
	0,						/* filename				*/ \
	0,						/* process id			*/ \
	0,						/* tty BFBLK 			*/ \
    STDERRFD,               /* file descriptor 2    */ \
    IO_OUP+IO_OPN+IO_SYS+IO_COT+IO_WRC, /* flg1     */ \
	0,						/* flg2					*/ \
	EOL1,					/* end of line char 1	*/ \
	EOL2}					/* end of line char 2	*/
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
	EOL1,					/* end of line char 1	*/ \
	EOL2 }					/* end of line char 2	*/
Init(	struct ioblk inpiob, inpiobinit);


#define outiobinit {0,		/* type word			*/ \
	ORECSIZ,				/* length				*/ \
	0,						/* filename				*/ \
	0,						/* process id			*/ \
	0,						/* no BFBLK needed		*/ \
	1,						/* file descriptor 1	*/ \
	IO_OUP+IO_OPN+IO_SYS+IO_WRC,  /* flg1: 			*/ \
	0,						/* flg2:				*/ \
	EOL1,					/* end of line char 1	*/ \
	EOL2 }		   			/* end of line char 2	*/
Init(	struct ioblk oupiob, outiobinit);

NoInit( char  namebuf[256]);
NoInit(	int		save_fd0);		/* Hold current fd 0 for swcinp */

#if SAVEFILE
Init(	int expanding, 0);	/* non-zero if doing expansion */
Init(	int compressing, 0);	/* non-zero if doing expansion */
Init(	long extra, 0);
NoInit(	int		bufcnt);
NoInit(	unsigned char *bufptr);
NoInit(	int		bit_count);
NoInit(	unsigned long bit_buffer);
NoInit(	short int *code_value);				/* This is the code value array			*/
NoInit(	short unsigned int *prefix_code);	/* This array holds the prefix codes	*/
NoInit(	unsigned char *append_character);	/* This array holds the appended chars	*/
NoInit(	unsigned char *decode_stack);		/* This array holds the decoded string	*/
NoInit(	unsigned char *buffer);				/* Read/write buffer					*/
#endif					/* SAVEFILE */

#if SAVEFILE | EXECFILE
NoInit(	int		aoutfd);
NoInit(  FILEPOS  fp);
#endif					/* SAVEFILE | EXECFILE */

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
extern int  hasfpu;
extern char cprtmsg[];
extern word reg_block;

#if ENGINE
/*
 * Engine globals
 */
NoInit(	word lastError);
#endif					/* ENGINE */
!@#$int.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
 * int.c - integer support for SPITBOL.
 *
 * Needed for RISC systems that do not provide integer multiply/
 * divide in hardware.
 */

#include "port.h"

#if SUN4

typedef long i;

/*
 * i_mli - multiply to accumulator
 */
i i_mli(arg,ia)
i arg,ia;
{
    return ia * arg;
}


/*
 * i_dvi - divide into accumulator
 */
i i_dvi(arg,ia)
i arg,ia;
{
    return ia / arg;
}

/*
 * i_rmi - remainder after division into accumulator
 */
i i_rmi(arg,ia)
i arg,ia;
{
    return ia % arg;
}

#endif					/* SUN4 */
!@#$lenfnm.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/ File:  LENFNM.C   Version:  01.02
/	---------------------------------------
/
/	Contents:	Function lenfnm
*/

/*
/   lenfnm( scptr )
/
/   lenfnm() examines the file argument within the passed SCBLK and returns
/   the length of the filename contained within it.  This function will be
/   called from any of the OSINT functions dealing with filenames or I/O
/   options.
*/

/*  The file argument string will contain a filename and/or options with the
/   options enclosed in "[" and "]", as in
/
/	"filename"
/	"filename[options]"
/	"[options]"
/
/  v1.02 23-Feb-96 - Check pipe syntax when bracketed options present.
*/

/*  The file argument can also contain options separated from the filename
/	by a blank.
/
/	"filename options"
/	" options"
/
*/

#if PIPES
/*
/   The file argument may instead be a command string with options as in
/
/	"!*commandstring"
/	"!*commandstring*"
/	"!*commandstring* options"
/
/   Notice that the character following the '!' serves as a delimiter to
/   separate the end of the command string from the space preceding any
/   options.
*/
#endif					/* PIPES */

/*  Parameters:
/	scptr	pointer to SCBLK containg filename string
/   Returns:
/	length of filename (0 is possible)
/       -1 if illegal name
*/

#include "port.h"

word lenfnm( scptr )

struct	scblk	*scptr;

{
    register word cnt, len, len2;
    register char	*cp;
#if PIPES
    register char delim;
#endif					/* PIPES */

    /*
    /	Null strings have filenames with lengths of 0.
    */
    len = len2 = scptr->len;
    if ( len == 0 )
        return	0L;

    /*
    /   Here to examine end of string for "[option]".
    */
    cp = &scptr->str[--len2];    /* last char of strng */
    if ( *cp == ']')			/* string end with "]" ? */
    {
        /* String ends with "]", find preceeding "[" */
        while (len2--)
        {
            if (*--cp == ']')
                break;
            if (*cp == '[')
            {
                /* valid option syntax, remove from length of string we'll examine */
                len = cp - scptr->str;
                break;
            }
        }
    }

    /* Look for space as the options delimiter */
    cp = scptr->str;

#if PIPES
    /*
    /	Here to bypass spaces within a pipe command.
    /   Count characters through second occurrence of delimiting
    /   character.  lenfnm( "!!foo goo!" ) = 10
    */
    if ( *cp == '!' )
    {
        if ( len < 3L )		/* "!!" clearly invalid		*/
            return	-1L;
        delim = *++cp;		/*  pick up delimiter		*/
        if ( *++cp == delim )	/* "!!!" also invalid		*/
            return	-1L;
        /*  count chars up to delim	*/
        for ( cnt = 2; cnt < len  && *cp++ != delim; cnt++ )
            ;
        if ( *--cp == delim )   /* if last char is delim then */
            ++cnt;             /*   include it in the count  */
        return cnt;
    }
#endif					/* PIPES */

    /*
    /	Here for a normal filename.  Just count the number of characters
    /	up to the first blank or end of string, whichever occurs first.
    */
    for ( cnt = 0; cnt < len  &&  *cp++ != ' '; cnt++ )
        ;
    return cnt;
}
!@#$main.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  MAIN.C		Version:  01.00
/	---------------------------------------
/
/	Contents:	Function main
*/

/*
/	This module contains the main function that gets control when
/	the spitbol compiler starts execution.  Responsibilities of
/	this function:
/
/	o  Save argc and argv parameters in global storage.
/
/	o  Determine if this execution reflects the invocation of
/	   of the compiler or of a load module and take appropriate
/	   actions.
/
/	   If invoked as compiler:  process command line arguments,
/	   set up input files, output file, initial memory allocation,
/	   and transfer control to compiler
/
/	   If invoked as load module:  reset various compiler variables
/	   whose values are no longer valid, re-establish dynamic area
/	   and transfer control to function that returns control to
/	   suspended spitbol program
/
/	HISTORY
/
/  V1.00 04-Jun-92 Split off from OSINT as a front-end module.
/  V1.01 30-Dec-96 Call swcinp after reloading SPX file.
/  V1.02 18-Mar-00 Don't interpret parameters following .spx on command
/                  line as file names.
*/
#define GLOBALS			/* global variables will be defined in this module */
#include "port.h"
#include <stdio.h>
#include <stdio.h>

#ifdef DEBUG
#undef DEBUG			/* Change simple -DDEBUG on command line to -DDEBUG=1 */
#define DEBUG 1
#else
#define DEBUG 0
#endif

void setout Params(( void ));

main( argc, argv )
int	argc;
char	*argv[];

{
    int		i;
    /*
    /   Save command line parameters in global storage, in case they are needed
    /   later.
    */
    gblargc = argc;
    gblargv = argv;
    lowsp = 0L;
    /*
    /	Initialize buffers
    */
    stdioinit();
    ttyinit();
    /*
    /	Make sure sysdc gets to output stuff at least once.
    */
    dcdone = 0;

#if EXECFILE
#if EXECSAVE
    /* On some platforms we implement execfiles differently.  A save file
     * is appended to the SPITBOL executable file, and will be read in
     * just like a save file specified on the command line.
     *
     * We have to check for the presence of a save file in the executable.
     */
    i = checksave(gblargv[0]);
    if (i) {
        inpptr = gblargv;
        if (getsave(i) != 1)
            __exit(1);
        close(i);

        /* set up things that normally would be retained in the
         * a Unix exec file.
         */
#if USEFD0FD1
        originp = dup(0);
#endif					/* USEFD0FD1 */
        readshell0 = 0;
#else					/* EXECSAVE */
    /*
    /   If this is a restart of this program from a load module, set things
    /   up for a restart.  Transfer control to function restart which actually
    /   resumes program execution.
    */
    if ( lmodstk ) {
        if ( brk( (char *) topmem ) < 0 ) { /* restore topmem to its prior state	*/
            wrterr( "Insufficient memory to load." );
            __exit(1);
        }
#endif					/* EXECSAVE */

        cmdcnt = 1;       /* allow access to command line args  */
        inpptr = 0;				/* no compilation input files		*/
        inpcnt = 0;				/* ditto				*/
        outptr = 0;				/* no compilation output file		*/
        pathptr = (char *)-1L;	/* include paths unknown 	*/
        clrbuf();				/* no chars left in std input buffer	*/
        sfn = 0;
#if FLOAT
        hasfpu = checkfpu();	/* check for floating point hardware */
#endif					/* FLOAT */
#if (SUN4 | LINUX) & !EXECSAVE
        heapmove();				/* move the heap up					*/
        malloc_empty();			/* mark the malloc region as empty	*/
#endif					/* SUN4 | LINUX */
        zysdc();							/* Brag if necessary */
        restart( (char *)0L, lowsp );       /* call restart to continue execution */
    }
#endif					/* EXECFILE */

    /*
     * 	Process command line arguments
     */
    inpptr = getargs(argc, argv);

    if ( inpptr )
        sfn = *inpptr;		/* pointer to first file name */
    else
    {
        zysdc();
        wrterr("");
        prompt();
    }

    /*
    /   Switch to proper input file.
    */
    swcinp( inpcnt, inpptr );

#if FLOAT
    /*
     * test if floating point hardware present
     */
    hasfpu = checkfpu();
#endif					/* FLOAT */

#if SAVEFILE | EXECSAVE
    switch (getsave(getrdfd())) {
    case 1:					/* save file loaded */
        inpcnt = 0;               /* v1.02 no more cmd line files */
        swcinp(inpcnt, inpptr );  /* v1.01 */
        restart( (char *)0L, lowsp );

    case 0:					/* not a save file */
#if RUNTIME
        wrterr("SPITBOL save (.spx) file only!");
#else					/* RUNTIME */
        break;
#endif					/* RUNTIME */

    case -1:				/* error loading save file */
        __exit(1);
    }
#endif					/* SAVEFILE | EXECSAVE */

    /*
    /	Setup output and issue brag message
    */
    setout();

#if !RUNTIME

    /*
     *	Force the memory manager to initialize itself
     */
    if ((char *)sbrk(0) == (char *)-1) {
        wrterr( "Insufficient memory.  Try smaller -d, -m, or -s command line options." );
        __exit( 1 );
    }

    /*
    /   Allocate stack
    */
    if ((lowsp = sbrk((uword)stacksiz)) == (char *) -1) {
        wrterr( "Stack memory unavailable." );
        __exit( 1 );
    }

    /*
    /   Allocate initial increment of dynamic memory.
    /
    */

    if ((basemem = (char *)sbrk((uword)memincb)) == (char *) -1) {
        wrterr( "Workspace memory unavailable." );
        __exit( 1 );
    }
    topmem = basemem + memincb;
    maxmem = basemem + databts;


    /*
    /   All compiler registers are initially zero, except for XL and XR which
    /   are set to top and bottom of heap.
    */
    SET_CP( 0 );
    SET_IA( 0 );
    SET_WA( 0 );
    SET_WB( 0 );
    SET_WC( 0 );
    SET_XR( basemem );
    SET_XL( topmem - sizeof(word) );

    /*
    /   Startup compiler.
    */
/*	fprintf(stderr,"calling startup\n");*/
    startup( (char *)0L, lowsp );
#endif					/* !RUNTIME */

    /*
    /   Never returns. exit is via exit().
    */
}



/*
/	wrterr( s )
/
/	Write message to standard error, and append end-of-line.
*/
void wrterr(s)
char	*s;
{
#if EOL2
    static char eol[2] = {EOL1,EOL2};

#else					/* EOL2 */
    static char eol[1] = {EOL1};
#endif					/* EOL2 */
    write( STDERRFD, s, length(s) );
    write( STDERRFD,  eol, sizeof(eol) );
}

void wrtint(n)
int	n;
{
#if EOL2
    static char eol[2] = {EOL1,EOL2};

#else					/* EOL2 */
    static char eol[1] = {EOL1};
#endif					/* EOL2 */
    /*
    	char str[16];
    	itoa(n,str);
    	write( STDOUTFD, str, length(str) );
    	write( STDOUTFD,  eol, sizeof(eol) );
    */
}

/*
/	wrtmsg( s )
/
/	Write message to standard output, and append end-of-line.
*/
void wrtmsg(s)
char	*s;
{
#if EOL2
    static char eol[2] = {EOL1,EOL2};

#else					/* EOL2 */
    static char eol[1] = {EOL1};
#endif					/* EOL2 */
    write( STDOUTFD, s, length(s) );
    write( STDOUTFD,  eol, sizeof(eol) );
}

/*
 * Setup output file.
 * Issue brag message if approriate
 *
 * This rather clumsy routine was placed here because of sequencing
 * concerns -- it can't be called with a save file until spitflag
 * has been reloaded.
 */
void setout()
{
    /*
     *	Brag prior to calling swcoup
     */
    zysdc();

    /*
    /   Switch to proper output file.
    */
    swcoup( outptr );

    /*
    /   Determine if standard output is a tty or not, and if it is be sure to
    /   inform compiler and turn off header.
    */
    spitflag &= ~PRTICH;
    if ( testty( getprfd() ) == 0 )
    {
        lnsppage = 0;
        spitflag |= (PRTICH | NOHEDR);
    }
}
int at_xl;
int at_xr;
int at_xs;
int at_wa;
int at_wb;
int at_wc;
int at_w0;
int at_cp;
int at_zz;

int last_xl;
int last_xr;
int last_xs;
int last_wa;
int last_wb;
int last_wc;
int last_w0;
int last_cp;

int AT_CALLS = 0;

#define DAVE
#ifdef DAVE
char * AT_DESC;
extern char at1_0;
void prtnl() {
	fprintf(stderr,"\n");
}
void prtval(int reg) {
	if (reg < 100000 && reg >= 0)
		fprintf(stderr," %8d ", reg);
	else
		/*fprintf(stderr," %8xx", reg);*/
		fprintf(stderr," ---------", reg);
}
void prtreg(char * name, int val) {
	prtval(val);
	fprintf(stderr," %s",name);
}
void prtdif(char* name, int old, int new, int listed)
{
	/* print old and new values of named register */
	fprintf(stderr,"%s:", name);
	prtval(old); fprintf(stderr," -> "); prtval(new);
	prtnl();
}

unsigned long at_off;
int zzz_calls=0;
/*void at_(long at_ip,char * at_desc) {*/
void zzz() {

	int changed = 0;
	int listed = 0;

	if(at_zz>0) zzz_calls++;
	fprintf(stderr, "zzz %d %d\n",zzz_calls, at_zz);

	/* print registers that have changed since last statement */

	/* see if any have changed. */
	if (at_xl != last_xl)  changed += 1;
	if (at_xr != last_xr)  changed += 1;
	if (at_xs != last_xs)  changed += 1;
	if (at_cp != last_cp)  changed += 1;
	if (at_wa != last_wa)  changed += 1;
	if (at_wb != last_wb)  changed += 1;
	if (at_wc != last_wc)  changed += 1;
	if (at_w0 != last_w0)  changed += 1;

	if (changed) {
/* marked changed Minimal registers with "!" to make it easy to search
   backward for last statement that changed a register. */
		prtnl();
		if (at_xl != last_xl)
			{ prtdif("xl.esi", last_xl, at_xl, listed); listed += 1; }
		if (at_xr != last_xr)
			{ prtdif("xr.edi", last_xr, at_xr, listed); listed += 1; }
		if (at_xs != last_xs)
			{ prtdif("xs.esp", last_xs, at_xs, listed); listed += 1; }
		if (at_cp != last_cp)
			{ prtdif("cp.ebp", last_cp, at_cp, listed); listed += 1; }
		if (at_wa != last_wa)
			{ prtdif("wa.ecx", last_wa, at_wa, listed); listed += 1; }
		if (at_wb != last_wb)
			{ prtdif("wb.ebx", last_wb, at_wb, listed); listed += 1; }
		if (at_wc != last_wc)
			{ prtdif("wc.edx", last_wc, at_wc, listed); listed += 1; }
		if (at_w0 != last_w0)
			{ prtdif("w0.eax", last_w0, at_w0, listed); listed += 1; }
		prtnl();
	}
	AT_CALLS++; /* count number of calls */

	if (AT_CALLS % 3 == 1) {
		/* print register values before the statement was executed */
		prtreg("xl.esi", at_xl);
		prtreg("xr.edi", at_xr);
		prtreg("xs.esp", at_xs);
		/* cp is last on line, so don't print it zero */
		if (at_cp) prtreg("cp.ebp", at_cp);
		fprintf(stderr, "\n");
		prtreg("wa.ecx", at_wa);
		prtreg("wb.ebx", at_wb);
		prtreg("wc.edx", at_wc);
		prtreg("w0.eax", at_w0);
		fprintf(stderr, "\n");
	}
	/* display instruction pointer and description of current statement. */
/*	fprintf(stderr, "\n%8xx %s\n", at_ip, p);*/

	/* save current register contents. */
	last_xl = at_xl; last_xr = at_xr; last_xs = at_xs; last_cp = at_cp;

	last_wa = at_wa; last_wb = at_wb; last_wc = at_wc; last_w0 = at_w0;

}
void AT_SHORT() {
    fprintf(stderr,"Enter short AT\n");
}
void strt()
{
	fprintf(stderr, "start minimal execution\n");
}
void strt1()
{
	fprintf(stderr, "start1 minimal execution\n");
}
void at_note() {
	fprintf(stderr, "at_note\n");
}
void at_note1() {
	fprintf(stderr, "at_note1\n");
}
void at_note2() {
	fprintf(stderr, "at_note2\n");
}
void at_note3(int num) {
	fprintf(stderr, "at_note3 %d\n",num);
}
#endif
void restart(char *p, char * q) {
 fprintf(stderr,"restart not supported\n");
}
!@#$math.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
 * math.c - extended math support for spitbol
 *
 * Routines not provided by hardware floating point.
 *
 * These routines are not called from other C routines.  Rather they
 * are called by inter.*, and by external functions.
 */

#include "port.h"

#include <errno.h>

#if FLOAT & !MATHHDWR

#include <math.h>

#ifndef errno
#if LINUX
int errno;
#else
extern int errno; /* system error number */
#endif
#endif

extern double inf;	/* infinity */

/*
 * f_atn - arctangent
 */
double f_atn(ra)
double ra;
{
    return atan(ra);
}


/*
 * f_chp - chop
 */
double f_chp(ra)
double ra;
{
    if (ra >= 0.0)
        return floor(ra);
    else
        return ceil(ra);
}



/*
 * f_cos - cosine
 */
double f_cos(ra)
double ra;
{
    return cos(ra);
}



/*
 * f_etx - e to the x
 */
double f_etx(ra)
double ra;
{
    double result;
    errno = 0;
    result = exp(ra);
    return errno ? inf : result;
}



/*
 * f_lnf - natural log
 */
double f_lnf(ra)
double ra;
{
    double result;
    errno = 0;
    result = log(ra);
    return errno ? inf : result;
}



/*
 * f_sin - sine
 */
double f_sin(ra)
double ra;
{
    return sin(ra);
}


/*
 * f_sqr - square root  (range checked by caller)
 */
double f_sqr(ra)
double ra;
{
    return sqrt(ra);
}


/*
 * f_tan - tangent
 */
double f_tan(ra)
double ra;
{
    double result;
    errno = 0;
    result = tan(ra);
    return errno ? inf : result;
}

#endif					/* FLOAT & !MATHHDWR */
!@#$optfile.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File: OPTFILE.C		Version: 1.00
/	-------------------------------------
/
/	Contents:	function optfile
/
*/

/*
/   optfile( varname, result )
/
/   optfile() looks for other, optional ways to supply a filename to
/   the INPUT/OUTPUT functions.  Varname is an SCBLK containing the string
/   used as an alias for the file name, and result is an SCBLK that will
/   receive the aliased name.
/
/   optfile() looks in two places for the alias.  First, if the alias is
/   a numeric string, it looks in the cfiles table to see if it was specified
/   on the command line.  If not found there, it looks in the environment block.
/
/   Parameters:
/	varname	 pointer to SCBLK containing alias
/	result   pointer to SCBLK that will receive any name found
/   Returns:
/       0  - success, result contains name
/	-1 - failure
/   Side Effects:
/	none
*/

#include "port.h"

int optfile( varname, result )

struct	scblk	*varname, *result;

{
    word	i, j, n;
    register char *p, *q;

    /* try to convert alias to an integer */
    i = 0;
    n = scnint( varname->str, varname->len, &i);
    if (i == varname->len)		/* Consume all characters? */
    {
        for (j = 0; j <= maxf; j++)
        {
            if (cfiles[j].filenum == n)
            {
                p = cfiles[j].fileptr;
                q = result->str;
                while ((*q++ = *p++) != 0)
                    ;
                result->len = q - result->str - 1;
                return 0;
            }
        }
    }

    /* didn't find it on the command line.  Check environment */
    return rdenv( varname, result );
}

!@#$osclose.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  OSCLOSE.C	Version:  01.00
/	---------------------------------------
/
/	Contents:	Function osclose
*/

/*
/   osclose( ioptr )
/
/   osclose() closes the file represented by the passed IOBLK.
/
/   Parameters:
/	ioptr	pointer to IOBLK
/   Returns:
/	Number of I/O errors, should be 0.
*/

#include "port.h"

osclose( ioptr )
struct	ioblk	*ioptr;
{
    register int	errcnt = 0;

    /*
    /	If not open, nothing to do.
    */
    if ( !(ioptr->flg1 & IO_OPN) )
        return 0;

    /*
    /	Flush buffer before closing output file.
    */
    if ( ioptr->flg1 & IO_OUP )
        errcnt += flush( ioptr );

    /*
    / DO NOT CLOSE SYSTEM FILE 0, 1 or 2; file was opened by shell.
    */
    if ( (ioptr->flg1 & IO_SYS) && ioptr->fdn >= 0 && ioptr->fdn <= 2 )
        return errcnt;

    /*
    /	Now we can reset open flag and close the file descriptor associated
    /	with file/pipe.
    */
    ioptr->flg1 &= ~IO_OPN;
    if ( close(ioptr->fdn ) < 0 )
        errcnt++;

#if PIPES
    /*
    /	For a pipe, must deal with process at other end.
    */
    if ( ioptr->flg2 & IO_PIP )
    {
        /*
        /   If process already dead just reset flag.
        */
        if ( ioptr->flg2 & IO_DED )
            ioptr->flg2 &= ~IO_DED;

        /*
        /   If reading from pipe, kill the process at other end
        /   and wait for its termination.
        */
        else if ( ioptr->flg1 & IO_INP )
        {
            kill( ioptr->pid );
            oswait( ioptr->pid );
        }

        /*
        /   If writing to pipe, wait for it to terminate.
        */
        else
            oswait( ioptr->pid );
    }
#endif					/* PIPES */

    /*
    /	Return number of errors.
    */
    return errcnt;
}
!@#$osint.h
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/   File:  OSINT.H		Version:  01.01
/   -------------------------------------------
/
/   This header file defines the interface between the Macro SPITBOL compiler
/   written in assembly langauge and the OS interface written in C.
/   Communication between the two is handled via a set of global variables
/   defined as externals below.
*/


/*
/   Set up externals for all the compiler's registers.
*/

extern word	reg_cp, reg_wa, reg_wb, reg_wc, reg_xr, reg_xl, reg_xs;
extern IATYPE	reg_ia;
extern double reg_ra;

/*
 *  Macros to deal with converting pointers within the Minimal heap
 *  to pointers that the C code can deal with.  On most systems, the
 *  two types of pointers are equivalent.  But on machines like the
 *  8088 or under Windows, the near pointers within the heap need to
 *  be converted to and from far pointers in the C data space.
 */
#if __NEAR__
extern void *mk_mp(void near *minp);
#define MK_MP(minp,type) ((type)mk_mp((void near *)(minp)))
#define MP_OFF(cp,type) ((type)(void NEAR *)(cp))
#else					/* __NEAR__ */
#define MK_MP(minp,type) ((type)(minp))
#define MP_OFF(cp,type) ((type)cp)
#endif					/* __NEAR__ */

/*
/   Macros to fetch a value of appropriate type from a compiler register
*/

#if __NEAR__
#define CP(type)	(sizeof(type) == 4 ? MK_MP(reg_cp,type) : ((type) reg_cp))
#define IA(type)	((type) reg_ia)
#define WA(type)	(sizeof(type) == 4 ? MK_MP(reg_wa,type) : ((type) reg_wa))
#define WB(type)	(sizeof(type) == 4 ? MK_MP(reg_wb,type) : ((type) reg_wb))
#define WC(type)	(sizeof(type) == 4 ? MK_MP(reg_wc,type) : ((type) reg_wc))
#define XR(type)	(sizeof(type) == 4 ? MK_MP(reg_xr,type) : ((type) reg_xr))
#define XL(type)	(sizeof(type) == 4 ? MK_MP(reg_xl,type) : ((type) reg_xl))
#define PC(type)	(sizeof(type) == 4 ? MK_MP(reg_pc,type) : ((type) reg_pc))
#define XS(type)	(sizeof(type) == 4 ? MK_MP(reg_xs,type) : ((type) reg_xs))
#define RA(type)  (sizeof(type) == 8 ? MK_MP(reg_ra,type) : ((type) reg_ra))
#else         /* __NEAR__ */
#define CP(type)	((type) reg_cp)
#define IA(type)	((type) reg_ia)
#define WA(type)	((type) reg_wa)
#define WB(type)	((type) reg_wb)
#define WC(type)	((type) reg_wc)
#define XR(type)	((type) reg_xr)
#define XL(type)	((type) reg_xl)
#define PC(type)	((type) reg_pc)
#define XS(type)	((type) reg_xs)
#define RA(type)  ((type) reg_ra)    /* v1.30.12 */
#endif          /* __NEAR__ */
/*
/   Macros to set a value of appropriate type into a compiler register.
*/
#define SET_CP(val)	(reg_cp = (word) (val))
#define SET_IA(val)	(reg_ia = (val))
#define SET_WA(val)	(reg_wa = (word) (val))
#define SET_WB(val)	(reg_wb = (word) (val))
#define SET_WC(val)	(reg_wc = (word) (val))
#define SET_XR(val)	(reg_xr = (word) (val))
#define SET_XL(val)	(reg_xl = (word) (val))
#define SET_PC(val)	(reg_pc = (word) (val))
#define SET_XS(val)	(reg_xs = (word) (val))
#define SET_RA(val)  (reg_ra = (double) (val))

/*
/   Return values to take exit N from interface
*/
#define EXIT_1		1
#define EXIT_2		2
#define EXIT_3		3
#define EXIT_4		4
#define EXIT_5		5
#define EXIT_6		6
#define EXIT_7		7
#define EXIT_8		8
#define EXIT_9		9

/*
/    Return value to do a normal return from interface.
*/
#define NORMAL_RETURN	0

/*
/	Function to call into MINIMAL code.
/	The argument is an ordinal number defined below.
*/
extern void minimal Params((word callno));
extern void popregs Params((void));
extern void pushregs Params((void));
#define MINIMAL(cn) minimal(cn)
#define MINSAVE() pushregs()
#define MINRESTORE() popregs()

/*
/	Ordinals for MINIMAL calls from C.
/
/   The order of entries here must correspond to the order of
/   table entries in the INTER assembly language module.
*/
enum CALLS {
    RELAJ,
    RELCR,
    RELOC,
    ALLOC,
    ALOCS,
    ALOST,
    BLKLN,
    INSTA,
    RSTRT,
    START,
    FILNM,
    DTYPE,
    ENEVS,
    ENGTS
};

/*
/	Function and macro to get/set value from/to MINIMAL dataspace.
/	The argument is an ordinal number defined below.
/   GET_DATA_OFFSET returns the address of a Minimal data value.
/   GET_CODE_OFFSET returns the address of a Minimal routine.
/	GET_MIN_VALUE returns the contents of an item of Minimal data.
/	SET_MIN_VALUE sets the contents of an item of Minimal data.
*/
#if DIRECT
#define GET_CODE_OFFSET(vn,type) ((type)vn)
#define GET_DATA_OFFSET(vn,type) ((type)&vn)
#define GET_MIN_VALUE(vn,type) ((type)vn)
#define SET_MIN_VALUE(vn,val,type) (*(type *)&vn = (type)(val))
/*
/   Names for accessing MINIMAL data values via GET_DATA_OFFSET macro.
*/
extern word
GBCNT,
HEADV,
MXLEN,
STAGE,
TIMSX,
DNAMB,
DNAMP,
STATE,
STBAS,
STATB,
POLCT,
TYPET,
LOWSPMIN,
FLPRT,
FLPTR,
GTCEF,
HSHTB,
PMHBS,
R_FCB,
C_AAA,
C_YYY,
G_AAA,
W_YYY,
R_COD,
KVSTN,
KVDMP,
KVFTR,
KVCOM,
KVPFL,
CSWFL,
STMCS,
STMCT,
TICBLK,
TSCBLK,
ID1,
ID2BLK,
INPBUF,
TTYBUF,
END_MIN_DATA;

/*
/   Names for accessing MINIMAL code values via GET_CODE_OFFSET macro.
*/
extern void	B_EFC();
extern void	B_ICL();
extern void B_RCL();
extern void B_SCL();
extern void	B_VCT();
extern void	B_XNT();
extern void	B_XRT();
extern void	DFFNC();
extern void	S_AAA();
extern void	S_YYY();

#else					/* DIRECT */
extern  word *minoff Params((word valno));
#define GET_CODE_OFFSET(vn,type) ((type)minoff(vn))
#define GET_DATA_OFFSET(vn,type) ((type)minoff(vn))
#define GET_MIN_VALUE(vn,type)	((type)*minoff(vn))
#define SET_MIN_VALUE(vn,val,type) (*(type *)minoff(vn) = (type)(val))
/*
/   Ordinals for accessing MINIMAL values.
/
/   The order of entries here must correspond to the order of
/   valtab entries in the INTER assembly language module.
*/
enum VALS {
    GBCNT,
    HEADV,
    MXLEN,
    STAGE,
    TIMSX,
    DNAMB,
    DNAMP,
    STATE,
    B_EFC,
    B_ICL,
    B_SCL,
    B_VCT,
    B_XNT,
    B_XRT,
    STBAS,
    STATB,
    POLCT,
    TYPET,
    DFFNC,
    LOWSPMIN,
    FLPRT,
    FLPTR,
    GTCEF,
    HSHTB,
    PMHBS,
    R_FCB,
    C_AAA,
    C_YYY,
    G_AAA,
    W_YYY,
    S_AAA,
    S_YYY,
    R_COD,
    KVSTN,
    KVDMP,
    KVFTR,
    KVCOM,
    KVPFL,
    CSWFL,
    STMCS,
    STMCT,
    TICBLK,
    TSCBLK,
    ID1,
    ID2BLK,
    INPBUF,
    TTYBUF,
    B_RCL,
    END_MIN_DATA
};

#endif					/* DIRECT */

/* Some shorthand notations */
#define pID1 GET_DATA_OFFSET(ID1,struct scblk *)
#define pID2BLK GET_DATA_OFFSET(ID2BLK,struct scblk *)
#define pINPBUF GET_DATA_OFFSET(INPBUF,struct bfblk *)
#define pTTYBUF GET_DATA_OFFSET(TTYBUF,struct bfblk *)
#define pTICBLK GET_DATA_OFFSET(TICBLK,struct icblk *)
#define pTSCBLK GET_DATA_OFFSET(TSCBLK,struct scblk *)

#define TYPE_EFC GET_CODE_OFFSET(B_EFC,word)
#define TYPE_ICL GET_CODE_OFFSET(B_ICL,word)
#define TYPE_SCL GET_CODE_OFFSET(B_SCL,word)
#define TYPE_VCT GET_CODE_OFFSET(B_VCT,word)
#define TYPE_XNT GET_CODE_OFFSET(B_XNT,word)
#define TYPE_XRT GET_CODE_OFFSET(B_XRT,word)
#define TYPE_RCL GET_CODE_OFFSET(B_RCL,word)

!@#$osopen.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  OSOPEN		Version:  01.06
/	---------------------------------------
/
/	Contents:	Function osopen
/
/	Revision history:
/
/	V01.01	Was testing for successful file open with (fd != 0) and
/		(fd >0).  If user ever explicitly closed fd 0, fd 0 would
/		be available for normal use by a file open.
/
/	V01.02	Look at flag IO_ENV, and if set, fnm string is the name
/		of an environment variable pointing to the filename.
/
/	V01.03	For MS-DOS, remove trailing ':', if any, from file name.
/		DOS does not like names like "CON:".
/
/	V01.04	File name "-" attaches to standard input or output.
/
/	V01.05	For MS-DOS on 386, process IO_COT option.
/
/	V01.06	Handle files open for update.
*/

/*
/   osopen( ioptr )
/
/   osopen() opens the file represented by the passed ioblk.  If the file
/   is actually a command, osopen() establishes a pipe to access the
/   command.
/
/   Parameters:
/	ioptr	pointer to IOBLK representing file
/   Returns:
/	0 - file opened successfully / -1 - open failed
*/

#include "port.h"

#if AIX | LINUX
#include <fcntl.h>
#endif

int	osopen( ioptr )
struct	ioblk	*ioptr;

{
    word	fd;
    char	savech;
    word 	len;
    char	*cp;
    struct	scblk	*scptr;

    /*
    /	If file already open, return.
    */
    if ( ioptr->flg1 & IO_OPN )
        return 0;

    /*
    /	Establish a few pointers and filename length.
    */
    scptr	= MK_MP(ioptr->fnm, struct scblk *);	/* point to filename SCBLK	*/
    if (ioptr->flg2 & IO_ENV)
    {
        if (optfile(scptr, pTSCBLK))
            return -1;
        scptr = pTSCBLK;
        pTSCBLK->len = lenfnm(scptr);	/* remove any options */
    }

    cp	= scptr->str;		/* point to filename string	*/
    len	= lenfnm( scptr );	/* get length of filename	*/

#if PIPES
    /*
    /	Handle pipes here.
    */
    if ( cp[0] == '!' )		/* if pipe ...			*/
    {
        ioptr -> flg2 |= IO_PIP;	/*   then set flag and		*/
        fd = ospipe( ioptr );   /*      let ospipe() do work	*/
    }


    /*
    /	Handle files here.
    */
    else
#endif					/* PIPES */

    {
        savech	= make_c_str(&cp[len]);	/*   else temporarily terminate	filename */
        if ( ioptr->flg1 & IO_OUP ) /*  output file		*/
        {
            fd = -1;	/* force creat if not update or append	*/

            /* Look for "-" as a file name.  Assign to fd 1 */
            if (len == 1 && *cp == '-')
            {
                fd = STDERRFD;          /* was STDOUTFD, changed for WinNT */
                ioptr->flg1 |= IO_SYS;
            }
            else
            {
                /* default mode:
                 *   create file if it doesn't exist
                 *   open for read/write so we can fill buffer after a seek
                 *    (even if this is a write only from file from the user's
                 *    point of view)
                 *   if file is not buffered and not appending or updating,
                 *    use O_WRONLY instead of O_RDWR.
                 */
                int mode = O_CREAT;		/* create file if it doesn't exist */

                if (ioptr->flg1 & IO_WRC && !(ioptr->action & IO_OPEN_IF_EXISTS))
                    mode |= O_WRONLY;
                else
                    mode |= O_RDWR;

                /* if not update or append mode */
                if (!(ioptr->flg1 & (IO_INP|IO_APP)))
                    mode |= O_TRUNC;			/* truncate existing file */

                fd = spit_open( cp, mode, ioptr->share /* 0666 */, ioptr->action);
            }

        }
        else			/* input-only file		*/
        {
            /* Look for "-" as a file name.  Assign to fd 0 */
            if (len == 1 && *cp == '-')
            {
                fd = STDINFD;
                ioptr->flg1 |= IO_SYS;
            }
            else
                fd = spit_open( cp, O_RDONLY, ioptr->share /* 0 */, ioptr->action);
        }
        unmake_c_str(&cp[len], savech);	/* restore filename string	*/
    }

    /*
    /	If file/pipe opened successfully, then set
    /
    /	o  file descriptor number in IOBLK
    /	o  open flag in IOBLK
    /	o  if output file is a TTY device, set the IO_WRC flag (no buffering)
    /	o  if IO_WRC flag set, throw away the buffer
    /	o  if output, append and not pipe, seek to end of file.
    /
    /	and then do a normal return.
    */
    if (fd != -1)
    {
        ioptr->fdn = (word)fd;
        ioptr->flg1 |= IO_OPN;
        if ( ioptr->flg1 & IO_OUP  &&  testty( fd ) == 0 )
            ioptr->flg1 |= IO_WRC;

#if HOST386
        /* Test for character output.  Definicon doesn't have screen functions */
        if ( ioptr->flg1 & IO_OUP && coutdev( ioptr->fdn ) == 0 )
            ioptr->flg1 |= IO_COT;
#endif					/* HOST386 */

        if ( ioptr->flg1 & IO_WRC )
            ioptr->bfb = 0;

        if ( (ioptr->flg1 & (IO_OUP|IO_APP)) == (IO_OUP|IO_APP) &&
                !(ioptr->flg2 & IO_PIP))
            doset(ioptr, 0L, 2);
        return 0;
    }

    /*
    /	When control passes here the open/pipe has failed so return -1.
    */
    return  -1;
}
!@#$ospipe.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/   File:  OSPIPE.C     Version:  01.06
/	---------------------------------------
/
/	Contents:	Function ospipe
/
/ 1.02	Use vfork() on BSD systems to avoid copying pages.  Parent is suspended
/	by system until child execl's.
/
/ 1.03	Look at flag IO_ENV, and if set, fnm string is the name
/ 	of an environment variable pointing to the filename.
/
/ 1.04	Check for update mode on file.
/
/ 1.05  <withdrawn>
/
/ 1.06  30-Dec-96 Create version of WinNT.  Save and restore characters
/       at end of string in doshell().  Fix bug in Unix version:
/       If child fork does not run to the point where it does the execcl call
/       before the parent resumes, the parent could do a garbage collect and
/       invalidate the string pointer that the child will use.  Use a poor
/       man's interlock to keep the parent within ospipe until the child
/       has captured what is needed.
/
/ 1.07  19-Feb-98 Interlock is not necessary under AIX because we use fork,
/       not vfork.  vfork shares the parent's address space, whereas fork
/       gives the child a complete new copy of the address space.
*/

#include "port.h"
#if PIPES
typedef int HFILE;

char	*getshell();
char	*lastpath();

static int doshell Params((struct ioblk *ioptr));
/*
/   ospipe( ioptr )
/
/   ospipe() builds a pipe for the command associated with the passed IOBLK.
/
/   Parameters:
/	ioptr	pointer to IOBLK for command
/   Returns:
/	file descriptor returned by pipe system call, -1 if error
*/

int ospipe( ioptr )
struct	ioblk	*ioptr;

{
    int   childpid;
    HFILE childfd, parentfd, savefd, stdfd, fd[2];

    if ( (ioptr->flg1 & (IO_INP | IO_OUP)) == (IO_INP | IO_OUP) )
        return -1;		/* can't open read/write pipe */
    /*
    /	Fail if system call to create pipe fails.
    */
    if ( pipe( fd ) < 0 )
        return -1;

    /*
    /	Set up file descriptors properly based on whose reading from pipe/
    /	writing to pipe.
    */
    if ( ioptr->flg1 & IO_INP ) {
        parentfd = fd[0];	/* parent reads from fd[0]	*/
        childfd  = fd[1];	/* child writes to fd[1]	*/
        stdfd = 1;
    }
    else {
        parentfd = fd[1];	/* parent writes to fd[1]	*/
        childfd  = fd[0];	/* child reads from fd[0]	*/
        stdfd = 0;
    }

#if UNIX
    /*
    /	Execute the proper code based on whose process is the parent and
    /	whose is the child.
    */
    switch ( childpid = fork() ) {
        int n;
    case -1:
        /*
        /   Fork failed, so close up files and return -1.
        */
        close( parentfd );
        close( childfd );
        parentfd = -1;
        break;

    case 0:
        /*
        /   Child executes here.  Set up file descriptors 0 & 1 properly
        /   and close any file descriptors open above 2.
        /
        /    If parent is expecting to read from us, we must write
        /    via file descriptor 1 to childfd.
        /    If parent is expecting to write to us, we must read via
        /    file descriptor 0 from childfd.
        */
        close( stdfd );

        /*
        /   Duplicate childfd to be either child's (our) fd 0 or 1.
        */
        dup( childfd );

        /*
        /   Close all unnecessary file descriptors.
        */
        for ( n=3 ; n<=OPEN_FILES ; close( n++ ) )
            ;

        if (doshell(ioptr) == -1)
            return -1;
        __exit(1);			/* Should never get here! */

    default:
        /*
        /   Parent executes here.  Remember process id of child and close
        /   its file descriptor.
        */
        ioptr->pid = childpid;
        close( childfd );
        break;
    }
#endif					/* UNIX */
    /*
    /	Control comes here ONLY in parent process. Return the file descriptor
    /	to be used for communication with child process or -1 if error.
    */
    return parentfd;
}


static int doshell( ioptr )
struct	ioblk	*ioptr;
{
#define CMDBUFLEN 1024
    struct	scblk	*scptr;
    char    *shellpath, cmdbuf[CMDBUFLEN];
    int     len;

    /*
    /   Set up to execute command.
    /
    /   Be sure to point properly at start of command and to
    /   terminate it with a Nul character.  Remember that
    /   command is in string with form "!*command* options".
    */
    scptr = MK_MP(ioptr->fnm,struct scblk *);	/* point to cmd scblk	*/
    if (ioptr->flg2 & IO_ENV) {
        if (optfile(scptr, pTSCBLK))
            return -1;
        scptr = pTSCBLK;
        pTSCBLK->len = lenfnm(scptr);	/* remove any options	*/
    }
    len   = lenfnm( scptr ) - 2;        /* length of cmd without ! & delimiter */
    if (len >= CMDBUFLEN)
        return -1;
    mystrncpy( cmdbuf, &scptr->str[2], len);/* get command */
    if ( cmdbuf[len-1] == scptr->str[1] )   /* if necessary         */
        len--;                              /*   zap 2nd delimiter  */
    cmdbuf[len] = '\0';                     /* Nul terminate cmd    */
#if UNIX
    shellpath = getshell();         /* get shell's path     */
    execl( shellpath, pathlast( shellpath ), "-c", cmdbuf, (char *)NULL );
    return -1;					/* should not get here */
#endif					/* UNIX */
}

#endif					/* PIPES */
!@#$osread.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  OSREAD.C		Version:  01.08
/	---------------------------------------
/
/	Contents:	Function osread
*/

/*
/   osread( mode, recsiz, ioptr, scptr )
/
/   osread()  reads the next record from the input file associated with
/   the passed IOBLK into the passed SCBLK.  mode determines whether the
/   read should be line or raw mode.
/
/	Line mode records are teminated with a new-line character (the
/	new-line is not put in the scblk though).
/
/	Raw mode records are simply the next recsiz characters.
/
/   Parameters:
/	mode	1=line mode / 0=raw mode
/	recsiz	line mode:  max length of record to be read
/		raw mode:   number of characters to be read
/	ioptr	pointer to IOBLK associated with input file
/	scptr	pointer to SCBLK to receive input record
/   Returns:
/	>0	length of record read
/	-1	EOF
/	-2	I/O error
/
/	V1.08	01-Aug-93	Add IO_EOT flag to ignore EOT char in DOS-mode
/						 text files.
/	V1.07	01-Feb-93	Change definition of mode argument.
/	V1.06	05-Feb-91	Change for read/write files.
/	V1.05	29-Nov-89	Terminate host screen operation if HOST386.
/	V1.04	05-Mar-88	Changes for Definicon and carriage return/
/						line feed terminated records.
/						Also modified code so that an end of file
/						in a record with no record terminator returns
/			   			that record, rather than an I/O error.
/
*/

#include "port.h"
#include <string.h>

word osread( mode, recsiz, ioptr, scptr )

word	mode;
word	recsiz;
struct	ioblk	*ioptr;
struct	scblk	*scptr;

{
    register struct bfblk	*bfptr = MK_MP(ioptr->bfb, struct bfblk *);
    register char	*cp = scptr->str;
    register char   *bp;
    register word	cnt = 0;
    register word fdn = ioptr->fdn;
    register word	n;

#if HOST386
    if ( ioptr->flg1 & IO_CIN )			/* End any special screen modes */
        termhost();
#endif					/* HOST386 */

    /*
    /	Distinguish buffered from unbuffered I/O.
    */
    if ( ioptr->flg1 & IO_WRC || ioptr->flg2 & IO_RAW ) {

        /*
         ********************
         *  Unbuffered I/O  *
         ********************
         */

        if ( mode == 1 ) {				/* line mode */

            /*
             * Unbuffered Line Mode
             */
            register char	eol1 = ioptr->eol1;
            register char	eol2 = ioptr->eol2;
#ifdef EOT
            /* Ignore eot char if IO_EOT bit set */
            register char	eot	 = (ioptr->flg1 & IO_EOT) ? eol1 : EOT;
#endif
            word i;
            char c;

#if PIPES
            if (ioptr->flg2 & IO_PIP) {				/* if pipe, read 1 char at a time */

                do {								/* because there's no chance to backup */
                    n = read(fdn, &c, 1);
                    if (n > 0) {
                        if (ioptr->flg2 & IO_LF) {
                            ioptr->flg2 &= ~IO_LF;
                            if (c == eol2)
                                continue;
                        }
                        if (c == eol1) {
                            if (eol2)
                                ioptr->flg2 |= IO_LF;
                            break;							/* exit loop on eol */
                        }
#ifdef EOT
                        if ( c == eot ) {
                            n = 0;
                            break;
                        }
#endif
                        if (cnt < recsiz) {
                            cnt++;
                            *cp++ = c;
                        }
                    }
                } while (n > 0);						/* loop until eol or eof */
            }
            else
#endif					/* PIPES */
            {
                char findeol = 1;

                n = read( fdn, cp, recsiz );

                if ( n > 0 )
                {
                    cnt = n;

                    for (i = cnt; i--; )
                    {   /* scan for eol1 */
#ifdef EOT
                        if ((c = *cp++) == eol1 || c == eot)
#else
                        if (*cp++ == eol1)
#endif
                        {   /* if end of line (or EOF) */
                            findeol = 0;
                            cnt -= i + 1;
                            if (eol2)
                            {
                                if (i && *cp == eol2)
                                    cp++;
                                else if (testty(fdn) && read(fdn, &c, 1) == 1 && c != eol2)
                                    doset(ioptr, -1L, 1);	/* back up over non-eol2 */
                            }
                            if (testty(fdn))
                                doset(ioptr, cp-scptr->str-n, 1);/* backup file to point following line */
                            break;
                        }
                    }

                    /*
                     * if we didn't see an eol, and this operating system does not
                     * read a line at time (through eol) automatically, then we have
                     * to keep reading one character at time until we find the eol.
                     */
                    if (findeol) {                /* on block device, discard chars */
                        do {									/* until find eol */
                            i = read(fdn, &c, 1);
                            if (i > 0) {
#ifdef EOT
                                if (c == eol1 || c == eot) {
                                    if (c == eol1 && eol2 && read(fdn, &c, 1) == 1 && c != eol2)
#else
                                if (c == eol1) {
                                    if (eol2 && read(fdn, &c, 1) == 1 && c != eol2)
#endif
                                        doset(ioptr, -1L, 1);	/* back up over non-eol2 */
                                    break;						/* exit loop on eol */
                                }
                            }
                        }
                        while (i > 0);					/* loop until eol or eof */
                    }
                }
            }
        }

        else {

            /*
             * Unbuffered Raw Mode
             */
            if ( ioptr->flg2 & IO_RAW )
                ttyraw( fdn, 1 );	/* set RAW mode		*/
            do {
                /*  loop till recsize satisfied		*/
                /*  (read returns one or more chars per call)	*/
                n = read( fdn, cp, recsiz );
                cp += n;
                cnt += n;
                recsiz -= n;
            } while ( ( recsiz ) && ( n > 0 ) );

            if ( ioptr->flg2 & IO_RAW )
                ttyraw( fdn, 0 );

            /*  if no error, return aggregate count	*/
            if ( n >= 0 )
                n = cnt;
        }

        /*	if read error then take action	*/
        if ( n < 0 )
            return	-2;

        /*	check for eof with nothing read */
        if ( n == 0 && cnt == 0)
            return -1;

        /*	everything ok, so return	*/
        return cnt;
    }

    else {
        /*
         ********************
         *  Buffered I/O  *
         ********************
         */

        if ( mode == 1 ) {			/* line mode */

            /*
             * Buffered Line Mode
             */
            register char	eol1 = ioptr->eol1;
            register char	eol2 = ioptr->eol2;
#ifdef EOT
            /* Ignore eot char if IO_EOT bit set */
            register char	eot	 = (ioptr->flg1 & IO_EOT) ? eol1 : EOT;
#endif
            char	*savecp;
            char	savechar;

            /*
             *	First phase:  copy characters to the result
             *	buffer either until recsiz is exhausted or
             *	we have copied the last character of a line.
             *	This loop is speeded up by pretending that
             *	the input line is no longer than the result.
             */
            do {
                register char	*oldbp;

                /* if the buffer is exhausted, try to fill it */
                if ( bfptr->next >= bfptr->fill ) {
                    if (flush(ioptr))	/* flush any dirty buffer */
                        return -2;

                    n = fillbuf(ioptr);

                    if ( n < 0 )
                        return -2;			/* I/O error */

                    /* true EOF only at the beginning of a line */
                    if ( !n )
                        return cnt > 0 ? cnt : -1;     /* 1.04 */
                }

                /* set n to max # chars we can process this time */
                n = recsiz - cnt;
                if ( n > bfptr->fill - bfptr->next )
                    n = bfptr->fill - bfptr->next;

                /* point bp and oldbp at the first char to be copied */
                oldbp = bp = bfptr->buf + bfptr->next;

                /* plant an eol1 at the end of the valid input */
                savecp = bp + n;
                savechar = *savecp;
                *savecp = eol1;

#ifdef EOT
                /* copy characters until we hit eol1 or EOT */
                while ( *bp != eol1 && *bp != eot )
#else					/* EOT */
                /* copy characters until we hit eol1 */
                while ( *bp != eol1 )
#endif					/* EOT */

                    *cp++ = *bp++;

                /* restore the stolen character */
                *savecp = savechar;

                /* calculate how many characters were moved */
                n = bp - oldbp;
                cnt += n;
                bfptr->next += n;

                /* loop until we hit a real \n or recsiz is exhausted */
            } while ( bp == savecp  &&  cnt < recsiz );

            /*
             *	Second phase: discard characters up to and
             *	including the next EOL1 in the input.
             *	This loop is optimized to miminize startup
             *	overhead, because it will usually be executed
             *	only once (but never less than once!)
             */
            do {
                /*
                 *	decrement count of characters remaining
                 *	in the buffer, check for buffer underflow
                 */
                if ( bfptr->next >= bfptr->fill ) {
                    if (flush(ioptr))	/* flush any dirty buffer */
                        return -2;

                    n = fillbuf(ioptr);

                    if ( n < 0 )
                        return -2;			/* I/O error */

                    /* true EOF only at the beginning of a line */
                    if ( !n )
                        return cnt > 0 ? cnt : -1;     /* 1.04 */
                }

                /*
                 *	The buffer is guaranteed non-empty,
                 *	Pick up a character and bump the offset.
                 */
#ifdef EOT
                /* loop until we see eol1 or end of text */
            } while ( (savechar = bfptr->buf[bfptr->next++]) != eol1 &&
                      savechar != eot );

            if ( !(ioptr->flg1 & IO_EOT) && savechar == EOT ) {
                    bfptr->next--;				/* back up so see it repeatedly */
                return (cnt > 0 ? cnt: -1);
            }
#else					/* EOT */
                /* loop until we see an eol1 */
            }
            while ( bfptr->buf[bfptr->next++] != eol1 );
#endif					/* EOT */

            /* if there is an eol2, look ahead for it	*/
            if (eol2) {
                if ( bfptr->next >= bfptr->fill && testty(fdn))
                {
                    if (flush(ioptr))	/* flush any dirty buffer */
                        return -2;
                    fillbuf(ioptr);
                }

                if ( bfptr->next < bfptr->fill && (bfptr->buf[bfptr->next] == eol2) )
                    bfptr->next++;	/* discard it if found	*/
            }

        }

        else {
            /*
             * Buffered Raw Mode
             */
            while ( recsiz > 0 ) {
                /* if the buffer is exhausted, try to fill it */
                if ( bfptr->next >= bfptr->fill ) {

                    if (flush(ioptr))	/* flush any dirty buffer */
                        return -2;

                    fsyncio(ioptr);        /* synchronize file and buffer */

                    n = read( fdn, bfptr->buf, bfptr->size );

                    /* input error, no good */
                    if ( n < 0 )
                        return -2;

                    /* eof, return what we got so far */
                    if ( n == 0 )
                        break;

                    bfptr->next = 0;
                    bfptr->fill = n;
                    bfptr->curpos += n;
                }

                /* calculate how many chars we can move */
                n = bfptr->fill - bfptr->next;
                if ( n > recsiz )
                    n = recsiz;
                bp = bfptr->buf + bfptr->next;

                /* update pointers to move n characters */
                cnt += n;
                recsiz -= n;
                bfptr->next += n;

                /* move n characters from bp to cp */
                memcpy(cp,bp,n);
                cp += n;
            }

            /* if we couldn't make any progress, signal end of file */
            if ( cnt == 0 )
                return -1;
        }
        return cnt;
    }
}

word fillbuf(ioptr)
struct ioblk *ioptr;
{
    register struct bfblk *bfptr = MK_MP(ioptr->bfb, struct bfblk *);
    word n;

    fsyncio(ioptr);           /* synchronize file and buffer */

    n = read( ioptr->fdn, bfptr->buf, bfptr->size );
    if ( n >= 0 ) {
        bfptr->next = 0;
        bfptr->fill = n;
        bfptr->curpos += n;
    }

    return n;
}
!@#$oswait.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/   File:  OSWAIT.C     Version:  01.02
/	---------------------------------------
/
/	Contents:	Function oswait
*/


/*
/   oswait( pid )
/
/   oswait() waits for the termination of the process with id pid.
/
/   Parameters:
/	pid	prcoess id
/   Returns:
/   nothing
/
/   V1.01 MBE 07-29-91  <withdrawn>.
/   V1.02 MBE 12-31-96  Modify for WinNT.
/
*/

#include "port.h"
#if PIPES

#if UNIX
#include <signal.h>
#endif                  /* UNIX */

void oswait( pid )
int	pid;
{
    int	deadpid, status;
    struct  chfcb   *chptr;
#if UNIX
    SigType (*hstat)Params((int)),
            (*istat)Params((int)),
            (*qstat)Params((int));

    istat	= signal( SIGINT, SIG_IGN );
    qstat	= signal( SIGQUIT ,SIG_IGN );
    hstat	= signal( SIGHUP, SIG_IGN );
#endif

    while ( (deadpid = wait( &status )) != pid  &&  deadpid != -1 )
    {
        for ( chptr = GET_MIN_VALUE(R_FCB,struct chfcb *); chptr != 0;
                chptr = MK_MP(chptr->nxt, struct chfcb *) )
        {
            if ( deadpid == MK_MP(MK_MP(chptr->fcp, struct fcblk *)->iob,
                                  struct ioblk *)->pid )
            {
                MK_MP(MK_MP(chptr->fcp, struct fcblk *)->iob,
                      struct ioblk *)->flg2 |= IO_DED;
                break;
            }
        }
    }

#if UNIX
    signal( SIGINT,istat );
    signal( SIGQUIT,qstat );
    signal( SIGHUP,hstat );
#endif                  /* UNIX */
}
#endif					/* PIPES */
!@#$oswrite.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  OSWRITE.C	Version:  01.11
/	---------------------------------------
/
/	Contents:	Function oswrite
/
/	V1.11	Split mode and line length into two separate arguments.  1-Feb-93.
/	V1.10	Maintain IO_DIR.  Other changes for read/write I/O.
/	V1.09	Decrement cp when restore savech in case multiple records.  Advance
/			cp when writing in unbuffered mode.
/	V1.08	Change modelen parameter from int to word.
/   V1.07   Fix binary writes to character device if MS-DOS.
/   V1.06   Ignore short writes to character device if MS-DOS.
/	V1.05	Terminate host screen operation if HOST386.
/	V1.04	Obey ioptr->len on line-mode output.
*/

/*
/   oswrite( mode, linesiz, recsiz, ioptr, scptr )
/
/   oswrite() writes the record in the passed SCBLK to the file associated
/   with the passed IOBLK.  There are two types of transfer:
/
/	unbuffered	write is done immediately
/
/	buffered	write is done into buffer
/
/   In either case, a new-line is appended to the record if in line mode
/   (mode == 1).
/
/   Parameters:
/	mode	1=line mode / 0=raw mode
/	linesiz output record length
/	recsiz	length of data being written
/	ioptr	pointer to IOBLK associated with output file
/	scptr	pointer to SCBLK to receive output record
/   Returns:
/	Number of I/O errors.  Should be 0.
*/

#include "port.h"

word oswrite( mode, linesiz, recsiz, ioptr, scptr )
word	mode;
word	linesiz;
register word	recsiz;
struct	ioblk	*ioptr;
struct	scblk	*scptr;

{
    char	*saveloc, savech;
    char	savech2;

    register char	*cp = scptr->str;
    register struct bfblk *bfptr = MK_MP(ioptr->bfb, struct bfblk *);
    register word fdn = ioptr->fdn;
    word	linelen;
    int	ioerrcnt = 0;

#if HOST386
    if ( ioptr->flg1 & IO_COT ) 			/* End any special screen modes */
        termhost();
#endif					/* HOST386 */

    do {
        /* If line mode, limit characters written on a line */
        if ( mode == 1 && recsiz > linesiz )
            linelen = linesiz;
        else
            linelen = recsiz;
        recsiz -= linelen;

        /*
        /  If in line mode, temperarily replace the character(s) following the
        /  string (record) to be written with eol1 (and eol2).
        */
        if ( mode == 1 ) {
            saveloc = cp + linelen;
            savech = *saveloc;
            *saveloc = ioptr->eol1;
            linelen++;
            if (ioptr->eol2) {
                savech2 = *++saveloc;
                *saveloc = ioptr->eol2;
                linelen++;
            }
        }

        /*
        /  If unbuffered (IO_WRC), write the string directly to the file
        */
        if (ioptr->flg1 & IO_WRC ) {
            int actcnt;
            actcnt = write( fdn, cp, linelen );
            if ( actcnt != linelen ) {
                ioerrcnt++;
            }
            cp += actcnt;
        }

        /*
        /  If buffered, move the string into the file's buffer.
        /  There may be up to three parts to this operation:
        /  1. Data is used to fill an existing, partially filled buffer.
        /  2. Additional data larger than the buffer is written directly
        /     to the file.
        /  3. Any remaining data is copied to an empty buffer.  If the
        /     file is open for update, the buffer is loaded from the
        /     file prior to copying data to it.
        */
        else {
            while ( linelen > 0 && !ioerrcnt ) {


                /*
                 *   If no room in buffer (currently full), make room
                 * by flushing the buffer.
                 *
                 */
                if (bfptr->next == bfptr->size)
                    ioerrcnt += flush(ioptr);

                /*
                 *   If the current buffer write-in position is non-zero,
                 * there is something in the buffer to be retained.  Copy
                 * new stuff to the buffer.
                 *
                 *   If the current buffer write-in position is zero, there
                 * may or may not be something in the buffer that needs to
                 * be maintained.  If the amount of data being written
                 * exceeds the size of the buffer, any present contents of
                 * the buffer can be ignored (it will be overwritten in the
                 * file).  If the amount to be written is less than a buffer
                 * load, then it must be copied to the buffer.
                 *
                 */
                else if (bfptr->next || linelen < bfptr->size) {
                    register char *r;
                    register word n;

                    /*
                     *   If the buffer is truly empty, and the file is opened
                     * for input as well as output, and it is not a character
                     * device, then it must be filled prior to copying in the
                     * characters being written.
                     *
                     */
                    if (!bfptr->fill && ioptr->flg1 & IO_INP && testty(fdn))
                        if (fillbuf(ioptr) < 0) {
                            ioerrcnt++;
                            break;
                        }

                    n = bfptr->size - bfptr->next;	/* space in buffer */
                    if (n > linelen)				/* if don't need it all */
                        n = linelen;
                    linelen -= n;

                    r = bfptr->buf + bfptr->next;	/* buffer write-in position */
                    bfptr->next += n;

                    /* copy n characters from *cp to *r */
                    if ( n & 1 )
                        *r++ = *cp++;
                    if ( n & 2 ) {
                        *r++ = *cp++;
                        *r++ = *cp++;
                    }
                    n >>= 2;
                    while (--n >= 0) {
                        *r++ = *cp++;
                        *r++ = *cp++;
                        *r++ = *cp++;
                        *r++ = *cp++;
                    }

                    ioptr->flg2 |= IO_DIR;			/* mark buffer dirty */
                    if ( bfptr->next > bfptr->fill )
                        bfptr->fill = bfptr->next;
                }

                /*
                 *   Here if the current buffer write-in position is zero
                 * and the number of characters being written exceeds the
                 * size of the buffer.  For efficiency, we will bypass
                 * the buffer and write as many multiples of the buffer
                 * as possible.
                 */
                else {								/* n==bfptr->size means ignore buffer contents */
                    register word n,m;

                    fsyncio(ioptr);              /* synchronize file and buffer */
                    bfptr->fill = 0;				/* discard contents */

                    n = (linelen / bfptr->size) * bfptr->size;
                    m = write(fdn, cp, n);
                    if ( m != n

                       )
                        ioerrcnt++;

                    if (m > 0) {
                        cp += m;
                        linelen -= m;
                        bfptr->offset += m;
                        bfptr->curpos += m;
                    }
                }
            }

        }

        /*
        /  If in line mode, restore the character(s) that were temporarily
        /  replaced with eol1 (and eol2).
        */
        if ( mode == 1 ) {
            if (ioptr->eol2) {
                *saveloc-- = savech2;
                cp--;
            }
            *saveloc = savech;
            cp--;
        }
    } while (recsiz > 0 && !ioerrcnt);

    /*
    /	Return number of errors.
    */
    return ioerrcnt;
}
!@#$port.h
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/   File:  PORT.H   (SPITBOL)   Version:  01.11
/   ---------------------------------------------------
/
/   This header file contains manifest constants that describe system
/   dependencies.  Many of these values will be changed when porting
/   the OS interface to another machine/operating system.
*/
#include "systype.h"

/*
/	Turn off system-specific features unless specifically called for
/	in systype.h.
*/

#ifndef	ALTCOMP
#define	ALTCOMP		0	/* no alternate string comparison */
#endif

#ifndef DATECHECK
#define DATECHECK   0   /* no check for expiration date */
#endif

#ifndef ENGINE
#define ENGINE		0	/* not building engine version */
#endif

#ifndef EXECSAVE
#define EXECSAVE	0	/* executable modules via save files */
#endif

#ifndef	EXTFUN
#define EXTFUN		0	/* no external functions */
#endif

#ifndef	FLTHDWR
#define	FLTHDWR		0	/* floating point hardware not present */
#endif

#ifndef	HOST386
#define HOST386		0	/* no 80386 host functions */
#endif

#ifndef	MATHHDWR
#define	MATHHDWR	0	/* extended math hardware not present */
#endif

#ifndef	RUNTIME
#define	RUNTIME		0	/* not making runtime version */
#endif

#ifndef	SAVEFILE
#define	SAVEFILE	0	/* can't create save files */
#endif

#ifndef SETREAL
#define SETREAL     0   /* don't use reals for SET()  */
#endif

#ifndef	USEQUIT
#define	USEQUIT		0	/* use quit() to report errors instead of wrterr */
#endif

/*
 * 	Turn on system-specific features unless specifically turned off
 * 	in systype.h
 */
#ifndef DIRECT
#define	DIRECT		1	/* access Minimal data directly */
#endif

#ifndef EXECFILE
#define	EXECFILE	1	/* create executable modules */
#endif

#ifndef	FLOAT
#define	FLOAT		1	/* include floating point code */
#endif

#ifndef IO
#define	IO			1	/* include input/output code */
#endif

#ifndef	MATH
#define	MATH		1	/* include extended math (i.e., trig) code */
#endif

#ifndef PIPES
#define	PIPES		1	/* include pipe code */
#endif

#ifndef	POLLING
#define	POLLING		1	/* enable polling of operating system */
#endif

#ifndef PROTOTYPES
#define	PROTOTYPES	1	/* assume compiler can handle prototypes */
#endif

#ifndef USEFD0FD1
#define	USEFD0FD1	1	/* use file descriptor 0 & 1 for stdio	*/
#endif

/*
 *  Other defaulted values that may be overridden in systype.h
 */
#ifndef INTBITS
#define INTBITS		32			/* assume int will be 32 bits */
#define MAXINT		0x7FFFFFFFL	/* maximum positive value in int */
#endif
#ifndef WORDBITS
#define WORDBITS	32			/* assume word will be 32 bits */
#define MAXPOSWORD	0x7FFFFFFFL	/* maximum positive value in word */
#endif
#ifndef IABITS
#define IABITS      32          /* Integer accumulator (IA) width */
#endif



/*
 *  If not defined in systype.h, disable it here.
 */
/* compiler defs */
#ifndef BCC32
#define BCC32		0			/* 32-bit Borland C++ 4.x */
#endif
#ifndef VCC
#define VCC         0           /* 32-bit Microsoft Visual C++ */
#endif
#ifndef GCCi32
#define GCCi32      0
#endif
#ifndef GCCi64
#define GCCi64      0
#endif
#ifndef RS6
#define RS6			0
#endif
#ifndef SUN4
#define SUN4		0
#endif

/* operating system defs */
#ifndef AIX3
#define AIX3		0
#endif
#ifndef AIX4
#define AIX4		0
#endif
#ifndef BSD43
#define BSD43		0
#endif
#ifndef LINUX
#define LINUX       0
#endif
#if SUN4
#define SYSVERSION 3
#endif
#if AIX3 | AIX4
#define SYSVERSION 6
#endif
#if GCCi64
#define SYSVERSION 7
#endif
#ifndef SYSVERSION
#define SYSVERSION 255
#endif

#if EXECSAVE			/* EXECSAVE requires EXECFILE & SAVEFILE on */
#undef EXECFILE
#undef SAVEFILE
#define EXECFILE	1
#define SAVEFILE	1
#endif

/* Define how the errors and phrases arrays will be accessed (see sysem.c) */
#ifndef ERRDIST
#define ERRDIST
#endif

#ifndef FAR
#define FAR
#define readfar read
#define writefar write
#endif

#ifdef NEAR
#define __NEAR__ 1
#else
#define NEAR
#define __NEAR__ 0
#endif

#define GCCx86 (GCCi32 | GCCi64)
#define AIX (AIX3 | AIX4)

#define SUN SUN4

#define UNIX (AIX | BSD43 | LINUX)

typedef int   word;
typedef unsigned int uword;

/* Size of integer accumulator */
#if IABITS==32
typedef long IATYPE;
#elif IABITS==64
typedef long long IATYPE;
#endif

/*
/   Define the default end of line characters.  Use Unix definitions
/   as the default.  Override in systype.h.
*/
#ifndef EOL1
#define EOL1	'\n'
#endif

#ifndef EOL2
#define EOL2	0
#endif

/*
 * Define the data type returned by a call to signal()
 */
#if UNIX
#define SigType void
#else
#define	SigType int
#endif

/*
/   The following manifest constants define the page size used when the
/   compiler produces a source listing.
/
/   PAGE_DEPTH		number of lines to print on a page
/   PAGE_WIDTH		number of characters to print on a line
/					also the default record length for OUTPUT, TERMINAL
*/
#define PAGE_DEPTH  60
#define PAGE_WIDTH	120

/*
/	The following constant defines the size of the code word for
/	LZW compression of a save file.  See file compress.c.
*/
#if WORDBITS == 16
#define LZWBITS 10
#else
#define LZWBITS 12
#endif

/*
/   The following manifest contants describe the constraints on the heap
/   managed by the spitbol compiler.
/
/   All values can be overriden via command line options.
/
/   CHUNK_SIZE		the size of an allocation unit (chunk) used to
/                   create the heap.  Defined in WORDS!
/
/   CHUNK_B_SIZE	CHUNK_SIZE in bytes.
/
/   HEAP_SIZE		the maximum size that spitbol's heap (dynamic area)
/                   can become.  Defined in WORDS!
/
/   OBJECT_SIZE		the maximum size of any object created in the heap.
/                   Defined in WORDS!
/	Note: It was necessary to reduce this value from 8M to 1M  because
/   some DPMI hosts (like 386MAX) use much smaller
/	starting address for data section.  4MB seems to be a good lowest
/	common denominator so that Save files can move between all the
/	different DPMI platforms.
*/

#define CHUNK_SIZE	32768
#define CHUNK_B_SIZE	(CHUNK_SIZE * sizeof(word))
#define HEAP_SIZE	16777216	/* 16Mwords = 64Mbytes */
#define OBJECT_SIZE	1048576		/* 1 Mword = 4 Mbytes */
/*
 *  Define the maximum nesting allowed of INCLUDE files
 */
#define	INCLUDE_DEPTH	9


/*
 *  Define the standard file ids
 */
#ifndef STDINFD
#define STDINFD 0
#endif
#ifndef STDOUTFD
#define STDOUTFD 1
#endif
#ifndef STDERRFD
#define STDERRFD 2
#endif

/*
 *   Define number of SPITBOL statements to be executed between
 *   interface polling intervals.  Only used if POLLING is 1.
 *   Unix systems can get away with an infinite polling interval,
 *   because their interrupts are asynchronous, and do not require
 *   true polling.
 */
#ifndef PollCount
#if UNIX
#define PollCount MAXPOSWORD
#else         /* UNIX */
#define PollCount 2500
#endif          /* UNIX */
#endif					/* PollCount */


/*
 *   Define Params macro to use or ignore function prototypes.
 */
#if PROTOTYPES
#define Params(a) a
#else
#define Params(a) ()
#endif


/*
/   The following manifest contant describes the constraints on the
/   run-time stack.
/
/   The value can be overriden via command line option.
/
/   STACK_SIZE		the maximum size of the run-time stack.  Any attempt
/                   to make the stack larger results in a stack overflow
/                   error.  Defined in BYTES!
*/
#define STACK_SIZE  (0x100000)      /* Set to 1MB 6/28/09 */


/*
/   The following manifest constant defines the location of the host file
/   which contains a one line description of the system environment under
/   which spitbol is running.
/
/   HOST_FILE		pathname for host text file used by function syshs
*/
#define HOST_FILE	"/usr/lib/spithost"

/*
/   The following manifest constant defines the names the files created
/   by the EXIT(3) and EXIT(-3) function.
/
/   AOUT_FILE		pathname for load module created by sysxi
/   SAVE_FILE		pathname for save file created by sysxi
*/
#define SAVE_FILE	"a.spx"
#define AOUT_FILE	"a.out"

/*
/ PSEP is the separator between multiple paths.
/ FSEP is the separator between directories in a path.
/ EXT is separator between name and extension.
/ COMPEXT is extension for source files.
/ EFNEXT is extension for external functions.
/ RUNEXT is extension for save files.
/ BINEXT is extension for load modules
*/

#define PSEP  ':'
#define PSEP2 ' '
#define FSEP '/'

#define EXT '.'
#define	BINEXT ".out"
#define COMPEXT ".spt"
#define EFNEXT ".slf"
#define LISTEXT ".lst"
#define RUNEXT ".spx"
#define SPITFILEPATH  "snolib"  /* path for include and external files */

/*
/   The following manifest constant determines the maximum number of
/   files that can be open at a time.
/
/   OPEN_FILES		the maximum number of files that can be open at
/			a time.  Used by function ospipe to close files
/			given by a parent process to a child process.
*/
#define OPEN_FILES	32

/*
/   The following manifest constants determines the size of the temporary
/   SCBLKs defined by the interface.
/
/   TSCBLK_LENGTH	the maximum length of a string that can be stored
/                   in structure 'tscblk'.  'tscblk' is defined in
/                   file inter.s.
/
/   ID2BLK_LENGTH	the maximum length of a string that can be stored
/                   in structure 'id2blk'.  'id2blk' is defined in
/                   inter.c.  ID2BLK_LENGTH should be long enough
/                   to hold the computer name type string (htype)
/                   plus the date/time and a few blanks (typically
/                   20 characters).  It should also be a multiple of
/                   the word size.
/
*/
#ifndef TSCBLK_LENGTH
#define TSCBLK_LENGTH	512
#endif
#define ID2BLK_LENGTH	52

/*
/   The following manifest constants determine the default environment
/   variable name for the shell and it
/
/   SHELL_ENV_NAME	the name under which then shell path is stored
/                   in the environment
/
/   SHELL_PATH		a default shell to use in event one cannot be
/                   located in the environment
*/

#define SHELL_ENV_NAME	"SHELL"
#define SHELL_PATH      "/bin/sh"

/*
/   Compiler flags (see compiler listing for more details):
/
/   ERRORS	send errors to terminal
/   PRTICH	terminal is standard output file
/   NOLIST	suppress compilation listing
/   NOCMPS	suppress compilation statistics
/   NOEXCS	suppress execution statistics
/   LNGLST	generate long listing (WITH page ejects)
/   NOEXEC	suppress program execution
/   TRMNAL	support terminal i/o association
/   STDLST	standard listing (intermediate)
/   NOHDER	suppress spitbol compiler header
/   PRINTC      list control cards
/   WRTEXE	write executable module after compilation
/   CASFLD      fold upper and lower case names
/   NOFAIL	no fail mode
/
/   DFLT_FLAGS	reasonable defaults for UN*X environment
*/

#define	ERRORS		0x00000001L
#define PRTICH		0x00000002L
#define NOLIST		0x00000004L
#define NOCMPS		0x00000008L
#define NOEXCS		0x00000010L
#define LNGLST		0x00000020L
#define NOEXEC		0x00000040L
#define TRMNAL		0x00000080L
#define STDLST		0x00000100L
#define NOHEDR		0x00000200L
#define PRINTC		0x00000400L
#define NOERRO		0x00000800L
#define CASFLD		0x00001000L
#define NOFAIL		0x00002000L
#define WRTEXE		0x00004000L
#define WRTSAV		0x00008000L

#define NOBRAG		0x02000000L	/*	No signon header when loading save file */

#define DFLT_FLAGS  (ERRORS+PRTICH+NOLIST+NOCMPS+NOEXCS+TRMNAL+PRINTC+CASFLD+NOERRO)

#define _Optlink

#define const

#include "osint.h"

#ifdef PRIVATEBLOCKS
#include "extern32.h"
#else					/* PRIVATEBLOCKS */
#include "spitblks.h"
#include "spitio.h"
#endif					/* PRIVATEBLOCKS */


#include "globals.h"
#include "sproto.h"

!@#$prompt.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  PROMPT.C		Version:  01.00
/	---------------------------------------
/
/	Contents:	Function prompt
*/

#include "port.h"

/*	prompt() - used to give user usage info in command line versions.
 *
 */
void prompt()
{
#if RUNTIME
    wrterr("usage: spitrun [options] file[.spx] [program arguments]");
#else					/* RUNTIME */

#if SAVEFILE
    wrterr("usage: spitbol [options] files[.spt or .spx] [args to HOST(2)]");
#else					/* SAVEFILE */
    wrterr("usage: spitbol [options] files[.spt] [args to HOST(2)]");
#endif					/* SAVEFILE */

#endif					/* RUNTIME */

#if RUNTIME
    wrterr("options: (# is a decimal number)");
    wrterr("-u \"string\" data string available to program");
    wrterr("-#=file   associate file with I/O channel #");
#else					/* RUNTIME */
    wrterr("source files are concatenated, filename '-' is standard input/output");
    wrterr("# is a decimal number.  Append \"k\" for kilobytes, \"m\" for megabytes.");
    wrterr("options:");
    wrterr("-d# #bytes max heap            -i# #bytes initial heap size & enlarge amount");
    wrterr("-m# #bytes max object size     -s# #bytes stack size");
    wrterr("-c compiler statistics         -x execution statistics");
    wrterr("-a same as -lcx                -l normal listing");
    wrterr("-p listing with wide titles    -z listing with form feeds");
    wrterr("-o=file[.lst]  listing file    -h suppress version ID/date in listing");
    wrterr("-g# lines per page             -t# line width in characters");
    wrterr("-b suppress signon message     -e errors to list file only");
    wrterr("-k run with compilation error  -n suppress execution");
    wrterr("-f no case-folding             -u \"string\" data passed to HOST(0)");

#if EXECFILE & SAVEFILE
    wrterr("-w write load (.out) module    -y write save (.spx) file");
#endif					/* EXECFILE & SAVEFILE */

#if SAVEFILE & !EXECFILE
    wrterr("-y write save (.spx) file");
#endif					/* SAVEFILE & !EXECFILE */

    wrterr("-r INPUT from source file following END statement");
    wrterr("-T=file  write TERMINAL output to file");
    wrterr("-#=file[options]  associate file with I/O channel #");
    wrterr("option defaults: -d64m -i128k -m4m -s128k -g60 -t120");

#endif					/* RUNTIME */

    __exit(0);
}
!@#$rdenv.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  RDENV.C		Version:  01.02
/	---------------------------------------
/
/	Contents:	Function rdenv
*/

/*
/   rdenv( varname, result )
/
/   rdenv() reads the environment variable named "varname", and if it can
/   be read, puts its value in "result.
/
/   Parameters:
/	varname	pointer to character string containing variable name
/	result	pointer to character string to receive result
/   Returns:
/	0 if successful / -1 on failure
/
/	v1.02 02-Jan-91 Changed rdenv to use cpys2sc instead of mystrncpy.
/					Add private getenv().
*/

#include "port.h"

/*
/   Find environment variable vq of length vn.  Return
/   pointer to value (just past '='), or 0 if not found.
*/
char *findenv( vq, vn )
char *vq;
int  vn;
{
    char savech;
    char *p;

    savech = make_c_str(&vq[vn]);
    p = (char *)getenv(vq);			/* use library lookup routine */
    unmake_c_str(&vq[vn], savech);
    return p;

}

rdenv( varname, result )
register struct scblk *varname, *result;
{
    register char *p;


    if ( (p = findenv(varname->str, varname->len)) == 0 )
        return -1;

    cpys2sc(p, result, TSCBLK_LENGTH);

    return 0;
}

/* make a string into a C string by changing the last character to null,
 * returning the old character at that location.
 * If the old character was already null, no change is made, so that
 * this works if passed a read-only C-string.
 */
char make_c_str(p)
char *p;
{
    char rtn;

    rtn = *p;
    if (rtn)
        *p = 0;
    return rtn;
}


/* Intel compiler bug? */
void unmake_c_str(p, savech)
char *p;
char savech;
{
    if (savech)
        *p = savech;
}
!@#$save.h
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:   SAVE.H           Version 1.01
/	-------------------------------------
/
/	This header file provides information for writing the impure
/	portions of SPITBOL's data segments to a save file.
/
/ v1.01 3-Jun-91 MBE
/	Added memincb, maxsize, readshell0 & uarg to header, and
/	additional argument to specify whether these values should
/	override existing values, as would be the case for the
/	Intel MS-DOS version, where Save files are used to simulate
/	Exec files.
/
*/
#if SAVEFILE
/*
 * +--------2--------+--------2--------+---------4---------+
 * |                 |                 |                   |
 * |     IA size     |    WORD size    | Save File Version |
 * |                 |                 |                   |
 * +-----------------+-----------------+-------------------+
 *
 * IA (integer accumulator) and Minimal Word Size:
 *  0 - 16 bits
 *  1 - 32 bits
 *  2 - 64 bits
 *  3 - 128 bits
 */
#define VWBSHFT     4
#define VIASHFT     (VWBSHFT+2)
#define VERSION     5
#define SaveVersion ((unsigned char)(VERSION+((WORDBITS/32)<<VWBSHFT)+(IABITS/32)<<VIASHFT))
#define UargSize    128

struct svfilehdr {
    unsigned long   magic1;         /* recognizer for object file           */
    unsigned long   magic2;         /* line terminators                     */
    unsigned char   version;        /* version of runtime needed            */
    unsigned char   system;         /* system version                       */
    short int       spare;          /* spare cells to dword boundary        */
    char            serial[8];      /* compiler serial number               */
    char            headv[8];       /* version string                       */
    char            iov[12];        /* i/o version string                   */
    unsigned long   timedate;       /* date and time of creation            */
    long            flags;          /* spitflag word                        */
    uword           stacksiz;       /* total size of stack area             */
    char            *stbas;         /* base of stack at save time           */
    uword           stacklength;    /* size of stack area in use            */
    uword           sec3size;       /* size of constant section             */
    char            *sec3adr;       /* address of constant section          */
    uword           sec4size;       /* size of work section                 */
    char            *sec4adr;       /* address of work section              */
    uword           statoff;        /* static offset=hshtb-basemem          */
    uword           dynoff;         /* dynamic offset=dnamb-basemem         */
    uword           heapsize;       /* size of heap after collection        */
    char            *heapadr;       /* address of heap                      */
    char            *topmem;        /* previous top of heap                 */
    uword           databts;        /* largest allowed size of heap         */
    uword           sec5size;       /* size of SPITBOL code                 */
    char            *sec5adr;       /* address of SPITBOL code              */
    uword           memincb;        /* memory increment size                */
    uword           maxsize;        /* maximum object size                  */
    word            compress;       /* 0 = no compress,                     */
    /* >0 = code word size (bits)           */
    word            uarglen;        /* length of -u command string          */
};

#define OURMAGIC1   0xfaa5a5fa
#define OURMAGIC2   0x0d0a0d0a
#endif					/* SAVEFILE */

#if SUN4
#define	PAGESIZE	PAGSIZ
#define T_START     SEGSIZ   /* N_MAGIC, no dynamic loading */
#endif					/* SUN4 */

!@#$sioarg.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/


/*
/	File:  SIOARG.C		Version:  01.07
/	---------------------------------------
/
/	Contents:	Function sioarg
*/

/*
/   sioarg( ioflg,ioptr,scptr )
/
/   sioarg() scans any arguments after the filename in the passed SCBLK and
/   sets appropriate values in the passed ioblk.
/
/   Parameters:
/	ioflg	0 - input association/ 3 - output association
/	ioptr	pointer to IOBLK representing file
/	scptr	pointer to SCBLK containing filename and args
/   Returns:
/	0 - options successfully processed / -1 - option error
/   Side Effects:
/	Modifies contents of passed IOBLK (ioptr).
/
/	V1.02	Distinguish default input/output record lengths
/	V1.03	Buffer size and record size must be less than
/			maxsize to avoid garbage collector problems when
/			these values are stored in fcblk and ioblk.
/	V1.04	Add i/o option -u for update mode.
/	V1.05	01-Aug-93. Add IO_EOT flag to ignore EOT char in
/			DOS-mode text files.
/	V1.06   21-Oct-94. Use uppercase function to fold case letters.
/	V1.07	26-Oct-94. Added share field to ioblk and processing of
/			-S option.
/			In -B option, subtract BFSIZE from maxsize before comparison.
/	V1.08	18-Dec-94. Add -I and -X options.
*/

#include "port.h"

/*  uppercase( word )
 *
 *  restricted upper case function.  Only acts on 'a' through 'z'.
 */
word uppercase(c)
word c;
{
    if (c >= 'a' && c <= 'z')
        c += 'A' - 'a';
    return c;
}

int	sioarg( ioflg, ioptr, scptr )

int	ioflg;
struct	ioblk	*ioptr;
struct	scblk	*scptr;

{
    int	lastdash = 0;
    word	cnt, v, share;
    char	ch, *cp;

    cp	= scptr->str;

    /*
    /	Initialize the default values for an I/O association.  Note that
    /	some of the fields are used here for purposes other than their
    /	normal uses.
    /
    /	typ	arguments found flag:  0 - no args / 1 - args found
    /		(when no args are present assume that this association has
    /		same properties as previous association for THIS file.)
    /	len	record mode and length:  >0 line mode / <0 raw mode
    /	pid	buffer size
    / fdn shell or external function provided file descriptor (IO_SYS flag)
    /	flg1,2	IO_INP or IO_OUP as appropriate and other flags
    */
    ioptr->typ = 0;			/* no args seen yet		*/
    ioptr->fdn = 0;			/* no shell provided fd		*/
    ioptr->pid = IOBUFSIZ;	/* buffer size		*/
    ioptr->eol1 = EOL1;		/* default end of line char 1	*/
    ioptr->eol2 = EOL2;		/* default end of line char 2	*/
    if (ioflg)
    {   /* output */
        ioptr->len = maxsize;	/* line mode record len	*/
        ioptr->flg1 = IO_OUP;
        ioptr->share = IO_DENY_READWRITE | IO_PRIVATE;
        ioptr->action= IO_REPLACE_IF_EXISTS | IO_CREATE_IF_NOT_EXIST;
    }
    else
    {   /* input */
        ioptr->len = IRECSIZ;	/* line mode record len	*/
        ioptr->flg1 = IO_INP;
        ioptr->share = IO_DENY_WRITE | IO_PRIVATE;
        ioptr->action = IO_OPEN_IF_EXISTS;
    }
    ioptr->flg2 = 0;
    /*
    /	If lenfnm() fails so shall we.
    */
    if ( (cnt = lenfnm( scptr )) < 0 )
        return	-1;

    /*
    /	One iteration per character.  Note that scanning an integer causes
    /	more than one character to be handled in an iteration.
    */
    while ( cnt < scptr->len )
    {
        ch = uppercase(*(cp + cnt++));	/* get next character		*/
        switch (ch)
        {
        case ' ':
        case '\t':
        case ',':
        case '[':
        case ']':
            lastdash = 0;
            continue;

        case '-':
            if ( lastdash != 0 )	/* "--" is illegal	*/
                return ( -1 );
            else
            {
                lastdash = 1;	/* saw an '-'		*/
                continue;
            }

            /*
            /   A - append output at end of existing file
            */
        case 'A':
            ioptr->flg1 |= IO_APP;
            ioptr->action &= ~IO_REPLACE_IF_EXISTS;
            ioptr->action |= IO_CREATE_IF_NOT_EXIST | IO_OPEN_IF_EXISTS;
            break;

            /*
            /   B - set size of I/O buffer (stored in pid field).
            */
        case 'B':
            v = scnint( cp + cnt, scptr->len - cnt, &cnt );
            if ( v > 0  &&
                    ((v + sizeof(word) - 1) & ~(sizeof(word) - 1)) <= (maxsize - BFSIZE) )
                ioptr->pid = v;
            else
                return	-1;
            break;

            /*
            /   C - set raw mode, character at a time access.
            */
        case 'C':
            ioptr->len = -1;
            break;

            /*
            /   E- ignore end-of-text character (DOS only)
            */
        case 'E':
            ioptr->flg1 |= IO_EOT;
            break;

            /*
            /   F - set file descriptor number (file opened by shell or external func).
            */
        case 'F':
            v = scnint( cp + cnt, scptr->len - cnt, &cnt );
            ioptr->fdn = v;
            ioptr->flg1 |= ( IO_OPN | IO_SYS );
            if ( ioflg && (testty(v) == 0) )
                ioptr->flg1 |= IO_WRC;

#if HOST386
            /* Test for character input/output to a device */
            if ( ioflg && !coutdev( v ) )	/* Test for character output */
                ioptr->flg1 |= IO_COT;
#endif					/* HOST386 */

            break;

            /*
            /	I - make file inheritable by any child processes
            */
        case 'I':
            ioptr->share &= ~IO_PRIVATE;
            break;

            /*
            /   L - line mode access having max record length v.
            */
        case 'L':
            v = scnint( cp + cnt, scptr->len - cnt, &cnt );
            if ( v > 0 && (uword)v <= maxsize )
                ioptr->len = v;
            else
                return	-1;
            break;

            /*
            /   M - specify end-of-line character 1.
            */
        case 'M':
            /*
            /   N - specify end-of-line character 2.
            */
        case 'N':
            v = scnint( cp + cnt, scptr->len - cnt, &cnt );
            if ( v >= 0 && v <= 255 ) {
                if (ch == 'M')
                    ioptr->eol1 = v;
                else
                    ioptr->eol2 = v;
            }
            else
                return -1;
            break;

            /*
            /   R - raw mode access of v characters.
            /   Q - like R, but no echo (quiet) if console input.
            */
        case 'Q':
            ioptr->flg2 |= IO_NOE;
        case 'R':
            v = scnint( cp + cnt, scptr->len - cnt, &cnt );
            if ( v > 0 && v <= (word)maxsize )
                ioptr->len = -v;
            else
                return	-1;
            break;

            /*
            /	S - sharing mode:
            /		-sdn	=	deny none
            /		-sdr	=	deny read
            /		-sdw	=	deny write
            /		-sdrw	=	deny read/write
            */
        case 'S':
            ch = uppercase(*(cp + cnt++));	/* get next character		*/
            if (ch != 'D')
                return -1;
            ch = uppercase(*(cp + cnt++));	/* get next character		*/
            switch (ch)
            {
            case 'N':
                share = IO_DENY_NONE;
                break;
            case 'R':
                share = IO_DENY_READ;
                if (uppercase(*(cp + cnt)) == 'W') {
                    share = IO_DENY_READWRITE;
                    cnt++;
                }
                break;
            case 'W':
                share = IO_DENY_WRITE;
                break;
            default:
                return -1;
            }

            if (cnt >= scptr->len)
                return -1;
            ioptr->share = (ioptr->share & ~IO_DENY_MASK) |  share;
            break;

            /*
            /   U - update access to file
            */
        case 'U':
            ioptr->flg1 |= (IO_INP | IO_OUP);
            if (ioptr->len == (word)maxsize)
                ioptr->len = IRECSIZ;	/* limit to input record len */
            ioptr->action &= ~IO_REPLACE_IF_EXISTS;
            ioptr->action |= IO_CREATE_IF_NOT_EXIST | IO_OPEN_IF_EXISTS;
            break;

            /*
            /   W - write with no buffering within SPITBOL.
            */
        case 'W':
            ioptr->flg1 |= IO_WRC;
            break;

            /*
            /	X - mark file executable
            */
        case 'X':
            ioptr->share |= IO_EXECUTABLE;
            break;

            /*
            /   Y - write with no buffering within SPITBOL or within operating system.
            */
        case 'Y':
            ioptr->flg1 |= IO_WRC;
            ioptr->action |= IO_WRITE_THRU;
            break;

            /*
            /   Unknown argument.
            */
        default:
            return	-1;
        }

        /*
        /   Indicate that an argument was found and processed and
        /   that the last character processed was not a '-'.
        */
        ioptr->typ = 1;		/* processed arg		*/
        lastdash = 0;		/* last char not a '-'		*/
    }
    /*
    /	Return successful scanning.
    */
    return	0;
}


/*
/   scnint( str, len, intptr )
/
/   scnint() scans and converts a decimal number at the front of a string.
/   "len" specifies the maximum number of digits that can be scanned.
/
/    Parameters:
/	str	pointer to string containing number at front
/	len	maximum number of digits to scan
/	intptr	pointer to integer to be adjusted by number of digits scanned
/    Returns:
/	Integer converted
/    Side Effects:
/	Modifies integer pointed to by intptr.
*/


word	scnint( str, len, intptr )

char	*str;
word	len;
word	*intptr;

{
    register word	i = 0;
    register word	n = 0;
    register char	ch;

    while ( i < len )
    {
        ch	= str[i++];
        if ( ch >= '0'  &&  ch <= '9' )
            n = 10 * n + ch - '0';
        else
        {
            --i;
            break;
        }
    }
    *intptr += i;
    return	n;
}



!@#$spitblks.h
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/   File:  SPITBLKS.H		Version:  01.01
/   -------------------------------------------
/
/   This header file defines structures used by the Macro SPITBOL compiler
/   that are passed into the OS interface.
*/

/*
/   First, define the C type word to be the same size as a word used
/   by the Macro SPITBOL compiler.  The type of a word is a signed
/   integer for now.
*/

/*
 * 	BUFFER CONTROL BLOCK
 *
 *	A buffer control block (BCBLK) is created by the BUFFER
 *	function, and serves as an indirect control header for the
 *	buffer. It contains the number of characters currently
 *	stored in the buffer.
 */
struct bcblk {
    word	typ;					/* type word							*/
    word	idv;					/* identifier value						*/
    word	len;					/* number of chars in use in bfblk		*/
    struct bsblk *bcbuf;			/* pointer to bfblk						*/
};

/*
 * 	STRING BUFFER BLOCK
 *
 *	A string buffer block (BFBLK) contains the actual buffer
 *	memory area. It specifies the largest string that can be
 *	stored in the buffer.
 */
struct bsblk {
    word	typ;					/* type word							*/
    word	bsalc;					/* allocated size of buffer				*/
    char	bschr[1];				/* characters of string					*/
};


/*
 * CODE BLOCK
 *
 * A code block (CDBLK) is present for every source statement.
 */

struct cdblk {
    word			cdjmp;			/* ptr to routine to execute statement	*/
    word			cdstm;			/* statement number						*/
    word			cdsln;			/* source file line number				*/
    word			cdlen;			/* length of CDBLK in bytes				*/
    union {
        struct cdblk NEAR *cdnxt;	/* if failure exit is next statement	*/
        struct vrblk NEAR *cdlab;	/* if failure exit is a simple label	*/
        char 		 NEAR *cdnof;	/* no failure exit (-NOFAIL mode)		*/
        word		  cddir;		/* failure exit is complex or direct	*/
    }			cdfal;			/* Failure exit							*/
    word			cdcod[1];		/* executable pseudo-code				*/
};


/*
/   CHFCB - chain of FCBs block
/
/   For every FCB created by OSINT, the compiler creates a CHFCB pointing
/   to the FCB and links it onto a chain of CHFCBs.  At EOJ the head of this
/   CHFCB chain is passed to the interface function SYSEJ so that all files
/   can be closed.
*/

struct	chfcb {
    word	typ;				/*  type word			*/
    word	len;				/*  block length		*/
    struct	chfcb NEAR *nxt;	/*  pointer to next chfcb	*/
    struct	fcblk NEAR *fcp;	/*  pointer to fcb		*/
};


/*
/   EFBLK - external function block
/
*/

struct	efblk {
    word	fcode;				/*  type word			*/
    word	fargs;				/*  number of arguments	*/
    word	eflen;				/*  block length		*/
    word	efuse;				/*  usage count			*/
    void NEAR *efcod;			/*  pointer to XNBLK	*/
    struct vrblk NEAR *efvar;	/*  pointer to VRBLK	*/
    word	efrsl;				/*  result type			*/
    word	eftar[1];			/*  argument types		*/
};

/*
/   ICBLK - integer block
/
/   Integer values are stored in ICBLKs.  Field icval should be defined
/   to be the appropriate type for the implementation.
*/

struct	icblk {
    word	typ;		/*  type word - b$icl		*/
    IATYPE	val;
};

/*
/	RCBLK - real block
/
/	Real values are stored in RCBLKs.  Field rcval should be defined
/	to be the appropriate type for the implementation.
*/

struct	rcblk {
    word	typ;		/*	type word - b$rcl */
    double	rcval;		/*	real value */
};

/*
/   SCBLK - string block
/
/   String values are stored in SCBLKs.  Notice that the scstr field
/   is defined as an array of characters of length 1.  This is a slight
/   kludge to side-step C's lack of support for varying length strings.
/
/   The actual length of a SCBLK is 2 words + the number of words necessary
/   to hold a string of length sclen.
*/

struct	scblk {
    word	typ;		/*  type word - b$scl		*/
    word	len;		/*  string length		*/
    char	str[1];		/*  string characters		*/
};


/*
 * VARIABLE BLOCK
 *
 * A variable block (VRBLK) is used to hold a program variable.
 */

struct vrblk {
    word			vrget;			/* routine to load variable onto stack	*/
    word			vrsto;			/* routine to store stack top into var.	*/
    union block	 NEAR *vrval;		/* variable value						*/
    word			vrtra;			/* routine to transfer to label			*/
    union block	 NEAR *vrlbl;		/* pointer to code for label			*/
    union block	 NEAR *vrfnc;		/* function block if name is function	*/
    struct vrblk NEAR *vrnxt;		/* next vrblk on hash chain				*/
    word			vrlen;			/* length of name						*/
    char			vrchs[1];		/* characters of name					*/
};




/*
/	BLOCK - an arbitrary block
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
!@#$spitio.h
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/   File:  SPITIO.H     Version:  01.09
/   -------------------------------------------
/
/   This header file defines the I/O control blocks used by the
/   operating system interface for the Macro Spitbol compiler.
/
/  V1.09 27-Apr-97 Add FILEPOS definition.
/  V1.08 26-Oct-94 Add "share" word to ioblk to allow file sharing
/			options.  Also, in the bfblk, change buf[1] to buf[sizeof(word)]
/			so that BFSIZE is calculated properly with compilers that
/			round-up the size of a structure to a word-multiple.
/	V1.07	01-Aug-93 Add IO_EOT flag to ignore EOT char in DOS-mode text files.
/	V1.06	01-Feb-93 Split record size into two fields (rsz and mode) in fcb, to
/			prevent negative record size appearing to be a valid
/			pointer in 8088 SPITBOL.
/	V1.05	Add IO_DIR, change definitions in bfblk to
/			accommodate read/write files.
/	V1.04	Split IOBLK flags into two words
/	V1.03	Add IO_COT flag from MS-DOS
/	V1.02	Split RECSIZ into IRECSIZ and ORECSIZ
*/

/* Size of file position words in I/O buffer block */
#if SETREAL
typedef double FILEPOS;     /* real file positions */
#else
typedef long FILEPOS;       /* 32-bit file positions */
#endif

/*
/   BLBLK - I/O buffer block
/
/   All buffered I/O is passed through a BFBLK.  This block is intentionally
/   kept non-relocatable, so that it can be freely moved around the heap by
/   the garbage collector.
/
/	WARNING:  INPBUF and TTYBUF are manually assembled into inter.asm and
/			  inter.s, and must be changed in all versions if this structure
/			  is altered.
*/

struct bfblk
{
    word typ;       /*  type word           */
    word len;       /*  length of bfblk        */
    word size;      /*  size of buffer in bytes      */
    word fill;      /*  number of bytes currently in buffer   */
    word next;      /*  next buffer position to read/write */
    FILEPOS offset; /*  file position of first byte in buf */
    FILEPOS curpos; /*  physical file position    */
    char	buf[sizeof(word)]; /* buffer ([sizeof(word)] is kludge for C) */
};

#define BFSIZE		(sizeof( struct bfblk ) - sizeof( word ))

/*
/   FCBLK - file control block (type XRBLK)
/
/   For every I/O association a FCBLK is created.  All subsequent I/O
/   operations are passed this block.
*/

struct fcblk
{
    word	typ;			/*  type word					*/
    word	len;			/*  length of fcblk				*/
    word	rsz;			/*  record size					*/
    struct ioblk NEAR *iob;	/*  pointer to IOBLK			*/
    word	mode;			/*  1=line mode, 0 = raw mode	*/
};

#define FCSIZE		(sizeof( struct fcblk ))

/*
/   IOBLK - I/O control block (type XRBLK)
/
/   For every SPITBOL I/O channel there is one central IOBLK containing
/   information about the channel:  filename, file descriptor, IOBLK
/   pointer, etc.
/
/   Because IOBLK is an XRBLK, and hence relocatable, all words in
/   the block must be relocatable pointers, or smaller than MXLEN.
/   Systems using 16-bit words typically use small MXLENs, and
/   may cause values in the flg word to be mis-interpreted as pointers.
/   For this reason, I/O flags will be split across two words.
/
*/

struct ioblk
{
    word	typ;			/*  type word				*/
    word	len;			/*  length of IOBLK			*/
    struct scblk NEAR *fnm;	/*  pointer to SCBLK holding filename	*/
    word	pid;			/*  process id for pipe			*/
    struct bfblk NEAR *bfb;	/*  pointer to BFBLK (type XNBLK)	*/
    word	fdn;			/*  file descriptor number		*/
    word	flg1;			/*  first nine flags			*/
    word	flg2;			/*  second nine flags			*/
    word	eol1;			/*  end of line character 1		*/
    word	eol2;			/*  end of line character 2		*/
    word	share;			/*	sharing mode				*/
    word	action;			/*  file open actions			*/
};

#define IOSIZE		(sizeof( struct ioblk ))

/*
 *  I/O flags within the flg1 and flg2 words of an IOBLK.
 *
 *  Caution:  Do not attempt to redefine as C bit fields.  Bit fields
 *  may be assigned to high-order bits on some systems, and this would
 *  produce values larger than MXLEN.
 */
/* Flags in flg1 */
#define IO_INP		0x00000001	/* file open for reading */
#define IO_OUP		0x00000002	/* file open for writing */
#define IO_APP		0x00000004	/* append output to existing file */
#define IO_OPN		0x00000008	/* file is open */
#define IO_COT		0x00000010	/* console output to non-disk device */
#define IO_CIN		0x00000020	/* console input from non-disk device */
#define IO_SYS		0x00000040	/* -f option used instead of name */
#define IO_WRC		0x00000080	/* output without buffering */
#define IO_EOT		0x00000100	/* Ignore end-of-text (control-Z) char */

/* Flags in flg2 */
#define IO_PIP		0x00000001	/* pipe */
#define IO_DED		0x00000002	/* dead pipe */
#define IO_ILL		0x00000004	/* illegal I/O association */
#define	IO_RAW		0x00000008	/* binary I/O to TTY device */
#define	IO_LF		0x00000010	/* Ignore eol2 if next character (pipes only) */
#define IO_NOE		0x00000020	/* no echo input */
#define IO_ENV		0x00000040	/* filearg1 maps to filename thru environment var */
#define IO_DIR		0x00000080	/* buffer is dirty (needs to be written) */
#define IO_BIN		0x00000100	/* last fcb to open file used raw mode */

#ifndef	 IRECSIZ
#define  IRECSIZ	1024		/* input line length */
#endif

#define  ORECSIZ	((word)MAXPOSWORD)	/* output line length */

#define  IOBUFSIZ	1024

/* Private flags used to convey sharing status when opening a file */
#define IO_COMPATIBILITY	0x00
#define IO_DENY_READWRITE	0x01
#define IO_DENY_WRITE		0x02
#define IO_DENY_READ		0x03
#define IO_DENY_NONE		0x04
#define IO_DENY_MASK		0x07		/* mask for above deny mode bits*/
#define	IO_EXECUTABLE		0x40		/* file to be marked executable */
#define IO_PRIVATE			0x80		/* file is private to current process */

/* Private flags used to convey file open actions */
#define IO_FAIL_IF_EXISTS		0x00	/* file exists -- fail */
#define IO_OPEN_IF_EXISTS		0x01    /* file exists -- open */
#define IO_REPLACE_IF_EXISTS	0x02    /* file exists -- open and truncate */
#define IO_FAIL_IF_NOT_EXIST	0x00	/* file does not exist -- fail */
#define IO_CREATE_IF_NOT_EXIST	0x10    /* file does not exist -- create it */
#define IO_EXIST_ACTION_MASK	0x13	/* mask for above bits */
#define IO_WRITE_THRU       	0x20	/* writes complete before return*/
!@#$sproto.h
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  SPROTO.H	Version 1.02
/	----------------------------
/
/	Function prototypes for argument type checking.
/	This files are unique to SPITBOL.
*/

#ifndef	_sproto_
#define	_sproto_

typedef int File_handle;
typedef int File_mode;
typedef int Open_method;

extern	union block *	alloc Params((word nchars));
extern	struct scblk *	alocs Params((word nchars));
extern	union block *	alost Params((word nchars));
extern	int			appendext Params((char *path, char *ext, char *result, int force));
extern	int			arg2scb Params(( int req, int argc, char *argv[], struct scblk *scptr, int maxs ));
#if EXTFUN
extern  union block *   callef Params((struct efblk *efb, union block **sp, word nargs));
#endif
extern	int			checkfpu Params(( void ));
extern	int			checksave Params((char *namep));
extern	int			checkstr Params(( struct scblk *scp ));
extern	int			check2str Params(( void ));
extern	int			check3str Params(( void ));
extern	int			chrdev Params(( File_handle F ));
extern	int			cindev Params(( File_handle F ));
extern	int			cinread Params(( File_handle fd, char *buf, int size ));
extern	void		close_all Params(( struct chfcb *chb ));
extern	word		closeaout Params(( char *filename, char *tmpfnbuf, word errflag ));
extern	void		clrbuf Params(( void ));
extern	int			compress Params(( unsigned char FAR *startadr, uword size ));
extern	void		conv Params(( char *dest, int value ));
extern	int			coutdev Params(( File_handle F ));
extern	void		cpys2sc Params(( char *cp, struct scblk *scptr, word maxlen ));
extern	void		crlf Params(( void ));
extern	int			docompress Params(( int bits, char *freeptr, uword size ));
extern	void		doexec Params(( struct scblk *scbptr ));
extern	int			doexpand Params(( int bits, char *freeptr, uword size ));
extern   FILEPOS  doset Params(( struct ioblk *ioptr, FILEPOS offset, int whence ));
extern  int     dosys Params(( char *cmd, char *path ));
extern	void		endbrk Params((void));
extern	struct scblk *	enevs Params((struct scblk *inScblkPtr, word flag));
extern	struct scblk *	endtp Params((union block *inBlkPtr));
extern	struct scblk *	engts Params((union block *inBlkPtr));
extern	void		exephase Params((void));
extern	void		exeinput Params((void));
extern	void		__exit  Params((int code));
extern	int			expand Params(( File_handle fd, unsigned char FAR *startadr, uword size ));
extern	word		fillbuf Params(( struct ioblk *ioptr ));
extern	char *		findenv Params(( char *vq, int vn ));
extern	int			flush Params(( struct ioblk *ioptr ));
extern	void		flush_all Params((struct chfcb *chb));
extern   int         fsyncio Params((struct ioblk *ioptr));
extern	long		gencmp Params((char*, char*, long, long, long));
extern	word *		get_fp Params(( void ));
extern	char **		getargs Params((int argc, char *argv[]));
extern	double		get_ra Params(( void ));
extern   FILEPOS     geteof Params(( struct ioblk *ioptr ));
extern	void		gethost Params(( struct scblk *scptr, word maxlen ));
extern	int			getint Params(( struct icblk *icp, IATYPE *pword ));
extern	char		*getnum Params(( char *cp, uword *ip ));
extern	File_handle	getprfd Params(( void ));
extern	struct ioblk *	getpriob Params(( void ));
extern	File_handle	getrdfd Params(( void ));
extern	struct ioblk *	getrdiob Params(( void ));
extern	int			getsave Params((File_handle fd));
extern	char *		getshell Params(( void ));
extern	char *		getstring Params(( struct scblk *scp, char *cp ));
extern	void		gettype Params(( struct scblk *scptr, word maxlen ));
extern	char *		heapAlloc Params(( void *minAdr, word size ));
extern	void		heapmove  Params(( void ));
extern	int			host386 Params(( int hostno ));
extern	int			host88 Params(( int hostno ));
extern	int			hostapl Params(( int hostno ));
extern	void		init_custom Params(( void ));
extern	void		initpath Params(( char *name ));
extern	word		lenfnm Params(( struct scblk *scptr ));
extern	int			length Params(( char *cp ));
extern	void *		loadef Params((word fd, char *filename));
extern	long		lstrncmp Params((char*, char*, long, long));
extern	int			_main Params(( int srcfd, int argc, char *argv[] ));
extern	int			makeexec Params(( struct scblk *scptr, int type ));
extern	char	    make_c_str Params(( char *p ));
extern	void		malloc_empty Params(( void ));
extern	int			malloc_init Params(( word endadr ));
extern	long		moremem Params(( long n, char **pp ));
extern	char		*mystrcpy Params(( char *p, char *q));
extern	int			mystrncpy Params(( char *p, char *q, int i));
extern	void *		nextef Params(( unsigned char FAR **bufp, int io ));
extern	void		numout Params(( unsigned n ));
extern	int			openaout Params(( char *fn, char *tmpfnbuf, int exe ));
extern	int			openexe Params((char *name));
extern	int			optfile Params(( struct scblk *varname, struct scblk *result ));
extern	char		*optnum Params(( char *cp, uword *ip ));
extern	int			osclose Params(( struct ioblk *ioptr ));
extern	int			osopen Params(( struct ioblk *ioptr ));
extern  int         ospipe Params(( struct ioblk *ioptr ));
extern	word		osread Params(( word mode, word recsiz, struct ioblk *ioptr, struct scblk *scptr ));
extern  void        oswait Params(( int pid ));
extern  word        oswrite Params(( word mode, word linesiz, word recsiz, struct ioblk *ioptr, struct scblk *scptr ));
extern	void		oupeof Params(( void ));
extern	char *		pathlast Params(( char *path ));
extern	void		prompt Params(( void ));
extern	word		putsave Params((word *stkbase, word stklen));
extern	void		quit Params(( int errno ));
extern	void		rawmode Params(( File_handle F, int mode ));
extern	int			rdaout Params(( File_handle fd, unsigned char FAR *startadr, uword size ));
extern	int			rdenv Params(( struct scblk *varname, struct scblk *result ));
#ifndef readfar
extern	uword		readfar Params(( File_handle fd, void FAR *Buf, uword Cnt ));
#endif
extern	int			renames Params((char *oldname, char *newname));
extern	void		rereloc Params(( void ));
extern	int			resaout Params(( char *filename ));
extern	void		restart Params(( char *code, char *stack ));
extern	void		restore0 Params(( void ));
extern	void		restorestring Params((struct scblk *scp, word c));
extern	void		restore2str Params(( void ));
extern	void		restore3str Params(( void ));
extern	word		roundup Params((word n));
extern	void		save0 Params(( void ));
extern	word		saveend Params((word *stkbase, word stklen));
extern	long		savestart Params((File_handle fd, char *bufp, unsigned int size));
extern	char *		savestr Params(( struct scblk *scp, char *cp ));
extern	void		save2str Params(( char **s1p, char **s2p ));
extern	void		save3str Params(( char **s1p, char **s2p, char **s3p ));
extern	void		scanef Params(( void ));
extern	word		scnint Params(( char *str, word len, word *intptr ));
extern	int			seekaout Params((long pagesize));
extern	void		set_ra Params((double f));
extern	void		setoptions Params((word flags));
extern	void		setout Params(( void ));
extern	void		setprfd Params(( File_handle fd ));
extern	void		setrdfd Params(( File_handle fd ));
extern	int			sioarg Params(( int ioflg, struct ioblk *ioptr, struct scblk *scptr ));
extern	File_handle	spit_open Params(( char *Name, Open_method Method, File_mode Mode, int Access ));
extern	void		startbrk Params(( void ));
extern	void		startup Params(( char *code, char *stack ));
extern	int			storedate Params(( char *cp, word maxlen ));
extern	int			stcu_d Params(( char *out, unsigned int in, int outlen ));
extern	void		stdioinit Params(( void ));
extern	void		strout Params(( char *s ));
extern	int			swcinp Params(( int filecnt, char **fileptr ));
extern	int			swcoup Params(( char *oupptr ));
extern	void		termhost Params((void));
extern	int			testty Params(( File_handle fd ));
extern	int			tryopen Params(( char *cp ));
extern	int			trypath Params(( char *name, char *file ));
extern  void        ttyoutfdn Params((File_handle h));
extern  void        ttyinit Params(( void ));
extern	void		ttyraw Params(( File_handle fd, int flag ));
extern	void		unldef Params((struct efblk *efb));
extern	void	    unmake_c_str Params(( char *p, char saved_c));
extern	void		unreloc Params(( void ));
extern	word		uppercase Params(( word c ));
extern	word		wabs Params((word x));
#ifndef writefar
extern	uword		writefar Params(( File_handle fd, void FAR *Buf, uword Cnt ));
#endif
extern	int			wrtaout Params(( unsigned char FAR *startadr, uword size ));
extern	void		wrterr Params(( char *s ));
extern	void		wrtint Params(( int));
extern	void		wrtmsg Params(( char *s ));
extern	int			zysax Params(( void ));
extern	int			zysbs Params(( void ));
extern	int			zysbx Params(( void ));
extern	int			zyscm Params(( void ));
extern	int			zysdc Params(( void ));
extern	int			zysdm Params(( void ));
extern	int			zysdt Params(( void ));
extern	int			zysea Params(( void ));
extern	int			zysef Params(( void ));
extern	void		zysej Params(( void ));
extern	int			zysem Params(( void ));
extern	int			zysen Params(( void ));
extern	int			zysep Params(( void ));
extern	int			zysex Params(( void ));
extern	int			zysfc Params(( void ));
extern	int			zysgc Params(( void ));
extern	int			zyshs Params(( void ));
extern	int			zysid Params(( void ));
extern	int			zysif Params(( void ));
extern	int			zysil Params(( void ));
extern	int			zysin Params(( void ));
extern	int			zysio Params(( void ));
extern	int			zysld Params(( void ));
extern	int			zysmm Params(( void ));
extern	int			zysmx Params(( void ));
extern	int			zysou Params(( void ));
extern	int			zyspi Params(( void ));
extern	int			zyspl Params(( void ));
extern	int			zyspp Params(( void ));
extern	int			zyspr Params(( void ));
extern	int			zysrd Params(( void ));
extern	int			zysri Params(( void ));
extern	int			zysrw Params(( void ));
extern	int			zysst Params(( void ));
extern	int			zystm Params(( void ));
extern	int			zystt Params(( void ));
extern	int			zysul Params(( void ));
extern	int			zysxi Params(( void ));

/* prototypes for standard system-level functions used by OSINT */

#if BCC32
/* Borland's header file defines sbrk with an int argument.  We prefer long.
 */
#undef sbrk
#define sbrk sbrkx
#endif

#if _MSC_VER
#undef sbrk
#define sbrk sbrkx
#endif          /* _MSC_VER */

#if AIX
/* Redefine sbrk and brk to use custom routines in sysrs6.c */
#undef sbrk
#undef brk
#define sbrk sbrkx
#define brk  brkx
#endif

#if UNIX
#include <unistd.h>
#define LSEEK lseek

#if LINUX
/* Redefine sbrk and brk to use custom routines in syslinux.c */
#undef sbrk
#undef brk
#define sbrk sbrkx
#define brk  brkx
extern	int 		brkx Params(( void *addr ));
extern	void		*sbrkx Params(( long incr ));
#endif

#else
extern  int         access Params((char *Name, int mode));
extern	int 		brk Params(( void *addr ));
extern	int 		close Params(( File_handle F ));
extern	File_handle	dup Params(( File_handle F ));
extern	char * _Optlink	getenv Params(( char *name ));
#define LSEEK lseek
extern   FILEPOS  LSEEK Params(( File_handle F, FILEPOS Loc, int Method ));
extern	word		read Params(( File_handle F, void *Buf, uword Cnt ));
extern	void		*sbrk Params(( long incr ));
extern	int			unlink Params(( char *Name ));
extern	word		write Params(( File_handle F, void *Buf, uword Cnt ));
#endif

#endif
!@#$st2d.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/* st2d.c - convert integer to decimal string */

#include "port.h"

static int stc_d Params((char *out, unsigned int in, int outlen, int signflag));

static int stc_d(out, in, outlen, signflag)
register char *out;
register unsigned int in;
register int outlen;
int signflag;
{
    char revnum [20];
    register int i=0;
    register char *out0 = out;

    if (outlen<=0) return (0);

    if (in == 0) revnum[i++]=0;
    else
        while (in)
        {
            revnum[i++] = in - (in/10)*10;
            in /= 10;
        }

    if (signflag)
    {
        *out++ = '-';
        outlen--;
    }

    for (; i && outlen; i--, outlen--)
        *out++ = revnum[i-1] + '0';

    *out = '\0';

    return (out-out0);

}


int
stcu_d(out, in, outlen)
char *out;
unsigned int in;
int outlen;
{
    return (stc_d(out, in, outlen, 0));
}
!@#$stubs.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  STUBS.C		Version:  01.02
/	---------------------------------------
/
/	Contents:	Function zysdc
/			Function zysdm
/			Function zystt
*/

/*
/	All functions are "dummy" functions not supported by this
/	implementation.
*/

#include "port.h"

zysdm()
{
    return NORMAL_RETURN;
}


zystt()
{
    return NORMAL_RETURN;
}

!@#$swcinp.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  SWCINP.C		Version:  01.16
/	---------------------------------------
/
/	Contents:	Function swcinp
/
/	Revision history:
/
/	01.16	04-Apr-95 If no end statement after reading source files,
/					  alert user.
/
/ 01.15 18-Oct-90 <withdrawn>
/
/	01.14	23-Jun-90 Function pathlast() moved here from getshell.c
/
/	01.13	11-May-90 Close save_fd0 in restore0() after dup.  Omission
/			was leaving save_fd0 handle busy after each save/restore cycle.
/
/	01.12	Added sfn as a pointer to the source file name currently being read.
/		Used by sysrd to pass file names to the compiler.
/
/	01.11   Moved curfile to osint for reinitialization when compiler serially reused.
/
/	01.10	As a result of using fd 0 to read both source files and
/		keyboard input, the following anomally occurs:
/
/		After reading the END statement of a source file, execution
/		begins with fd 0 connected to that source file (typically
/		positioned at the EOF following the END statement.  When
/		the user's program reads from INPUT, the EOF detected produces
/		a call to swcinp(), and fd 0 is switched from the source file
/		to the "true" standard input.
/
/		However, if prior to the first call to INPUT, the user
/		invokes a shell call, using either EXIT("cmd") or HOST(1,"cmd"),
/		execle() or the shell is invoked with fd 0 still attached to
/		the source file, and will read an end of file on first read.
/		This occurs because reading is outside the domain of
/		Spitbol, and SWCINP is not called.
/
/		Note that a call to INPUT prior to EXIT() or HOST(1,) would
/		mask the problem, because INPUT would switch us away from the
/		source file (assuming an EOF following END).  If there was
/		data following the END statement, things are even worse,
/		because the Shell will start reading data from the source file.
/
/   This problem only occurs on systems using dup().
/
/		To fix the problem, two new routines are used by EXIT("cmd")
/		and SHELL(1,"command") to bracket their operation.
/
/		save0() saves the current fd 0, and restores the original fd 0.
/		restore0() restores the saved fd 0.
/
/	01.09	Recoded so that after receiving EOF from standard input
/		and no more files on the command line, reconnect to stdin
/		if appropriate.  This permits the user to continue to invoke
/		INPUT after obtaining an EOF.  This behavior is consistant
/		with reads from TERMINAL, which will go to keyboard
/		regardless of results of previous read.
/
/		The usage of variables inpateof, no_more_input and proc_sh_fd0
/		is thereby eliminated, and system behavior is consistent
/		with other SNOBOL4 systems.
/
/		If file on command line cannot be opened, exit(1) after
/		issuing error message, rather than continuing.
/
/   For systems that do not support dup(), we leave
/		fd 0 open forever, and read command line files using a
/		non-zero fd.
/
/		Some code rearranged and cleaned up too.  The changes of
/		mod 01.08 are eliminated, having been recast in a
/		different manner.  MBE 12/24/87
/
/	01.08	After receiving EOF from standard input and no more files
/		on the command line, routine would exit with file descriptor
/		0 closed.  If the user subsequently issued a regular INPUT
/		function, osopen would obtain fd 0.  This was wrong in two
/		respects:
/		  1. osopen was testing for a successful open with fd > 0.
/		  2. a subsequent INPUT function specifying ' -f0' should
/		     attach to a file that returns a continuous EOF.
/
/		Solution: when exiting this routine without finding another
/		file for standard input, open "/dev/null" as fd 0.
/		MBE Nov. 9, 1987, per bug report from Kurt Gluck.
/
/	01.07	Every time a filename on the command line is accessed be
/		sure to increment 'cmdcnt' too.
*/

#include "port.h"

#if AIX | LINUX
#include <fcntl.h>
#endif

/*
/   swcinp( filecnt, fileptr )
/
/   swcinp() handles the switching of input files whose concatenation
/   represents standard input.  After all input is exhausted a -1 is
/   returned to indicate EOF.
/
/   If no filenames were specified on the command line, all input is
/   read from file descriptor 0 provided by the shell.
/
/   If filenames were specified on the command line all files are read
/   in their order of appearance.  A filename consisting of a single hyphen
/   '-' represents file descriptor 0 provided by the shell.
/
/   Parameters:
/	filecnt	number of filename specified on command line
/	fileptr	array of pointers to character strings (filenames)
/   Returns:
/	File descriptor to read from (always 0!) or -1 if could not switch
/	to a new file.
*/

int	swcinp( filecnt, fileptr )

int	filecnt;
char	**fileptr;

{
    register char	*cp;
    register int i;

    static int lastfd = 0;


    /*
    /  If first time through, make a duplicate of
    /  shell's file descriptor 0, so that we can access it later.
    */
    sfn = "stdin";

#if USEFD0FD1
    if ( originp < 0 )
        originp = dup( 0 );
#endif

    /*
    /  Process files on command line, if any.
    /  Read file descriptor 0 provided by the shell when a '-'
    /  is encountered as a filename.
    */
    if ( curfile < filecnt )
    {
        /*
        /  Point to next entry.  (Bump cmdcnt too!)
        */
        cmdcnt++;
        cp = fileptr[curfile++];

#if USEFD0FD1
        /*
        /   Close fd 0 so subsequent open or dup will acquire fd 0.
        */
        close(0);
#else
        if (lastfd > 0)
            close(lastfd);				/* if second or subsequent call to swcinp */
#endif
        clrbuf();
        /*
        /   If next entry is '-' then read file descriptor
        /   0 provided by the shell.
        */
        if ( *cp == '-' )
        {
#if USEFD0FD1
            dup( originp );		/* returns 0 */
#endif
            lastfd = 0;
            goto swci_exit;
        }

        /*
        /   Attempt to open file for reading.
        */
        sfn = cp;
        for ( i=0; ; i++ )
        {
            lastfd = -1;
            switch (i)
            {
            case 0:		/* first pass, no alteration */
                if ((lastfd = tryopen(cp)) >= 0 )
                    goto swci_exit;
                break;
#if !RUNTIME
            case 1:		/* try with .spt extension */
                if (!executing && appendext(cp, COMPEXT, namebuf, 0))
                    if ((lastfd = tryopen(namebuf)) >= 0 )
                    {
                        sfn = namebuf;
                        goto swci_exit;
                    }
                break;
#endif					/* !RUNTIME */

#if SAVEFILE
            case 2:		/* try with .spx extension */
                if (!executing && curfile == 1 && appendext(cp, RUNEXT, namebuf, 0))
                    if ((lastfd = tryopen(namebuf)) >= 0 )
                    {
                        sfn = namebuf;
                        goto swci_exit;
                    }
                break;
#endif					/* SAVEFILE */
            case 3:
                /*
                /   Error opening file, so issue a message and exit
                */
                write( STDERRFD, "Can't open ", 11 );
                write( STDERRFD, cp, length(cp) );
                wrterr( "" );
                __exit(1);
            }
        }
    }
    else
        lastfd = -1;		/* ATTEMPT TO FIX PIPE BUG FOR COPPEN 10-FEB-95 */

#if USEFD0FD1
    sfn = "stdin";

    if ( readshell0 )
    {
        if (!executing && filecnt)
        {
            wrterr( "No END statement found in source file(s)." );   /* V1.16 */
            __exit(1);
        }
        close(0);
        clrbuf();
        dup( originp );			/* returns 0 */
        readshell0 = 0;			/* only do this once */
        lastfd = 0;
    }

#endif					/* !USEFD0FD1 */
    /*
    /  Control comes here after all files specified on the command line
    /  have been read.
    /
    /  FD 0 remains attached to the last file that returned an EOF, and
    /  should continue to return EOFs.
    */
swci_exit:
#if !USEFD0FD1
    setrdfd(lastfd);
#endif
    return lastfd;
}




/*
/	Save the current fd 0, and connect fd 0 to the original one.
/	Used before EXIT("cmd") and HOST(1,"cmd")
/
*/
void save0()
{
#if USEFD0FD1
    if ((save_fd0 = dup( 0 )) >= 0) {
        close( 0 );
        clrbuf();
        dup( originp );
    }
#endif					/* USEFD0FD1 */
}





/*
/	Restore the saved fd 0.
/	Used after EXIT("cmd") and HOST(1,"cmd")
/
*/
void restore0()
{
#if USEFD0FD1
    if (save_fd0 >= 0) {
        close( 0 );
        clrbuf();
        dup( save_fd0 );
        close( save_fd0 );	 	/* 1.13 for HOST(1,"cmd") */
    }
#endif					/* USEFD0FD1 */
}




/*
/   tryopen - try to open file for swcinp.
/   returns -1 if fails, else file descriptor >= 0
*/
int tryopen(cp)
char *cp;
{
    int fd;
    if ( (fd = spit_open( cp, O_RDONLY, IO_PRIVATE | IO_DENY_WRITE,
                          IO_OPEN_IF_EXISTS )) >= 0 )
    {
        return fd;
    }
    return -1;
}





/*
/   pathlast()
/
/   Function pathlast returns the a pointer to the last component of a
/   path.
/
/   Parameters:
/	Pointer to path character string
/   Returns:
/	Pointer to last component in path character
*/


char *pathlast( path )

char	*path;

{
    char	*cp, c;
    int		len;

    /*
    /	Scan the path from right-to-left looking for a slash.  Stop when
    /	the front of the path is reached.
    */
    len = length(path);
    cp = path + len;

    /*
    /	Loop either terminated by finding a slash or hitting the front
    /	of the path.  If found a slash, the last component starts one
    /	position to the right.
    */
    while( len--)
    {
        c = *--cp;
        if (c == FSEP
           )
        {
            ++cp;
            break;
        }
    }
    return cp;
}

#if !(RUNTIME)
/*
 *  appendext - append extension to pathname if possible.
 *
 *	Parameters:
 *	   path	  - path name to append to.
 *	   ext    - extension to append
 *	   result - result buffer
 *	   force  - 1 for replace existing extension, if any, 0 to fail if
 *		    extension already present on path.
 * 	Returns:
 *	   >0  - Success, length of name
 *	   0   - Failure
 */
int appendext(path, ext, result, force)
char *path, *ext, *result;
int  force;
{
    register char *p, *q, *r;

    p = result;
    q = pathlast(path);
    r = (char *) 0;
    do {
        if (path >= q && *path == EXT)
            r = p;
    } while ((*p++ = *path++) != 0);

    p--;
    if ( r != (char *) 0)
    {
        if ( force )
            p = r;					/* copy over old extension */
        else
            return 0;				/* no force but extension present */
    }

    p = mystrcpy(p, ext);
    return p - result;
}
#endif          /* !(RUNTIME) */

/*
 * mystrcpy(p,q)  - copy string q to string p.  Return pointer to '\0' in p;
 *
 * Note that this definition is NOT the same as standard strcpy.
 */
char *mystrcpy(p, q)
register char *p, *q;
{
    while ( (*p++ = *q++) != 0 )
        ;
    return p - 1;
}


/*
/	Return length of string argument.
/	Identical to C strlen function.
*/
int length(cp)
char *cp;
{
    register char *p = cp;
    while (*p++)
        ;
    return p - cp - 1;
}


int mystrncpy( p, q, i)
register char *p, *q;
int i;
{
    register int j = i;
    while (j--)
        *p++ = *q++;
    return i;
}

!@#$swcoup.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  SWCOUP.C		Version:  01.03
/	---------------------------------------
/
/	Contents:	Function swcoup
/
/	Revision History:
/
/	01.01	14-Jul-88
/			Moved errflag to osint.c so that it can be reinitialized as necessary.
/
/	01.02	12-Sep-89
/			Defaulted list file extension to .lst
/
/	01.03	24-Oct-89
/			File name '-' means file descriptor 1.
*/

#include "port.h"

#if AIX | LINUX
#include <fcntl.h>
#endif

/*
/   swcoup( oupptr )
/
/   swcoup() switches between two output files:  the standard output file
/   provided by the shell and the optional output file provided by the
/   -o option on the command line.
/
/   This switching is necessary so that we blend into the Un*x environment
/   like other programs.  To this end output is routed to the appropriate
/   output file:
/
/	program listing, compilation statisitics, execution statistics,
/	and dump of variables at termination go to the -o file, if
/	specified.
/
/	standard output produced by the executing program goes to the
/	standard output file provided by the shell.
/
/   This routing insures that the ONLY standard output produced by the
/   "spitbol" command is that generated by the spitbol program being
/   executed!  Thus, spitbol can be used as a filter.
/
/
/   There are three calls to swcoup() as described by this sequence of events
/
/	   spitbol initialization
/	0->swcoup() called prior to compilation
/	   compilation (with output routed to -o file)
/	1->swcoup() called after compilation and prior to execution
/          (with output routed to shell's standard output)
/	2->swcoup() called after execution
/	   post mortem activities (with output routed to -o file)
/
/
/   A filename consisting of a single hyphen '-' represents file
/   descriptor 1 provided by the shell.
/
/   Parameters:
/	oupptr	pointer to -o option argument from command line
/   Returns:
/	0 if switch successful / -1 if switch failed
*/

int swcoup( oupptr )
char  *oupptr;

{
    int	retval = 0;

    /*
    /   No switch necessary if no -o option or previous errors encountered.
    */
    char namebuf[256];

    if (errflag)
        return 0;

    /* if no output file specified, but listing requested, use input name */
    if ( oupptr == 0)
    {
        if (((spitflag & NOLIST) == 0) && (**inpptr))
        {
            appendext(*inpptr, LISTEXT, namebuf, 1);
            oupptr = namebuf;
        }
        else
            goto swcexit;
    }

    /*
    /   If -o file name is '-' then continue to write file
    /   descriptor 1 provided by the shell.
    */
    if ( *oupptr == '-' && *(oupptr + 1) == '\0')
        goto swcexit;

    /*
    /   Do output file switch based on current state:
    */
    switch ( oupState++ )
    {

        /*
        /	State 0 (1st call to swcoup):  standard output -> -o file
        */
    case 0:
#if USEFD0FD1
        origoup = dup( 1 );		/* save std output	*/
        close( 1 );				/* close std output	*/
        if (appendext(oupptr, LISTEXT, namebuf, 0))	/* Append .lst if needed */
            oupptr = namebuf;
        if ( (spit_open( oupptr, O_WRONLY|O_CREAT|O_TRUNC,
                         IO_PRIVATE | IO_DENY_READWRITE /* 0666 */,
                         IO_REPLACE_IF_EXISTS | IO_CREATE_IF_NOT_EXIST )) < 0 ) /* create -o file */
        {
            wrterr( "-o file open error." );
            ++errflag;
            dup( origoup );
            close( origoup );
            retval = -1;
        }
#else					/* USEFD0FD1 */
        setprfd( origoup );
#endif					/* USEFD0FD1 */

        break;

        /*
        /	State 1 (2nd call to swcoup):  standard output -> shell output file
        */
    case 1:
#if USEFD0FD1
        close( 1 );				/* close -o file	*/
        dup( origoup );			/* restore std output	*/
        close( origoup );		/* close its duplicate	*/
#else					/* USEFD0FD1 */
        setprfd( 1 );			/* switch to fd 1, leave list file open */
#endif					/* USEFD0FD1 */
        break;

        /*
        /	State 2 (3rd call to swcoup):  standard output -> -o file
        */
    case 2:
#if USEFD0FD1
        close( 1 );				/* close std output	*/
        if (appendext(oupptr, LISTEXT, namebuf, 0))	/* Append .lst if needed */
            oupptr = namebuf;
        if ( (spit_open( oupptr,O_WRONLY,
                         IO_PRIVATE | IO_DENY_READWRITE /* 0666 */,
                         IO_OPEN_IF_EXISTS )) < 0 ) /* reopen -o file	*/
        {
            wrterr( "error reopening" );
        }
        oupeof();				/* seek to EOF on -o file */
#else					/* USEFD0FD1 */
        setprfd( origoup );		/* resume -o file	*/
#endif					/* USEFD0FD1 */

        break;

    default:
#if USEQUIT
        quit(354);
#else					/* USEQUIT */
        wrterr( "Internal system error--SWCOUP" );
#endif					/* USEQUIT */

    }

swcexit:
#if HOST386
    if ( coutdev( 1 ) == 0 )		/* Test for character output */
        getpriob()->flg1 |= IO_COT;
    else
        getpriob()->flg1 &= ~IO_COT;
#endif					/* HOST386 */

    return	retval;
}
!@#$sysax.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  SYSAX.C		Version:  01.01
/	---------------------------------------
/
/	Contents:	Function zysax
*/

/*
/
/	zysax - after execution cleanup
/
/	Here we just indicate that further output should go to the
/	compiler output file, as opposed to stdout from executing program.
/
/	Parameters:
/	    None
/	Returns:
/	    Nothing
/	Exits:
/	    None
*/

#include "port.h"

zysax()
{
    /*  swcoup does real work  */
    swcoup( outptr );
    return NORMAL_RETURN;
}
!@#$sysbs.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  SYSBS.C		Version:  01.02
/	---------------------------------------
/
/	Contents:	Function zysbs
*/

/*
/	zysbs - backspace file
/
/	zysbs move a file's position back one physical record.
/
/	Parameters:
/	    WA - FCBLK pointer or 0
/	    XR - SCBLK pointer (EJECT argument)
/	Returns:
/	    Nothing
/	Exits:
/	    1 - file does not exist
/	    2 - inappropriate file
/	    3 - i/o error
/
/ History:
/ v01.00	16-Feb-91	Initial version.
/ v01.01	01-Feb-93	Adjust for fcb->rsz now positive for raw mode.
/ v01.02	07-Jun-95	Disallow backspace if file is a pipe.
/
*/

#include "port.h"

static int back Params((struct ioblk *iob));

#define RET_BIAS 100

zysbs()
{
    register int c;
    register struct fcblk *fcb = WA(struct fcblk *);
    register struct ioblk *iob = MK_MP(fcb->iob, struct ioblk *);

    /* ensure the file is open */
    if ( !(iob->flg1 & IO_OPN) )
        return EXIT_1;

    if (!testty(iob->fdn)
#if PIPES
            || iob->flg2 & IO_PIP				/* not allowed on pipes */
#endif
       )
        return EXIT_2;						/* character device */

    if (fcb->mode) {						/* if line mode */

        /*
         * If the characters immediately preceding the current position
         * are end-of-line characters, ignore them before starting scan
         * for beginning of record.
         */
        if ((c = back(iob)) < 0)
            return c + RET_BIAS;			/* beginning of file */
#if EOL2
        if (c == EOL2)
            if ((c = back(iob)) < 0)
                return c + RET_BIAS;
#endif					/* EOL2 */
        if (c == EOL1)
            if ((c = back(iob)) < 0)
                return c + RET_BIAS;

        /*
         * Here with c containing the first character of the record
         * we should examine.
         */
        do {
#if EOL2
            if (c == EOL2)
                break;
#endif					/* EOL2 */
            if (c == EOL1)
                break;
        } while ((c = back(iob)) >= 0);

        if (c >= 0)
            doset(iob, 1L, 1);				/* advance past EOL char */
        else
            return c + RET_BIAS;
    }

    else {									/* if raw mode */
        if (doset(iob, -fcb->rsz, 1) < 0L)	/* just move back record length */
            return EXIT_1;					/* I/O error */
    }

    return NORMAL_RETURN;
}


/*
 * BACK - helper function to backup one position in file.
 *
 * returns character found at that position, or NORMAL_RETURN-RET_BIAS
 * if at beginning of file, or EXIT_3-RET_BIAS if I/O error.
 * Non-character returns are guaranteed to be negative.
 */
static int back(ioptr)
struct ioblk *ioptr;
{
    register struct bfblk *bfptr = MK_MP(ioptr->bfb, struct bfblk *);
    unsigned char c;

    while (bfptr) {							/* if file is buffered */
        if (bfptr->next)
            return (unsigned int)(unsigned char)bfptr->buf[--bfptr->next];
        if (!bfptr->offset)					/* if at beginning of file */
            return NORMAL_RETURN-RET_BIAS;
        if (doset(ioptr, -1L, 1) < 0L)		/* seek back one position */
            return EXIT_3-RET_BIAS;			/* if I/O error */
        bfptr->next++;						/* setup to return character */
    }

    /* Unbuffered file.  Use disgusting code */
    if (!doset(ioptr, 0L, 1))
        return NORMAL_RETURN-RET_BIAS;
    if (doset(ioptr, -1L, 1) < 0L ||
            read(ioptr->fdn, &c, 1) != 1)
        return EXIT_3-RET_BIAS;				/* if I/O error */
    doset(ioptr, -1L, 1);
    return (unsigned int)c;
}
!@#$sysbx.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  SYSBX.C		Version:  01.06
/	---------------------------------------
/
/	Contents:	Function zysbx
*/

/*
/	zysbx - before execution setup
/
/	Setup here so that all further "standard output" goes to stdout.
/	This allows us to separate compiler/interpreter generated output
/	from output generated by the executing program.
/
/	If the -w command line option has been invoked, this module will
/	write an executable module and terminate.
/
/	If the -y command line option has been invoked, this module will
/	write a save (.spx) file and terminate.

/	Parameters:
/	    None
/	Returns:
/	    Nothing
/	Exits:
/	    None
/
/   V1.07   02/03/97 - call swcinp to close input file
/
/   V1.06   05/12/92 - Remove nameblk.  Use TSCBLK instead.
/
/	V1.05	10/20/89 - Distinguish -w and -y options
/
/	V1.04   09/14/89 - Use input file name with RUNEXT extension
/			   for file name with -y option.
*/

#include "port.h"

zysbx()
{
#if !RUNTIME

    executing = 1;

    if (readshell0) {
        doset(getrdiob(), 0L, 2); /* bypass rest of source file */
        curfile = inpcnt;	  /* skip rest of cmd line files */
        swcinp( inpcnt, inpptr ); /* v1.07 switch away from source file */
    }

#if EXECFILE
    /*
    /   do we need to write an executable module, and if
    /   so does writing it produce an error?
    */
    if ( spitflag & WRTEXE)
    {
        pTSCBLK->len = appendext( *inpptr, BINEXT, pTSCBLK->str, 1 );

        if ( makeexec( pTSCBLK, spitflag & NOEXEC ? 3 : 4 ) )
        {
            wrterr( "Error writing load module." );
            zysej();
        }
    }
#endif					/* EXECFILE */

#if SAVEFILE
    /*
    /   do we need to write a save (.spx) file, and if
    /   so does writing it produce an error?
    */
    if ( spitflag & WRTSAV)
    {
        pTSCBLK->len = appendext( *inpptr, RUNEXT, pTSCBLK->str, 1 );
        if ( makeexec( pTSCBLK, spitflag & NOEXEC ? -3 : -4 ) )
        {
#if USEQUIT
            quit(357);
#else					/* USEQUIT */
            wrterr( "Error writing save file." );
            zysej();
#endif					/* USEQUIT */
        }
    }
    /*
    /   Execution does not resume here for dirty load modules.
    /   Because we must allow for new versions with different
    /   size C code, the stacked return addresses are not valid.
    /   Therefore, inter.asm forces a jump to restart code that
    /   eventually jumps to the MINIMAL code following the call
    /   the sysbx call.
    /
    / ***********************************************************
    / * WE DO NOT RETURN HERE.  ANY NEW CODE ADDED HERE MUST BE *
    / * DUPLICATED IN THE RESTART CODE                          *
    / ***********************************************************
    */
#endif					/* SAVEFILE */

    /*  execution resumes here when a.out file created with		*/
    /*  the -w option is reloaded.					*/

    startbrk();			/* turn on Control-C checking */

    /*  swcoup does real work  */
    swcoup( outptr );

#else         /* !RUNTIME */
    __exit(1);
#endif					/* !RUNTIME */

    return NORMAL_RETURN;
}
!@#$syscm.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  SYSCM.C		Version:  01.01
/	---------------------------------------
/
/	zyscm - string compare
/
/	V1.01	Don't bother clearing XR.
/		Change definition of first/second string.
*/

/*
/
/	zyscm is called to make either a strict ASCII or INTERNATIONAL comparison.
/
/	This external routine is provided to allow conditional access to
/	an alternate collation sequence.  Access is
/	controlled by the global switch IUSTRG.
/
/	Parameters:
/		XR - pointer to first string
/		WB - first string length
/		XL - pointer to second string
/		WA - second string length
/	Returns
/		XL = 0
/	Exits:
/		1 - string length exceeded capability of international comparison routine
/		2 - 2nd string < 1st string
/		3 - 2nd string > 1st string
/		normal exit - strings equal
/
*/

#include "port.h"
#if ALTCOMP
long *kvcom_ptr;

zyscm()
{
    register word result;

    if (!kvcom_ptr)							/* Cheap optimization to speed up */
        kvcom_ptr = GET_DATA_OFFSET(KVCOM,long *);	/* &COMPARE consultation */

    result = gencmp(XL(char *), XR(char *), WA(word), WB(word), *kvcom_ptr);

    SET_XL(0);

    if (result == 0x80000000)
        return EXIT_1;
    else if (result == 0)
        return NORMAL_RETURN;
    else if (result < 0)
        return EXIT_2;
    else
        return EXIT_3;
}
#endif					/* ALTCOMP */
!@#$sysdc.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	zysdc - check system expiration date
/
/	zysdc prints any header messages and may check
/	the date to see if execution is allowed to proceed.
/
/	Parameters:
/	    Nothing
/	Returns
/	    Nothing
/	    No return if execution not permitted
/
*/

#include "port.h"

zysdc()
{
    struct scblk *pHEADV = GET_DATA_OFFSET(HEADV,struct scblk *);
	return;
    /* announce name and copyright */
    if (!dcdone && !(spitflag & NOBRAG))
    {
        dcdone = 1;				/* Only do once per run */

        write( STDERRFD, "LINUX SPITBOL", 13);

#if RUNTIME
        write( STDERRFD, " Runtime", 8);
#endif					/* RUNTIME */

        write( STDERRFD, "  Release ", 10);
        write( STDERRFD, pHEADV->str, pHEADV->len );
        write( STDERRFD, pID1->str, pID1->len );
        wrterr( cprtmsg );
    }

#if DATECHECK
#endif
    return NORMAL_RETURN;
}
!@#$sysdt.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  SYSDT.C		Version:  01.06
/	---------------------------------------
/
/	Contents:	Function zysdt
/			Function conv
*/

/*
/	zysdt - get current date
/
/	zysdt is called when executing a Spitbol date function.
/
/	Parameters:
/       XR - optional integer argument describing date format desired
/	Returns:
/	    XL - pointer to SCBLK containing date string
/	Exits:
/	    None
*/

#include "port.h"
#include <time.h>

static int datecvt Params(( char *cp, int type ));
static int timeconv Params(( char *tp, struct tm *tm ));

/* conv() rewritten to avoid dependence on library remainder routine */
void conv (dest, value)

register char *dest;
register int value;

{
    register short int i;
    i = value / 10;
    dest[0] = i + '0';
    dest[1] = value - i*10 + '0';
}

zysdt()
{
    struct icblk *dtscb = XR (struct icblk *);

    pTSCBLK->len = datecvt( pTSCBLK->str, dtscb->val );
    SET_XL( pTSCBLK );
    return NORMAL_RETURN;
}

/*
 * Write date/time in SPITBOL form to a string
 */
int storedate( cp, maxlen )
char	*cp;
word	maxlen;
{
    if (maxlen < 18)
        return 0;

    return datecvt(cp, 0);
}

/*
 * Write date/time in several different forms to a string
 */
int datecvt( cp, type )
char	*cp;
int     type;
{

    time_t      tod;

    register struct tm *tm;
    tm = localtime( &tod );

    switch (type)
    {
    default:
    case 0:     /* "MM/DD/YY hh:mm:ss" */
        conv( cp, tm->tm_mon+1 );
        cp[2] = '/';
        conv( cp+3, tm->tm_mday );
        cp[5] = '/';
        conv( cp+6, tm->tm_year % 100 );    /* Prepare for year 2000! */
        return 8 + timeconv(&cp[8], tm);

    case 1:     /* "MM/DD/YYYY hh:mm:ss" */
        conv( cp, tm->tm_mon+1 );
        cp[2] = '/';
        conv( cp+3, tm->tm_mday );
        cp[5] = '/';
        conv( cp+6, (tm->tm_year + 1900) / 100 );
        conv( cp+8, tm->tm_year % 100 );    /* Prepare for year 2000! */
        return 10 + timeconv(&cp[10], tm);

    case 2:     /* "YYYY-MM-DD/YYYY hh:mm:ss" */
        conv( cp+0, (tm->tm_year + 1900) / 100 );
        conv( cp+2, tm->tm_year % 100 );    /* Prepare for year 2000! */
        cp[4] = '-';
        conv( cp+5, tm->tm_mon+1 );
        cp[7] = '-';
        conv( cp+8, tm->tm_mday );
        return 10 + timeconv(&cp[10], tm);
    }
}

static int timeconv( tp, tm)
char *tp;
struct tm *tm;
{
    tp[0] = ' ';
    conv( tp+1, tm->tm_hour );
    tp[3] = ':';
    conv( tp+4, tm->tm_min );
    tp[6] = ':';
    conv( tp+7, tm->tm_sec );
    *(tp+9) = '\0';
    return 9;
}

!@#$sysea.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  SYSEA.C		Version:  01.00
/	---------------------------------------
/
/	Contents:	Function zysea
*/

/*
/
/	zysea - error advise
/
/	Here we catch errors before they are printed.
/
/	Parameters:
/	    XR - Error stage
/			if XR = STGIC, STGCE, STGXT then
/				WA - error number (1-330)
/				WB - column number
/				WC - line number
/				XL - scblk containing source file name
/	Returns:
/	    XR - SCBLK of message to print, or 0 if none
/	Exits:
/	    1 - suppress printing of error message
/
/  1.30.20 3/18/2000 - fix bug displaying column number - 1
*/

#include "port.h"

static char *eacpy Params((char *s1, char *s2, int n));

static char *eacpy(s1, s2, n)
char *s1, *s2;
int n;
{
    char *s0 = s1+n;

    while (n--)
        *s1++ = *s2++;
    return s0;
}

/*
 * Error stage states
 */
enum stage {
    STGIC=0,			/* Initial compile				*/
    STGXC,				/* Execution compile (CODE)			*/
    STGEV,				/* Expression eval during execution		*/
    STGXT,				/* Execution time				*/
    STGCE,				/* Initial compile after scanning END line	*/
    STGXE,				/* Execute time compile after scanning END line	*/
    STGEE,				/* EVAL evaluating expression			*/
    STGNO				/* Number of codes				*/
};

zysea()
{
    register struct scblk *fnscblk = XL(struct scblk *);
    register char *p;


    /* Display file name if present */
    if (fnscblk->len) {
        p = pTSCBLK->str;
        p = eacpy(p, fnscblk->str, (int)fnscblk->len);
        /* Display line number if present */
        if (WC(unsigned int)) {
            *p++ = '(';
            p += stcu_d(p, WC(unsigned int), 16);
            /* Display character position if present */
            if (WB(unsigned int)) {
                *p++ = ',';
                p += stcu_d(p, WB(unsigned int)+1, 16);
            }
            *p++ = ')';
        }
        p = eacpy(p, " : ", 3);
        pTSCBLK->len = p - pTSCBLK->str;
        SET_XR( pTSCBLK );
        return NORMAL_RETURN;
    }
    SET_XR(0L);
    return NORMAL_RETURN;	/* Other errors be processed normally */
}

!@#$sysef.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  SYSEF.C		Version:  01.02
/	---------------------------------------
/
/	Contents:	Function zysef
*/

/*
/	zysef - eject file
/
/	zysef writes an eject (form-feed) to a file.
/
/	Parameters:
/	    WA - FCBLK pointer or 0
/	    XR - SCBLK pointer (EJECT argument)
/	Returns:
/	    Nothing
/	Exits:
/	    1 - file does not exist
/	    2 - inappropriate file
/	    3 - i/o error
/
/	v1.02 1-Feb-93 Change oswrite calling sequence.
*/

#include "port.h"

/*
/	ffscblk is one of the few SCBLKs that can be directly allocated
/	using a C struct!
*/
static struct scblk	ffscblk =
{
    0,		/*  type word - ignore		*/
    1,		/*  string length		*/
    '\f'	/*  string is a form-feed	*/
};

zysef()
{
    register struct fcblk *fcb = WA(struct fcblk *);
    register struct ioblk *iob = MK_MP(fcb->iob, struct ioblk *);

    /* ensure the file is open */
    if ( !(iob->flg1 & IO_OPN) )
        return EXIT_1;

    /* write the data, fail if unsuccessful */
    if ( oswrite( fcb->mode, fcb->rsz, ffscblk.len, iob, &ffscblk) != 0 )
        return EXIT_2;

    return NORMAL_RETURN;
}
!@#$sysej.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  SYSEJ.C		Version:  01.04
/	---------------------------------------
/
/	Contents:	Function zysej
*/

/*
/	zysej - end job
/
/	zysej is called to terminate spitbol's execution.  Any open files
/	will be closed before calling __exit.
/
/	Parameters:
/	    WA - value of &ABEND keyword (always 0)
/	    WB - value of &CODE keyword
/	    XL - pointer to FCBLK chain
/	Returns:
/	    NO RETURN
/
/	HISTORY
/
/  V1.04 MBE 07-Aug-90  Avoid using heap data structures if aborted in
/				the middle of a garbage collection.
/
/  V1.03 MBE 27-Nov-89	Call termhost() if 80386 version to clear any
/		        funny modes from screen host functions.
/
/  V1.02 MBE 14-Dec-87	Make file closing loop into function for access from
/			sysxi.c.
*/

#include "port.h"

#if EXTFUN
unsigned char FAR *bufp;
#endif					/* EXTFUN */


/*
/  close_all - Close all files.
/
/  Parameters:
/	chfcb	pointer to FCBLK chain or 0
/  Returns:
/	Nothing
/  Side Effects:
/	All files on the chain are closed and buffers flushed.
*/

void close_all(chb)

register struct chfcb *chb;

{
    while( chb != 0 )
    {
        osclose( MK_MP(MK_MP(chb->fcp, struct fcblk *)->iob, struct ioblk *) );
        chb = MK_MP(chb->nxt, struct chfcb *);
    }
}



void zysej()
{
#if HOST386
    termhost();
#endif					/* HOST386 */

    if (!in_gbcol) {		/* Only if not mid-garbage collection */
        close_all( XL( struct chfcb * ) );

#if EXTFUN
        scanef();					/* prepare to scan for external functions */
        while (nextef(&bufp, 1))	/* perform closing callback to some		  */
            ;
#endif					/* EXTFUN */

    }
    /*
    /	Pass &CODE to function __exit.  Don't call standard exit function,
    /	because of its association with the stdio package.
    */
    __exit( WB(int) );

}

!@#$sysem.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  SYSEM.C		Version:  2.01
/	---------------------------------------
/
/	Contents:	Function zysem
*/

/*
/	zysem - get error message text
/
/	zysem returns the error message associated with an error number.
/
/	An assembly language file, errors.s contains a compressed form
/	of the error messages.  On the Macintosh, error messages are
/	in the resource fork of the application, uncompressed.  This
/	allows the user to easily translate them into any language.
/
/	Error messages are compressed into two character arrays.  Segments
/	within these arrays are delineated by \0 characters.  To find the
/	Nth segment, it is necessary to scan the array for the Nth \0.  The
/	segment begins at the next character position.
/
/	The first array, errors, contains 330 segments for the primary
/	error messages.  Within a segment, there are ascii characters
/	in the range 32-127, which are taken verbatim, and character
/	values 1-31 and 128-255, which are special characters.
/
/	The special characters are mapped into the range [1-159], where
/	they index segments in the second array, phrases.  Segments within
/	phrases follow the same rules as those within arrays, and may
/	contain special characters themself.
/
/	This expansion code is by necessity recursive.  This code and
/	the data within errors.s were coded for minimum space, not speed,
/	since it is used infrequently.
/
/	Parameters:
/	    WA - error number
/	Returns:
/	    XR - pointer to SCBLK containing error message (null string is ok)
/	Exits:
/	    None
/
/   V2.01 23-Dec-91
/		Add ERRDIST to allow the errors and phrases arrays to be
/       accessed as FAR pointers for those systems that point to them
/		in another segment.
*/

#include "port.h"

extern unsigned char ERRDIST errors[];
extern unsigned char ERRDIST phrases[];
word msgcopy Params((word n, unsigned char ERRDIST *source, char *dest ));
word special Params((word c));

zysem()
{
    pTSCBLK->len = msgcopy( WA(word), errors, pTSCBLK->str );
    SET_XR( pTSCBLK );
    return NORMAL_RETURN;
}

/*
/	special(c)
/
/	Return 0 if argument character is normal ascii.
/	Return index to phrase array if c is a special character.
*/
word special(c)
word c;
{
    if ( c == 0 )
        return 0;
    if ( c < 32 )
        return c;
    if ( c < 128 )
        return 0;
    return (c - 96);
}

/*
/	msgcopy(n, source, dest)
/
/	msgcopy() locates segment n in the source array, and copies its
/	characters to the destination array.  If any special characters
/	are encountered, msgcopy() is called recursively to expand them.
/
/	The function returns the number of characters copied.
*/

word msgcopy(n, source, dest )
word	n;
unsigned char ERRDIST *source;
char		*dest;
{
    word 	k;
    unsigned char	c;
    char		*dstart;

    /*
    /   Save starting destination pointer
    */
    dstart = dest;

    /*
    /   Scan to first character of Nth string
    */
    for ( ; n--; )
    {
        for ( ; *source++; )
            ;
    }

    /*
    /   Examine next character of string.
    /	If it is a special character, recurse to unpack it
    /	   from phrases array.
    /	If normal character, just copy it.
    */
    for ( ; (c = *source++) != 0; )
    {
        if ( (k = special(c)) != 0 )
            dest += msgcopy( k, phrases, dest );
        else
            *dest++ = c;
    }

    /*
    /   Return number of characters transferred.
    */
    return dest - dstart;
}

!@#$sysen.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  SYSEN.C		Version:  01.02
/	---------------------------------------
/
/	Contents:	Function zysen
*/

/*
/	zysen - endfile
/
/	endfile is an artifact from the FORTRAN days and is supposed to
/	close a file.  However, the file may be reopened, etc.  We just
/	close it.
/
/	Parameters:
/	    WA - FCBLK pointer or 0
/	    XR - SCBLK pointer (ENDFILE argument)
/	Returns:
/	    Nothing
/	Exits:
/	    1 - file does not exist
/	    2 - inappropriate file
/	    3 - i/o error
/
/	V1.02 29-Mar-91	Check for error after calling osclose().
*/

#include "port.h"

zysen()
{
    register struct fcblk *fcb = WA (struct fcblk *);
    register struct ioblk *iob = MK_MP(fcb->iob, struct ioblk *);

    /* ensure the file is open */
    if ( !(iob->flg1 & IO_OPN) )
        return EXIT_1;

    /* now close it */
    if (osclose( iob ))
        return EXIT_3;

    return NORMAL_RETURN;
}
!@#$sysep.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  SYSEP.C		Version:  01.01
/	---------------------------------------
/
/	Contents:	Function zysep
*/

/*
/	zysep - eject printer (standard output)
/
/	zysep writes an eject to the standard output.
/
/	Parameters:
/	    None
/	Returns:
/	    Nothing
/	Exits:
/	    None
*/

#include "port.h"

zysep()
{
    write( 1, "\f", 1 );
    return NORMAL_RETURN;
}

!@#$sysex.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  SYSEX.C		Version:  01.01
/	---------------------------------------
/
/	Contents:	Function zysex
/
*/

/*
/	zysex - call external function
/
/	Parameters:
/	    XS - pointer to arguments
/	    XL - pointer to EFBLK
/	    WA - number of arguments
/	Returns:
/	    XR - result
/	Exits:
/	    1 - call fails
/	    2 - insufficient memory or function not found
/	    3 - improper argument type
/
/   WARNING!  THIS FUNCTION MAY CAUSE STORAGE ALLOCATION WHEN SAVING
/	THE RETURNED VALUE FROM THE EXTERNAL FUNCTION.  THAT ALLOCATION MAY
/	CAUSE A GARBAGE COLLECTION, THEREFORE IT IS IMPERATIVE THAT THE STACK
/	BE CLEAN, COLLECTABLE, AND WORD ALIGNED.
/
/  v1.01 11/25/90 Add exit 2 - insufficient memory, exit 3 - improper argument.
/
*/

#include "port.h"

zysex()
{
#if EXTFUN
    struct efblk *efb = XL(struct efblk *);
    word nargs = WA(word);
    union block *result = 0;		/* initialize so collectable */

    /* Bypass return word in second argument to callef */
    result = callef(efb, MK_MP(MP_OFF(XS(union block **),word)
                               + sizeof(word),union block **), nargs);
    switch ((word)result) {
    case (word)0:
        return EXIT_1;			/* fail */
    case (word)-1:
        return EXIT_2;			/* insufficient memory */
    case (word)-2:
        return EXIT_3;			/* improper argument */
    default:
        SET_XR(result);
        return NORMAL_RETURN;	/* Success, return pointer to stuff in EFBLK */
    }
#else					/* EXTFUN */
    return EXIT_1;
#endif					/* EXTFUN */
}
!@#$sysfc.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/ File:  SYSFC.C    Version:  01.04
/	---------------------------------------
/
/	Contents:	Function zysfc
*/

/*
/   zysfc - setup file control block
/
/   This is sort of a messy function that determines from the I/O association
/   arguments, what type of I/O is to be done and which i/o control blocks
/   are needed.  There are a number of possiblities:
/
/   For the first call to zysfc that establishes an i/o channel, allocate:
/	fcblk & ioblk & bfblk
/
/   For a second, third, ... call to zysfc that establishes a different type
/   of access to an existing i/o association, allocate:
/	fcblk
/
/   For a second, third, ... call to zysfc that does specify any arguments,
/   allocate:
/	nothing, use existing fcblk
/
/   Notice that of the three blocks that are allocated, only the BFBLK
/   has a varying size;  its size depends on the buffer size specified
/   as an I/O argument.
/
/   Parameters:
/	xl	pointer to scblk holding filearg1 (channel id)
/	xr	pointer to scblk holding filearg2 (filename & args)
/	wa	pointer to existing fcblk or 0
/	wb	0/3 for input/output association
/	wc	number of scblk pointers on stack (forced to zero by interface)
/   Returns:
/	wa = xl = 0	Nothing to allocate
/	wa > 0		Size of requested fcblk
/	wa = 0, xl > 0	Private fcblk pointer in xl
/	wc		0/1/2 for xrblk/xnblk/static allocation request
/
/   Exits:
/	1	invalid file argument
/ 2 channel already in use
/
/	1.03	If called first time with null filearg2, lookup filearg1
/		in environment block, and use filename specified there
/		instead.
/
/ 1.04  If called with filename or file descriptor and channel is
/   already in use, take new exit number 2.
/
*/

#include "port.h"

struct ioblk	tioblk;			/* temporary ioblk		*/

zysfc()
{
    int	fd_spec, i;
    word	allocsize, length_fname;
    register struct scblk *scb1 = XL( struct scblk * );
    register struct scblk *scb2 = XR( struct scblk * );
    register struct fcblk *fcb  = WA( struct fcblk * );
    word use_env = 0;   /* Initially, flag that not using environment block */

    /*
    /   Bad filearg2 or NULL filearg1 is an error
    */
again:
    if ( (length_fname = lenfnm( scb2 )) < 0  ||  !scb1->len )
        return  EXIT_1;

    /*
    /   Scan out I/O arguments and build temporary ioblk.
    */
    if ( sioarg( WB(int), &tioblk, scb2 ) < 0 )
        return  EXIT_1;

    /*
    /   If previous I/O association on this channel, be sure that type
    /   of access is consistent with current call.  I.e., both are
    /   input or both are output.  An illegal association is marked
    /   with the IO_ILL flag and SYSIO does the error return.
    */
    if ( fcb )
    {
        i = MK_MP(fcb->iob, struct ioblk *)->flg1 & (IO_INP | IO_OUP);
        if ( !(tioblk.flg1 & i) )
            tioblk.flg2 |= IO_ILL;
    }

    /*
    /   Processing now is dependent on how filename is supplied
    */
    fd_spec = tioblk.flg1 & IO_OPN;
    if ( length_fname  ||  fd_spec )
    {
        /*
        /   CANNOT specify BOTH filename and -f option!
        /   CANNOT specify filename with existing open FCB
        /
        /   Unopened FCB may be present if previous sysio failed
        /   on this channel.  V1.02 MBE
        /
        /	Note that allocsize may exceed MXLEN, because ALLOC doesn't
        /	check it, and we will carve the allocated block into three
        /	chunks, each of which will be MXLEN or less.
        */
        if ( (length_fname && fd_spec) )
            return EXIT_1;
        if ( (fcb && (MK_MP(fcb->iob, struct ioblk *)->flg1 & IO_OPN)) )
            return EXIT_2;

        save_iob = 0;
        bfblksize = (BFSIZE + tioblk.pid + sizeof( word ) - 1 )
                    & ~(sizeof( word ) - 1);
        allocsize = FCSIZE + IOSIZE + bfblksize;
        tioblk.typ = 1;
    }

    /*
    /   With a NULL filename there MUST BE an existing fcblk for us
    /   to use!
    /   1.03 - Lookup filearg1 in environment block before giving up.
    /   Use presence of arguments to allocate a new FCB.
    */
    else
    {
        if ( !fcb )					/* if no FCB then error	*/
        {
            /*
            	/ 1.03 - look up in environment block.  Filename
            	/	 will be copied to tscblk.
            	*/
            scb2 = pTSCBLK;
            if (!optfile(scb1, scb2) && !use_env)
            {
                use_env = IO_ENV;
                goto again;
            }
            return  EXIT_1;
        }
        if ( tioblk.typ )		/* if args then		*/
        {
            allocsize = FCSIZE;	/*    alloc new FCB	*/
            /* BAD!! Garbage collect could move ioblk before sysio is called */
            save_iob = MK_MP(fcb->iob, struct ioblk *);
        }
        else				/* if no args then	*/
            allocsize = 0;		/*   no new FCB needed	*/
    }

    /*
    /   Do a normal return here.
    */
    tioblk.flg2 |= use_env; /*  record use of environment for sysio */
    SET_WA( allocsize );  /*  size of block to alloc or 0   */
    SET_WC( 0 );		/*  xrblk please			*/
    SET_XL( 0 );		/*  no private fcblk			*/

    return NORMAL_RETURN;
}
!@#$sysgc.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  SYSGC.C		Version:  01.01
/	---------------------------------------
/
/	zysgc - notification of system garbage collection
/
/	zysgc is called before and after a garbage collection.
/	Some systems may wish to take special action using this information.
/
/	Parameters:
/	    XR - flag for garbage collection
/		 <>0 garbage collection commencing
/		 =0  garbage collection concluding
/		WA - starting location of dynamic area
/		WB - next available location
/		WC - last available location
/	Returns
/	    Nothing
/	    Preserves all registers
/
/  Version history:
/	  v1.01 17-May-91 MBE
/		Add arguments in WA, WB, WC for use in discarding page
/       contents of freed memory on virtual memory systems.
/
*/

#include "port.h"
#include "save.h"

zysgc()
{
    in_gbcol = XR(word);  /* retain information */
    return NORMAL_RETURN;
}
!@#$syshs.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/  File:  SYSHS.C    Version:  01.13
/	---------------------------------------
/
/	Contents:	Function zyshs
/
/  1.13  21-Jun-97   Changed getint() to allow real argument.
/
/  1.12  15-Mar-97   Added HOST(-1) calls.
/
/	1.11	18-May-92	Change getint() to return value as IATYPE.
/
/   1.10    20-Jan-92   Soften check in restorestring to just verify
/						that scp is non-zero.  Previously, we were
/						checking for valid sc_type word at scp, which
/						might not be true if two adjacent string arguments
/						were used in the host call.  The zero byte from
/						the first arg might be clobbering the type word
/						of the second arg.  This was the case in the
/						Mac implementation with a HOST(16) call.
/
/	1.09	03-Jul-90	Add functions for checking, converting, and
/						restoring string arguments.  The technique
/						of producing C-style strings by storing a zero
/						beyond the end of a SPITBOL string fails when
/						two string arguments are adjacent on the heap.
/
/						Storing a zero after the first string will bash
/						the type word of the second string, and the
/						subsequent conversion of the second string will fail.
/
/						To overcome this, we check all argument types first,
/						and then convert strings without checking type words.
/						If a sub-function contains both integer and string
/						arguments, convert the integers first.
/
/	1.08	23-Jun-90	Add additional argument to HOST(1,"cmd","path")
/						for MS-DOS hosts.
/
/	1.07	21-Nov-89	Add support for 386-specific hosts
/
/	1.06	21-Sep-88	Added fourth and fifth arguments to call.
/
/	1.05	04-Mar-88	Call save0() in swcinp.c to make sure fd 0
/				properly connected prior to HOST(1,"cmd").
/
/
*/

/*
/	zyshs - host specific functions
/
/	zyshs is the catch-all function in the interface.  Any actions that
/	are host specific should be placed here.
/
/	zyshs determines what function to preformed by examining the value
/	of argument 1.  Current functions:
/
/	HOST()
/		returns the host string identifying the host environment
/
/	HOST( 0 )
/		returns -u argument from command line
/
/	HOST( 1, "command" )
/		executes 2nd argument as a Unix command
/
/	HOST( 2, n )
/		returns command line argument "n"
/
/	HOST( 3 )
/		returns the command count
/
/	HOST( 4, "v" )
/		returns the value of environment variable "v"
/
/	Other HOST functions may be provided by system specific modules.
/
/	Parameters:
/	    WA - argument 1
/	    XL - argument 2
/	    XR - argument 3
/	    WB - argument 4
/	    WC - argument 5
/	Returns:
/	    See exits
/	Exits:
/	    1 - erroneous argument
/	    2 - execution error
/	    3 - pointer to SCBLK or 0 in XL
/	    4 - return NULL string
/	    5 - return result in XR
/	    6 - cause statement failure
/	    7 - return string in XL, length in WA (may be 0)
/	    8 - return copy of result in XR
*/

#include "port.h"

/*
 *  checkstr - check if scblk is a valid string.  Returns 1 if so, else 0.
 */
int
checkstr(scp)
struct scblk *scp;
{
    return scp != (struct scblk *)0L &&
           scp->typ == TYPE_SCL && scp->len < TSCBLK_LENGTH;
}

/*  check2str - check first two argument strings in XL, XR.
 *
 * Returns 1 if both OK, else 0.
 */
int
check2str()
{
    return checkstr( XL(struct scblk *) ) && checkstr( XR(struct scblk *) );
}


/*
 *  savestr - convert an scblk to a valid C string.  Returns pointer to
 *		start of string, or 0 if fail.  The char replaced by the
 *		'\0' terminator is returned in *cp.
 */
char *
savestr(scp,cp)
struct scblk *scp;
char *cp;
{
    *cp = scp->str[scp->len];
    scp->str[scp->len] = '\0';
    return scp->str;
}

/*
 *  save2str - convert first two argument strings in XL, XR.
 */
void
save2str(s1p,s2p)
char **s1p, **s2p;
{
    *s1p = savestr( XL(struct scblk *), &savexl );
    *s2p = savestr( XR(struct scblk *), &savexr );
}

/*
 *  getstring - verify and convert an scblk to a valid C string.
 *   Returns pointer to start of string, or 0 if fail.  The char
 *   replaced by the '\0' terminator is returned in *cp.
 */
char *
getstring(scp,cp)
struct scblk *scp;
char *cp;
{
    return checkstr(scp) ? savestr(scp,cp) : (char *)0L;
}


/*
 *  restorestring - restore an scblk after a getstring call.
 *
 *  when making multiple getstring calls, call restorestring in the reverse
 *  order from getstring, in case two arguments point to the same source string.
 */
void restorestring(scp,c)
struct scblk *scp;
word c;
{
    if (scp)
        scp->str[scp->len] = c;
}


/*
 *  restore2str - restore two argument strings in XL, XR.
 */
void
restore2str()
{
    restorestring( XR(struct scblk *), savexr);
    restorestring( XL(struct scblk *), savexl);
}

/*
 *  getint - fetch an integer from either an icblk, rcblk or non-null scblk.
 *
 *  returns 1 if successful, 0 if failed.
 */
int
getint(icp,pword)
struct icblk *icp;
IATYPE *pword;
{
    register char *p, c;
    struct scblk *scp;
    word i;
    IATYPE result;
    int sign;

    sign = 1;
    if ( icp->typ == TYPE_ICL)
        result = icp->val;
#ifdef REAL_ARITH
    else if (icp->typ == TYPE_RCL)
    {
#if sparc
        union {
            mword  rcvals[2];
            double rcval;
        } val;
        val.rcvals[0] = ((struct rcblk *)icp)->rcvals[0];
        val.rcvals[1] = ((struct rcblk *)icp)->rcvals[1];
        result = (IATYPE)val.rcval;
#else
        result = (IATYPE)(((struct rcblk *)icp)->rcval);
#endif
    }
#endif
    else {
        scp = (struct scblk *)icp;
        if (!checkstr(scp))
            return 0;
        i = scp->len;
        p = scp->str;
        result = (IATYPE)0;
        while (i && *p == ' ') {		/* remove leading blanks */
            p++;
            i--;
        }
        if (i && (*p == '+' || *p == '-')) {	/* process optional sign char */
            if (*p++ == '-')
                sign = -1;
            i--;
        }
        while (i--) {
            c = *p++;
            if ( c < '0' || c > '9' ) {	/* not handling trailing blanks */
                return 0;
            }
            result = result * 10 + (c - '0');
        }
    }
    *pword = sign * result;
    return 1;
}



zyshs()
{
    word	retval;
    IATYPE	val;
    register struct icblk *icp = WA (struct icblk *);
    register struct scblk *scp;

    /*
    /   if argument one is null...
    */
    scp = WA (struct scblk *);
    if (scp->typ == TYPE_SCL && !scp->len)
    {
        gethost( pTSCBLK, TSCBLK_LENGTH );
        if ( pTSCBLK->len == 0 )
            return EXIT_4;
        SET_XL( pTSCBLK );
        return EXIT_3;
    }

    /*
    /   If argument one is an integer ...
    */
    if ( getint(icp,&val) ) {
        switch( (int)val ) {
            /*
            / HOST( -1, n ) returns internal parameter n
            */
        case -1:
            icp = XL( struct icblk * );
            if ( getint(icp,&val) ) {
                pTICBLK->typ = TYPE_ICL;
                SET_XR( pTICBLK );
                switch ( (int)val ) {
                case 0:
                    pTICBLK->val = memincb;
                    return EXIT_8;
                case 1:
                    pTICBLK->val = databts;
                    return EXIT_8;
                case 2:
                    pTICBLK->val = (IATYPE)basemem;
                    return EXIT_8;
                case 3:
                    pTICBLK->val = (IATYPE)topmem;
                    return EXIT_8;
                case 4:
                    pTICBLK->val = stacksiz - 400;	/* safety margin */
                    return EXIT_8;
                case 5:							/* stack in use */
                    pTICBLK->val = stacksiz - (XS(IATYPE) - (IATYPE)lowsp);
                    return EXIT_8;
                case 6:
                    pTICBLK->val = sizeof(IATYPE);
                    return EXIT_8;
                default:
                    return EXIT_1;
                }
            }
            else
                return EXIT_1;

            /*
            /  HOST( 0 ) returns the -u command line option argument
            */
        case 0:
            if ( uarg ) {
                cpys2sc( uarg, pTSCBLK, TSCBLK_LENGTH );
                SET_XL( pTSCBLK );
                return EXIT_3;
            }
            else if ((val = cmdcnt) != 0) {
                pTSCBLK->len = 0;
                while (pTSCBLK->len < TSCBLK_LENGTH - 2 &&
                        arg2scb( (int) val++, gblargc, gblargv,
                                 pTSCBLK, TSCBLK_LENGTH - pTSCBLK->len ) > 0)
                    pTSCBLK->str[pTSCBLK->len++] = ' ';
                if (pTSCBLK->len)
                    --pTSCBLK->len;
                SET_XL( pTSCBLK );
                return EXIT_3;
            }
            else
                return EXIT_4;
            /*
            / HOST( 1, "command", "path" ) executes "command" using "path"
            */
        case 1: {
            char *cmd, *path;

            if (!check2str())
                return EXIT_1;
            save2str(&cmd,&path);
            save0();		/* made sure fd 0 OK	*/
            pTICBLK->val = dosys( cmd, path );

            pTICBLK->typ = TYPE_ICL;
            restore2str();
            restore0();
            if (pTICBLK->val < 0)
                return EXIT_6;
            SET_XR( pTICBLK );
            return EXIT_8;
        }

        /*
        / HOST( 2, n ) returns command line argument n
        */
        case 2:
            icp = XL( struct icblk * );
            if ( getint(icp,&val) ) {
                pTSCBLK->len = 0;
                retval = arg2scb( (int) val, gblargc, gblargv, pTSCBLK, TSCBLK_LENGTH );
                if ( retval < 0 )
                    return EXIT_6;
                if ( retval == 0 )
                    return EXIT_1;
                SET_XL( pTSCBLK );
                return EXIT_3;
            }
            else
                return EXIT_1;

            /*
            /  HOST( 3 ) returns the command count
            */
        case 3:
            if ( cmdcnt ) {
                pTICBLK->typ = TYPE_ICL;
                pTICBLK->val = cmdcnt;
                SET_XR( pTICBLK );
                return EXIT_8;
            }
            else
                return EXIT_6;

            /*
            / HOST( 4, "env-var" ) returns the value of "env-var" from
            /	    the environment.
            */
        case 4:
            scp = XL( struct scblk * );
            if ( scp->typ == TYPE_SCL ) {
                if ( scp->len == 0 )
                    return EXIT_1;
                if ( rdenv( scp, pTSCBLK ) < 0 )
                    return EXIT_6;
                SET_XL( pTSCBLK );
                return EXIT_3;
            }
            else
                return EXIT_1;
        }       /* end switch */

        /*
        / Any other integer value is processed by the system-specific functions
        */
#if HOST386
        return host386( (int)val );
#endif					/* HOST386 */

        /*
        /   Here if first argument wasn't an integer or was an illegal value.
        */
    }
    return EXIT_1;
}
!@#$sysid.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  SYSID.C		Version:  01.02
/	---------------------------------------
/
/	Contents:	Function zysid
/
/	1.02	Move id2 string here.
*/

/*
/	zysid - identify system
/
/	zysid returns two strings identifying the Spitbol system.
/
/	Parameters:
/	    None
/	Returns:
/	    XR - pointer to SCBLK containing suffix to Spitbol header
/	    XL - pointer to SCBLK containing 2nd header line
/	Exits:
/	    None
*/

#include "port.h"

/*
/   define actual headers elsewhere to overcome problems in initializing
/   the two SCBLKs.  Use id2blk instead of tscblk because tscblk may
/	be active with an error message when zysid is called.
*/

zysid()

{
    register char *cp;

    SET_XR( pID1 );
    gettype( pID2BLK, ID2BLK_LENGTH );
    cp = pID2BLK->str + pID2BLK->len;
    *cp++ = ' ';
    *cp++ = ' ';
    pID2BLK->len += 2 + storedate(cp, ID2BLK_LENGTH - pID2BLK->len);
    SET_XL( pID2BLK );
    return NORMAL_RETURN;
}
!@#$sysif.c
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/  File:  SYSIF.C    Version:  01.03
/	-----------------------------------
/
/	Contents:	Function zysif
/
/	V1.01	01-25-90
/			If include file cannot be opened, restore fd 0.
/
/	V1.02	02-16-91
/			Call clrbuf() after closing the existing file.
/
/  V1.03 04-27-97
/        Look for include file in the directory where SPITBOL resides, and
/        in the directory of the first source file.
*/

/*
/	zysif - start/stop using include file
/
/	zysif stacks the current input stream and opens a new include file.
/		It is also called when an EOF is read to restore the stacked file.
/
/	Parameters:
/	    XL	 pointer to SCBLK with name of file.
/	 		 0 to end use of file.
/	    XR - pointer to vacant SCBLK that will receive the name of the
/			 file finally opened, after looking in other directories.
/	Returns:
/	    XR - scblk filled in with full path name and length.
/	Exits:
/	     1 - could not find file
/
*/

#include "port.h"

#if AIX | LINUX
#include <fcntl.h>
#endif

static	void	openprev Params((void));

/*
/  Helper function to back up one file in the include nesting.
*/

static void openprev()
{
    fd = inc_fd[--nesting];		/* Unstack one level */
#if USEFD0FD1
    dup(fd);					/* Create fd 0 for previous file */
    close(fd);					/* Release dup'ed fd of old file */
    fd = 0;
#else					/* USEFD0FD1 */
    setrdfd( fd );	  			/* Make it the current input stream */
#endif					/* USEFD0FD1 */
    clrbuf();

    doset( getrdiob(),inc_pos[nesting],0 );	/* Position file where left off */
}

zysif()
{
    register struct scblk *fnscb = XL (struct scblk *);
    register struct scblk *pnscb = XR (struct scblk *);
    register char *savecp;
    char savechar, filebuf[256];
    char *file;

    if (fnscb) {
        /* Here to nest another include file */
        if (nesting == INCLUDE_DEPTH)			/* Is there room in array? */
            return EXIT_1;

        inc_pos[nesting] = doset(getrdiob(),0L,1);	/* Record current position */
#if USEFD0FD1
        inc_fd[nesting++] = dup(0);			/* Save current input file */
        close(0);							/* Make fd 0 available */
#else					/* USEFD0FD1 */
        inc_fd[nesting++] = getrdfd();		/* Record current input stream */
#endif					/* USEFD0FD1 */
        clrbuf();
        savecp = fnscb->str + fnscb->len;	/* Make it a C string for now. */
        savechar = *savecp;
        *savecp = '\0';
        file = fnscb->str;
        fd = spit_open( file, O_RDONLY, IO_PRIVATE | IO_DENY_WRITE,
                        IO_OPEN_IF_EXISTS );	/* Open file */
        if (fd < 0)
        {
            /* If couldn't open, try alternate paths via SNOLIB */
            initpath(SPITFILEPATH);
            file = filebuf;
            while (trypath(fnscb->str,file))
            {
                fd = spit_open(file, O_RDONLY, IO_PRIVATE | IO_DENY_WRITE, IO_OPEN_IF_EXISTS);
                if (fd >= 0)
                    break;
            }
        }
        if (fd < 0)
        {
            /* If still not open, look in directory where SPITBOL resides. */
            int i = pathlast(gblargv[0]) - gblargv[0];
            if (i)
            {
                mystrncpy(filebuf, gblargv[0], i);
                mystrcpy(&filebuf[i], fnscb->str);
                fd = spit_open(filebuf, O_RDONLY, IO_PRIVATE | IO_DENY_WRITE, IO_OPEN_IF_EXISTS);
            }
        }
        if (fd < 0 && sfn && sfn[0])
        {
            /* If still not open, look in directory where first source file resides. */
            int i = pathlast(sfn) - sfn;
            if (i)
            {
                mystrncpy(filebuf, sfn, i);
                mystrcpy(&filebuf[i], fnscb->str);
                fd = spit_open(filebuf, O_RDONLY, IO_PRIVATE | IO_DENY_WRITE, IO_OPEN_IF_EXISTS);
            }
        }
        if ( fd >= 0 ) {  				/* If file opened OK */
            cpys2sc(file,pnscb,pnscb->len);
#if !USEFD0FD1
            setrdfd( fd );        /* Make it the current input stream */
#endif					/* !USEFD0FD1 */
            *savecp = savechar;			/* Restore saved char */
        }
        else {  						/* Couldn't open file */
            *savecp = savechar;			/* Restore saved char */
            openprev();					/* Restore input file we just closed */
            return EXIT_1;				/* Fail */
        }
    }
    /*
    /  EOF read.  Pop back one include file.
    */
    else {
        if (nesting > 0) {				/* Make sure don't go too far	*/
            close(fd);					/* Close last include file		*/
            openprev();					/* Reopen previous include file	*/
        }
    }
    return NORMAL_RETURN;
}
