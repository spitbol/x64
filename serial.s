# copyright 1987-2012 robert b. k. dewar and mark emmer.
# 
# this file is part of macro spitbol.
# 
#     macro spitbol is free software: you can redistribute it and/or modify
#     it under the terms of the gnu general public license as published by
#     the free software foundation, either version 3 of the license, or
#     (at your option) any later version.
# 
#     macro spitbol is distributed in the hope that it will be useful,
#     but without any warranty; without even the implied warranty of
#     merchantability or fitness for a particular purpose.  see the
#     gnu general public license for more details.
# 
#     you should have received a copy of the gnu general public license
#     along with macro spitbol.  if not, see <http://www.gnu.org/licenses/>.
#
# first segment in program.  contains serial number string.
# if external functions are included, a call to the external
# function will appear in this segment as well, placed here
# by the code in load.asm.
#
        .include        "systype.ah"

        header_
        dseg_
        .balign         4
        pubdef          hasfpu,.long,0               #-1 if 80x87 present, else 0
        pubname         cprtmsg
.ifne  underscore
_cprtmsg:
.else
cprtmsg:
.endif
				.asciz          " copyright 1987-2012 robert b. k. dewar and mark emmer."
        dsegend_
        .end
