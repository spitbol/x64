/* manage system resource limits */

#include <sys/time.h>
#include <sys/resource.h>
#include <stdio.h>

void syslimits() {

struct rlimit {
	rlim_t rlim_cur; /* soft limit */
	rlim_t rlim_max; /* hard limit */
} rlim;

int rc;

	rc = getrlimit(RLIMIT_AS, &rlim);
	printf("RLIMIT_AS rc %d soft %d hard %d\n", rc, rlim.rlim_cur, rlim.rlim_max);

	rc = getrlimit(RLIMIT_DATA, &rlim);
	printf("RLIMIT_DATA rc %d soft %d hard %d\n", rc, rlim.rlim_cur, rlim.rlim_max);

	rc = getrlimit(RLIMIT_STACK, &rlim);
	printf("RLIMIT_STACK rc %d soft %d hard %d\n", rc, rlim.rlim_cur, rlim.rlim_max);

}

