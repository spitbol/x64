/*
 * checkfpu - check if floating point hardware is present.
 *
 * Used on those systems where hardware floating point is
 * optional.  On those systems where it is standard, the
 * floating point ops are coded in line, and this module
 * is not linked in.
 *
 * Returns 0 if absent, -1 if present.
 */

/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */

#include "port.h"

#if FLOAT
#if FLTHDWR
checkfpu()
{
    return -1;			/* Hardware flting pt always present */
}
#else					/* FLTHDWR */

#if LINUX | WINNT
checkfpu()
{
    return -1;    /* Assume all modern machines have FPU (excludes 80386 without 80387) */
}
#endif

#if SOLARIS
#include <signal.h>
#include <setjmp.h>

static jmp_buf	env;

void fputrap Params((int sig));

void fputrap(sig)
int sig;
{
    longjmp(env,1);			/* Here if trap occurs */
}

checkfpu()
{
    SigType (*fstat)Params((int));
    int result;

    fstat = signal(SIGEMT,fputrap);	/* Set to trap floating op */
    result = -1;					/* assume floating point present */

    if (!setjmp(env))
        tryfpu();					/* Try a floating point op */
    else
        result = 0;					/* floating point not present */

    signal(SIGEMT, fstat);			/* restore old trap value */
    return result;
}
#endif          /* SOLARIS */
#endif					/* FLTHDWR */
#endif					/* FLOAT */
