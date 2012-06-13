/*
/	File:  SYSSTDIO.C	Version:  01.09
/	---------------------------------------
/
/	Contents:	Function zyspr
/			Function zysrd
/
/	01.04	Removed usage of inpateof.  From disk files, OK to read
/		from file again and get EOF.  From console, OK to request
/		another line after EOF, if that is what user wants.  Makes
/		behavior of INPUT similar to behavior of TERMINAL.
/		MBE 12/24/87
/
/	01.05	Added getprfd() to provide current standard output fd to
/		osint.
/
/	01.06	Added sfn to report source file name to compiler.  Definition of sysrd EXIT 1
/		case expanded to handle both EOF and reporting of source file change.
/		Use of first_record expanded to provide initial source file name to compiler.
/
/	01.07	Added input/output record sizes to ioblocks.  Note, as a
/		result of changes in the compiler at ASG11, it is now
/		possible for zyspr() to be called from zysou().  Previously,
/		writes to OUTPUT were going through the PRTST logic, wasting
/		time using the print buffer, and limiting the record length
/		to the listing page width.  Instead, all output assignments
/		go to zysou(), which now uses the FCB info in WA to decide
/		if it is a special file (OUTPUT/TERMINAL), or a normal
/		file.
/
/	01.08	Add end of line characters to IOBLKs.  Add clrbuf().
/
/	01.09	New oswrite calling sequence.  01-Feb-93.
*/
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */

/*
/   sysstdio module
/
/   The sysstdio module contains two functions, zyspr and zysrd, that
/   perform standard input and output for the spitbol compiler.
/
/   During compilation zysrd is called to read lines of the program.  During
/   program execution zysrd is called to read input via input associated
/   variable INPUT.
/
/   During compilation zyspr is called to print header lines, the program
/   listing, and compilation statistics.  During program execution zyspr
/   is called to print output via output associated variable OUTPUT.
/
/   After program execution zyspr is called to print execution statistics
/   and the variable post-mortem dump if requested.
*/

#include "port.h"

void stdioinit()
{
	inpiob.bfb = MP_OFF(pINPBUF, struct bfblk NEAR *);
}

/*
/   zyspr - print to standard output file
/
/   zyspr prints a line to the standard output file.  Note that the
/   standard output is switched between two files.  See function swcoup
/   for details.
/
/   Parameters:
/	xr	pointer to SCBLK containing string to print
/	wa	length of string
/   Returns:
/	Nothing
/   Exits:
/	1	failure
*/

zyspr()

{
/*
/	Do writes in line mode.
*/
	if ( oswrite( 1, oupiob.len, WA(word), &oupiob, XR( struct scblk * ) ) < 0 )
		return  EXIT_1;

	return NORMAL_RETURN;
}


/*
/   zysrd - read from standard input
/
/   zysrd reads a line from standard input.  The file currently available
/   for reading is setup by function swcinp.
/
/   IMPORTANT:  the spitbol compiler will attempt to read past EOF, so we
/   must set our own internal "at EOF" flag and keep returning EOF until
/   it is accepted.
/
/   Parameters:
/	xr	pointer to SCBLK to receive line
/	wc	length of string area in SCBLK
/   Returns:
/	Nothing
/   Exits:
/	1	EOF or switch to new file.  (Returns length=0 in SCBLK if EOF, else
/       	new file name in SCBLK and non-zero length.)
*/

zysrd()

{

	word	length;
	struct scblk *scb = XR( struct scblk * );

	if (provide_name)
	{
		/* Provide compiler with name of source file, if desired. */
		provide_name = 0;
		if (sfn && sfn[0])
		{
			cpys2sc( sfn, scb, WC(word));
			return  EXIT_1;
		}
	}


/*
/	Read a line from standard input.  If EOF on current standard input
/	file, call function swcinp to switch to the next file, if any, except
/       if within an include file.
*/
	while ( (length = osread( 1, WC(word), &inpiob, scb )) < 0 )
	{
		if ( nesting || swcinp( inpcnt, inpptr ) < 0 )
		{
			/* EOF */
			scb->len = 0;
			return  EXIT_1;
		}
		else
		{
			/* Successful switch, report new file name if still in compilation phase */
			if (!executing && sfn && sfn[0])
			{
				cpys2sc( sfn, scb, WC(word));
				return  EXIT_1;
			}
		}

	}
	scb->len = length;	/* line read, so set line length	*/

#if UNIX
/*
/	Special check for '#!' invocation.
*/
	if ( first_record  &&  inpptr )
	{
		first_record = 0;
		if ( scb->str[0] == '#'  &&  scb->str[1] == '!' )
		{
			cmdcnt = gblargc - inpcnt + 1;
			inpcnt = 1;
			while( (length=osread(1, WC(word), &inpiob, scb)) < 0 )
			{
				if ( swcinp( inpcnt, inpptr ) < 0 )
				{
					scb->len = 0;
					return  EXIT_1;
				}
				/* Successful switch, report new file name */
				if (sfn && sfn[0])
				{
					cpys2sc( sfn, scb, WC(word));
					return  EXIT_1;
				}

			}
			scb->len = length;
		}
	}
#endif					/* UNIX */

	return NORMAL_RETURN;
}

/*
 /    Return file descriptor for standard input channel.
*/

int getrdfd( )
{
	return inpiob.fdn;
}

/*
 /    Return file descriptor for standard output channel.
*/

int getprfd( )
{
	return oupiob.fdn;
}


/*
 /    Return iob for standard input channel.
*/

struct ioblk *
getrdiob()
{
	return &inpiob;
}


#if WINNT
/*
 /    Return iob for standard output channel.
*/

struct ioblk *
getpriob()
{
	return &oupiob;
}
#endif               /* WINNT */


/*
 * CLRBUF - clear input buffer
 */
void clrbuf()
{
	register struct bfblk *bfptr;

	bfptr = MK_MP(inpiob.bfb,struct bfblk *);
	bfptr->next = bfptr->fill = 0;
   bfptr->offset = (FILEPOS)0;
   bfptr->curpos = (FILEPOS)-1;
	inpiob.flg2 &= ~IO_LF;
}

/*
 *  OUPEOF - advance output file to EOF
 */
void oupeof()
{
	doset(&oupiob, 0L, 2);
}

#if !USEFD0FD1
/*
/    SETPRFD/SETRDFD  are used on systems that do not support the
/    dup() system call.  On these systems, it is impossible to read/write
/    through fd 0 and 1 at all times.  Disk files must be accessed through
/    normal file descriptors.  These functions inform sysrd and syspr of
/    the descriptor currently in use.
*/

void setprfd( fd )
int	fd;
{
	oupiob.fdn = fd;
}

void setrdfd( fd )
int	fd;
{
	inpiob.fdn = fd;
	clrbuf();
}
#endif					/* !USEFD0FD1 */

