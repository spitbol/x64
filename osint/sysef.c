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
/	File:  SYSEF.C		Version:  01.02
/	---------------------------------------
/
/	Contents:	Function zysef
*/

/*
/	zysef - eject file
/
/	zysef writes an eject (form-feed) to a file.
/
/	Parameters:
/	    WA - FCBLK pointer or 0
/	    XR - SCBLK pointer (EJECT argument)
/	Returns:
/	    Nothing
/	Exits:
/	    1 - file does not exist
/	    2 - inappropriate file
/	    3 - i/o error
*/

#include "port.h"

/*
/	ffscblk is one of the few SCBLKs that can be directly allocated
/	using a C struct!
*/
static struct scblk	ffscblk =
{
    0,		//  type word - ignore
    1,		//  string length
    '\f'	//  string is a form-feed
};

zysef()
{
    register struct fcblk *fcb = WA(struct fcblk *);
    register struct ioblk *iob = ((struct ioblk *) (fcb->iob));

    // ensure the file is open
    if ( !(iob->flg1 & IO_OPN) )
        return EXIT_1;

    // write the data, fail if unsuccessful
    if ( oswrite( fcb->mode, fcb->rsz, ffscblk.len, iob, &ffscblk) != 0 )
        return EXIT_2;

    return NORMAL_RETURN;
}
