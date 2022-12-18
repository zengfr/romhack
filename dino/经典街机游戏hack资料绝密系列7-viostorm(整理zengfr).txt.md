~~~
---------------------------------------------------------------------------------------------------------------------
暴力风暴
Hit Anywhere  .mw@018C6E=6002 .mw@018C76=6002 .mw@018C7C=6002 mw@018C8C=6002 
200600 F2保存后配置200680->200600
20061f f2音量
200698 F2角色生命数量
200699 F2分数奖命first 00-02-03-05
20069A F2分数奖命every    00-04-06
20069B F2难度 00易-07难
2006A0 F2 LOOP 00 on round end 01 endless
2006A1 F2 Mode 00 lean 01 bloody
15734  F2数据COPY校验
20004b b
20005a b
200082 b
200083 b
2000c1 投币数
200C10 关卡
200C12 无限时间pw@200C12=0959
200C18 b? 
20080a 1p死后续币倒计时
20080C 1p无限生命pb@20080C=0A
200818 游戏状态
20088C 2p无限生命
20090C 3p无限生命
201200 b
201202 b
201242 b
201426 b
201800 =1过关
201802 
20180a b
20180B 角色数量 ;20de8f;
201816 b
201817 b
20181c b
201824 l
201342 w
201344 w
201428 0360;1V3 ;bp 3E16C d0=7;R:3e20e 3e21c;
201422 屏幕敌兵数量
201A00 w
201A10 w
201A14 w
201A30 b
201A33 b
201A58 卷轴 201A00、201A98
20de82-84 选人时间
796e8  文字字符串
78ef0  insert coin bp 2a32/2a9c
13400  角色介绍文字

211010 ID
211012 动作ID
211017 b
21101A 转向00/FF
21101C 动作指针
211020 X  2C 80 8C 坐标相关
211024 Z
211028 Y
21102c X offset
211030 Y offset
211034 Z offset
211059 我方1，敌方2
2110c6 按键 200800
211006 敌兵ID1 查表7CD44
211008 敌兵ID2 执行表指针子程序
2110b4 持物内存地址 6匕首 14钢管 26baa持物 262cc扔掉 1dc8c被打掉地上 1e094被打掉消失 1e2fa被打掉地上

217c00
218c00
300210 场景屏幕左上角显存
300240 分数显示
300D10 场景屏幕左下角显存
300DD0 场景屏幕右下角显存
301ca0 insert coin 显存
300400 1P血槽显存 bp 17848/17860
331000 1P人物显存 bp 9c9c copy 20c000/331000
330000-330C00 场景显存
80400  人物动作列表  0x7722载入
669da  出兵配置表
3df18  $5900卷轴出兵前数据查表 0x201430 0x201434  0x201438/$201A58/$201A98/$201AD8; （3E1A8也有+3E1E6 1V3相关）
58dc-5930 一堆JSR 场景相关
5972-59c2 一堆JSR 敌兵分配相关
217C   3P血条相关 201600 201620 201640
221A   3P    相关 201660 201680 2016A0
9d78/a0ec load Pal_Ptr_Tbl_9B82
9B82  Pal_Ptr_Tbl_9B82 0x330000/0x330400/0x330800/0x330C00/0x331000/0x331400/0x331800
9B9E  Mem_Ptr_9B9E    0x20B000/0x20B400/0x20B800/0x20BC00/0x20C000/0x20C400/0x20C800
443fc 敌兵减血 (过程 bp 19000 45->9f->62)
5d4ce boss减血 1boss d/211a00/331580 2boss e/211900/3317c0
2a1a6 桶子ID21配置表 表格大小0x08;bp 29e40     写内存 212100
2CAE8 打破掉食品     表格大小0x08;2cc30、2cb88 写内存 212d00 
25CCA 桶子打破掉物 钢管 14 查表25d40表格大小0x10
286bc 桶子打破掉钢管01 小刀00 空不走
3E250 桶子掉物控制位$A(a6);查表66ac2;4F 00 01为空桶,EF钢管 bp 286bc分配
26baa 角色捡起钢管
4C03E 内存出小刀06
3e232 $3e2e6分配内存 $3E300 指针具体分配空间起止$05(a0)
3e23a $3e246填充数据  
66ac2 卷轴数据表大小0x0A(66a22-66a2c) 5998->3E194->3E1E6->3E246
  
21101C		保存动作指针	另外一处单独调用，载入BB6A处指针表
21102C 		X OFFSET
211030 		Y OFFSET
211034 		Z OFFSET
21103f
21104f
211048
21104C 		人物ID W:3EDAE;R:3E66C查表求90、3E72A查表求91、40A4A比较13 
211052      小头像及姓名ID	和4C关联
211059		根据ID查表获取属性	52相关，我方1，敌方2。表地址18CD0
211060		HP上限	
211062		HP满值60，23676，初始化HP
21107f      b
211084      l
21108C		X坐标暂存	
211090		Z坐标暂存			
211094 
211098		等于IDX2	IDx2
21109A		动作ID缓存	用于4A等
2110a0      b
2110e9      b
2110EB		被攻击相关	和200182相关
211163      2p HP
211263      3p HP
bp 5D4D0    1boss死4行代码,ori.b  #2,$A0(a0) 关键.
bp 5C93C    1boss这句才会死ori.b  #$80,$E9(a0) ,e9 第0位=1则倒地弹动画=0快速倒地
bp 1aa58   行走E
bp 1aa7e   身体转向5
bp 1d948   行走B

bp 2008C   写角色数量$20180B
bp 16a8c   读取1993 kinami
bp 167ac   写798F0开机自检字符
bp 2b44    字符串查表
bp 3b48    200001每次加一
bp 3E410   分配敌兵内存A0 最高 $211900-$212100
bp 3EDAE   出兵 A5=4E806  ->A0 $211900
bp 3EDE2   过关卡和BOSS前触发 分配 a0 213d00 213e00
bp b524    改d1看动作 如d1=dc b 24 cb cc
bp b2C0    动作指针解析  人物动作列表总指针原版在0x7722
bp 40064,a0==211900,{d0=0x5;g}锁死第一敌兵AI模式
bp 3e24c,a6==211900,{d2=0x2d;}修改敌兵ID

1b1c/1b26->1b32->1ce8->1cfa->1d16 按键
1ECE4->1ECFA->
1ACE8->1AD06->1AD6C->1ADAE->1E800->前冲CB,CC
---------------------------------------------------------------------------------------------------------------
bp 3eda6 出兵

方向	类型	地址	文本
向下	p	ROM:0004A8CA	jsr     sub_3EDA6|
向下	p	ROM:0004C594	jsr     sub_3EDA6|
向下	p	ROM:0004D778	jsr     sub_3EDA6|
向下	p	ROM:0004E4AA	jsr     sub_3EDA6|
向下	p	ROM:00050D54	jsr     sub_3EDA6|
向下	p	ROM:00051D74	jsr     sub_3EDA6|
向下	p	ROM:000543E4	jsr     sub_3EDA6|
向下	p	ROM:00055C7E	jsr     sub_3EDA6|
向下	p	ROM:00056324	jsr     sub_3EDA6|
向下	p	ROM:00056750	jsr     sub_3EDA6|
向下	p	ROM:0005909C	jsr     sub_3EDA6|

方向	类型	地址	文本
向下	p	ROM:0004741E	jsr     sub_3EDE2|
向下	p	ROM:00047748	jsr     sub_3EDE2|
向下	p	ROM:00047936	jsr     sub_3EDE2|
向下	p	ROM:000479D2	jsr     sub_3EDE2|
----------------------------------------------------------------------------------------------------------------
出物品表 bp 29E40

      D87 tb-ljt    29E40    2A14E   212100     21AA     AA4E     FCF2       30
      D91 tb-ljt    29E40    2A14E   212200     21AA     AA4E     FCF2       30
     188D tb-ljt    29E40    2A1A6   212100     21F6     F653     FCF2       30
     18E9 tb-ljt    29E40    2A146   212200     21AA     AA4E     FFFB       30
     197D tb-ljt    29E40    2A19E   212100     21F6     F653     FFFB       30
     2378 tb-ljt    29E40    2A0BE   212100      51C     1D43       F6       20
     2399 tb-ljt    29E40    2A0BE   212300      51C     1D43       F6       20
     277B tb-ljt    29E40    2A0BE   212100      51C     1D43       F6       20
     2919 tb-ljt    29E40    2A0BE   212100      51C     1D43       F6       20
     2AB8 tb-ljt    29E40    2A0BE   212100      51C     1D43       F6       20
     2C13 tb-ljt    29E40    2A116   212100      52D     2E4B       FA     FFFF
     31B1 tb-ljt    29E40    2A19E   212100     21F6     F653     FFFB       30
     3247 tb-ljt    29E40    2A13E   212200     21A3     A34D       F6       38
     363B tb-ljt    29E40    2A20E   212100     2140     405B      4FA        0
     42AF tb-ljt    29E40    2A196   212100     1617     1752       F6        0
     42B2 tb-ljt    29E40    2A1AE   212200     21FB     FB54     FEFA       48
     42B5 tb-ljt    29E40    2A0BE   212300      51C     1D43       F6       20
     4318 tb-ljt    29E40    2A15E   212100     21EF     EF4F       F6       34
     4318 tb-ljt    29E40    2A15E   212200     21EF     EF4F       F6       34
     4318 tb-ljt    29E40    2A15E   212300     21EF     EF4F       F6       34
     45E0 tb-ljt    29E40    2A13E   212100     21A3     A34D       F6       38
     461F tb-ljt    29E40    2A16E   212200     21BC     BC50       F6       40
     463A tb-ljt    29E40    2A16E   212300     21BC     BC50       F6       40
     4652 tb-ljt    29E40    2A136   212400     21A3     A34D     FFFB       38
     4661 tb-ljt    29E40    2A136   212400     21A3     A34D     FFFB       38
     4F76 tb-ljt    29E40    2A13E   212100     21A3     A34D       F6       38
     4F76 tb-ljt    29E40    2A136   212200     21A3     A34D     FFFB       38
     5203 tb-ljt    29E40    2A136   212100     21A3     A34D     FFFB       38
     5209 tb-ljt    29E40    2A136   212400     21A3     A34D     FFFB       38
     5212 tb-ljt    29E40    2A136   212500     21A3     A34D     FFFB       38
     5218 tb-ljt    29E40    2A136   212600     21A3     A34D     FFFB       38
     521C tb-ljt    29E40    2A136   212700     21A3     A34D     FFFB       38
     5229 tb-ljt    29E40    2A136   212800     21A3     A34D     FFFB       38
     523C tb-ljt    29E40    2A136   212900     21A3     A34D     FFFB       38
     52B2 tb-ljt    29E40    2A10E   212200     21B2     B24A       F6       26
     52CC tb-ljt    29E40    2A1B6   212300     21FB     FB54       F6       48
     586C tb-ljt    29E40    2A15E   212200     21EF     EF4F       F6       34
     587C tb-ljt    29E40    2A15E   212100     21EF     EF4F       F6       34
     5979 tb-ljt    29E40    2A13E   212400     21A3     A34D       F6       38
     6344 tb-ljt    29E40    2A13E   212100     21A3     A34D       F6       38
     6375 tb-ljt    29E40    2A0F6   212200     21B1     B14A     FEFA       26
----------------------------------------------------------------------------------------------------------------
地址	        Function	指令
ROM:0000D344				move.w  (a6)+,$10(a0); 
ROM:00025CEC	sub_25CCA	move.w  (a6)+,$10(a0); 
ROM:00027810				move.w  (a6)+,$10(a0); 
ROM:00029CEC				move.w  (a6)+,$10(a0); 
ROM:0002A62C				move.w  (a6)+,$10(a0); 
ROM:0002ADE2				move.w  (a6)+,$10(a0); 
ROM:0002CAE8				move.w  (a6)+,$10(a0); 2cb88 202d00 d0=58 id=21/d0=108 2c38 id=21/2cc30
ROM:0002DA40				move.w  (a6)+,$10(a0); 
ROM:0002DF9A				move.w  (a6)+,$10(a0); 
ROM:0003225E				move.w  (a6)+,$10(a0); 
----------------------------------------------------------------------------------------------------------------

 hackrom 13:29:27
先说一下动作定义。每个人物0X100个，这个需要重新MAP我是给你说过的吧，所以你需要一个EXCEL来记录每个人物的动作列表。方便你后续进行替换和进度记录。

人物动作列表总指针原版在0x7722开始。ID排序如下

 hackrom 13:29:57
Role_Script_Tbl:	
		.long 0xB6F9E		| 嬉皮士
		.long 0xB739E		| 刀子女
		.long 0xB779E		| WADE
		.long 0xB7B9E		| 铁链男
		.long 0xB7F9E		| 判定框，定位器
		.long 0xB839E		| 破门
		.long 0xB859E		| 小刀
		.long 0xB879E		| 红色小块
		.long 0xBF11E		| 最终BOSS
		.long 0xB899E		| 斗篷小兵
		.long 0xB8D9E		| 长条。。
		.long 0xB909E		| 二关BOSS场景
		.long 0xB939E		| 非主流
		.long 0xB979E		| 红发嬉皮士
		.long 0xB9B9E		| 大木箱
		.long Script_Role_Dabel	| 第一关猪头无面具
		.long 0xBA19E		| 面具
		.long 0xBA59E		| 油桶
		.long 0xBA79E		| 小块
		.long 0xBAB9E		| 龙拳
		.long 0xBAF9E		| 钢管
		.long 0xBB19E		| 椅子
		.long 0xBB39E		| 带电物件
		.long 0xBB49E		| BORIS
		.long 0xBB89E		| 铁甲男
		.long 0xBBC9E		| 影子
		.long 0xBBD1E		| 橄榄球
		.long 0xBE61E		| 龙拳部分块
		.long 0xBBF1E		| KYLE
		.long 0xBC31E		| 肌肉男
		.long 0xBED1E		| 机械男
		.long 0xBC71E		| 炸弹男
		.long 0xBCB1E		| 死胖子
		.long 0xBCF1E		| 火烧状态
		.long 0xBD31E		| 野蛮人
		.long 0xBD71E		| 花盆
		.long 0xBD91E		| 普通猪头男
		.long 0xBDD1E		| 驼背剪刀手
		.long 0xBE11E		| 剪刀手带刀状态
		.long 0xBE51E		| 摩托车
		.long 0xBE61E		| 龙拳部分块2
		.long 0xBE71E		| 神龟
		.long 0xBEB1E		| 食品道具
		.long 0xBED1E		| 机械男
		.long 0

 hackrom 13:30:27
其中有的地址是名字，就是我修改过的，所以你还是要以原ROM的地址为准

 hackrom 13:31:19
以野蛮人为例，看一下他的动作指针，BD31E，到这个地址看一下，后面的256*4字节，刚好0X100个动作。

 hackrom 13:31:58
这个动作，你目前就只需要了解到指针层面就行了。替换也只替换指针。后续没有的动作，我把动作脚本导出来再修改添加。

wp 200800,2,r,0&&wpdata>0,{logerror "\n %8x act  r %8x %8x %4x",frame,pc,wpaddr,wpdata;g}

wp 200800,2,w,0&&wpdata>0,{logerror "\n %8x act  w %8x %8x %4x",frame,pc,wpaddr,wpdata;g}
wp 200800,2,r,0&&wpdata==29 or wpdata==2A,{logerror "\n %8x act  r %8x %8x %4x",frame,pc,wpaddr,wpdata;g}

wp 2110c6,2,r,0&&wpdata>0,{logerror "\n %8x anj  r %8x %8x %4x",frame,pc,wpaddr,wpdata;g}

wp 20080C,1,w,wpdata>0,{logerror "\n %8x live w %8x %8x %4x",frame,pc,wpaddr,wpdata;g}
wp 211063,1,w,wpdata>0,{logerror "\n %8x xue  w %8x %8x %4x",frame,pc,wpaddr,wpdata;g}

wp 211012,2,w,wpdata>0,{logerror "\n %8x 1pAct w %8x %8x %4x %4x",frame,pc,wpaddr,maincpu.pw@211010,wpdata;g}
wp 211012,2,r,0&&wpdata>0,{logerror "\n %8x 1pAct r %8x %8x %4x %4x",frame,pc,wpaddr,maincpu.pw@211010,wpdata;g}

wp 211912,2,w,wpdata>0,{logerror "\n %8x dbAct w %8x %8x %4x %4x",frame,pc,wpaddr,maincpu.pw@211910,wpdata;g}
wp 211912,2,r,0&&wpdata>0,{logerror "\n %8x dbAct r %8x %8x %4x %4x",frame,pc,wpaddr,maincpu.pw@211910,wpdata;g}

wp 211000,100,w,0&&wpdata>0 and wpaddr!=211020 and wpaddr!=211028 and wpaddr!=211059 and wpaddr!=211094 and wpaddr!=2110a3 and wpaddr!=211017  and wpaddr!=2110e6  and wpaddr!=211000  and wpaddr!=2110ac  and wpaddr!=21103f,{logerror "\n %8x 1p  w %8x %8x %4x",frame,pc,wpaddr,wpdata;g}