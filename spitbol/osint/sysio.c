/*
/	File:  SYSIO.C		Version:  01.07
/	---------------------------------------
/
/	Contents:	Function zysio
*/
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */

/*
/   zysio - fill in file control block
/
/   This function fills in the i/o control blocks requested by zysfc.
/   Remember that spitbol compiler has allocated a single block of
/   the requested length;  it is the responsibility of this function
/   to divide this large block into smaller blocks as needed.
/
/   Parameters:
/	xl	pointer to scblk holding filearg1 (channel id)
/	xr	pointer to scblk holding filearg2 (filename & args)
/	wa	pointer to fcblk or 0
/	wb	0/3 for input/output association
/   Returns:
/	xl	fcblk pointer
/	wc	maximum record length
/   Exits:
/	1	file does not exist
/	2	I/O not allowed
/
/  1.04		If filearg2 is null, filearg1 can be an environment
/		variable that points to the real filename.  Flag IO_ENV
/		notes this case, and iob->fnm points to filearg1 instead
/		of filearg 2.
/
/ 1.05 06-Feb-91 Changed for read/write I/O.
/
/ 1.06 01-Feb-93 Split record size into two fields (rsz and mode), to
/				 prevent negative record size appearing to be a valid
/				 pointer in 8088 SPITBOL.
/
/ 1.07 26-Oct-94 Added share field to ioblk.
*/

#include "port.h"

extern struct ioblk	tioblk;

zysio()
{
    register char	*charptr = WA( char *);
    register struct fcblk	*fcb;
    register struct ioblk	*iob;
    register struct bfblk	*bfb;

    /*
    /	If zysfc() marked this I/O association as illegal, return an error
    */
    if ( tioblk.flg2 & IO_ILL )
        return  EXIT_2;

    fcb = (struct fcblk *) charptr;		/* 1.03 MBE	*/
    /*
    /	If a new FCB has been allocated, fill it in.
    */
    if ( tioblk.typ )
    {
        fcb->len = FCSIZE;
        if (tioblk.len >= 0) {
            fcb->rsz = tioblk.len;	/* line mode */
            fcb->mode = 1;
        }
        else {
            fcb->rsz = -tioblk.len;	/* raw mode */
            fcb->mode = 0;
        }
        fcb->iob = MP_OFF(save_iob, struct ioblk NEAR *);

        /*
        /	If allocating a new FCB, check to see if it is the first FCB for
        /	this association.  If so, allocate a IOBLK and BFBLK too.
        /
        /	This is done by carving the allocated block into three blocks.  This
        /	is safe so long as we are sure to set the type and length fields for
        /	the garbage collector.
        */
        if ( save_iob == 0 )
        {

            /*
            /	Establish pointers to IOBLK and BFBLK.
            */
            charptr += FCSIZE;	/* point to IOBLK	*/
            iob = (struct ioblk *)charptr;
            fcb->iob = MP_OFF(iob, struct ioblk NEAR *);
            charptr += IOSIZE;	/* point to BFBLK	*/
            bfb = (struct bfblk *) charptr;

            /*
            /	Fill in IOBLK.
            */
            iob->typ = TYPE_XRT;	/* type: external reloc	*/
            iob->len = IOSIZE;		/* length		*/
            iob->fnm = MP_OFF((tioblk.flg2 & IO_ENV) ?
                              XL( struct scblk *) :  /* filearg 1	*/
                              XR( struct scblk * ), struct scblk NEAR *);  /* filename	*/

            iob->pid = 0;			/* process id		*/
            iob->bfb = MP_OFF(bfb, struct bfblk NEAR *);	/* buffer		*/
            iob->fdn = tioblk.fdn;	/* file descriptor	*/
            iob->flg1 = tioblk.flg1;/* flags		*/
            iob->flg2 = tioblk.flg2;
            iob->eol1 = tioblk.eol1;/* end of line chars	*/
            iob->eol2 = tioblk.eol2;
            iob->share = tioblk.share;	/* sharing mode */
            iob->action= tioblk.action; /* file open action */

            /*
            /	If system file (file descriptor provided),
            /	be sure that there is consistency in
            /	handling of file descriptors 0, 1, 2.
            */
            if ( iob->flg1 & IO_SYS )
            {
                switch( iob->fdn )
                {
                case 0:
                    iob->bfb = MP_OFF(pINPBUF, struct bfblk NEAR *);
                    break;
                case 1:
                    iob->bfb = 0;
                    iob->flg1 |= IO_WRC;
                    break;
                default:
                    break;
                }
            }

            /*
            /	Fill in BFBLK.
            */
            bfb->typ = TYPE_XNT;	/* type: external nonreloc */
            bfb->len = bfblksize;	/* length		*/
            bfb->size = tioblk.pid;	/* buffer size		*/
            bfb->fill = 0;		/* chars in buffer	*/
            bfb->next = 0;		/* next read/write pos	*/
            bfb->offset = (FILEPOS)0;  /* file offset of 1st byte in buffer */
            bfb->curpos = (FILEPOS)0;  /* physical file position */
        }
    }

    /*
    /	If file is not open, open it now so that 'file not found' exit
    /	can be taken.
    */
    iob = MK_MP(fcb->iob, struct ioblk *);

    if ( !(iob->flg1 & IO_OPN) ) {
        if ( osopen(iob) != 0 )
            return EXIT_1;
#if WINNT
        if ( fcb->mode == 0 )				/* set binary bit for doset */
            iob->flg2 |= IO_BIN;		/*  only on initial open */
#endif               /* WINNT */
    }

    /*
    /	If file is a TTY device, and raw I/O requested, set IO_RAW in
    /	iob->flg.  The RAW bit within the device will be turned on and
    /	off as appropriate when the read or write operation is done.
    */
    if ( ( testty( iob->fdn ) == 0 ) &&	/* If TTY device	*/
            ( fcb->mode == 0 ) )			/* and raw mode file	*/
        iob->flg2 |= IO_RAW;		/* then set IO_RAW bit	*/

#if WINNT
    if ( iob->flg1 & IO_INP && cindev( iob->fdn ) == 0 )	/* Test for character input */
        iob->flg1 |= IO_CIN;
#endif               /* WINNT */

    /*
    /	Normal return.
    */
    SET_WC( 0 );
    SET_XL( WA(word) );
    return  NORMAL_RETURN;
}
