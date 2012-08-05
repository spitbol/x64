# COMPRESSED SPITBOL ERROR MESSAGES 08/04/12 17:17:57
#
	.sbttl	"errors"
	.arch	pentium
	.include	"systype.ah"

	DSeg_

	pubdef	errors,.byte,0

#    1  "addition left operand is not numeric"
	.byte	166
	.byte	128
	.byte	0

#    2  "addition right operand is not numeric"
	.byte	166
	.byte	183
	.byte	0

#    3  "addition caused integer overflow"
	.byte	166
	.byte	18
	.byte	0

#    4  "affirmation operand is not numeric"
	.ascii	"affirmation "
	.byte	3
	.byte	8
	.byte	0

#    5  "alternation right operand is not pattern"
	.byte	227
	.byte	22
	.byte	3
	.byte	30
	.byte	0

#    6  "alternation left operand is not pattern"
	.byte	227
	.byte	255
	.byte	3
	.byte	30
	.byte	0

#    7  "compilation error encountered during execution"
	.ascii	"compilation "
	.byte	152
	.ascii	" encountered "
	.byte	223
	.ascii	"execution"
	.byte	0

#    8  "concatenation left operand is not a string or pattern"
	.byte	206
	.byte	255
	.byte	139
	.byte	0

#    9  "concatenation right operand is not a string or pattern"
	.byte	206
	.byte	22
	.byte	139
	.byte	0

#   10  "negation operand is not numeric"
	.ascii	"negation "
	.byte	3
	.byte	8
	.byte	0

#   11  "negation caused integer overflow"
	.ascii	"negation "
	.byte	18
	.byte	0

#   12  "division left operand is not numeric"
	.byte	164
	.byte	128
	.byte	0

#   13  "division right operand is not numeric"
	.byte	164
	.byte	183
	.byte	0

#   14  "division caused integer overflow"
	.byte	164
	.byte	18
	.byte	0

#   15  "exponentiation right operand is not numeric"
	.byte	24
	.byte	183
	.byte	0

#   16  "exponentiation left operand is not numeric"
	.byte	24
	.byte	128
	.byte	0

#   17  "exponentiation caused integer overflow"
	.byte	24
	.byte	18
	.byte	0

#   18  "exponentiation result is undefined"
	.byte	24
	.ascii	"result "
	.byte	25
	.ascii	"undefined"
	.byte	0

#   19  ""
	.byte	0

#   20  "goto evaluation failure"
	.byte	131
	.ascii	"evaluation failure"
	.byte	0

#   21  "function called by name returned a value"
	.byte	10
	.ascii	"called "
	.byte	203
	.ascii	"a value"
	.byte	0

#   22  "undefined function called"
	.byte	141
	.byte	10
	.ascii	"called"
	.byte	0

#   23  "goto operand is not a natural variable"
	.byte	131
	.byte	3
	.ascii	"a natural variable"
	.byte	0

#   24  "goto operand in direct goto is not code"
	.byte	131
	.ascii	"operand "
	.byte	199
	.ascii	"direct "
	.byte	131
	.byte	25
	.byte	21
	.ascii	"code"
	.byte	0

#   25  "immediate assignment left operand is not pattern"
	.ascii	"immediate "
	.byte	130
	.byte	0

#   26  "multiplication left operand is not numeric"
	.byte	137
	.byte	128
	.byte	0

#   27  "multiplication right operand is not numeric"
	.byte	137
	.byte	183
	.byte	0

#   28  "multiplication caused integer overflow"
	.byte	137
	.byte	18
	.byte	0

#   29  "undefined operator referenced"
	.byte	141
	.ascii	"operat"
	.byte	165
	.ascii	"referenced"
	.byte	0

#   30  "pattern assignment left operand is not pattern"
	.byte	30
	.ascii	" "
	.byte	130
	.byte	0

#   31  "pattern replacement right operand is not a string"
	.byte	30
	.byte	185
	.byte	0

#   32  "subtraction left operand is not numeric"
	.byte	142
	.byte	128
	.byte	0

#   33  "subtraction right operand is not numeric"
	.byte	142
	.byte	183
	.byte	0

#   34  "subtraction caused integer overflow"
	.byte	142
	.byte	18
	.byte	0

#   35  "unexpected failure in -nofail mode"
	.ascii	"unexpected failure "
	.byte	199
	.ascii	"-nofail mode"
	.byte	0

#   36  "goto abort with no preceding error"
	.byte	131
	.ascii	"abort "
	.byte	134
	.byte	0

#   37  "goto continue with no preceding error"
	.byte	131
	.byte	242
	.byte	0

#   38  "goto undefined label"
	.byte	131
	.byte	141
	.byte	188
	.byte	0

#   39  "external function argument is not a string"
	.byte	133
	.byte	4
	.byte	0

#   40  "external function argument is not integer"
	.byte	133
	.byte	136
	.byte	0

#   41  "field function argument is wrong datatype"
	.byte	178
	.byte	10
	.byte	2
	.byte	25
	.ascii	"wrong datatype"
	.byte	0

#   42  "attempt to change value of protected variable"
	.ascii	"attempt "
	.byte	201
	.ascii	"change "
	.byte	159
	.byte	191
	.ascii	"protected variable"
	.byte	0

#   43  "any evaluated argument is not a string"
	.ascii	"any "
	.byte	247
	.byte	0

#   44  "break evaluated argument is not a string"
	.ascii	"break "
	.byte	247
	.byte	0

#   45  "breakx evaluated argument is not a string"
	.ascii	"breakx "
	.byte	247
	.byte	0

#   46  "expression does not evaluate to pattern"
	.byte	234
	.byte	184
	.byte	0

#   47  "len evaluated argument is not integer"
	.byte	237
	.byte	246
	.byte	0

#   48  "len evaluated argument is negative or too large"
	.byte	237
	.byte	236
	.byte	0

#   49  "notany evaluated argument is not a string"
	.ascii	"notany "
	.byte	247
	.byte	0

#   50  "pos evaluated argument is not integer"
	.byte	239
	.byte	246
	.byte	0

#   51  "pos evaluated argument is negative or too large"
	.byte	239
	.byte	236
	.byte	0

#   52  "rpos evaluated argument is not integer"
	.byte	213
	.byte	246
	.byte	0

#   53  "rpos evaluated argument is negative or too large"
	.byte	213
	.byte	236
	.byte	0

#   54  "rtab evaluated argument is not integer"
	.byte	211
	.byte	246
	.byte	0

#   55  "rtab evaluated argument is negative or too large"
	.byte	211
	.byte	236
	.byte	0

#   56  "span evaluated argument is not a string"
	.ascii	"span "
	.byte	247
	.byte	0

#   57  "tab evaluated argument is not integer"
	.byte	244
	.byte	246
	.byte	0

#   58  "tab evaluated argument is negative or too large"
	.byte	244
	.byte	236
	.byte	0

#   59  "any argument is not a string or expression"
	.ascii	"any "
	.byte	238
	.byte	0

#   60  "apply first arg is not natural variable name"
	.ascii	"apply "
	.byte	7
	.byte	192
	.byte	0

#   61  "arbno argument is not pattern"
	.ascii	"arbno "
	.byte	1
	.byte	30
	.byte	0

#   62  "arg second argument is not integer"
	.byte	143
	.byte	207
	.byte	0

#   63  "arg first argument is not program function name"
	.byte	143
	.byte	7
	.byte	1
	.byte	156
	.byte	0

#   64  "array first argument is not integer or string"
	.byte	132
	.byte	7
	.byte	136
	.ascii	" "
	.byte	165
	.byte	175
	.byte	0

#   65  "array first argument lower bound is not integer"
	.byte	132
	.byte	254
	.byte	0

#   66  "array first argument upper bound is not integer"
	.byte	132
	.byte	7
	.byte	2
	.ascii	"upper "
	.byte	162
	.byte	0

#   67  "array dimension is zero, negative or out of range"
	.byte	132
	.byte	150
	.byte	0

#   68  "array size exceeds maximum permitted"
	.byte	132
	.byte	149
	.byte	0

#   69  "break argument is not a string or expression"
	.ascii	"break "
	.byte	238
	.byte	0

#   70  "breakx argument is not a string or expression"
	.ascii	"breakx "
	.byte	238
	.byte	0

#   71  "clear argument is not a string"
	.ascii	"clear "
	.byte	4
	.byte	0

#   72  "clear argument has null variable name"
	.ascii	"clear "
	.byte	231
	.byte	0

#   73  "collect argument is not integer"
	.ascii	"collect "
	.byte	136
	.byte	0

#   74  "convert second argument is not a string"
	.ascii	"convert "
	.byte	179
	.byte	0

#   75  "data argument is not a string"
	.byte	176
	.byte	4
	.byte	0

#   76  "data argument is null"
	.byte	176
	.byte	161
	.byte	0

#   77  "data argument is missing a left paren"
	.byte	176
	.byte	151
	.byte	0

#   78  "data argument has null datatype name"
	.byte	176
	.byte	140
	.byte	155
	.byte	0

#   79  "data argument is missing a right paren"
	.byte	176
	.byte	230
	.byte	0

#   80  "data argument has null field name"
	.byte	176
	.byte	140
	.byte	178
	.byte	26
	.byte	0

#   81  "define first argument is not a string"
	.byte	147
	.byte	167
	.byte	0

#   82  "define first argument is null"
	.byte	147
	.byte	7
	.byte	161
	.byte	0

#   83  "define first argument is missing a left paren"
	.byte	147
	.byte	7
	.byte	151
	.byte	0

#   84  "define first argument has null function name"
	.byte	147
	.byte	240
	.byte	0

#   85  "null arg name or missing ) in define first arg."
	.ascii	"null "
	.byte	143
	.byte	26
	.ascii	" "
	.byte	165
	.byte	20
	.ascii	") "
	.byte	199
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
	.byte	136
	.byte	0

#   89  "dump argument is negative or too large"
	.ascii	"dump "
	.byte	169
	.byte	0

#   90  "dupl second argument is not integer"
	.ascii	"dupl "
	.byte	207
	.byte	0

#   91  "dupl first argument is not a string or pattern"
	.ascii	"dupl "
	.byte	167
	.ascii	" "
	.byte	165
	.byte	30
	.byte	0

#   92  "eject argument is not a suitable name"
	.byte	194
	.byte	28
	.byte	0

#   93  "eject file does not exist"
	.byte	194
	.byte	171
	.byte	0

#   94  "eject file does not permit page eject"
	.byte	194
	.byte	154
	.ascii	"page eject"
	.byte	0

#   95  "eject caused non-recoverable output error"
	.byte	194
	.byte	13
	.byte	138
	.byte	152
	.byte	0

#   96  "endfile argument is not a suitable name"
	.byte	215
	.byte	28
	.byte	0

#   97  "endfile argument is null"
	.byte	215
	.byte	161
	.byte	0

#   98  "endfile file does not exist"
	.byte	215
	.byte	171
	.byte	0

#   99  "endfile file does not permit endfile"
	.byte	215
	.byte	154
	.ascii	"endfile"
	.byte	0

#  100  "endfile caused non-recoverable output error"
	.byte	215
	.byte	13
	.byte	138
	.byte	152
	.byte	0

#  101  "eq first argument is not numeric"
	.ascii	"eq "
	.byte	204
	.byte	0

#  102  "eq second argument is not numeric"
	.ascii	"eq "
	.byte	205
	.byte	0

#  103  "eval argument is not expression"
	.ascii	"eval "
	.byte	1
	.ascii	"expression"
	.byte	0

#  104  "exit first argument is not suitable integer or string"
	.byte	210
	.byte	249
	.byte	0

#  105  "exit action not available in this implementation"
	.byte	210
	.ascii	"action "
	.byte	21
	.ascii	"available "
	.byte	199
	.ascii	"th"
	.byte	25
	.ascii	"implementation"
	.byte	0

#  106  "exit action caused irrecoverable error"
	.byte	210
	.byte	153
	.byte	0

#  107  "field second argument is not integer"
	.byte	178
	.byte	207
	.byte	0

#  108  "field first argument is not datatype name"
	.byte	178
	.byte	7
	.byte	1
	.byte	155
	.byte	0

#  109  "ge first argument is not numeric"
	.ascii	"ge "
	.byte	204
	.byte	0

#  110  "ge second argument is not numeric"
	.ascii	"ge "
	.byte	205
	.byte	0

#  111  "gt first argument is not numeric"
	.ascii	"gt "
	.byte	204
	.byte	0

#  112  "gt second argument is not numeric"
	.ascii	"gt "
	.byte	205
	.byte	0

#  113  "input third argument is not a string"
	.byte	160
	.byte	129
	.byte	0

#  114  "inappropriate second argument for input"
	.byte	19
	.byte	9
	.byte	253
	.byte	0

#  115  "inappropriate first argument for input"
	.byte	19
	.byte	7
	.byte	253
	.byte	0

#  116  "inappropriate file specification for input"
	.byte	186
	.byte	252
	.byte	0

#  117  "input file cannot be read"
	.byte	160
	.byte	200
	.ascii	"read"
	.byte	0

#  118  "le first argument is not numeric"
	.ascii	"le "
	.byte	204
	.byte	0

#  119  "le second argument is not numeric"
	.ascii	"le "
	.byte	205
	.byte	0

#  120  "len argument is not integer or expression"
	.byte	237
	.byte	241
	.byte	0

#  121  "len argument is negative or too large"
	.byte	237
	.byte	169
	.byte	0

#  122  "leq first argument is not a string"
	.ascii	"leq "
	.byte	167
	.byte	0

#  123  "leq second argument is not a string"
	.ascii	"leq "
	.byte	179
	.byte	0

#  124  "lge first argument is not a string"
	.ascii	"lge "
	.byte	167
	.byte	0

#  125  "lge second argument is not a string"
	.ascii	"lge "
	.byte	179
	.byte	0

#  126  "lgt first argument is not a string"
	.ascii	"lgt "
	.byte	167
	.byte	0

#  127  "lgt second argument is not a string"
	.ascii	"lgt "
	.byte	179
	.byte	0

#  128  "lle first argument is not a string"
	.ascii	"lle "
	.byte	167
	.byte	0

#  129  "lle second argument is not a string"
	.ascii	"lle "
	.byte	179
	.byte	0

#  130  "llt first argument is not a string"
	.ascii	"llt "
	.byte	167
	.byte	0

#  131  "llt second argument is not a string"
	.ascii	"llt "
	.byte	179
	.byte	0

#  132  "lne first argument is not a string"
	.ascii	"lne "
	.byte	167
	.byte	0

#  133  "lne second argument is not a string"
	.ascii	"lne "
	.byte	179
	.byte	0

#  134  "local second argument is not integer"
	.ascii	"local "
	.byte	207
	.byte	0

#  135  "local first arg is not a program function name"
	.ascii	"local "
	.byte	7
	.byte	143
	.byte	25
	.byte	21
	.ascii	"a "
	.byte	156
	.byte	0

#  136  "load second argument is not a string"
	.byte	144
	.byte	179
	.byte	0

#  137  "load first argument is not a string"
	.byte	144
	.byte	167
	.byte	0

#  138  "load first argument is null"
	.byte	144
	.byte	7
	.byte	161
	.byte	0

#  139  "load first argument is missing a left paren"
	.byte	144
	.byte	7
	.byte	151
	.byte	0

#  140  "load first argument has null function name"
	.byte	144
	.byte	240
	.byte	0

#  141  "load first argument is missing a right paren"
	.byte	144
	.byte	7
	.byte	230
	.byte	0

#  142  "load function does not exist"
	.byte	144
	.byte	10
	.ascii	"does "
	.byte	21
	.ascii	"exist"
	.byte	0

#  143  "load function caused input error during load"
	.byte	144
	.byte	10
	.ascii	"caused "
	.byte	160
	.byte	152
	.ascii	" "
	.byte	223
	.ascii	"load"
	.byte	0

#  144  "lpad third argument is not a string"
	.ascii	"lpad "
	.byte	129
	.byte	0

#  145  "lpad second argument is not integer"
	.ascii	"lpad "
	.byte	207
	.byte	0

#  146  "lpad first argument is not a string"
	.ascii	"lpad "
	.byte	167
	.byte	0

#  147  "lt first argument is not numeric"
	.ascii	"lt "
	.byte	204
	.byte	0

#  148  "lt second argument is not numeric"
	.ascii	"lt "
	.byte	205
	.byte	0

#  149  "ne first argument is not numeric"
	.ascii	"ne "
	.byte	204
	.byte	0

#  150  "ne second argument is not numeric"
	.ascii	"ne "
	.byte	205
	.byte	0

#  151  "notany argument is not a string or expression"
	.ascii	"notany "
	.byte	238
	.byte	0

#  152  "opsyn third argument is not integer"
	.byte	173
	.byte	182
	.byte	0

#  153  "opsyn third argument is negative or too large"
	.byte	173
	.ascii	"third "
	.byte	169
	.byte	0

#  154  "opsyn second arg is not natural variable name"
	.byte	173
	.byte	9
	.byte	192
	.byte	0

#  155  "opsyn first arg is not natural variable name"
	.byte	173
	.byte	7
	.byte	192
	.byte	0

#  156  "opsyn first arg is not correct operator name"
	.byte	173
	.byte	180
	.byte	0

#  157  "output third argument is not a string"
	.byte	138
	.byte	129
	.byte	0

#  158  "inappropriate second argument for output"
	.byte	19
	.byte	9
	.byte	248
	.byte	0

#  159  "inappropriate first argument for output"
	.byte	19
	.byte	7
	.byte	248
	.byte	0

#  160  "inappropriate file specification for output"
	.byte	186
	.byte	233
	.byte	0

#  161  "output file cannot be written to"
	.byte	138
	.byte	200
	.ascii	"written to"
	.byte	0

#  162  "pos argument is not integer or expression"
	.byte	239
	.byte	241
	.byte	0

#  163  "pos argument is negative or too large"
	.byte	239
	.byte	169
	.byte	0

#  164  "prototype argument is not valid object"
	.ascii	"prototype "
	.byte	1
	.ascii	"valid object"
	.byte	0

#  165  "remdr second argument is not numeric"
	.byte	195
	.byte	205
	.byte	0

#  166  "remdr first argument is not numeric"
	.byte	195
	.byte	204
	.byte	0

#  167  "remdr caused integer overflow"
	.byte	195
	.byte	18
	.byte	0

#  168  "replace third argument is not a string"
	.byte	198
	.byte	129
	.byte	0

#  169  "replace second argument is not a string"
	.byte	198
	.byte	179
	.byte	0

#  170  "replace first argument is not a string"
	.byte	198
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
	.byte	161
	.byte	0

#  174  "rewind file does not exist"
	.byte	163
	.byte	171
	.byte	0

#  175  "rewind file does not permit rewind"
	.byte	163
	.byte	154
	.ascii	"rewind"
	.byte	0

#  176  "rewind caused non-recoverable error"
	.byte	163
	.byte	13
	.byte	152
	.byte	0

#  177  "reverse argument is not a string"
	.ascii	"reverse "
	.byte	4
	.byte	0

#  178  "rpad third argument is not a string"
	.byte	251
	.byte	129
	.byte	0

#  179  "rpad second argument is not integer"
	.byte	251
	.byte	207
	.byte	0

#  180  "rpad first argument is not a string"
	.byte	251
	.byte	167
	.byte	0

#  181  "rtab argument is not integer or expression"
	.byte	211
	.byte	241
	.byte	0

#  182  "rtab argument is negative or too large"
	.byte	211
	.byte	169
	.byte	0

#  183  "tab argument is not integer or expression"
	.byte	244
	.byte	241
	.byte	0

#  184  "tab argument is negative or too large"
	.byte	244
	.byte	169
	.byte	0

#  185  "rpos argument is not integer or expression"
	.byte	213
	.byte	241
	.byte	0

#  186  "rpos argument is negative or too large"
	.byte	213
	.byte	169
	.byte	0

#  187  "setexit argument is not label name or null"
	.ascii	"set"
	.byte	210
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
	.byte	238
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
	.byte	177
	.ascii	"type"
	.byte	0

#  192  "substr third argument is not integer"
	.byte	216
	.byte	182
	.byte	0

#  193  "substr second argument is not integer"
	.byte	216
	.byte	207
	.byte	0

#  194  "substr first argument is not a string"
	.byte	216
	.byte	167
	.byte	0

#  195  "table argument is not integer"
	.byte	193
	.byte	136
	.byte	0

#  196  "table argument is out of range"
	.byte	193
	.byte	202
	.byte	0

#  197  "trace fourth arg is not function name or null"
	.byte	177
	.ascii	"fourth "
	.byte	143
	.byte	25
	.byte	21
	.byte	10
	.byte	26
	.ascii	" "
	.byte	165
	.ascii	"null"
	.byte	0

#  198  "trace first argument is not appropriate name"
	.byte	177
	.byte	7
	.byte	29
	.byte	0

#  199  "trace second argument is not trace type"
	.byte	177
	.byte	9
	.byte	1
	.byte	177
	.ascii	"type"
	.byte	0

#  200  "trim argument is not a string"
	.ascii	"trim "
	.byte	4
	.byte	0

#  201  "unload argument is not natural variable name"
	.ascii	"un"
	.byte	144
	.byte	1
	.byte	27
	.byte	0

#  202  "input from file caused non-recoverable error"
	.byte	160
	.byte	225
	.byte	145
	.byte	13
	.byte	152
	.byte	0

#  203  "input file record has incorrect format"
	.byte	160
	.byte	145
	.ascii	"record has incorrect format"
	.byte	0

#  204  "memory overflow"
	.ascii	"memory "
	.byte	14
	.byte	0

#  205  "string length exceeds value of maxlngth keyword"
	.byte	175
	.byte	221
	.byte	0

#  206  "output caused file overflow"
	.byte	138
	.byte	250
	.byte	0

#  207  "output caused non-recoverable error"
	.byte	138
	.byte	13
	.byte	152
	.byte	0

#  208  "keyword value assigned is not integer"
	.byte	170
	.byte	218
	.byte	0

#  209  "keyword in assignment is protected"
	.byte	170
	.byte	199
	.ascii	"assignment "
	.byte	25
	.ascii	"protected"
	.byte	0

#  210  "keyword value assigned is negative or too large"
	.byte	170
	.byte	232
	.byte	0

#  211  "value assigned to keyword errtext not a string"
	.byte	23
	.byte	226
	.byte	0

#  212  "syntax error: value used where name is required"
	.byte	6
	.byte	159
	.ascii	"used where "
	.byte	26
	.ascii	" "
	.byte	25
	.ascii	"required"
	.byte	0

#  213  "syntax error: statement is too complicated."
	.byte	6
	.byte	245
	.byte	25
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
	.byte	141
	.byte	165
	.byte	181
	.byte	190
	.byte	0

#  216  "syntax error: missing end line"
	.byte	6
	.byte	20
	.ascii	"end line"
	.byte	0

#  217  "syntax error: duplicate label"
	.byte	6
	.byte	235
	.byte	0

#  218  "syntax error: duplicated goto field"
	.byte	6
	.ascii	"duplicated "
	.byte	131
	.ascii	"field"
	.byte	0

#  219  "syntax error: empty goto field"
	.byte	6
	.ascii	"empty "
	.byte	131
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
	.byte	148
	.byte	255
	.byte	217
	.byte	0

#  223  "syntax error: invalid use of comma"
	.byte	148
	.ascii	"comma"
	.byte	0

#  224  "syntax error: unbalanced right parenthesis"
	.byte	209
	.ascii	"parenthesis"
	.byte	0

#  225  "syntax error: unbalanced right bracket"
	.byte	209
	.byte	217
	.byte	0

#  226  "syntax error: missing right paren"
	.byte	6
	.byte	20
	.byte	22
	.ascii	"paren"
	.byte	0

#  227  "syntax error: right paren missing from goto"
	.byte	6
	.byte	22
	.ascii	"paren "
	.byte	20
	.byte	225
	.ascii	"goto"
	.byte	0

#  228  "syntax error: right bracket missing from goto"
	.byte	6
	.byte	22
	.byte	217
	.ascii	" "
	.byte	20
	.byte	225
	.ascii	"goto"
	.byte	0

#  229  "syntax error: missing right array bracket"
	.byte	6
	.byte	20
	.byte	22
	.byte	132
	.byte	217
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
	.byte	175
	.ascii	" quote"
	.byte	0

#  233  "syntax error: invalid use of operator"
	.byte	148
	.ascii	"operator"
	.byte	0

#  234  "syntax error: goto field incorrect"
	.byte	6
	.byte	131
	.byte	178
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
	.byte	132
	.byte	196
	.ascii	"wrong number "
	.byte	191
	.ascii	"subscripts"
	.byte	0

#  237  "table referenced with more than one subscript"
	.byte	193
	.byte	196
	.ascii	"more than one subscript"
	.byte	0

#  238  "array subscript is not integer"
	.byte	132
	.byte	214
	.byte	0

#  239  "indirection operand is not name"
	.ascii	"indirection "
	.byte	3
	.byte	26
	.byte	0

#  240  "pattern match right operand is not pattern"
	.byte	30
	.byte	243
	.byte	0

#  241  "pattern match left operand is not a string"
	.byte	30
	.byte	197
	.byte	0

#  242  "function return from level zero"
	.byte	10
	.ascii	"return "
	.byte	225
	.ascii	"level zero"
	.byte	0

#  243  "function result in nreturn is not name"
	.byte	10
	.byte	174
	.byte	0

#  244  "statement count exceeds value of stlimit keyword"
	.byte	245
	.byte	220
	.byte	0

#  245  "translation/execution time expired"
	.ascii	"translation/execution time expired"
	.byte	0

#  246  "stack overflow"
	.ascii	"stack "
	.byte	14
	.byte	0

#  247  "invalid control statement"
	.ascii	"invalid control statement"
	.byte	0

#  248  "attempted redefinition of system function"
	.ascii	"attempted redefinition "
	.byte	191
	.ascii	"system function"
	.byte	0

#  249  "expression evaluated by name returned value"
	.byte	234
	.byte	12
	.byte	203
	.ascii	"value"
	.byte	0

#  250  "insufficient memory to complete dump"
	.byte	208
	.ascii	"memory "
	.byte	201
	.ascii	"complete dump"
	.byte	0

#  251  "keyword operand is not name of defined keyword"
	.byte	170
	.byte	222
	.byte	0

#  252  "error on printing to interactive channel"
	.byte	152
	.ascii	" on printing "
	.byte	201
	.ascii	"interactive channel"
	.byte	0

#  253  "print limit exceeded on standard output channel"
	.ascii	"print limit exceeded on standard "
	.byte	138
	.ascii	"channel"
	.byte	0

#  254  "erroneous argument for host"
	.byte	181
	.byte	2
	.ascii	"f"
	.byte	165
	.ascii	"host"
	.byte	0

#  255  "error during execution of host"
	.byte	152
	.ascii	" "
	.byte	223
	.ascii	"execution "
	.byte	191
	.ascii	"host"
	.byte	0

#  256  "sort/rsort 1st arg not suitable array or table"
	.byte	172
	.ascii	"1st "
	.byte	143
	.byte	21
	.ascii	"sui"
	.byte	193
	.byte	132
	.byte	165
	.ascii	"table"
	.byte	0

#  257  "erroneous 2nd arg in sort/rsort of vector"
	.byte	181
	.ascii	"2nd "
	.byte	143
	.byte	199
	.byte	172
	.byte	191
	.ascii	"vector"
	.byte	0

#  258  "sort/rsort 2nd arg out of range or non-integer"
	.byte	172
	.byte	224
	.byte	0

#  259  "fence argument is not pattern"
	.ascii	"fence "
	.byte	1
	.byte	30
	.byte	0

#  260  "conversion array size exceeds maximum permitted"
	.ascii	"conversion "
	.byte	132
	.byte	149
	.byte	0

#  261  "addition caused real overflow"
	.byte	166
	.byte	15
	.byte	0

#  262  "division caused real overflow"
	.byte	164
	.byte	15
	.byte	0

#  263  "multiplication caused real overflow"
	.byte	137
	.byte	15
	.byte	0

#  264  "subtraction caused real overflow"
	.byte	142
	.byte	15
	.byte	0

#  265  "external function argument is not real"
	.byte	133
	.byte	1
	.ascii	"real"
	.byte	0

#  266  "exponentiation caused real overflow"
	.byte	24
	.byte	15
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
	.byte	25
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
	.byte	21
	.byte	11
	.byte	0

#  282  "char argument not in range"
	.ascii	"char "
	.byte	2
	.byte	21
	.byte	199
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
	.byte	141
	.byte	190
	.byte	0

#  287  "value assigned to keyword maxlngth is too small"
	.byte	23
	.byte	187
	.byte	25
	.ascii	"too small"
	.byte	0

#  288  "exit second argument is not a string"
	.byte	210
	.byte	179
	.byte	0

#  289  "input channel currently in use"
	.byte	160
	.byte	168
	.byte	0

#  290  "output channel currently in use"
	.byte	138
	.byte	168
	.byte	0

#  291  "set first argument is not a suitable name"
	.byte	212
	.byte	7
	.byte	28
	.byte	0

#  292  "set first argument is null"
	.byte	212
	.byte	7
	.byte	161
	.byte	0

#  293  "inappropriate second argument to set"
	.byte	19
	.byte	9
	.byte	2
	.byte	201
	.ascii	"set"
	.byte	0

#  294  "inappropriate third argument to set"
	.byte	19
	.ascii	"third "
	.byte	2
	.byte	201
	.ascii	"set"
	.byte	0

#  295  "set file does not exist"
	.byte	212
	.byte	171
	.byte	0

#  296  "set file does not permit setting file pointer"
	.byte	212
	.byte	154
	.ascii	"setting "
	.byte	145
	.ascii	"pointer"
	.byte	0

#  297  "set caused non-recoverable i/o error"
	.byte	212
	.byte	13
	.ascii	"i/o "
	.byte	152
	.byte	0

#  298  "external function argument is not file"
	.byte	133
	.byte	1
	.ascii	"file"
	.byte	0

#  299  "Internal logic error: Unexpected PPM branch"
	.ascii	"Internal logic "
	.byte	152
	.ascii	": Unexpected PPM branch"
	.byte	0

#  300  ""
	.byte	0

#  301  "atan argument not numeric"
	.ascii	"atan "
	.byte	146
	.byte	0

#  302  "chop argument not numeric"
	.ascii	"chop "
	.byte	146
	.byte	0

#  303  "cos argument not numeric"
	.ascii	"cos "
	.byte	146
	.byte	0

#  304  "exp argument not numeric"
	.ascii	"exp "
	.byte	146
	.byte	0

#  305  "exp produced real overflow"
	.ascii	"exp "
	.byte	31
	.byte	0

#  306  "ln argument not numeric"
	.ascii	"ln "
	.byte	146
	.byte	0

#  307  "ln produced real overflow"
	.ascii	"ln "
	.byte	31
	.byte	0

#  308  "sin argument not numeric"
	.ascii	"s"
	.byte	199
	.byte	146
	.byte	0

#  309  "tan argument not numeric"
	.ascii	"tan "
	.byte	146
	.byte	0

#  310  "tan produced real overflow or argument is out of range"
	.ascii	"tan "
	.byte	31
	.ascii	" "
	.byte	165
	.byte	202
	.byte	0

#  311  "exponentiation of negative base to non-integral power"
	.byte	24
	.byte	191
	.ascii	"negative base "
	.byte	201
	.ascii	"non-integral power"
	.byte	0

#  312  "remdr caused real overflow"
	.byte	195
	.byte	15
	.byte	0

#  313  "sqrt argument not numeric"
	.ascii	"sqrt "
	.byte	146
	.byte	0

#  314  "sqrt argument negative"
	.ascii	"sqrt "
	.byte	2
	.ascii	"negative"
	.byte	0

#  315  "ln argument negative"
	.ascii	"ln "
	.byte	2
	.ascii	"negative"
	.byte	0

#  316  "backspace argument is not a suitable name"
	.byte	157
	.byte	28
	.byte	0

#  317  "backspace file does not exist"
	.byte	157
	.byte	171
	.byte	0

#  318  "backspace file does not permit backspace"
	.byte	157
	.byte	154
	.ascii	"backspace"
	.byte	0

#  319  "backspace caused non-recoverable error"
	.byte	157
	.byte	13
	.byte	152
	.byte	0

#  320  "user interrupt"
	.ascii	"user interrupt"
	.byte	0

#  321  "goto scontinue with no preceding error"
	.byte	131
	.byte	228
	.byte	0

#  322  "cos argument is out of range"
	.ascii	"cos "
	.byte	202
	.byte	0

#  323  "sin argument is out of range"
	.ascii	"s"
	.byte	199
	.byte	202
	.byte	0

#  324  ""
	.byte	0

#  325  ""
	.byte	0

#  326  "calling external function - bad argument type"
	.byte	229
	.ascii	"bad "
	.byte	2
	.ascii	"type"
	.byte	0

#  327  "calling external function - not found"
	.byte	229
	.byte	21
	.ascii	"found"
	.byte	0

#  328  "load function - insufficient memory"
	.byte	144
	.byte	10
	.ascii	"- "
	.byte	208
	.ascii	"memory"
	.byte	0

#  329  "requested maxlngth too large"
	.ascii	"requested "
	.byte	187
	.ascii	"too large"
	.byte	0

#  330  "date argument is not integer"
	.ascii	"date "
	.byte	136
	.byte	0

#  331  "goto scontinue with no user interrupt"
	.byte	131
	.ascii	"scontinue with no user interrupt"
	.byte	0

#  332  "goto continue with error in failure goto"
	.byte	131
	.ascii	"continue with "
	.byte	152
	.ascii	" "
	.byte	199
	.ascii	"failure goto"
	.byte	0

	pubdef	phrases,.byte,0

#    1  "argument is not "
	.byte	2
	.byte	25
	.byte	21
	.byte	0

#    2  "argument "
	.ascii	"argument "
	.byte	0

#    3  "operand is not "
	.ascii	"operand "
	.byte	25
	.byte	21
	.byte	0

#    4  "argument is not a string"
	.byte	1
	.ascii	"a "
	.byte	175
	.byte	0

#    5  "is negative or too large"
	.byte	25
	.ascii	"negative "
	.byte	165
	.ascii	"too large"
	.byte	0

#    6  "syntax error: "
	.ascii	"syntax "
	.byte	152
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

#   13  "caused non-recoverable "
	.ascii	"caused non-recoverable "
	.byte	0

#   14  "overflow"
	.ascii	"overflow"
	.byte	0

#   15  "caused real overflow"
	.ascii	"caused real "
	.byte	14
	.byte	0

#   16  "file does not "
	.byte	145
	.ascii	"does "
	.byte	21
	.byte	0

#   17  " or expression"
	.ascii	" "
	.byte	165
	.ascii	"expression"
	.byte	0

#   18  "caused integer overflow"
	.ascii	"caused "
	.byte	11
	.ascii	" "
	.byte	14
	.byte	0

#   19  "inappropriate "
	.ascii	"inappropriate "
	.byte	0

#   20  "missing "
	.ascii	"missing "
	.byte	0

#   21  "not "
	.ascii	"not "
	.byte	0

#   22  "right "
	.ascii	"right "
	.byte	0

#   23  "value assigned to keyword "
	.byte	159
	.ascii	"assigned "
	.byte	201
	.byte	170
	.byte	0

#   24  "exponentiation "
	.ascii	"exponentiation "
	.byte	0

#   25  "is "
	.ascii	"is "
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

#   31  "produced real overflow"
	.ascii	"produced real "
	.byte	14
	.byte	0

#  128  "left operand is not numeric"
	.byte	255
	.byte	3
	.byte	8
	.byte	0

#  129  "third argument is not a string"
	.ascii	"third "
	.byte	4
	.byte	0

#  130  "assignment left operand is not pattern"
	.ascii	"assignment "
	.byte	255
	.byte	3
	.byte	30
	.byte	0

#  131  "goto "
	.ascii	"go"
	.byte	201
	.byte	0

#  132  "array "
	.ascii	"array "
	.byte	0

#  133  "external function "
	.ascii	"external "
	.byte	10
	.byte	0

#  134  "with no preceding error"
	.ascii	"with no preceding "
	.byte	152
	.byte	0

#  135  "out of range"
	.ascii	"out "
	.byte	191
	.ascii	"range"
	.byte	0

#  136  "argument is not integer"
	.byte	1
	.byte	11
	.byte	0

#  137  "multiplication "
	.ascii	"multiplication "
	.byte	0

#  138  "output "
	.byte	233
	.ascii	" "
	.byte	0

#  139  "operand is not a string or pattern"
	.byte	3
	.ascii	"a "
	.byte	175
	.ascii	" "
	.byte	165
	.byte	30
	.byte	0

#  140  "argument has null "
	.byte	2
	.ascii	"has null "
	.byte	0

#  141  "undefined "
	.ascii	"undefined "
	.byte	0

#  142  "subtraction "
	.ascii	"subtraction "
	.byte	0

#  143  "arg "
	.ascii	"arg "
	.byte	0

#  144  "load "
	.ascii	"load "
	.byte	0

#  145  "file "
	.ascii	"file "
	.byte	0

#  146  "argument not numeric"
	.byte	2
	.byte	21
	.byte	8
	.byte	0

#  147  "define "
	.ascii	"define "
	.byte	0

#  148  "syntax error: invalid use of "
	.byte	6
	.ascii	"invalid use "
	.byte	191
	.byte	0

#  149  "size exceeds maximum permitted"
	.ascii	"size exceeds maximum permitted"
	.byte	0

#  150  "dimension is zero, negative or out of range"
	.ascii	"dimension "
	.byte	25
	.ascii	"zero, negative "
	.byte	165
	.byte	135
	.byte	0

#  151  "argument is missing a left paren"
	.byte	2
	.byte	25
	.byte	20
	.ascii	"a "
	.byte	255
	.ascii	"paren"
	.byte	0

#  152  "error"
	.ascii	"error"
	.byte	0

#  153  "action caused irrecoverable error"
	.ascii	"action caused irrecoverable "
	.byte	152
	.byte	0

#  154  "file does not permit "
	.byte	16
	.ascii	"permit "
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

#  157  "backspace "
	.ascii	"backspace "
	.byte	0

#  158  "argument is not numeric"
	.byte	1
	.byte	8
	.byte	0

#  159  "value "
	.ascii	"value "
	.byte	0

#  160  "input "
	.byte	252
	.ascii	" "
	.byte	0

#  161  "argument is null"
	.byte	2
	.byte	25
	.ascii	"null"
	.byte	0

#  162  "bound is not integer"
	.ascii	"bound "
	.byte	25
	.byte	21
	.byte	11
	.byte	0

#  163  "rewind "
	.ascii	"rewind "
	.byte	0

#  164  "division "
	.ascii	"division "
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

#  168  "channel currently in use"
	.ascii	"channel currently "
	.byte	199
	.ascii	"use"
	.byte	0

#  169  "argument is negative or too large"
	.byte	2
	.byte	5
	.byte	0

#  170  "keyword "
	.byte	219
	.ascii	" "
	.byte	0

#  171  "file does not exist"
	.byte	16
	.ascii	"exist"
	.byte	0

#  172  "sort/rsort "
	.ascii	"sort/rsort "
	.byte	0

#  173  "opsyn "
	.ascii	"opsyn "
	.byte	0

#  174  "result in nreturn is not name"
	.ascii	"result "
	.byte	199
	.ascii	"nreturn "
	.byte	25
	.byte	21
	.byte	26
	.byte	0

#  175  "string"
	.ascii	"string"
	.byte	0

#  176  "data "
	.ascii	"data "
	.byte	0

#  177  "trace "
	.ascii	"trace "
	.byte	0

#  178  "field "
	.ascii	"field "
	.byte	0

#  179  "second argument is not a string"
	.byte	9
	.byte	4
	.byte	0

#  180  "first arg is not correct operator name"
	.byte	7
	.byte	143
	.byte	25
	.byte	21
	.ascii	"correct operat"
	.byte	165
	.byte	26
	.byte	0

#  181  "erroneous "
	.ascii	"erroneous "
	.byte	0

#  182  "third argument is not integer"
	.ascii	"third "
	.byte	136
	.byte	0

#  183  "right operand is not numeric"
	.byte	22
	.byte	3
	.byte	8
	.byte	0

#  184  "does not evaluate to pattern"
	.ascii	"does "
	.byte	21
	.ascii	"evaluate "
	.byte	201
	.byte	30
	.byte	0

#  185  " replacement right operand is not a string"
	.ascii	" replacement "
	.byte	22
	.byte	3
	.ascii	"a "
	.byte	175
	.byte	0

#  186  "inappropriate file specification for "
	.byte	19
	.byte	145
	.ascii	"specification f"
	.byte	165
	.byte	0

#  187  "maxlngth "
	.ascii	"maxlngth "
	.byte	0

#  188  "label"
	.ascii	"label"
	.byte	0

#  189  "function entry point is not defined label"
	.byte	10
	.ascii	"entry point "
	.byte	25
	.byte	21
	.ascii	"defined "
	.byte	188
	.byte	0

#  190  "entry label"
	.ascii	"entry "
	.byte	188
	.byte	0

#  191  "of "
	.ascii	"of "
	.byte	0

#  192  "arg is not natural variable name"
	.byte	143
	.byte	25
	.byte	21
	.byte	27
	.byte	0

#  193  "table "
	.ascii	"table "
	.byte	0

#  194  "eject "
	.ascii	"eject "
	.byte	0

#  195  "remdr "
	.ascii	"remdr "
	.byte	0

#  196  "referenced with "
	.ascii	"referenced with "
	.byte	0

#  197  " match left operand is not a string"
	.ascii	" match "
	.byte	255
	.byte	3
	.ascii	"a "
	.byte	175
	.byte	0

#  198  "replace "
	.ascii	"replace "
	.byte	0

#  199  "in "
	.ascii	"in "
	.byte	0

#  200  "file cannot be "
	.byte	145
	.ascii	"can"
	.byte	21
	.ascii	"be "
	.byte	0

#  201  "to "
	.ascii	"to "
	.byte	0

#  202  "argument is out of range"
	.byte	2
	.byte	25
	.byte	135
	.byte	0

#  203  "by name returned "
	.ascii	"by "
	.byte	26
	.ascii	" returned "
	.byte	0

#  204  "first argument is not numeric"
	.byte	7
	.byte	158
	.byte	0

#  205  "second argument is not numeric"
	.byte	9
	.byte	158
	.byte	0

#  206  "concatenation "
	.ascii	"concatenation "
	.byte	0

#  207  "second argument is not integer"
	.byte	9
	.byte	136
	.byte	0

#  208  "insufficient "
	.ascii	"insufficient "
	.byte	0

#  209  "syntax error: unbalanced right "
	.byte	6
	.ascii	"unbalanced "
	.byte	22
	.byte	0

#  210  "exit "
	.ascii	"exit "
	.byte	0

#  211  "rtab "
	.ascii	"r"
	.byte	244
	.byte	0

#  212  "set "
	.ascii	"set "
	.byte	0

#  213  "rpos "
	.ascii	"r"
	.byte	239
	.byte	0

#  214  "subscript is not integer"
	.ascii	"subscript "
	.byte	25
	.byte	21
	.byte	11
	.byte	0

#  215  "endfile "
	.ascii	"end"
	.byte	145
	.byte	0

#  216  "substr "
	.ascii	"substr "
	.byte	0

#  217  "bracket"
	.ascii	"bracket"
	.byte	0

#  218  "value assigned is not integer"
	.byte	159
	.ascii	"assigned "
	.byte	25
	.byte	21
	.byte	11
	.byte	0

#  219  "keyword"
	.ascii	"keyword"
	.byte	0

#  220  "count exceeds value of stlimit keyword"
	.ascii	"count exceeds "
	.byte	159
	.byte	191
	.ascii	"stlimit "
	.byte	219
	.byte	0

#  221  " length exceeds value of maxlngth keyword"
	.ascii	" length exceeds "
	.byte	159
	.byte	191
	.byte	187
	.byte	219
	.byte	0

#  222  "operand is not name of defined keyword"
	.byte	3
	.byte	26
	.ascii	" "
	.byte	191
	.ascii	"defined "
	.byte	219
	.byte	0

#  223  "during "
	.ascii	"during "
	.byte	0

#  224  "2nd arg out of range or non-integer"
	.ascii	"2nd "
	.byte	143
	.byte	135
	.ascii	" "
	.byte	165
	.ascii	"non-"
	.byte	11
	.byte	0

#  225  "from "
	.ascii	"from "
	.byte	0

#  226  "errtext not a string"
	.ascii	"errtext "
	.byte	21
	.ascii	"a "
	.byte	175
	.byte	0

#  227  "alternation "
	.ascii	"alternation "
	.byte	0

#  228  "scontinue with no preceding error"
	.ascii	"s"
	.byte	242
	.byte	0

#  229  "calling external function - "
	.ascii	"calling "
	.byte	133
	.ascii	"- "
	.byte	0

#  230  "argument is missing a right paren"
	.byte	2
	.byte	25
	.byte	20
	.ascii	"a "
	.byte	22
	.ascii	"paren"
	.byte	0

#  231  "argument has null variable name"
	.byte	140
	.ascii	"variable "
	.byte	26
	.byte	0

#  232  "value assigned is negative or too large"
	.byte	159
	.ascii	"assigned "
	.byte	5
	.byte	0

#  233  "output"
	.ascii	"output"
	.byte	0

#  234  "expression "
	.ascii	"expression "
	.byte	0

#  235  "duplicate label"
	.ascii	"duplicate "
	.byte	188
	.byte	0

#  236  "evaluated argument is negative or too large"
	.byte	12
	.byte	169
	.byte	0

#  237  "len "
	.ascii	"len "
	.byte	0

#  238  "argument is not a string or expression"
	.byte	4
	.byte	17
	.byte	0

#  239  "pos "
	.ascii	"pos "
	.byte	0

#  240  "first argument has null function name"
	.byte	7
	.byte	140
	.byte	10
	.byte	26
	.byte	0

#  241  "argument is not integer or expression"
	.byte	136
	.byte	17
	.byte	0

#  242  "continue with no preceding error"
	.ascii	"continue "
	.byte	134
	.byte	0

#  243  " match right operand is not pattern"
	.ascii	" match "
	.byte	22
	.byte	3
	.byte	30
	.byte	0

#  244  "tab "
	.ascii	"tab "
	.byte	0

#  245  "statement "
	.ascii	"statement "
	.byte	0

#  246  "evaluated argument is not integer"
	.byte	12
	.byte	136
	.byte	0

#  247  "evaluated argument is not a string"
	.byte	12
	.byte	4
	.byte	0

#  248  "argument for output"
	.byte	2
	.ascii	"f"
	.byte	165
	.byte	233
	.byte	0

#  249  "first argument is not suitable integer or string"
	.byte	7
	.byte	1
	.ascii	"sui"
	.byte	193
	.byte	11
	.ascii	" "
	.byte	165
	.byte	175
	.byte	0

#  250  "caused file overflow"
	.ascii	"caused "
	.byte	145
	.byte	14
	.byte	0

#  251  "rpad "
	.ascii	"rpad "
	.byte	0

#  252  "input"
	.ascii	"input"
	.byte	0

#  253  "argument for input"
	.byte	2
	.ascii	"f"
	.byte	165
	.byte	252
	.byte	0

#  254  "first argument lower bound is not integer"
	.byte	7
	.byte	2
	.ascii	"lower "
	.byte	162
	.byte	0

#  255  "left "
	.ascii	"left "
	.byte	0

	DSegEnd_
	.end
