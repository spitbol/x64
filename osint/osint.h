/*
copyright 1987-2012 robert b. k. dewar and mark emmer.

this file is part of macro spitbol.

    macro spitbol is free software: you can redistribute it and/or modify
    it under the terms of the gnu general public license as published by
    the free software foundation, either version 3 of the license, or
    (at your option) any later version.

    macro spitbol is distributed in the hope that it will be useful,
    but without any warranty; without even the implied warranty of
    merchantability or fitness for a particular purpose.  see the
    gnu general public license for more details.

    you should have received a copy of the gnu general public license
    along with macro spitbol.  if not, see <http://www.gnu.org/licenses/>.
*/

/*
/   file:  osint.h		version:  01.01
/   -------------------------------------------
/
/   this header file defines the interface between the macro spitbol compiler
/   written in assembly langauge and the os interface written in c.
/   communication between the two is handled via a set of global variables
/   defined as externals below.
*/


/*
/   set up externals for all the compiler's registers.
*/

extern word	reg_cp, reg_wa, reg_wb, reg_wc, reg_xr, reg_xl, reg_xs;
extern iatype	reg_ia;
extern double reg_ra;
#if winnt | sparc
extern word reg_pc;
#endif

/*
 *  macros to deal with converting pointers within the minimal heap
 *  to pointers that the c code can deal with.  on most systems, the
 *  two types of pointers are equivalent.  but on machines like the
 *  8088 or under windows, the near pointers within the heap need to
 *  be converted to and from far pointers in the c data space.
 */
#if __near__
extern void *mk_mp(void near *minp);
#define mk_mp(minp,type) ((type)mk_mp((void near *)(minp)))
#define mp_off(cp,type) ((type)(void near *)(cp))
#else					/* __near__ */
#define mk_mp(minp,type) ((type)(minp))
#define mp_off(cp,type) ((type)cp)
#endif					/* __near__ */

/*
/   macros to fetch a value of appropriate type from a compiler register
*/

#if __near__
#define cp(type)	(sizeof(type) == 4 ? mk_mp(reg_cp,type) : ((type) reg_cp))
#define ia(type)	((type) reg_ia)
#define wa(type)	(sizeof(type) == 4 ? mk_mp(reg_wa,type) : ((type) reg_wa))
#define wb(type)	(sizeof(type) == 4 ? mk_mp(reg_wb,type) : ((type) reg_wb))
#define wc(type)	(sizeof(type) == 4 ? mk_mp(reg_wc,type) : ((type) reg_wc))
#define xr(type)	(sizeof(type) == 4 ? mk_mp(reg_xr,type) : ((type) reg_xr))
#define xl(type)	(sizeof(type) == 4 ? mk_mp(reg_xl,type) : ((type) reg_xl))
#define pc(type)	(sizeof(type) == 4 ? mk_mp(reg_pc,type) : ((type) reg_pc))
#define xs(type)	(sizeof(type) == 4 ? mk_mp(reg_xs,type) : ((type) reg_xs))
#define ra(type)  (sizeof(type) == 8 ? mk_mp(reg_ra,type) : ((type) reg_ra))
#else         /* __near__ */
#define cp(type)	((type) reg_cp)
#define ia(type)	((type) reg_ia)
#define wa(type)	((type) reg_wa)
#define wb(type)	((type) reg_wb)
#define wc(type)	((type) reg_wc)
#define xr(type)	((type) reg_xr)
#define xl(type)	((type) reg_xl)
#define pc(type)	((type) reg_pc)
#define xs(type)	((type) reg_xs)
#define ra(type)  ((type) reg_ra)    /* v1.30.12 */
#endif          /* __near__ */
/*
/   macros to set a value of appropriate type into a compiler register.
*/
#define set_cp(val)	(reg_cp = (word) (val))
#define set_ia(val)	(reg_ia = (val))
#define set_wa(val)	(reg_wa = (word) (val))
#define set_wb(val)	(reg_wb = (word) (val))
#define set_wc(val)	(reg_wc = (word) (val))
#define set_xr(val)	(reg_xr = (word) (val))
#define set_xl(val)	(reg_xl = (word) (val))
#define set_pc(val)	(reg_pc = (word) (val))
#define set_xs(val)	(reg_xs = (word) (val))
#define set_ra(val)  (reg_ra = (double) (val))

/*
/   return values to take exit n from interface
*/
#define exit_1		0
#define exit_2		4
#define exit_3		8
#define exit_4		12
#define exit_5		16
#define exit_6		20
#define exit_7		24
#define exit_8		28
#define exit_9		32

/*
/    return value to do a normal return from interface.
*/
#define normal_return	(-1)

/*
/	function to call into minimal code.
/	the argument is an ordinal number defined below.
*/
extern void minimal params((word callno));
extern void popregs params((void));
extern void pushregs params((void));
#define minimal(cn) minimal(cn)
#define minsave() pushregs()
#define minrestore() popregs()

/*
/	ordinals for minimal calls from c.
/
/   the order of entries here must correspond to the order of
/   table entries in the inter assembly language module.
*/
enum calls {
    relaj,
    relcr,
    reloc,
    alloc,
    alocs,
    alost,
    blkln,
    insta,
    rstrt,
    start,
    filnm,
    dtype,
    enevs,
    engts
};

/*
/	function and macro to get/set value from/to minimal dataspace.
/	the argument is an ordinal number defined below.
/   get_data_offset returns the address of a minimal data value.
/   get_code_offset returns the address of a minimal routine.
/	get_min_value returns the contents of an item of minimal data.
/	set_min_value sets the contents of an item of minimal data.
*/
#if direct
#define get_code_offset(vn,type) ((type)vn)
#define get_data_offset(vn,type) ((type)&vn)
#define get_min_value(vn,type) ((type)vn)
#define set_min_value(vn,val,type) (*(type *)&vn = (type)(val))
/*
/   names for accessing minimal data values via get_data_offset macro.
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
/   names for accessing minimal code values via get_code_offset macro.
*/
extern void	b_efc();
extern void	b_icl();
extern void b_rcl();
extern void b_scl();
extern void	b_vct();
extern void	b_xnt();
extern void	b_xrt();
extern void	dffnc();
extern void	s_aaa();
extern void	s_yyy();

#else					/* direct */
extern  word *minoff params((word valno));
#define get_code_offset(vn,type) ((type)minoff(vn))
#define get_data_offset(vn,type) ((type)minoff(vn))
#define get_min_value(vn,type)	((type)*minoff(vn))
#define set_min_value(vn,val,type) (*(type *)minoff(vn) = (type)(val))
/*
/   ordinals for accessing minimal values.
/
/   the order of entries here must correspond to the order of
/   valtab entries in the inter assembly language module.
*/
enum vals {
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

#endif					/* direct */

/* some shorthand notations */
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

