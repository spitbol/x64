#	unix and osx use differnt conventions for defining a macro. This one is for unix.
	.macro	syscall	
       	popq	%rax			# save minimal return address
       	movq	%rax,reg_pc(%rip)	
       	call	syscall_init		# save registers
       	movq	%rsp,compsp(%rip)	# save minimal stack
       	movq	osisp(%rip),%rsp	# switch to osint stack
	call	$0			# call target procedure
       	call	syscall_exit		# save result, restore registers, switch back to minimal stack, and return
	.endm
