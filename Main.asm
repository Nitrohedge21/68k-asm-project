	rsset $00ff0000
_player1_memory: rs.b 1 ;8 Bits/1 Byte
_player2_memory: rs.b 1 ;8 Bits/1 Byte
;==================================================================================================;
; Title      : Hello World in Sega Mega Drive/Genesis
; Date       : 14.02.2024
; Description: This code is made by following BigEvilCorp's tutorial to get the gist of the console
;==================================================================================================;

	
	include 'common\init.asm'
    ;include 'common\checkSum.asm'	;Not necessary now but is a strech goal
	include 'common\textStuff.asm'
	include 'common\spriteStuff.asm'
	include 'common\blackboard.asm'
	include 'common\macros.asm'
	include 'common\pixelFont.asm'
	include 'common\gamepad.asm'
	include 'common\vblankHandler.asm'

__main:

;Enable the autoincrement	
   move.w #0x8F02, vdp_control   ; Set autoincrement to 2 bytes

;Writing the data
   move.l #0xC0000003, vdp_control ; Set up VDP to write to CRAM address 0x0000

;Move the background palette data into VDP'S Data port
   lea BGPalette, a0          ; Load address of BGPalette into a0
   move.l #0x07, d0         ; 32 bytes of data (8 longwords, minus 1 for counter) in palette
 
@LoopBG:
   move.l (a0)+, vdp_data ; Move data to VDP data port, and increment source address
   dbra d0, @LoopBG

   lea ColourPalette, a0  ; Load address of ColourPalette into a0
   move.l #0xF, d0  ; It was originally using 128 bytes of data (4 palettes, 32 longwords, minus 1 for counter)
					; but I changed it to use 64 bytes(?)/0xF (15 in decimal) to load in one less palette in order to use the bg palette. 

@ColourLoop:
	move.l (a0)+, vdp_data ; Move data to VDP data port, and increment source address
	dbra d0, @ColourLoop

;==================;
; Loading the font ;
;==================;
    lea        PixelFont, a0       ; Move font address to a0
    move.l    #PixelFontVRAM, d0   ; Move VRAM dest address to d0
    move.l    #PixelFontSizeT, d1  ; Move number of characters (font size in tiles) to d1
    jsr        LoadFont            ; Jump to subroutine

;=====================;
; Loading the sprites ;
;=====================;
	lea		   SpriteData, a0
	move.l    #SpriteDataVRAM, d0   ; Move VRAM dest address to d0
    move.l    #SpriteDataSizeT, d1  ; Move number of characters (font size in tiles) to d1
    jsr        LoadSprite            ; Jump to subroutine

; ************************************
; Load sprite descriptors
; ************************************
	lea     SpriteDescs, a0		; Sprite table data
	move.w  #0x1, d0			; 1 sprite
	jsr     LoadSpriteTables

;Everything should be set up correctly by this point so we test it by using the code below 	

;================================;
; Changing the background colour ;
;================================;
   move.w #0x870E, vdp_control  ; Set background colour to palette 0, colour _
   ;The last digit of #0x870_, '_' is the colour we choose.
GameLoop:
;=====================;
; Read gamepad inputs ;
;=====================;

	FastPauseZ80    ; Pause Z80 for a bit

	jsr ReadGamepadP1

	jsr    WaitVBlankStart ; Wait for start of vblank

	btst	#pad_button_up, d3
	bne		@NotUp
	move.w #0x870A, vdp_control
	@NotUp:

	btst	#pad_button_down, d3
	bne		@NotDown
	move.w #0x870B, vdp_control
	@NotDown:

	btst	#pad_button_left, d3
	bne		@NotLeft
	move.w #0x870C, vdp_control
	@NotLeft:

	btst	#pad_button_right, d3
	bne		@NotRight
	move.w #0x870D, vdp_control
	@NotRight:

	jsr    WaitVBlankEnd   ; Wait for end of vblank

;=========================================;
; Displaying the text - Just like Easy68K ;
;=========================================;
	lea		StringTest, a0		 ; String address
	move.l	#PixelFontTileID, d0 ; First tile id
	move.w	#0x0501, d1			 ; XY (5, 1)
	move.l	#0x1, d2			 ; Palette 1
	jsr		DrawTextPlaneA       ; Call draw text subroutine

;===============================;
; Hopefully displays the sprite ;
;===============================;

	jmp	   GameLoop


;====================================================================;
; The data can either be defined here or on top of the code as usual ;
;====================================================================;

BGPalette:
   dc.w 0x0000 ; Colour 0 - Transparent
   dc.w 0x000E ; Colour 1 - Red
   dc.w 0x00E0 ; Colour 2 - Green
   dc.w 0x0E00 ; Colour 3 - Blue
   dc.w 0x0000 ; Colour 4 - Black
   dc.w 0x0EEE ; Colour 5 - White
   dc.w 0x00EE ; Colour 6 - Yellow
   dc.w 0x008E ; Colour 7 - Orange
   dc.w 0x0E0E ; Colour 8 - Pink
   dc.w 0x0808 ; Colour 9 - Purple
   dc.w 0x0444 ; Colour A - Dark grey
   dc.w 0x0888 ; Colour B - Light grey
   dc.w 0x0EE0 ; Colour C - Turquoise
   dc.w 0x000A ; Colour D - Maroon
   dc.w 0x0600 ; Colour E - Navy blue
   dc.w 0x0060 ; Colour F - Dark green

ColourPalette:
	dc.w 0x0000 ; Colour 0 - Transparent
	dc.w 0x000E ; Colour 1 - Red
	dc.w 0x0000 
	dc.w 0x0000
	dc.w 0x0000
	dc.w 0x0000
	dc.w 0x0000
	dc.w 0x0000
	dc.w 0x0000
	dc.w 0x0000
	dc.w 0x0000
	dc.w 0x0000
	dc.w 0x0000
	dc.w 0x0000
	dc.w 0x0000
	dc.w 0x0000

	dc.w 0x0000 ; Colour 0 - Transparent
	dc.w 0x0EEE ; Colour 1 - White
	dc.w 0x0000
	dc.w 0x0000
	dc.w 0x0000
	dc.w 0x0000
	dc.w 0x0000
	dc.w 0x0000
	dc.w 0x0000
	dc.w 0x0000
	dc.w 0x0000
	dc.w 0x0000
	dc.w 0x0000
	dc.w 0x0000
	dc.w 0x0000
	dc.w 0x0000

	; ************************************
	; Sprite descriptor structs
	; ************************************
SpriteDescs:
    dc.w 0x0090        ; Y coord (+ 128)
    dc.b %00000101     ; Width (bits 0-1) and height (bits 2-3) in tiles	(00 - 8x, 01 - 16x, 10 - 24x,11 - 32x))
    dc.b 0x01          ; Index of next sprite (linked list)
    dc.b 0x00          ; H/V flipping (bits 3/4), palette index (bits 5-6), priority (bit 7)
    dc.b SpriteDataTileID ; Index of first tile
    dc.w 0x0115        ; X coord (+ 128)

	;after reaching 10, it adds + 6 to the coord value for some reason
	; dc.w 0x0010 = 10 + 6	/ dc.w 0x0020 = 20 + 12 / dc.w 0x0050 = 50 + 30
	; need to start from 80 in order to show up in the screen


StringTest:
	dc.b "HELLO WORLD!",0

__endMain: