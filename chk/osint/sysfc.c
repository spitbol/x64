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
/   sioarg( ioflg,ioptr,scptr )
/
/   sioarg() scans any arguments after the filename in the passed SCBLK and
/   sets appropriate values in the passed ioblk.
/
/   Parameters:
/	ioflg	0 - input association/ 3 - output association
/	ioptr	pointer to IOBLK representing file
/	scptr	pointer to SCBLK containing filename and args
/   Returns:
/	0 - options successfully processed / -1 - option error
/   Side Effects:
/	Modifies contents of passed IOBLK (ioptr).
/
*/

#include "port.h"

static int
sioarg( ioflg, ioptr, scptr )
int	ioflg;
struct	ioblk	*ioptr;
struct	scblk	*scptr;

{
    int	lastdash = 0;
    word	cnt, v, share;
    char	ch, *cp;

    cp	= scptr->str;

    /*
    /	Initialize the default values for an I/O association.  Note that
    /	some of the fields are used here for purposes other than their
    /	normal uses.
    /
    /	typ	arguments found flag:  0 - no args / 1 - args found
    /		(when no args are present assume that this association has
    /		same properties as previous association for THIS file.)
    /	len	record mode and length:  >0 line mode / <0 raw mode
    /	pid	buffer size
    / fdn shell or external function provided file descriptor (IO_SYS flag)
    /	flg1,2	IO_INP or IO_OUP as appropriate and other flags
    */
    ioptr->typ = 0;			// no args seen yet
    ioptr->fdn = 0;			// no shell provided fd
    ioptr->pid = IOBUFSIZ;	// buffer size
    if (ioflg)
    {   // output
        ioptr->len = maxsize;	// line mode record len
        ioptr->flg1 = IO_OUP;
        ioptr->share = IO_DENY_READWRITE | IO_PRIVATE;
        ioptr->action= IO_REPLACE_IF_EXISTS | IO_CREATE_IF_NOT_EXIST;
    }
    else
    {   // input
        ioptr->len = IRECSIZ;	// line mode record len
        ioptr->flg1 = IO_INP;
        ioptr->share = IO_DENY_WRITE | IO_PRIVATE;
        ioptr->action = IO_OPEN_IF_EXISTS;
    }
    ioptr->flg2 = 0;
    /*
    /	If lenfnm() fails so shall we.
    */
    if ( (cnt = lenfnm( scptr )) < 0 )
        return	-1;

    /*
    /	One iteration per character.  Note that scanning an integer causes
    /	more than one character to be handled in an iteration.
    */
    while ( cnt < scptr->len )
    {
        ch = uppercase(*(cp + cnt++));	// get next character
        switch (ch)
        {
        case ' ':
        case '\t':
        case ',':
        case '[':
        case ']':
            lastdash = 0;
            continue;

        case '-':
            if ( lastdash != 0 )	// "--" is illegal
                return ( -1 );
            else
            {
                lastdash = 1;	// saw an '-'
                continue;
            }

            /*
            /   A - append output at end of existing file
            */
        case 'A':
            ioptr->flg1 |= IO_APP;
            ioptr->action &= ~IO_REPLACE_IF_EXISTS;
            ioptr->action |= IO_CREATE_IF_NOT_EXIST | IO_OPEN_IF_EXISTS;
            break;

            /*
            /   B - set size of I/O buffer (stored in pid field).
            */
        case 'B':
            v = scnint( cp + cnt, scptr->len - cnt, &cnt );
            if ( v > 0  &&
                    ((v + sizeof(word) - 1) & ~(sizeof(word) - 1)) <= (maxsize - BFSIZE) )
                ioptr->pid = v;
            else
                return	-1;
            break;

            /*
            /   C - set raw mode, character at a time access.
            */
        case 'C':
            ioptr->len = -1;
            break;

            /*
            /   E- ignore end-of-text character (DOS only)
            */
	// Support for EOT eliminated on 1 Feb 2013 since not needed for Linux.

            /*
            /   F - set file descriptor number (file opened by shell or external func).
            */
        case 'F':
            v = scnint( cp + cnt, scptr->len - cnt, &cnt );
            ioptr->fdn = v;
            ioptr->flg1 |= ( IO_OPN | IO_SYS );
            if ( ioflg && (testty(v) == 0) )
                ioptr->flg1 |= IO_WRC;

            break;

            /*
            /	I - make file inheritable by any child processes
            */
        case 'I':
            ioptr->share &= ~IO_PRIVATE;
            break;

            /*
            /   L - line mode access having max record length v.
            */
        case 'L':
            v = scnint( cp + cnt, scptr->len - cnt, &cnt );
            if ( v > 0 && (uword)v <= maxsize )
                ioptr->len = v;
            else
                return	-1;
            break;

	/* M and N options no longer needed (DS 1 Feb 2013)

            /*
            /   R - raw mode access of v characters.
            /   Q - like R, but no echo (quiet) if console input.
            */
        case 'Q':
            ioptr->flg2 |= IO_NOE;
        case 'R':
            v = scnint( cp + cnt, scptr->len - cnt, &cnt );
            if ( v > 0 && v <= (word)maxsize )
                ioptr->len = -v;
            else
                return	-1;
            break;

            /*
            /	S - sharing mode:
            /		-sdn	=	deny none
            /		-sdr	=	deny read
            /		-sdw	=	deny write
            /		-sdrw	=	deny read/write
            */
        case 'S':
            ch = uppercase(*(cp + cnt++));	// get next character
            if (ch != 'D')
                return -1;
            ch = uppercase(*(cp + cnt++));	// get next character
            switch (ch)
            {
            case 'N':
                share = IO_DENY_NONE;
                break;
            case 'R':
                share = IO_DENY_READ;
                if (uppercase(*(cp + cnt)) == 'W') {
                    share = IO_DENY_READWRITE;
                    cnt++;
                }
                break;
            case 'W':
                share = IO_DENY_WRITE;
                break;
            default:
                return -1;
            }

            if (cnt >= scptr->len)
                return -1;
            ioptr->share = (ioptr->share & ~IO_DENY_MASK) |  share;
            break;

            /*
            /   U - update access to file
            */
        case 'U':
            ioptr->flg1 |= (IO_INP | IO_OUP);
            if (ioptr->len == (word)maxsize)
                ioptr->len = IRECSIZ;	// limit to input record len
            ioptr->action &= ~IO_REPLACE_IF_EXISTS;
            ioptr->action |= IO_CREATE_IF_NOT_EXIST | IO_OPEN_IF_EXISTS;
            break;

            /*
            /   W - write with no buffering within SPITBOL.
            */
        case 'W':
            ioptr->flg1 |= IO_WRC;
            break;

            /*
            /	X - mark file executable
            */
        case 'X':
            ioptr->share |= IO_EXECUTABLE;
            break;

            /*
            /   Y - write with no buffering within SPITBOL or within operating system.
            */
        case 'Y':
            ioptr->flg1 |= IO_WRC;
            ioptr->action |= IO_WRITE_THRU;
            break;

            /*
            /   Unknown argument.
            */
        default:
            return	-1;
        }

        /*
        /   Indicate that an argument was found and processed and
        /   that the last character processed was not a '-'.
        */
        ioptr->typ = 1;		// processed arg
        lastdash = 0;		// last char not a '-'
    }
    /*
    /	Return successful scanning.
    */
    return	0;
}


/*
/   scnint( str, len, intptr )
/
/   scnint() scans and converts a decimal number at the front of a string.
/   "len" specifies the maximum number of digits that can be scanned.
/
/    Parameters:
/	str	pointer to string containing number at front
/	len	maximum number of digits to scan
/	intptr	pointer to integer to be adjusted by number of digits scanned
/    Returns:
/	Integer converted
/    Side Effects:
/	Modifies integer pointed to by intptr.
*/


word	scnint( str, len, intptr )

char	*str;
word	len;
word	*intptr;

{
    register word	i = 0;
    register word	n = 0;
    register char	ch;

    while ( i < len )
    {
        ch	= str[i++];
        if ( ch >= '0'  &&  ch <= '9' )
            n = 10 * n + ch - '0';
        else
        {
            --i;
            break;
        }
    }
    *intptr += i;
    return	n;
}
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
            scb2 = ptscblk;
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
