	; Align 8 bytes
	nop 0,8

SpriteData: ; Font start address

	;First column
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000

	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000

	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000

	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	
	;Second column
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000

	dc.l	$00000000
	dc.l	$11111111
	dc.l	$10000000
	dc.l	$10001110
	dc.l	$10001010
	dc.l	$10001010
	dc.l	$10001010
	dc.l	$10001110

	dc.l	$10000000
	dc.l	$10000000
	dc.l	$10000000
	dc.l	$10000000
	dc.l	$10000000
	dc.l	$10000000
	dc.l	$11111111
	dc.l	$00001000

	dc.l	$00001000
	dc.l	$00001000
	dc.l	$00001000
	dc.l	$00001000
	dc.l	$00001110
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000

	;Third column
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000

	dc.l	$00000000
	dc.l	$11111111
	dc.l	$00000001
	dc.l	$01110001
	dc.l	$01010001
	dc.l	$01010001
	dc.l	$01010001
	dc.l	$01110001

	dc.l	$00000001
	dc.l	$00000001
	dc.l	$00000001
	dc.l	$00000001
	dc.l	$00000001
	dc.l	$00000001
	dc.l	$11111111
	dc.l	$00010000

	dc.l	$00010000
	dc.l	$00010000
	dc.l	$00010000
	dc.l	$00010000
	dc.l	$00011100
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	
	;Fourth column

	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000

	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00011000

	dc.l	$00000100
	dc.l	$01111110
	dc.l	$00000100
	dc.l	$00011000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000

	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000

;First iteration
;	dc.l	$00000000
;	dc.l	$01111110
;	dc.l	$01000010
;	dc.l	$01000010
;	dc.l	$01111110
;	dc.l	$00100100
;	dc.l	$00100100
;	dc.l	$00000000
	

SpriteDataEnd                                 ; Font end address
SpriteDataSizeB: equ (SpriteDataEnd-SpriteData) ; Font size in bytes
SpriteDataSizeW: equ (SpriteDataSizeB/2)       ; Font size in words
SpriteDataSizeL: equ (SpriteDataSizeB/4)       ; Font size in longs
SpriteDataSizeT: equ (SpriteDataSizeB/32)      ; Font size in tiles
SpriteDataVRAM:  equ 0x1000                   ; Dest address in VRAM
SpriteDataTileID: equ (SpriteDataVRAM/32)      ; ID of first tile


;=================;
; 16 bit version ;
;===============;

	;dc.l	$00000000
	;dc.l	$00000000
	;dc.l	$00000000
	;dc.l	$00011111
	;dc.l	$00010000
	;dc.l	$00010010
	;dc.l	$00010010
	;dc.l	$00010010
	;
	;dc.l	$00010000
	;dc.l	$00010010
	;dc.l	$00010001
	;dc.l	$00010000
	;dc.l	$00011111
	;dc.l	$00000100
	;dc.l	$00000100
	;dc.l	$00000110
	;
	;dc.l	$00000000
	;dc.l	$00000000
	;dc.l	$00000000
	;dc.l	$11111000
	;dc.l	$00001000
	;dc.l	$00101000
	;dc.l	$00101000
	;dc.l	$00101000
	;
	;dc.l	$00001000
	;dc.l	$00001000
	;dc.l	$11001000
	;dc.l	$00001000
	;dc.l	$11111000
	;dc.l	$01000000
	;dc.l	$01000000
	;dc.l	$01100000