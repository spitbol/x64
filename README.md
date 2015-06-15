spitbol
=======

Efficient implementation of the SNOBOL4 programming language.

Executable binaries:

./bin/sbl_osx		OSX SPITBOL	(64 bits)

./bin/sbl_unix		Unix version	(64 bits)

./bin/sbl_unix_32	Unix version	(32 bits)

Documentation:

./docs/green-book.pdf		The SNOBOL4 Programming Language, Griswold, et. al.

./docs/spitbol-manual.pdf	SPITBOL User Manual, Emmer and Quillen


./demos
	demonstration programs from the SPITBOL User Manual


SPITBOL is licensed under the GPL (v2 or later) license. All code needed to build the system is included in
this repository.

To build spitbol (./sbl):

OSX:

	make osx

	make test_osx

Unix:

	make unix

	make test_unix

See readme.txt for instructions on interpreting the test output.

