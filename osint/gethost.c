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
/   gethost( ccptr, maxlen )
/
/   gethost() reads the first line from the host file into the passed CCBLK.
/
/   Parameters:
/	ccptr	pointer to CCBLK to receive host string
/	maxlen	max length of string area in CCBLK
/   Returns:
/	Nothing.
/   Side Effects:
/	Modifies contents of passed CCBLK (ccptr).
*/

#include "port.h"

char htype[] = "x86";
char osver[] = ":Linux";

#include <fcntl.h>

void gethost( ccptr, maxlen )
struct	ccblk	*ccptr;
word	maxlen;

{
    struct ccblk *pHEADV = GET_DATA_OFFSET(HEADV,struct ccblk *);
    int cnt = 0;
    word fd;

    if ( (fd = spit_open( HOST_FILE, O_RDONLY, IO_PRIVATE | IO_DENY_WRITE,
                          IO_OPEN_IF_EXISTS )) >= 0 )
    {
        cnt	= read( fd, ccptr->str, maxlen );
        close( fd );
    }

    if ( cnt > 0  &&  ccptr->str[cnt-1] == EOL )
    {
        ccptr->str[--cnt] = 0;
    }

    if ( cnt == 0 )
    {
        // Could not read spithost file.  Construct string instead
        register char *scp;

        gettype( ccptr, maxlen );
        scp = ccptr->str + ccptr->len;
        scp = mystrcpy(scp,osver);
        scp = mystrcpy(scp,":Macro SPITBOL ");
        scp += mystrncpy(scp, pHEADV->str, pHEADV->len );
        scp += mystrncpy(scp, pID1->str, (int)pID1->len);
        *scp++ = ' ';
        *scp++ = ' ';
        cnt = scp - ccptr->str;
    }

    ccptr->len = cnt;
}



/*
 * Get type of host computer
 */
void gettype( ccptr, maxlen )

struct	ccblk	*ccptr;
word	maxlen;
{
    cpys2sc( htype, ccptr, maxlen );	// Computer type
}
