
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields
*/

/*
/    zysif - start/stop using include file
/
/    zysif stacks the current input stream and opens a new include file.
/        It is also called when an EOF is read to restore the stacked file.
/
/    Parameters:
/        XL     pointer to SCBLK with name of file.
/              0 to end use of file.
/        XR - pointer to vacant SCBLK that will receive the name of the
/             file finally opened, after looking in other directories.
/    Returns:
/        XR - scblk filled in with full path name and length.
/    Exits:
/         1 - could not find file
/
*/

#include "port.h"

#include <fcntl.h>

static void openprev(void);

/*
/  Helper function to back up one file in the include nesting.
*/

static void
openprev()
{
    fd = inc_fd[--nesting]; /* Unstack one level */
    dup(fd);                /* Create fd 0 for previous file */
    close(fd);              /* Release dup'ed fd of old file */
    fd = 0;
    clrbuf();

    doset(getrdiob(), inc_pos[nesting], 0); /* Position file where left off */
}

int
zysif()
{
    struct scblk *fnscb = XL(struct scblk *);
    struct scblk *pnscb = XR(struct scblk *);
    char *savecp;
    char savechar, filebuf[256];
    char *file;

    if(fnscb) {
        /* Here to nest another include file */
        if(nesting == INCLUDE_DEPTH) /* Is there room in array? */
            return EXIT_1;

        inc_pos[nesting] =
            doset(getrdiob(), 0L, 1); /* Record current position */
        inc_fd[nesting++] = dup(0);   /* Save current input file */
        close(0);                     /* Make fd 0 available */
        clrbuf();
        savecp = fnscb->str + fnscb->len; /* Make it a C string for now. */
        savechar = *savecp;
        *savecp = '\0';
        file = fnscb->str;
        fd = spit_open(file, O_RDONLY, IO_PRIVATE | IO_DENY_WRITE,
                       IO_OPEN_IF_EXISTS); /* Open file */
        if(fd < 0) {
            /* If couldn't open, try alternate paths via SNOLIB */
            initpath(SPITFILEPATH);
            file = filebuf;
            while(trypath(fnscb->str, file)) {
                fd = spit_open(file, O_RDONLY, IO_PRIVATE | IO_DENY_WRITE,
                               IO_OPEN_IF_EXISTS);
                if(fd >= 0)
                    break;
            }
        }
        if(fd < 0) {
            /* If still not open, look in directory where SPITBOL resides. */
            int i = pathlast(gblargv[0]) - gblargv[0];
            if(i) {
                mystrncpy(filebuf, gblargv[0], i);
                mystrcpy(&filebuf[i], fnscb->str);
                fd = spit_open(filebuf, O_RDONLY, IO_PRIVATE | IO_DENY_WRITE,
                               IO_OPEN_IF_EXISTS);
            }
        }
        if(fd < 0 && sfn && sfn[0]) {
            /* If still not open, look in directory where first source file resides. */
            int i = pathlast(sfn) - sfn;
            if(i) {
                mystrncpy(filebuf, sfn, i);
                mystrcpy(&filebuf[i], fnscb->str);
                fd = spit_open(filebuf, O_RDONLY, IO_PRIVATE | IO_DENY_WRITE,
                               IO_OPEN_IF_EXISTS);
            }
        }
        if(fd >= 0) { /* If file opened OK */
            cpys2sc(file, pnscb, pnscb->len);
            *savecp = savechar; /* Restore saved char */
        } else {                /* Couldn't open file */
            *savecp = savechar; /* Restore saved char */
            openprev();         /* Restore input file we just closed */
            return EXIT_1;      /* Fail */
        }
    }
    /*
       /  EOF read.  Pop back one include file.
     */
    else {
        if(nesting > 0) { /* Make sure don't go too far */
            close(fd);    /* Close last include file */
            openprev();   /* Reopen previous include file */
        }
    }
    return NORMAL_RETURN;
}
