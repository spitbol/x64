/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2013 David Shields

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
#if (FLOAT & !FLTHDWR) | EXTFUN


/*
 * f_ldr - load real
 */
void f_ldr() {
	reg_ra = * (double *) reg_w0;
	return;
}

/*
 * f_str - store real
 */
void f_str() {
	*((double *) reg_w0) = reg_ra;
	return;
}

/*
 * f_adr - add value to RA
 */
void f_adr() {
	reg_ra += * (double *) reg_w0;
	return;
}


/*
 * f_sbr - subtract value from RA
 */
void f_sbr() {
	reg_ra -= * (double *) reg_w0;
	return;
}

/*
 * f_mlr - multiply RA by value
 */
void f_mlr() {
	reg_ra *= * (double *) reg_w0;
	return;
}

/*
 * f_dvr - divide RA by value
 */
void f_dvr() {
	reg_ra /= * (double *) reg_w0;
	return;
}

/*
 * f_ngr - negate value in RA
 */
void f_ngr() {
	reg_ra = - (* (double *) reg_w0);
	return;
}

/*
 * f_2_i - float to integer
 */
long f_2_i(ra)
double ra;
{
    return (long)ra;
}


/*
 * i_2_f - integer to float
 */
double i_2_f(ia)
long ia;
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

#endif					// (FLOAT & !FLTHDWR) | EXTFUN
