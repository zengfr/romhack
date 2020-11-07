~~~
--------------------------------------------------------------------
wp d09000,400,r,1,{logerror "r p1 %8x %8x %8x\r\n",wpaddr-d09000,pc,wpdata;g;}
wp d09000,400,w,1,{logerror "w p1 %8x %8x %8x\r\n",wpaddr-d09000,pc,wpdata;g;}

wp d07000,400,r,1,{logerror "r enemy %8x %8x %8x\r\n",wpaddr-d07000,pc,wpdata;g;}
wp d07400,400,r,1,{logerror "r enemy %8x %8x %8x\r\n",wpaddr-d07400,pc,wpdata;g;}
wp d07800,400,r,1,{logerror "r enemy %8x %8x %8x\r\n",wpaddr-d07800,pc,wpdata;g;}
wp d07c00,400,r,1,{logerror "r enemy %8x %8x %8x\r\n",wpaddr-d07c00,pc,wpdata;g;}
wp d08000,400,r,1,{logerror "r enemy %8x %8x %8x\r\n",wpaddr-d08000,pc,wpdata;g;}
wp d08400,400,r,1,{logerror "r enemy %8x %8x %8x\r\n",wpaddr-d08400,pc,wpdata;g;}
wp d08c00,400,r,1,{logerror "r enemy %8x %8x %8x\r\n",wpaddr-d08c00,pc,wpdata;g;}

wp d07000,400,w,1,{logerror "w enemy %8x %8x %8x\r\n",wpaddr-d07000,pc,wpdata;g;}
wp d07400,400,w,1,{logerror "w enemy %8x %8x %8x\r\n",wpaddr-d07400,pc,wpdata;g;}
wp d07800,400,w,1,{logerror "w enemy %8x %8x %8x\r\n",wpaddr-d07800,pc,wpdata;g;}
wp d07c00,400,w,1,{logerror "w enemy %8x %8x %8x\r\n",wpaddr-d07c00,pc,wpdata;g;}
wp d08000,400,w,1,{logerror "w enemy %8x %8x %8x\r\n",wpaddr-d08000,pc,wpdata;g;}
wp d08400,400,w,1,{logerror "w enemy %8x %8x %8x\r\n",wpaddr-d08400,pc,wpdata;g;}
wp d08c00,400,w,1,{logerror "w enemy %8x %8x %8x\r\n",wpaddr-d08c00,pc,wpdata;g;}
------------------------------------------------------------------------------------
判定
wp d09020,4,r,1,{printf "r p1 %8x %8x %8x\r\n",wpaddr-d09000,pc,wpdata;g;}
wp d07020,4,r,1,{printf "r enemy %8x %8x %8x\r\n",wpaddr-d07000,pc,wpdata;g;}
wp d07420,4,r,1,{printf "r enemy %8x %8x %8x\r\n",wpaddr-d07400,pc,wpdata;g;}
wp d07820,4,r,1,{printf "r enemy %8x %8x %8x\r\n",wpaddr-d07800,pc,wpdata;g;}
wp d0706c,2,w,1,{printf "w enemy %8x %8x %8x\r\n",wpaddr-d07000,pc,wpdata;g;}
wp d0746c,2,w,1,{printf "w enemy %8x %8x %8x\r\n",wpaddr-d07400,pc,wpdata;g;}
wp d0786c,2,w,1,{printf "w enemy %8x %8x %8x\r\n",wpaddr-d07800,pc,wpdata;g;}
----------------------------------------------------------------------------------
wp d070f4,2,w,1,{logerror "enemy %1x %1x %2x %2x %8x %8x %8x\r\n",maincpu.pb@813AD1,maincpu.pb@813AD4,pb@d0a000,wpdata,md@(wpaddr-40),md@(wpaddr-40+4),pc;g;}
wp d070f6,2,w,1,{logerror "enemy %2x %2x %2x %2x %8x %8x\r\n",wpdata,md@(wpaddr-42,md@(wpaddr-42+4);g;}
------------------------------------------------------------------------------------
wp d02000,5000,w,1,{logerror "w item %8x %8x\r\n",(wpaddr-d02000)%100,pc;g;}
------------------------------
1DE3E8: swap    D1
1DE3EA: beq     $1de3f4
1DE3F4: move.l  (A7)+, D2
1DE3F6: rts
1726B4: asr.l   #6, D0
1726B6: sub.l   D0, D2
1726B8: move.l  D2, D0
1726BA: move.l  D4, D1
1726BC: jsr     $1de3ce.l
1DE3CE: movem.l D0/D2, -(A7)
1DE3D2: move.l  D0, D2
1DE3D4: mulu.w  D1, D0
1DE3D6: clr.w   D2
1DE3D8: swap    D2
1DE3DA: beq     $1de3e4
1DE3E4: move.l  (A7)+, D2
--------------------------------------------------------------------------------
                             tst.w   $6C(a2)
ROM:0044058E                 bne.s   loc_44059C
ROM:00440590                 move.w  #1,$B4(a2)
ROM:00440596                 move.w  #1,$174(a2)

ROM:0011A3C4                 jsr     sub_1724BC
ROM:0011A61C                 jsr     sub_1157C6
ROM:001158C4                 sub.w   d2,$6C(a2)
bsr 11a36e->jsr sub_1724BC->jsr 1de3ce->jsr 1157C6->
jsr     sub_1724BC ;计算d0伤害
jsr     sub_1157C6 ;敌兵减血
bp 440564;bp 1726bc;
bp 1726ae,1,{printf "%8x %8x %8x %8x %8x %8x",pc,d0,d1,d2,d3,d4;g}
bp 440566,1,{printf "%8x %8x %8x ",pc,d0,d2;g}
-------------------------------------------------------------------------------
($54,A2), A3->d0;
($58,A5), A4->d1;
$211cfe+d0+d1->d4;
1724E4: movea.l ($54,A2), A3 ;我 ;a3=27572a
1724E8: movea.l ($58,A5), A4 ;敌兵a5;a4=2376fa
1724EC: moveq   #$0, D0
1724EE: move.b  ($1,A3), D0
1724F2: move.l  D0, D1
1724F4: lsl.l   #5, D1
1724F6: add.l   D1, D0
1724F8: lsl.l   #2, D0
1724FA: sub.l   D1, D0
1724FC: moveq   #$0, D1
1724FE: move.b  ($1,A4), D1
172502: add.l   D1, D0
172504: movea.l #$211cfe, A0
17250A: move.b  (A0,D0.l), D4
17250E: andi.l  #$ff, D4
bp 172502,1,{printf "%8x %8x %8x ",pc,d0,d1;g}
27572a->28*64->fa0
2376fa->17-> 211cfe+fa0+17->212cb5 吕布对司马17伤害40
211cfe+fa0+28->212cc6吕布对j吕布28伤害00
211cfe+fa0+2c  左慈2c maincpu.md@43fb80=f05c0500