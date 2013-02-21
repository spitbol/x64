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
/	File:  CPYS2SC.C	Version:  01.01
/	---------------------------------------
/
/	Contents:	Function cpy2sc
*/

/*
/   cpys2sc( cp, ccptr, maxlen )
/
/   cpys2sc() copies a C style string pointed to by cp into the CCBLK
/   pointed to by ccptr.
/
/   Parameters:
/	cp	pointer to C style string
/	ccptr	pointer to CCBLK to receive copy of string
/	maxlen	maximum length of string area within CCBLK
/   Returns:
/	Nothing.
/
/   Side Effects:
/	Modifies contents of passed CCBLK (ccptr).
*/

#include "port.h"

void cpys2sc( cp, ccptr, maxlen )

char	*cp;
struct	ccblk	*ccptr;
word	maxlen;

{
    register word	i;
    register char	*ccbcp;

    ccptr->typ = TYPE_SCL;
    ccbcp	= ccptr->str;
    for( i = 0 ; i < maxlen  &&  ((*ccbcp++ = *cp++) != 0) ; i++ )
        ;
    ccptr->len = i;
    while (i++ & (sizeof(word) - 1))
        *ccbcp++ = 0;
}
