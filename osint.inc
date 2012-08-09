#   file:  osint.inc            version:  01.00
#   -------------------------------------------
#
#   this header file defines the interface between the macro spitbol compiler
#   and any assembly-language osint modules.
#   communication between the two is handled via a set of global variables
#   defined as externals below.

#  copyright 1991 robert goldberg and catspaw, inc.

#   set up externals for all the compiler's registers.

        dseg_
.ifndef globals
	ext		reg_cp,dword
	ext		reg_wa,dword
	ext		reg_wb,dword
	ext		reg_wc,dword
	ext		reg_xr,dword
	ext		reg_xl,dword
	ext		reg_xs,dword
	ext		reg_ia,dword
.endif
        dsegend_

#   macros to load a compiler register into a machine register

        .macro          get_cp reg
        mov             \reg, reg_cp
        .endm

        .macro          get_ia reg
        mov             \reg, reg_ia
        .endm

        .macro          get_wa reg
        mov             \reg, reg_wa
        .endm

        .macro          get_wb reg
        mov             \reg, reg_wb
        .endm

        .macro          get_wc reg
        mov             \reg, reg_wc
        .endm

        .macro          get_xr reg
        mov             \reg, reg_xr
        .endm

        .macro          get_xl reg
        mov             \reg, reg_xl
        .endm

        .macro          get_xs reg
        mov             \reg, reg_xs
        .endm


#   macros to store a machine register into a compiler register.

        .macro          set_cp val
        mov             reg_cp, \val
        .endm

        .macro          set_ia val
        mov             reg_ia, \val
        .endm

        .macro          set_wa val
        mov             reg_wa, \val
        .endm

        .macro          set_wb val
        mov             reg_wb, \val
        .endm

        .macro          vset_wc val
        mov             reg_wc, \val
        .endm

        .macro          set_xr val
        mov             reg_xr, \val
        .endm

        .macro          set_xl val
        mov             reg_xl, \val
        .endm

        .macro          set_xs val
        mov             reg_xs, \val
        .endm


#   return values to take exit n from interface

exit_1  =       0
exit_2  =       4
exit_3  =       8
exit_4  =       12
exit_5  =       16
exit_6  =       20
exit_7  =       24
exit_8  =       28
exit_9  =       32

#    return value to do a normal return from interface.

normal_return   =       -1

        cseg_

#       function and macro to call into minimal code.
#       the argument is an ordinal number defined below.
.ifndef globals
	ext		minimal,near
.endif
        .macro          minimal callno
        push            offset \callno
	callc		minimal,4
        .endm

#   ordinals for minimal calls from assembly language.
#
#   the order of entries here must correspond to the order of
#   calltab entries in the inter assembly language module.
#
relaj   =       0
relcr   =       1
reloc   =       2
alloc   =       3
alocs   =       4
alost   =       5
blkln   =       6
insta   =       7
rstrt   =       8
start   =       9
filnm   =       10
dtype   =       11
enevs   =       12
engts   =       13

#       function and macro to get/set value from/to minimal dataspace.
#       the argument is an ordinal number defined below.
#       the macro getoff returns the address of the value.
.if direct                                  # [[
        .macro          getoff reg,valno
.ifne underscore
        lea             \reg,_\valno
.else
        lea             \reg,\valno
.endif
        .endm

        .macro          getmin reg,valno
.ifne underscore
        mov             \reg,_\valno
.else
        mov             \reg,\valno
.endif
        .endm

        .macro          setmin valno,value
.ifne underscore
        mov             _\valno,dword ptr \value
.else
        mov             \valno,dword ptr \value
.endif
        .endm

        .macro          setminr valno,value
.ifne underscore
        mov             _\valno,\value
.else
        mov             \valno,\value
.endif
        .endm

        .macro          access name
        ext             \name,dword
        .endm

        .macro          access2 name
.ifndef globals
        ext            \name,dword
.endif
        .endm

        dseg_
.else                                       # ][
.ifndef globals
	ext		minoff,near
.endif
        .macro          getoff reg,valno
.ifnc \reg,eax
	push		eax
.endif
        push            offset \valno
	callc		minoff,4
.ifnc \reg,eax
        mov             \reg,eax
	pop		eax
.endif
        .endm

        .macro          getmin reg,valno
.ifnc \reg,eax
	push		eax
.endif
        push            offset \valno
	callc		minoff,4
        mov             \reg,[eax]
.ifnc \reg,eax
	pop		eax
.endif
        .endm

        .macro          setmin valno,value
.ifc \value,eax
	push		eax
.endif
        push            offset \valno
	callc		minoff,4
.ifc \value,eax
	pop		[eax]
.else
        mov             [eax],\value
.endif
        .endm

        .macro          access name
\name:  .byte           0
        .endm

        .macro          access2 name
\name:  .byte           0
        .endm

#   ordinals for transferring minimal values to/from assembly language.
#
#   the order of entries here must correspond to the order of
#   valtab entries in the inter assembly language module.
#
#   the structure vords and the access macro is merely a device to
#   produce an enumeration similar to an enum structure to c.
#
        struc   vords
.endif                                      # ]]

        access  gbcnt
        access  headv
        access  mxlen
        access  stage
        access  timsx
        access  dnamb
        access  dnamp
        access  state
        access  b_efc
        access  b_icl
        access  b_scl
        access  b_vct
        access  b_xnt
        access  b_xrt
        access  stbas
        access  statb
        access  polct
        access  typet
        access  dffnc
        access  lowspmin
        access  flprt
        access  flptr
        access  gtcef
        access  hshtb
        access  pmhbs
        access  r_fcb
        access  c_aaa
        access  c_yyy
        access  g_aaa
        access  w_yyy
        access  s_aaa
        access  s_yyy
        access  r_cod
        access  kvstn
        access  kvdmp
        access  kvftr
        access  kvcom
        access  kvpfl
        access  cswfl
        access  stmcs
        access  stmct
        access2 ticblk
        access2 tscblk
        access2 id1
        access2 id2blk
        access2 inpbuf
        access2 ttybuf
        access  b_rcl

.if direct
        dsegend_
.else
        ends    vords
.endif

        csegend_
