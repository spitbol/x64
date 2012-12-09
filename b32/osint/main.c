/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

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
/	File:  MAIN.C		Version:  01.00
/	---------------------------------------
/
/	Contents:	Function main
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
/	HISTORY
/
/  V1.00 04-Jun-92 Split off from OSINT as a front-end module.
/  V1.01 30-Dec-96 Call swcinp after reloading SPX file.
/  V1.02 18-Mar-00 Don't interpret parameters following .spx on command
/                  line as file names.
*/
#define GLOBALS			/* global variables will be defined in this module */
#include "port.h"
#include <stdio.h>
#include <stdio.h>

#ifdef DEBUG
#undef DEBUG			/* Change simple -DDEBUG on command line to -DDEBUG=1 */
#define DEBUG 1
#else
#define DEBUG 0
#endif

void setout Params(( void ));

main( argc, argv )
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
            __exit(1);
        close(i);

        /* set up things that normally would be retained in the
         * a Unix exec file.
         */
#if USEFD0FD1
        originp = dup(0);
#endif					/* USEFD0FD1 */
        readshell0 = 0;
#else					/* EXECSAVE */
    /*
    /   If this is a restart of this program from a load module, set things
    /   up for a restart.  Transfer control to function restart which actually
    /   resumes program execution.
    */
    if ( lmodstk ) {
        if ( brk( (char *) topmem ) < 0 ) { /* restore topmem to its prior state	*/
            wrterr( "Insufficient memory to load." );
            __exit(1);
        }
#endif					/* EXECSAVE */

        cmdcnt = 1;       /* allow access to command line args  */
        inpptr = 0;				/* no compilation input files		*/
        inpcnt = 0;				/* ditto				*/
        outptr = 0;				/* no compilation output file		*/
        pathptr = (char *)-1L;	/* include paths unknown 	*/
        clrbuf();				/* no chars left in std input buffer	*/
        sfn = 0;
#if FLOAT
        hasfpu = checkfpu();	/* check for floating point hardware */
#endif					/* FLOAT */
#if (SUN4 | LINUX) & !EXECSAVE
        heapmove();				/* move the heap up					*/
        malloc_empty();			/* mark the malloc region as empty	*/
#endif					/* SUN4 | LINUX */
        zysdc();							/* Brag if necessary */
        restart( (char *)0L, lowsp );       /* call restart to continue execution */
    }
#endif					/* EXECFILE */

    /*
     * 	Process command line arguments
     */
    inpptr = getargs(argc, argv);

    if ( inpptr )
        sfn = *inpptr;		/* pointer to first file name */
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

#if FLOAT
    /*
     * test if floating point hardware present
     */
    hasfpu = checkfpu();
#endif					/* FLOAT */

#if SAVEFILE | EXECSAVE
    switch (getsave(getrdfd())) {
    case 1:					/* save file loaded */
        inpcnt = 0;               /* v1.02 no more cmd line files */
        swcinp(inpcnt, inpptr );  /* v1.01 */
        restart( (char *)0L, lowsp );

    case 0:					/* not a save file */
#if RUNTIME
        wrterr("SPITBOL save (.spx) file only!");
#else					/* RUNTIME */
        break;
#endif					/* RUNTIME */

    case -1:				/* error loading save file */
        __exit(1);
    }
#endif					/* SAVEFILE | EXECSAVE */

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
    /   All compiler registers are initially zero, except for XL and XR which
    /   are set to top and bottom of heap.
    */
    SET_CP( 0 );
    SET_IA( 0 );
    SET_WA( 0 );
    SET_WB( 0 );
    SET_WC( 0 );
    SET_XR( basemem );
    SET_XL( topmem - sizeof(word) );

    /*
    /   Startup compiler.
    */
/*	fprintf(stderr,"calling startup\n");*/
    startup( (char *)0L, lowsp );
#endif					/* !RUNTIME */

    /*
    /   Never returns. exit is via exit().
    */
}



/*
/	wrterr( s )
/
/	Write message to standard error, and append end-of-line.
*/
void wrterr(s)
char	*s;
{
#if EOL2
    static char eol[2] = {EOL1,EOL2};

#else					/* EOL2 */
    static char eol[1] = {EOL1};
#endif					/* EOL2 */
    write( STDERRFD, s, length(s) );
    write( STDERRFD,  eol, sizeof(eol) );
}

void wrtint(n)
int	n;
{
#if EOL2
    static char eol[2] = {EOL1,EOL2};

#else					/* EOL2 */
    static char eol[1] = {EOL1};
#endif					/* EOL2 */
    /*
    	char str[16];
    	itoa(n,str);
    	write( STDOUTFD, str, length(str) );
    	write( STDOUTFD,  eol, sizeof(eol) );
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
#if EOL2
    static char eol[2] = {EOL1,EOL2};

#else					/* EOL2 */
    static char eol[1] = {EOL1};
#endif					/* EOL2 */
    write( STDOUTFD, s, length(s) );
    write( STDOUTFD,  eol, sizeof(eol) );
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
int at_xl;
int at_xr;
int at_xs;
int at_wa;
int at_wb;
int at_wc;
int at_w0;
int at_cp;
int at_zz;

int last_xl;
int last_xr;
int last_xs;
int last_wa;
int last_wb;
int last_wc;
int last_w0;
int last_cp;

int AT_CALLS = 0;

#define DAVE
#ifdef DAVE
char * AT_DESC;
extern char at1_0;
void prtnl() {
	fprintf(stderr,"\n");
}
void prtval(int reg) {
	if (reg < 100000 && reg >= 0)
		fprintf(stderr," %8d ", reg);
	else
		/*fprintf(stderr," %8xx", reg);*/
		fprintf(stderr," ---------", reg);
}
void prtreg(char * name, int val) {
	prtval(val);
	fprintf(stderr," %s",name);
}
void prtdif(char* name, int old, int new, int listed)
{
	/* print old and new values of named register */
	fprintf(stderr,"%s:", name);
	prtval(old); fprintf(stderr," -> "); prtval(new);
	prtnl();
}

unsigned long at_off;
int zzz_calls=0;
/*void at_(long at_ip,char * at_desc) {*/
void zzz() {

	int changed = 0;
	int listed = 0;

	if(at_zz>0) zzz_calls++;
	fprintf(stderr, "zzz %d %d\n",zzz_calls, at_zz);

	/* print registers that have changed since last statement */

	/* see if any have changed. */
	if (at_xl != last_xl)  changed += 1;
	if (at_xr != last_xr)  changed += 1;
	if (at_xs != last_xs)  changed += 1;
	if (at_cp != last_cp)  changed += 1;
	if (at_wa != last_wa)  changed += 1;
	if (at_wb != last_wb)  changed += 1;
	if (at_wc != last_wc)  changed += 1;
	if (at_w0 != last_w0)  changed += 1;

	if (changed) {
/* marked changed Minimal registers with "!" to make it easy to search
   backward for last statement that changed a register. */
		prtnl();
		if (at_xl != last_xl)
			{ prtdif("xl.esi", last_xl, at_xl, listed); listed += 1; }
		if (at_xr != last_xr)
			{ prtdif("xr.edi", last_xr, at_xr, listed); listed += 1; }
		if (at_xs != last_xs)
			{ prtdif("xs.esp", last_xs, at_xs, listed); listed += 1; }
		if (at_cp != last_cp)
			{ prtdif("cp.ebp", last_cp, at_cp, listed); listed += 1; }
		if (at_wa != last_wa)
			{ prtdif("wa.ecx", last_wa, at_wa, listed); listed += 1; }
		if (at_wb != last_wb)
			{ prtdif("wb.ebx", last_wb, at_wb, listed); listed += 1; }
		if (at_wc != last_wc)
			{ prtdif("wc.edx", last_wc, at_wc, listed); listed += 1; }
		if (at_w0 != last_w0)
			{ prtdif("w0.eax", last_w0, at_w0, listed); listed += 1; }
		prtnl();
	}
	AT_CALLS++; /* count number of calls */

	if (AT_CALLS % 3 == 1) {
		/* print register values before the statement was executed */
		prtreg("xl.esi", at_xl);
		prtreg("xr.edi", at_xr);
		prtreg("xs.esp", at_xs);
		/* cp is last on line, so don't print it zero */
		if (at_cp) prtreg("cp.ebp", at_cp);
		fprintf(stderr, "\n");
		prtreg("wa.ecx", at_wa);
		prtreg("wb.ebx", at_wb);
		prtreg("wc.edx", at_wc);
		prtreg("w0.eax", at_w0);
		fprintf(stderr, "\n");
	}
	/* display instruction pointer and description of current statement. */
/*	fprintf(stderr, "\n%8xx %s\n", at_ip, p);*/

	/* save current register contents. */
	last_xl = at_xl; last_xr = at_xr; last_xs = at_xs; last_cp = at_cp;

	last_wa = at_wa; last_wb = at_wb; last_wc = at_wc; last_w0 = at_w0;

}
void AT_SHORT() {
    fprintf(stderr,"Enter short AT\n");
}
void strt()
{
	fprintf(stderr, "start minimal execution\n");
}
void strt1()
{
	fprintf(stderr, "start1 minimal execution\n");
}
void at_note() {
	fprintf(stderr, "at_note\n");
}
void at_note1() {
	fprintf(stderr, "at_note1\n");
}
void at_note2() {
	fprintf(stderr, "at_note2\n");
}
void at_note3(int num) {
	fprintf(stderr, "at_note3 %d\n",num);
}
#endif
void restart(char *p, char * q) {
 fprintf(stderr,"restart not supported\n");
}
