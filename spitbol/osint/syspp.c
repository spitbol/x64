/*
/	File:  SYSPP.C		Version:  01.01
/	---------------------------------------
/
/	Contents:	Function zyspp
*/
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */

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
