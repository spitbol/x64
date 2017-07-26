## Unix SPITBOL 15.01 (Jan 2015)

This version adds support for [x86-64](http://en.wikipedia.org/wiki/x86-64),
so that both 32-bit and 64-bit versions of Spitbol are now available.

Downloads in the traditional form are no longer directly supported, since both
"Google Code" and "Github" no longer provide downloads built by the project.

Spitbol is now available only from its home at
[github.com/hardbol/spitbol](http://github.com/hardbol/spitbol). If you wish
to use git to work with the probject, use:  
`$ git clone http://github.com/hardbol/spitbol`  

If you just want to use the system, then select "Download ZIP" from the
project home page, and extract the files from that.

The binaries for 32-bit and 64-bit versions can be found in
`./bin/spitbol.m32` and `./bin/spitbol.m64`, respectively.

This 64-bit version is built by default, as 32-bit processors are no longer
widely used.

Three tools are needed to build Spitbol:

  1. A C compiler
  2. A C runtime library
  3. An assembler

Previous versions used _gcc_ and _glibc_ for the compiler and runtime support,
and the [nasm](http://www.nasm.us) assembler.

This version uses [tcc](http://bellard.org/tcc) for the compiler, [musl](http
://musl-libc.org) for the runtime support, and continues the use of _nasm_.

The make file `makefile` now uses tcc and musl to build (only) the 64-bit
version. To build the 32-bit version and/or to use gcc, use `makefile.gcc`.

This version rescinds the support for Unicode added in version 13.05. (This
caused enough problems that it was deemed best to abandon this experiment.)

Known problems

  * The SAVE function doesn't work. (This loss of function occurred whilst adding 64-bit support). Note that SAVE mode was mainly of interest back in the day when Spitbol was proprietary, so that one could distribute a program written in Spitbol without having to disclose the source.

## Unix SPITBOl 13.05 (May 2013)

This version includes versions of SPITBOL for both ASCII (8-bit characters)
and Unicode (32-bit characters). The binaries can be found in ./bin/spitbol
and ./bin/uspitbol, respectively.

## Unicode SPITBOL

The Unicode version of SPITBOL (`uspitbol`) uses 32-bit characters internally.
Character strings are converted from UTF-8 encoding to 32-bit characters when
input from the command line, the operating system environment, a pipe, or a
file opened in line mode. Character strings are converted from 32-bit
characters 8-bit characters in UTF-8 format when written to a file opened in
line mode, a pipe, or when passed as an argument to an operating system
procedure.

Program source files, which are read by SPITBOL in line mode, may thus contain
UTF-8 format Unicode characters in strings and comments. Identifiers are still
restricted to ASCII.

Use the following command to build the Unicode version:

    
    
    $ make UNICODE=1
    

## Overview

SPITBOL is an extremely high performance implementation of the SNOBOL4
language.

It is maintained by Dave Shields (thedaveshields at gmail dot com).

Source files, development versions, as well as other files of interest, can be
found at [github.com/hardbol/spitbol](http://github.com/hardbol/spitbol).

Downloads are available from [ http://code.google.com/p/spitbol/downloads/list
](http://code.google.com/p/spitbol/downloads/list)

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

    
    
    $ sudo make install
    

## Building SPITBOL

You should be able to build SPITBOL on most Unix systems with a processor that
implements the x86-32 or x86-64 architecture.

The development work and testing was done using the 32-bit version of [linux
mint](http://linuxmint.com), a variant of Ubuntu.

You need the `gcc` compiler, `make`, and the netwide assembler, `nasm`, to
build the system. You can install nasm with:

    
    
    $ sudo apt-get install nasm
    

The file `./bin/spitbol` is the base version of Spitbol that is used to build
the system.

To see if spitbol is working, try the "hello world" program:

    
    
    $ ./bin/spitbol test/hi.spt
    

To build the system:

    
    
    $ make clean
    $ make
    

This should produce the file `spitbol`. You can test it with the "hello world"
program:

    
    
    $ ./spitbol test/hi.spt
    

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

asm.spt

    Second stage of translator. It translates the token file produced by lex.spt to x86 assembly language.
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
lex.spt

    First stage of translator. It translates Minimal source to a file of lexemes (tokens)
makefile

    make file
map-x32.spt

    file used for debugging x32 version
map-x64.spt

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
x32.h

    header file for 32-bit version
x32.hdr

    file prepended to s.min for compiling 32-bit version
x32.s

    assembly language support and interface routines for 32-bit version
x64.h

    header file for 64-bit version
x64.hdr

    file prepended to s.min for compiling 64-bit version
x64.s

    assembly language support and interface routines for 64-bit version
z.spt

    prorgram used to insert trace code in generated assembly for debugging.

## Notes

This version contains code supporting both 32 and 64 bit implementations of
SPITBOL. Only the 32-bit version is complete. The 64-bit version is able to
compile lex and asm, but fails compiling the error message processor.

You can build the 64-bit version, on a 64-bit system, with:

    
    
    $ make ARCH=X32_64
    

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

## Release History

## Unix SPITBOL 13.01 (January 2013)

This version completes the initial port to Linux. Currently only Intel 32-bit
(X32) architecture is supported. There are files for building a 64-bit
version, but this version is not able to compile itself.

