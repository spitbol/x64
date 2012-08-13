# COMPRESSED SPITBOL ERROR MESSAGES 08/12/12 18:36:26
#
	.sbttl	"errors"
	.arch	pentium
	.include	"systype.ah"

	DSeg_

	pubdef	errors,.byte,0

#    1  "Addition left operand is not numeric"
	.byte	166
	.byte	31
	.byte	0

#    2  "Addition right operand is not numeric"
	.byte	166
	.byte	185
	.byte	0

#    3  "Addition caused integer overflow"
	.byte	166
	.byte	18
	.byte	0

#    4  "Affirmation operand is not numeric"
	.ascii	"Affirmation "
	.byte	3
	.byte	8
	.byte	0

#    5  "Alternation right operand is not pattern"
	.byte	229
	.byte	21
	.byte	3
	.byte	28
	.byte	0

#    6  "Alternation left operand is not pattern"
	.byte	229
	.ascii	"left "
	.byte	3
	.byte	28
	.byte	0

#    7  "Compilation error encountered during execution"
	.ascii	"Compilation "
	.byte	150
	.ascii	" encountered "
	.byte	225
	.ascii	"execution"
	.byte	0

#    8  "Concatenation left operand is not a string or pattern"
	.byte	206
	.ascii	"left "
	.byte	135
	.byte	0

#    9  "Concatenation right operand is not a string or pattern"
	.byte	206
	.byte	21
	.byte	135
	.byte	0

#   10  "Negation operand is not numeric"
	.ascii	"Negation "
	.byte	3
	.byte	8
	.byte	0

#   11  "Negation caused integer overflow"
	.ascii	"Negation "
	.byte	18
	.byte	0

#   12  "Division left operand is not numeric"
	.byte	161
	.byte	31
	.byte	0

#   13  "Division right operand is not numeric"
	.byte	161
	.byte	185
	.byte	0

#   14  "Division caused integer overflow"
	.byte	161
	.byte	18
	.byte	0

#   15  "Exponentiation right operand is not numeric"
	.byte	23
	.byte	185
	.byte	0

#   16  "Exponentiation left operand is not numeric"
	.byte	23
	.byte	31
	.byte	0

#   17  "Exponentiation caused integer overflow"
	.byte	23
	.byte	18
	.byte	0

#   18  "Exponentiation result is undefined"
	.byte	23
	.ascii	"result "
	.byte	22
	.ascii	"undefined"
	.byte	0

#   19  ""
	.byte	0

#   20  "Goto evaluation failure"
	.byte	136
	.ascii	"evaluation failure"
	.byte	0

#   21  "Function called by name returned a value"
	.byte	165
	.ascii	"called "
	.byte	207
	.ascii	"a value"
	.byte	0

#   22  "Undefined function called"
	.byte	183
	.byte	13
	.ascii	"called"
	.byte	0

#   23  "Goto operand is not a natural variable"
	.byte	136
	.byte	3
	.ascii	"a natural variable"
	.byte	0

#   24  "Goto operand in direct goto is not code"
	.byte	136
	.ascii	"operand "
	.byte	201
	.ascii	"direct go"
	.byte	217
	.byte	22
	.byte	20
	.ascii	"code"
	.byte	0

#   25  "Immediate assignment left operand is not pattern"
	.ascii	"Immediate "
	.byte	129
	.byte	0

#   26  "Multiplication left operand is not numeric"
	.byte	134
	.byte	31
	.byte	0

#   27  "Multiplication right operand is not numeric"
	.byte	134
	.byte	185
	.byte	0

#   28  "Multiplication caused integer overflow"
	.byte	134
	.byte	18
	.byte	0

#   29  "Undefined operator referenced"
	.byte	183
	.ascii	"operat"
	.byte	167
	.ascii	"referenced"
	.byte	0

#   30  "Pattern assignment left operand is not pattern"
	.byte	172
	.byte	129
	.byte	0

#   31  "Pattern replacement right operand is not a string"
	.byte	172
	.byte	188
	.byte	0

#   32  "Subtraction left operand is not numeric"
	.byte	138
	.byte	31
	.byte	0

#   33  "Subtraction right operand is not numeric"
	.byte	138
	.byte	185
	.byte	0

#   34  "Subtraction caused integer overflow"
	.byte	138
	.byte	18
	.byte	0

#   35  "Unexpected failure in -NOFAIL mode"
	.byte	239
	.ascii	"failure "
	.byte	201
	.ascii	"-NOFAIL mode"
	.byte	0

#   36  "Goto ABORT with no preceding error"
	.byte	136
	.ascii	"ABORT "
	.byte	131
	.byte	0

#   37  "Goto CONTINUE with no preceding error"
	.byte	251
	.byte	131
	.byte	0

#   38  "Goto undefined label"
	.byte	136
	.byte	236
	.byte	0

#   39  "External function argument is not a string"
	.byte	156
	.byte	4
	.byte	0

#   40  "External function argument is not integer"
	.byte	156
	.byte	133
	.byte	0

#   41  "FIELD function argument is wrong datatype"
	.byte	242
	.byte	13
	.byte	2
	.byte	22
	.ascii	"wrong datatype"
	.byte	0

#   42  "Attempt to change value of protected variable"
	.ascii	"Attempt "
	.byte	217
	.ascii	"change "
	.byte	158
	.byte	193
	.ascii	"protected variable"
	.byte	0

#   43  "ANY evaluated argument is not a string"
	.ascii	"ANY "
	.byte	244
	.byte	0

#   44  "BREAK evaluated argument is not a string"
	.ascii	"BREAK "
	.byte	244
	.byte	0

#   45  "BREAKX evaluated argument is not a string"
	.ascii	"BREAKX "
	.byte	244
	.byte	0

#   46  "Expression does not evaluate to pattern"
	.byte	234
	.byte	184
	.byte	0

#   47  "LEN evaluated argument is not integer"
	.byte	254
	.byte	249
	.byte	0

#   48  "LEN evaluated argument is negative or too large"
	.byte	254
	.byte	250
	.byte	0

#   49  "NOTANY evaluated argument is not a string"
	.ascii	"NOTANY "
	.byte	244
	.byte	0

#   50  "POS evaluated argument is not integer"
	.byte	245
	.byte	249
	.byte	0

#   51  "POS evaluated argument is negative or too large"
	.byte	245
	.byte	250
	.byte	0

#   52  "RPOS evaluated argument is not integer"
	.byte	211
	.byte	249
	.byte	0

#   53  "RPOS evaluated argument is negative or too large"
	.byte	211
	.byte	250
	.byte	0

#   54  "RTAB evaluated argument is not integer"
	.byte	224
	.byte	249
	.byte	0

#   55  "RTAB evaluated argument is negative or too large"
	.byte	224
	.byte	250
	.byte	0

#   56  "SPAN evaluated argument is not a string"
	.ascii	"SPAN "
	.byte	244
	.byte	0

#   57  "TAB evaluated argument is not integer"
	.byte	248
	.byte	249
	.byte	0

#   58  "TAB evaluated argument is negative or too large"
	.byte	248
	.byte	250
	.byte	0

#   59  "ANY argument is not a string or expression"
	.ascii	"ANY "
	.byte	247
	.byte	0

#   60  "APPLY first arg is not natural variable name"
	.ascii	"APPLY "
	.byte	7
	.byte	143
	.byte	0

#   61  "ARBNO argument is not pattern"
	.ascii	"ARBNO "
	.byte	1
	.byte	28
	.byte	0

#   62  "ARG second argument is not integer"
	.ascii	"ARG "
	.byte	208
	.byte	0

#   63  "ARG first argument is not program function name"
	.ascii	"ARG "
	.byte	7
	.byte	1
	.byte	155
	.byte	0

#   64  "ARRAY first argument is not integer or string"
	.byte	160
	.byte	7
	.byte	133
	.ascii	" "
	.byte	167
	.byte	179
	.byte	0

#   65  "ARRAY first argument lower bound is not integer"
	.byte	160
	.byte	7
	.byte	2
	.ascii	"lower "
	.byte	169
	.byte	0

#   66  "ARRAY first argument upper bound is not integer"
	.byte	160
	.byte	7
	.byte	2
	.ascii	"upper "
	.byte	169
	.byte	0

#   67  "ARRAY dimension is zero, negative or out of range"
	.byte	160
	.byte	147
	.byte	0

#   68  "ARRAY size exceeds maximum permitted"
	.byte	160
	.byte	146
	.byte	0

#   69  "BREAK argument is not a string or expression"
	.ascii	"BREAK "
	.byte	247
	.byte	0

#   70  "BREAKX argument is not a string or expression"
	.ascii	"BREAKX "
	.byte	247
	.byte	0

#   71  "CLEAR argument is not a string"
	.ascii	"CLEAR "
	.byte	4
	.byte	0

#   72  "CLEAR argument has null variable name"
	.ascii	"CLEAR "
	.byte	240
	.byte	0

#   73  "COLLECT argument is not integer"
	.ascii	"COLLECT "
	.byte	133
	.byte	0

#   74  "CONVERT second argument is not a string"
	.ascii	"CONVERT "
	.byte	180
	.byte	0

#   75  "DATA argument is not a string"
	.byte	176
	.byte	4
	.byte	0

#   76  "DATA argument is null"
	.byte	176
	.byte	159
	.byte	0

#   77  "DATA argument is missing a left paren"
	.byte	176
	.byte	148
	.byte	0

#   78  "DATA argument has null datatype name"
	.byte	176
	.byte	137
	.byte	153
	.byte	0

#   79  "DATA argument is missing a right paren"
	.byte	176
	.byte	237
	.byte	0

#   80  "DATA argument has null field name"
	.byte	176
	.byte	137
	.ascii	"field "
	.byte	24
	.byte	0

#   81  "DEFINE first argument is not a string"
	.byte	142
	.byte	168
	.byte	0

#   82  "DEFINE first argument is null"
	.byte	142
	.byte	7
	.byte	159
	.byte	0

#   83  "DEFINE first argument is missing a left paren"
	.byte	142
	.byte	7
	.byte	148
	.byte	0

#   84  "DEFINE first argument has null function name"
	.byte	142
	.byte	255
	.byte	0

#   85  "Null arg name or missing ) in DEFINE first arg."
	.ascii	"Null "
	.byte	218
	.byte	24
	.ascii	" "
	.byte	167
	.byte	130
	.ascii	") "
	.byte	201
	.byte	142
	.byte	7
	.ascii	"arg."
	.byte	0

#   86  "DEFINE function entry point is not defined label"
	.byte	142
	.byte	191
	.byte	0

#   87  "DETACH argument is not appropriate name"
	.ascii	"DETACH "
	.byte	27
	.byte	0

#   88  "DUMP argument is not integer"
	.ascii	"DUMP "
	.byte	133
	.byte	0

#   89  "DUMP argument is negative or too large"
	.ascii	"DUMP "
	.byte	171
	.byte	0

#   90  "DUPL second argument is not integer"
	.ascii	"DUPL "
	.byte	208
	.byte	0

#   91  "DUPL first argument is not a string or pattern"
	.ascii	"DUPL "
	.byte	168
	.ascii	" "
	.byte	167
	.byte	28
	.byte	0

#   92  "EJECT argument is not a suitable name"
	.byte	196
	.byte	26
	.byte	0

#   93  "EJECT file does not exist"
	.byte	196
	.byte	174
	.byte	0

#   94  "EJECT file does not permit page eject"
	.byte	196
	.byte	152
	.ascii	"page eject"
	.byte	0

#   95  "EJECT caused non-recoverable output error"
	.byte	196
	.byte	162
	.byte	0

#   96  "ENDFILE argument is not a suitable name"
	.byte	149
	.byte	26
	.byte	0

#   97  "ENDFILE argument is null"
	.byte	149
	.byte	159
	.byte	0

#   98  "ENDFILE file does not exist"
	.byte	149
	.byte	174
	.byte	0

#   99  "ENDFILE file does not permit endfile"
	.byte	149
	.byte	152
	.ascii	"endfile"
	.byte	0

#  100  "ENDFILE caused non-recoverable output error"
	.byte	149
	.byte	162
	.byte	0

#  101  "EQ first argument is not numeric"
	.ascii	"EQ "
	.byte	209
	.byte	0

#  102  "EQ second argument is not numeric"
	.ascii	"EQ "
	.byte	205
	.byte	0

#  103  "EVAL argument is not expression"
	.ascii	"EVAL "
	.byte	1
	.ascii	"expression"
	.byte	0

#  104  "EXIT first argument is not suitable integer or string"
	.byte	223
	.byte	202
	.byte	0

#  105  "EXIT action not available in this implementation"
	.byte	223
	.ascii	"action "
	.byte	20
	.ascii	"available "
	.byte	201
	.ascii	"th"
	.byte	22
	.ascii	"implementation"
	.byte	0

#  106  "EXIT action caused irrecoverable error"
	.byte	223
	.byte	151
	.byte	0

#  107  "FIELD second argument is not integer"
	.byte	242
	.byte	208
	.byte	0

#  108  "FIELD first argument is not datatype name"
	.byte	242
	.byte	7
	.byte	1
	.byte	153
	.byte	0

#  109  "GE first argument is not numeric"
	.ascii	"GE "
	.byte	209
	.byte	0

#  110  "GE second argument is not numeric"
	.ascii	"GE "
	.byte	205
	.byte	0

#  111  "GT first argument is not numeric"
	.ascii	"GT "
	.byte	209
	.byte	0

#  112  "GT second argument is not numeric"
	.ascii	"GT "
	.byte	205
	.byte	0

#  113  "INPUT third argument is not a string"
	.byte	233
	.byte	128
	.byte	0

#  114  "Inappropriate second argument for INPUT"
	.byte	19
	.byte	9
	.byte	2
	.ascii	"f"
	.byte	167
	.ascii	"INPUT"
	.byte	0

#  115  "Inappropriate first argument for INPUT"
	.byte	19
	.byte	7
	.byte	2
	.ascii	"f"
	.byte	167
	.ascii	"INPUT"
	.byte	0

#  116  "Inappropriate file specification for INPUT"
	.byte	186
	.ascii	"INPUT"
	.byte	0

#  117  "INPUT file cannot be read"
	.byte	233
	.byte	199
	.ascii	"read"
	.byte	0

#  118  "LE first argument is not numeric"
	.ascii	"LE "
	.byte	209
	.byte	0

#  119  "LE second argument is not numeric"
	.ascii	"LE "
	.byte	205
	.byte	0

#  120  "LEN argument is not integer or expression"
	.byte	254
	.byte	253
	.byte	0

#  121  "LEN argument is negative or too large"
	.byte	254
	.byte	171
	.byte	0

#  122  "LEQ first argument is not a string"
	.ascii	"LEQ "
	.byte	168
	.byte	0

#  123  "LEQ second argument is not a string"
	.ascii	"LEQ "
	.byte	180
	.byte	0

#  124  "LGE first argument is not a string"
	.ascii	"LGE "
	.byte	168
	.byte	0

#  125  "LGE second argument is not a string"
	.ascii	"LGE "
	.byte	180
	.byte	0

#  126  "LGT first argument is not a string"
	.ascii	"LGT "
	.byte	168
	.byte	0

#  127  "LGT second argument is not a string"
	.ascii	"LGT "
	.byte	180
	.byte	0

#  128  "LLE first argument is not a string"
	.ascii	"LLE "
	.byte	168
	.byte	0

#  129  "LLE second argument is not a string"
	.ascii	"LLE "
	.byte	180
	.byte	0

#  130  "LLT first argument is not a string"
	.ascii	"LLT "
	.byte	168
	.byte	0

#  131  "LLT second argument is not a string"
	.ascii	"LLT "
	.byte	180
	.byte	0

#  132  "LNE first argument is not a string"
	.ascii	"LNE "
	.byte	168
	.byte	0

#  133  "LNE second argument is not a string"
	.ascii	"LNE "
	.byte	180
	.byte	0

#  134  "LOCAL second argument is not integer"
	.ascii	"LOCAL "
	.byte	208
	.byte	0

#  135  "LOCAL first arg is not a program function name"
	.ascii	"LOCAL "
	.byte	7
	.byte	218
	.byte	22
	.byte	20
	.ascii	"a "
	.byte	155
	.byte	0

#  136  "LOAD second argument is not a string"
	.byte	140
	.byte	180
	.byte	0

#  137  "LOAD first argument is not a string"
	.byte	140
	.byte	168
	.byte	0

#  138  "LOAD first argument is null"
	.byte	140
	.byte	7
	.byte	159
	.byte	0

#  139  "LOAD first argument is missing a left paren"
	.byte	140
	.byte	7
	.byte	148
	.byte	0

#  140  "LOAD first argument has null function name"
	.byte	140
	.byte	255
	.byte	0

#  141  "LOAD first argument is missing a right paren"
	.byte	140
	.byte	7
	.byte	237
	.byte	0

#  142  "LOAD function does not exist"
	.byte	140
	.byte	13
	.ascii	"does "
	.byte	20
	.ascii	"exist"
	.byte	0

#  143  "LOAD function caused input error during load"
	.byte	140
	.byte	13
	.ascii	"caused input "
	.byte	150
	.ascii	" "
	.byte	225
	.ascii	"load"
	.byte	0

#  144  "LPAD third argument is not a string"
	.ascii	"LPAD "
	.byte	128
	.byte	0

#  145  "LPAD second argument is not integer"
	.ascii	"LPAD "
	.byte	208
	.byte	0

#  146  "LPAD first argument is not a string"
	.ascii	"LPAD "
	.byte	168
	.byte	0

#  147  "LT first argument is not numeric"
	.ascii	"LT "
	.byte	209
	.byte	0

#  148  "LT second argument is not numeric"
	.ascii	"LT "
	.byte	205
	.byte	0

#  149  "NE first argument is not numeric"
	.ascii	"NE "
	.byte	209
	.byte	0

#  150  "NE second argument is not numeric"
	.ascii	"NE "
	.byte	205
	.byte	0

#  151  "NOTANY argument is not a string or expression"
	.ascii	"NOTANY "
	.byte	247
	.byte	0

#  152  "OPSYN third argument is not integer"
	.byte	178
	.byte	182
	.byte	0

#  153  "OPSYN third argument is negative or too large"
	.byte	178
	.ascii	"third "
	.byte	171
	.byte	0

#  154  "OPSYN second arg is not natural variable name"
	.byte	178
	.byte	9
	.byte	143
	.byte	0

#  155  "OPSYN first arg is not natural variable name"
	.byte	178
	.byte	7
	.byte	143
	.byte	0

#  156  "OPSYN first arg is not correct operator name"
	.byte	178
	.byte	164
	.byte	0

#  157  "OUTPUT third argument is not a string"
	.byte	227
	.byte	128
	.byte	0

#  158  "Inappropriate second argument for OUTPUT"
	.byte	19
	.byte	9
	.byte	246
	.byte	0

#  159  "Inappropriate first argument for OUTPUT"
	.byte	19
	.byte	7
	.byte	246
	.byte	0

#  160  "Inappropriate file specification for OUTPUT"
	.byte	186
	.byte	231
	.byte	0

#  161  "OUTPUT file cannot be written to"
	.byte	227
	.byte	199
	.ascii	"written to"
	.byte	0

#  162  "POS argument is not integer or expression"
	.byte	245
	.byte	253
	.byte	0

#  163  "POS argument is negative or too large"
	.byte	245
	.byte	171
	.byte	0

#  164  "PROTOTYPE argument is not valid object"
	.ascii	"PROTOTYPE "
	.byte	1
	.ascii	"valid object"
	.byte	0

#  165  "REMDR second argument is not numeric"
	.byte	197
	.byte	205
	.byte	0

#  166  "REMDR first argument is not numeric"
	.byte	197
	.byte	209
	.byte	0

#  167  "REMDR caused integer overflow"
	.byte	197
	.byte	18
	.byte	0

#  168  "REPLACE third argument is not a string"
	.byte	200
	.byte	128
	.byte	0

#  169  "REPLACE second argument is not a string"
	.byte	200
	.byte	180
	.byte	0

#  170  "REPLACE first argument is not a string"
	.byte	200
	.byte	168
	.byte	0

#  171  "Null or unequally long 2nd, 3rd args to REPLACE"
	.ascii	"Null "
	.byte	167
	.ascii	"unequally long 2nd, 3rd args "
	.byte	217
	.ascii	"REPLACE"
	.byte	0

#  172  "REWIND argument is not a suitable name"
	.byte	163
	.byte	26
	.byte	0

#  173  "REWIND argument is null"
	.byte	163
	.byte	159
	.byte	0

#  174  "REWIND file does not exist"
	.byte	163
	.byte	174
	.byte	0

#  175  "REWIND file does not permit rewind"
	.byte	163
	.byte	152
	.ascii	"rewind"
	.byte	0

#  176  "REWIND caused non-recoverable error"
	.byte	163
	.byte	12
	.byte	150
	.byte	0

#  177  "REVERSE argument is not a string"
	.ascii	"REVERSE "
	.byte	4
	.byte	0

#  178  "RPAD third argument is not a string"
	.ascii	"RPAD "
	.byte	128
	.byte	0

#  179  "RPAD second argument is not integer"
	.ascii	"RPAD "
	.byte	208
	.byte	0

#  180  "RPAD first argument is not a string"
	.ascii	"RPAD "
	.byte	168
	.byte	0

#  181  "RTAB argument is not integer or expression"
	.byte	224
	.byte	253
	.byte	0

#  182  "RTAB argument is negative or too large"
	.byte	224
	.byte	171
	.byte	0

#  183  "TAB argument is not integer or expression"
	.byte	248
	.byte	253
	.byte	0

#  184  "TAB argument is negative or too large"
	.byte	248
	.byte	171
	.byte	0

#  185  "RPOS argument is not integer or expression"
	.byte	211
	.byte	253
	.byte	0

#  186  "RPOS argument is negative or too large"
	.byte	211
	.byte	171
	.byte	0

#  187  "SETEXIT argument is not label name or null"
	.ascii	"SET"
	.byte	223
	.byte	1
	.byte	189
	.ascii	" "
	.byte	24
	.ascii	" "
	.byte	167
	.ascii	"null"
	.byte	0

#  188  "SPAN argument is not a string or expression"
	.ascii	"SPAN "
	.byte	247
	.byte	0

#  189  "SIZE argument is not a string"
	.ascii	"SIZE "
	.byte	4
	.byte	0

#  190  "STOPTR first argument is not appropriate name"
	.ascii	"STOPTR "
	.byte	7
	.byte	27
	.byte	0

#  191  "STOPTR second argument is not trace type"
	.ascii	"STOPTR "
	.byte	230
	.byte	0

#  192  "SUBSTR third argument is not integer"
	.byte	214
	.byte	182
	.byte	0

#  193  "SUBSTR second argument is not integer"
	.byte	214
	.byte	208
	.byte	0

#  194  "SUBSTR first argument is not a string"
	.byte	214
	.byte	168
	.byte	0

#  195  "TABLE argument is not integer"
	.ascii	"TABLE "
	.byte	133
	.byte	0

#  196  "TABLE argument is out of range"
	.ascii	"TABLE "
	.byte	204
	.byte	0

#  197  "TRACE fourth arg is not function name or null"
	.byte	241
	.ascii	"fourth "
	.byte	218
	.byte	22
	.byte	20
	.byte	13
	.byte	24
	.ascii	" "
	.byte	167
	.ascii	"null"
	.byte	0

#  198  "TRACE first argument is not appropriate name"
	.byte	241
	.byte	7
	.byte	27
	.byte	0

#  199  "TRACE second argument is not trace type"
	.byte	241
	.byte	230
	.byte	0

#  200  "TRIM argument is not a string"
	.ascii	"TRIM "
	.byte	4
	.byte	0

#  201  "UNLOAD argument is not natural variable name"
	.ascii	"UN"
	.byte	140
	.byte	1
	.byte	25
	.byte	0

#  202  "Input from file caused non-recoverable error"
	.ascii	"Input "
	.byte	228
	.byte	141
	.byte	12
	.byte	150
	.byte	0

#  203  "Input file record has incorrect format"
	.ascii	"Input "
	.byte	141
	.ascii	"record has incorrect format"
	.byte	0

#  204  "Memory overflow"
	.ascii	"Memory "
	.byte	14
	.byte	0

#  205  "String length exceeds value of MAXLNGTH keyword"
	.ascii	"String "
	.byte	221
	.byte	0

#  206  "Output caused file overflow"
	.ascii	"Output caused "
	.byte	141
	.byte	14
	.byte	0

#  207  "Output caused non-recoverable error"
	.ascii	"Output "
	.byte	12
	.byte	150
	.byte	0

#  208  "Keyword value assigned is not integer"
	.byte	173
	.byte	226
	.byte	0

#  209  "Keyword in assignment is protected"
	.byte	173
	.byte	201
	.ascii	"assignment "
	.byte	22
	.ascii	"protected"
	.byte	0

#  210  "Keyword value assigned is negative or too large"
	.byte	173
	.byte	232
	.byte	0

#  211  "Value assigned to keyword ERRTEXT not a string"
	.byte	194
	.byte	212
	.byte	0

#  212  "Syntax error: Value used where name is required"
	.byte	6
	.byte	194
	.ascii	"used where "
	.byte	24
	.ascii	" "
	.byte	22
	.ascii	"required"
	.byte	0

#  213  "Syntax error: Statement is too complicated."
	.byte	6
	.byte	243
	.byte	22
	.ascii	"too complicated."
	.byte	0

#  214  "Bad label or misplaced continuation line"
	.ascii	"Bad "
	.byte	189
	.ascii	" "
	.byte	167
	.ascii	"misplaced continuation line"
	.byte	0

#  215  "Syntax error: Undefined or erroneous entry label"
	.byte	6
	.byte	192
	.byte	0

#  216  "Syntax error: Missing END line"
	.byte	139
	.ascii	"END line"
	.byte	0

#  217  "Syntax error: Duplicate label"
	.byte	6
	.byte	238
	.byte	0

#  218  "Syntax error: Duplicated goto field"
	.byte	6
	.ascii	"Duplicated go"
	.byte	217
	.ascii	"field"
	.byte	0

#  219  "Syntax error: Empty goto field"
	.byte	6
	.ascii	"Empty go"
	.byte	217
	.ascii	"field"
	.byte	0

#  220  "Syntax error: Missing operator"
	.byte	139
	.ascii	"operator"
	.byte	0

#  221  "Syntax error: Missing operand"
	.byte	139
	.ascii	"operand"
	.byte	0

#  222  "Syntax error: Invalid use of left bracket"
	.byte	145
	.ascii	"left "
	.byte	216
	.byte	0

#  223  "Syntax error: Invalid use of comma"
	.byte	145
	.ascii	"comma"
	.byte	0

#  224  "Syntax error: Unbalanced right parenthesis"
	.byte	215
	.ascii	"parenthesis"
	.byte	0

#  225  "Syntax error: Unbalanced right bracket"
	.byte	215
	.byte	216
	.byte	0

#  226  "Syntax error: Missing right paren"
	.byte	139
	.byte	21
	.ascii	"paren"
	.byte	0

#  227  "Syntax error: Right paren missing from goto"
	.byte	6
	.ascii	"Right paren "
	.byte	130
	.byte	228
	.ascii	"goto"
	.byte	0

#  228  "Syntax error: Right bracket missing from goto"
	.byte	6
	.ascii	"Right "
	.byte	216
	.ascii	" "
	.byte	130
	.byte	228
	.ascii	"goto"
	.byte	0

#  229  "Syntax error: Missing right array bracket"
	.byte	139
	.byte	21
	.ascii	"array "
	.byte	216
	.byte	0

#  230  "Syntax error: Illegal character"
	.byte	6
	.ascii	"Illegal character"
	.byte	0

#  231  "Syntax error: Invalid numeric item"
	.byte	6
	.ascii	"Invalid "
	.byte	8
	.ascii	" item"
	.byte	0

#  232  "Syntax error: Unmatched string quote"
	.byte	6
	.ascii	"Unmatched "
	.byte	179
	.ascii	" quote"
	.byte	0

#  233  "Syntax error: Invalid use of operator"
	.byte	145
	.ascii	"operator"
	.byte	0

#  234  "Syntax error: Goto field incorrect"
	.byte	6
	.byte	136
	.ascii	"field incorrect"
	.byte	0

#  235  "Subscripted operand is not table or array"
	.ascii	"Subscripted "
	.byte	3
	.ascii	"table "
	.byte	167
	.ascii	"array"
	.byte	0

#  236  "Array referenced with wrong number of subscripts"
	.ascii	"Array "
	.byte	195
	.ascii	"wrong number "
	.byte	193
	.ascii	"subscripts"
	.byte	0

#  237  "Table referenced with more than one subscript"
	.ascii	"Table "
	.byte	195
	.ascii	"more than one subscript"
	.byte	0

#  238  "Array subscript is not integer"
	.ascii	"Array "
	.byte	210
	.byte	0

#  239  "Indirection operand is not name"
	.ascii	"Indirection "
	.byte	3
	.byte	24
	.byte	0

#  240  "Pattern match right operand is not pattern"
	.byte	172
	.ascii	"match "
	.byte	21
	.byte	3
	.byte	28
	.byte	0

#  241  "Pattern match left operand is not a string"
	.byte	172
	.byte	203
	.byte	0

#  242  "Function return from level zero"
	.byte	165
	.ascii	"return "
	.byte	228
	.ascii	"level zero"
	.byte	0

#  243  "Function result in NRETURN is not name"
	.byte	165
	.byte	177
	.byte	0

#  244  "Statement count exceeds value of STLIMIT keyword"
	.byte	243
	.byte	220
	.byte	0

#  245  "Translation/execution time expired"
	.ascii	"Translation/execution time expired"
	.byte	0

#  246  "Stack overflow"
	.ascii	"Stack "
	.byte	14
	.byte	0

#  247  "Invalid control statement"
	.ascii	"Invalid control statement"
	.byte	0

#  248  "Attempted redefinition of system function"
	.ascii	"Attempted redefinition "
	.byte	193
	.ascii	"system function"
	.byte	0

#  249  "Expression evaluated by name returned value"
	.byte	234
	.byte	11
	.byte	207
	.ascii	"value"
	.byte	0

#  250  "Insufficient memory to complete dump"
	.ascii	"Insufficient memory "
	.byte	217
	.ascii	"complete dump"
	.byte	0

#  251  "Keyword operand is not name of defined keyword"
	.byte	173
	.byte	222
	.byte	0

#  252  "Error on printing to interactive channel"
	.ascii	"Err"
	.byte	167
	.ascii	"on printing "
	.byte	217
	.ascii	"interactive channel"
	.byte	0

#  253  "Print limit exceeded on standard output channel"
	.ascii	"Print limit exceeded on standard output channel"
	.byte	0

#  254  "Erroneous argument for HOST"
	.byte	252
	.byte	2
	.ascii	"f"
	.byte	167
	.ascii	"HOST"
	.byte	0

#  255  "Error during execution of HOST"
	.ascii	"Err"
	.byte	167
	.byte	225
	.ascii	"execution "
	.byte	193
	.ascii	"HOST"
	.byte	0

#  256  "SORT/RSORT 1st arg not suitable ARRAY or TABLE"
	.byte	175
	.ascii	"1st "
	.byte	218
	.byte	20
	.ascii	"suitable "
	.byte	160
	.byte	167
	.ascii	"TABLE"
	.byte	0

#  257  "Erroneous 2nd arg in SORT/RSORT of vector"
	.byte	252
	.ascii	"2nd "
	.byte	218
	.byte	201
	.byte	175
	.byte	193
	.ascii	"vector"
	.byte	0

#  258  "SORT/RSORT 2nd arg out of range or non-integer"
	.byte	175
	.byte	198
	.byte	0

#  259  "FENCE argument is not pattern"
	.ascii	"FENCE "
	.byte	1
	.byte	28
	.byte	0

#  260  "Conversion array size exceeds maximum permitted"
	.ascii	"Conversion array "
	.byte	146
	.byte	0

#  261  "Addition caused real overflow"
	.byte	166
	.byte	15
	.byte	0

#  262  "Division caused real overflow"
	.byte	161
	.byte	15
	.byte	0

#  263  "Multiplication caused real overflow"
	.byte	134
	.byte	15
	.byte	0

#  264  "Subtraction caused real overflow"
	.byte	138
	.byte	15
	.byte	0

#  265  "External function argument is not real"
	.byte	156
	.byte	1
	.ascii	"real"
	.byte	0

#  266  "Exponentiation caused real overflow"
	.byte	23
	.byte	15
	.byte	0

#  267  ""
	.byte	0

#  268  "Inconsistent value assigned to keyword PROFILE"
	.ascii	"Inconsistent "
	.byte	158
	.byte	29
	.ascii	"PROFILE"
	.byte	0

#  269  ""
	.byte	0

#  270  ""
	.byte	0

#  271  ""
	.byte	0

#  272  ""
	.byte	0

#  273  ""
	.byte	0

#  274  "Value assigned to keyword FULLSCAN is zero"
	.byte	194
	.byte	29
	.ascii	"FULLSCAN "
	.byte	22
	.ascii	"zero"
	.byte	0

#  275  ""
	.byte	0

#  276  ""
	.byte	0

#  277  ""
	.byte	0

#  278  ""
	.byte	0

#  279  ""
	.byte	0

#  280  ""
	.byte	0

#  281  "CHAR argument not integer"
	.ascii	"CHAR "
	.byte	2
	.byte	20
	.byte	10
	.byte	0

#  282  "CHAR argument not in range"
	.ascii	"CHAR "
	.byte	2
	.byte	20
	.byte	201
	.ascii	"range"
	.byte	0

#  283  ""
	.byte	0

#  284  "Excessively nested INCLUDE files"
	.ascii	"Excessively nested INCLUDE files"
	.byte	0

#  285  "INCLUDE file cannot be opened"
	.ascii	"INCLUDE "
	.byte	199
	.ascii	"opened"
	.byte	0

#  286  "Function call to undefined entry label"
	.byte	165
	.byte	190
	.byte	0

#  287  "Value assigned to keyword MAXLNGTH is too small"
	.byte	194
	.byte	29
	.byte	187
	.byte	22
	.ascii	"too small"
	.byte	0

#  288  "EXIT second argument is not a string"
	.byte	223
	.byte	180
	.byte	0

#  289  "INPUT channel currently in use"
	.byte	233
	.byte	170
	.byte	0

#  290  "OUTPUT channel currently in use"
	.byte	227
	.byte	170
	.byte	0

#  291  "SET first argument is not a suitable name"
	.byte	213
	.byte	7
	.byte	26
	.byte	0

#  292  "SET first argument is null"
	.byte	213
	.byte	7
	.byte	159
	.byte	0

#  293  "Inappropriate second argument to SET"
	.byte	19
	.byte	9
	.byte	2
	.byte	217
	.ascii	"SET"
	.byte	0

#  294  "Inappropriate third argument to SET"
	.byte	19
	.ascii	"third "
	.byte	2
	.byte	217
	.ascii	"SET"
	.byte	0

#  295  "SET file does not exist"
	.byte	213
	.byte	174
	.byte	0

#  296  "SET file does not permit setting file pointer"
	.byte	213
	.byte	152
	.ascii	"setting "
	.byte	141
	.ascii	"pointer"
	.byte	0

#  297  "SET caused non-recoverable I/O error"
	.byte	213
	.byte	12
	.ascii	"I/O "
	.byte	150
	.byte	0

#  298  "External function argument is not file"
	.byte	156
	.byte	1
	.ascii	"file"
	.byte	0

#  299  "Internal logic error: Unexpected PPM branch"
	.ascii	"Internal logic "
	.byte	150
	.ascii	": "
	.byte	239
	.ascii	"PPM branch"
	.byte	0

#  300  ""
	.byte	0

#  301  "ATAN argument not numeric"
	.ascii	"ATAN "
	.byte	144
	.byte	0

#  302  "CHOP argument not numeric"
	.ascii	"CHOP "
	.byte	144
	.byte	0

#  303  "COS argument not numeric"
	.ascii	"COS "
	.byte	144
	.byte	0

#  304  "EXP argument not numeric"
	.ascii	"EXP "
	.byte	144
	.byte	0

#  305  "EXP produced real overflow"
	.ascii	"EXP "
	.byte	30
	.byte	0

#  306  "LN argument not numeric"
	.ascii	"LN "
	.byte	144
	.byte	0

#  307  "LN produced real overflow"
	.ascii	"LN "
	.byte	30
	.byte	0

#  308  "SIN argument not numeric"
	.ascii	"SIN "
	.byte	144
	.byte	0

#  309  "TAN argument not numeric"
	.ascii	"TAN "
	.byte	144
	.byte	0

#  310  "TAN produced real overflow or argument is out of range"
	.ascii	"TAN "
	.byte	30
	.ascii	" "
	.byte	167
	.byte	204
	.byte	0

#  311  "Exponentiation of negative base to non-integral power"
	.byte	23
	.byte	193
	.ascii	"negative base "
	.byte	217
	.ascii	"non-integral power"
	.byte	0

#  312  "REMDR caused real overflow"
	.byte	197
	.byte	15
	.byte	0

#  313  "SQRT argument not numeric"
	.ascii	"SQRT "
	.byte	144
	.byte	0

#  314  "SQRT argument negative"
	.ascii	"SQRT "
	.byte	2
	.ascii	"negative"
	.byte	0

#  315  "LN argument negative"
	.ascii	"LN "
	.byte	2
	.ascii	"negative"
	.byte	0

#  316  "BACKSPACE argument is not a suitable name"
	.byte	154
	.byte	26
	.byte	0

#  317  "BACKSPACE file does not exist"
	.byte	154
	.byte	174
	.byte	0

#  318  "BACKSPACE file does not permit backspace"
	.byte	154
	.byte	152
	.ascii	"backspace"
	.byte	0

#  319  "BACKSPACE caused non-recoverable error"
	.byte	154
	.byte	12
	.byte	150
	.byte	0

#  320  "User interrupt"
	.ascii	"User interrupt"
	.byte	0

#  321  "Goto SCONTINUE with no preceding error"
	.byte	235
	.byte	131
	.byte	0

#  322  "COS argument is out of range"
	.ascii	"COS "
	.byte	204
	.byte	0

#  323  "SIN argument is out of range"
	.ascii	"SIN "
	.byte	204
	.byte	0

#  324  ""
	.byte	0

#  325  ""
	.byte	0

#  326  "Calling external function - bad argument type"
	.byte	181
	.ascii	"bad "
	.byte	2
	.ascii	"type"
	.byte	0

#  327  "Calling external function - not found"
	.byte	181
	.byte	20
	.ascii	"found"
	.byte	0

#  328  "LOAD function - insufficient memory"
	.byte	140
	.byte	13
	.ascii	"- insufficient memory"
	.byte	0

#  329  "Requested MAXLNGTH too large"
	.ascii	"Requested "
	.byte	187
	.ascii	"too large"
	.byte	0

#  330  "DATE argument is not integer"
	.ascii	"DATE "
	.byte	133
	.byte	0

#  331  "Goto SCONTINUE with no user interrupt"
	.byte	235
	.ascii	"with no user interrupt"
	.byte	0

#  332  "Goto CONTINUE with error in failure goto"
	.byte	251
	.ascii	"with "
	.byte	150
	.ascii	" "
	.byte	201
	.ascii	"failure goto"
	.byte	0

	pubdef	phrases,.byte,0

#    1  "argument is not "
	.byte	2
	.byte	22
	.byte	20
	.byte	0

#    2  "argument "
	.ascii	"argument "
	.byte	0

#    3  "operand is not "
	.ascii	"operand "
	.byte	22
	.byte	20
	.byte	0

#    4  "argument is not a string"
	.byte	1
	.ascii	"a "
	.byte	179
	.byte	0

#    5  "is negative or too large"
	.byte	22
	.ascii	"negative "
	.byte	167
	.ascii	"too large"
	.byte	0

#    6  "Syntax error: "
	.ascii	"Syntax "
	.byte	150
	.ascii	": "
	.byte	0

#    7  "first "
	.ascii	"first "
	.byte	0

#    8  "numeric"
	.ascii	"numeric"
	.byte	0

#    9  "second "
	.ascii	"second "
	.byte	0

#   10  "integer"
	.ascii	"integer"
	.byte	0

#   11  "evaluated "
	.ascii	"evaluated "
	.byte	0

#   12  "caused non-recoverable "
	.ascii	"caused non-recoverable "
	.byte	0

#   13  "function "
	.ascii	"function "
	.byte	0

#   14  "overflow"
	.ascii	"overflow"
	.byte	0

#   15  "caused real overflow"
	.ascii	"caused real "
	.byte	14
	.byte	0

#   16  "file does not "
	.byte	141
	.ascii	"does "
	.byte	20
	.byte	0

#   17  " or expression"
	.ascii	" "
	.byte	167
	.ascii	"expression"
	.byte	0

#   18  "caused integer overflow"
	.ascii	"caused "
	.byte	10
	.ascii	" "
	.byte	14
	.byte	0

#   19  "Inappropriate "
	.ascii	"Inappropriate "
	.byte	0

#   20  "not "
	.ascii	"not "
	.byte	0

#   21  "right "
	.ascii	"right "
	.byte	0

#   22  "is "
	.ascii	"is "
	.byte	0

#   23  "Exponentiation "
	.ascii	"Exponentiation "
	.byte	0

#   24  "name"
	.ascii	"name"
	.byte	0

#   25  "natural variable name"
	.ascii	"natural variable "
	.byte	24
	.byte	0

#   26  "argument is not a suitable name"
	.byte	1
	.ascii	"a suitable "
	.byte	24
	.byte	0

#   27  "argument is not appropriate name"
	.byte	1
	.ascii	"appropriate "
	.byte	24
	.byte	0

#   28  "pattern"
	.ascii	"pattern"
	.byte	0

#   29  "assigned to keyword "
	.ascii	"assigned "
	.byte	217
	.byte	219
	.ascii	" "
	.byte	0

#   30  "produced real overflow"
	.ascii	"produced real "
	.byte	14
	.byte	0

#   31  "left operand is not numeric"
	.ascii	"left "
	.byte	3
	.byte	8
	.byte	0

#  128  "third argument is not a string"
	.ascii	"third "
	.byte	4
	.byte	0

#  129  "assignment left operand is not pattern"
	.ascii	"assignment left "
	.byte	3
	.byte	28
	.byte	0

#  130  "missing "
	.ascii	"missing "
	.byte	0

#  131  "with no preceding error"
	.ascii	"with no preceding "
	.byte	150
	.byte	0

#  132  "out of range"
	.ascii	"out "
	.byte	193
	.ascii	"range"
	.byte	0

#  133  "argument is not integer"
	.byte	1
	.byte	10
	.byte	0

#  134  "Multiplication "
	.ascii	"Multiplication "
	.byte	0

#  135  "operand is not a string or pattern"
	.byte	3
	.ascii	"a "
	.byte	179
	.ascii	" "
	.byte	167
	.byte	28
	.byte	0

#  136  "Goto "
	.ascii	"Go"
	.byte	217
	.byte	0

#  137  "argument has null "
	.byte	2
	.ascii	"has null "
	.byte	0

#  138  "Subtraction "
	.ascii	"Subtraction "
	.byte	0

#  139  "Syntax error: Missing "
	.byte	6
	.ascii	"Missing "
	.byte	0

#  140  "LOAD "
	.ascii	"LOAD "
	.byte	0

#  141  "file "
	.ascii	"file "
	.byte	0

#  142  "DEFINE "
	.ascii	"DEFINE "
	.byte	0

#  143  "arg is not natural variable name"
	.byte	218
	.byte	22
	.byte	20
	.byte	25
	.byte	0

#  144  "argument not numeric"
	.byte	2
	.byte	20
	.byte	8
	.byte	0

#  145  "Syntax error: Invalid use of "
	.byte	6
	.ascii	"Invalid use "
	.byte	193
	.byte	0

#  146  "size exceeds maximum permitted"
	.ascii	"size exceeds maximum permitted"
	.byte	0

#  147  "dimension is zero, negative or out of range"
	.ascii	"dimension "
	.byte	22
	.ascii	"zero, negative "
	.byte	167
	.byte	132
	.byte	0

#  148  "argument is missing a left paren"
	.byte	2
	.byte	22
	.byte	130
	.ascii	"a left paren"
	.byte	0

#  149  "ENDFILE "
	.ascii	"ENDFILE "
	.byte	0

#  150  "error"
	.ascii	"error"
	.byte	0

#  151  "action caused irrecoverable error"
	.ascii	"action caused irrecoverable "
	.byte	150
	.byte	0

#  152  "file does not permit "
	.byte	16
	.ascii	"permit "
	.byte	0

#  153  "datatype name"
	.ascii	"datatype "
	.byte	24
	.byte	0

#  154  "BACKSPACE "
	.ascii	"BACKSPACE "
	.byte	0

#  155  "program function name"
	.ascii	"program "
	.byte	13
	.byte	24
	.byte	0

#  156  "External function "
	.ascii	"External "
	.byte	13
	.byte	0

#  157  "argument is not numeric"
	.byte	1
	.byte	8
	.byte	0

#  158  "value "
	.ascii	"value "
	.byte	0

#  159  "argument is null"
	.byte	2
	.byte	22
	.ascii	"null"
	.byte	0

#  160  "ARRAY "
	.ascii	"ARRAY "
	.byte	0

#  161  "Division "
	.ascii	"Division "
	.byte	0

#  162  "caused non-recoverable output error"
	.byte	12
	.ascii	"output "
	.byte	150
	.byte	0

#  163  "REWIND "
	.ascii	"REWIND "
	.byte	0

#  164  "first arg is not correct operator name"
	.byte	7
	.byte	218
	.byte	22
	.byte	20
	.ascii	"correct operat"
	.byte	167
	.byte	24
	.byte	0

#  165  "Function "
	.ascii	"Function "
	.byte	0

#  166  "Addition "
	.ascii	"Addition "
	.byte	0

#  167  "or "
	.ascii	"or "
	.byte	0

#  168  "first argument is not a string"
	.byte	7
	.byte	4
	.byte	0

#  169  "bound is not integer"
	.ascii	"bound "
	.byte	22
	.byte	20
	.byte	10
	.byte	0

#  170  "channel currently in use"
	.ascii	"channel currently "
	.byte	201
	.ascii	"use"
	.byte	0

#  171  "argument is negative or too large"
	.byte	2
	.byte	5
	.byte	0

#  172  "Pattern "
	.ascii	"Pattern "
	.byte	0

#  173  "Keyword "
	.ascii	"Keyword "
	.byte	0

#  174  "file does not exist"
	.byte	16
	.ascii	"exist"
	.byte	0

#  175  "SORT/RSORT "
	.ascii	"SORT/RSORT "
	.byte	0

#  176  "DATA "
	.ascii	"DATA "
	.byte	0

#  177  "result in NRETURN is not name"
	.ascii	"result "
	.byte	201
	.ascii	"NRETURN "
	.byte	22
	.byte	20
	.byte	24
	.byte	0

#  178  "OPSYN "
	.ascii	"OPSYN "
	.byte	0

#  179  "string"
	.ascii	"string"
	.byte	0

#  180  "second argument is not a string"
	.byte	9
	.byte	4
	.byte	0

#  181  "Calling external function - "
	.ascii	"Calling external "
	.byte	13
	.ascii	"- "
	.byte	0

#  182  "third argument is not integer"
	.ascii	"third "
	.byte	133
	.byte	0

#  183  "Undefined "
	.ascii	"Undefined "
	.byte	0

#  184  "does not evaluate to pattern"
	.ascii	"does "
	.byte	20
	.ascii	"evaluate "
	.byte	217
	.byte	28
	.byte	0

#  185  "right operand is not numeric"
	.byte	21
	.byte	3
	.byte	8
	.byte	0

#  186  "Inappropriate file specification for "
	.byte	19
	.byte	141
	.ascii	"specification f"
	.byte	167
	.byte	0

#  187  "MAXLNGTH "
	.ascii	"MAXLNGTH "
	.byte	0

#  188  "replacement right operand is not a string"
	.ascii	"replacement "
	.byte	21
	.byte	3
	.ascii	"a "
	.byte	179
	.byte	0

#  189  "label"
	.ascii	"label"
	.byte	0

#  190  "call to undefined entry label"
	.ascii	"call "
	.byte	217
	.ascii	"undefined entry "
	.byte	189
	.byte	0

#  191  "function entry point is not defined label"
	.byte	13
	.ascii	"entry point "
	.byte	22
	.byte	20
	.ascii	"defined "
	.byte	189
	.byte	0

#  192  "Undefined or erroneous entry label"
	.byte	183
	.byte	167
	.ascii	"erroneous entry "
	.byte	189
	.byte	0

#  193  "of "
	.ascii	"of "
	.byte	0

#  194  "Value "
	.ascii	"Value "
	.byte	0

#  195  "referenced with "
	.ascii	"referenced with "
	.byte	0

#  196  "EJECT "
	.ascii	"EJECT "
	.byte	0

#  197  "REMDR "
	.ascii	"REMDR "
	.byte	0

#  198  "2nd arg out of range or non-integer"
	.ascii	"2nd "
	.byte	218
	.byte	132
	.ascii	" "
	.byte	167
	.ascii	"non-"
	.byte	10
	.byte	0

#  199  "file cannot be "
	.byte	141
	.ascii	"can"
	.byte	20
	.ascii	"be "
	.byte	0

#  200  "REPLACE "
	.ascii	"REPLACE "
	.byte	0

#  201  "in "
	.ascii	"in "
	.byte	0

#  202  "first argument is not suitable integer or string"
	.byte	7
	.byte	1
	.ascii	"suitable "
	.byte	10
	.ascii	" "
	.byte	167
	.byte	179
	.byte	0

#  203  "match left operand is not a string"
	.ascii	"match left "
	.byte	3
	.ascii	"a "
	.byte	179
	.byte	0

#  204  "argument is out of range"
	.byte	2
	.byte	22
	.byte	132
	.byte	0

#  205  "second argument is not numeric"
	.byte	9
	.byte	157
	.byte	0

#  206  "Concatenation "
	.ascii	"Concatenation "
	.byte	0

#  207  "by name returned "
	.ascii	"by "
	.byte	24
	.ascii	" returned "
	.byte	0

#  208  "second argument is not integer"
	.byte	9
	.byte	133
	.byte	0

#  209  "first argument is not numeric"
	.byte	7
	.byte	157
	.byte	0

#  210  "subscript is not integer"
	.ascii	"subscript "
	.byte	22
	.byte	20
	.byte	10
	.byte	0

#  211  "RPOS "
	.ascii	"R"
	.byte	245
	.byte	0

#  212  "assigned to keyword ERRTEXT not a string"
	.byte	29
	.ascii	"ERRTEXT "
	.byte	20
	.ascii	"a "
	.byte	179
	.byte	0

#  213  "SET "
	.ascii	"SET "
	.byte	0

#  214  "SUBSTR "
	.ascii	"SUBSTR "
	.byte	0

#  215  "Syntax error: Unbalanced right "
	.byte	6
	.ascii	"Unbalanced "
	.byte	21
	.byte	0

#  216  "bracket"
	.ascii	"bracket"
	.byte	0

#  217  "to "
	.ascii	"to "
	.byte	0

#  218  "arg "
	.ascii	"arg "
	.byte	0

#  219  "keyword"
	.ascii	"keyword"
	.byte	0

#  220  "count exceeds value of STLIMIT keyword"
	.ascii	"count exceeds "
	.byte	158
	.byte	193
	.ascii	"STLIMIT "
	.byte	219
	.byte	0

#  221  "length exceeds value of MAXLNGTH keyword"
	.ascii	"length exceeds "
	.byte	158
	.byte	193
	.byte	187
	.byte	219
	.byte	0

#  222  "operand is not name of defined keyword"
	.byte	3
	.byte	24
	.ascii	" "
	.byte	193
	.ascii	"defined "
	.byte	219
	.byte	0

#  223  "EXIT "
	.ascii	"EXIT "
	.byte	0

#  224  "RTAB "
	.ascii	"R"
	.byte	248
	.byte	0

#  225  "during "
	.ascii	"during "
	.byte	0

#  226  "value assigned is not integer"
	.byte	158
	.ascii	"assigned "
	.byte	22
	.byte	20
	.byte	10
	.byte	0

#  227  "OUTPUT "
	.byte	231
	.ascii	" "
	.byte	0

#  228  "from "
	.ascii	"from "
	.byte	0

#  229  "Alternation "
	.ascii	"Alternation "
	.byte	0

#  230  "second argument is not trace type"
	.byte	9
	.byte	1
	.ascii	"trace type"
	.byte	0

#  231  "OUTPUT"
	.ascii	"OUTPUT"
	.byte	0

#  232  "value assigned is negative or too large"
	.byte	158
	.ascii	"assigned "
	.byte	5
	.byte	0

#  233  "INPUT "
	.ascii	"INPUT "
	.byte	0

#  234  "Expression "
	.ascii	"Expression "
	.byte	0

#  235  "Goto SCONTINUE "
	.byte	136
	.ascii	"SCONTINUE "
	.byte	0

#  236  "undefined label"
	.ascii	"undefined "
	.byte	189
	.byte	0

#  237  "argument is missing a right paren"
	.byte	2
	.byte	22
	.byte	130
	.ascii	"a "
	.byte	21
	.ascii	"paren"
	.byte	0

#  238  "Duplicate label"
	.ascii	"Duplicate "
	.byte	189
	.byte	0

#  239  "Unexpected "
	.ascii	"Unexpected "
	.byte	0

#  240  "argument has null variable name"
	.byte	137
	.ascii	"variable "
	.byte	24
	.byte	0

#  241  "TRACE "
	.ascii	"TRACE "
	.byte	0

#  242  "FIELD "
	.ascii	"FIELD "
	.byte	0

#  243  "Statement "
	.ascii	"Statement "
	.byte	0

#  244  "evaluated argument is not a string"
	.byte	11
	.byte	4
	.byte	0

#  245  "POS "
	.ascii	"POS "
	.byte	0

#  246  "argument for OUTPUT"
	.byte	2
	.ascii	"f"
	.byte	167
	.byte	231
	.byte	0

#  247  "argument is not a string or expression"
	.byte	4
	.byte	17
	.byte	0

#  248  "TAB "
	.ascii	"TAB "
	.byte	0

#  249  "evaluated argument is not integer"
	.byte	11
	.byte	133
	.byte	0

#  250  "evaluated argument is negative or too large"
	.byte	11
	.byte	171
	.byte	0

#  251  "Goto CONTINUE "
	.byte	136
	.ascii	"CONTINUE "
	.byte	0

#  252  "Erroneous "
	.ascii	"Erroneous "
	.byte	0

#  253  "argument is not integer or expression"
	.byte	133
	.byte	17
	.byte	0

#  254  "LEN "
	.ascii	"LEN "
	.byte	0

#  255  "first argument has null function name"
	.byte	7
	.byte	137
	.byte	13
	.byte	24
	.byte	0

	DSegEnd_
	.end
