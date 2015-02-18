# SPITBOL makefile using tcc
HOST=unix_64

EXECUTABLE=spitbol

DEBUG=$(debug)

nasm?=nasm
gas?=as

debug?=0

NASM=$(nasm)
GAS=$(gas)

os?=unix
OS=$(os)

TARGET=$(OS)_$(WS)

ws?=64
WS=$(ws)

it?=0
IT=$(it)
ifneq ($(IT),0)
ITOPT=:it
ITDEF=-Dzz_trace
endif

# basebol determines which spitbol to use to compile
spitbol?=./bin/spitbol.$(HOST)

BASEBOL=$(spitbol)

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

# spitbol source file
MIN=s

OSINT=./osint

vpath %.c $(OSINT)

# Assembler info -- Intel 32-bit syntax
ifeq	($(DEBUG),0)
NASMOPTS = -f $(ELF) -D$(TARGET) $(ITDEF)
else
NASMOPTS = -g -f $(ELF) -D$(TARGET) $(ITDEF)
endif

# tools for processing Minimal source file.
LEX=	lex.spt
COD=    $(A).spt
ERR=    err.spt

# implicit rule for building objects from C files.
./%.o: %.c
#.c.o:
	$(CC)  $(CCOPTS) -c  -o$@ $(OSINT)/$*.c

# implicit rule for building objects from nasm assembly language files.
.nasm.o:
	$(NASM) $(ASMOPTS) -l $*.lst -o$@ $*.nasm

# c headers common to all versions and all source files of SPITBOL:
CHDRS =	$(OSINT)/osint.h $(OSINT)/port.h $(OSINT)/sproto.h $(OSINT)/spitio.h $(OSINT)/spitblks.h $(OSINT)/globals.h 

# c headers unique to this version of SPITBOL:
UHDRS=	$(OSINT)/systype.h $(OSINT)/extern32.h $(OSINT)/blocks32.h $(OSINT)/system.h

# headers common to all C files.
HDRS=	$(CHDRS) $(UHDRS)

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

GOBJS=s-gas.o s-gas-err.o gas-sys.o
NOBJS=s-nasm.o s-nasm-err.o nasm-sys.o


# build nspitbol using nasm, build nspitbol using as.
# link nspitbol with static linking
nspitbol: $(OBJS) $(NOBJS)
	$(CC) $(LDOPTS)  $(OBJS) $(NOBJS) $(LMOPT) -onspitbol

# link nspitbol with dynamic linking
nspitbol-dynamic: $(OBJS) $(NOBJS)
	$(CC) $(LDOPTS) $(OBJS) $(NOBJS) $(LMOPT)  -onspitbol 

# build gspitbol using gas
# link gspitbol with static linking
gspitbol: $(OBJS) $(AOBJS) $(GOBJS)
	$(GAS) $(LDOPTS) $(OBJS) $(GOBJS) $(LMOPT) -o$(EXECUTABLE) 

# link gspitbol with dynamic linking
gspitbol-dynamic: $(OBJS) $(AOBJS) $(GOBJS)
	$(GAS) $(LDOPTS) $(OBJS) $(GOBJS) $(LMOPT)  -ogspitbol 

# bootbol is for bootstrapping just link with what's at hand
#bootbol: $(OBJS)
# no dependencies so can link for osx bootstrap
bootbol: 
	$(CC) $(LDOPTS)  $(OBJS) $(LMOPT) -obootbol

gas.h:	gas.r.h
	$(BASEBOL) -u $(TARGET) r.spt <gas.r.h >gas.h

s.lex: s.min s.cnd $(LEX)
	 $(BASEBOL) -u $(TARGET) $(LEX)

s-gas-err.gas: s.cnd $(ERR) s-gas.gas
	$(BASEBOL) -u $(TARGET) -1=s-gas.err -2=s-gas-err.gas $(ERR)

gas.inc: gas.hdr gas.h
	spitbol -u $(TARGET) r.spt <gas.hdr >gas.inc

s-gas.gas: s.lex $(VHDRS) gas.spt gas.inc
	$(BASEBOL) -r -u $(TARGET):$(ITOPT) -1=s.lex -2=s-gas.tmp -3=s-gas.err -4=gas.inc	gas.spt
	$(BASEBOL) -u $(TARGET) r.spt <s-gas.tmp >s-gas.gas

s-gas.o: s-gas.gas
	$(GAS) $(GASOPTS) -os-gas.o s-gas.gas

gas-sys.o: gas-sys.gas
	$(GAS) $(GASOPTS) -ogas-sys.o gas-sys.gas

s-gas-err.o: s-gas-err.gas
	$(GAS) $(GASOPTS) -os-gas-err.o s-gas-err.gas

s-nasm.nasm: s.lex $(VHDRS) nasm.spt
	$(BASEBOL) -r -u $(TARGET):$(ITOPT) -1=s.lex -2=s-nasm.nasm -3=s-nasm.err	nasm.spt

s-nasm.o: s-nasm.nasm
	$(NASM) $(NASMOPTS) -os-nasm.o s-nasm.nasm

nasm-sys.o: nasm-sys.nasm
	$(NASM) $(NASMOPTS) -onasm-sys.o nasm-sys.nasm

s-nasm-err.nasm: s.cnd $(ERR) s-nasm.nasm
	   $(BASEBOL) -u $(TARGET) -1=s-nasm.err -2=s-nasm-err.nasm $(ERR)

s-nasm-err.o: s-nasm-err.nasm
	$(NASM) $(NASMOPTS) -os-nasm-err.o s-nasm-err.nasm

# c language header dependencies:
main.o: $(OSINT)/save.h
sysgc.o: $(OSINT)/save.h
sysxi.o: $(OSINT)/save.h
dlfcn.o: dlfcn.h

# install binaries from ./bin as the system spitbol compilers
install:
	sudo cp ./bin/spitbol /usr/local/bin
clean:
	rm -f $(OBJS) *.o s.lex s.tmp [rs]-* ./spitbol gas.inc gas.h

z:
	nm -n s.o >s.nm
	spitbol map-$(WS).spt <s.nm >s.dic
	spitbol z.spt <ad >ae

sclean:
# clean up after sanity-check
	make clean
	rm tbol*
