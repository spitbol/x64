# SPITBOL makefile using tcc

ws?=64

debug?=0
EXECUTABLE=spitbol

os?=unix

OS=$(os)
WS=$(ws)
DEBUG=$(debug)

ARCH=m$(WS)
ARCHDEF=-D m$(WS)

ifeq ($(OS),unix)
#CC=tools/tcc/bin/tcc
CC=tcc
ELF=elf$(WS)
else
CC=llvm
ELF=macho$(WS)
endif


# SPITBOL Version:
MIN=   s

# Minimal source directory.
MINPATH=./

OSINT=./osint

vpath %.c $(OSINT)

ASM	=	nasm
ASM	=	./tools/nasm/bin/nasm

ifeq	($(DEBUG),0)
CFLAGS= -D m$(WS) -m$(WS) -Itools/tcc/include
else
CFLAGS= -D m$(WS) -g -m$(WS)-Itools/tcc/include
endif

# Assembler info -- Intel 32-bit syntax
ifeq	($(DEBUG),0)
ASMFLAGS = -f $(ELF) -d m$(WS)
else
ASMFLAGS = -g -f $(ELF) -d m$(WS)
endif

# Tools for processing Minimal source file.
LEX=	lex.spt
COD=    asm.spt
ERR=    err.spt
BASEBOL =   ./bin/spitbol.$(ARCH)

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

# link spitbol with static linking
#LIBS = -L$(MUSL)/lib  -Ltcc/lib/tcc/libtcc1.a $(MUSL)/lib/libc.a 
LIBS = -Ltools/tcc/lib -Ltools/musl/lib
spitbol: $(OBJS)
#	$(CC) $(CFLAGS) $(LIBS) -static -lm $(OBJS) -o$(EXECUTABLE) 
	$(CC) $(CFLAGS) $(LIBS) -lm $(OBJS) -o$(EXECUTABLE) 

# link spitbol with dynamic linking
spitbol-dynamic: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) $(LIBS) lm -ospitbol 

# Assembly language dependencies:
err.o: err.s
s.o: s.s

err.o: err.s


# SPITBOL Minimal source
s.go:	s.lex go.spt
	$(BASEBOL) -u i32 go.spt

s.s:	s.lex $(VHDRS) $(COD) 
	$(BASEBOL) -u $(WS) $(COD)

s.lex: $(MINPATH)$(MIN).min $(MIN).cnd $(LEX)
#	 $(BASEBOL) -u $(WS) $(LEX)
	 $(BASEBOL) -u $(WS) $(LEX)

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
