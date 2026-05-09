
.section .data
fmt:
        .asciz "%p\n"
        
.section .bss
        .comm local_array, 8

.section .text
.global main
        .type main, @function
main:
        # This stack frame setup is necessary,
        # because printf() requires the stack
        # is 16bytes aligned.
        # We push rbp there will let rsp -= 8.
        # When call instruction is executed,it
        # will push rip will let rsp -= 8.
        # The result is,rsp -= 16,still 16bytes
        # aligned.
        pushq   %rbp
        movq    %rsp, %rbp

        # Same as "movq    $local_array, %rax".
        leaq    local_array, %rax
        movq    %rax, %rsi
        leaq    fmt, %rdi
        call    printf

        leaq    local_array, %rax
        leaq    2(%rax), %rax
#        leaq    local_array + 2, %rax
        
        movq    %rax, %rsi
        leaq    fmt, %rdi
        call    printf

        movq    %rbp, %rsp
        popq    %rbp
        
        movq    $0x00, %rdi
        call    exit
        
        

