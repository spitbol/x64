/*
/	File:  ARG2SCB.C	Version:  01.02
/	---------------------------------------
/
/	Contents:	Function arg2scb
/
/	1.02	Rewritten to append to scblk instead of copy to block.
*/
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */

/*
/   arg2scb( req, argc, argv, scptr, maxs )
/
/   arg2scb() makes a copy of the req-th argument in the argv array.
/   The copy is appended to the string in the SCBLK provided.
/
/   Parameters:
/	req	number of argument to copy
/	argc	number of arguments
/	argv	pointer to array of pointers to strings (arguments)
/	scptr	pointer to SCBLK to receive copy of argument
/	maxs	maximum number of characters to append.
/   Returns:
/	Length of argument copied or -1 if req is out of range.
/   Side Effects:
/	Modifies contents of passed SCBLK (scptr).
/	SCBLK length field is incremented.
*/

#include "port.h"

int	arg2scb( req, argc, argv, scptr, maxs )

int	req;
int	argc;
char	*argv[];
struct	scblk	*scptr;
int	maxs;

{
    register word	i;
    register char	*argcp, *scbcp;

    if ( req < 0  ||  req >= argc )
        return	-1;

    argcp	= argv[req];
    scbcp	= scptr->str + scptr->len;
    for( i = 0 ; i < maxs  &&  ((*scbcp++ = *argcp++) != 0) ; i++ )
        ;
    scptr->len += i;
    return i;
}
