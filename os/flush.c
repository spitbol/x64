/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012 David Shields

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
    flush( ioptr )

    flush() writes out any characters in the buffer associated with the
    passed IOBLK.

    Parameters:
        ioptr   pointer to IOBLK representing file
    Returns:
        0 if flush successful / number of I/O errors
*/

#include "port.h"
#include "os.h"

int
flush(ioptr)
struct ioblk *ioptr;
{
    Enter("flush");
    REGISTER struct bfblk *bfptr = MK_MP(ioptr->bfb, struct bfblk *);
    REGISTER int ioerrcnt = 0;
    REGISTER word n;

    if (bfptr) {		/* if buffer */
	if (ioptr->flg2 & IO_DIR) {	/* if dirty */
	    ioerrcnt += fsyncio(ioptr);	/* synchronize file and buffer */
	    if (bfptr->fill) {
		n = write(ioptr->fdn, bfptr->buf, bfptr->fill);
		if (n != bfptr->fill)
		    ioerrcnt++;

		if (n > 0)
		    bfptr->curpos += n;
	    }
	    ioptr->flg2 &= ~IO_DIR;
	}
	bfptr->offset += bfptr->fill;	/* advance file position */
	bfptr->next = bfptr->fill = 0;	/* empty the buffer */
    }
    Exit("flush");
    return ioerrcnt;
}

/*
   fsyncio - bring file into sync with buffer.  A brute force
   approach is to always LSEEK to bfptr->offset, but this slows down
   SPITBOL's I/O with many unnecessary LSEEKs when the file is already
   properly positioned.  Instead, we remember the current physical file
   position in bfptr->curpos, and only LSEEK if it is different
   from bfptr->offset.

   For unbuffered files, the file position is always correct.

   Returns 0 if no error, 1 if error.
 */
int
fsyncio(ioptr)
struct ioblk *ioptr;
{
    REGISTER struct bfblk *bfptr = MK_MP(ioptr->bfb, struct bfblk *);
    FILEPOS n;
    Enter("ioptr");
    if (bfptr) {
	if (bfptr->offset != bfptr->curpos) {
	    n = LSEEK(ioptr->fdn, bfptr->offset, 0);
	    if (n >= 0)
		bfptr->curpos = n;
	    else {
		Exit("flush");
		return 1;	/* I/O error */
            }
	}
    }
    Exit("flush");
    return 0;
}
