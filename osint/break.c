
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields
*/

/*
/   startbrk( )
/
/   startbrk starts up the logic for trapping user keyboard interrupts.
*/

#include "port.h"
#include <signal.h>

void rearmbrk(void);
int brkpnd;

#if defined(USE_SIGACTION)
static void catchbrk(int sig, siginfo_t *info, void *context);
static struct sigaction istat, hstat, qstat;
static struct sigaction sighandler = { .sa_flags = SA_SIGINFO,
                                       .sa_sigaction = &catchbrk };

void
startbrk(void) /* start up break logic */
{

    brkpnd = 0;
    sigaction(SIGINT, &sighandler, &istat);
    sigaction(SIGHUP, &sighandler, &hstat);
    sigaction(SIGQUIT, &sighandler, &qstat);
}

void
endbrk(void) /* terminate break logic */
{
    /* Restore original handlers */
    sigaction(SIGINT, &istat, NULL);
    sigaction(SIGHUP, &hstat, NULL);
    sigaction(SIGQUIT, &qstat, NULL);
}

void
rearmbrk(void) /* rearm after a trap occurs */
{
    sigaction(SIGINT, &sighandler, NULL);
    sigaction(SIGHUP, &sighandler, NULL);
    sigaction(SIGQUIT, &sighandler, NULL);
}
/*
 *  catchbrk() - come here when a user interrupt occurs
 */
static void
catchbrk(int sig, siginfo_t *info, void *context)
{

    brkpnd++;
    stmct = GET_MIN_VALUE(stmct, word) - 1;
    stmcs = GET_MIN_VALUE(stmcs, word);
    SET_MIN_VALUE(stmct, 1, word);             /* force STMGO loop to check */
    SET_MIN_VALUE(stmcs, stmcs - stmct, word); /* counters quickly */
    SET_MIN_VALUE(polct, 1, word);             /* force quick SYSPL call */
}

#else
static void catchbrk(int sig);
static void (*cstat)(int signal);

void
startbrk(void) /* start up break logic */
{
    brkpnd = 0;
    cstat = signal(SIGINT, catchbrk); /* Catch ctrl-c */
}

void
endbrk(void) /* terminate break logic */
{
    signal(SIGINT, cstat);
}
void
rearmbrk(void) /* rearm after a trap occurs */
{
    signal(SIGINT, catchbrk);
}

/*
 *  catchbrk() - come here when a user interrupt occurs
 */
void
catchbrk(int sig)
{
    word stmct, stmcs;
    brkpnd++;
    stmct = GET_MIN_VALUE(stmct, word) - 1;
    stmcs = GET_MIN_VALUE(stmcs, word);
    SET_MIN_VALUE(stmct, 1, word);             /* force STMGO loop to check */
    SET_MIN_VALUE(stmcs, stmcs - stmct, word); /* counters quickly */
    SET_MIN_VALUE(polct, 1, word);             /* force quick SYSPL call */
}
#endif
