/*
/   The following manifest constants define the target hardware platform
/   and tool chain.
/
/               running on a:
/   BCC32       Intel 32-bit x86, Borland C++ compiler (Windows command line)
/   VCC         Intel 32-bit x86, Microsoft Visual C (Windows command line)
/   GCCi32      Intel 32-bit x86, GNU GCC
/   GCCi64      Intel 64-bit x86, GNU GCC
/   RS6         IBM RS6000 (Power)
/   SUN4        SPARC, SUN4
/
/   The following manifest constants define the target operating system.
/
/   AIX3        AIX version 3
/   AIX4        AIX version 4
/   BSD43       Berkeley release: BSD 4.3
/   LINUX       Linux
/   SOLARIS     Sun Solaris
/   WINNT       Windows NT/XP/Vista
/
*/
/*  Copyright 2009 Robert Goldberg and Catspaw, Inc. */

/* Override default values in port.h.  It is necessary for a user configuring
 * SPITBOL to examine all the default values in port.h and override those
 * that need to be altered.
 */
/*  Values for x86 Linux 32-bit SPITBOL.
 *  Copyright 2009 Robert Goldberg and Catspaw, Inc.
 */
#define EXECFILE    0
#define FLTHDWR     0   /* Change to 1 when do floating ops inline */
#define GCCi32      1
#define LINUX       1
#define SAVEFILE    1


