
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields
*/

/*
/    zysef - eject file
/
/    zysef writes an eject (form-feed) to a file.
/
/    Parameters:
/        WA - FCBLK pointer or 0
/        XR - SCBLK pointer (EJECT argument)
/    Returns:
/        Nothing
/    Exits:
/        1 - file does not exist
/        2 - inappropriate file
/        3 - i/o error
*/

#include "port.h"

/*
/    ffscblk is one of the few SCBLKs that can be directly allocated
/    using a C struct!
*/
static struct scblk ffscblk = {
    0,   /*  type word - ignore */
    1,   /*  string length */
    '\f' /*  string is a form-feed */
};

int
zysef()
{
    struct fcblk *fcb = WA(struct fcblk *);
    struct ioblk *iob = ((struct ioblk *)(fcb->iob));

    /* ensure the file is open */
    if(!(iob->flg1 & IO_OPN))
        return EXIT_1;

    /* write the data, fail if unsuccessful */
    if(oswrite(fcb->mode, fcb->rsz, ffscblk.len, iob, &ffscblk) != 0)
        return EXIT_2;

    return NORMAL_RETURN;
}
