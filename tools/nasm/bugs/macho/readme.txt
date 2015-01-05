
Work on porting Spitbol to osx (which is 64 bit) uncovered a problem in addressing. osx uses 'rip addressing' (relative
to instruction pointer), so that 'rel' prefixes must be generated for memory references in the generated assembly
code. This has been done. However, using nasm to compile the result results in nasm failing with a segmentation fault.
The files needed to demonstrate this problem can be found in tools/nasm/bugs/macho.

This directory can be used to demonstrate the bug. Try:

	nasm -fmacho64 -os.o s.s

This version of s.s has 'rel' directives (via macro REL) in the appropriate instructions.

The bug also occured when the 'default rel' instruction was used.


dave shields
thedaveshields@gmail.com

The bug has been with filed with nasm's bugzilla tracking system, as bug 3392298,

4 Jan 2015

