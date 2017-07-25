/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields

/*
/   startbrk( )
/
/   startbrk starts up the logic for trapping user keyboard interrupts.
*/

#include "port.h"

int	brkpnd;

#include <signal.h>
#undef SigType
#define SigType void

static SigType (*cstat)(int);
void catchbrk (int sig);
void rearmbrk (void);

void startbrk()							// start up break logic
{
    brkpnd = 0;
    cstat = signal(SIGINT,catchbrk);	// set to catch control-C
}



void endbrk()							// terminate break logic
{
    signal(SIGINT, cstat);				// restore original trap value
}


/*
 *  catchbrk() - come here when a user interrupt occurs
 */
SigType catchbrk(sig)
int sig;
{
    word    stmct, stmcs;
    brkpnd++;
    stmct = GET_MIN_VALUE(stmct,word) - 1;
    stmcs = GET_MIN_VALUE(stmcs,word);
    SET_MIN_VALUE(stmct,1,word);                // force STMGO loop to check
    SET_MIN_VALUE(stmcs,stmcs - stmct,word);    // counters quickly
    SET_MIN_VALUE(polct,1,word);				// force quick SYSPL call
}


void rearmbrk()							// rearm after a trap occurs
{
    signal(SIGINT,catchbrk);			// set to catch traps
}

