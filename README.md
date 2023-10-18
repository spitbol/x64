# SPITBOL is an extremely high performance implementation of the SNOBOL4 language
that brings raw power and speed to non-numeric computation.

SPITBOL is currently only available for 64-bit x86_64 processors running Unix
like systems.

The latest version of SPITBOL can be found at
[github.com/spitbol/x64](http://github.com/spitbol/x64).

For comments, suggestions, and bug reports please open an issue in the github
repository.

## Unix SPITBOL V4.0c (Oct 2023)

### Updates:

* Set default for &anchor to 0
* SIGQUIT and SIGHUP will cancel spitbol
* Set max number of floating point digits on output to 16
  (e.g. 0.1234567890123456) plus 3 digits for any exponent.
* Extended test suite to include more math related tests.
* Quick install instructions in INSTALL.md

### Bugs fixed:

* Fix the end of run summary for regenerations statics to use the proper message
  text
* Fix overflow detection for both integer and floating point
* Mark stack as non-executable (needed for hardened systems)
* Fix incorrect error handling within eval
* Fix using caret '^' for exponents (e.g. 2 ^ 2 => 4)

### Internal changes:

* Using more x86_64 registers for the internal workings of the minimal
  instructions.
    * R12 used for IA (integer accumulator)
    * XMM12 used for RA (real accumulator)
    * R13 used for CP
    * R10 and R11 are used as work registers.
    * XMM0, XMM1 are used as work registers for floating point
    * MXCSR used to manage floating point operations and detecting floating
      point errors

* Generate assembly code instead of calling C routines for some math and
  arithmetic operations.

* Use 'test' instead of 'or' to check register values
* Use 'xor' to zero registers

* Use sigaction instead of signal.

* Eliminate some of the internal macros and just generate the assembly code
  directly.  Use internal helper routines to handle some of the larger generated
  code blocks.

* General code formatting cleanup.
    * Using spaces instead of tab characters
    * Use standard C function declarations and definitions.
    * Reindent all C code using clangd lsp (see osint/.clang-format for options
      used)
    * Makefile cleanup

* Fix parsing source linenumber in asm.sbl
* Fix ucase and letters in asm.sbl
* Clean up label generation in asm.sbl
* Explicitly set REL and BITS64 in generated assembly code

The above needs more general testing.  Specific areas for testing are:

* Floating point operations and functions
* Integer "boundary" conditions

Thanks to Jeff Cooper for feedback, performing testing and providing additional
tests for arithmetic/math functions.

Note that the changes associated with the development release SPITBOL V4.0b
have been reworked into this release.

### Wish list items:

* Detection/and use of NAN and +/- INF for floating point.

## Unix SPITBOL V4.0b (Jun 2023)

Development release (see development branch in git repository)

## Unix SPITBOL V4.0a (Feb 2023)

### Language Changes

Version 4.0a contains minor bug fixes and clarifications

Version 4.0 differs from previous versions of SPITBOL as follows:

*   The initial value of &ANCHOR is one, not null as in prior versions.

*   The initial value of &TRIM is one, not null as in prior versions.

The manual has always suggested setting &ANCHOR and &TRIM to non-null values for more efficient searching.

Prior versions also folded cases by default, so that variables differing only in case, such as
'Var' and 'VAR' were treated as the same variable. Though this may have made sense when
lower case terminals and printers were just coming into use, those days are long gone.

The compiler option '-F' will enable folded cases (&CASE set to one).

## Known Problems and Limitations

The SAVE function doesn't work. (This loss of function occurred whilst adding 64-bit support).
Note that SAVE mode was mainly of interest back in the day when Spitbol was proprietary,
so that one could distribute a program written in Spitbol without having to disclose the source.

Load modules are not supported.

Loading of external functions is not supported.

## Installing SPITBOL

If you just want to use SPITBOL without building it, the file `./bin/sbl`
contains a statically-linked copy of the 64-bit version of spitbol.

You can install it in `/usr/local/bin/spitbol` with the command:

```
    $ sudo make install
```
## Required Programs

Three tools are needed to build Spitbol:

  1. Posix C compiler
  2. Standard C runtime library
  3. NASM assembler

SPITBOL uses the gcc compiler to compile C source files.

SPITBOL requires NASM, the Netwide ASseMbler: [nasm](http://www.nasm.us) to
assemble the generated x86_64 machine code.


## Building SPITBOL

You should be able to build SPITBOL on most Unix systems.

The file `./bin/sbl` is the base version of Spitbol that is used to build the system.

To see if spitbol is working, try the "hello world" program:

```
    $ ./bin/sbl test/hello.sbl
```

To build the system:


```
    $ make clean
    $ make
```

This should produce the file `./sbl`. You can test it with the "hello world"
program:


   ```
    $ ./sbl test/hello.sbl
   ```

To verify that the spitbol is building itself correctly you can run:

```
    $ ./sanity-check
```

This shell script should be run after bulding the system. Since part of the SPITBOL translator is written
in SPITBOL, it is essential to make sure that a new build of SPITBOL is able to build the system. The test
uses successive versions to build the system three times; first to see if the new version runs, second to see the
results of using it to build the system, and finally building the system again to see that none of the essential files were changed.

Three builds are needed, since it possible the new version contains an optimization or other code change whose effects will only
be tested in the final build.

Additional test programs can be found in the directory `./test`.

NEVER replace the file `./bin/sbl` with a newly built `spitbol` without first running and checking the results of
running the sanity test.  There's a good reason it has that name.

Use the command below to install `spitbol` in `/usr/local/bin`.

```
    $ make install
```

## Building from the bootstrap

A pre-built spitbol executable is provided in ./bin/sbl.

If this executable fails, a bootstrap is provided.

```
    $ make bootsbl
    $ make BASEBOL=./bootsbl spitbol
```


## Files

The SPITBOL implementation includes the following files:

### Minimal source

The principal source file is `sbl.min`.

### Minimal translation

`lex.sbl` is the first state of compilation. It converts the source file into a sequence of lexical tokens.

The lexcal scan is followed by running `asm.sbl` to translate the tokens into machine code for the target machine.

The program `err.sbl` is used to produce a compact representation of the error messages contained in the Minimal source.

`./bin/sbl` is the statically linked binary for SPITBOL. You should be able to run in on any 64-bit x86_64 processor
using Unix.


### OSINT - Operating System Interface

The directory `osint` contains the source files written in C99 that provide an interface to the Unix
environment.

### Assembly Language Support

The files  `int.h`, `int.dcl`, and `int.asm` contain that part of the runtime that cannot be expressed in C and
so is written in assembler.

### Instruction Tracing

The file `z.sbl` can be used to insert trace code in generated assembly for debugging. This is not required to
build this system, and was last used in 2009 as part of the port of SPITBOL to Linux.

### Demonstration Programs

Some demonstration programs can be found in the directory `./demos`.

## Documentation

The documentation files for SPITBOL can be found in the repository:
http://github.com/spitbol/spitbol-docs.

## Additional Resources

Mark Emmer's SNOBOL4 site: [snobol4.com](http://snobol4.com)

Phil Budne's SNOBOL site: [www.regressive.org/snobol4](https://www.regressive.org/snobol4/)

## Maintainer notes:

Before commiting changes perform the following checks:

```
    ./sanity-check
    make checkboot
```

If checkboot shows differences

```
    make makeboot
```

Finally create the binary executable for distribution
```
    make bininst
```

