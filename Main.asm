	rsset $00ff0000
_player1_memory: rs.b 1 ;8 Bits/1 Byte
_player2_memory: rs.b 1 ;8 Bits/1 Byte
;==================================================================================================;
; Title      : CT6TARPS Artefact
; Date       : 08.03.2024
; Description: A project that I have been making for an assessment of mine.
;==================================================================================================;

	
	include 'common\init.asm'
    ;include 'common\checkSum.asm'	;Not necessary now but is a strech goal
	include 'common\textStuff.asm'
	include 'common\spriteFunctions.asm'
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

;===================;
; Loading the font ;
;=================;
    lea        PixelFont, a0       ; Move font address to a0
    move.l    #PixelFontVRAM, d0   ; Move VRAM dest address to d0
    move.l    #PixelFontSizeT, d1  ; Move number of characters (font size in tiles) to d1
    jsr        LoadFont            ; Jump to subroutine

;======================;
; Loading the sprites ;
;====================;
	lea		   SpriteData, a0
	move.l    #SpriteDataVRAM, d0   ; Move VRAM dest address to d0
    move.l    #SpriteDataSizeT, d1  ; Move number of characters (font size in tiles) to d1
    jsr        LoadSprite            ; Jump to subroutine

;==========================;
; Load sprite descriptors ;
;========================;
	lea     SpriteDescs, a0		; Sprite table data
	move.w  #0x1, d0			; 1 sprite
	jsr     LoadSpriteTables

;========================================;
; Set starting positions of the sprites ;
;======================================;

	move.w  #0x0,  d0	  ; Sprite ID - First sprite
	move.w  #0xB0, d1	  ; X coord
	jsr     SetSpritePosX ; Set X pos
	move.w  #0xB0, d1	  ; Y coord
	jsr     SetSpritePosY ; Set Y pos

	move.l  #0x90, d4     ; X pos
	move.l  #0x110, d5     ; Y pos

;========================================;
; Setting the default background colour ;
;======================================;
   move.w #0x870E, vdp_control  ; Set background colour to palette 0, colour _
   ;The last digit of #0x870_, '_' is the colour we choose.

;Everything should be set up correctly by this point so we start the game loop - Ersan 	
GameLoop:

;=========================================;
; Displaying the text - Just like Easy68K ;
;=========================================;
	lea		StringTest, a0		 ; String address
	move.l	#PixelFontTileID, d0 ; First tile id
	move.w	#0x0501, d1			 ; XY (5, 1)
	move.l	#0x1, d2			 ; Palette 1
	jsr		DrawTextPlaneA       ; Call draw text subroutine

	FastPauseZ80    ; Pause Z80 for a bit

;======================;
; Read gamepad inputs ;
;=====================;
	jsr ReadGamepadP1

	btst	#pad_button_up, _player1_memory
	bne		@NotUp
	sub.w   #jump_force, d5     
	@NotUp:

	btst	#pad_button_down, _player1_memory
	bne		@NotDown
	;add.w   #jump_force, d5 
	@NotDown:

	; TODO - Try to figure out how to flip the sprite based on it's direction
	btst	#pad_button_left, _player1_memory
	bne		@NotLeft
	sub.w   #movement_speed, d4 
	@NotLeft:

	btst	#pad_button_right, _player1_memory
	bne		@NotRight
	add.w   #movement_speed, d4 
	@NotRight:

;The A and start buttons do not work for some reason. Need to figure out why that is
	
	btst	#pad_button_a, _player1_memory
	bne		@NotA		; This is configured to be Z in gens emulator
	move.w #0x870D, vdp_control
	@NotA:
	
	btst	#pad_button_b, _player1_memory
	bne		@NotB		; This is configured to be X in gens emulator
	move.w #0x870B, vdp_control
	@NotB:

	btst	#pad_button_c, _player1_memory
	bne		@NotC		; This is configured to be C in gens emulator
	move.w #0x870C, vdp_control
	@NotC:


	;===============================================;
	;  Adds a fake platform that blocks the player  ;
	;  from going downwards after a certain point   ;
	;===============================================;

	cmp		#0x110, d5
	blt		@NotBelowFloor
	sub.w   #gravity, d5	; This checks if the player is at 110 on y position. If so, applies force to push back it up
	move.l  #0x110, d5		; This sets the player's position and stops the stuttering issue.
	@NotBelowFloor:				

	add.w   #0x1, d5		; Can potentially add gravity to the character by doing something like this


	;====================================================;
	; The code below handles the position during vblank ;
	;===================================================;

	jsr    WaitVBlankStart ; Wait for start of vblank  

	; Anything related to visuals need to be updated during vblank pause. - Ersan
	move.w  #0x0,  d0	  ; Sprite ID
	move.w  d4, d1	      ; X coord
	jsr     SetSpritePosX ; Set X pos
	move.w  d5, d1	      ; Y coord
	jsr     SetSpritePosY ; Set Y pos

	jsr    WaitVBlankEnd   ; Wait for end of vblank

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

	;==================================;
	; Sprite Table Data/Descriptor(?) ;
	;================================;
SpriteDescs:
    dc.w 0x0090        ; Y coord (+ 128)
    dc.b %00001111     ; Width (bits 0-1) and height (bits 2-3) in tiles	(00 - 8x, 01 - 16x, 10 - 24x,11 - 32x))
    dc.b 0x01          ; Index of next sprite (linked list)
    dc.b %0001000          ; H/V flipping (bits 3/4), palette index (bits 5-6), priority (bit 7) | Horizontal - 01, Vertical 10, Vert. & Hori. - 11 |
    dc.b SpriteDataTileID ; Index of first tile
    dc.w 0x0115        ; X coord (+ 128)

	;after reaching 10, it adds + 6 to the coord value for some reason
	; dc.w 0x0010 = 10 + 6	/ dc.w 0x0020 = 20 + 12 / dc.w 0x0050 = 50 + 30
	; need to start from 80 in order to show up in the screen


StringTest:
	dc.b "HELLO WORLD!",0

__endMain: