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


#include "port.h"
//#include <unistd.h>
typedef int HFILE;

char	*getshell();
char	*lastpath();

static int doshell (struct ioblk *ioptr);
/*
/   ospipe( ioptr )
/
/   ospipe() builds a pipe for the command associated with the passed IOBLK.
/
/   Parameters:
/	ioptr	pointer to IOBLK for command
/   Returns:
/	file descriptor returned by pipe system call, -1 if error
*/

int ospipe( ioptr )
struct	ioblk	*ioptr;

{
    int   childpid;
    HFILE childfd, parentfd, savefd, stdfd, fd[2];

    if ( (ioptr->flg1 & (IO_INP | IO_OUP)) == (IO_INP | IO_OUP) )
        return -1;		// can't open read/write pipe
    /*
    /	Fail if system call to create pipe fails.
    */
    if ( pipe( fd ) < 0 )
        return -1;

    /*
    /	Set up file descriptors properly based on whose reading from pipe/
    /	writing to pipe.
    */
    if ( ioptr->flg1 & IO_INP ) {
        parentfd = fd[0];	// parent reads from fd[0]
        childfd  = fd[1];	// child writes to fd[1]
        stdfd = 1;
    }
    else {
        parentfd = fd[1];	// parent writes to fd[1]
        childfd  = fd[0];	// child reads from fd[0]
        stdfd = 0;
    }

    /*
    /	Execute the proper code based on whose process is the parent and
    /	whose is the child.
    */
    switch ( childpid = fork() ) {
        int n;
    case -1:
        /*
        /   Fork failed, so close up files and return -1.
        */
        close( parentfd );
        close( childfd );
        parentfd = -1;
        break;

    case 0:
        /*
        /   Child executes here.  Set up file descriptors 0 & 1 properly
        /   and close any file descriptors open above 2.
        /
        /    If parent is expecting to read from us, we must write
        /    via file descriptor 1 to childfd.
        /    If parent is expecting to write to us, we must read via
        /    file descriptor 0 from childfd.
        */
        close( stdfd );

        /*
        /   Duplicate childfd to be either child's (our) fd 0 or 1.
        */
        dup( childfd );

        /*
        /   Close all unnecessary file descriptors.
        */
        for ( n=3 ; n<=OPEN_FILES ; close( n++ ) )
            ;

        if (doshell(ioptr) == -1)
            return -1;
        __exit(1);			// Should never get here!

    default:
        /*
        /   Parent executes here.  Remember process id of child and close
        /   its file descriptor.
        */
        ioptr->pid = childpid;
        close( childfd );
        break;
    }
    /*
    /	Control comes here ONLY in parent process. Return the file descriptor
    /	to be used for communication with child process or -1 if error.
    */
    return parentfd;
}


static int doshell( ioptr )
struct	ioblk	*ioptr;
{
#define CMDBUFLEN 1024
    struct	scblk	*scptr;
    char    *shellpath, cmdbuf[CMDBUFLEN];
    int     len;

    /*
    /   Set up to execute command.
    /
    /   Be sure to point properly at start of command and to
    /   terminate it with a Nul character.  Remember that
    /   command is in string with form "!*command* options".
    */
    scptr = ((struct scblk *) (ioptr->fnm));	// point to cmd scblk
    if (ioptr->flg2 & IO_ENV) {
        if (optfile(scptr, ptscblk))
            return -1;
        scptr = ptscblk;
        ptscblk->len = lenfnm(scptr);	// remove any options
    }
    len   = lenfnm( scptr ) - 2;        // length of cmd without ! & delimiter
    if (len >= CMDBUFLEN)
        return -1;
    mystrncpy( cmdbuf, &scptr->str[2], len);// get command
    if ( cmdbuf[len-1] == scptr->str[1] )   // if necessary
        len--;                              //   zap 2nd delimiter
    cmdbuf[len] = '\0';                     // Nul terminate cmd
    shellpath = getshell();         // get shell's path
#ifdef  exec
// suppress call as it generates warning message we don't need for now. 
    execl( shellpath, pathlast( shellpath ), "-c", cmdbuf, (char *)NULL );
#endif
    return -1;					// should not get here
}

