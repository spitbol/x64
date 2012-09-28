/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2912 David Shields

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
        zysdc - check system expiration date

        zysdc prints any header messages and may check
        the date to see if execution is allowed to proceed.

        Parameters:
            Nothing
        Returns
            Nothing
            No return if execution not permitted

*/

#include "port.h"
#include "os.h"
#include "globals.ext"

#include <stdio.h>

int id_call;
extern int nlines;
extern int id_call;
extern int compsp;
extern int osisp;
extern int LOWSPMIN;

/* set ati_trace to zero to disable tracing, to -1 to resume it. */
int ati_trace = 1;

int at_xl;
int at_xr;
int at_xs;
int at_wa;
int at_wb;
int at_wc;
int at_w0;
int at_cp;
#undef NOTRACE
#define TRACE
void atmsg() {
	fprintf(stderr,"atmsg\n");
}
void 
rp(char *s, long reg) {
	if (reg < 1000000 && reg > -1000000) {
		fprintf(stderr,"%+8d", reg);
	}
	else {
		fprintf(stderr,"%8x", reg);
	}
	fprintf(stderr, " %s  ", s);
}
int ati_line;
void
atip(unsigned int ip)
{
	if (ati_line == 0) {
		return;
	}
	else if (ati_line == -1) {
		ati_trace = 1;
	}
	fprintf(stderr, "\nline %d  ip=0x%x\n",ati_line,ip);
	rp("esi.xl", at_xl);
	rp("edi.xr", at_xr);
	rp("esp.xs", at_xs);
	fprintf(stderr, " compsp %8x",compsp);
	fprintf(stderr,"\n");
	rp("reg_xl", reg_xl);
	rp("reg_xr", reg_xr);
	rp("reg_xs", reg_xs);
	fprintf(stderr,"\n");
	rp("ecx.wa", at_wa);
	rp("ebx.wb", at_wb);
	rp("edx.wc", at_wc);
	rp("eax.w0", at_w0);
	rp("ebp.cp", at_cp);
	fprintf(stderr,"\n");
	rp("reg_wa", reg_wa);
	rp("reg_wb", reg_wb);
	rp("reg_wc", reg_wc);
	rp("reg_w0", reg_w0);
	rp("ebp.cp", reg_cp);
	fprintf(stderr,"\nset:");
	if (reg_xl != 0) fprintf(stderr, " xl");
	if (reg_xr != 0) fprintf(stderr, " xr");
	if (reg_xs != 0) fprintf(stderr, " xs");
	if (reg_wa != 0) fprintf(stderr, " wa");
	if (reg_wb != 0) fprintf(stderr, " wb");
	if (reg_wc != 0) fprintf(stderr, " wc");
	if (reg_cp != 0) fprintf(stderr, " cp");
	fprintf(stderr,"\n\n");


}
atlin()
{
#ifdef TRACE
	fprintf(stderr, "at line %d\n",nlines);
	regdump();
#endif
}


regdump()
{
#ifdef TRACE
	fprintf(stderr," nlines %d\n",nlines);
	fprintf(stderr," %s %10u ","CP", CP(int));
	fprintf(stderr," %s %10u ","IA", IA(int));
	fprintf(stderr,"\n");
	fprintf(stderr," %s %10u ","WA", WA(int));
	fprintf(stderr," %s %10u ","WB", WB(int));
	fprintf(stderr," %s %10u ","WC", WC(int));
	fprintf(stderr,"\n");
	fprintf(stderr," %s %10u ","XL", XL(int));
	fprintf(stderr," %s %10u ","XR", XR(int));
	fprintf(stderr," %s %10u ","XS", XS(int));
	fprintf(stderr,"\n");
	fprintf(stderr," %s %10lX ","CP", CP(int));
	fprintf(stderr," %s %10lX ","IA", IA(int));
	fprintf(stderr,"\n");
	fprintf(stderr," %s %10lX ","WA", WA(int));
	fprintf(stderr," %s %10lX ","WB", WB(int));
	fprintf(stderr," %s %10lX ","WC", WC(int));
	fprintf(stderr,"\n");
	fprintf(stderr," %s %10lX ","XL", XL(int));
	fprintf(stderr," %s %10lX ","XR", XR(int));
	fprintf(stderr," %s %10lX ","XS", XS(int));
	fprintf(stderr,"\n");
	fprintf(stderr,"compsp %10u",compsp);
	fprintf(stderr,"  osisp %10u", osisp);
	fprintf(stderr," LOWSPMIN %u\n", LOWSPMIN);
	/*tracer();*/
#endif
}
void Trace(char * type, char * text) 
{
#ifdef TRACE
	fprintf(stderr,"%s %s\n", type, text);
#endif
}
void At(char * text)
{
#ifdef TRACE
	Trace("At", text);
#endif
}
void Enter(char * text) {
#ifdef TRACE
	Trace("Enter", text);
#endif
}
void Exit(char * text) 
{
#ifdef TRACE
	Trace("Exit", text);
#endif
}
#ifdef TRACE
void shields() 
{
}
void tracer()
{
	fprintf(stderr, "Tracer \n");
	fprintf(stderr, "nlines %8d " , nlines);
	fprintf(stderr, "call_id %5d ", id_call);
	fprintf(stderr,"compsp %10u",compsp);
	fprintf(stderr,"  osisp %10u", osisp);
	fprintf(stderr," LOWSPMIN %u\n", LOWSPMIN);
}
#endif
