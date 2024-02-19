	rsset $00ff0000
_player1_memory: rs.b 1 ;8 Bits/1 Byte
;==================================================================================================;
; Title      : Hello World in Sega Mega Drive/Genesis
; Date       : 14.02.2024
; Description: This code is made by following BigEvilCorp's tutorial to get the gist of the console
;==================================================================================================;

	
	include 'init.asm'
    ;include 'checkSum.asm'	;Not necessary now but is a strech goal
	include 'textStuff.asm'
	include 'blackboard.asm'
	include 'macros.asm'

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


;Everything should be set up correctly by this point so we test it by using the code below 	

;================================;
; Changing the background colour ;
;================================;
   move.w #0x870E, vdp_control  ; Set background colour to palette 0, colour _
   ;The last digit of #0x870_, '_' is the colour we choose.

;=====================;
; Read gamepad inputs ;
;=====================;

	FastPausez80    ; Pause Z80 for a bit

    move.b  #$40, (player1_data_port)  ; Read the first row of inputs (D-Pad, B and C)
    nop                 ; These are used to wait for a bit
    nop
    nop
    nop
    move.b  (player1_data_port), d2
    
    move.b  #$00, (player1_data_port)  ; Read the second row of inputs (A and Start)
    nop                 ; These are used to wait for a bit
    nop
    nop
    nop
    move.b  (player1_data_port), d3


	ResumeZ80        ; Z80 can run now
    and.b   #$3F, d2    ; Rearrange bits
    and.b   #$30, d3    ; into SACBRLDU
    lsl.b   #2, d3
    or.b    d3, d2 ; combines first row and second row into one
	move.b	d3, _player1_memory

    ; Now d3 contains all the buttons and is loaded into _player1_memory
    ; 1 = pressed and 0 = released



;=========================================;
; Displaying the text - Just like Easy68K ;
;=========================================;
	lea		StringTest, a0		 ; String address
	move.l	#PixelFontTileID, d0 ; First tile id
	move.w	#0x0501, d1			 ; XY (5, 1)
	move.l	#0x1, d2			 ; Palette 1

	jsr		DrawTextPlaneA       ; Call draw text subroutine



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

;List of variables to display on the screen

StringTest:
	dc.b "HELLO WORLD!",0
Test:
	dc.b "ITS WORKING",0


	include 'pixelFont.asm'

__endMain: