# SPITBOL makefile using nasm

ws?=64

debug?=0

os?=unix

OS=$(os)
WS=$(ws)
DEBUG=$(debug)

CC=gcc
ELF=elf$(WS)


ifeq	($(DEBUG),0)
CFLAGS= -D m64 -m64 -static 
else
CFLAGS= -D m64 -g -m64
endif

# Assembler info 
# Assembler
ASM=nasm
ifeq	($(DEBUG),0)
ASMFLAGS = -f $(ELF) -d m64
else
ASMFLAGS = -g -f $(ELF) -d m64
endif

# Tools for processing Minimal source file.
BASEBOL =   ./bin/sbl
# Objects for SPITBOL's LOAD function.  AIX 4 has dlxxx function library.
#LOBJS=  load.o
#LOBJS=  dlfcn.o load.o
LOBJS=

spitbol: 
#	rm sbl sbl.lex sbl.s sbl.err err.s
	$(BASEBOL) lex.sbl 
	$(BASEBOL) -x asm.sbl
	$(BASEBOL) -x -1=sbl.err -2=err.asm err.sbl
	$(ASM) $(ASMFLAGS) err.asm
	$(ASM) $(ASMFLAGS) int.asm
	$(ASM) $(ASMFLAGS) sbl.asm
#stop:
	$(CC) $(CFLAGS) -c osint/*.c
	$(CC) $(CFLAGS) *.o -osbl -lm
# link spitbol with dynamic linking
spitbol-dynamic: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) $(LIBS) -osbl -lm 

sbl.go:	sbl.lex go.sbl
	$(BASEBOL) -x -u i32 go.sbl

# Copy binary into BASEBOL
bininst:
	cp sbl ./bin

# install binaries from ./bin as the system spitbol compilers
install:
	sudo cp ./bin/sbl /usr/local/bin
clean:
	rm -f  *.o *.lst *.map *.err err.lex sbl.lex sbl.err sbl.asm err.asm ./sbl  

z:
	nm -n sbl.o >s.nm
	sbl map-$(WS).sbl <s.nm >s.dic
	sbl z.sbl <ad >ae

sclean:
# clean up after sanity-check
	make clean
	rm tbol*
