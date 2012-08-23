/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
        File:  DOSYS.C          Version:  01.04
        ---------------------------------------

        Contents:       Function dosys

        1.04    15-Oct-91       Intel bug in system() command.  Malloc must
                                                allocate out of high memory to allow spawn to
                                                work properly.  We set a global switch that
                                                tells malloc to use sbrk to satisfy memory
                                                request made by spawn() and system().

    1.03  08-May-91 <withdrawn>.

        1.02    23-Jun-90       Add second argument for optional path specification.
                                Change first argument to C-string, not SCBLK.

        1.01    04-Mar-88       Changes for Definicon

*/

/*
    dosys( cmd, path )

    dosys() does a "system" function call with the string contained in cmd.

    Parameters:
        cmd             C-string of command to execute
        path    C-string of optional pathspec of program to execute.
                        May be null string.
    Returns:
        code returned by system
*/

#include "port.h"

#if WINNT
#include <stdlib.h>
#endif

int dosys( cmd, path )
char    *cmd;
char    *path;
{
    return system( cmd );
}

