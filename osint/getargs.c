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
/	This module contains the switch loop that processes command
/	line options.
*/
#include "port.h"

#include <fcntl.h>

/*
 * getargs
 *
 * Input:
 *   argc:  count of argument strings
 *   argv:  array of argument string pointers
 *
 * Output:
 *   pointer to pointer to string of source file name, or NULL if none.
 *
 * Globals modified:
 *   cfiles[]
 *   cmdcnt
 *   databts
 *   inpcnt
 *   lnsppage
 *   maxf
 *   maxsize
 *   memincb
 *   outptr
 *   pagewdth
 *   readshell0
 *   spitflags
 *   stacksiz
 *   uarg
 */
static  int i;
static  char *cp;
static char *filenamearg (int argc, char *argv[]);

char **getargs( argc, argv )
int		argc;
char	*argv[];
{
    register char **result;

    /*
    /   Process all command line options.
    /
    /   NOTE:  the value of the loop control variable
    /   i is modified within the loop.
    /
    /   spitbol is invoked as
    /
    /	spitbol [options] [input-files]
    /
    /   where each option string begins with a '-'
    /
    /   A single '-' represents the standard file provided by the shell
    /   and is treated as an input-file or output file as appropriate.
    */
    result = (char **)0;		// no source file

    for( i = 1 ; i < argc ; i++ ) {
        cp = argv[i];			// point to next cmd line argument

        /*
         *   If this command line argument does not start with a '-
         *   OR is a single '-', treat is as the first filename.
         */
        if ( *cp != '-'  ||  !cp[1] ) {
            if ( !result )
                result = argv + i;	// result -> first filename pointer
            break;		// break out of for loop
        }

        /*
        /   Here to process option string.  Allow more than one option
        /   to be specified after the '-'.  For example, "-aez" and
        /    "-s24kae"
        */
        ++cp;
        while( *cp )
            switch( *cp++ ) {
                /*
                /	-?  display option summary
                */
            case '?':
                prompt();
                break;
#if !RUNTIME
                /*
                /   -a	turn on all listing options except header
                */
            case 'a':
                spitflag &= ~(NOLIST | NOCMPS | NOEXCS);
                break;

                /*
                /   -b	suppress signon message when reloading save file
                */
            case 'b':
                spitflag |= NOBRAG;
                break;

                /*
                /   -c	turn on compilation statistics
                */
            case 'c':
                spitflag &= ~NOCMPS;
                break;

                /*
                    /   -dnnn	set maximum size of dynamic area in bytes
                    */
            case 'd':
                cp = optnum( cp, &databts );
                // round up to machine word boundary
                databts = (databts + sizeof(int) - 1)  & ~(sizeof(int) - 1);
                break;

                /*
                /   -e don't send errors to terminal
                */
            case 'e':
                spitflag &= ~ERRORS;
                break;

                /*
                /   -f	don't fold lower case to upper case
                */
            case 'f':
                spitflag &= ~CASFLD;
                break;

                /*
                /   -gddd	set page length in lines  V1.08
                */
            case 'g':
                cp = getnum( cp, &lnsppage );
                break;

                /*
                /   -h	suppress version header in listing
                */
            case 'h':
                spitflag |= NOHEDR;
                break;

                /*
                /   -iddd	set memory expansion increment (bytes)
                */
            case 'i':
                cp = optnum( cp, &memincb );
                break;

                /*
                /   -k	run inspite of compilation errors
                */
            case 'k':
                spitflag &= ~NOERRO;
                break;

                /*
                /   -l	turn on compilation listing
                */
            case 'l':
                spitflag &= ~NOLIST;
                break;

                /*
                /   -mddd	set maximum size of object in dynamic area
                */
            case 'm':
                cp = optnum( cp, &maxsize );
                break;

                /*
                /   -n	suppress program execution
                */
            case 'n':
                spitflag |= NOEXEC;
                break;

                /*
                /   -o fff	set output file to fff
                /   -o:fff & -o=fff also allowed.
                */
            case 'o':
                outptr = filenamearg(argc, argv);
                if (!outptr)
                    goto badopt;
                break;

                /*
                /   -p	turn on long listing format
                */
            case 'p':
                spitflag |= LNGLST;
                spitflag &= ~NOLIST;
                break;

		/*
		/   -I	turn on instruction trace
		*/
	    case 'I':  
		spitflag |= ITRACE;
		break;
                /*
                /   -r	read INPUT from source program file
                */
            case 'r':
                readshell0 = 0;
                break;

                /*
                /   -s	set stack size in bytes
                */
            case 's': {
                cp = optnum( cp, &stacksiz );
                // round up to machine word boundary
                stacksiz = (stacksiz + sizeof(int) - 1)  & ~(sizeof(int) - 1);
		// make multiple of 16 (needed for mac osx)
		stacksiz = 16 * (stacksiz / 16);
            }
            break;

            /*
            /   -tddd	set line width in characters  V1.08
            */
            case 't':
                cp = getnum( cp, &pagewdth );
                break;
#endif					// !RUNTIME

                /*
                /   -T fff  write TERMINAL output to file fff
                /   -T:fff & -T=fff also allowed.
                */
            case 'T':
            {
                char *ttyfile;
                File_handle h;
                ttyfile = filenamearg(argc, argv);
                if (!ttyfile)
                    goto badopt;
                h = spit_open(ttyfile, O_WRONLY|O_CREAT|O_TRUNC,
                              IO_PRIVATE | IO_DENY_READWRITE /* 0666 */,
                              IO_REPLACE_IF_EXISTS | IO_CREATE_IF_NOT_EXIST |
                              IO_WRITE_THRU );
                if (h == -1)
                    goto badopt;
                ttyoutfdn(h);
            }
            break;

            /*
            /   -u aaa	set user argument accessible via host()
            */
            case 'u':
                uarg = argv[++i];
                if ( i == argc )
                    goto badopt;	// V1.08
                break;


#if !RUNTIME
#if EXECFILE
                /*
                /   -w	write executable module after compilation
                */
            case 'w':
                spitflag |= WRTEXE;
                break;

#endif					// EXECFILE

                /*
                /   -x	print execution statistics
                */
            case 'x':
                spitflag &= ~NOEXCS;
                break;

                /*
                /   -y	write executable module after compilation
                */
            case 'y':
                spitflag |= WRTSAV;
                break;

                /*
                /   -z	turn on standard listing options
                */
            case 'z':
                spitflag |= STDLST;
                spitflag &= ~NOLIST;
                break;
#endif					// !RUNTIME

                /*
                / -# fff	associate file fff with channel #
                */
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                if (++maxf >= Ncmdf) {
                    wrterr( "Too many files on command line." );
                    __exit(1);
                }
                cp = getnum(cp - 1, (uword *)&(cfiles[maxf].filenum));
                cfiles[maxf].fileptr = filenamearg(argc, argv);
                if (!cfiles[maxf].fileptr)
                    goto badopt;
                break;

                /*
                /   anything else is an error
                */
            default:
badopt:
                write( STDERRFD, "Illegal option -", 17 );
                write( STDERRFD,  (cp - 1), 1 );
                wrterr( "?" );
                __exit(1);			// V1.08
            }
    }

    inpcnt = argc - i;		// inpcnt =  number of filenames

    /*
    /   Establish command counter for use by HOST(3) function
    */
    cmdcnt = i;
    return result;
}

// Collect filename following option
static char *filenamearg( argc, argv )
int		argc;
char    *argv[];
{
    char *result;

    if ( *cp == ':' || *cp == '=' )
    {
        if (*(cp + 1))
        {
            result = ++cp;
            while (*++cp)
                ;
        }
        else
            return (char *)0;
    }
    else
    {
        result = argv[++i];
        if ( i == argc || (result[0] == '-' && result[1] != '\0')
           )
            return (char *)0;    // V1.08
    }
    return result;
}


/*
/    getnum() converts an ASCII string to an integer AND returns a pointer
/    to the character following the last valid digit.
/
/    Parameters:
/		cp	pointer to character string
/		ip	pointer to word receiving converted result
/    Returns:
/		Pointer to character following last valid digit in input string
/    Side Effects:
/		Modifies contents of integer pointed to by ip.
*/

char	*getnum( cp, ip )
char	*cp;
uword	*ip;
{
    word	result = 0;

    while( *cp >= '0'  &&  *cp <= '9' )
        result = result * 10 + *cp++ - '0';

    *ip = result;
    return  cp;
}


/*
/   optnum() converts an ASCII string to an integer AND returns a pointer
/   to the character following the last valid digit.  optnum() is similar
/   to getnum() except that optnum accepts a trailing 'k' or 'm' to indicate
/   that the value should be scaled in units of 1,024 or 1,048,576.
/
/   Parameters:
/		cp	pointer to character string
/		ip	pointer to word receiving converted result
/   Returns:
/		Pointer to character following last valid digit in input string,
/		including a trailing k.
/   Side Effects:
/		Modifies contents of integer pointed to by ip.
*/

char	*optnum( cp, ip )
char *cp;
uword *ip;
{
    char c;
    cp = getnum( cp, ip );

    c = *cp;
    if ( c == 'k' || c == 'K' ) {
        ++cp;
        *ip <<= 10;
    }

    if ( c == 'm' || c == 'M' ) {
        ++cp;
        *ip <<= 20;
    }

    return  cp;
}
