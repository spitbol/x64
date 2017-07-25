/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields
*/

/*
/	File:  SYSID.C		Version:  01.02
/	---------------------------------------
/
/	Contents:	Function zysid
*/

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
#include <time.h>
#include <string.h>

/*
/   define actual headers elsewhere to overcome problems in initializing
/   the two SCBLKs.  Use id2blk instead of tscblk because tscblk may
/	be active with an error message when zysid is called.
*/

zysid()

{
    time_t now;
    register char *cp;
    char * s;
    int i;
	

    SET_XR( pid1blk );
    now = time(NULL);
    gettype( pid2blk, id2blk_length );
    cp = pid2blk->str + pid2blk->len;
    *cp++ = ' ';
    *cp++ = ' ';
    s = ctime(&now);
    for (i=0;i<strlen(s);i++) *cp++ = s[i];
    pid2blk->len = pid2blk->len + 2 + strlen(s);
    SET_XL( pid2blk );
    return NORMAL_RETURN;
}
