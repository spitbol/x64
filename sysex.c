/*
/	File:  SYSEX.C		Version:  01.01
/	---------------------------------------
/
/	Contents:	Function zysex
/
*/
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */

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
/
/  v1.01 11/25/90 Add exit 2 - insufficient memory, exit 3 - improper argument.
/
*/

#include "port.h"

zysex()
{
#if EXTFUN
	struct efblk *efb = XL(struct efblk *);
	word nargs = WA(word);
	union block *result = 0;		/* initialize so collectable */

	/* Bypass return word in second argument to callef */
	result = callef(efb, MK_MP(MP_OFF(XS(union block **),word)
	 + sizeof(word),union block **), nargs);
	switch ((word)result) {
	    case (word)0:
	            return EXIT_1;			/* fail */
	    case (word)-1:
	            return EXIT_2;			/* insufficient memory */
	    case (word)-2:
	            return EXIT_3;			/* improper argument */
	    default:
	        SET_XR(result);
	        return NORMAL_RETURN;	/* Success, return pointer to stuff in EFBLK */
	    }
#else					/* EXTFUN */
	return EXIT_1;
#endif					/* EXTFUN */
}
