	list off
	include	equ.lib
	include	macros.lib
	list on

	extern	actionsub

	public	score,scoreup,scoreset

;------------------------------------------------------------------------------
score:
	moveq	#0,d0
	move.b	r_no0(a0),d0
	move.w	score_move_tbl(pc,d0.w),d1
	jmp	score_move_tbl(pc,d1.w)
score_move_tbl:
	dc.w	score_init-score_move_tbl
	dc.w	score_move-score_move_tbl
score_init:
	addq.b	#word,r_no0(a0)
	move.w	#$0090,xposi(a0)
	move.w	#$0108,yposi-2(a0)
	move.l	#scorepat,patbase(a0)
	move.w	#$06ca,sproffset(a0)
	move.b	#0,actflg(a0)
	move.b	#0,sprpri(a0)
score_move:
	tst.w	plring
	beq.b	?jump0
	clr.b	patno(a0)
	jmp	actionsub
?jump0:
	moveq	#0,d0
	btst.b	#3,$fffe04+1
	bne.b	?jump
	addq.w	#1,d0
	cmpi.b	#9,pltime+1
	bne.b	?jump
	addq.w	#2,d0
?jump:
	move.b	d0,patno(a0)
	jmp	actionsub

scorepat:
	dc.w	scoresp0-scorepat
	dc.w	scoresp1-scorepat
	dc.w	scoresp2-scorepat
	dc.w	scoresp3-scorepat
scoresp0:
	dc.b	10
	dc.b	$80,$0d,$80,$00,$00	;1:
	dc.b	$80,$0d,$80,$18,$20	;2:
	dc.b	$80,$0d,$80,$20,$40	;3:
	dc.b	$90,$0d,$80,$10,$00	;4:
	dc.b	$90,$0d,$80,$28,$28	;5:
	dc.b	$a0,$0d,$80,$08,$00	;6:
	dc.b	$a0,$01,$80,$00,$20	;7:
	dc.b	$a0,$09,$80,$30,$30	;8:
	dc.b	$40,$05,$81,$0a,$00	;9:
	dc.b	$40,$0d,$81,$0e,$10	;10:
scoresp1:
scoresp2:
scoresp3:

scoreup:
	move.b	#1,plscore_f
	lea	plscore,a3
	add.l	d0,(a3)
	move.l	#999999,d1
	cmp.l	(a3),d1
	bhi.b	?jump
	move.l	d1,(a3)
?jump:
	move.l	(a3),d0
	cmp.l	extrascore,d0
	bcs.b	?jump0
	addi.l	#5000,extrascore
	tst.b	mdstatus
	bmi.b	?jumpus
	addq.b	#1,pl_suu
	addq.b	#1,pl_suu_f
	move.w	#$88,d0
	jmp	bgmset
?jumpus:
?jump0:
	rts
scoreset: