/*
/	File:  SYSEA.C		Version:  01.00
/	---------------------------------------
/
/	Contents:	Function zysea
*/
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */

/*
/
/	zysea - error advise
/
/	Here we catch errors before they are printed.
/
/	Parameters:
/	    XR - Error stage
/			if XR = STGIC, STGCE, STGXT then
/				WA - error number (1-330)
/				WB - column number
/				WC - line number
/				XL - scblk containing source file name
/	Returns:
/	    XR - SCBLK of message to print, or 0 if none
/	Exits:
/	    1 - suppress printing of error message
/
/  1.30.20 3/18/2000 - fix bug displaying column number - 1
*/

#include "port.h"

static char *eacpy Params((char *s1, char *s2, int n));

static char *eacpy(s1, s2, n)
char *s1, *s2;
int n;
{
	char *s0 = s1+n;

	while (n--)
		*s1++ = *s2++;
	return s0;
}

/*
 * Error stage states
 */
enum stage {
	STGIC=0,			/* Initial compile				*/
	STGXC,				/* Execution compile (CODE)			*/
	STGEV,				/* Expression eval during execution		*/
	STGXT,				/* Execution time				*/
	STGCE,				/* Initial compile after scanning END line	*/
	STGXE,				/* Execute time compile after scanning END line	*/
	STGEE,				/* EVAL evaluating expression			*/
	STGNO				/* Number of codes				*/
	};

zysea()
{
  register struct scblk *fnscblk = XL(struct scblk *);
	register char *p;


      /* Display file name if present */
			if (fnscblk->len) {
				p = pTSCBLK->str;
				p = eacpy(p, fnscblk->str, (int)fnscblk->len);
				/* Display line number if present */
				if (WC(unsigned int)) {
					*p++ = '(';
					p += stcu_d(p, WC(unsigned int), 16);
					/* Display character position if present */
					if (WB(unsigned int)) {
						*p++ = ',';
            p += stcu_d(p, WB(unsigned int)+1, 16);
						}
					*p++ = ')';
					}
				p = eacpy(p, " : ", 3);
				pTSCBLK->len = p - pTSCBLK->str;
				SET_XR( pTSCBLK );
				return NORMAL_RETURN;
				}
  SET_XR(0L);
	return NORMAL_RETURN;	/* Other errors be processed normally */
}

