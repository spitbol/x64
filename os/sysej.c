/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012 David Shields

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


/*
        zysej - end job

        zysej is called to terminate spitbol's execution.  Any open files
        will be closed before calling exit.

        Parameters:
            WA - value of &ABEND keyword (always 0)
            WB - value of &CODE keyword
            XL - pointer to FCBLK chain
        Returns:
            NO RETURN
*/

#include "port.h"
#include "os.h"

extern word in_gbcol;

#if EXTFUN
unsigned char *bufp;
#endif				/* EXTFUN */


/*
   close_all - Close all files.

   Parameters:
        chfcb   pointer to FCBLK chain or 0
   Returns:
        Nothing
   Side Effects:
        All files on the chain are closed and buffers flushed.
*/

void
close_all(chb)
REGISTER struct chfcb *chb;
{
    Enter("closeall");
    while (chb != 0) {
	osclose(MK_MP
		(MK_MP(chb->fcp, struct fcblk *)->iob, struct ioblk *));
	chb = MK_MP(chb->nxt, struct chfcb *);
    }
    Exit("closeall");
}



void
zysej()
{
#if HOST386
    termhost();
#endif				/* HOST386 */

    Enter("zysej");
    if (!in_gbcol) {		/* Only if not mid-garbage collection */
	close_all(XL(struct chfcb *));

#if EXTFUN
	scanef();		/* prepare to scan for external functions */
	while (nextef(&bufp, 1))	/* perform closing callback to some               */
	    ;
#endif				/* EXTFUN */

    }
    Exit("zysej");
    exit(WB(int));

}
