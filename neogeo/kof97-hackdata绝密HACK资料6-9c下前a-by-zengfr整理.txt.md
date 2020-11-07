~~~
act 9c 按下前a:

void UndefinedFunction_00030656(void)

{
  int unaff_A3;
  code **unaff_A4;
  int unaff_A5;
  bool bVar1;
  
  FUN_0001e2fa();
  *(undefined *)(unaff_A4 + 0x69) = *(undefined *)(unaff_A3 + 0x7f);
  *(undefined *)((int)unaff_A4 + 0x1ba) = 0x2;
  *(undefined2 *)(unaff_A4 + 0x6f) = 0x2c5;
  *(undefined2 *)((int)unaff_A4 + 0x1be) = 0x2c7;
  *(undefined *)(unaff_A4 + 0x6e) = 0xb;
  *(undefined2 *)((int)unaff_A4 + 0x1de) = 0x600;
  FUN_00010f02();
  *(undefined2 *)(unaff_A4 + 0x78) = 0xa00;
  *(undefined *)(unaff_A4 + 0x42) = 0x7;
  *(undefined *)((int)unaff_A4 + 0xef) = 0x25;
  FUN_000140fe();
  *(undefined2 *)((int)unaff_A4 + 0xf6) = 0x85;
  *(undefined2 *)((int)unaff_A4 + 0xd2) = 0x9c;
  *(undefined2 *)(unaff_A4 + 0x35) = 0x9d;
  *(undefined2 *)((int)unaff_A4 + 0xd6) = 0x0;
  unaff_A4[0x6b] = (code *)0x0;
  FUN_00012d30();
  *(undefined2 *)((int)unaff_A4 + 0x72) = *(undefined2 *)((int)unaff_A4 + 0xd2);
  *(undefined2 *)(unaff_A4 + 0x1e) = 0xffff;
  FUN_0000584c();
  *unaff_A4 = (code *)&LAB_000306da;
  FUN_0000584c();
  FUN_000126c2();
  bVar1 = (&DAT_00002840)[unaff_A5] == '\0';
  if ((char)(&DAT_00002840)[unaff_A5] < '\0') {
    FUN_000155e4();
    if (bVar1) {
                    /* WARNING: Could not recover jumptable at 0x0002fbfa. Too many branches */
                    /* WARNING: Treating indirect jump as call */
      (**unaff_A4)();
      return;
    }
  }
  FUN_0000366e();
  FUN_00003686();
  FUN_00005caa();
  return;
}