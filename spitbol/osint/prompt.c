/*
/	File:  PROMPT.C		Version:  01.00
/	---------------------------------------
/
/	Contents:	Function prompt
*/

#include "port.h"

/*	prompt() - used to give user usage info in command line versions.
 *
 */
void prompt()
{
#if RUNTIME
    wrterr("usage: spitrun [options] file[.spx] [program arguments]");
#else					/* RUNTIME */

#if SAVEFILE
    wrterr("usage: spitbol [options] files[.spt or .spx] [args to HOST(2)]");
#else					/* SAVEFILE */
    wrterr("usage: spitbol [options] files[.spt] [args to HOST(2)]");
#endif					/* SAVEFILE */

#endif					/* RUNTIME */

#if RUNTIME
#if WINNT
    wrterr("options (use - or / to specify):   (# is a decimal number)");
#else             /* WINNT */
    wrterr("options: (# is a decimal number)");
#endif               /* WINNT */
    wrterr("-u \"string\" data string available to program");
    wrterr("-#=file   associate file with I/O channel #");
#else					/* RUNTIME */
    wrterr("source files are concatenated, filename '-' is standard input/output");
    wrterr("# is a decimal number.  Append \"k\" for kilobytes, \"m\" for megabytes.");
#if WINNT
    wrterr("options (use - or /  to specify):");
#else             /* WINNT */
    wrterr("options:");
#endif               /* WINNT */
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

#if EXECFILE & SAVEFILE
#if WINNT
    wrterr("-w write execution (.exe) file -y write save (.spx) file");
#else             /* WINNT */
    wrterr("-w write load (.out) module    -y write save (.spx) file");
#endif               /* WINNT */
#endif					/* EXECFILE & SAVEFILE */

#if SAVEFILE & !EXECFILE
    wrterr("-y write save (.spx) file");
#endif					/* SAVEFILE & !EXECFILE */

    wrterr("-r INPUT from source file following END statement");
    wrterr("-T=file  write TERMINAL output to file");
    wrterr("-#=file[options]  associate file with I/O channel #");
#if SOLARIS | LINUX | WINNT
    wrterr("option defaults: -d64m -i128k -m4m -s128k -g60 -t120");
#else
    wrterr("option defaults: -d64m -i128k -m64k -s128k -g60 -t120");
#endif

#endif					/* RUNTIME */

    __exit(0);
}
