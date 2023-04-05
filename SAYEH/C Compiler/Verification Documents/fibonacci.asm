	mil	r0	ff ; r0 <- &N
	mih	r0	0
	lda	r3	r0
	mil	r0	1  ; last = 1 
	mih	r0	0
	mil	r1	1  ; before_last = 1
	mih	r1	0
	mil	r2	2  ; i = 2
	mih	r2	0
	ccf
_for:	cmp	r2	r3 ; if (i < N)
	brc	_cntue
	jpr	_lvFor
_cntue:	mov	r3	r0 ; old_last = last
	add	r0	r1 ; last = last +  before_last
	mov	r1	r3 ; before_last = old_last
	mil	r3	1  ; 
	mih	r3	0
	add	r2	r3 ; i++
	mil	r3	ff ; r3 <- &N
	mih	r3	0
	lda	r3	r3
	jpr	_for
_lvFor:	mil	r1	ff ; r0 <- &N
	mih	r1	0
	sta	r1	r0
	
