/*
copyright 1987-2012 robert b. k. dewar and mark emmer.

this file is part of macro spitbol.

    macro spitbol is free software: you can redistribute it and/or modify
    it under the terms of the gnu general public license as published by
    the free software foundation, either version 3 of the license, or
    (at your option) any later version.

    macro spitbol is distributed in the hope that it will be useful,
    but without any warranty; without even the implied warranty of
    merchantability or fitness for a particular purpose.  see the
    gnu general public license for more details.

    you should have received a copy of the gnu general public license
    along with macro spitbol.  if not, see <http://www.gnu.org/licenses/>.
*/

/*
/   the following manifest constants define the target hardware platform
/   and tool chain.
/
/               running on a:
/   bcc32       intel 32-bit x86, borland c++ compiler (windows command line)
/   vcc         intel 32-bit x86, microsoft visual c (windows command line)
/   gcci32      intel 32-bit x86, gnu gcc
/   gcci64      intel 64-bit x86, gnu gcc
/   rs6         ibm rs6000 (power)
/   sun4        sparc, sun4
/
/   the following manifest constants define the target operating system.
/
/   linux       linux
/   winnt       windows nt/xp/vista
/
*/

/* override default values in port.h.  it is necessary for a user configuring
 * spitbol to examine all the default values in port.h and override those
 * that need to be altered.
 */
/*  values for x86 linux 32-bit spitbol.
 */
#define execfile    0
#define flthdwr     0   /* change to 1 when do floating ops inline */
#define gcci32      1
#define linux       1
#define savefile    1


