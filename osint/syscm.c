/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields
*/

/*
/	zyscm - string compare
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

int zyscm()
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
