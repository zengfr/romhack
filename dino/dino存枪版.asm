	;持枪和拳击分离，持枪同时不影响拳击 ; https://github.com/zengfr/romhack
	org $6598
	bcc.w   *+4
	moveq   #2,d0

	org $117cc
	nop
	nop
	
	org $191e4
	jmp $193CE
	
	 
	org $191f0
	jmp loc_180000 
	
	org $19376
	jmp $193CE
	
	org $19382
	jmp loc_18002C
	
	org $196de
	nop
	nop
	nop
	nop
	
	org $19b36
	andi.w  #$40,d0 ;原来 andi.w  #$10,d0 
	
	org $19bf4
	andi.w  #$40,d0
	
	org $19c74
	btst    #6,$A0(a6) ;原来 btst    #4,$A0(a6)
	
	org $1A08A
	jmp     loc_180058
	
	org $1a178
	beq.w   $1A09E
	
	org $1a188
	bne.w   $1A09E
	
	org $1ab14
	nop
	nop
	nop
	nop
	
	org $1c26c
	nop
	nop
	
	org $1c44c
	nop
	nop
	org $1cc96
	nop
	nop
	
	org $2467E
	tst.w   $A4(a6)
	
	org $248b6
	move.l  #$2000000,4(a6) ;原来 move.l  #$2000200,4(a6)
	
	org $2493a
	move.l  #$2000000,4(a6)
	
	org $249e4
	tst.w   $A4(a6) ;原来 subq.w  #1,$A4(a6)
    org $25212
    tst.w   $6C(a6)
	org $252fe
	tst.w   $6C(a6)
	org $2556a
    tst.w   $6C(a6) ;原来 subq.w  #1,$6C(a6)
	org $256d0
	tst.w   $6C(a6)
	org $257de
	tst.w   $6C(a6) 
	org $25902
	tst.w   $6C(a6) 
	
	org $180000
loc_180000:                             ; CODE XREF: sub_63AA:loc_191F0↑j
                 move.w  d1,d0           ; Move Data from Source to Destination
                 andi.w  #$40,d0 ; '@'   ; AND Immediate
                 beq.w   loc_180012      ; Branch if Equal
                 move.w  $B6(a6),d0      ; Move Data from Source to Destination
                 bne.w   loc_180020      ; Branch if Not Equal
 
loc_180012:                             ; CODE XREF: sub_63AA+179C5C↑j
                andi.w  #$20,d1 ; ' '   ; AND Immediate
                beq.w   loc_180026      ; Branch if Equal
                jmp     $191F8       ; Jump
; ---------------------------------------------------------------------------

loc_180020:                             ; CODE XREF: sub_63AA+179C64↑j
                jmp     $198DC       ; Jump
; ---------------------------------------------------------------------------

loc_180026:                             ; CODE XREF: sub_63AA+179C6C↑j
                jmp     $19210       ; Jump
; ---------------------------------------------------------------------------

loc_18002C:                             ; CODE XREF: sub_63AA:loc_19382↑j
                move.w  d1,d0           ; Move Data from Source to Destination
                andi.w  #$40,d0 ; '@'   ; AND Immediate
                beq.w   loc_18003E      ; Branch if Equal
                move.w  $B6(a6),d0      ; Move Data from Source to Destination
                bne.w   loc_18004C      ; Branch if Not Equal

loc_18003E:                             ; CODE XREF: sub_63AA+179C88↑j
                andi.w  #$20,d1 ; ' '   ; AND Immediate
                beq.w   loc_180052      ; Branch if Equal
                jmp     $191F8       ; Jump
; ---------------------------------------------------------------------------

loc_18004C:                             ; CODE XREF: sub_63AA+179C90↑j
                jmp     $198DC       ; Jump
; ---------------------------------------------------------------------------

loc_180052:                             ; CODE XREF: sub_63AA+179C98↑j
                jmp     $193A2       ; Jump
; ---------------------------------------------------------------------------

loc_180058:                             ; CODE XREF: sub_63AA+13CE0↑j
                btst    #4,$A8(a6)      ; Test a Bit
                bne.w   loc_18007C      ; Branch if Not Equal
                btst    #5,$A8(a6)      ; Test a Bit
                bne.w   loc_180082      ; Branch if Not Equal
                btst    #6,$A8(a6)      ; Test a Bit
                bne.w   loc_180088      ; Branch if Not Equal
                jmp     $1A09E       ; Jump
; ---------------------------------------------------------------------------

loc_18007C:                             ; CODE XREF: sub_63AA+179CB4↑j
                jmp     $19720       ; Jump
; ---------------------------------------------------------------------------

loc_180082:                             ; CODE XREF: sub_63AA+179CBE↑j
                jmp     $1A906       ; Jump
; ---------------------------------------------------------------------------

loc_180088:                             ; CODE XREF: sub_63AA+179CC8↑j
                jmp     $1A174       ; Jump