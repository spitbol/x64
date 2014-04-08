/* this is a comment */

package minimal

import (
	//	"io"
	"fmt"
	"math"

//	"unsafe"
)

const (
	r0 = iota
	r1
	r2
	wa
	wb
	wc
	xl
	xr
	xs
	ia
	ra
	cp
)
const (
	xt = xs
)
/*
const (
	atn = iota
	chp
	cos
	etx
	lnf
	sin
	sqr
	tan
)
*/
/*	operation encoded in four parts:
	_w	gives width in bits
	_m	gives mask to extract value
	operand encod
*/
const	(
	op_w	=	8
	dst_w	=	4
	src_w	=	4
	off_w	=	16
	op_m	=	1<<op_w - 1
	dst_m	=	1<<dst_w - 1
	src_m	=	1<<src_w - 1
	off_m 	=	1<<off_w - 1
	op_	=	0
	dst_	=	op_ + op_w
	src_	=	dst_ + dst_w
	off_	=	src_ + src_w
)

const (
	stackLength = 1000
)

var (
	reg      [16]uint32
	mem      [100000]uint32
	ip	uint32
	stackEnd uint32
)

func interp() {
	instn := 0
	var long1, long2 int64
	//	var int1,int2 int32
	var int1 int32
	var prcstack [32]uint32
	var inst, dst, src, off uint32
	var overflow bool
	var op uint32
	var f1, f2 float32
	var d1 float64

	ip = start

	for {
//		fmt.Println("ip",ip)
		if ip < s_aaa || ip > s_yyy {
			fmt.Println("ip out of range ", ip)
			return
		}
		inst = mem[ip]
		instn++
		if instn > 500 {
			return
		}
		ip++
		op = inst & op_m
		dst = inst >> dst_ & dst_m
		src = inst >> src_ & src_m
		off = inst >> off_ & off_m
		fmt.Printf(" %v %x %v %v %v %v\n",ip-1,inst,op,dst,src,off)
		switch op {

		case mov:
			reg[dst] = reg[src]

		case brn:
			ip = dst

		case bsw:
			if off > 0 {
				if reg[dst] >= r1 {
					ip = off
				}
			}
			ip = ip + reg[dst] + 1

		case bri:
			ip = reg[dst]

		case lei:
			reg[dst] = mem[reg[dst]-1]

		case ppm:
			ip = off
		case prc:
			prcstack[off] = ip
		case exi:
			// dst is procedure identifier  if 'n' type procedure, 0 otherwise.
			// off is exit number
			reg[r1] = off
			if dst > 0 {
				ip = prcstack[dst]
			} else {
				// pop return address from stack
				ip = mem[reg[xs]]
				reg[xs]++
			}

		case err:
			reg[wa] = reg[r1]
			ip = off
		case erb:
			reg[wa] = off
			ip = error_
		case icv:
			reg[dst]++
		case dcv:
			reg[dst]--
		case add:
			reg[dst] += reg[src]
		case sub:
			reg[dst] -= reg[src]
		case beq:
			if reg[dst] == reg[src] {
				ip = off
			}
		case bge:
			if reg[dst] >= reg[src] {
				ip = off
			}
		case bgt:
			if reg[dst] > reg[src] {
				ip = off
			}
		case bne:
			if reg[dst] != reg[src] {
				ip = off
			}
		case ble:
			if reg[dst] <= reg[src] {
				ip = off
			}
		case blt:
			if reg[dst] < reg[src] {
				ip = off
			}
		case blo:
			if reg[dst] < reg[src] {
				ip = off
			}
		case bhi:
			if reg[dst] > reg[src] {
				ip = off
			}
		case bnz:
			if reg[dst] != 0 {
				ip = off
			}
		case bze:
			if reg[dst] == 0 {
				ip = off
			}
		case lct:
			reg[dst] = reg[src]
		case bct:
			fmt.Println("bct",dst,off)
			reg[dst]--
			if reg[dst] > 0 {
				ip = off
			}
		case aov:
			reg[dst] += reg[src]
			if uint64(reg[dst])+uint64(reg[src]) > math.MaxUint32 {
				ip = off
			}
		case bev:
			if reg[dst]&1 == 0 {
				ip = off
			}
		case bod:
			if reg[dst]&1 != 0 {
				ip = off
			}
		case lcp:
			reg[cp] = reg[dst]
		case scp:
			reg[dst] = reg[cp]
		case lcw:
			reg[dst] = mem[reg[cp]]
		case icp:
			reg[cp]++
		case ldi:
			//		ia = int32(reg[dst])
			reg[ia] = reg[dst]
		case adi:
			long1, long2 = int64(reg[ia]), int64(reg[dst])
			long1 = long1 + long2
			if long1 > math.MaxInt32 || long1 < math.MinInt32 {
				overflow = true
			} else {
				overflow = false
				reg[ia] = uint32(long1)
			}
		case mli:
			long1, long2 = int64(reg[ia]), int64(reg[dst])
			long1 = long1 * long2
			if long1 > math.MaxInt32 || long1 < math.MinInt32 {
				overflow = true
			} else {
				overflow = false
				reg[ia] = uint32(long1)
			}

		case sbi:
			long1, long2 = int64(reg[ia]), int64(reg[dst])
			long1 = long1 - long2
			if long1 > math.MaxInt32 || long1 < math.MinInt32 {
				overflow = true
			} else {
				overflow = false
				reg[ia] = uint32(long1)
			}
		case dvi:
			if reg[src] == 0 {
				overflow = true
			} else {
				overflow = false
				reg[ia] /= reg[src]
			}
		case rmi:
			if reg[src] == 0 {
				overflow = true
			} else {
				overflow = false
				reg[ia] %= reg[src]
			}
		case sti:
			reg[dst] = reg[ia]
		case ngi:
			if int32(reg[ia]) == math.MinInt32 {
				overflow = true
			} else {
				overflow = false
				reg[ia] = -reg[ia]
			}
		case ino:
			if !overflow {
				ip = off
			}
		case iov:
			if overflow {
				ip = off
			}
		case ieq:
			if reg[ia] == 0 {
				ip = off
			}
		case ige:
			if reg[ia] == 0 {
				ip = off
			}
		case igt:
			if int32(reg[ia]) > 0 {
				ip = off
			}
		case ile:
			if int32(reg[ia]) <= 0 {
				ip = off
			}
		case ilt:
			if int32(reg[ia]) < 0 {
				ip = off
			}
		case ine:
			if reg[ia] != 0 {
				ip = off
			}
		case ldr:
			reg[ra] = reg[dst]
		case str:
			reg[dst] = reg[ra]
		case adr:
			f1 = math.Float32frombits(reg[dst])
			f2 = math.Float32frombits(reg[ra])
			reg[ra] = math.Float32bits(f1 + f2)
		case sbr:
			f1 = math.Float32frombits(reg[dst])
			f2 = math.Float32frombits(reg[ra])
			reg[ra] = math.Float32bits(f1 - f2)
		case mlr:
			f1 = math.Float32frombits(reg[dst])
			f2 = math.Float32frombits(reg[ra])
			reg[ra] = math.Float32bits(f1 * f2)
		case dvr:
			f1 = math.Float32frombits(reg[ra])
			f2 = math.Float32frombits(reg[src])
			reg[ra] = math.Float32bits(f1 / f2)
		case rov:
			d1 = float64(math.Float32frombits(reg[ra]))
			if math.IsNaN(d1) || math.IsInf(d1, 0) {
				ip = off
			}
		case rno:
			d1 = float64(math.Float32frombits(reg[ra]))
			if !(math.IsNaN(d1) || math.IsInf(d1, 0)) {
				ip = off
			}
		case ngr:
			f1 = math.Float32frombits(reg[ra])
			reg[ra] = math.Float32bits(-f1)
		case req:
			if math.Float32frombits(reg[ra]) == 0.0 {
				ip = off
			}
		case rge:
			if math.Float32frombits(reg[ra]) >= 0.0 {
				ip = off
			}
		case rgt:
			if math.Float32frombits(reg[ra]) < 0.0 {
				ip = off
			}
		case rle:
			if math.Float32frombits(reg[ra]) <= 0.0 {
				ip = off
			}
		case rlt:
			if math.Float32frombits(reg[ra]) < 0.0 {
				ip = off
			}
		case rne:
			if math.Float32frombits(reg[ra]) != 0.0 {
				ip = off
			}
		case plc:
			reg[dst] = reg[dst] + reg[src] + 2
		case psc:
			reg[dst] = reg[dst] + reg[src] + 2
		case cne:
			// TODO
		case cmc:
			// TODO
		case trc:
		case flc:
		case anb:
			reg[dst] &= reg[src]
		case orb:
			reg[dst] |= reg[src]
		case xob:
			reg[dst] ^= reg[src]
		case rsh:
			reg[dst] = reg[dst] >> reg[src]
		case lsh:
			reg[dst] = reg[dst] << reg[src]
		case nzb:
			if reg[dst] != 0 {
				ip = off
			}
		case zrb:
			if reg[dst] == 0 {
				ip = off
			}
		case mfi:
			if off != 0 && int32(reg[ia]) < 0 {
				ip = off
			} else {
				reg[dst] = reg[ia]
			}
		case itr:
			reg[ia] = math.Float32bits(float32(int32(reg[ia])))
		case rti:
			long1 = int64(math.Float32frombits(reg[ra]))
			if long1 > math.MaxInt32 || long1 < math.MinInt32 {
				ip = off
			}
			reg[ia] = uint32(long1)
		case cvm:
			long1 = int64(reg[ia])*10 - (int64(reg[wb]) - 0x30)
			if long1 > math.MaxInt32 || long1 < math.MinInt32 {
				ip = off
			}
			reg[ia] = uint32(long1)
		case cvd:
			int1 = int32(reg[ia])
			reg[ia] = uint32(int1 / 10)
			reg[wa] = uint32(-(int1 % 10) + 0x30)
		case mvc, mvw:
			for i := 0; i < int(reg[wa]); i++ {
				mem[reg[xr]+uint32(i)] = mem[reg[xl]+uint32(i)]
			}
			reg[xl] += reg[wa]
			reg[xr] += reg[wa]
		case mcb, mwb:
			for i := 0; i < int(reg[wa]); i++ {
				mem[reg[xr]-1-uint32(i)] = mem[reg[xl]-1-uint32(i)]
			}
			reg[xl] -= reg[wa]
			reg[xr] -= reg[wa]
		case chk:
			if uint32(reg[xs]) < stackEnd+100 {
				ip = sec06 // branch to stack overflow section
			}
		case move:
			reg[dst] = reg[src]
		case call:
			reg[xs]--
			reg[xs] = ip
			ip = off
		case sys:
			reg[r1] = syscall(off)
			if reg[r1] == 999 {
				break; // end execution
			}
		case decv:
			int1 = int32(reg[ia])
			reg[ia] = uint32(reg[ia] / 10)
			int1 = int1 % 10
			reg[ia] = uint32(-int1 + 0x30)
		case incv:
			reg[dst]++
		case jsrerr:
		case load:
			reg[dst] = mem[reg[src]+off]
		case loadcfp:
			reg[dst] = 2147483647
		case loadi:
			reg[dst] = off
		case nop:
			// nop means 'no operation' so there is nothing to do here
		case pop:
			mem[reg[src]+off] = mem[reg[dst]]
			reg[src]++
		case popr:
			reg[dst] = mem[reg[src]]
			reg[src]++
		case push:
			reg[dst]--
			mem[reg[dst]+off] = mem[reg[src]+off]
		case pushi:
			reg[dst]--
			mem[reg[dst]] = off
		case pushr:
			reg[dst]--
			mem[reg[dst]] = reg[src]
		case realop:
		case store:
			mem[reg[src]+off] = reg[dst]
		}
	}
}

// startup
// xs = one past stack base (subtract 1 to get first stack entry)
// xr = address first word data area
// xl = address last word data area
// wa=initial stack pointer
// wb=wc=ia=ra=cp=0

func Startup() int {
	//	var memMinimum int = len(program) + 3 * (maxreclen + 2) + stackLength
	for i := 0; i < len(program); i++ {
		mem[i] = program[i]
//		fmt.Printf("mem %v %x\n",i,mem[i])
	}
	scblk0 = 20000
	scblk1 = 22000
	scblk2 = 24000
	reg[xs] = 25000
	reg[xr] = 30000
	reg[xl] = 50000
	reg[wa] = start
	reg[wb] = 0
	reg[wc] = 0
	reg[wa] = 25000 - 1
	interp()
	/*
	last := len(program)
	scblk0 = last
	last += maxreclen + 2
	scblk1 = last
	last += maxreclen + 2
	scblk2 = last
	last += maxreclen + 2
	// allocate stack
	stackEnd = uint32(last)
	last += stackLength
	stackStart := uint32(last)
	reg[xs] = stackStart
	memStart := last + 1
	//memEnd := memStart + 1
	// allocate work areas
*/
	return 0
}
