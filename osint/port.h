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
/   file:  port.h   (spitbol)   version:  01.11
/   ---------------------------------------------------
/
/   this header file contains manifest constants that describe system
/   dependencies.  many of these values will be changed when porting
/   the os interface to another machine/operating system.
*/
#include "systype.h"

/*
/	turn off system-specific features unless specifically called for
/	in systype.h.
*/

#ifndef	altcomp
#define	altcomp		0	/* no alternate string comparison */
#endif

#ifndef datecheck
#define datecheck   0   /* no check for expiration date */
#endif

#ifndef engine
#define engine		0	/* not building engine version */
#endif

#ifndef execsave
#define execsave	0	/* executable modules via save files */
#endif

#ifndef	extfun
#define extfun		0	/* no external functions */
#endif

#ifndef	flthdwr
#define	flthdwr		0	/* floating point hardware not present */
#endif

#ifndef	host386
#define host386		0	/* no 80386 host functions */
#endif

#ifndef	mathhdwr
#define	mathhdwr	0	/* extended math hardware not present */
#endif

#ifndef	runtime
#define	runtime		0	/* not making runtime version */
#endif

#ifndef	savefile
#define	savefile	0	/* can't create save files */
#endif

#ifndef setreal
#define setreal     0   /* don't use reals for set()  */
#endif

#ifndef	usequit
#define	usequit		0	/* use quit() to report errors instead of wrterr */
#endif

/*
 * 	turn on system-specific features unless specifically turned off
 * 	in systype.h
 */
#ifndef direct
#define	direct		1	/* access minimal data directly */
#endif

#ifndef execfile
#define	execfile	1	/* create executable modules */
#endif

#ifndef	float
#define	float		1	/* include floating point code */
#endif

#ifndef io
#define	io			1	/* include input/output code */
#endif

#ifndef	math
#define	math		1	/* include extended math (i.e., trig) code */
#endif

#ifndef pipes
#define	pipes		1	/* include pipe code */
#endif

#ifndef	polling
#define	polling		1	/* enable polling of operating system */
#endif

#ifndef prototypes
#define	prototypes	1	/* assume compiler can handle prototypes */
#endif

#ifndef usefd0fd1
#define	usefd0fd1	1	/* use file descriptor 0 & 1 for stdio	*/
#endif

/*
 *  other defaulted values that may be overridden in systype.h
 */
#ifndef intbits
#define intbits		32			/* assume int will be 32 bits */
#define maxint		0x7fffffffl	/* maximum positive value in int */
#endif
#ifndef wordbits
#define wordbits	32			/* assume word will be 32 bits */
#define maxposword	0x7fffffffl	/* maximum positive value in word */
#endif
#ifndef iabits
#define iabits      32          /* integer accumulator (ia) width */
#endif



/*
 *  if not defined in systype.h, disable it here.
 */
/* compiler defs */
#ifndef bcc32
#define bcc32		0			/* 32-bit borland c++ 4.x */
#endif
#ifndef vcc
#define vcc         0           /* 32-bit microsoft visual c++ */
#endif
#ifndef gcci32
#define gcci32      0
#endif
#ifndef gcci64
#define gcci64      0
#endif
#ifndef rs6
#define rs6			0
#endif
#ifndef sun4
#define sun4		0
#endif

/* operating system defs */
#ifndef aix3
#define aix3		0
#endif
#ifndef aix4
#define aix4		0
#endif
#ifndef bsd43
#define bsd43		0
#endif
#ifndef linux
#define linux       0
#endif
#ifndef solaris
#define solaris		0
#endif
#ifndef winnt
#define winnt  		0
#endif

#if winnt | gcci32
#define sysversion 0
#endif
#if sun4
#define sysversion 3
#endif
#if aix3 | aix4
#define sysversion 6
#endif
#if gcci64
#define sysversion 7
#endif
#ifndef sysversion
#define sysversion 255
#endif

#if execsave			/* execsave requires execfile & savefile on */
#undef execfile
#undef savefile
#define execfile	1
#define savefile	1
#endif

/* define how the errors and phrases arrays will be accessed (see sysem.c) */
#ifndef errdist
#define errdist
#endif

#ifndef far
#define far
#define readfar read
#define writefar write
#endif

#ifdef near
#define __near__ 1
#else
#define near
#define __near__ 0
#endif

#define gccx86 (gcci32 | gcci64)
#define aix (aix3 | aix4)

#define sun sun4

/*#define unix (aix | bsd43 | linux | solaris)*/

typedef int   word;
typedef unsigned int uword;

/* size of integer accumulator */
#if iabits==32
typedef long iatype;
#elif iabits==64
typedef long long iatype;
#endif

/*
/   define the default end of line characters.  use unix definitions
/   as the default.  override in systype.h.
*/
#ifndef eol1
#define eol1	'\n'
#endif

#ifndef eol2
#define eol2	0
#endif

/*
 * define the data type returned by a call to signal()
 */
#if unix
#define sigtype void
#else
#define	sigtype int
#endif

/*
/   the following manifest constants define the page size used when the
/   compiler produces a source listing.
/
/   page_depth		number of lines to print on a page
/   page_width		number of characters to print on a line
/					also the default record length for output, terminal
*/
#define page_depth  60
#define page_width	120

/*
/	the following constant defines the size of the code word for
/	lzw compression of a save file.  see file compress.c.
*/
#if wordbits == 16
#define lzwbits 10
#else
#define lzwbits 12
#endif

/*
/   the following manifest contants describe the constraints on the heap
/   managed by the spitbol compiler.
/
/   all values can be overriden via command line options.
/
/   chunk_size		the size of an allocation unit (chunk) used to
/                   create the heap.  defined in words!
/
/   chunk_b_size	chunk_size in bytes.
/
/   heap_size		the maximum size that spitbol's heap (dynamic area)
/                   can become.  defined in words!
/
/   object_size		the maximum size of any object created in the heap.
/                   defined in words!
/	note: it was necessary to reduce this value from 8m to 1m  because
/   some dpmi hosts (like 386max) use much smaller
/	starting address for data section.  4mb seems to be a good lowest
/	common denominator so that save files can move between all the
/	different dpmi platforms.
*/

#if linux | winnt | aix | solaris
#define chunk_size	32768
#define chunk_b_size	(chunk_size * sizeof(word))
#define heap_size	16777216	/* 16mwords = 64mbytes */
#if sun4 | linux | winnt | aix
#define object_size	1048576		/* 1 mword = 4 mbytes */
#else         /* sun4 */
#define object_size	16384
#endif
#endif

#if sun
#define text_start      8192
#endif

/*
 *  define the maximum nesting allowed of include files
 */
#define	include_depth	9


/*
 *  define the standard file ids
 */
#ifndef stdinfd
#define stdinfd 0
#endif
#ifndef stdoutfd
#define stdoutfd 1
#endif
#ifndef stderrfd
#define stderrfd 2
#endif

/*
 *   define number of spitbol statements to be executed between
 *   interface polling intervals.  only used if polling is 1.
 *   unix systems can get away with an infinite polling interval,
 *   because their interrupts are asynchronous, and do not require
 *   true polling.
 */
#ifndef pollcount
#if unix
#define pollcount maxposword
#else         /* unix */
#define pollcount 2500
#endif          /* unix */
#endif					/* pollcount */


/*
 *   define params macro to use or ignore function prototypes.
 */
#if prototypes
#define params(a) a
#else
#define params(a) ()
#endif


/*
/   the following manifest contant describes the constraints on the
/   run-time stack.
/
/   the value can be overriden via command line option.
/
/   stack_size		the maximum size of the run-time stack.  any attempt
/                   to make the stack larger results in a stack overflow
/                   error.  defined in bytes!
*/
#if linux | winnt | aix | solaris
#define stack_size  (0x100000)      /* set to 1mb 6/28/09 */
#endif


/*
/   the following manifest constant defines the location of the host file
/   which contains a one line description of the system environment under
/   which spitbol is running.
/
/   host_file		pathname for host text file used by function syshs
*/
#define host_file	"/usr/lib/spithost"

/*
/   the following manifest constant defines the names the files created
/   by the exit(3) and exit(-3) function.
/
/   aout_file		pathname for load module created by sysxi
/   save_file		pathname for save file created by sysxi
*/
#define save_file	"a.spx"
#if winnt
#define aout_file	"a.exe"
#else
#define aout_file	"a.out"
#endif

/*
/ psep is the separator between multiple paths.
/ fsep is the separator between directories in a path.
/ ext is separator between name and extension.
/ compext is extension for source files.
/ efnext is extension for external functions.
/ runext is extension for save files.
/ binext is extension for load modules
*/

#if unix
#define psep  ':'
#define psep2 ' '
#define fsep '/'
#endif

#if winnt
#define psep ';'
#define fsep '\\'
#define fsep2 '/'
#endif          /* winnt */

#define ext '.'
#if winnt
#define	binext ".exe"
#else
#define	binext ".out"
#endif
#define compext ".spt"
#define efnext ".slf"
#define listext ".lst"
#define runext ".spx"
#define spitfilepath  "snolib"  /* path for include and external files */

/*
/   the following manifest constant determines the maximum number of
/   files that can be open at a time.
/
/   open_files		the maximum number of files that can be open at
/			a time.  used by function ospipe to close files
/			given by a parent process to a child process.
*/
#define open_files	32

/*
/   the following manifest constants determines the size of the temporary
/   scblks defined by the interface.
/
/   tscblk_length	the maximum length of a string that can be stored
/                   in structure 'tscblk'.  'tscblk' is defined in
/                   file inter.s.
/
/   id2blk_length	the maximum length of a string that can be stored
/                   in structure 'id2blk'.  'id2blk' is defined in
/                   inter.c.  id2blk_length should be long enough
/                   to hold the computer name type string (htype)
/                   plus the date/time and a few blanks (typically
/                   20 characters).  it should also be a multiple of
/                   the word size.
/
*/
#ifndef tscblk_length
#define tscblk_length	512
#endif
#define id2blk_length	52

/*
/   the following manifest constants determine the default environment
/   variable name for the shell and it
/
/   shell_env_name	the name under which then shell path is stored
/                   in the environment
/
/   shell_path		a default shell to use in event one cannot be
/                   located in the environment
*/

#if winnt             /* winnt */
extern char borland32rtm;             /* true if using dos extender */
extern char iswin95;                  /* true if running under winnt */
#define shell_env_name  "comspec"
#define shell_path  ((borland32rtm || iswin95) ? "command.com" : "cmd.exe")
#else                   /* winnt */
#define shell_env_name	"shell"
#define shell_path      "/bin/sh"
#endif          /* winnt */

/*
/   compiler flags (see compiler listing for more details):
/
/   errors	send errors to terminal
/   prtich	terminal is standard output file
/   nolist	suppress compilation listing
/   nocmps	suppress compilation statistics
/   noexcs	suppress execution statistics
/   lnglst	generate long listing (with page ejects)
/   noexec	suppress program execution
/   trmnal	support terminal i/o association
/   stdlst	standard listing (intermediate)
/   nohder	suppress spitbol compiler header
/   printc      list control cards
/   wrtexe	write executable module after compilation
/   casfld      fold upper and lower case names
/   nofail	no fail mode
/
/   dflt_flags	reasonable defaults for un*x environment
*/

#define	errors		0x00000001l
#define prtich		0x00000002l
#define nolist		0x00000004l
#define nocmps		0x00000008l
#define noexcs		0x00000010l
#define lnglst		0x00000020l
#define noexec		0x00000040l
#define trmnal		0x00000080l
#define stdlst		0x00000100l
#define nohedr		0x00000200l
#define printc		0x00000400l
#define noerro		0x00000800l
#define casfld		0x00001000l
#define nofail		0x00002000l
#define wrtexe		0x00004000l
#define wrtsav		0x00008000l

#define nobrag		0x02000000l	/*	no signon header when loading save file */

#define dflt_flags  (errors+prtich+nolist+nocmps+noexcs+trmnal+printc+casfld+noerro)

#define _optlink

#define const

#include "osint.h"

#ifdef privateblocks
#if winnt | sun4 | aix | linux
#include "extern32.h"
#endif          /* winnt | sun4 */
#else					/* privateblocks */
#include "spitblks.h"
#include "spitio.h"
#endif					/* privateblocks */


#include "globals.h"
#include "sproto.h"

