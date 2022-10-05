	.text
	.type	bigint_adc, %function
	.global bigint_adc
bigint_adc:
	stp	fp, lr, [sp, #-16]!
	stp	x19, x20, [sp, #-16]!
	stp	x21, x22, [sp, #-16]!
	stp	x23, x24, [sp, #-16]!
	
	mov	x19, x0		// x19 = j
	mov	x20, x1		// x20 = r
	mov	x21, x2		// x21 = carry
	
	ldr	w22, [x19, #8]	// x22 = l->size
	ldr	w23, [x20, #8]	// x23 = r->size
	cmp	w22, w23	// if l->size <= r->size, branch
	ble	noswap

	mov	x0, x22		// swap l->size and r->size
	mov	x22, x23
	mov	x23, x0

	mov	x2, x19		// swap l and r
	mov	x19, x20
	mov	x20, x2

noswap:	add	x0, x23, #1	// r->size + 1
	bl	bigint_alloc	// bigint_alloc(r->size + 1)

	mov	x24, x0		// store x0 to x24
	ldr	x0, [x24]	// x0 = sum->blks

	ldr	x2, [x19]	// x2 = l->blks
	ldr	x3, [x20]	// x3 = r->blks

	mov	x1, #0		// int i = 0

addmatching:
	cmp	w1, w22		// i < l->size
	bge	endmatch

	ldr	x4, [x2]	// x4 = l->blks[i]
	ldr	x5, [x3]	// x5 = r->blks[i]
	
	adds	x6, x4, x21	// x6 += carry
	cset	x21, cs		// Set carry

	adds	x6, x6, x5	// x6 = x4 + x5
	cinc	x21, x21, cs	// Increment carry
	
	str	x6, [x0]	// store sum in sum
	
	add	x0, x0, #8	// Go to next chunk
	add	x2, x2, #8
	add	x3, x3, #8
	add	w1, w1, #1	// Increment i

	b	addmatching

endmatch:
	cmp	x4, #0		// l->blks[x1]
	bge	else

	mov	x8, #-1		// x8 = lsign = -1
	b	addremaining
else:	mov	x8, #0		// lsign = 0

addremaining:
	cmp	x1, x23		// i < r->size
	bge	endremaining
	
	ldr	x5, [x3]	// x5 = r->blks[i]
	adds	x6, x5, x21	// x6 += carry
	cset	x21, cs		// Set the carry bit

	adds	x6, x8, x6	// x6 = lsign + r->blks[i]
	cinc	x21, x21, cs	// Increment the carry
	str	x6, [x0]	// Store result to sum

	add	x0, x0, #8	// Go to next chunk
	add	x3, x3, #8
	add	x1, x1, #1	// Increment i
	
	b	addremaining

endremaining:
	cmp	x5, #0		// r->blks[r->size - 1] < 0
	bge	rsign

	mov	x9, #-1 	// rsign = -1
	b	end
rsign:	mov	x9, #0		// rsign = 0
end:
	add	x8, x8, x9	// x8 = lsign + rsign
	add	x8, x8, x21	// x8 += carry
	str	x8, [x0]	// sum->blks[r->size] = lsign + rsign + carry

	mov	x0, x24		// mov sum to x0

	bl	bigint_trim_in_place

	mov	x0, x24		// return pointer to sum

	ldp	x23, x24, [sp], #16
	ldp	x21, x22, [sp], #16
	ldp	x19, x20, [sp], #16
	ldp	fp, lr, [sp], #16
	ret
	.size	bigint_adc, (. - bigint_adc)
.end
