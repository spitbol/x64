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
/	File:  SYSIL.C		Version:  01.03
/	---------------------------------------
/
/	Contents:	Function zysil
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
