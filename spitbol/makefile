# Linux/386 SPITBOL
#


# SPITBOL Version:
VERS=   linux
DEBUG=	1

# Minimal source directory.
MINPATH=./

OSINT=./osint

vpath %.c $(OSINT)


# Compiler info:
# Use POWER architecture for instruction generation until want to
# produce a version that runs on PowerPC, then change to -qarch=com.
CC=     gcc
ifeq	($(DEBUG),0)
CFLAGS= -m32 -O2 -fno-leading-underscore -mfpmath=387
else
CFLAGS= -g -m32 -fno-leading-underscore -mfpmath=387
endif

# Assembler info -- Intel 32-bit syntax
ifeq	($(DEBUG),0)
ASFLAGS = --32 -msyntax=intel -mmnemonic=intel -mnaked-reg
else
ASFLAGS = --32 -g -gstabs+ -msyntax=intel -mmnemonic=intel -mnaked-reg
endif

# Tools for processing Minimal source file.
TOK=	token.spt
COD=    codlinux.spt
ERR=    err386.spt
SPIT=   ../boot/spitbol

# Implicit rule for building objects from C files.
./%.o: %.c
#.c.o:
	$(CC) -c $(CFLAGS) -o$@ $(OSINT)/$*.c

# Implicit rule for building objects from assembly language files.
.s.o:
	$(AS) -a=$*.lst -o $@ $(ASFLAGS) $*.s

# C Headers common to all versions and all source files of SPITBOL:
CHDRS =	$(OSINT)/osint.h $(OSINT)/port.h $(OSINT)/sproto.h $(OSINT)/spitio.h $(OSINT)/spitblks.h $(OSINT)/globals.h

# C Headers unique to this version of SPITBOL:
UHDRS=	$(OSINT)/systype.h $(OSINT)/extern32.h $(OSINT)/blocks32.h $(OSINT)/system.h

# Headers common to all C files.
HDRS=	$(CHDRS) $(UHDRS)

# Headers for Minimal source translation:
VHDRS=	$(VERS).cnd $(VERS).def $(VERS).hdr hdrdata.inc hdrcode.inc

# OSINT objects:
SYSOBJS=sysax.o sysbs.o sysbx.o syscm.o sysdc.o sysdt.o sysea.o \
	sysef.o sysej.o sysem.o sysen.o sysep.o sysex.o sysfc.o \
	sysgc.o syshs.o sysid.o sysif.o sysil.o sysin.o sysio.o \
	sysld.o sysmm.o sysmx.o sysou.o syspl.o syspp.o sysrw.o \
	sysst.o sysstdio.o systm.o systty.o sysul.o sysxi.o

# Other C objects:
COBJS =	arg2scb.o break.o checkfpu.o compress.o cpys2sc.o doexec.o \
	doset.o dosys.o fakexit.o float.o flush.o gethost.o getshell.o \
	int.o lenfnm.o math.o optfile.o osclose.o \
	osopen.o ospipe.o osread.o oswait.o oswrite.o prompt.o rdenv.o \
	sioarg.o st2d.o stubs.o swcinp.o swcoup.o syslinux.o testty.o\
	trypath.o wrtaout.o

# Assembly langauge objects common to all versions:
CAOBJS = errors.o serial.o inter.o

# Objects for SPITBOL's HOST function:
#HOBJS=	hostrs6.o scops.o kbops.o vmode.o
HOBJS=

# Objects for SPITBOL's LOAD function.  AIX 4 has dlxxx function library.
#LOBJS=  load.o
#LOBJS=  dlfcn.o load.o
LOBJS=

# main objects:
MOBJS=	main.o getargs.o

# All assembly language objects
AOBJS = $(CAOBJS)

# Minimal source object file:
VOBJS =	v37.o

# All objects:
OBJS=	$(AOBJS) $(COBJS) $(HOBJS) $(LOBJS) $(SYSOBJS) $(VOBJS) $(MOBJS)

# main program
spitbol: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) /usr/lib32/libm.a -ospitbol -Wl,-M,-Map,spitbol.map

# Assembly language dependencies:
errors.o: errors.s
v37.o: v37.s

# SPITBOL Minimal source
v37.s:	v37.tok $(VHDRS) $(COD) systype.ah
	  $(SPIT) -u "v37:$(VERS):comments" $(COD)

v37.tok: $(MINPATH)v37.min $(VERS).cnd $(TOK)
	 $(SPIT) -u "$(MINPATH)v37:$(VERS):v37" $(TOK)

v37.err: v37.s

errors.s: $(VERS).cnd $(ERR) v37.s
	   $(SPIT) -1=v37.err -2=errors.s $(ERR)

inter.o: systype.ah osint.inc

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

clean:
	rm -f $(OBJS) spitbol


