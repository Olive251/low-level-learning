.text
.globl    _start

min = 0                         /* starting value for the loop index; note that this is a symbol (constant), not a variable */
max = 30                        /* loop exits when the index hits this number (loop condition is i<max) */
ten = 10

twoD_output:
    movq     %r15, %rax
    div     %r14        /* divide by 10 to get first digit, puts it in rax*/
                        /* ...quotient is in rdx */
    add     %rax, $'0'
    add     %rdx, $'0'

    movq    %rax, %r8
    movq    %rdx, %r9

    lea      $msg_two+5, %r10
    movq     %r11, %r10
    lea      $msg_two+6, %r10
    movq     %r10, %r12

    movq     $len_two, %rdx     /* message length */
    movq     $msg_two, %rcx     /* message location */
    movq     $1, %rdi           /* file descriptor stdout */
    movq     $1, %rax           /* syscall sys_write */
    syscall

    bl      end
oneD_output:
    movq    %r15, %rax
    

    lea      $msg_one+5, %r10
    movq     %r11, %r10

    movq     $len_two, %rdx     /* message length */
    movq     $msg_two, %rcx     /* message location */
    movq     $1, %rdi           /* file descriptor stdout */
    movq     $1, %rax           /* syscall sys_write */
    syscall

    bl      end


_start:
    mov     %r14, ten
    mov     %r15, min
    
determine_digits:
    mov     %r10, %r14
    cmp     %r10, ten
    jge twoD_output

    cmp     %r10, ten
    jl  oneD_output     
end:
    movq    $0, %rdi    /* exit status */
    movq    $60, %rax   /* syscall sys_exit */

exit:

.data
msg_one:    .ascii  "Loop #\n"
    len_one=    . - msg_one
msg_two:    .ascii  "Loop ##\n"
    len_two=    . - msg_two