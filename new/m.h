	%define M_CHAR	BYTE	; reference to byte in memory
	%define D_CHAR	DB	; define value of byte
	%define M_REAL	QWORD	; reference to floating point value in memory
	%define D_REAL	DQ	; define value for floating point
			
%ifdef	m32
	%define	XL	ESI
	%define	XT	ESI
	%define XR	EDI
	%define XS	ESP
	%define W0	EAX
	%define W1	EBP
	%define WA	ECX
	%define WA_L    CL
	%define WB	EBX
	%define WB_L  	BL
	%define WC	EDX
	%define WC_L  	DL
;	%define IA	EDX
	%define IA	EBP
	%define M_WORD	DWORD	; reference to word in memory
	%define D_WORD	DD	; define value for memory word
;	%define	CFP_B	4
	%define LOG_CFP_B 2
	%define CFP_C_VAL	4
	%define LOG_CFP_C 2
	%define CFP_M_	2147483647
;	%define	CFP_N_	32

	%define	LODS_B	lodsb
	%define	LODS_W	lodsd
	%define MOVS_B	movsb
	%define MOVS_W	movsd
	%define	STOS_B	stosb
	%define	STOS_W	stosd
	%define	CMPS_B	cmpsb

	%define	CDQ	cdq	; sign extend (32 bits)
%else
	%define	XL	RSI
	%define	XT	RSI
	%define	XR	RDI
	%define	W0	RAX
	%define W1	RBP
	%define	WA	RCX
	%define WA_L	CL
	%define	WB	RBX
	%define WB_L    BL
	%define	WC	RDX
	%define WC_L    DL
	%define	XS	RSP
	%define	W0_L	AL
;	%define	IA	RDX
	%define	IA	RBP
	%define M_WORD  QWORD
	%define D_WORD	DQ
;	%define	CFP_B	8
	%define LOG_CFP_B 3
	%define LOG_CFP_C 3
	%define D_REAL	DQ
	%define CFP_C_VAL	8
	%define LOG_CFP_C 3
	%define CFP_M_	9223372036854775807
;	%define	CFP_N_	64

	%define	LODS_W	lodsq
	%define	LODS_B	lodsb
	%define MOVS_B	movsb
	%define MOVS_W	movsq
	%define STOS_B	stosb
	%define	STOS_W	stosq
	%define	CMPS_B	cmpsb

	%define	CDQ	cqo	; sign extend (64 bits)

%endif	

	%define	R_WORD	DQ	; reference to real

;	Flags
	%define	FLAG_OF	0x80
	%define	FLAG_CF	0x01
	%define	FLAG_CA	0x40
