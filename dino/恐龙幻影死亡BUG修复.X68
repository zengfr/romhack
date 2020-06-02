		org		$81a92
		jmp		$106740
		org		$106740
		cmpi.b  #$6, ($4d9,A5)
		bne     _clr
		cmpi.b  #$3, ($786,A5)
		bne     _clr
		jmp     _no_clr
_clr
		clr.w   ($c6,A6)
_no_clr
		movea.w ($c6,A6),A0
		clr.w   ($6e,A6)
		jmp     $81a9a



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
https://github.com/zengfr/romhack
https://gitee.com/zengfr/romhack
