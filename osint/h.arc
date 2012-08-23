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
   Definitions of SPITBOL data blocks available to C-language
   external functions to be called from 32-bit versions of SPITBOL.

   SPITBOL BLOCKS

   All SPITBOL objects are encapsulated into blocks of memory.
   The first word of each block identifies the block type in a
   curious way.  Rather than containing a simple integer type
   code, it contains the address of a subroutine that performs
   some particular action on the block, such as placing it on
   the stack.  Because each block type uses a different subroutine,
   the subroutine addresses serve as a type identifier.


   Each subroutine is proceeded in memory by a one-byte (Intel platforms)
   or one-word (all other platforms) integer type code (given below).
   Thus to obtain a simple ordinal type code for a block pointed to by an
   address in pblk, use the following:

   block        *pblk;
   unsigned     typecode;
     ...
    typecode = *((unsigned char *)((long)pblk - 1)); (Intel platform)
    typecode = *((unsigned *)((long)pblk - 4));      (Sun, RS/6000, SGI, etc.)


   Here's a visualization of how SPITBOL stores data blocks and identifies
   their type by pointing to unique sections of code:


     In Data Space:                        In Code Space:
   +---------------------+               +-----------+
   |      Type Word      |----+          | Type code |
   +---------------------+    |          +-----------+----------------+
   |      Block Data     |    +--------->|   Program Code for this    |
 *...                   ...              |   Block Type               |
   |                     |               |                            |
   +---------------------+               +----------------------------+


   Given an integer type, the Type Word can be obtained by
   looking it up in a table provided to external functions as ptyptab in
   the misc info structure.  For example, if the locator information
   structure is passed to the function as an argument called "info",
   use the following:

   unsigned typecode;
   mword        typeword;
    ...
     typeword = (*info.ptyptab)[typecode];
 */

/*
   BLOCK CODES FOR ACCESSIBLE DATATYPES

   These blocks may appear in an argument list if left untranslated
   by the LOAD function definition.
 */

enum {
    BL_AR =     0,                              /* ARBLK        ARRAY                                                           */
    BL_CD,                                      /* CDBLK        CODE                                                            */
    BL_EX,                                      /* EXBLK        EXPRESSION                                                      */
    BL_IC,                                      /* ICBLK        INTEGER                                                         */
    BL_NM,                                      /* NMBLK        NAME                                                            */
    BL_P0,                                      /* P0BLK        PATTERN, 0 args                                         */
    BL_P1,                                      /* P1BLK        PATTERN, 1 arg                                          */
    BL_P2,                                      /* P2BLK        PATTERN, 2 args                                         */
    BL_RC,                                      /* RCBLK        REAL                                                            */
    BL_SC,                                      /* SCBLK        STRING                                                          */
    BL_SE,                                      /* SEBLK        EXPRESSION                                                      */
    BL_TB,                                      /* TBBLK        TABLE                                                           */
    BL_VC,                                      /* VCBLK        VECTOR (array)                                          */
    BL_XN,                                      /* XNBLK        EXTERNAL, non-relocatable contents      */
    BL_XR,                                      /* XRBLK        EXTERNAL, relocatable contents          */
    BL_BC,                                      /* BCBLK        BUFFER CONTROL                                          */
    BL_PD,                                      /* PDBLK        PROGRAM DEFINED DATATYPE                        */
    BL__D                                       /* NUMBER OF BLOCK CODES FOR DATA                               */
};

/*
   OTHER BLOCK CODES

   These blocks will never appear in an argument list, but are
   listed here for completeness.
 */

enum {
    BL_TR = BL__D,                      /* TRBLK        TRACE                                                   */
    BL_BF,                                      /* BFBLK        BUFFER                                                  */
    BL_CC,                                      /* CCBLK        CODE CONSTRUCTION                               */
    BL_CM,                                      /* CMBLK        COMPILER TREE NODE                              */
    BL_CT,                                      /* CTBLK        CHARACTER TABLE                                 */
    BL_DF,                                      /* DFBLK        DATATYPE FUNCTION                               */
    BL_EF,                                      /* EFBLK        EXTERNAL FUNCTION                               */
    BL_EV,                                      /* EVBLK        EXPRESSION VARIABLE                             */
    BL_FF,                                      /* FFBLK        FIELD FUNCTION                                  */
    BL_KV,                                      /* KVBLK        KEYWORD VARIABLE                                */
    BL_PF,                                      /* PFBLK        PROGRAM-DEFINED FUNCTION                */
    BL_TE                                       /* TEBLK        TABLE ELEMENT                                   */
};

/*
   Structure of common SPITBOL blocks:
            Integer, Real, String, and File blocks.

        These structures are part of the "blocks" union that can be applied
            to the result area to determine where to store required return
        information.
 */

/*
        Structure of ICBLK (integers)
 */

struct icblk {
    mword       ictyp;                                  /* type word                                            */
    mword       icval;                                  /* integer value                                        */
};


/*
                Structure of RCBLK (reals)
 */
#if sparc
/*
                Note that the obvious declaration "double rcval" can not be
        used, because the SPARC C compiler insists on placing double
                values on an 8-byte boundary, effectively making the rcblk into
                a four-word structure, instead of three. (A filler word is
                inserted between rctyp and rcval).  But an rcblk really is a
                three-word structure inside of SPITBOL.

                As a workaround, we define rcvals as a two word array, and use
                an rcval macro to access the double value there.  The macro
                is invoked with the rcblk as its argument.  For example,
                suppose presult pointed to a union of all block types.  The
                double value stored in an rcblk there would be accessed as

                        rcval(presult->rcb)

                It may be necessary to use the -misalign command option with
                cc to have the compiler generate the two single-precision loads
                needed to access the real at rcvals.  The normal double-precision
                load will fault because the operand is not aligned properly.

        See function retreal in extrnlib.c for an example.
 */
struct rcblk {
    mword       rctyp;                                  /* type word                                            */
    mword       rcvals[2];                              /* real value (not 8-byte aligned!)     */
};
#define rcval(blk) (*(double *)blk.rcvals) /* access double at rcvals   */
#else
struct rcblk {
    mword       rctyp;                                  /* type word                                            */
    double      rcval;                                  /* real value (not 8-byte aligned!)     */
};
#endif

/*
        Structure of SCBLK (strings)
 */

struct scblk {
    mword       sctyp;                                  /* type word                                            */
    mword       sclen;                                  /* string length                                        */
    char        scstr[1];                               /* start of string                                      */
};

/*
        Structure for returning a far string
 */

struct fsblk {
    mword       fstyp;                                  /* type word                                            */
    mword       fslen;                                  /* string length                                        */
    far char *fsptr;                            /* far pointer to string                                */
};


/*
        Structure for returning a far external block
 */

struct fxblk {
    mword       fxtyp;                                  /* type word                                            */
    mword       fxlen;                                  /* external data length                         */
    far void *fxptr;                            /* far pointer to external data                 */
};


/*
   FILE CONTROL BLOCK

   The user may provide the word "FILE" for any argument in
   the LOAD function prototype.  When a call is made to the
   external function with an I/O associated variable in this argument
   position, SPITBOL will provide a pointer to the file control
   block instead of the value of the variable.

   The file control block (FCB) points to an I/O block with
   additional information.  In turn, the I/O block points to any
   buffer used by the file.

   This block is obtained for every file except those associated
   with INPUT, OUTPUT, or TERMINAL.  Note that these FCB's are
   unrelated to MS-DOS FCB's.  File control blocks do not have
   their own type word, but appear as XRBLKs with the following structure:
 */

struct fcblk {
    mword                       fcbtyp;                 /* type word (XRBLK)                            */
    mword                       fcblen;                 /* size of block, in bytes                      */
    mword                       fcbrsz;                 /* SPITBOL record size and mode
                                                                           positive if text mode,
                                                                           negative if binary.                          */
    struct ioblk   *fcbiob;                     /* pointer to IOBLK                                     */
    mword                       fcbmod;                 /* 1 if text mode, 0 if binary mode     */
};


/*
     CHFCB - chain of FCBs block

     For every FCB created by OSINT, the compiler creates a CHFCB pointing
     to the FCB and links it onto a chain of CHFCBs.  At EOJ the head of this
     CHFCB chain is passed to the interface function SYSEJ so that all files
     can be closed.
 */

struct  chfcb {
    mword       typ;                            /*  type word                   */
    mword       len;                            /*  block length                */
    struct      chfcb *nxt;                     /*  pointer to next chfcb       */
    struct      fcblk *fcp;                     /*  pointer to fcb              */
};



/*
   I/O BLOCK

   An I/O block is pointed to by the fcbiob field of a file control block.
 */

struct ioblk {
    mword                       iobtyp;                 /* type word (XRBLK)                            */
    mword                       ioblen;                 /* size of IOBLK in bytes                       */
    struct scblk   *iobfnm;                     /* SCBLK holding filename                       */
    mword                       iobpid;                 /* pipe id (not used for DOS)           */
    struct bfbblk  *iobbfb;         /* pointer to BFBBLK                */
    mword                       iobfdn;                 /* O/S file descriptor number           */
    mword                       iobflg1;                /* flags 1 (see below)                          */
    mword                       iobflg2;                /* flags 2 (see below)                          */
    mword                       iobeol1;                /* end of line character 1                      */
    mword                       iobeol2;                /* end of line character 2                      */
    mword                       iobshare;               /* sharing mode                                         */
    mword                       iobaction;              /* file open actions                            */
};

/*
        Bits in iobflg1 dword
 */
#define IO_INP  0x00000001                      /* input file                                                   */
#define IO_OUP  0x00000002                      /* output file                                                  */
#define IO_APP  0x00000004                      /* append output to existing file               */
#define IO_OPN  0x00000008                      /* file is open                                                 */
#define IO_COT  0x00000010                      /* console output to non-disk device    */
#define IO_CIN  0x00000020                      /* console input from non-disk device   */
#define IO_SYS  0x00000040                      /* -f option used instead of name               */
#define IO_WRC  0x00000080                      /* output without buffering                             */

/*
        Bits in iobflg2 dword
 */
#define IO_PIP  0x00000001                      /* pipe (not used in MS-DOS)                    */
#define IO_DED  0x00000002                      /* dead pipe (not used in MS-DOS)               */
#define IO_ILL  0x00000004                      /* illegal I/O association                              */
#define IO_RAW  0x00000008                      /* binary I/O to character device                       */
#define IO_LF   0x00000010                      /* ignore line feed if next character   */
#define IO_NOE  0x00000020                      /* no echo input                                                */
#define IO_ENV  0x00000040                      /* filearg1 mapped via environment var  */
#define IO_DIR  0x00000080                  /* buffer is dirty (needs to be written)*/
#define IO_BIN  0x00000100                      /* binary I/O */

/* Private flags used to convey sharing status when opening a file */
#define IO_COMPATIBILITY        0x00
#define IO_DENY_READWRITE       0x01
#define IO_DENY_WRITE           0x02
#define IO_DENY_READ            0x03
#define IO_DENY_NONE            0x04
#define IO_DENY_MASK            0x07            /* mask for above deny mode bits*/
#define IO_EXECUTABLE           0x40            /* file to be marked executable */
#define IO_PRIVATE                      0x80            /* file is private to current process */

/* Private flags used to convey file open actions */
#define IO_FAIL_IF_EXISTS               0x00
#define IO_OPEN_IF_EXISTS               0x01
#define IO_REPLACE_IF_EXISTS    0x02
#define IO_FAIL_IF_NOT_EXIST    0x00
#define IO_CREATE_IF_NOT_EXIST  0x10
#define IO_EXIST_ACTION_MASK    0x13    /* mask for above bits */
#define IO_WRITE_THRU           0x20    /* writes complete before return*/

/*
   I/O BUFFER BLOCK

   An I/O buffer block (BFBBLK) is pointed to by an IOBLK.

   Size of file position words in I/O buffer block
 */

#if SETREAL
typedef double FILEPOS;     /* real file positions */
#else
typedef long FILEPOS;       /* 32-bit file positions */
#endif

struct bfbblk {
    mword       bfbtyp;                                 /* type word (XNBLK)                                    */
    mword       bfblen;                                 /* size of BFBBLK, in bytes                             */
    mword       bfbsiz;                                 /* size of buffer in bytes                              */
    mword       bfbfil;                                 /* number of bytes currently in buffer  */
    mword       bfbnxt;                                 /* offset of next buffer char to r/w    */
    FILEPOS bfboff;                 /* file position of first byte in buf   */
    FILEPOS bfbcur;                 /* physical file position               */
    char        bfbbuf[1];                              /* start of buffer                                              */
};


/*
   Structure of EFBLK (external function).  A pointer to this block
   is passed to the external function in the stack in info.pefblk.
 */

struct efblk {
    mword                       fcode;                  /* type word                                                    */
    mword               fargs;                  /* number of arguments                                  */
    mword                       eflen;                  /* block length                                                 */
    mword                       efuse;                  /* usage count                                                  */
    struct xnblk   *efcod;                      /* pointer to XNBLK, see below                  */
    struct vrblk   *efvar;                      /* pointer to VRBLK with function name  */
    mword                       efrsl;                  /* result type  (see below)                             */
    mword                       eftar[1];               /* array of argument types, one per arg */
};

/*
   efrsl and eftar[] contain small integer type codes as follows:
 */

#define noconv  0                                       /* argument remains unconverted                 */
#define constr  1                                       /* convert argument to string                   */
#define conint  2                                       /* convert argument to integer                  */
#define conreal 3                                       /* convert argument to real                             */
#define confile 4                                       /* produce fcb associated with variable */


/*
   Structure of XNBLK allocated for external function
   A pointer to this structure is passed to the external function
   in the stack in pxnblk.

   This structure is used to ways:
     1.  As a general structure in which the user can place private
                 data and have it maintained by SPITBOL.

     2.  As a particular structure in which information about each
                 external function is maintained.
 */

struct xnblk {
    mword       xntyp;                                  /* type word                                                    */
    mword       xnlen;                                  /* length of this block                                 */
    union {                                                     /* two uses for rest of block:                  */
        mword   xndta[1];                       /* 1. user defined data starts here             */
        struct ef {                 /* 2. external function info            */
#if WINNT | sparc | aix
            void   *xnhand;         /*    module handle                     */
            mword  (*xnpfn) Params((void));  /*    pointer to function entry         */
            mword       xn1st;                  /*    non-zero = first-ever call                */
            mword       xnsave;                 /*    non-zero = first call after reload*/
            void   (*xncbp) Params((void));  /*    callback function prior to exiting*/
#else
            mword   xnoff;          /*    base offset of function image     */
            mword   xnsiz;          /*    size of function in bytes         */
            mword   xneip;          /*    transfer EIP                      */
            short       xncs;                   /*    transfer CS                                               */
            mword   xnesp;          /*    transfer ESP, 0 = SPITBOL's stack */
            short       xnss;                   /*        transfer SS, 0 = SPITBOL's stack      */
            short       xnds;                   /*        transfer DS                                           */
            short       xnes;                   /*        transfer ES                                           */
            short       xnfs;                   /*        transfer FS                                           */
            short       xngs;                   /*        transfer GS                                           */
            short       xn1st;                  /*    non-zero = first-ever call                */
            short       xnsave;                 /*    non-zero = first call after reload*/
            far void (*xncbp)(void);/*    callback function prior to exiting*/
            short       xnpad;                  /*    pad to dword boundary                             */
#endif
        } ef;
    } xnu;
};

/*
   Simplified access to xn1st and xnsave words in xnblk via pointer to
   miscellaneous info area in pinfo.
 */

#define first_call ((*((*pinfo).pxnblk)).xnu.ef.xn1st)
#define reload_call ((*((*pinfo).pxnblk)).xnu.ef.xnsave)


/*
   Other selected blocks of interest:


   ARRAY BLOCK

   An array block (ARBLK) represents an array value other than one
   with one dimension whose lower bound is one (see VCBLK).
 */

struct arblk1 {                                         /* One dimensional array                                */
    mword                       arblk;                  /* type word (ARBLK)                    */
    mword                       aridv;                  /* identifier value                                             */
    mword                       arlen;                  /* length of ARBLK in bytes                             */
    mword                       arofs;                  /* offset in arblk to arpro field               */
    mword                       arndm;                  /* number of dimensions                                 */
    mword                       arlbd;                  /* low bound (first subscript)                  */
    mword                       ardim;                  /* dimension (first subscript)                  */
    struct scblk   *arpro;                      /* array prototype string                               */
    union block    *arvls[1];           /* start of values in row-wise order    */
};

struct arblk2 {                                         /* Two dimensional array                                */
    mword                       arblk;                  /* type word (ARBLK)                    */
    mword                       aridv;                  /* identifier value                                             */
    mword                       arlen;                  /* length of ARBLK in bytes                             */
    mword                       arofs;                  /* offset in arblk to arpro field               */
    mword                       arndm;                  /* number of dimensions                                 */
    mword                       arlbd;                  /* low bound (first subscript)                  */
    mword                       ardim;                  /* dimension (first subscript)                  */
    mword                       arlb2;                  /* low bound (second subscript)                 */
    mword                       ardm2;                  /* dimension (second subscript)                 */
    struct scblk   *arpro;                      /* array prototype string                               */
    union block    *arvls[1];           /* start of values in row-wise order    */
};

#define ndim    3                                       /* For example, 3-dimensional array             */
struct arblkn {                                         /* N-dimensional array                                  */
    mword                       arblk;                  /* type word (ARBLK)                    */
    mword                       aridv;                  /* identifier value                                             */
    mword                       arlen;                  /* length of ARBLK in bytes                             */
    mword                       arofs;                  /* offset in arblk to arpro field               */
    mword                       arndm;                  /* number of dimensions                                 */
    struct {
        mword   arlbd;                          /* low bound (first subscript)                  */
        mword   ardim;                          /* dimension (first subscript)                  */
    }                   bounds[ndim];   /* adjust for number of dimensions              */
    struct scblk   *arpro;              /* array prototype string                               */
    union block    *arvls[1];           /* start of values in row-wise order    */
};


/*
        BUFFER CONTROL BLOCK

        A buffer control block (BCBLK) is created by the BUFFER
        function, and serves as an indirect control header for the
        buffer. It contains the number of characters currently
        stored in the buffer.
 */
struct bcblk {
    mword       bctyp;                                  /* type word                                                    */
    mword       bcidv;                                  /* identifier value                                             */
    mword       bclen;                                  /* number of chars in use in bfblk              */
    mword       bcbuf;                                  /* pointer to bfblk                                             */
};


/*
        STRING BUFFER BLOCK

        A string buffer block (BFBLK) contains the actual buffer
        memory area. It specifies the largest string that can be
        stored in the buffer.
 */
struct bfblk {
    mword       bftyp;                                  /* type word                                                    */
    mword       bfalc;                                  /* allocated size of buffer                             */
    char        bfchr[1];                               /* characters of string                                 */
};


/*
   CODE BLOCK

   A code block (CDBLK) is present for every source statement.
 */

struct cdblk {
    mword                       cdjmp;                  /* ptr to routine to execute statement  */
    mword                       cdstm;                  /* statement number                                             */
    mword                       cdsln;                  /* source file line number                              */
    mword                       cdlen;                  /* length of CDBLK in bytes                             */
    union {
        struct cdblk *cdnxt;            /* if failure exit is next statement    */
        struct vrblk *cdlab;            /* if failure exit is a simple label    */
        char             *cdnof;                /* no failure exit (-NOFAIL mode)               */
        mword             cddir;                /* failure exit is complex or direct    */
    }                   cdfal;                  /* Failure exit                                                 */
    mword                       cdcod[1];               /* executable pseudo-code                               */
};


/*
   NAME BLOCK

   A name block (NMBLK) is used whereever a name must be stored as
   a value following use of the unary dot operator.
 */

struct nmblk {
    mword                       nmtyp;                  /* type word (NMBLK)                                    */
    union block    *nmbas;                      /* base pointer for variable                    */
    mword                       nmofs;                  /* offset within block for variable             */
};


/*
   TABLE BLOCK

   A table block (TBBLK) is used to represent a table value.
   It comprises a list of buckets, each of which may point to
   a chain of TEBLKs.  TBBUK entries either point to the first
   TEBLK on the chain or they point to the TBBLK itself to
   indicate the end of the chain.  The number of buckets can
   be deduced from tblen.
 */

struct tbblk {
    mword                       tbtyp;                  /* type word (TBBLK)                                    */
    mword                       tbidv;                  /* identifier value                                             */
    mword                       tblen;                  /* length of TBBLK in bytes                             */
    union block    *tbinv;                      /* default initial lookup value                 */
    struct teblk   *tbbuk[1];           /* start of hash bucket pointers                */
};


/*
   TABLE ELEMENT BLOCK

   A table element (TEBLK) is used to represent a single entry in
   a table.
 */

struct teblk {
    mword                       teblk;                  /* type word (TEBLK)                                    */
    union block    *tesub;                      /* subscript value                                              */
    union block    *teval;                      /* table element value                                  */
    struct teblk   *tenxt;                      /* next TEBLK or TBBLK if end of chain  */
};


/*
   VARIABLE BLOCK

   A variable block (VRBLK) is used to hold a program variable.
 */

struct vrblk {
    mword                       vrget;                  /* routine to load variable onto stack  */
    mword                       vrsto;                  /* routine to store stack top into var. */
    union block     *vrval;                     /* variable value                                               */
    mword                       vrtra;                  /* routine to transfer to label                 */
    union block    *vrlbl;                      /* pointer to code for label                    */
    union block    *vrfnc;                      /* function block if name is function   */
    struct vrblk   *vrnxt;                      /* next vrblk on hash chain                             */
    mword                       vrlen;                  /* length of name                                               */
    char                        vrchs[1];               /* characters of name                                   */
};


/*
   VECTOR BLOCK

   A vector block (VCBLK) is used to represent an array value which has
   one dimension whose lower bound is one. All other arrays are
   represented by ARBLKs.  The number of elements can be deduced
   from vclen.
 */

struct vcblk {
    mword                       vctyp;                  /* type word (VCBLK)                                    */
    mword                       vcidv;                  /* identifier value                                             */
    mword                       vclen;                  /* length of vcblk in bytes                             */
    union block    *vcvls[1];           /* start of vector values                               */
};


/*
   UNION OF ALL BLOCKS

   A block is merely a union of all the block types enumerated here.

 */

union block {
    struct arblk1       arb1;
    struct arblk2       arb2;
    struct arblkn       arbn;
    struct bcblk        bcb;
    struct bfblk        bfb;
    struct cdblk        cdb;
    struct efblk        efb;
    struct fcblk        fcb;
    struct fsblk        fsb;
    struct fxblk        fxb;
    struct icblk        icb;
    struct ioblk        iob;
    struct nmblk        nmb;
    struct rcblk        rcb;
    struct scblk        scb;
    struct tbblk        tbb;
    struct teblk        teb;
    struct vcblk        vcb;
    struct vrblk        vrb;
    struct xnblk        xnb;
};

#endif
/*------------------------  end of blocks32.h  ------------------------------*/
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
    Definitions of routines and data available to C-language
    external function to be called from 32-bit versions of SPITBOL.

    Definition of information placed on stack prior to pushing arguments to
    an external function.

    Many of these items can be ignored, and are provided only for the
    benefit of those wishing to operate directly on SPITBOL's internal
    data structures.

    However, the pointer in presult *must* be used by the external
    function to locate the area in which results are returned.

 */

#include "system.h"
typedef int mword;                              /* minimal word */
typedef unsigned int muword;    /* minimal unsigned word        */
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

#define _pascal           /* Available under Borland, but don't use it now. */
#if WINNT && __BORLANDC__
#define entry(x) mword _pascal __export x
#elif WINNT && _MSC_VER
#define entry(x) mword _pascal __declspec(dllexport) x
#else
#define entry(x) mword _pascal x
#endif

#include "blocks32.h"
#include <string.h>


/* array of pointers to double functions */
typedef double (*APDF[])();


/*
   Miscellaneous information provided by SPITBOL in pointer above the arguments.
 */

typedef struct misc {
    short                        vers;                  /* version number of interface                  */
    unsigned char        ext;                   /* host environment, see ext_type below */
    unsigned char        spare;                 /* reserved                                                     */
    mword                        nargs;             /* number of args to function                       */
    mword                  (*ptyptab)[];        /* pointer to table of data types               */
    struct xnblk        *pxnblk;            /* ptr to xnblk describing function         */
    struct efblk        *pefblk;                /* ptr to efblk describing function             */
    APDF            *pflttab;           /* ptr to array of floating point fncs  */
#if WINNT
    short            spds;          /* SPITBOL's DS segment selector        */
    short                        spcs;                  /* SPITBOL's CS segment selector                */
#endif
} misc;

enum ext_type {                                         /* Executing under:                                             */
    t_pharlap,                                          /*  PharLap DOS Extender                                */
    t_intel,                                            /*  Intel DOS Extender                                  */
    t_os2,                                                      /*  OS/2 2.0                                                    */
    t_tc16,                                                     /*  MS-DOS TurboC with 16-bit IA                */
    t_tc32,                                                     /*  MS-DOS TurboC with 32-bit IA                */
    t_w1616,                                            /*  16-bit Windows, 16-bit SPITBOL              */
    t_w1632,                                            /*  16-bit Windows, 32-bit SPITBOL              */
    t_wnt8,                                                     /*  Windows NT on 386/486                               */
    t_sparc,                                            /*  Sun 4 / SPARC                                               */
    t_mac,                                                      /*  Apple Macintosh                                             */
    t_mips,                                                     /*  MIPS R3000                                                  */
    t_rs6000,                       /*  IBM RS/6000                         */
    t_lnx8632,                      /*  Linux Intel x86 32-bit              */
    t_lnx8664                       /*  Linux Intel x86 64-bit              */
};

/*
   Sample usage.  Definition for function arguments, assuming
   calling function in SPITBOL with:

         F(INTEGER,REAL,STRING)

   Because SPITBOL pushes arguments left to right, a Pascal
   calling sequence should be used.  The could be supplied by
   adding the __pascal keyword to the entry macro.

   However, because the SPARC and RS/6000 C compilers do not support
   Pascal calling sequences, and we would like to move external function
   source files easily between systems, the function definition will have
   to manually reverse the arguments:
     entry(F)(presult, pinfo, parg3, larg3, rarg2, iarg1)
       union block         *presult;             pointer to result area
       misc                        *pinfo;                   miscellaneous info
       char                        *parg3;                       pointer to arg3 string
       mword                    larg3;                   arg3 length
       double                   rarg2;                   arg2 real number
       mword                    iarg1;                   arg1 integer
   {
      ....  start of function body
 */


/*
   Simple names for datatypes.  Performs a lookup in SPITBOL's type
   table to fetch a 32-bit type word for specific data types.
 */

#define ar      (*((*pinfo).ptyptab))[BL_AR]    /* Array                */
#define bc      (*((*pinfo).ptyptab))[BL_BC]    /* Buffer Control       */
#define bf      (*((*pinfo).ptyptab))[BL_BF]    /* String Buffer        */
#define cd      (*((*pinfo).ptyptab))[BL_CD]    /* Code                 */
#define ex      (*((*pinfo).ptyptab))[BL_EX]    /* Expression   */
#define ic      (*((*pinfo).ptyptab))[BL_IC]    /* Integer              */
#define nm      (*((*pinfo).ptyptab))[BL_NM]    /* Name                 */
#define rc      (*((*pinfo).ptyptab))[BL_RC]    /* Real                 */
#define sc      (*((*pinfo).ptyptab))[BL_SC]    /* String               */
#define tb      (*((*pinfo).ptyptab))[BL_TB]    /* Table                */
#define vc      (*((*pinfo).ptyptab))[BL_VC]    /* Vector               */
#define xn      (*((*pinfo).ptyptab))[BL_XN]    /* External             */


/*
   Non-standard block-type values that may be returned as a result:
 */

#define FAIL    (-1)                    /* Signal function failure      */
#define BL_NC   100                             /* Unconverted result           */
#define BL_FS   101                             /* Far string                           */
#define BL_FX   102                             /* Far external block           */

/*
   Length of string area in result buffer
 */

#define buflen  512


/*
   SPITBOL's Real Number Functions are not available to external
   functions coded in C.  Use the normal C floating point library
   to provide such support.
 */

/*
   Function definitions for routines in extrnlib.c
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
        Globals.h       All OSINT globals are defined in this file.

        Define GLOBALS in the C module that wishes to have these
        variables defined.  All other modules will see them as externals.
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
     Global data areas needed by compiler.
*/
NoInit( int             cmdcnt);                /*  command count                       */
NoInit( int             gblargc);               /*  argc from command line              */
NoInit( char    **gblargv);             /*  argv from command line              */
Init(   char    *uarg, 0);              /*  -u argument from command line       */

/*
    Information to be given to compiler
*/
Init(   uword   lnsppage, PAGE_DEPTH);  /*  lines per page for listings                 */
Init(   uword   pagewdth, PAGE_WIDTH);  /*  width of output line for listings   */
Init(   long    spitflag, DFLT_FLAGS);  /*  flags to be given to compiler               */

/*
    Memory variables that control compiler's dynamic area and stack.
*/
Init(   uword   memincb, CHUNK_B_SIZE); /*  meminc converted to bytes           */
Init(   uword   databts, HEAP_SIZE * sizeof(word));     /*  max size in bytes of data area      */
NoInit( char    *basemem);              /*  base of dynamic memory              */
NoInit( char    *topmem);               /*  current top of dynamic memory       */
NoInit( char    *maxmem);               /*  maximum top of dynamic memory       */
Init(   uword   maxsize, OBJECT_SIZE * sizeof(word));   /*  maximum size element in dyn. memory */
Init(   uword   stacksiz, STACK_SIZE);  /*  maximum size of stack in bytes      */
NoInit( char    *lowsp);                        /*  lowest legal sp value               */

/*
    Variables that describe access to standard input and output files.
*/
Init(   int             inpcnt, 0);             /*  number of input files                       */
Init(   char    **inpptr, 0);   /*  pointer to input file in argv array */
NoInit( char    *outptr);               /*  pointer to output listing file      */
Init(   char    *sfn, 0);               /*  current source file name            */
Init(   int     readshell0, 1);         /*  interlock default reading of fd 0   */
Init(   int     first_record, 2);       /*  non-zero before first record read   */
Init(   int     executing, 0);          /*  non-zero during execution           */
Init(   int     originp, -1);           /*  dup of original fd 0                        */
Init(   int     curfile, 0);            /*  current file position (swcinp)      */
Init(   int     errflag, 0);            /*  Nonzero if error in swcoup          */
Init(   int     origoup, 1);            /*  Dup of shell's std output (swcoup)  */
Init(   int     oupState, 0);           /*  Current state of swcoup                     */
Init(   int     nesting, 0);            /*  depth of include file nesting       */
NoInit( int     dcdone);                        /*  if zysdc has written headlines      */
Init(   int     provide_name, 1);       /*  sysrd to deliver filename to caller */
NoInit( char   *pathptr);               /*  include file paths                          */

NoInit( word    bfblksize);
NoInit( struct ioblk    *save_iob);
Init(   word in_gbcol, 0);              /* record whether in GBCOL or not */
Init(   int mallocSys, 0);              /* Kludgy Intel interlock with malloc and free */
Init(   int first_time, -1);    /* Flag for systm.c */
NoInit( long    start_time);    /* record start-up time for systm.c */
NoInit( char    savexl);                /* used by syshs.c */
NoInit( char    savexr);
NoInit( int             inc_fd[INCLUDE_DEPTH]); /* used by sysif.c      */
NoInit( int             fd);                                    /*  "    "   "          */
NoInit( FILEPOS inc_pos[INCLUDE_DEPTH]);/*      "        "       "              */

Init(   word    maxf, -1);              /* number of files specified this way -1 */

/*
        Structure to record i/o files specified on command line
        with /#=filename.
*/
#define Ncmdf   12

typedef struct {
    word        filenum;
    char        *fileptr;
} CFile;
NoInit( CFile   cfiles[Ncmdf]); /* Array of structures to record info   */

#define ttyiobininit {0,    /* type word            */ \
    IRECSIZ,                /* length               */ \
        0,                                              /* filename                             */ \
        0,                                              /* process id                   */ \
        0,                                              /* tty BFBLK                    */ \
    STDERRFD,               /* file descriptor 2    */ \
    IO_INP+IO_OPN+IO_SYS+IO_CIN, /* flg1            */ \
        0,                                              /* flg2                                 */ \
        EOL1,                                   /* end of line char 1   */ \
        EOL2}                                   /* end of line char 2   */

#define ttyioboutinit {0,   /* type word            */ \
        ORECSIZ,                                /* length                               */ \
        0,                                              /* filename                             */ \
        0,                                              /* process id                   */ \
        0,                                              /* tty BFBLK                    */ \
    STDERRFD,               /* file descriptor 2    */ \
    IO_OUP+IO_OPN+IO_SYS+IO_COT+IO_WRC, /* flg1     */ \
        0,                                              /* flg2                                 */ \
        EOL1,                                   /* end of line char 1   */ \
        EOL2}                                   /* end of line char 2   */
Init(   struct ioblk ttyiobin, ttyiobininit);
Init(   struct ioblk ttyiobout, ttyioboutinit);

#define inpiobinit      {0,             /* type word                    */ \
        IRECSIZ,                                /* length                               */ \
        0,                                              /* filename                             */ \
        0,                                              /* process id                   */ \
        0,                                              /* std input BFBLK              */ \
        0,                                              /* file descriptor 0    */ \
        IO_INP+IO_OPN+IO_SYS,   /* flg1:                                */ \
        0,                                              /* flg2:                                */ \
        EOL1,                                   /* end of line char 1   */ \
        EOL2 }                                  /* end of line char 2   */
Init(   struct ioblk inpiob, inpiobinit);


#define outiobinit {0,          /* type word                    */ \
        ORECSIZ,                                /* length                               */ \
        0,                                              /* filename                             */ \
        0,                                              /* process id                   */ \
        0,                                              /* no BFBLK needed              */ \
        1,                                              /* file descriptor 1    */ \
        IO_OUP+IO_OPN+IO_SYS+IO_WRC,  /* flg1:                  */ \
        0,                                              /* flg2:                                */ \
        EOL1,                                   /* end of line char 1   */ \
        EOL2 }                                  /* end of line char 2   */
Init(   struct ioblk oupiob, outiobinit);

NoInit( char  namebuf[256]);
NoInit( int             save_fd0);              /* Hold current fd 0 for swcinp */

#if SAVEFILE
Init(   int expanding, 0);      /* non-zero if doing expansion */
Init(   int compressing, 0);    /* non-zero if doing expansion */
Init(   long extra, 0);
NoInit( int             bufcnt);
NoInit( unsigned char *bufptr);
NoInit( int             bit_count);
NoInit( unsigned long bit_buffer);
NoInit( short int *code_value);                         /* This is the code value array                 */
NoInit( short unsigned int *prefix_code);       /* This array holds the prefix codes    */
NoInit( unsigned char *append_character);       /* This array holds the appended chars  */
NoInit( unsigned char *decode_stack);           /* This array holds the decoded string  */
NoInit( unsigned char *buffer);                         /* Read/write buffer                                    */
#endif                                  /* SAVEFILE */

#if SAVEFILE | EXECFILE
NoInit( int             aoutfd);
NoInit(  FILEPOS  fp);
#endif                                  /* SAVEFILE | EXECFILE */

/*
    lmodstk is set when creating a load module.  On the subsequent
    execution of a load module, the presence of a non-zero value in
    lmodstk determines that the execution is indeed of a load module.

    For Intel DOS Extender, lmodstk provides the file position within
        the execution module where a save file begins.
*/
NoInit( word    *lmodstk);


/*
   Globals found in assembly language modules.

 */
extern int  reg_size;
extern int  hasfpu;
extern char cprtmsg[];
extern word reg_block;

#if ENGINE
/*
   Engine globals
 */
NoInit( word lastError);
#endif                                  /* ENGINE */
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
    File:  OSINT.H              Version:  01.01
    -------------------------------------------

    This header file defines the interface between the Macro SPITBOL compiler
    written in assembly langauge and the OS interface written in C.
    Communication between the two is handled via a set of global variables
    defined as externals below.
*/


/*
    Set up externals for all the compiler's registers.
*/

extern word     reg_cp, reg_wa, reg_wb, reg_wc, reg_xr, reg_xl, reg_xs;
extern IATYPE   reg_ia;
extern double reg_ra;
#if WINNT | SPARC
extern word reg_pc;
#endif

/*
    Macros to deal with converting pointers within the Minimal heap
    to pointers that the C code can deal with.  On most systems, the
    two types of pointers are equivalent.  But on machines like the
    8088 or under Windows, the near pointers within the heap need to
    be converted to and from far pointers in the C data space.
 */
#if __NEAR__
extern void *mk_mp(void near *minp);
#define MK_MP(minp,type) ((type)mk_mp((void near *)(minp)))
#define MP_OFF(cp,type) ((type)(void NEAR *)(cp))
#else                                   /* __NEAR__ */
#define MK_MP(minp,type) ((type)(minp))
#define MP_OFF(cp,type) ((type)cp)
#endif                                  /* __NEAR__ */

/*
    Macros to fetch a value of appropriate type from a compiler register
*/

#if __NEAR__
#define CP(type)        (sizeof(type) == 4 ? MK_MP(reg_cp,type) : ((type) reg_cp))
#define IA(type)        ((type) reg_ia)
#define WA(type)        (sizeof(type) == 4 ? MK_MP(reg_wa,type) : ((type) reg_wa))
#define WB(type)        (sizeof(type) == 4 ? MK_MP(reg_wb,type) : ((type) reg_wb))
#define WC(type)        (sizeof(type) == 4 ? MK_MP(reg_wc,type) : ((type) reg_wc))
#define XR(type)        (sizeof(type) == 4 ? MK_MP(reg_xr,type) : ((type) reg_xr))
#define XL(type)        (sizeof(type) == 4 ? MK_MP(reg_xl,type) : ((type) reg_xl))
#define PC(type)        (sizeof(type) == 4 ? MK_MP(reg_pc,type) : ((type) reg_pc))
#define XS(type)        (sizeof(type) == 4 ? MK_MP(reg_xs,type) : ((type) reg_xs))
#define RA(type)  (sizeof(type) == 8 ? MK_MP(reg_ra,type) : ((type) reg_ra))
#else         /* __NEAR__ */
#define CP(type)        ((type) reg_cp)
#define IA(type)        ((type) reg_ia)
#define WA(type)        ((type) reg_wa)
#define WB(type)        ((type) reg_wb)
#define WC(type)        ((type) reg_wc)
#define XR(type)        ((type) reg_xr)
#define XL(type)        ((type) reg_xl)
#define PC(type)        ((type) reg_pc)
#define XS(type)        ((type) reg_xs)
#define RA(type)  ((type) reg_ra)    /* v1.30.12 */
#endif          /* __NEAR__ */
/*
    Macros to set a value of appropriate type into a compiler register.
*/
#define SET_CP(val)     (reg_cp = (word) (val))
#define SET_IA(val)     (reg_ia = (val))
#define SET_WA(val)     (reg_wa = (word) (val))
#define SET_WB(val)     (reg_wb = (word) (val))
#define SET_WC(val)     (reg_wc = (word) (val))
#define SET_XR(val)     (reg_xr = (word) (val))
#define SET_XL(val)     (reg_xl = (word) (val))
#define SET_PC(val)     (reg_pc = (word) (val))
#define SET_XS(val)     (reg_xs = (word) (val))
#define SET_RA(val)  (reg_ra = (double) (val))

/*
    Return values to take exit N from interface
*/
#define EXIT_1          0
#define EXIT_2          4
#define EXIT_3          8
#define EXIT_4          12
#define EXIT_5          16
#define EXIT_6          20
#define EXIT_7          24
#define EXIT_8          28
#define EXIT_9          32

/*
     Return value to do a normal return from interface.
*/
#define NORMAL_RETURN   (-1)

/*
        Function to call into minimal code.
        The argument is an ordinal number defined below.
*/
extern void minimal_call Params((word callno));
extern void popregs Params((void));
extern void pushregs Params((void));
#define MINIMAL_CALL(cn) minimal_call(cn)
#define MINSAVE() pushregs()
#define MINRESTORE() popregs()

/*
        Ordinals for minimal calls from C.

    The order of entries here must correspond to the order of
    table entries in the INTER assembly language module.
*/
enum calltab {
    relaj_callid,
    relcr_callid,
    reloc_callid,
    alloc_callid,
    alocs_callid,
    alost_callid,
    blkln_callid,
    insta_callid,
    rstrt_callid,
    start_callid,
    filnm_callid,
    dtype_callid,
    enevs_callid,
    engts_callid
};

/*
        Function and macro to get/set value from/to minimal dataspace.
        The argument is an ordinal number defined below.
    GET_DATA_OFFSET returns the address of a Minimal data value.
    GET_CODE_OFFSET returns the address of a Minimal routine.
        GET_MIN_VALUE returns the contents of an item of Minimal data.
        SET_MIN_VALUE sets the contents of an item of Minimal data.
*/
#if direcT
#define GET_CODE_OFFSET(vn,type) ((type)vn)
#define GET_DATA_OFFSET(vn,type) ((type)&vn)
#define GET_MIN_VALUE(vn,type) ((type)vn)
#define SET_MIN_VALUE(vn,val,type) (*(type *)&vn = (type)(val))
/*
    Names for accessing minimal data values via GET_DATA_OFFSET macro.
*/
extern word
gbcnt,
headv,
mxlen,
stage,
timsx,
dnamb,
dnamp,
state,
stbas,
statb,
polct,
typet,
lowspmin,
flprt,
flptr,
gtcef,
hshtb,
pmhbs,
r_fcb,
c_aaa,
c_yyy,
g_aaa,
w_yyy,
r_cod,
kvstn,
kvdmp,
kvftr,
kvcom,
kvpfl,
cswfl,
stmcs,
stmct,
ticblk,
tscblk,
id1,
id2blk,
inpbuf,
ttybuf,
end_min_data;

/*
    Names for accessing minimal code values via GET_CODE_OFFSET macro.
*/
extern void     B_EFC();
extern void     B_ICL();
extern void B_RCL();
extern void B_SCL();
extern void     B_VCT();
extern void     B_XNT();
extern void     B_XRT();
extern void     DFFNC();
extern void     S_AAA();
extern void     S_YYY();

#else                                   /* DIRECT */
extern  word *minoff Params((word valno));
#define GET_CODE_OFFSET(vn,type) ((type)minoff(vn))
#define GET_DATA_OFFSET(vn,type) ((type)minoff(vn))
#define GET_MIN_VALUE(vn,type)  ((type)*minoff(vn))
#define SET_MIN_VALUE(vn,val,type) (*(type *)minoff(vn) = (type)(val))
/*
    Ordinals for accessing minimal values.

    The order of entries here must correspond to the order of
    valtab entries in the INTER assembly language module.
*/
enum valtab {
    gbcnt,
    headv,
    mxlen,
    stage,
    timsx,
    dnamb,
    dnamp,
    state,
    b_efc,
    b_icl,
    b_scl,
    b_vct,
    b_xnt,
    b_xrt,
    stbas,
    statb,
    polct,
    typet,
    dffnc,
    lowspmin,
    flprt,
    flptr,
    gtcef,
    hshtb,
    pmhbs,
    r_fcb,
    c_aaa,
    c_yyy,
    g_aaa,
    w_yyy,
    s_aaa,
    s_yyy,
    r_cod,
    kvstn,
    kvdmp,
    kvftr,
    kvcom,
    kvpfl,
    cswfl,
    stmcs,
    stmct,
    ticblk,
    tscblk,
    id1,
    id2blk,
    inpbuf,
    ttybuf,
    b_rcl,
    end_min_data
};

#endif                                  /* DIRECT */

/* Some shorthand notations */
#define pID1 GET_DATA_OFFSET(id1,struct scblk *)
#define pID2BLK GET_DATA_OFFSET(id2blk,struct scblk *)
#define pINPBUF GET_DATA_OFFSET(inpbuf,struct bfblk *)
#define pTTYBUF GET_DATA_OFFSET(ttybuf,struct bfblk *)
#define pTICBLK GET_DATA_OFFSET(ticblk,struct icblk *)
#define pTSCBLK GET_DATA_OFFSET(tscblk,struct scblk *)

#define TYPE_EFC GET_CODE_OFFSET(b_efc,word)
#define TYPE_ICL GET_CODE_OFFSET(b_icl,word)
#define TYPE_SCL GET_CODE_OFFSET(b_scl,word)
#define TYPE_VCT GET_CODE_OFFSET(b_vct,word)
#define TYPE_XNT GET_CODE_OFFSET(b_xnt,word)
#define TYPE_XRT GET_CODE_OFFSET(b_xrt,word)
#define TYPE_RCL GET_CODE_OFFSET(b_rcl,word)

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
    File:  PORT.H   (SPITBOL)   Version:  01.11
    ---------------------------------------------------

    This header file contains manifest constants that describe system
    dependencies.  Many of these values will be changed when porting
    the OS interface to another machine/operating system.
*/
#include "systype.h"

/*
        Turn off system-specific features unless specifically called for
        in systype.h.
*/

#ifndef ALTCOMP
#define ALTCOMP         0       /* no alternate string comparison */
#endif

#ifndef DATECHECK
#define DATECHECK   0   /* no check for expiration date */
#endif

#ifndef ENGINE
#define ENGINE          0       /* not building engine version */
#endif

#ifndef EXECSAVE
#define EXECSAVE        0       /* executable modules via save files */
#endif

#ifndef EXTFUN
#define EXTFUN          0       /* no external functions */
#endif

#ifndef FLTHDWR
#define FLTHDWR         0       /* floating point hardware not present */
#endif

#ifndef HOST386
#define HOST386         0       /* no 80386 host functions */
#endif

#ifndef MATHHDWR
#define MATHHDWR        0       /* extended math hardware not present */
#endif

#ifndef RUNTIME
#define RUNTIME         0       /* not making runtime version */
#endif

#ifndef SAVEFILE
#define SAVEFILE        0       /* can't create save files */
#endif

#ifndef SETREAL
#define SETREAL     0   /* don't use reals for SET()  */
#endif

#ifndef USEQUIT
#define USEQUIT         0       /* use quit() to report errors instead of wrterr */
#endif

/*
        Turn on system-specific features unless specifically turned off
        in systype.h
 */
#ifndef DIRECT
#define DIRECT          1       /* access Minimal data directly */
#endif

#ifndef EXECFILE
#define EXECFILE        1       /* create executable modules */
#endif

#ifndef FLOAT
#define FLOAT           1       /* include floating point code */
#endif

#ifndef IO
#define IO                      1       /* include input/output code */
#endif

#ifndef MATH
#define MATH            1       /* include extended math (i.e., trig) code */
#endif

#ifndef PIPES
#define PIPES           1       /* include pipe code */
#endif

#ifndef POLLING
#define POLLING         1       /* enable polling of operating system */
#endif

#ifndef PROTOTYPES
#define PROTOTYPES      1       /* assume compiler can handle prototypes */
#endif

#ifndef USEFD0FD1
#define USEFD0FD1       1       /* use file descriptor 0 & 1 for stdio  */
#endif

/*
    Other defaulted values that may be overridden in systype.h
 */
#ifndef INTBITS
#define INTBITS         32                      /* assume int will be 32 bits */
#define MAXINT          0x7FFFFFFFL     /* maximum positive value in int */
#endif
#ifndef WORDBITS
#define WORDBITS        32                      /* assume word will be 32 bits */
#define MAXPOSWORD      0x7FFFFFFFL     /* maximum positive value in word */
#endif
#ifndef IABITS
#define IABITS      32          /* Integer accumulator (IA) width */
#endif



/*
    If not defined in systype.h, disable it here.
 */
/* compiler defs */
#ifndef BCC32
#define BCC32           0                       /* 32-bit Borland C++ 4.x */
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
#define RS6                     0
#endif
#ifndef SUN4
#define SUN4            0
#endif

/* operating system defs */
#ifndef AIX3
#define AIX3            0
#endif
#ifndef AIX4
#define AIX4            0
#endif
#ifndef BSD43
#define BSD43           0
#endif
#ifndef LINUX
#define LINUX       1
#endif
#ifndef SOLARIS
#define SOLARIS         0
#endif
#ifndef WINNT
#define WINNT           0
#endif

#if WINNT | GCCi32
#define SYSVERSION 0
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

#if EXECSAVE                    /* EXECSAVE requires EXECFILE & SAVEFILE on */
#undef EXECFILE
#undef SAVEFILE
#define EXECFILE        1
#define SAVEFILE        1
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

#define UNIX (AIX | BSD43 | LINUX | SOLARIS)

typedef int   word;
typedef unsigned int uword;

/* Size of integer accumulator */
#if IABITS==32
typedef long IATYPE;
#elif IABITS==64
typedef long long IATYPE;
#endif

/*
    Define the default end of line characters.  Use Unix definitions
    as the default.  Override in systype.h.
*/
#ifndef EOL1
#define EOL1    '\n'
#endif

#ifndef EOL2
#define EOL2    0
#endif

/*
   Define the data type returned by a call to signal()
 */
#if UNIX
#define SigType void
#else
#define SigType int
#endif

/*
    The following manifest constants define the page size used when the
    compiler produces a source listing.

    PAGE_DEPTH          number of lines to print on a page
    PAGE_WIDTH          number of characters to print on a line
                                        also the default record length for OUTPUT, TERMINAL
*/
#define PAGE_DEPTH  60
#define PAGE_WIDTH      120

/*
        The following constant defines the size of the code word for
        LZW compression of a save file.  See file compress.c.
*/
#if WORDBITS == 16
#define LZWBITS 10
#else
#define LZWBITS 12
#endif

/*
    The following manifest contants describe the constraints on the heap
    managed by the spitbol compiler.

    All values can be overriden via command line options.

    CHUNK_SIZE          the size of an allocation unit (chunk) used to
                    create the heap.  Defined in WORDS!

    CHUNK_B_SIZE        CHUNK_SIZE in bytes.

    HEAP_SIZE           the maximum size that spitbol's heap (dynamic area)
                    can become.  Defined in WORDS!

    OBJECT_SIZE         the maximum size of any object created in the heap.
                    Defined in WORDS!
        Note: It was necessary to reduce this value from 8M to 1M  because
    some DPMI hosts (like 386MAX) use much smaller
        starting address for data section.  4MB seems to be a good lowest
        common denominator so that Save files can move between all the
        different DPMI platforms.
*/

#if LINUX | WINNT | AIX | SOLARIS
#define CHUNK_SIZE      32768
#define CHUNK_B_SIZE    (CHUNK_SIZE * sizeof(word))
#define HEAP_SIZE       16777216        /* 16Mwords = 64Mbytes */
#if SUN4 | LINUX | WINNT | AIX
#define OBJECT_SIZE     1048576         /* 1 Mword = 4 Mbytes */
#else         /* SUN4 */
#define OBJECT_SIZE     16384
#endif
#endif

#if SUN
#define TEXT_START      8192
#endif

/*
    Define the maximum nesting allowed of INCLUDE files
 */
#define INCLUDE_DEPTH   9


/*
    Define the standard file ids
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
     Define number of SPITBOL statements to be executed between
     interface polling intervals.  Only used if POLLING is 1.
     Unix systems can get away with an infinite polling interval,
     because their interrupts are asynchronous, and do not require
     true polling.
 */
#ifndef PollCount
#if UNIX
#define PollCount MAXPOSWORD
#else         /* UNIX */
#define PollCount 2500
#endif          /* UNIX */
#endif                                  /* PollCount */


/*
     Define Params macro to use or ignore function prototypes.
 */
#if PROTOTYPES
#define Params(a) a
#else
#define Params(a) ()
#endif


/*
    The following manifest contant describes the constraints on the
    run-time stack.

    The value can be overriden via command line option.

    STACK_SIZE          the maximum size of the run-time stack.  Any attempt
                    to make the stack larger results in a stack overflow
                    error.  Defined in BYTES!
*/
#if LINUX | WINNT | AIX | SOLARIS
#define STACK_SIZE  (0x100000)      /* Set to 1MB 6/28/09 */
#endif


/*
    The following manifest constant defines the location of the host file
    which contains a one line description of the system environment under
    which spitbol is running.

    HOST_FILE           pathname for host text file used by function syshs
*/
#define HOST_FILE       "/usr/lib/spithost"

/*
    The following manifest constant defines the names the files created
    by the EXIT(3) and EXIT(-3) function.

    AOUT_FILE           pathname for load module created by sysxi
    SAVE_FILE           pathname for save file created by sysxi
*/
#define SAVE_FILE       "a.spx"
#if WINNT
#define AOUT_FILE       "a.exe"
#else
#define AOUT_FILE       "a.out"
#endif

/*
  PSEP is the separator between multiple paths.
  FSEP is the separator between directories in a path.
  EXT is separator between name and extension.
  COMPEXT is extension for source files.
  EFNEXT is extension for external functions.
  RUNEXT is extension for save files.
  BINEXT is extension for load modules
*/

#if UNIX
#define PSEP  ':'
#define PSEP2 ' '
#define FSEP '/'
#endif

#if WINNT
#define PSEP ';'
#define FSEP '\\'
#define FSEP2 '/'
#endif          /* WINNT */

#define EXT '.'
#if WINNT
#define BINEXT ".exe"
#else
#define BINEXT ".out"
#endif
#define COMPEXT ".spt"
#define EFNEXT ".slf"
#define LISTEXT ".lst"
#define RUNEXT ".spx"
#define SPITFILEPATH  "snolib"  /* path for include and external files */

/*
    The following manifest constant determines the maximum number of
    files that can be open at a time.

    OPEN_FILES          the maximum number of files that can be open at
                        a time.  Used by function ospipe to close files
                        given by a parent process to a child process.
*/
#define OPEN_FILES      32

/*
    The following manifest constants determines the size of the temporary
    SCBLKs defined by the interface.

    TSCBLK_LENGTH       the maximum length of a string that can be stored
                    in structure 'tscblk'.  'tscblk' is defined in
                    file inter.s.

    ID2BLK_LENGTH       the maximum length of a string that can be stored
                    in structure 'id2blk'.  'id2blk' is defined in
                    inter.c.  ID2BLK_LENGTH should be long enough
                    to hold the computer name type string (htype)
                    plus the date/time and a few blanks (typically
                    20 characters).  It should also be a multiple of
                    the word size.

*/
#ifndef TSCBLK_LENGTH
#define TSCBLK_LENGTH   512
#endif
#define ID2BLK_LENGTH   52

/*
    The following manifest constants determine the default environment
    variable name for the shell and it

    SHELL_ENV_NAME      the name under which then shell path is stored
                    in the environment

    SHELL_PATH          a default shell to use in event one cannot be
                    located in the environment
*/

#if WINNT             /* WINNT */
extern char borland32rtm;             /* True if using DOS Extender */
extern char isWin95;                  /* True if running under WinNT */
#define SHELL_ENV_NAME  "COMSPEC"
#define SHELL_PATH  ((borland32rtm || isWin95) ? "command.com" : "cmd.exe")
#else                   /* WINNT */
#define SHELL_ENV_NAME  "SHELL"
#define SHELL_PATH      "/bin/sh"
#endif          /* WINNT */

/*
    Compiler flags (see compiler listing for more details):

    ERRORS      send errors to terminal
    PRTICH      terminal is standard output file
    NOLIST      suppress compilation listing
    NOCMPS      suppress compilation statistics
    NOEXCS      suppress execution statistics
    LNGLST      generate long listing (WITH page ejects)
    NOEXEC      suppress program execution
    TRMNAL      support terminal i/o association
    STDLST      standard listing (intermediate)
    NOHDER      suppress spitbol compiler header
    PRINTC      list control cards
    WRTEXE      write executable module after compilation
    CASFLD      fold upper and lower case names
    NOFAIL      no fail mode

    DFLT_FLAGS  reasonable defaults for UN*X environment
*/

#define ERRORS          0x00000001L
#define PRTICH          0x00000002L
#define NOLIST          0x00000004L
#define NOCMPS          0x00000008L
#define NOEXCS          0x00000010L
#define LNGLST          0x00000020L
#define NOEXEC          0x00000040L
#define TRMNAL          0x00000080L
#define STDLST          0x00000100L
#define NOHEDR          0x00000200L
#define PRINTC          0x00000400L
#define NOERRO          0x00000800L
#define CASFLD          0x00001000L
#define NOFAIL          0x00002000L
#define WRTEXE          0x00004000L
#define WRTSAV          0x00008000L

#define NOBRAG          0x02000000L     /*      No signon header when loading save file */

#define DFLT_FLAGS  (ERRORS+PRTICH+NOLIST+NOCMPS+NOEXCS+TRMNAL+PRINTC+CASFLD+NOERRO)

#define _Optlink

#define const

#include "osint.h"

#ifdef PRIVATEBLOCKS
#if WINNT | SUN4 | AIX | LINUX
#include "extern32.h"
#endif          /* WINNT | SUN4 */
#else                                   /* PRIVATEBLOCKS */
#include "spitblks.h"
#include "spitio.h"
#endif                                  /* PRIVATEBLOCKS */


#include "globals.h"
#include "sproto.h"

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
        File:   SAVE.H           Version 1.01
        -------------------------------------

        This header file provides information for writing the impure
        portions of SPITBOL's data segments to a save file.

  v1.01 3-Jun-91 MBE
        Added memincb, maxsize, readshell0 & uarg to header, and
        additional argument to specify whether these values should
        override existing values, as would be the case for the
        Intel MS-DOS version, where Save files are used to simulate
        Exec files.

*/
#if SAVEFILE
/*
   +--------2--------+--------2--------+---------4---------+
   |                 |                 |                   |
   |     IA size     |    WORD size    | Save File Version |
   |                 |                 |                   |
   +-----------------+-----------------+-------------------+

   IA (integer accumulator) and Minimal Word Size:
    0 - 16 bits
    1 - 32 bits
    2 - 64 bits
    3 - 128 bits
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
#endif                                  /* SAVEFILE */

#if WINNT
#define PAGESIZE        4096
#define L2PGSZ          12              /* Log base 2 of page size */
#endif

#if SUN4
#define PAGESIZE        PAGSIZ
#define T_START     SEGSIZ   /* N_MAGIC, no dynamic loading */
#endif                                  /* SUN4 */

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
    File:  SPITBLKS.H           Version:  01.01
    -------------------------------------------

    This header file defines structures used by the Macro SPITBOL compiler
    that are passed into the OS interface.
*/

/*
    First, define the C type word to be the same size as a word used
    by the Macro SPITBOL compiler.  The type of a word is a signed
    integer for now.
*/

/*
        BUFFER CONTROL BLOCK

        A buffer control block (BCBLK) is created by the BUFFER
        function, and serves as an indirect control header for the
        buffer. It contains the number of characters currently
        stored in the buffer.
 */
struct bcblk {
    word        typ;                                    /* type word                                                    */
    word        idv;                                    /* identifier value                                             */
    word        len;                                    /* number of chars in use in bfblk              */
    struct bsblk *bcbuf;                        /* pointer to bfblk                                             */
};

/*
        STRING BUFFER BLOCK

        A string buffer block (BFBLK) contains the actual buffer
        memory area. It specifies the largest string that can be
        stored in the buffer.
 */
struct bsblk {
    word        typ;                                    /* type word                                                    */
    word        bsalc;                                  /* allocated size of buffer                             */
    char        bschr[1];                               /* characters of string                                 */
};


/*
   CODE BLOCK

   A code block (CDBLK) is present for every source statement.
 */

struct cdblk {
    word                        cdjmp;                  /* ptr to routine to execute statement  */
    word                        cdstm;                  /* statement number                                             */
    word                        cdsln;                  /* source file line number                              */
    word                        cdlen;                  /* length of CDBLK in bytes                             */
    union {
        struct cdblk NEAR *cdnxt;       /* if failure exit is next statement    */
        struct vrblk NEAR *cdlab;       /* if failure exit is a simple label    */
        char             NEAR *cdnof;   /* no failure exit (-NOFAIL mode)               */
        word              cddir;                /* failure exit is complex or direct    */
    }                   cdfal;                  /* Failure exit                                                 */
    word                        cdcod[1];               /* executable pseudo-code                               */
};


/*
    CHFCB - chain of FCBs block

    For every FCB created by OSINT, the compiler creates a CHFCB pointing
    to the FCB and links it onto a chain of CHFCBs.  At EOJ the head of this
    CHFCB chain is passed to the interface function SYSEJ so that all files
    can be closed.
*/

struct  chfcb {
    word        typ;                            /*  type word                   */
    word        len;                            /*  block length                */
    struct      chfcb NEAR *nxt;        /*  pointer to next chfcb       */
    struct      fcblk NEAR *fcp;        /*  pointer to fcb              */
};


/*
    EFBLK - external function block

*/

struct  efblk {
    word        fcode;                          /*  type word                   */
    word        fargs;                          /*  number of arguments */
    word        eflen;                          /*  block length                */
    word        efuse;                          /*  usage count                 */
    void NEAR *efcod;                   /*  pointer to XNBLK    */
    struct vrblk NEAR *efvar;   /*  pointer to VRBLK    */
    word        efrsl;                          /*  result type                 */
    word        eftar[1];                       /*  argument types              */
};

/*
    ICBLK - integer block

    Integer values are stored in ICBLKs.  Field icval should be defined
    to be the appropriate type for the implementation.
*/

struct  icblk {
    word        typ;            /*  type word - b$icl           */
    IATYPE      val;
};

/*
        RCBLK - real block

        Real values are stored in RCBLKs.  Field rcval should be defined
        to be the appropriate type for the implementation.
*/

struct  rcblk {
    word        typ;            /*      type word - b$rcl */
    double      rcval;          /*      real value */
};

/*
    SCBLK - string block

    String values are stored in SCBLKs.  Notice that the scstr field
    is defined as an array of characters of length 1.  This is a slight
    kludge to side-step C's lack of support for varying length strings.

    The actual length of a SCBLK is 2 words + the number of words necessary
    to hold a string of length sclen.
*/

struct  scblk {
    word        typ;            /*  type word - b$scl           */
    word        len;            /*  string length               */
    char        str[1];         /*  string characters           */
};


/*
   VARIABLE BLOCK

   A variable block (VRBLK) is used to hold a program variable.
 */

struct vrblk {
    word                        vrget;                  /* routine to load variable onto stack  */
    word                        vrsto;                  /* routine to store stack top into var. */
    union block  NEAR *vrval;           /* variable value                                               */
    word                        vrtra;                  /* routine to transfer to label                 */
    union block  NEAR *vrlbl;           /* pointer to code for label                    */
    union block  NEAR *vrfnc;           /* function block if name is function   */
    struct vrblk NEAR *vrnxt;           /* next vrblk on hash chain                             */
    word                        vrlen;                  /* length of name                                               */
    char                        vrchs[1];               /* characters of name                                   */
};




/*
        BLOCK - an arbitrary block
*/

union block {
    struct bcblk        bcb;
    struct bsblk        bsb;
    struct cdblk        cdb;
    struct chfcb        fcb;
    struct efblk        efb;
    struct icblk        icb;
    struct rcblk        rcb;
    struct scblk        scb;
    struct vrblk        vrb;
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
    File:  SPITIO.H     Version:  01.09
    -------------------------------------------

    This header file defines the I/O control blocks used by the
    operating system interface for the Macro Spitbol compiler.

*/

/* Size of file position words in I/O buffer block */
#if SETREAL
typedef double FILEPOS;     /* real file positions */
#else
typedef long FILEPOS;       /* 32-bit file positions */
#endif

/*
    BLBLK - I/O buffer block

    All buffered I/O is passed through a BFBLK.  This block is intentionally
    kept non-relocatable, so that it can be freely moved around the heap by
    the garbage collector.

        WARNING:  INPBUF and TTYBUF are manually assembled into inter.asm and
                          inter.s, and must be changed in all versions if this structure
                          is altered.
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
    char        buf[sizeof(word)]; /* buffer ([sizeof(word)] is kludge for C) */
};

#define BFSIZE          (sizeof( struct bfblk ) - sizeof( word ))

/*
    FCBLK - file control block (type XRBLK)

    For every I/O association a FCBLK is created.  All subsequent I/O
    operations are passed this block.
*/

struct fcblk
{
    word        typ;                    /*  type word                                   */
    word        len;                    /*  length of fcblk                             */
    word        rsz;                    /*  record size                                 */
    struct ioblk NEAR *iob;     /*  pointer to IOBLK                    */
    word        mode;                   /*  1=line mode, 0 = raw mode   */
};

#define FCSIZE          (sizeof( struct fcblk ))

/*
    IOBLK - I/O control block (type XRBLK)

    For every SPITBOL I/O channel there is one central IOBLK containing
    information about the channel:  filename, file descriptor, IOBLK
    pointer, etc.

    Because IOBLK is an XRBLK, and hence relocatable, all words in
    the block must be relocatable pointers, or smaller than MXLEN.
    Systems using 16-bit words typically use small MXLENs, and
    may cause values in the flg word to be mis-interpreted as pointers.
    For this reason, I/O flags will be split across two words.

*/

struct ioblk
{
    word        typ;                    /*  type word                           */
    word        len;                    /*  length of IOBLK                     */
    struct scblk NEAR *fnm;     /*  pointer to SCBLK holding filename   */
    word        pid;                    /*  process id for pipe                 */
    struct bfblk NEAR *bfb;     /*  pointer to BFBLK (type XNBLK)       */
    word        fdn;                    /*  file descriptor number              */
    word        flg1;                   /*  first nine flags                    */
    word        flg2;                   /*  second nine flags                   */
    word        eol1;                   /*  end of line character 1             */
    word        eol2;                   /*  end of line character 2             */
    word        share;                  /*      sharing mode                            */
    word        action;                 /*  file open actions                   */
};

#define IOSIZE          (sizeof( struct ioblk ))

/*
    I/O flags within the flg1 and flg2 words of an IOBLK.

    Caution:  Do not attempt to redefine as C bit fields.  Bit fields
    may be assigned to high-order bits on some systems, and this would
    produce values larger than MXLEN.
 */
/* Flags in flg1 */
#define IO_INP          0x00000001      /* file open for reading */
#define IO_OUP          0x00000002      /* file open for writing */
#define IO_APP          0x00000004      /* append output to existing file */
#define IO_OPN          0x00000008      /* file is open */
#define IO_COT          0x00000010      /* console output to non-disk device */
#define IO_CIN          0x00000020      /* console input from non-disk device */
#define IO_SYS          0x00000040      /* -f option used instead of name */
#define IO_WRC          0x00000080      /* output without buffering */
#define IO_EOT          0x00000100      /* Ignore end-of-text (control-Z) char */

/* Flags in flg2 */
#define IO_PIP          0x00000001      /* pipe */
#define IO_DED          0x00000002      /* dead pipe */
#define IO_ILL          0x00000004      /* illegal I/O association */
#define IO_RAW          0x00000008      /* binary I/O to TTY device */
#define IO_LF           0x00000010      /* Ignore eol2 if next character (pipes only) */
#define IO_NOE          0x00000020      /* no echo input */
#define IO_ENV          0x00000040      /* filearg1 maps to filename thru environment var */
#define IO_DIR          0x00000080      /* buffer is dirty (needs to be written) */
#define IO_BIN          0x00000100      /* last fcb to open file used raw mode */

#ifndef  IRECSIZ
#define  IRECSIZ        1024            /* input line length */
#endif

#define  ORECSIZ        ((word)MAXPOSWORD)      /* output line length */

#define  IOBUFSIZ       1024

/* Private flags used to convey sharing status when opening a file */
#define IO_COMPATIBILITY        0x00
#define IO_DENY_READWRITE       0x01
#define IO_DENY_WRITE           0x02
#define IO_DENY_READ            0x03
#define IO_DENY_NONE            0x04
#define IO_DENY_MASK            0x07            /* mask for above deny mode bits*/
#define IO_EXECUTABLE           0x40            /* file to be marked executable */
#define IO_PRIVATE                      0x80            /* file is private to current process */

/* Private flags used to convey file open actions */
#define IO_FAIL_IF_EXISTS               0x00    /* file exists -- fail */
#define IO_OPEN_IF_EXISTS               0x01    /* file exists -- open */
#define IO_REPLACE_IF_EXISTS    0x02    /* file exists -- open and truncate */
#define IO_FAIL_IF_NOT_EXIST    0x00    /* file does not exist -- fail */
#define IO_CREATE_IF_NOT_EXIST  0x10    /* file does not exist -- create it */
#define IO_EXIST_ACTION_MASK    0x13    /* mask for above bits */
#define IO_WRITE_THRU           0x20    /* writes complete before return*/
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
        File:  SPROTO.H Version 1.02
        ----------------------------

        Function prototypes for argument type checking.
        This files are unique to SPITBOL.
*/

#ifndef _sproto_
#define _sproto_

typedef int File_handle;
typedef int File_mode;
typedef int Open_method;

extern  union block *   alloc Params((word nchars));
extern  struct scblk *  alocs Params((word nchars));
extern  union block *   alost Params((word nchars));
extern  int                     appendext Params((char *path, char *ext, char *result, int force));
extern  int                     arg2scb Params(( int req, int argc, char *argv[], struct scblk *scptr, int maxs ));
#if EXTFUN
extern  union block *   callef Params((struct efblk *efb, union block **sp, word nargs));
#endif
extern  int                     checkfpu Params(( void ));
extern  int                     checksave Params((char *namep));
extern  int                     checkstr Params(( struct scblk *scp ));
extern  int                     check2str Params(( void ));
extern  int                     check3str Params(( void ));
extern  int                     chrdev Params(( File_handle F ));
extern  int                     cindev Params(( File_handle F ));
extern  int                     cinread Params(( File_handle fd, char *buf, int size ));
extern  void            close_all Params(( struct chfcb *chb ));
extern  word            closeaout Params(( char *filename, char *tmpfnbuf, word errflag ));
extern  void            clrbuf Params(( void ));
extern  int                     compress Params(( unsigned char FAR *startadr, uword size ));
extern  void            conv Params(( char *dest, int value ));
extern  int                     coutdev Params(( File_handle F ));
extern  void            cpys2sc Params(( char *cp, struct scblk *scptr, word maxlen ));
extern  void            crlf Params(( void ));
extern  int                     docompress Params(( int bits, char *freeptr, uword size ));
extern  void            doexec Params(( struct scblk *scbptr ));
extern  int                     doexpand Params(( int bits, char *freeptr, uword size ));
extern   FILEPOS  doset Params(( struct ioblk *ioptr, FILEPOS offset, int whence ));
extern  int     dosys Params(( char *cmd, char *path ));
extern  void            endbrk Params((void));
extern  struct scblk *  enevs Params((struct scblk *inScblkPtr, word flag));
extern  struct scblk *  endtp Params((union block *inBlkPtr));
extern  struct scblk *  engts Params((union block *inBlkPtr));
extern  void            exephase Params((void));
extern  void            exeinput Params((void));
extern  void            __exit  Params((int code));
extern  int                     expand Params(( File_handle fd, unsigned char FAR *startadr, uword size ));
extern  word            fillbuf Params(( struct ioblk *ioptr ));
extern  char *          findenv Params(( char *vq, int vn ));
extern  int                     flush Params(( struct ioblk *ioptr ));
extern  void            flush_all Params((struct chfcb *chb));
extern   int         fsyncio Params((struct ioblk *ioptr));
extern  long            gencmp Params((char*, char*, long, long, long));
extern  word *          get_fp Params(( void ));
extern  char **         getargs Params((int argc, char *argv[]));
extern  double          get_ra Params(( void ));
extern   FILEPOS     geteof Params(( struct ioblk *ioptr ));
extern  void            gethost Params(( struct scblk *scptr, word maxlen ));
extern  int                     getint Params(( struct icblk *icp, IATYPE *pword ));
extern  char            *getnum Params(( char *cp, uword *ip ));
extern  File_handle     getprfd Params(( void ));
extern  struct ioblk *  getpriob Params(( void ));
extern  File_handle     getrdfd Params(( void ));
extern  struct ioblk *  getrdiob Params(( void ));
extern  int                     getsave Params((File_handle fd));
extern  char *          getshell Params(( void ));
extern  char *          getstring Params(( struct scblk *scp, char *cp ));
extern  void            gettype Params(( struct scblk *scptr, word maxlen ));
extern  char *          heapAlloc Params(( void *minAdr, word size ));
extern  void            heapmove  Params(( void ));
extern  int                     host386 Params(( int hostno ));
extern  int                     host88 Params(( int hostno ));
extern  int                     hostapl Params(( int hostno ));
extern  void            init_custom Params(( void ));
extern  void            initpath Params(( char *name ));
extern  word            lenfnm Params(( struct scblk *scptr ));
extern  int                     length Params(( char *cp ));
extern  void *          loadef Params((word fd, char *filename));
extern  long            lstrncmp Params((char*, char*, long, long));
extern  int                     _main Params(( int srcfd, int argc, char *argv[] ));
extern  int                     makeexec Params(( struct scblk *scptr, int type ));
extern  char        make_c_str Params(( char *p ));
extern  void            malloc_empty Params(( void ));
extern  int                     malloc_init Params(( word endadr ));
extern  long            moremem Params(( long n, char **pp ));
extern  char            *mystrcpy Params(( char *p, char *q));
extern  int                     mystrncpy Params(( char *p, char *q, int i));
extern  void *          nextef Params(( unsigned char FAR **bufp, int io ));
extern  void            numout Params(( unsigned n ));
extern  int                     openaout Params(( char *fn, char *tmpfnbuf, int exe ));
extern  int                     openexe Params((char *name));
extern  int                     optfile Params(( struct scblk *varname, struct scblk *result ));
extern  char            *optnum Params(( char *cp, uword *ip ));
extern  int                     osclose Params(( struct ioblk *ioptr ));
extern  int                     osopen Params(( struct ioblk *ioptr ));
extern  int         ospipe Params(( struct ioblk *ioptr ));
extern  word            osread Params(( word mode, word recsiz, struct ioblk *ioptr, struct scblk *scptr ));
extern  void        oswait Params(( int pid ));
extern  word        oswrite Params(( word mode, word linesiz, word recsiz, struct ioblk *ioptr, struct scblk *scptr ));
extern  void            oupeof Params(( void ));
extern  char *          pathlast Params(( char *path ));
extern  void            prompt Params(( void ));
extern  word            putsave Params((word *stkbase, word stklen));
extern  void            quit Params(( int errno ));
extern  void            rawmode Params(( File_handle F, int mode ));
extern  int                     rdaout Params(( File_handle fd, unsigned char FAR *startadr, uword size ));
extern  int                     rdenv Params(( struct scblk *varname, struct scblk *result ));
#ifndef readfar
extern  uword           readfar Params(( File_handle fd, void FAR *Buf, uword Cnt ));
#endif
extern  int                     renames Params((char *oldname, char *newname));
extern  void            rereloc Params(( void ));
extern  int                     resaout Params(( char *filename ));
extern  void            restart Params(( char *code, char *stack ));
extern  void            restore0 Params(( void ));
extern  void            restorestring Params((struct scblk *scp, word c));
extern  void            restore2str Params(( void ));
extern  void            restore3str Params(( void ));
extern  word            roundup Params((word n));
extern  void            save0 Params(( void ));
extern  word            saveend Params((word *stkbase, word stklen));
extern  long            savestart Params((File_handle fd, char *bufp, unsigned int size));
extern  char *          savestr Params(( struct scblk *scp, char *cp ));
extern  void            save2str Params(( char **s1p, char **s2p ));
extern  void            save3str Params(( char **s1p, char **s2p, char **s3p ));
extern  void            scanef Params(( void ));
extern  word            scnint Params(( char *str, word len, word *intptr ));
extern  int                     seekaout Params((long pagesize));
extern  void            set_ra Params((double f));
extern  void            setoptions Params((word flags));
extern  void            setout Params(( void ));
extern  void            setprfd Params(( File_handle fd ));
extern  void            setrdfd Params(( File_handle fd ));
extern  int                     sioarg Params(( int ioflg, struct ioblk *ioptr, struct scblk *scptr ));
extern  File_handle     spit_open Params(( char *Name, Open_method Method, File_mode Mode, int Access ));
extern  void            startbrk Params(( void ));
extern  void            startup Params(( char *code, char *stack ));
extern  int                     storedate Params(( char *cp, word maxlen ));
extern  int                     stcu_d Params(( char *out, unsigned int in, int outlen ));
extern  void            stdioinit Params(( void ));
extern  void            strout Params(( char *s ));
extern  int                     swcinp Params(( int filecnt, char **fileptr ));
extern  int                     swcoup Params(( char *oupptr ));
extern  void            termhost Params((void));
extern  int                     testty Params(( File_handle fd ));
extern  int                     tryopen Params(( char *cp ));
extern  int                     trypath Params(( char *name, char *file ));
extern  void        ttyoutfdn Params((File_handle h));
extern  void        ttyinit Params(( void ));
extern  void            ttyraw Params(( File_handle fd, int flag ));
extern  void            unldef Params((struct efblk *efb));
extern  void        unmake_c_str Params(( char *p, char saved_c));
extern  void            unreloc Params(( void ));
extern  word            uppercase Params(( word c ));
extern  word            wabs Params((word x));
#ifndef writefar
extern  uword           writefar Params(( File_handle fd, void FAR *Buf, uword Cnt ));
#endif
extern  int                     wrtaout Params(( unsigned char FAR *startadr, uword size ));
extern  void            wrterr Params(( char *s ));
extern  void            wrtint Params(( int));
extern  void            wrtmsg Params(( char *s ));
extern  int                     zysax Params(( void ));
extern  int                     zysbs Params(( void ));
extern  int                     zysbx Params(( void ));
extern  int                     zyscm Params(( void ));
extern  int                     zysdc Params(( void ));
extern  int                     zysdm Params(( void ));
extern  int                     zysdt Params(( void ));
extern  int                     zysea Params(( void ));
extern  int                     zysef Params(( void ));
extern  void            zysej Params(( void ));
extern  int                     zysem Params(( void ));
extern  int                     zysen Params(( void ));
extern  int                     zysep Params(( void ));
extern  int                     zysex Params(( void ));
extern  int                     zysfc Params(( void ));
extern  int                     zysgc Params(( void ));
extern  int                     zyshs Params(( void ));
extern  int                     zysid Params(( void ));
extern  int                     zysif Params(( void ));
extern  int                     zysil Params(( void ));
extern  int                     zysin Params(( void ));
extern  int                     zysio Params(( void ));
extern  int                     zysld Params(( void ));
extern  int                     zysmm Params(( void ));
extern  int                     zysmx Params(( void ));
extern  int                     zysou Params(( void ));
extern  int                     zyspi Params(( void ));
extern  int                     zyspl Params(( void ));
extern  int                     zyspp Params(( void ));
extern  int                     zyspr Params(( void ));
extern  int                     zysrd Params(( void ));
extern  int                     zysri Params(( void ));
extern  int                     zysrw Params(( void ));
extern  int                     zysst Params(( void ));
extern  int                     zystm Params(( void ));
extern  int                     zystt Params(( void ));
extern  int                     zysul Params(( void ));
extern  int                     zysxi Params(( void ));

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
extern  int             brkx Params(( void *addr ));
extern  void            *sbrkx Params(( long incr ));
#endif

#else
extern  int         access Params((char *Name, int mode));
extern  int             brk Params(( void *addr ));
extern  int             close Params(( File_handle F ));
extern  File_handle     dup Params(( File_handle F ));
extern  char * _Optlink getenv Params(( char *name ));
#if WINNT && _MSC_VER
#define LSEEK lseeki64
#else
#define LSEEK lseek
#endif
extern   FILEPOS  LSEEK Params(( File_handle F, FILEPOS Loc, int Method ));
extern  word            read Params(( File_handle F, void *Buf, uword Cnt ));
extern  void            *sbrk Params(( long incr ));
extern  int                     unlink Params(( char *Name ));
extern  word            write Params(( File_handle F, void *Buf, uword Cnt ));
#endif

#endif
!@#$system.h
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

/* ------------------------- system.h ------------------------------- */

/*
   Define system type.
 */

#define gcc32  1
#define gcc64  0
#define gcc    (gcc32 | gcc64)

!@#$systype.h
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
    The following manifest constants define the target hardware platform
    and tool chain.

                running on a:
    BCC32       Intel 32-bit x86, Borland C++ compiler (Windows command line)
    VCC         Intel 32-bit x86, Microsoft Visual C (Windows command line)
    GCCi32      Intel 32-bit x86, GNU GCC
    GCCi64      Intel 64-bit x86, GNU GCC
    RS6         IBM RS6000 (Power)
    SUN4        SPARC, SUN4

    The following manifest constants define the target operating system.

    AIX3        AIX version 3
    AIX4        AIX version 4
    BSD43       Berkeley release: BSD 4.3
    LINUX       Linux
    SOLARIS     Sun Solaris
    WINNT       Windows NT/XP/Vista

*/

/* Override default values in port.h.  It is necessary for a user configuring
   SPITBOL to examine all the default values in port.h and override those
   that need to be altered.
 */
/*  Values for x86 Linux 32-bit SPITBOL.
 */
#define EXECFILE    0
#define FLTHDWR     0   /* Change to 1 when do floating ops inline */
#define GCCi32      1
#define LINUX       1
#define SAVEFILE    1


