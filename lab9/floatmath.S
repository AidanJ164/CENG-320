	.data
str:	.asciz  "This program will create a table for f(x) = (x^3 - x^2 - 2x)/(((x-2)^4)/11) + 3)\n"
str1:	.asciz	"%d"
str2:	.asciz	"Please give the lower limit of x: "
str3:	.asciz	"Please give the upper limit of x: "
str4:	.asciz  "Please give the number of rows in the table: "
str5:	.asciz	"\n"
str6:	.asciz	": "
str7:	.asciz  "%.4f"
	.align	4

lowerx:	.word	0
upperx:	.word	0
rows:	.word	0

	.text
	.type	main, %function
	.global main
main:
	stp	fp, lr, [sp, #-16]!
	stp	d8, d9, [sp, #-16]!
	stp	d10, d11, [sp, #-16]!

	ldr	x0, =str
	bl	printf

	ldr	x0, =str2
	bl	printf

	ldr	x0, =str1
	ldr	x1, =lowerx
	bl	scanf
	
	ldr	x0, =str3
	bl	printf

	ldr	x0, =str1
	ldr	x1, =upperx
	bl	scanf

	ldr	x0, =str4
	bl	printf

	ldr	x0, =str1
	ldr	x1, =rows
	bl	scanf

	ldr	w0, lowerx		// w0 = lowerx
	ldr	w1, upperx		// w1 = upperx
	scvtf	d10, x0			// convert lower to float, use as i
	scvtf	d9, x1			// convert upper to float
	fsub	d0, d9, d10		// d0 = upperx - lowerx

	ldr	x0, rows		// load number of rows
	scvtf	d1, x0			// convert rows to float

	fdiv	d8, d0, d1		// (upper - lower) / rows

printtable:
	fcmp	d10, d9
	bgt	endprint

	ldr	x0, =str5
	bl	printf

	ldr	x0, =str7
	fmov	d0, d10
	bl	printf

	ldr	x0, =str6
	bl	printf

	fmov	d0, d10
	bl	calcfx

	ldr	x0, =str7
	bl	printf

	fadd	d10, d10, d8
	b	printtable

endprint:
	ldp	d10, d11, [sp], #16
	ldp	d8, d9, [sp], #16
	ldp	fp, lr, [sp], #16
	ret
	.size	main, (. - main)

	.type	calcfx, %function
	.global	calcfx
calcfx:
	stp	fp, lr, [sp, #-16]!

	fmov	d16, #2.0
	fmul	d1, d0, d16

	fmul	d2, d0, d0
	fmul	d3, d0, d2

	fsub	d3, d3, d2
	fsub	d3, d3, d1

	fsub	d4, d0, d16
	fmul	d4, d4, d4
	fmul	d4, d4, d4

	fmov	d16, #11.0
	fdiv	d4, d4, d16

	fmov	d16, #3.0
	fadd	d4, d4, d16

	fdiv	d0, d3, d4

	ldp	fp, lr, [sp], #16
	ret
	.size	calcfx, (. - calcfx)

	
	
