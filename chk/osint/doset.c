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
/	File:  DOSET.C		Version:  01.04
/	---------------------------------------
/
/	Contents:	Function doset
*/

/*
/   doset( ioptr, offset, whence )
/
/   doset() does an "LSEEK" function call on the file described by ioptr.
/   For output files, the buffer must be flushed before doing the LSEEK.
/   For input file, any "unread" characters in the buffer must be seeked
/   over as well.
/
/   Parameters:
/	ioptr	pointer to IOBLK describing file
/  offset   offset for LSEEK call
/  whence   type of LSEEK to perform
/   Returns:
/  Value returned by LSEEK (-1 if error).
/
*/

#include "port.h"


#if SETREAL
#include <math.h>       // for floor()
#endif

FILEPOS doset( ioptr, offset, whence )

struct	ioblk	*ioptr;
FILEPOS  offset;
int	whence;

{
    register struct	bfblk *bfptr = ((struct bfblk *) (ioptr->bfb));
    FILEPOS target, newoffset;

    if (ioptr->flg2 & IO_PIP)
        return -1L;


    switch (whence) {
    case 0:								// absolute position
        target = offset;
        break;
    case 1:								// relative to current position
        target = offset +
                 (bfptr ? bfptr->offset + bfptr->next : LSEEK(ioptr->fdn, (FILEPOS)0, 1));
        break;
    case 2:								// relative to EOF
        target = offset + geteof(ioptr);
        break;
    default:
        return -1;
    }

    if (target < (FILEPOS)0)
        target = (FILEPOS)0;

    if (bfptr) {
        /*
         * see if target is within the present buffer
         */
        if (bfptr->offset <= target &&
                target <= bfptr->offset + bfptr->fill) {
            bfptr->next = (word)(target - bfptr->offset);
            return target;
        }

        /*
        /  Flush any dirty buffer before doing LSEEK.
        */
        if (flush(ioptr))
            return -1;						// return if error

        /*
        /	Seek to a position that is a multiple of the buffer size.
        */
#if SETREAL
        newoffset = floor(target / bfptr->size) * bfptr->size;
#else
        newoffset = (target / bfptr->size) * bfptr->size;
#endif
        if (newoffset != bfptr->curpos)
        {
            // physical file position differs from desired new offset
            FILEPOS newcurrent;
            newcurrent = LSEEK(ioptr->fdn, newoffset, 0);
            if (newcurrent < (FILEPOS)0)
                return -1;
            bfptr->offset = bfptr->curpos = newcurrent;
        }
        else
        {
            // file is properly positined already
            bfptr->offset = newoffset;
        }

        /*
        /	Now fill the buffer and position the next pointer carefully.
        */
        if (testty(ioptr->fdn) && fillbuf(ioptr) < 0)
            return -1;

        bfptr->next = (word)(target - bfptr->offset);
        if (bfptr->next > bfptr->fill)	{			// if extending beyond EOF
            if (ioptr->flg1 & IO_OUP)
                bfptr->fill = bfptr->next;			// only allow if output file
            else
                bfptr->next = bfptr->fill;			// otherwise, limit to true EOF
        }

        return bfptr->offset + bfptr->next;
    }
    else
        return LSEEK(ioptr->fdn, target, 0); // unbuffered I/O
}

FILEPOS geteof(ioptr)
struct ioblk *ioptr;
{
    register struct	bfblk *bfptr = ((struct bfblk *) (ioptr->bfb));
    FILEPOS eofpos, curpos;

    if (!bfptr)								// if unbuffered file
        curpos = LSEEK(ioptr->fdn, (FILEPOS)0, 1);   //  record current position

    eofpos = LSEEK(ioptr->fdn, (FILEPOS)0, 2);      // get eof position

    if (bfptr) {
        bfptr->curpos = eofpos;				// buffered - record position
        if (bfptr->offset + bfptr->fill > eofpos)	// if buffer extended
            eofpos = bfptr->offset + bfptr->fill;	// beyond physical file
    }
    else
        LSEEK(ioptr->fdn, curpos, 0);    // unbuffered - restore position


    return eofpos;
}
