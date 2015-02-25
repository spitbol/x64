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
#include <stdlib.h>
#include <string.h>

char reg_prefix;

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
long off_s_aaa;
long off_s_yyy;
long off_dnamb;
long off_dname;
long off_basemem;
long off_topemem;
//extern dnamb();
//extern dname();


char * AT_DESC;
extern char at1_0;
void prtnl() {
	fprintf(stderr,"\n");
}
void prtreal(double val) {
	fprintf(stderr, " %8.3g ", val);
}

void prtval(long reg) {
//	fprintf(stderr," %8ld ", reg);

	if (reg > 32 && reg < 127 ) {
	fprintf(stderr," %c  %5d", (char) reg, (int) reg);
	}
	if (reg >= 0 && reg < 1000000) {
		fprintf(stderr,"\t%8ld ", reg);
	}
	else if ( reg >= off_s_aaa && reg <= off_s_yyy) {	// code
		fprintf(stderr,"\tC:%ld ", reg-off_s_aaa);
	}
	else if ( reg >= off_c_aaa && reg <= off_w_yyy) {  	// data
		fprintf(stderr,"\tD:%ld ", reg-off_c_aaa);
	}
//	else if ( reg >= off_basemem && reg <= off_topmem) { 	// heap
	else if ( reg >= off_basemem ) { 	// heap
		fprintf(stderr,"\tH:%ld ", reg-off_basemem);
	}
	else {
		fprintf(stderr,"\t%8lxx", reg & 0xffffffff);
//		fprintf(stderr,"\t---------", reg);
	}
}
void prtregr(char * name, double val) {
	prtreal(val);
	fprintf(stderr," %c%s\n", reg_prefix,name);
}

void prtreg(char * name, char type, char *reg, long val) {
	prtval(val);
	fprintf(stderr," %s%c%s", name,reg_prefix, reg);
}
void prtdif(char* name, char type, char *reg, long old, long new, long listed)
{
	// print old and new values of named register
	fprintf(stderr,"%s%c%s:", name, reg_prefix, reg);
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

int reglines; // print full registers every this number of lines
int regline; // current line module reglines

extern uword _rc_;
void it() {

	char *p;
	char *dp;
	int changed = 0;
	int listed = 0;

	if ((spitflag & ITRACE) == 0)	return;

	it_calls++;
	if (it_calls > 50000) return;

	// print registers that have changed since last statement

	// see if any have changed.
	if (save_xl != last_xl)  changed += 1;
	if (save_xr != last_xr)  changed += 1;
	if (save_wa != last_wa)  changed += 1;
	if (save_wb != last_wb)  changed += 1;
	if (save_wc != last_wc)  changed += 1;
	if (save_w0 != last_w0)  changed += 1;
	if (save_ra != last_ra)  changed += 1;
//  changed = 0; // bypass printout
	if (changed) {
/* marked changed Minimal registers with "!" to make it easy to search
   backward for last statement that changed a register. */
		prtnl();
		if (save_xl != last_xl)
			{ prtdif("XL.",reg_prefix,"si", last_xl, save_xl, listed); listed += 1; }
		if (save_xr != last_xr)
			{ prtdif("XR.",reg_prefix,"di", last_xr, save_xr, listed); listed += 1; }
		if (save_w0 != last_w0)
			{ prtdif("W0.",reg_prefix,"ax", last_w0, save_w0, listed); listed += 1; }
		if (save_wa != last_wa)
			{ prtdif("WA.",reg_prefix,"cx", last_wa, save_wa, listed); listed += 1; }
		if (save_wb != last_wb)
			{ prtdif("WB.",reg_prefix,"bx", last_wb, save_wb, listed); listed += 1; }
		if (save_wc != last_wc)
			{ prtdif("WC.",reg_prefix,"dx", last_wc, save_wc, listed); listed += 1; }
		if (save_ra != last_ra)
			{ prtdifr("RA    ", last_ra, save_ra, listed); listed += 1; }
		prtnl();
	}

	int prtregs=1;
//	 prtregs=0;
	--regline;
//	if (prtregs>0 && (regline <= 0)) {
	if (prtregs) {
		regline = reglines;
		// print register values before the statement was executed
		prtreg("XL.",reg_prefix,"si", save_xl); prtnl();
		prtreg("XR.",reg_prefix,"di", save_xr); prtnl();
		prtreg("W0.",reg_prefix,"ax", save_w0); prtnl();
		prtreg("WA.",reg_prefix,"cx", save_wa); prtnl();
		prtreg("WB.",reg_prefix,"bx", save_wb); prtnl();
		prtreg("WC.",reg_prefix,"dx", save_wc); prtnl();
		prtnl();
	}
	// save current register contents.
	last_xl = save_xl; last_xr = save_xr; 
	last_wa = save_wa; last_wb = save_wb; last_wc = save_wc; last_w0 = save_w0;

	// display instruction pointer and description of current statement.
	// extract line number at end of trace string
	dp = it_de + strlen(it_de) - 4;
	it_last = atoi(dp);
	if (it_ln != it_last) {
	fprintf(stderr, "\n %s\n",it_de);
	}
	it_last = it_ln;

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

long off_basemem;
long off_topmem;

void it_init(long basemem, long topmem) {
	off_basemem = basemem;
	off_topmem = topmem;
	if ((spitflag & ITRACE) == 0) return;
	off_c_aaa = (long) &c_aaa;
	off_w_yyy = (long) &w_yyy;
	off_s_aaa = (long) &s_aaa;
	off_s_yyy = (long) &s_yyy;
	fprintf(stderr, "off_c_aaa %ld\n", 		(long) &c_aaa);
	fprintf(stderr, "off_w_yyy %ld\n", 		(long) &w_yyy);
	fprintf(stderr, "off_yyy-off_aaa %ld\n", 	off_w_yyy-off_c_aaa);

	fprintf(stderr, "off_s_aaa %ld\n", 		(long) &s_aaa);
	fprintf(stderr, "off_s_yyy %ld\n", 		(long) &s_yyy);
	fprintf(stderr, "s_yyy-s_aaa %ld\n", 		off_s_yyy - off_s_aaa);

	fprintf(stderr, "off_dnamb %ld\n", 		(long) &dnamb);
//	fprintf(stderr, "off_dname %ld\n", 		(long) &dname);
//	fprintf(stderr, "dname-dnamb %ld\n", 		off_dname - off_dnamb);
	reglines = 8; // print all registers every eight instructions
	regline = 0;
	if (INTBITS==32)
		reg_prefix = 'e';
	else
		reg_prefix = 'r';
	fprintf(stderr," INTBITS %d  prefix %c\n",INTBITS,reg_prefix);
}

