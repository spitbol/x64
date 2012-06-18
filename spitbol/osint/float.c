/*
 * float.c - floating point support for spitbol
 *
 * These routines are not called from other C routines.  Rather they
 * are called by inter.*, and by external functions.
 */
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */
#include "port.h"
#if (FLOAT & !FLTHDWR) | (EXTFUN & (SUN4 | AIX))

/*
 * f_2_i - float to integer
 */
IATYPE f_2_i(ra)
double ra;
{
    return (IATYPE)ra;
}


/*
 * i_2_f - integer to float
 */
double i_2_f(ia)
IATYPE ia;
{
    return ia;
}

/*
 * f_add - floating add to accumulator
 */
double f_add(arg, ra)
double arg,ra;
{
    return ra+arg;
}

/*
 * f_sub - floating subtract from accumulator
 */
double f_sub(arg, ra)
double arg,ra;
{
    return ra-arg;
}

/*
 * f_mul - floating multiply to accumulator
 */
double f_mul(arg, ra)
double arg,ra;
{
    return ra*arg;
}


/*
 * f_div - floating divide into accumulator
 */
double f_div(arg, ra)
double arg,ra;
{
    return ra/arg;
}

/*
 * f_neg - negate accumulator
 */
double f_neg(ra)
double ra;
{
    return -ra;
}

#endif					/* (FLOAT & !FLTHDWR) | (EXTFUN & (SUN4 | AIX)) */
