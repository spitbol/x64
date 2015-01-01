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
	if (reg_ra != 0.0)
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

void f_rti() {			// real to integer
	reg_ia = reg_ra;
}


#include <stdio.h>
#define DVI_RMI_LIB
#ifdef DVI_RMI_LIB
// dvi and rmi currently done in assembler, in m.s
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
	fprintf(stderr, "fdvi %ld %ld \n",reg_ia, reg_w0);

	if (reg_w0 == 0) {
		reg_fl = 0x80; // set overflow
	}
	else {
		reg_ia %= (long) reg_w0;
		reg_fl = 0;
	}
	fprintf(stderr,"fdvi returns %ld\n", reg_w0);

}
#endif

void f_cpr() {
	if ( reg_ra == 0.0) 
		reg_fl =  0; 
	else if ( reg_ra < 0.0) 
		reg_fl = -1; 
	else 
		reg_fl =  1; 
	fprintf(stderr, "cpr %g12.6 %d\n",reg_ra,reg_fl);
}

void f_pra () {
	fprintf(stderr,"ldr %g10.6\n",(double) reg_ra);
}

#ifdef trace_int
extern long reg_i1,reg_i2,reg_i3;

void t_ldi() {
	fprintf(stderr,"t_ldi %ld\n",reg_ia);
}

void t_sti() {
	fprintf(stderr,"t_sti %ld\n",reg_ia);
}

void t_adi() {
	fprintf(stderr,"t_adi  IA %ld  RB %ld  IA' %ld\n",reg_i2,reg_i1,reg_i3);
}

void t_mli() {
	fprintf(stderr,"t_mli  IA %ld  RB %ld  IA' %ld\n",reg_i2,reg_i1,reg_i3);
}

void t_sbi() {
	fprintf(stderr,"t_sbi  IA %ld  RB %ld  IA' %ld\n",reg_i2,reg_i1,reg_i3);
}

void t_dvi() {
	fprintf(stderr,"t_dvi  IA %ld  RB %ld  IA' %ld\n",reg_i2,reg_i1,reg_i3);
}

void t_rmi() {
	fprintf(stderr,"t_rmi  IA %ld  RB %ld  IA' %ld\n",reg_i2,reg_i1,reg_i3);
}

void t_ngi() {
	fprintf(stderr,"t_ngi  IA %ld  RB %ld  IA' %ld\n",reg_i2,reg_i1,reg_i3);
}

#endif


void i_adi() {
	reg_fl = 0;
	reg_ia += reg_w0;
}

void i_dvi() {
	if (reg_w0 == 0) {
		reg_fl = 1;
	}
	else {
		reg_ia /= reg_w0;
	}
}

void i_mli() {
	reg_fl = 0;
	reg_ia *= reg_w0;
}

void i_ngi() {
	reg_fl = 0;
	reg_ia = -reg_ia;
}

void i_rmi() {
	fprintf(stderr,"i_rmi enter IA %ld  WC %ld\n",reg_ia,(long) reg_w0);
	if (reg_ia == 0) {
		reg_fl = 1;
	}
	else {
		reg_wa = reg_ia % 10;
		reg_ia = reg_ia / 10;
		reg_wa = -reg_wa + '0';
		reg_fl = 0;
	}
}

void i_sbi() {
	reg_ia -= reg_w0;
}

void i_cvd() {
	
	reg_wa = reg_ia % 10;
//	fprintf(stderr,"i_cvd enter IA %ld  WA %ld\n");	
	reg_ia /= 10;
	reg_wa  = -reg_wa + 48; // convert remainder to character code for digit
//	fprintf(stderr,"i_cvd leave IA %ld  WA %ld\n");	
}

#ifdef trace_int
extern long reg_i1,reg_i2,reg_i3;

void t_ldi() {
	fprintf(stderr,"t_ldi %ld\n",reg_ia);
}

void t_sti() {
	fprintf(stderr,"t_sti %ld\n",reg_ia);
}

void t_adi() {
	fprintf(stderr,"t_adi  IA %ld  RB %ld  IA' %ld\n",reg_i2,reg_i1,reg_i3);
}

void t_mli() {
	fprintf(stderr,"t_mli  IA %ld  RB %ld  IA' %ld\n",reg_i2,reg_i1,reg_i3);
}

void t_sbi() {
	fprintf(stderr,"t_sbi  IA %ld  RB %ld  IA' %ld\n",reg_i2,reg_i1,reg_i3);
}

void t_dvi() {
	fprintf(stderr,"t_dvi  IA %ld  RB %ld  IA' %ld\n",reg_i2,reg_i1,reg_i3);
}

void t_rmi() {
	fprintf(stderr,"t_rmi  IA %ld  RB %ld  IA' %ld\n",reg_i2,reg_i1,reg_i3);
}

void t_ngi() {
	fprintf(stderr,"t_ngi  IA %ld  RB %ld  IA' %ld\n",reg_i2,reg_i1,reg_i3);
}

#endif

void rt(char *s) {
	fprintf(stderr, "rtrace %s  %12.6g   %d\n",s,reg_ra,reg_fl);
}

void adr_e() {
	rt("adr_e");
}

void adr_l() {
	rt("adr_l");
}


void sbr_e() {
	rt("sbr_e");
}

void sbr_l() {
	rt("sbr_l");
}


void mlr_e() {
	rt("mlr_e");
}

void mlr_l() {
	rt("mlr_l");
}


void dvr_e() {
	rt("dvr_e");
}

void dvr_l() {
	rt("dvr_l");
}


void ngr_e() {
	rt("adr_e");
}

void ngr_l() {
	rt("adr_l");
}

void rno_e() {
	rt("rno_e");
}


void rov_e() {
	rt("rov_e");
}

extern double *reg_rp;
void ldr_e() {
	fprintf(stderr,"ldr_e  %12.6g\n",*reg_rp);
}
void ldr_l() {
	rt("ldr_e");
}


#endif					// (FLOAT & !FLTHDWR) | EXTFUN

