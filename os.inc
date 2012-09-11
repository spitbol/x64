;   file:  osint.inc            version:  01.00
;   -------------------------------------------
;
;   this header file defines the interface between the macro spitbol compiler
;   and any assembly-language osint modules.
;   communication between the two is handled via a set of global variables
;   defined as externals below.

;  copyright 1991 robert goldberg and catspaw, inc.
;  copyright 2012 david shields

;   set up externals for all the compiler's registers.

	extern	atlin
	extern	nlines

%define TRACE
%ifdef TRACE
	%macro	atline 1
	mov	dword [nlines],%1
	mov	ebp,dword [save_cp]
	mov	ecx,dword [save_wa]
	mov	ebx,dword [save_wb]
	mov	edx,dword [save_wc]
	mov	esi,dword [save_xl]
	mov	edi,dword [save_xr]
	mov	esp,dword [save_xs]
	call	atlin
	mov	dword [save_cp],ebp
	mov	dword [save_wa],ecx
	mov	dword [save_wb],ebx
	mov	dword [save_wc],edx
	mov	dword [save_xl],esi
	mov	dword [save_xr],edi
	mov	dword [save_xs],esp
	%endmacro
%endif

	segment	.data
%ifndef globals
	extern		reg_cp
	extern		reg_wa
	extern		reg_wb
	extern		reg_wc
	extern		reg_xr
	extern		reg_xl
	extern		reg_xs
	extern		reg_ia
%endif


;   return values to take exit n from interface

exit_1 equ      0
exit_2 equ      4
exit_3 equ      8
exit_4 equ      12
exit_5 equ      16
exit_6 equ      20
exit_7 equ      24
exit_8 equ      28
exit_9 equ      32

;    return value to do a normal return from interface.

normal_return  equ      -1

	segment	.text

;       function and macro to call into minimal code.
;       the argument is an ordinal number defined below.

;   ordinals for minimal calls from assembly language.
;
;   the order of entries here must correspond to the order of
;   calltab entries in the inter assembly language module.
;
relaj_callid  equ      0
relcr_callid  equ      1
reloc_callid  equ      2
alloc_callid  equ      3
alocs_callid  equ      4
alost_callid  equ      5
blkln_callid  equ      6
insta_callid  equ      7
rstrt_callid  equ      8
start_callid  equ      9
filnm_callid  equ      10
dtype_callid  equ      11
enevs_callid  equ      12
engts_callid  equ      13

;       function and macro to get/set value from/to minimal dataspace.
;       the argument is an ordinal number defined below.
;       the macro getoff returns the address of the value.
%if direct                                  ; [[

	segment	.data
%else                                       ; ][
%ifndef globals
;*DS TODO	extern		minoff
%endif
%macro          getoff 2
%ifnidn %1,eax
	push		eax
%endif
        push            %2
	callc		minoff,4
%ifnidn %1,eax
        mov             %1,eax
	pop		eax
%endif
%endmacro

;   ordinals for transferring minimal values to/from assembly language.
;
;   the order of entries here must correspond to the order of
;   valtab entries in the inter assembly language module.
;
;   the structure vords and the access macro is merely a device to
;   produce an enumeration similar to an enum structure to c.
;
;        struc   vords
%endif
	segment	.text
%ifndef globals
	%include	"extern.h"
%endif
