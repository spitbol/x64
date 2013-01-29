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
/	File:  FAKEXIT.C	Version:  01.00
/	---------------------------------------
/
/	Contents:	Function exit
*/

/*
/   exit()
/
/   This is a "fake" exit() function that prevents the linker from linking
/   in the standard C exit() function with all the associated stdio library
/   functions.
*/
#include "port.h"
#if !VCC
void exit(status)
int status;
{}
#endif

extern void _exit (int status);

void __exit(code)
int code;
{
    _exit(code);
}
