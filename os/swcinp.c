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


#include "port.h"

#if UNIX
#include <fcntl.h>
#endif

/*
    swcinp( filecnt, fileptr )

    swcinp() handles the switching of input files whose concatenation
    represents standard input.  After all input is exhausted a -1 is
    returned to indicate EOF.

    If no filenames were specified on the command line, all input is
    read from file descriptor 0 provided by the shell.

    If filenames were specified on the command line all files are read
    in their order of appearance.  A filename consisting of a single hyphen
    '-' represents file descriptor 0 provided by the shell.

    Parameters:
        filecnt number of filename specified on command line
        fileptr array of pointers to character strings (filenames)
    Returns:
        File descriptor to read from (always 0!) or -1 if could not switch
        to a new file.
*/

int
swcinp (filecnt, fileptr)
     int filecnt;
     char **fileptr;

{
  register char *cp;
  register int i;

  static int lastfd = 0;


  /*
     /  If first time through, make a duplicate of
     /  shell's file descriptor 0, so that we can access it later.
   */
  sfn = "stdin";

  if (originp < 0)
    originp = dup (0);

  /*
     /  Process files on command line, if any.
     /  Read file descriptor 0 provided by the shell when a '-'
     /  is encountered as a filename.
   */
  if (curfile < filecnt)
    {
      /*
         /  Point to next entry.  (Bump cmdcnt too!)
       */
      cmdcnt++;
      cp = fileptr[curfile++];

      /*
         /   Close fd 0 so subsequent open or dup will acquire fd 0.
       */
      close (0);
      clrbuf ();
      /*
         /   If next entry is '-' then read file descriptor
         /   0 provided by the shell.
       */
      if (*cp == '-')
	{
	  dup (originp);	/* returns 0 */
	  lastfd = 0;
	  goto swci_exit;
	}

      /*
         /   Attempt to open file for reading.
       */
      sfn = cp;
      for (i = 0;; i++)
	{
	  lastfd = -1;
	  switch (i)
	    {
	    case 0:		/* first pass, no alteration */
	      if ((lastfd = tryopen (cp)) >= 0)
		goto swci_exit;
	      break;
#if !RUNTIME
	    case 1:		/* try with .spt extension */
	      if (!executing && appendext (cp, COMPEXT, namebuf, 0))
		if ((lastfd = tryopen (namebuf)) >= 0)
		  {
		    sfn = namebuf;
		    goto swci_exit;
		  }
	      break;
#endif /* !RUNTIME */

#if SAVEFILE
	    case 2:		/* try with .spx extension */
	      if (!executing && curfile == 1
		  && appendext (cp, RUNEXT, namebuf, 0))
		if ((lastfd = tryopen (namebuf)) >= 0)
		  {
		    sfn = namebuf;
		    goto swci_exit;
		  }
	      break;
#endif /* SAVEFILE */
	    case 3:
	      /*
	         /   Error opening file, so issue a message and exit
	       */
	      write (STDERRFD, "Can't open ", 11);
	      write (STDERRFD, cp, length (cp));
	      wrterr ("");
	      __exit (1);
	    }
	}
    }
  else
    lastfd = -1;		/* ATTEMPT TO FIX PIPE BUG FOR COPPEN 10-FEB-95 */

  sfn = "stdin";

  if (readshell0)
    {
      if (!executing && filecnt)
	{
	  wrterr ("No END statement found in source file(s).");	/* V1.16 */
	  __exit (1);
	}
      close (0);
      clrbuf ();
      dup (originp);		/* returns 0 */
      readshell0 = 0;		/* only do this once */
      lastfd = 0;
    }
  /*
     /  Control comes here after all files specified on the command line
     /  have been read.
     /
     /  FD 0 remains attached to the last file that returned an EOF, and
     /  should continue to return EOFs.
   */
swci_exit:
  return lastfd;
}




/*
        Save the current fd 0, and connect fd 0 to the original one.
        Used before EXIT("cmd") and HOST(1,"cmd")

*/
void
save0 ()
{
  if ((save_fd0 = dup (0)) >= 0)
    {
      close (0);
      clrbuf ();
      dup (originp);
    }
}





/*
        Restore the saved fd 0.
        Used after EXIT("cmd") and HOST(1,"cmd")

*/
void
restore0 ()
{
  if (save_fd0 >= 0)
    {
      close (0);
      clrbuf ();
      dup (save_fd0);
      close (save_fd0);		/* 1.13 for HOST(1,"cmd") */
    }
}




/*
    tryopen - try to open file for swcinp.
    returns -1 if fails, else file descriptor >= 0
*/
int
tryopen (cp)
     char *cp;
{
  int fd;
  if ((fd = spit_open (cp, O_RDONLY, IO_PRIVATE | IO_DENY_WRITE,
		       IO_OPEN_IF_EXISTS)) >= 0)
    {
      return fd;
    }
  return -1;
}





/*
    pathlast()

    Function pathlast returns the a pointer to the last component of a
    path.

    Parameters:
        Pointer to path character string
    Returns:
        Pointer to last component in path character
*/


char *
pathlast (path)
     char *path;

{
  char *cp, c;
  int len;

  /*
     /   Scan the path from right-to-left looking for a slash.  Stop when
     /   the front of the path is reached.
   */
  len = length (path);
  cp = path + len;

  /*
     /   Loop either terminated by finding a slash or hitting the front
     /   of the path.  If found a slash, the last component starts one
     /   position to the right.
   */
  while (len--)
    {
      c = *--cp;
      if (c == FSEP
	)
	{
	  ++cp;
	  break;
	}
    }
  return cp;
}

#if !(RUNTIME)
/*
 *  appendext - append extension to pathname if possible.
 *
 *      Parameters:
 *         path   - path name to append to.
 *         ext    - extension to append
 *         result - result buffer
 *         force  - 1 for replace existing extension, if any, 0 to fail if
 *                  extension already present on path.
 *      Returns:
 *         >0  - Success, length of name
 *         0   - Failure
 */
int
appendext (path, ext, result, force)
     char *path, *ext, *result;
     int force;
{
  register char *p, *q, *r;

  p = result;
  q = pathlast (path);
  r = (char *) 0;
  do
    {
      if (path >= q && *path == EXT)
	r = p;
    }
  while ((*p++ = *path++) != 0);

  p--;
  if (r != (char *) 0)
    {
      if (force)
	p = r;			/* copy over old extension */
      else
	return 0;		/* no force but extension present */
    }

  p = mystrcpy (p, ext);
  return p - result;
}
#endif /* !(RUNTIME) */

/*
 * mystrcpy(p,q)  - copy string q to string p.  Return pointer to '\0' in p;
 *
 * Note that this definition is NOT the same as standard strcpy.
 */
char *
mystrcpy (p, q)
     register char *p, *q;
{
  while ((*p++ = *q++) != 0)
    ;
  return p - 1;
}


/*
        Return length of string argument.
        Identical to C strlen function.
*/
int
length (cp)
     char *cp;
{
  register char *p = cp;
  while (*p++)
    ;
  return p - cp - 1;
}


int
mystrncpy (p, q, i)
     register char *p, *q;
     int i;
{
  register int j = i;
  while (j--)
    *p++ = *q++;
  return i;
}
