/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields
*/

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

#include "port.h"

#if FLOAT
# if FLTHDWR
int
checkfpu(void)
{
    return -1; /* Hardware flting pt always present */
}
# else /* FLTHDWR */
int
checkfpu(void)
{
    return -1; /* Assume all modern machines have FPU (excludes 80386 without
                  80387) */
}

# endif /* FLTHDWR */
#endif  /* FLOAT */
