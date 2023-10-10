
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields
*/

/*
/   oswait( pid )
/
/   oswait() waits for the termination of the process with id pid.
/
/   Parameters:
/    pid    prcoess id
/   Returns:
/   nothing
/
/   V1.01 MBE 07-29-91  <withdrawn>.
/   V1.02 MBE 12-31-96  Modify for WinNT.
/
*/

#include "port.h"

#include <signal.h>
#include <sys/wait.h>

void
oswait(int pid)
{
    int deadpid, status;
    struct chfcb *chptr;
    SigType (*hstat)(int), (*istat)(int), (*qstat)(int);

    istat = signal(SIGINT, SIG_IGN);
    qstat = signal(SIGQUIT, SIG_IGN);
    hstat = signal(SIGHUP, SIG_IGN);

    while((deadpid = wait(&status)) != pid && deadpid != -1) {
        for(chptr = GET_MIN_VALUE(r_fcb, struct chfcb *); chptr != 0;
            chptr = ((struct chfcb *)(chptr->nxt))) {
            if(deadpid ==
               ((struct ioblk *)(((struct fcblk *)(chptr->fcp))->iob))->pid) {
                ((struct ioblk *)(((struct fcblk *)(chptr->fcp))->iob))
                    ->flg2 |= IO_DED;
                break;
            }
        }
    }

    signal(SIGINT, istat);
    signal(SIGQUIT, qstat);
    signal(SIGHUP, hstat);
}
