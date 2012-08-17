%ifndef systype_included
%define systype_included        1
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

; configuration information for inter.s
;
setreal equ     0       ; ds review later why this is needed 6/30
linux   equ     1
winnt   equ     0
_masm_  equ     0

;        segment declarations macros
;


; structure definition macros
;
;        %macro  struct 1
;        struc  %1
;%endmacro

        %macro  ends 1
        dseg_
%endmacro

; define how data locations in the minimal code are accessed from
; assembly-language and c routines.  "direct" is non-zero to make
; the symbols public for direct access, zero to have access via
; a table of pointers and the minadr procedure.
;
#define direct 1
direct equ 1

; define how floating point results are returned from a function
; (either in st(0) or in edx:eax.
fretst0 equ 1
freteax equ 0

%macro  address 1
        dd   %1
%endmacro
%ifnmacro ext
%macro  ext 2
        extern %1
%endmacro
%endif

%ifnmacro cext
%macro  cext 1
        extern     %1
%endmacro
%endif

;        %macro  def 3
;%1     %2      %3
;%endmacro


%macro  proc 2
%1:
%endmacro

%macro  endp 1
%endmacro

%macro  cproc 2
%1:
%endmacro


; call c function.  intel follows standard c conventions, and
; caller pops arguments.
%macro  callc 2
        call    %1
%if %2
        add     esp,%2
%endif
%endmacro

; intel runs in one flat segment.  far calls are the same as near calls.
%macro  callfar 2
        extern     %1
        callc   %1,%2
%endmacro

; return from an assembly-language function that will be called by c.
; caller pops arguments
%macro  retc 1
        ret
%endmacro
%endif
