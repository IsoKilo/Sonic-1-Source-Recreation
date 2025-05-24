	list off
	include	equ.lib
	include	macros.lib
	list on

	extern	edit,playpat

	public	play00

;------------------------------------------------------------------------------
play00:
	tst.w	editmode
	beq.b	?jump
	jmp	edit
?jump:
	moveq	#0,d0
	move.b	r_no0(a0),d0
	move.w	play00_move_tbl(pc,d0.w),d1
	jmp	play00_move_tbl(pc,d1.w)
play00_move_tbl:
	dc.w	play00init-play00_move_tbl
	dc.w	play00move-play00_move_tbl
	dc.w	play00damage-play00_move_tbl
	dc.w	play00die-play00_move_tbl
	dc.w	play00erase-play00_move_tbl
play00init:
	addq.b	#word,r_no0(a0)
	move.b	#19,sprvsize(a0)
	move.b	#9,sprhsize(a0)
	move.l	#playpat,patbase(a0)
	move.w	#$0780,sproffset(a0)
	move.b	#2,sprpri(a0)
	move.b	#24,sprhs(a0)
	move.b	#4,actflg(a0)
	move.w	#$0600,plmaxspdwk
	move.w	#$000c,pladdspdwk
	move.w	#$0080,plretspdwk
play00move:
	tst.w	debugflag
	beq.b	?jump0
	btst.b	#4,swdata1+1	* b button check
	beq.b	?jump0
	move.w	#1,editmode
	clr.b	plautoflag
	rts
?jump0:
	tst.b	plautoflag
	bne.b	?pass
	move.w	swdata1,swdata
?pass:
	btst.b	#0,$fff7c8
	bne.b	?jump2
	moveq	#0,d0
	move.b	cddat(a0),d0
	andi.w	#$06,d0
	move.w	play00move_tbl(pc,d0.w),d1
	jsr	play00move_tbl(pc,d1.w)
?jump2:
	bsr.b	playpowercnt
	bsr.w	playposiwkset
	bsr.w	plwaterchk
	move.b	dirstk,footdir(a0)
	move.b	dirstk+word,footdir+1(a0)
	tst.b	watercoliflag
	beq.b	?jump3
	tst.b	mstno(a0)
	bne.b	?jump3
	move.b	mstno+1(a0),mstno(a0)
?jump3:
	bsr.w	patchgmain
	tst.b	$fff7c8
	bmi.b	?pass2
	jsr	pcol
?pass2:
	bsr.w	loopchk
	bsr.w	playwrt
	rts
play00move_tbl:
	dc.w	play00walk-play00move_tbl
	dc.w	play00jump-play00move_tbl
	dc.w	ball00walk-play00move_tbl
	dc.w	ball00jump-play00move_tbl
play00sound_tbl:
	dc.b	$81,$82,$83,$84,$85,$86
playpowercnt:
	move.w	$30(a0)
	beq.b	?jump0
	subq.w	#1,$30(a0)
	lsr.w	#3,d0
	bcc.b	?pass
?jump0:
	jsr	actionsub
?pass:
	tst.b	plpower_m
	beq.b	?jump4
	tst.w	$32(a0)
	beq.b	?jump4
	subq.w	#1,$32(a0)
	bne.b	?jump4
	tst.b	bossstart
	bne.b	?jump3
	cmpi.w	#12,pl_air
	bcs.b	?jump3
	moveq	#0,d0
	move.b	stageno,d0
	cmpi.w	#$0103,stageno
	bne.b	?pass2
	moveq	#5,d0
?pass2:
	lea	play00sound_tbl,a1
	move.b	(a1,d0.w),d0
	jsr	bgmset
?jump3:
	move.b	#0,plpower_m
?jump4:
	tst.b	plpower_s
	beq.b	?end
	tst.w	speeduptimer(a0)
	beq.b	?end
	subq.w	#1,speeduptimer(a0)
	bne.b	?end
	move.w	#$0600,plmaxspdwk
	move.w	#$000c,pladdspdwk
	move.w	#$0080,plretspdwk
	move.b	#0,plpower_s
	move.w	#$e3,d0
	jmp	bgmset
?end:
	rts

playposiwkset:
	move.w	plposiwkadr,d0
	lea	playposiwk,a1
	lea	(a1,d0.w),a1
	move.w	xposi(a0),(a1)+
	move.w	yposi(a0),(a1)+
	addq.b	#4,plposiwkadr+1
	rts

plwaterchk:
	cmpi.b	#1,stageno
	beq.b	?pass
?end:
	rts
?pass:
	move.w	waterposi,d0
	cmp.w	yposi(a0),d0
	bge.b	?jump
	bset.b	#cd_water,cddat(a0)
	bne.b	?end
	bsr.w	plairset
	move.b	#plawa_act,actwk+$340
	move.b	#$81,actwk+$340+userflag
	move.w	#$0300,plmaxspdwk
	move.w	#$0006,pladdspdwk
	move.w	#$0040,plretspdwk
	asr.w	xspeed(a0)
	asr.w	yspeed(a0)
	asr.w	yspeed(a0)
	beq.b	?end
	move.b	#exit2_act,actwk+$300
	move.w	#$aa,d0
	jmp	soundset
?jump:
	bclr	#cd_water,cddat(a0)
	beq.b	?end
	bsr.w	plairset
	move.w	#$0600,plmaxspdwk
	move.w	#$000c,pladdspdwk
	move.w	#$0080,plretspdwk
	asl.w	yspeed(a0)
	beq.w	?end
	move.b	#exit2_act,actwk+$300
	cmpi.w	#-$1000,yspeed(a0)
	bgt.b	?pass2
	move.w	#-$1000,yspeed(a0)
?pass2:
	move.w	#$aa,d0
	jmp	soundset

play00walk:
	bsr.w	jumpchk
	bsr.w	keispd
	bsr.w	levermove
	bsr.w	ballchk
	bsr.w	limitchk
	jsr	speedset2
	bsr.w	fcol
	bsr.w	fallchk
	rts
play00jump:
	bsr.w	jumpchk2
	bsr.w	jumpmove
	bsr.w	limitchk
	jsr	speedset
	btst.b	#cd_water,cddat(a0)
	beq.b	?pass
	subi.w	#$0028,yspeed(a0)
?pass:
	bsr.w	direcchg
	bsr.w	jumpcolchk
	rts
ball00walk:
	bsr.w	jumpchk
	bsr.w	keispd2
	bsr.w	balllmove
	bsr.w	limitchk
	jsr	speedset2
	bsr.w	fcol
	bsr.w	fallchk
	rts
ball00jump:
	bsr.w	jumpchk2
	bsr.w	jumpmove
	bsr.w	limitchk
	jsr	speedset
	btst.b	#cd_water,cddat(a0)
	beq.b	?pass
	subi.w	#$0028,yspeed(a0)
?pass:
	bsr.w	direcchg
	bsr.w	jumpcolchk
	rts

levermove: