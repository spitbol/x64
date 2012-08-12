tcc -o tcc tcc.c -DTCC_TARGET_I386 -O2 -g -Wall -mpreferred-stack-boundary=2 -m386 -malign-functions=0 -lm -L/usr/lib/i386/linux-gnu -ldl
In file included from tcc.c:21:
In file included from libtcc.c:21:
In file included from tcc.h:31:
In file included from /usr/include/stdlib.h:25:
/usr/include/features.h:324: include file 'bits/predefs.h' not found
make: *** [tcc] Error 1
