~~~
                    a2. = a2                                ; 敵方
                    a4. = a4                                ; 角色OBJ
                    d2. = d2                                ; 傷害值
                    d3. = d3                                ; 敵人編號
                    d5. = d5                                ; 是否敵將[01]

int FUN_001157c6(int param_1,int param_2,uint param_3,int param_4)

{
  ushort uVar1;
  short sVar2;
  char cVar3;
  bool bVar4;
  bool bVar5;
  uint uVar6;
  short sVar9;
  int iVar7;
  int iVar8;
  undefined *puVar10;
  
  bVar5 = false;
  bVar4 = false;
  cVar3 = **(char **)(param_1 + 0x58);
  if ((_DAT_00811990 != 0x0) && (DAT_00810a78 == '%')) {
    param_3 = param_3 + ((int)param_3 >> 0x2);
  }
  if (*(int *)(param_1 + 0xdc) != 0x0) {
    uVar6 = param_3;
    if ((int)param_3 < 0x0) {
      uVar6 = param_3 + 0x3;
    }
    param_3 = param_3 + ((int)uVar6 >> 0x2);
  }
  if (*(short *)(param_2 + 0xbe) != 0x0) {
    sVar9 = FUN_0012a9bc();
    if (((sVar9 != 0x0) && (0x0 < (int)param_3)) &&
       (param_3 = (int)param_3 >> 0x1, (int)param_3 < 0x1)) {
      param_3 = 0x1;
    }
  }
  if ((int)param_3 < 0x0) {
    param_3 = -param_3;
    if ((int)(uint)*(ushort *)(&DAT_001dfa2c + (uint)*(ushort *)(param_1 + 0xf4) * 0x2) <
        (int)(*(ushort *)(param_1 + 0x6c) + param_3)) {
      sVar2 = *(short *)(&DAT_001dfa2c + (uint)*(ushort *)(param_1 + 0xf4) * 0x2);
      sVar9 = *(short *)(param_1 + 0x6c);
      uVar6 = (uint)*(ushort *)(param_1 + 0xf4) * 0x2;
      *(undefined2 *)(param_1 + 0x6c) = *(undefined2 *)(&DAT_001dfa2c + uVar6);
      iVar7 = FUN_00114016(param_1,uVar6 & 0xffff0000 | (uint)(ushort)(sVar2 - sVar9));
    }
    else {
      *(short *)(param_1 + 0x6c) = (short)param_3 + *(short *)(param_1 + 0x6c);
      iVar7 = FUN_00114016(param_1,param_3 & 0xffff);
    }
  }
  else {
    sVar9 = (short)param_3;
    *(short *)(param_2 + 0x294) = sVar9 + *(short *)(param_2 + 0x294);
    if ((int)param_3 < (int)(uint)*(ushort *)(param_1 + 0x6c)) {
      *(short *)(param_1 + 0x6c) = *(short *)(param_1 + 0x6c) - sVar9;
      FUN_00114016(param_1,-sVar9);
    }
    else {
      uVar1 = *(ushort *)(param_1 + 0x6c);
      param_3 = (uint)uVar1;
      *(undefined2 *)(param_1 + 0x6c) = 0x0;
      FUN_00114016(param_1,-uVar1);
      bVar5 = true;
      if (cVar3 == '\x01') {
        bVar4 = true;
      }
    }
    iVar7 = param_2;
    if ((param_2 != 0x0) && (**(char **)(param_2 + 0x58) == '\0')) {
      uVar6 = (uint)*(ushort *)(param_1 + 0xf6);
      iVar7 = *(int *)(param_2 + 0xf8);
      if (cVar3 == '\x01') {
        *(short *)(iVar7 + 0x264) = *(short *)(iVar7 + 0x264) + 0x1;
        *(short *)(iVar7 + 0x266) = (short)param_3 + *(short *)(iVar7 + 0x266);
        if (bVar4) {
          *(char *)(iVar7 + 0x26c) = *(char *)(iVar7 + 0x26c) + '\x01';
          FUN_00158862(param_1);
          FUN_00107348(param_1);
          *(int *)(param_1 + 0x1ec) = param_2;
          FUN_00115664(param_1);
        }
      }
      if (bVar5) {
        if (cVar3 == '\x01') {
          if (DAT_00817fcc == '\x02') {
            iVar8 = FUN_001717e8();
            *(int *)(iVar7 + 0x268) =
                 *(int *)(&DAT_002186da + iVar8 * 0x4 + uVar6 * 0x10) + *(int *)(iVar7 + 0x268);
          }
          else {
            *(int *)(iVar7 + 0x268) =
                 *(int *)(&DAT_002185a2 + uVar6 * 0x4) + *(int *)(iVar7 + 0x268);
          }
        }
        else {
          if (DAT_00817fcc == '\x02') {
            iVar8 = FUN_001717e8();
            iVar8 = iVar8 * 0x4 + uVar6 * 0x10;
            puVar10 = &DAT_002186da;
          }
          else {
            iVar8 = uVar6 << 0x2;
            puVar10 = &DAT_002185a2;
          }
          param_4 = param_4 + *(int *)(puVar10 + iVar8);
        }
        *(short *)(iVar7 + 0x262) = *(short *)(iVar7 + 0x262) + 0x1;
      }
      if (DAT_00810a07 != '\0') {
        param_4 = param_4 * 0x2;
      }
      *(int *)(iVar7 + 0xa) = param_4 + *(int *)(iVar7 + 0xa);
      iVar7 = FUN_0015e890(iVar7);
      *(short *)(param_2 + 0x194) = (short)param_3 + *(short *)(param_2 + 0x194);
    }
  }
  return iVar7;
}