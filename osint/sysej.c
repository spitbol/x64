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
/	File:  SYSEJ.C		Version:  01.04
/	---------------------------------------
/
/	Contents:	Function zysej
*/

/*
/	zysej - end job
/
/	zysej is called to terminate spitbol's execution.  Any open files
/	will be closed before calling __exit.
/
/	Parameters:
/	    WA - value of &ABEND keyword (always 0)
/	    WB - value of &CODE keyword
/	    XL - pointer to FCBLK chain
/	Returns:
/	    NO RETURN
*/

#include "port.h"

#if EXTFUN
unsigned char *bufp;
#endif					// EXTFUN


/*
/  close_all - Close all files.
/
/  Parameters:
/	chfcb	pointer to FCBLK chain or 0
/  Returns:
/	Nothing
/  Side Effects:
/	All files on the chain are closed and buffers flushed.
*/

void close_all(chb)

register struct chfcb *chb;

{
    while( chb != 0 )
    {
        osclose( ((struct ioblk *) (((struct fcblk *) (chb->fcp))->iob)) );
        chb = ((struct chfcb *) (chb->nxt));
    }
}



void zysej()
{

    if (!in_gbcol) {		// Only if not mid-garbage collection
        close_all( XL( struct chfcb * ) );

#if EXTFUN
        scanef();					// prepare to scan for external functions
        while (nextef(&bufp, 1))	// perform closing callback to some
            ;
#endif					// EXTFUN

    }
    /*
    /	Pass &CODE to function __exit.  Don't call standard exit function,
    /	because of its association with the stdio package.
    */
    __exit( WB(int) );

}

