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
/	File:  SWCINP.C		Version:  01.16
/	---------------------------------------
/
/	Contents:	Function swcinp
/
/	Revision history:
/
/	01.16	04-Apr-95 If no end statement after reading source files,
/					  alert user.
/
/ 01.15 18-Oct-90 <withdrawn>
/
/	01.14	23-Jun-90 Function pathlast() moved here from getshell.c
/
/	01.13	11-May-90 Close save_fd0 in restore0() after dup.  Omission
/			was leaving save_fd0 handle busy after each save/restore cycle.
/
/	01.12	Added sfn as a pointer to the source file name currently being read.
/		Used by sysrd to pass file names to the compiler.
/
/	01.11   Moved curfile to osint for reinitialization when compiler serially reused.
/
/	01.10	As a result of using fd 0 to read both source files and
/		keyboard input, the following anomally occurs:
/
/		After reading the END statement of a source file, execution
/		begins with fd 0 connected to that source file (typically
/		positioned at the EOF following the END statement.  When
/		the user's program reads from INPUT, the EOF detected produces
/		a call to swcinp(), and fd 0 is switched from the source file
/		to the "true" standard input.
/
/		However, if prior to the first call to INPUT, the user
/		invokes a shell call, using either EXIT("cmd") or HOST(1,"cmd"),
/		execle() or the shell is invoked with fd 0 still attached to
/		the source file, and will read an end of file on first read.
/		This occurs because reading is outside the domain of
/		Spitbol, and SWCINP is not called.
/
/		Note that a call to INPUT prior to EXIT() or HOST(1,) would
/		mask the problem, because INPUT would switch us away from the
/		source file (assuming an EOF following END).  If there was
/		data following the END statement, things are even worse,
/		because the Shell will start reading data from the source file.
/
/   This problem only occurs on systems using dup().
/
/		To fix the problem, two new routines are used by EXIT("cmd")
/		and SHELL(1,"command") to bracket their operation.
/
/		save0() saves the current fd 0, and restores the original fd 0.
/		restore0() restores the saved fd 0.
/
/	01.09	Recoded so that after receiving EOF from standard input
/		and no more files on the command line, reconnect to stdin
/		if appropriate.  This permits the user to continue to invoke
/		INPUT after obtaining an EOF.  This behavior is consistant
/		with reads from TERMINAL, which will go to keyboard
/		regardless of results of previous read.
/
/		The usage of variables inpateof, no_more_input and proc_sh_fd0
/		is thereby eliminated, and system behavior is consistent
/		with other SNOBOL4 systems.
/
/		If file on command line cannot be opened, exit(1) after
/		issuing error message, rather than continuing.
/
/   For systems that do not support dup(), we leave
/		fd 0 open forever, and read command line files using a
/		non-zero fd.
/
/		Some code rearranged and cleaned up too.  The changes of
/		mod 01.08 are eliminated, having been recast in a
/		different manner.  MBE 12/24/87
/
/	01.08	After receiving EOF from standard input and no more files
/		on the command line, routine would exit with file descriptor
/		0 closed.  If the user subsequently issued a regular INPUT
/		function, osopen would obtain fd 0.  This was wrong in two
/		respects:
/		  1. osopen was testing for a successful open with fd > 0.
/		  2. a subsequent INPUT function specifying ' -f0' should
/		     attach to a file that returns a continuous EOF.
/
/		Solution: when exiting this routine without finding another
/		file for standard input, open "/dev/null" as fd 0.
/		MBE Nov. 9, 1987, per bug report from Kurt Gluck.
/
/	01.07	Every time a filename on the command line is accessed be
/		sure to increment 'cmdcnt' too.
*/

#include "port.h"

#include <fcntl.h>

/*
/   swcinp( filecnt, fileptr )
/
/   swcinp() handles the switching of input files whose concatenation
/   represents standard input.  After all input is exhausted a -1 is
/   returned to indicate EOF.
/
/   If no filenames were specified on the command line, all input is
/   read from file descriptor 0 provided by the shell.
/
/   If filenames were specified on the command line all files are read
/   in their order of appearance.  A filename consisting of a single hyphen
/   '-' represents file descriptor 0 provided by the shell.
/
/   Parameters:
/	filecnt	number of filename specified on command line
/	fileptr	array of pointers to character strings (filenames)
/   Returns:
/	File descriptor to read from (always 0!) or -1 if could not switch
/	to a new file.
*/

int	swcinp( filecnt, fileptr )

int	filecnt;
char	**fileptr;

{
    register char	*cp;
    register int i;

    static int lastfd = 0;


    /*
    /  If first time through, make a duplicate of
    /  shell's file descriptor 0, so that we can access it later.
    */
    sfn = "stdin";

    if ( originp < 0 )
        originp = dup( 0 );

    /*
    /  Process files on command line, if any.
    /  Read file descriptor 0 provided by the shell when a '-'
    /  is encountered as a filename.
    */
    if ( curfile < filecnt )
    {
        /*
        /  Point to next entry.  (Bump cmdcnt too!)
        */
        cmdcnt++;
        cp = fileptr[curfile++];

        /*
        /   Close fd 0 so subsequent open or dup will acquire fd 0.
        */
        close(0);
        clrbuf();
        /*
        /   If next entry is '-' then read file descriptor
        /   0 provided by the shell.
        */
        if ( *cp == '-' )
        {
            dup( originp );		// returns 0
            lastfd = 0;
            goto swci_exit;
        }

        /*
        /   Attempt to open file for reading.
        */
        sfn = cp;
        for ( i=0; ; i++ )
        {
            lastfd = -1;
            switch (i)
            {
            case 0:		// first pass, no alteration
                if ((lastfd = tryopen(cp)) >= 0 )
                    goto swci_exit;
                break;
#if !RUNTIME
            case 1:		// try with .spt extension
                if (!executing && appendext(cp, COMPEXTSPT, namebuf, 0))
                    if ((lastfd = tryopen(namebuf)) >= 0 )
                    {
                        sfn = namebuf;
                        goto swci_exit;
                    }
				// try with .sbl extension
                if (!executing && appendext(cp, COMPEXTSBL, namebuf, 0))
                    if ((lastfd = tryopen(namebuf)) >= 0 )
                    {
                        sfn = namebuf;
                        goto swci_exit;
                    }
                break;
#endif					// !RUNTIME

            case 2:		// try with .spx extension
                if (!executing && curfile == 1 && appendext(cp, RUNEXT, namebuf, 0))
                    if ((lastfd = tryopen(namebuf)) >= 0 )
                    {
                        sfn = namebuf;
                        goto swci_exit;
                    }
                break;
            case 3:
                /*
                /   Error opening file, so issue a message and exit
                */
                write( STDERRFD, "Can't open ", 11 );
                write( STDERRFD, cp, length(cp) );
                wrterr( "" );
                __exit(1);
            }
        }
    }
    else
        lastfd = -1;		// ATTEMPT TO FIX PIPE BUG FOR COPPEN 10-FEB-95

    sfn = "stdin";

    if ( readshell0 )
    {
        if (!executing && filecnt)
        {
            wrterr( "No END statement found in source file(s)." );   // V1.16
            __exit(1);
        }
        close(0);
        clrbuf();
        dup( originp );			// returns 0
        readshell0 = 0;			// only do this once
        lastfd = 0;
    }

    /*
    /  Control comes here after all files specified on the command line
    /  have been read.
    /
    /  FD 0 remains attached to the last file that returned an EOF, and
    /  should continue to return EOFs.
    */
swci_exit:
    return lastfd;
}




/*
/	Save the current fd 0, and connect fd 0 to the original one.
/	Used before EXIT("cmd") and HOST(1,"cmd")
/
*/
void save0()
{
    if ((save_fd0 = dup( 0 )) >= 0) {
        close( 0 );
        clrbuf();
        dup( originp );
    }
}





/*
/	Restore the saved fd 0.
/	Used after EXIT("cmd") and HOST(1,"cmd")
/
*/
void restore0()
{
    if (save_fd0 >= 0) {
        close( 0 );
        clrbuf();
        dup( save_fd0 );
        close( save_fd0 );	 	// 1.13 for HOST(1,"cmd")
    }
}




/*
/   tryopen - try to open file for swcinp.
/   returns -1 if fails, else file descriptor >= 0
*/
int tryopen(cp)
char *cp;
{
    int fd;
    if ( (fd = spit_open( cp, O_RDONLY, IO_PRIVATE | IO_DENY_WRITE,
                          IO_OPEN_IF_EXISTS )) >= 0 )
    {
        return fd;
    }
    return -1;
}





/*
/   pathlast()
/
/   Function pathlast returns the a pointer to the last component of a
/   path.
/
/   Parameters:
/	Pointer to path character string
/   Returns:
/	Pointer to last component in path character
*/


char *pathlast( path )

char	*path;

{
    char	*cp, c;
    int		len;

    /*
    /	Scan the path from right-to-left looking for a slash.  Stop when
    /	the front of the path is reached.
    */
    len = length(path);
    cp = path + len;

    /*
    /	Loop either terminated by finding a slash or hitting the front
    /	of the path.  If found a slash, the last component starts one
    /	position to the right.
    */
    while( len--)
    {
        c = *--cp;
        if (c == FSEP
           )
        {
            ++cp;
            break;
        }
    }
    return cp;
}

#if !(RUNTIME)
/*
 *  appendext - append extension to pathname if possible.
 *
 *	Parameters:
 *	   path	  - path name to append to.
 *	   ext    - extension to append
 *	   result - result buffer
 *	   force  - 1 for replace existing extension, if any, 0 to fail if
 *		    extension already present on path.
 * 	Returns:
 *	   >0  - Success, length of name
 *	   0   - Failure
 */
int appendext(path, ext, result, force)
char *path, *ext, *result;
int  force;
{
    register char *p, *q, *r;

    p = result;
    q = pathlast(path);
    r = (char *) 0;
    do {
        if (path >= q && *path == EXT)
            r = p;
    } while ((*p++ = *path++) != 0);

    p--;
    if ( r != (char *) 0)
    {
        if ( force )
            p = r;					// copy over old extension
        else
            return 0;				// no force but extension present
    }

    p = mystrcpy(p, ext);
    return p - result;
}
#endif          // !(RUNTIME)

/*
 * mystrcpy(p,q)  - copy string q to string p.  Return pointer to '\0' in p;
 *
 * Note that this definition is NOT the same as standard strcpy.
 */
char *mystrcpy(p, q)
register char *p, *q;
{
    while ( (*p++ = *q++) != 0 )
        ;
    return p - 1;
}


/*
/	Return length of string argument.
/	Identical to C strlen function.
*/
int length(cp)
char *cp;
{
    register char *p = cp;
    while (*p++)
        ;
    return p - cp - 1;
}


int mystrncpy( p, q, i)
register char *p, *q;
int i;
{
    register int j = i;
    while (j--)
        *p++ = *q++;
    return i;
}

