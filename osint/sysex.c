/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields
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

int zysex()
{
#if EXTFUN
    struct efblk *efb = XL(struct efblk *);
    word nargs = WA(word);
    union block *result = 0;		// initialize so collectable

    // Bypass return word in second argument to callef
    word xs;
    xs = XS(word);
    xs += 8;
    result = callef(efb, (union block **)(xs), nargs);
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
