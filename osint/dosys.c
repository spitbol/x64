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
/   dosys( cmd, path )
/
/   dosys() does a "system" function call with the string contained in cmd.
/
/   Parameters:
/	cmd		C-string of command to execute
/	path	C-string of optional pathspec of program to execute.
/			May be null string.
/   Returns:
/	code returned by system
*/

#include "port.h"

int dosys( cmd, path )
char	*cmd;
char	*path;
{
    return system( cmd );
}

