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
; list below produced by program test/equ.spt.
; The order of entries here must agree with order in inter.s
XS; assembly language module.

GBCNT equ  0
HEADV equ  1
MXLEN equ  2
STAGE equ  3
TIMSX equ  4
DNAMB equ  5
DNAMP equ  6
STATE equ  7
B_EFC equ  8
B_ICL equ  9
B_SCL equ 10
B_VCT equ 11
B_XNT equ 12
B_XRT equ 13
STBAS equ 14
STATB equ 15
POLCT equ 16
TYPET equ 17
DFFNC equ 18
LOWSPMIN equ 19
FLPRT equ 20
FLPTR equ 21
GTCEF equ 22
HSHTB equ 23
PMHBS equ 24
R_FCB equ 25
C_AAA equ 26
C_YYY equ 27
G_AAA equ 28
W_YYY equ 29
S_AAA equ 30
S_YYY equ 31
R_COD equ 32
KVSTN equ 33
KVDMP equ 34
KVFTR equ 35
KVCOM equ 36
KVPFL equ 37
CSWFL equ 38
STMCS equ 39
STMCT equ 40
TICBLK equ 41
TSCBLK equ 42
ID1 equ 43
ID2BLK equ 44
INPBUF equ 45
TTYBUF equ 46
B_RCL equ 47
