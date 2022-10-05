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
	stp	fp, lr, [sp, #-16]!
	stp	x19, x20, [sp, #-16]!
	stp	x21, x22, [sp, #-16]!
	stp	x23, x24, [sp, #-16]!

	ldr	x19, [x0]		// Move rgbimage to non-volatile
	ldr	w21, [x0, #width]	// Get width and height
	ldr	w22, [x0, #height]
	mov	w23, #0			// int i = 0;

	mov	w0, w21
	mov	w1, w22
	bl 	allocate_grayimage	// allocate_grayimage( width, height);
	ldr	x20, [x0]		// x20 = grayimage
	mov	x18, x0

	mov	x10, #54		// Move numbers we are multiplying by to registers
	mov	x11, #184
	mov	x12, #18

loopa:  
	lsl	x7, x23, #3
	ldr x8, [x19, x7]
	ldr	x9, [x20, x7]
	mov	w24, #0			// int j = 0;

loopb:  
	//add	x6, x24, x24, lsl #1	// Get address to new pixel
	//ldr 	x0, [x8]
	//ldr	x1, [x9]
	ldrb	w2, [x8], #1		// Load each pixel byte
	ldrb	w3, [x8], #1
	ldrb	w4, [x8], #1

	mul	w2, w2, w10		// Perform color to gray calcs
	mul	w3, w3, w11
	mul	w4, w4, w12
	add	w2, w2, w3
	add	w2, w2, w4
	lsr	w2, w2, #8

	strb	w2, [x9]		// Store the byte

	add	x8, x8, #3		// Go to next pixel
	add 	x9, x9, #1
	add	w24, w24, #1
	cmp	w24, w21
	blt	loopb

	cmp	w23, w22
	blt	loopa

	mov	x0, x18			// Return the new gray image
	ldp	x23, x24, [sp], #16
	ldp	x21, x22, [sp], #16
	ldp	x19, x20, [sp], #16
	ldp	fp, lr, [sp], #16
	ret
	.size	color_to_gray, (. - color_to_gray)
