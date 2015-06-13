#	unix and osx use differnt conventions for defining a macro. This one is for unix.
	.macro	syscall	cproc
       	popq	%rax			# save minimal return address
       	movq	%rax,reg_pc(%rip)	
       	call	syscall_init		# save registers
       	movq	%rsp,compsp(%rip)	# save minimal stack
       	movq	osisp(%rip),%rsp	# switch to osint stack
	call	\cproc			# call target procedure
       	call	syscall_exit		# save result, restore registers, switch back to minimal stack, and return
	.endm

	.macro	syscallf	cproc
       	popq	%rax			# save minimal return address
       	movq	%rax,reg_pc(%rip)	
       	call	syscallf_init		# save registers
       	movq	%rsp,compsp(%rip)	# save minimal stack
       	movq	osisp(%rip),%rsp	# switch to osint stack
	pushfq				# save flag register	
	movq	(%rsp),%rax
	movq	%rax,trc_fl(%rip)
	popq	%rax
	call	\cproc			# call target procedure
	movq	trc_fl(%rip),%rax	# restore flag register
	pushq	%rax
	popfq				
       	call	syscallf_exit		# save result, restore registers, switch back to minimal stack, and return
	.endm

