/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields
*/

/*
/	File:  SYSGC.C		Version:  01.01
/	---------------------------------------
/
/	zysgc - notification of system garbage collection
/
/	zysgc is called before and after a garbage collection.
/	Some systems may wish to take special action using this information.
/
/	Parameters:
/	    XR - flag for garbage collection
/		 <>0 garbage collection commencing
/		 =0  garbage collection concluding
/		WA - starting location of dynamic area
/		WB - next available location
/		WC - last available location
/	Returns
/	    Nothing
/	    Preserves all registers
*/

#include "port.h"
#include "save.h"

int zysgc()
{
    in_gbcol = XR(word);  // retain information
    return NORMAL_RETURN;
}
