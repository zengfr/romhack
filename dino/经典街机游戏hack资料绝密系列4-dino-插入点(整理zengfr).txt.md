~~~
github:https://github.com/zengfr/romhack

https://github.com/zengfr/romhack
https://gitee.com/zengfr/romhack
https://github.com/zengfr/arcade_game_romhacking_sourcecode_top_secret_data/dino/trace
0\106380-106520 149B0
1\106530-10675C 不能改 18D88* 
2\106760-10698c 16474 164DC 16518 1656e 165f4 164EA 1648a 1649E 18d88* 106554*
3\1069A0-106df2 acee 1720A 7BEDC 58612 517d6 61882 52D8a ABEC 810ba
4\107A60-107F44  AAF6 145c6 14390 1433e 14560 192ce 71DA
5\104800-104974  106548* 4D9A 4dc2 4DF0 10b32 11770 116cc 28adc 28ab8 28Ad0 28ae4
6\1004F0-100580 不能改 $100aa0-$100b1c 188a4*
7\BB020-BB058   9d3f4
8\105800-105CA8  7b3c6 7bf82
9\100590-100620  104430-104496  188a4* 100570* fe5a*
10\1044A0-1047fe 103b00-103bf4  5cca0 20A0C
11\104A00-104c1e  2AF8C 52dde 52ebe 97f66 97fA0
12\105Ce0-105e42 fe5a* 
13\106e00-107A3c 23428 23436 655ba 14516 492e 655ba 655ca 655e0
14\101c00-101Ff4
15\BB0A0
16 102CA0
17 105e60
------------------------------
 0\1047c0-104960  1\1049a0-104bcc   2\104c00-$104e30 3\104e70-1052c2  4\105300-105814   5\105840-1059b4 
 6\105a00 -105b12 *7\BB040          *8\101c00-1021da  9\105b40-105caa  *10\11f140-11f574改成107300了 11\147200-1473da
12\147400-147582 13\1063c0-107000  14\1475c0-1479b4 15\147a00-147b9e 16\147ba0-147bff 17\147c20-147c56 19

w$0 序号
b$2 场景
w$4 卷轴
b$6 1已COPY
w$8 同卷轴下的出兵个数
w$A 现场BOSS数
b$E ; 总统计
b$10 ;计数复位
w$12 ;索引+1 按键出兵的
w#$4+$10 4规律的 进门随机+后面+1
w#$6+$10 6规律的 6锁定的 关底BOSS
w#$8+$10 索引偏移 8随机的 幻影

w$A+$10 索引偏移 A敌兵的

------------------------------
;source dbg.cmd bp 104626

wp ffb27c,2,w,wpdata>=0,{printf "ffb27c 08 X %8x %4x a0:%8x d0:%8x %8x",pc,wpdata,a0,d0,d1;g}
wp ffb284,2,w,wpdata>=0,{printf "ffb284 10 Y %8x %4x a0:%8x d0:%8x %8x",pc,wpdata,a0,d0,d1;g}
wp ffb280,2,w,wpdata>=0,{printf "ffb280 0C G %8x %4x a0:%8x d0:%8x %8x",pc,wpdata,a0,d0,d1;g}
bp 5388,1,{printf "5388 action %8x a0:%8x d0:%8x %8x",pc,a0,d0,d1;g}
bp fe5a,1,{printf "table %8x a0:%8x a2:%8x %8x %8x %8x %2x",pc,a0,a2,maincpu.pw@(a2+02),maincpu.pw@(a2+04),maincpu.pw@(a2+0A),maincpu.pw@(fff890);g}


bp fcd2,1,{printf "table1 %8x a0:%8x a2:%8x %8x %8x %8x %2x",pc,a0,a2,maincpu.pw@(a2+02),maincpu.pw@(a2+04),maincpu.pw@(a2+0A),maincpu.pw@(fff890);g}

bp fe36,1,{printf "table2 %8x a0:%8x a2:%8x %8x %8x %8x %2x",pc,a0,a2,maincpu.pw@(a2+02),maincpu.pw@(a2+04),maincpu.pw@(a2+0A),maincpu.pw@(fff890);g}

bp fef4,1,{printf "table3 %8x a0:%8x a2:%8x %8x %8x %8x %2x",pc,a0,a2,maincpu.pw@(a2+02),maincpu.pw@(a2+04),maincpu.pw@(a2+0A),maincpu.pw@(fff890);g}
---------------------------------------------------------------------------------------------------------------------
