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
/   File:  OSPIPE.C     Version:  01.06
/       ---------------------------------------
/
/       Contents:       Function ospipe
/
/ 1.02  Use vfork() on BSD systems to avoid copying pages.  Parent is suspended
/       by system until child execl's.
/
/ 1.03  Look at flag IO_ENV, and if set, fnm string is the name
/       of an environment variable pointing to the filename.
/
/ 1.04  Check for update mode on file.
/
/ 1.05  <withdrawn>
/
/ 1.06  30-Dec-96 Create version of WinNT.  Save and restore characters
/       at end of string in doshell().  Fix bug in Unix version:
/       If child fork does not run to the point where it does the execcl call
/       before the parent resumes, the parent could do a garbage collect and
/       invalidate the string pointer that the child will use.  Use a poor
/       man's interlock to keep the parent within ospipe until the child
/       has captured what is needed.
/
/ 1.07  19-Feb-98 Interlock is not necessary under AIX because we use fork,
/       not vfork.  vfork shares the parent's address space, whereas fork
/       gives the child a complete new copy of the address space.
*/

#include "port.h"
#if PIPES
typedef int HFILE;

#if WINNT
#include <process.h>
extern int  dup2(File_handle from, int to);
extern int  pipe(File_handle fd[2]);
#define privatize(F) make_private(&(F));
extern void make_private(File_handle *f);
extern int spawnl(int mode, char *path, char *arg0, ...);
#define EXEC_ASYNC P_NOWAIT         /* must match definition in syswinnt */
#endif

char    *getshell();
char    *lastpath();

static int doshell Params((struct ioblk *ioptr));
#if SOLARIS
static int interlock;
#endif

#if WINNT
HFILE childfd, stdfd;           /* kludge to get info to syswinnt.c */
#endif
/*
/   ospipe( ioptr )
/
/   ospipe() builds a pipe for the command associated with the passed IOBLK.
/
/   Parameters:
/       ioptr   pointer to IOBLK for command
/   Returns:
/       file descriptor returned by pipe system call, -1 if error
*/

int ospipe( ioptr )
struct  ioblk   *ioptr;

{
    int   childpid;
#if WINNT
    HFILE parentfd, savefd, fd[2];
#else
    HFILE childfd, parentfd, savefd, stdfd, fd[2];
#endif

    if ( (ioptr->flg1 & (IO_INP | IO_OUP)) == (IO_INP | IO_OUP) )
        return -1;              /* can't open read/write pipe */
    /*
    /   Fail if system call to create pipe fails.
    */
    if ( pipe( fd ) < 0 )
        return -1;

    /*
    /   Set up file descriptors properly based on whose reading from pipe/
    /   writing to pipe.
    */
    if ( ioptr->flg1 & IO_INP ) {
        parentfd = fd[0];       /* parent reads from fd[0]      */
        childfd  = fd[1];       /* child writes to fd[1]        */
        stdfd = 1;
    }
    else {
        parentfd = fd[1];       /* parent writes to fd[1]       */
        childfd  = fd[0];       /* child reads from fd[0]       */
        stdfd = 0;
    }

#if UNIX
    /*
    /   Execute the proper code based on whose process is the parent and
    /   whose is the child.
    */
#if SOLARIS
    interlock = 0;
    switch ( childpid = vfork() ) {
#else
    switch ( childpid = fork() ) {
#endif
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
        __exit(1);                      /* Should never get here! */

    default:
        /*
        /   Parent executes here.  Remember process id of child and close
        /   its file descriptor.
        */
        ioptr->pid = childpid;
        close( childfd );
#if SOLARIS
        /* Need to wait here until child says that is has copied data */
        while (!interlock)
            usleep(100);                       /* Yield to other tasks */
#endif
        break;
    }
#endif                                  /* UNIX */

#if WINNT
    savefd = dup(stdfd);                        /* prepare to set up child's stdout */
    if (savefd == -1) {
        close( parentfd );
        close( childfd );
        parentfd = -1;
    }
    else {
        dup2(childfd, stdfd);           /* close stdfd, make it same a childfd */
        privatize(parentfd);            /* don't let child inherit this fd */
        childpid = doshell(ioptr);
        close(childfd);
        dup2(savefd,stdfd);                     /* bring back our standard file */
        if (childpid == -1) {
            close(parentfd);
            parentfd = -1;
        }
        else
            ioptr->pid = childpid;
    }
#endif                  /* WINNT */
    /*
    /   Control comes here ONLY in parent process. Return the file descriptor
    /   to be used for communication with child process or -1 if error.
    */
    return parentfd;
}


static int doshell( ioptr )
struct  ioblk   *ioptr;
{
#define CMDBUFLEN 1024
    struct      scblk   *scptr;
    char    *shellpath, cmdbuf[CMDBUFLEN];
    int     len;

    /*
    /   Set up to execute command.
    /
    /   Be sure to point properly at start of command and to
    /   terminate it with a Nul character.  Remember that
    /   command is in string with form "!*command* options".
    */
    scptr = MK_MP(ioptr->fnm,struct scblk *);   /* point to cmd scblk   */
    if (ioptr->flg2 & IO_ENV) {
        if (optfile(scptr, pTSCBLK))
            return -1;
        scptr = pTSCBLK;
        pTSCBLK->len = lenfnm(scptr);   /* remove any options   */
    }
    len   = lenfnm( scptr ) - 2;        /* length of cmd without ! & delimiter */
    if (len >= CMDBUFLEN)
        return -1;
    mystrncpy( cmdbuf, &scptr->str[2], len);/* get command */
    if ( cmdbuf[len-1] == scptr->str[1] )   /* if necessary         */
        len--;                              /*   zap 2nd delimiter  */
    cmdbuf[len] = '\0';                     /* Nul terminate cmd    */
#if WINNT
    shellpath = getshell();         /* get shell's path     */
    return spawnl(EXEC_ASYNC, shellpath, pathlast(shellpath), "/c", cmdbuf);
#endif                  /* WINNT */
#if UNIX
    shellpath = getshell();         /* get shell's path     */
#if SOLARIS
    interlock = 1;                  /* release parent */
#endif
    execl( shellpath, pathlast( shellpath ), "-c", cmdbuf, (char *)NULL );
    return -1;                                  /* should not get here */
#endif                                  /* UNIX */
}

#endif                                  /* PIPES */
