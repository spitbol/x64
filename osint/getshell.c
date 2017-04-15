/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2013 David Shields
*/

#include "port.h"

/*
/   getshell()
/
/   Function getshell returns the path for the current shell.
/
/   Parameters:
/	None
/   Returns:
/	Pointer to character string representing current shell path
*/

char *getshell()
{
    register char *p;

    if ((p = findenv(SHELL_ENV_NAME, sizeof(SHELL_ENV_NAME))) == (char *)0)
        p = SHELL_PATH;		// failure -- use default
    return p;			// value (with a null terminator)
}
