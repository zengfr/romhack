~~~
kof97-hackdata绝密HACK资料2-by-zengfr整理
--------------------------------------------------------------------------------------
wp 300000,1,r,wpdata!=ff,{printf "r %8x %8x  %1x",wpaddr,pc,wpdata;g}
wp 300000,1,w,wpdata!=ff,{printf "w %8x %8x  %1x",wpaddr,pc,wpdata;g}
wp 10da44,1,r,wpdata!=0,{printf "r %8x %8x %1x %4x %4x",wpaddr,pc,wpdata,pw@0x108170,pw@0x108172;g}
wp 10da44,1,w,wpdata!=0,{printf "w %8x %8x %1x",wpaddr,pc,wpdata;g}
wp 108172,2,w,wpdata!=0,{printf "w %8x %8x %2x",wpaddr,pc,wpdata;g}
-----------------------------------------------------
0-100 文件开始是vector 终端向量表
https://wiki.neogeodev.org/index.php?title=68k_vector_table

大部分以C00402 是指向bios rom；NeoGeo提供的公共接口
64~255 000100~0003FF User interrupt vectors
64 这个

100-68k Program Header 逆向分析起点
https://wiki.neogeodev.org/index.php?title=68k_program_header

100 = “NEO GEO”
10E = 0010 0000 dipswitch
122 = 函数地址UserSubroutineCodeStart 用户子程序入口主要
128 = PlayerStartSubroutine
12E = DemoEndSubroutine
134 = CoinSound
-----------------------------------------------------------------------------------------
0x9C38 主循环的入口
0x9C44循环点
0x9C50循环点
0x9EA2中断的地址
0x9D88回到9C44
0x9C5C=0x9F68 UpdateP1P2KeyState 进入输入系统继续分析

I/O 指令输入系统
1、在主循环中通过0x30000和0x340000找到0x9F68
0x9F68 翻译 UpdateP1P2KeyState
0x9F68是从IO的0x300000、0x340000接口读取P1，P2的输入

2、往下找到0x9FC8
5A44 翻译 P1KeyAnd2Frames
5A48 翻译 P1CheckResult
0x9FC8 move.b D1,($5A44,A5) 其中A5=108000；找到108000+5A44=10DA44

0x12914代码是做出招判定的
断下 0x12914可看出a0,a1,a2,a3寄存器的内容：

a0 0xA6E38 ROM地址是一个数组翻译CheckTable
分左检查表，右检查表，不同人物地址不一样

a1 0x10DA48 翻译 CheckResult
是出招结果00A8 2A02
二进制表示00 00 00 00 10 10 10 00 00 10 10 10 00 00 00 00
00 00 00 00 表示0xA6E38 - 0xA6E44的出招
10 10 10 00 表示0xA6E48 - 0xA6E54 其中1是系统用的
00 10 10 10 表示0xA6E58 - 0xA6E64
00 00 00 00 表示0xA6E68 - 0xA6E74

a2 0x10E79C 翻译ACT队列
输入缓存区，来自0x10DA44

a3 0x10DA44
输入存储地址，每一帧从IO的0x300000接口读取输入到WORKRAM区域
P2位置的人物输入
10DA5B a1CheckResult
10e9ea 判断0x10 0x20
3、然后通过0xA6E38地址找到rom里对应的出招表
-----------------------------------------------------------------------------------------
更多参考资料
github:https://github.com/zengfr/romhack

gitee:https://gitee.com/zengfr/romhack

blog:https://my.oschina.net/zengfr

https://github.com/zengfr/arcade_game_romhacking_sourcecode_top_secret_data

https://gitee.com/zengfr/arcade_game_romhacking_sourcecode_top_secret_data

https://github.com/zengfr/arcade-romhacking-framework

video:https://space.bilibili.com/492484080/video
--------------------------------------------------------------------------------------
300000 按键
108100 p1
108300 开始200代表P2人物
10b0b2 开始100大小；表示背景
10b7b2 一共有8层背景
108700 0x40小对象结构；人物的影子，一共3层影子，0x120
10da44 按键
3126 释放内存地址
30b2 分配动态内存 参数：a0自处理 d0 优先级 返回：a1新对象
+139 Energy血量
+1e3 power
+13f 眩晕
+147 防御
+70  id
+72  act
+78  PrevAct
+50   距离 /移动速度  
+58   高度
+1a4 按键
.L+198 载入的程序
.b+ef
.b+108
.+1e4
bp 59b0 位移x
Function_00011090 Function_000111e6 按键cd普通招式判断 act=74 FUN_000139c0
-------------------------------------------------------------------
.B   #0x2,(0x1B8,A4)              //攻击音效
.W   #0x2A00,(0x1DE,A4)           //发招后增加的气
.W   #0x1800,(0x1E0,A4)           //攻击人后增加的气
.B   #0x3,(0x108,A4)              //得分
.B   #0x1E,(0xEF,A4)              //伤血
.L   #0x58000,(0x50,A4)           //距离
.L   #0x38000,(0x58,A4)           //高度
.L   #0x8000,(0x5C,A4)            //重力加速度
.W   #0xEBBB,(0x54,A4)            //使速度放慢的摩擦力
.W   #0xD6,(0xD2,A4)动作，打击动作是D6
.W   (0xD2,A4),(0x72,A4)输出动作
.B   (0x7B,A3),D0              //判断玩家是不是出重拳(40)
.B    (0xD1,A4)     重要，判定玩家是否有后续出招
.W   #0x82,(0xD2,A4) 前冲动作
.W   #0x84,(0xD4,A4) 第一下冲拳动
.W   #0x92,(0xD6,A4) 第二一下冲拳动作
.W   #0x1C,(0x138,A4)//检测血量是否少于
.W   #0x8B,(0xD2,A4)              //起手式
.W   #0x8C,(0xD4,A4)              //肘顶
.W   #0x8D,(0xD6,A4)              //转身
.L   #0x48000,(0xC6,A4)           //最后一下移动距离(8E动作)
.L   #0x50000,(0xCA,A4)           //最后一下跳跃高度(8E动作)
TST.B    (0x1D6,A4)       //表里状态判断
TST.W    (0x1B2,A4)//表里人物判断
BTST     #0x5,(0xE1,A4)//飞行道具判断
BTST     #0x1,(0xE0,A4)//是否空中判断
BTST     #0x0,(0xE4,A4)//是否MAX状态
BTST     #0x5,(0x11D,A4)//检测是否爆气
TST.B    (0x1E3,A4)//检测是否有能量珠
BTST     #0x0,(0x31,A4)           //判断当前方向
BTST #0x4,(0x1A4,A4)           -判定轻出按什么键[4/5/6/7=A/B/C/D]
TST.B    (0x7C,A4)                    |判断动作有没有输出完
BTST     #0x1,(0xE0,A0) 判断敌人是否在空中
JSR      0x18C1C   伤血程序

btst.b     0x1,(A6) 按下
btst.b     0x6,(0x1,A6) 按C
----------------------------------------------------------------------------------------------------------
MOVE.B #0x2,(0x1BA,A4)         //貌似和COUNTER有关，只能是1、2、3中的一个，3以上会花屏
MOVE.W #0x2C1,(0x1BC,A4)       //角色发出的声音
MOVE.W #0x51B,(0x1BE,A4)       //火焰发出的声音
MOVE.B #0xB,(0x1B8,A4)         //命中对手后的音效
MOVE.W #0xC00,(0x1DE,A4)       //空发集气值
JSR 0x10F02                     //集气子程序
MOVE.W #0x600,(0x1E0,A4)       //命中集气值   
MOVE.B #0x5,(0x108,A4)         //轻鬼烧命中得分值
MOVE.B #0x1A,(0xEF,A4)         //轻鬼烧命中杀伤力
MOVE.W #0x68,(0xF6,A4)         //招式被识别或者是区分的代码？
MOVE.W #0x80,(0xD2,A4)         //ACT1
MOVE.W #0x82,(0xD4,A4)         //ACT2
MOVE.W #0x84,(0xD6,A4)         //ACT3
MOVE.W #0xC,(0xD8,A4)          //ACT4？
MOVE.W #0xF5,(0xC2,A4)         //ACT5,火焰
MOVE.W #0xF6,(0xC4,A4)         //ACT6,火焰
OVE.L #0x60000,(0x58,A4)    //跃起高度
BTST #0x4,(0x1A4,A4)          //轻出判断，按键为A
MOVE.B #0x7,(0x108,A4)         //重鬼烧命中得分值
MOVE.B #0x1C,(0xEF,A4)        //重鬼烧第1HIT杀伤力代码
MOVE.W #0x81,(0xD2,A4)        //ACT1
MOVE.W #0x83,(0xD4,A4)         //ACT2
MOVE.W #0x85,(0xD6,A4)         //ACT3
MOVE.W #0x20,(0xD8,A4)         //ACT4？
OVE.L #0x80000,(0x58,A4)    //重鬼烧跃起高度
OVE.L #0x50000,(0x50,A4)    //突进距离
OVE.L #0x6D00,(0x5C,A4)     //下落重力
MOVE.W #0xDAAA,(0x54,A4)       //使前进看起来更为平滑 //使速度放慢的摩擦力
JSR 0x140FE                    //杀伤力子程序
BTST #0x0,(0x31,A4)            //判断面向
BNE *+0x8 [0x2FDCC]          //正面则转到输出D2
NEG.L (0x50,A4)                //是负取反
MOVE.W (0xD2,A4),(0x72,A4)   //输出D2，也就是80，81
MOVE.W #0xFFFF,(0x78,A4)      //固定格式，可NOP
JSR 0x584C                     //固定格式
MOVE.L #0x2FDE4,(A4)           //接下一地址
TST.B (0x7C,A4)                //招式如果没有完毕则继续输出
BPL *-0x20E [0x2FBDA]        //KYO:2FBDA，各人物不同，但貌似通用
BTST #0x4,(0x1A4,A4)           //判断按键是否为A
BEQ *+0x10 [0x2FE02]         //如果不是则跳过第2HIT杀伤力，继续输出D4
MOVE.B #0x1B,(0xEF,A4)         //重鬼烧第2HIT的杀伤力代码
JSR 0x140FE                    //杀伤力子程序
MOVE.W (0xD4,A4),(0x72,A4)   //输出D4，也就是82，83
MOVE.B #0x1,(0x1E4,A4)         -？
MOVE.B #0x1,(0x1BA,A4)     貌似和COUNTER有关，只能是1、2、3中的一个，3以上会花屏
MOVE.W #0x2CF,(0x1BC,A4)       -角色发出的声音
MOVE.W #0x600,(0x1DE,A4)       -必杀挥空中集气数值 80满一能量珠
MOVE.W #0xA00,(0x1E0,A4)       -必杀技命中集气数值 80满一能量珠
MOVE.B #0x5,(0x108,A4)         -轻暗勾手命中分值
MOVE.B #0x29,(0xEF,A4)         -重暗勾手命中杀伤力代码
MOVE.W #0xE0,(0xD2,A4)         -轻暗勾手P2ACT E0
MOVE.W #0xE2,(0xD4,A4)         -暗勾手波动P2ACT E2
MOVE.W #0xE3,(0xD6,A4)         -暗勾手波动消失P2ACT E3
MOVE.W #0xF7,(0xD8,A4)         -发暗勾手时手部附加火焰 F7
MOVE.L #0x40000,(0x50,A4)    -轻暗勾手飞行速度
BTST #0x4,(0x1A4,A4)           -判定轻出按什么键[4/5/6/7=A/B/C/D]
MOVE.B #0x7,(0x108,A4)         -暗勾手命中分值
MOVE.B #0x2A,(0xEF,A4)         -重暗勾手命中杀伤力代码
MOVE.W #0xE1,(0xD2,A4)         -重暗勾手P2ACT E1
MOVE.L #0x70000,(0x50,A4)    -重暗勾手飞行速度 07
JSR 0x140FE                  -跳到伤害程序140FE //杀伤力子程序
BTST #0x0,(0x31,A4)          -判断面向 
BNE *+0x8 [0x31BCA]          -如果正向则继续输出D2 
NEG.L (0x50,A4)              -是负取反 
MOVE.W (0xD2,A4),(0x72,A4)     -输出D2，也就是E0,E1
MOVE.W #0xFFFF,(0x78,A4)
JSR 0x584C
MOVE.L #0x31BE2,(A4)           -转到下一行31BE2
TST.B           (0x7D,A4)       -判断是否到输出飞行道具“火”
BPL *+0x92 [0x31C78]         -不是则转到31C78继续输出
ANDI.B #0x7F,(0x7D,A4)         -重置7D值
LEA (-0x200,PC) [0x319F2],A0 -飞行道具程序 
MOVE.W (0x70,A4),D2          -从当前人物ID读取ACT
MOVE.W (0xD8,A4),D3          -输出D8，也就是F7
MOVE.W #0x0,D5               -暗勾手发出瞬间后甩手部火焰P2ACT F7X轴坐标
MOVE.W #0x0,D6               -暗勾手发出瞬间后甩手部火焰P2ACT F7Y轴坐标
JSR 0x1E374                    -加载数值入内存
TST.B (0x7D,A4)              -判断是否到输出飞行道具“火”
MOVE.W (0x70,A4),D2          -从当前人物ID读取ACT
MOVE.W (0xD4,A4),D3          -输出D4，也就是E2
MOVE.W #0xFFD0,D5            -暗勾手飞出瞬间P2ACT E2X轴坐标
MOVE.W #0x0,D6               -暗勾手飞出瞬间P2ACT E2Y轴坐标
JSR 0x1E374                    -加载数值入内存
MOVE.L #0x31D04,(0x19C,A1)   -飞行道具命中后的效果
MOVE.L #0x31D08,(0x1A0,A1)   -飞行道具命中后对手反应 消失/反弹/穿越 
MOVE.W (0xD6,A4),(0xD6,A1)   -输出D6,也就是E3，飞行道具命中后化作烟气    
TST.B (0x7C,A4)              -判断输出是否完毕
BTST     #0x3,(0xE1,A4)  //直接出还是CANCEL出的判断
MOVE.L   #0xFFFD8000,(0xC2,A4)   //反弹的方向，FF取负，00取正；FD代表负移2单位，如果是0002则是正移2单位
MOVE.L   #0xA0000,(0xC6,A4)      //弹起高度
MOVE.L   #0x8000,(0xCA,A4)       //下落重力
MOVE.B   #0xC,(0xEF,A4)  设置伤血
TST.W    (0x1B2,A4)//表里人物判断
BTST     #0x5,(0xE1,A4)//飞行道具判断
BTST     #0x1,(0xE0,A4)//是否空中判断
BTST     #0x0,(0xE4,A4)//是否MAX状态
BTST     #0x4,(0x1A4,A4)//是否按A
BTST     #0x5,(0x1A4,A4)//是否按B
BTST     #0x6,(0x1A4,A4)//是否按C
BTST     #0x7,(0x1A4,A4)//是否按D
JSR 0x7700              声音子程序，JMPA15C6
JMP      0x1EAD8       //站立性质招式的结束
JMP      0x1EB20      //带下蹲性质招式的结束
JMP      0x2516A                //结束，回到玩家操作
JSR      0x248A8                      //必杀技开头
JSR      0x24926    必杀技开头
JSR      0x155F4                      //加气
JSR      0x7A98                       //读入音效
JSR      0x3F8A           判断敌人能不能被投的函数
JMP      0x1EFA6         //1EFA6为设定招式为必杀技
JSR      0x98180    重要，98180处即判定后续出招摇招是否相符的子程序
JSR      0x18C1C   加载伤血程序
----------------------------------------------------------------------------
P1:人物动作ID表地址:AFC56 (400h)
P2:A:图像帧XY坐标定义:100002 (4h)
   B:帧定义数据（调用C的数据）基地址:150000 (4h)
---------------------------------------------------
200002-> 20011A[KYO] 
鬼燃烧的ACT为81?80 82 84?
里草发波（轻拳）的动作ACT就是E0
a8 a9  毒咬 下前c
9c 9d  荒咬 下前a
8d 8f 90 90 92 93 下前b
8e 8f 91 91 92 94 下前d
75     跳上+cd
74     cd act=64
98     后下后b
99     后下后d重跳2ffdc 2ff86 代码
80 82 84    前下前a 0x212abe
81 83 85    前下前c 2fcf0
8d     下前b
de     32360 外式·奈落落[特殊技] 空中↓+C bp 19a7a
61     下b act=59
62 63  按C 62近c 212526/63远c 212576
6b 6c  按d
af b1 b2 下后a 九百拾式·鹤摘（外式+虎伏/龙射） ↓↙←+A/C[当身技]
b0 b1 b2 下后c
b5     斜下d 0x213E5A
b6     前b 0x213EF8
50     轻拳
62     重拳 act=5a 0x212526
a0 a1 30a88 30b30 下前a+下后a 
9e 9f 3085a 30902 下前a+下前a 改速度
aa ab 30d9a 30e04 下前c+下后c 改距离
200002->20011A->0x21191A+9c*4=0x2132A6

20011A+98*4=20037a->21311e 数据
------------------------------------------------------------------
神乐千鹤 20003e
20791a
aa ab      瑟音c 后下前c 0x251ECC  0x251F1C
81828a8b8c 升龙c 前下前c
808283     前下前a
------------------------------------------------------------------
FUN_00005a3e
bp 58dc;普通招式 
afbca+id0*4=afbca->afc56
afc56+act74*2=afd3e->64

200002+0*4->20011a+64*4=2002aa->21289a
21289a 
---------------------------------------------------------------------
FA定义动作的附加图像效果，常用于指令投和乱舞系超必杀技，以及火焰、闪电之类.<br>
FB定义动作的水平位移.<br>
FC定义动作的附加声音.<br>
FD定义动作的攻击效果和被攻击攻击效果.<br>
FE定义动作出现一次.[通常格式00 FE，用作结尾]<br>
FF定义动作循环出现.[通常格式00 FF，用作结尾]
---------------------------------------------------------------------
攻击硬直和cancel:
其中高位表示硬直，低位表示Cancel类型
一.硬直类型：
P2 P1敌    P1我
0: [0B]11帧硬直 [0B]11帧硬直
1: [07]7帧硬直 [07]7帧硬直
2: [02]2帧硬直 [02]2帧硬直
3: [0B]11帧硬直 [08]8帧硬直
4: [00]0帧硬直 [00]0帧硬直
5: [0D]13帧硬直 [05]5帧硬直
6: [20]32帧硬直 [20]32帧硬直
7: [0F]15帧硬直 [0F]15帧硬直
8: 为没有变化（发射飞行道具或空中技用以及还有后续招式的帧图特用）
二.Cancel类型：
0为不可Cancel；
4为可以Cancel必杀技和超必杀技；
8为只可Cancel特殊技；C为完全Cancel；
1为削弱对空追打；2为倒地追击（Down攻击）
其中，1、2分别可以和0、4、8、C进行组合，从而得出：
5为可以Cancel必杀技和超必杀技,削弱对空追打
6为可以Cancel必杀技和超必杀技,倒地追击（Down攻击）
9为只可Cancel特殊技,削弱对空追打
A为只可Cancel特殊技,倒地追击（Down攻击）
D为完全Cancel,削弱对空追打
E为完全Cancel,倒地追击（Down攻击）
---------------------------------------------------------------------
1、人物CH、宽度WORD，108100+70=0x108170，108100：是动态对象池地址。
2、动作ACT的MAME DEBUG内存地址：108172。
1、MAME DEBUG的断点：6022！
2、P2ROM有4m内存里只能放1m所以有四个Bank，需要bank switch（这东东是分页）。
--------------------------------------------------------------------
草薙的Graph Tile贴图分析流程：

1、在108172位置锁定鬼燃烧的ACT为81
2、81在Bank2 里，然后去切换到bank2
3、在200002地址ch menu 找到20011A地址
4、从20011A+81x4 = 20031E找到212B02
5、212B02地址就是鬼燃烧的起始动作 0200 00E1
6、回到bank1 找图 从200002 找到 20008E的GraphInfoEntry 6个字节一组
7、20008E + E1x6 = FFCC FFA0 位置 00E1图片索引
8、草薙的图像索引从2536C6 + e1x4 = 253A4A 得到25100C
9、25100C：1001－方式，0506－大小，0001 1139－去winkawaks查一下Tile Viewer
------------------------------------------------------------------------------------------------
dip switch 打开游戏碰撞检测框
0x100000=0x02

p2rom包含的所有的的判定框的数据
可以通过mame 内存搜索工具找到这些数据
从ACT封装章节里的Bank2找到box数据的起始地址是 0x21191A
FD05 type | box index=05 根据000001 01 type左移2位
所以类型是type=1，在第一个判定框index=1；1*4 + 1 +FD00=FD05;
FD0A type | box index=0A 根据000010 10 type左移2位
所以类型是type=2，在第一个判定框index=2；2*4 + 2 +FD00=FD0A;


代码部分分析
0x9DE0
0x9e04=BoxCheck；碰撞检测，攻击被攻击
0x9e0A=CheckP1P2BodyOverlap；过于近检测，过近弹开

进入BoxCheck到3698位置4个循环检查box
3F1E+108000=10BF1E 攻击者携带的判定框
3F9E+108000=10BF9E 被攻击者携带的判定框

8100 108190P1人物携带的判定框
8300 108390P2人物携带的判定框
2B00=102B00，102B70:ch,act;102B90 是这个对象判定框，每个结构体是固定，小100，大的对象200，最小40；

108190 P1判定框属性 5组box0，box1，box2，box3，box4，boxBody；
5个字节一组，为啥是5个一组，因为数据是6个字节，第一个类型的分配到不同地址，人物一般都携带连三组判定框

判定框碰撞有效性
DD492ED0-BFE6-418E-B5FE-14E880A2483F.png
判定框类型0x38c0;switch{}

0-B一共12个被攻击判定

C-17 是不摩血的攻击

18-30 必杀技判定

38-39 架招

3A-3F 飞行道具抵消框

07 特瑞可以无限连击
不要在p2的108300+90位置设置07的判定框可以实现

分析动态内存的技巧
30B2是动态内存分配的方法，
在这个函数的返回的地方断点，打印出a1，就是他分配的内存地址
bp 3112，1，{printf a1;g}

3794
每一帧
bp 3794,1,{pc+=4;g}

a4 结构体

连技

cancel：八神前爪+葵花，前抓处在半主动状态，
58ec
是否连技判断
------------------------------------------------------------------------------------------------
声音地址：

声音调用地址+人物ID*2=声音代码


97  真吾  轻攻击 174



KYO  2AF  2D7

          声音调用地址

2B5  死亡   A7F34

2B6  挑拔   A3550(A3590  A35D0)

2B8  滚AB   A3650

2B9  倒地滚 A8C56

2B7  集气   A3610

2B2  被轻打 193F4

2B3  被重打 19434

2B4  被打飞 19474

A/B  11768  A3690

C/D  11778  A36D0





98   KYO

         声音调用地址

2B5  死亡  B2E86

2B6  挑拔  ABD68(

A/B        ABF30

C/D        ABF7C

2B7  集气   ABE4C

2B8  滚AB   ABEE4

2B9  倒地滚 B3BB4

2B2  被轻打 1E51C

2B3  被重打 1E568

2B4  被击飞 1E5B4



00  KYO

CD  重攻击  C837E

C/D         C8336

A/B         C82EE

            C82A6

            C825E

01 

声音程序：B1AC0

A/B    35ADC    C240A

C/D    35AEE     C245E

CD      35B00     C24B2

死亡     C20CA

前AB    C2362

后AB    C23B6

倒地AB起身     C3248

轻拳脚受击      39E2E

重拳脚受击      39E82

重必杀受击      39ED6

轻必杀受击      39F2A



02 KYO

845      A/B        C3318

846       C/D        C336A

86B      CD重攻击    C33BC

84A     死亡         C2F8E

84B    挑畔           C30DA(C312C  不详）

84C    前AB        C3274

84C     后AB       C32C6

849    必杀受击    342A6

86C    受击？？    342F8

848    重拳脚受击    34254 

------------------------------------------------------------------------------------------------
cheat "60s战斗时间"
default 0
0 "关闭"
1 "97/98", 0, 0x10A83A, 0x60
2 "99/00", 0, 0x10A7E6, 0x60
3 "01/02", 0, 0x10A7D2, 0x60

cheat "固定HP PL1"
default 0
0 "关闭"
1 "100%HP", 0, 0x108239, 0x66
2 "2/3HP", 0, 0x108239, 0x44
3 "50%HP", 0, 0x108239, 0x33
4 "1/3HP", 0, 0x108239, 0x22
5 "0%HP", 0, 0x108239, 0x00

cheat "固定能量 PL1"
default 0
0 "关闭"
1 "5气", 0, 0x1082E3, 0x05
2 "4气", 0, 0x1082E3, 0x04
3 "3气", 0, 0x1082E3, 0x03
4 "2气", 0, 0x1082E3, 0x02
5 "1气", 0, 0x1082E3, 0x01
6 "0气", 0, 0x1082E3, 0x00

cheat "总是有Max超杀模式 PL1"
default 0
0 "关闭"
1 "5气", 0, 0x1082E3, 0x05, 0, 0x1081EA, 0x2F, 0, 0x1081EB, 0x10, 0, 0x10821D, 0x20
2 "4气", 0, 0x1082E3, 0x04, 0, 0x1081EA, 0x2F, 0, 0x1081EB, 0x10, 0, 0x10821D, 0x20
3 "3气", 0, 0x1082E3, 0x03, 0, 0x1081EA, 0x2F, 0, 0x1081EB, 0x10, 0, 0x10821D, 0x20
4 "2气", 0, 0x1082E3, 0x02, 0, 0x1081EA, 0x2F, 0, 0x1081EB, 0x10, 0, 0x10821D, 0x20
5 "1气", 0, 0x1082E3, 0x01, 0, 0x1081EA, 0x2F, 0, 0x1081EB, 0x10, 0, 0x10821D, 0x20
6 "0气", 0, 0x1082E3, 0x00, 0, 0x1081EA, 0x2F, 0, 0x1081EB, 0x10, 0, 0x10821D, 0x20

cheat "固定眩晕值 PL1"
default 0
0 "关闭"
1 "100%眩晕值", 0, 0x10823F, 0x66
2 "2/3眩晕值", 0, 0x10823F, 0x44
3 "50%眩晕值", 0, 0x10823F, 0x33
4 "1/3眩晕值", 0, 0x10823F, 0x22
5 "0%眩晕值", 0, 0x10823F, 0x00

cheat "固定防御值 PL1"
default 0
0 "关闭"
1 "100%防御值", 0, 0x108247, 0x66
2 "2/3防御值", 0, 0x108247, 0x44
3 "50%防御值", 0, 0x108247, 0x33
4 "1/3防御值", 0, 0x108247, 0x22
5 "0%防御值", 0, 0x108247, 0x00

cheat "靠近-眩晕值立即恢复 PL1"
default 0
0 "关闭"
1 "开启", 0, 0x108244, 0x10

cheat "靠近-防御耐久值立即恢复 PL1"
default 0
0 "关闭"
1 "开启", 0, 0x10824C, 0x22

cheat "快速攻击 PL1"
default 0
0 "关闭"
1 "开启", 0, 0x1081E1, 0x00

cheat "快速动作 PL1"
default 0
0 "关闭"
1 "开启", 0, 0x10817A, 0x00

cheat "开始前可移动 PL1"
default 0
0 "关闭"
1 "开启", 0, 0x1081E2, 0x10

cheat "空中出招 PL1"
default 0
0 "关闭"
1 "开启", 0, 0x1081E0, 0x00

cheat "穿过对方 PL1"
default 0
0 "关闭"
1 "开启", 0, 0x1081A4, 0x80

cheat "无受创硬直 PL1"
default 0
0 "关闭"
1 "开启", 0, 0x1083E6, 0x81

cheat "空中无限追打 PL1"
default 0
0 "关闭"
1 "开启", 0, 0x10837C, 0x06, 0, 0x108393, 0x01

cheat "中断慢镜头 PL1"
default 0
0 "关闭"
1 "可用飞行道具", 0, 0x10817D, 0xFF,
2 "不可用飞行道具", 0,0x10817D, 0x7F

cheat "最高击打数 PL1"
default 0
0 "关闭"
1 "开启", 0, 0x10817C, 0x01

cheat "攻击加强 PL1"
default 0
0 "关闭"
1 "开启", 0, 0x108172, 0x00, 0, 0x108178, 0x00, 0, 0x1081E2, 0x02

cheat "保护层 PL1"
default 0
0 "关闭"
1 "开启", 0, 0x10819A, 0x0C

cheat "必定Counter PL1"
default 0
0 "关闭"
1 "倒地追加", 0, 0x108395, 0x01
2 "必定Counter", 0, 0x108395, 0x03

cheat "人物打击属性 PL1"
default 0
0 "关闭"
1 "放血（后弹）", 0, 0x10817E, 0x90
2 "放血（不后弹）", 0, 0x10817E, 0x93
3 "红焰Ⅰ型（后弹）", 0, 0x10817E, 0xA0
4 "红焰Ⅰ型（不后弹）", 0, 0x10817E, 0xA3
5 "紫焰（后弹）", 0, 0x10817E, 0xB0
6 "紫焰（不后弹）", 0, 0x10817E, 0xB3
7 "雷电（后弹）", 0, 0x10817E, 0xC0
8 "雷电（不后弹）", 0, 0x10817E, 0xC3
9 "红焰Ⅱ型（后弹）", 0, 0x10817E, 0xD0
10 "红焰Ⅱ型（不后弹）", 0, 0x10817E, 0xD3
11 "铁球（后弹）", 0, 0x10817E, 0xE0
12 "铁球（不后弹）", 0, 0x10817E, 0xE3
13 "概率暴击（后弹）", 0, 0x10817E, 0xF0
14 "概率暴击（不后弹）", 0, 0x10817E, 0xF3

cheat "固定HP PL2"
default 0
0 "关闭"
1 "100%HP", 0, 0x108439, 0x66
2 "2/3HP", 0, 0x108439, 0x44
3 "50%HP", 0, 0x108439, 0x33
4 "1/3HP", 0, 0x108439, 0x22
5 "0%HP", 0, 0x108439, 0x00

cheat "固定能量 PL2"
default 0
0 "关闭"
1 "5气", 0, 0x1084E3, 0x05
2 "4气", 0, 0x1084E3, 0x04
3 "3气", 0, 0x1084E3, 0x03
4 "2气", 0, 0x1084E3, 0x02
5 "1气", 0, 0x1084E3, 0x01
6 "0气", 0, 0x1084E3, 0x00

cheat "总是有Max超杀模式 PL2"
default 0
0 "关闭"
1 "5气", 0, 0x1084E3, 0x05, 0, 0x1083EA, 0x2F, 0, 0x1083EB, 0x10, 0, 0x10841D, 0x20
2 "4气", 0, 0x1084E3, 0x04, 0, 0x1083EA, 0x2F, 0, 0x1083EB, 0x10, 0, 0x10841D, 0x20
3 "3气", 0, 0x1084E3, 0x03, 0, 0x1083EA, 0x2F, 0, 0x1083EB, 0x10, 0, 0x10841D, 0x20
4 "2气", 0, 0x1084E3, 0x02, 0, 0x1083EA, 0x2F, 0, 0x1083EB, 0x10, 0, 0x10841D, 0x20
5 "1气", 0, 0x1084E3, 0x01, 0, 0x1083EA, 0x2F, 0, 0x1083EB, 0x10, 0, 0x10841D, 0x20
6 "0气", 0, 0x1084E3, 0x00, 0, 0x1083EA, 0x2F, 0, 0x1083EB, 0x10, 0, 0x10841D, 0x20

cheat "固定眩晕值 PL2"
default 0
0 "关闭"
1 "100%眩晕值", 0, 0x10843F, 0x66
2 "2/3眩晕值", 0, 0x10843F, 0x44
3 "50%眩晕值", 0, 0x10843F, 0x33
4 "1/3眩晕值", 0, 0x10843F, 0x22
5 "0%眩晕值", 0, 0x10843F, 0x00

cheat "固定防御值 PL2"
default 0
0 "关闭"
1 "100%防御值", 0, 0x108447, 0x66
2 "2/3防御值", 0, 0x108447, 0x44
3 "50%防御值", 0, 0x108447, 0x33
4 "1/3防御值", 0, 0x108447, 0x22
5 "0%防御值", 0, 0x108447, 0x00

cheat "靠近-眩晕值立即恢复 PL2"
default 0
0 "关闭"
1 "开启", 0, 0x108444, 0x10

cheat "靠近-防御值立即恢复 PL2"
default 0
0 "关闭"
1 "开启", 0, 0x10844C, 0x22

cheat "快速攻击 PL2"
default 0
0 "关闭"
1 "开启", 0, 0x1083E1, 0x00

cheat "快速动作 PL2"
default 0
0 "关闭"
1 "开启", 0, 0x10837A, 0x00

cheat "开始前可移动 PL2"
default 0
0 "关闭"
1 "开启", 0, 0x1083E2, 0x10

cheat "空中出招 PL2"
default 0
0 "关闭"
1 "开启", 0, 0x1083E0, 0x00

cheat "穿过对方 PL2"
default 0
0 "关闭"
1 "开启", 0, 0x1083A4, 0x80

cheat "无受创硬直 PL2"
default 0
0 "关闭"
1 "开启", 0, 0x1081E6, 0x81

cheat "空中无限追打 PL2"
default 0
0 "关闭"
1 "开启", 0, 0x10817C, 0x06, 0, 0x108193, 0x01

cheat "中断慢镜头 PL2"
default 0
0 "关闭"
1 "可用飞行道具", 0, 0x10837D, 0xFF,
2 "不可用飞行道具", 0,0x10837D, 0x7F

cheat "最高击打数 PL2"
default 0
0 "关闭"
1 "开启", 0, 0x10837C, 0x01

cheat "攻击加强 PL2"
default 0
0 "关闭"
1 "开启", 0, 0x108372, 0x00, 0, 0x108373, 0x79, 0, 0x108374, 0x00, 0, 0x1083E2, 0x02

cheat "保护层 PL2"
default 0
0 "关闭"
1 "开启", 0, 0x10839A, 0x0C

cheat "必定Counter PL2"
default 0
0 "关闭"
1 "倒地追加", 0, 0x108195, 0x01
2 "必定Counter", 0, 0x108195, 0x03

cheat "人物打击属性 PL2"
default 0
0 "关闭"
1 "放血（后弹）", 0, 0x10837E, 0x90
2 "放血（不后弹）", 0, 0x10837E, 0x93
3 "红焰Ⅰ型（后弹）", 0, 0x10837E, 0xA0
4 "红焰Ⅰ型（不后弹）", 0, 0x10837E, 0xA3
5 "紫焰（后弹）", 0, 0x10837E, 0xB0
6 "紫焰（不后弹）", 0, 0x10837E, 0xB3
7 "雷电（后弹）", 0, 0x10837E, 0xC0
8 "雷电（不后弹）", 0, 0x10837E, 0xC3
9 "红焰Ⅱ型（后弹）", 0, 0x10837E, 0xD0
10 "红焰Ⅱ型（不后弹）", 0, 0x10837E, 0xD3
11 "铁球（后弹）", 0, 0x10837E, 0xE0
12 "铁球（不后弹）", 0, 0x10837E, 0xE3
13 "概率暴击（后弹）", 0, 0x10837E, 0xF0
14 "概率暴击（不后弹）", 0, 0x10837E, 0xF3

-------------------------------------------------------------------------------------------------------------
如何取消人物候场

KOF97和KOF98差不多，KOF98的人物候场子程序在：35A2A，调用在：35996，

直接NOP调用不行，只要把35A2A的数据改754E

拳皇人物穿透修改：

人物控制程序中找到7C 19 FF 00 A4 00(KOF98)

($A4,A4)这个地址是控制能否人物穿透的，设为01不可穿透，设为FF可以穿透 
----------------------------------------------------------------------------------------
声音地址：

  

声音调用地址+人物ID*2=声音代码



97  真吾  轻攻击 174



KYO  2AF  2D7

          声音调用地址

2B5  死亡   A7F34

2B6  挑拔   A3550(A3590  A35D0)

2B8  滚AB   A3650

2B9  倒地滚 A8C56

2B7  集气   A3610

2B2  被轻打 193F4

2B3  被重打 19434

2B4  被打飞 19474

A/B  11768  A3690

C/D  11778  A36D0





98   KYO

         声音调用地址

2B5  死亡  B2E86

2B6  挑拔  ABD68(

A/B        ABF30

C/D        ABF7C

2B7  集气   ABE4C

2B8  滚AB   ABEE4

2B9  倒地滚 B3BB4

2B2  被轻打 1E51C

2B3  被重打 1E568

2B4  被击飞 1E5B4



00  KYO

CD  重攻击  C837E

C/D         C8336

A/B         C82EE

            C82A6

            C825E

01 

声音程序：B1AC0

A/B    35ADC    C240A

C/D    35AEE     C245E

CD      35B00     C24B2

死亡     C20CA

前AB    C2362

后AB    C23B6

倒地AB起身     C3248

轻拳脚受击      39E2E

重拳脚受击      39E82

重必杀受击      39ED6

轻必杀受击      39F2A



02 KYO

845      A/B        C3318

846       C/D        C336A

86B      CD重攻击    C33BC

84A     死亡         C2F8E

84B    挑畔           C30DA(C312C  不详）

84C    前AB        C3274

84C     后AB       C32C6

849    必杀受击    342A6

86C    受击？？    342F8

848    重拳脚受击    34254 
--------------------------------------------------------------------------
# Returns the list of memory addresses required to train on Street Fighter
def setup_memory_addresses():
    return {
        "round": Address('0x10A7F1', 'u8'),
        "stage": Address('0x10A798', 'u8'),
        "start": Address('0x1081E2', 'u8'),
        "winsP1": Address('0x10A85B', 'u8'),
        "winsP2": Address('0x10A84A', 'u8'),
        "healthP1": Address('0x108239', 'u8'),
        "healthP2": Address('0x108439', 'u8'),
        "positionP1": Address('0x108118', 'u16'),
        "positionP2": Address('0x108318', 'u16'),
        "powerP1": Address('0x1082E3', 'u8')
    }
----------------------------------------------------------------------------	
Backup_Start = 0x100000
Backup_Size  = 0x100
BIOS_SYSTEM_MODE = 0x10FD80
BIOS_USER_REQUEST = 0x10FDAE
BIOS_USER_MODE = 0x10FDAF
BIOS_CREDIT_DEC = 0x10fdb0
BIOS_START_FLAG = 0x10fdb4
BIOS_PLAYER_MOD1 = 0x10fdb6
BIOS_SELECT_TIMER = 0x10FDDA

PAL_START = 0x2cfff0

REG_VRAMADDR = 0x3C0000
REG_VRAMRW = 0x3C0002
REG_VRAMMOD = 0x3c0004

REG_WATCHDOG = 0x3C0001
REG_IRQACK = 0x3C000C
REG_SOUND   =   0x320000

BIOS_CLEAR_SPRITES = 0xC004C8

COINS_SOUND = 0x0010009E

A5Seg.DebugDips = -0x8000
A5Seg.COINS_SOUND = -0x7f62
A5Seg.VBlankCounter = -0x7f68

OBJ_LIST_HEAD = 0x100100

ScreenObj = 0x0
ScreenObj.X = 0x18
ScreenObj.Y = 0x1c 
ScreenObj.YFromGround = 0x20
ScreenObj.ShrinkRate = 0x2e
ScreenObj.BackgroundSpriteHeight = 0x60
ScreenObj.VRamBaseOffsetInSCB1 = 0x70
ScreenObj.SCB4UpdateVramAddr = 0x72
ScreenObj.SCB3UpdateVramAddr = 0x74
ScreenObj.SCB2UpdateVramAddr = 0x76
ScreenObj.MaxNumOfSpritesToUse = 0x78
ScreenObj.WidthInTiles = 0x7a
ScreenObj.HeightInTiles = 0x7c
ScreenObj.pBackgroundSCB1Data = 0x84
ScreenObj.RightPixelsX = 0x88
ScreenObj.LeftPixelsX = 0x8a
ScreenObj.TopPixelsY = 0x8c
ScreenObj.BottomPixelsY = 0x8e
ScreenObj.Flag = 0x90
ScreenObj.LastShrink = 0xa0
ScreenObj.pDataFromParam = 0xc2
ScreenObj.VRamBaseOffset = 0xca
ScreenObj.XfromParam = 0xd2
ScreenObj.YfromParam = 0xd4
ScreenObj.BackgroundSpriteWidthFromParam = 0xd6
ScreenObj.BackgroundSpriteHeightFromParam = 0xd8

Object = 0x0
Object.PNext = 0x4
Object.PPrev = 0x6
Object.Level = 0x8
Object.TagString = 0x10
Object.OriX = 0x18 ;
Object.OriY = 0x1c ;
Object.YFromGround = 0x20 ;
Object.XinScreen = 0x24
Object.pGraphInfoEntry = 0x28
Object.Z = 0x2c ;
Object.RoleShrinkRate = 0x2e
Object.IsFaceToRight = 0x31
Object.Palette = 0x3a
Object.ExGraphFlags = 0x3B
Object.pGraphDataSubmenuBase = 0x3c
Object.speedX = 0x50 ;
Object.ChCode = 0x70
Object.ActCode = 0x72
Object.MovOffsetFromActBase = 0x74
Object.PrevChCode = 0x76
Object.PrevActCode = 0x78
Object.SpanTime = 0x7a
Object.FreezeDelayTime = 0x7b
Object.HitBoxFlag = 0x7c
Object.RecoveryFlags = 0x7d
Object.HitSpecialStatus = 0x7e
Object.MovIndexInAct = 0x80
Object.ParentObj = 0x84
Object.EffectChild = 0x88
Object.FixlayVramTextXDelta = 0x8c
Object.FixlayVramTextYDelta = 0x8e
Object.Box0 = 0x90
Object.selfBuf2 = 0xc2
Object.selfBuf1 = 0xd2
Object.RoleStatusFlags = 0xe0


A5Seg.MainNextRoutine = 0x500
A5Seg.SpritePoolBaseTable = 0x2700
ObjPoolBaseTable = 0x10a700
A5Seg.ObjPoolStackIndex = 0x2780
A5Seg.VBlankSpinEvent = 0x2785
A5Seg.VideoSpecialModes = 0x2788
A5Seg.TileUpdateFlag = 0x2789
|A5Seg.PaletteUpdateFlag = 0x278a
A5Seg.PLAYER1_phase = 0x2790
A5Seg.IsPlayerExist = 0x27f2
A5seg.TitlePressButtonStruct = 0x282a
TitlePressButtonStruct = 0x10a82a
A5Seg.ObjZBuf = 0x286a
A5Seg.NumInObjZBuf = 0x2e6c
A5Seg.TileVertPositionsBuff_Main = 0x2e6e
A5Seg.BackUpTileOffsetInSCB1_Main = 0x306e
A5Seg.TileOffsetInSCB1_Main = 0x3070
A5Seg.ObjTotalSpriteNumbers_Main = 0x3072
A5Seg.SpriteAlreadyUsed_Main = 0x3076
A5Seg.ScreenLeftX = 0x3082
A5Seg.ScreenTopY = 0x3092
A5Seg.BackGroundObjLayer0 = 0x30b2
A5Seg.BackGroundObjLayer1 = 0x31b2
A5Seg.BackGroundObjLayer2 = 0x32b2
A5Seg.BackGroundObjLayer3 = 0x33b2
A5Seg.BackGroundObjLayer4 = 0x34b2
A5Seg.BackGroundObjLayer5 = 0x35b2
A5Seg.BackGroundObjLayer6 = 0x36b2
A5Seg.BackGroundObjLayer7 = 0x37b2
A5Seg.PendingNumOfBackgroundLayerToUpdate = 0x38b2
A5Seg.ShrinkNumBlocksToUpdate = 0x38b5
A5Seg.BackgroundUpdateSCB3_4NumBlocksPending = 0x38b4
A5Seg.pBackgroundUpdateSCB3_4BlocksStart = 0x38b6
A5Seg.BackgroundSCB3_4BlocksBuf = 0x38be

A5Seg.ShrinkUpdateBlocksStart = 0x38ba
A5Seg.UpdateOffsetInSCB2 = 0x3cfe | 0x10bcfe

PaletteTempQueueStart = 0x108000 + 0x4022	|0x10c022
A5Seg.PaletteTempQueueStart = 0x4022
A5Seg.PAL_IN_POINT = 0x5924
A5Seg.ColorTargetReachedFlag = 0x5928
A5Seg.PalGradDeltaR = 0x592e
A5Seg.PalGradDeltaG = 0x5930
A5Seg.PalGradDeltaB = 0x5932
A5Seg.SD_IN_POINT = 0x5936
A5Seg.SD_OUT_POINT = 0x5937
A5Seg.BGM_CODE      = 0x5938
A5Seg.SOUND_CODE_W  = 0x593a
A5Seg.SOUND_BUFFER = 0x593e     |size: 0x100

A5Seg.pPalGradEntry1 = 0x649e
A5Seg.pPalGradEntry2 = 0x64a2
A5Seg.PalGradTargetR= 0x64a6
A5Seg.PalGradTargetG = 0x64a8
A5Seg.PalGradTargetB = 0x64aa
A5Seg.FirstObjIndexInZBuf = 0x64d2
A5Seg.pGhostBuf = 0x64d6
A5Seg.SpriteDrawHoriCoefficient = 0x64e6
A5Seg.SpriteDrawVertCoefficient = 0x6448
A5Seg.TempGraphLevel = 0x64ee
A5Seg.TempExGraphMask = 0x64f0
A5Seg.TextOutputOffset = 0x64f6
A5Seg.TextOutputEntryHigh = 0x64f8
A5Seg.TextOutputDefaultPalIndex = 0x64fa
A5Seg.BackgroundSpritesXTempBuf = 0x6506
A5Seg.WhoPushedStart = 0x66bc
A5Seg.PaletteSubGroupIndex = 0x66be
A5Seg.FlashScreenTypeIndex = 0x6b8b
A5Seg.GlobalCamaraYDelta = 0x6ce4

PalGradObj = 0x0
PalGradObj.pEntryIndex1 = 0xa
PalGradObj.pEntryIndex2 = 0xe
PalGradObj.GradDeltaR = 0x12
PalGradObj.GradDeltaG = 0x14
PalGradObj.GradDeltaB = 0x16
PalGradObj.Counter = 0x18
PalGradObj.GradDDR = 0x1a
PalGradObj.GradDDG = 0x1c
PalGradObj.GradDDB = 0x1e
PalGradObj.CounterResetVal = 0x20
PalGradObj.MaxGradSteps = 0x21
PalGradObj.RGBbuf1 = 0x22
PalGradObj.RGBbuf2 = 0x112

FixLayerStruct = 0
FixLayerStruct.y = 2
FixLayerStruct.Flag = 4
FixLayerStruct.PCHAR = 8
------------------------------------------------------------------------------------
static struct BurnRomInfo kof97RomDesc[] = {
    { "232-p1.p1",    0x100000, 0x7db81ad9, 1 | BRF_ESS | BRF_PRG }, //  0 68K code
    { "232-p2.sp2",   0x400000, 0x158b23f6, 1 | BRF_ESS | BRF_PRG }, //  1 

    { "232-s1.s1",    0x020000, 0x8514ecf5, 2 | BRF_GRA },           //  2 Text layer tiles

    { "232-c1.c1",    0x800000, 0x5f8bf0a1, 3 | BRF_GRA },           //  3 Sprite data
    { "232-c2.c2",    0x800000, 0xe4d45c81, 3 | BRF_GRA },           //  4 
    { "232-c3.c3",    0x800000, 0x581d6618, 3 | BRF_GRA },           //  5 
    { "232-c4.c4",    0x800000, 0x49bb1e68, 3 | BRF_GRA },           //  6 
    { "232-c5.c5",    0x400000, 0x34fc4e51, 3 | BRF_GRA },           //  7 
    { "232-c6.c6",    0x400000, 0x4ff4d47b, 3 | BRF_GRA },           //  8 

    { "232-m1.m1",    0x020000, 0x45348747, 4 | BRF_ESS | BRF_PRG }, //  9 Z80 code

    { "232-v1.v1",    0x400000, 0x22a2b5b5, 5 | BRF_SND },           // 10 Sound data
    { "232-v2.v2",    0x400000, 0x2304e744, 5 | BRF_SND },           // 11 
    { "232-v3.v3",    0x400000, 0x759eb954, 5 | BRF_SND },           // 12 
};