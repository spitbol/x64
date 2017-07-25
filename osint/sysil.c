/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields
*/

/*
/	zysil - get input record length
/
/	Parameters:
/	    WA - pointer to FCBLK
/	Returns:
/	    WA - length of next record to be read
/	    WC - 0 if binary file, 1 if text file
/	Exits:
/	    None
*/

#include "port.h"

zysil()

{
    register struct fcblk *fcb = WA (struct fcblk *);

    SET_WA( fcb->rsz );
    SET_WC( fcb->mode );

    // normal return
    return NORMAL_RETURN;
}
