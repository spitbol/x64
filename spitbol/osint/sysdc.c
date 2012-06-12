/*
/	zysdc - check system expiration date
/
/	zysdc prints any header messages and may check
/	the date to see if execution is allowed to proceed.
/
/	Parameters:
/	    Nothing
/	Returns
/	    Nothing
/	    No return if execution not permitted
/
*/
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */

#include "port.h"

zysdc()
{
  struct scblk *pHEADV = GET_DATA_OFFSET(HEADV,struct scblk *);
	/* announce name and copyright */
	if (!dcdone && !(spitflag & NOBRAG))
	{
		dcdone = 1;				/* Only do once per run */
#if WINNT
		write( STDERRFD, "SPITBOL-386", 11);
#endif

#if SUN4
		write( STDERRFD, "SPARC SPITBOL", 13);
#endif          /* SUN4 */

#if LINUX
		write( STDERRFD, "LINUX SPITBOL", 13);
#endif

#if AIX
		write( STDERRFD, "AIX SPITBOL", 11);
#endif

#if RUNTIME
		write( STDERRFD, " Runtime", 8);
#endif					/* RUNTIME */

		write( STDERRFD, "   Release ", 11);
		write( STDERRFD, pHEADV->str, pHEADV->len );
		write( STDERRFD, pID1->str, pID1->len );
		write( STDERRFD, "   Serial ", 10 );
		wrterr( SERIAL );
		wrterr( cprtmsg );
	}

#if DATECHECK
#if WINNT
   {
      extern void date_check(void);
      date_check();
   }
#endif
#endif
		return NORMAL_RETURN;
}
