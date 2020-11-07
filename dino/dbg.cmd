bpclear
wpclear
bp fcd2,1,{printf "%8x table1 %8x a0:%8x a2:%8x %8x %8x %8x %2x",frame,pc,a0,a2,maincpu.pw@(a2+02),maincpu.pw@(a2+04),maincpu.pw@(a2+0A),maincpu.pw@(fff890);g}

bp fe36,1,{printf "%8x table2 %8x a0:%8x a2:%8x %8x %8x %8x %2x",frame,pc,a0,a2,maincpu.pw@(a2+02),maincpu.pw@(a2+04),maincpu.pw@(a2+0A),maincpu.pw@(fff890);g}

bp fef4,1,{printf "%8x table3 %8x a0:%8x a2:%8x %8x %8x %8x %2x",frame,pc,a0,a2,maincpu.pw@(a2+02),maincpu.pw@(a2+04),maincpu.pw@(a2+0A),maincpu.pw@(fff890);g}

wp ff84d9,1,w,1,{printf "%8x gk w %8x %4x a0:%8x %8x d0:%4x %4x",frame,pc,wpdata,a0,a1,d0,d1;g}
wp ff84d9,1,r,1,{printf "%8x gk r %8x %4x a0:%8x %8x d0:%4x %4x",frame,pc,wpdata,a0,a1,d0,d1;g}
wp ff8786,2,w,1,{printf "%8x cj w %8x %4x a0:%8x %8x d0:%4x %4x",frame,pc,wpdata,a0,a1,d0,d1;g}
wp ff8786,2,r,1,{printf "%8x cj r %8x %4x a0:%8x %8x d0:%4x %4x",frame,pc,wpdata,a0,a1,d0,d1;g}

wp ff8744,2,w,1,{printf "%8x jz0w %8x %4x a0:%8x %8x d0:%4x %4x",frame,pc,wpdata,a0,a1,d0,d1;g}
wp ff8744,2,r,1,{printf "%8x jz0r %8x %4x a0:%8x %8x d0:%4x %4x",frame,pc,wpdata,a0,a1,d0,d1;g}
wp ff8864,2,w,1,{printf "%8x jz1w %8x %4x a0:%8x %8x d0:%4x %4x",frame,pc,wpdata,a0,a1,d0,d1;g}
wp ff8864,2,r,1,{printf "%8x jz1r %8x %4x a0:%8x %8x d0:%4x %4x",frame,pc,wpdata,a0,a1,d0,d1;g}

wp ffe7c0,2,w,1,{printf "%8x objw %8x %4x a0:%8x %8x d0:%4x %4x",frame,pc,wpdata,a0,a1,d0,d1;g}
wp ffe7c0,2,r,1,{printf "%8x objr %8x %4x a0:%8x %8x d0:%4x %4x",frame,pc,wpdata,a0,a1,d0,d1;g}