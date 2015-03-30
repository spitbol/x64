	.set	cfp_b,4
	.set	cfp_c,4
	.set	os ,osx
	.set	log_cfp_b,2
	.set	log_cfp_c,2
	.set	ws,32
        Text
        Global sec01
sec01:
        Data
        Global sec02
sec02:
        Equ_ cfp_a,256
        Equ_ cfp_b,4
        Equ_ cfp_c,4
        Equ_ cfp_f,8
        Equ_ cfp_i,1
        Equ_ cfp_m,2147483647
        Equ_ cfp_n,32
        Equ_ cfp_r,2
        Equ_ cfp_s,9
        Equ_ cfp_x,3
        Equ_ mxdgs,cfp_s+cfp_x
        Equ_ nstmx,mxdgs+5
        Equ_ cfp_u,128
        Equ_ e_srs,100
        Equ_ e_sts,1000
        Equ_ e_cbs,500
        Equ_ e_hnb,257
        Equ_ e_hnw,6
        Equ_ e_fsp,15
        Equ_ e_sed,25
        Equ_ ch_la,97
        Equ_ ch_lb,98
        Equ_ ch_lc,99
        Equ_ ch_ld,100
        Equ_ ch_le,101
        Equ_ ch_lf,102
        Equ_ ch_lg,103
        Equ_ ch_lh,104
        Equ_ ch_li,105
        Equ_ ch_lj,106
        Equ_ ch_lk,107
        Equ_ ch_ll,108
        Equ_ ch_lm,109
        Equ_ ch_ln,110
        Equ_ ch_lo,111
        Equ_ ch_lp,112
        Equ_ ch_lq,113
        Equ_ ch_lr,114
        Equ_ ch_ls,115
        Equ_ ch_lt,116
        Equ_ ch_lu,117
        Equ_ ch_lv,118
        Equ_ ch_lw,119
        Equ_ ch_lx,120
        Equ_ ch_ly,121
        Equ_ ch_l_,122
        Equ_ ch_d0,48
        Equ_ ch_d1,49
        Equ_ ch_d2,50
        Equ_ ch_d3,51
        Equ_ ch_d4,52
        Equ_ ch_d5,53
        Equ_ ch_d6,54
        Equ_ ch_d7,55
        Equ_ ch_d8,56
        Equ_ ch_d9,57
        Equ_ ch_am,38
        Equ_ ch_as,42
        Equ_ ch_at,64
        Equ_ ch_bb,60
        Equ_ ch_bl,32
        Equ_ ch_br,124
        Equ_ ch_cl,58
        Equ_ ch_cm,44
        Equ_ ch_dl,36
        Equ_ ch_dt,46
        Equ_ ch_dq,34
        Equ_ ch_eq,61
        Equ_ ch_ex,33
        Equ_ ch_mn,45
        Equ_ ch_nm,35
        Equ_ ch_nt,126
        Equ_ ch_pc,37
        Equ_ ch_pl,43
        Equ_ ch_pp,40
        Equ_ ch_rb,62
        Equ_ ch_rp,41
        Equ_ ch_qu,63
        Equ_ ch_sl,47
        Equ_ ch_sm,59
        Equ_ ch_sq,39
        Equ_ ch_u_,95
        Equ_ ch_ob,91
        Equ_ ch_cb,93
        Equ_ ch_ht,9
        Equ_ ch_ey,94
        Equ_ ch_ua,65
        Equ_ ch_ub,66
        Equ_ ch_uc,67
        Equ_ ch_ud,68
        Equ_ ch_ue,69
        Equ_ ch_uf,70
        Equ_ ch_ug,71
        Equ_ ch_uh,72
        Equ_ ch_ui,73
        Equ_ ch_uj,74
        Equ_ ch_uk,75
        Equ_ ch_ul,76
        Equ_ ch_um,77
        Equ_ ch_un,78
        Equ_ ch_uo,79
        Equ_ ch_up,80
        Equ_ ch_uq,81
        Equ_ ch_ur,82
        Equ_ ch_us,83
        Equ_ ch_ut,84
        Equ_ ch_uu,85
        Equ_ ch_uv,86
        Equ_ ch_uw,87
        Equ_ ch_ux,88
        Equ_ ch_uy,89
        Equ_ ch_uz,90
        Equ_ iodel,32
        Equ_ offs1,1
        Equ_ offs2,2
        Equ_ offs3,3
        Equ_ bl_ar,0
        Equ_ bl_cd,bl_ar+1
        Equ_ bl_ex,bl_cd+1
        Equ_ bl_ic,bl_ex+1
        Equ_ bl_nm,bl_ic+1
        Equ_ bl_p0,bl_nm+1
        Equ_ bl_p1,bl_p0+1
        Equ_ bl_p2,bl_p1+1
        Equ_ bl_rc,bl_p2+1
        Equ_ bl_sc,bl_rc+1
        Equ_ bl_se,bl_sc+1
        Equ_ bl_tb,bl_se+1
        Equ_ bl_vc,bl_tb+1
        Equ_ bl_xn,bl_vc+1
        Equ_ bl_xr,bl_xn+1
        Equ_ bl_bc,bl_xr+1
        Equ_ bl_pd,bl_bc+1
        Equ_ bl__d,bl_pd+1
        Equ_ bl_tr,bl_pd+1
        Equ_ bl_bf,bl_tr+1
        Equ_ bl_cc,bl_bf+1
        Equ_ bl_cm,bl_cc+1
        Equ_ bl_ct,bl_cm+1
        Equ_ bl_df,bl_ct+1
        Equ_ bl_ef,bl_df+1
        Equ_ bl_ev,bl_ef+1
        Equ_ bl_ff,bl_ev+1
        Equ_ bl_kv,bl_ff+1
        Equ_ bl_pf,bl_kv+1
        Equ_ bl_te,bl_pf+1
        Equ_ bl__i,0
        Equ_ bl__t,bl_tr+1
        Equ_ bl___,bl_te+1
        Equ_ fcode,0
        Equ_ fargs,1
        Equ_ idval,1
        Equ_ artyp,0
        Equ_ arlen,idval+1
        Equ_ arofs,arlen+1
        Equ_ arndm,arofs+1
        Equ_ arlbd,arndm+1
        Equ_ ardim,arlbd+cfp_i
        Equ_ arlb2,ardim+cfp_i
        Equ_ ardm2,arlb2+cfp_i
        Equ_ arpro,ardim+cfp_i
        Equ_ arvls,arpro+1
        Equ_ arpr2,ardm2+cfp_i
        Equ_ arvl2,arpr2+1
        Equ_ arsi_,arlbd
        Equ_ ardms,arlb2-arlbd
        Equ_ cctyp,0
        Equ_ cclen,cctyp+1
        Equ_ ccsln,cclen+1
        Equ_ ccuse,ccsln+1
        Equ_ cccod,ccuse+1
        Equ_ cdjmp,0
        Equ_ cdstm,cdjmp+1
        Equ_ cdsln,cdstm+1
        Equ_ cdlen,cdsln+1
        Equ_ cdfal,cdlen+1
        Equ_ cdcod,cdfal+1
        Equ_ cdsi_,cdcod
        Equ_ cmidn,0
        Equ_ cmlen,cmidn+1
        Equ_ cmtyp,cmlen+1
        Equ_ cmopn,cmtyp+1
        Equ_ cmvls,cmopn+1
        Equ_ cmrop,cmvls
        Equ_ cmlop,cmvls+1
        Equ_ cmsi_,cmvls
        Equ_ cmus_,cmsi_+1
        Equ_ cmbs_,cmsi_+2
        Equ_ cmar1,cmvls+1
        Equ_ c_arr,0
        Equ_ c_fnc,c_arr+1
        Equ_ c_def,c_fnc+1
        Equ_ c_ind,c_def+1
        Equ_ c_key,c_ind+1
        Equ_ c_ubo,c_key+1
        Equ_ c_uuo,c_ubo+1
        Equ_ c_uo_,c_uuo+1
        Equ_ c__nm,c_uuo+1
        Equ_ c_bvl,c_uuo+1
        Equ_ c_uvl,c_bvl+1
        Equ_ c_alt,c_uvl+1
        Equ_ c_cnc,c_alt+1
        Equ_ c_cnp,c_cnc+1
        Equ_ c_unm,c_cnp+1
        Equ_ c_bvn,c_unm+1
        Equ_ c_ass,c_bvn+1
        Equ_ c_int,c_ass+1
        Equ_ c_neg,c_int+1
        Equ_ c_sel,c_neg+1
        Equ_ c_pmt,c_sel+1
        Equ_ c_pr_,c_bvn
        Equ_ c__nv,c_pmt+1
        Equ_ cttyp,0
        Equ_ ctchs,cttyp+1
        Equ_ ctsi_,ctchs+cfp_a
        Equ_ dflen,fargs+1
        Equ_ dfpdl,dflen+1
        Equ_ dfnam,dfpdl+1
        Equ_ dffld,dfnam+1
        Equ_ dfflb,dffld-1
        Equ_ dfsi_,dffld
        Equ_ dvopn,0
        Equ_ dvtyp,dvopn+1
        Equ_ dvlpr,dvtyp+1
        Equ_ dvrpr,dvlpr+1
        Equ_ dvus_,dvlpr+1
        Equ_ dvbs_,dvrpr+1
        Equ_ dvubs,dvus_+dvbs_
        Equ_ rrass,10
        Equ_ llass,00
        Equ_ rrpmt,20
        Equ_ llpmt,30
        Equ_ rramp,40
        Equ_ llamp,50
        Equ_ rralt,70
        Equ_ llalt,60
        Equ_ rrcnc,90
        Equ_ llcnc,80
        Equ_ rrats,110
        Equ_ llats,100
        Equ_ rrplm,120
        Equ_ llplm,130
        Equ_ rrnum,140
        Equ_ llnum,150
        Equ_ rrdvd,160
        Equ_ lldvd,170
        Equ_ rrmlt,180
        Equ_ llmlt,190
        Equ_ rrpct,200
        Equ_ llpct,210
        Equ_ rrexp,230
        Equ_ llexp,220
        Equ_ rrdld,240
        Equ_ lldld,250
        Equ_ rrnot,270
        Equ_ llnot,260
        Equ_ lluno,999
        Equ_ eflen,fargs+1
        Equ_ efuse,eflen+1
        Equ_ efcod,efuse+1
        Equ_ efvar,efcod+1
        Equ_ efrsl,efvar+1
        Equ_ eftar,efrsl+1
        Equ_ efsi_,eftar
        Equ_ evtyp,0
        Equ_ evexp,evtyp+1
        Equ_ evvar,evexp+1
        Equ_ evsi_,evvar+1
        Equ_ extyp,0
        Equ_ exstm,cdstm
        Equ_ exsln,exstm+1
        Equ_ exlen,exsln+1
        Equ_ exflc,exlen+1
        Equ_ excod,exflc+1
        Equ_ exsi_,excod
        Equ_ ffdfp,fargs+1
        Equ_ ffnxt,ffdfp+1
        Equ_ ffofs,ffnxt+1
        Equ_ ffsi_,ffofs+1
        Equ_ icget,0
        Equ_ icval,icget+1
        Equ_ icsi_,icval+cfp_i
        Equ_ kvtyp,0
        Equ_ kvvar,kvtyp+1
        Equ_ kvnum,kvvar+1
        Equ_ kvsi_,kvnum+1
        Equ_ nmtyp,0
        Equ_ nmbas,nmtyp+1
        Equ_ nmofs,nmbas+1
        Equ_ nmsi_,nmofs+1
        Equ_ pcode,0
        Equ_ pthen,pcode+1
        Equ_ pasi_,pthen+1
        Equ_ parm1,pthen+1
        Equ_ pbsi_,parm1+1
        Equ_ parm2,parm1+1
        Equ_ pcsi_,parm2+1
        Equ_ pdtyp,0
        Equ_ pddfp,idval+1
        Equ_ pdfld,pddfp+1
        Equ_ pdfof,dffld-pdfld
        Equ_ pdsi_,pdfld
        Equ_ pddfs,dfsi_-pdsi_
        Equ_ pflen,fargs+1
        Equ_ pfvbl,pflen+1
        Equ_ pfnlo,pfvbl+1
        Equ_ pfcod,pfnlo+1
        Equ_ pfctr,pfcod+1
        Equ_ pfrtr,pfctr+1
        Equ_ pfarg,pfrtr+1
        Equ_ pfagb,pfarg-1
        Equ_ pfsi_,pfarg
        Equ_ rcget,0
        Equ_ rcval,rcget+1
        Equ_ rcsi_,rcval+cfp_r
        Equ_ scget,0
        Equ_ sclen,scget+1
        Equ_ schar,sclen+1
        Equ_ scsi_,schar
        Equ_ setyp,0
        Equ_ sevar,setyp+1
        Equ_ sesi_,sevar+1
        Equ_ svbit,0
        Equ_ svlen,1
        Equ_ svchs,2
        Equ_ svsi_,2
        Equ_ svpre,1
        Equ_ svffc,svpre+svpre
        Equ_ svckw,svffc+svffc
        Equ_ svprd,svckw+svckw
        Equ_ svnbt,4
        Equ_ svknm,svprd+svprd
        Equ_ svfnc,svknm+svknm
        Equ_ svnar,svfnc+svfnc
        Equ_ svlbl,svnar+svnar
        Equ_ svval,svlbl+svlbl
        Equ_ svfnf,svfnc+svnar
        Equ_ svfnn,svfnf+svffc
        Equ_ svfnp,svfnn+svpre
        Equ_ svfpr,svfnn+svprd
        Equ_ svfnk,svfnn+svknm
        Equ_ svkwv,svknm+svval
        Equ_ svkwc,svckw+svknm
        Equ_ svkvc,svkwv+svckw
        Equ_ svkvl,svkvc+svlbl
        Equ_ svfpk,svfnp+svkvc
        Equ_ k_abe,0
        Equ_ k_anc,k_abe+cfp_b
        Equ_ k_cas,k_anc+cfp_b
        Equ_ k_cod,k_cas+cfp_b
        Equ_ k_com,k_cod+cfp_b
        Equ_ k_dmp,k_com+cfp_b
        Equ_ k_erl,k_dmp+cfp_b
        Equ_ k_ert,k_erl+cfp_b
        Equ_ k_ftr,k_ert+cfp_b
        Equ_ k_fls,k_ftr+cfp_b
        Equ_ k_inp,k_fls+cfp_b
        Equ_ k_mxl,k_inp+cfp_b
        Equ_ k_oup,k_mxl+cfp_b
        Equ_ k_pfl,k_oup+cfp_b
        Equ_ k_tra,k_pfl+cfp_b
        Equ_ k_trm,k_tra+cfp_b
        Equ_ k_fnc,k_trm+cfp_b
        Equ_ k_lst,k_fnc+cfp_b
        Equ_ k_lln,k_lst+cfp_b
        Equ_ k_lin,k_lln+cfp_b
        Equ_ k_stn,k_lin+cfp_b
        Equ_ k_abo,k_stn+cfp_b
        Equ_ k_arb,k_abo+pasi_
        Equ_ k_bal,k_arb+pasi_
        Equ_ k_fal,k_bal+pasi_
        Equ_ k_fen,k_fal+pasi_
        Equ_ k_rem,k_fen+pasi_
        Equ_ k_suc,k_rem+pasi_
        Equ_ k_alp,k_suc+1
        Equ_ k_rtn,k_alp+1
        Equ_ k_stc,k_rtn+1
        Equ_ k_etx,k_stc+1
        Equ_ k_fil,k_etx+1
        Equ_ k_lfl,k_fil+1
        Equ_ k_stl,k_lfl+1
        Equ_ k_lcs,k_stl+1
        Equ_ k_ucs,k_lcs+1
        Equ_ k__al,k_alp-k_alp
        Equ_ k__rt,k_rtn-k_alp
        Equ_ k__sc,k_stc-k_alp
        Equ_ k__et,k_etx-k_alp
        Equ_ k__fl,k_fil-k_alp
        Equ_ k__lf,k_lfl-k_alp
        Equ_ k__sl,k_stl-k_alp
        Equ_ k__lc,k_lcs-k_alp
        Equ_ k__uc,k_ucs-k_alp
        Equ_ k__n_,k__uc+1
        Equ_ k_p__,k_fnc
        Equ_ k_v__,k_abo
        Equ_ k_s__,k_alp
        Equ_ tbtyp,0
        Equ_ tblen,offs2
        Equ_ tbinv,offs3
        Equ_ tbbuk,tbinv+1
        Equ_ tbsi_,tbbuk
        Equ_ tbnbk,11
        Equ_ tetyp,0
        Equ_ tesub,tetyp+1
        Equ_ teval,tesub+1
        Equ_ tenxt,teval+1
        Equ_ tesi_,tenxt+1
        Equ_ tridn,0
        Equ_ trtyp,tridn+1
        Equ_ trval,trtyp+1
        Equ_ trnxt,trval
        Equ_ trlbl,trval
        Equ_ trkvr,trval
        Equ_ trtag,trval+1
        Equ_ trter,trtag
        Equ_ trtrf,trtag
        Equ_ trfnc,trtag+1
        Equ_ trfpt,trfnc
        Equ_ trsi_,trfnc+1
        Equ_ trtin,0
        Equ_ trtac,trtin+1
        Equ_ trtvl,trtac+1
        Equ_ trtou,trtvl+1
        Equ_ trtfc,trtou+1
        Equ_ vctyp,0
        Equ_ vclen,offs2
        Equ_ vcvls,offs3
        Equ_ vcsi_,vcvls
        Equ_ vcvlb,vcvls-1
        Equ_ vctbd,tbsi_-vcsi_
        Equ_ vrget,0
        Equ_ vrsto,vrget+1
        Equ_ vrval,vrsto+1
        Equ_ vrvlo,vrval-vrsto
        Equ_ vrtra,vrval+1
        Equ_ vrlbl,vrtra+1
        Equ_ vrlbo,vrlbl-vrtra
        Equ_ vrfnc,vrlbl+1
        Equ_ vrnxt,vrfnc+1
        Equ_ vrlen,vrnxt+1
        Equ_ vrchs,vrlen+1
        Equ_ vrsvp,vrlen+1
        Equ_ vrsi_,vrchs+1
        Equ_ vrsof,vrlen-sclen
        Equ_ vrsvo,vrsvp-vrsof
        Equ_ xntyp,0
        Equ_ xnlen,xntyp+1
        Equ_ xndta,xnlen+1
        Equ_ xnsi_,xndta
        Equ_ xrtyp,0
        Equ_ xrlen,xrtyp+1
        Equ_ xrptr,xrlen+1
        Equ_ xrsi_,xrptr
        Equ_ cnvst,8
        Equ_ cnvrt,cnvst+1
        Equ_ cnvbt,cnvrt
        Equ_ cnvtt,cnvbt+1
        Equ_ iniln,1024
        Equ_ inils,1024
        Equ_ ionmb,2
        Equ_ ionmo,4
        Equ_ mnlen,1024
        Equ_ mxern,329
        Equ_ num01,1
        Equ_ num02,2
        Equ_ num03,3
        Equ_ num04,4
        Equ_ num05,5
        Equ_ num06,6
        Equ_ num07,7
        Equ_ num08,8
        Equ_ num09,9
        Equ_ num10,10
        Equ_ num25,25
        Equ_ nm320,320
        Equ_ nm321,321
        Equ_ nini8,998
        Equ_ nini9,999
        Equ_ thsnd,1000
        Equ_ opbun,5
        Equ_ opuun,6
        Equ_ prsnf,13
        Equ_ prtmf,21
        Equ_ rilen,1024
        Equ_ stgic,0
        Equ_ stgxc,stgic+1
        Equ_ stgev,stgxc+1
        Equ_ stgxt,stgev+1
        Equ_ stgce,stgxt+1
        Equ_ stgxe,stgce+1
        Equ_ stgnd,stgce-stgic
        Equ_ stgee,stgxe+1
        Equ_ stgno,stgee+1
        Equ_ stnpd,8
        Equ_ t_uop,0
        Equ_ t_lpr,t_uop+3
        Equ_ t_lbr,t_lpr+3
        Equ_ t_cma,t_lbr+3
        Equ_ t_fnc,t_cma+3
        Equ_ t_var,t_fnc+3
        Equ_ t_con,t_var+3
        Equ_ t_bop,t_con+3
        Equ_ t_rpr,t_bop+3
        Equ_ t_rbr,t_rpr+3
        Equ_ t_col,t_rbr+3
        Equ_ t_smc,t_col+3
        Equ_ t_fgo,t_smc+1
        Equ_ t_sgo,t_fgo+1
        Equ_ t_uok,t_fnc
        Equ_ t_uo0,t_uop+0
        Equ_ t_uo1,t_uop+1
        Equ_ t_uo2,t_uop+2
        Equ_ t_lp0,t_lpr+0
        Equ_ t_lp1,t_lpr+1
        Equ_ t_lp2,t_lpr+2
        Equ_ t_lb0,t_lbr+0
        Equ_ t_lb1,t_lbr+1
        Equ_ t_lb2,t_lbr+2
        Equ_ t_cm0,t_cma+0
        Equ_ t_cm1,t_cma+1
        Equ_ t_cm2,t_cma+2
        Equ_ t_fn0,t_fnc+0
        Equ_ t_fn1,t_fnc+1
        Equ_ t_fn2,t_fnc+2
        Equ_ t_va0,t_var+0
        Equ_ t_va1,t_var+1
        Equ_ t_va2,t_var+2
        Equ_ t_co0,t_con+0
        Equ_ t_co1,t_con+1
        Equ_ t_co2,t_con+2
        Equ_ t_bo0,t_bop+0
        Equ_ t_bo1,t_bop+1
        Equ_ t_bo2,t_bop+2
        Equ_ t_rp0,t_rpr+0
        Equ_ t_rp1,t_rpr+1
        Equ_ t_rp2,t_rpr+2
        Equ_ t_rb0,t_rbr+0
        Equ_ t_rb1,t_rbr+1
        Equ_ t_rb2,t_rbr+2
        Equ_ t_cl0,t_col+0
        Equ_ t_cl1,t_col+1
        Equ_ t_cl2,t_col+2
        Equ_ t_sm0,t_smc+0
        Equ_ t_sm1,t_smc+1
        Equ_ t_sm2,t_smc+2
        Equ_ t_nes,t_sm2+1
        Equ_ cc_ca,0
        Equ_ cc_do,cc_ca+1
        Equ_ cc_co,cc_do+1
        Equ_ cc_du,cc_co+1
        Equ_ cc_cp,cc_du+1
        Equ_ cc_ej,cc_cp+1
        Equ_ cc_er,cc_ej+1
        Equ_ cc_ex,cc_er+1
        Equ_ cc_fa,cc_ex+1
        Equ_ cc_in,cc_fa+1
        Equ_ cc_ln,cc_in+1
        Equ_ cc_li,cc_ln+1
        Equ_ cc_nr,cc_li+1
        Equ_ cc_nx,cc_nr+1
        Equ_ cc_nf,cc_nx+1
        Equ_ cc_nl,cc_nf+1
        Equ_ cc_no,cc_nl+1
        Equ_ cc_np,cc_no+1
        Equ_ cc_op,cc_np+1
        Equ_ cc_pr,cc_op+1
        Equ_ cc_si,cc_pr+1
        Equ_ cc_sp,cc_si+1
        Equ_ cc_st,cc_sp+1
        Equ_ cc_ti,cc_st+1
        Equ_ cc_tr,cc_ti+1
        Equ_ cc_nc,cc_tr+1
        Equ_ ccnoc,4
        Equ_ ccofs,7
        Equ_ ccinm,9
        Equ_ cmstm,0
        Equ_ cmsgo,cmstm+1
        Equ_ cmfgo,cmsgo+1
        Equ_ cmcgo,cmfgo+1
        Equ_ cmpcd,cmcgo+1
        Equ_ cmffp,cmpcd+1
        Equ_ cmffc,cmffp+1
        Equ_ cmsop,cmffc+1
        Equ_ cmsoc,cmsop+1
        Equ_ cmlbl,cmsoc+1
        Equ_ cmtra,cmlbl+1
        Equ_ cmnen,cmtra+1
        Equ_ pfpd1,8
        Equ_ pfpd2,20
        Equ_ pfpd3,32
        Equ_ pf_i2,cfp_i+cfp_i
        Equ_ rlend,0
        Equ_ rladj,rlend+1
        Equ_ rlstr,rladj+1
        Equ_ rssi_,rlstr+1
        Equ_ rnsi_,5
        Equ_ rldye,0
        Equ_ rldya,rldye+1
        Equ_ rldys,rldya+1
        Equ_ rlste,rldys+1
        Equ_ rlsta,rlste+1
        Equ_ rlsts,rlsta+1
        Equ_ rlwke,rlsts+1
        Equ_ rlwka,rlwke+1
        Equ_ rlwks,rlwka+1
        Equ_ rlcne,rlwks+1
        Equ_ rlcna,rlcne+1
        Equ_ rlcns,rlcna+1
        Equ_ rlcde,rlcns+1
        Equ_ rlcda,rlcde+1
        Equ_ rlcds,rlcda+1
        Equ_ rlsi_,rlcds+1
        Data
        Global sec03
sec03:
_c_aaa:  .long 0
alfsp:  .long e_fsp
bits0:  .long 0
bits1:  .long 1
bits2:  .long 2
bits3:  .long 4
bits4:  .long 8
bits5:  .long 16
bits6:  .long 32
bits7:  .long 64
bits8:  .long 128
bits9:  .long 256
bit10:  .long 512
bit11:  .long 1024
bit12:  .long 2048
bitsm:  .long 0
btfnc:  .long svfnc
btknm:  .long svknm
btlbl:  .long svlbl
btffc:  .long svffc
btckw:  .long svckw
btkwv:  .long svkwv
btprd:  .long svprd
btpre:  .long svpre
btval:  .long svval
ccnms:  .ascii "case"
        .ascii "doub"
        .ascii "comp"
        .ascii "dump"
        .ascii "copy"
        .ascii "ejec"
        .ascii "erro"
        .ascii "exec"
        .ascii "fail"
        .ascii "incl"
        .ascii "line"
        .ascii "list"
        .ascii "noer"
        .ascii "noex"
        .ascii "nofa"
        .ascii "noli"
        .ascii "noop"
        .ascii "nopr"
        .ascii "opti"
        .ascii "prin"
        .ascii "sing"
        .ascii "spac"
        .ascii "stit"
        .ascii "titl"
        .ascii "trac"
dmhdk:  .long _b_scl
        .long 22
        .ascii "dump of keyword values"
        .byte 0
        .byte 0
dmhdv:  .long _b_scl
        .long 25
        .ascii "dump of natural variables"
        .byte 0
        .byte 0
        .byte 0
encm1:  .long _b_scl
        .long 19
        .ascii "memory used (bytes)"
        .byte 0
encm2:  .long _b_scl
        .long 19
        .ascii "memory left (bytes)"
        .byte 0
encm3:  .long _b_scl
        .long 11
        .ascii "comp _errors"
        .byte 0
encm4:  .long _b_scl
        .long 20
        .ascii "comp time (millisec)"
encm5:  .long _b_scl
        .long 20
        .ascii "execution suppressed"
endab:  .long _b_scl
        .long 12
        .ascii "abnormal end"
endmo:  .long _b_scl
endml:  .long 15
        .ascii "memory overflow"
        .byte 0
endms:  .long _b_scl
        .long 10
        .ascii "normal end"
        .byte 0
        .byte 0
endso:  .long _b_scl
        .long 36
        .ascii "stack overflow in garbage collection"
endtu:  .long _b_scl
        .long 15
        .ascii "error - time up"
        .byte 0
ermms:  .long _b_scl
        .long 5
        .ascii "error"
        .byte 0
        .byte 0
        .byte 0
ermns:  .long _b_scl
        .long 4
        .ascii " -- "
lstms:  .long _b_scl
        .long 5
        .ascii "page "
        .byte 0
        .byte 0
        .byte 0
headr:  .long _b_scl
        .long 27
        .ascii "macro spitbol version 15.01"
        .byte 0
_headv:  .long _b_scl
        .long 5
        .ascii "15.01"
        .byte 0
        .byte 0
        .byte 0
gbsdp:  .long e_sed
int_r:  .long _b_icl
intv0:  .long +0
inton:  .long _b_icl
intv1:  .long +1
inttw:  .long _b_icl
intv2:  .long +2
intvt:  .long +10
intvh:  .long +100
intth:  .long +1000
intab:  .long int_r
        .long inton
        .long inttw
ndabb:  .long p_abb
ndabd:  .long p_abd
ndarc:  .long p_arc
ndexb:  .long p_exb
ndfnb:  .long p_fnb
ndfnd:  .long p_fnd
ndexc:  .long p_exc
ndimb:  .long p_imb
ndimd:  .long p_imd
ndnth:  .long p_nth
ndpab:  .long p_pab
ndpad:  .long p_pad
nduna:  .long p_una
ndabo:  .long p_abo
        .long ndnth
ndarb:  .long p_arb
        .long ndnth
ndbal:  .long p_bal
        .long ndnth
ndfal:  .long p_fal
        .long ndnth
ndfen:  .long p_fen
        .long ndnth
ndrem:  .long p_rem
        .long ndnth
ndsuc:  .long p_suc
        .long ndnth
nulls:  .long _b_scl
        .long 0
nullw:  .ascii "          "
        .byte 0
        .byte 0
lcase:  .long _b_scl
        .long 26
        .ascii "abcdefghijklmnopqrstuvwxyz"
        .byte 0
        .byte 0
ucase:  .long _b_scl
        .long 26
        .ascii "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        .byte 0
        .byte 0
opdvc:  .long o_cnc
        .long c_cnc
        .long llcnc
        .long rrcnc
opdvp:  .long o_cnc
        .long c_cnp
        .long llcnc
        .long rrcnc
opdvs:  .long o_ass
        .long c_ass
        .long llass
        .long rrass
        .long 6
        .long c_uuo
        .long lluno
        .long o_pmv
        .long c_pmt
        .long llpmt
        .long rrpmt
        .long o_int
        .long c_uvl
        .long lluno
        .long 1
        .long c_ubo
        .long llamp
        .long rramp
        .long o_kwv
        .long c_key
        .long lluno
        .long o_alt
        .long c_alt
        .long llalt
        .long rralt
        .long 5
        .long c_uuo
        .long lluno
        .long 0
        .long c_ubo
        .long llats
        .long rrats
        .long o_cas
        .long c_unm
        .long lluno
        .long 2
        .long c_ubo
        .long llnum
        .long rrnum
        .long 7
        .long c_uuo
        .long lluno
        .long o_dvd
        .long c_bvl
        .long lldvd
        .long rrdvd
        .long 9
        .long c_uuo
        .long lluno
        .long o_mlt
        .long c_bvl
        .long llmlt
        .long rrmlt
        .long 0
        .long c_def
        .long lluno
        .long 3
        .long c_ubo
        .long llpct
        .long rrpct
        .long 8
        .long c_uuo
        .long lluno
        .long o_exp
        .long c_bvl
        .long llexp
        .long rrexp
        .long 10
        .long c_uuo
        .long lluno
        .long o_ima
        .long c_bvn
        .long lldld
        .long rrdld
        .long o_inv
        .long c_ind
        .long lluno
        .long 4
        .long c_ubo
        .long llnot
        .long rrnot
        .long 0
        .long c_neg
        .long lluno
        .long o_sub
        .long c_bvl
        .long llplm
        .long rrplm
        .long o_com
        .long c_uvl
        .long lluno
        .long o_add
        .long c_bvl
        .long llplm
        .long rrplm
        .long o_aff
        .long c_uvl
        .long lluno
        .long o_pas
        .long c_bvn
        .long lldld
        .long rrdld
        .long o_nam
        .long c_unm
        .long lluno
opdvd:  .long o_god
        .long c_uvl
        .long lluno
opdvn:  .long o_goc
        .long c_unm
        .long lluno
oamn_:  .long o_amn
oamv_:  .long o_amv
oaon_:  .long o_aon
oaov_:  .long o_aov
ocer_:  .long o_cer
ofex_:  .long o_fex
ofif_:  .long o_fif
ofnc_:  .long o_fnc
ofne_:  .long o_fne
ofns_:  .long o_fns
ogof_:  .long o_gof
oinn_:  .long o_inn
okwn_:  .long o_kwn
olex_:  .long o_lex
olpt_:  .long o_lpt
olvn_:  .long o_lvn
onta_:  .long o_nta
ontb_:  .long o_ntb
ontc_:  .long o_ntc
opmn_:  .long o_pmn
opms_:  .long o_pms
opop_:  .long o_pop
ornm_:  .long o_rnm
orpl_:  .long o_rpl
orvl_:  .long o_rvl
osla_:  .long o_sla
oslb_:  .long o_slb
oslc_:  .long o_slc
osld_:  .long o_sld
ostp_:  .long o_stp
ounf_:  .long o_unf
opsnb:  .long ch_at
        .long ch_am
        .long ch_nm
        .long ch_pc
        .long ch_nt
opnsu:  .long ch_br
        .long ch_eq
        .long ch_nm
        .long ch_pc
        .long ch_sl
        .long ch_ex
pfi2a:  .long pf_i2
pfms1:  .long _b_scl
        .long 15
        .ascii "program profile"
        .byte 0
pfms2:  .long _b_scl
        .long 42
        .ascii "stmt    number of     -- execution time --"
        .byte 0
        .byte 0
pfms3:  .long _b_scl
        .long 47
        .ascii "number  executions  total(msec) per excn(mcsec)"
        .byte 0
        Align_ 8
reav0:  .double 0.0
        Align_ 8
reap1:  .double 0.1
        Align_ 8
reap5:  .double 0.5
        Align_ 8
reav1:  .double 1.0
        Align_ 8
reavt:  .double 1.0e+1
        Align_ 8
        .double 1.0e+2
        Align_ 8
        .double 1.0e+3
        Align_ 8
        .double 1.0e+4
        Align_ 8
        .double 1.0e+5
        Align_ 8
        .double 1.0e+6
        Align_ 8
        .double 1.0e+7
        Align_ 8
        .double 1.0e+8
        Align_ 8
        .double 1.0e+9
        Align_ 8
reatt:  .double 1.0e+10
scarr:  .long _b_scl
        .long 5
        .ascii "array"
        .byte 0
        .byte 0
        .byte 0
sccod:  .long _b_scl
        .long 4
        .ascii "code"
scexp:  .long _b_scl
        .long 10
        .ascii "expression"
        .byte 0
        .byte 0
scext:  .long _b_scl
        .long 8
        .ascii "external"
scint:  .long _b_scl
        .long 7
        .ascii "integer"
        .byte 0
scnam:  .long _b_scl
        .long 4
        .ascii "name"
scnum:  .long _b_scl
        .long 7
        .ascii "numeric"
        .byte 0
scpat:  .long _b_scl
        .long 7
        .ascii "pattern"
        .byte 0
screa:  .long _b_scl
        .long 4
        .ascii "real"
scstr:  .long _b_scl
        .long 6
        .ascii "string"
        .byte 0
        .byte 0
sctab:  .long _b_scl
        .long 5
        .ascii "table"
        .byte 0
        .byte 0
        .byte 0
scfil:  .long _b_scl
        .long 4
        .ascii "file"
scfrt:  .long _b_scl
        .long 7
        .ascii "freturn"
        .byte 0
scnrt:  .long _b_scl
        .long 7
        .ascii "nreturn"
        .byte 0
scrtn:  .long _b_scl
        .long 6
        .ascii "return"
        .byte 0
        .byte 0
scnmt:  .long scarr
        .long sccod
        .long scexp
        .long scint
        .long scnam
        .long scpat
        .long scpat
        .long scpat
        .long screa
        .long scstr
        .long scexp
        .long sctab
        .long scarr
        .long scext
        .long scext
        .long nulls
scre0:  .long _b_scl
        .long 2
        .ascii "0."
        .byte 0
        .byte 0
stlim:  .long +2147483647
stndf:  .long o_fun
        .long 0
stndl:  .long l_und
stndo:  .long o_oun
        .long 0
stnvr:  .long b_vrl
        .long b_vrs
        .long nulls
        .long b_vrg
        .long stndl
        .long stndf
        .long 0
stpm1:  .long _b_scl
        .long 12
        .ascii "in _statement"
stpm2:  .long _b_scl
        .long 14
        .ascii "stmts executed"
        .byte 0
        .byte 0
stpm3:  .long _b_scl
        .long 19
        .ascii "run time (millisec)"
        .byte 0
stpm4:  .long _b_scl
        .long 12
        .ascii "mcsec / stmt"
stpm5:  .long _b_scl
        .long 13
        .ascii "regenerations"
        .byte 0
        .byte 0
        .byte 0
stpm6:  .long _b_scl
        .long 7
        .ascii "in line"
        .byte 0
stpm7:  .long _b_scl
        .long 7
        .ascii "in file"
        .byte 0
strtu:  .ascii "tu"
        .byte 0
        .byte 0
svctb:  .long scstr
        .long scint
        .long scnam
        .long scpat
        .long scarr
        .long sctab
        .long scexp
        .long sccod
        .long scnum
        .long screa
        .long 0
tmasb:  .long _b_scl
        .long 13
        .ascii "************ "
        .byte 0
        .byte 0
        .byte 0
tmbeb:  .long _b_scl
        .long 3
        .ascii " = "
        .byte 0
trbev:  .long b_trt
trbkv:  .long b_trt
trxdr:  .long o_txr
trxdc:  .long trxdr
v_eqf:  .long svfpr
        .long 2
        .ascii "eq"
        .byte 0
        .byte 0
        .long s_eqf
        .long 2
v_gef:  .long svfpr
        .long 2
        .ascii "ge"
        .byte 0
        .byte 0
        .long s_gef
        .long 2
v_gtf:  .long svfpr
        .long 2
        .ascii "gt"
        .byte 0
        .byte 0
        .long s_gtf
        .long 2
v_lef:  .long svfpr
        .long 2
        .ascii "le"
        .byte 0
        .byte 0
        .long s_lef
        .long 2
v_lnf:  .long svfnp
        .long 2
        .ascii "ln"
        .byte 0
        .byte 0
        .long s_lnf
        .long 1
v_ltf:  .long svfpr
        .long 2
        .ascii "lt"
        .byte 0
        .byte 0
        .long s_ltf
        .long 2
v_nef:  .long svfpr
        .long 2
        .ascii "ne"
        .byte 0
        .byte 0
        .long s_nef
        .long 2
v_any:  .long svfnp
        .long 3
        .ascii "any"
        .byte 0
        .long s_any
        .long 1
v_arb:  .long svkvc
        .long 3
        .ascii "arb"
        .byte 0
        .long k_arb
        .long ndarb
v_arg:  .long svfnn
        .long 3
        .ascii "arg"
        .byte 0
        .long s_arg
        .long 2
v_bal:  .long svkvc
        .long 3
        .ascii "bal"
        .byte 0
        .long k_bal
        .long ndbal
v_cos:  .long svfnp
        .long 3
        .ascii "cos"
        .byte 0
        .long s_cos
        .long 1
v_end:  .long svlbl
        .long 3
        .ascii "end"
        .byte 0
        .long l_end
v_exp:  .long svfnp
        .long 3
        .ascii "exp"
        .byte 0
        .long s_exp
        .long 1
v_len:  .long svfnp
        .long 3
        .ascii "len"
        .byte 0
        .long s_len
        .long 1
v_leq:  .long svfpr
        .long 3
        .ascii "leq"
        .byte 0
        .long s_leq
        .long 2
v_lge:  .long svfpr
        .long 3
        .ascii "lge"
        .byte 0
        .long s_lge
        .long 2
v_lgt:  .long svfpr
        .long 3
        .ascii "lgt"
        .byte 0
        .long s_lgt
        .long 2
v_lle:  .long svfpr
        .long 3
        .ascii "lle"
        .byte 0
        .long s_lle
        .long 2
v_llt:  .long svfpr
        .long 3
        .ascii "llt"
        .byte 0
        .long s_llt
        .long 2
v_lne:  .long svfpr
        .long 3
        .ascii "lne"
        .byte 0
        .long s_lne
        .long 2
v_pos:  .long svfnp
        .long 3
        .ascii "pos"
        .byte 0
        .long s_pos
        .long 1
v_rem:  .long svkvc
        .long 3
        .ascii "rem"
        .byte 0
        .long k_rem
        .long ndrem
v_set:  .long svfnn
        .long 3
        .ascii "set"
        .byte 0
        .long s_set
        .long 3
v_sin:  .long svfnp
        .long 3
        .ascii "sin"
        .byte 0
        .long s_sin
        .long 1
v_tab:  .long svfnp
        .long 3
        .ascii "tab"
        .byte 0
        .long s_tab
        .long 1
v_tan:  .long svfnp
        .long 3
        .ascii "tan"
        .byte 0
        .long s_tan
        .long 1
v_atn:  .long svfnp
        .long 4
        .ascii "atan"
        .long s_atn
        .long 1
v_cas:  .long svknm
        .long 4
        .ascii "case"
        .long k_cas
v_chr:  .long svfnp
        .long 4
        .ascii "char"
        .long s_chr
        .long 1
v_chp:  .long svfnp
        .long 4
        .ascii "chop"
        .long s_chp
        .long 1
v_cod:  .long svfnk
        .long 4
        .ascii "code"
        .long k_cod
        .long s_cod
        .long 1
v_cop:  .long svfnn
        .long 4
        .ascii "copy"
        .long s_cop
        .long 1
v_dat:  .long svfnn
        .long 4
        .ascii "data"
        .long s_dat
        .long 1
v_dte:  .long svfnn
        .long 4
        .ascii "date"
        .long s_dte
        .long 1
v_dmp:  .long svfnk
        .long 4
        .ascii "dump"
        .long k_dmp
        .long s_dmp
        .long 1
v_dup:  .long svfnn
        .long 4
        .ascii "dupl"
        .long s_dup
        .long 2
v_evl:  .long svfnn
        .long 4
        .ascii "eval"
        .long s_evl
        .long 1
v_ext:  .long svfnn
        .long 4
        .ascii "exit"
        .long s_ext
        .long 2
v_fal:  .long svkvc
        .long 4
        .ascii "fail"
        .long k_fal
        .long ndfal
v_fil:  .long svknm
        .long 4
        .ascii "file"
        .long k_fil
v_hst:  .long svfnn
        .long 4
        .ascii "host"
        .long s_hst
        .long 5
v_itm:  .long svfnf
        .long 4
        .ascii "item"
        .long s_itm
        .long 999
v_lin:  .long svknm
        .long 4
        .ascii "line"
        .long k_lin
v_lod:  .long svfnn
        .long 4
        .ascii "load"
        .long s_lod
        .long 2
v_lpd:  .long svfnp
        .long 4
        .ascii "lpad"
        .long s_lpd
        .long 3
v_rpd:  .long svfnp
        .long 4
        .ascii "rpad"
        .long s_rpd
        .long 3
v_rps:  .long svfnp
        .long 4
        .ascii "rpos"
        .long s_rps
        .long 1
v_rtb:  .long svfnp
        .long 4
        .ascii "rtab"
        .long s_rtb
        .long 1
v_si_:  .long svfnp
        .long 4
        .ascii "size"
        .long s_si_
        .long 1
v_srt:  .long svfnn
        .long 4
        .ascii "sort"
        .long s_srt
        .long 2
v_spn:  .long svfnp
        .long 4
        .ascii "span"
        .long s_spn
        .long 1
v_sqr:  .long svfnp
        .long 4
        .ascii "sqrt"
        .long s_sqr
        .long 1
v_stn:  .long svknm
        .long 4
        .ascii "stno"
        .long k_stn
v_tim:  .long svfnn
        .long 4
        .ascii "time"
        .long s_tim
        .long 0
v_trm:  .long svfnk
        .long 4
        .ascii "trim"
        .long k_trm
        .long s_trm
        .long 1
v_abe:  .long svknm
        .long 5
        .ascii "abend"
        .byte 0
        .byte 0
        .byte 0
        .long k_abe
v_abo:  .long svkvl
        .long 5
        .ascii "abort"
        .byte 0
        .byte 0
        .byte 0
        .long k_abo
        .long l_abo
        .long ndabo
v_app:  .long svfnf
        .long 5
        .ascii "apply"
        .byte 0
        .byte 0
        .byte 0
        .long s_app
        .long 999
v_abn:  .long svfnp
        .long 5
        .ascii "arbno"
        .byte 0
        .byte 0
        .byte 0
        .long s_abn
        .long 1
v_arr:  .long svfnn
        .long 5
        .ascii "array"
        .byte 0
        .byte 0
        .byte 0
        .long s_arr
        .long 2
v_brk:  .long svfnp
        .long 5
        .ascii "break"
        .byte 0
        .byte 0
        .byte 0
        .long s_brk
        .long 1
v_clr:  .long svfnn
        .long 5
        .ascii "clear"
        .byte 0
        .byte 0
        .byte 0
        .long s_clr
        .long 1
v_ejc:  .long svfnn
        .long 5
        .ascii "eject"
        .byte 0
        .byte 0
        .byte 0
        .long s_ejc
        .long 1
v_fen:  .long svfpk
        .long 5
        .ascii "fence"
        .byte 0
        .byte 0
        .byte 0
        .long k_fen
        .long s_fnc
        .long 1
        .long ndfen
v_fld:  .long svfnn
        .long 5
        .ascii "field"
        .byte 0
        .byte 0
        .byte 0
        .long s_fld
        .long 2
v_idn:  .long svfpr
        .long 5
        .ascii "ident"
        .byte 0
        .byte 0
        .byte 0
        .long s_idn
        .long 2
v_inp:  .long svfnk
        .long 5
        .ascii "input"
        .byte 0
        .byte 0
        .byte 0
        .long k_inp
        .long s_inp
        .long 3
v_lcs:  .long svkwc
        .long 5
        .ascii "lcase"
        .byte 0
        .byte 0
        .byte 0
        .long k_lcs
v_loc:  .long svfnn
        .long 5
        .ascii "local"
        .byte 0
        .byte 0
        .byte 0
        .long s_loc
        .long 2
v_ops:  .long svfnn
        .long 5
        .ascii "opsyn"
        .byte 0
        .byte 0
        .byte 0
        .long s_ops
        .long 3
v_rmd:  .long svfnp
        .long 5
        .ascii "remdr"
        .byte 0
        .byte 0
        .byte 0
        .long s_rmd
        .long 2
v_rsr:  .long svfnn
        .long 5
        .ascii "rsort"
        .byte 0
        .byte 0
        .byte 0
        .long s_rsr
        .long 2
v_tbl:  .long svfnn
        .long 5
        .ascii "table"
        .byte 0
        .byte 0
        .byte 0
        .long s_tbl
        .long 3
v_tra:  .long svfnk
        .long 5
        .ascii "trace"
        .byte 0
        .byte 0
        .byte 0
        .long k_tra
        .long s_tra
        .long 4
v_ucs:  .long svkwc
        .long 5
        .ascii "ucase"
        .byte 0
        .byte 0
        .byte 0
        .long k_ucs
v_anc:  .long svknm
        .long 6
        .ascii "anchor"
        .byte 0
        .byte 0
        .long k_anc
v_bkx:  .long svfnp
        .long 6
        .ascii "breakx"
        .byte 0
        .byte 0
        .long s_bkx
        .long 1
v_def:  .long svfnn
        .long 6
        .ascii "define"
        .byte 0
        .byte 0
        .long s_def
        .long 2
v_det:  .long svfnn
        .long 6
        .ascii "detach"
        .byte 0
        .byte 0
        .long s_det
        .long 1
v_dif:  .long svfpr
        .long 6
        .ascii "differ"
        .byte 0
        .byte 0
        .long s_dif
        .long 2
v_ftr:  .long svknm
        .long 6
        .ascii "ftrace"
        .byte 0
        .byte 0
        .long k_ftr
v_lst:  .long svknm
        .long 6
        .ascii "lastno"
        .byte 0
        .byte 0
        .long k_lst
v_nay:  .long svfnp
        .long 6
        .ascii "notany"
        .byte 0
        .byte 0
        .long s_nay
        .long 1
v_oup:  .long svfnk
        .long 6
        .ascii "output"
        .byte 0
        .byte 0
        .long k_oup
        .long s_oup
        .long 3
v_ret:  .long svlbl
        .long 6
        .ascii "return"
        .byte 0
        .byte 0
        .long l_rtn
v_rew:  .long svfnn
        .long 6
        .ascii "rewind"
        .byte 0
        .byte 0
        .long s_rew
        .long 1
v_stt:  .long svfnn
        .long 6
        .ascii "stoptr"
        .byte 0
        .byte 0
        .long s_stt
        .long 2
v_sub:  .long svfnn
        .long 6
        .ascii "substr"
        .byte 0
        .byte 0
        .long s_sub
        .long 3
v_unl:  .long svfnn
        .long 6
        .ascii "unload"
        .byte 0
        .byte 0
        .long s_unl
        .long 1
v_col:  .long svfnn
        .long 7
        .ascii "collect"
        .byte 0
        .long s_col
        .long 1
v_com:  .long svknm
        .long 7
        .ascii "compare"
        .byte 0
        .long k_com
v_cnv:  .long svfnn
        .long 7
        .ascii "convert"
        .byte 0
        .long s_cnv
        .long 2
v_enf:  .long svfnn
        .long 7
        .ascii "endfile"
        .byte 0
        .long s_enf
        .long 1
v_etx:  .long svknm
        .long 7
        .ascii "errtext"
        .byte 0
        .long k_etx
v_ert:  .long svknm
        .long 7
        .ascii "errtype"
        .byte 0
        .long k_ert
v_frt:  .long svlbl
        .long 7
        .ascii "freturn"
        .byte 0
        .long l_frt
v_int:  .long svfpr
        .long 7
        .ascii "integer"
        .byte 0
        .long s_int
        .long 1
v_nrt:  .long svlbl
        .long 7
        .ascii "nreturn"
        .byte 0
        .long l_nrt
v_pfl:  .long svknm
        .long 7
        .ascii "profile"
        .byte 0
        .long k_pfl
v_rpl:  .long svfnp
        .long 7
        .ascii "replace"
        .byte 0
        .long s_rpl
        .long 3
v_rvs:  .long svfnp
        .long 7
        .ascii "reverse"
        .byte 0
        .long s_rvs
        .long 1
v_rtn:  .long svknm
        .long 7
        .ascii "rtntype"
        .byte 0
        .long k_rtn
v_stx:  .long svfnn
        .long 7
        .ascii "setexit"
        .byte 0
        .long s_stx
        .long 1
v_stc:  .long svknm
        .long 7
        .ascii "stcount"
        .byte 0
        .long k_stc
v_stl:  .long svknm
        .long 7
        .ascii "stlimit"
        .byte 0
        .long k_stl
v_suc:  .long svkvc
        .long 7
        .ascii "succeed"
        .byte 0
        .long k_suc
        .long ndsuc
v_alp:  .long svkwc
        .long 8
        .ascii "alphabet"
        .long k_alp
v_cnt:  .long svlbl
        .long 8
        .ascii "continue"
        .long l_cnt
v_dtp:  .long svfnp
        .long 8
        .ascii "datatype"
        .long s_dtp
        .long 1
v_erl:  .long svknm
        .long 8
        .ascii "errlimit"
        .long k_erl
v_fnc:  .long svknm
        .long 8
        .ascii "fnclevel"
        .long k_fnc
v_fls:  .long svknm
        .long 8
        .ascii "fullscan"
        .long k_fls
v_lfl:  .long svknm
        .long 8
        .ascii "lastfile"
        .long k_lfl
v_lln:  .long svknm
        .long 8
        .ascii "lastline"
        .long k_lln
v_mxl:  .long svknm
        .long 8
        .ascii "maxlngth"
        .long k_mxl
v_ter:  .long 0
        .long 8
        .ascii "terminal"
        .long 0
v_bsp:  .long svfnn
        .long 9
        .ascii "backspace"
        .byte 0
        .byte 0
        .byte 0
        .long s_bsp
        .long 1
v_pro:  .long svfnn
        .long 9
        .ascii "prototype"
        .byte 0
        .byte 0
        .byte 0
        .long s_pro
        .long 1
v_scn:  .long svlbl
        .long 9
        .ascii "scontinue"
        .byte 0
        .byte 0
        .byte 0
        .long l_scn
        .long 0
        .long 10
vdmkw:  .long v_anc
        .long v_cas
        .long v_cod
        .long 1
        .long v_dmp
        .long v_erl
        .long v_etx
        .long v_ert
        .long v_fil
        .long v_fnc
        .long v_ftr
        .long v_fls
        .long v_inp
        .long v_lfl
        .long v_lln
        .long v_lst
        .long v_lin
        .long v_mxl
        .long v_oup
        .long v_pfl
        .long v_rtn
        .long v_stc
        .long v_stl
        .long v_stn
        .long v_tra
        .long v_trm
        .long 0
vsrch:  .long 0
        .long v_eqf
        .long v_eqf
        .long v_any
        .long v_atn
        .long v_abe
        .long v_anc
        .long v_col
        .long v_alp
        .long v_bsp
_c_yyy:  .long 0
        Global esec03
esec03:
        Data
        Global sec04
sec04:
cmlab:  .long _b_scl
        .long 2
        .ascii "  "
        .byte 0
        .byte 0
w_aaa:  .long 0
actrm:  .long 0
aldyn:  .long 0
allia:  .long +0
allsv:  .long 0
alsta:  .long 0
arcdm:  .long 0
arnel:  .long +0
arptr:  .long 0
arsvl:  .long +0
arfsi:  .long +0
arfxs:  .long 0
befof:  .long 0
bpfpf:  .long 0
bpfsv:  .long 0
bpfxt:  .long 0
clsvi:  .long +0
cnscc:  .long 0
cnswc:  .long 0
cnr_t:  .long 0
cnvtp:  .long 0
datdv:  .long 0
datxs:  .long 0
deflb:  .long 0
defna:  .long 0
defvr:  .long 0
defxs:  .long 0
dmarg:  .long 0
dmpsa:  .long 0
dmpsb:  .long 0
dmpsv:  .long 0
dmvch:  .long 0
dmpch:  .long 0
dmpkb:  .long 0
dmpkt:  .long 0
dmpkn:  .long 0
dtcnb:  .long 0
dtcnm:  .long 0
dupsi:  .long +0
enfch:  .long 0
ertwa:  .long 0
ertwb:  .long 0
evlin:  .long 0
evlis:  .long 0
evliv:  .long 0
evlio:  .long 0
evlif:  .long 0
expsv:  .long 0
gbcfl:  .long 0
gbclm:  .long 0
gbcnm:  .long 0
gbcns:  .long 0
gbcia:  .long +0
gbcsd:  .long 0
gbcsf:  .long 0
gbsva:  .long 0
gbsvb:  .long 0
gbsvc:  .long 0
gnvhe:  .long 0
gnvnw:  .long 0
gnvsa:  .long 0
gnvsb:  .long 0
gnvsp:  .long 0
gnvst:  .long 0
gtawa:  .long 0
gtina:  .long 0
gtinb:  .long 0
gtnnf:  .long 0
gtnsi:  .long +0
gtndf:  .long 0
gtnes:  .long 0
gtnex:  .long +0
gtnsc:  .long 0
        Align_ 8
gtnsr:  .double 0.0
gtnrd:  .long 0
gtpsb:  .long 0
gtssf:  .long 0
gtsvc:  .long 0
gtsvb:  .long 0
gtses:  .long 0
        Align_ 8
gtsrs:  .double 0.0
gtvrc:  .long 0
ioptt:  .long 0
lodfn:  .long 0
lodna:  .long 0
mxint:  .long +0
pfsvw:  .long 0
prnsi:  .long +0
prsna:  .long 0
prsva:  .long 0
prsvb:  .long 0
prsvc:  .long 0
prtsa:  .long 0
prtsb:  .long 0
prvsi:  .long 0
psave:  .long 0
psavc:  .long 0
rlals:  .long 0
rldcd:  .long 0
rldst:  .long 0
rldls:  .long 0
rtnbp:  .long 0
rtnfv:  .long 0
rtnsv:  .long 0
sbssv:  .long 0
scnsa:  .long 0
scnsb:  .long 0
scnsc:  .long 0
scnof:  .long 0
srtdf:  .long 0
srtfd:  .long 0
srtff:  .long 0
srtfo:  .long 0
srtnr:  .long 0
srtof:  .long 0
srtrt:  .long 0
srts1:  .long 0
srts2:  .long 0
srtsc:  .long 0
srtsf:  .long 0
srtsn:  .long 0
srtso:  .long 0
srtsr:  .long 0
srtst:  .long 0
srtwc:  .long 0
stpsi:  .long +0
stpti:  .long +0
tfnsi:  .long +0
xscrt:  .long 0
xscwb:  .long 0
_g_aaa:  .long 0
alfsf:  .long +0
cmerc:  .long 0
cmpln:  .long 0
cmpxs:  .long 0
cmpsn:  .long 1
cnsil:  .long 0
cnind:  .long 0
cnspt:  .long 0
cnttl:  .long 0
cpsts:  .long 0
cswdb:  .long 0
cswer:  .long 0
cswex:  .long 0
cswfl:  .long 1
cswin:  .long iniln
cswls:  .long 1
cswno:  .long 0
cswpr:  .long 0
ctmsk:  .long 0
curid:  .long 0
cwcof:  .long 0
dnams:  .long 0
erich:  .long 0
erlst:  .long 0
errft:  .long 0
errsp:  .long 0
exsts:  .long 0
_flprt:  .long 0
_flptr:  .long 0
gbsed:  .long +0
gbcnt:  .long 0
_gtcef:  .long 0
        Align_ 8
gtsrn:  .double 0.0
        Align_ 8
gtssc:  .double 0.0
gtswk:  .long 0
headp:  .long 0
hshnb:  .long +0
initr:  .long 0
kvabe:  .long 0
kvanc:  .long 0
kvcas:  .long 0
kvcod:  .long 0
kvcom:  .long 0
kvdmp:  .long 0
kverl:  .long 0
kvert:  .long 0
kvftr:  .long 0
kvfls:  .long 1
kvinp:  .long 1
kvmxl:  .long 5000
kvoup:  .long 1
kvpfl:  .long 0
kvtra:  .long 0
kvtrm:  .long 0
kvfnc:  .long 0
kvlst:  .long 0
kvlln:  .long 0
kvlin:  .long 0
kvstn:  .long 0
kvalp:  .long 0
kvrtn:  .long nulls
kvstl:  .long +2147483647
kvstc:  .long +2147483647
lstid:  .long 0
lstlc:  .long 0
lstnp:  .long 0
lstpf:  .long 1
lstpg:  .long 0
lstpo:  .long 0
lstsn:  .long 0
mxlen:  .long 0
noxeq:  .long 0
pfdmp:  .long 0
pffnc:  .long 0
pfstm:  .long +0
pfetm:  .long +0
pfnte:  .long 0
pfste:  .long +0
pmdfl:  .long 0
_pmhbs:  .long 0
pmssl:  .long 0
polcs:  .long 1
_polct:  .long 1
prich:  .long 0
prstd:  .long 0
prsto:  .long 0
prbuf:  .long 0
precl:  .long 0
prlen:  .long 0
prlnw:  .long 0
profs:  .long 0
prtef:  .long 0
rdcln:  .long 0
rdnln:  .long 0
rsmem:  .long 0
stmcs:  .long 1
stmct:  .long 1
a_aaa:  .long 0
cmpss:  .long 0
_dnamb:  .long 0
_dnamp:  .long 0
dname:  .long 0
_hshtb:  .long 0
hshte:  .long 0
iniss:  .long 0
pftbl:  .long 0
prnmv:  .long 0
statb:  .long 0
_state:  .long 0
stxvr:  .long nulls
r_aaa:  .long 0
r_arf:  .long 0
r_ccb:  .long 0
r_cim:  .long 0
r_cmp:  .long 0
r_cni:  .long 0
r_cnt:  .long 0
r_cod:  .long 0
r_ctp:  .long 0
r_cts:  .long 0
r_ert:  .long 0
r_etx:  .long nulls
r_exs:  .long 0
_r_fcb:  .long 0
r_fnc:  .long 0
r_gtc:  .long 0
r_ici:  .long 0
r_ifa:  .long 0
r_ifl:  .long 0
r_ifn:  .long 0
r_inc:  .long 0
r_io1:  .long 0
r_io2:  .long 0
r_iof:  .long 0
r_ion:  .long 0
r_iop:  .long 0
r_iot:  .long 0
r_pms:  .long 0
r_ra2:  .long 0
r_ra3:  .long 0
r_rpt:  .long 0
r_scp:  .long 0
r_sfc:  .long nulls
r_sfn:  .long 0
r_sxl:  .long 0
r_sxr:  .long 0
r_stc:  .long 0
r_stl:  .long 0
r_sxc:  .long 0
r_ttl:  .long nulls
r_xsc:  .long 0
r_uba:  .long stndo
r_ubm:  .long stndo
r_ubn:  .long stndo
r_ubp:  .long stndo
r_ubt:  .long stndo
r_uub:  .long stndo
r_uue:  .long stndo
r_uun:  .long stndo
r_uup:  .long stndo
r_uus:  .long stndo
r_uux:  .long stndo
r_yyy:  .long 0
scnbl:  .long 0
scncc:  .long 0
scngo:  .long 0
scnil:  .long 0
scnpt:  .long 0
scnrs:  .long 0
scnse:  .long 0
scntp:  .long 0
stage:  .long 0
_stbas:  .long 0
stxoc:  .long 0
stxof:  .long 0
timsx:  .long +0
timup:  .long 0
xsofs:  .long 0
_w_yyy:  .long 0
        Global esec04
esec04:
prc_:   .fill 19,4
        Global end_min_data
end_min_data:
        Text
        Global sec05
sec05:
	Align_	2
	.byte	bl__i
_s_aaa:
relaj:
        push %edi
        push %ecx
        Mov_ rlals,%esi
        Mov_ %edi,%ebx
rlaj0:
        Mov_ %esi,rlals
        Cmp_ %edi,(%esp)
        jne  rlaj1
        pop  %ecx
        pop  %edi
        ret
rlaj1:
        Mov_ %ecx,(%edi)
        Mov_ %ebx,$rnsi_
rlaj2:
        Cmp_ %ecx,0(%esi)
        ja   rlaj3
        Cmp_ %ecx,8(%esi)
        jb   rlaj3
        Add_ %ecx,4(%esi)
        Mov_ (%edi),%ecx
        Jmp_ rlaj4
rlaj3:
        Add_ %esi,$4*rssi_
        Dec_ %ebx
        jnz  rlaj2
rlaj4:
        Add_ %edi,$cfp_b
        Jmp_ rlaj0
relcr:
        Add_ %esi,$4*rlsi_
        Sub_ %esi,$4
        Mov_ (%esi),%ecx
        Mov_ %ecx,$_s_aaa
        Sub_ %ecx,(%esi)
        Sub_ %esi,$4
        Mov_ (%esi),%ecx
        Mov_ %ecx,$_s_yyy
        Sub_ %ecx,$_s_aaa
        Add_ %ecx,4(%esi)
        Sub_ %esi,$4
        Mov_ (%esi),%ecx
        Sub_ %esi,$4
        Mov_ (%esi),%ebx
        Mov_ %ebx,$_c_aaa
        Mov_ %ecx,$_c_yyy
        Sub_ %ecx,%ebx
        Sub_ %ebx,(%esi)
        Sub_ %esi,$4
        Mov_ (%esi),%ebx
        Add_ %ecx,4(%esi)
        Sub_ %esi,$4
        Mov_ (%esi),%ecx
        Sub_ %esi,$4
        Mov_ (%esi),%edx
        Mov_ %edx,$_g_aaa
        Mov_ %ecx,$_w_yyy
        Sub_ %ecx,%edx
        Sub_ %edx,(%esi)
        Sub_ %esi,$4
        Mov_ (%esi),%edx
        Add_ %ecx,4(%esi)
        Sub_ %esi,$4
        Mov_ (%esi),%ecx
        Mov_ %ebx,statb
        Sub_ %esi,$4
        Mov_ (%esi),%ebx
        Sub_ %edi,%ebx
        Sub_ %esi,$4
        Mov_ (%esi),%edi
        Sub_ %esi,$4
        Mov_ %eax,_state
        Mov_ (%esi),%eax
        Mov_ %ebx,_dnamb
        Sub_ %esi,$4
        Mov_ (%esi),%ebx
        Scp_ %ecx
        Sub_ %ecx,%ebx
        Sub_ %esi,$4
        Mov_ (%esi),%ecx
        Mov_ %edx,_dnamp
        Sub_ %esi,$4
        Mov_ (%esi),%edx
        ret
reldn:
        Mov_ %eax,52(%esi)
        Mov_ rldcd,%eax
        Mov_ %eax,16(%esi)
        Mov_ rldst,%eax
        Mov_ rldls,%esi
rld01:
        Mov_ %eax,rldcd
        Add_ (%edi),%eax
        Mov_ %esi,(%edi)
        Dec_ %esi
        mov  (%esi),%al
        movzbl %al,%esi
        jmp  *bsw_0001(,%esi,4)
        Data
bsw_0001:
        .long rld03
        .long rld07
        .long rld10
        .long rld05
        .long rld13
        .long rld13
        .long rld14
        .long rld14
        .long rld05
        .long rld05
        .long rld13
        .long rld17
        .long rld17
        .long rld05
        .long rld20
        .long rld05
        .long rld15
        .long rld19
        .long rld05
        .long rld05
        .long rld05
        .long rld05
        .long rld05
        .long rld08
        .long rld09
        .long rld11
        .long rld13
        .long rld16
        .long rld18
        Text
rld03:
        Mov_ %ecx,8(%edi)
        Mov_ %ebx,12(%edi)
rld04:
        Add_ %ecx,%edi
        Add_ %ebx,%edi
        Mov_ %esi,rldls
        call relaj
rld05:
        Mov_ %ecx,(%edi)
        call blkln
        Add_ %edi,%ecx
        Cmp_ %edi,%edx
        jb   rld01
        Mov_ %esi,rldls
        ret
rld07:
        Mov_ %ecx,12(%edi)
        Mov_ %ebx,$4*cdfal
        Cmp_ (%edi),$b_cdc
        jne  rld04
        Mov_ %ebx,$4*cdcod
        Jmp_ rld04
rld08:
        Mov_ %ecx,$4*efrsl
        Mov_ %ebx,$4*efcod
        Jmp_ rld04
rld09:
        Mov_ %ecx,$4*offs3
        Mov_ %ebx,$4*evexp
        Jmp_ rld04
rld10:
        Mov_ %ecx,12(%edi)
        Mov_ %ebx,$4*exflc
        Jmp_ rld04
rld11:
        Cmp_ 16(%edi),$4*pdfld
        jne  rld12
        push %edi
        Mov_ %edi,8(%edi)
        Add_ %edi,rldst
        Mov_ %eax,rldcd
        Add_ (%edi),%eax
        Mov_ %ecx,8(%edi)
        Mov_ %ebx,$4*dfnam
        Add_ %ecx,%edi
        Add_ %ebx,%edi
        Mov_ %esi,rldls
        call relaj
        Mov_ %edi,16(%edi)
        Mov_ %eax,rldcd
        Add_ (%edi),%eax
        pop  %edi
rld12:
        Mov_ %ecx,$4*ffofs
        Mov_ %ebx,$4*ffdfp
        Jmp_ rld04
rld13:
        Mov_ %ecx,$4*offs2
        Mov_ %ebx,$4*offs1
        Jmp_ rld04
rld14:
        Mov_ %ecx,$4*parm2
        Mov_ %ebx,$4*pthen
        Jmp_ rld04
rld15:
        Mov_ %esi,8(%edi)
        Add_ %esi,rldst
        Mov_ %ecx,12(%esi)
        Mov_ %ebx,$4*pddfp
        Jmp_ rld04
rld16:
        Mov_ %eax,rldst
        Add_ 12(%edi),%eax
        Mov_ %ecx,8(%edi)
        Mov_ %ebx,$4*pfcod
        Jmp_ rld04
rld17:
        Mov_ %ecx,8(%edi)
        Mov_ %ebx,$4*offs3
        Jmp_ rld04
rld18:
        Mov_ %ecx,$4*tesi_
        Mov_ %ebx,$4*tesub
        Jmp_ rld04
rld19:
        Mov_ %ecx,$4*trsi_
        Mov_ %ebx,$4*trval
        Jmp_ rld04
rld20:
        Mov_ %ecx,4(%edi)
        Mov_ %ebx,$4*xrptr
        Jmp_ rld04
reloc:
        Mov_ %edi,8(%esi)
        Mov_ %edx,0(%esi)
        Add_ %edi,4(%esi)
        Add_ %edx,4(%esi)
        call reldn
        call relws
        call relst
        ret
relst:
        Mov_ %edi,pftbl
        or   %edi,%edi
        jz   rls01
        Mov_ %eax,52(%esi)
        Add_ (%edi),%eax
rls01:
        Mov_ %edx,_hshtb
        Mov_ %ebx,%edx
        Mov_ %ecx,hshte
        call relaj
rls02:
        Cmp_ %edx,hshte
        je   rls05
        Mov_ %edi,%edx
        Add_ %edx,$cfp_b
        Sub_ %edi,$4*vrnxt
rls03:
        Mov_ %edi,24(%edi)
        or   %edi,%edi
        jz   rls02
        Mov_ %ecx,$4*vrlen
        Mov_ %ebx,$4*vrget
        Xor_ %eax,%eax
        Cmp_ 28(%edi),%eax
        jnz  rls04
        Mov_ %ecx,$4*vrsi_
rls04:
        Add_ %ecx,%edi
        Add_ %ebx,%edi
        call relaj
        Jmp_ rls03
rls05:
        ret
relws:
        Mov_ %ebx,$a_aaa
        Mov_ %ecx,$r_yyy
        call relaj
        Mov_ %eax,4(%esi)
        Add_ dname,%eax
        Mov_ %ebx,$kvrtn
        Mov_ %ecx,%ebx
        Add_ %ecx,$cfp_b
        call relaj
        ret
start:
        Mov_ mxint,%ebx
        Mov_ bitsm,%ebx
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Mov_ %esp,%ecx
        call systm
        sti_ timsx
        Mov_ statb,%edi
        Mov_ rsmem,$4*e_srs
        Mov_ _stbas,%esp
        ldi_ intvh
        Mov_ %eax,alfsp
        dvi_
        sti_ alfsf
        ldi_ intvh
        Mov_ %eax,gbsdp
        dvi_
        sti_ gbsed
        Mov_ %ebx,$cfp_s
        Mov_ %eax,$reav1
        call ldr_
ini03:
        Mov_ %eax,$reavt
        call mlr_
        Dec_ %ebx
        jnz  ini03
        Mov_ %eax,$gtssc
        call str_
        Mov_ %eax,$reap5
        call ldr_
        Mov_ %eax,$gtssc
        call dvr_
        Mov_ %eax,$gtsrn
        call str_
        Xor_ %eax,%eax
        Mov_ %edx,%eax
        call prpar
        Sub_ %esi,$4*e_srs
        Mov_ %ecx,prlen
        Add_ %ecx,$cfp_a
        Add_ %ecx,$nstmx
        mov  %ecx,ctbw_r
        movl $8,ctbw_v
        call ctb_
        movl ctbw_r,%ecx
        Mov_ %edi,statb
        Add_ %edi,%ecx
        Add_ %edi,$4*e_hnb
        Add_ %edi,$4*e_sts
        call sysmx
        Mov_ kvmxl,%ecx
        Mov_ mxlen,%ecx
        Cmp_ %edi,%ecx
        ja   ini06
        mov  %ecx,ctbw_r
        movl $1,ctbw_v
        call ctb_
        movl ctbw_r,%ecx
        Mov_ %edi,%ecx
ini06:
        Mov_ _dnamb,%edi
        Mov_ _dnamp,%edi
        or   %ecx,%ecx
        jnz  ini07
        Sub_ %edi,$cfp_b
        Mov_ kvmxl,%edi
        Mov_ mxlen,%edi
ini07:
        Mov_ dname,%esi
        Cmp_ _dnamb,%esi
        jb   ini09
        call sysmm
        Sal_ %edi,$2
        Add_ %esi,%edi
        or   %edi,%edi
        jnz  ini07
        Mov_ %ecx,$mxern
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Xor_ %eax,%eax
        Mov_ %edx,%eax
        Mov_ %edi,$stgic
        Mov_ %esi,$nulls
        call sysea
        Dec_ _rc_
        js   call_1
        Dec_ _rc_
        jns  ppm_0002
        Jmp_ ini08
ppm_0002:
call_1:
        Jmp_ ini08
        Mov_ _rc_,$329
        Jmp_ err_
ini08:
        Mov_ %edi,$endmo
        Mov_ %ecx,endml
        call syspr
        Dec_ _rc_
        js   call_2
        Dec_ _rc_
        jns  ppm_0003
        Mov_ _rc_,$299
        Jmp_ err_
ppm_0003:
call_2:
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        Mov_ %ebx,$num10
        call sysej
ini09:
        Mov_ %edi,statb
        call insta
        Mov_ %ecx,$e_hnb
        ldi_ %ecx
        sti_ hshnb
        Mov_ _hshtb,%edi
ini11:
        Xor_ %eax,%eax
        Mov_ %eax,%eax
        stosl
        Dec_ %ecx
        jnz  ini11
        Mov_ hshte,%edi
        Mov_ _state,%edi
        Mov_ %edx,$num01
        Mov_ %esi,$nulls
        Mov_ r_sfc,%esi
        call tmake
        Mov_ r_sfn,%edi
        Mov_ %edx,$num01
        Mov_ %esi,$nulls
        call tmake
        Mov_ r_inc,%edi
        Mov_ %ecx,$ccinm
        Mov_ %esi,$nulls
        call vmake
        Dec_ _rc_
        js   call_3
        Dec_ _rc_
        jns  ppm_0004
        Mov_ _rc_,$299
        Jmp_ err_
ppm_0004:
call_3:
        Mov_ r_ifa,%edi
        Mov_ %ecx,$ccinm
        Mov_ %esi,$inton
        call vmake
        Dec_ _rc_
        js   call_4
        Dec_ _rc_
        jns  ppm_0005
        Mov_ _rc_,$299
        Jmp_ err_
ppm_0005:
call_4:
        Mov_ r_ifl,%edi
        Mov_ %esi,$v_inp
        Mov_ %ebx,$trtin
        call inout
        Mov_ %esi,$v_oup
        Mov_ %ebx,$trtou
        call inout
        Mov_ %edx,initr
        or   %edx,%edx
        jz   ini13
        call prpar
ini13:
        call sysdc
        Mov_ _flptr,%esp
        call cmpil
        Mov_ r_cod,%edi
        Mov_ r_ttl,$nulls
        Mov_ r_stl,$nulls
        Xor_ %eax,%eax
        Mov_ r_cim,%eax
        Xor_ %eax,%eax
        Mov_ r_ccb,%eax
        Xor_ %eax,%eax
        Mov_ cnind,%eax
        Xor_ %eax,%eax
        Mov_ lstid,%eax
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Xor_ %eax,%eax
        Mov_ dnams,%eax
        call gbcol
        Mov_ dnams,%edi
        Xor_ %eax,%eax
        Cmp_ cpsts,%eax
        jnz  inix0
        call prtpg
        call prtmm
        ldi_ cmerc
        Mov_ %edi,$encm3
        call prtmi
        ldi_ gbcnt
        Mov_ %eax,intv1
        sbi_
        Mov_ %edi,$stpm5
        call prtmi
        call systm
        Mov_ %eax,timsx
        sbi_
        Mov_ %edi,$encm4
        call prtmi
        Add_ lstlc,$num05
        Xor_ %eax,%eax
        Cmp_ headp,%eax
        jz   inix0
        call prtpg
inix0:
        Cmp_ cswin,$iniln
        ja   inix1
        Mov_ cswin,$inils
inix1:
        call systm
        sti_ timsx
        Xor_ %eax,%eax
        Mov_ gbcnt,%eax
        call sysbx
        Mov_ %eax,cswex
        Add_ noxeq,%eax
        Xor_ %eax,%eax
        Cmp_ noxeq,%eax
        jnz  inix2
iniy0:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ headp,%eax
        Xor_ %eax,%eax
        push %eax
        Mov_ _flptr,%esp
        Mov_ %edi,r_cod
        Mov_ stage,$stgxt
        Mov_ polcs,$num01
        Mov_ _polct,$num01
        Mov_ %eax,cmpsn
        Mov_ pfnte,%eax
        Mov_ %eax,kvpfl
        Mov_ pfdmp,%eax
        call systm
        sti_ pfstm
        call stgcc
        Jmp_ *(%edi)
inix2:
        Xor_ %eax,%eax
        Mov_ %ecx,%eax
        Mov_ %ebx,$nini9
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        call sysej
rstrt:
        Mov_ %esp,_stbas
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        Jmp_ iniy0
	Align_	2
	nop
o_add:
        call arith
        Dec_ _rc_
        js   call_5
        Dec_ _rc_
        jns  ppm_0006
        Mov_ _rc_,$1
        Jmp_ err_
ppm_0006:
        Dec_ _rc_
        jns  ppm_0007
        Mov_ _rc_,$2
        Jmp_ err_
ppm_0007:
        Dec_ _rc_
        jns  ppm_0008
        Jmp_ oadd1
ppm_0008:
call_5:
        Mov_ %eax,4(%esi)
        adi_
        ino_ exint
        Mov_ _rc_,$3
        Jmp_ err_
oadd1:
        Mov_ %eax,%esi
        Add_ %eax,(cfp_b*rcval)
        call adr_
        rno_ exrea
        Mov_ _rc_,$261
        Jmp_ err_
	Align_	2
	nop
o_aff:
        pop  %edi
        call gtnum
        Dec_ _rc_
        js   call_6
        Dec_ _rc_
        jns  ppm_0009
        Mov_ _rc_,$4
        Jmp_ err_
ppm_0009:
call_6:
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
o_alt:
        pop  %edi
        call gtpat
        Dec_ _rc_
        js   call_7
        Dec_ _rc_
        jns  ppm_0010
        Mov_ _rc_,$5
        Jmp_ err_
ppm_0010:
call_7:
oalt1:
        Mov_ %ebx,$p_alt
        call pbild
        Mov_ %esi,%edi
        pop  %edi
        call gtpat
        Dec_ _rc_
        js   call_8
        Dec_ _rc_
        jns  ppm_0011
        Mov_ _rc_,$6
        Jmp_ err_
ppm_0011:
call_8:
        Cmp_ %edi,$p_alt
        je   oalt2
        Mov_ 4(%esi),%edi
        push %esi
        Lcw_ %edi
        Jmp_ *(%edi)
oalt2:
        Mov_ %eax,8(%edi)
        Mov_ 4(%esi),%eax
        push 4(%edi)
        Mov_ %edi,%esi
        Jmp_ oalt1
	Align_	2
	nop
o_amn:
        Lcw_ %edi
        Mov_ %ebx,%edi
        Jmp_ arref
	Align_	2
	nop
o_amv:
        Lcw_ %edi
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Jmp_ arref
	Align_	2
	nop
o_aon:
        Mov_ %edi,(%esp)
        Mov_ %esi,4(%esp)
        Mov_ %ecx,(%esi)
        Cmp_ %ecx,$b_vct
        je   oaon2
        Cmp_ %ecx,$b_tbt
        je   oaon3
oaon1:
        Mov_ %edi,$num01
        Mov_ %ebx,%edi
        Jmp_ arref
oaon2:
        Cmp_ (%edi),$_b_icl
        jne  oaon1
        ldi_ 4(%edi)
        sti_ %eax
        or   %eax,%eax
        js   exfal
        sti_ %ecx
        or   %ecx,%ecx
        jz   exfal
        Add_ %ecx,$vcvlb
        Sal_ %ecx,$2
        Mov_ (%esp),%ecx
        Cmp_ %ecx,8(%esi)
        jb   oaon4
        Jmp_ exfal
oaon3:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %ebx,%eax
        call tfind
        Dec_ _rc_
        js   call_9
        Dec_ _rc_
        jns  ppm_0012
        Jmp_ exfal
ppm_0012:
call_9:
        Mov_ 4(%esp),%esi
        Mov_ (%esp),%ecx
oaon4:
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
o_aov:
        pop  %edi
        pop  %esi
        Mov_ %ecx,(%esi)
        Cmp_ %ecx,$b_vct
        je   oaov2
        Cmp_ %ecx,$b_tbt
        je   oaov3
oaov1:
        push %esi
        push %edi
        Mov_ %edi,$num01
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Jmp_ arref
oaov2:
        Cmp_ (%edi),$_b_icl
        jne  oaov1
        ldi_ 4(%edi)
        sti_ %eax
        or   %eax,%eax
        js   exfal
        sti_ %ecx
        or   %ecx,%ecx
        jz   exfal
        Add_ %ecx,$vcvlb
        Sal_ %ecx,$2
        Cmp_ %ecx,8(%esi)
        jae  exfal
        call acess
        Dec_ _rc_
        js   call_10
        Dec_ _rc_
        jns  ppm_0013
        Jmp_ exfal
ppm_0013:
call_10:
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
oaov3:
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        call tfind
        Dec_ _rc_
        js   call_11
        Dec_ _rc_
        jns  ppm_0014
        Jmp_ exfal
ppm_0014:
call_11:
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
o_ass:
oass0:
        pop  %ebx
        pop  %ecx
        Mov_ %esi,(%esp)
        Mov_ (%esp),%ebx
        call asign
        Dec_ _rc_
        js   call_12
        Dec_ _rc_
        jns  ppm_0015
        Jmp_ exfal
ppm_0015:
call_12:
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
o_cer:
        Mov_ _rc_,$7
        Jmp_ err_
	Align_	2
	nop
o_cas:
        pop  %edx
        pop  %edi
        Mov_ %ebx,$p_cas
        call pbild
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
o_cnc:
        Mov_ %edi,(%esp)
        Cmp_ %edi,$nulls
        je   ocnc3
        Mov_ %esi,0(%esp)
        Cmp_ %esi,$nulls
        je   ocnc4
        Mov_ %ecx,$_b_scl
        Cmp_ %ecx,(%esi)
        jne  ocnc2
        Cmp_ %ecx,(%edi)
        jne  ocnc2
ocnc1:
        Mov_ %ecx,4(%esi)
        Add_ %ecx,4(%edi)
        call alocs
        Mov_ 0(%esp),%edi
        Add_ %edi,$cfp_f
        Mov_ %ecx,4(%esi)
        Add_ %esi,$cfp_f
        rep  movsb
        pop  %esi
        Mov_ %ecx,4(%esi)
        Add_ %esi,$cfp_f
        rep  movsb
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        Lcw_ %edi
        Jmp_ *(%edi)
ocnc2:
        call gtstg
        Dec_ _rc_
        js   call_13
        Dec_ _rc_
        jns  ppm_0018
        Jmp_ ocnc5
ppm_0018:
call_13:
        Mov_ %esi,%edi
        call gtstg
        Dec_ _rc_
        js   call_14
        Dec_ _rc_
        jns  ppm_0019
        Jmp_ ocnc6
ppm_0019:
call_14:
        push %edi
        push %esi
        Mov_ %esi,%edi
        Mov_ %edi,(%esp)
        Jmp_ ocnc1
ocnc3:
        Add_ %esp,$cfp_b
        Lcw_ %edi
        Jmp_ *(%edi)
ocnc4:
        Add_ %esp,$cfp_b
        Mov_ (%esp),%edi
        Lcw_ %edi
        Jmp_ *(%edi)
ocnc5:
        Mov_ %esi,%edi
        pop  %edi
ocnc6:
        call gtpat
        Dec_ _rc_
        js   call_15
        Dec_ _rc_
        jns  ppm_0020
        Mov_ _rc_,$8
        Jmp_ err_
ppm_0020:
call_15:
        push %edi
        Mov_ %edi,%esi
        call gtpat
        Dec_ _rc_
        js   call_16
        Dec_ _rc_
        jns  ppm_0021
        Mov_ _rc_,$9
        Jmp_ err_
ppm_0021:
call_16:
        Mov_ %esi,%edi
        pop  %edi
        call pconc
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
o_com:
        pop  %edi
        Mov_ %ecx,(%edi)
ocom1:
        Cmp_ %ecx,$_b_icl
        je   ocom2
        Cmp_ %ecx,$b_rcl
        je   ocom3
        call gtnum
        Dec_ _rc_
        js   call_17
        Dec_ _rc_
        jns  ppm_0022
        Mov_ _rc_,$10
        Jmp_ err_
ppm_0022:
call_17:
        Jmp_ ocom1
ocom2:
        ldi_ 4(%edi)
        ngi_
        ino_ exint
        Mov_ _rc_,$11
        Jmp_ err_
ocom3:
        Mov_ %eax,%edi
        Add_ %eax,(cfp_b*rcval)
        call ldr_
        call ngr_
        Jmp_ exrea
	Align_	2
	nop
o_dvd:
        call arith
        Dec_ _rc_
        js   call_18
        Dec_ _rc_
        jns  ppm_0023
        Mov_ _rc_,$12
        Jmp_ err_
ppm_0023:
        Dec_ _rc_
        jns  ppm_0024
        Mov_ _rc_,$13
        Jmp_ err_
ppm_0024:
        Dec_ _rc_
        jns  ppm_0025
        Jmp_ odvd2
ppm_0025:
call_18:
        Mov_ %eax,4(%esi)
        dvi_
        ino_ exint
        Mov_ _rc_,$14
        Jmp_ err_
odvd2:
        Mov_ %eax,%esi
        Add_ %eax,(cfp_b*rcval)
        call dvr_
        rno_ exrea
        Mov_ _rc_,$262
        Jmp_ err_
	Align_	2
	nop
o_exp:
        pop  %edi
        call gtnum
        Dec_ _rc_
        js   call_19
        Dec_ _rc_
        jns  ppm_0026
        Mov_ _rc_,$15
        Jmp_ err_
ppm_0026:
call_19:
        Mov_ %esi,%edi
        pop  %edi
        call gtnum
        Dec_ _rc_
        js   call_20
        Dec_ _rc_
        jns  ppm_0027
        Mov_ _rc_,$16
        Jmp_ err_
ppm_0027:
call_20:
        Cmp_ (%esi),$b_rcl
        je   oexp7
        ldi_ 4(%esi)
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jl   oex12
        Cmp_ %ecx,$b_rcl
        je   oexp3
        sti_ %eax
        or   %eax,%eax
        js   oexp2
        sti_ %ecx
        ldi_ 4(%edi)
        or   %ecx,%ecx
        jnz  oexp1
        Mov_ %eax,reg_ia
        or   %eax,%eax
        je   oexp4
        ldi_ intv1
        Jmp_ exint
oex13:
        Mov_ %eax,4(%edi)
        mli_
        iov_ oexp2
oexp1:
        Dec_ %ecx
        jnz  oex13
        Jmp_ exint
oexp2:
        Mov_ _rc_,$17
        Jmp_ err_
oexp3:
        sti_ %eax
        or   %eax,%eax
        js   oexp6
        sti_ %ecx
        Mov_ %eax,%edi
        Add_ %eax,(cfp_b*rcval)
        call ldr_
        or   %ecx,%ecx
        jnz  oexp5
        call cpr_
        movb reg_fl,%al
        or   %al,%al
        je   oexp4
        Mov_ %eax,$reav1
        call ldr_
        Jmp_ exrea
oexp4:
        Mov_ _rc_,$18
        Jmp_ err_
oex14:
        Mov_ %eax,%edi
        Add_ %eax,(cfp_b*rcval)
        call mlr_
        rov_ oexp6
oexp5:
        Dec_ %ecx
        jnz  oex14
        Jmp_ exrea
oexp6:
        Mov_ _rc_,$266
        Jmp_ err_
oexp7:
        Cmp_ (%edi),$b_rcl
        je   oexp8
        ldi_ 4(%edi)
        call itr_
        call rcbld
oexp8:
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Mov_ %eax,%edi
        Add_ %eax,(cfp_b*rcval)
        call ldr_
        call cpr_
        movb reg_fl,%al
        or   %al,%al
        jne  oexp9
        Mov_ %eax,%esi
        Add_ %eax,(cfp_b*rcval)
        call ldr_
        call cpr_
        movb reg_fl,%al
        or   %al,%al
        je   oexp4
        Mov_ %eax,$reav0
        call ldr_
        Jmp_ exrea
oexp9:
        call cpr_
        movb reg_fl,%al
        or   %al,%al
        jg   oex10
        call ngr_
        call rcbld
        Mov_ %eax,%esi
        Add_ %eax,(cfp_b*rcval)
        call ldr_
        call chp_
        call rti_
        jc   oexp6
        Mov_ %eax,%esi
        Add_ %eax,(cfp_b*rcval)
        call sbr_
        call cpr_
        movb reg_fl,%al
        or   %al,%al
        jne  oex11
        sti_ %ebx
        And_ %ebx,bits1
        Mov_ %eax,%edi
        Add_ %eax,(cfp_b*rcval)
        call ldr_
oex10:
        call lnf_
        rov_ oexp6
        Mov_ %eax,%esi
        Add_ %eax,(cfp_b*rcval)
        call mlr_
        rov_ oexp6
        call etx_
        rov_ oexp6
        or   %ebx,%ebx
        jz   exrea
        call ngr_
        Jmp_ exrea
oex11:
        Mov_ _rc_,$311
        Jmp_ err_
oex12:
        push %edi
        call itr_
        call rcbld
        Mov_ %esi,%edi
        pop  %edi
        Jmp_ oexp7
	Align_	2
	nop
o_fex:
        Jmp_ evlx6
	Align_	2
	nop
o_fif:
        Mov_ _rc_,$20
        Jmp_ err_
	Align_	2
	nop
o_fnc:
        Lcw_ %ecx
        Lcw_ %edi
        Mov_ %esi,20(%edi)
        Cmp_ %ecx,4(%esi)
        jne  cfunc
        Jmp_ *(%esi)
	Align_	2
	nop
o_fne:
        Lcw_ %ecx
        Cmp_ %ecx,$ornm_
        jne  ofne1
        Xor_ %eax,%eax
        Cmp_ 8(%esp),%eax
        jz   evlx3
ofne1:
        Mov_ _rc_,$21
        Jmp_ err_
	Align_	2
	nop
o_fns:
        Lcw_ %edi
        Mov_ %ecx,$num01
        Mov_ %esi,20(%edi)
        Cmp_ %ecx,4(%esi)
        jne  cfunc
        Jmp_ *(%esi)
	Align_	2
	nop
o_fun:
        Mov_ _rc_,$22
        Jmp_ err_
	Align_	2
	nop
o_goc:
        Mov_ %edi,4(%esp)
        Cmp_ %edi,_state
        ja   ogoc1
        Add_ %edi,$4*vrtra
        Jmp_ *(%edi)
ogoc1:
        Mov_ _rc_,$23
        Jmp_ err_
	Align_	2
	nop
o_god:
        Mov_ %edi,(%esp)
        Mov_ %ecx,(%edi)
        Cmp_ %ecx,$b_cds
        je   bcds0
        Cmp_ %ecx,$b_cdc
        je   bcdc0
        Mov_ _rc_,$24
        Jmp_ err_
	Align_	2
	nop
o_gof:
        Mov_ %edi,_flptr
        Add_ (%edi),$cfp_b
        Icp_
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
o_ima:
        Mov_ %ebx,$p_imc
        pop  %edx
        pop  %edi
        call pbild
        Mov_ %esi,%edi
        Mov_ %edi,(%esp)
        call gtpat
        Dec_ _rc_
        js   call_21
        Dec_ _rc_
        jns  ppm_0028
        Mov_ _rc_,$25
        Jmp_ err_
ppm_0028:
call_21:
        Mov_ (%esp),%edi
        Mov_ %ebx,$p_ima
        call pbild
        pop  4(%edi)
        call pconc
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
o_inn:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %ebx,%eax
        Jmp_ indir
	Align_	2
	nop
o_int:
        Mov_ (%esp),$nulls
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
o_inv:
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Jmp_ indir
	Align_	2
	nop
o_kwn:
        call kwnam
        Jmp_ exnam
	Align_	2
	nop
o_kwv:
        call kwnam
        Mov_ _dnamp,%edi
        call acess
        Dec_ _rc_
        js   call_22
        Dec_ _rc_
        jns  ppm_0029
        Jmp_ exnul
ppm_0029:
call_22:
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
o_lex:
        Mov_ %ecx,$4*evsi_
        call alloc
        Mov_ (%edi),$b_evt
        Mov_ 8(%edi),$trbev
        Lcw_ %ecx
        Mov_ 4(%edi),%ecx
        Mov_ %esi,%edi
        Mov_ %ecx,$4*evvar
        Jmp_ exnam
	Align_	2
	nop
o_lpt:
        Lcw_ %edi
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
o_lvn:
        Lcw_ %ecx
        push %ecx
        push $4*vrval
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
o_mlt:
        call arith
        Dec_ _rc_
        js   call_23
        Dec_ _rc_
        jns  ppm_0030
        Mov_ _rc_,$26
        Jmp_ err_
ppm_0030:
        Dec_ _rc_
        jns  ppm_0031
        Mov_ _rc_,$27
        Jmp_ err_
ppm_0031:
        Dec_ _rc_
        jns  ppm_0032
        Jmp_ omlt1
ppm_0032:
call_23:
        Mov_ %eax,4(%esi)
        mli_
        ino_ exint
        Mov_ _rc_,$28
        Jmp_ err_
omlt1:
        Mov_ %eax,%esi
        Add_ %eax,(cfp_b*rcval)
        call mlr_
        rno_ exrea
        Mov_ _rc_,$263
        Jmp_ err_
	Align_	2
	nop
o_nam:
        Mov_ %ecx,$4*nmsi_
        call alloc
        Mov_ (%edi),$b_nml
        pop  8(%edi)
        pop  4(%edi)
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
o_nta:
        Lcw_ %ecx
        push _flptr
        push %ecx
        Mov_ _flptr,%esp
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
o_ntb:
        Mov_ %eax,8(%esp)
        Mov_ _flptr,%eax
        Jmp_ exfal
	Align_	2
	nop
o_ntc:
        Add_ %esp,$cfp_b
        pop  _flptr
        Jmp_ exnul
	Align_	2
	nop
o_oun:
        Mov_ _rc_,$29
        Jmp_ err_
	Align_	2
	nop
o_pas:
        Mov_ %ebx,$p_pac
        pop  %edx
        pop  %edi
        call pbild
        Mov_ %esi,%edi
        Mov_ %edi,(%esp)
        call gtpat
        Dec_ _rc_
        js   call_24
        Dec_ _rc_
        jns  ppm_0033
        Mov_ _rc_,$30
        Jmp_ err_
ppm_0033:
call_24:
        Mov_ (%esp),%edi
        Mov_ %ebx,$p_paa
        call pbild
        pop  4(%edi)
        call pconc
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
o_pmn:
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Jmp_ match
	Align_	2
	nop
o_pms:
        Mov_ %ebx,$num02
        Jmp_ match
	Align_	2
	nop
o_pmv:
        Mov_ %ebx,$num01
        Jmp_ match
	Align_	2
	nop
o_pop:
        Add_ %esp,$cfp_b
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
o_stp:
        Jmp_ lend0
	Align_	2
	nop
o_rnm:
        Jmp_ evlx4
	Align_	2
	nop
o_rpl:
        call gtstg
        Dec_ _rc_
        js   call_25
        Dec_ _rc_
        jns  ppm_0034
        Mov_ _rc_,$31
        Jmp_ err_
ppm_0034:
call_25:
        Mov_ %esi,(%esp)
        Add_ %ecx,4(%esi)
        Add_ %ecx,8(%esp)
        Sub_ %ecx,4(%esp)
        or   %ecx,%ecx
        jz   orpl3
        push %edi
        call alocs
        Mov_ %ecx,12(%esp)
        Mov_ 12(%esp),%edi
        Add_ %edi,$cfp_f
        or   %ecx,%ecx
        jz   orpl1
        Mov_ %esi,4(%esp)
        Add_ %esi,$cfp_f
        rep  movsb
orpl1:
        pop  %esi
        Mov_ %ecx,4(%esi)
        or   %ecx,%ecx
        jz   orpl2
        Add_ %esi,$cfp_f
        rep  movsb
orpl2:
        pop  %esi
        pop  %edx
        Mov_ %ecx,4(%esi)
        Sub_ %ecx,%edx
        or   %ecx,%ecx
        jz   oass0
        Add_ %esi,%edx
        Add_ %esi,$cfp_f
        rep  movsb
        Jmp_ oass0
orpl3:
        Add_ %esp,$4*num02
        Mov_ (%esp),$nulls
        Jmp_ oass0
	Align_	2
	nop
o_rvl:
        Jmp_ evlx3
	Align_	2
	nop
o_sla:
        Lcw_ %ecx
        push _flptr
        push %ecx
        Mov_ _flptr,%esp
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
o_slb:
        pop  %edi
        Add_ %esp,$cfp_b
        Mov_ %eax,(%esp)
        Mov_ _flptr,%eax
        Mov_ (%esp),%edi
        Lcw_ %ecx
        Add_ %ecx,r_cod
        Lcp_ %ecx
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
o_slc:
        Lcw_ %ecx
        Mov_ (%esp),%ecx
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
o_sld:
        Add_ %esp,$cfp_b
        pop  _flptr
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
o_sub:
        call arith
        Dec_ _rc_
        js   call_26
        Dec_ _rc_
        jns  ppm_0038
        Mov_ _rc_,$32
        Jmp_ err_
ppm_0038:
        Dec_ _rc_
        jns  ppm_0039
        Mov_ _rc_,$33
        Jmp_ err_
ppm_0039:
        Dec_ _rc_
        jns  ppm_0040
        Jmp_ osub1
ppm_0040:
call_26:
        Mov_ %eax,4(%esi)
        sbi_
        ino_ exint
        Mov_ _rc_,$34
        Jmp_ err_
osub1:
        Mov_ %eax,%esi
        Add_ %eax,(cfp_b*rcval)
        call sbr_
        rno_ exrea
        Mov_ _rc_,$264
        Jmp_ err_
	Align_	2
	nop
o_txr:
        Jmp_ trxq1
	Align_	2
	nop
o_unf:
        Mov_ _rc_,$35
        Jmp_ err_
	Align_	2
	.byte	bl__i
b_aaa:
	Align_	2
	.byte	bl_ex
b_exl:
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	.byte	bl_se
b_sel:
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	.byte	bl__i
b_e__:
	Align_	2
	.byte	bl_tr
b_trt:
	Align_	2
	.byte	bl__i
b_t__:
	Align_	2
	.byte	bl_ar
b_art:
	Align_	2
	.byte	bl_bc
b_bct:
	Align_	2
	.byte	bl_bf
b_bft:
	Align_	2
	.byte	bl_cc
b_cct:
	Align_	2
	.byte	bl_cd
b_cdc:
bcdc0:
        Mov_ %esp,_flptr
        Mov_ %eax,16(%edi)
        Mov_ (%esp),%eax
        Jmp_ stmgo
	Align_	2
	.byte	bl_cd
b_cds:
bcds0:
        Mov_ %esp,_flptr
        Mov_ (%esp),$4*cdfal
        Jmp_ stmgo
	Align_	2
	.byte	bl_cm
b_cmt:
	Align_	2
	.byte	bl_ct
b_ctt:
	Align_	2
	.byte	bl_df
b_dfc:
        Mov_ %ecx,12(%esi)
        call alloc
        Mov_ (%edi),$b_pdt
        Mov_ 8(%edi),%esi
        Mov_ %edx,%edi
        Add_ %edi,%ecx
        Mov_ %ecx,4(%esi)
bdfc1:
        Sub_ %edi,$4
        pop  (%edi)
        Dec_ %ecx
        jnz  bdfc1
        Mov_ %edi,%edx
        Jmp_ exsid
	Align_	2
	.byte	bl_ef
b_efc:
        Mov_ %edx,4(%esi)
        Sal_ %edx,$2
        push %esi
        Mov_ %esi,%esp
befc1:
        Add_ %esi,$cfp_b
        Mov_ %edi,(%esp)
        Sub_ %edx,$cfp_b
        Add_ %edi,%edx
        Mov_ %edi,28(%edi)
        jmp  *bsw_0041(,%edi,4)
        Data
bsw_0041:
        .long befc7
        .long befc2
        .long befc3
        .long befc4
        .long beff1
        Text
beff1:
        push %esi
        Mov_ befof,%edx
        push (%esi)
        call iofcb
        Dec_ _rc_
        js   call_27
        Dec_ _rc_
        jns  ppm_0042
        Mov_ _rc_,$298
        Jmp_ err_
ppm_0042:
        Dec_ _rc_
        jns  ppm_0043
        Mov_ _rc_,$298
        Jmp_ err_
ppm_0043:
        Dec_ _rc_
        jns  ppm_0044
        Mov_ _rc_,$298
        Jmp_ err_
ppm_0044:
call_27:
        Mov_ %edi,%ecx
        pop  %esi
        Jmp_ befc5
befc2:
        push (%esi)
        call gtstg
        Dec_ _rc_
        js   call_28
        Dec_ _rc_
        jns  ppm_0045
        Mov_ _rc_,$39
        Jmp_ err_
ppm_0045:
call_28:
        Jmp_ befc6
befc3:
        Mov_ %edi,(%esi)
        Mov_ befof,%edx
        call gtint
        Dec_ _rc_
        js   call_29
        Dec_ _rc_
        jns  ppm_0046
        Mov_ _rc_,$40
        Jmp_ err_
ppm_0046:
call_29:
        Jmp_ befc5
befc4:
        Mov_ %edi,(%esi)
        Mov_ befof,%edx
        call gtrea
        Dec_ _rc_
        js   call_30
        Dec_ _rc_
        jns  ppm_0047
        Mov_ _rc_,$265
        Jmp_ err_
ppm_0047:
call_30:
befc5:
        Mov_ %edx,befof
befc6:
        Mov_ (%esi),%edi
befc7:
        or   %edx,%edx
        jnz  befc1
        pop  %esi
        Mov_ %ecx,4(%esi)
        call sysex
        Dec_ _rc_
        js   call_31
        Dec_ _rc_
        jns  ppm_0048
        Jmp_ exfal
ppm_0048:
        Dec_ _rc_
        jns  ppm_0049
        Mov_ _rc_,$327
        Jmp_ err_
ppm_0049:
        Dec_ _rc_
        jns  ppm_0050
        Mov_ _rc_,$326
        Jmp_ err_
ppm_0050:
call_31:
        Sal_ %ecx,$2
        Add_ %esp,%ecx
        Mov_ %ebx,24(%esi)
        or   %ebx,%ebx
        jnz  befa8
        Cmp_ (%edi),$_b_scl
        jne  befc8
        Xor_ %eax,%eax
        Cmp_ 4(%edi),%eax
        jz   exnul
befa8:
        Cmp_ %ebx,$num01
        jne  befc8
        Xor_ %eax,%eax
        Cmp_ 4(%edi),%eax
        jz   exnul
befc8:
        Cmp_ %edi,_dnamb
        jb   befc9
        Cmp_ %edi,_dnamp
        jbe  exixr
befc9:
        Mov_ %ecx,(%edi)
        or   %ebx,%ebx
        jz   bef11
        Mov_ %ecx,$_b_scl
        Cmp_ %ebx,$num01
        je   bef10
        Mov_ %ecx,$_b_icl
        Cmp_ %ebx,$num02
        je   bef10
        Mov_ %ecx,$b_rcl
bef10:
        Mov_ (%edi),%ecx
bef11:
        Cmp_ (%edi),$_b_scl
        je   bef12
        call blkln
        Mov_ %esi,%edi
        call alloc
        push %edi
        Sar_ %ecx,$2
        rep  movsl
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        Lcw_ %edi
        Jmp_ *(%edi)
bef12:
        Mov_ %esi,%edi
        Mov_ %ecx,4(%edi)
        or   %ecx,%ecx
        jz   exnul
        call alocs
        push %edi
        Add_ %edi,$cfp_f
        Add_ %esi,$cfp_f
        Mov_ %ecx,%edx
        rep  movsb
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	.byte	bl_ev
b_evt:
	Align_	2
	.byte	bl_ff
b_ffc:
        Mov_ %edi,%esi
        Lcw_ %edx
        Mov_ %esi,(%esp)
        Cmp_ (%esi),$b_pdt
        jne  bffc2
        Mov_ %ecx,8(%esi)
bffc1:
        Cmp_ %ecx,8(%edi)
        je   bffc3
        Mov_ %edi,12(%edi)
        or   %edi,%edi
        jnz  bffc1
bffc2:
        Mov_ _rc_,$41
        Jmp_ err_
bffc3:
        Mov_ %ecx,16(%edi)
        Cmp_ %edx,$ofne_
        je   bffc5
        Add_ %esi,%ecx
        Mov_ %edi,(%esi)
        Cmp_ (%edi),$b_trt
        jne  bffc4
        Sub_ %esi,%ecx
        Mov_ (%esp),%edx
        call acess
        Dec_ _rc_
        js   call_32
        Dec_ _rc_
        jns  ppm_0052
        Jmp_ exfal
ppm_0052:
call_32:
        Mov_ %edx,(%esp)
bffc4:
        Mov_ (%esp),%edi
        Mov_ %edi,%edx
        Mov_ %esi,(%edi)
        Jmp_ *%esi
bffc5:
        push %ecx
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	.byte	bl_ic
_b_icl:
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	.byte	bl_kv
b_kvt:
	Align_	2
	.byte	bl_nm
b_nml:
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	.byte	bl_pd
b_pdt:
	Align_	2
	.byte	bl_pf
b_pfc:
        Mov_ bpfpf,%esi
        Mov_ %edi,%esi
        Mov_ %esi,12(%edi)
bpf01:
        Mov_ %ebx,%esi
        Mov_ %esi,8(%esi)
        Cmp_ (%esi),$b_trt
        je   bpf01
        Mov_ bpfsv,%esi
        Mov_ %esi,%ebx
        Mov_ 8(%esi),$nulls
        Mov_ %ecx,4(%edi)
        Add_ %edi,$4*pfarg
        or   %ecx,%ecx
        jz   bpf04
        Mov_ %esi,%esp
        Sal_ %ecx,$2
        Add_ %esi,%ecx
        Mov_ bpfxt,%esi
bpf02:
        Mov_ %esi,(%edi)
        Add_ %edi,$4
bpf03:
        Mov_ %edx,%esi
        Mov_ %esi,8(%esi)
        Cmp_ (%esi),$b_trt
        je   bpf03
        Mov_ %ecx,%esi
        Mov_ %esi,bpfxt
        Sub_ %esi,$4
        Mov_ %ebx,(%esi)
        Mov_ (%esi),%ecx
        Mov_ bpfxt,%esi
        Mov_ %esi,%edx
        Mov_ 8(%esi),%ebx
        Cmp_ %esp,bpfxt
        jne  bpf02
bpf04:
        Mov_ %esi,bpfpf
        Mov_ %ecx,16(%esi)
        or   %ecx,%ecx
        jz   bpf07
        Mov_ %ebx,$nulls
bpf05:
        Mov_ %esi,(%edi)
        Add_ %edi,$4
bpf06:
        Mov_ %edx,%esi
        Mov_ %esi,8(%esi)
        Cmp_ (%esi),$b_trt
        je   bpf06
        push %esi
        Mov_ %esi,%edx
        Mov_ 8(%esi),%ebx
        Dec_ %ecx
        jnz  bpf05
bpf07:
        Xor_ %eax,%eax
        Mov_ %edi,%eax
        Xor_ %eax,%eax
        Cmp_ kvpfl,%eax
        jz   bpf7c
        Cmp_ kvpfl,$num02
        je   bpf7a
        call systm
        sti_ pfetm
        Mov_ %eax,pfstm
        sbi_
        call icbld
        ldi_ pfetm
        Jmp_ bpf7b
bpf7a:
        ldi_ pfstm
        call icbld
        call systm
bpf7b:
        sti_ pfstm
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ pffnc,%eax
bpf7c:
        push %edi
        Mov_ %ecx,r_cod
        Scp_ %ebx
        Sub_ %ebx,%ecx
        Mov_ %esi,bpfpf
        push bpfsv
        push %ecx
        push %ebx
        push _flprt
        push _flptr
        push %esi
        Xor_ %eax,%eax
        push %eax
        chk_
        or   %eax,%eax
        jne  sec06
        Mov_ _flptr,%esp
        Mov_ _flprt,%esp
        Mov_ %ecx,kvtra
        Add_ %ecx,kvftr
        or   %ecx,%ecx
        jnz  bpf09
        Inc_ kvfnc
bpf08:
        Mov_ %edi,20(%esi)
        Mov_ %edi,16(%edi)
        Cmp_ %edi,$stndl
        je   bpf17
        Cmp_ (%edi),$b_trt
        jne  bpf8a
        Mov_ %edi,8(%edi)
bpf8a:
        Jmp_ *(%edi)
bpf09:
        Mov_ %edi,24(%esi)
        Mov_ %esi,12(%esi)
        Mov_ %ecx,$4*vrval
        Xor_ %eax,%eax
        Cmp_ kvtra,%eax
        jz   bpf10
        or   %edi,%edi
        jz   bpf10
        Dec_ kvtra
        Xor_ %eax,%eax
        Cmp_ 16(%edi),%eax
        jz   bpf11
        call trxeq
bpf10:
        Xor_ %eax,%eax
        Cmp_ kvftr,%eax
        jz   bpf16
        Dec_ kvftr
bpf11:
        call prtsn
        call prtnm
        Mov_ %ecx,$ch_pp
        call prtch
        Mov_ %esi,4(%esp)
        Xor_ %eax,%eax
        Cmp_ 4(%esi),%eax
        jz   bpf15
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Jmp_ bpf13
bpf12:
        Mov_ %ecx,$ch_cm
        call prtch
bpf13:
        Mov_ (%esp),%ebx
        Sal_ %ebx,$2
        Add_ %esi,%ebx
        Mov_ %edi,32(%esi)
        Sub_ %esi,%ebx
        Mov_ %edi,8(%edi)
        call prtvl
        Mov_ %ebx,(%esp)
        Inc_ %ebx
        Cmp_ %ebx,4(%esi)
        jb   bpf12
bpf15:
        Mov_ %ecx,$ch_rp
        call prtch
        call prtnl
bpf16:
        Inc_ kvfnc
        Mov_ %esi,r_fnc
        call ktrex
        Mov_ %esi,4(%esp)
        Jmp_ bpf08
bpf17:
        Mov_ %eax,8(%esp)
        Mov_ _flptr,%eax
        Mov_ _rc_,$286
        Jmp_ err_
	Align_	2
	.byte	bl_rc
b_rcl:
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	.byte	bl_sc
_b_scl:
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	.byte	bl_tb
b_tbt:
	Align_	2
	.byte	bl_te
b_tet:
	Align_	2
	.byte	bl_vc
b_vct:
	Align_	2
	.byte	bl__i
b_vr_:
	Align_	2
	.byte	bl__i
b_vra:
        Mov_ %esi,%edi
        Mov_ %ecx,$4*vrval
        call acess
        Dec_ _rc_
        js   call_33
        Dec_ _rc_
        jns  ppm_0053
        Jmp_ exfal
ppm_0053:
call_33:
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
b_vre:
        Mov_ _rc_,$42
        Jmp_ err_
	Align_	2
	nop
b_vrg:
        Mov_ %edi,4(%edi)
        Mov_ %esi,(%edi)
        Jmp_ *%esi
	Align_	2
	nop
b_vrl:
        push 8(%edi)
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
b_vrs:
        Mov_ %eax,(%esp)
        Mov_ 4(%edi),%eax
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
b_vrt:
        Sub_ %edi,$4*vrtra
        Mov_ %esi,%edi
        Mov_ %ecx,$4*vrval
        Mov_ %edi,16(%esi)
        Xor_ %eax,%eax
        Cmp_ kvtra,%eax
        jz   bvrt2
        Dec_ kvtra
        Xor_ %eax,%eax
        Cmp_ 16(%edi),%eax
        jz   bvrt1
        call trxeq
        Jmp_ bvrt2
bvrt1:
        call prtsn
        Mov_ %edi,%esi
        Mov_ %ecx,$ch_cl
        call prtch
        Mov_ %ecx,$ch_pp
        call prtch
        call prtvn
        Mov_ %ecx,$ch_rp
        call prtch
        call prtnl
        Mov_ %edi,16(%esi)
bvrt2:
        Mov_ %edi,8(%edi)
        Jmp_ *(%edi)
	Align_	2
	nop
b_vrv:
        Mov_ %ebx,(%esp)
        Sub_ %edi,$4*vrsto
        Mov_ %esi,%edi
        Mov_ %ecx,$4*vrval
        call asign
        Dec_ _rc_
        js   call_34
        Dec_ _rc_
        jns  ppm_0054
        Jmp_ exfal
ppm_0054:
call_34:
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	.byte	bl_xn
_b_xnt:
	Align_	2
	.byte	bl_xr
_b_xrt:
	Align_	2
	.byte	bl__i
b_yyy:
	Align_	2
	.byte	bl__i
p_aaa:
	Align_	2
	.byte	bl_p0
p_aba:
        push %ebx
        push %edi
        push _pmhbs
        push $ndabb
        Mov_ _pmhbs,%esp
        Jmp_ succp
	Align_	2
	nop
p_abb:
        Mov_ _pmhbs,%ebx
        Jmp_ flpop
	Align_	2
	.byte	bl_p0
p_abc:
        Mov_ %esi,_pmhbs
        Mov_ %ecx,12(%esi)
        Mov_ %eax,4(%esi)
        Mov_ _pmhbs,%eax
        Cmp_ %esi,%esp
        je   pabc1
        push %esi
        push $ndabd
        Jmp_ pabc2
pabc1:
        Add_ %esp,$4*num04
pabc2:
        Cmp_ %ecx,%ebx
        jne  succp
        Mov_ %edi,4(%edi)
        Jmp_ succp
	Align_	2
	nop
p_abd:
        Mov_ _pmhbs,%ebx
        Jmp_ failp
	Align_	2
	.byte	bl_p0
p_abo:
        Jmp_ exfal
	Align_	2
	.byte	bl_p1
p_alt:
        push %ebx
        push 8(%edi)
        chk_
        or   %eax,%eax
        jne  sec06
        Jmp_ succp
	Align_	2
	.byte	bl_p1
p_ans:
        Cmp_ %ebx,pmssl
        je   failp
        Mov_ %esi,r_pms
        Add_ %esi,%ebx
        Add_ %esi,$cfp_f
#lch s.text (xl)  s.type 9  s.reg xl
#lch d.text wa  d.type 8  d.reg wa  w 0
        Xor_ %ecx,%ecx
        movb (%esi),%cl
        Cmp_ %ecx,8(%edi)
        jne  failp
        Inc_ %ebx
        Jmp_ succp
	Align_	2
	.byte	bl_p2
p_any:
pany1:
        Cmp_ %ebx,pmssl
        je   failp
        Mov_ %esi,r_pms
        Add_ %esi,%ebx
        Add_ %esi,$cfp_f
#lch s.text (xl)  s.type 9  s.reg xl
#lch d.text wa  d.type 8  d.reg wa  w 0
        Xor_ %ecx,%ecx
        movb (%esi),%cl
        Mov_ %esi,8(%edi)
        Sal_ %ecx,$2
        Add_ %esi,%ecx
        Mov_ %ecx,4(%esi)
        And_ %ecx,12(%edi)
        or   %ecx,%ecx
        jz   failp
        Inc_ %ebx
        Jmp_ succp
	Align_	2
	.byte	bl_p1
p_ayd:
        call evals
        Dec_ _rc_
        js   call_35
        Dec_ _rc_
        jns  ppm_0055
        Mov_ _rc_,$43
        Jmp_ err_
ppm_0055:
        Dec_ _rc_
        jns  ppm_0056
        Jmp_ failp
ppm_0056:
        Dec_ _rc_
        jns  ppm_0057
        Jmp_ pany1
ppm_0057:
call_35:
	Align_	2
	.byte	bl_p0
p_arb:
        Mov_ %edi,4(%edi)
        push %ebx
        push %edi
        push %ebx
        push $ndarc
        Jmp_ *(%edi)
	Align_	2
	nop
p_arc:
        Cmp_ %ebx,pmssl
        je   flpop
        Inc_ %ebx
        push %ebx
        push %edi
        Mov_ %edi,8(%esp)
        Jmp_ *(%edi)
	Align_	2
	.byte	bl_p0
p_bal:
        Xor_ %eax,%eax
        Mov_ %edx,%eax
        Mov_ %esi,r_pms
        Add_ %esi,%ebx
        Add_ %esi,$cfp_f
        Jmp_ pbal2
pbal1:
#lch s.text (xl)+  s.type 10  s.reg xl
#lch d.text wa  d.type 8  d.reg wa  w 0
        Xor_ %eax,%eax
        lodsb
        Mov_ %ecx,%eax
        Inc_ %ebx
        Cmp_ %ecx,$ch_pp
        je   pbal3
        Cmp_ %ecx,$ch_rp
        je   pbal4
        or   %edx,%edx
        jz   pbal5
pbal2:
        Cmp_ %ebx,pmssl
        jne  pbal1
        Jmp_ failp
pbal3:
        Inc_ %edx
        Jmp_ pbal2
pbal4:
        or   %edx,%edx
        jz   failp
        Dec_ %edx
        or   %edx,%edx
        jnz  pbal2
pbal5:
        push %ebx
        push %edi
        Jmp_ succp
	Align_	2
	.byte	bl_p1
p_bkd:
        call evals
        Dec_ _rc_
        js   call_36
        Dec_ _rc_
        jns  ppm_0058
        Mov_ _rc_,$44
        Jmp_ err_
ppm_0058:
        Dec_ _rc_
        jns  ppm_0059
        Jmp_ failp
ppm_0059:
        Dec_ _rc_
        jns  ppm_0060
        Jmp_ pbrk1
ppm_0060:
call_36:
	Align_	2
	.byte	bl_p1
p_bks:
        Mov_ %edx,pmssl
        Sub_ %edx,%ebx
        or   %edx,%edx
        jz   failp
        Mov_ %esi,r_pms
        Add_ %esi,%ebx
        Add_ %esi,$cfp_f
pbks1:
#lch s.text (xl)+  s.type 10  s.reg xl
#lch d.text wa  d.type 8  d.reg wa  w 0
        Xor_ %eax,%eax
        lodsb
        Mov_ %ecx,%eax
        Cmp_ %ecx,8(%edi)
        je   succp
        Inc_ %ebx
        Dec_ %edx
        jnz  pbks1
        Jmp_ failp
	Align_	2
	.byte	bl_p2
p_brk:
pbrk1:
        Mov_ %edx,pmssl
        Sub_ %edx,%ebx
        or   %edx,%edx
        jz   failp
        Mov_ %esi,r_pms
        Add_ %esi,%ebx
        Add_ %esi,$cfp_f
        Mov_ psave,%edi
pbrk2:
#lch s.text (xl)+  s.type 10  s.reg xl
#lch d.text wa  d.type 8  d.reg wa  w 0
        Xor_ %eax,%eax
        lodsb
        Mov_ %ecx,%eax
        Mov_ %edi,8(%edi)
        Sal_ %ecx,$2
        Add_ %edi,%ecx
        Mov_ %ecx,4(%edi)
        Mov_ %edi,psave
        And_ %ecx,12(%edi)
        or   %ecx,%ecx
        jnz  succp
        Inc_ %ebx
        Dec_ %edx
        jnz  pbrk2
        Jmp_ failp
	Align_	2
	.byte	bl_p0
p_bkx:
        Inc_ %ebx
        Jmp_ succp
	Align_	2
	.byte	bl_p1
p_bxd:
        call evals
        Dec_ _rc_
        js   call_37
        Dec_ _rc_
        jns  ppm_0061
        Mov_ _rc_,$45
        Jmp_ err_
ppm_0061:
        Dec_ _rc_
        jns  ppm_0062
        Jmp_ failp
ppm_0062:
        Dec_ _rc_
        jns  ppm_0063
        Jmp_ pbrk1
ppm_0063:
call_37:
	Align_	2
	.byte	bl_p2
p_cas:
        push %edi
        push %ebx
        Mov_ %esi,8(%edi)
        ldi_ %ebx
        Mov_ %ebx,12(%edi)
        call icbld
        Mov_ %ecx,%ebx
        Mov_ %ebx,%edi
        call asinp
        Dec_ _rc_
        js   call_38
        Dec_ _rc_
        jns  ppm_0064
        Jmp_ flpop
ppm_0064:
call_38:
        pop  %ebx
        pop  %edi
        Jmp_ succp
	Align_	2
	.byte	bl_p1
p_exa:
        call evalp
        Dec_ _rc_
        js   call_39
        Dec_ _rc_
        jns  ppm_0065
        Jmp_ failp
ppm_0065:
call_39:
        Cmp_ %ecx,$p_aaa
        jb   pexa1
        push %ebx
        push %edi
        push _pmhbs
        push $ndexb
        Mov_ _pmhbs,%esp
        Mov_ %edi,%esi
        Jmp_ *(%edi)
pexa1:
        Cmp_ %ecx,$_b_scl
        je   pexa2
        push %esi
        Mov_ %esi,%edi
        call gtstg
        Dec_ _rc_
        js   call_40
        Dec_ _rc_
        jns  ppm_0066
        Mov_ _rc_,$46
        Jmp_ err_
ppm_0066:
call_40:
        Mov_ %edx,%edi
        Mov_ %edi,%esi
        Mov_ %esi,%edx
pexa2:
        Xor_ %eax,%eax
        Cmp_ 4(%esi),%eax
        jz   succp
        Jmp_ pstr1
	Align_	2
	nop
p_exb:
        Mov_ _pmhbs,%ebx
        Jmp_ flpop
	Align_	2
	nop
p_exc:
        Mov_ _pmhbs,%ebx
        Jmp_ failp
	Align_	2
	.byte	bl_p0
p_fal:
        Jmp_ failp
	Align_	2
	.byte	bl_p0
p_fen:
        push %ebx
        push $ndabo
        Jmp_ succp
	Align_	2
	.byte	bl_p0
p_fna:
        push _pmhbs
        push $ndfnb
        Mov_ _pmhbs,%esp
        Jmp_ succp
	Align_	2
	.byte	bl_p0
p_fnb:
        Mov_ _pmhbs,%ebx
        Jmp_ failp
	Align_	2
	.byte	bl_p0
p_fnc:
        Mov_ %esi,_pmhbs
        Mov_ %eax,4(%esi)
        Mov_ _pmhbs,%eax
        Cmp_ %esi,%esp
        je   pfnc1
        push %esi
        push $ndfnd
        Jmp_ succp
pfnc1:
        Add_ %esp,$4*num02
        Jmp_ succp
	Align_	2
	.byte	bl_p0
p_fnd:
        Mov_ %esp,%ebx
        Jmp_ flpop
	Align_	2
	.byte	bl_p0
p_ima:
        push %ebx
        push %edi
        push _pmhbs
        push $ndimb
        Mov_ _pmhbs,%esp
        Jmp_ succp
	Align_	2
	nop
p_imb:
        Mov_ _pmhbs,%ebx
        Jmp_ flpop
	Align_	2
	.byte	bl_p2
p_imc:
        Mov_ %esi,_pmhbs
        Mov_ %ecx,%ebx
        Mov_ %ebx,12(%esi)
        Mov_ %eax,4(%esi)
        Mov_ _pmhbs,%eax
        Cmp_ %esi,%esp
        je   pimc1
        push %esi
        push $ndimd
        Jmp_ pimc2
pimc1:
        Add_ %esp,$4*num04
pimc2:
        push %ecx
        push %edi
        Mov_ %esi,r_pms
        Sub_ %ecx,%ebx
        call sbstr
        Mov_ %ebx,%edi
        Mov_ %edi,(%esp)
        Mov_ %esi,8(%edi)
        Mov_ %ecx,12(%edi)
        call asinp
        Dec_ _rc_
        js   call_41
        Dec_ _rc_
        jns  ppm_0067
        Jmp_ flpop
ppm_0067:
call_41:
        pop  %edi
        pop  %ebx
        Jmp_ succp
	Align_	2
	nop
p_imd:
        Mov_ _pmhbs,%ebx
        Jmp_ failp
	Align_	2
	.byte	bl_p1
p_len:
plen1:
        Add_ %ebx,8(%edi)
        Cmp_ %ebx,pmssl
        jbe  succp
        Jmp_ failp
	Align_	2
	.byte	bl_p1
p_lnd:
        call evali
        Dec_ _rc_
        js   call_42
        Dec_ _rc_
        jns  ppm_0068
        Mov_ _rc_,$47
        Jmp_ err_
ppm_0068:
        Dec_ _rc_
        jns  ppm_0069
        Mov_ _rc_,$48
        Jmp_ err_
ppm_0069:
        Dec_ _rc_
        jns  ppm_0070
        Jmp_ failp
ppm_0070:
        Dec_ _rc_
        jns  ppm_0071
        Jmp_ plen1
ppm_0071:
call_42:
	Align_	2
	.byte	bl_p1
p_nad:
        call evals
        Dec_ _rc_
        js   call_43
        Dec_ _rc_
        jns  ppm_0072
        Mov_ _rc_,$49
        Jmp_ err_
ppm_0072:
        Dec_ _rc_
        jns  ppm_0073
        Jmp_ failp
ppm_0073:
        Dec_ _rc_
        jns  ppm_0074
        Jmp_ pnay1
ppm_0074:
call_43:
	Align_	2
	.byte	bl_p1
p_nas:
        Cmp_ %ebx,pmssl
        je   failp
        Mov_ %esi,r_pms
        Add_ %esi,%ebx
        Add_ %esi,$cfp_f
#lch s.text (xl)  s.type 9  s.reg xl
#lch d.text wa  d.type 8  d.reg wa  w 0
        Xor_ %ecx,%ecx
        movb (%esi),%cl
        Cmp_ %ecx,8(%edi)
        je   failp
        Inc_ %ebx
        Jmp_ succp
	Align_	2
	.byte	bl_p2
p_nay:
pnay1:
        Cmp_ %ebx,pmssl
        je   failp
        Mov_ %esi,r_pms
        Add_ %esi,%ebx
        Add_ %esi,$cfp_f
#lch s.text (xl)  s.type 9  s.reg xl
#lch d.text wa  d.type 8  d.reg wa  w 0
        Xor_ %ecx,%ecx
        movb (%esi),%cl
        Sal_ %ecx,$2
        Mov_ %esi,8(%edi)
        Add_ %esi,%ecx
        Mov_ %ecx,4(%esi)
        And_ %ecx,12(%edi)
        or   %ecx,%ecx
        jnz  failp
        Inc_ %ebx
        Jmp_ succp
	Align_	2
	.byte	bl_p0
p_nth:
        Mov_ %esi,_pmhbs
        Mov_ %ecx,4(%esi)
        Cmp_ %ecx,$num02
        jbe  pnth2
        Mov_ _pmhbs,%ecx
        Mov_ %edi,8(%esi)
        Cmp_ %esi,%esp
        je   pnth1
        push %esi
        push $ndexc
        Jmp_ succp
pnth1:
        Add_ %esp,$4*num04
        Jmp_ succp
pnth2:
        Mov_ pmssl,%ebx
        Xor_ %eax,%eax
        Cmp_ pmdfl,%eax
        jz   pnth6
pnth3:
        Sub_ %esi,$cfp_b
        Sub_ %esi,$4
        Mov_ %ecx,(%esi)
        Cmp_ %ecx,$ndpad
        je   pnth4
        Cmp_ %ecx,$ndpab
        jne  pnth5
        push 4(%esi)
        chk_
        or   %eax,%eax
        jne  sec06
        Jmp_ pnth3
pnth4:
        Mov_ %ecx,4(%esi)
        Mov_ %ebx,(%esp)
        Mov_ (%esp),%esi
        Sub_ %ecx,%ebx
        Mov_ %esi,r_pms
        call sbstr
        Mov_ %ebx,%edi
        Mov_ %esi,(%esp)
        Mov_ %esi,8(%esi)
        Mov_ %ecx,12(%esi)
        Mov_ %esi,8(%esi)
        call asinp
        Dec_ _rc_
        js   call_44
        Dec_ _rc_
        jns  ppm_0075
        Jmp_ exfal
ppm_0075:
call_44:
        pop  %esi
pnth5:
        Cmp_ %esi,%esp
        jne  pnth3
pnth6:
        Mov_ %esp,_pmhbs
        pop  %ebx
        pop  %edx
        Mov_ %ecx,pmssl
        Mov_ %esi,r_pms
        Xor_ %eax,%eax
        Mov_ r_pms,%eax
        or   %edx,%edx
        jz   pnth7
        Cmp_ %edx,$num02
        je   pnth9
        Sub_ %ecx,%ebx
        call sbstr
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
pnth7:
        push %ebx
        push %ecx
pnth8:
        push %esi
pnth9:
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	.byte	bl_p1
p_pos:
        Cmp_ %ebx,8(%edi)
        je   succp
        or   %ebx,%ebx
        jnz  failp
        Mov_ %esi,_pmhbs
        Sub_ %esi,$4
        Cmp_ %edi,(%esi)
        jne  failp
ppos2:
        Sub_ %esi,$4
        Cmp_ (%esi),$nduna
        jne  failp
        Mov_ %ebx,8(%edi)
        Cmp_ %ebx,pmssl
        ja   exfal
        Mov_ 8(%esi),%ebx
        Jmp_ succp
	Align_	2
	.byte	bl_p1
p_psd:
        call evali
        Dec_ _rc_
        js   call_45
        Dec_ _rc_
        jns  ppm_0076
        Mov_ _rc_,$50
        Jmp_ err_
ppm_0076:
        Dec_ _rc_
        jns  ppm_0077
        Mov_ _rc_,$51
        Jmp_ err_
ppm_0077:
        Dec_ _rc_
        jns  ppm_0078
        Jmp_ failp
ppm_0078:
        Dec_ _rc_
        jns  ppm_0079
        Jmp_ ppos1
ppm_0079:
call_45:
ppos1:
        Cmp_ %ebx,8(%edi)
        je   succp
        or   %ebx,%ebx
        jnz  failp
        Xor_ %eax,%eax
        Cmp_ evlif,%eax
        jnz  failp
        Mov_ %esi,_pmhbs
        Mov_ %ecx,evlio
        Sub_ %esi,$4
        Cmp_ %ecx,(%esi)
        jne  failp
        Jmp_ ppos2
	Align_	2
	.byte	bl_p0
p_paa:
        push %ebx
        push $ndpab
        Jmp_ succp
	Align_	2
	nop
p_pab:
        Jmp_ failp
	Align_	2
	.byte	bl_p2
p_pac:
        push %ebx
        push %edi
        push %ebx
        push $ndpad
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ pmdfl,%eax
        Jmp_ succp
	Align_	2
	nop
p_pad:
        Jmp_ flpop
	Align_	2
	.byte	bl_p0
p_rem:
        Mov_ %ebx,pmssl
        Jmp_ succp
	Align_	2
	.byte	bl_p1
p_rpd:
        call evali
        Dec_ _rc_
        js   call_46
        Dec_ _rc_
        jns  ppm_0080
        Mov_ _rc_,$52
        Jmp_ err_
ppm_0080:
        Dec_ _rc_
        jns  ppm_0081
        Mov_ _rc_,$53
        Jmp_ err_
ppm_0081:
        Dec_ _rc_
        jns  ppm_0082
        Jmp_ failp
ppm_0082:
        Dec_ _rc_
        jns  ppm_0083
        Jmp_ prps1
ppm_0083:
call_46:
prps1:
        Mov_ %edx,pmssl
        Sub_ %edx,%ebx
        Cmp_ %edx,8(%edi)
        je   succp
        or   %ebx,%ebx
        jnz  failp
        Xor_ %eax,%eax
        Cmp_ evlif,%eax
        jnz  failp
        Mov_ %esi,_pmhbs
        Mov_ %ecx,evlio
        Sub_ %esi,$4
        Cmp_ %ecx,(%esi)
        jne  failp
        Jmp_ prps2
	Align_	2
	.byte	bl_p1
p_rps:
        Mov_ %edx,pmssl
        Sub_ %edx,%ebx
        Cmp_ %edx,8(%edi)
        je   succp
        or   %ebx,%ebx
        jnz  failp
        Mov_ %esi,_pmhbs
        Sub_ %esi,$4
        Cmp_ %edi,(%esi)
        jne  failp
prps2:
        Sub_ %esi,$4
        Cmp_ (%esi),$nduna
        jne  failp
        Mov_ %ebx,pmssl
        Cmp_ %ebx,8(%edi)
        jb   failp
        Sub_ %ebx,8(%edi)
        Mov_ 8(%esi),%ebx
        Jmp_ succp
	Align_	2
	.byte	bl_p1
p_rtb:
prtb1:
        Mov_ %edx,%ebx
        Mov_ %ebx,pmssl
        Cmp_ %ebx,8(%edi)
        jb   failp
        Sub_ %ebx,8(%edi)
        Cmp_ %ebx,%edx
        jae  succp
        Jmp_ failp
	Align_	2
	.byte	bl_p1
p_rtd:
        call evali
        Dec_ _rc_
        js   call_47
        Dec_ _rc_
        jns  ppm_0084
        Mov_ _rc_,$54
        Jmp_ err_
ppm_0084:
        Dec_ _rc_
        jns  ppm_0085
        Mov_ _rc_,$55
        Jmp_ err_
ppm_0085:
        Dec_ _rc_
        jns  ppm_0086
        Jmp_ failp
ppm_0086:
        Dec_ _rc_
        jns  ppm_0087
        Jmp_ prtb1
ppm_0087:
call_47:
	Align_	2
	.byte	bl_p1
p_spd:
        call evals
        Dec_ _rc_
        js   call_48
        Dec_ _rc_
        jns  ppm_0088
        Mov_ _rc_,$56
        Jmp_ err_
ppm_0088:
        Dec_ _rc_
        jns  ppm_0089
        Jmp_ failp
ppm_0089:
        Dec_ _rc_
        jns  ppm_0090
        Jmp_ pspn1
ppm_0090:
call_48:
	Align_	2
	.byte	bl_p2
p_spn:
pspn1:
        Mov_ %edx,pmssl
        Sub_ %edx,%ebx
        or   %edx,%edx
        jz   failp
        Mov_ %esi,r_pms
        Add_ %esi,%ebx
        Add_ %esi,$cfp_f
        Mov_ psavc,%ebx
        Mov_ psave,%edi
pspn2:
#lch s.text (xl)+  s.type 10  s.reg xl
#lch d.text wa  d.type 8  d.reg wa  w 0
        Xor_ %eax,%eax
        lodsb
        Mov_ %ecx,%eax
        Sal_ %ecx,$2
        Mov_ %edi,8(%edi)
        Add_ %edi,%ecx
        Mov_ %ecx,4(%edi)
        Mov_ %edi,psave
        And_ %ecx,12(%edi)
        or   %ecx,%ecx
        jz   pspn3
        Inc_ %ebx
        Dec_ %edx
        jnz  pspn2
pspn3:
        Cmp_ %ebx,psavc
        jne  succp
        Jmp_ failp
	Align_	2
	.byte	bl_p1
p_sps:
        Mov_ %edx,pmssl
        Sub_ %edx,%ebx
        or   %edx,%edx
        jz   failp
        Mov_ %esi,r_pms
        Add_ %esi,%ebx
        Add_ %esi,$cfp_f
        Mov_ psavc,%ebx
psps1:
#lch s.text (xl)+  s.type 10  s.reg xl
#lch d.text wa  d.type 8  d.reg wa  w 0
        Xor_ %eax,%eax
        lodsb
        Mov_ %ecx,%eax
        Cmp_ %ecx,8(%edi)
        jne  psps2
        Inc_ %ebx
        Dec_ %edx
        jnz  psps1
psps2:
        Cmp_ %ebx,psavc
        jne  succp
        Jmp_ failp
	Align_	2
	.byte	bl_p1
p_str:
        Mov_ %esi,8(%edi)
pstr1:
        Mov_ psave,%edi
        Mov_ %edi,r_pms
        Add_ %edi,%ebx
        Add_ %edi,$cfp_f
        Add_ %ebx,4(%esi)
        Cmp_ %ebx,pmssl
        ja   failp
        Mov_ psavc,%ebx
        Mov_ %ecx,4(%esi)
        Add_ %esi,$cfp_f
        repe cmpsb
        Xor_ %esi,%esi
        Xor_ %edi,%esi
        jnz  failp
        Mov_ %edi,psave
        Mov_ %ebx,psavc
        Jmp_ succp
	Align_	2
	.byte	bl_p0
p_suc:
        push %ebx
        push %edi
        Jmp_ succp
	Align_	2
	.byte	bl_p1
p_tab:
ptab1:
        Cmp_ %ebx,8(%edi)
        ja   failp
        Mov_ %ebx,8(%edi)
        Cmp_ %ebx,pmssl
        jbe  succp
        Jmp_ failp
	Align_	2
	.byte	bl_p1
p_tbd:
        call evali
        Dec_ _rc_
        js   call_49
        Dec_ _rc_
        jns  ppm_0091
        Mov_ _rc_,$57
        Jmp_ err_
ppm_0091:
        Dec_ _rc_
        jns  ppm_0092
        Mov_ _rc_,$58
        Jmp_ err_
ppm_0092:
        Dec_ _rc_
        jns  ppm_0093
        Jmp_ failp
ppm_0093:
        Dec_ _rc_
        jns  ppm_0094
        Jmp_ ptab1
ppm_0094:
call_49:
	Align_	2
	nop
p_una:
        Mov_ %edi,%ebx
        Mov_ %ebx,(%esp)
        Cmp_ %ebx,pmssl
        je   exfal
        Inc_ %ebx
        Mov_ (%esp),%ebx
        push %edi
        push $nduna
        Jmp_ *(%edi)
	Align_	2
	.byte	bl__i
p_yyy:
	Align_	2
	nop
l_abo:
labo1:
        Mov_ %ecx,kvert
        or   %ecx,%ecx
        jz   labo3
        call sysax
        Mov_ %edx,kvstn
        call filnm
        Mov_ %edi,r_cod
        Mov_ %edx,8(%edi)
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Mov_ %edi,stage
        call sysea
        Dec_ _rc_
        js   call_50
        Dec_ _rc_
        jns  ppm_0095
        Jmp_ stpr4
ppm_0095:
call_50:
        call prtpg
        or   %edi,%edi
        jz   labo2
        call prtst
labo2:
        call ermsg
        Xor_ %eax,%eax
        Mov_ %edi,%eax
        Jmp_ stopr
labo3:
        Mov_ _rc_,$36
        Jmp_ err_
	Align_	2
	nop
l_cnt:
lcnt1:
        Mov_ %edi,r_cnt
        or   %edi,%edi
        jz   lcnt3
        Xor_ %eax,%eax
        Mov_ r_cnt,%eax
        Mov_ r_cod,%edi
        Cmp_ (%edi),$b_cdc
        jne  lcnt2
        Mov_ %ecx,stxoc
        Cmp_ %ecx,stxof
        jae  lcnt4
lcnt2:
        Add_ %edi,stxof
        Lcp_ %edi
        Mov_ %esp,_flptr
        Lcw_ %edi
        Jmp_ *(%edi)
lcnt3:
        Inc_ errft
        Mov_ _rc_,$37
        Jmp_ err_
lcnt4:
        Inc_ errft
        Mov_ _rc_,$332
        Jmp_ err_
	Align_	2
	nop
l_end:
lend0:
        Mov_ %edi,$endms
        Jmp_ stopr
	Align_	2
	nop
l_frt:
        Mov_ %ecx,$scfrt
        Jmp_ retrn
	Align_	2
	nop
l_nrt:
        Mov_ %ecx,$scnrt
        Jmp_ retrn
	Align_	2
	nop
l_rtn:
        Mov_ %ecx,$scrtn
        Jmp_ retrn
	Align_	2
	nop
l_scn:
        Mov_ %edi,r_cnt
        or   %edi,%edi
        jz   lscn2
        Xor_ %eax,%eax
        Mov_ r_cnt,%eax
        Cmp_ kvert,$nm320
        jne  lscn1
        Cmp_ kvert,$nm321
        je   lscn2
        Mov_ r_cod,%edi
        Add_ %edi,stxoc
        Lcp_ %edi
        Lcw_ %edi
        Jmp_ *(%edi)
lscn1:
        Inc_ errft
        Mov_ _rc_,$331
        Jmp_ err_
lscn2:
        Inc_ errft
        Mov_ _rc_,$321
        Jmp_ err_
	Align_	2
	nop
l_und:
        Mov_ _rc_,$38
        Jmp_ err_
	Align_	2
	nop
s_any:
        Mov_ %ebx,$p_ans
        Mov_ %esi,$p_any
        Mov_ %edx,$p_ayd
        call patst
        Dec_ _rc_
        js   call_51
        Dec_ _rc_
        jns  ppm_0096
        Mov_ _rc_,$59
        Jmp_ err_
ppm_0096:
call_51:
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
s_app:
        or   %ecx,%ecx
        jz   sapp3
        Dec_ %ecx
        Mov_ %ebx,%ecx
        Sal_ %ebx,$2
        Mov_ %esi,%esp
        Add_ %esi,%ebx
        Mov_ %edi,(%esi)
        or   %ecx,%ecx
        jz   sapp2
        Mov_ %ebx,%ecx
sapp1:
        Sub_ %esi,$cfp_b
        Mov_ %eax,(%esi)
        Mov_ 4(%esi),%eax
        Dec_ %ebx
        jnz  sapp1
sapp2:
        Add_ %esp,$cfp_b
        call gtnvr
        Dec_ _rc_
        js   call_52
        Dec_ _rc_
        jns  ppm_0097
        Jmp_ sapp3
ppm_0097:
call_52:
        Mov_ %esi,20(%edi)
        Jmp_ cfunc
sapp3:
        Mov_ _rc_,$60
        Jmp_ err_
	Align_	2
	nop
s_abn:
        Xor_ %eax,%eax
        Mov_ %edi,%eax
        Mov_ %ebx,$p_alt
        call pbild
        Mov_ %esi,%edi
        Mov_ %ebx,$p_abc
        Xor_ %eax,%eax
        Mov_ %edi,%eax
        call pbild
        Mov_ 4(%edi),%esi
        Mov_ %ecx,%esi
        Mov_ %esi,%edi
        Mov_ %edi,(%esp)
        Mov_ (%esp),%ecx
        call gtpat
        Dec_ _rc_
        js   call_53
        Dec_ _rc_
        jns  ppm_0098
        Mov_ _rc_,$61
        Jmp_ err_
ppm_0098:
call_53:
        call pconc
        Mov_ %esi,%edi
        Mov_ %ebx,$p_aba
        Xor_ %eax,%eax
        Mov_ %edi,%eax
        call pbild
        Mov_ 4(%edi),%esi
        Mov_ %esi,(%esp)
        Mov_ 8(%esi),%edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
s_arg:
        call gtsmi
        Dec_ _rc_
        js   call_54
        Dec_ _rc_
        jns  ppm_0099
        Mov_ _rc_,$62
        Jmp_ err_
ppm_0099:
        Dec_ _rc_
        jns  ppm_0100
        Jmp_ exfal
ppm_0100:
call_54:
        Mov_ %ecx,%edi
        pop  %edi
        call gtnvr
        Dec_ _rc_
        js   call_55
        Dec_ _rc_
        jns  ppm_0101
        Jmp_ sarg1
ppm_0101:
call_55:
        Mov_ %edi,20(%edi)
        Cmp_ (%edi),$b_pfc
        jne  sarg1
        or   %ecx,%ecx
        jz   exfal
        Cmp_ %ecx,4(%edi)
        ja   exfal
        Sal_ %ecx,$2
        Add_ %edi,%ecx
        Mov_ %edi,28(%edi)
        Jmp_ exvnm
sarg1:
        Mov_ _rc_,$63
        Jmp_ err_
	Align_	2
	nop
s_arr:
        pop  %esi
        pop  %edi
        call gtint
        Dec_ _rc_
        js   call_56
        Dec_ _rc_
        jns  ppm_0102
        Jmp_ sar02
ppm_0102:
call_56:
        ldi_ 4(%edi)
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jle  sar10
        sti_ %eax
        or   %eax,%eax
        js   sar11
        sti_ %ecx
        call vmake
        Dec_ _rc_
        js   call_57
        Dec_ _rc_
        jns  ppm_0103
        Jmp_ sar11
ppm_0103:
call_57:
        Jmp_ exsid
sar02:
        push %edi
        call xscni
        Dec_ _rc_
        js   call_58
        Dec_ _rc_
        jns  ppm_0104
        Mov_ _rc_,$64
        Jmp_ err_
ppm_0104:
        Dec_ _rc_
        jns  ppm_0105
        Jmp_ exnul
ppm_0105:
call_58:
        push r_xsc
        push %esi
        Xor_ %eax,%eax
        Mov_ arcdm,%eax
        Xor_ %eax,%eax
        Mov_ arptr,%eax
        ldi_ intv1
        sti_ arnel
sar03:
        ldi_ intv1
        sti_ arsvl
        Mov_ %edx,$ch_cl
        Mov_ %esi,$ch_cm
        Xor_ %eax,%eax
        Mov_ %ecx,%eax
        call xscan
        Cmp_ %ecx,$num01
        jne  sar04
        call gtint
        Dec_ _rc_
        js   call_59
        Dec_ _rc_
        jns  ppm_0106
        Mov_ _rc_,$65
        Jmp_ err_
ppm_0106:
call_59:
        ldi_ 4(%edi)
        sti_ arsvl
        Mov_ %edx,$ch_cm
        Mov_ %esi,%edx
        Xor_ %eax,%eax
        Mov_ %ecx,%eax
        call xscan
sar04:
        call gtint
        Dec_ _rc_
        js   call_60
        Dec_ _rc_
        jns  ppm_0107
        Mov_ _rc_,$66
        Jmp_ err_
ppm_0107:
call_60:
        ldi_ 4(%edi)
        Mov_ %eax,arsvl
        sbi_
        iov_ sar10
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jl   sar10
        Mov_ %eax,intv1
        adi_
        iov_ sar10
        Mov_ %esi,arptr
        or   %esi,%esi
        jz   sar05
        Add_ %esi,(%esp)
        sti_ 4(%esi)
        ldi_ arsvl
        sti_ (%esi)
        Add_ arptr,$4*ardms
        Jmp_ sar06
sar05:
        Inc_ arcdm
        Mov_ %eax,arnel
        mli_
        iov_ sar11
        sti_ arnel
sar06:
        or   %ecx,%ecx
        jnz  sar03
        Xor_ %eax,%eax
        Cmp_ arptr,%eax
        jnz  sar09
        ldi_ arnel
        sti_ %eax
        or   %eax,%eax
        js   sar11
        sti_ %ebx
        Sal_ %ebx,$2
        Mov_ %ecx,$4*arsi_
        Mov_ %edx,arcdm
sar07:
        Add_ %ecx,$4*ardms
        Dec_ %edx
        jnz  sar07
        Mov_ %esi,%ecx
        Add_ %ecx,%ebx
        Add_ %ecx,$cfp_b
        Cmp_ %ecx,mxlen
        ja   sar11
        call alloc
        Mov_ %ebx,(%esp)
        Mov_ (%esp),%edi
        Mov_ %edx,%ecx
        Sar_ %ecx,$2
sar08:
        Mov_ %eax,%ebx
        stosl
        Dec_ %ecx
        jnz  sar08
        pop  %edi
        Mov_ %ebx,(%esp)
        Mov_ (%edi),$b_art
        Mov_ 8(%edi),%edx
        Xor_ %eax,%eax
        Mov_ 4(%edi),%eax
        Mov_ 12(%edi),%esi
        Mov_ %eax,arcdm
        Mov_ 16(%edi),%eax
        Mov_ %edx,%edi
        Add_ %edi,%esi
        Mov_ (%edi),%ebx
        Mov_ arptr,$4*arlbd
        Mov_ r_xsc,%ebx
        Mov_ (%esp),%edx
        Xor_ %eax,%eax
        Mov_ xsofs,%eax
        Jmp_ sar03
sar09:
        pop  %edi
        Jmp_ exsid
sar10:
        Mov_ _rc_,$67
        Jmp_ err_
sar11:
        Mov_ _rc_,$68
        Jmp_ err_
	Align_	2
	nop
s_atn:
        pop  %edi
        call gtrea
        Dec_ _rc_
        js   call_61
        Dec_ _rc_
        jns  ppm_0108
        Mov_ _rc_,$301
        Jmp_ err_
ppm_0108:
call_61:
        Mov_ %eax,%edi
        Add_ %eax,(cfp_b*rcval)
        call ldr_
        call atn_
        Jmp_ exrea
	Align_	2
	nop
s_bsp:
        call iofcb
        Dec_ _rc_
        js   call_62
        Dec_ _rc_
        jns  ppm_0109
        Mov_ _rc_,$316
        Jmp_ err_
ppm_0109:
        Dec_ _rc_
        jns  ppm_0110
        Mov_ _rc_,$316
        Jmp_ err_
ppm_0110:
        Dec_ _rc_
        jns  ppm_0111
        Mov_ _rc_,$317
        Jmp_ err_
ppm_0111:
call_62:
        call sysbs
        Dec_ _rc_
        js   call_63
        Dec_ _rc_
        jns  ppm_0112
        Mov_ _rc_,$317
        Jmp_ err_
ppm_0112:
        Dec_ _rc_
        jns  ppm_0113
        Mov_ _rc_,$318
        Jmp_ err_
ppm_0113:
        Dec_ _rc_
        jns  ppm_0114
        Mov_ _rc_,$319
        Jmp_ err_
ppm_0114:
call_63:
        Jmp_ exnul
	Align_	2
	nop
s_brk:
        Mov_ %ebx,$p_bks
        Mov_ %esi,$p_brk
        Mov_ %edx,$p_bkd
        call patst
        Dec_ _rc_
        js   call_64
        Dec_ _rc_
        jns  ppm_0115
        Mov_ _rc_,$69
        Jmp_ err_
ppm_0115:
call_64:
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
s_bkx:
        Mov_ %ebx,$p_bks
        Mov_ %esi,$p_brk
        Mov_ %edx,$p_bxd
        call patst
        Dec_ _rc_
        js   call_65
        Dec_ _rc_
        jns  ppm_0116
        Mov_ _rc_,$70
        Jmp_ err_
ppm_0116:
call_65:
        push %edi
        Mov_ %ebx,$p_bkx
        call pbild
        Mov_ %eax,(%esp)
        Mov_ 4(%edi),%eax
        Mov_ %ebx,$p_alt
        call pbild
        Mov_ %ecx,%edi
        Mov_ %edi,(%esp)
        Mov_ 4(%edi),%ecx
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
s_chr:
        call gtsmi
        Dec_ _rc_
        js   call_66
        Dec_ _rc_
        jns  ppm_0117
        Mov_ _rc_,$281
        Jmp_ err_
ppm_0117:
        Dec_ _rc_
        jns  ppm_0118
        Jmp_ schr1
ppm_0118:
call_66:
        Cmp_ %edx,$cfp_a
        jae  schr1
        Mov_ %ecx,$num01
        Mov_ %ebx,%edx
        call alocs
        Mov_ %esi,%edi
        Add_ %esi,$cfp_f
#sch s.text wb  s.type 8  s.reg wb
#sch d.text (xl)  d.type 9  d.reg xl  w 0
        movb %bl,(%esi)
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
schr1:
        Mov_ _rc_,$282
        Jmp_ err_
	Align_	2
	nop
s_chp:
        pop  %edi
        call gtrea
        Dec_ _rc_
        js   call_67
        Dec_ _rc_
        jns  ppm_0119
        Mov_ _rc_,$302
        Jmp_ err_
ppm_0119:
call_67:
        Mov_ %eax,%edi
        Add_ %eax,(cfp_b*rcval)
        call ldr_
        call chp_
        Jmp_ exrea
	Align_	2
	nop
s_clr:
        call xscni
        Dec_ _rc_
        js   call_68
        Dec_ _rc_
        jns  ppm_0120
        Mov_ _rc_,$71
        Jmp_ err_
ppm_0120:
        Dec_ _rc_
        jns  ppm_0121
        Jmp_ sclr2
ppm_0121:
call_68:
sclr1:
        Mov_ %edx,$ch_cm
        Mov_ %esi,%edx
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %ecx,%eax
        call xscan
        call gtnvr
        Dec_ _rc_
        js   call_69
        Dec_ _rc_
        jns  ppm_0122
        Mov_ _rc_,$72
        Jmp_ err_
ppm_0122:
call_69:
        Xor_ %eax,%eax
        Mov_ 0(%edi),%eax
        or   %ecx,%ecx
        jnz  sclr1
sclr2:
        Mov_ %ebx,_hshtb
sclr3:
        Cmp_ %ebx,hshte
        je   exnul
        Mov_ %edi,%ebx
        Add_ %ebx,$cfp_b
        Sub_ %edi,$4*vrnxt
sclr4:
        Mov_ %edi,24(%edi)
        or   %edi,%edi
        jz   sclr3
        Xor_ %eax,%eax
        Cmp_ 0(%edi),%eax
        jnz  sclr5
        call setvr
        Jmp_ sclr4
sclr5:
        Cmp_ 4(%edi),$b_vre
        je   sclr4
        Mov_ %esi,%edi
sclr6:
        Mov_ %ecx,%esi
        Mov_ %esi,8(%esi)
        Cmp_ (%esi),$b_trt
        je   sclr6
        Mov_ %esi,%ecx
        Mov_ 8(%esi),$nulls
        Jmp_ sclr4
	Align_	2
	nop
s_cod:
        pop  %edi
        call gtcod
        Dec_ _rc_
        js   call_70
        Dec_ _rc_
        jns  ppm_0123
        Jmp_ exfal
ppm_0123:
call_70:
        push %edi
        Xor_ %eax,%eax
        Mov_ r_ccb,%eax
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
s_col:
        pop  %edi
        call gtint
        Dec_ _rc_
        js   call_71
        Dec_ _rc_
        jns  ppm_0124
        Mov_ _rc_,$73
        Jmp_ err_
ppm_0124:
call_71:
        ldi_ 4(%edi)
        sti_ clsvi
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Xor_ %eax,%eax
        Mov_ r_ccb,%eax
        Xor_ %eax,%eax
        Mov_ dnams,%eax
        call gbcol
        Mov_ dnams,%edi
        Mov_ %ecx,dname
        Sub_ %ecx,_dnamp
        Sar_ %ecx,$2
        ldi_ %ecx
        Mov_ %eax,clsvi
        sbi_
        iov_ exfal
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jl   exfal
        Mov_ %eax,clsvi
        adi_
        Jmp_ exint
	Align_	2
	nop
s_cnv:
        call gtstg
        Dec_ _rc_
        js   call_72
        Dec_ _rc_
        jns  ppm_0125
        Jmp_ scv29
ppm_0125:
call_72:
        or   %ecx,%ecx
        jz   scv29
        call flstg
        Mov_ %esi,(%esp)
        Cmp_ (%esi),$b_pdt
        jne  scv01
        Mov_ %esi,8(%esi)
        Mov_ %esi,16(%esi)
        call ident
        Dec_ _rc_
        js   call_73
        Dec_ _rc_
        jns  ppm_0126
        Jmp_ exits
ppm_0126:
call_73:
        Jmp_ exfal
scv01:
        push %edi
        Mov_ %esi,$svctb
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Mov_ %edx,%ecx
scv02:
        lodsl
        Mov_ %edi,%eax
        or   %edi,%edi
        jz   exfal
        Cmp_ %edx,4(%edi)
        jne  scv05
        Mov_ cnvtp,%esi
        Add_ %edi,$cfp_f
        Mov_ %esi,(%esp)
        Add_ %esi,$cfp_f
        Mov_ %ecx,%edx
        repe cmpsb
        Xor_ %esi,%esi
        Xor_ %edi,%esi
        jnz  scv04
scv03:
        Mov_ %esi,%ebx
        Add_ %esp,$cfp_b
        pop  %edi
        jmp  *bsw_0127(,%esi,4)
        Data
bsw_0127:
        .long scv06
        .long scv07
        .long scv09
        .long scv10
        .long scv11
        .long scv19
        .long scv25
        .long scv26
        .long scv27
        .long scv08
        Text
scv04:
        Mov_ %esi,cnvtp
scv05:
        Inc_ %ebx
        Jmp_ scv02
scv06:
        push %edi
        call gtstg
        Dec_ _rc_
        js   call_74
        Dec_ _rc_
        jns  ppm_0128
        Jmp_ exfal
ppm_0128:
call_74:
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
scv07:
        call gtint
        Dec_ _rc_
        js   call_75
        Dec_ _rc_
        jns  ppm_0129
        Jmp_ exfal
ppm_0129:
call_75:
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
scv08:
        call gtrea
        Dec_ _rc_
        js   call_76
        Dec_ _rc_
        jns  ppm_0130
        Jmp_ exfal
ppm_0130:
call_76:
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
scv09:
        Cmp_ (%edi),$b_nml
        je   exixr
        call gtnvr
        Dec_ _rc_
        js   call_77
        Dec_ _rc_
        jns  ppm_0131
        Jmp_ exfal
ppm_0131:
call_77:
        Jmp_ exvnm
scv10:
        call gtpat
        Dec_ _rc_
        js   call_78
        Dec_ _rc_
        jns  ppm_0132
        Jmp_ exfal
ppm_0132:
call_78:
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
scv11:
        push %edi
        Xor_ %eax,%eax
        Mov_ %ecx,%eax
        call gtarr
        Dec_ _rc_
        js   call_79
        Dec_ _rc_
        jns  ppm_0133
        Jmp_ exfal
ppm_0133:
        Dec_ _rc_
        jns  ppm_0134
        Jmp_ exfal
ppm_0134:
call_79:
        pop  %esi
        Cmp_ (%esi),$b_tbt
        jne  exsid
        push %edi
        push $nulls
        Xor_ %eax,%eax
        Mov_ %ecx,%eax
        call sorta
        Dec_ _rc_
        js   call_80
        Dec_ _rc_
        jns  ppm_0135
        Jmp_ exfal
ppm_0135:
call_80:
        Mov_ %ebx,%edi
        ldi_ 24(%edi)
        sti_ %ecx
        Add_ %edi,$4*arvl2
scv12:
        Mov_ %esi,(%edi)
        Mov_ %eax,4(%esi)
        stosl
        Mov_ %eax,8(%esi)
        stosl
        Dec_ %ecx
        jnz  scv12
        Mov_ %edi,%ebx
        Jmp_ exsid
scv19:
        Mov_ %ecx,(%edi)
        push %edi
        Cmp_ %ecx,$b_tbt
        je   exits
        Cmp_ %ecx,$b_art
        jne  exfal
        Cmp_ 16(%edi),$num02
        jne  exfal
        ldi_ 32(%edi)
        Mov_ %eax,intv2
        sbi_
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jne  exfal
        ldi_ 24(%edi)
        sti_ %ecx
        Mov_ %ebx,%ecx
        Add_ %ecx,$tbsi_
        Sal_ %ecx,$2
        call alloc
        Mov_ %edx,%edi
        push %edi
        Mov_ %eax,$b_tbt
        stosl
        Xor_ %eax,%eax
        Mov_ %eax,%eax
        stosl
        Mov_ %eax,%ecx
        stosl
        Mov_ %eax,$nulls
        stosl
scv20:
        Mov_ %eax,%edx
        stosl
        Dec_ %ebx
        jnz  scv20
        Mov_ %ebx,$4*arvl2
scv21:
        Mov_ %esi,4(%esp)
        Cmp_ %ebx,8(%esi)
        je   scv24
        Add_ %esi,%ebx
        Add_ %ebx,$4*num02
        Mov_ %edi,(%esi)
        Sub_ %esi,$cfp_b
scv22:
        Mov_ %esi,8(%esi)
        Cmp_ (%esi),$b_trt
        je   scv22
scv23:
        push %esi
        Mov_ %esi,4(%esp)
        call tfind
        Dec_ _rc_
        js   call_81
        Dec_ _rc_
        jns  ppm_0136
        Jmp_ exfal
ppm_0136:
call_81:
        pop  8(%esi)
        Jmp_ scv21
scv24:
        pop  %edi
        Add_ %esp,$cfp_b
        Jmp_ exsid
scv25:
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        call gtexp
        Dec_ _rc_
        js   call_82
        Dec_ _rc_
        jns  ppm_0137
        Jmp_ exfal
ppm_0137:
call_82:
        Xor_ %eax,%eax
        Mov_ r_ccb,%eax
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
scv26:
        call gtcod
        Dec_ _rc_
        js   call_83
        Dec_ _rc_
        jns  ppm_0138
        Jmp_ exfal
ppm_0138:
call_83:
        Xor_ %eax,%eax
        Mov_ r_ccb,%eax
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
scv27:
        call gtnum
        Dec_ _rc_
        js   call_84
        Dec_ _rc_
        jns  ppm_0139
        Jmp_ exfal
ppm_0139:
call_84:
scv31:
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
scv29:
        Mov_ _rc_,$74
        Jmp_ err_
	Align_	2
	nop
s_cop:
        call copyb
        Dec_ _rc_
        js   call_85
        Dec_ _rc_
        jns  ppm_0140
        Jmp_ exits
ppm_0140:
call_85:
        Jmp_ exsid
	Align_	2
	nop
s_cos:
        pop  %edi
        call gtrea
        Dec_ _rc_
        js   call_86
        Dec_ _rc_
        jns  ppm_0141
        Mov_ _rc_,$303
        Jmp_ err_
ppm_0141:
call_86:
        Mov_ %eax,%edi
        Add_ %eax,(cfp_b*rcval)
        call ldr_
        call cos_
        rno_ exrea
        Mov_ _rc_,$322
        Jmp_ err_
	Align_	2
	nop
s_dat:
        call xscni
        Dec_ _rc_
        js   call_87
        Dec_ _rc_
        jns  ppm_0142
        Mov_ _rc_,$75
        Jmp_ err_
ppm_0142:
        Dec_ _rc_
        jns  ppm_0143
        Mov_ _rc_,$76
        Jmp_ err_
ppm_0143:
call_87:
        Mov_ %edx,$ch_pp
        Mov_ %esi,%edx
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %ecx,%eax
        call xscan
        or   %ecx,%ecx
        jnz  sdat1
        Mov_ _rc_,$77
        Jmp_ err_
sdat1:
        Mov_ %ecx,4(%edi)
        or   %ecx,%ecx
        jz   sdt1a
        call flstg
sdt1a:
        Mov_ %esi,%edi
        Mov_ %ecx,4(%edi)
        mov  %ecx,ctbw_r
        movl $scsi_,ctbw_v
        call ctb_
        movl ctbw_r,%ecx
        call alost
        push %edi
        Sar_ %ecx,$2
        rep  movsl
        Mov_ %edi,(%esp)
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        call gtnvr
        Dec_ _rc_
        js   call_88
        Dec_ _rc_
        jns  ppm_0144
        Mov_ _rc_,$78
        Jmp_ err_
ppm_0144:
call_88:
        Mov_ datdv,%edi
        Mov_ datxs,%esp
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
sdat2:
        Mov_ %edx,$ch_rp
        Mov_ %esi,$ch_cm
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %ecx,%eax
        call xscan
        or   %ecx,%ecx
        jnz  sdat3
        Mov_ _rc_,$79
        Jmp_ err_
sdat3:
        call gtnvr
        Dec_ _rc_
        js   call_89
        Dec_ _rc_
        jns  ppm_0145
        Mov_ _rc_,$80
        Jmp_ err_
ppm_0145:
call_89:
        push %edi
        Inc_ %ebx
        Cmp_ %ecx,$num02
        je   sdat2
        Mov_ %ecx,$dfsi_
        Add_ %ecx,%ebx
        Sal_ %ecx,$2
        Mov_ %edx,%ebx
        call alost
        Mov_ %ebx,%edx
        Mov_ %esi,datxs
        Mov_ %edx,(%esi)
        Mov_ (%esi),%edi
        Mov_ %eax,$b_dfc
        stosl
        Mov_ %eax,%ebx
        stosl
        Mov_ %eax,%ecx
        stosl
        Sub_ %ecx,$4*pddfs
        Mov_ %eax,%ecx
        stosl
        Mov_ %eax,%edx
        stosl
        Mov_ %edx,%ebx
sdat4:
        Sub_ %esi,$4
        Mov_ %eax,(%esi)
        stosl
        Dec_ %edx
        jnz  sdat4
        Mov_ %edx,%ecx
        Mov_ %edi,datdv
        Mov_ %esi,datxs
        Mov_ %esi,(%esi)
        call dffnc
sdat5:
        Mov_ %ecx,$4*ffsi_
        call alloc
        Mov_ (%edi),$b_ffc
        Mov_ 4(%edi),$num01
        Mov_ %esi,datxs
        Mov_ %eax,(%esi)
        Mov_ 8(%edi),%eax
        Sub_ %edx,$cfp_b
        Mov_ 16(%edi),%edx
        Xor_ %eax,%eax
        Mov_ 12(%edi),%eax
        Mov_ %esi,%edi
        Mov_ %edi,(%esp)
        Mov_ %edi,20(%edi)
        Cmp_ (%edi),$b_ffc
        jne  sdat6
        Mov_ 12(%esi),%edi
sdat6:
        pop  %edi
        call dffnc
        Cmp_ %esp,datxs
        jne  sdat5
        Add_ %esp,$cfp_b
        Jmp_ exnul
	Align_	2
	nop
s_dtp:
        pop  %edi
        call dtype
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
s_dte:
        pop  %edi
        call gtint
        Dec_ _rc_
        js   call_90
        Dec_ _rc_
        jns  ppm_0146
        Mov_ _rc_,$330
        Jmp_ err_
ppm_0146:
call_90:
        call sysdt
        Mov_ %ecx,4(%esi)
        or   %ecx,%ecx
        jz   exnul
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        call sbstr
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
s_def:
        pop  %edi
        Xor_ %eax,%eax
        Mov_ deflb,%eax
        Cmp_ %edi,$nulls
        je   sdf01
        call gtnvr
        Dec_ _rc_
        js   call_91
        Dec_ _rc_
        jns  ppm_0147
        Jmp_ sdf12
ppm_0147:
call_91:
        Mov_ deflb,%edi
sdf01:
        call xscni
        Dec_ _rc_
        js   call_92
        Dec_ _rc_
        jns  ppm_0148
        Mov_ _rc_,$81
        Jmp_ err_
ppm_0148:
        Dec_ _rc_
        jns  ppm_0149
        Mov_ _rc_,$82
        Jmp_ err_
ppm_0149:
call_92:
        Mov_ %edx,$ch_pp
        Mov_ %esi,%edx
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %ecx,%eax
        call xscan
        or   %ecx,%ecx
        jnz  sdf02
        Mov_ _rc_,$83
        Jmp_ err_
sdf02:
        call gtnvr
        Dec_ _rc_
        js   call_93
        Dec_ _rc_
        jns  ppm_0150
        Mov_ _rc_,$84
        Jmp_ err_
ppm_0150:
call_93:
        Mov_ defvr,%edi
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Mov_ defxs,%esp
        Xor_ %eax,%eax
        Cmp_ deflb,%eax
        jnz  sdf03
        Mov_ deflb,%edi
sdf03:
        Mov_ %edx,$ch_rp
        Mov_ %esi,$ch_cm
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %ecx,%eax
        call xscan
        or   %ecx,%ecx
        jnz  sdf04
        Mov_ _rc_,$85
        Jmp_ err_
sdf04:
        Cmp_ %edi,$nulls
        jne  sdf05
        or   %ebx,%ebx
        jz   sdf06
sdf05:
        call gtnvr
        Dec_ _rc_
        js   call_94
        Dec_ _rc_
        jns  ppm_0151
        Jmp_ sdf03
ppm_0151:
call_94:
        push %edi
        Inc_ %ebx
        Cmp_ %ecx,$num02
        je   sdf03
sdf06:
        Mov_ defna,%ebx
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
sdf07:
        Mov_ %edx,$ch_cm
        Mov_ %esi,%edx
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %ecx,%eax
        call xscan
        Cmp_ %edi,$nulls
        jne  sdf08
        or   %ecx,%ecx
        jz   sdf09
sdf08:
        call gtnvr
        Dec_ _rc_
        js   call_95
        Dec_ _rc_
        jns  ppm_0152
        Jmp_ sdf07
ppm_0152:
call_95:
        Inc_ %ebx
        push %edi
        or   %ecx,%ecx
        jnz  sdf07
sdf09:
        Mov_ %ecx,%ebx
        Add_ %ecx,defna
        Mov_ %edx,%ecx
        Add_ %ecx,$pfsi_
        Sal_ %ecx,$2
        call alloc
        Mov_ %esi,%edi
        Mov_ %eax,$b_pfc
        stosl
        Mov_ %eax,defna
        stosl
        Mov_ %eax,%ecx
        stosl
        Mov_ %eax,defvr
        stosl
        Mov_ %eax,%ebx
        stosl
        Xor_ %eax,%eax
        Mov_ %eax,%eax
        stosl
        Xor_ %eax,%eax
        Mov_ %eax,%eax
        stosl
        Xor_ %eax,%eax
        Mov_ %eax,%eax
        stosl
        or   %edx,%edx
        jz   sdf11
        Mov_ %ecx,%esi
        Mov_ %esi,defxs
sdf10:
        Sub_ %esi,$4
        Mov_ %eax,(%esi)
        stosl
        Dec_ %edx
        jnz  sdf10
        Mov_ %esi,%ecx
sdf11:
        Mov_ %esp,defxs
        Mov_ %eax,deflb
        Mov_ 20(%esi),%eax
        Mov_ %edi,defvr
        call dffnc
        Jmp_ exnul
sdf12:
        Mov_ _rc_,$86
        Jmp_ err_
	Align_	2
	nop
s_det:
        pop  %edi
        call gtvar
        Dec_ _rc_
        js   call_96
        Dec_ _rc_
        jns  ppm_0153
        Mov_ _rc_,$87
        Jmp_ err_
ppm_0153:
call_96:
        call dtach
        Jmp_ exnul
	Align_	2
	nop
s_dif:
        pop  %edi
        pop  %esi
        call ident
        Dec_ _rc_
        js   call_97
        Dec_ _rc_
        jns  ppm_0154
        Jmp_ exfal
ppm_0154:
call_97:
        Jmp_ exnul
	Align_	2
	nop
s_dmp:
        call gtsmi
        Dec_ _rc_
        js   call_98
        Dec_ _rc_
        jns  ppm_0155
        Mov_ _rc_,$88
        Jmp_ err_
ppm_0155:
        Dec_ _rc_
        jns  ppm_0156
        Mov_ _rc_,$89
        Jmp_ err_
ppm_0156:
call_98:
        call dumpr
        Jmp_ exnul
	Align_	2
	nop
s_dup:
        call gtsmi
        Dec_ _rc_
        js   call_99
        Dec_ _rc_
        jns  ppm_0157
        Mov_ _rc_,$90
        Jmp_ err_
ppm_0157:
        Dec_ _rc_
        jns  ppm_0158
        Jmp_ sdup7
ppm_0158:
call_99:
        Mov_ %ebx,%edi
        call gtstg
        Dec_ _rc_
        js   call_100
        Dec_ _rc_
        jns  ppm_0159
        Jmp_ sdup4
ppm_0159:
call_100:
        ldi_ %ecx
        sti_ dupsi
        ldi_ %ebx
        Mov_ %eax,dupsi
        mli_
        iov_ sdup3
        Mov_ %eax,reg_ia
        or   %eax,%eax
        je   exnul
        sti_ %eax
        or   %eax,%eax
        js   sdup3
        sti_ %ecx
sdup1:
        Mov_ %esi,%edi
        call alocs
        push %edi
        Mov_ %edx,%esi
        Add_ %edi,$cfp_f
sdup2:
        Mov_ %esi,%edx
        Mov_ %ecx,4(%esi)
        Add_ %esi,$cfp_f
        rep  movsb
        Dec_ %ebx
        jnz  sdup2
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        Lcw_ %edi
        Jmp_ *(%edi)
sdup3:
        Mov_ %ecx,dname
        Jmp_ sdup1
sdup4:
        call gtpat
        Dec_ _rc_
        js   call_101
        Dec_ _rc_
        jns  ppm_0161
        Mov_ _rc_,$91
        Jmp_ err_
ppm_0161:
call_101:
        push %edi
        Mov_ %edi,$ndnth
        or   %ebx,%ebx
        jz   sdup6
        push %ebx
sdup5:
        Mov_ %esi,%edi
        Mov_ %edi,4(%esp)
        call pconc
        Dec_ (%esp)
        Xor_ %eax,%eax
        Cmp_ (%esp),%eax
        jnz  sdup5
        Add_ %esp,$cfp_b
sdup6:
        Mov_ (%esp),%edi
        Lcw_ %edi
        Jmp_ *(%edi)
sdup7:
        Add_ %esp,$cfp_b
        Jmp_ exfal
	Align_	2
	nop
s_ejc:
        call iofcb
        Dec_ _rc_
        js   call_102
        Dec_ _rc_
        jns  ppm_0162
        Mov_ _rc_,$92
        Jmp_ err_
ppm_0162:
        Dec_ _rc_
        jns  ppm_0163
        Jmp_ sejc1
ppm_0163:
        Dec_ _rc_
        jns  ppm_0164
        Mov_ _rc_,$93
        Jmp_ err_
ppm_0164:
call_102:
        call sysef
        Dec_ _rc_
        js   call_103
        Dec_ _rc_
        jns  ppm_0165
        Mov_ _rc_,$93
        Jmp_ err_
ppm_0165:
        Dec_ _rc_
        jns  ppm_0166
        Mov_ _rc_,$94
        Jmp_ err_
ppm_0166:
        Dec_ _rc_
        jns  ppm_0167
        Mov_ _rc_,$95
        Jmp_ err_
ppm_0167:
call_103:
        Jmp_ exnul
sejc1:
        call sysep
        Jmp_ exnul
	Align_	2
	nop
s_enf:
        call iofcb
        Dec_ _rc_
        js   call_104
        Dec_ _rc_
        jns  ppm_0168
        Mov_ _rc_,$96
        Jmp_ err_
ppm_0168:
        Dec_ _rc_
        jns  ppm_0169
        Mov_ _rc_,$97
        Jmp_ err_
ppm_0169:
        Dec_ _rc_
        jns  ppm_0170
        Mov_ _rc_,$98
        Jmp_ err_
ppm_0170:
call_104:
        call sysen
        Dec_ _rc_
        js   call_105
        Dec_ _rc_
        jns  ppm_0171
        Mov_ _rc_,$98
        Jmp_ err_
ppm_0171:
        Dec_ _rc_
        jns  ppm_0172
        Mov_ _rc_,$99
        Jmp_ err_
ppm_0172:
        Dec_ _rc_
        jns  ppm_0173
        Mov_ _rc_,$100
        Jmp_ err_
ppm_0173:
call_105:
        Mov_ %ebx,%esi
        Mov_ %edi,%esi
senf1:
        Mov_ %esi,%edi
        Mov_ %edi,8(%edi)
        Cmp_ (%edi),$b_trt
        jne  exnul
        Cmp_ 4(%edi),$trtfc
        jne  senf1
        Mov_ %eax,8(%edi)
        Mov_ 8(%esi),%eax
        Mov_ %eax,12(%edi)
        Mov_ enfch,%eax
        Mov_ %edx,16(%edi)
        Mov_ %edi,%ebx
        call setvr
        Mov_ %esi,$_r_fcb
        Sub_ %esi,$4*num02
senf2:
        Mov_ %edi,%esi
        Mov_ %esi,8(%esi)
        or   %esi,%esi
        jz   senf4
        Cmp_ 12(%esi),%edx
        je   senf3
        Jmp_ senf2
senf3:
        Mov_ %eax,8(%esi)
        Mov_ 8(%edi),%eax
senf4:
        Mov_ %esi,enfch
        or   %esi,%esi
        jz   exnul
        Mov_ %eax,12(%esi)
        Mov_ enfch,%eax
        Mov_ %ecx,16(%esi)
        Mov_ %esi,8(%esi)
        call dtach
        Jmp_ senf4
	Align_	2
	nop
s_eqf:
        call acomp
        Dec_ _rc_
        js   call_106
        Dec_ _rc_
        jns  ppm_0174
        Mov_ _rc_,$101
        Jmp_ err_
ppm_0174:
        Dec_ _rc_
        jns  ppm_0175
        Mov_ _rc_,$102
        Jmp_ err_
ppm_0175:
        Dec_ _rc_
        jns  ppm_0176
        Jmp_ exfal
ppm_0176:
        Dec_ _rc_
        jns  ppm_0177
        Jmp_ exnul
ppm_0177:
        Dec_ _rc_
        jns  ppm_0178
        Jmp_ exfal
ppm_0178:
call_106:
	Align_	2
	nop
s_evl:
        pop  %edi
        Lcw_ %edx
        Cmp_ %edx,$ofne_
        jne  sevl1
        Scp_ %esi
        Mov_ %ecx,(%esi)
        Cmp_ %ecx,$ornm_
        jne  sevl2
        Xor_ %eax,%eax
        Cmp_ 4(%esp),%eax
        jnz  sevl2
sevl1:
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        push %edx
        call gtexp
        Dec_ _rc_
        js   call_107
        Dec_ _rc_
        jns  ppm_0179
        Mov_ _rc_,$103
        Jmp_ err_
ppm_0179:
call_107:
        Xor_ %eax,%eax
        Mov_ r_ccb,%eax
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        call evalx
        Dec_ _rc_
        js   call_108
        Dec_ _rc_
        jns  ppm_0180
        Jmp_ exfal
ppm_0180:
call_108:
        Mov_ %esi,%edi
        Mov_ %edi,(%esp)
        Mov_ (%esp),%esi
        Jmp_ *(%edi)
sevl2:
        Mov_ %ebx,$num01
        call gtexp
        Dec_ _rc_
        js   call_109
        Dec_ _rc_
        jns  ppm_0181
        Mov_ _rc_,$103
        Jmp_ err_
ppm_0181:
call_109:
        Xor_ %eax,%eax
        Mov_ r_ccb,%eax
        Mov_ %ebx,$num01
        call evalx
        Dec_ _rc_
        js   call_110
        Dec_ _rc_
        jns  ppm_0182
        Jmp_ exfal
ppm_0182:
call_110:
        Jmp_ exnam
	Align_	2
	nop
s_ext:
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Xor_ %eax,%eax
        Mov_ r_ccb,%eax
        Xor_ %eax,%eax
        Mov_ dnams,%eax
        call gbcol
        Mov_ dnams,%edi
        call gtstg
        Dec_ _rc_
        js   call_111
        Dec_ _rc_
        jns  ppm_0183
        Mov_ _rc_,$288
        Jmp_ err_
ppm_0183:
call_111:
        Mov_ %esi,%edi
        call gtstg
        Dec_ _rc_
        js   call_112
        Dec_ _rc_
        jns  ppm_0184
        Mov_ _rc_,$104
        Jmp_ err_
ppm_0184:
call_112:
        push %esi
        Mov_ %esi,%edi
        call gtint
        Dec_ _rc_
        js   call_113
        Dec_ _rc_
        jns  ppm_0185
        Jmp_ sext1
ppm_0185:
call_113:
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        ldi_ 4(%edi)
sext1:
        Mov_ %ebx,_r_fcb
        Mov_ %edi,$_headv
        pop  %ecx
        call sysxi
        Dec_ _rc_
        js   call_114
        Dec_ _rc_
        jns  ppm_0186
        Mov_ _rc_,$105
        Jmp_ err_
ppm_0186:
        Dec_ _rc_
        jns  ppm_0187
        Mov_ _rc_,$106
        Jmp_ err_
ppm_0187:
call_114:
        Mov_ %eax,reg_ia
        or   %eax,%eax
        je   exnul
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jg   sext2
        ngi_
sext2:
        sti_ %edx
        Add_ %ecx,%edx
        Cmp_ %ecx,$num05
        je   sext5
        Xor_ %eax,%eax
        Mov_ gbcnt,%eax
        Cmp_ %edx,$num03
        jae  sext3
        push %edx
        Xor_ %eax,%eax
        Mov_ %edx,%eax
        call prpar
        pop  %edx
sext3:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ headp,%eax
        Cmp_ %edx,$num01
        jne  sext4
        Xor_ %eax,%eax
        Mov_ headp,%eax
sext4:
        call systm
        sti_ timsx
        ldi_ kvstc
        sti_ kvstl
        call stgcc
        Jmp_ exnul
sext5:
        Mov_ %edi,$inton
        Jmp_ exixr
	Align_	2
	nop
s_exp:
        pop  %edi
        call gtrea
        Dec_ _rc_
        js   call_115
        Dec_ _rc_
        jns  ppm_0188
        Mov_ _rc_,$304
        Jmp_ err_
ppm_0188:
call_115:
        Mov_ %eax,%edi
        Add_ %eax,(cfp_b*rcval)
        call ldr_
        call etx_
        rno_ exrea
        Mov_ _rc_,$305
        Jmp_ err_
	Align_	2
	nop
s_fld:
        call gtsmi
        Dec_ _rc_
        js   call_116
        Dec_ _rc_
        jns  ppm_0189
        Mov_ _rc_,$107
        Jmp_ err_
ppm_0189:
        Dec_ _rc_
        jns  ppm_0190
        Jmp_ exfal
ppm_0190:
call_116:
        Mov_ %ebx,%edi
        pop  %edi
        call gtnvr
        Dec_ _rc_
        js   call_117
        Dec_ _rc_
        jns  ppm_0191
        Jmp_ sfld1
ppm_0191:
call_117:
        Mov_ %edi,20(%edi)
        Cmp_ (%edi),$b_dfc
        jne  sfld1
        or   %ebx,%ebx
        jz   exfal
        Cmp_ %ebx,4(%edi)
        ja   exfal
        Sal_ %ebx,$2
        Add_ %edi,%ebx
        Mov_ %edi,16(%edi)
        Jmp_ exvnm
sfld1:
        Mov_ _rc_,$108
        Jmp_ err_
	Align_	2
	nop
s_fnc:
        Mov_ %ebx,$p_fnc
        Xor_ %eax,%eax
        Mov_ %edi,%eax
        call pbild
        Mov_ %esi,%edi
        pop  %edi
        call gtpat
        Dec_ _rc_
        js   call_118
        Dec_ _rc_
        jns  ppm_0192
        Mov_ _rc_,$259
        Jmp_ err_
ppm_0192:
call_118:
        call pconc
        Mov_ %esi,%edi
        Mov_ %ebx,$p_fna
        Xor_ %eax,%eax
        Mov_ %edi,%eax
        call pbild
        Mov_ 4(%edi),%esi
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
s_gef:
        call acomp
        Dec_ _rc_
        js   call_119
        Dec_ _rc_
        jns  ppm_0193
        Mov_ _rc_,$109
        Jmp_ err_
ppm_0193:
        Dec_ _rc_
        jns  ppm_0194
        Mov_ _rc_,$110
        Jmp_ err_
ppm_0194:
        Dec_ _rc_
        jns  ppm_0195
        Jmp_ exfal
ppm_0195:
        Dec_ _rc_
        jns  ppm_0196
        Jmp_ exnul
ppm_0196:
        Dec_ _rc_
        jns  ppm_0197
        Jmp_ exnul
ppm_0197:
call_119:
	Align_	2
	nop
s_gtf:
        call acomp
        Dec_ _rc_
        js   call_120
        Dec_ _rc_
        jns  ppm_0198
        Mov_ _rc_,$111
        Jmp_ err_
ppm_0198:
        Dec_ _rc_
        jns  ppm_0199
        Mov_ _rc_,$112
        Jmp_ err_
ppm_0199:
        Dec_ _rc_
        jns  ppm_0200
        Jmp_ exfal
ppm_0200:
        Dec_ _rc_
        jns  ppm_0201
        Jmp_ exfal
ppm_0201:
        Dec_ _rc_
        jns  ppm_0202
        Jmp_ exnul
ppm_0202:
call_120:
	Align_	2
	nop
s_hst:
        pop  %edx
        pop  %ebx
        pop  %edi
        pop  %esi
        pop  %ecx
        call syshs
        Dec_ _rc_
        js   call_121
        Dec_ _rc_
        jns  ppm_0203
        Mov_ _rc_,$254
        Jmp_ err_
ppm_0203:
        Dec_ _rc_
        jns  ppm_0204
        Mov_ _rc_,$255
        Jmp_ err_
ppm_0204:
        Dec_ _rc_
        jns  ppm_0205
        Jmp_ shst1
ppm_0205:
        Dec_ _rc_
        jns  ppm_0206
        Jmp_ exnul
ppm_0206:
        Dec_ _rc_
        jns  ppm_0207
        Jmp_ exixr
ppm_0207:
        Dec_ _rc_
        jns  ppm_0208
        Jmp_ exfal
ppm_0208:
        Dec_ _rc_
        jns  ppm_0209
        Jmp_ shst3
ppm_0209:
        Dec_ _rc_
        jns  ppm_0210
        Jmp_ shst4
ppm_0210:
call_121:
shst1:
        or   %esi,%esi
        jz   exnul
        Mov_ %ecx,4(%esi)
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
shst2:
        call sbstr
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
shst3:
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Sub_ %ebx,$cfp_f
        Jmp_ shst2
shst4:
        push %edi
        call copyb
        Dec_ _rc_
        js   call_122
        Dec_ _rc_
        jns  ppm_0211
        Jmp_ exits
ppm_0211:
call_122:
        Jmp_ exsid
	Align_	2
	nop
s_idn:
        pop  %edi
        pop  %esi
        call ident
        Dec_ _rc_
        js   call_123
        Dec_ _rc_
        jns  ppm_0212
        Jmp_ exnul
ppm_0212:
call_123:
        Jmp_ exfal
	Align_	2
	nop
s_inp:
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        call ioput
        Dec_ _rc_
        js   call_124
        Dec_ _rc_
        jns  ppm_0213
        Mov_ _rc_,$113
        Jmp_ err_
ppm_0213:
        Dec_ _rc_
        jns  ppm_0214
        Mov_ _rc_,$114
        Jmp_ err_
ppm_0214:
        Dec_ _rc_
        jns  ppm_0215
        Mov_ _rc_,$115
        Jmp_ err_
ppm_0215:
        Dec_ _rc_
        jns  ppm_0216
        Mov_ _rc_,$116
        Jmp_ err_
ppm_0216:
        Dec_ _rc_
        jns  ppm_0217
        Jmp_ exfal
ppm_0217:
        Dec_ _rc_
        jns  ppm_0218
        Mov_ _rc_,$117
        Jmp_ err_
ppm_0218:
        Dec_ _rc_
        jns  ppm_0219
        Mov_ _rc_,$289
        Jmp_ err_
ppm_0219:
call_124:
        Jmp_ exnul
	Align_	2
	nop
s_int:
        pop  %edi
        call gtnum
        Dec_ _rc_
        js   call_125
        Dec_ _rc_
        jns  ppm_0220
        Jmp_ exfal
ppm_0220:
call_125:
        Cmp_ %ecx,$_b_icl
        je   exnul
        Jmp_ exfal
	Align_	2
	nop
s_itm:
        or   %ecx,%ecx
        jnz  sitm1
        push $nulls
        Mov_ %ecx,$num01
sitm1:
        Scp_ %edi
        Mov_ %esi,(%edi)
        Dec_ %ecx
        Mov_ %edi,%ecx
        Cmp_ %esi,$ofne_
        je   sitm2
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Jmp_ arref
sitm2:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %ebx,%eax
        Lcw_ %ecx
        Jmp_ arref
	Align_	2
	nop
s_lef:
        call acomp
        Dec_ _rc_
        js   call_126
        Dec_ _rc_
        jns  ppm_0221
        Mov_ _rc_,$118
        Jmp_ err_
ppm_0221:
        Dec_ _rc_
        jns  ppm_0222
        Mov_ _rc_,$119
        Jmp_ err_
ppm_0222:
        Dec_ _rc_
        jns  ppm_0223
        Jmp_ exnul
ppm_0223:
        Dec_ _rc_
        jns  ppm_0224
        Jmp_ exnul
ppm_0224:
        Dec_ _rc_
        jns  ppm_0225
        Jmp_ exfal
ppm_0225:
call_126:
	Align_	2
	nop
s_len:
        Mov_ %ebx,$p_len
        Mov_ %ecx,$p_lnd
        call patin
        Dec_ _rc_
        js   call_127
        Dec_ _rc_
        jns  ppm_0226
        Mov_ _rc_,$120
        Jmp_ err_
ppm_0226:
        Dec_ _rc_
        jns  ppm_0227
        Mov_ _rc_,$121
        Jmp_ err_
ppm_0227:
call_127:
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
s_leq:
        call lcomp
        Dec_ _rc_
        js   call_128
        Dec_ _rc_
        jns  ppm_0228
        Mov_ _rc_,$122
        Jmp_ err_
ppm_0228:
        Dec_ _rc_
        jns  ppm_0229
        Mov_ _rc_,$123
        Jmp_ err_
ppm_0229:
        Dec_ _rc_
        jns  ppm_0230
        Jmp_ exfal
ppm_0230:
        Dec_ _rc_
        jns  ppm_0231
        Jmp_ exnul
ppm_0231:
        Dec_ _rc_
        jns  ppm_0232
        Jmp_ exfal
ppm_0232:
call_128:
	Align_	2
	nop
s_lge:
        call lcomp
        Dec_ _rc_
        js   call_129
        Dec_ _rc_
        jns  ppm_0233
        Mov_ _rc_,$124
        Jmp_ err_
ppm_0233:
        Dec_ _rc_
        jns  ppm_0234
        Mov_ _rc_,$125
        Jmp_ err_
ppm_0234:
        Dec_ _rc_
        jns  ppm_0235
        Jmp_ exfal
ppm_0235:
        Dec_ _rc_
        jns  ppm_0236
        Jmp_ exnul
ppm_0236:
        Dec_ _rc_
        jns  ppm_0237
        Jmp_ exnul
ppm_0237:
call_129:
	Align_	2
	nop
s_lgt:
        call lcomp
        Dec_ _rc_
        js   call_130
        Dec_ _rc_
        jns  ppm_0238
        Mov_ _rc_,$126
        Jmp_ err_
ppm_0238:
        Dec_ _rc_
        jns  ppm_0239
        Mov_ _rc_,$127
        Jmp_ err_
ppm_0239:
        Dec_ _rc_
        jns  ppm_0240
        Jmp_ exfal
ppm_0240:
        Dec_ _rc_
        jns  ppm_0241
        Jmp_ exfal
ppm_0241:
        Dec_ _rc_
        jns  ppm_0242
        Jmp_ exnul
ppm_0242:
call_130:
	Align_	2
	nop
s_lle:
        call lcomp
        Dec_ _rc_
        js   call_131
        Dec_ _rc_
        jns  ppm_0243
        Mov_ _rc_,$128
        Jmp_ err_
ppm_0243:
        Dec_ _rc_
        jns  ppm_0244
        Mov_ _rc_,$129
        Jmp_ err_
ppm_0244:
        Dec_ _rc_
        jns  ppm_0245
        Jmp_ exnul
ppm_0245:
        Dec_ _rc_
        jns  ppm_0246
        Jmp_ exnul
ppm_0246:
        Dec_ _rc_
        jns  ppm_0247
        Jmp_ exfal
ppm_0247:
call_131:
	Align_	2
	nop
s_llt:
        call lcomp
        Dec_ _rc_
        js   call_132
        Dec_ _rc_
        jns  ppm_0248
        Mov_ _rc_,$130
        Jmp_ err_
ppm_0248:
        Dec_ _rc_
        jns  ppm_0249
        Mov_ _rc_,$131
        Jmp_ err_
ppm_0249:
        Dec_ _rc_
        jns  ppm_0250
        Jmp_ exnul
ppm_0250:
        Dec_ _rc_
        jns  ppm_0251
        Jmp_ exfal
ppm_0251:
        Dec_ _rc_
        jns  ppm_0252
        Jmp_ exfal
ppm_0252:
call_132:
	Align_	2
	nop
s_lne:
        call lcomp
        Dec_ _rc_
        js   call_133
        Dec_ _rc_
        jns  ppm_0253
        Mov_ _rc_,$132
        Jmp_ err_
ppm_0253:
        Dec_ _rc_
        jns  ppm_0254
        Mov_ _rc_,$133
        Jmp_ err_
ppm_0254:
        Dec_ _rc_
        jns  ppm_0255
        Jmp_ exnul
ppm_0255:
        Dec_ _rc_
        jns  ppm_0256
        Jmp_ exfal
ppm_0256:
        Dec_ _rc_
        jns  ppm_0257
        Jmp_ exnul
ppm_0257:
call_133:
	Align_	2
	nop
s_lnf:
        pop  %edi
        call gtrea
        Dec_ _rc_
        js   call_134
        Dec_ _rc_
        jns  ppm_0258
        Mov_ _rc_,$306
        Jmp_ err_
ppm_0258:
call_134:
        Mov_ %eax,%edi
        Add_ %eax,(cfp_b*rcval)
        call ldr_
        call cpr_
        movb reg_fl,%al
        or   %al,%al
        je   slnf1
        call cpr_
        movb reg_fl,%al
        or   %al,%al
        jl   slnf2
        call lnf_
        rno_ exrea
slnf1:
        Mov_ _rc_,$307
        Jmp_ err_
slnf2:
        Mov_ _rc_,$315
        Jmp_ err_
	Align_	2
	nop
s_loc:
        call gtsmi
        Dec_ _rc_
        js   call_135
        Dec_ _rc_
        jns  ppm_0259
        Mov_ _rc_,$134
        Jmp_ err_
ppm_0259:
        Dec_ _rc_
        jns  ppm_0260
        Jmp_ exfal
ppm_0260:
call_135:
        Mov_ %ebx,%edi
        pop  %edi
        call gtnvr
        Dec_ _rc_
        js   call_136
        Dec_ _rc_
        jns  ppm_0261
        Jmp_ sloc1
ppm_0261:
call_136:
        Mov_ %edi,20(%edi)
        Cmp_ (%edi),$b_pfc
        jne  sloc1
        or   %ebx,%ebx
        jz   exfal
        Cmp_ %ebx,16(%edi)
        ja   exfal
        Add_ %ebx,4(%edi)
        Sal_ %ebx,$2
        Add_ %edi,%ebx
        Mov_ %edi,28(%edi)
        Jmp_ exvnm
sloc1:
        Mov_ _rc_,$135
        Jmp_ err_
	Align_	2
	nop
s_lod:
        call gtstg
        Dec_ _rc_
        js   call_137
        Dec_ _rc_
        jns  ppm_0262
        Mov_ _rc_,$136
        Jmp_ err_
ppm_0262:
call_137:
        Mov_ %esi,%edi
        call xscni
        Dec_ _rc_
        js   call_138
        Dec_ _rc_
        jns  ppm_0263
        Mov_ _rc_,$137
        Jmp_ err_
ppm_0263:
        Dec_ _rc_
        jns  ppm_0264
        Mov_ _rc_,$138
        Jmp_ err_
ppm_0264:
call_138:
        push %esi
        Mov_ %edx,$ch_pp
        Mov_ %esi,%edx
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %ecx,%eax
        call xscan
        push %edi
        or   %ecx,%ecx
        jnz  slod1
        Mov_ _rc_,$139
        Jmp_ err_
slod1:
        call gtnvr
        Dec_ _rc_
        js   call_139
        Dec_ _rc_
        jns  ppm_0265
        Mov_ _rc_,$140
        Jmp_ err_
ppm_0265:
call_139:
        Mov_ lodfn,%edi
        Xor_ %eax,%eax
        Mov_ lodna,%eax
slod2:
        Mov_ %edx,$ch_rp
        Mov_ %esi,$ch_cm
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %ecx,%eax
        call xscan
        Inc_ lodna
        or   %ecx,%ecx
        jnz  slod3
        Mov_ _rc_,$141
        Jmp_ err_
slod3:
        Mov_ %ebx,%ecx
        Mov_ %ecx,4(%edi)
        or   %ecx,%ecx
        jz   sld3a
        call flstg
sld3a:
        Mov_ %ecx,%ebx
        push %edi
        Mov_ %ebx,$num01
        Mov_ %esi,$scstr
        call ident
        Dec_ _rc_
        js   call_140
        Dec_ _rc_
        jns  ppm_0266
        Jmp_ slod4
ppm_0266:
call_140:
        Mov_ %edi,(%esp)
        Add_ %ebx,%ebx
        Mov_ %esi,$scint
        call ident
        Dec_ _rc_
        js   call_141
        Dec_ _rc_
        jns  ppm_0267
        Jmp_ slod4
ppm_0267:
call_141:
        Mov_ %edi,(%esp)
        Inc_ %ebx
        Mov_ %esi,$screa
        call ident
        Dec_ _rc_
        js   call_142
        Dec_ _rc_
        jns  ppm_0268
        Jmp_ slod4
ppm_0268:
call_142:
        Mov_ %edi,(%esp)
        Inc_ %ebx
        Mov_ %esi,$scfil
        call ident
        Dec_ _rc_
        js   call_143
        Dec_ _rc_
        jns  ppm_0269
        Jmp_ slod4
ppm_0269:
call_143:
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
slod4:
        Mov_ (%esp),%ebx
        Cmp_ %ecx,$num02
        je   slod2
        or   %ecx,%ecx
        jz   slod5
        Mov_ %edx,mxlen
        Mov_ %esi,%edx
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %ecx,%eax
        call xscan
        Xor_ %eax,%eax
        Mov_ %ecx,%eax
        Jmp_ slod3
slod5:
        Mov_ %ecx,lodna
        Mov_ %edx,%ecx
        Sal_ %ecx,$2
        Add_ %ecx,$4*efsi_
        call alloc
        Mov_ (%edi),$b_efc
        Mov_ 4(%edi),%edx
        Xor_ %eax,%eax
        Mov_ 12(%edi),%eax
        Xor_ %eax,%eax
        Mov_ 16(%edi),%eax
        pop  24(%edi)
        Mov_ %eax,lodfn
        Mov_ 20(%edi),%eax
        Mov_ 8(%edi),%ecx
        Mov_ %ebx,%edi
        Add_ %edi,%ecx
slod6:
        Sub_ %edi,$4
        pop  (%edi)
        Dec_ %edx
        jnz  slod6
        pop  %edi
        Mov_ %ecx,4(%edi)
        call flstg
        Mov_ %esi,(%esp)
        Mov_ (%esp),%ebx
        call sysld
        Dec_ _rc_
        js   call_144
        Dec_ _rc_
        jns  ppm_0270
        Mov_ _rc_,$142
        Jmp_ err_
ppm_0270:
        Dec_ _rc_
        jns  ppm_0271
        Mov_ _rc_,$143
        Jmp_ err_
ppm_0271:
        Dec_ _rc_
        jns  ppm_0272
        Mov_ _rc_,$328
        Jmp_ err_
ppm_0272:
call_144:
        pop  %esi
        Mov_ 16(%esi),%edi
        Mov_ %edi,lodfn
        call dffnc
        Jmp_ exnul
	Align_	2
	nop
s_lpd:
        call gtstg
        Dec_ _rc_
        js   call_145
        Dec_ _rc_
        jns  ppm_0273
        Mov_ _rc_,$144
        Jmp_ err_
ppm_0273:
call_145:
        Add_ %edi,$cfp_f
#lch s.text (xr)  s.type 9  s.reg xr
#lch d.text wb  d.type 8  d.reg wb  w 0
        Xor_ %ebx,%ebx
        movb (%edi),%bl
        call gtsmi
        Dec_ _rc_
        js   call_146
        Dec_ _rc_
        jns  ppm_0274
        Mov_ _rc_,$145
        Jmp_ err_
ppm_0274:
        Dec_ _rc_
        jns  ppm_0275
        Jmp_ slpd4
ppm_0275:
call_146:
slpd1:
        call gtstg
        Dec_ _rc_
        js   call_147
        Dec_ _rc_
        jns  ppm_0276
        Mov_ _rc_,$146
        Jmp_ err_
ppm_0276:
call_147:
        Cmp_ %ecx,%edx
        jae  exixr
        Mov_ %esi,%edi
        Mov_ %ecx,%edx
        call alocs
        push %edi
        Mov_ %ecx,4(%esi)
        Sub_ %edx,%ecx
        Add_ %edi,$cfp_f
slpd2:
#sch s.text wb  s.type 8  s.reg wb
#sch d.text (xr)+  d.type 10  d.reg xr  w 0
        movb %bl,(%edi)
        Inc_ %edi
        Dec_ %edx
        jnz  slpd2
        or   %ecx,%ecx
        jz   slpd3
        Add_ %esi,$cfp_f
        rep  movsb
        Xor_ %eax,%eax
        Mov_ %esi,%eax
slpd3:
        Lcw_ %edi
        Jmp_ *(%edi)
slpd4:
        Xor_ %eax,%eax
        Mov_ %edx,%eax
        Jmp_ slpd1
	Align_	2
	nop
s_ltf:
        call acomp
        Dec_ _rc_
        js   call_148
        Dec_ _rc_
        jns  ppm_0278
        Mov_ _rc_,$147
        Jmp_ err_
ppm_0278:
        Dec_ _rc_
        jns  ppm_0279
        Mov_ _rc_,$148
        Jmp_ err_
ppm_0279:
        Dec_ _rc_
        jns  ppm_0280
        Jmp_ exnul
ppm_0280:
        Dec_ _rc_
        jns  ppm_0281
        Jmp_ exfal
ppm_0281:
        Dec_ _rc_
        jns  ppm_0282
        Jmp_ exfal
ppm_0282:
call_148:
	Align_	2
	nop
s_nef:
        call acomp
        Dec_ _rc_
        js   call_149
        Dec_ _rc_
        jns  ppm_0283
        Mov_ _rc_,$149
        Jmp_ err_
ppm_0283:
        Dec_ _rc_
        jns  ppm_0284
        Mov_ _rc_,$150
        Jmp_ err_
ppm_0284:
        Dec_ _rc_
        jns  ppm_0285
        Jmp_ exnul
ppm_0285:
        Dec_ _rc_
        jns  ppm_0286
        Jmp_ exfal
ppm_0286:
        Dec_ _rc_
        jns  ppm_0287
        Jmp_ exnul
ppm_0287:
call_149:
	Align_	2
	nop
s_nay:
        Mov_ %ebx,$p_nas
        Mov_ %esi,$p_nay
        Mov_ %edx,$p_nad
        call patst
        Dec_ _rc_
        js   call_150
        Dec_ _rc_
        jns  ppm_0288
        Mov_ _rc_,$151
        Jmp_ err_
ppm_0288:
call_150:
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
s_ops:
        call gtsmi
        Dec_ _rc_
        js   call_151
        Dec_ _rc_
        jns  ppm_0289
        Mov_ _rc_,$152
        Jmp_ err_
ppm_0289:
        Dec_ _rc_
        jns  ppm_0290
        Mov_ _rc_,$153
        Jmp_ err_
ppm_0290:
call_151:
        Mov_ %ebx,%edx
        pop  %edi
        call gtnvr
        Dec_ _rc_
        js   call_152
        Dec_ _rc_
        jns  ppm_0291
        Mov_ _rc_,$154
        Jmp_ err_
ppm_0291:
call_152:
        Mov_ %esi,20(%edi)
        or   %ebx,%ebx
        jnz  sops2
        pop  %edi
        call gtnvr
        Dec_ _rc_
        js   call_153
        Dec_ _rc_
        jns  ppm_0292
        Mov_ _rc_,$155
        Jmp_ err_
ppm_0292:
call_153:
sops1:
        call dffnc
        Jmp_ exnul
sops2:
        call gtstg
        Dec_ _rc_
        js   call_154
        Dec_ _rc_
        jns  ppm_0293
        Jmp_ sops5
ppm_0293:
call_154:
        Cmp_ %ecx,$num01
        jne  sops5
        Add_ %edi,$cfp_f
#lch s.text (xr)  s.type 9  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
sops3:
sops4:
        Cmp_ %edx,(%edi)
        je   sops6
        Add_ %ecx,$cfp_b
        Add_ %edi,$cfp_b
        Dec_ %ebx
        jnz  sops4
sops5:
        Mov_ _rc_,$156
        Jmp_ err_
sops6:
        Mov_ %edi,%ecx
        Sub_ %edi,$4*vrfnc
        Jmp_ sops1
	Align_	2
	nop
s_oup:
        Mov_ %ebx,$num03
        call ioput
        Dec_ _rc_
        js   call_155
        Dec_ _rc_
        jns  ppm_0294
        Mov_ _rc_,$157
        Jmp_ err_
ppm_0294:
        Dec_ _rc_
        jns  ppm_0295
        Mov_ _rc_,$158
        Jmp_ err_
ppm_0295:
        Dec_ _rc_
        jns  ppm_0296
        Mov_ _rc_,$159
        Jmp_ err_
ppm_0296:
        Dec_ _rc_
        jns  ppm_0297
        Mov_ _rc_,$160
        Jmp_ err_
ppm_0297:
        Dec_ _rc_
        jns  ppm_0298
        Jmp_ exfal
ppm_0298:
        Dec_ _rc_
        jns  ppm_0299
        Mov_ _rc_,$161
        Jmp_ err_
ppm_0299:
        Dec_ _rc_
        jns  ppm_0300
        Mov_ _rc_,$290
        Jmp_ err_
ppm_0300:
call_155:
        Jmp_ exnul
	Align_	2
	nop
s_pos:
        Mov_ %ebx,$p_pos
        Mov_ %ecx,$p_psd
        call patin
        Dec_ _rc_
        js   call_156
        Dec_ _rc_
        jns  ppm_0301
        Mov_ _rc_,$162
        Jmp_ err_
ppm_0301:
        Dec_ _rc_
        jns  ppm_0302
        Mov_ _rc_,$163
        Jmp_ err_
ppm_0302:
call_156:
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
s_pro:
        pop  %edi
        Mov_ %ebx,8(%edi)
        Sar_ %ebx,$2
        Mov_ %ecx,(%edi)
        Cmp_ %ecx,$b_art
        je   spro4
        Cmp_ %ecx,$b_tbt
        je   spro1
        Cmp_ %ecx,$b_vct
        je   spro3
        Mov_ _rc_,$164
        Jmp_ err_
spro1:
        Sub_ %ebx,$tbsi_
spro2:
        ldi_ %ebx
        Jmp_ exint
spro3:
        Sub_ %ebx,$vcsi_
        Jmp_ spro2
spro4:
        Add_ %edi,12(%edi)
        Mov_ %edi,(%edi)
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
s_rmd:
        call arith
        Dec_ _rc_
        js   call_157
        Dec_ _rc_
        jns  ppm_0303
        Mov_ _rc_,$166
        Jmp_ err_
ppm_0303:
        Dec_ _rc_
        jns  ppm_0304
        Mov_ _rc_,$165
        Jmp_ err_
ppm_0304:
        Dec_ _rc_
        jns  ppm_0305
        Jmp_ srm06
ppm_0305:
call_157:
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        ldi_ 4(%edi)
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jge  srm01
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %ebx,%eax
srm01:
        Mov_ %eax,4(%esi)
        rmi_
        iov_ srm05
        or   %ebx,%ebx
        jz   srm03
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jle  exint
srm02:
        ngi_
        Jmp_ exint
srm03:
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jl   srm02
        Jmp_ exint
srm04:
        Mov_ _rc_,$166
        Jmp_ err_
srm05:
        Mov_ _rc_,$167
        Jmp_ err_
srm06:
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Mov_ %eax,%edi
        Add_ %eax,(cfp_b*rcval)
        call ldr_
        call cpr_
        movb reg_fl,%al
        or   %al,%al
        jge  srm07
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %ebx,%eax
srm07:
        Mov_ %eax,%esi
        Add_ %eax,(cfp_b*rcval)
        call dvr_
        rov_ srm10
        call chp_
        Mov_ %eax,%esi
        Add_ %eax,(cfp_b*rcval)
        call mlr_
        Mov_ %eax,%edi
        Add_ %eax,(cfp_b*rcval)
        call sbr_
        or   %ebx,%ebx
        jz   srm09
        call cpr_
        movb reg_fl,%al
        or   %al,%al
        jle  exrea
srm08:
        call ngr_
        Jmp_ exrea
srm09:
        call cpr_
        movb reg_fl,%al
        or   %al,%al
        jl   srm08
        Jmp_ exrea
srm10:
        Mov_ _rc_,$312
        Jmp_ err_
	Align_	2
	nop
s_rpl:
        call gtstg
        Dec_ _rc_
        js   call_158
        Dec_ _rc_
        jns  ppm_0306
        Mov_ _rc_,$168
        Jmp_ err_
ppm_0306:
call_158:
        Mov_ %esi,%edi
        call gtstg
        Dec_ _rc_
        js   call_159
        Dec_ _rc_
        jns  ppm_0307
        Mov_ _rc_,$169
        Jmp_ err_
ppm_0307:
call_159:
        Cmp_ %edi,r_ra2
        jne  srpl1
        Cmp_ %esi,r_ra3
        je   srpl4
srpl1:
        Mov_ %ebx,4(%esi)
        Cmp_ %ecx,%ebx
        jne  srpl6
        Cmp_ %edi,kvalp
        je   srpl5
        or   %ebx,%ebx
        jz   srpl6
        Mov_ r_ra3,%esi
        Mov_ r_ra2,%edi
        Mov_ %esi,kvalp
        Mov_ %ecx,4(%esi)
        Mov_ %edi,r_rpt
        or   %edi,%edi
        jnz  srpl2
        call alocs
        Mov_ %ecx,%edx
        Mov_ r_rpt,%edi
srpl2:
        mov  %ecx,ctbw_r
        movl $scsi_,ctbw_v
        call ctb_
        movl ctbw_r,%ecx
        Sar_ %ecx,$2
        rep  movsl
        Mov_ %esi,r_ra2
        Xor_ %eax,%eax
        Mov_ %edx,%eax
        Mov_ %edi,r_ra3
        Add_ %edi,$cfp_f
srpl3:
        Mov_ %esi,r_ra2
        Add_ %esi,%edx
        Add_ %esi,$cfp_f
        Inc_ %edx
#lch s.text (xl)  s.type 9  s.reg xl
#lch d.text wa  d.type 8  d.reg wa  w 0
        Xor_ %ecx,%ecx
        movb (%esi),%cl
        Mov_ %esi,r_rpt
        Add_ %esi,%ecx
        Add_ %esi,$cfp_f
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wa  d.type 8  d.reg wa  w 0
        Xor_ %ecx,%ecx
        movb (%edi),%cl
        Inc_ %edi
#sch s.text wa  s.type 8  s.reg wa
#sch d.text (xl)  d.type 9  d.reg xl  w 0
        movb %cl,(%esi)
        Dec_ %ebx
        jnz  srpl3
srpl4:
        Mov_ %esi,r_rpt
srpl5:
        call gtstg
        Dec_ _rc_
        js   call_160
        Dec_ _rc_
        jns  ppm_0308
        Mov_ _rc_,$170
        Jmp_ err_
ppm_0308:
call_160:
        or   %ecx,%ecx
        jz   exnul
        push %esi
        Mov_ %esi,%edi
        Mov_ %edx,%ecx
        mov  %ecx,ctbw_r
        movl $schar,ctbw_v
        call ctb_
        movl ctbw_r,%ecx
        call alloc
        Mov_ %ebx,%edi
        Sar_ %ecx,$2
        rep  movsl
        pop  %edi
        Add_ %edi,$cfp_f
        Mov_ %esi,%ebx
        Add_ %esi,$cfp_f
        Mov_ %ecx,%edx
        xchg %esi,%edi
trc_0309: movzbl (%edi),%eax
        Add_ (%esi),%eax
        mov  (%eax),%al
        stosb
        dec  %ecx
        jnz  trc_0309
        Xor_ %esi,%esi
        Xor_ %edi,%edi
srpl8:
        push %ebx
        Lcw_ %edi
        Jmp_ *(%edi)
srpl6:
        Mov_ _rc_,$171
        Jmp_ err_
	Align_	2
	nop
s_rew:
        call iofcb
        Dec_ _rc_
        js   call_161
        Dec_ _rc_
        jns  ppm_0310
        Mov_ _rc_,$172
        Jmp_ err_
ppm_0310:
        Dec_ _rc_
        jns  ppm_0311
        Mov_ _rc_,$173
        Jmp_ err_
ppm_0311:
        Dec_ _rc_
        jns  ppm_0312
        Mov_ _rc_,$174
        Jmp_ err_
ppm_0312:
call_161:
        call sysrw
        Dec_ _rc_
        js   call_162
        Dec_ _rc_
        jns  ppm_0313
        Mov_ _rc_,$174
        Jmp_ err_
ppm_0313:
        Dec_ _rc_
        jns  ppm_0314
        Mov_ _rc_,$175
        Jmp_ err_
ppm_0314:
        Dec_ _rc_
        jns  ppm_0315
        Mov_ _rc_,$176
        Jmp_ err_
ppm_0315:
call_162:
        Jmp_ exnul
	Align_	2
	nop
s_rvs:
        call gtstg
        Dec_ _rc_
        js   call_163
        Dec_ _rc_
        jns  ppm_0316
        Mov_ _rc_,$177
        Jmp_ err_
ppm_0316:
call_163:
        or   %ecx,%ecx
        jz   exixr
        Mov_ %esi,%edi
        call alocs
        push %edi
        Add_ %edi,$cfp_f
        Add_ %esi,%edx
        Add_ %esi,$cfp_f
srvs1:
#lch s.text -(xl)  s.type 11  s.reg xl
#lch d.text wb  d.type 8  d.reg wb  w 0
        dec  %esi
        Xor_ %ebx,%ebx
        movb (%esi),%bl
#sch s.text wb  s.type 8  s.reg wb
#sch d.text (xr)+  d.type 10  d.reg xr  w 0
        movb %bl,(%edi)
        Inc_ %edi
        Dec_ %edx
        jnz  srvs1
srvs4:
        Xor_ %eax,%eax
        Mov_ %esi,%eax
srvs2:
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
s_rpd:
        call gtstg
        Dec_ _rc_
        js   call_164
        Dec_ _rc_
        jns  ppm_0317
        Mov_ _rc_,$178
        Jmp_ err_
ppm_0317:
call_164:
        Add_ %edi,$cfp_f
#lch s.text (xr)  s.type 9  s.reg xr
#lch d.text wb  d.type 8  d.reg wb  w 0
        Xor_ %ebx,%ebx
        movb (%edi),%bl
        call gtsmi
        Dec_ _rc_
        js   call_165
        Dec_ _rc_
        jns  ppm_0318
        Mov_ _rc_,$179
        Jmp_ err_
ppm_0318:
        Dec_ _rc_
        jns  ppm_0319
        Jmp_ srpd3
ppm_0319:
call_165:
srpd1:
        call gtstg
        Dec_ _rc_
        js   call_166
        Dec_ _rc_
        jns  ppm_0320
        Mov_ _rc_,$180
        Jmp_ err_
ppm_0320:
call_166:
        Cmp_ %ecx,%edx
        jae  exixr
        Mov_ %esi,%edi
        Mov_ %ecx,%edx
        call alocs
        push %edi
        Mov_ %ecx,4(%esi)
        Sub_ %edx,%ecx
        Add_ %edi,$cfp_f
        or   %ecx,%ecx
        jz   srpd2
        Add_ %esi,$cfp_f
        rep  movsb
        Xor_ %eax,%eax
        Mov_ %esi,%eax
srpd2:
#sch s.text wb  s.type 8  s.reg wb
#sch d.text (xr)+  d.type 10  d.reg xr  w 0
        movb %bl,(%edi)
        Inc_ %edi
        Dec_ %edx
        jnz  srpd2
        Lcw_ %edi
        Jmp_ *(%edi)
srpd3:
        Xor_ %eax,%eax
        Mov_ %edx,%eax
        Jmp_ srpd1
	Align_	2
	nop
s_rtb:
        Mov_ %ebx,$p_rtb
        Mov_ %ecx,$p_rtd
        call patin
        Dec_ _rc_
        js   call_167
        Dec_ _rc_
        jns  ppm_0322
        Mov_ _rc_,$181
        Jmp_ err_
ppm_0322:
        Dec_ _rc_
        jns  ppm_0323
        Mov_ _rc_,$182
        Jmp_ err_
ppm_0323:
call_167:
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
s_set:
        pop  r_io2
        pop  r_io1
        call iofcb
        Dec_ _rc_
        js   call_168
        Dec_ _rc_
        jns  ppm_0324
        Mov_ _rc_,$291
        Jmp_ err_
ppm_0324:
        Dec_ _rc_
        jns  ppm_0325
        Mov_ _rc_,$292
        Jmp_ err_
ppm_0325:
        Dec_ _rc_
        jns  ppm_0326
        Mov_ _rc_,$295
        Jmp_ err_
ppm_0326:
call_168:
        Mov_ %ebx,r_io1
        Mov_ %edx,r_io2
        call sysst
        Dec_ _rc_
        jns  ppm_0327
        Mov_ _rc_,$293
        Jmp_ err_
ppm_0327:
        Dec_ _rc_
        jns  ppm_0328
        Mov_ _rc_,$294
        Jmp_ err_
ppm_0328:
        Dec_ _rc_
        jns  ppm_0329
        Mov_ _rc_,$295
        Jmp_ err_
ppm_0329:
        Dec_ _rc_
        jns  ppm_0330
        Mov_ _rc_,$296
        Jmp_ err_
ppm_0330:
        Dec_ _rc_
        jns  ppm_0331
        Mov_ _rc_,$297
        Jmp_ err_
ppm_0331:
        Jmp_ exint
	Align_	2
	nop
s_tab:
        Mov_ %ebx,$p_tab
        Mov_ %ecx,$p_tbd
        call patin
        Dec_ _rc_
        js   call_169
        Dec_ _rc_
        jns  ppm_0332
        Mov_ _rc_,$183
        Jmp_ err_
ppm_0332:
        Dec_ _rc_
        jns  ppm_0333
        Mov_ _rc_,$184
        Jmp_ err_
ppm_0333:
call_169:
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
s_rps:
        Mov_ %ebx,$p_rps
        Mov_ %ecx,$p_rpd
        call patin
        Dec_ _rc_
        js   call_170
        Dec_ _rc_
        jns  ppm_0334
        Mov_ _rc_,$185
        Jmp_ err_
ppm_0334:
        Dec_ _rc_
        jns  ppm_0335
        Mov_ _rc_,$186
        Jmp_ err_
ppm_0335:
call_170:
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
s_rsr:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %ecx,%eax
        call sorta
        Dec_ _rc_
        js   call_171
        Dec_ _rc_
        jns  ppm_0336
        Jmp_ exfal
ppm_0336:
call_171:
        Jmp_ exsid
	Align_	2
	nop
s_stx:
        pop  %edi
        Mov_ %ecx,stxvr
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        Cmp_ %edi,$nulls
        je   sstx1
        call gtnvr
        Dec_ _rc_
        js   call_172
        Dec_ _rc_
        jns  ppm_0337
        Jmp_ sstx2
ppm_0337:
call_172:
        Mov_ %esi,16(%edi)
        Cmp_ %esi,$stndl
        je   sstx2
        Cmp_ (%esi),$b_trt
        jne  sstx1
        Mov_ %esi,8(%esi)
sstx1:
        Mov_ stxvr,%edi
        Mov_ r_sxc,%esi
        Cmp_ %ecx,$nulls
        je   exnul
        Mov_ %edi,%ecx
        Jmp_ exvnm
sstx2:
        Mov_ _rc_,$187
        Jmp_ err_
	Align_	2
	nop
s_sin:
        pop  %edi
        call gtrea
        Dec_ _rc_
        js   call_173
        Dec_ _rc_
        jns  ppm_0338
        Mov_ _rc_,$308
        Jmp_ err_
ppm_0338:
call_173:
        Mov_ %eax,%edi
        Add_ %eax,(cfp_b*rcval)
        call ldr_
        call sin_
        rno_ exrea
        Mov_ _rc_,$323
        Jmp_ err_
	Align_	2
	nop
s_sqr:
        pop  %edi
        call gtrea
        Dec_ _rc_
        js   call_174
        Dec_ _rc_
        jns  ppm_0339
        Mov_ _rc_,$313
        Jmp_ err_
ppm_0339:
call_174:
        Mov_ %eax,%edi
        Add_ %eax,(cfp_b*rcval)
        call ldr_
        call cpr_
        movb reg_fl,%al
        or   %al,%al
        jl   ssqr1
        call sqr_
        Jmp_ exrea
ssqr1:
        Mov_ _rc_,$314
        Jmp_ err_
	Align_	2
	nop
s_srt:
        Xor_ %eax,%eax
        Mov_ %ecx,%eax
        call sorta
        Dec_ _rc_
        js   call_175
        Dec_ _rc_
        jns  ppm_0340
        Jmp_ exfal
ppm_0340:
call_175:
        Jmp_ exsid
	Align_	2
	nop
s_spn:
        Mov_ %ebx,$p_sps
        Mov_ %esi,$p_spn
        Mov_ %edx,$p_spd
        call patst
        Dec_ _rc_
        js   call_176
        Dec_ _rc_
        jns  ppm_0341
        Mov_ _rc_,$188
        Jmp_ err_
ppm_0341:
call_176:
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
s_si_:
        call gtstg
        Dec_ _rc_
        js   call_177
        Dec_ _rc_
        jns  ppm_0342
        Mov_ _rc_,$189
        Jmp_ err_
ppm_0342:
call_177:
        ldi_ %ecx
        Jmp_ exint
	Align_	2
	nop
s_stt:
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        call trace
        Dec_ _rc_
        js   call_178
        Dec_ _rc_
        jns  ppm_0343
        Mov_ _rc_,$190
        Jmp_ err_
ppm_0343:
        Dec_ _rc_
        jns  ppm_0344
        Mov_ _rc_,$191
        Jmp_ err_
ppm_0344:
call_178:
        Jmp_ exnul
	Align_	2
	nop
s_sub:
        call gtsmi
        Dec_ _rc_
        js   call_179
        Dec_ _rc_
        jns  ppm_0345
        Mov_ _rc_,$192
        Jmp_ err_
ppm_0345:
        Dec_ _rc_
        jns  ppm_0346
        Jmp_ exfal
ppm_0346:
call_179:
        Mov_ sbssv,%edi
        call gtsmi
        Dec_ _rc_
        js   call_180
        Dec_ _rc_
        jns  ppm_0347
        Mov_ _rc_,$193
        Jmp_ err_
ppm_0347:
        Dec_ _rc_
        jns  ppm_0348
        Jmp_ exfal
ppm_0348:
call_180:
        Mov_ %edx,%edi
        or   %edx,%edx
        jz   exfal
        Dec_ %edx
        call gtstg
        Dec_ _rc_
        js   call_181
        Dec_ _rc_
        jns  ppm_0349
        Mov_ _rc_,$194
        Jmp_ err_
ppm_0349:
call_181:
        Mov_ %ebx,%edx
        Mov_ %edx,sbssv
        or   %edx,%edx
        jnz  ssub2
        Mov_ %edx,%ecx
        Cmp_ %ebx,%edx
        ja   exfal
        Sub_ %edx,%ebx
ssub2:
        Mov_ %esi,%ecx
        Mov_ %ecx,%edx
        Add_ %edx,%ebx
        Cmp_ %edx,%esi
        ja   exfal
        Mov_ %esi,%edi
        call sbstr
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
s_tbl:
        pop  %esi
        Add_ %esp,$cfp_b
        call gtsmi
        Dec_ _rc_
        js   call_182
        Dec_ _rc_
        jns  ppm_0350
        Mov_ _rc_,$195
        Jmp_ err_
ppm_0350:
        Dec_ _rc_
        jns  ppm_0351
        Mov_ _rc_,$196
        Jmp_ err_
ppm_0351:
call_182:
        or   %edx,%edx
        jnz  stbl1
        Mov_ %edx,$tbnbk
stbl1:
        call tmake
        Jmp_ exsid
	Align_	2
	nop
s_tan:
        pop  %edi
        call gtrea
        Dec_ _rc_
        js   call_183
        Dec_ _rc_
        jns  ppm_0352
        Mov_ _rc_,$309
        Jmp_ err_
ppm_0352:
call_183:
        Mov_ %eax,%edi
        Add_ %eax,(cfp_b*rcval)
        call ldr_
        call tan_
        rno_ exrea
        Mov_ _rc_,$310
        Jmp_ err_
	Align_	2
	nop
s_tim:
        call systm
        Mov_ %eax,timsx
        sbi_
        Jmp_ exint
	Align_	2
	nop
s_tra:
        Cmp_ 12(%esp),$nulls
        je   str02
        pop  %edi
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        Cmp_ %edi,$nulls
        je   str01
        call gtnvr
        Dec_ _rc_
        js   call_184
        Dec_ _rc_
        jns  ppm_0353
        Jmp_ str03
ppm_0353:
call_184:
        Mov_ %esi,%edi
str01:
        pop  %edi
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        call trbld
        Mov_ %esi,%edi
        call trace
        Dec_ _rc_
        js   call_185
        Dec_ _rc_
        jns  ppm_0354
        Mov_ _rc_,$198
        Jmp_ err_
ppm_0354:
        Dec_ _rc_
        jns  ppm_0355
        Mov_ _rc_,$199
        Jmp_ err_
ppm_0355:
call_185:
        Jmp_ exnul
str02:
        call systt
        Add_ %esp,$4*num04
        Jmp_ exnul
str03:
        Mov_ _rc_,$197
        Jmp_ err_
	Align_	2
	nop
s_trm:
        call gtstg
        Dec_ _rc_
        js   call_186
        Dec_ _rc_
        jns  ppm_0356
        Mov_ _rc_,$200
        Jmp_ err_
ppm_0356:
call_186:
        or   %ecx,%ecx
        jz   exnul
        Mov_ %esi,%edi
        mov  %ecx,ctbw_r
        movl $schar,ctbw_v
        call ctb_
        movl ctbw_r,%ecx
        call alloc
        Mov_ %ebx,%edi
        Sar_ %ecx,$2
        rep  movsl
        Mov_ %edi,%ebx
        call trimr
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
	Align_	2
	nop
s_unl:
        pop  %edi
        call gtnvr
        Dec_ _rc_
        js   call_187
        Dec_ _rc_
        jns  ppm_0357
        Mov_ _rc_,$201
        Jmp_ err_
ppm_0357:
call_187:
        Mov_ %esi,$stndf
        call dffnc
        Jmp_ exnul
arref:
        Mov_ %ecx,%edi
        Mov_ %esi,%esp
        Sal_ %edi,$2
        Add_ %esi,%edi
        Add_ %esi,$cfp_b
        Mov_ arfxs,%esi
        Sub_ %esi,$4
        Mov_ %edi,(%esi)
        Mov_ r_arf,%edi
        Mov_ %edi,%esi
        Mov_ %esi,r_arf
        Mov_ %edx,(%esi)
        Cmp_ %edx,$b_art
        je   arf01
        Cmp_ %edx,$b_vct
        je   arf07
        Cmp_ %edx,$b_tbt
        je   arf10
        Mov_ _rc_,$235
        Jmp_ err_
arf01:
        Cmp_ %ecx,16(%esi)
        jne  arf09
        ldi_ intv0
        Mov_ %esi,%edi
        Xor_ %eax,%eax
        Mov_ %ecx,%eax
        Jmp_ arf03
arf02:
        Mov_ %eax,32(%edi)
        mli_
arf03:
        Sub_ %esi,$4
        Mov_ %edi,(%esi)
        sti_ arfsi
        ldi_ 4(%edi)
        Cmp_ (%edi),$_b_icl
        je   arf04
        call gtint
        Dec_ _rc_
        js   call_188
        Dec_ _rc_
        jns  ppm_0358
        Jmp_ arf12
ppm_0358:
call_188:
        ldi_ 4(%edi)
arf04:
        Mov_ %edi,r_arf
        Add_ %edi,%ecx
        Mov_ %eax,20(%edi)
        sbi_
        iov_ arf13
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jl   arf13
        Mov_ %eax,24(%edi)
        sbi_
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jge  arf13
        Mov_ %eax,24(%edi)
        adi_
        Mov_ %eax,arfsi
        adi_
        Add_ %ecx,$4*ardms
        Cmp_ %esi,%esp
        jne  arf02
        sti_ %ecx
        Sal_ %ecx,$2
        Mov_ %esi,r_arf
        Add_ %ecx,12(%esi)
        Add_ %ecx,$cfp_b
        or   %ebx,%ebx
        jnz  arf08
arf05:
        call acess
        Dec_ _rc_
        js   call_189
        Dec_ _rc_
        jns  ppm_0359
        Jmp_ arf13
ppm_0359:
call_189:
arf06:
        Mov_ %esp,arfxs
        Xor_ %eax,%eax
        Mov_ r_arf,%eax
        push %edi
        Lcw_ %edi
        Jmp_ *(%edi)
arf07:
        Cmp_ %ecx,$num01
        jne  arf09
        Mov_ %edi,(%esp)
        call gtint
        Dec_ _rc_
        js   call_190
        Dec_ _rc_
        jns  ppm_0360
        Jmp_ arf12
ppm_0360:
call_190:
        ldi_ 4(%edi)
        Mov_ %eax,intv1
        sbi_
        sti_ %eax
        or   %eax,%eax
        js   arf13
        sti_ %ecx
        Add_ %ecx,$vcvls
        Sal_ %ecx,$2
        Cmp_ %ecx,8(%esi)
        jae  arf13
        or   %ebx,%ebx
        jz   arf05
arf08:
        Mov_ %esp,arfxs
        Xor_ %eax,%eax
        Mov_ r_arf,%eax
        Jmp_ exnam
arf09:
        Mov_ _rc_,$236
        Jmp_ err_
arf10:
        Cmp_ %ecx,$num01
        jne  arf11
        Mov_ %edi,(%esp)
        call tfind
        Dec_ _rc_
        js   call_191
        Dec_ _rc_
        jns  ppm_0361
        Jmp_ arf13
ppm_0361:
call_191:
        or   %ebx,%ebx
        jnz  arf08
        Jmp_ arf06
arf11:
        Mov_ _rc_,$237
        Jmp_ err_
arf12:
        Mov_ _rc_,$238
        Jmp_ err_
arf13:
        Xor_ %eax,%eax
        Mov_ r_arf,%eax
        Jmp_ exfal
cfunc:
        Cmp_ %ecx,4(%esi)
        jb   cfnc1
        Cmp_ %ecx,4(%esi)
        je   cfnc3
        Mov_ %ebx,%ecx
        Sub_ %ebx,4(%esi)
        Sal_ %ebx,$2
        Add_ %esp,%ebx
        Jmp_ cfnc3
cfnc1:
        Mov_ %ebx,4(%esi)
        Cmp_ %ebx,$nini9
        je   cfnc3
        Sub_ %ebx,%ecx
cfnc2:
        push $nulls
        Dec_ %ebx
        jnz  cfnc2
cfnc3:
        Jmp_ *(%esi)
exfal:
        Mov_ %esp,_flptr
        Mov_ %edi,(%esp)
        Add_ %edi,r_cod
        Lcp_ %edi
        Lcw_ %edi
        Mov_ %esi,(%edi)
        Jmp_ *%esi
exint:
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        call icbld
exixr:
        push %edi
exits:
        Lcw_ %edi
        Mov_ %esi,(%edi)
        Jmp_ *%esi
exnam:
        push %esi
        push %ecx
        Lcw_ %edi
        Jmp_ *(%edi)
exnul:
        push $nulls
        Lcw_ %edi
        Mov_ %esi,(%edi)
        Jmp_ *%esi
exrea:
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        call rcbld
        Jmp_ exixr
exsid:
        Mov_ %ecx,curid
        Cmp_ %ecx,mxint
        jne  exsi1
        Xor_ %eax,%eax
        Mov_ %ecx,%eax
exsi1:
        Inc_ %ecx
        Mov_ curid,%ecx
        Mov_ 4(%edi),%ecx
        Jmp_ exixr
exvnm:
        Mov_ %esi,%edi
        Mov_ %ecx,$4*nmsi_
        call alloc
        Mov_ (%edi),$b_nml
        Mov_ 4(%edi),%esi
        Mov_ 8(%edi),$4*vrval
        Jmp_ exixr
flpop:
        Add_ %esp,$4*num02
failp:
        pop  %edi
        pop  %ebx
        Mov_ %esi,(%edi)
        Jmp_ *%esi
indir:
        pop  %edi
        Cmp_ (%edi),$b_nml
        je   indr2
        call gtnvr
        Dec_ _rc_
        js   call_192
        Dec_ _rc_
        jns  ppm_0362
        Mov_ _rc_,$239
        Jmp_ err_
ppm_0362:
call_192:
        or   %ebx,%ebx
        jz   indr1
        push %edi
        push $4*vrval
        Lcw_ %edi
        Mov_ %esi,(%edi)
        Jmp_ *%esi
indr1:
        Jmp_ *(%edi)
indr2:
        Mov_ %esi,4(%edi)
        Mov_ %ecx,8(%edi)
        or   %ebx,%ebx
        jnz  exnam
        call acess
        Dec_ _rc_
        js   call_193
        Dec_ _rc_
        jns  ppm_0363
        Jmp_ exfal
ppm_0363:
call_193:
        Jmp_ exixr
match:
        pop  %edi
        call gtpat
        Dec_ _rc_
        js   call_194
        Dec_ _rc_
        jns  ppm_0364
        Mov_ _rc_,$240
        Jmp_ err_
ppm_0364:
call_194:
        Mov_ %esi,%edi
        or   %ebx,%ebx
        jnz  mtch1
        Mov_ %ecx,(%esp)
        push %esi
        Mov_ %esi,8(%esp)
        call acess
        Dec_ _rc_
        js   call_195
        Dec_ _rc_
        jns  ppm_0365
        Jmp_ exfal
ppm_0365:
call_195:
        Mov_ %esi,(%esp)
        Mov_ (%esp),%edi
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
mtch1:
        call gtstg
        Dec_ _rc_
        js   call_196
        Dec_ _rc_
        jns  ppm_0366
        Mov_ _rc_,$241
        Jmp_ err_
ppm_0366:
call_196:
        push %ebx
        Mov_ r_pms,%edi
        Mov_ pmssl,%ecx
        Xor_ %eax,%eax
        push %eax
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Mov_ _pmhbs,%esp
        Xor_ %eax,%eax
        Mov_ pmdfl,%eax
        Mov_ %edi,%esi
        Xor_ %eax,%eax
        Cmp_ kvanc,%eax
        jnz  mtch2
        push %edi
        push $nduna
        Jmp_ *(%edi)
mtch2:
        Xor_ %eax,%eax
        push %eax
        push $ndabo
        Jmp_ *(%edi)
retrn:
        Xor_ %eax,%eax
        Cmp_ kvfnc,%eax
        jnz  rtn01
        Mov_ _rc_,$242
        Jmp_ err_
rtn01:
        Mov_ %esp,_flprt
        Add_ %esp,$cfp_b
        pop  %edi
        pop  _flptr
        pop  _flprt
        pop  %ebx
        pop  %edx
        Add_ %ebx,%edx
        Lcp_ %ebx
        Mov_ r_cod,%edx
        Dec_ kvfnc
        Mov_ %ebx,kvtra
        Add_ %ebx,kvftr
        or   %ebx,%ebx
        jz   rtn06
        push %ecx
        push %edi
        Mov_ kvrtn,%ecx
        Mov_ %esi,r_fnc
        call ktrex
        Mov_ %esi,12(%edi)
        Xor_ %eax,%eax
        Cmp_ kvtra,%eax
        jz   rtn02
        Mov_ %edi,28(%edi)
        or   %edi,%edi
        jz   rtn02
        Dec_ kvtra
        Xor_ %eax,%eax
        Cmp_ 16(%edi),%eax
        jz   rtn03
        Mov_ %ecx,$4*vrval
        Mov_ %eax,4(%esp)
        Mov_ kvrtn,%eax
        call trxeq
rtn02:
        Xor_ %eax,%eax
        Cmp_ kvftr,%eax
        jz   rtn05
        Dec_ kvftr
rtn03:
        call prtsn
        Mov_ %edi,4(%esp)
        call prtst
        Mov_ %ecx,$ch_bl
        call prtch
        Mov_ %esi,0(%esp)
        Mov_ %esi,12(%esi)
        Mov_ %ecx,$4*vrval
        Cmp_ %edi,$scfrt
        jne  rtn04
        call prtnm
        call prtnl
        Jmp_ rtn05
rtn04:
        call prtnv
rtn05:
        pop  %edi
        pop  %ecx
rtn06:
        Mov_ kvrtn,%ecx
        Mov_ %esi,12(%edi)
rtn07:
        Mov_ rtnbp,%esi
        Mov_ %esi,8(%esi)
        Cmp_ (%esi),$b_trt
        je   rtn07
        Mov_ rtnfv,%esi
        pop  rtnsv
        pop  %esi
        or   %esi,%esi
        jz   rtn7c
        Xor_ %eax,%eax
        Cmp_ kvpfl,%eax
        jz   rtn7c
        call prflu
        Cmp_ kvpfl,$num02
        je   rtn7a
        ldi_ pfstm
        Mov_ %eax,4(%esi)
        sbi_
        Jmp_ rtn7b
rtn7a:
        ldi_ 4(%esi)
rtn7b:
        sti_ pfstm
rtn7c:
        Mov_ %ebx,4(%edi)
        Add_ %ebx,16(%edi)
        or   %ebx,%ebx
        jz   rtn10
        Add_ %edi,8(%edi)
rtn08:
        Sub_ %edi,$4
        Mov_ %esi,(%edi)
rtn09:
        Mov_ %ecx,%esi
        Mov_ %esi,8(%esi)
        Cmp_ (%esi),$b_trt
        je   rtn09
        Mov_ %esi,%ecx
        pop  8(%esi)
        Dec_ %ebx
        jnz  rtn08
rtn10:
        Mov_ %esi,rtnbp
        Mov_ %eax,rtnsv
        Mov_ 8(%esi),%eax
        Mov_ %edi,rtnfv
        Mov_ %esi,r_cod
        Mov_ %eax,kvstn
        Mov_ kvlst,%eax
        Mov_ %eax,4(%esi)
        Mov_ kvstn,%eax
        Mov_ %eax,kvlin
        Mov_ kvlln,%eax
        Mov_ %eax,8(%esi)
        Mov_ kvlin,%eax
        Mov_ %ecx,kvrtn
        Cmp_ %ecx,$scrtn
        je   exixr
        Cmp_ %ecx,$scfrt
        je   exfal
        Cmp_ (%edi),$b_nml
        je   rtn11
        call gtnvr
        Dec_ _rc_
        js   call_197
        Dec_ _rc_
        jns  ppm_0367
        Mov_ _rc_,$243
        Jmp_ err_
ppm_0367:
call_197:
        Mov_ %esi,%edi
        Mov_ %ecx,$4*vrval
        Jmp_ rtn12
rtn11:
        Mov_ %esi,4(%edi)
        Mov_ %ecx,8(%edi)
rtn12:
        Mov_ %edi,%esi
        Lcw_ %ebx
        Mov_ %esi,%edi
        Cmp_ %ebx,$ofne_
        je   exnam
        push %ebx
        call acess
        Dec_ _rc_
        js   call_198
        Dec_ _rc_
        jns  ppm_0368
        Jmp_ exfal
ppm_0368:
call_198:
        Mov_ %esi,%edi
        Mov_ %edi,(%esp)
        Mov_ (%esp),%esi
        Mov_ %esi,(%edi)
        Jmp_ *%esi
stcov:
        Inc_ errft
        ldi_ intvt
        Mov_ %eax,kvstl
        adi_
        sti_ kvstl
        ldi_ intvt
        sti_ kvstc
        call stgcc
        Mov_ _rc_,$244
        Jmp_ err_
stmgo:
        Mov_ r_cod,%edi
        Dec_ stmct
        Xor_ %eax,%eax
        Cmp_ stmct,%eax
        jz   stgo2
        Mov_ %eax,kvstn
        Mov_ kvlst,%eax
        Mov_ %eax,4(%edi)
        Mov_ kvstn,%eax
        Mov_ %eax,kvlin
        Mov_ kvlln,%eax
        Mov_ %eax,8(%edi)
        Mov_ kvlin,%eax
        Add_ %edi,$4*cdcod
        Lcp_ %edi
stgo1:
        Lcw_ %edi
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        Jmp_ *(%edi)
stgo2:
        Xor_ %eax,%eax
        Cmp_ kvpfl,%eax
        jz   stgo3
        call prflu
stgo3:
        Mov_ %eax,kvstn
        Mov_ kvlst,%eax
        Mov_ %eax,4(%edi)
        Mov_ kvstn,%eax
        Mov_ %eax,kvlin
        Mov_ kvlln,%eax
        Mov_ %eax,8(%edi)
        Mov_ kvlin,%eax
        Add_ %edi,$4*cdcod
        Lcp_ %edi
        push stmcs
        Dec_ _polct
        Xor_ %eax,%eax
        Cmp_ _polct,%eax
        jnz  stgo4
        Xor_ %eax,%eax
        Mov_ %ecx,%eax
        Mov_ %ebx,kvstn
        Mov_ %esi,%edi
        call syspl
        Dec_ _rc_
        js   call_199
        Dec_ _rc_
        jns  ppm_0369
        Mov_ _rc_,$320
        Jmp_ err_
ppm_0369:
        Dec_ _rc_
        jns  ppm_0370
        Mov_ _rc_,$299
        Jmp_ err_
ppm_0370:
        Dec_ _rc_
        jns  ppm_0371
        Mov_ _rc_,$299
        Jmp_ err_
ppm_0371:
call_199:
        Mov_ %edi,%esi
        Mov_ polcs,%ecx
        call stgcc
stgo4:
        ldi_ kvstc
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jl   stgo5
        pop  %eax
        ldi_ %eax
        ngi_
        Mov_ %eax,kvstc
        adi_
        sti_ kvstc
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jle  stcov
        Xor_ %eax,%eax
        Cmp_ r_stc,%eax
        jz   stgo5
        Xor_ %eax,%eax
        Mov_ %edi,%eax
        Mov_ %esi,r_stc
        call ktrex
stgo5:
        Mov_ %eax,stmcs
        Mov_ stmct,%eax
        Jmp_ stgo1
stopr:
        or   %edi,%edi
        jz   stpra
        call sysax
stpra:
        Mov_ %eax,rsmem
        Add_ dname,%eax
        Cmp_ %edi,$endms
        jne  stpr0
        Xor_ %eax,%eax
        Cmp_ exsts,%eax
        jnz  stpr3
        Xor_ %eax,%eax
        Mov_ erich,%eax
stpr0:
        call prtpg
        or   %edi,%edi
        jz   stpr1
        call prtst
stpr1:
        call prtis
        Xor_ %eax,%eax
        Cmp_ gbcfl,%eax
        jnz  stpr5
        Mov_ %edi,$stpm7
        call prtst
        Mov_ profs,$prtmf
        Mov_ %edx,kvstn
        call filnm
        Mov_ %edi,%esi
        call prtst
        call prtis
        Mov_ %edi,r_cod
        ldi_ 8(%edi)
        Mov_ %edi,$stpm6
        call prtmx
stpr5:
        ldi_ kvstn
        Mov_ %edi,$stpm1
        call prtmx
        call systm
        Mov_ %eax,timsx
        sbi_
        sti_ stpti
        Mov_ %edi,$stpm3
        call prtmx
        ldi_ kvstl
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jl   stpr2
        Mov_ %eax,kvstc
        sbi_
        sti_ stpsi
        Mov_ %ecx,stmcs
        Sub_ %ecx,stmct
        ldi_ %ecx
        Mov_ %eax,stpsi
        adi_
        sti_ stpsi
        Mov_ %edi,$stpm2
        call prtmx
        ldi_ stpti
        Mov_ %eax,intth
        mli_
        iov_ stpr2
        Mov_ %eax,stpsi
        dvi_
        iov_ stpr2
        Mov_ %edi,$stpm4
        call prtmx
stpr2:
        ldi_ gbcnt
        Mov_ %edi,$stpm5
        call prtmx
        call prtmm
        call prtis
stpr3:
        call prflr
        Mov_ %edi,kvdmp
        call dumpr
        Mov_ %esi,_r_fcb
        Mov_ %ecx,kvabe
        Mov_ %ebx,kvcod
        call sysej
stpr4:
        Mov_ %eax,rsmem
        Add_ dname,%eax
        Xor_ %eax,%eax
        Cmp_ exsts,%eax
        jz   stpr1
        Jmp_ stpr3
succp:
        Mov_ %edi,4(%edi)
        Mov_ %esi,(%edi)
        Jmp_ *%esi
sysab:
        Mov_ %edi,$endab
        Mov_ kvabe,$num01
        call prtnl
        Jmp_ stopr
systu:
        Mov_ %edi,$endtu
        Mov_ %ecx,strtu
        Mov_ kvcod,%ecx
        Mov_ %ecx,timup
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ timup,%eax
        or   %ecx,%ecx
        jnz  stopr
        Mov_ _rc_,$245
        Jmp_ err_
acess:
        Mov_ %edi,%esi
        Add_ %edi,%ecx
        Mov_ %edi,(%edi)
acs02:
        Cmp_ (%edi),$b_trt
        jne  acs18
        Cmp_ %edi,$trbkv
        je   acs12
        Cmp_ %edi,$trbev
        jne  acs05
        Mov_ %edi,4(%esi)
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        call evalx
        Dec_ _rc_
        js   call_200
        Dec_ _rc_
        jns  ppm_0372
        Jmp_ acs04
ppm_0372:
call_200:
        Jmp_ acs02
acs03:
        Add_ %esp,$4*num03
        Mov_ _dnamp,%edi
acs04:
        Mov_ _rc_,$1
        ret
acs05:
        Mov_ %ebx,4(%edi)
        or   %ebx,%ebx
        jnz  acs10
        Xor_ %eax,%eax
        Cmp_ kvinp,%eax
        jz   acs09
        push %esi
        push %ecx
        push %edi
        Mov_ %eax,kvtrm
        Mov_ actrm,%eax
        Mov_ %esi,16(%edi)
        or   %esi,%esi
        jnz  acs06
        Cmp_ 12(%edi),$v_ter
        je   acs21
        Mov_ %ecx,cswin
        call alocs
        call sysrd
        Dec_ _rc_
        js   call_201
        Dec_ _rc_
        jns  ppm_0373
        Jmp_ acs03
ppm_0373:
call_201:
        Jmp_ acs07
acs06:
        Mov_ %ecx,%esi
        call sysil
        or   %edx,%edx
        jnz  acs6a
        Mov_ actrm,%edx
acs6a:
        call alocs
        Mov_ %ecx,%esi
        call sysin
        Dec_ _rc_
        js   call_202
        Dec_ _rc_
        jns  ppm_0374
        Jmp_ acs03
ppm_0374:
        Dec_ _rc_
        jns  ppm_0375
        Jmp_ acs22
ppm_0375:
        Dec_ _rc_
        jns  ppm_0376
        Jmp_ acs23
ppm_0376:
call_202:
acs07:
        Mov_ %ebx,actrm
        call trimr
        Mov_ %ebx,%edi
        Mov_ %edi,(%esp)
acs08:
        Mov_ %esi,%edi
        Mov_ %edi,8(%edi)
        Cmp_ (%edi),$b_trt
        je   acs08
        Mov_ 8(%esi),%ebx
        pop  %edi
        pop  %ecx
        pop  %esi
acs09:
        Mov_ %edi,8(%edi)
        Jmp_ acs02
acs10:
        Cmp_ %ebx,$trtac
        jne  acs09
        Xor_ %eax,%eax
        Cmp_ kvtra,%eax
        jz   acs09
        Dec_ kvtra
        Xor_ %eax,%eax
        Cmp_ 16(%edi),%eax
        jz   acs11
        call trxeq
        Jmp_ acs09
acs11:
        call prtsn
        call prtnv
        Jmp_ acs09
acs12:
        Mov_ %edi,8(%esi)
        Cmp_ %edi,$k_v__
        jae  acs14
        ldi_ kvabe(%edi)
acs13:
        call icbld
        Jmp_ acs18
acs14:
        Cmp_ %edi,$k_s__
        jae  acs15
        Sub_ %edi,$k_v__
        Sal_ %edi,$2
        Add_ %edi,$ndabo
        Jmp_ acs18
acs15:
        Mov_ %esi,kvrtn
        ldi_ kvstl
        Sub_ %edi,$k_s__
        jmp  *bsw_0377(,%edi,4)
        Data
bsw_0377:
        .long acs16
        .long acs17
        .long acs19
        .long acs20
        .long acs26
        .long acs27
        .long acs13
        .long acs24
        .long acs25
        Text
acs24:
        Mov_ %edi,$lcase
        Jmp_ acs18
acs25:
        Mov_ %edi,$ucase
        Jmp_ acs18
acs26:
        Mov_ %edx,kvstn
        Jmp_ acs28
acs27:
        Mov_ %edx,kvlst
acs28:
        call filnm
        Jmp_ acs17
acs16:
        Mov_ %esi,kvalp
acs17:
        Mov_ %edi,%esi
acs18:
        Mov_ _rc_,$0
        ret
acs19:
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jl   acs29
        Mov_ %ecx,stmcs
        Sub_ %ecx,stmct
        ldi_ %ecx
        Mov_ %eax,kvstl
        adi_
acs29:
        Mov_ %eax,kvstc
        sbi_
        Jmp_ acs13
acs20:
        Mov_ %edi,r_etx
        Jmp_ acs18
acs21:
        Mov_ %ecx,$rilen
        call alocs
        call sysri
        Dec_ _rc_
        js   call_203
        Dec_ _rc_
        jns  ppm_0378
        Jmp_ acs03
ppm_0378:
call_203:
        Jmp_ acs07
acs22:
        Mov_ _dnamp,%edi
        Mov_ _rc_,$202
        Jmp_ err_
acs23:
        Mov_ _dnamp,%edi
        Mov_ _rc_,$203
        Jmp_ err_
acomp:
        pop  prc_+4*0
        call arith
        Dec_ _rc_
        js   call_204
        Dec_ _rc_
        jns  ppm_0379
        Jmp_ acmp7
ppm_0379:
        Dec_ _rc_
        jns  ppm_0380
        Jmp_ acmp8
ppm_0380:
        Dec_ _rc_
        jns  ppm_0381
        Jmp_ acmp4
ppm_0381:
call_204:
        Mov_ %eax,4(%esi)
        sbi_
        iov_ acmp3
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jl   acmp5
        Mov_ %eax,reg_ia
        or   %eax,%eax
        je   acmp2
acmp1:
        Mov_ _rc_,$5
        Mov_ %eax,prc_+4*0
        Jmp_ *%eax
acmp2:
        Mov_ _rc_,$4
        Mov_ %eax,prc_+4*0
        Jmp_ *%eax
acmp3:
        ldi_ 4(%esi)
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jl   acmp1
        Jmp_ acmp5
acmp4:
        Mov_ %eax,%esi
        Add_ %eax,(cfp_b*rcval)
        call sbr_
        rov_ acmp6
        call cpr_
        movb reg_fl,%al
        or   %al,%al
        jg   acmp1
        call cpr_
        movb reg_fl,%al
        or   %al,%al
        je   acmp2
acmp5:
        Mov_ _rc_,$3
        Mov_ %eax,prc_+4*0
        Jmp_ *%eax
acmp6:
        Mov_ %eax,%esi
        Add_ %eax,(cfp_b*rcval)
        call ldr_
        call cpr_
        movb reg_fl,%al
        or   %al,%al
        jl   acmp1
        Jmp_ acmp5
acmp7:
        Mov_ _rc_,$1
        Mov_ %eax,prc_+4*0
        Jmp_ *%eax
acmp8:
        Mov_ _rc_,$2
        Mov_ %eax,prc_+4*0
        Jmp_ *%eax
alloc:
aloc1:
        Mov_ %edi,_dnamp
        Add_ %edi,%ecx
        jc   aloc2
        Cmp_ %edi,dname
        ja   aloc2
        Mov_ _dnamp,%edi
        Sub_ %edi,%ecx
        ret
aloc2:
        Mov_ allsv,%ebx
alc2a:
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        call gbcol
        Mov_ %ebx,%edi
aloc3:
        Mov_ %edi,_dnamp
        Add_ %edi,%ecx
        jc   alc3a
        Cmp_ %edi,dname
        jb   aloc4
alc3a:
        call sysmm
        Sal_ %edi,$2
        Add_ dname,%edi
        or   %edi,%edi
        jnz  aloc3
        Xor_ %eax,%eax
        Cmp_ dnams,%eax
        jz   alc3b
        Xor_ %eax,%eax
        Mov_ dnams,%eax
        Jmp_ alc2a
alc3b:
        Mov_ %eax,rsmem
        Add_ dname,%eax
        Xor_ %eax,%eax
        Mov_ rsmem,%eax
        Inc_ errft
        Mov_ _rc_,$204
        Jmp_ err_
aloc4:
        sti_ allia
        Mov_ dnams,%ebx
        Mov_ %ebx,dname
        Sub_ %ebx,_dnamp
        Sar_ %ebx,$2
        ldi_ %ebx
        Mov_ %eax,alfsf
        mli_
        iov_ aloc5
        Mov_ %ebx,dname
        Sub_ %ebx,_dnamb
        Sar_ %ebx,$2
        Mov_ aldyn,%ebx
        Mov_ %eax,aldyn
        sbi_
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jg   aloc5
        call sysmm
        Sal_ %edi,$2
        Add_ dname,%edi
aloc5:
        ldi_ allia
        Mov_ %ebx,allsv
        Jmp_ aloc1
alocs:
        Cmp_ %ecx,kvmxl
        ja   alcs2
        Mov_ %edx,%ecx
        mov  %ecx,ctbw_r
        movl $scsi_,ctbw_v
        call ctb_
        movl ctbw_r,%ecx
        Mov_ %edi,_dnamp
        Add_ %edi,%ecx
        jc   alcs0
        Cmp_ %edi,dname
        jb   alcs1
alcs0:
        Xor_ %eax,%eax
        Mov_ %edi,%eax
        call alloc
        Add_ %edi,%ecx
alcs1:
        Mov_ _dnamp,%edi
        Sub_ %edi,$4
        Xor_ %eax,%eax
        Mov_ (%edi),%eax
        Sub_ %ecx,$cfp_b
        Sub_ %edi,%ecx
        Mov_ (%edi),$_b_scl
        Mov_ 4(%edi),%edx
        ret
alcs2:
        Mov_ _rc_,$205
        Jmp_ err_
alost:
alst1:
        Mov_ %edi,_state
        Add_ %edi,%ecx
        jc   alst2
        Cmp_ %edi,_dnamb
        jae  alst2
        Mov_ _state,%edi
        Sub_ %edi,%ecx
        ret
alst2:
        Mov_ alsta,%ecx
        Cmp_ %ecx,$4*e_sts
        jae  alst3
        Mov_ %ecx,$4*e_sts
alst3:
        call alloc
        Mov_ _dnamp,%edi
        Mov_ %ebx,%ecx
        call gbcol
        Mov_ dnams,%edi
        Mov_ %ecx,alsta
        Jmp_ alst1
arith:
        pop  prc_+4*1
        pop  %esi
        pop  %edi
        Mov_ %ecx,(%esi)
        Cmp_ %ecx,$_b_icl
        je   arth1
        Cmp_ %ecx,$b_rcl
        je   arth4
        push %edi
        Mov_ %edi,%esi
        call gtnum
        Dec_ _rc_
        js   call_205
        Dec_ _rc_
        jns  ppm_0382
        Jmp_ arth6
ppm_0382:
call_205:
        Mov_ %esi,%edi
        Mov_ %ecx,(%esi)
        pop  %edi
        Cmp_ %ecx,$b_rcl
        je   arth4
arth1:
        Cmp_ (%edi),$_b_icl
        jne  arth3
arth2:
        ldi_ 4(%edi)
        Mov_ _rc_,$0
        Mov_ %eax,prc_+4*1
        Jmp_ *%eax
arth3:
        call gtnum
        Dec_ _rc_
        js   call_206
        Dec_ _rc_
        jns  ppm_0383
        Jmp_ arth7
ppm_0383:
call_206:
        Cmp_ %ecx,$_b_icl
        je   arth2
        push %edi
        ldi_ 4(%esi)
        call itr_
        call rcbld
        Mov_ %esi,%edi
        pop  %edi
        Jmp_ arth5
arth4:
        Cmp_ (%edi),$b_rcl
        je   arth5
        call gtrea
        Dec_ _rc_
        js   call_207
        Dec_ _rc_
        jns  ppm_0384
        Jmp_ arth7
ppm_0384:
call_207:
arth5:
        Mov_ %eax,%edi
        Add_ %eax,(cfp_b*rcval)
        call ldr_
        Mov_ _rc_,$3
        Mov_ %eax,prc_+4*1
        Jmp_ *%eax
arth6:
        Add_ %esp,$cfp_b
        Mov_ _rc_,$2
        Mov_ %eax,prc_+4*1
        Jmp_ *%eax
arth7:
        Mov_ _rc_,$1
        Mov_ %eax,prc_+4*1
        Jmp_ *%eax
asign:
asg01:
        Add_ %esi,%ecx
        Mov_ %edi,(%esi)
        Cmp_ (%edi),$b_trt
        je   asg02
        Mov_ (%esi),%ebx
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        Mov_ _rc_,$0
        ret
asg02:
        Sub_ %esi,%ecx
        Cmp_ %edi,$trbkv
        je   asg14
        Cmp_ %edi,$trbev
        jne  asg04
        Mov_ %edi,4(%esi)
        push %ebx
        Mov_ %ebx,$num01
        call evalx
        Dec_ _rc_
        js   call_208
        Dec_ _rc_
        jns  ppm_0385
        Jmp_ asg03
ppm_0385:
call_208:
        pop  %ebx
        Jmp_ asg01
asg03:
        Add_ %esp,$cfp_b
        Mov_ _rc_,$1
        ret
asg04:
        push %edi
asg05:
        Mov_ %edx,%edi
        Mov_ %edi,8(%edi)
        Cmp_ (%edi),$b_trt
        je   asg05
        Mov_ %edi,%edx
        Mov_ 8(%edi),%ebx
        pop  %edi
asg06:
        Mov_ %ebx,4(%edi)
        Cmp_ %ebx,$trtvl
        je   asg08
        Cmp_ %ebx,$trtou
        je   asg10
asg07:
        Mov_ %edi,8(%edi)
        Cmp_ (%edi),$b_trt
        je   asg06
        Mov_ _rc_,$0
        ret
asg08:
        Xor_ %eax,%eax
        Cmp_ kvtra,%eax
        jz   asg07
        Dec_ kvtra
        Xor_ %eax,%eax
        Cmp_ 16(%edi),%eax
        jz   asg09
        call trxeq
        Jmp_ asg07
asg09:
        call prtsn
        call prtnv
        Jmp_ asg07
asg10:
        Xor_ %eax,%eax
        Cmp_ kvoup,%eax
        jz   asg07
asg1b:
        Mov_ %esi,%edi
        Mov_ %edi,8(%edi)
        Cmp_ (%edi),$b_trt
        je   asg1b
        Mov_ %edi,%esi
        push 8(%edi)
        call gtstg
        Dec_ _rc_
        js   call_209
        Dec_ _rc_
        jns  ppm_0386
        Jmp_ asg12
ppm_0386:
call_209:
asg11:
        Mov_ %ecx,16(%esi)
        or   %ecx,%ecx
        jz   asg13
asg1a:
        call sysou
        Dec_ _rc_
        js   call_210
        Dec_ _rc_
        jns  ppm_0387
        Mov_ _rc_,$206
        Jmp_ err_
ppm_0387:
        Dec_ _rc_
        jns  ppm_0388
        Mov_ _rc_,$207
        Jmp_ err_
ppm_0388:
call_210:
        Mov_ _rc_,$0
        ret
asg12:
        call dtype
        Jmp_ asg11
asg13:
        Cmp_ 12(%esi),$v_ter
        je   asg1a
        Inc_ %ecx
        Jmp_ asg1a
asg14:
        Mov_ %esi,8(%esi)
        Cmp_ %esi,$k_etx
        je   asg19
        Mov_ %edi,%ebx
        call gtint
        Dec_ _rc_
        js   call_211
        Dec_ _rc_
        jns  ppm_0389
        Mov_ _rc_,$208
        Jmp_ err_
ppm_0389:
call_211:
        ldi_ 4(%edi)
        Cmp_ %esi,$k_stl
        je   asg16
        sti_ %eax
        or   %eax,%eax
        js   asg18
        sti_ %ecx
        Cmp_ %ecx,mxlen
        ja   asg18
        Cmp_ %esi,$k_ert
        je   asg17
        Cmp_ %esi,$k_pfl
        je   asg21
        Cmp_ %esi,$k_mxl
        je   asg24
        Cmp_ %esi,$k_fls
        je   asg26
        Cmp_ %esi,$k_p__
        jb   asg15
        Mov_ _rc_,$209
        Jmp_ err_
asg15:
        Mov_ kvabe(%esi),%ecx
        Mov_ _rc_,$0
        ret
asg16:
        Mov_ %eax,kvstl
        sbi_
        Mov_ %eax,kvstc
        adi_
        sti_ kvstc
        ldi_ kvstl
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jl   asg25
        Mov_ %ecx,stmcs
        Sub_ %ecx,stmct
        ldi_ %ecx
        ngi_
        Mov_ %eax,kvstc
        adi_
        sti_ kvstc
asg25:
        ldi_ 4(%edi)
        sti_ kvstl
        call stgcc
        Mov_ _rc_,$0
        ret
asg17:
        Cmp_ %ecx,$nini9
        jbe  error
asg18:
        Mov_ _rc_,$210
        Jmp_ err_
asg19:
        push %ebx
        call gtstg
        Dec_ _rc_
        js   call_212
        Dec_ _rc_
        jns  ppm_0390
        Mov_ _rc_,$211
        Jmp_ err_
ppm_0390:
call_212:
        Mov_ r_etx,%edi
        Mov_ _rc_,$0
        ret
asg21:
        Cmp_ %ecx,$num02
        ja   asg18
        or   %ecx,%ecx
        jz   asg15
        Xor_ %eax,%eax
        Cmp_ pfdmp,%eax
        jz   asg22
        Cmp_ %ecx,pfdmp
        je   asg23
        Mov_ _rc_,$268
        Jmp_ err_
asg22:
        Mov_ pfdmp,%ecx
asg23:
        Mov_ kvpfl,%ecx
        call stgcc
        call systm
        sti_ pfstm
        Mov_ _rc_,$0
        ret
asg24:
        Cmp_ %ecx,$mnlen
        jae  asg15
        Mov_ _rc_,$287
        Jmp_ err_
asg26:
        or   %ecx,%ecx
        jnz  asg15
        Mov_ _rc_,$274
        Jmp_ err_
asinp:
        Add_ %esi,%ecx
        Mov_ %edi,(%esi)
        Cmp_ (%edi),$b_trt
        je   asnp1
        Mov_ (%esi),%ebx
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        Mov_ _rc_,$0
        ret
asnp1:
        Sub_ %esi,%ecx
        push pmssl
        push _pmhbs
        push r_pms
        push pmdfl
        call asign
        Dec_ _rc_
        js   call_213
        Dec_ _rc_
        jns  ppm_0391
        Jmp_ asnp2
ppm_0391:
call_213:
        pop  pmdfl
        pop  r_pms
        pop  _pmhbs
        pop  pmssl
        Mov_ _rc_,$0
        ret
asnp2:
        pop  pmdfl
        pop  r_pms
        pop  _pmhbs
        pop  pmssl
        Mov_ _rc_,$1
        ret
blkln:
        Mov_ %esi,%ecx
        Dec_ %esi
        mov  (%esi),%al
        movzbl %al,%esi
        Cmp_ %esi,$bl___
        jge  bln00
        jmp  *bsw_0392(,%esi,4)
        Data
bsw_0392:
        .long bln01
        .long bln12
        .long bln12
        .long bln07
        .long bln03
        .long bln02
        .long bln03
        .long bln04
        .long bln09
        .long bln10
        .long bln02
        .long bln01
        .long bln01
        .long bln00
        .long bln00
        .long bln00
        .long bln08
        .long bln05
        .long bln00
        .long bln00
        .long bln00
        .long bln06
        .long bln01
        .long bln01
        .long bln03
        .long bln05
        .long bln03
        .long bln01
        .long bln04
        Text
bln00:
        Mov_ %ecx,4(%edi)
        ret
bln01:
        Mov_ %ecx,8(%edi)
        ret
bln02:
        Mov_ %ecx,$4*num02
        ret
bln03:
        Mov_ %ecx,$4*num03
        ret
bln04:
        Mov_ %ecx,$4*num04
        ret
bln05:
        Mov_ %ecx,$4*num05
        ret
bln06:
        Mov_ %ecx,$4*ctsi_
        ret
bln07:
        Mov_ %ecx,$4*icsi_
        ret
bln08:
        Mov_ %esi,8(%edi)
        Mov_ %ecx,12(%esi)
        ret
bln09:
        Mov_ %ecx,$4*rcsi_
        ret
bln10:
        Mov_ %ecx,4(%edi)
        mov  %ecx,ctbw_r
        movl $scsi_,ctbw_v
        call ctb_
        movl ctbw_r,%ecx
        ret
bln12:
        Mov_ %ecx,12(%edi)
        ret
copyb:
        pop  prc_+4*2
        Mov_ %edi,(%esp)
        Cmp_ %edi,$nulls
        je   cop10
        Mov_ %ecx,(%edi)
        Mov_ %ebx,%ecx
        call blkln
        Mov_ %esi,%edi
        call alloc
        Mov_ (%esp),%edi
        Sar_ %ecx,$2
        rep  movsl
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        Mov_ %edi,(%esp)
        Cmp_ %ebx,$b_tbt
        je   cop05
        Cmp_ %ebx,$b_vct
        je   cop01
        Cmp_ %ebx,$b_pdt
        je   cop01
        Cmp_ %ebx,$b_art
        jne  cop10
        Add_ %edi,12(%edi)
        Jmp_ cop02
cop01:
        Add_ %edi,$4*pdfld
cop02:
        Mov_ %esi,(%edi)
cop03:
        Cmp_ (%esi),$b_trt
        jne  cop04
        Mov_ %esi,8(%esi)
        Jmp_ cop03
cop04:
        Mov_ %eax,%esi
        stosl
        Cmp_ %edi,_dnamp
        jne  cop02
        Jmp_ cop09
cop05:
        Xor_ %eax,%eax
        Mov_ 4(%edi),%eax
        Mov_ %ecx,$4*tesi_
        Mov_ %edx,$4*tbbuk
cop06:
        Mov_ %edi,(%esp)
        Cmp_ %edx,8(%edi)
        je   cop09
        Mov_ %ebx,%edx
        Sub_ %ebx,$4*tenxt
        Add_ %edi,%ebx
        Add_ %edx,$cfp_b
cop07:
        Mov_ %esi,12(%edi)
        Mov_ %eax,(%esp)
        Mov_ 12(%edi),%eax
        Cmp_ (%esi),$b_tbt
        je   cop06
        Sub_ %edi,%ebx
        push %edi
        Mov_ %ecx,$4*tesi_
        call alloc
        push %edi
        Sar_ %ecx,$2
        rep  movsl
        pop  %edi
        pop  %esi
        Add_ %esi,%ebx
        Mov_ 12(%esi),%edi
        Mov_ %esi,%edi
cop08:
        Mov_ %esi,8(%esi)
        Cmp_ (%esi),$b_trt
        je   cop08
        Mov_ 8(%edi),%esi
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Jmp_ cop07
cop09:
        pop  %edi
        Mov_ _rc_,$0
        Mov_ %eax,prc_+4*2
        Jmp_ *%eax
cop10:
        Mov_ _rc_,$1
        Mov_ %eax,prc_+4*2
        Jmp_ *%eax
cdgcg:
        Mov_ %esi,12(%edi)
        Mov_ %edi,16(%edi)
        Cmp_ %esi,$opdvd
        je   cdgc2
        call cdgnm
cdgc1:
        Mov_ %ecx,%esi
        call cdwrd
        ret
cdgc2:
        call cdgvl
        Jmp_ cdgc1
cdgex:
        Cmp_ (%esi),$b_vr_
        jb   cdgx1
        Mov_ %ecx,$4*sesi_
        call alloc
        Mov_ (%edi),$b_sel
        Mov_ 4(%edi),%esi
        ret
cdgx1:
        Mov_ %edi,%esi
        push %edx
        Mov_ %esi,cwcof
        or   %ecx,%ecx
        jz   cdgx2
        Mov_ %ecx,(%edi)
        Cmp_ %ecx,$b_cmt
        jne  cdgx2
        Cmp_ 8(%edi),$c__nm
        jae  cdgx2
        call cdgnm
        Mov_ %ecx,$ornm_
        Jmp_ cdgx3
cdgx2:
        call cdgvl
        Mov_ %ecx,$orvl_
cdgx3:
        call cdwrd
        call exbld
        pop  %edx
        ret
cdgnm:
        push %esi
        push %ebx
        chk_
        or   %eax,%eax
        jne  sec06
        Mov_ %ecx,(%edi)
        Cmp_ %ecx,$b_cmt
        je   cgn04
        Cmp_ %ecx,$b_vr_
        ja   cgn02
cgn01:
        Mov_ _rc_,$212
        Jmp_ err_
cgn02:
        Mov_ %ecx,$olvn_
        call cdwrd
        Mov_ %ecx,%edi
        call cdwrd
cgn03:
        pop  %ebx
        pop  %esi
        ret
cgn04:
        Mov_ %esi,%edi
        Mov_ %edi,8(%edi)
        Cmp_ %edi,$c__nm
        jae  cgn01
        jmp  *bsw_0393(,%edi,4)
        Data
bsw_0393:
        .long cgn05
        .long cgn08
        .long cgn09
        .long cgn10
        .long cgn11
        .long cgn08
        .long cgn08
        Text
cgn05:
        Mov_ %ebx,$4*cmopn
cgn06:
        call cmgen
        Mov_ %edx,4(%esi)
        Cmp_ %ebx,%edx
        jb   cgn06
        Mov_ %ecx,$oaon_
        Cmp_ %edx,$4*cmar1
        je   cgn07
        Mov_ %ecx,$oamn_
        call cdwrd
        Mov_ %ecx,%edx
        Sar_ %ecx,$2
        Sub_ %ecx,$cmvls
cgn07:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %edx,%eax
        call cdwrd
        Jmp_ cgn03
cgn08:
        Mov_ %edi,%esi
        call cdgvl
        Mov_ %ecx,$ofne_
        Jmp_ cgn07
cgn09:
        Mov_ %edi,16(%esi)
        Cmp_ (%edi),$b_vr_
        ja   cgn02
        Mov_ %esi,%edi
        Mov_ %ecx,$num01
        call cdgex
        Mov_ %ecx,$olex_
        call cdwrd
        Mov_ %ecx,%edi
        call cdwrd
        Jmp_ cgn03
cgn10:
        Mov_ %edi,16(%esi)
        call cdgvl
        Mov_ %ecx,$oinn_
        Jmp_ cgn12
cgn11:
        Mov_ %edi,16(%esi)
        call cdgnm
        Mov_ %ecx,$okwn_
cgn12:
        call cdwrd
        Jmp_ cgn03
cdgvl:
        Mov_ %ecx,(%edi)
        Cmp_ %ecx,$b_cmt
        je   cgv01
        Cmp_ %ecx,$b_vra
        jb   cgv00
        Xor_ %eax,%eax
        Cmp_ 28(%edi),%eax
        jnz  cgvl0
        push %edi
        Mov_ %edi,32(%edi)
        Mov_ %ecx,0(%edi)
        pop  %edi
        And_ %ecx,btkwv
        Cmp_ %ecx,btkwv
        je   cgv00
cgvl0:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %edx,%eax
cgv00:
        Mov_ %ecx,%edi
        call cdwrd
        ret
cgv01:
        push %ebx
        push %esi
        push %edx
        push cwcof
        chk_
        or   %eax,%eax
        jne  sec06
        Mov_ %esi,%edi
        Mov_ %edi,8(%edi)
        Mov_ %edx,cswno
        Cmp_ %edi,$c_pr_
        jbe  cgv02
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %edx,%eax
cgv02:
        jmp  *bsw_0394(,%edi,4)
        Data
bsw_0394:
        .long cgv03
        .long cgv05
        .long cgv14
        .long cgv31
        .long cgv27
        .long cgv29
        .long cgv30
        .long cgv18
        .long cgv19
        .long cgv18
        .long cgv24
        .long cgv24
        .long cgv27
        .long cgv26
        .long cgv21
        .long cgv31
        .long cgv28
        .long cgv15
        .long cgv18
        Text
cgv03:
        Mov_ %ebx,$4*cmopn
cgv04:
        call cmgen
        Mov_ %edx,4(%esi)
        Cmp_ %ebx,%edx
        jb   cgv04
        Mov_ %ecx,$oaov_
        Cmp_ %edx,$4*cmar1
        je   cgv32
        Mov_ %ecx,$oamv_
        call cdwrd
        Mov_ %ecx,%edx
        Sub_ %ecx,$4*cmvls
        Sar_ %ecx,$2
        Jmp_ cgv32
cgv05:
        Mov_ %ebx,$4*cmvls
cgv06:
        Cmp_ %ebx,4(%esi)
        je   cgv07
        call cmgen
        Jmp_ cgv06
cgv07:
        Sub_ %ebx,$4*cmvls
        Sar_ %ebx,$2
        Mov_ %edi,12(%esi)
        Xor_ %eax,%eax
        Cmp_ 28(%edi),%eax
        jnz  cgv12
        Mov_ %esi,32(%edi)
        Mov_ %ecx,0(%esi)
        And_ %ecx,btffc
        or   %ecx,%ecx
        jz   cgv12
        Mov_ %ecx,0(%esi)
        And_ %ecx,btpre
        or   %ecx,%ecx
        jnz  cgv08
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %edx,%eax
cgv08:
        Mov_ %esi,20(%edi)
        Mov_ %ecx,4(%esi)
        Cmp_ %ecx,%ebx
        je   cgv11
        Cmp_ %ecx,%ebx
        ja   cgv09
        Sub_ %ebx,%ecx
        Mov_ %ecx,$opop_
        Jmp_ cgv10
cgv09:
        Sub_ %ecx,%ebx
        Mov_ %ebx,%ecx
        Mov_ %ecx,$nulls
cgv10:
        call cdwrd
        Dec_ %ebx
        jnz  cgv10
cgv11:
        Mov_ %ecx,%esi
        Jmp_ cgv36
cgv12:
        Mov_ %ecx,$ofns_
        Cmp_ %ebx,$num01
        je   cgv13
        Mov_ %ecx,$ofnc_
        call cdwrd
        Mov_ %ecx,%ebx
cgv13:
        call cdwrd
        Mov_ %ecx,%edi
        Jmp_ cgv32
cgv14:
        Mov_ %esi,16(%esi)
        Xor_ %eax,%eax
        Mov_ %ecx,%eax
        call cdgex
        Mov_ %ecx,%edi
        call cdwrd
        Jmp_ cgv34
cgv15:
        Xor_ %eax,%eax
        push %eax
        Xor_ %eax,%eax
        push %eax
        Mov_ %ebx,$4*cmvls
        Mov_ %ecx,$osla_
cgv16:
        call cdwrd
        Mov_ %eax,cwcof
        Mov_ (%esp),%eax
        call cdwrd
        call cmgen
        Mov_ %ecx,$oslb_
        call cdwrd
        Mov_ %ecx,4(%esp)
        Mov_ %eax,cwcof
        Mov_ 4(%esp),%eax
        call cdwrd
        Mov_ %edi,(%esp)
        Add_ %edi,r_ccb
        Mov_ %eax,cwcof
        Mov_ (%edi),%eax
        Mov_ %ecx,$oslc_
        Mov_ %edi,%ebx
        Add_ %edi,$cfp_b
        Cmp_ %edi,4(%esi)
        jb   cgv16
        Mov_ %ecx,$osld_
        call cdwrd
        call cmgen
        Add_ %esp,$cfp_b
        pop  %edi
cgv17:
        Add_ %edi,r_ccb
        Mov_ %ecx,(%edi)
        Mov_ %eax,cwcof
        Mov_ (%edi),%eax
        Mov_ %edi,%ecx
        or   %ecx,%ecx
        jnz  cgv17
        Jmp_ cgv33
cgv18:
        Mov_ %edi,20(%esi)
        call cdgvl
cgv19:
        Mov_ %edi,16(%esi)
        call cdgvl
cgv20:
        Mov_ %ecx,12(%esi)
        Jmp_ cgv36
cgv21:
        Mov_ %edi,20(%esi)
        Cmp_ (%edi),$b_vr_
        jb   cgv22
        Mov_ %edi,16(%esi)
        call cdgvl
        Mov_ %ecx,20(%esi)
        Add_ %ecx,$4*vrsto
        Jmp_ cgv32
cgv22:
        call expap
        Dec_ _rc_
        js   call_214
        Dec_ _rc_
        jns  ppm_0395
        Jmp_ cgv23
ppm_0395:
call_214:
        Mov_ %eax,16(%edi)
        Mov_ 20(%esi),%eax
        Mov_ %edi,20(%edi)
        call cdgnm
        Mov_ %edi,20(%esi)
        call cdgvl
        Mov_ %ecx,$opmn_
        call cdwrd
        Mov_ %edi,16(%esi)
        call cdgvl
        Mov_ %ecx,$orpl_
        Jmp_ cgv32
cgv23:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %edx,%eax
        call cdgnm
        Jmp_ cgv31
cgv24:
        Mov_ %edi,20(%esi)
        Cmp_ (%edi),$b_cmt
        jne  cgv18
        Mov_ %ebx,8(%edi)
        Cmp_ %ebx,$c_int
        je   cgv25
        Cmp_ %ebx,$c_neg
        je   cgv25
        Cmp_ %ebx,$c_fnc
        jne  cgv18
        Mov_ %edi,12(%edi)
        Xor_ %eax,%eax
        Cmp_ 28(%edi),%eax
        jnz  cgv18
        Mov_ %edi,32(%edi)
        Mov_ %ecx,0(%edi)
        And_ %ecx,btprd
        or   %ecx,%ecx
        jz   cgv18
cgv25:
        Mov_ %edi,20(%esi)
        call cdgvl
        Mov_ %ecx,$opop_
        call cdwrd
        Mov_ %edi,16(%esi)
        call cdgvl
        Jmp_ cgv33
cgv26:
        Mov_ %edi,20(%esi)
        call cdgvl
cgv27:
        Mov_ %edi,16(%esi)
        call cdgnm
        Mov_ %edi,12(%esi)
        Cmp_ (%edi),$o_kwv
        jne  cgv20
        or   %edx,%edx
        jnz  cgv20
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %edx,%eax
        Mov_ %edi,16(%esi)
        Xor_ %eax,%eax
        Cmp_ 28(%edi),%eax
        jnz  cgv20
        Mov_ %edi,32(%edi)
        Mov_ %ecx,0(%edi)
        And_ %ecx,btckw
        or   %ecx,%ecx
        jz   cgv20
        Xor_ %eax,%eax
        Mov_ %edx,%eax
        Jmp_ cgv20
cgv28:
        Mov_ %ecx,$onta_
        call cdwrd
        Mov_ %ebx,cwcof
        call cdwrd
        Mov_ %edi,16(%esi)
        call cdgvl
        Mov_ %ecx,$ontb_
        call cdwrd
        Mov_ %edi,%ebx
        Add_ %edi,r_ccb
        Mov_ %eax,cwcof
        Mov_ (%edi),%eax
        Mov_ %ecx,$ontc_
        Jmp_ cgv32
cgv29:
        Mov_ %edi,20(%esi)
        call cdgvl
cgv30:
        Mov_ %ebx,$c_uo_
        Sub_ %ebx,8(%esi)
        Mov_ %edi,16(%esi)
        call cdgvl
        Mov_ %edi,12(%esi)
        Mov_ %edi,0(%edi)
        Sal_ %edi,$2
        Add_ %edi,$r_uba
        Sub_ %edi,$4*vrfnc
        Jmp_ cgv12
cgv31:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %edx,%eax
        Jmp_ cgv19
cgv32:
        call cdwrd
cgv33:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %edx,%eax
cgv34:
        Add_ %esp,$cfp_b
        pop  %ecx
        pop  %esi
        pop  %ebx
        or   %edx,%edx
        jnz  cgv35
        Mov_ %edx,%ecx
cgv35:
        ret
cgv36:
        call cdwrd
        or   %edx,%edx
        jnz  cgv34
        Mov_ %ecx,$orvl_
        call cdwrd
        Mov_ %esi,(%esp)
        call exbld
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        call evalx
        Dec_ _rc_
        js   call_215
        Dec_ _rc_
        jns  ppm_0396
        Mov_ _rc_,$299
        Jmp_ err_
ppm_0396:
call_215:
        Mov_ %ecx,(%edi)
        Cmp_ %ecx,$p_aaa
        jb   cgv37
        Mov_ %ecx,$olpt_
        call cdwrd
cgv37:
        Mov_ %ecx,%edi
        call cdwrd
        Xor_ %eax,%eax
        Mov_ %edx,%eax
        Jmp_ cgv34
cdwrd:
        push %edi
        push %ecx
cdwd1:
        Mov_ %edi,r_ccb
        or   %edi,%edi
        jnz  cdwd2
        Mov_ %ecx,$4*e_cbs
        call alloc
        Mov_ (%edi),$b_cct
        Mov_ cwcof,$4*cccod
        Mov_ 4(%edi),%ecx
        Xor_ %eax,%eax
        Mov_ 8(%edi),%eax
        Mov_ r_ccb,%edi
cdwd2:
        Mov_ %ecx,cwcof
        Add_ %ecx,$4*num05
        Cmp_ %ecx,4(%edi)
        jb   cdwd4
        Cmp_ %ecx,mxlen
        jae  cdwd5
        Add_ %ecx,$4*e_cbs
        push %esi
        Mov_ %esi,%edi
        Cmp_ %ecx,mxlen
        jb   cdwd3
        Mov_ %ecx,mxlen
cdwd3:
        call alloc
        Mov_ r_ccb,%edi
        Mov_ %eax,$b_cct
        stosl
        Mov_ %eax,%ecx
        stosl
        Mov_ %eax,8(%esi)
        stosl
        Add_ %esi,$4*ccuse
        Mov_ %ecx,(%esi)
        Sar_ %ecx,$2
        rep  movsl
        pop  %esi
        Jmp_ cdwd1
cdwd4:
        Mov_ %ecx,cwcof
        Add_ %ecx,$cfp_b
        Mov_ cwcof,%ecx
        Mov_ 12(%edi),%ecx
        Sub_ %ecx,$cfp_b
        Add_ %edi,%ecx
        pop  %ecx
        Mov_ (%edi),%ecx
        pop  %edi
        ret
cdwd5:
        Mov_ _rc_,$213
        Jmp_ err_
cmgen:
        Mov_ %edi,%esi
        Add_ %edi,%ebx
        Mov_ %edi,(%edi)
        call cdgvl
        Add_ %ebx,$cfp_b
        ret
cmpil:
        Mov_ %ebx,$cmnen
cmp00:
        Xor_ %eax,%eax
        push %eax
        Dec_ %ebx
        jnz  cmp00
        Mov_ cmpxs,%esp
cmp01:
        Mov_ %ebx,scnpt
        Mov_ scnse,%ebx
        Mov_ %ecx,$ocer_
        call cdwrd
        Cmp_ %ebx,scnil
        jb   cmp04
cmpce:
        Xor_ %eax,%eax
        Mov_ %edi,%eax
        Xor_ %eax,%eax
        Cmp_ cnind,%eax
        jnz  cmpc2
        Cmp_ stage,$stgic
        jne  cmp02
cmpc2:
        call readr
        or   %edi,%edi
        jz   cmp09
        call nexts
        Mov_ %eax,cmpsn
        Mov_ lstsn,%eax
        Mov_ %eax,rdcln
        Mov_ cmpln,%eax
        Xor_ %eax,%eax
        Mov_ scnpt,%eax
        Jmp_ cmp04
cmp02:
        Mov_ %edi,r_cim
        Mov_ %ebx,scnpt
        Add_ %edi,%ebx
        Add_ %edi,$cfp_f
cmp03:
        Mov_ %eax,scnil
        Cmp_ scnpt,%eax
        jae  cmp09
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Inc_ %edi
        Inc_ scnpt
        Cmp_ %edx,$ch_sm
        jne  cmp03
cmp04:
        Mov_ %edi,r_cim
        Mov_ %ebx,scnpt
        Mov_ %ecx,%ebx
        Add_ %edi,%ebx
        Add_ %edi,$cfp_f
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Inc_ %edi
        Cmp_ %edx,$ch_sm
        je   cmp12
        Cmp_ %edx,$ch_as
        je   cmpce
        Cmp_ %edx,$ch_mn
        je   cmp32
        Mov_ %eax,r_cim
        Mov_ r_cmp,%eax
        Mov_ %esi,$cmlab
        Mov_ r_cim,%esi
        Add_ %esi,$cfp_f
#sch s.text wc  s.type 8  s.reg wc
#sch d.text (xl)+  d.type 10  d.reg xl  w 0
        movb %dl,(%esi)
        Inc_ %esi
        Mov_ %edx,$ch_sm
#sch s.text wc  s.type 8  s.reg wc
#sch d.text (xl)  d.type 9  d.reg xl  w 0
        movb %dl,(%esi)
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        Xor_ %eax,%eax
        Mov_ scnpt,%eax
        push scnil
        Mov_ scnil,$num02
        call scane
        pop  scnil
        Mov_ %edx,%esi
        Mov_ %esi,r_cmp
        Mov_ r_cim,%esi
        Mov_ scnpt,%ebx
        Xor_ %eax,%eax
        Cmp_ scnbl,%eax
        jnz  cmp12
        Mov_ %edi,%esi
        Add_ %edi,%ebx
        Add_ %edi,$cfp_f
        Cmp_ %edx,$t_var
        je   cmp06
        Cmp_ %edx,$t_con
        je   cmp06
cmple:
        Mov_ %eax,r_cmp
        Mov_ r_cim,%eax
        Mov_ _rc_,$214
        Jmp_ err_
cmp05:
        Cmp_ %edx,$ch_sm
        je   cmp07
        Inc_ %ecx
        Cmp_ %ecx,scnil
        je   cmp07
cmp06:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Inc_ %edi
        Cmp_ %edx,$ch_ht
        je   cmp07
        Cmp_ %edx,$ch_bl
        jne  cmp05
cmp07:
        Mov_ scnpt,%ecx
        Sub_ %ecx,%ebx
        or   %ecx,%ecx
        jz   cmp12
        Xor_ %eax,%eax
        Mov_ %edi,%eax
        call sbstr
        call gtnvr
        Dec_ _rc_
        js   call_216
        Dec_ _rc_
        jns  ppm_0397
        Mov_ _rc_,$299
        Jmp_ err_
ppm_0397:
call_216:
        Mov_ 36(%esp),%edi
        Xor_ %eax,%eax
        Cmp_ 28(%edi),%eax
        jnz  cmp11
        Cmp_ 32(%edi),$v_end
        jne  cmp11
        Add_ stage,$stgnd
        call scane
        Cmp_ %esi,$t_smc
        je   cmp10
        Cmp_ %esi,$t_var
        jne  cmp08
        Cmp_ 16(%edi),$stndl
        je   cmp08
        Mov_ %eax,16(%edi)
        Mov_ 40(%esp),%eax
        call scane
        Cmp_ %esi,$t_smc
        je   cmp10
cmp08:
        Mov_ _rc_,$215
        Jmp_ err_
cmp09:
        Xor_ %eax,%eax
        Mov_ %edi,%eax
        Add_ stage,$stgnd
        Cmp_ stage,$stgxe
        je   cmp10
        Mov_ _rc_,$216
        Jmp_ err_
cmp10:
        Mov_ %ecx,$ostp_
        call cdwrd
        Jmp_ cmpse
cmp11:
        Cmp_ stage,$stgic
        jne  cmp12
        Cmp_ 16(%edi),$stndl
        je   cmp12
        Xor_ %eax,%eax
        Mov_ 36(%esp),%eax
        Mov_ _rc_,$217
        Jmp_ err_
cmp12:
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        call expan
        Mov_ 0(%esp),%edi
        Xor_ %eax,%eax
        Mov_ 4(%esp),%eax
        Xor_ %eax,%eax
        Mov_ 8(%esp),%eax
        Xor_ %eax,%eax
        Mov_ 12(%esp),%eax
        call scane
        Cmp_ %esi,$t_col
        je   cmp13
        Xor_ %eax,%eax
        Cmp_ cswno,%eax
        jnz  cmp18
        Xor_ %eax,%eax
        Cmp_ 36(%esp),%eax
        jnz  cmp18
        Mov_ %edi,0(%esp)
        Mov_ %ecx,(%edi)
        Cmp_ %ecx,$b_cmt
        je   cmp18
        Cmp_ %ecx,$b_vra
        jae  cmp18
        Mov_ %esi,r_ccb
        Mov_ 12(%esi),$4*cccod
        Mov_ cwcof,$4*cccod
        Inc_ cmpsn
        Jmp_ cmp01
cmp13:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ scngo,%eax
        call scane
        Cmp_ %esi,$t_smc
        je   cmp31
        Cmp_ %esi,$t_sgo
        je   cmp14
        Cmp_ %esi,$t_fgo
        je   cmp16
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ scnrs,%eax
        call scngf
        Xor_ %eax,%eax
        Cmp_ 8(%esp),%eax
        jnz  cmp17
        Mov_ 8(%esp),%edi
        Jmp_ cmp15
cmp14:
        call scngf
        Mov_ 12(%esp),$num01
cmp15:
        Xor_ %eax,%eax
        Cmp_ 4(%esp),%eax
        jnz  cmp17
        Mov_ 4(%esp),%edi
        Jmp_ cmp13
cmp16:
        call scngf
        Mov_ 12(%esp),$num01
        Xor_ %eax,%eax
        Cmp_ 8(%esp),%eax
        jnz  cmp17
        Mov_ 8(%esp),%edi
        Jmp_ cmp13
cmp17:
        Mov_ _rc_,$218
        Jmp_ err_
cmp18:
        Xor_ %eax,%eax
        Mov_ scnse,%eax
        Mov_ %edi,0(%esp)
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Xor_ %eax,%eax
        Mov_ %edx,%eax
        call expap
        Dec_ _rc_
        js   call_217
        Dec_ _rc_
        jns  ppm_0398
        Jmp_ cmp19
ppm_0398:
call_217:
        Mov_ 12(%edi),$opms_
        Mov_ 8(%edi),$c_pmt
cmp19:
        call cdgvl
        Mov_ %edi,4(%esp)
        Mov_ %ecx,%edi
        or   %edi,%edi
        jz   cmp21
        Xor_ %eax,%eax
        Mov_ 32(%esp),%eax
        Cmp_ %edi,_state
        ja   cmp20
        Add_ %ecx,$4*vrtra
        call cdwrd
        Jmp_ cmp22
cmp20:
        Cmp_ %edi,8(%esp)
        je   cmp22
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        call cdgcg
        Jmp_ cmp22
cmp21:
        Mov_ %eax,cwcof
        Mov_ 32(%esp),%eax
        Mov_ %ecx,$ocer_
        call cdwrd
cmp22:
        Mov_ %edi,8(%esp)
        Mov_ %ecx,%edi
        Xor_ %eax,%eax
        Mov_ 24(%esp),%eax
        or   %edi,%edi
        jz   cmp23
        Add_ %ecx,$4*vrtra
        Cmp_ %edi,_state
        jb   cmpse
        Mov_ %ebx,cwcof
        Mov_ %ecx,$ogof_
        call cdwrd
        Mov_ %ecx,$ofif_
        call cdwrd
        call cdgcg
        Mov_ %ecx,%ebx
        Mov_ %ebx,$b_cdc
        Jmp_ cmp25
cmp23:
        Mov_ %ecx,$ounf_
        Mov_ %edx,cswfl
        Or_  %edx,12(%esp)
        or   %edx,%edx
        jz   cmpse
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ 24(%esp),%eax
        Mov_ %ecx,$ocer_
cmpse:
        Mov_ %ebx,$b_cds
cmp25:
        Mov_ %edi,r_ccb
        Mov_ %esi,36(%esp)
        or   %esi,%esi
        jz   cmp26
        Xor_ %eax,%eax
        Mov_ 36(%esp),%eax
        Mov_ 16(%esi),%edi
cmp26:
        Mov_ (%edi),%ebx
        Mov_ 16(%edi),%ecx
        Mov_ %esi,%edi
        Mov_ %ebx,12(%edi)
        Mov_ %edx,4(%edi)
        Add_ %esi,%ebx
        Sub_ %edx,%ebx
        Mov_ (%esi),$b_cct
        Mov_ 12(%esi),$4*cccod
        Mov_ cwcof,$4*cccod
        Mov_ 4(%esi),%edx
        Mov_ r_ccb,%esi
        Xor_ %eax,%eax
        Mov_ 8(%esi),%eax
        Mov_ %eax,cmpln
        Mov_ 8(%edi),%eax
        Mov_ %eax,cmpsn
        Mov_ 4(%edi),%eax
        Inc_ cmpsn
        Mov_ %esi,16(%esp)
        Xor_ %eax,%eax
        Cmp_ 20(%esp),%eax
        jz   cmp27
        Mov_ 16(%esi),%edi
cmp27:
        Mov_ %ecx,28(%esp)
        or   %ecx,%ecx
        jz   cmp28
        Add_ %esi,%ecx
        Mov_ (%esi),%edi
        Xor_ %eax,%eax
        Mov_ %esi,%eax
cmp28:
        Mov_ %eax,24(%esp)
        Mov_ 20(%esp),%eax
        Mov_ %eax,32(%esp)
        Mov_ 28(%esp),%eax
        Mov_ 16(%esp),%edi
        Xor_ %eax,%eax
        Cmp_ 40(%esp),%eax
        jnz  cmp29
        Mov_ 40(%esp),%edi
cmp29:
        Cmp_ stage,$stgce
        jb   cmp01
        Xor_ %eax,%eax
        Cmp_ cswls,%eax
        jz   cmp30
        call listr
cmp30:
        Mov_ %edi,40(%esp)
        Add_ %esp,$4*cmnen
        ret
cmp31:
        Mov_ %ebx,8(%esp)
        Or_  %ebx,4(%esp)
        or   %ebx,%ebx
        jnz  cmp18
        Mov_ _rc_,$219
        Jmp_ err_
cmp32:
        Inc_ %ebx
        call cncrd
        Xor_ %eax,%eax
        Mov_ scnse,%eax
        Jmp_ cmpce
cncrd:
        Mov_ scnpt,%ebx
        Mov_ %ecx,$ccnoc
        mov  %ecx,ctbw_r
        movl $0,ctbw_v
        call ctw_
        movl ctbw_r,%ecx
        Mov_ cnswc,%ecx
cnc01:
        Mov_ %eax,scnil
        Cmp_ scnpt,%eax
        jae  cnc09
        Mov_ %edi,r_cim
        Add_ %edi,$cfp_f
        Add_ %edi,scnpt
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wa  d.type 8  d.reg wa  w 0
        Xor_ %ecx,%ecx
        movb (%edi),%cl
        Inc_ %edi
        cmpb %cl,'A'
        jb   flc_0399
        cmpb %cl,'Z'
        ja   flc_0399
        Add_ %cl,$32
flc_0399:
        Cmp_ %ecx,$ch_li
        je   cnc07
cnc0a:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ scncc,%eax
        call scane
        Xor_ %eax,%eax
        Mov_ scncc,%eax
        or   %esi,%esi
        jnz  cnc06
        Mov_ %ecx,$ccnoc
        Cmp_ 4(%edi),%ecx
        jb   cnc08
        Mov_ %esi,%edi
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        call sbstr
        Mov_ %ecx,4(%edi)
        call flstg
        Mov_ cnscc,%edi
        Mov_ %edi,$ccnms
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Mov_ %edx,$cc_nc
cnc02:
        Mov_ %esi,cnscc
        Mov_ %ecx,cnswc
        Jmp_ cnc04
cnc03:
        Add_ %edi,$cfp_b
        Add_ %esi,$cfp_b
cnc04:
        Mov_ %eax,(%edi)
        Cmp_ 8(%esi),%eax
        jnz  cnc05
        Dec_ %ecx
        jnz  cnc03
        Cmp_ %esi,$cc_nc
        jge  cnc08
        jmp  *bsw_0400(,%esi,4)
        Data
bsw_0400:
        .long cnc37
        .long cnc10
        .long cnc08
        .long cnc11
        .long cnc41
        .long cnc12
        .long cnc13
        .long cnc14
        .long cnc15
        .long cnc41
        .long cnc44
        .long cnc16
        .long cnc17
        .long cnc18
        .long cnc19
        .long cnc20
        .long cnc21
        .long cnc22
        .long cnc24
        .long cnc25
        .long cnc27
        .long cnc28
        .long cnc31
        .long cnc32
        .long cnc36
        Text
cnc05:
        Add_ %edi,$cfp_b
        Dec_ %ecx
        jnz  cnc05
        Inc_ %ebx
        Dec_ %edx
        jnz  cnc02
        Jmp_ cnc08
cnc06:
        Mov_ _rc_,$247
        Jmp_ err_
cnc07:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wa  d.type 8  d.reg wa  w 0
        Xor_ %ecx,%ecx
        movb (%edi),%cl
        Inc_ %edi
        cmpb %cl,'A'
        jb   flc_0401
        cmpb %cl,'Z'
        ja   flc_0401
        Add_ %cl,$32
flc_0401:
        Cmp_ %ecx,$ch_ln
        jne  cnc0a
#lch s.text (xr)  s.type 9  s.reg xr
#lch d.text wa  d.type 8  d.reg wa  w 0
        Xor_ %ecx,%ecx
        movb (%edi),%cl
        Cmp_ %ecx,$ch_d0
        jb   cnc0a
        Cmp_ %ecx,$ch_d9
        ja   cnc0a
        Add_ scnpt,$num02
        call scane
        push %edi
        call gtsmi
        Dec_ _rc_
        js   call_218
        Dec_ _rc_
        jns  ppm_0402
        Jmp_ cnc06
ppm_0402:
        Dec_ _rc_
        jns  ppm_0403
        Jmp_ cnc06
ppm_0403:
call_218:
        Mov_ cswin,%edi
cnc08:
        Mov_ %ecx,scnpt
        call scane
        Cmp_ %esi,$t_cma
        je   cnc01
        Mov_ scnpt,%ecx
cnc09:
        ret
cnc10:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ cswdb,%eax
        Jmp_ cnc08
cnc11:
        call sysdm
        Jmp_ cnc09
cnc12:
        Xor_ %eax,%eax
        Cmp_ cswls,%eax
        jz   cnc09
        call prtps
        call listt
        Jmp_ cnc09
cnc13:
        Xor_ %eax,%eax
        Mov_ cswer,%eax
        Jmp_ cnc08
cnc14:
        Xor_ %eax,%eax
        Mov_ cswex,%eax
        Jmp_ cnc08
cnc15:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ cswfl,%eax
        Jmp_ cnc08
cnc16:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ cswls,%eax
        Cmp_ stage,$stgic
        je   cnc08
        Xor_ %eax,%eax
        Mov_ lstpf,%eax
        call listr
        Jmp_ cnc08
cnc17:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ cswer,%eax
        Jmp_ cnc08
cnc18:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ cswex,%eax
        Jmp_ cnc08
cnc19:
        Xor_ %eax,%eax
        Mov_ cswfl,%eax
        Jmp_ cnc08
cnc20:
        Xor_ %eax,%eax
        Mov_ cswls,%eax
        Jmp_ cnc08
cnc21:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ cswno,%eax
        Jmp_ cnc08
cnc22:
        Xor_ %eax,%eax
        Mov_ cswpr,%eax
        Jmp_ cnc08
cnc24:
        Xor_ %eax,%eax
        Mov_ cswno,%eax
        Jmp_ cnc08
cnc25:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ cswpr,%eax
        Jmp_ cnc08
cnc27:
        Xor_ %eax,%eax
        Mov_ cswdb,%eax
        Jmp_ cnc08
cnc28:
        Xor_ %eax,%eax
        Cmp_ cswls,%eax
        jz   cnc09
        call scane
        Mov_ %edx,$num01
        Cmp_ %edi,$t_smc
        je   cnc29
        push %edi
        call gtsmi
        Dec_ _rc_
        js   call_219
        Dec_ _rc_
        jns  ppm_0404
        Jmp_ cnc06
ppm_0404:
        Dec_ _rc_
        jns  ppm_0405
        Jmp_ cnc06
ppm_0405:
call_219:
        or   %edx,%edx
        jnz  cnc29
        Mov_ %edx,$num01
cnc29:
        Add_ lstlc,%edx
        Mov_ %eax,lstnp
        Cmp_ lstlc,%eax
        jb   cnc30
        call prtps
        call listt
        Jmp_ cnc09
cnc30:
        call prtnl
        Dec_ %edx
        jnz  cnc30
        Jmp_ cnc09
cnc31:
        Mov_ cnr_t,$r_stl
        Jmp_ cnc33
cnc32:
        Mov_ r_stl,$nulls
        Mov_ cnr_t,$r_ttl
cnc33:
        Mov_ %edi,$nulls
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ cnttl,%eax
        Mov_ %ebx,$ccofs
        Mov_ %ecx,scnil
        Cmp_ %ecx,%ebx
        jb   cnc34
        Sub_ %ecx,%ebx
        Mov_ %esi,r_cim
        call sbstr
cnc34:
        Mov_ %esi,cnr_t
        Mov_ (%esi),%edi
        Cmp_ %esi,$r_stl
        je   cnc09
        Xor_ %eax,%eax
        Cmp_ precl,%eax
        jnz  cnc09
        Xor_ %eax,%eax
        Cmp_ prich,%eax
        jz   cnc09
        Mov_ %esi,4(%edi)
        Mov_ %ecx,%esi
        or   %esi,%esi
        jz   cnc35
        Add_ %esi,$num10
        Cmp_ %esi,prlen
        ja   cnc09
        Add_ %ecx,$num04
cnc35:
        Mov_ lstpo,%ecx
        Jmp_ cnc09
cnc36:
        call systt
        Jmp_ cnc08
cnc37:
        call scane
        Xor_ %eax,%eax
        Mov_ %edx,%eax
        Cmp_ %esi,$t_smc
        je   cnc38
        push %edi
        call gtsmi
        Dec_ _rc_
        js   call_220
        Dec_ _rc_
        jns  ppm_0406
        Jmp_ cnc06
ppm_0406:
        Dec_ _rc_
        jns  ppm_0407
        Jmp_ cnc06
ppm_0407:
call_220:
cnc38:
        Mov_ kvcas,%edx
        Jmp_ cnc09
cnc41:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ scncc,%eax
        call scane
        Xor_ %eax,%eax
        Mov_ scncc,%eax
        Cmp_ %esi,$t_con
        jne  cnc06
        Cmp_ (%edi),$_b_scl
        jne  cnc06
        Mov_ r_ifn,%edi
        Mov_ %esi,r_inc
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        call tfind
        Dec_ _rc_
        js   call_221
        Dec_ _rc_
        jns  ppm_0408
        Mov_ _rc_,$299
        Jmp_ err_
ppm_0408:
call_221:
        Cmp_ %edi,$inton
        je   cnc09
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %ebx,%eax
        Mov_ %edi,r_ifn
        call trimr
        Mov_ %esi,r_inc
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %ebx,%eax
        call tfind
        Dec_ _rc_
        js   call_222
        Dec_ _rc_
        jns  ppm_0409
        Mov_ _rc_,$299
        Jmp_ err_
ppm_0409:
call_222:
        Mov_ 8(%esi),$inton
        Inc_ cnind
        Mov_ %ecx,cnind
        Cmp_ %ecx,$ccinm
        ja   cnc42
        Mov_ %esi,r_ifa
        Add_ %ecx,$vcvlb
        Sal_ %ecx,$2
        Add_ %esi,%ecx
        Mov_ %eax,r_sfc
        Mov_ (%esi),%eax
        Mov_ %esi,%ecx
        ldi_ rdnln
        call icbld
        Add_ %esi,r_ifl
        Mov_ (%esi),%edi
        Mov_ %ecx,cswin
        Mov_ %esi,r_ifn
        call alocs
        call sysif
        Dec_ _rc_
        js   call_223
        Dec_ _rc_
        jns  ppm_0410
        Jmp_ cnc43
ppm_0410:
call_223:
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        call trimr
        Mov_ r_sfc,%edi
        ldi_ cmpsn
        call icbld
        Mov_ %esi,r_sfn
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %ebx,%eax
        call tfind
        Dec_ _rc_
        js   call_224
        Dec_ _rc_
        jns  ppm_0411
        Mov_ _rc_,$299
        Jmp_ err_
ppm_0411:
call_224:
        Mov_ %eax,r_sfc
        Mov_ 8(%esi),%eax
        Xor_ %eax,%eax
        Mov_ rdnln,%eax
        Cmp_ stage,$stgic
        je   cnc09
        Cmp_ cnind,$num01
        jne  cnc09
        Mov_ %eax,r_cim
        Mov_ r_ici,%eax
        Mov_ %eax,scnpt
        Mov_ cnspt,%eax
        Mov_ %eax,scnil
        Mov_ cnsil,%eax
        Jmp_ cnc09
cnc42:
        Mov_ _rc_,$284
        Jmp_ err_
cnc43:
        Mov_ _dnamp,%edi
        Mov_ _rc_,$285
        Jmp_ err_
cnc44:
        call scane
        Cmp_ %esi,$t_con
        jne  cnc06
        Cmp_ (%edi),$_b_icl
        jne  cnc06
        ldi_ 4(%edi)
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jle  cnc06
        Cmp_ stage,$stgic
        je   cnc45
        sti_ cmpln
        Jmp_ cnc46
cnc45:
        Mov_ %eax,intv1
        sbi_
        sti_ rdnln
cnc46:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ scncc,%eax
        call scane
        Xor_ %eax,%eax
        Mov_ scncc,%eax
        Cmp_ %esi,$t_smc
        je   cnc47
        Cmp_ %esi,$t_con
        jne  cnc06
        Cmp_ (%edi),$_b_scl
        jne  cnc06
        call newfn
        Jmp_ cnc09
cnc47:
        Dec_ scnpt
        Jmp_ cnc09
dffnc:
        Cmp_ (%esi),$b_efc
        jne  dffn1
        Inc_ 12(%esi)
dffn1:
        Mov_ %ecx,%edi
        Mov_ %edi,20(%edi)
        Cmp_ (%edi),$b_efc
        jne  dffn2
        Mov_ %ebx,12(%edi)
        Dec_ %ebx
        Mov_ 12(%edi),%ebx
        or   %ebx,%ebx
        jnz  dffn2
        call sysul
dffn2:
        Mov_ %edi,%ecx
        Mov_ %ecx,%esi
        Cmp_ %edi,$r_yyy
        jb   dffn3
        Xor_ %eax,%eax
        Cmp_ 28(%edi),%eax
        jnz  dffn3
        Mov_ %esi,32(%edi)
        Mov_ %ebx,0(%esi)
        And_ %ebx,btfnc
        or   %ebx,%ebx
        jz   dffn3
        Mov_ _rc_,$248
        Jmp_ err_
dffn3:
        Mov_ 20(%edi),%ecx
        Mov_ %esi,%ecx
        ret
dtach:
        Mov_ dtcnb,%esi
        Add_ %esi,%ecx
        Mov_ dtcnm,%esi
dtch1:
        Mov_ %edi,%esi
dtch2:
        Mov_ %esi,(%esi)
        Cmp_ (%esi),$b_trt
        jne  dtch6
        Mov_ %ecx,4(%esi)
        Cmp_ %ecx,$trtin
        je   dtch3
        Cmp_ %ecx,$trtou
        je   dtch3
        Add_ %esi,$4*trnxt
        Jmp_ dtch1
dtch3:
        Mov_ %eax,8(%esi)
        Mov_ (%edi),%eax
        Mov_ %ecx,%esi
        Mov_ %ebx,%edi
        Mov_ %esi,12(%esi)
        or   %esi,%esi
        jz   dtch5
        Cmp_ (%esi),$b_trt
        jne  dtch5
dtch4:
        Mov_ %edi,%esi
        Mov_ %esi,12(%esi)
        or   %esi,%esi
        jz   dtch5
        Mov_ %edx,8(%esi)
        Add_ %edx,16(%esi)
        Cmp_ %edx,dtcnm
        jne  dtch4
        Mov_ %eax,12(%esi)
        Mov_ 12(%edi),%eax
dtch5:
        Mov_ %esi,%ecx
        Mov_ %edi,%ebx
        Add_ %esi,$4*trval
        Jmp_ dtch2
dtch6:
        Mov_ %edi,dtcnb
        call setvr
        ret
dtype:
        Cmp_ (%edi),$b_pdt
        je   dtyp1
        Mov_ %edi,(%edi)
        Dec_ %edi
        mov  (%edi),%al
        movzbl %al,%edi
        Sal_ %edi,$2
        Mov_ %edi,scnmt(%edi)
        ret
dtyp1:
        Mov_ %edi,8(%edi)
        Mov_ %edi,16(%edi)
        ret
dumpr:
        or   %edi,%edi
        jz   dmp28
        Cmp_ %edi,$num03
        ja   dmp29
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Mov_ dmarg,%edi
        Xor_ %eax,%eax
        Mov_ dnams,%eax
        call gbcol
        call prtpg
        Mov_ %edi,$dmhdv
        call prtst
        call prtnl
        call prtnl
        Xor_ %eax,%eax
        Mov_ dmvch,%eax
        Mov_ %ecx,_hshtb
dmp00:
        Mov_ %edi,%ecx
        Add_ %ecx,$cfp_b
        Sub_ %edi,$4*vrnxt
dmp01:
        Mov_ %edi,24(%edi)
        or   %edi,%edi
        jz   dmp09
        Mov_ %esi,%edi
dmp02:
        Mov_ %esi,8(%esi)
        Cmp_ dmarg,$num03
        je   dmp2a
        Cmp_ %esi,$nulls
        je   dmp01
dmp2a:
        Cmp_ (%esi),$b_trt
        je   dmp02
        Mov_ %edx,%edi
        Add_ %edi,$4*vrsof
        Xor_ %eax,%eax
        Cmp_ 4(%edi),%eax
        jnz  dmp03
        Mov_ %edi,8(%edi)
dmp03:
        Mov_ %ebx,%edi
        Mov_ dmpsv,%ecx
        Mov_ %ecx,$dmvch
dmp04:
        Mov_ dmpch,%ecx
        Mov_ %esi,%ecx
        Mov_ %edi,(%esi)
        or   %edi,%edi
        jz   dmp08
        Add_ %edi,$4*vrsof
        Xor_ %eax,%eax
        Cmp_ 4(%edi),%eax
        jnz  dmp05
        Mov_ %edi,8(%edi)
dmp05:
        Mov_ %esi,%ebx
        Mov_ %ecx,4(%esi)
        Add_ %esi,$cfp_f
        Cmp_ %ecx,4(%edi)
        ja   dmp06
        Add_ %edi,$cfp_f
        repe cmpsb
        Xor_ %esi,%esi
        Xor_ %edi,%esi
        ja   dmp07
        jb   dmp08
        Jmp_ dmp08
dmp06:
        Mov_ %ecx,4(%edi)
        Add_ %edi,$cfp_f
        repe cmpsb
        Xor_ %esi,%esi
        Xor_ %edi,%esi
        ja   dmp07
        jb   dmp08
dmp07:
        Mov_ %esi,dmpch
        Mov_ %ecx,(%esi)
        Jmp_ dmp04
dmp08:
        Mov_ %esi,dmpch
        Mov_ %ecx,dmpsv
        Mov_ %edi,%edx
        Mov_ %eax,(%esi)
        Mov_ 0(%edi),%eax
        Mov_ (%esi),%edi
        Jmp_ dmp01
dmp09:
        Cmp_ %ecx,hshte
        jne  dmp00
dmp10:
        Mov_ %edi,dmvch
        or   %edi,%edi
        jz   dmp11
        Mov_ %eax,(%edi)
        Mov_ dmvch,%eax
        call setvr
        Mov_ %esi,%edi
        Mov_ %ecx,$4*vrval
        call prtnv
        Jmp_ dmp10
dmp11:
        call prtnl
        call prtnl
        Mov_ %edi,$dmhdk
        call prtst
        call prtnl
        call prtnl
        Mov_ %esi,$vdmkw
dmp12:
        lodsl
        Mov_ %edi,%eax
        or   %edi,%edi
        jz   dmp13
        Cmp_ %edi,$num01
        je   dmp12
        Mov_ %ecx,$ch_am
        call prtch
        call prtst
        Mov_ %ecx,4(%edi)
        mov  %ecx,ctbw_r
        movl $svchs,ctbw_v
        call ctb_
        movl ctbw_r,%ecx
        Add_ %edi,%ecx
        Mov_ %eax,(%edi)
        Mov_ dmpkn,%eax
        Mov_ %edi,$tmbeb
        call prtst
        Mov_ dmpsv,%esi
        Mov_ %esi,$dmpkb
        Mov_ (%esi),$b_kvt
        Mov_ 4(%esi),$trbkv
        Mov_ %ecx,$4*kvvar
        call acess
        Dec_ _rc_
        js   call_225
        Dec_ _rc_
        jns  ppm_0412
        Mov_ _rc_,$299
        Jmp_ err_
ppm_0412:
call_225:
        call prtvl
        call prtnl
        Mov_ %esi,dmpsv
        Jmp_ dmp12
dmp13:
        Cmp_ dmarg,$num01
        je   dmp27
        Mov_ %edi,_dnamb
dmp14:
        Cmp_ %edi,_dnamp
        je   dmp27
        Mov_ %ecx,(%edi)
        Cmp_ %ecx,$b_vct
        je   dmp16
        Cmp_ %ecx,$b_art
        je   dmp17
        Cmp_ %ecx,$b_pdt
        je   dmp18
        Cmp_ %ecx,$b_tbt
        je   dmp19
dmp15:
        call blkln
        Add_ %edi,%ecx
        Jmp_ dmp14
dmp16:
        Mov_ %ebx,$4*vcvls
        Jmp_ dmp19
dmp17:
        Mov_ %ebx,12(%edi)
        Add_ %ebx,$cfp_b
        Jmp_ dmp19
dmp18:
        Mov_ %ebx,$4*pdfld
dmp19:
        Xor_ %eax,%eax
        Cmp_ 4(%edi),%eax
        jz   dmp15
        call blkln
        Mov_ %esi,%edi
        Mov_ dmpsv,%ecx
        Mov_ %ecx,%ebx
        call prtnl
        Mov_ dmpsa,%ecx
        call prtvl
        Mov_ %ecx,dmpsa
        call prtnl
        Cmp_ (%edi),$b_tbt
        je   dmp22
        Sub_ %ecx,$cfp_b
dmp20:
        Mov_ %edi,%esi
        Add_ %ecx,$cfp_b
        Add_ %edi,%ecx
        Cmp_ %ecx,dmpsv
        je   dmp14
        Sub_ %edi,$4*vrval
dmp21:
        Mov_ %edi,8(%edi)
        Cmp_ dmarg,$num03
        je   dmp2b
        Cmp_ %edi,$nulls
        je   dmp20
dmp2b:
        Cmp_ (%edi),$b_trt
        je   dmp21
        call prtnv
        Jmp_ dmp20
dmp22:
        Mov_ %edx,$4*tbbuk
        Mov_ %ecx,$4*teval
dmp23:
        push %esi
        Add_ %esi,%edx
        Add_ %edx,$cfp_b
        Sub_ %esi,$4*tenxt
dmp24:
        Mov_ %esi,12(%esi)
        Cmp_ %esi,(%esp)
        je   dmp26
        Mov_ %edi,%esi
dmp25:
        Mov_ %edi,8(%edi)
        Cmp_ %edi,$nulls
        je   dmp24
        Cmp_ (%edi),$b_trt
        je   dmp25
        Mov_ dmpsv,%edx
        call prtnv
        Mov_ %edx,dmpsv
        Jmp_ dmp24
dmp26:
        pop  %esi
        Cmp_ %edx,8(%esi)
        jne  dmp23
        Mov_ %edi,%esi
        Add_ %edi,%edx
        Jmp_ dmp14
dmp27:
        call prtpg
dmp28:
        ret
dmp29:
        call sysdm
        Jmp_ dmp28
ermsg:
        Mov_ %ecx,kvert
        Mov_ %edi,$ermms
        call prtst
        call ertex
        Add_ %ecx,$thsnd
        ldi_ %ecx
        Mov_ %ebx,profs
        call prtin
        Mov_ %esi,prbuf
        Add_ %esi,%ebx
        Add_ %esi,$cfp_f
        Mov_ %ecx,$ch_bl
#sch s.text wa  s.type 8  s.reg wa
#sch d.text (xl)  d.type 9  d.reg xl  w 0
        movb %cl,(%esi)
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        Mov_ %ecx,%edi
        Mov_ %edi,$ermns
        call prtst
        Mov_ %edi,%ecx
        call prtst
        call prtis
        call prtis
        ret
ertex:
        Mov_ ertwa,%ecx
        Mov_ ertwb,%ebx
        call sysem
        Mov_ %esi,%edi
        Mov_ %ecx,4(%edi)
        or   %ecx,%ecx
        jz   ert02
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        call sbstr
        Mov_ r_etx,%edi
ert01:
        Mov_ %ebx,ertwb
        Mov_ %ecx,ertwa
        ret
ert02:
        Mov_ %edi,r_etx
        Jmp_ ert01
evali:
        call evalp
        Dec_ _rc_
        js   call_226
        Dec_ _rc_
        jns  ppm_0413
        Jmp_ evli1
ppm_0413:
call_226:
        push %esi
        Mov_ %esi,4(%edi)
        Mov_ evlio,%edi
        Mov_ evlif,%edx
        call gtsmi
        Dec_ _rc_
        js   call_227
        Dec_ _rc_
        jns  ppm_0414
        Jmp_ evli2
ppm_0414:
        Dec_ _rc_
        jns  ppm_0415
        Jmp_ evli3
ppm_0415:
call_227:
        Mov_ evliv,%edi
        Mov_ %edi,$evlin
        Mov_ (%edi),$p_len
        Mov_ 4(%edi),%esi
        Mov_ _rc_,$4
        ret
evli1:
        Mov_ _rc_,$3
        ret
evli2:
        Mov_ _rc_,$1
        ret
evli3:
        Mov_ _rc_,$2
        ret
evalp:
        Mov_ %esi,8(%edi)
        Cmp_ (%esi),$b_exl
        je   evlp1
        Mov_ %esi,4(%esi)
        Mov_ %esi,8(%esi)
        Mov_ %ecx,(%esi)
        Cmp_ %ecx,$b_t__
        ja   evlp3
evlp1:
        chk_
        or   %eax,%eax
        jne  sec06
        push %edi
        push %ebx
        push r_pms
        push pmssl
        push pmdfl
        push _pmhbs
        Mov_ %edi,8(%edi)
evlp2:
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        call evalx
        Dec_ _rc_
        js   call_228
        Dec_ _rc_
        jns  ppm_0416
        Jmp_ evlp4
ppm_0416:
call_228:
        Mov_ %ecx,(%edi)
        Cmp_ %ecx,$b_e__
        jb   evlp2
        Mov_ %esi,%edi
        pop  _pmhbs
        pop  pmdfl
        pop  pmssl
        pop  r_pms
        pop  %ebx
        pop  %edi
        Mov_ %edx,%edi
        Mov_ _rc_,$0
        ret
evlp3:
        Xor_ %eax,%eax
        Mov_ %edx,%eax
        Mov_ _rc_,$0
        ret
evlp4:
        pop  _pmhbs
        pop  pmdfl
        pop  pmssl
        pop  r_pms
        Add_ %esp,$4*num02
        Mov_ _rc_,$1
        ret
evals:
        call evalp
        Dec_ _rc_
        js   call_229
        Dec_ _rc_
        jns  ppm_0417
        Jmp_ evls1
ppm_0417:
call_229:
        push 4(%edi)
        push %ebx
        push %esi
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Xor_ %eax,%eax
        Mov_ %edx,%eax
        Mov_ %esi,$p_brk
        call patst
        Dec_ _rc_
        js   call_230
        Dec_ _rc_
        jns  ppm_0418
        Jmp_ evls2
ppm_0418:
call_230:
        pop  %ebx
        pop  4(%edi)
        Mov_ _rc_,$3
        ret
evls1:
        Mov_ _rc_,$2
        ret
evls2:
        Add_ %esp,$4*num02
        Mov_ _rc_,$1
        ret
evalx:
        Cmp_ (%edi),$b_exl
        je   evlx2
        Mov_ %esi,4(%edi)
        Mov_ %ecx,$4*vrval
        or   %ebx,%ebx
        jnz  evlx1
        call acess
        Dec_ _rc_
        js   call_231
        Dec_ _rc_
        jns  ppm_0419
        Jmp_ evlx9
ppm_0419:
call_231:
evlx1:
        Mov_ _rc_,$0
        ret
evlx2:
        Scp_ %edx
        Mov_ %ecx,r_cod
        Sub_ %edx,%ecx
        push %ecx
        push %edx
        push _flptr
        push %ebx
        push $4*exflc
        Mov_ %eax,_flptr
        Mov_ _gtcef,%eax
        Mov_ %eax,r_cod
        Mov_ r_gtc,%eax
        Mov_ _flptr,%esp
        Mov_ r_cod,%edi
        Mov_ %eax,kvstn
        Mov_ 4(%edi),%eax
        Add_ %edi,$4*excod
        Lcp_ %edi
        Cmp_ stage,$stgxt
        jne  evlx0
        Mov_ stage,$stgee
evlx0:
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        Lcw_ %edi
        Jmp_ *(%edi)
evlx3:
        pop  %edi
        Xor_ %eax,%eax
        Cmp_ 4(%esp),%eax
        jz   evlx5
        Mov_ _rc_,$249
        Jmp_ err_
evlx4:
        pop  %ecx
        pop  %esi
        Xor_ %eax,%eax
        Cmp_ 4(%esp),%eax
        jnz  evlx5
        call acess
        Dec_ _rc_
        js   call_232
        Dec_ _rc_
        jns  ppm_0420
        Jmp_ evlx6
ppm_0420:
call_232:
evlx5:
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Jmp_ evlx7
evlx6:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %ebx,%eax
evlx7:
        Cmp_ stage,$stgee
        jne  evlx8
        Mov_ stage,$stgxt
evlx8:
        Add_ %esp,$4*num02
        pop  _flptr
        pop  %edx
        Add_ %edx,(%esp)
        pop  r_cod
        Lcp_ %edx
        or   %ebx,%ebx
        jz   evlx1
evlx9:
        Mov_ _rc_,$1
        ret
exbld:
        Mov_ %ecx,%esi
        Sub_ %ecx,$4*excod
        push %ecx
        Mov_ %ecx,cwcof
        Sub_ %ecx,%esi
        Add_ %ecx,$4*exsi_
        call alloc
        push %edi
        Mov_ 0(%edi),$b_exl
        Xor_ %eax,%eax
        Mov_ 4(%edi),%eax
        Mov_ %eax,cmpln
        Mov_ 8(%edi),%eax
        Mov_ 12(%edi),%ecx
        Mov_ 16(%edi),$ofex_
        Add_ %edi,$4*exsi_
        Mov_ cwcof,%esi
        Add_ %esi,r_ccb
        Sub_ %ecx,$4*exsi_
        push %ecx
        Sar_ %ecx,$2
        rep  movsl
        pop  %ecx
        Sar_ %ecx,$2
        Mov_ %esi,(%esp)
        Add_ %esi,$4*excod
        Mov_ %ebx,4(%esp)
exbl1:
        lodsl
        Mov_ %edi,%eax
        Cmp_ %edi,$osla_
        je   exbl3
        Cmp_ %edi,$onta_
        je   exbl3
        Dec_ %ecx
        jnz  exbl1
exbl2:
        pop  %edi
        pop  %esi
        ret
exbl3:
        Sub_ (%esi),%ebx
        Add_ %esi,$4
        Dec_ %ecx
        jnz  exbl4
exbl4:
        Dec_ %ecx
        jnz  exbl5
exbl5:
        lodsl
        Mov_ %edi,%eax
        Cmp_ %edi,$osla_
        je   exbl3
        Cmp_ %edi,$oslb_
        je   exbl3
        Cmp_ %edi,$oslc_
        je   exbl3
        Cmp_ %edi,$onta_
        je   exbl3
        Dec_ %ecx
        jnz  exbl5
        Jmp_ exbl2
expan:
        Xor_ %eax,%eax
        push %eax
        Xor_ %eax,%eax
        Mov_ %ecx,%eax
        Xor_ %eax,%eax
        Mov_ %edx,%eax
exp01:
        call scane
        Add_ %esi,%ecx
        jmp  *bsw_0421(,%esi,4)
        Data
bsw_0421:
        .long exp27
        .long exp27
        .long exp04
        .long exp06
        .long exp06
        .long exp04
        .long exp08
        .long exp08
        .long exp09
        .long exp02
        .long exp05
        .long exp11
        .long exp10
        .long exp10
        .long exp04
        .long exp03
        .long exp03
        .long exp04
        .long exp03
        .long exp03
        .long exp04
        .long exp05
        .long exp05
        .long exp26
        .long exp02
        .long exp05
        .long exp12
        .long exp02
        .long exp05
        .long exp18
        .long exp02
        .long exp05
        .long exp19
        .long exp02
        .long exp05
        .long exp19
        Text
exp02:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ scnrs,%eax
        Mov_ %edi,$nulls
exp03:
        push %edi
        Mov_ %ecx,$num02
        Jmp_ exp01
exp04:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ scnrs,%eax
        Mov_ %edi,$opdvc
        or   %ebx,%ebx
        jz   exp4a
        Mov_ %edi,$opdvp
exp4a:
        Xor_ %eax,%eax
        Cmp_ scnbl,%eax
        jnz  exp26
        Mov_ _rc_,$220
        Jmp_ err_
exp05:
        Mov_ _rc_,$221
        Jmp_ err_
exp06:
        Mov_ %esi,$num04
        Xor_ %eax,%eax
        Mov_ %edi,%eax
exp07:
        push %edi
        push %edx
        push %ebx
        chk_
        or   %eax,%eax
        jne  sec06
        Xor_ %eax,%eax
        Mov_ %ecx,%eax
        Mov_ %ebx,%esi
        Mov_ %edx,$num01
        Jmp_ exp01
exp08:
        Mov_ _rc_,$222
        Jmp_ err_
exp09:
        pop  %edi
        Mov_ %esi,$num03
        Jmp_ exp07
exp10:
        Mov_ %esi,$num05
        Jmp_ exp07
exp11:
        Inc_ %edx
        call expdm
        Xor_ %eax,%eax
        push %eax
        Xor_ %eax,%eax
        Mov_ %ecx,%eax
        Cmp_ %ebx,$num02
        ja   exp01
        Mov_ _rc_,$223
        Jmp_ err_
exp12:
        Cmp_ %ebx,$num01
        je   exp20
        Cmp_ %ebx,$num05
        je   exp13
        Cmp_ %ebx,$num04
        je   exp14
        Mov_ _rc_,$224
        Jmp_ err_
exp13:
        Mov_ %esi,$c_fnc
        Jmp_ exp15
exp14:
        Cmp_ %edx,$num01
        je   exp17
        Mov_ %esi,$c_sel
exp15:
        call expdm
        Mov_ %ecx,%edx
        Add_ %ecx,$cmvls
        Sal_ %ecx,$2
        call alloc
        Mov_ (%edi),$b_cmt
        Mov_ 8(%edi),%esi
        Mov_ 4(%edi),%ecx
        Add_ %edi,%ecx
exp16:
        Sub_ %edi,$4
        pop  (%edi)
        pop  %ebx
        Dec_ %edx
        jnz  exp16
        Sub_ %edi,$4*cmvls
        pop  %edx
        Mov_ %eax,(%esp)
        Mov_ 12(%edi),%eax
        Mov_ (%esp),%edi
        Mov_ %ecx,$num02
        Jmp_ exp01
exp17:
        call expdm
        pop  %edi
        pop  %ebx
        pop  %edx
        Mov_ (%esp),%edi
        Mov_ %ecx,$num02
        Jmp_ exp01
exp18:
        Mov_ %esi,$c_arr
        Cmp_ %ebx,$num03
        je   exp15
        Cmp_ %ebx,$num02
        je   exp20
        Mov_ _rc_,$225
        Jmp_ err_
exp19:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ scnrs,%eax
        Mov_ %esi,%ebx
        jmp  *bsw_0422(,%esi,4)
        Data
bsw_0422:
        .long exp20
        .long exp22
        .long exp23
        .long exp24
        .long exp21
        .long exp21
        Text
exp20:
        call expdm
        pop  %edi
        Add_ %esp,$cfp_b
        ret
exp21:
        Mov_ _rc_,$226
        Jmp_ err_
exp22:
        Mov_ _rc_,$227
        Jmp_ err_
exp23:
        Mov_ _rc_,$228
        Jmp_ err_
exp24:
        Mov_ _rc_,$229
        Jmp_ err_
exp25:
        Mov_ expsv,%edi
        call expop
        Mov_ %edi,expsv
exp26:
        Mov_ %esi,4(%esp)
        Cmp_ %esi,$num05
        jbe  exp27
        Mov_ %eax,8(%esi)
        Cmp_ 12(%edi),%eax
        jb   exp25
exp27:
        push %edi
        chk_
        or   %eax,%eax
        jne  sec06
        Mov_ %ecx,$num01
        Cmp_ %edi,$opdvs
        jne  exp01
        Xor_ %eax,%eax
        Mov_ %ecx,%eax
        Jmp_ exp01
expap:
        push %esi
        Cmp_ (%edi),$b_cmt
        jne  expp2
        Mov_ %ecx,8(%edi)
        Cmp_ %ecx,$c_cnc
        je   expp1
        Cmp_ %ecx,$c_pmt
        je   expp1
        Cmp_ %ecx,$c_alt
        jne  expp2
        Mov_ %esi,20(%edi)
        Cmp_ (%esi),$b_cmt
        jne  expp2
        Cmp_ 8(%esi),$c_cnc
        jne  expp2
        Mov_ %eax,16(%esi)
        Mov_ 20(%edi),%eax
        Mov_ 16(%esi),%edi
        Mov_ %edi,%esi
expp1:
        pop  %esi
        Mov_ _rc_,$0
        ret
expp2:
        pop  %esi
        Mov_ _rc_,$1
        ret
expdm:
        pop  prc_+4*3
        Mov_ r_exs,%esi
exdm1:
        Cmp_ 4(%esp),$num05
        jbe  exdm2
        call expop
        Jmp_ exdm1
exdm2:
        Mov_ %esi,r_exs
        Xor_ %eax,%eax
        Mov_ r_exs,%eax
        Mov_ _rc_,$0
        Mov_ %eax,prc_+4*3
        Jmp_ *%eax
expop:
        pop  prc_+4*4
        Mov_ %edi,4(%esp)
        Cmp_ 8(%edi),$lluno
        je   expo2
        Mov_ %ecx,$4*cmbs_
        call alloc
        pop  16(%edi)
        pop  %esi
        Mov_ %eax,(%esp)
        Mov_ 20(%edi),%eax
expo1:
        Mov_ (%edi),$b_cmt
        Mov_ %eax,4(%esi)
        Mov_ 8(%edi),%eax
        Mov_ 12(%edi),%esi
        Mov_ 4(%edi),%ecx
        Mov_ (%esp),%edi
        Mov_ _rc_,$0
        Mov_ %eax,prc_+4*4
        Jmp_ *%eax
expo2:
        Mov_ %ecx,$4*cmus_
        call alloc
        pop  16(%edi)
        Mov_ %esi,(%esp)
        Jmp_ expo1
filnm:
        push %ebx
        or   %edx,%edx
        jz   filn3
        Mov_ %esi,r_sfn
        or   %esi,%esi
        jz   filn3
        Mov_ %ebx,16(%esi)
        Cmp_ %ebx,r_sfn
        je   filn3
        push %edi
        Mov_ %edi,%ebx
        push %edx
filn1:
        Mov_ %esi,%edi
        Mov_ %edi,4(%esi)
        ldi_ 4(%edi)
        sti_ %edx
        Cmp_ (%esp),%edx
        jb   filn2
        Mov_ %ebx,%esi
        Mov_ %edi,12(%esi)
        Cmp_ %edi,r_sfn
        jne  filn1
filn2:
        Mov_ %esi,%ebx
        Mov_ %esi,8(%esi)
        pop  %edx
        pop  %edi
        pop  %ebx
        ret
filn3:
        pop  %ebx
        Mov_ %esi,$nulls
        ret
flstg:
        Xor_ %eax,%eax
        Cmp_ kvcas,%eax
        jz   fst99
        push %esi
        push %edi
        call alocs
        Mov_ %esi,(%esp)
        push %edi
        Add_ %esi,$cfp_f
        Add_ %edi,$cfp_f
        Xor_ %eax,%eax
        push %eax
fst01:
#lch s.text (xl)+  s.type 10  s.reg xl
#lch d.text wa  d.type 8  d.reg wa  w 0
        Xor_ %eax,%eax
        lodsb
        Mov_ %ecx,%eax
        Cmp_ %ecx,$ch_ua
        jb   fst02
        Cmp_ %ecx,$ch_uz
        ja   fst02
        cmpb %cl,'A'
        jb   flc_0423
        cmpb %cl,'Z'
        ja   flc_0423
        Add_ %cl,$32
flc_0423:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ (%esp),%eax
fst02:
#sch s.text wa  s.type 8  s.reg wa
#sch d.text (xr)+  d.type 10  d.reg xr  w 0
        movb %cl,(%edi)
        Inc_ %edi
        Dec_ %edx
        jnz  fst01
        pop  %edi
        or   %edi,%edi
        jnz  fst10
        pop  _dnamp
        pop  %edi
        Jmp_ fst20
fst10:
        pop  %edi
        Add_ %esp,$cfp_b
fst20:
        Mov_ %ecx,4(%edi)
        pop  %esi
fst99:
        ret
gbcol:
        Xor_ %eax,%eax
        Cmp_ dmvch,%eax
        jnz  gbc14
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ gbcfl,%eax
        Mov_ gbsva,%ecx
        Mov_ gbsvb,%ebx
        Mov_ gbsvc,%edx
        push %esi
        Scp_ %ecx
        Sub_ %ecx,r_cod
        Lcp_ %ecx
        or   %ebx,%ebx
        jz   gbc0a
        Xor_ %eax,%eax
        Mov_ dnams,%eax
gbc0a:
        Mov_ %ecx,_dnamb
        Add_ %ecx,dnams
        Mov_ gbcsd,%ecx
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %edi,%eax
        Mov_ %ecx,_dnamb
        Mov_ %ebx,_dnamp
        Mov_ %edx,dname
        call sysgc
        Mov_ %edi,%esp
        Mov_ %esi,_stbas
        Cmp_ %esi,%edi
        jae  gbc00
        Mov_ %edi,%esi
        Mov_ %esi,%esp
gbc00:
        call gbcpf
        Mov_ %edi,$r_aaa
        Mov_ %esi,$r_yyy
        call gbcpf
        Mov_ %ecx,_hshtb
gbc01:
        Mov_ %esi,%ecx
        Add_ %ecx,$cfp_b
        Mov_ gbcnm,%ecx
gbc02:
        Mov_ %edi,(%esi)
        or   %edi,%edi
        jz   gbc03
        Mov_ %esi,%edi
        Add_ %edi,$4*vrval
        Add_ %esi,$4*vrnxt
        call gbcpf
        Jmp_ gbc02
gbc03:
        Mov_ %ecx,gbcnm
        Cmp_ %ecx,hshte
        jne  gbc01
        Mov_ %edi,_dnamb
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
gbc04:
        Cmp_ %edi,gbcsd
        je   gbc4c
        Mov_ %ecx,(%edi)
        Xor_ %eax,%eax
        Inc_ %eax
        And_ %eax,%ecx
        jne  gbc4b
        Dec_ %ecx
        Mov_ (%edi),%ecx
        call blkln
        Add_ %edi,%ecx
        Jmp_ gbc04
gbc4b:
        call blkln
        Add_ %edi,%ecx
        Add_ %ebx,%ecx
        Jmp_ gbc04
gbc4c:
        Mov_ gbcsf,%ebx
        Mov_ %edx,%edi
        Add_ %edx,gbsvb
        Xor_ %eax,%eax
        Mov_ gbcnm,%eax
        Mov_ gbclm,$gbcnm
        Mov_ gbcns,%edi
gbc05:
        Cmp_ %edi,_dnamp
        je   gbc07
        Mov_ %ecx,(%edi)
        Xor_ %eax,%eax
        Inc_ %eax
        And_ %eax,%ecx
        jne  gbc07
gbc06:
        Mov_ %esi,%ecx
        Mov_ %ecx,(%esi)
        Mov_ (%esi),%edx
        Xor_ %eax,%eax
        Inc_ %eax
        And_ %eax,%ecx
        je   gbc06
        Mov_ (%edi),%ecx
        call blkln
        Add_ %edi,%ecx
        Add_ %edx,%ecx
        Jmp_ gbc05
gbc07:
        Mov_ %ecx,%edi
        Mov_ %esi,gbclm
        Sub_ %ecx,4(%esi)
        Mov_ 4(%esi),%ecx
gbc08:
        Cmp_ %edi,_dnamp
        je   gbc10
        Mov_ %ecx,(%edi)
        Xor_ %eax,%eax
        Inc_ %eax
        And_ %eax,%ecx
        je   gbc09
        call blkln
        Add_ %edi,%ecx
        Jmp_ gbc08
gbc09:
        Sub_ %edi,$4*num02
        Mov_ %esi,gbclm
        Mov_ (%esi),%edi
        Xor_ %eax,%eax
        Mov_ (%edi),%eax
        Mov_ gbclm,%edi
        Mov_ %esi,%edi
        Add_ %edi,$4*num02
        Mov_ 4(%esi),%edi
        Jmp_ gbc06
gbc10:
        Mov_ %edi,gbcsd
        Add_ %edi,gbcns
gbc11:
        Mov_ %esi,gbcnm
        or   %esi,%esi
        jz   gbc12
        lodsl
        Mov_ gbcnm,%eax
        lodsl
        Mov_ %ecx,%eax
        Sar_ %ecx,$2
        rep  movsl
        Jmp_ gbc11
gbc12:
        Mov_ _dnamp,%edi
        Mov_ %ebx,gbsvb
        or   %ebx,%ebx
        jz   gbc13
        Mov_ %esi,%edi
        Add_ %edi,%ebx
        Mov_ _dnamp,%edi
        Mov_ %ecx,%esi
        Sub_ %ecx,_dnamb
        Add_ _dnamb,%ebx
        Sar_ %ecx,$2
        std
        Sub_ %esi,$4
        Sub_ %edi,$4
rep_0424:
        or   %ecx,%ecx
        jz   rep_0425
        movsl
        dec  %ecx
        Jmp_ rep_0424
rep_0425:
        cld
gbc13:
        Xor_ %eax,%eax
        Mov_ %edi,%eax
        Mov_ gbcfl,%edi
        Mov_ %ecx,_dnamb
        Mov_ %ebx,_dnamp
        Mov_ %edx,dname
        call sysgc
        sti_ gbcia
        Xor_ %eax,%eax
        Mov_ %edi,%eax
        Mov_ %ebx,gbcsf
        Sar_ %ebx,$2
        ldi_ %ebx
        Mov_ %eax,gbsed
        mli_
        iov_ gb13a
        Mov_ %ebx,_dnamp
        Sub_ %ebx,_dnamb
        Sar_ %ebx,$2
        Mov_ gbcsf,%ebx
        Mov_ %eax,gbcsf
        sbi_
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jg   gb13a
        Mov_ %edi,_dnamp
        Sub_ %edi,_dnamb
gb13a:
        ldi_ gbcia
        Mov_ %ecx,gbsva
        Mov_ %ebx,gbsvb
        Scp_ %edx
        Add_ %edx,r_cod
        Lcp_ %edx
        Mov_ %edx,gbsvc
        pop  %esi
        Inc_ gbcnt
        ret
gbc14:
        Inc_ errft
        Mov_ _rc_,$250
        Jmp_ err_
gbcpf:
        Xor_ %eax,%eax
        push %eax
        push %esi
gpf01:
        Mov_ %esi,(%edi)
        Mov_ %edx,%edi
        Cmp_ %esi,_dnamb
        jb   gpf2a
        Cmp_ %esi,_dnamp
        jae  gpf2a
        Mov_ %ecx,(%esi)
        Cmp_ %esi,gbcsd
        jb   gpf1a
        Mov_ (%esi),%edi
        Mov_ (%edi),%ecx
gpf1a:
        Xor_ %eax,%eax
        Inc_ %eax
        And_ %eax,%ecx
        jne  gpf03
gpf02:
        Mov_ %edi,%edx
gpf2a:
        Add_ %edi,$cfp_b
        Cmp_ %edi,(%esp)
        jne  gpf01
        pop  %esi
        pop  %edi
        or   %edi,%edi
        jnz  gpf2a
        ret
gpf03:
        Cmp_ %esi,gbcsd
        jae  gpf3a
        Inc_ (%esi)
gpf3a:
        Mov_ %edi,%esi
        Mov_ %esi,%ecx
        Dec_ %esi
        mov  (%esi),%al
        movzbl %al,%esi
        jmp  *bsw_0426(,%esi,4)
        Data
bsw_0426:
        .long gpf06
        .long gpf19
        .long gpf17
        .long gpf02
        .long gpf10
        .long gpf10
        .long gpf12
        .long gpf12
        .long gpf02
        .long gpf02
        .long gpf02
        .long gpf08
        .long gpf08
        .long gpf02
        .long gpf09
        .long gpf02
        .long gpf13
        .long gpf16
        .long gpf02
        .long gpf07
        .long gpf04
        .long gpf02
        .long gpf02
        .long gpf02
        .long gpf10
        .long gpf11
        .long gpf02
        .long gpf14
        .long gpf15
        Text
gpf04:
        Mov_ %ecx,4(%edi)
        Mov_ %ebx,$4*cmtyp
gpf05:
        Add_ %ecx,%edi
        Add_ %edi,%ebx
        push %edx
        push %ecx
        chk_
        or   %eax,%eax
        jne  sec06
        Jmp_ gpf01
gpf06:
        Mov_ %ecx,8(%edi)
        Mov_ %ebx,12(%edi)
        Jmp_ gpf05
gpf07:
        Mov_ %ecx,12(%edi)
        Mov_ %ebx,$4*ccuse
        Jmp_ gpf05
gpf19:
        Mov_ %ecx,12(%edi)
        Mov_ %ebx,$4*cdfal
        Jmp_ gpf05
gpf08:
        Mov_ %ecx,8(%edi)
        Mov_ %ebx,$4*offs3
        Jmp_ gpf05
gpf09:
        Mov_ %ecx,4(%edi)
        Mov_ %ebx,$4*xrptr
        Jmp_ gpf05
gpf10:
        Mov_ %ecx,$4*offs2
        Mov_ %ebx,$4*offs1
        Jmp_ gpf05
gpf11:
        Mov_ %ecx,$4*ffofs
        Mov_ %ebx,$4*ffnxt
        Jmp_ gpf05
gpf12:
        Mov_ %ecx,$4*parm2
        Mov_ %ebx,$4*pthen
        Jmp_ gpf05
gpf13:
        Mov_ %esi,8(%edi)
        Mov_ %ecx,12(%esi)
        Mov_ %ebx,$4*pdfld
        Jmp_ gpf05
gpf14:
        Mov_ %ecx,$4*pfarg
        Mov_ %ebx,$4*pfcod
        Jmp_ gpf05
gpf15:
        Mov_ %ecx,$4*tesi_
        Mov_ %ebx,$4*tesub
        Jmp_ gpf05
gpf16:
        Mov_ %ecx,$4*trsi_
        Mov_ %ebx,$4*trval
        Jmp_ gpf05
gpf17:
        Mov_ %ecx,12(%edi)
        Mov_ %ebx,$4*exflc
        Jmp_ gpf05
gtarr:
        Mov_ gtawa,%ecx
        Mov_ %ecx,(%edi)
        Cmp_ %ecx,$b_art
        je   gtar8
        Cmp_ %ecx,$b_vct
        je   gtar8
        Cmp_ %ecx,$b_tbt
        jne  gta9a
        push %edi
        Xor_ %eax,%eax
        Mov_ %edi,%eax
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
gtar1:
        Mov_ %esi,(%esp)
        Add_ %esi,8(%esi)
        Sub_ %esi,$4*tbbuk
        Mov_ %ecx,%esi
gtar2:
        Mov_ %esi,%ecx
        Sub_ %ecx,$cfp_b
gtar3:
        Mov_ %esi,12(%esi)
        Cmp_ %esi,(%esp)
        je   gtar6
        Mov_ cnvtp,%esi
gtar4:
        Mov_ %esi,8(%esi)
        Cmp_ (%esi),$b_trt
        je   gtar4
        Mov_ %edx,%esi
        Mov_ %esi,cnvtp
        Cmp_ %edx,$nulls
        je   gtar3
        or   %edi,%edi
        jnz  gtar5
        Inc_ %ebx
        Jmp_ gtar3
gtar5:
        Xor_ %eax,%eax
        Cmp_ gtawa,%eax
        jz   gta5a
        Mov_ %eax,4(%esi)
        stosl
        Mov_ %eax,%edx
        stosl
        Jmp_ gtar3
gta5a:
        Mov_ %eax,%esi
        stosl
        Mov_ %eax,%esi
        stosl
        Jmp_ gtar3
gtar6:
        Cmp_ %ecx,(%esp)
        jne  gtar2
        or   %edi,%edi
        jnz  gtar7
        or   %ebx,%ebx
        jz   gtar9
        Mov_ %ecx,%ebx
        Add_ %ecx,%ebx
        Add_ %ecx,$arvl2
        Sal_ %ecx,$2
        Cmp_ %ecx,mxlen
        ja   gta9b
        call alloc
        Mov_ (%edi),$b_art
        Xor_ %eax,%eax
        Mov_ 4(%edi),%eax
        Mov_ 8(%edi),%ecx
        Mov_ 16(%edi),$num02
        ldi_ intv1
        sti_ 20(%edi)
        sti_ 28(%edi)
        ldi_ intv2
        sti_ 32(%edi)
        ldi_ %ebx
        sti_ 24(%edi)
        Xor_ %eax,%eax
        Mov_ 36(%edi),%eax
        Mov_ 12(%edi),$4*arpr2
        Mov_ %ebx,%edi
        Add_ %edi,$4*arvl2
        Jmp_ gtar1
gtar7:
        Mov_ %edi,%ebx
        Mov_ (%esp),%ebx
        ldi_ 24(%edi)
        Mov_ %eax,intvh
        mli_
        Mov_ %eax,intv2
        adi_
        call icbld
        push %edi
        call gtstg
        Dec_ _rc_
        js   call_233
        Dec_ _rc_
        jns  ppm_0427
        Mov_ _rc_,$299
        Jmp_ err_
ppm_0427:
call_233:
        Mov_ %esi,%edi
        pop  %edi
        Mov_ 36(%edi),%esi
        Sub_ %ecx,$num02
        Add_ %esi,%ecx
        Add_ %esi,$cfp_f
        Mov_ %ebx,$ch_cm
#sch s.text wb  s.type 8  s.reg wb
#sch d.text (xl)  d.type 9  d.reg xl  w 0
        movb %bl,(%esi)
gtar8:
        Mov_ _rc_,$0
        ret
gtar9:
        pop  %edi
        Mov_ _rc_,$1
        ret
gta9a:
        Mov_ _rc_,$2
        ret
gta9b:
        Mov_ _rc_,$260
        Jmp_ err_
gtcod:
        Cmp_ (%edi),$b_cds
        je   gtcd1
        Cmp_ (%edi),$b_cdc
        je   gtcd1
        push %edi
        call gtstg
        Dec_ _rc_
        js   call_234
        Dec_ _rc_
        jns  ppm_0428
        Jmp_ gtcd2
ppm_0428:
call_234:
        Mov_ %eax,_flptr
        Mov_ _gtcef,%eax
        Mov_ %eax,r_cod
        Mov_ r_gtc,%eax
        Mov_ r_cim,%edi
        Mov_ scnil,%ecx
        Xor_ %eax,%eax
        Mov_ scnpt,%eax
        Mov_ stage,$stgxc
        Mov_ %eax,cmpsn
        Mov_ lstsn,%eax
        Inc_ cmpln
        call cmpil
        Mov_ stage,$stgxt
        Xor_ %eax,%eax
        Mov_ r_cim,%eax
gtcd1:
        Mov_ _rc_,$0
        ret
gtcd2:
        Mov_ _rc_,$1
        ret
gtexp:
        Cmp_ (%edi),$b_e__
        jb   gtex1
        push %edi
        call gtstg
        Dec_ _rc_
        js   call_235
        Dec_ _rc_
        jns  ppm_0429
        Jmp_ gtex2
ppm_0429:
call_235:
        Mov_ %esi,%edi
        Add_ %esi,%ecx
        Add_ %esi,$cfp_f
#lch s.text -(xl)  s.type 11  s.reg xl
#lch d.text xl  d.type 7  d.reg xl  w 1
        dec  %esi
        Xor_ %eax,%eax
        movb (%esi),%al
        mov  %eax,%esi
        Cmp_ %esi,$ch_cl
        je   gtex2
        Cmp_ %esi,$ch_sm
        je   gtex2
        Mov_ r_cim,%edi
        Xor_ %eax,%eax
        Mov_ scnpt,%eax
        Mov_ scnil,%ecx
        push %ebx
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Mov_ %eax,_flptr
        Mov_ _gtcef,%eax
        Mov_ %eax,r_cod
        Mov_ r_gtc,%eax
        Mov_ stage,$stgev
        Mov_ scntp,$t_uok
        call expan
        Xor_ %eax,%eax
        Mov_ scnrs,%eax
        pop  %ecx
        Mov_ %eax,scnil
        Cmp_ scnpt,%eax
        jne  gtex2
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Mov_ %esi,%edi
        call cdgex
        Xor_ %eax,%eax
        Mov_ r_cim,%eax
        Mov_ stage,$stgxt
gtex1:
        Mov_ _rc_,$0
        ret
gtex2:
        Mov_ _rc_,$1
        ret
gtint:
        Cmp_ (%edi),$_b_icl
        je   gtin2
        Mov_ gtina,%ecx
        Mov_ gtinb,%ebx
        call gtnum
        Dec_ _rc_
        js   call_236
        Dec_ _rc_
        jns  ppm_0430
        Jmp_ gtin3
ppm_0430:
call_236:
        Cmp_ %ecx,$_b_icl
        je   gtin1
        Mov_ %eax,%edi
        Add_ %eax,(cfp_b*rcval)
        call ldr_
        call rti_
        jc   gtin3
        call icbld
gtin1:
        Mov_ %ecx,gtina
        Mov_ %ebx,gtinb
gtin2:
        Mov_ _rc_,$0
        ret
gtin3:
        Mov_ _rc_,$1
        ret
gtnum:
        Mov_ %ecx,(%edi)
        Cmp_ %ecx,$_b_icl
        je   gtn34
        Cmp_ %ecx,$b_rcl
        je   gtn34
        push %edi
        push %edi
        call gtstg
        Dec_ _rc_
        js   call_237
        Dec_ _rc_
        jns  ppm_0431
        Jmp_ gtn36
ppm_0431:
call_237:
        ldi_ intv0
        or   %ecx,%ecx
        jz   gtn32
        Xor_ %eax,%eax
        Mov_ gtnnf,%eax
        sti_ gtnex
        Xor_ %eax,%eax
        Mov_ gtnsc,%eax
        Xor_ %eax,%eax
        Mov_ gtndf,%eax
        Xor_ %eax,%eax
        Mov_ gtnrd,%eax
        Mov_ %eax,$reav0
        call ldr_
        Add_ %edi,$cfp_f
gtn01:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wb  d.type 8  d.reg wb  w 0
        Xor_ %ebx,%ebx
        movb (%edi),%bl
        Inc_ %edi
        Cmp_ %ebx,$ch_d0
        jb   gtn02
        Cmp_ %ebx,$ch_d9
        jbe  gtn06
gtn02:
        Cmp_ %ebx,$ch_bl
        jne  gtn03
gtna2:
        Dec_ %ecx
        jnz  gtn01
        Jmp_ gtn07
gtn03:
        Cmp_ %ebx,$ch_pl
        je   gtn04
        Cmp_ %ebx,$ch_ht
        je   gtna2
        Cmp_ %ebx,$ch_mn
        jne  gtn12
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ gtnnf,%eax
gtn04:
        Dec_ %ecx
        jnz  gtn05
        Jmp_ gtn36
gtn05:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wb  d.type 8  d.reg wb  w 0
        Xor_ %ebx,%ebx
        movb (%edi),%bl
        Inc_ %edi
        Cmp_ %ebx,$ch_d0
        jb   gtn08
        Cmp_ %ebx,$ch_d9
        ja   gtn08
gtn06:
        sti_ gtnsi
        sti_ %eax
        imul %eax
        jo   gtn35
        Sub_ %ebx,ch_d0
        Sub_ %eax,%ebx
        ldi_ %eax
        jo   gtn35
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ gtnrd,%eax
        Dec_ %ecx
        jnz  gtn05
gtn07:
        Xor_ %eax,%eax
        Cmp_ gtnnf,%eax
        jnz  gtn32
        ngi_
        ino_ gtn32
        Jmp_ gtn36
gtn08:
        Cmp_ %ebx,$ch_bl
        je   gtna9
        Cmp_ %ebx,$ch_ht
        je   gtna9
        call itr_
        call ngr_
        Jmp_ gtn12
gtn09:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wb  d.type 8  d.reg wb  w 0
        Xor_ %ebx,%ebx
        movb (%edi),%bl
        Inc_ %edi
        Cmp_ %ebx,$ch_ht
        je   gtna9
        Cmp_ %ebx,$ch_bl
        jne  gtn36
gtna9:
        Dec_ %ecx
        jnz  gtn09
        Jmp_ gtn07
gtn10:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wb  d.type 8  d.reg wb  w 0
        Xor_ %ebx,%ebx
        movb (%edi),%bl
        Inc_ %edi
        Cmp_ %ebx,$ch_d0
        jb   gtn12
        Cmp_ %ebx,$ch_d9
        ja   gtn12
gtn11:
        Sub_ %ebx,$ch_d0
        Mov_ %eax,$reavt
        call mlr_
        rov_ gtn36
        Mov_ %eax,$gtnsr
        call str_
        ldi_ %ebx
        call itr_
        Mov_ %eax,$gtnsr
        call adr_
        Mov_ %eax,gtndf
        Add_ gtnsc,%eax
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ gtnrd,%eax
        Dec_ %ecx
        jnz  gtn10
        Jmp_ gtn22
gtn12:
        Cmp_ %ebx,$ch_dt
        jne  gtn13
        Xor_ %eax,%eax
        Cmp_ gtndf,%eax
        jnz  gtn36
        Mov_ gtndf,$num01
        Dec_ %ecx
        jnz  gtn10
        Jmp_ gtn22
gtn13:
        Cmp_ %ebx,$ch_le
        je   gtn15
        Cmp_ %ebx,$ch_ld
        je   gtn15
        Cmp_ %ebx,$ch_ue
        je   gtn15
        Cmp_ %ebx,$ch_ud
        je   gtn15
gtn14:
        Cmp_ %ebx,$ch_bl
        je   gtnb4
        Cmp_ %ebx,$ch_ht
        je   gtnb4
        Jmp_ gtn36
gtnb4:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wb  d.type 8  d.reg wb  w 0
        Xor_ %ebx,%ebx
        movb (%edi),%bl
        Inc_ %edi
        Dec_ %ecx
        jnz  gtn14
        Jmp_ gtn22
gtn15:
        Xor_ %eax,%eax
        Mov_ gtnes,%eax
        ldi_ intv0
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ gtndf,%eax
        Dec_ %ecx
        jnz  gtn16
        Jmp_ gtn36
gtn16:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wb  d.type 8  d.reg wb  w 0
        Xor_ %ebx,%ebx
        movb (%edi),%bl
        Inc_ %edi
        Cmp_ %ebx,$ch_pl
        je   gtn17
        Cmp_ %ebx,$ch_mn
        jne  gtn19
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ gtnes,%eax
gtn17:
        Dec_ %ecx
        jnz  gtn18
        Jmp_ gtn36
gtn18:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wb  d.type 8  d.reg wb  w 0
        Xor_ %ebx,%ebx
        movb (%edi),%bl
        Inc_ %edi
gtn19:
        Cmp_ %ebx,$ch_d0
        jb   gtn20
        Cmp_ %ebx,$ch_d9
        ja   gtn20
        sti_ %eax
        imul %eax
        jo   gtn36
        Sub_ %ebx,ch_d0
        Sub_ %eax,%ebx
        ldi_ %eax
        jo   gtn36
        Dec_ %ecx
        jnz  gtn18
        Jmp_ gtn21
gtn20:
        Cmp_ %ebx,$ch_bl
        je   gtnc0
        Cmp_ %ebx,$ch_ht
        je   gtnc0
        Jmp_ gtn36
gtnc0:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wb  d.type 8  d.reg wb  w 0
        Xor_ %ebx,%ebx
        movb (%edi),%bl
        Inc_ %edi
        Dec_ %ecx
        jnz  gtn20
gtn21:
        sti_ gtnex
        Xor_ %eax,%eax
        Cmp_ gtnes,%eax
        jnz  gtn22
        ngi_
        iov_ gtn36
        sti_ gtnex
gtn22:
        Xor_ %eax,%eax
        Cmp_ gtnrd,%eax
        jz   gtn36
        Xor_ %eax,%eax
        Cmp_ gtndf,%eax
        jz   gtn36
        ldi_ gtnsc
        Mov_ %eax,gtnex
        sbi_
        iov_ gtn36
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jl   gtn26
        sti_ %eax
        or   %eax,%eax
        js   gtn36
        sti_ %ecx
gtn23:
        Cmp_ %ecx,$num10
        jbe  gtn24
        Mov_ %eax,$reatt
        call dvr_
        Sub_ %ecx,$num10
        Jmp_ gtn23
gtn24:
        or   %ecx,%ecx
        jz   gtn30
        Mov_ %ebx,$cfp_r
        Mov_ %edi,$reav1
        Sal_ %ecx,$2
gtn25:
        Add_ %edi,%ecx
        Dec_ %ebx
        jnz  gtn25
        Mov_ %eax,%edi
        call dvr_
        Jmp_ gtn30
gtn26:
        ngi_
        iov_ gtn36
        sti_ %eax
        or   %eax,%eax
        js   gtn36
        sti_ %ecx
gtn27:
        Cmp_ %ecx,$num10
        jbe  gtn28
        Mov_ %eax,$reatt
        call mlr_
        rov_ gtn36
        Sub_ %ecx,$num10
        Jmp_ gtn27
gtn28:
        or   %ecx,%ecx
        jz   gtn30
        Mov_ %ebx,$cfp_r
        Mov_ %edi,$reav1
        Sal_ %ecx,$2
gtn29:
        Add_ %edi,%ecx
        Dec_ %ebx
        jnz  gtn29
        Mov_ %eax,%edi
        call mlr_
        rov_ gtn36
gtn30:
        Xor_ %eax,%eax
        Cmp_ gtnnf,%eax
        jz   gtn31
        call ngr_
gtn31:
        call rcbld
        Jmp_ gtn33
gtn32:
        call icbld
gtn33:
        Mov_ %ecx,(%edi)
        Add_ %esp,$cfp_b
gtn34:
        Mov_ _rc_,$0
        ret
gtn35:
#lch s.text -(xr)  s.type 11  s.reg xr
#lch d.text wb  d.type 8  d.reg wb  w 0
        dec  %edi
        Xor_ %ebx,%ebx
        movb (%edi),%bl
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wb  d.type 8  d.reg wb  w 0
        Xor_ %ebx,%ebx
        movb (%edi),%bl
        Inc_ %edi
        ldi_ gtnsi
        call itr_
        call ngr_
        Jmp_ gtn11
gtn36:
        pop  %edi
        Mov_ _rc_,$1
        ret
gtnvr:
        Cmp_ (%edi),$b_nml
        jne  gnv02
        Mov_ %edi,4(%edi)
        Cmp_ %edi,_state
        jb   gnv07
gnv01:
        Mov_ _rc_,$1
        ret
gnv02:
        Mov_ gnvsa,%ecx
        Mov_ gnvsb,%ebx
        push %edi
        call gtstg
        Dec_ _rc_
        js   call_238
        Dec_ _rc_
        jns  ppm_0432
        Jmp_ gnv01
ppm_0432:
call_238:
        or   %ecx,%ecx
        jz   gnv01
        call flstg
        push %esi
        push %edi
        Mov_ %ebx,%edi
        Add_ %ebx,$4*schar
        Mov_ gnvst,%ebx
        Mov_ %ebx,%ecx
        mov  %ebx,ctbw_r
        movl $0,ctbw_v
        call ctw_
        movl ctbw_r,%ebx
        Mov_ gnvnw,%ebx
        call hashs
        Mov_ %eax,hshnb
        rmi_
        sti_ %edx
        Sal_ %edx,$2
        Add_ %edx,_hshtb
        Sub_ %edx,$4*vrnxt
gnv03:
        Mov_ %esi,%edx
        Mov_ %esi,24(%esi)
        or   %esi,%esi
        jz   gnv08
        Mov_ %edx,%esi
        Xor_ %eax,%eax
        Cmp_ 28(%esi),%eax
        jnz  gnv04
        Mov_ %esi,32(%esi)
        Sub_ %esi,$4*vrsof
gnv04:
        Cmp_ %ecx,28(%esi)
        jne  gnv03
        Add_ %esi,$4*vrchs
        Mov_ %ebx,gnvnw
        Mov_ %edi,gnvst
gnv05:
        Mov_ %eax,(%esi)
        Cmp_ (%edi),%eax
        jnz  gnv03
        Add_ %edi,$cfp_b
        Add_ %esi,$cfp_b
        Dec_ %ebx
        jnz  gnv05
        Mov_ %edi,%edx
gnv06:
        Mov_ %ecx,gnvsa
        Mov_ %ebx,gnvsb
        Add_ %esp,$cfp_b
        pop  %esi
gnv07:
        Mov_ _rc_,$0
        ret
gnv08:
        Xor_ %eax,%eax
        Mov_ %edi,%eax
        Mov_ gnvhe,%edx
        Cmp_ %ecx,$num09
        ja   gnv14
        Mov_ %esi,%ecx
        Sal_ %esi,$2
        Mov_ %esi,vsrch(%esi)
gnv09:
        Mov_ gnvsp,%esi
        lodsl
        Mov_ %edx,%eax
        lodsl
        Mov_ %ebx,%eax
        Cmp_ %ecx,%ebx
        jne  gnv14
        Mov_ %ebx,gnvnw
        Mov_ %edi,gnvst
gnv10:
        Mov_ %eax,(%esi)
        Cmp_ (%edi),%eax
        jnz  gnv11
        Add_ %edi,$cfp_b
        Add_ %esi,$cfp_b
        Dec_ %ebx
        jnz  gnv10
        Xor_ %eax,%eax
        Mov_ %edx,%eax
        Mov_ %ecx,$4*vrsi_
        Jmp_ gnv15
gnv11:
        Add_ %esi,$cfp_b
        Dec_ %ebx
        jnz  gnv11
        Sar_ %edx,$svnbt
gnv12:
        Mov_ %ebx,bits1
        And_ %ebx,%edx
        or   %ebx,%ebx
        jz   gnv13
        Add_ %esi,$cfp_b
gnv13:
        Sar_ %edx,$1
        or   %edx,%edx
        jnz  gnv12
        Jmp_ gnv09
gnv14:
        Mov_ %edx,%ecx
        Mov_ %ecx,$vrchs
        Add_ %ecx,gnvnw
        Sal_ %ecx,$2
gnv15:
        call alost
        Mov_ %ebx,%edi
        Mov_ %esi,$stnvr
        Mov_ %ecx,$4*vrlen
        Sar_ %ecx,$2
        rep  movsl
        Mov_ %esi,gnvhe
        Mov_ 24(%esi),%ebx
        Mov_ %eax,%edx
        stosl
        Mov_ %ecx,gnvnw
        Sal_ %ecx,$2
        or   %edx,%edx
        jz   gnv16
        Mov_ %esi,(%esp)
        Add_ %esi,$4*schar
        Sar_ %ecx,$2
        rep  movsl
        Mov_ %edi,%ebx
        Jmp_ gnv06
gnv16:
        Mov_ %esi,gnvsp
        Mov_ (%edi),%esi
        Mov_ %edi,%ebx
        Mov_ %ebx,0(%esi)
        Add_ %esi,$4*svchs
        Add_ %esi,%ecx
        Mov_ %edx,btknm
        And_ %edx,%ebx
        or   %edx,%edx
        jz   gnv17
        Add_ %esi,$cfp_b
gnv17:
        Mov_ %edx,btfnc
        And_ %edx,%ebx
        or   %edx,%edx
        jz   gnv18
        Mov_ 20(%edi),%esi
        Add_ %esi,$4*num02
gnv18:
        Mov_ %edx,btlbl
        And_ %edx,%ebx
        or   %edx,%edx
        jz   gnv19
        Mov_ 16(%edi),%esi
        Add_ %esi,$cfp_b
gnv19:
        Mov_ %edx,btval
        And_ %edx,%ebx
        or   %edx,%edx
        jz   gnv06
        Mov_ %eax,(%esi)
        Mov_ 8(%edi),%eax
        Mov_ 4(%edi),$b_vre
        Jmp_ gnv06
gtpat:
        Cmp_ (%edi),$p_aaa
        ja   gtpt5
        Mov_ gtpsb,%ebx
        push %edi
        call gtstg
        Dec_ _rc_
        js   call_239
        Dec_ _rc_
        jns  ppm_0433
        Jmp_ gtpt2
ppm_0433:
call_239:
        or   %ecx,%ecx
        jnz  gtpt1
        Mov_ %edi,$ndnth
        Jmp_ gtpt4
gtpt1:
        Mov_ %ebx,$p_str
        Cmp_ %ecx,$num01
        jne  gtpt3
        Add_ %edi,$cfp_f
#lch s.text (xr)  s.type 9  s.reg xr
#lch d.text wa  d.type 8  d.reg wa  w 0
        Xor_ %ecx,%ecx
        movb (%edi),%cl
        Mov_ %edi,%ecx
        Mov_ %ebx,$p_ans
        Jmp_ gtpt3
gtpt2:
        Mov_ %ebx,$p_exa
        Cmp_ (%edi),$b_e__
        jb   gtpt3
        Mov_ _rc_,$1
        ret
gtpt3:
        call pbild
gtpt4:
        Mov_ %ebx,gtpsb
gtpt5:
        Mov_ _rc_,$0
        ret
gtrea:
        Mov_ %ecx,(%edi)
        Cmp_ %ecx,$b_rcl
        je   gtre2
        call gtnum
        Dec_ _rc_
        js   call_240
        Dec_ _rc_
        jns  ppm_0434
        Jmp_ gtre3
ppm_0434:
call_240:
        Cmp_ %ecx,$b_rcl
        je   gtre2
gtre1:
        ldi_ 4(%edi)
        call itr_
        call rcbld
gtre2:
        Mov_ _rc_,$0
        ret
gtre3:
        Mov_ _rc_,$1
        ret
gtsmi:
        pop  prc_+4*5
        pop  %edi
        Cmp_ (%edi),$_b_icl
        je   gtsm1
        call gtint
        Dec_ _rc_
        js   call_241
        Dec_ _rc_
        jns  ppm_0435
        Jmp_ gtsm2
ppm_0435:
call_241:
gtsm1:
        ldi_ 4(%edi)
        sti_ %eax
        or   %eax,%eax
        js   gtsm3
        sti_ %edx
        Cmp_ %edx,mxlen
        ja   gtsm3
        Mov_ %edi,%edx
        Mov_ _rc_,$0
        Mov_ %eax,prc_+4*5
        Jmp_ *%eax
gtsm2:
        Mov_ _rc_,$1
        Mov_ %eax,prc_+4*5
        Jmp_ *%eax
gtsm3:
        Mov_ _rc_,$2
        Mov_ %eax,prc_+4*5
        Jmp_ *%eax
gtstg:
        pop  prc_+4*6
        pop  %edi
        Cmp_ (%edi),$_b_scl
        je   gts30
gts01:
        push %edi
        push %esi
        Mov_ gtsvb,%ebx
        Mov_ gtsvc,%edx
        Mov_ %ecx,(%edi)
        Cmp_ %ecx,$_b_icl
        je   gts05
        Cmp_ %ecx,$b_rcl
        je   gts10
        Cmp_ %ecx,$b_nml
        je   gts03
gts02:
        pop  %esi
        pop  %edi
        Mov_ _rc_,$1
        Mov_ %eax,prc_+4*6
        Jmp_ *%eax
gts03:
        Mov_ %esi,4(%edi)
        Cmp_ %esi,_state
        ja   gts02
        Add_ %esi,$4*vrsof
        Mov_ %ecx,4(%esi)
        or   %ecx,%ecx
        jnz  gts04
        Mov_ %esi,8(%esi)
        Mov_ %ecx,4(%esi)
gts04:
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        call sbstr
        Jmp_ gts29
gts05:
        ldi_ 4(%edi)
        Mov_ gtssf,$num01
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jl   gts06
        ngi_
        Xor_ %eax,%eax
        Mov_ gtssf,%eax
gts06:
        Mov_ %edi,gtswk
        Mov_ %ebx,$nstmx
        Add_ %edi,%ebx
        Add_ %edi,$cfp_f
gts07:
        cvd_
#sch s.text wa  s.type 8  s.reg wa
#sch d.text -(xr)  d.type 11  d.reg xr  w 0
        dec  %edi
        movb %cl,(%edi)
        Dec_ %ebx
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jne  gts07
gts08:
        Mov_ %ecx,$nstmx
        Sub_ %ecx,%ebx
        Mov_ %esi,%ecx
        Add_ %ecx,gtssf
        call alocs
        Mov_ %edx,%edi
        Add_ %edi,$cfp_f
        Xor_ %eax,%eax
        Cmp_ gtssf,%eax
        jz   gts09
        Mov_ %ecx,$ch_mn
#sch s.text wa  s.type 8  s.reg wa
#sch d.text (xr)+  d.type 10  d.reg xr  w 0
        movb %cl,(%edi)
        Inc_ %edi
gts09:
        Mov_ %ecx,%esi
        Mov_ %esi,gtswk
        Add_ %esi,%ebx
        Add_ %esi,$cfp_f
        rep  movsb
        Mov_ %edi,%edx
        Jmp_ gts29
gts10:
        Mov_ %eax,%edi
        Add_ %eax,(cfp_b*rcval)
        call ldr_
        Xor_ %eax,%eax
        Mov_ gtssf,%eax
        call cpr_
        movb reg_fl,%al
        or   %al,%al
        je   gts31
        call cpr_
        movb reg_fl,%al
        or   %al,%al
        jge  gts11
        Mov_ gtssf,$num01
        call ngr_
gts11:
        ldi_ intv0
gts12:
        Mov_ %eax,$gtsrs
        call str_
        Mov_ %eax,$reap1
        call sbr_
        call cpr_
        movb reg_fl,%al
        or   %al,%al
        jge  gts13
        Mov_ %eax,$gtsrs
        call ldr_
        Mov_ %eax,$reatt
        call mlr_
        Mov_ %eax,intvt
        sbi_
        Jmp_ gts12
gts13:
        Mov_ %eax,$gtsrs
        call ldr_
        Mov_ %eax,$reav1
        call sbr_
        call cpr_
        movb reg_fl,%al
        or   %al,%al
        jl   gts17
        Mov_ %eax,$gtsrs
        call ldr_
gts14:
        Mov_ %eax,$reatt
        call sbr_
        call cpr_
        movb reg_fl,%al
        or   %al,%al
        jl   gts15
        Mov_ %eax,$gtsrs
        call ldr_
        Mov_ %eax,$reatt
        call dvr_
        Mov_ %eax,$gtsrs
        call str_
        Mov_ %eax,intvt
        adi_
        Jmp_ gts14
gts15:
        Mov_ %edi,$reav1
gts16:
        Mov_ %eax,$gtsrs
        call ldr_
        Mov_ %eax,intv1
        adi_
        Add_ %edi,$4*cfp_r
        Mov_ %eax,%edi
        call sbr_
        call cpr_
        movb reg_fl,%al
        or   %al,%al
        jge  gts16
        Mov_ %eax,$gtsrs
        call ldr_
        Mov_ %eax,%edi
        call dvr_
        Mov_ %eax,$gtsrs
        call str_
gts17:
        Mov_ %eax,$gtsrs
        call ldr_
        Mov_ %eax,$gtsrn
        call adr_
        Mov_ %eax,$gtsrs
        call str_
        Mov_ %eax,$reav1
        call sbr_
        call cpr_
        movb reg_fl,%al
        or   %al,%al
        jl   gts18
        Mov_ %eax,intv1
        adi_
        Mov_ %eax,$gtsrs
        call ldr_
        Mov_ %eax,$reavt
        call dvr_
        Jmp_ gts19
gts18:
        Mov_ %eax,$gtsrs
        call ldr_
gts19:
        Mov_ %esi,$cfp_s
        Mov_ gtses,$ch_mn
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jl   gts21
        sti_ %ecx
        Cmp_ %ecx,$cfp_s
        jbe  gts20
        ldi_ %ecx
        ngi_
        Mov_ gtses,$ch_pl
        Jmp_ gts21
gts20:
        Sub_ %esi,%ecx
        ldi_ intv0
gts21:
        Mov_ %edi,gtswk
        Mov_ %ebx,$nstmx
        Add_ %edi,%ebx
        Add_ %edi,$cfp_f
        Mov_ %eax,reg_ia
        or   %eax,%eax
        je   gts23
gts22:
        cvd_
#sch s.text wa  s.type 8  s.reg wa
#sch d.text -(xr)  d.type 11  d.reg xr  w 0
        dec  %edi
        movb %cl,(%edi)
        Dec_ %ebx
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jne  gts22
        Mov_ %ecx,gtses
#sch s.text wa  s.type 8  s.reg wa
#sch d.text -(xr)  d.type 11  d.reg xr  w 0
        dec  %edi
        movb %cl,(%edi)
        Mov_ %ecx,$ch_le
#sch s.text wa  s.type 8  s.reg wa
#sch d.text -(xr)  d.type 11  d.reg xr  w 0
        dec  %edi
        movb %cl,(%edi)
        Sub_ %ebx,$num02
gts23:
        Mov_ %eax,$gtssc
        call mlr_
        call rti_
        ngi_
gts24:
        or   %esi,%esi
        jz   gts27
        cvd_
        Cmp_ %ecx,$ch_d0
        jne  gts26
        Dec_ %esi
        Jmp_ gts24
gts25:
        cvd_
gts26:
#sch s.text wa  s.type 8  s.reg wa
#sch d.text -(xr)  d.type 11  d.reg xr  w 0
        dec  %edi
        movb %cl,(%edi)
        Dec_ %ebx
        Dec_ %esi
        or   %esi,%esi
        jnz  gts25
gts27:
        Mov_ %ecx,$ch_dt
#sch s.text wa  s.type 8  s.reg wa
#sch d.text -(xr)  d.type 11  d.reg xr  w 0
        dec  %edi
        movb %cl,(%edi)
        Dec_ %ebx
gts28:
        cvd_
#sch s.text wa  s.type 8  s.reg wa
#sch d.text -(xr)  d.type 11  d.reg xr  w 0
        dec  %edi
        movb %cl,(%edi)
        Dec_ %ebx
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jne  gts28
        Jmp_ gts08
gts29:
        pop  %esi
        Add_ %esp,$cfp_b
        Mov_ %ebx,gtsvb
        Mov_ %edx,gtsvc
gts30:
        Mov_ %ecx,4(%edi)
        Mov_ _rc_,$0
        Mov_ %eax,prc_+4*6
        Jmp_ *%eax
gts31:
        Mov_ %esi,$scre0
        Mov_ %ecx,$num02
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        call sbstr
        Jmp_ gts29
gtvar:
        Cmp_ (%edi),$b_nml
        jne  gtvr2
        Mov_ %ecx,8(%edi)
        Mov_ %esi,4(%edi)
        Cmp_ (%esi),$b_evt
        je   gtvr1
        Cmp_ (%esi),$b_kvt
        jne  gtvr3
gtvr1:
        Mov_ _rc_,$1
        ret
gtvr2:
        Mov_ gtvrc,%edx
        call gtnvr
        Dec_ _rc_
        js   call_242
        Dec_ _rc_
        jns  ppm_0437
        Jmp_ gtvr1
ppm_0437:
call_242:
        Mov_ %esi,%edi
        Mov_ %ecx,$4*vrval
        Mov_ %edx,gtvrc
gtvr3:
        Cmp_ %esi,_state
        ja   gtvr4
        Cmp_ 4(%esi),$b_vre
        je   gtvr1
gtvr4:
        Mov_ _rc_,$0
        ret
hashs:
        Mov_ %edx,$e_hnw
        or   %edx,%edx
        jz   hshsa
        Mov_ %edx,4(%edi)
        Mov_ %ebx,%edx
        or   %edx,%edx
        jz   hshs3
        nop
        mov  %edx,ctbw_r
        movl $0,ctbw_v
        call ctw_
        movl ctbw_r,%edx
        Add_ %edi,$4*schar
        Cmp_ %edx,$e_hnw
        jb   hshs1
        Mov_ %edx,$e_hnw
hshs1:
hshs2:
        Xor_ %ebx,(%edi)
        Add_ %edi,$4
        Dec_ %edx
        jnz  hshs2
hshs3:
        nop
        And_ %ebx,bitsm
        ldi_ %ebx
        Xor_ %eax,%eax
        Mov_ %edi,%eax
        ret
hshsa:
        Mov_ %edx,4(%edi)
        Mov_ %ebx,%edx
        or   %edx,%edx
        jz   hshs3
        nop
        mov  %edx,ctbw_r
        movl $0,ctbw_v
        call ctw_
        movl ctbw_r,%edx
        Add_ %edi,$cfp_f
        push %esi
        Mov_ %esi,%edx
        Cmp_ %esi,$num25
        jae  hsh24
        jmp  *bsw_0438(,%esi,4)
        Data
bsw_0438:
        .long hsh00
        .long hsh01
        .long hsh02
        .long hsh03
        .long hsh04
        .long hsh05
        .long hsh06
        .long hsh07
        .long hsh08
        .long hsh09
        .long hsh10
        .long hsh11
        .long hsh12
        .long hsh13
        .long hsh14
        .long hsh15
        .long hsh16
        .long hsh17
        .long hsh18
        .long hsh19
        .long hsh20
        .long hsh21
        .long hsh22
        .long hsh23
        .long hsh24
        Text
hsh24:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Inc_ %edi
        Sal_ %edx,$24
        Xor_ %ebx,%edx
hsh23:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Inc_ %edi
        Sal_ %edx,$16
        Xor_ %ebx,%edx
hsh22:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Inc_ %edi
        Sal_ %edx,$8
        Xor_ %ebx,%edx
hsh21:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Inc_ %edi
        Xor_ %ebx,%edx
hsh20:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Inc_ %edi
        Sal_ %edx,$24
        Xor_ %ebx,%edx
hsh19:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Inc_ %edi
        Sal_ %edx,$16
        Xor_ %ebx,%edx
hsh18:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Inc_ %edi
        Sal_ %edx,$8
        Xor_ %ebx,%edx
hsh17:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Inc_ %edi
        Xor_ %ebx,%edx
hsh16:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Inc_ %edi
        Sal_ %edx,$24
        Xor_ %ebx,%edx
hsh15:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Inc_ %edi
        Sal_ %edx,$16
        Xor_ %ebx,%edx
hsh14:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Inc_ %edi
        Sal_ %edx,$8
        Xor_ %ebx,%edx
hsh13:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Inc_ %edi
        Xor_ %ebx,%edx
hsh12:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Inc_ %edi
        Sal_ %edx,$24
        Xor_ %ebx,%edx
hsh11:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Inc_ %edi
        Sal_ %edx,$16
        Xor_ %ebx,%edx
hsh10:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Inc_ %edi
        Sal_ %edx,$8
        Xor_ %ebx,%edx
hsh09:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Inc_ %edi
        Xor_ %ebx,%edx
hsh08:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Inc_ %edi
        Sal_ %edx,$24
        Xor_ %ebx,%edx
hsh07:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Inc_ %edi
        Sal_ %edx,$16
        Xor_ %ebx,%edx
hsh06:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Inc_ %edi
        Sal_ %edx,$8
        Xor_ %ebx,%edx
hsh05:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Inc_ %edi
        Xor_ %ebx,%edx
hsh04:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Inc_ %edi
        Sal_ %edx,$24
        Xor_ %ebx,%edx
hsh03:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Inc_ %edi
        Sal_ %edx,$16
        Xor_ %ebx,%edx
hsh02:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Inc_ %edi
        Sal_ %edx,$8
        Xor_ %ebx,%edx
hsh01:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Inc_ %edi
        Xor_ %ebx,%edx
hsh00:
        pop  %esi
        Jmp_ hshs3
icbld:
        sti_ %eax
        or   %eax,%eax
        js   icbl1
        sti_ %edi
        Cmp_ %edi,$num02
        jbe  icbl3
icbl1:
        Mov_ %edi,_dnamp
        Add_ %edi,$4*icsi_
        Cmp_ %edi,dname
        jb   icbl2
        Mov_ %ecx,$4*icsi_
        call alloc
        Add_ %edi,%ecx
icbl2:
        Mov_ _dnamp,%edi
        Sub_ %edi,$4*icsi_
        Mov_ (%edi),$_b_icl
        sti_ 4(%edi)
        ret
icbl3:
        Sal_ %edi,$2
        Mov_ %edi,intab(%edi)
        ret
ident:
        Cmp_ %edi,%esi
        je   iden7
        Mov_ %edx,(%edi)
        Cmp_ %edx,(%esi)
        jne  iden1
        Cmp_ %edx,$_b_scl
        je   iden2
        Cmp_ %edx,$_b_icl
        je   iden4
        Cmp_ %edx,$b_rcl
        je   iden5
        Cmp_ %edx,$b_nml
        je   iden6
iden1:
        Mov_ _rc_,$0
        ret
iden2:
        Mov_ %edx,4(%edi)
        Cmp_ %edx,4(%esi)
        jne  iden1
idn2a:
        Add_ %edi,$4*schar
        Add_ %esi,$4*schar
        mov  %edx,ctbw_r
        movl $0,ctbw_v
        call ctw_
        movl ctbw_r,%edx
iden3:
        Mov_ %eax,(%esi)
        Cmp_ (%edi),%eax
        jnz  iden8
        Add_ %edi,$cfp_b
        Add_ %esi,$cfp_b
        Dec_ %edx
        jnz  iden3
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        Xor_ %eax,%eax
        Mov_ %edi,%eax
        Mov_ _rc_,$1
        ret
iden4:
        ldi_ 4(%edi)
        Mov_ %eax,4(%esi)
        sbi_
        iov_ iden1
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jne  iden1
        Mov_ _rc_,$1
        ret
iden5:
        Mov_ %eax,%edi
        Add_ %eax,(cfp_b*rcval)
        call ldr_
        Mov_ %eax,%esi
        Add_ %eax,(cfp_b*rcval)
        call sbr_
        rov_ iden1
        call cpr_
        movb reg_fl,%al
        or   %al,%al
        jne  iden1
        Mov_ _rc_,$1
        ret
iden6:
        Mov_ %eax,8(%esi)
        Cmp_ 8(%edi),%eax
        jne  iden1
        Mov_ %eax,4(%esi)
        Cmp_ 4(%edi),%eax
        jne  iden1
iden7:
        Mov_ _rc_,$1
        ret
iden8:
        Xor_ %eax,%eax
        Mov_ %edi,%eax
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        Mov_ _rc_,$0
        ret
inout:
        push %ebx
        Mov_ %ecx,4(%esi)
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        call sbstr
        call gtnvr
        Dec_ _rc_
        js   call_243
        Dec_ _rc_
        jns  ppm_0439
        Mov_ _rc_,$299
        Jmp_ err_
ppm_0439:
call_243:
        Mov_ %edx,%edi
        pop  %ebx
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        call trbld
        Mov_ %esi,%edx
        Mov_ %eax,32(%esi)
        Mov_ 12(%edi),%eax
        Mov_ 8(%esi),%edi
        Mov_ 0(%esi),$b_vra
        Mov_ 4(%esi),$b_vrv
        ret
insta:
        Mov_ %edx,prlen
        Mov_ prbuf,%edi
        Mov_ %eax,$_b_scl
        stosl
        Mov_ %eax,%edx
        stosl
        mov  %edx,ctbw_r
        movl $0,ctbw_v
        call ctw_
        movl ctbw_r,%edx
        Mov_ prlnw,%edx
inst1:
        Mov_ %eax,nullw
        stosl
        Dec_ %edx
        jnz  inst1
        Mov_ %ecx,$nstmx
        mov  %ecx,ctbw_r
        movl $scsi_,ctbw_v
        call ctb_
        movl ctbw_r,%ecx
        Mov_ gtswk,%edi
        Add_ %edi,%ecx
        Mov_ kvalp,%edi
        Mov_ (%edi),$_b_scl
        Mov_ %edx,$cfp_a
        Mov_ 4(%edi),%edx
        Mov_ %ebx,%edx
        mov  %ebx,ctbw_r
        movl $scsi_,ctbw_v
        call ctb_
        movl ctbw_r,%ebx
        Add_ %ebx,%edi
        Mov_ %ecx,%ebx
        Add_ %edi,$cfp_f
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
inst2:
#sch s.text wb  s.type 8  s.reg wb
#sch d.text (xr)+  d.type 10  d.reg xr  w 0
        movb %bl,(%edi)
        Inc_ %edi
        Inc_ %ebx
        Dec_ %edx
        jnz  inst2
        Mov_ %edi,%ecx
        ret
iofcb:
        pop  prc_+4*7
        call gtstg
        Dec_ _rc_
        js   call_244
        Dec_ _rc_
        jns  ppm_0440
        Jmp_ iofc2
ppm_0440:
call_244:
        Mov_ %esi,%edi
        call gtnvr
        Dec_ _rc_
        js   call_245
        Dec_ _rc_
        jns  ppm_0441
        Jmp_ iofc3
ppm_0441:
call_245:
        Mov_ %ebx,%esi
        Mov_ %esi,%edi
        Xor_ %eax,%eax
        Mov_ %ecx,%eax
iofc1:
        Mov_ %edi,8(%edi)
        Cmp_ (%edi),$b_trt
        jne  iofc4
        Cmp_ 4(%edi),$trtfc
        jne  iofc1
        Mov_ %ecx,16(%edi)
        Mov_ %edi,%ebx
        Mov_ _rc_,$0
        Mov_ %eax,prc_+4*7
        Jmp_ *%eax
iofc2:
        Mov_ _rc_,$1
        Mov_ %eax,prc_+4*7
        Jmp_ *%eax
iofc3:
        Mov_ _rc_,$2
        Mov_ %eax,prc_+4*7
        Jmp_ *%eax
iofc4:
        Mov_ _rc_,$3
        Mov_ %eax,prc_+4*7
        Jmp_ *%eax
ioppf:
        pop  prc_+4*8
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
iopp1:
        Mov_ %esi,$iodel
        Mov_ %edx,%esi
        Xor_ %eax,%eax
        Mov_ %ecx,%eax
        call xscan
        push %edi
        Inc_ %ebx
        or   %ecx,%ecx
        jnz  iopp1
        Mov_ %edx,%ebx
        Mov_ %ebx,ioptt
        Mov_ %ecx,r_iof
        Mov_ %edi,r_io2
        Mov_ %esi,r_io1
        Mov_ _rc_,$0
        Mov_ %eax,prc_+4*8
        Jmp_ *%eax
ioput:
        pop  prc_+4*9
        Xor_ %eax,%eax
        Mov_ r_iot,%eax
        Xor_ %eax,%eax
        Mov_ r_iof,%eax
        Xor_ %eax,%eax
        Mov_ r_iop,%eax
        Mov_ ioptt,%ebx
        call xscni
        Dec_ _rc_
        js   call_246
        Dec_ _rc_
        jns  ppm_0442
        Jmp_ iop13
ppm_0442:
        Dec_ _rc_
        jns  ppm_0443
        Jmp_ iopa0
ppm_0443:
call_246:
iopa0:
        Mov_ r_io2,%edi
        Mov_ %esi,%ecx
        call gtstg
        Dec_ _rc_
        js   call_247
        Dec_ _rc_
        jns  ppm_0444
        Jmp_ iop14
ppm_0444:
call_247:
        Mov_ r_io1,%edi
        call gtnvr
        Dec_ _rc_
        js   call_248
        Dec_ _rc_
        jns  ppm_0445
        Jmp_ iop00
ppm_0445:
call_248:
        Jmp_ iop04
iop00:
        or   %esi,%esi
        jz   iop01
        call ioppf
        call sysfc
        Dec_ _rc_
        js   call_249
        Dec_ _rc_
        jns  ppm_0446
        Jmp_ iop16
ppm_0446:
        Dec_ _rc_
        jns  ppm_0447
        Jmp_ iop26
ppm_0447:
call_249:
        Jmp_ iop11
iop01:
        Mov_ %ebx,ioptt
        Mov_ %edi,r_iot
        call trbld
        Mov_ %edx,%edi
        pop  %edi
        push %edx
        call gtvar
        Dec_ _rc_
        js   call_250
        Dec_ _rc_
        jns  ppm_0448
        Jmp_ iop15
ppm_0448:
call_250:
        pop  %edx
        Mov_ r_ion,%esi
        Mov_ %edi,%esi
        Add_ %edi,%ecx
        Sub_ %edi,$4*vrval
iop02:
        Mov_ %esi,%edi
        Mov_ %edi,8(%edi)
        Cmp_ (%edi),$b_trt
        jne  iop03
        Mov_ %eax,ioptt
        Cmp_ 4(%edi),%eax
        jne  iop02
        Mov_ %edi,8(%edi)
iop03:
        Mov_ 8(%esi),%edx
        Mov_ %esi,%edx
        Mov_ 8(%esi),%edi
        Mov_ %edi,r_ion
        Mov_ %ebx,%ecx
        call setvr
        Mov_ %edi,r_iot
        or   %edi,%edi
        jnz  iop19
        Mov_ _rc_,$0
        Mov_ %eax,prc_+4*9
        Jmp_ *%eax
iop04:
        Xor_ %eax,%eax
        Mov_ %ecx,%eax
iop05:
        Mov_ %ebx,%edi
        Mov_ %edi,8(%edi)
        Cmp_ (%edi),$b_trt
        jne  iop06
        Cmp_ 4(%edi),$trtfc
        jne  iop05
        Mov_ r_iot,%edi
        Mov_ %ecx,16(%edi)
iop06:
        Mov_ r_iof,%ecx
        Mov_ r_iop,%ebx
        call ioppf
        call sysfc
        Dec_ _rc_
        js   call_251
        Dec_ _rc_
        jns  ppm_0449
        Jmp_ iop16
ppm_0449:
        Dec_ _rc_
        jns  ppm_0450
        Jmp_ iop26
ppm_0450:
call_251:
        or   %ecx,%ecx
        jz   iop12
        Cmp_ %edx,$num02
        jb   iop6a
        call alost
        Jmp_ iop6b
iop6a:
        call alloc
iop6b:
        Mov_ %esi,%edi
        Mov_ %ebx,%ecx
        Sar_ %ebx,$2
iop07:
        Xor_ %eax,%eax
        Mov_ %eax,%eax
        stosl
        Dec_ %ebx
        jnz  iop07
        Cmp_ %edx,$num02
        je   iop09
        Mov_ (%esi),$_b_xnt
        Mov_ 4(%esi),%ecx
        or   %edx,%edx
        jnz  iop09
        Mov_ (%esi),$_b_xrt
iop09:
        Mov_ %edi,r_iot
        Mov_ r_iof,%esi
        or   %edi,%edi
        jnz  iop10
        Mov_ %ebx,$trtfc
        call trbld
        Mov_ r_iot,%edi
        Mov_ %esi,r_iop
        Mov_ %eax,8(%esi)
        Mov_ 8(%edi),%eax
        Mov_ 8(%esi),%edi
        Mov_ %edi,%esi
        call setvr
        Mov_ %edi,8(%edi)
        Jmp_ iop1a
iop10:
        Xor_ %eax,%eax
        Mov_ r_iop,%eax
iop1a:
        Mov_ %eax,r_iof
        Mov_ 16(%edi),%eax
iop11:
        Mov_ %ecx,r_iof
        Mov_ %ebx,ioptt
        Mov_ %edi,r_io2
        Mov_ %esi,r_io1
        call sysio
        Dec_ _rc_
        js   call_252
        Dec_ _rc_
        jns  ppm_0451
        Jmp_ iop17
ppm_0451:
        Dec_ _rc_
        jns  ppm_0452
        Jmp_ iop18
ppm_0452:
call_252:
        Xor_ %eax,%eax
        Cmp_ r_iot,%eax
        jnz  iop01
        Xor_ %eax,%eax
        Cmp_ ioptt,%eax
        jnz  iop01
        or   %edx,%edx
        jz   iop01
        Mov_ cswin,%edx
        Jmp_ iop01
iop12:
        or   %esi,%esi
        jnz  iop09
        Jmp_ iop11
iop13:
        Mov_ _rc_,$1
        Mov_ %eax,prc_+4*9
        Jmp_ *%eax
iop14:
        Mov_ _rc_,$2
        Mov_ %eax,prc_+4*9
        Jmp_ *%eax
iop15:
        Add_ %esp,$cfp_b
        Mov_ _rc_,$3
        Mov_ %eax,prc_+4*9
        Jmp_ *%eax
iop16:
        Mov_ _rc_,$4
        Mov_ %eax,prc_+4*9
        Jmp_ *%eax
iop26:
        Mov_ _rc_,$7
        Mov_ %eax,prc_+4*9
        Jmp_ *%eax
iop17:
        Mov_ %edi,r_iop
        or   %edi,%edi
        jz   iopa7
        Mov_ %esi,8(%edi)
        Mov_ %eax,8(%esi)
        Mov_ 8(%edi),%eax
        call setvr
iopa7:
        Mov_ _rc_,$5
        Mov_ %eax,prc_+4*9
        Jmp_ *%eax
iop18:
        Mov_ %edi,r_iop
        or   %edi,%edi
        jz   iopa7
        Mov_ %esi,8(%edi)
        Mov_ %eax,8(%esi)
        Mov_ 8(%edi),%eax
        call setvr
iopa8:
        Mov_ _rc_,$6
        Mov_ %eax,prc_+4*9
        Jmp_ *%eax
iop19:
        Mov_ %edx,r_ion
iop20:
        Mov_ %edi,12(%edi)
        or   %edi,%edi
        jz   iop21
        Cmp_ %edx,8(%edi)
        jne  iop20
        Cmp_ %ebx,16(%edi)
        je   iop22
        Jmp_ iop20
iop21:
        Mov_ %ecx,$4*num05
        call alloc
        Mov_ (%edi),$_b_xrt
        Mov_ 4(%edi),%ecx
        Mov_ 8(%edi),%edx
        Mov_ 16(%edi),%ebx
        Mov_ %esi,r_iot
        Mov_ %ecx,12(%esi)
        Mov_ 12(%esi),%edi
        Mov_ 12(%edi),%ecx
iop22:
        Xor_ %eax,%eax
        Cmp_ r_iof,%eax
        jz   iop25
        Mov_ %esi,_r_fcb
iop23:
        or   %esi,%esi
        jz   iop24
        Mov_ %eax,r_iof
        Cmp_ 12(%esi),%eax
        je   iop25
        Mov_ %esi,8(%esi)
        Jmp_ iop23
iop24:
        Mov_ %ecx,$4*num04
        call alloc
        Mov_ (%edi),$_b_xrt
        Mov_ 4(%edi),%ecx
        Mov_ %eax,_r_fcb
        Mov_ 8(%edi),%eax
        Mov_ %eax,r_iof
        Mov_ 12(%edi),%eax
        Mov_ _r_fcb,%edi
iop25:
        Mov_ _rc_,$0
        Mov_ %eax,prc_+4*9
        Jmp_ *%eax
ktrex:
        or   %esi,%esi
        jz   ktrx3
        Xor_ %eax,%eax
        Cmp_ kvtra,%eax
        jz   ktrx3
        Dec_ kvtra
        push %edi
        Mov_ %edi,%esi
        Mov_ %esi,8(%edi)
        Mov_ %ecx,$4*vrval
        Xor_ %eax,%eax
        Cmp_ 16(%edi),%eax
        jz   ktrx1
        call trxeq
        Jmp_ ktrx2
ktrx1:
        push %esi
        push %ecx
        call prtsn
        Mov_ %ecx,$ch_am
        call prtch
        call prtnm
        Mov_ %edi,$tmbeb
        call prtst
        call kwnam
        Mov_ _dnamp,%edi
        call acess
        Dec_ _rc_
        js   call_253
        Dec_ _rc_
        jns  ppm_0453
        Mov_ _rc_,$299
        Jmp_ err_
ppm_0453:
call_253:
        call prtvl
        call prtnl
ktrx2:
        pop  %edi
ktrx3:
        ret
kwnam:
        pop  prc_+4*10
        Add_ %esp,$cfp_b
        pop  %edi
        Cmp_ %edi,_state
        jae  kwnm1
        Xor_ %eax,%eax
        Cmp_ 28(%edi),%eax
        jnz  kwnm1
        Mov_ %edi,32(%edi)
        Mov_ %ecx,0(%edi)
        And_ %ecx,btknm
        or   %ecx,%ecx
        jz   kwnm1
        Mov_ %ecx,4(%edi)
        mov  %ecx,ctbw_r
        movl $svchs,ctbw_v
        call ctb_
        movl ctbw_r,%ecx
        Add_ %edi,%ecx
        Mov_ %ebx,(%edi)
        Mov_ %ecx,$4*kvsi_
        call alloc
        Mov_ (%edi),$b_kvt
        Mov_ 8(%edi),%ebx
        Mov_ 4(%edi),$trbkv
        Mov_ %esi,%edi
        Mov_ %ecx,$4*kvvar
        Mov_ _rc_,$0
        Mov_ %eax,prc_+4*10
        Jmp_ *%eax
kwnm1:
        Mov_ _rc_,$251
        Jmp_ err_
lcomp:
        pop  prc_+4*11
        call gtstg
        Dec_ _rc_
        js   call_254
        Dec_ _rc_
        jns  ppm_0454
        Jmp_ lcmp6
ppm_0454:
call_254:
        Mov_ %esi,%edi
        Mov_ %edx,%ecx
        call gtstg
        Dec_ _rc_
        js   call_255
        Dec_ _rc_
        jns  ppm_0455
        Jmp_ lcmp5
ppm_0455:
call_255:
        Mov_ %ebx,%ecx
        Add_ %edi,$cfp_f
        Add_ %esi,$cfp_f
        Cmp_ %ecx,%edx
        jb   lcmp1
        Mov_ %ecx,%edx
lcmp1:
        or   %ecx,%ecx
        jz   lcmp7
        repe cmpsb
        Xor_ %esi,%esi
        Xor_ %edi,%esi
        ja   lcmp3
        jb   lcmp4
lcmp7:
        Cmp_ %ebx,%edx
        jne  lcmp2
        Mov_ _rc_,$4
        Mov_ %eax,prc_+4*11
        Jmp_ *%eax
lcmp2:
        Cmp_ %ebx,%edx
        ja   lcmp4
lcmp3:
        Mov_ _rc_,$3
        Mov_ %eax,prc_+4*11
        Jmp_ *%eax
lcmp4:
        Mov_ _rc_,$5
        Mov_ %eax,prc_+4*11
        Jmp_ *%eax
lcmp5:
        Mov_ _rc_,$1
        Mov_ %eax,prc_+4*11
        Jmp_ *%eax
lcmp6:
        Mov_ _rc_,$2
        Mov_ %eax,prc_+4*11
        Jmp_ *%eax
listr:
        Xor_ %eax,%eax
        Cmp_ cnttl,%eax
        jnz  list5
        Xor_ %eax,%eax
        Cmp_ lstpf,%eax
        jnz  list4
        Mov_ %eax,lstnp
        Cmp_ lstlc,%eax
        jae  list6
list0:
        Mov_ %edi,r_cim
        or   %edi,%edi
        jz   list4
        Add_ %edi,$cfp_f
#lch s.text (xr)  s.type 9  s.reg xr
#lch d.text wa  d.type 8  d.reg wa  w 0
        Xor_ %ecx,%ecx
        movb (%edi),%cl
        Mov_ %edi,lstsn
        or   %edi,%edi
        jz   list2
        ldi_ %edi
        Cmp_ stage,$stgic
        jne  list1
        Cmp_ %ecx,$ch_as
        je   list2
        Cmp_ %ecx,$ch_mn
        je   list2
list1:
        call prtin
        Xor_ %eax,%eax
        Mov_ lstsn,%eax
list2:
        Mov_ %edi,lstid
        or   %edi,%edi
        jz   list8
        Mov_ %ecx,$stnpd
        Sub_ %ecx,$num03
        Mov_ profs,%ecx
        ldi_ %edi
        call prtin
list8:
        Mov_ profs,$stnpd
        Mov_ %edi,r_cim
        call prtst
        Inc_ lstlc
        Xor_ %eax,%eax
        Cmp_ erlst,%eax
        jnz  list3
        call prtnl
        Xor_ %eax,%eax
        Cmp_ cswdb,%eax
        jz   list3
        call prtnl
        Inc_ lstlc
list3:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ lstpf,%eax
list4:
        ret
list5:
        Xor_ %eax,%eax
        Mov_ cnttl,%eax
list6:
        call prtps
        Xor_ %eax,%eax
        Cmp_ prich,%eax
        jz   list7
        Cmp_ r_ttl,$nulls
        je   list0
list7:
        call listt
        Jmp_ list0
listt:
        Mov_ %edi,r_ttl
        call prtst
        Mov_ %eax,lstpo
        Mov_ profs,%eax
        Mov_ %edi,$lstms
        call prtst
        Inc_ lstpg
        ldi_ lstpg
        call prtin
        call prtnl
        Add_ lstlc,$num02
        Mov_ %edi,r_stl
        or   %edi,%edi
        jz   lstt1
        call prtst
        call prtnl
        Inc_ lstlc
lstt1:
        call prtnl
        ret
newfn:
        push %edi
        Mov_ %esi,r_sfc
        call ident
        Dec_ _rc_
        js   call_256
        Dec_ _rc_
        jns  ppm_0456
        Jmp_ nwfn1
ppm_0456:
call_256:
        pop  %edi
        Mov_ r_sfc,%edi
        Mov_ %ebx,cmpsn
        ldi_ %ebx
        call icbld
        Mov_ %esi,r_sfn
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %ebx,%eax
        call tfind
        Dec_ _rc_
        js   call_257
        Dec_ _rc_
        jns  ppm_0457
        Mov_ _rc_,$299
        Jmp_ err_
ppm_0457:
call_257:
        Mov_ %eax,r_sfc
        Mov_ 8(%esi),%eax
        ret
nwfn1:
        Add_ %esp,$cfp_b
        ret
nexts:
        Xor_ %eax,%eax
        Cmp_ cswls,%eax
        jz   nxts2
        Mov_ %edi,r_cim
        or   %edi,%edi
        jz   nxts2
        Add_ %edi,$cfp_f
#lch s.text (xr)  s.type 9  s.reg xr
#lch d.text wa  d.type 8  d.reg wa  w 0
        Xor_ %ecx,%ecx
        movb (%edi),%cl
        Cmp_ %ecx,$ch_mn
        jne  nxts1
        Xor_ %eax,%eax
        Cmp_ cswpr,%eax
        jz   nxts2
nxts1:
        call listr
nxts2:
        Mov_ %edi,r_cni
        Mov_ r_cim,%edi
        Mov_ %eax,rdnln
        Mov_ rdcln,%eax
        Mov_ %eax,cnind
        Mov_ lstid,%eax
        Xor_ %eax,%eax
        Mov_ r_cni,%eax
        Mov_ %ecx,4(%edi)
        Mov_ %ebx,cswin
        Cmp_ %ecx,%ebx
        jb   nxts3
        Mov_ %ecx,%ebx
nxts3:
        Mov_ scnil,%ecx
        Xor_ %eax,%eax
        Mov_ scnse,%eax
        Xor_ %eax,%eax
        Mov_ lstpf,%eax
        ret
patin:
        pop  prc_+4*12
        Mov_ %esi,%ecx
        call gtsmi
        Dec_ _rc_
        js   call_258
        Dec_ _rc_
        jns  ppm_0458
        Jmp_ ptin2
ppm_0458:
        Dec_ _rc_
        jns  ppm_0459
        Jmp_ ptin3
ppm_0459:
call_258:
ptin1:
        call pbild
        Mov_ _rc_,$0
        Mov_ %eax,prc_+4*12
        Jmp_ *%eax
ptin2:
        Mov_ %ebx,%esi
        Cmp_ (%edi),$b_e__
        jb   ptin1
        Mov_ _rc_,$1
        Mov_ %eax,prc_+4*12
        Jmp_ *%eax
ptin3:
        Mov_ _rc_,$2
        Mov_ %eax,prc_+4*12
        Jmp_ *%eax
patst:
        pop  prc_+4*13
        call gtstg
        Dec_ _rc_
        js   call_259
        Dec_ _rc_
        jns  ppm_0460
        Jmp_ pats7
ppm_0460:
call_259:
        or   %ecx,%ecx
        jz   pats7
        Cmp_ %ecx,$num01
        jne  pats2
        or   %ebx,%ebx
        jz   pats2
        Add_ %edi,$cfp_f
#lch s.text (xr)  s.type 9  s.reg xr
#lch d.text xr  d.type 7  d.reg xr  w 1
        Xor_ %eax,%eax
        movb (%edi),%al
        mov  %eax,%edi
pats1:
        call pbild
        Mov_ _rc_,$0
        Mov_ %eax,prc_+4*13
        Jmp_ *%eax
pats2:
        push %esi
        Mov_ %edx,ctmsk
        Cmp_ %edi,r_cts
        je   pats6
        push %edi
        Sal_ %edx,$1
        or   %edx,%edx
        jnz  pats4
        Mov_ %ecx,$4*ctsi_
        call alloc
        Mov_ r_ctp,%edi
        Mov_ %eax,$b_ctt
        stosl
        Mov_ %ebx,$cfp_a
        Mov_ %edx,bits0
pats3:
        Mov_ %eax,%edx
        stosl
        Dec_ %ebx
        jnz  pats3
        Mov_ %edx,bits1
pats4:
        Mov_ ctmsk,%edx
        pop  %esi
        Mov_ r_cts,%esi
        Mov_ %ebx,4(%esi)
        or   %ebx,%ebx
        jz   pats6
        Add_ %esi,$cfp_f
pats5:
#lch s.text (xl)+  s.type 10  s.reg xl
#lch d.text wa  d.type 8  d.reg wa  w 0
        Xor_ %eax,%eax
        lodsb
        Mov_ %ecx,%eax
        Sal_ %ecx,$2
        Mov_ %edi,r_ctp
        Add_ %edi,%ecx
        Mov_ %ecx,%edx
        Or_  %ecx,4(%edi)
        Mov_ 4(%edi),%ecx
        Dec_ %ebx
        jnz  pats5
pats6:
        Mov_ %edi,r_ctp
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        pop  %ebx
        Jmp_ pats1
pats7:
        Mov_ %ebx,%edx
        Cmp_ (%edi),$b_e__
        jb   pats1
        Mov_ _rc_,$1
        Mov_ %eax,prc_+4*13
        Jmp_ *%eax
pbild:
        push %edi
        Mov_ %edi,%ebx
        Dec_ %edi
        mov  (%edi),%al
        movzbl %al,%edi
        Cmp_ %edi,$bl_p1
        je   pbld1
        Cmp_ %edi,$bl_p0
        je   pbld3
        Mov_ %ecx,$4*pcsi_
        call alloc
        Mov_ 12(%edi),%edx
        Jmp_ pbld2
pbld1:
        Mov_ %ecx,$4*pbsi_
        call alloc
pbld2:
        Mov_ %eax,(%esp)
        Mov_ 8(%edi),%eax
        Jmp_ pbld4
pbld3:
        Mov_ %ecx,$4*pasi_
        call alloc
pbld4:
        Mov_ (%edi),%ebx
        Add_ %esp,$cfp_b
        Mov_ 4(%edi),$ndnth
        ret
pconc:
        Xor_ %eax,%eax
        push %eax
        Mov_ %edx,%esp
        push $ndnth
        push %esi
        Mov_ %esi,%esp
        call pcopy
        Mov_ 8(%esi),%ecx
pcnc1:
        Cmp_ %esi,%esp
        je   pcnc2
        Sub_ %esi,$4
        Mov_ %edi,(%esi)
        Mov_ %edi,4(%edi)
        call pcopy
        Sub_ %esi,$4
        Mov_ %edi,(%esi)
        Mov_ 4(%edi),%ecx
        Cmp_ (%edi),$p_alt
        jne  pcnc1
        Mov_ %edi,8(%edi)
        call pcopy
        Mov_ %edi,(%esi)
        Mov_ 8(%edi),%ecx
        Jmp_ pcnc1
pcnc2:
        Mov_ %esp,%edx
        pop  %edi
        ret
pcopy:
        pop  prc_+4*14
        Mov_ %ebx,%esi
        Mov_ %esi,%edx
pcop1:
        Sub_ %esi,$cfp_b
        Cmp_ %edi,(%esi)
        je   pcop2
        Sub_ %esi,$cfp_b
        Cmp_ %esi,%esp
        jne  pcop1
        Mov_ %ecx,(%edi)
        call blkln
        Mov_ %esi,%edi
        call alloc
        push %esi
        push %edi
        chk_
        or   %eax,%eax
        jne  sec06
        Sar_ %ecx,$2
        rep  movsl
        Mov_ %ecx,(%esp)
        Jmp_ pcop3
pcop2:
        Sub_ %esi,$4
        Mov_ %ecx,(%esi)
pcop3:
        Mov_ %esi,%ebx
        Mov_ _rc_,$0
        Mov_ %eax,prc_+4*14
        Jmp_ *%eax
prflr:
        Xor_ %eax,%eax
        Cmp_ pfdmp,%eax
        jz   prfl4
        push %edi
        Mov_ pfsvw,%ebx
        call prtpg
        Mov_ %edi,$pfms1
        call prtst
        call prtnl
        call prtnl
        Mov_ %edi,$pfms2
        call prtst
        call prtnl
        Mov_ %edi,$pfms3
        call prtst
        call prtnl
        call prtnl
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Mov_ %edi,pftbl
        Add_ %edi,$4*xndta
prfl1:
        Inc_ %ebx
        ldi_ (%edi)
        Mov_ %eax,reg_ia
        or   %eax,%eax
        je   prfl3
        Mov_ profs,$pfpd1
        call prtin
        Xor_ %eax,%eax
        Mov_ profs,%eax
        ldi_ %ebx
        call prtin
        Mov_ profs,$pfpd2
        ldi_ 4(%edi)
        call prtin
        ldi_ 4(%edi)
        Mov_ %eax,intth
        mli_
        iov_ prfl2
        Mov_ %eax,(%edi)
        dvi_
        Mov_ profs,$pfpd3
        call prtin
prfl2:
        call prtnl
prfl3:
        Add_ %edi,$4*pf_i2
        Cmp_ %ebx,pfnte
        jb   prfl1
        pop  %edi
        Mov_ %ebx,pfsvw
prfl4:
        ret
prflu:
        Xor_ %eax,%eax
        Cmp_ pffnc,%eax
        jnz  pflu4
        push %edi
        Mov_ pfsvw,%ecx
        Xor_ %eax,%eax
        Cmp_ pftbl,%eax
        jnz  pflu2
        Sub_ pfnte,$num01
        ldi_ pfi2a
        sti_ pfste
        ldi_ pfnte
        Mov_ %eax,pfste
        mli_
        sti_ %ecx
        Add_ %ecx,$num02
        Sal_ %ecx,$2
        call alost
        Mov_ pftbl,%edi
        Mov_ %eax,$_b_xnt
        stosl
        Mov_ %eax,%ecx
        stosl
        sti_ %ecx
pflu1:
        Xor_ %eax,%eax
        Mov_ %eax,%eax
        stosl
        Dec_ %ecx
        jnz  pflu1
pflu2:
        ldi_ kvstn
        Mov_ %eax,intv1
        sbi_
        Mov_ %eax,pfste
        mli_
        sti_ %ecx
        Sal_ %ecx,$2
        Add_ %ecx,$4*num02
        Mov_ %edi,pftbl
        Cmp_ %ecx,4(%edi)
        jae  pflu3
        Add_ %edi,%ecx
        ldi_ (%edi)
        Mov_ %eax,intv1
        adi_
        sti_ (%edi)
        call systm
        sti_ pfetm
        Mov_ %eax,pfstm
        sbi_
        Mov_ %eax,4(%edi)
        adi_
        sti_ 4(%edi)
        ldi_ pfetm
        sti_ pfstm
pflu3:
        pop  %edi
        Mov_ %ecx,pfsvw
        ret
pflu4:
        Xor_ %eax,%eax
        Mov_ pffnc,%eax
        ret
prpar:
        or   %edx,%edx
        jnz  prpa8
        call syspp
        or   %ebx,%ebx
        jnz  prpa1
        Mov_ %ebx,mxint
        Sar_ %ebx,$1
prpa1:
        Mov_ lstnp,%ebx
        Mov_ lstlc,%ebx
        Xor_ %eax,%eax
        Mov_ lstpg,%eax
        Mov_ %ebx,prlen
        or   %ebx,%ebx
        jz   prpa2
        Cmp_ %ecx,%ebx
        ja   prpa3
prpa2:
        Mov_ prlen,%ecx
prpa3:
        Mov_ %ebx,bits3
        And_ %ebx,%edx
        or   %ebx,%ebx
        jz   prpa4
        Xor_ %eax,%eax
        Mov_ cswls,%eax
prpa4:
        Mov_ %ebx,bits1
        And_ %ebx,%edx
        Mov_ erich,%ebx
        Mov_ %ebx,bits2
        And_ %ebx,%edx
        Mov_ prich,%ebx
        Mov_ %ebx,bits4
        And_ %ebx,%edx
        Mov_ cpsts,%ebx
        Mov_ %ebx,bits5
        And_ %ebx,%edx
        Mov_ exsts,%ebx
        Mov_ %ebx,bits6
        And_ %ebx,%edx
        Mov_ precl,%ebx
        Sub_ %ecx,$num08
        or   %ebx,%ebx
        jz   prpa5
        Mov_ lstpo,%ecx
prpa5:
        Mov_ %ebx,bits7
        And_ %ebx,%edx
        Mov_ cswex,%ebx
        Mov_ %ebx,bit10
        And_ %ebx,%edx
        Mov_ headp,%ebx
        Mov_ %ebx,bits9
        And_ %ebx,%edx
        Mov_ prsto,%ebx
        Mov_ %ebx,%edx
        Sar_ %ebx,$12
        And_ %ebx,bits1
        Mov_ kvcas,%ebx
        Mov_ %ebx,bit12
        And_ %ebx,%edx
        Mov_ cswer,%ebx
        or   %ebx,%ebx
        jz   prpa6
        Mov_ %ecx,prlen
        Sub_ %ecx,$num08
        Mov_ lstpo,%ecx
prpa6:
        Mov_ %ebx,bit11
        And_ %ebx,%edx
        Mov_ cswpr,%ebx
        And_ %edx,bits8
        or   %edx,%edx
        jnz  prpa8
        Xor_ %eax,%eax
        Cmp_ initr,%eax
        jz   prpa9
        Mov_ %esi,$v_ter
        call gtnvr
        Dec_ _rc_
        js   call_260
        Dec_ _rc_
        jns  ppm_0461
        Mov_ _rc_,$299
        Jmp_ err_
ppm_0461:
call_260:
        Mov_ 8(%edi),$nulls
        call setvr
        Jmp_ prpa9
prpa8:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ initr,%eax
        Xor_ %eax,%eax
        Cmp_ _dnamb,%eax
        jz   prpa9
        Mov_ %esi,$v_ter
        Mov_ %ebx,$trtou
        call inout
        push %edi
        Mov_ %esi,$v_ter
        Mov_ %ebx,$trtin
        call inout
        pop  8(%edi)
prpa9:
        ret
prtch:
        push %edi
        Mov_ %eax,prlen
        Cmp_ profs,%eax
        jne  prch1
        call prtnl
prch1:
        Mov_ %edi,prbuf
        Add_ %edi,$cfp_f
        Add_ %edi,profs
#sch s.text wa  s.type 8  s.reg wa
#sch d.text (xr)  d.type 9  d.reg xr  w 0
        movb %cl,(%edi)
        Inc_ profs
        pop  %edi
        ret
prtic:
        push %edi
        Mov_ %edi,prbuf
        Mov_ %ecx,profs
        call syspi
        Dec_ _rc_
        js   call_261
        Dec_ _rc_
        jns  ppm_0462
        Jmp_ prtc2
ppm_0462:
call_261:
prtc1:
        pop  %edi
        ret
prtc2:
        Xor_ %eax,%eax
        Mov_ erich,%eax
        Mov_ _rc_,$252
        Jmp_ err_
        Jmp_ prtc1
prtis:
        Xor_ %eax,%eax
        Cmp_ prich,%eax
        jnz  prts1
        Xor_ %eax,%eax
        Cmp_ erich,%eax
        jz   prts1
        call prtic
prts1:
        call prtnl
        ret
prtin:
        push %edi
        call icbld
        Cmp_ %edi,_dnamb
        jb   prti1
        Cmp_ %edi,_dnamp
        ja   prti1
        Mov_ _dnamp,%edi
prti1:
        push %edi
        call gtstg
        Dec_ _rc_
        js   call_262
        Dec_ _rc_
        jns  ppm_0463
        Mov_ _rc_,$299
        Jmp_ err_
ppm_0463:
call_262:
        Mov_ _dnamp,%edi
        call prtst
        pop  %edi
        ret
prtmi:
        call prtst
        Mov_ profs,$prtmf
        call prtin
        call prtnl
        ret
prtmm:
        Mov_ %ecx,_dnamp
        Sub_ %ecx,statb
        ldi_ %ecx
        Mov_ %edi,$encm1
        call prtmi
        Mov_ %ecx,dname
        Sub_ %ecx,_dnamp
        ldi_ %ecx
        Mov_ %edi,$encm2
        call prtmi
        ret
prtmx:
        call prtst
        Mov_ profs,$prtmf
        call prtin
        call prtis
        ret
prtnl:
        Xor_ %eax,%eax
        Cmp_ headp,%eax
        jnz  prnl0
        call prtps
prnl0:
        push %edi
        Mov_ prtsa,%ecx
        Mov_ prtsb,%ebx
        Mov_ %edi,prbuf
        Mov_ %ecx,profs
        call syspr
        Dec_ _rc_
        js   call_263
        Dec_ _rc_
        jns  ppm_0464
        Jmp_ prnl2
ppm_0464:
call_263:
        Mov_ %ecx,prlnw
        Add_ %edi,$4*schar
        Mov_ %ebx,nullw
prnl1:
        Mov_ %eax,%ebx
        stosl
        Dec_ %ecx
        jnz  prnl1
        Mov_ %ebx,prtsb
        Mov_ %ecx,prtsa
        pop  %edi
        Xor_ %eax,%eax
        Mov_ profs,%eax
        ret
prnl2:
        Xor_ %eax,%eax
        Cmp_ prtef,%eax
        jnz  prnl3
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ prtef,%eax
        Mov_ _rc_,$253
        Jmp_ err_
prnl3:
        Mov_ %ebx,$nini8
        Mov_ %ecx,kvstn
        Mov_ %esi,_r_fcb
        call sysej
prtnm:
        push %ecx
        push %edi
        push %esi
        Cmp_ %esi,_state
        ja   prn02
        Mov_ %edi,%esi
        call prtvn
prn01:
        pop  %esi
        pop  %edi
        pop  %ecx
        ret
prn02:
        Mov_ %ebx,%ecx
        Cmp_ (%esi),$b_pdt
        jne  prn03
        Mov_ %edi,8(%esi)
        Add_ %edi,%ecx
        Mov_ %edi,8(%edi)
        call prtvn
        Mov_ %ecx,$ch_pp
        call prtch
prn03:
        Cmp_ (%esi),$b_tet
        jne  prn04
        Mov_ %esi,12(%esi)
        Jmp_ prn03
prn04:
        Mov_ %edi,prnmv
        Mov_ %ecx,_hshtb
        Jmp_ prn07
prn05:
        Mov_ %edi,%ecx
        Add_ %ecx,$cfp_b
        Sub_ %edi,$4*vrnxt
prn06:
        Mov_ %edi,24(%edi)
prn07:
        Mov_ %edx,%edi
        or   %edx,%edx
        jz   prn09
prn08:
        Mov_ %edi,8(%edi)
        Cmp_ (%edi),$b_trt
        je   prn08
        Cmp_ %edi,%esi
        je   prn10
        Mov_ %edi,%edx
        Jmp_ prn06
prn09:
        Cmp_ %ecx,hshte
        jb   prn05
        Mov_ %edi,%esi
        call prtvl
        Jmp_ prn11
prn10:
        Mov_ %edi,%edx
        Mov_ prnmv,%edi
        call prtvn
prn11:
        Mov_ %edx,(%esi)
        Cmp_ %edx,$b_pdt
        jne  prn13
        Mov_ %ecx,$ch_rp
prn12:
        call prtch
        Mov_ %ecx,%ebx
        Jmp_ prn01
prn13:
        Mov_ %ecx,$ch_bb
        call prtch
        Mov_ %esi,(%esp)
        Mov_ %edx,(%esi)
        Cmp_ %edx,$b_tet
        jne  prn15
        Mov_ %edi,4(%esi)
        Mov_ %esi,%ebx
        call prtvl
        Mov_ %ebx,%esi
prn14:
        Mov_ %ecx,$ch_rb
        Jmp_ prn12
prn15:
        Mov_ %ecx,%ebx
        Sar_ %ecx,$2
        Cmp_ %edx,$b_art
        je   prn16
        Sub_ %ecx,$vcvlb
        ldi_ %ecx
        call prtin
        Jmp_ prn14
prn16:
        Mov_ %edx,12(%esi)
        Add_ %edx,$cfp_b
        Sar_ %edx,$2
        Sub_ %ecx,%edx
        ldi_ %ecx
        Mov_ %ecx,16(%esi)
        Add_ %esi,12(%esi)
        Sub_ %esi,$4*arlbd
prn17:
        Sub_ %esi,$4*ardms
        sti_ prnsi
        Mov_ %eax,24(%esi)
        rmi_
        sti_ %eax
        push %eax
        ldi_ prnsi
        Mov_ %eax,24(%esi)
        dvi_
        Dec_ %ecx
        jnz  prn17
        Xor_ %eax,%eax
        Mov_ %edi,%eax
        Mov_ %ebx,16(%esi)
        Jmp_ prn19
prn18:
        Mov_ %ecx,$ch_cm
        call prtch
prn19:
        pop  %eax
        ldi_ %eax
        Add_ %esi,%edi
        Mov_ %eax,20(%esi)
        adi_
        Sub_ %esi,%edi
        call prtin
        Add_ %edi,$4*ardms
        Dec_ %ebx
        jnz  prn18
        Jmp_ prn14
prtnv:
        call prtnm
        push %edi
        push %ecx
        Mov_ %edi,$tmbeb
        call prtst
        Mov_ %edi,%esi
        Add_ %edi,%ecx
        Mov_ %edi,(%edi)
        call prtvl
        call prtnl
        pop  %ecx
        pop  %edi
        ret
prtpg:
        Cmp_ stage,$stgxt
        je   prp01
        Xor_ %eax,%eax
        Cmp_ lstlc,%eax
        jz   prp06
        Xor_ %eax,%eax
        Mov_ lstlc,%eax
prp01:
        push %edi
        Xor_ %eax,%eax
        Cmp_ prstd,%eax
        jnz  prp02
        Xor_ %eax,%eax
        Cmp_ prich,%eax
        jnz  prp03
        Xor_ %eax,%eax
        Cmp_ precl,%eax
        jz   prp03
prp02:
        call sysep
        Jmp_ prp04
prp03:
        Mov_ %edi,headp
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ headp,%eax
        call prtnl
        call prtnl
        call prtnl
        Mov_ lstlc,$num03
        Mov_ headp,%edi
prp04:
        Xor_ %eax,%eax
        Cmp_ headp,%eax
        jnz  prp05
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ headp,%eax
        push %esi
        Mov_ %edi,$headr
        call prtst
        call sysid
        call prtst
        call prtnl
        Mov_ %edi,%esi
        call prtst
        call prtnl
        call prtnl
        call prtnl
        Add_ lstlc,$num04
        pop  %esi
prp05:
        pop  %edi
prp06:
        ret
prtps:
        Mov_ %eax,prsto
        Mov_ prstd,%eax
        call prtpg
        Xor_ %eax,%eax
        Mov_ prstd,%eax
        ret
prtsn:
        push %edi
        Mov_ prsna,%ecx
        Mov_ %edi,$tmasb
        call prtst
        Mov_ profs,$num04
        ldi_ kvstn
        call prtin
        Mov_ profs,$prsnf
        Mov_ %edi,kvfnc
        Mov_ %ecx,$ch_li
prsn1:
        or   %edi,%edi
        jz   prsn2
        call prtch
        Dec_ %edi
        Jmp_ prsn1
prsn2:
        Mov_ %ecx,$ch_bl
        call prtch
        Mov_ %ecx,prsna
        pop  %edi
        ret
prtst:
        Xor_ %eax,%eax
        Cmp_ headp,%eax
        jnz  prst0
        call prtps
prst0:
        Mov_ prsva,%ecx
        Mov_ prsvb,%ebx
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
prst1:
        Mov_ %ecx,4(%edi)
        Sub_ %ecx,%ebx
        or   %ecx,%ecx
        jz   prst4
        push %esi
        push %edi
        Mov_ %esi,%edi
        Mov_ %edi,prlen
        Sub_ %edi,profs
        or   %edi,%edi
        jnz  prst2
        call prtnl
        Mov_ %edi,prlen
prst2:
        Cmp_ %ecx,%edi
        jb   prst3
        Mov_ %ecx,%edi
prst3:
        Mov_ %edi,prbuf
        Add_ %esi,%ebx
        Add_ %esi,$cfp_f
        Add_ %edi,$cfp_f
        Add_ %edi,profs
        Add_ %ebx,%ecx
        Add_ profs,%ecx
        Mov_ prsvc,%ebx
        rep  movsb
        Mov_ %ebx,prsvc
        pop  %edi
        pop  %esi
        Jmp_ prst1
prst4:
        Mov_ %ebx,prsvb
        Mov_ %ecx,prsva
        ret
prttr:
        push %edi
        call prtic
        Mov_ %edi,prbuf
        Mov_ %ecx,prlnw
        Add_ %edi,$4*schar
        Mov_ %ebx,nullw
prtt1:
        Mov_ %eax,%ebx
        stosl
        Dec_ %ecx
        jnz  prtt1
        Xor_ %eax,%eax
        Mov_ profs,%eax
        pop  %edi
        ret
prtvl:
        push %esi
        push %edi
        chk_
        or   %eax,%eax
        jne  sec06
prv01:
        Mov_ %eax,4(%edi)
        Mov_ prvsi,%eax
        Mov_ %esi,(%edi)
        Dec_ %esi
        mov  (%esi),%al
        movzbl %al,%esi
        Cmp_ %esi,$bl__t
        jge  prv02
        jmp  *bsw_0466(,%esi,4)
        Data
bsw_0466:
        .long prv05
        .long prv02
        .long prv02
        .long prv08
        .long prv09
        .long prv02
        .long prv02
        .long prv02
        .long prv08
        .long prv11
        .long prv12
        .long prv13
        .long prv13
        .long prv02
        .long prv02
        .long prv02
        .long prv10
        .long prv04
        Text
prv02:
        call dtype
        call prtst
prv03:
        pop  %edi
        pop  %esi
        ret
prv04:
        Mov_ %edi,8(%edi)
        Jmp_ prv01
prv05:
        Mov_ %esi,%edi
        Mov_ %edi,$scarr
        call prtst
        Mov_ %ecx,$ch_pp
        call prtch
        Add_ %esi,12(%esi)
        Mov_ %edi,(%esi)
        call prtst
prv06:
        Mov_ %ecx,$ch_rp
        call prtch
prv07:
        Mov_ %ecx,$ch_bl
        call prtch
        Mov_ %ecx,$ch_nm
        call prtch
        ldi_ prvsi
        call prtin
        Jmp_ prv03
prv08:
        push %edi
        call gtstg
        Dec_ _rc_
        js   call_264
        Dec_ _rc_
        jns  ppm_0467
        Mov_ _rc_,$299
        Jmp_ err_
ppm_0467:
call_264:
        call prtst
        Mov_ _dnamp,%edi
        Jmp_ prv03
prv09:
        Mov_ %esi,4(%edi)
        Mov_ %ecx,(%esi)
        Cmp_ %ecx,$b_kvt
        je   prv02
        Cmp_ %ecx,$b_evt
        je   prv02
        Mov_ %ecx,$ch_dt
        call prtch
        Mov_ %ecx,8(%edi)
        call prtnm
        Jmp_ prv03
prv10:
        call dtype
        call prtst
        Jmp_ prv07
prv11:
        Mov_ %ecx,$ch_sq
        call prtch
        call prtst
        call prtch
        Jmp_ prv03
prv12:
        Mov_ %ecx,$ch_as
        call prtch
        Mov_ %edi,4(%edi)
        call prtvn
        Jmp_ prv03
prv13:
        Mov_ %esi,%edi
        call dtype
        call prtst
        Mov_ %ecx,$ch_pp
        call prtch
        Mov_ %ecx,8(%esi)
        Sar_ %ecx,$2
        Sub_ %ecx,$tbsi_
        Cmp_ (%esi),$b_tbt
        je   prv14
        Add_ %ecx,$vctbd
prv14:
        ldi_ %ecx
        call prtin
        Jmp_ prv06
prtvn:
        push %edi
        Add_ %edi,$4*vrsof
        Xor_ %eax,%eax
        Cmp_ 4(%edi),%eax
        jnz  prvn1
        Mov_ %edi,8(%edi)
prvn1:
        call prtst
        pop  %edi
        ret
rcbld:
        Mov_ %edi,_dnamp
        Add_ %edi,$4*rcsi_
        Cmp_ %edi,dname
        jb   rcbl1
        Mov_ %ecx,$4*rcsi_
        call alloc
        Add_ %edi,%ecx
rcbl1:
        Mov_ _dnamp,%edi
        Sub_ %edi,$4*rcsi_
        Mov_ (%edi),$b_rcl
        Mov_ %eax,%edi
        Add_ %eax,(cfp_b*rcval)
        call str_
        ret
readr:
        Mov_ %edi,r_cni
        or   %edi,%edi
        jnz  read3
        Xor_ %eax,%eax
        Cmp_ cnind,%eax
        jnz  reada
        Cmp_ stage,$stgic
        jne  read3
reada:
        Mov_ %ecx,cswin
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        call alocs
        call sysrd
        Dec_ _rc_
        js   call_265
        Dec_ _rc_
        jns  ppm_0468
        Jmp_ read4
ppm_0468:
call_265:
        Inc_ rdnln
        Dec_ _polct
        Xor_ %eax,%eax
        Cmp_ _polct,%eax
        jnz  read0
        Xor_ %eax,%eax
        Mov_ %ecx,%eax
        Mov_ %ebx,rdnln
        call syspl
        Dec_ _rc_
        js   call_266
        Dec_ _rc_
        jns  ppm_0469
        Mov_ _rc_,$320
        Jmp_ err_
ppm_0469:
        Dec_ _rc_
        jns  ppm_0470
        Mov_ _rc_,$299
        Jmp_ err_
ppm_0470:
        Dec_ _rc_
        jns  ppm_0471
        Mov_ _rc_,$299
        Jmp_ err_
ppm_0471:
call_266:
        Mov_ polcs,%ecx
        Mov_ _polct,%ecx
read0:
        Mov_ %eax,cswin
        Cmp_ 4(%edi),%eax
        jbe  read1
        Mov_ %eax,cswin
        Mov_ 4(%edi),%eax
read1:
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %ebx,%eax
        call trimr
read2:
        Mov_ r_cni,%edi
read3:
        ret
read4:
        Xor_ %eax,%eax
        Cmp_ 4(%edi),%eax
        jz   read5
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Mov_ rdnln,%ebx
        call trimr
        call newfn
        Jmp_ reada
read5:
        Mov_ _dnamp,%edi
        Xor_ %eax,%eax
        Cmp_ cnind,%eax
        jz   read6
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        call sysif
        Dec_ _rc_
        js   call_267
        Dec_ _rc_
        jns  ppm_0472
        Mov_ _rc_,$299
        Jmp_ err_
ppm_0472:
call_267:
        Mov_ %ecx,cnind
        Add_ %ecx,$vcvlb
        Sal_ %ecx,$2
        Mov_ %edi,r_ifa
        Add_ %edi,%ecx
        Mov_ %eax,(%edi)
        Mov_ r_sfc,%eax
        Mov_ (%edi),$nulls
        Mov_ %edi,r_ifl
        Add_ %edi,%ecx
        Mov_ %esi,(%edi)
        ldi_ 4(%esi)
        sti_ rdnln
        Mov_ (%edi),$inton
        Dec_ cnind
        Mov_ %ebx,cmpsn
        Inc_ %ebx
        ldi_ %ebx
        call icbld
        Mov_ %esi,r_sfn
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %ebx,%eax
        call tfind
        Dec_ _rc_
        js   call_268
        Dec_ _rc_
        jns  ppm_0473
        Mov_ _rc_,$299
        Jmp_ err_
ppm_0473:
call_268:
        Mov_ %eax,r_sfc
        Mov_ 8(%esi),%eax
        Cmp_ stage,$stgic
        je   reada
        Xor_ %eax,%eax
        Cmp_ cnind,%eax
        jnz  reada
        Mov_ %esi,r_ici
        Xor_ %eax,%eax
        Mov_ r_ici,%eax
        Mov_ %ecx,cnsil
        Mov_ %ebx,cnspt
        Sub_ %ecx,%ebx
        Mov_ scnil,%ecx
        Xor_ %eax,%eax
        Mov_ scnpt,%eax
        call sbstr
        Mov_ r_cim,%edi
        Jmp_ read2
read6:
        Xor_ %eax,%eax
        Mov_ %edi,%eax
        Jmp_ read2
sbstr:
        or   %ecx,%ecx
        jz   sbst2
        call alocs
        Mov_ %ecx,%edx
        Mov_ %edx,%edi
        Add_ %esi,%ebx
        Add_ %esi,$cfp_f
        Add_ %edi,$cfp_f
        rep  movsb
        Mov_ %edi,%edx
sbst1:
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        ret
sbst2:
        Mov_ %edi,$nulls
        Jmp_ sbst1
stgcc:
        Mov_ %ecx,polcs
        Mov_ %ebx,$num01
        ldi_ kvstl
        Xor_ %eax,%eax
        Cmp_ kvpfl,%eax
        jnz  stgc1
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jl   stgc3
        Xor_ %eax,%eax
        Cmp_ r_stc,%eax
        jz   stgc2
stgc1:
        Mov_ %ebx,%ecx
        Mov_ %ecx,$num01
        Jmp_ stgc3
stgc2:
        ldi_ %ecx
        Mov_ %eax,kvstl
        sbi_
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jle  stgc3
        ldi_ kvstl
        sti_ %ecx
stgc3:
        Mov_ stmcs,%ecx
        Mov_ stmct,%ecx
        Mov_ _polct,%ebx
        ret
tfind:
        push %ebx
        push %edi
        push %esi
        Mov_ %ecx,8(%esi)
        Sar_ %ecx,$2
        Sub_ %ecx,$tbbuk
        ldi_ %ecx
        sti_ tfnsi
        Mov_ %esi,(%edi)
        Dec_ %esi
        mov  (%esi),%al
        movzbl %al,%esi
        Cmp_ %esi,$bl__d
        jge  tfn00
        jmp  *bsw_0475(,%esi,4)
        Data
bsw_0475:
        .long tfn00
        .long tfn00
        .long tfn00
        .long tfn02
        .long tfn04
        .long tfn03
        .long tfn03
        .long tfn03
        .long tfn02
        .long tfn05
        .long tfn00
        .long tfn00
        .long tfn00
        .long tfn00
        .long tfn00
        .long tfn00
        .long tfn00
        Text
tfn00:
        Mov_ %ecx,0(%edi)
tfn01:
        ldi_ %ecx
        Jmp_ tfn06
tfn02:
        ldi_ 0(%edi)
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jge  tfn06
        ngi_
        iov_ tfn06
        Jmp_ tfn06
tfn03:
        Mov_ %ecx,(%edi)
        Jmp_ tfn01
tfn04:
        Mov_ %ecx,8(%edi)
        Jmp_ tfn01
tfn05:
        call hashs
tfn06:
        Mov_ %eax,tfnsi
        rmi_
        sti_ %edx
        Sal_ %edx,$2
        Mov_ %esi,(%esp)
        Add_ %esi,%edx
        Mov_ %edi,16(%esi)
        Cmp_ %edi,(%esp)
        je   tfn10
tfn07:
        Mov_ %ebx,%edi
        Mov_ %edi,4(%edi)
        Mov_ %esi,0(%esp)
        call ident
        Dec_ _rc_
        js   call_269
        Dec_ _rc_
        jns  ppm_0476
        Jmp_ tfn08
ppm_0476:
call_269:
        Mov_ %esi,%ebx
        Mov_ %edi,12(%esi)
        Cmp_ %edi,(%esp)
        jne  tfn07
        Mov_ %edx,$4*tenxt
        Jmp_ tfn11
tfn08:
        Mov_ %esi,%ebx
        Mov_ %ecx,$4*teval
        Mov_ %ebx,0(%esp)
        or   %ebx,%ebx
        jnz  tfn09
        call acess
        Dec_ _rc_
        js   call_270
        Dec_ _rc_
        jns  ppm_0477
        Jmp_ tfn12
ppm_0477:
call_270:
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
tfn09:
        Add_ %esp,$4*num03
        Mov_ _rc_,$0
        ret
tfn10:
        Add_ %edx,$4*tbbuk
        Mov_ %esi,(%esp)
tfn11:
        Mov_ %edi,(%esp)
        Mov_ %edi,12(%edi)
        Mov_ %ebx,0(%esp)
        or   %ebx,%ebx
        jz   tfn09
        Mov_ %ebx,%edi
        Mov_ %ecx,$4*tesi_
        call alloc
        Add_ %esi,%edx
        Mov_ (%esi),%edi
        Mov_ (%edi),$b_tet
        Mov_ 8(%edi),%ebx
        pop  12(%edi)
        pop  4(%edi)
        pop  %ebx
        Mov_ %esi,%edi
        Mov_ %ecx,$4*teval
        Mov_ _rc_,$0
        ret
tfn12:
        Mov_ _rc_,$1
        ret
tmake:
        Mov_ %ecx,%edx
        Add_ %ecx,$tbsi_
        Sal_ %ecx,$2
        call alloc
        Mov_ %ebx,%edi
        Mov_ %eax,$b_tbt
        stosl
        Xor_ %eax,%eax
        Mov_ %eax,%eax
        stosl
        Mov_ %eax,%ecx
        stosl
        Mov_ %eax,%esi
        stosl
tma01:
        Mov_ %eax,%ebx
        stosl
        Dec_ %edx
        jnz  tma01
        Mov_ %edi,%ebx
        ret
vmake:
        Mov_ %ebx,%ecx
        Add_ %ecx,$vcsi_
        Sal_ %ecx,$2
        Cmp_ %ecx,mxlen
        ja   vmak2
        call alloc
        Mov_ (%edi),$b_vct
        Xor_ %eax,%eax
        Mov_ 4(%edi),%eax
        Mov_ 8(%edi),%ecx
        Mov_ %edx,%esi
        Mov_ %esi,%edi
        Add_ %esi,$4*vcvls
vmak1:
        Mov_ (%esi),%edx
        Add_ %esi,$4
        Dec_ %ebx
        jnz  vmak1
        Mov_ _rc_,$0
        ret
vmak2:
        Mov_ _rc_,$1
        ret
scane:
        Xor_ %eax,%eax
        Mov_ scnbl,%eax
        Mov_ scnsa,%ecx
        Mov_ scnsb,%ebx
        Mov_ scnsc,%edx
        Xor_ %eax,%eax
        Cmp_ scnrs,%eax
        jz   scn03
        Mov_ %esi,scntp
        Mov_ %edi,r_scp
        Xor_ %eax,%eax
        Mov_ scnrs,%eax
        Jmp_ scn13
scn01:
        call readr
        Mov_ %ebx,$4*dvubs
        or   %edi,%edi
        jz   scn30
        Add_ %edi,$cfp_f
#lch s.text (xr)  s.type 9  s.reg xr
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%edi),%dl
        Cmp_ %edx,$ch_dt
        je   scn02
        Cmp_ %edx,$ch_pl
        jne  scn30
scn02:
        call nexts
        Mov_ scnpt,$num01
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ scnbl,%eax
scn03:
        Mov_ %ecx,scnpt
        Cmp_ %ecx,scnil
        je   scn01
        Mov_ %esi,r_cim
        Add_ %esi,%ecx
        Add_ %esi,$cfp_f
        Mov_ scnse,%ecx
        Mov_ %edx,$opdvs
        Mov_ %ebx,$4*dvubs
        Jmp_ scn06
scn05:
        or   %ebx,%ebx
        jz   scn10
        Inc_ scnse
        Cmp_ %ecx,scnil
        je   scn01
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ scnbl,%eax
scn06:
#lch s.text (xl)+  s.type 10  s.reg xl
#lch d.text xr  d.type 7  d.reg xr  w 1
        Xor_ %eax,%eax
        lodsb
        Mov_ %edi,%eax
        Inc_ %ecx
        Mov_ scnpt,%ecx
        Cmp_ %edi,$cfp_u
        jge  scn07
        jmp  *bsw_0478(,%edi,4)
        Data
bsw_0478:
        .long scn07
        .long scn07
        .long scn07
        .long scn07
        .long scn07
        .long scn07
        .long scn07
        .long scn07
        .long scn07
        .long scn05
        .long scn07
        .long scn07
        .long scn07
        .long scn07
        .long scn07
        .long scn07
        .long scn07
        .long scn07
        .long scn07
        .long scn07
        .long scn07
        .long scn07
        .long scn07
        .long scn07
        .long scn07
        .long scn07
        .long scn07
        .long scn07
        .long scn07
        .long scn07
        .long scn07
        .long scn07
        .long scn05
        .long scn37
        .long scn17
        .long scn41
        .long scn36
        .long scn38
        .long scn44
        .long scn16
        .long scn25
        .long scn26
        .long scn49
        .long scn33
        .long scn31
        .long scn34
        .long scn32
        .long scn40
        .long scn08
        .long scn08
        .long scn08
        .long scn08
        .long scn08
        .long scn08
        .long scn08
        .long scn08
        .long scn08
        .long scn08
        .long scn29
        .long scn30
        .long scn28
        .long scn46
        .long scn27
        .long scn45
        .long scn42
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn20
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn21
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn28
        .long scn07
        .long scn27
        .long scn37
        .long scn24
        .long scn07
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn20
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn21
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn09
        .long scn07
        .long scn43
        .long scn07
        .long scn35
        .long scn07
        Text
scn07:
        or   %ebx,%ebx
        jz   scn10
        Mov_ _rc_,$230
        Jmp_ err_
scn08:
        or   %ebx,%ebx
        jz   scn09
        Xor_ %eax,%eax
        Mov_ %edx,%eax
scn09:
        Cmp_ %ecx,scnil
        je   scn11
        Xor_ %eax,%eax
        Mov_ %ebx,%eax
        Jmp_ scn06
scn10:
        Dec_ %ecx
scn11:
        Mov_ scnpt,%ecx
        Mov_ %ebx,scnse
        Sub_ %ecx,%ebx
        Mov_ %esi,r_cim
        or   %edx,%edx
        jnz  scn15
        call sbstr
        Mov_ _dnamp,%edi
        call gtnum
        Dec_ _rc_
        js   call_271
        Dec_ _rc_
        jns  ppm_0479
        Jmp_ scn14
ppm_0479:
call_271:
scn12:
        Mov_ %esi,$t_con
scn13:
        Mov_ %ecx,scnsa
        Mov_ %ebx,scnsb
        Mov_ %edx,scnsc
        Mov_ r_scp,%edi
        Mov_ scntp,%esi
        Xor_ %eax,%eax
        Mov_ scngo,%eax
        ret
scn14:
        Mov_ _rc_,$231
        Jmp_ err_
scn15:
        call sbstr
        Xor_ %eax,%eax
        Cmp_ scncc,%eax
        jnz  scn13
        call gtnvr
        Dec_ _rc_
        js   call_272
        Dec_ _rc_
        jns  ppm_0480
        Mov_ _rc_,$299
        Jmp_ err_
ppm_0480:
call_272:
        Mov_ %esi,$t_var
        Jmp_ scn13
scn16:
        or   %ebx,%ebx
        jz   scn10
        Mov_ %ebx,$ch_sq
        Jmp_ scn18
scn17:
        or   %ebx,%ebx
        jz   scn10
        Mov_ %ebx,$ch_dq
scn18:
        Cmp_ %ecx,scnil
        je   scn19
#lch s.text (xl)+  s.type 10  s.reg xl
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %eax,%eax
        lodsb
        Mov_ %edx,%eax
        Inc_ %ecx
        Cmp_ %edx,%ebx
        jne  scn18
        Mov_ %ebx,scnpt
        Mov_ scnpt,%ecx
        Dec_ %ecx
        Sub_ %ecx,%ebx
        Mov_ %esi,r_cim
        call sbstr
        Jmp_ scn12
scn19:
        Mov_ scnpt,%ecx
        Mov_ _rc_,$232
        Jmp_ err_
scn20:
        Mov_ %edi,$t_fgo
        Jmp_ scn22
scn21:
        Mov_ %edi,$t_sgo
scn22:
        Xor_ %eax,%eax
        Cmp_ scngo,%eax
        jz   scn09
scn23:
        or   %ebx,%ebx
        jz   scn10
        Mov_ %esi,%edi
        Jmp_ scn13
scn24:
        or   %ebx,%ebx
        jz   scn09
        Jmp_ scn07
scn25:
        Mov_ %edi,$t_lpr
        or   %ebx,%ebx
        jnz  scn23
        or   %edx,%edx
        jz   scn10
        Mov_ %ebx,scnse
        Mov_ scnpt,%ecx
        Dec_ %ecx
        Sub_ %ecx,%ebx
        Mov_ %esi,r_cim
        call sbstr
        call gtnvr
        Dec_ _rc_
        js   call_273
        Dec_ _rc_
        jns  ppm_0481
        Mov_ _rc_,$299
        Jmp_ err_
ppm_0481:
call_273:
        Mov_ %esi,$t_fnc
        Jmp_ scn13
scn26:
        Mov_ %edi,$t_rpr
        Jmp_ scn23
scn27:
        Mov_ %edi,$t_rbr
        Jmp_ scn23
scn28:
        Mov_ %edi,$t_lbr
        Jmp_ scn23
scn29:
        Mov_ %edi,$t_col
        Jmp_ scn23
scn30:
        Mov_ %edi,$t_smc
        Jmp_ scn23
scn31:
        Mov_ %edi,$t_cma
        Jmp_ scn23
scn32:
        or   %ebx,%ebx
        jz   scn09
        Add_ %edx,%ebx
scn33:
        or   %edx,%edx
        jz   scn09
        or   %ebx,%ebx
        jz   scn48
        Add_ %edx,%ebx
scn34:
        or   %edx,%edx
        jz   scn09
        or   %ebx,%ebx
        jz   scn48
        Add_ %edx,%ebx
scn35:
        Add_ %edx,%ebx
scn36:
        Add_ %edx,%ebx
scn37:
        Add_ %edx,%ebx
scn38:
        Add_ %edx,%ebx
scn39:
        Add_ %edx,%ebx
scn40:
        Add_ %edx,%ebx
scn41:
        Add_ %edx,%ebx
scn42:
        Add_ %edx,%ebx
scn43:
        Add_ %edx,%ebx
scn44:
        Add_ %edx,%ebx
scn45:
        Add_ %edx,%ebx
scn46:
        or   %ebx,%ebx
        jz   scn10
        Mov_ %edi,%edx
#lch s.text (xl)  s.type 9  s.reg xl
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %edx,%edx
        movb (%esi),%dl
        Mov_ %esi,$t_bop
        Cmp_ %ecx,scnil
        je   scn47
        Cmp_ %edx,$ch_bl
        je   scn47
        Cmp_ %edx,$ch_ht
        je   scn47
        Cmp_ %edx,$ch_sm
        je   scn47
        Cmp_ %edx,$ch_cl
        je   scn47
        Cmp_ %edx,$ch_rp
        je   scn47
        Cmp_ %edx,$ch_rb
        je   scn47
        Cmp_ %edx,$ch_cb
        je   scn47
        Add_ %edi,$4*dvbs_
        Mov_ %esi,$t_uop
        Cmp_ scntp,$t_uok
        jbe  scn13
scn47:
        Xor_ %eax,%eax
        Cmp_ scnbl,%eax
        jnz  scn13
scn48:
        Mov_ _rc_,$233
        Jmp_ err_
scn49:
        or   %ebx,%ebx
        jz   scn10
        Cmp_ %ecx,scnil
        je   scn39
        Mov_ %edi,%ecx
        Mov_ scnof,%ecx
#lch s.text (xl)+  s.type 10  s.reg xl
#lch d.text wa  d.type 8  d.reg wa  w 0
        Xor_ %eax,%eax
        lodsb
        Mov_ %ecx,%eax
        Cmp_ %ecx,$ch_as
        jne  scn50
        Inc_ %edi
        Cmp_ %edi,scnil
        je   scn51
#lch s.text (xl)  s.type 9  s.reg xl
#lch d.text wa  d.type 8  d.reg wa  w 0
        Xor_ %ecx,%ecx
        movb (%esi),%cl
        Cmp_ %ecx,$ch_bl
        je   scn51
        Cmp_ %ecx,$ch_ht
        je   scn51
scn50:
        Mov_ %ecx,scnof
        Mov_ %esi,r_cim
        Add_ %esi,%ecx
        Add_ %esi,$cfp_f
        Jmp_ scn39
scn51:
        Mov_ scnpt,%edi
        Mov_ %ecx,%edi
        Jmp_ scn37
scngf:
        call scane
        Cmp_ %esi,$t_lpr
        je   scng1
        Cmp_ %esi,$t_lbr
        je   scng2
        Mov_ _rc_,$234
        Jmp_ err_
scng1:
        Mov_ %ebx,$num01
        call expan
        Mov_ %ecx,$opdvn
        Cmp_ %edi,statb
        jbe  scng3
        Cmp_ %edi,_state
        jb   scng4
        Jmp_ scng3
scng2:
        Mov_ %ebx,$num02
        call expan
        Mov_ %ecx,$opdvd
scng3:
        push %ecx
        push %edi
        call expop
        pop  %edi
scng4:
        ret
setvr:
        Cmp_ %edi,_state
        ja   setv1
        Mov_ %esi,%edi
        Mov_ 0(%edi),$b_vrl
        Cmp_ 4(%edi),$b_vre
        je   setv1
        Mov_ 4(%edi),$b_vrs
        Mov_ %esi,8(%esi)
        Cmp_ (%esi),$b_trt
        jne  setv1
        Mov_ 0(%edi),$b_vra
        Mov_ 4(%edi),$b_vrv
setv1:
        ret
sorta:
        pop  prc_+4*15
        Mov_ srtsr,%ecx
        Mov_ srtst,$4*num01
        Xor_ %eax,%eax
        Mov_ srtof,%eax
        Mov_ srtdf,$nulls
        pop  r_sxr
        pop  %edi
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ %ecx,%eax
        call gtarr
        Dec_ _rc_
        js   call_274
        Dec_ _rc_
        jns  ppm_0482
        Jmp_ srt18
ppm_0482:
        Dec_ _rc_
        jns  ppm_0483
        Jmp_ srt16
ppm_0483:
call_274:
        push %edi
        push %edi
        call copyb
        Dec_ _rc_
        js   call_275
        Dec_ _rc_
        jns  ppm_0484
        Mov_ _rc_,$299
        Jmp_ err_
ppm_0484:
call_275:
        push %edi
        Mov_ %edi,r_sxr
        Mov_ %esi,4(%esp)
        Cmp_ (%esi),$b_vct
        jne  srt02
        Cmp_ %edi,$nulls
        je   srt01
        call gtnvr
        Dec_ _rc_
        js   call_276
        Dec_ _rc_
        jns  ppm_0485
        Mov_ _rc_,$257
        Jmp_ err_
ppm_0485:
call_276:
        Mov_ srtdf,%edi
srt01:
        Mov_ %edx,$4*vclen
        Mov_ %ebx,$4*vcvls
        Mov_ %ecx,8(%esi)
        Sub_ %ecx,$4*vcsi_
        Jmp_ srt04
srt02:
        ldi_ 24(%esi)
        sti_ %ecx
        Sal_ %ecx,$2
        Mov_ %ebx,$4*arvls
        Mov_ %edx,$4*arpro
        Cmp_ 16(%esi),$num01
        je   srt04
        Cmp_ 16(%esi),$num02
        jne  srt16
        ldi_ 28(%esi)
        Cmp_ %edi,$nulls
        je   srt03
        call gtint
        Dec_ _rc_
        js   call_277
        Dec_ _rc_
        jns  ppm_0486
        Jmp_ srt17
ppm_0486:
call_277:
        ldi_ 4(%edi)
srt03:
        Mov_ %eax,28(%esi)
        sbi_
        iov_ srt17
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jl   srt17
        Mov_ %eax,32(%esi)
        sbi_
        Mov_ %eax,reg_ia
        or   %eax,%eax
        jge  srt17
        Mov_ %eax,32(%esi)
        adi_
        sti_ %ecx
        Sal_ %ecx,$2
        Mov_ srtof,%ecx
        ldi_ 32(%esi)
        sti_ %ecx
        Mov_ %edi,%ecx
        Sal_ %ecx,$2
        Mov_ srtst,%ecx
        ldi_ 24(%esi)
        sti_ %ecx
        Sal_ %ecx,$2
        Mov_ %edx,8(%esi)
        Sub_ %edx,%ecx
        Sub_ %edx,$cfp_b
        Mov_ %ebx,12(%esi)
        Add_ %ebx,$cfp_b
srt04:
        Cmp_ %ecx,$4*num01
        jbe  srt15
        Mov_ srtsn,%ecx
        Mov_ srtso,%edx
        Mov_ %edx,8(%esi)
        Add_ %edx,%esi
        Mov_ srtsf,%ebx
        Add_ %esi,%ebx
srt05:
        Mov_ %edi,(%esi)
srt06:
        Cmp_ (%edi),$b_trt
        jne  srt07
        Mov_ %edi,8(%edi)
        Jmp_ srt06
srt07:
        Mov_ (%esi),%edi
        Add_ %esi,$4
        Cmp_ %esi,%edx
        jb   srt05
        Mov_ %esi,(%esp)
        Mov_ %edi,srtsf
        Mov_ %ebx,srtst
        Add_ %esi,srtso
        Add_ %esi,$cfp_b
        Mov_ %edx,srtsn
        Sar_ %edx,$2
        Mov_ srtnr,%edx
srt08:
        Mov_ (%esi),%edi
        Add_ %esi,$4
        Add_ %edi,%ebx
        Dec_ %edx
        jnz  srt08
srt09:
        Mov_ %ecx,srtsn
        Mov_ %edx,srtnr
        Sar_ %edx,$1
        Sal_ %edx,$2
srt10:
        call sorth
        Sub_ %edx,$cfp_b
        or   %edx,%edx
        jnz  srt10
        Mov_ %edx,%ecx
srt11:
        Sub_ %edx,$cfp_b
        or   %edx,%edx
        jz   srt12
        Mov_ %edi,(%esp)
        Add_ %edi,srtso
        Mov_ %esi,%edi
        Add_ %esi,%edx
        Mov_ %ebx,4(%esi)
        Mov_ %eax,4(%edi)
        Mov_ 4(%esi),%eax
        Mov_ 4(%edi),%ebx
        Mov_ %ecx,%edx
        Mov_ %edx,$4*num01
        call sorth
        Mov_ %edx,%ecx
        Jmp_ srt11
srt12:
        Mov_ %edi,(%esp)
        Mov_ %edx,%edi
        Add_ %edx,srtso
        Add_ %edi,srtsf
        Mov_ %ebx,srtst
srt13:
        Add_ %edx,$cfp_b
        Mov_ %esi,%edx
        Mov_ %esi,(%esi)
        Add_ %esi,4(%esp)
        Mov_ %ecx,%ebx
        Sar_ %ecx,$2
        rep  movsl
        Dec_ srtnr
        Xor_ %eax,%eax
        Cmp_ srtnr,%eax
        jnz  srt13
srt15:
        pop  %edi
        Add_ %esp,$cfp_b
        Xor_ %eax,%eax
        Mov_ r_sxl,%eax
        Xor_ %eax,%eax
        Mov_ r_sxr,%eax
        Mov_ _rc_,$0
        Mov_ %eax,prc_+4*15
        Jmp_ *%eax
srt16:
        Mov_ _rc_,$256
        Jmp_ err_
srt17:
        Mov_ _rc_,$258
        Jmp_ err_
srt18:
        Mov_ _rc_,$1
        Mov_ %eax,prc_+4*15
        Jmp_ *%eax
sortc:
        Mov_ srts1,%ecx
        Mov_ srts2,%ebx
        Mov_ srtsc,%edx
        Add_ %esi,srtof
        Mov_ %edi,%esi
        Add_ %esi,%ecx
        Add_ %edi,%ebx
        Mov_ %esi,(%esi)
        Mov_ %edi,(%edi)
        Cmp_ srtdf,$nulls
        jne  src12
src01:
        Mov_ %edx,(%esi)
        Cmp_ %edx,(%edi)
        jne  src02
        Cmp_ %edx,$_b_scl
        je   src09
        Cmp_ %edx,$_b_icl
        je   src14
src02:
        Mov_ r_sxl,%esi
        Mov_ r_sxr,%edi
        Cmp_ %edx,$_b_scl
        je   src11
        Cmp_ (%edi),$_b_scl
        je   src11
src14:
        push %esi
        push %edi
        call acomp
        Dec_ _rc_
        js   call_278
        Dec_ _rc_
        jns  ppm_0487
        Jmp_ src10
ppm_0487:
        Dec_ _rc_
        jns  ppm_0488
        Jmp_ src10
ppm_0488:
        Dec_ _rc_
        jns  ppm_0489
        Jmp_ src03
ppm_0489:
        Dec_ _rc_
        jns  ppm_0490
        Jmp_ src08
ppm_0490:
        Dec_ _rc_
        jns  ppm_0491
        Jmp_ src05
ppm_0491:
call_278:
src03:
        Xor_ %eax,%eax
        Cmp_ srtsr,%eax
        jnz  src06
src04:
        Mov_ %edx,srtsc
        Mov_ _rc_,$1
        ret
src05:
        Xor_ %eax,%eax
        Cmp_ srtsr,%eax
        jnz  src04
src06:
        Mov_ %edx,srtsc
        Mov_ _rc_,$0
        ret
src07:
        Cmp_ %esi,%edi
        jb   src03
        Cmp_ %esi,%edi
        ja   src05
src08:
        Mov_ %eax,srts2
        Cmp_ srts1,%eax
        jb   src04
        Jmp_ src06
src09:
        push %esi
        push %edi
        call lcomp
        Dec_ _rc_
        js   call_279
        Dec_ _rc_
        jns  ppm_0492
        Mov_ _rc_,$299
        Jmp_ err_
ppm_0492:
        Dec_ _rc_
        jns  ppm_0493
        Mov_ _rc_,$299
        Jmp_ err_
ppm_0493:
        Dec_ _rc_
        jns  ppm_0494
        Jmp_ src03
ppm_0494:
        Dec_ _rc_
        jns  ppm_0495
        Jmp_ src08
ppm_0495:
        Dec_ _rc_
        jns  ppm_0496
        Jmp_ src05
ppm_0496:
call_279:
src10:
        Mov_ %esi,r_sxl
        Mov_ %edi,r_sxr
        Mov_ %edx,(%esi)
        Cmp_ %edx,(%edi)
        je   src07
src11:
        Mov_ %esi,%edx
        Mov_ %edi,(%edi)
        Dec_ %esi
        mov  (%esi),%al
        movzbl %al,%esi
        Dec_ %edi
        mov  (%edi),%al
        movzbl %al,%edi
        Cmp_ %esi,%edi
        ja   src05
        Jmp_ src03
src12:
        call sortf
        push %esi
        Mov_ %esi,%edi
        call sortf
        Mov_ %edi,%esi
        pop  %esi
        Jmp_ src01
sortf:
        Cmp_ (%esi),$b_pdt
        jne  srtf3
        push %edi
        Mov_ %edi,srtfd
        or   %edi,%edi
        jz   srtf4
        Cmp_ %edi,8(%esi)
        jne  srtf4
        Mov_ %eax,srtff
        Cmp_ srtdf,%eax
        jne  srtf4
        Add_ %esi,srtfo
srtf1:
        Mov_ %esi,(%esi)
srtf2:
        pop  %edi
srtf3:
        ret
srtf4:
        Mov_ %edi,%esi
        Mov_ %edi,8(%edi)
        Mov_ srtfd,%edi
        Mov_ %edx,4(%edi)
        Sal_ %edx,$2
        Add_ %edi,8(%edi)
srtf5:
        Sub_ %edx,$cfp_b
        Sub_ %edi,$cfp_b
        Mov_ %eax,srtdf
        Cmp_ (%edi),%eax
        je   srtf6
        or   %edx,%edx
        jnz  srtf5
        Jmp_ srtf2
srtf6:
        Mov_ %eax,(%edi)
        Mov_ srtff,%eax
        Add_ %edx,$4*pdfld
        Mov_ srtfo,%edx
        Add_ %esi,%edx
        Jmp_ srtf1
sorth:
        pop  prc_+4*16
        Mov_ srtsn,%ecx
        Mov_ srtwc,%edx
        Mov_ %esi,(%esp)
        Add_ %esi,srtso
        Add_ %esi,%edx
        Mov_ %eax,(%esi)
        Mov_ srtrt,%eax
        Add_ %edx,%edx
srh01:
        Cmp_ %edx,srtsn
        ja   srh03
        Cmp_ %edx,srtsn
        je   srh02
        Mov_ %edi,(%esp)
        Mov_ %esi,4(%esp)
        Add_ %edi,srtso
        Add_ %edi,%edx
        Mov_ %ecx,4(%edi)
        Mov_ %ebx,(%edi)
        call sortc
        Dec_ _rc_
        js   call_280
        Dec_ _rc_
        jns  ppm_0497
        Jmp_ srh02
ppm_0497:
call_280:
        Add_ %edx,$cfp_b
srh02:
        Mov_ %esi,4(%esp)
        Mov_ %edi,(%esp)
        Add_ %edi,srtso
        Mov_ %ebx,%edi
        Add_ %edi,%edx
        Mov_ %ecx,(%edi)
        Mov_ %edi,%ebx
        Mov_ %ebx,srtrt
        call sortc
        Dec_ _rc_
        js   call_281
        Dec_ _rc_
        jns  ppm_0498
        Jmp_ srh03
ppm_0498:
call_281:
        Mov_ %edi,(%esp)
        Add_ %edi,srtso
        Mov_ %esi,%edi
        Mov_ %ecx,%edx
        Sar_ %edx,$2
        Sar_ %edx,$1
        Sal_ %edx,$2
        Add_ %esi,%ecx
        Add_ %edi,%edx
        Mov_ %eax,(%esi)
        Mov_ (%edi),%eax
        Mov_ %edx,%ecx
        Add_ %edx,%edx
        jc   srh03
        Jmp_ srh01
srh03:
        Sar_ %edx,$2
        Sar_ %edx,$1
        Sal_ %edx,$2
        Mov_ %edi,(%esp)
        Add_ %edi,srtso
        Add_ %edi,%edx
        Mov_ %eax,srtrt
        Mov_ (%edi),%eax
        Mov_ %ecx,srtsn
        Mov_ %edx,srtwc
        Mov_ _rc_,$0
        Mov_ %eax,prc_+4*16
        Jmp_ *%eax
trace:
        pop  prc_+4*17
        call gtstg
        Dec_ _rc_
        js   call_282
        Dec_ _rc_
        jns  ppm_0499
        Jmp_ trc15
ppm_0499:
call_282:
        Add_ %edi,$cfp_f
#lch s.text (xr)  s.type 9  s.reg xr
#lch d.text wa  d.type 8  d.reg wa  w 0
        Xor_ %ecx,%ecx
        movb (%edi),%cl
        cmpb %cl,'A'
        jb   flc_0500
        cmpb %cl,'Z'
        ja   flc_0500
        Add_ %cl,$32
flc_0500:
        Mov_ %edi,(%esp)
        Mov_ (%esp),%esi
        Mov_ %edx,$trtac
        Cmp_ %ecx,$ch_la
        je   trc10
        Mov_ %edx,$trtvl
        Cmp_ %ecx,$ch_lv
        je   trc10
        Cmp_ %ecx,$ch_bl
        je   trc10
        Cmp_ %ecx,$ch_lf
        je   trc01
        Cmp_ %ecx,$ch_lr
        je   trc01
        Cmp_ %ecx,$ch_ll
        je   trc03
        Cmp_ %ecx,$ch_lk
        je   trc06
        Cmp_ %ecx,$ch_lc
        jne  trc15
trc01:
        call gtnvr
        Dec_ _rc_
        js   call_283
        Dec_ _rc_
        jns  ppm_0501
        Jmp_ trc16
ppm_0501:
call_283:
        Add_ %esp,$cfp_b
        Mov_ %edi,20(%edi)
        Cmp_ (%edi),$b_pfc
        jne  trc17
        Cmp_ %ecx,$ch_lr
        je   trc02
        Mov_ 24(%edi),%esi
        Cmp_ %ecx,$ch_lc
        je   exnul
trc02:
        Mov_ 28(%edi),%esi
        Mov_ _rc_,$0
        Mov_ %eax,prc_+4*17
        Jmp_ *%eax
trc03:
        call gtnvr
        Dec_ _rc_
        js   call_284
        Dec_ _rc_
        jns  ppm_0502
        Jmp_ trc16
ppm_0502:
call_284:
        Mov_ %esi,16(%edi)
        Cmp_ (%esi),$b_trt
        jne  trc04
        Mov_ %esi,8(%esi)
trc04:
        Cmp_ %esi,$stndl
        je   trc16
        pop  %ebx
        or   %ebx,%ebx
        jz   trc05
        Mov_ 16(%edi),%ebx
        Mov_ 12(%edi),$b_vrt
        Mov_ %edi,%ebx
        Mov_ 8(%edi),%esi
        Mov_ _rc_,$0
        Mov_ %eax,prc_+4*17
        Jmp_ *%eax
trc05:
        Mov_ 16(%edi),%esi
        Mov_ 12(%edi),$b_vrg
        Mov_ _rc_,$0
        Mov_ %eax,prc_+4*17
        Jmp_ *%eax
trc06:
        call gtnvr
        Dec_ _rc_
        js   call_285
        Dec_ _rc_
        jns  ppm_0503
        Jmp_ trc16
ppm_0503:
call_285:
        Xor_ %eax,%eax
        Cmp_ 28(%edi),%eax
        jnz  trc16
        Add_ %esp,$cfp_b
        or   %esi,%esi
        jz   trc07
        Mov_ 8(%esi),%edi
trc07:
        Mov_ %edi,32(%edi)
        Cmp_ %edi,$v_ert
        je   trc08
        Cmp_ %edi,$v_stc
        je   trc09
        Cmp_ %edi,$v_fnc
        jne  trc17
        Mov_ r_fnc,%esi
        Mov_ _rc_,$0
        Mov_ %eax,prc_+4*17
        Jmp_ *%eax
trc08:
        Mov_ r_ert,%esi
        Mov_ _rc_,$0
        Mov_ %eax,prc_+4*17
        Jmp_ *%eax
trc09:
        Mov_ r_stc,%esi
        call stgcc
        Mov_ _rc_,$0
        Mov_ %eax,prc_+4*17
        Jmp_ *%eax
trc10:
        call gtvar
        Dec_ _rc_
        js   call_286
        Dec_ _rc_
        jns  ppm_0504
        Jmp_ trc16
ppm_0504:
call_286:
        pop  %ebx
        Add_ %ecx,%esi
        Mov_ %edi,%ecx
trc11:
        Mov_ %esi,(%edi)
        Cmp_ (%esi),$b_trt
        jne  trc13
        Cmp_ %edx,4(%esi)
        jb   trc13
        Cmp_ %edx,4(%esi)
        je   trc12
        Add_ %esi,$4*trnxt
        Mov_ %edi,%esi
        Jmp_ trc11
trc12:
        Mov_ %esi,8(%esi)
        Mov_ (%edi),%esi
trc13:
        or   %ebx,%ebx
        jz   trc14
        Mov_ (%edi),%ebx
        Mov_ %edi,%ebx
        Mov_ 8(%edi),%esi
        Mov_ 4(%edi),%edx
trc14:
        Mov_ %edi,%ecx
        Sub_ %edi,$4*vrval
        call setvr
        Mov_ _rc_,$0
        Mov_ %eax,prc_+4*17
        Jmp_ *%eax
trc15:
        Mov_ _rc_,$2
        Mov_ %eax,prc_+4*17
        Jmp_ *%eax
trc16:
        Add_ %esp,$cfp_b
trc17:
        Mov_ _rc_,$1
        Mov_ %eax,prc_+4*17
        Jmp_ *%eax
trbld:
        push %edi
        Mov_ %ecx,$4*trsi_
        call alloc
        Mov_ (%edi),$b_trt
        Mov_ 16(%edi),%esi
        pop  12(%edi)
        Mov_ 4(%edi),%ebx
        Mov_ 8(%edi),$nulls
        ret
trimr:
        Mov_ %esi,%edi
        Mov_ %ecx,4(%edi)
        or   %ecx,%ecx
        jz   trim2
        Add_ %esi,%ecx
        Add_ %esi,$cfp_f
        or   %ebx,%ebx
        jz   trim3
        Mov_ %edx,$ch_bl
trim0:
#lch s.text -(xl)  s.type 11  s.reg xl
#lch d.text wb  d.type 8  d.reg wb  w 0
        dec  %esi
        Xor_ %ebx,%ebx
        movb (%esi),%bl
        Cmp_ %ebx,$ch_ht
        je   trim1
        Cmp_ %ebx,%edx
        jne  trim3
trim1:
        Dec_ %ecx
        or   %ecx,%ecx
        jnz  trim0
trim2:
        Mov_ _dnamp,%edi
        Mov_ %edi,$nulls
        Jmp_ trim5
trim3:
        Mov_ 4(%edi),%ecx
        Mov_ %esi,%edi
        Add_ %esi,%ecx
        Add_ %esi,$cfp_f
        mov  %ecx,ctbw_r
        movl $schar,ctbw_v
        call ctb_
        movl ctbw_r,%ecx
        Add_ %ecx,%edi
        Mov_ _dnamp,%ecx
        Mov_ %ecx,$cfp_c
        Xor_ %eax,%eax
        Mov_ %edx,%eax
trim4:
#sch s.text wc  s.type 8  s.reg wc
#sch d.text (xl)+  d.type 10  d.reg xl  w 0
        movb %dl,(%esi)
        Inc_ %esi
        Dec_ %ecx
        jnz  trim4
trim5:
        Xor_ %eax,%eax
        Mov_ %esi,%eax
        ret
trxeq:
        Mov_ %edx,r_cod
        Scp_ %ebx
        Sub_ %ebx,%edx
        push kvtra
        push %edi
        push %esi
        push %ecx
        push %edx
        push %ebx
        push _flptr
        Xor_ %eax,%eax
        push %eax
        Mov_ _flptr,%esp
        Xor_ %eax,%eax
        Mov_ kvtra,%eax
        Mov_ %edx,$trxdc
        Mov_ r_cod,%edx
        Lcp_ %edx
        Mov_ %ebx,%ecx
        Mov_ %ecx,$4*nmsi_
        call alloc
        Mov_ (%edi),$b_nml
        Mov_ 4(%edi),%esi
        Mov_ 8(%edi),%ebx
        Mov_ %esi,0(%esp)
        push %edi
        push 12(%esi)
        Mov_ %esi,16(%esi)
        Mov_ %esi,20(%esi)
        Cmp_ %esi,$stndf
        je   trxq2
        Mov_ %ecx,$num02
        Jmp_ cfunc
trxq1:
        Mov_ %esp,_flptr
        Add_ %esp,$cfp_b
        pop  _flptr
        pop  %ebx
        pop  %edx
        Mov_ %edi,%edx
        Mov_ %eax,4(%edi)
        Mov_ kvstn,%eax
        pop  %ecx
        pop  %esi
        pop  %edi
        pop  kvtra
        Add_ %ebx,%edx
        Lcp_ %ebx
        Mov_ r_cod,%edx
        ret
trxq2:
        Mov_ _rc_,$197
        Jmp_ err_
xscan:
        Mov_ xscwb,%ebx
        push %ecx
        push %ecx
        Mov_ %edi,r_xsc
        Mov_ %ecx,4(%edi)
        Mov_ %ebx,xsofs
        Sub_ %ecx,%ebx
        or   %ecx,%ecx
        jz   xscn3
        Add_ %edi,%ebx
        Add_ %edi,$cfp_f
xscn1:
#lch s.text (xr)+  s.type 10  s.reg xr
#lch d.text wb  d.type 8  d.reg wb  w 0
        Xor_ %ebx,%ebx
        movb (%edi),%bl
        Inc_ %edi
        Cmp_ %ebx,%edx
        je   xscn4
        Cmp_ %ebx,%esi
        je   xscn5
        Xor_ %eax,%eax
        Cmp_ (%esp),%eax
        jz   xscn2
        Inc_ xsofs
        Cmp_ %ebx,$ch_ht
        je   xscn2
        Cmp_ %ebx,$ch_bl
        je   xscn2
        Dec_ xsofs
        Xor_ %eax,%eax
        Mov_ (%esp),%eax
xscn2:
        Dec_ %ecx
        or   %ecx,%ecx
        jnz  xscn1
xscn3:
        Mov_ %esi,r_xsc
        Mov_ %ecx,4(%esi)
        Mov_ %ebx,xsofs
        Sub_ %ecx,%ebx
        Xor_ %eax,%eax
        Mov_ r_xsc,%eax
        Xor_ %eax,%eax
        Mov_ xscrt,%eax
        Jmp_ xscn7
xscn4:
        Mov_ xscrt,$num01
        Jmp_ xscn6
xscn5:
        Mov_ xscrt,$num02
xscn6:
        Mov_ %esi,r_xsc
        Mov_ %edx,4(%esi)
        Sub_ %edx,%ecx
        Mov_ %ecx,%edx
        Mov_ %ebx,xsofs
        Sub_ %ecx,%ebx
        Inc_ %edx
        Mov_ xsofs,%edx
xscn7:
        Xor_ %eax,%eax
        Mov_ %edi,%eax
        call sbstr
        Add_ %esp,$cfp_b
        pop  %ebx
        Xor_ %eax,%eax
        Cmp_ 4(%edi),%eax
        jz   xscn8
        call trimr
xscn8:
        Mov_ %ecx,xscrt
        Mov_ %ebx,xscwb
        ret
xscni:
        pop  prc_+4*18
        call gtstg
        Dec_ _rc_
        js   call_287
        Dec_ _rc_
        jns  ppm_0505
        Jmp_ xsci1
ppm_0505:
call_287:
        Mov_ r_xsc,%edi
        Xor_ %eax,%eax
        Mov_ xsofs,%eax
        or   %ecx,%ecx
        jz   xsci2
        Mov_ _rc_,$0
        Mov_ %eax,prc_+4*18
        Jmp_ *%eax
xsci1:
        Mov_ _rc_,$1
        Mov_ %eax,prc_+4*18
        Jmp_ *%eax
xsci2:
        Mov_ _rc_,$2
        Mov_ %eax,prc_+4*18
        Jmp_ *%eax
        Global sec06
sec06:  nop
        Add_ errft,$num04
        Mov_ %esp,_flptr
        Xor_ %eax,%eax
        Cmp_ gbcfl,%eax
        jnz  stak1
        Mov_ _rc_,$246
        Jmp_ err_
stak1:
        Mov_ %edi,$endso
        Xor_ %eax,%eax
        Mov_ kvdmp,%eax
        Jmp_ stopr
        Global sec07
sec07:
#sec07:a::g:rcode
err_:
        xchg %ecx,_rc_
error:
        Cmp_ r_cim,$cmlab
        je   cmple
        Mov_ kvert,%ecx
        Xor_ %eax,%eax
        Mov_ scnrs,%eax
        Xor_ %eax,%eax
        Mov_ scngo,%eax
        Mov_ polcs,$num01
        Mov_ _polct,$num01
        Mov_ %edi,stage
        jmp  *bsw_0506(,%edi,4)
        Data
bsw_0506:
        .long err01
        .long err04
        .long err04
        .long err05
        .long err01
        .long err04
        .long err04
        Text
err01:
        Mov_ %esp,cmpxs
        Xor_ %eax,%eax
        Cmp_ errsp,%eax
        jnz  err03
        Mov_ %edx,cmpsn
        call filnm
        Mov_ %ebx,scnse
        Mov_ %edx,rdcln
        Mov_ %edi,stage
        call sysea
        Dec_ _rc_
        js   call_288
        Dec_ _rc_
        jns  ppm_0507
        Jmp_ erra3
ppm_0507:
call_288:
        push %edi
        Mov_ %eax,erich
        Mov_ erlst,%eax
        call listr
        call prtis
        Xor_ %eax,%eax
        Mov_ erlst,%eax
        Mov_ %ecx,scnse
        or   %ecx,%ecx
        jz   err02
        Mov_ %ebx,%ecx
        Inc_ %ecx
        Mov_ %esi,r_cim
        call alocs
        Mov_ %ecx,%edi
        Add_ %edi,$cfp_f
        Add_ %esi,$cfp_f
erra1:
#lch s.text (xl)+  s.type 10  s.reg xl
#lch d.text wc  d.type 8  d.reg wc  w 0
        Xor_ %eax,%eax
        lodsb
        Mov_ %edx,%eax
        Cmp_ %edx,$ch_ht
        je   erra2
        Mov_ %edx,$ch_bl
erra2:
#sch s.text wc  s.type 8  s.reg wc
#sch d.text (xr)+  d.type 10  d.reg xr  w 0
        movb %dl,(%edi)
        Inc_ %edi
        Dec_ %ebx
        jnz  erra1
        Mov_ %esi,$ch_ex
#sch s.text xl  s.type 7  s.reg xl
#sch d.text (xr)  d.type 9  d.reg xr  w 1
        Mov_ %eax,%esi
        movb %al,(%edi)
        Mov_ profs,$stnpd
        Mov_ %edi,%ecx
        call prtst
err02:
        call prtis
        pop  %edi
        or   %edi,%edi
        jz   erra0
        call prtst
erra0:
        call ermsg
        Add_ lstlc,$num03
erra3:
        Xor_ %eax,%eax
        Mov_ %edi,%eax
        Cmp_ errft,$num03
        ja   stopr
        Inc_ cmerc
        Mov_ %eax,cswer
        Add_ noxeq,%eax
        Cmp_ stage,$stgic
        jne  cmp10
err03:
        Mov_ %edi,r_cim
        Add_ %edi,$cfp_f
#lch s.text (xr)  s.type 9  s.reg xr
#lch d.text xr  d.type 7  d.reg xr  w 1
        Xor_ %eax,%eax
        movb (%edi),%al
        mov  %eax,%edi
        Cmp_ %edi,$ch_mn
        je   cmpce
        Xor_ %eax,%eax
        Mov_ scnrs,%eax
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ errsp,%eax
        call scane
        Cmp_ %esi,$t_smc
        jne  err03
        Xor_ %eax,%eax
        Mov_ errsp,%eax
        Mov_ cwcof,$4*cdcod
        Mov_ %ecx,$ocer_
        call cdwrd
        Mov_ %eax,cwcof
        Mov_ 32(%esp),%eax
        Xor_ %eax,%eax
        Inc_ %eax
        Mov_ 24(%esp),%eax
        call cdwrd
        Jmp_ cmpse
err04:
        Cmp_ errft,$num03
        jae  labo1
        Cmp_ kvert,$nm320
        je   err06
        Xor_ %eax,%eax
        Mov_ r_ccb,%eax
        Mov_ cwcof,$4*cccod
        call ertex
        Sub_ %esp,$cfp_b
erra4:
        Add_ %esp,$cfp_b
        Cmp_ %esp,_flprt
        je   errc4
        Cmp_ %esp,_gtcef
        jne  erra4
        Mov_ stage,$stgxt
        Mov_ %eax,r_gtc
        Mov_ r_cod,%eax
        Mov_ _flptr,%esp
        Xor_ %eax,%eax
        Mov_ r_cim,%eax
        Xor_ %eax,%eax
        Mov_ cnind,%eax
errb4:
        Xor_ %eax,%eax
        Cmp_ kverl,%eax
        jnz  err07
        Jmp_ exfal
errc4:
        Mov_ %esp,_flptr
        Jmp_ errb4
err05:
        Xor_ %eax,%eax
        Cmp_ dmvch,%eax
        jnz  err08
err06:
        Xor_ %eax,%eax
        Cmp_ kverl,%eax
        jz   labo1
        call ertex
err07:
        Cmp_ errft,$num03
        jae  labo1
        Dec_ kverl
        Mov_ %esi,r_ert
        call ktrex
        Mov_ %ecx,r_cod
        Mov_ r_cnt,%ecx
        Scp_ %ebx
        Sub_ %ebx,%ecx
        Mov_ stxoc,%ebx
        Mov_ %edi,_flptr
        Mov_ %eax,(%edi)
        Mov_ stxof,%eax
        Mov_ %edi,r_sxc
        or   %edi,%edi
        jz   lcnt1
        Xor_ %eax,%eax
        Mov_ r_sxc,%eax
        Mov_ stxvr,$nulls
        Mov_ %esi,(%edi)
        Jmp_ *%esi
err08:
        Mov_ %edi,dmvch
        or   %edi,%edi
        jz   err06
        Mov_ %eax,(%edi)
        Mov_ dmvch,%eax
        call setvr
_s_yyy:
        Jmp_ err08
# osx renamed
# fixed 298
