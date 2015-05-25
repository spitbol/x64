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
/	File:  SYSBS.C		Version:  01.02
/	---------------------------------------
/
/	Contents:	Function zysbs
*/

/*
/	zysbs - backspace file
/
/	zysbs move a file's position back one physical record.
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
/
*/

#include "port.h"

static int back (struct ioblk *iob);

#define RET_BIAS 100

zysbs()
{
    register int c;
    register struct fcblk *fcb = WA(struct fcblk *);
    register struct ioblk *iob = ((struct ioblk *) (fcb->iob));

    // ensure the file is open
    if ( !(iob->flg1 & IO_OPN) )
        return EXIT_1;

    if (!testty(iob->fdn)
            || iob->flg2 & IO_PIP				// not allowed on pipes
       )
        return EXIT_2;						// character device

    if (fcb->mode) {						// if line mode

        /*
         * If the characters immediately preceding the current position
         * are end-of-line characters, ignore them before starting scan
         * for beginning of record.
         */
        if ((c = back(iob)) < 0)
            return c + RET_BIAS;			// beginning of file
        if (c == EOL)
            if ((c = back(iob)) < 0)
                return c + RET_BIAS;

        /*
         * Here with c containing the first character of the record
         * we should examine.
         */
        do {
            if (c == EOL)
                break;
        } while ((c = back(iob)) >= 0);

        if (c >= 0)
            doset(iob, 1L, 1);				// advance past EOL char
        else
            return c + RET_BIAS;
    }

    else {									// if raw mode
        if (doset(iob, -fcb->rsz, 1) < 0L)	// just move back record length
            return EXIT_1;					// I/O error
    }

    return NORMAL_RETURN;
}


/*
 * BACK - helper function to backup one position in file.
 *
 * returns character found at that position, or NORMAL_RETURN-RET_BIAS
 * if at beginning of file, or EXIT_3-RET_BIAS if I/O error.
 * Non-character returns are guaranteed to be negative.
 */
static int back(ioptr)
struct ioblk *ioptr;
{
    register struct bfblk *bfptr = ((struct bfblk *) (ioptr->bfb));
    unsigned char c;

    while (bfptr) {							// if file is buffered
        if (bfptr->next)
            return (unsigned int)(unsigned char)bfptr->buf[--bfptr->next];
        if (!bfptr->offset)					// if at beginning of file
            return NORMAL_RETURN-RET_BIAS;
        if (doset(ioptr, -1L, 1) < 0L)		// seek back one position
            return EXIT_3-RET_BIAS;			// if I/O error
        bfptr->next++;						// setup to return character
    }

    // Unbuffered file.  Use disgusting code
    if (!doset(ioptr, 0L, 1))
        return NORMAL_RETURN-RET_BIAS;
    if (doset(ioptr, -1L, 1) < 0L ||
            read(ioptr->fdn, &c, 1) != 1)
        return EXIT_3-RET_BIAS;				// if I/O error
    doset(ioptr, -1L, 1);
    return (unsigned int)c;
}
