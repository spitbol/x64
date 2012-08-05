; COMPRESSED SPITBOL ERROR MESSAGES 08/05/12 00:20:08
;
	;.sbttl	"errors"
	;.arch	pentium
	%include	"mintype.h"

	segment  .data

errors:	db	0

;    1  "Addition left operand is not numeric"
	db	166
	db	31
	db	0

;    2  "Addition right operand is not numeric"
	db	166
	db	185
	db	0

;    3  "Addition caused integer overflow"
	db	166
	db	18
	db	0

;    4  "Affirmation operand is not numeric"
	db	'Affirmation '
	db	3
	db	8
	db	0

;    5  "Alternation right operand is not pattern"
	db	229
	db	21
	db	3
	db	28
	db	0

;    6  "Alternation left operand is not pattern"
	db	229
	db	'left '
	db	3
	db	28
	db	0

;    7  "Compilation error encountered during execution"
	db	'Compilation '
	db	150
	db	' encountered '
	db	225
	db	'execution'
	db	0

;    8  "Concatenation left operand is not a string or pattern"
	db	206
	db	'left '
	db	135
	db	0

;    9  "Concatenation right operand is not a string or pattern"
	db	206
	db	21
	db	135
	db	0

;   10  "Negation operand is not numeric"
	db	'Negation '
	db	3
	db	8
	db	0

;   11  "Negation caused integer overflow"
	db	'Negation '
	db	18
	db	0

;   12  "Division left operand is not numeric"
	db	161
	db	31
	db	0

;   13  "Division right operand is not numeric"
	db	161
	db	185
	db	0

;   14  "Division caused integer overflow"
	db	161
	db	18
	db	0

;   15  "Exponentiation right operand is not numeric"
	db	23
	db	185
	db	0

;   16  "Exponentiation left operand is not numeric"
	db	23
	db	31
	db	0

;   17  "Exponentiation caused integer overflow"
	db	23
	db	18
	db	0

;   18  "Exponentiation result is undefined"
	db	23
	db	'result '
	db	22
	db	'undefined'
	db	0

;   19  ""
	db	0

;   20  "Goto evaluation failure"
	db	136
	db	'evaluation failure'
	db	0

;   21  "Function called by name returned a value"
	db	165
	db	'called '
	db	207
	db	'a value'
	db	0

;   22  "Undefined function called"
	db	183
	db	13
	db	'called'
	db	0

;   23  "Goto operand is not a natural variable"
	db	136
	db	3
	db	'a natural variable'
	db	0

;   24  "Goto operand in direct goto is not code"
	db	136
	db	'operand '
	db	201
	db	'direct go'
	db	217
	db	22
	db	20
	db	'code'
	db	0

;   25  "Immediate assignment left operand is not pattern"
	db	'Immediate '
	db	129
	db	0

;   26  "Multiplication left operand is not numeric"
	db	134
	db	31
	db	0

;   27  "Multiplication right operand is not numeric"
	db	134
	db	185
	db	0

;   28  "Multiplication caused integer overflow"
	db	134
	db	18
	db	0

;   29  "Undefined operator referenced"
	db	183
	db	'operat'
	db	167
	db	'referenced'
	db	0

;   30  "Pattern assignment left operand is not pattern"
	db	172
	db	129
	db	0

;   31  "Pattern replacement right operand is not a string"
	db	172
	db	188
	db	0

;   32  "Subtraction left operand is not numeric"
	db	138
	db	31
	db	0

;   33  "Subtraction right operand is not numeric"
	db	138
	db	185
	db	0

;   34  "Subtraction caused integer overflow"
	db	138
	db	18
	db	0

;   35  "Unexpected failure in -NOFAIL mode"
	db	239
	db	'failure '
	db	201
	db	'-NOFAIL mode'
	db	0

;   36  "Goto ABORT with no preceding error"
	db	136
	db	'ABORT '
	db	131
	db	0

;   37  "Goto CONTINUE with no preceding error"
	db	251
	db	131
	db	0

;   38  "Goto undefined label"
	db	136
	db	236
	db	0

;   39  "External function argument is not a string"
	db	156
	db	4
	db	0

;   40  "External function argument is not integer"
	db	156
	db	133
	db	0

;   41  "FIELD function argument is wrong datatype"
	db	242
	db	13
	db	2
	db	22
	db	'wrong datatype'
	db	0

;   42  "Attempt to change value of protected variable"
	db	'Attempt '
	db	217
	db	'change '
	db	158
	db	193
	db	'protected variable'
	db	0

;   43  "ANY evaluated argument is not a string"
	db	'ANY '
	db	244
	db	0

;   44  "BREAK evaluated argument is not a string"
	db	'BREAK '
	db	244
	db	0

;   45  "BREAKX evaluated argument is not a string"
	db	'BREAKX '
	db	244
	db	0

;   46  "Expression does not evaluate to pattern"
	db	234
	db	184
	db	0

;   47  "LEN evaluated argument is not integer"
	db	254
	db	249
	db	0

;   48  "LEN evaluated argument is negative or too large"
	db	254
	db	250
	db	0

;   49  "NOTANY evaluated argument is not a string"
	db	'NOTANY '
	db	244
	db	0

;   50  "POS evaluated argument is not integer"
	db	245
	db	249
	db	0

;   51  "POS evaluated argument is negative or too large"
	db	245
	db	250
	db	0

;   52  "RPOS evaluated argument is not integer"
	db	211
	db	249
	db	0

;   53  "RPOS evaluated argument is negative or too large"
	db	211
	db	250
	db	0

;   54  "RTAB evaluated argument is not integer"
	db	224
	db	249
	db	0

;   55  "RTAB evaluated argument is negative or too large"
	db	224
	db	250
	db	0

;   56  "SPAN evaluated argument is not a string"
	db	'SPAN '
	db	244
	db	0

;   57  "TAB evaluated argument is not integer"
	db	248
	db	249
	db	0

;   58  "TAB evaluated argument is negative or too large"
	db	248
	db	250
	db	0

;   59  "ANY argument is not a string or expression"
	db	'ANY '
	db	247
	db	0

;   60  "APPLY first arg is not natural variable name"
	db	'APPLY '
	db	7
	db	143
	db	0

;   61  "ARBNO argument is not pattern"
	db	'ARBNO '
	db	1
	db	28
	db	0

;   62  "ARG second argument is not integer"
	db	'ARG '
	db	208
	db	0

;   63  "ARG first argument is not program function name"
	db	'ARG '
	db	7
	db	1
	db	155
	db	0

;   64  "ARRAY first argument is not integer or string"
	db	160
	db	7
	db	133
	db	' '
	db	167
	db	179
	db	0

;   65  "ARRAY first argument lower bound is not integer"
	db	160
	db	7
	db	2
	db	'lower '
	db	169
	db	0

;   66  "ARRAY first argument upper bound is not integer"
	db	160
	db	7
	db	2
	db	'upper '
	db	169
	db	0

;   67  "ARRAY dimension is zero, negative or out of range"
	db	160
	db	147
	db	0

;   68  "ARRAY size exceeds maximum permitted"
	db	160
	db	146
	db	0

;   69  "BREAK argument is not a string or expression"
	db	'BREAK '
	db	247
	db	0

;   70  "BREAKX argument is not a string or expression"
	db	'BREAKX '
	db	247
	db	0

;   71  "CLEAR argument is not a string"
	db	'CLEAR '
	db	4
	db	0

;   72  "CLEAR argument has null variable name"
	db	'CLEAR '
	db	240
	db	0

;   73  "COLLECT argument is not integer"
	db	'COLLECT '
	db	133
	db	0

;   74  "CONVERT second argument is not a string"
	db	'CONVERT '
	db	180
	db	0

;   75  "DATA argument is not a string"
	db	176
	db	4
	db	0

;   76  "DATA argument is null"
	db	176
	db	159
	db	0

;   77  "DATA argument is missing a left paren"
	db	176
	db	148
	db	0

;   78  "DATA argument has null datatype name"
	db	176
	db	137
	db	153
	db	0

;   79  "DATA argument is missing a right paren"
	db	176
	db	237
	db	0

;   80  "DATA argument has null field name"
	db	176
	db	137
	db	'field '
	db	24
	db	0

;   81  "DEFINE first argument is not a string"
	db	142
	db	168
	db	0

;   82  "DEFINE first argument is null"
	db	142
	db	7
	db	159
	db	0

;   83  "DEFINE first argument is missing a left paren"
	db	142
	db	7
	db	148
	db	0

;   84  "DEFINE first argument has null function name"
	db	142
	db	255
	db	0

;   85  "Null arg name or missing ) in DEFINE first arg."
	db	'Null '
	db	218
	db	24
	db	' '
	db	167
	db	130
	db	') '
	db	201
	db	142
	db	7
	db	'arg.'
	db	0

;   86  "DEFINE function entry point is not defined label"
	db	142
	db	191
	db	0

;   87  "DETACH argument is not appropriate name"
	db	'DETACH '
	db	27
	db	0

;   88  "DUMP argument is not integer"
	db	'DUMP '
	db	133
	db	0

;   89  "DUMP argument is negative or too large"
	db	'DUMP '
	db	171
	db	0

;   90  "DUPL second argument is not integer"
	db	'DUPL '
	db	208
	db	0

;   91  "DUPL first argument is not a string or pattern"
	db	'DUPL '
	db	168
	db	' '
	db	167
	db	28
	db	0

;   92  "EJECT argument is not a suitable name"
	db	196
	db	26
	db	0

;   93  "EJECT file does not exist"
	db	196
	db	174
	db	0

;   94  "EJECT file does not permit page eject"
	db	196
	db	152
	db	'page eject'
	db	0

;   95  "EJECT caused non-recoverable output error"
	db	196
	db	162
	db	0

;   96  "ENDFILE argument is not a suitable name"
	db	149
	db	26
	db	0

;   97  "ENDFILE argument is null"
	db	149
	db	159
	db	0

;   98  "ENDFILE file does not exist"
	db	149
	db	174
	db	0

;   99  "ENDFILE file does not permit endfile"
	db	149
	db	152
	db	'endfile'
	db	0

;  100  "ENDFILE caused non-recoverable output error"
	db	149
	db	162
	db	0

;  101  "EQ first argument is not numeric"
	db	'EQ '
	db	209
	db	0

;  102  "EQ second argument is not numeric"
	db	'EQ '
	db	205
	db	0

;  103  "EVAL argument is not expression"
	db	'EVAL '
	db	1
	db	'expression'
	db	0

;  104  "EXIT first argument is not suitable integer or string"
	db	223
	db	202
	db	0

;  105  "EXIT action not available in this implementation"
	db	223
	db	'action '
	db	20
	db	'available '
	db	201
	db	'th'
	db	22
	db	'implementation'
	db	0

;  106  "EXIT action caused irrecoverable error"
	db	223
	db	151
	db	0

;  107  "FIELD second argument is not integer"
	db	242
	db	208
	db	0

;  108  "FIELD first argument is not datatype name"
	db	242
	db	7
	db	1
	db	153
	db	0

;  109  "GE first argument is not numeric"
	db	'GE '
	db	209
	db	0

;  110  "GE second argument is not numeric"
	db	'GE '
	db	205
	db	0

;  111  "GT first argument is not numeric"
	db	'GT '
	db	209
	db	0

;  112  "GT second argument is not numeric"
	db	'GT '
	db	205
	db	0

;  113  "INPUT third argument is not a string"
	db	233
	db	128
	db	0

;  114  "Inappropriate second argument for INPUT"
	db	19
	db	9
	db	2
	db	'f'
	db	167
	db	'INPUT'
	db	0

;  115  "Inappropriate first argument for INPUT"
	db	19
	db	7
	db	2
	db	'f'
	db	167
	db	'INPUT'
	db	0

;  116  "Inappropriate file specification for INPUT"
	db	186
	db	'INPUT'
	db	0

;  117  "INPUT file cannot be read"
	db	233
	db	199
	db	'read'
	db	0

;  118  "LE first argument is not numeric"
	db	'LE '
	db	209
	db	0

;  119  "LE second argument is not numeric"
	db	'LE '
	db	205
	db	0

;  120  "LEN argument is not integer or expression"
	db	254
	db	253
	db	0

;  121  "LEN argument is negative or too large"
	db	254
	db	171
	db	0

;  122  "LEQ first argument is not a string"
	db	'LEQ '
	db	168
	db	0

;  123  "LEQ second argument is not a string"
	db	'LEQ '
	db	180
	db	0

;  124  "LGE first argument is not a string"
	db	'LGE '
	db	168
	db	0

;  125  "LGE second argument is not a string"
	db	'LGE '
	db	180
	db	0

;  126  "LGT first argument is not a string"
	db	'LGT '
	db	168
	db	0

;  127  "LGT second argument is not a string"
	db	'LGT '
	db	180
	db	0

;  128  "LLE first argument is not a string"
	db	'LLE '
	db	168
	db	0

;  129  "LLE second argument is not a string"
	db	'LLE '
	db	180
	db	0

;  130  "LLT first argument is not a string"
	db	'LLT '
	db	168
	db	0

;  131  "LLT second argument is not a string"
	db	'LLT '
	db	180
	db	0

;  132  "LNE first argument is not a string"
	db	'LNE '
	db	168
	db	0

;  133  "LNE second argument is not a string"
	db	'LNE '
	db	180
	db	0

;  134  "LOCAL second argument is not integer"
	db	'LOCAL '
	db	208
	db	0

;  135  "LOCAL first arg is not a program function name"
	db	'LOCAL '
	db	7
	db	218
	db	22
	db	20
	db	'a '
	db	155
	db	0

;  136  "LOAD second argument is not a string"
	db	140
	db	180
	db	0

;  137  "LOAD first argument is not a string"
	db	140
	db	168
	db	0

;  138  "LOAD first argument is null"
	db	140
	db	7
	db	159
	db	0

;  139  "LOAD first argument is missing a left paren"
	db	140
	db	7
	db	148
	db	0

;  140  "LOAD first argument has null function name"
	db	140
	db	255
	db	0

;  141  "LOAD first argument is missing a right paren"
	db	140
	db	7
	db	237
	db	0

;  142  "LOAD function does not exist"
	db	140
	db	13
	db	'does '
	db	20
	db	'exist'
	db	0

;  143  "LOAD function caused input error during load"
	db	140
	db	13
	db	'caused input '
	db	150
	db	' '
	db	225
	db	'load'
	db	0

;  144  "LPAD third argument is not a string"
	db	'LPAD '
	db	128
	db	0

;  145  "LPAD second argument is not integer"
	db	'LPAD '
	db	208
	db	0

;  146  "LPAD first argument is not a string"
	db	'LPAD '
	db	168
	db	0

;  147  "LT first argument is not numeric"
	db	'LT '
	db	209
	db	0

;  148  "LT second argument is not numeric"
	db	'LT '
	db	205
	db	0

;  149  "NE first argument is not numeric"
	db	'NE '
	db	209
	db	0

;  150  "NE second argument is not numeric"
	db	'NE '
	db	205
	db	0

;  151  "NOTANY argument is not a string or expression"
	db	'NOTANY '
	db	247
	db	0

;  152  "OPSYN third argument is not integer"
	db	178
	db	182
	db	0

;  153  "OPSYN third argument is negative or too large"
	db	178
	db	'third '
	db	171
	db	0

;  154  "OPSYN second arg is not natural variable name"
	db	178
	db	9
	db	143
	db	0

;  155  "OPSYN first arg is not natural variable name"
	db	178
	db	7
	db	143
	db	0

;  156  "OPSYN first arg is not correct operator name"
	db	178
	db	164
	db	0

;  157  "OUTPUT third argument is not a string"
	db	227
	db	128
	db	0

;  158  "Inappropriate second argument for OUTPUT"
	db	19
	db	9
	db	246
	db	0

;  159  "Inappropriate first argument for OUTPUT"
	db	19
	db	7
	db	246
	db	0

;  160  "Inappropriate file specification for OUTPUT"
	db	186
	db	231
	db	0

;  161  "OUTPUT file cannot be written to"
	db	227
	db	199
	db	'written to'
	db	0

;  162  "POS argument is not integer or expression"
	db	245
	db	253
	db	0

;  163  "POS argument is negative or too large"
	db	245
	db	171
	db	0

;  164  "PROTOTYPE argument is not valid object"
	db	'PROTOTYPE '
	db	1
	db	'valid object'
	db	0

;  165  "REMDR second argument is not numeric"
	db	197
	db	205
	db	0

;  166  "REMDR first argument is not numeric"
	db	197
	db	209
	db	0

;  167  "REMDR caused integer overflow"
	db	197
	db	18
	db	0

;  168  "REPLACE third argument is not a string"
	db	200
	db	128
	db	0

;  169  "REPLACE second argument is not a string"
	db	200
	db	180
	db	0

;  170  "REPLACE first argument is not a string"
	db	200
	db	168
	db	0

;  171  "Null or unequally long 2nd, 3rd args to REPLACE"
	db	'Null '
	db	167
	db	'unequally long 2nd, 3rd args '
	db	217
	db	'REPLACE'
	db	0

;  172  "REWIND argument is not a suitable name"
	db	163
	db	26
	db	0

;  173  "REWIND argument is null"
	db	163
	db	159
	db	0

;  174  "REWIND file does not exist"
	db	163
	db	174
	db	0

;  175  "REWIND file does not permit rewind"
	db	163
	db	152
	db	'rewind'
	db	0

;  176  "REWIND caused non-recoverable error"
	db	163
	db	12
	db	150
	db	0

;  177  "REVERSE argument is not a string"
	db	'REVERSE '
	db	4
	db	0

;  178  "RPAD third argument is not a string"
	db	'RPAD '
	db	128
	db	0

;  179  "RPAD second argument is not integer"
	db	'RPAD '
	db	208
	db	0

;  180  "RPAD first argument is not a string"
	db	'RPAD '
	db	168
	db	0

;  181  "RTAB argument is not integer or expression"
	db	224
	db	253
	db	0

;  182  "RTAB argument is negative or too large"
	db	224
	db	171
	db	0

;  183  "TAB argument is not integer or expression"
	db	248
	db	253
	db	0

;  184  "TAB argument is negative or too large"
	db	248
	db	171
	db	0

;  185  "RPOS argument is not integer or expression"
	db	211
	db	253
	db	0

;  186  "RPOS argument is negative or too large"
	db	211
	db	171
	db	0

;  187  "SETEXIT argument is not label name or null"
	db	'SET'
	db	223
	db	1
	db	189
	db	' '
	db	24
	db	' '
	db	167
	db	'null'
	db	0

;  188  "SPAN argument is not a string or expression"
	db	'SPAN '
	db	247
	db	0

;  189  "SIZE argument is not a string"
	db	'SIZE '
	db	4
	db	0

;  190  "STOPTR first argument is not appropriate name"
	db	'STOPTR '
	db	7
	db	27
	db	0

;  191  "STOPTR second argument is not trace type"
	db	'STOPTR '
	db	230
	db	0

;  192  "SUBSTR third argument is not integer"
	db	214
	db	182
	db	0

;  193  "SUBSTR second argument is not integer"
	db	214
	db	208
	db	0

;  194  "SUBSTR first argument is not a string"
	db	214
	db	168
	db	0

;  195  "TABLE argument is not integer"
	db	'TABLE '
	db	133
	db	0

;  196  "TABLE argument is out of range"
	db	'TABLE '
	db	204
	db	0

;  197  "TRACE fourth arg is not function name or null"
	db	241
	db	'fourth '
	db	218
	db	22
	db	20
	db	13
	db	24
	db	' '
	db	167
	db	'null'
	db	0

;  198  "TRACE first argument is not appropriate name"
	db	241
	db	7
	db	27
	db	0

;  199  "TRACE second argument is not trace type"
	db	241
	db	230
	db	0

;  200  "TRIM argument is not a string"
	db	'TRIM '
	db	4
	db	0

;  201  "UNLOAD argument is not natural variable name"
	db	'UN'
	db	140
	db	1
	db	25
	db	0

;  202  "Input from file caused non-recoverable error"
	db	'Input '
	db	228
	db	141
	db	12
	db	150
	db	0

;  203  "Input file record has incorrect format"
	db	'Input '
	db	141
	db	'record has incorrect format'
	db	0

;  204  "Memory overflow"
	db	'Memory '
	db	14
	db	0

;  205  "String length exceeds value of MAXLNGTH keyword"
	db	'String '
	db	221
	db	0

;  206  "Output caused file overflow"
	db	'Output caused '
	db	141
	db	14
	db	0

;  207  "Output caused non-recoverable error"
	db	'Output '
	db	12
	db	150
	db	0

;  208  "Keyword value assigned is not integer"
	db	173
	db	226
	db	0

;  209  "Keyword in assignment is protected"
	db	173
	db	201
	db	'assignment '
	db	22
	db	'protected'
	db	0

;  210  "Keyword value assigned is negative or too large"
	db	173
	db	232
	db	0

;  211  "Value assigned to keyword ERRTEXT not a string"
	db	194
	db	212
	db	0

;  212  "Syntax error: Value used where name is required"
	db	6
	db	194
	db	'used where '
	db	24
	db	' '
	db	22
	db	'required'
	db	0

;  213  "Syntax error: Statement is too complicated."
	db	6
	db	243
	db	22
	db	'too complicated.'
	db	0

;  214  "Bad label or misplaced continuation line"
	db	'Bad '
	db	189
	db	' '
	db	167
	db	'misplaced continuation line'
	db	0

;  215  "Syntax error: Undefined or erroneous entry label"
	db	6
	db	192
	db	0

;  216  "Syntax error: Missing END line"
	db	139
	db	'END line'
	db	0

;  217  "Syntax error: Duplicate label"
	db	6
	db	238
	db	0

;  218  "Syntax error: Duplicated goto field"
	db	6
	db	'Duplicated go'
	db	217
	db	'field'
	db	0

;  219  "Syntax error: Empty goto field"
	db	6
	db	'Empty go'
	db	217
	db	'field'
	db	0

;  220  "Syntax error: Missing operator"
	db	139
	db	'operator'
	db	0

;  221  "Syntax error: Missing operand"
	db	139
	db	'operand'
	db	0

;  222  "Syntax error: Invalid use of left bracket"
	db	145
	db	'left '
	db	216
	db	0

;  223  "Syntax error: Invalid use of comma"
	db	145
	db	'comma'
	db	0

;  224  "Syntax error: Unbalanced right parenthesis"
	db	215
	db	'parenthesis'
	db	0

;  225  "Syntax error: Unbalanced right bracket"
	db	215
	db	216
	db	0

;  226  "Syntax error: Missing right paren"
	db	139
	db	21
	db	'paren'
	db	0

;  227  "Syntax error: Right paren missing from goto"
	db	6
	db	'Right paren '
	db	130
	db	228
	db	'goto'
	db	0

;  228  "Syntax error: Right bracket missing from goto"
	db	6
	db	'Right '
	db	216
	db	' '
	db	130
	db	228
	db	'goto'
	db	0

;  229  "Syntax error: Missing right array bracket"
	db	139
	db	21
	db	'array '
	db	216
	db	0

;  230  "Syntax error: Illegal character"
	db	6
	db	'Illegal character'
	db	0

;  231  "Syntax error: Invalid numeric item"
	db	6
	db	'Invalid '
	db	8
	db	' item'
	db	0

;  232  "Syntax error: Unmatched string quote"
	db	6
	db	'Unmatched '
	db	179
	db	' quote'
	db	0

;  233  "Syntax error: Invalid use of operator"
	db	145
	db	'operator'
	db	0

;  234  "Syntax error: Goto field incorrect"
	db	6
	db	136
	db	'field incorrect'
	db	0

;  235  "Subscripted operand is not table or array"
	db	'Subscripted '
	db	3
	db	'table '
	db	167
	db	'array'
	db	0

;  236  "Array referenced with wrong number of subscripts"
	db	'Array '
	db	195
	db	'wrong number '
	db	193
	db	'subscripts'
	db	0

;  237  "Table referenced with more than one subscript"
	db	'Table '
	db	195
	db	'more than one subscript'
	db	0

;  238  "Array subscript is not integer"
	db	'Array '
	db	210
	db	0

;  239  "Indirection operand is not name"
	db	'Indirection '
	db	3
	db	24
	db	0

;  240  "Pattern match right operand is not pattern"
	db	172
	db	'match '
	db	21
	db	3
	db	28
	db	0

;  241  "Pattern match left operand is not a string"
	db	172
	db	203
	db	0

;  242  "Function return from level zero"
	db	165
	db	'return '
	db	228
	db	'level zero'
	db	0

;  243  "Function result in NRETURN is not name"
	db	165
	db	177
	db	0

;  244  "Statement count exceeds value of STLIMIT keyword"
	db	243
	db	220
	db	0

;  245  "Translation/execution time expired"
	db	'Translation/execution time expired'
	db	0

;  246  "Stack overflow"
	db	'Stack '
	db	14
	db	0

;  247  "Invalid control statement"
	db	'Invalid control statement'
	db	0

;  248  "Attempted redefinition of system function"
	db	'Attempted redefinition '
	db	193
	db	'system function'
	db	0

;  249  "Expression evaluated by name returned value"
	db	234
	db	11
	db	207
	db	'value'
	db	0

;  250  "Insufficient memory to complete dump"
	db	'Insufficient memory '
	db	217
	db	'complete dump'
	db	0

;  251  "Keyword operand is not name of defined keyword"
	db	173
	db	222
	db	0

;  252  "Error on printing to interactive channel"
	db	'Err'
	db	167
	db	'on printing '
	db	217
	db	'interactive channel'
	db	0

;  253  "Print limit exceeded on standard output channel"
	db	'Print limit exceeded on standard output channel'
	db	0

;  254  "Erroneous argument for HOST"
	db	252
	db	2
	db	'f'
	db	167
	db	'HOST'
	db	0

;  255  "Error during execution of HOST"
	db	'Err'
	db	167
	db	225
	db	'execution '
	db	193
	db	'HOST'
	db	0

;  256  "SORT/RSORT 1st arg not suitable ARRAY or TABLE"
	db	175
	db	'1st '
	db	218
	db	20
	db	'suitable '
	db	160
	db	167
	db	'TABLE'
	db	0

;  257  "Erroneous 2nd arg in SORT/RSORT of vector"
	db	252
	db	'2nd '
	db	218
	db	201
	db	175
	db	193
	db	'vector'
	db	0

;  258  "SORT/RSORT 2nd arg out of range or non-integer"
	db	175
	db	198
	db	0

;  259  "FENCE argument is not pattern"
	db	'FENCE '
	db	1
	db	28
	db	0

;  260  "Conversion array size exceeds maximum permitted"
	db	'Conversion array '
	db	146
	db	0

;  261  "Addition caused real overflow"
	db	166
	db	15
	db	0

;  262  "Division caused real overflow"
	db	161
	db	15
	db	0

;  263  "Multiplication caused real overflow"
	db	134
	db	15
	db	0

;  264  "Subtraction caused real overflow"
	db	138
	db	15
	db	0

;  265  "External function argument is not real"
	db	156
	db	1
	db	'real'
	db	0

;  266  "Exponentiation caused real overflow"
	db	23
	db	15
	db	0

;  267  ""
	db	0

;  268  "Inconsistent value assigned to keyword PROFILE"
	db	'Inconsistent '
	db	158
	db	29
	db	'PROFILE'
	db	0

;  269  ""
	db	0

;  270  ""
	db	0

;  271  ""
	db	0

;  272  ""
	db	0

;  273  ""
	db	0

;  274  "Value assigned to keyword FULLSCAN is zero"
	db	194
	db	29
	db	'FULLSCAN '
	db	22
	db	'zero'
	db	0

;  275  ""
	db	0

;  276  ""
	db	0

;  277  ""
	db	0

;  278  ""
	db	0

;  279  ""
	db	0

;  280  ""
	db	0

;  281  "CHAR argument not integer"
	db	'CHAR '
	db	2
	db	20
	db	10
	db	0

;  282  "CHAR argument not in range"
	db	'CHAR '
	db	2
	db	20
	db	201
	db	'range'
	db	0

;  283  ""
	db	0

;  284  "Excessively nested INCLUDE files"
	db	'Excessively nested INCLUDE files'
	db	0

;  285  "INCLUDE file cannot be opened"
	db	'INCLUDE '
	db	199
	db	'opened'
	db	0

;  286  "Function call to undefined entry label"
	db	165
	db	190
	db	0

;  287  "Value assigned to keyword MAXLNGTH is too small"
	db	194
	db	29
	db	187
	db	22
	db	'too small'
	db	0

;  288  "EXIT second argument is not a string"
	db	223
	db	180
	db	0

;  289  "INPUT channel currently in use"
	db	233
	db	170
	db	0

;  290  "OUTPUT channel currently in use"
	db	227
	db	170
	db	0

;  291  "SET first argument is not a suitable name"
	db	213
	db	7
	db	26
	db	0

;  292  "SET first argument is null"
	db	213
	db	7
	db	159
	db	0

;  293  "Inappropriate second argument to SET"
	db	19
	db	9
	db	2
	db	217
	db	'SET'
	db	0

;  294  "Inappropriate third argument to SET"
	db	19
	db	'third '
	db	2
	db	217
	db	'SET'
	db	0

;  295  "SET file does not exist"
	db	213
	db	174
	db	0

;  296  "SET file does not permit setting file pointer"
	db	213
	db	152
	db	'setting '
	db	141
	db	'pointer'
	db	0

;  297  "SET caused non-recoverable I/O error"
	db	213
	db	12
	db	'I/O '
	db	150
	db	0

;  298  "External function argument is not file"
	db	156
	db	1
	db	'file'
	db	0

;  299  "Internal logic error: Unexpected PPM branch"
	db	'Internal logic '
	db	150
	db	': '
	db	239
	db	'PPM branch'
	db	0

;  300  ""
	db	0

;  301  "ATAN argument not numeric"
	db	'ATAN '
	db	144
	db	0

;  302  "CHOP argument not numeric"
	db	'CHOP '
	db	144
	db	0

;  303  "COS argument not numeric"
	db	'COS '
	db	144
	db	0

;  304  "EXP argument not numeric"
	db	'EXP '
	db	144
	db	0

;  305  "EXP produced real overflow"
	db	'EXP '
	db	30
	db	0

;  306  "LN argument not numeric"
	db	'LN '
	db	144
	db	0

;  307  "LN produced real overflow"
	db	'LN '
	db	30
	db	0

;  308  "SIN argument not numeric"
	db	'SIN '
	db	144
	db	0

;  309  "TAN argument not numeric"
	db	'TAN '
	db	144
	db	0

;  310  "TAN produced real overflow or argument is out of range"
	db	'TAN '
	db	30
	db	' '
	db	167
	db	204
	db	0

;  311  "Exponentiation of negative base to non-integral power"
	db	23
	db	193
	db	'negative base '
	db	217
	db	'non-integral power'
	db	0

;  312  "REMDR caused real overflow"
	db	197
	db	15
	db	0

;  313  "SQRT argument not numeric"
	db	'SQRT '
	db	144
	db	0

;  314  "SQRT argument negative"
	db	'SQRT '
	db	2
	db	'negative'
	db	0

;  315  "LN argument negative"
	db	'LN '
	db	2
	db	'negative'
	db	0

;  316  "BACKSPACE argument is not a suitable name"
	db	154
	db	26
	db	0

;  317  "BACKSPACE file does not exist"
	db	154
	db	174
	db	0

;  318  "BACKSPACE file does not permit backspace"
	db	154
	db	152
	db	'backspace'
	db	0

;  319  "BACKSPACE caused non-recoverable error"
	db	154
	db	12
	db	150
	db	0

;  320  "User interrupt"
	db	'User interrupt'
	db	0

;  321  "Goto SCONTINUE with no preceding error"
	db	235
	db	131
	db	0

;  322  "COS argument is out of range"
	db	'COS '
	db	204
	db	0

;  323  "SIN argument is out of range"
	db	'SIN '
	db	204
	db	0

;  324  ""
	db	0

;  325  ""
	db	0

;  326  "Calling external function - bad argument type"
	db	181
	db	'bad '
	db	2
	db	'type'
	db	0

;  327  "Calling external function - not found"
	db	181
	db	20
	db	'found'
	db	0

;  328  "LOAD function - insufficient memory"
	db	140
	db	13
	db	'- insufficient memory'
	db	0

;  329  "Requested MAXLNGTH too large"
	db	'Requested '
	db	187
	db	'too large'
	db	0

;  330  "DATE argument is not integer"
	db	'DATE '
	db	133
	db	0

;  331  "Goto SCONTINUE with no user interrupt"
	db	235
	db	'with no user interrupt'
	db	0

;  332  "Goto CONTINUE with error in failure goto"
	db	251
	db	'with '
	db	150
	db	' '
	db	201
	db	'failure goto'
	db	0

phrases:	db	0

;    1  "argument is not "
	db	2
	db	22
	db	20
	db	0

;    2  "argument "
	db	'argument '
	db	0

;    3  "operand is not "
	db	'operand '
	db	22
	db	20
	db	0

;    4  "argument is not a string"
	db	1
	db	'a '
	db	179
	db	0

;    5  "is negative or too large"
	db	22
	db	'negative '
	db	167
	db	'too large'
	db	0

;    6  "Syntax error: "
	db	'Syntax '
	db	150
	db	': '
	db	0

;    7  "first "
	db	'first '
	db	0

;    8  "numeric"
	db	'numeric'
	db	0

;    9  "second "
	db	'second '
	db	0

;   10  "integer"
	db	'integer'
	db	0

;   11  "evaluated "
	db	'evaluated '
	db	0

;   12  "caused non-recoverable "
	db	'caused non-recoverable '
	db	0

;   13  "function "
	db	'function '
	db	0

;   14  "overflow"
	db	'overflow'
	db	0

;   15  "caused real overflow"
	db	'caused real '
	db	14
	db	0

;   16  "file does not "
	db	141
	db	'does '
	db	20
	db	0

;   17  " or expression"
	db	' '
	db	167
	db	'expression'
	db	0

;   18  "caused integer overflow"
	db	'caused '
	db	10
	db	' '
	db	14
	db	0

;   19  "Inappropriate "
	db	'Inappropriate '
	db	0

;   20  "not "
	db	'not '
	db	0

;   21  "right "
	db	'right '
	db	0

;   22  "is "
	db	'is '
	db	0

;   23  "Exponentiation "
	db	'Exponentiation '
	db	0

;   24  "name"
	db	'name'
	db	0

;   25  "natural variable name"
	db	'natural variable '
	db	24
	db	0

;   26  "argument is not a suitable name"
	db	1
	db	'a suitable '
	db	24
	db	0

;   27  "argument is not appropriate name"
	db	1
	db	'appropriate '
	db	24
	db	0

;   28  "pattern"
	db	'pattern'
	db	0

;   29  "assigned to keyword "
	db	'assigned '
	db	217
	db	219
	db	' '
	db	0

;   30  "produced real overflow"
	db	'produced real '
	db	14
	db	0

;   31  "left operand is not numeric"
	db	'left '
	db	3
	db	8
	db	0

;  128  "third argument is not a string"
	db	'third '
	db	4
	db	0

;  129  "assignment left operand is not pattern"
	db	'assignment left '
	db	3
	db	28
	db	0

;  130  "missing "
	db	'missing '
	db	0

;  131  "with no preceding error"
	db	'with no preceding '
	db	150
	db	0

;  132  "out of range"
	db	'out '
	db	193
	db	'range'
	db	0

;  133  "argument is not integer"
	db	1
	db	10
	db	0

;  134  "Multiplication "
	db	'Multiplication '
	db	0

;  135  "operand is not a string or pattern"
	db	3
	db	'a '
	db	179
	db	' '
	db	167
	db	28
	db	0

;  136  "Goto "
	db	'Go'
	db	217
	db	0

;  137  "argument has null "
	db	2
	db	'has null '
	db	0

;  138  "Subtraction "
	db	'Subtraction '
	db	0

;  139  "Syntax error: Missing "
	db	6
	db	'Missing '
	db	0

;  140  "LOAD "
	db	'LOAD '
	db	0

;  141  "file "
	db	'file '
	db	0

;  142  "DEFINE "
	db	'DEFINE '
	db	0

;  143  "arg is not natural variable name"
	db	218
	db	22
	db	20
	db	25
	db	0

;  144  "argument not numeric"
	db	2
	db	20
	db	8
	db	0

;  145  "Syntax error: Invalid use of "
	db	6
	db	'Invalid use '
	db	193
	db	0

;  146  "size exceeds maximum permitted"
	db	'size exceeds maximum permitted'
	db	0

;  147  "dimension is zero, negative or out of range"
	db	'dimension '
	db	22
	db	'zero, negative '
	db	167
	db	132
	db	0

;  148  "argument is missing a left paren"
	db	2
	db	22
	db	130
	db	'a left paren'
	db	0

;  149  "ENDFILE "
	db	'ENDFILE '
	db	0

;  150  "error"
	db	'error'
	db	0

;  151  "action caused irrecoverable error"
	db	'action caused irrecoverable '
	db	150
	db	0

;  152  "file does not permit "
	db	16
	db	'permit '
	db	0

;  153  "datatype name"
	db	'datatype '
	db	24
	db	0

;  154  "BACKSPACE "
	db	'BACKSPACE '
	db	0

;  155  "program function name"
	db	'program '
	db	13
	db	24
	db	0

;  156  "External function "
	db	'External '
	db	13
	db	0

;  157  "argument is not numeric"
	db	1
	db	8
	db	0

;  158  "value "
	db	'value '
	db	0

;  159  "argument is null"
	db	2
	db	22
	db	'null'
	db	0

;  160  "ARRAY "
	db	'ARRAY '
	db	0

;  161  "Division "
	db	'Division '
	db	0

;  162  "caused non-recoverable output error"
	db	12
	db	'output '
	db	150
	db	0

;  163  "REWIND "
	db	'REWIND '
	db	0

;  164  "first arg is not correct operator name"
	db	7
	db	218
	db	22
	db	20
	db	'correct operat'
	db	167
	db	24
	db	0

;  165  "Function "
	db	'Function '
	db	0

;  166  "Addition "
	db	'Addition '
	db	0

;  167  "or "
	db	'or '
	db	0

;  168  "first argument is not a string"
	db	7
	db	4
	db	0

;  169  "bound is not integer"
	db	'bound '
	db	22
	db	20
	db	10
	db	0

;  170  "channel currently in use"
	db	'channel currently '
	db	201
	db	'use'
	db	0

;  171  "argument is negative or too large"
	db	2
	db	5
	db	0

;  172  "Pattern "
	db	'Pattern '
	db	0

;  173  "Keyword "
	db	'Keyword '
	db	0

;  174  "file does not exist"
	db	16
	db	'exist'
	db	0

;  175  "SORT/RSORT "
	db	'SORT/RSORT '
	db	0

;  176  "DATA "
	db	'DATA '
	db	0

;  177  "result in NRETURN is not name"
	db	'result '
	db	201
	db	'NRETURN '
	db	22
	db	20
	db	24
	db	0

;  178  "OPSYN "
	db	'OPSYN '
	db	0

;  179  "string"
	db	'string'
	db	0

;  180  "second argument is not a string"
	db	9
	db	4
	db	0

;  181  "Calling external function - "
	db	'Calling external '
	db	13
	db	'- '
	db	0

;  182  "third argument is not integer"
	db	'third '
	db	133
	db	0

;  183  "Undefined "
	db	'Undefined '
	db	0

;  184  "does not evaluate to pattern"
	db	'does '
	db	20
	db	'evaluate '
	db	217
	db	28
	db	0

;  185  "right operand is not numeric"
	db	21
	db	3
	db	8
	db	0

;  186  "Inappropriate file specification for "
	db	19
	db	141
	db	'specification f'
	db	167
	db	0

;  187  "MAXLNGTH "
	db	'MAXLNGTH '
	db	0

;  188  "replacement right operand is not a string"
	db	'replacement '
	db	21
	db	3
	db	'a '
	db	179
	db	0

;  189  "label"
	db	'label'
	db	0

;  190  "call to undefined entry label"
	db	'call '
	db	217
	db	'undefined entry '
	db	189
	db	0

;  191  "function entry point is not defined label"
	db	13
	db	'entry point '
	db	22
	db	20
	db	'defined '
	db	189
	db	0

;  192  "Undefined or erroneous entry label"
	db	183
	db	167
	db	'erroneous entry '
	db	189
	db	0

;  193  "of "
	db	'of '
	db	0

;  194  "Value "
	db	'Value '
	db	0

;  195  "referenced with "
	db	'referenced with '
	db	0

;  196  "EJECT "
	db	'EJECT '
	db	0

;  197  "REMDR "
	db	'REMDR '
	db	0

;  198  "2nd arg out of range or non-integer"
	db	'2nd '
	db	218
	db	132
	db	' '
	db	167
	db	'non-'
	db	10
	db	0

;  199  "file cannot be "
	db	141
	db	'can'
	db	20
	db	'be '
	db	0

;  200  "REPLACE "
	db	'REPLACE '
	db	0

;  201  "in "
	db	'in '
	db	0

;  202  "first argument is not suitable integer or string"
	db	7
	db	1
	db	'suitable '
	db	10
	db	' '
	db	167
	db	179
	db	0

;  203  "match left operand is not a string"
	db	'match left '
	db	3
	db	'a '
	db	179
	db	0

;  204  "argument is out of range"
	db	2
	db	22
	db	132
	db	0

;  205  "second argument is not numeric"
	db	9
	db	157
	db	0

;  206  "Concatenation "
	db	'Concatenation '
	db	0

;  207  "by name returned "
	db	'by '
	db	24
	db	' returned '
	db	0

;  208  "second argument is not integer"
	db	9
	db	133
	db	0

;  209  "first argument is not numeric"
	db	7
	db	157
	db	0

;  210  "subscript is not integer"
	db	'subscript '
	db	22
	db	20
	db	10
	db	0

;  211  "RPOS "
	db	'R'
	db	245
	db	0

;  212  "assigned to keyword ERRTEXT not a string"
	db	29
	db	'ERRTEXT '
	db	20
	db	'a '
	db	179
	db	0

;  213  "SET "
	db	'SET '
	db	0

;  214  "SUBSTR "
	db	'SUBSTR '
	db	0

;  215  "Syntax error: Unbalanced right "
	db	6
	db	'Unbalanced '
	db	21
	db	0

;  216  "bracket"
	db	'bracket'
	db	0

;  217  "to "
	db	'to '
	db	0

;  218  "arg "
	db	'arg '
	db	0

;  219  "keyword"
	db	'keyword'
	db	0

;  220  "count exceeds value of STLIMIT keyword"
	db	'count exceeds '
	db	158
	db	193
	db	'STLIMIT '
	db	219
	db	0

;  221  "length exceeds value of MAXLNGTH keyword"
	db	'length exceeds '
	db	158
	db	193
	db	187
	db	219
	db	0

;  222  "operand is not name of defined keyword"
	db	3
	db	24
	db	' '
	db	193
	db	'defined '
	db	219
	db	0

;  223  "EXIT "
	db	'EXIT '
	db	0

;  224  "RTAB "
	db	'R'
	db	248
	db	0

;  225  "during "
	db	'during '
	db	0

;  226  "value assigned is not integer"
	db	158
	db	'assigned '
	db	22
	db	20
	db	10
	db	0

;  227  "OUTPUT "
	db	231
	db	' '
	db	0

;  228  "from "
	db	'from '
	db	0

;  229  "Alternation "
	db	'Alternation '
	db	0

;  230  "second argument is not trace type"
	db	9
	db	1
	db	'trace type'
	db	0

;  231  "OUTPUT"
	db	'OUTPUT'
	db	0

;  232  "value assigned is negative or too large"
	db	158
	db	'assigned '
	db	5
	db	0

;  233  "INPUT "
	db	'INPUT '
	db	0

;  234  "Expression "
	db	'Expression '
	db	0

;  235  "Goto SCONTINUE "
	db	136
	db	'SCONTINUE '
	db	0

;  236  "undefined label"
	db	'undefined '
	db	189
	db	0

;  237  "argument is missing a right paren"
	db	2
	db	22
	db	130
	db	'a '
	db	21
	db	'paren'
	db	0

;  238  "Duplicate label"
	db	'Duplicate '
	db	189
	db	0

;  239  "Unexpected "
	db	'Unexpected '
	db	0

;  240  "argument has null variable name"
	db	137
	db	'variable '
	db	24
	db	0

;  241  "TRACE "
	db	'TRACE '
	db	0

;  242  "FIELD "
	db	'FIELD '
	db	0

;  243  "Statement "
	db	'Statement '
	db	0

;  244  "evaluated argument is not a string"
	db	11
	db	4
	db	0

;  245  "POS "
	db	'POS '
	db	0

;  246  "argument for OUTPUT"
	db	2
	db	'f'
	db	167
	db	231
	db	0

;  247  "argument is not a string or expression"
	db	4
	db	17
	db	0

;  248  "TAB "
	db	'TAB '
	db	0

;  249  "evaluated argument is not integer"
	db	11
	db	133
	db	0

;  250  "evaluated argument is negative or too large"
	db	11
	db	171
	db	0

;  251  "Goto CONTINUE "
	db	136
	db	'CONTINUE '
	db	0

;  252  "Erroneous "
	db	'Erroneous '
	db	0

;  253  "argument is not integer or expression"
	db	133
	db	17
	db	0

;  254  "LEN "
	db	'LEN '
	db	0

;  255  "first argument has null function name"
	db	7
	db	137
	db	13
	db	24
	db	0


