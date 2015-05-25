# SPITBOL makefile using gcc 
host?=sbl_unix_64
HOST=$(host)

DEBUG:=$(debug)

nasm?=nasm

debug?=0

os?=unix
OS:=$(os)

ws?=64
WS:=$(ws)

asm?=as
ASM:=$(asm)


TARGET=$(OS)_$(WS)

trc?=0
TRC:=$(trc)
ifneq ($(TRC),0)
TRCOPT:=:trc
endif

sbl?=./bin/sbl_unix_64
SBL=$(sbl)

cc?=gcc
CC:=$(cc)

ifeq	($(DEBUG),1)
GFLAG=-g
endif

ARCH=-D$(TARGET)  -m$(WS)

CCOPTS:= $(GFLAG) 
LDOPTS:= $(GFLAG)
LMOPT:=-lm

ifeq ($(OS),unix)
ELF:=elf$(WS)
else
EL:F=macho$(WS)
endif


OSINT=./osint

vpath %.c $(OSINT)

# Assembler info -- Intel 64-bit syntax
ifeq	($(DEBUG),0)
ASMOPTS =  -D$(TARGET) 
else
ASMOPTS = -g  -D$(TARGET) 
endif

OSXOPTS = -f macho64 -Dosx_64 
# tools for processing Minimal source file.

# implicit rule for building objects from C files.
./%.o: %.c
#.c.o:
	$(CC)  $(CCOPTS) -c  -o$@ $(OSINT)/$*.c

unix_64_gas:
	rm -fr bld
	mkdir bld
	$(CC) -Dunix_64 -m64 $(CCOPTS) -c osint/*.c
	mv *.o bld
	$(SBL) -u unix_64_gas	-1=sbl.asm	-2=bld/sbl.lex -3=bld/sbl.equ lex.sbl
	$(SBL) -u unix_64:$(TRCOPT) -1=bld/sbl.lex	-2=bld/sbl.tmp -3=bld/sbl.err -4=bld/sbl.equ gas/asm.sbl
	$(SBL) -u unix_64_gas	-1=bld/sbl.err -2=bld/err.s 	err.sbl
	cat gas/sys.asm bld/err.s bld/sbl.tmp >bld/sbl.s
	as -o bld/sbl.o bld/sbl.s
	$(CC) -lm -Dunix_64 -m64 $(LDOPTS)  bld/*.o -lm  -osbl 

unix_64_nasm:
	rm -fr bld
	mkdir bld
	$(CC) -Dunix_64 -m64 $(CCOPTS) -c osint/*.c
	mv *.o bld
	$(SBL) -u unix_64 		-1=sbl.asm 	-2=bld/sbl.lex	-3=bld/sbl.equ lex.sbl
	$(SBL) -u unix_64:$(TRCOPT) -1=bld/sbl.lex	-2=bld/sbl.tmp	-3=bld/sbl.err -4=bld/sbl.equ nasm/asm.sbl
	$(SBL) -u unix_64_nasm 	-1=bld/sbl.err	-2=bld/err.s 	err.sbl
	cat nasm/sys.asm bld/err.s bld/sbl.tmp >bld/sbl.s
	nasm -f elf64 -Dunix_64 -o bld/sbl.o bld/sbl.s
	$(CC) -lm -Dunix_64 -m64 $(LDOPTS)  bld/*.o -lm  -osbl 

osx_64:
	$(CC) $(CCOPTS) -c osint/*.c
	$(SBL)  -u osx_64 lex.sbl
	$(SBL)  -r -u osx_64:$(TRCOPT) -1=sbl.lex -2=sbl.tmp -3=sbl.err asm.sbl
	$(SBL)  -u osx_64 -1=sbl.err -2=err.s err.sbl
	cat sys.asm err.s sbl.tmp >sbl.s
	$(ASM) -f macho64 -Dosx_64 -o sbl.o sbl.s
	$(CC) -lm -Dosx_64 -m64 $(LDOPTS)  *.o -lm  -osbl 

lex-0:
	./nbl -I  -u unix_64_gas -1=sbl.asm -2=lx/sbl.lex.0 -3=lx/sbl.equ.0 lex.sbl 1>lx/ok.ad 2>lx/ok.ae
lex-1:
	./sbl -I -u unix_64_gas -1=sbl.asm -2=lx/sbl.lex.1 -3=lx/sbl.equ.1 lex.sbl  1>lx/ad 2>lx/ae
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
	$(ASM) -Dosx_64 -f macho64 -o osx/sbl.o osx/sbl.s

osx-import: 
	gcc -arch i386 -c osint/*.c
	cp osx/*.o .
	gcc -arch i386  -o sbl *.o

# install binaries from ./bin as the system spitbol compilers
install:
	sudo cp ./bin/sbl /usr/local/bin
.PHONY:	clean
clean:
	rm -f bld/*  ./sbl  sbl_unix_64 tb*

z:
	nm -n s.o >s.nm
	sbl map-$(WS).sbl <s.nm >s.dic
	sbl z.sbl <ad >ae

# build system using nasm
nasm_64:
	$(CC) -Dunix_64 -m64 $(CCOPTS) -c osint/*.c
	$(SBL) -u unix_64 lex.sbl
	$(SBL) -r -u unix_64:$(ITOPT) -1=sbl.lex -2=sbl.tmp -3=sbl.err nasm/asm.sbl
	$(SBL) -u unix_64 -1=sbl.err -2=err.s nasm/err.sbl
	cat sys.asm err.s sbl.tmp >sbl.s
	nasm -f elf64 -Dunix_64 -o sbl.o sbl.s
	$(CC) -lm -Dunix_64 -m64 $(LDOPTS)  *.o -lm  -osbl 

nasm_32:
	$(CC) -Dunix_32 -m32 $(CCOPTS) -c osint/*.c
	$(SBL)  -u unix_32 nasm/lex.sbl
	$(SBL)  -r -u unix_32:$(ITOPT) -1=sbl.lex -2=sbl.tmp -3=sbl.err nasm/asm.sbl
	$(SBL)  -u unix_32 -1=sbl.err -2=err.s nams/err.sbl
	cat sys.asm err.s sbl.tmp >sbl.s
	nasm -f elf32 -Dunix_32 -o sbl.o sbl.s
	$(CC) -lm -Dunix_32 -m32 $(LDOPTS)  *.o -lm  -osbl 

sclean:
# clean up after sanity-check
	make clean
	rm tbol*

sanity_unix_64:
# Do a sanity test on spitbol to  verify that spitbol is able to compile itself.
# This is done by building the system three times, and comparing the generated assembly (.s)
# filesbl. Normally, all three assembly files wil be equal. However, if a new optimization is
# being introduced, the first two may differ, but the second and third should always agree.
#
	echo "start 64-bit sanity test"
	rm -f tbol.*
	cp ./bin/sbl_unix_64 .
	rm -fr bld
	mkdir bld
	cp ./bin/sbl_unix_64 .
	$(CC) -Dunix_64 -m64 $(CCOPTS) -c osint/*.c
	mv *.o bld
	./sbl_unix_64 -u unix_64_gas -1=sbl.asm -2=bld/sbl.lex -3=bld/sbl.equ lex.sbl
	./sbl_unix_64 -r -u unix_64:$(TRCOPT) -1=bld/sbl.lex -2=bld/sbl.tmp -3=bld/sbl.err -4=bld/sbl.equ gas/asm.sbl
	./sbl_unix_64 -u unix_64_gas -1=bld/sbl.err -2=bld/err.s err.sbl
	cat gas/sys.asm bld/err.s bld/sbl.tmp >bld/sbl.s
	as -o bld/sbl.o bld/sbl.s
	$(CC) -lm -Dunix_64 -m64 $(LDOPTS)  bld/*.o -lm  -osbl 
	mv bld/sbl.lex	tbol.sbl.lex.0
	mv bld/sbl.s	tbol.sbl.s.0
	mv ./sbl sbl_unix_64
	rm bld/sbl.o
	./sbl_unix_64 -u unix_64_gas -1=sbl.asm -2=bld/sbl.lex -3=bld/sbl.equ lex.sbl
	./sbl_unix_64 -r -u unix_64:$(TRCOPT) -1=bld/sbl.lex -2=bld/sbl.tmp -3=bld/sbl.err -4=bld/sbl.equ gas/asm.sbl
	./sbl_unix_64 -u unix_64_gas -1=bld/sbl.err -2=bld/err.s err.sbl
	cat gas/sys.asm bld/err.s bld/sbl.tmp >bld/sbl.s
	as -o bld/sbl.o bld/sbl.s
	$(CC) -lm -Dunix_64 -m64 $(LDOPTS)  bld/*.o -lm  -osbl 
	mv bld/sbl.lex	tbol.sbl.lex.1
	mv bld/sbl.s	tbol.sbl.s.1
	mv ./sbl sbl_unix_64
	./sbl_unix_64 -u unix_64_gas -1=sbl.asm -2=bld/sbl.lex -3=bld/sbl.equ lex.sbl
	./sbl_unix_64 -r -u unix_64:$(TRCOPT) -1=bld/sbl.lex -2=bld/sbl.tmp -3=bld/sbl.err -4=bld/sbl.equ gas/asm.sbl
	./sbl_unix_64 -u unix_64_gas -1=bld/sbl.err -2=bld/err.s err.sbl
	cat gas/sys.asm bld/err.s bld/sbl.tmp >bld/sbl.s
	as -o bld/sbl.o bld/sbl.s
	$(CC) -lm -Dunix_64 -m64 $(LDOPTS)  bld/*.o -lm  -osbl 
	cp bld/sbl.lex	tbol.sbl.lex.2
	cp bld/sbl.s	tbol.sbl.s.2
	$(CC) -Dunix_64 -m64 $(CCOPTS) -c osint/*.c
	echo "comparing generated .s files"
	diff tbol.sbl.s.1 tbol.sbl.s.2
	echo "end sanity test"
	
