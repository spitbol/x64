;        .title          "spitbol assembly-language to c-language o/s interface"
;        .sbttl          "inter"
; copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
; copyright 2012 David Shields
; 
; this file is part of macro spitbol.
; 
;     macro spitbol is free software: you can redistribute it and/or modify
;     it under the terms of the gnu general public license as published by
;     the free software foundation, either version 3 of the license, or
;     (at your option) any later version.
; 
;     macro spitbol is distributed in the hope that it will be useful,
;     but without any warranty; without even the implied warranty of
;     merchantability or fitness for a particular purpose.  see the
;     gnu general public license for more details.
; 
;     you should have received a copy of the gnu general public license
;     along with macro spitbol.  if not, see <http://www.gnu.org/licenses/>.

%define globals 1

        %include        "mintype.h"
        %include        "os.inc"

	segment	.text
;-----------
;
;       interface routines
;
;       each interface routine takes the following form:
;
;               sysxx   call    ccaller         ; call common interface
;                       dd      zysxx           ; dd of c osint function
;                       db      n               ; offset to instruction after
;                                               ;   last procedure exit
;
;       in an effort to achieve portability of c osint functions, we
;       do not take take advantage of any "internal" to "external"
;       transformation of names by c compilers.  so, a c osint function
;       representing sysxx is named _zysxx.  this renaming should satisfy
;       all c compilers.
;
;       important:  one interface routine, sysfc, is passed arguments on
;       the stack.  these items are removed from the stack before calling
;       ccaller, as they are not needed by this implementation.
;
;
  
; define interface routines for calling procedures written in c from
; within the minimal code.
 
	%macro	mtoc	2
	global	%1
	extern	%2
%1:
	%endmacro

	mtoc	sysax,zysax
	call	ccaller
	db	0

	mtoc	sysbs,zysbs
	call	ccaller
	db	6

	mtoc	sysbx,zysbx
	mov	[reg_xs],esp
	call	ccaller
	db	0

%if setreal == 1
	mtoc	syscr,zyscr
	call	ccaller
	db	0
%endif
	mtoc	sysdc,zysdc
	call	ccaller
	db	0

	mtoc	sysdm,zysdm
	call	ccaller
	db	0

	mtoc	sysdt,zysdt
	call	ccaller
	db	0

	mtoc	sysea,zysea
	call	ccaller
	db	2

	mtoc	sysef,zysef
	call	ccaller
	db	6

	mtoc	sysej,zysej
	call	ccaller
	db	0

	mtoc	sysem,zysem
	call	ccaller
	db	0

	
	mtoc	sysen,zysen
	call	ccaller
	db	0

	mtoc	sysep,zysep
	call	ccaller
	db	6

	mtoc	sysex,zysex
	mov	[reg_xs],esp
	call	ccaller
	db	6
 
	mtoc	sysfc,zysfc
	pop     eax             ; <<<<remove stacked scblk>>>>
	lea	esp,[esp+edx*4]
	push	eax
	call	ccaller
	db	4

	mtoc	sysgc,zysgc
	call	ccaller
	db	0

	mtoc	syshs,zyshs
	mov	[reg_xs],esp
	call	ccaller
	db	16

	mtoc	sysid,zysid
	call	ccaller
	db	0

	mtoc	sysif,zysif
	call	ccaller
	db	2

	mtoc	sysil,zysil
	call	ccaller
	db	0

	mtoc	sysin,zysin
	call	ccaller
	db	6

	mtoc	sysio,zysio
	call	ccaller
	db	4

	mtoc	sysld,zysld
	call	ccaller
	db	0

	mtoc	sysmm,zysmm
	call	ccaller
	db	0

	mtoc	sysmx,zysmx
	call	ccaller
	db	0

	mtoc	sysou,zysou
	call	ccaller
	db	4

	mtoc	syspi,zyspi
	call	ccaller
	db	2

	mtoc	syspl,zyspl
	call	ccaller
	db	6

	mtoc	syspp,zyspp
	call	ccaller
	db	0

	mtoc	syspr,zyspr
	call	ccaller
	db	2

	mtoc	sysrd,zysrd
	call	ccaller
	db	2

	mtoc	sysri,zysri
	call	ccaller
	db	2

	mtoc	sysrw,zysrw
	call	ccaller
	db	6

	mtoc	sysst,zysst
	call	ccaller
	db	10

	mtoc	systm,zystm
	call	ccaller
	db	0

	mtoc	systt,zystt
	call	ccaller
	db	0

	mtoc	sysul,zysul
	call	ccaller
	db	0

        
	mtoc	sysxi,zysxi
	mov	[reg_xs],esp
	call	ccaller
	db	4
