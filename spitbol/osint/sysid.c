/*
/	File:  SYSID.C		Version:  01.02
/	---------------------------------------
/
/	Contents:	Function zysid
/
/	1.02	Move id2 string here.
*/
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */

/*
/	zysid - identify system
/
/	zysid returns two strings identifying the Spitbol system.
/
/	Parameters:
/	    None
/	Returns:
/	    XR - pointer to SCBLK containing suffix to Spitbol header
/	    XL - pointer to SCBLK containing 2nd header line
/	Exits:
/	    None
*/

#include "port.h"

/*
/   define actual headers elsewhere to overcome problems in initializing
/   the two SCBLKs.  Use id2blk instead of tscblk because tscblk may
/	be active with an error message when zysid is called.
*/

zysid()

{
    register char *cp;

    SET_XR( pID1 );
    gettype( pID2BLK, ID2BLK_LENGTH );
    cp = pID2BLK->str + pID2BLK->len;
    *cp++ = ' ';
    *cp++ = ' ';
    pID2BLK->len += 2 + storedate(cp, ID2BLK_LENGTH - pID2BLK->len);
    SET_XL( pID2BLK );
    return NORMAL_RETURN;
}
