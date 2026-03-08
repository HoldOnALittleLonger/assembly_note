
.section .data

/* IA-32 architecture,not for x86-64 */
cpuid_bit_mask:
        .int    0x200000    /* the 21th bit */

pfmt_valid:
        .asciz  "Support CPUID instruction\n"
pfmt_valid_size:
        .byte . - pfmt_valid

pfmt_invalid:
        .ascii  "Do not support CPUID instruction\n"
pfmt_invalid_size:      
        .byte . - pfmt_invalid

pfmt_vendorID:  
        .asciz  "Vendor ID : %u%u%u\n"

.section .bss
        .lcomm  vendor_id, 16

.section .text
.global main
main:
        /* we do not store the general registers that we may use,
         * because we will just invoke sys_exit() to stop process.
         */
        
        pushq   %rbx
        movq    $0x00, %rbx
        pushf
        popq    %rbx
        andl    cpuid_bit_mask, %ebx
        popq    %rbx
        jnz     do_cpuid
        /* CPUID is not available */
        movq    $0x01, %rax
        movq    $0x01, %rdi
        lea     pfmt_invalid, %rsi
        movq    $0x00, %rdx
        movb    pfmt_invalid_size, %dl
        syscall /* invoke sys_write() */

        jmp     do_call_exit

do_cpuid:
        movq    $0x01, %rax
        movq    $0x01, %rdi
        lea     pfmt_valid, %rsi
        movb    pfmt_valid_size, %dl
        syscall

        movq    $0x00, %rax
	    movq    $0x00, %rsi
	    movq    $0x00, %rdx
	    movq    $0x00, %rcx
        
        cpuid
        lea     vendor_id, %r12
        movl    %ebx, (%r12)
        movl    %ecx, 4(%r12)
        movl    %edx, 8(%r12)
        lea     pfmt_vendorID, %rdi
        movl    (%r12), %esi
        movl    4(%r12), %edx
        movl    8(%r12), %ecx
        callq   printf

do_call_exit:
        movq    $0x3c, %rax
        movq    $0x00, %rdi
        syscall


        
