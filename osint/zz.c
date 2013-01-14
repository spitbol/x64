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

#include "port.h"

#include <stdio.h>


extern uword compsp;
extern uword osisp;
extern uword lowspmin;

uword zz_xl;
uword zz_xr;
uword zz_xs;
uword zz_wa;
uword zz_wb;
uword zz_wc;
uword zz_w0;
uword zz_cp;
uword zz_zz;
uword zz_ln;

uword last_xl;
uword last_xr;
uword last_xs;
uword last_wa;
uword last_wb;
uword last_wc;
uword last_w0;
uword last_cp;

uword zz_calls = 0;
uword zz_hundred = 0;

uword zz_off;
uword zz_id=0;
uword zz_last = 0;
char ** zz_de;
extern long C_AAA;
extern long W_YYY;
long OFF_C_AAA;
long OFF_W_YYY;
#define DAVE
#ifdef DAVE
char * AT_DESC;
extern char at1_0;
void prtnl() {
	fprintf(stderr,"\n");
}
void prtval(long reg) {
//	if (reg > 32 && reg < 127 ) {
//		fprintf(stderr," '%c' %4d ", reg, reg);
//	}
//	else if (reg >= 0 && reg < 100000) {
	if (reg >= 0 && reg < 100000) {
		fprintf(stderr," %8d ", reg);
	}
	else if ( reg >= OFF_C_AAA && reg <= OFF_W_YYY) {
		fprintf(stderr," Z%ld ", reg);
	}
	else {
		fprintf(stderr," %8lxx", reg & 0xffffffff);
//		fprintf(stderr," ---------", reg);
	}
}
void prtreg(char * name, long val) {
	prtval(val);
	fprintf(stderr," %s",name);
}
void prtdif(char* name, long old, long new, long listed)
{
	/* print old and new values of named register */
	fprintf(stderr,"%s:", name);
	prtval(old); fprintf(stderr," -> "); prtval(new);
	prtnl();
}
extern long C_AAA;
extern long W_YYY;

long OFF_C_AAA;
long OFF_W_YYY;


void zz_init() {
	OFF_C_AAA = &C_AAA;
	OFF_W_YYY = &W_YYY;
	fprintf(stderr, "OFF_C_AAA %ld\n", &C_AAA);
	fprintf(stderr, "OFF_W_YYY %ld\n", &W_YYY);
}

char * zz_charp;

void zz_str() {
// print memory block pointed to by zz_cp as string.
// print up to 20 characters, or until find non-printable character.
	char * cp;
	cp = zz_charp;
	int i;
	fprintf(stderr,"zz_str  ");
	for (i = 0;i<20;i++) {
		char c = *cp++;
		if (c>=32 && c <= 126) fprintf(stderr,"%c",c);
		else break;
	}
	fprintf(stderr,"\n");
}

extern uword _rc_;
void zz() {

	char *p;
	int changed = 0;
	int listed = 0;

	zz_calls++;
	if (zz_calls > 100000) return;
/*
	return;
 	zz_calls++;

	if (zz_calls == 100 ) {
	zz_hundred++;
	printf("%\d\n",zz_hundred);
	zz_calls = 0;
	}
	return;
*/
	/* print registers that have changed since last statement */

	/* see if any have changed. */
	if (zz_xl != last_xl)  changed += 1;
	if (zz_xr != last_xr)  changed += 1;
	if (zz_xs != last_xs)  changed += 1;
	if (zz_cp != last_cp)  changed += 1;
	if (zz_wa != last_wa)  changed += 1;
	if (zz_wb != last_wb)  changed += 1;
	if (zz_wc != last_wc)  changed += 1;
	if (zz_w0 != last_w0)  changed += 1;
  changed = 0; // bypass printout
	if (changed) {
/* marked changed Minimal registers with "!" to make it easy to search
   backward for last statement that changed a register. */
		prtnl();
		if (zz_xl != last_xl)
			{ prtdif("xl.esi", last_xl, zz_xl, listed); listed += 1; }
		if (zz_xr != last_xr)
			{ prtdif("xr.edi", last_xr, zz_xr, listed); listed += 1; }
		if (zz_xs != last_xs)
			{ prtdif("xs.esp", last_xs, zz_xs, listed); listed += 1; }
		if (zz_cp != last_cp)
			{ prtdif("cp.ebp", last_cp, zz_cp, listed); listed += 1; }
		if (zz_wa != last_wa)
			{ prtdif("wa.ecx", last_wa, zz_wa, listed); listed += 1; }
		if (zz_wb != last_wb)
			{ prtdif("wb.ebx", last_wb, zz_wb, listed); listed += 1; }
		if (zz_wc != last_wc)
			{ prtdif("wc.edx", last_wc, zz_wc, listed); listed += 1; }
		if (zz_w0 != last_w0)
			{ prtdif("w0.eax", last_w0, zz_w0, listed); listed += 1; }
		prtnl();
	}

//	if (zz_calls % 3 == 1) {
//	if (zz_calls>0) {
	int prtregs=1;
 prtregs=0;
if (prtregs) {

		/* print register values before the statement was executed */
		prtreg("xl.esi", zz_xl);
		prtreg("xr.edi", zz_xr);
		prtreg("xs.esp", zz_xs);
		/* cp is last on line, so don't print it zero */
		if (zz_cp) prtreg("cp.ebp", zz_cp);
		fprintf(stderr, "\n");
		prtreg("wa.ecx", zz_wa);
		prtreg("wb.ebx", zz_wb);
		prtreg("wc.edx", zz_wc);
		prtreg("w0.eax", zz_w0);
		fprintf(stderr, "\n");
}
//	}
	/* display instruction pointer and description of current statement. */
	if (zz_zz != zz_last) {
/*	fprintf(stderr, "\n%8xx %s\n", zz_ip, p);*/
//	fprintf(stderr, "zzz %d %d %d %s\n",zz_calls, zz_id, zz_zz,zz_de);
	fprintf(stderr, "zzz %d %s\n",_rc_,zz_de);
	}
	zz_last = zz_zz;

	/* save current register contents. */
	last_xl = zz_xl; last_xr = zz_xr; last_xs = zz_xs; last_cp = zz_cp;

	last_wa = zz_wa; last_wb = zz_wb; last_wc = zz_wc; last_w0 = zz_w0;

}
void zz_0() {
	fprintf(stderr, "zz_0\n");
}
void zz_1() {
	fprintf(stderr, "zz_1\n");
}
void zz_2() {
	fprintf(stderr, "zz_2\n");
}
void zz_3() {
	fprintf(stderr, "zz_3\n");
}
void zz_4() {
	fprintf(stderr, "zz_4\n");
}
uword zz_arg;
void zz_num() {
	fprintf(stderr, "zz_num\t%x\n",zz_arg);
}
uword zz_num_id;
uword zz_sys_id;
uword zz_sys_calls=0;
void zz_sys() {
	zz_sys_calls++;
	fprintf(stderr, "zz_sys %d %d\n",zz_sys_calls,zz_sys_id);
}
#endif
