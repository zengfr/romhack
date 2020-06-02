	;--------------------------------------
		org		$fbf00
_laodbing
		jsr		$1744				;申请obj，得到空的敌人obj在A0
		move.w	#$101,(a0)			;激活该obj
		move.l	#$347d6,($72,a0)	;必写，不知道什么鬼，反正不写死机
		move.w	#$300,($20,a0)
		move.w	#$200,($28,a0)
		rts
		
	;--------------------------------------
	
		ORG		$02081C
		JMP		$fbf80
		ORG		$fbf80
		JSR		_laodbing
		move.b  (-$243a,A5), ($52,A6)
		rts

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	