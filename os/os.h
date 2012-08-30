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
    Set up externals for all the compiler's registers.
*/

#define REGISTER
extern word reg_cp, reg_wa, reg_wb, reg_wc, reg_xr, reg_xl, reg_xs;
extern IATYPE reg_ia;
extern double reg_ra;

#define MK_MP(minp,type) ((type)(minp))
#define MP_OFF(cp,type) ((type)cp)

/*
    Macros to fetch a value of appropriate type from a compiler register
*/

#define CP(type)        ((type) reg_cp)
#define IA(type)        ((type) reg_ia)
#define WA(type)        ((type) reg_wa)
#define WB(type)        ((type) reg_wb)
#define WC(type)        ((type) reg_wc)
#define XR(type)        ((type) reg_xr)
#define XL(type)        ((type) reg_xl)
#define PC(type)        ((type) reg_pc)
#define XS(type)        ((type) reg_xs)
#define RA(type)  ((type) reg_ra)	/* v1.30.12 */
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
extern void minimal_call(word callno);
extern void popregs(void);
extern void pushregs(void);
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
    GBCNT,
    HEADV,
    MXLEN,
    STAGE,
    TIMSX,
    DNAMB,
    DNAMP,
    STATE,
    STBAS,
    STATB,
    POLCT,
    TYPET,
    LOWSPMIN,
    FLPRT,
    FLPTR,
    GTCEF,
    HSHTB,
    PMHBS,
    R_FCB,
    C_AAA,
    C_YYY,
    G_AAA,
    W_YYY,
    R_COD,
    KVSTN,
    KVDMP,
    KVFTR,
    KVCOM,
    KVPFL,
    CSWFL,
    STMCS, STMCT, TICBLK, TSCBLK, ID1, ID2BLK, INPBUF, TTYBUF,
    END_MIN_DATA;

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

#else				/* DIRECT */
extern word *minoff(word valno);
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
    GBCNT,
    HEADV,
    MXLEN,
    STAGE,
    TIMSX,
    DNAMB,
    DNAMP,
    STATE,
    B_EFC,
    B_ICL,
    B_SCL,
    B_VCT,
    B_XNT,
    B_XRT,
    STBAS,
    STATB,
    POLCT,
    TYPET,
    DFFNC,
    LOWSPMIN,
    FLPRT,
    FLPTR,
    GTCEF,
    HSHTB,
    PMHBS,
    R_FCB,
    C_AAA,
    C_YYY,
    G_AAA,
    W_YYY,
    S_AAA,
    S_YYY,
    R_COD,
    KVSTN,
    KVDMP,
    KVFTR,
    KVCOM,
    KVPFL,
    CSWFL,
    STMCS,
    STMCT,
    TICBLK,
    TSCBLK,
    ID1,
    ID2BLK,
    INPBUF,
    TTYBUF,
    B_RCL,
    END_MIN_DATA
};

#endif				/* DIRECT */

/* Some shorthand notations */
#define pid1 get_data_offset(ID1,struct scblk *)
#define pid2blk get_data_offset(ID2BLK,struct scblk *)
#define pinpbuf get_data_offset(INPBUF,struct bfblk *)
#define pttybuf get_data_offset(TTYBUF,struct bfblk *)
#define pticblk get_data_offset(TICBLK,struct icblk *)
#define ptscblk get_data_offset(TSCBLK,struct scblk *)

#define type_efc get_code_offset(B_EFC,word)
#define type_icl get_code_offset(B_ICL,word)
#define type_scl get_code_offset(B_SCL,word)
#define type_vct get_code_offset(B_VCT,word)
#define type_xnt get_code_offset(B_XNT,word)
#define type_xrt get_code_offset(B_XRT,word)
#define type_rcl get_code_offset(B_RCL,word)
