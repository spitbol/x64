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

/* startbrk starts up the logic for trapping user keyboard interrupts. */

#include "port.h"

#if POLLING
int brkpnd;

#include <signal.h>
#undef SigType
#define SigType void

static
SigType (*cstat) (int);
     void catchbrk (int sig);
     void rearmbrk (void);

     void startbrk ()		/* start up break logic */
{
  brkpnd = 0;
  cstat = signal (SIGINT, catchbrk);	/* set to catch control-C */
}



void
endbrk ()			/* terminate break logic */
{
  signal (SIGINT, cstat);	/* restore original trap value */
}


/*
 *  catchbrk() - come here when a user interrupt occurs
 */
SigType
catchbrk (sig)
     int sig;
{
  word stmctv, stmcsv;
  brkpnd++;
  stmctv = get_min_value (STMCT, word) - 1;
  stmcsv = get_min_value (STMCS, word);
  set_min_value (STMCT, 1, word);	/* force STMGO loop to check */
  set_min_value (STMCS, stmcsv - stmctv, word);	/* counters quickly */
  set_min_value (POLCT, 1, word);	/* force quick SYSPL call */
}


void
rearmbrk ()			/* rearm after a trap occurs */
{
  signal (SIGINT, catchbrk);	/* set to catch traps */
}
#endif /* POLLING */
