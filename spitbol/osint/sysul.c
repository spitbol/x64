/*
/	File:  SYSUL.C		Version:  01.00
/	---------------------------------------
/
/	Contents:	Function zysul
/
*/
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */

/*
/	zysul - unload external function
/
/	Parameters:
/	    XR - pointer to EFBLK
/	Returns:
/	    nothing
*/

#include "port.h"


zysul()
{
#if EXTFUN
	unldef(XR(struct efblk *));
#endif					/* EXTFUN */
    return NORMAL_RETURN;
}
