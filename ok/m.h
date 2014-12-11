	%define M_CHAR	BYTE	; reference to byte in memory
	%define D_CHAR	DB	; define value of byte
	%define M_REAL	QWORD	; reference to floating point value in memory
	%define D_REAL	DQ	; define value for floating point
			
%ifdef	m32
	%define CP	EBP
	%define	XL	ESI
	%define	XT	ESI
	%define XR	EDI
	%define XS	ESP
	%define W0	EAX
	%define WA	ECX
	%define WA_L    CL
	%define WB	EBX
	%define WB_L  	BL
	%define WC	EDX
	%define WC_L  	DL
	%define IA	EDX
	%define M_WORD	DWORD	; reference to word in memory
	%define D_WORD	DD	; define value for memory word
	%define LOG_CFP_B 2
	%define CFP_C_VAL	4
	%define LOG_CFP_C 2
%else
	%define CP	RBP
	%define CP	RBP
	%define	XL	RSI
	%define	XT	RSI
	%define	XR	RDI
	%define	W0	RAX
	%define	WA	RCX
	%define WA_L	CL
	%define	WB	RBX
	%define WB_L    BL
	%define	WC	RDX
	%define WC_L    DL
	%define	XS	RSP
	%define	W0_L	AL
	%define	IA	RDX
	%define M_WORD  QWORD
	%define D_WORD	DQ
	%define LOG_CFP_B 3
	%define LOG_CFP_C 3
	%define D_REAL	DQ
	%define CFP_C_VAL	8
	%define LOG_CFP_C 3
%endif	
