
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields
*/

/*    zysld - load external function */

/* */

/*    Parameters: */

/*        XR - pointer to SCBLK containing function name */

/*        XL - pointer to SCBLK containing library name */

/*    Returns: */

/*        XR - pointer to code (or other data structure) to be stored in the EFBLK. */

/*    Exits: */

/*        1 - function does not exist */

/*        2 - I/O error loading function */

/*        3 - insufficient memory */

/* */

/* */

/*    WARNING:  THIS FUNCTION CALLS A FUNCTION WHICH MAY INVOKE A GARBAGE */

/*    COLLECTION.  STACK MUST REMAIN WORD ALIGNED AND COLLECTABLE. */

/* */

#include "port.h"
#include <dlfcn.h>
#include <fcntl.h>

#if EXTFUN
static void *openloadfile(char *namebuf);
static void closeloadfile(void *fd);
#endif /* EXTFUN */

int
zysld()
{
#if EXTFUN
    void *fd; /* keep stack word-aligned */
    void *result = 0;

    fd = openloadfile(ptscblk->str);
    if(fd != -1) {                         /* If file opened OK */
        result = loadef(fd, ptscblk->str); /* Invoke loader */
        closeloadfile(fd);
        switch((word)result) {
        case(word)0:
            return EXIT_2; /* I/O error */
        case(word)-1:
            return EXIT_1; /* doesn't exist */
        case(word)-2:
            return EXIT_3; /* insufficient memory */
        default:
            SET_XR(result);
            return NORMAL_RETURN; /* Success, return pointer to stuff in EFBLK */
        }
    } else
        return EXIT_1;
}

static void
closeloadfile(word fd)
{}

static void *
openloadfile(char *file)
{

    struct scblk *lnscb = XL(struct scblk *);
    struct scblk *fnscb = XR(struct scblk *);
    char *savecp;
    char savechar;
    void *handle;
    handle = dlopen(file, RTLD_LAZY);
    if(handle == NULL)
        return EXIT_1;
    else {
        /* todo ... */
        return EXIT_NORMAL
    }
#else  /* EXTFUN */
    return EXIT_1;
}
#endif /* EXTFUN */
