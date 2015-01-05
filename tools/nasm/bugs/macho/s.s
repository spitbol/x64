; copyright 1987-2012 robert b. k. dewar and mark emmer.
; copyright 2012-2015 david shields
;
; this file is part of macro spitbol.
;
;     macro spitbol is free software: you can redistribute it and/or modify
;     it under the terms of the gnu general public license as published by
;     the free software foundation, either version 2 of the license, or
;     (at your option) any later version.
;
;     macro spitbol is distributed in the hope that it will be useful,
;     but without any warranty; without even the implied warranty of
;     merchantability or fitness for a particular purpose.  see the
;     gnu general public license for more details.
;
;     you should have received a copy of the gnu general public license
;     along with macro spitbol.  if not, see <http://www.gnu.org/licenses/>.
;
        section	.text

	%include	"m.h"

	extern	osisp
	extern	compsp
	extern	save_regs
	extern	restore_regs
	extern	_rc_
	extern	reg_fl
	extern	reg_w0

	global	mxint

;%define zz_trace
%ifdef zz_trace
	extern	zz
	extern	zzz
	extern	zz_cp
	extern	zz_xl
	extern	zz_xr
	extern	zz_xs
	extern	zz_wa
	extern	zz_wb
	extern	zz_wc
	extern	zz_w0
	extern	zz_zz
	extern	zz_id
	extern	zz_de
	extern	zz_0
	extern	zz_1
	extern	zz_2
	extern	zz_3
	extern	zz_4
	extern	zz_arg
	extern	zz_num
%endif
	global	start


;
;
;   table to recover type word from type ordinal
;

	extern	_rc_
	global	typet
	section .data

        d_word	b_art   ; arblk type word - 0
        d_word	b_cdc   ; cdblk type word - 1
        d_word	b_exl   ; exblk type word - 2
        d_word	b_icl   ; icblk type word - 3
        d_word	b_nml   ; nmblk type word - 4
        d_word	p_aba   ; p0blk type word - 5
        d_word	p_alt   ; p1blk type word - 6
        d_word	p_any   ; p2blk type word - 7
; next needed only if support real arithmetic cnra
;       d_word	b_rcl   ; rcblk type word - 8
        d_word	b_scl   ; scblk type word - 9
        d_word	b_sel   ; seblk type word - 10
        d_word	b_tbt   ; tbblk type word - 11
        d_word	b_vct   ; vcblk type word - 12
        d_word	b_xnt   ; xnblk type word - 13
        d_word	b_xrt   ; xrblk type word - 14
        d_word	b_bct   ; bcblk type word - 15
        d_word	b_pdt   ; pdblk type word - 16
        d_word	b_trt   ; trblk type word - 17
        d_word	b_bft   ; bfblk type word   18
        d_word	b_cct   ; ccblk type word - 19
        d_word	b_cmt   ; cmblk type word - 20
        d_word	b_ctt   ; ctblk type word - 21
        d_word	b_dfc   ; dfblk type word - 22
        d_word	b_efc   ; efblk type word - 23
        d_word	b_evt   ; evblk type word - 24
        d_word	b_ffc   ; ffblk type word - 25
        d_word	b_kvt   ; kvblk type word - 26
        d_word	b_pfc   ; pfblk type word - 27
        d_word	b_tet   ; teblk type word - 28
;
;   table of minimal entry points that can be dded from c
;   via the minimal function (see inter.asm).
;
;   note that the order of entries in this table must correspond
;   to the order of entries in the call enumeration in osint.h
;   and osint.inc.
;
	global calltab
calltab:
        d_word	relaj
        d_word	relcr
        d_word	reloc
        d_word	alloc
        d_word	alocs
        d_word	alost
        d_word	blkln
        d_word	insta
        d_word	rstrt
        d_word	start
        d_word	filnm
        d_word	dtype
;       d_word	enevs ;  engine words
;       d_word	engts ;   not used

	global	gbcnt
	global	headv
	global	mxlen
	global	stage
	global	timsx
	global	dnamb
	global	dnamp
	global	state
	global	b_efc
	global	b_icl
	global	b_scl
	global	b_vct
	global	b_xnt
	global	b_xrt
	global	stbas
	global	statb
	global	polct
	global  typet
	global	lowspmin
	global	flprt
	global	flptr
	global	gtcef
	global	hshtb
	global	pmhbs
	global	r_fcb
	global	c_aaa
	global	c_yyy
	global	g_aaa
	global	w_yyy
	global	s_aaa
	global	s_yyy
	global	r_cod
	global	kvstn
	global	kvdmp
	global	kvftr
	global	kvcom
	global	kvpfl
	global	cswfl
        global  stmcs
        global  stmct
	global	b_rcl
	global	end_min_data


        extern ldr_
        extern str_
        extern itr_
        extern adr_
        extern sbr_
        extern mlr_
        extern dvr_
        extern ngr_
        extern atn_
        extern chp_
        extern cos_
        extern etx_
        extern lnf_
        extern sin_
        extern sqr_
        extern tan_
	extern cpr_
	extern ovr_

	%macro	zzz	3
	section	.data
%%desc:	db	%3,0
	section	.text
	mov	m_word [zz_id],%1
	mov	m_word [zz_zz],%2
	mov	m_word [zz_de],%%desc
	call	zzz
	%endmacro

	extern	reg_ia,reg_wa,reg_fl,reg_w0,reg_wc

;	integer arithmetic instructions
	extern	cvd__
	%macro	cvd_	0
	call	cvd__
	%endmacro


	%macro	adi_	1
	add	ia,%1
	seto	byte [reg_fl]
	%endmacro
	extern	dvi__
	%macro	dvi_	1
	call	dvi__
	%endmacro

	extern	rmi__
	%macro	rmi_	1
	mov	w0,%1
	call	rmi__
	%endmacro


	%macro	ino_	1
	mov	al,byte [reg_fl]
	or	al,al
	jno	%1
	%endmacro

	%macro	iov_	1
	mov	al,byte [reg_fl]
	or	al,al
	jo	%1
	%endmacro

	%macro	ldi_	1
	mov	ia,%1
	%endmacro

	%macro	mli_	1
	imul	ia,%1
	seto	byte [reg_fl]
	%endmacro

	%macro	ngi_	0
	neg	ia
	seto	byte [reg_fl]
	%endmacro

	extern	f_rti
	%macro	rti_	0
	call	f_rti
	mov	ia,m_word [reg_ia]
	%endmacro

	%macro	sbi_	1
	sub	ia,%1
	mov	w0,0
	seto	byte [reg_fl]
	%endmacro

	%macro	sti_	1
	mov	%1,ia
	%endmacro

;	code pointer instructions (cp maintained in location reg_cp)

	extern	reg_cp

	%macro	lcp_	1
	mov	w0,%1
	mov	m_word [reg_cp],w0
	%endmacro

	%macro	lcw_	1
	mov	w0,m_word [reg_cp]		; load address of code word
	mov	w0,m_word [w0]			; load code word
	mov	%1,w0
	mov	w0,m_word [reg_cp]		; load address of code word
	add	w0,cfp_b
	mov	m_word [reg_cp],w0
	%endmacro

	%macro	scp_	1
	mov	w0,m_word [reg_cp]
	mov	%1,w0
	%endmacro

	%macro	icp_	0
	mov	w0,m_word [reg_cp]
	add	w0,cfp_b
	mov	m_word [reg_cp],w0
	%endmacro

	%macro	rov_	1
	mov	al,byte [reg_fl]
	or	al,al
	jne	%1
	%endmacro

	%macro	rno_	1
	mov	al,byte [reg_fl]
	or	al,al
	je	%1
	%endmacro


        segment .text
        global sec01
sec01:
        extern sysax
        extern sysbs
        extern sysbx
        extern sysdc
        extern sysdm
        extern sysdt
        extern sysea
        extern sysef
        extern sysej
        extern sysem
        extern sysen
        extern sysep
        extern sysex
        extern sysfc
        extern sysgc
        extern syshs
        extern sysid
        extern sysif
        extern sysil
        extern sysin
        extern sysio
        extern sysld
        extern sysmm
        extern sysmx
        extern sysou
        extern syspi
        extern syspl
        extern syspp
        extern syspr
        extern sysrd
        extern sysri
        extern sysrw
        extern sysst
        extern systm
        extern systt
        extern sysul
        extern sysxi
        segment .data
        global sec02
sec02:
cfp_a   equ  256
cfp_b   equ  8
cfp_c   equ  8
cfp_f   equ  16
cfp_i   equ  1
cfp_m   equ  9223372036854775807
cfp_n   equ  64
cfp_r   equ  1
cfp_s   equ  9
cfp_x   equ  3
mxdgs   equ  cfp_s+cfp_x
nstmx   equ  mxdgs+5
cfp_u   equ  128
e_srs   equ  100
e_sts   equ  1000
e_cbs   equ  500
e_hnb   equ  257
e_hnw   equ  3
e_fsp   equ  15
e_sed   equ  25
ch_la   equ  97
ch_lb   equ  98
ch_lc   equ  99
ch_ld   equ  100
ch_le   equ  101
ch_lf   equ  102
ch_lg   equ  103
ch_lh   equ  104
ch_li   equ  105
ch_lj   equ  106
ch_lk   equ  107
ch_ll   equ  108
ch_lm   equ  109
ch_ln   equ  110
ch_lo   equ  111
ch_lp   equ  112
ch_lq   equ  113
ch_lr   equ  114
ch_ls   equ  115
ch_lt   equ  116
ch_lu   equ  117
ch_lv   equ  118
ch_lw   equ  119
ch_lx   equ  120
ch_ly   equ  121
ch_l_   equ  122
ch_d0   equ  48
ch_d1   equ  49
ch_d2   equ  50
ch_d3   equ  51
ch_d4   equ  52
ch_d5   equ  53
ch_d6   equ  54
ch_d7   equ  55
ch_d8   equ  56
ch_d9   equ  57
ch_am   equ  38
ch_as   equ  42
ch_at   equ  64
ch_bb   equ  60
ch_bl   equ  32
ch_br   equ  124
ch_cl   equ  58
ch_cm   equ  44
ch_dl   equ  36
ch_dt   equ  46
ch_dq   equ  34
ch_eq   equ  61
ch_ex   equ  33
ch_mn   equ  45
ch_nm   equ  35
ch_nt   equ  126
ch_pc   equ  37
ch_pl   equ  43
ch_pp   equ  40
ch_rb   equ  62
ch_rp   equ  41
ch_qu   equ  63
ch_sl   equ  47
ch_sm   equ  59
ch_sq   equ  39
ch_u_   equ  95
ch_ob   equ  91
ch_cb   equ  93
ch_ht   equ  9
ch_ey   equ  94
ch_ua   equ  65
ch_ub   equ  66
ch_uc   equ  67
ch_ud   equ  68
ch_ue   equ  69
ch_uf   equ  70
ch_ug   equ  71
ch_uh   equ  72
ch_ui   equ  73
ch_uj   equ  74
ch_uk   equ  75
ch_ul   equ  76
ch_um   equ  77
ch_un   equ  78
ch_uo   equ  79
ch_up   equ  80
ch_uq   equ  81
ch_ur   equ  82
ch_us   equ  83
ch_ut   equ  84
ch_uu   equ  85
ch_uv   equ  86
ch_uw   equ  87
ch_ux   equ  88
ch_uy   equ  89
ch_uz   equ  90
iodel   equ  32
offs1   equ  1
offs2   equ  2
offs3   equ  3
bl_ar   equ  0
bl_cd   equ  bl_ar+1
bl_ex   equ  bl_cd+1
bl_ic   equ  bl_ex+1
bl_nm   equ  bl_ic+1
bl_p0   equ  bl_nm+1
bl_p1   equ  bl_p0+1
bl_p2   equ  bl_p1+1
bl_rc   equ  bl_p2+1
bl_sc   equ  bl_rc+1
bl_se   equ  bl_sc+1
bl_tb   equ  bl_se+1
bl_vc   equ  bl_tb+1
bl_xn   equ  bl_vc+1
bl_xr   equ  bl_xn+1
bl_bc   equ  bl_xr+1
bl_pd   equ  bl_bc+1
bl__d   equ  bl_pd+1
bl_tr   equ  bl_pd+1
bl_bf   equ  bl_tr+1
bl_cc   equ  bl_bf+1
bl_cm   equ  bl_cc+1
bl_ct   equ  bl_cm+1
bl_df   equ  bl_ct+1
bl_ef   equ  bl_df+1
bl_ev   equ  bl_ef+1
bl_ff   equ  bl_ev+1
bl_kv   equ  bl_ff+1
bl_pf   equ  bl_kv+1
bl_te   equ  bl_pf+1
bl__i   equ  0
bl__t   equ  bl_tr+1
bl___   equ  bl_te+1
fcode   equ  0
fargs   equ  1
idval   equ  1
artyp   equ  0
arlen   equ  idval+1
arofs   equ  arlen+1
arndm   equ  arofs+1
arlbd   equ  arndm+1
ardim   equ  arlbd+cfp_i
arlb2   equ  ardim+cfp_i
ardm2   equ  arlb2+cfp_i
arpro   equ  ardim+cfp_i
arvls   equ  arpro+1
arpr2   equ  ardm2+cfp_i
arvl2   equ  arpr2+1
arsi_   equ  arlbd
ardms   equ  arlb2-arlbd
cctyp   equ  0
cclen   equ  cctyp+1
ccsln   equ  cclen+1
ccuse   equ  ccsln+1
cccod   equ  ccuse+1
cdjmp   equ  0
cdstm   equ  cdjmp+1
cdsln   equ  cdstm+1
cdlen   equ  cdsln+1
cdfal   equ  cdlen+1
cdcod   equ  cdfal+1
cdsi_   equ  cdcod
cmidn   equ  0
cmlen   equ  cmidn+1
cmtyp   equ  cmlen+1
cmopn   equ  cmtyp+1
cmvls   equ  cmopn+1
cmrop   equ  cmvls
cmlop   equ  cmvls+1
cmsi_   equ  cmvls
cmus_   equ  cmsi_+1
cmbs_   equ  cmsi_+2
cmar1   equ  cmvls+1
c_arr   equ  0
c_fnc   equ  c_arr+1
c_def   equ  c_fnc+1
c_ind   equ  c_def+1
c_key   equ  c_ind+1
c_ubo   equ  c_key+1
c_uuo   equ  c_ubo+1
c_uo_   equ  c_uuo+1
c__nm   equ  c_uuo+1
c_bvl   equ  c_uuo+1
c_uvl   equ  c_bvl+1
c_alt   equ  c_uvl+1
c_cnc   equ  c_alt+1
c_cnp   equ  c_cnc+1
c_unm   equ  c_cnp+1
c_bvn   equ  c_unm+1
c_ass   equ  c_bvn+1
c_int   equ  c_ass+1
c_neg   equ  c_int+1
c_sel   equ  c_neg+1
c_pmt   equ  c_sel+1
c_pr_   equ  c_bvn
c__nv   equ  c_pmt+1
cttyp   equ  0
ctchs   equ  cttyp+1
ctsi_   equ  ctchs+cfp_a
dflen   equ  fargs+1
dfpdl   equ  dflen+1
dfnam   equ  dfpdl+1
dffld   equ  dfnam+1
dfflb   equ  dffld-1
dfsi_   equ  dffld
dvopn   equ  0
dvtyp   equ  dvopn+1
dvlpr   equ  dvtyp+1
dvrpr   equ  dvlpr+1
dvus_   equ  dvlpr+1
dvbs_   equ  dvrpr+1
dvubs   equ  dvus_+dvbs_
rrass   equ  10
llass   equ  00
rrpmt   equ  20
llpmt   equ  30
rramp   equ  40
llamp   equ  50
rralt   equ  70
llalt   equ  60
rrcnc   equ  90
llcnc   equ  80
rrats   equ  110
llats   equ  100
rrplm   equ  120
llplm   equ  130
rrnum   equ  140
llnum   equ  150
rrdvd   equ  160
lldvd   equ  170
rrmlt   equ  180
llmlt   equ  190
rrpct   equ  200
llpct   equ  210
rrexp   equ  230
llexp   equ  220
rrdld   equ  240
lldld   equ  250
rrnot   equ  270
llnot   equ  260
lluno   equ  999
eflen   equ  fargs+1
efuse   equ  eflen+1
efcod   equ  efuse+1
efvar   equ  efcod+1
efrsl   equ  efvar+1
eftar   equ  efrsl+1
efsi_   equ  eftar
evtyp   equ  0
evexp   equ  evtyp+1
evvar   equ  evexp+1
evsi_   equ  evvar+1
extyp   equ  0
exstm   equ  cdstm
exsln   equ  exstm+1
exlen   equ  exsln+1
exflc   equ  exlen+1
excod   equ  exflc+1
exsi_   equ  excod
ffdfp   equ  fargs+1
ffnxt   equ  ffdfp+1
ffofs   equ  ffnxt+1
ffsi_   equ  ffofs+1
icget   equ  0
icval   equ  icget+1
icsi_   equ  icval+cfp_i
kvtyp   equ  0
kvvar   equ  kvtyp+1
kvnum   equ  kvvar+1
kvsi_   equ  kvnum+1
nmtyp   equ  0
nmbas   equ  nmtyp+1
nmofs   equ  nmbas+1
nmsi_   equ  nmofs+1
pcode   equ  0
pthen   equ  pcode+1
pasi_   equ  pthen+1
parm1   equ  pthen+1
pbsi_   equ  parm1+1
parm2   equ  parm1+1
pcsi_   equ  parm2+1
pdtyp   equ  0
pddfp   equ  idval+1
pdfld   equ  pddfp+1
pdfof   equ  dffld-pdfld
pdsi_   equ  pdfld
pddfs   equ  dfsi_-pdsi_
pflen   equ  fargs+1
pfvbl   equ  pflen+1
pfnlo   equ  pfvbl+1
pfcod   equ  pfnlo+1
pfctr   equ  pfcod+1
pfrtr   equ  pfctr+1
pfarg   equ  pfrtr+1
pfagb   equ  pfarg-1
pfsi_   equ  pfarg
rcget   equ  0
rcval   equ  rcget+1
rcsi_   equ  rcval+cfp_r
scget   equ  0
sclen   equ  scget+1
schar   equ  sclen+1
scsi_   equ  schar
setyp   equ  0
sevar   equ  setyp+1
sesi_   equ  sevar+1
svbit   equ  0
svlen   equ  1
svchs   equ  2
svsi_   equ  2
svpre   equ  1
svffc   equ  svpre+svpre
svckw   equ  svffc+svffc
svprd   equ  svckw+svckw
svnbt   equ  4
svknm   equ  svprd+svprd
svfnc   equ  svknm+svknm
svnar   equ  svfnc+svfnc
svlbl   equ  svnar+svnar
svval   equ  svlbl+svlbl
svfnf   equ  svfnc+svnar
svfnn   equ  svfnf+svffc
svfnp   equ  svfnn+svpre
svfpr   equ  svfnn+svprd
svfnk   equ  svfnn+svknm
svkwv   equ  svknm+svval
svkwc   equ  svckw+svknm
svkvc   equ  svkwv+svckw
svkvl   equ  svkvc+svlbl
svfpk   equ  svfnp+svkvc
k_abe   equ  0
k_anc   equ  k_abe+cfp_b
k_cas   equ  k_anc+cfp_b
k_cod   equ  k_cas+cfp_b
k_com   equ  k_cod+cfp_b
k_dmp   equ  k_com+cfp_b
k_erl   equ  k_dmp+cfp_b
k_ert   equ  k_erl+cfp_b
k_ftr   equ  k_ert+cfp_b
k_fls   equ  k_ftr+cfp_b
k_inp   equ  k_fls+cfp_b
k_mxl   equ  k_inp+cfp_b
k_oup   equ  k_mxl+cfp_b
k_pfl   equ  k_oup+cfp_b
k_tra   equ  k_pfl+cfp_b
k_trm   equ  k_tra+cfp_b
k_fnc   equ  k_trm+cfp_b
k_lst   equ  k_fnc+cfp_b
k_lln   equ  k_lst+cfp_b
k_lin   equ  k_lln+cfp_b
k_stn   equ  k_lin+cfp_b
k_abo   equ  k_stn+cfp_b
k_arb   equ  k_abo+pasi_
k_bal   equ  k_arb+pasi_
k_fal   equ  k_bal+pasi_
k_fen   equ  k_fal+pasi_
k_rem   equ  k_fen+pasi_
k_suc   equ  k_rem+pasi_
k_alp   equ  k_suc+1
k_rtn   equ  k_alp+1
k_stc   equ  k_rtn+1
k_etx   equ  k_stc+1
k_fil   equ  k_etx+1
k_lfl   equ  k_fil+1
k_stl   equ  k_lfl+1
k_lcs   equ  k_stl+1
k_ucs   equ  k_lcs+1
k__al   equ  k_alp-k_alp
k__rt   equ  k_rtn-k_alp
k__sc   equ  k_stc-k_alp
k__et   equ  k_etx-k_alp
k__fl   equ  k_fil-k_alp
k__lf   equ  k_lfl-k_alp
k__sl   equ  k_stl-k_alp
k__lc   equ  k_lcs-k_alp
k__uc   equ  k_ucs-k_alp
k__n_   equ  k__uc+1
k_p__   equ  k_fnc
k_v__   equ  k_abo
k_s__   equ  k_alp
tbtyp   equ  0
tblen   equ  offs2
tbinv   equ  offs3
tbbuk   equ  tbinv+1
tbsi_   equ  tbbuk
tbnbk   equ  11
tetyp   equ  0
tesub   equ  tetyp+1
teval   equ  tesub+1
tenxt   equ  teval+1
tesi_   equ  tenxt+1
tridn   equ  0
trtyp   equ  tridn+1
trval   equ  trtyp+1
trnxt   equ  trval
trlbl   equ  trval
trkvr   equ  trval
trtag   equ  trval+1
trter   equ  trtag
trtrf   equ  trtag
trfnc   equ  trtag+1
trfpt   equ  trfnc
trsi_   equ  trfnc+1
trtin   equ  0
trtac   equ  trtin+1
trtvl   equ  trtac+1
trtou   equ  trtvl+1
trtfc   equ  trtou+1
vctyp   equ  0
vclen   equ  offs2
vcvls   equ  offs3
vcsi_   equ  vcvls
vcvlb   equ  vcvls-1
vctbd   equ  tbsi_-vcsi_
vrget   equ  0
vrsto   equ  vrget+1
vrval   equ  vrsto+1
vrvlo   equ  vrval-vrsto
vrtra   equ  vrval+1
vrlbl   equ  vrtra+1
vrlbo   equ  vrlbl-vrtra
vrfnc   equ  vrlbl+1
vrnxt   equ  vrfnc+1
vrlen   equ  vrnxt+1
vrchs   equ  vrlen+1
vrsvp   equ  vrlen+1
vrsi_   equ  vrchs+1
vrsof   equ  vrlen-sclen
vrsvo   equ  vrsvp-vrsof
xntyp   equ  0
xnlen   equ  xntyp+1
xndta   equ  xnlen+1
xnsi_   equ  xndta
xrtyp   equ  0
xrlen   equ  xrtyp+1
xrptr   equ  xrlen+1
xrsi_   equ  xrptr
cnvst   equ  8
cnvrt   equ  cnvst+1
cnvbt   equ  cnvrt
cnvtt   equ  cnvbt+1
iniln   equ  1024
inils   equ  1024
ionmb   equ  2
ionmo   equ  4
mnlen   equ  1024
mxern   equ  329
num01   equ  1
num02   equ  2
num03   equ  3
num04   equ  4
num05   equ  5
num06   equ  6
num07   equ  7
num08   equ  8
num09   equ  9
num10   equ  10
num25   equ  25
nm320   equ  320
nm321   equ  321
nini8   equ  998
nini9   equ  999
thsnd   equ  1000
opbun   equ  5
opuun   equ  6
prsnf   equ  13
prtmf   equ  21
rilen   equ  1024
stgic   equ  0
stgxc   equ  stgic+1
stgev   equ  stgxc+1
stgxt   equ  stgev+1
stgce   equ  stgxt+1
stgxe   equ  stgce+1
stgnd   equ  stgce-stgic
stgee   equ  stgxe+1
stgno   equ  stgee+1
stnpd   equ  8
t_uop   equ  0
t_lpr   equ  t_uop+3
t_lbr   equ  t_lpr+3
t_cma   equ  t_lbr+3
t_fnc   equ  t_cma+3
t_var   equ  t_fnc+3
t_con   equ  t_var+3
t_bop   equ  t_con+3
t_rpr   equ  t_bop+3
t_rbr   equ  t_rpr+3
t_col   equ  t_rbr+3
t_smc   equ  t_col+3
t_fgo   equ  t_smc+1
t_sgo   equ  t_fgo+1
t_uok   equ  t_fnc
t_uo0   equ  t_uop+0
t_uo1   equ  t_uop+1
t_uo2   equ  t_uop+2
t_lp0   equ  t_lpr+0
t_lp1   equ  t_lpr+1
t_lp2   equ  t_lpr+2
t_lb0   equ  t_lbr+0
t_lb1   equ  t_lbr+1
t_lb2   equ  t_lbr+2
t_cm0   equ  t_cma+0
t_cm1   equ  t_cma+1
t_cm2   equ  t_cma+2
t_fn0   equ  t_fnc+0
t_fn1   equ  t_fnc+1
t_fn2   equ  t_fnc+2
t_va0   equ  t_var+0
t_va1   equ  t_var+1
t_va2   equ  t_var+2
t_co0   equ  t_con+0
t_co1   equ  t_con+1
t_co2   equ  t_con+2
t_bo0   equ  t_bop+0
t_bo1   equ  t_bop+1
t_bo2   equ  t_bop+2
t_rp0   equ  t_rpr+0
t_rp1   equ  t_rpr+1
t_rp2   equ  t_rpr+2
t_rb0   equ  t_rbr+0
t_rb1   equ  t_rbr+1
t_rb2   equ  t_rbr+2
t_cl0   equ  t_col+0
t_cl1   equ  t_col+1
t_cl2   equ  t_col+2
t_sm0   equ  t_smc+0
t_sm1   equ  t_smc+1
t_sm2   equ  t_smc+2
t_nes   equ  t_sm2+1
cc_ca   equ  0
cc_do   equ  cc_ca+1
cc_co   equ  cc_do+1
cc_du   equ  cc_co+1
cc_cp   equ  cc_du+1
cc_ej   equ  cc_cp+1
cc_er   equ  cc_ej+1
cc_ex   equ  cc_er+1
cc_fa   equ  cc_ex+1
cc_in   equ  cc_fa+1
cc_ln   equ  cc_in+1
cc_li   equ  cc_ln+1
cc_nr   equ  cc_li+1
cc_nx   equ  cc_nr+1
cc_nf   equ  cc_nx+1
cc_nl   equ  cc_nf+1
cc_no   equ  cc_nl+1
cc_np   equ  cc_no+1
cc_op   equ  cc_np+1
cc_pr   equ  cc_op+1
cc_si   equ  cc_pr+1
cc_sp   equ  cc_si+1
cc_st   equ  cc_sp+1
cc_ti   equ  cc_st+1
cc_tr   equ  cc_ti+1
cc_nc   equ  cc_tr+1
ccnoc   equ  4
ccofs   equ  7
ccinm   equ  9
cmstm   equ  0
cmsgo   equ  cmstm+1
cmfgo   equ  cmsgo+1
cmcgo   equ  cmfgo+1
cmpcd   equ  cmcgo+1
cmffp   equ  cmpcd+1
cmffc   equ  cmffp+1
cmsop   equ  cmffc+1
cmsoc   equ  cmsop+1
cmlbl   equ  cmsoc+1
cmtra   equ  cmlbl+1
cmnen   equ  cmtra+1
pfpd1   equ  8
pfpd2   equ  20
pfpd3   equ  32
pf_i2   equ  cfp_i+cfp_i
rlend   equ  0
rladj   equ  rlend+1
rlstr   equ  rladj+1
rssi_   equ  rlstr+1
rnsi_   equ  5
rldye   equ  0
rldya   equ  rldye+1
rldys   equ  rldya+1
rlste   equ  rldys+1
rlsta   equ  rlste+1
rlsts   equ  rlsta+1
rlwke   equ  rlsts+1
rlwka   equ  rlwke+1
rlwks   equ  rlwka+1
rlcne   equ  rlwks+1
rlcna   equ  rlcne+1
rlcns   equ  rlcna+1
rlcde   equ  rlcns+1
rlcda   equ  rlcde+1
rlcds   equ  rlcda+1
rlsi_   equ  rlcds+1
        segment .data
        global sec03
sec03:
c_aaa:  d_word 0
alfsp:  d_word e_fsp
bits0:  d_word 0
bits1:  d_word 1
bits2:  d_word 2
bits3:  d_word 4
bits4:  d_word 8
bits5:  d_word 16
bits6:  d_word 32
bits7:  d_word 64
bits8:  d_word 128
bits9:  d_word 256
bit10:  d_word 512
bit11:  d_word 1024
bit12:  d_word 2048
bitsm:  d_word 0
btfnc:  d_word svfnc
btknm:  d_word svknm
btlbl:  d_word svlbl
btffc:  d_word svffc
btckw:  d_word svckw
btkwv:  d_word svkwv
btprd:  d_word svprd
btpre:  d_word svpre
btval:  d_word svval
ccnms:  d_char 'c','a','s','e',0,0,0,0
        d_char 'd','o','u','b',0,0,0,0
        d_char 'c','o','m','p',0,0,0,0
        d_char 'd','u','m','p',0,0,0,0
        d_char 'c','o','p','y',0,0,0,0
        d_char 'e','j','e','c',0,0,0,0
        d_char 'e','r','r','o',0,0,0,0
        d_char 'e','x','e','c',0,0,0,0
        d_char 'f','a','i','l',0,0,0,0
        d_char 'i','n','c','l',0,0,0,0
        d_char 'l','i','n','e',0,0,0,0
        d_char 'l','i','s','t',0,0,0,0
        d_char 'n','o','e','r',0,0,0,0
        d_char 'n','o','e','x',0,0,0,0
        d_char 'n','o','f','a',0,0,0,0
        d_char 'n','o','l','i',0,0,0,0
        d_char 'n','o','o','p',0,0,0,0
        d_char 'n','o','p','r',0,0,0,0
        d_char 'o','p','t','i',0,0,0,0
        d_char 'p','r','i','n',0,0,0,0
        d_char 's','i','n','g',0,0,0,0
        d_char 's','p','a','c',0,0,0,0
        d_char 's','t','i','t',0,0,0,0
        d_char 't','i','t','l',0,0,0,0
        d_char 't','r','a','c',0,0,0,0
dmhdk:  d_word b_scl
        d_word 22
        d_char 'd','u','m','p',' ','o','f',' ','k','e','y','w','o','r','d',' ','v','a','l','u','e','s',0,0
dmhdv:  d_word b_scl
        d_word 25
        d_char 'd','u','m','p',' ','o','f',' ','n','a','t','u','r','a','l',' ','v','a','r','i','a','b','l','e','s',0,0,0,0,0,0,0
encm1:  d_word b_scl
        d_word 19
        d_char 'm','e','m','o','r','y',' ','u','s','e','d',' ','(','b','y','t','e','s',')',0,0,0,0,0
encm2:  d_word b_scl
        d_word 19
        d_char 'm','e','m','o','r','y',' ','l','e','f','t',' ','(','b','y','t','e','s',')',0,0,0,0,0
encm3:  d_word b_scl
        d_word 11
        d_char 'c','o','m','p',' ','e','r','r','o','r','s',0,0,0,0,0
encm4:  d_word b_scl
        d_word 20
        d_char 'c','o','m','p',' ','t','i','m','e',' ','(','m','i','l','l','i','s','e','c',')',0,0,0,0
encm5:  d_word b_scl
        d_word 20
        d_char 'e','x','e','c','u','t','i','o','n',' ','s','u','p','p','r','e','s','s','e','d',0,0,0,0
endab:  d_word b_scl
        d_word 12
        d_char 'a','b','n','o','r','m','a','l',' ','e','n','d',0,0,0,0
endmo:  d_word b_scl
endml:  d_word 15
        d_char 'm','e','m','o','r','y',' ','o','v','e','r','f','l','o','w',0
endms:  d_word b_scl
        d_word 10
        d_char 'n','o','r','m','a','l',' ','e','n','d',0,0,0,0,0,0
endso:  d_word b_scl
        d_word 36
        d_char 's','t','a','c','k',' ','o','v','e','r','f','l','o','w',' ','i','n',' ','g','a','r','b','a','g','e',' ','c','o','l','l','e','c','t','i','o','n',0,0,0,0
endtu:  d_word b_scl
        d_word 15
        d_char 'e','r','r','o','r',' ','-',' ','t','i','m','e',' ','u','p',0
ermms:  d_word b_scl
        d_word 5
        d_char 'e','r','r','o','r',0,0,0
ermns:  d_word b_scl
        d_word 4
        d_char ' ','-','-',' ',0,0,0,0
lstms:  d_word b_scl
        d_word 5
        d_char 'p','a','g','e',' ',0,0,0
headr:  d_word b_scl
        d_word 27
        d_char 'm','a','c','r','o',' ','s','p','i','t','b','o','l',' ','v','e','r','s','i','o','n',' ','1','5','.','0','1',0,0,0,0,0
headv:  d_word b_scl
        d_word 5
        d_char '1','5','.','0','1',0,0,0
gbsdp:  d_word e_sed
int_r:  d_word b_icl
intv0:  d_word +0
inton:  d_word b_icl
intv1:  d_word +1
inttw:  d_word b_icl
intv2:  d_word +2
intvt:  d_word +10
intvh:  d_word +100
intth:  d_word +1000
intab:  d_word int_r
        d_word inton
        d_word inttw
ndabb:  d_word p_abb
ndabd:  d_word p_abd
ndarc:  d_word p_arc
ndexb:  d_word p_exb
ndfnb:  d_word p_fnb
ndfnd:  d_word p_fnd
ndexc:  d_word p_exc
ndimb:  d_word p_imb
ndimd:  d_word p_imd
ndnth:  d_word p_nth
ndpab:  d_word p_pab
ndpad:  d_word p_pad
nduna:  d_word p_una
ndabo:  d_word p_abo
        d_word ndnth
ndarb:  d_word p_arb
        d_word ndnth
ndbal:  d_word p_bal
        d_word ndnth
ndfal:  d_word p_fal
        d_word ndnth
ndfen:  d_word p_fen
        d_word ndnth
ndrem:  d_word p_rem
        d_word ndnth
ndsuc:  d_word p_suc
        d_word ndnth
nulls:  d_word b_scl
        d_word 0
nullw:  d_char ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',0,0,0,0,0,0
lcase:  d_word b_scl
        d_word 26
        d_char 'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',0,0,0,0,0,0
ucase:  d_word b_scl
        d_word 26
        d_char 'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',0,0,0,0,0,0
opdvc:  d_word o_cnc
        d_word c_cnc
        d_word llcnc
        d_word rrcnc
opdvp:  d_word o_cnc
        d_word c_cnp
        d_word llcnc
        d_word rrcnc
opdvs:  d_word o_ass
        d_word c_ass
        d_word llass
        d_word rrass
        d_word 6
        d_word c_uuo
        d_word lluno
        d_word o_pmv
        d_word c_pmt
        d_word llpmt
        d_word rrpmt
        d_word o_int
        d_word c_uvl
        d_word lluno
        d_word 1
        d_word c_ubo
        d_word llamp
        d_word rramp
        d_word o_kwv
        d_word c_key
        d_word lluno
        d_word o_alt
        d_word c_alt
        d_word llalt
        d_word rralt
        d_word 5
        d_word c_uuo
        d_word lluno
        d_word 0
        d_word c_ubo
        d_word llats
        d_word rrats
        d_word o_cas
        d_word c_unm
        d_word lluno
        d_word 2
        d_word c_ubo
        d_word llnum
        d_word rrnum
        d_word 7
        d_word c_uuo
        d_word lluno
        d_word o_dvd
        d_word c_bvl
        d_word lldvd
        d_word rrdvd
        d_word 9
        d_word c_uuo
        d_word lluno
        d_word o_mlt
        d_word c_bvl
        d_word llmlt
        d_word rrmlt
        d_word 0
        d_word c_def
        d_word lluno
        d_word 3
        d_word c_ubo
        d_word llpct
        d_word rrpct
        d_word 8
        d_word c_uuo
        d_word lluno
        d_word o_exp
        d_word c_bvl
        d_word llexp
        d_word rrexp
        d_word 10
        d_word c_uuo
        d_word lluno
        d_word o_ima
        d_word c_bvn
        d_word lldld
        d_word rrdld
        d_word o_inv
        d_word c_ind
        d_word lluno
        d_word 4
        d_word c_ubo
        d_word llnot
        d_word rrnot
        d_word 0
        d_word c_neg
        d_word lluno
        d_word o_sub
        d_word c_bvl
        d_word llplm
        d_word rrplm
        d_word o_com
        d_word c_uvl
        d_word lluno
        d_word o_add
        d_word c_bvl
        d_word llplm
        d_word rrplm
        d_word o_aff
        d_word c_uvl
        d_word lluno
        d_word o_pas
        d_word c_bvn
        d_word lldld
        d_word rrdld
        d_word o_nam
        d_word c_unm
        d_word lluno
opdvd:  d_word o_god
        d_word c_uvl
        d_word lluno
opdvn:  d_word o_goc
        d_word c_unm
        d_word lluno
oamn_:  d_word o_amn
oamv_:  d_word o_amv
oaon_:  d_word o_aon
oaov_:  d_word o_aov
ocer_:  d_word o_cer
ofex_:  d_word o_fex
ofif_:  d_word o_fif
ofnc_:  d_word o_fnc
ofne_:  d_word o_fne
ofns_:  d_word o_fns
ogof_:  d_word o_gof
oinn_:  d_word o_inn
okwn_:  d_word o_kwn
olex_:  d_word o_lex
olpt_:  d_word o_lpt
olvn_:  d_word o_lvn
onta_:  d_word o_nta
ontb_:  d_word o_ntb
ontc_:  d_word o_ntc
opmn_:  d_word o_pmn
opms_:  d_word o_pms
opop_:  d_word o_pop
ornm_:  d_word o_rnm
orpl_:  d_word o_rpl
orvl_:  d_word o_rvl
osla_:  d_word o_sla
oslb_:  d_word o_slb
oslc_:  d_word o_slc
osld_:  d_word o_sld
ostp_:  d_word o_stp
ounf_:  d_word o_unf
opsnb:  d_word ch_at
        d_word ch_am
        d_word ch_nm
        d_word ch_pc
        d_word ch_nt
opnsu:  d_word ch_br
        d_word ch_eq
        d_word ch_nm
        d_word ch_pc
        d_word ch_sl
        d_word ch_ex
pfi2a:  d_word pf_i2
pfms1:  d_word b_scl
        d_word 15
        d_char 'p','r','o','g','r','a','m',' ','p','r','o','f','i','l','e',0
pfms2:  d_word b_scl
        d_word 42
        d_char 's','t','m','t',' ',' ',' ',' ','n','u','m','b','e','r',' ','o','f',' ',' ',' ',' ',' ','-','-',' ','e','x','e','c','u','t','i','o','n',' ','t','i','m','e',' ','-','-',0,0,0,0,0,0
pfms3:  d_word b_scl
        d_word 47
        d_char 'n','u','m','b','e','r',' ',' ','e','x','e','c','u','t','i','o','n','s',' ',' ','t','o','t','a','l','(','m','s','e','c',')',' ','p','e','r',' ','e','x','c','n','(','m','c','s','e','c',')',0
        align 8
reav0:  d_real 0.0
        align 8
reap1:  d_real 0.1
        align 8
reap5:  d_real 0.5
        align 8
reav1:  d_real 1.0
        align 8
reavt:  d_real 1.0e+1
        align 8
        d_real 1.0e+2
        align 8
        d_real 1.0e+3
        align 8
        d_real 1.0e+4
        align 8
        d_real 1.0e+5
        align 8
        d_real 1.0e+6
        align 8
        d_real 1.0e+7
        align 8
        d_real 1.0e+8
        align 8
        d_real 1.0e+9
        align 8
reatt:  d_real 1.0e+10
scarr:  d_word b_scl
        d_word 5
        d_char 'a','r','r','a','y',0,0,0
sccod:  d_word b_scl
        d_word 4
        d_char 'c','o','d','e',0,0,0,0
scexp:  d_word b_scl
        d_word 10
        d_char 'e','x','p','r','e','s','s','i','o','n',0,0,0,0,0,0
scext:  d_word b_scl
        d_word 8
        d_char 'e','x','t','e','r','n','a','l'
scint:  d_word b_scl
        d_word 7
        d_char 'i','n','t','e','g','e','r',0
scnam:  d_word b_scl
        d_word 4
        d_char 'n','a','m','e',0,0,0,0
scnum:  d_word b_scl
        d_word 7
        d_char 'n','u','m','e','r','i','c',0
scpat:  d_word b_scl
        d_word 7
        d_char 'p','a','t','t','e','r','n',0
screa:  d_word b_scl
        d_word 4
        d_char 'r','e','a','l',0,0,0,0
scstr:  d_word b_scl
        d_word 6
        d_char 's','t','r','i','n','g',0,0
sctab:  d_word b_scl
        d_word 5
        d_char 't','a','b','l','e',0,0,0
scfil:  d_word b_scl
        d_word 4
        d_char 'f','i','l','e',0,0,0,0
scfrt:  d_word b_scl
        d_word 7
        d_char 'f','r','e','t','u','r','n',0
scnrt:  d_word b_scl
        d_word 7
        d_char 'n','r','e','t','u','r','n',0
scrtn:  d_word b_scl
        d_word 6
        d_char 'r','e','t','u','r','n',0,0
scnmt:  d_word scarr
        d_word sccod
        d_word scexp
        d_word scint
        d_word scnam
        d_word scpat
        d_word scpat
        d_word scpat
        d_word screa
        d_word scstr
        d_word scexp
        d_word sctab
        d_word scarr
        d_word scext
        d_word scext
        d_word nulls
scre0:  d_word b_scl
        d_word 2
        d_char '0','.',0,0,0,0,0,0
stlim:  d_word +2147483647
stndf:  d_word o_fun
        d_word 0
stndl:  d_word l_und
stndo:  d_word o_oun
        d_word 0
stnvr:  d_word b_vrl
        d_word b_vrs
        d_word nulls
        d_word b_vrg
        d_word stndl
        d_word stndf
        d_word 0
stpm1:  d_word b_scl
        d_word 12
        d_char 'i','n',' ','s','t','a','t','e','m','e','n','t',0,0,0,0
stpm2:  d_word b_scl
        d_word 14
        d_char 's','t','m','t','s',' ','e','x','e','c','u','t','e','d',0,0
stpm3:  d_word b_scl
        d_word 19
        d_char 'r','u','n',' ','t','i','m','e',' ','(','m','i','l','l','i','s','e','c',')',0,0,0,0,0
stpm4:  d_word b_scl
        d_word 12
        d_char 'm','c','s','e','c',' ','/',' ','s','t','m','t',0,0,0,0
stpm5:  d_word b_scl
        d_word 13
        d_char 'r','e','g','e','n','e','r','a','t','i','o','n','s',0,0,0
stpm6:  d_word b_scl
        d_word 7
        d_char 'i','n',' ','l','i','n','e',0
stpm7:  d_word b_scl
        d_word 7
        d_char 'i','n',' ','f','i','l','e',0
strtu:  d_char 't','u',0,0,0,0,0,0
svctb:  d_word scstr
        d_word scint
        d_word scnam
        d_word scpat
        d_word scarr
        d_word sctab
        d_word scexp
        d_word sccod
        d_word scnum
        d_word screa
        d_word 0
tmasb:  d_word b_scl
        d_word 13
        d_char '*','*','*','*','*','*','*','*','*','*','*','*',' ',0,0,0
tmbeb:  d_word b_scl
        d_word 3
        d_char ' ','=',' ',0,0,0,0,0
trbev:  d_word b_trt
trbkv:  d_word b_trt
trxdr:  d_word o_txr
trxdc:  d_word trxdr
v_eqf:  d_word svfpr
        d_word 2
        d_char 'e','q',0,0,0,0,0,0
        d_word s_eqf
        d_word 2
v_gef:  d_word svfpr
        d_word 2
        d_char 'g','e',0,0,0,0,0,0
        d_word s_gef
        d_word 2
v_gtf:  d_word svfpr
        d_word 2
        d_char 'g','t',0,0,0,0,0,0
        d_word s_gtf
        d_word 2
v_lef:  d_word svfpr
        d_word 2
        d_char 'l','e',0,0,0,0,0,0
        d_word s_lef
        d_word 2
v_lnf:  d_word svfnp
        d_word 2
        d_char 'l','n',0,0,0,0,0,0
        d_word s_lnf
        d_word 1
v_ltf:  d_word svfpr
        d_word 2
        d_char 'l','t',0,0,0,0,0,0
        d_word s_ltf
        d_word 2
v_nef:  d_word svfpr
        d_word 2
        d_char 'n','e',0,0,0,0,0,0
        d_word s_nef
        d_word 2
v_any:  d_word svfnp
        d_word 3
        d_char 'a','n','y',0,0,0,0,0
        d_word s_any
        d_word 1
v_arb:  d_word svkvc
        d_word 3
        d_char 'a','r','b',0,0,0,0,0
        d_word k_arb
        d_word ndarb
v_arg:  d_word svfnn
        d_word 3
        d_char 'a','r','g',0,0,0,0,0
        d_word s_arg
        d_word 2
v_bal:  d_word svkvc
        d_word 3
        d_char 'b','a','l',0,0,0,0,0
        d_word k_bal
        d_word ndbal
v_cos:  d_word svfnp
        d_word 3
        d_char 'c','o','s',0,0,0,0,0
        d_word s_cos
        d_word 1
v_end:  d_word svlbl
        d_word 3
        d_char 'e','n','d',0,0,0,0,0
        d_word l_end
v_exp:  d_word svfnp
        d_word 3
        d_char 'e','x','p',0,0,0,0,0
        d_word s_exp
        d_word 1
v_len:  d_word svfnp
        d_word 3
        d_char 'l','e','n',0,0,0,0,0
        d_word s_len
        d_word 1
v_leq:  d_word svfpr
        d_word 3
        d_char 'l','e','q',0,0,0,0,0
        d_word s_leq
        d_word 2
v_lge:  d_word svfpr
        d_word 3
        d_char 'l','g','e',0,0,0,0,0
        d_word s_lge
        d_word 2
v_lgt:  d_word svfpr
        d_word 3
        d_char 'l','g','t',0,0,0,0,0
        d_word s_lgt
        d_word 2
v_lle:  d_word svfpr
        d_word 3
        d_char 'l','l','e',0,0,0,0,0
        d_word s_lle
        d_word 2
v_llt:  d_word svfpr
        d_word 3
        d_char 'l','l','t',0,0,0,0,0
        d_word s_llt
        d_word 2
v_lne:  d_word svfpr
        d_word 3
        d_char 'l','n','e',0,0,0,0,0
        d_word s_lne
        d_word 2
v_pos:  d_word svfnp
        d_word 3
        d_char 'p','o','s',0,0,0,0,0
        d_word s_pos
        d_word 1
v_rem:  d_word svkvc
        d_word 3
        d_char 'r','e','m',0,0,0,0,0
        d_word k_rem
        d_word ndrem
v_set:  d_word svfnn
        d_word 3
        d_char 's','e','t',0,0,0,0,0
        d_word s_set
        d_word 3
v_sin:  d_word svfnp
        d_word 3
        d_char 's','i','n',0,0,0,0,0
        d_word s_sin
        d_word 1
v_tab:  d_word svfnp
        d_word 3
        d_char 't','a','b',0,0,0,0,0
        d_word s_tab
        d_word 1
v_tan:  d_word svfnp
        d_word 3
        d_char 't','a','n',0,0,0,0,0
        d_word s_tan
        d_word 1
v_atn:  d_word svfnp
        d_word 4
        d_char 'a','t','a','n',0,0,0,0
        d_word s_atn
        d_word 1
v_cas:  d_word svknm
        d_word 4
        d_char 'c','a','s','e',0,0,0,0
        d_word k_cas
v_chr:  d_word svfnp
        d_word 4
        d_char 'c','h','a','r',0,0,0,0
        d_word s_chr
        d_word 1
v_chp:  d_word svfnp
        d_word 4
        d_char 'c','h','o','p',0,0,0,0
        d_word s_chp
        d_word 1
v_cod:  d_word svfnk
        d_word 4
        d_char 'c','o','d','e',0,0,0,0
        d_word k_cod
        d_word s_cod
        d_word 1
v_cop:  d_word svfnn
        d_word 4
        d_char 'c','o','p','y',0,0,0,0
        d_word s_cop
        d_word 1
v_dat:  d_word svfnn
        d_word 4
        d_char 'd','a','t','a',0,0,0,0
        d_word s_dat
        d_word 1
v_dte:  d_word svfnn
        d_word 4
        d_char 'd','a','t','e',0,0,0,0
        d_word s_dte
        d_word 1
v_dmp:  d_word svfnk
        d_word 4
        d_char 'd','u','m','p',0,0,0,0
        d_word k_dmp
        d_word s_dmp
        d_word 1
v_dup:  d_word svfnn
        d_word 4
        d_char 'd','u','p','l',0,0,0,0
        d_word s_dup
        d_word 2
v_evl:  d_word svfnn
        d_word 4
        d_char 'e','v','a','l',0,0,0,0
        d_word s_evl
        d_word 1
v_ext:  d_word svfnn
        d_word 4
        d_char 'e','x','i','t',0,0,0,0
        d_word s_ext
        d_word 2
v_fal:  d_word svkvc
        d_word 4
        d_char 'f','a','i','l',0,0,0,0
        d_word k_fal
        d_word ndfal
v_fil:  d_word svknm
        d_word 4
        d_char 'f','i','l','e',0,0,0,0
        d_word k_fil
v_hst:  d_word svfnn
        d_word 4
        d_char 'h','o','s','t',0,0,0,0
        d_word s_hst
        d_word 5
v_itm:  d_word svfnf
        d_word 4
        d_char 'i','t','e','m',0,0,0,0
        d_word s_itm
        d_word 999
v_lin:  d_word svknm
        d_word 4
        d_char 'l','i','n','e',0,0,0,0
        d_word k_lin
v_lod:  d_word svfnn
        d_word 4
        d_char 'l','o','a','d',0,0,0,0
        d_word s_lod
        d_word 2
v_lpd:  d_word svfnp
        d_word 4
        d_char 'l','p','a','d',0,0,0,0
        d_word s_lpd
        d_word 3
v_rpd:  d_word svfnp
        d_word 4
        d_char 'r','p','a','d',0,0,0,0
        d_word s_rpd
        d_word 3
v_rps:  d_word svfnp
        d_word 4
        d_char 'r','p','o','s',0,0,0,0
        d_word s_rps
        d_word 1
v_rtb:  d_word svfnp
        d_word 4
        d_char 'r','t','a','b',0,0,0,0
        d_word s_rtb
        d_word 1
v_si_:  d_word svfnp
        d_word 4
        d_char 's','i','z','e',0,0,0,0
        d_word s_si_
        d_word 1
v_srt:  d_word svfnn
        d_word 4
        d_char 's','o','r','t',0,0,0,0
        d_word s_srt
        d_word 2
v_spn:  d_word svfnp
        d_word 4
        d_char 's','p','a','n',0,0,0,0
        d_word s_spn
        d_word 1
v_sqr:  d_word svfnp
        d_word 4
        d_char 's','q','r','t',0,0,0,0
        d_word s_sqr
        d_word 1
v_stn:  d_word svknm
        d_word 4
        d_char 's','t','n','o',0,0,0,0
        d_word k_stn
v_tim:  d_word svfnn
        d_word 4
        d_char 't','i','m','e',0,0,0,0
        d_word s_tim
        d_word 0
v_trm:  d_word svfnk
        d_word 4
        d_char 't','r','i','m',0,0,0,0
        d_word k_trm
        d_word s_trm
        d_word 1
v_abe:  d_word svknm
        d_word 5
        d_char 'a','b','e','n','d',0,0,0
        d_word k_abe
v_abo:  d_word svkvl
        d_word 5
        d_char 'a','b','o','r','t',0,0,0
        d_word k_abo
        d_word l_abo
        d_word ndabo
v_app:  d_word svfnf
        d_word 5
        d_char 'a','p','p','l','y',0,0,0
        d_word s_app
        d_word 999
v_abn:  d_word svfnp
        d_word 5
        d_char 'a','r','b','n','o',0,0,0
        d_word s_abn
        d_word 1
v_arr:  d_word svfnn
        d_word 5
        d_char 'a','r','r','a','y',0,0,0
        d_word s_arr
        d_word 2
v_brk:  d_word svfnp
        d_word 5
        d_char 'b','r','e','a','k',0,0,0
        d_word s_brk
        d_word 1
v_clr:  d_word svfnn
        d_word 5
        d_char 'c','l','e','a','r',0,0,0
        d_word s_clr
        d_word 1
v_ejc:  d_word svfnn
        d_word 5
        d_char 'e','j','e','c','t',0,0,0
        d_word s_ejc
        d_word 1
v_fen:  d_word svfpk
        d_word 5
        d_char 'f','e','n','c','e',0,0,0
        d_word k_fen
        d_word s_fnc
        d_word 1
        d_word ndfen
v_fld:  d_word svfnn
        d_word 5
        d_char 'f','i','e','l','d',0,0,0
        d_word s_fld
        d_word 2
v_idn:  d_word svfpr
        d_word 5
        d_char 'i','d','e','n','t',0,0,0
        d_word s_idn
        d_word 2
v_inp:  d_word svfnk
        d_word 5
        d_char 'i','n','p','u','t',0,0,0
        d_word k_inp
        d_word s_inp
        d_word 3
v_lcs:  d_word svkwc
        d_word 5
        d_char 'l','c','a','s','e',0,0,0
        d_word k_lcs
v_loc:  d_word svfnn
        d_word 5
        d_char 'l','o','c','a','l',0,0,0
        d_word s_loc
        d_word 2
v_ops:  d_word svfnn
        d_word 5
        d_char 'o','p','s','y','n',0,0,0
        d_word s_ops
        d_word 3
v_rmd:  d_word svfnp
        d_word 5
        d_char 'r','e','m','d','r',0,0,0
        d_word s_rmd
        d_word 2
v_rsr:  d_word svfnn
        d_word 5
        d_char 'r','s','o','r','t',0,0,0
        d_word s_rsr
        d_word 2
v_tbl:  d_word svfnn
        d_word 5
        d_char 't','a','b','l','e',0,0,0
        d_word s_tbl
        d_word 3
v_tra:  d_word svfnk
        d_word 5
        d_char 't','r','a','c','e',0,0,0
        d_word k_tra
        d_word s_tra
        d_word 4
v_ucs:  d_word svkwc
        d_word 5
        d_char 'u','c','a','s','e',0,0,0
        d_word k_ucs
v_anc:  d_word svknm
        d_word 6
        d_char 'a','n','c','h','o','r',0,0
        d_word k_anc
v_bkx:  d_word svfnp
        d_word 6
        d_char 'b','r','e','a','k','x',0,0
        d_word s_bkx
        d_word 1
v_def:  d_word svfnn
        d_word 6
        d_char 'd','e','f','i','n','e',0,0
        d_word s_def
        d_word 2
v_det:  d_word svfnn
        d_word 6
        d_char 'd','e','t','a','c','h',0,0
        d_word s_det
        d_word 1
v_dif:  d_word svfpr
        d_word 6
        d_char 'd','i','f','f','e','r',0,0
        d_word s_dif
        d_word 2
v_ftr:  d_word svknm
        d_word 6
        d_char 'f','t','r','a','c','e',0,0
        d_word k_ftr
v_lst:  d_word svknm
        d_word 6
        d_char 'l','a','s','t','n','o',0,0
        d_word k_lst
v_nay:  d_word svfnp
        d_word 6
        d_char 'n','o','t','a','n','y',0,0
        d_word s_nay
        d_word 1
v_oup:  d_word svfnk
        d_word 6
        d_char 'o','u','t','p','u','t',0,0
        d_word k_oup
        d_word s_oup
        d_word 3
v_ret:  d_word svlbl
        d_word 6
        d_char 'r','e','t','u','r','n',0,0
        d_word l_rtn
v_rew:  d_word svfnn
        d_word 6
        d_char 'r','e','w','i','n','d',0,0
        d_word s_rew
        d_word 1
v_stt:  d_word svfnn
        d_word 6
        d_char 's','t','o','p','t','r',0,0
        d_word s_stt
        d_word 2
v_sub:  d_word svfnn
        d_word 6
        d_char 's','u','b','s','t','r',0,0
        d_word s_sub
        d_word 3
v_unl:  d_word svfnn
        d_word 6
        d_char 'u','n','l','o','a','d',0,0
        d_word s_unl
        d_word 1
v_col:  d_word svfnn
        d_word 7
        d_char 'c','o','l','l','e','c','t',0
        d_word s_col
        d_word 1
v_com:  d_word svknm
        d_word 7
        d_char 'c','o','m','p','a','r','e',0
        d_word k_com
v_cnv:  d_word svfnn
        d_word 7
        d_char 'c','o','n','v','e','r','t',0
        d_word s_cnv
        d_word 2
v_enf:  d_word svfnn
        d_word 7
        d_char 'e','n','d','f','i','l','e',0
        d_word s_enf
        d_word 1
v_etx:  d_word svknm
        d_word 7
        d_char 'e','r','r','t','e','x','t',0
        d_word k_etx
v_ert:  d_word svknm
        d_word 7
        d_char 'e','r','r','t','y','p','e',0
        d_word k_ert
v_frt:  d_word svlbl
        d_word 7
        d_char 'f','r','e','t','u','r','n',0
        d_word l_frt
v_int:  d_word svfpr
        d_word 7
        d_char 'i','n','t','e','g','e','r',0
        d_word s_int
        d_word 1
v_nrt:  d_word svlbl
        d_word 7
        d_char 'n','r','e','t','u','r','n',0
        d_word l_nrt
v_pfl:  d_word svknm
        d_word 7
        d_char 'p','r','o','f','i','l','e',0
        d_word k_pfl
v_rpl:  d_word svfnp
        d_word 7
        d_char 'r','e','p','l','a','c','e',0
        d_word s_rpl
        d_word 3
v_rvs:  d_word svfnp
        d_word 7
        d_char 'r','e','v','e','r','s','e',0
        d_word s_rvs
        d_word 1
v_rtn:  d_word svknm
        d_word 7
        d_char 'r','t','n','t','y','p','e',0
        d_word k_rtn
v_stx:  d_word svfnn
        d_word 7
        d_char 's','e','t','e','x','i','t',0
        d_word s_stx
        d_word 1
v_stc:  d_word svknm
        d_word 7
        d_char 's','t','c','o','u','n','t',0
        d_word k_stc
v_stl:  d_word svknm
        d_word 7
        d_char 's','t','l','i','m','i','t',0
        d_word k_stl
v_suc:  d_word svkvc
        d_word 7
        d_char 's','u','c','c','e','e','d',0
        d_word k_suc
        d_word ndsuc
v_alp:  d_word svkwc
        d_word 8
        d_char 'a','l','p','h','a','b','e','t'
        d_word k_alp
v_cnt:  d_word svlbl
        d_word 8
        d_char 'c','o','n','t','i','n','u','e'
        d_word l_cnt
v_dtp:  d_word svfnp
        d_word 8
        d_char 'd','a','t','a','t','y','p','e'
        d_word s_dtp
        d_word 1
v_erl:  d_word svknm
        d_word 8
        d_char 'e','r','r','l','i','m','i','t'
        d_word k_erl
v_fnc:  d_word svknm
        d_word 8
        d_char 'f','n','c','l','e','v','e','l'
        d_word k_fnc
v_fls:  d_word svknm
        d_word 8
        d_char 'f','u','l','l','s','c','a','n'
        d_word k_fls
v_lfl:  d_word svknm
        d_word 8
        d_char 'l','a','s','t','f','i','l','e'
        d_word k_lfl
v_lln:  d_word svknm
        d_word 8
        d_char 'l','a','s','t','l','i','n','e'
        d_word k_lln
v_mxl:  d_word svknm
        d_word 8
        d_char 'm','a','x','l','n','g','t','h'
        d_word k_mxl
v_ter:  d_word 0
        d_word 8
        d_char 't','e','r','m','i','n','a','l'
        d_word 0
v_bsp:  d_word svfnn
        d_word 9
        d_char 'b','a','c','k','s','p','a','c','e',0,0,0,0,0,0,0
        d_word s_bsp
        d_word 1
v_pro:  d_word svfnn
        d_word 9
        d_char 'p','r','o','t','o','t','y','p','e',0,0,0,0,0,0,0
        d_word s_pro
        d_word 1
v_scn:  d_word svlbl
        d_word 9
        d_char 's','c','o','n','t','i','n','u','e',0,0,0,0,0,0,0
        d_word l_scn
        d_word 0
        d_word 10
vdmkw:  d_word v_anc
        d_word v_cas
        d_word v_cod
        d_word 1
        d_word v_dmp
        d_word v_erl
        d_word v_etx
        d_word v_ert
        d_word v_fil
        d_word v_fnc
        d_word v_ftr
        d_word v_fls
        d_word v_inp
        d_word v_lfl
        d_word v_lln
        d_word v_lst
        d_word v_lin
        d_word v_mxl
        d_word v_oup
        d_word v_pfl
        d_word v_rtn
        d_word v_stc
        d_word v_stl
        d_word v_stn
        d_word v_tra
        d_word v_trm
        d_word 0
vsrch:  d_word 0
        d_word v_eqf
        d_word v_eqf
        d_word v_any
        d_word v_atn
        d_word v_abe
        d_word v_anc
        d_word v_col
        d_word v_alp
        d_word v_bsp
c_yyy:  d_word 0
        global esec03
esec03:
        segment .data
        global sec04
sec04:
cmlab:  d_word b_scl
        d_word 2
        d_char ' ',' ',0,0,0,0,0,0
w_aaa:  d_word 0
actrm:  d_word 0
aldyn:  d_word 0
allia:  d_word +0
allsv:  d_word 0
alsta:  d_word 0
arcdm:  d_word 0
arnel:  d_word +0
arptr:  d_word 0
arsvl:  d_word +0
arfsi:  d_word +0
arfxs:  d_word 0
befof:  d_word 0
bpfpf:  d_word 0
bpfsv:  d_word 0
bpfxt:  d_word 0
clsvi:  d_word +0
cnscc:  d_word 0
cnswc:  d_word 0
cnr_t:  d_word 0
cnvtp:  d_word 0
datdv:  d_word 0
datxs:  d_word 0
deflb:  d_word 0
defna:  d_word 0
defvr:  d_word 0
defxs:  d_word 0
dmarg:  d_word 0
dmpsa:  d_word 0
dmpsb:  d_word 0
dmpsv:  d_word 0
dmvch:  d_word 0
dmpch:  d_word 0
dmpkb:  d_word 0
dmpkt:  d_word 0
dmpkn:  d_word 0
dtcnb:  d_word 0
dtcnm:  d_word 0
dupsi:  d_word +0
enfch:  d_word 0
ertwa:  d_word 0
ertwb:  d_word 0
evlin:  d_word 0
evlis:  d_word 0
evliv:  d_word 0
evlio:  d_word 0
evlif:  d_word 0
expsv:  d_word 0
gbcfl:  d_word 0
gbclm:  d_word 0
gbcnm:  d_word 0
gbcns:  d_word 0
gbcia:  d_word +0
gbcsd:  d_word 0
gbcsf:  d_word 0
gbsva:  d_word 0
gbsvb:  d_word 0
gbsvc:  d_word 0
gnvhe:  d_word 0
gnvnw:  d_word 0
gnvsa:  d_word 0
gnvsb:  d_word 0
gnvsp:  d_word 0
gnvst:  d_word 0
gtawa:  d_word 0
gtina:  d_word 0
gtinb:  d_word 0
gtnnf:  d_word 0
gtnsi:  d_word +0
gtndf:  d_word 0
gtnes:  d_word 0
gtnex:  d_word +0
gtnsc:  d_word 0
        align 8
gtnsr:  d_real 0.0
gtnrd:  d_word 0
gtpsb:  d_word 0
gtssf:  d_word 0
gtsvc:  d_word 0
gtsvb:  d_word 0
gtses:  d_word 0
        align 8
gtsrs:  d_real 0.0
gtvrc:  d_word 0
ioptt:  d_word 0
lodfn:  d_word 0
lodna:  d_word 0
mxint:  d_word 0
pfsvw:  d_word 0
prnsi:  d_word +0
prsna:  d_word 0
prsva:  d_word 0
prsvb:  d_word 0
prsvc:  d_word 0
prtsa:  d_word 0
prtsb:  d_word 0
prvsi:  d_word 0
psave:  d_word 0
psavc:  d_word 0
rlals:  d_word 0
rldcd:  d_word 0
rldst:  d_word 0
rldls:  d_word 0
rtnbp:  d_word 0
rtnfv:  d_word 0
rtnsv:  d_word 0
sbssv:  d_word 0
scnsa:  d_word 0
scnsb:  d_word 0
scnsc:  d_word 0
scnof:  d_word 0
srtdf:  d_word 0
srtfd:  d_word 0
srtff:  d_word 0
srtfo:  d_word 0
srtnr:  d_word 0
srtof:  d_word 0
srtrt:  d_word 0
srts1:  d_word 0
srts2:  d_word 0
srtsc:  d_word 0
srtsf:  d_word 0
srtsn:  d_word 0
srtso:  d_word 0
srtsr:  d_word 0
srtst:  d_word 0
srtwc:  d_word 0
stpsi:  d_word +0
stpti:  d_word +0
tfnsi:  d_word +0
xscrt:  d_word 0
xscwb:  d_word 0
g_aaa:  d_word 0
alfsf:  d_word +0
cmerc:  d_word 0
cmpln:  d_word 0
cmpxs:  d_word 0
cmpsn:  d_word 1
cnsil:  d_word 0
cnind:  d_word 0
cnspt:  d_word 0
cnttl:  d_word 0
cpsts:  d_word 0
cswdb:  d_word 0
cswer:  d_word 0
cswex:  d_word 0
cswfl:  d_word 1
cswin:  d_word iniln
cswls:  d_word 1
cswno:  d_word 0
cswpr:  d_word 0
ctmsk:  d_word 0
curid:  d_word 0
cwcof:  d_word 0
dnams:  d_word 0
erich:  d_word 0
erlst:  d_word 0
errft:  d_word 0
errsp:  d_word 0
exsts:  d_word 0
flprt:  d_word 0
flptr:  d_word 0
gbsed:  d_word +0
gbcnt:  d_word 0
gtcef:  d_word 0
        align 8
gtsrn:  d_real 0.0
        align 8
gtssc:  d_real 0.0
gtswk:  d_word 0
headp:  d_word 0
hshnb:  d_word +0
initr:  d_word 0
kvabe:  d_word 0
kvanc:  d_word 0
kvcas:  d_word 0
kvcod:  d_word 0
kvcom:  d_word 0
kvdmp:  d_word 0
kverl:  d_word 0
kvert:  d_word 0
kvftr:  d_word 0
kvfls:  d_word 1
kvinp:  d_word 1
kvmxl:  d_word 5000
kvoup:  d_word 1
kvpfl:  d_word 0
kvtra:  d_word 0
kvtrm:  d_word 0
kvfnc:  d_word 0
kvlst:  d_word 0
kvlln:  d_word 0
kvlin:  d_word 0
kvstn:  d_word 0
kvalp:  d_word 0
kvrtn:  d_word nulls
kvstl:  d_word +2147483647
kvstc:  d_word +2147483647
lstid:  d_word 0
lstlc:  d_word 0
lstnp:  d_word 0
lstpf:  d_word 1
lstpg:  d_word 0
lstpo:  d_word 0
lstsn:  d_word 0
mxlen:  d_word 0
noxeq:  d_word 0
pfdmp:  d_word 0
pffnc:  d_word 0
pfstm:  d_word +0
pfetm:  d_word +0
pfnte:  d_word 0
pfste:  d_word +0
pmdfl:  d_word 0
pmhbs:  d_word 0
pmssl:  d_word 0
polcs:  d_word 1
polct:  d_word 1
prich:  d_word 0
prstd:  d_word 0
prsto:  d_word 0
prbuf:  d_word 0
precl:  d_word 0
prlen:  d_word 0
prlnw:  d_word 0
profs:  d_word 0
prtef:  d_word 0
rdcln:  d_word 0
rdnln:  d_word 0
rsmem:  d_word 0
stmcs:  d_word 1
stmct:  d_word 1
a_aaa:  d_word 0
cmpss:  d_word 0
dnamb:  d_word 0
dnamp:  d_word 0
dname:  d_word 0
hshtb:  d_word 0
hshte:  d_word 0
iniss:  d_word 0
pftbl:  d_word 0
prnmv:  d_word 0
statb:  d_word 0
state:  d_word 0
stxvr:  d_word nulls
r_aaa:  d_word 0
r_arf:  d_word 0
r_ccb:  d_word 0
r_cim:  d_word 0
r_cmp:  d_word 0
r_cni:  d_word 0
r_cnt:  d_word 0
r_cod:  d_word 0
r_ctp:  d_word 0
r_cts:  d_word 0
r_ert:  d_word 0
r_etx:  d_word nulls
r_exs:  d_word 0
r_fcb:  d_word 0
r_fnc:  d_word 0
r_gtc:  d_word 0
r_ici:  d_word 0
r_ifa:  d_word 0
r_ifl:  d_word 0
r_ifn:  d_word 0
r_inc:  d_word 0
r_io1:  d_word 0
r_io2:  d_word 0
r_iof:  d_word 0
r_ion:  d_word 0
r_iop:  d_word 0
r_iot:  d_word 0
r_pms:  d_word 0
r_ra2:  d_word 0
r_ra3:  d_word 0
r_rpt:  d_word 0
r_scp:  d_word 0
r_sfc:  d_word nulls
r_sfn:  d_word 0
r_sxl:  d_word 0
r_sxr:  d_word 0
r_stc:  d_word 0
r_stl:  d_word 0
r_sxc:  d_word 0
r_ttl:  d_word nulls
r_xsc:  d_word 0
r_uba:  d_word stndo
r_ubm:  d_word stndo
r_ubn:  d_word stndo
r_ubp:  d_word stndo
r_ubt:  d_word stndo
r_uub:  d_word stndo
r_uue:  d_word stndo
r_uun:  d_word stndo
r_uup:  d_word stndo
r_uus:  d_word stndo
r_uux:  d_word stndo
r_yyy:  d_word 0
scnbl:  d_word 0
scncc:  d_word 0
scngo:  d_word 0
scnil:  d_word 0
scnpt:  d_word 0
scnrs:  d_word 0
scnse:  d_word 0
scntp:  d_word 0
stage:  d_word 0
stbas:  d_word 0
stxoc:  d_word 0
stxof:  d_word 0
timsx:  d_word +0
timup:  d_word 0
xsofs:  d_word 0
w_yyy:  d_word 0
        global esec04
esec04:
        prc_: times 19 dd 0
        global lowspmin
lowspmin: d_word 0
        global end_min_data
end_min_data:
        segment .text
        global sec05
sec05:
	align	2
	db	bl__i
s_aaa:
relaj:
        push xr
        push wa
        mov  m_word [REL rlals],xl
        mov  xr,wb
rlaj0:
        mov  xl,m_word [REL rlals]
        cmp  xr,m_word [ xs]
        jne  rlaj1
        pop  wa
        pop  xr
        ret
rlaj1:
        mov  wa,m_word [ xr]
        mov  wb,rnsi_
rlaj2:
        cmp  wa,m_word [REL (cfp_b*rlend)+xl]
        ja   rlaj3
        cmp  wa,m_word [REL (cfp_b*rlstr)+xl]
        jb   rlaj3
        add  wa,m_word [REL (cfp_b*rladj)+xl]
        mov  m_word [ xr],wa
        jmp  rlaj4
rlaj3:
        add  xl,cfp_b*rssi_
        dec  wb
        jnz  rlaj2
rlaj4:
        add  xr,cfp_b
        jmp  rlaj0
relcr:
        add  xl,cfp_b*rlsi_
        lea  xl,[xl-cfp_b]
        mov  m_word [xl],wa
        mov  wa,s_aaa
        sub  wa,m_word [ xl]
        lea  xl,[xl-cfp_b]
        mov  m_word [xl],wa
        mov  wa,s_yyy
        sub  wa,s_aaa
        add  wa,m_word [REL (cfp_b*num01)+xl]
        lea  xl,[xl-cfp_b]
        mov  m_word [xl],wa
        lea  xl,[xl-cfp_b]
        mov  m_word [xl],wb
        mov  wb,c_aaa
        mov  wa,c_yyy
        sub  wa,wb
        sub  wb,m_word [ xl]
        lea  xl,[xl-cfp_b]
        mov  m_word [xl],wb
        add  wa,m_word [REL (cfp_b*num01)+xl]
        lea  xl,[xl-cfp_b]
        mov  m_word [xl],wa
        lea  xl,[xl-cfp_b]
        mov  m_word [xl],wc
        mov  wc,g_aaa
        mov  wa,w_yyy
        sub  wa,wc
        sub  wc,m_word [ xl]
        lea  xl,[xl-cfp_b]
        mov  m_word [xl],wc
        add  wa,m_word [REL (cfp_b*num01)+xl]
        lea  xl,[xl-cfp_b]
        mov  m_word [xl],wa
        mov  wb,m_word [REL statb]
        lea  xl,[xl-cfp_b]
        mov  m_word [xl],wb
        sub  xr,wb
        lea  xl,[xl-cfp_b]
        mov  m_word [xl],xr
        lea  xl,[xl-cfp_b]
        mov  w0,m_word [REL state]
        mov  m_word [xl],w0
        mov  wb,m_word [REL dnamb]
        lea  xl,[xl-cfp_b]
        mov  m_word [xl],wb
        scp_ wa
        sub  wa,wb
        lea  xl,[xl-cfp_b]
        mov  m_word [xl],wa
        mov  wc,m_word [REL dnamp]
        lea  xl,[xl-cfp_b]
        mov  m_word [xl],wc
        ret
reldn:
        mov  w0,m_word [REL (cfp_b*rlcda)+xl]
        mov  m_word [REL rldcd],w0
        mov  w0,m_word [REL (cfp_b*rlsta)+xl]
        mov  m_word [REL rldst],w0
        mov  m_word [REL rldls],xl
rld01:
        mov  w0,m_word [REL rldcd]
        add  m_word [ xr],w0
        mov  xl,m_word [ xr]
        movzx xl,byte [xl-1]
        jmp  m_word [_l0001+xl*cfp_b]
        segment .data
_l0001:
        d_word rld03
        d_word rld07
        d_word rld10
        d_word rld05
        d_word rld13
        d_word rld13
        d_word rld14
        d_word rld14
        d_word rld05
        d_word rld05
        d_word rld13
        d_word rld17
        d_word rld17
        d_word rld05
        d_word rld20
        d_word rld05
        d_word rld15
        d_word rld19
        d_word rld05
        d_word rld05
        d_word rld05
        d_word rld05
        d_word rld05
        d_word rld08
        d_word rld09
        d_word rld11
        d_word rld13
        d_word rld16
        d_word rld18
        segment .text
rld03:
        mov  wa,m_word [REL (cfp_b*arlen)+xr]
        mov  wb,m_word [REL (cfp_b*arofs)+xr]
rld04:
        add  wa,xr
        add  wb,xr
        mov  xl,m_word [REL rldls]
        call relaj
rld05:
        mov  wa,m_word [ xr]
        call blkln
        add  xr,wa
        cmp  xr,wc
        jb   rld01
        mov  xl,m_word [REL rldls]
        ret
rld07:
        mov  wa,m_word [REL (cfp_b*cdlen)+xr]
        mov  wb,cfp_b*cdfal
        cmp  m_word [ xr],b_cdc
        jne  rld04
        mov  wb,cfp_b*cdcod
        jmp  rld04
rld08:
        mov  wa,cfp_b*efrsl
        mov  wb,cfp_b*efcod
        jmp  rld04
rld09:
        mov  wa,cfp_b*offs3
        mov  wb,cfp_b*evexp
        jmp  rld04
rld10:
        mov  wa,m_word [REL (cfp_b*exlen)+xr]
        mov  wb,cfp_b*exflc
        jmp  rld04
rld11:
        cmp  m_word [REL (cfp_b*ffofs)+xr],cfp_b*pdfld
        jne  rld12
        push xr
        mov  xr,m_word [REL (cfp_b*ffdfp)+xr]
        add  xr,m_word [REL rldst]
        mov  w0,m_word [REL rldcd]
        add  m_word [ xr],w0
        mov  wa,m_word [REL (cfp_b*dflen)+xr]
        mov  wb,cfp_b*dfnam
        add  wa,xr
        add  wb,xr
        mov  xl,m_word [REL rldls]
        call relaj
        mov  xr,m_word [REL (cfp_b*dfnam)+xr]
        mov  w0,m_word [REL rldcd]
        add  m_word [ xr],w0
        pop  xr
rld12:
        mov  wa,cfp_b*ffofs
        mov  wb,cfp_b*ffdfp
        jmp  rld04
rld13:
        mov  wa,cfp_b*offs2
        mov  wb,cfp_b*offs1
        jmp  rld04
rld14:
        mov  wa,cfp_b*parm2
        mov  wb,cfp_b*pthen
        jmp  rld04
rld15:
        mov  xl,m_word [REL (cfp_b*pddfp)+xr]
        add  xl,m_word [REL rldst]
        mov  wa,m_word [REL (cfp_b*dfpdl)+xl]
        mov  wb,cfp_b*pddfp
        jmp  rld04
rld16:
        mov  w0,m_word [REL rldst]
        add  m_word [REL (cfp_b*pfvbl)+xr],w0
        mov  wa,m_word [REL (cfp_b*pflen)+xr]
        mov  wb,cfp_b*pfcod
        jmp  rld04
rld17:
        mov  wa,m_word [REL (cfp_b*offs2)+xr]
        mov  wb,cfp_b*offs3
        jmp  rld04
rld18:
        mov  wa,cfp_b*tesi_
        mov  wb,cfp_b*tesub
        jmp  rld04
rld19:
        mov  wa,cfp_b*trsi_
        mov  wb,cfp_b*trval
        jmp  rld04
rld20:
        mov  wa,m_word [REL (cfp_b*xrlen)+xr]
        mov  wb,cfp_b*xrptr
        jmp  rld04
reloc:
        mov  xr,m_word [REL (cfp_b*rldys)+xl]
        mov  wc,m_word [REL (cfp_b*rldye)+xl]
        add  xr,m_word [REL (cfp_b*rldya)+xl]
        add  wc,m_word [REL (cfp_b*rldya)+xl]
        call reldn
        call relws
        call relst
        ret
relst:
        mov  xr,m_word [REL pftbl]
        or   xr,xr
        jz   rls01
        mov  w0,m_word [REL (cfp_b*rlcda)+xl]
        add  m_word [ xr],w0
rls01:
        mov  wc,m_word [REL hshtb]
        mov  wb,wc
        mov  wa,m_word [REL hshte]
        call relaj
rls02:
        cmp  wc,m_word [REL hshte]
        je   rls05
        mov  xr,wc
        add  wc,cfp_b
        sub  xr,cfp_b*vrnxt
rls03:
        mov  xr,m_word [REL (cfp_b*vrnxt)+xr]
        or   xr,xr
        jz   rls02
        mov  wa,cfp_b*vrlen
        mov  wb,cfp_b*vrget
        cmp  m_word [REL (cfp_b*vrlen)+xr],0
        jnz  rls04
        mov  wa,cfp_b*vrsi_
rls04:
        add  wa,xr
        add  wb,xr
        call relaj
        jmp  rls03
rls05:
        ret
relws:
        mov  wb,a_aaa
        mov  wa,r_yyy
        call relaj
        mov  w0,m_word [REL (cfp_b*rldya)+xl]
        add  m_word [REL dname],w0
        mov  wb,kvrtn
        mov  wa,wb
        add  wa,cfp_b
        call relaj
        ret
start:
        mov  m_word [REL mxint],wb
        mov  m_word [REL bitsm],wb
        xor  wb,wb
        mov  xs,wa
        call systm
        sti_ m_word [REL timsx]
        mov  m_word [REL statb],xr
        mov  m_word [REL rsmem],cfp_b*e_srs
        mov  m_word [REL stbas],xs
        ldi_ m_word [REL intvh]
        dvi_ m_word [REL alfsp]
        sti_ m_word [REL alfsf]
        ldi_ m_word [REL intvh]
        dvi_ m_word [REL gbsdp]
        sti_ m_word [REL gbsed]
        mov  wb,cfp_s
        lea  w0,[REL reav1]
        call ldr_
ini03:
        lea  w0,[REL reavt]
        call mlr_
        dec  wb
        jnz  ini03
        lea  w0,[REL gtssc]
        call str_
        lea  w0,[REL reap5]
        call ldr_
        lea  w0,[REL gtssc]
        call dvr_
        lea  w0,[REL gtsrn]
        call str_
        xor  wc,wc
        call prpar
        sub  xl,cfp_b*e_srs
        mov  wa,m_word [REL prlen]
        add  wa,cfp_a
        add  wa,nstmx
        add  wa,(cfp_b-1)+cfp_b*8
        and  wa,-cfp_b
        mov  xr,m_word [REL statb]
        add  xr,wa
        add  xr,cfp_b*e_hnb
        add  xr,cfp_b*e_sts
        call sysmx
        mov  m_word [REL kvmxl],wa
        mov  m_word [REL mxlen],wa
        cmp  xr,wa
        ja   ini06
        add  wa,(cfp_b-1)+cfp_b*1
        and  wa,-cfp_b
        mov  xr,wa
ini06:
        mov  m_word [REL dnamb],xr
        mov  m_word [REL dnamp],xr
        or   wa,wa
        jnz  ini07
        sub  xr,cfp_b
        mov  m_word [REL kvmxl],xr
        mov  m_word [REL mxlen],xr
ini07:
        mov  m_word [REL dname],xl
        cmp  m_word [REL dnamb],xl
        jb   ini09
        call sysmm
        sal  xr,log_cfp_b
        add  xl,xr
        or   xr,xr
        jnz  ini07
        mov  wa,mxern
        xor  wb,wb
        xor  wc,wc
        mov  xr,stgic
        mov  xl,nulls
        call sysea
        dec  m_word [_rc_]
        js   call_1
        dec  m_word [_rc_]
        jns  _l0002
        jmp  ini08
_l0002:
call_1:
        jmp  ini08
        mov  m_word [_rc_],329
        jmp  err_
ini08:
        mov  xr,endmo
        mov  wa,m_word [REL endml]
        call syspr
        dec  m_word [_rc_]
        js   call_2
        dec  m_word [_rc_]
        jns  _l0003
        mov  m_word [_rc_],299
        jmp  err_
_l0003:
call_2:
        xor  xl,xl
        mov  wb,num10
        call sysej
ini09:
        mov  xr,m_word [REL statb]
        call insta
        mov  wa,e_hnb
        ldi_ wa
        sti_ m_word [REL hshnb]
        mov  m_word [REL hshtb],xr
ini11:
        mov  w0,0
        stos_w
        dec  wa
        jnz  ini11
        mov  m_word [REL hshte],xr
        mov  m_word [REL state],xr
        mov  wc,num01
        mov  xl,nulls
        mov  m_word [REL r_sfc],xl
        call tmake
        mov  m_word [REL r_sfn],xr
        mov  wc,num01
        mov  xl,nulls
        call tmake
        mov  m_word [REL r_inc],xr
        mov  wa,ccinm
        mov  xl,nulls
        call vmake
        dec  m_word [_rc_]
        js   call_3
        dec  m_word [_rc_]
        jns  _l0004
        mov  m_word [_rc_],299
        jmp  err_
_l0004:
call_3:
        mov  m_word [REL r_ifa],xr
        mov  wa,ccinm
        mov  xl,inton
        call vmake
        dec  m_word [_rc_]
        js   call_4
        dec  m_word [_rc_]
        jns  _l0005
        mov  m_word [_rc_],299
        jmp  err_
_l0005:
call_4:
        mov  m_word [REL r_ifl],xr
        mov  xl,v_inp
        mov  wb,trtin
        call inout
        mov  xl,v_oup
        mov  wb,trtou
        call inout
        mov  wc,m_word [REL initr]
        or   wc,wc
        jz   ini13
        call prpar
ini13:
        call sysdc
        mov  m_word [REL flptr],xs
        call cmpil
        mov  m_word [REL r_cod],xr
        mov  m_word [REL r_ttl],nulls
        mov  m_word [REL r_stl],nulls
        mov  w0,0
        mov  m_word [REL r_cim],w0
        mov  w0,0
        mov  m_word [REL r_ccb],w0
        mov  w0,0
        mov  m_word [REL cnind],w0
        mov  w0,0
        mov  m_word [REL lstid],w0
        xor  xl,xl
        xor  wb,wb
        mov  w0,0
        mov  m_word [REL dnams],w0
        call gbcol
        mov  m_word [REL dnams],xr
        cmp  m_word [REL cpsts],0
        jnz  inix0
        call prtpg
        call prtmm
        ldi_ m_word [REL cmerc]
        mov  xr,encm3
        call prtmi
        ldi_ m_word [REL gbcnt]
        sbi_ m_word [REL intv1]
        mov  xr,stpm5
        call prtmi
        call systm
        sbi_ m_word [REL timsx]
        mov  xr,encm4
        call prtmi
        add  m_word [REL lstlc],num05
        cmp  m_word [REL headp],0
        jz   inix0
        call prtpg
inix0:
        cmp  m_word [REL cswin],iniln
        ja   inix1
        mov  m_word [REL cswin],inils
inix1:
        call systm
        sti_ m_word [REL timsx]
        mov  w0,0
        mov  m_word [REL gbcnt],w0
        call sysbx
        mov  w0,m_word [REL cswex]
        add  m_word [REL noxeq],w0
        cmp  m_word [REL noxeq],0
        jnz  inix2
iniy0:
        mov  m_word [REL headp],xs
        push 0
        mov  m_word [REL flptr],xs
        mov  xr,m_word [REL r_cod]
        mov  m_word [REL stage],stgxt
        mov  m_word [REL polcs],num01
        mov  m_word [REL polct],num01
        mov  w0,m_word [REL cmpsn]
        mov  m_word [REL pfnte],w0
        mov  w0,m_word [REL kvpfl]
        mov  m_word [REL pfdmp],w0
        call systm
        sti_ m_word [REL pfstm]
        call stgcc
        jmp  m_word [ xr]
inix2:
        xor  wa,wa
        mov  wb,nini9
        xor  xl,xl
        call sysej
rstrt:
        mov  xs,m_word [REL stbas]
        xor  xl,xl
        jmp  iniy0
	align	2
	nop
o_add:
        call arith
        dec  m_word [_rc_]
        js   call_5
        dec  m_word [_rc_]
        jns  _l0006
        mov  m_word [_rc_],1
        jmp  err_
_l0006:
        dec  m_word [_rc_]
        jns  _l0007
        mov  m_word [_rc_],2
        jmp  err_
_l0007:
        dec  m_word [_rc_]
        jns  _l0008
        jmp  oadd1
_l0008:
call_5:
        adi_ m_word [REL (cfp_b*icval)+xl]
        ino_ exint
        mov  m_word [_rc_],3
        jmp  err_
oadd1:
        lea  w0,[REL (cfp_b*rcval)+xl]
        call adr_
        rno_ exrea
        mov  m_word [_rc_],261
        jmp  err_
	align	2
	nop
o_aff:
        pop  xr
        call gtnum
        dec  m_word [_rc_]
        js   call_6
        dec  m_word [_rc_]
        jns  _l0009
        mov  m_word [_rc_],4
        jmp  err_
_l0009:
call_6:
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
o_alt:
        pop  xr
        call gtpat
        dec  m_word [_rc_]
        js   call_7
        dec  m_word [_rc_]
        jns  _l0010
        mov  m_word [_rc_],5
        jmp  err_
_l0010:
call_7:
oalt1:
        mov  wb,p_alt
        call pbild
        mov  xl,xr
        pop  xr
        call gtpat
        dec  m_word [_rc_]
        js   call_8
        dec  m_word [_rc_]
        jns  _l0011
        mov  m_word [_rc_],6
        jmp  err_
_l0011:
call_8:
        cmp  xr,p_alt
        je   oalt2
        mov  m_word [REL (cfp_b*pthen)+xl],xr
        push xl
        lcw_ xr
        jmp  m_word [ xr]
oalt2:
        mov  w0,m_word [REL (cfp_b*parm1)+xr]
        mov  m_word [REL (cfp_b*pthen)+xl],w0
        push m_word [REL (cfp_b*pthen)+xr]
        mov  xr,xl
        jmp  oalt1
	align	2
	nop
o_amn:
        lcw_ xr
        mov  wb,xr
        jmp  arref
	align	2
	nop
o_amv:
        lcw_ xr
        xor  wb,wb
        jmp  arref
	align	2
	nop
o_aon:
        mov  xr,m_word [ xs]
        mov  xl,m_word [REL (cfp_b*num01)+xs]
        mov  wa,m_word [ xl]
        cmp  wa,b_vct
        je   oaon2
        cmp  wa,b_tbt
        je   oaon3
oaon1:
        mov  xr,num01
        mov  wb,xr
        jmp  arref
oaon2:
        cmp  m_word [ xr],b_icl
        jne  oaon1
        ldi_ m_word [REL (cfp_b*icval)+xr]
        sti_ w0
        or   w0,w0
        js   exfal
        sti_ wa
        or   wa,wa
        jz   exfal
        add  wa,vcvlb
        sal  wa,log_cfp_b
        mov  m_word [ xs],wa
        cmp  wa,m_word [REL (cfp_b*vclen)+xl]
        jb   oaon4
        jmp  exfal
oaon3:
        mov  wb,xs
        call tfind
        dec  m_word [_rc_]
        js   call_9
        dec  m_word [_rc_]
        jns  _l0012
        jmp  exfal
_l0012:
call_9:
        mov  m_word [REL (cfp_b*num01)+xs],xl
        mov  m_word [ xs],wa
oaon4:
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
o_aov:
        pop  xr
        pop  xl
        mov  wa,m_word [ xl]
        cmp  wa,b_vct
        je   oaov2
        cmp  wa,b_tbt
        je   oaov3
oaov1:
        push xl
        push xr
        mov  xr,num01
        xor  wb,wb
        jmp  arref
oaov2:
        cmp  m_word [ xr],b_icl
        jne  oaov1
        ldi_ m_word [REL (cfp_b*icval)+xr]
        sti_ w0
        or   w0,w0
        js   exfal
        sti_ wa
        or   wa,wa
        jz   exfal
        add  wa,vcvlb
        sal  wa,log_cfp_b
        cmp  wa,m_word [REL (cfp_b*vclen)+xl]
        jae  exfal
        call acess
        dec  m_word [_rc_]
        js   call_10
        dec  m_word [_rc_]
        jns  _l0013
        jmp  exfal
_l0013:
call_10:
        push xr
        lcw_ xr
        jmp  m_word [ xr]
oaov3:
        xor  wb,wb
        call tfind
        dec  m_word [_rc_]
        js   call_11
        dec  m_word [_rc_]
        jns  _l0014
        jmp  exfal
_l0014:
call_11:
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
o_ass:
oass0:
        pop  wb
        pop  wa
        mov  xl,m_word [ xs]
        mov  m_word [ xs],wb
        call asign
        dec  m_word [_rc_]
        js   call_12
        dec  m_word [_rc_]
        jns  _l0015
        jmp  exfal
_l0015:
call_12:
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
o_cer:
        mov  m_word [_rc_],7
        jmp  err_
	align	2
	nop
o_cas:
        pop  wc
        pop  xr
        mov  wb,p_cas
        call pbild
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
o_cnc:
        mov  xr,m_word [ xs]
        cmp  xr,nulls
        je   ocnc3
        mov  xl,m_word [REL (cfp_b*1)+xs]
        cmp  xl,nulls
        je   ocnc4
        mov  wa,b_scl
        cmp  wa,m_word [ xl]
        jne  ocnc2
        cmp  wa,m_word [ xr]
        jne  ocnc2
ocnc1:
        mov  wa,m_word [REL (cfp_b*sclen)+xl]
        add  wa,m_word [REL (cfp_b*sclen)+xr]
        call alocs
        mov  m_word [REL (cfp_b*1)+xs],xr
        add  xr,cfp_f
        mov  wa,m_word [REL (cfp_b*sclen)+xl]
        add  xl,cfp_f
        rep
        movs_b
        pop  xl
        mov  wa,m_word [REL (cfp_b*sclen)+xl]
        add  xl,cfp_f
        rep
        movs_b
        xor  xl,xl
        lcw_ xr
        jmp  m_word [ xr]
ocnc2:
        call gtstg
        dec  m_word [_rc_]
        js   call_13
        dec  m_word [_rc_]
        jns  _l0018
        jmp  ocnc5
_l0018:
call_13:
        mov  xl,xr
        call gtstg
        dec  m_word [_rc_]
        js   call_14
        dec  m_word [_rc_]
        jns  _l0019
        jmp  ocnc6
_l0019:
call_14:
        push xr
        push xl
        mov  xl,xr
        mov  xr,m_word [ xs]
        jmp  ocnc1
ocnc3:
        add  xs,cfp_b
        lcw_ xr
        jmp  m_word [ xr]
ocnc4:
        add  xs,cfp_b
        mov  m_word [ xs],xr
        lcw_ xr
        jmp  m_word [ xr]
ocnc5:
        mov  xl,xr
        pop  xr
ocnc6:
        call gtpat
        dec  m_word [_rc_]
        js   call_15
        dec  m_word [_rc_]
        jns  _l0020
        mov  m_word [_rc_],8
        jmp  err_
_l0020:
call_15:
        push xr
        mov  xr,xl
        call gtpat
        dec  m_word [_rc_]
        js   call_16
        dec  m_word [_rc_]
        jns  _l0021
        mov  m_word [_rc_],9
        jmp  err_
_l0021:
call_16:
        mov  xl,xr
        pop  xr
        call pconc
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
o_com:
        pop  xr
        mov  wa,m_word [ xr]
ocom1:
        cmp  wa,b_icl
        je   ocom2
        cmp  wa,b_rcl
        je   ocom3
        call gtnum
        dec  m_word [_rc_]
        js   call_17
        dec  m_word [_rc_]
        jns  _l0022
        mov  m_word [_rc_],10
        jmp  err_
_l0022:
call_17:
        jmp  ocom1
ocom2:
        ldi_ m_word [REL (cfp_b*icval)+xr]
        ngi_
        ino_ exint
        mov  m_word [_rc_],11
        jmp  err_
ocom3:
        lea  w0,[REL (cfp_b*rcval)+xr]
        call ldr_
        call ngr_
        jmp  exrea
	align	2
	nop
o_dvd:
        call arith
        dec  m_word [_rc_]
        js   call_18
        dec  m_word [_rc_]
        jns  _l0023
        mov  m_word [_rc_],12
        jmp  err_
_l0023:
        dec  m_word [_rc_]
        jns  _l0024
        mov  m_word [_rc_],13
        jmp  err_
_l0024:
        dec  m_word [_rc_]
        jns  _l0025
        jmp  odvd2
_l0025:
call_18:
        dvi_ m_word [REL (cfp_b*icval)+xl]
        ino_ exint
        mov  m_word [_rc_],14
        jmp  err_
odvd2:
        lea  w0,[REL (cfp_b*rcval)+xl]
        call dvr_
        rno_ exrea
        mov  m_word [_rc_],262
        jmp  err_
	align	2
	nop
o_exp:
        pop  xr
        call gtnum
        dec  m_word [_rc_]
        js   call_19
        dec  m_word [_rc_]
        jns  _l0026
        mov  m_word [_rc_],15
        jmp  err_
_l0026:
call_19:
        mov  xl,xr
        pop  xr
        call gtnum
        dec  m_word [_rc_]
        js   call_20
        dec  m_word [_rc_]
        jns  _l0027
        mov  m_word [_rc_],16
        jmp  err_
_l0027:
call_20:
        cmp  m_word [ xl],b_rcl
        je   oexp7
        ldi_ m_word [REL (cfp_b*icval)+xl]
        sti_ w0
        or   w0,w0
        jl   oex12
        cmp  wa,b_rcl
        je   oexp3
        sti_ w0
        or   w0,w0
        js   oexp2
        sti_ wa
        ldi_ m_word [REL (cfp_b*icval)+xr]
        or   wa,wa
        jnz  oexp1
        sti_ w0
        or   w0,w0
        je   oexp4
        ldi_ m_word [REL intv1]
        jmp  exint
oex13:
        mli_ m_word [REL (cfp_b*icval)+xr]
        iov_ oexp2
oexp1:
        dec  wa
        jnz  oex13
        jmp  exint
oexp2:
        mov  m_word [_rc_],17
        jmp  err_
oexp3:
        sti_ w0
        or   w0,w0
        js   oexp6
        sti_ wa
        lea  w0,[REL (cfp_b*rcval)+xr]
        call ldr_
        or   wa,wa
        jnz  oexp5
        call cpr_
        mov  al,byte [reg_fl]
        or   al,al
        je   oexp4
        lea  w0,[REL reav1]
        call ldr_
        jmp  exrea
oexp4:
        mov  m_word [_rc_],18
        jmp  err_
oex14:
        lea  w0,[REL (cfp_b*rcval)+xr]
        call mlr_
        rov_ oexp6
oexp5:
        dec  wa
        jnz  oex14
        jmp  exrea
oexp6:
        mov  m_word [_rc_],266
        jmp  err_
oexp7:
        cmp  m_word [ xr],b_rcl
        je   oexp8
        ldi_ m_word [REL (cfp_b*icval)+xr]
        call itr_
        call rcbld
oexp8:
        xor  wb,wb
        lea  w0,[REL (cfp_b*rcval)+xr]
        call ldr_
        call cpr_
        mov  al,byte [reg_fl]
        or   al,al
        jne  oexp9
        lea  w0,[REL (cfp_b*rcval)+xl]
        call ldr_
        call cpr_
        mov  al,byte [reg_fl]
        or   al,al
        je   oexp4
        lea  w0,[REL reav0]
        call ldr_
        jmp  exrea
oexp9:
        call cpr_
        mov  al,byte [reg_fl]
        or   al,al
        jg   oex10
        call ngr_
        call rcbld
        lea  w0,[REL (cfp_b*rcval)+xl]
        call ldr_
        call chp_
        rti_
        jc   oexp6
        lea  w0,[REL (cfp_b*rcval)+xl]
        call sbr_
        call cpr_
        mov  al,byte [reg_fl]
        or   al,al
        jne  oex11
        sti_ wb
        and  wb,m_word [REL bits1]
        lea  w0,[REL (cfp_b*rcval)+xr]
        call ldr_
oex10:
        call lnf_
        rov_ oexp6
        lea  w0,[REL (cfp_b*rcval)+xl]
        call mlr_
        rov_ oexp6
        call etx_
        rov_ oexp6
        or   wb,wb
        jz   exrea
        call ngr_
        jmp  exrea
oex11:
        mov  m_word [_rc_],311
        jmp  err_
oex12:
        push xr
        call itr_
        call rcbld
        mov  xl,xr
        pop  xr
        jmp  oexp7
	align	2
	nop
o_fex:
        jmp  evlx6
	align	2
	nop
o_fif:
        mov  m_word [_rc_],20
        jmp  err_
	align	2
	nop
o_fnc:
        lcw_ wa
        lcw_ xr
        mov  xl,m_word [REL (cfp_b*vrfnc)+xr]
        cmp  wa,m_word [REL (cfp_b*fargs)+xl]
        jne  cfunc
        jmp  m_word [ xl]
	align	2
	nop
o_fne:
        lcw_ wa
        cmp  wa,ornm_
        jne  ofne1
        cmp  m_word [REL (cfp_b*num02)+xs],0
        jz   evlx3
ofne1:
        mov  m_word [_rc_],21
        jmp  err_
	align	2
	nop
o_fns:
        lcw_ xr
        mov  wa,num01
        mov  xl,m_word [REL (cfp_b*vrfnc)+xr]
        cmp  wa,m_word [REL (cfp_b*fargs)+xl]
        jne  cfunc
        jmp  m_word [ xl]
	align	2
	nop
o_fun:
        mov  m_word [_rc_],22
        jmp  err_
	align	2
	nop
o_goc:
        mov  xr,m_word [REL (cfp_b*num01)+xs]
        cmp  xr,m_word [REL state]
        ja   ogoc1
        add  xr,cfp_b*vrtra
        jmp  m_word [ xr]
ogoc1:
        mov  m_word [_rc_],23
        jmp  err_
	align	2
	nop
o_god:
        mov  xr,m_word [ xs]
        mov  wa,m_word [ xr]
        cmp  wa,b_cds
        je   bcds0
        cmp  wa,b_cdc
        je   bcdc0
        mov  m_word [_rc_],24
        jmp  err_
	align	2
	nop
o_gof:
        mov  xr,m_word [REL flptr]
        add  m_word [ xr],cfp_b
        icp_
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
o_ima:
        mov  wb,p_imc
        pop  wc
        pop  xr
        call pbild
        mov  xl,xr
        mov  xr,m_word [ xs]
        call gtpat
        dec  m_word [_rc_]
        js   call_21
        dec  m_word [_rc_]
        jns  _l0028
        mov  m_word [_rc_],25
        jmp  err_
_l0028:
call_21:
        mov  m_word [ xs],xr
        mov  wb,p_ima
        call pbild
        pop  m_word [REL (cfp_b*pthen)+xr]
        call pconc
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
o_inn:
        mov  wb,xs
        jmp  indir
	align	2
	nop
o_int:
        mov  m_word [ xs],nulls
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
o_inv:
        xor  wb,wb
        jmp  indir
	align	2
	nop
o_kwn:
        call kwnam
        jmp  exnam
	align	2
	nop
o_kwv:
        call kwnam
        mov  m_word [REL dnamp],xr
        call acess
        dec  m_word [_rc_]
        js   call_22
        dec  m_word [_rc_]
        jns  _l0029
        jmp  exnul
_l0029:
call_22:
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
o_lex:
        mov  wa,cfp_b*evsi_
        call alloc
        mov  m_word [ xr],b_evt
        mov  m_word [REL (cfp_b*evvar)+xr],trbev
        lcw_ wa
        mov  m_word [REL (cfp_b*evexp)+xr],wa
        mov  xl,xr
        mov  wa,cfp_b*evvar
        jmp  exnam
	align	2
	nop
o_lpt:
        lcw_ xr
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
o_lvn:
        lcw_ wa
        push wa
        push cfp_b*vrval
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
o_mlt:
        call arith
        dec  m_word [_rc_]
        js   call_23
        dec  m_word [_rc_]
        jns  _l0030
        mov  m_word [_rc_],26
        jmp  err_
_l0030:
        dec  m_word [_rc_]
        jns  _l0031
        mov  m_word [_rc_],27
        jmp  err_
_l0031:
        dec  m_word [_rc_]
        jns  _l0032
        jmp  omlt1
_l0032:
call_23:
        mli_ m_word [REL (cfp_b*icval)+xl]
        ino_ exint
        mov  m_word [_rc_],28
        jmp  err_
omlt1:
        lea  w0,[REL (cfp_b*rcval)+xl]
        call mlr_
        rno_ exrea
        mov  m_word [_rc_],263
        jmp  err_
	align	2
	nop
o_nam:
        mov  wa,cfp_b*nmsi_
        call alloc
        mov  m_word [ xr],b_nml
        pop  m_word [REL (cfp_b*nmofs)+xr]
        pop  m_word [REL (cfp_b*nmbas)+xr]
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
o_nta:
        lcw_ wa
        push m_word [REL flptr]
        push wa
        mov  m_word [REL flptr],xs
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
o_ntb:
        mov  w0,m_word [REL (cfp_b*num02)+xs]
        mov  m_word [REL flptr],w0
        jmp  exfal
	align	2
	nop
o_ntc:
        add  xs,cfp_b
        pop  m_word [REL flptr]
        jmp  exnul
	align	2
	nop
o_oun:
        mov  m_word [_rc_],29
        jmp  err_
	align	2
	nop
o_pas:
        mov  wb,p_pac
        pop  wc
        pop  xr
        call pbild
        mov  xl,xr
        mov  xr,m_word [ xs]
        call gtpat
        dec  m_word [_rc_]
        js   call_24
        dec  m_word [_rc_]
        jns  _l0033
        mov  m_word [_rc_],30
        jmp  err_
_l0033:
call_24:
        mov  m_word [ xs],xr
        mov  wb,p_paa
        call pbild
        pop  m_word [REL (cfp_b*pthen)+xr]
        call pconc
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
o_pmn:
        xor  wb,wb
        jmp  match
	align	2
	nop
o_pms:
        mov  wb,num02
        jmp  match
	align	2
	nop
o_pmv:
        mov  wb,num01
        jmp  match
	align	2
	nop
o_pop:
        add  xs,cfp_b
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
o_stp:
        jmp  lend0
	align	2
	nop
o_rnm:
        jmp  evlx4
	align	2
	nop
o_rpl:
        call gtstg
        dec  m_word [_rc_]
        js   call_25
        dec  m_word [_rc_]
        jns  _l0034
        mov  m_word [_rc_],31
        jmp  err_
_l0034:
call_25:
        mov  xl,m_word [ xs]
        add  wa,m_word [REL (cfp_b*sclen)+xl]
        add  wa,m_word [REL (cfp_b*num02)+xs]
        sub  wa,m_word [REL (cfp_b*num01)+xs]
        or   wa,wa
        jz   orpl3
        push xr
        call alocs
        mov  wa,m_word [REL (cfp_b*num03)+xs]
        mov  m_word [REL (cfp_b*num03)+xs],xr
        add  xr,cfp_f
        or   wa,wa
        jz   orpl1
        mov  xl,m_word [REL (cfp_b*num01)+xs]
        add  xl,cfp_f
        rep
        movs_b
orpl1:
        pop  xl
        mov  wa,m_word [REL (cfp_b*sclen)+xl]
        or   wa,wa
        jz   orpl2
        add  xl,cfp_f
        rep
        movs_b
orpl2:
        pop  xl
        pop  wc
        mov  wa,m_word [REL (cfp_b*sclen)+xl]
        sub  wa,wc
        or   wa,wa
        jz   oass0
        lea  xl,[cfp_f+xl+wc]
        rep
        movs_b
        jmp  oass0
orpl3:
        add  xs,cfp_b*num02
        mov  m_word [ xs],nulls
        jmp  oass0
	align	2
	nop
o_rvl:
        jmp  evlx3
	align	2
	nop
o_sla:
        lcw_ wa
        push m_word [REL flptr]
        push wa
        mov  m_word [REL flptr],xs
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
o_slb:
        pop  xr
        add  xs,cfp_b
        mov  w0,m_word [ xs]
        mov  m_word [REL flptr],w0
        mov  m_word [ xs],xr
        lcw_ wa
        add  wa,m_word [REL r_cod]
        lcp_ wa
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
o_slc:
        lcw_ wa
        mov  m_word [ xs],wa
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
o_sld:
        add  xs,cfp_b
        pop  m_word [REL flptr]
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
o_sub:
        call arith
        dec  m_word [_rc_]
        js   call_26
        dec  m_word [_rc_]
        jns  _l0038
        mov  m_word [_rc_],32
        jmp  err_
_l0038:
        dec  m_word [_rc_]
        jns  _l0039
        mov  m_word [_rc_],33
        jmp  err_
_l0039:
        dec  m_word [_rc_]
        jns  _l0040
        jmp  osub1
_l0040:
call_26:
        sbi_ m_word [REL (cfp_b*icval)+xl]
        ino_ exint
        mov  m_word [_rc_],34
        jmp  err_
osub1:
        lea  w0,[REL (cfp_b*rcval)+xl]
        call sbr_
        rno_ exrea
        mov  m_word [_rc_],264
        jmp  err_
	align	2
	nop
o_txr:
        jmp  trxq1
	align	2
	nop
o_unf:
        mov  m_word [_rc_],35
        jmp  err_
	align	2
	db	bl__i
b_aaa:
	align	2
	db	bl_ex
b_exl:
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	db	bl_se
b_sel:
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	db	bl__i
b_e__:
	align	2
	db	bl_tr
b_trt:
	align	2
	db	bl__i
b_t__:
	align	2
	db	bl_ar
b_art:
	align	2
	db	bl_bc
b_bct:
	align	2
	db	bl_bf
b_bft:
	align	2
	db	bl_cc
b_cct:
	align	2
	db	bl_cd
b_cdc:
bcdc0:
        mov  xs,m_word [REL flptr]
        mov  w0,m_word [REL (cfp_b*cdfal)+xr]
        mov  m_word [ xs],w0
        jmp  stmgo
	align	2
	db	bl_cd
b_cds:
bcds0:
        mov  xs,m_word [REL flptr]
        mov  m_word [ xs],cfp_b*cdfal
        jmp  stmgo
	align	2
	db	bl_cm
b_cmt:
	align	2
	db	bl_ct
b_ctt:
	align	2
	db	bl_df
b_dfc:
        mov  wa,m_word [REL (cfp_b*dfpdl)+xl]
        call alloc
        mov  m_word [ xr],b_pdt
        mov  m_word [REL (cfp_b*pddfp)+xr],xl
        mov  wc,xr
        add  xr,wa
        mov  wa,m_word [REL (cfp_b*fargs)+xl]
bdfc1:
        lea  xr,[xr-cfp_b]
        pop  m_word [xr]
        dec  wa
        jnz  bdfc1
        mov  xr,wc
        jmp  exsid
	align	2
	db	bl_ef
b_efc:
        mov  wc,m_word [REL (cfp_b*fargs)+xl]
        sal  wc,log_cfp_b
        push xl
        mov  xt,xs
befc1:
        add  xt,cfp_b
        mov  xr,m_word [ xs]
        sub  wc,cfp_b
        add  xr,wc
        mov  xr,m_word [REL (cfp_b*eftar)+xr]
        jmp  m_word [_l0041+xr*cfp_b]
        segment .data
_l0041:
        d_word befc7
        d_word befc2
        d_word befc3
        d_word befc4
        d_word beff1
        segment .text
beff1:
        push xt
        mov  m_word [REL befof],wc
        push m_word [ xt]
        call iofcb
        dec  m_word [_rc_]
        js   call_27
        dec  m_word [_rc_]
        jns  _l0042
        mov  m_word [_rc_],298
        jmp  err_
_l0042:
        dec  m_word [_rc_]
        jns  _l0043
        mov  m_word [_rc_],298
        jmp  err_
_l0043:
        dec  m_word [_rc_]
        jns  _l0044
        mov  m_word [_rc_],298
        jmp  err_
_l0044:
call_27:
        mov  xr,wa
        pop  xt
        jmp  befc5
befc2:
        push m_word [ xt]
        call gtstg
        dec  m_word [_rc_]
        js   call_28
        dec  m_word [_rc_]
        jns  _l0045
        mov  m_word [_rc_],39
        jmp  err_
_l0045:
call_28:
        jmp  befc6
befc3:
        mov  xr,m_word [ xt]
        mov  m_word [REL befof],wc
        call gtint
        dec  m_word [_rc_]
        js   call_29
        dec  m_word [_rc_]
        jns  _l0046
        mov  m_word [_rc_],40
        jmp  err_
_l0046:
call_29:
        jmp  befc5
befc4:
        mov  xr,m_word [ xt]
        mov  m_word [REL befof],wc
        call gtrea
        dec  m_word [_rc_]
        js   call_30
        dec  m_word [_rc_]
        jns  _l0047
        mov  m_word [_rc_],265
        jmp  err_
_l0047:
call_30:
befc5:
        mov  wc,m_word [REL befof]
befc6:
        mov  m_word [ xt],xr
befc7:
        or   wc,wc
        jnz  befc1
        pop  xl
        mov  wa,m_word [REL (cfp_b*fargs)+xl]
        call sysex
        dec  m_word [_rc_]
        js   call_31
        dec  m_word [_rc_]
        jns  _l0048
        jmp  exfal
_l0048:
        dec  m_word [_rc_]
        jns  _l0049
        mov  m_word [_rc_],327
        jmp  err_
_l0049:
        dec  m_word [_rc_]
        jns  _l0050
        mov  m_word [_rc_],326
        jmp  err_
_l0050:
call_31:
        sal  wa,log_cfp_b
        add  xs,wa
        mov  wb,m_word [REL (cfp_b*efrsl)+xl]
        or   wb,wb
        jnz  befa8
        cmp  m_word [ xr],b_scl
        jne  befc8
        cmp  m_word [REL (cfp_b*sclen)+xr],0
        jz   exnul
befa8:
        cmp  wb,num01
        jne  befc8
        cmp  m_word [REL (cfp_b*sclen)+xr],0
        jz   exnul
befc8:
        cmp  xr,m_word [REL dnamb]
        jb   befc9
        cmp  xr,m_word [REL dnamp]
        jbe  exixr
befc9:
        mov  wa,m_word [ xr]
        or   wb,wb
        jz   bef11
        mov  wa,b_scl
        cmp  wb,num01
        je   bef10
        mov  wa,b_icl
        cmp  wb,num02
        je   bef10
        mov  wa,b_rcl
bef10:
        mov  m_word [ xr],wa
bef11:
        cmp  m_word [ xr],b_scl
        je   bef12
        call blkln
        mov  xl,xr
        call alloc
        push xr
        shr  wa,log_cfp_b
        rep  movs_w
        xor  xl,xl
        lcw_ xr
        jmp  m_word [ xr]
bef12:
        mov  xl,xr
        mov  wa,m_word [REL (cfp_b*sclen)+xr]
        or   wa,wa
        jz   exnul
        call alocs
        push xr
        add  xr,cfp_f
        add  xl,cfp_f
        mov  wa,wc
        rep
        movs_b
        xor  xl,xl
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	db	bl_ev
b_evt:
	align	2
	db	bl_ff
b_ffc:
        mov  xr,xl
        lcw_ wc
        mov  xl,m_word [ xs]
        cmp  m_word [ xl],b_pdt
        jne  bffc2
        mov  wa,m_word [REL (cfp_b*pddfp)+xl]
bffc1:
        cmp  wa,m_word [REL (cfp_b*ffdfp)+xr]
        je   bffc3
        mov  xr,m_word [REL (cfp_b*ffnxt)+xr]
        or   xr,xr
        jnz  bffc1
bffc2:
        mov  m_word [_rc_],41
        jmp  err_
bffc3:
        mov  wa,m_word [REL (cfp_b*ffofs)+xr]
        cmp  wc,ofne_
        je   bffc5
        add  xl,wa
        mov  xr,m_word [ xl]
        cmp  m_word [ xr],b_trt
        jne  bffc4
        sub  xl,wa
        mov  m_word [ xs],wc
        call acess
        dec  m_word [_rc_]
        js   call_32
        dec  m_word [_rc_]
        jns  _l0052
        jmp  exfal
_l0052:
call_32:
        mov  wc,m_word [ xs]
bffc4:
        mov  m_word [ xs],xr
        mov  xr,wc
        mov  xl,m_word [ xr]
        jmp  xl
bffc5:
        push wa
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	db	bl_ic
b_icl:
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	db	bl_kv
b_kvt:
	align	2
	db	bl_nm
b_nml:
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	db	bl_pd
b_pdt:
	align	2
	db	bl_pf
b_pfc:
        mov  m_word [REL bpfpf],xl
        mov  xr,xl
        mov  xl,m_word [REL (cfp_b*pfvbl)+xr]
bpf01:
        mov  wb,xl
        mov  xl,m_word [REL (cfp_b*vrval)+xl]
        cmp  m_word [ xl],b_trt
        je   bpf01
        mov  m_word [REL bpfsv],xl
        mov  xl,wb
        mov  m_word [REL (cfp_b*vrval)+xl],nulls
        mov  wa,m_word [REL (cfp_b*fargs)+xr]
        add  xr,cfp_b*pfarg
        or   wa,wa
        jz   bpf04
        mov  xt,xs
        sal  wa,log_cfp_b
        add  xt,wa
        mov  m_word [REL bpfxt],xt
bpf02:
        mov  xl,m_word [REL xr]
        lea  xr,[xr+cfp_b]
bpf03:
        mov  wc,xl
        mov  xl,m_word [REL (cfp_b*vrval)+xl]
        cmp  m_word [ xl],b_trt
        je   bpf03
        mov  wa,xl
        mov  xt,m_word [REL bpfxt]
        lea  xt,[xt-cfp_b]
        mov  wb,m_word [xt]
        mov  m_word [ xt],wa
        mov  m_word [REL bpfxt],xt
        mov  xl,wc
        mov  m_word [REL (cfp_b*vrval)+xl],wb
        cmp  xs,m_word [REL bpfxt]
        jne  bpf02
bpf04:
        mov  xl,m_word [REL bpfpf]
        mov  wa,m_word [REL (cfp_b*pfnlo)+xl]
        or   wa,wa
        jz   bpf07
        mov  wb,nulls
bpf05:
        mov  xl,m_word [REL xr]
        lea  xr,[xr+cfp_b]
bpf06:
        mov  wc,xl
        mov  xl,m_word [REL (cfp_b*vrval)+xl]
        cmp  m_word [ xl],b_trt
        je   bpf06
        push xl
        mov  xl,wc
        mov  m_word [REL (cfp_b*vrval)+xl],wb
        dec  wa
        jnz  bpf05
bpf07:
        xor  xr,xr
        cmp  m_word [REL kvpfl],0
        jz   bpf7c
        cmp  m_word [REL kvpfl],num02
        je   bpf7a
        call systm
        sti_ m_word [REL pfetm]
        sbi_ m_word [REL pfstm]
        call icbld
        ldi_ m_word [REL pfetm]
        jmp  bpf7b
bpf7a:
        ldi_ m_word [REL pfstm]
        call icbld
        call systm
bpf7b:
        sti_ m_word [REL pfstm]
        mov  m_word [REL pffnc],xs
bpf7c:
        push xr
        mov  wa,m_word [REL r_cod]
        scp_ wb
        sub  wb,wa
        mov  xl,m_word [REL bpfpf]
        push m_word [REL bpfsv]
        push wa
        push wb
        push m_word [REL flprt]
        push m_word [REL flptr]
        push xl
        push 0
        cmp  xs,lowspmin
        jb   sec06
        mov  m_word [REL flptr],xs
        mov  m_word [REL flprt],xs
        mov  wa,m_word [REL kvtra]
        add  wa,m_word [REL kvftr]
        or   wa,wa
        jnz  bpf09
        inc  m_word [REL kvfnc]
bpf08:
        mov  xr,m_word [REL (cfp_b*pfcod)+xl]
        mov  xr,m_word [REL (cfp_b*vrlbl)+xr]
        cmp  xr,stndl
        je   bpf17
        cmp  m_word [ xr],b_trt
        jne  bpf8a
        mov  xr,m_word [REL (cfp_b*trlbl)+xr]
bpf8a:
        jmp  m_word [ xr]
bpf09:
        mov  xr,m_word [REL (cfp_b*pfctr)+xl]
        mov  xl,m_word [REL (cfp_b*pfvbl)+xl]
        mov  wa,cfp_b*vrval
        cmp  m_word [REL kvtra],0
        jz   bpf10
        or   xr,xr
        jz   bpf10
        dec  m_word [REL kvtra]
        cmp  m_word [REL (cfp_b*trfnc)+xr],0
        jz   bpf11
        call trxeq
bpf10:
        cmp  m_word [REL kvftr],0
        jz   bpf16
        dec  m_word [REL kvftr]
bpf11:
        call prtsn
        call prtnm
        mov  wa,ch_pp
        call prtch
        mov  xl,m_word [REL (cfp_b*num01)+xs]
        cmp  m_word [REL (cfp_b*fargs)+xl],0
        jz   bpf15
        xor  wb,wb
        jmp  bpf13
bpf12:
        mov  wa,ch_cm
        call prtch
bpf13:
        mov  m_word [ xs],wb
        sal  wb,log_cfp_b
        add  xl,wb
        mov  xr,m_word [REL (cfp_b*pfarg)+xl]
        sub  xl,wb
        mov  xr,m_word [REL (cfp_b*vrval)+xr]
        call prtvl
        mov  wb,m_word [ xs]
        inc  wb
        cmp  wb,m_word [REL (cfp_b*fargs)+xl]
        jb   bpf12
bpf15:
        mov  wa,ch_rp
        call prtch
        call prtnl
bpf16:
        inc  m_word [REL kvfnc]
        mov  xl,m_word [REL r_fnc]
        call ktrex
        mov  xl,m_word [REL (cfp_b*num01)+xs]
        jmp  bpf08
bpf17:
        mov  w0,m_word [REL (cfp_b*num02)+xs]
        mov  m_word [REL flptr],w0
        mov  m_word [_rc_],286
        jmp  err_
	align	2
	db	bl_rc
b_rcl:
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	db	bl_sc
b_scl:
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	db	bl_tb
b_tbt:
	align	2
	db	bl_te
b_tet:
	align	2
	db	bl_vc
b_vct:
	align	2
	db	bl__i
b_vr_:
	align	2
	db	bl__i
b_vra:
        mov  xl,xr
        mov  wa,cfp_b*vrval
        call acess
        dec  m_word [_rc_]
        js   call_33
        dec  m_word [_rc_]
        jns  _l0053
        jmp  exfal
_l0053:
call_33:
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
b_vre:
        mov  m_word [_rc_],42
        jmp  err_
	align	2
	nop
b_vrg:
        mov  xr,m_word [REL (cfp_b*vrlbo)+xr]
        mov  xl,m_word [ xr]
        jmp  xl
	align	2
	nop
b_vrl:
        push m_word [REL (cfp_b*vrval)+xr]
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
b_vrs:
        mov  w0,m_word [ xs]
        mov  m_word [REL (cfp_b*vrvlo)+xr],w0
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
b_vrt:
        sub  xr,cfp_b*vrtra
        mov  xl,xr
        mov  wa,cfp_b*vrval
        mov  xr,m_word [REL (cfp_b*vrlbl)+xl]
        cmp  m_word [REL kvtra],0
        jz   bvrt2
        dec  m_word [REL kvtra]
        cmp  m_word [REL (cfp_b*trfnc)+xr],0
        jz   bvrt1
        call trxeq
        jmp  bvrt2
bvrt1:
        call prtsn
        mov  xr,xl
        mov  wa,ch_cl
        call prtch
        mov  wa,ch_pp
        call prtch
        call prtvn
        mov  wa,ch_rp
        call prtch
        call prtnl
        mov  xr,m_word [REL (cfp_b*vrlbl)+xl]
bvrt2:
        mov  xr,m_word [REL (cfp_b*trlbl)+xr]
        jmp  m_word [ xr]
	align	2
	nop
b_vrv:
        mov  wb,m_word [ xs]
        sub  xr,cfp_b*vrsto
        mov  xl,xr
        mov  wa,cfp_b*vrval
        call asign
        dec  m_word [_rc_]
        js   call_34
        dec  m_word [_rc_]
        jns  _l0054
        jmp  exfal
_l0054:
call_34:
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	db	bl_xn
b_xnt:
	align	2
	db	bl_xr
b_xrt:
	align	2
	db	bl__i
b_yyy:
	align	2
	db	bl__i
p_aaa:
	align	2
	db	bl_p0
p_aba:
        push wb
        push xr
        push m_word [REL pmhbs]
        push ndabb
        mov  m_word [REL pmhbs],xs
        jmp  succp
	align	2
	nop
p_abb:
        mov  m_word [REL pmhbs],wb
        jmp  flpop
	align	2
	db	bl_p0
p_abc:
        mov  xt,m_word [REL pmhbs]
        mov  wa,m_word [REL (cfp_b*num03)+xt]
        mov  w0,m_word [REL (cfp_b*num01)+xt]
        mov  m_word [REL pmhbs],w0
        cmp  xt,xs
        je   pabc1
        push xt
        push ndabd
        jmp  pabc2
pabc1:
        add  xs,cfp_b*num04
pabc2:
        cmp  wa,wb
        jne  succp
        mov  xr,m_word [REL (cfp_b*pthen)+xr]
        jmp  succp
	align	2
	nop
p_abd:
        mov  m_word [REL pmhbs],wb
        jmp  failp
	align	2
	db	bl_p0
p_abo:
        jmp  exfal
	align	2
	db	bl_p1
p_alt:
        push wb
        push m_word [REL (cfp_b*parm1)+xr]
        cmp  xs,lowspmin
        jb   sec06
        jmp  succp
	align	2
	db	bl_p1
p_ans:
        cmp  wb,m_word [REL pmssl]
        je   failp
        mov  xl,m_word [REL r_pms]
        lea  xl,[cfp_f+xl+wb]
        mov  w0,0
        mov  al,m_char [xl]
        mov  wa,w0
        cmp  wa,m_word [REL (cfp_b*parm1)+xr]
        jne  failp
        inc  wb
        jmp  succp
	align	2
	db	bl_p2
p_any:
pany1:
        cmp  wb,m_word [REL pmssl]
        je   failp
        mov  xl,m_word [REL r_pms]
        lea  xl,[cfp_f+xl+wb]
        mov  w0,0
        mov  al,m_char [xl]
        mov  wa,w0
        mov  xl,m_word [REL (cfp_b*parm1)+xr]
        sal  wa,log_cfp_b
        add  xl,wa
        mov  wa,m_word [REL (cfp_b*ctchs)+xl]
        and  wa,m_word [REL (cfp_b*parm2)+xr]
        or   wa,wa
        jz   failp
        inc  wb
        jmp  succp
	align	2
	db	bl_p1
p_ayd:
        call evals
        dec  m_word [_rc_]
        js   call_35
        dec  m_word [_rc_]
        jns  _l0055
        mov  m_word [_rc_],43
        jmp  err_
_l0055:
        dec  m_word [_rc_]
        jns  _l0056
        jmp  failp
_l0056:
        dec  m_word [_rc_]
        jns  _l0057
        jmp  pany1
_l0057:
call_35:
	align	2
	db	bl_p0
p_arb:
        mov  xr,m_word [REL (cfp_b*pthen)+xr]
        push wb
        push xr
        push wb
        push ndarc
        jmp  m_word [ xr]
	align	2
	nop
p_arc:
        cmp  wb,m_word [REL pmssl]
        je   flpop
        inc  wb
        push wb
        push xr
        mov  xr,m_word [REL (cfp_b*num02)+xs]
        jmp  m_word [ xr]
	align	2
	db	bl_p0
p_bal:
        xor  wc,wc
        mov  xl,m_word [REL r_pms]
        lea  xl,[cfp_f+xl+wb]
        jmp  pbal2
pbal1:
        mov  w0,0
        mov  al,m_char [xl]
        mov  wa,w0
        inc  xl
        inc  wb
        cmp  wa,ch_pp
        je   pbal3
        cmp  wa,ch_rp
        je   pbal4
        or   wc,wc
        jz   pbal5
pbal2:
        cmp  wb,m_word [REL pmssl]
        jne  pbal1
        jmp  failp
pbal3:
        inc  wc
        jmp  pbal2
pbal4:
        or   wc,wc
        jz   failp
        dec  wc
        or   wc,wc
        jnz  pbal2
pbal5:
        push wb
        push xr
        jmp  succp
	align	2
	db	bl_p1
p_bkd:
        call evals
        dec  m_word [_rc_]
        js   call_36
        dec  m_word [_rc_]
        jns  _l0058
        mov  m_word [_rc_],44
        jmp  err_
_l0058:
        dec  m_word [_rc_]
        jns  _l0059
        jmp  failp
_l0059:
        dec  m_word [_rc_]
        jns  _l0060
        jmp  pbrk1
_l0060:
call_36:
	align	2
	db	bl_p1
p_bks:
        mov  wc,m_word [REL pmssl]
        sub  wc,wb
        or   wc,wc
        jz   failp
        mov  xl,m_word [REL r_pms]
        lea  xl,[cfp_f+xl+wb]
pbks1:
        mov  w0,0
        mov  al,m_char [xl]
        mov  wa,w0
        inc  xl
        cmp  wa,m_word [REL (cfp_b*parm1)+xr]
        je   succp
        inc  wb
        dec  wc
        jnz  pbks1
        jmp  failp
	align	2
	db	bl_p2
p_brk:
pbrk1:
        mov  wc,m_word [REL pmssl]
        sub  wc,wb
        or   wc,wc
        jz   failp
        mov  xl,m_word [REL r_pms]
        lea  xl,[cfp_f+xl+wb]
        mov  m_word [REL psave],xr
pbrk2:
        mov  w0,0
        mov  al,m_char [xl]
        mov  wa,w0
        inc  xl
        mov  xr,m_word [REL (cfp_b*parm1)+xr]
        sal  wa,log_cfp_b
        add  xr,wa
        mov  wa,m_word [REL (cfp_b*ctchs)+xr]
        mov  xr,m_word [REL psave]
        and  wa,m_word [REL (cfp_b*parm2)+xr]
        or   wa,wa
        jnz  succp
        inc  wb
        dec  wc
        jnz  pbrk2
        jmp  failp
	align	2
	db	bl_p0
p_bkx:
        inc  wb
        jmp  succp
	align	2
	db	bl_p1
p_bxd:
        call evals
        dec  m_word [_rc_]
        js   call_37
        dec  m_word [_rc_]
        jns  _l0061
        mov  m_word [_rc_],45
        jmp  err_
_l0061:
        dec  m_word [_rc_]
        jns  _l0062
        jmp  failp
_l0062:
        dec  m_word [_rc_]
        jns  _l0063
        jmp  pbrk1
_l0063:
call_37:
	align	2
	db	bl_p2
p_cas:
        push xr
        push wb
        mov  xl,m_word [REL (cfp_b*parm1)+xr]
        ldi_ wb
        mov  wb,m_word [REL (cfp_b*parm2)+xr]
        call icbld
        mov  wa,wb
        mov  wb,xr
        call asinp
        dec  m_word [_rc_]
        js   call_38
        dec  m_word [_rc_]
        jns  _l0064
        jmp  flpop
_l0064:
call_38:
        pop  wb
        pop  xr
        jmp  succp
	align	2
	db	bl_p1
p_exa:
        call evalp
        dec  m_word [_rc_]
        js   call_39
        dec  m_word [_rc_]
        jns  _l0065
        jmp  failp
_l0065:
call_39:
        cmp  wa,p_aaa
        jb   pexa1
        push wb
        push xr
        push m_word [REL pmhbs]
        push ndexb
        mov  m_word [REL pmhbs],xs
        mov  xr,xl
        jmp  m_word [ xr]
pexa1:
        cmp  wa,b_scl
        je   pexa2
        push xl
        mov  xl,xr
        call gtstg
        dec  m_word [_rc_]
        js   call_40
        dec  m_word [_rc_]
        jns  _l0066
        mov  m_word [_rc_],46
        jmp  err_
_l0066:
call_40:
        mov  wc,xr
        mov  xr,xl
        mov  xl,wc
pexa2:
        cmp  m_word [REL (cfp_b*sclen)+xl],0
        jz   succp
        jmp  pstr1
	align	2
	nop
p_exb:
        mov  m_word [REL pmhbs],wb
        jmp  flpop
	align	2
	nop
p_exc:
        mov  m_word [REL pmhbs],wb
        jmp  failp
	align	2
	db	bl_p0
p_fal:
        jmp  failp
	align	2
	db	bl_p0
p_fen:
        push wb
        push ndabo
        jmp  succp
	align	2
	db	bl_p0
p_fna:
        push m_word [REL pmhbs]
        push ndfnb
        mov  m_word [REL pmhbs],xs
        jmp  succp
	align	2
	db	bl_p0
p_fnb:
        mov  m_word [REL pmhbs],wb
        jmp  failp
	align	2
	db	bl_p0
p_fnc:
        mov  xt,m_word [REL pmhbs]
        mov  w0,m_word [REL (cfp_b*num01)+xt]
        mov  m_word [REL pmhbs],w0
        cmp  xt,xs
        je   pfnc1
        push xt
        push ndfnd
        jmp  succp
pfnc1:
        add  xs,cfp_b*num02
        jmp  succp
	align	2
	db	bl_p0
p_fnd:
        mov  xs,wb
        jmp  flpop
	align	2
	db	bl_p0
p_ima:
        push wb
        push xr
        push m_word [REL pmhbs]
        push ndimb
        mov  m_word [REL pmhbs],xs
        jmp  succp
	align	2
	nop
p_imb:
        mov  m_word [REL pmhbs],wb
        jmp  flpop
	align	2
	db	bl_p2
p_imc:
        mov  xt,m_word [REL pmhbs]
        mov  wa,wb
        mov  wb,m_word [REL (cfp_b*num03)+xt]
        mov  w0,m_word [REL (cfp_b*num01)+xt]
        mov  m_word [REL pmhbs],w0
        cmp  xt,xs
        je   pimc1
        push xt
        push ndimd
        jmp  pimc2
pimc1:
        add  xs,cfp_b*num04
pimc2:
        push wa
        push xr
        mov  xl,m_word [REL r_pms]
        sub  wa,wb
        call sbstr
        mov  wb,xr
        mov  xr,m_word [ xs]
        mov  xl,m_word [REL (cfp_b*parm1)+xr]
        mov  wa,m_word [REL (cfp_b*parm2)+xr]
        call asinp
        dec  m_word [_rc_]
        js   call_41
        dec  m_word [_rc_]
        jns  _l0067
        jmp  flpop
_l0067:
call_41:
        pop  xr
        pop  wb
        jmp  succp
	align	2
	nop
p_imd:
        mov  m_word [REL pmhbs],wb
        jmp  failp
	align	2
	db	bl_p1
p_len:
plen1:
        add  wb,m_word [REL (cfp_b*parm1)+xr]
        cmp  wb,m_word [REL pmssl]
        jbe  succp
        jmp  failp
	align	2
	db	bl_p1
p_lnd:
        call evali
        dec  m_word [_rc_]
        js   call_42
        dec  m_word [_rc_]
        jns  _l0068
        mov  m_word [_rc_],47
        jmp  err_
_l0068:
        dec  m_word [_rc_]
        jns  _l0069
        mov  m_word [_rc_],48
        jmp  err_
_l0069:
        dec  m_word [_rc_]
        jns  _l0070
        jmp  failp
_l0070:
        dec  m_word [_rc_]
        jns  _l0071
        jmp  plen1
_l0071:
call_42:
	align	2
	db	bl_p1
p_nad:
        call evals
        dec  m_word [_rc_]
        js   call_43
        dec  m_word [_rc_]
        jns  _l0072
        mov  m_word [_rc_],49
        jmp  err_
_l0072:
        dec  m_word [_rc_]
        jns  _l0073
        jmp  failp
_l0073:
        dec  m_word [_rc_]
        jns  _l0074
        jmp  pnay1
_l0074:
call_43:
	align	2
	db	bl_p1
p_nas:
        cmp  wb,m_word [REL pmssl]
        je   failp
        mov  xl,m_word [REL r_pms]
        lea  xl,[cfp_f+xl+wb]
        mov  w0,0
        mov  al,m_char [xl]
        mov  wa,w0
        cmp  wa,m_word [REL (cfp_b*parm1)+xr]
        je   failp
        inc  wb
        jmp  succp
	align	2
	db	bl_p2
p_nay:
pnay1:
        cmp  wb,m_word [REL pmssl]
        je   failp
        mov  xl,m_word [REL r_pms]
        lea  xl,[cfp_f+xl+wb]
        mov  w0,0
        mov  al,m_char [xl]
        mov  wa,w0
        sal  wa,log_cfp_b
        mov  xl,m_word [REL (cfp_b*parm1)+xr]
        add  xl,wa
        mov  wa,m_word [REL (cfp_b*ctchs)+xl]
        and  wa,m_word [REL (cfp_b*parm2)+xr]
        or   wa,wa
        jnz  failp
        inc  wb
        jmp  succp
	align	2
	db	bl_p0
p_nth:
        mov  xt,m_word [REL pmhbs]
        mov  wa,m_word [REL (cfp_b*num01)+xt]
        cmp  wa,num02
        jbe  pnth2
        mov  m_word [REL pmhbs],wa
        mov  xr,m_word [REL (cfp_b*num02)+xt]
        cmp  xt,xs
        je   pnth1
        push xt
        push ndexc
        jmp  succp
pnth1:
        add  xs,cfp_b*num04
        jmp  succp
pnth2:
        mov  m_word [REL pmssl],wb
        cmp  m_word [REL pmdfl],0
        jz   pnth6
pnth3:
        sub  xt,cfp_b
        lea  xt,[xt-cfp_b]
        mov  wa,m_word [xt]
        cmp  wa,ndpad
        je   pnth4
        cmp  wa,ndpab
        jne  pnth5
        push m_word [REL (cfp_b*num01)+xt]
        cmp  xs,lowspmin
        jb   sec06
        jmp  pnth3
pnth4:
        mov  wa,m_word [REL (cfp_b*num01)+xt]
        mov  wb,m_word [ xs]
        mov  m_word [ xs],xt
        sub  wa,wb
        mov  xl,m_word [REL r_pms]
        call sbstr
        mov  wb,xr
        mov  xt,m_word [ xs]
        mov  xl,m_word [REL (cfp_b*num02)+xt]
        mov  wa,m_word [REL (cfp_b*parm2)+xl]
        mov  xl,m_word [REL (cfp_b*parm1)+xl]
        call asinp
        dec  m_word [_rc_]
        js   call_44
        dec  m_word [_rc_]
        jns  _l0075
        jmp  exfal
_l0075:
call_44:
        pop  xt
pnth5:
        cmp  xt,xs
        jne  pnth3
pnth6:
        mov  xs,m_word [REL pmhbs]
        pop  wb
        pop  wc
        mov  wa,m_word [REL pmssl]
        mov  xl,m_word [REL r_pms]
        mov  w0,0
        mov  m_word [REL r_pms],w0
        or   wc,wc
        jz   pnth7
        cmp  wc,num02
        je   pnth9
        sub  wa,wb
        call sbstr
        push xr
        lcw_ xr
        jmp  m_word [ xr]
pnth7:
        push wb
        push wa
pnth8:
        push xl
pnth9:
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	db	bl_p1
p_pos:
        cmp  wb,m_word [REL (cfp_b*parm1)+xr]
        je   succp
        or   wb,wb
        jnz  failp
        mov  xt,m_word [REL pmhbs]
        lea  xt,[xt-cfp_b]
        cmp  xr,m_word [xt]
        jne  failp
ppos2:
        lea  xt,[xt-cfp_b]
        cmp  m_word [xt],nduna
        jne  failp
        mov  wb,m_word [REL (cfp_b*parm1)+xr]
        cmp  wb,m_word [REL pmssl]
        ja   exfal
        mov  m_word [REL (cfp_b*num02)+xt],wb
        jmp  succp
	align	2
	db	bl_p1
p_psd:
        call evali
        dec  m_word [_rc_]
        js   call_45
        dec  m_word [_rc_]
        jns  _l0076
        mov  m_word [_rc_],50
        jmp  err_
_l0076:
        dec  m_word [_rc_]
        jns  _l0077
        mov  m_word [_rc_],51
        jmp  err_
_l0077:
        dec  m_word [_rc_]
        jns  _l0078
        jmp  failp
_l0078:
        dec  m_word [_rc_]
        jns  _l0079
        jmp  ppos1
_l0079:
call_45:
ppos1:
        cmp  wb,m_word [REL (cfp_b*parm1)+xr]
        je   succp
        or   wb,wb
        jnz  failp
        cmp  m_word [REL evlif],0
        jnz  failp
        mov  xt,m_word [REL pmhbs]
        mov  wa,m_word [REL evlio]
        lea  xt,[xt-cfp_b]
        cmp  wa,m_word [xt]
        jne  failp
        jmp  ppos2
	align	2
	db	bl_p0
p_paa:
        push wb
        push ndpab
        jmp  succp
	align	2
	nop
p_pab:
        jmp  failp
	align	2
	db	bl_p2
p_pac:
        push wb
        push xr
        push wb
        push ndpad
        mov  m_word [REL pmdfl],xs
        jmp  succp
	align	2
	nop
p_pad:
        jmp  flpop
	align	2
	db	bl_p0
p_rem:
        mov  wb,m_word [REL pmssl]
        jmp  succp
	align	2
	db	bl_p1
p_rpd:
        call evali
        dec  m_word [_rc_]
        js   call_46
        dec  m_word [_rc_]
        jns  _l0080
        mov  m_word [_rc_],52
        jmp  err_
_l0080:
        dec  m_word [_rc_]
        jns  _l0081
        mov  m_word [_rc_],53
        jmp  err_
_l0081:
        dec  m_word [_rc_]
        jns  _l0082
        jmp  failp
_l0082:
        dec  m_word [_rc_]
        jns  _l0083
        jmp  prps1
_l0083:
call_46:
prps1:
        mov  wc,m_word [REL pmssl]
        sub  wc,wb
        cmp  wc,m_word [REL (cfp_b*parm1)+xr]
        je   succp
        or   wb,wb
        jnz  failp
        cmp  m_word [REL evlif],0
        jnz  failp
        mov  xt,m_word [REL pmhbs]
        mov  wa,m_word [REL evlio]
        lea  xt,[xt-cfp_b]
        cmp  wa,m_word [xt]
        jne  failp
        jmp  prps2
	align	2
	db	bl_p1
p_rps:
        mov  wc,m_word [REL pmssl]
        sub  wc,wb
        cmp  wc,m_word [REL (cfp_b*parm1)+xr]
        je   succp
        or   wb,wb
        jnz  failp
        mov  xt,m_word [REL pmhbs]
        lea  xt,[xt-cfp_b]
        cmp  xr,m_word [xt]
        jne  failp
prps2:
        lea  xt,[xt-cfp_b]
        cmp  m_word [xt],nduna
        jne  failp
        mov  wb,m_word [REL pmssl]
        cmp  wb,m_word [REL (cfp_b*parm1)+xr]
        jb   failp
        sub  wb,m_word [REL (cfp_b*parm1)+xr]
        mov  m_word [REL (cfp_b*num02)+xt],wb
        jmp  succp
	align	2
	db	bl_p1
p_rtb:
prtb1:
        mov  wc,wb
        mov  wb,m_word [REL pmssl]
        cmp  wb,m_word [REL (cfp_b*parm1)+xr]
        jb   failp
        sub  wb,m_word [REL (cfp_b*parm1)+xr]
        cmp  wb,wc
        jae  succp
        jmp  failp
	align	2
	db	bl_p1
p_rtd:
        call evali
        dec  m_word [_rc_]
        js   call_47
        dec  m_word [_rc_]
        jns  _l0084
        mov  m_word [_rc_],54
        jmp  err_
_l0084:
        dec  m_word [_rc_]
        jns  _l0085
        mov  m_word [_rc_],55
        jmp  err_
_l0085:
        dec  m_word [_rc_]
        jns  _l0086
        jmp  failp
_l0086:
        dec  m_word [_rc_]
        jns  _l0087
        jmp  prtb1
_l0087:
call_47:
	align	2
	db	bl_p1
p_spd:
        call evals
        dec  m_word [_rc_]
        js   call_48
        dec  m_word [_rc_]
        jns  _l0088
        mov  m_word [_rc_],56
        jmp  err_
_l0088:
        dec  m_word [_rc_]
        jns  _l0089
        jmp  failp
_l0089:
        dec  m_word [_rc_]
        jns  _l0090
        jmp  pspn1
_l0090:
call_48:
	align	2
	db	bl_p2
p_spn:
pspn1:
        mov  wc,m_word [REL pmssl]
        sub  wc,wb
        or   wc,wc
        jz   failp
        mov  xl,m_word [REL r_pms]
        lea  xl,[cfp_f+xl+wb]
        mov  m_word [REL psavc],wb
        mov  m_word [REL psave],xr
pspn2:
        mov  w0,0
        mov  al,m_char [xl]
        mov  wa,w0
        inc  xl
        sal  wa,log_cfp_b
        mov  xr,m_word [REL (cfp_b*parm1)+xr]
        add  xr,wa
        mov  wa,m_word [REL (cfp_b*ctchs)+xr]
        mov  xr,m_word [REL psave]
        and  wa,m_word [REL (cfp_b*parm2)+xr]
        or   wa,wa
        jz   pspn3
        inc  wb
        dec  wc
        jnz  pspn2
pspn3:
        cmp  wb,m_word [REL psavc]
        jne  succp
        jmp  failp
	align	2
	db	bl_p1
p_sps:
        mov  wc,m_word [REL pmssl]
        sub  wc,wb
        or   wc,wc
        jz   failp
        mov  xl,m_word [REL r_pms]
        lea  xl,[cfp_f+xl+wb]
        mov  m_word [REL psavc],wb
psps1:
        mov  w0,0
        mov  al,m_char [xl]
        mov  wa,w0
        inc  xl
        cmp  wa,m_word [REL (cfp_b*parm1)+xr]
        jne  psps2
        inc  wb
        dec  wc
        jnz  psps1
psps2:
        cmp  wb,m_word [REL psavc]
        jne  succp
        jmp  failp
	align	2
	db	bl_p1
p_str:
        mov  xl,m_word [REL (cfp_b*parm1)+xr]
pstr1:
        mov  m_word [REL psave],xr
        mov  xr,m_word [REL r_pms]
        lea  xr,[cfp_f+xr+wb]
        add  wb,m_word [REL (cfp_b*sclen)+xl]
        cmp  wb,m_word [REL pmssl]
        ja   failp
        mov  m_word [REL psavc],wb
        mov  wa,m_word [REL (cfp_b*sclen)+xl]
        add  xl,cfp_f
        repe cmps_b
        mov  xl,0
        mov  xr,xl
        jnz  failp
        mov  xr,m_word [REL psave]
        mov  wb,m_word [REL psavc]
        jmp  succp
	align	2
	db	bl_p0
p_suc:
        push wb
        push xr
        jmp  succp
	align	2
	db	bl_p1
p_tab:
ptab1:
        cmp  wb,m_word [REL (cfp_b*parm1)+xr]
        ja   failp
        mov  wb,m_word [REL (cfp_b*parm1)+xr]
        cmp  wb,m_word [REL pmssl]
        jbe  succp
        jmp  failp
	align	2
	db	bl_p1
p_tbd:
        call evali
        dec  m_word [_rc_]
        js   call_49
        dec  m_word [_rc_]
        jns  _l0091
        mov  m_word [_rc_],57
        jmp  err_
_l0091:
        dec  m_word [_rc_]
        jns  _l0092
        mov  m_word [_rc_],58
        jmp  err_
_l0092:
        dec  m_word [_rc_]
        jns  _l0093
        jmp  failp
_l0093:
        dec  m_word [_rc_]
        jns  _l0094
        jmp  ptab1
_l0094:
call_49:
	align	2
	nop
p_una:
        mov  xr,wb
        mov  wb,m_word [ xs]
        cmp  wb,m_word [REL pmssl]
        je   exfal
        inc  wb
        mov  m_word [ xs],wb
        push xr
        push nduna
        jmp  m_word [ xr]
	align	2
	db	bl__i
p_yyy:
	align	2
	nop
l_abo:
labo1:
        mov  wa,m_word [REL kvert]
        or   wa,wa
        jz   labo3
        call sysax
        mov  wc,m_word [REL kvstn]
        call filnm
        mov  xr,m_word [REL r_cod]
        mov  wc,m_word [REL (cfp_b*cdsln)+xr]
        xor  wb,wb
        mov  xr,m_word [REL stage]
        call sysea
        dec  m_word [_rc_]
        js   call_50
        dec  m_word [_rc_]
        jns  _l0095
        jmp  stpr4
_l0095:
call_50:
        call prtpg
        or   xr,xr
        jz   labo2
        call prtst
labo2:
        call ermsg
        xor  xr,xr
        jmp  stopr
labo3:
        mov  m_word [_rc_],36
        jmp  err_
	align	2
	nop
l_cnt:
lcnt1:
        mov  xr,m_word [REL r_cnt]
        or   xr,xr
        jz   lcnt3
        mov  w0,0
        mov  m_word [REL r_cnt],w0
        mov  m_word [REL r_cod],xr
        cmp  m_word [ xr],b_cdc
        jne  lcnt2
        mov  wa,m_word [REL stxoc]
        cmp  wa,m_word [REL stxof]
        jae  lcnt4
lcnt2:
        add  xr,m_word [REL stxof]
        lcp_ xr
        mov  xs,m_word [REL flptr]
        lcw_ xr
        jmp  m_word [ xr]
lcnt3:
        inc  m_word [REL errft]
        mov  m_word [_rc_],37
        jmp  err_
lcnt4:
        inc  m_word [REL errft]
        mov  m_word [_rc_],332
        jmp  err_
	align	2
	nop
l_end:
lend0:
        mov  xr,endms
        jmp  stopr
	align	2
	nop
l_frt:
        mov  wa,scfrt
        jmp  retrn
	align	2
	nop
l_nrt:
        mov  wa,scnrt
        jmp  retrn
	align	2
	nop
l_rtn:
        mov  wa,scrtn
        jmp  retrn
	align	2
	nop
l_scn:
        mov  xr,m_word [REL r_cnt]
        or   xr,xr
        jz   lscn2
        mov  w0,0
        mov  m_word [REL r_cnt],w0
        cmp  m_word [REL kvert],nm320
        jne  lscn1
        cmp  m_word [REL kvert],nm321
        je   lscn2
        mov  m_word [REL r_cod],xr
        add  xr,m_word [REL stxoc]
        lcp_ xr
        lcw_ xr
        jmp  m_word [ xr]
lscn1:
        inc  m_word [REL errft]
        mov  m_word [_rc_],331
        jmp  err_
lscn2:
        inc  m_word [REL errft]
        mov  m_word [_rc_],321
        jmp  err_
	align	2
	nop
l_und:
        mov  m_word [_rc_],38
        jmp  err_
	align	2
	nop
s_any:
        mov  wb,p_ans
        mov  xl,p_any
        mov  wc,p_ayd
        call patst
        dec  m_word [_rc_]
        js   call_51
        dec  m_word [_rc_]
        jns  _l0096
        mov  m_word [_rc_],59
        jmp  err_
_l0096:
call_51:
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
s_app:
        or   wa,wa
        jz   sapp3
        dec  wa
        mov  wb,wa
        sal  wb,log_cfp_b
        mov  xt,xs
        add  xt,wb
        mov  xr,m_word [ xt]
        or   wa,wa
        jz   sapp2
        mov  wb,wa
sapp1:
        sub  xt,cfp_b
        mov  w0,m_word [ xt]
        mov  m_word [REL (cfp_b*num01)+xt],w0
        dec  wb
        jnz  sapp1
sapp2:
        add  xs,cfp_b
        call gtnvr
        dec  m_word [_rc_]
        js   call_52
        dec  m_word [_rc_]
        jns  _l0097
        jmp  sapp3
_l0097:
call_52:
        mov  xl,m_word [REL (cfp_b*vrfnc)+xr]
        jmp  cfunc
sapp3:
        mov  m_word [_rc_],60
        jmp  err_
	align	2
	nop
s_abn:
        xor  xr,xr
        mov  wb,p_alt
        call pbild
        mov  xl,xr
        mov  wb,p_abc
        xor  xr,xr
        call pbild
        mov  m_word [REL (cfp_b*pthen)+xr],xl
        mov  wa,xl
        mov  xl,xr
        mov  xr,m_word [ xs]
        mov  m_word [ xs],wa
        call gtpat
        dec  m_word [_rc_]
        js   call_53
        dec  m_word [_rc_]
        jns  _l0098
        mov  m_word [_rc_],61
        jmp  err_
_l0098:
call_53:
        call pconc
        mov  xl,xr
        mov  wb,p_aba
        xor  xr,xr
        call pbild
        mov  m_word [REL (cfp_b*pthen)+xr],xl
        mov  xl,m_word [ xs]
        mov  m_word [REL (cfp_b*parm1)+xl],xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
s_arg:
        call gtsmi
        dec  m_word [_rc_]
        js   call_54
        dec  m_word [_rc_]
        jns  _l0099
        mov  m_word [_rc_],62
        jmp  err_
_l0099:
        dec  m_word [_rc_]
        jns  _l0100
        jmp  exfal
_l0100:
call_54:
        mov  wa,xr
        pop  xr
        call gtnvr
        dec  m_word [_rc_]
        js   call_55
        dec  m_word [_rc_]
        jns  _l0101
        jmp  sarg1
_l0101:
call_55:
        mov  xr,m_word [REL (cfp_b*vrfnc)+xr]
        cmp  m_word [ xr],b_pfc
        jne  sarg1
        or   wa,wa
        jz   exfal
        cmp  wa,m_word [REL (cfp_b*fargs)+xr]
        ja   exfal
        sal  wa,log_cfp_b
        add  xr,wa
        mov  xr,m_word [REL (cfp_b*pfagb)+xr]
        jmp  exvnm
sarg1:
        mov  m_word [_rc_],63
        jmp  err_
	align	2
	nop
s_arr:
        pop  xl
        pop  xr
        call gtint
        dec  m_word [_rc_]
        js   call_56
        dec  m_word [_rc_]
        jns  _l0102
        jmp  sar02
_l0102:
call_56:
        ldi_ m_word [REL (cfp_b*icval)+xr]
        sti_ w0
        or   w0,w0
        jle  sar10
        sti_ w0
        or   w0,w0
        js   sar11
        sti_ wa
        call vmake
        dec  m_word [_rc_]
        js   call_57
        dec  m_word [_rc_]
        jns  _l0103
        jmp  sar11
_l0103:
call_57:
        jmp  exsid
sar02:
        push xr
        call xscni
        dec  m_word [_rc_]
        js   call_58
        dec  m_word [_rc_]
        jns  _l0104
        mov  m_word [_rc_],64
        jmp  err_
_l0104:
        dec  m_word [_rc_]
        jns  _l0105
        jmp  exnul
_l0105:
call_58:
        push m_word [REL r_xsc]
        push xl
        mov  w0,0
        mov  m_word [REL arcdm],w0
        mov  w0,0
        mov  m_word [REL arptr],w0
        ldi_ m_word [REL intv1]
        sti_ m_word [REL arnel]
sar03:
        ldi_ m_word [REL intv1]
        sti_ m_word [REL arsvl]
        mov  wc,ch_cl
        mov  xl,ch_cm
        xor  wa,wa
        call xscan
        cmp  wa,num01
        jne  sar04
        call gtint
        dec  m_word [_rc_]
        js   call_59
        dec  m_word [_rc_]
        jns  _l0106
        mov  m_word [_rc_],65
        jmp  err_
_l0106:
call_59:
        ldi_ m_word [REL (cfp_b*icval)+xr]
        sti_ m_word [REL arsvl]
        mov  wc,ch_cm
        mov  xl,wc
        xor  wa,wa
        call xscan
sar04:
        call gtint
        dec  m_word [_rc_]
        js   call_60
        dec  m_word [_rc_]
        jns  _l0107
        mov  m_word [_rc_],66
        jmp  err_
_l0107:
call_60:
        ldi_ m_word [REL (cfp_b*icval)+xr]
        sbi_ m_word [REL arsvl]
        iov_ sar10
        sti_ w0
        or   w0,w0
        jl   sar10
        adi_ m_word [REL intv1]
        iov_ sar10
        mov  xl,m_word [REL arptr]
        or   xl,xl
        jz   sar05
        add  xl,m_word [ xs]
        sti_ m_word [REL (cfp_b*cfp_i)+xl]
        ldi_ m_word [REL arsvl]
        sti_ m_word [ xl]
        add  m_word [REL arptr],cfp_b*ardms
        jmp  sar06
sar05:
        inc  m_word [REL arcdm]
        mli_ m_word [REL arnel]
        iov_ sar11
        sti_ m_word [REL arnel]
sar06:
        or   wa,wa
        jnz  sar03
        cmp  m_word [REL arptr],0
        jnz  sar09
        ldi_ m_word [REL arnel]
        sti_ w0
        or   w0,w0
        js   sar11
        sti_ wb
        sal  wb,log_cfp_b
        mov  wa,cfp_b*arsi_
        mov  wc,m_word [REL arcdm]
sar07:
        add  wa,cfp_b*ardms
        dec  wc
        jnz  sar07
        mov  xl,wa
        add  wa,wb
        add  wa,cfp_b
        cmp  wa,m_word [REL mxlen]
        ja   sar11
        call alloc
        mov  wb,m_word [ xs]
        mov  m_word [ xs],xr
        mov  wc,wa
        shr  wa,log_cfp_b
sar08:
        mov  w0,wb
        stos_w
        dec  wa
        jnz  sar08
        pop  xr
        mov  wb,m_word [ xs]
        mov  m_word [ xr],b_art
        mov  m_word [REL (cfp_b*arlen)+xr],wc
        mov  w0,0
        mov  m_word [REL (cfp_b*idval)+xr],w0
        mov  m_word [REL (cfp_b*arofs)+xr],xl
        mov  w0,m_word [REL arcdm]
        mov  m_word [REL (cfp_b*arndm)+xr],w0
        mov  wc,xr
        add  xr,xl
        mov  m_word [ xr],wb
        mov  m_word [REL arptr],cfp_b*arlbd
        mov  m_word [REL r_xsc],wb
        mov  m_word [ xs],wc
        mov  w0,0
        mov  m_word [REL xsofs],w0
        jmp  sar03
sar09:
        pop  xr
        jmp  exsid
sar10:
        mov  m_word [_rc_],67
        jmp  err_
sar11:
        mov  m_word [_rc_],68
        jmp  err_
	align	2
	nop
s_atn:
        pop  xr
        call gtrea
        dec  m_word [_rc_]
        js   call_61
        dec  m_word [_rc_]
        jns  _l0108
        mov  m_word [_rc_],301
        jmp  err_
_l0108:
call_61:
        lea  w0,[REL (cfp_b*rcval)+xr]
        call ldr_
        call atn_
        jmp  exrea
	align	2
	nop
s_bsp:
        call iofcb
        dec  m_word [_rc_]
        js   call_62
        dec  m_word [_rc_]
        jns  _l0109
        mov  m_word [_rc_],316
        jmp  err_
_l0109:
        dec  m_word [_rc_]
        jns  _l0110
        mov  m_word [_rc_],316
        jmp  err_
_l0110:
        dec  m_word [_rc_]
        jns  _l0111
        mov  m_word [_rc_],317
        jmp  err_
_l0111:
call_62:
        call sysbs
        dec  m_word [_rc_]
        js   call_63
        dec  m_word [_rc_]
        jns  _l0112
        mov  m_word [_rc_],317
        jmp  err_
_l0112:
        dec  m_word [_rc_]
        jns  _l0113
        mov  m_word [_rc_],318
        jmp  err_
_l0113:
        dec  m_word [_rc_]
        jns  _l0114
        mov  m_word [_rc_],319
        jmp  err_
_l0114:
call_63:
        jmp  exnul
	align	2
	nop
s_brk:
        mov  wb,p_bks
        mov  xl,p_brk
        mov  wc,p_bkd
        call patst
        dec  m_word [_rc_]
        js   call_64
        dec  m_word [_rc_]
        jns  _l0115
        mov  m_word [_rc_],69
        jmp  err_
_l0115:
call_64:
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
s_bkx:
        mov  wb,p_bks
        mov  xl,p_brk
        mov  wc,p_bxd
        call patst
        dec  m_word [_rc_]
        js   call_65
        dec  m_word [_rc_]
        jns  _l0116
        mov  m_word [_rc_],70
        jmp  err_
_l0116:
call_65:
        push xr
        mov  wb,p_bkx
        call pbild
        mov  w0,m_word [ xs]
        mov  m_word [REL (cfp_b*pthen)+xr],w0
        mov  wb,p_alt
        call pbild
        mov  wa,xr
        mov  xr,m_word [ xs]
        mov  m_word [REL (cfp_b*pthen)+xr],wa
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
s_chr:
        call gtsmi
        dec  m_word [_rc_]
        js   call_66
        dec  m_word [_rc_]
        jns  _l0117
        mov  m_word [_rc_],281
        jmp  err_
_l0117:
        dec  m_word [_rc_]
        jns  _l0118
        jmp  schr1
_l0118:
call_66:
        cmp  wc,cfp_a
        jae  schr1
        mov  wa,num01
        mov  wb,wc
        call alocs
        mov  xl,xr
        add  xl,cfp_f
        mov  m_char [xl],wb_l
        xor  xl,xl
        push xr
        lcw_ xr
        jmp  m_word [ xr]
schr1:
        mov  m_word [_rc_],282
        jmp  err_
	align	2
	nop
s_chp:
        pop  xr
        call gtrea
        dec  m_word [_rc_]
        js   call_67
        dec  m_word [_rc_]
        jns  _l0119
        mov  m_word [_rc_],302
        jmp  err_
_l0119:
call_67:
        lea  w0,[REL (cfp_b*rcval)+xr]
        call ldr_
        call chp_
        jmp  exrea
	align	2
	nop
s_clr:
        call xscni
        dec  m_word [_rc_]
        js   call_68
        dec  m_word [_rc_]
        jns  _l0120
        mov  m_word [_rc_],71
        jmp  err_
_l0120:
        dec  m_word [_rc_]
        jns  _l0121
        jmp  sclr2
_l0121:
call_68:
sclr1:
        mov  wc,ch_cm
        mov  xl,wc
        mov  wa,xs
        call xscan
        call gtnvr
        dec  m_word [_rc_]
        js   call_69
        dec  m_word [_rc_]
        jns  _l0122
        mov  m_word [_rc_],72
        jmp  err_
_l0122:
call_69:
        mov  w0,0
        mov  m_word [REL (cfp_b*vrget)+xr],w0
        or   wa,wa
        jnz  sclr1
sclr2:
        mov  wb,m_word [REL hshtb]
sclr3:
        cmp  wb,m_word [REL hshte]
        je   exnul
        mov  xr,wb
        add  wb,cfp_b
        sub  xr,cfp_b*vrnxt
sclr4:
        mov  xr,m_word [REL (cfp_b*vrnxt)+xr]
        or   xr,xr
        jz   sclr3
        cmp  m_word [REL (cfp_b*vrget)+xr],0
        jnz  sclr5
        call setvr
        jmp  sclr4
sclr5:
        cmp  m_word [REL (cfp_b*vrsto)+xr],b_vre
        je   sclr4
        mov  xl,xr
sclr6:
        mov  wa,xl
        mov  xl,m_word [REL (cfp_b*vrval)+xl]
        cmp  m_word [ xl],b_trt
        je   sclr6
        mov  xl,wa
        mov  m_word [REL (cfp_b*vrval)+xl],nulls
        jmp  sclr4
	align	2
	nop
s_cod:
        pop  xr
        call gtcod
        dec  m_word [_rc_]
        js   call_70
        dec  m_word [_rc_]
        jns  _l0123
        jmp  exfal
_l0123:
call_70:
        push xr
        mov  w0,0
        mov  m_word [REL r_ccb],w0
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
s_col:
        pop  xr
        call gtint
        dec  m_word [_rc_]
        js   call_71
        dec  m_word [_rc_]
        jns  _l0124
        mov  m_word [_rc_],73
        jmp  err_
_l0124:
call_71:
        ldi_ m_word [REL (cfp_b*icval)+xr]
        sti_ m_word [REL clsvi]
        xor  wb,wb
        mov  w0,0
        mov  m_word [REL r_ccb],w0
        mov  w0,0
        mov  m_word [REL dnams],w0
        call gbcol
        mov  m_word [REL dnams],xr
        mov  wa,m_word [REL dname]
        sub  wa,m_word [REL dnamp]
        shr  wa,log_cfp_b
        ldi_ wa
        sbi_ m_word [REL clsvi]
        iov_ exfal
        sti_ w0
        or   w0,w0
        jl   exfal
        adi_ m_word [REL clsvi]
        jmp  exint
	align	2
	nop
s_cnv:
        call gtstg
        dec  m_word [_rc_]
        js   call_72
        dec  m_word [_rc_]
        jns  _l0125
        jmp  scv29
_l0125:
call_72:
        or   wa,wa
        jz   scv29
        call flstg
        mov  xl,m_word [ xs]
        cmp  m_word [ xl],b_pdt
        jne  scv01
        mov  xl,m_word [REL (cfp_b*pddfp)+xl]
        mov  xl,m_word [REL (cfp_b*dfnam)+xl]
        call ident
        dec  m_word [_rc_]
        js   call_73
        dec  m_word [_rc_]
        jns  _l0126
        jmp  exits
_l0126:
call_73:
        jmp  exfal
scv01:
        push xr
        mov  xl,svctb
        xor  wb,wb
        mov  wc,wa
scv02:
        lods_w
        mov  xr,w0
        or   xr,xr
        jz   exfal
        cmp  wc,m_word [REL (cfp_b*sclen)+xr]
        jne  scv05
        mov  m_word [REL cnvtp],xl
        add  xr,cfp_f
        mov  xl,m_word [ xs]
        add  xl,cfp_f
        mov  wa,wc
        repe cmps_b
        mov  xl,0
        mov  xr,xl
        jnz  scv04
scv03:
        mov  xl,wb
        add  xs,cfp_b
        pop  xr
        jmp  m_word [_l0127+xl*cfp_b]
        segment .data
_l0127:
        d_word scv06
        d_word scv07
        d_word scv09
        d_word scv10
        d_word scv11
        d_word scv19
        d_word scv25
        d_word scv26
        d_word scv27
        d_word scv08
        segment .text
scv04:
        mov  xl,m_word [REL cnvtp]
scv05:
        inc  wb
        jmp  scv02
scv06:
        push xr
        call gtstg
        dec  m_word [_rc_]
        js   call_74
        dec  m_word [_rc_]
        jns  _l0128
        jmp  exfal
_l0128:
call_74:
        push xr
        lcw_ xr
        jmp  m_word [ xr]
scv07:
        call gtint
        dec  m_word [_rc_]
        js   call_75
        dec  m_word [_rc_]
        jns  _l0129
        jmp  exfal
_l0129:
call_75:
        push xr
        lcw_ xr
        jmp  m_word [ xr]
scv08:
        call gtrea
        dec  m_word [_rc_]
        js   call_76
        dec  m_word [_rc_]
        jns  _l0130
        jmp  exfal
_l0130:
call_76:
        push xr
        lcw_ xr
        jmp  m_word [ xr]
scv09:
        cmp  m_word [ xr],b_nml
        je   exixr
        call gtnvr
        dec  m_word [_rc_]
        js   call_77
        dec  m_word [_rc_]
        jns  _l0131
        jmp  exfal
_l0131:
call_77:
        jmp  exvnm
scv10:
        call gtpat
        dec  m_word [_rc_]
        js   call_78
        dec  m_word [_rc_]
        jns  _l0132
        jmp  exfal
_l0132:
call_78:
        push xr
        lcw_ xr
        jmp  m_word [ xr]
scv11:
        push xr
        xor  wa,wa
        call gtarr
        dec  m_word [_rc_]
        js   call_79
        dec  m_word [_rc_]
        jns  _l0133
        jmp  exfal
_l0133:
        dec  m_word [_rc_]
        jns  _l0134
        jmp  exfal
_l0134:
call_79:
        pop  xl
        cmp  m_word [ xl],b_tbt
        jne  exsid
        push xr
        push nulls
        xor  wa,wa
        call sorta
        dec  m_word [_rc_]
        js   call_80
        dec  m_word [_rc_]
        jns  _l0135
        jmp  exfal
_l0135:
call_80:
        mov  wb,xr
        ldi_ m_word [REL (cfp_b*ardim)+xr]
        sti_ wa
        add  xr,cfp_b*arvl2
scv12:
        mov  xl,m_word [ xr]
        mov  w0,m_word [REL (cfp_b*tesub)+xl]
        stos_w
        mov  w0,m_word [REL (cfp_b*teval)+xl]
        stos_w
        dec  wa
        jnz  scv12
        mov  xr,wb
        jmp  exsid
scv19:
        mov  wa,m_word [ xr]
        push xr
        cmp  wa,b_tbt
        je   exits
        cmp  wa,b_art
        jne  exfal
        cmp  m_word [REL (cfp_b*arndm)+xr],num02
        jne  exfal
        ldi_ m_word [REL (cfp_b*ardm2)+xr]
        sbi_ m_word [REL intv2]
        sti_ w0
        or   w0,w0
        jne  exfal
        ldi_ m_word [REL (cfp_b*ardim)+xr]
        sti_ wa
        mov  wb,wa
        add  wa,tbsi_
        sal  wa,log_cfp_b
        call alloc
        mov  wc,xr
        push xr
        mov  w0,b_tbt
        stos_w
        mov  w0,0
        stos_w
        mov  w0,wa
        stos_w
        mov  w0,nulls
        stos_w
scv20:
        mov  w0,wc
        stos_w
        dec  wb
        jnz  scv20
        mov  wb,cfp_b*arvl2
scv21:
        mov  xl,m_word [REL (cfp_b*num01)+xs]
        cmp  wb,m_word [REL (cfp_b*arlen)+xl]
        je   scv24
        add  xl,wb
        add  wb,cfp_b*num02
        mov  xr,m_word [ xl]
        sub  xl,cfp_b
scv22:
        mov  xl,m_word [REL (cfp_b*trval)+xl]
        cmp  m_word [ xl],b_trt
        je   scv22
scv23:
        push xl
        mov  xl,m_word [REL (cfp_b*num01)+xs]
        call tfind
        dec  m_word [_rc_]
        js   call_81
        dec  m_word [_rc_]
        jns  _l0136
        jmp  exfal
_l0136:
call_81:
        pop  m_word [REL (cfp_b*teval)+xl]
        jmp  scv21
scv24:
        pop  xr
        add  xs,cfp_b
        jmp  exsid
scv25:
        xor  wb,wb
        call gtexp
        dec  m_word [_rc_]
        js   call_82
        dec  m_word [_rc_]
        jns  _l0137
        jmp  exfal
_l0137:
call_82:
        mov  w0,0
        mov  m_word [REL r_ccb],w0
        push xr
        lcw_ xr
        jmp  m_word [ xr]
scv26:
        call gtcod
        dec  m_word [_rc_]
        js   call_83
        dec  m_word [_rc_]
        jns  _l0138
        jmp  exfal
_l0138:
call_83:
        mov  w0,0
        mov  m_word [REL r_ccb],w0
        push xr
        lcw_ xr
        jmp  m_word [ xr]
scv27:
        call gtnum
        dec  m_word [_rc_]
        js   call_84
        dec  m_word [_rc_]
        jns  _l0139
        jmp  exfal
_l0139:
call_84:
scv31:
        push xr
        lcw_ xr
        jmp  m_word [ xr]
scv29:
        mov  m_word [_rc_],74
        jmp  err_
	align	2
	nop
s_cop:
        call copyb
        dec  m_word [_rc_]
        js   call_85
        dec  m_word [_rc_]
        jns  _l0140
        jmp  exits
_l0140:
call_85:
        jmp  exsid
	align	2
	nop
s_cos:
        pop  xr
        call gtrea
        dec  m_word [_rc_]
        js   call_86
        dec  m_word [_rc_]
        jns  _l0141
        mov  m_word [_rc_],303
        jmp  err_
_l0141:
call_86:
        lea  w0,[REL (cfp_b*rcval)+xr]
        call ldr_
        call cos_
        rno_ exrea
        mov  m_word [_rc_],322
        jmp  err_
	align	2
	nop
s_dat:
        call xscni
        dec  m_word [_rc_]
        js   call_87
        dec  m_word [_rc_]
        jns  _l0142
        mov  m_word [_rc_],75
        jmp  err_
_l0142:
        dec  m_word [_rc_]
        jns  _l0143
        mov  m_word [_rc_],76
        jmp  err_
_l0143:
call_87:
        mov  wc,ch_pp
        mov  xl,wc
        mov  wa,xs
        call xscan
        or   wa,wa
        jnz  sdat1
        mov  m_word [_rc_],77
        jmp  err_
sdat1:
        mov  wa,m_word [REL (cfp_b*sclen)+xr]
        or   wa,wa
        jz   sdt1a
        call flstg
sdt1a:
        mov  xl,xr
        mov  wa,m_word [REL (cfp_b*sclen)+xr]
        add  wa,(cfp_b-1)+cfp_b*scsi_
        and  wa,-cfp_b
        call alost
        push xr
        shr  wa,log_cfp_b
        rep  movs_w
        mov  xr,m_word [ xs]
        xor  xl,xl
        call gtnvr
        dec  m_word [_rc_]
        js   call_88
        dec  m_word [_rc_]
        jns  _l0144
        mov  m_word [_rc_],78
        jmp  err_
_l0144:
call_88:
        mov  m_word [REL datdv],xr
        mov  m_word [REL datxs],xs
        xor  wb,wb
sdat2:
        mov  wc,ch_rp
        mov  xl,ch_cm
        mov  wa,xs
        call xscan
        or   wa,wa
        jnz  sdat3
        mov  m_word [_rc_],79
        jmp  err_
sdat3:
        call gtnvr
        dec  m_word [_rc_]
        js   call_89
        dec  m_word [_rc_]
        jns  _l0145
        mov  m_word [_rc_],80
        jmp  err_
_l0145:
call_89:
        push xr
        inc  wb
        cmp  wa,num02
        je   sdat2
        mov  wa,dfsi_
        add  wa,wb
        sal  wa,log_cfp_b
        mov  wc,wb
        call alost
        mov  wb,wc
        mov  xt,m_word [REL datxs]
        mov  wc,m_word [ xt]
        mov  m_word [ xt],xr
        mov  w0,b_dfc
        stos_w
        mov  w0,wb
        stos_w
        mov  w0,wa
        stos_w
        sub  wa,cfp_b*pddfs
        mov  w0,wa
        stos_w
        mov  w0,wc
        stos_w
        mov  wc,wb
sdat4:
        lea  xt,[xt-cfp_b]
        mov  w0,m_word [xt]
        stos_w
        dec  wc
        jnz  sdat4
        mov  wc,wa
        mov  xr,m_word [REL datdv]
        mov  xt,m_word [REL datxs]
        mov  xl,m_word [ xt]
        call dffnc
sdat5:
        mov  wa,cfp_b*ffsi_
        call alloc
        mov  m_word [ xr],b_ffc
        mov  m_word [REL (cfp_b*fargs)+xr],num01
        mov  xt,m_word [REL datxs]
        mov  w0,m_word [ xt]
        mov  m_word [REL (cfp_b*ffdfp)+xr],w0
        sub  wc,cfp_b
        mov  m_word [REL (cfp_b*ffofs)+xr],wc
        mov  w0,0
        mov  m_word [REL (cfp_b*ffnxt)+xr],w0
        mov  xl,xr
        mov  xr,m_word [ xs]
        mov  xr,m_word [REL (cfp_b*vrfnc)+xr]
        cmp  m_word [ xr],b_ffc
        jne  sdat6
        mov  m_word [REL (cfp_b*ffnxt)+xl],xr
sdat6:
        pop  xr
        call dffnc
        cmp  xs,m_word [REL datxs]
        jne  sdat5
        add  xs,cfp_b
        jmp  exnul
	align	2
	nop
s_dtp:
        pop  xr
        call dtype
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
s_dte:
        pop  xr
        call gtint
        dec  m_word [_rc_]
        js   call_90
        dec  m_word [_rc_]
        jns  _l0146
        mov  m_word [_rc_],330
        jmp  err_
_l0146:
call_90:
        call sysdt
        mov  wa,m_word [REL (cfp_b*num01)+xl]
        or   wa,wa
        jz   exnul
        xor  wb,wb
        call sbstr
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
s_def:
        pop  xr
        mov  w0,0
        mov  m_word [REL deflb],w0
        cmp  xr,nulls
        je   sdf01
        call gtnvr
        dec  m_word [_rc_]
        js   call_91
        dec  m_word [_rc_]
        jns  _l0147
        jmp  sdf12
_l0147:
call_91:
        mov  m_word [REL deflb],xr
sdf01:
        call xscni
        dec  m_word [_rc_]
        js   call_92
        dec  m_word [_rc_]
        jns  _l0148
        mov  m_word [_rc_],81
        jmp  err_
_l0148:
        dec  m_word [_rc_]
        jns  _l0149
        mov  m_word [_rc_],82
        jmp  err_
_l0149:
call_92:
        mov  wc,ch_pp
        mov  xl,wc
        mov  wa,xs
        call xscan
        or   wa,wa
        jnz  sdf02
        mov  m_word [_rc_],83
        jmp  err_
sdf02:
        call gtnvr
        dec  m_word [_rc_]
        js   call_93
        dec  m_word [_rc_]
        jns  _l0150
        mov  m_word [_rc_],84
        jmp  err_
_l0150:
call_93:
        mov  m_word [REL defvr],xr
        xor  wb,wb
        mov  m_word [REL defxs],xs
        cmp  m_word [REL deflb],0
        jnz  sdf03
        mov  m_word [REL deflb],xr
sdf03:
        mov  wc,ch_rp
        mov  xl,ch_cm
        mov  wa,xs
        call xscan
        or   wa,wa
        jnz  sdf04
        mov  m_word [_rc_],85
        jmp  err_
sdf04:
        cmp  xr,nulls
        jne  sdf05
        or   wb,wb
        jz   sdf06
sdf05:
        call gtnvr
        dec  m_word [_rc_]
        js   call_94
        dec  m_word [_rc_]
        jns  _l0151
        jmp  sdf03
_l0151:
call_94:
        push xr
        inc  wb
        cmp  wa,num02
        je   sdf03
sdf06:
        mov  m_word [REL defna],wb
        xor  wb,wb
sdf07:
        mov  wc,ch_cm
        mov  xl,wc
        mov  wa,xs
        call xscan
        cmp  xr,nulls
        jne  sdf08
        or   wa,wa
        jz   sdf09
sdf08:
        call gtnvr
        dec  m_word [_rc_]
        js   call_95
        dec  m_word [_rc_]
        jns  _l0152
        jmp  sdf07
_l0152:
call_95:
        inc  wb
        push xr
        or   wa,wa
        jnz  sdf07
sdf09:
        mov  wa,wb
        add  wa,m_word [REL defna]
        mov  wc,wa
        add  wa,pfsi_
        sal  wa,log_cfp_b
        call alloc
        mov  xl,xr
        mov  w0,b_pfc
        stos_w
        mov  w0,m_word [REL defna]
        stos_w
        mov  w0,wa
        stos_w
        mov  w0,m_word [REL defvr]
        stos_w
        mov  w0,wb
        stos_w
        mov  w0,0
        stos_w
        mov  w0,0
        stos_w
        mov  w0,0
        stos_w
        or   wc,wc
        jz   sdf11
        mov  wa,xl
        mov  xt,m_word [REL defxs]
sdf10:
        lea  xt,[xt-cfp_b]
        mov  w0,m_word [xt]
        stos_w
        dec  wc
        jnz  sdf10
        mov  xl,wa
sdf11:
        mov  xs,m_word [REL defxs]
        mov  w0,m_word [REL deflb]
        mov  m_word [REL (cfp_b*pfcod)+xl],w0
        mov  xr,m_word [REL defvr]
        call dffnc
        jmp  exnul
sdf12:
        mov  m_word [_rc_],86
        jmp  err_
	align	2
	nop
s_det:
        pop  xr
        call gtvar
        dec  m_word [_rc_]
        js   call_96
        dec  m_word [_rc_]
        jns  _l0153
        mov  m_word [_rc_],87
        jmp  err_
_l0153:
call_96:
        call dtach
        jmp  exnul
	align	2
	nop
s_dif:
        pop  xr
        pop  xl
        call ident
        dec  m_word [_rc_]
        js   call_97
        dec  m_word [_rc_]
        jns  _l0154
        jmp  exfal
_l0154:
call_97:
        jmp  exnul
	align	2
	nop
s_dmp:
        call gtsmi
        dec  m_word [_rc_]
        js   call_98
        dec  m_word [_rc_]
        jns  _l0155
        mov  m_word [_rc_],88
        jmp  err_
_l0155:
        dec  m_word [_rc_]
        jns  _l0156
        mov  m_word [_rc_],89
        jmp  err_
_l0156:
call_98:
        call dumpr
        jmp  exnul
	align	2
	nop
s_dup:
        call gtsmi
        dec  m_word [_rc_]
        js   call_99
        dec  m_word [_rc_]
        jns  _l0157
        mov  m_word [_rc_],90
        jmp  err_
_l0157:
        dec  m_word [_rc_]
        jns  _l0158
        jmp  sdup7
_l0158:
call_99:
        mov  wb,xr
        call gtstg
        dec  m_word [_rc_]
        js   call_100
        dec  m_word [_rc_]
        jns  _l0159
        jmp  sdup4
_l0159:
call_100:
        ldi_ wa
        sti_ m_word [REL dupsi]
        ldi_ wb
        mli_ m_word [REL dupsi]
        iov_ sdup3
        sti_ w0
        or   w0,w0
        je   exnul
        sti_ w0
        or   w0,w0
        js   sdup3
        sti_ wa
sdup1:
        mov  xl,xr
        call alocs
        push xr
        mov  wc,xl
        add  xr,cfp_f
sdup2:
        mov  xl,wc
        mov  wa,m_word [REL (cfp_b*sclen)+xl]
        add  xl,cfp_f
        rep
        movs_b
        dec  wb
        jnz  sdup2
        xor  xl,xl
        lcw_ xr
        jmp  m_word [ xr]
sdup3:
        mov  wa,m_word [REL dname]
        jmp  sdup1
sdup4:
        call gtpat
        dec  m_word [_rc_]
        js   call_101
        dec  m_word [_rc_]
        jns  _l0161
        mov  m_word [_rc_],91
        jmp  err_
_l0161:
call_101:
        push xr
        mov  xr,ndnth
        or   wb,wb
        jz   sdup6
        push wb
sdup5:
        mov  xl,xr
        mov  xr,m_word [REL (cfp_b*num01)+xs]
        call pconc
        dec  m_word [ xs]
        cmp  m_word [ xs],0
        jnz  sdup5
        add  xs,cfp_b
sdup6:
        mov  m_word [ xs],xr
        lcw_ xr
        jmp  m_word [ xr]
sdup7:
        add  xs,cfp_b
        jmp  exfal
	align	2
	nop
s_ejc:
        call iofcb
        dec  m_word [_rc_]
        js   call_102
        dec  m_word [_rc_]
        jns  _l0162
        mov  m_word [_rc_],92
        jmp  err_
_l0162:
        dec  m_word [_rc_]
        jns  _l0163
        jmp  sejc1
_l0163:
        dec  m_word [_rc_]
        jns  _l0164
        mov  m_word [_rc_],93
        jmp  err_
_l0164:
call_102:
        call sysef
        dec  m_word [_rc_]
        js   call_103
        dec  m_word [_rc_]
        jns  _l0165
        mov  m_word [_rc_],93
        jmp  err_
_l0165:
        dec  m_word [_rc_]
        jns  _l0166
        mov  m_word [_rc_],94
        jmp  err_
_l0166:
        dec  m_word [_rc_]
        jns  _l0167
        mov  m_word [_rc_],95
        jmp  err_
_l0167:
call_103:
        jmp  exnul
sejc1:
        call sysep
        jmp  exnul
	align	2
	nop
s_enf:
        call iofcb
        dec  m_word [_rc_]
        js   call_104
        dec  m_word [_rc_]
        jns  _l0168
        mov  m_word [_rc_],96
        jmp  err_
_l0168:
        dec  m_word [_rc_]
        jns  _l0169
        mov  m_word [_rc_],97
        jmp  err_
_l0169:
        dec  m_word [_rc_]
        jns  _l0170
        mov  m_word [_rc_],98
        jmp  err_
_l0170:
call_104:
        call sysen
        dec  m_word [_rc_]
        js   call_105
        dec  m_word [_rc_]
        jns  _l0171
        mov  m_word [_rc_],98
        jmp  err_
_l0171:
        dec  m_word [_rc_]
        jns  _l0172
        mov  m_word [_rc_],99
        jmp  err_
_l0172:
        dec  m_word [_rc_]
        jns  _l0173
        mov  m_word [_rc_],100
        jmp  err_
_l0173:
call_105:
        mov  wb,xl
        mov  xr,xl
senf1:
        mov  xl,xr
        mov  xr,m_word [REL (cfp_b*trval)+xr]
        cmp  m_word [ xr],b_trt
        jne  exnul
        cmp  m_word [REL (cfp_b*trtyp)+xr],trtfc
        jne  senf1
        mov  w0,m_word [REL (cfp_b*trval)+xr]
        mov  m_word [REL (cfp_b*trval)+xl],w0
        mov  w0,m_word [REL (cfp_b*trtrf)+xr]
        mov  m_word [REL enfch],w0
        mov  wc,m_word [REL (cfp_b*trfpt)+xr]
        mov  xr,wb
        call setvr
        mov  xl,r_fcb
        sub  xl,cfp_b*num02
senf2:
        mov  xr,xl
        mov  xl,m_word [REL (cfp_b*num02)+xl]
        or   xl,xl
        jz   senf4
        cmp  m_word [REL (cfp_b*num03)+xl],wc
        je   senf3
        jmp  senf2
senf3:
        mov  w0,m_word [REL (cfp_b*num02)+xl]
        mov  m_word [REL (cfp_b*num02)+xr],w0
senf4:
        mov  xl,m_word [REL enfch]
        or   xl,xl
        jz   exnul
        mov  w0,m_word [REL (cfp_b*trtrf)+xl]
        mov  m_word [REL enfch],w0
        mov  wa,m_word [REL (cfp_b*ionmo)+xl]
        mov  xl,m_word [REL (cfp_b*ionmb)+xl]
        call dtach
        jmp  senf4
	align	2
	nop
s_eqf:
        call acomp
        dec  m_word [_rc_]
        js   call_106
        dec  m_word [_rc_]
        jns  _l0174
        mov  m_word [_rc_],101
        jmp  err_
_l0174:
        dec  m_word [_rc_]
        jns  _l0175
        mov  m_word [_rc_],102
        jmp  err_
_l0175:
        dec  m_word [_rc_]
        jns  _l0176
        jmp  exfal
_l0176:
        dec  m_word [_rc_]
        jns  _l0177
        jmp  exnul
_l0177:
        dec  m_word [_rc_]
        jns  _l0178
        jmp  exfal
_l0178:
call_106:
	align	2
	nop
s_evl:
        pop  xr
        lcw_ wc
        cmp  wc,ofne_
        jne  sevl1
        scp_ xl
        mov  wa,m_word [ xl]
        cmp  wa,ornm_
        jne  sevl2
        cmp  m_word [REL (cfp_b*num01)+xs],0
        jnz  sevl2
sevl1:
        xor  wb,wb
        push wc
        call gtexp
        dec  m_word [_rc_]
        js   call_107
        dec  m_word [_rc_]
        jns  _l0179
        mov  m_word [_rc_],103
        jmp  err_
_l0179:
call_107:
        mov  w0,0
        mov  m_word [REL r_ccb],w0
        xor  wb,wb
        call evalx
        dec  m_word [_rc_]
        js   call_108
        dec  m_word [_rc_]
        jns  _l0180
        jmp  exfal
_l0180:
call_108:
        mov  xl,xr
        mov  xr,m_word [ xs]
        mov  m_word [ xs],xl
        jmp  m_word [ xr]
sevl2:
        mov  wb,num01
        call gtexp
        dec  m_word [_rc_]
        js   call_109
        dec  m_word [_rc_]
        jns  _l0181
        mov  m_word [_rc_],103
        jmp  err_
_l0181:
call_109:
        mov  w0,0
        mov  m_word [REL r_ccb],w0
        mov  wb,num01
        call evalx
        dec  m_word [_rc_]
        js   call_110
        dec  m_word [_rc_]
        jns  _l0182
        jmp  exfal
_l0182:
call_110:
        jmp  exnam
	align	2
	nop
s_ext:
        xor  wb,wb
        mov  w0,0
        mov  m_word [REL r_ccb],w0
        mov  w0,0
        mov  m_word [REL dnams],w0
        call gbcol
        mov  m_word [REL dnams],xr
        call gtstg
        dec  m_word [_rc_]
        js   call_111
        dec  m_word [_rc_]
        jns  _l0183
        mov  m_word [_rc_],288
        jmp  err_
_l0183:
call_111:
        mov  xl,xr
        call gtstg
        dec  m_word [_rc_]
        js   call_112
        dec  m_word [_rc_]
        jns  _l0184
        mov  m_word [_rc_],104
        jmp  err_
_l0184:
call_112:
        push xl
        mov  xl,xr
        call gtint
        dec  m_word [_rc_]
        js   call_113
        dec  m_word [_rc_]
        jns  _l0185
        jmp  sext1
_l0185:
call_113:
        xor  xl,xl
        ldi_ m_word [REL (cfp_b*icval)+xr]
sext1:
        mov  wb,m_word [REL r_fcb]
        mov  xr,headv
        pop  wa
        call sysxi
        dec  m_word [_rc_]
        js   call_114
        dec  m_word [_rc_]
        jns  _l0186
        mov  m_word [_rc_],105
        jmp  err_
_l0186:
        dec  m_word [_rc_]
        jns  _l0187
        mov  m_word [_rc_],106
        jmp  err_
_l0187:
call_114:
        sti_ w0
        or   w0,w0
        je   exnul
        sti_ w0
        or   w0,w0
        jg   sext2
        ngi_
sext2:
        sti_ wc
        add  wa,wc
        cmp  wa,num05
        je   sext5
        mov  w0,0
        mov  m_word [REL gbcnt],w0
        cmp  wc,num03
        jae  sext3
        push wc
        xor  wc,wc
        call prpar
        pop  wc
sext3:
        mov  m_word [REL headp],xs
        cmp  wc,num01
        jne  sext4
        mov  w0,0
        mov  m_word [REL headp],w0
sext4:
        call systm
        sti_ m_word [REL timsx]
        ldi_ m_word [REL kvstc]
        sti_ m_word [REL kvstl]
        call stgcc
        jmp  exnul
sext5:
        mov  xr,inton
        jmp  exixr
	align	2
	nop
s_exp:
        pop  xr
        call gtrea
        dec  m_word [_rc_]
        js   call_115
        dec  m_word [_rc_]
        jns  _l0188
        mov  m_word [_rc_],304
        jmp  err_
_l0188:
call_115:
        lea  w0,[REL (cfp_b*rcval)+xr]
        call ldr_
        call etx_
        rno_ exrea
        mov  m_word [_rc_],305
        jmp  err_
	align	2
	nop
s_fld:
        call gtsmi
        dec  m_word [_rc_]
        js   call_116
        dec  m_word [_rc_]
        jns  _l0189
        mov  m_word [_rc_],107
        jmp  err_
_l0189:
        dec  m_word [_rc_]
        jns  _l0190
        jmp  exfal
_l0190:
call_116:
        mov  wb,xr
        pop  xr
        call gtnvr
        dec  m_word [_rc_]
        js   call_117
        dec  m_word [_rc_]
        jns  _l0191
        jmp  sfld1
_l0191:
call_117:
        mov  xr,m_word [REL (cfp_b*vrfnc)+xr]
        cmp  m_word [ xr],b_dfc
        jne  sfld1
        or   wb,wb
        jz   exfal
        cmp  wb,m_word [REL (cfp_b*fargs)+xr]
        ja   exfal
        sal  wb,log_cfp_b
        add  xr,wb
        mov  xr,m_word [REL (cfp_b*dfflb)+xr]
        jmp  exvnm
sfld1:
        mov  m_word [_rc_],108
        jmp  err_
	align	2
	nop
s_fnc:
        mov  wb,p_fnc
        xor  xr,xr
        call pbild
        mov  xl,xr
        pop  xr
        call gtpat
        dec  m_word [_rc_]
        js   call_118
        dec  m_word [_rc_]
        jns  _l0192
        mov  m_word [_rc_],259
        jmp  err_
_l0192:
call_118:
        call pconc
        mov  xl,xr
        mov  wb,p_fna
        xor  xr,xr
        call pbild
        mov  m_word [REL (cfp_b*pthen)+xr],xl
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
s_gef:
        call acomp
        dec  m_word [_rc_]
        js   call_119
        dec  m_word [_rc_]
        jns  _l0193
        mov  m_word [_rc_],109
        jmp  err_
_l0193:
        dec  m_word [_rc_]
        jns  _l0194
        mov  m_word [_rc_],110
        jmp  err_
_l0194:
        dec  m_word [_rc_]
        jns  _l0195
        jmp  exfal
_l0195:
        dec  m_word [_rc_]
        jns  _l0196
        jmp  exnul
_l0196:
        dec  m_word [_rc_]
        jns  _l0197
        jmp  exnul
_l0197:
call_119:
	align	2
	nop
s_gtf:
        call acomp
        dec  m_word [_rc_]
        js   call_120
        dec  m_word [_rc_]
        jns  _l0198
        mov  m_word [_rc_],111
        jmp  err_
_l0198:
        dec  m_word [_rc_]
        jns  _l0199
        mov  m_word [_rc_],112
        jmp  err_
_l0199:
        dec  m_word [_rc_]
        jns  _l0200
        jmp  exfal
_l0200:
        dec  m_word [_rc_]
        jns  _l0201
        jmp  exfal
_l0201:
        dec  m_word [_rc_]
        jns  _l0202
        jmp  exnul
_l0202:
call_120:
	align	2
	nop
s_hst:
        pop  wc
        pop  wb
        pop  xr
        pop  xl
        pop  wa
        call syshs
        dec  m_word [_rc_]
        js   call_121
        dec  m_word [_rc_]
        jns  _l0203
        mov  m_word [_rc_],254
        jmp  err_
_l0203:
        dec  m_word [_rc_]
        jns  _l0204
        mov  m_word [_rc_],255
        jmp  err_
_l0204:
        dec  m_word [_rc_]
        jns  _l0205
        jmp  shst1
_l0205:
        dec  m_word [_rc_]
        jns  _l0206
        jmp  exnul
_l0206:
        dec  m_word [_rc_]
        jns  _l0207
        jmp  exixr
_l0207:
        dec  m_word [_rc_]
        jns  _l0208
        jmp  exfal
_l0208:
        dec  m_word [_rc_]
        jns  _l0209
        jmp  shst3
_l0209:
        dec  m_word [_rc_]
        jns  _l0210
        jmp  shst4
_l0210:
call_121:
shst1:
        or   xl,xl
        jz   exnul
        mov  wa,m_word [REL (cfp_b*sclen)+xl]
        xor  wb,wb
shst2:
        call sbstr
        push xr
        lcw_ xr
        jmp  m_word [ xr]
shst3:
        xor  wb,wb
        sub  wb,cfp_f
        jmp  shst2
shst4:
        push xr
        call copyb
        dec  m_word [_rc_]
        js   call_122
        dec  m_word [_rc_]
        jns  _l0211
        jmp  exits
_l0211:
call_122:
        jmp  exsid
	align	2
	nop
s_idn:
        pop  xr
        pop  xl
        call ident
        dec  m_word [_rc_]
        js   call_123
        dec  m_word [_rc_]
        jns  _l0212
        jmp  exnul
_l0212:
call_123:
        jmp  exfal
	align	2
	nop
s_inp:
        xor  wb,wb
        call ioput
        dec  m_word [_rc_]
        js   call_124
        dec  m_word [_rc_]
        jns  _l0213
        mov  m_word [_rc_],113
        jmp  err_
_l0213:
        dec  m_word [_rc_]
        jns  _l0214
        mov  m_word [_rc_],114
        jmp  err_
_l0214:
        dec  m_word [_rc_]
        jns  _l0215
        mov  m_word [_rc_],115
        jmp  err_
_l0215:
        dec  m_word [_rc_]
        jns  _l0216
        mov  m_word [_rc_],116
        jmp  err_
_l0216:
        dec  m_word [_rc_]
        jns  _l0217
        jmp  exfal
_l0217:
        dec  m_word [_rc_]
        jns  _l0218
        mov  m_word [_rc_],117
        jmp  err_
_l0218:
        dec  m_word [_rc_]
        jns  _l0219
        mov  m_word [_rc_],289
        jmp  err_
_l0219:
call_124:
        jmp  exnul
	align	2
	nop
s_int:
        pop  xr
        call gtnum
        dec  m_word [_rc_]
        js   call_125
        dec  m_word [_rc_]
        jns  _l0220
        jmp  exfal
_l0220:
call_125:
        cmp  wa,b_icl
        je   exnul
        jmp  exfal
	align	2
	nop
s_itm:
        or   wa,wa
        jnz  sitm1
        push nulls
        mov  wa,num01
sitm1:
        scp_ xr
        mov  xl,m_word [ xr]
        dec  wa
        mov  xr,wa
        cmp  xl,ofne_
        je   sitm2
        xor  wb,wb
        jmp  arref
sitm2:
        mov  wb,xs
        lcw_ wa
        jmp  arref
	align	2
	nop
s_lef:
        call acomp
        dec  m_word [_rc_]
        js   call_126
        dec  m_word [_rc_]
        jns  _l0221
        mov  m_word [_rc_],118
        jmp  err_
_l0221:
        dec  m_word [_rc_]
        jns  _l0222
        mov  m_word [_rc_],119
        jmp  err_
_l0222:
        dec  m_word [_rc_]
        jns  _l0223
        jmp  exnul
_l0223:
        dec  m_word [_rc_]
        jns  _l0224
        jmp  exnul
_l0224:
        dec  m_word [_rc_]
        jns  _l0225
        jmp  exfal
_l0225:
call_126:
	align	2
	nop
s_len:
        mov  wb,p_len
        mov  wa,p_lnd
        call patin
        dec  m_word [_rc_]
        js   call_127
        dec  m_word [_rc_]
        jns  _l0226
        mov  m_word [_rc_],120
        jmp  err_
_l0226:
        dec  m_word [_rc_]
        jns  _l0227
        mov  m_word [_rc_],121
        jmp  err_
_l0227:
call_127:
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
s_leq:
        call lcomp
        dec  m_word [_rc_]
        js   call_128
        dec  m_word [_rc_]
        jns  _l0228
        mov  m_word [_rc_],122
        jmp  err_
_l0228:
        dec  m_word [_rc_]
        jns  _l0229
        mov  m_word [_rc_],123
        jmp  err_
_l0229:
        dec  m_word [_rc_]
        jns  _l0230
        jmp  exfal
_l0230:
        dec  m_word [_rc_]
        jns  _l0231
        jmp  exnul
_l0231:
        dec  m_word [_rc_]
        jns  _l0232
        jmp  exfal
_l0232:
call_128:
	align	2
	nop
s_lge:
        call lcomp
        dec  m_word [_rc_]
        js   call_129
        dec  m_word [_rc_]
        jns  _l0233
        mov  m_word [_rc_],124
        jmp  err_
_l0233:
        dec  m_word [_rc_]
        jns  _l0234
        mov  m_word [_rc_],125
        jmp  err_
_l0234:
        dec  m_word [_rc_]
        jns  _l0235
        jmp  exfal
_l0235:
        dec  m_word [_rc_]
        jns  _l0236
        jmp  exnul
_l0236:
        dec  m_word [_rc_]
        jns  _l0237
        jmp  exnul
_l0237:
call_129:
	align	2
	nop
s_lgt:
        call lcomp
        dec  m_word [_rc_]
        js   call_130
        dec  m_word [_rc_]
        jns  _l0238
        mov  m_word [_rc_],126
        jmp  err_
_l0238:
        dec  m_word [_rc_]
        jns  _l0239
        mov  m_word [_rc_],127
        jmp  err_
_l0239:
        dec  m_word [_rc_]
        jns  _l0240
        jmp  exfal
_l0240:
        dec  m_word [_rc_]
        jns  _l0241
        jmp  exfal
_l0241:
        dec  m_word [_rc_]
        jns  _l0242
        jmp  exnul
_l0242:
call_130:
	align	2
	nop
s_lle:
        call lcomp
        dec  m_word [_rc_]
        js   call_131
        dec  m_word [_rc_]
        jns  _l0243
        mov  m_word [_rc_],128
        jmp  err_
_l0243:
        dec  m_word [_rc_]
        jns  _l0244
        mov  m_word [_rc_],129
        jmp  err_
_l0244:
        dec  m_word [_rc_]
        jns  _l0245
        jmp  exnul
_l0245:
        dec  m_word [_rc_]
        jns  _l0246
        jmp  exnul
_l0246:
        dec  m_word [_rc_]
        jns  _l0247
        jmp  exfal
_l0247:
call_131:
	align	2
	nop
s_llt:
        call lcomp
        dec  m_word [_rc_]
        js   call_132
        dec  m_word [_rc_]
        jns  _l0248
        mov  m_word [_rc_],130
        jmp  err_
_l0248:
        dec  m_word [_rc_]
        jns  _l0249
        mov  m_word [_rc_],131
        jmp  err_
_l0249:
        dec  m_word [_rc_]
        jns  _l0250
        jmp  exnul
_l0250:
        dec  m_word [_rc_]
        jns  _l0251
        jmp  exfal
_l0251:
        dec  m_word [_rc_]
        jns  _l0252
        jmp  exfal
_l0252:
call_132:
	align	2
	nop
s_lne:
        call lcomp
        dec  m_word [_rc_]
        js   call_133
        dec  m_word [_rc_]
        jns  _l0253
        mov  m_word [_rc_],132
        jmp  err_
_l0253:
        dec  m_word [_rc_]
        jns  _l0254
        mov  m_word [_rc_],133
        jmp  err_
_l0254:
        dec  m_word [_rc_]
        jns  _l0255
        jmp  exnul
_l0255:
        dec  m_word [_rc_]
        jns  _l0256
        jmp  exfal
_l0256:
        dec  m_word [_rc_]
        jns  _l0257
        jmp  exnul
_l0257:
call_133:
	align	2
	nop
s_lnf:
        pop  xr
        call gtrea
        dec  m_word [_rc_]
        js   call_134
        dec  m_word [_rc_]
        jns  _l0258
        mov  m_word [_rc_],306
        jmp  err_
_l0258:
call_134:
        lea  w0,[REL (cfp_b*rcval)+xr]
        call ldr_
        call cpr_
        mov  al,byte [reg_fl]
        or   al,al
        je   slnf1
        call cpr_
        mov  al,byte [reg_fl]
        or   al,al
        jl   slnf2
        call lnf_
        rno_ exrea
slnf1:
        mov  m_word [_rc_],307
        jmp  err_
slnf2:
        mov  m_word [_rc_],315
        jmp  err_
	align	2
	nop
s_loc:
        call gtsmi
        dec  m_word [_rc_]
        js   call_135
        dec  m_word [_rc_]
        jns  _l0259
        mov  m_word [_rc_],134
        jmp  err_
_l0259:
        dec  m_word [_rc_]
        jns  _l0260
        jmp  exfal
_l0260:
call_135:
        mov  wb,xr
        pop  xr
        call gtnvr
        dec  m_word [_rc_]
        js   call_136
        dec  m_word [_rc_]
        jns  _l0261
        jmp  sloc1
_l0261:
call_136:
        mov  xr,m_word [REL (cfp_b*vrfnc)+xr]
        cmp  m_word [ xr],b_pfc
        jne  sloc1
        or   wb,wb
        jz   exfal
        cmp  wb,m_word [REL (cfp_b*pfnlo)+xr]
        ja   exfal
        add  wb,m_word [REL (cfp_b*fargs)+xr]
        sal  wb,log_cfp_b
        add  xr,wb
        mov  xr,m_word [REL (cfp_b*pfagb)+xr]
        jmp  exvnm
sloc1:
        mov  m_word [_rc_],135
        jmp  err_
	align	2
	nop
s_lod:
        call gtstg
        dec  m_word [_rc_]
        js   call_137
        dec  m_word [_rc_]
        jns  _l0262
        mov  m_word [_rc_],136
        jmp  err_
_l0262:
call_137:
        mov  xl,xr
        call xscni
        dec  m_word [_rc_]
        js   call_138
        dec  m_word [_rc_]
        jns  _l0263
        mov  m_word [_rc_],137
        jmp  err_
_l0263:
        dec  m_word [_rc_]
        jns  _l0264
        mov  m_word [_rc_],138
        jmp  err_
_l0264:
call_138:
        push xl
        mov  wc,ch_pp
        mov  xl,wc
        mov  wa,xs
        call xscan
        push xr
        or   wa,wa
        jnz  slod1
        mov  m_word [_rc_],139
        jmp  err_
slod1:
        call gtnvr
        dec  m_word [_rc_]
        js   call_139
        dec  m_word [_rc_]
        jns  _l0265
        mov  m_word [_rc_],140
        jmp  err_
_l0265:
call_139:
        mov  m_word [REL lodfn],xr
        mov  w0,0
        mov  m_word [REL lodna],w0
slod2:
        mov  wc,ch_rp
        mov  xl,ch_cm
        mov  wa,xs
        call xscan
        inc  m_word [REL lodna]
        or   wa,wa
        jnz  slod3
        mov  m_word [_rc_],141
        jmp  err_
slod3:
        mov  wb,wa
        mov  wa,m_word [REL (cfp_b*sclen)+xr]
        or   wa,wa
        jz   sld3a
        call flstg
sld3a:
        mov  wa,wb
        push xr
        mov  wb,num01
        mov  xl,scstr
        call ident
        dec  m_word [_rc_]
        js   call_140
        dec  m_word [_rc_]
        jns  _l0266
        jmp  slod4
_l0266:
call_140:
        mov  xr,m_word [ xs]
        add  wb,wb
        mov  xl,scint
        call ident
        dec  m_word [_rc_]
        js   call_141
        dec  m_word [_rc_]
        jns  _l0267
        jmp  slod4
_l0267:
call_141:
        mov  xr,m_word [ xs]
        inc  wb
        mov  xl,screa
        call ident
        dec  m_word [_rc_]
        js   call_142
        dec  m_word [_rc_]
        jns  _l0268
        jmp  slod4
_l0268:
call_142:
        mov  xr,m_word [ xs]
        inc  wb
        mov  xl,scfil
        call ident
        dec  m_word [_rc_]
        js   call_143
        dec  m_word [_rc_]
        jns  _l0269
        jmp  slod4
_l0269:
call_143:
        xor  wb,wb
slod4:
        mov  m_word [ xs],wb
        cmp  wa,num02
        je   slod2
        or   wa,wa
        jz   slod5
        mov  wc,m_word [REL mxlen]
        mov  xl,wc
        mov  wa,xs
        call xscan
        xor  wa,wa
        jmp  slod3
slod5:
        mov  wa,m_word [REL lodna]
        mov  wc,wa
        sal  wa,log_cfp_b
        add  wa,cfp_b*efsi_
        call alloc
        mov  m_word [ xr],b_efc
        mov  m_word [REL (cfp_b*fargs)+xr],wc
        mov  w0,0
        mov  m_word [REL (cfp_b*efuse)+xr],w0
        mov  w0,0
        mov  m_word [REL (cfp_b*efcod)+xr],w0
        pop  m_word [REL (cfp_b*efrsl)+xr]
        mov  w0,m_word [REL lodfn]
        mov  m_word [REL (cfp_b*efvar)+xr],w0
        mov  m_word [REL (cfp_b*eflen)+xr],wa
        mov  wb,xr
        add  xr,wa
slod6:
        lea  xr,[xr-cfp_b]
        pop  m_word [xr]
        dec  wc
        jnz  slod6
        pop  xr
        mov  wa,m_word [REL (cfp_b*sclen)+xr]
        call flstg
        mov  xl,m_word [ xs]
        mov  m_word [ xs],wb
        call sysld
        dec  m_word [_rc_]
        js   call_144
        dec  m_word [_rc_]
        jns  _l0270
        mov  m_word [_rc_],142
        jmp  err_
_l0270:
        dec  m_word [_rc_]
        jns  _l0271
        mov  m_word [_rc_],143
        jmp  err_
_l0271:
        dec  m_word [_rc_]
        jns  _l0272
        mov  m_word [_rc_],328
        jmp  err_
_l0272:
call_144:
        pop  xl
        mov  m_word [REL (cfp_b*efcod)+xl],xr
        mov  xr,m_word [REL lodfn]
        call dffnc
        jmp  exnul
	align	2
	nop
s_lpd:
        call gtstg
        dec  m_word [_rc_]
        js   call_145
        dec  m_word [_rc_]
        jns  _l0273
        mov  m_word [_rc_],144
        jmp  err_
_l0273:
call_145:
        add  xr,cfp_f
        mov  w0,0
        mov  al,m_char [xr]
        mov  wb,w0
        call gtsmi
        dec  m_word [_rc_]
        js   call_146
        dec  m_word [_rc_]
        jns  _l0274
        mov  m_word [_rc_],145
        jmp  err_
_l0274:
        dec  m_word [_rc_]
        jns  _l0275
        jmp  slpd4
_l0275:
call_146:
slpd1:
        call gtstg
        dec  m_word [_rc_]
        js   call_147
        dec  m_word [_rc_]
        jns  _l0276
        mov  m_word [_rc_],146
        jmp  err_
_l0276:
call_147:
        cmp  wa,wc
        jae  exixr
        mov  xl,xr
        mov  wa,wc
        call alocs
        push xr
        mov  wa,m_word [REL (cfp_b*sclen)+xl]
        sub  wc,wa
        add  xr,cfp_f
slpd2:
        mov  al,wb_l
        stos_b
        dec  wc
        jnz  slpd2
        or   wa,wa
        jz   slpd3
        add  xl,cfp_f
        rep
        movs_b
        xor  xl,xl
slpd3:
        lcw_ xr
        jmp  m_word [ xr]
slpd4:
        xor  wc,wc
        jmp  slpd1
	align	2
	nop
s_ltf:
        call acomp
        dec  m_word [_rc_]
        js   call_148
        dec  m_word [_rc_]
        jns  _l0278
        mov  m_word [_rc_],147
        jmp  err_
_l0278:
        dec  m_word [_rc_]
        jns  _l0279
        mov  m_word [_rc_],148
        jmp  err_
_l0279:
        dec  m_word [_rc_]
        jns  _l0280
        jmp  exnul
_l0280:
        dec  m_word [_rc_]
        jns  _l0281
        jmp  exfal
_l0281:
        dec  m_word [_rc_]
        jns  _l0282
        jmp  exfal
_l0282:
call_148:
	align	2
	nop
s_nef:
        call acomp
        dec  m_word [_rc_]
        js   call_149
        dec  m_word [_rc_]
        jns  _l0283
        mov  m_word [_rc_],149
        jmp  err_
_l0283:
        dec  m_word [_rc_]
        jns  _l0284
        mov  m_word [_rc_],150
        jmp  err_
_l0284:
        dec  m_word [_rc_]
        jns  _l0285
        jmp  exnul
_l0285:
        dec  m_word [_rc_]
        jns  _l0286
        jmp  exfal
_l0286:
        dec  m_word [_rc_]
        jns  _l0287
        jmp  exnul
_l0287:
call_149:
	align	2
	nop
s_nay:
        mov  wb,p_nas
        mov  xl,p_nay
        mov  wc,p_nad
        call patst
        dec  m_word [_rc_]
        js   call_150
        dec  m_word [_rc_]
        jns  _l0288
        mov  m_word [_rc_],151
        jmp  err_
_l0288:
call_150:
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
s_ops:
        call gtsmi
        dec  m_word [_rc_]
        js   call_151
        dec  m_word [_rc_]
        jns  _l0289
        mov  m_word [_rc_],152
        jmp  err_
_l0289:
        dec  m_word [_rc_]
        jns  _l0290
        mov  m_word [_rc_],153
        jmp  err_
_l0290:
call_151:
        mov  wb,wc
        pop  xr
        call gtnvr
        dec  m_word [_rc_]
        js   call_152
        dec  m_word [_rc_]
        jns  _l0291
        mov  m_word [_rc_],154
        jmp  err_
_l0291:
call_152:
        mov  xl,m_word [REL (cfp_b*vrfnc)+xr]
        or   wb,wb
        jnz  sops2
        pop  xr
        call gtnvr
        dec  m_word [_rc_]
        js   call_153
        dec  m_word [_rc_]
        jns  _l0292
        mov  m_word [_rc_],155
        jmp  err_
_l0292:
call_153:
sops1:
        call dffnc
        jmp  exnul
sops2:
        call gtstg
        dec  m_word [_rc_]
        js   call_154
        dec  m_word [_rc_]
        jns  _l0293
        jmp  sops5
_l0293:
call_154:
        cmp  wa,num01
        jne  sops5
        add  xr,cfp_f
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        mov  wa,r_uub
        mov  xr,opnsu
        add  wb,opbun
        cmp  wb,opuun
        je   sops3
        mov  wa,r_uba
        mov  xr,opsnb
        mov  wb,opbun
sops3:
sops4:
        cmp  wc,m_word [ xr]
        je   sops6
        add  wa,cfp_b
        add  xr,cfp_b
        dec  wb
        jnz  sops4
sops5:
        mov  m_word [_rc_],156
        jmp  err_
sops6:
        mov  xr,wa
        sub  xr,cfp_b*vrfnc
        jmp  sops1
	align	2
	nop
s_oup:
        mov  wb,num03
        call ioput
        dec  m_word [_rc_]
        js   call_155
        dec  m_word [_rc_]
        jns  _l0294
        mov  m_word [_rc_],157
        jmp  err_
_l0294:
        dec  m_word [_rc_]
        jns  _l0295
        mov  m_word [_rc_],158
        jmp  err_
_l0295:
        dec  m_word [_rc_]
        jns  _l0296
        mov  m_word [_rc_],159
        jmp  err_
_l0296:
        dec  m_word [_rc_]
        jns  _l0297
        mov  m_word [_rc_],160
        jmp  err_
_l0297:
        dec  m_word [_rc_]
        jns  _l0298
        jmp  exfal
_l0298:
        dec  m_word [_rc_]
        jns  _l0299
        mov  m_word [_rc_],161
        jmp  err_
_l0299:
        dec  m_word [_rc_]
        jns  _l0300
        mov  m_word [_rc_],290
        jmp  err_
_l0300:
call_155:
        jmp  exnul
	align	2
	nop
s_pos:
        mov  wb,p_pos
        mov  wa,p_psd
        call patin
        dec  m_word [_rc_]
        js   call_156
        dec  m_word [_rc_]
        jns  _l0301
        mov  m_word [_rc_],162
        jmp  err_
_l0301:
        dec  m_word [_rc_]
        jns  _l0302
        mov  m_word [_rc_],163
        jmp  err_
_l0302:
call_156:
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
s_pro:
        pop  xr
        mov  wb,m_word [REL (cfp_b*tblen)+xr]
        shr  wb,log_cfp_b
        mov  wa,m_word [ xr]
        cmp  wa,b_art
        je   spro4
        cmp  wa,b_tbt
        je   spro1
        cmp  wa,b_vct
        je   spro3
        mov  m_word [_rc_],164
        jmp  err_
spro1:
        sub  wb,tbsi_
spro2:
        ldi_ wb
        jmp  exint
spro3:
        sub  wb,vcsi_
        jmp  spro2
spro4:
        add  xr,m_word [REL (cfp_b*arofs)+xr]
        mov  xr,m_word [ xr]
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
s_rmd:
        call arith
        dec  m_word [_rc_]
        js   call_157
        dec  m_word [_rc_]
        jns  _l0303
        mov  m_word [_rc_],166
        jmp  err_
_l0303:
        dec  m_word [_rc_]
        jns  _l0304
        mov  m_word [_rc_],165
        jmp  err_
_l0304:
        dec  m_word [_rc_]
        jns  _l0305
        jmp  srm06
_l0305:
call_157:
        xor  wb,wb
        ldi_ m_word [REL (cfp_b*icval)+xr]
        sti_ w0
        or   w0,w0
        jge  srm01
        mov  wb,xs
srm01:
        rmi_ m_word [REL (cfp_b*icval)+xl]
        iov_ srm05
        or   wb,wb
        jz   srm03
        sti_ w0
        or   w0,w0
        jle  exint
srm02:
        ngi_
        jmp  exint
srm03:
        sti_ w0
        or   w0,w0
        jl   srm02
        jmp  exint
srm04:
        mov  m_word [_rc_],166
        jmp  err_
srm05:
        mov  m_word [_rc_],167
        jmp  err_
srm06:
        xor  wb,wb
        lea  w0,[REL (cfp_b*rcval)+xr]
        call ldr_
        call cpr_
        mov  al,byte [reg_fl]
        or   al,al
        jge  srm07
        mov  wb,xs
srm07:
        lea  w0,[REL (cfp_b*rcval)+xl]
        call dvr_
        rov_ srm10
        call chp_
        lea  w0,[REL (cfp_b*rcval)+xl]
        call mlr_
        lea  w0,[REL (cfp_b*rcval)+xr]
        call sbr_
        or   wb,wb
        jz   srm09
        call cpr_
        mov  al,byte [reg_fl]
        or   al,al
        jle  exrea
srm08:
        call ngr_
        jmp  exrea
srm09:
        call cpr_
        mov  al,byte [reg_fl]
        or   al,al
        jl   srm08
        jmp  exrea
srm10:
        mov  m_word [_rc_],312
        jmp  err_
	align	2
	nop
s_rpl:
        call gtstg
        dec  m_word [_rc_]
        js   call_158
        dec  m_word [_rc_]
        jns  _l0306
        mov  m_word [_rc_],168
        jmp  err_
_l0306:
call_158:
        mov  xl,xr
        call gtstg
        dec  m_word [_rc_]
        js   call_159
        dec  m_word [_rc_]
        jns  _l0307
        mov  m_word [_rc_],169
        jmp  err_
_l0307:
call_159:
        cmp  xr,m_word [REL r_ra2]
        jne  srpl1
        cmp  xl,m_word [REL r_ra3]
        je   srpl4
srpl1:
        mov  wb,m_word [REL (cfp_b*sclen)+xl]
        cmp  wa,wb
        jne  srpl6
        cmp  xr,m_word [REL kvalp]
        je   srpl5
        or   wb,wb
        jz   srpl6
        mov  m_word [REL r_ra3],xl
        mov  m_word [REL r_ra2],xr
        mov  xl,m_word [REL kvalp]
        mov  wa,m_word [REL (cfp_b*sclen)+xl]
        mov  xr,m_word [REL r_rpt]
        or   xr,xr
        jnz  srpl2
        call alocs
        mov  wa,wc
        mov  m_word [REL r_rpt],xr
srpl2:
        add  wa,(cfp_b-1)+cfp_b*scsi_
        and  wa,-cfp_b
        shr  wa,log_cfp_b
        rep  movs_w
        mov  xl,m_word [REL r_ra2]
        xor  wc,wc
        mov  xr,m_word [REL r_ra3]
        add  xr,cfp_f
srpl3:
        mov  xl,m_word [REL r_ra2]
        lea  xl,[cfp_f+xl+wc]
        inc  wc
        mov  w0,0
        mov  al,m_char [xl]
        mov  wa,w0
        mov  xl,m_word [REL r_rpt]
        lea  xl,[cfp_f+xl+wa]
        mov  w0,0
        mov  al,m_char [xr]
        mov  wa,w0
        inc  xr
        mov  m_char [xl],wa_l
        dec  wb
        jnz  srpl3
srpl4:
        mov  xl,m_word [REL r_rpt]
srpl5:
        call gtstg
        dec  m_word [_rc_]
        js   call_160
        dec  m_word [_rc_]
        jns  _l0308
        mov  m_word [_rc_],170
        jmp  err_
_l0308:
call_160:
        or   wa,wa
        jz   exnul
        push xl
        mov  xl,xr
        mov  wc,wa
        add  wa,(cfp_b-1)+cfp_b*schar
        and  wa,-cfp_b
        call alloc
        mov  wb,xr
        shr  wa,log_cfp_b
        rep  movs_w
        pop  xr
        add  xr,cfp_f
        mov  xl,wb
        add  xl,cfp_f
        mov  wa,wc
        xchg xl,xr
_l0309: movzx w0,m_char [xr]
        mov  al,[xl+w0]
        stosb
        dec  wa
        jnz  _l0309
        xor  xl,xl
        xor  xr,xr
srpl8:
        push wb
        lcw_ xr
        jmp  m_word [ xr]
srpl6:
        mov  m_word [_rc_],171
        jmp  err_
	align	2
	nop
s_rew:
        call iofcb
        dec  m_word [_rc_]
        js   call_161
        dec  m_word [_rc_]
        jns  _l0310
        mov  m_word [_rc_],172
        jmp  err_
_l0310:
        dec  m_word [_rc_]
        jns  _l0311
        mov  m_word [_rc_],173
        jmp  err_
_l0311:
        dec  m_word [_rc_]
        jns  _l0312
        mov  m_word [_rc_],174
        jmp  err_
_l0312:
call_161:
        call sysrw
        dec  m_word [_rc_]
        js   call_162
        dec  m_word [_rc_]
        jns  _l0313
        mov  m_word [_rc_],174
        jmp  err_
_l0313:
        dec  m_word [_rc_]
        jns  _l0314
        mov  m_word [_rc_],175
        jmp  err_
_l0314:
        dec  m_word [_rc_]
        jns  _l0315
        mov  m_word [_rc_],176
        jmp  err_
_l0315:
call_162:
        jmp  exnul
	align	2
	nop
s_rvs:
        call gtstg
        dec  m_word [_rc_]
        js   call_163
        dec  m_word [_rc_]
        jns  _l0316
        mov  m_word [_rc_],177
        jmp  err_
_l0316:
call_163:
        or   wa,wa
        jz   exixr
        mov  xl,xr
        call alocs
        push xr
        add  xr,cfp_f
        lea  xl,[cfp_f+xl+wc]
srvs1:
        dec  xl
        mov  w0,0
        mov  al,m_char [xl]
        mov  wb,w0
        mov  al,wb_l
        stos_b
        dec  wc
        jnz  srvs1
srvs4:
        xor  xl,xl
srvs2:
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
s_rpd:
        call gtstg
        dec  m_word [_rc_]
        js   call_164
        dec  m_word [_rc_]
        jns  _l0317
        mov  m_word [_rc_],178
        jmp  err_
_l0317:
call_164:
        add  xr,cfp_f
        mov  w0,0
        mov  al,m_char [xr]
        mov  wb,w0
        call gtsmi
        dec  m_word [_rc_]
        js   call_165
        dec  m_word [_rc_]
        jns  _l0318
        mov  m_word [_rc_],179
        jmp  err_
_l0318:
        dec  m_word [_rc_]
        jns  _l0319
        jmp  srpd3
_l0319:
call_165:
srpd1:
        call gtstg
        dec  m_word [_rc_]
        js   call_166
        dec  m_word [_rc_]
        jns  _l0320
        mov  m_word [_rc_],180
        jmp  err_
_l0320:
call_166:
        cmp  wa,wc
        jae  exixr
        mov  xl,xr
        mov  wa,wc
        call alocs
        push xr
        mov  wa,m_word [REL (cfp_b*sclen)+xl]
        sub  wc,wa
        add  xr,cfp_f
        or   wa,wa
        jz   srpd2
        add  xl,cfp_f
        rep
        movs_b
        xor  xl,xl
srpd2:
        mov  al,wb_l
        stos_b
        dec  wc
        jnz  srpd2
        lcw_ xr
        jmp  m_word [ xr]
srpd3:
        xor  wc,wc
        jmp  srpd1
	align	2
	nop
s_rtb:
        mov  wb,p_rtb
        mov  wa,p_rtd
        call patin
        dec  m_word [_rc_]
        js   call_167
        dec  m_word [_rc_]
        jns  _l0322
        mov  m_word [_rc_],181
        jmp  err_
_l0322:
        dec  m_word [_rc_]
        jns  _l0323
        mov  m_word [_rc_],182
        jmp  err_
_l0323:
call_167:
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
s_set:
        pop  m_word [REL r_io2]
        pop  m_word [REL r_io1]
        call iofcb
        dec  m_word [_rc_]
        js   call_168
        dec  m_word [_rc_]
        jns  _l0324
        mov  m_word [_rc_],291
        jmp  err_
_l0324:
        dec  m_word [_rc_]
        jns  _l0325
        mov  m_word [_rc_],292
        jmp  err_
_l0325:
        dec  m_word [_rc_]
        jns  _l0326
        mov  m_word [_rc_],295
        jmp  err_
_l0326:
call_168:
        mov  wb,m_word [REL r_io1]
        mov  wc,m_word [REL r_io2]
        call sysst
        dec  m_word [_rc_]
        jns  _l0327
        mov  m_word [_rc_],293
        jmp  err_
_l0327:
        dec  m_word [_rc_]
        jns  _l0328
        mov  m_word [_rc_],294
        jmp  err_
_l0328:
        dec  m_word [_rc_]
        jns  _l0329
        mov  m_word [_rc_],295
        jmp  err_
_l0329:
        dec  m_word [_rc_]
        jns  _l0330
        mov  m_word [_rc_],296
        jmp  err_
_l0330:
        dec  m_word [_rc_]
        jns  _l0331
        mov  m_word [_rc_],297
        jmp  err_
_l0331:
        jmp  exint
	align	2
	nop
s_tab:
        mov  wb,p_tab
        mov  wa,p_tbd
        call patin
        dec  m_word [_rc_]
        js   call_169
        dec  m_word [_rc_]
        jns  _l0332
        mov  m_word [_rc_],183
        jmp  err_
_l0332:
        dec  m_word [_rc_]
        jns  _l0333
        mov  m_word [_rc_],184
        jmp  err_
_l0333:
call_169:
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
s_rps:
        mov  wb,p_rps
        mov  wa,p_rpd
        call patin
        dec  m_word [_rc_]
        js   call_170
        dec  m_word [_rc_]
        jns  _l0334
        mov  m_word [_rc_],185
        jmp  err_
_l0334:
        dec  m_word [_rc_]
        jns  _l0335
        mov  m_word [_rc_],186
        jmp  err_
_l0335:
call_170:
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
s_rsr:
        mov  wa,xs
        call sorta
        dec  m_word [_rc_]
        js   call_171
        dec  m_word [_rc_]
        jns  _l0336
        jmp  exfal
_l0336:
call_171:
        jmp  exsid
	align	2
	nop
s_stx:
        pop  xr
        mov  wa,m_word [REL stxvr]
        xor  xl,xl
        cmp  xr,nulls
        je   sstx1
        call gtnvr
        dec  m_word [_rc_]
        js   call_172
        dec  m_word [_rc_]
        jns  _l0337
        jmp  sstx2
_l0337:
call_172:
        mov  xl,m_word [REL (cfp_b*vrlbl)+xr]
        cmp  xl,stndl
        je   sstx2
        cmp  m_word [ xl],b_trt
        jne  sstx1
        mov  xl,m_word [REL (cfp_b*trlbl)+xl]
sstx1:
        mov  m_word [REL stxvr],xr
        mov  m_word [REL r_sxc],xl
        cmp  wa,nulls
        je   exnul
        mov  xr,wa
        jmp  exvnm
sstx2:
        mov  m_word [_rc_],187
        jmp  err_
	align	2
	nop
s_sin:
        pop  xr
        call gtrea
        dec  m_word [_rc_]
        js   call_173
        dec  m_word [_rc_]
        jns  _l0338
        mov  m_word [_rc_],308
        jmp  err_
_l0338:
call_173:
        lea  w0,[REL (cfp_b*rcval)+xr]
        call ldr_
        call sin_
        rno_ exrea
        mov  m_word [_rc_],323
        jmp  err_
	align	2
	nop
s_sqr:
        pop  xr
        call gtrea
        dec  m_word [_rc_]
        js   call_174
        dec  m_word [_rc_]
        jns  _l0339
        mov  m_word [_rc_],313
        jmp  err_
_l0339:
call_174:
        lea  w0,[REL (cfp_b*rcval)+xr]
        call ldr_
        call cpr_
        mov  al,byte [reg_fl]
        or   al,al
        jl   ssqr1
        call sqr_
        jmp  exrea
ssqr1:
        mov  m_word [_rc_],314
        jmp  err_
	align	2
	nop
s_srt:
        xor  wa,wa
        call sorta
        dec  m_word [_rc_]
        js   call_175
        dec  m_word [_rc_]
        jns  _l0340
        jmp  exfal
_l0340:
call_175:
        jmp  exsid
	align	2
	nop
s_spn:
        mov  wb,p_sps
        mov  xl,p_spn
        mov  wc,p_spd
        call patst
        dec  m_word [_rc_]
        js   call_176
        dec  m_word [_rc_]
        jns  _l0341
        mov  m_word [_rc_],188
        jmp  err_
_l0341:
call_176:
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
s_si_:
        call gtstg
        dec  m_word [_rc_]
        js   call_177
        dec  m_word [_rc_]
        jns  _l0342
        mov  m_word [_rc_],189
        jmp  err_
_l0342:
call_177:
        ldi_ wa
        jmp  exint
	align	2
	nop
s_stt:
        xor  xl,xl
        call trace
        dec  m_word [_rc_]
        js   call_178
        dec  m_word [_rc_]
        jns  _l0343
        mov  m_word [_rc_],190
        jmp  err_
_l0343:
        dec  m_word [_rc_]
        jns  _l0344
        mov  m_word [_rc_],191
        jmp  err_
_l0344:
call_178:
        jmp  exnul
	align	2
	nop
s_sub:
        call gtsmi
        dec  m_word [_rc_]
        js   call_179
        dec  m_word [_rc_]
        jns  _l0345
        mov  m_word [_rc_],192
        jmp  err_
_l0345:
        dec  m_word [_rc_]
        jns  _l0346
        jmp  exfal
_l0346:
call_179:
        mov  m_word [REL sbssv],xr
        call gtsmi
        dec  m_word [_rc_]
        js   call_180
        dec  m_word [_rc_]
        jns  _l0347
        mov  m_word [_rc_],193
        jmp  err_
_l0347:
        dec  m_word [_rc_]
        jns  _l0348
        jmp  exfal
_l0348:
call_180:
        mov  wc,xr
        or   wc,wc
        jz   exfal
        dec  wc
        call gtstg
        dec  m_word [_rc_]
        js   call_181
        dec  m_word [_rc_]
        jns  _l0349
        mov  m_word [_rc_],194
        jmp  err_
_l0349:
call_181:
        mov  wb,wc
        mov  wc,m_word [REL sbssv]
        or   wc,wc
        jnz  ssub2
        mov  wc,wa
        cmp  wb,wc
        ja   exfal
        sub  wc,wb
ssub2:
        mov  xl,wa
        mov  wa,wc
        add  wc,wb
        cmp  wc,xl
        ja   exfal
        mov  xl,xr
        call sbstr
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
s_tbl:
        pop  xl
        add  xs,cfp_b
        call gtsmi
        dec  m_word [_rc_]
        js   call_182
        dec  m_word [_rc_]
        jns  _l0350
        mov  m_word [_rc_],195
        jmp  err_
_l0350:
        dec  m_word [_rc_]
        jns  _l0351
        mov  m_word [_rc_],196
        jmp  err_
_l0351:
call_182:
        or   wc,wc
        jnz  stbl1
        mov  wc,tbnbk
stbl1:
        call tmake
        jmp  exsid
	align	2
	nop
s_tan:
        pop  xr
        call gtrea
        dec  m_word [_rc_]
        js   call_183
        dec  m_word [_rc_]
        jns  _l0352
        mov  m_word [_rc_],309
        jmp  err_
_l0352:
call_183:
        lea  w0,[REL (cfp_b*rcval)+xr]
        call ldr_
        call tan_
        rno_ exrea
        mov  m_word [_rc_],310
        jmp  err_
	align	2
	nop
s_tim:
        call systm
        sbi_ m_word [REL timsx]
        jmp  exint
	align	2
	nop
s_tra:
        cmp  m_word [REL (cfp_b*num03)+xs],nulls
        je   str02
        pop  xr
        xor  xl,xl
        cmp  xr,nulls
        je   str01
        call gtnvr
        dec  m_word [_rc_]
        js   call_184
        dec  m_word [_rc_]
        jns  _l0353
        jmp  str03
_l0353:
call_184:
        mov  xl,xr
str01:
        pop  xr
        xor  wb,wb
        call trbld
        mov  xl,xr
        call trace
        dec  m_word [_rc_]
        js   call_185
        dec  m_word [_rc_]
        jns  _l0354
        mov  m_word [_rc_],198
        jmp  err_
_l0354:
        dec  m_word [_rc_]
        jns  _l0355
        mov  m_word [_rc_],199
        jmp  err_
_l0355:
call_185:
        jmp  exnul
str02:
        call systt
        add  xs,cfp_b*num04
        jmp  exnul
str03:
        mov  m_word [_rc_],197
        jmp  err_
	align	2
	nop
s_trm:
        call gtstg
        dec  m_word [_rc_]
        js   call_186
        dec  m_word [_rc_]
        jns  _l0356
        mov  m_word [_rc_],200
        jmp  err_
_l0356:
call_186:
        or   wa,wa
        jz   exnul
        mov  xl,xr
        add  wa,(cfp_b-1)+cfp_b*schar
        and  wa,-cfp_b
        call alloc
        mov  wb,xr
        shr  wa,log_cfp_b
        rep  movs_w
        mov  xr,wb
        call trimr
        push xr
        lcw_ xr
        jmp  m_word [ xr]
	align	2
	nop
s_unl:
        pop  xr
        call gtnvr
        dec  m_word [_rc_]
        js   call_187
        dec  m_word [_rc_]
        jns  _l0357
        mov  m_word [_rc_],201
        jmp  err_
_l0357:
call_187:
        mov  xl,stndf
        call dffnc
        jmp  exnul
arref:
        mov  wa,xr
        mov  xt,xs
        sal  xr,log_cfp_b
        add  xt,xr
        add  xt,cfp_b
        mov  m_word [REL arfxs],xt
        lea  xt,[xt-cfp_b]
        mov  xr,m_word [xt]
        mov  m_word [REL r_arf],xr
        mov  xr,xt
        mov  xl,m_word [REL r_arf]
        mov  wc,m_word [ xl]
        cmp  wc,b_art
        je   arf01
        cmp  wc,b_vct
        je   arf07
        cmp  wc,b_tbt
        je   arf10
        mov  m_word [_rc_],235
        jmp  err_
arf01:
        cmp  wa,m_word [REL (cfp_b*arndm)+xl]
        jne  arf09
        ldi_ m_word [REL intv0]
        mov  xt,xr
        xor  wa,wa
        jmp  arf03
arf02:
        mli_ m_word [REL (cfp_b*ardm2)+xr]
arf03:
        lea  xt,[xt-cfp_b]
        mov  xr,m_word [xt]
        sti_ m_word [REL arfsi]
        ldi_ m_word [REL (cfp_b*icval)+xr]
        cmp  m_word [ xr],b_icl
        je   arf04
        call gtint
        dec  m_word [_rc_]
        js   call_188
        dec  m_word [_rc_]
        jns  _l0358
        jmp  arf12
_l0358:
call_188:
        ldi_ m_word [REL (cfp_b*icval)+xr]
arf04:
        mov  xr,m_word [REL r_arf]
        add  xr,wa
        sbi_ m_word [REL (cfp_b*arlbd)+xr]
        iov_ arf13
        sti_ w0
        or   w0,w0
        jl   arf13
        sbi_ m_word [REL (cfp_b*ardim)+xr]
        sti_ w0
        or   w0,w0
        jge  arf13
        adi_ m_word [REL (cfp_b*ardim)+xr]
        adi_ m_word [REL arfsi]
        add  wa,cfp_b*ardms
        cmp  xt,xs
        jne  arf02
        sti_ wa
        sal  wa,log_cfp_b
        mov  xl,m_word [REL r_arf]
        add  wa,m_word [REL (cfp_b*arofs)+xl]
        add  wa,cfp_b
        or   wb,wb
        jnz  arf08
arf05:
        call acess
        dec  m_word [_rc_]
        js   call_189
        dec  m_word [_rc_]
        jns  _l0359
        jmp  arf13
_l0359:
call_189:
arf06:
        mov  xs,m_word [REL arfxs]
        mov  w0,0
        mov  m_word [REL r_arf],w0
        push xr
        lcw_ xr
        jmp  m_word [ xr]
arf07:
        cmp  wa,num01
        jne  arf09
        mov  xr,m_word [ xs]
        call gtint
        dec  m_word [_rc_]
        js   call_190
        dec  m_word [_rc_]
        jns  _l0360
        jmp  arf12
_l0360:
call_190:
        ldi_ m_word [REL (cfp_b*icval)+xr]
        sbi_ m_word [REL intv1]
        sti_ w0
        or   w0,w0
        js   arf13
        sti_ wa
        add  wa,vcvls
        sal  wa,log_cfp_b
        cmp  wa,m_word [REL (cfp_b*vclen)+xl]
        jae  arf13
        or   wb,wb
        jz   arf05
arf08:
        mov  xs,m_word [REL arfxs]
        mov  w0,0
        mov  m_word [REL r_arf],w0
        jmp  exnam
arf09:
        mov  m_word [_rc_],236
        jmp  err_
arf10:
        cmp  wa,num01
        jne  arf11
        mov  xr,m_word [ xs]
        call tfind
        dec  m_word [_rc_]
        js   call_191
        dec  m_word [_rc_]
        jns  _l0361
        jmp  arf13
_l0361:
call_191:
        or   wb,wb
        jnz  arf08
        jmp  arf06
arf11:
        mov  m_word [_rc_],237
        jmp  err_
arf12:
        mov  m_word [_rc_],238
        jmp  err_
arf13:
        mov  w0,0
        mov  m_word [REL r_arf],w0
        jmp  exfal
cfunc:
        cmp  wa,m_word [REL (cfp_b*fargs)+xl]
        jb   cfnc1
        cmp  wa,m_word [REL (cfp_b*fargs)+xl]
        je   cfnc3
        mov  wb,wa
        sub  wb,m_word [REL (cfp_b*fargs)+xl]
        sal  wb,log_cfp_b
        add  xs,wb
        jmp  cfnc3
cfnc1:
        mov  wb,m_word [REL (cfp_b*fargs)+xl]
        cmp  wb,nini9
        je   cfnc3
        sub  wb,wa
cfnc2:
        push nulls
        dec  wb
        jnz  cfnc2
cfnc3:
        jmp  m_word [ xl]
exfal:
        mov  xs,m_word [REL flptr]
        mov  xr,m_word [ xs]
        add  xr,m_word [REL r_cod]
        lcp_ xr
        lcw_ xr
        mov  xl,m_word [ xr]
        jmp  xl
exint:
        xor  xl,xl
        call icbld
exixr:
        push xr
exits:
        lcw_ xr
        mov  xl,m_word [ xr]
        jmp  xl
exnam:
        push xl
        push wa
        lcw_ xr
        jmp  m_word [ xr]
exnul:
        push nulls
        lcw_ xr
        mov  xl,m_word [ xr]
        jmp  xl
exrea:
        xor  xl,xl
        call rcbld
        jmp  exixr
exsid:
        mov  wa,m_word [REL curid]
        cmp  wa,m_word [REL mxint]
        jne  exsi1
        xor  wa,wa
exsi1:
        inc  wa
        mov  m_word [REL curid],wa
        mov  m_word [REL (cfp_b*idval)+xr],wa
        jmp  exixr
exvnm:
        mov  xl,xr
        mov  wa,cfp_b*nmsi_
        call alloc
        mov  m_word [ xr],b_nml
        mov  m_word [REL (cfp_b*nmbas)+xr],xl
        mov  m_word [REL (cfp_b*nmofs)+xr],cfp_b*vrval
        jmp  exixr
flpop:
        add  xs,cfp_b*num02
failp:
        pop  xr
        pop  wb
        mov  xl,m_word [ xr]
        jmp  xl
indir:
        pop  xr
        cmp  m_word [ xr],b_nml
        je   indr2
        call gtnvr
        dec  m_word [_rc_]
        js   call_192
        dec  m_word [_rc_]
        jns  _l0362
        mov  m_word [_rc_],239
        jmp  err_
_l0362:
call_192:
        or   wb,wb
        jz   indr1
        push xr
        push cfp_b*vrval
        lcw_ xr
        mov  xl,m_word [ xr]
        jmp  xl
indr1:
        jmp  m_word [ xr]
indr2:
        mov  xl,m_word [REL (cfp_b*nmbas)+xr]
        mov  wa,m_word [REL (cfp_b*nmofs)+xr]
        or   wb,wb
        jnz  exnam
        call acess
        dec  m_word [_rc_]
        js   call_193
        dec  m_word [_rc_]
        jns  _l0363
        jmp  exfal
_l0363:
call_193:
        jmp  exixr
match:
        pop  xr
        call gtpat
        dec  m_word [_rc_]
        js   call_194
        dec  m_word [_rc_]
        jns  _l0364
        mov  m_word [_rc_],240
        jmp  err_
_l0364:
call_194:
        mov  xl,xr
        or   wb,wb
        jnz  mtch1
        mov  wa,m_word [ xs]
        push xl
        mov  xl,m_word [REL (cfp_b*num02)+xs]
        call acess
        dec  m_word [_rc_]
        js   call_195
        dec  m_word [_rc_]
        jns  _l0365
        jmp  exfal
_l0365:
call_195:
        mov  xl,m_word [ xs]
        mov  m_word [ xs],xr
        xor  wb,wb
mtch1:
        call gtstg
        dec  m_word [_rc_]
        js   call_196
        dec  m_word [_rc_]
        jns  _l0366
        mov  m_word [_rc_],241
        jmp  err_
_l0366:
call_196:
        push wb
        mov  m_word [REL r_pms],xr
        mov  m_word [REL pmssl],wa
        push 0
        xor  wb,wb
        mov  m_word [REL pmhbs],xs
        mov  w0,0
        mov  m_word [REL pmdfl],w0
        mov  xr,xl
        cmp  m_word [REL kvanc],0
        jnz  mtch2
        push xr
        push nduna
        jmp  m_word [ xr]
mtch2:
        push 0
        push ndabo
        jmp  m_word [ xr]
retrn:
        cmp  m_word [REL kvfnc],0
        jnz  rtn01
        mov  m_word [_rc_],242
        jmp  err_
rtn01:
        mov  xs,m_word [REL flprt]
        add  xs,cfp_b
        pop  xr
        pop  m_word [REL flptr]
        pop  m_word [REL flprt]
        pop  wb
        pop  wc
        add  wb,wc
        lcp_ wb
        mov  m_word [REL r_cod],wc
        dec  m_word [REL kvfnc]
        mov  wb,m_word [REL kvtra]
        add  wb,m_word [REL kvftr]
        or   wb,wb
        jz   rtn06
        push wa
        push xr
        mov  m_word [REL kvrtn],wa
        mov  xl,m_word [REL r_fnc]
        call ktrex
        mov  xl,m_word [REL (cfp_b*pfvbl)+xr]
        cmp  m_word [REL kvtra],0
        jz   rtn02
        mov  xr,m_word [REL (cfp_b*pfrtr)+xr]
        or   xr,xr
        jz   rtn02
        dec  m_word [REL kvtra]
        cmp  m_word [REL (cfp_b*trfnc)+xr],0
        jz   rtn03
        mov  wa,cfp_b*vrval
        mov  w0,m_word [REL (cfp_b*num01)+xs]
        mov  m_word [REL kvrtn],w0
        call trxeq
rtn02:
        cmp  m_word [REL kvftr],0
        jz   rtn05
        dec  m_word [REL kvftr]
rtn03:
        call prtsn
        mov  xr,m_word [REL (cfp_b*num01)+xs]
        call prtst
        mov  wa,ch_bl
        call prtch
        mov  xl,m_word [REL (cfp_b*0)+xs]
        mov  xl,m_word [REL (cfp_b*pfvbl)+xl]
        mov  wa,cfp_b*vrval
        cmp  xr,scfrt
        jne  rtn04
        call prtnm
        call prtnl
        jmp  rtn05
rtn04:
        call prtnv
rtn05:
        pop  xr
        pop  wa
rtn06:
        mov  m_word [REL kvrtn],wa
        mov  xl,m_word [REL (cfp_b*pfvbl)+xr]
rtn07:
        mov  m_word [REL rtnbp],xl
        mov  xl,m_word [REL (cfp_b*vrval)+xl]
        cmp  m_word [ xl],b_trt
        je   rtn07
        mov  m_word [REL rtnfv],xl
        pop  m_word [REL rtnsv]
        pop  xl
        or   xl,xl
        jz   rtn7c
        cmp  m_word [REL kvpfl],0
        jz   rtn7c
        call prflu
        cmp  m_word [REL kvpfl],num02
        je   rtn7a
        ldi_ m_word [REL pfstm]
        sbi_ m_word [REL (cfp_b*icval)+xl]
        jmp  rtn7b
rtn7a:
        ldi_ m_word [REL (cfp_b*icval)+xl]
rtn7b:
        sti_ m_word [REL pfstm]
rtn7c:
        mov  wb,m_word [REL (cfp_b*fargs)+xr]
        add  wb,m_word [REL (cfp_b*pfnlo)+xr]
        or   wb,wb
        jz   rtn10
        add  xr,m_word [REL (cfp_b*pflen)+xr]
rtn08:
        lea  xr,[xr-cfp_b]
        mov  xl,m_word [xr]
rtn09:
        mov  wa,xl
        mov  xl,m_word [REL (cfp_b*vrval)+xl]
        cmp  m_word [ xl],b_trt
        je   rtn09
        mov  xl,wa
        pop  m_word [REL (cfp_b*vrval)+xl]
        dec  wb
        jnz  rtn08
rtn10:
        mov  xl,m_word [REL rtnbp]
        mov  w0,m_word [REL rtnsv]
        mov  m_word [REL (cfp_b*vrval)+xl],w0
        mov  xr,m_word [REL rtnfv]
        mov  xl,m_word [REL r_cod]
        mov  w0,m_word [REL kvstn]
        mov  m_word [REL kvlst],w0
        mov  w0,m_word [REL (cfp_b*cdstm)+xl]
        mov  m_word [REL kvstn],w0
        mov  w0,m_word [REL kvlin]
        mov  m_word [REL kvlln],w0
        mov  w0,m_word [REL (cfp_b*cdsln)+xl]
        mov  m_word [REL kvlin],w0
        mov  wa,m_word [REL kvrtn]
        cmp  wa,scrtn
        je   exixr
        cmp  wa,scfrt
        je   exfal
        cmp  m_word [ xr],b_nml
        je   rtn11
        call gtnvr
        dec  m_word [_rc_]
        js   call_197
        dec  m_word [_rc_]
        jns  _l0367
        mov  m_word [_rc_],243
        jmp  err_
_l0367:
call_197:
        mov  xl,xr
        mov  wa,cfp_b*vrval
        jmp  rtn12
rtn11:
        mov  xl,m_word [REL (cfp_b*nmbas)+xr]
        mov  wa,m_word [REL (cfp_b*nmofs)+xr]
rtn12:
        mov  xr,xl
        lcw_ wb
        mov  xl,xr
        cmp  wb,ofne_
        je   exnam
        push wb
        call acess
        dec  m_word [_rc_]
        js   call_198
        dec  m_word [_rc_]
        jns  _l0368
        jmp  exfal
_l0368:
call_198:
        mov  xl,xr
        mov  xr,m_word [ xs]
        mov  m_word [ xs],xl
        mov  xl,m_word [ xr]
        jmp  xl
stcov:
        inc  m_word [REL errft]
        ldi_ m_word [REL intvt]
        adi_ m_word [REL kvstl]
        sti_ m_word [REL kvstl]
        ldi_ m_word [REL intvt]
        sti_ m_word [REL kvstc]
        call stgcc
        mov  m_word [_rc_],244
        jmp  err_
stmgo:
        mov  m_word [REL r_cod],xr
        dec  m_word [REL stmct]
        cmp  m_word [REL stmct],0
        jz   stgo2
        mov  w0,m_word [REL kvstn]
        mov  m_word [REL kvlst],w0
        mov  w0,m_word [REL (cfp_b*cdstm)+xr]
        mov  m_word [REL kvstn],w0
        mov  w0,m_word [REL kvlin]
        mov  m_word [REL kvlln],w0
        mov  w0,m_word [REL (cfp_b*cdsln)+xr]
        mov  m_word [REL kvlin],w0
        add  xr,cfp_b*cdcod
        lcp_ xr
stgo1:
        lcw_ xr
        xor  xl,xl
        jmp  m_word [ xr]
stgo2:
        cmp  m_word [REL kvpfl],0
        jz   stgo3
        call prflu
stgo3:
        mov  w0,m_word [REL kvstn]
        mov  m_word [REL kvlst],w0
        mov  w0,m_word [REL (cfp_b*cdstm)+xr]
        mov  m_word [REL kvstn],w0
        mov  w0,m_word [REL kvlin]
        mov  m_word [REL kvlln],w0
        mov  w0,m_word [REL (cfp_b*cdsln)+xr]
        mov  m_word [REL kvlin],w0
        add  xr,cfp_b*cdcod
        lcp_ xr
        push m_word [REL stmcs]
        dec  m_word [REL polct]
        cmp  m_word [REL polct],0
        jnz  stgo4
        xor  wa,wa
        mov  wb,m_word [REL kvstn]
        mov  xl,xr
        call syspl
        dec  m_word [_rc_]
        js   call_199
        dec  m_word [_rc_]
        jns  _l0369
        mov  m_word [_rc_],320
        jmp  err_
_l0369:
        dec  m_word [_rc_]
        jns  _l0370
        mov  m_word [_rc_],299
        jmp  err_
_l0370:
        dec  m_word [_rc_]
        jns  _l0371
        mov  m_word [_rc_],299
        jmp  err_
_l0371:
call_199:
        mov  xr,xl
        mov  m_word [REL polcs],wa
        call stgcc
stgo4:
        ldi_ m_word [REL kvstc]
        sti_ w0
        or   w0,w0
        jl   stgo5
        pop  w0
        ldi_ w0
        ngi_
        adi_ m_word [REL kvstc]
        sti_ m_word [REL kvstc]
        sti_ w0
        or   w0,w0
        jle  stcov
        cmp  m_word [REL r_stc],0
        jz   stgo5
        xor  xr,xr
        mov  xl,m_word [REL r_stc]
        call ktrex
stgo5:
        mov  w0,m_word [REL stmcs]
        mov  m_word [REL stmct],w0
        jmp  stgo1
stopr:
        or   xr,xr
        jz   stpra
        call sysax
stpra:
        mov  w0,m_word [REL rsmem]
        add  m_word [REL dname],w0
        cmp  xr,endms
        jne  stpr0
        cmp  m_word [REL exsts],0
        jnz  stpr3
        mov  w0,0
        mov  m_word [REL erich],w0
stpr0:
        call prtpg
        or   xr,xr
        jz   stpr1
        call prtst
stpr1:
        call prtis
        cmp  m_word [REL gbcfl],0
        jnz  stpr5
        mov  xr,stpm7
        call prtst
        mov  m_word [REL profs],prtmf
        mov  wc,m_word [REL kvstn]
        call filnm
        mov  xr,xl
        call prtst
        call prtis
        mov  xr,m_word [REL r_cod]
        ldi_ m_word [REL (cfp_b*cdsln)+xr]
        mov  xr,stpm6
        call prtmx
stpr5:
        ldi_ m_word [REL kvstn]
        mov  xr,stpm1
        call prtmx
        call systm
        sbi_ m_word [REL timsx]
        sti_ m_word [REL stpti]
        mov  xr,stpm3
        call prtmx
        ldi_ m_word [REL kvstl]
        sti_ w0
        or   w0,w0
        jl   stpr2
        sbi_ m_word [REL kvstc]
        sti_ m_word [REL stpsi]
        mov  wa,m_word [REL stmcs]
        sub  wa,m_word [REL stmct]
        ldi_ wa
        adi_ m_word [REL stpsi]
        sti_ m_word [REL stpsi]
        mov  xr,stpm2
        call prtmx
        ldi_ m_word [REL stpti]
        mli_ m_word [REL intth]
        iov_ stpr2
        dvi_ m_word [REL stpsi]
        iov_ stpr2
        mov  xr,stpm4
        call prtmx
stpr2:
        ldi_ m_word [REL gbcnt]
        mov  xr,stpm5
        call prtmx
        call prtmm
        call prtis
stpr3:
        call prflr
        mov  xr,m_word [REL kvdmp]
        call dumpr
        mov  xl,m_word [REL r_fcb]
        mov  wa,m_word [REL kvabe]
        mov  wb,m_word [REL kvcod]
        call sysej
stpr4:
        mov  w0,m_word [REL rsmem]
        add  m_word [REL dname],w0
        cmp  m_word [REL exsts],0
        jz   stpr1
        jmp  stpr3
succp:
        mov  xr,m_word [REL (cfp_b*pthen)+xr]
        mov  xl,m_word [ xr]
        jmp  xl
sysab:
        mov  xr,endab
        mov  m_word [REL kvabe],num01
        call prtnl
        jmp  stopr
systu:
        mov  xr,endtu
        mov  wa,m_word [REL strtu]
        mov  m_word [REL kvcod],wa
        mov  wa,m_word [REL timup]
        mov  m_word [REL timup],xs
        or   wa,wa
        jnz  stopr
        mov  m_word [_rc_],245
        jmp  err_
acess:
        mov  xr,xl
        add  xr,wa
        mov  xr,m_word [ xr]
acs02:
        cmp  m_word [ xr],b_trt
        jne  acs18
        cmp  xr,trbkv
        je   acs12
        cmp  xr,trbev
        jne  acs05
        mov  xr,m_word [REL (cfp_b*evexp)+xl]
        xor  wb,wb
        call evalx
        dec  m_word [_rc_]
        js   call_200
        dec  m_word [_rc_]
        jns  _l0372
        jmp  acs04
_l0372:
call_200:
        jmp  acs02
acs03:
        add  xs,cfp_b*num03
        mov  m_word [REL dnamp],xr
acs04:
        mov  m_word [_rc_],1
        ret
acs05:
        mov  wb,m_word [REL (cfp_b*trtyp)+xr]
        or   wb,wb
        jnz  acs10
        cmp  m_word [REL kvinp],0
        jz   acs09
        push xl
        push wa
        push xr
        mov  w0,m_word [REL kvtrm]
        mov  m_word [REL actrm],w0
        mov  xl,m_word [REL (cfp_b*trfpt)+xr]
        or   xl,xl
        jnz  acs06
        cmp  m_word [REL (cfp_b*trter)+xr],v_ter
        je   acs21
        mov  wa,m_word [REL cswin]
        call alocs
        call sysrd
        dec  m_word [_rc_]
        js   call_201
        dec  m_word [_rc_]
        jns  _l0373
        jmp  acs03
_l0373:
call_201:
        jmp  acs07
acs06:
        mov  wa,xl
        call sysil
        or   wc,wc
        jnz  acs6a
        mov  m_word [REL actrm],wc
acs6a:
        call alocs
        mov  wa,xl
        call sysin
        dec  m_word [_rc_]
        js   call_202
        dec  m_word [_rc_]
        jns  _l0374
        jmp  acs03
_l0374:
        dec  m_word [_rc_]
        jns  _l0375
        jmp  acs22
_l0375:
        dec  m_word [_rc_]
        jns  _l0376
        jmp  acs23
_l0376:
call_202:
acs07:
        mov  wb,m_word [REL actrm]
        call trimr
        mov  wb,xr
        mov  xr,m_word [ xs]
acs08:
        mov  xl,xr
        mov  xr,m_word [REL (cfp_b*trnxt)+xr]
        cmp  m_word [ xr],b_trt
        je   acs08
        mov  m_word [REL (cfp_b*trnxt)+xl],wb
        pop  xr
        pop  wa
        pop  xl
acs09:
        mov  xr,m_word [REL (cfp_b*trnxt)+xr]
        jmp  acs02
acs10:
        cmp  wb,trtac
        jne  acs09
        cmp  m_word [REL kvtra],0
        jz   acs09
        dec  m_word [REL kvtra]
        cmp  m_word [REL (cfp_b*trfnc)+xr],0
        jz   acs11
        call trxeq
        jmp  acs09
acs11:
        call prtsn
        call prtnv
        jmp  acs09
acs12:
        mov  xr,m_word [REL (cfp_b*kvnum)+xl]
        cmp  xr,k_v__
        jae  acs14
        ldi_ m_word [REL kvabe+xr]
acs13:
        call icbld
        jmp  acs18
acs14:
        cmp  xr,k_s__
        jae  acs15
        sub  xr,k_v__
        sal  xr,log_cfp_b
        add  xr,ndabo
        jmp  acs18
acs15:
        mov  xl,m_word [REL kvrtn]
        ldi_ m_word [REL kvstl]
        sub  xr,k_s__
        jmp  m_word [_l0377+xr*cfp_b]
        segment .data
_l0377:
        d_word acs16
        d_word acs17
        d_word acs19
        d_word acs20
        d_word acs26
        d_word acs27
        d_word acs13
        d_word acs24
        d_word acs25
        segment .text
acs24:
        mov  xr,lcase
        jmp  acs18
acs25:
        mov  xr,ucase
        jmp  acs18
acs26:
        mov  wc,m_word [REL kvstn]
        jmp  acs28
acs27:
        mov  wc,m_word [REL kvlst]
acs28:
        call filnm
        jmp  acs17
acs16:
        mov  xl,m_word [REL kvalp]
acs17:
        mov  xr,xl
acs18:
        mov  m_word [_rc_],0
        ret
acs19:
        sti_ w0
        or   w0,w0
        jl   acs29
        mov  wa,m_word [REL stmcs]
        sub  wa,m_word [REL stmct]
        ldi_ wa
        adi_ m_word [REL kvstl]
acs29:
        sbi_ m_word [REL kvstc]
        jmp  acs13
acs20:
        mov  xr,m_word [REL r_etx]
        jmp  acs18
acs21:
        mov  wa,rilen
        call alocs
        call sysri
        dec  m_word [_rc_]
        js   call_203
        dec  m_word [_rc_]
        jns  _l0378
        jmp  acs03
_l0378:
call_203:
        jmp  acs07
acs22:
        mov  m_word [REL dnamp],xr
        mov  m_word [_rc_],202
        jmp  err_
acs23:
        mov  m_word [REL dnamp],xr
        mov  m_word [_rc_],203
        jmp  err_
acomp:
        pop  m_word [prc_+cfp_b*0]
        call arith
        dec  m_word [_rc_]
        js   call_204
        dec  m_word [_rc_]
        jns  _l0379
        jmp  acmp7
_l0379:
        dec  m_word [_rc_]
        jns  _l0380
        jmp  acmp8
_l0380:
        dec  m_word [_rc_]
        jns  _l0381
        jmp  acmp4
_l0381:
call_204:
        sbi_ m_word [REL (cfp_b*icval)+xl]
        iov_ acmp3
        sti_ w0
        or   w0,w0
        jl   acmp5
        sti_ w0
        or   w0,w0
        je   acmp2
acmp1:
        mov  m_word [_rc_],5
        mov  w0,m_word [prc_+cfp_b*0]
        jmp  w0
acmp2:
        mov  m_word [_rc_],4
        mov  w0,m_word [prc_+cfp_b*0]
        jmp  w0
acmp3:
        ldi_ m_word [REL (cfp_b*icval)+xl]
        sti_ w0
        or   w0,w0
        jl   acmp1
        jmp  acmp5
acmp4:
        lea  w0,[REL (cfp_b*rcval)+xl]
        call sbr_
        rov_ acmp6
        call cpr_
        mov  al,byte [reg_fl]
        or   al,al
        jg   acmp1
        call cpr_
        mov  al,byte [reg_fl]
        or   al,al
        je   acmp2
acmp5:
        mov  m_word [_rc_],3
        mov  w0,m_word [prc_+cfp_b*0]
        jmp  w0
acmp6:
        lea  w0,[REL (cfp_b*rcval)+xl]
        call ldr_
        call cpr_
        mov  al,byte [reg_fl]
        or   al,al
        jl   acmp1
        jmp  acmp5
acmp7:
        mov  m_word [_rc_],1
        mov  w0,m_word [prc_+cfp_b*0]
        jmp  w0
acmp8:
        mov  m_word [_rc_],2
        mov  w0,m_word [prc_+cfp_b*0]
        jmp  w0
alloc:
aloc1:
        mov  xr,m_word [REL dnamp]
        add  xr,wa
        jc   aloc2
        cmp  xr,m_word [REL dname]
        ja   aloc2
        mov  m_word [REL dnamp],xr
        sub  xr,wa
        ret
aloc2:
        mov  m_word [REL allsv],wb
alc2a:
        xor  wb,wb
        call gbcol
        mov  wb,xr
aloc3:
        mov  xr,m_word [REL dnamp]
        add  xr,wa
        jc   alc3a
        cmp  xr,m_word [REL dname]
        jb   aloc4
alc3a:
        call sysmm
        sal  xr,log_cfp_b
        add  m_word [REL dname],xr
        or   xr,xr
        jnz  aloc3
        cmp  m_word [REL dnams],0
        jz   alc3b
        mov  w0,0
        mov  m_word [REL dnams],w0
        jmp  alc2a
alc3b:
        mov  w0,m_word [REL rsmem]
        add  m_word [REL dname],w0
        mov  w0,0
        mov  m_word [REL rsmem],w0
        inc  m_word [REL errft]
        mov  m_word [_rc_],204
        jmp  err_
aloc4:
        sti_ m_word [REL allia]
        mov  m_word [REL dnams],wb
        mov  wb,m_word [REL dname]
        sub  wb,m_word [REL dnamp]
        shr  wb,log_cfp_b
        ldi_ wb
        mli_ m_word [REL alfsf]
        iov_ aloc5
        mov  wb,m_word [REL dname]
        sub  wb,m_word [REL dnamb]
        shr  wb,log_cfp_b
        mov  m_word [REL aldyn],wb
        sbi_ m_word [REL aldyn]
        sti_ w0
        or   w0,w0
        jg   aloc5
        call sysmm
        sal  xr,log_cfp_b
        add  m_word [REL dname],xr
aloc5:
        ldi_ m_word [REL allia]
        mov  wb,m_word [REL allsv]
        jmp  aloc1
alocs:
        cmp  wa,m_word [REL kvmxl]
        ja   alcs2
        mov  wc,wa
        add  wa,(cfp_b-1)+cfp_b*scsi_
        and  wa,-cfp_b
        mov  xr,m_word [REL dnamp]
        add  xr,wa
        jc   alcs0
        cmp  xr,m_word [REL dname]
        jb   alcs1
alcs0:
        xor  xr,xr
        call alloc
        add  xr,wa
alcs1:
        mov  m_word [REL dnamp],xr
        lea  xr,[xr-cfp_b]
        mov  w0,0
        mov  m_word [xr],w0
        sub  wa,cfp_b
        sub  xr,wa
        mov  m_word [ xr],b_scl
        mov  m_word [REL (cfp_b*sclen)+xr],wc
        ret
alcs2:
        mov  m_word [_rc_],205
        jmp  err_
alost:
alst1:
        mov  xr,m_word [REL state]
        add  xr,wa
        jc   alst2
        cmp  xr,m_word [REL dnamb]
        jae  alst2
        mov  m_word [REL state],xr
        sub  xr,wa
        ret
alst2:
        mov  m_word [REL alsta],wa
        cmp  wa,cfp_b*e_sts
        jae  alst3
        mov  wa,cfp_b*e_sts
alst3:
        call alloc
        mov  m_word [REL dnamp],xr
        mov  wb,wa
        call gbcol
        mov  m_word [REL dnams],xr
        mov  wa,m_word [REL alsta]
        jmp  alst1
arith:
        pop  m_word [prc_+cfp_b*1]
        pop  xl
        pop  xr
        mov  wa,m_word [ xl]
        cmp  wa,b_icl
        je   arth1
        cmp  wa,b_rcl
        je   arth4
        push xr
        mov  xr,xl
        call gtnum
        dec  m_word [_rc_]
        js   call_205
        dec  m_word [_rc_]
        jns  _l0382
        jmp  arth6
_l0382:
call_205:
        mov  xl,xr
        mov  wa,m_word [ xl]
        pop  xr
        cmp  wa,b_rcl
        je   arth4
arth1:
        cmp  m_word [ xr],b_icl
        jne  arth3
arth2:
        ldi_ m_word [REL (cfp_b*icval)+xr]
        mov  m_word [_rc_],0
        mov  w0,m_word [prc_+cfp_b*1]
        jmp  w0
arth3:
        call gtnum
        dec  m_word [_rc_]
        js   call_206
        dec  m_word [_rc_]
        jns  _l0383
        jmp  arth7
_l0383:
call_206:
        cmp  wa,b_icl
        je   arth2
        push xr
        ldi_ m_word [REL (cfp_b*icval)+xl]
        call itr_
        call rcbld
        mov  xl,xr
        pop  xr
        jmp  arth5
arth4:
        cmp  m_word [ xr],b_rcl
        je   arth5
        call gtrea
        dec  m_word [_rc_]
        js   call_207
        dec  m_word [_rc_]
        jns  _l0384
        jmp  arth7
_l0384:
call_207:
arth5:
        lea  w0,[REL (cfp_b*rcval)+xr]
        call ldr_
        mov  m_word [_rc_],3
        mov  w0,m_word [prc_+cfp_b*1]
        jmp  w0
arth6:
        add  xs,cfp_b
        mov  m_word [_rc_],2
        mov  w0,m_word [prc_+cfp_b*1]
        jmp  w0
arth7:
        mov  m_word [_rc_],1
        mov  w0,m_word [prc_+cfp_b*1]
        jmp  w0
asign:
asg01:
        add  xl,wa
        mov  xr,m_word [ xl]
        cmp  m_word [ xr],b_trt
        je   asg02
        mov  m_word [ xl],wb
        xor  xl,xl
        mov  m_word [_rc_],0
        ret
asg02:
        sub  xl,wa
        cmp  xr,trbkv
        je   asg14
        cmp  xr,trbev
        jne  asg04
        mov  xr,m_word [REL (cfp_b*evexp)+xl]
        push wb
        mov  wb,num01
        call evalx
        dec  m_word [_rc_]
        js   call_208
        dec  m_word [_rc_]
        jns  _l0385
        jmp  asg03
_l0385:
call_208:
        pop  wb
        jmp  asg01
asg03:
        add  xs,cfp_b
        mov  m_word [_rc_],1
        ret
asg04:
        push xr
asg05:
        mov  wc,xr
        mov  xr,m_word [REL (cfp_b*trnxt)+xr]
        cmp  m_word [ xr],b_trt
        je   asg05
        mov  xr,wc
        mov  m_word [REL (cfp_b*trval)+xr],wb
        pop  xr
asg06:
        mov  wb,m_word [REL (cfp_b*trtyp)+xr]
        cmp  wb,trtvl
        je   asg08
        cmp  wb,trtou
        je   asg10
asg07:
        mov  xr,m_word [REL (cfp_b*trnxt)+xr]
        cmp  m_word [ xr],b_trt
        je   asg06
        mov  m_word [_rc_],0
        ret
asg08:
        cmp  m_word [REL kvtra],0
        jz   asg07
        dec  m_word [REL kvtra]
        cmp  m_word [REL (cfp_b*trfnc)+xr],0
        jz   asg09
        call trxeq
        jmp  asg07
asg09:
        call prtsn
        call prtnv
        jmp  asg07
asg10:
        cmp  m_word [REL kvoup],0
        jz   asg07
asg1b:
        mov  xl,xr
        mov  xr,m_word [REL (cfp_b*trnxt)+xr]
        cmp  m_word [ xr],b_trt
        je   asg1b
        mov  xr,xl
        push m_word [REL (cfp_b*trval)+xr]
        call gtstg
        dec  m_word [_rc_]
        js   call_209
        dec  m_word [_rc_]
        jns  _l0386
        jmp  asg12
_l0386:
call_209:
asg11:
        mov  wa,m_word [REL (cfp_b*trfpt)+xl]
        or   wa,wa
        jz   asg13
asg1a:
        call sysou
        dec  m_word [_rc_]
        js   call_210
        dec  m_word [_rc_]
        jns  _l0387
        mov  m_word [_rc_],206
        jmp  err_
_l0387:
        dec  m_word [_rc_]
        jns  _l0388
        mov  m_word [_rc_],207
        jmp  err_
_l0388:
call_210:
        mov  m_word [_rc_],0
        ret
asg12:
        call dtype
        jmp  asg11
asg13:
        cmp  m_word [REL (cfp_b*trter)+xl],v_ter
        je   asg1a
        inc  wa
        jmp  asg1a
asg14:
        mov  xl,m_word [REL (cfp_b*kvnum)+xl]
        cmp  xl,k_etx
        je   asg19
        mov  xr,wb
        call gtint
        dec  m_word [_rc_]
        js   call_211
        dec  m_word [_rc_]
        jns  _l0389
        mov  m_word [_rc_],208
        jmp  err_
_l0389:
call_211:
        ldi_ m_word [REL (cfp_b*icval)+xr]
        cmp  xl,k_stl
        je   asg16
        sti_ w0
        or   w0,w0
        js   asg18
        sti_ wa
        cmp  wa,m_word [REL mxlen]
        ja   asg18
        cmp  xl,k_ert
        je   asg17
        cmp  xl,k_pfl
        je   asg21
        cmp  xl,k_mxl
        je   asg24
        cmp  xl,k_fls
        je   asg26
        cmp  xl,k_p__
        jb   asg15
        mov  m_word [_rc_],209
        jmp  err_
asg15:
        mov  m_word [REL kvabe+xl],wa
        mov  m_word [_rc_],0
        ret
asg16:
        sbi_ m_word [REL kvstl]
        adi_ m_word [REL kvstc]
        sti_ m_word [REL kvstc]
        ldi_ m_word [REL kvstl]
        sti_ w0
        or   w0,w0
        jl   asg25
        mov  wa,m_word [REL stmcs]
        sub  wa,m_word [REL stmct]
        ldi_ wa
        ngi_
        adi_ m_word [REL kvstc]
        sti_ m_word [REL kvstc]
asg25:
        ldi_ m_word [REL (cfp_b*icval)+xr]
        sti_ m_word [REL kvstl]
        call stgcc
        mov  m_word [_rc_],0
        ret
asg17:
        cmp  wa,nini9
        jbe  error
asg18:
        mov  m_word [_rc_],210
        jmp  err_
asg19:
        push wb
        call gtstg
        dec  m_word [_rc_]
        js   call_212
        dec  m_word [_rc_]
        jns  _l0390
        mov  m_word [_rc_],211
        jmp  err_
_l0390:
call_212:
        mov  m_word [REL r_etx],xr
        mov  m_word [_rc_],0
        ret
asg21:
        cmp  wa,num02
        ja   asg18
        or   wa,wa
        jz   asg15
        cmp  m_word [REL pfdmp],0
        jz   asg22
        cmp  wa,m_word [REL pfdmp]
        je   asg23
        mov  m_word [_rc_],268
        jmp  err_
asg22:
        mov  m_word [REL pfdmp],wa
asg23:
        mov  m_word [REL kvpfl],wa
        call stgcc
        call systm
        sti_ m_word [REL pfstm]
        mov  m_word [_rc_],0
        ret
asg24:
        cmp  wa,mnlen
        jae  asg15
        mov  m_word [_rc_],287
        jmp  err_
asg26:
        or   wa,wa
        jnz  asg15
        mov  m_word [_rc_],274
        jmp  err_
asinp:
        add  xl,wa
        mov  xr,m_word [ xl]
        cmp  m_word [ xr],b_trt
        je   asnp1
        mov  m_word [ xl],wb
        xor  xl,xl
        mov  m_word [_rc_],0
        ret
asnp1:
        sub  xl,wa
        push m_word [REL pmssl]
        push m_word [REL pmhbs]
        push m_word [REL r_pms]
        push m_word [REL pmdfl]
        call asign
        dec  m_word [_rc_]
        js   call_213
        dec  m_word [_rc_]
        jns  _l0391
        jmp  asnp2
_l0391:
call_213:
        pop  m_word [REL pmdfl]
        pop  m_word [REL r_pms]
        pop  m_word [REL pmhbs]
        pop  m_word [REL pmssl]
        mov  m_word [_rc_],0
        ret
asnp2:
        pop  m_word [REL pmdfl]
        pop  m_word [REL r_pms]
        pop  m_word [REL pmhbs]
        pop  m_word [REL pmssl]
        mov  m_word [_rc_],1
        ret
blkln:
        mov  xl,wa
        movzx xl,byte [xl-1]
        cmp  xl,bl___
        jge  bln00
        jmp  m_word [_l0392+xl*cfp_b]
        segment .data
_l0392:
        d_word bln01
        d_word bln12
        d_word bln12
        d_word bln07
        d_word bln03
        d_word bln02
        d_word bln03
        d_word bln04
        d_word bln09
        d_word bln10
        d_word bln02
        d_word bln01
        d_word bln01
        d_word bln00
        d_word bln00
        d_word bln00
        d_word bln08
        d_word bln05
        d_word bln00
        d_word bln00
        d_word bln00
        d_word bln06
        d_word bln01
        d_word bln01
        d_word bln03
        d_word bln05
        d_word bln03
        d_word bln01
        d_word bln04
        segment .text
bln00:
        mov  wa,m_word [REL (cfp_b*num01)+xr]
        ret
bln01:
        mov  wa,m_word [REL (cfp_b*num02)+xr]
        ret
bln02:
        mov  wa,cfp_b*num02
        ret
bln03:
        mov  wa,cfp_b*num03
        ret
bln04:
        mov  wa,cfp_b*num04
        ret
bln05:
        mov  wa,cfp_b*num05
        ret
bln06:
        mov  wa,cfp_b*ctsi_
        ret
bln07:
        mov  wa,cfp_b*icsi_
        ret
bln08:
        mov  xl,m_word [REL (cfp_b*pddfp)+xr]
        mov  wa,m_word [REL (cfp_b*dfpdl)+xl]
        ret
bln09:
        mov  wa,cfp_b*rcsi_
        ret
bln10:
        mov  wa,m_word [REL (cfp_b*sclen)+xr]
        add  wa,(cfp_b-1)+cfp_b*scsi_
        and  wa,-cfp_b
        ret
bln12:
        mov  wa,m_word [REL (cfp_b*num03)+xr]
        ret
copyb:
        pop  m_word [prc_+cfp_b*2]
        mov  xr,m_word [ xs]
        cmp  xr,nulls
        je   cop10
        mov  wa,m_word [ xr]
        mov  wb,wa
        call blkln
        mov  xl,xr
        call alloc
        mov  m_word [ xs],xr
        shr  wa,log_cfp_b
        rep  movs_w
        xor  xl,xl
        mov  xr,m_word [ xs]
        cmp  wb,b_tbt
        je   cop05
        cmp  wb,b_vct
        je   cop01
        cmp  wb,b_pdt
        je   cop01
        cmp  wb,b_art
        jne  cop10
        add  xr,m_word [REL (cfp_b*arofs)+xr]
        jmp  cop02
cop01:
        add  xr,cfp_b*pdfld
cop02:
        mov  xl,m_word [ xr]
cop03:
        cmp  m_word [ xl],b_trt
        jne  cop04
        mov  xl,m_word [REL (cfp_b*trval)+xl]
        jmp  cop03
cop04:
        mov  w0,xl
        stos_w
        cmp  xr,m_word [REL dnamp]
        jne  cop02
        jmp  cop09
cop05:
        mov  w0,0
        mov  m_word [REL (cfp_b*idval)+xr],w0
        mov  wa,cfp_b*tesi_
        mov  wc,cfp_b*tbbuk
cop06:
        mov  xr,m_word [ xs]
        cmp  wc,m_word [REL (cfp_b*tblen)+xr]
        je   cop09
        mov  wb,wc
        sub  wb,cfp_b*tenxt
        add  xr,wb
        add  wc,cfp_b
cop07:
        mov  xl,m_word [REL (cfp_b*tenxt)+xr]
        mov  w0,m_word [ xs]
        mov  m_word [REL (cfp_b*tenxt)+xr],w0
        cmp  m_word [ xl],b_tbt
        je   cop06
        sub  xr,wb
        push xr
        mov  wa,cfp_b*tesi_
        call alloc
        push xr
        shr  wa,log_cfp_b
        rep  movs_w
        pop  xr
        pop  xl
        add  xl,wb
        mov  m_word [REL (cfp_b*tenxt)+xl],xr
        mov  xl,xr
cop08:
        mov  xl,m_word [REL (cfp_b*teval)+xl]
        cmp  m_word [ xl],b_trt
        je   cop08
        mov  m_word [REL (cfp_b*teval)+xr],xl
        xor  wb,wb
        jmp  cop07
cop09:
        pop  xr
        mov  m_word [_rc_],0
        mov  w0,m_word [prc_+cfp_b*2]
        jmp  w0
cop10:
        mov  m_word [_rc_],1
        mov  w0,m_word [prc_+cfp_b*2]
        jmp  w0
cdgcg:
        mov  xl,m_word [REL (cfp_b*cmopn)+xr]
        mov  xr,m_word [REL (cfp_b*cmrop)+xr]
        cmp  xl,opdvd
        je   cdgc2
        call cdgnm
cdgc1:
        mov  wa,xl
        call cdwrd
        ret
cdgc2:
        call cdgvl
        jmp  cdgc1
cdgex:
        cmp  m_word [ xl],b_vr_
        jb   cdgx1
        mov  wa,cfp_b*sesi_
        call alloc
        mov  m_word [ xr],b_sel
        mov  m_word [REL (cfp_b*sevar)+xr],xl
        ret
cdgx1:
        mov  xr,xl
        push wc
        mov  xl,m_word [REL cwcof]
        or   wa,wa
        jz   cdgx2
        mov  wa,m_word [ xr]
        cmp  wa,b_cmt
        jne  cdgx2
        cmp  m_word [REL (cfp_b*cmtyp)+xr],c__nm
        jae  cdgx2
        call cdgnm
        mov  wa,ornm_
        jmp  cdgx3
cdgx2:
        call cdgvl
        mov  wa,orvl_
cdgx3:
        call cdwrd
        call exbld
        pop  wc
        ret
cdgnm:
        push xl
        push wb
        cmp  xs,lowspmin
        jb   sec06
        mov  wa,m_word [ xr]
        cmp  wa,b_cmt
        je   cgn04
        cmp  wa,b_vr_
        ja   cgn02
cgn01:
        mov  m_word [_rc_],212
        jmp  err_
cgn02:
        mov  wa,olvn_
        call cdwrd
        mov  wa,xr
        call cdwrd
cgn03:
        pop  wb
        pop  xl
        ret
cgn04:
        mov  xl,xr
        mov  xr,m_word [REL (cfp_b*cmtyp)+xr]
        cmp  xr,c__nm
        jae  cgn01
        jmp  m_word [_l0393+xr*cfp_b]
        segment .data
_l0393:
        d_word cgn05
        d_word cgn08
        d_word cgn09
        d_word cgn10
        d_word cgn11
        d_word cgn08
        d_word cgn08
        segment .text
cgn05:
        mov  wb,cfp_b*cmopn
cgn06:
        call cmgen
        mov  wc,m_word [REL (cfp_b*cmlen)+xl]
        cmp  wb,wc
        jb   cgn06
        mov  wa,oaon_
        cmp  wc,cfp_b*cmar1
        je   cgn07
        mov  wa,oamn_
        call cdwrd
        mov  wa,wc
        shr  wa,log_cfp_b
        sub  wa,cmvls
cgn07:
        mov  wc,xs
        call cdwrd
        jmp  cgn03
cgn08:
        mov  xr,xl
        call cdgvl
        mov  wa,ofne_
        jmp  cgn07
cgn09:
        mov  xr,m_word [REL (cfp_b*cmrop)+xl]
        cmp  m_word [ xr],b_vr_
        ja   cgn02
        mov  xl,xr
        mov  wa,num01
        call cdgex
        mov  wa,olex_
        call cdwrd
        mov  wa,xr
        call cdwrd
        jmp  cgn03
cgn10:
        mov  xr,m_word [REL (cfp_b*cmrop)+xl]
        call cdgvl
        mov  wa,oinn_
        jmp  cgn12
cgn11:
        mov  xr,m_word [REL (cfp_b*cmrop)+xl]
        call cdgnm
        mov  wa,okwn_
cgn12:
        call cdwrd
        jmp  cgn03
cdgvl:
        mov  wa,m_word [ xr]
        cmp  wa,b_cmt
        je   cgv01
        cmp  wa,b_vra
        jb   cgv00
        cmp  m_word [REL (cfp_b*vrlen)+xr],0
        jnz  cgvl0
        push xr
        mov  xr,m_word [REL (cfp_b*vrsvp)+xr]
        mov  wa,m_word [REL (cfp_b*svbit)+xr]
        pop  xr
        and  wa,m_word [REL btkwv]
        cmp  wa,m_word [REL btkwv]
        je   cgv00
cgvl0:
        mov  wc,xs
cgv00:
        mov  wa,xr
        call cdwrd
        ret
cgv01:
        push wb
        push xl
        push wc
        push m_word [REL cwcof]
        cmp  xs,lowspmin
        jb   sec06
        mov  xl,xr
        mov  xr,m_word [REL (cfp_b*cmtyp)+xr]
        mov  wc,m_word [REL cswno]
        cmp  xr,c_pr_
        jbe  cgv02
        mov  wc,xs
cgv02:
        jmp  m_word [_l0394+xr*cfp_b]
        segment .data
_l0394:
        d_word cgv03
        d_word cgv05
        d_word cgv14
        d_word cgv31
        d_word cgv27
        d_word cgv29
        d_word cgv30
        d_word cgv18
        d_word cgv19
        d_word cgv18
        d_word cgv24
        d_word cgv24
        d_word cgv27
        d_word cgv26
        d_word cgv21
        d_word cgv31
        d_word cgv28
        d_word cgv15
        d_word cgv18
        segment .text
cgv03:
        mov  wb,cfp_b*cmopn
cgv04:
        call cmgen
        mov  wc,m_word [REL (cfp_b*cmlen)+xl]
        cmp  wb,wc
        jb   cgv04
        mov  wa,oaov_
        cmp  wc,cfp_b*cmar1
        je   cgv32
        mov  wa,oamv_
        call cdwrd
        mov  wa,wc
        sub  wa,cfp_b*cmvls
        shr  wa,log_cfp_b
        jmp  cgv32
cgv05:
        mov  wb,cfp_b*cmvls
cgv06:
        cmp  wb,m_word [REL (cfp_b*cmlen)+xl]
        je   cgv07
        call cmgen
        jmp  cgv06
cgv07:
        sub  wb,cfp_b*cmvls
        shr  wb,log_cfp_b
        mov  xr,m_word [REL (cfp_b*cmopn)+xl]
        cmp  m_word [REL (cfp_b*vrlen)+xr],0
        jnz  cgv12
        mov  xl,m_word [REL (cfp_b*vrsvp)+xr]
        mov  wa,m_word [REL (cfp_b*svbit)+xl]
        and  wa,m_word [REL btffc]
        or   wa,wa
        jz   cgv12
        mov  wa,m_word [REL (cfp_b*svbit)+xl]
        and  wa,m_word [REL btpre]
        or   wa,wa
        jnz  cgv08
        mov  wc,xs
cgv08:
        mov  xl,m_word [REL (cfp_b*vrfnc)+xr]
        mov  wa,m_word [REL (cfp_b*fargs)+xl]
        cmp  wa,wb
        je   cgv11
        cmp  wa,wb
        ja   cgv09
        sub  wb,wa
        mov  wa,opop_
        jmp  cgv10
cgv09:
        sub  wa,wb
        mov  wb,wa
        mov  wa,nulls
cgv10:
        call cdwrd
        dec  wb
        jnz  cgv10
cgv11:
        mov  wa,xl
        jmp  cgv36
cgv12:
        mov  wa,ofns_
        cmp  wb,num01
        je   cgv13
        mov  wa,ofnc_
        call cdwrd
        mov  wa,wb
cgv13:
        call cdwrd
        mov  wa,xr
        jmp  cgv32
cgv14:
        mov  xl,m_word [REL (cfp_b*cmrop)+xl]
        xor  wa,wa
        call cdgex
        mov  wa,xr
        call cdwrd
        jmp  cgv34
cgv15:
        push 0
        push 0
        mov  wb,cfp_b*cmvls
        mov  wa,osla_
cgv16:
        call cdwrd
        mov  w0,m_word [REL cwcof]
        mov  m_word [ xs],w0
        call cdwrd
        call cmgen
        mov  wa,oslb_
        call cdwrd
        mov  wa,m_word [REL (cfp_b*num01)+xs]
        mov  w0,m_word [REL cwcof]
        mov  m_word [REL (cfp_b*num01)+xs],w0
        call cdwrd
        mov  xr,m_word [ xs]
        add  xr,m_word [REL r_ccb]
        mov  w0,m_word [REL cwcof]
        mov  m_word [ xr],w0
        mov  wa,oslc_
        mov  xr,wb
        add  xr,cfp_b
        cmp  xr,m_word [REL (cfp_b*cmlen)+xl]
        jb   cgv16
        mov  wa,osld_
        call cdwrd
        call cmgen
        add  xs,cfp_b
        pop  xr
cgv17:
        add  xr,m_word [REL r_ccb]
        mov  wa,m_word [ xr]
        mov  w0,m_word [REL cwcof]
        mov  m_word [ xr],w0
        mov  xr,wa
        or   wa,wa
        jnz  cgv17
        jmp  cgv33
cgv18:
        mov  xr,m_word [REL (cfp_b*cmlop)+xl]
        call cdgvl
cgv19:
        mov  xr,m_word [REL (cfp_b*cmrop)+xl]
        call cdgvl
cgv20:
        mov  wa,m_word [REL (cfp_b*cmopn)+xl]
        jmp  cgv36
cgv21:
        mov  xr,m_word [REL (cfp_b*cmlop)+xl]
        cmp  m_word [ xr],b_vr_
        jb   cgv22
        mov  xr,m_word [REL (cfp_b*cmrop)+xl]
        call cdgvl
        mov  wa,m_word [REL (cfp_b*cmlop)+xl]
        add  wa,cfp_b*vrsto
        jmp  cgv32
cgv22:
        call expap
        dec  m_word [_rc_]
        js   call_214
        dec  m_word [_rc_]
        jns  _l0395
        jmp  cgv23
_l0395:
call_214:
        mov  w0,m_word [REL (cfp_b*cmrop)+xr]
        mov  m_word [REL (cfp_b*cmlop)+xl],w0
        mov  xr,m_word [REL (cfp_b*cmlop)+xr]
        call cdgnm
        mov  xr,m_word [REL (cfp_b*cmlop)+xl]
        call cdgvl
        mov  wa,opmn_
        call cdwrd
        mov  xr,m_word [REL (cfp_b*cmrop)+xl]
        call cdgvl
        mov  wa,orpl_
        jmp  cgv32
cgv23:
        mov  wc,xs
        call cdgnm
        jmp  cgv31
cgv24:
        mov  xr,m_word [REL (cfp_b*cmlop)+xl]
        cmp  m_word [ xr],b_cmt
        jne  cgv18
        mov  wb,m_word [REL (cfp_b*cmtyp)+xr]
        cmp  wb,c_int
        je   cgv25
        cmp  wb,c_neg
        je   cgv25
        cmp  wb,c_fnc
        jne  cgv18
        mov  xr,m_word [REL (cfp_b*cmopn)+xr]
        cmp  m_word [REL (cfp_b*vrlen)+xr],0
        jnz  cgv18
        mov  xr,m_word [REL (cfp_b*vrsvp)+xr]
        mov  wa,m_word [REL (cfp_b*svbit)+xr]
        and  wa,m_word [REL btprd]
        or   wa,wa
        jz   cgv18
cgv25:
        mov  xr,m_word [REL (cfp_b*cmlop)+xl]
        call cdgvl
        mov  wa,opop_
        call cdwrd
        mov  xr,m_word [REL (cfp_b*cmrop)+xl]
        call cdgvl
        jmp  cgv33
cgv26:
        mov  xr,m_word [REL (cfp_b*cmlop)+xl]
        call cdgvl
cgv27:
        mov  xr,m_word [REL (cfp_b*cmrop)+xl]
        call cdgnm
        mov  xr,m_word [REL (cfp_b*cmopn)+xl]
        cmp  m_word [ xr],o_kwv
        jne  cgv20
        or   wc,wc
        jnz  cgv20
        mov  wc,xs
        mov  xr,m_word [REL (cfp_b*cmrop)+xl]
        cmp  m_word [REL (cfp_b*vrlen)+xr],0
        jnz  cgv20
        mov  xr,m_word [REL (cfp_b*vrsvp)+xr]
        mov  wa,m_word [REL (cfp_b*svbit)+xr]
        and  wa,m_word [REL btckw]
        or   wa,wa
        jz   cgv20
        xor  wc,wc
        jmp  cgv20
cgv28:
        mov  wa,onta_
        call cdwrd
        mov  wb,m_word [REL cwcof]
        call cdwrd
        mov  xr,m_word [REL (cfp_b*cmrop)+xl]
        call cdgvl
        mov  wa,ontb_
        call cdwrd
        mov  xr,wb
        add  xr,m_word [REL r_ccb]
        mov  w0,m_word [REL cwcof]
        mov  m_word [ xr],w0
        mov  wa,ontc_
        jmp  cgv32
cgv29:
        mov  xr,m_word [REL (cfp_b*cmlop)+xl]
        call cdgvl
cgv30:
        mov  wb,c_uo_
        sub  wb,m_word [REL (cfp_b*cmtyp)+xl]
        mov  xr,m_word [REL (cfp_b*cmrop)+xl]
        call cdgvl
        mov  xr,m_word [REL (cfp_b*cmopn)+xl]
        mov  xr,m_word [REL (cfp_b*dvopn)+xr]
        sal  xr,log_cfp_b
        add  xr,r_uba
        sub  xr,cfp_b*vrfnc
        jmp  cgv12
cgv31:
        mov  wc,xs
        jmp  cgv19
cgv32:
        call cdwrd
cgv33:
        mov  wc,xs
cgv34:
        add  xs,cfp_b
        pop  wa
        pop  xl
        pop  wb
        or   wc,wc
        jnz  cgv35
        mov  wc,wa
cgv35:
        ret
cgv36:
        call cdwrd
        or   wc,wc
        jnz  cgv34
        mov  wa,orvl_
        call cdwrd
        mov  xl,m_word [ xs]
        call exbld
        xor  wb,wb
        call evalx
        dec  m_word [_rc_]
        js   call_215
        dec  m_word [_rc_]
        jns  _l0396
        mov  m_word [_rc_],299
        jmp  err_
_l0396:
call_215:
        mov  wa,m_word [ xr]
        cmp  wa,p_aaa
        jb   cgv37
        mov  wa,olpt_
        call cdwrd
cgv37:
        mov  wa,xr
        call cdwrd
        xor  wc,wc
        jmp  cgv34
cdwrd:
        push xr
        push wa
cdwd1:
        mov  xr,m_word [REL r_ccb]
        or   xr,xr
        jnz  cdwd2
        mov  wa,cfp_b*e_cbs
        call alloc
        mov  m_word [ xr],b_cct
        mov  m_word [REL cwcof],cfp_b*cccod
        mov  m_word [REL (cfp_b*cclen)+xr],wa
        mov  w0,0
        mov  m_word [REL (cfp_b*ccsln)+xr],w0
        mov  m_word [REL r_ccb],xr
cdwd2:
        mov  wa,m_word [REL cwcof]
        add  wa,cfp_b*num05
        cmp  wa,m_word [REL (cfp_b*cclen)+xr]
        jb   cdwd4
        cmp  wa,m_word [REL mxlen]
        jae  cdwd5
        add  wa,cfp_b*e_cbs
        push xl
        mov  xl,xr
        cmp  wa,m_word [REL mxlen]
        jb   cdwd3
        mov  wa,m_word [REL mxlen]
cdwd3:
        call alloc
        mov  m_word [REL r_ccb],xr
        mov  w0,b_cct
        stos_w
        mov  w0,wa
        stos_w
        mov  w0,m_word [REL (cfp_b*ccsln)+xl]
        stos_w
        add  xl,cfp_b*ccuse
        mov  wa,m_word [ xl]
        shr  wa,log_cfp_b
        rep  movs_w
        pop  xl
        jmp  cdwd1
cdwd4:
        mov  wa,m_word [REL cwcof]
        add  wa,cfp_b
        mov  m_word [REL cwcof],wa
        mov  m_word [REL (cfp_b*ccuse)+xr],wa
        sub  wa,cfp_b
        add  xr,wa
        pop  wa
        mov  m_word [ xr],wa
        pop  xr
        ret
cdwd5:
        mov  m_word [_rc_],213
        jmp  err_
cmgen:
        mov  xr,xl
        add  xr,wb
        mov  xr,m_word [ xr]
        call cdgvl
        add  wb,cfp_b
        ret
cmpil:
        mov  wb,cmnen
cmp00:
        push 0
        dec  wb
        jnz  cmp00
        mov  m_word [REL cmpxs],xs
cmp01:
        mov  wb,m_word [REL scnpt]
        mov  m_word [REL scnse],wb
        mov  wa,ocer_
        call cdwrd
        cmp  wb,m_word [REL scnil]
        jb   cmp04
cmpce:
        xor  xr,xr
        cmp  m_word [REL cnind],0
        jnz  cmpc2
        cmp  m_word [REL stage],stgic
        jne  cmp02
cmpc2:
        call readr
        or   xr,xr
        jz   cmp09
        call nexts
        mov  w0,m_word [REL cmpsn]
        mov  m_word [REL lstsn],w0
        mov  w0,m_word [REL rdcln]
        mov  m_word [REL cmpln],w0
        mov  w0,0
        mov  m_word [REL scnpt],w0
        jmp  cmp04
cmp02:
        mov  xr,m_word [REL r_cim]
        mov  wb,m_word [REL scnpt]
        lea  xr,[cfp_f+xr+wb]
cmp03:
        mov  w0,m_word [REL scnil]
        cmp  m_word [REL scnpt],w0
        jae  cmp09
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        inc  xr
        inc  m_word [REL scnpt]
        cmp  wc,ch_sm
        jne  cmp03
cmp04:
        mov  xr,m_word [REL r_cim]
        mov  wb,m_word [REL scnpt]
        mov  wa,wb
        lea  xr,[cfp_f+xr+wb]
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        inc  xr
        cmp  wc,ch_sm
        je   cmp12
        cmp  wc,ch_as
        je   cmpce
        cmp  wc,ch_mn
        je   cmp32
        mov  w0,m_word [REL r_cim]
        mov  m_word [REL r_cmp],w0
        mov  xl,cmlab
        mov  m_word [REL r_cim],xl
        add  xl,cfp_f
        mov  m_char [xl],wc_l
        inc  xl
        mov  wc,ch_sm
        mov  m_char [xl],wc_l
        xor  xl,xl
        mov  w0,0
        mov  m_word [REL scnpt],w0
        push m_word [REL scnil]
        mov  m_word [REL scnil],num02
        call scane
        pop  m_word [REL scnil]
        mov  wc,xl
        mov  xl,m_word [REL r_cmp]
        mov  m_word [REL r_cim],xl
        mov  m_word [REL scnpt],wb
        cmp  m_word [REL scnbl],0
        jnz  cmp12
        mov  xr,xl
        lea  xr,[cfp_f+xr+wb]
        cmp  wc,t_var
        je   cmp06
        cmp  wc,t_con
        je   cmp06
cmple:
        mov  w0,m_word [REL r_cmp]
        mov  m_word [REL r_cim],w0
        mov  m_word [_rc_],214
        jmp  err_
cmp05:
        cmp  wc,ch_sm
        je   cmp07
        inc  wa
        cmp  wa,m_word [REL scnil]
        je   cmp07
cmp06:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        inc  xr
        cmp  wc,ch_ht
        je   cmp07
        cmp  wc,ch_bl
        jne  cmp05
cmp07:
        mov  m_word [REL scnpt],wa
        sub  wa,wb
        or   wa,wa
        jz   cmp12
        xor  xr,xr
        call sbstr
        call gtnvr
        dec  m_word [_rc_]
        js   call_216
        dec  m_word [_rc_]
        jns  _l0397
        mov  m_word [_rc_],299
        jmp  err_
_l0397:
call_216:
        mov  m_word [REL (cfp_b*cmlbl)+xs],xr
        cmp  m_word [REL (cfp_b*vrlen)+xr],0
        jnz  cmp11
        cmp  m_word [REL (cfp_b*vrsvp)+xr],v_end
        jne  cmp11
        add  m_word [REL stage],stgnd
        call scane
        cmp  xl,t_smc
        je   cmp10
        cmp  xl,t_var
        jne  cmp08
        cmp  m_word [REL (cfp_b*vrlbl)+xr],stndl
        je   cmp08
        mov  w0,m_word [REL (cfp_b*vrlbl)+xr]
        mov  m_word [REL (cfp_b*cmtra)+xs],w0
        call scane
        cmp  xl,t_smc
        je   cmp10
cmp08:
        mov  m_word [_rc_],215
        jmp  err_
cmp09:
        xor  xr,xr
        add  m_word [REL stage],stgnd
        cmp  m_word [REL stage],stgxe
        je   cmp10
        mov  m_word [_rc_],216
        jmp  err_
cmp10:
        mov  wa,ostp_
        call cdwrd
        jmp  cmpse
cmp11:
        cmp  m_word [REL stage],stgic
        jne  cmp12
        cmp  m_word [REL (cfp_b*vrlbl)+xr],stndl
        je   cmp12
        mov  w0,0
        mov  m_word [REL (cfp_b*cmlbl)+xs],w0
        mov  m_word [_rc_],217
        jmp  err_
cmp12:
        xor  wb,wb
        call expan
        mov  m_word [REL (cfp_b*cmstm)+xs],xr
        mov  w0,0
        mov  m_word [REL (cfp_b*cmsgo)+xs],w0
        mov  w0,0
        mov  m_word [REL (cfp_b*cmfgo)+xs],w0
        mov  w0,0
        mov  m_word [REL (cfp_b*cmcgo)+xs],w0
        call scane
        cmp  xl,t_col
        je   cmp13
        cmp  m_word [REL cswno],0
        jnz  cmp18
        cmp  m_word [REL (cfp_b*cmlbl)+xs],0
        jnz  cmp18
        mov  xr,m_word [REL (cfp_b*cmstm)+xs]
        mov  wa,m_word [ xr]
        cmp  wa,b_cmt
        je   cmp18
        cmp  wa,b_vra
        jae  cmp18
        mov  xl,m_word [REL r_ccb]
        mov  m_word [REL (cfp_b*ccuse)+xl],cfp_b*cccod
        mov  m_word [REL cwcof],cfp_b*cccod
        inc  m_word [REL cmpsn]
        jmp  cmp01
cmp13:
        mov  m_word [REL scngo],xs
        call scane
        cmp  xl,t_smc
        je   cmp31
        cmp  xl,t_sgo
        je   cmp14
        cmp  xl,t_fgo
        je   cmp16
        mov  m_word [REL scnrs],xs
        call scngf
        cmp  m_word [REL (cfp_b*cmfgo)+xs],0
        jnz  cmp17
        mov  m_word [REL (cfp_b*cmfgo)+xs],xr
        jmp  cmp15
cmp14:
        call scngf
        mov  m_word [REL (cfp_b*cmcgo)+xs],num01
cmp15:
        cmp  m_word [REL (cfp_b*cmsgo)+xs],0
        jnz  cmp17
        mov  m_word [REL (cfp_b*cmsgo)+xs],xr
        jmp  cmp13
cmp16:
        call scngf
        mov  m_word [REL (cfp_b*cmcgo)+xs],num01
        cmp  m_word [REL (cfp_b*cmfgo)+xs],0
        jnz  cmp17
        mov  m_word [REL (cfp_b*cmfgo)+xs],xr
        jmp  cmp13
cmp17:
        mov  m_word [_rc_],218
        jmp  err_
cmp18:
        mov  w0,0
        mov  m_word [REL scnse],w0
        mov  xr,m_word [REL (cfp_b*cmstm)+xs]
        xor  wb,wb
        xor  wc,wc
        call expap
        dec  m_word [_rc_]
        js   call_217
        dec  m_word [_rc_]
        jns  _l0398
        jmp  cmp19
_l0398:
call_217:
        mov  m_word [REL (cfp_b*cmopn)+xr],opms_
        mov  m_word [REL (cfp_b*cmtyp)+xr],c_pmt
cmp19:
        call cdgvl
        mov  xr,m_word [REL (cfp_b*cmsgo)+xs]
        mov  wa,xr
        or   xr,xr
        jz   cmp21
        mov  w0,0
        mov  m_word [REL (cfp_b*cmsoc)+xs],w0
        cmp  xr,m_word [REL state]
        ja   cmp20
        add  wa,cfp_b*vrtra
        call cdwrd
        jmp  cmp22
cmp20:
        cmp  xr,m_word [REL (cfp_b*cmfgo)+xs]
        je   cmp22
        xor  wb,wb
        call cdgcg
        jmp  cmp22
cmp21:
        mov  w0,m_word [REL cwcof]
        mov  m_word [REL (cfp_b*cmsoc)+xs],w0
        mov  wa,ocer_
        call cdwrd
cmp22:
        mov  xr,m_word [REL (cfp_b*cmfgo)+xs]
        mov  wa,xr
        mov  w0,0
        mov  m_word [REL (cfp_b*cmffc)+xs],w0
        or   xr,xr
        jz   cmp23
        add  wa,cfp_b*vrtra
        cmp  xr,m_word [REL state]
        jb   cmpse
        mov  wb,m_word [REL cwcof]
        mov  wa,ogof_
        call cdwrd
        mov  wa,ofif_
        call cdwrd
        call cdgcg
        mov  wa,wb
        mov  wb,b_cdc
        jmp  cmp25
cmp23:
        mov  wa,ounf_
        mov  wc,m_word [REL cswfl]
        or   wc,m_word [REL (cfp_b*cmcgo)+xs]
        or   wc,wc
        jz   cmpse
        mov  m_word [REL (cfp_b*cmffc)+xs],xs
        mov  wa,ocer_
cmpse:
        mov  wb,b_cds
cmp25:
        mov  xr,m_word [REL r_ccb]
        mov  xl,m_word [REL (cfp_b*cmlbl)+xs]
        or   xl,xl
        jz   cmp26
        mov  w0,0
        mov  m_word [REL (cfp_b*cmlbl)+xs],w0
        mov  m_word [REL (cfp_b*vrlbl)+xl],xr
cmp26:
        mov  m_word [ xr],wb
        mov  m_word [REL (cfp_b*cdfal)+xr],wa
        mov  xl,xr
        mov  wb,m_word [REL (cfp_b*ccuse)+xr]
        mov  wc,m_word [REL (cfp_b*cclen)+xr]
        add  xl,wb
        sub  wc,wb
        mov  m_word [ xl],b_cct
        mov  m_word [REL (cfp_b*ccuse)+xl],cfp_b*cccod
        mov  m_word [REL cwcof],cfp_b*cccod
        mov  m_word [REL (cfp_b*cclen)+xl],wc
        mov  m_word [REL r_ccb],xl
        mov  w0,0
        mov  m_word [REL (cfp_b*ccsln)+xl],w0
        mov  w0,m_word [REL cmpln]
        mov  m_word [REL (cfp_b*cdsln)+xr],w0
        mov  w0,m_word [REL cmpsn]
        mov  m_word [REL (cfp_b*cdstm)+xr],w0
        inc  m_word [REL cmpsn]
        mov  xl,m_word [REL (cfp_b*cmpcd)+xs]
        cmp  m_word [REL (cfp_b*cmffp)+xs],0
        jz   cmp27
        mov  m_word [REL (cfp_b*cdfal)+xl],xr
cmp27:
        mov  wa,m_word [REL (cfp_b*cmsop)+xs]
        or   wa,wa
        jz   cmp28
        add  xl,wa
        mov  m_word [ xl],xr
        xor  xl,xl
cmp28:
        mov  w0,m_word [REL (cfp_b*cmffc)+xs]
        mov  m_word [REL (cfp_b*cmffp)+xs],w0
        mov  w0,m_word [REL (cfp_b*cmsoc)+xs]
        mov  m_word [REL (cfp_b*cmsop)+xs],w0
        mov  m_word [REL (cfp_b*cmpcd)+xs],xr
        cmp  m_word [REL (cfp_b*cmtra)+xs],0
        jnz  cmp29
        mov  m_word [REL (cfp_b*cmtra)+xs],xr
cmp29:
        cmp  m_word [REL stage],stgce
        jb   cmp01
        cmp  m_word [REL cswls],0
        jz   cmp30
        call listr
cmp30:
        mov  xr,m_word [REL (cfp_b*cmtra)+xs]
        add  xs,cfp_b*cmnen
        ret
cmp31:
        mov  wb,m_word [REL (cfp_b*cmfgo)+xs]
        or   wb,m_word [REL (cfp_b*cmsgo)+xs]
        or   wb,wb
        jnz  cmp18
        mov  m_word [_rc_],219
        jmp  err_
cmp32:
        inc  wb
        call cncrd
        mov  w0,0
        mov  m_word [REL scnse],w0
        jmp  cmpce
cncrd:
        mov  m_word [REL scnpt],wb
        mov  wa,ccnoc
        add  wa,(cfp_c-1)+cfp_c*0
        shr  wa,log_cfp_c
        mov  m_word [REL cnswc],wa
cnc01:
        mov  w0,m_word [REL scnil]
        cmp  m_word [REL scnpt],w0
        jae  cnc09
        mov  xr,m_word [REL r_cim]
        add  xr,cfp_f
        add  xr,m_word [REL scnpt]
        mov  w0,0
        mov  al,m_char [xr]
        mov  wa,w0
        inc  xr
        cmp  wa_l,'A'
        jb   _l0399
        cmp  wa_l,'Z'
        ja   _l0399
        add  wa_l,32
_l0399:
        cmp  wa,ch_li
        je   cnc07
cnc0a:
        mov  m_word [REL scncc],xs
        call scane
        mov  w0,0
        mov  m_word [REL scncc],w0
        or   xl,xl
        jnz  cnc06
        mov  wa,ccnoc
        cmp  m_word [REL (cfp_b*sclen)+xr],wa
        jb   cnc08
        mov  xl,xr
        xor  wb,wb
        call sbstr
        mov  wa,m_word [REL (cfp_b*sclen)+xr]
        call flstg
        mov  m_word [REL cnscc],xr
        mov  xr,ccnms
        xor  wb,wb
        mov  wc,cc_nc
cnc02:
        mov  xl,m_word [REL cnscc]
        mov  wa,m_word [REL cnswc]
        jmp  cnc04
cnc03:
        add  xr,cfp_b
        add  xl,cfp_b
cnc04:
        mov  w0,m_word [ xr]
        cmp  m_word [REL (cfp_b*schar)+xl],w0
        jnz  cnc05
        dec  wa
        jnz  cnc03
        mov  xl,wb
        cmp  xl,cc_nc
        jge  cnc08
        jmp  m_word [_l0400+xl*cfp_b]
        segment .data
_l0400:
        d_word cnc37
        d_word cnc10
        d_word cnc08
        d_word cnc11
        d_word cnc41
        d_word cnc12
        d_word cnc13
        d_word cnc14
        d_word cnc15
        d_word cnc41
        d_word cnc44
        d_word cnc16
        d_word cnc17
        d_word cnc18
        d_word cnc19
        d_word cnc20
        d_word cnc21
        d_word cnc22
        d_word cnc24
        d_word cnc25
        d_word cnc27
        d_word cnc28
        d_word cnc31
        d_word cnc32
        d_word cnc36
        segment .text
cnc05:
        add  xr,cfp_b
        dec  wa
        jnz  cnc05
        inc  wb
        dec  wc
        jnz  cnc02
        jmp  cnc08
cnc06:
        mov  m_word [_rc_],247
        jmp  err_
cnc07:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wa,w0
        inc  xr
        cmp  wa_l,'A'
        jb   _l0401
        cmp  wa_l,'Z'
        ja   _l0401
        add  wa_l,32
_l0401:
        cmp  wa,ch_ln
        jne  cnc0a
        mov  w0,0
        mov  al,m_char [xr]
        mov  wa,w0
        cmp  wa,ch_d0
        jb   cnc0a
        cmp  wa,ch_d9
        ja   cnc0a
        add  m_word [REL scnpt],num02
        call scane
        push xr
        call gtsmi
        dec  m_word [_rc_]
        js   call_218
        dec  m_word [_rc_]
        jns  _l0402
        jmp  cnc06
_l0402:
        dec  m_word [_rc_]
        jns  _l0403
        jmp  cnc06
_l0403:
call_218:
        mov  m_word [REL cswin],xr
cnc08:
        mov  wa,m_word [REL scnpt]
        call scane
        cmp  xl,t_cma
        je   cnc01
        mov  m_word [REL scnpt],wa
cnc09:
        ret
cnc10:
        mov  m_word [REL cswdb],xs
        jmp  cnc08
cnc11:
        call sysdm
        jmp  cnc09
cnc12:
        cmp  m_word [REL cswls],0
        jz   cnc09
        call prtps
        call listt
        jmp  cnc09
cnc13:
        mov  w0,0
        mov  m_word [REL cswer],w0
        jmp  cnc08
cnc14:
        mov  w0,0
        mov  m_word [REL cswex],w0
        jmp  cnc08
cnc15:
        mov  m_word [REL cswfl],xs
        jmp  cnc08
cnc16:
        mov  m_word [REL cswls],xs
        cmp  m_word [REL stage],stgic
        je   cnc08
        mov  w0,0
        mov  m_word [REL lstpf],w0
        call listr
        jmp  cnc08
cnc17:
        mov  m_word [REL cswer],xs
        jmp  cnc08
cnc18:
        mov  m_word [REL cswex],xs
        jmp  cnc08
cnc19:
        mov  w0,0
        mov  m_word [REL cswfl],w0
        jmp  cnc08
cnc20:
        mov  w0,0
        mov  m_word [REL cswls],w0
        jmp  cnc08
cnc21:
        mov  m_word [REL cswno],xs
        jmp  cnc08
cnc22:
        mov  w0,0
        mov  m_word [REL cswpr],w0
        jmp  cnc08
cnc24:
        mov  w0,0
        mov  m_word [REL cswno],w0
        jmp  cnc08
cnc25:
        mov  m_word [REL cswpr],xs
        jmp  cnc08
cnc27:
        mov  w0,0
        mov  m_word [REL cswdb],w0
        jmp  cnc08
cnc28:
        cmp  m_word [REL cswls],0
        jz   cnc09
        call scane
        mov  wc,num01
        cmp  xr,t_smc
        je   cnc29
        push xr
        call gtsmi
        dec  m_word [_rc_]
        js   call_219
        dec  m_word [_rc_]
        jns  _l0404
        jmp  cnc06
_l0404:
        dec  m_word [_rc_]
        jns  _l0405
        jmp  cnc06
_l0405:
call_219:
        or   wc,wc
        jnz  cnc29
        mov  wc,num01
cnc29:
        add  m_word [REL lstlc],wc
        mov  w0,m_word [REL lstnp]
        cmp  m_word [REL lstlc],w0
        jb   cnc30
        call prtps
        call listt
        jmp  cnc09
cnc30:
        call prtnl
        dec  wc
        jnz  cnc30
        jmp  cnc09
cnc31:
        mov  m_word [REL cnr_t],r_stl
        jmp  cnc33
cnc32:
        mov  m_word [REL r_stl],nulls
        mov  m_word [REL cnr_t],r_ttl
cnc33:
        mov  xr,nulls
        mov  m_word [REL cnttl],xs
        mov  wb,ccofs
        mov  wa,m_word [REL scnil]
        cmp  wa,wb
        jb   cnc34
        sub  wa,wb
        mov  xl,m_word [REL r_cim]
        call sbstr
cnc34:
        mov  xl,m_word [REL cnr_t]
        mov  m_word [ xl],xr
        cmp  xl,r_stl
        je   cnc09
        cmp  m_word [REL precl],0
        jnz  cnc09
        cmp  m_word [REL prich],0
        jz   cnc09
        mov  xl,m_word [REL (cfp_b*sclen)+xr]
        mov  wa,xl
        or   xl,xl
        jz   cnc35
        add  xl,num10
        cmp  xl,m_word [REL prlen]
        ja   cnc09
        add  wa,num04
cnc35:
        mov  m_word [REL lstpo],wa
        jmp  cnc09
cnc36:
        call systt
        jmp  cnc08
cnc37:
        call scane
        xor  wc,wc
        cmp  xl,t_smc
        je   cnc38
        push xr
        call gtsmi
        dec  m_word [_rc_]
        js   call_220
        dec  m_word [_rc_]
        jns  _l0406
        jmp  cnc06
_l0406:
        dec  m_word [_rc_]
        jns  _l0407
        jmp  cnc06
_l0407:
call_220:
cnc38:
        mov  m_word [REL kvcas],wc
        jmp  cnc09
cnc41:
        mov  m_word [REL scncc],xs
        call scane
        mov  w0,0
        mov  m_word [REL scncc],w0
        cmp  xl,t_con
        jne  cnc06
        cmp  m_word [ xr],b_scl
        jne  cnc06
        mov  m_word [REL r_ifn],xr
        mov  xl,m_word [REL r_inc]
        xor  wb,wb
        call tfind
        dec  m_word [_rc_]
        js   call_221
        dec  m_word [_rc_]
        jns  _l0408
        mov  m_word [_rc_],299
        jmp  err_
_l0408:
call_221:
        cmp  xr,inton
        je   cnc09
        mov  wb,xs
        mov  xr,m_word [REL r_ifn]
        call trimr
        mov  xl,m_word [REL r_inc]
        mov  wb,xs
        call tfind
        dec  m_word [_rc_]
        js   call_222
        dec  m_word [_rc_]
        jns  _l0409
        mov  m_word [_rc_],299
        jmp  err_
_l0409:
call_222:
        mov  m_word [REL (cfp_b*teval)+xl],inton
        inc  m_word [REL cnind]
        mov  wa,m_word [REL cnind]
        cmp  wa,ccinm
        ja   cnc42
        mov  xl,m_word [REL r_ifa]
        add  wa,vcvlb
        sal  wa,log_cfp_b
        add  xl,wa
        mov  w0,m_word [REL r_sfc]
        mov  m_word [ xl],w0
        mov  xl,wa
        ldi_ m_word [REL rdnln]
        call icbld
        add  xl,m_word [REL r_ifl]
        mov  m_word [ xl],xr
        mov  wa,m_word [REL cswin]
        mov  xl,m_word [REL r_ifn]
        call alocs
        call sysif
        dec  m_word [_rc_]
        js   call_223
        dec  m_word [_rc_]
        jns  _l0410
        jmp  cnc43
_l0410:
call_223:
        xor  wb,wb
        call trimr
        mov  m_word [REL r_sfc],xr
        ldi_ m_word [REL cmpsn]
        call icbld
        mov  xl,m_word [REL r_sfn]
        mov  wb,xs
        call tfind
        dec  m_word [_rc_]
        js   call_224
        dec  m_word [_rc_]
        jns  _l0411
        mov  m_word [_rc_],299
        jmp  err_
_l0411:
call_224:
        mov  w0,m_word [REL r_sfc]
        mov  m_word [REL (cfp_b*teval)+xl],w0
        mov  w0,0
        mov  m_word [REL rdnln],w0
        cmp  m_word [REL stage],stgic
        je   cnc09
        cmp  m_word [REL cnind],num01
        jne  cnc09
        mov  w0,m_word [REL r_cim]
        mov  m_word [REL r_ici],w0
        mov  w0,m_word [REL scnpt]
        mov  m_word [REL cnspt],w0
        mov  w0,m_word [REL scnil]
        mov  m_word [REL cnsil],w0
        jmp  cnc09
cnc42:
        mov  m_word [_rc_],284
        jmp  err_
cnc43:
        mov  m_word [REL dnamp],xr
        mov  m_word [_rc_],285
        jmp  err_
cnc44:
        call scane
        cmp  xl,t_con
        jne  cnc06
        cmp  m_word [ xr],b_icl
        jne  cnc06
        ldi_ m_word [REL (cfp_b*icval)+xr]
        sti_ w0
        or   w0,w0
        jle  cnc06
        cmp  m_word [REL stage],stgic
        je   cnc45
        sti_ m_word [REL cmpln]
        jmp  cnc46
cnc45:
        sbi_ m_word [REL intv1]
        sti_ m_word [REL rdnln]
cnc46:
        mov  m_word [REL scncc],xs
        call scane
        mov  w0,0
        mov  m_word [REL scncc],w0
        cmp  xl,t_smc
        je   cnc47
        cmp  xl,t_con
        jne  cnc06
        cmp  m_word [ xr],b_scl
        jne  cnc06
        call newfn
        jmp  cnc09
cnc47:
        dec  m_word [REL scnpt]
        jmp  cnc09
dffnc:
        cmp  m_word [ xl],b_efc
        jne  dffn1
        inc  m_word [REL (cfp_b*efuse)+xl]
dffn1:
        mov  wa,xr
        mov  xr,m_word [REL (cfp_b*vrfnc)+xr]
        cmp  m_word [ xr],b_efc
        jne  dffn2
        mov  wb,m_word [REL (cfp_b*efuse)+xr]
        dec  wb
        mov  m_word [REL (cfp_b*efuse)+xr],wb
        or   wb,wb
        jnz  dffn2
        call sysul
dffn2:
        mov  xr,wa
        mov  wa,xl
        cmp  xr,r_yyy
        jb   dffn3
        cmp  m_word [REL (cfp_b*vrlen)+xr],0
        jnz  dffn3
        mov  xl,m_word [REL (cfp_b*vrsvp)+xr]
        mov  wb,m_word [REL (cfp_b*svbit)+xl]
        and  wb,m_word [REL btfnc]
        or   wb,wb
        jz   dffn3
        mov  m_word [_rc_],248
        jmp  err_
dffn3:
        mov  m_word [REL (cfp_b*vrfnc)+xr],wa
        mov  xl,wa
        ret
dtach:
        mov  m_word [REL dtcnb],xl
        add  xl,wa
        mov  m_word [REL dtcnm],xl
dtch1:
        mov  xr,xl
dtch2:
        mov  xl,m_word [ xl]
        cmp  m_word [ xl],b_trt
        jne  dtch6
        mov  wa,m_word [REL (cfp_b*trtyp)+xl]
        cmp  wa,trtin
        je   dtch3
        cmp  wa,trtou
        je   dtch3
        add  xl,cfp_b*trnxt
        jmp  dtch1
dtch3:
        mov  w0,m_word [REL (cfp_b*trval)+xl]
        mov  m_word [ xr],w0
        mov  wa,xl
        mov  wb,xr
        mov  xl,m_word [REL (cfp_b*trtrf)+xl]
        or   xl,xl
        jz   dtch5
        cmp  m_word [ xl],b_trt
        jne  dtch5
dtch4:
        mov  xr,xl
        mov  xl,m_word [REL (cfp_b*trtrf)+xl]
        or   xl,xl
        jz   dtch5
        mov  wc,m_word [REL (cfp_b*ionmb)+xl]
        add  wc,m_word [REL (cfp_b*ionmo)+xl]
        cmp  wc,m_word [REL dtcnm]
        jne  dtch4
        mov  w0,m_word [REL (cfp_b*trtrf)+xl]
        mov  m_word [REL (cfp_b*trtrf)+xr],w0
dtch5:
        mov  xl,wa
        mov  xr,wb
        add  xl,cfp_b*trval
        jmp  dtch2
dtch6:
        mov  xr,m_word [REL dtcnb]
        call setvr
        ret
dtype:
        cmp  m_word [ xr],b_pdt
        je   dtyp1
        mov  xr,m_word [ xr]
        movzx xr,byte [xr-1]
        sal  xr,log_cfp_b
        mov  xr,m_word [REL scnmt+xr]
        ret
dtyp1:
        mov  xr,m_word [REL (cfp_b*pddfp)+xr]
        mov  xr,m_word [REL (cfp_b*dfnam)+xr]
        ret
dumpr:
        or   xr,xr
        jz   dmp28
        cmp  xr,num03
        ja   dmp29
        xor  xl,xl
        xor  wb,wb
        mov  m_word [REL dmarg],xr
        mov  w0,0
        mov  m_word [REL dnams],w0
        call gbcol
        call prtpg
        mov  xr,dmhdv
        call prtst
        call prtnl
        call prtnl
        mov  w0,0
        mov  m_word [REL dmvch],w0
        mov  wa,m_word [REL hshtb]
dmp00:
        mov  xr,wa
        add  wa,cfp_b
        sub  xr,cfp_b*vrnxt
dmp01:
        mov  xr,m_word [REL (cfp_b*vrnxt)+xr]
        or   xr,xr
        jz   dmp09
        mov  xl,xr
dmp02:
        mov  xl,m_word [REL (cfp_b*vrval)+xl]
        cmp  m_word [REL dmarg],num03
        je   dmp2a
        cmp  xl,nulls
        je   dmp01
dmp2a:
        cmp  m_word [ xl],b_trt
        je   dmp02
        mov  wc,xr
        add  xr,cfp_b*vrsof
        cmp  m_word [REL (cfp_b*sclen)+xr],0
        jnz  dmp03
        mov  xr,m_word [REL (cfp_b*vrsvo)+xr]
dmp03:
        mov  wb,xr
        mov  m_word [REL dmpsv],wa
        mov  wa,dmvch
dmp04:
        mov  m_word [REL dmpch],wa
        mov  xl,wa
        mov  xr,m_word [ xl]
        or   xr,xr
        jz   dmp08
        add  xr,cfp_b*vrsof
        cmp  m_word [REL (cfp_b*sclen)+xr],0
        jnz  dmp05
        mov  xr,m_word [REL (cfp_b*vrsvo)+xr]
dmp05:
        mov  xl,wb
        mov  wa,m_word [REL (cfp_b*sclen)+xl]
        add  xl,cfp_f
        cmp  wa,m_word [REL (cfp_b*sclen)+xr]
        ja   dmp06
        add  xr,cfp_f
        repe cmps_b
        mov  xl,0
        mov  xr,xl
        ja   dmp07
        jb   dmp08
        jmp  dmp08
dmp06:
        mov  wa,m_word [REL (cfp_b*sclen)+xr]
        add  xr,cfp_f
        repe cmps_b
        mov  xl,0
        mov  xr,xl
        ja   dmp07
        jb   dmp08
dmp07:
        mov  xl,m_word [REL dmpch]
        mov  wa,m_word [ xl]
        jmp  dmp04
dmp08:
        mov  xl,m_word [REL dmpch]
        mov  wa,m_word [REL dmpsv]
        mov  xr,wc
        mov  w0,m_word [ xl]
        mov  m_word [REL (cfp_b*vrget)+xr],w0
        mov  m_word [ xl],xr
        jmp  dmp01
dmp09:
        cmp  wa,m_word [REL hshte]
        jne  dmp00
dmp10:
        mov  xr,m_word [REL dmvch]
        or   xr,xr
        jz   dmp11
        mov  w0,m_word [ xr]
        mov  m_word [REL dmvch],w0
        call setvr
        mov  xl,xr
        mov  wa,cfp_b*vrval
        call prtnv
        jmp  dmp10
dmp11:
        call prtnl
        call prtnl
        mov  xr,dmhdk
        call prtst
        call prtnl
        call prtnl
        mov  xl,vdmkw
dmp12:
        lods_w
        mov  xr,w0
        or   xr,xr
        jz   dmp13
        cmp  xr,num01
        je   dmp12
        mov  wa,ch_am
        call prtch
        call prtst
        mov  wa,m_word [REL (cfp_b*svlen)+xr]
        add  wa,(cfp_b-1)+cfp_b*svchs
        and  wa,-cfp_b
        add  xr,wa
        mov  w0,m_word [ xr]
        mov  m_word [REL dmpkn],w0
        mov  xr,tmbeb
        call prtst
        mov  m_word [REL dmpsv],xl
        mov  xl,dmpkb
        mov  m_word [ xl],b_kvt
        mov  m_word [REL (cfp_b*kvvar)+xl],trbkv
        mov  wa,cfp_b*kvvar
        call acess
        dec  m_word [_rc_]
        js   call_225
        dec  m_word [_rc_]
        jns  _l0412
        mov  m_word [_rc_],299
        jmp  err_
_l0412:
call_225:
        call prtvl
        call prtnl
        mov  xl,m_word [REL dmpsv]
        jmp  dmp12
dmp13:
        cmp  m_word [REL dmarg],num01
        je   dmp27
        mov  xr,m_word [REL dnamb]
dmp14:
        cmp  xr,m_word [REL dnamp]
        je   dmp27
        mov  wa,m_word [ xr]
        cmp  wa,b_vct
        je   dmp16
        cmp  wa,b_art
        je   dmp17
        cmp  wa,b_pdt
        je   dmp18
        cmp  wa,b_tbt
        je   dmp19
dmp15:
        call blkln
        add  xr,wa
        jmp  dmp14
dmp16:
        mov  wb,cfp_b*vcvls
        jmp  dmp19
dmp17:
        mov  wb,m_word [REL (cfp_b*arofs)+xr]
        add  wb,cfp_b
        jmp  dmp19
dmp18:
        mov  wb,cfp_b*pdfld
dmp19:
        cmp  m_word [REL (cfp_b*idval)+xr],0
        jz   dmp15
        call blkln
        mov  xl,xr
        mov  m_word [REL dmpsv],wa
        mov  wa,wb
        call prtnl
        mov  m_word [REL dmpsa],wa
        call prtvl
        mov  wa,m_word [REL dmpsa]
        call prtnl
        cmp  m_word [ xr],b_tbt
        je   dmp22
        sub  wa,cfp_b
dmp20:
        mov  xr,xl
        add  wa,cfp_b
        add  xr,wa
        cmp  wa,m_word [REL dmpsv]
        je   dmp14
        sub  xr,cfp_b*vrval
dmp21:
        mov  xr,m_word [REL (cfp_b*vrval)+xr]
        cmp  m_word [REL dmarg],num03
        je   dmp2b
        cmp  xr,nulls
        je   dmp20
dmp2b:
        cmp  m_word [ xr],b_trt
        je   dmp21
        call prtnv
        jmp  dmp20
dmp22:
        mov  wc,cfp_b*tbbuk
        mov  wa,cfp_b*teval
dmp23:
        push xl
        add  xl,wc
        add  wc,cfp_b
        sub  xl,cfp_b*tenxt
dmp24:
        mov  xl,m_word [REL (cfp_b*tenxt)+xl]
        cmp  xl,m_word [ xs]
        je   dmp26
        mov  xr,xl
dmp25:
        mov  xr,m_word [REL (cfp_b*teval)+xr]
        cmp  xr,nulls
        je   dmp24
        cmp  m_word [ xr],b_trt
        je   dmp25
        mov  m_word [REL dmpsv],wc
        call prtnv
        mov  wc,m_word [REL dmpsv]
        jmp  dmp24
dmp26:
        pop  xl
        cmp  wc,m_word [REL (cfp_b*tblen)+xl]
        jne  dmp23
        mov  xr,xl
        add  xr,wc
        jmp  dmp14
dmp27:
        call prtpg
dmp28:
        ret
dmp29:
        call sysdm
        jmp  dmp28
ermsg:
        mov  wa,m_word [REL kvert]
        mov  xr,ermms
        call prtst
        call ertex
        add  wa,thsnd
        ldi_ wa
        mov  wb,m_word [REL profs]
        call prtin
        mov  xl,m_word [REL prbuf]
        lea  xl,[cfp_f+xl+wb]
        mov  wa,ch_bl
        mov  m_char [xl],wa_l
        xor  xl,xl
        mov  wa,xr
        mov  xr,ermns
        call prtst
        mov  xr,wa
        call prtst
        call prtis
        call prtis
        ret
ertex:
        mov  m_word [REL ertwa],wa
        mov  m_word [REL ertwb],wb
        call sysem
        mov  xl,xr
        mov  wa,m_word [REL (cfp_b*sclen)+xr]
        or   wa,wa
        jz   ert02
        xor  wb,wb
        call sbstr
        mov  m_word [REL r_etx],xr
ert01:
        mov  wb,m_word [REL ertwb]
        mov  wa,m_word [REL ertwa]
        ret
ert02:
        mov  xr,m_word [REL r_etx]
        jmp  ert01
evali:
        call evalp
        dec  m_word [_rc_]
        js   call_226
        dec  m_word [_rc_]
        jns  _l0413
        jmp  evli1
_l0413:
call_226:
        push xl
        mov  xl,m_word [REL (cfp_b*pthen)+xr]
        mov  m_word [REL evlio],xr
        mov  m_word [REL evlif],wc
        call gtsmi
        dec  m_word [_rc_]
        js   call_227
        dec  m_word [_rc_]
        jns  _l0414
        jmp  evli2
_l0414:
        dec  m_word [_rc_]
        jns  _l0415
        jmp  evli3
_l0415:
call_227:
        mov  m_word [REL evliv],xr
        mov  xr,evlin
        mov  m_word [ xr],p_len
        mov  m_word [REL (cfp_b*pthen)+xr],xl
        mov  m_word [_rc_],4
        ret
evli1:
        mov  m_word [_rc_],3
        ret
evli2:
        mov  m_word [_rc_],1
        ret
evli3:
        mov  m_word [_rc_],2
        ret
evalp:
        mov  xl,m_word [REL (cfp_b*parm1)+xr]
        cmp  m_word [ xl],b_exl
        je   evlp1
        mov  xl,m_word [REL (cfp_b*sevar)+xl]
        mov  xl,m_word [REL (cfp_b*vrval)+xl]
        mov  wa,m_word [ xl]
        cmp  wa,b_t__
        ja   evlp3
evlp1:
        cmp  xs,lowspmin
        jb   sec06
        push xr
        push wb
        push m_word [REL r_pms]
        push m_word [REL pmssl]
        push m_word [REL pmdfl]
        push m_word [REL pmhbs]
        mov  xr,m_word [REL (cfp_b*parm1)+xr]
evlp2:
        xor  wb,wb
        call evalx
        dec  m_word [_rc_]
        js   call_228
        dec  m_word [_rc_]
        jns  _l0416
        jmp  evlp4
_l0416:
call_228:
        mov  wa,m_word [ xr]
        cmp  wa,b_e__
        jb   evlp2
        mov  xl,xr
        pop  m_word [REL pmhbs]
        pop  m_word [REL pmdfl]
        pop  m_word [REL pmssl]
        pop  m_word [REL r_pms]
        pop  wb
        pop  xr
        mov  wc,xr
        mov  m_word [_rc_],0
        ret
evlp3:
        xor  wc,wc
        mov  m_word [_rc_],0
        ret
evlp4:
        pop  m_word [REL pmhbs]
        pop  m_word [REL pmdfl]
        pop  m_word [REL pmssl]
        pop  m_word [REL r_pms]
        add  xs,cfp_b*num02
        mov  m_word [_rc_],1
        ret
evals:
        call evalp
        dec  m_word [_rc_]
        js   call_229
        dec  m_word [_rc_]
        jns  _l0417
        jmp  evls1
_l0417:
call_229:
        push m_word [REL (cfp_b*pthen)+xr]
        push wb
        push xl
        xor  wb,wb
        xor  wc,wc
        mov  xl,p_brk
        call patst
        dec  m_word [_rc_]
        js   call_230
        dec  m_word [_rc_]
        jns  _l0418
        jmp  evls2
_l0418:
call_230:
        pop  wb
        pop  m_word [REL (cfp_b*pthen)+xr]
        mov  m_word [_rc_],3
        ret
evls1:
        mov  m_word [_rc_],2
        ret
evls2:
        add  xs,cfp_b*num02
        mov  m_word [_rc_],1
        ret
evalx:
        cmp  m_word [ xr],b_exl
        je   evlx2
        mov  xl,m_word [REL (cfp_b*sevar)+xr]
        mov  wa,cfp_b*vrval
        or   wb,wb
        jnz  evlx1
        call acess
        dec  m_word [_rc_]
        js   call_231
        dec  m_word [_rc_]
        jns  _l0419
        jmp  evlx9
_l0419:
call_231:
evlx1:
        mov  m_word [_rc_],0
        ret
evlx2:
        scp_ wc
        mov  wa,m_word [REL r_cod]
        sub  wc,wa
        push wa
        push wc
        push m_word [REL flptr]
        push wb
        push cfp_b*exflc
        mov  w0,m_word [REL flptr]
        mov  m_word [REL gtcef],w0
        mov  w0,m_word [REL r_cod]
        mov  m_word [REL r_gtc],w0
        mov  m_word [REL flptr],xs
        mov  m_word [REL r_cod],xr
        mov  w0,m_word [REL kvstn]
        mov  m_word [REL (cfp_b*exstm)+xr],w0
        add  xr,cfp_b*excod
        lcp_ xr
        cmp  m_word [REL stage],stgxt
        jne  evlx0
        mov  m_word [REL stage],stgee
evlx0:
        xor  xl,xl
        lcw_ xr
        jmp  m_word [ xr]
evlx3:
        pop  xr
        cmp  m_word [REL (cfp_b*num01)+xs],0
        jz   evlx5
        mov  m_word [_rc_],249
        jmp  err_
evlx4:
        pop  wa
        pop  xl
        cmp  m_word [REL (cfp_b*num01)+xs],0
        jnz  evlx5
        call acess
        dec  m_word [_rc_]
        js   call_232
        dec  m_word [_rc_]
        jns  _l0420
        jmp  evlx6
_l0420:
call_232:
evlx5:
        xor  wb,wb
        jmp  evlx7
evlx6:
        mov  wb,xs
evlx7:
        cmp  m_word [REL stage],stgee
        jne  evlx8
        mov  m_word [REL stage],stgxt
evlx8:
        add  xs,cfp_b*num02
        pop  m_word [REL flptr]
        pop  wc
        add  wc,m_word [ xs]
        pop  m_word [REL r_cod]
        lcp_ wc
        or   wb,wb
        jz   evlx1
evlx9:
        mov  m_word [_rc_],1
        ret
exbld:
        mov  wa,xl
        sub  wa,cfp_b*excod
        push wa
        mov  wa,m_word [REL cwcof]
        sub  wa,xl
        add  wa,cfp_b*exsi_
        call alloc
        push xr
        mov  m_word [REL (cfp_b*extyp)+xr],b_exl
        mov  w0,0
        mov  m_word [REL (cfp_b*exstm)+xr],w0
        mov  w0,m_word [REL cmpln]
        mov  m_word [REL (cfp_b*exsln)+xr],w0
        mov  m_word [REL (cfp_b*exlen)+xr],wa
        mov  m_word [REL (cfp_b*exflc)+xr],ofex_
        add  xr,cfp_b*exsi_
        mov  m_word [REL cwcof],xl
        add  xl,m_word [REL r_ccb]
        sub  wa,cfp_b*exsi_
        push wa
        shr  wa,log_cfp_b
        rep  movs_w
        pop  wa
        shr  wa,log_cfp_b
        mov  xl,m_word [ xs]
        add  xl,cfp_b*excod
        mov  wb,m_word [REL (cfp_b*num01)+xs]
exbl1:
        lods_w
        mov  xr,w0
        cmp  xr,osla_
        je   exbl3
        cmp  xr,onta_
        je   exbl3
        dec  wa
        jnz  exbl1
exbl2:
        pop  xr
        pop  xl
        ret
exbl3:
        sub  m_word [REL xl],wb
        lea  xl,[xl+cfp_b]
        dec  wa
        jnz  exbl4
exbl4:
        dec  wa
        jnz  exbl5
exbl5:
        lods_w
        mov  xr,w0
        cmp  xr,osla_
        je   exbl3
        cmp  xr,oslb_
        je   exbl3
        cmp  xr,oslc_
        je   exbl3
        cmp  xr,onta_
        je   exbl3
        dec  wa
        jnz  exbl5
        jmp  exbl2
expan:
        push 0
        xor  wa,wa
        xor  wc,wc
exp01:
        call scane
        add  xl,wa
        jmp  m_word [_l0421+xl*cfp_b]
        segment .data
_l0421:
        d_word exp27
        d_word exp27
        d_word exp04
        d_word exp06
        d_word exp06
        d_word exp04
        d_word exp08
        d_word exp08
        d_word exp09
        d_word exp02
        d_word exp05
        d_word exp11
        d_word exp10
        d_word exp10
        d_word exp04
        d_word exp03
        d_word exp03
        d_word exp04
        d_word exp03
        d_word exp03
        d_word exp04
        d_word exp05
        d_word exp05
        d_word exp26
        d_word exp02
        d_word exp05
        d_word exp12
        d_word exp02
        d_word exp05
        d_word exp18
        d_word exp02
        d_word exp05
        d_word exp19
        d_word exp02
        d_word exp05
        d_word exp19
        segment .text
exp02:
        mov  m_word [REL scnrs],xs
        mov  xr,nulls
exp03:
        push xr
        mov  wa,num02
        jmp  exp01
exp04:
        mov  m_word [REL scnrs],xs
        mov  xr,opdvc
        or   wb,wb
        jz   exp4a
        mov  xr,opdvp
exp4a:
        cmp  m_word [REL scnbl],0
        jnz  exp26
        mov  m_word [_rc_],220
        jmp  err_
exp05:
        mov  m_word [_rc_],221
        jmp  err_
exp06:
        mov  xl,num04
        xor  xr,xr
exp07:
        push xr
        push wc
        push wb
        cmp  xs,lowspmin
        jb   sec06
        xor  wa,wa
        mov  wb,xl
        mov  wc,num01
        jmp  exp01
exp08:
        mov  m_word [_rc_],222
        jmp  err_
exp09:
        pop  xr
        mov  xl,num03
        jmp  exp07
exp10:
        mov  xl,num05
        jmp  exp07
exp11:
        inc  wc
        call expdm
        push 0
        xor  wa,wa
        cmp  wb,num02
        ja   exp01
        mov  m_word [_rc_],223
        jmp  err_
exp12:
        cmp  wb,num01
        je   exp20
        cmp  wb,num05
        je   exp13
        cmp  wb,num04
        je   exp14
        mov  m_word [_rc_],224
        jmp  err_
exp13:
        mov  xl,c_fnc
        jmp  exp15
exp14:
        cmp  wc,num01
        je   exp17
        mov  xl,c_sel
exp15:
        call expdm
        mov  wa,wc
        add  wa,cmvls
        sal  wa,log_cfp_b
        call alloc
        mov  m_word [ xr],b_cmt
        mov  m_word [REL (cfp_b*cmtyp)+xr],xl
        mov  m_word [REL (cfp_b*cmlen)+xr],wa
        add  xr,wa
exp16:
        lea  xr,[xr-cfp_b]
        pop  m_word [xr]
        pop  wb
        dec  wc
        jnz  exp16
        sub  xr,cfp_b*cmvls
        pop  wc
        mov  w0,m_word [ xs]
        mov  m_word [REL (cfp_b*cmopn)+xr],w0
        mov  m_word [ xs],xr
        mov  wa,num02
        jmp  exp01
exp17:
        call expdm
        pop  xr
        pop  wb
        pop  wc
        mov  m_word [ xs],xr
        mov  wa,num02
        jmp  exp01
exp18:
        mov  xl,c_arr
        cmp  wb,num03
        je   exp15
        cmp  wb,num02
        je   exp20
        mov  m_word [_rc_],225
        jmp  err_
exp19:
        mov  m_word [REL scnrs],xs
        mov  xl,wb
        jmp  m_word [_l0422+xl*cfp_b]
        segment .data
_l0422:
        d_word exp20
        d_word exp22
        d_word exp23
        d_word exp24
        d_word exp21
        d_word exp21
        segment .text
exp20:
        call expdm
        pop  xr
        add  xs,cfp_b
        ret
exp21:
        mov  m_word [_rc_],226
        jmp  err_
exp22:
        mov  m_word [_rc_],227
        jmp  err_
exp23:
        mov  m_word [_rc_],228
        jmp  err_
exp24:
        mov  m_word [_rc_],229
        jmp  err_
exp25:
        mov  m_word [REL expsv],xr
        call expop
        mov  xr,m_word [REL expsv]
exp26:
        mov  xl,m_word [REL (cfp_b*num01)+xs]
        cmp  xl,num05
        jbe  exp27
        mov  w0,m_word [REL (cfp_b*dvlpr)+xl]
        cmp  m_word [REL (cfp_b*dvrpr)+xr],w0
        jb   exp25
exp27:
        push xr
        cmp  xs,lowspmin
        jb   sec06
        mov  wa,num01
        cmp  xr,opdvs
        jne  exp01
        xor  wa,wa
        jmp  exp01
expap:
        push xl
        cmp  m_word [ xr],b_cmt
        jne  expp2
        mov  wa,m_word [REL (cfp_b*cmtyp)+xr]
        cmp  wa,c_cnc
        je   expp1
        cmp  wa,c_pmt
        je   expp1
        cmp  wa,c_alt
        jne  expp2
        mov  xl,m_word [REL (cfp_b*cmlop)+xr]
        cmp  m_word [ xl],b_cmt
        jne  expp2
        cmp  m_word [REL (cfp_b*cmtyp)+xl],c_cnc
        jne  expp2
        mov  w0,m_word [REL (cfp_b*cmrop)+xl]
        mov  m_word [REL (cfp_b*cmlop)+xr],w0
        mov  m_word [REL (cfp_b*cmrop)+xl],xr
        mov  xr,xl
expp1:
        pop  xl
        mov  m_word [_rc_],0
        ret
expp2:
        pop  xl
        mov  m_word [_rc_],1
        ret
expdm:
        pop  m_word [prc_+cfp_b*3]
        mov  m_word [REL r_exs],xl
exdm1:
        cmp  m_word [REL (cfp_b*num01)+xs],num05
        jbe  exdm2
        call expop
        jmp  exdm1
exdm2:
        mov  xl,m_word [REL r_exs]
        mov  w0,0
        mov  m_word [REL r_exs],w0
        mov  m_word [_rc_],0
        mov  w0,m_word [prc_+cfp_b*3]
        jmp  w0
expop:
        pop  m_word [prc_+cfp_b*4]
        mov  xr,m_word [REL (cfp_b*num01)+xs]
        cmp  m_word [REL (cfp_b*dvlpr)+xr],lluno
        je   expo2
        mov  wa,cfp_b*cmbs_
        call alloc
        pop  m_word [REL (cfp_b*cmrop)+xr]
        pop  xl
        mov  w0,m_word [ xs]
        mov  m_word [REL (cfp_b*cmlop)+xr],w0
expo1:
        mov  m_word [ xr],b_cmt
        mov  w0,m_word [REL (cfp_b*dvtyp)+xl]
        mov  m_word [REL (cfp_b*cmtyp)+xr],w0
        mov  m_word [REL (cfp_b*cmopn)+xr],xl
        mov  m_word [REL (cfp_b*cmlen)+xr],wa
        mov  m_word [ xs],xr
        mov  m_word [_rc_],0
        mov  w0,m_word [prc_+cfp_b*4]
        jmp  w0
expo2:
        mov  wa,cfp_b*cmus_
        call alloc
        pop  m_word [REL (cfp_b*cmrop)+xr]
        mov  xl,m_word [ xs]
        jmp  expo1
filnm:
        push wb
        or   wc,wc
        jz   filn3
        mov  xl,m_word [REL r_sfn]
        or   xl,xl
        jz   filn3
        mov  wb,m_word [REL (cfp_b*tbbuk)+xl]
        cmp  wb,m_word [REL r_sfn]
        je   filn3
        push xr
        mov  xr,wb
        push wc
filn1:
        mov  xl,xr
        mov  xr,m_word [REL (cfp_b*tesub)+xl]
        ldi_ m_word [REL (cfp_b*icval)+xr]
        sti_ wc
        cmp  m_word [ xs],wc
        jb   filn2
        mov  wb,xl
        mov  xr,m_word [REL (cfp_b*tenxt)+xl]
        cmp  xr,m_word [REL r_sfn]
        jne  filn1
filn2:
        mov  xl,wb
        mov  xl,m_word [REL (cfp_b*teval)+xl]
        pop  wc
        pop  xr
        pop  wb
        ret
filn3:
        pop  wb
        mov  xl,nulls
        ret
flstg:
        cmp  m_word [REL kvcas],0
        jz   fst99
        push xl
        push xr
        call alocs
        mov  xl,m_word [ xs]
        push xr
        add  xl,cfp_f
        add  xr,cfp_f
        push 0
fst01:
        mov  w0,0
        mov  al,m_char [xl]
        mov  wa,w0
        inc  xl
        cmp  wa,ch_ua
        jb   fst02
        cmp  wa,ch_uz
        ja   fst02
        cmp  wa_l,'A'
        jb   _l0423
        cmp  wa_l,'Z'
        ja   _l0423
        add  wa_l,32
_l0423:
        mov  m_word [ xs],xs
fst02:
        mov  al,wa_l
        stos_b
        dec  wc
        jnz  fst01
        pop  xr
        or   xr,xr
        jnz  fst10
        pop  m_word [REL dnamp]
        pop  xr
        jmp  fst20
fst10:
        pop  xr
        add  xs,cfp_b
fst20:
        mov  wa,m_word [REL (cfp_b*sclen)+xr]
        pop  xl
fst99:
        ret
gbcol:
        cmp  m_word [REL dmvch],0
        jnz  gbc14
        mov  m_word [REL gbcfl],xs
        mov  m_word [REL gbsva],wa
        mov  m_word [REL gbsvb],wb
        mov  m_word [REL gbsvc],wc
        push xl
        scp_ wa
        sub  wa,m_word [REL r_cod]
        lcp_ wa
        or   wb,wb
        jz   gbc0a
        mov  w0,0
        mov  m_word [REL dnams],w0
gbc0a:
        mov  wa,m_word [REL dnamb]
        add  wa,m_word [REL dnams]
        mov  m_word [REL gbcsd],wa
        mov  xr,xs
        mov  wa,m_word [REL dnamb]
        mov  wb,m_word [REL dnamp]
        mov  wc,m_word [REL dname]
        call sysgc
        mov  xr,xs
        mov  xl,m_word [REL stbas]
        cmp  xl,xr
        jae  gbc00
        mov  xr,xl
        mov  xl,xs
gbc00:
        call gbcpf
        mov  xr,r_aaa
        mov  xl,r_yyy
        call gbcpf
        mov  wa,m_word [REL hshtb]
gbc01:
        mov  xl,wa
        add  wa,cfp_b
        mov  m_word [REL gbcnm],wa
gbc02:
        mov  xr,m_word [ xl]
        or   xr,xr
        jz   gbc03
        mov  xl,xr
        add  xr,cfp_b*vrval
        add  xl,cfp_b*vrnxt
        call gbcpf
        jmp  gbc02
gbc03:
        mov  wa,m_word [REL gbcnm]
        cmp  wa,m_word [REL hshte]
        jne  gbc01
        mov  xr,m_word [REL dnamb]
        xor  wb,wb
gbc04:
        cmp  xr,m_word [REL gbcsd]
        je   gbc4c
        mov  wa,m_word [ xr]
        test wa_l,1
        jne  gbc4b
        dec  wa
        mov  m_word [ xr],wa
        call blkln
        add  xr,wa
        jmp  gbc04
gbc4b:
        call blkln
        add  xr,wa
        add  wb,wa
        jmp  gbc04
gbc4c:
        mov  m_word [REL gbcsf],wb
        mov  wc,xr
        add  wc,m_word [REL gbsvb]
        mov  w0,0
        mov  m_word [REL gbcnm],w0
        mov  m_word [REL gbclm],gbcnm
        mov  m_word [REL gbcns],xr
gbc05:
        cmp  xr,m_word [REL dnamp]
        je   gbc07
        mov  wa,m_word [ xr]
        test wa_l,1
        jne  gbc07
gbc06:
        mov  xl,wa
        mov  wa,m_word [ xl]
        mov  m_word [ xl],wc
        test wa_l,1
        je   gbc06
        mov  m_word [ xr],wa
        call blkln
        add  xr,wa
        add  wc,wa
        jmp  gbc05
gbc07:
        mov  wa,xr
        mov  xl,m_word [REL gbclm]
        sub  wa,m_word [REL (cfp_b*num01)+xl]
        mov  m_word [REL (cfp_b*num01)+xl],wa
gbc08:
        cmp  xr,m_word [REL dnamp]
        je   gbc10
        mov  wa,m_word [ xr]
        test wa_l,1
        je   gbc09
        call blkln
        add  xr,wa
        jmp  gbc08
gbc09:
        sub  xr,cfp_b*num02
        mov  xl,m_word [REL gbclm]
        mov  m_word [ xl],xr
        mov  w0,0
        mov  m_word [ xr],w0
        mov  m_word [REL gbclm],xr
        mov  xl,xr
        add  xr,cfp_b*num02
        mov  m_word [REL (cfp_b*num01)+xl],xr
        jmp  gbc06
gbc10:
        mov  xr,m_word [REL gbcsd]
        add  xr,m_word [REL gbcns]
gbc11:
        mov  xl,m_word [REL gbcnm]
        or   xl,xl
        jz   gbc12
        lods_w
        mov  m_word [REL gbcnm],w0
        lods_w
        mov  wa,w0
        shr  wa,log_cfp_b
        rep  movs_w
        jmp  gbc11
gbc12:
        mov  m_word [REL dnamp],xr
        mov  wb,m_word [REL gbsvb]
        or   wb,wb
        jz   gbc13
        mov  xl,xr
        add  xr,wb
        mov  m_word [REL dnamp],xr
        mov  wa,xl
        sub  wa,m_word [REL dnamb]
        add  m_word [REL dnamb],wb
        shr  wa,log_cfp_b
        std
        lea  xl,[xl-cfp_b]
        lea  xr,[xr-cfp_b]
_l0424:
        or   wa,wa
        jz   _l0425
        movs_w
        dec  wa
        jmp  _l0424
_l0425:
        cld
gbc13:
        xor  xr,xr
        mov  m_word [REL gbcfl],xr
        mov  wa,m_word [REL dnamb]
        mov  wb,m_word [REL dnamp]
        mov  wc,m_word [REL dname]
        call sysgc
        sti_ m_word [REL gbcia]
        xor  xr,xr
        mov  wb,m_word [REL gbcsf]
        shr  wb,log_cfp_b
        ldi_ wb
        mli_ m_word [REL gbsed]
        iov_ gb13a
        mov  wb,m_word [REL dnamp]
        sub  wb,m_word [REL dnamb]
        shr  wb,log_cfp_b
        mov  m_word [REL gbcsf],wb
        sbi_ m_word [REL gbcsf]
        sti_ w0
        or   w0,w0
        jg   gb13a
        mov  xr,m_word [REL dnamp]
        sub  xr,m_word [REL dnamb]
gb13a:
        ldi_ m_word [REL gbcia]
        mov  wa,m_word [REL gbsva]
        mov  wb,m_word [REL gbsvb]
        scp_ wc
        add  wc,m_word [REL r_cod]
        lcp_ wc
        mov  wc,m_word [REL gbsvc]
        pop  xl
        inc  m_word [REL gbcnt]
        ret
gbc14:
        inc  m_word [REL errft]
        mov  m_word [_rc_],250
        jmp  err_
gbcpf:
        push 0
        push xl
gpf01:
        mov  xl,m_word [ xr]
        mov  wc,xr
        cmp  xl,m_word [REL dnamb]
        jb   gpf2a
        cmp  xl,m_word [REL dnamp]
        jae  gpf2a
        mov  wa,m_word [ xl]
        cmp  xl,m_word [REL gbcsd]
        jb   gpf1a
        mov  m_word [ xl],xr
        mov  m_word [ xr],wa
gpf1a:
        test wa_l,1
        jne  gpf03
gpf02:
        mov  xr,wc
gpf2a:
        add  xr,cfp_b
        cmp  xr,m_word [ xs]
        jne  gpf01
        pop  xl
        pop  xr
        or   xr,xr
        jnz  gpf2a
        ret
gpf03:
        cmp  xl,m_word [REL gbcsd]
        jae  gpf3a
        inc  m_word [ xl]
gpf3a:
        mov  xr,xl
        mov  xl,wa
        movzx xl,byte [xl-1]
        jmp  m_word [_l0426+xl*cfp_b]
        segment .data
_l0426:
        d_word gpf06
        d_word gpf19
        d_word gpf17
        d_word gpf02
        d_word gpf10
        d_word gpf10
        d_word gpf12
        d_word gpf12
        d_word gpf02
        d_word gpf02
        d_word gpf02
        d_word gpf08
        d_word gpf08
        d_word gpf02
        d_word gpf09
        d_word gpf02
        d_word gpf13
        d_word gpf16
        d_word gpf02
        d_word gpf07
        d_word gpf04
        d_word gpf02
        d_word gpf02
        d_word gpf02
        d_word gpf10
        d_word gpf11
        d_word gpf02
        d_word gpf14
        d_word gpf15
        segment .text
gpf04:
        mov  wa,m_word [REL (cfp_b*cmlen)+xr]
        mov  wb,cfp_b*cmtyp
gpf05:
        add  wa,xr
        add  xr,wb
        push wc
        push wa
        cmp  xs,lowspmin
        jb   sec06
        jmp  gpf01
gpf06:
        mov  wa,m_word [REL (cfp_b*arlen)+xr]
        mov  wb,m_word [REL (cfp_b*arofs)+xr]
        jmp  gpf05
gpf07:
        mov  wa,m_word [REL (cfp_b*ccuse)+xr]
        mov  wb,cfp_b*ccuse
        jmp  gpf05
gpf19:
        mov  wa,m_word [REL (cfp_b*cdlen)+xr]
        mov  wb,cfp_b*cdfal
        jmp  gpf05
gpf08:
        mov  wa,m_word [REL (cfp_b*offs2)+xr]
        mov  wb,cfp_b*offs3
        jmp  gpf05
gpf09:
        mov  wa,m_word [REL (cfp_b*xrlen)+xr]
        mov  wb,cfp_b*xrptr
        jmp  gpf05
gpf10:
        mov  wa,cfp_b*offs2
        mov  wb,cfp_b*offs1
        jmp  gpf05
gpf11:
        mov  wa,cfp_b*ffofs
        mov  wb,cfp_b*ffnxt
        jmp  gpf05
gpf12:
        mov  wa,cfp_b*parm2
        mov  wb,cfp_b*pthen
        jmp  gpf05
gpf13:
        mov  xl,m_word [REL (cfp_b*pddfp)+xr]
        mov  wa,m_word [REL (cfp_b*dfpdl)+xl]
        mov  wb,cfp_b*pdfld
        jmp  gpf05
gpf14:
        mov  wa,cfp_b*pfarg
        mov  wb,cfp_b*pfcod
        jmp  gpf05
gpf15:
        mov  wa,cfp_b*tesi_
        mov  wb,cfp_b*tesub
        jmp  gpf05
gpf16:
        mov  wa,cfp_b*trsi_
        mov  wb,cfp_b*trval
        jmp  gpf05
gpf17:
        mov  wa,m_word [REL (cfp_b*exlen)+xr]
        mov  wb,cfp_b*exflc
        jmp  gpf05
gtarr:
        mov  m_word [REL gtawa],wa
        mov  wa,m_word [ xr]
        cmp  wa,b_art
        je   gtar8
        cmp  wa,b_vct
        je   gtar8
        cmp  wa,b_tbt
        jne  gta9a
        push xr
        xor  xr,xr
        xor  wb,wb
gtar1:
        mov  xl,m_word [ xs]
        add  xl,m_word [REL (cfp_b*tblen)+xl]
        sub  xl,cfp_b*tbbuk
        mov  wa,xl
gtar2:
        mov  xl,wa
        sub  wa,cfp_b
gtar3:
        mov  xl,m_word [REL (cfp_b*tenxt)+xl]
        cmp  xl,m_word [ xs]
        je   gtar6
        mov  m_word [REL cnvtp],xl
gtar4:
        mov  xl,m_word [REL (cfp_b*teval)+xl]
        cmp  m_word [ xl],b_trt
        je   gtar4
        mov  wc,xl
        mov  xl,m_word [REL cnvtp]
        cmp  wc,nulls
        je   gtar3
        or   xr,xr
        jnz  gtar5
        inc  wb
        jmp  gtar3
gtar5:
        cmp  m_word [REL gtawa],0
        jz   gta5a
        mov  w0,m_word [REL (cfp_b*tesub)+xl]
        stos_w
        mov  w0,wc
        stos_w
        jmp  gtar3
gta5a:
        mov  w0,xl
        stos_w
        mov  w0,xl
        stos_w
        jmp  gtar3
gtar6:
        cmp  wa,m_word [ xs]
        jne  gtar2
        or   xr,xr
        jnz  gtar7
        or   wb,wb
        jz   gtar9
        mov  wa,wb
        add  wa,wb
        add  wa,arvl2
        sal  wa,log_cfp_b
        cmp  wa,m_word [REL mxlen]
        ja   gta9b
        call alloc
        mov  m_word [ xr],b_art
        mov  w0,0
        mov  m_word [REL (cfp_b*idval)+xr],w0
        mov  m_word [REL (cfp_b*arlen)+xr],wa
        mov  m_word [REL (cfp_b*arndm)+xr],num02
        ldi_ m_word [REL intv1]
        sti_ m_word [REL (cfp_b*arlbd)+xr]
        sti_ m_word [REL (cfp_b*arlb2)+xr]
        ldi_ m_word [REL intv2]
        sti_ m_word [REL (cfp_b*ardm2)+xr]
        ldi_ wb
        sti_ m_word [REL (cfp_b*ardim)+xr]
        mov  w0,0
        mov  m_word [REL (cfp_b*arpr2)+xr],w0
        mov  m_word [REL (cfp_b*arofs)+xr],cfp_b*arpr2
        mov  wb,xr
        add  xr,cfp_b*arvl2
        jmp  gtar1
gtar7:
        mov  xr,wb
        mov  m_word [ xs],wb
        ldi_ m_word [REL (cfp_b*ardim)+xr]
        mli_ m_word [REL intvh]
        adi_ m_word [REL intv2]
        call icbld
        push xr
        call gtstg
        dec  m_word [_rc_]
        js   call_233
        dec  m_word [_rc_]
        jns  _l0427
        mov  m_word [_rc_],299
        jmp  err_
_l0427:
call_233:
        mov  xl,xr
        pop  xr
        mov  m_word [REL (cfp_b*arpr2)+xr],xl
        sub  wa,num02
        lea  xl,[cfp_f+xl+wa]
        mov  wb,ch_cm
        mov  m_char [xl],wb_l
gtar8:
        mov  m_word [_rc_],0
        ret
gtar9:
        pop  xr
        mov  m_word [_rc_],1
        ret
gta9a:
        mov  m_word [_rc_],2
        ret
gta9b:
        mov  m_word [_rc_],260
        jmp  err_
gtcod:
        cmp  m_word [ xr],b_cds
        je   gtcd1
        cmp  m_word [ xr],b_cdc
        je   gtcd1
        push xr
        call gtstg
        dec  m_word [_rc_]
        js   call_234
        dec  m_word [_rc_]
        jns  _l0428
        jmp  gtcd2
_l0428:
call_234:
        mov  w0,m_word [REL flptr]
        mov  m_word [REL gtcef],w0
        mov  w0,m_word [REL r_cod]
        mov  m_word [REL r_gtc],w0
        mov  m_word [REL r_cim],xr
        mov  m_word [REL scnil],wa
        mov  w0,0
        mov  m_word [REL scnpt],w0
        mov  m_word [REL stage],stgxc
        mov  w0,m_word [REL cmpsn]
        mov  m_word [REL lstsn],w0
        inc  m_word [REL cmpln]
        call cmpil
        mov  m_word [REL stage],stgxt
        mov  w0,0
        mov  m_word [REL r_cim],w0
gtcd1:
        mov  m_word [_rc_],0
        ret
gtcd2:
        mov  m_word [_rc_],1
        ret
gtexp:
        cmp  m_word [ xr],b_e__
        jb   gtex1
        push xr
        call gtstg
        dec  m_word [_rc_]
        js   call_235
        dec  m_word [_rc_]
        jns  _l0429
        jmp  gtex2
_l0429:
call_235:
        mov  xl,xr
        lea  xl,[cfp_f+xl+wa]
        dec  xl
        mov  w0,0
        mov  al,m_char [xl]
        mov  xl,w0
        cmp  xl,ch_cl
        je   gtex2
        cmp  xl,ch_sm
        je   gtex2
        mov  m_word [REL r_cim],xr
        mov  w0,0
        mov  m_word [REL scnpt],w0
        mov  m_word [REL scnil],wa
        push wb
        xor  wb,wb
        mov  w0,m_word [REL flptr]
        mov  m_word [REL gtcef],w0
        mov  w0,m_word [REL r_cod]
        mov  m_word [REL r_gtc],w0
        mov  m_word [REL stage],stgev
        mov  m_word [REL scntp],t_uok
        call expan
        mov  w0,0
        mov  m_word [REL scnrs],w0
        pop  wa
        mov  w0,m_word [REL scnil]
        cmp  m_word [REL scnpt],w0
        jne  gtex2
        xor  wb,wb
        mov  xl,xr
        call cdgex
        mov  w0,0
        mov  m_word [REL r_cim],w0
        mov  m_word [REL stage],stgxt
gtex1:
        mov  m_word [_rc_],0
        ret
gtex2:
        mov  m_word [_rc_],1
        ret
gtint:
        cmp  m_word [ xr],b_icl
        je   gtin2
        mov  m_word [REL gtina],wa
        mov  m_word [REL gtinb],wb
        call gtnum
        dec  m_word [_rc_]
        js   call_236
        dec  m_word [_rc_]
        jns  _l0430
        jmp  gtin3
_l0430:
call_236:
        cmp  wa,b_icl
        je   gtin1
        lea  w0,[REL (cfp_b*rcval)+xr]
        call ldr_
        rti_
        jc   gtin3
        call icbld
gtin1:
        mov  wa,m_word [REL gtina]
        mov  wb,m_word [REL gtinb]
gtin2:
        mov  m_word [_rc_],0
        ret
gtin3:
        mov  m_word [_rc_],1
        ret
gtnum:
        mov  wa,m_word [ xr]
        cmp  wa,b_icl
        je   gtn34
        cmp  wa,b_rcl
        je   gtn34
        push xr
        push xr
        call gtstg
        dec  m_word [_rc_]
        js   call_237
        dec  m_word [_rc_]
        jns  _l0431
        jmp  gtn36
_l0431:
call_237:
        ldi_ m_word [REL intv0]
        or   wa,wa
        jz   gtn32
        mov  w0,0
        mov  m_word [REL gtnnf],w0
        sti_ m_word [REL gtnex]
        mov  w0,0
        mov  m_word [REL gtnsc],w0
        mov  w0,0
        mov  m_word [REL gtndf],w0
        mov  w0,0
        mov  m_word [REL gtnrd],w0
        lea  w0,[REL reav0]
        call ldr_
        add  xr,cfp_f
gtn01:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wb,w0
        inc  xr
        cmp  wb,ch_d0
        jb   gtn02
        cmp  wb,ch_d9
        jbe  gtn06
gtn02:
        cmp  wb,ch_bl
        jne  gtn03
gtna2:
        dec  wa
        jnz  gtn01
        jmp  gtn07
gtn03:
        cmp  wb,ch_pl
        je   gtn04
        cmp  wb,ch_ht
        je   gtna2
        cmp  wb,ch_mn
        jne  gtn12
        mov  m_word [REL gtnnf],xs
gtn04:
        dec  wa
        jnz  gtn05
        jmp  gtn36
gtn05:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wb,w0
        inc  xr
        cmp  wb,ch_d0
        jb   gtn08
        cmp  wb,ch_d9
        ja   gtn08
gtn06:
        sti_ m_word [REL gtnsi]
        sti_ w0
        imul w0,10
        jo   gtn35
        sub  wb,ch_d0
        sub  w0,wb
        ldi_ w0
        jo   gtn35
        mov  m_word [REL gtnrd],xs
        dec  wa
        jnz  gtn05
gtn07:
        cmp  m_word [REL gtnnf],0
        jnz  gtn32
        ngi_
        ino_ gtn32
        jmp  gtn36
gtn08:
        cmp  wb,ch_bl
        je   gtna9
        cmp  wb,ch_ht
        je   gtna9
        call itr_
        call ngr_
        jmp  gtn12
gtn09:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wb,w0
        inc  xr
        cmp  wb,ch_ht
        je   gtna9
        cmp  wb,ch_bl
        jne  gtn36
gtna9:
        dec  wa
        jnz  gtn09
        jmp  gtn07
gtn10:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wb,w0
        inc  xr
        cmp  wb,ch_d0
        jb   gtn12
        cmp  wb,ch_d9
        ja   gtn12
gtn11:
        sub  wb,ch_d0
        lea  w0,[REL reavt]
        call mlr_
        rov_ gtn36
        lea  w0,[REL gtnsr]
        call str_
        ldi_ wb
        call itr_
        lea  w0,[REL gtnsr]
        call adr_
        mov  w0,m_word [REL gtndf]
        add  m_word [REL gtnsc],w0
        mov  m_word [REL gtnrd],xs
        dec  wa
        jnz  gtn10
        jmp  gtn22
gtn12:
        cmp  wb,ch_dt
        jne  gtn13
        cmp  m_word [REL gtndf],0
        jnz  gtn36
        mov  m_word [REL gtndf],num01
        dec  wa
        jnz  gtn10
        jmp  gtn22
gtn13:
        cmp  wb,ch_le
        je   gtn15
        cmp  wb,ch_ld
        je   gtn15
        cmp  wb,ch_ue
        je   gtn15
        cmp  wb,ch_ud
        je   gtn15
gtn14:
        cmp  wb,ch_bl
        je   gtnb4
        cmp  wb,ch_ht
        je   gtnb4
        jmp  gtn36
gtnb4:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wb,w0
        inc  xr
        dec  wa
        jnz  gtn14
        jmp  gtn22
gtn15:
        mov  w0,0
        mov  m_word [REL gtnes],w0
        ldi_ m_word [REL intv0]
        mov  m_word [REL gtndf],xs
        dec  wa
        jnz  gtn16
        jmp  gtn36
gtn16:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wb,w0
        inc  xr
        cmp  wb,ch_pl
        je   gtn17
        cmp  wb,ch_mn
        jne  gtn19
        mov  m_word [REL gtnes],xs
gtn17:
        dec  wa
        jnz  gtn18
        jmp  gtn36
gtn18:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wb,w0
        inc  xr
gtn19:
        cmp  wb,ch_d0
        jb   gtn20
        cmp  wb,ch_d9
        ja   gtn20
        sti_ w0
        imul w0,10
        jo   gtn36
        sub  wb,ch_d0
        sub  w0,wb
        ldi_ w0
        jo   gtn36
        dec  wa
        jnz  gtn18
        jmp  gtn21
gtn20:
        cmp  wb,ch_bl
        je   gtnc0
        cmp  wb,ch_ht
        je   gtnc0
        jmp  gtn36
gtnc0:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wb,w0
        inc  xr
        dec  wa
        jnz  gtn20
gtn21:
        sti_ m_word [REL gtnex]
        cmp  m_word [REL gtnes],0
        jnz  gtn22
        ngi_
        iov_ gtn36
        sti_ m_word [REL gtnex]
gtn22:
        cmp  m_word [REL gtnrd],0
        jz   gtn36
        cmp  m_word [REL gtndf],0
        jz   gtn36
        ldi_ m_word [REL gtnsc]
        sbi_ m_word [REL gtnex]
        iov_ gtn36
        sti_ w0
        or   w0,w0
        jl   gtn26
        sti_ w0
        or   w0,w0
        js   gtn36
        sti_ wa
gtn23:
        cmp  wa,num10
        jbe  gtn24
        lea  w0,[REL reatt]
        call dvr_
        sub  wa,num10
        jmp  gtn23
gtn24:
        or   wa,wa
        jz   gtn30
        mov  wb,cfp_r
        mov  xr,reav1
        sal  wa,log_cfp_b
gtn25:
        add  xr,wa
        dec  wb
        jnz  gtn25
        lea  w0,[ xr]
        call dvr_
        jmp  gtn30
gtn26:
        ngi_
        iov_ gtn36
        sti_ w0
        or   w0,w0
        js   gtn36
        sti_ wa
gtn27:
        cmp  wa,num10
        jbe  gtn28
        lea  w0,[REL reatt]
        call mlr_
        rov_ gtn36
        sub  wa,num10
        jmp  gtn27
gtn28:
        or   wa,wa
        jz   gtn30
        mov  wb,cfp_r
        mov  xr,reav1
        sal  wa,log_cfp_b
gtn29:
        add  xr,wa
        dec  wb
        jnz  gtn29
        lea  w0,[ xr]
        call mlr_
        rov_ gtn36
gtn30:
        cmp  m_word [REL gtnnf],0
        jz   gtn31
        call ngr_
gtn31:
        call rcbld
        jmp  gtn33
gtn32:
        call icbld
gtn33:
        mov  wa,m_word [ xr]
        add  xs,cfp_b
gtn34:
        mov  m_word [_rc_],0
        ret
gtn35:
        dec  xr
        mov  w0,0
        mov  al,m_char [xr]
        mov  wb,w0
        mov  w0,0
        mov  al,m_char [xr]
        mov  wb,w0
        inc  xr
        ldi_ m_word [REL gtnsi]
        call itr_
        call ngr_
        jmp  gtn11
gtn36:
        pop  xr
        mov  m_word [_rc_],1
        ret
gtnvr:
        cmp  m_word [ xr],b_nml
        jne  gnv02
        mov  xr,m_word [REL (cfp_b*nmbas)+xr]
        cmp  xr,m_word [REL state]
        jb   gnv07
gnv01:
        mov  m_word [_rc_],1
        ret
gnv02:
        mov  m_word [REL gnvsa],wa
        mov  m_word [REL gnvsb],wb
        push xr
        call gtstg
        dec  m_word [_rc_]
        js   call_238
        dec  m_word [_rc_]
        jns  _l0432
        jmp  gnv01
_l0432:
call_238:
        or   wa,wa
        jz   gnv01
        call flstg
        push xl
        push xr
        mov  wb,xr
        add  wb,cfp_b*schar
        mov  m_word [REL gnvst],wb
        mov  wb,wa
        add  wb,(cfp_c-1)+cfp_c*0
        shr  wb,log_cfp_c
        mov  m_word [REL gnvnw],wb
        call hashs
        rmi_ m_word [REL hshnb]
        sti_ wc
        sal  wc,log_cfp_b
        add  wc,m_word [REL hshtb]
        sub  wc,cfp_b*vrnxt
gnv03:
        mov  xl,wc
        mov  xl,m_word [REL (cfp_b*vrnxt)+xl]
        or   xl,xl
        jz   gnv08
        mov  wc,xl
        cmp  m_word [REL (cfp_b*vrlen)+xl],0
        jnz  gnv04
        mov  xl,m_word [REL (cfp_b*vrsvp)+xl]
        sub  xl,cfp_b*vrsof
gnv04:
        cmp  wa,m_word [REL (cfp_b*vrlen)+xl]
        jne  gnv03
        add  xl,cfp_b*vrchs
        mov  wb,m_word [REL gnvnw]
        mov  xr,m_word [REL gnvst]
gnv05:
        mov  w0,m_word [ xl]
        cmp  m_word [ xr],w0
        jnz  gnv03
        add  xr,cfp_b
        add  xl,cfp_b
        dec  wb
        jnz  gnv05
        mov  xr,wc
gnv06:
        mov  wa,m_word [REL gnvsa]
        mov  wb,m_word [REL gnvsb]
        add  xs,cfp_b
        pop  xl
gnv07:
        mov  m_word [_rc_],0
        ret
gnv08:
        xor  xr,xr
        mov  m_word [REL gnvhe],wc
        cmp  wa,num09
        ja   gnv14
        mov  xl,wa
        sal  xl,log_cfp_b
        mov  xl,m_word [REL vsrch+xl]
gnv09:
        mov  m_word [REL gnvsp],xl
        lods_w
        mov  wc,w0
        lods_w
        mov  wb,w0
        cmp  wa,wb
        jne  gnv14
        mov  wb,m_word [REL gnvnw]
        mov  xr,m_word [REL gnvst]
gnv10:
        mov  w0,m_word [ xl]
        cmp  m_word [ xr],w0
        jnz  gnv11
        add  xr,cfp_b
        add  xl,cfp_b
        dec  wb
        jnz  gnv10
        xor  wc,wc
        mov  wa,cfp_b*vrsi_
        jmp  gnv15
gnv11:
        add  xl,cfp_b
        dec  wb
        jnz  gnv11
        shr  wc,svnbt
gnv12:
        mov  wb,m_word [REL bits1]
        and  wb,wc
        or   wb,wb
        jz   gnv13
        add  xl,cfp_b
gnv13:
        shr  wc,1
        or   wc,wc
        jnz  gnv12
        jmp  gnv09
gnv14:
        mov  wc,wa
        mov  wa,vrchs
        add  wa,m_word [REL gnvnw]
        sal  wa,log_cfp_b
gnv15:
        call alost
        mov  wb,xr
        mov  xl,stnvr
        mov  wa,cfp_b*vrlen
        shr  wa,log_cfp_b
        rep  movs_w
        mov  xl,m_word [REL gnvhe]
        mov  m_word [REL (cfp_b*vrnxt)+xl],wb
        mov  w0,wc
        stos_w
        mov  wa,m_word [REL gnvnw]
        sal  wa,log_cfp_b
        or   wc,wc
        jz   gnv16
        mov  xl,m_word [ xs]
        add  xl,cfp_b*schar
        shr  wa,log_cfp_b
        rep  movs_w
        mov  xr,wb
        jmp  gnv06
gnv16:
        mov  xl,m_word [REL gnvsp]
        mov  m_word [ xr],xl
        mov  xr,wb
        mov  wb,m_word [REL (cfp_b*svbit)+xl]
        add  xl,cfp_b*svchs
        add  xl,wa
        mov  wc,m_word [REL btknm]
        and  wc,wb
        or   wc,wc
        jz   gnv17
        add  xl,cfp_b
gnv17:
        mov  wc,m_word [REL btfnc]
        and  wc,wb
        or   wc,wc
        jz   gnv18
        mov  m_word [REL (cfp_b*vrfnc)+xr],xl
        add  xl,cfp_b*num02
gnv18:
        mov  wc,m_word [REL btlbl]
        and  wc,wb
        or   wc,wc
        jz   gnv19
        mov  m_word [REL (cfp_b*vrlbl)+xr],xl
        add  xl,cfp_b
gnv19:
        mov  wc,m_word [REL btval]
        and  wc,wb
        or   wc,wc
        jz   gnv06
        mov  w0,m_word [ xl]
        mov  m_word [REL (cfp_b*vrval)+xr],w0
        mov  m_word [REL (cfp_b*vrsto)+xr],b_vre
        jmp  gnv06
gtpat:
        cmp  m_word [ xr],p_aaa
        ja   gtpt5
        mov  m_word [REL gtpsb],wb
        push xr
        call gtstg
        dec  m_word [_rc_]
        js   call_239
        dec  m_word [_rc_]
        jns  _l0433
        jmp  gtpt2
_l0433:
call_239:
        or   wa,wa
        jnz  gtpt1
        mov  xr,ndnth
        jmp  gtpt4
gtpt1:
        mov  wb,p_str
        cmp  wa,num01
        jne  gtpt3
        add  xr,cfp_f
        mov  w0,0
        mov  al,m_char [xr]
        mov  wa,w0
        mov  xr,wa
        mov  wb,p_ans
        jmp  gtpt3
gtpt2:
        mov  wb,p_exa
        cmp  m_word [ xr],b_e__
        jb   gtpt3
        mov  m_word [_rc_],1
        ret
gtpt3:
        call pbild
gtpt4:
        mov  wb,m_word [REL gtpsb]
gtpt5:
        mov  m_word [_rc_],0
        ret
gtrea:
        mov  wa,m_word [ xr]
        cmp  wa,b_rcl
        je   gtre2
        call gtnum
        dec  m_word [_rc_]
        js   call_240
        dec  m_word [_rc_]
        jns  _l0434
        jmp  gtre3
_l0434:
call_240:
        cmp  wa,b_rcl
        je   gtre2
gtre1:
        ldi_ m_word [REL (cfp_b*icval)+xr]
        call itr_
        call rcbld
gtre2:
        mov  m_word [_rc_],0
        ret
gtre3:
        mov  m_word [_rc_],1
        ret
gtsmi:
        pop  m_word [prc_+cfp_b*5]
        pop  xr
        cmp  m_word [ xr],b_icl
        je   gtsm1
        call gtint
        dec  m_word [_rc_]
        js   call_241
        dec  m_word [_rc_]
        jns  _l0435
        jmp  gtsm2
_l0435:
call_241:
gtsm1:
        ldi_ m_word [REL (cfp_b*icval)+xr]
        sti_ w0
        or   w0,w0
        js   gtsm3
        sti_ wc
        cmp  wc,m_word [REL mxlen]
        ja   gtsm3
        mov  xr,wc
        mov  m_word [_rc_],0
        mov  w0,m_word [prc_+cfp_b*5]
        jmp  w0
gtsm2:
        mov  m_word [_rc_],1
        mov  w0,m_word [prc_+cfp_b*5]
        jmp  w0
gtsm3:
        mov  m_word [_rc_],2
        mov  w0,m_word [prc_+cfp_b*5]
        jmp  w0
gtstg:
        pop  m_word [prc_+cfp_b*6]
        pop  xr
        cmp  m_word [ xr],b_scl
        je   gts30
gts01:
        push xr
        push xl
        mov  m_word [REL gtsvb],wb
        mov  m_word [REL gtsvc],wc
        mov  wa,m_word [ xr]
        cmp  wa,b_icl
        je   gts05
        cmp  wa,b_rcl
        je   gts10
        cmp  wa,b_nml
        je   gts03
gts02:
        pop  xl
        pop  xr
        mov  m_word [_rc_],1
        mov  w0,m_word [prc_+cfp_b*6]
        jmp  w0
gts03:
        mov  xl,m_word [REL (cfp_b*nmbas)+xr]
        cmp  xl,m_word [REL state]
        ja   gts02
        add  xl,cfp_b*vrsof
        mov  wa,m_word [REL (cfp_b*sclen)+xl]
        or   wa,wa
        jnz  gts04
        mov  xl,m_word [REL (cfp_b*vrsvo)+xl]
        mov  wa,m_word [REL (cfp_b*svlen)+xl]
gts04:
        xor  wb,wb
        call sbstr
        jmp  gts29
gts05:
        ldi_ m_word [REL (cfp_b*icval)+xr]
        mov  m_word [REL gtssf],num01
        sti_ w0
        or   w0,w0
        jl   gts06
        ngi_
        mov  w0,0
        mov  m_word [REL gtssf],w0
gts06:
        mov  xr,m_word [REL gtswk]
        mov  wb,nstmx
        lea  xr,[cfp_f+xr+wb]
gts07:
        cvd_
        dec  xr
        mov  m_char [xr],wa_l
        dec  wb
        sti_ w0
        or   w0,w0
        jne  gts07
gts08:
        mov  wa,nstmx
        sub  wa,wb
        mov  xl,wa
        add  wa,m_word [REL gtssf]
        call alocs
        mov  wc,xr
        add  xr,cfp_f
        cmp  m_word [REL gtssf],0
        jz   gts09
        mov  wa,ch_mn
        mov  al,wa_l
        stos_b
gts09:
        mov  wa,xl
        mov  xl,m_word [REL gtswk]
        lea  xl,[cfp_f+xl+wb]
        rep
        movs_b
        mov  xr,wc
        jmp  gts29
gts10:
        lea  w0,[REL (cfp_b*rcval)+xr]
        call ldr_
        mov  w0,0
        mov  m_word [REL gtssf],w0
        call cpr_
        mov  al,byte [reg_fl]
        or   al,al
        je   gts31
        call cpr_
        mov  al,byte [reg_fl]
        or   al,al
        jge  gts11
        mov  m_word [REL gtssf],num01
        call ngr_
gts11:
        ldi_ m_word [REL intv0]
gts12:
        lea  w0,[REL gtsrs]
        call str_
        lea  w0,[REL reap1]
        call sbr_
        call cpr_
        mov  al,byte [reg_fl]
        or   al,al
        jge  gts13
        lea  w0,[REL gtsrs]
        call ldr_
        lea  w0,[REL reatt]
        call mlr_
        sbi_ m_word [REL intvt]
        jmp  gts12
gts13:
        lea  w0,[REL gtsrs]
        call ldr_
        lea  w0,[REL reav1]
        call sbr_
        call cpr_
        mov  al,byte [reg_fl]
        or   al,al
        jl   gts17
        lea  w0,[REL gtsrs]
        call ldr_
gts14:
        lea  w0,[REL reatt]
        call sbr_
        call cpr_
        mov  al,byte [reg_fl]
        or   al,al
        jl   gts15
        lea  w0,[REL gtsrs]
        call ldr_
        lea  w0,[REL reatt]
        call dvr_
        lea  w0,[REL gtsrs]
        call str_
        adi_ m_word [REL intvt]
        jmp  gts14
gts15:
        mov  xr,reav1
gts16:
        lea  w0,[REL gtsrs]
        call ldr_
        adi_ m_word [REL intv1]
        add  xr,cfp_b*cfp_r
        lea  w0,[ xr]
        call sbr_
        call cpr_
        mov  al,byte [reg_fl]
        or   al,al
        jge  gts16
        lea  w0,[REL gtsrs]
        call ldr_
        lea  w0,[ xr]
        call dvr_
        lea  w0,[REL gtsrs]
        call str_
gts17:
        lea  w0,[REL gtsrs]
        call ldr_
        lea  w0,[REL gtsrn]
        call adr_
        lea  w0,[REL gtsrs]
        call str_
        lea  w0,[REL reav1]
        call sbr_
        call cpr_
        mov  al,byte [reg_fl]
        or   al,al
        jl   gts18
        adi_ m_word [REL intv1]
        lea  w0,[REL gtsrs]
        call ldr_
        lea  w0,[REL reavt]
        call dvr_
        jmp  gts19
gts18:
        lea  w0,[REL gtsrs]
        call ldr_
gts19:
        mov  xl,cfp_s
        mov  m_word [REL gtses],ch_mn
        sti_ w0
        or   w0,w0
        jl   gts21
        sti_ wa
        cmp  wa,cfp_s
        jbe  gts20
        ldi_ wa
        ngi_
        mov  m_word [REL gtses],ch_pl
        jmp  gts21
gts20:
        sub  xl,wa
        ldi_ m_word [REL intv0]
gts21:
        mov  xr,m_word [REL gtswk]
        mov  wb,nstmx
        lea  xr,[cfp_f+xr+wb]
        sti_ w0
        or   w0,w0
        je   gts23
gts22:
        cvd_
        dec  xr
        mov  m_char [xr],wa_l
        dec  wb
        sti_ w0
        or   w0,w0
        jne  gts22
        mov  wa,m_word [REL gtses]
        dec  xr
        mov  m_char [xr],wa_l
        mov  wa,ch_le
        dec  xr
        mov  m_char [xr],wa_l
        sub  wb,num02
gts23:
        lea  w0,[REL gtssc]
        call mlr_
        rti_
        ngi_
gts24:
        or   xl,xl
        jz   gts27
        cvd_
        cmp  wa,ch_d0
        jne  gts26
        dec  xl
        jmp  gts24
gts25:
        cvd_
gts26:
        dec  xr
        mov  m_char [xr],wa_l
        dec  wb
        dec  xl
        or   xl,xl
        jnz  gts25
gts27:
        mov  wa,ch_dt
        dec  xr
        mov  m_char [xr],wa_l
        dec  wb
gts28:
        cvd_
        dec  xr
        mov  m_char [xr],wa_l
        dec  wb
        sti_ w0
        or   w0,w0
        jne  gts28
        jmp  gts08
gts29:
        pop  xl
        add  xs,cfp_b
        mov  wb,m_word [REL gtsvb]
        mov  wc,m_word [REL gtsvc]
gts30:
        mov  wa,m_word [REL (cfp_b*sclen)+xr]
        mov  m_word [_rc_],0
        mov  w0,m_word [prc_+cfp_b*6]
        jmp  w0
gts31:
        mov  xl,scre0
        mov  wa,num02
        xor  wb,wb
        call sbstr
        jmp  gts29
gtvar:
        cmp  m_word [ xr],b_nml
        jne  gtvr2
        mov  wa,m_word [REL (cfp_b*nmofs)+xr]
        mov  xl,m_word [REL (cfp_b*nmbas)+xr]
        cmp  m_word [ xl],b_evt
        je   gtvr1
        cmp  m_word [ xl],b_kvt
        jne  gtvr3
gtvr1:
        mov  m_word [_rc_],1
        ret
gtvr2:
        mov  m_word [REL gtvrc],wc
        call gtnvr
        dec  m_word [_rc_]
        js   call_242
        dec  m_word [_rc_]
        jns  _l0437
        jmp  gtvr1
_l0437:
call_242:
        mov  xl,xr
        mov  wa,cfp_b*vrval
        mov  wc,m_word [REL gtvrc]
gtvr3:
        cmp  xl,m_word [REL state]
        ja   gtvr4
        cmp  m_word [REL (cfp_b*vrsto)+xl],b_vre
        je   gtvr1
gtvr4:
        mov  m_word [_rc_],0
        ret
hashs:
        mov  wc,e_hnw
        or   wc,wc
        jz   hshsa
        mov  wc,m_word [REL (cfp_b*sclen)+xr]
        mov  wb,wc
        or   wc,wc
        jz   hshs3
        nop
        add  wc,(cfp_c-1)+cfp_c*0
        shr  wc,log_cfp_c
        add  xr,cfp_b*schar
        cmp  wc,e_hnw
        jb   hshs1
        mov  wc,e_hnw
hshs1:
hshs2:
        xor  wb,m_word [REL xr]
        lea  xr,[xr+cfp_b]
        dec  wc
        jnz  hshs2
hshs3:
        nop
        and  wb,m_word [REL bitsm]
        ldi_ wb
        xor  xr,xr
        ret
hshsa:
        mov  wc,m_word [REL (cfp_b*sclen)+xr]
        mov  wb,wc
        or   wc,wc
        jz   hshs3
        nop
        add  wc,(cfp_c-1)+cfp_c*0
        shr  wc,log_cfp_c
        add  xr,cfp_f
        push xl
        mov  xl,wc
        cmp  xl,num25
        jae  hsh24
        jmp  m_word [_l0438+xl*cfp_b]
        segment .data
_l0438:
        d_word hsh00
        d_word hsh01
        d_word hsh02
        d_word hsh03
        d_word hsh04
        d_word hsh05
        d_word hsh06
        d_word hsh07
        d_word hsh08
        d_word hsh09
        d_word hsh10
        d_word hsh11
        d_word hsh12
        d_word hsh13
        d_word hsh14
        d_word hsh15
        d_word hsh16
        d_word hsh17
        d_word hsh18
        d_word hsh19
        d_word hsh20
        d_word hsh21
        d_word hsh22
        d_word hsh23
        d_word hsh24
        segment .text
hsh24:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        inc  xr
        shl  wc,24
        xor  wb,wc
hsh23:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        inc  xr
        shl  wc,16
        xor  wb,wc
hsh22:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        inc  xr
        shl  wc,8
        xor  wb,wc
hsh21:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        inc  xr
        xor  wb,wc
hsh20:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        inc  xr
        shl  wc,24
        xor  wb,wc
hsh19:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        inc  xr
        shl  wc,16
        xor  wb,wc
hsh18:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        inc  xr
        shl  wc,8
        xor  wb,wc
hsh17:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        inc  xr
        xor  wb,wc
hsh16:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        inc  xr
        shl  wc,24
        xor  wb,wc
hsh15:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        inc  xr
        shl  wc,16
        xor  wb,wc
hsh14:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        inc  xr
        shl  wc,8
        xor  wb,wc
hsh13:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        inc  xr
        xor  wb,wc
hsh12:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        inc  xr
        shl  wc,24
        xor  wb,wc
hsh11:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        inc  xr
        shl  wc,16
        xor  wb,wc
hsh10:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        inc  xr
        shl  wc,8
        xor  wb,wc
hsh09:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        inc  xr
        xor  wb,wc
hsh08:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        inc  xr
        shl  wc,24
        xor  wb,wc
hsh07:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        inc  xr
        shl  wc,16
        xor  wb,wc
hsh06:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        inc  xr
        shl  wc,8
        xor  wb,wc
hsh05:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        inc  xr
        xor  wb,wc
hsh04:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        inc  xr
        shl  wc,24
        xor  wb,wc
hsh03:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        inc  xr
        shl  wc,16
        xor  wb,wc
hsh02:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        inc  xr
        shl  wc,8
        xor  wb,wc
hsh01:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        inc  xr
        xor  wb,wc
hsh00:
        pop  xl
        jmp  hshs3
icbld:
        sti_ w0
        or   w0,w0
        js   icbl1
        sti_ xr
        cmp  xr,num02
        jbe  icbl3
icbl1:
        mov  xr,m_word [REL dnamp]
        add  xr,cfp_b*icsi_
        cmp  xr,m_word [REL dname]
        jb   icbl2
        mov  wa,cfp_b*icsi_
        call alloc
        add  xr,wa
icbl2:
        mov  m_word [REL dnamp],xr
        sub  xr,cfp_b*icsi_
        mov  m_word [ xr],b_icl
        sti_ m_word [REL (cfp_b*icval)+xr]
        ret
icbl3:
        sal  xr,log_cfp_b
        mov  xr,m_word [REL intab+xr]
        ret
ident:
        cmp  xr,xl
        je   iden7
        mov  wc,m_word [ xr]
        cmp  wc,m_word [ xl]
        jne  iden1
        cmp  wc,b_scl
        je   iden2
        cmp  wc,b_icl
        je   iden4
        cmp  wc,b_rcl
        je   iden5
        cmp  wc,b_nml
        je   iden6
iden1:
        mov  m_word [_rc_],0
        ret
iden2:
        mov  wc,m_word [REL (cfp_b*sclen)+xr]
        cmp  wc,m_word [REL (cfp_b*sclen)+xl]
        jne  iden1
idn2a:
        add  xr,cfp_b*schar
        add  xl,cfp_b*schar
        add  wc,(cfp_c-1)+cfp_c*0
        shr  wc,log_cfp_c
iden3:
        mov  w0,m_word [ xl]
        cmp  m_word [ xr],w0
        jnz  iden8
        add  xr,cfp_b
        add  xl,cfp_b
        dec  wc
        jnz  iden3
        xor  xl,xl
        xor  xr,xr
        mov  m_word [_rc_],1
        ret
iden4:
        ldi_ m_word [REL (cfp_b*icval)+xr]
        sbi_ m_word [REL (cfp_b*icval)+xl]
        iov_ iden1
        sti_ w0
        or   w0,w0
        jne  iden1
        mov  m_word [_rc_],1
        ret
iden5:
        lea  w0,[REL (cfp_b*rcval)+xr]
        call ldr_
        lea  w0,[REL (cfp_b*rcval)+xl]
        call sbr_
        rov_ iden1
        call cpr_
        mov  al,byte [reg_fl]
        or   al,al
        jne  iden1
        mov  m_word [_rc_],1
        ret
iden6:
        mov  w0,m_word [REL (cfp_b*nmofs)+xl]
        cmp  m_word [REL (cfp_b*nmofs)+xr],w0
        jne  iden1
        mov  w0,m_word [REL (cfp_b*nmbas)+xl]
        cmp  m_word [REL (cfp_b*nmbas)+xr],w0
        jne  iden1
iden7:
        mov  m_word [_rc_],1
        ret
iden8:
        xor  xr,xr
        xor  xl,xl
        mov  m_word [_rc_],0
        ret
inout:
        push wb
        mov  wa,m_word [REL (cfp_b*sclen)+xl]
        xor  wb,wb
        call sbstr
        call gtnvr
        dec  m_word [_rc_]
        js   call_243
        dec  m_word [_rc_]
        jns  _l0439
        mov  m_word [_rc_],299
        jmp  err_
_l0439:
call_243:
        mov  wc,xr
        pop  wb
        xor  xl,xl
        call trbld
        mov  xl,wc
        mov  w0,m_word [REL (cfp_b*vrsvp)+xl]
        mov  m_word [REL (cfp_b*trter)+xr],w0
        mov  m_word [REL (cfp_b*vrval)+xl],xr
        mov  m_word [REL (cfp_b*vrget)+xl],b_vra
        mov  m_word [REL (cfp_b*vrsto)+xl],b_vrv
        ret
insta:
        mov  wc,m_word [REL prlen]
        mov  m_word [REL prbuf],xr
        mov  w0,b_scl
        stos_w
        mov  w0,wc
        stos_w
        add  wc,(cfp_c-1)+cfp_c*0
        shr  wc,log_cfp_c
        mov  m_word [REL prlnw],wc
inst1:
        mov  w0,m_word [REL nullw]
        stos_w
        dec  wc
        jnz  inst1
        mov  wa,nstmx
        add  wa,(cfp_b-1)+cfp_b*scsi_
        and  wa,-cfp_b
        mov  m_word [REL gtswk],xr
        add  xr,wa
        mov  m_word [REL kvalp],xr
        mov  m_word [ xr],b_scl
        mov  wc,cfp_a
        mov  m_word [REL (cfp_b*sclen)+xr],wc
        mov  wb,wc
        add  wb,(cfp_b-1)+cfp_b*scsi_
        and  wb,-cfp_b
        add  wb,xr
        mov  wa,wb
        add  xr,cfp_f
        xor  wb,wb
inst2:
        mov  al,wb_l
        stos_b
        inc  wb
        dec  wc
        jnz  inst2
        mov  xr,wa
        ret
iofcb:
        pop  m_word [prc_+cfp_b*7]
        call gtstg
        dec  m_word [_rc_]
        js   call_244
        dec  m_word [_rc_]
        jns  _l0440
        jmp  iofc2
_l0440:
call_244:
        mov  xl,xr
        call gtnvr
        dec  m_word [_rc_]
        js   call_245
        dec  m_word [_rc_]
        jns  _l0441
        jmp  iofc3
_l0441:
call_245:
        mov  wb,xl
        mov  xl,xr
        xor  wa,wa
iofc1:
        mov  xr,m_word [REL (cfp_b*vrval)+xr]
        cmp  m_word [ xr],b_trt
        jne  iofc4
        cmp  m_word [REL (cfp_b*trtyp)+xr],trtfc
        jne  iofc1
        mov  wa,m_word [REL (cfp_b*trfpt)+xr]
        mov  xr,wb
        mov  m_word [_rc_],0
        mov  w0,m_word [prc_+cfp_b*7]
        jmp  w0
iofc2:
        mov  m_word [_rc_],1
        mov  w0,m_word [prc_+cfp_b*7]
        jmp  w0
iofc3:
        mov  m_word [_rc_],2
        mov  w0,m_word [prc_+cfp_b*7]
        jmp  w0
iofc4:
        mov  m_word [_rc_],3
        mov  w0,m_word [prc_+cfp_b*7]
        jmp  w0
ioppf:
        pop  m_word [prc_+cfp_b*8]
        xor  wb,wb
iopp1:
        mov  xl,iodel
        mov  wc,xl
        xor  wa,wa
        call xscan
        push xr
        inc  wb
        or   wa,wa
        jnz  iopp1
        mov  wc,wb
        mov  wb,m_word [REL ioptt]
        mov  wa,m_word [REL r_iof]
        mov  xr,m_word [REL r_io2]
        mov  xl,m_word [REL r_io1]
        mov  m_word [_rc_],0
        mov  w0,m_word [prc_+cfp_b*8]
        jmp  w0
ioput:
        pop  m_word [prc_+cfp_b*9]
        mov  w0,0
        mov  m_word [REL r_iot],w0
        mov  w0,0
        mov  m_word [REL r_iof],w0
        mov  w0,0
        mov  m_word [REL r_iop],w0
        mov  m_word [REL ioptt],wb
        call xscni
        dec  m_word [_rc_]
        js   call_246
        dec  m_word [_rc_]
        jns  _l0442
        jmp  iop13
_l0442:
        dec  m_word [_rc_]
        jns  _l0443
        jmp  iopa0
_l0443:
call_246:
iopa0:
        mov  m_word [REL r_io2],xr
        mov  xl,wa
        call gtstg
        dec  m_word [_rc_]
        js   call_247
        dec  m_word [_rc_]
        jns  _l0444
        jmp  iop14
_l0444:
call_247:
        mov  m_word [REL r_io1],xr
        call gtnvr
        dec  m_word [_rc_]
        js   call_248
        dec  m_word [_rc_]
        jns  _l0445
        jmp  iop00
_l0445:
call_248:
        jmp  iop04
iop00:
        or   xl,xl
        jz   iop01
        call ioppf
        call sysfc
        dec  m_word [_rc_]
        js   call_249
        dec  m_word [_rc_]
        jns  _l0446
        jmp  iop16
_l0446:
        dec  m_word [_rc_]
        jns  _l0447
        jmp  iop26
_l0447:
call_249:
        jmp  iop11
iop01:
        mov  wb,m_word [REL ioptt]
        mov  xr,m_word [REL r_iot]
        call trbld
        mov  wc,xr
        pop  xr
        push wc
        call gtvar
        dec  m_word [_rc_]
        js   call_250
        dec  m_word [_rc_]
        jns  _l0448
        jmp  iop15
_l0448:
call_250:
        pop  wc
        mov  m_word [REL r_ion],xl
        mov  xr,xl
        add  xr,wa
        sub  xr,cfp_b*vrval
iop02:
        mov  xl,xr
        mov  xr,m_word [REL (cfp_b*vrval)+xr]
        cmp  m_word [ xr],b_trt
        jne  iop03
        mov  w0,m_word [REL ioptt]
        cmp  m_word [REL (cfp_b*trtyp)+xr],w0
        jne  iop02
        mov  xr,m_word [REL (cfp_b*trnxt)+xr]
iop03:
        mov  m_word [REL (cfp_b*vrval)+xl],wc
        mov  xl,wc
        mov  m_word [REL (cfp_b*trnxt)+xl],xr
        mov  xr,m_word [REL r_ion]
        mov  wb,wa
        call setvr
        mov  xr,m_word [REL r_iot]
        or   xr,xr
        jnz  iop19
        mov  m_word [_rc_],0
        mov  w0,m_word [prc_+cfp_b*9]
        jmp  w0
iop04:
        xor  wa,wa
iop05:
        mov  wb,xr
        mov  xr,m_word [REL (cfp_b*vrval)+xr]
        cmp  m_word [ xr],b_trt
        jne  iop06
        cmp  m_word [REL (cfp_b*trtyp)+xr],trtfc
        jne  iop05
        mov  m_word [REL r_iot],xr
        mov  wa,m_word [REL (cfp_b*trfpt)+xr]
iop06:
        mov  m_word [REL r_iof],wa
        mov  m_word [REL r_iop],wb
        call ioppf
        call sysfc
        dec  m_word [_rc_]
        js   call_251
        dec  m_word [_rc_]
        jns  _l0449
        jmp  iop16
_l0449:
        dec  m_word [_rc_]
        jns  _l0450
        jmp  iop26
_l0450:
call_251:
        or   wa,wa
        jz   iop12
        cmp  wc,num02
        jb   iop6a
        call alost
        jmp  iop6b
iop6a:
        call alloc
iop6b:
        mov  xl,xr
        mov  wb,wa
        shr  wb,log_cfp_b
iop07:
        mov  w0,0
        stos_w
        dec  wb
        jnz  iop07
        cmp  wc,num02
        je   iop09
        mov  m_word [ xl],b_xnt
        mov  m_word [REL (cfp_b*num01)+xl],wa
        or   wc,wc
        jnz  iop09
        mov  m_word [ xl],b_xrt
iop09:
        mov  xr,m_word [REL r_iot]
        mov  m_word [REL r_iof],xl
        or   xr,xr
        jnz  iop10
        mov  wb,trtfc
        call trbld
        mov  m_word [REL r_iot],xr
        mov  xl,m_word [REL r_iop]
        mov  w0,m_word [REL (cfp_b*vrval)+xl]
        mov  m_word [REL (cfp_b*vrval)+xr],w0
        mov  m_word [REL (cfp_b*vrval)+xl],xr
        mov  xr,xl
        call setvr
        mov  xr,m_word [REL (cfp_b*vrval)+xr]
        jmp  iop1a
iop10:
        mov  w0,0
        mov  m_word [REL r_iop],w0
iop1a:
        mov  w0,m_word [REL r_iof]
        mov  m_word [REL (cfp_b*trfpt)+xr],w0
iop11:
        mov  wa,m_word [REL r_iof]
        mov  wb,m_word [REL ioptt]
        mov  xr,m_word [REL r_io2]
        mov  xl,m_word [REL r_io1]
        call sysio
        dec  m_word [_rc_]
        js   call_252
        dec  m_word [_rc_]
        jns  _l0451
        jmp  iop17
_l0451:
        dec  m_word [_rc_]
        jns  _l0452
        jmp  iop18
_l0452:
call_252:
        cmp  m_word [REL r_iot],0
        jnz  iop01
        cmp  m_word [REL ioptt],0
        jnz  iop01
        or   wc,wc
        jz   iop01
        mov  m_word [REL cswin],wc
        jmp  iop01
iop12:
        or   xl,xl
        jnz  iop09
        jmp  iop11
iop13:
        mov  m_word [_rc_],1
        mov  w0,m_word [prc_+cfp_b*9]
        jmp  w0
iop14:
        mov  m_word [_rc_],2
        mov  w0,m_word [prc_+cfp_b*9]
        jmp  w0
iop15:
        add  xs,cfp_b
        mov  m_word [_rc_],3
        mov  w0,m_word [prc_+cfp_b*9]
        jmp  w0
iop16:
        mov  m_word [_rc_],4
        mov  w0,m_word [prc_+cfp_b*9]
        jmp  w0
iop26:
        mov  m_word [_rc_],7
        mov  w0,m_word [prc_+cfp_b*9]
        jmp  w0
iop17:
        mov  xr,m_word [REL r_iop]
        or   xr,xr
        jz   iopa7
        mov  xl,m_word [REL (cfp_b*vrval)+xr]
        mov  w0,m_word [REL (cfp_b*vrval)+xl]
        mov  m_word [REL (cfp_b*vrval)+xr],w0
        call setvr
iopa7:
        mov  m_word [_rc_],5
        mov  w0,m_word [prc_+cfp_b*9]
        jmp  w0
iop18:
        mov  xr,m_word [REL r_iop]
        or   xr,xr
        jz   iopa7
        mov  xl,m_word [REL (cfp_b*vrval)+xr]
        mov  w0,m_word [REL (cfp_b*vrval)+xl]
        mov  m_word [REL (cfp_b*vrval)+xr],w0
        call setvr
iopa8:
        mov  m_word [_rc_],6
        mov  w0,m_word [prc_+cfp_b*9]
        jmp  w0
iop19:
        mov  wc,m_word [REL r_ion]
iop20:
        mov  xr,m_word [REL (cfp_b*trtrf)+xr]
        or   xr,xr
        jz   iop21
        cmp  wc,m_word [REL (cfp_b*ionmb)+xr]
        jne  iop20
        cmp  wb,m_word [REL (cfp_b*ionmo)+xr]
        je   iop22
        jmp  iop20
iop21:
        mov  wa,cfp_b*num05
        call alloc
        mov  m_word [ xr],b_xrt
        mov  m_word [REL (cfp_b*num01)+xr],wa
        mov  m_word [REL (cfp_b*ionmb)+xr],wc
        mov  m_word [REL (cfp_b*ionmo)+xr],wb
        mov  xl,m_word [REL r_iot]
        mov  wa,m_word [REL (cfp_b*trtrf)+xl]
        mov  m_word [REL (cfp_b*trtrf)+xl],xr
        mov  m_word [REL (cfp_b*trtrf)+xr],wa
iop22:
        cmp  m_word [REL r_iof],0
        jz   iop25
        mov  xl,m_word [REL r_fcb]
iop23:
        or   xl,xl
        jz   iop24
        mov  w0,m_word [REL r_iof]
        cmp  m_word [REL (cfp_b*num03)+xl],w0
        je   iop25
        mov  xl,m_word [REL (cfp_b*num02)+xl]
        jmp  iop23
iop24:
        mov  wa,cfp_b*num04
        call alloc
        mov  m_word [ xr],b_xrt
        mov  m_word [REL (cfp_b*num01)+xr],wa
        mov  w0,m_word [REL r_fcb]
        mov  m_word [REL (cfp_b*num02)+xr],w0
        mov  w0,m_word [REL r_iof]
        mov  m_word [REL (cfp_b*num03)+xr],w0
        mov  m_word [REL r_fcb],xr
iop25:
        mov  m_word [_rc_],0
        mov  w0,m_word [prc_+cfp_b*9]
        jmp  w0
ktrex:
        or   xl,xl
        jz   ktrx3
        cmp  m_word [REL kvtra],0
        jz   ktrx3
        dec  m_word [REL kvtra]
        push xr
        mov  xr,xl
        mov  xl,m_word [REL (cfp_b*trkvr)+xr]
        mov  wa,cfp_b*vrval
        cmp  m_word [REL (cfp_b*trfnc)+xr],0
        jz   ktrx1
        call trxeq
        jmp  ktrx2
ktrx1:
        push xl
        push wa
        call prtsn
        mov  wa,ch_am
        call prtch
        call prtnm
        mov  xr,tmbeb
        call prtst
        call kwnam
        mov  m_word [REL dnamp],xr
        call acess
        dec  m_word [_rc_]
        js   call_253
        dec  m_word [_rc_]
        jns  _l0453
        mov  m_word [_rc_],299
        jmp  err_
_l0453:
call_253:
        call prtvl
        call prtnl
ktrx2:
        pop  xr
ktrx3:
        ret
kwnam:
        pop  m_word [prc_+cfp_b*10]
        add  xs,cfp_b
        pop  xr
        cmp  xr,m_word [REL state]
        jae  kwnm1
        cmp  m_word [REL (cfp_b*vrlen)+xr],0
        jnz  kwnm1
        mov  xr,m_word [REL (cfp_b*vrsvp)+xr]
        mov  wa,m_word [REL (cfp_b*svbit)+xr]
        and  wa,m_word [REL btknm]
        or   wa,wa
        jz   kwnm1
        mov  wa,m_word [REL (cfp_b*svlen)+xr]
        add  wa,(cfp_b-1)+cfp_b*svchs
        and  wa,-cfp_b
        add  xr,wa
        mov  wb,m_word [ xr]
        mov  wa,cfp_b*kvsi_
        call alloc
        mov  m_word [ xr],b_kvt
        mov  m_word [REL (cfp_b*kvnum)+xr],wb
        mov  m_word [REL (cfp_b*kvvar)+xr],trbkv
        mov  xl,xr
        mov  wa,cfp_b*kvvar
        mov  m_word [_rc_],0
        mov  w0,m_word [prc_+cfp_b*10]
        jmp  w0
kwnm1:
        mov  m_word [_rc_],251
        jmp  err_
lcomp:
        pop  m_word [prc_+cfp_b*11]
        call gtstg
        dec  m_word [_rc_]
        js   call_254
        dec  m_word [_rc_]
        jns  _l0454
        jmp  lcmp6
_l0454:
call_254:
        mov  xl,xr
        mov  wc,wa
        call gtstg
        dec  m_word [_rc_]
        js   call_255
        dec  m_word [_rc_]
        jns  _l0455
        jmp  lcmp5
_l0455:
call_255:
        mov  wb,wa
        add  xr,cfp_f
        add  xl,cfp_f
        cmp  wa,wc
        jb   lcmp1
        mov  wa,wc
lcmp1:
        or   wa,wa
        jz   lcmp7
        repe cmps_b
        mov  xl,0
        mov  xr,xl
        ja   lcmp3
        jb   lcmp4
lcmp7:
        cmp  wb,wc
        jne  lcmp2
        mov  m_word [_rc_],4
        mov  w0,m_word [prc_+cfp_b*11]
        jmp  w0
lcmp2:
        cmp  wb,wc
        ja   lcmp4
lcmp3:
        mov  m_word [_rc_],3
        mov  w0,m_word [prc_+cfp_b*11]
        jmp  w0
lcmp4:
        mov  m_word [_rc_],5
        mov  w0,m_word [prc_+cfp_b*11]
        jmp  w0
lcmp5:
        mov  m_word [_rc_],1
        mov  w0,m_word [prc_+cfp_b*11]
        jmp  w0
lcmp6:
        mov  m_word [_rc_],2
        mov  w0,m_word [prc_+cfp_b*11]
        jmp  w0
listr:
        cmp  m_word [REL cnttl],0
        jnz  list5
        cmp  m_word [REL lstpf],0
        jnz  list4
        mov  w0,m_word [REL lstnp]
        cmp  m_word [REL lstlc],w0
        jae  list6
list0:
        mov  xr,m_word [REL r_cim]
        or   xr,xr
        jz   list4
        add  xr,cfp_f
        mov  w0,0
        mov  al,m_char [xr]
        mov  wa,w0
        mov  xr,m_word [REL lstsn]
        or   xr,xr
        jz   list2
        ldi_ xr
        cmp  m_word [REL stage],stgic
        jne  list1
        cmp  wa,ch_as
        je   list2
        cmp  wa,ch_mn
        je   list2
list1:
        call prtin
        mov  w0,0
        mov  m_word [REL lstsn],w0
list2:
        mov  xr,m_word [REL lstid]
        or   xr,xr
        jz   list8
        mov  wa,stnpd
        sub  wa,num03
        mov  m_word [REL profs],wa
        ldi_ xr
        call prtin
list8:
        mov  m_word [REL profs],stnpd
        mov  xr,m_word [REL r_cim]
        call prtst
        inc  m_word [REL lstlc]
        cmp  m_word [REL erlst],0
        jnz  list3
        call prtnl
        cmp  m_word [REL cswdb],0
        jz   list3
        call prtnl
        inc  m_word [REL lstlc]
list3:
        mov  m_word [REL lstpf],xs
list4:
        ret
list5:
        mov  w0,0
        mov  m_word [REL cnttl],w0
list6:
        call prtps
        cmp  m_word [REL prich],0
        jz   list7
        cmp  m_word [REL r_ttl],nulls
        je   list0
list7:
        call listt
        jmp  list0
listt:
        mov  xr,m_word [REL r_ttl]
        call prtst
        mov  w0,m_word [REL lstpo]
        mov  m_word [REL profs],w0
        mov  xr,lstms
        call prtst
        inc  m_word [REL lstpg]
        ldi_ m_word [REL lstpg]
        call prtin
        call prtnl
        add  m_word [REL lstlc],num02
        mov  xr,m_word [REL r_stl]
        or   xr,xr
        jz   lstt1
        call prtst
        call prtnl
        inc  m_word [REL lstlc]
lstt1:
        call prtnl
        ret
newfn:
        push xr
        mov  xl,m_word [REL r_sfc]
        call ident
        dec  m_word [_rc_]
        js   call_256
        dec  m_word [_rc_]
        jns  _l0456
        jmp  nwfn1
_l0456:
call_256:
        pop  xr
        mov  m_word [REL r_sfc],xr
        mov  wb,m_word [REL cmpsn]
        ldi_ wb
        call icbld
        mov  xl,m_word [REL r_sfn]
        mov  wb,xs
        call tfind
        dec  m_word [_rc_]
        js   call_257
        dec  m_word [_rc_]
        jns  _l0457
        mov  m_word [_rc_],299
        jmp  err_
_l0457:
call_257:
        mov  w0,m_word [REL r_sfc]
        mov  m_word [REL (cfp_b*teval)+xl],w0
        ret
nwfn1:
        add  xs,cfp_b
        ret
nexts:
        cmp  m_word [REL cswls],0
        jz   nxts2
        mov  xr,m_word [REL r_cim]
        or   xr,xr
        jz   nxts2
        add  xr,cfp_f
        mov  w0,0
        mov  al,m_char [xr]
        mov  wa,w0
        cmp  wa,ch_mn
        jne  nxts1
        cmp  m_word [REL cswpr],0
        jz   nxts2
nxts1:
        call listr
nxts2:
        mov  xr,m_word [REL r_cni]
        mov  m_word [REL r_cim],xr
        mov  w0,m_word [REL rdnln]
        mov  m_word [REL rdcln],w0
        mov  w0,m_word [REL cnind]
        mov  m_word [REL lstid],w0
        mov  w0,0
        mov  m_word [REL r_cni],w0
        mov  wa,m_word [REL (cfp_b*sclen)+xr]
        mov  wb,m_word [REL cswin]
        cmp  wa,wb
        jb   nxts3
        mov  wa,wb
nxts3:
        mov  m_word [REL scnil],wa
        mov  w0,0
        mov  m_word [REL scnse],w0
        mov  w0,0
        mov  m_word [REL lstpf],w0
        ret
patin:
        pop  m_word [prc_+cfp_b*12]
        mov  xl,wa
        call gtsmi
        dec  m_word [_rc_]
        js   call_258
        dec  m_word [_rc_]
        jns  _l0458
        jmp  ptin2
_l0458:
        dec  m_word [_rc_]
        jns  _l0459
        jmp  ptin3
_l0459:
call_258:
ptin1:
        call pbild
        mov  m_word [_rc_],0
        mov  w0,m_word [prc_+cfp_b*12]
        jmp  w0
ptin2:
        mov  wb,xl
        cmp  m_word [ xr],b_e__
        jb   ptin1
        mov  m_word [_rc_],1
        mov  w0,m_word [prc_+cfp_b*12]
        jmp  w0
ptin3:
        mov  m_word [_rc_],2
        mov  w0,m_word [prc_+cfp_b*12]
        jmp  w0
patst:
        pop  m_word [prc_+cfp_b*13]
        call gtstg
        dec  m_word [_rc_]
        js   call_259
        dec  m_word [_rc_]
        jns  _l0460
        jmp  pats7
_l0460:
call_259:
        or   wa,wa
        jz   pats7
        cmp  wa,num01
        jne  pats2
        or   wb,wb
        jz   pats2
        add  xr,cfp_f
        mov  w0,0
        mov  al,m_char [xr]
        mov  xr,w0
pats1:
        call pbild
        mov  m_word [_rc_],0
        mov  w0,m_word [prc_+cfp_b*13]
        jmp  w0
pats2:
        push xl
        mov  wc,m_word [REL ctmsk]
        cmp  xr,m_word [REL r_cts]
        je   pats6
        push xr
        shl  wc,1
        or   wc,wc
        jnz  pats4
        mov  wa,cfp_b*ctsi_
        call alloc
        mov  m_word [REL r_ctp],xr
        mov  w0,b_ctt
        stos_w
        mov  wb,cfp_a
        mov  wc,m_word [REL bits0]
pats3:
        mov  w0,wc
        stos_w
        dec  wb
        jnz  pats3
        mov  wc,m_word [REL bits1]
pats4:
        mov  m_word [REL ctmsk],wc
        pop  xl
        mov  m_word [REL r_cts],xl
        mov  wb,m_word [REL (cfp_b*sclen)+xl]
        or   wb,wb
        jz   pats6
        add  xl,cfp_f
pats5:
        mov  w0,0
        mov  al,m_char [xl]
        mov  wa,w0
        inc  xl
        sal  wa,log_cfp_b
        mov  xr,m_word [REL r_ctp]
        add  xr,wa
        mov  wa,wc
        or   wa,m_word [REL (cfp_b*ctchs)+xr]
        mov  m_word [REL (cfp_b*ctchs)+xr],wa
        dec  wb
        jnz  pats5
pats6:
        mov  xr,m_word [REL r_ctp]
        xor  xl,xl
        pop  wb
        jmp  pats1
pats7:
        mov  wb,wc
        cmp  m_word [ xr],b_e__
        jb   pats1
        mov  m_word [_rc_],1
        mov  w0,m_word [prc_+cfp_b*13]
        jmp  w0
pbild:
        push xr
        mov  xr,wb
        movzx xr,byte [xr-1]
        cmp  xr,bl_p1
        je   pbld1
        cmp  xr,bl_p0
        je   pbld3
        mov  wa,cfp_b*pcsi_
        call alloc
        mov  m_word [REL (cfp_b*parm2)+xr],wc
        jmp  pbld2
pbld1:
        mov  wa,cfp_b*pbsi_
        call alloc
pbld2:
        mov  w0,m_word [ xs]
        mov  m_word [REL (cfp_b*parm1)+xr],w0
        jmp  pbld4
pbld3:
        mov  wa,cfp_b*pasi_
        call alloc
pbld4:
        mov  m_word [ xr],wb
        add  xs,cfp_b
        mov  m_word [REL (cfp_b*pthen)+xr],ndnth
        ret
pconc:
        push 0
        mov  wc,xs
        push ndnth
        push xl
        mov  xt,xs
        call pcopy
        mov  m_word [REL (cfp_b*num02)+xt],wa
pcnc1:
        cmp  xt,xs
        je   pcnc2
        lea  xt,[xt-cfp_b]
        mov  xr,m_word [xt]
        mov  xr,m_word [REL (cfp_b*pthen)+xr]
        call pcopy
        lea  xt,[xt-cfp_b]
        mov  xr,m_word [xt]
        mov  m_word [REL (cfp_b*pthen)+xr],wa
        cmp  m_word [ xr],p_alt
        jne  pcnc1
        mov  xr,m_word [REL (cfp_b*parm1)+xr]
        call pcopy
        mov  xr,m_word [ xt]
        mov  m_word [REL (cfp_b*parm1)+xr],wa
        jmp  pcnc1
pcnc2:
        mov  xs,wc
        pop  xr
        ret
pcopy:
        pop  m_word [prc_+cfp_b*14]
        mov  wb,xt
        mov  xt,wc
pcop1:
        sub  xt,cfp_b
        cmp  xr,m_word [ xt]
        je   pcop2
        sub  xt,cfp_b
        cmp  xt,xs
        jne  pcop1
        mov  wa,m_word [ xr]
        call blkln
        mov  xl,xr
        call alloc
        push xl
        push xr
        cmp  xs,lowspmin
        jb   sec06
        shr  wa,log_cfp_b
        rep  movs_w
        mov  wa,m_word [ xs]
        jmp  pcop3
pcop2:
        lea  xt,[xt-cfp_b]
        mov  wa,m_word [xt]
pcop3:
        mov  xt,wb
        mov  m_word [_rc_],0
        mov  w0,m_word [prc_+cfp_b*14]
        jmp  w0
prflr:
        cmp  m_word [REL pfdmp],0
        jz   prfl4
        push xr
        mov  m_word [REL pfsvw],wb
        call prtpg
        mov  xr,pfms1
        call prtst
        call prtnl
        call prtnl
        mov  xr,pfms2
        call prtst
        call prtnl
        mov  xr,pfms3
        call prtst
        call prtnl
        call prtnl
        xor  wb,wb
        mov  xr,m_word [REL pftbl]
        add  xr,cfp_b*xndta
prfl1:
        inc  wb
        ldi_ m_word [ xr]
        sti_ w0
        or   w0,w0
        je   prfl3
        mov  m_word [REL profs],pfpd1
        call prtin
        mov  w0,0
        mov  m_word [REL profs],w0
        ldi_ wb
        call prtin
        mov  m_word [REL profs],pfpd2
        ldi_ m_word [REL (cfp_b*cfp_i)+xr]
        call prtin
        ldi_ m_word [REL (cfp_b*cfp_i)+xr]
        mli_ m_word [REL intth]
        iov_ prfl2
        dvi_ m_word [ xr]
        mov  m_word [REL profs],pfpd3
        call prtin
prfl2:
        call prtnl
prfl3:
        add  xr,cfp_b*pf_i2
        cmp  wb,m_word [REL pfnte]
        jb   prfl1
        pop  xr
        mov  wb,m_word [REL pfsvw]
prfl4:
        ret
prflu:
        cmp  m_word [REL pffnc],0
        jnz  pflu4
        push xr
        mov  m_word [REL pfsvw],wa
        cmp  m_word [REL pftbl],0
        jnz  pflu2
        sub  m_word [REL pfnte],num01
        ldi_ m_word [REL pfi2a]
        sti_ m_word [REL pfste]
        ldi_ m_word [REL pfnte]
        mli_ m_word [REL pfste]
        sti_ wa
        add  wa,num02
        sal  wa,log_cfp_b
        call alost
        mov  m_word [REL pftbl],xr
        mov  w0,b_xnt
        stos_w
        mov  w0,wa
        stos_w
        sti_ wa
pflu1:
        mov  w0,0
        stos_w
        dec  wa
        jnz  pflu1
pflu2:
        ldi_ m_word [REL kvstn]
        sbi_ m_word [REL intv1]
        mli_ m_word [REL pfste]
        sti_ wa
        sal  wa,log_cfp_b
        add  wa,cfp_b*num02
        mov  xr,m_word [REL pftbl]
        cmp  wa,m_word [REL (cfp_b*num01)+xr]
        jae  pflu3
        add  xr,wa
        ldi_ m_word [ xr]
        adi_ m_word [REL intv1]
        sti_ m_word [ xr]
        call systm
        sti_ m_word [REL pfetm]
        sbi_ m_word [REL pfstm]
        adi_ m_word [REL (cfp_b*cfp_i)+xr]
        sti_ m_word [REL (cfp_b*cfp_i)+xr]
        ldi_ m_word [REL pfetm]
        sti_ m_word [REL pfstm]
pflu3:
        pop  xr
        mov  wa,m_word [REL pfsvw]
        ret
pflu4:
        mov  w0,0
        mov  m_word [REL pffnc],w0
        ret
prpar:
        or   wc,wc
        jnz  prpa8
        call syspp
        or   wb,wb
        jnz  prpa1
        mov  wb,m_word [REL mxint]
        shr  wb,1
prpa1:
        mov  m_word [REL lstnp],wb
        mov  m_word [REL lstlc],wb
        mov  w0,0
        mov  m_word [REL lstpg],w0
        mov  wb,m_word [REL prlen]
        or   wb,wb
        jz   prpa2
        cmp  wa,wb
        ja   prpa3
prpa2:
        mov  m_word [REL prlen],wa
prpa3:
        mov  wb,m_word [REL bits3]
        and  wb,wc
        or   wb,wb
        jz   prpa4
        mov  w0,0
        mov  m_word [REL cswls],w0
prpa4:
        mov  wb,m_word [REL bits1]
        and  wb,wc
        mov  m_word [REL erich],wb
        mov  wb,m_word [REL bits2]
        and  wb,wc
        mov  m_word [REL prich],wb
        mov  wb,m_word [REL bits4]
        and  wb,wc
        mov  m_word [REL cpsts],wb
        mov  wb,m_word [REL bits5]
        and  wb,wc
        mov  m_word [REL exsts],wb
        mov  wb,m_word [REL bits6]
        and  wb,wc
        mov  m_word [REL precl],wb
        sub  wa,num08
        or   wb,wb
        jz   prpa5
        mov  m_word [REL lstpo],wa
prpa5:
        mov  wb,m_word [REL bits7]
        and  wb,wc
        mov  m_word [REL cswex],wb
        mov  wb,m_word [REL bit10]
        and  wb,wc
        mov  m_word [REL headp],wb
        mov  wb,m_word [REL bits9]
        and  wb,wc
        mov  m_word [REL prsto],wb
        mov  wb,wc
        shr  wb,12
        and  wb,m_word [REL bits1]
        mov  m_word [REL kvcas],wb
        mov  wb,m_word [REL bit12]
        and  wb,wc
        mov  m_word [REL cswer],wb
        or   wb,wb
        jz   prpa6
        mov  wa,m_word [REL prlen]
        sub  wa,num08
        mov  m_word [REL lstpo],wa
prpa6:
        mov  wb,m_word [REL bit11]
        and  wb,wc
        mov  m_word [REL cswpr],wb
        and  wc,m_word [REL bits8]
        or   wc,wc
        jnz  prpa8
        cmp  m_word [REL initr],0
        jz   prpa9
        mov  xl,v_ter
        call gtnvr
        dec  m_word [_rc_]
        js   call_260
        dec  m_word [_rc_]
        jns  _l0461
        mov  m_word [_rc_],299
        jmp  err_
_l0461:
call_260:
        mov  m_word [REL (cfp_b*vrval)+xr],nulls
        call setvr
        jmp  prpa9
prpa8:
        mov  m_word [REL initr],xs
        cmp  m_word [REL dnamb],0
        jz   prpa9
        mov  xl,v_ter
        mov  wb,trtou
        call inout
        push xr
        mov  xl,v_ter
        mov  wb,trtin
        call inout
        pop  m_word [REL (cfp_b*vrval)+xr]
prpa9:
        ret
prtch:
        push xr
        mov  w0,m_word [REL prlen]
        cmp  m_word [REL profs],w0
        jne  prch1
        call prtnl
prch1:
        mov  xr,m_word [REL prbuf]
        add  xr,cfp_f
        add  xr,m_word [REL profs]
        mov  m_char [xr],wa_l
        inc  m_word [REL profs]
        pop  xr
        ret
prtic:
        push xr
        mov  xr,m_word [REL prbuf]
        mov  wa,m_word [REL profs]
        call syspi
        dec  m_word [_rc_]
        js   call_261
        dec  m_word [_rc_]
        jns  _l0462
        jmp  prtc2
_l0462:
call_261:
prtc1:
        pop  xr
        ret
prtc2:
        mov  w0,0
        mov  m_word [REL erich],w0
        mov  m_word [_rc_],252
        jmp  err_
        jmp  prtc1
prtis:
        cmp  m_word [REL prich],0
        jnz  prts1
        cmp  m_word [REL erich],0
        jz   prts1
        call prtic
prts1:
        call prtnl
        ret
prtin:
        push xr
        call icbld
        cmp  xr,m_word [REL dnamb]
        jb   prti1
        cmp  xr,m_word [REL dnamp]
        ja   prti1
        mov  m_word [REL dnamp],xr
prti1:
        push xr
        call gtstg
        dec  m_word [_rc_]
        js   call_262
        dec  m_word [_rc_]
        jns  _l0463
        mov  m_word [_rc_],299
        jmp  err_
_l0463:
call_262:
        mov  m_word [REL dnamp],xr
        call prtst
        pop  xr
        ret
prtmi:
        call prtst
        mov  m_word [REL profs],prtmf
        call prtin
        call prtnl
        ret
prtmm:
        mov  wa,m_word [REL dnamp]
        sub  wa,m_word [REL statb]
        ldi_ wa
        mov  xr,encm1
        call prtmi
        mov  wa,m_word [REL dname]
        sub  wa,m_word [REL dnamp]
        ldi_ wa
        mov  xr,encm2
        call prtmi
        ret
prtmx:
        call prtst
        mov  m_word [REL profs],prtmf
        call prtin
        call prtis
        ret
prtnl:
        cmp  m_word [REL headp],0
        jnz  prnl0
        call prtps
prnl0:
        push xr
        mov  m_word [REL prtsa],wa
        mov  m_word [REL prtsb],wb
        mov  xr,m_word [REL prbuf]
        mov  wa,m_word [REL profs]
        call syspr
        dec  m_word [_rc_]
        js   call_263
        dec  m_word [_rc_]
        jns  _l0464
        jmp  prnl2
_l0464:
call_263:
        mov  wa,m_word [REL prlnw]
        add  xr,cfp_b*schar
        mov  wb,m_word [REL nullw]
prnl1:
        mov  w0,wb
        stos_w
        dec  wa
        jnz  prnl1
        mov  wb,m_word [REL prtsb]
        mov  wa,m_word [REL prtsa]
        pop  xr
        mov  w0,0
        mov  m_word [REL profs],w0
        ret
prnl2:
        cmp  m_word [REL prtef],0
        jnz  prnl3
        mov  m_word [REL prtef],xs
        mov  m_word [_rc_],253
        jmp  err_
prnl3:
        mov  wb,nini8
        mov  wa,m_word [REL kvstn]
        mov  xl,m_word [REL r_fcb]
        call sysej
prtnm:
        push wa
        push xr
        push xl
        cmp  xl,m_word [REL state]
        ja   prn02
        mov  xr,xl
        call prtvn
prn01:
        pop  xl
        pop  xr
        pop  wa
        ret
prn02:
        mov  wb,wa
        cmp  m_word [ xl],b_pdt
        jne  prn03
        mov  xr,m_word [REL (cfp_b*pddfp)+xl]
        add  xr,wa
        mov  xr,m_word [REL (cfp_b*pdfof)+xr]
        call prtvn
        mov  wa,ch_pp
        call prtch
prn03:
        cmp  m_word [ xl],b_tet
        jne  prn04
        mov  xl,m_word [REL (cfp_b*tenxt)+xl]
        jmp  prn03
prn04:
        mov  xr,m_word [REL prnmv]
        mov  wa,m_word [REL hshtb]
        jmp  prn07
prn05:
        mov  xr,wa
        add  wa,cfp_b
        sub  xr,cfp_b*vrnxt
prn06:
        mov  xr,m_word [REL (cfp_b*vrnxt)+xr]
prn07:
        mov  wc,xr
        or   wc,wc
        jz   prn09
prn08:
        mov  xr,m_word [REL (cfp_b*vrval)+xr]
        cmp  m_word [ xr],b_trt
        je   prn08
        cmp  xr,xl
        je   prn10
        mov  xr,wc
        jmp  prn06
prn09:
        cmp  wa,m_word [REL hshte]
        jb   prn05
        mov  xr,xl
        call prtvl
        jmp  prn11
prn10:
        mov  xr,wc
        mov  m_word [REL prnmv],xr
        call prtvn
prn11:
        mov  wc,m_word [ xl]
        cmp  wc,b_pdt
        jne  prn13
        mov  wa,ch_rp
prn12:
        call prtch
        mov  wa,wb
        jmp  prn01
prn13:
        mov  wa,ch_bb
        call prtch
        mov  xl,m_word [ xs]
        mov  wc,m_word [ xl]
        cmp  wc,b_tet
        jne  prn15
        mov  xr,m_word [REL (cfp_b*tesub)+xl]
        mov  xl,wb
        call prtvl
        mov  wb,xl
prn14:
        mov  wa,ch_rb
        jmp  prn12
prn15:
        mov  wa,wb
        shr  wa,log_cfp_b
        cmp  wc,b_art
        je   prn16
        sub  wa,vcvlb
        ldi_ wa
        call prtin
        jmp  prn14
prn16:
        mov  wc,m_word [REL (cfp_b*arofs)+xl]
        add  wc,cfp_b
        shr  wc,log_cfp_b
        sub  wa,wc
        ldi_ wa
        mov  wa,m_word [REL (cfp_b*arndm)+xl]
        add  xl,m_word [REL (cfp_b*arofs)+xl]
        sub  xl,cfp_b*arlbd
prn17:
        sub  xl,cfp_b*ardms
        sti_ m_word [REL prnsi]
        rmi_ m_word [REL (cfp_b*ardim)+xl]
        sti_ w0
        push w0
        ldi_ m_word [REL prnsi]
        dvi_ m_word [REL (cfp_b*ardim)+xl]
        dec  wa
        jnz  prn17
        xor  xr,xr
        mov  wb,m_word [REL (cfp_b*arndm)+xl]
        jmp  prn19
prn18:
        mov  wa,ch_cm
        call prtch
prn19:
        pop  w0
        ldi_ w0
        add  xl,xr
        adi_ m_word [REL (cfp_b*arlbd)+xl]
        sub  xl,xr
        call prtin
        add  xr,cfp_b*ardms
        dec  wb
        jnz  prn18
        jmp  prn14
prtnv:
        call prtnm
        push xr
        push wa
        mov  xr,tmbeb
        call prtst
        mov  xr,xl
        add  xr,wa
        mov  xr,m_word [ xr]
        call prtvl
        call prtnl
        pop  wa
        pop  xr
        ret
prtpg:
        cmp  m_word [REL stage],stgxt
        je   prp01
        cmp  m_word [REL lstlc],0
        jz   prp06
        mov  w0,0
        mov  m_word [REL lstlc],w0
prp01:
        push xr
        cmp  m_word [REL prstd],0
        jnz  prp02
        cmp  m_word [REL prich],0
        jnz  prp03
        cmp  m_word [REL precl],0
        jz   prp03
prp02:
        call sysep
        jmp  prp04
prp03:
        mov  xr,m_word [REL headp]
        mov  m_word [REL headp],xs
        call prtnl
        call prtnl
        call prtnl
        mov  m_word [REL lstlc],num03
        mov  m_word [REL headp],xr
prp04:
        cmp  m_word [REL headp],0
        jnz  prp05
        mov  m_word [REL headp],xs
        push xl
        mov  xr,headr
        call prtst
        call sysid
        call prtst
        call prtnl
        mov  xr,xl
        call prtst
        call prtnl
        call prtnl
        call prtnl
        add  m_word [REL lstlc],num04
        pop  xl
prp05:
        pop  xr
prp06:
        ret
prtps:
        mov  w0,m_word [REL prsto]
        mov  m_word [REL prstd],w0
        call prtpg
        mov  w0,0
        mov  m_word [REL prstd],w0
        ret
prtsn:
        push xr
        mov  m_word [REL prsna],wa
        mov  xr,tmasb
        call prtst
        mov  m_word [REL profs],num04
        ldi_ m_word [REL kvstn]
        call prtin
        mov  m_word [REL profs],prsnf
        mov  xr,m_word [REL kvfnc]
        mov  wa,ch_li
prsn1:
        or   xr,xr
        jz   prsn2
        call prtch
        dec  xr
        jmp  prsn1
prsn2:
        mov  wa,ch_bl
        call prtch
        mov  wa,m_word [REL prsna]
        pop  xr
        ret
prtst:
        cmp  m_word [REL headp],0
        jnz  prst0
        call prtps
prst0:
        mov  m_word [REL prsva],wa
        mov  m_word [REL prsvb],wb
        xor  wb,wb
prst1:
        mov  wa,m_word [REL (cfp_b*sclen)+xr]
        sub  wa,wb
        or   wa,wa
        jz   prst4
        push xl
        push xr
        mov  xl,xr
        mov  xr,m_word [REL prlen]
        sub  xr,m_word [REL profs]
        or   xr,xr
        jnz  prst2
        call prtnl
        mov  xr,m_word [REL prlen]
prst2:
        cmp  wa,xr
        jb   prst3
        mov  wa,xr
prst3:
        mov  xr,m_word [REL prbuf]
        lea  xl,[cfp_f+xl+wb]
        add  xr,cfp_f
        add  xr,m_word [REL profs]
        add  wb,wa
        add  m_word [REL profs],wa
        mov  m_word [REL prsvc],wb
        rep
        movs_b
        mov  wb,m_word [REL prsvc]
        pop  xr
        pop  xl
        jmp  prst1
prst4:
        mov  wb,m_word [REL prsvb]
        mov  wa,m_word [REL prsva]
        ret
prttr:
        push xr
        call prtic
        mov  xr,m_word [REL prbuf]
        mov  wa,m_word [REL prlnw]
        add  xr,cfp_b*schar
        mov  wb,m_word [REL nullw]
prtt1:
        mov  w0,wb
        stos_w
        dec  wa
        jnz  prtt1
        mov  w0,0
        mov  m_word [REL profs],w0
        pop  xr
        ret
prtvl:
        push xl
        push xr
        cmp  xs,lowspmin
        jb   sec06
prv01:
        mov  w0,m_word [REL (cfp_b*idval)+xr]
        mov  m_word [REL prvsi],w0
        mov  xl,m_word [ xr]
        movzx xl,byte [xl-1]
        cmp  xl,bl__t
        jge  prv02
        jmp  m_word [_l0466+xl*cfp_b]
        segment .data
_l0466:
        d_word prv05
        d_word prv02
        d_word prv02
        d_word prv08
        d_word prv09
        d_word prv02
        d_word prv02
        d_word prv02
        d_word prv08
        d_word prv11
        d_word prv12
        d_word prv13
        d_word prv13
        d_word prv02
        d_word prv02
        d_word prv02
        d_word prv10
        d_word prv04
        segment .text
prv02:
        call dtype
        call prtst
prv03:
        pop  xr
        pop  xl
        ret
prv04:
        mov  xr,m_word [REL (cfp_b*trval)+xr]
        jmp  prv01
prv05:
        mov  xl,xr
        mov  xr,scarr
        call prtst
        mov  wa,ch_pp
        call prtch
        add  xl,m_word [REL (cfp_b*arofs)+xl]
        mov  xr,m_word [ xl]
        call prtst
prv06:
        mov  wa,ch_rp
        call prtch
prv07:
        mov  wa,ch_bl
        call prtch
        mov  wa,ch_nm
        call prtch
        ldi_ m_word [REL prvsi]
        call prtin
        jmp  prv03
prv08:
        push xr
        call gtstg
        dec  m_word [_rc_]
        js   call_264
        dec  m_word [_rc_]
        jns  _l0467
        mov  m_word [_rc_],299
        jmp  err_
_l0467:
call_264:
        call prtst
        mov  m_word [REL dnamp],xr
        jmp  prv03
prv09:
        mov  xl,m_word [REL (cfp_b*nmbas)+xr]
        mov  wa,m_word [ xl]
        cmp  wa,b_kvt
        je   prv02
        cmp  wa,b_evt
        je   prv02
        mov  wa,ch_dt
        call prtch
        mov  wa,m_word [REL (cfp_b*nmofs)+xr]
        call prtnm
        jmp  prv03
prv10:
        call dtype
        call prtst
        jmp  prv07
prv11:
        mov  wa,ch_sq
        call prtch
        call prtst
        call prtch
        jmp  prv03
prv12:
        mov  wa,ch_as
        call prtch
        mov  xr,m_word [REL (cfp_b*sevar)+xr]
        call prtvn
        jmp  prv03
prv13:
        mov  xl,xr
        call dtype
        call prtst
        mov  wa,ch_pp
        call prtch
        mov  wa,m_word [REL (cfp_b*tblen)+xl]
        shr  wa,log_cfp_b
        sub  wa,tbsi_
        cmp  m_word [ xl],b_tbt
        je   prv14
        add  wa,vctbd
prv14:
        ldi_ wa
        call prtin
        jmp  prv06
prtvn:
        push xr
        add  xr,cfp_b*vrsof
        cmp  m_word [REL (cfp_b*sclen)+xr],0
        jnz  prvn1
        mov  xr,m_word [REL (cfp_b*vrsvo)+xr]
prvn1:
        call prtst
        pop  xr
        ret
rcbld:
        mov  xr,m_word [REL dnamp]
        add  xr,cfp_b*rcsi_
        cmp  xr,m_word [REL dname]
        jb   rcbl1
        mov  wa,cfp_b*rcsi_
        call alloc
        add  xr,wa
rcbl1:
        mov  m_word [REL dnamp],xr
        sub  xr,cfp_b*rcsi_
        mov  m_word [ xr],b_rcl
        lea  w0,[REL (cfp_b*rcval)+xr]
        call str_
        ret
readr:
        mov  xr,m_word [REL r_cni]
        or   xr,xr
        jnz  read3
        cmp  m_word [REL cnind],0
        jnz  reada
        cmp  m_word [REL stage],stgic
        jne  read3
reada:
        mov  wa,m_word [REL cswin]
        xor  xl,xl
        call alocs
        call sysrd
        dec  m_word [_rc_]
        js   call_265
        dec  m_word [_rc_]
        jns  _l0468
        jmp  read4
_l0468:
call_265:
        inc  m_word [REL rdnln]
        dec  m_word [REL polct]
        cmp  m_word [REL polct],0
        jnz  read0
        xor  wa,wa
        mov  wb,m_word [REL rdnln]
        call syspl
        dec  m_word [_rc_]
        js   call_266
        dec  m_word [_rc_]
        jns  _l0469
        mov  m_word [_rc_],320
        jmp  err_
_l0469:
        dec  m_word [_rc_]
        jns  _l0470
        mov  m_word [_rc_],299
        jmp  err_
_l0470:
        dec  m_word [_rc_]
        jns  _l0471
        mov  m_word [_rc_],299
        jmp  err_
_l0471:
call_266:
        mov  m_word [REL polcs],wa
        mov  m_word [REL polct],wa
read0:
        mov  w0,m_word [REL cswin]
        cmp  m_word [REL (cfp_b*sclen)+xr],w0
        jbe  read1
        mov  w0,m_word [REL cswin]
        mov  m_word [REL (cfp_b*sclen)+xr],w0
read1:
        mov  wb,xs
        call trimr
read2:
        mov  m_word [REL r_cni],xr
read3:
        ret
read4:
        cmp  m_word [REL (cfp_b*sclen)+xr],0
        jz   read5
        xor  wb,wb
        mov  m_word [REL rdnln],wb
        call trimr
        call newfn
        jmp  reada
read5:
        mov  m_word [REL dnamp],xr
        cmp  m_word [REL cnind],0
        jz   read6
        xor  xl,xl
        call sysif
        dec  m_word [_rc_]
        js   call_267
        dec  m_word [_rc_]
        jns  _l0472
        mov  m_word [_rc_],299
        jmp  err_
_l0472:
call_267:
        mov  wa,m_word [REL cnind]
        add  wa,vcvlb
        sal  wa,log_cfp_b
        mov  xr,m_word [REL r_ifa]
        add  xr,wa
        mov  w0,m_word [ xr]
        mov  m_word [REL r_sfc],w0
        mov  m_word [ xr],nulls
        mov  xr,m_word [REL r_ifl]
        add  xr,wa
        mov  xl,m_word [ xr]
        ldi_ m_word [REL (cfp_b*icval)+xl]
        sti_ m_word [REL rdnln]
        mov  m_word [ xr],inton
        dec  m_word [REL cnind]
        mov  wb,m_word [REL cmpsn]
        inc  wb
        ldi_ wb
        call icbld
        mov  xl,m_word [REL r_sfn]
        mov  wb,xs
        call tfind
        dec  m_word [_rc_]
        js   call_268
        dec  m_word [_rc_]
        jns  _l0473
        mov  m_word [_rc_],299
        jmp  err_
_l0473:
call_268:
        mov  w0,m_word [REL r_sfc]
        mov  m_word [REL (cfp_b*teval)+xl],w0
        cmp  m_word [REL stage],stgic
        je   reada
        cmp  m_word [REL cnind],0
        jnz  reada
        mov  xl,m_word [REL r_ici]
        mov  w0,0
        mov  m_word [REL r_ici],w0
        mov  wa,m_word [REL cnsil]
        mov  wb,m_word [REL cnspt]
        sub  wa,wb
        mov  m_word [REL scnil],wa
        mov  w0,0
        mov  m_word [REL scnpt],w0
        call sbstr
        mov  m_word [REL r_cim],xr
        jmp  read2
read6:
        xor  xr,xr
        jmp  read2
sbstr:
        or   wa,wa
        jz   sbst2
        call alocs
        mov  wa,wc
        mov  wc,xr
        lea  xl,[cfp_f+xl+wb]
        add  xr,cfp_f
        rep
        movs_b
        mov  xr,wc
sbst1:
        xor  xl,xl
        ret
sbst2:
        mov  xr,nulls
        jmp  sbst1
stgcc:
        mov  wa,m_word [REL polcs]
        mov  wb,num01
        ldi_ m_word [REL kvstl]
        cmp  m_word [REL kvpfl],0
        jnz  stgc1
        sti_ w0
        or   w0,w0
        jl   stgc3
        cmp  m_word [REL r_stc],0
        jz   stgc2
stgc1:
        mov  wb,wa
        mov  wa,num01
        jmp  stgc3
stgc2:
        ldi_ wa
        sbi_ m_word [REL kvstl]
        sti_ w0
        or   w0,w0
        jle  stgc3
        ldi_ m_word [REL kvstl]
        sti_ wa
stgc3:
        mov  m_word [REL stmcs],wa
        mov  m_word [REL stmct],wa
        mov  m_word [REL polct],wb
        ret
tfind:
        push wb
        push xr
        push xl
        mov  wa,m_word [REL (cfp_b*tblen)+xl]
        shr  wa,log_cfp_b
        sub  wa,tbbuk
        ldi_ wa
        sti_ m_word [REL tfnsi]
        mov  xl,m_word [ xr]
        movzx xl,byte [xl-1]
        cmp  xl,bl__d
        jge  tfn00
        jmp  m_word [_l0475+xl*cfp_b]
        segment .data
_l0475:
        d_word tfn00
        d_word tfn00
        d_word tfn00
        d_word tfn02
        d_word tfn04
        d_word tfn03
        d_word tfn03
        d_word tfn03
        d_word tfn02
        d_word tfn05
        d_word tfn00
        d_word tfn00
        d_word tfn00
        d_word tfn00
        d_word tfn00
        d_word tfn00
        d_word tfn00
        segment .text
tfn00:
        mov  wa,m_word [REL (cfp_b*1)+xr]
tfn01:
        ldi_ wa
        jmp  tfn06
tfn02:
        ldi_ m_word [REL (cfp_b*1)+xr]
        sti_ w0
        or   w0,w0
        jge  tfn06
        ngi_
        iov_ tfn06
        jmp  tfn06
tfn03:
        mov  wa,m_word [ xr]
        jmp  tfn01
tfn04:
        mov  wa,m_word [REL (cfp_b*nmofs)+xr]
        jmp  tfn01
tfn05:
        call hashs
tfn06:
        rmi_ m_word [REL tfnsi]
        sti_ wc
        sal  wc,log_cfp_b
        mov  xl,m_word [ xs]
        add  xl,wc
        mov  xr,m_word [REL (cfp_b*tbbuk)+xl]
        cmp  xr,m_word [ xs]
        je   tfn10
tfn07:
        mov  wb,xr
        mov  xr,m_word [REL (cfp_b*tesub)+xr]
        mov  xl,m_word [REL (cfp_b*1)+xs]
        call ident
        dec  m_word [_rc_]
        js   call_269
        dec  m_word [_rc_]
        jns  _l0476
        jmp  tfn08
_l0476:
call_269:
        mov  xl,wb
        mov  xr,m_word [REL (cfp_b*tenxt)+xl]
        cmp  xr,m_word [ xs]
        jne  tfn07
        mov  wc,cfp_b*tenxt
        jmp  tfn11
tfn08:
        mov  xl,wb
        mov  wa,cfp_b*teval
        mov  wb,m_word [REL (cfp_b*2)+xs]
        or   wb,wb
        jnz  tfn09
        call acess
        dec  m_word [_rc_]
        js   call_270
        dec  m_word [_rc_]
        jns  _l0477
        jmp  tfn12
_l0477:
call_270:
        xor  wb,wb
tfn09:
        add  xs,cfp_b*num03
        mov  m_word [_rc_],0
        ret
tfn10:
        add  wc,cfp_b*tbbuk
        mov  xl,m_word [ xs]
tfn11:
        mov  xr,m_word [ xs]
        mov  xr,m_word [REL (cfp_b*tbinv)+xr]
        mov  wb,m_word [REL (cfp_b*2)+xs]
        or   wb,wb
        jz   tfn09
        mov  wb,xr
        mov  wa,cfp_b*tesi_
        call alloc
        add  xl,wc
        mov  m_word [ xl],xr
        mov  m_word [ xr],b_tet
        mov  m_word [REL (cfp_b*teval)+xr],wb
        pop  m_word [REL (cfp_b*tenxt)+xr]
        pop  m_word [REL (cfp_b*tesub)+xr]
        pop  wb
        mov  xl,xr
        mov  wa,cfp_b*teval
        mov  m_word [_rc_],0
        ret
tfn12:
        mov  m_word [_rc_],1
        ret
tmake:
        mov  wa,wc
        add  wa,tbsi_
        sal  wa,log_cfp_b
        call alloc
        mov  wb,xr
        mov  w0,b_tbt
        stos_w
        mov  w0,0
        stos_w
        mov  w0,wa
        stos_w
        mov  w0,xl
        stos_w
tma01:
        mov  w0,wb
        stos_w
        dec  wc
        jnz  tma01
        mov  xr,wb
        ret
vmake:
        mov  wb,wa
        add  wa,vcsi_
        sal  wa,log_cfp_b
        cmp  wa,m_word [REL mxlen]
        ja   vmak2
        call alloc
        mov  m_word [ xr],b_vct
        mov  w0,0
        mov  m_word [REL (cfp_b*idval)+xr],w0
        mov  m_word [REL (cfp_b*vclen)+xr],wa
        mov  wc,xl
        mov  xl,xr
        add  xl,cfp_b*vcvls
vmak1:
        mov  m_word [REL xl],wc
        lea  xl,[xl+cfp_b]
        dec  wb
        jnz  vmak1
        mov  m_word [_rc_],0
        ret
vmak2:
        mov  m_word [_rc_],1
        ret
scane:
        mov  w0,0
        mov  m_word [REL scnbl],w0
        mov  m_word [REL scnsa],wa
        mov  m_word [REL scnsb],wb
        mov  m_word [REL scnsc],wc
        cmp  m_word [REL scnrs],0
        jz   scn03
        mov  xl,m_word [REL scntp]
        mov  xr,m_word [REL r_scp]
        mov  w0,0
        mov  m_word [REL scnrs],w0
        jmp  scn13
scn01:
        call readr
        mov  wb,cfp_b*dvubs
        or   xr,xr
        jz   scn30
        add  xr,cfp_f
        mov  w0,0
        mov  al,m_char [xr]
        mov  wc,w0
        cmp  wc,ch_dt
        je   scn02
        cmp  wc,ch_pl
        jne  scn30
scn02:
        call nexts
        mov  m_word [REL scnpt],num01
        mov  m_word [REL scnbl],xs
scn03:
        mov  wa,m_word [REL scnpt]
        cmp  wa,m_word [REL scnil]
        je   scn01
        mov  xl,m_word [REL r_cim]
        lea  xl,[cfp_f+xl+wa]
        mov  m_word [REL scnse],wa
        mov  wc,opdvs
        mov  wb,cfp_b*dvubs
        jmp  scn06
scn05:
        or   wb,wb
        jz   scn10
        inc  m_word [REL scnse]
        cmp  wa,m_word [REL scnil]
        je   scn01
        mov  m_word [REL scnbl],xs
scn06:
        mov  w0,0
        mov  al,m_char [xl]
        mov  xr,w0
        inc  xl
        inc  wa
        mov  m_word [REL scnpt],wa
        cmp  xr,cfp_u
        jge  scn07
        jmp  m_word [_l0478+xr*cfp_b]
        segment .data
_l0478:
        d_word scn07
        d_word scn07
        d_word scn07
        d_word scn07
        d_word scn07
        d_word scn07
        d_word scn07
        d_word scn07
        d_word scn07
        d_word scn05
        d_word scn07
        d_word scn07
        d_word scn07
        d_word scn07
        d_word scn07
        d_word scn07
        d_word scn07
        d_word scn07
        d_word scn07
        d_word scn07
        d_word scn07
        d_word scn07
        d_word scn07
        d_word scn07
        d_word scn07
        d_word scn07
        d_word scn07
        d_word scn07
        d_word scn07
        d_word scn07
        d_word scn07
        d_word scn07
        d_word scn05
        d_word scn37
        d_word scn17
        d_word scn41
        d_word scn36
        d_word scn38
        d_word scn44
        d_word scn16
        d_word scn25
        d_word scn26
        d_word scn49
        d_word scn33
        d_word scn31
        d_word scn34
        d_word scn32
        d_word scn40
        d_word scn08
        d_word scn08
        d_word scn08
        d_word scn08
        d_word scn08
        d_word scn08
        d_word scn08
        d_word scn08
        d_word scn08
        d_word scn08
        d_word scn29
        d_word scn30
        d_word scn28
        d_word scn46
        d_word scn27
        d_word scn45
        d_word scn42
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn20
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn21
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn28
        d_word scn07
        d_word scn27
        d_word scn37
        d_word scn24
        d_word scn07
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn20
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn21
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn09
        d_word scn07
        d_word scn43
        d_word scn07
        d_word scn35
        d_word scn07
        segment .text
scn07:
        or   wb,wb
        jz   scn10
        mov  m_word [_rc_],230
        jmp  err_
scn08:
        or   wb,wb
        jz   scn09
        xor  wc,wc
scn09:
        cmp  wa,m_word [REL scnil]
        je   scn11
        xor  wb,wb
        jmp  scn06
scn10:
        dec  wa
scn11:
        mov  m_word [REL scnpt],wa
        mov  wb,m_word [REL scnse]
        sub  wa,wb
        mov  xl,m_word [REL r_cim]
        or   wc,wc
        jnz  scn15
        call sbstr
        mov  m_word [REL dnamp],xr
        call gtnum
        dec  m_word [_rc_]
        js   call_271
        dec  m_word [_rc_]
        jns  _l0479
        jmp  scn14
_l0479:
call_271:
scn12:
        mov  xl,t_con
scn13:
        mov  wa,m_word [REL scnsa]
        mov  wb,m_word [REL scnsb]
        mov  wc,m_word [REL scnsc]
        mov  m_word [REL r_scp],xr
        mov  m_word [REL scntp],xl
        mov  w0,0
        mov  m_word [REL scngo],w0
        ret
scn14:
        mov  m_word [_rc_],231
        jmp  err_
scn15:
        call sbstr
        cmp  m_word [REL scncc],0
        jnz  scn13
        call gtnvr
        dec  m_word [_rc_]
        js   call_272
        dec  m_word [_rc_]
        jns  _l0480
        mov  m_word [_rc_],299
        jmp  err_
_l0480:
call_272:
        mov  xl,t_var
        jmp  scn13
scn16:
        or   wb,wb
        jz   scn10
        mov  wb,ch_sq
        jmp  scn18
scn17:
        or   wb,wb
        jz   scn10
        mov  wb,ch_dq
scn18:
        cmp  wa,m_word [REL scnil]
        je   scn19
        mov  w0,0
        mov  al,m_char [xl]
        mov  wc,w0
        inc  xl
        inc  wa
        cmp  wc,wb
        jne  scn18
        mov  wb,m_word [REL scnpt]
        mov  m_word [REL scnpt],wa
        dec  wa
        sub  wa,wb
        mov  xl,m_word [REL r_cim]
        call sbstr
        jmp  scn12
scn19:
        mov  m_word [REL scnpt],wa
        mov  m_word [_rc_],232
        jmp  err_
scn20:
        mov  xr,t_fgo
        jmp  scn22
scn21:
        mov  xr,t_sgo
scn22:
        cmp  m_word [REL scngo],0
        jz   scn09
scn23:
        or   wb,wb
        jz   scn10
        mov  xl,xr
        jmp  scn13
scn24:
        or   wb,wb
        jz   scn09
        jmp  scn07
scn25:
        mov  xr,t_lpr
        or   wb,wb
        jnz  scn23
        or   wc,wc
        jz   scn10
        mov  wb,m_word [REL scnse]
        mov  m_word [REL scnpt],wa
        dec  wa
        sub  wa,wb
        mov  xl,m_word [REL r_cim]
        call sbstr
        call gtnvr
        dec  m_word [_rc_]
        js   call_273
        dec  m_word [_rc_]
        jns  _l0481
        mov  m_word [_rc_],299
        jmp  err_
_l0481:
call_273:
        mov  xl,t_fnc
        jmp  scn13
scn26:
        mov  xr,t_rpr
        jmp  scn23
scn27:
        mov  xr,t_rbr
        jmp  scn23
scn28:
        mov  xr,t_lbr
        jmp  scn23
scn29:
        mov  xr,t_col
        jmp  scn23
scn30:
        mov  xr,t_smc
        jmp  scn23
scn31:
        mov  xr,t_cma
        jmp  scn23
scn32:
        or   wb,wb
        jz   scn09
        add  wc,wb
scn33:
        or   wc,wc
        jz   scn09
        or   wb,wb
        jz   scn48
        add  wc,wb
scn34:
        or   wc,wc
        jz   scn09
        or   wb,wb
        jz   scn48
        add  wc,wb
scn35:
        add  wc,wb
scn36:
        add  wc,wb
scn37:
        add  wc,wb
scn38:
        add  wc,wb
scn39:
        add  wc,wb
scn40:
        add  wc,wb
scn41:
        add  wc,wb
scn42:
        add  wc,wb
scn43:
        add  wc,wb
scn44:
        add  wc,wb
scn45:
        add  wc,wb
scn46:
        or   wb,wb
        jz   scn10
        mov  xr,wc
        mov  w0,0
        mov  al,m_char [xl]
        mov  wc,w0
        mov  xl,t_bop
        cmp  wa,m_word [REL scnil]
        je   scn47
        cmp  wc,ch_bl
        je   scn47
        cmp  wc,ch_ht
        je   scn47
        cmp  wc,ch_sm
        je   scn47
        cmp  wc,ch_cl
        je   scn47
        cmp  wc,ch_rp
        je   scn47
        cmp  wc,ch_rb
        je   scn47
        cmp  wc,ch_cb
        je   scn47
        add  xr,cfp_b*dvbs_
        mov  xl,t_uop
        cmp  m_word [REL scntp],t_uok
        jbe  scn13
scn47:
        cmp  m_word [REL scnbl],0
        jnz  scn13
scn48:
        mov  m_word [_rc_],233
        jmp  err_
scn49:
        or   wb,wb
        jz   scn10
        cmp  wa,m_word [REL scnil]
        je   scn39
        mov  xr,wa
        mov  m_word [REL scnof],wa
        mov  w0,0
        mov  al,m_char [xl]
        mov  wa,w0
        inc  xl
        cmp  wa,ch_as
        jne  scn50
        inc  xr
        cmp  xr,m_word [REL scnil]
        je   scn51
        mov  w0,0
        mov  al,m_char [xl]
        mov  wa,w0
        cmp  wa,ch_bl
        je   scn51
        cmp  wa,ch_ht
        je   scn51
scn50:
        mov  wa,m_word [REL scnof]
        mov  xl,m_word [REL r_cim]
        lea  xl,[cfp_f+xl+wa]
        jmp  scn39
scn51:
        mov  m_word [REL scnpt],xr
        mov  wa,xr
        jmp  scn37
scngf:
        call scane
        cmp  xl,t_lpr
        je   scng1
        cmp  xl,t_lbr
        je   scng2
        mov  m_word [_rc_],234
        jmp  err_
scng1:
        mov  wb,num01
        call expan
        mov  wa,opdvn
        cmp  xr,m_word [REL statb]
        jbe  scng3
        cmp  xr,m_word [REL state]
        jb   scng4
        jmp  scng3
scng2:
        mov  wb,num02
        call expan
        mov  wa,opdvd
scng3:
        push wa
        push xr
        call expop
        pop  xr
scng4:
        ret
setvr:
        cmp  xr,m_word [REL state]
        ja   setv1
        mov  xl,xr
        mov  m_word [REL (cfp_b*vrget)+xr],b_vrl
        cmp  m_word [REL (cfp_b*vrsto)+xr],b_vre
        je   setv1
        mov  m_word [REL (cfp_b*vrsto)+xr],b_vrs
        mov  xl,m_word [REL (cfp_b*vrval)+xl]
        cmp  m_word [ xl],b_trt
        jne  setv1
        mov  m_word [REL (cfp_b*vrget)+xr],b_vra
        mov  m_word [REL (cfp_b*vrsto)+xr],b_vrv
setv1:
        ret
sorta:
        pop  m_word [prc_+cfp_b*15]
        mov  m_word [REL srtsr],wa
        mov  m_word [REL srtst],cfp_b*num01
        mov  w0,0
        mov  m_word [REL srtof],w0
        mov  m_word [REL srtdf],nulls
        pop  m_word [REL r_sxr]
        pop  xr
        mov  wa,xs
        call gtarr
        dec  m_word [_rc_]
        js   call_274
        dec  m_word [_rc_]
        jns  _l0482
        jmp  srt18
_l0482:
        dec  m_word [_rc_]
        jns  _l0483
        jmp  srt16
_l0483:
call_274:
        push xr
        push xr
        call copyb
        dec  m_word [_rc_]
        js   call_275
        dec  m_word [_rc_]
        jns  _l0484
        mov  m_word [_rc_],299
        jmp  err_
_l0484:
call_275:
        push xr
        mov  xr,m_word [REL r_sxr]
        mov  xl,m_word [REL (cfp_b*num01)+xs]
        cmp  m_word [ xl],b_vct
        jne  srt02
        cmp  xr,nulls
        je   srt01
        call gtnvr
        dec  m_word [_rc_]
        js   call_276
        dec  m_word [_rc_]
        jns  _l0485
        mov  m_word [_rc_],257
        jmp  err_
_l0485:
call_276:
        mov  m_word [REL srtdf],xr
srt01:
        mov  wc,cfp_b*vclen
        mov  wb,cfp_b*vcvls
        mov  wa,m_word [REL (cfp_b*vclen)+xl]
        sub  wa,cfp_b*vcsi_
        jmp  srt04
srt02:
        ldi_ m_word [REL (cfp_b*ardim)+xl]
        sti_ wa
        sal  wa,log_cfp_b
        mov  wb,cfp_b*arvls
        mov  wc,cfp_b*arpro
        cmp  m_word [REL (cfp_b*arndm)+xl],num01
        je   srt04
        cmp  m_word [REL (cfp_b*arndm)+xl],num02
        jne  srt16
        ldi_ m_word [REL (cfp_b*arlb2)+xl]
        cmp  xr,nulls
        je   srt03
        call gtint
        dec  m_word [_rc_]
        js   call_277
        dec  m_word [_rc_]
        jns  _l0486
        jmp  srt17
_l0486:
call_277:
        ldi_ m_word [REL (cfp_b*icval)+xr]
srt03:
        sbi_ m_word [REL (cfp_b*arlb2)+xl]
        iov_ srt17
        sti_ w0
        or   w0,w0
        jl   srt17
        sbi_ m_word [REL (cfp_b*ardm2)+xl]
        sti_ w0
        or   w0,w0
        jge  srt17
        adi_ m_word [REL (cfp_b*ardm2)+xl]
        sti_ wa
        sal  wa,log_cfp_b
        mov  m_word [REL srtof],wa
        ldi_ m_word [REL (cfp_b*ardm2)+xl]
        sti_ wa
        mov  xr,wa
        sal  wa,log_cfp_b
        mov  m_word [REL srtst],wa
        ldi_ m_word [REL (cfp_b*ardim)+xl]
        sti_ wa
        sal  wa,log_cfp_b
        mov  wc,m_word [REL (cfp_b*arlen)+xl]
        sub  wc,wa
        sub  wc,cfp_b
        mov  wb,m_word [REL (cfp_b*arofs)+xl]
        add  wb,cfp_b
srt04:
        cmp  wa,cfp_b*num01
        jbe  srt15
        mov  m_word [REL srtsn],wa
        mov  m_word [REL srtso],wc
        mov  wc,m_word [REL (cfp_b*arlen)+xl]
        add  wc,xl
        mov  m_word [REL srtsf],wb
        add  xl,wb
srt05:
        mov  xr,m_word [ xl]
srt06:
        cmp  m_word [ xr],b_trt
        jne  srt07
        mov  xr,m_word [REL (cfp_b*trval)+xr]
        jmp  srt06
srt07:
        mov  m_word [REL xl],xr
        lea  xl,[xl+cfp_b]
        cmp  xl,wc
        jb   srt05
        mov  xl,m_word [ xs]
        mov  xr,m_word [REL srtsf]
        mov  wb,m_word [REL srtst]
        add  xl,m_word [REL srtso]
        add  xl,cfp_b
        mov  wc,m_word [REL srtsn]
        shr  wc,log_cfp_b
        mov  m_word [REL srtnr],wc
srt08:
        mov  m_word [REL xl],xr
        lea  xl,[xl+cfp_b]
        add  xr,wb
        dec  wc
        jnz  srt08
srt09:
        mov  wa,m_word [REL srtsn]
        mov  wc,m_word [REL srtnr]
        shr  wc,1
        sal  wc,log_cfp_b
srt10:
        call sorth
        sub  wc,cfp_b
        or   wc,wc
        jnz  srt10
        mov  wc,wa
srt11:
        sub  wc,cfp_b
        or   wc,wc
        jz   srt12
        mov  xr,m_word [ xs]
        add  xr,m_word [REL srtso]
        mov  xl,xr
        add  xl,wc
        mov  wb,m_word [REL (cfp_b*num01)+xl]
        mov  w0,m_word [REL (cfp_b*num01)+xr]
        mov  m_word [REL (cfp_b*num01)+xl],w0
        mov  m_word [REL (cfp_b*num01)+xr],wb
        mov  wa,wc
        mov  wc,cfp_b*num01
        call sorth
        mov  wc,wa
        jmp  srt11
srt12:
        mov  xr,m_word [ xs]
        mov  wc,xr
        add  wc,m_word [REL srtso]
        add  xr,m_word [REL srtsf]
        mov  wb,m_word [REL srtst]
srt13:
        add  wc,cfp_b
        mov  xl,wc
        mov  xl,m_word [ xl]
        add  xl,m_word [REL (cfp_b*num01)+xs]
        mov  wa,wb
        shr  wa,log_cfp_b
        rep  movs_w
        dec  m_word [REL srtnr]
        cmp  m_word [REL srtnr],0
        jnz  srt13
srt15:
        pop  xr
        add  xs,cfp_b
        mov  w0,0
        mov  m_word [REL r_sxl],w0
        mov  w0,0
        mov  m_word [REL r_sxr],w0
        mov  m_word [_rc_],0
        mov  w0,m_word [prc_+cfp_b*15]
        jmp  w0
srt16:
        mov  m_word [_rc_],256
        jmp  err_
srt17:
        mov  m_word [_rc_],258
        jmp  err_
srt18:
        mov  m_word [_rc_],1
        mov  w0,m_word [prc_+cfp_b*15]
        jmp  w0
sortc:
        mov  m_word [REL srts1],wa
        mov  m_word [REL srts2],wb
        mov  m_word [REL srtsc],wc
        add  xl,m_word [REL srtof]
        mov  xr,xl
        add  xl,wa
        add  xr,wb
        mov  xl,m_word [ xl]
        mov  xr,m_word [ xr]
        cmp  m_word [REL srtdf],nulls
        jne  src12
src01:
        mov  wc,m_word [ xl]
        cmp  wc,m_word [ xr]
        jne  src02
        cmp  wc,b_scl
        je   src09
        cmp  wc,b_icl
        je   src14
src02:
        mov  m_word [REL r_sxl],xl
        mov  m_word [REL r_sxr],xr
        cmp  wc,b_scl
        je   src11
        cmp  m_word [ xr],b_scl
        je   src11
src14:
        push xl
        push xr
        call acomp
        dec  m_word [_rc_]
        js   call_278
        dec  m_word [_rc_]
        jns  _l0487
        jmp  src10
_l0487:
        dec  m_word [_rc_]
        jns  _l0488
        jmp  src10
_l0488:
        dec  m_word [_rc_]
        jns  _l0489
        jmp  src03
_l0489:
        dec  m_word [_rc_]
        jns  _l0490
        jmp  src08
_l0490:
        dec  m_word [_rc_]
        jns  _l0491
        jmp  src05
_l0491:
call_278:
src03:
        cmp  m_word [REL srtsr],0
        jnz  src06
src04:
        mov  wc,m_word [REL srtsc]
        mov  m_word [_rc_],1
        ret
src05:
        cmp  m_word [REL srtsr],0
        jnz  src04
src06:
        mov  wc,m_word [REL srtsc]
        mov  m_word [_rc_],0
        ret
src07:
        cmp  xl,xr
        jb   src03
        cmp  xl,xr
        ja   src05
src08:
        mov  w0,m_word [REL srts2]
        cmp  m_word [REL srts1],w0
        jb   src04
        jmp  src06
src09:
        push xl
        push xr
        call lcomp
        dec  m_word [_rc_]
        js   call_279
        dec  m_word [_rc_]
        jns  _l0492
        mov  m_word [_rc_],299
        jmp  err_
_l0492:
        dec  m_word [_rc_]
        jns  _l0493
        mov  m_word [_rc_],299
        jmp  err_
_l0493:
        dec  m_word [_rc_]
        jns  _l0494
        jmp  src03
_l0494:
        dec  m_word [_rc_]
        jns  _l0495
        jmp  src08
_l0495:
        dec  m_word [_rc_]
        jns  _l0496
        jmp  src05
_l0496:
call_279:
src10:
        mov  xl,m_word [REL r_sxl]
        mov  xr,m_word [REL r_sxr]
        mov  wc,m_word [ xl]
        cmp  wc,m_word [ xr]
        je   src07
src11:
        mov  xl,wc
        mov  xr,m_word [ xr]
        movzx xl,byte [xl-1]
        movzx xr,byte [xr-1]
        cmp  xl,xr
        ja   src05
        jmp  src03
src12:
        call sortf
        push xl
        mov  xl,xr
        call sortf
        mov  xr,xl
        pop  xl
        jmp  src01
sortf:
        cmp  m_word [ xl],b_pdt
        jne  srtf3
        push xr
        mov  xr,m_word [REL srtfd]
        or   xr,xr
        jz   srtf4
        cmp  xr,m_word [REL (cfp_b*pddfp)+xl]
        jne  srtf4
        mov  w0,m_word [REL srtff]
        cmp  m_word [REL srtdf],w0
        jne  srtf4
        add  xl,m_word [REL srtfo]
srtf1:
        mov  xl,m_word [ xl]
srtf2:
        pop  xr
srtf3:
        ret
srtf4:
        mov  xr,xl
        mov  xr,m_word [REL (cfp_b*pddfp)+xr]
        mov  m_word [REL srtfd],xr
        mov  wc,m_word [REL (cfp_b*fargs)+xr]
        sal  wc,log_cfp_b
        add  xr,m_word [REL (cfp_b*dflen)+xr]
srtf5:
        sub  wc,cfp_b
        sub  xr,cfp_b
        mov  w0,m_word [REL srtdf]
        cmp  m_word [ xr],w0
        je   srtf6
        or   wc,wc
        jnz  srtf5
        jmp  srtf2
srtf6:
        mov  w0,m_word [ xr]
        mov  m_word [REL srtff],w0
        add  wc,cfp_b*pdfld
        mov  m_word [REL srtfo],wc
        add  xl,wc
        jmp  srtf1
sorth:
        pop  m_word [prc_+cfp_b*16]
        mov  m_word [REL srtsn],wa
        mov  m_word [REL srtwc],wc
        mov  xl,m_word [ xs]
        add  xl,m_word [REL srtso]
        add  xl,wc
        mov  w0,m_word [ xl]
        mov  m_word [REL srtrt],w0
        add  wc,wc
srh01:
        cmp  wc,m_word [REL srtsn]
        ja   srh03
        cmp  wc,m_word [REL srtsn]
        je   srh02
        mov  xr,m_word [ xs]
        mov  xl,m_word [REL (cfp_b*num01)+xs]
        add  xr,m_word [REL srtso]
        add  xr,wc
        mov  wa,m_word [REL (cfp_b*num01)+xr]
        mov  wb,m_word [ xr]
        call sortc
        dec  m_word [_rc_]
        js   call_280
        dec  m_word [_rc_]
        jns  _l0497
        jmp  srh02
_l0497:
call_280:
        add  wc,cfp_b
srh02:
        mov  xl,m_word [REL (cfp_b*num01)+xs]
        mov  xr,m_word [ xs]
        add  xr,m_word [REL srtso]
        mov  wb,xr
        add  xr,wc
        mov  wa,m_word [ xr]
        mov  xr,wb
        mov  wb,m_word [REL srtrt]
        call sortc
        dec  m_word [_rc_]
        js   call_281
        dec  m_word [_rc_]
        jns  _l0498
        jmp  srh03
_l0498:
call_281:
        mov  xr,m_word [ xs]
        add  xr,m_word [REL srtso]
        mov  xl,xr
        mov  wa,wc
        shr  wc,log_cfp_b
        shr  wc,1
        sal  wc,log_cfp_b
        add  xl,wa
        add  xr,wc
        mov  w0,m_word [ xl]
        mov  m_word [ xr],w0
        mov  wc,wa
        add  wc,wc
        jc   srh03
        jmp  srh01
srh03:
        shr  wc,log_cfp_b
        shr  wc,1
        sal  wc,log_cfp_b
        mov  xr,m_word [ xs]
        add  xr,m_word [REL srtso]
        add  xr,wc
        mov  w0,m_word [REL srtrt]
        mov  m_word [ xr],w0
        mov  wa,m_word [REL srtsn]
        mov  wc,m_word [REL srtwc]
        mov  m_word [_rc_],0
        mov  w0,m_word [prc_+cfp_b*16]
        jmp  w0
trace:
        pop  m_word [prc_+cfp_b*17]
        call gtstg
        dec  m_word [_rc_]
        js   call_282
        dec  m_word [_rc_]
        jns  _l0499
        jmp  trc15
_l0499:
call_282:
        add  xr,cfp_f
        mov  w0,0
        mov  al,m_char [xr]
        mov  wa,w0
        cmp  wa_l,'A'
        jb   _l0500
        cmp  wa_l,'Z'
        ja   _l0500
        add  wa_l,32
_l0500:
        mov  xr,m_word [ xs]
        mov  m_word [ xs],xl
        mov  wc,trtac
        cmp  wa,ch_la
        je   trc10
        mov  wc,trtvl
        cmp  wa,ch_lv
        je   trc10
        cmp  wa,ch_bl
        je   trc10
        cmp  wa,ch_lf
        je   trc01
        cmp  wa,ch_lr
        je   trc01
        cmp  wa,ch_ll
        je   trc03
        cmp  wa,ch_lk
        je   trc06
        cmp  wa,ch_lc
        jne  trc15
trc01:
        call gtnvr
        dec  m_word [_rc_]
        js   call_283
        dec  m_word [_rc_]
        jns  _l0501
        jmp  trc16
_l0501:
call_283:
        add  xs,cfp_b
        mov  xr,m_word [REL (cfp_b*vrfnc)+xr]
        cmp  m_word [ xr],b_pfc
        jne  trc17
        cmp  wa,ch_lr
        je   trc02
        mov  m_word [REL (cfp_b*pfctr)+xr],xl
        cmp  wa,ch_lc
        je   exnul
trc02:
        mov  m_word [REL (cfp_b*pfrtr)+xr],xl
        mov  m_word [_rc_],0
        mov  w0,m_word [prc_+cfp_b*17]
        jmp  w0
trc03:
        call gtnvr
        dec  m_word [_rc_]
        js   call_284
        dec  m_word [_rc_]
        jns  _l0502
        jmp  trc16
_l0502:
call_284:
        mov  xl,m_word [REL (cfp_b*vrlbl)+xr]
        cmp  m_word [ xl],b_trt
        jne  trc04
        mov  xl,m_word [REL (cfp_b*trlbl)+xl]
trc04:
        cmp  xl,stndl
        je   trc16
        pop  wb
        or   wb,wb
        jz   trc05
        mov  m_word [REL (cfp_b*vrlbl)+xr],wb
        mov  m_word [REL (cfp_b*vrtra)+xr],b_vrt
        mov  xr,wb
        mov  m_word [REL (cfp_b*trlbl)+xr],xl
        mov  m_word [_rc_],0
        mov  w0,m_word [prc_+cfp_b*17]
        jmp  w0
trc05:
        mov  m_word [REL (cfp_b*vrlbl)+xr],xl
        mov  m_word [REL (cfp_b*vrtra)+xr],b_vrg
        mov  m_word [_rc_],0
        mov  w0,m_word [prc_+cfp_b*17]
        jmp  w0
trc06:
        call gtnvr
        dec  m_word [_rc_]
        js   call_285
        dec  m_word [_rc_]
        jns  _l0503
        jmp  trc16
_l0503:
call_285:
        cmp  m_word [REL (cfp_b*vrlen)+xr],0
        jnz  trc16
        add  xs,cfp_b
        or   xl,xl
        jz   trc07
        mov  m_word [REL (cfp_b*trkvr)+xl],xr
trc07:
        mov  xr,m_word [REL (cfp_b*vrsvp)+xr]
        cmp  xr,v_ert
        je   trc08
        cmp  xr,v_stc
        je   trc09
        cmp  xr,v_fnc
        jne  trc17
        mov  m_word [REL r_fnc],xl
        mov  m_word [_rc_],0
        mov  w0,m_word [prc_+cfp_b*17]
        jmp  w0
trc08:
        mov  m_word [REL r_ert],xl
        mov  m_word [_rc_],0
        mov  w0,m_word [prc_+cfp_b*17]
        jmp  w0
trc09:
        mov  m_word [REL r_stc],xl
        call stgcc
        mov  m_word [_rc_],0
        mov  w0,m_word [prc_+cfp_b*17]
        jmp  w0
trc10:
        call gtvar
        dec  m_word [_rc_]
        js   call_286
        dec  m_word [_rc_]
        jns  _l0504
        jmp  trc16
_l0504:
call_286:
        pop  wb
        add  wa,xl
        mov  xr,wa
trc11:
        mov  xl,m_word [ xr]
        cmp  m_word [ xl],b_trt
        jne  trc13
        cmp  wc,m_word [REL (cfp_b*trtyp)+xl]
        jb   trc13
        cmp  wc,m_word [REL (cfp_b*trtyp)+xl]
        je   trc12
        add  xl,cfp_b*trnxt
        mov  xr,xl
        jmp  trc11
trc12:
        mov  xl,m_word [REL (cfp_b*trnxt)+xl]
        mov  m_word [ xr],xl
trc13:
        or   wb,wb
        jz   trc14
        mov  m_word [ xr],wb
        mov  xr,wb
        mov  m_word [REL (cfp_b*trnxt)+xr],xl
        mov  m_word [REL (cfp_b*trtyp)+xr],wc
trc14:
        mov  xr,wa
        sub  xr,cfp_b*vrval
        call setvr
        mov  m_word [_rc_],0
        mov  w0,m_word [prc_+cfp_b*17]
        jmp  w0
trc15:
        mov  m_word [_rc_],2
        mov  w0,m_word [prc_+cfp_b*17]
        jmp  w0
trc16:
        add  xs,cfp_b
trc17:
        mov  m_word [_rc_],1
        mov  w0,m_word [prc_+cfp_b*17]
        jmp  w0
trbld:
        push xr
        mov  wa,cfp_b*trsi_
        call alloc
        mov  m_word [ xr],b_trt
        mov  m_word [REL (cfp_b*trfnc)+xr],xl
        pop  m_word [REL (cfp_b*trtag)+xr]
        mov  m_word [REL (cfp_b*trtyp)+xr],wb
        mov  m_word [REL (cfp_b*trval)+xr],nulls
        ret
trimr:
        mov  xl,xr
        mov  wa,m_word [REL (cfp_b*sclen)+xr]
        or   wa,wa
        jz   trim2
        lea  xl,[cfp_f+xl+wa]
        or   wb,wb
        jz   trim3
        mov  wc,ch_bl
trim0:
        dec  xl
        mov  w0,0
        mov  al,m_char [xl]
        mov  wb,w0
        cmp  wb,ch_ht
        je   trim1
        cmp  wb,wc
        jne  trim3
trim1:
        dec  wa
        or   wa,wa
        jnz  trim0
trim2:
        mov  m_word [REL dnamp],xr
        mov  xr,nulls
        jmp  trim5
trim3:
        mov  m_word [REL (cfp_b*sclen)+xr],wa
        mov  xl,xr
        lea  xl,[cfp_f+xl+wa]
        add  wa,(cfp_b-1)+cfp_b*schar
        and  wa,-cfp_b
        add  wa,xr
        mov  m_word [REL dnamp],wa
        mov  wa,cfp_c
        xor  wc,wc
trim4:
        mov  m_char [xl],wc_l
        inc  xl
        dec  wa
        jnz  trim4
trim5:
        xor  xl,xl
        ret
trxeq:
        mov  wc,m_word [REL r_cod]
        scp_ wb
        sub  wb,wc
        push m_word [REL kvtra]
        push xr
        push xl
        push wa
        push wc
        push wb
        push m_word [REL flptr]
        push 0
        mov  m_word [REL flptr],xs
        mov  w0,0
        mov  m_word [REL kvtra],w0
        mov  wc,trxdc
        mov  m_word [REL r_cod],wc
        lcp_ wc
        mov  wb,wa
        mov  wa,cfp_b*nmsi_
        call alloc
        mov  m_word [ xr],b_nml
        mov  m_word [REL (cfp_b*nmbas)+xr],xl
        mov  m_word [REL (cfp_b*nmofs)+xr],wb
        mov  xl,m_word [REL (cfp_b*6)+xs]
        push xr
        push m_word [REL (cfp_b*trtag)+xl]
        mov  xl,m_word [REL (cfp_b*trfnc)+xl]
        mov  xl,m_word [REL (cfp_b*vrfnc)+xl]
        cmp  xl,stndf
        je   trxq2
        mov  wa,num02
        jmp  cfunc
trxq1:
        mov  xs,m_word [REL flptr]
        add  xs,cfp_b
        pop  m_word [REL flptr]
        pop  wb
        pop  wc
        mov  xr,wc
        mov  w0,m_word [REL (cfp_b*cdstm)+xr]
        mov  m_word [REL kvstn],w0
        pop  wa
        pop  xl
        pop  xr
        pop  m_word [REL kvtra]
        add  wb,wc
        lcp_ wb
        mov  m_word [REL r_cod],wc
        ret
trxq2:
        mov  m_word [_rc_],197
        jmp  err_
xscan:
        mov  m_word [REL xscwb],wb
        push wa
        push wa
        mov  xr,m_word [REL r_xsc]
        mov  wa,m_word [REL (cfp_b*sclen)+xr]
        mov  wb,m_word [REL xsofs]
        sub  wa,wb
        or   wa,wa
        jz   xscn3
        lea  xr,[cfp_f+xr+wb]
xscn1:
        mov  w0,0
        mov  al,m_char [xr]
        mov  wb,w0
        inc  xr
        cmp  wb,wc
        je   xscn4
        cmp  wb,xl
        je   xscn5
        cmp  m_word [ xs],0
        jz   xscn2
        inc  m_word [REL xsofs]
        cmp  wb,ch_ht
        je   xscn2
        cmp  wb,ch_bl
        je   xscn2
        dec  m_word [REL xsofs]
        mov  w0,0
        mov  m_word [ xs],w0
xscn2:
        dec  wa
        or   wa,wa
        jnz  xscn1
xscn3:
        mov  xl,m_word [REL r_xsc]
        mov  wa,m_word [REL (cfp_b*sclen)+xl]
        mov  wb,m_word [REL xsofs]
        sub  wa,wb
        mov  w0,0
        mov  m_word [REL r_xsc],w0
        mov  w0,0
        mov  m_word [REL xscrt],w0
        jmp  xscn7
xscn4:
        mov  m_word [REL xscrt],num01
        jmp  xscn6
xscn5:
        mov  m_word [REL xscrt],num02
xscn6:
        mov  xl,m_word [REL r_xsc]
        mov  wc,m_word [REL (cfp_b*sclen)+xl]
        sub  wc,wa
        mov  wa,wc
        mov  wb,m_word [REL xsofs]
        sub  wa,wb
        inc  wc
        mov  m_word [REL xsofs],wc
xscn7:
        xor  xr,xr
        call sbstr
        add  xs,cfp_b
        pop  wb
        cmp  m_word [REL (cfp_b*sclen)+xr],0
        jz   xscn8
        call trimr
xscn8:
        mov  wa,m_word [REL xscrt]
        mov  wb,m_word [REL xscwb]
        ret
xscni:
        pop  m_word [prc_+cfp_b*18]
        call gtstg
        dec  m_word [_rc_]
        js   call_287
        dec  m_word [_rc_]
        jns  _l0505
        jmp  xsci1
_l0505:
call_287:
        mov  m_word [REL r_xsc],xr
        mov  w0,0
        mov  m_word [REL xsofs],w0
        or   wa,wa
        jz   xsci2
        mov  m_word [_rc_],0
        mov  w0,m_word [prc_+cfp_b*18]
        jmp  w0
xsci1:
        mov  m_word [_rc_],1
        mov  w0,m_word [prc_+cfp_b*18]
        jmp  w0
xsci2:
        mov  m_word [_rc_],2
        mov  w0,m_word [prc_+cfp_b*18]
        jmp  w0
        global sec06
sec06:  nop
        add  m_word [REL errft],num04
        mov  xs,m_word [REL flptr]
        cmp  m_word [REL gbcfl],0
        jnz  stak1
        mov  m_word [_rc_],246
        jmp  err_
stak1:
        mov  xr,endso
        mov  w0,0
        mov  m_word [REL kvdmp],w0
        jmp  stopr
        global sec07
sec07:
err_:   xchg wa,m_word [_rc_]
error:
        cmp  m_word [REL r_cim],cmlab
        je   cmple
        mov  m_word [REL kvert],wa
        mov  w0,0
        mov  m_word [REL scnrs],w0
        mov  w0,0
        mov  m_word [REL scngo],w0
        mov  m_word [REL polcs],num01
        mov  m_word [REL polct],num01
        mov  xr,m_word [REL stage]
        jmp  m_word [_l0506+xr*cfp_b]
        segment .data
_l0506:
        d_word err01
        d_word err04
        d_word err04
        d_word err05
        d_word err01
        d_word err04
        d_word err04
        segment .text
err01:
        mov  xs,m_word [REL cmpxs]
        cmp  m_word [REL errsp],0
        jnz  err03
        mov  wc,m_word [REL cmpsn]
        call filnm
        mov  wb,m_word [REL scnse]
        mov  wc,m_word [REL rdcln]
        mov  xr,m_word [REL stage]
        call sysea
        dec  m_word [_rc_]
        js   call_288
        dec  m_word [_rc_]
        jns  _l0507
        jmp  erra3
_l0507:
call_288:
        push xr
        mov  w0,m_word [REL erich]
        mov  m_word [REL erlst],w0
        call listr
        call prtis
        mov  w0,0
        mov  m_word [REL erlst],w0
        mov  wa,m_word [REL scnse]
        or   wa,wa
        jz   err02
        mov  wb,wa
        inc  wa
        mov  xl,m_word [REL r_cim]
        call alocs
        mov  wa,xr
        add  xr,cfp_f
        add  xl,cfp_f
erra1:
        mov  w0,0
        mov  al,m_char [xl]
        mov  wc,w0
        inc  xl
        cmp  wc,ch_ht
        je   erra2
        mov  wc,ch_bl
erra2:
        mov  al,wc_l
        stos_b
        dec  wb
        jnz  erra1
        mov  xl,ch_ex
        mov  w0,xl
        mov  [xr],al
        mov  m_word [REL profs],stnpd
        mov  xr,wa
        call prtst
err02:
        call prtis
        pop  xr
        or   xr,xr
        jz   erra0
        call prtst
erra0:
        call ermsg
        add  m_word [REL lstlc],num03
erra3:
        xor  xr,xr
        cmp  m_word [REL errft],num03
        ja   stopr
        inc  m_word [REL cmerc]
        mov  w0,m_word [REL cswer]
        add  m_word [REL noxeq],w0
        cmp  m_word [REL stage],stgic
        jne  cmp10
err03:
        mov  xr,m_word [REL r_cim]
        add  xr,cfp_f
        mov  w0,0
        mov  al,m_char [xr]
        mov  xr,w0
        cmp  xr,ch_mn
        je   cmpce
        mov  w0,0
        mov  m_word [REL scnrs],w0
        mov  m_word [REL errsp],xs
        call scane
        cmp  xl,t_smc
        jne  err03
        mov  w0,0
        mov  m_word [REL errsp],w0
        mov  m_word [REL cwcof],cfp_b*cdcod
        mov  wa,ocer_
        call cdwrd
        mov  w0,m_word [REL cwcof]
        mov  m_word [REL (cfp_b*cmsoc)+xs],w0
        mov  m_word [REL (cfp_b*cmffc)+xs],xs
        call cdwrd
        jmp  cmpse
err04:
        cmp  m_word [REL errft],num03
        jae  labo1
        cmp  m_word [REL kvert],nm320
        je   err06
        mov  w0,0
        mov  m_word [REL r_ccb],w0
        mov  m_word [REL cwcof],cfp_b*cccod
        call ertex
        sub  xs,cfp_b
erra4:
        add  xs,cfp_b
        cmp  xs,m_word [REL flprt]
        je   errc4
        cmp  xs,m_word [REL gtcef]
        jne  erra4
        mov  m_word [REL stage],stgxt
        mov  w0,m_word [REL r_gtc]
        mov  m_word [REL r_cod],w0
        mov  m_word [REL flptr],xs
        mov  w0,0
        mov  m_word [REL r_cim],w0
        mov  w0,0
        mov  m_word [REL cnind],w0
errb4:
        cmp  m_word [REL kverl],0
        jnz  err07
        jmp  exfal
errc4:
        mov  xs,m_word [REL flptr]
        jmp  errb4
err05:
        cmp  m_word [REL dmvch],0
        jnz  err08
err06:
        cmp  m_word [REL kverl],0
        jz   labo1
        call ertex
err07:
        cmp  m_word [REL errft],num03
        jae  labo1
        dec  m_word [REL kverl]
        mov  xl,m_word [REL r_ert]
        call ktrex
        mov  wa,m_word [REL r_cod]
        mov  m_word [REL r_cnt],wa
        scp_ wb
        sub  wb,wa
        mov  m_word [REL stxoc],wb
        mov  xr,m_word [REL flptr]
        mov  w0,m_word [ xr]
        mov  m_word [REL stxof],w0
        mov  xr,m_word [REL r_sxc]
        or   xr,xr
        jz   lcnt1
        mov  w0,0
        mov  m_word [REL r_sxc],w0
        mov  m_word [REL stxvr],nulls
        mov  xl,m_word [ xr]
        jmp  xl
err08:
        mov  xr,m_word [REL dmvch]
        or   xr,xr
        jz   err06
        mov  w0,m_word [ xr]
        mov  m_word [REL dmvch],w0
        call setvr
s_yyy:
        jmp  err08
