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
    sioarg( ioflg,ioptr,scptr )

    sioarg() scans any arguments after the filename in the passed SCBLK and
    sets appropriate values in the passed ioblk.

    Parameters:
        ioflg   0 - input association/ 3 - output association
        ioptr   pointer to IOBLK representing file
        scptr   pointer to SCBLK containing filename and args
    Returns:
        0 - options successfully processed / -1 - option error
    Side Effects:
        Modifies contents of passed IOBLK (ioptr).
*/

#include "port.h"
#include "globals.ext"

/*  uppercase( word )
 *
 *  restricted upper case function.  Only acts on 'a' through 'z'.
 */
word
uppercase (c)
     word c;
{
  if (c >= 'a' && c <= 'z')
    c += 'A' - 'a';
  return c;
}

int
sioarg (ioflg, ioptr, scptr)
     int ioflg;
     struct ioblk *ioptr;
     struct scblk *scptr;

{
  int lastdash = 0;
  word cnt, v, share;
  char ch, *cp;

  cp = scptr->str;

  /*
     /   Initialize the default values for an I/O association.  Note that
     /   some of the fields are used here for purposes other than their
     /   normal uses.
     /
     /   typ     arguments found flag:  0 - no args / 1 - args found
     /           (when no args are present assume that this association has
     /           same properties as previous association for THIS file.)
     /   len     record mode and length:  >0 line mode / <0 raw mode
     /   pid     buffer size
     / fdn shell or external function provided file descriptor (IO_SYS flag)
     /   flg1,2  IO_INP or IO_OUP as appropriate and other flags
   */
  ioptr->typ = 0;		/* no args seen yet             */
  ioptr->fdn = 0;		/* no shell provided fd         */
  ioptr->pid = IOBUFSIZ;	/* buffer size          */
  ioptr->eol1 = EOL1;		/* default end of line char 1   */
  ioptr->eol2 = EOL2;		/* default end of line char 2   */
  if (ioflg)
    {				/* output */
      ioptr->len = maxsize;	/* line mode record len */
      ioptr->flg1 = IO_OUP;
      ioptr->share = IO_DENY_READWRITE | IO_PRIVATE;
      ioptr->action = IO_REPLACE_IF_EXISTS | IO_CREATE_IF_NOT_EXIST;
    }
  else
    {				/* input */
      ioptr->len = IRECSIZ;	/* line mode record len */
      ioptr->flg1 = IO_INP;
      ioptr->share = IO_DENY_WRITE | IO_PRIVATE;
      ioptr->action = IO_OPEN_IF_EXISTS;
    }
  ioptr->flg2 = 0;
  /*
     /   If lenfnm() fails so shall we.
   */
  if ((cnt = lenfnm (scptr)) < 0)
    return -1;

  /*
     /   One iteration per character.  Note that scanning an integer causes
     /   more than one character to be handled in an iteration.
   */
  while (cnt < scptr->len)
    {
      ch = uppercase (*(cp + cnt++));	/* get next character           */
      switch (ch)
	{
	case ' ':
	case '\t':
	case ',':
	case '[':
	case ']':
	  lastdash = 0;
	  continue;

	case '-':
	  if (lastdash != 0)	/* "--" is illegal      */
	    return (-1);
	  else
	    {
	      lastdash = 1;	/* saw an '-'           */
	      continue;
	    }

	  /*
	     /   A - append output at end of existing file
	   */
	case 'A':
	  ioptr->flg1 |= IO_APP;
	  ioptr->action &= ~IO_REPLACE_IF_EXISTS;
	  ioptr->action |= IO_CREATE_IF_NOT_EXIST | IO_OPEN_IF_EXISTS;
	  break;

	  /*
	     /   B - set size of I/O buffer (stored in pid field).
	   */
	case 'B':
	  v = scnint (cp + cnt, scptr->len - cnt, &cnt);
	  if (v > 0 &&
	      ((v + sizeof (word) - 1) & ~(sizeof (word) - 1)) <=
	      (maxsize - BFSIZE))
	    ioptr->pid = v;
	  else
	    return -1;
	  break;

	  /*
	     /   C - set raw mode, character at a time access.
	   */
	case 'C':
	  ioptr->len = -1;
	  break;

	  /*
	     /   E- ignore end-of-text character (DOS only)
	   */
	case 'E':
	  ioptr->flg1 |= IO_EOT;
	  break;

	  /*
	     /   F - set file descriptor number (file opened by shell or external func).
	   */
	case 'F':
	  v = scnint (cp + cnt, scptr->len - cnt, &cnt);
	  ioptr->fdn = v;
	  ioptr->flg1 |= (IO_OPN | IO_SYS);
	  if (ioflg && (testty (v) == 0))
	    ioptr->flg1 |= IO_WRC;

#if HOST386
	  /* Test for character input/output to a device */
	  if (ioflg && !coutdev (v))	/* Test for character output */
	    ioptr->flg1 |= IO_COT;
#endif /* HOST386 */


	  break;

	  /*
	     /   I - make file inheritable by any child processes
	   */
	case 'I':
	  ioptr->share &= ~IO_PRIVATE;
	  break;

	  /*
	     /   L - line mode access having max record length v.
	   */
	case 'L':
	  v = scnint (cp + cnt, scptr->len - cnt, &cnt);
	  if (v > 0 && (uword) v <= maxsize)
	    ioptr->len = v;
	  else
	    return -1;
	  break;

	  /*
	     /   M - specify end-of-line character 1.
	   */
	case 'M':
	  /*
	     /   N - specify end-of-line character 2.
	   */
	case 'N':
	  v = scnint (cp + cnt, scptr->len - cnt, &cnt);
	  if (v >= 0 && v <= 255)
	    {
	      if (ch == 'M')
		ioptr->eol1 = v;
	      else
		ioptr->eol2 = v;
	    }
	  else
	    return -1;
	  break;

	  /*
	     /   R - raw mode access of v characters.
	     /   Q - like R, but no echo (quiet) if console input.
	   */
	case 'Q':
	  ioptr->flg2 |= IO_NOE;
	case 'R':
	  v = scnint (cp + cnt, scptr->len - cnt, &cnt);
	  if (v > 0 && v <= (word) maxsize)
	    ioptr->len = -v;
	  else
	    return -1;
	  break;

	  /*
	     /   S - sharing mode:
	     /           -sdn    =       deny none
	     /           -sdr    =       deny read
	     /           -sdw    =       deny write
	     /           -sdrw   =       deny read/write
	   */
	case 'S':
	  ch = uppercase (*(cp + cnt++));	/* get next character           */
	  if (ch != 'D')
	    return -1;
	  ch = uppercase (*(cp + cnt++));	/* get next character           */
	  switch (ch)
	    {
	    case 'N':
	      share = IO_DENY_NONE;
	      break;
	    case 'R':
	      share = IO_DENY_READ;
	      if (uppercase (*(cp + cnt)) == 'W')
		{
		  share = IO_DENY_READWRITE;
		  cnt++;
		}
	      break;
	    case 'W':
	      share = IO_DENY_WRITE;
	      break;
	    default:
	      return -1;
	    }

	  if (cnt >= scptr->len)
	    return -1;
	  ioptr->share = (ioptr->share & ~IO_DENY_MASK) | share;
	  break;

	  /*
	     /   U - update access to file
	   */
	case 'U':
	  ioptr->flg1 |= (IO_INP | IO_OUP);
	  if (ioptr->len == (word) maxsize)
	    ioptr->len = IRECSIZ;	/* limit to input record len */
	  ioptr->action &= ~IO_REPLACE_IF_EXISTS;
	  ioptr->action |= IO_CREATE_IF_NOT_EXIST | IO_OPEN_IF_EXISTS;
	  break;

	  /*
	     /   W - write with no buffering within SPITBOL.
	   */
	case 'W':
	  ioptr->flg1 |= IO_WRC;
	  break;

	  /*
	     /   X - mark file executable
	   */
	case 'X':
	  ioptr->share |= IO_EXECUTABLE;
	  break;

	  /*
	     /   Y - write with no buffering within SPITBOL or within operating system.
	   */
	case 'Y':
	  ioptr->flg1 |= IO_WRC;
	  ioptr->action |= IO_WRITE_THRU;
	  break;

	  /*
	     /   Unknown argument.
	   */
	default:
	  return -1;
	}

      /*
         /   Indicate that an argument was found and processed and
         /   that the last character processed was not a '-'.
       */
      ioptr->typ = 1;		/* processed arg                */
      lastdash = 0;		/* last char not a '-'          */
    }
  /*
     /   Return successful scanning.
   */
  return 0;
}


/*
    scnint( str, len, intptr )

    scnint() scans and converts a decimal number at the front of a string.
    "len" specifies the maximum number of digits that can be scanned.

     Parameters:
        str     pointer to string containing number at front
        len     maximum number of digits to scan
        intptr  pointer to integer to be adjusted by number of digits scanned
     Returns:
        Integer converted
     Side Effects:
        Modifies integer pointed to by intptr.
*/


word
scnint (str, len, intptr)
     char *str;
     word len;
     word *intptr;

{
  REGISTER word i = 0;
  REGISTER word n = 0;
  REGISTER char ch;

  while (i < len)
    {
      ch = str[i++];
      if (ch >= '0' && ch <= '9')
	n = 10 * n + ch - '0';
      else
	{
	  --i;
	  break;
	}
    }
  *intptr += i;
  return n;
}
