~~~
void UndefinedFunction_00125f26
               (int param_1,byte param_2,uint param_3,uint param_4,uint param_5,undefined4 param_6)

{
  uint uVar1;
  undefined4 uVar2;
  int iVar3;
  
  if (*(ushort *)(param_1 + 0x52) < 0x32) {
    param_2 = *(byte *)(param_1 + 0x1cb);
  }
  uVar1 = (param_2 - 0x1) * 0x2 & 0xffff0000;
  switch(param_2) {
  case 0x1:
  case 0x2:
  case 0x3:
  case 0x4:
  case 0x5:
  case 0x6:
  case 0x7:
  case 0x8:
  case 0x9:
  case 0xa:
  case 0xb:
  case 0xc:
  case 0xd:
  case 0xe:
  case 0x18:
  case 0x23:
  case 0x24:
  case 0x27:
  case 0x28:
  case 0x29:
    if (((_DAT_0081198c == 0x0) && (_DAT_00811982 != 0x0)) && ((&DAT_00811992)[param_2] == '\0')) {
      _DAT_0081198c = 0x1;
      (**(code **)(&DAT_001e2be8 + (short)((ushort)param_2 << 0x2)))
                (param_1,param_3,param_4,param_5,param_6);
      if (*(ushort *)(param_1 + 0x52) < 0x32) {
        FUN_001312d2(param_1);
      }
      else {
        FUN_0017a3bc(param_1);
      }
    }
    else {
      FUN_00130aa0(param_1);
      if (*(ushort *)(param_1 + 0x52) < 0x32) {
        uVar2 = FUN_00170eba(param_1,0x2,0x42);
        FUN_00171042(param_1,uVar2);
      }
      else {
        FUN_00172fbe(param_1);
      }
    }
    break;
  case 0xf:
  case 0x11:
    if (DAT_00810a09 == '\0') {
      (**(code **)(&DAT_001e2be8 + (short)((ushort)param_2 << 0x2)))
                (param_1,param_3,param_4,param_5,param_6);
      FUN_0017a3bc(param_1);
    }
    else {
      FUN_00130aa0(param_1);
      uVar2 = FUN_00170eba(param_1,0x2,0x42);
      FUN_00171042(param_1,uVar2);
    }
    break;
  case 0x10:
    iVar3 = FUN_00130a38();
    if (iVar3 == 0x0) {
      FUN_00130aa0(param_1);
      FUN_00172fbe(param_1);
    }
    else {
      (**(code **)(&DAT_001e2be8 + (short)((ushort)param_2 << 0x2)))
                (param_1,param_3,param_4,param_5,param_6);
      FUN_0017a3bc(param_1);
    }
    break;
  case 0x12:
  case 0x13:
  case 0x14:
  case 0x15:
    if (param_2 == 0x12) {
    }
    else if (param_2 == 0x15) {
      DAT_00810a06 = DAT_00810a07;
    }
    else {
      DAT_00810a06 = DAT_00810a09;
      if (param_2 == 0x14) {
        DAT_00810a06 = DAT_00810a08;
      }
    }
    if ((DAT_00810a06 == '\0') && (_DAT_00811990 == 0x0)) {
      (**(code **)(&DAT_001e2be8 + (short)((ushort)param_2 << 0x2)))
                (param_1,param_3,param_4,param_5,0x0);
      FUN_001312d2(param_1);
    }
    else {
      FUN_00130aa0(param_1);
      uVar2 = FUN_00170eba(param_1,0x2,0x42);
      FUN_00171042(param_1,uVar2);
    }
    break;
  default:
    FUN_0010d9e6(0x0,0xa,s_INDEX_ERROR_=_%d_003682da,param_2);
    FUN_00100af6(&DAT_003682ec,s_slavewpneff.c_003682ee,0x54d);
    break;
  case 0x1b:
  case 0x1c:
  case 0x1e:
  case 0x1f:
  case 0x2a:
  case 0x2b:
  case 0x2c:
  case 0x2d:
    (**(code **)(&DAT_001e2be8 + (short)((ushort)param_2 << 0x2))) ;bp 126334 ;2a=1255d0;
              (param_1,param_3,param_4,param_5,param_6);
    FUN_001312d2(param_1);
    break;
  case 0x20:
  case 0x21:
    if (_DAT_0081198e == 0x0) {
      _DAT_0081198e = 0x1;
      (**(code **)(&DAT_001e2be8 + (short)((ushort)param_2 << 0x2)))
                (param_1,param_3,param_4,param_5,param_6);
      FUN_001312d2(param_1);
    }
    else {
      FUN_00130aa0(param_1);
      uVar2 = FUN_00170eba(param_1,0x2,0x42);
      FUN_00171042(param_1,uVar2);
    }
    break;
  case 0x25:
  case 0x26:
    if ((_DAT_00811990 == 0x0) && (_DAT_00810a06 == 0x0)) {
      _DAT_00811990 = 0x1;
      (**(code **)(&DAT_001e2be8 + (short)((ushort)param_2 << 0x2)))
                (param_1,param_3,param_4,param_5,param_6);
      FUN_001312d2(param_1);
    }
    else {
      FUN_00130aa0(param_1);
      uVar2 = FUN_00170eba(param_1,0x2,0x42);
      FUN_00171042(param_1,uVar2);
    }
    break;
  case 0x2e:
  case 0x2f:
  case 0x30:
  case 0x31:
  case 0x32:
  case 0x33:
  case 0x34:
  case 0x35:
  case 0x36:
  case 0x37:
  case 0x38:
  case 0x39:
  case 0x3a:
  case 0x3b:
    FUN_00125b64(param_1,param_3,param_4,param_5,param_6);
    break;
  case 0x3c:
  case 0x3d:
  case 0x3e:
  case 0x3f:
  case 0x40:
  case 0x41:
  case 0x42:
  case 0x43:
  case 0x44:
  case 0x45:
  case 0x46:
  case 0x47:
  case 0x48:
  case 0x49:
  case 0x4a:
  case 0x4b:
  case 0x4c:
  case 0x4d:
  case 0x4e:
  case 0x4f:
  case 0x50:
  case 0x51:
  case 0x52:
  case 0x53:
  case 0x54:
  case 0x55:
  case 0x56:
  case 0x57:
  case 0x58:
  case 0x59:
  case 0x5a:
  case 0x5b:
  case 0x5c:
  case 0x5d:
  case 0x5e:
  case 0x5f:
  case 0x60:
  case 0x61:
  case 0x62:
  case 0x63:
  case 0x64:
  case 0x65:
  case 0x66:
  case 0x67:
  case 0x68:
    FUN_00125b30(param_1,param_3,param_4,param_5,param_6);
    break;
  case 0x7d:
    FUN_0012f066(param_1,uVar1 | param_3 & 0xffff,uVar1 | param_4 & 0xffff,uVar1 | param_5 & 0xffff)
    ;
  }
  return;
}
-------------------------------------------------------------------------------------------------------------------------
道具2a;
void UndefinedFunction_001255d0(int param_1,int param_2,int param_3,int param_4)

{
  short sVar1;
  undefined uVar2;
  int iVar3;
  int iVar4;
  short sVar5;
  short sVar6;
  
  if ((((*(short *)(param_1 + 0xf6) == 0x5) || (*(short *)(param_1 + 0xf6) == 0x10)) ||
      (*(short *)(param_1 + 0xf6) == 0x8)) || (*(short *)(param_1 + 0xf6) == 0x13)) {
    iVar4 = FUN_0015fb8c();
    FUN_0015fc6e(iVar4,&DAT_001e2150,*(short *)(param_1 + 0x20) + param_2,
                 *(short *)(param_1 + 0x22) + param_3,*(short *)(param_1 + 0x24) + param_4,
                 *(undefined2 *)(param_1 + 0xc8));
    *(int *)(iVar4 + 0x78) = param_1;
    *(undefined2 *)(iVar4 + 0x6c) = 0x0;
    if (param_1 != 0x0) {
      *(undefined4 *)(iVar4 + 0x7c) = *(undefined4 *)(param_1 + 0x58);
    }
    *(undefined **)(iVar4 + 0x2c) = PTR_DAT_0031c86a;
    *(undefined2 *)(iVar4 + 0x3c) = 0x0;
    *(undefined2 *)(iVar4 + 0x54) = 0x0;
    *(undefined2 *)(iVar4 + 0x68) = 0x0;
    iVar4 = 0x1;
    do {
      iVar3 = FUN_0016332c(&DAT_001e2150,*(short *)(param_1 + 0x20) + param_2,
                           *(short *)(param_1 + 0x22) + param_3,*(short *)(param_1 + 0x24) + param_4
                           ,*(undefined2 *)(param_1 + 0xc8));
      *(undefined4 *)(iVar3 + 0x2c) =
           *(undefined4 *)((int)&PTR_DAT_0031c86a + (int)(short)((short)iVar4 << 0x2));
      *(undefined2 *)(iVar3 + 0x3c) = 0x0;
      *(undefined2 *)(iVar3 + 0x54) = 0x0;
      *(undefined2 *)(iVar3 + 0x68) = 0x0;
      iVar4 = iVar4 + 0x1;
    } while (iVar4 < 0x3);
  }
  else {
    sVar5 = *(short *)(param_1 + 0x20) + (short)param_2;
    sVar6 = *(short *)(param_1 + 0x22) + (short)param_3 + 0x8;
    sVar1 = *(short *)(param_1 + 0x24);
    uVar2 = *(undefined *)(param_1 + 0xc9);
    iVar4 = 0x0;
    do {
      iVar3 = FUN_0015fb8c();
      FUN_0015fc6e(iVar3,&DAT_001e2150,(int)sVar5,(int)sVar6,(int)(short)(sVar1 + (short)param_4),
                   uVar2);
      *(undefined **)(iVar3 + 0x2c) = &DAT_001e20d8;
      *(undefined2 *)(iVar3 + 0x3c) = 0x0;
      *(undefined2 *)(iVar3 + 0x54) = 0x0;
      *(undefined2 *)(iVar3 + 0x68) = 0x0;
      *(int *)(iVar3 + 0x78) = param_1;
      *(undefined2 *)(iVar3 + 0x6c) = 0x0;
      if (param_1 != 0x0) {
        *(undefined4 *)(iVar3 + 0x7c) = *(undefined4 *)(param_1 + 0x58);
      }
      sVar6 = sVar6 + -0x8;
      sVar5 = sVar5 + -0x8;
      iVar4 = iVar4 + 0x1;
    } while (iVar4 < 0x3);
  }
  return;
}
--------------------------------------------------------------------------------------------------------------------------------
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
道具37;
uint FUN_00125b64(uint param_1)

{
  short sVar1;
  ushort uVar2;
  bool bVar3;
  uint uVar4;
  int iVar5;
  byte bVar6;
  int iVar7;
  undefined *puVar8;
  int in_stack_00000014;
  
  uVar4 = in_stack_00000014 * 0x2 & 0xffff0000U |
          (uint)(&switchD_00125b82::switchdataD_00125b86)[in_stack_00000014];
  switch(in_stack_00000014) {
  default:
    goto switchD_00125b82_caseD_0;
  case 0x1:
    *(undefined2 *)(param_1 + 0xc6) = 0x0;
    bVar3 = 0xdf < (int)*(short *)(param_1 + 0x20) - (int)_DAT_00d0a000;
    if (bVar3) {
      *(undefined2 *)(param_1 + 0xc8) = 0x1;
    }
    else {
      *(undefined2 *)(param_1 + 0xc8) = 0x0;
    }
    iVar7 = FUN_0015fb8c();
    bVar6 = *(byte *)(*(int *)(param_1 + 0x58) + 0x1);
    if (0xa < bVar6) {
      bVar6 = bVar6 - 0xb;
    }
    FUN_0015fc6e(iVar7,*(undefined4 *)(&DAT_0031c8e6 + (short)((ushort)bVar6 << 0x2)),
                 (int)*(short *)(param_1 + 0x20),(int)*(short *)(param_1 + 0x22),
                 (int)*(short *)(param_1 + 0x24),!bVar3);
    *(undefined2 *)(iVar7 + 0xd2) = *(undefined2 *)(param_1 + 0x1c8);
    *(undefined4 *)(iVar7 + 0x2c) = *(undefined4 *)(&DAT_001e2d64 + (short)((ushort)bVar6 << 0x2));
    *(undefined2 *)(iVar7 + 0x3c) = 0x0;
    *(undefined2 *)(iVar7 + 0x54) = 0x0;
    *(undefined2 *)(iVar7 + 0x68) = 0x0;
    *(undefined2 *)(iVar7 + 0x50) = *(undefined2 *)(param_1 + 0x60);
    *(undefined2 *)(iVar7 + 0x8a) = *(undefined2 *)(param_1 + 0x60);
    *(uint *)(iVar7 + 0x78) = param_1;
    *(undefined2 *)(iVar7 + 0x6c) = 0x0;
    if (param_1 != 0x0) {
      *(undefined4 *)(iVar7 + 0x7c) = *(undefined4 *)(param_1 + 0x58);
    }
    bVar6 = *(char *)(param_1 + 0x1cb) - 0x23;
    iVar7 = *(int *)(&DAT_0031c882 + (short)((ushort)bVar6 << 0x2));
    bVar3 = 0xdf < (int)*(short *)(param_1 + 0x20) - (int)_DAT_00d0a000;
    if (bVar3) {
      *(undefined2 *)(param_1 + 0xc8) = 0x1;
      uVar4 = (uint)*(ushort *)(&DAT_001e3852 + (short)((ushort)bVar6 << 0x2));
    }
    else {
      *(undefined2 *)(param_1 + 0xc8) = 0x0;
      uVar4 = -(uint)*(ushort *)(&DAT_001e3852 + (short)((ushort)bVar6 << 0x2));
    }
    uVar2 = *(ushort *)(&DAT_001e3854 + (short)((ushort)bVar6 << 0x2));
    iVar5 = FUN_0015fb8c();
    FUN_0015fc6e(iVar5,*(undefined4 *)(&DAT_0031c8e6 + (short)((ushort)bVar6 << 0x2)),
                 (int)*(short *)(param_1 + 0x20) + uVar4,(int)*(short *)(param_1 + 0x22),
                 (int)*(short *)(param_1 + 0x24) - (uint)uVar2,bVar3);
    *(undefined2 *)(iVar5 + 0xd2) = *(undefined2 *)(param_1 + 0x1c8);
    *(undefined4 *)(iVar5 + 0x2c) = *(undefined4 *)(&DAT_001e2d00 + (short)((ushort)bVar6 << 0x2));
    *(undefined2 *)(iVar5 + 0x3c) = 0x0;
    *(undefined2 *)(iVar5 + 0x54) = 0x0;
    *(undefined2 *)(iVar5 + 0x68) = 0x0;
    FUN_00108640(0x2,0x1e,**(undefined4 **)(iVar7 + 0x32));
    *(undefined2 *)(iVar5 + 0x50) = 0x1e;
    *(undefined2 *)(iVar5 + 0x8a) = 0x1e;
    goto LAB_00125f0a;
  case 0x2:
    bVar6 = *(char *)(param_1 + 0x1cb) - 0x23;
    uVar4 = FUN_00172906(param_1,*(undefined4 *)(&DAT_0031c882 + (short)((ushort)bVar6 << 0x2)),
                         *(undefined2 *)(&DAT_001e38b6 + (short)((ushort)bVar6 * 0x2)));
    return uVar4;
  case 0x3:
    sVar1 = *(short *)(param_1 + 0x20);
    iVar7 = (int)_DAT_00d0a000;
    bVar6 = *(byte *)((int)&PTR_DAT_001e2cba +
                     (int)(short)(ushort)*(byte *)(*(int *)(param_1 + 0x54) + 0x1));
    iVar5 = FUN_0015fb8c();
    FUN_0015fc6e(iVar5,*(undefined4 *)(&DAT_0031c8e6 + (short)((ushort)bVar6 << 0x2)),
                 (int)*(short *)(param_1 + 0x20),(int)*(short *)(param_1 + 0x22),
                 (int)*(short *)(param_1 + 0x24),sVar1 - iVar7 < 0xe0);
    *(undefined2 *)(iVar5 + 0xd2) = *(undefined2 *)(param_1 + 0x1c8);
    puVar8 = &DAT_001e2d64;
    break;
  case 0x4:
    FUN_00172b1c(param_1);
    *(undefined2 *)(param_1 + 0xc6) = 0x0;
    bVar3 = 0xdf < (int)*(short *)(param_1 + 0x20) - (int)_DAT_00d0a000;
    if (bVar3) {
      iVar7 = 0x122;
      *(undefined2 *)(param_1 + 0xc8) = 0x1;
    }
    else {
      iVar7 = -0x122;
      *(undefined2 *)(param_1 + 0xc8) = 0x0;
    }
    iVar5 = FUN_0015fb8c();
    bVar6 = *(byte *)(*(int *)(param_1 + 0x58) + 0x1);
    if (0xa < bVar6) {
      bVar6 = bVar6 - 0xb;
    }
    FUN_0015fc6e(iVar5,*(undefined4 *)(&DAT_0031c8e6 + (short)((ushort)bVar6 << 0x2)),
                 *(short *)(param_1 + 0x20) + iVar7,(int)*(short *)(param_1 + 0x22),
                 *(short *)(param_1 + 0x24) + -0xe4,bVar3);
    *(undefined2 *)(iVar5 + 0xd2) = *(undefined2 *)(param_1 + 0x1c8);
    puVar8 = &DAT_001e2d00;
  }
  *(undefined4 *)(iVar5 + 0x2c) = *(undefined4 *)(puVar8 + (short)((ushort)bVar6 << 0x2));
  *(undefined2 *)(iVar5 + 0x3c) = 0x0;
  *(undefined2 *)(iVar5 + 0x54) = 0x0;
  *(undefined2 *)(iVar5 + 0x68) = 0x0;
  *(undefined2 *)(iVar5 + 0x50) = *(undefined2 *)(param_1 + 0x60);
  *(undefined2 *)(iVar5 + 0x8a) = *(undefined2 *)(param_1 + 0x60);
LAB_00125f0a:
  *(uint *)(iVar5 + 0x78) = param_1;
  *(undefined2 *)(iVar5 + 0x6c) = 0x0;
  uVar4 = param_1;
  if (param_1 != 0x0) {
    *(undefined4 *)(iVar5 + 0x7c) = *(undefined4 *)(param_1 + 0x58);
  }
switchD_00125b82_caseD_0:
  return uVar4;
}
-------------------------------------------------------------------------------------------------------------
内存分配00d02000 道具释放时
int * FUN_0015fb8c(void)

{
  int iVar1;
  int *piVar2;
  
  iVar1 = 0x0;
  piVar2 = (int *)&DAT_00d02000;
  while( true ) {
    if (0x4f < iVar1) {
      FUN_0010d9e6(0x1,0x9,s_OBJECT_DYNAMIC_USE_00373c54);
      while (iVar1 = FUN_00107cce(0x9), iVar1 == 0x0) {
        iVar1 = FUN_00107cce(0xe);
        if (iVar1 != 0x0) {
          FUN_00162e96();
        }
        iVar1 = FUN_00107cce(0xf);
        if (iVar1 != 0x0) {
          FUN_001040d6();
        }
      }
      piVar2 = (int *)FUN_00100ec4(s_OBJECT_DYNAMIC_USE_00373c68,0x2b);
      return piVar2;
    }
    if (*(short *)(piVar2 + 0x2) == 0x0) break;
    iVar1 = iVar1 + 0x1;
    piVar2 = piVar2 + 0x40;
  }
  *(undefined2 *)(piVar2 + 0x2) = 0x1;
  *(undefined2 *)((int)piVar2 + 0x72) = 0x1;
  *(undefined2 *)((int)piVar2 + 0xce) = 0x0;
  if (_DAT_00817190 == (int *)0x0) {
    _DAT_00817190 = piVar2;
    *piVar2 = 0x0;
    _DAT_00817190[0x1] = 0x0;
    _DAT_00817188 = _DAT_00817190;
  }
  else {
    *(int **)((int)_DAT_00817188 + 0x4) = piVar2;
    *piVar2 = (int)_DAT_00817188;
    piVar2[0x1] = 0x0;
    _DAT_00817188 = piVar2;
  }
  _DAT_00817184 = _DAT_00817188;
  _DAT_0081718c = _DAT_00817190;
  return piVar2;
}




