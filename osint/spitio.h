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
/   file:  spitio.h     version:  01.09
/   -------------------------------------------
/
/   this header file defines the i/o control blocks used by the
/   operating system interface for the macro spitbol compiler.
/
/  v1.09 27-apr-97 add filepos definition.
/  v1.08 26-oct-94 add "share" word to ioblk to allow file sharing
/			options.  also, in the bfblk, change buf[1] to buf[sizeof(word)]
/			so that bfsize is calculated properly with compilers that
/			round-up the size of a structure to a word-multiple.
/	v1.07	01-aug-93 add io_eot flag to ignore eot char in dos-mode text files.
/	v1.06	01-feb-93 split record size into two fields (rsz and mode) in fcb, to
/			prevent negative record size appearing to be a valid
/			pointer in 8088 spitbol.
/	v1.05	add io_dir, change definitions in bfblk to
/			accommodate read/write files.
/	v1.04	split ioblk flags into two words
/	v1.03	add io_cot flag from ms-dos
/	v1.02	split recsiz into irecsiz and orecsiz
*/

/* size of file position words in i/o buffer block */
#if setreal
typedef double filepos;     /* real file positions */
#else
typedef long filepos;       /* 32-bit file positions */
#endif

/*
/   blblk - i/o buffer block
/
/   all buffered i/o is passed through a bfblk.  this block is intentionally
/   kept non-relocatable, so that it can be freely moved around the heap by
/   the garbage collector.
/
/	warning:  inpbuf and ttybuf are manually assembled into inter.asm and
/			  inter.s, and must be changed in all versions if this structure
/			  is altered.
*/

struct bfblk
{
    word typ;       /*  type word           */
    word len;       /*  length of bfblk        */
    word size;      /*  size of buffer in bytes      */
    word fill;      /*  number of bytes currently in buffer   */
    word next;      /*  next buffer position to read/write */
    filepos offset; /*  file position of first byte in buf */
    filepos curpos; /*  physical file position    */
    char	buf[sizeof(word)]; /* buffer ([sizeof(word)] is kludge for c) */
};

#define bfsize		(sizeof( struct bfblk ) - sizeof( word ))

/*
/   fcblk - file control block (type xrblk)
/
/   for every i/o association a fcblk is created.  all subsequent i/o
/   operations are passed this block.
*/

struct fcblk
{
    word	typ;			/*  type word					*/
    word	len;			/*  length of fcblk				*/
    word	rsz;			/*  record size					*/
    struct ioblk near *iob;	/*  pointer to ioblk			*/
    word	mode;			/*  1=line mode, 0 = raw mode	*/
};

#define fcsize		(sizeof( struct fcblk ))

/*
/   ioblk - i/o control block (type xrblk)
/
/   for every spitbol i/o channel there is one central ioblk containing
/   information about the channel:  filename, file descriptor, ioblk
/   pointer, etc.
/
/   because ioblk is an xrblk, and hence relocatable, all words in
/   the block must be relocatable pointers, or smaller than mxlen.
/   systems using 16-bit words typically use small mxlens, and
/   may cause values in the flg word to be mis-interpreted as pointers.
/   for this reason, i/o flags will be split across two words.
/
*/

struct ioblk
{
    word	typ;			/*  type word				*/
    word	len;			/*  length of ioblk			*/
    struct scblk near *fnm;	/*  pointer to scblk holding filename	*/
    word	pid;			/*  process id for pipe			*/
    struct bfblk near *bfb;	/*  pointer to bfblk (type xnblk)	*/
    word	fdn;			/*  file descriptor number		*/
    word	flg1;			/*  first nine flags			*/
    word	flg2;			/*  second nine flags			*/
    word	eol1;			/*  end of line character 1		*/
    word	eol2;			/*  end of line character 2		*/
    word	share;			/*	sharing mode				*/
    word	action;			/*  file open actions			*/
};

#define iosize		(sizeof( struct ioblk ))

/*
 *  i/o flags within the flg1 and flg2 words of an ioblk.
 *
 *  caution:  do not attempt to redefine as c bit fields.  bit fields
 *  may be assigned to high-order bits on some systems, and this would
 *  produce values larger than mxlen.
 */
/* flags in flg1 */
#define io_inp		0x00000001	/* file open for reading */
#define io_oup		0x00000002	/* file open for writing */
#define io_app		0x00000004	/* append output to existing file */
#define io_opn		0x00000008	/* file is open */
#define io_cot		0x00000010	/* console output to non-disk device */
#define io_cin		0x00000020	/* console input from non-disk device */
#define io_sys		0x00000040	/* -f option used instead of name */
#define io_wrc		0x00000080	/* output without buffering */
#define io_eot		0x00000100	/* ignore end-of-text (control-z) char */

/* flags in flg2 */
#define io_pip		0x00000001	/* pipe */
#define io_ded		0x00000002	/* dead pipe */
#define io_ill		0x00000004	/* illegal i/o association */
#define	io_raw		0x00000008	/* binary i/o to tty device */
#define	io_lf		0x00000010	/* ignore eol2 if next character (pipes only) */
#define io_noe		0x00000020	/* no echo input */
#define io_env		0x00000040	/* filearg1 maps to filename thru environment var */
#define io_dir		0x00000080	/* buffer is dirty (needs to be written) */
#define io_bin		0x00000100	/* last fcb to open file used raw mode */

#ifndef	 irecsiz
#define  irecsiz	1024		/* input line length */
#endif

#define  orecsiz	((word)maxposword)	/* output line length */

#define  iobufsiz	1024

/* private flags used to convey sharing status when opening a file */
#define io_compatibility	0x00
#define io_deny_readwrite	0x01
#define io_deny_write		0x02
#define io_deny_read		0x03
#define io_deny_none		0x04
#define io_deny_mask		0x07		/* mask for above deny mode bits*/
#define	io_executable		0x40		/* file to be marked executable */
#define io_private			0x80		/* file is private to current process */

/* private flags used to convey file open actions */
#define io_fail_if_exists		0x00	/* file exists -- fail */
#define io_open_if_exists		0x01    /* file exists -- open */
#define io_replace_if_exists	0x02    /* file exists -- open and truncate */
#define io_fail_if_not_exist	0x00	/* file does not exist -- fail */
#define io_create_if_not_exist	0x10    /* file does not exist -- create it */
#define io_exist_action_mask	0x13	/* mask for above bits */
#define io_write_thru       	0x20	/* writes complete before return*/
