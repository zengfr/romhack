~~~
int FUN_00170eba(int param_1,ushort param_2,ushort param_3)

{
  uint uVar1;
  int iVar2;
  
  uVar1 = *(uint *)((uint)param_2 * 0x4 + *(int *)(*(int *)(param_1 + 0x54) + 0x16));
  if ((((uVar1 == 0x0) || ((uVar1 & 0x1) == 0x1)) || (uVar1 < 0x100000)) || (0x900000 < uVar1)) {
    FUN_0010d9e6(0x3,0x9,s_R=%06X_ORGMEN=%d_MENID=%d_ACTION_00376ece,param_1,
                 *(undefined *)(*(int *)(param_1 + 0x58) + 0x1),
                 *(undefined *)(*(int *)(param_1 + 0x54) + 0x1),uVar1,param_2,param_3);
    FUN_00100ec4(s_ROLE_NULL_ACTION_0_00376f02,0x12);
  }
  iVar2 = (uint)param_3 * 0x12 + uVar1;
  if (*(int *)(iVar2 + 0x2) == 0x0) {
    FUN_0010d9e6(0x3,0x9,s_R=%06X_ORGMEN=%d_MENID=%d_ACTION_00376f16,param_1,
                 *(undefined *)(*(int *)(param_1 + 0x58) + 0x1),
                 *(undefined *)(*(int *)(param_1 + 0x54) + 0x1),iVar2,param_2,param_3);
    FUN_00100ec4(s_ROLE_NULL_ACTION_1_00376f4a,0x13);
  }
  return iVar2;
}