/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2013 David Shields
*/

/*
/   rdenv( varname, result )
/
/   rdenv() reads the environment variable named "varname", and if it can
/   be read, puts its value in "result.
/
/   Parameters:
/	varname	pointer to character string containing variable name
/	result	pointer to character string to receive result
/   Returns:
/	0 if successful / -1 on failure
/
/	v1.02 02-Jan-91 Changed rdenv to use cpys2sc instead of mystrncpy.
/					Add private getenv().
*/

#include "port.h"

/*
/   Find environment variable vq of length vn.  Return
/   pointer to value (just past '='), or 0 if not found.
*/
char *findenv( vq, vn )
char *vq;
int  vn;
{
    char savech;
    char *p;

    savech = make_c_str(&vq[vn]);
    p = (char *)getenv(vq);			// use library lookup routine
    unmake_c_str(&vq[vn], savech);
    return p;

}

rdenv( varname, result )
register struct scblk *varname, *result;
{
    register char *p;


    if ( (p = findenv(varname->str, varname->len)) == 0 )
        return -1;

    cpys2sc(p, result, tscblk_length);

    return 0;
}

/* make a string into a C string by changing the last character to null,
 * returning the old character at that location.
 * If the old character was already null, no change is made, so that
 * this works if passed a read-only C-string.
 */
char make_c_str(p)
char *p;
{
    char rtn;

    rtn = *p;
    if (rtn)
        *p = 0;
    return rtn;
}


// Intel compiler bug?
void unmake_c_str(p, savech)
char *p;
char savech;
{
    if (savech)
        *p = savech;
}
