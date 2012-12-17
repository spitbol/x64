/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

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
 * float.c - floating point support for spitbol
 *
 * These routines are not called from other C routines.  Rather they
 * are called by inter.*, and by external functions.
 */

#include "port.h"
#if (FLOAT & !FLTHDWR) | EXTFUN)

/*
 * f_2_i - float to integer
 */
IATYPE f_2_i(ra)
double ra;
{
    return (IATYPE)ra;
}


/*
 * i_2_f - integer to float
 */
double i_2_f(ia)
IATYPE ia;
{
    return ia;
}

/*
 * f_add - floating add to accumulator
 */
double f_add(arg, ra)
double arg,ra;
{
    return ra+arg;
}

/*
 * f_sub - floating subtract from accumulator
 */
double f_sub(arg, ra)
double arg,ra;
{
    return ra-arg;
}

/*
 * f_mul - floating multiply to accumulator
 */
double f_mul(arg, ra)
double arg,ra;
{
    return ra*arg;
}


/*
 * f_div - floating divide into accumulator
 */
double f_div(arg, ra)
double arg,ra;
{
    return ra/arg;
}

/*
 * f_neg - negate accumulator
 */
double f_neg(ra)
double ra;
{
    return -ra;
}

#endif					/* (FLOAT & !FLTHDWR) | EXTFUN */
