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
/       File:  SYSLD.C          Version:  01.03
/       ---------------------------------------
/
/       Contents:       Function zysld
/
*/

/*
/       zysld - load external function
/
/       Parameters:
/           XR - pointer to SCBLK containing function name
/           XL - pointer to SCBLK containing library name
/       Returns:
/           XR - pointer to code (or other data structure) to be stored in the EFBLK.
/       Exits:
/           1 - function does not exist
/           2 - I/O error loading function
/           3 - insufficient memory
/
/
/       WARNING:  THIS FUNCTION CALLS A FUNCTION WHICH MAY INVOKE A GARBAGE
/       COLLECTION.  STACK MUST REMAIN WORD ALIGNED AND COLLECTABLE.
/
/       V1.01 09/09/90  Rearrange so that dynamic variables are not
/                                       on stack when loadef is called.  If they are, and
/                                       a garbage collection is triggered, garbage text in
/                                       dynamic area could foul up garbage collector.
/                                       Fixed for SPITBOL-386 v1.08.
/
/       V1.02 11/25/90  Add exit 3 return for insufficient memory.
/
/   V1.02 4-Sep-91  <withdrawn>.
*/

#include "port.h"

#if AIX | SOLARIS | LINUX
#include <fcntl.h>
#endif

#if EXTFUN
static word openloadfile Params((char *namebuf));
static void closeloadfile Params((word fd));
#endif                                  /* EXTFUN */

zysld()
{
#if EXTFUN
    word fd;                                    /* keep stack word-aligned */
    void *result = 0;

    fd = openloadfile(pTSCBLK->str);
    if ( fd != -1 ) {                   /* If file opened OK */
        result = loadef(fd, pTSCBLK->str); /* Invoke loader */
        closeloadfile(fd);
        switch ((word)result) {
        case (word)0:
            return EXIT_2;                      /* I/O error */
        case (word)-1:
            return EXIT_1;                      /* doesn't exist */
        case (word)-2:
            return EXIT_3;                      /* insufficient memory */
        default:
            SET_XR(result);
            return NORMAL_RETURN;       /* Success, return pointer to stuff in EFBLK */
        }
    }
    else
        return EXIT_1;
}


static void closeloadfile(fd)
word fd;
{
}

static word openloadfile(file)
char *file;
{

    register struct scblk *lnscb = XL (struct scblk *);
    register struct scblk *fnscb = XR (struct scblk *);
    char *savecp;
    char savechar;

#if  | AIX | WINNT
    /* Kludge for DLLs:  openloadfile returns TWO pieces of information:
     *   The handle for the DLL file is returned as the function result.
     *   The address of the DLL function is returned as a word in the
     *   beginning of the the filename buffer passed in as an argument.
     */
    typedef int (*PFN)();
    word fd;
    char file2[512];
    PFN pfn;
    extern word loadDll Params((char *dllName, char *fcnName, PFN *pfn));

    /* Search strategy for DLLs:
     *  If explicit library name given, then
     *     use it.
     *  Else
     *     Append .slf extension to filename.
     *     Use initpath and trypath to find it in SNOLIB.
     *     If not found, then
    *        Use unmodified function name.  Note:  This may
     *        not include a search of the current directory, unless
     *        LIBPATH includes ".\"!
     */

    if (lnscb->len >= 512)
        return -1;

    savecp = fnscb->str + fnscb->len;           /* Make function name a C string for now. */
    savechar = make_c_str(savecp);

    if (lnscb->len == 0) {                                      /* If no library name, first try */
        /* function name with ".slf" extension */
#if SOLARIS
        /* force lookup in local directory */
        file2[0] = '.';
        file2[1] = '/';
        appendext(fnscb->str,EFNEXT,&file2[2],1);
        fd = loadDll(file2, fnscb->str, &pfn);
#else
        appendext(fnscb->str,EFNEXT,file,1); /* append .slf extension to function name */
        fd = loadDll(file, fnscb->str, &pfn);
#endif
        if (fd == -1) {                                         /* if couldn't open in local directory */
            mystrcpy(file2,file);
            initpath(SPITFILEPATH);                     /* try alternate paths along SNOLIB */
            while (trypath(file2,file)) {
                fd = loadDll(file, fnscb->str, &pfn);
                if (fd != -1)
                    break;
            }
            if (fd == -1)                                       /* if not found as an .slf file */
                fd = loadDll(fnscb->str, fnscb->str, &pfn);
        }
    }
    else {                                                      /* Explicit library name given */
        char *savecp2;
        char savechar2;
        savecp2 = lnscb->str + lnscb->len;      /* Make it a C string for now. */
        savechar2 = make_c_str(savecp2);
        fd = loadDll(lnscb->str, fnscb->str, &pfn);
        if (fd == -1)
        {
            mystrcpy(file2,lnscb->str);         /* Try via SNOLIB */
            initpath(SPITFILEPATH);
            while (trypath(file2,file))
            {
                fd = loadDll(file, fnscb->str, &pfn);
                if (fd != -1)
                    break;
            }
#if SOLARIS | AIX
            if (fd == -1)
            {
                /* force lookup in local directory */
                file2[0] = '.';
                file2[1] = '/';
                mystrcpy(&file2[2],lnscb->str);
                fd = loadDll(file2, fnscb->str, &pfn);
            }
#endif
        }
        unmake_c_str(savecp2, savechar2);
    }

    unmake_c_str(savecp, savechar);                     /* Restore saved char in function name */
    *(PFN *)file = pfn;                 /* Return function address in file buffer */
    return fd;
#endif          /* SOLARIS | AIX | WINNT */
}


#else                                   /* EXTFUN */
    return EXIT_1;
}
#endif                                  /* EXTFUN */
