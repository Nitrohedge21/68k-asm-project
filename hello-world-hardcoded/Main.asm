;==================================================================================================;
; Title      : Hello World in Sega Mega Drive/Genesis
; Written by : Ersan
; Date       : 12.02.2024
; Description: This code is made by following BigEvilCorp's tutorial to get the gist of the console
;==================================================================================================;

	
	include 'init.asm'

; If I wanted to rename the main, I need to do it both in here and init.asm
__Main:

;Preparing VDP to write data  	
   move.l #0x40000003, 0x00C00004

;Enable the autoincrement	
   move.w #0x8F02, 0x00C00004   ; Set autoincrement to 2 bytes

;Writing the data
; * Writing a palette	
   move.l #0xC0000003, 0x00C00004 ; Set up VDP to write to CRAM address 0x0000

;Move the palette data into VDP'S Data port
   lea Palette, a0          ; Load address of Palette into a0
   move.l #0x07, d0         ; 32 bytes of data (8 longwords, minus 1 for counter) in palette
 
@LoopBG:
   move.l (a0)+, 0x00C00000 ; Move data to VDP data port, and increment source address
   dbra d0, @LoopBG

;Everything should be set up correctly by this point so we test it by using the code below 	

;================================;
; Changing the background colour ;
;================================;
   move.w #0x870E, 0x00C00004  ; Set background colour to palette 0, colour 8
   ;The last digit of #0x8708, '8' is the colour we choose.

;===================================;
; Writing Hello World on the screen ;
;===================================;

   move.l #0x40200000, 0x00C00004 ; Set up VDP to write to VRAM address 0x0020
   lea Characters, a0             ; Load address of Characters into a0
   move.l #0x37, d0               ; 32*7 bytes of data (56 longwords, minus 1 for counter) in the font
 
@LoopTXT:
   move.l (a0)+, 0x00C00000       ; Move data to VDP data port, and increment source address
   dbra d0, @LoopTXT

   move.l #0x40000003, 0x00C00004 ; Set up VDP to write to VRAM address 0xC000 (Plane A)
   move.w #0x0001, 0x00C00000     ; Low plane, palette 0, no flipping, tile ID 1

   move.l #0x40000003, 0x00C00004 ; Set up VDP to write to VRAM address 0xC000 (Plane A)
 
; The numbers after 0x stand for low plane, palette 0, no flipping, plus tile ID in order. - Ersan
   move.w #0x0001, 0x00C00000     ; Pattern ID 1 - H
   move.w #0x0002, 0x00C00000     ; Pattern ID 2 - E
   move.w #0x0003, 0x00C00000     ; Pattern ID 3 - L
   move.w #0x0003, 0x00C00000     ; Pattern ID 3 - L
   move.w #0x0004, 0x00C00000     ; Pattern ID 4 - O
   move.w #0x0000, 0x00C00000     ; Pattern ID 0 - Blank space	;There is no need to set up the data of this as it's doable this way - Ersan
   move.w #0x0005, 0x00C00000     ; Pattern ID 5 - W
   move.w #0x0004, 0x00C00000     ; Pattern ID 4 - O
   move.w #0x0006, 0x00C00000     ; Pattern ID 6 - R
   move.w #0x0003, 0x00C00000     ; Pattern ID 3 - L
   move.w #0x0007, 0x00C00000     ; Pattern ID 7 - D

;====================================================================;
; The data can either be defined here or on top of the code as usual ;
;====================================================================;

Palette:
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

Characters:
   dc.l 0x11000110 ; Character 0 - H
   dc.l 0x11000110
   dc.l 0x11000110
   dc.l 0x11111110
   dc.l 0x11000110
   dc.l 0x11000110
   dc.l 0x11000110
   dc.l 0x00000000
 
   dc.l 0x11111110 ; Character 1 - E
   dc.l 0x11000000
   dc.l 0x11000000
   dc.l 0x11111110
   dc.l 0x11000000
   dc.l 0x11000000
   dc.l 0x11111110
   dc.l 0x00000000
 
   dc.l 0x11000000 ; Character 2 - L
   dc.l 0x11000000
   dc.l 0x11000000
   dc.l 0x11000000
   dc.l 0x11000000
   dc.l 0x11111110
   dc.l 0x11111110
   dc.l 0x00000000
 
   dc.l 0x01111100 ; Character 3 - O
   dc.l 0x11101110
   dc.l 0x11000110
   dc.l 0x11000110
   dc.l 0x11000110
   dc.l 0x11101110
   dc.l 0x01111100
   dc.l 0x00000000
 
   dc.l 0x11000110 ; Character 4 - W
   dc.l 0x11000110
   dc.l 0x11000110
   dc.l 0x11000110
   dc.l 0x11010110
   dc.l 0x11101110
   dc.l 0x11000110
   dc.l 0x00000000
 
   dc.l 0x11111100 ; Character 5 - R
   dc.l 0x11000110
   dc.l 0x11001100
   dc.l 0x11111100
   dc.l 0x11001110
   dc.l 0x11000110
   dc.l 0x11000110
   dc.l 0x00000000
 
   dc.l 0x11111000 ; Character 6 - D
   dc.l 0x11001110
   dc.l 0x11000110
   dc.l 0x11000110
   dc.l 0x11000110
   dc.l 0x11001110
   dc.l 0x11111000
   dc.l 0x00000000

__endMain: