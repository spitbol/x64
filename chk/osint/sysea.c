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
*/

#include "port.h"

static char *eacpy (char *s1, char *s2, int n);

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
    STGIC=0,			// Initial compile
    STGXC,				// Execution compile (CODE)
    STGEV,				// Expression eval during execution
    STGXT,				// Execution time
    STGCE,				// Initial compile after scanning END line
    STGXE,				// Execute time compile after scanning END line
    STGEE,				// EVAL evaluating expression
    STGNO				// Number of codes
};

zysea()
{
    register struct scblk *fnscblk = XL(struct scblk *);
    register char *p;


    // Display file name if present
    if (fnscblk->len) {
        p = ptscblk->str;
        p = eacpy(p, fnscblk->str, (int)fnscblk->len);
        // Display line number if present
        if (WC(unsigned int)) {
            *p++ = '(';
            p += stcu_d(p, WC(unsigned int), 16);
            // Display character position if present
            if (WB(unsigned int)) {
                *p++ = ',';
                p += stcu_d(p, WB(unsigned int)+1, 16);
            }
            *p++ = ')';
        }
        p = eacpy(p, " : ", 3);
        ptscblk->len = p - ptscblk->str;
        SET_XR( ptscblk );
        return NORMAL_RETURN;
    }
    SET_XR(0L);
    return NORMAL_RETURN;	// Other errors be processed normally
}

