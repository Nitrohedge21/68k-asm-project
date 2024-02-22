WaitVBlankStart:
	move.w  vdp_control, d0	; Move VDP status word to d0
	andi.w  #0x0008, d0     ; AND with bit 4 (vblank), result in status register
	bne     WaitVBlankStart ; Branch if not equal (to zero)
	rts

WaitVBlankEnd:
	move.w  vdp_control, d0	; Move VDP status word to d0
	andi.w  #0x0008, d0     ; AND with bit 4 (vblank), result in status register
	beq     WaitVBlankEnd   ; Branch if equal (to zero)
	rts

WaitFrames:
	; d0 - Number of frames to wait

	move.l  vblank_counter, d1 ; Get start vblank count

	@Wait:
	move.l  vblank_counter, d2 ; Get end vblank count
	subx.l  d1, d2             ; Calc delta, result in d2
	cmp.l   d0, d2             ; Compare with num frames
	bge     @End               ; Branch to end if greater or equal to num frames
	jmp     @Wait              ; Try again
	
	@End:
	rts