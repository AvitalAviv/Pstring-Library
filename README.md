# Pstring-Library
Assembly implementation of basic Pstring functions. 
Written in GAS/AT&T x86 Assembly as a part of Computer Structure course.

## Pstring Defenition
typedef struct {

char size;

char string[255];

} Pstring;


## Abstract
We were assigned a task to implement basic functions regarding pStrings in the assembly language:

* char pstrlen(Pstring* pstr) - return the length of a pString
* Pstring* replaceChar(Pstring* pstr, char oldChar, char newChar) - replace every occourance of the oldChar in the pString with the newChar given.
* Pstring* pstrijcpy(Pstring* dst, Pstring* src, char i, char j) - given a range, copy the the content of src to dst.
* Pstring* swapCase(Pstring* pstr) - itterate through the pString and change upper case letter to lower case, and vise verca, whilst ignoring non-letter characters.
* int pstrijcmp(Pstring* pstr1, Pstring* psrt2, char i, char j) - in a given range, determine the lexical relation between two pString.


## Project Files
## run_main.s
Starts from **run_main.s** that contains main function - the user input two string and their lengths (memory allocated on the stack frame) and an option number (integer) to pick an option on the menu. The function builds two Pstrings from the user's input as described.

## func_select.s
contains switch case implementation using jump table. First, clearing the offset between the user's choice and the cases on the jump table (In our case an off set of 50).  Each choice from the user can result in two outcomes: invoking a proper function from pstring.s or a default case which will print the prompt 'invalid option!'

## pstring.s

contains all library functions (in brackets the number option):

**pstrlen (50/60)**:
input - Pstring, output - length

**replaceChar (52)**:
input - Pstring and two chars, output - replaces first char in second char

**pstrijcpy (53)**:
input - Pstring1, Pstring2, i,j(ints), output - replace Pstring2[i:j] in Pstring1[i:j]

**swapCase (54)**:
input - Pstring, output - Pstring replaced all Capital letters with small letters and the opposite

**pstrijcmp (55)**:
input - Pstring1, Pstring2, i,j(ints), output - compare substring Pstring1[i:j] with Pstring2[i:j] and returns boolean expression

