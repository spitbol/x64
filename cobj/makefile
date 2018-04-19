# SPITBOL makefile using musl-gcc

ws?=64

debug?=1

os?=unix

OS=$(os)
WS=$(ws)
DEBUG=$(debug)

CC=musl-gcc
ELF=elf$(WS)

# SPITBOL Version:
MIN=   s

# Minimal source directory.
MINPATH=./

OSINT=../osint

vpath %.c $(OSINT)

ifeq	($(DEBUG),0)
SCFLAGS= -D m64 -O3 -static -m64 -DGEN_C_CODE=1
CFLAGS= -D m64 -O3  -m64  -DGEN_C_CODE=1
else
SCFLAGS= -D m64 -g -static -m64  -DGEN_C_CODE=1
CFLAGS= -D m64 -g -m64  -DGEN_C_CODE=1
endif

# Assembler info -- Intel 64-bit syntax
ifeq	($(DEBUG),0)
ASMFLAGS = -f $(ELF) -d m64
else
ASMFLAGS = -g -f $(ELF) -d m64
endif

# Tools for processing Minimal source file.
BASEBOL =   ../bin/sbl-static

BASEBOLS = ../bin/csbl

# Implicit rule for building objects from C files.
./%.o: %.c
#.c.o:
	$(CC)  $(CFLAGS) -c  -o$@ $(OSINT)/$*.c

# Implicit rule for building objects from assembly language files.
.s.o:
	nasm $(ASMFLAGS) -l $*.lst -o$@ $*.s

# C Headers common to all versions and all source files of SPITBOL:
CHDRS =	$(OSINT)/osint.h $(OSINT)/port.h $(OSINT)/sproto.h $(OSINT)/spitio.h $(OSINT)/spitblks.h $(OSINT)/globals.h 

# C Headers unique to this version of SPITBOL:
UHDRS=	$(OSINT)/systype.h $(OSINT)/extern64.h $(OSINT)/blocks64.h $(OSINT)/system.h

# Headers common to all C files.
HDRS=	$(CHDRS) $(UHDRS)

# Headers for Minimal source translation:
VHDRS=	x64.hdr 

# OSINT objects:
SYSOBJS=sysax.o sysbs.o sysbx.o syscm.o sysdc.o sysdt.o sysea.o \
	sysef.o sysej.o sysem.o sysen.o sysep.o sysex.o sysfc.o \
	sysgc.o syshs.o sysid.o sysif.o sysil.o sysin.o sysio.o \
	sysld.o sysmm.o sysmx.o sysou.o syspl.o syspp.o sysrw.o \
	sysst.o sysstdio.o systm.o systty.o sysul.o sysxi.o 

# Other C objects:
COBJS =	break.o checkfpu.o compress.o cpys2sc.o \
	doset.o dosys.o fakexit.o float.o flush.o gethost.o getshell.o \
	lenfnm.o math.o optfile.o osclose.o \
	osopen.o ospipe.o osread.o oswait.o oswrite.o prompt.o rdenv.o \
	st2d.o stubs.o swcinp.o swcoup.o syslinux.o testty.o\
	trypath.o wrtaout.o zz.o 
		
# C only pnjects


# Assembly langauge objects common to all versions:
CAOBJS = 
NAOBJS = 


# for the c version:
C_CAOBJS = 
C_NAOBJS = cx64.o cerr.o

# Objects for SPITBOL's HOST function:
HOBJS=

# Objects for SPITBOL's LOAD function.  AIX 4 has dlxxx function library.
#LOBJS=  load.o
#LOBJS=  dlfcn.o load.o
LOBJS=

# main objects:
MOBJS=	getargs.o main.o

# All assembly language objects
AOBJS = $(CAOBJS)

C_AOBJS = $(C_CAOBJS)

# Minimal source object file:
VOBJS =	s.o
C_VOBJS = cs.o

# All objects:
OBJS=	$(AOBJS) $(COBJS) $(HOBJS) $(LOBJS) $(SYSOBJS) $(VOBJS) $(MOBJS) $(NAOBJS)

# All objects for c version:
C_OBJS=	$(C_AOBJS) $(COBJS) $(HOBJS) $(LOBJS) $(SYSOBJS) $(C_VOBJS) $(MOBJS) $(C_NAOBJS)

# link spitbol with static linking
LIBS = 




system: $(OSINT)/gen_code_c.h  csbl

csbl: $(C_OBJS)
	$(CC) $(CFLAGS) $(C_OBJS) $(LIBS) -lm /usr/lib/x86_64-linux-musl/libffcall.a -ocsbl 
	cp csbl ..

# Assembly language dependencies:
err.o: err.s


cerr.o: $(OSINT)/cerr.c
cs.o: cs.c



$(OSINT)/gen_code_c.h: $(OSINT)/gen_c_code_head_fragment.h $(OSINT)/gen_c_code_tail_fragment.h $(OSINT)/cs.c
	$(BASEBOL) cs_c_to_gen_c_code.sbl <$(OSINT)/cs.c >tempad
	cat >$(OSINT)/gen_code_c.h  $(OSINT)/gen_c_code_head_fragment.h  tempad $(OSINT)/gen_c_code_tail_fragment.h
	rm  tempad


$(OSINT)/cerr.c: err.s ../convert_err_s_to_err_c.sbl
	$(BASEBOL) ../convert_err_s_to_err_c.sbl <err.s >$(OSINT)/cerr.c


cx64.o: cx64.c


base:  sbl-static sbl
	cp  sbl-static sbl ./bin

# SPITBOL Minimal source
s.go:	s.lex go.sbl
	$(BASEBOL) -x -u i64 go.sbl

	
x64.hdr: ../x64.hdr
	cp ../x64.hdr .	

$(OSINT)/cs.c: 	s.lex $(VHDRS) ../cgen.sbl x64.hdr
	$(BASEBOL) -x -u $(WS) ../cgen.sbl

s.min: ../s.min
	cp ../s.min .

s.cnd: ../s.cnd
	cp ../s.cnd .


s.lex: $(MINPATH)s.min s.cnd ../lex.sbl
	 $(BASEBOL) -x -u $(WS) ../lex.sbl

err.s: ../err.s
	cp ../err.s .


cs.err: cs.c


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
	sudo cp ./bin/sbl /usr/local/bin
clean:
	rm -f $(OBJS) *.o *.lst *.map *.err s.lex s.tmp s.s err.s s.S s.t ./sbl ./sbl-static

z:
	nm -n s.o >s.nm
	sbl map-$(WS).sbl <s.nm >s.dic
	sbl z.sbl <ad >ae

sclean:
# clean up after sanity-check
	make clean
	rm tbol*
