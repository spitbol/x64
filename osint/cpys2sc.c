
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields
*/

/*
/   cpys2sc( cp, scptr, maxlen )
/
/   cpys2sc() copies a C style string pointed to by cp into the SCBLK
/   pointed to by scptr.
/
/   Parameters:
/    cp    pointer to C style string
/    scptr    pointer to SCBLK to receive copy of string
/    maxlen    maximum length of string area within SCBLK
/   Returns:
/    Nothing.
/
/   Side Effects:
/    Modifies contents of passed SCBLK (scptr).
*/

#include "port.h"

void
cpys2sc(char *cp, struct scblk *scptr, word maxlen)
{
    word i;
    char *scbcp;

    scptr->typ = TYPE_SCL;
    scbcp = scptr->str;
    for(i = 0; i < maxlen && ((*scbcp++ = *cp++) != 0); i++)
        ;
    scptr->len = i;
    while(i++ & (sizeof(word) - 1))
        *scbcp++ = 0;
}
