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

#include <stdio.h>

// overflow codes
// OF = 0x80
// cf = 0x01
// zr = 0x40

void f_ldr() {			// load real
	reg_ra = *reg_rp;
	return;
}
void f_str() {			// store real
	*reg_rp = reg_ra;
	return;
}

void f_adr() {			// add real
	reg_ra += *reg_rp;
	return;
}

void f_sbr() {			// subtract real
	reg_ra -= *reg_rp;
	return;
}

void f_mlr() {			// multiply real
	reg_ra *= *reg_rp;
	return;
}

void f_dvr() {			// divide real
	reg_ra /= *reg_rp;
	return;
}

void f_ngr() {			// negate real
	reg_ra = -reg_ra;
	return;
}

void f_itr() {			// integer to real
	reg_ra = (double) reg_ia;
	return;
}

int f_rti() {			// real to integer
	reg_ia = reg_ra;
	return 0;
}

long f_2_i(ra) 		// float to integer
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


double f_add(arg, ra)		// float add
double arg,ra;
{
    return ra+arg;
}

double f_sub(arg, ra)		// float substract
double arg,ra;
{
    return ra-arg;
}

double f_mul(arg, ra)		// float multiply
double arg,ra;
{
    return ra*arg;
}

double f_div(arg, ra)		// float divide
double arg,ra;
{
    return ra/arg;
}

double f_neg(ra)		// float negate
double ra;
{
    return -ra;
}

#include <stdio.h>
void f_dvi() {
//	fprintf(stderr, "fdvi %ld %ld \n",reg_ia, reg_w0);

	if (reg_w0 == 0) {
		reg_fl = 0x80; // set overflow
	}
	else {
		reg_ia /= (long) reg_w0;
		reg_fl = 0;
	}
//	fprintf(stderr,"fdvi returns %ld\n", reg_w0);

}
void f_rmi() {
//	fprintf(stderr, "fdvi %ld %ld \n",reg_ia, reg_w0);

	if (reg_w0 == 0) {
		reg_fl = 0x80; // set overflow
	}
	else {
		reg_ia %= (long) reg_w0;
		reg_fl = 0;
	}
//	fprintf(stderr,"fdvi returns %ld\n", reg_w0);

}

/*
void f_rmi() {
	long dividend,divisor,remainder;
	dividend = (long) reg_ia;
	divisor = (long) reg_w0;
	remainder = dividend % divisor;
	reg_ia = remainder;
//	fprintf(stderr,"rmi %8ld =  %8ld   %8ld   %8ld\n",reg_ia, remainder, dividend, divisor);
}
*/

void f_jra() {
	if ( reg_ra == 0.0) 
		reg_w0 =  0; 
	else if ( reg_ra < 0.0) 
		reg_w0 = -1; 
	else 
		reg_w0 =  1; 
	fprintf(stderr, "cpr %g12.6 %ld\n",reg_ra,reg_w0);
}

void f_pra () {
	fprintf(stderr,"ldr %g10.6\n",(double) reg_ra);
}

#endif					// (FLOAT & !FLTHDWR) | EXTFUN
