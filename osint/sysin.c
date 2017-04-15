/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2013 David Shields
*/

/*
/	zysin - read input record
/
/	zysin reads and returns the next input record from a file.
/
/	Parameters:
/	    WA - pointer to FCBLK or 0
/	    XR - pointer to SCBLK containing buffer to receive record read
/	Returns:
/	    Nothing
/	Exits:
/	    1 - EOF or file not available after SYSXI
/	    2 - i/o error
/	    3 - record format error
*/

#include "port.h"

word wabs(x)
word x;
{
    return (x >= 0) ? x : -x;
}

zysin()
{
    register word	reclen;
    register struct fcblk *fcb = WA (struct fcblk *);
    register struct scblk *scb = XR (struct scblk *);
    register struct ioblk *ioptr = ((struct ioblk *) (fcb->iob));

    // ensure iob is open, fail if unsuccessful
    if ( !(ioptr->flg1 & IO_OPN) )
        return EXIT_3;

    // read the data, fail if unsuccessful
    while( (reclen = osread( fcb->mode, fcb->rsz, ioptr, scb )) < 0)
    {
        if ( reclen == (word)-1 )		// EOF?
        {
            if ( ioptr->fdn )	// If not fd 0, true EOF
                return EXIT_1;
            else			// Fd 0 - try to switch files
                if ( swcinp( inpcnt, inpptr ) < 0 )
                    return EXIT_1;     // If can't switch

            ioptr->flg2 &= ~IO_RAW; // Switched. Set IO_RAW
            if ( (testty( ioptr->fdn ) == 0 ) && // If TTY
                    ( fcb->mode == 0 ) )	// and raw mode,
                ioptr->flg2 |= IO_RAW;   // then set IO_RAW

        }
        else				// I/O Error
            return EXIT_2;
    }
    scb->len = reclen;		// set record length

    // normal return
    return NORMAL_RETURN;
}
