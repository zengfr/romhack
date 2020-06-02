*-----------------------------------------------------------
* Title      :
* Written by :ZHYxxxx
* Date       :
* Description:
*-----------------------------------------------------------

*=====================
	org	$fe36
	jmp	_random
	org	$fe48
	dc.w	$4e71,$4e71,$4e71



	org	$104430
_random	

	movem.l	d0-d2/d7,-(a7)	*入盏
	clr.l	d1
	clr.l	d0
	clr.l	d7
	clr.l	d2
	move.b	$3(a2),d0	*读取大类
	andi.b	#$f,d0	*取个位
	tst.b	d0	*是否为0
	bne	_out_random	*不为0跳
	clr.l	d0
	move.l	#$a,d7	循环a次
_loop
	move.w	$4(a2),d0	读敌兵ID
	move.w	d7,d2
	add.w	d2,d2
	move.w	_enemy_ID(pc,d2),d1	读表
	cmp.w	d0,d1	对比ID和表
	beq	_in_random	等于跳
	dbeq	d7,_loop	循环

	jmp	_out_random	*不随机
_enemy_ID	
	dc.w	$08,$0c,$18,$28,$34,$38,$50,$0c,$100,$fc		*需要随机的表

_enemy_ID_a
	dc.w	$08,$48,$18,$28,$34,$38,$48,$50,$0c,$0c,$16c	*会出现的ID

	

_in_random
	clr.l	d1
	clr.l	d0
	jsr	$119c	*得出随机数d0
	add.w	($fff5c2),d0
	divs.w	#$b,d0	*范围
	swap	d0 	*求余
	add.w	d0,d0

	move.w	_enemy_ID_a(pc,d0),d0	*取表
	move.w	d0,$20(a0)	*写入敌兵ID
	clr.l	d0
	jsr	$119c
	add.w	($fff5c2),d0
	divu.w	#$3,d0
	swap	d0
	add.w	d0,d0
	cmpi.w	#$48,$20(a0)	*第一关BOSS处理
	beq	_NO_48
	cmpi.w	#$16c,$20(a0)	*寄生BOSS处理
	beq	_NO_16c
	cmpi.w	#$38,$20(a0)	*匕首兵处理
	bne	_NO_38
	andi.w	#$2,d0
_NO_38
	move.b	d0,$26(a0)
	cmpi.w	#$50,$20(a0)	*猴子处理
	bne	_NO_50
	move.b	#$06,$27(a0)	*猴子出场方式设为06
	bra	_fe3c
_NO_50
	move.b	#$00,$27(a0)
_fe3c
	movem.l	(a7)+,d0-d2/d7	*取盏
	jmp	$fe3c	*跳回
_NO_48
	move.w	#$0200,$26(a0)	*类型设为02
	bra	_fe3c
_NO_16c
	move.w	#$0000,$26(a0)	*类型设为00
	bra	_fe3c
_out_random	
	movem.l	(a7)+,d0-d2/d7	*取盏
	move.w	$4(a2),$20(a0)
	move.w	$a(a2),$26(a0)
	jmp	$fe3c

*_random_fun	*测试随机函数
*	clr.l	d0
*	move.b	($fff5c2),d0
**	move.b	($ffdc63),d1
**	muls.w	#$13,d0	*乘1
**	add.w	d1,d0
**	divs.w	#$2,d0
*	addi.w	#$321,d0	*加
*	rts
	





	
	





*~Font name~Fixedsys~
*~Font size~18~
*~Tab type~1~
*~Tab size~8~
