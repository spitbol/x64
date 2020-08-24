# copyright 1987-2012 robert b. k. dewar and mark emmer.

# copyright 2012-2020 david shields
#
# this file is part of macro spitbol.
#
#     macro spitbol is free software: you can redistribute it and/or modify
#     it under the terms of the gnu general public license as published by
#     the free software foundation, either version 2 of the license, or
#     (at your option) any later version.
#
#     macro spitbol is distributed in the hope that it will be useful,
#     but without any warranty; without even the implied warranty of
#     merchantability or fitness for a particular purpose.  see the
#     gnu general public license for more details.
#
#     you should have received a copy of the gnu general public license
#     along with macro spitbol.	 if not, see <http://www.gnu.org/licenses/>.

	.set m_char	byte	# reference to byte in memory
	.set d_char	db	# define value of byte

	.set m_word	qword
	.set d_word	dq

	.set m_real	qword	# reference to floating point value in memory
	.set d_real	dq	# define value for floating point

	.set	xl	%rsi
	.set	xr	%rdi
	.set	xt	%rsi
	.set	xs	%rsp

	.set	w0	%rax

	.set	wa	%rcx
	.set	wa_l	%cl

	.set	wb	%rbx
	.set	wb_l	%bl

	.set	wc	%rdx
	.set	wc_l	%dl

	.set	ia	%rbp

#	.set	cfp_b	8

	.set	log_cfp_b 3
	.set	log_cfp_c 3
	.set	d_real	dq
	.set	cfp_c_val	8
	.set	log_cfp_c 3
	.set	cfp_m_	9223372036854775807
#	.set	cfp_n_	64

	.set	lods_w	lodsq
	.set	lods_b	lodsb
	.set	movs_b	movsb
	.set	movs_w	movsq
	.set	stos_b	stosb
	.set	stos_w	stosq
	.set	cmps_b	cmpsb

	.set	cdq	cqo	# sign extend (64 bits)

#	flags
	.set	flag_of	0x80
	.set	flag_cf	0x01
	.set	flag_ca	0x40
