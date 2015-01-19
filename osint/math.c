/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2015 David Shields

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or
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
 *
 * Routines not provided by hardware floating point.
 *
 * These routines are not called from other C routines.  Rather they
 * are called by inter.*, and by external functions.
 */

#include "port.h"

#include <errno.h>

#if FLOAT & !MATHHDWR

#include <math.h>

#ifndef errno
int errno;
#endif

extern double inf;	// infinity

/*
 * f_atn - arctangent
 */
void f_atn()
{
	reg_ra = atan(reg_ra);
}

/*
 * f_chp - chop
 */
void f_chp()
{
    if (reg_ra >= 0.0)
        reg_ra =  floor(reg_ra);
    else
        reg_ra =  ceil(reg_ra);
}

/*
 * f_cos - cosine
 */
void f_cos()
{
    reg_ra =  cos(reg_ra);
}


/*
 * f_etx - e to the x
 */
void f_etx()
{
    errno = 0;
    reg_ra = exp(reg_ra);
    if (errno) {
	reg_ra = inf;
    }
}

/*
 * f_lnf - natureg_ral log
 */
void f_lnf()
{
    errno = 0;
    reg_ra = log(reg_ra);
    if (errno) {
	reg_ra = inf;
    }
}

/*
 * f_sin - sine
 */
void f_sin()
{
    reg_ra = sin(reg_ra);
}

/*
 * f_sqr - square root  (reg_range checked by caller)
 */
void f_sqr()
{
    reg_ra = sqrt(reg_ra);
}

/*
 * f_tan - tangent
 */
void f_tan()
{
    double result;
    result = tan(reg_ra);
    errno = 0;
    reg_ra = errno ? inf : result;
}
#endif					// FLOAT & !MATHHDWR
