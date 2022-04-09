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
Starts from **run_main.s** that contains main function - the user input two string and their lengths, and an option number to pick an option on the menu. In additional, the function builds two Pstrings from the user's input as described - first char is the length of the string, and from the second the user's input string. 

**func_select.s** contains switch case implementation - the arguments are the two Pstrings and the choosen option from the menu. 

**pstring.s** contains all library functions (in brackets the number option):

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

