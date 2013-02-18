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
/   arg2scb( req, scptr, maxs )
/
/   arg2scb() makes a copy of the req-th argument in the argv array.
/   The copy is appended to the string in the SCBLK provided.
/
/   Parameters:
/	req	number of argument to copy
/	scptr	pointer to SCBLK to receive copy of argument
/	maxs	maximum number of characters to append.
/   Returns:
/	Length of argument copied or -1 if req is out of range.
/   Side Effects:
/	Modifies contents of passed SCBLK (scptr).
/	SCBLK length field is incremented.
*/

#include "port.h"

static int 
arg2scb( req, scptr, maxs )

int	req;
struct	scblk	*scptr;
int	maxs;

{
    register word	i;
    register char	*argcp, *scbcp;

    if ( req < 0  ||  req >= gblargc )
        return	-1;

    argcp	= gblargv[req];
    scbcp	= scptr->str + scptr->len;
    for( i = 0 ; i < maxs  &&  ((*scbcp++ = *argcp++) != 0) ; i++ )
        ;
    scptr->len += i;
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
 *  getint - fetch an integer from either an icblk, rcblk or non-null scblk.
 *
 *  returns 1 if successful, 0 if failed.
 */
int
getint(icp,pword)
struct icblk *icp;
IATYPE *pword;
{
    register char *p, c;
    struct scblk *scp;
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
	uc_init(2);
	if (!uc_encode(2,(struct scblk *)icp)) {
		return 0;
	}
        i = uc_len(2);
        p = uc_str(2);
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
    register struct scblk *scp;

    /*
    /   if argument one is null...
    */
    scp = WA (struct scblk *);
    if (scp->typ == TYPE_SCL && !scp->len)
    {
	uc_init(0);
	uc_append(0,HOST_STRING);
        uc_decode(0);
	SET_XL(uc_scblk(0));
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
		// uarg is encoded (utf8 format)
		uc_init(0);
		uc_append(0,uarg);
		uc_decode(0);
		SET_XL(uc_scblk(0));
                return EXIT_3;
            }
            else if ((val = cmdcnt) != 0) {
                pTSCBLK->len = 0;
                while (pTSCBLK->len < TSCBLK_LENGTH - 2 &&
                        arg2scb( (int) val++, pTSCBLK, TSCBLK_LENGTH - pTSCBLK->len ) > 0)
                    pTSCBLK->str[pTSCBLK->len++] = ' ';
                if (pTSCBLK->len)
                    --pTSCBLK->len;
                SET_XL( pTSCBLK );
                return EXIT_3;
            }
            else
                return EXIT_4;
            /*
            / HOST( 1, "command", "path" ) executes "command" using "path"
            */
        case 1: {
            char *cmd, *path;
	    uc_init(0);
	    uc_init(1);
	    if (!uc_encode(0, XL(struct scblk *))) {
		return EXIT_1;
	    }
	    if (!uc_encode(1, XR(struct scblk *))) {
		return EXIT_1;
	    }
            save0();		// made sure fd 0 OK
            pTICBLK->val = dosys(uc_str(0), uc_str(1));

            pTICBLK->typ = TYPE_ICL;
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
                pTSCBLK->len = 0;
                retval = arg2scb( (int) val, pTSCBLK, TSCBLK_LENGTH );
                if ( retval < 0 )
                    return EXIT_6;
                if ( retval == 0 )
                    return EXIT_1;
                SET_XL( pTSCBLK );
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
	    scp = XL(struct scblk *);
            if ( scp->typ == TYPE_SCL ) {
                if ( scp->len == 0 )
                    return EXIT_1;
	    	uc_init(0);
	    	uc_encode(0,scp);
	        uc_init(2);
                if ( rdenv( 0, 2 ) < 0 )
                    return EXIT_6;

                SET_XL( uc_scblk(2) );
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
