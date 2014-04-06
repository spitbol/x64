package minimal

import (
	"bufio"
	//	"io"
	"os"
	"time"
)

const (
	maxreclen = 1024
)

type fcblk struct { // file control block
	file    *os.File
	output  bool
	name    string
	open    bool
	illegal bool
	reclen  int
	reader  *bufio.Reader
	writer  *bufio.Writer
}

// scblk1 and scblk2 are memory indices of work areas used to return strings
// to the interpreter in the form of an scblk.

var (
	scblk0  int // null string
	scblk1  int
	scblk2  int
	fcblkid int
	fcblks  map[int]*fcblk
	fcbn    int
)

func sysax() uint32 {
	// Will need to mimic the swcoup function if want to use spitbol as unix filter
	return 0
}

func sysbs() uint32 {
	panic("sysbs not implemented.")
}

func sysbx() uint32 {
	return 0
	panic("sysbx not implemented.")
}

func syscm() uint32 {
	// syscm needed only if .ccmc conditional option selected
	panic("syscm not implemented.")
}

func sysdc() uint32 {
	// SPITBOL now open open source, so no need to check expiry of trial version.
	return 0
}

func sysdm() uint32 {
	// No core dump for now.
	return 0
}

func sysdt() uint32 {
	t := time.Now()
	s := t.Format(time.RFC822)
	for i := 0; i < len(s); i++ {
		mem[scblk1+2+i] = uint32(s[i])
	}
	mem[scblk1+1] = uint32(len(s))
	reg[xr] = uint32(scblk1)
	return 0
}

func sysea() uint32 {
	// no action for now
	return 0
}

func sysef() uint32 {
	// sysef is eject file. sysen is endfile
	return 0
}

func sysej() uint32 {
	// close open files
	for _, fcb := range fcblks {
		if fcb.open {
			fcb.file.Close()
			fcb.open = false
		}
	}
	// need to find way to terminate program
	return 0
}

func setscblk(b int, str string) {
	for i := 0; i < len(str); i++ {
		mem[b+2+i] = uint32(str[i])
	}
	mem[b+1] = uint32(len(str))
}

func sysem() uint32 {
	if int(reg[wa]) > len(error_messages) { // return null string if error number out of range
		reg[xr] = uint32(scblk0)
	} else {
		message := error_messages[reg[xr]]
		setscblk(scblk1, message)
		reg[xr] = uint32(scblk1)
	}
	return 0
}

func sysen() uint32 {
	fcb := fcblks[int(reg[wa])]
	if fcb == nil {
		return 1
	}
	if !fcb.open {
		return 3
	}
	fcb.open = false
	if fcb.file.Close() != nil {
		return 2
	}
	delete(fcblks, int(reg[wa]))
	return 0
}

func sysep() uint32 {
	os.Stdout.WriteString("\n")
	return 0
}

func sysex() uint32 {
	// call to external function not supported
	return 1
}

func sysfc() uint32 {
	/* cases

	   1. both null
	   case of both null should not occur, so return error 1 if it does.

	   2. filearg1 null, filearg3 non-null.
	   No action needed.


	   3: filearg1 non-null, filearg2 null.
	   We are just adding new variable assocation. Must check that same mode, returning error
	   if not. Must have been provided a fcb, and return it.

	   4. both non-null
	   See if channel in use, returning error if so. Then initialize channel.
	*/
	//var scblk1,scblk2 []uint32

	fcbn := int(reg[wa])
	reg[wa] = 0
	// pop any stacked arguments, since we ignore them (for now).
	reg[xs] += reg[wc]

	// if second argument is null, then call is just to check third argument in
	// case it is needed. We don't need it for this implementation.
	scblk1 := mem[reg[xl]:]
	scblk2 := mem[reg[xl]:]
	len1 := int(scblk1[1])
	len2 := int(scblk2[1])
	switch {

	case len1 == 0 && len2 == 0:
		return 1

	case len1 == 0 && len2 > 0:
		reg[wa] = 0
		reg[xl] = 0
		reg[wc] = 0
		return 0

	case len1 > 0 && len2 == 0:
		// error if no fcb available
		if fcbn == 0 {
			return 1
		}
		fcb := fcblks[fcbn]
		if fcb == nil {
			return 1
		}
		if fcb.output && reg[wb] == 0 || !fcb.output && reg[wb] != 0 {
			fcb.illegal = true // sysio call will signal error
		}
		return 0

	case len1 > 0 && len2 > 0:

		fcb := new(fcblk)
		fcb.output = reg[wb] > 0
		fcb.name = goString(scblk2)
		fcblkid++
		fcblks[fcblkid] = fcb
		reg[xl] = uint32(fcblkid) // return private fcblk index
		reg[wa] = 0
		reg[wc] = 0
		return 0
	}
	return 0
}

func sysgc() uint32 {
	// no action needed
	return 0
}

func syshs() uint32 {
	return 1
}

func sysid() uint32 {
	// return null system id for now
	reg[xr] = uint32(scblk0)
	reg[xl] = uint32(scblk0)
	return 0
}

func sysif() uint32 {
	// TODO: support include files.
	return 1
}

func sysil() uint32 {
	reg[wa] = maxreclen
	reg[wc] = 1 // text file
	return 0
}

func sysin() uint32 {
	panic("sysin not implemented.")
}

func sysio() uint32 {
	var err error
	var file *os.File
	if reg[wa] == 0 {
		return 1
	}
	fcb := fcblks[int(reg[wa])]
	if fcb == nil {
		return 1
	}
	if !fcb.open {
		if fcb.output {
			file, err = os.Create(fcb.name)
			if err != nil {
				return 1
			}
			fcb.reader = bufio.NewReader(file)
		} else {
			file, err = os.Open(fcb.name)
			if err != nil {
				return 1
			}
			//			fcb.writer = bufio.NewWriter(file)
		}
		fcb.file = file
	}
	reg[xl] = reg[wa]
	reg[wc] = maxreclen
	if fcb.file == nil { // fail if unable to create/open file
		return 1
	}
	return 0
}

func sysld() uint32 {
	return 1
}

func sysmm() uint32 {
	// no memory expansion for now
	reg[xr] = 0
	return 0
}

func sysmx() uint32 {
	// return default
	reg[wa] = 0
	return 0
}

func sysou() uint32 {
	panic("sysou not implemented.")
}

func syspi() uint32 {
	panic("syspi not implemented.")
}

func syspl() uint32 {
	return 1
}

func syspp() uint32 {
	panic("syspp not implemented.")
}

func syspr() uint32 {
	var fcb *fcblk
	scblk1 = int(reg[xr])

	l := int(reg[wa])
	for i := 0; i < l; i++ {
		_, err := fcb.writer.WriteRune(rune(mem[scblk1+2+i]))
		if err != nil {
			return 1
		}
	}
	_, err := fcb.writer.WriteString("\n")
	if err != nil {
		return 1
	}
	fcb.writer.Flush()
	return 0
	panic("syspr not implemented.")
}

func sysrd() uint32 {
	// read standard input
	panic("sysrd not implemented.")
}

func sysri() uint32 {
	panic("sysri not implemented.")
}

func sysrw() uint32 {
	panic("sysrw not implemented.")
}

func sysst() uint32 {
	panic("sysst not implemented.")
}

func systm() uint32 {
	panic("systm not implemented.")
}

func systt() uint32 {
	// No trace for now
	return 0
	panic("systt not implemented.")
}

func sysul() uint32 {
	return 1
}

func sysxi() uint32 {
	return 1
}

func syscall(ea uint32) uint32 {

	switch ea {

	case sysax_:
		return sysax()

	case sysbs_:
		return sysbs()

	case sysbx_:
		return sysbx()

	case syscm_:
		return syscm()

	case sysdc_:
		return sysdc()

	case sysdm_:
		return sysdm()

	case sysdt_:
		return sysdt()

	case sysea_:
		return sysea()

	case sysef_:
		return sysef()

	case sysej_:
		return sysej()

	case sysem_:
		return sysem()

	case sysen_:
		return sysen()

	case sysep_:
		return sysep()

	case sysex_:
		return sysex()

	case sysfc_:
		return sysfc()

	case sysgc_:
		return sysgc()

	case syshs_:
		return syshs()

	case sysid_:
		return sysid()

	case sysif_:
		return sysif()

	case sysil_:
		return sysil()

	case sysin_:
		return sysin()

	case sysio_:
		return sysio()

	case sysld_:
		return sysld()

	case sysmm_:
		return sysmm()

	case sysmx_:
		return sysmx()

	case sysou_:
		return sysou()

	case syspi_:
		return syspi()

	case syspl_:
		return syspl()

	case syspp_:
		return syspp()

	case syspr_:
		return syspr()

	case sysrd_:
		return sysrd()

	case sysri_:
		return sysri()

	case sysrw_:
		return sysrw()

	case sysst_:
		return sysst()

	case systm_:
		return systm()

	case systt_:
		return systt()

	case sysul_:
		return sysul()

	case sysxi_:
		return sysxi()

	}
	panic("undefined system call")
}

func init() {
	var fcb *fcblk
	fcb = new(fcblk)
	fcb.name = "dev/stdin"
	fcb.file = os.Stdin
	fcblks[len(fcblks)+1] = fcb
	fcb = new(fcblk)
	fcb.name = "dev/stdout"
	fcb.file = os.Stdout
	fcblks[len(fcblks)+1] = fcb
	fcb = new(fcblk)
	fcb.name = "dev/stderr"
	fcb.file = os.Stderr
	fcblks[len(fcblks)+1] = fcb
}

func goString(scblk []uint32) string {
	if scblk[1] == 0 {
		return ""
	}
	n := int(scblk[1])
	b := make([]byte, n)
	for i := 0; i < n; i++ {
		b[i] = byte(scblk[2+i])
	}
	return string(b)
}

// return byte array in form of spitbol scblk
func minString(b []byte) []uint32 {
	var s []uint32
	s = make([]uint32, len(b)+2)
	s[1] = uint32(len(b))
	for i := 1; i < len(b); i++ {
		s[i+1] = uint32(b[i])
	}
	return s
}
func check(e error) {
	if e != nil {
		panic(e)
	}
}
