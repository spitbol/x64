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
/	File:  WRTAOUT.C	Version:  01.02
/	---------------------------------------
/
/	Contents:	Function openaout
/			Function wrtaout
/			Function seekaout
/			Function closeaout
/
/   These functions are used to write an executable "a.out" file containing
/   the currently executing spitbol program.
*/

#include "port.h"

#include <sys/types.h>
#include <sys/times.h>

#include <fcntl.h>


/*  openaout(file, tmpfnbuf, exe)
/
/   Parameters:
/	file = file name
/	tmpfnbuf = buffer where we can build temp file name
/	exe = IO_EXECUTABLE to mark file as executable, else 0
/   Returns:
/	0	successful. Variable aoutfd set to file descriptor.
/	-1	create error for "a.out"
*/
int openaout(fn, tmpfnbuf, exe)
char *fn;
char *tmpfnbuf;
int	exe;
{
    char			*p;
    unsigned int	m,n;

    mystrcpy(tmpfnbuf, fn);
    n = (unsigned int)clock();
    m = n = n - ((n / 10000) * 10000);		// put in range 0 - 9999
    for (;;) {
        p = pathlast(tmpfnbuf);				// p = address we can append to
        p = mystrcpy(p, "temp");
        p += stcu_d(p, n, 4);
        mystrcpy(p, ".tmp");
        if (access(tmpfnbuf, 0) != 0)
            break;
        n++;
        n = n - ((n / 10000) * 10000);		// put in range 0 - 9999
        if (m == n)
            return -1;
    }

    if ( (aoutfd = spit_open( tmpfnbuf, O_WRONLY|O_TRUNC|O_CREAT,
                              IO_PRIVATE | IO_DENY_READWRITE | exe /* ? 0777 : 0666 */,
                              IO_REPLACE_IF_EXISTS | IO_CREATE_IF_NOT_EXIST )) < 0 )
        return	-1;
    fp = (FILEPOS)0;           //   file position
    return 0;
}

/*
/   wrtaout( startadr, size )
/
/   Parameters:
/	startadr	char pointer to first address to write
/	size		number of bytes to write
/   Returns:
/	0	successful
/	-2	error writing memory to a.out
/
/   Write data to a.out file.
*/
int wrtaout( startadr, size )
unsigned char *startadr;
uword size;
{
    if ( (uword)write( aoutfd, startadr, size ) != size )
        return	-2;

    fp += size;			//   advance file position
    return 0;
}

#if EXECFILE
/*
/   seekaout( pagesize )
/
/   Parameters:
/	pagesize	power of two (e.g. 1024)
/   Returns:
/	0	successful
/  -3 LSEEK to pagesize-1 file position failed
/	-4	forced write to pagesize boundary failed
/
/   Seek and extend file to power of two boundary.
*/

int seekaout( pagesize )
long pagesize;
{
    register long excess;

    /*
    /   If fp not multiple of pagesize, force file size up to multiple.
    /   Notice trick to force file size up:  seek to 1 character in front
    /   of desired length, then write a single character at that position.
    /   The file system will fill in seeked over characters.
    */
    if ( (excess = ((long)fp & (pagesize - 1))) != 0 )
    {
        excess	= pagesize - excess;
        if ( LSEEK( aoutfd, (FILEPOS)(excess-1), 1 ) < (FILEPOS)0 )
            return	-3;
        if ( write( aoutfd, "", 1 ) != 1 )
            return	-4;
        fp += (FILEPOS)excess;
    }

    return 0;
}
#endif					// EXECFILE


/*
/   closeaout(filename)
/
/   Parameters
/	filename
/   Returns:
/	none
/
/   Close "a.out" file and return.
*/

word closeaout(fn, tmpfnbuf, errflag)
char *fn;
char *tmpfnbuf;
word errflag;
{
    close( aoutfd );
    if (errflag == 0)
    {
        unlink(fn);							// delete old file, if any
        if (rename(tmpfnbuf, fn) != 0)
            errflag = -1;					// if can't rename it
    }
    if (errflag != 0)						// if failing, delete temp file
        unlink(tmpfnbuf);
    return errflag;
}


/*
/   rdaout( fd, startadr, size ) - read in section of file created by wrtaout()
/
/   Parameters:
/	fd		file descriptor
/	startadr	char pointer to first address to read
/	size		number of bytes to read
/   Returns:
/	0	successful
/	-2	error reading from a.out
/
/   Read data from .spx file.
*/
int rdaout( fd, startadr, size )
int	fd;
unsigned char *startadr;
uword size;
{
    if ( (uword)read( fd, startadr, size ) != size )
        return	-2;

    fp += size;			//   advance file position
    return 0;
}
