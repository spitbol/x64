/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields
*/

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

int zysep()
{
    write( 1, "\f", 1 );
    return NORMAL_RETURN;
}

