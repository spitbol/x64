/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012-2013 David Shields

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/


/*
/   zysst - set file position
/
/   Parameters:
/	WA - FCBLK pointer
#if SETREAL
/  RA - 2nd argument (real number), offset
#else
/	WB - 2nd argument (might require conversion), offset
#endif
/	WC - 3rd argument (might require conversion), whence
/    Returns:
#if SETREAL
/  RA - File position
#else
/	IA - File position
#endif
/    Exits:
/	1 - invalid 2nd argument
/	2 - invlaid 3rd argument
/	3 - file does not exist
/	4 - set not allowed
/	5 - i/o error
/
/  PC-SPITBOL option form of SET:
/    WB = 'P':
/  		  set position to WC
/    WB = 'H'
/  		  set position to WC * 32768 + (current_position mod 32768)
/    WB = 'R'
/  		  set position to current_position + WC
/    WB = 'E'
/  		  set position to end_of_file + WC
/    WB = 'C'
/  		  set record length to WC for byte-stream file
/    WB = 'D'
/  		  delete record -- not supported
/
*/

#include "port.h"

zysst()

{
    long	whence, temp;
    FILEPOS  offset;
    register struct fcblk *fcb = WA (struct fcblk *);
    register struct ioblk *iob = ((struct ioblk *) (fcb->iob));
    register struct icblk *icp;

    // ensure iob is open, fail if unsuccessful
    if ( !(iob->flg1 & IO_OPN) )
        return EXIT_3;

    // not allowed to do a set of a pipe
    if ( iob->flg2 & IO_PIP )
        return EXIT_4;

    // whence may come in either integer or string form
    icp = WC( struct icblk * );
    if ( !getint(icp,&whence) )
        return EXIT_1;

#if SETREAL
    // offset comes in as a real in RA
    offset = RA(FILEPOS);
#else
    // offset may come in either integer or string form
    icp = WB( struct icblk * );
    if ( !getint(icp,&temp) ) {
        struct scblk *scp;
        scp = (struct scblk *)icp;
        if (!checkstr(scp) || scp->len != 1)
            return EXIT_1;
        temp = whence;
        switch (uppercase(scp->str[0])) {
        case 'P':
            whence = 0;
            break;

        case 'H':
            temp = (whence << 15) + ((int)doset(iob,0,1) & 0x7FFFL);
            whence = 0;
            break;

        case 'R':
            whence = 1;
            break;

        case 'E':
            whence = 2;
            break;

        case 'C':
            if ( fcb->mode == 0 && temp > 0 && temp <= (word)maxsize ) {
                fcb->rsz = temp;
                temp = 0;
                whence = 1;			// return current position
                break;
            }
            else {
                if (temp < 0 || temp > (word)maxsize)
                    return EXIT_2;
                else
                    return EXIT_1;
            }

        default:
            return EXIT_1;		// Unrecognised control
        }
    }
    offset = (FILEPOS)temp;
#endif
    //  finally, set the file position
    offset = doset( iob, offset, (int)whence );

    //  test for error.  01.02
    if ( offset < (FILEPOS)0 )
        return EXIT_5;
#if SETREAL
    //  return resulting position in RA.  01.07
    SET_RA( offset );
#else
    //  return resulting position in IA.  01.02
    SET_IA( (long)offset );
#endif

    // normal return
    return NORMAL_RETURN;
}
