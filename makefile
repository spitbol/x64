# SPITBOL makefile using tcc

ws?=64

debug?=0
EXECUTABLE=spitbol

os?=unix

OS=$(os)
WS=$(ws)

TARGET=$(OS)_$(WS)

TOPT=-D m$(WS)

DEBUG=$(debug)

cc?=gcc
CC=$(cc)

ifeq	($(DEBUG),1)
GFLAG=-g
endif


ARCH=-D m$(WS) -m$(WS)


ifeq ($(CC),tcc)
CC=tools/tcc/bin/tcc
#LIBS = -L$(MUSL)/lib  -Ltcc/lib/tcc/libtcc1.a $(MUSL)/lib/libc.a 
CCOPTS= -Dm$(WS) -m$(WS) -I tools/tcc/include $(GFLAG)
LDOPTS = -Ltools/tcc/lib -Ltools/musl/lib $(GFLAG) 
LMOPT=-lm
else
CCOPTS= -Dm$(WS) -m$(WS)  $(GFLAG)
LDOPTS= -lm $(GFLAG) $(ARCH)
LMOPT=-lm
endif

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

ASM	=	tools/nasm/bin/nasm

# Assembler info -- Intel 32-bit syntax
ifeq	($(DEBUG),0)
ASMOPTS = -f $(ELF) -d $(TARGET) -d m$(WS)
else
ASMOPTS = -g -f $(ELF) -d $(TARGET) -d$(WS)
endif

# Tools for processing Minimal source file.
LEX=	lex.spt
COD=    asm.spt
ERR=    err.spt
BASEBOL =   ./bin/spitbol.m$(WS)

# Implicit rule for building objects from C files.
./%.o: %.c
#.c.o:
	$(CC)  $(CCOPTS) -c  -o$@ $(OSINT)/$*.c

# Implicit rule for building objects from assembly language files.
.s.o:
	$(ASM) $(ASMOPTS) -l $*.lst -o$@ $*.s

# C Headers common to all versions and all source files of SPITBOL:
CHDRS =	$(OSINT)/osint.h $(OSINT)/port.h $(OSINT)/sproto.h $(OSINT)/spitio.h $(OSINT)/spitblks.h $(OSINT)/globals.h 

# C Headers unique to this version of SPITBOL:
UHDRS=	$(OSINT)/systype.h $(OSINT)/extern32.h $(OSINT)/blocks32.h $(OSINT)/system.h

# Headers common to all C files.
HDRS=	$(CHDRS) $(UHDRS)

# Headers for Minimal source translation:
VHDRS=	m.hdr 

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
	trypath.o wrtaout.o zz.o

# Assembly langauge objects common to all versions:
# CAOBJS is for gas, NAOBJS for nasm
CAOBJS = 
NAOBJS = m.o err.o

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
# bootbol is for bootstrapping just link with what's at hand
#bootbol: $(OBJS)
bootbol: $(OBJS)
	$(CC) $(LDOPTS)  $(OBJS) $(LMOPT) -obootbol


# link spitbol with static linking
spitbol: $(OBJS)
#	$(CC) $(LDOPTS) -static -lm $(OBJS) -o$(EXECUTABLE) 

#	$(CC) -static  $(LDOPTS)  $(OBJS) $(LMOPT) -o$(EXECUTABLE) 
	$(CC) $(LDOPTS)  $(OBJS) $(LMOPT) -o$(EXECUTABLE) 

# link spitbol with dynamic linking
spitbol-dynamic: $(OBJS)
	$(CC) $(LDOPTS) $(OBJS) $(LMOPT)  -ospitbol 

# Assembly language dependencies:
err.o: err.s
s.o: s.s

err.o: err.s


# SPITBOL Minimal source
s.go:	s.lex go.spt
	$(BASEBOL) -u i32 go.spt

s.s:	s.lex $(VHDRS) $(COD) 
	$(BASEBOL) -u $(TARGET) $(COD)

s.lex: $(MINPATH)$(MIN).min $(MIN).cnd $(LEX)
	 $(BASEBOL) -u $(TARGET) $(LEX)

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

# install binaries from ./bin as the system spitbol compilers
install:
	sudo cp ./bin/spitbol /usr/local/bin
clean:
	rm -f $(OBJS) *.o *.lst *.map *.err s.lex s.tmp s.s err.s s.S s.t ./spitbol

z:
	nm -n s.o >s.nm
	spitbol map-$(WS).spt <s.nm >s.dic
	spitbol z.spt <ad >ae

sclean:
# clean up after sanity-check
	make clean
	rm tbol*
