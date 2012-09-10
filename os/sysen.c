/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012 David Shields

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
        zysen - endfile

        endfile is an artifact from the FORTRAN days and is supposed to
        close a file.  However, the file may be reopened, etc.  We just
        close it.

        Parameters:
            WA - FCBLK pointer or 0
            XR - SCBLK pointer (ENDFILE argument)
        Returns:
            Nothing
        Exits:
            1 - file does not exist
            2 - inappropriate file
            3 - i/o error
*/

#include "port.h"
#include "os.h"

zysen()
{
    REGISTER struct fcblk *fcb = WA(struct fcblk *);
    REGISTER struct ioblk *iob = MK_MP(fcb->iob, struct ioblk *);

    Enter("zysen");
    /* ensure the file is open */
    if (!(iob->flg1 & IO_OPN)) {
        Exit("zysen");
	return EXIT_1;
    }

    /* now close it */
    if (osclose(iob)) {
        Exit("zysen");
	return EXIT_3;
    }
    Exit("zysen");
    return NORMAL_RETURN;
}
