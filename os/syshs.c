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
        zyshs - host specific functions

        zyshs is the catch-all function in the interface.  Any actions that
        are host specific should be placed here.

        zyshs determines what function to preformed by examining the value
        of argument 1.  Current functions:

        HOST()
                returns the host string identifying the host environment

        HOST( 0 )
                returns -u argument from command line

        HOST( 1, "command" )
                executes 2nd argument as a Unix command

        HOST( 2, n )
                returns command line argument "n"

        HOST( 3 )
                returns the command count

        HOST( 4, "v" )
                returns the value of environment variable "v"

        Other HOST functions may be provided by system specific modules.

        Parameters:
            WA - argument 1
            XL - argument 2
            XR - argument 3
            WB - argument 4
            WC - argument 5
        Returns:
            See exits
        Exits:
            1 - erroneous argument
            2 - execution error
            3 - pointer to SCBLK or 0 in XL
            4 - return NULL string
            5 - return result in XR
            6 - cause statement failure
            7 - return string in XL, length in WA (may be 0)
            8 - return copy of result in XR
*/

#include "port.h"

#if !WINNT
extern uword lowxs;
#endif

/*
 *  checkstr - check if scblk is a valid string.  Returns 1 if so, else 0.
 */
int
checkstr (scp)
     struct scblk *scp;
{
  return scp != (struct scblk *) 0L &&
    scp->typ == type_scl && scp->len < TSCBLK_LENGTH;
}

/*  check2str - check first two argument strings in XL, XR.
 *
 * Returns 1 if both OK, else 0.
 */
int
check2str ()
{
  return checkstr (XL (struct scblk *)) && checkstr (XR (struct scblk *));
}


/*
 *  savestr - convert an scblk to a valid C string.  Returns pointer to
 *              start of string, or 0 if fail.  The char replaced by the
 *              '\0' terminator is returned in *cp.
 */
char *
savestr (scp, cp)
     struct scblk *scp;
     char *cp;
{
  *cp = scp->str[scp->len];
  scp->str[scp->len] = '\0';
  return scp->str;
}

/*
 *  save2str - convert first two argument strings in XL, XR.
 */
void
save2str (s1p, s2p)
     char **s1p, **s2p;
{
  *s1p = savestr (XL (struct scblk *), &savexl);
  *s2p = savestr (XR (struct scblk *), &savexr);
}

/*
 *  getstring - verify and convert an scblk to a valid C string.
 *   Returns pointer to start of string, or 0 if fail.  The char
 *   replaced by the '\0' terminator is returned in *cp.
 */
char *
getstring (scp, cp)
     struct scblk *scp;
     char *cp;
{
  return checkstr (scp) ? savestr (scp, cp) : (char *) 0L;
}


/*
 *  restorestring - restore an scblk after a getstring call.
 *
 *  when making multiple getstring calls, call restorestring in the reverse
 *  order from getstring, in case two arguments point to the same source string.
 */
void
restorestring (scp, c)
     struct scblk *scp;
     word c;
{
  if (scp)
    scp->str[scp->len] = c;
}


/*
 *  restore2str - restore two argument strings in XL, XR.
 */
void
restore2str ()
{
  restorestring (XR (struct scblk *), savexr);
  restorestring (XL (struct scblk *), savexl);
}

/*
 *  getint - fetch an integer from either an icblk, rcblk or non-null scblk.
 *
 *  returns 1 if successful, 0 if failed.
 */
int
getint (icp, pword)
     struct icblk *icp;
     IATYPE *pword;
{
  register char *p, c;
  struct scblk *scp;
  word i;
  IATYPE result;
  int sign;

  sign = 1;
  if (icp->typ == type_icl)
    result = icp->val;
  else if (icp->typ == type_rcl)
    {
#if sparc
      union
      {
	mword rcvals[2];
	double rcval;
      } val;
      val.rcvals[0] = ((struct rcblk *) icp)->rcvals[0];
      val.rcvals[1] = ((struct rcblk *) icp)->rcvals[1];
      result = (IATYPE) val.rcval;
#else
      result = (IATYPE) (((struct rcblk *) icp)->rcval);
#endif
    }
  else
    {
      scp = (struct scblk *) icp;
      if (!checkstr (scp))
	return 0;
      i = scp->len;
      p = scp->str;
      result = (IATYPE) 0;
      while (i && *p == ' ')
	{			/* remove leading blanks */
	  p++;
	  i--;
	}
      if (i && (*p == '+' || *p == '-'))
	{			/* process optional sign char */
	  if (*p++ == '-')
	    sign = -1;
	  i--;
	}
      while (i--)
	{
	  c = *p++;
	  if (c < '0' || c > '9')
	    {			/* not handling trailing blanks */
	      return 0;
	    }
	  result = result * 10 + (c - '0');
	}
    }
  *pword = sign * result;
  return 1;
}



zyshs ()
{
  word retval;
  IATYPE val;
  register struct icblk *icp = WA (struct icblk *);
  register struct scblk *scp;

  /*
     /   if argument one is null...
   */
  scp = WA (struct scblk *);
  if (scp->typ == type_scl && !scp->len)
    {
      gethost (ptscblk, TSCBLK_LENGTH);
      if (ptscblk->len == 0)
	return EXIT_4;
      SET_XL (ptscblk);
      return EXIT_3;
    }

  /*
     /   If argument one is an integer ...
   */
  if (getint (icp, &val))
    {
      switch ((int) val)
	{
	  /*
	     / HOST( -1, n ) returns internal parameter n
	   */
	case -1:
	  icp = XL (struct icblk *);
	  if (getint (icp, &val))
	    {
	      pticblk->typ = type_icl;
	      SET_XR (pticblk);
	      switch ((int) val)
		{
		case 0:
		  pticblk->val = memincb;
		  return EXIT_8;
		case 1:
		  pticblk->val = databts;
		  return EXIT_8;
		case 2:
		  pticblk->val = (IATYPE) basemem;
		  return EXIT_8;
		case 3:
		  pticblk->val = (IATYPE) topmem;
		  return EXIT_8;
		case 4:
		  pticblk->val = stacksiz - 400;	/* safety margin */
		  return EXIT_8;
		case 5:	/* stack in use */
#if WINNT | LINUX
		  pticblk->val = stacksiz - (XS (IATYPE) - (IATYPE) lowsp);
#else
		  pticblk->val =
		    stacksiz - (XS (IATYPE) - ((IATYPE) lowxs - 400));
#endif
		  return EXIT_8;
		case 6:
		  pticblk->val = sizeof (IATYPE);
		  return EXIT_8;
		default:
		  return EXIT_1;
		}
	    }
	  else
	    return EXIT_1;

	  /*
	     /  HOST( 0 ) returns the -u command line option argument
	   */
	case 0:
	  if (uarg)
	    {
	      cpys2sc (uarg, ptscblk, TSCBLK_LENGTH);
	      SET_XL (ptscblk);
	      return EXIT_3;
	    }
	  else if ((val = cmdcnt) != 0)
	    {
	      ptscblk->len = 0;
	      while (ptscblk->len < TSCBLK_LENGTH - 2 &&
		     arg2scb ((int) val++, gblargc, gblargv,
			      ptscblk, TSCBLK_LENGTH - ptscblk->len) > 0)
		ptscblk->str[ptscblk->len++] = ' ';
	      if (ptscblk->len)
		--ptscblk->len;
	      SET_XL (ptscblk);
	      return EXIT_3;
	    }
	  else
	    return EXIT_4;
	  /*
	     / HOST( 1, "command", "path" ) executes "command" using "path"
	   */
	case 1:
	  {
	    char *cmd, *path;

	    if (!check2str ())
	      return EXIT_1;
	    save2str (&cmd, &path);
	    save0 ();		/* made sure fd 0 OK    */
	    pticblk->val = dosys (cmd, path);

	    pticblk->typ = type_icl;
	    restore2str ();
	    restore0 ();
	    if (pticblk->val < 0)
	      return EXIT_6;
	    SET_XR (pticblk);
	    return EXIT_8;
	  }

	  /*
	     / HOST( 2, n ) returns command line argument n
	   */
	case 2:
	  icp = XL (struct icblk *);
	  if (getint (icp, &val))
	    {
	      ptscblk->len = 0;
	      retval =
		arg2scb ((int) val, gblargc, gblargv, ptscblk, TSCBLK_LENGTH);
	      if (retval < 0)
		return EXIT_6;
	      if (retval == 0)
		return EXIT_1;
	      SET_XL (ptscblk);
	      return EXIT_3;
	    }
	  else
	    return EXIT_1;

	  /*
	     /  HOST( 3 ) returns the command count
	   */
	case 3:
	  if (cmdcnt)
	    {
	      pticblk->typ = type_icl;
	      pticblk->val = cmdcnt;
	      SET_XR (pticblk);
	      return EXIT_8;
	    }
	  else
	    return EXIT_6;

	  /*
	     / HOST( 4, "env-var" ) returns the value of "env-var" from
	     /       the environment.
	   */
	case 4:
	  scp = XL (struct scblk *);
	  if (scp->typ == type_scl)
	    {
	      if (scp->len == 0)
		return EXIT_1;
	      if (rdenv (scp, ptscblk) < 0)
		return EXIT_6;
	      SET_XL (ptscblk);
	      return EXIT_3;
	    }
	  else
	    return EXIT_1;
	}			/* end switch */

      /*
         / Any other integer value is processed by the system-specific functions
       */
#if HOST386
      return host386 ((int) val);
#endif /* HOST386 */

      /*
         /   Here if first argument wasn't an integer or was an illegal value.
       */
    }
  return EXIT_1;
}
