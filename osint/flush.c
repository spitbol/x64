/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields

/*
/   flush( ioptr )
/
/   flush() writes out any characters in the buffer associated with the
/   passed IOBLK.
/
/   Parameters:
/	ioptr	pointer to IOBLK representing file
/   Returns:
/	0 if flush successful / number of I/O errors
*/

#include "port.h"

int flush( ioptr )
struct	ioblk	*ioptr;
{
    register struct bfblk	*bfptr = ((struct bfblk *) (ioptr->bfb));
    register int	ioerrcnt = 0;
    register word	n;

    if ( bfptr ) {							// if buffer
        if ( ioptr->flg2 & IO_DIR ) {		// if dirty
            ioerrcnt += fsyncio(ioptr);     // synchronize file and buffer
            if ( bfptr->fill ) {
                n = write(ioptr->fdn, bfptr->buf, bfptr->fill);
                if ( n != bfptr->fill)
                    ioerrcnt++;

                if (n > 0)
                    bfptr->curpos += n;
            }
            ioptr->flg2 &= ~IO_DIR;
        }
        bfptr->offset += bfptr->fill;		// advance file position
        bfptr->next = bfptr->fill = 0;		// empty the buffer
    }
    return ioerrcnt;
}

/*
 * fsyncio - bring file into sync with buffer.  A brute force
 * approach is to always LSEEK to bfptr->offset, but this slows down
 * SPITBOL's I/O with many unnecessary LSEEKs when the file is already
 * properly positioned.  Instead, we remember the current physical file
 * position in bfptr->curpos, and only LSEEK if it is different
 * from bfptr->offset.
 *
 * For unbuffered files, the file position is always correct.
 *
 * Returns 0 if no error, 1 if error.
 */
int fsyncio( ioptr )
struct	ioblk	*ioptr;
{
    register struct bfblk *bfptr = ((struct bfblk *) (ioptr->bfb));
    FILEPOS n;

    if (bfptr) {
        if (bfptr->offset != bfptr->curpos) {
            n = LSEEK(ioptr->fdn, bfptr->offset, 0);
            if (n >= 0)
                bfptr->curpos = n;
            else
                return 1;			// I/O error
        }
    }
    return 0;
}

