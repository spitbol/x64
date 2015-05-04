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

void i_enter(char * name) {
	return;
	fprintf(stderr,"i_enter name %s  ia %ld  w0 %ld wa %ld \n",name,reg_ia,reg_w0,reg_wa);
}

void i_leave(char * name) {
	return;
	fprintf(stderr,"i_leave name %s  ia %ld  w0 %ld wa %ld reg_fl %d \n",name,reg_ia,reg_w0,reg_wa,reg_fl);
}

void i_ldi() {
	reg_ia = reg_w0;
}

void i_adi() {
	reg_fl = 0;
	reg_ia += reg_w0;
}

void i_dvi() {
	i_enter("dvi");
	if (reg_w0 == 0) {
		reg_fl = 1;
	}
	else {
		reg_fl = 0;
		reg_ia /= reg_w0;
	}
	i_leave("dvi");
}

void i_mli() {
	long product;
	i_enter("mli");
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
	i_leave("mli");
}

void i_ngi() {
	long checkin,checkout;
	i_enter("mli");
	checkin = reg_ia;
	reg_fl = 0;
	reg_ia = -reg_ia;
	checkout = -reg_ia;
	if (checkin != checkout) {
		reg_fl = 1;
	}
	i_leave("mli");
}

void i_rmi() {
	
	i_enter("rmi");
	if (reg_w0 == 0) {
		reg_fl = 1;
	}
	else {
		reg_ia = reg_ia % reg_w0;
		reg_fl = 0;
	}
	i_leave("rmi");
}

extern long save_wa;
void i_sbi() {
	reg_ia -= reg_w0;
}

void i_cvd() {
	
	i_enter("cvd");
	reg_wa = reg_ia % 10;
	reg_ia /= 10;
	reg_wa  = -reg_wa + 48; // convert remainder to character code for digit
	save_wa = reg_wa;
	i_leave("cvd");
}

void i_cvm() {
	long	product;
	int	dig;
	i_enter("cvm");
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
	i_leave("cvm");
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
