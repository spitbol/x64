/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2015 David Shields

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

