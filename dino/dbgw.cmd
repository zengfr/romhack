bpclear
wpclear
rpclear
wp ffb274,180,w,{0 && wpaddr!=ffb274+8 && wpaddr!=ffb274+0x10},{printf "1p w %8x %8x %8x ",wpaddr,wpdata,pc;g}

bp fcd2,1,{logerror  "\n%8x table1 %8x a0:%8x a2:%8x %4x %4x %4x %2x %2x %4x %4x",frame,pc,a0,a2,maincpu.pw@(a2+02),maincpu.pw@(a2+04),maincpu.pw@(a2+0A),maincpu.pb@(fff890),maincpu.pb@(ff84d9),maincpu.pw@(ff8786),maincpu.pw@(ff8744);g}

bp fe36,1,{logerror  "\n%8x table2 %8x a0:%8x a2:%8x %4x %4x %4x %4x %2x %2x %4x %4x",frame,pc,a0,a2,maincpu.pw@(a2+02),maincpu.pw@(a2+04),maincpu.pw@(a2+0A),maincpu.pw@(a2+0E),maincpu.pb@(fff890),maincpu.pb@(ff84d9),maincpu.pw@(ff8786),maincpu.pw@(ff8744);g}

bp fef4,1,{logerror  "\n%8x table3 %8x a0:%8x a2:%8x %4x %4x %4x %4x %2x %2x %4x %4x",frame,pc,a0,a2,maincpu.pw@(a2+02),maincpu.pw@(a2+04),maincpu.pw@(a2+0A),,maincpu.pw@(a2+0E),maincpu.pb@(fff890),maincpu.pb@(ff84d9),maincpu.pw@(ff8786),maincpu.pw@(ff8744);g}

wp ff84d9,1,w,1,{logerror  "\n%8x gk w %8x %8x %4x a0:%8x %8x a4:%8x a6:%8x d0:%8x %8x",frame,pc,wpaddr,wpdata,a0,a1,a4,a6,d0,d1;g}
 
wp ff8786,1,w,1,{logerror  "\n%8x cj w %8x %8x %4x a0:%8x %8x a4:%8x a6:%8x d0:%8x %8x",frame,pc,wpaddr,wpdata,a0,a1,a4,a6,d0,d1;g}

wp ff8744,2,w,0 && pc!=20a68 && pc!=210be,{logerror  "\n%8x jz0w %8x %4x a0:%8x %8x d0:%4x %4x",frame,pc,wpdata,a0,a1,d0,d1;g}
 
wp ff8864,2,w,1 && pc!=6e8,{logerror  "\n%8x jz1w %8x %4x a0:%8x %8x d0:%8x %8x",frame,pc,wpdata,a0,a1,d0,d1;g}
 
wp ffe7c0,1,w,1 && pc!=49e6 && pc!=10476 && pc!=14076,{logerror  "\n%8x objw %8x %4x a0:%8x %8x d0:%8x %8x",frame,pc,wpdata,a0,a1,d0,d1;g} 

bp fe36,0,{logerror  "\n%8x table2 %8x a0:%8x a2:%8x %4x %4x %4x %4x %2x %2x %4x %4x",frame,pc,a0,a2,maincpu.pw@(a2+02),maincpu.pw@(a2+04),maincpu.pw@(a2+0A),maincpu.pw@(a2+0E),maincpu.pb@(fff890),maincpu.pb@(ff84d9),maincpu.pw@(ff8786),maincpu.pw@(ff8744);wp a0+0xd6,2,w,1,{printf "db1 w %8x %8x %8x ",wpaddr,wpdata,pc;g};wp a0+0x74,2,w,1,{printf "db2 w %8x %8x %8x ",wpaddr,wpdata,pc;g};wp a0+0xda,2,w,1,{printf "db3 w %8x %8x %8x ",wpaddr,wpdata,pc;g};g}

bp 104a00,1,{logerror  "\n%8x change1 %8x a6:%8x %8x %8x %8x %8x",frame,pc,a6,maincpu.pw@(a6+0x20),maincpu.pw@(a6+0x26),maincpu.pw@(a6+0xda),maincpu.pw@(a6+0x74);g}
bp 104b00,1,{logerror  "\n%8x change2 %8x a6:%8x %8x %8x  %8x %8x",frame,pc,a6,maincpu.pw@(a6+0x20),maincpu.pw@(a6+0x26),maincpu.pw@(a6+0xda),maincpu.pw@(a6+0x74);g}
bp 1069a0,1,{logerror  "\n%8x die acee %8x a6:%8x %8x %8x %8x %8x",frame,pc,a6,maincpu.pw@(a6+0x20),maincpu.pw@(a6+0x26),maincpu.pw@(a6+0xda),maincpu.pw@(a6+0x74);g}
bp 106b3c,1,{logerror  "\n%8x die 1720a  %8x a3:%8x %8x %8x %8x %8x",frame,pc,a3,maincpu.pw@(a3+0x20),maincpu.pw@(a3+0x26),maincpu.pw@(a3+0xda),maincpu.pw@(a6+0x74);g}
bp 106c00,1,{logerror  "\n%8x die 106c00  %8x a3:%8x %8x %8x %8x %8x",frame,pc,a3,maincpu.pw@(a3+0x20),maincpu.pw@(a3+0x26),maincpu.pw@(a3+0xda),maincpu.pw@(a6+0x74);g}

wp FFC8F4+0xda,2,w,1,{printf "db4 w %8x %8x %8x ",wpaddr,wpdata,pc;g}
wp FFC8F4+0xda+e0*1,2,w,1,{printf "db4 w %8x %8x %8x ",wpaddr,wpdata,pc;g}
wp FFC8F4+0xda+e0*2,2,w,1,{printf "db4 w %8x %8x %8x ",wpaddr,wpdata,pc;g}
wp FFC8F4+0xda+e0*3,2,w,1,{printf "db4 w %8x %8x %8x ",wpaddr,wpdata,pc;g}
wp FFC8F4+0xda+e0*4,2,w,1,{printf "db4 w %8x %8x %8x ",wpaddr,wpdata,pc;g}
wp FFC8F4+0xda+e0*5,2,w,1,{printf "db4 w %8x %8x %8x ",wpaddr,wpdata,pc;g}
wp FFC8F4+0xda+e0*6,2,w,1,{printf "db4 w %8x %8x %8x ",wpaddr,wpdata,pc;g}
wp FFC8F4+0xda+e0*7,2,w,1,{printf "db4 w %8x %8x %8x ",wpaddr,wpdata,pc;g}

wp FFC8F4+0x74,2,w,1,{printf "db5 w %8x %8x %8x ",wpaddr,wpdata,pc;g}
wp FFC8F4+0x74+e0*1,2,w,1,{printf "db5 w %8x %8x %8x ",wpaddr,wpdata,pc;g}
wp FFC8F4+0x74+e0*2,2,w,1,{printf "db5 w %8x %8x %8x ",wpaddr,wpdata,pc;g}
wp FFC8F4+0x74+e0*3,2,w,1,{printf "db5 w %8x %8x %8x ",wpaddr,wpdata,pc;g}
wp FFC8F4+0x74+e0*4,2,w,1,{printf "db5 w %8x %8x %8x ",wpaddr,wpdata,pc;g}
wp FFC8F4+0x74+e0*5,2,w,1,{printf "db5 w %8x %8x %8x ",wpaddr,wpdata,pc;g}
wp FFC8F4+0x74+e0*6,2,w,1,{printf "db5 w %8x %8x %8x ",wpaddr,wpdata,pc;g}
wp FFC8F4+0x74+e0*7,2,w,1,{printf "db5 w %8x %8x %8x ",wpaddr,wpdata,pc;g}