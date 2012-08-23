/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
        File:  SYSXI.C          Version:  01.18
        ---------------------------------------

        Contents:       Function zysxi
                        Function unreloc
                        Function rereloc
*/

/*
        zysxi - exit to produce load module

        zysxi is called to perform one of two actions:

        o  "chain" to another program to execute

        o  write a load module of the currently executing spitbol program

        In either case the currently executing spitbol process is terminated,
    except if called with IA as +4 or -4, in which case execution
        continues.

        Parameters:
            IA - integer argument if writing load module
                 <0 - write only impure area of memory
                 =0 - exit to command level
                 >0 - write all of memory
         =4 or -4 - to continue execution after creating file
            WA - pointer to SCBLK for second argument
            WB - pointer to head of FCBLK chain (CHBLK)
            XL - pointer to SCBLK containing command to execute or 0
            XR - version number SCBLK.  Three char string of form "X.Y".
        Returns:
        WA   1 only when called with IA=4 or IA=-4 and we are
             continuing execution, else 0.
             values of IA do not elicit a return.
        Exits:
            1 - requested action not possible
            2 - action caused irrecoverable error


   V1.10 12-Oct-87 MBE  <withdrawn>

   V1.11 14-Dec-87 MBE  Close files *prior* to writing a.out file or chaining
                        to another shell command.  This frees up the channel
                        variables for reuse upon restart (EXIT(3) case), and
                        flushing any output data still in Spitbol's buffers
                        (EXIT("cmd string") case).

   V1.12 01-Jan-88 MBE  Modified for HP

   V1.13 02-Feb-88 MBE  Modified for Definicon.
                        Use save0() before EXIT("cmd") call (all versions).

   V1.14 13-Sep-89 MBE  Modified for DOS 386.  Supports EXIT(-3) only.
                        Added optional second argument to EXIT to allow
                        specifying file name of load module.

   V1.15 16-Oct-89 MBE  Modified for SPARC.

   V1.16 19-May-91 MBE  Write load modules for SPITBOL-386 with
                        Intel DOS Extender.
   V1.17 22-Aug-91 MBE  <withdrawn>.

   V1.18 07-Nov-91 MBE  Start rework for relocatable Save files.
                                                Restrict portion of Static region saved.
                        Replace initsp with usage of STBAS in
                        Minimal source.

   V1.19 10-Dec-91 MBE  Add +4 and -4 case to allow execution to proceed.

   V1.20 14-Oct-94 MBE  Call termhost *prior* to writing save or exec file.

*/

#include "port.h"

#if UNIX & EXECFILE & !EXECSAVE
#include <a.out.h>
#endif                                  /* UNIX */

#include "save.h"

#include <time.h>
#if EXECFILE & !EXECSAVE
extern word     *edata;
extern word     *etext;
#endif                                  /* EXECFILE */

#if SAVEFILE
struct svfilehdr svfheader;
char uargbuf[UargSize];

static void hcopy Params((char *src, char *dst, int len, int max));
#endif                                  /* SAVEFILE */


#if SAVEFILE | EXECSAVE
extern word read Params((int F, void *Buf, unsigned Cnt));
extern FILEPOS LSEEK Params((int F, FILEPOS Loc, int Method));
#endif          /* EXECFILE  | SAVEFILE */

zysxi()

{
#if EXECFILE & !EXECSAVE
    register word       *srcptr, *dstptr;
    char        *endofmem;
    char        *starttext;
    char        *startdata;
    long        i;
#endif                                  /* EXECFILE */

#if EXECFILE | SAVEFILE
    char        fileName[256], tmpfnbuf[256];
    word        *stackbase;
    word        retval, stacklength;
    struct scblk        *scfn = WA( struct scblk * );
    char        savech;
#endif                                  /* EXECFILE | SAVEFILE */

    struct scblk        *scb = XL( struct scblk * );

    /*
    /   Case 1:  Chain to another program
    /
    /   If XL is non-zero then it must point to a SCBLK containing the
    /   command to execute by chaining.
    */
    if ( scb != 0 )
    {
        if ( scb->typ == TYPE_SCL )             /* must be SCBLK!       */
        {
            close_all( WB( struct chfcb * ) );  /* V1.11*/
#if HOST386
            termhost();
#endif                                  /* HOST386 */
            save0();            /* V1.14 make sure fd 0 OK */
            doexec( scb );              /* execute command      */
            restore0();         /* just in case         */
            return EXIT_2;              /* Couldn't chain */
        }
        return  EXIT_1;                 /* not a SCBLK          */
    }

    /*
    /   Case 2:  Write load module.
    /
    */
    SET_WA(0);                                  /* Prepare to return 0 on resumption. */

#if !EXECFILE
    /*  Don't accept request to write executable files. */
    if ( IA(IATYPE) >= 0 )
        return  EXIT_1;
#endif                                  /* !EXECFILE */

#if !SAVEFILE
    /*  Don't accept request except to write save file. */
    if ( IA(IATYPE) <= 0 )
        return  EXIT_1;
#endif                                  /* !SAVEFILE */

#if SAVEFILE | EXECFILE
    /*
    /   Get current value of FP and compute length of current stack.
    */
    stackbase   = (word *)get_fp();
    stacklength = GET_MIN_VALUE(stbas,char *) - (char *)stackbase;
    /*
    /   Close all files and flush buffers
    */
#if HOST386
    termhost();
#endif                                  /* HOST386 */
    close_all( WB( struct chfcb * ) );  /* V1.11 */

    /*  Prepare optional file name as a C string, open output file */
    savech = make_c_str(&(scfn->str[scfn->len]));
    if (scfn->str[0])
        mystrcpy(fileName, scfn->str);
    else
        mystrcpy(fileName,                /* default file name */
#if SAVEFILE
                 IA(IATYPE) < 0 ? SAVE_FILE : AOUT_FILE);
#else                                   /* SAVEFILE */
                 AOUT_FILE);
#endif                                  /* SAVEFILE */
    retval = openaout(fileName, tmpfnbuf,
#if SAVEFILE
                      (IA(IATYPE) < 0 ? 0 : IO_EXECUTABLE)              /* executable? */
#else                                   /* SAVEFILE */
                      IO_EXECUTABLE
#endif                                  /* SAVEFILE */
                     );
    unmake_c_str(&(scfn->str[scfn->len]), savech);


#if SAVEFILE
    if (IA(IATYPE) < 0 ) {
        retval |= putsave(stackbase, stacklength);      /* write save file */
    }
#endif                                  /* SAVEFILE */

#if EXECFILE
    if (IA(IATYPE) > 0 ) {

#if EXECSAVE
        /*
         * We copy the SPITBOL executable to the target file, and then
         * append a save file to the end of it.  Locations in the
         * executable header are adjusted to mark the presence of
         * the save file.
         *
         * Have to do this carefully.  If we are currently running in
         * an EXEC file, then we want to overwrite the old save file
         * presently on the end.
         *
         * Ideally we should bash the code that can read source files
         * to prevent tampering, but it's difficult to figure out
         * where that is in the EXE file.
         */
        int fromfd;
        long extra, copylen, bufsize, size;
        char *bufp;

        fromfd = openexe( gblargv[0] );
        if (fromfd == -1) {
#if UNIX
            write( STDERRFD, "To create an executable, the file ", 34);
            write( STDERRFD, gblargv[0], length(gblargv[0]));
            wrterr( " must have read (-r) privilege." );
#endif
            retval = -1;
            goto fail;
        }

        /*
         * Try to allocate 4k buffer at end of heap,
         * expanding if necessary.  If we can't expand, we settle for
         * a smaller buffer.
         */
        bufsize = 4096;
        bufp = GET_MIN_VALUE(dnamp,char *);
        size = topmem - bufp;                   /* free space in heap */
        extra = bufsize - size;
        if (extra > 0) {                                /* if not enough in heap */
            if (sbrk((uword)extra) == (void *)-1) {     /* try to enlarge */
                bufsize = size;                 /* couldn't.  Use smaller buffer */
                extra = 0;
            }
        }
        /*
         * Copy copylen bytes from fromfd to target file.
         *
         */
        copylen = bufsize;
        retval = -1;                                    /* flag first buffer read */
        if (!bufsize)
            goto fail;

        do {
            size = read(fromfd, bufp, copylen > bufsize ? bufsize : copylen);

            if (!size || size == (uword)-1) {
                close(fromfd);
                retval = -1;
                goto fail;
            }
            if (retval) {                                       /* first time through */
                copylen = savestart(fromfd, bufp, size);
                if (!copylen)
                    goto fail;
                retval = 0;                             /* only do this once */
            }
            copylen -= size;

            retval |= wrtaout((unsigned char *)bufp, size);
        } while (copylen > 0 && !retval);

        close(fromfd);

        /* If we allocated extra memory, release it */
        if (extra > 0)
            sbrk(-extra);

        retval |= saveend(stackbase, stacklength);

#else                                   /* EXECSAVE */
        /*
        /       Copy entire stack into local storage of temporary SCBLK.
        */
        if ( stacklength > TSCBLK_LENGTH ) {
            retval = -1;
            goto fail;
        }
        srcptr = stackbase;
        dstptr = (word *)pTSCBLK->str;
        i = GET_MIN_VALUE(stbas,word *) - srcptr;
        while( i-- )
            *dstptr++ = *srcptr++;
        lmodstk = dstptr;               /* (also non-zero flag for restart) */
#endif                                  /* EXECSAVE */

#if SOLARIS & !EXECSAVE
        /*
        /       Create a.out header.
        /       First address of text section 0x2000 (SEGSIZ)
        /       Data section starts at next segment.
        /       Note that there is a gap between the end of C data and the
        /       start of the heap.  The data section is written out followed
        /       by the heap.  Whoever reloads it will have to physically move
        /       the heap up in memory.
        /
        /       Note that NO part of the malloc region is saved.
        /
        */
        starttext       = (char *)T_START;  /*LAH*/
        startdata       = (char *)roundup((word)&etext);
        endofmem        = GET_MIN_VALUE(dnamp,char *);

        header.a_magic  = NMAGIC;       /* Don't want demand loading of library */
        header.a_dynamic = 0;           /* No dynamic links */
        header.a_toolversion = 1;       /* Unsure of meaning of this guy */
        header.a_machtype = M_SPARC;

        header.a_text   = (int)((char *)&etext - starttext);
        header.a_data = (int)(endofmem - basemem) +
                        (int)((char *)&edata - startdata);
        header.a_bss  = 0;
        header.a_syms   = 0;
        header.a_entry  = T_START; /*LAH*/
        header.a_trsize = 0;
        header.a_drsize = 0;

        /*
        /       Let function wrtaout write the a.out file.  Hold off checking for
        /       errors until stack position sensitive pointers have been readjusted.
        */
        unreloc();

        if ( retval == 0 )
            retval = wrtaout( (unsigned char FAR *)&header, sizeof( struct exec ) );
        if ( retval == 0 )
            retval = wrtaout( (unsigned char FAR *)starttext, header.a_text );
        /* new system with gap between heap and  C data */
        if ( retval == 0 )
            retval = wrtaout( (unsigned char FAR *)startdata, (int)((char *)&edata - startdata) );
        if ( retval == 0 )
            retval = wrtaout( (unsigned char FAR *)basemem, (int)(endofmem - basemem) );
#endif          /* SOLARIS */

    }
#endif                                  /* EXECFILE */

    rereloc();
fail:
    retval |= closeaout(fileName, tmpfnbuf, retval);
    if ( retval < 0 )
        return EXIT_2;

    /*
    /   load module or save file has been successfully written.
    /   If called with anything other than +4 or -4, terminate execution.
    */
    if (IA(IATYPE) == 4 || IA(IATYPE) == -4) {
        SET_WA( 1 );                    /* flag continuation to caller */
        return NORMAL_RETURN;
    }

    SET_XL( 0 );                        /* files already closed V1.11 */
    SET_WB( 0 );
    zysej();                    /* NO RETURN */
    return EXIT_1;
#endif                                  /* EXECFILE | SAVEFILE */
}

#if (SOLARIS | LINUX) & EXECFILE & !EXECSAVE
/* heapmove
 *
 * perform upward copy of heap from where it was stored in the execfile
 * to where it was in memory when the execfile was written.
 */
void heapmove()
{
    unsigned long i = (GET_MIN_VALUE(dnamp, char *) - basemem) / sizeof(word);
    word *from = (word *)&edata;
    word *to = (word *)basemem;

    while (i--)
        *to++ = *from++;
}
#endif


#if EXECFILE | SAVEFILE
/*
        The following two functions deal with the "unrelocation" and
        "re-relocation" of compiler variables that point into the stack.
        These actions must be taken so that these pointers into the
        stack can be adjusted every time that the load module is executed.
        Why?  Because there is no way to guarantee that the stack can be
        rebuilt during subsequent executions of the laod module at the
        same locations as when the load module was written.

        So, function unreloc takes such variables and turns them into
        offsets into the stack.  Function rereloc converts stack offsets
        into stack pointers.

    Register CP is "unrelocated" relative to the start of dynamic
    storage, in case it moves after a reload.

    Register PC is "unrelocated" relative to the start of Minimal code.
*/

/*
        unreloc()

        unreloc() "unrelocates" all compiler variables that point into
        the stack by subtracting the initial stack pointer value from them.
        This converts these stack pointers into offsets.
*/

void unreloc()
{
    register char *stbas;

    stbas = GET_MIN_VALUE(stbas,char *);
    SET_MIN_VALUE(flptr,GET_MIN_VALUE(flptr,char *) - stbas,word);
    SET_MIN_VALUE(flprt,GET_MIN_VALUE(flprt,char *) - stbas,word);
    SET_MIN_VALUE(gtcef,GET_MIN_VALUE(gtcef,char *) - stbas,word);
    SET_MIN_VALUE(pmhbs,GET_MIN_VALUE(pmhbs,char *) - stbas,word);
    SET_CP(CP(char *) - GET_MIN_VALUE(dnamb,char *));
#if winnT
    SET_PC(PC(char *) - GET_CODE_OFFSET(s_aaa,char *));
#endif
}

/*
        rereloc() "re-relocates" all compiler variables that pointer into
        the stack by adding the initial stack pointer value to them.  This
        action converts these offsets in the stack into real pointers.
*/

void rereloc()
{
    register char *stbas;

    stbas = GET_MIN_VALUE(stbas,char *);
    SET_MIN_VALUE(flptr,GET_MIN_VALUE(flptr,word) + stbas,word);
    SET_MIN_VALUE(flprt,GET_MIN_VALUE(flprt,word) + stbas,word);
    SET_MIN_VALUE(gtcef,GET_MIN_VALUE(gtcef,word) + stbas,word);
    SET_MIN_VALUE(pmhbs,GET_MIN_VALUE(pmhbs,word) + stbas,word);
    SET_CP(CP(word) + GET_MIN_VALUE(dnamb,char *));
#if SPARC | WINNT
    SET_PC(PC(word) + GET_CODE_OFFSET(s_aaa,char *));
#endif          /* SPARC | WINNT */
}
#endif                                  /* EXECFILE | SAVEFILE */


#if SAVEFILE
static void hcopy(src, dst, len, max)
char *src, *dst;
int len, max;
{
    int i = 0;

    while ( (++i <= max) && (*dst++ = *src++) != 0 && (len-- != 0))
        ;
    while (++i <= max)
        *dst++ = '\0';
}
#endif                                  /* SAVEFILE */



#if EXECFILE & !EXECSAVE
/*
        Roundup the integer argument to be a multiple of the
        system page size.
*/

static word roundup(n)
word    n;
{
    return (n + PAGESIZE - 1) & ~((word)PAGESIZE - 1);
}
#endif                                  /* EXECFILE */

#if SAVEFILE | EXECSAVE
/*
 * putsave - create a save file
 */
word putsave(stkbase, stklen)
word *stkbase, stklen;
{
    word result = 0;
    struct scblk *vscb = XR( struct scblk * );
#if EXTFUN
    unsigned char FAR *bufp;
    word textlen;
#endif                                  /* EXTFUN */


    /*
    /   Fill in the file header
    */
    svfheader.magic1 = OURMAGIC1;
    svfheader.magic2 = OURMAGIC2;
    svfheader.version = SaveVersion;
    svfheader.system = SYSVERSION;
    svfheader.spare = 0;
    hcopy(vscb->str, svfheader.headv, vscb->len, sizeof(svfheader.headv));
    hcopy(pID1->str, svfheader.iov, pID1->len, sizeof(svfheader.iov));
    svfheader.timedate = time((time_t *)0);
    svfheader.flags = spitflag;
    svfheader.stacksiz = (uword)stacksiz;
    svfheader.stacklength = (uword)stklen;
    svfheader.stbas = GET_MIN_VALUE(stbas,char *);
    svfheader.sec3size = (uword)(GET_DATA_OFFSET(c_yyy,char *) - GET_DATA_OFFSET(c_aaa,char *));
    svfheader.sec3adr = GET_DATA_OFFSET(c_aaa,char *);
    svfheader.sec4size = (uword)(GET_DATA_OFFSET(w_yyy,char *) - GET_DATA_OFFSET(g_aaa,char *));
    svfheader.sec4adr = GET_DATA_OFFSET(g_aaa,char *);
    svfheader.statoff = (uword)(GET_MIN_VALUE(hshtb,char *) - basemem); /* offset to saved static in heap */
    svfheader.dynoff = (uword)(GET_MIN_VALUE(dnamb,char *) - basemem);          /* offset to saved dynamic in heap */
    svfheader.heapsize = (uword)(GET_MIN_VALUE(dnamp,char *) - basemem);
    svfheader.heapadr = basemem;
    svfheader.topmem = topmem;
    svfheader.databts = (uword)databts;
    svfheader.memincb = (uword)memincb;
    svfheader.maxsize = (uword)maxsize;
    svfheader.sec5size = (uword)(GET_CODE_OFFSET(s_yyy,char *) - GET_CODE_OFFSET(s_aaa,char *));
    svfheader.sec5adr = GET_CODE_OFFSET(s_aaa,char *);
    svfheader.compress = (uword)LZWBITS;
    svfheader.uarglen = uarg ? (uword)length(uarg) : 0;
    if (svfheader.uarglen >= UargSize)
        svfheader.uarglen = UargSize - 1;

    /*
    /   Let function wrtaout write the save file.  Hold off checking for
    /   errors until stack position sensitive pointers have been readjusted.
    */
    unreloc();

    if (docompress(svfheader.compress, basemem+svfheader.heapsize,
                   (uword)(topmem-(basemem+svfheader.heapsize)) ) )     /* Do compression if room */
        svfheader.compress = 0;

    /* write out header */
    result |= wrtaout( (unsigned char FAR *)&svfheader, sizeof( struct svfilehdr ) );

    /* write out -u command line string if there is one */
    result |= compress( (unsigned char FAR *)uarg, svfheader.uarglen );

    /* write out stack */
    result |= compress( (unsigned char FAR *)stkbase, stklen );

    /* write out working section */
    result |= compress( (unsigned char FAR *)svfheader.sec4adr, svfheader.sec4size );

    /* write out important portion of static region */
    result |= compress( (unsigned char FAR *)GET_MIN_VALUE(hshtb,char *),
                        GET_MIN_VALUE(state,uword)-GET_MIN_VALUE(hshtb,uword) );

    /* write out dynamic portion of heap */
    result |= compress( (unsigned char FAR *)GET_MIN_VALUE(dnamb,char *),
                        GET_MIN_VALUE(dnamp,uword) - GET_MIN_VALUE(dnamb,uword) );

    /* write out minimal register block */
    result |= compress( (unsigned char FAR *)&reg_block, reg_size );
#if EXTFUN
    scanef();                   /* prepare to scan for external functions */
    while ((textlen = (word)nextef(&bufp, 1)) != 0)
#if WINNT
        ;                                                                               /* can't save DLLs! */
#else         /* SOLARIS */
        result |= compress( bufp, textlen );    /* write each function */
#endif          /* SOLARIS */
#endif                                  /* EXTFUN */
    docompress(0, (char *)0, 0);        /* turn off compression */
    return result;
}


/*
 * getsave(fd) - reload a save file.
 *
 * input:  fd - file descriptor of save file to read
 *
 * return: 1 if save file loaded.
 *                 0 if not a save file.
 *        -1 if save file but error during reload.
 */
int getsave(fd)
int fd;
{
    int n;
    unsigned long s;
    FILEPOS pos;
    char *cp;
#if EXTFUN
    unsigned char FAR *bufp;
    int textlen;
#endif                                  /* EXTFUN */
    word adjusts[15];                           /* structure to hold adjustments */

    /*
    / Test if input is from a block device, and if so, peek ahead and
    / see if it's a save file that needs to be loaded.
    */
    if ( testty(fd) && (pos = LSEEK(fd, (FILEPOS)0, 1)) >=0 )
    {
        /* If not char device or pipe, peek ahead to see if it's a save file */
        n = read(fd, (char *)&svfheader.magic1, sizeof(svfheader.magic1));
        LSEEK(fd, pos, 0);           /* Restore position */

        if (n == sizeof(svfheader.magic1) && svfheader.magic1 == OURMAGIC1)
        {
            /*
            /   This is reload of a saved impure data region:  set things
            /   up for a restart  Transfer control to function restart which actually
            /   resumes program execution.
            /
            /   Read file header from save file
            */

            doexpand(0, (char *)0, 0);  /* turn off expansion for header */
            if ( expand( fd, (unsigned char FAR *)&svfheader, sizeof(struct svfilehdr) ) )
                goto reload_ioerr;

            /* Check header validity.   ** UNDER CONSTRUCTION ** */
            if (svfheader.magic1 != OURMAGIC1)
            {
#if USEQUIT
                quit(360);
#else                                   /* USEQUIT */
                cp = "Invalid file ";
                goto reload_err;
#endif                                  /* USEQUIT */
            }

            /*
            /   Setup output and issue brag message
            */
            spitflag = svfheader.flags; /* restore flags */
            spitflag |= NOLIST;         /* no listing (screws up swcoup if reset) */
            setout();

            /* Check version number */
            if ( svfheader.version != SaveVersion )
            {
#if USEQUIT
                quit(361);
#else                                   /* USEQUIT */
                cp = "Wrong save file version.";
                goto reload_verserr;
#endif                                  /* USEQUIT */
            }

            if ( svfheader.sec3size != (GET_DATA_OFFSET(c_yyy,uword) - GET_DATA_OFFSET(c_aaa,uword)) )
            {
#if USEQUIT
                quit(362);
#else                                   /* USEQUIT */
                cp = "Constant section size error.";
                goto reload_verserr;
#endif                                  /* USEQUIT */
            }

            if ( svfheader.sec4size != (GET_DATA_OFFSET(w_yyy,uword) - GET_DATA_OFFSET(g_aaa,uword)) )
            {
#if USEQUIT
                quit(363);
#else                                   /* USEQUIT */
                cp = "Working section size error.";
                goto reload_verserr;
#endif                                  /* USEQUIT */
            }

            if ( svfheader.sec5size !=
                    (uword)((GET_CODE_OFFSET(s_yyy,char *)-GET_CODE_OFFSET(s_aaa,char *))) )
            {
#if USEQUIT
                quit(364);
#else                                   /* USEQUIT */
                cp = "Code section size error.";
                goto reload_verserr;
#endif                                  /* USEQUIT */
            }

#if WINNT
            /*
             * Allocate stack on DOS systems
             */
            lowsp = (char *)sbrk((uword)svfheader.stacksiz);
            if (lowsp == (char *) -1 ||
                    svfheader.stacksiz < svfheader.stacklength + 400)
            {
                cp = "Stack memory unavailable, file ";
                goto reload_err;
            }
#else
            /* build onto existing stack */
            lowsp = (char *)&fd - svfheader.stacksiz - 100;
#endif

            s = svfheader.maxsize - svfheader.dynoff; /* Minimum load address */
#if SUN4
            /* Allocate a buffer for mallocs.  Use the space between the
             * end of data and the start of Minimal's static and dynamic
             * area.  Because of virtual memory, we can use almost 32 megabytes
             * for this region, and it has the secondary benefit of letting
             * us have object sizes greater than the previous 64K.
             */
            if (malloc_init( svfheader.maxsize ))
            {
                cp = "Malloc initialization failure reloading ";
                goto reload_err;
            }
#endif                                  /* SUN4 */

            cp = "Insufficient memory to load ";
            if ((unsigned long)sbrk(0) < s )    /* If DNAMB will be below old MXLEN, */
                if (brk((char *)s))             /*  try to move basemem up. */
                    goto reload_err;

            /* Allocate heap. Restore topmem to its prior state */
            s = svfheader.topmem - svfheader.heapadr;
            basemem = (char *)sbrk((uword)s);
            if (basemem == (char *)-1)
                goto reload_err;
            topmem = basemem + s;
            if (svfheader.databts > (uword)databts)
                databts = svfheader.databts;
            if (svfheader.memincb > (uword)memincb)
                memincb = svfheader.memincb;
            if (svfheader.maxsize > (uword)maxsize)
                maxsize = svfheader.maxsize;
            maxmem = basemem + databts;

            if ( doexpand(svfheader.compress, basemem+svfheader.heapsize,
                          (uword)(topmem-(basemem+svfheader.heapsize))) )
            {
                /* Do decompression if required */
                cp = "Insufficient memory to uncompress file ";
                goto reload_err;
            }

            /* Read saved -u command string if present */
            if (svfheader.uarglen)
                if ( expand( fd, (unsigned char FAR *)uargbuf, svfheader.uarglen ) )
                    goto reload_ioerr;

            /* Read saved stack from save file into tscblk */
            if ( expand( fd, (unsigned char FAR *)pTSCBLK->str, svfheader.stacklength ) )
                goto reload_ioerr;

            SET_MIN_VALUE(stbas, svfheader.stbas,word);
            lmodstk = (word *)(pTSCBLK->str + svfheader.stacklength);
            stacksiz = svfheader.stacksiz;

            /* Reload compiler working globals section */
            if ( expand( fd, GET_DATA_OFFSET(g_aaa,unsigned char FAR *), svfheader.sec4size ) )
                goto reload_ioerr;

            /* Reload important portion of static region */
            if ( expand(fd, (unsigned char FAR *)basemem+svfheader.statoff,
                        GET_MIN_VALUE(state,uword)-GET_MIN_VALUE(hshtb,uword)) )
                goto reload_ioerr;

            /* Reload heap */
            if ( expand(fd, (unsigned char FAR *)basemem+svfheader.dynoff,
                        GET_MIN_VALUE(dnamp,uword)-GET_MIN_VALUE(dnamb,uword)) )
                goto reload_ioerr;

            /* Relocate all pointers because of different reload addresses */
            SET_WA(svfheader.sec5adr);
            SET_WB(svfheader.sec3adr);
            SET_WC(svfheader.sec4adr);
            SET_XR(basemem);
            SET_CP(basemem+svfheader.dynoff);
            SET_XL(adjusts);
            minimal_call(relcr_callid);
            minimal_call(reloc_callid);

            /* Relocate any return addresses in stack */
            SET_WB(pTSCBLK->str);
            SET_WA(pTSCBLK->str + svfheader.stacklength);
            if (svfheader.stacklength)
                minimal_call(relaj_callid);

            /* Note: There are return addresses in the PRC_ variables
             * used by N-type Minimal procedures.  However, there does
             * not appear to be a way for EXIT() to be called from within
             * such an N-type procedure, and so we forego adjusting
             * these variables.
             */

            /* Reload saved compiler registers
             * The only Minimal register in need of relocation is CP,
             * and this is handled by the rereloc routine.
             */
            if ( expand( fd, (unsigned char FAR *)&reg_block, reg_size ) )
                goto reload_ioerr;

            /* No Minimal calls past this point should be done if it
             * involves setting any of the Minimal registers.
             */

#if EXTFUN
            scanef();           /* prepare to scan for external functions */
#if SOLARIS | AIX | WINNT
            while (nextef(&bufp, -1) != (void *)0)
                ((struct efblk *)bufp)->efcod = 0;      /* wipe out each function */
#else         /* SOLARIS */
            while ((textlen = (word)nextef(&bufp, 0)) > 0)  /* read each function */
                if ( expand( fd, bufp, textlen ) )
                    goto reload_ioerr;
            if (textlen < 0)
            {
#if USEQUIT
                quit(365);
#else                                   /* USEQUIT */
                cp = "Insufficient memory to load ";
                goto reload_err;
#endif                                  /* USEQUIT */
            }
#endif          /* SOLARIS */
#endif                                  /* EXTFUN */

            doexpand(0, (char *)0, 0);  /* turn off compression */

            LSEEK(fd, (FILEPOS)0, 2); /* advance to EOF should be a nop */
            pathptr = (char *)-1L;  /* include paths unknown  */
            pINPBUF->next = 0;  /* no chars left in std input buffer  */
            pINPBUF->fill = 0;  /* ditto                                */
            pINPBUF->offset = (FILEPOS)0;
            pINPBUF->curpos = (FILEPOS)0;
            if (uargbuf[0] && !uarg)            /* if uarg in save file and none */
                uarg = uargbuf;                         /* on command line, use saved version */
            provide_name = 0;   /* no need to provide filename in sysrd */
            executing = 1;              /* we're running */
            return 1;                   /* call restart to continue execution   */

reload_verserr:
            write( STDERRFD,  cp, length(cp) );
            wrterr( "" );
            write( STDERRFD, "Need ", 5);
            write( STDERRFD, ((svfheader.version>>VWBSHFT) & 0xF)==2 ? "32" : "64", 2);
            write( STDERRFD, "-bit SPITBOL release ", 21);
            write( STDERRFD, svfheader.headv, length(svfheader.headv) );
            write( STDERRFD, svfheader.iov, length(svfheader.iov) );
            cp = " to load file ";
            goto reload_err;
reload_ioerr:
#if USEQUIT
            quit(366);
#else                                   /* USEQUIT */
            cp = "Error reading ";
reload_err:
            write( STDERRFD,  cp, length(cp) );
            write( STDERRFD,  *inpptr, length(*inpptr) );
            wrterr( "" );
            return -1;
#endif                                  /* USEQUIT */
        }
    }
    return 0;
}

#endif          /* SAVEFILE | EXECSAVE */

