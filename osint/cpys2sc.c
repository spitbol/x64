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
*/

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
