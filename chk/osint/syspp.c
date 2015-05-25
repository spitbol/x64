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
/   zyspp - obtain print parameters
*/

#include "port.h"

zyspp()

{
    /*
    /   Set default case flag here; cannot set before starting up
    /   compiler because of its clearing of its local data.
    */
    /*
    /   Set page width, lines per page, and compiler flags.
    */

    SET_WA( pagewdth );
    SET_WB( lnsppage );
    SET_WC( spitflag );

    return NORMAL_RETURN;
}
