/*
/	File:  CPYS2SC.C	Version:  01.01
/	---------------------------------------
/
/	Contents:	Function cpy2sc
*/

/*
/   cpys2sc( cp, scptr, maxlen )
/
/   cpys2sc() copies a C style string pointed to by cp into the SCBLK
/   pointed to by scptr.
/
/   Parameters:
/	cp	pointer to C style string
/	scptr	pointer to SCBLK to receive copy of string
/	maxlen	maximum length of string area within SCBLK
/   Returns:
/	Nothing.
/
/   Side Effects:
/	Modifies contents of passed SCBLK (scptr).
/
/   v1.01, 12/28/90 - pad last word in SCBLK with zeros to match behavior of ALOCS.
/			Eliminated termch argument,  since it was always zero.
*/
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */

#include "port.h"

void cpys2sc( cp, scptr, maxlen )

char	*cp;
struct	scblk	*scptr;
word	maxlen;

{
    register word	i;
    register char	*scbcp;

    scptr->typ = TYPE_SCL;
    scbcp	= scptr->str;
    for( i = 0 ; i < maxlen  &&  ((*scbcp++ = *cp++) != 0) ; i++ )
        ;
    scptr->len = i;
    while (i++ & (sizeof(word) - 1))
        *scbcp++ = 0;
}
