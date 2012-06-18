/*
/	File:  SYSIL.C		Version:  01.03
/	---------------------------------------
/
/	Contents:	Function zysil
/
/	V1.02	Return binary/text indication in WC
/	V1.03	Adjust to new fcb style with separate mode field.  1-Feb-93.
*/
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */

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

    /* normal return */
    return NORMAL_RETURN;
}
