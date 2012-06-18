/*
/	File:  SYSTM.C		Version:  01.03
/	---------------------------------------
/
/	Contents:	Function zystm
*/
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */

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
/	v1.03	27-May-95	For AIX, corrected use of tms_utime.  Was
/						multiplying by 100 / 6.  Should be 1000/CLK_TCK.
/						Was running fast by factor of 1.6.
*/

#include "port.h"

#if WINNT
extern long msec( void );
#else         /* WINNT */
#include <sys/types.h>
#include <sys/times.h>
#if AIX
#include <time.h>		/* pick up CLK_TCK definition (100) */
#endif
#if SOLARIS
#include <sys/param.h>		/* pick up HZ definition (60) */
#define CLK_TCK HZ
#endif
#endif          /* WINNT */
#if LINUX
#include <sys/times.h>
#define CLK_TCK sysconf(_SC_CLK_TCK)
#endif

zystm()
{
    /*
    /	process times are in 60ths of second, multiply by 100
    /	to get 6000ths of second, divide by 6 to get 100ths
    */
#if WINNT
    SET_IA( msec() );
#else
    struct tms	timebuf;

    timebuf.tms_utime = 0;	/* be sure to init in case failure	*/
    times( &timebuf );	/* get process times			*/

    /* CLK_TCK is clock ticks/second:
     * # of seconds = tms_utime / CLK_TCK
     * # of milliseconds = tms_utime * 1000 / CLK_TCK
     *
     * To avoid overflow, use
     * # of milliseconds = tms_utime * (1000/10) / (CLK_TCK / 10)
     */
    SET_IA( (timebuf.tms_utime * (1000/10)) / (CLK_TCK/10) );
#endif
    return NORMAL_RETURN;
}

