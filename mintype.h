%ifndef systype_included
%define systype_included        1
; 
; This file is part of Macro SPITBOL.
; 
;     Macro SPITBOL is free software: you can redistribute it and/or modify
;     it under the terms of the GNU General Public License as published by
;     the Free Software Foundation, either version 3 of the License, or
;     (at your option) any later version.
; 
;     Macro SPITBOL is distributed in the hope that it will be useful,
;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;     GNU General Public License for more details.
; 
;     You should have received a copy of the GNU General Public License
;     along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.

; configuration information for inter.s
;
SETREAL equ     0       ; DS review later why this is needed 6/30
linux   equ     1
winnt   equ     0
_MASM_  equ     0

;        Segment Declarations Macros
;


; Structure definition macros
;
;        %macro  struct 1
;        struc  %1
;%endmacro

        %macro  ends 1
        DSeg_
%endmacro

; define how data locations in the Minimal code are accessed from
; assembly-language and C routines.  "direct" is non-zero to make
; the symbols public for direct access, zero to have access via
; a table of pointers and the minadr procedure.
;
direct equ 1

; define how floating point results are returned from a function
; (either in ST(0) or in EDX:EAX.
fretst0 equ 1
freteax equ 0

; Macros defining whether a leading underscore is required for public Minimal
; names that will be referenced from C.
;
underscore equ 0
%macro  address 1
        dd   %1
%endmacro
%macro  ext 2
        extern %1:%2
%endmacro

%macro  cext 2
        extern     %1,%2
%endmacro

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


; Call C function.  Intel follows standard C conventions, and
; caller pops arguments.
%macro  callc 2
        call    %1
%if %2
        add     esp,%2
%endif
%endmacro

; Intel runs in one flat segment.  Far calls are the same as near calls.
%macro  callfar 2
        extern     %1
        callc   %1,%2
%endmacro

; Return from an assembly-language function that will be called by C.
; Caller pops arguments
%macro  retc 1
        ret
%endmacro
%endif
