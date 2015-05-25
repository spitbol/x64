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

/*	prompt() - used to give user usage info in command line versions.
 *
 */
void prompt()
{
#if RUNTIME
    wrterr("usage: spitrun [options] file[.spx] [program arguments]");
#else					// RUNTIME

    wrterr("usage: spitbol [options] files[.spt or .spx] [args to HOST(2)]");

#endif					// RUNTIME

#if RUNTIME
    wrterr("options: (# is a decimal number)");
    wrterr("-u \"string\" data string available to program");
    wrterr("-#=file   associate file with I/O channel #");
#else					// RUNTIME
    wrterr("source files are concatenated, filename '-' is standard input/output");
    wrterr("# is a decimal number.  Append \"k\" for kilobytes, \"m\" for megabytes.");
    wrterr("options:");
    wrterr("-d# #bytes max heap            -i# #bytes initial heap size & enlarge amount");
    wrterr("-m# #bytes max object size     -s# #bytes stack size");
    wrterr("-c compiler statistics         -x execution statistics");
    wrterr("-a same as -lcx                -l normal listing");
    wrterr("-p listing with wide titles    -z listing with form feeds");
    wrterr("-o=file[.lst]  listing file    -h suppress version ID/date in listing");
    wrterr("-g# lines per page             -t# line width in characters");
    wrterr("-b suppress signon message     -e errors to list file only");
    wrterr("-k run with compilation error  -n suppress execution");
    wrterr("-f no case-folding             -u \"string\" data passed to HOST(0)");

#if EXECFILE
    wrterr("-w write load (.out) module    -y write save (.spx) file");
#endif					// EXECFILE

#if !EXECFILE
    wrterr("-y write save (.spx) file");
#endif					// !EXECFILE

    wrterr("-r INPUT from source file following END statement");
    wrterr("-T=file  write TERMINAL output to file");
    wrterr("-#=file[options]  associate file with I/O channel #");
    wrterr("option defaults: -d64m -i128k -m4m -s128k -g60 -t120");

#endif					// RUNTIME

    __exit(0);
}
