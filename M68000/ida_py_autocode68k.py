import idautils
import idaapi
import idc
import threading
#from concurrent.futures import ThreadPoolExecutor,ProcessPoolExecutor
"""
runTime:Python 2.7.12
fileName:ida_py_autocode68k.py
home site1:https://github.com/zengfr/romhack
home site2:https://github.com/zengfr/arcade_game_romhacking_sourcecode_top_secret_data
author:zengfr

"""
def make_code(start, end):
  for i in range((end - start) / 4):
    addr = start + (i * 4)
    if not idc.isCode(idc.GetFlags(addr)):
      idaapi.do_unknown_range(addr, 4, 0)
      idaapi.auto_make_code(addr)
      idc.MakeCode(addr)
  return
def autoCode(hex_value):
  start = idc.MinEA();
  len=idc.MaxEA()-start;
  addr=start;
  flag = False
  for x in range(len):
    addr = idc.FindBinary(addr, SEARCH_DOWN|SEARCH_CASE|SEARCH_NEXT, hex_value)
    if addr != idc.BADADDR:
      make_code(addr,addr+4)
      print "{:>8X} {:<32}".format(addr,idc.GetDisasm(addr))
    else:
      flag = False
    #addr=idc.NextHead(addr)
  return 0
def showEA():  
  print 'range:0x%x-0x%x'%(idc.MinEA(),idc.MaxEA())
  return
def autoCodeTask(hexArr):  
  for hex in hexArr:
    autoCode(hex)
  return   
def autoCodeTaskPool(hexArr,workers):  
  executor=ProcessPoolExecutor(max_workers=workers)
  futures=[]
  for hex in hexArr:
    future=executor.submit(autoCode,hex)
    futures.append(future)
  executor.shutdown(True)
  print('+++>')
  return  
def autoCode68k(): 
  hexArr=['4eb8','4eb9',
  '4ef8','4ef9',
  '6100','6600', '6700',
  '48E7FFFE', '4CDF7FFF',
  '4e73','4e75','7001',
  '7100','7200','7400','7600',
  '3200','323C','4440'
  'D040','D041','D240','D241',
  'B041',
  '0C2900010000','0C2800010000',
  '4a28','4a29','4a2a','4a2d','4a2e',
  '4a68','4a69','4a6a','4a6d','4a6e',
  '1801','1802','1803','1804','1805','1806','1807','1809','180a','180b','180c',
  '1018','1218',
  '102d','122d',
  '5328']
  autoCodeTask(hexArr)
  #autoCodeTaskPool(hexArr,workers)
  return
def autoCodeCps1(): 
  hexArr=[ 
  '4BF88000',
  '207C00FF0000',
  '41F900','43F900','23FC0000','33DF00',
  '303900800','103900800']
  autoCodeTask(hexArr)
  #autoCodeTaskPool(hexArr,workers)
  return
"""
Python 2.7.12

4BF8 8000                           lea     ($FF8000).w,a5
207C 00FF 0000                      movea.l #$FF0000,a0 
41F9 0090 C000                      lea     ($90C000).l,a0
43F9 0090 A7B0                      lea     ($90A7B0).l,a1
3039 0080 0000                      move.w  ($800000).l,d0
1039 0080 0018                      move.b  ($800018).l,d0
23FC 0000 03CA 00FF+                move.l  #$3CA,($FF0000).l
33DF 00FF 0004                      move.w  (sp)+,($FF0004).l
autoCode('4eb8') #jsr
autoCode('4eb9')
autoCode('4ef8') #jmp
autoCode('4ef9')
autoCode('6100') #bsr
autoCode('6600') #bne.w  
autoCode('6700') #beq.w
autoCode('48E7FFFE') #movem.l d0-a6,-(sp) 
autoCode('4CDF7FFF') #movem.l (sp)+,d0-a6
4EB9 0000 119C                      jsr     (sub_119C).l 
4440                                neg.w   d0 
1803                                move.b  d3,d4 
1018                                move.b  (a0)+,d0        ; Move Data from Source to Destination
1218                                move.b  (a0)+,d1 
102D 0016                           move.b  $16(a5),d0
122D 001B                           move.b  $1B(a5),d1 
7200                                moveq   #0,d1
3200                                move.w  d0,d1
323C 0000                           move.w  #0,d1 
D040                                add.w   d0,d0
D041                                add.w   d1,d0 
D240                                add.w   d0,d1
D241                                add.w   d1,d1
B041                                cmp.w   d1,d0 
0C29 0001 0000                      cmpi.b  #1,0(a1) 
0C28 0001 0000                      cmpi.b  #1,0(a0) 
4A28 0000                           tst.b   0(a0)
4A2A 00D5                           tst.b   $D5(a2)
4A2D 014C                           tst.b   $14C(a5) 
4A6E 005C                           tst.w   $5C(a6)  
0829 0000 0000                      btst    #0,0(a1)
5328 0001                           subq.b  #1,1(a0) 
"""

if __name__ == '__main__':  
  #autoCode('4ef9')
  autoCodeCps1()
  autoCode68k()
  showEA()