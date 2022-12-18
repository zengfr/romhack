题目
 希望你实现的系统有以下功能：

类似于文本编辑器，在屏幕中打印输入的字符，按下回车能换行，按下退格能删除（而且要能回到上一行）
注意，所有功能都不能依赖操作系统，也就是说，你得自己写一个。

题解
org 07c00h 
mov ax, cs
mov ds, ax 
mov es, ax 
call main 
jmp $  

main:
	mov dh, 0
	mov dl, 0
	call gets
	
gets:
	mov ah, 0
	int 16h    ; keyboard input
	
	cmp al, 20h
	jb control ; control character if ASCII <= 0x20
	
	mov ah, 0eh
	int 10h
	
	jmp gets
	
control:
	cmp ah, 0eh
	je backspace
	cmp ah, 1ch
	je newline
	jmp gets

backspace:
	; get cursor
	mov ah, 3h
	mov bh, 0h
	int 10h
	
	cmp dl, 0h
	je backline
	
	; unwind cursor
	mov ah, 2h
	dec dl
	int 10h
	; blank character
	mov ah, 0eh
	mov al, ' '
	int 10h
	; rewind cursor
	mov ah, 2h
	int 10h
	
	jmp gets
	
backline:
	; do nothing if first line
	cmp dh, 0
	je gets
	
	; unwind cursor
	mov ah, 2h
	pop dx    ; load last line
	int 10h
	
	jmp gets
	
newline:
	; get cursor
	mov ah, 3h
	mov bh, 0h
	int 10h
	; move cursor to newline
	mov ah, 2h
	push dx   ; store this line
	inc dh    ; line feed
	mov dl, 0 ; carriage return
	int 10h
	
	jmp gets



times 510-($-$$) db 0
dw 0xaa55