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
/	File:  SPROTO.H	Version 1.02
/	----------------------------
/
/	Function prototypes for argument type checking.
/	This files are unique to SPITBOL.
*/

#ifndef	_sproto_
#define	_sproto_

typedef int File_handle;
typedef int File_mode;
typedef int Open_method;

extern	union block *	alloc (word nchars);
extern	struct scblk *	alocs (word nchars);
extern	union block *	alost (word nchars);
extern	int			appendext (char *path, char *ext, char *result, int force);
#if EXTFUN
extern  union block *   callef (struct efblk *efb, union block **sp, word nargs);
#endif
extern	int			checkfpu ( void );
extern	int			checksave (char *namep);
extern	int			checkstr ( struct scblk *scp );
extern	int			check2str ( void );
extern	int			check3str ( void );
extern	int			chrdev ( File_handle F );
extern	int			cindev ( File_handle F );
extern	int			cinread ( File_handle fd, char *buf, int size );
extern	void		close_all ( struct chfcb *chb );
extern	word		closeaout ( char *filename, char *tmpfnbuf, word errflag );
extern	void		clrbuf ( void );
extern	int			compress ( unsigned char *startadr, uword size );
extern	void		conv ( char *dest, int value );
extern	int			coutdev ( File_handle F );
extern	void		cpys2sc ( char *cp, struct scblk *scptr, word maxlen );
extern	void		crlf ( void );
extern	int			docompress ( int bits, char *freeptr, uword size );
extern	void		doexec ( struct scblk *scbptr );
extern	int			doexpand ( int bits, char *freeptr, uword size );
extern   FILEPOS  doset ( struct ioblk *ioptr, FILEPOS offset, int whence );
extern  int     dosys ( char *cmd, char *path );
extern	void		endbrk (void);
extern	struct scblk *	enevs (struct scblk *inScblkPtr, word flag);
extern	struct scblk *	endtp (union block *inBlkPtr);
extern	struct scblk *	engts (union block *inBlkPtr);
extern	void		exephase (void);
extern	void		exeinput (void);
extern	void		__exit  (int code);
extern	int			expand ( File_handle fd, unsigned char *startadr, uword size );
extern	word		fillbuf ( struct ioblk *ioptr );
extern	char *		findenv ( char *vq, int vn );
extern	int			flush ( struct ioblk *ioptr );
extern	void		flush_all (struct chfcb *chb);
extern   int         fsyncio (struct ioblk *ioptr);
extern	long		gencmp (char*, char*, long, long, long);
extern	word *		get_fp ( void );
extern	char **		getargs (int argc, char *argv[]);
extern	double		get_ra ( void );
extern   FILEPOS     geteof ( struct ioblk *ioptr );
extern	void		gethost ( struct scblk *scptr, word maxlen );
extern	int			getint ( struct icblk *icp, long *pword );
extern	char		*getnum ( char *cp, uword *ip );
extern	File_handle	getprfd ( void );
extern	struct ioblk *	getpriob ( void );
extern	File_handle	getrdfd ( void );
extern	struct ioblk *	getrdiob ( void );
extern	int			getsave (File_handle fd);
extern	char *		getshell ( void );
extern	char *		getstring ( struct scblk *scp, char *cp );
extern	void		gettype ( struct scblk *scptr, word maxlen );
extern	char *		heapAlloc ( void *minAdr, word size );
extern	void		heapmove  ( void );
extern	int			host386 ( int hostno );
extern	int			host88 ( int hostno );
extern	int			hostapl ( int hostno );
extern	void		init_custom ( void );
extern	void		initpath ( char *name );
extern	word		lenfnm ( struct scblk *scptr );
extern	int			length ( char *cp );
extern	void *		loadef (word fd, char *filename);
extern	long		lstrncmp (char*, char*, long, long);
extern	int			_main ( int srcfd, int argc, char *argv[] );
extern	int			makeexec ( struct scblk *scptr, int type );
extern	char	    make_c_str ( char *p );
extern	void		malloc_empty ( void );
extern	int			malloc_init ( word endadr );
extern	long		moremem ( long n, char **pp );
extern	char		*mystrcpy ( char *p, char *q);
extern	int			mystrncpy ( char *p, char *q, int i);
extern	void *		nextef ( unsigned char **bufp, int io );
extern	void		numout ( unsigned n );
extern	int			openaout ( char *fn, char *tmpfnbuf, int exe );
extern	int			openexe (char *name);
extern	int			optfile ( struct scblk *varname, struct scblk *result );
extern	char		*optnum ( char *cp, uword *ip );
extern	int			osclose ( struct ioblk *ioptr );
extern	int			osopen ( struct ioblk *ioptr );
extern  int         ospipe ( struct ioblk *ioptr );
extern	word		osread ( word mode, word recsiz, struct ioblk *ioptr, struct scblk *scptr );
extern  void        oswait ( int pid );
extern  word        oswrite ( word mode, word linesiz, word recsiz, struct ioblk *ioptr, struct scblk *scptr );
extern	void		oupeof ( void );
extern	char *		pathlast ( char *path );
extern	void		prompt ( void );
extern	word		putsave (word *stkbase, word stklen);
extern	void		quit ( int errno );
extern	void		rawmode ( File_handle F, int mode );
extern	int			rdaout ( File_handle fd, unsigned char *startadr, uword size );
extern	int			rdenv ( struct scblk *varname, struct scblk *result );
extern	int			renames (char *oldname, char *newname);
extern	void		rereloc ( void );
extern	int			resaout ( char *filename );
extern	void		restart ( char *code, char *stack );
extern	void		restore0 ( void );
extern	void		restorestring (struct scblk *scp, word c);
extern	void		restore2str ( void );
extern	void		restore3str ( void );
extern	word		roundup (word n);
extern	void		save0 ( void );
extern	word		saveend (word *stkbase, word stklen);
extern	long		savestart (File_handle fd, char *bufp, unsigned int size);
extern	char *		savestr ( struct scblk *scp, char *cp );
extern	void		save2str ( char **s1p, char **s2p );
extern	void		save3str ( char **s1p, char **s2p, char **s3p );
extern	void		scanef ( void );
extern	word		scnint ( char *str, word len, word *intptr );
extern	int			seekaout (long pagesize);
extern	void		set_ra (double f);
extern	void		setoptions (word flags);
extern	void		setout ( void );
extern	void		setprfd ( File_handle fd );
extern	void		setrdfd ( File_handle fd );
extern	File_handle	spit_open ( char *Name, Open_method Method, File_mode Mode, int Access );
extern	void		startbrk ( void );
extern	void		startup (void);
extern	int			storedate ( char *cp, word maxlen );
extern	int			stcu_d ( char *out, unsigned int in, int outlen );
extern	void		stdioinit ( void );
extern	void		strout ( char *s );
extern	int			swcinp ( int filecnt, char **fileptr );
extern	int			swcoup ( char *oupptr );
extern	void		termhost (void);
extern	int			testty ( File_handle fd );
extern	int			tryopen ( char *cp );
extern	int			trypath ( char *name, char *file );
extern  void        ttyoutfdn (File_handle h);
extern  void        ttyinit ( void );
extern	void		ttyraw ( File_handle fd, int flag );
extern	void		unldef (struct efblk *efb);
extern	void	    unmake_c_str ( char *p, char saved_c);
extern	void		unreloc ( void );
extern	word		uppercase ( word c );
extern	word		wabs (word x);
extern	int			wrtaout ( unsigned char *startadr, uword size );
extern	void		wrterr ( char *s );
extern	void		wrtint ( int);
extern	void		wrtmsg ( char *s );
extern	int			zysax ( void );
extern	int			zysbs ( void );
extern	int			zysbx ( void );
extern	int			zyscm ( void );
extern	int			zysdc ( void );
extern	int			zysdm ( void );
extern	int			zysdt ( void );
extern	int			zysea ( void );
extern	int			zysef ( void );
extern	void		zysej ( void );
extern	int			zysem ( void );
extern	int			zysen ( void );
extern	int			zysep ( void );
extern	int			zysex ( void );
extern	int			zysfc ( void );
extern	int			zysgc ( void );
extern	int			zyshs ( void );
extern	int			zysid ( void );
extern	int			zysif ( void );
extern	int			zysil ( void );
extern	int			zysin ( void );
extern	int			zysio ( void );
extern	int			zysld ( void );
extern	int			zysmm ( void );
extern	int			zysmx ( void );
extern	int			zysou ( void );
extern	int			zyspi ( void );
extern	int			zyspl ( void );
extern	int			zyspp ( void );
extern	int			zyspr ( void );
extern	int			zysrd ( void );
extern	int			zysri ( void );
extern	int			zysrw ( void );
extern	int			zysst ( void );
extern	int			zystm ( void );
extern	int			zystt ( void );
extern	int			zysul ( void );
extern	int			zysxi ( void );

// prototypes for standard system-level functions used by OSINT

//#include <unistd.h>
#define LSEEK lseek

// Redefine sbrk and brk to use custom routines in syslinux.c
#undef sbrk
#undef brk
#define sbrk sbrkx
#define brk  brkx
extern	int 		brkx ( void *addr );
extern	void		*sbrkx ( long incr );


#endif
