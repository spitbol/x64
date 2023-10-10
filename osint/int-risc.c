
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2015 David Shields
*/

/*
 * int.c - integer support for SPITBOL.
 *
 * Needed for RISC systems that do not provide integer multiply/
 * divide in hardware.
 */

#include "port.h"

#if SUN4

typedef long i;

/*
 * i_mli - multiply to accumulator
 */
i
i_mli(i arg, i ia)
{
    return ia * arg;
}

/*
 * i_dvi - divide into accumulator
 */
i
i_dvi(i arg, i ia)
{
    return ia / arg;
}

/*
 * i_rmi - remainder after division into accumulator
 */
i
i_rmi(i arg, i ia;)
{
    return ia % arg;
}

#endif /* SUN4 */
