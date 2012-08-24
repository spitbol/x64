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
    exit()

    This is a "fake" exit() function that prevents the linker from linking
    in the standard C exit() function with all the associated stdio library
    functions.
*/
#include "port.h"
#if !VCC
void
exit (status)
     int status;
{
}
#endif

extern void _exit Params ((int status));
#if WINNT | AIX
extern void exit_custom Params ((int code));
#endif

void
__exit (code)
     int code;
{
#if WINNT | AIX
  exit_custom (code);		/* Perform system specific shutdown */
#endif

  _exit (code);
}
