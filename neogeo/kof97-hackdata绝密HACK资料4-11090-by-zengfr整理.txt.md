~~~
void UndefinedFunction_00011090(void)

{
  code **ppcVar1;
  byte bVar2;
  short sVar4;
  uint uVar3;
  ushort in_D1w;
  undefined *puVar5;
  code **unaff_A3;
  code **unaff_A4;
  int unaff_A5;
  byte *unaff_A6;
  undefined uVar6;
  bool bVar7;
  
  unaff_A4[0x8] = (code *)0x0;
  *(undefined *)(unaff_A4 + 0x29) = 0x1;
  *(byte *)((int)unaff_A4 + 0xe2) = *(byte *)((int)unaff_A4 + 0xe2) | 0x2;
LAB_0000f43e:
  do {
    *(byte *)((int)unaff_A4 + 0xe2) = *(byte *)((int)unaff_A4 + 0xe2) & 0x7f;
    *(undefined2 *)((int)unaff_A4 + 0x72) = 0x0;
    if (*(char *)((int)unaff_A4 + 0x1d6) != '\0') {
      *(undefined2 *)((int)unaff_A4 + 0x72) = 0x4f;
    }
    *(undefined2 *)(unaff_A4 + 0x1e) = 0xffff;
    *unaff_A4 = (code *)0xf464;
    uVar6 = false;
    FUN_0001228e();
    if (!(bool)uVar6) {
      *(undefined2 *)((int)unaff_A4 + 0x72) = 0x18;
      *(undefined2 *)(unaff_A4 + 0x1e) = 0xffff;
      FUN_0000584c();
      *unaff_A4 = (code *)0xf484;
      uVar6 = *(char *)(unaff_A4 + 0x1f) == '\0';
      if (*(char *)(unaff_A4 + 0x1f) < '\0') {
        *(undefined2 *)((int)unaff_A4 + 0x72) = 0x0;
        if (*(char *)((int)unaff_A4 + 0x1d6) != '\0') {
          *(undefined2 *)((int)unaff_A4 + 0x72) = 0x4f;
        }
        FUN_000122c8();
        *unaff_A4 = (code *)0xf464;
        uVar6 = 0x0;
      }
    }
    (**(code **)(unaff_A4[0x65] + 0x8))();
    if (!(bool)uVar6) goto LAB_000101d8;
    FUN_000116d6();
    if (!(bool)uVar6) {
LAB_000101e2:
      sVar4 = FUN_00015692();
      if (sVar4 == 0x1) {
        FUN_000122c8();
        if (*(char *)((int)unaff_A4 + 0x1d5) != '\0') {
          FUN_00007700();
          *(undefined ***)((int)unaff_A4 + 0xc2) = &PTR_DAT_000a34fc;
          unaff_A4[0x14] = unaff_A3[0x7f];
          *(undefined2 *)(unaff_A4 + 0x15) = *(undefined2 *)((int)unaff_A3 + 0x202);
          unaff_A4[0x16] = unaff_A3[0x81];
          unaff_A4[0x17] = unaff_A3[0x82];
          if ((*(byte *)((int)unaff_A4 + 0x31) & 0x1) == 0x0) {
            unaff_A4[0x14] = (code *)-(int)unaff_A4[0x14];
          }
          *unaff_A4 = (code *)&DAT_00010cb2;
          if (*(char *)((int)unaff_A3 + 0x1fa) != '\0') {
            *unaff_A4 = (code *)&DAT_00010af0;
          }
          *(undefined **)((int)unaff_A4 + 0x36) = &DAT_00010a16;
                    /* WARNING: Could not recover jumptable at 0x00010a14. Too many branches */
                    /* WARNING: Treating indirect jump as call */
          (**unaff_A4)();
          return;
        }
        *(undefined ***)((int)unaff_A4 + 0xc2) = &PTR_PTR_DAT_000a34f6;
        unaff_A4[0x14] = unaff_A3[0x5];
        if ((*(byte *)((int)unaff_A4 + 0x31) & 0x1) == 0x0) {
          unaff_A4[0x14] = (code *)-(int)unaff_A4[0x14];
        }
        *(undefined *)((int)unaff_A4 + 0xd2) = *(undefined *)((int)unaff_A3 + 0x6f);
        *(byte *)((int)unaff_A4 + 0xd2) = *(byte *)((int)unaff_A4 + 0xd2) & 0xc;
        *(undefined2 *)(unaff_A4 + 0x35) = 0xa;
        *unaff_A4 = (code *)&DAT_00010b86;
        *(undefined **)((int)unaff_A4 + 0x36) = &DAT_000109bc;
                    /* WARNING: Could not recover jumptable at 0x000109ba. Too many branches */
                    /* WARNING: Treating indirect jump as call */
        (**unaff_A4)();
        return;
      }
      if (sVar4 == 0x2) {
        FUN_00007700();
        FUN_000122c8();
        *(undefined ***)((int)unaff_A4 + 0xc2) = &PTR_DAT_000a3502;
        unaff_A4[0x14] = *(code **)((int)unaff_A3 + 0x1e);
        *(undefined2 *)(unaff_A4 + 0x15) = *(undefined2 *)(unaff_A3 + 0x9);
        unaff_A4[0x16] = *(code **)((int)unaff_A3 + 0x26);
        unaff_A4[0x17] = *(code **)((int)unaff_A3 + 0x2a);
        if ((*(byte *)((int)unaff_A4 + 0x31) & 0x1) == 0x0) {
          unaff_A4[0x14] = (code *)-(int)unaff_A4[0x14];
        }
        *unaff_A4 = (code *)&DAT_00010cb2;
        if (*(char *)(unaff_A3 + 0x7) != '\0') {
          *unaff_A4 = (code *)&DAT_00010af0;
        }
        *(undefined **)((int)unaff_A4 + 0x36) = &DAT_00010a76;
                    /* WARNING: Could not recover jumptable at 0x00010a74. Too many branches */
                    /* WARNING: Treating indirect jump as call */
        (**unaff_A4)();
        return;
      }
      FUN_000122c8();
      if ((*(byte *)((int)unaff_A3 + 0x73) & 0xc) == 0x0) {
        *(byte *)((int)unaff_A4 + 0xe2) = *(byte *)((int)unaff_A4 + 0xe2) & 0x7f;
        *(undefined *)((int)unaff_A4 + 0x1b1) = 0x0;
        unaff_A4[0x16] = unaff_A3[0x1];
        unaff_A4[0x14] = (code *)0x0;
        unaff_A4[0x17] = unaff_A3[0x2];
        *(undefined2 *)((int)unaff_A4 + 0x72) = 0x3;
        *unaff_A4 = (code *)&DAT_0000f5b2;
        goto LAB_0000f382;
      }
      uVar3 = FUN_0000f78e();
      *(undefined2 *)((int)unaff_A4 + 0x72) = 0x7;
      if ((uVar3 & 0x4) == 0x0) {
        FUN_00014fd2();
        if ((*(byte *)((int)unaff_A4 + 0x31) & 0x1) == 0x0) {
          *(undefined2 *)((int)unaff_A4 + 0x72) = 0xb;
          goto LAB_0000fa00;
        }
LAB_0000f8ba:
        *(byte *)((int)unaff_A4 + 0xe2) = *(byte *)((int)unaff_A4 + 0xe2) & 0x7f;
        *(undefined *)((int)unaff_A4 + 0x1b1) = 0x1;
        unaff_A4[0x16] = unaff_A3[0x1];
        unaff_A4[0x17] = unaff_A3[0x2];
        *unaff_A4 = (code *)0xf8d8;
        bVar7 = false;
        (**(code **)(unaff_A4[0x65] + 0x8))();
        if (!bVar7) goto LAB_000101d8;
        (**(code **)(unaff_A4[0x65] + 0x4))();
        if (!bVar7) goto LAB_0000f382;
        FUN_000113e0();
        if (bVar7) {
          if (*(char *)(unaff_A4 + 0x1f) < '\0') {
            FUN_0000f7d0();
            break;
          }
          goto LAB_0000f382;
        }
      }
      else {
        FUN_00014fd2();
        unaff_A4[0x14] = (code *)-(int)unaff_A4[0x14];
        if ((*(byte *)((int)unaff_A4 + 0x31) & 0x1) == 0x0) goto LAB_0000f8ba;
        *(undefined2 *)((int)unaff_A4 + 0x72) = 0xb;
LAB_0000fa00:
        *(byte *)((int)unaff_A4 + 0xe2) = *(byte *)((int)unaff_A4 + 0xe2) & 0x7f;
        *(undefined *)((int)unaff_A4 + 0x1b1) = 0x2;
        unaff_A4[0x16] = unaff_A3[0x1];
        unaff_A4[0x17] = unaff_A3[0x2];
        *unaff_A4 = (code *)0xfa1e;
        bVar7 = false;
        (**(code **)(unaff_A4[0x65] + 0x8))();
        if (!bVar7) goto LAB_000101d8;
        (**(code **)(unaff_A4[0x65] + 0x4))();
        if (!bVar7) goto LAB_0000f382;
        FUN_000113e0();
        if (bVar7) {
          if (*(char *)(unaff_A4 + 0x1f) < '\0') {
            FUN_0000f7d0();
            *(undefined2 *)((int)unaff_A4 + 0x72) = 0xc;
            if ((*(byte *)(unaff_A4 + 0x38) & 0x8) != 0x0) {
              *(undefined2 *)((int)unaff_A4 + 0x72) = 0x13;
            }
            *unaff_A4 = (code *)0xfa72;
            bVar7 = false;
            (**(code **)(unaff_A4[0x65] + 0x8))();
            if (!bVar7) goto LAB_000101d8;
            (**(code **)(unaff_A4[0x65] + 0x4))();
            if (bVar7) {
              FUN_000113e0();
              if (bVar7) {
                FUN_0000f7fc();
                if (bVar7) goto LAB_0000f834;
                    /* WARNING: Could not recover jumptable at 0x0000fabc. Too many branches */
                    /* WARNING: Treating indirect jump as call */
                (**(code **)((short)((*unaff_A6 & 0xff0f) * 0x4) + 0x11976))();
                return;
              }
              goto LAB_00010056;
            }
          }
          goto LAB_0000f382;
        }
      }
      FUN_00011712();
      goto LAB_00010056;
    }
    (**(code **)unaff_A4[0x65])();
    if (!(bool)uVar6) goto LAB_0000f382;
    FUN_00011672();
    if ((bool)uVar6) {
      FUN_000111e6();
      if ((bool)uVar6) {
        bVar2 = *unaff_A6;
        if (*(char *)((int)&PTR_DAT_000118e6 + (int)(short)(bVar2 & 0xff0f)) != '\0') {
          FUN_000122c8();
        }
                    /* WARNING: Could not recover jumptable at 0x0000f50e. Too many branches */
                    /* WARNING: Treating indirect jump as call */
        (**(code **)(&DAT_000118a6 + (short)((bVar2 & 0xff0f) * 0x4)))();
        return;
      }
LAB_000101fc:
      do {
        sVar4 = FUN_00015692();
        if (sVar4 == 0x2) {
          if (*(char *)((int)unaff_A4 + 0x1d5) == '\0') {
            *(undefined ***)((int)unaff_A4 + 0xc2) = &PTR_DAT_000a3508;
            unaff_A4[0x14] = unaff_A3[0x24];
            unaff_A4[0x14] = unaff_A4[0x14];
            unaff_A4[0x16] = unaff_A3[0x25];
            unaff_A4[0x17] = unaff_A3[0x26];
            if ((*(byte *)((int)unaff_A4 + 0x31) & 0x1) == 0x0) {
              unaff_A4[0x14] = (code *)-(int)unaff_A4[0x14];
            }
            FUN_00016190();
            FUN_0001377e();
            *(undefined *)(unaff_A4 + 0x29) = 0xff;
            *unaff_A4 = (code *)&DAT_00010a7a;
            if (*(char *)((int)unaff_A3 + 0x8e) != '\0') {
              *unaff_A4 = (code *)&DAT_00010af0;
            }
            *(undefined **)((int)unaff_A4 + 0x36) = &DAT_00010ffc;
                    /* WARNING: Could not recover jumptable at 0x00010ffa. Too many branches */
                    /* WARNING: Treating indirect jump as call */
            (**unaff_A4)();
            return;
          }
LAB_00011100:
          FUN_000122c8();
          FUN_00016190();
          FUN_0001377e();
          *(undefined *)(unaff_A4 + 0x29) = 0xff;
          *(undefined2 *)((int)unaff_A4 + 0x72) = 0x3f;
          *(undefined2 *)(unaff_A4 + 0x1e) = 0xffff;
          FUN_0000584c();
          *unaff_A4 = (code *)0x11136;
          if (-0x1 < *(char *)(unaff_A4 + 0x1f)) goto LAB_0000f382;
          *(undefined2 *)((int)unaff_A4 + 0x72) = 0x40;
          FUN_0000584c();
          *unaff_A4 = (code *)0x11150;
          if (-0x1 < *(char *)(unaff_A4 + 0x1f)) goto LAB_0000f382;
          *(undefined2 *)((int)unaff_A4 + 0x72) = 0x41;
          FUN_0000584c();
          *unaff_A4 = (code *)0x1116a;
          if (-0x1 < *(char *)(unaff_A4 + 0x1f)) goto LAB_0000f382;
          *(undefined *)(unaff_A4 + 0x29) = 0x1;
          goto LAB_0000f43e;
        }
        if (sVar4 == 0x3) {
          *(undefined2 *)((int)unaff_A4 + 0x72) = 0x46;
          puVar5 = &DAT_000a3550;
          if (*(char *)((int)unaff_A4 + 0x1d6) != '\0') {
            *(undefined2 *)((int)unaff_A4 + 0x72) = 0x4e;
            puVar5 = &DAT_000a3590;
          }
          *(undefined *)((int)unaff_A4 + 0x1ba) = 0x2;
          *(undefined2 *)(unaff_A4 + 0x6f) = *(undefined2 *)(puVar5 + *(short *)(unaff_A4 + 0x60));
          *(undefined2 *)((int)unaff_A4 + 0x1be) =
               *(undefined2 *)(&DAT_000a35d0 + *(short *)(unaff_A4 + 0x60));
          bVar7 = *(short *)(unaff_A4 + 0x1c) == 0x0;
          FUN_00015642();
          if (bVar7) {
            FUN_00007700();
          }
          FUN_000122c8();
          *(undefined2 *)((int)unaff_A4 + 0xd2) = 0x20;
          *(undefined2 *)(unaff_A4 + 0x1e) = 0xffff;
          FUN_0000584c();
          *unaff_A4 = (code *)&DAT_000101a0;
          goto LAB_0000f382;
        }
        if (sVar4 == 0x4) {
          if (*(char *)((int)unaff_A4 + 0x1d5) == '\0') {
            *(undefined ***)((int)unaff_A4 + 0xc2) = &PTR_DAT_000a3514;
            unaff_A4[0x14] = unaff_A3[0x4b];
            unaff_A4[0x14] = unaff_A4[0x14];
            unaff_A4[0x16] = unaff_A3[0x4c];
            unaff_A4[0x17] = unaff_A3[0x4d];
            if ((*(byte *)((int)unaff_A4 + 0x31) & 0x1) != 0x0) {
              unaff_A4[0x14] = (code *)-(int)unaff_A4[0x14];
            }
            FUN_00016190();
            FUN_0001377e();
            *(undefined *)(unaff_A4 + 0x29) = 0xff;
            *unaff_A4 = (code *)&DAT_00010a7a;
            if (*(char *)((int)unaff_A3 + 0x12a) != '\0') {
              *unaff_A4 = (code *)&DAT_00010af0;
            }
            *(code **)((int)unaff_A4 + 0x36) = UndefinedFunction_00011090;
                    /* WARNING: Could not recover jumptable at 0x0001108e. Too many branches */
                    /* WARNING: Treating indirect jump as call */
            (**unaff_A4)();
            return;
          }
          goto LAB_00011100;
        }
        if (sVar4 == 0x5) {
          *(char *)((int)unaff_A4 + 0x1e3) = *(char *)((int)unaff_A4 + 0x1e3) + -0x1;
          FUN_00010e9a();
          *(undefined2 *)(unaff_A4 + 0x3b) = 0x10;
          *(undefined2 *)((int)unaff_A4 + 0x72) = 0x4d;
          *(undefined2 *)(unaff_A4 + 0x1e) = 0xffff;
          FUN_0000584c();
          *unaff_A4 = (code *)0x111a2;
          if (*(char *)(unaff_A4 + 0x1f) < '\0') goto LAB_0000f43e;
          goto LAB_0000f382;
        }
        if ((*unaff_A6 & 0x2) != 0x0) {
          FUN_00011734();
          *(byte *)(unaff_A4 + 0x38) = *(byte *)(unaff_A4 + 0x38) | 0x5;
          FUN_000122c8();
          *(undefined2 *)(unaff_A4 + 0x1e) = 0xffff;
          FUN_0000584c();
          *unaff_A4 = (code *)0xffde;
          if (-0x1 < *(char *)(unaff_A4 + 0x5c)) {
            *unaff_A4 = (code *)0xffd4;
            bVar7 = false;
            FUN_0001e5aa();
            if (!bVar7) goto LAB_000101d8;
          }
          unaff_A4[0x4d] = (code *)0x0;
          if ((*(byte *)(unaff_A4 + 0x1f) & 0x20) != 0x0) {
            *(undefined *)((int)unaff_A4 + 0xd2) = *(undefined *)((int)unaff_A4 + 0xef);
            *(undefined *)((int)unaff_A4 + 0xd3) = *(undefined *)((int)unaff_A4 + 0xee);
            *(undefined2 *)(unaff_A4 + 0x35) = *(undefined2 *)((int)unaff_A4 + 0x72);
            sVar4 = FUN_000111e6();
            *(byte *)(unaff_A4 + 0x3d) = *(byte *)(unaff_A4 + 0x3d) & 0x2;
            if (sVar4 != 0x0) {
              if ((sVar4 == 0x1) &&
                 (in_D1w = in_D1w & 0xff00 | (ushort)*(byte *)((int)unaff_A4 + 0xee),
                 *(byte *)((int)unaff_A4 + 0xee) == *(byte *)((int)unaff_A4 + 0xd3)))
              goto LAB_000101fc;
              *(undefined *)((int)unaff_A4 + 0xef) = *(undefined *)((int)unaff_A4 + 0xd2);
              *(undefined *)((int)unaff_A4 + 0xee) = *(undefined *)((int)unaff_A4 + 0xd3);
              *(undefined2 *)((int)unaff_A4 + 0x72) = *(undefined2 *)(unaff_A4 + 0x35);
            }
          }
          unaff_A4[0x4d] = (code *)0xfd8e;
          if (-0x1 < *(char *)(unaff_A4 + 0x1f)) goto LAB_0000f382;
          *(byte *)(unaff_A4 + 0x38) = *(byte *)(unaff_A4 + 0x38) & 0xfa;
          *(byte *)((int)unaff_A4 + 0xe2) = *(byte *)((int)unaff_A4 + 0xe2) & 0x7f;
          *(undefined2 *)((int)unaff_A4 + 0x72) = 0x17;
          *(undefined2 *)(unaff_A4 + 0x1e) = 0xffff;
          FUN_0000584c();
          unaff_A4[0x4d] = (code *)0xfd8e;
          *unaff_A4 = (code *)0xfdb4;
          *(byte *)(unaff_A4 + 0x38) = *(byte *)(unaff_A4 + 0x38) & 0xfb;
          unaff_A4[0x4d] = (code *)0x0;
          uVar6 = true;
          FUN_0001228e();
          if (!(bool)uVar6) {
            *(undefined2 *)((int)unaff_A4 + 0x72) = 0x19;
            *(undefined2 *)(unaff_A4 + 0x1e) = 0xffff;
            FUN_0000584c();
            *unaff_A4 = (code *)0xfdde;
            *(byte *)(unaff_A4 + 0x38) = *(byte *)(unaff_A4 + 0x38) & 0xfb;
            unaff_A4[0x4d] = (code *)0x0;
            uVar6 = *(char *)(unaff_A4 + 0x1f) == '\0';
            if (*(char *)(unaff_A4 + 0x1f) < '\0') {
              *(undefined2 *)((int)unaff_A4 + 0x72) = 0x17;
              FUN_000122c8();
              *unaff_A4 = (code *)0xfdb4;
              uVar6 = 0x0;
            }
          }
          (**(code **)(unaff_A4[0x65] + 0x8))();
          if (!(bool)uVar6) goto LAB_000101d8;
          FUN_000116d6();
          if (!(bool)uVar6) goto LAB_000101e2;
          FUN_000111e6();
          if ((bool)uVar6) {
            bVar2 = *unaff_A6;
            if (*(char *)((short)(bVar2 & 0xff0f) + 0x11af6) != '\0') {
              FUN_000122c8();
            }
                    /* WARNING: Could not recover jumptable at 0x0000fe4e. Too many branches */
                    /* WARNING: Treating indirect jump as call */
            (**(code **)((short)((bVar2 & 0xff0f) * 0x4) + 0x11ab6))();
            return;
          }
          goto LAB_000101fc;
        }
        FUN_00011734();
        *(byte *)(unaff_A4 + 0x38) = *(byte *)(unaff_A4 + 0x38) & 0xfb;
        *(byte *)(unaff_A4 + 0x38) = *(byte *)(unaff_A4 + 0x38) | 0x1;
        FUN_000122c8();
        *(undefined2 *)(unaff_A4 + 0x1e) = 0xffff;
        FUN_0000584c();
        *unaff_A4 = (code *)0xff3c;
        if (-0x1 < *(char *)(unaff_A4 + 0x5c)) {
          *unaff_A4 = (code *)0xff32;
          bVar7 = false;
          FUN_0001e5aa();
          if (!bVar7) goto LAB_000101d8;
        }
        if ((*(byte *)(unaff_A4 + 0x1f) & 0x20) == 0x0) goto LAB_0000ff90;
        *(undefined *)((int)unaff_A4 + 0xd2) = *(undefined *)((int)unaff_A4 + 0xef);
        *(undefined *)((int)unaff_A4 + 0xd3) = *(undefined *)((int)unaff_A4 + 0xee);
        *(undefined2 *)(unaff_A4 + 0x35) = *(undefined2 *)((int)unaff_A4 + 0x72);
        sVar4 = FUN_000111e6();
        *(byte *)(unaff_A4 + 0x3d) = *(byte *)(unaff_A4 + 0x3d) & 0x2;
        if (sVar4 == 0x0) goto LAB_0000ff90;
        if ((sVar4 != 0x1) ||
           (in_D1w = in_D1w & 0xff00 | (ushort)*(byte *)((int)unaff_A4 + 0xee),
           *(byte *)((int)unaff_A4 + 0xee) != *(byte *)((int)unaff_A4 + 0xd3))) goto LAB_0000ff7e;
      } while( true );
    }
    FUN_00016190();
    *(ushort *)(unaff_A4 + 0x6f) = in_D1w;
    FUN_00007700();
    *(undefined2 *)((int)unaff_A4 + 0x1be) = 0x90;
    *(undefined *)((int)unaff_A4 + 0x1ba) = 0x2;
    FUN_00015692();
    FUN_000122c8();
    *(undefined2 *)((int)unaff_A4 + 0x72) = 0x42;
    *(undefined2 *)(unaff_A4 + 0x1e) = 0xffff;
    FUN_0000584c();
    *unaff_A4 = (code *)0x10d6e;
    bVar7 = false;
    FUN_00011672();
    if (!bVar7) {
      ppcVar1 = unaff_A4 + 0x3a;
      *(short *)ppcVar1 = *(short *)ppcVar1 + 0x180;
      bVar7 = *(short *)ppcVar1 == 0x0;
      FUN_00010e44();
      if (bVar7) {
        if (*(char *)(unaff_A4 + 0x1f) < '\0') {
          FUN_0001e374();
          *(undefined2 *)((int)unaff_A4 + 0x72) = 0x43;
          *unaff_A4 = (code *)&DAT_00010dc2;
        }
        goto LAB_0000f382;
      }
      FUN_00010e5c();
      *(undefined2 *)(unaff_A4 + 0x3b) = 0x10;
    }
    FUN_000161b0();
    *(undefined2 *)((int)unaff_A4 + 0x72) = 0x44;
    *unaff_A4 = (code *)0x10dfe;
    if ((unaff_A6[0x1] == 0x0) && (-0x1 < *(char *)(unaff_A4 + 0x1f))) goto LAB_0000f382;
  } while( true );
LAB_0000f910:
  *(undefined2 *)((int)unaff_A4 + 0x72) = 0x8;
  if ((*(byte *)(unaff_A4 + 0x38) & 0x8) != 0x0) {
    *(undefined2 *)((int)unaff_A4 + 0x72) = 0x11;
  }
  *unaff_A4 = (code *)0xf92c;
  bVar7 = false;
  (**(code **)(unaff_A4[0x65] + 0x8))();
  if (!bVar7) goto LAB_000101d8;
  (**(code **)(unaff_A4[0x65] + 0x4))();
  if (!bVar7) goto LAB_0000f382;
  FUN_000113e0();
  if (!bVar7) goto LAB_00010056;
  FUN_0000f7fc();
  if (!bVar7) {
    unaff_A4[0x6] = unaff_A4[0x14] + (int)unaff_A4[0x6];
    FUN_0000345e();
    if (-0x1 < (short)in_D1w) goto LAB_0000f382;
    *(undefined2 *)((int)unaff_A4 + 0x72) = 0x9;
    if ((*(byte *)(unaff_A4 + 0x38) & 0x8) != 0x0) {
      *(undefined2 *)((int)unaff_A4 + 0x72) = 0x12;
    }
    *unaff_A4 = (code *)0xf990;
    bVar7 = false;
    (**(code **)(unaff_A4[0x65] + 0x8))();
    if (!bVar7) {
LAB_000101d8:
      *(code **)((int)unaff_A4 + 0x1c6) = *unaff_A4;
                    /* WARNING: Could not recover jumptable at 0x000101e0. Too many branches */
                    /* WARNING: Treating indirect jump as call */
      (*unaff_A4[0x66])();
      return;
    }
    (**(code **)(unaff_A4[0x65] + 0x4))();
    if (!bVar7) goto LAB_0000f382;
    FUN_000113e0();
    if (!bVar7) goto LAB_00010056;
    FUN_0000f7fc();
    if (!bVar7) {
      ppcVar1 = unaff_A4 + 0x6;
      *ppcVar1 = unaff_A4[0x14] + (int)*ppcVar1;
      bVar7 = *ppcVar1 == (code *)0x0;
      FUN_0000345e();
      if (bVar7) {
        *(undefined2 *)((int)unaff_A4 + 0x72) = 0xa;
        FUN_000117a0();
        *(byte *)((int)unaff_A4 + 0xe2) = *(byte *)((int)unaff_A4 + 0xe2) | 0x2;
        *unaff_A4 = (code *)&DAT_0000f6f2;
      }
      goto LAB_0000f382;
    }
  }
LAB_0000f834:
  FUN_00007700();
  *(undefined2 *)((int)unaff_A4 + 0x72) = 0x4a;
  *(undefined2 *)(unaff_A4 + 0x1e) = 0xffff;
  FUN_0000584c();
  unaff_A4[0x14] = *unaff_A3;
  unaff_A4[0x16] = unaff_A3[0x1];
  unaff_A4[0x17] = unaff_A3[0x2];
  *(byte *)((int)unaff_A4 + 0x31) = *(byte *)((int)unaff_A4 + 0x31) & 0xfe;
  if ((*unaff_A6 & 0x8) == 0x0) {
    unaff_A4[0x14] = (code *)-(int)unaff_A4[0x14];
    *(byte *)((int)unaff_A4 + 0x31) = *(byte *)((int)unaff_A4 + 0x31) | 0x1;
  }
  *unaff_A4 = (code *)0xf87a;
  if (-0x1 < *(char *)(unaff_A4 + 0x1f)) goto LAB_0000f382;
  *(byte *)((int)unaff_A4 + 0x31) = *(byte *)((int)unaff_A4 + 0x31) ^ 0x1;
  unaff_A4[0x6] = unaff_A4[0x14] + (int)unaff_A4[0x6];
  FUN_0000345e();
  goto LAB_0000f910;
LAB_0000ff7e:
  *(undefined *)((int)unaff_A4 + 0xef) = *(undefined *)((int)unaff_A4 + 0xd2);
  *(undefined *)((int)unaff_A4 + 0xee) = *(undefined *)((int)unaff_A4 + 0xd3);
  *(undefined2 *)((int)unaff_A4 + 0x72) = *(undefined2 *)(unaff_A4 + 0x35);
LAB_0000ff90:
  if (-0x1 < *(char *)(unaff_A4 + 0x1f)) goto LAB_0000f382;
  *(byte *)(unaff_A4 + 0x38) = *(byte *)(unaff_A4 + 0x38) & 0xfa;
  goto LAB_0000f43e;
LAB_00010056:
  FUN_00011734();
  FUN_00015692();
  *(byte *)(unaff_A4 + 0x38) = *(byte *)(unaff_A4 + 0x38) | 0x1;
  *(undefined **)((int)unaff_A4 + 0xc2) = &DAT_000a3520;
  if ((*(char *)((int)unaff_A4 + 0x1b1) != '\0') &&
     (*(undefined **)((int)unaff_A4 + 0xc2) = &DAT_000a3530,
     *(char *)((int)unaff_A4 + 0x1b1) != '\x01')) {
    *(undefined **)((int)unaff_A4 + 0xc2) = &DAT_000a3540;
  }
  *unaff_A4 = (code *)&DAT_0001009c;
LAB_0000f382:
  FUN_0000584c();
  FUN_000126c2();
  bVar7 = (&DAT_00002840)[unaff_A5] == '\0';
  if (((char)(&DAT_00002840)[unaff_A5] < '\0') && (FUN_000155e4(), bVar7)) {
                    /* WARNING: Could not recover jumptable at 0x0000f3a2. Too many branches */
                    /* WARNING: Treating indirect jump as call */
    (**unaff_A4)();
    return;
  }
  FUN_0000366e();
  FUN_00003686();
  FUN_00005caa();
  return;
}