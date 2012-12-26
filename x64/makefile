# X32 SPITBOL
#


# SPITBOL Version:
MIN=   s
DEBUG=	1

# Minimal source directory.
MINPATH=./

OSINT=./osint

vpath %.c $(OSINT)



CC	=	tcc
ASM	=	nasm
INCDIRS = -I../tcc/include -Imusl/include
# next is for tcc
ifeq	($(DEBUG),0)
CFLAGS= $(INCDIRS)
else
CFLAGS= -g  $(INCDIRS)
endif
# next is for gcc
#ifeq	($(DEBUG),0)
#CFLAGS= -m32 -O2 -fno-leading-underscore -mfpmath=387
#else
#CFLAGS= -g -m32 -fno-leading-underscore -mfpmath=387
#endif

# Assembler info -- Intel 32-bit syntax
ifeq	($(DEBUG),0)
ASMFLAGS = -f elf64
else
ASMFLAGS = -g -f elf64
endif

# Tools for processing Minimal source file.
LEX=	lex.spt
COD=    asm.spt
ERR=    err.spt
SPIT=   ./bootbol

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
VHDRS=	$(MIN).hdr

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
	trypath.o wrtaout.o zz.o

# Assembly langauge objects common to all versions:
# CAOBJS is for gas, NAOBJS for nasm
CAOBJS = 
NAOBJS = x64.o errors.o

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

# main program
spitbol: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -lm -ospitbol

# Assembly language dependencies:
errors.o: errors.s
s.o: s.s

errors.o: errors.s


# SPITBOL Minimal source
s.s:	s.lex $(VHDRS) $(COD) 
	$(SPIT) -u "s:$(MIN):comments" $(COD)
	cp	s.s	s.S
	$(SPIT) san.spt <s.s >s.t
	cp	s.t s.s

s.lex: $(MINPATH)$(MIN).min $(MIN).cnd $(LEX)
	 $(SPIT) -u "$(MINPATH)s:$(MIN):s" $(LEX)

s.err: s.s

errors.s: $(MIN).cnd $(ERR) s.s
	   $(SPIT) -1=s.err -2=errors.s $(ERR)


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
	cp -p bootstrap/s.s bootstrap/s.lex bootstrap/errors.s .

install:
	sudo cp spitbol /usr/local/bin
clean:
	rm -f $(OBJS) *.o *.lst *.map *.err s.lex s.tmp s.s errors.s s.S s.t
