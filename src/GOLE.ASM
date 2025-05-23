	list off
	include	equ.lib
	include	macros.lib
	list on

	extern	actionsub,actwkchk,frameout,patchg,bgmset,soundset,ringpat
	public	gole,golesub,golepat

;------------------------------------------------------------------------------
gole:
	moveq	#0,d0
	move.b	r_no0(a0),d0
	move.w	gole_move_tbl(pc,d0.w),d1
	jsr	gole_move_tbl(pc,d1.w)
	lea	golechg,a1
	bsr.w	patchg
	bsr.w	actionsub
	move.w	xposi(a0),d0
	andi.w	#-$0080,d0
	move.w	scra_h_posit,d1
	subi.w	#$0080,d1
	andi.w	#-$0080,d1
	sub.w	d1,d0
	cmpi.w	#$0280,d0
	bhi.w	frameout
	rts
gole_move_tbl:
	dc.w	goleinit-gole_move_tbl
	dc.w	golemove-gole_move_tbl
	dc.w	golemove2-gole_move_tbl
	dc.w	golemove3-gole_move_tbl
	dc.w	golemove4-gole_move_tbl
goleinit:
	addq.b	#word,r_no0(a0)
	move.l	#golepat,patbase(a0)
	move.w	#$0680,sproffset(a0)
	move.b	#4,actflg(a0)
	move.b	#24,sprhs(a0)
	move.b	#4,sprpri(a0)
golemove:
	move.w	playerwk+xposi,d0
	sub.w	xposi(a0),d0
	bcs.b	?end
	cmpi.w	#32,d0
	bcc.b	?end
	move.w	#$00cf,d0
	jsr		bgmset
	clr.b	pltime_f
	move.w	scralim_right,scralim_left
	addq.b	#word,r_no0(a0)
?end:
	rts
golemove2:
	subq.w	#1,$30(a0)
	bpl.b	?jump
	move.w	#60,$30(a0)
	addq.b	#1,mstno(a0)
	cmpi.b	#3,mstno(a0)
	bne.b	?jump
	addq.b	#word,r_no0(a0)
?jump:
	subq.w	#1,$32(a0)
	bpl.b	?end
	move.w	#11,$32(a0)
	moveq	#0,d0
	move.b	#34(a0),d0
	addq.b	#2,$34(a0)
	andi.b	#14,$34(a0)
	lea	golepositbl(pc,d0.w),a2
	bsr.w	actwkchk
	bne.b	?worknai
	move.b	#ring_act,actno(a1)
	move.b	#6,r_no0(a1)
	move.b	(a2)+,d0
	ext.w	d0
	add.w	xposi(a0),d0
	move.w	d0,xposi(a1)
	move.b	(a2)+,d0
	ext.w	d0
	add.w	yposi(a0),d0
	move.w	d0,yposi(a1)
	move.l	#ringpat,patbase(a1)
	move.w	#$27b2,sproffset(a1)
	move.b	#2,sprpri(a1)
	move.b	#8,sprhs(a1)
?worknai:
?end:
	rts
golepositbl:
	dc.b	-24,-16
	dc.b	8,8
	dc.b	-16,0
	dc.b	24,-8
	dc.b	0,-8
	dc.b	16,0
	dc.b	-24,8
	dc.b	24,16
golemove3:
	tst.w	editmode
	bne.w	goleend
	btst.b	#1,playerwk+cddat
	bne.b	?jump0
	move.b	#1,plautoflag
	move.w	#$0800,swdata
?jump0:
	tst.b	playerwk
	beq.b	?jump1
	move.w	playerwk+xposi,d0
	move.w	scralim_right,d1
	addi.w	#$0128,d1
	cmp.w	d1,d0
	bcs.b	goleend
?jump1:
	addq.b	#word,r_no0(a0)
golesub:
	tst.b	actwk+$5c0+actno
	bne.b	goleend
	move.w	scralim_right,scralim_left
	clr.b	plpower_m
	clr.b	pltime_f
	move.b	#$3a,actwk+$5c0+actno
	moveq	#16,d0
	jsr	divdevset2
	move.b	#1,bonus_f
	moveq	#0,d0
	move.b	pltime+1,d0
	mulu.w	#60,d0
	moveq	#0,d1
	move.b	pltime+2,d1
	add.w	d1,d0
	divu.w	#15,d0
	moveq	#20,d1
	cmp.w	d1,d0
	bcs.b	?jump2
	move.w	d1,d0
?jump2:
	add.w	d0,d0
	move.w	timebonustbl(pc,d0.w),timebonus
	move.w	plring,d0
	mulu.w	#10,d0
	move.w	d0,ringbonus
	move.w	#$008e,d0
	jsr	soundset
goleend:
	rts
timebonustbl:
	dc.w	5000
	dc.w	5000
	dc.w	1000
	dc.w	500
	dc.w	400
	dc.w	400
	dc.w	300
	dc.w	300
	dc.w	200
	dc.w	200
	dc.w	200
	dc.w	200
	dc.w	100
	dc.w	100
	dc.w	100
	dc.w	100
	dc.w	50
	dc.w	50
	dc.w	50
	dc.w	50
	dc.w	0
golemove4:
	rts

golechg:
	dc.w	golechg0-golechg
	dc.w	golechg1-golechg
	dc.w	golechg2-golechg
	dc.w	golechg3-golechg
golechg0:
	dc.b	15, 0, -1
golechg1:
	dc.b	1, 0, 1, 2, 3, -1
golechg2:
	dc.b	1, 4, 1, 2, 3, -1
golechg3:
	dc.b	15, 4, -1

golepat:
	dc.w	golesp0-golepat
	dc.w	golesp1-golepat
	dc.w	golesp2-golepat
	dc.w	golesp3-golepat
	dc.w	golesp4-golepat
golesp0:
	dc.b	03
	dc.b	$F0,$0B,$00,$00,$E8	;1:
	dc.b	$F0,$0B,$08,$00,$00	;2:
	dc.b	$10,$0B,$08,$38,$FC	;3:
golesp1:
	dc.b	02
	dc.b	$F0,$0F,$00,$0C,$F0	;1:
	dc.b	$10,$01,$00,$38,$FC	;2:
golesp2:
	dc.b	02
	dc.b	$F0,$03,$00,$1C,$FC	;1:
	dc.b	$10,$01,$08,$38,$FC	;2:
golesp3:
	dc.b	02
	dc.b	$F0,$0F,$08,$0C,$F0	;1:
	dc.b	$10,$01,$08,$38,$FC	;2:
golesp4:
	dc.b	03
	dc.b	$F0,$0B,$00,$20,$E8	;1:
	dc.b	$F0,$0B,$00,$2C,$00	;2:
	dc.b	$10,$01,$00,$38,$FC	;3:

	end