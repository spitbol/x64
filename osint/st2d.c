
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields
*/

/* st2d.c - convert integer to decimal string */

#include "port.h"

static int stc_d(char *out, unsigned int in, int outlen, int signflag);

static int
stc_d(char *out, unsigned int in, int outlen, int signflag)
{
    char revnum[20];
    int i = 0;
    char *out0 = out;

    if(outlen <= 0)
        return (0);

    if(in == 0)
        revnum[i++] = 0;
    else
        while(in) {
            revnum[i++] = in - (in / 10) * 10;
            in /= 10;
        }

    if(signflag) {
        *out++ = '-';
        outlen--;
    }

    for(; i && outlen; i--, outlen--)
        *out++ = revnum[i - 1] + '0';

    *out = '\0';

    return (out - out0);
}

int
stcu_d(char *out, unsigned int in, int outlen)
{
    return (stc_d(out, in, outlen, 0));
}
