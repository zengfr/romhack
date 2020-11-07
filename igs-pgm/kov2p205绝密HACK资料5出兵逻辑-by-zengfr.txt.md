~~~
;void FUN_0010fc66(int param_1,int param_2,undefined4 param_3,undefined4 param_4,undefined4 param_5,
                 undefined2 param_6,undefined2 param_7)

{
  byte bVar1;
  int iVar2;
  undefined4 uVar3;
  uint uVar4;
  short sVar5;
  undefined *puVar6;
  
  iVar2 = param_1 * 0x400;
  puVar6 = &DAT_00d07000 + iVar2;
  if (*(short *)(&DAT_00d0700c + iVar2) != 0x1) {
    FUN_0010d9e6(0x6,0x8,s_h=%d_MEN=%x_x=%d_y=%d_z=%d_00366e3c,param_1,param_2,param_3,param_4,
                 param_5);
    FUN_00100ec4(s_RORO_REACTIVE_00366e58,0x5);
  }
  *(undefined4 *)(iVar2 + 0xd07180) = 0x0;
  *(undefined2 *)(iVar2 + 0xd070c8) = param_6;
  *(int *)(iVar2 + 0xd07054) = param_2;
  *(int *)(iVar2 + 0xd07058) = param_2;
  bVar1 = *(byte *)(param_2 + 0x1);
  *(ushort *)(iVar2 + 0xd070f4) = (ushort)bVar1;
  *(ushort *)(iVar2 + 0xd070f6) = (ushort)bVar1;
  *(undefined4 *)(iVar2 + 0xd070f8) = 0x0;
  uVar3 = FUN_0010e5c6();
  *(undefined4 *)(iVar2 + 0xd07070) = uVar3;
  uVar3 = FUN_0010e5c6();
  *(undefined4 *)(iVar2 + 0xd07074) = uVar3;
  *(undefined2 *)(iVar2 + 0xd07086) = 0x0;
  *(undefined4 *)(iVar2 + 0xd0705c) = *(undefined4 *)(param_2 + 0x3e);
  FUN_00115e82(puVar6);
  if (*(short *)(&DAT_00d0710c + iVar2) == 0x0) {
    *(undefined2 *)(iVar2 + 0xd0706e) = param_7;
  }
  else {
    *(undefined2 *)(iVar2 + 0xd0706e) = *(undefined2 *)(&DAT_00d0710c + iVar2);
  }
  *(undefined4 *)(iVar2 + 0xd07064) =
       *(undefined4 *)((uint)*(ushort *)(iVar2 + 0xd0706e) * 0x4 + *(int *)(param_2 + 0x32));
  uVar3 = FUN_00156d16();
  FUN_0010f50a(puVar6,*(undefined4 *)(iVar2 + 0xd07064),uVar3);
  *(undefined4 *)(iVar2 + 0xd07068) = *(undefined4 *)(param_2 + 0x52);
  *(ushort *)(iVar2 + 0xd07010) = (ushort)*(byte *)(param_2 + 0x4);
  *(undefined2 *)(iVar2 + 0xd07012) = 0x0;
  *(short *)(iVar2 + 0xd07014) = (short)param_3;
  sVar5 = (short)param_5;
  *(short *)(iVar2 + 0xd07016) = (short)param_4 + sVar5;
  *(undefined2 *)(iVar2 + 0xd07018) = 0x0;
  *(undefined2 *)(iVar2 + 0xd0701a) = 0x0;
  *(short *)(iVar2 + 0xd07020) = (short)param_3;
  *(short *)(iVar2 + 0xd07022) = (short)param_4;
  *(short *)(iVar2 + 0xd07024) = sVar5;
  *(undefined2 *)(iVar2 + 0xd07026) = 0x0;
  *(undefined2 *)(iVar2 + 0xd07028) = 0x0;
  *(undefined2 *)(iVar2 + 0xd0702a) = 0x0;
  *(undefined2 *)(iVar2 + 0xd07044) = 0x0;
  *(undefined2 *)(iVar2 + 0xd07046) = 0x0;
  *(undefined2 *)(iVar2 + 0xd071a2) = 0x0;
  *(undefined2 *)(iVar2 + 0xd0708c) = 0x0;
  FUN_0010e606(*(undefined4 *)(iVar2 + 0xd07070),*(undefined4 *)(&DAT_00d07078 + iVar2),
               *(undefined2 *)(iVar2 + 0xd07022));
  FUN_0010e606(*(undefined4 *)(iVar2 + 0xd07074),*(undefined4 *)(&DAT_00d0707c + iVar2),0x1);
  (**(code **)(*(int *)(iVar2 + 0xd07054) + 0x6))(puVar6);
  FUN_00118e02(puVar6);
  *(int *)(iVar2 + 0xd07008) = param_1;
  *(undefined2 *)(iVar2 + 0xd0709a) = 0x0;
  for (uVar4 = 0x0; (ushort)uVar4 < 0x7; uVar4 = (uint)(ushort)((ushort)uVar4 + 0x1)) {
    *(undefined4 *)(iVar2 + 0xd070d4 + uVar4 * 0x4) = 0x0;
  }
  *(undefined2 *)(iVar2 + 0xd07088) = 0x0;
  *(ushort *)(iVar2 + 0xd07108) = (ushort)*(byte *)(param_2 + 0x94);
  FUN_0010fc10(puVar6);
  *(undefined2 *)(iVar2 + 0xd07112) = 0x2;
  *(undefined4 *)(iVar2 + 0xd07114) = 0x0;
  *(undefined2 *)(iVar2 + 0xd0711c) = 0x0;
  *(undefined2 *)(iVar2 + 0xd07168) = 0x0;
  *(undefined2 *)(iVar2 + 0xd070a2) = 0x0;
  *(undefined2 *)(iVar2 + 0xd07084) = 0x1;
  *(undefined2 *)(iVar2 + 0xd071e2) = 0x0;
  *(undefined2 *)(iVar2 + 0xd0713e) = 0xffff;
  *(undefined2 *)(iVar2 + 0xd070d0) = 0x0;
  if (**(char **)(iVar2 + 0xd07054) == '\x01') {
    FUN_00107336();
    DAT_00817100 = DAT_00817100 + '\x01';
  }
  else {
    _DAT_00817872 = _DAT_00817872 + 0x1;
  }
  _DAT_00817108 = _DAT_00817108 + 0x1;
  if (0x7 < _DAT_00817108) {
    FUN_00100af6(s_rorototal<=MAXRORO_00366e66,s_c_oro.c_00366e7a,0x2d8);
  }
  *(undefined2 *)(iVar2 + 0xd07080) = 0x1;
  *(undefined2 *)(iVar2 + 0xd07126) = 0x0;
  *(undefined2 *)(iVar2 + 0xd07128) = 0x0;
  *(undefined2 *)(iVar2 + 0xd0712a) = 0x0;
  *(undefined2 *)(iVar2 + 0xd07082) = 0x0;
  *(undefined2 *)(iVar2 + 0xd07138) = 0x0;
  *(undefined2 *)(iVar2 + 0xd0713a) = 0x0;
  if (*(short *)(&DAT_00d0710c + iVar2) != 0x0) {
    *(short *)(iVar2 + 0xd07080) = *(short *)(iVar2 + 0xd07080) + 0x1;
  }
  *(undefined2 *)(iVar2 + 0xd0712c) = 0x0;
  *(undefined2 *)(iVar2 + 0xd0712e) = 0x0;
  *(undefined2 *)(iVar2 + 0xd07132) = 0x0;
  *(undefined2 *)(iVar2 + 0xd07258) = 0x0;
  *(undefined2 *)(iVar2 + 0xd07134) = 0x10;
  *(undefined2 *)(iVar2 + 0xd07136) = 0x10;
  *(undefined4 *)(iVar2 + 0xd07140) = 0x0;
  *(undefined2 *)(iVar2 + 0xd0709c) = 0x1;
  *(undefined2 *)(iVar2 + 0xd070a8) = 0x1;
  *(undefined2 *)(iVar2 + 0xd07170) = 0x0;
  *(undefined2 *)(iVar2 + 0xd07172) = 0x0;
  *(undefined2 *)(iVar2 + 0xd07176) = 0x0;
  *(undefined2 *)(iVar2 + 0xd071a0) = 0x0;
  *(undefined2 *)(iVar2 + 0xd0728c) = 0x0;
  *(undefined2 *)(iVar2 + 0xd07184) = 0x0;
  *(undefined2 *)(&DAT_00d07052 + iVar2) = 0x0;
  *(undefined2 *)(iVar2 + 0xd07196) = 0x0;
  *(undefined2 *)(iVar2 + 0xd071b0) = 0x1f;
  *(undefined4 *)(iVar2 + 0xd071ac) = 0x0;
  *(undefined2 *)(iVar2 + 0xd071b4) = 0x0;
  *(undefined2 *)(iVar2 + 0xd070ae) = 0x0;
  *(undefined2 *)(iVar2 + 0xd070b2) = 0x0;
  *(undefined2 *)(iVar2 + 0xd071c0) = 0x0;
  *(undefined2 *)(iVar2 + 0xd071c8) = 0x0;
  *(undefined2 *)(iVar2 + 0xd071cc) = 0x0;
  *(undefined2 *)(iVar2 + 0xd071ce) = 0x0;
  *(undefined2 *)(iVar2 + 0xd071c6) = 0x0;
  *(undefined2 *)(iVar2 + 0xd071a6) = 0x0;
  *(ushort *)(iVar2 + 0xd070b6) = (ushort)*(byte *)(param_2 + 0x78);
  if (*(short *)(iVar2 + 0xd070b6) != 0x0) {
    *(short *)(iVar2 + 0xd0728e) = sVar5;
  }
  *(undefined2 *)(iVar2 + 0xd071de) = 0x0;
  *(undefined2 *)(iVar2 + 0xd071d6) = 0x0;
  *(undefined2 *)(iVar2 + 0xd0716e) = 0x0;
  *(undefined2 *)(iVar2 + 0xd070b4) = 0x0;
  *(ushort *)(iVar2 + 0xd071e8) = (ushort)*(byte *)(param_2 + 0x79);
  *(undefined2 *)(iVar2 + 0xd071ea) = 0x0;
  *(undefined2 *)(iVar2 + 0xd0723e) = 0x0;
  *(undefined2 *)(iVar2 + 0xd07240) = 0x0;
  *(undefined2 *)(iVar2 + 0xd070c6) = 0x0;
  *(undefined2 *)(iVar2 + 0xd070c4) = 0x0;
  *(undefined2 *)(iVar2 + 0xd07216) = 0x3c;
  *(undefined2 *)(iVar2 + 0xd07218) = 0x258;
  *(undefined2 *)(iVar2 + 0xd0721a) = 0x0;
  *(undefined4 *)(iVar2 + 0xd07198) = 0x0;
  *(undefined2 *)(iVar2 + 0xd0722c) = 0x0;
  *(undefined2 *)(iVar2 + 0xd07220) = 0x0;
  *(undefined2 *)(iVar2 + 0xd07222) = 0x0;
  *(undefined2 *)(iVar2 + 0xd07230) = 0x0;
  *(undefined2 *)(iVar2 + 0xd07232) = 0x0;
  *(undefined2 *)(iVar2 + 0xd071b8) = 0x0;
  *(undefined2 *)(iVar2 + 0xd07294) = 0x0;
  FUN_00140c80(puVar6);
  *(undefined4 *)(iVar2 + 0xd071ec) = 0x0;
  *(undefined2 *)(iVar2 + 0xd070c2) = 0x0;
  *(undefined4 *)(iVar2 + 0xd07244) = 0x0;
  *(undefined2 *)(iVar2 + 0xd071d2) = 0x0;
  *(undefined2 *)(iVar2 + 0xd07290) = 0x0;
  *(undefined2 *)(&DAT_00d0700c + iVar2) = 0x2;
  FUN_00113cf4(puVar6);
  if ((DAT_00810a09 != '\0') && (*(ushort *)(iVar2 + 0xd070f6) < 0x40)) {
    FUN_00129cde(puVar6);
  }
  return;
}