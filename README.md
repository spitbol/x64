# SPITBOL x64

SPITBOL x64 is an efficient implementation of the SNOBOL4 programming language for the 64-bit architecture x86-64 (amd64), using the Unix system
and its derivatives, including Linux and OSX.

It is written in a portable assembly language called MINIMAL, 
with runtime support provided by code written in C.

## Executable binaries

Ready-to-run binary executables can be found in
the directory `./bin`.

* OSX SPITBOL: `./bin/sbl_osx`	

* Unix SPITBOL: `./bin/sbl_unix`

## Sample Program

Here is a simple SPITBOL calculator that reads each line
from standard input, tries to evalute it, and writes the result
to standard output. The code can be found in `./demos/calc.spt`
Note, for example, that `23+4` is a string, while 
`23 + 4` is an integer (27).

```
*    A simple calculator in SPITBOL

*    Copyright 2015 David Shields

*    Read lines from standard input, evalute each as
*    an expression, and write the result and its datatype
*    to standard output.

    			:(loop)
error
*   Here if error, so print error message and continue
    output = 'failure evaluating'
    output = '**  '  line 
loop
    output = 'enter expression to evaluate:'
    line = input			:f(end)
    result = eval(line)		:f(error)
    output = result 
    output = datatype(result)	:(loop)
end
```

## Documentation

Directory ./docs contains documentation:

* The SNOBOL4 Programming Language, Griswold, et. al.  `./docs/green-book.pdf`	

This is the classic introduction to SNOBOL4, known affectionately
to SNOBOL enthusiasts as "The Green Book," due to its bright green
cover.

* SPITBOL User Manual, Emmer and Quillen	`./docs/spitbol-manual.pdf`	

This is a comprehensive manual for SPITBOL, including many examples and
tutorials.

* Minimal Specification  ./docs/spitbol-reference-manual.md

This document describes the portable assembly language used to
implement SPITBOL. 

## Demonstration Programs

Demonstration programs from the SPITBOL User Manual can be found in `./demos`

## Building SPITBOL

To build spitbol (`./sbl`)

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

# License

SPITBOL is licensed under the GPL (v2 or later) license.
All code needed to build the system is included in
this repository.

