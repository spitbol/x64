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
    doexec( scptr )

    doexec() does an "execle" function call to invoke the shell on the
    command string contained in the passed SCBLK.

    Parameters:
        scptr   pointer to SCBLK containing the command to execute
    Returns:
        No return if shell successfully executed
        Returns if could not execute command


        1.03    15-Oct-91       Intel bug in system() command.  Malloc must
                                                allocate out of high memory to allow spawn to
                                                work properly.  We set a global switch that
                                                tells malloc to use sbrk to satisfy memory
                                                request made by spawn() and system().


*/

#include "port.h"


char *getshell ();
char *pathlast ();

void
doexec (scbptr)
     struct scblk *scbptr;

{
  word length;
  char savech;
  char *cp;
  extern char **environ;
  char *shellpath;
  length = scbptr->len;
  cp = scbptr->str;

  /*
     /   Instead of copying the command string, temporarily save the character
     /   following the string, replace it with a NUL, execute the command, and
     /   then restore the original character.
   */
  savech = make_c_str (&cp[length]);

  /*
     /   Use function getshell to get shell's path and function lastpath
     /   to get the last component of the shell's path.
   */
  shellpath = getshell ();
  execle (shellpath, pathlast (shellpath), "-c", cp, (char *) NULL, environ);	/* no return */

  unmake_c_str (&cp[length], savech);
}
