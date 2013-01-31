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
/   testty( fd )
/
/   testty() determines whether or not a file descriptor represents a
/   teletype (non-block) device.
/
/   Parameters:
/	fd	file descriptor to test
/   Returns:
/	0 if fd is a tty / -1 if fd is not a tty
*/
#include "port.h"

#define RAW_BIT RAW

#include <sys/stat.h>
struct  stat	statbuf;
#include <termios.h>
struct termios termiosbuf;

int testty( fd )

int	fd;

{
    if (fstat(fd, &statbuf))
        return -1;
    return	S_ISCHR(statbuf.st_mode) ? 0 : -1;
}


/*
/    ttyraw( fd, flag )
/
/    ttyraw() sets or clears the raw input mode in an teletype device.
/
/    Parameters:
/	fd	file descriptor
/	flag	0 to clear raw mode / non-zero to set raw mode
/    Returns:
/	none
/
*/

void ttyraw( fd, flag )

int	fd;
int	flag;

{
    // read current params
    if ( testty( fd ) ) return;     // exit if not tty
    tcgetattr( fd, &termiosbuf );
    if ( flag )
        termiosbuf.c_lflag &= ~(ICANON|ECHO); // Setting
    else
        termiosbuf.c_lflag |= (ICANON|ECHO);    // Clearing

    tcsetattr( fd, TCSANOW, &termiosbuf );     // store device flags
}
