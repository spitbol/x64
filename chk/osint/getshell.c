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
