/* st2d.c - convert integer to decimal string */
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */

#include "port.h"

static int stc_d Params((char *out, unsigned int in, int outlen, int signflag));

static int stc_d(out, in, outlen, signflag)
register char *out;
register unsigned int in;
register int outlen;
int signflag;
{
char revnum [20];
register int i=0;
register char *out0 = out;

	if (outlen<=0) return (0);

	if (in == 0) revnum[i++]=0;
	else
		while (in)
		{
			revnum[i++] = in - (in/10)*10;
			in /= 10;
		}

	if (signflag)
	{
		*out++ = '-';
		outlen--;
	}

	for (; i && outlen; i--, outlen--)
		*out++ = revnum[i-1] + '0';

	*out = '\0';

	return (out-out0);

}


int
stcu_d(out, in, outlen)
char *out;
unsigned int in;
int outlen;
{
	return (stc_d(out, in, outlen, 0));
}
