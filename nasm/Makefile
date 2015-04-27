# SPITBOL makefile using tccSE
ws?=32
WS=$(ws)

host?=unix_$(WS)
HOST=$(host)

DEBUG:=$(debug)

nasm?=nasm

debug?=0

NASM=$(nasm)

os?=unix
OS:=$(os)

asm?=nasm
ASM=$(asm)


TARGET=$(OS)_$(WS)

it?=0
IT:=$(it)
ifneq ($(IT),0)
ITOPT:=:it
ITDEF:=-Dzz_trace
endif

# basebol determines which spitbol to use to compile
sbl?=./bin/sbl_$(HOST)

BASEBOL:=$(sbl)

cc?=gcc
CC:=$(cc)

ifeq	($(DEBUG),1)
GFLAG=-g
endif

ARCH=-D$(TARGET)  -m$(WS)

CCOPTS:= $(ITDEF) $(GFLAG) 
LDOPTS:= $(GFLAG)
LMOPT:=-lm

ifeq ($(OS),unix)
ELF:=elf$(WS)
else
EL:F=macho$(WS)
endif


OSINT=./osint

vpath %.c $(OSINT)

# Assembler info -- Intel 32-bit syntax
ifeq	($(DEBUG),0)
NASMOPTS = -f $(ELF) -D$(TARGET) $(ITDEF)
else
NASMOPTS = -g -f $(ELF) -D$(TARGET) $(ITDEF)
endif

OSXOPTS = -f macho32 -Dosx_32 $(ITDEF)
# tools for processing Minimal source file.

# implicit rule for building objects from C files.
./%.o: %.c
#.c.o:
	$(CC)  $(CCOPTS) -c  -o$@ $(OSINT)/$*.c

unix_32:
	$(CC) -Dunix_32 -m32 $(CCOPTS) -c osint/*.c
	$(BASEBOL)  -u unix_32 lex.sbl
	$(BASEBOL)  -r -u unix_32:$(ITOPT) -1=sbl.lex -2=sbl.tmp -3=sbl.err asm.sbl
	$(BASEBOL)  -u unix_32 -1=sbl.err -2=err.s err.sbl
	cat sys.asm err.s sbl.tmp >sbl.s
	$(NASM) -f elf32 -Dunix_32 -o sbl.o sbl.s
	$(CC) -lm -Dunix_32 -m32 $(LDOPTS)  *.o -lm  -osbl 

unix_64:
	$(CC) -Dunix_64 -m64 $(CCOPTS) -c osint/*.c
	./bin/sbl_unix_64 -u unix_64 lex.sbl
	./bin/sbl_unix_64 -r -u unix_64:$(ITOPT) -1=sbl.lex -2=sbl.tmp -3=sbl.err asm.sbl
	./bin/sbl_unix_64 -u unix_64 -1=sbl.err -2=err.s err.sbl
	cat sys.asm err.s sbl.tmp >sbl.s
	$(NASM) -f elf64 -Dunix_64 -o sbl.o sbl.s
	$(CC) -lm -Dunix_64 -m64 $(LDOPTS)  *.o -lm  -osbl 

osx_32:
	$(CC) $(CCOPTS) -c osint/*.c
	$(BASEBOL)  -u osx_32 lex.sbl
	$(BASEBOL)  -r -u osx_32:$(ITOPT) -1=sbl.lex -2=sbl.tmp -3=sbl.err asm.sbl
	$(BASEBOL)  -u osx_32 -1=sbl.err -2=err.s err.sbl
	cat sys.asm err.s sbl.tmp >sbl.s
	$(NASM) -f macho32 -Dosx_32 -o sbl.o sbl.s
	$(CC) -lm -Dosx_32 -m32 $(LDOPTS)  *.o -lm  -osbl 

# link spitbol with dynamic linking
spitbol-dynamic: $(OBJS) $(NOBJS)
	$(CC) $(LDOPTS) $(OBJS) $(NOBJS) $(LMOPT)  -osbl 

# bootbol is for bootstrapping just link with what's at hand
#bootbol: $(OBJS)
# no dependencies so can link for osx bootstrap
bootbol: 
	$(CC) $(LDOPTS)  $(OBJS) $(LMOPT) -obootbol

osx-export: 
	
	cp sbl.s  osx/sbl.s
	$(NASM) -Dosx_32 -f macho32 -o osx/sbl.o osx/sbl.s

osx-import: 
	gcc -arch i386 -c osint/*.c
	cp osx/*.o .
	gcc -arch i386  -o sbl *.o

# install binaries from ./bin as the system spitbol compilers
install:
	sudo cp ./bin/sbl /usr/local/bin
.PHONY:	clean
clean:
	rm -f $(OBJS) *.o s.lex s.tmp err.s sbl.s ./sbl sbl.lex sbl.tmp

z:
	nm -n s.o >s.nm
	sbl map-$(WS).sbl <s.nm >s.dic
	sbl z.sbl <ad >ae

sclean:
# clean up after sanity-check
	make clean
	rm tbol*

