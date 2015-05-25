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

/************************************************************************\
*                                                                        *
*  syslinux - Unique Linux code for SPITBOL              *
*                                                                        *
\************************************************************************/

#define PRIVATEBLOCKS 1
#include "port.h"
#include <stdlib.h>
#include <fcntl.h>
#undef brk  // remove sproto redefinition
#undef sbrk // remove sproto redefinition
//#include <malloc.h>

// Size and offset of fields of a structure.  Probably not portable.
#define FIELDSIZE(str, fld) (sizeof(((str *)0)->fld))
#define FIELDOFFSET(str, fld) ((unsigned long)(char *)&(((str *)0)->fld))


#if EXTFUN
#include <dlfcn.h>

typedef struct xnblk XFNode, *pXFNode;
typedef mword (*PFN)();				// pointer to function

static union block *scanp;			// used by scanef/nextef
static pXFNode xnfree = (pXFNode)0;	// list of freed blocks

extern long f_2_i (double ra);
extern double i_2_f (long ia);
extern double f_add (double arg, double ra);
extern double f_sub (double arg, double ra);
extern double f_mul (double arg, double ra);
extern double f_div (double arg, double ra);
extern double f_neg (double ra);
extern double f_atn (double ra);
extern double f_chp (double ra);
extern double f_cos (double ra);
extern double f_etx (double ra);
extern double f_lnf (double ra);
extern double f_sin (double ra);
extern double f_sqr (double ra);
extern double f_tan (double ra);

static APDF flttab = {
    (double (*)())f_2_i,			// float to integer
    i_2_f,							// integer to float
    f_add,							// floating add
    f_sub,							// floating subtract
    f_mul,							// floating multiply
    f_div,							// floating divide
    f_neg,							// floating negage
    f_atn,							// arc tangent
    f_chp,							// chop
    f_cos,							// cosine
    f_etx,							// exponential
    f_lnf,							// natural log
    f_sin,							// sine
    f_sqr,							// square root
    f_tan							// tangent
};

misc miscinfo = {0x105,				// internal version number
                 GCCi32 ? t_lnx8632 : t_lnx8664,           // environment
                 0,								// spare
                 0,								// number of arguments
                 0,								// pointer to type table
                 0,								// pointer to XNBLK
                 0,								// pointer to EFBLK
                 (APDF *)flttab,					// pointer to flttab
                };

/* Assembly-language helper needed for final linkage to function:
 */
extern mword callextfun (struct efblk *efb, union block **sp, mword nargs, mword nbytes);


/*
 * callef - procedure to call external function.
 *
 *	result = callef(efptr, xsp, nargs)
 *
 *	   efptr	pointer to efblk
 *	   xsp		pointer to arguments+4 (artifact of machines with return link on stack)
 *	   nargs	number of arguments
 *	   result	 0 - function should fail
 *				-1 - insufficient memory to convert arg (not used)
 *				     or function not found.
 *				-2 - improper argument type (not used)
 *				other - block pointer to function result
 *
 * Called from sysex.c.
 *
 */
union block *callef(efb, sp, nargs)
        struct efblk *efb;
union block **sp;
mword nargs;
{
    register pXFNode pnode;
    union block *result;
    static initsels = 0;
    static mword (*pTYPET)[];
    mword type, length;
    mword nbytes, i;
    char *p;
    char *q;
    mword *r;
    mword *s;

    pnode = ((pXFNode) (efb->efcod));
    if (pnode == NULL)
        return (union block *)-1L;

    if (!initsels) {						// one-time initializations
        pTYPET = (mword (*)[])GET_DATA_OFFSET(TYPET,muword);
        miscinfo.ptyptab = pTYPET;		// pointer to table of data types
        initsels++;
    }

    miscinfo.pefblk = efb;				// save efblk ptr in misc area
    miscinfo.pxnblk = pnode;
    miscinfo.nargs = nargs;

    /* Fiddle the xn1st and xnsave words in the xnblk.  If either is zero,
     * it is left alone.  If either is non-zero, it is decremented.  This
     * has the effect of providing the function with a 1 or a 0 if this is
     * the first call or a subsequent call respectively.
     */
    if (pnode->xnu.ef.xn1st)
        pnode->xnu.ef.xn1st--;
    if (pnode->xnu.ef.xnsave)
        pnode->xnu.ef.xnsave--;

    /* Count number of stack words needed for arguments during actual call.
     * No Convert (type 0), Integer (type 2), and File (type 4) need one mword,
     * String (type 1) and Real (type 3) need two words.
     * While a switch statement would be a cleaner way to write the following
     * code, for speed reasons, we directly take advantage of the fact that
     * only odd-numbered argument types need two words.
     */
    nbytes = (nargs+2) * sizeof(mword) +	// presult, pinfo + args (1 mword each)
             MINFRAME-ARGPUSHSIZE;		// in/local save area + struct-ret adr

    for (i = nargs; i--; )
        if (efb->eftar[i] & 1)			// type 1 and type 3 require
            nbytes += sizeof(mword);		// two words each on stack

    /* For SPARC, the number of words reserved for arguments on the stack
     * must be six or greater, and must be even (stack pointer must be
     * 8-byte aligned).  (Note that real args occupy two stack words.)
     *
     *	high memory	|							|
     * 				|---------------------------|
     * 				|	 arg n-6 (if needed)	|
     * 				|---------------------------|
     * 	arg i		|	 arg n-5 (if needed)	|
     * 	refers		|---------------------------|  -------------------------
     * 	to SPITBOL	|	 arg n-4 (if needed)	|                    ^
     * 	arguments	|===========================|  ---------         |
     * 	in the		|  arg n-3 = %i5 dump word	|      ^             |
     * 	external	|---------------------------|      |             |
     * 	function	|  arg n-2 = %i4 dump word	|      |             |
     * 	call		|---------------------------|      |
     * 				|  arg n-1 = %i3 dump word	|      |         minimum to
     * 				|---------------------------|      |      preserve 8-byte
     * 				|    arg n = %i2 dump word	|      |         alignment
     * 				|---------------------------|      |
     *				| &miscinf = %i1 dump word  |                    |
     *				|---------------------------|   required         |
     *				|  &result = %i0 dump word  |                    |
     * 				|---------------------------|      |             |
     * 				| struct-ret adr (not used) |      |             |
     * 				|---------------------------|      |             |
     * 				|							|      |             |
     * 				|	 16 words to save		|      |             |
     * 				|	in/local regs when		|      |             |
     * 				|	  save overflows		|      |             |
     * 				|							|      v             v
     * 	low memory	|===========================| --------------------------
     *
     */
    if (nbytes < MINFRAME)
        nbytes = MINFRAME;

    type = callextfun(efb, sp-1, nargs, SA(nbytes));	// make call with Stack Aligned nbytes

    result = (union block *)ptscblk;
    switch (type) {

    case BL_XN:						// XNBLK    external block
        result->xnb.xnlen = ((result->xnb.xnlen + sizeof(mword) - 1) &
                             -sizeof(mword)) + FIELDOFFSET(struct xnblk, xnu.xndta[0]);
    case BL_AR:	 					// ARBLK	array
    case BL_CD:						// CDBLK	code
    case BL_EX:						// EXBLK	expression
    case BL_IC:						// ICBLK	integer
    case BL_NM:						// NMBLK	name
    case BL_P0:						// P0BLK	pattern, 0 args
    case BL_P1:						// P1BLK	pattern, 1 arg
    case BL_P2:						// P2BLK	pattern, 2 args
    case BL_RC:						// RCBLK	real
    case BL_SC:						// SCBLK	string
    case BL_SE:						// SEBLK	expression
    case BL_TB:						// TBBLK	table
    case BL_VC:						// VCBLK	vector (array)
    case BL_XR:						// XRBLK	external, relocatable contents
    case BL_PD:						// PDBLK	program defined datatype
        result->scb.sctyp = (*pTYPET)[type];
        break;

    case BL_NC:	 					// return result block unchanged
        break;

    case BL_FS:						// string pointer at tscblk.str
        result->fsb.fstyp = (*pTYPET)[BL_SC];
        p = result->fsb.fsptr;
        length = result->fsb.fslen;
        if (!length)
            break;						// return null string result
        MINSAVE();
        SET_WA(length);
        MINIMAL(MINIMAL_ALOCS);				// allocate string storage
        result = XR(union block *);
        MINRESTORE();
        q = result->scb.scstr;
        while (length--)
            *q++ = *p++;
        break;

    case BL_FX:						// pointer to external data at tscblk.str
        length = ((result->fxb.fxlen + sizeof(mword) - 1) &
                  -sizeof(mword)) + FIELDOFFSET(struct xnblk, xnu.xndta[0]);
        if (length > GET_MIN_VALUE(mxlen,mword)) {
            result = (union block *)0;
            break;
        }
        r = result->fxb.fxptr;
        MINSAVE();
        SET_WA(length);
        MINIMAL(MINIMAL_ALLOC);				// allocate block storage
        result = XR(union block *);
        MINRESTORE();
        result->xnb.xnlen = length;
        result->xnb.xntyp = (*pTYPET)[BL_XN];
        s = result->xnb.xnu.xndta;
        length = (length - FIELDOFFSET(struct xnblk, xnu.xndta[0])) / sizeof(mword);
        while (length--)
            *s++ = *r++;
        break;

    case FAIL:						// fail
    default:
        result = (union block *)0;
        break;
    }
    return result;
}

/* Attempt to load a DLL into memory using the name provided.
 *
 * The name may either be a fully-qualified pathname, or just a module
 * (function) name.
 *
 * If the DLL is found, its handle is returned as the function result.
 * Further, the function name provided is looked up in the DLL module,
 * and the address of the function is returned in *ppfnProcAddress.
 *
 * Returns -1 if module or function not found.
 *
 */
mword loadDll(dllName, fcnName, ppfnProcAddress)
char *dllName;
char *fcnName;
PFN *ppfnProcAddress;
{
    void *handle;
    PFN pfn;

#ifdef RTLD_NOW
    handle = dlopen(dllName, RTLD_NOW);
#else
    handle = dlopen(dllName, RTLD_LAZY);
#endif
    if (!handle)
    {
        fcnName = dlerror();
        return -1;
    }

    *ppfnProcAddress = (PFN)dlsym(handle, fcnName);
    if (!*ppfnProcAddress) {
        dlclose(handle);
        return -1;
    }

    return (mword)handle;
}

/*
 * loadef - load external function
 *
 *	result = loadef(handle, pfnc)
 *
 *	Input:
 *	   handle	module handle of DLL (already in memory)
 *	   pfnc		pointer to function entry point in module
 *	Output:
 *	 result	 0 - I/O error
 *			-1 - function doesn't exist (not used)
 *			-2 - insufficient memory
 *			other - pointer to XNBLK that points in turn
 *			        to the loaded code (here as void *).
 */
void *loadef(fd, filename)
mword fd;
char *filename;
{
    void *handle = (void *)fd;
    PFN pfn = *(PFN *)filename;
    register pXFNode pnode;

    if (xnfree) {							// Are these any free nodes to use?
        pnode = xnfree;						// Yes, seize one
        xnfree = (pXFNode)pnode->xnu.ef.xnpfn;
    }
    else {
        MINSAVE();							// No
        SET_WA(sizeof(XFNode));
        MINIMAL(MINIMAL_ALOST);						// allocate from static region
        pnode = XR(pXFNode);					// get node to hold information
        MINRESTORE();
    }

    pnode->xntyp = TYPE_XNT;					// B_XNT type word
    pnode->xnlen = sizeof(XFNode);			// length of this block
    pnode->xnu.ef.xnhand = handle;			// record DLL handle
    pnode->xnu.ef.xnpfn = pfn;				// record function entry address
    pnode->xnu.ef.xn1st = 2;					// flag first call to function
    pnode->xnu.ef.xnsave = 0;				// not reload from save file
    pnode->xnu.ef.xncbp = (void far (*)())0; // no callback  declared
    return (void *)pnode;                    // Return node to store in EFBLK
}

/*
 * nextef - return next external function block.
 *
 * 		length = nextef(.bufp, io);
 *
 * Input:
 * bufp = address of pointer to be loaded with block pointer
 * io = -1 = scanning memory
 *		0 if loading functions
 *		1 if saving functions or exiting SPITBOL
 *
 * Note that under SPARC, it is not possible to save or reload
 * functions from the Save file. The user must explicitly re-execute
 * the LOAD() function to reload the DLL.
 *
 * Output:
 *  for io = -1:
 *		length = pointer to XNBLK
 *				 0 if done
 *		bufp   = pointer to EFBLK.
 *
 *  for io = 0,1:
 * 		length = length of function's memory block
 *	    		 0 if done
 *	    		 -1 if unable to allocate memory (io=0 only)
 *		bufp   = pointer to function body.
 *
 * When io = 1, we invoke any callback routine established by the
 * external function if it wants to be notified when SPITBOL is
 * shutting down.  xnsave set to -1 to preclude multiple callbacks.
 *
 * When io = 0, the routine will allocate the memory needed to
 * hold the function when it is read from a disk file.
 *
 * When io = -1, nextef takes no special action, and simple returns the
 * address of the next EFBLK found.
 *
 * The current scan point is in scanp, established by scanef.
 */
void *nextef( bufp, io )
unsigned char **bufp;
int io;
{
    union block *dnamp;
    mword ef_type = GET_CODE_OFFSET(B_EFC,mword);
    void *result = 0;
    mword type, blksize;
    pXFNode pnode;

    MINSAVE();
    for (dnamp = GET_MIN_VALUE(dnamp,union block *);
            scanp < dnamp; scanp = ((union block *) (MP_OFF(scanp,muword)+blksize)) {
        type = scanp->scb.sctyp;				// any block type lets us access type word
        SET_WA(type);
        SET_XR(scanp);
        MINIMAL(MINIMAL_BLKLN);						// get length of block in bytes
        blksize = WA(mword);
        if (type != ef_type)					// keep searching if not EFBLK
            continue;
        pnode = ((pXFNode) (scanp->efb.efcod));	// it's an EFBLK; get address of XNBLK
        if (!pnode)							// keep searching if no longer in use
            continue;

        switch (io) {
        case -1:
            result = (void *)pnode;			// return pointer to XNBLK
            *bufp = (unsigned char *)scanp;	// return pointer to EFBLK
            break;
        case 0:
            result = (void *)-1;			// can't reload DLL
            break;
        case 1:
            if (pnode->xnu.ef.xncbp)		// is there a callback routine?
                if (pnode->xnu.ef.xnsave >= 0) {
                    (pnode->xnu.ef.xncbp)();
                    pnode->xnu.ef.xnsave = -1;
                }
            *bufp = (unsigned char *)pnode->xnu.ef.xnpfn;
            result = (void *)1;				// phony non-zero size of code
            break;
        }
        // point to next block
        scanp = ((union block *) (MP_OFF(scanp,muword)+blksize));
        break;								// break out of for loop
    }
    MINRESTORE();
    return result;
}

// Rename a file.  Return 0 if OK
int renames(oldname, newname)
char *oldname;
char *newname;
{
    if (link(oldname, newname) == 0)
    {
        unlink(oldname);
        return 0;
    }
    else
        return -1;
}


/*
 * scanef - prepare to scan memory for external function blocks.
 */
void scanef()
{
    scanp = GET_MIN_VALUE(dnamb,union block *);
}


/*
 * unldef - unload an external function
 */
void unldef(efb)
struct efblk *efb;
{
    pXFNode pnode, pnode2;
    unsigned char *bufp;

    pnode = ((pXFNode) (efb->efcod));
    if (pnode == NULL)
        return;

    if (pnode->xnu.ef.xncbp)			  		// is there a callback routine?
        if (pnode->xnu.ef.xnsave >= 0) {
            (pnode->xnu.ef.xncbp)();
            pnode->xnu.ef.xnsave = -1;
        }

    efb->efcod = 0;							// remove pointer to XNBLK
    dlclose(pnode->xnu.ef.xnhand);			// close use of handle

    pnode->xnu.ef.xnpfn = (PFN)xnfree;		// put back on free list
    xnfree = pnode;
}

#endif 					// EXTFUN

/* Open file "Name" for reading, writing, or updating.
 * Method is O_RDONLY, O_WRONLY, O_RDWR, O_CREAT, O_TRUNC.
 * Mode supplies the sharing modes (IO_DENY_XX), IO_PRIVATE and IO_EXECUTABLE flags.
 * Action consists of flags such as IO_FAIL_IF_EXISTS, IO_OPEN_IF_EXISTS, IO_REPLACE_IF_EXISTS,
 *  IO_FAIL_IF_NOT_EXISTS, IO_CREATE_IF_NOT_EXIST, IO_WRITE_THRU.
 */
#define MethodMask	(O_RDONLY | O_WRONLY | O_RDWR)
// Private flags used to convey sharing status when opening a file
#define IO_COMPATIBILITY	0x00
#define IO_DENY_READWRITE	0x01
#define IO_DENY_WRITE		0x02
#define IO_DENY_READ		0x03
#define IO_DENY_NONE		0x04
#define IO_DENY_MASK		0x07 // mask for above deny mode bits
#define	IO_EXECUTABLE		0x40 // file to be marked executable
#define IO_PRIVATE			0x80 // file is private to current process

// Private flags used to convey file open actions
#define IO_FAIL_IF_EXISTS		0x00
#define IO_OPEN_IF_EXISTS		0x01
#define IO_REPLACE_IF_EXISTS	0x02
#define IO_FAIL_IF_NOT_EXIST	0x00
#define IO_CREATE_IF_NOT_EXIST	0x10
#define IO_EXIST_ACTION_MASK	0x13 // mask for above bits
#define IO_WRITE_THRU			0x20 // writes complete before return

File_handle spit_open(Name, Method, Mode, Action)
char *Name;
Open_method Method;
File_mode Mode;
int Action;
{
    if ((Method & MethodMask) == O_RDONLY) // if opening for read only
        Method &= ~(O_CREAT | O_TRUNC);	   // guarantee these bits off
    else if (Action & IO_WRITE_THRU)	   // else must be a write
        Method |= O_SYNC;

    if ((Method & O_CREAT) & (Action & IO_FAIL_IF_EXISTS))
        Method |= O_EXCL;

    return open(Name, Method, (Mode & IO_EXECUTABLE) ? 0777 : 0666);
}


void *sbrkx( long incr )
{
    static char *base = 0; // base of the sbrk region
    static char *endofmem;
    static char *curr;
    void *result;

    if (!base)
    {   // if need to initialize
        char *first_base;
        unsigned long size;

        /* Allocate but do not commit a chunk of linear address space.
         * This allows dlopen and any loaded external functions to use
         * the system malloc and sbrk to obtain memory beyond SPITBOL's
         * heap.
         */
        size = databts;

        do
        {
            first_base = (char *)malloc(size);
            if (first_base != 0)
                break;

            size -= (1 * 1024 * 1024);
        } while (size >= (20 * maxsize)); // arbitrary lower limit

        if (!first_base)
            return (void *)-1;

        base = first_base;

        /* To satisfy SPITBOL's requirement that the heap begin at an address
         * numerically larger than the largest object size, we force base
         * up to that value.  Note three things:  Since Linux memory is a sparse
         * array, this doesn't waste any physical memory.  And if by some
         * chance the user has specified a different object size value on
         * the command line, there is no harm in doing this.  It also starts
         * the heap at a nice high address that isn't likely to change as
         * the size of the SPITBOL system changes.
         */
        if (base < (char *)maxsize)
            base = (char *)maxsize;

        curr = base;
        endofmem = first_base + size;
    }

    if (curr + incr > endofmem)
        return (void *)-1;

    result = curr;
    curr += incr;

    return result;
}


/*  brkx(addr) - set the break address to the given value.
 *  returns 0 if successful, -1 if not.
 */
int brkx( void *addr )
{
    return sbrkx((char *)addr - (char *)sbrkx(0)) == (void *)-1 ? -1 : 0;
}




/*
 *-----------
 *
 *	makeexec - C callable make executable file function
 *
 *	Allows C function zysbx() to create executable files
 *	(a.out files) in response to user's -w command option.
 *
 *	SPITBOL performed a garbage collection prior to calling
 *	SYSBX, so there is no need to duplicate it here.
 *
 *	Then zysxi() is invoked directly to write the module.
 *
 *	int makeexec( struct scblk *scptr, int type);
 *
 *	Input:	scptr = Pointer to SCBLK for load module name.
 *			type = Type (+-3 or +-4)
 *	Output:	Result value <> 0 if error writing a.out.
 *		Result = 0 if type was |4| and no error.
 *		No return if type was |3| and file written successfully.
 *		When a.out is eventually loaded and executed, the restart
 *		code jumps directly to RESTART in the Minimal source.
 *		That is, makeexec is not resumed, since that would involve
 *		preserving the C stack and registers in the load module.
 *
 *		Upon resumption, the execution start time and garbage collect
 *		count are reset appropriately by restart().
 *
 */
int makeexec( scptr, type )
struct scblk *scptr;
int type;
{
    word	save_wa, save_wb, save_ia, save_xr;
    int		result;

    // save zysxi()'s argument registers (but not XL)
    save_wa = reg_wa;
    save_wb = reg_wb;
    save_ia = reg_ia;
    save_xr = reg_xr;

    reg_wa = (word)scptr;
    reg_xl = 0;
    reg_ia = type;
    reg_wb = 0;
    reg_xr = GET_DATA_OFFSET(headv,word);

    //  -1 is the normal return, so result >= 0 is an error
    result = zysxi() + 1;

    reg_wa = save_wa;
    reg_wb = save_wb;
    reg_ia = save_ia;
    reg_xr = save_xr;
    return result;
}

/*  uppercase( word )
 *
 *  restricted upper case function.  Only acts on 'a' through 'z'.
 */
word 
uppercase(c)
word c;
{
    if (c >= 'a' && c <= 'z')
        c += 'A' - 'a';
    return c;
}

