~~~
void FUN_00172906(int param_1,int param_2,undefined4 param_3)

{
  undefined2 uVar2;
  undefined4 uVar1;
  
  if (*(short *)(param_1 + 0xbe) == 0x0) {
    if (*(short *)(param_1 + 0x10c) == 0x0) {
      *(undefined2 *)(param_1 + 0x10e) = 0x0;
    }
    else {
      *(undefined2 *)(param_1 + 0x10e) = *(undefined2 *)(param_1 + 0x10c);
      if (*(short *)(param_2 + 0x88) == 0x0) {
        *(undefined2 *)(param_1 + 0x10c) = 0x0;
        *(short *)(param_1 + 0x80) = *(short *)(param_1 + 0x80) + -0x1;
      }
      else {
        *(short *)(param_1 + 0x10c) = *(short *)(param_2 + 0x88) + -0x3c;
      }
    }
    *(undefined2 *)(param_1 + 0x6e) = *(undefined2 *)(param_1 + 0x10c);
    *(int *)(param_1 + 0x54) = param_2;
    *(ushort *)(param_1 + 0xf4) = (ushort)*(byte *)(param_2 + 0x1);
    *(undefined4 *)(param_1 + 0x5c) = *(undefined4 *)(param_2 + 0x3e);
    *(undefined4 *)(param_1 + 0x148) = *(undefined4 *)(*(int *)(param_2 + 0x3e) + 0x4);
    *(undefined4 *)(param_1 + 0x68) = *(undefined4 *)(param_2 + 0x52);
    *(undefined4 *)(param_1 + 0x34) = *(undefined4 *)(param_2 + 0x42);
    *(undefined4 *)(param_1 + 0x64) =
         *(undefined4 *)((uint)*(ushort *)(param_1 + 0x6e) * 0x4 + *(int *)(param_2 + 0x32));
    *(undefined4 *)(param_1 + 0x38) = *(undefined4 *)(param_2 + 0x46);
    *(uint *)(param_1 + 0x3c) =
         (uint)(*(ushort *)((uint)*(ushort *)(param_1 + 0x46) * 0x2 + *(int *)(param_1 + 0x38)) >>
               0x4) * 0xa + *(int *)(param_2 + 0x4a);
    *(ushort *)(param_1 + 0x40) =
         *(byte *)((uint)*(ushort *)(param_1 + 0x46) * 0x2 + *(int *)(param_1 + 0x38) + 0x1) & 0xf;
    *(undefined2 *)(param_1 + 0xbe) = 0x1;
    uVar2 = FUN_001796b8(*(undefined4 *)(param_1 + 0xf8),param_3);
    *(undefined2 *)(param_1 + 0x20a) = uVar2;
    *(undefined2 *)(param_1 + 0x16e) = 0x0;
    if (((*(byte *)(param_1 + 0x244) & 0x2) == 0x0) && ((*(byte *)(param_1 + 0x244) & 0x1) == 0x0))
    {
      FUN_00108fe8(*(undefined2 *)(param_1 + 0x122),0x2,*(undefined2 *)(param_1 + 0x60),
                   *(undefined4 *)(param_1 + 0x64),0x2);
      uVar1 = FUN_00109236(*(undefined2 *)(param_1 + 0x122),*(undefined4 *)(param_1 + 0x64),0x1);
      FUN_00107680(uVar1);
    }
    else {
      FUN_00134db4(param_1);
    }
    uVar1 = FUN_00170eba(param_1,0x2,0x1);
    FUN_00171042(param_1,uVar1);
    if (*(int *)(param_1 + 0xe8) != 0x0) {
      FUN_0017057a(param_1,0x5);
    }
    if (*(int *)(param_1 + 0xec) != 0x0) {
      FUN_0017057a(param_1,0x6);
    }
    _DAT_00d00002 = (ushort)*(byte *)(*(int *)(param_1 + 0xf8) + 0x1);
    _DAT_00d00004 = (ushort)*(byte *)(param_2 + 0x1);
    _DAT_00d00006 = *(undefined2 *)(param_1 + 0xa);
    FUN_00141e1c(0x15);
  }
  return;
}