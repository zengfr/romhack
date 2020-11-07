~~~
undefined4 FUN_000111e6(void)

{
  byte bVar1;
  short sVar2;
  byte *pbVar3;
  int unaff_A3;
  int unaff_A4;
  byte *unaff_A6;
  bool bVar4;
  
  if ((*unaff_A6 & 0x2) != 0x0) {
    if ((unaff_A6[0x1] & 0x10) == 0x0) {
      if ((unaff_A6[0x1] & 0x20) == 0x0) {
        if ((unaff_A6[0x1] & 0x40) == 0x0) {
          if ((unaff_A6[0x1] & 0x80) == 0x0) {
            *(byte *)(unaff_A4 + 0xf4) = *(byte *)(unaff_A4 + 0xf4) | 0x7;
            return 0x0;
          }
          *(undefined *)(unaff_A4 + 0xee) = 0x2;
          if ((*(byte *)(unaff_A4 + 0xe0) & 0x10) != 0x0) {
            *(undefined *)(unaff_A4 + 0xee) = 0x3;
          }
          *(undefined2 *)(unaff_A4 + 0x72) = 0x73;
        }
        else {
          *(undefined *)(unaff_A4 + 0xee) = 0x2;
          if ((*(byte *)(unaff_A4 + 0xe0) & 0x10) != 0x0) {
            *(undefined *)(unaff_A4 + 0xee) = 0x3;
          }
          *(undefined2 *)(unaff_A4 + 0x72) = 0x6a;
        }
      }
      else {
        *(undefined *)(unaff_A4 + 0xee) = 0x0;
        if ((*(byte *)(unaff_A4 + 0xe0) & 0x10) != 0x0) {
          *(undefined *)(unaff_A4 + 0xee) = 0x1;
        }
        *(undefined2 *)(unaff_A4 + 0x72) = 0x61;
      }
    }
    else {
      *(undefined *)(unaff_A4 + 0xee) = 0x0;
      if ((*(byte *)(unaff_A4 + 0xe0) & 0x10) != 0x0) {
        *(undefined *)(unaff_A4 + 0xee) = 0x1;
      }
      *(undefined2 *)(unaff_A4 + 0x72) = 0x58;
    }
    *(byte *)(unaff_A4 + 0xe2) = *(byte *)(unaff_A4 + 0xe2) & 0x7f;
    FUN_000139c0();
    FUN_000140fe();
    return 0x1;
  }
  FUN_00012276();
  if ((unaff_A6[0x1] & 0x10) == 0x0) {
    if ((unaff_A6[0x1] & 0x20) == 0x0) {
      if ((unaff_A6[0x1] & 0x40) == 0x0) {
        if ((unaff_A6[0x1] & 0x80) == 0x0) {
          bVar4 = unaff_A6[0x8] == 0xc0;
          if (!bVar4) {
            sVar2 = FUN_00011382();
            if (!bVar4) {
              if (sVar2 == 0x1) {
                return 0x2;
              }
              return 0x4;
            }
            pbVar3 = unaff_A6 + 0x31;
            bVar1 = *(char *)(unaff_A4 + 0x170) * '\x02';
            if (bVar1 != 0x0) {
              pbVar3 = unaff_A6 + 0x19;
            }
            bVar4 = (*pbVar3 & '\x01' << (bVar1 & 0x7)) == 0x0;
            if (!bVar4) {
              return 0x3;
            }
            FUN_000113bc();
            if (!bVar4) {
              return 0x5;
            }
            *(byte *)(unaff_A4 + 0xf4) = *(byte *)(unaff_A4 + 0xf4) | 0x7;
            return 0x0;
          }
          *(undefined *)(unaff_A4 + 0xee) = 0x4;
          *(undefined2 *)(unaff_A4 + 0x72) = 0x74;
          if ((*(byte *)(unaff_A4 + 0xe0) & 0x10) != 0x0) {
            *(undefined *)(unaff_A4 + 0xee) = 0x5;
            *(undefined2 *)(unaff_A4 + 0x72) = 0x74;
          }
        }
        else {
          *(undefined *)(unaff_A4 + 0xee) = 0x2;
          if ((*(byte *)(unaff_A4 + 0xe0) & 0x10) != 0x0) {
            *(undefined *)(unaff_A4 + 0xee) = 0x3;
          }
          bVar1 = *(byte *)(unaff_A3 + 0xf);
          *(undefined2 *)(unaff_A4 + 0x72) = 0x6b;
          if ((ushort)bVar1 <= *(ushort *)(unaff_A4 + 0xbc)) {
            *(undefined2 *)(unaff_A4 + 0x72) = 0x6c;
          }
        }
      }
      else {
        *(undefined *)(unaff_A4 + 0xee) = 0x2;
        if ((*(byte *)(unaff_A4 + 0xe0) & 0x10) != 0x0) {
          *(undefined *)(unaff_A4 + 0xee) = 0x3;
        }
        bVar1 = *(byte *)(unaff_A3 + 0xe);
        *(undefined2 *)(unaff_A4 + 0x72) = 0x62;
        if ((ushort)bVar1 <= *(ushort *)(unaff_A4 + 0xbc)) {
          *(undefined2 *)(unaff_A4 + 0x72) = 0x63;
        }
      }
    }
    else {
      *(undefined *)(unaff_A4 + 0xee) = 0x0;
      if ((*(byte *)(unaff_A4 + 0xe0) & 0x10) != 0x0) {
        *(undefined *)(unaff_A4 + 0xee) = 0x1;
      }
      bVar1 = *(byte *)(unaff_A3 + 0xd);
      *(undefined2 *)(unaff_A4 + 0x72) = 0x59;
      if ((ushort)bVar1 <= *(ushort *)(unaff_A4 + 0xbc)) {
        *(undefined2 *)(unaff_A4 + 0x72) = 0x5a;
      }
    }
  }
  else {
    *(undefined *)(unaff_A4 + 0xee) = 0x0;
    if ((*(byte *)(unaff_A4 + 0xe0) & 0x10) != 0x0) {
      *(undefined *)(unaff_A4 + 0xee) = 0x1;
    }
    bVar1 = *(byte *)(unaff_A3 + 0xc);
    *(undefined2 *)(unaff_A4 + 0x72) = 0x50;
    if ((ushort)bVar1 <= *(ushort *)(unaff_A4 + 0xbc)) {
      *(undefined2 *)(unaff_A4 + 0x72) = 0x51;
    }
  }
  *(byte *)(unaff_A4 + 0xe2) = *(byte *)(unaff_A4 + 0xe2) & 0x7f;
  FUN_000139c0();
  FUN_000140fe();
  return 0x1;
}