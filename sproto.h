/*
/	File:  SPROTO.H	Version 1.02
/	----------------------------
/
/	Function prototypes for argument type checking.
/	This files are unique to SPITBOL.
*/
/*  Copyright 1991 Robert Goldberg and Catspaw, Inc. */

#ifndef	_sproto_
#define	_sproto_

typedef int File_handle;
typedef int File_mode;
typedef int Open_method;

extern	union block *	alloc Params((word nchars));
extern	struct scblk *	alocs Params((word nchars));
extern	union block *	alost Params((word nchars));
extern	int			appendext Params((char *path, char *ext, char *result, int force));
extern	int			arg2scb Params(( int req, int argc, char *argv[], struct scblk *scptr, int maxs ));
#if EXTFUN
extern  union block *   callef Params((struct efblk *efb, union block **sp, word nargs));
#endif
extern	int			checkfpu Params(( void ));
extern	int			checksave Params((char *namep));
extern	int			checkstr Params(( struct scblk *scp ));
extern	int			check2str Params(( void ));
extern	int			check3str Params(( void ));
extern	int			chrdev Params(( File_handle F ));
extern	int			cindev Params(( File_handle F ));
extern	int			cinread Params(( File_handle fd, char *buf, int size ));
extern	void		close_all Params(( struct chfcb *chb ));
extern	word		closeaout Params(( char *filename, char *tmpfnbuf, word errflag ));
extern	void		clrbuf Params(( void ));
extern	int			compress Params(( unsigned char FAR *startadr, uword size ));
extern	void		conv Params(( char *dest, int value ));
extern	int			coutdev Params(( File_handle F ));
extern	void		cpys2sc Params(( char *cp, struct scblk *scptr, word maxlen ));
extern	void		crlf Params(( void ));
extern	int			docompress Params(( int bits, char *freeptr, uword size ));
extern	void		doexec Params(( struct scblk *scbptr ));
extern	int			doexpand Params(( int bits, char *freeptr, uword size ));
extern   FILEPOS  doset Params(( struct ioblk *ioptr, FILEPOS offset, int whence ));
extern  int     dosys Params(( char *cmd, char *path ));
extern	void		endbrk Params((void));
extern	struct scblk *	enevs Params((struct scblk *inScblkPtr, word flag));
extern	struct scblk *	endtp Params((union block *inBlkPtr));
extern	struct scblk *	engts Params((union block *inBlkPtr));
extern	void		exephase Params((void));
extern	void		exeinput Params((void));
extern	void		__exit  Params((int code));
extern	int			expand Params(( File_handle fd, unsigned char FAR *startadr, uword size ));
extern	word		fillbuf Params(( struct ioblk *ioptr ));
extern	char *		findenv Params(( char *vq, int vn ));
extern	int			flush Params(( struct ioblk *ioptr ));
extern	void		flush_all Params((struct chfcb *chb));
extern   int         fsyncio Params((struct ioblk *ioptr));
extern	long		gencmp Params((char*, char*, long, long, long));
extern	word *		get_fp Params(( void ));
extern	char **		getargs Params((int argc, char *argv[]));
extern	double		get_ra Params(( void ));
extern   FILEPOS     geteof Params(( struct ioblk *ioptr ));
extern	void		gethost Params(( struct scblk *scptr, word maxlen ));
extern	int			getint Params(( struct icblk *icp, IATYPE *pword ));
extern	char		*getnum Params(( char *cp, uword *ip ));
extern	File_handle	getprfd Params(( void ));
extern	struct ioblk *	getpriob Params(( void ));
extern	File_handle	getrdfd Params(( void ));
extern	struct ioblk *	getrdiob Params(( void ));
extern	int			getsave Params((File_handle fd));
extern	char *		getshell Params(( void ));
extern	char *		getstring Params(( struct scblk *scp, char *cp ));
extern	void		gettype Params(( struct scblk *scptr, word maxlen ));
extern	char *		heapAlloc Params(( void *minAdr, word size ));
extern	void		heapmove  Params(( void ));
extern	int			host386 Params(( int hostno ));
extern	int			host88 Params(( int hostno ));
extern	int			hostapl Params(( int hostno ));
extern	void		init_custom Params(( void ));
extern	void		initpath Params(( char *name ));
extern	word		lenfnm Params(( struct scblk *scptr ));
extern	int			length Params(( char *cp ));
extern	void *		loadef Params((word fd, char *filename));
extern	long		lstrncmp Params((char*, char*, long, long));
extern	int			_main Params(( int srcfd, int argc, char *argv[] ));
extern	int			makeexec Params(( struct scblk *scptr, int type ));
extern	char	    make_c_str Params(( char *p ));
extern	void		malloc_empty Params(( void ));
extern	int			malloc_init Params(( word endadr ));
extern	long		moremem Params(( long n, char **pp ));
extern	char		*mystrcpy Params(( char *p, char *q));
extern	int			mystrncpy Params(( char *p, char *q, int i));
extern	void *		nextef Params(( unsigned char FAR **bufp, int io ));
extern	void		numout Params(( unsigned n ));
extern	int			openaout Params(( char *fn, char *tmpfnbuf, int exe ));
extern	int			openexe Params((char *name));
extern	int			optfile Params(( struct scblk *varname, struct scblk *result ));
extern	char		*optnum Params(( char *cp, uword *ip ));
extern	int			osclose Params(( struct ioblk *ioptr ));
extern	int			osopen Params(( struct ioblk *ioptr ));
extern  int         ospipe Params(( struct ioblk *ioptr ));
extern	word		osread Params(( word mode, word recsiz, struct ioblk *ioptr, struct scblk *scptr ));
extern  void        oswait Params(( int pid ));
extern  word        oswrite Params(( word mode, word linesiz, word recsiz, struct ioblk *ioptr, struct scblk *scptr ));
extern	void		oupeof Params(( void ));
extern	char *		pathlast Params(( char *path ));
extern	void		prompt Params(( void ));
extern	word		putsave Params((word *stkbase, word stklen));
extern	void		quit Params(( int errno ));
extern	void		rawmode Params(( File_handle F, int mode ));
extern	int			rdaout Params(( File_handle fd, unsigned char FAR *startadr, uword size ));
extern	int			rdenv Params(( struct scblk *varname, struct scblk *result ));
#ifndef readfar
extern	uword		readfar Params(( File_handle fd, void FAR *Buf, uword Cnt ));
#endif
extern	int			rename Params((char *oldname, char *newname));
extern	void		rereloc Params(( void ));
extern	int			resaout Params(( char *filename ));
extern	void		restart Params(( char *code, char *stack ));
extern	void		restore0 Params(( void ));
extern	void		restorestring Params((struct scblk *scp, word c));
extern	void		restore2str Params(( void ));
extern	void		restore3str Params(( void ));
extern	word		roundup Params((word n));
extern	void		save0 Params(( void ));
extern	word		saveend Params((word *stkbase, word stklen));
extern	long		savestart Params((File_handle fd, char *bufp, unsigned int size));
extern	char *		savestr Params(( struct scblk *scp, char *cp ));
extern	void		save2str Params(( char **s1p, char **s2p ));
extern	void		save3str Params(( char **s1p, char **s2p, char **s3p ));
extern	void		scanef Params(( void ));
extern	word		scnint Params(( char *str, word len, word *intptr ));
extern	int			seekaout Params((long pagesize));
extern	void		set_ra Params((double f));
extern	void		setoptions Params((word flags));
extern	void		setout Params(( void ));
extern	void		setprfd Params(( File_handle fd ));
extern	void		setrdfd Params(( File_handle fd ));
extern	int			sioarg Params(( int ioflg, struct ioblk *ioptr, struct scblk *scptr ));
extern	File_handle	spit_open Params(( char *Name, Open_method Method, File_mode Mode, int Access ));
extern	void		startbrk Params(( void ));
extern	void		startup Params(( char *code, char *stack ));
extern	int			storedate Params(( char *cp, word maxlen ));
extern	int			stcu_d Params(( char *out, unsigned int in, int outlen ));
extern	void		stdioinit Params(( void ));
extern	void		strout Params(( char *s ));
extern	int			swcinp Params(( int filecnt, char **fileptr ));
extern	int			swcoup Params(( char *oupptr ));
extern	void		termhost Params((void));
extern	int			testty Params(( File_handle fd ));
extern	int			tryopen Params(( char *cp ));
extern	int			trypath Params(( char *name, char *file ));
extern  void        ttyoutfdn Params((File_handle h));
extern  void        ttyinit Params(( void ));
extern	void		ttyraw Params(( File_handle fd, int flag ));
extern	void		unldef Params((struct efblk *efb));
extern	void	    unmake_c_str Params(( char *p, char saved_c));
extern	void		unreloc Params(( void ));
extern	word		uppercase Params(( word c ));
extern	word		wabs Params((word x));
#ifndef writefar
extern	uword		writefar Params(( File_handle fd, void FAR *Buf, uword Cnt ));
#endif
extern	int			wrtaout Params(( unsigned char FAR *startadr, uword size ));
extern	void		wrterr Params(( char *s ));
extern	int			zysax Params(( void ));
extern	int			zysbs Params(( void ));
extern	int			zysbx Params(( void ));
extern	int			zyscm Params(( void ));
extern	int			zysdc Params(( void ));
extern	int			zysdm Params(( void ));
extern	int			zysdt Params(( void ));
extern	int			zysea Params(( void ));
extern	int			zysef Params(( void ));
extern	void		zysej Params(( void ));
extern	int			zysem Params(( void ));
extern	int			zysen Params(( void ));
extern	int			zysep Params(( void ));
extern	int			zysex Params(( void ));
extern	int			zysfc Params(( void ));
extern	int			zysgc Params(( void ));
extern	int			zyshs Params(( void ));
extern	int			zysid Params(( void ));
extern	int			zysif Params(( void ));
extern	int			zysil Params(( void ));
extern	int			zysin Params(( void ));
extern	int			zysio Params(( void ));
extern	int			zysld Params(( void ));
extern	int			zysmm Params(( void ));
extern	int			zysmx Params(( void ));
extern	int			zysou Params(( void ));
extern	int			zyspi Params(( void ));
extern	int			zyspl Params(( void ));
extern	int			zyspp Params(( void ));
extern	int			zyspr Params(( void ));
extern	int			zysrd Params(( void ));
extern	int			zysri Params(( void ));
extern	int			zysrw Params(( void ));
extern	int			zysst Params(( void ));
extern	int			zystm Params(( void ));
extern	int			zystt Params(( void ));
extern	int			zysul Params(( void ));
extern	int			zysxi Params(( void ));

/* prototypes for standard system-level functions used by OSINT */

#if BCC32
/* Borland's header file defines sbrk with an int argument.  We prefer long.
 */
#undef sbrk
#define sbrk sbrkx
#endif

#if _MSC_VER
#undef sbrk
#define sbrk sbrkx
#endif          /* _MSC_VER */

#if AIX
/* Redefine sbrk and brk to use custom routines in sysrs6.c */
#undef sbrk
#undef brk
#define sbrk sbrkx
#define brk  brkx
#endif

#if UNIX
#include <unistd.h>
#define LSEEK lseek

#if LINUX
/* Redefine sbrk and brk to use custom routines in syslinux.c */
#undef sbrk
#undef brk
#define sbrk sbrkx
#define brk  brkx
extern	int 		brkx Params(( void *addr ));
extern	void		*sbrkx Params(( long incr ));
#endif

#else
extern  int         access Params((char *Name, int mode));
extern	int 		brk Params(( void *addr ));
extern	int 		close Params(( File_handle F ));
extern	File_handle	dup Params(( File_handle F ));
extern	char * _Optlink	getenv Params(( char *name ));
#if WINNT && _MSC_VER
#define LSEEK lseeki64
#else
#define LSEEK lseek
#endif
extern   FILEPOS  LSEEK Params(( File_handle F, FILEPOS Loc, int Method ));
extern	word		read Params(( File_handle F, void *Buf, uword Cnt ));
extern	void		*sbrk Params(( long incr ));
extern	int			unlink Params(( char *Name ));
extern	word		write Params(( File_handle F, void *Buf, uword Cnt ));
#endif

#endif
