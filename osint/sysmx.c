/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2013 David Shields
*/

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
