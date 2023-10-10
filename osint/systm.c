
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields
*/

/*
/    zystm - get execution time so far
/
/    zystm is called to obtain the amount of execution time used so far
/    since spitbol began execution.  The returned value is assumed to be
/    in microseonds, except for 16-bit implementations, which return deciseconds.
/
/    Parameters:
/        None
/    Returns:
/        IA - execution time so far in microseconds or deciseconds.
/
*/

#include "port.h"
#include "time.h"
#include <sys/times.h>

/*#define CLK_TCK sysconf(_SC_CLK_TCK) */

/* */
#define CLK_TCK 100

int
zystm()
{

    struct timespec tim;
    long etime;

    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &tim);

    etime = (long)(tim.tv_sec * 1000000000) + (long)(tim.tv_nsec);
    SET_IA(etime);
    return NORMAL_RETURN;
}
