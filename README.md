# Unix SPITBOL V4.05 (Apr 2018)

SPITBOL is an extremely high performance implementation of the SNOBOL4 language that brings raw power and speed
to non-numeric computation.

SPITBOL V4.05 is currently only available for 64-bit x86_64 processors running Unix.  

The latest version of SPITBOL V4.0 can be found at [github.com/spitbol/x64](http://github.com/spitbol/x64).

Address comments, suggestions, and bug reports to `spitbol@fastmail.com`.

## Language Changes

Version 4.0 differs from previous versions of SPITBOL as follows:

*   The initial value of &anchor is one, not null as in prior versions.

*   The initial value of &term is one, not null as in prior versions.

*   The initial value of &case is zero, not one as in prior versions.

The manual has always suggested setting &ANCHOR and &TERM to non-null values for more efficient searching.

Prior versions also folded cases by default, so that variables differing only in case, such as
'Var' and 'VAR' were treated as the same variable. Though this may have made sense when
lower case terminals and printers were just coming into use, those days are long gone.


## Known Problems and Limitations

The save file exit(-3) and exir(-4) function does work.   The save to executable [exit(3) and exit(4)] does not work.
save files are useful for snobol programs with a large amount of setup to do prior to execution, such as making complex patterns.

Load modules are partially supported.
It is assumed that string inputs to a function are (const char *) functions and null terminated.
a string return value is assumed to be char * and null terminated. The string is copied into a spitbol SP string.
Currently there is a problem with garbage collection that has not been perfected.

## Installing SPITBOL

If you just want to use SPITBOL without building it, the file `./bin/spitbol`
contains a statically-linked copy of the 64-bit version of spitbol (sbl-static).
Also, there is a dynamically linked copy (sbl) that requires the musl library to be installed

You can install it in `/usr/local/bin/spitbol` with the command:

```
    $ sudo make install
```
## Required Programs
    
Three tools are needed to build Spitbol:

  1. A C compiler
  2. A C runtime library
  3. An assembler

SPITBOL uses the gcc compiler to compile C source files.

SPITBOL uses [musl](http://musl-libc.org) for the runtime support.
The command `musl-gcc` must be used instead of `gcc` to link to the musl library and include files.

SPITBOL requires NASM, the Netwide ASseMbler: [nasm](http://www.nasm.us) to assemble the generated
x86_64 machine code.

For external function loading, SPITBOL also requires libffcall compiled for the musl environement.  
This can be turne doff by setting EXTFUN to 0 in osint/systype.h

## Building SPITBOL

You should be able to build SPITBOL on most Unix systems.

The file `./bin/sbl-static` is the base version of Spitbol that is used to build the system.  

To see if spitbol is working, try the "hello world" program:

```    
    $ ./bin/sbl-static test/hello.sbl
```

conversely, the dynamic version of spitbol can be tested as so:
```    
    $ ./bin/sbl test/hello.sbl
```

Prerequisite for the build:
    
For external function loading, SPITBOL also libffcall compiled for the musl environement.  
To do this, please type the following:

```    
wget https://ftp.gnu.org/gnu/libffcall/libffcall-2.1.tar.gz
tar -xzvf libffcall-2.1.tar.gz
cd libffcall-2.1
export CC=musl-gcc
./configure --prefix=/usr --libdir=/usr/lib/x86_64-linux-musl  --includedir=/usr/include/x86_64-linux-musl
make
sudo make install
```   

	
	        
To build the system:

    
```    
    $ make clean
    $ make
```

This should produce the file `./sbl` and the file `./sbl-static` . You can test it with the "hello world"
program:

    
   ``` 
    $ ./sbl-static test/hello.sbl
   ``` 

To test the system more comprehensively, do:
    
```    
    $ ./test/sanity-test
```    
    
This shell script should be run after bulding the system. Since part of the SPITBOL translator is written
in SPITBOL, it is essential to make sure that a new build of SPITBOL is able to build the system. The test
uses successive versions to build the system three times; first to see if the new version runs, second to see the
results of using it to build the system, and finally building the system again to see that none of the essential files were changed.

Three builds are needed, since it possible the new version contains an optimization or other code change whose effects will only
be tested in the final build.

Additional test programs can be found in the directory `./bin`.

NEVER replace the file `./bin/sbl-static` with a newly built `sbl-static` without first running and checking the results of
running the sanity test.  There's a good reason it has that name.  

To install the new version as the base for futher checks (after the sanity test is cleared, type the following:
```
 $ make base
 $ make
```
	


Use the command below to install `sbl` and `sbl-static` in `/usr/local/bin`.
    
```    
    $ make install
```    


## Files

The SPITBOL implementation includes the following files:

### Minimal source

The principal source file is `s.min`. The file `s.cnd` contains the definition of conditional assembly options.

### Minimal translation

`lex.sbl` is the first state of compilation. It converts the source file into a sequence of lexical tokens. 

The lexcal scan is followed by running `asm.sbl` to translate the tokens into machine code for the target machine.

The program `err.sbl` is used to produce a compact representation of the error messages contained in the Minimal source.

`./bin/sbl-static` is the statically linked binary for SPITBOL. You should be able to run in on any 64-bit x86_64 processor
using Unix.


### OSINT - Operating System Interface

The directory `osint` contains the source files written in C99 that provide an interface to the Unix
environment.

### Assembly Language Support

The files  `x64.h`,  `x64.hdr`, and `x64.s` contain that part of the runtime that cannot be expressed in C and
so is written in assembler.

### Instruction Tracing

The file `z.sbl` can be used to insert trace code in generated assembly for debugging. This is not required to
build this system, and was last used in 2009 as part of the port of SPITBOL to Linux.

### Demonstration Programs

Some demonstration programs can be found in the directory `./demos`.

## Documentation

The `./docs` directory contains:

### [The SNOBOL4 Programming Language](docs/green-book.pdf) by R. E. Griswold, J. F. Poage and I. P. Polonski.

This is the classic "Green Book" (because of the cover of its color). It is a marvel of typography, and first
introduced the use of "beads" to explain SNOBOL pattern matching.



### [MACRO SPITBOL: The High-Performance SNOBOL4 Language](docs/spitbol-manual-v3.7.pdf) by Mark Emmer and Edward Quillen.

The SPITBOL project notes with sadness the death of Ed Quillen in June, 2012.
To quote from Mark Emmer's Acknowledgments in the SPITBOL Manual:

> Ed Quillen, local novelist, political columnist, and SNOBOL enthusiast, co-
authored this manual. He combined various terse SPITBOL documents from other
systems with Catspaw's SNOBOL4+ manual, while providing more complete
explanations of some concepts. Any observed clarity is this manual is due to
Ed, while the more opaque portions can be blamed on me.

You can learn more about Ed at [Ed's web site](http://www.edquillen.com/) and
[ Denver Post columnist Ed Quillen dies at age 61 in his Salida
home](http://www.denverpost.com/obituaries/ci_20781716/denver-post-columnist-
ed-quillen-dies-at-age).

### V37.MIN

`v37.min` is the source file for SPITBOL v3.7. It is the state of SPITBOL as of 2009 when
Dave Shields took over the maintainer role. The actual code in the current system is
very close to v3.7. The main difference is that the change history has been deleted, and
the MINIMAL specification formerly in this document can now be found in the file `minimal.md`

### MINIMAL.MD

`minimal.md` contains the specification of the MINIMAL language, based on the text in `v37.min`.

## Licensing

SPITBOL is licensed using the GPLv2 (or later) license.

[COPYING](COPYING) contains a copy of the GPLv2 license.

[COPYING-SAVE-FILE](COPYING-SAVE-FILES) describes licensing issues for a
SPITBOL "save file."

[COPYING-LOAD-MODULES](COPYING-LOAD-MODULES) describes licensing issues for a
SPITBOL "load module."

## Additional Resources

Mark Emmer's SNOBOL4 site: [snobol4.com](http://snobol4.com)

Phil Bunde's SNOBOL site: [snobol4.org](http://www.snobol4.org)

