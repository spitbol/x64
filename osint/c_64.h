// copyright 1987-2012 robert b. k. dewar and mark emmer.

// copyright 2012-2015 david shields
//
// this file is part of macro spitbol.
//
//     macro spitbol is free software: you can redistribute it and/or modify
//     it under the terms of the gnu general public license as published by
//     the free software foundation, either version 2 of the license, or
//     (at your option) any later version.
//
//     macro spitbol is distributed in the hope that it will be useful,
//     but without any warranty// without even the implied warranty of
//     merchantability or fitness for a particular purpose.  see the
//     gnu general public license for more details.
//
//     you should have received a copy of the gnu general public license
//     along with macro spitbol.  if not, see <http://www.gnu.org/licenses/>.
#include <math.h>

// this is included first for the C64 interface.

typedef unsigned char m_char;  // reference to byte in memory
typedef unsigned char d_char; // define value of byte
typedef double m_real;	// reference to floating point value in memory
typedef double d_real;  // define value for floating point

typedef unsigned long d_word;
typedef unsigned long m_word;
//typedef unsigned long word;
// port.h does this one


typedef union itis { 
  word w;
  word *wp;
  m_char *chp;
  void *vp;
  void (*callp)();
  double *dp;
  double d;
  char c[4];} 
  itis;

// exp10 is a math function. So is log. Neex to differentiate
#define exp10 ezp10


#define	FLAG_OF	0x80
#define	FLAG_CF	0x01
#define	FLAG_CA	0x40

#define xl (xl_it.w)
#define xr (xr_it.w)
#define w0 (w0_it.w)
#define w1 (w1_it.w)
#define wa (wa_it.w)
#define wb (wb_it.w)
#define wc (wc_it.w)
#define xs (xs_it.w)
#define ia (ia_it.w)
#define cp (cp_it.w)
#define ra (ra_it.d)
#define rp (rp_it.dp)
#define rp (rp_it.dp)
#define fl (fl_it.c[0])

itis xl_it;
itis xr_it;
itis w0_it;
itis w1_it;
itis wa_it;
itis wb_it;
itis wc_it;
itis xs_it;
itis ia_it;
itis cp_it;
itis ra_it;
itis rp_it;
itis fl_it;
word _rt_;

void (*goto_nextfunction)();
word goto_counter=0;






#define xt xl
#define xt_it xl_it
#define wa_l *((byte *)(&wa))
#define wb_l *((byte *)(&wb))
#define w0_l *(byte *)(&w0))

#define CFP_B	8
#define CFP_C	8
#define LOG_CFP_B 3
#define LOG_CFP_C 3
#define CFP_C_VAL	8
#define LOG_CFP_C 3
#define CFP_M_	9223372036854775807
//	%define	cfp_n_	64


//	flags
#define	FLAG_OF	0x80
#define	flag_cf	0x01
#define	flag_ca	0x40




#define C_GOTO(new_func) { if ((goto_counter++) &31) { new_func();} else goto_nextfunction = new_func; return;}
#define C_CALL(new_func) {new_func(); }

#define C_POP() \
  *(xs_it.wp++)
#define C_TOP() \
  *(xs_it.wp)
#define C_PUSH(val)  *(--xs_it.wp) = val

typedef void (*voidcall());

#define C_JSR(procedureya) \
  {C_CALL(procedureya); while (goto_nextfunction) { goto_nextfunction(); }}
#define C_JSR_1(procedureya,nogo) \
  {C_CALL(procedureya); while (goto_nextfunction) { goto_nextfunction(); } if (_rt_) nogo; }

#define C_JSR_2(procedureya,other1,other2) \
  {C_CALL(procedureya); while (goto_nextfunction) { goto_nextfunction(); } if(_rt_==1) other1; if (_rt_==2) other2; }
  
#define C_JSR_3(procedureya,other1,other2,other3) \
  {C_CALL(procedureya); while (goto_nextfunction) { goto_nextfunction(); } if(_rt_==1) other1; if (_rt_==2) other2; \
    if (_rt_==3) other3;}
    
#define C_JSR_4(procedureya,other1,other2,other3,other4) \
  {C_CALL(procedureya); while (goto_nextfunction) { goto_nextfunction(); } if(_rt_==1) other1; if (_rt_==2) other2; \
    if (_rt_==3) other3;    if (_rt_==4) other4;}
/* C_ERR and C_GOTO are the parameters other... for the C_JSR variants */

#define C_JSR_5(procedureya,other1,other2,other3,other4,other5) \
  {C_CALL(procedureya); while (goto_nextfunction) { goto_nextfunction(); } if(_rt_==1) other1; if (_rt_==2) other2; \
    if (_rt_==3) other3;    if (_rt_==4) other4; if (_rt_==5) other5;}
/* C_ERR and C_GOTO are the parameters other... for the C_JSR variants */

#define C_JSR_6(procedureya,other1,other2,other3,other4,other5,other6) \
  {C_CALL(procedureya); while (goto_nextfunction) { goto_nextfunction(); } if(_rt_==1) other1; if (_rt_==2) other2; \
    if (_rt_==3) other3;    if (_rt_==4) other4; if (_rt_==5) other5; if (_rt_==6) other6;}

#define C_JSR_7(procedureya,other1,other2,other3,other4,other5,other6,other7) \
  {C_CALL(procedureya); while (goto_nextfunction) { goto_nextfunction(); } if(_rt_==1) other1; if (_rt_==2) other2; \
    if (_rt_==3) other3;    if (_rt_==4) other4; if (_rt_==5) other5; if (_rt_==6) other6;if (_rt_==7) other7;}

    
#define C_JSR_8(procedureya,other1,other2,other3,other4,other5,other6,other7,other8) \
  {C_CALL(procedureya); while (goto_nextfunction) { goto_nextfunction(); } if(_rt_==1) other1; if (_rt_==2) other2; \
    if (_rt_==3) other3;    if (_rt_==4) other4; if (_rt_==5) other5; if (_rt_==6) other6;if (_rt_==7) other7; \
    if (_rt_==7) other8;}
	    
    
/* C_ERR and C_GOTO are the parameters other... for the C_JSR variants */


#define C_ERR(errnumber) {error_found(errnumber);return;}

/* error base - probably wrong */
#define C_ERB(errnumber) {error_found(errnumber);return;}

#define C_EXIT(par) { goto_nextfunction = NULL;  _rt_ = par;return;}

extern void error_found(word errornum);
extern void ezzor();


