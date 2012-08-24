/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
    File:  OSINT.H              Version:  01.01
    -------------------------------------------

    This header file defines the interface between the Macro SPITBOL compiler
    written in assembly langauge and the OS interface written in C.
    Communication between the two is handled via a set of global variables
    defined as externals below.
*/


/*
    Set up externals for all the compiler's registers.
*/

extern word     reg_cp, reg_wa, reg_wb, reg_wc, reg_xr, reg_xl, reg_xs;
extern IATYPE   reg_ia;
extern double reg_ra;
#if WINNT | SPARC
extern word reg_pc;
#endif

/*
    Macros to deal with converting pointers within the Minimal heap
    to pointers that the C code can deal with.  On most systems, the
    two types of pointers are equivalent.  But on machines like the
    8088 or under Windows, the near pointers within the heap need to
    be converted to and from far pointers in the C data space.
 */
#if __NEAR__
extern void *mk_mp(void near *minp);
#define MK_MP(minp,type) ((type)mk_mp((void near *)(minp)))
#define MP_OFF(cp,type) ((type)(void NEAR *)(cp))
#else                                   /* __NEAR__ */
#define MK_MP(minp,type) ((type)(minp))
#define MP_OFF(cp,type) ((type)cp)
#endif                                  /* __NEAR__ */

/*
    Macros to fetch a value of appropriate type from a compiler register
*/

#if __NEAR__
#define CP(type)        (sizeof(type) == 4 ? MK_MP(reg_cp,type) : ((type) reg_cp))
#define IA(type)        ((type) reg_ia)
#define WA(type)        (sizeof(type) == 4 ? MK_MP(reg_wa,type) : ((type) reg_wa))
#define WB(type)        (sizeof(type) == 4 ? MK_MP(reg_wb,type) : ((type) reg_wb))
#define WC(type)        (sizeof(type) == 4 ? MK_MP(reg_wc,type) : ((type) reg_wc))
#define XR(type)        (sizeof(type) == 4 ? MK_MP(reg_xr,type) : ((type) reg_xr))
#define XL(type)        (sizeof(type) == 4 ? MK_MP(reg_xl,type) : ((type) reg_xl))
#define PC(type)        (sizeof(type) == 4 ? MK_MP(reg_pc,type) : ((type) reg_pc))
#define XS(type)        (sizeof(type) == 4 ? MK_MP(reg_xs,type) : ((type) reg_xs))
#define RA(type)  (sizeof(type) == 8 ? MK_MP(reg_ra,type) : ((type) reg_ra))
#else         /* __NEAR__ */
#define CP(type)        ((type) reg_cp)
#define IA(type)        ((type) reg_ia)
#define WA(type)        ((type) reg_wa)
#define WB(type)        ((type) reg_wb)
#define WC(type)        ((type) reg_wc)
#define XR(type)        ((type) reg_xr)
#define XL(type)        ((type) reg_xl)
#define PC(type)        ((type) reg_pc)
#define XS(type)        ((type) reg_xs)
#define RA(type)  ((type) reg_ra)    /* v1.30.12 */
#endif          /* __NEAR__ */
/*
    Macros to set a value of appropriate type into a compiler register.
*/
#define SET_CP(val)     (reg_cp = (word) (val))
#define SET_IA(val)     (reg_ia = (val))
#define SET_WA(val)     (reg_wa = (word) (val))
#define SET_WB(val)     (reg_wb = (word) (val))
#define SET_WC(val)     (reg_wc = (word) (val))
#define SET_XR(val)     (reg_xr = (word) (val))
#define SET_XL(val)     (reg_xl = (word) (val))
#define SET_PC(val)     (reg_pc = (word) (val))
#define SET_XS(val)     (reg_xs = (word) (val))
#define SET_RA(val)  (reg_ra = (double) (val))

/*
    Return values to take exit N from interface
*/
#define EXIT_1          0
#define EXIT_2          4
#define EXIT_3          8
#define EXIT_4          12
#define EXIT_5          16
#define EXIT_6          20
#define EXIT_7          24
#define EXIT_8          28
#define EXIT_9          32

/*
     Return value to do a normal return from interface.
*/
#define NORMAL_RETURN   (-1)

/*
        Function to call into minimal code.
        The argument is an ordinal number defined below.
*/
extern void minimal_call Params((word callno));
extern void popregs Params((void));
extern void pushregs Params((void));
#define MINIMAL_CALL(cn) minimal_call(cn)
#define MINSAVE() pushregs()
#define MINRESTORE() popregs()

/*
        Ordinals for minimal calls from C.

    The order of entries here must correspond to the order of
    table entries in the INTER assembly language module.
*/
enum calltab {
    relaj_callid,
    relcr_callid,
    reloc_callid,
    alloc_callid,
    alocs_callid,
    alost_callid,
    blkln_callid,
    insta_callid,
    rstrt_callid,
    start_callid,
    filnm_callid,
    dtype_callid,
    enevs_callid,
    engts_callid
};

/*
Function and macro to get/set value from/to minimal dataspace.
The argument is an ordinal number defined below.
get_data_offset returns the address of a Minimal data value.
get_code_offset returns the address of a Minimal routine.
get_min_value returns the contents of an item of Minimal data.
set_min_value sets the contents of an item of Minimal data.
*/
#if direct
#define get_code_offset(vn,type) ((type)vn)
#define get_data_offset(vn,type) ((type)&vn)
#define get_min_value(vn,type) ((type)vn)
#define set_min_value(vn,val,type) (*(type *)&vn = (type)(val))
/*
    Names for accessing minimal data values via get_data_offset macro.
*/
extern word
gbcnt,
headv,
mxlen,
stage,
timsx,
dnamb,
dnamp,
state,
stbas,
statb,
polct,
typet,
lowspmin,
flprt,
flptr,
gtcef,
hshtb,
pmhbs,
r_fcb,
c_aaa,
c_yyy,
g_aaa,
w_yyy,
r_cod,
kvstn,
kvdmp,
kvftr,
kvcom,
kvpfl,
cswfl,
stmcs,
stmct,
ticblk,
tscblk,
id1,
id2blk,
inpbuf,
ttybuf,
end_min_data;

/*
    Names for accessing minimal code values via get_code_offset macro.
*/
extern void B_EFC();
extern void B_ICL();
extern void B_RCL();
extern void B_SCL();
extern void B_VCT();
extern void B_XNT();
extern void B_XRT();
extern void DFFNC();
extern void S_AAA();
extern void S_YYY();

#else                                   /* DIRECT */
extern  word *minoff Params((word valno));
#define get_code_offset(vn,type) ((type)minoff(vn))
#define get_data_offset(vn,type) ((type)minoff(vn))
#define get_min_value(vn,type)  ((type)*minoff(vn))
#define set_min_value(vn,val,type) (*(type *)minoff(vn) = (type)(val))
/*
    Ordinals for accessing minimal values.

    The order of entries here must correspond to the order of
    valtab entries in the INTER assembly language module.
*/
enum valtab {
    gbcnt,
    headv,
    mxlen,
    stage,
    timsx,
    dnamb,
    dnamp,
    state,
    b_efc,
    b_icl,
    b_scl,
    b_vct,
    b_xnt,
    b_xrt,
    stbas,
    statb,
    polct,
    typet,
    dffnc,
    lowspmin,
    flprt,
    flptr,
    gtcef,
    hshtb,
    pmhbs,
    r_fcb,
    c_aaa,
    c_yyy,
    g_aaa,
    w_yyy,
    s_aaa,
    s_yyy,
    r_cod,
    kvstn,
    kvdmp,
    kvftr,
    kvcom,
    kvpfl,
    cswfl,
    stmcs,
    stmct,
    ticblk,
    tscblk,
    id1,
    id2blk,
    inpbuf,
    ttybuf,
    b_rcl,
    end_min_data
};

#endif                                  /* DIRECT */

/* Some shorthand notations */
#define pid1 get_data_offset(id1,struct scblk *)
#define pid2blk get_data_offset(id2blk,struct scblk *)
#define pinpbuf get_data_offset(inpbuf,struct bfblk *)
#define pttybuf get_data_offset(ttybuf,struct bfblk *)
#define pticblk get_data_offset(ticblk,struct icblk *)
#define ptscblk get_data_offset(tscblk,struct scblk *)

#define type_efc get_code_offset(b_efc,word)
#define type_icl get_code_offset(b_icl,word)
#define type_scl get_code_offset(b_scl,word)
#define type_vct get_code_offset(b_vct,word)
#define type_xnt get_code_offset(b_xnt,word)
#define type_xrt get_code_offset(b_xrt,word)
#define type_rcl get_code_offset(b_rcl,word)

