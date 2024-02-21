;============================================;
; An attempt to resolve the checksum issue - ;
; I found out thanks to Kage Fusion emulator ;
;============================================;

; The code corrupts the project because it's missing a few things.

end_addr	equ	$1a4
	org		-$8000

startCSum:

	lea			end_addr,a0
	move.l		(a0),d1
	addq.l		#$1,d1
	movea.l		#$200,a0
	sub.l		a0,d1
	asr.l		#1,d1
	move		d1,d2
	subq.w		#$1,d2
	swap		d1
	moveq		#$0,d0

	.12:
		add		(a0)+,d0
		dbra	d2,.12
		dbra	d1,.12
		nop
		nop
		nop
		nop
		nop
		nop
		nop

	.le:
		nop
		nop
		bra.b	.le