/*
/   File:  OSWAIT.C     Version:  01.02
/	---------------------------------------
/
/	Contents:	Function oswait
*/
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */

/*
/   oswait( pid )
/
/   oswait() waits for the termination of the process with id pid.
/
/   Parameters:
/	pid	prcoess id
/   Returns:
/   nothing
/
/   V1.01 MBE 07-29-91  <withdrawn>.
/   V1.02 MBE 12-31-96  Modify for WinNT.
/
*/

#include "port.h"
#if PIPES

#if UNIX
#include <signal.h>
#endif                  /* UNIX */

#if WINNT
#include <process.h>
#if _MSC_VER
extern int wait(int *status);
#endif
#endif

void oswait( pid )
int	pid;
{
    int	deadpid, status;
    struct  chfcb   *chptr;
#if UNIX
    SigType (*hstat)Params((int)),
            (*istat)Params((int)),
            (*qstat)Params((int));

    istat	= signal( SIGINT, SIG_IGN );
    qstat	= signal( SIGQUIT ,SIG_IGN );
    hstat	= signal( SIGHUP, SIG_IGN );
#endif

    while ( (deadpid = wait( &status )) != pid  &&  deadpid != -1 )
    {
        for ( chptr = GET_MIN_VALUE(R_FCB,struct chfcb *); chptr != 0;
                chptr = MK_MP(chptr->nxt, struct chfcb *) )
        {
            if ( deadpid == MK_MP(MK_MP(chptr->fcp, struct fcblk *)->iob,
                                  struct ioblk *)->pid )
            {
                MK_MP(MK_MP(chptr->fcp, struct fcblk *)->iob,
                      struct ioblk *)->flg2 |= IO_DED;
                break;
            }
        }
    }

#if UNIX
    signal( SIGINT,istat );
    signal( SIGQUIT,qstat );
    signal( SIGHUP,hstat );
#endif                  /* UNIX */
}
#endif					/* PIPES */
