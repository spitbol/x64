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
/   The following manifest constants define the target hardware platform
/   and tool chain.
/
/               running on a:
/   BCC32       Intel 32-bit x86, Borland C++ compiler (Windows command line)
/   VCC         Intel 32-bit x86, Microsoft Visual C (Windows command line)
/   GCCi32      Intel 32-bit x86, GNU GCC
/   GCCi64      Intel 64-bit x86, GNU GCC
/   RS6         IBM RS6000 (Power)
/
/   The following manifest constants define the target operating system.
/
/   LINUX       Linux
/
*/

/* Override default values in port.h.  It is necessary for a user configuring
 * SPITBOL to examine all the default values in port.h and override those
 * that need to be altered.
 */
/*  Values for x86 Linux 32-bit SPITBOL.
 */
#define EXECFILE    0
#define FLTHDWR     0   // Change to 1 when do floating ops inline
#define GCCi32      1
#define LINUX       1
#define SAVEFILE    1


