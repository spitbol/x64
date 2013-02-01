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
/	File:  COMPRESS.C	Version:  01.01
/	---------------------------------------
/
/	Contents:	Functions doexpand, docompress
/			Functions compress, expand
/
/	These functions are used to compress and expand a save file.
/
/	LZW data compression taken from an article by Mark R. Nelson in
/	the October 1989 Dr. Dobbs magazine.
/	Modified to flush table when full.
/
/	Note on memory allocation.  Both compression and decompression require
/	substantial tables.  Because a program is garbage collected prior to
/	being saved, there may exist a substantial block of memory between
/	dnamp and topmem.  The docompress and doexpand routines accept a pointer
/	to this block from the caller.  If the block provided is not large enough,
/	we call sbrk to extend the block as needed.  This additional memory is
/	released after the expansion/compression is completed.
/
/	IT IS ASSUMED THAT THE MEMORY PROVIDED BY THE CALLER IS THE LAST
/	ALLOCATED BLOCK ON THE HEAP, AND THAT ADDITIONAL MEMORY PROVIDED
/	BY SBRK() WILL BE CONTIGUOUS WITH THIS MEMORY.
/
*/


#include "port.h"
#include "sproto.h"
#include <string.h>

#define HASHING_SHIFT (LZWBITS-8)
#define MAX_VALUE ((1L << LZWBITS) - 1)
#define MAX_CODE (MAX_VALUE - 1)

#if LZWBITS == 14
#define TABLE_SIZE 18041		// The string table size needs to be a
#endif							// prime number that is somewhat larger
#if LZWBITS == 13               // than 2**LZWBITS
#define TABLE_SIZE 9029
#endif
#if LZWBITS == 12
#define	TABLE_SIZE 5021
#endif
#if LZWBITS == 11
#define	TABLE_SIZE 2551
#endif
#if LZWBITS <= 10
#define	TABLE_SIZE 1223
#endif


#define CODE_SIZE   (TABLE_SIZE*sizeof(short int))
#define PREFIX_SIZE (TABLE_SIZE*sizeof(short unsigned int))
#define APPEND_SIZE (TABLE_SIZE*sizeof(unsigned char))
#define DECODE_SIZE (4096*sizeof(unsigned char))
#define BUFF_SIZE (2048*sizeof(unsigned char))

static unsigned int input_code (word fd);
static void output_code (unsigned int code);
static unsigned char *decode_string (unsigned char *buffer, unsigned int code);
static int find_match (int hash_prefix, unsigned int hash_character);

/*
/ Memory needed for tables for expansion (EMEMORY) and compression (CMEMORY)
*/
#define EMEMORY (PREFIX_SIZE + APPEND_SIZE + DECODE_SIZE + BUFF_SIZE)
#define CMEMORY (CODE_SIZE + PREFIX_SIZE + APPEND_SIZE + DECODE_SIZE + BUFF_SIZE)

/*
/ doexpand - initialize or terminate expansion
*/
int doexpand(bits, freeptr, size)
int	bits;
char	*freeptr;
uword size;
{
    if (!(bits | expanding))	// If not expanding, nothing to do
        return 0;

    if (!bits && expanding)		// Turn off expansion
    {
        if (extra)
            sbrk(-extra);		// release any extra memory acquired
        extra = 0;
        expanding = 0;
        return 0;
    }

    if (bits == LZWBITS)          // turn on expansion
    {
        if (EMEMORY <= size)
            extra = 0;	// no extra memory needed
        else
        {
            extra = EMEMORY - size;	// extra memory needed
            if ((char *)sbrk((uword)extra) == (char *) -1)
                return 1;			// not available
        }
        expanding = bits;

        // initialize for expansion
        prefix_code = (short unsigned int *)freeptr;
        append_character = (unsigned char *)prefix_code + PREFIX_SIZE;
        decode_stack = (unsigned char *)append_character + APPEND_SIZE;
        buffer = decode_stack + DECODE_SIZE;
        bufcnt = 0;				// buffer is empty
        bit_buffer = 0L;
        bit_count = 0;
        return 0;
    }

    return 1;			// failure

}


/*
/	The following two routines are used to output variable length codes.
*/
static unsigned int input_code(fd)
word fd;
{
    unsigned int return_value;

    while (bit_count <= 24)
    {
        if (bufcnt <= 0)
        {
            bufcnt = read( fd, buffer, BUFF_SIZE);
            if (bufcnt < 0)
                return MAX_VALUE;
            if (!bufcnt) {				// provide 0 at EOF until ...
                *buffer = 0;			// ... bit_buffer is shifted out
                bufcnt++;
            }
            bufptr = buffer;
        }
        bit_buffer |= (unsigned long)*bufptr++ << (24-bit_count);
        bufcnt--;
        bit_count += 8;
    }
    return_value = (unsigned int)(bit_buffer >> (32-LZWBITS));
    bit_buffer <<= LZWBITS;
    bit_count -= LZWBITS;
    return return_value;
}

static void output_code(code)
unsigned int code;
{
    bit_buffer |= (unsigned long)code << (32-LZWBITS-bit_count);
    bit_count += LZWBITS;

    while (bit_count >= 8)
    {
        if (bufcnt >= BUFF_SIZE)
        {
            wrtaout((unsigned char *) buffer, bufcnt);
            bufptr = buffer;
            bufcnt = 0;
        }
        *bufptr++ = (unsigned char)(bit_buffer >> 24);
        bufcnt++;
        bit_buffer <<= 8;
        bit_count -= 8;
    }
}


/*
/	This routine simple decodes a string from the string table, storing
/	it in a buffer.  The buffer can then be output in reverse order by
/	the expansion program.
*/
static unsigned char *decode_string(buffer, code)
unsigned char *buffer;
unsigned int code;
{
    register int i;

    i = 0;
    while (code > 255)
    {
        *buffer++ = append_character[code];
        code = prefix_code[code];
        if (i++ >= 4000)
        {
            wrterr("Fatal error during save file expansion.");
            __exit(1);
        }
    }
    *buffer = (unsigned char) code;
    return buffer;
}


/*
/   expand( fd, startadr, size ) - read in section of file created by wrtaout()
/									with optional decompression.
/
/   Parameters:
/	fd		file descriptor
/	startadr	char pointer to first address to read
/	size		number of bytes to read
/   Returns:
/	0	successful
/	-2	error reading from a.out
/
/   Read data from .spx file.
*/
int
expand( fd, startadr, size )
int	fd;
unsigned char *startadr;
uword size;

{
    unsigned char *string;
    unsigned int character;
    unsigned int old_code;
    unsigned int new_code;
    unsigned int next_code;

    if (!expanding)
        return rdaout( fd, startadr, size );

    if (!size)
        return 0;

    next_code = 256;					// This is the next available code to define
    old_code = input_code(fd);			// Read in the first code, initialize the
    character = old_code;				// character variable, and send the first
    *startadr++ = old_code;				// code to the output file.
    size--;

    /*
    /	This is the main expansin loop.  It reads in characters from the LZW file
    /	until it sees the special code used to indicate the end of the data.
    */
    while ((new_code=input_code(fd)) != MAX_VALUE)
    {
        /*
        /	This code checks for the special STRING+CHARACTER+STRING+CHARACTER+STRING
        /	case, which generates an undefined code.  It handles it by decoding
        /	the last code, adding a single character tothe end of the decode string
        */
        if (new_code >= next_code)
        {
            *decode_stack = character;
            string = decode_string(decode_stack+1, old_code);
        }

        /*
        /	Otherwise we do a straight decode of the new code.
        */
        else
            string = decode_string(decode_stack, new_code);

        /*
        /	Now we output the decoded string in reverse order
        */
        character = *string;
        while (string >= decode_stack)
        {
            *startadr++ = *string--;
            size--;
        }

        /*
        /	Finally, if possible, add a new code to the string table.
        */
        if (next_code <= MAX_CODE)
        {
            prefix_code[next_code] = old_code;
            append_character[next_code] = character;
            next_code++;
        }
        old_code = new_code;
        if (next_code > MAX_CODE)
            next_code = 256;			// Restart codes when it gets too big
    }
    return (size == 0 ? 0 : -2);
}


/*
/	This is the hashing routine.  It tries to find a match for the prefix+char
/	string in the string table.  If it finds it, the index is returned.  If
/	the string is not found, the first available index in the string table is
/	returned instead.
*/
static int find_match(hash_prefix, hash_character)
int hash_prefix;
unsigned int hash_character;
{
    int index;
    int offset;

    index = (hash_character << HASHING_SHIFT) ^ hash_prefix;
    if (index == 0)
        offset = 1;
    else
        offset = TABLE_SIZE - index;

    for (;;)
    {
        if (code_value[index] == -1)
            return index;
        if (prefix_code[index] == hash_prefix && append_character[index] == hash_character)
            return index;
        index -= offset;
        if (index < 0)
            index += TABLE_SIZE;
    }
}


/*
/	docompress - initialize and terminate compression
*/
int docompress(bits, freeptr, size)
int	bits;
char	*freeptr;
uword size;
{
    if (!(bits | compressing))	// If not compressing, nothing to do
        return 0;

    if (!bits && compressing)	// Turn off compression
    {
        output_code(0);			// This code flushes the output buffer
        if (bufcnt)
            wrtaout((unsigned char *)buffer, bufcnt);
        bufcnt = 0;
        if (extra)
            sbrk(-extra);		// release any extra memory acquired
        extra = 0;
        compressing = 0;
        return 0;
    }

    if (bits == LZWBITS)          // turn on compression
    {
        if (CMEMORY <= size)
            extra = 0;	// no extra memory needed
        else
        {
            extra = CMEMORY - size;	// extra memory needed
            if ((char *)sbrk((uword)extra) == (char *) -1)
                return 1;			// not available
        }
        compressing = bits;

        // initialize for compression
        code_value = (short int *)freeptr;
        prefix_code = (short unsigned int *)((char *)code_value + CODE_SIZE);
        append_character = (unsigned char *)prefix_code + PREFIX_SIZE;
        decode_stack = (unsigned char *)append_character + APPEND_SIZE;
        buffer = decode_stack + DECODE_SIZE;
        bufcnt = 0;				// buffer is empty
        bufptr = buffer;
        bit_buffer = 0L;
        bit_count = 0;
        return 0;
    }

    return 1;			// failure

}


/*
/   compress( startadr, size )
/
/   Parameters:
/	startadr	char pointer to first address to write
/	size		number of bytes to write
/   Returns:
/	0	successful
/	-2	error writing memory to a.out
/
/   Write data to a.out file.
*/
int
compress( startadr, size )
unsigned char *startadr;
uword size;
{
    unsigned int index;
    unsigned int string_code;
    unsigned int character;
    unsigned int next_code;

    if (!compressing)
        return wrtaout( startadr, size );

    if (!size)
        return 0;

    next_code = 256;				// next_code is the next available string code

    // Clear out the string hash table before starting
    memset((void *)code_value, -1, TABLE_SIZE*sizeof(short int));

    string_code = *startadr++;		// Get the first code
    size--;

    /*
    /	This is the main loop where it all happens.  This loop runs until all of
    /	the input has been exhausted.  Note that it clears the table and starts over
    /	when all of the possible codes have been define.
    */
    while (size--)
    {
        character = *startadr++;

        index = find_match(string_code, character);	// See if the string is in
        if (code_value[index] != -1)				// the table.  If it is,
            string_code = code_value[index];		// get the code value.  If
        else										// the string is not in the
        {   // table, try to add it.
            if (next_code <= MAX_CODE)
            {
                code_value[index] = next_code++;
                prefix_code[index] = string_code;
                append_character[index] = character;
            }
            output_code(string_code);				// When a string is found
            string_code = character;				// that is not in the table,
            if (next_code > MAX_CODE)				// output the last string
            {   // after adding the new one
                // Clear out the string hash table and restart codes
                memset((void *)code_value, -1, TABLE_SIZE*sizeof(short int));
                next_code = 256;
            }
        }
    }

    /*
    /	End of the main loop
    */
    output_code(string_code);					// Output the last code
    output_code(MAX_VALUE);						// Output the buffer end code
    return 0;
}
