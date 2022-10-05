/********************************************************************
 * lab4_1.S
 *
 * Arrays, Loops, and Function Part 1
 *
 * Aidan Justice
 *
 * Wed Feb 9, 2022
 *
 * Program to calculate checksum but with a bug.
 *
 * Compiled as follows:
 *    gcc -o lab4_1 lab4_1.S
 *******************************************************************/
        .data
str1:   .asciz  "Enter text (ctrl-D to end): "
str2:	.asciz	"%s\n"
str3:	.asciz  "\nThe checksum is %08X\n"
	.align  2

i:	.word   0		// int i = 0;
sum:	.word   0		// int sum = 0;
buffer: .skip   4096		// char buffer[4096];

	.text
	.type   main, %function
	.global main
main:
	stp	fp, lr, [sp, #-16]!
	stp	x19, x20, [sp, #-16]!

	adr	x19, buffer		// Get the address of the buffer
	ldr	x20, i			// int i = 0;

	ldr	x0, =str1
	bl 	printf

loop:
	bl 	getchar			// Get the char and store it in the array
	str 	w0, [x19, x20]
	cmp	w0, #-1
	beq	done			// If getchar returns -1, branch out
	add	x20, x20, #1		// i++;
	cmp	x20, #4095
	beq	done			// If i = 4095, branch out
	b 	loop
done:
	str	xzr, [x19, x20]		// Store 0 at buffer[i]

	ldr	x0, =buffer
	bl	checksum

	mov	x1, x0  
	ldr	x0, =str3
	bl	printf
	
	ldr	x0, =buffer
	bl 	checksum

	mov	x1, x0  
	ldr	x0, =str3
	bl	printf

	mov	w0, #0			// Return 0
	ldp	x19, x20, [sp], #16	// Restore the stack
	ldp	fp, lr, [sp], #16
	ret
	.size	main, (. - main)

	.text
	.type	checksum, %function
	.global checksum
checksum:
	stp	fp, lr, [sp, #-16]!
	stp	x19, x20, [sp, #-16]!
	str	x21, [sp, #-16]!
	
	mov	x19, x0			// Get the address of buffer
	adr	x20, sum		// Get the address of sum
	ldr	x21, sum

csloop:
	ldrb	w0, [x19]		// Load byte from buffer
	cmp	w0, #0
	beq	csdone			// If char = 0, branch out
	add	x21, x21, x0
	add 	x19, x19, #1
	b	csloop
csdone:
	str	w21, [x20]		// Store the new sum

	mov 	x0, x21			// Return the new sum
	ldr	x21, [sp], #16		// Restore the stack
	ldp	x19, x20, [sp], #16
	ldp	fp, lr, [sp], #16
	ret
	.size	checksum, (. - checksum)
.end
	
