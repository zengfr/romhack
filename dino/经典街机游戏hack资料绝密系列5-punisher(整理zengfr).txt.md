~~~
---------------------------------------------------------------------------------------------------------------------
d6760-d67da 00
f9e80-fa05f 01
fa0b0-fa110 02 不要
fa0d0-fa192 021
f85e0-f89d8 03 大片空白不能写 f926a fb276 fb3ea
fad80-fb118 03
fbc20-fbdca 03
f95e0-f9a7c 04
fa740-fa7be 05
f8d80-f8ddf 06
f8e00-f924e 07

08CBBA: jmp     (A0)
8CBD000
bp 1723e,1,{pb@(a6+2)=01;pw@(a6+5c)=01;pw@(a6+ee)=04;pd@(a5-2424)=0xFF5BE4;d0=pw@(a5-244c);g}
bp 172fa,1,{pb@(ff8e68+2)=00;g}
bp 17302,1,{pb@(ff8e68+2)=01;g}
--
惩罚者
@FF18AB=BF Infinite Time 
@FF5D96=01 Always have Gun drawn
@01ADEE=60 Sticky Weapons
@FF5FA1=FF Finish this Level Now
@FF5BB9=0x06 Select Starting Stage  bp 7e7a (-2447,a5) 
Hit Anywhere:@0905C2=4E71@09135C=4E71@092FC4=4E71@0939AE=4E71
One Hit Kills:@096B4E=6000@02C1D0=6002@05C158=6000@0913FE=446C@095FF2=446C@093A24=446C
@FF5FA1 :Kill all Enemies now
FF5784:00000000:skip stage clear bonus screen
FF5ACF:0000000C:clear this scene now
FF0408 难度 ff5b51    ff0306+11
FF0407 默认投币数 ff5b55 ff0306+c
 	     
@FF5BA4=03 P1 Infinite Lives
@FF5BCA=09 P1 Infinite Bombs
@FF8E9F=88 P1 Infinite Energy
@FF8EB5=F0 P1 Invincibility ;F0 Alternate Color;F1 Original Color;
@FF8ECE)+FF0037)=FE P1 Infinite Weapon on Pickup

@FF5BA5=03 P2 Infinite Lives
@FF5BCB=09 P2 Infinite Bombs
@FF8F9F=88 P2 Infinite Energy
@FF8FB5=F0 P2 Invincibility
@FF8FCE)+FF0037)=FE P2 Infinite Weapon on Pickup
@FF5BF6:00 Special Ending;01 Normal Ending;
Play Hidden Bonus Stage:FF769B=0 FF769F=0;
@FF8E6E Palette PL1;@FF8F6E Palette PL2
<cheat desc="Palette PL1">
    <parameter>
	  <item value="0x80">Punisher</item>
	  <item value="0x81">Nick Fury</item>
	  <item value="0x82">Blue+Orange</item>
	  <item value="0x83">Green+Brown</item>
	  <item value="0x84">Invincible Color</item>
	  <item value="0x85">Black+Gray</item>
	  <item value="0x86">White+Red</item>
	  <item value="0x87">Cream+Blue</item>
	  <item value="0x88">Pink+White</item>
	  <item value="0x89">Brown+Green</item>
	  <item value="0x92">Red+Alabaster</item>
	  <item value="0x96">Gray</item>
	</parameter>
    <script state="run">
      <action>maincpu.pb@FF8E6E=param</action>
    </script>
  </cheat>
--------------------- 
惩罚者(日版)快速前冲加速加长
21cb6 03 80->1f 80
21cd6 fc 80->e0 80

a8de8 00 04->00 1f
a8db4 ff fc->ff e0
--------------------   
186ea 92e8c 26806 26836 脚刀
--------------------  
108C30 109C10 109AF6 109C10 act:fa/2拳a4/2保险da/2翻滚64/2冲踢
C573A  c5568 1boss真
c5c6a  c5a98 1boss假
132da4 133082 忍者
11c938 11ca9c 
120b8a 120be2 4boss act:05拳08保险11放炮0a收炮

maincpu.mw@20826=C
maincpu.mw@20828=573a
maincpu.mw@20210=C
maincpu.mw@20212=573a
maincpu.mw@6bdfc=C
maincpu.mw@6bdfe=573a
bp 116c,1,{printf "\r\n%8x %8x %4x %4x %4x %4x",a6,a0,d0,maincpu.pw@(a6+2),maincpu.pw@(a6+c),maincpu.pw@(a6+e);go;}
bp 1172,a6==ffff8e68,{logerror "%8x %8x %4x %4x \r\n",a6,a0,d0,maincpu.pw@(a6+2);go;}
wp ffafe8+16,4,rw,1,{printf "%8x %8x %8x ",wpaddr,wpdata,pc;go;}
--------------------
数字精灵1-0:49f2/49be/4ccc-e/4f2e\4f3e\4f4e\4f4d\4faa
90a790 显存 分数(181,a1),(201,a1)
90c000
918000
90d86a 第1个金袋
9040e0 第1个椅子 bp 1533a写obj显存

ff8e68 1P基址 ff8f68 2p基址 内存0x100大小
ffb3a8 第1个敌兵 内存0x0c0大小
ffbe28 第1个椅子0301
ffc968 第1个金袋
ff8f28 1p按键 ($52,A6)
bp 18fc  捡东西
bp 19e4  捡起武器
bp 14c94 写900000显存
bp 1533a 加钱数字动画 写精灵显存
bp 1cbfa 动作ID 10-1D156
bp 4506  显示d2分数
bp 9042a 角色减血
bp 95ff2 角色拳攻击力d0 敌兵被打
bp 93054 敌兵被武器砍
bp 2966  敌兵血初始化
bp 9c4f4 读取投币数01显示
bp 963b8 第1敌兵+物品加载填充 a2=17610d,17611f  fff8a8 fffae8 ffbfa8 ffbee8 ffbe28 b2e8
bp 9678a 出兵表COPY to ff0868 move.b  (a2)+,-$7798(a5)
bp 96886 第3敌兵内存加载填充 读取a2=ff0868 
bp 963fc 写场景出兵指针+12 ff7666
bp 9646a 写场景出兵指针+04 ff7666
bp 9647c 写场景出兵指针+04 ff7666
bp 964ea 写场景出兵指针+04 ff7666
bp 965be 写场景出兵指针+06 ff7666
bp 965f0 写场景出兵指针+06 ff7666
bp 96260 写场景出兵指针 第一次 17600c 
bp 9623e 关卡场景加载d0->a0->ff7666
bp 9666c 关卡动态敌兵加载d0->a0->10(a6)=ff76a6
bp 96934 关卡动态敌兵+04加载d0->a0->10(a6)=ff76a6
bp 968cc 关卡动态敌兵+10加载d0->a0->10(a6)=ff76a6
bp 96924 关卡动态敌兵+08加载d0->a0->10(a6)=ff76a6
bp 96944 关卡动态敌兵+04加载d0->a0->10(a6)=ff76a6
bp 96960 关卡动态敌兵+02加载d0->a0->10(a6)=ff76a6
bp 9628E 读 ff7666
bp 96758 读 ff76a6
bp 968cc 读 ff76a6
bp 92fe6 武器斧头使用损耗
bp 2a12  掉物查表 
bp 2d66  掉物写内存
bp 7a1a0 掉物分配实际实物 钢管查的表7aae8
bp 9628a 初始化美女ffbbe8+5;177191;01改成00第二门出美女;zengfr
    org $177190
		dc.b $0100 ;$0001老鼠;$0000粉红女;$0100白领女;$0200白领男;bp 9628a 初始化美女ffbbe8+5;177191;01改成00第二门出美女;zengfr
	org $831a1
		dc.b $7f ;$20;美女亲吻次数+3a;
	org $8342e
		bgt $83442 ;beq $83442;改成6e12都掉食物
	org $83432
		dc.b $20 ;$74;美女亲吻掉物+99;
maincpu.mw@1cc2e=d462 抓人后直接旋转
ff5f96 场景源头;FF18B3也是场景;FF5ACF=0C starts triggering next section;
ff6012 场景
ff4ee1 过场景动画0148.ff4e83?
ff07c6 卷轴
ff07c8 卷轴
ff7376 screen_left 卷轴比较 -$C8A(a5) 源头
ff737a 卷轴比较 -$C86(a5)
ff7396 卷轴
ff7398 卷轴
ff765f 场景加载指针函数索引 a6=7656=(-9aa,a5)
ff7660 场景加载指针类型 +4 +6或 +12 
ff7666 场景加载指针  a6=7656
ff7696  ？(-96a,a5)
ff76a6 动态加载敌兵指针
ff0862  -$779E(a5)
ff0868  -$7798(a5)
ff5fac  时间计数
ff5ffc
ff5bac 分数
ff5bc6 拳击计数
ff5b14 投币数 
ff5b1c start coin键
ff5b20 按键输入
ff5bb2 按键输入
ff5bd0 循环计数
ff5bda 非0不能续币-$2426(a5)

ff5b3d 场景加载比较 -$24C3(a5)
ff5bd7 场景加载比较 -$2429(a5)

ff5b38 场景加载比较 -$24C8(a5)
ff5b40 场景加载比较 -$24c0(a5)
camera_mode = 0xFF5BD3
game_phase  = 0xFF4E81
a4+02  ID
a4+03  出场动作
a4+04  ?
a4+05  ?
a4+07  flip_x 
a4+08  面向0后1前
a4+0c  动作ID
a4+0e  子动作ID
a4+12  .l 精灵指针 bp 14fd4
a4+16  enemies alive
a4+1a  enemies active
a4+96  ?
a4+97  ?
a4+99  掉物 27雷 23鸡腿
a4+9b  ?
a4+24  坐标Y
a4+20  pos_x坐标X来源ff085e
a4+28  pos_z坐标Z来源ff0860
a4+30  hitbox_ptr 
a4+36  血量
a4+34  减血量
a4+3a  第二关美女亲次数0065；bp 831a0;
a4+3c  attack
a4+3e  vulnerability
a4+64  持枪02
a4+66  持物指针
($9c,A6) 惩罚者有个标签，可以直接让BOSS变小兵的，打死不过关等等
f9bxx=f9cxx 大段空白 不能擦除 会异常。
03 功夫男 03飞出
04 铁桶
05 时尚男
07 小兵
08 小兵
09 小兵
00 小刀兵
0a 空
0B 小刀兵
0C 风衣枪兵
0D 风衣枪兵红裤
0E 忍者女蓝色
0F 忍者女绿色
10 空
12 西装男不动
13 机器兵红色
18 2BOSS坦克
1B 绿色西装手枪男
1C 西装男红色不动
1D 红衣大枪兵
1E 紫色西装手枪男 14大笑
1F 忍者女
20 忍者女 红棕色
21 高个绿色
22 高个红棕色
23 驼背斧头兵 00棒锥 08 扔雷兵
24 驼背兵  01 棒槌
25 红短衣枪兵
26 浅绿短衣枪兵
28 喷火器时尚男
29 功夫男
2F 跑步鞋小刀兵
30 喷火器时尚男  
2B 头巾跑步鞋小兵
-------------
掉物:
06小蛋糕 0E大蛋糕 
13戒指分 17枪分 
20最大牛排 
30大斧头 31斧头   33钢管 35断木 37弯刀 
41机枪   42灭火器 43喷火器 
50五星镖 56自爆雷
63喷火器 63螺旋镖 64黄金块 65五星镖 66大蛋糕 
74热狗
---------------------------------------
0002黄金块  
0100最大牛排 0101热狗 0103鸡腿 0104大蛋糕 0107手雷
0201斧头 0202弯刀 0203钢管 0204棒槌 0205断木 
0403铁桶
0503喷火器 0502灭火器 
0600五星镖 0607飞刀 0606自爆雷 0604雨伞镖 0603螺旋镖 
0900猫/14
色板调式:bp 152f0,1,{printf "%8x %8x %8x %8x %8x %8x %8x",frame,pc,a6,a1,a2,d0,d6;g}

wp ff8e68+0c,2,r,wpdata>0,{printf "wpr %8x %8x %8x %8x",frame,pc,wpdddr,wpdata;g}
wp ff8e68+0c,2,w,wpdata>0,{printf "wpw %8x %8x %8x %8x",frame,pc,wpaddr,wpdata;g}
bp 1cbfe,1,{printf "act %8x %8x %8x %8x",frame,pc,d0,a1;g}

bp 96788,1,{logerror "c%2x %2x %8x|%2x %2x %2x|%2x %8x %8x %8x\n",pb@FF5BB9,pb@ff6012,a2,pb@(a2-3),pb@(a2-2),pb@(a2-1),pb@(a2+0x0),pd@(a2+0x1),pd@(a2+0x5),pd@(a2+0x9);g}

bp 963e6,1,{logerror "s%2x %2x %8x|%2x|dc.w $%04x,$%04x,$%04x,$%04x,$%04x,$%02x%02x\n",pb@FF5BB9,pb@ff6012,a2,d1&1f,pw@(a0+0x2),pw@(a0+0x4),pw@(a0+0x20),pw@(a0+0x24),maincpu.pw@(a0+0x28),maincpu.pb@(a0+0x99),maincpu.pb@(a0+0x9b);g}

bp 968b0,1,{logerror "d%2x %2x %8x|%2x|dc.w $%04x,$%04x,$%04x,$%04x,$%04x,$%02x%02x\n",pb@FF5BB9,pb@ff6012,a2,d1&1f,pw@(a0+0x2),pw@(a0+0x4),pw@(a0+0x20),pw@(a0+0x24),maincpu.pw@(a0+0x28),maincpu.pb@(a0+0x99),maincpu.pb@(a0+0x9b);g}

bp f971c,1,{logerror " %8x %2x %2x %2x %8x %8x %8x %8x\n",frame,pb@FF5BB9,pb@ff6012,d1,a0,a2,maincpu.md@(a2),maincpu.md@(a2+0x4);g}
---------------------------------------------------------------------------------------------------------------------