
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields
*/

/*
/    This module contains the switch loop that processes command
/    line options.
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
static int i;
static char *cp;
static char *filenamearg(int argc, char *argv[]);

char **
getargs(int argc, char *argv[])
{
    char **result;

    /*
       /   Process all command line options.
       /
       /   NOTE:  the value of the loop control variable
       /   i is modified within the loop.
       /
       /   spitbol is invoked as
       /
       /    spitbol [options] [input-files]
       /
       /   where each option string begins with a '-'
       /
       /   A single '-' represents the standard file provided by the shell
       /   and is treated as an input-file or output file as appropriate.
     */
    result = NULL; /* no source file */

    for(i = 1; i < argc; i++) {
        cp = argv[i]; /* point to next cmd line argument */

        /*
         *   If this command line argument does not start with a '-
         *   OR is a single '-', treat is as the first filename.
         */
        if(*cp != '-' || !cp[1]) {
            if(!result)
                result = argv + i; /* result -> first filename pointer */
            break;                 /* break out of for loop */
        }

        /*
           /   Here to process option string.  Allow more than one option
           /   to be specified after the '-'.  For example, "-aez" and
           /    "-s24kae"
         */
        ++cp;
        while(*cp)
            switch(*cp++) {
            case '?':   /* display option summary */
                prompt();
                break;
#if !RUNTIME
            case 'l':   /* turn on compilation listing */
                spitflag &= ~NOLIST;
                break;
            case 'c':   /* turn on compilation statistics */
                spitflag &= ~NOCMPS;
                break;
            case 'x':   /* print executaion statistics */
                spitflag &= ~NOEXCS;
                break;
            case 'a':   /* (lcx) turn on all listing options except header */
                spitflag &= ~(NOLIST | NOCMPS | NOEXCS);
                break;
            case 'g':   /* ddd set page length in lines V1.08 */
                cp = getnum(cp, &lnsppage);
                break;
            case 't':   /* ddd set line width in characters   V1.08 */
                cp = getnum(cp, &pagewdth);
                break;
            case 'h':   /* suppress version header in listing */
                spitflag |= NOHEDR;
                break;
            case 'p':   /* turn on long listing format */
                spitflag |= LNGLST;
                spitflag &= ~NOLIST;
                break;
            case 'z':   /* turn on standard listing options */
                spitflag |= STDLST;
                spitflag &= ~NOLIST;
                break;
            case 'b':   /* suppress signon message when reloading save */
                spitflag |= NOBRAG;
                break;

            case 'd':   /* nnn set maximum size of dynamic area in bytes */
                cp = optnum(cp, &databts);
                /* round up to machine word boundary */
                databts = (databts + sizeof(int) - 1) & ~(sizeof(int) - 1);
                break;
            case 'e':   /* don't send errors to terminal */
                spitflag &= ~ERRORS;
                break;
            case 'f':   /* don't fold lower case to upper case */
                spitflag &= ~CASFLD;
                break;
            case 'F':   /* fold lower case to upper case */
                spitflag |= CASFLD;
                break;
            case 'i':   /* ddd set memory expansion increment (bytes) */
                cp = optnum(cp, &memincb);
                break;
            case 'k':   /* run inspite of compilation errors */
                spitflag &= ~NOERRO;
                break;
            case 'm':   /* ddd set maximum size of object in dynmaic area */
                cp = optnum(cp, &maxsize);
                break;
            case 'n':   /* supress program execution */
                spitflag |= NOEXEC;
                break;
            case 'o':   /* fff | :fff | =fff set output file to fff */
                outptr = filenamearg(argc, argv);
                if(!outptr)
                    goto badopt;
                break;
            case 'r':   /* read INPUT from source program file */
                readshell0 = 0;
                break;
            case 's':   /* ddd set stack size in bytes */
                cp = optnum(cp, &stacksiz);
                /* round up to machine word boundary */
                stacksiz = (stacksiz + sizeof(int) - 1) & ~(sizeof(int) - 1);
                break;

#endif /* !RUNTIME */

            case 'T': { /* fff | :fff | =fff write TERMINAL output to file fff */
                char *ttyfile;
                File_handle h;
                ttyfile = filenamearg(argc, argv);
                if(!ttyfile)
                    goto badopt;
                h = spit_open(ttyfile, O_WRONLY | O_CREAT | O_TRUNC,
                              IO_PRIVATE | IO_DENY_READWRITE
                              /* 0666 */,
                              IO_REPLACE_IF_EXISTS | IO_CREATE_IF_NOT_EXIST
                                  | IO_WRITE_THRU);
                if(h == -1)
                    goto badopt;
                ttyoutfdn(h);
            } break;

            case 'u':   /* aaa set user argument accessible via host() */
                uarg = argv[++i];
                if(i == argc)
                    goto badopt; /* V1.08 */
                break;

#if !RUNTIME
# if EXECFILE
            case 'w':   /* write executable module after compilation */
                spitflag |= WRTEXE;
                break;
# endif /* EXECFILE */
            case 'y':   /* write executable module after compilation */
                spitflag |= WRTSAV;
                break;
#endif /* !RUNTIME */

            case '0':   /* # fff associate file fff with channel # */
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                if(++maxf >= Ncmdf) {
                    wrterr("Too many files on command line.");
                    exit(1);
                }
                cp = getnum(cp - 1, (uword *)&(cfiles[maxf].filenum));
                cfiles[maxf].fileptr = filenamearg(argc, argv);
                if(!cfiles[maxf].fileptr)
                    goto badopt;
                break;

            default:    /* anything else is an error */
            badopt:
                write(STDERRFD, "Illegal option -", 17);
                write(STDERRFD, (cp - 1), 1);
                wrterr("?");
                exit(1); /* V1.08 */
            }
    }

    inpcnt = argc - i; /* inpcnt =  number of filenames */

    /*
       /   Establish command counter for use by HOST(3) function
     */
    cmdcnt = i;
    return result;
}

/* Collect filename following option */
static char *
filenamearg(int argc, char *argv[])
{
    char *result;

    if(*cp == ':' || *cp == '=') {
        if(*(cp + 1)) {
            result = ++cp;
            while(*++cp)
                ;
        } else
            return (char *)0;
    } else {
        result = argv[++i];
        if(i == argc || (result[0] == '-' && result[1] != '\0'))
            return (char *)0; /* V1.08 */
    }
    return result;
}

/*
/    getnum() converts an ASCII string to an integer AND returns a pointer
/    to the character following the last valid digit.
/
/    Parameters:
/        cp    pointer to character string
/        ip    pointer to word receiving converted result
/    Returns:
/        Pointer to character following last valid digit in input string
/    Side Effects:
/        Modifies contents of integer pointed to by ip.
*/

char *
getnum(char *cp, uword *ip)
{
    word result = 0;

    while(*cp >= '0' && *cp <= '9')
        result = result * 10 + *cp++ - '0';

    *ip = result;
    return cp;
}

/*
/   optnum() converts an ASCII string to an integer AND returns a pointer
/   to the character following the last valid digit.  optnum() is similar
/   to getnum() except that optnum accepts a trailing 'k' or 'm' to indicate
/   that the value should be scaled in units of 1,024 or 1,048,576.
/
/   Parameters:
/        cp    pointer to character string
/        ip    pointer to word receiving converted result
/   Returns:
/        Pointer to character following last valid digit in input string,
/        including a trailing k.
/   Side Effects:
/        Modifies contents of integer pointed to by ip.
*/

char *
optnum(char *cp, uword *ip)
{
    char c;
    cp = getnum(cp, ip);

    c = *cp;
    if(c == 'k' || c == 'K') {
        ++cp;
        *ip <<= 10;
    }

    if(c == 'm' || c == 'M') {
        ++cp;
        *ip <<= 20;
    }

    return cp;
}
