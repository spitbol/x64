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
*/

#include "port.h"

zysex()
{
#if EXTFUN
    struct efblk *efb = XL(struct efblk *);
    word nargs = WA(word);
    union block *result = 0;		// initialize so collectable

    // Bypass return word in second argument to callef
    result = callef(efb, ((word) (MP_OFF(XS(union block **)))
                               + sizeof(word),union block **), nargs);
    switch ((word)result) {
    case (word)0:
        return EXIT_1;			// fail
    case (word)-1:
        return EXIT_2;			// insufficient memory
    case (word)-2:
        return EXIT_3;			// improper argument
    default:
        SET_XR(result);
        return NORMAL_RETURN;	// Success, return pointer to stuff in EFBLK
    }
#else					// EXTFUN
    return EXIT_1;
#endif					// EXTFUN
}
