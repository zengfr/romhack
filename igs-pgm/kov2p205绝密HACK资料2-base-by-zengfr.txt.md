~~~
--------------------------------------------------------------------
Roms Contain the Following Data

Pxxxx – 68000 program
Txxxx – Text and background graphics (2 formats within the same rom)
Mxxxx – Audio samples (8 bit mono signed PCM at 11025Hz)
Axxxx – Sprite graphics data
Bxxxx – A Offsets and Sprite masks

There is no rom for the Z80, the program is uploaded by the 68000

68000 Memory Map

0x000000 0x01FFFF BIOS ROM (Read-Only)
0x100000 0x5FFFFF Game ROM (Read-Only)
0x700006 0x700007 Watchdog?
0x800000 0x81FFFF Main Ram (Read/Write)
0x900000 0x903FFF Background layer (Read/Write)
0x904000 0x905FFF Text layer (Read/Write)
0x907000 0x9077FF Row scroll ram (Read/Write)
0xA00000 0xA011FF Palette ram (Read/Write)
0xB00000 0xB0FFFF Video Regs inc. Zoom Table (Read/Write)
0xC00002 0xC00003 Sound latch 1 (Read/Write)
0xC00004 0xC00005 Sound latch 2 (Read/Write)
0xC00006 0xC00007 Calander (Read/Write)
0xC00008 0xC00009 Z80 Reset (Write)
0xC0000A 0xC0000B Z80 Control (Write)
0xC0000C 0xC0000D Sound latch 3 (Read/Write)
0xC08000 0xC08001 Player 1 and 2 controls (Read)
0xC08002 0xC08003 Player 3 and 4 controls (Read)
0xC08004 0xC08005 Extra controls (Read)
0xC08006 0xC08007 Dip switches (Read)
0xC10000 0xC1FFFF Z80 program ram (Read/Write)
-------------------------------------------------------
<cheat desc="援军不退" default="0">
		<option desc="关闭"/>
		<option desc="PL1">
			<parameter cpu="0" address="0x815B0E" value="0x09"/>
			<parameter cpu="0" address="0x815B11" value="0x50"/>
			<parameter cpu="0" address="0xD0920A" value="0xEE"/>
			<parameter cpu="0" address="0xD0920B" value="0x05"/>
		</option>
		<option desc="PL2">
			<parameter cpu="0" address="0x815B8F" value="0x09"/>
			<parameter cpu="0" address="0x815B92" value="0x50"/>
			<parameter cpu="0" address="0xD0960A" value="0xEE"/>
			<parameter cpu="0" address="0xD0960B" value="0x05"/>
		</option>
<cheat desc="P1 Invincibility">
    <script state="run">
      <action>maincpu.pw@D090D2=0003</action>
      <action>maincpu.pw@D090F1=D0B0</action>
      <action>maincpu.pw@D091E2=0001</action>
    </script>
  </cheat>
   <cheat desc="Works in N,R,C modes"/>
  <cheat desc="Enable before inserting coins"/>
  <cheat desc="Unlock secret characters">
    <script state="run">
      <action>maincpu.pb@8139F4=12</action>
    </script>
  </cheat>
  <cheat desc="Unlock Secret Characters">
		<script state="on">
			<action>temp0 =maincpu.mw@14349A</action>
			<action>temp1 =maincpu.mw@1434F4</action>
			<action>temp2 =maincpu.mw@14350C</action>
		</script>
		<script state="run">
			<action>maincpu.mw@14349A=0002</action>
			<action>maincpu.mw@1434F4=0002</action>
			<action>maincpu.mw@14350C=0002</action>
		</script>
		<script state="off">
			<action>maincpu.mw@14349A=temp0 </action>
			<action>maincpu.mw@1434F4=temp1 </action>
			<action>maincpu.mw@14350C=temp2 </action>
		</script>
	</cheat>
-------------------------------------------------------
maincpu.pb@813B16=64  Infinite Stage Time
-------------------------------------------------------
C08000;Input Ports  
D00138 ;区域 
817FCC ;模式选择
8139F4 ;选人画面人数
813AD0 ;选关
813AD3 ;选择场景
8114d4 ;第一件道具 id=12-7b
813b16 ;-1
814028 ;+1
816dfa ;80f8e0
-------------------------------------------------------
D0706C ;敌将生命值
D0728C D091A0;降将威力增强
814018 4800906d;1p 角色无限气
81441e 4800946D;2p 角色无限气
811534 =08;拥有8项道具 PL1
8114D5 id ;选择道具1 PL1
8114D6 =09;道具1无限 PL1
8114Da =09;道具2无限 PL1
-------------------------------------------------------
28 真吕布援军ID

2A 281036 ;孟优?大象
2d 27ecea ;孟优
30 403E3A
3A 417FBC
3B 41B52E
-------------------------------------------------------
d02000-d07000 0x100 ;道具释放效果等 bp 15fb8c;FUN_0015fc6e写内存
d07000-d08c00 0x400 ;敌兵
d09000-d09c00 0x400 ;1234p ;我方
D0A000 ; 屏幕版邊左坐標點
D0A002 ; 屏幕版邊上坐標點
(0x50,A2)    ;敌兵(0x50,A2)=7,8,a,b时有特殊逻辑,不等于时可死
$f4(a2) ; id;敵將編號
$f6(a2) ; id
$0c(a2) ; 02为我方
$20(a2) ; X軸
$22(a2) ; Y軸
$24(a2) ; Z軸
$C8(a2) ; 角色朝向
$48(a0)         ; 動作指針
$4C(a0)         ; 被擊指針
$50(a2)      ; D09X50 角色動作類目;
$52(a2)      ; 角色動作編號 D09X52
$54(a2) ;受擊者指针
w@6c Energy
b@131 跳起
$6E(a2)    ; 所持武器
l@$64(a2)    ; 我方色盘存放
$80(a2) ; 攻擊者OBJ
$BE(a4) ;
$DC(a2) ;
$58(a4) ;
$10C(a3.) ; 武器
$114(a2)    ; 是否有攻擊對象
$1B4(a3.)   ; 是否屬性攻擊
$1A0(a3.)   ; 累計 Hits
$174(a2) ;无敌 zfr
$1Cb(a3.) ; 当前道具
$244(a2)     ; 屬性攻擊
$A(a3)       ; 分數值
$264(a3)     ; 擊殺敵將數
$262(a3)     ; 擊殺敵人數目
$26C(a3)     ; 當前角色擊殺的敵將數目
$2E0(a3)     ; 經驗值
d@f8 角色基
cmpi.w  #$2, ($50,A2)	; 是否02類動作
cmpi.w  #$2, ($50,A2) ;是否立地狀態
cmpi.w  #$8, ($50,A2) ;是否浮空狀態
$2B(a2)			      ; 勛章
move.w  #1,$A2(a2)	  ; 地圖無邊界
move.b	($6,A1), D0					; 當前生命值上限
movea.l	($10,A1), A2				; 當前角色OBJ
move.w	($6C,A2), D0				; 當前生命值
move.l	($10,A7), D2				; 需要判斷的敵將編號
movea.l $54(A2),A2					; A2=當前敵方的代碼
btst    #$3, ($244,A0)				; 火屬性
btst    #$7, ($244,A0)				; 暈
btst    #$3, ($244,A0)				; 火
btst    #$1, ($244,A0)				; 毒
clr.w   ($238,A2)					; 清除中毒配色
btst    #7,$244(a2)					; 是否暈眩
bclr    #7,$244(a2)					; 清除暈眩狀態
cmpi.w	#$48,$208(a4)				; 判斷士氣是否已滿
addi.l  #$904000, D0                ; 計算第一士氣段地址
$81A1BB ; 玩家數量
movea.l $801008.l, A2			; 牛金objbase
movea.l $81ABDE.l, A3			; 司馬懿objbase
cmpi.b	#$2, $81ABC2.l			; 是否江夏路線
cmpi.b	#$2, $81AC7F.l			; 是否曹魏路線
move.b  #$95,$81833E.l			; 曹操游戲時間150秒
movea.l	$81b600.l, a2			; 甘寧objbase
movea.l ($1ec,A2), A3			; 擊殺甘寧的對象
move.w  $d0a000.l, D0			; 傳遞當前的卷軸坐標
cmpi.b	#$1, $81AC7F.l			; 是否孫吳路線
move.w	($10c,A2), $801036.l	; 記錄當前角色所持武器
clr.w	($be,A2)				; 取消換將狀態
171e34 被打
bp 10fc66 敌方出場;出兵
bp 10fc5c 敌兵血
bp 10fce6 敌兵id
bp 1158c4 敌兵被打
-----------------------------------------------------
敌兵被减血击杀相关函数
v204			v205
FUN_001198fc	
FUN_00110be2	
FUN_00171016	FUN_00171042
FUN_00171d52	FUN_00171d7e
FUN_00171de4	FUN_00171e10
FUN_00170e8e	FUN_00170eba
-----------------------------------------------------
maincpu.pw@D0906C=0080  P1 Infinite Energy
maincpu.pw@D09286=0006  P1 Maximum Power
maincpu.pd@8F1514=param P1 Select Armour

maincpu.pw@8F14D4=param P1 Select 1st Item
maincpu.pb@8F14D6=09    P1 Infinite Items
maincpu.pb@8F14DA=09
maincpu.pb@8F14DE=09
maincpu.pb@8F14E2=09
maincpu.pb@8F14E6=09
maincpu.pb@8F14EA=09
maincpu.pb@8F14EE=09
maincpu.pb@8F14F2=09
-----------------------------------------------------
maincpu.pw@D0946C=0080  P2 Infinite Energy
maincpu.pd@8F1642=param P2 Select Armour

maincpu.pw@8F1602=param P2 Select 1st Item
maincpu.pb@8F1604=09
maincpu.pb@8F1608=09
maincpu.pb@8F160C=09
maincpu.pb@8F1610=09
maincpu.pb@8F1614=09
maincpu.pb@8F1618=09
maincpu.pb@8F161C=09
maincpu.pb@8F1620=09
----------------------------------------------------
[全部防具]
青铜甲(+10%,盗)69
锁子甲(+12%,火)6A
明光铠甲(+14%,火)6B
蛮尤战甲(+12%,乱,木)6C
秦皇宝甲(+15%,冰)6D
霸王战甲(+14%,)6E
蛮王藤甲(+20%,电,冰)6F
鹤羽宝衣(+15%,晕,爆)70
鱼鳞宝衣(+15%,乱,木)71
于吉仙衣(+14%,火，晕)72
太平道袍(+9%,毒)73
天师道袍(+12%,电,爆,盗)74
张鲁战袍(+17%,火,毒)75
踏云天衣(+9%,电,三段跳跃)76
反刃甲(+9%,反射伤害)77
重甲金锁(+100%,电,火,毒)78
金丝战袍(+6%,出招硬汉)79
风神袍(+7%,行动加速)7A
黄袍(+4%,气增加7B

[全部道具]
★★★★投掷道具★★★★=
金珠=2A
燃烧弹=2B
烟雾弹=2C
铁莲花=2D
★★★★特殊道具★★★★=
七星灯=1F
威灵仙=1C
薤叶芸香=1E
神龙古水=1B
流马=20
木牛=21
民兵策=18
水兵策=23
刀兵策=27
连环火车阵=24
道家秘本=28
道家法典=29
孙子兵法=25
吴子兵法=26
青龙神器=12
白虎神器=13
朱雀神器=14
玄武神器=15
★★★★援军令★★★★=
程昱=2E
夏侯渊=2F
夏侯惇=30
徐晃=31
许诸=32
张郃=33
牛金=34
甘宁=35
周泰=36
吕布=37
曹操=38
曹仁=3A
虎符=39
令旗=3B
★★★★武器★★★★=
青龙偃月刀(+12%)=3E
凤翔烈阳刀(+28%,火)=59
丈八蛇矛(+12%)=41
红缨梨花枪(+18%)=43
方天画戟(+45%)=3F
真·方天画戟(+14%,火)=5C
毒龙铁胎弓(+12%,毒)=45
祝融神火弓(+37%,火)=46
猛虎劈山弓(+100%,爆)=47
天火双煞弓(+28%,火,电)=5D
倚天剑(+25%)=49
青釭剑(+50%)=4A
玄铁鸳鸯简(+10%,晕)=4B
五火神焰扇(+50%,火)=4C
天罡劈水扇(+28%,冰)=4D
巫羽(+42%,爆)=61
赤锋(+20%,电)=62
血匕首(+18%)=4F
飞天虎爪(+32%)=50
吴钩(+25%)=52
巫刀(+20%)=53
盘龙三节棍(-18%)=55
------------------------------------------------------
ROM_START( kov2p )
	ROM_REGION( 0x600000, "maincpu", 0 ) /* 68000 Code */
	PGM_68K_BIOS
	ROM_LOAD16_WORD_SWAP( "v205_32m.u8",    0x100000, 0x400000, CRC(3a2cc0de) SHA1(d7511478b34bfb03b2fb5b8268b60502d05b9414) ) // 04/25/02 17:48:27 M205XX

	ROM_REGION( 0x4000, "prot", 0 ) /* ARM protection ASIC - internal rom */
	ROM_LOAD( "kov2p_igs027a_china.bin", 0x000000, 0x04000, CRC(19a0bd95) SHA1(83e9f22512832a51d41c588debe8be7adb3b1df7) )

	ROM_REGION32_LE( 0x400000, "user1", 0 ) /* Protection Data (encrypted external ARM data) */
	ROM_LOAD( "v200_16m.u23",   0x000000, 0x200000,  CRC(16a0c11f) SHA1(ce449cef76ebd5657d49b57951e2eb0f132e203e) )

	ROM_REGION( 0xa00000, "tiles", 0 ) /* 8x8 Text Tiles + 32x32 BG Tiles */
	PGM_VIDEO_BIOS
	ROM_LOAD( "pgm_t1200.u21",  0x180000, 0x800000, CRC(d7e26609) SHA1(bdad810f82fcf1d50a8791bdc495374ec5a309c6) )

	ROM_REGION16_LE( 0x4000000, "sprcol", 0 ) /* Sprite Colour Data */
	ROM_LOAD( "pgm_a1200.u1",   0x0000000, 0x0800000, CRC(ceeb81d8) SHA1(5476729443fc1bc9593ae10fbf7cbc5d7290b017) )
	ROM_LOAD( "pgm_a1201.u4",   0x0800000, 0x0800000, CRC(21063ca7) SHA1(cf561b44902425a920d5cbea5bf65dd9530b2289) )
	ROM_LOAD( "pgm_a1202.u6",   0x1000000, 0x0800000, CRC(4bb92fae) SHA1(f0b6d72ed425de1c69dc8f8d5795ea760a4a59b0) )
	ROM_LOAD( "pgm_a1203.u8",   0x1800000, 0x0800000, CRC(e73cb627) SHA1(4c6e48b845a5d1e8f9899010fbf273d54c2b8899) )
	ROM_LOAD( "pgm_a1204.u10",  0x2000000, 0x0200000, CRC(14b4b5bb) SHA1(d7db5740eec971f2782fb2885ee3af8f2a796550) )

	ROM_REGION16_LE( 0x1000000, "sprmask", 0 ) /* Sprite Masks + Colour Indexes */
	ROM_LOAD( "pgm_b1200.u5",   0x0000000, 0x0800000,  CRC(bed7d994) SHA1(019dfba8154256d64cd249eb0fa4c451edce34b8) )
	ROM_LOAD( "pgm_b1201.u7",   0x0800000, 0x0800000,  CRC(f251eb57) SHA1(56a5fc14ab7822f83379cecb26638e5bb266349a) )

	ROM_REGION( 0x1000000, "ics", 0 ) /* Samples - (8 bit mono 11025Hz) - */
	PGM_AUDIO_BIOS
	ROM_LOAD( "pgm_m1200.u3",   0x800000, 0x800000, CRC(b0d88720) SHA1(44ab137e3f8e15b7cb5697ffbd9b1143d8210c4f) )
ROM_END
