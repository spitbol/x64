/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2013 David Shields

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
/   File:  OSINT.H		Version:  01.01
/   -------------------------------------------
/
/   This header file defines the interface between the Macro SPITBOL compiler
/   written in assembly langauge and the OS interface written in C.
/   Communication between the two is handled via a set of global variables
/   defined as externals below.
*/


/*
/   Set up externals for all the compiler's registers.
*/

extern word	reg_cp, reg_wa, reg_wb, reg_wc, reg_xr, reg_xl, reg_xs;
extern IATYPE	reg_ia;
extern double reg_ra;
extern uword	minimal_id;

/*
 *  Macros to deal with converting pointers within the Minimal heap
 *  to pointers that the C code can deal with.
 *  These macros were needed for x86, due to NEAR/FAR distinction, which
 *  is no longer relevant, so that the macros should be eliminated when
 *  convenient, to improve readability.
 */
#define MP_OFF(cp,type) ((type)cp)

/*
/   Macros to fetch a value of appropriate type from a compiler register
*/

#define CP(type)	((type) reg_cp)
#define IA(type)	((type) reg_ia)
#define WA(type)	((type) reg_wa)
#define WB(type)	((type) reg_wb)
#define WC(type)	((type) reg_wc)
#define XR(type)	((type) reg_xr)
#define XL(type)	((type) reg_xl)
#define PC(type)	((type) reg_pc)
#define XS(type)	((type) reg_xs)
#define RA(type)        ((type) reg_ra)
/*
/   Macros to set a value of appropriate type into a compiler register.
*/
#define SET_CP(val)	(reg_cp = (word) (val))
#define SET_IA(val)	(reg_ia = (val))
#define SET_WA(val)	(reg_wa = (word) (val))
#define SET_WB(val)	(reg_wb = (word) (val))
#define SET_WC(val)	(reg_wc = (word) (val))
#define SET_XR(val)	(reg_xr = (word) (val))
#define SET_XL(val)	(reg_xl = (word) (val))
#define SET_PC(val)	(reg_pc = (word) (val))
#define SET_XS(val)	(reg_xs = (word) (val))
#define SET_RA(val)  (reg_ra = (double) (val))

/*
/   Return values to take exit N from interface
*/
#define EXIT_1		1
#define EXIT_2		2
#define EXIT_3		3
#define EXIT_4		4
#define EXIT_5		5
#define EXIT_6		6
#define EXIT_7		7
#define EXIT_8		8
#define EXIT_9		9

/*
/    Return value to do a normal return from interface.
*/
#define NORMAL_RETURN	0

/*
/	Function to call into MINIMAL code.
/	The argument is an ordinal number defined below.
*/
extern void minimal (void);
extern void popregs (void);
extern void pushregs (void);
#define MINIMAL(cn) minimal_id = cn; minimal();
#define MINSAVE() pushregs()
#define MINRESTORE() popregs()

/*
/	Ordinals for MINIMAL calls from C.
/
/   The order of entries here must correspond to the order of
/   table entries in the INTER assembly language module.
*/
enum CALLS {
    MINIMAL_RELAJ,
    MINIMAL_RELCR,
    MINIMAL_RELOC,
    MINIMAL_ALLOC,
    MINIMAL_ALOCS,
    MINIMAL_ALOST,
    MINIMAL_BLKLN,
    MINIMAL_INSTA,
    MINIMAL_RSTRT,
    MINIMAL_START,
    MINIMAL_FILNM,
    MINIMAL_DTYPE,
    MINIMAL_ENEVS,
    MINIMAL_ENGTS
};

/*
/	Function and macro to get/set value from/to MINIMAL dataspace.
/	The argument is an ordinal number defined below.
/   	GET_DATA_OFFSET returns the address of a Minimal data value.
/   	GET_CODE_OFFSET returns the address of a Minimal routine.
/	GET_MIN_VALUE returns the contents of an item of Minimal data.
/	SET_MIN_VALUE sets the contents of an item of Minimal data.
*/
#if DIRECT
#define GET_CODE_OFFSET(vn,type) ((type)vn)
#define GET_DATA_OFFSET(vn,type) ((type)&vn)
#define GET_MIN_VALUE(vn,type) ((type)vn)
#define SET_MIN_VALUE(vn,val,type) (*(type *)&vn = (type)(val))
/*
/   Names for accessing MINIMAL data values via GET_DATA_OFFSET macro.
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
STMCS,
STMCT,
TICBLK,
TSCBLK,
ID1,
ID2BLK,
INPBUF,
TTYBUF,
END_MIN_DATA;

/*
/   Names for accessing MINIMAL code values via GET_CODE_OFFSET macro.
*/
extern void	B_EFC();
extern void	B_ICL();
extern void 	B_RCL();
extern void 	B_SCL();
extern void	B_VCT();
extern void	B_XNT();
extern void	B_XRT();
extern void	DFFNC();
extern void	S_AAA();
extern void	S_YYY();

#else					// DIRECT
extern  word *minoff (word valno);
#define GET_CODE_OFFSET(vn,type) ((type)minoff(vn))
#define GET_DATA_OFFSET(vn,type) ((type)minoff(vn))
#define GET_MIN_VALUE(vn,type)	((type)*minoff(vn))
#define SET_MIN_VALUE(vn,val,type) (*(type *)minoff(vn) = (type)(val))
/*
/   Ordinals for accessing MINIMAL values.
/
/   The order of entries here must correspond to the order of
/   valtab entries in the INTER assembly language module.
*/
enum VALS {
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

#endif					// DIRECT

// Some shorthand notations
#define pID1 GET_DATA_OFFSET(ID1,struct scblk *)
#define pID2BLK GET_DATA_OFFSET(ID2BLK,struct scblk *)
#define pINPBUF GET_DATA_OFFSET(INPBUF,struct bfblk *)
#define pTTYBUF GET_DATA_OFFSET(TTYBUF,struct bfblk *)
#define pTICBLK GET_DATA_OFFSET(TICBLK,struct icblk *)
#define pTSCBLK GET_DATA_OFFSET(TSCBLK,struct scblk *)

#define TYPE_EFC GET_CODE_OFFSET(B_EFC,word)
#define TYPE_ICL GET_CODE_OFFSET(B_ICL,word)
#define TYPE_SCL GET_CODE_OFFSET(B_SCL,word)
#define TYPE_VCT GET_CODE_OFFSET(B_VCT,word)
#define TYPE_XNT GET_CODE_OFFSET(B_XNT,word)
#define TYPE_XRT GET_CODE_OFFSET(B_XRT,word)
#define TYPE_RCL GET_CODE_OFFSET(B_RCL,word)

