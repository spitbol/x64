## Unix SPITBOL V4.0 (July 2017)

The project provides support only for the 64-bit x86_64 version.

Spitbol is now available only from its home at
[github.com/hardbol/spitbol](http://github.com/hardbol/spitbol). If you wish
to use git to work with the probject, use:  
```
$ git clone http://github.com/hardbol/spitbol`  
```
If you just want to use the system, then select "Download ZIP" from the
project home page, and extract the files from that.


Three tools are needed to build Spitbol:

  1. A C compiler
  2. A C runtime library
  3. An assembler

SPITBOL uses the gcc compiler to compile C source files.

SPITBOL use [musl](http://musl-libc.org) for the runtime support.
The command `musl-gcc` must be used instead of `gcc` to link to the musl library and include files.

SPITBOL requires NASM, the Netwide ASseMbler: [nasm](http://www.nasm.us).


Known problems

* The SAVE function doesn't work. (This loss of function occurred whilst adding 64-bit support). Note that SAVE mode was mainly of interest back in the day when Spitbol was proprietary, so that one could distribute a program written in Spitbol without having to disclose the source.

## Overview

SPITBOL is an extremely high performance implementation of the SNOBOL4
language.

It is maintained by Dave Shields (thedaveshields at gmail dot com).

Source files, development versions, as well as other files of interest, can be
found at [github.com/hardbol/spitbol](http://github.com/hardbol/spitbol).

## Licensing

SPITBOL is licensed with the GPLv2 (or later) license.

[COPYING](COPYING) contains a copy of the GPLv2 license.

[COPYING-SAVE-FILE](COPYING-SAVE-FILES) describes licensing issues for a
SPITBOL "save file."

[COPYING-LOAD-MODULES](COPYING-LOAD-MODULES) describes licensing issues for a
SPITBOL "load module."

## Known Problems and Limitations

Load modules are not supported.

Loading of external functions is not supported.

## Installing SPITBOL

If you just want to use spitbol without building it, the file `./bin/spitbol`
contains a statically-linked copy of the 8-bit version of spitbol.

You can install it in `/usr/local/bin/spitbol` with the command:

```
    $ sudo make install
```
    

## Building SPITBOL

You should be able to build SPITBOL on most Unix systems.

The file `./bin/spitbol` is the base version of Spitbol that is used to build
the system.

To see if spitbol is working, try the "hello world" program:

```    
    $ ./bin/spitbol test/hello.sbl
```
    
To build the system:

    
```    
    $ make clean
    $ make
```

This should produce the file `spitbol`. You can test it with the "hello world"
program:

    
   ``` 
    $ ./spitbol test/hi.sbl
   ``` 

Directory `demos` contains some demonstration programs.  
Directory `test` contains some small test programs.

To test the system more comprehensively, do:

    
    
    $ ./test/sanity-test
    

which verifies that the version of SPITBOL just built is able to translate
itself. This test passes if the diff outputs are null.

NEVER replace the file `./bin/spitbol` with a newly built `spitbol` unless you
have run the sanity test.

By default, the `spitbol` binary is linked statically. To get a dynamically-
linked version, do:

    
    
    $ make
    $ rm spitbol
    $ make spitbol-dynamic
    

Use the command:

    
    
    $ make install
    

to install `spitbol` in `/usr/local/bin`.

This version of SPITBOL was built using a 32-bit version of Unix. If you are
running a 64-bit system, then you may get compile errors when you try to build
the system, in which case you need to install the 32-bit runtime libraries.

You can do this on Mint (and also Ubuntu) with:

    
    
    $ sudo apt-get install ia32-libs
    

or, if that doesn't work, try:

    
    
    $ sudo apt-get install ia32-libs-multiarch
    

## Files

The SPITBOL implementation includes the following files:

asm.sbl

    Second stage of translator. It translates the token file produced by lex.sbl to x86 assembly language.
./bin/spitbol

    base compiler, used to compile the SPITBOL part of the Minimal translator
./bin/uspitbol

    variant of SPITBOL that supports Unicode. COPYING 
    license information

COPYING-LOAD-MODULES

    license information for SPITBOL load modules

COPYING-SAVE-FILES

    license information for SPITBOL save files

demos

    directory with SPITBOL demonstration programs

docs

    directory with pdf version of SNOBOL "Green Book" and MACRO SPITBOL user manual.

lex.sbl

    First stage of translator. It translates Minimal source to a file of lexemes (tokens)

makefile

    make file

map-x32.sbl

    file used for debugging x32 version
map-x64.sbl

    file used to debugging x64 version

minimal-reference-manual.html

    Minimal Reference Manual

osint

    operating system interface files, written in C99.

readme.html

    system introduction

README.md

    system identification (required by Github for use with Git).

sanity-check

    script to run test that compiler can compile itself

s.cnd

    selection of Minimal conditional assembly options for spitbol

s.min

    Minimal source for SPITBOL

test

    directory with several small tests

x64.h

    header file for 64-bit version

x64.hdr

    file prepended to s.min for compiling 64-bit version

x64.s

    assembly language support and interface routines for 64-bit version

z.sbl

    prorgram used to insert trace code in generated assembly for debugging.

## Documentation

The `./docs` directory contains:

  * [The SNOBOL4 Programming Language](docs/green-book.pdf) by R. E. Griswold, J. F. Poage and I. P. Polonski.
  * [MACRO SPITBOL: The High-Performance SNOBOL4 Language](docs/spitbol-manual-v3.7.pdf) by Mark Emmer and Edward Quillen.

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

## Resources

Mark Emmer's SNOBOL4 site: [snobol4.com](http://snobol4.com)

Phil Bunde's SNOBOL site: [snobol4.org](http://www.snobol4.org)

