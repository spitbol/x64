/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
        File:  SYSTTY.C         Version:  01.04
        ---------------------------------------

        Contents:       Function zyspi
                        Function zysri

/ 01.02         Added output record size to ioblock.  Note, as a
                result of changes in the compiler at ASG11, it is now
                possible for zyspi() to be called from zysou().  Previously,
                writes to TERMINAL were going through the PRTST logic, wasting
                time using the print buffer, and limiting the record length
                to the listing page width.  Instead, all output assignments
                go to zysou(), which now uses the FCB info in WA to decide
                if it is a special file (OUTPUT/TERMINAL), or a normal
                file.

/ 01.03 06-Feb-91 Changed for read/write I/O.  Add EOL chars to ioblk.

/ 01.04 01-Feb-93 New oswrite calling sequence.

*/

/*
    The systty module contains two functions, zyspi and zysri, that
    perform terminal I/O.

    During program execution assignment to variable TERMINAL causes a line
    to be printed on the terminal.  A call is made to zyspi to actually
    print the line.

    During program execution a value reference to varible TERMINAL causes
    a line to be read from the terminal.  A call is made to zysri to actually
    read the line.

    Under Un*x file descriptor 2 will be used for terminal access.
*/

#include "port.h"

void ttyinit()
{
    ttyiobin.bfb = MP_OFF(pttybuf, struct bfblk NEAR *);
}

/*
    zyspi - print on interactive channel

    zyspi prints a line on the user's terminal.

    Parameters:
        xr      pointer to SCBLK containing string to print
        wa      length of string
    Returns:
        Nothing
    Exits:
        1       failure
*/

zyspi()

{
    word        retval;

    retval = oswrite( 1, ttyiobout.len, WA(word), &ttyiobout, XR( struct scblk * ) );

    /*
    /   Return error if oswrite fails.
    */
    if ( retval != 0 )
        return EXIT_1;

    return  NORMAL_RETURN;
}


/*
    zysri - read from interactive channel

    zysri reads a line from the user's terminal.

    Parameters:
        xr      pointer to SCBLK to receive line
    Returns:
        Nothing
    Exits:
        1       EOF
*/


zysri()

{
    register word       length;
    register struct scblk *scb = XR( struct scblk * );
    register char *saveptr, savechr;

    /*
    /   Read a line specified by length of scblk.  If EOF take exit 1.
    */
    length = scb->len;                                  /* Length of buffer provided */
    saveptr = scb->str + length;                /* Save char following buffer for \n */
    savechr = *saveptr;

    MK_MP(ttyiobin.bfb, struct bfblk *)->size = ++length; /* Size includes extra byte for \n */

    length = osread( 1, length, &ttyiobin, scb );

    *saveptr = savechr;                                 /* Restore saved char */

    if ( length < 0 )
        return  EXIT_1;

    /*
    /   Line read OK, so set string length and return normally.
    */
    scb->len = length;
    return NORMAL_RETURN;
}


/* change handle used for TERMINAL output */
void ttyoutfdn(h)
File_handle h;
{
    ttyiobout.fdn = h;
#if HOST386
    if (coutdev(h))
#else
    if (testty(h))
#endif
        ttyiobout.flg1 &= ~IO_COT;
    else
        ttyiobout.flg1 |= IO_COT;
}
