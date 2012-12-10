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

/*
/	File:  GETHOST.C	Version:  01.05
/	---------------------------------------
/
/	Contents:	Function gethost
*/

/*
/   gethost( scptr, maxlen )
/
/   gethost() reads the first line from the host file into the passed SCBLK.
/
/   Parameters:
/	scptr	pointer to SCBLK to receive host string
/	maxlen	max length of string area in SCBLK
/   Returns:
/	Nothing.
/   Side Effects:
/	Modifies contents of passed SCBLK (scptr).
*/

#include "port.h"

char htype[] = "80386";
char osver[] = ":Linux ";

#include <fcntl.h>

void gethost( scptr, maxlen )
struct	scblk	*scptr;
word	maxlen;

{
    struct scblk *pHEADV = GET_DATA_OFFSET(HEADV,struct scblk *);
    int cnt = 0;
    word fd;

    if ( (fd = spit_open( HOST_FILE, O_RDONLY, IO_PRIVATE | IO_DENY_WRITE,
                          IO_OPEN_IF_EXISTS )) >= 0 )
    {
        cnt	= read( fd, scptr->str, maxlen );
        close( fd );
    }

#if EOL2
    if ( cnt > 0  &&  scptr->str[cnt-2] == EOL1 )
    {
        cnt--;
        scptr->str[--cnt] = 0;
    }
#else					/* EOL2 */
    if ( cnt > 0  &&  scptr->str[cnt-1] == EOL1 )
    {
        scptr->str[--cnt] = 0;
    }
#endif					/* EOL2 */

    if ( cnt == 0 )
    {
        /* Could not read spithost file.  Construct string instead */
        register char *scp;

        gettype( scptr, maxlen );
        scp = scptr->str + scptr->len;
        scp = mystrcpy(scp,osver);
        scp = mystrcpy(scp,":Macro SPITBOL ");
        scp += mystrncpy(scp, pHEADV->str, pHEADV->len );
        scp += mystrncpy(scp, pID1->str, (int)pID1->len);
        *scp++ = ' ';
        *scp++ = '#';
        cnt = scp - scptr->str;
    }

    scptr->len = cnt;
}



/*
 * Get type of host computer
 */
void gettype( scptr, maxlen )

struct	scblk	*scptr;
word	maxlen;
{
    cpys2sc( htype, scptr, maxlen );	/* Computer type */
}
