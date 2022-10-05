/*************************************************************************
 * lab3.S
 * 
 * C Library Input and Output
 *
 * Aidan Justice
 *
 * Thur Feb 3, 2022
 * 
 * This is a simple program that uses the C Library for input and output
 * and to get familiar with adding integers in assembly.
 *
 * It should be compiled and linked as follows:
 *   gcc -o lab3 lab3.S
 *
 * gcc will call the assembler and linker, telling the linker to include
 * the C standard library in the executable program.
 ************************************************************************/
        .data
str1:   .asciz  "%d"     // Format string for reading in a 32-bit int with scanf
        .align  2

str2:   .asciz  "%ld"    // Format string for reading in a 64-bit int with scanf
        .align  2

str3:   .asciz  "%d + %d =  %d\n"    // Format string for printing a 32-bit int with printf
        .align  2

str4:   .asciz  "%ld + %ld =  %ld\n"   // Format string for printing a 64-bit int with printf
        .align  2

n:      .word   0        // Initialize variables
m:      .dword  0
i:      .word   0
j:      .dword  0

        .text

        .global main
main:
    str lr, [sp, #-16]!  // Push lr onto the stack

    ldr x0, =str1        // Read in the first 32 bit int
    ldr x1, =n
    bl  scanf

    ldr x0, =str1        // Read in the second 32 bit int
    ldr x1, =i
    bl  scanf

    ldr w1, n            // Add the two 32 bit integers
    ldr w2, i
    add w3, w1, w2

    ldr x0, =str3        // Print out the sum
    bl  printf

    ldr x0, =str2        // Read in the first 64 bit int
    ldr x1, =m
    bl  scanf

    ldr x0, =str2        // Read in the second 64 bit in
    ldr x1, =j
    bl  scanf
 
    ldr x1, m            // Add the two 64 bit integers
    ldr x2, j
    add x3, x1, x2
 
    ldr x0, =str4        // Print out the sum
    bl  printf

    ldr lr, [sp], #16    // Pop lr from stack
    mov x0, #0           // Load return value
    ret                  // Return
    .end
