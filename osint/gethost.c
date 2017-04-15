/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2013 David Shields
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

char htype[] = "x86-64";
char osver[] = ":unix ";

#include <fcntl.h>

void gethost( scptr, maxlen )
struct	scblk	*scptr;
word	maxlen;

{
    struct scblk *pheadv = GET_DATA_OFFSET(headv,struct scblk *);
    int cnt = 0;
    word fd;

    if ( (fd = spit_open( HOST_FILE, O_RDONLY, IO_PRIVATE | IO_DENY_WRITE,
                          IO_OPEN_IF_EXISTS )) >= 0 )
    {
        cnt	= read( fd, scptr->str, maxlen );
        close( fd );
    }

    if ( cnt > 0  &&  scptr->str[cnt-1] == EOL )
    {
        scptr->str[--cnt] = 0;
    }

    if ( cnt == 0 )
    {
        // Could not read spithost file.  Construct string instead
        register char *scp;

        gettype( scptr, maxlen );
        scp = scptr->str + scptr->len;
        scp = mystrcpy(scp,osver);
        scp = mystrcpy(scp,":Macro SPITBOL ");
        scp += mystrncpy(scp, pheadv->str, pheadv->len );
        scp += mystrncpy(scp, pid1blk->str, (int)pid1blk->len);
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
    cpys2sc( htype, scptr, maxlen );	// Computer type
}
