	.data
	.equ	array, 0
	.equ	frontindex,208
	.equ	endindex, 212
	.equ	nitems, 216

	.text
	.type	_ZN5queue5enqueEi, %function
	.global _ZN5queue5enqueEi
_ZN5queue5enqueEi:
	stp	fp, lr, [sp, #-16]!
	stp	x19, x20, [sp, #-16]!

	mov	x19, x0		// x19 = private data
	mov	x20, x1		// x20 = item

	bl 	_ZN5queue6isfullEv
	cmp	x0, #1
	mov	x0, #0
	beq	endone

	ldr	w1, [x19, #endindex]	// Load the endindex
	ldr	w2, [x19, #nitems]	// Load nitems
	str	w20, [x19, x1, lsl #2]	// array[endindex] = item

	add	w1, w1, #1
	cmp 	x1, #52
	blt	enelse
	mov	w1, #0
enelse:
	add	w2, w2, #1

	str	w1, [x19, #endindex]
	str	w2, [x19, #nitems]
	mov 	x0, #1
endone:
	ldp	x19, x20, [sp], #16
	ldp	fp, lr, [sp], #16
	ret
	.size	_ZN5queue5enqueEi, (. - _ZN5queue5enqueEi)

	.text
	.type	_ZN5queue5dequeERi, %function
	.global _ZN5queue5dequeERi
_ZN5queue5dequeERi:
	stp	fp, lr, [sp, #-16]!
	stp	x19, x20, [sp, #-16]!

	mov	x19, x0		// x19 = private data
	mov	x20, x1		// x20 = &item

	bl 	_ZN5queue7isemptyEv
	cmp 	x0, #1
	mov 	x0, #0
	beq	dedone
	
	ldr	w1, [x19, #frontindex]	// Load frontindex
	ldr	w2, [x19, #nitems]	// Load nitems
	ldr	w3, [x19, x1, lsl #2]
	str	w3, [x20]		// item = array[frontindex]

	add	w1, w1, #1		// frontindex++
	cmp	x1, #52			
	blt	deelse
	mov	w1, #0
deelse:
	sub 	w2, w2, #1
	
	str	w1, [x19, #frontindex]
	str	w2, [x19, #nitems]
	ldr	w0, [x20]
dedone:
	ldp	x19, x20, [sp], #16
	ldp	fp, lr, [sp], #16
	ret
	.size	_ZN5queue5dequeERi, (. - _ZN5queue5dequeERi)
