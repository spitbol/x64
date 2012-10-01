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
        zysin - read input record

        zysin reads and returns the next input record from a file.

        Parameters:
            WA - pointer to FCBLK or 0
            XR - pointer to SCBLK containing buffer to receive record read
        Returns:
            Nothing
        Exits:
            1 - EOF or file not available after SYSXI
            2 - i/o error
            3 - record format error
*/

#include "port.h"
#include "os.h"

extern int inpcnt;
extern char **inpptr;

word
wabs(x)
word x;
{
    return (x >= 0) ? x : -x;
}

zysin()
{
    REGISTER word reclen;
    REGISTER struct fcblk *fcb = WA(struct fcblk *);
    REGISTER struct scblk *scb = XR(struct scblk *);
    REGISTER struct ioblk *ioptr = MK_MP(fcb->iob, struct ioblk *);

    Enter("zysin");
    /* ensure iob is open, fail if unsuccessful */
    if (!(ioptr->flg1 & IO_OPN)) {
        Exit("zysin");
	return EXI_3;
    }

    /* read the data, fail if unsuccessful */
    while ((reclen = osread(fcb->mode, fcb->rsz, ioptr, scb)) < 0) {
	if (reclen == (word) - 1) {	/* EOF?                 */
	    if (ioptr->fdn) {	/* If not fd 0, true EOF */
        	Exit("zysin");
		return EXI_1;
	    }
	    else /* Fd 0 - try to switch files */
	    if (swcinp(inpcnt, inpptr) < 0) {
        	Exit("zysin");
		return EXI_1;	/* If can't switch      */
            }

	    ioptr->flg2 &= ~IO_RAW;	/* Switched. Set IO_RAW */
	    if ((testty(ioptr->fdn) == 0) &&	/* If TTY */
		(fcb->mode == 0))	/* and raw mode,   */
		ioptr->flg2 |= IO_RAW;	/* then set IO_RAW */
	} else	{		/* I/O Error            */
	    Exit("zysin");
	    return EXI_2;
          }
    }
    scb->len = reclen;		/* set record length    */

    /* normal return */
    Exit("zysin");
    return EXI_0;
}
