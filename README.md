## Pstring-Library
Written in Assembly x86 as a part of Computer Structure course.

Starts from **run_main.s** that conatins main function - the user input two string and their lengths, and an option number to pick an option on the menu. In additional, the function builds two Pstrings from the user's input as described - first char is the length of the string, and from the second the user's input string. 

**func_select.s** contains switch case implementation - the arguments are the two Pstrings and the choosen option from the menu. 

**pstring.s** contains all library functions (in brackets the number option):

**pstrlen**:
input - Pstring, output - length

**replaceChat**:
input - Pstring and two chars, output - replaces first char in second char

**pstrijcpy**:
input - Pstring1, Pstring2, i,j(ints), output - replace Pstring2[i:j] in Pstring1[i:j]

**swapCase**:
input - Pstring, output - Pstring replaced all Capital letters with small letters and the opposite

**pstrijcmp**:
input - Pstring1, Pstring2, i,j(ints), output - compare substring Pstring1[i:j] with Pstring2[i:j] and returns boolean expression

