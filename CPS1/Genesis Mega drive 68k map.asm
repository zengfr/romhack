; ====================================================================
; ----------------------------------------------------------------
; Genesis / Mega drive 68k map
; ----------------------------------------------------------------

sys_exram	equ	$200000		; External RAM
z80_cpu		equ	$A00000		; Z80 CPU RAM, size: $2000
ym_ctrl_1	equ	$A04000		; YM2612 Reg 1, channels 1-3
ym_data_1	equ	$A04001		; YM2612 Reg 2
ym_ctrl_2	equ	$A04002		; YM2612 Reg 1, channels 4-6
ym_data_2	equ	$A04003		; YM2612 Reg 2
sys_io		equ	$A10001		; bits: OVRSEAS(7)|PAL(6)|DISK(5)|VER(3-0)
sys_data_1	equ	$A10003		; Port 1 DATA
sys_data_2	equ	$A10005		; Port 2 DATA
sys_data_3	equ	$A10007		; Modem DATA
sys_ctrl_1	equ	$A10009		; Port 1 CTRL
sys_ctrl_2	equ	$A1000B		; Port 2 CTRL
sys_ctrl_3	equ	$A1000D		; Modem CTRL
sys_tmss	equ	$A14000		; Write "SEGA" here if ver > 0
z80_bus 	equ	$A11100		; Only use bit 0 (bit 8 as WORD)
z80_reset	equ	$A11200		; WRITE only ($0000 reset/$0100 cancel)
md_mars_id	equ	$A130EC		; MARS ID "MARS"
md_bank_sram	equ	$A130F1		; Make SRAM visible at $200000
vdp_data	equ	$C00000		; Video data port (mirror: $C00002)
vdp_ctrl	equ	$C00004		; Video control port (mirror: $C00006)
psg_ctrl	equ	$C00011		; PSG Sound port

; ----------------------------------------------------------------
; Genesis / Mega drive Z80 map
; ----------------------------------------------------------------

zym_ctrl_1	equ	$4000		; YM2612 reg 1
zym_data_1	equ	$4001		; YM2612 reg 2
zym_ctrl_2	equ	$4002		; YM2612 reg 1
zym_data_2	equ	$4003		; YM2612 reg 2
zbank		equ	$6000		; ROM BANK 24bits %XXXXXXXX X0000000 00000000
zvdp_data	equ	$7F00		; Video data port
zvdp_ctrl	equ	$7F04		; Video control port
zpsg_ctrl	equ	$7F11		; PSG control

; ----------------------------------------------------------------
; If a SEGA CD is attached
; ----------------------------------------------------------------

syscd_prgram	equ	$020000		; SubCPU PRG-RAM, up to $1FFFF, banked
syscd_wordram	equ	$200000		; WORD-RAM seen in MAIN-CPU
syscd_bus	equ	$A12000		; WORD | Sub-CPU BUS/RESET
syscd_memory	equ	$A12003		; BYTE | Sub-CPU memory mode
syscd_cdcmode	equ	$A12004		; WORD | CDC Mode
syscd_hint	equ	$A12006		; WORD | VDP HBlank jump ($FFxxxx)
syscd_cdchost	equ	$A12008		; WORD | CDC Host
syscd_stopwtch	equ	$A12008		; WORD | Stopwatch
syscd_comm_m	equ	$A1200E		; BYTE | MainCPU R/W comm byte
syscd_comm_s	equ	$A1200F		; BYTE | Sub-CPU Read comm byte
syscd_args_m	equ	$A12010		; DATA | Comm R/W list, max size: $E
syscd_args_s	equ	$A12020		; DATA | Comm Read list, max size: $E

; ----------------------------------------------------------------
; If a 32X is attached
; ----------------------------------------------------------------

sysmars_ID	equ	$A130EC		; MARS ID "MARS"
sysmars_reg	equ	$A15100		; MARS 32X buffer (check for mars_ID first)