/*
/	File:  BREAK.C		Version:  01.00
/	---------------------------------------
/
/	Contents:	Function endbrk
/				Function startbrk
/			    Function rearmbrk
/
/	v1.00	02-Mar-91	Initial version for Unix.
/	V1.01	16-May-91	Initial version for MS-DOS using Intel compiler.
*/
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */

/*
/   startbrk( )
/
/   startbrk starts up the logic for trapping user keyboard interrupts.
*/

#include "port.h"

#if POLLING
int	brkpnd;

#if UNIX | WINNT
#include <signal.h>
#undef SigType
#define SigType void

static SigType (*cstat)Params((int));
#if WINNT
static SigType (*bstat)Params((int));
#endif
void catchbrk Params((int sig));
void rearmbrk Params((void));

void startbrk()							/* start up break logic */
{
	brkpnd = 0;
	cstat = signal(SIGINT,catchbrk);	/* set to catch control-C */
#if WINNT
	bstat = signal(SIGBREAK,catchbrk);	/* set to catch control-BREAK */
#endif
}



void endbrk()							/* terminate break logic */
{
	signal(SIGINT, cstat);				/* restore original trap value */
#if WINNT
	signal(SIGBREAK, bstat);
#endif
}


/*
 *  catchbrk() - come here when a user interrupt occurs
 */
SigType catchbrk(sig)
int sig;
{
    word    stmct, stmcs;
	brkpnd++;
    stmct = GET_MIN_VALUE(STMCT,word) - 1;
    stmcs = GET_MIN_VALUE(STMCS,word);
    SET_MIN_VALUE(STMCT,1,word);                /* force STMGO loop to check */
    SET_MIN_VALUE(STMCS,stmcs - stmct,word);    /* counters quickly */
	SET_MIN_VALUE(POLCT,1,word);				/* force quick SYSPL call */
}


void rearmbrk()							/* rearm after a trap occurs */
{
	signal(SIGINT,catchbrk);			/* set to catch traps */
#if WINNT
	signal(SIGBREAK,catchbrk);
#endif
}
#endif
#endif					/* POLLING */

