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
LEX=lex.sbl
ERR=err.sbl
MIN=min.sbl

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
	doset.o dosys.o fakexit.o flush.o gethost.o getshell.o \
	arith.o lenfnm.o math.o optfile.o osclose.o \
	osopen.o ospipe.o osread.o oswait.o oswrite.o prompt.o rdenv.o \
	st2d.o stubs.o swcinp.o swcoup.o syslinux.o testty.o\
	trypath.o wrtaout.o zz.o getargs.o it.o main.o 


# build spitbol using nasm, build spitbol using as.
# link asm spitbol with static linking
# use fake target asmobj which appears only when all .s files built
asm: 

# run lex to get min.lex
	$(BASEBOL) -u $(TARGET)_$(ASM) $(LEX)
# run preprocessor to get asm for nasm as target
	$(BASEBOL) -u A pp.sbl <min.sbl >min-asm.spt 
# run asm to get .s and .err files
	$(BASEBOL) -u $(TARGET):$(ITOPT) min-asm.spt
# run err 
	$(BASEBOL) -u $(TARGET)_asm $(ERR)
# use preprocessor to make version of rewriter for asm
	$(BASEBOL) -u A pp.sbl <r.sbl >r-asm.spt
# run preprocessor to get sys for nasm as target
	$(BASEBOL) -u A pp.sbl <sys >sys.asm.r
# run asm rewriter r to resolve system dependencies in sys
	$(BASEBOL) -u $(TARGET) r-asm.spt <sys.asm.r >sys.s
# combine sys.s,min.s, and err.s to get sincle assembler source file
	cat <sys.s >spitbol.s
	cat <sbl.s >>spitbol.s
	cat <err.s >>spitbol.s
# assemble the translated file
	$(NASM) $(ASMOPTS) -ospitbol.o spitbol.s
# compile osint
	$(CC)  $(CCOPTS) -c  osint/*.c
# load objects
	$(CC) $(LDOPTS)  $(COBJS) spitbol.o $(LMOPT) -static -ospitbol

spitbol-dynamic: $(OBJS) $(AOBJS)
# link spitbol with dynamic linking
	$(CC) $(LDOPTS) $(OBJS) $(AOBJS) $(LMOPT)  -ospitbol 

gas: 
# build gasbol, the asm variant  targeting gas format assembler
# link gasbol with static linking

# run preprocessor to get asm for nasm as target
	$(BASEBOL) -u G pp.sbl <asm.r >gas.spt 
# run lex to get s.lex
	$(BASEBOL) -u $(TARGET)_$(GAS) $(LEX)
# run gas to get .s and .err files
	$(BASEBOL) -u $(TARGET):$(ITOPT) gas.spt
# revise source .s 
	$(BASEBOL) -u $(TARGET) r.sbl <s.s >s.r
# run err 
	$(BASEBOL) -u $(TARGET)_gas $(ERR)
# revise gas file
	$(BASEBOL) -u $(TARGET) r.sbl <gas.gas >gas.r
# assemble the .gas file
	$(GAS) $(GASOPTS) -ogas.o gas.r
# compile osint
	$(CC)  $(CCOPTS) -c  osint/*.c
# load objects
	$(CC) $(LDOPTS)  $(COBJS) gas.o $(LMOPT) -static -ospitbol

gasbol-dynamic: $(OBJS) $(GOBJS) $(GOBJS)
# link gasbol with dynamic linking
	$(CC) $(LDOPTS) $(OBJS) $(GOBJS) $(LMOPT)  -ogasbol 

asm.spt:	asm
	$(BASEBOL) -u A -1=asm -2=asm.spt pp.sbl

gas.spt:	asm
	$(BASEBOL) -u G -1=asm -2=gas.spt pp.sbl

bootbol: 
# bootbol is for bootstrapping just link with what's at hand
#bootbol: $(OBJS)
# no dependencies so can link for osx bootstrap
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
	rm -f *.spt *.[ors] tbol* sbl.err sbl.lex sbl.equ ./asmbol ./gasbol ./spitbol 
