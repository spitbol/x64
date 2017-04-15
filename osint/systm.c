/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2013 David Shields
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
//#define CLK_TCK sysconf(_SC_CLK_TCK)
//
#define CLK_TCK 100


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

