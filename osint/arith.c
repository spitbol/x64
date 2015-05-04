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
 * arith.c - floating point support for spitbol
 *
 * These routines are not called from other C routines.  Rather they
 * are called by inter.*, and by external functions, to perform basic
 * arithmetic operatios.
 */

#include "port.h"
#include <stdio.h>


long w00;

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
	if (*reg_rp != 0.0) {
		reg_ra /= *reg_rp;
		reg_fl = 0;
	}
	else
		reg_fl = 1;
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

void f_rti() {			// real to integer
	reg_ia = reg_ra;
}


void f_cpr() {
	if ( reg_ra == 0.0) 
		reg_fl =  0; 
	else if ( reg_ra < 0.0) 
		reg_fl = -1; 
	else 
		reg_fl =  1; 
}

void f_pra () {
}

void i_ldi() {
	reg_ia = reg_w0;
}

void i_adi() {
	reg_fl = 0;
	reg_ia += reg_w0;
}

void i_dvi() {
	if (reg_w0 == 0) {
		reg_fl = 1;
	}
	else {
		reg_fl = 0;
		reg_ia /= reg_w0;
	}
}

void i_mli() {
	long product;
	if (reg_w0 ==0 || reg_ia ==0) {
		reg_ia = 0;
		reg_fl = 0;
	}
	else {
		reg_fl = 0;
		product = reg_ia * reg_w0;
		if (product / reg_w0 != reg_ia) {
			reg_fl = 1;
		}
		else {
			reg_ia = product;
			reg_fl = 0;
		}
	}
}

void i_ngi() {
	long checkin,checkout;
	checkin = reg_ia;
	reg_fl = 0;
	reg_ia = -reg_ia;
	checkout = -reg_ia;
	if (checkin != checkout) {
		reg_fl = 1;
	}
}

void i_rmi() {
	if (reg_w0 == 0) {
		reg_fl = 1;
	}
	else {
		reg_ia = reg_ia % reg_w0;
		reg_fl = 0;
	}
}

extern long save_wa;
void i_sbi() {
	reg_ia -= reg_w0;
}

void i_cvd() {
	
//	fprintf(stderr,"cvd entry reg_ia %ld  reg_wa %ld\n",reg_ia,reg_wa);
	reg_wa = reg_ia % 10;
	reg_ia /= 10;
	reg_wa  = -reg_wa + 48; // convert remainder to character code for digit
//	fprintf(stderr,"cvd exit  reg_ia %ld  reg_wa %ld reg_wa %c\n",reg_ia,reg_wa,reg_wa);
	save_wa = reg_wa;
}

void i_cvm() {
	long	product;
	int	dig;
//	fprintf(stderr,"cvm entry reg_ia %ld reg_wb '%c' \n",reg_ia,reg_wb);
	product = reg_ia * 10;
	if (product / 10 != reg_ia) {
		reg_fl = 1;
	}
	else {
		dig = reg_wb - '0';
		reg_ia = product - dig;
		if (reg_ia + dig != product) {
			reg_fl = 1;
		} 
		else {
			reg_fl = 0;
		}
	}
//	fprintf(stderr,"cvm exit  reg_ia %ld  reg_fl %d\n",reg_ia,reg_fl);
	return;
}

long ctbw_r;
long ctbw_v;

void ctw_() {
	long reg;
	reg = (ctbw_r + CPW - 1) >> LOG_CPW;
	reg += ctbw_v;
	ctbw_r = reg;
}

void ctb_() {
	ctw_();
	ctbw_r = ctbw_r * CPW;
}
