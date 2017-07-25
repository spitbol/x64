/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields

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
