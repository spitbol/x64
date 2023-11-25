
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields
*/

/*
 * math.c - extended math support for spitbol
 *
 * Routines not provided by hardware floating point.
 *
 * These routines are not called from other C routines.  Rather they
 * are called by inter.*, and by external functions.
 */

#include <errno.h>

#include <math.h>
#include <xmmintrin.h>

#include "port.h"

#ifndef errno
int errno;
# endif

extern double inf;     /* infinity */
extern word reg_flerr; /* Floating point error */

/*
 * f_atn - arctangent
 */
void
f_atn(void)
{
    unsigned int mxcsr;

    reg_ra = atan(reg_ra);
    mxcsr = _mm_getcsr();
    if(mxcsr & _MM_EXCEPT_UNDERFLOW)
        reg_ra = 0;
}

/*
 * f_chp - chop
 */
void
f_chp(void)
{
    if(reg_ra >= 0.0)
        reg_ra = floor(reg_ra);
    else
        reg_ra = ceil(reg_ra);
}

/*
 * f_cos - cosine
 */
void
f_cos(void)
{
    unsigned int mxcsr;
    reg_ra = cos(reg_ra);
    mxcsr = _mm_getcsr();
    if(mxcsr & _MM_EXCEPT_UNDERFLOW)
        reg_ra = 0;
}

/*
 * f_etx - e to the x
 */
void
f_etx(void)
{
    unsigned int mxcsr;
    errno = 0;
    reg_ra = exp(reg_ra);
    mxcsr = _mm_getcsr();
    if(mxcsr & _MM_EXCEPT_UNDERFLOW)
        reg_ra = 0;
    else if(errno)
        reg_ra = inf;
}

/*
 * f_lnf - natureg_ral log
 */
void
f_lnf(void)
{
    unsigned int mxcsr;
    errno = 0;

    reg_ra = log(reg_ra);
    mxcsr = _mm_getcsr();
    if(mxcsr & _MM_EXCEPT_UNDERFLOW)
        reg_ra = 0;
    else if(errno)
        reg_ra = inf;
}

/*
 * f_sin - sine
 */
void
f_sin(void)
{
    unsigned int mxcsr;
    reg_ra = sin(reg_ra);
    mxcsr = _mm_getcsr();
    if(mxcsr & _MM_EXCEPT_UNDERFLOW)
        reg_ra = 0;
}

/*
 * f_sqr - square root  (reg_range checked by caller)
 */
void
f_sqr(void)
{
    unsigned int mxcsr;
    reg_ra = sqrt(reg_ra);
    mxcsr = _mm_getcsr();
    if(mxcsr & _MM_EXCEPT_UNDERFLOW)
        reg_ra = 0;
}

/*
 * f_tan - tangent
 */
void
f_tan(void)
{
    unsigned int mxcsr;
    errno = 0;
    reg_ra = tan(reg_ra);
    mxcsr = _mm_getcsr();
    if(mxcsr & _MM_EXCEPT_UNDERFLOW)
        reg_ra = 0;
    else if(errno)
        reg_ra = inf;
}
