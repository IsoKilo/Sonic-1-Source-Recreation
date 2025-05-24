	list off
	include	equ.lib
	include	macros.lib
	list on

	extern	ringpat,itempat,butapat,kanipat,hachipat,togepat
	extern	fishpat,fish2pat,mogurapat,shimapat2,jyamapat
	extern	musipat,sjumppat,kamerepat,arumapat,kagebpat,ballpat
	extern	firepat,fblockpat,signalpat,bobinpat,yoganpat,yogan2pat
	extern	usapat,yadopat,boxpat,bryukapat,daipat,break2pat,yogancpat
	extern	batpat,z5daipat,dai2pat,switch2pat,z4daipat
	extern	elevpat,pedalpat,steppat,funpat,sisoopat,hassyapat
	extern	brobopat,unipat,yaripat,udaipat,dai3pat,kazaripat,kassyapat
	extern	awapat,mizupat,boupat,benpat,fetamapat,mawarupat,hagurumapat
	extern	patapat,yukafpat,nokopat,dai4pat,doorpat,yukaepat,fire6pat
	extern	elepat,yukaipat,scolipat,imopat,savepat,bigringpat,btenpat
	extern	actionsub,actwkchk,frameout,playpat
	extern	flicpat,usagipat,pengpat,azarpat,fbutapat,niwapat,risupat

	public	edit

;------------------------------------------------------------------------------
edit:
	moveq	#0,d0
	move.b	editmode,d0
	move.w	edit_move_tbl(pc,d0.w),d1
	jmp	edit_move_tbl(pc,d1.w)
edit_move_tbl:
	dc.w	editinit-edit_move_tbl
	dc.w	editmove-edit_move_tbl
editinit:
	addq.b	#word,editmode
	move.w	scralim_up,editstack
	move.w	scralim_n_down,editstack2
	move.w	#$0000,scralim_up
	move.w	#$0720,scralim_n_down
	andi.w	#$07ff,playerwk+yposi
	andi.w	#$07ff,scra_v_posit
	andi.w	#$03ff,scrb_v_posit
	move.b	#0,patno(a0)
	move.b	#0,mstno(a0)
	cmpi.b	#spgamemd,gmmode
	bne.b	?jump0
*	move.b	#7-1,stageno
	move.w	#$000,rotspd
	move.w	#$000,rotdir
	moveq	#7-1,d0
	bra.b	?jump1
?jump0:
	moveq	#0,d0
	move.b	stageno,d0
?jump1:
	lea	edittbl,a2
	add.w	d0,d0
	adda.w	(a2,d0.w),a2
	move.w	(a2)+,d6
	cmp.b	editno,d6
	bhi.b	?jump
	move.b	#0,editno
?jump:
	bsr.w	editpatchg
	move.b	#12,edittimer
	move.b	#1,edittimer+1
editmove:
	moveq	#7-1,d0
	cmpi.b	#spgamemd,gmmode
	beq.b	?jump
	moveq	#0,d0
	move.b	stageno,d0
?jump:
	lea	edittbl,a2
	add.w	d0,d0
	adda.w	(a2,d0.w),a2
	move.w	(a2)+,d6
	bsr.w	editwalk
*	bsr.w	dirsprset
	jmp	actionsub
editwalk:
	moveq	#0,d4
	move.w	#1,d1
	move.b	swdata+1,d4
	andi.w	#$0f,d4
	bne.b	?jump0
	move.b	swdata1,d0
	andi.w	#$0f,d0
	bne.b	?jump
	move.b	#12,edittimer
	move.b	#$0f,edittimer+1
	bra.w	?lend
?jump:
	subq.b	#1,edittimer
	bne.b	jump1
	move.b	#1,edittimer
	addq.b	#1,edittimer+1
*	cmpi.b	#255,edittimer+1
	bne.b	?jump0
	move.b	#255,edittimer+1
?jump0:
	move.b	swdata1,d4
?jump1:
	moveq	#0,d1
	move.b	edittimer+1,d1
	addq.w	#1,d1
	swap	d1
	asr.l	#4,d1
	move.l	yposi(a0),d2
	move.l	xposi(a0),d3
	btst.l	#0,d4			*swdata+0
	beq.b	?jump2
	sub.l	d1,d2			*yposi
	bcc.b	?jump2
	moveq	#0,d2
?jump2:
	btst.l	#1,d4			*swdata+0
	beq.b	?jump3
	add.l	d1,d2			*yposi
	cmpi.l	#$7ff0000,d2
	bcs.b	?jump3
	move.l	#$7ff0000,d2
?jump3:
	btst.l	#2,d4			*swdata+0
	beq.b	?jump4
	sub.l	d1,d3			*xposi
	bcc.b	?jump4
	moveq	#0,d3
?jump4:
	btst.l	#3,d4			*swdata+0
	beq.b	?jump5
	add.l	d1,d3			*xposi
?jump5:
	move.l	d2,yposi(a0)
	move.l	d3,xposi(a0)
?lend:
	btst.b	#6,swdata1+0
	beq.b	?jump7
	btst.b	#5,swdata1+1	* c button check
	beq.b	?jump77
	subq.b	#1,editno
	bcc.b	?jump6
	add.b	d6,editno
	bra.b	?jump6
?jump77:
	btst.b	#6,swdata1+1
	beq.b	?jump7
	addq.b	#1,editno
	cmp.b	editno,d6
	bhi.b	?jump6
	move.b	#0,editno
?jump6:
	bra.w	editpatchg
?jump7:
	btst.b	#5,swdata1+1	* c button check
	beq.b	?jump8
	jsr	actwkchk
	bne.b	?worknai		;z=0:ok z=1:no
	move.w	xposi(a0),xposi(a1)
	move.w	yposi(a0),yposi(a1)
	move.b	patbase(a0),actno(a1)
	move.b	actflg(a0),actflg(a1)
	move.b	actflg(a0),cddat(a1)
	andi.b	#$7f,cddat(a1)
	moveq	#0,d0
	move.b	editno,d0
	lsl.w	#3,d0
	move.b	4(a2,d0.w),userflag(a1)
	rts
?worknai:
?jump8:
	btst	#4,swdata1+1	* b button check
	beq.b	?jump9
	moveq	#0,d0
	move.w	d0,editmode
	move.l	#playpat,playerwk+patbase
	move.w	#$0780,playerwk+sproffset
	move.b	d0,playerwk+mstno
	move.w	d0,xposi+2(a0)
	move.w	d0,yposi+2(a0)
	move.w	editstack,scralim_up
	move.w	editstack2,scralim_n_down
	cmpi.b	#spgamemd,gmmode
	bne.b	?jump9
	clr.w	rotdir
	move.w	#$040,rotspd
	move.l	#playpat,playerwk+patbase
	move.w	#$0780,playerwk+sproffset
	move.b	#02,playerwk+mstno
	bset.b	#cd_ball,playerwk+cddat
	bset.b	#cd_jump,playerwk+cddat
?jump9
	rts
editpatchg:
	moveq	#0,d0
	move.b	editno,d0
	lsl.w	#3,d0
	move.l	0(a2,d0.w),patbase(a0)
	move.w	6(a2,d0.w),sproffset(a0)
	move.b	5(a2,d0.w),patno(a0)
*	move.b	4(a2,d0.w),userflag(a0)
	rts

dcblw	macro	\1,\2,\3,\4,\5
	dc.l	(\1)*$1000000+(\2)
	dc.w	(\4)+(\5)*$100
	dc.w	(\3)
	endm

edittbl:
	dc.w	edit1tbl-edittbl
	dc.w	edit2tbl-edittbl
	dc.w	edit3tbl-edittbl
	dc.w	edit4tbl-edittbl
	dc.w	edit5tbl-edittbl
	dc.w	edit6tbl-edittbl
	dc.w	edit7tbl-edittbl
edit1tbl:
	dc.w	16
	dcblw	ring_act,ringpat,$27b2,0,$00		;1:
	dcblw	item_act,itempat,$0680,0,$00		;2:
	dcblw	kani_act,kanipat,$0400,0,$00		;3:
	dcblw	hachi_act,hachipat,$0444,0,$00		;4:
	dcblw	fish_act,fishpat,$047b,0,$00		;5:
	dcblw	toge_act,togepat,$051b,0,$00		;6:
	dcblw	shima_act,shimapat2,$4000,0,$00		;7:
	dcblw	jyama_act,jyamapat,$6ed0,0,$00		;8:
	dcblw	musi_act,musipat,$04f0,0,$00		;9:
	dcblw	sjump_act,sjumppat,$0523,0,$00		;10:
	dcblw	kamere_act,kamerepat,$249b,0,$00	;11:
	dcblw	kageb_act,kagebpat,$434c,0,$00		;12:
	dcblw	ball_act,ballpat,$43aa,0,$00		;13:
	dcblw	save_act,savepat,$07a0,0,$01		;14:
	dcblw	bigring_act,bigringpat,$2400,0,$00	;15:
	dcblw	bten_act,btenpat,$84b6,1,$01		;16:

edit2tbl:
	dc.w	25
	dcblw	ring_act,ringpat,$27b2,0,$00		;1:
	dcblw	item_act,itempat,$0680,0,$00		;2:
	dcblw	sjump_act,sjumppat,$0523,0,$00		;3:
	dcblw	fish2_act,fish2pat,$2486,0,$08		;4:
	dcblw	mogura_act,mogurapat,$84a6,2,$00	;5:
	dcblw	yari_act,yaripat,$03cc,0,$00		;6:
	dcblw	yari_act,yaripat,$03cc,3,$02		;7:
	dcblw	box_act,boxpat,$43de,0,$00			;8:
	dcblw	switch2_act,switch2pat,$0513,0,$00	;9:
	dcblw	toge_act,togepat,$051b,0,$00		;10:
	dcblw	dai_act,udaipat,$43bc,0,$04			;11:
	dcblw	dai3_act,dai3pat,$43e6,0,$01		;12:
	dcblw	dai3_act,dai3pat,$43e6,1,$13		;13:
	dcblw	dai3_act,dai3pat,$43e6,0,$05		;14:
	dcblw	kazari_act,kazaripat,$443e,0,$00	;15:
	dcblw	dai3_act,dai3pat,$43e6,2,$27		;16:
	dcblw	dai3_act,dai3pat,$43e6,3,$30		;17:
	dcblw	kassya_act,kassyapat,$03f6,0,$7f	;18:
	dcblw	uni_act,unipat,$0467,0,$00			;19:
	dcblw	awa_act,awapat,$8348,19,$84			;20:
	dcblw	mizu_act,mizupat,$c259,2,$02		;21:
	dcblw	mizu_act,mizupat,$c259,9,$09		;22:
	dcblw	bou_act,boupat,$43de,0,$00			;23:
	dcblw	ben_act,benpat,$4328,0,$02			;24:
	dcblw	save_act,savepat,$26bc,0,$01		;25:

*	dcblw	dai4_act,dai4pat,$41f0,4,$80		;25:
edit3tbl:
	end