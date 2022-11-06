.text
.globl _start

min = 0                          /* starting value for the loop index; note that this is a symbol (constant), not a variable */
max = 30                         /* loop exits when the index hits this number (loop condition is i<max) */
ten = 10
true = 0
false = 1

/* TODO - split into two seperate paths */
/* Program needs to choose between a single digit output or 2 digit output branches */ 
/* or just break up the msg handler */

_start:

    mov     x19, min
    mov     x10, ten

loop:

    /* ... body of the loop .. */
    mov     x20, x19        /* register moving to, register from */
    cmp x20, ten       /* if loop < 10, do nothing */
    b.ge  fd_handler

    cmp x20, ten
    b.le loop_cont        
            
loop_cont:
    add     x22, x22, '0'   /* register to go in, register we're adding to, what we're adding */
    add     x23, x23, '0'

    adr     x21, msg+5
    strb    w22, [x21]      /* if storing less that 64 bits have to us low register (w20 instead of x20)*/
    adr     x21, msg+6
    strb    w23, [x21]

    mov     x0, 1           /* file descriptor: 1 is stdout */
    adr     x1, msg         /*  message location in memory */
    mov     x2, len         /*  message length in bytes */

    mov     x8, 64          /*  write is syscall #64  */
    svc     0               /* invoke syscall   */

    /* End body of loop */

    add     x19, x19, 1
    cmp     x19, max
    b.ne    loop

    mov     x0, 0           /* status -> 0 */
    mov     x8, 93          /* exit is syscall #93 */
    svc     0               /* invoke syscall */

fd_handler:  
    udiv    x22, x20, x10       /* elif loop >= 10, divide by '10'. Result is first digit */
                                /* ...first digit is in x22 */
    msub    x23, x10, x22, x20  /* second digit is stored in x23 */
    bl loop_cont

.data
msg_1d:    .ascii      "Loop #\n"
msg_2d:    .ascii      "Loop ##\n"
len=    . - msg