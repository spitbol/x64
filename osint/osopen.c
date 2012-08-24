/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

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
        File:  OSOPEN           Version:  01.06
        ---------------------------------------

        Contents:       Function osopen

        Revision history:

        V01.01  Was testing for successful file open with (fd != 0) and
                (fd >0).  If user ever explicitly closed fd 0, fd 0 would
                be available for normal use by a file open.

        V01.02  Look at flag IO_ENV, and if set, fnm string is the name
                of an environment variable pointing to the filename.

        V01.03  For MS-DOS, remove trailing ':', if any, from file name.
                DOS does not like names like "CON:".

        V01.04  File name "-" attaches to standard input or output.

        V01.05  For MS-DOS on 386, process IO_COT option.

        V01.06  Handle files open for update.
*/

/*
    osopen( ioptr )

    osopen() opens the file represented by the passed ioblk.  If the file
    is actually a command, osopen() establishes a pipe to access the
    command.

    Parameters:
        ioptr   pointer to IOBLK representing file
    Returns:
        0 - file opened successfully / -1 - open failed
*/

#include "port.h"

#if AIX | SOLARIS | LINUX
#include <fcntl.h>
#endif

int     osopen( ioptr )
struct  ioblk   *ioptr;

{
    word        fd;
    char        savech;
    word        len;
    char        *cp;
    struct      scblk   *scptr;

    /*
    /   If file already open, return.
    */
    if ( ioptr->flg1 & IO_OPN )
        return 0;

    /*
    /   Establish a few pointers and filename length.
    */
    scptr       = MK_MP(ioptr->fnm, struct scblk *);    /* point to filename SCBLK      */
    if (ioptr->flg2 & IO_ENV)
    {
        if (optfile(scptr, ptscblk))
            return -1;
        scptr = ptscblk;
        ptscblk->len = lenfnm(scptr);   /* remove any options */
    }

    cp  = scptr->str;           /* point to filename string     */
    len = lenfnm( scptr );      /* get length of filename       */

#if PIPES
    /*
    /   Handle pipes here.
    */
    if ( cp[0] == '!' )         /* if pipe ...                  */
    {
        ioptr -> flg2 |= IO_PIP;        /*   then set flag and          */
        fd = ospipe( ioptr );   /*      let ospipe() do work    */
    }


    /*
    /   Handle files here.
    */
    else
#endif                                  /* PIPES */

    {
#if WINNT
        /* Check for CON:, AUX:, LPT1:, etc., and remove colon */
        if ((len == 4 || len == 5) && cp[len - 1] == ':')
            len--;
#endif               /* WINNT */

        savech  = make_c_str(&cp[len]); /*   else temporarily terminate filename */
        if ( ioptr->flg1 & IO_OUP ) /*  output file             */
        {
            fd = -1;    /* force creat if not update or append  */

            /* Look for "-" as a file name.  Assign to fd 1 */
            if (len == 1 && *cp == '-')
            {
                fd = STDERRFD;          /* was STDOUTFD, changed for WinNT */
                ioptr->flg1 |= IO_SYS;
            }
            else
            {
                /* default mode:
                 *   create file if it doesn't exist
                 *   open for read/write so we can fill buffer after a seek
                 *    (even if this is a write only from file from the user's
                 *    point of view)
                 *   if file is not buffered and not appending or updating,
                 *    use O_WRONLY instead of O_RDWR.
                 */
                int mode = O_CREAT;             /* create file if it doesn't exist */

                if (ioptr->flg1 & IO_WRC && !(ioptr->action & IO_OPEN_IF_EXISTS))
                    mode |= O_WRONLY;
                else
                    mode |= O_RDWR;

                /* if not update or append mode */
                if (!(ioptr->flg1 & (IO_INP|IO_APP)))
                    mode |= O_TRUNC;                    /* truncate existing file */

                fd = spit_open( cp, mode, ioptr->share /* 0666 */, ioptr->action);
            }

        }
        else                    /* input-only file              */
        {
            /* Look for "-" as a file name.  Assign to fd 0 */
            if (len == 1 && *cp == '-')
            {
                fd = STDINFD;
                ioptr->flg1 |= IO_SYS;
            }
            else
                fd = spit_open( cp, O_RDONLY, ioptr->share /* 0 */, ioptr->action);
        }
        unmake_c_str(&cp[len], savech); /* restore filename string      */
    }

    /*
    /   If file/pipe opened successfully, then set
    /
    /   o  file descriptor number in IOBLK
    /   o  open flag in IOBLK
    /   o  if output file is a TTY device, set the IO_WRC flag (no buffering)
    /   o  if IO_WRC flag set, throw away the buffer
    /   o  if output, append and not pipe, seek to end of file.
    /
    /   and then do a normal return.
    */
    if (fd != -1)
    {
        ioptr->fdn = (word)fd;
        ioptr->flg1 |= IO_OPN;
        if ( ioptr->flg1 & IO_OUP  &&  testty( fd ) == 0 )
            ioptr->flg1 |= IO_WRC;
#if WINNT
        /* Test for character input */
        if ( ioptr->flg1 & IO_INP && cindev( ioptr->fdn ) == 0 )
            ioptr->flg1 |= IO_CIN;
#endif               /* WINNT */

#if HOST386
        /* Test for character output.  Definicon doesn't have screen functions */
        if ( ioptr->flg1 & IO_OUP && coutdev( ioptr->fdn ) == 0 )
            ioptr->flg1 |= IO_COT;
#endif                                  /* HOST386 */

        if ( ioptr->flg1 & IO_WRC )
            ioptr->bfb = 0;

        if ( (ioptr->flg1 & (IO_OUP|IO_APP)) == (IO_OUP|IO_APP) &&
                !(ioptr->flg2 & IO_PIP))
            doset(ioptr, 0L, 2);
        return 0;
    }

    /*
    /   When control passes here the open/pipe has failed so return -1.
    */
    return  -1;
}
