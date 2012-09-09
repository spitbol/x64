;        .title          "spitbol assembly-language to c-language o/s interface"
;        .sbttl          "inter"
; copyright 1987-2012 robert b. k. dewar and mark emmer.
; 
; this file is part of macro spitbol.
; 
;     macro spitbol is free software: you can redistribute it and/or modify
;     it under the terms of the gnu general public license as published by
;     the free software foundation, either version 3 of the license, or
;     (at your option) any later version.
; 
;     macro spitbol is distributed in the hope that it will be useful,
;     but without any warranty; without even the implied warranty of
;     merchantability or fitness for a particular purpose.  see the
;     gnu general public license for more details.
; 
;     you should have received a copy of the gnu general public license
;     along with macro spitbol.  if not, see <http://www.gnu.org/licenses/>.

%define globals 1

        %include        "mintype.h"
        %include        "os.inc"
	%macro	atline 1
	mov	dword [nlines],%1
	call	atlin
	%endmacro

        segment .data

;       this file contains the assembly language routines that interface
;       the macro spitbol compiler written in 80386 assembly language to its
;       operating system interface functions written in c.
;
;       contents:
;
;       o overview
;       o global variables accessed by osint functions
;       o c callable function startup
;       o c callable function get_fp
;       o c callable function restart
;       o c callable function makeexec
;       o routines for minimal opcodes chk and cvd
;       o math functions for integer multiply, divide, and remainder
;       o math functions for real operation
;
;-----------
;
;       overview
;
;       the macro spitbol compiler relies on a set of operating system
;       interface functions to provide all interaction with the host
;       operating system.  these functions are referred to as osint
;       functions.  a typical call to one of these osint functions takes
;       the following form in the 80386 version of the compiler:
;
;               ...code to put arguments in registers...
;               call    sysxx           ; call osint function
;               dd      exit_1          ; dd of exit point 1
;               dd      exit_2          ; dd of exit point 2
;               ...     ...             ; ...
;               dd      exit_n          ; dd of exit point n
;               ...instruction following call...
;
;       the osint function 'sysxx' can then return in one of n+1 ways:
;       to one of the n exit points or to the instruction following the
;       last exit.  this is not really very complicated - the call places
;       the return dd on the stack, so all the interface function has
;       to do is add the appropriate offset to the return dd and then
;       pick up the exit dd and jump to it or do a normal return via
;       an ret instruction.
;
;       unfortunately, a c function cannot handle this scheme.  so, an
;       intermediary set of routines have been established to allow the
;       interfacing of c functions.  the mechanism is as follows:
;
;       (1) the compiler calls osint functions as described above.
;
;       (2) a set of assembly language interface routines is established,
;           one per osint function, named accordingly.  each interface
;           routine ...
;
;           (a) saves all compiler registers in global variables
;               accessible by c functions
;           (b) calls the osint function written in c
;           (c) restores all compiler registers from the global variables
;           (d) inspects the osint function's return value to determine
;               which of the n+1 returns should be taken and does so
;
;       (3) a set of c language osint functions is established, one per
;           osint function, named differently than the interface routines.
;           each osint function can access compiler registers via global
;           variables.  no arguments are passed via the call.
;
;           when an osint function returns, it must return a value indicating
;           which of the n+1 exits should be taken.  these return values are
;           defined in header file 'inter.h'.
;
;       note:  in the actual implementation below, the saving and restoring
;       of registers is actually done in one common routine accessed by all
;       interface routines.
;
;       other notes:
;
;       some c ompilers transform "internal" global names to
;       "external" global names by adding a leading underscore at the front
;       of the internal name.  thus, the function name 'osopen' becomes
;       '_osopen'.  however, not all c compilers follow this convention.
;
;       acknowledgement:
;
;       this interfacing scheme is based on an idea put forth by andy koenig.
;
;------------
;
;       global variables
;
        extern  swcoup
	extern	atlin
	extern	nlines
	extern	stacksiz
	extern	lmodstk
	extern	lowsp
	extern	outptr
%if direct == 0
        extern     valtab
%endif

        %include "x86/extern-x86.inc"

	segment	.data
; words saved during exit(-3)
;
        align 4

        global  reg_cp
        global  reg_ia
        global  reg_pc
        global  reg_pp
        global  reg_ra
        global  reg_xl
        global  reg_xr
        global  reg_xs
        global  reg_wa
        global  reg_wb
        global  reg_wc

        global  reg_block
        global  reg_size
reg_block:
reg_wa: dd      0     		; Register WA (ECX)
reg_wb: dd      0     		; Register WB (EBX)
reg_ia:
reg_wc: dd   	0     		; Register WC & IA (EDX)
reg_xr: dd   	0     		; Register XR (EDI)
reg_xl: dd   	0     		; Register XL (ESI)
reg_cp: dd   	0     		; Register CP
reg_ra: dq   	0e    		; Register RA
;
; these locations save information needed to return after calling osint
; and after a restart from exit()
;
reg_pc:	dd	0		; return pc from caller
reg_pp: dd      0               ; number of bytes of ppms
reg_xs:	dd   	0  		; minimal stack pointer

;
r_size equ      $-reg_block
reg_size        db      r_size
;
;	reg_dump is used to retrieve the register values for
;	use during debugging
	global	reg_dump

	global	dump_wa
	global	dump_wb
	global	dump_wc
	global	dump_w0
	global	dump_xl
	global	dump_xr
	global 	dump_xs
	global	dump_cp
	global	dump_pp

dump_wa: dd      0     		; Register WA (ECX)
dump_wb: dd      0     		; Register WB (EBX)
dump_ia:
dump_wc: dd   	0     		; Register WC & IA (EDX)
dump_xl: dd   	0     		; Register XL (ESI)
dump_xr: dd   	0     		; Register XR (EDI)
dump_xs:	dd   	0  		; minimal stack pointer
dump_cp: dd   	0     		; Register CP
dump_ra: dq   	0e    		; Register RA
dump_pc: dd	0		; return pc from caller
dump_pp: dd      0               ; number of bytes of ppms
dump_w0: dd	0


; end of words saved during exit(-3)
;
sav_block: times r_size dd 0    ; save minimal registers during push/pop reg
;
        align 4
	global	ppoff
ppoff:  dd      0               ; offset for ppm exits
	global	compsp
compsp: dd      0               ; compiler's stack pointer
sav_compsp:
        dd      0               ; save compsp here
	global	osisp
osisp:  dd      0               ; osint's stack pointer


;
;       setup a number of internal ddes in the compiler that cannot
;       be directly accessed from within c because of naming difficulties.
;
	global	ID1
ID1	dd	0
%ifdef setreal
        dd       2
        db  "1x\x00\x00"
%else
        dd       1
        db  "1x\x00\x00\x00"
%endif
;
	global	ID2BLK
	dd	0
ID2BLK:	times	52 dd 0
	global	TSCBLK

	global	TICBLK
TICBLK:	dd	0

	global	TSCBLk
        dd      0
TSCBLK:	times	512 dd 0

;       standard input buffer block.
;
	global	INPBUF
INPBUF:
        dd      0               ; type work
        dd      0               ; block length
        dd      1024            ; buffer size
        dd      0               ; remaining chars to read
        dd      0               ; offset to next character to read
        dd      0               ; file position of buffer
        dd      0               ; physical position in file
        times   1024 dd 0       ; buffer
;
	global	TTYBUF
TTYBUF:	dd   	0     		; type word
        dd      0               ; block length
        dd      260             ; buffer size  (260 ok in ms-dos with cinread())
        dd      0               ; remaining chars to read
        dd      0               ; offset to next char to read
        dd      0               ; file position of buffer
        dd      0               ; physical position in file
        times   260 dd 0        ; buffer


        segment .text

;       mimimal_call -- call minimal function from c
;
;       usage:  extern void minimal_call(word callno)
;
;       where:
;         callno is an ordinal defined in osint.h, osint.inc, and calltab.
;
;       minimal registers wa, wb, wc, xr, and xl are loaded and
;       saved from/to the register block.
;
;       note that before restart is called, we do not yet have compiler
;       stack to switch to.  in that case, just make the call on the
;       the osint stack.

	global	dump_regs
dump_regs:
	mov	ecx,[dump_wa]
	mov	ebx,[dump_wb]
	mov	edx,[dump_wc]
	mov	edi,[dump_xr]
	mov	esi,[dump_xl]
	mov	esp,[dump_xs]
	mov	ebp,[dump_cp]
;	mov	cpx,[dump_ra]
;	mov	xxx,[dump_pc]
	mov	eax,[dump_w0]
	ret

	global	minimal_call
minimal_call:

        pushad                          	; save all registers for c
        mov     eax,dword[esp+32+4]          	; get ordinal
        mov     ecx,dword[reg_wa]              	; restore registers
        mov     ebx,dword[reg_wb]
        mov     edx,dword[reg_wc]              	; (also _reg_ia)
        mov     edi,dword[reg_xr]
        mov     esi,dword[reg_xl]
        mov     ebp,dword[reg_cp]

	atline	-100
        mov     dword [osisp],esp               ; save osint stack pointer
	atline	-101
        cmp     dword [compsp],0      ; is there a compiler stack?
        je      min1              ; jump if none yet
        mov     esp,dword [compsp]              ; switch to compiler stack
	atline	-102

	extern	calltab
min1:   callc   [calltab+eax*4],0        ; off to the minimal code
	atline	-201
        mov     esp,osisp               ; switch to osint stack
	atline	-202

        mov     [reg_wa],ecx              ; save registers
        mov     [reg_wb],ebx
        mov     [reg_wc],edx
        mov     [reg_xr],edi
        mov     [reg_xl],esi
        mov     [reg_cp],ebp
	atline	-203
        popad
        retc    4

;
;       save and restore minimal and interface registers on stack.
;       used by any routine that needs to call back into the minimal
;       code in such a way that the minimal code might trigger another
;       sysxx call before returning.
;
;       note 1:  pushregs returns a collectable value in xl, safe
;       for subsequent call to memory allocation routine.
;
;       note 2:  these are not recursive routines.  only reg_xl is
;       saved on the stack, where it is accessible to the garbage
;       collector.  other registers are just moved to a temp area.
;
;       note 3:  popregs does not restore reg_cp, because it may have
;       been modified by the minimal routine called between pushregs
;       and popregs as a result of a garbage collection.  calling of
;       another sysxx routine in between is not a problem, because
;       cp will have been preserved by minimal.
;
;       note 4:  if there isn't a compiler stack yet, we don't bother
;       saving xl.  this only happens in call of nextef from sysxi when
;       reloading a save file.
;
;
                                                ;bashes eax,ecx,esi
pushregs:
        pushad
        lea     esi,[reg_block]
        lea     edi,[sav_block]
        mov     ecx,r_size/4
        cld
   rep  movsd

        mov     edi,dword [compsp]
        or      edi,edi                         ; is there a compiler stack
        je      push1                     	; jump if none yet
        sub     edi,4                           ;push onto compiler's stack
        mov     esi,dword [reg_xl]              ;collectable XL
        mov     dword [edi],esi
        mov     dword [compsp],edi              ;smashed if call OSINT again (SYSGC)
        mov     dword [sav_compsp],edi          ;used by popregs

push1:  popad
        retc    0

popregs:
        pushad
        mov     eax,dword [reg_cp]              ;don't restore CP
        cld
        lea     esi,[sav_block]
        lea     edi,[reg_block]                 ;unload saved registers
        mov     ecx,r_size/4
   rep  movsd                                   ;restore from temp area
        mov     dword [reg_cp],eax

        mov     edi,dword [sav_compsp]          ;saved compiler's stack
        or      edi,edi                         ;is there one?
        je      pop1                      	;jump if none yet
        mov     esi,dword [edi]                 ;retrieve collectable XL
        mov     dword [reg_xl],esi              ;update XL
        add     edi,4                           ;update compiler's sp
        mov     dword [compsp],edi

pop1:   popad
        retc    0

;

;
;-----------
;
;       startup( char *dummy1, char *dummy2) - startup compiler
;
;       an osint c function calls startup to transfer control
;       to the compiler.
;
;       (xr) = basemem
;       (xl) = topmem - sizeof(word)
;
;       Note: This function never returns.

        
        global  startup
startup:
	atline	-1
        pop     eax                     ; discard return
        pop     eax                     ; discard dummy1
        pop     eax                     ; discard dummy2
	atline	-2
        call    stackinit               ; initialize MINIMAL stack
	atline	-3
        mov     eax,dword [compsp]              ; get MINIMAL's stack pointer
        mov     dword [reg_wa],eax                     ; startup stack pointer

	atline	-4
        cld                             ; default to UP direction for string ops
        extern  DFFNC
	atline	-5
        lea     eax,[DFFNC]               ; get dd of PPM offset
 	atline	-6
        mov     dword [ppoff],eax               ; save for use later
 	atline	-61
        mov     esp,dword [osisp]               ; switch to new c stack
;	atline	-7
	push	start_callid
	atline	-9
; DS start doesn't return, crash happens there
	callc	minimal_call,4 			 ; load regs, switch stack, start compiler


;
;-----------
;
;       stackinit  -- initialize lowspmin from sp.
;
;       Input:  sp - current C stack
;               stacksiz - size of desired Minimal stack in bytes
;
;       Uses:   eax
;
;       Output: register WA, sp, lowspmin, compsp, osisp set up per diagram:
;
;       (high)  +----------------+
;               |  old C stack   |
;               |----------------| <-- incoming sp, resultant WA (future XS)
;               |            ^   |
;               |            |   |
;               / stacksiz bytes /
;               |            |   |
;               |            |   |
;               |----------- | --| <-- resultant lowspmin
;               | 400 bytes  v   |
;               |----------------| <-- future C stack pointer, osisp
;               |  new C stack   |
;       (low)   |                |
;

        global  stackinit
stackinit:
	atline	-10
        mov     eax,esp
        mov     dword [compsp],eax              ; save as MINIMAL's stack pointer
        sub     eax,dword [stacksiz]     ; end of MINIMAL stack is where C stack will start
	atline	-11
        mov     dword [osisp],eax       ; save new C stack pointer
        add     eax,4*100               ; 100 words smaller for CHK
        extern  LOWSPMIN
        mov	dword [LOWSPMIN],eax           ; Set lowspmin
	atline	-99
	ret
;


;;%if direct = 0
;
;-----------
;
;       minoff -- obtain dd of minimal variable
;
;       usage:  extern word *minoff(word valno)
;
;       where:
;         valno is an ordinal defined in osint.h, osint.inc and valtab.
;
	extern	valtab
        global  minoff
minoff:

        mov     eax,dword [esp+4]             ; get ordinal
        mov     eax,dword [valtab+eax*4]       ; get dd of Minimal value
        retc    4

;;%endif


;
;-----------
;
;       get_fp  - get c caller's fp (frame pointer)
;
;       get_fp() returns the frame pointer for the c function that called
;       this function.  however, this function is only called by zysxi.
;
;       c function zysxi calls this function to determine the lowest useful
;       word on the stack, so that only the useful part of the stack will be
;       saved in the load module.
;
;       the flow goes like this:
;
;       (1) user's spitbol program calls exit function
;
;       (2) spitbol compiler calls interface routine sysxi to handle exit
;
;       (3) interface routine sysxi passes control to ccaller which then
;           calls c function zysxi
;
;       (4) c function zysxi will write a load module, but needs to save
;           a copy of the current stack in the load module.  the base of
;           the part of the stack to be saved begins with the frame of our
;           caller, so that the load module can execute a return to ccaller.
;
;           this will allow the load module to pretend to be returning from
;           c function zysxi.  so, c function zysxi calls this function,
;           get_fp, to determine the base of the useful part of the stack.
;
;           we cheat just a little bit here.  c function zysxi can (and does)
;           have local variables, but we won't save them in the load module.
;           only the portion of the frame established by the 80386 call
;           instruction, from bp up, is saved.  these local variables
;           aren't needed, because the load module will not be going back
;           to c function zysxi.  instead when function restart returns, it
;           will act as if c function zysxi is returning.
;
;       (5) after writing the load module, c function zysxi calls c function
;           zysej to terminate spitbol's execution.
;
;       (6) when the resulting load module is executed, c function main
;           calls function restart.  function restart restores the stack
;           and then does a return.  this return will act as if it is
;           c function zysxi doing the return and the user's program will
;           continue execution following its call to exit.
;
;       on entry to _get_fp, the stack looks like
;
;               /      ...      /
;       (high)  |               |
;               |---------------|
;       zysxi   |    old pc     |  --> return point in ccaller
;         +     |---------------|  useful part of stack
;       frame   |    old bp     |  <<<<-- bp of get_fp's caller
;               |---------------|     -
;               |     zysxi's   |     -
;               /     locals    /     - non-useful part of stack
;               |               |     ------
;       ======= |---------------|
;       sp-->   |    old pc     |  --> return pc in c function zysxi
;       (low)   +---------------+
;
;       on exit, return ebp in eax. this is the lower limit on the
;       size of the stack.


        global  get_fp
get_fp:

        mov     eax,dword [reg_xs]      ; Minimal's XS
        add     eax,4           ; pop return from call to SYSBX or SYSXI
        retc    0               ; done


;
;-----------
;
;       restart - restart for load module
;
;       restart( char *dummy, char *stackbase ) - startup compiler
;
;       the osint main function calls restart when resuming execution
;       of a program from a load module.  the osint main function has
;       reset global variables except for the stack and any associated
;       variables.
;
;       before restoring stack, set up values for proper checking of
;       stack overflow. (initial sp here will most likely differ
;       from initial sp when compile was done.)
;
;       it is also necessary to relocate any ddes in the the stack
;       that point within the stack itself.  an adjustment factor is
;       calculated as the difference between the stbas at exit() time,
;       and stbas at restart() time.  as the stack is transferred from
;       tscblk to the active stack, each word is inspected to see if it
;       points within the old stack boundaries.  if so, the adjustment
;       factor is subtracted from it.
;
;       we use minimal's insta routine to initialize static variables
;       not saved in the save file.  these values were not saved so as
;       to minimize the size of the save file.
;
%ifdef LOAD_MODULE
        extern  rereloc

       global   restart
restart:
        global  restart

        pop     eax                     ; discard return
        pop     eax                     ; discard dummy
        pop     eax                     ; get lowest legal stack value

        add     eax,stacksiz            ; top of compiler's stack
        mov     esp,eax                 ; switch to this stack
        call    stackinit               ; initialize MINIMAL stack

                                        ; set up for stack relocation
        lea     eax,[tscblk+scstr]        ; top of saved stack
        mov     ebx,[lmodstk]             ; bottom of saved stack
	extern	stbas
        mov     ecx,dword [stbas]               ; ecx = stbas from exit() time
        sub     ebx,eax                 ; ebx = size of saved stack
        mov     edx,ecx
        sub     edx,ebx                 ; edx = stack bottom from exit() time
        mov     ebx,ecx
        sub     ebx,esp                 ; ebx = old stbas - new stbas
	extern	stbas
        mov     dword [stbas],esp               ; save initial sp
        lea     eax,[dffnc]               ; get dd of ppm offset
        mov     dword [ppoff],eax               ; save for use later
;
;       restore stack from tscblk.
;
        mov     esi,dword [lmodstk]             ; -> bottom word of stack in tscblk
        lea     edi,[tscblk+scstr]        ; -> top word of stack
        cmp     esi,edi                 ; any stack to transfer?
        je      re3               ;  skip if not
        sub     esi,4
        std
re1:    lodsd                           ; get old stack word to eax
        cmp     eax,edx                 ; below old stack bottom?
        jb      re2               ;   j. if eax < edx
        cmp     eax,ecx                 ; above old stack top?
        ja      re2               ;   j. if eax > ecx
        sub     eax,ebx                 ; within old stack, perform relocation
re2:    push    eax                     ; transfer word of stack
        cmp     esi,edi                 ; if not at end of relocation then
        jae     re1                     ;    loop back

re3:    cld
        mov     dword [compsp],esp              ; save compiler's stack pointer
        mov     esp,dword [osisp]               ; back to OSINT's stack pointer
        callc   rereloc,0               ; V1.08 relocate compiler pointers into stack
	extern	statb
        mov     dword [eax],statb               ; V1.34 start of static region to XR
        mov     dword [reg_xr],  eax
	push	insta_callid
        callc	minimal_call,4               ; V1.34 initialize static region

;
;       now pretend that we're executing the following c statement from
;       function zysxi:
;
;               return  normal_return;
;
;       if the load module was invoked by exit(), the return path is
;       as follows:  back to ccaller, back to s$ext following sysxi call,
;       back to user program following exit() call.
;
;       alternately, the user specified -w as a command line option, and
;       sysbx called makeexec, which in turn called sysxi.  the return path
;       should be:  back to ccaller, back to makeexec following sysxi call,
;       back to sysbx, back to minimal code.  if we allowed this to happen,
;       then it would require that stacked return dd to sysbx still be
;       valid, which may not be true if some of the c programs have changed
;       size.  instead, we clear the stack and execute the restart code that
;       simulates resumption just past the sysbx call in the minimal code.
;       we distinguish this case by noting the variable stage is 4.
;
        extern  startbrk
        callc   startbrk,0              ; start control-C logic
	extern	stage
        mov     dword [eax],stage               ; is this a -w call?
        cmp     eax,4
        je      re4               ; yes, do a complete fudge

;
;       Jump back to cc1 with return value = NORMAL_RETURN
        mov     eax,-1
	extern	cc1
        jmp     cc1                     ; jump back

;       here if -w produced load module.  simulate all the code that
;       would occur if we naively returned to sysbx.  clear the stack and
;       go for it.
;
re4:	
	mov	dword [eax],stbas
        mov     dword [compsp],eax              ; empty the stack

;       code that would be executed if we had returned to makeexec:
;
	extern	gbcnt
        mov     dword [gbcnt],0                 ; reset garbage collect count
	extern	zystm
        callc   zystm,0                 ; fetch execution time to reg_ia
        mov     eax,dword [reg_ia]              ; set time into compiler0
	extern	timsx
	mov	dword [timsx],eax

;       code that would be executed if we returned to sysbx:
;
        push    outptr                  ; swcoup(outptr)
        callc   swcoup,4

;       jump to minimal code to restart a save file.

	push	rstrt_callid
	callc	minimal_call,4			; no return

%endif

