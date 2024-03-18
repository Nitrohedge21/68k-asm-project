	include 'common\spriteData.asm'

	LoadSprite:
   ; a0 - Font address (l)
   ; d0 - VRAM address (w)
   ; d1 - Num chars (w)

   swap     d0                   ; Shift VRAM addr to upper word
   add.l    #vdp_write_tiles, d0 ; VRAM write cmd + VRAM destination address
   move.l   d0, vdp_control      ; Send address to VDP cmd port

   subq.b   #0x1, d1             ; Num chars - 1
   @CharCopySprite:
   move.w   #0x07, d2            ; 8 longwords in tile
   @LongCopySprite:
   move.l   (a0)+, vdp_data      ; Copy one line of tile to VDP data port
   dbra     d2, @LongCopySprite
   dbra     d1, @CharCopySprite

   rts

   LoadSpriteTables:
	; a0 - Sprite data address
	; d0 - Number of sprites
	move.l	#vdp_write_sprite_table, vdp_control
	
	subq.b	#0x1, d0				; sprites attributes
	@AttrCopy:
	move.l	(a0)+, vdp_data
	move.l	(a0)+, vdp_data
	dbra	d0, @AttrCopy
	
	rts

	SetSpritePosX:
	; Set sprite X position
	; d0 (b) - Sprite ID
	; d1 (w) - X coord
	clr.l	d3						; Clear d3
	move.b	d0, d3					; Move sprite ID to d3
	
	mulu.w	#0x8, d3				; Sprite array offset
	add.b	#0x6, d3				; X coord offset
	swap	d3						; Move to upper word
	add.l	#vdp_write_sprite_table, d3	; Add to sprite attr table (at 0xD400)
	
	move.l	d3, vdp_control			; Set dest address
	move.w	d1, vdp_data			; Move X pos to data port
	
	rts

	SetSpritePosY:
	; Set sprite Y position
	; d0 (b) - Sprite ID
	; d1 (w) - Y coord
	clr.l	d3						; Clear d3
	move.b	d0, d3					; Move sprite ID to d3
	
	mulu.w	#0x8, d3				; Sprite array offset
	swap	d3						; Move to upper word
	add.l	#vdp_write_sprite_table, d3	; Add to sprite attr table (at 0xD400)
	
	move.l	d3, vdp_control			; Set dest address
	move.w	d1, vdp_data			; Move X pos to data port
	
	rts