# SPITBOL makefile using tcc
HOST=unix_64
nasm?=nasm
as?=as
NASM=$(nasm)
GAS=$(as)

ws?=64

debug?=0
EXECUTABLE=spitbol
# P is prefix chosen according to assembler, used to identify machine-dependent assembler files
#ifeq($(A),nasm)
P=p
#else
P=a
os?=unix

it?=0
IT=$(it)
ifneq ($(IT),0)
ITOPT=:it
ITDEF=-Dzz_trace
endif


OS=$(os)
WS=$(ws)

TARGET=$(OS)_$(WS)

# basebol determines which spitbol to use to compile
spitbol?=./bin/spitbol.$(HOST)
BASEBOL=$(spitbol)

DEBUG=$(debug)

cc?=gcc
CC=$(cc)

ifeq	($(DEBUG),1)
GFLAG=-g
endif


ARCH=-D$(TARGET)  -m$(WS)


CCOPTS= $(ARCH) $(ITDEF) $(GFLAG) 
LDOPTS= -lm $(GFLAG) $(ARCH)
LMOPT=-lm

ifeq ($(OS),unix)
ELF=elf$(WS)
else
ELF=macho$(WS)
endif


# SPITBOL Version:
MIN=   s

# Minimal source directory.
MINPATH=./

OSINT=./osint

vpath %.c $(OSINT)

# Assembler info -- Intel 32-bit syntax
ifeq	($(DEBUG),0)
NASMOPTS = -f $(ELF) -D$(TARGET) $(ITDEF)
else
NASMOPTS = -g -f $(ELF) -D$(TARGET) $(ITDEF)
endif

# Tools for processing Minimal source file.
LEX=	lex.spt
COD=    $(A).spt
ERR=    err.spt

# Implicit rule for building objects from C files.
./%.o: %.c
#.c.o:
	$(CC)  $(CCOPTS) -c  -o$@ $(OSINT)/$*.c

# Implicit rule for building objects from assembly language files.
ns.o:
	$(NASM) $(ASMOPTS) -l $*.lst -o$@ $*.ns

# C Headers common to all versions and all source files of SPITBOL:
CHDRS =	$(OSINT)/osint.h $(OSINT)/port.h $(OSINT)/sproto.h $(OSINT)/spitio.h $(OSINT)/spitblks.h $(OSINT)/globals.h 

# C Headers unique to this version of SPITBOL:
UHDRS=	$(OSINT)/systype.h $(OSINT)/extern32.h $(OSINT)/blocks32.h $(OSINT)/system.h

# Headers common to all C files.
HDRS=	$(CHDRS) $(UHDRS)

# Headers for Minimal source translation:
AVHDRS=	m.hdr 
NVHDRS=	n.hdr 

OBJS=sysax.o sysbs.o sysbx.o syscm.o sysdc.o sysdt.o sysea.o \
	sysef.o sysej.o sysem.o sysen.o sysep.o sysex.o sysfc.o \
	sysgc.o syshs.o sysid.o sysif.o sysil.o sysin.o sysio.o \
	sysld.o sysmm.o sysmx.o sysou.o syspl.o syspp.o sysrw.o \
	sysst.o sysstdio.o systm.o systty.o sysul.o sysxi.o  \
	break.o checkfpu.o compress.o cpys2sc.o \
	doset.o dosys.o fakexit.o float.o flush.o gethost.o getshell.o \
	int.o lenfnm.o math.o optfile.o osclose.o \
	osopen.o ospipe.o osread.o oswait.o oswrite.o prompt.o rdenv.o \
	st2d.o stubs.o swcinp.o swcoup.o syslinux.o testty.o\
	trypath.o wrtaout.o zz.o getargs.o main.o 

AOBJS=as.o aerr.o
NOBJS=ns.o nerr.o n.o


# Build nspitbol using nasm, build aspitbol using as.
# link nspitbol with static linking
nspitbol: $(OBJS) $(NOBJS)
	$(CC) $(LDOPTS)  $(OBJS) $(NOBJS) $(LMOPT) -o$(EXECUTABLE) 

# link nspitbol with dynamic linking
nspitbol-dynamic: $(OBJS) $(NOBJS)
	$(CC) $(LDOPTS) $(OBJS) $(NOBJS) $(LMOPT)  -ospitbol 

# link aspitbol with static linking
aspitbol: $(OBJS) $(AOBJS)
	$(CC) $(LDOPTS)  $(OBJS) $(LMOPT) -o$(EXECUTABLE) 

# link aspitbol with dynamic linking
aspitbol-dynamic: $(OBJS) $(AOBJS)
	$(CC) $(LDOPTS) $(OBJS) $(AOBJS) $(LMOPT)  -ospitbol 

# bootbol is for bootstrapping just link with what's at hand
#bootbol: $(OBJS)
# no dependencies so can link for osx bootstrap
bootbol: 
	$(CC) $(LDOPTS)  $(OBJS) $(LMOPT) -obootbol

# Assembly language dependencies:
err.o: err.ns
nerr.o: ns.ne

# SPITBOL Minimal source
s.go:	s.lex go.spt
	$(BASEBOL) -u i32 go.spt

#s.s:	s.lex $(VHDRS) $(COD) 
#	$(BASEBOL) -u $(TARGET):$(ITOPT) $(COD)

ns.ns: s.lex $(VHDRS) nasm.spt
	$(BASEBOL) -u $(TARGET):$(ITOPT) nasm.spt
.ns.o: s.ns
	$(NASM) $(NASMOPTS) -ons.o ns.ns

s.lex: $(MINPATH)s.min s.cnd $(LEX)
	 $(BASEBOL) -u $(TARGET) $(LEX)

s.nerr: s.ns

err.ns: s.cnd $(ERR) s.ns
	   $(BASEBOL) -u $(TARGET) -1=s.ne -2=err.ns $(ERR)

# C language header dependencies:
main.o: $(OSINT)/save.h
sysgc.o: $(OSINT)/save.h
sysxi.o: $(OSINT)/save.h
dlfcn.o: dlfcn.h

# install binaries from ./bin as the system spitbol compilers
install:
	sudo cp ./bin/spitbol /usr/local/bin
clean:
	rm -f $(OBJS) *.o *.lst *.map *.ne s.lex s.tmp ns.ns ./spitbol

z:
	nm -n s.o >s.nm
	spitbol map-$(WS).spt <s.nm >s.dic
	spitbol z.spt <ad >ae

sclean:
# clean up after sanity-check
	make clean
	rm tbol*
