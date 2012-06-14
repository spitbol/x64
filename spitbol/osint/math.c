/*
 * math.c - extended math support for spitbol
 *
 * Routines not provided by hardware floating point.
 *
 * These routines are not called from other C routines.  Rather they
 * are called by inter.*, and by external functions.
 */
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */
#include "port.h"
/* next needed on Ubunto to avoid TLS error message from ld  (DS 6/13/12) */
#include <errno.h>

#if FLOAT & !MATHHDWR

#include <math.h>

#ifndef errno
#if LINUX
int errno;
#else
extern int errno; /* system error number */
#endif
#endif

extern double inf;	/* infinity */

/*
 * f_atn - arctangent
 */
double f_atn(ra)
double ra;
   {
   return atan(ra);
   }


/*
 * f_chp - chop
 */
double f_chp(ra)
double ra;
   {
   if (ra >= 0.0)
      return floor(ra);
   else
      return ceil(ra);
   }



/*
 * f_cos - cosine
 */
double f_cos(ra)
double ra;
   {
   return cos(ra);
   }



/*
 * f_etx - e to the x
 */
double f_etx(ra)
double ra;
   {
   double result;
   errno = 0;
   result = exp(ra);
   return errno ? inf : result;
   }



/*
 * f_lnf - natural log
 */
double f_lnf(ra)
double ra;
   {
   double result;
   errno = 0;
   result = log(ra);
   return errno ? inf : result;
   }



/*
 * f_sin - sine
 */
double f_sin(ra)
double ra;
   {
   return sin(ra);
   }


/*
 * f_sqr - square root  (range checked by caller)
 */
double f_sqr(ra)
double ra;
   {
   return sqrt(ra);
   }


/*
 * f_tan - tangent
 */
double f_tan(ra)
double ra;
   {
   double result;
   errno = 0;
   result = tan(ra);
   return errno ? inf : result;
   }

#endif					/* FLOAT & !MATHHDWR */
