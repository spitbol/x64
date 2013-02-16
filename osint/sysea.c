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

extern char *stc_out;
zysea()
{
    register struct scblk *fnscblk = XL(struct scblk *);
    register char *p;


    // Display file name if present
    if (fnscblk->len) {
	uc_init(1);
	uc_encode(1,XL(struct scblk *));
        // Display line number if present
        if (WC(unsigned int)) {
	    uc_strcat(1,"(");
            stcu_d(WC(unsigned int), 16);
	    uc_strcat(1,stc_out);
            // Display character position if present
            if (WB(unsigned int)) {
		uc_strcat(1,",");
                stcu_d(WB(unsigned int)+1, 16);
		uc_strcat(1,stc_out);
            }
	    uc_strcat(1,")");
        }
        uc_strcat(1," : ");
	uc_decode(1);
        SET_XR( uc_scblk(1) );
        return NORMAL_RETURN;
    }
    SET_XR(0L);
    return NORMAL_RETURN;	// Other errors be processed normally
}

