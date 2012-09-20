/*
Copyright 1987-2012 Robert B. K. Dewar and Mark Emmer.
Copyright 2012 David Shields

This file is part of Macro SPITBOL.

    Macro SPITBOL is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Macro SPITBOL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Macro SPITBOL.  If not, see <http://www.gnu.org/licenses/>.
*/


/*
    Define the C type word to be the same size as a word used
    by the Macro SPITBOL compiler.  The type of a word is a signed
    integer for now.
*/


typedef long word;
typedef unsigned long uword;

/* Size of integer accumulator */
#define IABITS 32

#if IABITS==32
typedef long IATYPE;
#elif IABITS==64
typedef long long IATYPE;
#endif

/*
    Some procedures use register to provide better code. Though
    gains are dubious, the uses remain, but with the name REGISTER.
    This permits avoid use of 'register' when debugging code, since
    all declared variables have associated storage.
*/

#define REGISTER

