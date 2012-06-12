/*
/	File:  DOSYS.C		Version:  01.04
/	---------------------------------------
/
/	Contents:	Function dosys
/
/	1.04	15-Oct-91	Intel bug in system() command.  Malloc must
/						allocate out of high memory to allow spawn to
/						work properly.  We set a global switch that
/						tells malloc to use sbrk to satisfy memory
/						request made by spawn() and system().
/
/   1.03  08-May-91 <withdrawn>.
/
/	1.02	23-Jun-90	Add second argument for optional path specification.
/				Change first argument to C-string, not SCBLK.
/
/	1.01	04-Mar-88	Changes for Definicon
/
*/
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */

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

#if WINNT
#include <stdlib.h>
#endif

int dosys( cmd, path )
char	*cmd;
char	*path;
{
  return system( cmd );
}

