.section .data
data_obj:
        .long 32

.section .bss
        .comm bss_buffer, 8, 16

.section .rodata
print_fmt:
        .asciz "%#x\n"

.section .text
        .global main
        .type main, @function
main:
        pushq   %rbp
        movq    %rsp, %rbp

        leaq    print_fmt(%rip), %rdi
        movq    data_obj(%rip), %rsi
        call    printf

        leaq    print_fmt(%rip), %rdi
        leaq    bss_buffer(%rip), %rsi
        call    printf 

        movq    %rbp, %rsp
        popq    %rbp

        movq    $0x00, %rax
        ret
        
