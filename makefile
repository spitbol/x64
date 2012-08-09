# Linux/386 SPITBOL
#


# SPITBOL Version:
VERS=   x86
DEBUG=	0

# Minimal source directory.
MINPATH=./

OSINT=./osint

vpath %.c $(OSINT)


AS=nasm
CC=     gcc
ifeq	($(DEBUG),0)
CFLAGS= 
else
CFLAGS= -g -
endif

# Assembler info -- Intel 32-bit syntax
ifeq	($(DEBUG),0)
ASFLAGS = -f elf
else
ASFLAGS = -f elf -g
endif

# Tools for processing Minimal source file.
TOK=	minimal-lexer.spt
COD=    minimal-x86.spt
ERR=    err386.spt
SPIT=   ./bootstrap/spitbol

# Implicit rule for building objects from C files.
./%.o: %.c
#.c.o:
	$(CC) -c $(CFLAGS) -o$@ $(OSINT)/$*.c

# Implicit rule for building objects from assembly language files.
.s.o:
	$(AS) -o $@ $(ASFLAGS) $*.s

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
VOBJS =	v40.o

# All objects:
OBJS=	 $(COBJS) $(HOBJS) $(LOBJS) $(SYSOBJS) $(VOBJS) $(MOBJS) $(AOBJS)

# main program
spitbol: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -lm  -ospitbol -Wl,-M,-Map,spitbol.map

# Assembly language dependencies:
errors.o: errors.s
v40.o: v40.s

# SPITBOL Minimal source
v40.s:	v40.lex $(VHDRS) $(COD) mintype.h
	  $(SPIT) -u "v40:$(VERS):comments" $(COD)

v40.lex: $(MINPATH)v40.min $(VERS).cnd $(TOK)
	 $(SPIT) -u "$(MINPATH)v40:$(VERS):v40" $(TOK)

v40.err: v40.s

errors.s: $(VERS).cnd $(ERR) v40.s
	   $(SPIT) -1=v40.err -2=errors.s $(ERR)

inter.o: mintype.h osint.inc

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
	cp -p bootstrap/v40.s bootstrap/v40.lex bootstrap/errors.s .

install:
	sudo cp spitbol /usr/local/bin
clean:
	rm -f $(OBJS) *.lst *.map *.err v40.lex v40.tmp v40.s errors.s
