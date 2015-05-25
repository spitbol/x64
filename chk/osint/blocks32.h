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

//----------------------------  blocks32.h  --------------------------------
#ifndef __blocks32__
#define __blocks32__

/*
 * Definitions of SPITBOL data blocks available to C-language
 * external functions to be called from 32-bit versions of SPITBOL.
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
    BL_AR =	0,				// ARBLK	ARRAY
    BL_CD,					// CDBLK	CODE
    BL_EX,					// EXBLK	EXPRESSION
    BL_IC,					// ICBLK	INTEGER
    BL_NM,					// NMBLK	NAME
    BL_P0,					// P0BLK	PATTERN, 0 args
    BL_P1,					// P1BLK	PATTERN, 1 arg
    BL_P2,					// P2BLK	PATTERN, 2 args
    BL_RC,					// RCBLK	REAL
    BL_SC,					// SCBLK	STRING
    BL_SE,					// SEBLK	EXPRESSION
    BL_TB,					// TBBLK	TABLE
    BL_VC,					// VCBLK	VECTOR (array)
    BL_XN,					// XNBLK	EXTERNAL, non-relocatable contents
    BL_XR,					// XRBLK	EXTERNAL, relocatable contents
    BL_BC,					// BCBLK	BUFFER CONTROL
    BL_PD,					// PDBLK	PROGRAM DEFINED DATATYPE
    BL__D					// NUMBER OF BLOCK CODES FOR DATA
};

/*
 * OTHER BLOCK CODES
 *
 * These blocks will never appear in an argument list, but are
 * listed here for completeness.
 */

enum {
    BL_TR = BL__D,			// TRBLK	TRACE
    BL_BF,					// BFBLK	BUFFER
    BL_CC,					// CCBLK	CODE CONSTRUCTION
    BL_CM,					// CMBLK	COMPILER TREE NODE
    BL_CT,					// CTBLK	CHARACTER TABLE
    BL_DF,					// DFBLK	DATATYPE FUNCTION
    BL_EF,					// EFBLK	EXTERNAL FUNCTION
    BL_EV,					// EVBLK	EXPRESSION VARIABLE
    BL_FF,					// FFBLK	FIELD FUNCTION
    BL_KV,					// KVBLK	KEYWORD VARIABLE
    BL_PF,					// PFBLK	PROGRAM-DEFINED FUNCTION
    BL_TE					// TEBLK	TABLE ELEMENT
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
    mword 	ictyp;					// type word
    mword 	icval;					// integer value
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
    mword	rctyp;					// type word
    mword	rcvals[2];				// real value (not 8-byte aligned!)
};
#define rcval(blk) (*(double *)blk.rcvals) // access double at rcvals
#else
struct rcblk {
    mword	rctyp;					// type word
    double	rcval;					// real value (not 8-byte aligned!)
};
#endif

/*
 *  	Structure of SCBLK (strings)
 */

struct scblk {
    mword	sctyp;					// type word
    mword	sclen;					// string length
    char	scstr[1];				// start of string
};

/*
 *   	Structure for returning a far string
 */

struct fsblk {
    mword	fstyp;					// type word
    mword	fslen;					// string length
    far char *fsptr;				// far pointer to string
};


/*
 *   	Structure for returning a far external block
 */

struct fxblk {
    mword	fxtyp;					// type word
    mword	fxlen;					// external data length
    far void *fxptr;				// far pointer to external data
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
    mword			fcbtyp;	 		// type word (XRBLK)
    mword			fcblen;	 		// size of block, in bytes
    mword			fcbrsz;	 		/* SPITBOL record size and mode
									   positive if text mode,
									   negative if binary.				*/
    struct ioblk   *fcbiob;			// pointer to IOBLK
    mword			fcbmod;			// 1 if text mode, 0 if binary mode
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
    mword	typ;				//  type word
    mword	len;				//  block length
    struct	chfcb *nxt;			//  pointer to next chfcb
    struct	fcblk *fcp;			//  pointer to fcb
};



/*
 * I/O BLOCK
 *
 * An I/O block is pointed to by the fcbiob field of a file control block.
 */

struct ioblk {
    mword			iobtyp;	   		// type word (XRBLK)
    mword			ioblen;			// size of IOBLK in bytes
    struct scblk   *iobfnm;			// SCBLK holding filename
    mword			iobpid;			// pipe id (not used for DOS)
    struct bfbblk  *iobbfb;         // pointer to BFBBLK
    mword			iobfdn;			// O/S file descriptor number
    mword			iobflg1;		// flags 1 (see below)
    mword			iobflg2;		// flags 2 (see below)
    mword			iobeol;			// end of line character 1
    mword			iobshare; 		// sharing mode
    mword			iobaction;		// file open actions
};

/*
 * 	Bits in iobflg1 dword
 */
#define IO_INP	0x00000001			// input file
#define IO_OUP	0x00000002			// output file
#define IO_APP	0x00000004			// append output to existing file
#define IO_OPN	0x00000008			// file is open
#define IO_COT	0x00000010			// console output to non-disk device
#define IO_CIN	0x00000020			// console input from non-disk device
#define IO_SYS	0x00000040			// -f option used instead of name
#define IO_WRC	0x00000080			// output without buffering

/*
 * 	Bits in iobflg2 dword
 */
#define IO_PIP	0x00000001			// pipe (not used in MS-DOS)
#define IO_DED	0x00000002			// dead pipe (not used in MS-DOS)
#define IO_ILL	0x00000004			// illegal I/O association
#define IO_RAW	0x00000008			// binary I/O to character device
#define IO_LF 	0x00000010			// ignore line feed if next character
#define IO_NOE	0x00000020			// no echo input
#define IO_ENV	0x00000040			// filearg1 mapped via environment var
#define IO_DIR  0x00000080		    // buffer is dirty (needs to be written)
#define	IO_BIN	0x00000100			// binary I/O

// Private flags used to convey sharing status when opening a file
#define IO_COMPATIBILITY	0x00
#define IO_DENY_READWRITE	0x01
#define IO_DENY_WRITE		0x02
#define IO_DENY_READ		0x03
#define IO_DENY_NONE		0x04
#define IO_DENY_MASK		0x07		// mask for above deny mode bits
#define	IO_EXECUTABLE		0x40		// file to be marked executable
#define IO_PRIVATE			0x80		// file is private to current process

// Private flags used to convey file open actions
#define IO_FAIL_IF_EXISTS		0x00
#define IO_OPEN_IF_EXISTS		0x01
#define IO_REPLACE_IF_EXISTS	0x02
#define IO_FAIL_IF_NOT_EXIST	0x00
#define IO_CREATE_IF_NOT_EXIST	0x10
#define IO_EXIST_ACTION_MASK	0x13	// mask for above bits
#define IO_WRITE_THRU       	0x20	// writes complete before return

/*
 * I/O BUFFER BLOCK
 *
 * An I/O buffer block (BFBBLK) is pointed to by an IOBLK.
 *
 * Size of file position words in I/O buffer block
 */

#if SETREAL
typedef double FILEPOS;     // real file positions
#else
typedef long FILEPOS;       // 32-bit file positions
#endif

struct bfbblk {
    mword	bfbtyp;					// type word (XNBLK)
    mword	bfblen;					// size of BFBBLK, in bytes
    mword	bfbsiz;					// size of buffer in bytes
    mword	bfbfil;					// number of bytes currently in buffer
    mword	bfbnxt;					// offset of next buffer char to r/w
    FILEPOS bfboff;                 // file position of first byte in buf
    FILEPOS bfbcur;                 // physical file position
    char	bfbbuf[1];				// start of buffer
};


/*
 * Structure of EFBLK (external function).  A pointer to this block
 * is passed to the external function in the stack in info.pefblk.
 */

struct efblk {
    mword			fcode;			// type word
    mword   		fargs;			// number of arguments
    mword			eflen;			// block length
    mword			efuse;			// usage count
    struct xnblk   *efcod;			// pointer to XNBLK, see below
    struct vrblk   *efvar;			// pointer to VRBLK with function name
    mword			efrsl;			// result type  (see below)
    mword			eftar[1];		// array of argument types, one per arg
};

/*
 * efrsl and eftar[] contain small integer type codes as follows:
 */

#define noconv	0					// argument remains unconverted
#define constr	1					// convert argument to string
#define conint	2					// convert argument to integer
#define conreal	3					// convert argument to real
#define confile	4					// produce fcb associated with variable


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
    mword	xntyp;					// type word
    mword	xnlen;					// length of this block
    union {							// two uses for rest of block:
        mword	xndta[1];			// 1. user defined data starts here
        struct ef {                 // 2. external function info
            mword   xnoff;          //    base offset of function image
            mword   xnsiz;          //    size of function in bytes
            mword   xneip;          //    transfer EIP
            short	xncs;			//    transfer CS
            mword   xnesp;          //    transfer ESP, 0 = SPITBOL's stack
            short	xnss;			//	  transfer SS, 0 = SPITBOL's stack
            short	xnds;			//	  transfer DS
            short	xnes;			//	  transfer ES
            short	xnfs;			//	  transfer FS
            short	xngs;			//	  transfer GS
            short	xn1st;			//    non-zero = first-ever call
            short	xnsave;			//    non-zero = first call after reload
            far void (*xncbp)(void);//    callback function prior to exiting
            short	xnpad;			//    pad to dword boundary
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

struct arblk1 {	   					// One dimensional array
    mword			arblk;			// type word (ARBLK)
    mword			aridv;			// identifier value
    mword			arlen;			// length of ARBLK in bytes
    mword			arofs;			// offset in arblk to arpro field
    mword			arndm;			// number of dimensions
    mword			arlbd;			// low bound (first subscript)
    mword			ardim;			// dimension (first subscript)
    struct scblk   *arpro;			// array prototype string
    union block	   *arvls[1];		// start of values in row-wise order
};

struct arblk2 {						// Two dimensional array
    mword			arblk;	  		// type word (ARBLK)
    mword			aridv;	  		// identifier value
    mword			arlen;			// length of ARBLK in bytes
    mword			arofs;			// offset in arblk to arpro field
    mword			arndm;			// number of dimensions
    mword			arlbd;			// low bound (first subscript)
    mword			ardim;			// dimension (first subscript)
    mword			arlb2;			// low bound (second subscript)
    mword			ardm2;			// dimension (second subscript)
    struct scblk   *arpro;			// array prototype string
    union block	   *arvls[1];		// start of values in row-wise order
};

#define ndim	3					// For example, 3-dimensional array
struct arblkn {						// N-dimensional array
    mword			arblk;			// type word (ARBLK)
    mword			aridv;			// identifier value
    mword			arlen;			// length of ARBLK in bytes
    mword			arofs;			// offset in arblk to arpro field
    mword			arndm;		  	// number of dimensions
    struct {
        mword	arlbd;				// low bound (first subscript)
        mword	ardim;				// dimension (first subscript)
    } 			bounds[ndim]; 	// adjust for number of dimensions
    struct scblk   *arpro;  		// array prototype string
    union block	   *arvls[1];		// start of values in row-wise order
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
    mword	bctyp;					// type word
    mword	bcidv;					// identifier value
    mword	bclen;					// number of chars in use in bfblk
    mword	bcbuf;					// pointer to bfblk
};


/*
 * 	STRING BUFFER BLOCK
 *
 *	A string buffer block (BFBLK) contains the actual buffer
 *	memory area. It specifies the largest string that can be
 *	stored in the buffer.
 */
struct bfblk {
    mword	bftyp;					// type word
    mword	bfalc;					// allocated size of buffer
    char	bfchr[1];				// characters of string
};


/*
 * CODE BLOCK
 *
 * A code block (CDBLK) is present for every source statement.
 */

struct cdblk {
    mword			cdjmp;			// ptr to routine to execute statement
    mword			cdstm;			// statement number
    mword			cdsln;			// source file line number
    mword			cdlen;			// length of CDBLK in bytes
    union {
        struct cdblk *cdnxt;		// if failure exit is next statement
        struct vrblk *cdlab;		// if failure exit is a simple label
        char 		 *cdnof;		// no failure exit (-NOFAIL mode)
        mword		  cddir;		// failure exit is complex or direct
    }			cdfal;			// Failure exit
    mword			cdcod[1];		// executable pseudo-code
};


/*
 * NAME BLOCK
 *
 * A name block (NMBLK) is used whereever a name must be stored as
 * a value following use of the unary dot operator.
 */

struct nmblk {
    mword			nmtyp;		  	// type word (NMBLK)
    union block	   *nmbas;			// base pointer for variable
    mword			nmofs;			// offset within block for variable
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
    mword			tbtyp;			// type word (TBBLK)
    mword			tbidv;			// identifier value
    mword			tblen;			// length of TBBLK in bytes
    union block	   *tbinv; 			// default initial lookup value
    struct teblk   *tbbuk[1];		// start of hash bucket pointers
};


/*
 * TABLE ELEMENT BLOCK
 *
 * A table element (TEBLK) is used to represent a single entry in
 * a table.
 */

struct teblk {
    mword			teblk;			// type word (TEBLK)
    union block	   *tesub;			// subscript value
    union block    *teval;			// table element value
    struct teblk   *tenxt;			// next TEBLK or TBBLK if end of chain
};


/*
 * VARIABLE BLOCK
 *
 * A variable block (VRBLK) is used to hold a program variable.
 */

struct vrblk {
    mword			vrget;			// routine to load variable onto stack
    mword			vrsto;			// routine to store stack top into var.
    union block	    *vrval;			// variable value
    mword			vrtra;			// routine to transfer to label
    union block	   *vrlbl;			// pointer to code for label
    union block	   *vrfnc;			// function block if name is function
    struct vrblk   *vrnxt;			// next vrblk on hash chain
    mword			vrlen;			// length of name
    char			vrchs[1];		// characters of name
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
    mword			vctyp;			// type word (VCBLK)
    mword			vcidv;			// identifier value
    mword			vclen;			// length of vcblk in bytes
    union block	   *vcvls[1];		// start of vector values
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
//------------------------  end of blocks32.h  ------------------------------
