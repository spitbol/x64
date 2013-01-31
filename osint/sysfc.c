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
/ File:  SYSFC.C    Version:  01.04
/	---------------------------------------
/
/	Contents:	Function zysfc
*/

/*
/   zysfc - setup file control block
/
/   This is sort of a messy function that determines from the I/O association
/   arguments, what type of I/O is to be done and which i/o control blocks
/   are needed.  There are a number of possiblities:
/
/   For the first call to zysfc that establishes an i/o channel, allocate:
/	fcblk & ioblk & bfblk
/
/   For a second, third, ... call to zysfc that establishes a different type
/   of access to an existing i/o association, allocate:
/	fcblk
/
/   For a second, third, ... call to zysfc that does specify any arguments,
/   allocate:
/	nothing, use existing fcblk
/
/   Notice that of the three blocks that are allocated, only the BFBLK
/   has a varying size;  its size depends on the buffer size specified
/   as an I/O argument.
/
/   Parameters:
/	xl	pointer to scblk holding filearg1 (channel id)
/	xr	pointer to scblk holding filearg2 (filename & args)
/	wa	pointer to existing fcblk or 0
/	wb	0/3 for input/output association
/	wc	number of scblk pointers on stack (forced to zero by interface)
/   Returns:
/	wa = xl = 0	Nothing to allocate
/	wa > 0		Size of requested fcblk
/	wa = 0, xl > 0	Private fcblk pointer in xl
/	wc		0/1/2 for xrblk/xnblk/static allocation request
/
/   Exits:
/	1	invalid file argument
/       2 channel already in use
/
*/

#include "port.h"

struct ioblk	tioblk;			// temporary ioblk

zysfc()
{
    int	fd_spec, i;
    word	allocsize, length_fname;
    register struct scblk *scb1 = XL( struct scblk * );
    register struct scblk *scb2 = XR( struct scblk * );
    register struct fcblk *fcb  = WA( struct fcblk * );
    word use_env = 0;   // Initially, flag that not using environment block

    /*
    /   Bad filearg2 or NULL filearg1 is an error
    */
again:
    if ( (length_fname = lenfnm( scb2 )) < 0  ||  !scb1->len )
        return  EXIT_1;

    /*
    /   Scan out I/O arguments and build temporary ioblk.
    */
    if ( sioarg( WB(int), &tioblk, scb2 ) < 0 )
        return  EXIT_1;

    /*
    /   If previous I/O association on this channel, be sure that type
    /   of access is consistent with current call.  I.e., both are
    /   input or both are output.  An illegal association is marked
    /   with the IO_ILL flag and SYSIO does the error return.
    */
    if ( fcb )
    {
        i = ((struct ioblk *) (fcb->iob))->flg1 & (IO_INP | IO_OUP);
        if ( !(tioblk.flg1 & i) )
            tioblk.flg2 |= IO_ILL;
    }

    /*
    /   Processing now is dependent on how filename is supplied
    */
    fd_spec = tioblk.flg1 & IO_OPN;
    if ( length_fname  ||  fd_spec )
    {
        /*
        /   CANNOT specify BOTH filename and -f option!
        /   CANNOT specify filename with existing open FCB
        /
        /   Unopened FCB may be present if previous sysio failed
        /   on this channel.  V1.02 MBE
        /
        /	Note that allocsize may exceed MXLEN, because ALLOC doesn't
        /	check it, and we will carve the allocated block into three
        /	chunks, each of which will be MXLEN or less.
        */
        if ( (length_fname && fd_spec) )
            return EXIT_1;
        if ( (fcb && (((struct ioblk *) (fcb->iob))->flg1 & IO_OPN)) )
            return EXIT_2;

        save_iob = 0;
        bfblksize = (BFSIZE + tioblk.pid + sizeof( word ) - 1 )
                    & ~(sizeof( word ) - 1);
        allocsize = FCSIZE + IOSIZE + bfblksize;
        tioblk.typ = 1;
    }

    /*
    /   With a NULL filename there MUST BE an existing fcblk for us
    /   to use!
    /   1.03 - Lookup filearg1 in environment block before giving up.
    /   Use presence of arguments to allocate a new FCB.
    */
    else
    {
        if ( !fcb )					// if no FCB then error
        {
            /*
            	/ 1.03 - look up in environment block.  Filename
            	/	 will be copied to tscblk.
            	*/
            scb2 = pTSCBLK;
            if (!optfile(scb1, scb2) && !use_env)
            {
                use_env = IO_ENV;
                goto again;
            }
            return  EXIT_1;
        }
        if ( tioblk.typ )		// if args then
        {
            allocsize = FCSIZE;	//    alloc new FCB
            // BAD!! Garbage collect could move ioblk before sysio is called
            save_iob = ((struct ioblk *) (fcb->iob));
        }
        else				// if no args then
            allocsize = 0;		//   no new FCB needed
    }

    /*
    /   Do a normal return here.
    */
    tioblk.flg2 |= use_env; //  record use of environment for sysio
    SET_WA( allocsize );  //  size of block to alloc or 0
    SET_WC( 0 );		//  xrblk please
    SET_XL( 0 );		//  no private fcblk

    return NORMAL_RETURN;
}
