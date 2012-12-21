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

#include "port.h"

#include <stdio.h>


extern int compsp;
extern int osisp;
extern int lowspmin;

int zz_xl;
int zz_xr;
int zz_xs;
int zz_wa;
int zz_wb;
int zz_wc;
int zz_w0;
int zz_cp;
int zz_zz;

int last_xl;
int last_xr;
int last_xs;
int last_wa;
int last_wb;
int last_wc;
int last_w0;
int last_cp;

int AT_CALLS = 0;

#define DAVE
#ifdef DAVE
char * AT_DESC;
extern char at1_0;
void prtnl() {
	fprintf(stderr,"\n");
}
void prtval(int reg) {
	if (reg < 100000 && reg >= 0)
		fprintf(stderr," %8d ", reg);
	else
		fprintf(stderr," %16lxx", reg);
//		fprintf(stderr," ---------", reg);
}
void prtreg(char * name, int val) {
	prtval(val);
	fprintf(stderr," %s",name);
}
void prtdif(char* name, int old, int new, int listed)
{
	/* print old and new values of named register */
	fprintf(stderr,"%s:", name);
	prtval(old); fprintf(stderr," -> "); prtval(new);
	prtnl();
}

unsigned long zz_off;
int zz_calls=0;
int zz_id=0;
/*void zz_(long zz_ip,char * zz_desc) {*/
void zz() {

	int changed = 0;
	int listed = 0;

	if(zz_zz>0) zz_calls++;
	fprintf(stderr, "ZZZ %d %d %d\n",zz_calls, zz_zz, zz_id);

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
	AT_CALLS++; /* count number of calls */

	if (AT_CALLS % 3 == 1) {
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
	/* display instruction pointer and description of current statement. */
/*	fprintf(stderr, "\n%8xx %s\n", zz_ip, p);*/

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
	fprintf(stderr, "zz_2\n");
}
uword zz_arg;
void zz_num() {
	fprintf(stderr, "zz_num\t%lx\n",zz_arg);
}
uword zz_num_id;
uword zz_sys_id;
uword zz_sys_calls=0;
void zz_sys() {
	zz_sys_calls++;
	fprintf(stderr, "zz_sys %d %d\n",zz_sys_calls,zz_sys_id);
}
#endif
