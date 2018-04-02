/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields
*/

//	zysld - load external function
//
//	Parameters:
//	    XR - pointer to SCBLK containing function name
//	    XL - pointer to SCBLK containing library name
//	Returns:
//	    XR - pointer to code (or other data structure) to be stored in the EFBLK.
//	Exits:
//	    1 - function does not exist
//	    2 - I/O error loading function
//	    3 - insufficient memory
//
//
//	WARNING:  THIS FUNCTION CALLS A FUNCTION WHICH MAY INVOKE A GARBAGE
//	COLLECTION.  STACK MUST REMAIN WORD ALIGNED AND COLLECTABLE.
//

#include "port.h"
       #define _GNU_SOURCE
       
#include <dlfcn.h>
#include <fcntl.h>

#if EXTFUN
static void *openloadfile (char *namebuf);
static void closeloadfile (void *fd);

#endif					// EXTFUN
/* xL - "."
wa - ox42
IA - 0
WC - 0
*/
int zysld(void)
{
#if EXTFUN
    void *fd;					// keep stack word-aligned
    void *result = 0;
    char prototype[2048],library_name[2048];
    struct efblk *efblk = WB(struct efblk *);
    char savech1;
    struct scblk  *scbf = XL(struct scblk *);
    
    struct scblk  *scbp = XR(struct scblk *);
    char savech2;
    
    savech1 = make_c_str(scbf->str+scbf->len);
    savech2 = make_c_str(scbp->str+scbp->len);
    
    fd = openloadfile(scbf->str);
    char *errstr;
    
    errstr = dlerror();
//    if (errstr != NULL)
//    fprintf (stderr,"A dynamic linking error occurred: (%s)\n", errstr);
	
//    fd = openloadfile(ptscblk->str);
    if ( fd ) {			// If file opened OK
	typedef void *(*PFN)();				// pointer to function
	PFN pfnProcAddress;

        // syslinux would look for the symbol too. Dont know if you shoud close -c ould still be open    
         pfnProcAddress = (PFN)dlsym(fd, scbp->str);
         errstr = dlerror();
//         if (errstr != NULL)
//             fprintf (stderr,"A dynamic somehow linking error occurred: (%s)\n", errstr);
        if (!pfnProcAddress) {
          dlclose(fd);
	  unmake_c_str(scbf->str+scbf->len,savech1);
  	  unmake_c_str(scbp->str+scbf->len,savech2);
          return EXIT_1;
          }
    
	unmake_c_str(scbf->str+scbf->len,savech1);
	unmake_c_str(scbp->str+scbf->len,savech2);
        result = loadef((word)fd, pfnProcAddress); // Invoke loader
        switch ((word)result) {
        case (word)0:
            return EXIT_2;			// I/O error
        case (word)-1:
            return EXIT_1;			// doesn't exist
        case (word)-2:
            return EXIT_3;			// insufficient memory
        default:
//	    efblk->efcod = result; - this is done is slod6
	    SET_XL(efblk);
            SET_XR(result);
            return NORMAL_RETURN;	// Success, return pointer to stuff in EFBLK
        } // case
    } // if opened load file
    else {
    	unmake_c_str(scbf->str+scbf->len,savech1);
    	unmake_c_str(scbp->str+scbf->len,savech2);
	
        return EXIT_1;
	}
}



static void closeloadfile(fd)
void *fd;
{
dlclose(fd);
}

static void *openloadfile(file)
char *file;
{
// return dlopen(file, RTLD_LAZY);
// LAZY is good for glibc, but musl-c needs it fully loaded
// see https://wiki.musl-libc.org/functional-differences-from-glibc.html
return dlopen(file, RTLD_NOW);
}
#else					// EXTFUN
    return (NULL);
}
#endif					// EXTFUN
