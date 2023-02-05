/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields
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

    wrterr("usage: spitbol [options] files[.sbl or .spx] [args to HOST(2)]");

#endif					// RUNTIME

#if RUNTIME
    wrterr("spitbol v4.0");
    wrterr("options: (# is a decimal number)");
    wrterr("-u \"string\" data string available to program");
    wrterr("-#=file   associate file with I/O channel #");
#else					// RUNTIME
    wrterr("source files are concatenated, filename '-' is standard input/output");
    wrterr("# is a decimal number.  Append \"k\" for kilobytes, \"m\" for megabytes.");
    wrterr("spitbol v4.0");
    wrterr("options:");
    wrterr("-d# #bytes max heap            -i# #bytes initial heap size & enlarge amount");
    wrterr("-m# #bytes max object size     -s# #bytes stack size");
    wrterr("-c compiler statistics         -x execution statistics");
    wrterr("-a same as -lcx                -l normal listing");
    wrterr("-o=file[.lst]  listing file    -h suppress version ID/date in listing");
/*    wrterr("-g# lines per page             -t# line width in characters");*/
    wrterr("-b suppress signon message     -e errors to list file only");
    wrterr("-k run with compilation error  -n suppress execution");
    wrterr("-F fold source code case (ignore source code case) -f don't fold source code");
    wrterr("-u \"string\" data passed to HOST(0)");

#if EXECFILE
    wrterr("-w write load (.out) module    -y write save (.spx) file");
#endif					// EXECFILE

#if !EXECFILE
    wrterr("-y write save (.spx) file");
#endif					// !EXECFILE

    wrterr("-r INPUT from source file following END statement");
    wrterr("-T=file  write TERMINAL output to file");
    wrterr("-#=file[options]  associate file with I/O channel #");
    wrterr("option defaults: -F -d64m -i128k -m4m -s128k -g60 -t120");

#endif					// RUNTIME

    exit(0);
}
