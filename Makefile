# SPITBOL makefile using nasm

ws?=64

debug?=0

os?=unix

OS=$(os)
WS=$(ws)
DEBUG=$(debug)

CC=gcc
ELF=elf$(WS)

destprefix?=/usr/local

DEST=$(destprefix)/bin
DEMODEST=$(destprefix)/share/spitbol
MANDEST=$(destprefix)/man/man1

ifeq ($(DEBUG),0)
CFLAGS= -Dm64 -m64 -static
else
CFLAGS= -Dm64 -g -m64 -static
endif

# Assembler info
# Assembler
ASM=nasm
ifeq	($(DEBUG),0)
ASMFLAGS = -f $(ELF) -d m64
else
ASMFLAGS = -g -F dwarf -f $(ELF) -d m64
endif

# Tools for processing Minimal source file.
BASEBOL =   ./bin/sbl
# Objects for SPITBOL's LOAD function.  AIX 4 has dlxxx function library.
#LOBJS=  load.o
#LOBJS=  dlfcn.o load.o
LOBJS=

spitbol: sbl

sbl: sbl.min lex.sbl asm.sbl err.sbl int.asm int.dcl int.h osint/*.c osint/*.h
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

# Use the bootstrap assembler files
# You can then do: make BASEBOL=./bootsbl to do a first make of spitbol
bootsbl:
	cp bootstrap/sbl.asm .
	cp bootstrap/err.asm .
	$(ASM) $(ASMFLAGS) err.asm
	$(ASM) $(ASMFLAGS) int.asm
	$(ASM) $(ASMFLAGS) sbl.asm
	$(CC) $(CFLAGS) -c osint/*.c
	$(CC) $(CFLAGS) *.o -obootsbl -lm
	rm -f *.o *.lst *.map *.err err.lex sbl.lex sbl.err sbl.asm err.asm

# verify that the bootstrap files match
checkboot:
	diff err.asm bootstrap/err.asm
	diff sbl.asm bootstrap/sbl.asm
	diff sbl.lex bootstrap/sbl.lex

# Run sanity check first to make sure we have good output.
makeboot: spitbol
	cp err.asm bootstrap/err.asm
	cp sbl.asm bootstrap/sbl.asm
	cp sbl.lex bootstrap/sbl.lex

# Copy binary into BASEBOL
bininst:
	cp sbl ./bin

# install into the system
install:
	sudo mkdir -p $(DEST)
	sudo mkdir -p $(DEMODEST)
	sudo mkdir -p $(MANDEST)
	sudo cp ./bin/sbl $(DEST)/spitbol
	sudo cp ./demos/* $(DEMODEST)
	sudo cp spitbol.1 $(MANDEST)/spitbol.1

clean:
	rm -f  *.o *.lst *.map *.err err.lex sbl.lex sbl.err sbl.asm err.asm ./sbl ./bootsbl

sclean:
# clean up after sanity-check
	make clean
	rm tbol*
