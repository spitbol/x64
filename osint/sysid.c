/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2013 David Shields

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
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
