;===================;
;     VDP stuff     ;
;===================;

vdp_control				equ 0x00C00004
vdp_data				equ 0x00C00000

vdp_write_palettes		equ 0xF0000000
vdp_bg_palette			equ	0xC0000003	;Unsure if this is required
vdp_write_tiles			equ 0x40000000
vdp_write_plane_a		equ 0x40000003
vdp_write_sprite_tiles	equ 0x60000000
vdp_write_sprite_table	equ 0x60000003

;==================;
; Controller stuff ;
;==================;

pad_button_up			equ 0x0
pad_button_down			equ 0x1
pad_button_left			equ 0x2
pad_button_right		equ 0x3
pad_button_a			equ 0xC
pad_button_b			equ 0x4
pad_button_c			equ 0x5
pad_button_start		equ 0xD
;the data below are from BigEvilCorp.

pad_data_a				equ 0x00A10003
pad_data_b				equ 0x00A10005
pad_data_c				equ 0x00A10007
pad_ctrl_a				equ 0x00A10009
pad_ctrl_b				equ 0x00A1000B
pad_ctrl_c				equ 0x00A1000D

player1_control_port	equ	$A10009
player2_control_port	equ	$A1000B
player1_data_port		equ	$A10003
player2_data_port		equ	$A10005

just_pressed			equ	pressed_now and (not pressed_before)
just_released			equ	pressed_before and (not pressed_now)
pressed_now				equ	0x00
pressed_before			equ	0x00