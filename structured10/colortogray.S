/* color_to_gray will allocate a new grayimage structure and fill it
   with the grayscale equivalent of the given image.

   The C prototype is:

   grayimage *color_to_gray(rgbimage *image);

*/
	.data
	.equ	pixel, 3
	.equ	red, 0
	.equ	green, 1
	.equ	blue, 2
	.equ	rgbpixel, 0
	.equ	width, 8
	.equ	height, 12
	
	.text
	.type	color_to_gray, %function
	.global color_to_gray
 color_to_gray:
	/* Fill in the code to allocate a new grayimage, then convert
	   each pixel from the given rgbimage from color to grayscale,
	   and store it in the grayimage. */
	stp		fp, lr, [sp, #-16]!
	stp 	x19, x20, [sp, #-16]!
	stp		x21, x22, [sp, #-16]!

	ldr		x19, [x0]				// Move rgbimage to non-volatile
	ldr		w21, [x0, #width]		// Get width and height
	ldr		w22, [x0, #height]

	mov		w0, w21
	mov		w1, w22
	bl		allocate_grayimage
	mov		x15, x0
	ldr		x0, [x15]				// x0 = grayimage

	lsr		w16, w21, #3			// w16 = num of groups of 8
	and		w17, w21, #7			// w17 = num of remaining pixels

	mov		x10, #54		// Move numbers we are multiplying by to registers
	mov		x11, #184
	mov 	x12, #18
	dup		v3.8b, w10
	dup		v4.8b, w11
	dup		v5.8b, w12

	mov		w1, #0					// i = 0
loopheight:
	cmp		w1, w22
	bge		endheight

	ldr		x3, [x19], #8			// load row of rgbpixel
	ldr		x4, [x0], #8			// load row of graypixel
	mov		w2, #0					// j = 0
	
loop8:
	cmp		w2, w16
	bge		endloop8

	ld3		{v0.8b,v1.8b,v2.8b}, [x3], #24

	umull	v6.8h, v0.8b, v3.8b
 	umlal	v6.8h, v1.8b, v4.8b
	umlal	v6.8h, v2.8b, v5.8b
	uqshrn	v6.8b, v6.8h, #8

	st1		{v6.8b}, [x4], #8	

	add		w2, w2, #1
	b 		loop8
endloop8:

	mov		w2, #0
loopremaining:
	cmp		w2, w17
	bge		endremaining

	ldrb	w5, [x3]
	ldrb	w6, [x3, #green]
	ldrb	w7, [x3, #blue]

	mul		w5, w5, w10		// Perform color to gray calcs
	mul		w6, w6, w11
	mul		w7, w7, w12
	add		w5, w5, w6
	add		w5, w5, w7
	lsr		w5, w5, #8

	strb	w5, [x4], #1 

	add		x3, x3, #3
	add		w2, w2, #1
	b 		loopremaining
endremaining:
	add		w1, w1, #1
	b		loopheight
endheight:
	mov		x0, x15
	ldp		x21, x22, [sp], #16
	ldp		x19, x20, [sp], #16
	ldp		fp, lr, [sp], #16
	ret
	.size	color_to_gray, (. - color_to_gray)
