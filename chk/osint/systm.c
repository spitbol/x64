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

#ifdef old
#include <sys/times.h>
#define CLK_TCK sysconf(_SC_CLK_TCK)

zystm() {

    /*
    /	process times are in 60ths of second, multiply by 100
    /	to get 6000ths of second, divide by 6 to get 100ths
    */
    struct tms	timebuf;

    timebuf.tms_utime = 0;	// be sure to init in case failure
    times( &timebuf );	// get process times

    /* CLK_TCK is clock ticks/second:
     * # of seconds = tms_utime / CLK_TCK
     * # of milliseconds = tms_utime * 1000 / CLK_TCK
     *
     * To avoid overflow, use
     * # of milliseconds = tms_utime * (1000/10) / (CLK_TCK / 10)
     */
    SET_IA( (timebuf.tms_utime * (1000/10)) / (CLK_TCK/10) );
    return NORMAL_RETURN;
}
#endif

zystm() {

    SET_IA( 600);
    return NORMAL_RETURN;
}
