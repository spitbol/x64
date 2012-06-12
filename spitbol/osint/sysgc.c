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
/
/  Version history:
/	  v1.01 17-May-91 MBE
/		Add arguments in WA, WB, WC for use in discarding page
/       contents of freed memory on virtual memory systems.
/
*/
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */

#include "port.h"
#include "save.h"

zysgc()
{
  in_gbcol = XR(word);  /* retain information */
	return NORMAL_RETURN;
}
