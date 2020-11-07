;https://github.com/mamedev/mame/blob/388d6c34b2d30fff2924e94035077ab0d184841f/src/mame/konami/vendetta.cpp
;b682=3682
;https://github.com/Arakula/A09/blob/master/a09.c
start
  ORG $b682
  jsr _Weapon
  ORG $7f00
_Weapon
  lda #$02
  sta #$20 , x
  rts
 