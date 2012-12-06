;
;
;   Table to recover type word from type ordinal
;

%ifndef HDRDATA_INCLUDED
%define HDRDATA_INCLUDED
;   HDRDATA.INC
	extern	_rc_
	extern	zzz
        ;pubdef  TYPET
	global	TYPET
	
        dd B_ART   ; ARBLK type word - 0
        dd B_CDC   ; CDBLK type word - 1
        dd B_EXL   ; EXBLK type word - 2
        dd B_ICL   ; ICBLK type word - 3
        dd B_NML   ; NMBLK type word - 4
        dd P_ABA   ; P0BLK type word - 5
        dd P_ALT   ; P1BLK type word - 6
        dd P_ANY   ; P2BLK type word - 7
; next needed only if support real arithmetic CNRA
;        dd B_RCL   ; RCBLK type word - 8
        dd B_SCL   ; SCBLK type word - 9
        dd B_SEL   ; SEBLK type word - 10
        dd B_TBT   ; TBBLK type word - 11
        dd B_VCT   ; VCBLK type word - 12
        dd B_XNT   ; XNBLK type word - 13
        dd B_XRT   ; XRBLK type word - 14
        dd B_BCT   ; BCBLK type word - 15
        dd B_PDT   ; PDBLK type word - 16
        dd B_TRT   ; TRBLK type word - 17
        dd B_BFT   ; BFBLK type word   18
        dd B_CCT   ; CCBLK type word - 19
        dd B_CMT   ; CMBLK type word - 20
        dd B_CTT   ; CTBLK type word - 21
        dd B_DFC   ; DFBLK type word - 22
        dd B_EFC   ; EFBLK type word - 23
        dd B_EVT   ; EVBLK type word - 24
        dd B_FFC   ; FFBLK type word - 25
        dd B_KVT   ; KVBLK type word - 26
        dd B_PFC   ; PFBLK type word - 27
        dd B_TET   ; TEBLK type word - 28
;
;   Table of MINIMAL entry points that can be dded from C
;   via the minimal function (see inter.asm).
;
;   Note that the order of entries in this table must correspond
;   to the order of entries in the CALL enumeration in osint.h
;   and osint.inc.
;
       ; pubdef  calltab
	global calltab
calltab:
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
;       dd   ENEVS ;  Engine words
;       dd   ENGTS ;   not used

;
;   Table of MINIMAL variables that can be dded from C
;   and assembly-language via macros GETOFF, GETPTR, GETMIN, and SETMIN.
;
;   There are two ways of setting this up.  If the symbol "direct" is
;   non-zero, the symbols are declared public and dded directly.
;   If direct is zero, dd is via the function minadr in inter.asm.
;
;   The macros GETOFF, GETPTR, GETMIN, and SETMIN in osint.h and osint.inc
;   must be adjusted when direct is changed.
;
;   Note that the order of entries in this table must correspond to the
;   order of entries in the VAL enumeration in osint.h and osint.inc.
;
        %macro  DD_ENT 1
%if direct
        global %1
%else
        dd %1
%endif
        %endmacro

        ;pubdef  valtab
	global	valtab
valtab:
	DD_ENT	GBCNT
	DD_ENT	HEADV
	DD_ENT	MXLEN
	DD_ENT	STAGE
	DD_ENT	TIMSX
	DD_ENT	DNAMB
	DD_ENT	DNAMP
	DD_ENT	STATE
	DD_ENT	B_EFC
	DD_ENT	B_ICL
	DD_ENT	B_SCL
	DD_ENT	B_VCT
	DD_ENT	B_XNT
	DD_ENT	B_XRT
	DD_ENT	STBAS
	DD_ENT	STATB
	DD_ENT	POLCT
	DD_ENT  	TYPET
	DD_ENT	LOWSPMIN
	DD_ENT	FLPRT
	DD_ENT	FLPTR
	DD_ENT	GTCEF
	DD_ENT	HSHTB
	DD_ENT	PMHBS
	DD_ENT	R_FCB
	DD_ENT	C_AAA
	DD_ENT	C_YYY
	DD_ENT	G_AAA
	DD_ENT	W_YYY
	DD_ENT	S_AAA
	DD_ENT	S_YYY
	DD_ENT	R_COD
	DD_ENT	KVSTN
	DD_ENT	KVDMP
	DD_ENT	KVFTR
	DD_ENT	KVCOM
	DD_ENT	KVPFL
	DD_ENT	CSWFL
        DD_ENT  	STMCS
        DD_ENT  	STMCT
	DD_ENT	B_RCL
	DD_ENT	END_MIN_DATA
        %unmacro  DD_ENT 1
%endif
