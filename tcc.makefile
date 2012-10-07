# Unix/x32 SPITBOL

# SPITBOL Version:
TARGET=   x32
DEBUG=	1

# Minimal source directory.
MINPATH=./

OS=./os

vpath %.c $(OS)

MUSL=musl
#CC=     tcc/bin/tcc
CC=     tcc
AS=nasm
INCDIRS = -Itcc/include -I$(MUSL)/include
ifeq	($(DEBUG),1)
CFLAGS =  -g  $(INCDIRS)
else
CFLAGS =  $(INCDIRS)
endif

# Assembler info -- Intel 32-bit syntax
ifeq	($(DEBUG),0)
ASFLAGS = -f elf 
else
ASFLAGS = -f elf -g
endif

# Tools for processing Minimal source file.
LEX=	lex.spt
TRANS=    $(TARGET)/min2asm.spt
ERR=    $(TARGET)/err.spt
SPIT=   ./bin/spitbol

# Implicit rule for building objects from C files.
./%.o: %.c
#.c.o:
	$(CC) -c $(CFLAGS) -o$@ $(OS)/$*.c

# Implicit rule for building objects from assembly language files.
.s.o:
	$(AS) -l $*.lst -o $@ $(ASFLAGS) $*.s
#	$(AS) -o $@ $(ASFLAGS) $*.s
#	$(AS) -a=$*.lst -o $@ $(ASFLAGS) $*.s

# C Headers common to all versions and all source files of SPITBOL:
CHDRS =	$(OS)/os.h $(OS)/port.h $(OS)/sproto.h $(OS)/spitio.h $(OS)/spitblks.h $(OS)/globals.init

# C Headers unique to this version of SPITBOL:
UHDRS=	$(OS)/systype.h $(OS)/extern32.h $(OS)/blocks32.h $(OS)/system.h

# Headers common to all C files.
HDRS=	$(CHDRS) $(UHDRS)

# Headers for Minimal source translation:
VHDRS=	$(TARGET)/$(TARGET).hdr 

# OS objects:
SYSOBJS=trace.o sysax.o sysbp.o sysbs.o sysbx.o syscm.o sysdc.o sysdt.o sysea.o \
	sysef.o sysej.o sysem.o sysen.o sysep.o sysex.o sysfc.o \
	sysgc.o syshs.o sysid.o sysif.o sysil.o sysin.o sysio.o \
	sysld.o sysmm.o sysmx.o sysou.o syspl.o syspp.o sysrw.o \
	sysst.o sysstdio.o systm.o systty.o sysul.o sysxi.o

# Other C objects:
# Don't use math.o for now since not supporting math functions
COBJS =	arg2scb.o break.o checkfpu.o compress.o cpys2sc.o doexec.o \
	doset.o dosys.o float.o flush.o gethost.o getshell.o \
	int.o lenfnm.o optfile.o osclose.o \
	osopen.o ospipe.o osread.o oswait.o oswrite.o prompt.o rdenv.o \
	sioarg.o st2d.o stubs.o swcinp.o swcoup.o syslinux.o testty.o\
	trypath.o wrtaout.o

# Assembly language objects common to all versions:
CAOBJS = errors.o $(TARGET)/sys.o

# machine-dependent object
#XAOBJS = $(TARGET)/sys.o
#arith.o

# Objects for SPITBOL's HOST function:
#HOBJS=	hostrs6.o scops.o kbops.o vmode.o
HOBJS=

# Objects for SPITBOL's LOAD function.  
#LOBJS=  load.o
#LOBJS=  dlfcn.o load.o
LOBJS=

# main objects:
MOBJS=	main.o getargs.o

# All assembly language objects
AOBJS = $(CAOBJS)

# Minimal source object file:
VOBJS =	spitbol.o

# All objects:
OBJS=	$(MOBJS) $(COBJS) $(HOBJS) $(LOBJS) $(SYSOBJS) $(VOBJS) $(AOBJS)

# main program
LIBS = -L$(MUSL)/lib  -Ltcc/lib/tcc/libtcc1.a $(MUSL)/lib/libc.a 
#LIBS = -L$(MUSL)/lib  -Ltcc/lib/tcc/ -L$(MUSL)/lib/libm.a -static
#LIBS = -L$(MUSL)/lib  -Ltcc/lib/tcc/ -L$(MUSL)/lib/libm.a -L/usr/lib/i386-linux-gnu/
spitbol: $(OBJS)
ifeq	($(DEBUG),0)
 	$(CC) -o spitbol $(LIBS) $(OBJS)  
else
	$(CC) -g -o spitbol $(LIBS) $(OBJS)  
endif

# Assembly language dependencies:
errors.o: errors.s
spitbol.o: spitbol.s

# SPITBOL Minimal source
spitbol.s:	spitbol.lex $(VHDRS) $(TRANS) 
	  $(SPIT) -u "spitbol:$(TARGET):comments" $(TRANS)

spitbol.lex: $(MINPATH)spitbol.min $(LEX)
	 $(SPIT) -u "$(MINPATH)spitbol:$(TARGET):spitbol" $(LEX)

spitbol.err: spitbol.s

errors.s: $(ERR) spitbol.s
	   $(SPIT) -1=spitbol.err -2=errors.s $(ERR)

os.o: $(TARGET)/os.inc

sys.o: $(TARGET)/os.inc $(TARGET)/$(TARGET).h

x32.o: $(TARGET)/os.inc $(TARGET)/$(TARGET).h


# make os objects
cobjs:	$(COBJS)

# C language header dependencies:
$(COBJS): $(HDRS)
$(MOBJS): $(HDRS)
$(SYSOBJS): $(HDRS)
main.o: $(OS)/save.h
sysgc.o: $(OS)/save.h
sysxi.o: $(OS)/save.h
dlfcn.o: dlfcn.h

boot:
	cp -p bootstrap/spitbol.s bootstrap/spitbol.lex bootstrap/errors.s .

install:
	sudo cp spitbol /usr/local/bin
clean:
	rm -f ao $(OBJS) *.lst *.map *.err spitbol.lex spitbol.tmp spitbol.s errors.s */*.lst spitbol