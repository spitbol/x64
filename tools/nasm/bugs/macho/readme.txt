This directory can be used to demonstrate a bug in nasm 2.11.96 that came about trying to 
compile spitbol for 64-bits for osx (macho format).

The problem is that nasm terminates with a segmantation fault.


To repeat the problem: try
	
	nasm -fmacho64 -os.o s.s

This version of s.s has 'rel' directives (via macro REL) in the appropriate instructions.

The bug also occurs if the 'default rel' instruction is used.


dave shields
thedaveshields@gmail.com

4 Jan 2015

