# X32 SPITBOL makefile using gcc
#

ARCH?=x32
ifeq ($(ARCH),x32)
ARCHDEF=-D ARCH_X32_8
ARCHX=x32
CHARBITS=8
ELF=elf32
endif
ifeq ($(ARCH),x32.8)
ARCHDEF=-D ARCH_X32_8
ARCHX=x32
CHARBITS=8
ELF=elf32
endif
ifeq ($(ARCH),x32.32)
ARCH=x32
ARCHDEF=-D ARCH_X32_32
ARCHX=x32
CHARBITS=32
ELF=elf32
endif
ifeq ($(ARCH),x64)
ARCHDEF=-D ARCH_X64
ARCHX=x64
CHARBITS=8
ELF=elf64
endif

# SPITBOL Version:
MIN=   s
DEBUG=	1

# Minimal source directory.
MINPATH=./

OSINT=./osint

vpath %.c $(OSINT)



CC	=	gcc
ASM	=	nasm
INCDIRS = -I./tcc/include -I./musl/include
# next is for tcc
ifeq	($(DEBUG),0)
CFLAGS= $(ARCHDEF) -m32 -fno-leading-underscore
else
CFLAGS= $(ARCHDEF) -g -m32 -fno-leading-underscore
endif

# Assembler info -- Intel 32-bit syntax
ifeq	($(DEBUG),0)
ASMFLAGS = -f $(ELF) -DCHARBITS=$(CHARBITS)
else
ASMFLAGS = -g -f $(ELF) -DCHARBITS=$(CHARBITS)
endif

# Tools for processing Minimal source file.
LEX=	lex.spt
COD=    asm.spt
ERR=    err.spt
BASEBOL =   ./basebol

# Implicit rule for building objects from C files.
./%.o: %.c
#.c.o:
	$(CC)  $(CFLAGS) -c  -o$@ $(OSINT)/$*.c

# Implicit rule for building objects from assembly language files.
.s.o:
	$(ASM) $(ASMFLAGS) -l $*.lst -o$@ $*.s

# C Headers common to all versions and all source files of SPITBOL:
CHDRS =	$(OSINT)/osint.h $(OSINT)/port.h $(OSINT)/sproto.h $(OSINT)/spitio.h $(OSINT)/spitblks.h $(OSINT)/globals.h

# C Headers unique to this version of SPITBOL:
UHDRS=	$(OSINT)/systype.h $(OSINT)/extern32.h $(OSINT)/blocks32.h $(OSINT)/system.h

# Headers common to all C files.
HDRS=	$(CHDRS) $(UHDRS)

# Headers for Minimal source translation:
VHDRS=	$(ARCHX).hdr 

# OSINT objects:
SYSOBJS=sysax.o sysbs.o sysbx.o syscm.o sysdc.o sysdt.o sysea.o \
	sysef.o sysej.o sysem.o sysen.o sysep.o sysex.o sysfc.o \
	sysgc.o syshs.o sysid.o sysif.o sysil.o sysin.o sysio.o \
	sysld.o sysmm.o sysmx.o sysou.o syspl.o syspp.o sysrw.o \
	sysst.o sysstdio.o systm.o systty.o sysul.o sysxi.o 

# Other C objects:
COBJS =	break.o checkfpu.o compress.o cpys2sc.o \
	doset.o dosys.o fakexit.o float.o flush.o gethost.o getshell.o \
	int.o lenfnm.o math.o optfile.o osclose.o \
	osopen.o ospipe.o osread.o oswait.o oswrite.o prompt.o rdenv.o \
	st2d.o stubs.o swcinp.o swcoup.o syslinux.o testty.o\
	trypath.o uc.o wrtaout.o zz.o

# Assembly langauge objects common to all versions:
# CAOBJS is for gas, NAOBJS for nasm
CAOBJS = 
NAOBJS = $(ARCHX).o err.o

# Objects for SPITBOL's HOST function:
#HOBJS=	hostrs6.o scops.o kbops.o vmode.o
HOBJS=

# Objects for SPITBOL's LOAD function.  AIX 4 has dlxxx function library.
#LOBJS=  load.o
#LOBJS=  dlfcn.o load.o
LOBJS=

# main objects:
MOBJS=	getargs.o main.o

# All assembly language objects
AOBJS = $(CAOBJS)

# Minimal source object file:
VOBJS =	s.o

# All objects:
OBJS=	$(AOBJS) $(COBJS) $(HOBJS) $(LOBJS) $(SYSOBJS) $(VOBJS) $(MOBJS) $(NAOBJS)

# link spitbol with static linking
spitbol: $(OBJS)
ifeq ($(ARCHX),x32)
	$(CC) $(CFLAGS) $(OBJS) -static /usr/lib/i386-linux-gnu/libm.a -ospitbol -Wl,-M,-Map,spitbol.map
endif
ifeq ($(ARCHX),x64)
	$(CC) $(CFLAGS) $(OBJS) -static /usr/lib/i386-linux-gnu/libm.a -ospitbol -Wl,-M,-Map,spitbol.map
endif

# link spitbol with dynamic linking
spitbol-dynamic: $(OBJS)
ifeq ($(ARCHX),x32)
	$(CC) $(CFLAGS) $(OBJS) /usr/lib/i386-linux-gnu/libm.a -ospitbol -Wl,-M,-Map,spitbol.map
endif
ifeq ($(ARCHX),x64)
	$(CC) $(CFLAGS) $(OBJS) /usr/lib/i386-linux-gnu/libm.a -ospitbol -Wl,-M,-Map,spitbol.map
endif

# Assembly language dependencies:
err.o: err.s
s.o: s.s

err.o: err.s


# SPITBOL Minimal source
s.s:	s.lex $(VHDRS) $(COD) 
	$(BASEBOL) -u $(ARCH) $(COD)

s.lex: $(MINPATH)$(MIN).min $(MIN).cnd $(LEX)
#	 $(BASEBOL) -u "s" $(LEX)
	 $(BASEBOL) -u $(ARCH) $(LEX)

s.err: s.s

err.s: $(MIN).cnd $(ERR) s.s
	   $(BASEBOL) -1=s.err -2=err.s $(ERR)


# make osint objects
cobjs:	$(COBJS)

# C language header dependencies:
$(COBJS): $(HDRS)
$(MOBJS): $(HDRS)
$(SYSOBJS): $(HDRS)
main.o: $(OSINT)/save.h
sysgc.o: $(OSINT)/save.h
sysxi.o: $(OSINT)/save.h
dlfcn.o: dlfcn.h

boot:
	cp -p bootstrap/s.s bootstrap/s.lex bootstrap/err.s .

# install spitbol as the symstem spitbol compiler
install:
	sudo cp spitbol /usr/local/bin
# install basebol as the system spitbol compiler
install-basebol:
	sudo cp basebol /usr/local/bin/spitbol
clean:
	rm -f $(OBJS) *.o *.lst *.map *.err s.lex s.tmp s.s err.s s.S s.t
z:
	nm -n s.o >s.nm
	spitbol map-$(ARCHX).spt <s.nm >s.dic
	spitbol z.spt <ad >ae
