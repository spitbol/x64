/*
/	File:  FLUSH.C		Version:  01.02
/	---------------------------------------
/
/	Contents:	Function flush
/
/   V1.02 05-Feb-91	Flush only if dirty.  Adjust file position in buffer.
/   v1.01		Ignore short count writes if MS-DOS and character device.
*/
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */

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
    register struct bfblk	*bfptr = MK_MP(ioptr->bfb, struct bfblk *);
    register int	ioerrcnt = 0;
    register word	n;

    if ( bfptr ) {							/* if buffer */
        if ( ioptr->flg2 & IO_DIR ) {		/* if dirty */
            ioerrcnt += fsyncio(ioptr);     /* synchronize file and buffer */
            if ( bfptr->fill ) {
                n = write(ioptr->fdn, bfptr->buf, bfptr->fill);
#if WINNT
                /* ignore short writes on character device */
                if ( n != bfptr->fill && testty(ioptr->fdn) )
#else
                if ( n != bfptr->fill)
#endif
                    ioerrcnt++;

                if (n > 0)
                    bfptr->curpos += n;
            }
            ioptr->flg2 &= ~IO_DIR;
        }
        bfptr->offset += bfptr->fill;		/* advance file position */
        bfptr->next = bfptr->fill = 0;		/* empty the buffer */
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
    register struct bfblk *bfptr = MK_MP(ioptr->bfb, struct bfblk *);
    FILEPOS n;

    if (bfptr) {
        if (bfptr->offset != bfptr->curpos) {
            n = LSEEK(ioptr->fdn, bfptr->offset, 0);
            if (n >= 0)
                bfptr->curpos = n;
            else
                return 1;			/* I/O error */
        }
    }
    return 0;
}

