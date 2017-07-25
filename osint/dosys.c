/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields
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

