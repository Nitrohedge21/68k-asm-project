;This was originally using d3 & d4 for the input stuff because the background wasn't working.
;I thought the reason was because I was using data registers that were already in use.
;However, when I was trying to implement movement to the sprites, I encountered an issue where the character would "lag"
;So I put the gamepad data back to d0 & d1 to see if it would change anything and it turns out that was the solution???
;So each data register seemingly can be used for multiple things

ReadGamepadP1:
    move.b  #$40, (player1_data_port)  ; Read the first row of inputs (D-Pad, B and C)
    nop                 ; These are used to wait for a bit
    nop
    nop
    nop
    move.b  (player1_data_port), d0
    
    move.b  #$00, (player1_data_port)  ; Read the second row of inputs (A and Start)
    nop                 ; These are used to wait for a bit
    nop
    nop
    nop
    move.b  (player1_data_port), d1


	ResumeZ80        ; Z80 can run now
    and.b   #$3F, d0    ; Rearrange bits
    and.b   #$30, d1    ; into SACBRLDU - Start,A,C,B,Right,Left,Down,Up
    lsl.b   #2, d1
    or.b    d1, d0 ; combines first row and second row into one
	move.b	d0, _player1_memory ; This loads the input data into the player 1's memory
	rts

    ; Now d contains all the buttons and is loaded into _player1_memory
    ; 1 = pressed and 0 = released

;=============================;
; Player2's Gamepad readings ;      ;Seems like its working.
;===========================;

ReadGamepadP2:
    move.b  #$40, player2_data_port  ; Read the first row of inputs (D-Pad, B and C)
    nop                 ; These are used to wait for a bit
    nop
    nop
    nop
    move.b  player2_data_port, d0
    
    move.b  #$00, player1_data_port  ; Read the second row of inputs (A and Start)
    nop                 ; These are used to wait for a bit
    nop
    nop
    nop
    move.b  player2_data_port, d1


	ResumeZ80        ; Z80 can run now
    and.b   #$3F, d0    ; Rearrange bits
    and.b   #$30, d1    ; into SACBRLDU - Start,A,C,B,Right,Left,Down,Up
    lsl.b   #2, d1
    or.b    d1, d0 ; combines first row and second row into one
	move.b	d0, _player2_memory ;not defined yet
	rts

    ; Now d3 contains all the buttons and is loaded into _player1_memory
    ; 1 = pressed and 0 = released