# compressed spitbol error messages 04/11/45 00:53:52


	.global	_errors
_errors:	.byte	0

#    1  "addition left operand is not numeric"
	.byte	166
	.byte	128
	.byte	0

#    2  "addition right operand is not numeric"
	.byte	166
	.byte	182
	.byte	0

#    3  "addition caused integer overflow"
	.byte	166
	.byte	139
	.byte	0

#    4  "affirmation operand is not numeric"
	.ascii	"affirmation "
	.byte	3
	.byte	8
	.byte	0

#    5  "alternation right operand is not pattern"
	.byte	228
	.byte	21
	.byte	3
	.byte	30
	.byte	0

#    6  "alternation left operand is not pattern"
	.byte	228
	.ascii	"left "
	.byte	3
	.byte	30
	.byte	0

#    7  "compilation error encountered during execution"
	.ascii	"compilation "
	.byte	154
	.ascii	" encountered "
	.byte	213
	.ascii	"execution"
	.byte	0

#    8  "concatenation left operand is not a string or pattern"
	.byte	205
	.ascii	"left "
	.byte	138
	.byte	0

#    9  "concatenation right operand is not a string or pattern"
	.byte	205
	.byte	21
	.byte	138
	.byte	0

#   10  "negation operand is not numeric"
	.ascii	"negation "
	.byte	3
	.byte	8
	.byte	0

#   11  "negation caused integer overflow"
	.ascii	"negation "
	.byte	139
	.byte	0

#   12  "division left operand is not numeric"
	.byte	162
	.byte	128
	.byte	0

#   13  "division right operand is not numeric"
	.byte	162
	.byte	182
	.byte	0

#   14  "division caused integer overflow"
	.byte	162
	.byte	139
	.byte	0

#   15  "exponentiation right operand is not numeric"
	.byte	25
	.byte	182
	.byte	0

#   16  "exponentiation left operand is not numeric"
	.byte	25
	.byte	128
	.byte	0

#   17  "exponentiation caused integer overflow"
	.byte	25
	.byte	139
	.byte	0

#   18  "exponentiation result is undefined"
	.byte	25
	.ascii	"result "
	.byte	24
	.ascii	"undefined"
	.byte	0

#   19  ""
	.byte	0

#   20  "goto evaluation failure"
	.byte	130
	.ascii	"evaluation failure"
	.byte	0

#   21  "function called by name returned a value"
	.byte	10
	.ascii	"called "
	.byte	204
	.ascii	"a value"
	.byte	0

#   22  "undefined function called"
	.byte	142
	.byte	10
	.ascii	"called"
	.byte	0

#   23  "goto operand is not a natural variable"
	.byte	130
	.byte	3
	.ascii	"a natural variable"
	.byte	0

#   24  "goto operand in direct goto is not code"
	.byte	130
	.ascii	"operand "
	.byte	202
	.ascii	"direct "
	.byte	130
	.byte	24
	.byte	19
	.ascii	"code"
	.byte	0

#   25  "immediate assignment left operand is not pattern"
	.ascii	"immediate "
	.byte	129
	.byte	0

#   26  "multiplication left operand is not numeric"
	.byte	137
	.byte	128
	.byte	0

#   27  "multiplication right operand is not numeric"
	.byte	137
	.byte	182
	.byte	0

#   28  "multiplication caused integer overflow"
	.byte	137
	.byte	139
	.byte	0

#   29  "undefined operator referenced"
	.byte	142
	.ascii	"operat"
	.byte	165
	.ascii	"referenced"
	.byte	0

#   30  "pattern assignment left operand is not pattern"
	.byte	30
	.ascii	" "
	.byte	129
	.byte	0

#   31  "pattern replacement right operand is not a string"
	.byte	30
	.byte	187
	.byte	0

#   32  "subtraction left operand is not numeric"
	.byte	143
	.byte	128
	.byte	0

#   33  "subtraction right operand is not numeric"
	.byte	143
	.byte	182
	.byte	0

#   34  "subtraction caused integer overflow"
	.byte	143
	.byte	139
	.byte	0

#   35  "unexpected failure in -nofail mode"
	.byte	233
	.ascii	"failure "
	.byte	202
	.ascii	"-nofail mode"
	.byte	0

#   36  "goto abort with no preceding error"
	.byte	130
	.ascii	"abort "
	.byte	134
	.byte	0

#   37  "goto continue with no preceding error"
	.byte	243
	.byte	134
	.byte	0

#   38  "goto undefined label"
	.byte	130
	.byte	142
	.byte	188
	.byte	0

#   39  "external function argument is not a string"
	.byte	132
	.byte	4
	.byte	0

#   40  "external function argument is not integer"
	.byte	132
	.byte	135
	.byte	0

#   41  "field function argument is wrong datatype"
	.byte	174
	.byte	10
	.byte	2
	.byte	24
	.ascii	"wrong datatype"
	.byte	0

#   42  "attempt to change value of protected variable"
	.ascii	"attempt "
	.byte	201
	.ascii	"change "
	.byte	160
	.byte	192
	.ascii	"protected variable"
	.byte	0

#   43  "any evaluated argument is not a string"
	.ascii	"any "
	.byte	253
	.byte	0

#   44  "break evaluated argument is not a string"
	.ascii	"break "
	.byte	253
	.byte	0

#   45  "breakx evaluated argument is not a string"
	.ascii	"breakx "
	.byte	253
	.byte	0

#   46  "expression does not evaluate to pattern"
	.byte	239
	.byte	184
	.byte	0

#   47  "len evaluated argument is not integer"
	.byte	250
	.byte	248
	.byte	0

#   48  "len evaluated argument is negative or too large"
	.byte	250
	.byte	240
	.byte	0

#   49  "notany evaluated argument is not a string"
	.ascii	"notany "
	.byte	253
	.byte	0

#   50  "pos evaluated argument is not integer"
	.byte	251
	.byte	248
	.byte	0

#   51  "pos evaluated argument is negative or too large"
	.byte	251
	.byte	240
	.byte	0

#   52  "rpos evaluated argument is not integer"
	.byte	224
	.byte	248
	.byte	0

#   53  "rpos evaluated argument is negative or too large"
	.byte	224
	.byte	240
	.byte	0

#   54  "rtab evaluated argument is not integer"
	.byte	210
	.byte	248
	.byte	0

#   55  "rtab evaluated argument is negative or too large"
	.byte	210
	.byte	240
	.byte	0

#   56  "span evaluated argument is not a string"
	.ascii	"span "
	.byte	253
	.byte	0

#   57  "tab evaluated argument is not integer"
	.byte	247
	.byte	248
	.byte	0

#   58  "tab evaluated argument is negative or too large"
	.byte	247
	.byte	240
	.byte	0

#   59  "any argument is not a string or expression"
	.ascii	"any "
	.byte	242
	.byte	0

#   60  "apply first arg is not natural variable name"
	.ascii	"apply "
	.byte	7
	.byte	196
	.byte	0

#   61  "arbno argument is not pattern"
	.ascii	"arbno "
	.byte	1
	.byte	30
	.byte	0

#   62  "arg second argument is not integer"
	.byte	144
	.byte	206
	.byte	0

#   63  "arg first argument is not program function name"
	.byte	144
	.byte	7
	.byte	1
	.byte	156
	.byte	0

#   64  "array first argument is not integer or string"
	.byte	131
	.byte	7
	.byte	135
	.ascii	" "
	.byte	165
	.byte	178
	.byte	0

#   65  "array first argument lower bound is not integer"
	.byte	131
	.byte	7
	.byte	2
	.ascii	"lower "
	.byte	164
	.byte	0

#   66  "array first argument upper bound is not integer"
	.byte	131
	.byte	255
	.byte	0

#   67  "array dimension is zero, negative or out of range"
	.byte	131
	.byte	151
	.byte	0

#   68  "array size exceeds maximum permitted"
	.byte	131
	.byte	150
	.byte	0

#   69  "break argument is not a string or expression"
	.ascii	"break "
	.byte	242
	.byte	0

#   70  "breakx argument is not a string or expression"
	.ascii	"breakx "
	.byte	242
	.byte	0

#   71  "clear argument is not a string"
	.ascii	"clear "
	.byte	4
	.byte	0

#   72  "clear argument has null variable name"
	.ascii	"clear "
	.byte	238
	.byte	0

#   73  "collect argument is not integer"
	.ascii	"collect "
	.byte	135
	.byte	0

#   74  "convert second argument is not a string"
	.ascii	"convert "
	.byte	181
	.byte	0

#   75  "data argument is not a string"
	.byte	177
	.byte	4
	.byte	0

#   76  "data argument is null"
	.byte	177
	.byte	159
	.byte	0

#   77  "data argument is missing a left paren"
	.byte	177
	.byte	152
	.byte	0

#   78  "data argument has null datatype name"
	.byte	177
	.byte	141
	.byte	155
	.byte	0

#   79  "data argument is missing a right paren"
	.byte	177
	.byte	235
	.byte	0

#   80  "data argument has null field name"
	.byte	177
	.byte	141
	.byte	174
	.byte	26
	.byte	0

#   81  "define first argument is not a string"
	.byte	147
	.byte	167
	.byte	0

#   82  "define first argument is null"
	.byte	147
	.byte	7
	.byte	159
	.byte	0

#   83  "define first argument is missing a left paren"
	.byte	147
	.byte	7
	.byte	152
	.byte	0

#   84  "define first argument has null function name"
	.byte	147
	.byte	246
	.byte	0

#   85  "null arg name or missing ) in define first arg."
	.ascii	"null "
	.byte	144
	.byte	26
	.ascii	" "
	.byte	165
	.byte	20
	.ascii	") "
	.byte	202
	.byte	147
	.byte	7
	.ascii	"arg."
	.byte	0

#   86  "define function entry point is not defined label"
	.byte	147
	.byte	189
	.byte	0

#   87  "detach argument is not appropriate name"
	.ascii	"detach "
	.byte	29
	.byte	0

#   88  "dump argument is not integer"
	.ascii	"dump "
	.byte	135
	.byte	0

#   89  "dump argument is negative or too large"
	.ascii	"dump "
	.byte	168
	.byte	0

#   90  "dupl second argument is not integer"
	.ascii	"dupl "
	.byte	206
	.byte	0

#   91  "dupl first argument is not a string or pattern"
	.ascii	"dupl "
	.byte	167
	.ascii	" "
	.byte	165
	.byte	30
	.byte	0

#   92  "eject argument is not a suitable name"
	.byte	195
	.byte	28
	.byte	0

#   93  "eject file does not exist"
	.byte	195
	.byte	176
	.byte	0

#   94  "eject file does not permit page eject"
	.byte	195
	.byte	153
	.ascii	"page eject"
	.byte	0

#   95  "eject caused non-recoverable output error"
	.byte	195
	.byte	17
	.byte	136
	.byte	154
	.byte	0

#   96  "endfile argument is not a suitable name"
	.byte	223
	.byte	28
	.byte	0

#   97  "endfile argument is null"
	.byte	223
	.byte	159
	.byte	0

#   98  "endfile file does not exist"
	.byte	223
	.byte	176
	.byte	0

#   99  "endfile file does not permit endfile"
	.byte	223
	.byte	153
	.ascii	"endfile"
	.byte	0

#  100  "endfile caused non-recoverable output error"
	.byte	223
	.byte	17
	.byte	136
	.byte	154
	.byte	0

#  101  "eq first argument is not numeric"
	.ascii	"eq "
	.byte	208
	.byte	0

#  102  "eq second argument is not numeric"
	.ascii	"eq "
	.byte	207
	.byte	0

#  103  "eval argument is not expression"
	.ascii	"eval "
	.byte	1
	.ascii	"expression"
	.byte	0

#  104  "exit first argument is not suitable integer or string"
	.byte	211
	.byte	244
	.byte	0

#  105  "exit action not available in this implementation"
	.byte	211
	.ascii	"action "
	.byte	19
	.ascii	"available "
	.byte	202
	.ascii	"th"
	.byte	24
	.ascii	"implementation"
	.byte	0

#  106  "exit action caused irrecoverable error"
	.byte	211
	.byte	170
	.byte	0

#  107  "field second argument is not integer"
	.byte	174
	.byte	206
	.byte	0

#  108  "field first argument is not datatype name"
	.byte	174
	.byte	7
	.byte	1
	.byte	155
	.byte	0

#  109  "ge first argument is not numeric"
	.ascii	"ge "
	.byte	208
	.byte	0

#  110  "ge second argument is not numeric"
	.ascii	"ge "
	.byte	207
	.byte	0

#  111  "gt first argument is not numeric"
	.ascii	"gt "
	.byte	208
	.byte	0

#  112  "gt second argument is not numeric"
	.ascii	"gt "
	.byte	207
	.byte	0

#  113  "input third argument is not a string"
	.byte	161
	.byte	31
	.byte	0

#  114  "inappropriate second argument for input"
	.byte	18
	.byte	9
	.byte	2
	.ascii	"f"
	.byte	165
	.ascii	"input"
	.byte	0

#  115  "inappropriate first argument for input"
	.byte	18
	.byte	7
	.byte	2
	.ascii	"f"
	.byte	165
	.ascii	"input"
	.byte	0

#  116  "inappropriate file specification for input"
	.byte	186
	.ascii	"input"
	.byte	0

#  117  "input file cannot be read"
	.byte	161
	.byte	200
	.ascii	"read"
	.byte	0

#  118  "le first argument is not numeric"
	.ascii	"le "
	.byte	208
	.byte	0

#  119  "le second argument is not numeric"
	.ascii	"le "
	.byte	207
	.byte	0

#  120  "len argument is not integer or expression"
	.byte	250
	.byte	241
	.byte	0

#  121  "len argument is negative or too large"
	.byte	250
	.byte	168
	.byte	0

#  122  "leq first argument is not a string"
	.ascii	"leq "
	.byte	167
	.byte	0

#  123  "leq second argument is not a string"
	.ascii	"leq "
	.byte	181
	.byte	0

#  124  "lge first argument is not a string"
	.ascii	"lge "
	.byte	167
	.byte	0

#  125  "lge second argument is not a string"
	.ascii	"lge "
	.byte	181
	.byte	0

#  126  "lgt first argument is not a string"
	.ascii	"lgt "
	.byte	167
	.byte	0

#  127  "lgt second argument is not a string"
	.ascii	"lgt "
	.byte	181
	.byte	0

#  128  "lle first argument is not a string"
	.ascii	"lle "
	.byte	167
	.byte	0

#  129  "lle second argument is not a string"
	.ascii	"lle "
	.byte	181
	.byte	0

#  130  "llt first argument is not a string"
	.ascii	"llt "
	.byte	167
	.byte	0

#  131  "llt second argument is not a string"
	.ascii	"llt "
	.byte	181
	.byte	0

#  132  "lne first argument is not a string"
	.ascii	"lne "
	.byte	167
	.byte	0

#  133  "lne second argument is not a string"
	.ascii	"lne "
	.byte	181
	.byte	0

#  134  "local second argument is not integer"
	.ascii	"local "
	.byte	206
	.byte	0

#  135  "local first arg is not a program function name"
	.ascii	"local "
	.byte	7
	.byte	144
	.byte	24
	.byte	19
	.ascii	"a "
	.byte	156
	.byte	0

#  136  "load second argument is not a string"
	.byte	146
	.byte	181
	.byte	0

#  137  "load first argument is not a string"
	.byte	146
	.byte	167
	.byte	0

#  138  "load first argument is null"
	.byte	146
	.byte	7
	.byte	159
	.byte	0

#  139  "load first argument is missing a left paren"
	.byte	146
	.byte	7
	.byte	152
	.byte	0

#  140  "load first argument has null function name"
	.byte	146
	.byte	246
	.byte	0

#  141  "load first argument is missing a right paren"
	.byte	146
	.byte	7
	.byte	235
	.byte	0

#  142  "load function does not exist"
	.byte	146
	.byte	10
	.ascii	"does "
	.byte	19
	.ascii	"exist"
	.byte	0

#  143  "load function caused input error during load"
	.byte	146
	.byte	10
	.byte	13
	.byte	161
	.byte	154
	.ascii	" "
	.byte	213
	.ascii	"load"
	.byte	0

#  144  "lpad third argument is not a string"
	.ascii	"lpad "
	.byte	31
	.byte	0

#  145  "lpad second argument is not integer"
	.ascii	"lpad "
	.byte	206
	.byte	0

#  146  "lpad first argument is not a string"
	.ascii	"lpad "
	.byte	167
	.byte	0

#  147  "lt first argument is not numeric"
	.ascii	"lt "
	.byte	208
	.byte	0

#  148  "lt second argument is not numeric"
	.ascii	"lt "
	.byte	207
	.byte	0

#  149  "ne first argument is not numeric"
	.ascii	"ne "
	.byte	208
	.byte	0

#  150  "ne second argument is not numeric"
	.ascii	"ne "
	.byte	207
	.byte	0

#  151  "notany argument is not a string or expression"
	.ascii	"notany "
	.byte	242
	.byte	0

#  152  "opsyn third argument is not integer"
	.byte	179
	.byte	183
	.byte	0

#  153  "opsyn third argument is negative or too large"
	.byte	179
	.ascii	"third "
	.byte	168
	.byte	0

#  154  "opsyn second arg is not natural variable name"
	.byte	179
	.byte	9
	.byte	196
	.byte	0

#  155  "opsyn first arg is not natural variable name"
	.byte	179
	.byte	7
	.byte	196
	.byte	0

#  156  "opsyn first arg is not correct operator name"
	.byte	179
	.byte	180
	.byte	0

#  157  "output third argument is not a string"
	.byte	136
	.byte	31
	.byte	0

#  158  "inappropriate second argument for output"
	.byte	18
	.byte	9
	.byte	245
	.byte	0

#  159  "inappropriate first argument for output"
	.byte	18
	.byte	7
	.byte	245
	.byte	0

#  160  "inappropriate file specification for output"
	.byte	186
	.byte	237
	.byte	0

#  161  "output file cannot be written to"
	.byte	136
	.byte	200
	.ascii	"written to"
	.byte	0

#  162  "pos argument is not integer or expression"
	.byte	251
	.byte	241
	.byte	0

#  163  "pos argument is negative or too large"
	.byte	251
	.byte	168
	.byte	0

#  164  "prototype argument is not valid object"
	.ascii	"prototype "
	.byte	1
	.ascii	"valid object"
	.byte	0

#  165  "remdr second argument is not numeric"
	.byte	197
	.byte	207
	.byte	0

#  166  "remdr first argument is not numeric"
	.byte	197
	.byte	208
	.byte	0

#  167  "remdr caused integer overflow"
	.byte	197
	.byte	139
	.byte	0

#  168  "replace third argument is not a string"
	.byte	203
	.byte	31
	.byte	0

#  169  "replace second argument is not a string"
	.byte	203
	.byte	181
	.byte	0

#  170  "replace first argument is not a string"
	.byte	203
	.byte	167
	.byte	0

#  171  "null or unequally long 2nd, 3rd args to replace"
	.ascii	"null "
	.byte	165
	.ascii	"unequally long 2nd, 3rd args "
	.byte	201
	.ascii	"replace"
	.byte	0

#  172  "rewind argument is not a suitable name"
	.byte	163
	.byte	28
	.byte	0

#  173  "rewind argument is null"
	.byte	163
	.byte	159
	.byte	0

#  174  "rewind file does not exist"
	.byte	163
	.byte	176
	.byte	0

#  175  "rewind file does not permit rewind"
	.byte	163
	.byte	153
	.ascii	"rewind"
	.byte	0

#  176  "rewind caused non-recoverable error"
	.byte	163
	.byte	17
	.byte	154
	.byte	0

#  177  "reverse argument is not a string"
	.ascii	"reverse "
	.byte	4
	.byte	0

#  178  "rpad third argument is not a string"
	.ascii	"rpad "
	.byte	31
	.byte	0

#  179  "rpad second argument is not integer"
	.ascii	"rpad "
	.byte	206
	.byte	0

#  180  "rpad first argument is not a string"
	.ascii	"rpad "
	.byte	167
	.byte	0

#  181  "rtab argument is not integer or expression"
	.byte	210
	.byte	241
	.byte	0

#  182  "rtab argument is negative or too large"
	.byte	210
	.byte	168
	.byte	0

#  183  "tab argument is not integer or expression"
	.byte	247
	.byte	241
	.byte	0

#  184  "tab argument is negative or too large"
	.byte	247
	.byte	168
	.byte	0

#  185  "rpos argument is not integer or expression"
	.byte	224
	.byte	241
	.byte	0

#  186  "rpos argument is negative or too large"
	.byte	224
	.byte	168
	.byte	0

#  187  "setexit argument is not label name or null"
	.ascii	"set"
	.byte	211
	.byte	1
	.byte	188
	.ascii	" "
	.byte	26
	.ascii	" "
	.byte	165
	.ascii	"null"
	.byte	0

#  188  "span argument is not a string or expression"
	.ascii	"span "
	.byte	242
	.byte	0

#  189  "size argument is not a string"
	.ascii	"size "
	.byte	4
	.byte	0

#  190  "stoptr first argument is not appropriate name"
	.ascii	"stoptr "
	.byte	7
	.byte	29
	.byte	0

#  191  "stoptr second argument is not trace type"
	.ascii	"stoptr "
	.byte	9
	.byte	1
	.byte	175
	.ascii	"type"
	.byte	0

#  192  "substr third argument is not integer"
	.byte	215
	.byte	183
	.byte	0

#  193  "substr second argument is not integer"
	.byte	215
	.byte	206
	.byte	0

#  194  "substr first argument is not a string"
	.byte	215
	.byte	167
	.byte	0

#  195  "table argument is not integer"
	.byte	193
	.byte	135
	.byte	0

#  196  "table argument is out of range"
	.byte	193
	.byte	199
	.byte	0

#  197  "trace fourth arg is not function name or null"
	.byte	175
	.ascii	"fourth "
	.byte	144
	.byte	24
	.byte	19
	.byte	10
	.byte	26
	.ascii	" "
	.byte	165
	.ascii	"null"
	.byte	0

#  198  "trace first argument is not appropriate name"
	.byte	175
	.byte	7
	.byte	29
	.byte	0

#  199  "trace second argument is not trace type"
	.byte	175
	.byte	9
	.byte	1
	.byte	175
	.ascii	"type"
	.byte	0

#  200  "trim argument is not a string"
	.ascii	"trim "
	.byte	4
	.byte	0

#  201  "unload argument is not natural variable name"
	.ascii	"un"
	.byte	146
	.byte	1
	.byte	27
	.byte	0

#  202  "input from file caused non-recoverable error"
	.byte	161
	.byte	209
	.byte	145
	.byte	17
	.byte	154
	.byte	0

#  203  "input file record has incorrect format"
	.byte	161
	.byte	145
	.ascii	"record has incorrect format"
	.byte	0

#  204  "memory overflow"
	.ascii	"memory "
	.byte	14
	.byte	0

#  205  "string length exceeds value of maxlngth keyword"
	.byte	178
	.byte	218
	.byte	0

#  206  "output caused file overflow"
	.byte	136
	.byte	13
	.byte	145
	.byte	14
	.byte	0

#  207  "output caused non-recoverable error"
	.byte	136
	.byte	17
	.byte	154
	.byte	0

#  208  "keyword value assigned is not integer"
	.byte	171
	.byte	214
	.byte	0

#  209  "keyword in assignment is protected"
	.byte	171
	.byte	202
	.ascii	"assignment "
	.byte	24
	.ascii	"protected"
	.byte	0

#  210  "keyword value assigned is negative or too large"
	.byte	171
	.byte	231
	.byte	0

#  211  "value assigned to keyword errtext not a string"
	.byte	23
	.byte	229
	.byte	0

#  212  "syntax error: value used where name is required"
	.byte	6
	.byte	160
	.ascii	"used where "
	.byte	26
	.ascii	" "
	.byte	24
	.ascii	"required"
	.byte	0

#  213  "syntax error: _statement is too complicated."
	.byte	6
	.byte	249
	.byte	24
	.ascii	"too complicated."
	.byte	0

#  214  "bad label or misplaced continuation line"
	.ascii	"bad "
	.byte	188
	.ascii	" "
	.byte	165
	.ascii	"misplaced continuation line"
	.byte	0

#  215  "syntax error: undefined or erroneous entry label"
	.byte	6
	.byte	142
	.byte	165
	.byte	185
	.byte	190
	.byte	0

#  216  "syntax error: missing end line"
	.byte	6
	.byte	20
	.ascii	"end line"
	.byte	0

#  217  "syntax error: duplicate label"
	.byte	6
	.byte	230
	.byte	0

#  218  "syntax error: duplicated goto field"
	.byte	6
	.ascii	"duplicated "
	.byte	130
	.ascii	"field"
	.byte	0

#  219  "syntax error: empty goto field"
	.byte	6
	.ascii	"empty "
	.byte	130
	.ascii	"field"
	.byte	0

#  220  "syntax error: missing operator"
	.byte	6
	.byte	20
	.ascii	"operator"
	.byte	0

#  221  "syntax error: missing operand"
	.byte	6
	.byte	20
	.ascii	"operand"
	.byte	0

#  222  "syntax error: invalid use of left bracket"
	.byte	149
	.ascii	"left "
	.byte	220
	.byte	0

#  223  "syntax error: invalid use of comma"
	.byte	149
	.ascii	"comma"
	.byte	0

#  224  "syntax error: unbalanced right parenthesis"
	.byte	6
	.ascii	"unbalanced "
	.byte	234
	.ascii	"thesis"
	.byte	0

#  225  "syntax error: unbalanced right bracket"
	.byte	6
	.byte	221
	.byte	0

#  226  "syntax error: missing right paren"
	.byte	6
	.byte	20
	.byte	234
	.byte	0

#  227  "syntax error: right paren missing from goto"
	.byte	6
	.byte	234
	.ascii	" "
	.byte	20
	.byte	209
	.ascii	"goto"
	.byte	0

#  228  "syntax error: right bracket missing from goto"
	.byte	6
	.byte	21
	.byte	220
	.ascii	" "
	.byte	20
	.byte	209
	.ascii	"goto"
	.byte	0

#  229  "syntax error: missing right array bracket"
	.byte	6
	.byte	20
	.byte	21
	.byte	131
	.byte	220
	.byte	0

#  230  "syntax error: illegal character"
	.byte	6
	.ascii	"illegal character"
	.byte	0

#  231  "syntax error: invalid numeric item"
	.byte	6
	.ascii	"invalid "
	.byte	8
	.ascii	" item"
	.byte	0

#  232  "syntax error: unmatched string quote"
	.byte	6
	.ascii	"unmatched "
	.byte	178
	.ascii	" quote"
	.byte	0

#  233  "syntax error: invalid use of operator"
	.byte	149
	.ascii	"operator"
	.byte	0

#  234  "syntax error: goto field incorrect"
	.byte	6
	.byte	130
	.byte	174
	.ascii	"incorrect"
	.byte	0

#  235  "subscripted operand is not table or array"
	.ascii	"subscripted "
	.byte	3
	.byte	193
	.byte	165
	.ascii	"array"
	.byte	0

#  236  "array referenced with wrong number of subscripts"
	.byte	131
	.byte	198
	.ascii	"wrong number "
	.byte	192
	.ascii	"subscripts"
	.byte	0

#  237  "table referenced with more than one subscript"
	.byte	193
	.byte	198
	.ascii	"more than one subscript"
	.byte	0

#  238  "array subscript is not integer"
	.byte	131
	.byte	212
	.byte	0

#  239  "indirection operand is not name"
	.ascii	"indirection "
	.byte	3
	.byte	26
	.byte	0

#  240  "pattern match right operand is not pattern"
	.byte	30
	.byte	252
	.byte	0

#  241  "pattern match left operand is not a string"
	.byte	30
	.byte	194
	.byte	0

#  242  "function return from level zero"
	.byte	10
	.ascii	"return "
	.byte	209
	.ascii	"level zero"
	.byte	0

#  243  "function result in nreturn is not name"
	.byte	10
	.byte	172
	.byte	0

#  244  "_statement count exceeds value of stlimit keyword"
	.byte	249
	.byte	217
	.byte	0

#  245  "translation/execution time expired"
	.ascii	"translation/execution time expired"
	.byte	0

#  246  "stack overflow"
	.ascii	"stack "
	.byte	14
	.byte	0

#  247  "invalid control _statement"
	.ascii	"invalid control _statement"
	.byte	0

#  248  "attempted redefinition of system function"
	.ascii	"attempted redefinition "
	.byte	192
	.ascii	"system function"
	.byte	0

#  249  "expression evaluated by name returned value"
	.byte	239
	.byte	12
	.byte	204
	.ascii	"value"
	.byte	0

#  250  "insufficient memory to complete dump"
	.byte	222
	.ascii	"memory "
	.byte	201
	.ascii	"complete dump"
	.byte	0

#  251  "keyword operand is not name of defined keyword"
	.byte	171
	.byte	219
	.byte	0

#  252  "error on printing to interactive channel"
	.byte	154
	.ascii	" on printing "
	.byte	201
	.ascii	"interactive channel"
	.byte	0

#  253  "print limit exceeded on standard output channel"
	.ascii	"print limit exceeded on standard "
	.byte	136
	.ascii	"channel"
	.byte	0

#  254  "erroneous argument for host"
	.byte	185
	.byte	2
	.ascii	"f"
	.byte	165
	.ascii	"host"
	.byte	0

#  255  "error during execution of host"
	.byte	154
	.ascii	" "
	.byte	213
	.ascii	"execution "
	.byte	192
	.ascii	"host"
	.byte	0

#  256  "sort/rsort 1st arg not suitable array or table"
	.byte	173
	.ascii	"1st "
	.byte	144
	.byte	19
	.ascii	"sui"
	.byte	193
	.byte	131
	.byte	165
	.ascii	"table"
	.byte	0

#  257  "erroneous 2nd arg in sort/rsort of vector"
	.byte	185
	.ascii	"2nd "
	.byte	144
	.byte	202
	.byte	173
	.byte	192
	.ascii	"vector"
	.byte	0

#  258  "sort/rsort 2nd arg out of range or non-integer"
	.byte	173
	.byte	225
	.byte	0

#  259  "fence argument is not pattern"
	.ascii	"fence "
	.byte	1
	.byte	30
	.byte	0

#  260  "conversion array size exceeds maximum permitted"
	.ascii	"conversion "
	.byte	131
	.byte	150
	.byte	0

#  261  "addition caused real overflow"
	.byte	166
	.byte	227
	.byte	0

#  262  "division caused real overflow"
	.byte	162
	.byte	227
	.byte	0

#  263  "multiplication caused real overflow"
	.byte	137
	.byte	227
	.byte	0

#  264  "subtraction caused real overflow"
	.byte	143
	.byte	227
	.byte	0

#  265  "external function argument is not real"
	.byte	132
	.byte	1
	.ascii	"real"
	.byte	0

#  266  "exponentiation caused real overflow"
	.byte	25
	.byte	227
	.byte	0

#  267  ""
	.byte	0

#  268  "inconsistent value assigned to keyword profile"
	.ascii	"inconsistent "
	.byte	23
	.ascii	"profile"
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

#  274  "value assigned to keyword fullscan is zero"
	.byte	23
	.ascii	"fullscan "
	.byte	24
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

#  281  "char argument not integer"
	.ascii	"char "
	.byte	2
	.byte	19
	.byte	11
	.byte	0

#  282  "char argument not in range"
	.ascii	"char "
	.byte	2
	.byte	19
	.byte	202
	.ascii	"range"
	.byte	0

#  283  ""
	.byte	0

#  284  "excessively nested include files"
	.ascii	"excessively nested include files"
	.byte	0

#  285  "include file cannot be opened"
	.ascii	"include "
	.byte	200
	.ascii	"opened"
	.byte	0

#  286  "function call to undefined entry label"
	.byte	10
	.ascii	"call "
	.byte	201
	.byte	142
	.byte	190
	.byte	0

#  287  "value assigned to keyword maxlngth is too small"
	.byte	23
	.byte	191
	.byte	24
	.ascii	"too small"
	.byte	0

#  288  "exit second argument is not a string"
	.byte	211
	.byte	181
	.byte	0

#  289  "input channel currently in use"
	.byte	161
	.byte	169
	.byte	0

#  290  "output channel currently in use"
	.byte	136
	.byte	169
	.byte	0

#  291  "set first argument is not a suitable name"
	.byte	226
	.byte	7
	.byte	28
	.byte	0

#  292  "set first argument is null"
	.byte	226
	.byte	7
	.byte	159
	.byte	0

#  293  "inappropriate second argument to set"
	.byte	18
	.byte	9
	.byte	2
	.byte	201
	.ascii	"set"
	.byte	0

#  294  "inappropriate third argument to set"
	.byte	18
	.ascii	"third "
	.byte	2
	.byte	201
	.ascii	"set"
	.byte	0

#  295  "set file does not exist"
	.byte	226
	.byte	176
	.byte	0

#  296  "set file does not permit setting file pointer"
	.byte	226
	.byte	153
	.ascii	"setting "
	.byte	145
	.ascii	"pointer"
	.byte	0

#  297  "set caused non-recoverable i/o error"
	.byte	226
	.byte	17
	.ascii	"i/o "
	.byte	154
	.byte	0

#  298  "external function argument is not file"
	.byte	132
	.byte	1
	.ascii	"file"
	.byte	0

#  299  "internal logic error: unexpected ppm branch"
	.ascii	"internal logic "
	.byte	154
	.ascii	": "
	.byte	233
	.ascii	"ppm branch"
	.byte	0

#  300  ""
	.byte	0

#  301  "atan argument not numeric"
	.ascii	"atan "
	.byte	148
	.byte	0

#  302  "chop argument not numeric"
	.ascii	"chop "
	.byte	148
	.byte	0

#  303  "cos argument not numeric"
	.ascii	"cos "
	.byte	148
	.byte	0

#  304  "exp argument not numeric"
	.ascii	"exp "
	.byte	148
	.byte	0

#  305  "exp produced real overflow"
	.ascii	"exp "
	.byte	140
	.byte	0

#  306  "ln argument not numeric"
	.ascii	"ln "
	.byte	148
	.byte	0

#  307  "ln produced real overflow"
	.ascii	"ln "
	.byte	140
	.byte	0

#  308  "sin argument not numeric"
	.ascii	"s"
	.byte	202
	.byte	148
	.byte	0

#  309  "tan argument not numeric"
	.ascii	"tan "
	.byte	148
	.byte	0

#  310  "tan produced real overflow or argument is out of range"
	.ascii	"tan "
	.byte	140
	.ascii	" "
	.byte	165
	.byte	199
	.byte	0

#  311  "exponentiation of negative base to non-integral power"
	.byte	25
	.byte	192
	.ascii	"negative base "
	.byte	201
	.ascii	"non-integral power"
	.byte	0

#  312  "remdr caused real overflow"
	.byte	197
	.byte	227
	.byte	0

#  313  "sqrt argument not numeric"
	.ascii	"sqrt "
	.byte	148
	.byte	0

#  314  "sqrt argument negative"
	.ascii	"sqrt "
	.byte	254
	.byte	0

#  315  "ln argument negative"
	.ascii	"ln "
	.byte	254
	.byte	0

#  316  "backspace argument is not a suitable name"
	.byte	158
	.byte	28
	.byte	0

#  317  "backspace file does not exist"
	.byte	158
	.byte	176
	.byte	0

#  318  "backspace file does not permit backspace"
	.byte	158
	.byte	153
	.ascii	"backspace"
	.byte	0

#  319  "backspace caused non-recoverable error"
	.byte	158
	.byte	17
	.byte	154
	.byte	0

#  320  "user interrupt"
	.ascii	"user interrupt"
	.byte	0

#  321  "goto scontinue with no preceding error"
	.byte	232
	.byte	134
	.byte	0

#  322  "cos argument is out of range"
	.ascii	"cos "
	.byte	199
	.byte	0

#  323  "sin argument is out of range"
	.ascii	"s"
	.byte	202
	.byte	199
	.byte	0

#  324  ""
	.byte	0

#  325  ""
	.byte	0

#  326  "calling external function - bad argument type"
	.byte	236
	.ascii	"bad "
	.byte	2
	.ascii	"type"
	.byte	0

#  327  "calling external function - not found"
	.byte	236
	.byte	19
	.ascii	"found"
	.byte	0

#  328  "load function - insufficient memory"
	.byte	146
	.byte	10
	.ascii	"- "
	.byte	222
	.ascii	"memory"
	.byte	0

#  329  "requested maxlngth too large"
	.ascii	"requested "
	.byte	191
	.ascii	"too large"
	.byte	0

#  330  "date argument is not integer"
	.ascii	"date "
	.byte	135
	.byte	0

#  331  "goto scontinue with no user interrupt"
	.byte	232
	.ascii	"with no user interrupt"
	.byte	0

#  332  "goto continue with error in failure goto"
	.byte	243
	.ascii	"with "
	.byte	154
	.ascii	" "
	.byte	202
	.ascii	"failure goto"
	.byte	0

	.global	_phrases
_phrases:	.byte	0

#    1  "argument is not "
	.byte	2
	.byte	24
	.byte	19
	.byte	0

#    2  "argument "
	.ascii	"argument "
	.byte	0

#    3  "operand is not "
	.ascii	"operand "
	.byte	24
	.byte	19
	.byte	0

#    4  "argument is not a string"
	.byte	1
	.ascii	"a "
	.byte	178
	.byte	0

#    5  "is negative or too large"
	.byte	24
	.ascii	"negative "
	.byte	165
	.ascii	"too large"
	.byte	0

#    6  "syntax error: "
	.ascii	"syntax "
	.byte	154
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

#   10  "function "
	.ascii	"function "
	.byte	0

#   11  "integer"
	.ascii	"integer"
	.byte	0

#   12  "evaluated "
	.ascii	"evaluated "
	.byte	0

#   13  "caused "
	.ascii	"caused "
	.byte	0

#   14  "overflow"
	.ascii	"overflow"
	.byte	0

#   15  " or expression"
	.ascii	" "
	.byte	165
	.ascii	"expression"
	.byte	0

#   16  "file does not "
	.byte	145
	.ascii	"does "
	.byte	19
	.byte	0

#   17  "caused non-recoverable "
	.byte	13
	.ascii	"non-recoverable "
	.byte	0

#   18  "inappropriate "
	.ascii	"inappropriate "
	.byte	0

#   19  "not "
	.ascii	"not "
	.byte	0

#   20  "missing "
	.ascii	"missing "
	.byte	0

#   21  "right "
	.ascii	"right "
	.byte	0

#   22  "real overflow"
	.ascii	"real "
	.byte	14
	.byte	0

#   23  "value assigned to keyword "
	.byte	160
	.ascii	"assigned "
	.byte	201
	.byte	171
	.byte	0

#   24  "is "
	.ascii	"is "
	.byte	0

#   25  "exponentiation "
	.ascii	"exponentiation "
	.byte	0

#   26  "name"
	.ascii	"name"
	.byte	0

#   27  "natural variable name"
	.ascii	"natural variable "
	.byte	26
	.byte	0

#   28  "argument is not a suitable name"
	.byte	1
	.ascii	"a sui"
	.byte	193
	.byte	26
	.byte	0

#   29  "argument is not appropriate name"
	.byte	1
	.ascii	"appropriate "
	.byte	26
	.byte	0

#   30  "pattern"
	.ascii	"pattern"
	.byte	0

#   31  "third argument is not a string"
	.ascii	"third "
	.byte	4
	.byte	0

#  128  "left operand is not numeric"
	.ascii	"left "
	.byte	3
	.byte	8
	.byte	0

#  129  "assignment left operand is not pattern"
	.ascii	"assignment left "
	.byte	3
	.byte	30
	.byte	0

#  130  "goto "
	.ascii	"go"
	.byte	201
	.byte	0

#  131  "array "
	.ascii	"array "
	.byte	0

#  132  "external function "
	.ascii	"external "
	.byte	10
	.byte	0

#  133  "out of range"
	.ascii	"out "
	.byte	192
	.ascii	"range"
	.byte	0

#  134  "with no preceding error"
	.ascii	"with no preceding "
	.byte	154
	.byte	0

#  135  "argument is not integer"
	.byte	1
	.byte	11
	.byte	0

#  136  "output "
	.byte	237
	.ascii	" "
	.byte	0

#  137  "multiplication "
	.ascii	"multiplication "
	.byte	0

#  138  "operand is not a string or pattern"
	.byte	3
	.ascii	"a "
	.byte	178
	.ascii	" "
	.byte	165
	.byte	30
	.byte	0

#  139  "caused integer overflow"
	.byte	13
	.byte	11
	.ascii	" "
	.byte	14
	.byte	0

#  140  "produced real overflow"
	.ascii	"produced "
	.byte	22
	.byte	0

#  141  "argument has null "
	.byte	2
	.ascii	"has null "
	.byte	0

#  142  "undefined "
	.ascii	"undefined "
	.byte	0

#  143  "subtraction "
	.ascii	"subtraction "
	.byte	0

#  144  "arg "
	.ascii	"arg "
	.byte	0

#  145  "file "
	.ascii	"file "
	.byte	0

#  146  "load "
	.ascii	"load "
	.byte	0

#  147  "define "
	.ascii	"define "
	.byte	0

#  148  "argument not numeric"
	.byte	2
	.byte	19
	.byte	8
	.byte	0

#  149  "syntax error: invalid use of "
	.byte	6
	.ascii	"invalid use "
	.byte	192
	.byte	0

#  150  "size exceeds maximum permitted"
	.ascii	"size exceeds maximum permitted"
	.byte	0

#  151  "dimension is zero, negative or out of range"
	.ascii	"dimension "
	.byte	24
	.ascii	"zero, negative "
	.byte	165
	.byte	133
	.byte	0

#  152  "argument is missing a left paren"
	.byte	2
	.byte	24
	.byte	20
	.ascii	"a left paren"
	.byte	0

#  153  "file does not permit "
	.byte	16
	.ascii	"permit "
	.byte	0

#  154  "error"
	.ascii	"error"
	.byte	0

#  155  "datatype name"
	.ascii	"datatype "
	.byte	26
	.byte	0

#  156  "program function name"
	.ascii	"program "
	.byte	10
	.byte	26
	.byte	0

#  157  "argument is not numeric"
	.byte	1
	.byte	8
	.byte	0

#  158  "backspace "
	.ascii	"backspace "
	.byte	0

#  159  "argument is null"
	.byte	2
	.byte	24
	.ascii	"null"
	.byte	0

#  160  "value "
	.ascii	"value "
	.byte	0

#  161  "input "
	.ascii	"input "
	.byte	0

#  162  "division "
	.ascii	"division "
	.byte	0

#  163  "rewind "
	.ascii	"rewind "
	.byte	0

#  164  "bound is not integer"
	.ascii	"bound "
	.byte	24
	.byte	19
	.byte	11
	.byte	0

#  165  "or "
	.ascii	"or "
	.byte	0

#  166  "addition "
	.ascii	"addition "
	.byte	0

#  167  "first argument is not a string"
	.byte	7
	.byte	4
	.byte	0

#  168  "argument is negative or too large"
	.byte	2
	.byte	5
	.byte	0

#  169  "channel currently in use"
	.ascii	"channel currently "
	.byte	202
	.ascii	"use"
	.byte	0

#  170  "action caused irrecoverable error"
	.ascii	"action "
	.byte	13
	.ascii	"irrecoverable "
	.byte	154
	.byte	0

#  171  "keyword "
	.byte	216
	.ascii	" "
	.byte	0

#  172  "result in nreturn is not name"
	.ascii	"result "
	.byte	202
	.ascii	"nreturn "
	.byte	24
	.byte	19
	.byte	26
	.byte	0

#  173  "sort/rsort "
	.ascii	"sort/rsort "
	.byte	0

#  174  "field "
	.ascii	"field "
	.byte	0

#  175  "trace "
	.ascii	"trace "
	.byte	0

#  176  "file does not exist"
	.byte	16
	.ascii	"exist"
	.byte	0

#  177  "data "
	.ascii	"data "
	.byte	0

#  178  "string"
	.ascii	"string"
	.byte	0

#  179  "opsyn "
	.ascii	"opsyn "
	.byte	0

#  180  "first arg is not correct operator name"
	.byte	7
	.byte	144
	.byte	24
	.byte	19
	.ascii	"correct operat"
	.byte	165
	.byte	26
	.byte	0

#  181  "second argument is not a string"
	.byte	9
	.byte	4
	.byte	0

#  182  "right operand is not numeric"
	.byte	21
	.byte	3
	.byte	8
	.byte	0

#  183  "third argument is not integer"
	.ascii	"third "
	.byte	135
	.byte	0

#  184  "does not evaluate to pattern"
	.ascii	"does "
	.byte	19
	.ascii	"evaluate "
	.byte	201
	.byte	30
	.byte	0

#  185  "erroneous "
	.ascii	"erroneous "
	.byte	0

#  186  "inappropriate file specification for "
	.byte	18
	.byte	145
	.ascii	"specification f"
	.byte	165
	.byte	0

#  187  " replacement right operand is not a string"
	.ascii	" replacement "
	.byte	21
	.byte	3
	.ascii	"a "
	.byte	178
	.byte	0

#  188  "label"
	.ascii	"label"
	.byte	0

#  189  "function entry point is not defined label"
	.byte	10
	.ascii	"entry point "
	.byte	24
	.byte	19
	.ascii	"defined "
	.byte	188
	.byte	0

#  190  "entry label"
	.ascii	"entry "
	.byte	188
	.byte	0

#  191  "maxlngth "
	.ascii	"maxlngth "
	.byte	0

#  192  "of "
	.ascii	"of "
	.byte	0

#  193  "table "
	.ascii	"table "
	.byte	0

#  194  " match left operand is not a string"
	.ascii	" match left "
	.byte	3
	.ascii	"a "
	.byte	178
	.byte	0

#  195  "eject "
	.ascii	"eject "
	.byte	0

#  196  "arg is not natural variable name"
	.byte	144
	.byte	24
	.byte	19
	.byte	27
	.byte	0

#  197  "remdr "
	.ascii	"remdr "
	.byte	0

#  198  "referenced with "
	.ascii	"referenced with "
	.byte	0

#  199  "argument is out of range"
	.byte	2
	.byte	24
	.byte	133
	.byte	0

#  200  "file cannot be "
	.byte	145
	.ascii	"can"
	.byte	19
	.ascii	"be "
	.byte	0

#  201  "to "
	.ascii	"to "
	.byte	0

#  202  "in "
	.ascii	"in "
	.byte	0

#  203  "replace "
	.ascii	"replace "
	.byte	0

#  204  "by name returned "
	.ascii	"by "
	.byte	26
	.ascii	" returned "
	.byte	0

#  205  "concatenation "
	.ascii	"concatenation "
	.byte	0

#  206  "second argument is not integer"
	.byte	9
	.byte	135
	.byte	0

#  207  "second argument is not numeric"
	.byte	9
	.byte	157
	.byte	0

#  208  "first argument is not numeric"
	.byte	7
	.byte	157
	.byte	0

#  209  "from "
	.ascii	"from "
	.byte	0

#  210  "rtab "
	.ascii	"r"
	.byte	247
	.byte	0

#  211  "exit "
	.ascii	"exit "
	.byte	0

#  212  "subscript is not integer"
	.ascii	"subscript "
	.byte	24
	.byte	19
	.byte	11
	.byte	0

#  213  "during "
	.ascii	"during "
	.byte	0

#  214  "value assigned is not integer"
	.byte	160
	.ascii	"assigned "
	.byte	24
	.byte	19
	.byte	11
	.byte	0

#  215  "substr "
	.ascii	"substr "
	.byte	0

#  216  "keyword"
	.ascii	"keyword"
	.byte	0

#  217  "count exceeds value of stlimit keyword"
	.ascii	"count exceeds "
	.byte	160
	.byte	192
	.ascii	"stlimit "
	.byte	216
	.byte	0

#  218  " length exceeds value of maxlngth keyword"
	.ascii	" length exceeds "
	.byte	160
	.byte	192
	.byte	191
	.byte	216
	.byte	0

#  219  "operand is not name of defined keyword"
	.byte	3
	.byte	26
	.ascii	" "
	.byte	192
	.ascii	"defined "
	.byte	216
	.byte	0

#  220  "bracket"
	.ascii	"bracket"
	.byte	0

#  221  "unbalanced right bracket"
	.ascii	"unbalanced "
	.byte	21
	.byte	220
	.byte	0

#  222  "insufficient "
	.ascii	"insufficient "
	.byte	0

#  223  "endfile "
	.ascii	"end"
	.byte	145
	.byte	0

#  224  "rpos "
	.ascii	"r"
	.byte	251
	.byte	0

#  225  "2nd arg out of range or non-integer"
	.ascii	"2nd "
	.byte	144
	.byte	133
	.ascii	" "
	.byte	165
	.ascii	"non-"
	.byte	11
	.byte	0

#  226  "set "
	.ascii	"set "
	.byte	0

#  227  "caused real overflow"
	.byte	13
	.byte	22
	.byte	0

#  228  "alternation "
	.ascii	"alternation "
	.byte	0

#  229  "errtext not a string"
	.ascii	"errtext "
	.byte	19
	.ascii	"a "
	.byte	178
	.byte	0

#  230  "duplicate label"
	.ascii	"duplicate "
	.byte	188
	.byte	0

#  231  "value assigned is negative or too large"
	.byte	160
	.ascii	"assigned "
	.byte	5
	.byte	0

#  232  "goto scontinue "
	.byte	130
	.ascii	"scontinue "
	.byte	0

#  233  "unexpected "
	.ascii	"unexpected "
	.byte	0

#  234  "right paren"
	.byte	21
	.ascii	"paren"
	.byte	0

#  235  "argument is missing a right paren"
	.byte	2
	.byte	24
	.byte	20
	.ascii	"a "
	.byte	234
	.byte	0

#  236  "calling external function - "
	.ascii	"calling "
	.byte	132
	.ascii	"- "
	.byte	0

#  237  "output"
	.ascii	"output"
	.byte	0

#  238  "argument has null variable name"
	.byte	141
	.ascii	"variable "
	.byte	26
	.byte	0

#  239  "expression "
	.ascii	"expression "
	.byte	0

#  240  "evaluated argument is negative or too large"
	.byte	12
	.byte	168
	.byte	0

#  241  "argument is not integer or expression"
	.byte	135
	.byte	15
	.byte	0

#  242  "argument is not a string or expression"
	.byte	4
	.byte	15
	.byte	0

#  243  "goto continue "
	.byte	130
	.ascii	"continue "
	.byte	0

#  244  "first argument is not suitable integer or string"
	.byte	7
	.byte	1
	.ascii	"sui"
	.byte	193
	.byte	11
	.ascii	" "
	.byte	165
	.byte	178
	.byte	0

#  245  "argument for output"
	.byte	2
	.ascii	"f"
	.byte	165
	.byte	237
	.byte	0

#  246  "first argument has null function name"
	.byte	7
	.byte	141
	.byte	10
	.byte	26
	.byte	0

#  247  "tab "
	.ascii	"tab "
	.byte	0

#  248  "evaluated argument is not integer"
	.byte	12
	.byte	135
	.byte	0

#  249  "_statement "
	.ascii	"_statement "
	.byte	0

#  250  "len "
	.ascii	"len "
	.byte	0

#  251  "pos "
	.ascii	"pos "
	.byte	0

#  252  " match right operand is not pattern"
	.ascii	" match "
	.byte	21
	.byte	3
	.byte	30
	.byte	0

#  253  "evaluated argument is not a string"
	.byte	12
	.byte	4
	.byte	0

#  254  "argument negative"
	.byte	2
	.ascii	"negative"
	.byte	0

#  255  "first argument upper bound is not integer"
	.byte	7
	.byte	2
	.ascii	"upper "
	.byte	164
	.byte	0



# fixed 10
