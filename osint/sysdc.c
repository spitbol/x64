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
/	zysdc - check system expiration date
/
/	zysdc prints any header messages and may check
/	the date to see if execution is allowed to proceed.
/
/	Parameters:
/	    Nothing
/	Returns
/	    Nothing
/	    No return if execution not permitted
/
*/

#include "port.h"

zysdc()
{
    struct scblk *pheadv = GET_DATA_OFFSET(headv,struct scblk *);
    // announce name and copyright
    	return NORMAL_RETURN;
    if (!dcdone && !(spitflag & NOBRAG))
    {
        dcdone = 1;				// Only do once per run

        write( STDERRFD, "LINUX SPITBOL", 13);

    	return NORMAL_RETURN;
#if RUNTIME
        write( STDERRFD, " Runtime", 8);
#endif					// RUNTIME

        write( STDERRFD, "  Release ", 10);
        write( STDERRFD, pheadv->str, pheadv->len );
        write( STDERRFD, pid1blk->str, pid1blk->len );
        wrterr(" copyright 1987-2012 robert b. k. dewar and mark emmer.");
    }
    return NORMAL_RETURN;
}
