
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields
*/

/*
/    zysou - output a record
/
/    zysou writes a record to a file.
/
/    Parameters:
/        WA - pointer to FCBLK or 0 (TERMINAL) or 1 (OUTPUT)
/        XR - pointer to BCBLK or SCBLK containing record to be written
/    Returns:
/        Nothing
/    Exits:
/        1 - file full or no file after SYSXI
/        2 - i/o error
*/

#include "port.h"

int
zysou()
{
    struct fcblk *fcb = WA(struct fcblk *);
    union block *blk = XR(union block *);
    int result;

    if(blk->scb.typ == TYPE_SCL) {
        /* called with string, get length from SCBLK */
        SET_WA(blk->scb.len);
    } else {
        /* called with buffer, get length from BCBLK, and treat BSBLK
         * like an SCBLK
         */
        SET_WA(blk->bcb.len);
        SET_XR(blk->bcb.bcbuf);
    }

    if(fcb == (struct fcblk *)0 || fcb == (struct fcblk *)1) {
        if(!fcb)
            result = zyspi();
        else
            result = zyspr();
        if(result == NORMAL_RETURN)
            return NORMAL_RETURN;
        else
            return EXIT_2;
    }

    /* ensure iob is open, fail if unsuccessful */
    if(!(((struct ioblk *)(fcb->iob))->flg1 & IO_OPN))
        return EXIT_1;

    /* write the data, fail if unsuccessful */
    if(oswrite(fcb->mode, fcb->rsz, WA(word), ((struct ioblk *)(fcb->iob)),
               XR(struct scblk *)) != 0)
        return EXIT_2;

    /* normal return */
    return NORMAL_RETURN;
}
