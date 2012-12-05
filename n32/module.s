
; copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
; copyright 2012 David Shields
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

; The rest of this file was part of save-file / load module support for
; 32 bit SPITBOL 386 for Windows.


;;%if direct = 0
;
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
        ret			; done


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
	call	minimal_call
	add	esp,4

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
	call 	minimal_call  			; no return
	add	esp,4

%endif

; Startup code from Spitbol 3.8. This was part of Emmer's version, and
; contains code needed for save/restore of save files and load modules.

        global  startup
startup:
	call	atmsg
        pop     eax                     ; discard return
        pop     eax                     ; discard dummy1
        pop     eax                     ; discard dummy2
        call    stackinit               ; initialize MINIMAL stack
        mov     eax,dword [compsp]              ; get MINIMAL's stack pointer
        mov     dword [reg_wa],eax                     ; startup stack pointer

        cld                             ; default to UP direction for string ops
        extern  DFFNC
        lea     eax,[DFFNC]               ; get dd of PPM offset
        mov     dword [ppoff],eax               ; save for use later
        mov     esp,dword [osisp]               ; switch to new c stack
;	mov	dword [id_call],start_callid
;	start doesn't return, so there is no need to save or restore registers.
	push	start_callid
	call 	minimal_call   			 ; load regs, switch stack, start compiler
	add	esp,4

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
        mov     eax,esp
        mov     dword [compsp],eax              ; save as MINIMAL's stack pointer
        sub     eax,dword [stacksiz]     ; end of MINIMAL stack is where C stack will start
        mov     dword [osisp],eax       ; save new C stack pointer
        add     eax,4*100               ; 100 words smaller for CHK
        extern  LOWSPMIN
        mov	dword [LOWSPMIN],eax           ; Set lowspmin
	ret
;
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

	extern	id_call
	global	minimal_call
minimal_call:

        pushad                          	; save all registers for c
        mov     eax,dword[esp+32+4]          	; get ordinal
	mov	dword [id_call], eax
        mov     ecx,dword[reg_wa]              	; restore registers
        mov     ebx,dword[reg_wb]
        mov     edx,dword[reg_wc]              	; (also _reg_ia)
        mov     edi,dword[reg_xr]
        mov     esi,dword[reg_xl]
        mov     ebp,dword[reg_cp]
        mov     dword [osisp],esp               ; save osint stack pointer
        cmp     dword [compsp],0      ; is there a compiler stack?
        je      min1              ; jump if none yet
        mov     esp,dword [compsp]              ; switch to compiler stack
	extern	calltab
min1:   call   [calltab+eax*4]          ; off to the minimal code
        mov     esp,dword [osisp]               ; switch to osint stack
        mov     dword [reg_wa],ecx              ; save registers
        mov     dword [reg_wb],ebx
        mov     dword [reg_wc],edx
        mov     dword [reg_xr],edi
        mov     dword [reg_xl],esi
        mov     dword [reg_cp],ebp
        popad
        ret


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
        ret

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
;        mov     edi,sav_compsp          ;saved compiler's stack
        or      edi,edi                         ;is there one?
        je      pop1                      	;jump if none yet
        mov     esi,dword [edi]                 ;retrieve collectable XL
        mov     dword [reg_xl],esi              ;update XL
        add     edi,4                           ;update compiler's sp
        mov     dword [compsp],edi

pop1:   popad
        ret 

;
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

	extern	id_call
	global	minimal_call
minimal_call:

        pushad                          	; save all registers for c
        mov     eax,dword[esp+32+4]          	; get ordinal
	mov	dword [id_call], eax
        mov     ecx,dword[reg_wa]              	; restore registers
        mov     ebx,dword[reg_wb]
        mov     edx,dword[reg_wc]              	; (also _reg_ia)
        mov     edi,dword[reg_xr]
        mov     esi,dword[reg_xl]
        mov     ebp,dword[reg_cp]

        mov     dword [osisp],esp               ; save osint stack pointer
        cmp     dword [compsp],0      ; is there a compiler stack?
        je      min1              ; jump if none yet
        mov     esp,dword [compsp]              ; switch to compiler stack

	extern	calltab
min1:   call   [calltab+eax*4]          ; off to the minimal code
        mov     esp,dword [osisp]               ; switch to osint stack
        mov     dword [reg_wa],ecx              ; save registers
        mov     dword [reg_wb],ebx
        mov     dword [reg_wc],edx
        mov     dword [reg_xr],edi
        mov     dword [reg_xl],esi
        mov     dword [reg_cp],ebp
        popad
        ret

