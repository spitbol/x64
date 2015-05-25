/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2015 David Shields

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
/   sysstdio module
/
/   The sysstdio module contains two functions, zyspr and zysrd, that
/   perform standard input and output for the spitbol compiler.
/
/   During compilation zysrd is called to read lines of the program.  During
/   program execution zysrd is called to read input via input associated
/   variable INPUT.
/
/   During compilation zyspr is called to print header lines, the program
/   listing, and compilation statistics.  During program execution zyspr
/   is called to print output via output associated variable OUTPUT.
/
/   After program execution zyspr is called to print execution statistics
/   and the variable post-mortem dump if requested.
*/

#include "port.h"

void stdioinit()
{
    inpiob.bfb = MP_OFF(pinpbuf, struct bfblk *);
}

/*
/   zyspr - print to standard output file
/
/   zyspr prints a line to the standard output file.  Note that the
/   standard output is switched between two files.  See function swcoup
/   for details.
/
/   Parameters:
/	xr	pointer to SCBLK containing string to print
/	wa	length of string
/   Returns:
/	Nothing
/   Exits:
/	1	failure
*/

zyspr()

{
    /*
    /	Do writes in line mode.
    */

    if ( oswrite( 1, oupiob.len, WA(word), &oupiob, XR( struct scblk * ) ) < 0 ) {
        return  EXIT_1;
    }

    return NORMAL_RETURN;
}


/*
/   zysrd - read from standard input
/
/   zysrd reads a line from standard input.  The file currently available
/   for reading is setup by function swcinp.
/
/   IMPORTANT:  the spitbol compiler will attempt to read past EOF, so we
/   must set our own internal "at EOF" flag and keep returning EOF until
/   it is accepted.
/
/   Parameters:
/	xr	pointer to SCBLK to receive line
/	wc	length of string area in SCBLK
/   Returns:
/	Nothing
/   Exits:
/	1	EOF or switch to new file.  (Returns length=0 in SCBLK if EOF, else
/       	new file name in SCBLK and non-zero length.)
*/

zysrd()

{

    word	length;
    struct scblk *scb = XR( struct scblk * );

    if (provide_name)
    {
        // Provide compiler with name of source file, if desired.
        provide_name = 0;
        if (sfn && sfn[0])
        {
            cpys2sc( sfn, scb, WC(word));
            return  EXIT_1;
        }
    }


    /*
    /	Read a line from standard input.  If EOF on current standard input
    /	file, call function swcinp to switch to the next file, if any, except
    /       if within an include file.
    */
    while ( (length = osread( 1, WC(word), &inpiob, scb )) < 0 )
    {
        if ( nesting || swcinp( inpcnt, inpptr ) < 0 )
        {
            // EOF
            scb->len = 0;
            return  EXIT_1;
        }
        else
        {
            // Successful switch, report new file name if still in compilation phase
            if (!executing && sfn && sfn[0])
            {
                cpys2sc( sfn, scb, WC(word));
                return  EXIT_1;
            }
        }

    }
    scb->len = length;	// line read, so set line length
    /*
    /	Special check for '#!' invocation.
    */
    if ( first_record  &&  inpptr )
    {
        first_record = 0;
        if ( scb->str[0] == '#'  &&  scb->str[1] == '!' )
        {
            cmdcnt = gblargc - inpcnt + 1;
            inpcnt = 1;
            while( (length=osread(1, WC(word), &inpiob, scb)) < 0 )
            {
                if ( swcinp( inpcnt, inpptr ) < 0 )
                {
                    scb->len = 0;
                    return  EXIT_1;
                }
                // Successful switch, report new file name
                if (sfn && sfn[0])
                {
                    cpys2sc( sfn, scb, WC(word));
                    return  EXIT_1;
                }

            }
            scb->len = length;
        }
    }

    return NORMAL_RETURN;
}

/*
 /    Return file descriptor for standard input channel.
*/

int getrdfd( )
{
    return inpiob.fdn;
}

/*
 /    Return file descriptor for standard output channel.
*/

int getprfd( )
{
    return oupiob.fdn;
}


/*
 /    Return iob for standard input channel.
*/

struct ioblk *
getrdiob()
{
    return &inpiob;
}


/*
 * CLRBUF - clear input buffer
 */
void clrbuf()
{
    register struct bfblk *bfptr;

    bfptr = ((struct bfblk *) (inpiob.bfb));
    bfptr->next = bfptr->fill = 0;
    bfptr->offset = (FILEPOS)0;
    bfptr->curpos = (FILEPOS)-1;
    inpiob.flg2 &= ~IO_LF;
}

/*
 *  OUPEOF - advance output file to EOF
 */
void oupeof()
{
    doset(&oupiob, 0L, 2);
}
