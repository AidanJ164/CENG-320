/********************************************************************
 * lab4_2.S
 *
 * Arrays, Loops, and Functions Part 2
 * 
 * Aidan Justice
 *
 * Wed Feb 16, 2022
 *
 * Program to calculate checksum
 *
 * Compiled as follows:
 *    gcc -o lab4_2 lab4_2.S
 *******************************************************************/
	.data
str1:	.asciz  "Enter text (ctrl-D to end): "
str2:	.asciz	"%s\n"
str3:	.asciz  "\nThe checksum is %08X\n"
buffer:	.skip	8

	.text
	.type	main, %function
	.global main
main:
	stp	fp, lr, [sp, #-16]!	// Store the registers
	stp	x19, x20, [sp, #-16]!
	str	x21, [sp, #-16]!

	sub	sp, sp, #4096		// char buffer[4096]
	adr	x8, buffer
	str	x30, [x8]

	adr	x21, buffer
	
	mov 	x19, #0			// int i = 0

	ldr	x0, =str1
	bl	printf

loop:
	bl	getchar		
	str	x0, [x21, x19]		// Store the character to buffer[i]
	cmp	w0, #-1
	beq	done			// If char = -1, branch out
	add	x19, x19, #1		// i++
	cmp	x19, #4095		// If i = 4095, branch out
	beq	done
	b	loop
done:
	mov	x0, #0			// Store 0 at buffer[i]
	str	x0, [x21, x19]
	
	mov	x0, x21
	bl	checksum

	mov	x1, x0
	ldr	x0, =str3
	bl	printf
	
	mov	x0, x21
	bl	checksum

	mov	x1, x0
	ldr	x0, =str3
	bl	printf

	mov	w0, #0			// Return 0
	add	sp, sp, #4096		// Delete the array
	ldr	x21, [sp], #16
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

	mov	x19, #0			// int i = 0
	mov	x20, #0			// int sum = 0
	mov	x21, x0

csloop:
	ldrb	w0, [x21, x19]		// Load byte from buffer[i]
	cmp	x0, #0
	beq	csdone			// If buffer[i] = 0, branch out
	add	x20, x20, x0		// Increase the sum
	add	x19, x19, #1		// i++;
	b	csloop
csdone:
	mov	x0, x20			// Return sum

	ldr	x21, [sp], #16
	ldp	x19, x20, [sp], #16
	ldp	fp, lr, [sp], #16
	ret
	.size	checksum, (. - checksum)
.end
