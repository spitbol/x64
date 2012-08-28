;-------------------------- block386.inc -----------------------------
;
;       copyright 1989 catspaw, inc.   all rights reserved.
;
;       spitbol blocks
;
;       all spitbol objects are encapsulated into blocks of memory.
;       the first word of each block identifies the block type in a
;       curious way.  rather than containing a simple integer type
;       code, it contains the address of a subroutine that performs
;       some particular action on the block, such as placing it on
;       the stack.  because each block type uses a different subroutine,
;       the subroutine addresses serve as a type identifier.
;
;       each subroutine is proceeded in memory by a one-byte integer
;       type code (given below).  thus to obtain a simple ordinal
;       type code for a block pointed to by an address in ebx, the following
;       code sequence will load the ordinal value into register al:
;
;       ....                    block pointer in ebx
;       mov     eax,[ebx]       type word (subroutine pointer) to eax
;       mov     al,[eax-1]      load integer type code to al
;
;       to obtain the type code as a full 32-bit integer, replace the last
;       instruction with:
;
;       movzx   eax,byte ptr [eax-1]    load integer type code to eax
;
;       +---------------------+               +------------------ +
;       |      type word      |----+          | integer type byte |
;       +---------------------+    |          +-------------------+--------+
;       |      block data     |    +--------->|   program code for this    |
;      ...                   ...              |   block type               |
;       |                     |               |                            |
;       +---------------------+               +----------------------------+
;
;
;       given an integer type, the type word can be obtained by
;       looking it up in a table provided to external functions in ptyptab
;       (provided in the miscellaneous area).
;       for example, if the ptyptab pointer is loaded into es:ecx, then given
;       a small integer type code in eax, the type word is obtained with:
;
;       mov     eax,es:[ecx+eax*4]     obtain type word
;
;
;       block codes for accessible datatypes
;
;       these blocks may appear in an argument list if left untranslated
;       by the load function definition.
;
	segment	.data
bl_ar  equ      0               ;arblk  array
bl_cd  equ      bl_ar+1         ;cdblk  code
bl_ex  equ      bl_cd+1         ;exblk  expression
bl_ic  equ      bl_ex+1         ;icblk  integer
bl_nm  equ      bl_ic+1         ;nmblk  name
bl_p0  equ      bl_nm+1         ;p0blk  pattern, 0 args
bl_p1  equ      bl_p0+1         ;p1blk  pattern, 1 arg
bl_p2  equ      bl_p1+1         ;p2blk  pattern, 2 args
bl_rc  equ      bl_p2+1         ;rcblk  real
bl_sc  equ      bl_rc+1         ;scblk  string
bl_se  equ      bl_sc+1         ;seblk  expression
bl_tb  equ      bl_se+1         ;tbblk  table
bl_vc  equ      bl_tb+1         ;vcblk  vector (array)
bl_xn  equ      bl_vc+1         ;xnblk  external, non-relocatable contents
bl_xr  equ      bl_xn+1         ;xrblk  external, relocatable contents
bl_bc  equ      bl_xr+1         ;bcblk  buffer control
bl_pd  equ      bl_bc+1         ;pdblk  program defined datatype

bl__d  equ      bl_pd+1         ;number of block codes for data
;
;
;       other block codes
;
;       these blocks will never appear in an argument list, but are
;       listed here for completeness.
;
bl_tr  equ      bl_pd+1         ;trblk  trace
bl_bf  equ      bl_tr+1         ;bfblk  string buffer
bl_cc  equ      bl_bf+1         ;ccblk  code construction
bl_cm  equ      bl_cc+1         ;cmblk  compiler tree node
bl_ct  equ      bl_cm+1         ;ctblk  character table
bl_df  equ      bl_ct+1         ;dfblk  datatype function
bl_ef  equ      bl_df+1         ;efblk  external function
bl_ev  equ      bl_ef+1         ;evblk  expression variable
bl_ff  equ      bl_ev+1         ;ffblk  field function
bl_kv  equ      bl_ff+1         ;kvblk  keyword variable
bl_pf  equ      bl_kv+1         ;pfblk  program-defined functin
bl_te  equ      bl_pf+1         ;teblk  table element

;
;
;
;       structure of common spitbol blocks:
;         integer, real, string, and file blocks.
;
;       these structures can be applied to the result area to determine
;       where to store required return information.
;
;
;       structure of icblk (integers)
;
;	segment	.text
;;	segment	.data
        struc   icblk
ictyp:  resd      1               ;type word
icval:  resd      1               ;integer value
;;        endstruc
;
;
;       structure of rcblk (reals)
;
        struc   rcblk
rctyp:  resd      1               ;type word
rcval:  resd      1               ;real value
        endstruc
;;;
;;;       structure of scblk (strings)
;;;
	section	.data
        struc   scblk
sctyp:  resd      1               ;type word
sclen:  resd      1               ;string length
scstr:  resb      1               ;start of string
        endstruc
;;;
;;;       structure for returning a string via a pointer
;;;
        struc   fsblk
fstyp:  resd      1               ;type word
fslen:  resd      1               ;string length
fsptr:  resd      1               ;near pointer to string
        endstruc
;;;
;;;       structure for returning an external block via a pointer
;;;
;;        struc   fxblk
;;fxtyp:  dd      0               ;type word
;;fxlen:  dd      0               ;external data length
;;fxptr:  dd      0               ;near pointer to external data
;;        endstruc
;;
;;;
;;;
;;;       file control block
;;;
;;;       the user may provide the word "file" for any argument in
;;;       the load function prototype.  when a call is made to the
;;;       external function with an i/o associated variable in this argument
;;;       position, spitbol will provide a pointer to the file control
;;;       block instead of the value of the variable.
;;;
;;;       the file control block (fcb) points to an i/o block with
;;;       additional information.  in turn, the i/o block points to any
;;;       buffer used by the file.
;;;
;;;       this block is obtained for every file except those associated
;;;       with input, output, or terminal.  note that these fcb's are
;;;       unrelated to ms-dos fcb's.  file control blocks do not have
;;;       their own type word, but appear as xrblks with the following structure:
;;
;;;
;;        struc   fcblk
;;fcbtyp: dd      0               ;type word (xrblk)
;;fcblen: dd      0               ;size of block, in bytes
;;fcbrsz: dd      0               ;spitbol record size and mode
;;                                ;positive if text mode, negative if binary
;;fcbiob: dd      0               ;pointer to ioblk
;;fcbmod: dd      0               ;1 if text mode, 0 if binary mode
;;        endstruc
;;;
;;;       i/o block
;;;
;;;       an i/o block is pointed to by the fcbiob field of a file control block.
;;;
;;        struc   ioblk
;;iobtyp: dd      0               ;type word (xrblk)
;;ioblen: dd      0               ;size of ioblk in bytes
;;iobfnm: dd      0               ;pointer to scblk holding filename
;;iobpid: dd      0               ;process id for pipe (not used for dos)
;;iobbfb: dd      0               ;pointer to bfbblk
;;iobfdn: dd      0               ;o/s file descriptor number
;;iobflg1:dd      0               ;flags 1 (see below)
;;iobflg2:dd      0               ;flags 2 (see below)
;;iobeol1:dd      0               ;end of line character 1
;;iobeol2:dd      0               ;end of line character 2
;;iobshare:dd     0               ;sharing mode
;;iobaction:dd    0               ;file open actions
;;        endstruc
;;
;       bits in iobflg1 dword:
;
io_inp equ      0x00000001       ;input file
io_oup equ      0x00000002       ;output file
io_app equ      0x00000004       ;append output to end of existing file
io_opn equ      0x00000008       ;file is open
io_cot equ      0x00000010       ;console output to non-disk device
io_cin equ      0x00000020       ;console input from non-disk device
io_sys equ      0x00000040       ;system file descriptor used instead of name
io_wrc equ      0x00000080       ;output without buffering
io_eot equ      0x00000100       ;ignore end-of-text (control-z) character

;       bits in iobflg2 dword:
;
io_pip equ      0x00000001       ;pipe (not used in ms-dos)
io_ded equ      0x00000002       ;dead pipe (not used in ms-dos)
io_ill equ      0x00000004       ;illegal i/o association
io_raw equ      0x00000008       ;binary i/o
io_lf  equ      0x00000010       ;ignore line feed if next character
io_noe equ      0x00000020       ;no echo input
io_env equ      0x00000040       ;filearg1 maps to filename thru environment var
io_dir equ      0x00000080       ;buffer is dirty (needs to be written)
io_bin equ      0x00000100       ;binary i/o

;       bits in iobshare dword:
io_compatibility  equ      0x00
io_deny_readwrite equ      0x01
io_deny_write     equ      0x02
io_deny_read      equ      0x03
io_deny_none      equ      0x04
io_deny_mask      equ      0x07  ;mask for above deny mode bits
io_executable     equ      0x40  ;file to be marked executable
io_private        equ      0x80  ;file is private to current process

;       bits in iobaction dword:
io_fail_if_exists     equ  0x00
io_open_if_exists     equ  0x01
io_replace_if_exists  equ  0x02
io_fail_if_not_exist  equ  0x00
io_create_if_not_exist equ 0x10
io_exist_action_mask  equ  0x13  ;mask for above bits
io_write_thru         equ  0x20  ;writes complete before return

;
;       i/o buffer block
;
;       an i/o buffer block (bfbblk) is pointed to by an ioblk.
;
;;        struc   bfbblk
;;bfbtyp: dd      0               ;type word (xnblk)
;;bfblen: dd      0               ;size of bfbblk, in bytes
;;bfbsiz: dd      0               ;size of buffer in bytes
;;bfbfil: dd      0               ;number of bytes currently in buffer
;;bfbnxt: dd      0               ;offset of next buffer char to r/w
;;bfboff: dd      0               ;file position of first byte in buf
;;bfbcur: dd      0               ;physical file position
;;bfbbuf: db      0               ;start of buffer
;;        endstruc
;;;
;;;
;;;       structure of efblk (external function).  a pointer to this block
;;;       is passed to the external function in the miscellaneous area
;;;       in pefblk.
;;;
;;        struc   efblk
;;fcode:  dd      0               ;type word
;;fargs:  dd      0               ;number of arguments
;;eflen:  dd      0               ;block length
;;efuse:  dd      0               ;usage count
;;efcod:  dd      0               ;pointer to xnblk, see below
;;efvar:  dd      0               ;pointer to vrblk with function name
;;efrsl:  dd      0               ;result type  (see below)
;;eftar:  dd      0               ;argument types, one dword per arg (see below)
;;        endstruc
;;;
;;;  efrsl and eftar[] dwords contain small integer type codes as follows:
;;;  0 - unconverted
;;;  1 - convert to string
;;;  2 - convert to integer
;;;  3 - convert to real
;;;  4 - produce as file control block associated with variable
;;;
;;;
;;;       structure of xnblk allocated for external function
;;;       a pointer to this structure is passed to the external function
;;;       in the miscellaneous area in pxnblk.
;;;
;;
;;        struc   xnblk           ;keep as multiple of dwords
;;xntyp:  dd      0               ;type word
;;xnlen:  dd      0               ;length of this block
;;xnhand: dd      0               ;module handle
;;xnpfn:  dd      0               ;pointer to function
;;xn1st:  dd      0               ;non-zero means first-ever call
;;xnsave: dd      0               ;non-zero means first call after reload of save file
;;xncbp:  dd      0               ;call back address prior to saving or exiting
;;        endstruc
;;xndta  equ      (xnlen+4)       ;start of user data region in xnblk
;;;
;;
;;;
;;;  other selected blocks of interest:
;;;
;;;
;;;       array block
;;;
;;;       an array block (arblk) represents an array value other than one
;;;       with one dimension whose lower bound is one (see vcblk).
;;;
;;        struc   arblk
;;artyp:  dd      0               ;type word (arblk)
;;aridv:  dd      0               ;identifier value
;;arlen:  dd      0               ;length of arblk in bytes
;;arofs:  dd      0               ;offset in arblk to arpro field
;;arndm:  dd      0               ;number of dimensions
;;arlbd:  dd      0               ;low bound (first subscript)
;;ardim:  dd      0               ;dimension (first subscript)
;;; above two dwords are repeated for each additional dimension
;;arpro:  dd      0               ;array prototype string
;;arvls:  dd      0               ;start of values in row-wise order
;;        endstruc
;;
;;;       buffer control block
;;;
;;;       a buffer control block (bcblk) is created by the buffer
;;;       function, and serves as an indirect control header for the
;;;       buffer. it contains the number of characters currently
;;;       stored in the buffer.
;;;
;;        struc   bcblk
;;bctyp:  dd      0               ;type word (bcblk)
;;bcidv:  dd      0               ;identifier value
;;bclen:  dd      0               ;number of chars in use in bfblk
;;bcbuf:  dd      0               ;pointer to bfblk
;;        endstruc
;;
;;;       string buffer block
;;;
;;;       a string buffer block (bfblk) contains the actual buffer
;;;       memory area. it specifies the largest string that can be
;;;       stored in the buffer.
;;;
;;        struc   bfblk
;;bftyp:  dd      0               ;type word (bfblk)
;;bfalc:  dd      0               ;allocated size of buffer
;;bfchr:  db      0               ;characters of string
;;        endstruc
;;
;;;
;;;       code block
;;;
;;;       a code block (cdblk) is present for every source statement.
;;;
;;        struc   cdblk
;;cdjmp:  dd      0               ;ptr to routine to execute statement
;;cdstm:  dd      0               ;statement number
;;cdsln:  dd      0               ;source file line number
;;cdlen:  dd      0               ;length of cdblk in bytes
;;cdfal:  dd      0               ;failure exit
;;cdcod:  dd      0               ;start of executable pseudo-code
;;        endstruc
;;
;;;
;;;       name block
;;;
;;;       a name block (nmblk) is used whereever a name must be stored as
;;;       a value following use of the unary dot operator.
;;;
;;        struc   nmblk
;;nmtyp:  dd      0               ;type word (nmblk)
;;nmbas:  dd      0               ;base pointer for variable
;;nmofs:  dd      0               ;offset for variable
;;        endstruc
;;
;;;
;;;       table block
;;;
;;;       a table block (tbblk) is used to represent a table value.
;;;       it comprises a list of buckets, each of which may point to
;;;       a chain of teblks.  tbbuk entries either point to the first
;;;       teblk on the chain or they point to the tbblk itself to
;;;       indicate the end of the chain.  the number of buckets can
;;;       be deduced from tblen.
;;;
;;        struc   tbblk
;;tbtyp:  dd      0               ;type word (tbblk)
;;tbidv:  dd      0               ;identifier value
;;tblen:  dd      0               ;length of tbblk in bytes
;;tbinv:  dd      0               ;default initial lookup value
;;tbbuk:  dd      0               ;start of hash bucket pointers
;;        endstruc
;;
;;;
;;;       table element block
;;;
;;;       a table element (teblk) is used to represent a single entry in
;;;       a table.
;;;
;;        struc   teblk
;;tetyp:  dd      0               ;type word (teblk)
;;tesub:  dd      0               ;subscript value
;;teval:  dd      0               ;table element value
;;tenxt:  dd      0               ;link to next teblk or tbblk if end of chain
;;        endstruc
;;
;;;       vector block
;;;
;;;       a vector block (vcblk) is used to represent an array value which has
;;;       one dimension whose lower bound is one. all other arrays are
;;;       represented by arblks.  the number of elements can be deduced
;;;       from vclen.
;;;
;;        struc   vcblk
;;vctyp:  dd      0               ;type word (vcblk)
;;vcidv:  dd      0               ;identifier value
;;vclen:  dd      0               ;length of vcblk in bytes
;;vcvls:  dd      0               ;start of vector values
;;        endstruc
;;
;---------------------  end of block386.inc -----------------------
