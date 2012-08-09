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
/	file:  sproto.h	version 1.02
/	----------------------------
/
/	function prototypes for argument type checking.
/	this files are unique to spitbol.
*/

#ifndef	_sproto_
#define	_sproto_

typedef int file_handle;
typedef int file_mode;
typedef int open_method;

extern	union block *	alloc params((word nchars));
extern	struct scblk *	alocs params((word nchars));
extern	union block *	alost params((word nchars));
extern	int			appendext params((char *path, char *ext, char *result, int force));
extern	int			arg2scb params(( int req, int argc, char *argv[], struct scblk *scptr, int maxs ));
#if extfun
extern  union block *   callef params((struct efblk *efb, union block **sp, word nargs));
#endif
extern	int			checkfpu params(( void ));
extern	int			checksave params((char *namep));
extern	int			checkstr params(( struct scblk *scp ));
extern	int			check2str params(( void ));
extern	int			check3str params(( void ));
extern	int			chrdev params(( file_handle f ));
extern	int			cindev params(( file_handle f ));
extern	int			cinread params(( file_handle fd, char *buf, int size ));
extern	void		close_all params(( struct chfcb *chb ));
extern	word		closeaout params(( char *filename, char *tmpfnbuf, word errflag ));
extern	void		clrbuf params(( void ));
extern	int			compress params(( unsigned char far *startadr, uword size ));
extern	void		conv params(( char *dest, int value ));
extern	int			coutdev params(( file_handle f ));
extern	void		cpys2sc params(( char *cp, struct scblk *scptr, word maxlen ));
extern	void		crlf params(( void ));
extern	int			docompress params(( int bits, char *freeptr, uword size ));
extern	void		doexec params(( struct scblk *scbptr ));
extern	int			doexpand params(( int bits, char *freeptr, uword size ));
extern   filepos  doset params(( struct ioblk *ioptr, filepos offset, int whence ));
extern  int     dosys params(( char *cmd, char *path ));
extern	void		endbrk params((void));
extern	struct scblk *	enevs params((struct scblk *inscblkptr, word flag));
extern	struct scblk *	endtp params((union block *inblkptr));
extern	struct scblk *	engts params((union block *inblkptr));
extern	void		exephase params((void));
extern	void		exeinput params((void));
extern	void		__exit  params((int code));
extern	int			expand params(( file_handle fd, unsigned char far *startadr, uword size ));
extern	word		fillbuf params(( struct ioblk *ioptr ));
extern	char *		findenv params(( char *vq, int vn ));
extern	int			flush params(( struct ioblk *ioptr ));
extern	void		flush_all params((struct chfcb *chb));
extern   int         fsyncio params((struct ioblk *ioptr));
extern	long		gencmp params((char*, char*, long, long, long));
extern	word *		get_fp params(( void ));
extern	char **		getargs params((int argc, char *argv[]));
extern	double		get_ra params(( void ));
extern   filepos     geteof params(( struct ioblk *ioptr ));
extern	void		gethost params(( struct scblk *scptr, word maxlen ));
extern	int			getint params(( struct icblk *icp, iatype *pword ));
extern	char		*getnum params(( char *cp, uword *ip ));
extern	file_handle	getprfd params(( void ));
extern	struct ioblk *	getpriob params(( void ));
extern	file_handle	getrdfd params(( void ));
extern	struct ioblk *	getrdiob params(( void ));
extern	int			getsave params((file_handle fd));
extern	char *		getshell params(( void ));
extern	char *		getstring params(( struct scblk *scp, char *cp ));
extern	void		gettype params(( struct scblk *scptr, word maxlen ));
extern	char *		heapalloc params(( void *minadr, word size ));
extern	void		heapmove  params(( void ));
extern	int			host386 params(( int hostno ));
extern	int			host88 params(( int hostno ));
extern	int			hostapl params(( int hostno ));
extern	void		init_custom params(( void ));
extern	void		initpath params(( char *name ));
extern	word		lenfnm params(( struct scblk *scptr ));
extern	int			length params(( char *cp ));
extern	void *		loadef params((word fd, char *filename));
extern	long		lstrncmp params((char*, char*, long, long));
extern	int			_main params(( int srcfd, int argc, char *argv[] ));
extern	int			makeexec params(( struct scblk *scptr, int type ));
extern	char	    make_c_str params(( char *p ));
extern	void		malloc_empty params(( void ));
extern	int			malloc_init params(( word endadr ));
extern	long		moremem params(( long n, char **pp ));
extern	char		*mystrcpy params(( char *p, char *q));
extern	int			mystrncpy params(( char *p, char *q, int i));
extern	void *		nextef params(( unsigned char far **bufp, int io ));
extern	void		numout params(( unsigned n ));
extern	int			openaout params(( char *fn, char *tmpfnbuf, int exe ));
extern	int			openexe params((char *name));
extern	int			optfile params(( struct scblk *varname, struct scblk *result ));
extern	char		*optnum params(( char *cp, uword *ip ));
extern	int			osclose params(( struct ioblk *ioptr ));
extern	int			osopen params(( struct ioblk *ioptr ));
extern  int         ospipe params(( struct ioblk *ioptr ));
extern	word		osread params(( word mode, word recsiz, struct ioblk *ioptr, struct scblk *scptr ));
extern  void        oswait params(( int pid ));
extern  word        oswrite params(( word mode, word linesiz, word recsiz, struct ioblk *ioptr, struct scblk *scptr ));
extern	void		oupeof params(( void ));
extern	char *		pathlast params(( char *path ));
extern	void		prompt params(( void ));
extern	word		putsave params((word *stkbase, word stklen));
extern	void		quit params(( int errno ));
extern	void		rawmode params(( file_handle f, int mode ));
extern	int			rdaout params(( file_handle fd, unsigned char far *startadr, uword size ));
extern	int			rdenv params(( struct scblk *varname, struct scblk *result ));
#ifndef readfar
extern	uword		readfar params(( file_handle fd, void far *buf, uword cnt ));
#endif
extern	int			renames params((char *oldname, char *newname));
extern	void		rereloc params(( void ));
extern	int			resaout params(( char *filename ));
extern	void		restart params(( char *code, char *stack ));
extern	void		restore0 params(( void ));
extern	void		restorestring params((struct scblk *scp, word c));
extern	void		restore2str params(( void ));
extern	void		restore3str params(( void ));
extern	word		roundup params((word n));
extern	void		save0 params(( void ));
extern	word		saveend params((word *stkbase, word stklen));
extern	long		savestart params((file_handle fd, char *bufp, unsigned int size));
extern	char *		savestr params(( struct scblk *scp, char *cp ));
extern	void		save2str params(( char **s1p, char **s2p ));
extern	void		save3str params(( char **s1p, char **s2p, char **s3p ));
extern	void		scanef params(( void ));
extern	word		scnint params(( char *str, word len, word *intptr ));
extern	int			seekaout params((long pagesize));
extern	void		set_ra params((double f));
extern	void		setoptions params((word flags));
extern	void		setout params(( void ));
extern	void		setprfd params(( file_handle fd ));
extern	void		setrdfd params(( file_handle fd ));
extern	int			sioarg params(( int ioflg, struct ioblk *ioptr, struct scblk *scptr ));
extern	file_handle	spit_open params(( char *name, open_method method, file_mode mode, int access ));
extern	void		startbrk params(( void ));
extern	void		startup params(( char *code, char *stack ));
extern	int			storedate params(( char *cp, word maxlen ));
extern	int			stcu_d params(( char *out, unsigned int in, int outlen ));
extern	void		stdioinit params(( void ));
extern	void		strout params(( char *s ));
extern	int			swcinp params(( int filecnt, char **fileptr ));
extern	int			swcoup params(( char *oupptr ));
extern	void		termhost params((void));
extern	int			testty params(( file_handle fd ));
extern	int			tryopen params(( char *cp ));
extern	int			trypath params(( char *name, char *file ));
extern  void        ttyoutfdn params((file_handle h));
extern  void        ttyinit params(( void ));
extern	void		ttyraw params(( file_handle fd, int flag ));
extern	void		unldef params((struct efblk *efb));
extern	void	    unmake_c_str params(( char *p, char saved_c));
extern	void		unreloc params(( void ));
extern	word		uppercase params(( word c ));
extern	word		wabs params((word x));
#ifndef writefar
extern	uword		writefar params(( file_handle fd, void far *buf, uword cnt ));
#endif
extern	int			wrtaout params(( unsigned char far *startadr, uword size ));
extern	void		wrterr params(( char *s ));
extern	void		wrtint params(( int));
extern	void		wrtmsg params(( char *s ));
extern	int			zysax params(( void ));
extern	int			zysbs params(( void ));
extern	int			zysbx params(( void ));
extern	int			zyscm params(( void ));
extern	int			zysdc params(( void ));
extern	int			zysdm params(( void ));
extern	int			zysdt params(( void ));
extern	int			zysea params(( void ));
extern	int			zysef params(( void ));
extern	void		zysej params(( void ));
extern	int			zysem params(( void ));
extern	int			zysen params(( void ));
extern	int			zysep params(( void ));
extern	int			zysex params(( void ));
extern	int			zysfc params(( void ));
extern	int			zysgc params(( void ));
extern	int			zyshs params(( void ));
extern	int			zysid params(( void ));
extern	int			zysif params(( void ));
extern	int			zysil params(( void ));
extern	int			zysin params(( void ));
extern	int			zysio params(( void ));
extern	int			zysld params(( void ));
extern	int			zysmm params(( void ));
extern	int			zysmx params(( void ));
extern	int			zysou params(( void ));
extern	int			zyspi params(( void ));
extern	int			zyspl params(( void ));
extern	int			zyspp params(( void ));
extern	int			zyspr params(( void ));
extern	int			zysrd params(( void ));
extern	int			zysri params(( void ));
extern	int			zysrw params(( void ));
extern	int			zysst params(( void ));
extern	int			zystm params(( void ));
extern	int			zystt params(( void ));
extern	int			zysul params(( void ));
extern	int			zysxi params(( void ));

/* prototypes for standard system-level functions used by osint */

#if bcc32
/* borland's header file defines sbrk with an int argument.  we prefer long.
 */
#undef sbrk
#define sbrk sbrkx
#endif

#if _msc_ver
#undef sbrk
#define sbrk sbrkx
#endif          /* _msc_ver */

#if aix
/* redefine sbrk and brk to use custom routines in sysrs6.c */
#undef sbrk
#undef brk
#define sbrk sbrkx
#define brk  brkx
#endif

#if unix
#include <unistd.h>
#define lseek lseek

#if linux
/* redefine sbrk and brk to use custom routines in syslinux.c */
#undef sbrk
#undef brk
#define sbrk sbrkx
#define brk  brkx
extern	int 		brkx params(( void *addr ));
extern	void		*sbrkx params(( long incr ));
#endif

#else
extern  int         access params((char *name, int mode));
extern	int 		brk params(( void *addr ));
extern	int 		close params(( file_handle f ));
extern	file_handle	dup params(( file_handle f ));
extern	char * _optlink	getenv params(( char *name ));
#if winnt && _msc_ver
#define lseek lseeki64
#else
#define lseek lseek
#endif
extern   filepos  lseek params(( file_handle f, filepos loc, int method ));
extern	word		read params(( file_handle f, void *buf, uword cnt ));
extern	void		*sbrk params(( long incr ));
extern	int			unlink params(( char *name ));
extern	word		write params(( file_handle f, void *buf, uword cnt ));
#endif

#endif
