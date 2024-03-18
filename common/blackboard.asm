hblank_counter        equ 0x00FF0000
vblank_counter        equ 0x00FF0004

;===================;
;     VDP stuff     ;
;===================;

vdp_control				equ 0x00C00004
vdp_data				equ 0x00C00000

vdp_write_palettes		equ 0xF0000000
vdp_bg_palette			equ	0xC0000003	;Unsure if this is required
vdp_write_tiles			equ 0x40000000
vdp_write_plane_a		equ 0x40000003
vdp_write_hscroll		equ 0x50000003
vdp_write_sprite_tiles	equ 0x60000000
vdp_write_sprite_table	equ 0x60000003

;==================;
; Controller stuff ;
;==================;

pad_button_up			equ 0x0
pad_button_down			equ 0x1
pad_button_left			equ 0x2
pad_button_right		equ 0x3
pad_button_a			equ 0x6		; This was originally 0xC which should work if the input data aren't combined into one
pad_button_b			equ 0x4		; Refer back to the 3 button controller scheme
pad_button_c			equ 0x5
pad_button_start		equ 0x7		; This was originally 0xD which should work if the input data aren't combined into one

player1_control_port	equ	0x00A10009
player2_control_port	equ	0x00A1000B	;these had same values with pad_data & pad_control
player1_data_port		equ	0x00A10003
player2_data_port		equ	0x00A10005

; The variables below aren't being used as I couldn't figure out how to use them
just_pressed			equ	pressed_now and (not pressed_before)
just_released			equ	pressed_before and (not pressed_now)
pressed_now				equ	0x00
pressed_before			equ	0x00

;=====================================;
;     Artefact related variables     ;
;===================================;

movement_speed			equ	0x2
jump_force				equ 0x3
gravity					equ 0x2
test_variable			equ 0x3