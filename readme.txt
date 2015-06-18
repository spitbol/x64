Update		17 June 2015	Dave Shields

File ./docs/minimal-reference-manual.md replaces ./docs/minimal-reference-manual.html. (This was easier to format, and the
markdown md format can be viewed directly from github.)

File ./docs/markdown.html is a reference document for writing markdown format.

Note that ./docs/v37.min has Minimal source as of September 2009 (when I took over the project). It contains
a record of changes  going back to 1977, almost forty years ago.

Status Report	15 June 2015	Dave Shields

The port to OSX is now working and passes the basic sanity test:
	make osx	build ./sbl for osx 64 bit
	make test_osx

The unix/linux version is built and tested with
	make unix	build ./sbl for unix 64 bit
	make test_unix


The "sanity" test on spitbol verifies that spitbol is able to translate itself.
This is done by building the system three times, and comparing the generated assembly files. 
Normally, all three assembly files wil be equal. However, if a new optimization is
being introduced, the first two may differ, but the second and third should always agree.

Examine the test results with

	ls -l tb*

Here is the result from a successfull run on Linux:
	-rwxr-xr-x 1 daveshields daveshields 289957 Jun 14 17:48 tbol
	-rw-r--r-- 1 daveshields daveshields  41362 Jun 14 17:48 tbol.err.1
	-rw-r--r-- 1 daveshields daveshields  41362 Jun 14 17:48 tbol.err.2
	-rw-r--r-- 1 daveshields daveshields  41362 Jun 14 17:48 tbol.err.s
	-rw-r--r-- 1 daveshields daveshields 910986 Jun 14 17:48 tbol.lex.0
	-rw-r--r-- 1 daveshields daveshields 910986 Jun 14 17:48 tbol.lex.1
	-rw-r--r-- 1 daveshields daveshields 910986 Jun 14 17:48 tbol.lex.2
	-rw-r--r-- 1 daveshields daveshields 472404 Jun 14 17:48 tbol.s.0
	-rw-r--r-- 1 daveshields daveshields 472404 Jun 14 17:48 tbol.s.1
	-rw-r--r-- 1 daveshields daveshields 472404 Jun 14 17:48 tbol.s.2

Spitbol is now built by default using the translator from minimal to gas, found in ./gas

You can also build on unix using the nasm assembler:
	make nasm
	make test_nasm

Status Report	19 April 2015	Dave Shields

Since January I've been working on the port to Apple OSX.

OSX currently supports 64-bits and uses a different programming model from that on x85_64. OSX uses 
relative-instruction-pointer (RIP) addressing.

Initial work on modifying the code to use NASM to generate RIP code uncovered a bug in NASM. The NASM folks fixed it
but I soon thereafter generated code that caused NASM to crash.

At this point I decided to use GNU 'as' (GAS) assembler for the port. I forked the code generator and wrote one
that generated gas that got sufficiently along that I decided to complete the support of gas.

By mid-February I realized that, while the gas port looked reasonable, maintaining two different translators would 
be difficult unless I merged them into a single file, using conditional assembly and other methods to allow translation
to two different assembler formats. I also decided to support word size of both 32 and 64 bits.

As an early part of this, I modified the basic 'sanity test' that I use to test any changes.

Things went well until mid-April. While tracking down a bug, I realized that the mid-February 'cleanup' of the
sanity test had been entirely wrong, so that the test was just seeing if the translator could be compiled without
any obvious errors.

Though I had a lot of fun trying to add support for multiple assembler formats, I realized that
	a) things were getting too complicated
	b) it would be *very* difficult to debug

Thus, I changed approach.

The mid-February version that passed sanity test using nasm for both 32 and 64 bits on linux, has been saved
in the directory ./nasm

The last version of the work-done between mid-February and mid-April has been saved in ./gasm.

Work going forward will start from the ./nasm version:
	a) will only support 64 bits from now on
	b) will only generate gas format from now on, first for 64 bit unix, and then for 64-bit osx.

The 32 bit unix version (unix_32) can be built using
	$ cp nasm/* .
	$ make unix_32


V15.01 News (8 January 2015)

Now unable to build 32-bit version on 64-bit system. This problem surfaced only after updating my workstation
to Linux Mint 17.1, which happened to involve installing a new version of gcc.  It should still be possible to build a 32-bit version on a 32-bit system.

Note that this experience confirms the move to using tcc and musl instead of gcc/glibc was the right thing to do.


Unix SPITBOL 15.01 (Jan 2015)

This version adds support for x86_64 so that both 32-bit and 64-bit versions of Spitbol are now available.

Downloads in the traditional form are no longer directly supported, since both "Google Code" and "Github" no
longer provide downloads built by the project.

Spitbol is now available only from its home at 
http://github.com/hardbol/spitbol
If you wish to use git to work with the probject, use:

$ git clone http://github.com/hardbol/spitbol

If you just want to use the system, then select "Download ZIP" from the project home page,
and extract the files from that.

The binaries for 32-bit and 64-bit versions can be found in ./bin/spitbol.m32
and ./bin/spitbol.m64, respectively

This 64-bit version is built by default, as 32-bit processors are no longer widely used.

Three tools are needed to build Spitbol:

	A C compiler
	A C runtime library
	An assembler

Previous versions used gcc and glibc for the compiler and runtime support, 
and the http://www.nasm.us, the nasm assembler.

This version uses http://bellard.org/tcc for the compiler, http://musl-libc.org for the runtime support, 
and continues the use of nasm.

The make file  makefile now uses tcc and musl to build (only) the 64-bit version. To build the 32-bit
version and/or to use gcc, use makefile.gcc.

This version rescinds the support for Unicode added in version 13.05.  
(This caused enough problems that it was deemed best to abandon this experiment.)

Known problems


The SAVE function doesn't work. (This loss of function occurred  whilst adding 64-bit support).
Note that SAVE mode was mainly of interest back in the day when Spitbol was proprietary, 
so that one could distribute a program written in Spitbol without having to disclose the source.

Unix SPITBOl 13.05 (May 2013)

This version includes versions of SPITBOL for both ASCII (8-bit characters) and Unicode (32-bit
characters). The binaries can be found in ./bin/spitbol and ./bin/uspitbol, respectively. 

Unicode SPITBOL


The Unicode version of SPITBOL (spitbol) uses 32-bit characters internally. Character strings 
are converted from UTF-8 encoding to 32-bit characters when input from the command line,
the operating system environment, a pipe, or a file opened in line mode. 
Character strings are converted from 32-bit characters 8-bit characters in UTF-8 format 
when written to a file opened in line mode, a pipe, or when passed as an argument to 
an operating system procedure.

Program source files, which are read by SPITBOL in line mode, may thus contain UTF-8 format
Unicode characters in strings and comments. Identifiers are still restricted to ASCII.

Use the following command to build the Unicode version:

$ make UNICODE=1
 
Overview

SPITBOL is an extremely high performance implementation of the SNOBOL4 language.

It is maintained by Dave Shields (thedaveshields at gmail dot com).

Source files, development versions, as well as other files of interest, can be found at 

	http://github.com/hardbol/spitbol

Downloads are available from http://code.google.com/p/spitbol/downloads/list

Licensing
	
SPITBOL is licensed with the GPLv2 (or later) license:
	COPYING contains a copy of the GPLv2 license.
	COPYING-SAVE-FILE  describes licensing issues for a SPITBOL "save file."
	COPYING-LOAD-MODULES describes licensing issues for a SPITBOL "load module."

Known Problems and Limitations

Load modules are not supported.

Loading of external functions is not supported.

Installing SPITBOL

If you just want to use spitbol without building it, the file
./bin/spitbol contains a statically-linked copy of the 8-bit version of spitbol. 


You can install it in /usr/local/bin/spitbol with the command:

$ sudo make install


Building SPITBOL

You should be able to build SPITBOL on most Unix systems with a processor that implements the x86-32 or x86-64 architecture.


The development work and testing was done using the 32-bit version of linux mint a variant of Ubuntu.


You need the gcc compiler, make, and the netwide assembler, nasm, to build the system. You can install nasm with:

$ sudo apt-get install nasm

The file ./bin/spitbol is the base version of Spitbol that is used to build the system. 

To see if spitbol is working, try the "hello world" program:

$ ./bin/spitbol test/hi.spt



To build the system:

$ make clean
$ make


This should produce the file spitbol. You can test it with the "hello world" program:

$ ./spitbol test/hi.spt


Directory demos contains some demonstration programs.

Directory test contains some small test programs.

To test the system more comprehensively, do:

$ ./test/sanity-test

which verifies that the version of SPITBOL just built is able to translate itself. This test passes if the diff 
	outputs are null.  NEVER replace the file ./bin/spitbol with a newly built spitbol unless you have run the sanity test.

By default, the spitbol binary is linked statically. 
To get a dynamically-linked version, do:

$ make
$ rm spitbol
$ make spitbol-dynamic


Use the command:

$ make install

to install spitbol in /usr/local/bin.


This version of SPITBOL was built using a 32-bit version of Unix. If you are running a 64-bit system, then you may get compile errors when you try to build
the system, in which case you need to install the 32-bit runtime libraries.

You can do this on Mint (and also Ubuntu) with:

$ sudo apt-get install ia32-libs

or, if that doesn't work, try:

$ sudo apt-get install ia32-libs-multiarch


Files

The SPITBOL implementation includes the following files:

asm.spt: Second stage of translator. It translates the token file produced by lex.spt 
	to x86 assembly language
./bin/spitbol: base compiler, used to compile the SPITBOL part of the Minimal translator
./bin/uspitbol: variant of SPITBOL that supports Unicode.

COPYING: license information
COPYING-LOAD-MODULES: license information for SPITBOL load modules
COPYING-SAVE-FILES: license information for SPITBOL save files
./demos: directory with SPITBOL demonstration programs
./docs: directory with pdf version of SNOBOL "Green Book" and MACRO SPITBOL user manual.
lex.spt: First stage of translator. It translates Minimal source to a file of lexemes (tokens)
makefile: make file
map-x32.spt; file used for debugging x32 version
map-x64.spt; file used to debugging x64 version
minimal-reference-manual.html: Minimal Reference Manual
osint: operating system interface files, written in C99.
readme.html: system introduction
README.md: system identification (required by Github for use with Git).
sanity-check: script to run test that compiler can compile itself
s.cnd: selection of Minimal conditional assembly options for spitbol
s.min: Minimal source for SPITBOL
./test: directory with several small tests
32.h: header file for 32-bit version
x32.hdr: file prepended to s.min for compiling 32-bit version
x32.s: assembly language support and interface routines for 32-bit version
x64.h: header file for 64-bit version
x64.hdr: file prepended to s.min for compiling 64-bit version
x64.s: assembly language support and interface routines for 64-bit version
z.spt: prorgram used to insert trace code in generated assembly for debugging.

Notes

This version contains code supporting both 32 and 64 bit implementations of SPITBOL. Only the 32-bit version is complete. The 64-bit version is able to compile lex and asm, but fails compiling the error message processor.

You can build the 64-bit version, on a 64-bit system, with:

$ make ARCH=X32_64


Documentation

The ./docs directory contains:

The SNOBOL4 Programming Language by R. E. Griswold, J.  F. Poage and I. P. Polonski.


MACRO SPITBOL: The High-Performance SNOBOL4 Language by Mark Emmer and Edward Quillen

The SPITBOL project notes with sadness the death of Ed Quillen in June, 2012. To
quote from Mark Emmer's  Acknowledgments in the SPITBOL Manual:

      Ed Quillen, local novelist, political columnist, and SNOBOL
      enthusiast, co-authored this manual. He combined various terse
      SPITBOL documents from other systems with Catspaw's SNOBOL4+
      manual, while providing more complete explanations of some
      concepts. Any observed clarity is this manual is due to Ed,
      while the more opaque portions can be blamed on me.


href=http://www.edquillen.com/ web site and

http://www.denverpost.com/obituaries/ci_20781716/denver-post-columnist-ed-quillen-dies-at-age

Resources

Mark Emmer's SNOBOL4 site: http://snobol4.com

Phil Bunde's SNOBOL site: http://www.snobol4.org

Release History

Unix SPITBOL 13.01 (January 2013)

This version completes the initial port to Linux. Currently only Intel 32-bit (X32) architecture is
supported. There are files for building a 64-bit version, but this version is not able to compile
itself.
