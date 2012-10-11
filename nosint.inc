;   file:  osint.inc            version:  01.00
;   -------------------------------------------
;
;   this header file defines the interface between the macro spitbol compiler
;   and any assembly-language osint modules.
;   communication between the two is handled via a set of global variables
;   defined as externals below.

;  copyright 1991 robert goldberg and catspaw, inc.

;   set up externals for all the compiler's registers.

        dseg_
%ifndef globals
;	extern		reg_cp
;	extern		reg_wa
;	extern		reg_wb
;	extern		reg_wc
;	extern		reg_xr
;	extern		reg_xl
;	extern		reg_xs
;	extern		reg_ia
%endif
        dsegend_

;   macros to load a compiler register into a machine register
	%macro		atline 1
	mov	dword [nlines],%1
	call	atlin
	%endmacro

        %macro          get_cp 1
        mov             %1, dword [reg_cp]
        %endmacro

        %macro          get_ia 1
        mov             %1, dword [reg_ia]
        %endmacro

        %macro          get_wa 1
        mov             %1, dword [reg_wa]
        %endmacro

        %macro          get_wb 1
        mov             %1, dword [reg_wb]
        %endmacro

        %macro          get_wc 1
        mov             %1, dword [reg_wc]
        %endmacro

        %macro          get_xr 1
        mov             %1, dword [reg_xr]
        %endmacro

        %macro          get_xl 1
        mov             %1, dword [reg_xl]
        %endmacro

        %macro          get_xs 1
        mov             %1, dword [reg_xs]
        %endmacro


;   macros to store a machine register into a compiler register.

        %macro          set_cp  1
        mov             dword [reg_cp], %1
        %endmacro

        %macro          set_ia 1
        mov             dword [reg_ia], %1
        %endmacro

        %macro          set_wa 1
        mov             dword [reg_wa], %1
        %endmacro

        %macro          set_wb 1
        mov             dword [reg_wb], %1
        %endmacro

        %macro          set_wc 1
        mov             dword [reg_wc], %1
        %endmacro

        %macro          set_xr 1
        mov             dword [reg_xr], %1
        %endmacro

        %macro          set_xl 1
        mov             dword [reg_xl], %1
        %endmacro

        %macro          set_xs 1
        mov             dword [reg_xs], %1
        %endmacro


;   return values to take exit n from interface

%define	exit_1         0
%define	exit_2         4
%define	exit_3         8
%define	exit_4         12
%define	exit_5         16
%define	exit_6         20
%define	exit_7         24
%define	exit_8         28
%define	exit_9         32
;    return value to do a normal return from interface.

%define normal_return   -1

        cseg_

;       function and macro to call into minimal code.
;       the argument is an ordinal number defined below.
;%ifndef globals
;	extern		minimal
;%endif
        %macro          minimal 1
        push            %1
	callc		call_minimal,4
        %endmacro

;   ordinals for minimal calls from assembly language.
;
;   the order of entries here must correspond to the order of
;   calltab entries in the inter assembly language module.
;
%define  relaj          0
%define  relcr          1
%define  reloc          2
%define  alloc          3
%define  alocs          4
%define  alost          5
%define  blkln          6
%define  insta          7
%define  rstrt          8
%define  start          9
%define  filnm          10
%define  dtype          11
%define  enevs          12
%define  engts          13

;       function and macro to get/set value from/to minimal dataspace.
;       the argument is an ordinal number defined below.
;       the macro getoff returns the address of the value.
%if direct                                  ; [[
        %macro          getoff 2
	lea		%1,[%2]
        %endmacro

        %macro          getmin 2
        mov             %1,%2
        %endmacro

        %macro          setmin 2
	mov		dword [%1],%2
        %endmacro

        %macro          setminr 2
	mov		dword [%1],%2
        %endmacro

        %macro          access 1
        ext             %1,dword
        %endmacro

        %macro          access2 1
%ifndef globals
        ext            %1,dword
%endif
        %endmacro

        dseg_
%else                                       ; ][
%ifndef globals
	ext		minoff,near
%endif
        %macro          getoff 2
%ifidn %1,eax
%else
	push	dave
	push		eax
%endif
        push            %2
	callc		minoff,4
%ifidn %1,eax
%else
        mov             %1,eax
	pop		eax
%endif
        %endmacro

        %macro          getmin 2
%ifidn	%1,eax
%else
	push		eax
%endif
        push            %2
	callc		minoff,4
        mov             %1,dword [eax]
%ifidn %1,eax
%else
	pop		eax
%endif
        %endmacro

        %macro          setmin 2
%ifidn %1,eax
	push		eax
%endif
        push            offset %1
	callc		minoff,4
%ifidn %2,eax
	pop		dword [eax]
%else
        mov             dword [eax],%2
%endif
        %endmacro

        %macro          access 1
%1:  db              0
        %endmacro

        %macro          access2 1
%1:  db              0
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
%endif                                      ; ]]

;        %define   gbcnt 1
;        %define   headv 2
;        %define   mxlen 3
;        %define   stage 4
;        %define   timsx 5
;        %define   dnamb 6
;        %define   dnamp 7
;        %define   state 8
;        %define   b_efc 9
;        %define   b_icl 10
;        %define   b_scl 11
;        %define   b_vct 12
;        %define   b_xnt 13
;        %define   b_xrt 14
;        %define   stbas 15
;        %define   statb 16
;        %define   polct 17
;        %define   typet 18
;        %define   dffnc 19
;        %define   lowspmin 20
;        %define   flprt 21
;        %define   flptr 22
;        %define   gtcef 23
;        %define   hshtb 24
;        %define   pmhbs 25
;        %define   r_fcb 26
;        %define   c_aaa 27
;        %define   c_yyy 28
;        %define   g_aaa 29
;        %define   w_yyy 30
;        %define   s_aaa 31
;        %define   s_yyy 32
;        %define   r_cod 33
;        %define   kvstn 34
;        %define   kvdmp 35
;        %define   kvftr 36
;        %define   kvcom 37
;        %define   kvpfl 38
;        %define   cswfl 39
;        %define   stmcs 40
;        %define   stmct 41
;        %define   ticblk   42
;        %define   tscblk   43
;        %define   id1   44
;        %define   id2blk   45
;        %define   inpbuf   46
;        %define   ttybuf   47
;        %define   b_rcl   48
;
%if direct
        dsegend_
%else
;        ends    vords
%endif

        csegend_
