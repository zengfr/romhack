bpclear
wpclear
bp fcd2,1,{printf "%8x table1 %8x a0:%8x a2:%8x %8x %8x %8x %2x",frame,pc,a0,a2,maincpu.pw@(a2+02),maincpu.pw@(a2+04),maincpu.pw@(a2+0A),maincpu.pw@(fff890);g}

bp fe36,1,{printf "%8x table2 %8x a0:%8x a2:%8x %8x %8x %8x %2x",frame,pc,a0,a2,maincpu.pw@(a2+02),maincpu.pw@(a2+04),maincpu.pw@(a2+0A),maincpu.pw@(fff890);g}

bp fef4,1,{printf "%8x table3 %8x a0:%8x a2:%8x %8x %8x %8x %2x",frame,pc,a0,a2,maincpu.pw@(a2+02),maincpu.pw@(a2+04),maincpu.pw@(a2+0A),maincpu.pw@(fff890);g}

wp ff84d9,1,w,1,{printf "%8x gk w %8x %4x a0:%8x %8x d0:%4x %4x",frame,pc,wpdata,a0,a1,d0,d1;g}
wp ff84d9,1,r,pc!=20434 && pc!=2089e && pc!=208aa && pc!=208ec && pc!=22e28,{printf "%8x gk r %8x %4x a0:%8x %8x d0:%4x %4x",frame,pc,wpdata,a0,a1,d0,d1;g}
wp ff8786,2,w,1,{printf "%8x cj w %8x %4x a0:%8x %8x d0:%4x %4x",frame,pc,wpdata,a0,a1,d0,d1;g}
wp ff8786,2,r,1 && pc!=20b6c && pc!=22e30,{printf "%8x cj r %8x %4x a0:%8x %8x d0:%4x %4x",frame,pc,wpdata,a0,a1,d0,d1;g}

wp ff8744,2,w,1 && pc!=2126a,{printf "%8x jz0w %8x %4x a0:%8x %8x d0:%4x %4x",frame,pc,wpdata,a0,a1,d0,d1;g}
wp ff8744,2,r,1 && pc!=174c && pc!=1712 && pc!=208fe && pc!=20abe && pc!=20a2a && pc!=20a34 && pc!=21272 && pc!=212a0 && pc!=22e1a && pc!=12c9c && pc!=13fcc && pc!=fc9c && pc!=fd24  && pc!=6e6  && pc!=186ec  && pc!=4fde  && pc!=1712  && pc!=56bfa  && pc!=56bfe  && pc!=56bb8  && pc!=56bbc && pc!=7bc18 && pc!=20f1a,{printf "%8x jz0r %8x %4x a0:%8x %8x d0:%4x %4x",frame,pc,wpdata,a0,a1,d0,d1;g}
wp ff8864,2,w,1 && pc!=6e8,{printf "%8x jz1w %8x %4x a0:%8x %8x d0:%4x %4x",frame,pc,wpdata,a0,a1,d0,d1;g}
wp ff8864,2,r,1 && pc!=6da,{printf "%8x jz1r %8x %4x a0:%8x %8x d0:%4x %4x",frame,pc,wpdata,a0,a1,d0,d1;g}

wp ffe7c0,2,w,1 && pc!=49e6 && pc!=10476 && pc!=14076,{printf "%8x objw %8x %4x a0:%8x %8x d0:%4x %4x",frame,pc,wpdata,a0,a1,d0,d1;g}
wp ffe7c0,2,r,1  && pc!=14006  && pc!=1404e  && pc!=14ec4  && pc!=14076 && pc!=49e6,{printf "%8x objr %8x %4x a0:%8x %8x d0:%4x %4x",frame,pc,wpdata,a0,a1,d0,d1;g}