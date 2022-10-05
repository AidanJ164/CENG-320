	.data
str:	.asciz  "This program will create a table for f(x) = (x^3 - x^2 -2x)/(((x-2)^4)/11) + 3)\n"
str1:	.asciz	"%d"
str2:	.asciz	"Please give the lower limit of x: "
str3:	.asciz	"Please give the upper limit of x: "
str4:	.asciz	"Please give the number of rows in the table: "
str5:	.asciz	"\n"
str6:	.asciz  ": "
	.align	2

upperx:	.word	0
lowerx: .word	0
rows:	.word 	0

	.text
	.type	main, %function
	.global main
main:
	stp	fp, lr, [sp, #-16]!
	stp	x19, x20, [sp, #-16]!
	stp	x21, x22, [sp, #-16]!

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

	ldr	w19, lowerx
	ldr	w20, upperx
	sub	x0, x20, x19
	
	lsl	x0, x0, #16
	ldr	x1, rows
	bl	divide

	mov	x22, x0
	lsl	x19, x19, #16
	lsl	x20, x20, #16
	mov	x21, x19	// x21 = x
printtable:
	cmp	x21, x20
	bgt	end

	ldr	x0, =str5
	bl	printf
	
	mov	x0, x21
	mov	x1, #16
	bl	printS

	ldr	x0, =str6
	bl	printf
	
	mov	x0, x21	
	bl	calcfx

	mov	x1, #16
	bl	printS

	add	x21, x21, x22
	b	printtable

end:
	ldp	x21, x22, [sp], #16
	ldp	x19, x20, [sp], #16
	ldp	fp, lr, [sp], #16
	ret
	.size	main, (. - main)

	.type	calcfx, %function
	.global	calcfx
calcfx:
	stp	fp, lr, [sp, #-16]!
	stp	x19, x20, [sp, #-16]!

	lsl	x1, x0, #1		// 2x = U(16, 16)
	
	umull	x2, w0, w0		// xsq = U(32, 32)
	lsr	x2, x2, #16		// xsq = U(16, 16)

	umull	x3, w2, w0		// xcb = U(32, 32)
	lsr	x3, x3, #16		// xcb = U(16, 16)

	sub	x3, x3, x2
	sub	x19, x3, x1

	bl	calcdenom	  	// Get denominator for the function U(16, 16)

	mov	w1, w0
	lsl	x0, x19, #16
	bl	divide

	
	ldp	x19, x20, [sp], #16
	ldp	fp, lr, [sp], #16
	ret
	.size	calcfx, (. - calcfx)

	.type	calcdenom, %function
	.global calcdenom
calcdenom:
	stp	fp, lr, [sp, #-16]!

	mov	x1, #2
	lsl	x1, x1, #16		// 2 << 16
	sub	x0, x0, x1		// x - 2

	umull	x0, w0, w0		// xsq = U(32,32)
	lsr	x0, x0, #16		// xsq = U(16,16)

	umull	x0, w0, w0 		// x^4 = U(32,32)
	lsr	x0, x0, #16		// x^4 = U(16,16)

	ldr	w1, =0b00010111010001011101	// w1 = 1/11 U(0,20)
	umull	x0, w0, w1
	asr	x0, x0, #20

	mov	x1, #3
	lsl	x1, x1, #16		// x1 = 3 << 16 U(16,16)
	add	x0, x0, x1		
	
	ldp	fp, lr, [sp], #16
	ret
	.size	calcdenom, (. - calcdenom)

	.global	divide
	.type	divide, %function
divide:
	stp	fp, lr, [sp, #-16]!

	mov	x2, x1
	mov	x3, #1

while:
	cmp	x2, x0
	bgt	endwhile

	add	x2, x2, x1
	add	x3, x3, #1

	b	while
endwhile:
	sub	x2, x2, x1
	sub	x3, x3, #1

	sub	x1, x0, x2
	mov	x0, x3

	ldp	fp, lr, [sp], #16
	ret
	.size	divide, (. - divide)
