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
/   oswrite( mode, linesiz, recsiz, ioptr, scptr )
/
/   oswrite() writes the record in the passed SCBLK to the file associated
/   with the passed IOBLK.  There are two types of transfer:
/
/	unbuffered	write is done immediately
/
/	buffered	write is done into buffer
/
/   In either case, a new-line is appended to the record if in line mode
/   (mode == 1).
/
/   Parameters:
/	mode	1=line mode / 0=raw mode
/	linesiz output record length
/	recsiz	length of data being written
/	ioptr	pointer to IOBLK associated with output file
/	scptr	pointer to SCBLK to receive output record
/   Returns:
/	Number of I/O errors.  Should be 0.
*/

#include "port.h"

word oswrite( mode, linesiz, recsiz, ioptr, scptr )
word	mode;
word	linesiz;
register word	recsiz;
struct	ioblk	*ioptr;
struct	scblk	*scptr;

{
    char	*saveloc, savech;
    char	savech2;

    register char	*cp = scptr->str;
    register struct bfblk *bfptr = ((struct bfblk *) (ioptr->bfb));
    register word fdn = ioptr->fdn;
    word	linelen;
    int	ioerrcnt = 0;

    do {
        // If line mode, limit characters written on a line
        if ( mode == 1 && recsiz > linesiz )
            linelen = linesiz;
        else
            linelen = recsiz;
        recsiz -= linelen;

        /*
        /  If in line mode, temperarily replace the characte following the
        /  string (record) to be written with EOL.
        */
        if ( mode == 1 ) {
            saveloc = cp + linelen;
            savech = *saveloc;
            *saveloc = EOL;
            linelen++;
        }

        /*
        /  If unbuffered (IO_WRC), write the string directly to the file
        */
        if (ioptr->flg1 & IO_WRC ) {
            int actcnt;
            actcnt = write( fdn, cp, linelen );
            if ( actcnt != linelen ) {
                ioerrcnt++;
            }
            cp += actcnt;
        }

        /*
        /  If buffered, move the string into the file's buffer.
        /  There may be up to three parts to this operation:
        /  1. Data is used to fill an existing, partially filled buffer.
        /  2. Additional data larger than the buffer is written directly
        /     to the file.
        /  3. Any remaining data is copied to an empty buffer.  If the
        /     file is open for update, the buffer is loaded from the
        /     file prior to copying data to it.
        */
        else {
            while ( linelen > 0 && !ioerrcnt ) {


                /*
                 *   If no room in buffer (currently full), make room
                 * by flushing the buffer.
                 *
                 */
                if (bfptr->next == bfptr->size)
                    ioerrcnt += flush(ioptr);

                /*
                 *   If the current buffer write-in position is non-zero,
                 * there is something in the buffer to be retained.  Copy
                 * new stuff to the buffer.
                 *
                 *   If the current buffer write-in position is zero, there
                 * may or may not be something in the buffer that needs to
                 * be maintained.  If the amount of data being written
                 * exceeds the size of the buffer, any present contents of
                 * the buffer can be ignored (it will be overwritten in the
                 * file).  If the amount to be written is less than a buffer
                 * load, then it must be copied to the buffer.
                 *
                 */
                else if (bfptr->next || linelen < bfptr->size) {
                    register char *r;
                    register word n;

                    /*
                     *   If the buffer is truly empty, and the file is opened
                     * for input as well as output, and it is not a character
                     * device, then it must be filled prior to copying in the
                     * characters being written.
                     *
                     */
                    if (!bfptr->fill && ioptr->flg1 & IO_INP && testty(fdn))
                        if (fillbuf(ioptr) < 0) {
                            ioerrcnt++;
                            break;
                        }

                    n = bfptr->size - bfptr->next;	// space in buffer
                    if (n > linelen)				// if don't need it all
                        n = linelen;
                    linelen -= n;

                    r = bfptr->buf + bfptr->next;	// buffer write-in position
                    bfptr->next += n;

                    // copy n characters from *cp to *r
                    if ( n & 1 )
                        *r++ = *cp++;
                    if ( n & 2 ) {
                        *r++ = *cp++;
                        *r++ = *cp++;
                    }
                    n >>= 2;
                    while (--n >= 0) {
                        *r++ = *cp++;
                        *r++ = *cp++;
                        *r++ = *cp++;
                        *r++ = *cp++;
                    }

                    ioptr->flg2 |= IO_DIR;			// mark buffer dirty
                    if ( bfptr->next > bfptr->fill )
                        bfptr->fill = bfptr->next;
                }

                /*
                 *   Here if the current buffer write-in position is zero
                 * and the number of characters being written exceeds the
                 * size of the buffer.  For efficiency, we will bypass
                 * the buffer and write as many multiples of the buffer
                 * as possible.
                 */
                else {								// n==bfptr->size means ignore buffer contents
                    register word n,m;

                    fsyncio(ioptr);              // synchronize file and buffer
                    bfptr->fill = 0;				// discard contents

                    n = (linelen / bfptr->size) * bfptr->size;
                    m = write(fdn, cp, n);
                    if ( m != n

                       )
                        ioerrcnt++;

                    if (m > 0) {
                        cp += m;
                        linelen -= m;
                        bfptr->offset += m;
                        bfptr->curpos += m;
                    }
                }
            }

        }

        /*
        /  If in line mode, restore the character(s) that were temporarily
        /  replaced with EOL.
        */
        if ( mode == 1 ) {
            *saveloc = savech;
            cp--;
        }
    } while (recsiz > 0 && !ioerrcnt);

    /*
    /	Return number of errors.
    */
    return ioerrcnt;
}
