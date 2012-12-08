;
;
;   Table to recover type word from type ordinal
;

%ifndef HDRDATA_INCLUDED
%define HDRDATA_INCLUDED
;   HDRDATA.INC
	extern	_rc_
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

	global	GBCNT
	global	HEADV
	global	MXLEN
	global	STAGE
	global	TIMSX
	global	DNAMB
	global	DNAMP
	global	STATE
	global	B_EFC
	global	B_ICL
	global	B_SCL
	global	B_VCT
	global	B_XNT
	global	B_XRT
	global	STBAS
	global	STATB
	global	POLCT
	global  TYPET
	global	LOWSPMIN
	global	FLPRT
	global	FLPTR
	global	GTCEF
	global	HSHTB
	global	PMHBS
	global	R_FCB
	global	C_AAA
	global	C_YYY
	global	G_AAA
	global	W_YYY
	global	S_AAA
	global	S_YYY
	global	R_COD
	global	KVSTN
	global	KVDMP
	global	KVFTR
	global	KVCOM
	global	KVPFL
	global	CSWFL
        global  STMCS
        global  STMCT
	global	B_RCL
	global	END_MIN_DATA
%endif
