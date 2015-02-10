/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-25 David Shields

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


#include "port.h"

#include <stdio.h>


extern uword compsp;
extern uword osisp;

uword save_xl;
uword save_xr;
uword save_xs;
uword save_wa;
uword save_wb;
uword save_wc;
uword save_w0;
uword save_cp;
double save_ra;
uword it_ln;
uword it_ln;

uword last_xl;
uword last_xr;
uword last_xs;
uword last_wa;
uword last_wb;
uword last_wc;
uword last_w0;
uword last_cp;
double last_ra;

uword it_calls = 0;
uword it_hundred = 0;

uword it_off;
uword it_id=0;
uword it_last = 0;
char * it_de;
extern long c_aaa;
extern long w_yyy;
long off_c_aaa;
long off_w_yyy;
char * AT_DESC;
extern char at1_0;
void prtnl() {
	fprintf(stderr,"\n");
}
void prtreal(double val) {
	fprintf(stderr, " %8.3g ", val);
}

void prtval(long reg) {
//	if (reg > 32 && reg < 127 ) {
//		fprintf(stderr," '%c' %4d ", reg, reg);
//	}
//	else if (reg >= 0 && reg < 300000) {
	if (reg >= 0 && reg < 100000) {
		fprintf(stderr," %8ld ", reg);
	}
	else if ( reg >= off_c_aaa && reg <= off_w_yyy) {
		fprintf(stderr," Z%ld ", reg);
	}
	else {
		fprintf(stderr," %8lxx", reg & 0xffffffff);
//		fprintf(stderr," ---------", reg);
	}
}
void prtregr(char * name, double val) {
	prtreal(val);
	fprintf(stderr," %s",name);
}

void prtreg(char * name, long val) {
	prtval(val);
	fprintf(stderr," %s",name);
}
void prtdif(char* name, long old, long new, long listed)
{
	// print old and new values of named register
	fprintf(stderr,"%s:", name);
	prtval(old); fprintf(stderr," -> "); prtval(new);
	prtnl();
}

void prtdifr(char* name, double old, double new, long listed)
{
	// print old and new values of named register
	fprintf(stderr,"%s:", name);
	prtreal(old); fprintf(stderr," -> "); prtreal(new);
	prtnl();
}
extern long c_aaa;
extern long w_yyy;

long off_c_aaa;
long off_w_yyy;


char * it_charp;

void it_str() {
// print memory block pointed to by save_cp as string.
// print up to 20 characters, or until find non-printable character.
	char * cp;
	cp = it_charp;
	int i;
	fprintf(stderr,"it_str  ");
	for (i = 0;i<20;i++) {
		char c = *cp++;
		if (c>=32 && c <= 126) fprintf(stderr,"%c",c);
		else break;
	}
	fprintf(stderr,"\n");
}

extern uword _rc_;
void it() {

	char *p;
	int changed = 0;
	int listed = 0;

	it_calls++;
//	if (it_calls < 2000)	return;	// bypass initial code
	if (it_calls > 50000) return;
/*
	return;
 	it_calls++;

	if (it_calls == 100 ) {
	it_hundred++;
	printf("%\d\n",it_hundred);
	it_calls = 0;
	}
	return;
*/
	// print registers that have changed since last statement

	// see if any have changed.
	if (save_xl != last_xl)  changed += 1;
	if (save_xr != last_xr)  changed += 1;
//	if (save_xs != last_xs)  changed += 1;
//	if (save_cp != last_cp)  changed += 1;
	if (save_wa != last_wa)  changed += 1;
	if (save_wb != last_wb)  changed += 1;
	if (save_wc != last_wc)  changed += 1;
	if (save_w0 != last_w0)  changed += 1;
	if (save_ra != last_ra)  changed += 1;
  changed = 0; // bypass printout
	if (changed) {
/* marked changed Minimal registers with "!" to make it easy to search
   backward for last statement that changed a register. */
		prtnl();
		if (save_xl != last_xl)
			{ prtdif("XL.esi", last_xl, save_xl, listed); listed += 1; }
		if (save_xr != last_xr)
			{ prtdif("XR.edi", last_xr, save_xr, listed); listed += 1; }
//		if (save_xs != last_xs)
//			{ prtdif("XS.esp", last_xs, save_xs, listed); listed += 1; }
//		if (save_cp != last_cp)
//			{ prtdif("CP.ebp", last_cp, save_cp, listed); listed += 1; }
		if (save_w0 != last_w0)
			{ prtdif("W0.eax", last_w0, save_w0, listed); listed += 1; }
		if (save_wa != last_wa)
			{ prtdif("WA.ecx", last_wa, save_wa, listed); listed += 1; }
		if (save_wb != last_wb)
			{ prtdif("WB.ebx", last_wb, save_wb, listed); listed += 1; }
		if (save_wc != last_wc)
			{ prtdif("WC.edx", last_wc, save_wc, listed); listed += 1; }
		if (save_ra != last_ra)
			{ prtdifr("RA    ", last_ra, save_ra, listed); listed += 1; }
		prtnl();
	}

//	if (it_calls % 3 == 1) {
//	if (it_calls>0) {
	int prtregs=1;
	 prtregs=1;
	 prtregs=0;

if (prtregs) {

		// print register values before the statement was executed
		prtreg("XL.esi", save_xl);
		prtreg("XR.edi", save_xr);
//		prtregr("RA    ",save_ra);
//		prtreg("XS.esp", save_xs);
		// cp is last on line, so don't print it zero
//		if (save_cp) prtreg("cp.ebp", save_cp);
		fprintf(stderr, "\n");
		prtreg("W0.eax", save_w0);
		prtreg("WA.ecx", save_wa);
		prtreg("WB.ebx", save_wb);
		prtreg("WC.edx", save_wc);
		fprintf(stderr, "\n");
}
//	}
	// display instruction pointer and description of current statement.
	if (it_ln != it_last) {
//	fprintf(stderr, "\n%8xx %s\n", it_ip, p);
//	fprintf(stderr, "it %d %d %d %s\n",it_calls, it_id, it_ln,it_de);
//	fprintf(stderr, "it %d %s\n",_rc_,it_de);
//	fprintf(stderr, "\n    %6d  %s\n",it_calls,it_de);
	fprintf(stderr, "\n  %s\n",it_de);
	}
	it_last = it_ln;

	// save current register contents.
	last_xl = save_xl; last_xr = save_xr; last_xs = save_xs; last_cp = save_cp;

	last_wa = save_wa; last_wb = save_wb; last_wc = save_wc; last_w0 = save_w0;

}
void it_0() {
	fprintf(stderr, "it_0\n");
}
void it_1() {
	fprintf(stderr, "it_1\n");
}
void it_2() {
	fprintf(stderr, "it_2\n");
}
void it_3() {
	fprintf(stderr, "it_3\n");
}
void it_4() {
	fprintf(stderr, "it_4\n");
}
uword it_arg;
void it_num() {
	fprintf(stderr, "it_num\t%x\n",(unsigned int) it_arg);
}
int it_num_id;
int it_sys_id;
int it_sys_calls=0;
void it_sys() {
	it_sys_calls++;
	fprintf(stderr, "it_sys %d %d\n",it_sys_calls,it_sys_id);
}
	extern double REAV1;
void it_ra() {
	fprintf(stderr,"it_ra %e\n",reg_ra);
}
void it_init() {
//	off_c_aaa = &c_aaa;
//	off_w_yyy = &w_yyy;
//	fprintf(stderr, "off_c_aaa %ld\n", &c_aaa);
//	fprintf(stderr, "off_w_yyy %ld\n", &w_yyy);
}

