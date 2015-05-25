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
    char	ucname[32];		// only called with "snolib" and "path"
    int		i;

    pathptr = findenv(name,length(name));
    if (!pathptr)
    {
        for (i = 0; ; i++)
            if ((ucname[i] = uppercase(name[i])) == '\0')
                break;
        pathptr = findenv(ucname, length(ucname));
    }

    // skip leading paren if present
    if (pathptr && *pathptr == '(')
        pathptr++;
}


/*
/  trypath - form a file name in file by concatenating name onto the
/  next path element.
*/
int trypath(name,file)
char *name, *file;
{
    char c;

    // return 0 if no search path or fully-qualified name
    if (pathptr == (char *)0L || name[0] == FSEP
#ifdef FSEP2
            || name[0] == FSEP2
#endif
       )
        return 0;

    while (*pathptr == ' ')    // Skip initial blanks
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

    if (!c)                     // If exhausted the string,
        pathptr = (char *)0L;     // clear pathptr so kick out on next call

    file--;
    *file++ = FSEP;

    while ((*file++ = *name++) != 0)
        ;

    *file = '\0';
    return 1;
}
