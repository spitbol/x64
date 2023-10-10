
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields

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
    along with Macro SPITBOL.  If not, see www.gnu.org/licenses.
*/

/*
 * float.c - floating point support for spitbol
 *
 * These routines are not called from other C routines.  Rather they
 * are called by inter.*, and by external functions.
 */

#include "port.h"
#include <fenv.h>
#include <math.h>
#define FE_SBL_EXCEPT (FE_INVALID | FE_DIVBYZERO | FE_OVERFLOW | FE_UNDERFLOW)

#if(FLOAT & !FLTHDWR) | EXTFUN

# if 0
/* overflow codes */
/* OF = 0x80 */
/* cf = 0x01 */
/* zr = 0x40 */

void
f_ldr(void)
{ /* load real */
    reg_ra = *reg_rp;
    return;
}

void
f_str(void)
{ /* store real */
    *reg_rp = reg_ra;
    return;
}

void
f_adr()
{ /* add real */
    feclearexcept(FE_ALL_EXCEPT);
    reg_ra += *reg_rp;
    reg_flerr = fetestexcept(FE_SBL_EXCEPT);
    return;
}

void
f_sbr(void)
{ /* subtract real */
    feclearexcept(FE_ALL_EXCEPT);
    reg_ra -= *reg_rp;
    reg_flerr = fetestexcept(FE_SBL_EXCEPT);
    return;
}

void
f_mlr(void)
{ /* multiply real */
    feclearexcept(FE_ALL_EXCEPT);
    reg_ra *= *reg_rp;
    reg_flerr = fetestexcept(FE_SBL_EXCEPT);
    return;
}

void
f_dvr(void)
{ /* divide real */
    feclearexcept(FE_ALL_EXCEPT);
    if(*reg_rp != 0.0) {
        reg_ra /= *reg_rp;
        reg_flerr = fetestexcept(FE_SBL_EXCEPT);
    } else {
        reg_ra = NAN;
        reg_flerr = FE_DIVBYZERO;
    }
    return;
}

void
f_cpr(void)
{
    if(reg_ra == 0.0)
        reg_fl = 0;
    else if(reg_ra < 0.0)
        reg_fl = -1;
    else
        reg_fl = 1;
}

void
f_pra(void)
{}

void
i_cvd(void)
{
    reg_wa = reg_ia % 10;
    reg_ia /= 10;
    reg_wa = -reg_wa + '0'; /* convert remainder to character code for digit */
}
# endif
#endif /* (FLOAT & !FLTHDWR) | EXTFUN */
