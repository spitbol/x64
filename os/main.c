/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012 David Shields

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
        This module contains the main function that gets control when
        the spitbol compiler starts execution.  Responsibilities of
        this function:

        o  Save argc and argv parameters in global storage.

        o  Determine if this execution reflects the invocation of
           of the compiler or of a load module and take appropriate
           actions.

           If invoked as compiler:  process command line arguments,
           set up input files, output file, initial memory allocation,
           and transfer control to compiler

           If invoked as load module:  reset various compiler variables
           whose values are no longer valid, re-establish dynamic area
           and transfer control to function that returns control to
           suspended spitbol program
*/

#include "systype.h"
#include "port.h"
#include "os.h"
#include "globals.init"
#include <stdio.h>

void wrterr(char *s);
#ifdef DEBUG
#undef DEBUG			/* Change simple -DDEBUG on command line to -DDEBUG=1 */
#define DEBUG 1
#else
#define DEBUG 0
#endif

void setout(void);

extern long stklo;
extern long print_sp();
extern long stkhi;

main(argc, argv)
int argc;
char *argv[];

{
    int i;
    /*
       Save command line parameters in global storage, in case they are needed
       later.
     */
    Enter("main");
	fprintf(stderr,"stklo %8x stkhi %8x\n",&stklo, &stkhi);
    gblargc = argc;
    gblargv = argv;
    lowsp = 0L;
    /*
       Initialize buffers
     */
    stdioinit();
    ttyinit();
    /*
       Make sure sysdc gets to output stuff at least once.
     */
    dcdone = 0;

#if EXECFILE
#if EXECSAVE
    /* On some platforms we implement execfiles differently.  A save file
     * is appended to the SPITBOL executable file, and will be read in
     * just like a save file specified on the command line.
     *
     * We have to check for the presence of a save file in the executable.
     */
    i = checksave(gblargv[0]);
    if (i) {
	inpptr = gblargv;
	if (getsave(i) != 1)
	    exit(1);
	close(i);

	/* set up things that normally would be retained in the
	 * a Unix exec file.
	 */
	originp = dup(0);
	readshell0 = 0;
#else				/* EXECSAVE */
    /*
       If this is a restart of this program from a load module, set things
       up for a restart.  Transfer control to function restart which actually
       resumes program execution.
     */
    if (lmodstk) {
	if (brk((char *) topmem) < 0) {	/* restore topmem to its prior state        */
	    wrterr("Insufficient memory to load.");
	    exit(1);
	}
#endif				/* EXECSAVE */

	cmdcnt = 1;		/* allow access to command line args  */
	inpptr = 0;		/* no compilation input files           */
	inpcnt = 0;		/* ditto                                */
	outptr = 0;		/* no compilation output file           */
	pathptr = (char *) -1L;	/* include paths unknown        */
	clrbuf();		/* no chars left in std input buffer    */
	sfn = 0;
#if FLOAT
	hasfpu = checkfpu();	/* check for floating point hardware */
#endif				/* FLOAT */
#if !EXECSAVE
	heapmove();		/* move the heap up                                     */
	malloc_empty();		/* mark the malloc region as empty      */
#endif
	zysdc();		/* Brag if necessary */
	restart((char *) 0L, lowsp);	/* call restart to continue execution */
    }
#endif				/* EXECFILE */

    /*
       Process command line arguments
     */
    inpptr = getargs(argc, argv);

    if (inpptr) {
	sfn = *inpptr;		/* pointer to first file name */
    }
    else {
	zysdc();
	wrterr("");
	prompt();
    }

    /*
       Switch to proper input file.
     */
    swcinp(inpcnt, inpptr);

#if FLOAT
    /*
       test if floating point hardware present
     */
    hasfpu = checkfpu();
#endif				/* FLOAT */

#if SAVEFILE | EXECSAVE
    switch (getsave(getrdfd())) {
    case 1:			/* save file loaded */
	inpcnt = 0;		/* v1.02 no more cmd line files */
	swcinp(inpcnt, inpptr);	/* v1.01 */
	restart((char *) 0L, lowsp);

    case 0:			/* not a save file */
#if RUNTIME
	wrterr("SPITBOL save (.spx) file only!");
#else				/* RUNTIME */
	break;
#endif				/* RUNTIME */

    case -1:			/* error loading save file */
	exit(1);
    }
#endif				/* SAVEFILE | EXECSAVE */

    /*
       Setup output and issue brag message
     */
    setout();

#if !RUNTIME
    /*
       Force the memory manager to initialize itself
     */
    if ((char *) sbrk(0) == (char *) -1) {
	wrterr
	    ("Insufficient memory.  Try smaller -d, -m, or -s command line options.");
	exit(1);
    }

    /*
       Allocate stack
     */
	stacksiz = 400*4;
	At("allocate stack");
    if ((lowsp = sbrk((uword) stacksiz)) == (char *) -1) {
	wrterr("Stack memory unavailable.");
	exit(1);
    }

    printf("allocated sbrk lowsp, stacksiz 0x%8x 0x%8x\n",lowsp,stacksiz);
    /* Allocate initial increment of dynamic memory.  */
    basemem = sbrk(0);
    printf("sbrk(0) 0x%8x\n",basemem);
    if ((basemem = (char *) sbrk((uword) memincb)) == (char *) -1) {
	wrterr("Workspace memory unavailable.");
	exit(1);
    }
    printf("basemem 0x%8x  memincb 0x%8x\n",basemem, memincb);
    topmem = basemem + memincb;
    maxmem = basemem + databts;

    printf("topmem 0x%8x maxmem 0x%8x\n",topmem, maxmem);
    reg_xr = basemem;
    reg_xl =  topmem - sizeof(word);
    reg_xs = &stkhi;
    zystm();
    print_sp();
    startup();

	At("back from compiler");

/* atlin(); */
#endif				/* !RUNTIME */

    /*
       Never returns. exit is via exit().
     */
}



/*
        wrterr( s )

        Write message to standard error, and append end-of-line.
*/
void
wrterr(s)
char *s;
{
#if EOL2
    static char eol[2] = { EOL1, EOL2 };

#else				/* EOL2 */
    static char eol[1] = { EOL1 };
#endif				/* EOL2 */
    write(STDERRFD, s, length(s));
    write(STDERRFD, eol, sizeof(eol));
}

void
wrtint(n)
int n;
{
#if EOL2
    static char eol[2] = { EOL1, EOL2 };

#else				/* EOL2 */
    static char eol[1] = { EOL1 };
#endif				/* EOL2 */
    /*
       char str[16];
       itoa(n,str);
       write( STDOUTFD, str, length(str) );
       write( STDOUTFD,  eol, sizeof(eol) );
     */
}

/*
        wrtmsg( s )

        Write message to standard output, and append end-of-line.
*/
void
wrtmsg(s)
char *s;
{
#if EOL2
    static char eol[2] = { EOL1, EOL2 };

#else				/* EOL2 */
    static char eol[1] = { EOL1 };
#endif				/* EOL2 */
    write(STDOUTFD, s, length(s));
    write(STDOUTFD, eol, sizeof(eol));
}

/*
   Setup output file.
   Issue brag message if approriate

   This rather clumsy routine was placed here because of sequencing
   concerns -- it can't be called with a save file until spitflag
   has been reloaded.
 */
void
setout()
{
    Enter("setout");
    /*
       Brag prior to calling swcoup
     */
    zysdc();

    /*
       Switch to proper output file.
     */
    swcoup(outptr);

    /*
       Determine if standard output is a tty or not, and if it is be sure to
       /   inform compiler and turn off header.
     */
    spitflag &= ~PRTICH;
    if (testty(getprfd()) == 0) {
	lnsppage = 0;
	spitflag |= (PRTICH | NOHEDR);
    }
    Exit("setout");
}
