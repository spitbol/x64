package	minimal

//go
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
	ip
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
	op_w	=	7
	dst_w	=	4
	src_w	=	4
	off_w	=	17
	op_m	=	1<<op_w - 1
	dst_m	=	1<<dst_w - 1
	src_m	=	1<<src_w - 1
	off_m 	=	1<<off_w - 1
	op_	=	0
	dst_	=	op_ + op_w
	src_	=	dst_ + dst_w
	off_	=	src_ + src_w
)

