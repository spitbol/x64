/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2013 David Shields

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
/   File:  SPITIO.H     Version:  01.09
/   -------------------------------------------
/
/   This header file defines the I/O control blocks used by the
/   operating system interface for the Macro Spitbol compiler.
/
/  V1.09 27-Apr-97 Add FILEPOS definition.
/  V1.08 26-Oct-94 Add "share" word to ioblk to allow file sharing
/			options.  Also, in the bfblk, change buf[1] to buf[sizeof(word)]
/			so that BFSIZE is calculated properly with compilers that
/			round-up the size of a structure to a word-multiple.
/	V1.07	01-Aug-93 Add IO_EOT flag to ignore EOT char in DOS-mode text files.
/	V1.06	01-Feb-93 Split record size into two fields (rsz and mode) in fcb, to
/			prevent negative record size appearing to be a valid
/			pointer in 8088 SPITBOL.
/	V1.05	Add IO_DIR, change definitions in bfblk to
/			accommodate read/write files.
/	V1.04	Split IOBLK flags into two words
/	V1.03	Add IO_COT flag from MS-DOS
/	V1.02	Split RECSIZ into IRECSIZ and ORECSIZ
*/

// Size of file position words in I/O buffer block
#if SETREAL
typedef double FILEPOS;     // real file positions
#else
typedef long FILEPOS;       // 32-bit file positions
#endif

/*
/   BLBLK - I/O buffer block
/
/   All buffered I/O is passed through a BFBLK.  This block is intentionally
/   kept non-relocatable, so that it can be freely moved around the heap by
/   the garbage collector.
/
/	WARNING:  INPBUF and TTYBUF are manually assembled into inter.asm and
/			  inter.s, and must be changed in all versions if this structure
/			  is altered.
*/

struct bfblk
{
    word typ;       //  type word
    word len;       //  length of bfblk
    word size;      //  size of buffer in bytes
    word fill;      //  number of bytes currently in buffer
    word next;      //  next buffer position to read/write
    FILEPOS offset; //  file position of first byte in buf
    FILEPOS curpos; //  physical file position
    char	buf[sizeof(word)]; // buffer ([sizeof(word)] is kludge for C)
};

#define BFSIZE		(sizeof( struct bfblk ) - sizeof( word ))

/*
/   FCBLK - file control block (type XRBLK)
/
/   For every I/O association a FCBLK is created.  All subsequent I/O
/   operations are passed this block.
*/

struct fcblk
{
    word	typ;			//  type word
    word	len;			//  length of fcblk
    word	rsz;			//  record size
    struct ioblk *iob;	//  pointer to IOBLK
    word	mode;			//  1=line mode, 0 = raw mode
};

#define FCSIZE		(sizeof( struct fcblk ))

/*
/   IOBLK - I/O control block (type XRBLK)
/
/   For every SPITBOL I/O channel there is one central IOBLK containing
/   information about the channel:  filename, file descriptor, IOBLK
/   pointer, etc.
/
/   Because IOBLK is an XRBLK, and hence relocatable, all words in
/   the block must be relocatable pointers, or smaller than MXLEN.
/   Systems using 16-bit words typically use small MXLENs, and
/   may cause values in the flg word to be mis-interpreted as pointers.
/   For this reason, I/O flags will be split across two words.
/
*/

struct ioblk
{
    word	typ;			//  type word
    word	len;			//  length of IOBLK
    struct scblk *fnm;	//  pointer to SCBLK holding filename
    word	pid;			//  process id for pipe
    struct bfblk *bfb;	//  pointer to BFBLK (type XNBLK)
    word	fdn;			//  file descriptor number
    word	flg1;			//  first nine flags
    word	flg2;			//  second nine flags
    word	share;			//	sharing mode
    word	action;			//  file open actions
};

#define IOSIZE		(sizeof( struct ioblk ))

/*
 *  I/O flags within the flg1 and flg2 words of an IOBLK.
 *
 *  Caution:  Do not attempt to redefine as C bit fields.  Bit fields
 *  may be assigned to high-order bits on some systems, and this would
 *  produce values larger than MXLEN.
 */
// Flags in flg1
#define IO_INP		0x00000001	// file open for reading
#define IO_OUP		0x00000002	// file open for writing
#define IO_APP		0x00000004	// append output to existing file
#define IO_OPN		0x00000008	// file is open
#define IO_COT		0x00000010	// console output to non-disk device
#define IO_CIN		0x00000020	// console input from non-disk device
#define IO_SYS		0x00000040	// -f option used instead of name
#define IO_WRC		0x00000080	// output without buffering
// IO_EOT only needed for DOS so is not used/supported for Linux.
//# define IO_EOT		0x00000100	// Ignore end-of-text (control-Z) char


// Flags in flg2
#define IO_PIP		0x00000001	// pipe
#define IO_DED		0x00000002	// dead pipe
#define IO_ILL		0x00000004	// illegal I/O association
#define	IO_RAW		0x00000008	// binary I/O to TTY device
#define	IO_LF		0x00000010	// Ignore eol2 if next character (pipes only)
#define IO_NOE		0x00000020	// no echo input
#define IO_ENV		0x00000040	// filearg1 maps to filename thru environment var
#define IO_DIR		0x00000080	// buffer is dirty (needs to be written)
#define IO_BIN		0x00000100	// last fcb to open file used raw mode

#ifndef	 IRECSIZ
#define  IRECSIZ	1024		// input line length
#endif

#define  ORECSIZ	((word)MAXPOSWORD)	// output line length

#define  IOBUFSIZ	1024

// Private flags used to convey sharing status when opening a file
#define IO_COMPATIBILITY	0x00
#define IO_DENY_READWRITE	0x01
#define IO_DENY_WRITE		0x02
#define IO_DENY_READ		0x03
#define IO_DENY_NONE		0x04
#define IO_DENY_MASK		0x07		// mask for above deny mode bits
#define	IO_EXECUTABLE		0x40		// file to be marked executable
#define IO_PRIVATE			0x80		// file is private to current process

// Private flags used to convey file open actions
#define IO_FAIL_IF_EXISTS		0x00	// file exists -- fail
#define IO_OPEN_IF_EXISTS		0x01    // file exists -- open
#define IO_REPLACE_IF_EXISTS	0x02    // file exists -- open and truncate
#define IO_FAIL_IF_NOT_EXIST	0x00	// file does not exist -- fail
#define IO_CREATE_IF_NOT_EXIST	0x10    // file does not exist -- create it
#define IO_EXIST_ACTION_MASK	0x13	// mask for above bits
#define IO_WRITE_THRU       	0x20	// writes complete before return
