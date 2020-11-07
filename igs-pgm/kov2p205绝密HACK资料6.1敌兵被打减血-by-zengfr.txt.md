~~~
void FUN_0011a36e(int param_1,int param_2,int param_3)

{
  ushort uVar1;
  int iVar2;
  int iVar3;
  uint uVar4;
  short sVar5;
  undefined **ppuVar6;
  
  if (param_2 == 0x0) {
    iVar3 = (int)(short)*(char *)(*(int *)(param_3 + 0x10) + 0x22);
    uVar4 = (uint)*(ushort *)(*(int *)(param_3 + 0x10) + 0x20);
  }
  else {
    if (*(char *)(*(int *)(param_3 + 0x10) + 0x3e) == '\x06') {
      iVar3 = FUN_001724bc(param_2,param_1,0x6,*(undefined *)(*(int *)(param_3 + 0x10) + 0x3f));
      uVar1 = *(ushort *)
               (&DAT_00217472 +
               (uint)*(byte *)(*(int *)(param_2 + 0x58) + 0x1) * 0xc8 +
               (uint)*(byte *)(*(int *)(param_3 + 0x10) + 0x3f) * 0x2);
    }
    else {
      iVar3 = FUN_001724bc(param_2,param_1,0x3,*(undefined *)(*(int *)(param_3 + 0x10) + 0x3f));
      uVar1 = *(ushort *)(*(int *)(param_3 + 0x10) + 0x20);
    }
    uVar4 = (uint)uVar1;
    if (*(short *)(param_2 + 0x16e) == 0x0) {
      if (*(ushort *)(param_2 + 0x1a0) < 0x3d) {
        iVar2 = (uint)*(byte *)(*(int *)(param_2 + 0x58) + 0x1) * 0xf4 +
                (uint)*(ushort *)(param_2 + 0x1a0) * 0x4;
        ppuVar6 = (undefined **)&DAT_00218f54;
      }
      else {
        iVar2 = (uint)*(byte *)(*(int *)(param_2 + 0x58) + 0x1) * 0xf4;
        ppuVar6 = &PTR_DAT_00219044;
      }
      uVar4 = uVar4 + *(int *)((int)ppuVar6 + iVar2);
    }
    if ((*(short *)(param_2 + 0xbe) != 0x0) && (*(short *)(param_2 + 0x16e) == 0x0)) {
      uVar4 = uVar4 + *(ushort *)
                       (&DAT_0021a44c + (uint)*(byte *)(*(int *)(param_2 + 0x54) + 0x1) * 0x2);
    }
    if (*(short *)(param_3 + 0xf8) != 0x0) {
      if ((*(short *)(param_3 + 0xf8) == 0x0) || (0x9 < *(ushort *)(param_3 + 0xf8))) {
        FUN_00100af6(s_o->assigncaningattrib_>_CANINGAT_00367d02,s_c_ule.c_00367d5c,0x274);
      }
      switch(*(undefined2 *)(param_3 + 0xf8)) {
      case 0x1:
        break;
      default:
        goto switchD_0011a50e_caseD_2;
      case 0x4:
        break;
      case 0x5:
        break;
      case 0x6:
        break;
      case 0x7:
        break;
      case 0x8:
        break;
      case 0x9:
      }
      iVar3 = FUN_001de3ce();
      iVar3 = iVar3 >> 0x6;
    }
  }
switchD_0011a50e_caseD_2:
  if (iVar3 < 0x1) {
    iVar3 = 0x1;
  }
  FUN_001157c6(param_1,param_2,iVar3,uVar4);
  if (*(int *)(*(int *)(param_3 + 0x10) + 0x4c) == 0x0) {
    iVar3 = *(int *)(*(int *)(param_3 + 0x10) + 0x48);
  }
  else {
    iVar3 = (**(code **)(*(int *)(param_3 + 0x10) + 0x4c))(param_1,param_3);
  }
  iVar2 = iVar3;
  if ((*(short *)(param_1 + 0x50) == 0x8) &&
     ((*(short *)(param_1 + 0x25a) == 0x5 || (*(short *)(param_1 + 0x25a) == 0xf)))) {
    iVar2 = FUN_001147d8(param_1,0x8,0x14);
  }
  FUN_00114b12(param_1,iVar2);
  *(int *)(param_1 + 0x1ec) = param_2;
  FUN_00162af4(param_3,param_1);
  if (*(short *)(param_3 + 0x22) < *(short *)(param_1 + 0x22)) {
    sVar5 = *(short *)(param_1 + 0x22);
  }
  else {
    sVar5 = *(short *)(param_3 + 0x22);
  }
  sVar5 = sVar5 + 0x1;
  if (*(char *)(*(int *)(param_3 + 0x10) + 0x6a) == '\0') {
    if ((*(byte *)(*(int *)(param_3 + 0x10) + 0x50) & 0x40) == 0x0) {
      if ((*(byte *)(iVar3 + 0x8) & 0x2) == 0x0) {
        FUN_001654ba(*(undefined2 *)(param_1 + 0x104),sVar5,*(undefined2 *)(param_1 + 0x106),
                     (*(byte *)(iVar3 + 0x9) >> 0x5) + 0x1,*(undefined2 *)(param_2 + 0xc8));
      }
      else {
        FUN_001654ba(*(undefined2 *)(param_1 + 0x104),sVar5,*(undefined2 *)(param_1 + 0x106),
                     (*(byte *)(iVar3 + 0x9) >> 0x5) + 0x8,*(undefined2 *)(param_2 + 0xc8));
        FUN_0016581e(*(undefined2 *)(param_1 + 0x104),sVar5,*(undefined2 *)(param_1 + 0x106),
                     *(byte *)(iVar3 + 0x9) >> 0x5,*(undefined2 *)(param_2 + 0xc8));
      }
    }
  }
  else {
    FUN_0016564e(*(undefined2 *)(param_1 + 0x104),sVar5,*(undefined2 *)(param_1 + 0x106),
                 *(undefined *)(*(int *)(param_3 + 0x10) + 0x6a),*(undefined2 *)(param_3 + 0x5c),
                 *(undefined *)(*(int *)(param_1 + 0x54) + 0x7b));
  }
  if (*(int *)(*(int *)(param_3 + 0x10) + 0x36) != 0x0) {
    *(undefined2 *)(param_3 + 0x20) = *(undefined2 *)(param_1 + 0x104);
    *(short *)(param_3 + 0x22) = *(short *)(param_1 + 0x22) + 0x1;
    *(undefined2 *)(param_3 + 0x24) = *(undefined2 *)(param_1 + 0x106);
    *(undefined4 *)(param_3 + 0x2c) = *(undefined4 *)(*(int *)(param_3 + 0x10) + 0x36);
    *(undefined2 *)(param_3 + 0x3c) = 0x0;
    *(undefined2 *)(param_3 + 0x54) = 0x0;
    *(undefined2 *)(param_3 + 0x68) = 0x0;
    *(undefined2 *)(param_3 + 0x58) = 0x0;
    if (*(short *)(param_3 + 0x5e) == 0x1) {
      *(undefined2 *)(param_3 + 0xbe) = 0x0;
    }
    else {
      *(undefined2 *)(param_3 + 0xbe) = 0x1;
    }
  }
  if (*(int *)(*(int *)(param_3 + 0x10) + 0x3a) != 0x0) {
    (**(code **)(*(int *)(param_3 + 0x10) + 0x3a))(param_3);
  }
  if (**(char **)(param_2 + 0x58) == '\0') {
    FUN_00166e06(param_2);
  }
  uVar4 = (uint)*(byte *)(*(int *)(param_2 + 0xf8) + 0x1);
  if (*(short *)(param_1 + 0x298 + uVar4 * 0x2) != *(short *)(param_2 + 0x296)) {
    *(undefined2 *)(param_1 + 0x298 + uVar4 * 0x2) = *(undefined2 *)(param_2 + 0x296);
    *(undefined2 *)(param_2 + 0xa0) = 0x0;
    *(short *)(param_1 + 0x1ea) = *(short *)(param_1 + 0x1ea) + 0x1;
    if (DAT_00810a07 == '\0') {
      if ((*(char *)(*(int *)(param_3 + 0x10) + 0x3e) == '\x06') &&
         (*(char *)(*(int *)(param_3 + 0x10) + 0x3f) == '\x04')) {
        if (*(short *)(param_2 + 0xbe) == 0x0) {
          *(undefined2 *)(param_1 + 0x1ea) = 0x0;
        }
        *(short *)(param_2 + 0x292) = *(short *)(param_2 + 0x292) + 0x1;
        if (0x1 < *(ushort *)(param_2 + 0x292)) {
          *(undefined2 *)(param_1 + 0x174) = 0x1;
          *(undefined2 *)(param_2 + 0x292) = 0x0;
        }
      }
      else if (((*(short *)(param_2 + 0xbe) != 0x0) && (0x7 < *(ushort *)(param_1 + 0x1ea))) ||
              (0x4 < *(ushort *)(param_1 + 0x1ea))) {
        *(undefined2 *)(param_1 + 0x174) = 0x1;
        *(undefined2 *)(param_1 + 0x1ea) = 0x0;
        *(undefined2 *)(param_1 + 0x28c) = 0x0;
        *(undefined2 *)(param_2 + 0x1a0) = 0x0;
      }
    }
  }
  if (*(short *)(param_3 + 0x62) == 0x0) {
    *(undefined2 *)(param_1 + 0x258) = *(undefined2 *)(param_3 + 0xe8);
    *(undefined2 *)(param_3 + 0xea) = *(undefined2 *)(param_3 + 0xe8);
  }
  return;
}