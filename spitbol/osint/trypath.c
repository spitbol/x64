/*
/  File: TRYPATH.C         Version 1.01
/	--------------------------------------------
/
/	Contents:	Functions initpath, trypath.
/
/  V1.01 4-27-97 Fix bug in trypath that allowed it to search beyond the
/                trailing '\0' in pathptr.
*/
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */

#include "port.h"

/*
/  Pointer to "SNOLIB" string
*/


/*
/  initpath - initialize for a search by looking to see if there
/	    is a search path.  Under Unix, the user could be running
/		either the Korn shell or csh, implying two forms:
/		VAR path:path:path
/		var (path path path)
/
/		caller should call with the lowercase version of var.  We
/		will try the uppercase version automatically.
*/
void initpath(name)
char *name;
{
    char	ucname[32];		/* only called with "snolib" and "path" */
    int		i;

    pathptr = findenv(name,length(name));
    if (!pathptr)
    {
        for (i = 0; ; i++)
            if ((ucname[i] = uppercase(name[i])) == '\0')
                break;
        pathptr = findenv(ucname, length(ucname));
    }

#if UNIX
    /* skip leading paren if present */
    if (pathptr && *pathptr == '(')
        pathptr++;
#endif
}


/*
/  trypath - form a file name in file by concatenating name onto the
/  next path element.
*/
int trypath(name,file)
char *name, *file;
{
    char c;

    /* return 0 if no search path or fully-qualified name */
    if (pathptr == (char *)0L || name[0] == FSEP
#ifdef FSEP2
            || name[0] == FSEP2
#endif
       )
        return 0;

    while (*pathptr == ' ')    /* Skip initial blanks */
        pathptr++;
    if (!*pathptr)
        return 0;

    do
    {
        c = (*file++ = *pathptr++);
    }
#ifdef PSEP2
    while (c && c != PSEP && c != PSEP2 && c != ')' )
#else
    while (c && c != PSEP)
#endif
        ;

    if (!c)                     /* If exhausted the string, */
        pathptr = (char *)0L;     /* clear pathptr so kick out on next call */

    file--;
    *file++ = FSEP;

    while ((*file++ = *name++) != 0)
        ;

    *file = '\0';
    return 1;
}
