# SPITBOL x64

SPITBOL x64 is an efficient implementation of the SNOBOL4 programming language for the 32-bit x32 (i386) architecture.
 It is written in a portable assembly
language called MINIMAL, with runtime support provided by code written in C.

## Executable binaries:
-------------------

Ready-to-run binary executables can be found in
the directory ./bin:

* OSX SPITBOL	(64 bits)	`./bin/sbl_osx`	

* Unix version	(64 bits)	`./bin/sbl_unix`

* Unix version	(32 bits)	`./bin/sbl_unix_32` 

## Documentation:

Directory ./docs contains documentation:

* The SNOBOL4 Programming Language, Griswold, et. al.  `./docs/green-book.pdf`	

* SPITBOL User Manual, Emmer and Quillen	`./docs/spitbol-manual.pdf`	

* Minimal Specification  ./docs/spitbol-reference-manual.md

## Demonstration Programs

Demonstration programs from the SPITBOL User Manual can be found in `./demos`

SPITBOL is licensed under the GPL (v2 or later) license. All code needed to build the system is included in
this repository.

## Building SPITBOL

To build spitbol (`./sbl`):

OSX:

```
	make osx
	make test_osx
```

Unix:

```
	make unix
	make test_unix
```

See `readme.txt` for instructions on interpreting the test output.


