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
;
;        .psize          80,132
;        .arch           pentium

%define	globals	1

	%include	"systype.ah"
	%include	"osint.inc"



	segment	.data
;
;       file: inter.s           version: 1.46
;       ---------------------------------------
;
;       this file contains the assembly language routines that interface
;       the macro spitbol compiler written in 80386 assembly language to its
;       operating system interface functions written in c.
;
;       contents:
;
;       o overview
;       o global variables accessed by osint functions
;       o interface routines between compiler and osint functions
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
	extern	swcoup

	extern	stacksiz
	extern	lmodstk
	extern	lowsp
	extern	outptr
	extern	calltab
%if direct == 0
        extern     valtab
%endif

        %include "extrn386.inc"


; words saved during exit(-3)
;
        align 4

	global	reg_wa
	global	reg_wb
	global	reg_ia
	global	reg_wc
	global	reg_xr
	global	reg_xl
	global	reg_cp
	global	reg_ra
	global	reg_pc
	global	reg_pp
	global	reg_xs

	global	reg_block
	global	reg_size
reg_block:
reg_wa:	dd	0     ; register wa (ecx)
reg_wb:	dd	0     ; register wb (ebx)
reg_ia:
reg_wc:	dd   0     ; register wc & ia (edx)
reg_xr:	dd   0     ; register xr (edi)
reg_xl:	dd   0     ; register xl (esi)
reg_cp:	dd   0     ; register cp
reg_ra:	dd	0e  ; register ra
;
; these locations save information needed to return after calling osint
; and after a restart from exit()
;
reg_pc:	dd	0		; return pc from caller
reg_pp: dd      0               ; number of bytes of ppms
reg_xs:	dd   	0  		; minimal stack pointer
;
r_size equ      $-reg_block
reg_size	dd	r_size
;
; end of words saved during exit(-3)
;

;
;  constants
;
ten:    dd      10              ; constant 10
	global	inf
inf:	dd	0	
        dd      0x7ff00000      ; double precision infinity

sav_block: times r_size dd 0    ; save minimal registers during push/pop reg
;
        align 4
ppoff:  dd      0               ; offset for ppm exits
compsp: dd      0               ; 1.39 compiler's stack pointer
sav_compsp:
        dd      0               ; save compsp here
osisp:  dd      0               ; 1.39 osint's stack pointer


;
;       setup a number of internal ddes in the compiler that cannot
;       be directly accessed from within c because of naming difficulties.
;
	global	id1
id1	dd	0
%ifdef setreal
        dd       2
        db  "1x\x00\x00"
%else
        dd       1
        db  "1x\x00\x00\x00"
%endif
;
	global	id2blk
id2blk:	times	52 dd 0
	global	tscblk

	global	ticblk
ticblk:	dd	0
        dd      0

	global	tscblk
tscblk:	times	512 dd 0

;       standard input buffer block.
;
	global	inpbuf
inpbuf:	dd   	0     ; type word
        dd      0               ; block length
        dd      1024            ; buffer size
        dd      0               ; remaining chars to read
        dd      0               ; offset to next character to read
        dd      0               ; file position of buffer
        dd      0               ; physical position in file
%if winnt
        dd      0               ; 64-bit offset
        dd      0               ; and current position
%endif
	times	1024 dd 0	; buffer
;
	global	ttybuf
ttybuf:	dd   0     ; type word
        dd      0               ; block length
        dd      260             ; buffer size  (260 ok in ms-dos with cinread())
        dd      0               ; remaining chars to read
        dd      0               ; offset to next char to read
        dd      0               ; file position of buffer
        dd      0               ; physical position in file
%if winnt 
        dd      0               ; 64-bit offset
        dd      0               ; and current position
%endif
	times	260 dd 0	; buffer


	segment	.text
;
;-----------
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
	lea	edi,[sav_block]
	mov	ecx,r_size/4
	cld
   rep	movsd

        mov     edi,compsp
        or      edi,edi                         ; 1.39 is there a compiler stack
        je      push1                     ; 1.39 jump if none yet
        sub     edi,4                           ;push onto compiler's stack
        mov     esi,reg_xl                      ;collectable xl
	mov	[edi],esi
        mov     [compsp],edi                      ;smashed if call osint again (sysgc)
        mov     [sav_compsp],edi                  ;used by popregs

push1:	popad
	retc	0

popregs:
	pushad
        mov     eax,[reg_cp]                      ;don't restore cp
	cld
	lea	esi,[sav_block]
        lea     edi,[reg_block]                   ;unload saved registers
	mov	ecx,r_size/4
   rep  movsd                                   ;restore from temp area
	mov	[reg_cp],eax

        mov     edi,[sav_compsp]                  ;saved compiler's stack
        or      edi,edi                         ;1.39 is there one?
        je      pop1                      ;1.39 jump if none yet
        mov     esi,[edi]                       ;retrieve collectable xl
        mov     dword [reg_xl],esi                      ;update xl
        add     edi,4                           ;update compiler's sp
        mov     [compsp],edi

pop1:	popad
	retc	0

;
;-----------
;
;       interface routines
;
;       each interface routine takes the following form:
;
;               sysxx   call    ccaller         ; call common interface
;                       dd      zysxx           ; dd of c osint function
;                       db      n               ; offset to instruction after
;                                               ;   last procedure exit
;
;       in an effort to achieve portability of c osint functions, we
;       do not take take advantage of any "internal" to "external"
;       transformation of names by c compilers.  so, a c osint function
;       representing sysxx is named _zysxx.  this renaming should satisfy
;       all c compilers.
;
;       important  one interface routine, sysfc, is passed arguments on
;       the stack.  these items are removed from the stack before calling
;       ccaller, as they are not needed by this implementation.
;
;
;-----------
;
;       ccaller is called by the os interface routines to call the
;       real c os interface function.
;
;       general calling sequence is
;
;               call    ccaller
;               dd      dd_of_c_function
;               db      2*number_of_exit_points
;
;       control is never returned to a interface routine.  instead, control
;       is returned to the compiler (the caller of the interface routine).
;
;       the c function that is called must always return an integer
;       indicating the procedure exit to take or that a normal return
;       is to be performed.
;
;               c function      interpretation
;               return value
;               ------------    -------------------------------------------
;                    <0         do normal return to instruction past
;                               last procedure exit (distance passed
;                               in by dummy routine and saved on stack)
;                     0         take procedure exit 1
;                     4         take procedure exit 2
;                     8         take procedure exit 3
;                    ...        ...
;
ccaller:

;       (1) save registers in global variables
;
        mov     [reg_wa],ecx              ; save registers
	mov	[reg_wb],ebx
        mov     [reg_wc],edx              ; (also _reg_ia)
	mov	[reg_xr],edi
	mov	[reg_xl],esi
        mov     [reg_cp],ebp              ; needed in image saved by sysxi

;       (2) get pointer to arg list
;
        pop     esi                     ; point to arg list
;
;       (3) fetch dd of c function, fetch offset to  instruction
;           past last procedure exit, and call c function.
;
        cs                              ; cs segment override
        lodsd                           ; point to c function entry point
;       lodsd   cs:ccaller              ; point to c function entry point
        movzx   ebx,byte [esi]   ; save normal exit adjustment
;
        mov     dword [reg_pp],ebx              ; in memory
        pop     dword [reg_pc]                  ; save return pc past "call sysxx"
;
;       (3a) save compiler stack and switch to osint stack
;
        mov     dword [compsp],esp              ; 1.39 save compiler's stack pointer
        mov     esp,[osisp]               ; 1.39 load osint's stack pointer
;
;       (3b) make call to osint
;
        call    eax                     ; call c interface function
;
;       (4) restore registers after c function returns.
;

cc1:    mov     [osisp], esp               ; 1.39 save osint's stack pointer
        mov     esp, dword [compsp]              ; 1.39 restore compiler's stack pointer
        mov     ecx, dword [reg_wa]              ; restore registers
	mov	ebx, dword [reg_wb]
        mov     edx, dword [reg_wc]             ; (also reg_ia)
	mov	edi, dword [reg_xr]
	mov	esi, dword [reg_xl]
	mov	ebp, dword [reg_cp]

	cld
;
;       (5) based on returned value from c function (in eax) either do a normal
;           return or take a procedure exit.
;
        or      eax,eax         ; test if normal return ...
        jns     erexit    ; j. if >= 0 (take numbered exit)
	mov	eax,dword [reg_pc]
        add     eax,dword [reg_pp]      ; point to instruction following exits
        jmp     eax             ; bypass ppm exits

;                               ; else (take procedure exit n)
erexit: shr     eax,1           ; divide by 2
        add     eax,dword [reg_pc]      ;   get to dd of exit offset
	movsx	eax,word [eax]
        add     eax,ppoff       ; bias to fit in 16-bit word
	push	eax
        xor     eax,eax         ; in case branch to error cascade
        ret                     ;   take procedure exit via ppm dd

;
;---------------
;
;       individual osint routine entry points
;
	global	sysax
	extern	zysax
sysax:	call	ccaller
        dd   zysax
        db      0
;
	global	sysbs
	extern	zysbs
sysbs:	call	ccaller
        dd   zysbs
        db      3*2
;
        global	 sysbx
	extern	zysbx
sysbx:	mov	[reg_xs],esp
	call	ccaller
        dd zysbx
        db      0
;
%ifdef setreal
        global syscr
	extern	zyscr
syscr:  call    ccaller
        dd zyscr
        db      0
;
%endif
        global sysdc
	extern	zysdc
sysdc:	call	ccaller
        dd zysdc
        db      0
;
        global sysdm
	extern	zysdm
sysdm:	call	ccaller
        dd zysdm
        db      0
;
        global sysdt
	extern	zysdt
sysdt:	call	ccaller
        dd zysdt
        db      0
;
        global sysea
	extern	zysea
sysea:	call	ccaller
        dd zysea
        db      1*2
;
        global sysef
	extern	zysef
sysef:	call	ccaller
        dd zysef
        db      3*2
;
        global sysej
	extern	zysej
sysej:	call	ccaller
        dd zysej
        db      0
;
        global sysem
	extern	zysem
sysem:	call	ccaller
        dd zysem
        db      0
;
        global sysen
	extern	zysen
sysen:	call	ccaller
        dd zysen
        db      3*2
;
        global sysep
	extern	zysep
sysep:	call	ccaller
        dd zysep
        db      0
;
        global sysex
	extern	zysex
sysex:	mov	[reg_xs],esp
	call	ccaller
        dd zysex
        db      3*2
;
        global sysfc
	extern	zysfc
sysfc:  pop     eax             ; <<<<remove stacked scblk>>>>
	lea	esp,[esp+edx*4]
	push	eax
	call	ccaller
        dd zysfc
        db      2*2
;
        global sysgc
	extern	zysgc
sysgc:	call	ccaller
        dd zysgc
        db      0
;
        global syshs
	extern	zyshs
syshs:	mov	[reg_xs],esp
	call	ccaller
        dd zyshs
        db      8*2
;
        global sysid
	extern	zysid
sysid:	call	ccaller
        dd zysid
        db      0
;
        global sysif
	extern	zysif
sysif:	call	ccaller
        dd zysif
        db      1*2
;
        global sysil
	extern	zysil
sysil:  call    ccaller
        dd zysil
        db      0
;
        global sysin
	extern	zysin
sysin:	call	ccaller
        dd zysin
        db      3*2
;
        global sysio
	extern	zysio
sysio:	call	ccaller
        dd zysio
        db      2*2
;
        global sysld
	extern	zysld
sysld:  call    ccaller
        dd zysld
        db      3*2
;
        global sysmm
	extern	zysmm
sysmm:	call	ccaller
        dd zysmm
        db      0
;
        global sysmx
	extern	zysmx
sysmx:	call	ccaller
        dd zysmx
        db      0
;
        global sysou
	extern	zysou
sysou:	call	ccaller
        dd zysou
        db      2*2
;
        global syspi
	extern	zyspi
syspi:	call	ccaller
        dd zyspi
        db      1*2
;
        global syspl
	extern	zyspl
syspl:	call	ccaller
        dd zyspl
        db      3*2
;
        global syspp
	extern	zyspp
syspp:	call	ccaller
        dd zyspp
        db      0
;
        global syspr
	extern	zyspr
syspr:	call	ccaller
        dd zyspr
        db      1*2
;
        global sysrd
	extern	zysrd
sysrd:	call	ccaller
        dd zysrd
        db      1*2
;
        global sysri
	extern	zysri
sysri:	call	ccaller
        dd zysri
        db      1*2
;
        global sysrw
	extern	zysrw
sysrw:	call	ccaller
        dd zysrw
        db      3*2
;
        global sysst
	extern	zysst
sysst:	call	ccaller
        dd zysst
        db      5*2
;
        global systm
	extern	zystm
systm:	call	ccaller
systm_p: dd zystm
        db      0
;
        global systt
	extern	zystt
systt:	call	ccaller
        dd zystt
        db      0
;
        global sysul
	extern	zysul
sysul:	call	ccaller
        dd zysul
        db      0
;
        global sysxi
	extern	zysxi
sysxi:	mov	[reg_xs],esp
	call	ccaller
sysxi_p: dd zysxi
        db      2*2

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
;	note: this function never returns.
;

	
	global	startup
startup:

        pop     eax                     ; discard return
        pop     eax                     ; discard dummy1
        pop     eax                     ; discard dummy2
	call	stackinit               ; initialize minimal stack
        mov     eax,compsp              ; get minimal's stack pointer
        mov	dword [reg_wa],eax                     ; startup stack pointer

	cld                             ; default to up direction for string ops
	extern	dffnc
        getoff  eax,[dffnc]               ; get dd of ppm offset
        mov     dword [ppoff],eax               ; save for use later
;
        mov     esp,dword [osisp]               ; switch to new c stack
        minimal start                   ; load regs, switch stack, start compiler


;
;-----------
;
;	stackinit  -- initialize lowspmin from sp.
;
;	input:  sp - current c stack
;		stacksiz - size of desired minimal stack in bytes
;
;	uses:	eax
;
;	output: register wa, sp, lowspmin, compsp, osisp set up per diagram:
;
;	(high)	+----------------+
;		|  old c stack   |
;	  	|----------------| <-- incoming sp, resultant wa (future xs)
;		|	     ^	 |
;		|	     |	 |
;		/ stacksiz bytes /
;		|	     |	 |
;		|            |	 |
;		|----------- | --| <-- resultant lowspmin
;		| 400 bytes  v   |
;	  	|----------------| <-- future c stack pointer, osisp
;		|  new c stack	 |
;	(low)	|                |
;
;
;

	global	stackinit
stackinit:
	mov	eax,esp
        mov     dword [compsp],eax              ; save as minimal's stack pointer
	sub	eax,dword [stacksiz]     ; end of minimal stack is where c stack will start
        mov     dword [osisp],eax       ; save new c stack pointer
	add	eax,4*100               ; 100 words smaller for chk
	extern	lowspmin
        setminr  [lowspmin],eax           ; set lowspmin
	ret

;
;-----------
;
;       mimimal -- call minimal function from c
;
;       usage:  extern void minimal(word callno)
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
;

	global	minimal
minimal:

        pushad                          ; save all registers for c
        mov     eax,dword[esp+32+4]          ; get ordinal
        mov     ecx,dword[reg_wa]              ; restore registers
	mov	ebx,dword[reg_wb]
        mov     edx,dword[reg_wc]              ; (also _reg_ia)
	mov	edi,dword[reg_xr]
	mov	esi,dword[reg_xl]
	mov	ebp,dword[reg_cp]

        mov     dword [osisp],esp               ; 1.39 save osint stack pointer
        cmp     dword [compsp],0      ; 1.39 is there a compiler stack?
        je      min1              ; 1.39 jump if none yet
        mov     esp,compsp              ; 1.39 switch to compiler stack

min1:   callc   [calltab+eax*4],0        ; off to the minimal code

        mov     esp,osisp               ; 1.39 switch to osint stack

        mov     [reg_wa],ecx              ; save registers
	mov	[reg_wb],ebx
	mov	[reg_wc],edx
	mov	[reg_xr],edi
	mov	[reg_xl],esi
	mov	[reg_cp],ebp
	popad
	retc	4



%if direct = 0
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

	global 	minoff
minoff:

        mov     eax,[esp+4]             ; get ordinal
        mov     eax,[valtab+eax*4]       ; get dd of minimal value
	retc	4

%endif


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


	global	get_fp
get_fp:

        mov     eax,[reg_xs]      ; minimal's xs
        add     eax,4           ; pop return from call to sysbx or sysxi
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
	extern	rereloc

       global   restart
restart:
	global	restart

        pop     eax                     ; discard return
        pop     eax                     ; discard dummy
        pop     eax                     ; get lowest legal stack value

        add     eax,stacksiz            ; top of compiler's stack
        mov     esp,eax                 ; switch to this stack
	call	stackinit               ; initialize minimal stack

                                        ; set up for stack relocation
        lea     eax,[tscblk+scstr]        ; top of saved stack
        mov     ebx,dword [lmodstk]             ; bottom of saved stack
;;        getmin  ecx,[stbas]               ; ecx = stbas from exit() time
;ds todo review above line. commented out to get os x port going
        sub     ebx,eax                 ; ebx = size of saved stack
	mov	edx,ecx
        sub     edx,ebx                 ; edx = stack bottom from exit() time
	mov	ebx,ecx
        sub     ebx,esp                 ; ebx = old stbas - new stbas
	extern	stbas
        setminr  dword [stbas],esp               ; save initial sp
        getoff  eax,[dffnc]               ; get dd of ppm offset
        mov     dword [ppoff],eax               ; save for use later
;
;       restore stack from tscblk.
;
        mov     esi,dword [lmodstk]             ; -> bottom word of stack in tscblk
        lea     edi,[tscblk+scstr]        ; -> top word of stack
        cmp     esi,edi                 ; any stack to transfer?
        je      re3               ;  skip if not
	sub	esi,4
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

re3:	cld
        mov     dword [compsp],esp              ; 1.39 save compiler's stack pointer
        mov     esp,dword [osisp]               ; 1.39 back to osint's stack pointer
        callc   rereloc,0               ; v1.08 relocate compiler pointers into stack
;ds todo review above line. commented out to get os x port going
;        getmin  eax,[statb]               ; v1.34 start of static region to xr
	mov	dword [reg_xr],  eax
        minimal insta                   ; v1.34 initialize static region

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
	extern	startbrk
        callc   startbrk,0              ; start control-c logic
;ds todo review above line. commented out to get os x port going
;        getmin  eax,stage               ; is this a -w call?
	cmp	eax,4
        je      re4               ; yes, do a complete fudge

;
;       jump back to cc1 with return value = normal_return
	mov	eax,-1
        jmp     cc1                     ; jump back

;       here if -w produced load module.  simulate all the code that
;       would occur if we naively returned to sysbx.  clear the stack and
;       go for it.
;
re4:	
;	getmin	eax,[stbas]
;ds todo review commented-out line. commented out to get os x port going
        mov     dword [compsp],eax              ; 1.39 empty the stack

;       code that would be executed if we had returned to makeexec:
;
;ds todo review commented-out line. commented out to get os x port going
;        setmin  dword [gbcnt],0                 ; reset garbage collect count
        callc   zystm,0                 ; fetch execution time to reg_ia
        mov     eax,dword [reg_ia]              ; set time into compiler0
	extern	timsx
	setminr	dword [timsx],eax

;       code that would be executed if we returned to sysbx:
;
        push    outptr                  ; swcoup(outptr)
	callc	swcoup,4

;       jump to minimal code to restart a save file.

        minimal rstrt                   ; no return

;
;-----------
;
;       cvd_ - convert by division
;
;       input   ia (edx) = number <=0 to convert
;       output  ia / 10
;               wa (ecx) = remainder + '0'
;
	global	cvd_
cvd_:
        xchg    eax,edx         ; ia to eax
        cdq                     ; sign extend
        idiv    dword [ten]   ; divide by 10. edx = remainder (negative)
        neg     edx             ; make remainder positive
        add     dl,0x30         ; convert remainder to ascii ('0')
        mov     ecx,edx         ; return remainder in wa
        xchg    edx,eax         ; return quotient in ia
	ret

;
;-----------
;
;       dvi_ - divide ia (edx) by long in eax
;
	global	dvi_
dvi_:

        or      eax,eax         ; test for 0
        jz      setovr    ; jump if 0 divisor
        push    ebp             ; preserve cp
        xchg    ebp,eax         ; divisor to ebp
        xchg    eax,edx         ; dividend in eax
        cdq                     ; extend dividend
        idiv    ebp             ; perform division. eax=quotient, edx=remainder
        xchg    edx,eax         ; place quotient in edx (ia)
        pop     ebp             ; restore cp
        xor     eax,eax         ; clear overflow indicator
	ret


;
;-----------
;
;       rmi_ - remainder of ia (edx) divided by long in eax
;
	global	rmi_
rmi_:
             or      eax,eax         ; test for 0
        jz      setovr    ; jump if 0 divisor
        push    ebp             ; preserve cp
        xchg    ebp,eax         ; divisor to ebp
        xchg    eax,edx         ; dividend in eax
        cdq                     ; extend dividend
        idiv    ebp             ; perform division. eax=quotient, edx=remainder
        pop     ebp             ; restore cp
        xor     eax,eax         ; clear overflow indicator
        ret                     ; return remainder in edx (ia)
setovr: mov     al,0x80         ; set overflow indicator
	dec	al
	ret



;----------
;
;    calls to c
;
;       the calling convention of the various compilers:
;
;       integer results returned in eax.
;       float results returned in st0 for intel.
;       see conditional switches fretst0 and
;       freteax in systype.ah for each compiler.
;
;       c function preserves ebp, ebx, esi, edi.
;


;----------
;
;       rti_ - convert real in ra to integer in ia
;               returns c=0 if fit ok, c=1 if too large to convert
;
	global	rti_
rti_:

; 41e00000 00000000 = 2147483648.0
; 41e00000 00200000 = 2147483649.0
        mov     eax, dword [reg_ra+4]   ; ra msh
        btr     eax,31          ; take absolute value, sign bit to carry flag
        jc      rti_2     ; jump if negative real
        cmp     eax,0x41e00000  ; test against 2147483648
        jae     rti_1     ; jump if >= +2147483648
rti_3:  push    ecx             ; protect against c routine usage.
        push    eax             ; push ra msh
        push    dword [reg_ra]; push ra lsh
        callfar f_2_i,8         ; float to integer
        xchg    eax,edx         ; return integer in edx (ia)
        pop     ecx             ; restore ecx
        clc
	ret

; here to test negative number, made positive by the btr instruction
rti_2:  cmp     eax,0x41e00000          ; test against 2147483649
        jb      rti_0             ; definately smaller
        ja      rti_1             ; definately larger
        cmp     dword [reg_ra+2], 0x0020
        jae     rti_1
rti_0:  btc     eax,31                  ; make negative again
        jmp     rti_3
rti_1:  stc                             ; return c=1 for too large to convert
        ret

;
;----------
;
;       itr_ - convert integer in ia to real in ra
;
	global	itr_
itr_:

        push    ecx             ; preserve
        push    edx             ; push ia
        callfar i_2_f,4         ; integer to float
%if fretst0
	fstp	dword [reg_ra]
        pop     ecx             ; restore ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra],eax    ; return result in ra

	mov	dword [reg_ra+4],edx
        pop     ecx             ; restore ecx
%endif
	ret

;
;----------
;
;       ldr_ - load real pointed to by eax to ra
;
	global	ldr_
ldr_:
        push    dword [eax]                 ; lsh
	pop	dword [reg_ra]
        mov     eax,[eax+4]                     ; msh
	mov	dword [reg_ra+4], eax
	ret

;
;----------
;
;       str_ - store ra in real pointed to by eax
;
	global	str_
str_:

        push    dword [reg_ra]                ; lsh
	pop	dword [eax]
        push    dword [reg_ra+4]              ; msh
	pop	dword [eax+4]
	ret

;
;----------
;
;       adr_ - add real at [eax] to ra
;
	global	adr_
adr_:

        push    ecx                             ; preserve regs for c
	push	edx
        push    dword [reg_ra+4]              ; ra msh
        push    dword [reg_ra]                ; ra lsh
        push    dword [eax+4]               ; arg msh
        push    dword [eax]                 ; arg lsh
        callfar f_add,16                        ; perform op
%if fretst0
	fstp	qword [reg_ra]
        pop     edx                             ; restore regs
	pop	ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret

;
;----------
;
;       sbr_ - subtract real at [eax] from ra
;
        global  sbr_
sbr_:

        push    ecx                             ; preserve regs for c
	push	edx
        push    dword [reg_ra+4]              ; ra msh
        push    dword [reg_ra]                ; ra lsh
        push    dword [eax+4]               ; arg msh
        push    dword [eax]                 ; arg lsh
        callfar f_sub,16                        ; perform op
%if fretst0
	fstp	qword [reg_ra]
        pop     edx                             ; restore regs
	pop	ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra+4, edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret

;
;----------
;
;       mlr_ - multiply real in ra by real at [eax]
;
        global  mlr_
mlr_:

        push    ecx                             ; preserve regs for c
	push	edx
        push    dword [reg_ra+4]              ; ra msh
        push    dword [reg_ra]                ; ra lsh
        push    dword [eax+4]               ; arg msh
        push    dword [eax]                 ; arg lsh
        callfar f_mul,16                        ; perform op
%if fretst0
	fstp	qword [reg_ra]
        pop     edx                             ; restore regs
	pop	ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra+4,] edx         ; result msh
        mov     dword [reg_ra,] eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret

;
;----------
;
;       dvr_ - divide real in ra by real at [eax]
;
        global  dvr_

dvr_:

        push    ecx                             ; preserve regs for c
	push	edx
        push    dword [reg_ra+4]              ; ra msh
        push    dword [reg_ra]                ; ra lsh
        push    dword [eax+4]               ; arg msh
        push    dword [eax]                 ; arg lsh
        callfar f_div,16                        ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     edx                             ; restore regs
	pop	ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret

;
;----------
;
;       ngr_ - negate real in ra
;
        global  ngr_
ngr_:
	cmp	dword [reg_ra], 0
	jne	ngr_1
	cmp	dword [reg_ra+4], 0
        je      ngr_2                     ; if zero, leave alone
ngr_1:  xor     byte [reg_ra+7], 0x80         ; complement mantissa sign
ngr_2:	ret

;
;----------
;
;       atn_ arctangent of real in ra
;
        global  atn_

atn_:

        push    ecx                             ; preserve regs for c
	push	edx
        push    dword [reg_ra+4]              ; ra msh
        push    dword [reg_ra]                ; ra lsh
        callfar f_atn,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     edx                             ; restore regs
	pop	ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret

;
;----------
;
;       chp_ chop fractional part of real in ra
;
        global  chp_

chp_:

        push    ecx                             ; preserve regs for c
	push	edx
        push    dword [reg_ra+4]              ; ra msh
        push    dword [reg_ra]                ; ra lsh
        callfar f_chp,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     edx                             ; restore regs
	pop	ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret

;
;----------
;
;       cos_ cosine of real in ra
;
        global  cos_

cos_:
        push    ecx                             ; preserve regs for c
	push	edx
        push    dword [reg_ra+4]              ; ra msh
        push    dword [reg_ra]                ; ra lsh
        callfar f_cos,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     edx                             ; restore regs
	pop	ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret

;
;----------
;
;       etx_ exponential of real in ra
;
        global  etx_

etx_:
        push    ecx                             ; preserve regs for c
	push	edx
        push    dword [reg_ra+4]              ; ra msh
        push    dword [reg_ra]                ; ra lsh
        callfar f_etx,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     edx                             ; restore regs
	pop	ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret

;
;----------
;
;       lnf_ natural logarithm of real in ra
;
        global  lnf_

lnf_:

        push    ecx                             ; preserve regs for c
	push	edx
        push    dword [reg_ra+4]              ; ra msh
        push    dword [reg_ra]                ; ra lsh
        callfar f_lnf,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     edx                             ; restore regs
	pop	ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret

;
;----------
;
;       sin_ arctangent of real in ra
;
        global  sin_

sin_:

        push    ecx                             ; preserve regs for c
	push	edx
        push    dword [reg_ra+4]              ; ra msh
        push    dword [reg_ra]                ; ra lsh
        callfar f_sin,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     edx                             ; restore regs
	pop	ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret

;
;----------
;
;       sqr_ arctangent of real in ra
;
        global  sqr_


sqr_:
        push    ecx                             ; preserve regs for c
	push	edx
        push    dword [reg_ra+4]              ; ra msh
        push    dword [reg_ra]                ; ra lsh
        callfar f_sqr,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     edx                             ; restore regs
	pop	ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret

;
;----------
;
;       tan_ arctangent of real in ra
;
        global  tan_

tan_:
        push    ecx                             ; preserve regs for c
	push	edx
        push    dword [reg_ra+4]              ; ra msh
        push    dword [reg_ra]                ; ra lsh
        callfar f_tan,8                         ; perform op
%if fretst0
        fstp	qword [reg_ra]
        pop     edx                             ; restore regs
	pop	ecx
	fwait
%endif
%if freteax
        mov     dword [reg_ra+4], edx         ; result msh
        mov     dword [reg_ra], eax           ; result lsh
        pop     edx                             ; restore regs
	pop	ecx
%endif
	ret

;
;----------
;
;       cpr_ compare real in ra to 0
;
        global  cpr_

cpr_:

        mov     eax, dword [reg_ra+4] ; fetch msh
        cmp     eax, 0x80000000         ; test msh for -0.0
        je      cpr050            ; possibly
        or      eax, eax                ; test msh for +0.0
        jnz     cpr100            ; exit if non-zero for cc's set
cpr050: cmp     dword [reg_ra], 0     ; true zero, or denormalized number?
        jz      cpr100            ; exit if true zero
	mov	al, 1
        cmp     al, 0                   ; positive denormal, set cc
cpr100:	ret

;
;----------
;
;       ovr_ test for overflow value in ra
;
        global  ovr_

ovr_: 

        mov     ax, word [reg_ra+6]   ; get top 2 bytes
        and     ax, 0x7ff0              ; check for infinity or nan
        add     ax, 0x10                ; set/clear overflow accordingly
	ret


%if winnt
;
;----------
;
;       cinread(fdn, buffer, size)      do buffered console input
;
;       input:  fdn     = file descriptor in case can't use dos function 0a
;               buffer  = buffer
;               size    = buffer size
;       output: eax    = number of bytes transferred if no error
;               = -1 if error
;
;       preserves ds, es, esi, edi, ebx
;
;       uses dos function 0a because that is the function intercepted by
;       various keyboard editing programs, such as dos edit.
;
;       if a program has redirected standard output, function 0a's echos
;       will go to the redirected file, instead of the screen.  to overcome
;       this, we save standard out's handle, and force it to be the console
;       (stderr).  similarly, function 0ah reads from handle 0, and we
;       force it to the console to preclude reading from a file.
;
;       if insufficient handles remain in the system to do this little
;       shuffle, we simple fall back to the normal dos read routine.
;

        struc   cinarg
cin_ebp: resd     1
cin_ip:  resd     1
cin_fdn: resd     1
cin_buf: resd     1
cin_siz: resd     1
        endstruc

        struc   ct                      ;cinread temps
crbuf:  times   260 resd 0                ;keyboard buffer
	endstruc
zct    equ      260/4                   ;word aligned temp size
ctemp  equ      [ebp-zct]               ;temp on stack

	extern	read
%if winnt
        proc    cinreaddos
	global  cinreaddos
%else
        proc    cinread
	global	cinread
%endif
        enter   zct,0                   ;enter and reserve space for ctemp
	push	ebx
	push	esi
	push	edi

        xor     ebx,ebx                 ; save stdin by duplicating to
        mov     ecx,ebx                 ;  get another handle
	xor	eax,eax
        mov     ah,0x45                 ; cx = stdin
        int     0x21
        jc      cinr5                   ; out of handles
        push    eax                     ; save handle to old stdin
        mov     ebx,2                   ; make stdin refer to stderr
        mov     ah,0x46                 ; so dos's input comes from keyboard
        int     0x21

        mov     ebx,1                   ; save stdout by duplicating to
        mov     ecx,ebx                 ;  get another handle
        mov     ah,0x45                 ; cx = stdout
        int     0x21
        jc      cinr4             ; out of handles
	push	ecx
        push    eax                     ; save handle to old stdout
        mov     ebx,2                   ; make stdout refer to stderr
        mov     ah,0x46                 ; so dos' echo goes to screen
        int     0x21

	mov	ecx,[ebp].cin_siz
        inc     ecx                     ; allow for cr
	cmp	ecx,255
	jle	cinr1
        mov     cl,255                  ; 255 is the max size for function 0ah
cinr1:  lea     edx,ctemp.crbuf         ; buffer (ds=ss)
        mov     [edx],cl                ; set up count

        mov     ah,0x0a
        int     0x21                    ; do buffered input into [edx+2]

	pop	ebx
        pop     ecx                     ; (cx = stdout)
        mov     ah,0x46                 ; restore stdout to original file
        int     0x21
        mov     ah,0x3e                 ; discard dup'ed handle
        int     0x21

        xor     ecx,ecx                 ; cx = stdin
	pop	ebx
        mov     ah,0x46                 ; restore stdin to original file
        int     0x21
        mov     ah,0x3e                 ; discard dup'ed handle
        int     0x21

	mov	esi,edx
        inc     esi                     ; point to number of bytes read
        movzx   ebx,byte [esi]      ; char count
        inc     ebx                     ; include cr
        inc     esi                     ; point to first char
        lea     edx,[esi+ebx]           ; point past cr
        mov     [edx],byte 10       ; append lf after cr
        inc     ebx                     ; include lf
        cmp     ebx,[cin_siz+ebp]        ; compare with caller's buffer size
	jle	cinr3
        mov     ebx,[cin_siz+ebp]        ; caller's buffer size limits us
cinr3:	mov	ecx,ebx
        mov     edi,[cin_buf+ebp]        ; caller's buffer
  rep	movsb

        push    ebx                     ; save count
        mov     ebx,2                   ; force lf echo to screen
        mov     ah,0x40                 ; edx points to lf
	mov	ecx,1
        int     0x21
	pop	eax

cinr2:	pop	edi
	pop	esi
	pop	ebx
	leave
	retc	12

; here if insufficient handles to save standard out.
; release standard in.
;
cinr4:  xor     ecx,ecx                 ; cx = stdin
	pop	ebx
        mov     ah,0x46                 ; restore stdin to original file
        int     0x21
        mov     ah,0x3e                 ; discard dup'ed handle
        int     0x21

; here if insufficient handles to save standard in.
; just fall back to read routine.
;
cinr5:	push	[cin_siz+ebp]
	push	[cin_buf+ebp]
	push	[cin_fdn+ebp]
	callc	read,12
	jmp	cinr2

%endif



%if winnt
;
;----------
;
;       chrdevdos(fdn)  do ioctl to see if character device.
;
;       input:  fdn     = file descriptor
;       output: eax     = 81h/82h if input/output char dev, else 0
;
;       preserves ds, es, esi, edi, ebx
;

                struc   chrdevarg
chrdev_ebp:     resd      1
chrdev_ip:      resd      1
chrdev_fdn:     resd      1
                ends

        proc    chrdevdos
	global  chrdevdos
	enter	0,0
	push	ebx

        mov     ebx,[chrdev_fdn+ebp]     ; caller's fdn
        mov     ax,0x4400               ; ioctl get status
        int     0x21
	pop	ebx
	jc	chrdev1
	xor	eax,eax
	mov	al,dl
	leave
	retc	4
chrdev1: xor	eax,eax
	leave
	retc	4

;
;----------
;
;       rawmodedos(fdn,mode)    set console to raw/cooked mode
;
;       input:  fdn     = file descriptor
;               mode    = 0 = cooked, 1 = raw
;       output: none
;
;       preserves ds, es, esi, edi, ebx
;

                struc   rawmodearg
rawmode_ebp:    resd      1
rawmode_ip:     resd      1
rawmode_fdn:    resd      1
rawmode_mode:   resd      1
                endstruc

        proc    rawmodedos
	global  rawmodedos
	enter	0,0
	push	ebx

	push	[rawmode_fdn+ebp]
	callc	chrdevdos,4
	or	eax,eax
	jz	rawmode1
        and     eax,0x0df
	cmp	[rawmode_mode+ebp],0
	je	rawmode0
        or      al,0x20                 ; set raw bit
rawmode0:
	mov	edx,eax
        mov     ax,0x4401
        int     0x21
rawmode1: pop	ebx
	leave
	retc	4
%endif

%if linux
;
;----------
;
;  tryfpu - perform a floating point op to trigger a trap if no floating point hardware.
;
	global	tryfpu
tryfpu:
	push	ebp
	fldz
	pop	ebp
	ret
%endif


;;: error: symbol `id1' redefined
;;: error: symbol `id2blk' redefined
;;: error: symbol `ticblk' redefined
;;: error: symbol `tscblk' redefined
;;: error: symbol `inpbuf' redefined
;;: error: symbol `ttybuf' redefined
