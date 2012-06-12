/*
/	File:  SYSMX.C		Version:  01.01
/	---------------------------------------
/
/	Contents:	Function zysmx
*/
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */

/*
/	zysmx - return maximum size in bytes of any created object
/
/	Parameters:
/	    XR - tentative end of static
/	Returns:
/	    WA - maximum created object size in bytes
/	Exits:
/	    None
*/

#include "port.h"

zysmx()

{
	SET_WA( maxsize );
	return NORMAL_RETURN;
}
