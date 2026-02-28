
.section .text
        .global _start

.section .data
v_16bit:
        .word 0
print_msg:
        .asciz "store and load FPU status word.\n"
print_msg_len:
        .byte . - print_msg

.section .text
        
_start:
        fstsw   %ax
        movw    %ax, v_16bit
        fldcw   v_16bit

        # invoke sys_write()
        movq    $0x01, %rax
        movq    $0x01, %rdi
        lea     print_msg, %rsi
        movq    print_msg_len, %rdx
        syscall

        # invoke sys_exit()
        movq    $0x3c, %rax
        movq    $0x00, %rdi
        syscall
        
