# Quick install instructions

## Installing the pre-built binary

The release tar file contains a pre-built binary in the bin directory.

To install the pre-built file:

    make destprefix={destprefix} install

Where {destprefix} defaults to /usr/local

This installs:

* {destprefix}/bin/spitbol
* {destprefix}/share/spitbol/{demo files}
* {destprefix}/man/man1/spitbol.1

## Rebuilding spitbol from source

### Requirements:

* gcc compiler (other compilers might work, but they have not been tested)
* standard glibc library (review the C code in osint.c)
* nasm
* make

### The spitbol build steps

The source code from spitbol, `sbl.min`, is written in `minimal` which is an assembly language
for an abstract architecture.  There is a `minimal` to x86_64 assembly language (nasm format)
translator `lex.sbl, asm.sbl` and `err.sbl` which are written in spitbol.  In order to rebuild
from the minimal source requires that an existing spitbol compiler is available.

There are 2 methods to rebuild the spitbol binary from source

#### Using the prebuilt binary, bin/sbl

From the top level in the source directory, the `spitbol` target in the Makefile will use the
prebuilt spitbol compiler that is in the bin directory.

    make spitbol

This will create a sbl binary in the top level of the source directory

#### Builting without an available spitbol compiler

If a spitbol compiler is not available, pre-translated assembly files are provided in
in the bootstrap directory.

From the top level in the source directory, the `bootsbl` target in the Makefile will
use the pre-translated assembly files.

    make bootsbl

This produces a bootsbl binary that can be used to re-build the source

    make BASEBOL=./bootsbl spitbol

This will create a sbl file in the top level of the source directory.

### Make targets and options

The following are the make targets:
<dl compact>
<dt>sbl</dt>
<dd>is the primary build target and builds the sbl binary. Requires an existing spitbol compiler</dd>

<dt>spitbol</dt>
<dd>an alias for the sbl target</dd>

<dt>bininst</dt>
<dd>copies sbl to bin/sbl</dd>

<dt>install</dt>
<dd>installs the spitbol compiler (from bin/sbl), the demo source and the man page to
   the {destprefix} directories</dd>

<dt>bootsbl</dt>
<dd>builds the bootsbl binary just nasm and gcc.  Does not require an existing spitbol compiler</dd>

<dt>checkboot</dt>
<dd>Developer target, verifies that the source files in bootstrap match the output of the
   `minimal` to assembly conversion</dd>

<dt>makeboot</dt>
<dd>Copies the output of the `minimal` translation to the bootstrap directory</dd>

<dt>clean</dt>
<dd>cleans built items from the source directory</dd>
</dl>

The following make definition options that are used:
<dl compact>
	<dt>destprefix</dt><dd>target directory where spitbol, the demo files and the man page will be installed, defaults to destprefix=/usr/local</dd>
	<dt>debug</dt><dd>if set to non-zero, will build spitbol with debugging information for gdb, defaults to debug=0</dd>
	<dt>BASEBOL</dt><dd>path to the spitbol compiler used during the build process, defaults to BASEBOL=./bin/sbl</dd>
</dl>