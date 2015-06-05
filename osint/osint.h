/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2015555vid Shields

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

extern word	reg_cp, reg_wa, reg_wb, reg_wc, reg_xr, reg_xl, reg_xs, reg_w0;
extern signed char	reg_fl;
extern long	reg_ia;
extern double 	reg_ra,*reg_rp;
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
#define W0(type)	((type) reg_w0)
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
#define SET_W0(val)	(reg_w0 = (word) (val))
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
#define MINIMAL(cn) minimal_id = cn; c_minimal();
#define MINSAVE() pushregs()
#define MINRESTORE() popregs()

/*
/	Ordinals for MINIMAL calls from C.
/
/   The order of entries here must correspond to the order of
/   table entries in the INTER assembly language module.
*/
enum CALLS {
    minimal_relaj,
    minimal_relcr,
    minimal_reloc,
    minimal_alloc,
    minimal_alocs,
    minimal_alost,
    minimal_blkln,
    minimal_insta,
    minimal_rstrt,
    minimal_start,
    minimal_filnm,
    minimal_dtype,
    minimal_enevs,
    minimal_engts
};

/*
/	Function and macro to get/set value from/to MINIMAL dataspace.
/	The argument is an ordinal number defined below.
/   	GET_DATA_OFFSET returns the address of a Minimal data value.
/   	GET_CODE_OFFSET returns the address of a Minimal routine.
/	GET_MIN_VALUE returns the contents of an item of Minimal data.
/	SET_MIN_VALUE sets the contents of an item of Minimal data.
*/
#define GET_CODE_OFFSET(vn,type) ((type)vn)
#define GET_DATA_OFFSET(vn,type) ((type)&vn)
#define GET_MIN_VALUE(vn,type) ((type)vn)
#define SET_MIN_VALUE(vn,val,type) (*(type *)&vn = (type)(val))
/*
/   Names for accessing MINIMAL data values via GET_DATA_OFFSET macro.
*/
extern word
c_aaa,
c_yyy,
cswfl,
dnamb,
dnamp,
flprt,
flptr,
g_aaa,
gbcnt,
gtcef,
headv,
hshtb,
id1blk,
id2blk,
inpbuf,
kvstn,
kvdmp,
kvftr,
kvcom,
kvpfl,
mxlen,
pmhbs,
polct,
r_fcb,
r_cod,
stage,
statb,
state,
stbas,
stmcs,
stmct,
ticblk,
timsx,
tscblk,
ttybuf,
typet,
w_yyy,
end_min_data;

/*
/   Names for accessing MINIMAL code values via GET_CODE_OFFSET macro.
*/
extern void	b_efc();
extern void	b_icl();
extern void 	b_rcl();
extern void 	b_scl();
extern void	b_vct();
extern void	b_xnt();
extern void	b_xrt();
extern void	dffnc();
extern void	s_aaa();
extern void	s_yyy();


// Some shorthand notations
#define pid1blk GET_DATA_OFFSET(id1blk,struct scblk *)
#define pid2blk GET_DATA_OFFSET(id2blk,struct scblk *)
#define pinpbuf GET_DATA_OFFSET(inpbuf,struct bfblk *)
#define pttybuf GET_DATA_OFFSET(ttybuf,struct bfblk *)
#define pticblk GET_DATA_OFFSET(ticblk,struct icblk *)
#define ptscblk GET_DATA_OFFSET(tscblk,struct scblk *)

#define TYPE_EFC GET_CODE_OFFSET(b_efc,word)
#define TYPE_ICL GET_CODE_OFFSET(b_icl,word)
#define TYPE_SCL GET_CODE_OFFSET(b_scl,word)
#define TYPE_VCT GET_CODE_OFFSET(b_vct,word)
#define TYPE_XNT GET_CODE_OFFSET(b_xnt,word)
#define TYPE_XRT GET_CODE_OFFSET(b_xrt,word)
#define TYPE_RCL GET_CODE_OFFSET(b_rcl,word)

