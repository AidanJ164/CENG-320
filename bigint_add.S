	.data

	.equ	size, 8

	.text
	.type	bigint_adc, %function
	.global	bigint_adc
bigint_adc:
	stp	x29, x30, [sp, #-16]!
	stp	x19, x20, [sp, #-16]!
	stp	x21, x22, [sp, #-16]!
	stp	x23, x24, [sp, #-16]!

	mov	x19, x0
	mov	x20, x1
	mov	x21, x2

	add	x0, x0, #8
	ldr	w0, [x0]
	add	x1, x1, #8
	ldr	w1, [x1]

	cmp	x0, x1
	bge	lgreater

	mov	x2, x0
	mov	x0, x1
	mov	x1, x2

	mov	x2, x19
	mov	x19, x20
	mov	x20, x2
lgreater:
	mov	x22, x0
	mov	x23, x1

	add	x0, x0, #1
	bl	bigint_alloc

	mov	x24, x0
	ldr	x0, [x0]
	mov	x6, x23
	ldr	x1, [x19]
	ldr	x2, [x20]
	mov	x3, x21

loop:
	cmp	x6, #0
	ble	endloop

	ldr	x4, [x1]
	adds	x7, x4, x3
	cset	x3, cs

	ldr	x5, [x2]
	adds	x7, x7, x5
	cinc	x3, x3, cs
	str	x7, [x0]

	add	x0, x0, #8
	add	x1, x1, #8
	add	x2, x2, #8
	sub	x6, x6, #1
	b	loop

endloop:
	mov	x7, #0
	cmp	x5, #0
	bge	rsignnotset
	sub	x7, x7, #1
rsignnotset:
	sub	x6, x22, x23
	mov	x5, x7

loop2:
	cmp	x6, #0
	ble	endloop2

	ldr	x4, [x1]
	adds	x7, x4, x3
	cset	x3, cs

	adds	x7, x7, x5
	cinc	x3, x3, cs
	str	x7, [x0]

	add	x0, x0, #8
	add	x1, x1, #8
	sub	x6, x6, #1
	b	loop2

endloop2:
	mov	x7, #0
	cmp	x4, #0
	bge	lsignnotset
	sub	x7, x7, #1
lsignnotset:
	add	x7, x7, x3
	add	x7, x5, x7
	str	x7, [x0]

	mov	x0, x24
	bl	bigint_trim_in_place

	mov	x0, x24

	ldp	x23, x24,[sp], #16
	ldp	x21, x22,[sp], #16
	ldp	x19, x20,[sp], #16
	ldp	x29, x30,[sp], #16
	ret
.end
