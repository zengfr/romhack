#coding=utf-8
import sys
import idaapi
import idc
import os
'''
然后在命令行上，可以调用IDAPython脚本（假设IDA在您的路径中）：
^{pr2}$
-A用于运行IDA silent
-S用于脚本路径和脚本参数
最后一个参数是idb路径（或使用-t生成临时idb）
ida -c -A -S"script_path" filepath
参数说明：
-c 删除旧的数据库
-A autonomous模式，IDA将不会显示
-S 后面紧跟着IDA Python脚本的路径
ida -c -A -S"script_path argv[1] argv[2] argv[3]" filepath
除了参数传递，有时候还会想让脚本的输出打印在控制台中，而不是文件中。
在IDA/python目录下，可以找到init.py
sys.stdout = sys.stderr = IDAPythonStdOut()
https://my.oschina.net/zengfr/blog/5592298
https://github.com/zengfr/romhack
https://gitee.com/zengfr/romhack
'''
def stdout_to_file(output_file_name, output_dir=None):
    '''Set stdout to a file descriptor

    param: output_file_name: name of the file where standard output is written.
    param: output_dir: output directory for output file, default to script directory.

    Returns: output file descriptor, original stdout descriptor
    '''
    # obtain this script path and build output path
    if not output_dir:
        output_dir = os.path.dirname(os.path.realpath(__file__))

    output_file_path = os.path.join(output_dir, output_file_name)

    # save original stdout descriptor
    orig_stdout = sys.stdout

    # create output file
    f = file(output_file_path, "w")

    # set stdout to output file descriptor
    sys.stdout = f

    return f, orig_stdout
def showEA():  
  print 'range:0x%x-0x%x'%(idc.MinEA(),idc.MaxEA())
  return
def append_comment(va, new_cmt, repeatable=False):
    """
    Append a comment to an address in IDA Pro.
    :param va: comment address
    :param new_cmt: comment string
    :param repeatable: if True, append as repeatable comment
    :return: True if success
    """
    cmt = idc.get_cmt(va, repeatable)
    if not cmt:
        # no existing comment
        cmt = new_cmt
    else:
        if new_cmt in cmt:
            # comment already exists
            return True
        cmt = cmt + "\n" + new_cmt
    return idc.set_cmt(va, cmt, repeatable) 
def process_all(start, end):
  len2=end-start;
  addr=start;
  flag = False
  rs=range((len2) / 4)
  for i in rs:
    addr = start + (i * 4)
    if idc.isCode(idc.GetFlags(addr)):
      old_comm = idc.get_cmt(addr, 0)
      if old_comm is not None:
        print "{:>8X} {:<32} {}".format(addr,idc.GetDisasm(addr),old_comm)
    else:
      flag = False
    #addr=idc.NextHead(addr)
  print("[*] process_all:{} {} {}".format(start, end,len(rs)))
def process(args):
    start = idc.MinEA()
    end=idc.MaxEA()
    process_all(start, end)
def main(args):
    # get original stdout and output file descriptor
    f, orig_stdout = stdout_to_file("ida-output.log")

    if idc.ARGV:
        for i, arg in enumerate(idc.ARGV):
            print("[*] arg[{}]: {}".format(i, arg))

    # call something from IDA (get the original input file name from IDB)
    print("[*] filename from IDB: {}".format(idaapi.get_root_filename()))
    showEA()
    process(args)
    showEA()
    print("[*] done, exiting.")

    # restore stdout, close output file
    sys.stdout = orig_stdout 
    f.close()

    # exit IDA
    idc.Exit(0)

if __name__ == "__main__":
    open("ida.log", 'w').close()
    print("py start")
    idc.Wait()
    main(sys.argv)
    idc.Exit(0)
    print("py end")