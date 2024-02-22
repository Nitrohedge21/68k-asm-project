ReadGamepadP1:
    move.b  #$40, player1_data_port  ; Read the first row of inputs (D-Pad, B and C)
    nop                 ; These are used to wait for a bit
    nop
    nop
    nop
    move.b  player1_data_port, d3
    
    move.b  #$00, player1_data_port  ; Read the second row of inputs (A and Start)
    nop                 ; These are used to wait for a bit
    nop
    nop
    nop
    move.b  player1_data_port, d4


	ResumeZ80        ; Z80 can run now
    and.b   #$3F, d3    ; Rearrange bits
    and.b   #$30, d4    ; into SACBRLDU - Start,A,C,B,Right,Left,Down,Up
    lsl.b   #2, d4
    or.b    d4, d3 ; combines first row and second row into one
	move.b	d3, _player1_memory
	rts

    ; Now d3 contains all the buttons and is loaded into _player1_memory
    ; 1 = pressed and 0 = released

;=============================;
; Player2's Gamepad readings ;      ;Not implemented but could be a stretch goal.
; Player2's Gamepad readings ;      ;I just have a temporary code for the moment.
;===========================;
    ReadGamepadP2:
    move.b  #$40, player2_data_port  ; Read the first row of inputs (D-Pad, B and C)
    nop                 ; These are used to wait for a bit
    nop
    nop
    nop
    move.b  player2_data_port, d3
    
    move.b  #$00, player1_data_port  ; Read the second row of inputs (A and Start)
    nop                 ; These are used to wait for a bit
    nop
    nop
    nop
    move.b  player2_data_port, d4


	ResumeZ80        ; Z80 can run now
    and.b   #$3F, d3    ; Rearrange bits
    and.b   #$30, d4    ; into SACBRLDU - Start,A,C,B,Right,Left,Down,Up
    lsl.b   #2, d4
    or.b    d4, d3 ; combines first row and second row into one
	move.b	d3, _player2_memory ;not defined yet
	rts

    ; Now d3 contains all the buttons and is loaded into _player1_memory
    ; 1 = pressed and 0 = released

