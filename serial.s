# First segment in program.  Contains serial number string.
# If external functions are included, a call to the external
# function will appear in this segment as well, placed here
# by the code in load.asm.
#
        .sbttl          "SERIAL"
        .psize          80,132
        .arch           pentium
        .include        "systype.ah"

        Header_
        DSeg_
        pubname         serial
.ifne underscore
_serial:
.else
serial:
.endif
				.asciz          "28001"
        .balign         4
        pubdef          hasfpu,.long,0               #-1 if 80x87 present, else 0
        pubname         cprtmsg
.ifne  underscore
_cprtmsg:
.else
cprtmsg:
.endif
				.asciz          "(c) Copyright 1987-2009 Robert B. K. Dewar and Catspaw, Inc."
        DSegEnd_
        .end
