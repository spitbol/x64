
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
#if defined(USE_SIGACTION)
    struct sigaction ignore = { .sa_handler = SIG_IGN };
    struct sigaction istat, qstat, hstat;
    sigaction(SIGINT, &ignore, &istat);
    sigaction(SIGQUIT, &ignore, &qstat);
    sigaction(SIGHUP, &ignore, &hstat);
#else
    void (*hstat)(int), (*istat)(int), (*qstat)(int);

    istat = signal(SIGINT, SIG_IGN);
    qstat = signal(SIGQUIT, SIG_IGN);
    hstat = signal(SIGHUP, SIG_IGN);
#endif
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

#if defined(USE_SIGACTION)
    sigaction(SIGINT, &istat, NULL);
    sigaction(SIGQUIT, &qstat, NULL);
    sigaction(SIGHUP, &hstat, NULL);
#else
    signal(SIGINT, istat);
    signal(SIGQUIT, qstat);
    signal(SIGHUP, hstat);
#endif
}
