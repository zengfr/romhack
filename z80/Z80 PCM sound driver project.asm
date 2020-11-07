https://github.com/zengfr/romhack
https://gitee.com/zengfr/romhack
; BC = bank register

COUNTER     EQU     $1FF0           ; 16 bits counter
COMM_CH0    EQU     $1FFE           ; FF = done, < 80 = SFX ID to play
COMM_CH1    EQU     $1FFF           ; FF = done, < 80 = SFX ID to play

FM_ACCESS   EQU     $1FFD           ; indicate that Z80 is accessing DAC register (00 = ok, 2A = DAC access)

CH0_PRIO    EQU     $1FE0           ; channel 0 priority
CH0_LEN     EQU     $1FE1           ; channel 0 length (2 bytes: LH)
CH0_ADDR    EQU     $1FE3           ; channel 0 address (3 bytes: LMH)

CH1_PRIO    EQU     $1FE8           ; channel 1 priority
CH1_LEN     EQU     $1FE9           ; channel 1 length (2 bytes: LH)
CH1_ADDR    EQU     $1FEB           ; channel 1 address (3 bytes: LMH)

            ORG     $0000

init
            DI                      ; disable ints
            IM      $01             ; set int mode 1
            LD      SP, $1000       ; setup stack

            ld      A,0xff
            ld      (COMM_CH0),a        ; clear command ch 0
            ld      (COMM_CH1),a        ; clear command ch 1

            ld      hl,(0x1001)         ; load empty sample param
            ld      (CH0_ADDR),hl
            ld      (CH1_ADDR),hl
            ld      a,(0x1003)
            ld      (CH0_ADDR+2),a
            ld      (CH1_ADDR+2),a
            ld      bc,0x6000           ; init BC

loop
            ld      hl,(COUNTER)
            inc     hl                  ; inc counter
            ld      (COUNTER),hl        ;                                       =38

do_com0
            ld      a,(COMM_CH0)
            or      a                   ; read command channel 0
            jp      m,do_com1           ; if (a & 0x80) goto do_com1            =27

            ld      l,a                 ; A = SFX ID
            ld      h,0x00
            add     hl,hl
            add     hl,hl
            add     hl,hl
            ex      de,hl
            ld      ix,0x1000
            add     ix,de               ; IX = SFX DATA ADDR                    =+77

            ld      a,(CH0_PRIO)
            ld      e,a                 ; E = old prio
            ld      a,(ix+0)            ; A = new prio                          =+36

            cp      e                   ; if (new_prio > old_prio)
            jr      c,com0_done         ; {                                     =+11/16

            ld      (CH0_PRIO),a        ;   load prio
            ld      l,(ix+4)
            ld      h,(ix+5)
            ld      (CH0_LEN),hl        ;   load lenght
            ld      l,(ix+1)
            ld      h,(ix+2)
            ld      (CH0_ADDR),hl       ;   load address
            ld      a,(ix+3)
            ld      (CH0_ADDR+2),a      ; }                                     =+153

com0_done
            ld      a,0xff
            ld      (COMM_CH0),a        ; command channel 0 done                =+20

do_com1
            ld      a,(COMM_CH1)
            or      a                   ; read command channel 1
            jp      m,set_bank0         ; if (a & 0x80) goto set_bank0          =27

            ld      l,a                 ; A = SFX ID
            ld      h,0x00
            add     hl,hl
            add     hl,hl
            add     hl,hl
            ex      de,hl
            ld      ix,0x1000
            add     ix,de               ; IX = SFX DATA ADDR                    =+77

            ld      a,(CH1_PRIO)
            ld      e,a                 ; E = old prio
            ld      a,(ix+0)            ; A = new prio                          =+36

            cp      e                   ; if (new_prio > old_prio)
            jr      c,com1_done         ; {                                     =+11/16

            ld      (CH1_PRIO),a        ;   load prio
            ld      l,(ix+4)
            ld      h,(ix+5)
            ld      (CH1_LEN),hl        ;   load lenght
            ld      l,(ix+1)
            ld      h,(ix+2)
            ld      (CH1_ADDR),hl       ;   load address
            ld      a,(ix+3)
            ld      (CH1_ADDR+2),a      ; }                                     =+153

com1_done
            ld      a,0xff
            ld      (COMM_CH1),a        ; command channel 1 done                =+20

set_bank0
            ld      hl,(CH0_ADDR)       ; HL = sample 0 addr (ML)
            ld      a,h
            rlca
            ld      (bc),a              ; bank = addr bit 15                    =31

            ld      a,(CH0_ADDR+2)      ; A = sample 0 addr (H)
            ld      (bc),a              ; bank = addr bit 16
            rrca
            ld      (bc),a
            rrca
            ld      (bc),a
            rrca
            ld      (bc),a
            rrca
            ld      (bc),a
            rrca
            ld      (bc),a
            rrca
            ld      (bc),a
            rrca
            ld      (bc),a              ; bank = addr bit 23                    =97

read0
            set     7,h                 ; HL = sample ch0 addr banked
            ld      a,(hl)
            ex      af,af'              ; A' = sample ch0                       =19

set_bank1
            ld      hl,(CH1_ADDR)       ; HL = sample 1 addr (ML)
            ld      a,h
            rlca
            ld      (bc),a              ; bank = addr bit 15                    =31

            ld      a,(CH1_ADDR+2)      ; A = sample 1 addr (H)
            ld      (bc),a              ; bank = addr bit 16
            rrca
            ld      (bc),a
            rrca
            ld      (bc),a
            rrca
            ld      (bc),a
            rrca
            ld      (bc),a
            rrca
            ld      (bc),a
            rrca
            ld      (bc),a
            rrca
            ld      (bc),a              ; bank = addr bit 23                    =97

read1
            set     7,h                 ; HL = sample ch1 addr banked           =8

            ld      de,FM_ACCESS
            ld      a,0x2a
            ld      (de),a              ; indicate Z80 is accessing YM DAC register
            ld      (0x4000),a          ; prepare DAC write                     =37

mix
            ex      af,af'              ; A = sample ch0 (7 bits)
            add     a,(hl)              ; A = mixed sample (8 bits)
            rra                         ; A = mixed sample (7 bits)
            ld      (0x4001),a          ; write sample to DAC                   =28

            xor     a
            ld      (de),a              ; Z80 release YM access                 =11

update0
            ld      hl,(CH0_LEN)        ; HL = ch0.len
            ld      a,h
            or      l                   ; if (ch0.len == 0)
            jr      z,play_fixed0       ;   goto play_fixed0                    =31

            dec     hl
            ld      (CH0_LEN),hl        ; ch0.len--
            ld      a,h
            or      l                   ; if (ch0.len == 0)
            jr      z,play_done0        ;   goto play_done0                     =37

            ld      hl,CH0_ADDR
            inc     (hl)                ; ch0.addr.l++
            jr      nz,play_done0_1                                             =28

            ld      hl,(CH0_ADDR+1)
            inc     hl                  ; ch0.addr.mh++
            ld      (CH0_ADDR+1),hl
            jp      update1             ; goto update1                          =48

play_fixed0
            ld      a,0x05
play_f0_wait
            dec     a
            jr      nz,play_f0_wait                                             =+87+5

            nop                         ; waste some cycles
            jr      update1             ; goto update_ch1                       =+16

play_done0
            xor     a
            ld      (CH0_PRIO),a        ; no more playing ch0
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            jr      update1             ; waste some cycles                     =+61+5

play_done0_1
            ld      a,0x00
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop                         ; waste some cycles                     =+43+5

update1
            ld      hl,(CH1_LEN)        ; HL = ch1.len
            ld      a,h
            or      l                   ; if (ch1.len == 0)
            jr      z,play_fixed1       ;   goto play_fixed1                    =31

            dec     hl
            ld      (CH1_LEN),hl        ; ch1.len--
            ld      a,h
            or      l                   ; if (ch1.len == 0)
            jr      z,play_done1        ;   goto play_done1                     =37

            ld      hl,CH1_ADDR
            inc     (hl)                ; ch1.addr.l++
            jr      nz,play_done0_1                                             =28

            ld      hl,(CH1_ADDR+1)
            inc     hl                  ; ch1.addr.mh++
            ld      (CH1_ADDR+1),hl
            jp      next                ; goto next                             =48
; note that in the original driver it was jumping to 'update1' instead
; that is probably a copy/paste bug and lead to some missed sample

play_fixed1
            ld      a,0x05
play_f1_wait
            dec     a
            jr      nz,play_f1_wait                                             =+87+5

            nop                         ; waste some cycles
            jr      next                ; goto next                             =+16

play_done1
            xor     a
            ld      (CH1_PRIO),a        ; no more playing ch1
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            jr      next                ; waste some cycles                     =+61+5

play_done1_1
            ld      a,0x00
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop                         ; waste some cycles                     =+43+5

next
            jp loop                                                             =10

                                        ; total cycles per loop = 749 ~ 4.8 Khz

            BLOCK   $1000-$

; SFX DATA
; --------
; format : PP AA AA AA LL LL 00 00
; PP = priority
; AA = address (LMH)
; LL = length (LH)
;
; 001000    00 00 00 28 52 05 00 00         SFX 0
;           00 52 05 28 e7 0d 00 00         SFX 1
; 001010    00 39 13 28 b9 05 00 00         .....
;           00 f2 18 28 ca 05 00 00
; 001020    00 bc 1e 28 d1 06 00 00 00 8d 25 28 97 05 00 00
; 001030    00 24 2b 28 c8 05 00 00 00 ec 30 28 fe 06 00 00
; 001040    00 ea 37 28 70 01 00 00 00 5a 39 28 c7 03 00 00
; 001050    00 21 3d 28 95 04 00 00 00 b6 41 28 b6 03 00 00
; 001060    00 6c 45 28 85 05 00 00 00 f1 4a 28 08 0a 00 00
; 001070    00 f9 54 28 de 09 00 00 00 d7 5e 28 20 07 00 00
; 001080    00 f7 65 28 03 05 00 00 00 fa 6a 28 8b 06 00 00
; 001090    00 85 71 28 fd 0c 00 00 00 82 7e 28 82 04 00 00
; 0010a0    02 04 83 28 f5 02 00 00 02 f9 85 28 3b 04 00 00
; 0010b0    02 34 8a 28 50 07 00 00 02 84 91 28 6a 03 00 00
; 0010c0    02 ee 94 28 6d 04 00 00 02 5b 99 28 d6 06 00 00
; 0010d0    02 31 a0 28 d1 01 00 00 01 02 a2 28 30 03 00 00
; 0010e0    02 32 a5 28 d1 08 00 00 01 03 ae 28 37 02 00 00
; 0010f0    02 3a b0 28 45 05 00 00 02 7f b5 28 ca 07 00 00
; 001100    02 49 bd 28 bb 14 00 00 02 04 d2 28 67 0c 00 00
; 001110    02 6b de 28 69 15 00 00 02 d4 f3 28 b4 08 00 00
; 001120    02 88 fc 28 5a 14 00 00 02 e2 10 29 9b 13 00 00
; 001130    02 7d 24 29 09 10 00 00 03 86 34 29 7f 1b 00 00
; 001140    02 05 50 29 44 17 00 00 02 49 67 29 6e 02 00 00
; 001150    02 b7 69 29 e1 1a 00 00 03 98 84 29 63 17 00 00
; 001160    02 fb 9b 29 2e 05 00 00 03 29 a1 29 be 0b 00 00
; 001170    03 e7 ac 29 cd 14 00 00 02 b4 c1 29 e1 0b 00 00
; 001180    02 95 cd 29 5c 1b 00 00 02 f1 e8 29 49 12 00 00
; 001190    02 3a fb 29 7b 1b 00 00 02 b5 16 2a ec 03 00 00
; 0011a0    02 a1 1a 2a fd 06 00 00 03 9e 21 2a f7 26 00 00
; 0011b0    02 95 48 2a 98 23 00 00 01 2d 6c 2a 3b 1f 00 00
; 0011c0    02 68 8b 2a 4c 1a 00 00 02 b4 a5 2a 50 0e 00 00
; 0011d0    02 04 b4 2a 30 10 00 00 02 34 c4 2a 9d 10 00 00
; 0011e0    02 d1 d4 2a 43 05 00 00 02 14 da 2a 27 06 00 00
; 0011f0    02 3b e0 2a a0 09 00 00 02 db e9 2a c9 0a 00 00
; 001200    02 a4 f4 2a 46 0e 00 00 02 ea 02 2b 44 0b 00 00
; 001210    02 2e 0e 2b b9 0e 00 00 02 e7 1c 2b 57 0a 00 00
; 001220    02 3e 27 2b ae 10 00 00 02 ec 37 2b 89 09 00 00
; 001230    02 75 41 2b fa 0d 00 00 02 6f 4f 2b 2b 0f 00 00
; 001240    03 9a 5e 2b 82 0b 00 00 03 1c 6a 2b 42 07 00 00
; 001250    03 5e 71 2b a2 0b 00 00 03 00 7d 2b 15 0c 00 00
; 001260    02 15 89 2b e0 0c 00 00 02 f5 95 2b e2 09 00 00
; 001270    02 d7 9f 2b f1 0a 00 00 02 c8 aa 2b 67 0f 00 00
; 001280    02 2f ba 2b 92 0f 00 00 02 c1 c9 2b 43 13 00 00
; 001290    02 04 dd 2b 34 0f 00 00 02 38 ec 2b ef 14 00 00
; 0012a0    02 27 01 2c d5 21 00 00 02 fc 22 2c 1f 23 00 00
; 0012b0    ff 1b 46 2c 01 00 00 00 ff ff ff ff ff ff ff ff
; 0012c0    ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
; ...
; 0013f0    ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
;
; NOT USED
; 001400    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
; ...

; VARIABLES
; 001fe0    00 00 00 00 00 28 00 00 00 00 00 00 00 28 00 00
; 001ff0    53 30 00 00 00 00 00 00 00 00 00 00 00 00 ff ff

https://github.com/zengfr/romhack
https://gitee.com/zengfr/romhack