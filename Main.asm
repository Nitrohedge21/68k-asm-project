;===========================================================
; Title      : Testing Genesis 68K Assembly
; Written by : 
; Date       : 12.02.2024
; Description:
;===========================================================

	
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
 
@Loop:
   move.l (a0)+, 0x00C00000 ; Move data to VDP data port, and increment source address
   dbra d0, @Loop

;Everything should be set up correctly by this point so we test it by using the code below 	
   move.w #0x8706, 0x00C00004  ; Set background colour to palette 0, colour 8
   ;The last digit of #0x8708, '8' is the colour we choose.


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

__endMain: