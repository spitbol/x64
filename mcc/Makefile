#
# MCC - Miniml  C Compiler - Makefile
#

TOP ?= .
include $(TOP)/config.mak

CFLAGS+=-g -Wall
CFLAGS_P=$(CFLAGS) -pg -static -DCONFIG_MCC_STATIC
LIBS_P=

ifneq ($(GCC_MAJOR),2)
CFLAGS+=-fno-strict-aliasing
endif

ifeq ($(ARCH),i386)
CFLAGS+=-mpreferred-stack-boundary=2
ifeq ($(GCC_MAJOR),2)
CFLAGS+=-m386 -malign-functions=0
else
CFLAGS+=-march=i386 -falign-functions=0
ifneq ($(GCC_MAJOR),3)
CFLAGS+=-Wno-pointer-sign -Wno-sign-compare -D_FORTIFY_SOURCE=0
endif
endif
endif

ifeq ($(ARCH),x86-64)
CFLAGS+=-Wno-pointer-sign
endif

ifndef CONFIG_WIN32
LIBS=-lm
ifndef CONFIG_NOLDL
LIBS+=-ldl
endif
endif

ifdef CONFIG_WIN32
NATIVE_TARGET=-DMCC_TARGET_PE
LIBMCC1=libmcc1.a
else
ifeq ($(ARCH),i386)
NATIVE_TARGET=-DMCC_TARGET_I386
LIBMCC1=libmcc1.a
BCHECK_O=bcheck.o
else
ifeq ($(ARCH),arm)
NATIVE_TARGET=-DMCC_TARGET_ARM
NATIVE_TARGET+=$(if $(wildcard /lib/ld-linux.so.3),-DMCC_ARM_EABI)
NATIVE_TARGET+=$(if $(shell grep -l "^Features.* \(vfp\|iwmmxt\) " /proc/cpuinfo),-DMCC_ARM_VFP)
else
ifeq ($(ARCH),x86-64)
NATIVE_TARGET=-DMCC_TARGET_X86_64
LIBMCC1=libmcc1.a
endif
endif
endif
endif

ifneq ($(wildcard /lib/ld-uClibc.so.0),)
NATIVE_TARGET+=-DMCC_UCLIBC
BCHECK_O=
endif

ifdef CONFIG_USE_LIBGCC
LIBMCC1=
endif

ifeq ($(TOP),.)

PROGS=mcc$(EXESUF)

I386_CROSS = i386-mcc$(EXESUF)
WIN32_CROSS = i386-win32-mcc$(EXESUF)
X64_CROSS = x86_64-mcc$(EXESUF)
ARM_CROSS = arm-mcc-fpa$(EXESUF) arm-mcc-fpa-ld$(EXESUF) \
    arm-mcc-vfp$(EXESUF) arm-mcc-vfp-eabi$(EXESUF)
C67_CROSS = c67-mcc$(EXESUF)

CORE_FILES = mcc.c libmcc.c mccpp.c mccgen.c mccelf.c mccasm.c \
    mcc.h config.h libmcc.h mcctok.h
I386_FILES = $(CORE_FILES) i386-gen.c i386-asm.c i386-asm.h
WIN32_FILES = $(CORE_FILES) i386-gen.c i386-asm.c i386-asm.h mccpe.c
X86_64_FILES = $(CORE_FILES) x86_64-gen.c
ARM_FILES = $(CORE_FILES) arm-gen.c
C67_FILES = $(CORE_FILES) c67-gen.c mcccoff.c

ifdef CONFIG_WIN32
PROGS+=tiny_impdef$(EXESUF) tiny_libmaker$(EXESUF)
NATIVE_FILES=$(WIN32_FILES)
PROGS_CROSS=$(I386_CROSS) $(X64_CROSS) $(ARM_CROSS) $(C67_CROSS)
else
ifeq ($(ARCH),i386)
NATIVE_FILES=$(I386_FILES)
PROGS_CROSS=$(X64_CROSS) $(WIN32_CROSS) $(ARM_CROSS) $(C67_CROSS)
else
ifeq ($(ARCH),x86-64)
NATIVE_FILES=$(X86_64_FILES)
PROGS_CROSS=$(I386_CROSS) $(WIN32_CROSS) $(ARM_CROSS) $(C67_CROSS)
else
ifeq ($(ARCH),arm)
NATIVE_FILES=$(ARM_FILES)
PROGS_CROSS=$(I386_CROSS) $(X64_CROSS) $(WIN32_CROSS) $(C67_CROSS)
endif
endif
endif
endif

ifdef CONFIG_CROSS
PROGS+=$(PROGS_CROSS)
endif

all: $(PROGS) $(LIBMCC1) $(BCHECK_O) libmcc.a mcc-doc.html mcc.1 libmcc_test$(EXESUF)

# Host Tiny C Compiler
mcc$(EXESUF): $(NATIVE_FILES)
	$(CC) -o $@ $< $(NATIVE_TARGET) $(CFLAGS) $(LIBS)

# Cross Tiny C Compilers
i386-mcc$(EXESUF): $(I386_FILES)
	$(CC) -o $@ $< -DMCC_TARGET_I386 $(CFLAGS) $(LIBS)

i386-win32-mcc$(EXESUF): $(WIN32_FILES)
	$(CC) -o $@ $< -DMCC_TARGET_PE $(CFLAGS) $(LIBS)

x86_64-mcc$(EXESUF): $(X86_64_FILES)
	$(CC) -o $@ $< -DMCC_TARGET_X86_64 $(CFLAGS) $(LIBS)

c67-mcc$(EXESUF): $(C67_FILES)
	$(CC) -o $@ $< -DMCC_TARGET_C67 $(CFLAGS) $(LIBS)

arm-mcc-fpa$(EXESUF): $(ARM_FILES)
	$(CC) -o $@ $< -DMCC_TARGET_ARM $(CFLAGS) $(LIBS)

arm-mcc-fpa-ld$(EXESUF): $(ARM_FILES)
	$(CC) -o $@ $< -DMCC_TARGET_ARM -DLDOUBLE_SIZE=12 $(CFLAGS) $(LIBS)

arm-mcc-vfp$(EXESUF): $(ARM_FILES)
	$(CC) -o $@ $< -DMCC_TARGET_ARM -DMCC_ARM_VFP $(CFLAGS) $(LIBS)

arm-mcc-vfp-eabi$(EXESUF): $(ARM_FILES)
	$(CC) -o $@ $< -DMCC_TARGET_ARM -DMCC_ARM_EABI $(CFLAGS) $(LIBS)

# libmcc generation and test
libmcc.o: $(NATIVE_FILES)
	$(CC) -o $@ -c libmcc.c $(NATIVE_TARGET) $(CFLAGS)

libmcc.a: libmcc.o
	$(AR) rcs $@ $^

libmcc_test$(EXESUF): tests/libmcc_test.c libmcc.a
	$(CC) -o $@ $^ -I. $(CFLAGS) $(LIBS)

libtest: libmcc_test$(EXESUF) $(LIBMCC1)
	./libmcc_test$(EXESUF) lib_path=.

# profiling version
mcc_p$(EXESUF): $(NATIVE_FILES)
	$(CC) -o $@ $< $(NATIVE_TARGET) $(CFLAGS_P) $(LIBS_P)

# windows utilities
tiny_impdef$(EXESUF): win32/tools/tiny_impdef.c
	$(CC) -o $@ $< $(CFLAGS)
tiny_libmaker$(EXESUF): win32/tools/tiny_libmaker.c
	$(CC) -o $@ $< $(CFLAGS)

# TinyCC runtime libraries
LIBMCC1_OBJS=libmcc1.o
LIBMCC1_CC=$(CC)
VPATH+=lib
ifdef CONFIG_WIN32
# for windows, we must use MCC because we generate ELF objects
LIBMCC1_OBJS+=crt1.o wincrt1.o dllcrt1.o dllmain.o chkstk.o
LIBMCC1_CC=./mcc.exe -Bwin32 -DMCC_TARGET_PE
VPATH+=win32/lib
endif
ifeq ($(ARCH),i386)
LIBMCC1_OBJS+=alloca86.o alloca86-bt.o
endif

%.o: %.c
	$(LIBMCC1_CC) -o $@ -c $< -O2 -Wall

%.o: %.S
	$(LIBMCC1_CC) -o $@ -c $<

libmcc1.a: $(LIBMCC1_OBJS)
	$(AR) rcs $@ $^

bcheck.o: bcheck.c
	$(CC) -o $@ -c $< -O2 -Wall

# install
MCC_INCLUDES = stdarg.h stddef.h stdbool.h float.h varargs.h mcclib.h
INSTALL=install

ifndef CONFIG_WIN32
install: $(PROGS) $(LIBMCC1) $(BCHECK_O) libmcc.a mcc.1 mcc-doc.html
	mkdir -p "$(bindir)"
	$(INSTALL) -s -m755 $(PROGS) "$(bindir)"
	mkdir -p "$(mandir)/man1"
	$(INSTALL) mcc.1 "$(mandir)/man1"
	mkdir -p "$(mccdir)"
	mkdir -p "$(mccdir)/include"
ifneq ($(LIBMCC1),)
	$(INSTALL) -m644 $(LIBMCC1) "$(mccdir)"
endif
ifneq ($(BCHECK_O),)
	$(INSTALL) -m644 $(BCHECK_O) "$(mccdir)"
endif
	$(INSTALL) -m644 $(addprefix include/,$(MCC_INCLUDES)) "$(mccdir)/include"
	mkdir -p "$(docdir)"
	$(INSTALL) -m644 mcc-doc.html "$(docdir)"
	mkdir -p "$(libdir)"
	$(INSTALL) -m644 libmcc.a "$(libdir)"
	mkdir -p "$(includedir)"
	$(INSTALL) -m644 libmcc.h "$(includedir)"

uninstall:
	rm -fv $(foreach P,$(PROGS),"$(bindir)/$P")
	rm -fv $(foreach P,$(LIBMCC1) $(BCHECK_O),"$(mccdir)/$P")
	rm -fv $(foreach P,$(MCC_INCLUDES),"$(mccdir)/include/$P")
	rm -fv "$(docdir)/mcc-doc.html" "$(mandir)/man1/mcc.1"
	rm -fv "$(libdir)/libmcc.a" "$(includedir)/libmcc.h"

else
install: $(PROGS) $(LIBMCC1) libmcc.a mcc-doc.html
	mkdir -p "$(mccdir)"
	mkdir -p "$(mccdir)/lib"
	mkdir -p "$(mccdir)/include"
	mkdir -p "$(mccdir)/examples"
	mkdir -p "$(mccdir)/doc"
	mkdir -p "$(mccdir)/libmcc"
	$(INSTALL) -s -m755 $(PROGS) "$(mccdir)"
	$(INSTALL) -m644 $(LIBMCC1) win32/lib/*.def "$(mccdir)/lib"
	cp -r win32/include/. "$(mccdir)/include"
	cp -r win32/examples/. "$(mccdir)/examples"
#	$(INSTALL) -m644 $(addprefix include/,$(MCC_INCLUDES)) "$(mccdir)/include"
	$(INSTALL) -m644 mcc-doc.html win32/mcc-win32.txt "$(mccdir)/doc"
	$(INSTALL) -m644 libmcc.a libmcc.h "$(mccdir)/libmcc"
endif

# documentation and man page
mcc-doc.html: mcc-doc.texi
	-texi2html -monolithic -number $<

mcc.1: mcc-doc.texi
	-./texi2pod.pl $< mcc.pod
	-pod2man --section=1 --center=" " --release=" " mcc.pod > $@

# tar release (use 'make -k tar' on a checkouted tree)
MCC-VERSION=mcc-$(shell cat VERSION)
tar:
	rm -rf /tmp/$(MCC-VERSION)
	cp -r . /tmp/$(MCC-VERSION)
	( cd /tmp ; tar zcvf ~/$(MCC-VERSION).tar.gz $(MCC-VERSION) --exclude CVS )
	rm -rf /tmp/$(MCC-VERSION)

# in tests subdir
test clean :
	$(MAKE) -C tests $@

# clean
clean: local_clean
local_clean:
	rm -vf $(PROGS) mcc_p$(EXESUF) mcc.pod *~ *.o *.a *.out libmcc_test$(EXESUF)

distclean: clean
	rm -vf config.h config.mak config.texi mcc.1 mcc-doc.html

endif # ifeq ($(TOP),.)
