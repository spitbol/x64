package minimal

import	(
	"math"
)

func fun() {
	var long1,long2 int64
	var int1,int2 int32
	overflow := false
	var prcstack [32]uint32
	var inst,op,dst,src,off uint32
	op = inst & op_m
	dst = inst >> dst_ & dst_m
	src = inst >> src_ & src_m
	off = inst >> off_ & off_m
	i := 1
	switch i {

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
		reg[dst] = mem[reg[dst] - 1]

	case ppm:
		ip = off
	case prc:
		prcstack[off] = ip
	case exi:
	// dst is procedure identifier  if 'n' type procedure, 0 otherwise. 
	// off is exit number
		reg[r1] = off
		if dst>0 {
			ip = prcstack[dst]
		} else {
			// pop return address from stack
			ip = mem[reg[xs]]
			xs++
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
		reg[dst]--
		if reg[dst] > 0 {
			ip = off
		}
	case aov:
		// TODO
	case bev:
		if reg[dst] & 1 == 0{
			ip = off
		}
	case bod:
		if reg[dst] & 1 != 0 {
			ip = off
		}
	case lcp:
		reg[CP] = reg[dst]
	case scp:
		reg[dst] = reg[CP]
	case lcw:
		reg[dst] = mem[reg[CP]]
	case icp:
		reg[CP]++
	case ldi:
		reg[ia] = int32(reg[dst])
	case adi:
		long1,long2 = int64(reg[ia]),int64(reg[dst])
		long1 = long1 + long2
		if long1 > math.MaxInt32 || long1 < math.MinInt32 {
			overlow = true
		} else {
			overflow = false
			reg[ia] += reg[src]
		}
	case mli:
		long1,long2 = int64(reg[ia]),int64(reg[dst])
		long1 = long1 * long2
		if long1 > math.MaxInt32 || long1 < math.MinInt32 {
			overlow = true
		} else {
			overflow = false
			reg[ia] *= reg[src]
		}

	case sbi:
		long1,long2 = int64(reg[ia]),int64(reg[dst])
		long1 = long1 - long2
		if long1 > math.MaxInt32 || long1 < math.MinInt32 {
			overlow = true
		} else {
			overflow = false
			reg[ia] -= reg[src]
		}
	case dvi:
		if reg[src] == 0 {
			overflow = true
		} else {
			overlow = false
			reg[ia] /= reg[src]
		}
	case rmi:
		if reg[src] == 0 {
			overflow = true
		} else {
			overlow = false
			reg[ia] %= reg[src]
		}
	case sti:
			reg[dst] = uint32(reg[ia])
	case ngi:
		if reg[ia] == math.MinInt32 {
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
			ip = off
		}
	case igt:
		if reg[ia] > 0 {
			ip = off
		}
	case ile:
		if reg[ia] <= 0 {
			ip = off
		}
	case ilt:
		if reg[ia] < 0 {
			ip = off
		}
	case ine:
		if reg[ia] != 0 {
			ip = off
		}
	case ldr:
//		reg[ra] = (float32) reg[dst]
	case mlr:
	case dvr:
	case rov:
	case rno:
	case ngr:
	case req:
	case rge:
	case rgt:
	case rle:
	case rlt:
	case rne:
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
	case adr:
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
	case sbr:
	case store:
		mem[reg[src] + off] = reg[dst]
	}
}

const (
	aaa = iota
	add
	adi
	adr
	anb
	aov
	bct
	beq
	bev
	bge
	bgt
	bhi
	ble
	blo
	blt
	bne
	bnz
	bod
	bri
	brn
	bsw
	bze
	call
	callos
	chk
	cmc
	cne
	ctb
	ctw
	cvd
	cvm
	dcv
	decv
	dvi
	dvr
	enp
	ent
	erb
	err
	exi
	flc
	icp
	icv
	ieq
	ige
	igt
	ile
	ilt
	incv
	ine
	ino
	iov
	itr
	jsrerr
	lcp
	lct
	lcw
	ldi
	ldr
	lei
	load
	loadcfp
	loadi
	lsh
	mfi
	mli
	mlr
	mov
	move
	mvc
	mvw
	mwb
	ngi
	ngr
	nop
	nzb
	orb
	plc
	pop
	popr
	ppm
	prc
	psc
	push
	pushi
	pushr
	realop
	req
	rge
	rgt
	rle
	rlt
	rmi
	rne
	rno
	rov
	rsh
	rti
	rtn
	sbi
	sbr
	scp
	ssl
	sss
	store
	sub
	trc
	xob
	zrb
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
const (
	dst = 1
	src = 2
	off = 3
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
