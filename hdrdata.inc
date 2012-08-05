;   HDRDATA.INC
;
;
;   Table to recover type word from type ordinal
;

	%include "mintype.h"
        pubdef  TYPET
        dd   B_ART   ; ARBLK type word - 0
        dd   B_CDC   ; CDBLK type word - 1
        dd   B_EXL   ; EXBLK type word - 2
        address B_ICL   ; ICBLK type word - 3
        dd   B_NML   ; NMBLK type word - 4
        dd   P_ABA   ; P0BLK type word - 5
        dd   P_ALT   ; P1BLK type word - 6
        dd   P_ANY   ; P2BLK type word - 7
        address B_RCL   ; RCBLK type word - 8
        address B_SCL   ; SCBLK type word - 9
        dd   B_SEL   ; SEBLK type word - 10
        dd   B_TBT   ; TBBLK type word - 11
        address B_VCT   ; VCBLK type word - 12
        address B_XNT   ; XNBLK type word - 13
        address B_XRT   ; XRBLK type word - 14
        dd   B_BCT   ; BCBLK type word - 15
        dd   B_PDT   ; PDBLK type word - 16
        dd   B_TRT   ; TRBLK type word - 17
        dd   B_BFT   ; BFBLK type word   18
        dd   B_CCT   ; CCBLK type word - 19
        dd   B_CMT   ; CMBLK type word - 20
        dd   B_CTT   ; CTBLK type word - 21
        dd   B_DFC   ; DFBLK type word - 22
        address B_EFC   ; EFBLK type word - 23
        dd   B_EVT   ; EVBLK type word - 24
        dd   B_FFC   ; FFBLK type word - 25
        dd   B_KVT   ; KVBLK type word - 26
        dd   B_PFC   ; PFBLK type word - 27
        dd   B_TET   ; TEBLK type word - 28
;
;   Table of MINIMAL entry points that can be accessed from C
;   via the minimal function (see inter.asm).
;
;   Note that the order of entries in this table must correspond
;   to the order of entries in the CALL enumeration in osint.h
;   and osint.inc.
;
        pubdef  calltab
        dd   RELAJ
        dd   RELCR
        dd   RELOC
        dd   ALLOC
        dd   ALOCS
        dd   ALOST
        dd   BLKLN
        dd   INSTA
        dd   RSTRT
        dd   START
        dd   FILNM
        dd   DTYPE
;       dd   ENEVS #  Engine words
;       dd   ENGTS #   not used

;
;   Table of MINIMAL variables that can be accessed from C
;   and assembly-language via macros GETOFF, GETPTR, GETMIN, and SETMIN.
;
;   There are two ways of setting this up.  If the symbol "direct" is
;   non-zero, the symbols are declared public and accessed directly.
;   If direct is zero, access is via the function minadr in inter.asm.
;
;   The macros GETOFF, GETPTR, GETMIN, and SETMIN in osint.h and osint.inc
;   must be adjusted when direct is changed.
;
;   Note that the order of entries in this table must correspond to the
;   order of entries in the VAL enumeration in osint.h and osint.inc.
;

%macro  access 1
	%if	 direct
		pubname %1
	%else
		address %1
	%endif
%endmacro

        pubdef  valtab

	access	GBCNT
	access	HEADV
	access	MXLEN
	access	STAGE
	access	TIMSX
	access	DNAMB
	access	DNAMP
	access	STATE
	access	B_EFC
	access	B_ICL
	access	B_SCL
	access	B_VCT
	access	B_XNT
	access	B_XRT
	access	STBAS
	access	STATB
	access	POLCT
	access  TYPET
	access	LOWSPMIN
	access	FLPRT
	access	FLPTR
	access	GTCEF
	access	HSHTB
	access	PMHBS
	access	R_FCB
	access	C_AAA
	access	C_YYY
	access	G_AAA
	access	W_YYY
	access	S_AAA
	access	S_YYY
	access	R_COD
	access	KVSTN
	access	KVDMP
	access	KVFTR
	access	KVCOM
	access	KVPFL
	access	CSWFL
        access  STMCS
        access  STMCT
	access	B_RCL
	access	END_MIN_DATA

