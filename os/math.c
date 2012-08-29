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
 * math.c - extended math support for spitbol

 * Routines not provided by hardware floating point.

 * These routines are not called from other C routines.  Rather they
 * are called by inter.*, and by external functions.
 */

#include "port.h"
#include "globals.ext"

#include <errno.h>

#if FLOAT & !MATHHDWR

#include <math.h>

#ifndef errno
#if UNIX
int errno;
#else
extern int errno;		/* system error number */
#endif
#endif

extern double inf;		/* infinity */

/*
   f_atn - arctangent
 */
double
f_atn (ra)
     double ra;
{
  return atan (ra);
}


/*
   f_chp - chop
 */
double
f_chp (ra)
     double ra;
{
  if (ra >= 0.0)
    return floor (ra);
  else
    return ceil (ra);
}



/*
   f_cos - cosine
 */
double
f_cos (ra)
     double ra;
{
  return cos (ra);
}



/*
   f_etx - e to the x
 */
double
f_etx (ra)
     double ra;
{
  double result;
  errno = 0;
  result = exp (ra);
  return errno ? inf : result;
}



/*
   f_lnf - natural log
 */
double
f_lnf (ra)
     double ra;
{
  double result;
  errno = 0;
  result = log (ra);
  return errno ? inf : result;
}



/*
   f_sin - sine
 */
double
f_sin (ra)
     double ra;
{
  return sin (ra);
}


/*
   f_sqr - square root  (range checked by caller)
 */
double
f_sqr (ra)
     double ra;
{
  return sqrt (ra);
}


/*
   f_tan - tangent
 */
double
f_tan (ra)
     double ra;
{
  double result;
  errno = 0;
  result = tan (ra);
  return errno ? inf : result;
}

#endif /* FLOAT & !MATHHDWR */
