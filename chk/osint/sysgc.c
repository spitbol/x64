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

zysgc()
{
    in_gbcol = XR(word);  // retain information
    return NORMAL_RETURN;
}
