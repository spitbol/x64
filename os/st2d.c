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

/* st2d.c - convert integer to decimal string */

#include "port.h"
#include "globals.ext"

static int stc_d (char *out, unsigned int in, int outlen, int signflag);

static int
stc_d (out, in, outlen, signflag)
     REGISTER char *out;
     REGISTER unsigned int in;
     REGISTER int outlen;
     int signflag;
{
  char revnum[20];
  REGISTER int i = 0;
  REGISTER char *out0 = out;

  if (outlen <= 0)
    return (0);

  if (in == 0)
    revnum[i++] = 0;
  else
    while (in)
      {
	revnum[i++] = in - (in / 10) * 10;
	in /= 10;
      }

  if (signflag)
    {
      *out++ = '-';
      outlen--;
    }

  for (; i && outlen; i--, outlen--)
    *out++ = revnum[i - 1] + '0';

  *out = '\0';

  return (out - out0);

}


int
stcu_d (out, in, outlen)
     char *out;
     unsigned int in;
     int outlen;
{
  return (stc_d (out, in, outlen, 0));
}
