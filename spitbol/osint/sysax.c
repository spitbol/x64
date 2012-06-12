/*
/	File:  SYSAX.C		Version:  01.01
/	---------------------------------------
/
/	Contents:	Function zysax
*/
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */

/*
/
/	zysax - after execution cleanup
/
/	Here we just indicate that further output should go to the
/	compiler output file, as opposed to stdout from executing program.
/
/	Parameters:
/	    None
/	Returns:
/	    Nothing
/	Exits:
/	    None
*/

#include "port.h"

zysax()
{
	/*  swcoup does real work  */
	swcoup( outptr );
	return NORMAL_RETURN;
}
