#   //316125855 Avital Aviv
    .data
    .extern run_func
    .align 16
    .section .rodata
length_scan: .string "%d"
pstring_scan: .string "%s"
option_int_scan: .string "%d"
    
    
    .text
    .global run_main
    .type run_main, @function

run_main:
    push %rbp                     #setup stack
    movq  %rsp, %rbp
    subq  $544, %rsp              # allocating 544 bytes - 256*2 for both pstrings and 4 bytes for option number and the rest for stack reasons

    movq $length_scan, %rdi       # first pstring - scanf format
    leaq -256(%rbp), %rsi         # in 256 - the pstring size
    movq $0, %rax                 
    call scanf
    
    movq $pstring_scan, %rdi       # scanf format
    leaq -255(%rbp), %rsi          # from 255 - the string
    movq $0, %rax
    call scanf
    
    movq $length_scan, %rdi       # second pstring - scanf format
    leaq -512(%rbp), %rsi         # in 512 - the pstring size
    movq $0, %rax
    call scanf
    
    movq $pstring_scan, %rdi       # scanf format
    leaq -511(%rbp), %rsi          # from 511 - the string
    movq $0, %rax
    call scanf
    
    movq $option_int_scan, %rdi    # option number
    leaq -516(%rbp), %rsi          # save in 516 offset from rsp
    movq $0, %rax
    call scanf
    
    # rdi = option number, %rsi = pstr1, %rdx = pstr2
    movl -516(%rbp), %edi          # setup before calling the run_func function
    leaq -256(%rbp), %rsi
    leaq -512(%rbp), %rdx

    call run_func
   
    mov %rbp, %rsp
    pop %rbp
    ret

    