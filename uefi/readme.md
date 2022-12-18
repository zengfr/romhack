## ida逆向分析uefi固件之突破u盘机器码加密狗时间限制等游戏外挂,虚拟机完美运行开启游戏外挂设置

### 工具&环境
- ida pro 7.7
- win 10
- gdb 8.3
- VMware Workstation Pro 16
- qemu
- efiXplorer64 + uefi_analyser
### 背景
- 游戏外挂单台机器按天收费50-100不等 价值不菲 工作室和网吧成本很高
- 游戏外挂 绑定固定U盘 绑定电脑机器，固件按机器自定义编译并加密，换机器无法启动和使用。每个固件差异很大 算法不一样。
- uefi开机固件 相当于BIOS ，先于系统启动 在系统引导之前
- uefi启动自动检测时间过期和机器码和U盘必须插入，验证不过无法启动电脑引导系统
- 验证通过则启动uefi内置游戏外挂程序，进入外挂设置后，退出后 可拔掉u盘，才能启动引导系统
### 目标
- 单固件突破机器码限制 U盘限制 时间限制 去除绑定
- 能任意机器使用
- 虚拟机要能使用
### 难点
-  检测不过 提示字串 自动内存加密  无法直接ida直接静态分析出来
- 需系统引导前gdb中断动态远程调试
- 动态基址 每次不一样 uefi即时分配 内存分页  无法提前设置断点中断
### 视频
- uefi readme https://github.com/zengfr/ida-pro-idb-database/tree/main/demo
- uefi article https://my.oschina.net/zengfr/blog/5606084
- uefi video   https://www.bilibili.com/video/BV1HG4y1V7Ym/
### gdb 参考
    https://github.com/zengfr/ida-pro-idb-database/tree/main/demo/gdb.txt
### 笔记
~~~

https://kagurazakakotori.github.io/ubmp-cn/index.html

Address	Length	  bytes	  bytes
000000000000194	0xa	89 05 66 BE 00 00 32 C0 EB 27 	90 90 90 90 90 90 90 90 90 90 
000000000000264	0x1	8E 	85 
000000000000925	0x1	74 	75 
000000000000B8F	0x1	74 	75 
000000000000B89	0x1	74 	75 
000000000000BAC	0x3	74 09 CC 	90 90 90 
000000000000BB6	0x1	74 	75 
000000000002AA0	0x1	32 	33 
000000000002AA2	0x1	33 	30 
000000000002AA8	0x1	31 	32 

-----------------------------------------------------------------------------------
IN: 
0xfffffff0:  0f 20 c0                 movl     %cr0, %eax
0xfffffff3:  a8 01                    testb    $1, %al
0xfffffff5:  74 05                    je       0xfffc

----------------
IN: 
0xfffffffc:  e9 09 ff                 jmp      0xff08

----------------
IN: 
0xffffff08:  bf 42 50                 movw     $0x5042, %di
0xffffff0b:  eb 0a                    jmp      0xff17

-------------------------------------------------------------------------------------------------
IN: 
0x0704d066:  4c 89 64 24 28           movq     %r12, 0x28(%rsp)
0x0704d06b:  49 89 f1                 movq     %rsi, %r9
0x0704d06e:  48 8d 0d fd 15 00 00     leaq     0x15fd(%rip), %rcx
0x0704d075:  48 89 44 24 20           movq     %rax, 0x20(%rsp)
0x0704d07a:  e8 8a 45 ff ff           callq    0x7041609

----------------
IN: 
0x07045225:  48 8b 05 fc a0 00 00     movq     0xa0fc(%rip), %rax
0x0704522c:  48 8d 53 50              leaq     0x50(%rbx), %rdx
0x07045230:  48 8b 8c 24 88 00 00 00  movq     0x88(%rsp), %rcx
0x07045238:  4c 8d 43 48              leaq     0x48(%rbx), %r8
0x0704523c:  ff 90 d0 00 00 00        callq    *0xd0(%rax)

----------------
IN: 
0x0658b6b0:  48 89 5c 24 08           movq     %rbx, 8(%rsp)
0x0658b6b5:  57                       pushq    %rdi
0x0658b6b6:  48 83 ec 20              subq     $0x20, %rsp
0x0658b6ba:  8b 05 f8 37 00 00        movl     0x37f8(%rip), %eax
0x0658b6c0:  48 8b da                 movq     %rdx, %rbx
0x0658b6c3:  48 8b f9                 movq     %rcx, %rdi
0x0658b6c6:  85 c0                    testl    %eax, %eax
0x0658b6c8:  74 11                    je       0x658b6db
-------------------------------------------------------------------------------------------------

----------------
IN: 
0x07045225:  48 8b 05 fc a0 00 00     movq     0xa0fc(%rip), %rax
0x0704522c:  48 8d 53 50              leaq     0x50(%rbx), %rdx
0x07045230:  48 8b 8c 24 88 00 00 00  movq     0x88(%rsp), %rcx
0x07045238:  4c 8d 43 48              leaq     0x48(%rbx), %r8
0x0704523c:  ff 90 d0 00 00 00        callq    *0xd0(%rax)

----------------
IN: 
0x065a36b0:  48 89 5c 24 08           movq     %rbx, 8(%rsp)
0x065a36b5:  57                       pushq    %rdi
0x065a36b6:  48 83 ec 20              subq     $0x20, %rsp
0x065a36ba:  8b 05 f8 37 00 00        movl     0x37f8(%rip), %eax
0x065a36c0:  48 8b da                 movq     %rdx, %rbx
0x065a36c3:  48 8b f9                 movq     %rcx, %rdi
0x065a36c6:  85 c0                    testl    %eax, %eax
0x065a36c8:  74 11                    je       0x65a36db
---------------------------------------------------------------------------------------------------
0x07ece8fd:  48 31 c0                 xorq     %rax, %rax
0x07ece900:  ff e2                    jmpq     *%rdx

----------------
IN: 
0x07ec2110:  48 85 c0                 testq    %rax, %rax
0x07ec2113:  74 3c                    je       0x7ec2151

----------------
IN: 
0x07ec2151:  48 8b 44 24 20           movq     0x20(%rsp), %rax
0x07ec2156:  48 8b 4c 24 70           movq     0x70(%rsp), %rcx
0x07ec215b:  48 8b 50 38              movq     0x38(%rax), %rdx
0x07ec215f:  c6 40 18 01              movb     $1, 0x18(%rax)
0x07ec2163:  ff 50 20                 callq    *0x20(%rax)

----------------
IN: 
0x065a36b0:  48 89 5c 24 08           movq     %rbx, 8(%rsp)

----------------
IN: 
0x065a36b5:  57                       pushq    %rdi

----------------
IN: 
0x065a36b6:  48 83 ec 20              subq     $0x20, %rsp
----------------
IN: 
0x065a36ba:  8b 05 f8 37 00 00        movl     0x37f8(%rip), %eax

----------------
IN: 
0x065a36c0:  48 8b da                 movq     %rdx, %rbx

----------------
IN: 
0x065a36c3:  48 8b f9                 movq     %rcx, %rdi
~~~