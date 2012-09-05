/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
        regdump - list minimal register value


        Parameters:
            Nothing
        Returns
            Nothing
            No return if execution not permitted

*/

#include "port.h"
#include "os.h"
#include "globals.ext"

#include <stdio.h>

extern int nlines;
#ifdef REDUMP
extern	struct regs reg_block;
#endif
regdump()
{
#ifdef REGDUMP
	struct regs {
	unsigned int	reg_wa,
	unsigned int 	reg_wb,
	unsigned int 	reg_wc,
	unsigned int 	reg_xr,
	unsigned int 	reg_xl,
	unsigned int 	reg_cp,
	double 		reg_ra,
	unsigned int	reg_pc,
	unsigned int	reg_pp,
	unsigned int	reg_xs
	};
#endif
	
    printf( "mininal registers line %d\n",nlines);
#ifdef REGDUMP
  	struct regs *rp;  

	rp = &reg_block
	printf("wa \ud\n",	rp->reg_wa);
#endif
}
