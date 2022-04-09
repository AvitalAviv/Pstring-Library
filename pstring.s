#   //316125855 Avital Aviv
.section .rodata
print_invalid_input: .string "invalid input!\n"

.text
.globl pstrlen,replaceChar, pstrijcpy, swapCase, pstrijcmp
.global pstrlen
.type pstrlen, @function

# %rdi = *pstr
pstrlen:
    # with () getting the value in the first address = pstr len
    movzbq (%rdi), %rax
    ret


.global replaceChar
.type replaceChar, @function
replaceChar:
# %rdi = *pstr, %rsi = oldChar, %rdx = newChar
    movzbq (%rdi), %rcx                 # rcx = string len
    xorq %r9, %r9                       # r9 = 0 = loop counter

.Lreplace_char:    
    cmpq %r9, %rcx                      # check if r9(loop counter) is equals to string len(rcx)
    je .end_loop_bye    
    movq $0, %r8
    movb 1(%rdi,%r9,1), %r8b            # r8 = pstr[i]
    cmpq %r8, %rsi                      # check if pstr[i] == old char
    jne .chars_not_equals               # if they not equals
    movb %dl, 1(%rdi,%r9,1)             # if they equals, put new char in pstr[i]
       
.chars_not_equals:
    inc %r9                             # loop counter++
    jmp .Lreplace_char                  # continue loop
    
.end_loop_bye:                          # end of the loop
    movq %rdi, %rax
    ret


.global pstrijcpy
.type pstrijcpy, @function
# %rdi = *dst, %rsi = *src, %rdx = i, %rcx = j
pstrijcpy:
    # check if input is valid - if i,j in legal range
    movzbq (%rdi), %r9                  # r9 = pstr1.len
    movzbq (%rsi), %r10                 # r10 = pstr2.len
    inc %rdx
    inc %rcx
    cmp %rdx, %r9                       # check if i <= pstr1.len
    js .pstrijcpy_not_valid
    cmp %rdx, %r10                      # check if j <= pstr1.len
    js .pstrijcpy_not_valid
    cmp %rcx, %r9                       # check if i <= pstr2.len
    js .pstrijcpy_not_valid
    cmp %rcx, %r10                      # check if j <= pstr2.len
    js .pstrijcpy_not_valid
    dec %rdx
    dec %rcx
    
    # starting the loop -> indexes are ok
.start_loop_pstrijcpy:
    cmp %rdx, %rcx                      # check if i < j -> continue looping
    jb .end_loop_pstrijcpy
    movb 1(%rsi,%rdx,1), %r8b           # r11 = pstr2[i]
    movb %r8b, 1(%rdi,%rdx,1)           # move pstr2[i] into pstr1[i]
    inc %rdx                            # j++
    jmp .start_loop_pstrijcpy


.end_loop_pstrijcpy:
    movq %rdi, %rax                     # end of the loop, returning the pstr1=dst -> after changes
    ret

  
.pstrijcpy_not_valid:
    movq $-2, %r15                      # if indexes not ok, than put -2 into r15 register
    movq %rdi, %rax                     # moving to rax the rdi without changes
    ret
  

          
.global swapCase
.type swapCase, @function
swapCase:
# %rdi = *pstr
    movzbq (%rdi), %r9                  # r9 = pstring length
    movq $0, %r10                       # r10 = loop counter
    
    cmp %r9, %r10                       # check that loop counter < pstr.len
    je .bye                             # if loop counter == pstr.len, than end the loop

# start loop
.swap_start_loop:
    movq $0, %r8                
    movb 1(%rdi,%r10,1), %r8b           # r8b = pstr[r10] , r10 = loop counter
    cmp $65, %r8                        # check if r8b > 65
    js .go_on
    cmp $123, %r8                       # check if r8 > 122
    jns .go_on
    cmp $91, %r8                        # if r8 < 91
    jns .start_check
    addq $32, 1(%rdi,%r10,1)            # yes -> add 32

   # not a letter a-z or A-Z   
.go_on:
    inc %r10                            # move on loop counter
    cmp %r9, %r10                       # check that loop counter < pstr.len
    jb .swap_start_loop
    jmp .bye                            # if loop counter == pstr.len, than end the loop
    
.bye:
    movq %rdi, %rax
    ret

.start_check:
    cmp $97, %r8                        # if r8 < 97
    js .go_on
    subq $32, 1(%rdi,%r10,1)            # sub 32 from letter
    jmp .go_on
    

.global pstrijcmp
.type pstrijcmp, @function
pstrijcmp:
    # rdi = *dst , %rsi = *src , %rdx = i, %rcx = j
    push %rbp
    movq  %rsp, %rbp
    
    # checking input if valid
    movzbq (%rdi), %r10                    # r10 = dst.len
    sub $1, %r10                           # r10--
    cmp %rdx, %r10                         # if i (rdx) < dst.len (r10)
    js .error_for_input_55
    cmp %rcx, %r10                         # if j (rcx) < dst.len (r10)
    js .error_for_input_55
    movzbq (%rsi), %r10                    # r10 = src.len
    sub $1, %r10                           # r10--
    cmp %rdx, %r10                         # if i (rdx) < dsrc.len (r10)
    js .error_for_input_55
    cmp %rcx, %r10                         # if j (rcx) < dst.len (r10)
    js .error_for_input_55
    
.loop_start_55:
    cmp %rdx, %rcx                         # if i < j
    js .strings_equals_lexi
    movzbq 1(%rdi,%rdx,1), %r11            # r11 = pstr1[i]
    movzbq 1(%rsi,%rdx,1), %r12            # r12 = pstr2[i]
    cmp %r11, %r12                         # comparing ascii
    js .pstr1_bigger                       # pstr1[i] > pstr2[i]
    jg .pstr2_bigger                       # pstr1[i] < pstr2[i]
    inc %rdx                               # i++ 
    jmp .loop_start_55                     # if pstr1[i] = pstr2[i]


# return value is 1
.pstr1_bigger:
    movq $1, %rax
    pop %rbp
    ret

# return value is -1
.pstr2_bigger:
    movq $-1, %rax
    pop %rbp
    ret

# error in input    
.error_for_input_55:
    movq $-2, %rax
    pop %rbp
    ret

# return value is 0
.strings_equals_lexi:
    movq $0, %rax
    pop %rbp
    ret






