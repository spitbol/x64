ws?=64
WS:=$(ws)

# base compiler used for building

base?= bin/spitbol_unix_$(WS)
BASEBOL:=$(base)

os?=unix
OS:=$(os)

asm?=gas
ASM:=$(asm)

TARGET=$(OS)_$(WS)

debug?=0
DEBUG:=$(debug)

# options to pick alternate executables for assemblers

gas?=as
GAS:=$(gas)

nasm?=nasm
NASM:=$(nasm)

trc?=0
TRC:=$(trc)
ifneq ($(TRC),0)
TRCOPT:=:trc
TRCDEF:=-Dtrc_trace
endif

NMFLAGS:=-p

# basebol determines which spitbol to use to compile

cc?=gcc
CC:=$(cc)

ifeq	($(DEBUG),1)
GFLAG=-g
endif

ARCH=-D$(OS)_$(WS)  -m$(WS)

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
NASMOPTS = -f $(ELF) -D$(OS)_$(WS) $(ITDEF)
ASMOPTS  = -f $(ELF) -D$(OS)_$(WS) $(ITDEF)
else
NASMOPTS = -g -f $(ELF) -D$(TARGET) $(ITDEF)
ASMOPTS = -g -f $(ELF) -D$(TARGET) $(ITDEF)
endif

# tools for processing Minimal source file.

DEF=def.sbl
ERR=err.sbl
MIN=asm.sbl
PRE=pre.sbl

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
	trypath.o wrtaout.o zz.o getargs.o trc.o main.o 

gas:

# run preprocessor to process multi-line comments in lex

	$(BASEBOL) -u $(TARGET)_gas pre.sbl <lex.sbl >lex.spt

# run lex to get sbl.lex

	$(BASEBOL) -u $(TARGET)_gas lex.spt

# run preprocessor to get translator to gas

	$(BASEBOL) -u $(TARGET)_gas pre.sbl <asm.sbl >gas.spt 

# run gas to get .s and .err files from .lex

	$(BASEBOL) -u $(TARGET)_gas:$(TRCOPT) gas.spt

# run preprocessor to process multi-line comments in err

	$(BASEBOL) pre.sbl <err.sbl >err.spt

# run err 

	$(BASEBOL) -u $(TARGET)_gas err.spt

# use preprocessor to make version of rewriter for gas

	$(BASEBOL) -u $(TARGET)_gas pre.sbl <def.sbl >def.spt

# run preprocessor to get sys for gas

	$(BASEBOL) -u $(TARGET)_gas pre.sbl <sys.asm >sys.pre

# run gas definer to resolve system dependencies in sys

	$(BASEBOL) -u $(TARGET)_gas  def.spt <sys.pre >sys.s

# run gas definer to resolve system dependencies in sbl.s

	mv	sbl.s	sbl.tmp
	$(BASEBOL) -u $(TARGET)_gas  def.spt <sbl.tmp >sbl.s

# combine sys.s,min.s, and err.s to get sincle assembler source file

	cat <sys.s >spitbol.s
	cat <sbl.s >>spitbol.s
	cat <err.s >>spitbol.s
# assemble the translated file

	$(GAS) $(GASOPTS) -ospitbol.o spitbol.s

# compile osint

	$(CC)  $(CCOPTS) -c  osint/*.c

# load objects

	$(CC) $(LDOPTS)  $(COBJS) spitbol.o $(LMOPT) -static -ospitbol

# build spitbol using nasm, build spitbol using as.
# link asm spitbol with static linking
# use fake target asmobj which appears only when all .s files built

asm: 

# run preprocessor to process multi-line comments in lex

	$(BASEBOL) -u $(TARGET)_asm pre.sbl <lex.sbl >lex.spt

# run lex to get sbl.lex for asm

	$(BASEBOL) -u $(TARGET)_asm lex.spt

# run preprocessor to get asm for nasm as target

	$(BASEBOL) -u $(TARGET)_asm $(PRE) <asm.sbl >asm.spt 

# run asm to get .s and .err files

	$(BASEBOL) -u $(TARGET)_asm$(TRCOPT) asm.spt

# run preprocessor to process multi-line comments in err

	$(BASEBOL) pre.sbl <err.sbl >err.spt

# run err 

	$(BASEBOL) -u $(TARGET)_asm err.spt


# use preprocessor to make version of rewriter for asm

	$(BASEBOL) -u $(TARGET)_asm $(PRE) <$(DEF) >def.spt

# run preprocessor to get sys for nasm as target

	$(BASEBOL) -u $(TARGET)_asm $(PRE)  <sys.asm >sys.pre

# run asm definer to resolve system dependencies in sys

	$(BASEBOL) -u $(TARGET)_asm  def.spt <sys.pre >sys.s

# combine sys.s,min.s, and err.s to get sincle assembler source file

	cat <sys.s >spitbol.s
	cat <sbl.s >>spitbol.s
	cat <err.s >>spitbol.s
# -- works

# assemble the translated file

	$(NASM) $(ASMOPTS) -ospitbol.o spitbol.s

# compile osint

	$(CC)  $(CCOPTS) -c  osint/*.c

# load objects

	$(CC) $(LDOPTS)  $(COBJS) spitbol.o $(LMOPT) -static -ospitbol
osx-export:

	rm	osx/*

# run lex to get min.lex

	$(BASEBOL) -u osx_32_gas $(LEX)

# run preprocessor to get gas for ngas as target

	$(BASEBOL) -u osx_32_gas $(PRE) <asm.sbl >gas.spt 

# run gas to get .s and .err files

	$(BASEBOL) -u osx_32_gas:$(TRCOPT) gas.spt

# run err 

	$(BASEBOL) -u osx_32_gas $(ERR)

# use preprocessor to make version of rewriter for gas

	$(BASEBOL) -u osx_32_gas $(PRE) <$(DEF) >def.spt

# run preprocessor to get sys for ngas as target

	$(BASEBOL) -u osx_32_gas $(PRE) <sys.asm >sys.pre

# run gas definer to resolve system dependencies in sys

	$(BASEBOL) -u osx_32_gas  def.spt <sys.pre >sys.s

# run gas definer to resolve system dependencies in sbl.s

	mv	sbl.s	sbl.tmp
	$(BASEBOL) -u osx_32_gas  def.spt <sbl.tmp >sbl.s

# run fixer to prefix certain names with underscore

	$(BASEBOL) fix.sbl <err.s >err.tmp
	mv	err.tmp	err.s
	$(BASEBOL) fix.sbl <sbl.s >sbl.tmp
	mv	sbl.tmp	sbl.s
	$(BASEBOL) fix.sbl <sys.s >sys.tmp
	mv	sys.tmp	sys.s

	cp sys.s sbl.s err.s osx

osx-import:

	cat <osx/sys.s >spitbol.s
	cat <osx/sbl.s >>spitbol.s
	cat <osx/err.s >>spitbol.s

# assemble the translated file

	$(GAS) $(GASOPTS) -ospitbol.o spitbol.s

# compile osint

	$(CC)  $(CCOPTS) -c  osint/*.c

# load objects

	$(CC) $(LDOPTS)  $(COBJS) spitbol.o $(LMOPT) -static -ospitbol

sys-asm:

# run preprocessor to get sys for nasm as target

	$(BASEBOL) -u $(TARGET)_asm $(PRE)  <sys.asm >sys.pre

# use preprocessor to make version of rewriter for asm

	$(BASEBOL) -u $(TARGET)_asm $(PRE) <$(DEF) >def.spt

# run asm definer to resolve system dependencies in sys

	$(BASEBOL) -u $(TARGET)_asm  def.spt <sys.pre >sys.s

# assemble the sys file

	$(NASM) $(ASMOPTS) -osys.o sys.s

sys-gas:

# run preprocessor to get sys for gas as target

	$(BASEBOL) -u $(TARGET)_gas $(PRE)  <sys.asm >sys.pre

# use preprocessor to make version of rewriter for gas

	$(BASEBOL) -u $(TARGET)_gas $(PRE) <$(DEF) >def.spt

# run gas definer to resolve system dependencies in sys

	$(BASEBOL) -u $(TARGET)_gas  def.spt <sys.pre >sys.s

# assemble the sys file

	$(GAS) $(GASOPTS) -osys.o sys.s

bug:

# combine sys.s,min.s, and err.s to get sincle assembler source file

	cat <sys.s >spitbol.s
	cat <sbl.s >>spitbol.s
	cat <err.s >>spitbol.s

# assemble the translated file

	$(NASM) $(ASMOPTS) -ospitbol.o spitbol.s

# compile osint
#	$(CC)  $(CCOPTS) -c  osint/*.c
# load objects

	$(CC) $(LDOPTS)  $(COBJS) spitbol.o $(LMOPT) -static -ospitbol

lbug:

# load objects

	$(CC) $(LDOPTS)  $(COBJS) spitbol.o $(LMOPT) -static -ospitbol

spitbol-dynamic: $(OBJS) $(AOBJS)

# link spitbol with dynamic linking
	$(CC) $(LDOPTS) $(OBJS) $(AOBJS) $(LMOPT)  -ospitbol 


asm.spt:	asm
	$(BASEBOL) -u A -1=asm -2=asm.spt pre.sbl

gas.spt:	asm
	$(BASEBOL) -u G -1=asm -2=gas.spt pre.sbl

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

trc-gas:	s-gas.dic trc.sbl
	$(BASEBOL) -u s-gas.dic trc.sbl <ad >ae

s-nasm.dic: s-nasm.nm
	$(BASEBOL) test/map-$(WS).sbl <s-nasm.nm >s-nasm.dic

s-nasm.nm: s-nasm.o
	nm $(NMFLAGS) s-nasm.o >s-nasm.nm

trc-nasm: s-nasm.dic it.sbl
	$(BASEBOL) -u s-nasm.dic trc.sbl <ad >ae

sanity:

# This program does a sanity test to  verify that spitbol is able to compile itself.

# This is done by building the system three times, and comparing the generated assembly (.s) files. 

# Normally, all three assembly files wil be equal. However, if a new optimization is
# being introduced, the first two may differ, but the second and third should always agree.

	rm -f tbol.*
	cp	./bin/spitbol_$(OS)_$(WS) testbol
	make	clean>/dev/null
	make	base=./testbol ws=$(WS) $(ASM)
	mv	sbl.lex tbol.lex.0
	mv	sbl.s tbol.s.0
	mv	spitbol tbol
	make 	base=./testbol ws=$(WS) $(ASM)
	mv	sbl.lex tbol.lex.1
	mv	sbl.s tbol.s.1
	mv	spitbol tbol
	make	base=./testbol ws=$(WS) $(ASM)
	mv	sbl.lex tbol.lex.2
	mv	sbl.s tbol.s.2
	rm -f	./testbol
	echo	"comparing generated .s files"
	diff	tbol.s.1 tbol.s.2
	echo "end sanity test"

clean:
	rm -f  *.def *.pre *.[ors] *.def tbol* sbl.err sbl.lex sbl.equ ./asmbol ./gasbol ./spitbol def.spt err.s r-asm.sbl sbl.equ sbl.err s.equ s.err s.lex sys.pre sys.s asm.spt sbl.tmp gas.spt
