# procedures needed for save file / load module support -- debug later

#
#-----------
#
#       get_fp  - get C caller's FP (frame pointer)
#
#       get_fp() returns the frame pointer for the C function that called
#       this function.  HOWEVER, THIS FUNCTION IS ONLY CALLED BY ZYSXI.
#
#       C function zysxi calls this function to determine the lowest USEFUL
#       word on the stack, so that only the useful part of the stack will be
#       saved in the load module.
#
#       The flow goes like this:
#
#       (1) User's spitbol program calls EXIT function
#
#       (2) spitbol compiler calls interface routine sysxi to handle exit
#
#       (3) Interface routine sysxi passes control to ccaller which then
#           calls C function zysxi
#
#       (4) C function zysxi will write a load module, but needs to save
#           a copy of the current stack in the load module.  The base of
#           the part of the stack to be saved begins with the frame of our
#           caller, so that the load module can execute a return to ccaller.
#
#           This will allow the load module to pretend to be returning from
#           C function zysxi.  So, C function zysxi calls this function,
#           get_fp, to determine the BASE OF THE USEFUL PART OF THE STACK.
#
#           We cheat just a little bit here.  C function zysxi can (and does)
#           have local variables, but we won't save them in the load module.
#           Only the portion of the frame established by the 80386 call
#           instruction, from BP up, is saved.  These local variables
#           aren't needed, because the load module will not be going back
#           to C function zysxi.  Instead when function restart returns, it
#           will act as if C function zysxi is returning.
#
#       (5) After writing the load module, C function zysxi calls C function
#           zysej to terminate spitbol's execution.
#
#       (6) When the resulting load module is executed, C function main
#           calls function restart.  Function restart restores the stack
#           and then does a return.  This return will act as if it is
#           C function zysxi doing the return and the user's program will
#           continue execution following its call to EXIT.
#
#       On entry to _get_fp, the stack looks like
#
#               /      ...      /
#       (high)  |               |
#               |---------------|
#       ZYSXI   |    old PC     |  --> return point in CCALLER
#         +     |---------------|  USEFUL part of stack
#       frame   |    old BP     |  <<<<-- BP of get_fp's caller
#               |---------------|     -
#               |     ZYSXI's   |     -
#               /     locals    /     - NON-USEFUL part of stack
#               |               |     ------
#       ======= |---------------|
#       SP-->   |    old PC     |  --> return PC in C function ZYSXI
#       (low)   +---------------+
#
#       On exit, return EBP in EAX. This is the lower limit on the
#       size of the stack.


        cproc    get_fp,near
	pubname	get_fp

        mov     eax,reg_xs      # Minimal's XS
        add     eax,4           # pop return from call to SYSBX or SYSXI
        retc    0               # done

        cendp    get_fp

#
#-----------
#
#       restart - restart for load module
#
#       restart( char *dummy, char *stackbase ) - startup compiler
#
#       The OSINT main function calls restart when resuming execution
#       of a program from a load module.  The OSINT main function has
#       reset global variables except for the stack and any associated
#       variables.
#
#       Before restoring stack, set up values for proper checking of
#       stack overflow. (initial sp here will most likely differ
#       from initial sp when compile was done.)
#
#       It is also necessary to relocate any addresses in the the stack
#       that point within the stack itself.  An adjustment factor is
#       calculated as the difference between the STBAS at exit() time,
#       and STBAS at restart() time.  As the stack is transferred from
#       TSCBLK to the active stack, each word is inspected to see if it
#       points within the old stack boundaries.  If so, the adjustment
#       factor is subtracted from it.
#
#       We use Minimal's INSTA routine to initialize static variables
#       not saved in the Save file.  These values were not saved so as
#       to minimize the size of the Save file.
#
	ext	rereloc,near

        cproc   restart,near
	pubname	restart

        pop     eax                     # discard return
        pop     eax                     # discard dummy
        pop     eax                     # get lowest legal stack value

        add     eax,stacksiz            # top of compiler's stack
        mov     esp,eax                 # switch to this stack
	call	stackinit               # initialize MINIMAL stack

                                        # set up for stack relocation
        lea     eax,TSCBLK+scstr        # top of saved stack
        mov     ebx,lmodstk             # bottom of saved stack
        GETMIN  ecx,STBAS               # ecx = stbas from exit() time
        sub     ebx,eax                 # ebx = size of saved stack
	mov	edx,ecx
        sub     edx,ebx                 # edx = stack bottom from exit() time
	mov	ebx,ecx
        sub     ebx,esp                 # ebx = old stbas - new stbas

        SETMINR  STBAS,esp               # save initial sp
#        GETOFF  eax,DFFNC               # get address of PPM offset
        mov     ppoff,eax               # save for use later
#
#       restore stack from TSCBLK.
#
        mov     esi,lmodstk             # -> bottom word of stack in TSCBLK
        lea     edi,TSCBLK+scstr        # -> top word of stack
        cmp     esi,edi                 # Any stack to transfer?
        je      short re3               #  skip if not
	sub	esi,4
	std
re1:    lodsd                           # get old stack word to eax
        cmp     eax,edx                 # below old stack bottom?
        jb      short re2               #   j. if eax < edx
        cmp     eax,ecx                 # above old stack top?
        ja      short re2               #   j. if eax > ecx
        sub     eax,ebx                 # within old stack, perform relocation
re2:    push    eax                     # transfer word of stack
        cmp     esi,edi                 # if not at end of relocation then
        jae     re1                     #    loop back

re3:	cld
        mov     compsp,esp              # 1.39 save compiler's stack pointer
        mov     esp,osisp               # 1.39 back to OSINT's stack pointer
        callc   rereloc,0               # V1.08 relocate compiler pointers into stack
        GETMIN  eax,STATB               # V1.34 start of static region to XR
	SET_XR  eax
        MINIMAL INSTA                   # V1.34 initialize static region

#
#       Now pretend that we're executing the following C statement from
#       function zysxi:
#
#               return  NORMAL_RETURN#
#
#       If the load module was invoked by EXIT(), the return path is
#       as follows:  back to ccaller, back to S$EXT following SYSXI call,
#       back to user program following EXIT() call.
#
#       Alternately, the user specified -w as a command line option, and
#       SYSBX called MAKEEXEC, which in turn called SYSXI.  The return path
#       should be:  back to ccaller, back to MAKEEXEC following SYSXI call,
#       back to SYSBX, back to MINIMAL code.  If we allowed this to happen,
#       then it would require that stacked return address to SYSBX still be
#       valid, which may not be true if some of the C programs have changed
#       size.  Instead, we clear the stack and execute the restart code that
#       simulates resumption just past the SYSBX call in the MINIMAL code.
#       We distinguish this case by noting the variable STAGE is 4.
#
        callc   startbrk,0              # start control-C logic

        GETMIN  eax,STAGE               # is this a -w call?
	cmp	eax,4
        je      short re4               # yes, do a complete fudge

#
#       Jump back to cc1 with return value = NORMAL_RETURN
	mov	eax,-1
        jmp     cc1                     # jump back

#       Here if -w produced load module.  simulate all the code that
#       would occur if we naively returned to sysbx.  Clear the stack and
#       go for it.
#
re4:	GETMIN	eax,STBAS
        mov     compsp,eax              # 1.39 empty the stack

#       Code that would be executed if we had returned to makeexec:
#
        SETMIN  GBCNT,0                 # reset garbage collect count
        callc   zystm,0                 # Fetch execution time to reg_ia
        mov     eax,reg_ia              # Set time into compiler
	SETMINR	TIMSX,eax

#       Code that would be executed if we returned to sysbx:
#
        push    outptr                  # swcoup(outptr)
	callc	swcoup,4

#       Jump to Minimal code to restart a save file.

        MINIMAL RSTRT                   # no return

        cendp    restart

