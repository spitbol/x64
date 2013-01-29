/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2013 David Shields

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

//----------------------------  extern32.h  ------------------------------
#ifndef __extern32__
#define __extern32__

/*
 *  Definitions of routines and data available to C-language
 *  external function to be called from 32-bit versions of SPITBOL.
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
typedef int mword;				// MINIMAL word
typedef unsigned int muword;	// MINIMAL unsigned word
#ifndef far
#define far
#endif

#ifndef near
#define near
#endif

#include "blocks32.h"
#include <string.h>


// array of pointers to double functions
typedef double (*APDF[])();


/*
 * Miscellaneous information provided by SPITBOL in pointer above the arguments.
 */

typedef struct misc {
    short			 vers;			// version number of interface
    unsigned char	 ext;			// host environment, see ext_type below
    unsigned char	 spare;			// reserved
    mword			 nargs;		    // number of args to function
    mword		   (*ptyptab)[];	// pointer to table of data types
    struct xnblk 	*pxnblk;	    // ptr to xnblk describing function
    struct efblk 	*pefblk;		// ptr to efblk describing function
    APDF            *pflttab;		// ptr to array of floating point fncs
} misc;

enum ext_type {						// Executing under:
    t_pharlap,						//  PharLap DOS Extender
    t_intel,						//  Intel DOS Extender
    t_os2,							//  OS/2 2.0
    t_tc16,						 	//  MS-DOS TurboC with 16-bit IA
    t_tc32,							//  MS-DOS TurboC with 32-bit IA
    t_w1616,						//  16-bit Windows, 16-bit SPITBOL
    t_w1632,						//  16-bit Windows, 32-bit SPITBOL
    t_wnt8,							//  Windows NT on 386/486
    t_sparc,						//  Sun 4 / SPARC
    t_mac,							//  Apple Macintosh
    t_mips,							//  MIPS R3000
    t_rs6000,                       //  IBM RS/6000
    t_lnx8632,                      //  Linux Intel x86 32-bit
    t_lnx8664                       //  Linux Intel x86 64-bit
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

#define ar	(*((*pinfo).ptyptab))[BL_AR]	// Array
#define bc	(*((*pinfo).ptyptab))[BL_BC]	// Buffer Control
#define bf	(*((*pinfo).ptyptab))[BL_BF]	// String Buffer
#define cd	(*((*pinfo).ptyptab))[BL_CD]	// Code
#define ex	(*((*pinfo).ptyptab))[BL_EX]	// Expression
#define ic	(*((*pinfo).ptyptab))[BL_IC]	// Integer
#define nm	(*((*pinfo).ptyptab))[BL_NM]	// Name
#define rc	(*((*pinfo).ptyptab))[BL_RC]	// Real
#define sc	(*((*pinfo).ptyptab))[BL_SC]	// String
#define tb	(*((*pinfo).ptyptab))[BL_TB]	// Table
#define vc	(*((*pinfo).ptyptab))[BL_VC]	// Vector
#define xn	(*((*pinfo).ptyptab))[BL_XN]	// External


/*
 * Non-standard block-type values that may be returned as a result:
 */

#define FAIL	(-1)			// Signal function failure
#define	BL_NC	100				// Unconverted result
#define BL_FS	101				// Far string
#define	BL_FX	102				// Far external block

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

mword     retint (int val, union block *presult);
mword     retnstrt (char *s, size_t n, union block *presult);
mword     retnxdtf (void *s, size_t n, union block *presult);
mword     retreal (double val, union block *presult);
mword     retstrt (char *s, union block *presult);

#endif          // __extern32__
//-------------------------- end of extern32.h ------------------------
