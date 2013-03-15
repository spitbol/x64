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
/   arg2scb( req, argc, argv, ccptr, maxs )
/
/   arg2scb() makes a copy of the req-th argument in the argv array.
/   The copy is appended to the string in the CCBLK provided.
/
/   Parameters:
/	req	number of argument to copy
/	argc	number of arguments
/	argv	pointer to array of pointers to strings (arguments)
/	ccptr	pointer to SCBLK to receive copy of argument
/	maxs	maximum number of characters to append.
/   Returns:
/	Length of argument copied or -1 if req is out of range.
/   Side Effects:
/	Modifies contents of passed CCBLK (ccptr).
/	CCBLK length field is incremented.
*/

#include "port.h"

void set_xl() {
	
// set XL to string, performing unicode translation if needed.
        if (CHARBITS == 8) {
	        SET_XL( pTCCBLK );
	}
	else {
		uc_decode(0, pTCCBLK);	// assume translation cannot fail
		SET_XL( uc_scblk(0));
	}
}

static int
arg2scb( req, argc, argv, ccptr, maxs )

int	req;
int	argc;
char	*argv[];
struct	ccblk	*ccptr;
int	maxs;

{
    register word	i;
    register char	*argcp, *ccbcp;

    if ( req < 0  ||  req >= argc )
        return	-1;

    argcp	= argv[req];
    ccbcp	= ccptr->str + ccptr->len;
    for( i = 0 ; i < maxs  &&  ((*ccbcp++ = *argcp++) != 0) ; i++ )
        ;
    ccptr->len += i;
    return i;
}

/*
/	zyshs - host specific functions
/
/	zyshs is the catch-all function in the interface.  Any actions that
/	are host specific should be placed here.
/
/	zyshs determines what function to preformed by examining the value
/	of argument 1.  Current functions:
/
/	HOST()
/		returns the host string identifying the host environment
/
/	HOST( 0 )
/		returns -u argument from command line
/
/	HOST( 1, "command" )
/		executes 2nd argument as a Unix command
/
/	HOST( 2, n )
/		returns command line argument "n"
/
/	HOST( 3 )
/		returns the command count
/
/	HOST( 4, "v" )
/		returns the value of environment variable "v"
/
/	Other HOST functions may be provided by system specific modules.
/
/	Parameters:
/	    WA - argument 1
/	    XL - argument 2
/	    XR - argument 3
/	    WB - argument 4
/	    WC - argument 5
/	Returns:
/	    See exits
/	Exits:
/	    1 - erroneous argument
/	    2 - execution error
/	    3 - pointer to SCBLK or 0 in XL
/	    4 - return NULL string
/	    5 - return result in XR
/	    6 - cause statement failure
/	    7 - return string in XL, length in WA (may be 0)
/	    8 - return copy of result in XR
*/

/*
 *  checkstr - check if ccblk is a valid string.  Returns 1 if so, else 0.
 */
int
checkstr(scp)
struct ccblk *scp;
{
    return scp != (struct ccblk *)0L &&
           scp->typ == TYPE_SCL && scp->len < TCCBLK_LENGTH;
}

/*  check2str - check first two argument strings in XL, XR.
 *
 * Returns 1 if both OK, else 0.
 */
int
check2str()
{
    return checkstr( XL(struct ccblk *) ) && checkstr( XR(struct ccblk *) );
}


/*
 *  savestr - convert an ccblk to a valid C string.  Returns pointer to
 *		start of string, or 0 if fail.  The char replaced by the
 *		'\0' terminator is returned in *cp.
 */
char *
savestr(scp,cp)
struct ccblk *scp;
char *cp;
{
    *cp = scp->str[scp->len];
    scp->str[scp->len] = '\0';
    return scp->str;
}

/*
 *  save2str - convert first two argument strings in XL, XR.
 */
void
save2str(s1p,s2p)
char **s1p, **s2p;
{
    *s1p = savestr( XL(struct ccblk *), &savexl );
    *s2p = savestr( XR(struct ccblk *), &savexr );
}

/*
 *  getstring - verify and convert an ccblk to a valid C string.
 *   Returns pointer to start of string, or 0 if fail.  The char
 *   replaced by the '\0' terminator is returned in *cp.
 */
char *
getstring(scp,cp)
struct ccblk *scp;
char *cp;
{
    return checkstr(scp) ? savestr(scp,cp) : (char *)0L;
}


/*
 *  restorestring - restore an ccblk after a getstring call.
 *
 *  when making multiple getstring calls, call restorestring in the reverse
 *  order from getstring, in case two arguments point to the same source string.
 */
void restorestring(scp,c)
struct ccblk *scp;
word c;
{
    if (scp)
        scp->str[scp->len] = c;
}


/*
 *  restore2str - restore two argument strings in XL, XR.
 */
void
restore2str()
{
    restorestring( XR(struct ccblk *), savexr);
    restorestring( XL(struct ccblk *), savexl);
}

/*
 *  getint - fetch an integer from either an icblk, rcblk or non-null ccblk.
 *
 *  returns 1 if successful, 0 if failed.
 */
int
getint(icp,pword)
struct icblk *icp;
IATYPE *pword;
{
    register char *p, c;
    struct ccblk *scp;
    word i;
    IATYPE result;
    int sign;

    sign = 1;
    if ( icp->typ == TYPE_ICL)
        result = icp->val;
#ifdef REAL_ARITH
    else if (icp->typ == TYPE_RCL)
    {
#if sparc
        union {
            mword  rcvals[2];
            double rcval;
        } val;
        val.rcvals[0] = ((struct rcblk *)icp)->rcvals[0];
        val.rcvals[1] = ((struct rcblk *)icp)->rcvals[1];
        result = (IATYPE)val.rcval;
#else
        result = (IATYPE)(((struct rcblk *)icp)->rcval);
#endif
    }
#endif
    else {
        scp = (struct ccblk *)icp;
        if (!checkstr(scp))
            return 0;
        i = scp->len;
        p = scp->str;
        result = (IATYPE)0;
        while (i && *p == ' ') {		// remove leading blanks
            p++;
            i--;
        }
        if (i && (*p == '+' || *p == '-')) {	// process optional sign char
            if (*p++ == '-')
                sign = -1;
            i--;
        }
        while (i--) {
            c = *p++;
            if ( c < '0' || c > '9' ) {	// not handling trailing blanks
                return 0;
            }
            result = result * 10 + (c - '0');
        }
    }
    *pword = sign * result;
    return 1;
}

int
zyshs()
{
    word	retval;
    IATYPE	val;
    register struct icblk *icp = WA (struct icblk *);
    register struct ccblk *scp;

    /*
    /   if argument one is null...
    */
    scp = WA (struct ccblk *);
    if (scp->typ == TYPE_SCL && !scp->len)
    {
        gethost( pTCCBLK, TCCBLK_LENGTH );
        if ( pTCCBLK->len == 0 )
            return EXIT_4;
	set_xl();
        return EXIT_3;
    }

    /*
    /   If argument one is an integer ...
    */
    if ( getint(icp,&val) ) {
        switch( (int)val ) {
            /*
            / HOST( -1, n ) returns internal parameter n
            */
        case -1:
            icp = XL( struct icblk * );
            if ( getint(icp,&val) ) {
                pTICBLK->typ = TYPE_ICL;
                SET_XR( pTICBLK );
                switch ( (int)val ) {
                case 0:
                    pTICBLK->val = memincb;
                    return EXIT_8;
                case 1:
                    pTICBLK->val = databts;
                    return EXIT_8;
                case 2:
                    pTICBLK->val = (IATYPE)basemem;
                    return EXIT_8;
                case 3:
                    pTICBLK->val = (IATYPE)topmem;
                    return EXIT_8;
                case 4:
                    pTICBLK->val = stacksiz - 400;	// safety margin
                    return EXIT_8;
                case 5:							// stack in use
                    pTICBLK->val = stacksiz - (XS(IATYPE) - (IATYPE)lowsp);
                    return EXIT_8;
                case 6:
                    pTICBLK->val = sizeof(IATYPE);
                    return EXIT_8;
                default:
                    return EXIT_1;
                }
            }
            else
                return EXIT_1;

            /*
            /  HOST( 0 ) returns the -u command line option argument
            */
        case 0:
            if ( uarg ) {
                cpys2sc( uarg, pTCCBLK, TCCBLK_LENGTH );
		set_xl();
                return EXIT_3;
            }
            else if ((val = cmdcnt) != 0) {
                pTCCBLK->len = 0;
                while (pTCCBLK->len < TCCBLK_LENGTH - 2 &&
                        arg2scb( (int) val++, gblargc, gblargv,
                                 pTCCBLK, TCCBLK_LENGTH - pTCCBLK->len ) > 0)
                    pTCCBLK->str[pTCCBLK->len++] = ' ';
                if (pTCCBLK->len)
                    --pTCCBLK->len;
		set_xl();
                return EXIT_3;
            }
            else
                return EXIT_4;
            /*
            / HOST( 1, "command", "path" ) executes "command" using "path"
            */
        case 1: {
            char *cmd, *path;
	    if (CHARBITS == 8) {

            	if (!check2str())
                    return EXIT_1;
            	save2str(&cmd,&path);
            	save0();		// made sure fd 0 OK
            	pTICBLK->val = dosys( cmd, path );

            	pTICBLK->typ = TYPE_ICL;
            	restore2str();
            }
	    else {
		uc_encode(0, XL(struct scblk *));
		cmd = uc_ccblk(0)->str;
		uc_encode(1, XR(struct scblk *));
		path = uc_ccblk(1)->str;
		save0();
		pTICBLK->val = dosys(cmd,path);
            	pTICBLK->typ = TYPE_ICL;
	    }
	    restore0();
            if (pTICBLK->val < 0)
                return EXIT_6;
            SET_XR( pTICBLK );
            return EXIT_8;
        }

        /*
        / HOST( 2, n ) returns command line argument n
        */
        case 2:
            icp = XL( struct icblk * );
            if ( getint(icp,&val) ) {
                pTCCBLK->len = 0;
                retval = arg2scb( (int) val, gblargc, gblargv, pTCCBLK, TCCBLK_LENGTH );
                if ( retval < 0 )
                    return EXIT_6;
                if ( retval == 0 )
                    return EXIT_1;
                set_xl();
                return EXIT_3;
            }
            else
                return EXIT_1;

            /*
            /  HOST( 3 ) returns the command count
            */
        case 3:
            if ( cmdcnt ) {
                pTICBLK->typ = TYPE_ICL;
                pTICBLK->val = cmdcnt;
                SET_XR( pTICBLK );
                return EXIT_8;
            }
            else
                return EXIT_6;

            /*
            / HOST( 4, "env-var" ) returns the value of "env-var" from
            /	    the environment.
            */
        case 4:
	    scp = XL( struct ccblk *);
            if ( scp->typ == TYPE_SCL ) {
                if ( scp->len == 0 )
                    return EXIT_1;

	    	if (CHARBITS == 8) {
                    scp = XL( struct ccblk * );
	   	}
	    	else {
		    uc_encode(0, XL(struct scblk *)); // assume unicode translation cannot fail
		    scp = uc_ccblk(0);
	    	}
                if ( rdenv( scp, pTCCBLK ) < 0 )
                    return EXIT_6;
		set_xl();
                return EXIT_3;
            }
            else
                return EXIT_1;
        }       // end switch

        /*
        / Any other integer value is processed by the system-specific functions
        */

        /*
        /   Here if first argument wasn't an integer or was an illegal value.
        */
    }
    return EXIT_1;
}
