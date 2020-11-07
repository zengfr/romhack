;https://github.com/mamedev/mame/blob/388d6c34b2d30fff2924e94035077ab0d184841f/src/mame/konami/vendetta.cpp
;https://github.com/mamedev/mame/tree/master/src/devices/cpu/m6809 ;case 0x39:	%RTS;
;https://github.com/mamedev/mame/blob/master/src/devices/cpu/m6809/konami.ops ;case 0x8F:	%RTS;
;https://github.com/Arakula/A09/blob/master/a09.c  { "RTS",     OPCAT_ONEBYTE,     0x39 }
;https://github.com/sho3string/a09-konami-cross-assembler
;b682=3682
;start 
		org $b682
		jsr change_Weapon
		rts ;
		rts ;
		org $7f00
change_Weapon:
		lda #$02
		sta #$20 , x
		rts
		rts
		rts
;org $b682
;ffff-(b682-7f00)
; LBSR  $7f00    ;ab c8 7b
;org $7f00
;   lda #$05     ;10 05
;   sta #$20 , x ;3a 24 20
;   rts          ;8f

;maincpu.rd@b682=abc87b3a
;maincpu.pw@7f00=1005
;maincpu.pd@7f02=3a24208f