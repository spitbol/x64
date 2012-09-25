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
extern int koshka;
extern int nlines;
extern int id_call;
extern int compsp;
extern int osisp;
extern int LOWSPMIN;

int at_xl;
int at_xr;
int at_xs;
int at_wa;
int at_wb;
int at_wc;
int at_cp;
#undef NOTRACE
#define TRACE
void atmsg() {
	fprintf(stderr,"atmsg\n");
}
void
atip(unsigned int ip,int line) {
	fprintf(stderr, "ip=0x%x line %d\n",ip,line);
	fprintf(stderr,"xl %8x  xr %8x  xs %8x  wa %8x wb %8x wc %8x cp %8x\n",
	 at_xl,at_xr,at_xs,at_wa,at_wb,at_wc,at_cp);
}
atlin()
{
#ifdef TRACE
	fprintf(stderr, "at line %d\n",nlines);
	regdump();
#endif
}

rp(char * name,uword reg)
/* print register name and vaue */
{
#ifdef TRACE
	fprintf(stderr," %s %8u ",name, reg);
	fprintf(stderr," %s %8u ",name, reg);
#endif
}

regdump()
{
#ifdef TRACE
	fprintf(stderr," nlines %d\n",nlines);
	fprintf(stderr, "koshka %d\n",koshka);
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
