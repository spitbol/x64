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
        File:  TESTTY.C         Version:  01.04
        ---------------------------------------

        Contents:       Function testty
                        Function ttyraw
*/

/*
    testty( fd )

    testty() determines whether or not a file descriptor represents a
    teletype (non-block) device.

    Parameters:
        fd      file descriptor to test
    Returns:
        0 if fd is a tty / -1 if fd is not a tty
*/
#include "port.h"

#if AIX | SOLARIS | LINUX
#define RAW_BIT RAW
#endif

#if UNIX
#include <sys/stat.h>
struct  stat    statbuf;
#if LINUX
#include <termios.h>
struct termios termiosbuf;
#else
#include <sgtty.h>
struct  sgttyb  sgtbuf;
#endif
#endif

int testty( fd )

int     fd;

{
#if WINNT
    return  chrdev( fd ) ? 0 : -1;
#else
    if (fstat(fd, &statbuf))
        return -1;
    return      S_ISCHR(statbuf.st_mode) ? 0 : -1;
#endif
}


/*
     ttyraw( fd, flag )

     ttyraw() sets or clears the raw input mode in an teletype device.

     Parameters:
        fd      file descriptor
        flag    0 to clear raw mode / non-zero to set raw mode
     Returns:
        none

*/

void ttyraw( fd, flag )

int     fd;
int     flag;

{
    /* read current params      */
#if WINNT
    rawmode( fd, flag ? -1 : 0 );               /* Set or clear raw mode*/
#elif LINUX
    if ( testty( fd ) ) return;     /* exit if not tty  */
    tcgetattr( fd, &termiosbuf );
    if ( flag )
        termiosbuf.c_lflag &= ~(ICANON|ECHO); /* Setting      */
    else
        termiosbuf.c_lflag |= (ICANON|ECHO);    /* Clearing     */

    tcsetattr( fd, TCSANOW, &termiosbuf );     /* store device flags   */
#else
    if ( testty( fd ) ) return;         /* exit if not tty      */
    ioctl( fd, TIOCGETP, &sgtbuf );
    if ( flag )
        sgtbuf.sg_flags |= RAW_BIT;     /* Setting              */
    else
        sgtbuf.sg_flags &= ~RAW_BIT;    /* Clearing             */

    ioctl( fd, TIOCSETP, &sgtbuf );             /* store device flags   */
#endif
}
