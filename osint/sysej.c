/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields
*/

/*
/	zysej - end job
/
/	zysej is called to terminate spitbol's execution.  Any open files
/	will be closed before calling __exit.
/
/	Parameters:
/	    WA - value of &ABEND keyword (always 0)
/	    WB - value of &CODE keyword
/	    XL - pointer to FCBLK chain
/	Returns:
/	    NO RETURN
*/

#include "port.h"

#if EXTFUN
unsigned char *bufp;
#endif					// EXTFUN


/*
/  close_all - Close all files.
/
/  Parameters:
/	chfcb	pointer to FCBLK chain or 0
/  Returns:
/	Nothing
/  Side Effects:
/	All files on the chain are closed and buffers flushed.
*/

void close_all(chb)

register struct chfcb *chb;

{
    while( chb != 0 )
    {
        osclose( ((struct ioblk *) (((struct fcblk *) (chb->fcp))->iob)) );
        chb = ((struct chfcb *) (chb->nxt));
    }
}



int zysej()
{

    if (!in_gbcol) {		// Only if not mid-garbage collection
        close_all( XL( struct chfcb * ) );

#if EXTFUN
        scanef();					// prepare to scan for external functions
        while (nextef(&bufp, 1))	// perform closing callback to some
            ;
#endif					// EXTFUN

    }
    /*
    /	Pass &CODE to function __exit.  Don't call standard exit function,
    /	because of its association with the stdio package.
    */
    __exit( WB(int) );

}

