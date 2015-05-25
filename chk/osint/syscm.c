/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2013 David Shields

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
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:  SYSCM.C		Version:  01.01
/	---------------------------------------
/
/	zyscm - string compare
/
*/

/*
/
/	zyscm is called to make either a strict ASCII or INTERNATIONAL comparison.
/
/	This external routine is provided to allow conditional access to
/	an alternate collation sequence.  Access is
/	controlled by the global switch IUSTRG.
/
/	Parameters:
/		XR - pointer to first string
/		WB - first string length
/		XL - pointer to second string
/		WA - second string length
/	Returns
/		XL = 0
/	Exits:
/		1 - string length exceeded capability of international comparison routine
/		2 - 2nd string < 1st string
/		3 - 2nd string > 1st string
/		normal exit - strings equal
/
*/

#include "port.h"
#if ALTCOMP
long *kvcom_ptr;

zyscm()
{
    register word result;

    if (!kvcom_ptr)							// Cheap optimization to speed up
        kvcom_ptr = GET_DATA_OFFSET(KVCOM,long *);	// &COMPARE consultation

    result = gencmp(XL(char *), XR(char *), WA(word), WB(word), *kvcom_ptr);

    SET_XL(0);

    if (result == 0x80000000)
        return EXIT_1;
    else if (result == 0)
        return NORMAL_RETURN;
    else if (result < 0)
        return EXIT_2;
    else
        return EXIT_3;
}
#endif					// ALTCOMP
