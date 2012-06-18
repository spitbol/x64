/*
/	File:  FAKEXIT.C	Version:  01.00
/	---------------------------------------
/
/	Contents:	Function exit
*/
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */

/*
/   exit()
/
/   This is a "fake" exit() function that prevents the linker from linking
/   in the standard C exit() function with all the associated stdio library
/   functions.
*/
#include "port.h"
#if !VCC
void exit(status)
int status;
{}
#endif

extern void _exit Params((int status));
#if WINNT | AIX
extern void exit_custom Params((int code));
#endif

void __exit(code)
int code;
{
#if WINNT | AIX
    exit_custom(code);				/* Perform system specific shutdown */
#endif

    _exit(code);
}
