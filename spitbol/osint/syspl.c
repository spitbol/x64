/*
/	File:  SYSPL.C		Version:  01.01
/	---------------------------------------
/
/	zyspl - interface polling from SPITBOL
/
/	zyspl is called before statement execution to allow the interface
/         to regain control if desired.
/	Parameters:
/	    WA - reason for call
/		     =0  periodic polling
/		     =1  breakpoint hit
/		     =2  completion of statement stepping
/     WB - current statement number
/           XL - SCBLK of result if WA = 3.
/	Normal Return
/	    WA - number of statements to elapse before calling SYSPL again.
/	Exits:
/	    1 - set breakpoint
/	    2 - single step
/	    3 - evaluate expression
/       normal exit - no special action
/
/  Version history:
/
/
*/
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */

#include "port.h"

#if POLLING & (UNIX | WINNT)
#if WINNT
int	pollevent Params((void));
#endif
#if UNIX
#define pollevent()
#endif          /* UNIX */
extern  rearmbrk Params((void));
extern	int	brkpnd;
#define stmtDelay PollCount
#endif


zyspl()
{
#if POLLING

    /* Make simple polling case the fastest by avoiding switch statement */
    if (WA(word) == 0) {
#if !ENGINE
        pollevent();
#endif					/* !ENGINE */
        SET_WA(stmtDelay);	/* Poll finished or Continue */
#if !ENGINE & (WINNT | UNIX)
        if (brkpnd) {
            brkpnd = 0;		/* User interrupt */
            rearmbrk();		/* allow breaks again */
            return EXIT_1;
        }
#endif
    }
#else					/* POLLING */
    SET_WA((word)MAXPOSWORD);			/* Effectively shut off polling */
#endif					/* POLLING */
    return NORMAL_RETURN;
}

