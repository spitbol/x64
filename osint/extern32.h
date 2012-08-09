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

/*----------------------------  extern32.h  ------------------------------*/
#ifndef __extern32__
#define __extern32__

/*
 *  definitions of routines and data available to c-language
 *  external function to be called from 32-bit versions of spitbol.
 *
 * 	v1.00  02/17/90 01:52pm
 * 		   initial version
 *
 *  v1.01  10-18-91 04:53pm
 *         <withdrawn>.
 *
 *  v1.02  03-29-92 09:11am
 *       <withdrawn>.
 *
 *  v1.03  07-28-92 06:56am
 * 		   customize for sparc.
 *
 *	v1.04  09-12-94 07:13pm
 *		   add definitions for buffers
 *
 *  v1.05  04-25-95 10:05pm
 *		   customize for rs/6000
 *
 *  v1.06  12-29-96 06:05pm
 *         customize for windows nt
 *
 *  v1.07  03-04-97 12:45pm
 *			  tweak for sparc.
 *
 *  definition of information placed on stack prior to pushing arguments to
 *  an external function.
 *
 *  many of these items can be ignored, and are provided only for the
 *  benefit of those wishing to operate directly on spitbol's internal
 *  data structures.
 *
 *  however, the pointer in presult *must* be used by the external
 *  function to locate the area in which results are returned.
 *
 */

#include "system.h"
typedef int mword;				/* minimal word	*/
typedef unsigned int muword;	/* minimal unsigned word	*/
#ifndef far
#define far
#endif

#ifndef near
#define near
#endif

#ifndef params
#if prototypes
#define params(a) a
#else
#define params(a) ()
#endif
#endif

#define _pascal           /* available under borland, but don't use it now. */
#if winnt && __borlandc__
#define entry(x) mword _pascal __export x
#elif winnt && _msc_ver
#define entry(x) mword _pascal __declspec(dllexport) x
#else
#define entry(x) mword _pascal x
#endif

#include "blocks32.h"
#include <string.h>


/* array of pointers to double functions */
typedef double (*apdf[])();


/*
 * miscellaneous information provided by spitbol in pointer above the arguments.
 */

typedef struct misc {
    short			 vers;			/* version number of interface			*/
    unsigned char	 ext;			/* host environment, see ext_type below	*/
    unsigned char	 spare;			/* reserved 							*/
    mword			 nargs;		    /* number of args to function			*/
    mword		   (*ptyptab)[];	/* pointer to table of data types		*/
    struct xnblk 	*pxnblk;	    /* ptr to xnblk describing function		*/
    struct efblk 	*pefblk;		/* ptr to efblk describing function		*/
    apdf            *pflttab;		/* ptr to array of floating point fncs	*/
#if winnt
    short            spds;          /* spitbol's ds segment selector        */
    short			 spcs;			/* spitbol's cs segment selector		*/
#endif
} misc;

enum ext_type {						/* executing under:						*/
    t_pharlap,						/*  pharlap dos extender				*/
    t_intel,						/*  intel dos extender					*/
    t_os2,							/*  os/2 2.0							*/
    t_tc16,						 	/*  ms-dos turboc with 16-bit ia		*/
    t_tc32,							/*  ms-dos turboc with 32-bit ia		*/
    t_w1616,						/*  16-bit windows, 16-bit spitbol		*/
    t_w1632,						/*  16-bit windows, 32-bit spitbol		*/
    t_wnt8,							/*  windows nt on 386/486				*/
    t_sparc,						/*  sun 4 / sparc						*/
    t_mac,							/*  apple macintosh						*/
    t_mips,							/*  mips r3000							*/
    t_rs6000,                       /*  ibm rs/6000                         */
    t_lnx8632,                      /*  linux intel x86 32-bit              */
    t_lnx8664                       /*  linux intel x86 64-bit              */
};

/*
 * sample usage.  definition for function arguments, assuming
 * calling function in spitbol with:
 *
 * 	 f(integer,real,string)
 *
 * because spitbol pushes arguments left to right, a pascal
 * calling sequence should be used.  the could be supplied by
 * adding the __pascal keyword to the entry macro.
 *
 * however, because the sparc and rs/6000 c compilers do not support
 * pascal calling sequences, and we would like to move external function
 * source files easily between systems, the function definition will have
 * to manually reverse the arguments:
 *   entry(f)(presult, pinfo, parg3, larg3, rarg2, iarg1)
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
 * simple names for datatypes.  performs a lookup in spitbol's type
 * table to fetch a 32-bit type word for specific data types.
 */

#define ar	(*((*pinfo).ptyptab))[bl_ar]	/* array		*/
#define bc	(*((*pinfo).ptyptab))[bl_bc]	/* buffer control	*/
#define bf	(*((*pinfo).ptyptab))[bl_bf]	/* string buffer	*/
#define cd	(*((*pinfo).ptyptab))[bl_cd]	/* code			*/
#define ex	(*((*pinfo).ptyptab))[bl_ex]	/* expression	*/
#define ic	(*((*pinfo).ptyptab))[bl_ic]	/* integer		*/
#define nm	(*((*pinfo).ptyptab))[bl_nm]	/* name			*/
#define rc	(*((*pinfo).ptyptab))[bl_rc]	/* real			*/
#define sc	(*((*pinfo).ptyptab))[bl_sc]	/* string		*/
#define tb	(*((*pinfo).ptyptab))[bl_tb]	/* table		*/
#define vc	(*((*pinfo).ptyptab))[bl_vc]	/* vector		*/
#define xn	(*((*pinfo).ptyptab))[bl_xn]	/* external		*/


/*
 * non-standard block-type values that may be returned as a result:
 */

#define fail	(-1)			/* signal function failure	*/
#define	bl_nc	100				/* unconverted result		*/
#define bl_fs	101				/* far string				*/
#define	bl_fx	102				/* far external block		*/

/*
 * length of string area in result buffer
 */

#define	buflen	512


/*
 * spitbol's real number functions are not available to external
 * functions coded in c.  use the normal c floating point library
 * to provide such support.
 */

/*
 * function definitions for routines in extrnlib.c
 */
#if sparc | aix
#include <memory.h>
#endif

mword     retint params((int val, union block *presult));
mword     retnstrt params((char *s, size_t n, union block *presult));
mword     retnxdtf params((void *s, size_t n, union block *presult));
mword     retreal params((double val, union block *presult));
mword     retstrt params((char *s, union block *presult));

#endif          /* __extern32__ */
/*-------------------------- end of extern32.h ------------------------*/
