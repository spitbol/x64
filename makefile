# SPITBOL makefile using musl-gcc

ifeq	($(DEBUG),0)
#CFLAGS= -D m64 -m64 -Itools/tcc/include
CFLAGS= -D m64 -m64 
else
#CFLAGS= -D m64 -g -m64 
CFLAGS= -D m64 -g -m64
endif

# Assembler info -- Intel 32-bit syntax
ifeq	($(DEBUG),0)
ASMFLAGS = -f elf64 -d m64
else
ASMFLAGS = -g -f elf64 -d m64
endif

# Tools for processing Minimal source file.
BASEBOL =   ./bin/sbl


musl:
	musl-gcc -c $(CFLAGS) -lm ./osint/*.c

sbl:

	musl-gcc -osbl $(CFLAGS) $(OBJS) $(LIBS) lm ./osint/*.c
	$(BASEBOL) lex.spt
	$(BASEBOL) asm.spt
	$(BASEBOL) -1=s.err -2=err.s err.spt
	nasm $(ASMFLAGS) -l $*.lst -o$@ $*.s
	musl-gcc -osbl $(CFLAGS) LIBS) lm *.o

# link sbl with dynamic linking
sbl-dynamic: $(OBJS)
	musl-gcc -osbl $(CFLAGS) $(OBJS) $(LIBS) lm -./osint/*.c


# make osint objects
cobjs:	$(COBJS)

# C language header dependencies:
$(COBJS): $(HDRS)
$(MOBJS): $(HDRS)
$(SYSOBJS): $(HDRS)
main.o: ./osint/save.h
sysgc.o: ./osint/save.h
sysxi.o: ./osint/save.h
dlfcn.o: dlfcn.h

# install binaries from ./bin as the system sbl compilers
install:
	sudo cp ./bin/sbl /usr/local/bin
clean:
	rm -f $(OBJS) *.o *.lst *.map *.err s.lex s.tmp s.s err.s s.S s.t ./sbl

z:
	nm -n s.o >s.nm
	sbl map-64.spt <s.nm >s.dic
	sbl z.spt <ad >ae

sclean:
# clean up after sanity-check
	make clean
	rm tbol*
