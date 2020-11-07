~~~
-------------------------------------------------------------------
204				205
FUN_001198fc	
FUN_00110be2
FUN_00100b62
FUN_00100b78
FUN_00107874
FUN_001065f8
FUN_00171016	FUN_00171042
FUN_00171d52	FUN_00171d7e
FUN_00171de4	FUN_00171e10
FUN_00170e8e	FUN_00170eba
-------------------------------------------------------------------
int UndefinedFunction_00440340(int param_1)

{
  short sVar1;
  byte bVar2;
  int iVar3;
  uint uVar4;
  undefined4 uVar5;
  ushort uVar6;
  
  iVar3 = FUN_001198fc();
  if ((short)iVar3 != 0x0) {
    for (iVar3 = FUN_00110be2(); iVar3 != 0x0; iVar3 = FUN_00171d52(iVar3)) {
      sVar1 = *(short *)(iVar3 + 0x50);
      if (((((sVar1 != 0xa) && (sVar1 != 0xb)) && (*(short *)(iVar3 + 0x6c) != 0x0)) &&
          ((sVar1 != 0x7 && (sVar1 != 0x8)))) &&
         ((*(short *)(iVar3 + 0x174) == 0x0 && ;无敌
          ((*(short *)(iVar3 + 0x1e2) == 0x0 && (*(short *)(iVar3 + 0xca) != 0x10)))))) {
        FUN_00171de4(iVar3,*(undefined2 *)(iVar3 + 0x6c)) ; 减血
        if (*(short *)(iVar3 + 0x6c) == 0x0) {
          if (*(short *)(param_1 + 0xc8) == *(short *)(iVar3 + 0xc8)) {
            uVar6 = 0x11;
          }
          else {
            uVar6 = 0x7;
          }
          if (*(short *)(*(int *)(iVar3 + 0x54) + 0x68) == 0x29f) { ;9f=id
LAB_004403f6:
            bVar2 = DAT_00816c50;
            DAT_00816c50 = DAT_00816c50 + 0x1;
            if (0x3f < DAT_00816c50) {
              DAT_00816c50 = bVar2 - 0x3f;
            }
            uVar4 = _DAT_00816c4c;
            if ((int)_DAT_00816c4c < _DAT_00816c48) {
              FUN_00100b62();
              FUN_00107874(_DAT_00816c3c,
                           (uint)*(ushort *)(*(int *)(iVar3 + 0x54) + 0x68) << 0x8 |
                           (uint)DAT_00816c50 << 0x2 |
                           (int)(uint)*(ushort *)(*(int *)(iVar3 + 0x54) + 0x68) >> 0x8 & 0x3U |
                           0xdf0000,0x1);
              _DAT_00816c3c = _DAT_00816c44 + _DAT_00816c3c;
              _DAT_00816c4c = _DAT_00816c4c + 0x1;
              if (_DAT_00816c3c == _DAT_00816c40) {
                _DAT_00816c3c = _DAT_00816c34;
              }
              uVar4 = FUN_00100b78();
            }
          }
          else {
            uVar4 = FUN_001065f8();
            if (uVar4 != 0x0) goto LAB_004403f6;
          }
          uVar5 = FUN_00170e8e(iVar3,0x8,uVar4 & 0xffff0000 | (uint)uVar6);
          FUN_00171016(iVar3,uVar5);
          *(undefined2 *)(iVar3 + 0x174) = 0x1;
          *(undefined2 *)(iVar3 + 0xb4) = 0x1;
        }
      }
    }
  }
  return iVar3;
}