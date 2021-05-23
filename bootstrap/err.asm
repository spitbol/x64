; compressed spitbol error messages 01/03/70 17:49:04
;




	segment	.data

	global	errors
errors				    :	db	0

;    1  "addition left operand is not numeric"
	db	163
	db	128
	db	0

;    2  "addition right operand is not numeric"
	db	163
	db	183
	db	0

;    3  "addition caused integer overflow"
	db	163
	db	139
	db	0

;    4  "affirmation operand is not numeric"
	db	"affirmation "
	db	3
	db	8
	db	0

;    5  "alternation right operand is not pattern"
	db	226
	db	19
	db	3
	db	30
	db	0

;    6  "alternation left operand is not pattern"
	db	226
	db	"left "
	db	3
	db	30
	db	0

;    7  "compilation error encountered during execution"
	db	"compilation "
	db	216
	db	"encountered "
	db	214
	db	"execution"
	db	0

;    8  "concatenation left operand is not a string or pattern"
	db	207
	db	"left "
	db	138
	db	0

;    9  "concatenation right operand is not a string or pattern"
	db	207
	db	19
	db	138
	db	0

;   10  "negation operand is not numeric"
	db	"negation "
	db	3
	db	8
	db	0

;   11  "negation caused integer overflow"
	db	"negation "
	db	139
	db	0

;   12  "division left operand is not numeric"
	db	160
	db	128
	db	0

;   13  "division right operand is not numeric"
	db	160
	db	183
	db	0

;   14  "division caused integer overflow"
	db	160
	db	139
	db	0

;   15  "exponentiation right operand is not numeric"
	db	22
	db	183
	db	0

;   16  "exponentiation left operand is not numeric"
	db	22
	db	128
	db	0

;   17  "exponentiation caused integer overflow"
	db	22
	db	139
	db	0

;   18  "exponentiation result is undefined"
	db	22
	db	"result "
	db	24
	db	"undefined"
	db	0

;   19  ""
	db	0

;   20  "goto evaluation failure"
	db	130
	db	"evaluation failure"
	db	0

;   21  "function called by name returned a value"
	db	10
	db	"called "
	db	206
	db	"a value"
	db	0

;   22  "undefined function called"
	db	141
	db	10
	db	"called"
	db	0

;   23  "goto operand is not a natural variable"
	db	130
	db	3
	db	"a natural variable"
	db	0

;   24  "goto operand in direct goto is not code"
	db	130
	db	"operand "
	db	202
	db	"direct "
	db	130
	db	24
	db	16
	db	"code"
	db	0

;   25  "immediate assignment left operand is not pattern"
	db	"immediate "
	db	129
	db	0

;   26  "multiplication left operand is not numeric"
	db	137
	db	128
	db	0

;   27  "multiplication right operand is not numeric"
	db	137
	db	183
	db	0

;   28  "multiplication caused integer overflow"
	db	137
	db	139
	db	0

;   29  "undefined operator referenced"
	db	141
	db	"operat"
	db	162
	db	"referenced"
	db	0

;   30  "pattern assignment left operand is not pattern"
	db	30
	db	" "
	db	129
	db	0

;   31  "pattern replacement right operand is not a string"
	db	30
	db	187
	db	0

;   32  "subtraction left operand is not numeric"
	db	143
	db	128
	db	0

;   33  "subtraction right operand is not numeric"
	db	143
	db	183
	db	0

;   34  "subtraction caused integer overflow"
	db	143
	db	139
	db	0

;   35  "unexpected failure in -nofail mode"
	db	232
	db	"failure "
	db	202
	db	"-nofail mode"
	db	0

;   36  "goto abort with no preceding error"
	db	130
	db	"abort "
	db	134
	db	0

;   37  "goto continue with no preceding error"
	db	242
	db	134
	db	0

;   38  "goto undefined label"
	db	130
	db	141
	db	188
	db	0

;   39  "external function argument is not a string"
	db	132
	db	4
	db	0

;   40  "external function argument is not integer"
	db	132
	db	135
	db	0

;   41  "field function argument is wrong datatype"
	db	174
	db	10
	db	2
	db	24
	db	"wrong datatype"
	db	0

;   42  "attempt to change value of protected variable"
	db	"attempt "
	db	233
	db	"change "
	db	158
	db	193
	db	"protected variable"
	db	0

;   43  "any evaluated argument is not a string"
	db	"any "
	db	253
	db	0

;   44  "break evaluated argument is not a string"
	db	"break "
	db	253
	db	0

;   45  "breakx evaluated argument is not a string"
	db	"breakx "
	db	253
	db	0

;   46  "expression does not evaluate to pattern"
	db	239
	db	182
	db	0

;   47  "len evaluated argument is not integer"
	db	250
	db	245
	db	0

;   48  "len evaluated argument is negative or too large"
	db	250
	db	243
	db	0

;   49  "notany evaluated argument is not a string"
	db	"notany "
	db	253
	db	0

;   50  "pos evaluated argument is not integer"
	db	252
	db	245
	db	0

;   51  "pos evaluated argument is negative or too large"
	db	252
	db	243
	db	0

;   52  "rpos evaluated argument is not integer"
	db	222
	db	245
	db	0

;   53  "rpos evaluated argument is negative or too large"
	db	222
	db	243
	db	0

;   54  "rtab evaluated argument is not integer"
	db	211
	db	245
	db	0

;   55  "rtab evaluated argument is negative or too large"
	db	211
	db	243
	db	0

;   56  "span evaluated argument is not a string"
	db	"span "
	db	253
	db	0

;   57  "tab evaluated argument is not integer"
	db	244
	db	245
	db	0

;   58  "tab evaluated argument is negative or too large"
	db	244
	db	243
	db	0

;   59  "any argument is not a string or expression"
	db	"any "
	db	241
	db	0

;   60  "apply first arg is not natural variable name"
	db	"apply "
	db	7
	db	199
	db	0

;   61  "arbno argument is not pattern"
	db	"arbno "
	db	1
	db	30
	db	0

;   62  "arg second argument is not integer"
	db	144
	db	208
	db	0

;   63  "arg first argument is not program function name"
	db	144
	db	7
	db	1
	db	155
	db	0

;   64  "array first argument is not integer or string"
	db	131
	db	7
	db	135
	db	" "
	db	162
	db	178
	db	0

;   65  "array first argument lower bound is not integer"
	db	131
	db	7
	db	2
	db	"lower "
	db	165
	db	0

;   66  "array first argument upper bound is not integer"
	db	131
	db	255
	db	0

;   67  "array dimension is zero, negative or out of range"
	db	131
	db	150
	db	0

;   68  "array size exceeds maximum permitted"
	db	131
	db	149
	db	0

;   69  "break argument is not a string or expression"
	db	"break "
	db	241
	db	0

;   70  "breakx argument is not a string or expression"
	db	"breakx "
	db	241
	db	0

;   71  "clear argument is not a string"
	db	"clear "
	db	4
	db	0

;   72  "clear argument has null variable name"
	db	"clear "
	db	238
	db	0

;   73  "collect argument is not integer"
	db	"collect "
	db	135
	db	0

;   74  "convert second argument is not a string"
	db	"convert "
	db	181
	db	0

;   75  "data argument is not a string"
	db	176
	db	4
	db	0

;   76  "data argument is null"
	db	176
	db	173
	db	0

;   77  "data argument is missing a left paren"
	db	176
	db	153
	db	0

;   78  "data argument has null datatype name"
	db	176
	db	140
	db	154
	db	0

;   79  "data argument is missing a right paren"
	db	176
	db	235
	db	0

;   80  "data argument has null field name"
	db	176
	db	140
	db	174
	db	26
	db	0

;   81  "define first argument is not a string"
	db	146
	db	166
	db	0

;   82  "define first argument is null"
	db	146
	db	7
	db	173
	db	0

;   83  "define first argument is missing a left paren"
	db	146
	db	7
	db	153
	db	0

;   84  "define first argument has null function name"
	db	146
	db	247
	db	0

;   85  "null arg name or missing ) in define first arg."
	db	"null "
	db	144
	db	26
	db	" "
	db	162
	db	17
	db	") "
	db	202
	db	146
	db	7
	db	"arg."
	db	0

;   86  "define function entry point is not defined label"
	db	146
	db	189
	db	0

;   87  "detach argument is not appropriate name"
	db	"detach "
	db	29
	db	0

;   88  "dump argument is not integer"
	db	"dump "
	db	135
	db	0

;   89  "dump argument is negative or too large"
	db	"dump "
	db	167
	db	0

;   90  "dupl second argument is not integer"
	db	"dupl "
	db	208
	db	0

;   91  "dupl first argument is not a string or pattern"
	db	"dupl "
	db	166
	db	" "
	db	162
	db	30
	db	0

;   92  "eject argument is not a suitable name"
	db	196
	db	28
	db	0

;   93  "eject file does not exist"
	db	196
	db	23
	db	192
	db	0

;   94  "eject file does not permit page eject"
	db	196
	db	171
	db	"page eject"
	db	0

;   95  "eject caused non-recoverable output error"
	db	196
	db	18
	db	136
	db	164
	db	0

;   96  "endfile argument is not a suitable name"
	db	151
	db	28
	db	0

;   97  "endfile argument is null"
	db	151
	db	173
	db	0

;   98  "endfile file does not exist"
	db	151
	db	23
	db	192
	db	0

;   99  "endfile file does not permit endfile"
	db	151
	db	171
	db	"endfile"
	db	0

;  100  "endfile caused non-recoverable output error"
	db	151
	db	18
	db	136
	db	164
	db	0

;  101  "eq first argument is not numeric"
	db	"eq "
	db	205
	db	0

;  102  "eq second argument is not numeric"
	db	"eq "
	db	204
	db	0

;  103  "eval argument is not expression"
	db	"eval "
	db	1
	db	"expression"
	db	0

;  104  "exit first argument is not suitable integer or string"
	db	212
	db	248
	db	0

;  105  "exit action not available in this implementation"
	db	212
	db	"action "
	db	16
	db	"available "
	db	202
	db	"th"
	db	24
	db	"implementation"
	db	0

;  106  "exit action caused irrecoverable error"
	db	212
	db	169
	db	0

;  107  "field second argument is not integer"
	db	174
	db	208
	db	0

;  108  "field first argument is not datatype name"
	db	174
	db	7
	db	1
	db	154
	db	0

;  109  "ge first argument is not numeric"
	db	"ge "
	db	205
	db	0

;  110  "ge second argument is not numeric"
	db	"ge "
	db	204
	db	0

;  111  "gt first argument is not numeric"
	db	"gt "
	db	205
	db	0

;  112  "gt second argument is not numeric"
	db	"gt "
	db	204
	db	0

;  113  "input third argument is not a string"
	db	159
	db	31
	db	0

;  114  "inappropriate second argument for input"
	db	25
	db	9
	db	2
	db	"f"
	db	162
	db	"input"
	db	0

;  115  "inappropriate first argument for input"
	db	25
	db	7
	db	2
	db	"f"
	db	162
	db	"input"
	db	0

;  116  "inappropriate file specification for input"
	db	186
	db	"input"
	db	0

;  117  "input file cannot be read"
	db	159
	db	201
	db	"read"
	db	0

;  118  "le first argument is not numeric"
	db	"le "
	db	205
	db	0

;  119  "le second argument is not numeric"
	db	"le "
	db	204
	db	0

;  120  "len argument is not integer or expression"
	db	250
	db	240
	db	0

;  121  "len argument is negative or too large"
	db	250
	db	167
	db	0

;  122  "leq first argument is not a string"
	db	"leq "
	db	166
	db	0

;  123  "leq second argument is not a string"
	db	"leq "
	db	181
	db	0

;  124  "lge first argument is not a string"
	db	"lge "
	db	166
	db	0

;  125  "lge second argument is not a string"
	db	"lge "
	db	181
	db	0

;  126  "lgt first argument is not a string"
	db	"lgt "
	db	166
	db	0

;  127  "lgt second argument is not a string"
	db	"lgt "
	db	181
	db	0

;  128  "lle first argument is not a string"
	db	"lle "
	db	166
	db	0

;  129  "lle second argument is not a string"
	db	"lle "
	db	181
	db	0

;  130  "llt first argument is not a string"
	db	"llt "
	db	166
	db	0

;  131  "llt second argument is not a string"
	db	"llt "
	db	181
	db	0

;  132  "lne first argument is not a string"
	db	"lne "
	db	166
	db	0

;  133  "lne second argument is not a string"
	db	"lne "
	db	181
	db	0

;  134  "local second argument is not integer"
	db	"local "
	db	208
	db	0

;  135  "local first arg is not a program function name"
	db	"local "
	db	7
	db	144
	db	24
	db	16
	db	"a "
	db	155
	db	0

;  136  "load second argument is not a string"
	db	145
	db	181
	db	0

;  137  "load first argument is not a string"
	db	145
	db	166
	db	0

;  138  "load first argument is null"
	db	145
	db	7
	db	173
	db	0

;  139  "load first argument is missing a left paren"
	db	145
	db	7
	db	153
	db	0

;  140  "load first argument has null function name"
	db	145
	db	247
	db	0

;  141  "load first argument is missing a right paren"
	db	145
	db	7
	db	235
	db	0

;  142  "load function does not exist"
	db	145
	db	10
	db	"does "
	db	16
	db	192
	db	0

;  143  "load function caused input error during load"
	db	145
	db	10
	db	13
	db	159
	db	216
	db	214
	db	"load"
	db	0

;  144  "lpad third argument is not a string"
	db	"lpad "
	db	31
	db	0

;  145  "lpad second argument is not integer"
	db	"lpad "
	db	208
	db	0

;  146  "lpad first argument is not a string"
	db	"lpad "
	db	166
	db	0

;  147  "lt first argument is not numeric"
	db	"lt "
	db	205
	db	0

;  148  "lt second argument is not numeric"
	db	"lt "
	db	204
	db	0

;  149  "ne first argument is not numeric"
	db	"ne "
	db	205
	db	0

;  150  "ne second argument is not numeric"
	db	"ne "
	db	204
	db	0

;  151  "notany argument is not a string or expression"
	db	"notany "
	db	241
	db	0

;  152  "opsyn third argument is not integer"
	db	179
	db	184
	db	0

;  153  "opsyn third argument is negative or too large"
	db	179
	db	"third "
	db	167
	db	0

;  154  "opsyn second arg is not natural variable name"
	db	179
	db	9
	db	199
	db	0

;  155  "opsyn first arg is not natural variable name"
	db	179
	db	7
	db	199
	db	0

;  156  "opsyn first arg is not correct operator name"
	db	179
	db	180
	db	0

;  157  "output third argument is not a string"
	db	136
	db	31
	db	0

;  158  "inappropriate second argument for output"
	db	25
	db	9
	db	249
	db	0

;  159  "inappropriate first argument for output"
	db	25
	db	7
	db	249
	db	0

;  160  "inappropriate file specification for output"
	db	186
	db	237
	db	0

;  161  "output file cannot be written to"
	db	136
	db	201
	db	"written to"
	db	0

;  162  "pos argument is not integer or expression"
	db	252
	db	240
	db	0

;  163  "pos argument is negative or too large"
	db	252
	db	167
	db	0

;  164  "prototype argument is not valid object"
	db	"prototype "
	db	1
	db	"valid object"
	db	0

;  165  "remdr second argument is not numeric"
	db	197
	db	204
	db	0

;  166  "remdr first argument is not numeric"
	db	197
	db	205
	db	0

;  167  "remdr caused integer overflow"
	db	197
	db	139
	db	0

;  168  "replace third argument is not a string"
	db	203
	db	31
	db	0

;  169  "replace second argument is not a string"
	db	203
	db	181
	db	0

;  170  "replace first argument is not a string"
	db	203
	db	166
	db	0

;  171  "null or unequally long 2nd, 3rd args to replace"
	db	"null "
	db	162
	db	"unequally long 2nd, 3rd args "
	db	233
	db	"replace"
	db	0

;  172  "rewind argument is not a suitable name"
	db	161
	db	28
	db	0

;  173  "rewind argument is null"
	db	161
	db	173
	db	0

;  174  "rewind file does not exist"
	db	161
	db	23
	db	192
	db	0

;  175  "rewind file does not permit rewind"
	db	161
	db	171
	db	"rewind"
	db	0

;  176  "rewind caused non-recoverable error"
	db	161
	db	18
	db	164
	db	0

;  177  "reverse argument is not a string"
	db	"reverse "
	db	4
	db	0

;  178  "rpad third argument is not a string"
	db	"rpad "
	db	31
	db	0

;  179  "rpad second argument is not integer"
	db	"rpad "
	db	208
	db	0

;  180  "rpad first argument is not a string"
	db	"rpad "
	db	166
	db	0

;  181  "rtab argument is not integer or expression"
	db	211
	db	240
	db	0

;  182  "rtab argument is negative or too large"
	db	211
	db	167
	db	0

;  183  "tab argument is not integer or expression"
	db	244
	db	240
	db	0

;  184  "tab argument is negative or too large"
	db	244
	db	167
	db	0

;  185  "rpos argument is not integer or expression"
	db	222
	db	240
	db	0

;  186  "rpos argument is negative or too large"
	db	222
	db	167
	db	0

;  187  "setexit argument is not label name or null"
	db	"set"
	db	212
	db	1
	db	188
	db	" "
	db	26
	db	" "
	db	162
	db	"null"
	db	0

;  188  "span argument is not a string or expression"
	db	"span "
	db	241
	db	0

;  189  "size argument is not a string"
	db	"size "
	db	4
	db	0

;  190  "stoptr first argument is not appropriate name"
	db	"stoptr "
	db	7
	db	29
	db	0

;  191  "stoptr second argument is not trace type"
	db	"stoptr "
	db	9
	db	1
	db	175
	db	"type"
	db	0

;  192  "substr third argument is not integer"
	db	215
	db	184
	db	0

;  193  "substr second argument is not integer"
	db	215
	db	208
	db	0

;  194  "substr first argument is not a string"
	db	215
	db	166
	db	0

;  195  "table argument is not integer"
	db	194
	db	135
	db	0

;  196  "table argument is out of range"
	db	194
	db	200
	db	0

;  197  "trace fourth arg is not function name or null"
	db	175
	db	"fourth "
	db	144
	db	24
	db	16
	db	10
	db	26
	db	" "
	db	162
	db	"null"
	db	0

;  198  "trace first argument is not appropriate name"
	db	175
	db	7
	db	29
	db	0

;  199  "trace second argument is not trace type"
	db	175
	db	9
	db	1
	db	175
	db	"type"
	db	0

;  200  "trim argument is not a string"
	db	"trim "
	db	4
	db	0

;  201  "unload argument is not natural variable name"
	db	"un"
	db	145
	db	1
	db	27
	db	0

;  202  "input from file caused non-recoverable error"
	db	159
	db	210
	db	152
	db	18
	db	164
	db	0

;  203  "input file record has incorrect format"
	db	159
	db	152
	db	"record has incorrect format"
	db	0

;  204  "memory overflow"
	db	"memory "
	db	14
	db	0

;  205  "string length exceeds value of maxlngth keyword"
	db	178
	db	219
	db	0

;  206  "output caused file overflow"
	db	136
	db	13
	db	152
	db	14
	db	0

;  207  "output caused non-recoverable error"
	db	136
	db	18
	db	164
	db	0

;  208  "keyword value assigned is not integer"
	db	170
	db	223
	db	0

;  209  "keyword in assignment is protected"
	db	170
	db	202
	db	"assignment "
	db	24
	db	"protected"
	db	0

;  210  "keyword value assigned is negative or too large"
	db	170
	db	230
	db	0

;  211  "value assigned to keyword errtext not a string"
	db	21
	db	227
	db	0

;  212  "syntax error: value used where name is required"
	db	6
	db	158
	db	"used where "
	db	26
	db	" "
	db	24
	db	"required"
	db	0

;  213  "syntax error: statement is too complicated."
	db	6
	db	246
	db	24
	db	"too complicated."
	db	0

;  214  "bad label or misplaced continuation line"
	db	"bad "
	db	188
	db	" "
	db	162
	db	"misplaced continuation line"
	db	0

;  215  "syntax error: undefined or erroneous entry label"
	db	6
	db	141
	db	162
	db	185
	db	190
	db	0

;  216  "syntax error: missing end line"
	db	6
	db	17
	db	"end line"
	db	0

;  217  "syntax error: duplicate label"
	db	6
	db	229
	db	0

;  218  "syntax error: duplicated goto field"
	db	6
	db	"duplicated "
	db	130
	db	"field"
	db	0

;  219  "syntax error: empty goto field"
	db	6
	db	"empty "
	db	130
	db	"field"
	db	0

;  220  "syntax error: missing operator"
	db	6
	db	17
	db	"operator"
	db	0

;  221  "syntax error: missing operand"
	db	6
	db	17
	db	"operand"
	db	0

;  222  "syntax error: invalid use of left bracket"
	db	148
	db	"left "
	db	220
	db	0

;  223  "syntax error: invalid use of comma"
	db	148
	db	"comma"
	db	0

;  224  "syntax error: unbalanced right parenthesis"
	db	209
	db	"parenthesis"
	db	0

;  225  "syntax error: unbalanced right bracket"
	db	209
	db	220
	db	0

;  226  "syntax error: missing right paren"
	db	6
	db	17
	db	234
	db	0

;  227  "syntax error: right paren missing from goto"
	db	6
	db	234
	db	" "
	db	17
	db	210
	db	"goto"
	db	0

;  228  "syntax error: right bracket missing from goto"
	db	6
	db	19
	db	220
	db	" "
	db	17
	db	210
	db	"goto"
	db	0

;  229  "syntax error: missing right array bracket"
	db	6
	db	17
	db	19
	db	131
	db	220
	db	0

;  230  "syntax error: illegal character"
	db	6
	db	"illegal character"
	db	0

;  231  "syntax error: invalid numeric item"
	db	6
	db	"invalid "
	db	8
	db	" item"
	db	0

;  232  "syntax error: unmatched string quote"
	db	6
	db	"unmatched "
	db	178
	db	" quote"
	db	0

;  233  "syntax error: invalid use of operator"
	db	148
	db	"operator"
	db	0

;  234  "syntax error: goto field incorrect"
	db	6
	db	130
	db	174
	db	"incorrect"
	db	0

;  235  "subscripted operand is not table or array"
	db	"subscripted "
	db	3
	db	194
	db	162
	db	"array"
	db	0

;  236  "array referenced with wrong number of subscripts"
	db	131
	db	198
	db	"wrong number "
	db	193
	db	"subscripts"
	db	0

;  237  "table referenced with more than one subscript"
	db	194
	db	198
	db	"more than one subscript"
	db	0

;  238  "array subscript is not integer"
	db	131
	db	224
	db	0

;  239  "indirection operand is not name"
	db	"indirection "
	db	3
	db	26
	db	0

;  240  "pattern match right operand is not pattern"
	db	30
	db	251
	db	0

;  241  "pattern match left operand is not a string"
	db	30
	db	195
	db	0

;  242  "function return from level zero"
	db	10
	db	"return "
	db	210
	db	"level zero"
	db	0

;  243  "function result in nreturn is not name"
	db	10
	db	177
	db	0

;  244  "statement count exceeds value of stlimit keyword"
	db	246
	db	218
	db	0

;  245  "translation/execution time expired"
	db	"translation/execution time expired"
	db	0

;  246  "stack overflow"
	db	"stack "
	db	14
	db	0

;  247  "invalid control statement"
	db	"invalid control statement"
	db	0

;  248  "attempted redefinition of system function"
	db	"attempted redefinition "
	db	193
	db	"system function"
	db	0

;  249  "expression evaluated by name returned value"
	db	239
	db	12
	db	206
	db	"value"
	db	0

;  250  "insufficient memory to complete dump"
	db	221
	db	"memory "
	db	233
	db	"complete dump"
	db	0

;  251  "keyword operand is not name of defined keyword"
	db	170
	db	225
	db	0

;  252  "error on printing to interactive channel"
	db	216
	db	"on printing "
	db	233
	db	"interactive channel"
	db	0

;  253  "print limit exceeded on standard output channel"
	db	"print limit exceeded on standard "
	db	136
	db	"channel"
	db	0

;  254  "erroneous argument for host"
	db	185
	db	2
	db	"f"
	db	162
	db	"host"
	db	0

;  255  "error during execution of host"
	db	216
	db	214
	db	"execution "
	db	193
	db	"host"
	db	0

;  256  "sort/rsort 1st arg not suitable array or table"
	db	172
	db	"1st "
	db	144
	db	16
	db	"sui"
	db	194
	db	131
	db	162
	db	"table"
	db	0

;  257  "erroneous 2nd arg in sort/rsort of vector"
	db	185
	db	"2nd "
	db	144
	db	202
	db	172
	db	193
	db	"vector"
	db	0

;  258  "sort/rsort 2nd arg out of range or non-integer"
	db	172
	db	213
	db	0

;  259  "fence argument is not pattern"
	db	"fence "
	db	1
	db	30
	db	0

;  260  "conversion array size exceeds maximum permitted"
	db	"conversion "
	db	131
	db	149
	db	0

;  261  "addition caused real overflow"
	db	163
	db	228
	db	0

;  262  "division caused real overflow"
	db	160
	db	228
	db	0

;  263  "multiplication caused real overflow"
	db	137
	db	228
	db	0

;  264  "subtraction caused real overflow"
	db	143
	db	228
	db	0

;  265  "external function argument is not real"
	db	132
	db	1
	db	"real"
	db	0

;  266  "exponentiation caused real overflow"
	db	22
	db	228
	db	0

;  267  ""
	db	0

;  268  "inconsistent value assigned to keyword profile"
	db	"inconsistent "
	db	21
	db	"profile"
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

;  274  "value assigned to keyword fullscan is zero"
	db	21
	db	"fullscan "
	db	24
	db	"zero"
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

;  281  "char argument not integer"
	db	"char "
	db	2
	db	16
	db	11
	db	0

;  282  "char argument not in range"
	db	"char "
	db	2
	db	16
	db	202
	db	"range"
	db	0

;  283  ""
	db	0

;  284  "excessively nested include files"
	db	"excessively nested include files"
	db	0

;  285  "include file cannot be opened"
	db	"include "
	db	201
	db	"opened"
	db	0

;  286  "function call to undefined entry label"
	db	10
	db	"call "
	db	233
	db	141
	db	190
	db	0

;  287  "value assigned to keyword maxlngth is too small"
	db	21
	db	191
	db	24
	db	"too small"
	db	0

;  288  "exit second argument is not a string"
	db	212
	db	181
	db	0

;  289  "input channel currently in use"
	db	159
	db	168
	db	0

;  290  "output channel currently in use"
	db	136
	db	168
	db	0

;  291  ""
	db	0

;  292  ""
	db	0

;  293  ""
	db	0

;  294  ""
	db	0

;  295  ""
	db	0

;  296  ""
	db	0

;  297  ""
	db	0

;  298  "external function argument is not file"
	db	132
	db	1
	db	"file"
	db	0

;  299  "internal logic errorsecond second : unexpected ppm branch"
	db	"internal logic "
	db	164
	db	9
	db	9
	db	": "
	db	232
	db	"ppm branch"
	db	0

;  300  ""
	db	0

;  301  "atan argument not numeric"
	db	"atan "
	db	147
	db	0

;  302  "chop argument not numeric"
	db	"chop "
	db	147
	db	0

;  303  "cos argument not numeric"
	db	"cos "
	db	147
	db	0

;  304  "exp argument not numeric"
	db	"exp "
	db	147
	db	0

;  305  "exp produced real overflow"
	db	"exp "
	db	142
	db	0

;  306  "ln argument not numeric"
	db	"ln "
	db	147
	db	0

;  307  "ln produced real overflow"
	db	"ln "
	db	142
	db	0

;  308  "sin argument not numeric"
	db	"s"
	db	202
	db	147
	db	0

;  309  "tan argument not numeric"
	db	"tan "
	db	147
	db	0

;  310  "tan produced real overflow or argument is out of range"
	db	"tan "
	db	142
	db	" "
	db	162
	db	200
	db	0

;  311  "exponentiation of negative base to non-integral power"
	db	22
	db	193
	db	"negative base "
	db	233
	db	"non-integral power"
	db	0

;  312  "remdr caused real overflow"
	db	197
	db	228
	db	0

;  313  "sqrt argument not numeric"
	db	"sqrt "
	db	147
	db	0

;  314  "sqrt argument negative"
	db	"sqrt "
	db	254
	db	0

;  315  "ln argument negative"
	db	"ln "
	db	254
	db	0

;  316  "backspace argument is not a suitable name"
	db	157
	db	28
	db	0

;  317  "backspace file does not exist"
	db	157
	db	23
	db	192
	db	0

;  318  "backspace file does not permit backspace"
	db	157
	db	171
	db	"backspace"
	db	0

;  319  "backspace caused non-recoverable error"
	db	157
	db	18
	db	164
	db	0

;  320  "user interrupt"
	db	"user interrupt"
	db	0

;  321  "goto scontinue with no preceding error"
	db	231
	db	134
	db	0

;  322  "cos argument is out of range"
	db	"cos "
	db	200
	db	0

;  323  "sin argument is out of range"
	db	"s"
	db	202
	db	200
	db	0

;  324  ""
	db	0

;  325  ""
	db	0

;  326  "calling external function - bad argument type"
	db	236
	db	"bad "
	db	2
	db	"type"
	db	0

;  327  "calling external function - not found"
	db	236
	db	16
	db	"found"
	db	0

;  328  "load function - insufficient memory"
	db	145
	db	10
	db	"- "
	db	221
	db	"memory"
	db	0

;  329  "requested maxlngth too large"
	db	"requested "
	db	191
	db	"too large"
	db	0

;  330  "date argument is not integer"
	db	"date "
	db	135
	db	0

;  331  "goto scontinue with no user interrupt"
	db	231
	db	"with no user interrupt"
	db	0

;  332  "goto continue with error in failure goto"
	db	242
	db	"with "
	db	216
	db	202
	db	"failure goto"
	db	0

	global	phrases
phrases				    :	db	0

;    1  "argument is not "
	db	2
	db	24
	db	16
	db	0

;    2  "argument "
	db	"argument "
	db	0

;    3  "operand is not "
	db	"operand "
	db	24
	db	16
	db	0

;    4  "argument is not a string"
	db	1
	db	"a "
	db	178
	db	0

;    5  "is negative or too large"
	db	24
	db	"negative "
	db	162
	db	"too large"
	db	0

;    6  "syntax error: "
	db	"syntax "
	db	164
	db	": "
	db	0

;    7  "first "
	db	"first "
	db	0

;    8  "numeric"
	db	"numeric"
	db	0

;    9  "second "
	db	"second "
	db	0

;   10  "function "
	db	"function "
	db	0

;   11  "integer"
	db	"integer"
	db	0

;   12  "evaluated "
	db	"evaluated "
	db	0

;   13  "caused "
	db	"caused "
	db	0

;   14  "overflow"
	db	"overflow"
	db	0

;   15  " or expression"
	db	" "
	db	162
	db	"expression"
	db	0

;   16  "not "
	db	"not "
	db	0

;   17  "missing "
	db	"missing "
	db	0

;   18  "caused non-recoverable "
	db	13
	db	"non-recoverable "
	db	0

;   19  "right "
	db	"right "
	db	0

;   20  "real overflow"
	db	"real "
	db	14
	db	0

;   21  "value assigned to keyword "
	db	158
	db	"assigned "
	db	233
	db	170
	db	0

;   22  "exponentiation "
	db	"exponentiation "
	db	0

;   23  "file does not "
	db	152
	db	"does "
	db	16
	db	0

;   24  "is "
	db	"is "
	db	0

;   25  "inappropriate "
	db	"inappropriate "
	db	0

;   26  "name"
	db	"name"
	db	0

;   27  "natural variable name"
	db	"natural variable "
	db	26
	db	0

;   28  "argument is not a suitable name"
	db	1
	db	"a sui"
	db	194
	db	26
	db	0

;   29  "argument is not appropriate name"
	db	1
	db	"appropriate "
	db	26
	db	0

;   30  "pattern"
	db	"pattern"
	db	0

;   31  "third argument is not a string"
	db	"third "
	db	4
	db	0

;  128  "left operand is not numeric"
	db	"left "
	db	3
	db	8
	db	0

;  129  "assignment left operand is not pattern"
	db	"assignment left "
	db	3
	db	30
	db	0

;  130  "goto "
	db	"go"
	db	233
	db	0

;  131  "array "
	db	"array "
	db	0

;  132  "external function "
	db	"external "
	db	10
	db	0

;  133  "out of range"
	db	"out "
	db	193
	db	"range"
	db	0

;  134  "with no preceding error"
	db	"with no preceding "
	db	164
	db	0

;  135  "argument is not integer"
	db	1
	db	11
	db	0

;  136  "output "
	db	237
	db	" "
	db	0

;  137  "multiplication "
	db	"multiplication "
	db	0

;  138  "operand is not a string or pattern"
	db	3
	db	"a "
	db	178
	db	" "
	db	162
	db	30
	db	0

;  139  "caused integer overflow"
	db	13
	db	11
	db	" "
	db	14
	db	0

;  140  "argument has null "
	db	2
	db	"has null "
	db	0

;  141  "undefined "
	db	"undefined "
	db	0

;  142  "produced real overflow"
	db	"produced "
	db	20
	db	0

;  143  "subtraction "
	db	"subtraction "
	db	0

;  144  "arg "
	db	"arg "
	db	0

;  145  "load "
	db	"load "
	db	0

;  146  "define "
	db	"define "
	db	0

;  147  "argument not numeric"
	db	2
	db	16
	db	8
	db	0

;  148  "syntax error: invalid use of "
	db	6
	db	"invalid use "
	db	193
	db	0

;  149  "size exceeds maximum permitted"
	db	"size exceeds maximum permitted"
	db	0

;  150  "dimension is zero, negative or out of range"
	db	"dimension "
	db	24
	db	"zero, negative "
	db	162
	db	133
	db	0

;  151  "endfile "
	db	"end"
	db	152
	db	0

;  152  "file "
	db	"file "
	db	0

;  153  "argument is missing a left paren"
	db	2
	db	24
	db	17
	db	"a left paren"
	db	0

;  154  "datatype name"
	db	"datatype "
	db	26
	db	0

;  155  "program function name"
	db	"program "
	db	10
	db	26
	db	0

;  156  "argument is not numeric"
	db	1
	db	8
	db	0

;  157  "backspace "
	db	"backspace "
	db	0

;  158  "value "
	db	"value "
	db	0

;  159  "input "
	db	"input "
	db	0

;  160  "division "
	db	"division "
	db	0

;  161  "rewind "
	db	"rewind "
	db	0

;  162  "or "
	db	"or "
	db	0

;  163  "addition "
	db	"addition "
	db	0

;  164  "error"
	db	"error"
	db	0

;  165  "bound is not integer"
	db	"bound "
	db	24
	db	16
	db	11
	db	0

;  166  "first argument is not a string"
	db	7
	db	4
	db	0

;  167  "argument is negative or too large"
	db	2
	db	5
	db	0

;  168  "channel currently in use"
	db	"channel currently "
	db	202
	db	"use"
	db	0

;  169  "action caused irrecoverable error"
	db	"action "
	db	13
	db	"irrecoverable "
	db	164
	db	0

;  170  "keyword "
	db	217
	db	" "
	db	0

;  171  "file does not permit "
	db	23
	db	"permit "
	db	0

;  172  "sort/rsort "
	db	"sort/rsort "
	db	0

;  173  "argument is null"
	db	2
	db	24
	db	"null"
	db	0

;  174  "field "
	db	"field "
	db	0

;  175  "trace "
	db	"trace "
	db	0

;  176  "data "
	db	"data "
	db	0

;  177  "result in nreturn is not name"
	db	"result "
	db	202
	db	"nreturn "
	db	24
	db	16
	db	26
	db	0

;  178  "string"
	db	"string"
	db	0

;  179  "opsyn "
	db	"opsyn "
	db	0

;  180  "first arg is not correct operator name"
	db	7
	db	144
	db	24
	db	16
	db	"correct operat"
	db	162
	db	26
	db	0

;  181  "second argument is not a string"
	db	9
	db	4
	db	0

;  182  "does not evaluate to pattern"
	db	"does "
	db	16
	db	"evaluate "
	db	233
	db	30
	db	0

;  183  "right operand is not numeric"
	db	19
	db	3
	db	8
	db	0

;  184  "third argument is not integer"
	db	"third "
	db	135
	db	0

;  185  "erroneous "
	db	"erroneous "
	db	0

;  186  "inappropriate file specification for "
	db	25
	db	152
	db	"specification f"
	db	162
	db	0

;  187  " replacement right operand is not a string"
	db	" replacement "
	db	19
	db	3
	db	"a "
	db	178
	db	0

;  188  "label"
	db	"label"
	db	0

;  189  "function entry point is not defined label"
	db	10
	db	"entry point "
	db	24
	db	16
	db	"defined "
	db	188
	db	0

;  190  "entry label"
	db	"entry "
	db	188
	db	0

;  191  "maxlngth "
	db	"maxlngth "
	db	0

;  192  "exist"
	db	"exist"
	db	0

;  193  "of "
	db	"of "
	db	0

;  194  "table "
	db	"table "
	db	0

;  195  " match left operand is not a string"
	db	" match left "
	db	3
	db	"a "
	db	178
	db	0

;  196  "eject "
	db	"eject "
	db	0

;  197  "remdr "
	db	"remdr "
	db	0

;  198  "referenced with "
	db	"referenced with "
	db	0

;  199  "arg is not natural variable name"
	db	144
	db	24
	db	16
	db	27
	db	0

;  200  "argument is out of range"
	db	2
	db	24
	db	133
	db	0

;  201  "file cannot be "
	db	152
	db	"can"
	db	16
	db	"be "
	db	0

;  202  "in "
	db	"in "
	db	0

;  203  "replace "
	db	"replace "
	db	0

;  204  "second argument is not numeric"
	db	9
	db	156
	db	0

;  205  "first argument is not numeric"
	db	7
	db	156
	db	0

;  206  "by name returned "
	db	"by "
	db	26
	db	" returned "
	db	0

;  207  "concatenation "
	db	"concatenation "
	db	0

;  208  "second argument is not integer"
	db	9
	db	135
	db	0

;  209  "syntax error: unbalanced right "
	db	6
	db	"unbalanced "
	db	19
	db	0

;  210  "from "
	db	"from "
	db	0

;  211  "rtab "
	db	"r"
	db	244
	db	0

;  212  "exit "
	db	"exit "
	db	0

;  213  "2nd arg out of range or non-integer"
	db	"2nd "
	db	144
	db	133
	db	" "
	db	162
	db	"non-"
	db	11
	db	0

;  214  "during "
	db	"during "
	db	0

;  215  "substr "
	db	"substr "
	db	0

;  216  "error "
	db	"err"
	db	162
	db	0

;  217  "keyword"
	db	"keyword"
	db	0

;  218  "count exceeds value of stlimit keyword"
	db	"count exceeds "
	db	158
	db	193
	db	"stlimit "
	db	217
	db	0

;  219  " length exceeds value of maxlngth keyword"
	db	" length exceeds "
	db	158
	db	193
	db	191
	db	217
	db	0

;  220  "bracket"
	db	"bracket"
	db	0

;  221  "insufficient "
	db	"insufficient "
	db	0

;  222  "rpos "
	db	"r"
	db	252
	db	0

;  223  "value assigned is not integer"
	db	158
	db	"assigned "
	db	24
	db	16
	db	11
	db	0

;  224  "subscript is not integer"
	db	"subscript "
	db	24
	db	16
	db	11
	db	0

;  225  "operand is not name of defined keyword"
	db	3
	db	26
	db	" "
	db	193
	db	"defined "
	db	217
	db	0

;  226  "alternation "
	db	"alternation "
	db	0

;  227  "errtext not a string"
	db	"errtext "
	db	16
	db	"a "
	db	178
	db	0

;  228  "caused real overflow"
	db	13
	db	20
	db	0

;  229  "duplicate label"
	db	"duplicate "
	db	188
	db	0

;  230  "value assigned is negative or too large"
	db	158
	db	"assigned "
	db	5
	db	0

;  231  "goto scontinue "
	db	130
	db	"scontinue "
	db	0

;  232  "unexpected "
	db	"unexpected "
	db	0

;  233  "to "
	db	"to "
	db	0

;  234  "right paren"
	db	19
	db	"paren"
	db	0

;  235  "argument is missing a right paren"
	db	2
	db	24
	db	17
	db	"a "
	db	234
	db	0

;  236  "calling external function - "
	db	"calling "
	db	132
	db	"- "
	db	0

;  237  "output"
	db	"output"
	db	0

;  238  "argument has null variable name"
	db	140
	db	"variable "
	db	26
	db	0

;  239  "expression "
	db	"expression "
	db	0

;  240  "argument is not integer or expression"
	db	135
	db	15
	db	0

;  241  "argument is not a string or expression"
	db	4
	db	15
	db	0

;  242  "goto continue "
	db	130
	db	"continue "
	db	0

;  243  "evaluated argument is negative or too large"
	db	12
	db	167
	db	0

;  244  "tab "
	db	"tab "
	db	0

;  245  "evaluated argument is not integer"
	db	12
	db	135
	db	0

;  246  "statement "
	db	"statement "
	db	0

;  247  "first argument has null function name"
	db	7
	db	140
	db	10
	db	26
	db	0

;  248  "first argument is not suitable integer or string"
	db	7
	db	1
	db	"sui"
	db	194
	db	11
	db	" "
	db	162
	db	178
	db	0

;  249  "argument for output"
	db	2
	db	"f"
	db	162
	db	237
	db	0

;  250  "len "
	db	"len "
	db	0

;  251  " match right operand is not pattern"
	db	" match "
	db	19
	db	3
	db	30
	db	0

;  252  "pos "
	db	"pos "
	db	0

;  253  "evaluated argument is not a string"
	db	12
	db	4
	db	0

;  254  "argument negative"
	db	2
	db	"negative"
	db	0

;  255  "first argument upper bound is not integer"
	db	7
	db	2
	db	"upper "
	db	165
	db	0



