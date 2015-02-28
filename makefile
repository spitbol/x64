# SPITBOL makefile using tcc
host?=unix_64
HOST=$(host)

DEBUG:=$(debug)

debug?=0

gas?=as
GAS:=$(gas)

nasm?=nasm
NASM:=$(nasm)

os?=unix
OS:=$(os)

ws?=64
WS=$(ws)

TARGET=$(OS)_$(WS)

it?=0
IT:=$(it)
ifneq ($(IT),0)
ITOPT:=:it
ITDEF:=-Dit_trace
endif

NMFLAGS:=-p
# basebol determines which spitbol to use to compile
spitbol?=./bin/spitbol.$(HOST)

BASEBOL:=$(spitbol)

cc?=gcc
CC:=$(cc)

ifeq	($(DEBUG),1)
GFLAG=-g
endif

ARCH=-D$(TARGET)  -m$(WS)

CCOPTS:= $(ARCH) $(ITDEF) $(GFLAG) 
LDOPTS:= -lm $(GFLAG) $(ARCH)
LMOPT:=-lm

GASOPTS= --$(WS)

ifeq ($(OS),unix)
ELF:=elf$(WS)
else
EL:F=macho$(WS)
endif

# spitbol source file
MIN=s

OSINT=./osint



# Assembler info -- Intel 32-bit syntax
ifeq	($(DEBUG),0)
NASMOPTS = -f $(ELF) -D$(TARGET) $(ITDEF)
ASMOPTS = -f $(ELF) -D$(TARGET) $(ITDEF)
else
NASMOPTS = -g -f $(ELF) -D$(TARGET) $(ITDEF)
ASMOPTS = -g -f $(ELF) -D$(TARGET) $(ITDEF)
endif

# tools for processing Minimal source file.
LEX=	lex.sbl
ERR=    err.sbl

# implicit rule for building objects from C files.
./%.o: %.c
#.c.o:
	$(CC)  $(CCOPTS) -c  -o$@ $(OSINT)/$*.c

# implicit rule for building objects from nasm assembly language files.
.asm.o:
	$(NASM) $(ASMOPTS) -l $*.lst -o$@ $*.asm

# c headers common to all versions and all source files of SPITBOL:
CHDRS =	$(OSINT)/osint.h $(OSINT)/port.h $(OSINT)/sproto.h $(OSINT)/spitio.h $(OSINT)/spitblks.h $(OSINT)/globals.h 

# c headers unique to this version of SPITBOL:
UHDRS=	$(OSINT)/systype.h $(OSINT)/extern32.h $(OSINT)/blocks32.h $(OSINT)/system.h

# headers common to all C files.
HDRS=	$(CHDRS) $(UHDRS)

COBJS=sysax.o sysbs.o sysbx.o syscm.o sysdc.o sysdt.o sysea.o \
	sysef.o sysej.o sysem.o sysen.o sysep.o sysex.o sysfc.o \
	sysgc.o syshs.o sysid.o sysif.o sysil.o sysin.o sysio.o \
	sysld.o sysmm.o sysmx.o sysou.o syspl.o syspp.o sysrw.o \
	sysst.o sysstdio.o systm.o systty.o sysul.o sysxi.o  \
	break.o checkfpu.o compress.o cpys2sc.o \
	doset.o dosys.o fakexit.o float.o flush.o gethost.o getshell.o \
	int.o lenfnm.o math.o optfile.o osclose.o \
	osopen.o ospipe.o osread.o oswait.o oswrite.o prompt.o rdenv.o \
	st2d.o stubs.o swcinp.o swcoup.o syslinux.o testty.o\
	trypath.o wrtaout.o zz.o getargs.o it.o main.o 

AOBJS=s.o err.o sys.o

# build spitbol using nasm, build spitbol using as.
# link asm spitbol with static linking
# use fake target asmobj which appears only when all .s files built
asm: 

# run preprocessor to get asm for nasm as target
	$(BASEBOL) -u A pp.sbl <asm.sbl >asm.spt
# run lex to get s.lex
	$(BASEBOL) -u $(TARGET)_$(ASM) $(LEX)
# run asm to get .s and .err files
	$(BASEBOL) -r -u $(TARGET):$(ITOPT) -1=s.lex -2=s.s -3=s.err -4=asm.hdr -6=s.equ	asm.spt
# run err to s-asm-err.s
	$(BASEBOL) -u $(TARGET)_asm -1=s.err -2=err.s $(ERR)
# compile the .s files 
	$(NASM) $(ASMOPTS) -os.o s.s
	$(NASM) $(ASMOPTS) -oerr.o err.s
	$(NASM) $(ASMOPTS) -osys.o asm.sys
# compile osint
	$(CC)  $(CCOPTS) -c  osint/*.c
# load objects
	$(CC) $(LDOPTS)  $(COBJS) $(AOBJS) $(LMOPT) -static -ospitbol

# link spitbol with dynamic linking
spitbol-dynamic: $(OBJS) $(AOBJS)
	$(CC) $(LDOPTS) $(OBJS) $(AOBJS) $(LMOPT)  -ospitbol 

# build gasbol, the asm variant  targeting gas format assembler
# link gasbol with static linking
gas: 
# run preprocessor to get h file
	$(BASEBOL) -u $(TARGET) r.sbl <gas.h >gas.r
# run preprocessor to get asm for nasm as target
	$(BASEBOL) -u G pp.sbl <asm.sbl >asm.spt
# run lex to get s.lex
	$(BASEBOL) -u $(TARGET)_$(ASM) $(LEX)
# run asm to get .s and .err files
	$(BASEBOL) -r -u $(TARGET):$(ITOPT) -1=s.lex -2=s-gas.s -3=s-gas-err.err -4=asm.hdr -6=s.equ	asm.spt
# run err to s-asm-err.s
	$(BASEBOL) -u $(TARGET)_gas -1=s-gas-err.err -2=s-gas-err.s $(ERR)
# compile the .s files 
	$(NASM) $(ASMOPTS) -os-gas.o s-gas.s
	$(NASM) $(ASMOPTS) -os-gas-err.o s-gas-err.s
	$(NASM) $(ASMOPTS) -ogas-sys.o gas.sys
# compile osint
	$(CC)  $(CCOPTS) -c  osint/*.c
# load objects
	$(CC) $(LDOPTS)  $(OBJS) $(GOBJS) $(LMOPT) -static -ogasbol


# link gasbol with dynamic linking
gasbol-dynamic: $(OBJS) $(GOBJS) $(GOBJS)
	$(CC) $(LDOPTS) $(OBJS) $(GOBJS) $(LMOPT)  -ogasbol 

# bootbol is for bootstrapping just link with what's at hand
#bootbol: $(OBJS)
# no dependencies so can link for osx bootstrap
bootbol: 
	$(CC) $(LDOPTS)  $(OBJS) $(LMOPT) -obootbol

cobjs:
	cd bld
	$(CC) $(CCOPTS) -c ../osint/*.c
	touch cobjs
	cd ..

dic:
	nm -n s-nasm.o >s-nasm.nm
	spitbol test/map-$(WS).sbl <s-nasm.nm >s-nasm.dic
	spitbol it.sbl <ad >ae

# install binaries from ./bin as the system spitbol compilers
install:
	sudo cp ./bin/spitbol /usr/local/bin

s-gas.dic: s-gas.nm
	$(BASEBOL) test/map-$(WS).sbl <s-gas.nm >s-gas.dic

s-gas.nm: s-gas.o
	nm -n s-gas.o >s-gas.nm

it-gas:	s-gas.dic it.sbl
	$(BASEBOL) -u s-gas.dic it.sbl <ad >ae

s-nasm.dic: s-nasm.nm
	$(BASEBOL) test/map-$(WS).sbl <s-nasm.nm >s-nasm.dic

s-nasm.nm: s-nasm.o
	nm $(NMFLAGS) s-nasm.o >s-nasm.nm

it-nasm: s-nasm.dic it.sbl
	$(BASEBOL) -u s-nasm.dic it.sbl <ad >ae

clean:
	rm -f *.o s.err err.s s.lex s.equ ./asmbol ./gasbol ./spitbol 
	rm asm.hdr asm.spt gas.spt asm.hdr gas.hdr 

sclean:
# clean up after sanity-check
	make clean
	rm tbol*
