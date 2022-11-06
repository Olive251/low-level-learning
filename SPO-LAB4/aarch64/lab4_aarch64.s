.text
.globl _start

min = 0                          /* starting value for the loop index; note that this is a symbol (constant), not a variable */
max = 30                         /* loop exits when the index hits this number (loop condition is i<max) */
ten = 10

twoD_handler:  
    udiv    x22, x20, x10       /* elif loop >= 10, divide by '10'. Result is first digit */
                                /* ...first digit is in x22 */
    msub    x23, x10, x22, x20  /* second digit is stored in x23 */
    bl      twoD_output    
            
twoD_output:
    add     x22, x22, '0'   /* register to go in, register we're adding to, what we're adding */
    add     x23, x23, '0'

    adr     x21, msg_twoD+5
    strb    w22, [x21]      /* if storing less that 64 bits have to use low register (w20 instead of x20)*/
    adr     x21, msg_twoD+6
    strb    w23, [x21]

    mov     x0, 1           /* file descriptor: 1 is stdout */
    adr     x1, msg_twoD         /*  message location in memory */
    mov     x2, len_twoD         /*  message length in bytes */
    bl      end

oneD_output:
    add     x20, x20, '0'

    adr     x21, msg_oneD + 5
    strb    w20, [x21]

    mov     x0, 1           /* file descriptor: 1 is stdout */
    adr     x1, msg_oneD         /*  message location in memory */
    mov     x2, len_oneD         /*  message length in bytes */
    bl end

_start:

    mov     x19, min
    mov     x10, ten

determine_digits:

    /* ... body of the loop .. */
    mov     x20, x19        /* register moving to, register from */
    cmp x20, ten       /* if loop < 10, do nothing */
    b.ge  twoD_handler

    cmp x20, ten
    b.lt oneD_output   

end:
    mov     x8, 64          /*  write is syscall #64  */
    svc     0               /* invoke syscall   */

    add     x19, x19, 1
    cmp     x19, max
    b.ne    determine_digits

exit:
    mov     x0, 0           /* status -> 0 */
    mov     x8, 93          /* exit is syscall #93 */
    svc     0               /* invoke syscall */

.data

msg_oneD:    .ascii      "Loop #\n"
len_oneD=    . - msg_oneD
msg_twoD:    .ascii      "Loop ##\n"
len_twoD=    . - msg_twoD