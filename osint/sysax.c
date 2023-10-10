
/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2017 David Shields
*/

/*
/    zysax - after execution cleanup
/
/    Here we just indicate that further output should go to the
/    compiler output file, as opposed to stdout from executing program.
/
/    Parameters:
/        None
/    Returns:
/        Nothing
/    Exits:
/        None
*/

#include "port.h"

int
zysax()
{
    /*  swcoup does real work */
    swcoup(outptr);
    return NORMAL_RETURN;
}
