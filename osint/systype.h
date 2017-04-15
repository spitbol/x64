/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2013 David Shields
*/

/*
/   The following manifest constants define the target hardware platform
/   and tool chain.
/
/   GCCi32      Intel 32-bit x86, GNU GCC
/   GCCi64      Intel 64-bit x86, GNU GCC
/
*/

/* Override default values in port.h.  It is necessary for a user configuring
 * SPITBOL to examine all the default values in port.h and override those
 * that need to be altered.
 */
/*  Values for x86 Linux 32-bit SPITBOL.
 */
#define EXECFILE    0
#define FLTHDWR     0   // Change to 1 when do floating ops inline
#define GCCi32      1
