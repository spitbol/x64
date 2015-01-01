/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2013 David Shields

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
/   oswait( pid )
/
/   oswait() waits for the termination of the process with id pid.
/
/   Parameters:
/	pid	prcoess id
/   Returns:
/   nothing
/
/   V1.01 MBE 07-29-91  <withdrawn>.
/   V1.02 MBE 12-31-96  Modify for WinNT.
/
*/

#include "port.h"

#include <signal.h>

void oswait( pid )
int	pid;
{
    int	deadpid, status;
    struct  chfcb   *chptr;
    SigType (*hstat)(int),
            (*istat)(int),
            (*qstat)(int);

    istat	= signal( SIGINT, SIG_IGN );
    qstat	= signal( SIGQUIT ,SIG_IGN );
    hstat	= signal( SIGHUP, SIG_IGN );

    while ( (deadpid = wait( &status )) != pid  &&  deadpid != -1 )
    {
        for ( chptr = GET_MIN_VALUE(r_fcb,struct chfcb *); chptr != 0;
                chptr = ((struct chfcb *) (chptr->nxt)) )
        {
            if ( deadpid == ((struct ioblk *) (((struct fcblk *) (chptr->fcp))->iob))->pid )
            {
                ((struct ioblk *) (((struct fcblk *) (chptr->fcp))->iob))->flg2 |= IO_DED;
                break;
            }
        }
    }

    signal( SIGINT,istat );
    signal( SIGQUIT,qstat );
    signal( SIGHUP,hstat );
}
