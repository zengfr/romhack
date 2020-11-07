*-----------------------------------------------------------
* 名称       :
* 说明       :
* 制作       :
*-------------------————更换关卡——————————————————--—  
     ORG  $abec
     jsr $101600
     ORG  $101600
     clr.b $ffffac
     andi.b #$7,($4d9,a5)
     rts    
     
     

     
     ORG  $20448
     jsr $101490
     
     ORG  $101490
     cmp.b #$3e,$ffffac
     beq _cycg
    movem.l d0-d7/a0-a6,-(a7)
    move.b #$3e,$ffffac
    move.b #$6,($4d9,a5)        //更换为8关3场景 
    move.b #$3,($786,a5)        //  
    jsr $8a44                   //载入色板？
    jsr $892c                   //设置亮度
    move.b #$c,($4d0,a5)
    jsr $2228a                  //加载场景
    jsr $162ae
    movem.l (a7)+,d0-d7/a0-a6   
    rts      
_cycg
    jsr $206d4
    rts
   

*-------------------幻影过关检测---------------------------------    
    ORG  $ad66                       //唯一的开始游戏清理数据   
    jsr $106f80

    ORG  $106f80
    jsr $89e6
    clr.l $ffffb0
    clr.b $ffffac
    rts

    ORG  $8190e                        //这里决定出幻影个数
    jmp $102ca0
    
    ORG  $102ca0
    add.b #1,$ffffb0
    clr.l d0                       //X坐标
    clr.l d1                       //Y坐标
    clr.l d2                       //对应归属地址偏移
    movem.l d0-d7/a0-a6,-(a7)
    move.w #$580,d0                //1倍幻影  
    move.w #$40,d1                 //40居中
    move.w #$a0,d2
    jsr $102f50
    cmpi.b #1,$ffffb0
    BLE _zfh
    move.w #$580,d0                //2倍幻影   
    move.w #$30,d1                 //
    move.w #$a2,d2
    jsr $102f50    
    cmpi.b #2,$ffffb0
    BLE _zfh  
    move.w #$580,d0                //3倍幻影 
    move.w #$20,d1                 //
    move.w #$a4,d2
    jsr $102f50     
    cmpi.b #4,$ffffb0
    BLE _zfh
    move.w #$500,d0                //4倍幻影 
    move.w #$50,d1                 //
    move.w #$a6,d2
    jsr $102f50     
    cmpi.b #6,$ffffb0
    BLE _zfh
    move.w #$500,d0                //5倍幻影 
    move.w #$10,d1                 //
    move.w #$a6,d2
    jsr $102f50     
    cmpi.b #7,$ffffb0
    BLE _zfh
    move.w #$540,d0                //6倍幻影 
    move.w #$40,d1                 //
    move.w #$a6,d2
    jsr $102f50     
    cmpi.b #8,$ffffb0
    BLE _zfh 
    move.w #$540,d0                //7倍幻影 
    move.w #$20,d1                 //
    move.w #$a6,d2
    jsr $102f50     
    cmpi.b #9,$ffffb0
    BLE _zfh
    move.w #$540,d0                //8倍幻影 
    move.w #$30,d1                 //
    move.w #$a6,d2
    jsr $102f50         
_zfh    
    movem.l (a7)+,d0-d7/a0-a6
    rts
    

    ORG  $102f50
    jsr $483c                          //申请内存
    bcs _nomorr                        //内存占满
    move.b #$1,($0,a0)                 //
    move.w #$11c,($20,a0)              //加怪物ID
    move.w d0,($8,a0)               //X坐标
    move.w d1,($10,a0)               //Y坐标
    move.w a6,($c6,a0)                 //加归属体
    cmpi.w #$a4,d2
    BGT _nomorr
    move.w a0,(a6,d2)                 //归属地址加到主体过关要用到    
    addq.b #1,($aa,a6)                 //归属个数加到主体过关要用到
_nomorr    
    rts



    ORG  $5c878                        //幻影血处理
    jsr $105000
    
    ORG  $105000
    cmpi.b #2,$ffffb0
    BLE _1fyx
    cmpi.b #3,$ffffb0
    beq _2fyx
    cmpi.b #4,$ffffb0
    beq _1fyx
    cmpi.b #5,$ffffb0
    beq _2fyx
    cmpi.b #6,$ffffb0
    beq _1fyx
    jmp _2fyx
_1fyx    
    move.w #$320,($6c,a6)   //8管320
    move.w #$320,($6e,a6)   //8管320
    jmp _xlfh
_2fyx    
    move.w #$258,($6c,a6)   //6管258
    move.w #$258,($6e,a6)   //6管258     
_xlfh
    move.w ($6c,a6),($be,a6)   
    rts





    ORG  $819f6                        //幻影血处理
    jsr $105100
    
    ORG  $105100
    cmpi.b #$a,$ffffb0
    BLT _tgfh
    move.b #$7,$ff84d9
_tgfh    
    jsr $acee
    rts


    ORG  $fe5a                    //条件掉宝特殊处理程序
    jsr $105200
    ORG  $105200
    move.b ($f,a2),($96,a0)
    cmp.l #$b0d22,a2              //关底箱子
    BLT _kcpz
    cmp.l #$b0d62,a2
    BGT _kcpz
    cmpi.b #1,$ffffb0
    BLE _pt
    jmp _m16
_kcpz
    cmp.l #$b0d72,a2              //关底胖子
    BLT _fxzpz
    cmp.l #$b0dc2,a2
    BGT _fxzpz
    cmpi.b #1,$ffffb0
    BLE _kx
    jmp _zx
_fxzpz
    cmp.l #$b5328,a2              //幻影战掉血的胖子
    beq _fxzpzw
    cmp.l #$b53f0,a2
    beq _fxzpzw
    cmp.l #$b5596,a2
    beq _fxzpzw
    cmp.l #$b56ba,a2
    beq _fxzpzw
    jmp _dbfh
_fxzpzw
    cmpi.b #1,$ffffb0
    beq _kx
    cmpi.b #2,$ffffb0
    beq _xx
    cmpi.b #6,$ffffb0
    BLE _zx
    jmp _dx  
_pt    
    move.b #$21,($96,a0)           //炮
    jmp _dbfh
_m16    
    move.b #$8,($96,a0)           //M16
    jmp _dbfh
_kx
    move.b #$0,($96,a0)           //空血
    jmp _dbfh
_xx
    move.b #$3,($96,a0)           //小血
    jmp _dbfh   
_zx
    move.b #$35,($96,a0)           //中血
    jmp _dbfh
_dx
    move.b #$b,($96,a0)           //大血    
_dbfh    
    rts


*    ORG  $24b50                        //箱子掉宝
*    jsr $105300


*    ORG  $105300
*    movea.l #$b64f2,A1
*    rts 












*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
