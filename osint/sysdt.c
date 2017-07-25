/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields
*/

/*
/*
/	zysdt - get current date
/
/	zysdt is called when executing a Spitbol date function.
/
/	Parameters:
/       XR - optional integer argument describing date format desired
/	Returns:
/	    XL - pointer to SCBLK containing date string
/	Exits:
/	    None
*/

#include "port.h"
#include <time.h>

static int datecvt ( char *cp, int type );
static int timeconv ( char *tp, struct tm *tm );

// conv() rewritten to avoid dependence on library remainder routine
void conv (dest, value)

register char *dest;
register int value;

{
    register short int i;
    i = value / 10;
    dest[0] = i + '0';
    dest[1] = value - i*10 + '0';
}

zysdt()
{
    struct icblk *dtscb = XR (struct icblk *);

    ptscblk->len = datecvt( ptscblk->str, dtscb->val );
    SET_XL( ptscblk );
    return NORMAL_RETURN;
}

/*
 * Write date/time in SPITBOL form to a string
 */
int storedate( cp, maxlen )
char	*cp;
word	maxlen;
{
    if (maxlen < 18)
        return 0;

    return datecvt(cp, 0);
}

/*
 * Write date/time in several different forms to a string
 */
int datecvt( cp, type )
char	*cp;
int     type;
{

    time_t      tod;

    register struct tm *tm;
    tm = localtime( &tod );

    switch (type)
    {
    default:
    case 0:     // "MM/DD/YY hh:mm:ss"
        conv( cp, tm->tm_mon+1 );
        cp[2] = '/';
        conv( cp+3, tm->tm_mday );
        cp[5] = '/';
        conv( cp+6, tm->tm_year % 100 );    // Prepare for year 2000!
        return 8 + timeconv(&cp[8], tm);

    case 1:     // "MM/DD/YYYY hh:mm:ss"
        conv( cp, tm->tm_mon+1 );
        cp[2] = '/';
        conv( cp+3, tm->tm_mday );
        cp[5] = '/';
        conv( cp+6, (tm->tm_year + 1900) / 100 );
        conv( cp+8, tm->tm_year % 100 );    // Prepare for year 2000!
        return 10 + timeconv(&cp[10], tm);

    case 2:     // "YYYY-MM-DD/YYYY hh:mm:ss"
        conv( cp+0, (tm->tm_year + 1900) / 100 );
        conv( cp+2, tm->tm_year % 100 );    // Prepare for year 2000!
        cp[4] = '-';
        conv( cp+5, tm->tm_mon+1 );
        cp[7] = '-';
        conv( cp+8, tm->tm_mday );
        return 10 + timeconv(&cp[10], tm);
    }
}

static int timeconv( tp, tm)
char *tp;
struct tm *tm;
{
    tp[0] = ' ';
    conv( tp+1, tm->tm_hour );
    tp[3] = ':';
    conv( tp+4, tm->tm_min );
    tp[6] = ':';
    conv( tp+7, tm->tm_sec );
    *(tp+9) = '\0';
    return 9;
}

