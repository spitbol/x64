/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields
*/

/*
/	zysul - unload external function
/
/	Parameters:
/	    XR - pointer to EFBLK
/	Returns:
/	    nothing
*/

#include "port.h"


int zysul()
{
#if EXTFUN
    unldef(XR(struct efblk *));
#endif					// EXTFUN
    return NORMAL_RETURN;
}
