
;       Interface routines

;       Each interface routine takes the following form:

;               SYSXX   call    ccaller         ; call common interface
;                       dd      zysxx           ; dd      of C OSINT function
;                       db      n               ; offset to instruction after
;                                               ;   last procedure exit

;       In an effort to achieve portability of C OSINT functions, we
;       do not take take advantage of any "internal" to "external"
;       transformation of names by C compilers.  So, a C OSINT function
;       representing sysxx is named _zysxx.  This renaming should satisfy
;       all C compilers.

;       IMPORTANT  ONE interface routine, SYSFC, is passed arguments on
;       the stack.  These items are removed from the stack before calling
;       ccaller, as they are not needed by this implementation.


;-----------

;       CCALLER is called by the OS interface routines to call the
;       real C OS interface function.

;       General calling sequence is

;               call    ccaller
;               dd      address_of_C_function
;               db      2*number_of_exit_points

;       Control IS NEVER returned to a interface routine.  Instead, control
;       is returned to the compiler (THE caller of the interface routine).

;       The C function that is called MUST ALWAYS return an integer
;       indicating the procedure exit to take or that a normal return
;       is to be performed.

;               C function      Interpretation
;               return value
;               ------------    -------------------------------------------
;                    <0         Do normal return to instruction past
;                               last procedure exit (distance passed
;                               in by dummy routine and saved on stack)
;                     0         Take procedure exit 1
;                     4         Take procedure exit 2
;                     8         Take procedure exit 3
;                    ...        ...


	extern	_rc_
	extern	reg_xl
	extern	reg_xr
	extern	reg_xs
	extern	reg_wa
	extern	reg_wb
	extern	reg_wc
	extern	reg_cp
	extern	reg_pc
	extern	reg_pp
	extern	osisp
	extern	compsp
	segment	.data
call_adr:	dd	0
	segment	.text

ccaller:
;       (1) Save registers in global variables

        mov     dword [reg_wa],ecx              ; save registers
	mov	dword [reg_wb],ebx
        mov     dword [reg_wc],edx              ; (also _reg_ia)
	mov	dword [reg_xr],edi
	mov	dword [reg_xl],esi
        mov     dword [reg_cp],ebp              ; Needed in image saved by sysxi

;       (2) Get pointer to arg list

        pop     esi                     ; point to arg list

;       (3) Fetch dd      of C function], fetch offset to 1st instruction
;           past last procedure exit], and call C function.

        cs                              ; CS segment override
        lodsd                           ; point to C function entry point
	mov	dword [call_adr],eax
;       lodsd   cs:ccaller              ; point to C function entry point
;	word after callee address used to be ppm count. Now used for debug
	mov	ebx,dword[esi]
        mov     dword [reg_pp],ebx              ; in memory
        pop     dword [reg_pc]                  ; save return PC past "CALL SYSXX"

;       (3a) Save compiler stack and switch to OSINT stack

; DS 12/22/12 Note that needn't save and restore stack ptrs if not using
; 	save files or load modules
         mov     dword [compsp],esp              ; 1.39 save compiler's stack pointer
         mov     esp,dword [osisp]               ; 1.39 load OSINT's stack pointer

;       (3b) Make call to OSINT
	mov	eax,dword [call_adr]
        call    eax                     ; call C interface function

	mov	dword [_rc_],eax		; save return code from function

;       (4) Restore registers after C function returns.


cc1:    
 	mov     dword [osisp],esp               ; 1.39 save OSINT's stack pointer
        mov     esp,dword [compsp]              ; 1.39 restore compiler's stack pointer
        mov     ecx,dword [reg_wa]              ; restore registers
	mov	ebx,dword [reg_wb]
        mov     edx,dword [reg_wc]              ; (also reg_ia)
	mov	edi,dword [reg_xr]
	mov	esi,dword [reg_xl]
	mov	ebp,dword [reg_cp]

	cld

	mov	eax,dword [reg_pc]
	jmp	eax


;---------------

;       Individual OSINT routine entry points

        global SYSAX
	extern	zysax
SYSAX:	call	ccaller
        dd        zysax
        dd   1

        global SYSBS
	extern	zysbs
SYSBS:	call	ccaller
        dd        zysbs
        dd   2

        global SYSBX
	extern	zysbx
SYSBX:	mov	dword [reg_xs],esp
	call	ccaller
        dd      zysbx
        dd   2

;        global SYSCR
;	extern	zyscr
;SYSCR:  call    ccaller
;        dd      zyscr
;        dd   0
;
        global SYSDC
	extern	zysdc
SYSDC:	call	ccaller
        dd      zysdc
        dd   4

        global SYSDM
	extern	zysdm
SYSDM:	call	ccaller
        dd      zysdm
        dd   5

        global SYSDT
	extern	zysdt
SYSDT:	call	ccaller
        dd      zysdt
        dd   6

        global SYSEA
	extern	zysea
SYSEA:	call	ccaller
        dd      zysea
        dd   7

        global SYSEF
	extern	zysef
SYSEF:	call	ccaller
        dd      zysef
        dd   8

        global SYSEJ
	extern	zysej
SYSEJ:	call	ccaller
        dd      zysej
        dd   9

        global SYSEM
	extern	zysem
SYSEM:	call	ccaller
        dd      zysem
        dd   10

        global SYSEN
	extern	zysen
SYSEN:	call	ccaller
        dd      zysen
        dd   11

        global SYSEP
	extern	zysep
SYSEP:	call	ccaller
        dd      zysep
        dd  	12

        global SYSEX
	extern	zysex
SYSEX:	mov	dword [reg_xs],esp
	call	ccaller
        dd      zysex
        dd   13

        global SYSFC
	extern	zysfc
SYSFC:  pop     eax             ; <<<<remove stacked SCBLK>>>>
	lea	esp,[esp+edx*4]
	push	eax
	call	ccaller
        dd      zysfc
        dd   14

        global SYSGC
	extern	zysgc
SYSGC:	call	ccaller
        dd      zysgc
        dd   15

        global SYSHS
	extern	zyshs
SYSHS:	mov	dword [reg_xs],esp
	call	ccaller
        dd      zyshs
        dd   16

        global SYSID
	extern	zysid
SYSID:	call	ccaller
        dd      zysid
        dd   17

        global SYSIF
	extern	zysif
SYSIF:	call	ccaller
        dd      zysif
        dd   18

        global SYSIL
	extern	zysil
SYSIL:  call    ccaller
        dd      zysil
        dd   19

        global SYSIN
	extern	zysin
SYSIN:	call	ccaller
        dd      zysin
        dd   20

        global SYSIO
	extern	zysio
SYSIO:	call	ccaller
        dd      zysio
        dd   21

        global SYSLD
	extern	zysld
SYSLD:  call    ccaller
        dd      zysld
        dd   22

        global SYSMM
	extern	zysmm
SYSMM:	call	ccaller
        dd      zysmm
        dd   23

        global SYSMX
	extern	zysmx
SYSMX:	call	ccaller
        dd      zysmx
        dd   24

        global SYSOU
	extern	zysou
SYSOU:	call	ccaller
        dd      zysou
        dd   25

        global SYSPI
	extern	zyspi
SYSPI:	call	ccaller
        dd      zyspi
        dd   26

        global SYSPL
	extern	zyspl
SYSPL:	call	ccaller
        dd      zyspl
        dd   27

        global SYSPP
	extern	zyspp
SYSPP:	call	ccaller
        dd      zyspp
        dd   28

        global SYSPR
	extern	zyspr
SYSPR:	call	ccaller
        dd      zyspr
        dd   29

        global SYSRD
	extern	zysrd
SYSRD:	call	ccaller
        dd      zysrd
        dd   30

        global SYSRI
	extern	zysri
SYSRI:	call	ccaller
        dd      zysri
        dd   32

        global SYSRW
	extern	zysrw
SYSRW:	call	ccaller
        dd      zysrw
        dd   33

        global SYSST
	extern	zysst
SYSST:	call	ccaller
        dd      zysst
        dd   34

        global SYSTM
	extern	zystm
SYSTM:	call	ccaller
systm_p: dd      zystm
        dd   35

        global SYSTT
	extern	zystt
SYSTT:	call	ccaller
        dd      zystt
        dd   36

        global SYSUL
	extern	zysul
SYSUL:	call	ccaller
        dd      zysul
        dd   37

        global SYSXI
	extern	zysxi
SYSXI:	mov	dword [reg_xs],esp
	call	ccaller
sysxi_p: dd      zysxi
        dd   38
