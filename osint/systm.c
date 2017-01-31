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
/	File:  SYSTM.C		Version:  01.03
/	---------------------------------------
/
/	Contents:	Function zystm
*/

/*
/	zystm - get execution time so far
/
/	zystm is called to obtain the amount of execution time used so far
/	since spitbol began execution.  The returned value is assumed to be
/	in milliseonds, except for 16-bit implementations, which return deciseconds.
/
/	Parameters:
/	    None
/	Returns:
/	    IA - execution time so far in milliseconds or deciseconds.
/
*/

#include "port.h"

#include <sys/times.h>
#include <unistd.h>

#define CLK_TCK sysconf(_SC_CLK_TCK)

zystm() {

/*
	times returns clock 'ticks', which need to be divided by
	CLK_TCK to get time in seconds. We want user time in 
	milliseconds, so we multiply tick count by 1000 before	
	dividing by CLK_TCK.
*/
    struct tms st_cpu;
    clock_t st_time;

    st_time = (times(&st_cpu) * 1000)  / CLK_TCK;

    SET_IA( st_time );
    return NORMAL_RETURN;
}

