/**************************************************************************
 * helloas.S
 *
 * "Hello World" in ARM Assembly
 *
 * Aidan Justice
 *
 * Thur Jan 27, 2022
 *
 * This is a smiple Hello World program written in ARM assembly using 
 * Linux system calls.
 * This version will run without the C standard library, and provides its
 * own _start function.
 *
 * It should be assembled and linked as follows:
 *   as -o helloas.o helloas.S
 *   ld -o helloas helloas.o
 *************************************************************************/
    .data

msg:    .ascii "Hello World!\n"
len     = . - msg

    .text

.globl _start
    // main is called by the _start function which is in the C
    // standard library
_start:
    // write( int fd, const void *buf, size_t count )
    mov    x0, #1
    ldr    x1, =msg
    ldr    x2, =len
    mov    x8, #64
    svc    #0
    // return from main()
    mov    x0, #0           // Status -> 0
    mov    x8, #93
    svc    #0

.end
