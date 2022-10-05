	.data
str:	.asciz 	"%d %d %d %d"
str1:	.asciz	"Enter the number of pennies, nickels, dimes, and quarters for week %d: "
str2:	.asciz	"\nOver four weeks you have collected %d pennies, %d nickles, %d dimes, and %d quarters.\n"
str3:	.asciz	"\nThis comes to $%d.%d\n"
str4:	.asciz	"Your weekly average is $%d.%d\n"
str5:	.asciz	"Your estimated yearly savings is $%d.%d\n"
	.align	2

nump:	.word	0
numn:	.word	0
numd:	.word	0
numq:	.word	0

	.text
	.type 	main, %function
	.global main
main:
	stp	fp, lr, [sp, #-16]!
	stp	x19, x20, [sp, #-16]!
	stp	x21, x22, [sp, #-16]!
	str	x23, [sp, #-16]!

	mov	x19, #0		// x19 = numpennies
	mov	x20, #0		// x20 = numnickels
	mov	x21, #0		// x21 = numdimes
	mov	x22, #0		// x22 = numquarters
	mov	x23, #1		// i = 1
	
getcoins:
	cmp	x23, #4
	bgt	gotcoins

	ldr	x0, =str1
	mov	x1, x23
	bl	printf

	ldr	x0, =str
	ldr	x1, =nump
	ldr	x2, =numn
	ldr	x3, =numd
	ldr	x4, =numq
	bl	scanf

	ldr	x0, nump
	ldr	x1, numn
	ldr	x2, numd
	ldr	x3, numq

	add	x19, x19, x0
	add	x20, x20, x1
	add	x21, x21, x2
	add	x22, x22, x3
	add	x23, x23, #1

	b	getcoins
	
gotcoins:
	ldr	x0, =str2
	mov	x1, x19
	mov	x2, x20
	mov	x3, x21
	mov	x4, x22
	bl	printf

	mov	x0, #5
	mul	x20, x20, x0
	mov	x0, #10
	mul	x21, x21, x0
	mov	x0, #25
	mul	x22, x22, x0
	add	x19, x19, x20
	add	x19, x19, x21
	add	x19, x19, x22

	mov	x0, x19
	mov	x1, #100
	bl	divide
	
	mov	x2, x1
	mov	x1, x0
	ldr	x0, =str3
	bl	printf

	mov	x0, x19
	mov	w1, #400
	bl	divide

	mov	x19, x0
	mov	x0, x1
	mov	x1, #4
	bl	divide

	mov	x20, x0
	mov	x2, x0
	mov	x1, x19
	ldr	x0, =str4
	bl	printf
	
	lsl	x0, x19, #6		// Multiply the integer part by 100
	lsl	x1, x19, #5
	add	x19, x1, x19, lsl #2
	add	x19, x0, x19

	add	x19, x19, x20		// Add the integer part and the decimal part
	lsl	x0, x19, #5		// Multiply by 52
	lsl	x1, x19, #4
	add	x19, x1, x19, lsl #2
	add	x0, x19, x0

	mov	x1, #100
	bl	divide

	mov	x2, x1
	mov	x1, x0
	ldr	x0, =str5
	bl	printf

	ldr	x23, [sp], #16
	ldp	x21, x22, [sp], #16
	ldp	x19, x20, [sp], #16
	ldp	fp, lr, [sp], #16
	ret
	.size	main, (. - main)

	.global is_prime
	.type	is_prime, %function
is_prime:
	stp	fp, lr, [sp, #-16]!
	stp	x19, x20, [sp, #-16]!
	
	mov	x19, x0		// x19 = x
	mov	w20, #2		// x20 = i

	lsr	x8, x19, #1	// x8 = x / 2

findprime:
	cmp	x20, x8		// if i > x0, endprime
	bgt	endprime

	mov	x0, x19		// x0 = x
	mov	x1, x20		// x1 = i
	bl	divide		// divide(x, i)

	mov	x0, #0

	cmp	w1, #0		// if r == 0, endprime
	beq	end

	add	w20, w20, #1	// i++
	b	findprime

endprime:
	mov	x0, #1

end:
	ldp	x19, x20, [sp], #16
	ldp	fp, lr, [sp], #16
	ret
	.size	is_prime, (. - is_prime)

	.global	divide
	.type 	divide, %function
divide:
	stp	fp, lr, [sp, #-16]!

	mov	w2, w1		// temp = y
	mov	w3, #1		// quotient = 1

while:
	cmp	w2, w0
	bgt	endwhile

	add	w2, w2, w1
	add	w3, w3, #1

	b	while
endwhile:	
	sub 	w2, w2, w1
	sub	w3, w3, #1

	sub	w1, w0, w2
	mov	w0, w3

	ldp	fp, lr, [sp], #16
	ret
	.size	divide, (. - divide)
