/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2013 David Shields
*/

/*
/	zysen - endfile
/
/	endfile is an artifact from the FORTRAN days and is supposed to
/	close a file.  However, the file may be reopened, etc.  We just
/	close it.
/
/	Parameters:
/	    WA - FCBLK pointer or 0
/	    XR - SCBLK pointer (ENDFILE argument)
/	Returns:
/	    Nothing
/	Exits:
/	    1 - file does not exist
/	    2 - inappropriate file
/	    3 - i/o error
*/

#include "port.h"

zysen()
{
    register struct fcblk *fcb = WA (struct fcblk *);
    register struct ioblk *iob = ((struct ioblk *) (fcb->iob));

    // ensure the file is open
    if ( !(iob->flg1 & IO_OPN) )
        return EXIT_1;

    // now close it
    if (osclose( iob ))
        return EXIT_3;

    return NORMAL_RETURN;
}
