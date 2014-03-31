package minimal

import	(
	"math"
//	"unsafe"
)

func fun() {
	var long1,long2 int64
//	var int1,int2 int32
	var prcstack [32]uint32
	var reg [16]uint32
	var mem [16]uint32
	var inst,dst,src,off uint32
	var overflow bool
	var op uint32
	var f1,f2 float32
	var d1 float64

	op = inst & op_m
	_ = op
	dst = inst >> dst_ & dst_m
	src = inst >> src_ & src_m
	off = inst >> off_ & off_m
	i := 1
	switch i {

	case mov:
		reg[dst] = reg[src]

	case brn:
		reg[ip] = dst

	case bsw:
		if off > 0 {
			if reg[dst] >= r1 {
				reg[ip] = off
			}
		}
		reg[ip] = reg[ip] + reg[dst] + 1

	case bri:
		reg[ip] = reg[dst]

	case lei:
		reg[dst] = mem[reg[dst] - 1]

	case ppm:
		reg[ip] = off
	case prc:
		prcstack[off] = reg[ip]
	case exi:
	// dst is procedure identifier  if 'n' type procedure, 0 otherwise. 
	// off is exit number
		reg[r1] = off
		if dst>0 {
			reg[ip] = prcstack[dst]
		} else {
			// pop return address from stack
			reg[ip] = mem[reg[xs]]
			reg[xs]++
		}
		
	case err:
		reg[wa] = reg[r1]
		reg[ip] = off
	case erb:
		reg[wa] = off
		reg[ip] = error_
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
			reg[ip] = off
		}
	case bge:
		if reg[dst] >= reg[src] {
			reg[ip] = off
		}
	case bgt:
		if reg[dst] > reg[src] {
			reg[ip] = off
		}
	case bne:
		if reg[dst] != reg[src] {
			reg[ip] = off
		}
	case ble:
		if reg[dst] <= reg[src] {
			reg[ip] = off
		}
	case blt:
		if reg[dst] < reg[src] {
			reg[ip] = off
		}
	case blo:
		if reg[dst] < reg[src] {
			reg[ip] = off
		}
	case bhi:
		if reg[dst] > reg[src] {
			reg[ip] = off
		}
	case bnz:
		if reg[dst] != 0 {
			reg[ip] = off
		}
	case bze:
		if reg[dst] == 0 {
			reg[ip] = off
		}
	case lct:
		reg[dst] = reg[src]
	case bct:
		reg[dst]--
		if reg[dst] > 0 {
			reg[ip] = off
		}
	case aov:
		reg[dst] += reg[src]
		if uint64(reg[dst]) + uint64(reg[src]) > math.MaxUint32 {
			reg[ip] = off
		}
	case bev:
		if reg[dst] & 1 == 0{
			reg[ip] = off
		}
	case bod:
		if reg[dst] & 1 != 0 {
			reg[ip] = off
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
		long1,long2 = int64(reg[ia]),int64(reg[dst])
		long1 = long1 + long2
		if long1 > math.MaxInt32 || long1 < math.MinInt32 {
			overflow = true
		} else {
			overflow = false
			reg[ia] = uint32(long1)
		}
	case mli:
		long1,long2 = int64(reg[ia]),int64(reg[dst])
		long1 = long1 * long2
		if long1 > math.MaxInt32 || long1 < math.MinInt32 {
			overflow = true
		} else {
			overflow = false
			reg[ia] = uint32(long1)
		}

	case sbi:
		long1,long2 = int64(reg[ia]),int64(reg[dst])
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
			reg[ia] = - reg[ia]
		}
	case ino:
		if !overflow {
			reg[ip] = off
		}
	case iov:
		if overflow {
			reg[ip] = off
		}
	case ieq:
		if reg[ia] == 0 {
			reg[ip] = off
		}
	case ige:
		if reg[ia] == 0 {
			reg[ip] = off
		}
	case igt:
		if int32(reg[ia]) > 0 {
			reg[ip] = off
		}
	case ile:
		if int32(reg[ia]) <= 0 {
			reg[ip] = off
		}
	case ilt:
		if int32(reg[ia]) < 0 {
			reg[ip] = off
		}
	case ine:
		if reg[ia] != 0 {
			reg[ip] = off
		}
	case ldr:
		reg[ra] = reg[dst]
	case str:
		reg[dst] = reg[ra]
	case adr:
		f1 =  math.Float32frombits(reg[dst])
		f2 =  math.Float32frombits(reg[ra])
		reg[ra] = math.Float32bits(f1 + f2)
	case sbr:
		f1 =  math.Float32frombits(reg[dst])
		f2 =  math.Float32frombits(reg[ra])
		reg[ra] = math.Float32bits(f1 - f2)
	case mlr:
		f1 =  math.Float32frombits(reg[dst])
		f2 =  math.Float32frombits(reg[ra])
		reg[ra] = math.Float32bits(f1 * f2)
	case dvr:
		f1 =  math.Float32frombits(reg[ra])
		f2 =  math.Float32frombits(reg[src])
		reg[ra] = math.Float32bits(f1 / f2)
	case rov:
		d1 = float64(math.Float32frombits(reg[ra]))
		if math.IsNaN(d1) || math.IsInf(d1,0) {
			reg[ip] = off
		}
	case rno:
		d1 = float64(math.Float32frombits(reg[ra]))
		if ! (math.IsNaN(d1) || math.IsInf(d1,0)) {
			reg[ip] = off
		}
	case ngr:
		f1 =  math.Float32frombits(reg[ra])
		reg[ra] = math.Float32bits(-f1)
	case req:
		if math.Float32frombits(reg[ra]) == 0.0 {
			reg[ip] = off	
		}
	case rge:
		if math.Float32frombits(reg[ra]) >= 0.0 {
			reg[ip] = off	
		}
	case rgt:
		if math.Float32frombits(reg[ra]) < 0.0 {
			reg[ip] = off	
		}
	case rle:
		if math.Float32frombits(reg[ra]) <= 0.0 {
			reg[ip] = off	
		}
	case rlt:
		if math.Float32frombits(reg[ra]) < 0.0 {
			reg[ip] = off	
		}
	case rne:
		if math.Float32frombits(reg[ra]) != 0.0 {
			reg[ip] = off	
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
			reg[ip] = off
		}
	case zrb:
		if reg[dst] == 0 {
			reg[ip] = off
		}
	case mfi:
		// TODO
	case itr:
	case rti:
//HERE
	case cvm:
	case mvc:
	case mvw:
	case mwb:
	case chk:

	case move:
		reg[dst] = reg[src]
	case call:
	case callos:
	case cvd:
	case decv:
		reg[dst]--
	case incv:
		reg[dst]++
	case jsrerr:
	case load:
		reg[dst] = mem[reg[src] + off]
	case loadcfp:
		reg[dst] = 2147483647
	case loadi:
		reg[dst] = off
	case nop:
		// nop means 'no operation' so there is nothing to do here
	case pop:
		mem[reg[src] + off] = mem[reg[dst]]
		reg[src]++
	case popr:
		reg[dst] = mem[reg[src]]
		reg[src]++
	case push:
		reg[dst]--
		mem[reg[dst] + off] = mem[reg[src] + off]
	case pushi:
		reg[dst]--
		mem[reg[dst]] = off
	case pushr:
		reg[dst]--
		mem[reg[dst]] = reg[src]
	case realop:
	case store:
		mem[reg[src] + off] = reg[dst]
	}
}

