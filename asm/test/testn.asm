;NASM "Hello World!", run in CMD or DOS.
 
;编译链接命令：
 
;      nasm hello.asm -o hello.com
section .text
global main
  org 100h
main:
  mov  ax, cs
  mov  ds, ax
  mov  ah, 9          ;9号调用
  mov  dx, msge    ;字符串的首地址送入dx
  int     21h            ;输出字符串
  mov  ah, 4ch       ;4ch号调用
  int     21h            ;结束
msge: 
 db 'Hello World!',0dh,0ah,'$'
 