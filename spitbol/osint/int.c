/*
 * int.c - integer support for SPITBOL.
 *
 * Needed for RISC systems that do not provide integer multiply/
 * divide in hardware.
 */
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */
#include "port.h"

#if SUN4

typedef long i;

/*
 * i_mli - multiply to accumulator
 */
i i_mli(arg,ia)
i arg,ia;
{
    return ia * arg;
}


/*
 * i_dvi - divide into accumulator
 */
i i_dvi(arg,ia)
i arg,ia;
{
    return ia / arg;
}

/*
 * i_rmi - remainder after division into accumulator
 */
i i_rmi(arg,ia)
i arg,ia;
{
    return ia % arg;
}

#endif					/* SUN4 */
