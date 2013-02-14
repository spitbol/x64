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

    uc_init(1);
    SET_XR(uc_scblk(1));
    uc_init(0);
    uc_strcpy(0,HOST_STRING);
    uc_strcat(0,"  ");
    uc_strcat(0,getdate(0));
    uc_decode(0);
    SET_XL(uc_scblk(0));
    return NORMAL_RETURN;
}
