~~~
---------------------------------------------------------------------------------------------------------------------
快打旋风
dbg mode:wp ff8084,1,rw,1,{pb@ff8084=1;g}
$3bec ; Random
5e7b6 reset
14C2 17DC draw_string/hide_string
126c 打印字符串
165C8 900000
FF8129 (b)过关 4d40 Gameplay demo switch,sublevel outro (00 = not in demo, 01 = in demo, FF = signal demo end?)
90B014	- First visible tile of leftmost dynamite scene portrait, SCROLL2
{address = 0xFF8568, number = 0x0F, space = 0xC0, hp = 0x18}, --players and enemies
		{address = 0xFF90A8, number = 0x06, space = 0xC0, projectile = true}, --weapons
		{address = 0xFF9528, number = 0x08, space = 0xC0, hp = 0x18}, --bosses and enemies
		FF9B28-FFB2E7 ,number = 0x1f, space = 0xC0
		{address = 0xFFB2E8, number = 0x10, space = 0xC0, hp = 0x18, projectile = true}, --containers
		{address = 0xFFBEE8, number = 0x0A, space = 0xC0, projectile = true}, --items
FF86e8 to Ff90a7 Enemy memory regions, c0 bytes each, 13 slots
FF90a8 to FF9527 Weapons, c0 bytes each, 6 slots
FF9528 to FF9B27 Boss memory, c0 bytes each, 8 slots ff9a68
FF8568 P1
0x00E6D0;Intro demos
0x00CBF6;Middle demos
0x00F4F8;Outro demos
wp 908610,2,w 血条
FF8581(18) P1 Infinite Energy
FF85C9(61) P1 Invincibility无敌 r:32cc,a79e,a7a4 w:79d4被打
FF85E8(80)(b) lives
FF85EA(82)(b) 1P Input
FF860B(a3)(b) 00 02 04 06 动作组合
FF8590(28)(b)=01 Action Speed Up
FF9a68 boss 79c0,3ce4敌兵减血
ffb1e8 xx基址 bp 5b0a 5b76
ff1150,ff1152 bp 3bec
bp 79c0,1,{printf "%8x %8x %8x %8x ",frame,pc,a3,pb@FF85C9;pb@FF85C9=0x28;g}
bp 79d4,1,{printf "%8x %8x %8x %8x ",frame,pc,a3,pb@FF85C9;pb@FF85C9=0x28;g}
bp 5ea8,1,{printf "db1 %8x %8x %8x %8x %8x %8x %8x %8x",frame,pc,a4,a3,pd@(a3+0),pd@(a3+4),pd@(a3+8),pw@(a3+c);g}
bp 6210,1,{printf "db2 %8x %8x %8x %8x %8x %8x %8x %8x",frame,pc,a4,a3,pd@(a3+0),pd@(a3+4),pd@(a3+8),pw@(a3+c);g}
bp 1faf2,1,{printf "db3 %8x %8x %8x %8x %8x %8x",frame,pc,a4,a0,a2,pd@(a0+0),pd@(a2+0);g}
($12,A4)         ;entity class ID 0 2 敌兵 4 6 8 敌兵 a 物品箱子  080f门
($13,A4)		; player ID 
($15,A4)		; 敌兵掉物 
($18,A4)		; hp
($2F,A4)		; palette ID色板
($2e,A6)        ;1P Direction facing 00 = right, 01 = left
($36,A6)        ;Movement direction
($3f,A6)        ;
($60,A6)        ;
($62,A6)        ; 
($70,A6)        ;
($6,A2)   ; X position  FF856e
($a,A2)   ; y position  FF8572
($20,A2)  ; Head x position


($412,A5)  ; Level scroll x
($416,A5)  ; Level scroll y
$31A8(a5) $31e8(a5) ;场景 出兵指针
bp 3a12 敌兵死清内存
bp 61ba 5ea8 1faf2 敌兵分配内存
a5956 箱子打破掉物
354ba 敌兵掉武器
6d0ca 大箱子
6ec1a
108c投币1134减币进入选人
db1:5EA74,5EA7C,414,A2C6,9ACA,61C0,3A12,5EAE,A5CC,9F8C,,,,,
db2:3D13A,5A95C,
db4:595AC
db5:5A924,
 
---------------------------------------------------------------------------------------------------------------------