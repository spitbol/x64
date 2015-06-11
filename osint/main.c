/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2015 David Shields

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
/	This module contains the main function that gets control when
/	the spitbol compiler starts execution.  Responsibilities of
/	this function:
/
/	o  Save argc and argv parameters in global storage.
/
/	o  Determine if this execution reflects the invocation of
/	   of the compiler or of a load module and take appropriate
/	   actions.
/
/	   If invoked as compiler:  process command line arguments,
/	   set up input files, output file, initial memory allocation,
/	   and transfer control to compiler
/
/	   If invoked as load module:  reset various compiler variables
/	   whose values are no longer valid, re-establish dynamic area
/	   and transfer control to function that returns control to
/	   suspended spitbol program
/
/                  line as file names.
*/
#define GLOBALS			// global variables will be defined in this module
#include "port.h"
#include <stdint.h>
#include <stdio.h>

#ifdef DEBUG
#undef DEBUG			// Change simple -DDEBUG on command line to -DDEBUG=1
#define DEBUG 1
#else
#define DEBUG 0
#endif

void setout ( void );

int main( argc, argv )
int	argc;
char	*argv[];

{
    int		i;
    /*
    /   Save command line parameters in global storage, in case they are needed
    /   later.
    */
    gblargc = argc;
    gblargv = argv;
    lowsp = 0L;
    /*
    /	Initialize buffers
    */
    stdioinit();
    ttyinit();
    /*
    /	Make sure sysdc gets to output stuff at least once.
    */
    dcdone = 0;

#undef EXECFILE
#if EXECFILE
    /*
    /   If this is a restart of this program from a load module, set things
    /   up for a restart.  Transfer control to function restart which actually
    /   resumes program execution.
    */
    if ( lmodstk ) {
        if ( brk( (char *) topmem ) < 0 ) { // restore topmem to its prior state
            wrterr( "Insufficient memory to load." );
            __exit(1);
        }

        cmdcnt = 1;       // allow access to command line args
        inpptr = 0;				// no compilation input files
        inpcnt = 0;				// ditto
        outptr = 0;				// no compilation output file
        pathptr = (char *)-1L;	// include paths unknown
        clrbuf();				// no chars left in std input buffer
        sfn = 0;
        heapmove();				// move the heap up
        malloc_empty();			// mark the malloc region as empty
        zysdc();							// Brag if necessary
        restart( (char *)0L, lowsp );       // call restart to continue execution
    }
#endif					// EXECFILE

    /*
     * 	Process command line arguments
     */
    inpptr = getargs(argc, argv);

    if ( inpptr )
        sfn = *inpptr;		// pointer to first file name
    else
    {
        zysdc();
        wrterr("");
        prompt();
    }

    /*
    /   Switch to proper input file.
    */
    swcinp( inpcnt, inpptr );

    switch (getsave(getrdfd())) {
    case 1:					// save file loaded
	wrterr("SPITBOL save file no supported");
//        inpcnt = 0;               // v1.02 no more cmd line files
 //       swcinp(inpcnt, inpptr );  // v1.01
  //      restart( (char *)0L, lowsp );

    case 0:					// not a save file
#if RUNTIME
        wrterr("SPITBOL save (.spx) file only!");
#else					// RUNTIME
        break;
#endif					// RUNTIME

    case -1:				// error loading save file
        __exit(1);
    }

    /*
    /	Setup output and issue brag message
    */
    setout();

#if !RUNTIME

    /*
     *	Force the memory manager to initialize itself
     */
    if ((char *)sbrk(0) == (char *)-1) {
        wrterr( "Insufficient memory.  Try smaller -d, -m, or -s command line options." );
        __exit( 1 );
    }

    /*
    /   Allocate stack
    */
    if ((lowsp = sbrk((uword)stacksiz)) == (char *) -1) {
        wrterr( "Stack memory unavailable." );
        __exit( 1 );
    }
    /*
    /   Allocate initial increment of dynamic memory.
    /
    */

    if ((basemem = (char *)sbrk((uword)memincb)) == (char *) -1) {
        wrterr( "Workspace memory unavailable." );
        __exit( 1 );
    }
    topmem = basemem + memincb;
    maxmem = basemem + databts;


    /*
	Adjust stacksiz to be multiple of 16. This is required for OSX and causes
	no harm for unix.
    */
	stacksiz = 16 * (stacksiz / 16 );
    /*
    /   All compiler registers are initially zero, except for XL and XR which
    /   are set to top and bottom of heap.
    */
    SET_CP( 0 );
    SET_IA( 0 );
    SET_WA( 0 );

/* Pass value of largest integer in WB on startup. It's not possible to set this up
   at compile time if we compiling for 64 bits on 32 bit machine.
 */
#ifdef unix_32
    long mxint = INT32_MAX;
#else
    long mxint = INT64_MAX;
#endif
#ifdef osx_32
    long mxint = INT32_MAX;
#endif
    SET_WB( mxint );

    SET_WC( 0 );
    SET_XR( basemem );
    SET_XL( topmem - sizeof(word) );

    trc_init(basemem, topmem);
    /*
    /   Startup compiler.
    */
    startup();
    printf("oops! startup unexpectedly returned. exiting...\n");
    return 1;
#endif					// !RUNTIME

    /*
    /   Never returns. exit is via exit().
    */
	return 0;
}



/*
/	wrterr( s )
/
/	Write message to standard error, and append end-of-line.
*/
void wrterr(s)
char	*s;
{
    write( STDERRFD, s, length(s) );
    write( STDERRFD,  "\n", 1 );
}

void wrtintz(n)
int	n;
{
    /*
    	char str[16];
    	itoa(n,str);
    	write( STDOUTFD, str, length(str) );
    	write( STDOUTFD,  EOL, 1 );
    */
}

/*
/	wrtmsg( s )
/
/	Write message to standard output, and append end-of-line.
*/
void wrtmsg(s)
char	*s;
{
    write( STDOUTFD, s, length(s) );
    write( STDOUTFD,  "\n", 1 );
}

/*
 * Setup output file.
 * Issue brag message if approriate
 *
 * This rather clumsy routine was placed here because of sequencing
 * concerns -- it can't be called with a save file until spitflag
 * has been reloaded.
 */
void setout()
{
    /*
     *	Brag prior to calling swcoup
     */
    zysdc();

    /*
    /   Switch to proper output file.
    */
    swcoup( outptr );

    /*
    /   Determine if standard output is a tty or not, and if it is be sure to
    /   inform compiler and turn off header.
    */
    spitflag &= ~PRTICH;
    if ( testty( getprfd() ) == 0 )
    {
        lnsppage = 0;
        spitflag |= (PRTICH | NOHEDR);
    }
}
