/*************************************************************************
 * hellogcc.S
 * 
 * "Hello World" in ARM Assembly
 *
 * Aidan Justice
 *
 * Thur Jan 27, 2022
 * 
 * This is a simple Hello World program written in ARM assembly and using
 * printf() from the C standard library.
 *
 * It should be compiled and linked as follows:
 *   gcc -o hellogcc hellogcc.S
 *
 * gcc will call the assembler and linker, telling the linker to include
 * the C standard library in the executable program.
 ************************************************************************/
    .data

msg:    .ascii "Hello World!\n"
len     = . - msg

    .text

.globl main
    // main is called by the _stary function which is in the C
    // standrd library
main:
    str     lr, [sp, #-16]!
    // write( int fd, const void *buf, size_t count)
    ldr     x0, =msg
    bl      printf
    // return from main()
    mov     x0, #0          //Status -> 0
    ldr     lr, [sp], #16
    ret
.end 
