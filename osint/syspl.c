/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields
*/

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
*/

#include "port.h"

#define pollevent()
extern  int rearmbrk (void);
extern	int brkpnd;
#define stmtDelay PollCount


int zyspl()
{
    // Make simple polling case the fastest by avoiding switch statement
    if (WA(word) == 0) {
#if !ENGINE
        pollevent();
#endif					// !ENGINE
        SET_WA(stmtDelay);	// Poll finished or Continue
#if !ENGINE
        if (brkpnd) {
            brkpnd = 0;		// User interrupt
            rearmbrk();		// allow breaks again
            return EXIT_1;
        }
#endif
    }
    return NORMAL_RETURN;
}

