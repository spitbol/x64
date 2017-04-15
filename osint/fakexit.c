/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2013 David Shields
*/

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

extern void _exit (int status);

void __exit(code)
int code;
{
    _exit(code);
}
