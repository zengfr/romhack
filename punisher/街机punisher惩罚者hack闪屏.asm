    ;去除后目测依然闪屏
    ;更多资料下载:
https://github.com/zengfr/romhack
https://gitee.com/zengfr/romhack
	org $14c98 ;去除精灵100限制
    move.w  #$2F00,-$2482(a5)
    org $9a4b6 ;去除精灵100限制
    move.w  #$2F00,-$2482(a5)