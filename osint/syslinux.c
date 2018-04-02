/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields
*/

/************************************************************************\
*                                                                        *
*  syslinux - Unique Linux code for SPITBOL              *
*                                                                        *
\************************************************************************/

#define PRIVATEBLOCKS 1
//#include <unistd.h>
#include "port.h"
#include <stdlib.h>
#include <fcntl.h>
#undef brk  // remove sproto redefinition
#undef sbrk // remove sproto redefinition
#include <malloc.h>

// Size and offset of fields of a structure.  Probably not portable.
#define FIELDSIZE(str, fld) (sizeof(((str *)0)->fld))
#define FIELDOFFSET(str, fld) ((unsigned long)(char *)&(((str *)0)->fld))
/*
mkdir ffcall
wget https://ftp.gnu.org/gnu/libffcall/libffcall-2.1.tar.gz
tar -xzvf libffcall-2.1.tar.gz
cd libffcall-2.1
export CC=musl-gcc
export DEBUG=1
./configure --prefix=/usr --libdir=/usr/lib/x86_64-linux-musl  --includedir=/usr/include/x86_64-linux-musl
make
sudo make install
*/

#if EXTFUN
#include <dlfcn.h>
#include <avcall.h>

typedef struct xnblk XFNode;
typedef XFNode * pXFNode;

typedef mword (*PFN)();				// pointer to function

static union block *scanp;			// used by scanef/nextef
static pXFNode xnfree = (pXFNode)0;	// list of freed blocks


#define FUNC_TYPE_UNCONVERTED 0
#define FUNC_TYPE_STRING 1
#define FUNC_TYPE_INTEGER 2
#define FUNC_TYPE_REAL 3
//#define FUNC_TYPE_FILE 4
// set cnra

#ifdef USE_FLOAT_TABLE
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
#endif





misc miscinfo = {0x105,				// internal version number
                 GCCi32 ? t_lnx8632 : t_lnx8664,           // environment
                 0,								// spare
                 0,								// number of arguments
                 0,								// pointer to type table
                 0,								// pointer to XNBLK
                 0,								// pointer to EFBLK
                 NULL // (APDF *)flttab,					// pointer to flttab
                };

/* Assembly-language helper needed for final linkage to function:
 But now we use avcall
 */
//extern mword callextfun (struct efblk *efb, union block **sp, mword nargs, mword nbytes);



/*
;       
;       save and restore minimal and interface registers on stack.
;       used by any routine that needs to call back into the minimal
;       code in such a way that the minimal code might trigger another
;       sysxx call before returning.
;       
;       note 1:  pushregs returns a collectable value in xl, safe
;       for subsequent call to memory allocation routine.
;       
;       note 2:  these are not recursive routines.  only reg_xl is
;       saved on the stack, where it is accessible to the garbage
;       collector.  other registers are just moved to a temp area.
;       
;       note 3:  popregs does not restore reg_cp, because it may have
;       been modified by the minimal routine called between pushregs
;       and popregs as a result of a garbage collection.  calling of
;       another sysxx routine in between is not a problem, because
;       cp will have been preserved by minimal.
;       
;       note 4:  if there isn't a compiler stack yet, we don't bother
;       saving xl.  this only happens in call of nextef from sysxi when 
;       reloading a save file.
;       
;               
*/

/* simulation of pushregs and popregs of yesteryear - 
ours mimics the weird code, and also, it is recursive */

extern word compsp;
word syslinux_reg_pointer=0;
word syslinux_reg_stack[512];
void pushregs(void) {
if (compsp) {
  compsp -= sizeof(word);
  ((word *)compsp)[0] =  XL(word);
  }
else {
  syslinux_reg_stack[syslinux_reg_pointer++] = XL(word);
  }
syslinux_reg_stack[syslinux_reg_pointer++] = IA(word);
syslinux_reg_stack[syslinux_reg_pointer++] = W0(word);
syslinux_reg_stack[syslinux_reg_pointer++] = WA(word);
syslinux_reg_stack[syslinux_reg_pointer++] = WB(word);
syslinux_reg_stack[syslinux_reg_pointer++] = WC(word);
syslinux_reg_stack[syslinux_reg_pointer++] = XR(word);
syslinux_reg_stack[syslinux_reg_pointer++] = compsp;
syslinux_reg_stack[syslinux_reg_pointer++] = RA(word);
syslinux_reg_stack[syslinux_reg_pointer++] = minimal_id;
}


void popregs(void) {
minimal_id = syslinux_reg_stack[--syslinux_reg_pointer];
SET_RA(syslinux_reg_stack[--syslinux_reg_pointer]);
compsp = (syslinux_reg_stack[--syslinux_reg_pointer]);
SET_XR(syslinux_reg_stack[--syslinux_reg_pointer]);
SET_WC(syslinux_reg_stack[--syslinux_reg_pointer]);
SET_WB(syslinux_reg_stack[--syslinux_reg_pointer]);
SET_WA(syslinux_reg_stack[--syslinux_reg_pointer]);
SET_W0(syslinux_reg_stack[--syslinux_reg_pointer]);
SET_IA(syslinux_reg_stack[--syslinux_reg_pointer]);
if (compsp) {
  SET_XL(((word *)compsp)[0]);
  compsp += sizeof(word);
  }
else {
  SET_XL(syslinux_reg_stack[--syslinux_reg_pointer]);
  }
}



 word typet;

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
word nargs;
{
    register pXFNode pnode;
    union block *result;
    static word initsels = 0;
    static mword (*pTYPET)[];
    mword type, length;
    mword nbytes, i;
    char *p;
    char *q;
    mword *r;
    mword *s;

    type =  (efb->efrsl);
    pnode = ((pXFNode) (efb->efcod));
    if (pnode == NULL)
        return (union block *)-1L;

    if (!initsels) {						// one-time initializations
        pTYPET = (mword (*)[])GET_DATA_OFFSET(typet,muword);
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

#define MAX_ARGS 40
    char savechar[40];	
	
    long long_return;
    void *ptr_return = NULL;
    double double_return;
    
    av_alist alist;
    result = (union block *)ptscblk;
    void (*function)() = (void *)((pXFNode)pnode->xnu.ef.xnpfn);

    switch (type) {
    case FUNC_TYPE_INTEGER:
    	av_start_long(alist, function,&long_return);
        break;
    case FUNC_TYPE_REAL:
    	av_start_double(alist, function,&double_return);
        break;
    case FUNC_TYPE_STRING:
    	av_start_ptr(alist, function,void *,&ptr_return);
        break; 		
    case FAIL:						// fail
        av_start_void(alist,function);   
	break;
    default:
    	av_start_ptr(alist, function,void *,&result);
        break;   
    }
    
    
    
    
    /* set up arguments */
    for (i=0;i<nargs;i++) {
      mword eftype;
      eftype = efb->eftar[i];
      
      switch (eftype) {
      case FUNC_TYPE_INTEGER:
    	av_long(alist,(sp[i]->icb.icval));
        break;
      case FUNC_TYPE_REAL:
    	av_double(alist,sp[i]->rcb.rcval);
        break;
      case FUNC_TYPE_STRING:
        /* hack allocate chuink */
	savechar[i] =make_c_str(&((char *)(sp[i]->scb.scstr))[sp[i]->scb.sclen]);
        av_ptr(alist,char *,(char *)(sp[i]->scb.scstr));
        break;
      case FAIL:						// fail
      default:
     	av_ptr(alist,void *,sp[i]);
        break;   
      } // switch eftype
    } // for each argument
      
    av_call(alist);
    //    type = callextfun(efb, sp-1, nargs, SA(nbytes));	// make call with Stack Aligned nbytes

    
    for (i=0;i<nargs;i++) {
      mword eftype;
      eftype = efb->eftar[i];
      
      switch (eftype) {
      case FUNC_TYPE_STRING:	
	unmake_c_str(&((char *)(sp[i]->scb.scstr))[sp[i]->scb.sclen],savechar[i]);
	break;
      default:
        break;   
      } // switch eftype
    } // for each argument

        
    switch (type) {

     case FUNC_TYPE_INTEGER:
        result->icb.ictyp = (*pTYPET)[BL_IC];
	result->icb.icval = long_return;
	break;
    case FUNC_TYPE_REAL:
        result->rcb.rctyp = (*pTYPET)[BL_RC];
        result->rcb.rcval = double_return;
        break;
    case FUNC_TYPE_STRING:		  	 
      if (!ptr_return) {
        length = 0;
	result = 0;
	break;						 // return null string result
	}
      length = strlen((char *)ptr_return);      

      MINSAVE();
      SET_WA( length);
      MINIMAL(minimal_alocs);				// allocate string storage
      result = XR(union block *);
      MINRESTORE();

//      result->scv.fstyp = (*pTYPET)[BL_FS];      
      memcpy(result->scb.scstr, ptr_return, length);
      break;

    case FAIL:						// fail
      result = 0;
      break;
    default:
        length = ((result->fxb.fxlen + sizeof(mword) - 1) &
                  -sizeof(mword)) + FIELDOFFSET(struct xnblk, xnu.xndta[0]);
        if (length > GET_MIN_VALUE(mxlen,mword)) {
            result = (union block *)0;
            break;
        }
        r = result->fxb.fxptr;
        MINSAVE();
        SET_WA(length);
        MINIMAL(minimal_alloc);				// allocate block storage
        result = XR(union block *);
        MINRESTORE();
        result->xnb.xnlen = length;
        result->xnb.xntyp = (*pTYPET)[BL_XN];
        s = result->xnb.xnu.xndta;
        length = (length - FIELDOFFSET(struct xnblk, xnu.xndta[0]));
	memcpy(s,r,length*sizeof(mword));
        break;
    }
    return result;
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
void *loadef(fd, pfn_entry)
mword fd;
void *pfn_entry;
{
    void *handle = (void *)fd;
    PFN pfn = (PFN)pfn_entry;
    auto pXFNode pnode;  // onot register therwise the minimal restore regs wipes it out fool!

    if (xnfree) {							// Are these any free nodes to use?
        pnode = xnfree;						// Yes, seize one
        xnfree = (pXFNode)pnode->xnu.ef.xnpfn;
    }
    else {
        MINSAVE();							// No
        SET_WA(sizeof(XFNode));
        MINIMAL(minimal_alost);						// allocate from static region
        pnode = XR(pXFNode);					// get node to hold information
        MINRESTORE();
    }

    pnode->xntyp = TYPE_XNT;					// B_XNT type word
    pnode->xnlen = sizeof(XFNode);			// length of this block
    // xnoff left - 72
    // xnsiz 0
    // xniep 0
    // xncs 2968
    // xnesp 0
    // xnss 0
    // xnds 0
    // xnes 0
    // xnfs 0
    // xngs 0
    pnode->xnu.ef.xn1st = 2;					// flag first call to function
    pnode->xnu.ef.xnsave = 0;				// not reload from save file
    pnode->xnu.ef.xncbp = (void far (*)())0; // no callback  declared
    pnode->xnu.ef.xnpfn = (mword)pfn;				// record function entry address
    pnode->xnu.ef.xnhand = handle;			// record DLL handle
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
    union block *mydnamp;
    mword ef_type = GET_CODE_OFFSET(b_efc,mword);
    void *result = 0;
    mword type, blksize;
    pXFNode pnode;
    blksize = 0;
    MINSAVE();
    for (mydnamp = GET_MIN_VALUE(dnamp,union block *);
            scanp < mydnamp; scanp = ((union block *) (MP_OFF(scanp,muword)+blksize))) {
        type = scanp->scb.sctyp;				// any block type lets us access type word
	if (type==0) {
	  blksize = 16;
	  continue;
	  }
	 
        SET_WA(type);
        SET_XR(scanp);
        MINIMAL(minimal_blkln);						// get length of block in bytes
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

    pnode->xnu.ef.xnpfn = (mword)xnfree;		// put back on free list
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

