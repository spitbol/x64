/*
/	File:  SYSEP.C		Version:  01.01
/	---------------------------------------
/
/	Contents:	Function zysep
*/
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */

/*
/	zysep - eject printer (standard output)
/
/	zysep writes an eject to the standard output.
/
/	Parameters:
/	    None
/	Returns:
/	    Nothing
/	Exits:
/	    None
*/

#include "port.h"

zysep()
{
	write( 1, "\f", 1 );
	return NORMAL_RETURN;
}

