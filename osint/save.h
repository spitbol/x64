/*
copyright 1987-2012 robert b. k. dewar and mark emmer.

this file is part of macro spitbol.

    macro spitbol is free software: you can redistribute it and/or modify
    it under the terms of the gnu general public license as published by
    the free software foundation, either version 3 of the license, or
    (at your option) any later version.

    macro spitbol is distributed in the hope that it will be useful,
    but without any warranty; without even the implied warranty of
    merchantability or fitness for a particular purpose.  see the
    gnu general public license for more details.

    you should have received a copy of the gnu general public license
    along with macro spitbol.  if not, see <http://www.gnu.org/licenses/>.
*/

/*
/	file:   save.h           version 1.01
/	-------------------------------------
/
/	this header file provides information for writing the impure
/	portions of spitbol's data segments to a save file.
/
/ v1.01 3-jun-91 mbe
/	added memincb, maxsize, readshell0 & uarg to header, and
/	additional argument to specify whether these values should
/	override existing values, as would be the case for the
/	intel ms-dos version, where save files are used to simulate
/	exec files.
/
*/
#if savefile
/*
 * +--------2--------+--------2--------+---------4---------+
 * |                 |                 |                   |
 * |     ia size     |    word size    | save file version |
 * |                 |                 |                   |
 * +-----------------+-----------------+-------------------+
 *
 * ia (integer accumulator) and minimal word size:
 *  0 - 16 bits
 *  1 - 32 bits
 *  2 - 64 bits
 *  3 - 128 bits
 */
#define vwbshft     4
#define viashft     (vwbshft+2)
#define version     5
#define saveversion ((unsigned char)(version+((wordbits/32)<<vwbshft)+(iabits/32)<<viashft))
#define uargsize    128

struct svfilehdr {
    unsigned long   magic1;         /* recognizer for object file           */
    unsigned long   magic2;         /* line terminators                     */
    unsigned char   version;        /* version of runtime needed            */
    unsigned char   system;         /* system version                       */
    short int       spare;          /* spare cells to dword boundary        */
    char            serial[8];      /* compiler serial number               */
    char            headv[8];       /* version string                       */
    char            iov[12];        /* i/o version string                   */
    unsigned long   timedate;       /* date and time of creation            */
    long            flags;          /* spitflag word                        */
    uword           stacksiz;       /* total size of stack area             */
    char            *stbas;         /* base of stack at save time           */
    uword           stacklength;    /* size of stack area in use            */
    uword           sec3size;       /* size of constant section             */
    char            *sec3adr;       /* address of constant section          */
    uword           sec4size;       /* size of work section                 */
    char            *sec4adr;       /* address of work section              */
    uword           statoff;        /* static offset=hshtb-basemem          */
    uword           dynoff;         /* dynamic offset=dnamb-basemem         */
    uword           heapsize;       /* size of heap after collection        */
    char            *heapadr;       /* address of heap                      */
    char            *topmem;        /* previous top of heap                 */
    uword           databts;        /* largest allowed size of heap         */
    uword           sec5size;       /* size of spitbol code                 */
    char            *sec5adr;       /* address of spitbol code              */
    uword           memincb;        /* memory increment size                */
    uword           maxsize;        /* maximum object size                  */
    word            compress;       /* 0 = no compress,                     */
    /* >0 = code word size (bits)           */
    word            uarglen;        /* length of -u command string          */
};

#define ourmagic1   0xfaa5a5fa
#define ourmagic2   0x0d0a0d0a
#endif					/* savefile */

#if winnt
#define	pagesize	4096
#define l2pgsz		12		/* log base 2 of page size */
#endif

#if sun4
#define	pagesize	pagsiz
#define t_start     segsiz   /* n_magic, no dynamic loading */
#endif					/* sun4 */

