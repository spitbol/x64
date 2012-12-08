	global	reg_block
	global	reg_wa
	global	reg_wb
	global	reg_ia
	global	reg_wc
	global	reg_xr
	global	reg_xl
	global	reg_cp
	global	reg_ra
	global	reg_pp
	global	reg_pc
	global	reg_xs
	global	reg_size

 	global	minimal
	extern	calltab
	extern	stacksiz
 
; Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
; 
; This file is part of Macro SPITBOL.
; 
;     Macro SPITBOL is free software: you can redistribute it and/or modify
;     it under the terms of the GNU General Public License as published by
;     the Free Software Foundation, either version 3 of the License, or
;     (at your option) any later version.
; 
;     Macro SPITBOL is distributed in the hope that it will be useful,
;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;     GNU General Public License for more details.
; 
;     You should have received a copy of the GNU General Public License
;     along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
;
%define globals 1                       ;ASM globals defined here

;
;       File: inter.s           Version: 1.46
;       ---------------------------------------
;
;       This file contains the assembly language routines that interface
;       the Macro SPITBOL compiler written in 80386 assembly language to its
;       operating system interface functions written in C.
;
;       Contents:
;
;       o Overview
;       o Global variables accessed by OSINT functions
;       o Interface routines between compiler and OSINT functions
;       o C callable function startup
;       o C callable function get_fp
;       o C callable function restart
;       o C callable function makeexec
;       o Routines for Minimal opcodes CHK and CVD
;       o Math functions for integer multiply, divide, and remainder
;       o Math functions for real operation
;
;-----------
;
;       Overview
;
;       The Macro SPITBOL compiler relies on a set of operating system
;       interface functions to provide all interaction with the host
;       operating system.  These functions are referred to as OSINT
;       functions.  A typical call to one of these OSINT functions takes
;       the following form in the 80386 version of the compiler:
;
;               ...code to put arguments in registers...
;               call    SYSXX           # call osint function
;               dd      EXIT_1          # address of exit point 1
;               dd      EXIT_2          # address of exit point 2
;               ...     ...             # ...
;               dd      EXIT_n          # address of exit point n
;               ...instruction following call...
;
;       The OSINT function 'SYSXX' can then return in one of n+1 ways:
;       to one of the n exit points or to the instruction following the
;       last exit.  This is not really very complicated - the call places
;       the return address on the stack, so all the interface function has
;       to do is add the appropriate offset to the return address and then
;       pick up the exit address and jump to it OR do a normal return via
;       an ret instruction.
;
;       Unfortunately, a C function cannot handle this scheme.  So, an
;       intermediary set of routines have been established to allow the
;       interfacing of C functions.  The mechanism is as follows:
;
;       (1) The compiler calls OSINT functions as described above.
;
;       (2) A set of assembly language interface routines is established,
;           one per OSINT function, named accordingly.  Each interface
;           routine ...
;
;           (a) saves all compiler registers in global variables
;               accessible by C functions
;           (b) calls the OSINT function written in C
;           (c) restores all compiler registers from the global variables
;           (d) inspects the OSINT function's return value to determine
;               which of the n+1 returns should be taken and does so
;
;       (3) A set of C language OSINT functions is established, one per
;           OSINT function, named differently than the interface routines.
;           Each OSINT function can access compiler registers via global
;           variables.  NO arguments are passed via the call.
;
;           When an OSINT function returns, it must return a value indicating
;           which of the n+1 exits should be taken.  These return values are
;           defined in header file 'inter.h'.
;
;       Note:  in the actual implementation below, the saving and restoring
;       of registers is actually done in one common routine accessed by all
;       interface routines.
;
;       Other notes:
;
;       Some C ompilers transform "internal" global names to
;       "external" global names by adding a leading underscore at the front
;       of the internal name.  Thus, the function name 'osopen' becomes
;       '_osopen'.  However, not all C compilers follow this convention.
;
;------------
;
;       Global Variables
;
        segment	.data
; 	extern	swcoup
; 
; 	extern	stacksiz
; 	extern	lmodstk
; 	extern	lowsp
; 	extern	outptr
; 	extern	calltab
; 
; ;       .include "extrn386.inc"
; 
; 
; ; Words saved during exit(-3)
; ;
        align 4
reg_block:
reg_wa:	dd	0        ; Register WA (ECX)
reg_wb:	dd 	0        ; Register WB (EBX)
reg_ia:
reg_wc:	dd	0		; Register WC & IA (EDX)
reg_xr:	dd	0        ; Register XR (EDI)
reg_xl:	dd	0        ; Register XL (ESI)
reg_cp:	dd	0        ; Register CP
reg_ra	dq 	0.0  ; Register RA
;
; These locations save information needed to return after calling OSINT
; and after a restart from EXIT()
;
reg_pc: dd      0               ; return PC from caller
reg_pp: dd      0               ; Number of bytes of PPMs
reg_xs:	dd	0;		 Minimal stack pointer
;
;	r_size  equ       $-reg_block
; use computed value for nasm conversion, put back proper code later
r_size	equ	44
reg_size:	dd   r_size

;
; end of words saved during exit(-3)
;

;
;  Constants
;
	global	ten
ten:    dd      10              ; constant 10
        global  inf
inf:	dd	0   
        dd      0x7ff00000      ; double precision infinity

	global	sav_block
;sav_block: times r_size db 0     ; Save Minimal registers during push/pop reg
sav_block: times 44 db 0     ; Save Minimal registers during push/pop reg
;
        align 4
	global	ppoff
ppoff:  dd      0               ; offset for ppm exits
	global	compsp
compsp: dd      0               ; 1.39 compiler's stack pointer
	global	sav_compsp
sav_compsp:
        dd      0               ; save compsp here
	global	osisp
osisp:  dd      0               ; 1.39 OSINT's stack pointer
	global	_rc_
_rc_:	dd   0	; return code from osint procedure
; 
%define SETREAL 0
;
;       Setup a number of internal addresses in the compiler that cannot
;       be directly accessed from within C because of naming difficulties.
;
        global  ID1
ID1:	dd   0
%if SETREAL == 1
        dd       2

        dd       1
        db  "1x\x00\x00\x00"
%endif
;
        global  ID2BLK
ID2BLK	dd   52
        dd      0
        times   52 db 0

        global  TICBLK
TICBLK:	dd   0
        dd      0

        global  TSCBLK
TSCBLK:	 dd   512
        dd      0
        times   512 db 0

;
;       Standard input buffer block.
;
        global  INPBUF
INPBUF:	dd	0		; type word
        dd      0               ; block length
        dd      1024            ; buffer size
        dd      0               ; remaining chars to read
        dd      0               ; offset to next character to read
        dd      0               ; file position of buffer
        dd      0               ; physical position in file
        times   1024 db 0        ; buffer
;
        global  TTYBUF
TTYBUF:	dd   0     ; type word
        dd      0               ; block length
        dd      260             ; buffer size  (260 OK in MS-DOS with cinread())
        dd      0               ; remaining chars to read
        dd      0               ; offset to next char to read
        dd      0               ; file position of buffer
        dd      0               ; physical position in file
        times   260 db 0         ; buffer
; ;-----------
; ;
; ;       Save and restore MINIMAL and interface registers on stack.
; ;       Used by any routine that needs to call back into the MINIMAL
; ;       code in such a way that the MINIMAL code might trigger another
; ;       SYSxx call before returning.
; ;
; ;       Note 1:  pushregs returns a collectable value in XL, safe
; ;       for subsequent call to memory allocation routine.
; ;
; ;       Note 2:  these are not recursive routines.  Only reg_xl is
; ;       saved on the stack, where it is accessible to the garbage
; ;       collector.  Other registers are just moved to a temp area.
; ;
; ;       Note 3:  popregs does not restore REG_CP, because it may have
; ;       been modified by the Minimal routine called between pushregs
; ;       and popregs as a result of a garbage collection.  Calling of
; ;       another SYSxx routine in between is not a problem, because
; ;       CP will have been preserved by Minimal.
; ;
; ;       Note 4:  if there isn't a compiler stack yet, we don't bother
; ;       saving XL.  This only happens in call of nextef from sysxi when
; ;       reloading a save file.
; ;
; ;
	global	pushregs
pushregs:
	pushad
	lea	esi,[reg_block]
	lea	edi,[sav_block]
	mov	ecx,r_size/4
	cld
   rep	movsd

        mov     edi,dword [compsp]
        or      edi,edi                         ; 1.39 is there a compiler stack
        je      push1                     ; 1.39 jump if none yet
        sub     edi,4                           ;push onto compiler's stack
        mov     esi,dword [reg_xl]                      ;collectable XL
	mov	[edi],esi
        mov     dword [compsp],edi                      ;smashed if call OSINT again (SYSGC)
        mov     dword [sav_compsp],edi                  ;used by popregs

push1:	popad
	ret

	global	popregs
popregs:
	pushad
        mov     eax,dword [reg_cp]                      ;don't restore CP
	cld
	lea	esi,[sav_block]
        lea     edi,[reg_block]                   ;unload saved registers
	mov	ecx,r_size/4
   rep  movsd                                   ;restore from temp area
	mov	dword [reg_cp],eax

        mov     edi,dword [sav_compsp]                  ;saved compiler's stack
        or      edi,edi                         ;1.39 is there one?
        je      pop1                      ;1.39 jump if none yet
        mov     esi,dword [edi]                       ;retrieve collectable XL
        mov     dword [reg_xl],esi                      ;update XL
        add     edi,4                           ;update compiler's sp
        mov     dword [compsp],edi

pop1:	popad
	ret

; ;
; ;
; ;-----------
; ;
; ;       startup( char *dummy1, char *dummy2) - startup compiler
; ;
; ;       An OSINT C function calls startup to transfer control
; ;       to the compiler.
; ;
; ;       (XR) = basemem
; ;       (XL) = topmem - sizeof(WORD)
; ;
; ;	Note: This function never returns.
; ;
; 
	global	startup
;   Ordinals for MINIMAL calls from assembly language.
;
;   The order of entries here must correspond to the order of
;   calltab entries in the INTER assembly language module.
;
CALLTAB_RELAJ equ   0
CALLTAB_RELCR equ   1
CALLTAB_RELOC equ   2
CALLTAB_ALLOC equ   3
CALLTAB_ALOCS equ   4
CALLTAB_ALOST equ   5
CALLTAB_BLKLN equ   6
CALLTAB_INSTA equ   7
CALLTAB_RSTRT equ   8
CALLTAB_START equ   9
CALLTAB_FILNM equ   10
CALLTAB_DTYPE equ   11
CALLTAB_ENEVS equ   12
CALLTAB_ENGTS equ   13


startup:
        pop     eax                     ; discard return
        pop     eax                     ; discard dummy1
        pop     eax                     ; discard dummy2
	call	stackinit               ; initialize MINIMAL stack
        mov     eax,dword [compsp]              ; get MINIMAL's stack pointer
        mov dword[reg_wa],eax                     ; startup stack pointer

	cld                             ; default to UP direction for string ops
;        GETOFF  eax,DFFNC               # get address of PPM offset
        mov     dword [ppoff],eax               ; save for use later
;
        mov     esp,dword [osisp]               ; switch to new C stack
	push	CALLTAB_START
	call	minimal			; load regs, switch stack, start compiler

; 
; 
; 
;
;-----------
;
;	stackinit  -- initialize LOWSPMIN from sp.
;
;	Input:  sp - current C stack
;		stacksiz - size of desired Minimal stack in bytes
;
;	Uses:	eax
;
;	Output: register WA, sp, LOWSPMIN, compsp, osisp set up per diagram:
;
;	(high)	+----------------+
;		|  old C stack   |
;	  	|----------------| <-- incoming sp, resultant WA (future XS)
;		|	     ^	 |
;		|	     |	 |
;		/ stacksiz bytes /
;		|	     |	 |
;		|            |	 |
;		|----------- | --| <-- resultant LOWSPMIN
;		| 400 bytes  v   |
;	  	|----------------| <-- future C stack pointer, osisp
;		|  new C stack	 |
;	(low)	|                |
;
;
;

	global	stackinit
stackinit:
	mov	eax,esp
        mov     dword [compsp],eax              ; save as MINIMAL's stack pointer
	sub	eax,dword [stacksiz]            ; end of MINIMAL stack is where C stack will start
        mov     dword [osisp],eax               ; save new C stack pointer
	add	eax,4*100               ; 100 words smaller for CHK
	extern	LOWSPMIN
	mov	dword [LOWSPMIN],eax
	ret

;
;-----------
;
;       mimimal -- call MINIMAL function from C
;
;       Usage:  extern void minimal(WORD callno)
;
;       where:
;         callno is an ordinal defined in osint.h, osint.inc, and calltab.
;
;       Minimal registers WA, WB, WC, XR, and XL are loaded and
;       saved from/to the register block.
;
;       Note that before restart is called, we do not yet have compiler
;       stack to switch to.  In that case, just make the call on the
;       the OSINT stack.
;

 minimal:
         pushad                          ; save all registers for C
         mov     eax,dword [esp+32+4]          ; get ordinal
         mov     ecx,dword [reg_wa]              ; restore registers
 	mov	ebx,dword [reg_wb]
         mov     edx,dword [reg_wc]              ; (also _reg_ia)
 	mov	edi,dword [reg_xr]
 	mov	esi,dword [reg_xl]
 	mov	ebp,dword [reg_cp]
 
         mov     dword [osisp],esp               ; 1.39 save OSINT stack pointer
         cmp     dword [compsp],0      ; 1.39 is there a compiler stack?
         je      min1              ; 1.39 jump if none yet
         mov     esp,dword [compsp]              ; 1.39 switch to compiler stack
 
 min1:   call   dword [calltab+eax*4]        ; off to the Minimal code
 
         mov     esp,dword [osisp]               ; 1.39 switch to OSINT stack
 
         mov     dword [reg_wa],ecx              ; save registers
 	mov	dword [reg_wb],ebx
 	mov	dword [reg_wc],edx
 	mov	dword [reg_xr],edi
 	mov	dword [reg_xl],esi
 	mov	dword [reg_cp],ebp
 	popad
 	ret
 
 
