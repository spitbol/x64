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


// this is included first for the C64 interface.

typedef unsigned char m_char;  // reference to byte in memory
typedef unsigned char d_char; // define value of byte
typedef double m_real;	// reference to floating point value in memory
typedef double d_real;  // define value for floating point

typedef unsigned long d_word;
typedef unsigned long m_word;
typedef unsigned long word;


// The registers
word xl;
word xr;
word w0;
word w1;
word wa;
word wb;
word wc;
word xs;
word ia;
word cp;
word _rt_;

void (*goto_nextfunction)();
word goto_counter=0;




#define work_base xl
#define index_left xl
#define index_t xt
#define index_right xr
#define the_stack xs
#define work_a wa
#define work_b wb
#define work_c wc
#define integer_accumulator ia
#define temp_register w0
#define code_pointer cp
#define work_register w0
/* ^^^ add work_register */
#define NULL (void *)0


#define xt xl
#define wa_l *((byte *)(&wa))
#define wb_l *((byte *)(&wb))
#define w0_l *(byte *)(&w0))

#define CFP_B	8
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




#define C_GOTO(new_func) \
 { if ((goto_counter++) &31) { new_func();} else goto_nextfunction = new_func; return;}
#define C_CALL(new_func) {new_func(); }

#define C_POP() \
  *((word *)(xs += CFP_B))
#define C_TOP() \
  *((word *)(xs + CFP_B))
#define C_PUSH(val)  *((word *)(xs -= CFP_B)) = val

typedef void (*voidcall());

#define C_JSR(procedureya) \
  {C_CALL(procedureya); while (goto_nextfunction) { goto_nextfunction(); }}
#define C_JSR1(procedureya,nogo) \
  {C_CALL(procedureya); while (goto_nextfunction) { goto_nextfunction(); } if (_rt_) nogo; }

#define C_JSR2(procedureya,other1,other2) \
  {C_CALL(procedureya); while (goto_nextfunction) { goto_nextfunction(); } if(_rt_==1) other1; if (_rt_==2) other2; }
  
#define C_JSR3(procedureya,other1,other2,other3) \
  {C_CALL(procedureya); while (goto_nextfunction) { goto_nextfunction(); } if(_rt_==1) other1; if (_rt_==2) other2; \
    if (_rt_==3) other3;}
    
#define C_JSR4(procedureya,other1,other2other3) \
  {C_CALL(procedureya); while (goto_nextfunction) { goto_nextfunction(); } if(_rt_==1) other1; if (_rt_==2) other2; \
    if (_rt_==3) other3;    if (_rt_==4) other4;}
/* C_ERR and C_GOTO are the parameters other... for the C_JSR variants */

#define C_ERR(errnumber) {error_found(errnumber);return;}


extern void error_found(word errornum);

