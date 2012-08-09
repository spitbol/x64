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

/*----------------------------  blocks32.h  --------------------------------*/
#ifndef __blocks32__
#define __blocks32__

/*
 * definitions of spitbol data blocks available to c-language
 * external functions to be called from 32-bit versions of spitbol.
 *
 * v1.00	02/17/90 01:53pm
 *			initial version
 * v1.01	12-03-90 12:01pm
 * 			to match release 1.08.  split flags in ioblk
 * 			into to words to prevent flag bits from being
 * 			mistaken for a relocatable value.
 * v1.02	03-11-91 15:00pm
 * 			to match release 1.1.  add new words to ioblk for end-
 * 			of-line characters.  the bfblk has been completely
 * 			reworked to accommodate read/write i/o.
 * v1.03	10-18-91 04:27pm
 *        <withdrawn>.
 * v1.04	3-july-92
 * 			begin to customize for sparc/sun 4.
 * v1.05	09-12-94 07:13pm
 *		 	add definitions for buffers
 * v1.06	04-25-95 10:07pm
 *			customize for rs/6000.
 * v1.07    12-29-96 06:05pm
 *          customize for windows nt
 * v1.08    03-04-97 01:45pm
 *          tweak for sparc
 * v1.09 04-27-97
 *          add filepos definition.
 *
 *
 * spitbol blocks
 *
 * all spitbol objects are encapsulated into blocks of memory.
 * the first word of each block identifies the block type in a
 * curious way.  rather than containing a simple integer type
 * code, it contains the address of a subroutine that performs
 * some particular action on the block, such as placing it on
 * the stack.  because each block type uses a different subroutine,
 * the subroutine addresses serve as a type identifier.
 *
 *
 * each subroutine is proceeded in memory by a one-byte (intel platforms)
 * or one-word (all other platforms) integer type code (given below).
 * thus to obtain a simple ordinal type code for a block pointed to by an
 * address in pblk, use the following:
 *
 * block	*pblk;
 * unsigned	typecode;
 *   ...
 *  typecode = *((unsigned char *)((long)pblk - 1)); (intel platform)
 *  typecode = *((unsigned *)((long)pblk - 4));      (sun, rs/6000, sgi, etc.)
 *
 *
 * here's a visualization of how spitbol stores data blocks and identifies
 * their type by pointing to unique sections of code:
 *
 *
 *   in data space:                        in code space:
 * +---------------------+               +-----------+
 * |      type word      |----+          | type code |
 * +---------------------+    |          +-----------+----------------+
 * |      block data     |    +--------->|   program code for this    |
 *...                   ...              |   block type               |
 * |                     |               |                            |
 * +---------------------+               +----------------------------+
 *
 *
 * given an integer type, the type word can be obtained by
 * looking it up in a table provided to external functions as ptyptab in
 * the misc info structure.  for example, if the locator information
 * structure is passed to the function as an argument called "info",
 * use the following:
 *
 * unsigned typecode;
 * mword	typeword;
 *  ...
 *   typeword = (*info.ptyptab)[typecode];
 */

/*
 * block codes for accessible datatypes
 *
 * these blocks may appear in an argument list if left untranslated
 * by the load function definition.
 */

enum {
    bl_ar =	0,				/* arblk	array								*/
    bl_cd,					/* cdblk	code								*/
    bl_ex,					/* exblk	expression							*/
    bl_ic,					/* icblk	integer								*/
    bl_nm,					/* nmblk	name								*/
    bl_p0,					/* p0blk	pattern, 0 args						*/
    bl_p1,					/* p1blk	pattern, 1 arg						*/
    bl_p2,					/* p2blk	pattern, 2 args						*/
    bl_rc,					/* rcblk	real								*/
    bl_sc,					/* scblk	string								*/
    bl_se,					/* seblk	expression							*/
    bl_tb,					/* tbblk	table								*/
    bl_vc,					/* vcblk	vector (array)						*/
    bl_xn,					/* xnblk	external, non-relocatable contents	*/
    bl_xr,					/* xrblk	external, relocatable contents		*/
    bl_bc,					/* bcblk	buffer control						*/
    bl_pd,					/* pdblk	program defined datatype			*/
    bl__d					/* number of block codes for data				*/
};

/*
 * other block codes
 *
 * these blocks will never appear in an argument list, but are
 * listed here for completeness.
 */

enum {
    bl_tr = bl__d,			/* trblk	trace							*/
    bl_bf,					/* bfblk	buffer							*/
    bl_cc,					/* ccblk	code construction				*/
    bl_cm,					/* cmblk	compiler tree node				*/
    bl_ct,					/* ctblk	character table					*/
    bl_df,					/* dfblk	datatype function				*/
    bl_ef,					/* efblk	external function				*/
    bl_ev,					/* evblk	expression variable				*/
    bl_ff,					/* ffblk	field function					*/
    bl_kv,					/* kvblk	keyword variable				*/
    bl_pf,					/* pfblk	program-defined function		*/
    bl_te					/* teblk	table element					*/
};

/*
 * structure of common spitbol blocks:
 * 	    integer, real, string, and file blocks.
 *
 *  	these structures are part of the "blocks" union that can be applied
 * 	    to the result area to determine where to store required return
 *      information.
 */

/*
 *  	structure of icblk (integers)
 */

struct icblk {
    mword 	ictyp;					/* type word						*/
    mword 	icval;					/* integer value					*/
};


/*
 * 		structure of rcblk (reals)
 */
#if sparc
/*
 * 		note that the obvious declaration "double rcval" can not be
 *      used, because the sparc c compiler insists on placing double
 * 		values on an 8-byte boundary, effectively making the rcblk into
 * 		a four-word structure, instead of three. (a filler word is
 * 		inserted between rctyp and rcval).  but an rcblk really is a
 * 		three-word structure inside of spitbol.
 *
 * 		as a workaround, we define rcvals as a two word array, and use
 * 		an rcval macro to access the double value there.  the macro
 * 		is invoked with the rcblk as its argument.  for example,
 * 		suppose presult pointed to a union of all block types.  the
 * 		double value stored in an rcblk there would be accessed as
 *
 * 			rcval(presult->rcb)
 *
 * 		it may be necessary to use the -misalign command option with
 * 		cc to have the compiler generate the two single-precision loads
 * 		needed to access the real at rcvals.  the normal double-precision
 * 		load will fault because the operand is not aligned properly.
 *
 *  	see function retreal in extrnlib.c for an example.
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
 *  	structure of scblk (strings)
 */

struct scblk {
    mword	sctyp;					/* type word						*/
    mword	sclen;					/* string length					*/
    char	scstr[1];				/* start of string					*/
};

/*
 *   	structure for returning a far string
 */

struct fsblk {
    mword	fstyp;					/* type word						*/
    mword	fslen;					/* string length					*/
    far char *fsptr;				/* far pointer to string				*/
};


/*
 *   	structure for returning a far external block
 */

struct fxblk {
    mword	fxtyp;					/* type word						*/
    mword	fxlen;					/* external data length				*/
    far void *fxptr;				/* far pointer to external data			*/
};


/*
 * file control block
 *
 * the user may provide the word "file" for any argument in
 * the load function prototype.  when a call is made to the
 * external function with an i/o associated variable in this argument
 * position, spitbol will provide a pointer to the file control
 * block instead of the value of the variable.
 *
 * the file control block (fcb) points to an i/o block with
 * additional information.  in turn, the i/o block points to any
 * buffer used by the file.
 *
 * this block is obtained for every file except those associated
 * with input, output, or terminal.  note that these fcb's are
 * unrelated to ms-dos fcb's.  file control blocks do not have
 * their own type word, but appear as xrblks with the following structure:
 */

struct fcblk {
    mword			fcbtyp;	 		/* type word (xrblk)				*/
    mword			fcblen;	 		/* size of block, in bytes			*/
    mword			fcbrsz;	 		/* spitbol record size and mode
									   positive if text mode,
									   negative if binary.				*/
    struct ioblk   *fcbiob;			/* pointer to ioblk					*/
    mword			fcbmod;			/* 1 if text mode, 0 if binary mode	*/
};


/*
 *   chfcb - chain of fcbs block
 *
 *   for every fcb created by osint, the compiler creates a chfcb pointing
 *   to the fcb and links it onto a chain of chfcbs.  at eoj the head of this
 *   chfcb chain is passed to the interface function sysej so that all files
 *   can be closed.
 */

struct	chfcb {
    mword	typ;				/*  type word			*/
    mword	len;				/*  block length		*/
    struct	chfcb *nxt;			/*  pointer to next chfcb	*/
    struct	fcblk *fcp;			/*  pointer to fcb		*/
};



/*
 * i/o block
 *
 * an i/o block is pointed to by the fcbiob field of a file control block.
 */

struct ioblk {
    mword			iobtyp;	   		/* type word (xrblk)				*/
    mword			ioblen;			/* size of ioblk in bytes			*/
    struct scblk   *iobfnm;			/* scblk holding filename			*/
    mword			iobpid;			/* pipe id (not used for dos)		*/
    struct bfbblk  *iobbfb;         /* pointer to bfbblk                */
    mword			iobfdn;			/* o/s file descriptor number 		*/
    mword			iobflg1;		/* flags 1 (see below)				*/
    mword			iobflg2;		/* flags 2 (see below)				*/
    mword			iobeol1;		/* end of line character 1			*/
    mword			iobeol2;		/* end of line character 2			*/
    mword			iobshare; 		/* sharing mode						*/
    mword			iobaction;		/* file open actions				*/
};

/*
 * 	bits in iobflg1 dword
 */
#define io_inp	0x00000001			/* input file							*/
#define io_oup	0x00000002			/* output file							*/
#define io_app	0x00000004			/* append output to existing file		*/
#define io_opn	0x00000008			/* file is open							*/
#define io_cot	0x00000010			/* console output to non-disk device	*/
#define io_cin	0x00000020			/* console input from non-disk device	*/
#define io_sys	0x00000040			/* -f option used instead of name		*/
#define io_wrc	0x00000080			/* output without buffering				*/

/*
 * 	bits in iobflg2 dword
 */
#define io_pip	0x00000001			/* pipe (not used in ms-dos)			*/
#define io_ded	0x00000002			/* dead pipe (not used in ms-dos)		*/
#define io_ill	0x00000004			/* illegal i/o association				*/
#define io_raw	0x00000008			/* binary i/o to character device			*/
#define io_lf 	0x00000010			/* ignore line feed if next character	*/
#define io_noe	0x00000020			/* no echo input						*/
#define io_env	0x00000040			/* filearg1 mapped via environment var	*/
#define io_dir  0x00000080		    /* buffer is dirty (needs to be written)*/
#define	io_bin	0x00000100			/* binary i/o */

/* private flags used to convey sharing status when opening a file */
#define io_compatibility	0x00
#define io_deny_readwrite	0x01
#define io_deny_write		0x02
#define io_deny_read		0x03
#define io_deny_none		0x04
#define io_deny_mask		0x07		/* mask for above deny mode bits*/
#define	io_executable		0x40		/* file to be marked executable */
#define io_private			0x80		/* file is private to current process */

/* private flags used to convey file open actions */
#define io_fail_if_exists		0x00
#define io_open_if_exists		0x01
#define io_replace_if_exists	0x02
#define io_fail_if_not_exist	0x00
#define io_create_if_not_exist	0x10
#define io_exist_action_mask	0x13	/* mask for above bits */
#define io_write_thru       	0x20	/* writes complete before return*/

/*
 * i/o buffer block
 *
 * an i/o buffer block (bfbblk) is pointed to by an ioblk.
 *
 * size of file position words in i/o buffer block
 */

#if setreal
typedef double filepos;     /* real file positions */
#else
typedef long filepos;       /* 32-bit file positions */
#endif

struct bfbblk {
    mword	bfbtyp;					/* type word (xnblk)					*/
    mword	bfblen;					/* size of bfbblk, in bytes				*/
    mword	bfbsiz;					/* size of buffer in bytes				*/
    mword	bfbfil;					/* number of bytes currently in buffer	*/
    mword	bfbnxt;					/* offset of next buffer char to r/w	*/
    filepos bfboff;                 /* file position of first byte in buf   */
    filepos bfbcur;                 /* physical file position               */
    char	bfbbuf[1];				/* start of buffer						*/
};


/*
 * structure of efblk (external function).  a pointer to this block
 * is passed to the external function in the stack in info.pefblk.
 */

struct efblk {
    mword			fcode;			/* type word							*/
    mword   		fargs;			/* number of arguments					*/
    mword			eflen;			/* block length							*/
    mword			efuse;			/* usage count							*/
    struct xnblk   *efcod;			/* pointer to xnblk, see below			*/
    struct vrblk   *efvar;			/* pointer to vrblk with function name	*/
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
 * structure of xnblk allocated for external function
 * a pointer to this structure is passed to the external function
 * in the stack in pxnblk.
 *
 * this structure is used to ways:
 *   1.	 as a general structure in which the user can place private
 * 		 data and have it maintained by spitbol.
 *
 *   2.  as a particular structure in which information about each
 * 		 external function is maintained.
 */

struct xnblk {
    mword	xntyp;					/* type word							*/
    mword	xnlen;					/* length of this block					*/
    union {							/* two uses for rest of block:			*/
        mword	xndta[1];			/* 1. user defined data starts here		*/
        struct ef {                 /* 2. external function info            */
#if winnt | sparc | aix
            void   *xnhand;         /*    module handle                     */
            mword  (*xnpfn) params((void));  /*    pointer to function entry         */
            mword	xn1st;			/*    non-zero = first-ever call		*/
            mword	xnsave;			/*    non-zero = first call after reload*/
            void   (*xncbp) params((void));  /*    callback function prior to exiting*/
#else
            mword   xnoff;          /*    base offset of function image     */
            mword   xnsiz;          /*    size of function in bytes         */
            mword   xneip;          /*    transfer eip                      */
            short	xncs;			/*    transfer cs						*/
            mword   xnesp;          /*    transfer esp, 0 = spitbol's stack */
            short	xnss;			/*	  transfer ss, 0 = spitbol's stack	*/
            short	xnds;			/*	  transfer ds						*/
            short	xnes;			/*	  transfer es						*/
            short	xnfs;			/*	  transfer fs						*/
            short	xngs;			/*	  transfer gs						*/
            short	xn1st;			/*    non-zero = first-ever call		*/
            short	xnsave;			/*    non-zero = first call after reload*/
            far void (*xncbp)(void);/*    callback function prior to exiting*/
            short	xnpad;			/*    pad to dword boundary				*/
#endif
        } ef;
    } xnu;
};

/*
 * simplified access to xn1st and xnsave words in xnblk via pointer to
 * miscellaneous info area in pinfo.
 */

#define first_call ((*((*pinfo).pxnblk)).xnu.ef.xn1st)
#define reload_call ((*((*pinfo).pxnblk)).xnu.ef.xnsave)


/*
 * other selected blocks of interest:
 *
 *
 * array block
 *
 * an array block (arblk) represents an array value other than one
 * with one dimension whose lower bound is one (see vcblk).
 */

struct arblk1 {	   					/* one dimensional array				*/
    mword			arblk;			/* type word (arblk)                    */
    mword			aridv;			/* identifier value						*/
    mword			arlen;			/* length of arblk in bytes				*/
    mword			arofs;			/* offset in arblk to arpro field		*/
    mword			arndm;			/* number of dimensions					*/
    mword			arlbd;			/* low bound (first subscript)			*/
    mword			ardim;			/* dimension (first subscript)			*/
    struct scblk   *arpro;			/* array prototype string				*/
    union block	   *arvls[1];		/* start of values in row-wise order	*/
};

struct arblk2 {						/* two dimensional array				*/
    mword			arblk;	  		/* type word (arblk)                    */
    mword			aridv;	  		/* identifier value						*/
    mword			arlen;			/* length of arblk in bytes				*/
    mword			arofs;			/* offset in arblk to arpro field		*/
    mword			arndm;			/* number of dimensions					*/
    mword			arlbd;			/* low bound (first subscript)			*/
    mword			ardim;			/* dimension (first subscript)			*/
    mword			arlb2;			/* low bound (second subscript)			*/
    mword			ardm2;			/* dimension (second subscript)			*/
    struct scblk   *arpro;			/* array prototype string				*/
    union block	   *arvls[1];		/* start of values in row-wise order	*/
};

#define ndim	3					/* for example, 3-dimensional array		*/
struct arblkn {						/* n-dimensional array					*/
    mword			arblk;			/* type word (arblk)                    */
    mword			aridv;			/* identifier value						*/
    mword			arlen;			/* length of arblk in bytes				*/
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
 * 	buffer control block
 *
 *	a buffer control block (bcblk) is created by the buffer
 *	function, and serves as an indirect control header for the
 *	buffer. it contains the number of characters currently
 *	stored in the buffer.
 */
struct bcblk {
    mword	bctyp;					/* type word							*/
    mword	bcidv;					/* identifier value						*/
    mword	bclen;					/* number of chars in use in bfblk		*/
    mword	bcbuf;					/* pointer to bfblk						*/
};


/*
 * 	string buffer block
 *
 *	a string buffer block (bfblk) contains the actual buffer
 *	memory area. it specifies the largest string that can be
 *	stored in the buffer.
 */
struct bfblk {
    mword	bftyp;					/* type word							*/
    mword	bfalc;					/* allocated size of buffer				*/
    char	bfchr[1];				/* characters of string					*/
};


/*
 * code block
 *
 * a code block (cdblk) is present for every source statement.
 */

struct cdblk {
    mword			cdjmp;			/* ptr to routine to execute statement	*/
    mword			cdstm;			/* statement number						*/
    mword			cdsln;			/* source file line number				*/
    mword			cdlen;			/* length of cdblk in bytes				*/
    union {
        struct cdblk *cdnxt;		/* if failure exit is next statement	*/
        struct vrblk *cdlab;		/* if failure exit is a simple label	*/
        char 		 *cdnof;		/* no failure exit (-nofail mode)		*/
        mword		  cddir;		/* failure exit is complex or direct	*/
    }			cdfal;			/* failure exit							*/
    mword			cdcod[1];		/* executable pseudo-code				*/
};


/*
 * name block
 *
 * a name block (nmblk) is used whereever a name must be stored as
 * a value following use of the unary dot operator.
 */

struct nmblk {
    mword			nmtyp;		  	/* type word (nmblk)					*/
    union block	   *nmbas;			/* base pointer for variable			*/
    mword			nmofs;			/* offset within block for variable		*/
};


/*
 * table block
 *
 * a table block (tbblk) is used to represent a table value.
 * it comprises a list of buckets, each of which may point to
 * a chain of teblks.  tbbuk entries either point to the first
 * teblk on the chain or they point to the tbblk itself to
 * indicate the end of the chain.  the number of buckets can
 * be deduced from tblen.
 */

struct tbblk {
    mword			tbtyp;			/* type word (tbblk)					*/
    mword			tbidv;			/* identifier value						*/
    mword			tblen;			/* length of tbblk in bytes				*/
    union block	   *tbinv; 			/* default initial lookup value			*/
    struct teblk   *tbbuk[1];		/* start of hash bucket pointers		*/
};


/*
 * table element block
 *
 * a table element (teblk) is used to represent a single entry in
 * a table.
 */

struct teblk {
    mword			teblk;			/* type word (teblk)					*/
    union block	   *tesub;			/* subscript value						*/
    union block    *teval;			/* table element value					*/
    struct teblk   *tenxt;			/* next teblk or tbblk if end of chain	*/
};


/*
 * variable block
 *
 * a variable block (vrblk) is used to hold a program variable.
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
 * vector block
 *
 * a vector block (vcblk) is used to represent an array value which has
 * one dimension whose lower bound is one. all other arrays are
 * represented by arblks.  the number of elements can be deduced
 * from vclen.
 */

struct vcblk {
    mword			vctyp;			/* type word (vcblk)					*/
    mword			vcidv;			/* identifier value						*/
    mword			vclen;			/* length of vcblk in bytes				*/
    union block	   *vcvls[1];		/* start of vector values				*/
};


/*
 * union of all blocks
 *
 * a block is merely a union of all the block types enumerated here.
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
