#-------------------------- block386.inc -----------------------------
.nolist
#
#
#       copyright 1989 catspaw, inc.   all rights reserved.
#
#       spitbol blocks
#
#       all spitbol objects are encapsulated into blocks of memory.
#       the first word of each block identifies the block type in a
#       curious way.  rather than containing a simple integer type
#       code, it contains the address of a subroutine that performs
#       some particular action on the block, such as placing it on
#       the stack.  because each block type uses a different subroutine,
#       the subroutine addresses serve as a type identifier.
#
#       each subroutine is proceeded in memory by a one-byte integer
#       type code (given below).  thus to obtain a simple ordinal
#       type code for a block pointed to by an address in ebx, the following
#       code sequence will load the ordinal value into register al:
#
#       ....                    block pointer in ebx
#       mov     eax,[ebx]       type word (subroutine pointer) to eax
#       mov     al,[eax-1]      load integer type code to al
#
#       to obtain the type code as a full 32-bit integer, replace the last
#       instruction with:
#
#       movzx   eax,byte ptr [eax-1]    load integer type code to eax
#
#       +---------------------+               +------------------ +
#       |      type word      |----+          | integer type byte |
#       +---------------------+    |          +-------------------+--------+
#       |      block data     |    +--------->|   program code for this    |
#      ...                   ...              |   block type               |
#       |                     |               |                            |
#       +---------------------+               +----------------------------+
#
#
#       given an integer type, the type word can be obtained by
#       looking it up in a table provided to external functions in ptyptab
#       (provided in the miscellaneous area).
#       for example, if the ptyptab pointer is loaded into es:ecx, then given
#       a small integer type code in eax, the type word is obtained with:
#
#       mov     eax,es:[ecx+eax*4]     obtain type word
#
#
#       block codes for accessible datatypes
#
#       these blocks may appear in an argument list if left untranslated
#       by the load function definition.
#
BL_AR   =       0               #arblk  array
BL_CD   =       BL_AR+1         #cdblk  code
BL_EX   =       BL_CD+1         #exblk  expression
BL_IC   =       BL_EX+1         #icblk  integer
bl_nm   =       bl_ic+1         #nmblk  name
bl_p0   =       bl_nm+1         #p0blk  pattern, 0 args
bl_p1   =       bl_p0+1         #p1blk  pattern, 1 arg
bl_p2   =       bl_p1+1         #p2blk  pattern, 2 args
bl_rc   =       bl_p2+1         #rcblk  real
bl_sc   =       bl_rc+1         #scblk  string
bl_se   =       bl_sc+1         #seblk  expression
bl_tb   =       bl_se+1         #tbblk  table
bl_vc   =       bl_tb+1         #vcblk  vector (array)
bl_xn   =       bl_vc+1         #xnblk  external, non-relocatable contents
bl_xr   =       bl_xn+1         #xrblk  external, relocatable contents
bl_bc   =       bl_xr+1         #bcblk  buffer control
bl_pd   =       bl_bc+1         #pdblk  program defined datatype

bl__d   =       bl_pd+1         #number of block codes for data
#
#
#       other block codes
#
#       these blocks will never appear in an argument list, but are
#       listed here for completeness.
#
bl_tr   =       bl_pd+1         #trblk  trace
bl_bf   =       bl_tr+1         #bfblk  string buffer
bl_cc   =       bl_bf+1         #ccblk  code construction
bl_cm   =       bl_cc+1         #cmblk  compiler tree node
bl_ct   =       bl_cm+1         #ctblk  character table
bl_df   =       bl_ct+1         #dfblk  datatype function
bl_ef   =       bl_df+1         #efblk  external function
bl_ev   =       bl_ef+1         #evblk  expression variable
bl_ff   =       bl_ev+1         #ffblk  field function
bl_kv   =       bl_ff+1         #kvblk  keyword variable
bl_pf   =       bl_kv+1         #pfblk  program-defined functin
bl_te   =       bl_pf+1         #teblk  table element
#
#
#
#       structure of common spitbol blocks:
#         integer, real, string, and file blocks.
#
#       these structures can be applied to the result area to determine
#       where to store required return information.
#
#
#       structure of icblk (integers)
#
        struc   icblk
ictyp:  .long   0               #type word
icval:  .long   0               #integer value
        ends    icblk
#
#
#       structure of rcblk (reals)
#
        struc   rcblk
rctyp:  .long   0               #type word
rcval:  .double 0               #real value
        ends    rcblk
#
#       structure of scblk (strings)
#
        struc   scblk
sctyp:  .long   0               #type word
sclen:  .long   0               #string length
scstr:  .byte   0               #start of string
        ends    scblk
#
#       structure for returning a string via a pointer
#
        struc   fsblk
fstyp:  .long   0               #type word
fslen:  .long   0               #string length
fsptr:  .long   0               #near pointer to string
        ends    fsblk
#
#       structure for returning an external block via a pointer
#
        struc   fxblk
fxtyp:  .long   0               #type word
fxlen:  .long   0               #external data length
fxptr:  .long   0               #near pointer to external data
        ends    fxblk
#
#
#       file control block
#
#       the user may provide the word "file" for any argument in
#       the load function prototype.  when a call is made to the
#       external function with an i/o associated variable in this argument
#       position, spitbol will provide a pointer to the file control
#       block instead of the value of the variable.
#
#       the file control block (fcb) points to an i/o block with
#       additional information.  in turn, the i/o block points to any
#       buffer used by the file.
#
#       this block is obtained for every file except those associated
#       with input, output, or terminal.  note that these fcb's are
#       unrelated to ms-dos fcb's.  file control blocks do not have
#       their own type word, but appear as xrblks with the following structure:

#
        struc   fcblk
fcbtyp: .long   0               #type word (xrblk)
fcblen: .long   0               #size of block, in bytes
fcbrsz: .long   0               #spitbol record size and mode
                                #positive if text mode, negative if binary
fcbiob: .long   0               #pointer to ioblk
fcbmod: .long   0               #1 if text mode, 0 if binary mode
        ends    fcblk
#
#       i/o block
#
#       an i/o block is pointed to by the fcbiob field of a file control block.
#
        struc   ioblk
iobtyp: .long   0               #type word (xrblk)
ioblen: .long   0               #size of ioblk in bytes
iobfnm: .long   0               #pointer to scblk holding filename
iobpid: .long   0               #process id for pipe (not used for dos)
iobbfb: .long   0               #pointer to bfbblk
iobfdn: .long   0               #o/s file descriptor number
iobflg1:.long   0               #flags 1 (see below)
iobflg2:.long   0               #flags 2 (see below)
iobeol1:.long   0               #end of line character 1
iobeol2:.long   0               #end of line character 2
iobshare:.long  0               #sharing mode
iobaction:.long 0               #file open actions
        ends    ioblk

#       bits in iobflg1 dword:
#
io_inp  =       0x00000001       #input file
io_oup  =       0x00000002       #output file
io_app  =       0x00000004       #append output to end of existing file
io_opn  =       0x00000008       #file is open
io_cot  =       0x00000010       #console output to non-disk device
io_cin  =       0x00000020       #console input from non-disk device
io_sys  =       0x00000040       #system file descriptor used instead of name
io_wrc  =       0x00000080       #output without buffering
io_eot  =       0x00000100       #ignore end-of-text (control-z) character

#       bits in iobflg2 dword:
#
io_pip  =       0x00000001       #pipe (not used in ms-dos)
io_ded  =       0x00000002       #dead pipe (not used in ms-dos)
io_ill  =       0x00000004       #illegal i/o association
io_raw  =       0x00000008       #binary i/o
io_lf   =       0x00000010       #ignore line feed if next character
io_noe  =       0x00000020       #no echo input
io_env  =       0x00000040       #filearg1 maps to filename thru environment var
io_dir  =       0x00000080       #buffer is dirty (needs to be written)
io_bin  =       0x00000100       #binary i/o

#       bits in iobshare dword:
io_compatibility   =       0x00
io_deny_readwrite  =       0x01
io_deny_write      =       0x02
io_deny_read       =       0x03
io_deny_none       =       0x04
io_deny_mask       =       0x07  #mask for above deny mode bits
io_executable      =       0x40  #file to be marked executable
io_private         =       0x80  #file is private to current process

#       bits in iobaction dword:
io_fail_if_exists      =   0x00
io_open_if_exists      =   0x01
io_replace_if_exists   =   0x02
io_fail_if_not_exist   =   0x00
io_create_if_not_exist =   0x10
io_exist_action_mask   =   0x13  #mask for above bits
io_write_thru          =   0x20  #writes complete before return

#
#       i/o buffer block
#
#       an i/o buffer block (bfbblk) is pointed to by an ioblk.
#
        struc   bfbblk
bfbtyp: .long   0               #type word (xnblk)
bfblen: .long   0               #size of bfbblk, in bytes
bfbsiz: .long   0               #size of buffer in bytes
bfbfil: .long   0               #number of bytes currently in buffer
bfbnxt: .long   0               #offset of next buffer char to r/w
bfboff: .long   0               #file position of first byte in buf
bfbcur: .long   0               #physical file position
bfbbuf: .byte   0               #start of buffer
        ends    bfbblk
#
#
#       structure of efblk (external function).  a pointer to this block
#       is passed to the external function in the miscellaneous area
#       in pefblk.
#
        struc   efblk
fcode:  .long   0               #type word
fargs:  .long   0               #number of arguments
eflen:  .long   0               #block length
efuse:  .long   0               #usage count
efcod:  .long   0               #pointer to xnblk, see below
efvar:  .long   0               #pointer to vrblk with function name
efrsl:  .long   0               #result type  (see below)
eftar:  .long   0               #argument types, one dword per arg (see below)
        ends    efblk
#
#  efrsl and eftar[] dwords contain small integer type codes as follows:
#  0 - unconverted
#  1 - convert to string
#  2 - convert to integer
#  3 - convert to real
#  4 - produce as file control block associated with variable
#
#
#       structure of xnblk allocated for external function
#       a pointer to this structure is passed to the external function
#       in the miscellaneous area in pxnblk.
#

        struc   xnblk           #keep as multiple of dwords
xntyp:  .long   0               #type word
xnlen:  .long   0               #length of this block
xnhand: .long   0               #module handle
xnpfn:  .long   0               #pointer to function
xn1st:  .long   0               #non-zero = first-ever call
xnsave: .long   0               #non-zero = first call after reload of save file
xncbp:  .long   0               #call back address prior to saving or exiting
        ends    xnblk
xndta   =       (xnlen+4)       #start of user data region in xnblk
#

#
#  other selected blocks of interest:
#
#
#       array block
#
#       an array block (arblk) represents an array value other than one
#       with one dimension whose lower bound is one (see vcblk).
#
        struc   arblk
artyp:  .long   0               #type word (arblk)
aridv:  .long   0               #identifier value
arlen:  .long   0               #length of arblk in bytes
arofs:  .long   0               #offset in arblk to arpro field
arndm:  .long   0               #number of dimensions
arlbd:  .long   0               #low bound (first subscript)
ardim:  .long   0               #dimension (first subscript)
# above two dwords are repeated for each additional dimension
arpro:  .long   0               #array prototype string
arvls:  .long   0               #start of values in row-wise order
        ends    arblk

#       buffer control block
#
#       a buffer control block (bcblk) is created by the buffer
#       function, and serves as an indirect control header for the
#       buffer. it contains the number of characters currently
#       stored in the buffer.
#
        struc   bcblk
bctyp:  .long   0               #type word (bcblk)
bcidv:  .long   0               #identifier value
bclen:  .long   0               #number of chars in use in bfblk
bcbuf:  .long   0               #pointer to bfblk
        ends    bcblk

#       string buffer block
#
#       a string buffer block (bfblk) contains the actual buffer
#       memory area. it specifies the largest string that can be
#       stored in the buffer.
#
        struc   bfblk
bftyp:  .long   0               #type word (bfblk)
bfalc:  .long   0               #allocated size of buffer
bfchr:  .byte   0               #characters of string
        ends    bfblk

#
#       code block
#
#       a code block (cdblk) is present for every source statement.
#
        struc   cdblk
cdjmp:  .long   0               #ptr to routine to execute statement
cdstm:  .long   0               #statement number
cdsln:  .long   0               #source file line number
cdlen:  .long   0               #length of cdblk in bytes
cdfal:  .long   0               #failure exit
cdcod:  .long   0               #start of executable pseudo-code
        ends    cdblk

#
#       name block
#
#       a name block (nmblk) is used whereever a name must be stored as
#       a value following use of the unary dot operator.
#
        struc   nmblk
nmtyp:  .long   0               #type word (nmblk)
nmbas:  .long   0               #base pointer for variable
nmofs:  .long   0               #offset for variable
        ends    nmblk

#
#       table block
#
#       a table block (tbblk) is used to represent a table value.
#       it comprises a list of buckets, each of which may point to
#       a chain of teblks.  tbbuk entries either point to the first
#       teblk on the chain or they point to the tbblk itself to
#       indicate the end of the chain.  the number of buckets can
#       be deduced from tblen.
#
        struc   tbblk
tbtyp:  .long   0               #type word (tbblk)
tbidv:  .long   0               #identifier value
tblen:  .long   0               #length of tbblk in bytes
tbinv:  .long   0               #default initial lookup value
tbbuk:  .long   0               #start of hash bucket pointers
        ends    tbblk

#
#       table element block
#
#       a table element (teblk) is used to represent a single entry in
#       a table.
#
        struc   teblk
tetyp:  .long   0               #type word (teblk)
tesub:  .long   0               #subscript value
teval:  .long   0               #table element value
tenxt:  .long   0               #link to next teblk or tbblk if end of chain
        ends    teblk

#       vector block
#
#       a vector block (vcblk) is used to represent an array value which has
#       one dimension whose lower bound is one. all other arrays are
#       represented by arblks.  the number of elements can be deduced
#       from vclen.
#
        struc   vcblk
vctyp:  .long   0               #type word (vcblk)
vcidv:  .long   0               #identifier value
vclen:  .long   0               #length of vcblk in bytes
vcvls:  .long   0               #start of vector values
        ends    vcblk

.list
#---------------------  end of block386.inc -----------------------
