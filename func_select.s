#   //316125855 Avital Aviv
.section .rodata
option_50_or_60_first_printing: .string "first pstring length: %d, second pstring length: %d\n"
option_52_get_char: .string "%s %s"
option_52_printing_format: .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
option_53_get_two_ints: .string "%d %d"
option_53_printing_format: .string "length: %d, string: %s\nlength: %d, string: %s\n"
option_53_printing_error: .string "invalid input!\nlength: %d, string: %s\nlength: %d, string: %s\n"
option_54_for_print: .string "length: %d, string: %s\nlength: %d, string: %s\n"
invalid_option_str: .string "invalid option!\n"
error_option_55: .string "invalid input!\ncompare result: %d\n"
option_55_scanf_int: .string "%d\n%d"
option_55_print_format: .string "compare result: %d\n"

.align 8

.jump_table:
    .quad .option_50_or_60
    .quad .invalid_option   # 51
    .quad .option_52
    .quad .option_53
    .quad .option_54
    .quad .option_55
    .quad .


  .text
  .globl run_func
  .type run_func, @function
  .extern pstrlen,replaceChar, pstrijcpy, swapCase, pstrijcmp

#from run_main - got: rdi=option number, %rsi=first pointer, %rdx=second pointer
run_func:
    movq %rdi, %r10
    cmpq $60, %r10
    je .option_50_or_60
    sub $50, %r10
    cmpq $5, %r10         # if user input is 50
    ja .invalid_option
    jmp *.jump_table(,%r10,8)
    ret
    
 
.option_50_or_60:
    # %rsi=first pointer
    # %rdx=second pointer
    push %rbp
    movq %rsp, %rbp
    
    #first pstring - put in %rdi and call the function
    movq %rsi, %rdi
    call pstrlen
    # move result to rsi - the 2nd argument to printf
    movq %rax, %rsi
    
    # pstr2 (in %rdx) sent to function
    movq %rdx, %rdi
    call pstrlen
    # move result to rdx - the 3rd argument to printf
    movq %rax, %rdx
    
    # printing format moved to %rdi - first argument to printf
    movq $option_50_or_60_first_printing, %rdi
    movq $0, %rax
    call printf
    
    movq %rbp, %rsp
    pop %rbp
    ret


#from run_main - got: rdi=option number, %rsi=first pointer, %rdx=second pointer
.option_52:
    push %rbp
    movq %rsp, %rbp
    # 16 bytes from rsp to save the two chars
    leaq -16(%rsp), %rsp
    #push the pstrings to stack
    push %rdx
    push %rsi
    
    #get two chars
    movq $option_52_get_char, %rdi          # printing format
    leaq -8(%rbp), %rsi                     # old char
    leaq -16(%rbp), %rdx                    # new char
    movq $0, %rax
    call scanf
    
    pop %rsi
    movq %rsi, %rdi                         # put pstr1 in rdi - first arg in function
    movzbq -8(%rbp), %rsi                   # old char
    movzbq -16(%rbp), %rdx                  # new char
    call replaceChar
    pop %rdx
    movq %rdx, %rdi                         # put pstr2 from stack in first arg to function
    
    push %rax                               # push result
    movzbq -8(%rbp), %rsi                   # old char
    movzbq -16(%rbp), %rdx                  # new char
    call replaceChar
    leaq 1(%rax), %r8                       # r8 = pstr2 without size
    
    pop %rax
    leaq 1(%rax), %rcx                      # rcx = pstr1 without size
    movq $option_52_printing_format, %rdi
    movzbq -8(%rbp), %rsi
    movzbq -16(%rbp), %rdx
    movq $0, %rax
    call printf                              # printing
    
    leaq 16(%rsp), %rsp
    pop %rbp
    ret
    
.option_53:
    #from run_main - got: %rdi=option number, %rsi = pstr1, %rdx = pstr2
    push %rbp
    movq %rsp, %rbp
    # 16 bytes from rsp to save the two integers
    leaq -16(%rsp), %rsp
    # saving the pointers to the pstrings
    push %rdx
    push %rsi
    
    # getting two integers
    movq $option_53_get_two_ints, %rdi
    leaq -8(%rbp), %rsi                     # rsi = i
    leaq -16(%rbp), %rdx                    # rdx = j
    movq $0, %rax
    call scanf
    
    # set-up registers before calling function
    pop %rsi
    pop %rdx
    # push again the registers to save them to the printing function.
    push %rsi
    push %rdx
    movq %rsi, %rdi
    movq %rdx, %rsi
    movzbq -8(%rbp), %rdx
    movzbq -16(%rbp), %rcx
    call pstrijcpy
    
    # if the return value is -2 it means that the input is invalid
    cmpq $-2, %r15
    je .invalid_input_53
    
    # if the input is valid, and the return value from the function is not -2
    movq $option_53_printing_format, %rdi
    pop %rdx                                        # pstr2 is the src, function dont change it, so it can be taken from stack.
    movzbq (%rdx), %rcx
    # taking the len to r8 - the 5th argument to printf
    leaq 1(%rdx), %r8
    # pointer to the string - the 4th argument to printf
    movzbq (%rax), %rsi
    leaq 1(%rax), %rdx
    movq $0, %rax
    call printf
    
    # pop %rsi = pstr1 that left in the stack - used the result from the function.
    pop %rsi
    leaq 16(%rsp), %rsp
    movq %rbp, %rsp
    pop %rbp
    ret

# if the i,j was not in right range
.invalid_input_53:
# pstr2 is the src, function dont change it, so it can be taken from stack.
    pop %rdx
    movq $option_53_printing_error, %rdi
    movzbq (%rdx), %rcx
    leaq 1(%rdx), %r8
    # in rax, the rdi = pstr1 , when there was no change
    movzbq (%rax), %rsi
    leaq 1(%rax), %rdx
    movq $0, %rax
    #printing it
    call printf
    pop %rsi
    leaq 16(%rsp), %rsp
    movq %rbp, %rsp
    pop %rbp
    movq $0, %rax
    ret


.option_54:
    # rdi = option, %rsi = first pstring, %rdx = second pstring
    push %rbp
    movq %rsp, %rbp
    push %rdx
    
    # move pstr1 to rdi to switch ketters
    movq %rsi, %rdi
    Call swapCase
    # result in rax
    
    pop %rdx
    movq %rdx, %rdi             # rdi = pstr2
    push %rax                   # save the result on pstr1
    Call swapCase
    movq %rax, %r9              # result from pstr2 on r9
    
    # printings
    movq $option_54_for_print, %rdi
    pop %rax
    movzbq (%rax), %rsi         # rsi = pstr1.len
    leaq 1(%rax), %rdx          # rdx = pstr1 after changes
    movzbq (%r9), %rcx          # rcx = pstr2.len
    leaq 1(%r9), %r8            # r8 = pstr2 after changes
    movq $0, %rax
    call printf                 # printing

    movq %rsp, %rbp
    movq $0, %rax
    pop %rbp
    ret
    

.option_55:
    #from run_main - got: rdi=option number, %rsi=first pointer, %rdx=second pointer
    push %rbp
    movq %rsp, %rbp
    # 16 bytes from stack for two integers
    leaq -16(%rsp), %rsp
    push %rdx                                   # saving the pstrings in stack
    push %rsi
    
    # getting two integers
    movq $option_55_scanf_int, %rdi
    leaq -8(%rbp), %rsi                         # rsi = i
    leaq -16(%rbp), %rdx                        # rdx = j
    movq $0, %rax
    call scanf
    
    # set-up registers before calling function
    pop %rsi                                    # rsi = pstr1
    movq %rsi, %rdi                             # move pstr1 to rdi = first arg in function
    pop %rdx                                    # rdx = pstr2
    movq %rdx, %rsi                             # move pstr2 to rsi = second arg in function
    movzbq -8(%rbp), %rdx
    movzbq -16(%rbp), %rcx
    call  pstrijcmp                             # call function
    
    cmp $-2, %rax                               # if indexes are not in range
    je .error_message

    movq $option_55_print_format, %rdi
    movq %rax, %rsi                             # in rsi its the result after comparing in the func
    movq $0, %rax
    call printf
    
    leaq 16(%rsp), %rsp
    pop %rbp
    ret

    # if indexes not in range
.error_message:
    movq $error_option_55, %rdi
    movq %rax, %rsi                             # indexes not ok
    movq $0, %rax
    call printf
    leaq 16(%rsp), %rsp                         # ending of the function
    pop %rbp
    ret
    

# the default option - printing to the user the "invalid option" message
.invalid_option:
    movq $invalid_option_str, %rdi
    movq $0, %rax
    call printf
    ret
    
    
