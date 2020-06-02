*_____________________________________________BOSS小兵化、非关底打死不过关_______________________________________________	
	;======================================过关=====================================
		org		$acee
		jmp		$1de000
		org		$1de000		
		tst.b	$ffff00						;是否关底
		beq		_acee_noguandi
		move.b  #$1, ($4d4,A5)
		jmp		$00ACF4			
_acee_noguandi		
		cmpi.w	#$150,($20,A6)				;是否大龙
		beq		_acee_dl
_acee_noguandi_jx
		move.w	#$48,($20,a6)				;非关底，强制改成马甲ID，这样BOSS死后不会过关，且尸体会消失
		move.b	#$02,($26,a6)				;非关底，强制改成马甲ID，这样BOSS死后不会过关，且尸体会消失		
		rts
_acee_dl
		movem.l	A0-A1/D0-D1,-(A7)
		movea.w	($B0,A6),A1					;大龙前手		
		jsr		_CLR_OBJ
		movea.w	($B2,A6),A1					;大龙后手		
		jsr		_CLR_OBJ
		movea.w	($B4,A6),A1					;大龙前手		
		jsr		_CLR_OBJ
		movea.w	($B6,A6),A1					;大龙前手		
		jsr		_CLR_OBJ
		;--------------------------搜索大龙身体154，并清零----------------------------
		movea.l	#$FFFFDD14,A0					;c8f4		
_154_zt		
		cmpa.w	($b0,a0),a6						;是否大龙基址
		beq		_154_clr						;找到则执行清理，并退出（只有1个）
		suba.w	#$e0,a0							;偏移到下一个OBJ
		cmpa.w	#$c8f4,a0						;搜索完毕，没有退出
		blt		_acee_js						;没有退出
		bra		_154_zt							;循环
_154_clr
		movea.w	A0,A1	
		jsr		_CLR_OBJ
		bra		_acee_js
		; movea.w	($B0,A6),A1					;大龙另一个头的OBJ地址
		; clr.l	D0
		; move.b	#$37,D0
; _acee_dl_cl_a1		
		; clr.l	(a1)+						;清理OBJ数据	
		; dbRA	D0,_acee_dl_cl_a1	
		
		; movea.w	($B2,A6),A1					;大龙另一个头的OBJ地址
		; move.b	#$37,D0
; _acee_dl_cl_a2		
		; clr.l	(a1)+						;清理OBJ数据	
		; dbRA	D0,_acee_dl_cl_a2	
		
		; movea.w	($B4,A6),A1					;大龙另一个头的OBJ地址
		; move.b	#$37,D0
; _acee_dl_cl_a3		
		; clr.l	(a1)+						;清理OBJ数据	
		; dbRA	D0,_acee_dl_cl_a3	

		; movea.w	($B6,A6),A1					;大龙另一个头的OBJ地址
		; move.b	#$37,D0
; _acee_dl_cl_a4		
		; clr.l	(a1)+						;清理OBJ数据	
		; dbRA	D0,_acee_dl_cl_a4	
_acee_js		
		movem.l	(A7)+,A0-A1/D0-D1
		bra	    _acee_noguandi_jx
		;---------------------------清理OBJ数据------------------------------		
_CLR_OBJ				
		CLR.L	($0,a1)
		CLR.L	($4,a1)	
		CLR.L	($8,a1)
		CLR.L	($c,a1)
		CLR.L	($10,a1)
		CLR.L	($14,a1)	
		CLR.L	($18,a1)
		CLR.L	($1c,a1)
		CLR.L	($20,a1)
		CLR.L	($24,a1)	
		CLR.L	($28,a1)
		CLR.L	($2c,a1)
		CLR.L	($30,a1)
		CLR.L	($34,a1)	
		CLR.L	($38,a1)
		CLR.L	($3c,a1)
		CLR.L	($40,a1)
		CLR.L	($44,a1)	
		CLR.L	($48,a1)
		CLR.L	($4c,a1)
		CLR.L	($50,a1)
		CLR.L	($54,a1)	
		CLR.L	($58,a1)
		CLR.L	($5c,a1)
		CLR.L	($60,a1)
		CLR.L	($64,a1)	
		CLR.L	($68,a1)
		CLR.L	($6c,a1)
		CLR.L	($70,a1)
		CLR.L	($74,a1)	
		CLR.L	($78,a1)
		CLR.L	($7c,a1)
		CLR.L	($80,a1)
		CLR.L	($84,a1)	
		CLR.L	($88,a1)
		CLR.L	($8c,a1)
		CLR.L	($90,a1)
		CLR.L	($94,a1)	
		CLR.L	($98,a1)
		CLR.L	($9c,a1)
		CLR.L	($a0,a1)
		CLR.L	($a4,a1)	
		CLR.L	($a8,a1)
		CLR.L	($ac,a1)
		CLR.L	($b0,a1)
		CLR.L	($b4,a1)	
		CLR.L	($b8,a1)
		CLR.L	($bc,a1)
		CLR.L	($c0,a1)
		CLR.L	($c4,a1)	
		CLR.L	($c8,a1)
		CLR.L	($cc,a1)
		CLR.L	($d0,a1)
		CLR.L	($d4,a1)	
		CLR.L	($d8,a1)
		CLR.L	($dc,a1)
		rts
	








		
		;------------------------幻影这些怪的置8------------------------------
		org		$01720A					;敌人死后才会运行的某处			
		jmp		$1df000			
		org		$1df000		
		
	
		
		tst.w   ($6c,A3)				;原来的 检测血量是否为0		
		bne     _17216					;原来的	不为0则退出
		;--------------------------------血量为0了---------------------------------
		cmpa.l	#$FFFFDD14,A3			;过滤掉非敌人基址（己方、箱子、特效等）
		bGt		_17212					;超过范围不改ID	
		cmpa.l	#$FFFFC8f4,A3			;过滤掉非敌人基址（己方、箱子、特效等）
		blT		_17212					;超过范围不改ID	
		
		tst.b	$ffff00						*是否关底(以后要改成是否最后一只关底BOSS)
		bne		_17212						*非尾1不改ID
		
		move.w	#$48,($20,a3)				;非关底，强制改成马甲ID，这样BOSS死后不会过关，且尸体会消失	
		move.b	#$02,($26,a3)				;非关底，强制改成马甲ID，这样BOSS死后不会过关，且尸体会消失			
_17212		
		jmp		$017212		
		;-----------------------------------------------------------------------
_17216
		jmp		$017216						;这是原来的，别被骗了，没用
		

	;======================================派兵跟死后不动的=====================================
		ORG		$07BEDC
		jmp		$1df080
		org		$1df080		
		tst.b	$ffff00						;是否关底
		beq		_7bedc_noguandi
		jsr     $4860.l
		jmp		$07BEE2		
_7bedc_noguandi		
		rts
	;==========================================出场音乐=============================================
		org     $058612                    ;取消2B开场音乐
        jsr     $1df100
        org     $1df100	
		tst.b	$ffff00					   ;是否关底
		bne		_2bmusic		
        rts
_2bmusic
        cmpi.b  #$1,$FF84D9				   ;是否2关										
        bne     _2bmusic_no
        jsr     $a63c
_2bmusic_no		
        rts
		;------------------------------------------------------------
		org     $0517d6                    ;取消5B开场音乐
        jsr     $1df180
        org     $1df180	
		tst.b	$ffff00					   ;是否关底
		bne		_5bmusic		
        rts
_5bmusic
        cmpi.b  #$4,$FF84D9				   ;是否5关										
        bne     _5bmusic_no
        jsr     $a63c
_5bmusic_no		
        rts
		;------------------------------------------------------------
		org     $61882                    ;取消8B开场音乐
        jsr     $1df200
        org     $1df200	
		tst.b	$ffff00					   ;是否关底
		beq		_8bmusic_no		
        cmpi.b  #$7,$FF84D9				   ;是否8关										
        bne     _8bmusic_no
        jsr     $a63c
_8bmusic_no		
        rts
		;======================================取消马云打死慢动作、小兵死=======================================				
		org		$052D8a
		jmp		$1df300	
		org		$1df300			
		tst.b	$ffff00					   ;是否关底，关底会变龙
		BNE		_052D8a_Y		
		move.w	#$8,($20,a6)			   ;非关底，强制改成马甲ID，这样BOSS死后不会过关，且尸体会消失	
_052D8a_Y		
		jmp     $052d9C




*_____________________________________________过关清空暂存数据_______________________________________________	
			org		$ABEC							;过关+1的地方
			jsr		$1dfa00							;
			org		$1dfa00							;					
			andi.b  #$7, ($4d9,A5)					;原来的关卡相关指令，别管			
			clr.l		$ffff00						;全部清零
			clr.l		$ffff04
			clr.l		$ffff08
			clr.l		$ffff0c					
		
			clr.l		$ffffD0						;fFd0-fFdF全部清零
			clr.l		$ffffD4
			clr.l		$ffffD8
			clr.l		$ffffDc					
			
			clr.l		$ffffe0						;fFE0-fFF0全部清零
			clr.l		$ffffe4
			clr.l		$ffffe8
			clr.l		$ffffec		

			clr.l		$fffff0						;fFE0-fFF0全部清零
			clr.l		$fffff4
			clr.l		$fffff8
			clr.l		$fffffc				
			rts


*_____________________________________________正式游戏时，会一直读取时间的地址_______________________________________________	
		org		$810ba
		jmp		$1dfe00
		org		$1dfe00
		cmpi.w  #$300, ($4e8,A5)				;原来读取时间地址的地方，不管
		jsr		_gdbq							;插入按卷轴识别关底标签
		jmp		$0810C0							;返回
	;=================================按卷轴识别关底标签=======================================
_gdbq		
		tst.b	$ffff00							;是否关底
		bne		_gdbq_rts						;是不再进行检测（因为有时关底卷轴会往左跑，不好检测）
		cmpi.b  #$0,$FF84D9						;是否1关
        beq     _ckjz_1							;检测卷轴是否到关底了
		cmpi.b  #$1,$FF84D9						;是否2关
        beq     _ckjz_2							;检测卷轴是否到关底了		
		cmpi.b  #$2,$FF84D9						;是否3关
        beq     _ckjz_3							;检测卷轴是否到关底了	
		cmpi.b  #$3,$FF84D9						;是否4关
        beq     _ckjz_4							;检测卷轴是否到关底了	
		cmpi.b  #$4,$FF84D9						;是否5关
        beq     _ckjz_5							;检测卷轴是否到关底了	
		cmpi.b  #$5,$FF84D9						;是否6关
        beq     _ckjz_6							;检测卷轴是否到关底了	
		cmpi.b  #$6,$FF84D9						;是否7关
        beq     _ckjz_7							;检测卷轴是否到关底了	
		cmpi.b  #$7,$FF84D9						;是否8关
        beq     _ckjz_8							;检测卷轴是否到关底了	
_gdbq_rts										;难道还有9关。..不成。...
		rts
	;-------------------------------------------------------------------------------
_ckjz_1
        cmpi.b  #$2,$FF8786                     ;检测是否第3场景
		bne     _gdbq_rts						;不是退出
		cmpi.w	#$1a2,$ff8864					;卷轴到关底了			
		bge		_m1_ffff00_						;ffff00置1，表示关底
		rts
	;-----------------------------------------------------------
_ckjz_2
        cmpi.b  #$2,$FF8786                     ;检测是否第3场景
		bne     _gdbq_rts						;不是退出
		cmpi.w	#$250,$ff8864					;卷轴到关底了			
		bge		_m1_ffff00_						;ffff00置1，表示关底
		rts
	;-----------------------------------------------------------
_ckjz_3
		cmpi.w	#$2ccc,$ff8864					;卷轴到关底了			
		bge		_m1_ffff00_						;ffff00置1，表示关底
		rts
	;-----------------------------------------------------------
_ckjz_4
        cmpi.b  #$2,$FF8786                     ;检测是否第3场景
		bne     _gdbq_rts						;不是退出
		cmpi.w	#$39E,$ff8864					;卷轴到关底了			
		bge		_m1_ffff00_						;ffff00置1，表示关底
		rts
	;-----------------------------------------------------------
_ckjz_5
        cmpi.b  #$1,$FF8786                     ;检测是否第2场景
		bne     _gdbq_rts						;不是退出
		cmpi.w	#$1100,$ff8864					;卷轴到关底了			
		bge		_m1_ffff00_						;ffff00置1，表示关底
		rts
	;-----------------------------------------------------------
_ckjz_6
        cmpi.b  #$2,$FF8786                     ;检测是否第3场景
		bne     _gdbq_rts						;不是退出
		cmpi.w	#$FDF,$ff8864					;卷轴到关底了			
		bge		_m1_ffff00_						;ffff00置1，表示关底
		rts
	;-----------------------------------------------------------
_ckjz_7
        cmpi.b  #$3,$FF8786                     ;检测是否第4场景
		bne     _gdbq_rts						;不是退出
		cmpi.w	#$34A,$ff8864					;卷轴到关底了			
		bge		_m1_ffff00_						;ffff00置1，表示关底
		rts
	;-----------------------------------------------------------
_ckjz_8
        cmpi.b  #$3,$FF8786                     ;检测是否第4场景
		bne     _gdbq_rts						;不是退出
		cmpi.w	#$FC5,$ff8864					;卷轴到关底了			
		bge		_m1_ffff00_						;ffff00置1，表示关底
		rts
	;---------------------------------------------------------							
_m1_ffff00_
		move.b	#$1,$ffff00						;检测到是关底，置1
		rts
		
		
*_____________________________________________一直运行的指令，读取基址存在否处（插入动态强制色板）_______________________________________________	
		org		$23428
		jmp		$1e0000
		org		$1e0000
		jsr		_dtsb_q_x					*插入的"动态强制色板程序"
		tst.b    ($0,A6)					;读取敌人是否存在什么鬼的，别管
		BEQ		 _23436						;读取敌人是否存在什么鬼的，别管
		JMP		$2342E						;读取敌人是否存在什么鬼的，别管

_23436
		JMP		$23436						;读取敌人是否存在什么鬼的，别管

*_____________________________________________动态0D-1D载色(更改D3显色位,0E1E摩托)___________________________________________________________	
	*===========================================【1】求D6\D7，并写入内存=============================================================		
		org		$1e0100		
_dtsb_q_x		
		movem.l D0-d2/d4-D7/A0-A6,-(A7)		;入栈(目的借用寄存器)
		clr.l	D0							;使用前清除原值
		clr.l	D1							;使用前清除原值
		clr.l	D2							;使用前清除原值	
		clr.l	D6							;使用前清除原值
		clr.l	D4							;使用前清除原值
		clr.l	D5			 				;使用前清除原值
		clr.l	D7			 				;使用前清除原值	
		
		movea.l	A6,A0					;A0A6共用
		tst.b	$ff84e4					;没人玩则不用动态色板	
		beq		_no_dr	
_feishuili		
		cmpa.l	#$FFFFDD14,A6			;过滤掉非敌人基址（己方、箱子、特效等）
		bGt		_no_dr					;超过范围跳出动态色板程序	
		cmpa.l	#$FFFFC8f4,A6			;过滤掉非敌人基址（己方、箱子、特效等）
		blT		_no_dr					;超过范围跳出动态色板程序
		cmpi.w	#8,($20,A6)				;过滤非敌人ID
		blt		_no_dr					;小于8(马甲)则退出
	;---------------------------------过滤非敌人ID(不过滤会很卡)--------------------------------------	
		cmpi.w	#$1C,($20,A6)			;
		beq		_no_dr					;
		cmpi.w	#$20,($20,A6)			;
		beq		_no_dr					;
		cmpi.w	#$24,($20,A6)			;
		beq		_no_dr					;
		cmpi.w	#$3C,($20,A6)			;
		beq		_no_dr					;
		cmpi.w	#$40,($20,A6)			;
		beq		_no_dr					;
		cmpi.w	#$44,($20,A6)			;
		beq		_no_dr					;	
		cmpi.w	#$4C,($20,A6)			;
		beq		_no_dr					;
		cmpi.w	#$5C,($20,A6)			;
		beq		_no_dr					;
		cmpi.w	#$68,($20,A6)			;
		beq		_no_dr					;	
		cmpi.w	#$78,($20,A6)			;
		beq		_no_dr					;	
		cmpi.w	#$84,($20,A6)			;
		beq		_no_dr					;	
		cmpi.w	#$D4,($20,A6)			;
		beq		_no_dr					;	
		cmpi.w	#$E4,($20,A6)			;
		beq		_no_dr					;			
		cmpi.w	#$a8,($20,A6)			;3B的炸弹
		beq		_no_dr					;		
		cmpi.w	#$ec,($20,A6)			;马云枪子弹
		beq		_no_dr					;				
		cmpi.w	#$f0,($20,A6)			;匕首兵的匕首
		beq		_no_dr					;
		cmpi.w	#$104,($20,A6)			;滚桶
		beq		_no_dr					;
		cmpi.w	#$108,($20,A6)			;落石
		beq		_no_dr					;
		cmpi.w	#$10C,($20,A6)			;机枪
		beq		_no_dr_CLR_23			;
		cmpi.w	#$110,($20,A6)			;手雷
		beq		_no_dr					;
		cmpi.w	#$114,($20,A6)			;
		beq		_no_dr					;
		cmpi.w	#$124,($20,A6)			;
		beq		_no_dr					;
		cmpi.w	#$128,($20,A6)			;
		beq		_no_dr					;
		cmpi.w	#$12c,($20,A6)			;
		beq		_no_dr					;	
		cmpi.w	#$154,($20,A6)			;
		beq		_no_dr					;	
		cmpi.w	#$158,($20,A6)			;
		beq		_no_dr					;	
		cmpi.w	#$15c,($20,A6)			;
		beq		_no_dr					;	
		cmpi.w	#$160,($20,A6)			;
		beq		_no_dr					;	
		cmpi.w	#$164,($20,A6)			;
		beq		_no_dr					;	
		cmpi.w	#$168,($20,A6)			;
		beq		_no_dr					;	
		cmpi.w	#$17c,($20,A6)			;大龙火球
		beq		_no_dr					;	
		cmpi.w	#$180,($20,A6)			;
		beq		_no_dr					;	
		cmpi.w	#$184,($20,A6)			;
		beq		_no_dr					;	
		cmpi.w	#$188,($20,A6)			;
		beq		_no_dr					;	
		cmpi.w	#$18c,($20,A6)			;
		beq		_no_dr					;	
		cmpi.w	#$190,($20,A6)			;
		beq		_no_dr					;	
		cmpi.w	#$194,($20,A6)			;
		beq		_no_dr					;	
		cmpi.w	#$198,($20,A6)			;
		beq		_no_dr					;	
		cmpi.w	#$b8,($20,A6)			;2关开头飞鸟
		beq		_no_dr					;	
		cmpi.w	#$194,($20,A6)			;
		beq		_no_dr					;	
		cmpi.w	#$198,($20,A6)			;
		beq		_no_dr					;	
		
		

		
		cmpi.w	#$118,($20,A6)			;蓝马甲骑兵
		beq		_jc_lmjmt				;查出使用8E\9E色板的OBJ并清除，再写入914000+$20*$E;914000+$20*$1E	
		cmpi.w	#$7C,($20,A6)			;3Boss
		beq		_jc_l3BS				;查出使用97\9f色板的OBJ并清除，写入914000+$20*$17;914000+$20*$1f	

		
*---------------------------------------显色位分配------------------------------------------------
	;---------------------------重刷色板---------------------------------		
		move.b	($D6,A0),D1				;强制色板给D1
		beq		_jc_xsw					;0则申请显色位	
		move.b	($D6,A0),($23,a0)		;锁定强制色板	
		
		andi.b	#$1f,D1	
		mulu.w	#$20,D1					;色板一组32个，所以乘20（16进制）
		moveA.l	#$914000,A1				;显色存基址
		add.w	D1,A1					;转换成显色地址相关
		bra		_xieru2					;跳到搬运色板的地方
		
		bra		_no_dr			
	;=======================================蓝马甲摩托(清理被占用色位)=============================================
_jc_lmjmt
		move.b	#$8e,D0						;蓝马甲骑兵显色位
		move.b	#$9e,D1						;蓝马甲摩托显色位			
_jc_lmjmt_ks		
		movea.l	#$FFFFDD14,A3				;载入敌人起始基址
_jc_lmjmt_next		
		cmpa.l	#$FFFFC8f4,A3				;是否小于FFFFC8f4
		bLT		_mjmt_xr_8e_9e				;结束，写入色板到8E9E【必走】
		cmp.B	($d6,A3),D0					;某敌人是否使用D0(某显色位)
		beq		_jc_lmjmt_qld6				;被占用清除
_jc_lmjmt_d1		
		cmp.B	($d6,A3),D1					;某敌人是否使用D0(某显色位)
		beq		_jc_lmjmt_qld61				;被占用清除	
_jc_lmjmt_nw		
		suba.l	#$E0,A3						;基址偏移-E0
		bra		_jc_lmjmt_next				;检测下一个敌人基址		
	;---------------------------------------清理被占用d6值--------------------------------------------
_jc_lmjmt_qld6
		clr.b	($d6,A3)					;清理掉
		bra		_jc_lmjmt_d1 
_jc_lmjmt_qld61
		clr.b	($d6,A3)					;清理掉
		bra		_jc_lmjmt_nw 
		
	;=======================================3BOSS摩托(清理被占用色位)=============================================
_jc_l3BS
		move.b	#$9e,D1						;3BOSS摩托佬显色位			
_jc_l3BS_ks		
		movea.l	#$FFFFDD14,A3				;载入敌人起始基址
_jc_l3BS_next		
		cmpa.l	#$FFFFC8f4,A3				;是否小于FFFFC8f4
		bLT		_3boss_xr_97_9F				;结束，写入色板到979F【必走】
_jc_l3BS_d1		
		cmp.B	($d6,A3),D1					;某敌人是否使用D0(某显色位)
		beq		_jc_l3BS_qld61				;被占用清除	
_jc_l3BS_nw		
		suba.l	#$E0,A3						;基址偏移-E0
		bra		_jc_l3BS_next				;检测下一个敌人基址		
	;---------------------------------------清理被占用d6值--------------------------------------------
_jc_l3BS_qld61
		clr.b	($d6,A3)					;清理掉
		bra		_jc_l3BS_nw 		
		
				
	;---------------------------不符合条件/退出---------------------------------;		
_no_dr_CLR_23
		CLR.B	($23,a0)
_no_dr		
		movem.l (A7)+,D0-d2/d4-D7/A0-A6		;出栈(程序结束，返还寄存器原值)
		RTS								

	*------------------------------申请显色位（8d-9f ）-------------------------------------	
_jc_xsw
		move.b	#$8d,D0						;初始显存位，强制色板8d开始		
		
_xsw_jc_ks		
		movea.l	#$FFFFDD14,A3				;载入敌人起始基址
_jzjc_next		
		cmpa.l	#$FFFFC8f4,A3				;是否小于FFFFC8f4
		bLT		_jcd_ok						;小于FFFFC8f4，说明场上敌人没人用此显色位，同意使用
		cmp.B	($d6,A3),D0					;某敌人是否使用D0(某显色位)
		beq		_jcd_j						;此显色位已被使用，得换色位重新检测
		suba.l	#$E0,A3						;基址偏移-E0
		bra		_jzjc_next					;检测下一个敌人基址
		
	*==========================================================				
_jcd_j
		addq	#1,D0						;已被使用D0+1检测重新检测
		cmpi.b	#$8e,D0						;是否摩托骑兵色位
		bEQ		_jcl_mtqb					;	
_jcd_j_9e		
		cmpi.b	#$9e,D0						;是否摩托骑兵的摩托色位
		bEQ		_jcl_mtqbb					;	
_jcd_j_9f		
		cmpi.b	#$9f,D0						;是否摩托骑兵的摩托色位
		bEQ		_jcl_mtqbbb					;				
_jcd_j_9c		
		cmpi.b	#$9c,D0						;是否9c，9c是水里占用
		bEQ		_jcd_sfSL					;是检测是否水里						
_jc_sw_jx	
		cmpi.b	#$9f,D0						;超过9f还是退出吧
		bgt		_no_dr		
		bra		_xsw_jc_ks					;重新开始检测 DD14~C8f4		
	;==========================检测场上有118骑兵否================================			
_jcl_mtqb		
		movea.l	#$FFFFDD14,A4				;载入敌人起始基址
_jcl_mtqb1		
		cmpa.l	#$FFFFC8f4,A4				;是否小于FFFFC8f4
		bLT		_jcd_j_9e					;小于FFFFC8f4，说明场上敌人没有骑兵
		cmp.w	#$118,($20,A4)				;某敌人是骑兵
		beq		_jcd_j						;色位+1
		suba.l	#$E0,A4						;基址偏移-E0
		bra		_jcl_mtqb1					;检测下一个敌人基址		
	;==========================检测场上有118骑兵否2================================			
_jcl_mtqbb		
		movea.l	#$FFFFDD14,A4				;载入敌人起始基址
_jcl_mtqbb1		
		cmpa.l	#$FFFFC8f4,A4				;是否小于FFFFC8f4
		bLT		_jcd_j_9f					;小于FFFFC8f4，说明场上敌人没人用此显色位，同意使用
		cmp.w	#$118,($20,A4)				;某敌人是骑兵
		beq		_jcd_j						;此显色位已被使用，得换色位重新检测
		suba.l	#$E0,A4						;基址偏移-E0
		bra		_jcl_mtqbb1					;检测下一个敌人基址		
	;==========================检测场上有7C骑兵否3================================			
_jcl_mtqbbb		
		movea.l	#$FFFFDD14,A4				;载入敌人起始基址
_jcl_mtqbbb1		
		cmpa.l	#$FFFFC8f4,A4				;是否小于FFFFC8f4
		bLT		_jcd_j_9c					;小于FFFFC8f4，说明场上敌人没人用此显色位，同意使用
		cmp.w	#$7C,($20,A4)				;某敌人是骑兵
		beq		_jcd_j						;此显色位已被使用，得换色位重新检测
		suba.l	#$E0,A4						;基址偏移-E0
		bra		_jcl_mtqbbb1				;检测下一个敌人基址		

		
	;===========================================================================================			
_jcd_sfSL			
        cmpi.b  #1,$FF84D9            		;检测是否2关
		beq     _jc_cj26	
        cmpi.b  #5,$FF84D9            		;检测是否6关
		beq     _jc_cj26	
		bra		_jc_sw_jx					;继续
		;---------------------------------------------------
_jc_cj26		
		cmpi.b  #1,$FF8786					;是否2场景
		bne     _jc_sw_jx					;否继续				
		addq	#1,D0						;都是D0加1，绕过
		bra		_jc_sw_jx					;继续	
	*===========================↓↓↓===申请到色位，并写入===↓↓↓===============================		
_jcd_ok	
		move.b	D0,($d6,A0)					;写入色板位
		move.b	D0,($23,A0)					;写入强制色板			
		andi.b	#$1f,D0						;压缩到20内			
							
*---------------------------------------写入色板数据------------------------------------------------
_xieru
		mulu.w 		#$20,D0					;转换成显存相关
		moveA.l 	#$914000,A1				;显色存基址
		add.w		D0,A1					;转换成显存相关		
		clr.l		D1						;D1被用来干其他事情了		
		bra			_id_qusebanhao			;根据ID取得色板号，写入显色
_sbgl		
		bra			_xsgy					;场上是否有相同色板号，有则共用，不新增	
	*--------------------------正式搬运色板数据-----------------------------			
_xieru2
		move.b	($d7,a6),D1					;色板号在D1	
		andi.w	#$ff,D1						;去掉低34位			
		mulu.w  #$20,D1						;取得色板号X20		
		movea.l  #$b7a52,A2					;色板数据基址(第一个是白人是色板)
		add.l	D1,A2						;得出此敌人色板数据
		
		
	*--------------------------正式搬运色板数据-----------------------------	
		clr.l		D2
		move.b		#$f,D2								;2行（双字节16组）搬运20次
_A1_A2_loop_all	
		dbra		D2,_A1_A2_goon_all					;循环20次
		bra			_A2A0Js_lb_all						;搬运完成收工退出
_A1_A2_goon_all	
		move.w		(A2)+,(A1)							;搬运色板数据到显色
		or.w		#$f000,(A1)+						;低4位加上F	
		bra			_A1_A2_loop_all						;继续下一组
_A2A0Js_lb_all		
		; cmpi.w		#$150,($20,A0)						;是否大龙主体
		; beq			_D6_D3								;是则D3的值不变（大龙插入动态色板不在砖块搬运处）
_dtsb_over
		movem.l		(A7)+,D0-d2/d4-D7/A0-A6				;全部16组搬完，出栈收工	
		rts							

		
		
	*--------------------------根据ID分配色板-----------------------------------	
_id_qusebanhao
		cmpi.w		#$8,($20,A0)			;马甲
		beq		_sehao_mj		
		cmpi.w		#$6c,($20,A0)	    	;马甲
		beq		_sehao_mj_6c	
		cmpi.w		#$dc,($20,A0)			;马甲
		beq		_sehao_mj			
		; cmpi.w		#$118,($20,A0)			;骑摩托
		; beq		_sehao_mt						
		cmpi.w		#$c4,($20,A0)			;1关天台翼龙
		beq			_sehao_ttyl							
		cmpi.w		#$c8,($20,A0)			;1关天台翼龙
		beq			_sehao_ttyl					
				

		cmpi.w		#$c,($20,A0)			;链锤
		beq			_sehao_lc		
		
		cmpi.w		#$10,($20,A0)			;寄生兽（BOSS）
		beq			_sehao_tyrog	
		cmpi.w		#$16C,($20,A0)			;寄生兽 tyrog2	
		beq			_sehao_tyrog	
		
		cmpi.w		#$14,($20,A0)			;屠夫
		beq			_sehao_tf
		cmpi.w		#$F4,($20,A0)			;屠夫
		beq			_sehao_tf
		cmpi.w		#$D0,($20,A0)			;屠夫刀x	
		beq			_sehao_tf
		
		cmpi.w		#$18,($20,A0)			;狮子
		beq			_sehao_sz	
		
		cmpi.w		#$28,($20,A0)			;胖子
		beq			_sehao_pz	
		cmpi.L		#$6c008D,($20,A0)		;4关滴汗胖子
		beq			_sehao_pz			
		cmpi.w		#$13C,($20,A0)			;打龙胖子
		beq			_sehao_pz	
		
		cmpi.w		#$2c,($20,A0)			;开场动画步枪兵（可无视）
		beq			_sehao_bq
		cmpi.w		#$34,($20,A0)			;步枪兵
		beq			_sehao_bq		
		
		; cmpi.w		#$30,($20,A0)			;开场逃跑角龙（可无视）
		; beq			_sehao_kcfl	
		
		cmpi.w		#$38,($20,A0)			;匕首兵
		beq			_sehao_bs
		cmpi.w		#$FC,($20,A0)			;匕首兵
		beq			_sehao_bs
		
		cmpi.w		#$40,($20,A0)			;车子
		beq			_sehao_cz		
		
		cmpi.w		#$44,($20,A0)			;车轮
		beq			_sehao_cl		

		
		
		cmpi.w		#$48,($20,A0)			;大个
		beq			_sehao_dg		
		cmpi.w		#$D8,($20,A0)			;大个(1关开场)
		beq			_sehao_dg	
		
		cmpi.w		#$50,($20,A0)			;猴子
		beq			_sehao_hz	
		cmpi.w		#$100,($20,A0)			;扔雷猴子
		beq			_sehao_hz	
		cmpi.w		#$134,($20,A0)			;扔雷猴子
		beq			_sehao_hz
		
		cmpi.w		#$58,($20,A0)			;巨脚
		beq			_sehao_jj		
		
		cmpi.w		#$60,($20,A0)			;暴龙
		beq			_sehao_bl	
		
		cmpi.w		#$64,($20,A0)			;4b
		beq			_sehao_4b	
		cmpi.w		#$ac,($20,A0)			;4b
		beq			_sehao_4b			
		cmpi.w		#$11c,($20,A0)			;幻影
		beq			_sehao_4b	
		
		cmpi.w		#$74,($20,A0)			;异龙锁
		beq			_sehao_YL			
		cmpi.w		#$11c,($20,A0)			;异龙
		beq			_sehao_YL				

		cmpi.w		#$7c,($20,A0)			;3B
		beq			_sehao_3b			
		cmpi.w		#$80,($20,A0)			;摩托
		beq			_sehao_mt		
				
		cmpi.w		#$8C,($20,A0)			;马云+老头
		beq			_sehao_my
		cmpi.w		#$90,($20,A0)			;马云
		beq			_sehao_my

		cmpi.w		#$A0,($20,A0)			;马云龙
		beq			_sehao_MYL
		cmpi.w		#$178,($20,A0)			;宋小龙
		beq			_sehao_MYL
		
		cmpi.w		#$94,($20,A0)			;飞龙
		beq			_sehao_FL		
		cmpi.w		#$148,($20,A0)			;飞龙（会打人）
		beq			_sehao_FL
		
		cmpi.w		#$98,($20,A0)			;角龙
		beq			_sehao_JL
		cmpi.w		#$B0,($20,A0)			;迷你角龙
		beq			_sehao_JL
		cmpi.w		#$BC,($20,A0)			;迷你雷龙
		beq			_sehao_JL
		cmpi.w		#$138,($20,A0)			;迷你角龙
		beq			_sehao_JL
		cmpi.w		#$140,($20,A0)			;迷你雷龙
		beq			_sehao_JL
		
		cmpi.w		#$9c,($20,A0)			;宋小宝
		beq			_sehao_sxb		
		
		cmpi.w		#$b4,($20,A0)			;老头
		beq			_sehao_lt			
		
		cmpi.w		#$cc,($20,A0)			;被砍龙
		beq			_sehao_bkl			
		
		cmpi.w		#$150,($20,A0)			;大龙
		beq			_sehao_dl			
_nossid
		clr.w		($d6,A0)				;清除d6,A0	
		bra			_no_dr					;都不是跳出()
		;----------------------------------------------------
_sehao_mj_6c
		cmpi.b		#$04,($26,a0)
		beq			_sehao_pz				;ID 6C，子类为4是胖子，非4是马甲 
		bra			_sehao_mj	
		
		
		;-----------------------------------按ID分配色板号---------------------------------------------
_sehao_mj
		clr.l	D0								;D0.b用来做随机数
		jsr     _suiji							;随机程序			
		divu.w	#$6,D0							;求余, 即限制范围( )	
		swap	D0		    				    ;余数在高12位，交叉下	
		move.b	(_sehao_9a_data,PC,D0),D1	    ;取下表中随机一色
		move.b	D1,($D7,A0)						;色板号也写入敌人内存中
		bra    _sbgl
_sehao_9a_data
		dc.w	$0D0E,$3D3D,$0D0E				;3个												
;橙 蓝 绿

_sehao_ttyl
		; cmpi.b	#$8,($27,a0)					;是否天台翼龙(动作8是，C8还可能是马云变身中)
		; bne		_nossid							;非退出
		clr.l	D0								;D0.b用来做随机数
		jsr     _suiji							;随机程序			
		divu.w	#$6,D0							;求余, 即限制范围( )	
		swap	D0		    				    ;余数在高12位，交叉下	
		move.b	(_sehao_c8_data,PC,D0),D1	    ;取下表中随机一色
		move.b	D1,($D7,A0)						;色板号也写入敌人内存中
		bra    _sbgl
_sehao_c8_data
		dc.w	$3127,$2D71,$7235
;橙 蓝 绿 绿 灰 白

				
_sehao_lc
		clr.l	D0								;D0.b用来做随机数
		jsr     _suiji							;随机程序			
		divu.w	#$2,D0							;求余, 即限制范围( )	
		swap	D0		    					;余数在高12位，交叉下	
		move.b	(_sehao_dz_data,PC,D0),D1		;取下表中随机一色
		move.b	D1,($D7,A0)						;色板号也写入敌人内存中
		bra    _sbgl
_sehao_dz_data
		dc.w	$1A1a	
;肉 


_sehao_tyrog	
		clr.l	D0								;D0.b用来做随机数
		jsr     _suiji							;随机程序			
		divu.w	#$6,D0							;求余, 即限制范围( )	
		swap	D0		    					;余数在高12位，交叉下	
		move.b	(_sehao_gc_data,PC,D0),D1		;取下表中随机一色
		move.b	D1,($d7,A0)						;色板号也写入敌人内存中
		bra    _sbgl
_sehao_gc_data
		dc.w	$2E27,$2A79,$7172 
; 橙 蓝 蓝 粉 绿 灰 



_sehao_tf
		clr.l	D0							;D0.b用来做随机数
		jsr     _suiji						;随机程序			
		divu.w	#$4,D0						;求余, 即限制范围( )	
		swap	D0		    				;余数在高12位，交叉下	
		move.b	(_sehao_RZ_data,PC,D0),D1	;取下表中随机一色
		move.b	D1,($d7,A0)					;色板号也写入敌人内存中
		bra    _sbgl
_sehao_RZ_data
		dc.w	$171d,$7374
;  绿  红  粉 蓝


_sehao_sz
		clr.l	D0							;D0.b用来做随机数
		jsr     _suiji						;随机程序			
		divu.w	#$4,D0						;求余, 即限制范围( )	
		swap	D0		    				;余数在高12位，交叉下	
		move.b	(_sehao_ff_data,PC,D0),D1	;取下表中随机一色
		move.b	D1,($d7,A0)					;色板号也写入敌人内存中
		bra    _sbgl
_sehao_ff_data
		dc.w	$171d,$7374
; 绿 红 粉 蓝 


_sehao_pz
		clr.l	D0							;D0.b用来做随机数
		jsr     _suiji						;随机程序			
		divu.w	#$6,D0						;求余, 即限制范围( )	
		swap	D0		    				;余数在高12位，交叉下	
		move.b	(_sehao_3m_data,PC,D0),D1	;取下表中随机一色
		move.b	D1,($d7,A0)					;色板号也写入敌人内存中
		bra    _sbgl
_sehao_3m_data
		dc.w	$0212,$1314,$3e75
;绿 黄 紫 绿 粉 黑黄


_sehao_bq
		clr.l	D0							;D0.b用来做随机数
		jsr     _suiji						;随机程序			
		divu.w	#$6,D0						;求余, 即限制范围( )	
		swap	D0		    				;余数在高12位，交叉下	
		move.b	(_sehao_ld_data,PC,D0),D1	;取下表中随机一色
		move.b	D1,($d7,A0)					;色板号也写入敌人内存中
		bra    _sbgl
_sehao_ld_data
		dc.w	$0F10,$1111,$0F10
;绿 红 黄  	

		
; _sehao_kcfl		;可能作废了
		; clr.l	D0							;D0.b用来做随机数
		; jsr     _suiji						;随机程序			
		; divu.w	#$2,D0						;求余, 即限制范围( )	
		; swap	D0		    				;余数在高12位，交叉下	
		; move.b	(_sehao_xhd_data,PC,D0),D1	;取下表中随机一色
		; move.b	D1,($d7,A0)					;色板号也写入敌人内存中
		; bra    _sbgl
; _sehao_xhd_data
		; dc.w	$1414

		
_sehao_bs
		clr.l	D0							;D0.b用来做随机数
		jsr     _suiji						;随机程序			
		divu.w	#$6,D0						;求余, 即限制范围( )	
		swap	D0		    				;余数在高12位，交叉下	
		move.b	(_sehao_xzym_data,PC,D0),D1	;取下表中随机一色
		move.b	D1,($d7,A0)					;色板号也写入敌人内存中
		bra    _sbgl
_sehao_xzym_data
		dc.w	$0215,$1516,$3c3e
;绿 黄  黄 黄 粉 紫


_sehao_cz
		clr.l	D0							;D0.b用来做随机数
		jsr     _suiji						;随机程序			
		divu.w	#$2,D0						;求余, 即限制范围( )	
		swap	D0		    				;余数在高12位，交叉下	
		move.b	(_sehao_cr_data,PC,D0),D1	;取下表中随机一色
		move.b	D1,($d7,A0)					;色板号也写入敌人内存中
		bra    _sbgl
_sehao_cr_data
		dc.w	$2727
;蓝 
		
_sehao_cl
		clr.l	D0							;D0.b用来做随机数
		jsr     _suiji						;随机程序			
		divu.w	#$2,D0						;求余, 即限制范围( )	
		swap	D0		    				;余数在高12位，交叉下	
		move.b	(_sehao_cl_data,PC,D0),D1	;取下表中随机一色
		move.b	D1,($d7,A0)					;色板号也写入敌人内存中
		bra    _sbgl
_sehao_cl_data
		dc.w	$2525
;蓝 

		
_sehao_dg
		clr.l	D0								;D0.b用来做随机数
		jsr     _suiji							;随机程序			
		divu.w	#$6,D0							;求余, 即限制范围( )	
		swap	D0		    					;余数在高12位，交叉下	
		move.b	(_sehao_CYDXH_data,PC,D0),D1	;取下表中随机一色
		move.b	D1,($d7,A0)						;色板号也写入敌人内存中
		bra    _sbgl
_sehao_CYDXH_data
		dc.w	$1B1c,$1f40,$4142
;蓝 蓝 黄 红 黄 白 
		
		
		
		
_sehao_hz
		clr.l	D0							;D0.b用来做随机数
		jsr     _suiji						;随机程序			
		divu.w	#$a,D0						;求余, 即限制范围( )	
		swap	D0		    				;余数在高12位，交叉下	
		move.b	(_sehao_XHJ_data,PC,D0),D1	;取下表中随机一色
		move.b	D1,($d7,A0)					;色板号也写入敌人内存中
		bra    _sbgl
_sehao_XHJ_data
		dc.w	$0102,$1918,$3E3e,$0102,$1918
;红 绿 橙 卡 紫
		
		
		
_sehao_JJ
		clr.l	D0							;D0.b用来做随机数
		jsr     _suiji						;随机程序			
		divu.w	#$2,D0						;求余, 即限制范围( )	
		swap	D0		    				;余数在高12位，交叉下	
		move.b	(_sehao_zl_data,PC,D0),D1	;取下表中随机一色
		move.b	D1,($d7,A0)					;色板号也写入敌人内存中
		bra    _sbgl
_sehao_zl_data
		dc.w	$3030
;绿 		
		
		

		
_sehao_bl
		clr.l	D0							;D0.b用来做随机数
		jsr     _suiji						;随机程序			
		divu.w	#$4,D0						;求余, 即限制范围( )	
		swap	D0		    				;余数在高12位，交叉下	
		move.b	(_sehao_lb_data,PC,D0),D1	;取下表中随机一色
		move.b	D1,($d7,A0)					;色板号也写入敌人内存中
		bra    _sbgl
_sehao_lb_data
		dc.w	$2E2A,$2D71	
;黄 蓝 绿 绿		



_sehao_4b	;4幻影
		clr.l	D0								;D0.b用来做随机数
		jsr     _suiji							;随机程序			
		divu.w	#$2,D0							;求余, 即限制范围( )	
		swap	D0		    					;余数在高12位，交叉下	
		move.b	(_sehao_xhecc_data,PC,D0),D1	;取下表中随机一色
		move.b	D1,($d7,A0)						;色板号也写入敌人内存中
		bra    _sbgl
_sehao_xhecc_data
		dc.w	$2122
;肉 绿 		

_sehao_xxl
		clr.l	D0							;D0.b用来做随机数
		jsr     _suiji						;随机程序			
		divu.w	#$4,D0						;求余, 即限制范围( )	
		swap	D0		    				;余数在高12位，交叉下	
		move.b	(_sehao_xxl_data,PC,D0),D1	;取下表中随机一色
		move.b	D1,($d7,A0)					;色板号也写入敌人内存中
		bra    _sbgl
_sehao_xxl_data
		dc.w	$3128,$2D71	
;黄 蓝 绿 绿	
	
	
_sehao_YL		;异龙
		clr.l	D0							;D0.b用来做随机数
		jsr     _suiji						;随机程序			
		divu.w	#$6,D0						;求余, 即限制范围( )	
		swap	D0		    				;余数在高12位，交叉下	
		move.b	(_sehao_YL_data,PC,D0),D1	;取下表中随机一色
		move.b	D1,($d7,A0)					;色板号也写入敌人内存中
		bra    _sbgl
_sehao_YL_data
		dc.w	$2E2A,$2D71,$7279
;黄 蓝 绿 绿 黑 粉

	
_sehao_3b		;3BOSS
		clr.l	D0								;D0.b用来做随机数
		jsr     _suiji							;随机程序			
		divu.w	#$6,D0							;求余, 即限制范围( )	
		swap	D0		    					;余数在高12位，交叉下	
		move.b	(_sehao_3b_data,PC,D0),D1		;取下表中随机一色
		move.b	D1,($d7,A0)						;色板号也写入敌人内存中
		bra    _sbgl
_sehao_3b_data
		dc.w	$0034,$3A3E,$7279
;蓝 灰 灰 粉

_sehao_mt		;摩托
		clr.l	D0								;D0.b用来做随机数
		jsr     _suiji							;随机程序			
		divu.w	#$2,D0							;求余, 即限制范围( )	
		swap	D0		    					;余数在高12位，交叉下	
		move.b	(_sehao_mt_data,PC,D0),D1		;取下表中随机一色
		move.b	D1,($d7,A0)						;色板号也写入敌人内存中
		bra    _sbgl
_sehao_mt_data
		dc.w	$3535
;紫 

_sehao_my		;马云
		clr.l	D0								;D0.b用来做随机数
		jsr     _suiji							;随机程序			
		divu.w	#$6,D0							;求余, 即限制范围( )	
		swap	D0		    					;余数在高12位，交叉下	
		move.b	(_sehao_my_data,PC,D0),D1		;取下表中随机一色
		move.b	D1,($d7,A0)						;色板号也写入敌人内存中
		bra    _sbgl
_sehao_my_data
		dc.w	$1724,$2932,$7374
;绿 白 	青 蓝 紫  蓝

_sehao_myl		;马云龙
		clr.l	D0								;D0.b用来做随机数
		jsr     _suiji							;随机程序			
		divu.w	#$6,D0							;求余, 即限制范围( )	
		swap	D0		    					;余数在高12位，交叉下	
		move.b	(_sehao_myl_data,PC,D0),D1		;取下表中随机一色
		move.b	D1,($d7,A0)						;色板号也写入敌人内存中
		bra    _sbgl
_sehao_myl_data
		dc.w	$1724,$2932,$7374
;绿 白 	青 蓝 紫  蓝


_sehao_fl		;飞龙
		clr.l	D0								;D0.b用来做随机数
		jsr     _suiji							;随机程序			
		divu.w	#$6,D0							;求余, 即限制范围( )	
		swap	D0		    					;余数在高12位，交叉下	
		move.b	(_sehao_fl_data,PC,D0),D1		;取下表中随机一色
		move.b	D1,($d7,A0)						;色板号也写入敌人内存中
		bra    _sbgl
_sehao_fl_data
		dc.w	$3127,$2D71,$7235
;橙 蓝 绿 绿 灰 白
 
_sehao_jl		;角龙
		clr.l	D0								;D0.b用来做随机数
		jsr     _suiji							;随机程序			
		divu.w	#$6,D0							;求余, 即限制范围( )	
		swap	D0		    					;余数在高12位，交叉下	
		move.b	(_sehao_jl_data,PC,D0),D1		;取下表中随机一色
		move.b	D1,($d7,A0)						;色板号也写入敌人内存中
		bra    _sbgl
_sehao_jl_data
		dc.w	$282D,$3135,$712D
;蓝 绿 橙 白 绿

_sehao_sxb		;宋小宝
		clr.l	D0								;D0.b用来做随机数
		jsr     _suiji							;随机程序			
		divu.w	#$2,D0							;求余, 即限制范围( )	
		swap	D0		    					;余数在高12位，交叉下	
		move.b	(_sehao_sxb_data,PC,D0),D1		;取下表中随机一色
		move.b	D1,($d7,A0)						;色板号也写入敌人内存中
		bra    _sbgl
_sehao_sxb_data
		dc.w	$3434
;

_sehao_lt		;老头
		clr.l	D0								;D0.b用来做随机数
		jsr     _suiji							;随机程序			
		divu.w	#$2,D0							;求余, 即限制范围( )	
		swap	D0		    					;余数在高12位，交叉下	
		move.b	(_sehao_lt_data,PC,D0),D1		;取下表中随机一色
		move.b	D1,($d7,A0)						;色板号也写入敌人内存中
		bra    _sbgl
_sehao_lt_data
		dc.w	$2c2c
;

_sehao_bkl		;被砍龙
		clr.l	D0								;D0.b用来做随机数
		jsr     _suiji							;随机程序			
		divu.w	#$2,D0							;求余, 即限制范围( )	
		swap	D0		    					;余数在高12位，交叉下	
		move.b	(_sehao_bkl_data,PC,D0),D1		;取下表中随机一色
		move.b	D1,($d7,A0)						;色板号也写入敌人内存中
		bra    _sbgl
_sehao_bkl_data
		dc.w	$3636
;


_sehao_dl		;大龙
		clr.l	D0								;D0.b用来做随机数
		jsr     _suiji							;随机程序			
		divu.w	#$4,D0							;求余, 即限制范围( )	
		swap	D0		    					;余数在高12位，交叉下	
		move.b	(_sehao_sdb_data,PC,D0),D1		;取下表中随机一色
		move.b	D1,($d7,A0)						;色板号也写入敌人内存中
		bra    _sbgl
_sehao_sdb_data
		dc.w	$2d3B,$712A
;绿 粉 绿 蓝



	*--------------------------同色共用（如矛兵跟大赵都是蓝色，可以共用1显色位）----------------------------------	
_xsgy	
		move.b	($d7,A0),D0				;色板号1给D0	
		movea.l	A0,A3					;复制一份此敌人基址
		clr.l	D2

_idbl_e0	;检测场上敌人是否色板号一致		
		suba.l	#$E0,A3					;偏移到下一个敌人基址
		cmpa.l	#$FFFFC8f4,A3			;是否小于DD14
		Bge     _sbh_0_xyg				;大于C8F4，证明属于敌人基址，继续检测
		movea.l	#$FFFFDD14,A3			;A3置为DD14（第一个）
_sbh_0_xyg		
		cmpa.l	A3,A0					;是否绕了一圈基址
		beq		_xieru2					//绕了一圈没发现一样的，可以写入				
		;--------------------------------------------------
_id_dy_fc0b		
		move.b	($d7,A3),D1				;色板号2给D1
		beq		_idbl_e0				;D1为0就别检测了，下一个		
		cmp.w	D0,D1					;检测是否跟某色板号是否相同
		beq		_idyiyang				;相同则把复制它给D0
		bra		_idbl_e0				;不一样或者0，这跳到下个敌人基址
		;----------------------------------找到相同-------------------------------------
_idyiyang
		move.b	($d6,A3),($d6,A0)		;找到一致的色板号，与之共用	
		move.b	($d6,A3),($23,A0)		;找到一致的色板号，与之共用			
_idbuyiyang		
		bra		_xieru2					;重复写入色板数据
		

	;---------------------------摩托车数据写入---------------------------------	
_mjmt_xr_8e_9e	
		move.l	#$F111F343,$914000+$20*$E					;蓝马甲E
		move.l	#$F565F898,$914000+$20*$E+$4
		move.l	#$FABAF146,$914000+$20*$E+$8
		move.l	#$F169F0AC,$914000+$20*$E+$c
		move.l	#$F0EFFD00,$914000+$20*$E+$10
		move.l	#$FFC9FC86,$914000+$20*$E+$14
		move.l	#$F964F742,$914000+$20*$E+$18
		move.l	#$FFFFFA80,$914000+$20*$E+$1c
	
		move.l	#$F111F333,$914000+$20*$1E					;摩托1E
		move.l	#$F555F777,$914000+$20*$1E+$4
		move.l	#$F999FBBB,$914000+$20*$1E+$8
		move.l	#$FDDDFFFF,$914000+$20*$1E+$c
		move.l	#$FFEAFFD2,$914000+$20*$1E+$10
		move.l	#$FF93FE22,$914000+$20*$1E+$14
		move.l	#$FC06F908,$914000+$20*$1E+$18
		move.l	#$F607FA80,$914000+$20*$1E+$1c
		bra		_no_dr	
		;--------------------------------------------------------------------
_3boss_xr_97_9F				
		move.l	#$F111FFCA,$914000+$20*$1F					;3B 1F
		move.l	#$FD96FA64,$914000+$20*$1F+$4
		move.l	#$F730F334,$914000+$20*$1F+$8
		move.l	#$F556F667,$914000+$20*$1F+$c
		move.l	#$F889FBBC,$914000+$20*$1F+$10
		move.l	#$FEC0FC90,$914000+$20*$1F+$14
		move.l	#$F860FD00,$914000+$20*$1F+$18
		move.l	#$FFFFFA80,$914000+$20*$1F+$1c	
		bra		_no_dr		
*______________________________________随机_________________________________________		
_suiji		
		clr.l	D0						;清个零吧	
		jsr		$119c
		add.b	$ff84eA,D0				;复制随机数给D0
		rts
		
		
*===========================================小兵死后一些内存数据清零===========================================	
		org		$492e				;小兵死后一些内存数据清零
		nop
		jsr		$1fe000
		org		$1fe000		
		move.b  D0, ($87,A6)		;其他的
		move.b  D0, ($96,A6)		;其他的		
		clr.w    ($D6,A6) 			;色板号位		
		rts
				

*===========================================NOP掉一些自带的强制色板===========================================			
		org		$655ba				;tyrog2
		dc.w	$4e71,$4e71,$4e71
		org		$655ca				;tyrog2
		dc.w	$4e71,$4e71,$4e71		
		org		$655e0				;tyrog2
		dc.w	$4e71,$4e71,$4e71
		
		
		;-----------------------------------0d以下不用强制色板------------------------------------------
		org		$014516	
		nop
		jmp		$1fe020
		org		$1fe020	
		
		move.w  (A1)+, D2			;把A1提前，反正都得走这一步
		move.w  (A1)+, D3			;因为要提前判断D5是否小于D
		cmpi.b	#$d,D3				;是否小于D
		blt		_0144D2				;小于D不用强制色板
_014516JX		
		move.b  ($23,A0), D0
_01451e
		JMP		$01451e				;继续	
_0144D2	
		; cmpi.w	#$b4,($20,A0)		;不是老头的回到强制色板
		; BNE		_014516JX			;不是老头的回到强制色板
		JMP		$0144D2				;跳到非强制
	
		
		
		
		
; *___________________________________插入动态色板程序的地方____________________________________________	
	; ; ;-----------------------大龙-----------------------------------
		; org		$63900
		; jsr		$1d0000
		; org		$1d0000
		; ; move.b  ($23,A0), ($23,A6)
		; jsr		_dtsb
		; rts




	; ;------------------------左---------------------------------
	
		; org		$144D0			
		; jsr		$1f3000
		; org		$1f3000
		
		; move.w  (A1)+, D3
		; jsr		_dtsb
		
		; move.w  (A2)+, D0
		; add.w   D4, D0
		; rts
		
	; ;------------------------右---------------------------------
	
		; org		$014576
			
		; jsr		$1f3100
		; org		$1f3100
		
		; move.w  (A1)+, D3
		; jsr		_dtsb
		
		; bchg    #$5, D3
		; rts		
	; ;------------------------抓？？？---------------------------------
	
		; org		$1427A
			
		; jsr		$1f3180
		; org		$1f3180
		
		
		; move.w  (A1)+, D6
		; subq.w  #1, D6

		; move.w  (A1)+, D3
		; jsr		_dtsb
		
		; rts			

	; ;------------------------抓？？？---------------------------------
	
		; org		$142B0
			
		; jsr		$1f3200
		; org		$1f3200
		
		
		; move.w  (A1)+, D6
		; subq.w  #1, D6

		; move.w  (A1)+, D3
		; jsr		_dtsb
		
		; rts	


	; ;------------------------？？？---------------------------------
	
		; org		$1468e
			
		; jsr		$1f3300
		; org		$1f3300
		
		
		; move.w  (A1)+, D2
		; move.w  (A1)+, D3
		; jsr		_dtsb
		; move.w  (A2)+, D0


		
		; rts	

	; ;------------------------？？？---------------------------------
	
		; org		$014518

			
		; jsr		$1f3380
		; org		$1f3380
		
		
		; move.w  (A1)+, D3
		; jsr		_dtsb
		; move.b  ($23,A0), D0
		
		; rts	

	; ;------------------------？？？---------------------------------
	
		; org		$0145D4
	
		; jsr		$1f3400
		; org		$1f3400
		
		
		; move.w  (A1)+, D3
		; jsr		_dtsb
		; move.b  ($23,A0), D0
		
		; rts	


	; ;------------------------？？？---------------------------------
	
		; org		$0146D8
	
		; jsr		$1f3480
		; org		$1f3480
		
		
		; move.w  (A1)+, D3
		; jsr		_dtsb
		; move.b  ($23,A0), D0
		
		; rts			
		
	; ;------------------------？？？---------------------------------	
		; org		$14736
	
		; jsr		$1f3500
		; org		$1f3500

		; move.w  (A1)+, D3
		; jsr		_dtsb
		; bchg    #$5, D3

		; rts			
	; ;------------------------？？？---------------------------------
	
		; org		$14794
	
		; jsr		$1f3580
		; org		$1f3580
		
		
		; move.w  (A1)+, D3
		; jsr		_dtsb
		; move.b  ($23,A0), D0
		
		; rts						
		
	; ;------------------------？？？---------------------------------	
		; org		$14892
	
		; jsr		$1f3600
		; org		$1f3600

		; move.w  (A1)+, D3
		; jsr		_dtsb
		; bchg    #$5, D3

		; rts		
		
	; ;------------------------？？？---------------------------------
	
		; org		$1494E
	
		; jsr		$1f3680
		; org		$1f3680
		
		
		; move.w  (A1)+, D3
		; jsr		_dtsb
		; move.b  ($23,A0), D0
		
		; rts		




		

		
		
	;------------------------水中倒影？---------------------------------
	
		; org		$14bee
			
		; jsr		$1f3280
		; org		$1f3280
		
		
		; move.w  (A2)+, D3
		; jsr		_dtsb
		; move.w  D4, D0
		; add.w   (A2)+, D0


		
		; rts			
		
		
		
		
		
		
		
		; org		$063F3A
		; nop
		; nop
		; nop
		; org		$0637C8

		; nop
		; nop
		; nop
		; org		$063CBE

		; nop
		; nop
		; nop

