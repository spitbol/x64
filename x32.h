	%define CP	EBP
	%define	XL	ESI
	%define	XT	ESI
	%define XR	EDI
	%define XS	ESP
	%define WA	ECX
	%define WA_L     CL
	%define WB	EBX
	%define WB_L  	 BL
	%define WC	EDX
	%define WC_L  	 DL
	%define IA	EDX
	%define W0	EAX
	%define M_WORD	DWORD
	%define R_WORD	QWORD
	%define D_WORD	DD
	%define D_REAL	DQ
	%define LOG_CFP_B 2
%if	CHARBITS == 32
	%define	D_CHAR	DD
	%define CFP_C_VAL	1
	%define LOG_CFP_C 0
%else
	%define D_CHAR	DB
	%define CFP_C_VAL	4
	%define LOG_CFP_C 2
%endif

