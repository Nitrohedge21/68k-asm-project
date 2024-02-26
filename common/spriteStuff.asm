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
