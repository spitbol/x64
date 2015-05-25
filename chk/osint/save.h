/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2015 David Shields

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/	File:   SAVE.H           Version 1.01
/	-------------------------------------
/
/	This header file provides information for writing the impure
/	portions of SPITBOL's data segments to a save file.
/
/ v1.01 3-Jun-91 MBE
/	Added memincb, maxsize, readshell0 & uarg to header, and
/	additional argument to specify whether these values should
/	override existing values, as would be the case for the
/	Intel MS-DOS version, where Save files are used to simulate
/	Exec files.
/
*/
/*
 * +--------2--------+--------2--------+---------4---------+
 * |                 |                 |                   |
 * |     IA size     |    WORD size    | Save File Version |
 * |                 |                 |                   |
 * +-----------------+-----------------+-------------------+
 *
 * IA (integer accumulator) and Minimal Word Size:
 *  0 - 16 bits
 *  1 - 32 bits
 *  2 - 64 bits
 *  3 - 128 bits
 */
#define VWBSHFT     4
#define VIASHFT     (VWBSHFT+2)
#define VERSION     5
#define SaveVersion ((unsigned char)(VERSION+((WORDBITS/32)<<VWBSHFT)+(IABITS/32)<<VIASHFT))
#define UargSize    128

struct svfilehdr {
    unsigned long   magic1;         // recognizer for object file
    unsigned long   magic2;         // line terminators
    unsigned char   version;        // version of runtime needed
    unsigned char   system;         // system version
    short int       spare;          // spare cells to dword boundary
    char            serial[8];      // compiler serial number
    char            headv[8];       // version string
    char            iov[12];        // i/o version string
    unsigned long   timedate;       // date and time of creation
    long            flags;          // spitflag word
    uword           stacksiz;       // total size of stack area
    char            *stbas;         // base of stack at save time
    uword           stacklength;    // size of stack area in use
    uword           sec3size;       // size of constant section
    char            *sec3adr;       // address of constant section
    uword           sec4size;       // size of work section
    char            *sec4adr;       // address of work section
    uword           statoff;        // static offset=hshtb-basemem
    uword           dynoff;         // dynamic offset=dnamb-basemem
    uword           heapsize;       // size of heap after collection
    char            *heapadr;       // address of heap
    char            *topmem;        // previous top of heap
    uword           databts;        // largest allowed size of heap
    uword           sec5size;       // size of SPITBOL code
    char            *sec5adr;       // address of SPITBOL code
    uword           memincb;        // memory increment size
    uword           maxsize;        // maximum object size
    word            compress;       // 0 = no compress,
    // >0 = code word size (bits)
    word            uarglen;        // length of -u command string
};

#define OURMAGIC1   0xfaa5a5fa
#define OURMAGIC2   0x0d0a0d0a
